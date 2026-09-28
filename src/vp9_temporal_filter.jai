SUB_PEL_FILTERS_12_in_vp9_temporal_filter: [16] Interp_Kernel12 #align 256;

fixed_divide: [512] s32;

index_mult: [14] u32;

K_ZERO_MV: MV;

COUNT_TO_UPDATE_FACTOR_in_vp9_temporal_filter: [21] s32;

FRAME_SCALE_FACTOR_in_vp9_temporal_filter: [2] s32;

RATE_THRESH_MULT_in_vp9_temporal_filter: [2] float64;

RCF_MULT_in_vp9_temporal_filter: [2] float64;

K_VP9_REF_FLAG_LIST_in_vp9_temporal_filter: [4] s32;

clip_pixel_in_vp9_temporal_filter :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_temporal_filter :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_temporal_filter :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_temporal_filter :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_temporal_filter :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_temporal_filter(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_temporal_filter(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_temporal_filter(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_temporal_filter :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_lsb_in_vp9_temporal_filter :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_temporal_filter :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_temporal_filter :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_temporal_filter(num_values) + 1 else 0;
}

get_filter_taps_in_vp9_temporal_filter :: (FILTER: *s16) -> s32 {
    if (cast(s32) FILTER[0]) | cast(s32) FILTER[7] != 0 {
        return 8;
    }
    if (cast(s32) FILTER[1]) | cast(s32) FILTER[6] != 0 {
        return 6;
    }
    if (cast(s32) FILTER[2]) | cast(s32) FILTER[5] != 0 {
        return 4;
    }
    return 2;
}

vp9_temporal_filter_init :: () {
    fixed_divide[0] = 0;
    if 1 < 512 {
        for i: 1..cast(s32) 512 - 1 {
            fixed_divide[i] = 0x80000 / i;
        }
    }
}

vp9_temporal_filter :: (cpi: *VP9_COMP_in_vp9_encoder, distance: s32) {
    CM := *cpi.common;
    RC := *cpi.rc;
    XD := *cpi.td.mb.e_mbd;
    arnr_filter_data := *cpi.arnr_filter_data;

    frames_to_blur: s32 = ---;

    strength: s32 = ---;
    frames_to_blur_backward: s32 = ---;
    frames_to_blur_forward: s32 = ---;
    sf := *arnr_filter_data.sf;
    frames := arnr_filter_data.frames.data;

    adjust_arnr_filter(
        cpi,
        distance,
        RC.gfu_boost,
        *frames_to_blur,
        *frames_to_blur_backward,
        *frames_to_blur_forward,
        *strength
    );
    start_frame := distance + frames_to_blur_forward;

    arnr_filter_data.strength = strength;
    arnr_filter_data.frame_count = frames_to_blur;
    arnr_filter_data.alt_ref_index = frames_to_blur_backward;
    arnr_filter_data.dst = *cpi.tf_buffer;

    if 0 < frames_to_blur {
        for frame: 0..frames_to_blur - 1 {
            WHICH_BUFFER := start_frame - frame;
            buf := vp9_lookahead_peek(cpi.lookahead, WHICH_BUFFER);
            frames[frames_to_blur - 1 - frame] = *buf.img;
        }
    }

    f := frames[arnr_filter_data.alt_ref_index];
    XD.cur_buf = f;
    XD.plane[1].subsampling_y = f.subsampling_y;
    XD.plane[1].subsampling_x = f.subsampling_x;

    if frames_to_blur > 0 {
        if cpi.use_svc != 0 {
            frame_used: s32 = 0;

            vp9_setup_scale_factors_for_frame(
                sf,
                (get_frame_new_buffer_in_vp9_temporal_filter(CM)).y_crop_width,
                (get_frame_new_buffer_in_vp9_temporal_filter(CM)).y_crop_height,
                (get_frame_new_buffer_in_vp9_temporal_filter(CM)).y_crop_width,
                (get_frame_new_buffer_in_vp9_temporal_filter(CM)).y_crop_height
            );

            if 0 < frames_to_blur {
                for frame: 0..frames_to_blur - 1 {
                    if CM.mi_cols * (cast(s32) 1) << 3 != frames[frame].y_width || CM.mi_rows * (cast(s32) 1) << 3 != frames[frame].y_height {
                        if realloc_frame_buffer(
                            cpi.svc.scaled_frames.data + frame_used,
                            CM.width,
                            CM.height,
                            CM.subsampling_x,
                            CM.subsampling_y,
                            160,
                            CM.byte_alignment,
                            null,
                            null,
                            null
                        ) != 0 {
                            internal_error(
                                *CM.error,
                                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                                c_string("Failed to reallocate alt_ref_buffer")
                            );
                        }
                        frames[frame] =
                            vp9_scale_if_required(
                                CM,
                                frames[frame],
                                cpi.svc.scaled_frames.data + frame_used,
                                0,
                                0,
                                0
                            );
                        frame_used += 1;
                    }
                }
            }
            CM.mi = CM.mip + CM.mi_stride + 1;
            XD.mi = CM.mi_grid_visible;
            XD.mi[0] = CM.mi;
        } else {
            vp9_setup_scale_factors_for_frame(
                sf,
                frames[0].y_crop_width,
                frames[0].y_crop_height,
                frames[0].y_crop_width,
                frames[0].y_crop_height
            );
        }
    }

    rdmult := vp9_compute_rd_mult_based_on_qindex(cpi, 128);
    set_error_per_bit_in_vp9_temporal_filter(*cpi.td.mb, rdmult);
    vp9_initialize_me_consts(cpi, *cpi.td.mb, 128);

    if cpi.row_mt == 0 {
        temporal_filter_iterate_c(cpi);
    } else {
        vp9_temporal_filter_row_mt(cpi);
    }
}

temporal_filter_iterate_c :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    TILE_ROWS := (cast(s32) 1) << ((CM.log2_tile_rows) & 31);
    tile_col: s32 = ---;
    vp9_init_tile_data(cpi);

    if 0 < TILE_ROWS {
        for tile_row: 0..TILE_ROWS - 1 {
            tile_col = 0;
            while tile_col < TILE_COLS {
                temporal_filter_iterate_tile_c(cpi, tile_row, tile_col);
                tile_col += 1;
            }
        }
    }
}

temporal_filter_iterate_tile_c :: (cpi: *VP9_COMP_in_vp9_encoder, tile_row: s32, tile_col: s32) {
    CM := *cpi.common;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    tile_info := *cpi.tile_data[tile_row * TILE_COLS + tile_col].tile_info;
    MB_ROW_START := tile_info.mi_row_start >> 2;
    MB_ROW_END := (tile_info.mi_row_end + 3) >> 2;
    MB_COL_START := tile_info.mi_col_start >> 2;
    MB_COL_END := (tile_info.mi_col_end + 3) >> 2;

    mb_row := MB_ROW_START;
    while mb_row < MB_ROW_END {
        vp9_temporal_filter_iterate_row_c(cpi, *cpi.td, mb_row, MB_COL_START, MB_COL_END);
        mb_row += 1;
    }
}

vp9_temporal_filter_iterate_row_c :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    td: *Thread_Data_in_vp9_encoder,
    mb_row: s32,
    mb_col_start: s32,
    mb_col_end: s32
) {
    arnr_filter_data := *cpi.arnr_filter_data;
    frames := arnr_filter_data.frames.data;
    frame_count := arnr_filter_data.frame_count;
    alt_ref_index := arnr_filter_data.alt_ref_index;
    strength := arnr_filter_data.strength;
    scale := *arnr_filter_data.sf;

    frame: s32 = ---;

    mb_cols := (frames[alt_ref_index].y_crop_width + 32 - 1) >> 5;
    mb_rows := (frames[alt_ref_index].y_crop_height + 32 - 1) >> 5;
    accumulator: [3072] u32 = --- #align 16;
    count: [3072] u16 = --- #align 16;
    mbd := *td.mb.e_mbd;
    f := frames[alt_ref_index];
    dst := arnr_filter_data.dst;

    predictor: [3072] u8 = --- #align 16;

    MB_UV_HEIGHT := (cast(s32) 32) >> ((mbd.plane[1].subsampling_y) & 31);
    MB_UV_WIDTH := (cast(s32) 32) >> ((mbd.plane[1].subsampling_x) & 31);

    mb_y_offset := mb_row * 32 * f.y_stride + 32 * mb_col_start;
    mb_uv_offset := mb_row * MB_UV_HEIGHT * f.uv_stride + MB_UV_WIDTH * mb_col_start;

    td.mb.mv_limits.row_min = -(mb_row * 32 + (17 - cast,no_check(s32) ((2 * 6))));
    td.mb.mv_limits.row_max = (mb_rows - 1 - mb_row) * 32 + (17 - cast,no_check(s32) ((2 * 6)));

    mb_col := mb_col_start;
    while mb_col < mb_col_end {
        i, j, k: s32 = ---;

        ref_mv: MV = ---;

        fill_memory(accumulator.data, 0, cast,no_check(u64) ((cast,no_check(s32) ((32 * 32))) * 3) * size_of(u32));
        fill_memory(count.data, 0, cast,no_check(u64) ((cast,no_check(s32) ((32 * 32))) * 3) * size_of(u16));

        td.mb.mv_limits.col_min = -(mb_col * 32 + (17 - cast,no_check(s32) ((2 * 6))));
        td.mb.mv_limits.col_max = (mb_cols - 1 - mb_col) * 32 + (17 - cast,no_check(s32) ((2 * 6)));

        if cpi.oxcf.content == cast,no_check(u32) VP9E_CONTENT_FILM {
            src: Buf_2d = ---;

            src.buf = f.y_buffer + mb_y_offset;
            src.stride = f.y_stride;

            src_variance := vp9_get_sby_perpixel_variance(cpi, *src, 9);

            if src_variance <= 2 {
                strength = ifx 0 > arnr_filter_data.strength - 2 then 0 else arnr_filter_data.strength - 2;
            }
        }

        frame = 0;
        while frame < frame_count {
            blk_mvs: [4] MV = ---;

            blk_fw: [4] s32;
            use_32x32: s32 = 0;

            if frames[frame] == null {
                frame += 1;
                continue;
            }

            ref_mv.row = 0;
            ref_mv.col = 0;
            blk_mvs[0] = K_ZERO_MV;
            blk_mvs[1] = K_ZERO_MV;
            blk_mvs[2] = K_ZERO_MV;
            blk_mvs[3] = K_ZERO_MV;

            if frame == alt_ref_index {
                blk_fw[3] = 2;
                blk_fw[2] = blk_fw[3];
                blk_fw[1] = blk_fw[2];
                blk_fw[0] = blk_fw[1];
                use_32x32 = 1;
            } else {
                THRESH_LOW: s32 = 10000;
                THRESH_HIGH: s32 = 20000;
                blk_bestsme := s32.[ 2147483647, 2147483647, 2147483647, 2147483647 ];
                is_dc_diff_large: s32 = 0;

                err :=
                    cast,no_check(s32) temporal_filter_find_matching_mb_c(
                        cpi,
                        td,
                        frames[alt_ref_index].y_buffer + mb_y_offset,
                        frames[frame].y_buffer + mb_y_offset,
                        frames[frame].y_stride,
                        *ref_mv,
                        blk_mvs.data,
                        blk_bestsme.data,
                        *is_dc_diff_large
                    );

                if cpi.oxcf.enable_keyframe_filtering == 1 &&
                    cpi.common.frame_type == cast,no_check(u32) KEY_FRAME &&
                    is_dc_diff_large != 0 {
                    strength = ifx strength < 1 then strength else 1;
                }

                err16 := blk_bestsme[0] + blk_bestsme[1] + blk_bestsme[2] + blk_bestsme[3];
                max_err: s32 = cast,no_check(s32) ((-2147483647 - 1));
                min_err: s32 = 2147483647;
                k = 0;
                while k < 4 {
                    if min_err > blk_bestsme[k] {
                        min_err = blk_bestsme[k];
                    }
                    if max_err < blk_bestsme[k] {
                        max_err = blk_bestsme[k];
                    }
                    k += 1;
                }

                if err * 15 < err16 << 4 && max_err - min_err < 10000 || err * 14 < err16 << 4 && max_err - min_err < 5000 {
                    use_32x32 = 1;

                    blk_fw[0] = ifx err < THRESH_LOW << 2 then 2 else cast(s32) (err < THRESH_HIGH << 2);
                    blk_fw[3] = blk_fw[0];
                    blk_fw[2] = blk_fw[3];
                    blk_fw[1] = blk_fw[2];
                } else {
                    use_32x32 = 0;
                    k = 0;
                    while k < 4 {
                        blk_fw[k] =
                            ifx blk_bestsme[k] < THRESH_LOW then 2 else cast(s32) (blk_bestsme[k] < THRESH_HIGH);
                        k += 1;
                    }
                }

                k = 0;
                while k < 4 {
                    if absolute_value(frame - alt_ref_index) == {
                        case 1;
                            blk_fw[k] = ifx blk_fw[k] < 2 then blk_fw[k] else 2;
                        case 2; #through;
                        case 3;
                            blk_fw[k] = ifx blk_fw[k] < 1 then blk_fw[k] else 1;
                        case;
                    }
                    k += 1;
                }
            }

            if blk_fw[0] | blk_fw[1] | blk_fw[2] | blk_fw[3] != 0 {
                temporal_filter_predictors_mb_c(
                    mbd,
                    frames[frame].y_buffer + mb_y_offset,
                    frames[frame].u_buffer + mb_uv_offset,
                    frames[frame].v_buffer + mb_uv_offset,
                    frames[frame].y_stride,
                    MB_UV_WIDTH,
                    MB_UV_HEIGHT,
                    cast,no_check(s32) ref_mv.row,
                    cast,no_check(s32) ref_mv.col,
                    predictor.data,
                    scale,
                    mb_col * 32,
                    mb_row * 32,
                    blk_mvs.data,
                    use_32x32
                );

                vp9_apply_temporal_filter_c(
                    f.y_buffer + mb_y_offset,
                    f.y_stride,
                    predictor.data,
                    32,
                    f.u_buffer + mb_uv_offset,
                    f.v_buffer + mb_uv_offset,
                    f.uv_stride,
                    predictor.data + 32 * 32,
                    predictor.data + (cast,no_check(s32) ((32 * 32))) << 1,
                    MB_UV_WIDTH,
                    32,
                    32,
                    mbd.plane[1].subsampling_x,
                    mbd.plane[1].subsampling_y,
                    strength,
                    blk_fw.data,
                    use_32x32,
                    accumulator.data,
                    count.data,
                    accumulator.data + 32 * 32,
                    count.data + 32 * 32,
                    accumulator.data + (cast,no_check(s32) ((32 * 32))) << 1,
                    count.data + (cast,no_check(s32) ((32 * 32))) << 1
                );
            }
            frame += 1;
        }

        dst1 := dst.y_buffer;
        stride := dst.y_stride;
        byte := mb_y_offset;
        i = 0;
        k = 0;
        while i < 32 {
            j = 0;
            while j < 32 {
                pval: u32 = accumulator[k] + cast,no_check(u32) ((cast(s32) count[k]) >> 1);
                pval *= cast,no_check(u32) fixed_divide[count[k]];
                c_transpiler_compound_shr(*(pval), (cast(s32) 19), u32, u32);

                dst1[byte] = cast,no_check(u8) pval;

                byte += 1;
                j += 1;
                k += 1;
            }
            byte += stride - 32;
            i += 1;
        }

        dst1 = dst.u_buffer;
        dst2 := dst.v_buffer;
        stride = dst.uv_stride;
        byte = mb_uv_offset;
        i = 0;
        k = cast,no_check(s32) ((32 * 32));
        while i < MB_UV_HEIGHT {
            j = 0;
            while j < MB_UV_WIDTH {
                m := k + cast,no_check(s32) ((32 * 32));

                pval: u32 = accumulator[k] + cast,no_check(u32) ((cast(s32) count[k]) >> 1);
                pval *= cast,no_check(u32) fixed_divide[count[k]];
                c_transpiler_compound_shr(*(pval), (cast(s32) 19), u32, u32);
                dst1[byte] = cast,no_check(u8) pval;

                pval = accumulator[m] + cast,no_check(u32) ((cast(s32) count[m]) >> 1);
                pval *= cast,no_check(u32) fixed_divide[count[m]];
                c_transpiler_compound_shr(*(pval), (cast(s32) 19), u32, u32);
                dst2[byte] = cast,no_check(u8) pval;

                byte += 1;
                j += 1;
                k += 1;
            }
            byte += stride - MB_UV_WIDTH;
            i += 1;
        }

        mb_y_offset += 32;
        mb_uv_offset += MB_UV_WIDTH;
        mb_col += 1;
    }
}

vp9_apply_temporal_filter_c :: (
    y_frame1: *u8,
    y_stride: s32,
    y_pred: *u8,
    y_buf_stride: s32,
    u_frame1: *u8,
    v_frame1: *u8,
    uv_stride: s32,
    u_pred: *u8,
    v_pred: *u8,
    uv_buf_stride: s32,
    block_width: u32,
    block_height: u32,
    ss_x: s32,
    ss_y: s32,
    strength: s32,
    BLK_FW: *s32,
    use_32x32: s32,
    y_accumulator: *u32,
    y_count: *u16,
    u_accumulator: *u32,
    u_count: *u16,
    v_accumulator: *u32,
    v_count: *u16
) {
    j: u32 = ---;
    k: u32 = ---;
    m: u32 = ---;
    modifier: s32 = ---;
    ROUNDING := (cast(s32) 1) << ((strength) & 31) >> 1;
    UV_BLOCK_WIDTH := block_width >> ((ss_x) & 31);
    UV_BLOCK_HEIGHT := block_height >> ((ss_y) & 31);
    y_diff_sse: [1024] u16 = --- #align 16;
    u_diff_sse: [1024] u16 = --- #align 16;
    v_diff_sse: [1024] u16 = --- #align 16;

    idx: s32 = 0;
    idy: s32 = ---;

    fill_memory(y_diff_sse.data, 0, cast,no_check(u64) (32 * 32) * size_of(u16));
    fill_memory(u_diff_sse.data, 0, cast,no_check(u64) (32 * 32) * size_of(u16));
    fill_memory(v_diff_sse.data, 0, cast,no_check(u64) (32 * 32) * size_of(u16));

    i: u32 = 0;
    while i < block_height {
        j = 0;
        while j < block_width {
            DIFF :=
                cast,no_check(s16) ((cast(s32) y_frame1[(i * cast,no_check(u32) y_stride) + j]) -
                    cast(s32) y_pred[(i * cast,no_check(u32) (cast,no_check(s32) block_width)) + j]);
            y_diff_sse[idx] = cast,no_check(u16) ((cast(s32) DIFF) * cast(s32) DIFF);
            idx += 1;
            j += 1;
        }
        i += 1;
    }
    idx = 0;
    i = 0;
    while i < UV_BLOCK_HEIGHT {
        j = 0;
        while j < UV_BLOCK_WIDTH {
            DIFFU :=
                cast,no_check(s16) ((cast(s32) u_frame1[(i * cast,no_check(u32) uv_stride) + j]) -
                    cast(s32) u_pred[(i * cast,no_check(u32) uv_buf_stride) + j]);
            DIFFV :=
                cast,no_check(s16) ((cast(s32) v_frame1[(i * cast,no_check(u32) uv_stride) + j]) -
                    cast(s32) v_pred[(i * cast,no_check(u32) uv_buf_stride) + j]);
            u_diff_sse[idx] = cast,no_check(u16) ((cast(s32) DIFFU) * cast(s32) DIFFU);
            v_diff_sse[idx] = cast,no_check(u16) ((cast(s32) DIFFV) * cast(s32) DIFFV);
            idx += 1;
            j += 1;
        }
        i += 1;
    }

    i = 0;
    k = 0;
    m = 0;
    while i < block_height {
        j = 0;
        while j < block_width {
            PIXEL_VALUE := cast,no_check(s32) y_pred[(i * cast,no_check(u32) y_buf_stride) + j];
            FILTER_WEIGHT := get_filter_weight(i, j, block_height, block_width, BLK_FW, use_32x32);

            y_index: s32 = 0;

            UV_R := cast,no_check(s32) (i >> ((ss_y) & 31));
            UV_C := cast,no_check(s32) (j >> ((ss_x) & 31));
            modifier = 0;

            idy = -1;
            while idy <= 1 {
                idx = -1;
                while idx <= 1 {
                    ROW := (cast,no_check(s32) i) + idy;
                    COL := (cast,no_check(s32) j) + idx;

                    if ROW >= 0 && ROW < cast,no_check(s32) block_height && COL >= 0 && COL < cast,no_check(s32) block_width {
                        modifier += cast,no_check(s32) y_diff_sse[(ROW * cast,no_check(s32) block_width) + COL];
                        y_index += 1;
                    }
                    idx += 1;
                }
                idy += 1;
            }

            modifier +=
                cast,no_check(s32) u_diff_sse[(cast,no_check(u32) UV_R) * UV_BLOCK_WIDTH +
                    cast,no_check(u32) UV_C];
            modifier +=
                cast,no_check(s32) v_diff_sse[(cast,no_check(u32) UV_R) * UV_BLOCK_WIDTH +
                    cast,no_check(u32) UV_C];

            y_index += 2;

            modifier = mod_index(modifier, y_index, ROUNDING, strength, FILTER_WEIGHT);

            y_count[k] = cast,no_check(u16) ((cast,no_check(s32) y_count[k]) + modifier);
            y_accumulator[k] += cast,no_check(u32) (modifier * PIXEL_VALUE);

            k += 1;

            if i & cast,no_check(u32) ss_y == 0 && j & cast,no_check(u32) ss_x == 0 {
                U_PIXEL_VALUE := cast,no_check(s32) u_pred[UV_R * uv_buf_stride + UV_C];
                V_PIXEL_VALUE := cast,no_check(s32) v_pred[UV_R * uv_buf_stride + UV_C];

                cr_index: s32 = 0;
                u_mod: s32 = 0;
                v_mod: s32 = 0;
                y_diff: s32 = 0;

                idy = -1;
                while idy <= 1 {
                    idx = -1;
                    while idx <= 1 {
                        ROW := UV_R + idy;
                        COL := UV_C + idx;

                        if ROW >= 0 && ROW < cast,no_check(s32) UV_BLOCK_HEIGHT && COL >= 0 && COL < cast,no_check(s32) UV_BLOCK_WIDTH {
                            u_mod +=
                                cast,no_check(s32) u_diff_sse[(cast,no_check(u32) ROW) * UV_BLOCK_WIDTH +
                                    cast,no_check(u32) COL];
                            v_mod +=
                                cast,no_check(s32) v_diff_sse[(cast,no_check(u32) ROW) * UV_BLOCK_WIDTH +
                                    cast,no_check(u32) COL];
                            cr_index += 1;
                        }
                        idx += 1;
                    }
                    idy += 1;
                }

                idy = 0;
                while idy < 1 + ss_y {
                    idx = 0;
                    while idx < 1 + ss_x {
                        ROW := UV_R << ((ss_y) & 31) + idy;
                        COL := UV_C << ((ss_x) & 31) + idx;
                        y_diff += cast,no_check(s32) y_diff_sse[(ROW * cast,no_check(s32) block_width) + COL];
                        cr_index += 1;
                        idx += 1;
                    }
                    idy += 1;
                }

                u_mod += y_diff;
                v_mod += y_diff;

                u_mod = mod_index(u_mod, cr_index, ROUNDING, strength, FILTER_WEIGHT);
                v_mod = mod_index(v_mod, cr_index, ROUNDING, strength, FILTER_WEIGHT);

                u_count[m] = cast,no_check(u16) ((cast,no_check(s32) u_count[m]) + u_mod);
                u_accumulator[m] += cast,no_check(u32) (u_mod * U_PIXEL_VALUE);
                v_count[m] = cast,no_check(u16) ((cast,no_check(s32) v_count[m]) + v_mod);
                v_accumulator[m] += cast,no_check(u32) (v_mod * V_PIXEL_VALUE);

                m += 1;
            }
            j += 1;
        }
        i += 1;
    }
}

get_filter_weight :: (i: u32, j: u32, block_height: u32, block_width: u32, BLK_FW: *s32, use_32x32: s32) -> s32 {
    if use_32x32 != 0 {
        return BLK_FW[0];
    }

    if i < block_height / 2 {
        if j < block_width / 2 {
            return BLK_FW[0];
        }

        return BLK_FW[1];
    }

    if j < block_width / 2 {
        return BLK_FW[2];
    }

    return BLK_FW[3];
}

mod_index :: (sum_dist: s32, index: s32, rounding: s32, strength: s32, filter_weight: s32) -> s32 {
    mod :=
        cast,no_check(s32) (((cast,no_check(u32) clamp_in_vp9_temporal_filter(sum_dist, 0, 65535)) *
            index_mult[index]) >> 16);
    mod += rounding;
    c_transpiler_compound_shr(*(mod), (((strength) & 31)), s32, s32);

    mod = ifx 16 < mod then 16 else mod;

    mod = 16 - mod;
    mod *= filter_weight;

    return mod;
}

temporal_filter_predictors_mb_c :: (
    xd: *MACROBLOCKD,
    y_mb_ptr: *u8,
    u_mb_ptr: *u8,
    v_mb_ptr: *u8,
    stride: s32,
    uv_block_width: s32,
    uv_block_height: s32,
    mv_row: s32,
    mv_col: s32,
    pred: *u8,
    scale: *Scale_Factors,
    x: s32,
    y: s32,
    blk_mvs: *MV,
    use_32x32: s32
) {
    WHICH_MV: s32 = 0;
    KERNEL := SUB_PEL_FILTERS_12_in_vp9_temporal_filter.data;
    j: s32 = ---;
    k: s32 = 0;
    ys: s32 = (cast(s32) 32) >> 1;
    xs: s32 = (cast(s32) 32) >> 1;

    mv_precision_uv: Mv_Precision = ---;
    uv_stride: s32 = ---;
    if uv_block_width == (cast(s32) 32) >> 1 {
        uv_stride = (stride + 1) >> 1;
        mv_precision_uv = cast,no_check(Mv_Precision) MV_PRECISION_Q4;
    } else {
        uv_stride = stride;
        mv_precision_uv = cast,no_check(Mv_Precision) MV_PRECISION_Q3;
    }

    if use_32x32 != 0 {
        MV_ := MV.{row = cast,no_check(s16) mv_row, col = cast,no_check(s16) mv_col};

        vp9_build_inter_predictor_12(
            y_mb_ptr,
            stride,
            *pred[0],
            32,
            *MV_,
            scale,
            32,
            32,
            WHICH_MV,
            KERNEL,
            cast,no_check(Mv_Precision) MV_PRECISION_Q3,
            x,
            y
        );

        vp9_build_inter_predictor_12(
            u_mb_ptr,
            uv_stride,
            *pred[32 * 32],
            uv_block_width,
            *MV_,
            scale,
            uv_block_width,
            uv_block_height,
            WHICH_MV,
            KERNEL,
            mv_precision_uv,
            x,
            y
        );

        vp9_build_inter_predictor_12(
            v_mb_ptr,
            uv_stride,
            *pred[(cast,no_check(s32) ((32 * 32))) << 1],
            uv_block_width,
            *MV_,
            scale,
            uv_block_width,
            uv_block_height,
            WHICH_MV,
            KERNEL,
            mv_precision_uv,
            x,
            y
        );
        return;
    }

    i: s32 = 0;
    while i < 32 {
        j = 0;
        while j < 32 {
            MV_ := blk_mvs[k];
            Y_OFFSET := i * stride + j;
            P_OFFSET := i * 32 + j;

            vp9_build_inter_predictor_12(
                y_mb_ptr + Y_OFFSET,
                stride,
                *pred[P_OFFSET],
                32,
                *MV_,
                scale,
                xs,
                ys,
                WHICH_MV,
                KERNEL,
                cast,no_check(Mv_Precision) MV_PRECISION_Q3,
                x,
                y
            );

            k += 1;
            j += xs;
        }
        i += ys;
    }

    ys = uv_block_height >> 1;
    xs = uv_block_width >> 1;
    k = 0;

    i = 0;
    while i < uv_block_height {
        j = 0;
        while j < uv_block_width {
            MV_ := blk_mvs[k];
            UV_OFFSET := i * uv_stride + j;
            P_OFFSET := i * uv_block_width + j;

            vp9_build_inter_predictor_12(
                u_mb_ptr + UV_OFFSET,
                uv_stride,
                *pred[(cast,no_check(s32) ((32 * 32))) + P_OFFSET],
                uv_block_width,
                *MV_,
                scale,
                xs,
                ys,
                WHICH_MV,
                KERNEL,
                mv_precision_uv,
                x,
                y
            );

            vp9_build_inter_predictor_12(
                v_mb_ptr + UV_OFFSET,
                uv_stride,
                *pred[(cast,no_check(s32) ((32 * 32))) << 1 + P_OFFSET],
                uv_block_width,
                *MV_,
                scale,
                xs,
                ys,
                WHICH_MV,
                KERNEL,
                mv_precision_uv,
                x,
                y
            );

            k += 1;
            j += xs;
        }
        i += ys;
    }
}

vp9_build_inter_predictor_12 :: (
    src: *u8,
    src_stride: s32,
    dst: *u8,
    dst_stride: s32,
    src_mv: *MV,
    sf: *Scale_Factors,
    w: s32,
    h: s32,
    ref: s32,
    kernel: *Interp_Kernel12,
    precision: Mv_Precision,
    x: s32,
    y: s32
) {
    IS_Q4 := cast(s32) (precision == cast,no_check(u32) MV_PRECISION_Q4);
    MV_Q4 :=
        MV.{row = cast,no_check(s16) ((ifx IS_Q4 != 0 then cast,no_check(s32) src_mv.row else (cast(s32) src_mv.row) *
            2)), col = cast,no_check(s16) ((ifx IS_Q4 != 0 then cast,no_check(s32) src_mv.col else (cast(s32) src_mv.col) * 2))};
    mv := vp9_scale_mv(*MV_Q4, x, y, sf);
    SUBPEL_X: s32 = mv.col & ((cast(s32) 1) << 4 - 1);
    SUBPEL_Y: s32 = mv.row & ((cast(s32) 1) << 4 - 1);

    src += mv.row >> 4 * src_stride + mv.col >> 4;

    if SUBPEL_X == 0 && SUBPEL_Y == 0 {
        convolve_copy_c(
            src,
            cast,no_check(s64) src_stride,
            dst,
            cast,no_check(s64) dst_stride,
            null,
            SUBPEL_X,
            sf.x_step_q4,
            SUBPEL_Y,
            sf.y_step_q4,
            w,
            h
        );
    } else if SUBPEL_X == 0 && SUBPEL_Y != 0 {
        convolve12_vert_c(
            src,
            cast,no_check(s64) src_stride,
            dst,
            cast,no_check(s64) dst_stride,
            kernel,
            SUBPEL_X,
            sf.x_step_q4,
            SUBPEL_Y,
            sf.y_step_q4,
            w,
            h
        );
    } else if SUBPEL_X != 0 && SUBPEL_Y == 0 {
        convolve12_horiz_c(
            src,
            cast,no_check(s64) src_stride,
            dst,
            cast,no_check(s64) dst_stride,
            kernel,
            SUBPEL_X,
            sf.x_step_q4,
            SUBPEL_Y,
            sf.y_step_q4,
            w,
            h
        );
    } else {
        convolve12_c(
            src,
            cast,no_check(s64) src_stride,
            dst,
            cast,no_check(s64) dst_stride,
            kernel,
            SUBPEL_X,
            sf.x_step_q4,
            SUBPEL_Y,
            sf.y_step_q4,
            w,
            h
        );
    }
}

convolve12_c :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    filter: *Interp_Kernel12,
    x0_q4: s32,
    x_step_q4: s32,
    y0_q4: s32,
    y_step_q4: s32,
    w: s32,
    h: s32
) {
    temp: [1376] u8 = ---;
    TEMP_STRIDE: s32 = 32;
    INTERMEDIATE_HEIGHT := ((h - 1) * y_step_q4 + y0_q4) >> 4 + 12;

    convolve12_horiz_c(
        src - src_stride * cast,no_check(s64) ((cast,no_check(s32) ((12 / 2))) - 1),
        src_stride,
        temp.data,
        cast,no_check(s64) TEMP_STRIDE,
        filter,
        x0_q4,
        x_step_q4,
        y0_q4,
        y_step_q4,
        w,
        INTERMEDIATE_HEIGHT
    );
    convolve12_vert_c(
        temp.data + TEMP_STRIDE * ((cast,no_check(s32) ((12 / 2))) - 1),
        cast,no_check(s64) TEMP_STRIDE,
        dst,
        dst_stride,
        filter,
        x0_q4,
        x_step_q4,
        y0_q4,
        y_step_q4,
        w,
        h
    );
}

convolve12_vert_c :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    filter: *Interp_Kernel12,
    x0_q4: s32,
    x_step_q4: s32,
    y0_q4: s32,
    y_step_q4: s32,
    w: s32,
    h: s32
) {
    y: s32 = ---;
    src -= src_stride * cast,no_check(s64) ((cast,no_check(s32) ((12 / 2))) - 1);

    if 0 < w {
        for x: 0..w - 1 {
            y_q4 := y0_q4;
            y = 0;
            while y < h {
                src_y := *src[(cast(s64) (y_q4 >> 4)) * src_stride];
                Y_FILTER := filter[y_q4 & ((cast(s32) 1) << 4 - 1)].data;
                sum: s32 = 0;
                for k: 0..cast(s32) 12 - 1 {
                    sum += (cast(s32) src_y[(cast(s64) k) * src_stride]) * cast(s32) Y_FILTER[k];
                }
                dst[(cast(s64) y) * dst_stride] =
                    clip_pixel_in_vp9_temporal_filter(
                        (sum + (cast(s32) 1) << (((7 - 1)) & 31)) >> 7
                    );
                y_q4 += y_step_q4;
                y += 1;
            }
            src += 1;
            dst += 1;
        }
    }
}

convolve12_horiz_c :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    filter: *Interp_Kernel12,
    x0_q4: s32,
    x_step_q4: s32,
    y0_q4: s32,
    y_step_q4: s32,
    w: s32,
    h: s32
) {
    x: s32 = ---;
    src -= (cast,no_check(s32) ((12 / 2))) - 1;

    if 0 < h {
        for y: 0..h - 1 {
            x_q4 := x0_q4;
            x = 0;
            while x < w {
                SRC_X := *src[x_q4 >> 4];
                X_FILTER := filter[x_q4 & ((cast(s32) 1) << 4 - 1)].data;
                sum: s32 = 0;
                for k: 0..cast(s32) 12 - 1 {
                    sum += (cast(s32) SRC_X[k]) * cast(s32) X_FILTER[k];
                }
                dst[x] = clip_pixel_in_vp9_temporal_filter((sum + (cast(s32) 1) << (((7 - 1)) & 31)) >> 7);
                x_q4 += x_step_q4;
                x += 1;
            }
            src += src_stride;
            dst += dst_stride;
        }
    }
}

temporal_filter_find_matching_mb_c :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    td: *Thread_Data_in_vp9_encoder,
    arf_frame_buf: *u8,
    frame_ptr_buf: *u8,
    stride: s32,
    ref_mv: *MV,
    blk_mvs: *MV,
    blk_bestsme: *s32,
    is_dc_diff_large: *s32
) -> u32 {
    X := *td.mb;
    XD := *X.e_mbd;
    MV_SF := *cpi.sf.mv;
    SEARCH_METHOD := cast,no_check(SEARCH_METHODS_in_vp9_cx_iface) MESH;
    SEARCH_METHOD_16 := cpi.sf.temporal_filter_search_method;

    sadpb := X.sadperbit16;
    bestsme: u32 = U32_MAX;
    distortion: u32 = ---;
    sse: u32 = ---;
    cost_list: [5] s32 = ---;
    TMP_MV_LIMITS := X.mv_limits;

    best_ref_mv1: MV;
    best_ref_mv1_full: MV = ---;

    src := X.plane[0].src;
    pre := XD.plane[0].pre[0];
    j: s32 = ---;
    k: s32 = 0;

    best_ref_mv1_full.col = cast,no_check(s16) ((cast(s32) best_ref_mv1.col) >> 3);
    best_ref_mv1_full.row = cast,no_check(s16) ((cast(s32) best_ref_mv1.row) >> 3);

    X.plane[0].src.buf = arf_frame_buf;
    X.plane[0].src.stride = stride;
    XD.plane[0].pre[0].buf = frame_ptr_buf;
    XD.plane[0].pre[0].stride = stride;
    is_dc_diff_large.* = 0;

    step_param := MV_SF.reduce_first_step_size;
    step_param = ifx step_param < 11 - 2 then step_param else cast,no_check(s32) ((11 - 2));

    vp9_set_mv_search_range(*X.mv_limits, *best_ref_mv1);

    vp9_full_pixel_search(
        cpi,
        X,
        9,
        *best_ref_mv1_full,
        step_param,
        cast,no_check(s32) SEARCH_METHOD,
        sadpb,
        cond_cost_list_in_vp9_temporal_filter(cpi, cost_list.data),
        *best_ref_mv1,
        ref_mv,
        0,
        0
    );

    X.mv_limits = TMP_MV_LIMITS;

    bestsme =
        cpi.find_fractional_mv_step(
            X,
            ref_mv,
            *best_ref_mv1,
            cpi.common.allow_high_precision_mv,
            X.errorperbit,
            cpi.fn_ptr.data + 9,
            0,
            MV_SF.subpel_search_level,
            cond_cost_list_in_vp9_temporal_filter(cpi, cost_list.data),
            null,
            null,
            *distortion,
            *sse,
            null,
            32,
            32,
            cast,no_check(s32) (USE_8_TAPS_SHARP)
        );
    is_dc_diff_large.* = cast(s32) (50 * bestsme < sse);

    best_ref_mv1.row = ref_mv.row;
    best_ref_mv1.col = ref_mv.col;
    best_ref_mv1_full.col = cast,no_check(s16) ((cast(s32) best_ref_mv1.col) >> 3);
    best_ref_mv1_full.row = cast,no_check(s16) ((cast(s32) best_ref_mv1.row) >> 3);

    i: s32 = 0;
    while i < 32 {
        j = 0;
        while j < 32 {
            X.plane[0].src.buf = arf_frame_buf + i * stride + j;
            X.plane[0].src.stride = stride;
            XD.plane[0].pre[0].buf = frame_ptr_buf + i * stride + j;
            XD.plane[0].pre[0].stride = stride;

            vp9_set_mv_search_range(*X.mv_limits, *best_ref_mv1);
            vp9_full_pixel_search(
                cpi,
                X,
                6,
                *best_ref_mv1_full,
                step_param,
                cast,no_check(s32) SEARCH_METHOD_16,
                sadpb,
                cond_cost_list_in_vp9_temporal_filter(cpi, cost_list.data),
                *best_ref_mv1,
                *blk_mvs[k],
                0,
                0
            );

            X.mv_limits = TMP_MV_LIMITS;

            blk_bestsme[k] =
                cast,no_check(s32) cpi.find_fractional_mv_step(
                    X,
                    *blk_mvs[k],
                    *best_ref_mv1,
                    cpi.common.allow_high_precision_mv,
                    X.errorperbit,
                    cpi.fn_ptr.data + 6,
                    0,
                    MV_SF.subpel_search_level,
                    cond_cost_list_in_vp9_temporal_filter(cpi, cost_list.data),
                    null,
                    null,
                    *distortion,
                    *sse,
                    null,
                    16,
                    16,
                    cast,no_check(s32) (USE_8_TAPS_SHARP)
                );
            k += 1;
            j += 16;
        }
        i += 16;
    }

    X.plane[0].src = src;
    XD.plane[0].pre[0] = pre;

    return bestsme;
}

cond_cost_list_in_vp9_temporal_filter :: (cpi: *VP9_COMP_in_vp9_encoder, cost_list: *s32) -> *s32 {
    return ifx cpi.sf.mv.subpel_search_method != cast,no_check(u32) SUBPEL_TREE then cost_list else null;
}

set_error_per_bit_in_vp9_temporal_filter :: (x: *MACROBLOCK, rdmult: s32) {
    x.errorperbit = rdmult >> 6;
    x.errorperbit += cast(s32) (x.errorperbit == 0);
}

get_frame_new_buffer_in_vp9_temporal_filter :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

adjust_arnr_filter :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    distance: s32,
    group_boost: s32,
    arnr_frames: *s32,
    frames_backward: *s32,
    frames_forward: *s32,
    arnr_strength: *s32
) {
    OXCF := *cpi.oxcf;

    max_fwd :=
        (ifx (cast,no_check(s32) vp9_lookahead_depth(cpi.lookahead)) - distance -
            1 > 0 then (cast,no_check(s32) vp9_lookahead_depth(cpi.lookahead)) - distance - 1 else 0);
    max_bwd := (ifx distance > 0 then distance else 0);
    frames := (ifx OXCF.arnr_max_frames > 1 then OXCF.arnr_max_frames else 1);
    base_strength: s32 = ---;
    strength: s32 = ---;

    if OXCF.pass == 2 {
        base_strength = OXCF.arnr_strength + cpi.twopass.arnr_strength_adjustment;

        base_strength = clamp_in_vp9_temporal_filter(base_strength, 0, 6);
    } else {
        base_strength = OXCF.arnr_strength;
    }

    q: s32 = ifx cpi.common.current_video_frame > 1
        then cast,no_check(s32) vp9_convert_qindex_to_q(cpi.rc.avg_frame_qindex[INTER_FRAME], cpi.common.bit_depth)
        else cast,no_check(s32) vp9_convert_qindex_to_q(cpi.rc.avg_frame_qindex[KEY_FRAME], cpi.common.bit_depth);
    if q > 16 {
        strength = base_strength;
    } else {
        strength = base_strength - (16 - q) / 2;
        if strength < 0 {
            strength = 0;
        }
    }

    frames = ifx frames < group_boost / 150 then frames else group_boost / 150;

    if strength > group_boost / 300 {
        strength = group_boost / 300;
    }

    if min(max_fwd, max_bwd) >= frames / 2 {
        frames_backward.* = frames / 2;
        frames_forward.* = (frames - 1) / 2;
    } else if max_fwd < frames / 2 {
        frames_forward.* = max_fwd;
        frames_backward.* = ifx frames - 1 - frames_forward.* < max_bwd then frames - 1 - frames_forward.* else max_bwd;
    } else {
        frames_backward.* = max_bwd;
        frames_forward.* =
            ifx frames - 1 - frames_backward.* < max_fwd then frames -
                1 - frames_backward.* else max_fwd;
    }

    frames = frames_backward.* + 1 + frames_forward.*;

    if frames <= 1 {
        frames = 1;
        frames_backward.* = 0;
        frames_forward.* = 0;
    }

    arnr_frames.* = frames;
    arnr_strength.* = strength;
}

get_prob_in_vp9_temporal_filter :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_temporal_filter :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_temporal_filter(n0, DEN);
}

weighted_prob_in_vp9_temporal_filter :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_temporal_filter :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_temporal_filter(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_temporal_filter(
        cast,no_check(s32) pre_prob,
        cast,no_check(s32) PROB,
        cast,no_check(s32) FACTOR
    );
}

mode_mv_merge_probs_in_vp9_temporal_filter :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_temporal_filter[COUNT];
        PROB := get_prob_in_vp9_temporal_filter(ct[0], DEN);
        return weighted_prob_in_vp9_temporal_filter(
            cast,no_check(s32) pre_prob,
            cast,no_check(s32) PROB,
            cast,no_check(s32) FACTOR
        );
    }
}

get_band_translate_in_vp9_temporal_filter :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_temporal_filter :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_temporal_filter :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
    above_ec: ENTROPY_CONTEXT = 0;
    left_ec: ENTROPY_CONTEXT = 0;

    if cast,no_check(s32) tx_size == {
        case cast,no_check(s32) cast(TX_SIZE) 0;
            above_ec = cast(ENTROPY_CONTEXT) (a[0] != 0);
            left_ec = cast(ENTROPY_CONTEXT) (l[0] != 0);
        case cast,no_check(s32) cast(TX_SIZE) 1;
            above_ec = cast(ENTROPY_CONTEXT) (((cast(*u16) a).*) != 0);
            left_ec = cast(ENTROPY_CONTEXT) (((cast(*u16) l).*) != 0);
        case cast,no_check(s32) cast(TX_SIZE) 2;
            above_ec = cast(ENTROPY_CONTEXT) (((cast(*u32) a).*) != 0);
            left_ec = cast(ENTROPY_CONTEXT) (((cast(*u32) l).*) != 0);
        case cast,no_check(s32) cast(TX_SIZE) 3;
            above_ec = cast(ENTROPY_CONTEXT) (((cast(*u64) a).*) != 0);
            left_ec = cast(ENTROPY_CONTEXT) (((cast(*u64) l).*) != 0);
        case;
    }

    return combine_entropy_contexts_in_vp9_temporal_filter(above_ec, left_ec);
}

is_zero_mv_in_vp9_temporal_filter :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_temporal_filter :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_temporal_filter :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_temporal_filter(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_temporal_filter(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_temporal_filter :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_temporal_filter :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_temporal_filter :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_temporal_filter :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

vp9_is_valid_scale_in_vp9_temporal_filter :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_temporal_filter :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_temporal_filter(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_temporal_filter :: (
    ref_width: s32,
    ref_height: s32,
    this_width: s32,
    this_height: s32
) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_temporal_filter :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_temporal_filter :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_temporal_filter :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_temporal_filter :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_temporal_filter :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_temporal_filter :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_temporal_filter :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_temporal_filter :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_temporal_filter :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_temporal_filter :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_temporal_filter(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_temporal_filter :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_temporal_filter(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_temporal_filter(MI, ib)];
}

get_uv_tx_size_in_vp9_temporal_filter :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_temporal_filter :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_temporal_filter :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_temporal_filter(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_temporal_filter :: (
    mi: *MODE_INFO,
    above_mi: *MODE_INFO,
    left_mi: *MODE_INFO,
    block: s32
) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_temporal_filter :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_temporal_filter :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_temporal_filter :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_temporal_filter :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
    frame_info.frame_width = cm.width;
    frame_info.frame_height = cm.height;
    frame_info.render_frame_width = cm.render_width;
    frame_info.render_frame_height = cm.render_height;
    frame_info.mi_cols = cm.mi_cols;
    frame_info.mi_rows = cm.mi_rows;
    frame_info.mb_cols = cm.mb_cols;
    frame_info.mb_rows = cm.mb_rows;
    frame_info.num_mbs = cm.m_bs;
    frame_info.bit_depth = cm.bit_depth;
}

get_buf_frame_in_vp9_temporal_filter :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_temporal_filter :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_free_fb_in_vp9_temporal_filter :: (cm: *VP9_COMMON) -> s32 {
    FRAME_BUFS := cm.buffer_pool.frame_bufs.data;

    i: s32 = 0;
    while i < (cast(s32) 1) << 3 + 1 + 3 {
        if FRAME_BUFS[i].ref_count == 0 {
            break;
        }
        i += 1;
    }

    if i != (cast(s32) 1) << 3 + 1 + 3 {
        FRAME_BUFS[i].ref_count = 1;
    } else {
        i = -1;
    }

    return i;
}

ref_cnt_fb_in_vp9_temporal_filter :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_temporal_filter :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_temporal_filter :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_temporal_filter :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_temporal_filter(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_temporal_filter :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_temporal_filter(cm.mi_cols);

        if get_plane_type_in_vp9_temporal_filter(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_temporal_filter(cm, xd);
}

get_partition_probs_in_vp9_temporal_filter :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_temporal_filter :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_temporal_filter :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_temporal_filter :: (
    xd: *MACROBLOCKD,
    TILE: *Tile_Info,
    mi_row: s32,
    bh: s32,
    mi_col: s32,
    bw: s32,
    mi_rows: s32,
    mi_cols: s32
) {
    xd.mb_to_top_edge = -(mi_row * (cast(s32) 1) << 3 * 8);
    xd.mb_to_bottom_edge = (mi_rows - bh - mi_row) * (cast(s32) 1) << 3 * 8;
    xd.mb_to_left_edge = -(mi_col * (cast(s32) 1) << 3 * 8);
    xd.mb_to_right_edge = (mi_cols - bw - mi_col) * (cast(s32) 1) << 3 * 8;

    xd.above_mi = ifx mi_row != 0 then xd.mi[-xd.mi_stride] else null;
    xd.left_mi = ifx mi_col > TILE.mi_col_start then xd.mi[-1] else null;
}

update_partition_context_in_vp9_temporal_filter :: (
    xd: *MACROBLOCKD,
    mi_row: s32,
    mi_col: s32,
    subsize: BLOCK_SIZE,
    bsize: BLOCK_SIZE
) {
    ABOVE_CTX := xd.above_seg_context + mi_col;
    LEFT_CTX := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);

    BS := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize];

    fill_memory(ABOVE_CTX, cast,no_check(s32) PARTITION_CONTEXT_LOOKUP[subsize].above, cast,no_check(u64) BS);
    fill_memory(LEFT_CTX, cast,no_check(s32) PARTITION_CONTEXT_LOOKUP[subsize].left, cast,no_check(u64) BS);
}

partition_plane_context_in_vp9_temporal_filter :: (
    xd: *MACROBLOCKD,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE
) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

inter_predictor_in_vp9_temporal_filter :: (
    src: *u8,
    src_stride: s32,
    dst: *u8,
    dst_stride: s32,
    SUBPEL_X: s32,
    SUBPEL_Y: s32,
    sf: *Scale_Factors,
    w: s32,
    h: s32,
    ref: s32,
    kernel: *Interp_Kernel,
    xs: s32,
    ys: s32
) {
    (cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s64, _: *Interp_Kernel, _: s32, _: s32, _: s32, _: s32, _: s32, _: s32)) (cast(*void) sf.predict[cast(s32) (SUBPEL_X != 0)][cast(s32) (SUBPEL_Y != 0)][ref]))(
        src,
        cast,no_check(s64) src_stride,
        dst,
        cast,no_check(s64) dst_stride,
        kernel,
        SUBPEL_X,
        xs,
        SUBPEL_Y,
        ys,
        w,
        h
    );
}

scaled_buffer_offset_in_vp9_temporal_filter :: (x_offset: s32, y_offset: s32, stride: s32, sf: *Scale_Factors) -> s64 {
    X := (ifx sf != null then sf.scale_value_x(x_offset, sf) else x_offset);
    Y := (ifx sf != null then sf.scale_value_y(y_offset, sf) else y_offset);
    return ((cast,no_check(s64) Y) * cast(s64) stride) + cast(s64) X;
}

setup_pred_plane_in_vp9_temporal_filter :: (
    dst: *Buf_2d,
    src: *u8,
    stride: s32,
    mi_row: s32,
    mi_col: s32,
    scale: *Scale_Factors,
    subsampling_x: s32,
    subsampling_y: s32
) {
    X := ((cast(s32) 1) << 3 * mi_col) >> ((subsampling_x) & 31);
    Y := ((cast(s32) 1) << 3 * mi_row) >> ((subsampling_y) & 31);
    dst.buf = src + scaled_buffer_offset_in_vp9_temporal_filter(X, Y, stride, scale);
    dst.stride = stride;
}

fps_init_first_pass_info_in_vp9_temporal_filter :: (
    first_pass_info: *FIRST_PASS_INFO,
    stats: *FIRSTPASS_STATS_in_vp9_cx_iface,
    num_frames: s32
) {
    first_pass_info.stats = stats;
    first_pass_info.num_frames = num_frames;
}

fps_get_num_frames_in_vp9_temporal_filter :: (first_pass_info: *FIRST_PASS_INFO) -> s32 {
    return first_pass_info.num_frames;
}

fps_get_frame_stats_in_vp9_temporal_filter :: (
    first_pass_info: *FIRST_PASS_INFO,
    show_idx: s32
) -> *FIRSTPASS_STATS_in_vp9_cx_iface {
    if show_idx < 0 || show_idx >= first_pass_info.num_frames {
        return null;
    }
    return *(cast(*FIRSTPASS_STATS_in_vp9_cx_iface) (first_pass_info.stats))[show_idx];
}

get_buf_from_mv_in_vp9_temporal_filter :: (buf: *Buf_2d, mv: *MV) -> *u8 {
    return *buf.buf[(cast(s32) mv.row) * buf.stride + cast(s32) mv.col];
}

vp8_set_reference_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_vp9_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

gcd_in_vp9_temporal_filter :: (a: s64, b: s32) -> s32 {
    while b != 0 {
        r := cast,no_check(s32) (a % cast(s64) b);
        a = cast,no_check(s64) b;
        b = r;
    }

    return cast,no_check(s32) a;
}

reduce_ratio_in_vp9_temporal_filter :: (ratio: *Rational64_T) {
    DENOM := gcd_in_vp9_temporal_filter(ratio.num, ratio.den);
    ratio.num /= cast,no_check(s64) DENOM;
    ratio.den /= DENOM;
}

cyclic_refresh_segment_id_boosted_in_vp9_temporal_filter :: (segment_id: s32) -> s32 {
    if segment_id == 1 || segment_id == 2 {
        return 1;
    }
    return 0;
}

cyclic_refresh_segment_id_in_vp9_temporal_filter :: (segment_id: s32) -> s32 {
    if segment_id == 1 {
        return 1;
    } else if segment_id == 2 {
        return 2;
    } else {
        return 0;
    }
}

cost_branch256_in_vp9_temporal_filter :: (ct: *u32, p: Prob) -> u64 {
    return ((cast,no_check(u64) ct[0]) * cast(u64) VP9_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP9_PROB_COST[256 - cast(s32) p];
}

treed_cost_in_vp9_temporal_filter :: (tree: *Tree_Index, probs: *Prob, bits: s32, len: s32) -> s32 {
    cost: s32 = 0;
    i: Tree_Index = 0;

    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            cost +=
                cast,no_check(s32) (VP9_PROB_COST[(ifx BIT != 0 then 256 -
                    cast(s32) probs[(cast(s32) i) >> 1] else cast,no_check(s32) probs[(cast(s32) i) >> 1])]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }

    return cost;
}

rd_less_than_thresh_in_vp9_temporal_filter :: (best_rd: s64, thresh: s32, THRESH_FACT: *s32) -> s32 {
    if best_rd < ((cast,no_check(s64) thresh) * cast(s64) THRESH_FACT.*) >> 5 || thresh == 2147483647 {
        return 1;
    }
    return 0;
}

write_in_vp9_temporal_filter :: (br: *Writer, bit: s32, probability: s32) {
    count := br.count;
    range := br.range;
    lowvalue := br.lowvalue;

    split := 1 + ((range - 1) * cast,no_check(u32) probability) >> 8;

    range = split;

    if bit != 0 {
        lowvalue += split;
        range = br.range - split;
    }

    shift := cast,no_check(s32) NORM[range];

    c_transpiler_compound_shl(*(range), (((cast,no_check(u32) shift) & 31)), u32, u32);
    count += shift;

    if count >= 0 {
        offset := shift - count;

        if br.error == 0 {
            if lowvalue << (((offset - 1)) & 31) & 0x80000000 != 0 {
                x := (cast,no_check(s32) br.pos) - 1;

                while x >= 0 && br.buffer[x] == 0xff {
                    br.buffer[x] = 0;
                    x -= 1;
                }

                br.buffer[x] = cast,no_check(u8) ((cast,no_check(s32) br.buffer[x]) + 1);
            }

            if br.pos < br.size {
                br.buffer[br.pos] = cast,no_check(u8) (lowvalue >> (((24 - offset)) & 31) & 0xff);
                br.pos += 1;
            } else {
                br.error = 1;
            }
        }
        c_transpiler_compound_shl(*(lowvalue), (((cast,no_check(u32) offset) & 31)), u32, u32);
        shift = count;
        lowvalue &= 0xffffff;
        count -= 8;
    }

    c_transpiler_compound_shl(*(lowvalue), (((cast,no_check(u32) shift) & 31)), u32, u32);
    br.count = count;
    br.lowvalue = lowvalue;
    br.range = range;
}

write_bit_in_vp9_temporal_filter :: (w: *Writer, bit: s32) {
    write_in_vp9_temporal_filter(w, bit, 128);
}

write_literal_in_vp9_temporal_filter :: (w: *Writer, data: s32, bits: s32) {
    bit := bits - 1;
    while bit >= 0 {
        write_bit_in_vp9_temporal_filter(w, 1 & (data >> ((bit) & 31)));
        bit -= 1;
    }
}

vp9_write_tree_in_vp9_temporal_filter :: (
    w: *Writer,
    tree: *Tree_Index,
    probs: *Prob,
    bits: s32,
    len: s32,
    i: Tree_Index
) {
    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            write_in_vp9_temporal_filter(w, BIT, cast,no_check(s32) probs[(cast(s32) i) >> 1]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }
}

vp9_write_token_in_vp9_temporal_filter :: (w: *Writer, tree: *Tree_Index, probs: *Prob, token: *Vp9_Token) {
    vp9_write_tree_in_vp9_temporal_filter(w, tree, probs, token.value, token.len, 0);
}

vp9_get_high_cost_table_in_vp9_temporal_filter :: (bit_depth: s32) -> *u16 {
    return VP9_CAT6_HIGH_COST.data;
}

vp9_get_token_extra_in_vp9_temporal_filter :: (v: s32, token: *s16, extra: *EXTRABIT) {
    if v >= 67 || v <= -67 {
        token.* = 10;
        if v >= 67 {
            extra.* = cast,no_check(EXTRABIT) (2 * v - cast,no_check(s32) ((2 * 67)));
        } else {
            extra.* = cast,no_check(EXTRABIT) ((-2 * v - cast,no_check(s32) ((2 * 67))) + 1);
        }
        return;
    }
    token.* = vp9_dct_cat_lt_10_value_tokens[v].token;
    extra.* = vp9_dct_cat_lt_10_value_tokens[v].extra;
}

vp9_get_token_in_vp9_temporal_filter :: (v: s32) -> s16 {
    if v >= 67 || v <= -67 {
        return 10;
    }
    return vp9_dct_cat_lt_10_value_tokens[v].token;
}

vp9_get_token_cost_in_vp9_temporal_filter :: (v: s32, token: *s16, cat6_high_table: *u16) -> s32 {
    if v >= 67 || v <= -67 {
        token.* = 10;
        extrabits := cast,no_check(EXTRABIT) (absolute_value(v) - 67);
        return (cast(s32) VP9_CAT6_LOW_COST[extrabits & 0xff]) + cast(s32) cat6_high_table[(cast(s32) extrabits) >> 8];
    }
    token.* = vp9_dct_cat_lt_10_value_tokens[v].token;
    return vp9_dct_cat_lt_10_value_cost[v];
}

is_lossless_requested_in_vp9_temporal_filter :: (cfg: *VP9_Encoder_Config) -> s32 {
    if cfg.best_allowed_q == 0 && cfg.worst_allowed_q == 0 {
        return 1;
    }
    return 0;
}

stack_pop_in_vp9_temporal_filter :: (stack: *s32, stack_size: s32) -> s32 {
    R := stack[0];
    if 1 < stack_size {
        for idx: 1..stack_size - 1 {
            stack[idx - 1] = stack[idx];
        }
    }

    return R;
}

stack_top_in_vp9_temporal_filter :: (stack: *s32) -> s32 {
    return stack[0];
}

stack_push_in_vp9_temporal_filter :: (stack: *s32, new_item: s32, stack_size: s32) {
    idx := stack_size;
    while idx > 0 {
        stack[idx] = stack[idx - 1];
        idx -= 1;
    }
    stack[0] = new_item;
}

stack_init_in_vp9_temporal_filter :: (stack: *s32, length: s32) {
    if 0 < length {
        for idx: 0..length - 1 {
            stack[idx] = -1;
        }
    }
}

frame_is_kf_gf_arf_in_vp9_temporal_filter :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if frame_is_intra_only_in_vp9_temporal_filter(*cpi.common) != 0 ||
        cpi.refresh_alt_ref_frame != 0 ||
        cpi.refresh_golden_frame != 0 && cpi.rc.is_src_frame_alt_ref == 0 {
        return 1;
    }
    return 0;
}

ref_frame_to_flag_in_vp9_temporal_filter :: (ref_frame: s8) -> s32 {

    return K_VP9_REF_FLAG_LIST_in_vp9_temporal_filter[ref_frame];
}

get_ref_frame_map_idx_in_vp9_temporal_filter :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame: MV_REFERENCE_FRAME) -> s32 {
    if ref_frame == 1 {
        return cpi.lst_fb_idx;
    } else if ref_frame == 2 {
        return cpi.gld_fb_idx;
    } else {
        return cpi.alt_fb_idx;
    }
}

get_ref_frame_buf_idx_in_vp9_temporal_filter :: (CPI: *VP9_COMP_in_vp9_encoder, ref_frame: s32) -> s32 {
    CM := *CPI.common;
    MAP_IDX := get_ref_frame_map_idx_in_vp9_temporal_filter(CPI, cast,no_check(MV_REFERENCE_FRAME) ref_frame);
    return ifx MAP_IDX != -1 then CM.ref_frame_map[MAP_IDX] else -1;
}

get_ref_cnt_buffer_in_vp9_temporal_filter :: (cm: *VP9_COMMON, fb_idx: s32) -> *Ref_Cnt_Buffer {
    return ifx fb_idx != -1 then cm.buffer_pool.frame_bufs.data + fb_idx else null;
}

get_ref_frame_bufs_in_vp9_temporal_filter :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame_bufs: **Ref_Cnt_Buffer) {
    CM := *cpi.common;

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame < 4 {
        ref_frame_buf_idx := get_ref_frame_buf_idx_in_vp9_temporal_filter(cpi, cast,no_check(s32) ref_frame);
        inter_ref_idx := mv_ref_frame_to_inter_ref_idx_in_vp9_temporal_filter(ref_frame);
        ref_frame_bufs[inter_ref_idx] = get_ref_cnt_buffer_in_vp9_temporal_filter(CM, ref_frame_buf_idx);
        ref_frame += 1;
    }
}

get_ref_frame_buffer_in_vp9_temporal_filter :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    ref_frame: MV_REFERENCE_FRAME
) -> *YV12_BUFFER_CONFIG {
    CM := *CPI.common;
    BUF_IDX := get_ref_frame_buf_idx_in_vp9_temporal_filter(CPI, cast,no_check(s32) ref_frame);
    return ifx BUF_IDX != -1 then *CM.buffer_pool.frame_bufs[BUF_IDX].buf else null;
}

get_token_alloc_in_vp9_temporal_filter :: (mb_rows: s32, mb_cols: s32) -> s64 {
    ALIGNED_MB_ROWS :=
        (mb_rows +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    ALIGNED_MB_COLS :=
        (mb_cols +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    return ((cast,no_check(s64) ALIGNED_MB_ROWS) * cast(s64) ALIGNED_MB_COLS) * cast,no_check(s64) ((cast,no_check(s32) ((16 * 16))) * 3 + 4);
}

allocated_tokens_in_vp9_temporal_filter :: (tile: Tile_Info) -> s64 {
    tile_mb_rows := (tile.mi_row_end - tile.mi_row_start + 1) >> 1;
    tile_mb_cols := (tile.mi_col_end - tile.mi_col_start + 1) >> 1;

    return get_token_alloc_in_vp9_temporal_filter(tile_mb_rows, tile_mb_cols);
}

get_start_tok_in_vp9_temporal_filter :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    tile_row: s32,
    tile_col: s32,
    mi_row: s32,
    tok: **TOKENEXTRA_in_vp9_cx_iface
) {
    CM := *cpi.common;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    this_tile := *cpi.tile_data[tile_row * TILE_COLS + tile_col];
    TILE_INFO := *this_tile.tile_info;

    tile_mb_cols := (TILE_INFO.mi_col_end - TILE_INFO.mi_col_start + 1) >> 1;
    MB_ROW := (mi_row - TILE_INFO.mi_row_start) >> 1;

    tok.* = cpi.tile_tok[tile_row][tile_col] + get_token_alloc_in_vp9_temporal_filter(MB_ROW, tile_mb_cols);
}

is_one_pass_svc_in_vp9_temporal_filter :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if CPI.use_svc != 0 && CPI.oxcf.pass == 0 {
        return 1;
    }
    return 0;
}

is_altref_enabled_in_vp9_temporal_filter :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if !(CPI.oxcf.mode == cast,no_check(u32) REALTIME && CPI.oxcf.rc_mode == cast,no_check(u32) CBR) &&
        CPI.oxcf.lag_in_frames >= 4 &&
        CPI.oxcf.enable_auto_arf != 0 {
        return 1;
    }
    return 0;
}

set_ref_ptrs_in_vp9_temporal_filter :: (
    CM: *VP9_COMMON,
    xd: *MACROBLOCKD,
    ref0: MV_REFERENCE_FRAME,
    ref1: MV_REFERENCE_FRAME
) {
    xd.block_refs[0] = CM.frame_refs.data + (ifx ref0 >= 1 then (cast(s32) ref0) - 1 else 0);
    xd.block_refs[1] = CM.frame_refs.data + (ifx ref1 >= 1 then (cast(s32) ref1) - 1 else 0);
}

get_chessboard_index_in_vp9_temporal_filter :: (FRAME_INDEX: s32) -> s32 {
    return FRAME_INDEX & 0x1;
}

get_num_vert_units_in_vp9_temporal_filter :: (tile: Tile_Info, shift: s32) -> s32 {
    num_vert_units := (tile.mi_row_end - tile.mi_row_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_vert_units;
}

get_num_cols_in_vp9_temporal_filter :: (tile: Tile_Info, shift: s32) -> s32 {
    num_cols := (tile.mi_col_end - tile.mi_col_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_cols;
}

get_level_index_in_vp9_temporal_filter :: (level: VP9_LEVEL) -> s32 {
    for i: 0..cast(s32) 14 - 1 {
        if level == VP9_LEVEL_DEFS[i].level {
            return i;
        }
    }
    return -1;
}

log_tile_cols_from_picsize_level_in_vp9_temporal_filter :: (width: u32, height: u32) -> s32 {
    PIC_SIZE := width * height;
    PIC_BREADTH := max(width, height);
    for i: 0..cast(s32) 14 - 1 {
        if VP9_LEVEL_DEFS[i].max_luma_picture_size >= PIC_SIZE && VP9_LEVEL_DEFS[i].max_luma_picture_breadth >= PIC_BREADTH {
            return get_msb_in_vp9_temporal_filter(cast,no_check(u32) VP9_LEVEL_DEFS[i].max_col_tiles);
        }
    }
    return 2147483647;
}

alloc_frame_mvs_in_vp9_temporal_filter :: (CM: *VP9_COMMON, buffer_idx: s32) {
    NEW_FB_PTR := CM.buffer_pool.frame_bufs.data + buffer_idx;
    if NEW_FB_PTR.mvs == null || NEW_FB_PTR.mi_rows < CM.mi_rows || NEW_FB_PTR.mi_cols < CM.mi_cols {
        deallocate_memory(cast(*void) NEW_FB_PTR.mvs);
        NEW_FB_PTR.mvs =
            cast(*MV_REF) calloc_2(
                cast,no_check(u64) (CM.mi_rows * CM.mi_cols),
                size_of(MV_REF)
            );

        if NEW_FB_PTR.mvs == null {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate new_fb_ptr->mvs")
            );
        }
        NEW_FB_PTR.mi_rows = CM.mi_rows;
        NEW_FB_PTR.mi_cols = CM.mi_cols;
    }
}

mv_cost_in_vp9_temporal_filter :: (mv: *MV, joint_cost: *s32, comp_cost: **s32) -> s32 {
    return joint_cost[vp9_get_mv_joint_in_vp9_temporal_filter(mv)] + comp_cost[0][mv.row] + comp_cost[1][mv.col];
}

mvsad_err_cost_in_vp9_temporal_filter :: (x: *MACROBLOCK, mv: *MV, ref: *MV, sad_per_bit: s32) -> s32 {
    diff: MV = ---;
    diff.row = cast,no_check(s16) ((cast(s32) mv.row) - cast(s32) ref.row);
    diff.col = cast,no_check(s16) ((cast(s32) mv.col) - cast(s32) ref.col);
    return cast,no_check(s32) ((((cast,no_check(u32) mv_cost_in_vp9_temporal_filter(*diff, x.nmvjointsadcost.data, x.nmvsadcost.data)) * cast,no_check(u32) sad_per_bit) + cast,no_check(u32) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9);
}

get_start_mv_sad_in_vp9_temporal_filter :: (
    x: *MACROBLOCK,
    mvp_full: *MV,
    ref_mv_full: *MV,
    sad_fn_ptr: Sad_Fn_T,
    sadpb: s32
) -> u32 {
    SRC_BUF_STRIDE := x.plane[0].src.stride;
    SRC_BUF := x.plane[0].src.buf;
    XD := *x.e_mbd;
    PRED_BUF_STRIDE := XD.plane[0].pre[0].stride;
    PRED_BUF := XD.plane[0].pre[0].buf + (cast(s32) mvp_full.row) * PRED_BUF_STRIDE + cast,no_check(s32) mvp_full.col;
    start_mv_sad: u32 = sad_fn_ptr(SRC_BUF, SRC_BUF_STRIDE, PRED_BUF, PRED_BUF_STRIDE);
    start_mv_sad += cast,no_check(u32) mvsad_err_cost_in_vp9_temporal_filter(x, mvp_full, ref_mv_full, sadpb);

    return start_mv_sad;
}

num_4x4_to_edge_in_vp9_temporal_filter :: (
    plane_4x4_dim: s32,
    mb_to_edge_dim: s32,
    subsampling_dim: s32,
    blk_dim: s32
) -> s32 {
    return plane_4x4_dim + mb_to_edge_dim >> (((5 + subsampling_dim)) & 31) - blk_dim;
}

sum_squares_visible_in_vp9_temporal_filter :: (
    xd: *MACROBLOCKD,
    PD: *Macroblockd_Plane,
    diff: *s16,
    DIFF_STRIDE: s32,
    blk_row: s32,
    blk_col: s32,
    PLANE_BSIZE: BLOCK_SIZE,
    TX_BSIZE: BLOCK_SIZE,
    visible_width: *s32,
    visible_height: *s32
) -> s64 {
    sse: s64 = ---;
    PLANE_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE];
    PLANE_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE];
    TX_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[TX_BSIZE];
    TX_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[TX_BSIZE];
    B4X4S_TO_RIGHT_EDGE :=
        num_4x4_to_edge_in_vp9_temporal_filter(
            PLANE_4X4_W,
            xd.mb_to_right_edge,
            PD.subsampling_x,
            blk_col
        );
    B4X4S_TO_BOTTOM_EDGE :=
        num_4x4_to_edge_in_vp9_temporal_filter(
            PLANE_4X4_H,
            xd.mb_to_bottom_edge,
            PD.subsampling_y,
            blk_row
        );
    if TX_BSIZE == 0 || B4X4S_TO_RIGHT_EDGE >= TX_4X4_W && B4X4S_TO_BOTTOM_EDGE >= TX_4X4_H {
        sse = cast,no_check(s64) sum_squares_2d_i16_c(diff, DIFF_STRIDE, TX_4X4_W << 2);
        visible_width.* = TX_4X4_W << 2;
        visible_height.* = TX_4X4_H << 2;
    } else {
        c: s32 = ---;
        MAX_R := min(B4X4S_TO_BOTTOM_EDGE, TX_4X4_H);
        MAX_C := min(B4X4S_TO_RIGHT_EDGE, TX_4X4_W);
        sse = 0;

        if 0 < MAX_R {
            for r: 0..MAX_R - 1 {
                c = 0;
                while c < MAX_C {
                    sse +=
                        cast,no_check(s64) sum_squares_2d_i16_c(
                            diff + r * DIFF_STRIDE * 4 + c * 4,
                            DIFF_STRIDE,
                            4
                        );
                    c += 1;
                }
            }
        }
        visible_width.* = MAX_C << 2;
        visible_height.* = MAX_R << 2;
    }
    return sse;
}

do_trellis_opt_in_vp9_temporal_filter :: (
    pd: *Macroblockd_Plane,
    src_diff: *s16,
    diff_stride: s32,
    blk_row: s32,
    blk_col: s32,
    plane_bsize: BLOCK_SIZE,
    tx_size: TX_SIZE,
    arg: *void
) -> s32 {
    ARGS := cast(*Encode_B_Args) arg;
    X := ARGS.x;

    if ARGS.enable_trellis_opt == {
        case DISABLE_TRELLIS_OPT;
            return 0;
        case ENABLE_TRELLIS_OPT;
            return 1;
        case ENABLE_TRELLIS_OPT_TX_RD_SRC_VAR;
            {
                return ifx c_transpiler_float_greater(ARGS.trellis_opt_thresh, 0.0) then cast(s32) (c_transpiler_float_less_equal(X.log_block_src_var, ARGS.trellis_opt_thresh)) else 1;
            }
        case ENABLE_TRELLIS_OPT_TX_RD_RESIDUAL_MSE;
            {
                XD := *X.e_mbd;
                TX_BSIZE := TXSIZE_TO_BSIZE[tx_size];

                DEQUANT_SHIFT: s32 = 3;

                QSTEP := (cast(s32) pd.dequant[1]) >> ((DEQUANT_SHIFT) & 31);
                sse_calc_done := ARGS.sse_calc_done;
                sse := ARGS.sse;
                visible_width: s32 = 0;
                visible_height: s32 = 0;

                if XD.cur_buf.flags & 8 != 0 || sse == null || sse_calc_done == null {
                    return 1;
                }

                sse.* =
                    sum_squares_visible_in_vp9_temporal_filter(
                        XD,
                        pd,
                        src_diff,
                        diff_stride,
                        blk_row,
                        blk_col,
                        plane_bsize,
                        TX_BSIZE,
                        *visible_width,
                        *visible_height
                    );
                sse_calc_done.* = 1;

                if c_transpiler_float_less_equal(cast,no_check(float64) sse.*, (((((cast,no_check(s64) visible_width) * cast(s64) visible_height) * cast(s64) QSTEP) * cast(s64) QSTEP) * ARGS.trellis_opt_thresh)) {
                    return 1;
                }
                return 0;
            }
        case;
            return 1;
    }
    return unreachable_value(s32);
}

usec_timer_start_in_vp9_temporal_filter :: (t: *Usec_Timer) {
    clock_gettime(4, *t.begin);
}

usec_timer_mark_in_vp9_temporal_filter :: (t: *Usec_Timer) {
    clock_gettime(4, *t.end);
}

usec_timer_elapsed_in_vp9_temporal_filter :: (t: *Usec_Timer) -> s64 {
    diff: C_Transpiler_POSIX.timespec = ---;

    assignment_0: Time_T = (t.end.tv_sec - t.begin.tv_sec);
    (diff.tv_sec) = assignment_0;

    assignment_1: Syscall_Slong_T = (t.end.tv_nsec - t.begin.tv_nsec);
    (diff.tv_nsec) = assignment_1;

    if diff.tv_nsec < 0 {
        diff.tv_sec -= 1;

        c_transpiler_compound_add(*(diff.tv_nsec), (cast(Syscall_Slong_T) 1000000000), Syscall_Slong_T, Syscall_Slong_T);
    }
    return (diff.tv_sec * 1000000) + diff.tv_nsec / 1000;
}

globals_initialization_state_for_vp9_temporal_filter: u32;
initialize_globals_for_vp9_temporal_filter :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_temporal_filter);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_temporal_filter, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_temporal_filter) != 2 {}
            return;
        }
    }
    K_VP9_REF_FLAG_LIST_in_vp9_temporal_filter =
        s32.[ 0, cast,no_check(s32) (VP9_LAST_FLAG), cast,no_check(s32) (VP9_GOLD_FLAG), cast,no_check(s32) (VP9_ALT_FLAG) ];
    SUB_PEL_FILTERS_12_in_vp9_temporal_filter =
        Interp_Kernel12.[
            s16.[ 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, 0, 0 ],
            s16.[ 0, 1, -2, 3, -7, 127, 8, -4, 2, -1, 1, 0 ],
            s16.[ -1, 2, -3, 6, -13, 124, 18, -8, 4, -2, 2, -1 ],
            s16.[ -1, 3, -4, 8, -18, 120, 28, -12, 7, -4, 2, -1 ],
            s16.[ -1, 3, -6, 10, -21, 115, 38, -15, 8, -5, 3, -1 ],
            s16.[ -2, 4, -6, 12, -24, 108, 49, -18, 10, -6, 3, -2 ],
            s16.[ -2, 4, -7, 13, -25, 100, 60, -21, 11, -7, 4, -2 ],
            s16.[ -2, 4, -7, 13, -26, 91, 71, -24, 13, -7, 4, -2 ],
            s16.[ -2, 4, -7, 13, -25, 81, 81, -25, 13, -7, 4, -2 ],
            s16.[ -2, 4, -7, 13, -24, 71, 91, -26, 13, -7, 4, -2 ],
            s16.[ -2, 4, -7, 11, -21, 60, 100, -25, 13, -7, 4, -2 ],
            s16.[ -2, 3, -6, 10, -18, 49, 108, -24, 12, -6, 4, -2 ],
            s16.[ -1, 3, -5, 8, -15, 38, 115, -21, 10, -6, 3, -1 ],
            s16.[ -1, 2, -4, 7, -12, 28, 120, -18, 8, -4, 3, -1 ],
            s16.[ -1, 2, -2, 4, -8, 18, 124, -13, 6, -3, 2, -1 ],
            s16.[ 0, 1, -1, 2, -4, 8, 127, -7, 3, -2, 1, 0 ]
        ];
    index_mult =
        u32.[
            0,
            0,
            0,
            0,
            49152,
            39322,
            32768,
            28087,
            24576,
            21846,
            19661,
            17874,
            0,
            15124
        ];
    COUNT_TO_UPDATE_FACTOR_in_vp9_temporal_filter =
        s32.[
            0,
            6,
            12,
            19,
            25,
            32,
            38,
            44,
            51,
            57,
            64,
            70,
            76,
            83,
            89,
            96,
            102,
            108,
            115,
            121,
            128
        ];
    FRAME_SCALE_FACTOR_in_vp9_temporal_filter = s32.[ 16, 24 ];
    RATE_THRESH_MULT_in_vp9_temporal_filter = float64.[ 1.0, 2.0 ];
    RCF_MULT_in_vp9_temporal_filter = float64.[ 1.0, 2.0 ];
    atomic_store(*globals_initialization_state_for_vp9_temporal_filter, 2);
}

