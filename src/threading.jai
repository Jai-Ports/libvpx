// Generated directly from C by cpp_transpiler.
codec_control_vp8_set_reference_in_threading :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *Ref_Frame_T) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_copy_reference_in_threading :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *Ref_Frame_T) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_set_postproc_in_threading :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Vp8_Postproc_Cfg_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_get_reference_in_threading :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Vp9_Ref_Frame_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_last_ref_updates_in_threading :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_frame_corrupted_in_threading :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_last_ref_used_in_threading :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vpxd_set_decryptor_in_threading :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *Decrypt_Init) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_set_decryptor_in_threading :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Decrypt_Init
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_frame_size_in_threading :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_display_size_in_threading :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_bit_depth_in_threading :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *u32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_set_byte_alignment_in_threading :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_invert_tile_decode_order_in_threading :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_set_skip_loop_filter_in_threading :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_decode_svc_spatial_layer_in_threading :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vpxd_get_last_quantizer_in_threading :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_set_row_mt_in_threading :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_set_loop_filter_opt_in_threading :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

vp8dx_decode_bool_in_threading :: (br: *BOOL_DECODER, probability: s32) -> s32 {
    bit: u32 = 0;

    split := 1 + ((br.range - 1) * cast,no_check(u32) probability) >> 8;

    if br.count < 0 {
        (cast,no_check(#type (_: *BOOL_DECODER)) (cast(*void) vp8dx_bool_decoder_fill))(br);
    }

    value := br.value;
    count := br.count;

    bigsplit :=
        (cast,no_check(VP8_BD_VALUE) split) << ((((cast,no_check(s32) (cast(u64) size_of(VP8_BD_VALUE))) * 8 -
            8)) & 63);

    range := split;

    if value >= bigsplit {
        range = br.range - split;
        value = value - bigsplit;
        bit = 1;
    }

    {
        SHIFT := VP8_NORM[cast,no_check(u8) range];
        c_transpiler_compound_shl(*(range), (((cast,no_check(u32) (cast,no_check(s32) SHIFT)) & 31)), u32, u32);
        c_transpiler_compound_shl(*(value), (((cast,no_check(VP8_BD_VALUE) (cast,no_check(s32) SHIFT)) & 63)), VP8_BD_VALUE, VP8_BD_VALUE);
        count -= cast,no_check(s32) SHIFT;
    }
    br.value = value;
    br.count = count;
    br.range = range;

    return cast,no_check(s32) bit;
}

vp8_decode_value_in_threading :: (br: *BOOL_DECODER, bits: s32) -> s32 {
    z: s32 = 0;

    bit := bits - 1;
    while bit >= 0 {
        z |= vp8dx_decode_bool_in_threading(br, 0x80) << ((bit) & 31);
        bit -= 1;
    }

    return z;
}

vp8dx_bool_error_in_threading :: (br: *BOOL_DECODER) -> s32 {
    if br.count > (cast,no_check(s32) (cast(u64) size_of(VP8_BD_VALUE))) * 8 && br.count < 0x40000000 {
        return 1;
    }

    return 0;
}

vp8_treed_read_in_threading :: (R: *Vp8_Reader_in_treereader, t: *Vp8_Tree_Index, P: *Vp8_Prob) -> s32 {
    i: Vp8_Tree_Index = 0;

    while (ifx true { assignment_1: Vp8_Tree_Index = cast,no_check(Vp8_Tree_Index) (t[(cast(s32) i) + vp8dx_decode_bool_in_threading(R, cast,no_check(s32) P[(cast(s32) i) >> 1])]); (i) = assignment_1; assignment_1; }) > 0 {
    }

    return -(cast,no_check(s32) i);
}

vp8_sem_wait_in_threading :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_2: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_2; assignment_2; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init_in_threading :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release_in_threading :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

atomic_load_acquire_in_threading :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_atomic_spin_wait_in_threading :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire_in_threading(last_row_current_mb_col) - NSYNC {
    }
}

usec_timer_start_in_threading :: (t: *Usec_Timer) {
    clock_gettime(4, *t.begin);
}

usec_timer_mark_in_threading :: (t: *Usec_Timer) {
    clock_gettime(4, *t.end);
}

usec_timer_elapsed_in_threading :: (t: *Usec_Timer) -> s64 {
    diff: C_Transpiler_POSIX.timespec = ---;

    assignment_3: Time_T = (t.end.tv_sec - t.begin.tv_sec);
    (diff.tv_sec) = assignment_3;

    assignment_4: Syscall_Slong_T = (t.end.tv_nsec - t.begin.tv_nsec);
    (diff.tv_nsec) = assignment_4;

    if diff.tv_nsec < 0 {
        diff.tv_sec -= 1;

        c_transpiler_compound_add(*(diff.tv_nsec), (cast(Syscall_Slong_T) 1000000000), Syscall_Slong_T, Syscall_Slong_T);
    }
    return (diff.tv_sec * 1000000) + diff.tv_nsec / 1000;
}

vp8mt_decode_mb_rows :: (pbi: *VP8_D_COMP, xd: *MACROBLOCKD_in_blockd) -> s32 {
    pc := *pbi.common;

    j: s32 = ---;

    filter_level := pc.filter_level;
    yv12_fb_new := pbi.dec_fb_ref[INTRA_FRAME];

    if filter_level != 0 {
        fill_memory(pbi.mt_yabove_row[0] + 32 - 1, 127, cast,no_check(u64) (yv12_fb_new.y_width + 5));
        fill_memory(
            pbi.mt_uabove_row[0] + (cast(s32) 32) >> 1 - 1,
            127,
            cast,no_check(u64) (yv12_fb_new.y_width >> 1 + 5)
        );
        fill_memory(
            pbi.mt_vabove_row[0] + (cast(s32) 32) >> 1 - 1,
            127,
            cast,no_check(u64) (yv12_fb_new.y_width >> 1 + 5)
        );

        j = 1;
        while j < pc.mb_rows {
            fill_memory(pbi.mt_yabove_row[j] + 32 - 1, cast,no_check(s32) (cast(u8) 129), 1);
            fill_memory(pbi.mt_uabove_row[j] + (cast(s32) 32) >> 1 - 1, cast,no_check(s32) (cast(u8) 129), 1);
            fill_memory(pbi.mt_vabove_row[j] + (cast(s32) 32) >> 1 - 1, cast,no_check(s32) (cast(u8) 129), 1);
            j += 1;
        }

        j = 0;
        while j < pc.mb_rows {
            fill_memory(pbi.mt_yleft_col[j], cast,no_check(s32) (cast(u8) 129), 16);
            fill_memory(pbi.mt_uleft_col[j], cast,no_check(s32) (cast(u8) 129), 8);
            fill_memory(pbi.mt_vleft_col[j], cast,no_check(s32) (cast(u8) 129), 8);
            j += 1;
        }

        vp8_loop_filter_frame_init(pc, *pbi.mb, filter_level);
    } else {
        vp8_setup_intra_recon_top_line(yv12_fb_new);
    }

    setup_decoding_thread_data(pbi, xd, pbi.mb_row_di, cast,no_check(s32) pbi.decoding_thread_count);

    i: u32 = 0;
    while i < pbi.decoding_thread_count {
        sem_post(*(cast(*Sem_T) (pbi.h_event_start_decoding))[i]);
        i += 1;
    }

    if setjmp_2(xd.error_info.jmp.data) != 0 {
        xd.error_info.setjmp = 0;
        xd.corrupted = 1;

        i = 0;
        while i < pbi.decoding_thread_count {
            vp8_sem_wait_in_threading(*pbi.h_event_end_decoding);
            i += 1;
        }
        return -1;
    }

    xd.error_info.setjmp = 1;
    mt_decode_mb_rows(pbi, xd, 0);
    xd.error_info.setjmp = 0;

    i = 0;
    while i < pbi.decoding_thread_count + 1 {
        vp8_sem_wait_in_threading(*pbi.h_event_end_decoding);
        i += 1;
    }

    i = 0;
    while i < pbi.decoding_thread_count {
        if pbi.mb_row_di[i].mbd.error_info.error_code != 0 {
            xd.error_info = pbi.mb_row_di[i].mbd.error_info;
            return -1;
        }
        i += 1;
    }

    return 0;
}

mt_decode_mb_rows :: (pbi: *VP8_D_COMP, xd: *MACROBLOCKD_in_blockd, start_mb_row: s32) {
    pc := *pbi.common;
    NSYNC := pbi.sync_range;
    FIRST_ROW_NO_SYNC_ABOVE := Atomic_Int.{value = pc.mb_cols + NSYNC};
    num_part := (cast(s32) 1) << ((pbi.common.multi_token_partition) & 31);
    last_mb_row := start_mb_row;

    yv12_fb_new := pbi.dec_fb_ref[INTRA_FRAME];
    yv12_fb_lst := pbi.dec_fb_ref[LAST_FRAME];

    recon_y_stride := yv12_fb_new.y_stride;
    recon_uv_stride := yv12_fb_new.uv_stride;

    ref_buffer: [4] [3] *u8 = ---;
    dst_buffer: [3] *u8 = ---;

    ref_fb_corrupted: [4] s32 = ---;

    ref_fb_corrupted[INTRA_FRAME] = 0;

    i: s32 = 1;
    while i < MAX_REF_FRAMES {
        this_fb := pbi.dec_fb_ref[i];

        ref_buffer[i][0] = this_fb.y_buffer;
        ref_buffer[i][1] = this_fb.u_buffer;
        ref_buffer[i][2] = this_fb.v_buffer;

        ref_fb_corrupted[i] = this_fb.corrupted;
        i += 1;
    }

    dst_buffer[0] = yv12_fb_new.y_buffer;
    dst_buffer[1] = yv12_fb_new.u_buffer;
    dst_buffer[2] = yv12_fb_new.v_buffer;

    xd.up_available = cast(s32) (start_mb_row != 0);

    xd.mode_info_context = pc.mi + pc.mode_info_stride * start_mb_row;
    xd.mode_info_stride = pc.mode_info_stride;

    mb_row := start_mb_row;
    while mb_row < pc.mb_rows {
        filter_level: s32 = ---;
        lfi_n := *pc.lf_info;

        last_mb_row = mb_row;

        xd.current_bc = cast(*void) (pbi.mbc.data + mb_row % num_part);

        last_row_current_mb_col: *Atomic_Int = ifx mb_row > 0
            then *(cast(*Atomic_Int) (pbi.mt_current_mb_col))[mb_row - 1]
            else *FIRST_ROW_NO_SYNC_ABOVE;

        current_mb_col := *(cast(*Atomic_Int) (pbi.mt_current_mb_col))[mb_row];

        recon_yoffset := mb_row * recon_y_stride * 16;
        recon_uvoffset := mb_row * recon_uv_stride * 8;

        xd.above_context = pc.above_context;
        fill_memory(xd.left_context, 0, size_of(ENTROPY_CONTEXT_PLANES));

        xd.left_available = 0;

        xd.mb_to_top_edge = -((mb_row * 16) << 3);
        xd.mb_to_bottom_edge = ((pc.mb_rows - 1 - mb_row) * 16) << 3;

        if pbi.common.filter_level != 0 {
            xd.recon_above[0] = pbi.mt_yabove_row[mb_row] + 0 * 16 + 32;
            xd.recon_above[1] = pbi.mt_uabove_row[mb_row] + 0 * 8 + 16;
            xd.recon_above[2] = pbi.mt_vabove_row[mb_row] + 0 * 8 + 16;

            xd.recon_left[0] = pbi.mt_yleft_col[mb_row];
            xd.recon_left[1] = pbi.mt_uleft_col[mb_row];
            xd.recon_left[2] = pbi.mt_vleft_col[mb_row];

            xd.recon_left_stride[0] = 1;
            xd.recon_left_stride[1] = 1;
        } else {
            xd.recon_above[0] = dst_buffer[0] + recon_yoffset;
            xd.recon_above[1] = dst_buffer[1] + recon_uvoffset;
            xd.recon_above[2] = dst_buffer[2] + recon_uvoffset;

            xd.recon_left[0] = xd.recon_above[0] - 1;
            xd.recon_left[1] = xd.recon_above[1] - 1;
            xd.recon_left[2] = xd.recon_above[2] - 1;

            xd.recon_above[0] -= xd.dst.y_stride;
            xd.recon_above[1] -= xd.dst.uv_stride;
            xd.recon_above[2] -= xd.dst.uv_stride;

            xd.recon_left_stride[0] = xd.dst.y_stride;
            xd.recon_left_stride[1] = xd.dst.uv_stride;

            setup_intra_recon_left_in_threading(
                xd.recon_left[0],
                xd.recon_left[1],
                xd.recon_left[2],
                xd.dst.y_stride,
                xd.dst.uv_stride
            );
        }

        mb_col: s32 = 0;
        while mb_col < pc.mb_cols {
            if (mb_col - 1) % NSYNC == 0 {
                atomic_store_release_in_threading(current_mb_col, mb_col - 1);
            }

            if mb_row != 0 && mb_col & (NSYNC - 1) == 0 {
                vp8_atomic_spin_wait_in_threading(mb_col, last_row_current_mb_col, NSYNC);
            }

            xd.mb_to_left_edge = -((mb_col * 16) << 3);
            xd.mb_to_right_edge = ((pc.mb_cols - 1 - mb_col) * 16) << 3;

            xd.dst.y_buffer = dst_buffer[0] + recon_yoffset;
            xd.dst.u_buffer = dst_buffer[1] + recon_uvoffset;
            xd.dst.v_buffer = dst_buffer[2] + recon_uvoffset;

            xd.corrupted |= ref_fb_corrupted[xd.mode_info_context.mbmi.ref_frame];

            if xd.corrupted != 0 {
                while mb_row < pc.mb_rows {
                    current_mb_col = *(cast(*Atomic_Int) (pbi.mt_current_mb_col))[mb_row];
                    atomic_store_release_in_threading(current_mb_col, pc.mb_cols + NSYNC);
                    mb_row = cast,no_check(s32) ((cast,no_check(u32) mb_row) + (pbi.decoding_thread_count + 1));
                }
                internal_error(
                    *xd.error_info,
                    cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                    c_string("Corrupted reference frame")
                );
            }

            if xd.mode_info_context.mbmi.ref_frame >= cast,no_check(u8) LAST_FRAME {
                REF := cast,no_check(MV_REFERENCE_FRAME_in_alloccommon) xd.mode_info_context.mbmi.ref_frame;
                xd.pre.y_buffer = ref_buffer[REF][0] + recon_yoffset;
                xd.pre.u_buffer = ref_buffer[REF][1] + recon_uvoffset;
                xd.pre.v_buffer = ref_buffer[REF][2] + recon_uvoffset;
            } else {
                xd.pre.y_buffer = null;
                xd.pre.u_buffer = null;
                xd.pre.v_buffer = null;
            }
            mt_decode_macroblock(pbi, xd, 0);

            xd.left_available = 1;

            xd.corrupted |= vp8dx_bool_error_in_threading(cast(*BOOL_DECODER) xd.current_bc);

            xd.recon_above[0] += 16;
            xd.recon_above[1] += 8;
            xd.recon_above[2] += 8;

            if pbi.common.filter_level == 0 {
                xd.recon_left[0] += 16;
                xd.recon_left[1] += 8;
                xd.recon_left[2] += 8;
            }

            if pbi.common.filter_level != 0 {
                skip_lf :=
                    cast(s32) (xd.mode_info_context.mbmi.mode != cast,no_check(u8) B_PRED &&
                        xd.mode_info_context.mbmi.mode != cast,no_check(u8) SPLITMV && xd.mode_info_context.mbmi.mb_skip_coeff != 0);

                MODE_INDEX := cast,no_check(s32) lfi_n.mode_lf_lut[xd.mode_info_context.mbmi.mode];
                SEG := cast,no_check(s32) xd.mode_info_context.mbmi.segment_id;
                REF_FRAME := cast,no_check(s32) xd.mode_info_context.mbmi.ref_frame;

                filter_level = cast,no_check(s32) lfi_n.lvl[SEG][REF_FRAME][MODE_INDEX];

                if mb_row != pc.mb_rows - 1 {
                    copy_memory(
                        pbi.mt_yabove_row[mb_row + 1] + 32 + mb_col * 16,
                        xd.dst.y_buffer + 15 * recon_y_stride,
                        16
                    );
                    copy_memory(
                        pbi.mt_uabove_row[mb_row + 1] + 16 + mb_col * 8,
                        xd.dst.u_buffer + 7 * recon_uv_stride,
                        8
                    );
                    copy_memory(
                        pbi.mt_vabove_row[mb_row + 1] + 16 + mb_col * 8,
                        xd.dst.v_buffer + 7 * recon_uv_stride,
                        8
                    );
                }

                if mb_col != pc.mb_cols - 1 {
                    next := xd.mode_info_context + 1;

                    if next.mbmi.ref_frame == cast,no_check(u8) INTRA_FRAME {
                        i = 0;
                        while i < 16 {
                            pbi.mt_yleft_col[mb_row][i] = xd.dst.y_buffer[i * recon_y_stride + 15];
                            i += 1;
                        }
                        i = 0;
                        while i < 8 {
                            pbi.mt_uleft_col[mb_row][i] = xd.dst.u_buffer[i * recon_uv_stride + 7];
                            pbi.mt_vleft_col[mb_row][i] = xd.dst.v_buffer[i * recon_uv_stride + 7];
                            i += 1;
                        }
                    }
                }

                if filter_level != 0 {
                    if pc.filter_type == cast,no_check(u32) NORMAL_LOOPFILTER {
                        lfi: Loop_Filter_Info = ---;
                        frame_type := pc.frame_type;
                        HEV_INDEX := cast,no_check(s32) lfi_n.hev_thr_lut[frame_type][filter_level];
                        lfi.mblim = lfi_n.mblim[filter_level].data;
                        lfi.blim = lfi_n.blim[filter_level].data;
                        lfi.lim = lfi_n.lim[filter_level].data;
                        lfi.hev_thr = lfi_n.hev_thr[HEV_INDEX].data;

                        if mb_col > 0 {
                            vp8_loop_filter_mbv_c(
                                xd.dst.y_buffer,
                                xd.dst.u_buffer,
                                xd.dst.v_buffer,
                                recon_y_stride,
                                recon_uv_stride,
                                *lfi
                            );
                        }

                        if skip_lf == 0 {
                            vp8_loop_filter_bv_c(
                                xd.dst.y_buffer,
                                xd.dst.u_buffer,
                                xd.dst.v_buffer,
                                recon_y_stride,
                                recon_uv_stride,
                                *lfi
                            );
                        }

                        if mb_row > 0 {
                            vp8_loop_filter_mbh_c(
                                xd.dst.y_buffer,
                                xd.dst.u_buffer,
                                xd.dst.v_buffer,
                                recon_y_stride,
                                recon_uv_stride,
                                *lfi
                            );
                        }

                        if skip_lf == 0 {
                            vp8_loop_filter_bh_c(
                                xd.dst.y_buffer,
                                xd.dst.u_buffer,
                                xd.dst.v_buffer,
                                recon_y_stride,
                                recon_uv_stride,
                                *lfi
                            );
                        }
                    } else {
                        if mb_col > 0 {
                            vp8_loop_filter_simple_vertical_edge_c(
                                xd.dst.y_buffer,
                                recon_y_stride,
                                lfi_n.mblim[filter_level].data
                            );
                        }

                        if skip_lf == 0 {
                            vp8_loop_filter_bvs_c(xd.dst.y_buffer, recon_y_stride, lfi_n.blim[filter_level].data);
                        }

                        if mb_row > 0 {
                            vp8_loop_filter_simple_horizontal_edge_c(
                                xd.dst.y_buffer,
                                recon_y_stride,
                                lfi_n.mblim[filter_level].data
                            );
                        }

                        if skip_lf == 0 {
                            vp8_loop_filter_bhs_c(xd.dst.y_buffer, recon_y_stride, lfi_n.blim[filter_level].data);
                        }
                    }
                }
            }

            recon_yoffset += 16;
            recon_uvoffset += 8;

            xd.mode_info_context += 1;

            xd.above_context += 1;
            mb_col += 1;
        }

        if pbi.common.filter_level != 0 {
            if mb_row != pc.mb_rows - 1 {
                lasty := yv12_fb_lst.y_width + 32;
                lastuv := yv12_fb_lst.y_width >> 1 + (cast(s32) 32) >> 1;

                i = 0;
                while i < 4 {
                    pbi.mt_yabove_row[mb_row + 1][lasty + i] = pbi.mt_yabove_row[mb_row + 1][lasty - 1];
                    pbi.mt_uabove_row[mb_row + 1][lastuv + i] = pbi.mt_uabove_row[mb_row + 1][lastuv - 1];
                    pbi.mt_vabove_row[mb_row + 1][lastuv + i] = pbi.mt_vabove_row[mb_row + 1][lastuv - 1];
                    i += 1;
                }
            }
        } else {
            vp8_extend_mb_row(yv12_fb_new, xd.dst.y_buffer + 16, xd.dst.u_buffer + 8, xd.dst.v_buffer + 8);
        }

        atomic_store_release_in_threading(current_mb_col, mb_col + NSYNC);

        xd.mode_info_context += 1;
        xd.up_available = 1;

        xd.mode_info_context += (cast,no_check(u32) xd.mode_info_stride) * pbi.decoding_thread_count;
        mb_row = cast,no_check(s32) ((cast,no_check(u32) mb_row) + (pbi.decoding_thread_count + 1));
    }

    if ((last_mb_row + cast,no_check(s32) pbi.decoding_thread_count) + 1) >= pc.mb_rows {
        sem_post(*pbi.h_event_end_decoding);
    }
}

mt_decode_macroblock :: (pbi: *VP8_D_COMP, xd: *MACROBLOCKD_in_blockd, mb_idx: u32) {
    if xd.mode_info_context.mbmi.mb_skip_coeff != 0 {
        vp8_reset_mb_tokens_context(xd);
    } else if vp8dx_bool_error_in_threading(cast(*BOOL_DECODER) xd.current_bc) == 0 {
        eobtotal := vp8_decode_mb_tokens(pbi, xd);

        xd.mode_info_context.mbmi.mb_skip_coeff = cast(u8) (eobtotal == 0);
    }

    mode := cast,no_check(MB_PREDICTION_MODE) xd.mode_info_context.mbmi.mode;

    if xd.segmentation_enabled != 0 {
        vp8_mb_init_dequantizer(pbi, xd);
    }

    if xd.mode_info_context.mbmi.ref_frame == cast,no_check(u8) INTRA_FRAME {
        vp8_build_intra_predictors_mbuv_s(
            xd,
            xd.recon_above[1],
            xd.recon_above[2],
            xd.recon_left[1],
            xd.recon_left[2],
            xd.recon_left_stride[1],
            xd.dst.u_buffer,
            xd.dst.v_buffer,
            xd.dst.uv_stride
        );

        if mode != cast,no_check(u32) B_PRED {
            vp8_build_intra_predictors_mby_s(
                xd,
                xd.recon_above[0],
                xd.recon_left[0],
                xd.recon_left_stride[0],
                xd.dst.y_buffer,
                xd.dst.y_stride
            );
        } else {
            dqc := xd.dequant_y1.data;
            dst_stride := xd.dst.y_stride;

            if xd.mode_info_context.mbmi.mb_skip_coeff != 0 {
                fill_memory(xd.eobs.data, 0, 25);
            }

            intra_prediction_down_copy_in_threading(xd, xd.recon_above[0] + 16);

            for i: 0..cast(s32) 16 - 1 {
                b := xd.block.data + i;
                dst: *u8 = xd.dst.y_buffer + b.offset;
                b_mode := xd.mode_info_context.bmi[i].as_mode;

                yleft: *u8 = ---;
                left_stride: s32 = ---;

                above: *u8 = ifx i < 4 && pbi.common.filter_level != 0
                    then xd.recon_above[0] + b.offset
                    else dst - dst_stride;

                if i % 4 == 0 && pbi.common.filter_level != 0 {
                    yleft = xd.recon_left[0] + i;
                    left_stride = 1;
                } else {
                    yleft = dst - 1;
                    left_stride = dst_stride;
                }

                top_left: u8 = ifx (i == 4 || i == 8 || i == 12) && pbi.common.filter_level != 0
                    then (xd.recon_left[0] + i - 1).*
                    else above[-1];

                vp8_intra4x4_predict(above, yleft, left_stride, b_mode, dst, dst_stride, top_left);

                if xd.eobs[i] != 0 {
                    if xd.eobs[i] > 1 {
                        vp8_dequant_idct_add_c(b.qcoeff, dqc, dst, dst_stride);
                    } else {
                        vp8_dc_only_idct_add_c(
                            cast,no_check(s16) ((cast(s32) b.qcoeff[0]) * cast(s32) dqc[0]),
                            dst,
                            dst_stride,
                            dst,
                            dst_stride
                        );
                        fill_memory(b.qcoeff, 0, cast(u64) 2 * size_of(s16));
                    }
                }
            }
        }
    } else {
        vp8_build_inter_predictors_mb(xd);
    }

    if xd.mode_info_context.mbmi.mb_skip_coeff == 0 {
        if mode != cast,no_check(u32) B_PRED {
            dqc := xd.dequant_y1.data;

            if mode != cast,no_check(u32) SPLITMV {
                b := xd.block.data + 24;

                if xd.eobs[24] > 1 {
                    vp8_dequantize_b_c(b, xd.dequant_y2.data);

                    vp8_short_inv_walsh4x4_c(*b.dqcoeff[0], xd.qcoeff.data);
                    fill_memory(b.qcoeff, 0, cast(u64) 16 * size_of(s16));
                } else {
                    b.dqcoeff[0] = cast,no_check(s16) ((cast(s32) b.qcoeff[0]) * cast(s32) xd.dequant_y2[0]);
                    vp8_short_inv_walsh4x4_1_c(*b.dqcoeff[0], xd.qcoeff.data);
                    fill_memory(b.qcoeff, 0, cast(u64) 2 * size_of(s16));
                }

                dqc = xd.dequant_y1_dc.data;
            }

            vp8_dequant_idct_add_y_block_c(xd.qcoeff.data, dqc, xd.dst.y_buffer, xd.dst.y_stride, xd.eobs.data);
        }

        vp8_dequant_idct_add_uv_block_c(
            xd.qcoeff.data + 16 * 16,
            xd.dequant_uv.data,
            xd.dst.u_buffer,
            xd.dst.v_buffer,
            xd.dst.uv_stride,
            xd.eobs.data + 16
        );
    }
}

intra_prediction_down_copy_in_threading :: (xd: *MACROBLOCKD_in_blockd, above_right_src: *u8) {
    dst_stride := xd.dst.y_stride;
    above_right_dst: *u8 = xd.dst.y_buffer - dst_stride + 16;

    src_ptr := cast(*u32) above_right_src;
    dst_ptr0 := cast(*u32) (above_right_dst + 4 * dst_stride);
    dst_ptr1 := cast(*u32) (above_right_dst + 8 * dst_stride);
    dst_ptr2 := cast(*u32) (above_right_dst + 12 * dst_stride);

    dst_ptr0.* = src_ptr.*;
    dst_ptr1.* = src_ptr.*;
    dst_ptr2.* = src_ptr.*;
}

setup_intra_recon_left_in_threading :: (y_buffer: *u8, u_buffer: *u8, v_buffer: *u8, y_stride: s32, uv_stride: s32) {
    for i: 0..cast(s32) 16 - 1 {
        y_buffer[y_stride * i] = 129;
    }

    for i: 0..cast(s32) 8 - 1 {
        u_buffer[uv_stride * i] = 129;
    }

    for i: 0..cast(s32) 8 - 1 {
        v_buffer[uv_stride * i] = 129;
    }
}

setup_decoding_thread_data :: (pbi: *VP8_D_COMP, xd: *MACROBLOCKD_in_blockd, mbrd: *MB_ROW_DEC, count: s32) {
    PC := *pbi.common;

    i: s32 = 0;
    while i < count {
        mbd := *mbrd[i].mbd;

        if PC.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon || pbi.ec_active != 0 {
            mbd.corrupted = 0;
        }
        mbd.error_info.error_code = cast,no_check(Codec_Err_T) (cast(s32) 0);

        mbd.subpixel_predict = xd.subpixel_predict;
        mbd.subpixel_predict8x4 = xd.subpixel_predict8x4;
        mbd.subpixel_predict8x8 = xd.subpixel_predict8x8;
        mbd.subpixel_predict16x16 = xd.subpixel_predict16x16;

        mbd.frame_type = PC.frame_type;
        mbd.pre = xd.pre;
        mbd.dst = xd.dst;

        mbd.segmentation_enabled = xd.segmentation_enabled;
        mbd.mb_segment_abs_delta = xd.mb_segment_abs_delta;
        copy_memory(
            mbd.segment_feature_data.data,
            xd.segment_feature_data.data,
            xd.segment_feature_data.count * size_of([4] s8)
        );

        copy_memory(mbd.ref_lf_deltas.data, xd.ref_lf_deltas.data, xd.ref_lf_deltas.count);

        copy_memory(mbd.mode_lf_deltas.data, xd.mode_lf_deltas.data, xd.mode_lf_deltas.count);

        mbd.mode_ref_lf_delta_enabled = xd.mode_ref_lf_delta_enabled;
        mbd.mode_ref_lf_delta_update = xd.mode_ref_lf_delta_update;

        mbd.current_bc = cast(*void) (pbi.mbc.data + 0);

        copy_memory(mbd.dequant_y1_dc.data, xd.dequant_y1_dc.data, xd.dequant_y1_dc.count * size_of(s16));
        copy_memory(mbd.dequant_y1.data, xd.dequant_y1.data, xd.dequant_y1.count * size_of(s16));
        copy_memory(mbd.dequant_y2.data, xd.dequant_y2.data, xd.dequant_y2.count * size_of(s16));
        copy_memory(mbd.dequant_uv.data, xd.dequant_uv.data, xd.dequant_uv.count * size_of(s16));

        mbd.fullpixel_mask = ~(cast(s32) 0);

        if PC.full_pixel != 0 {
            mbd.fullpixel_mask = ~(cast(s32) 7);
        }
        i += 1;
    }

    i = 0;
    while i < PC.mb_rows {
        atomic_store_release_in_threading(*(cast(*Atomic_Int) (pbi.mt_current_mb_col))[i], -1);
        i += 1;
    }
}

vp8_decoder_remove_threads :: (pbi: *VP8_D_COMP) {
    if atomic_load_acquire_in_threading(*pbi.b_multithreaded_rd) != 0 {
        atomic_store_release_in_threading(*pbi.b_multithreaded_rd, 0);

        i: s32 = 0;
        while i < pbi.allocated_decoding_thread_count {
            sem_post(*(cast(*Sem_T) (pbi.h_event_start_decoding))[i]);
            pthread_join(pbi.h_decoding_thread[i], null);
            i += 1;
        }

        i = 0;
        while i < pbi.allocated_decoding_thread_count {
            sem_destroy(*(cast(*Sem_T) (pbi.h_event_start_decoding))[i]);
            i += 1;
        }

        if pbi.allocated_decoding_thread_count != 0 {
            sem_destroy(*pbi.h_event_end_decoding);
        }

        deallocate_memory(cast(*void) pbi.h_decoding_thread);
        pbi.h_decoding_thread = null;

        deallocate_memory(cast(*void) pbi.h_event_start_decoding);
        pbi.h_event_start_decoding = null;

        deallocate_memory(cast(*void) pbi.mb_row_di);
        pbi.mb_row_di = null;

        deallocate_memory(cast(*void) pbi.de_thread_data);
        pbi.de_thread_data = null;

        vp8mt_de_alloc_temp_buffers(pbi, pbi.common.mb_rows);
    }
}

vp8mt_de_alloc_temp_buffers :: (pbi: *VP8_D_COMP, mb_rows: s32) {
    deallocate_memory(cast(*void) pbi.mt_current_mb_col);
    pbi.mt_current_mb_col = null;

    if pbi.mt_yabove_row != null {
        if 0 < mb_rows {
            for i: 0..mb_rows - 1 {
                deallocate_memory(cast(*void) pbi.mt_yabove_row[i]);
                pbi.mt_yabove_row[i] = null;
            }
        }
        deallocate_memory(cast(*void) pbi.mt_yabove_row);
        pbi.mt_yabove_row = null;
    }

    if pbi.mt_uabove_row != null {
        if 0 < mb_rows {
            for i: 0..mb_rows - 1 {
                deallocate_memory(cast(*void) pbi.mt_uabove_row[i]);
                pbi.mt_uabove_row[i] = null;
            }
        }
        deallocate_memory(cast(*void) pbi.mt_uabove_row);
        pbi.mt_uabove_row = null;
    }

    if pbi.mt_vabove_row != null {
        if 0 < mb_rows {
            for i: 0..mb_rows - 1 {
                deallocate_memory(cast(*void) pbi.mt_vabove_row[i]);
                pbi.mt_vabove_row[i] = null;
            }
        }
        deallocate_memory(cast(*void) pbi.mt_vabove_row);
        pbi.mt_vabove_row = null;
    }

    if pbi.mt_yleft_col != null {
        if 0 < mb_rows {
            for i: 0..mb_rows - 1 {
                deallocate_memory(cast(*void) pbi.mt_yleft_col[i]);
                pbi.mt_yleft_col[i] = null;
            }
        }
        deallocate_memory(cast(*void) pbi.mt_yleft_col);
        pbi.mt_yleft_col = null;
    }

    if pbi.mt_uleft_col != null {
        if 0 < mb_rows {
            for i: 0..mb_rows - 1 {
                deallocate_memory(cast(*void) pbi.mt_uleft_col[i]);
                pbi.mt_uleft_col[i] = null;
            }
        }
        deallocate_memory(cast(*void) pbi.mt_uleft_col);
        pbi.mt_uleft_col = null;
    }

    if pbi.mt_vleft_col != null {
        if 0 < mb_rows {
            for i: 0..mb_rows - 1 {
                deallocate_memory(cast(*void) pbi.mt_vleft_col[i]);
                pbi.mt_vleft_col[i] = null;
            }
        }
        deallocate_memory(cast(*void) pbi.mt_vleft_col);
        pbi.mt_vleft_col = null;
    }
}

vp8_decoder_create_threads :: (pbi: *VP8_D_COMP) {
    core_count: s32 = 0;
    ithread: u32 = ---;

    atomic_init_in_threading(*pbi.b_multithreaded_rd, 0);
    pbi.allocated_decoding_thread_count = 0;

    core_count = ifx pbi.max_threads > 8 then 8 else pbi.max_threads;

    if core_count > pbi.common.processor_core_count {
        core_count = pbi.common.processor_core_count;
    }

    if core_count > 1 {
        atomic_init_in_threading(*pbi.b_multithreaded_rd, 1);
        pbi.decoding_thread_count = cast,no_check(u32) (core_count - 1);

        pbi.h_decoding_thread =
            cast(*Pthread_T) calloc_2(
                size_of(Pthread_T),
                cast,no_check(u64) pbi.decoding_thread_count
            );

        if pbi.h_decoding_thread == null {
            internal_error(
                *pbi.common.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate (pbi->h_decoding_thread)")
            );
        }
        pbi.h_event_start_decoding =
            cast(*Sem_T) calloc_2(
                size_of(Sem_T),
                cast,no_check(u64) pbi.decoding_thread_count
            );

        if pbi.h_event_start_decoding == null {
            internal_error(
                *pbi.common.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate (pbi->h_event_start_decoding)")
            );
        }
        pbi.mb_row_di =
            cast(*MB_ROW_DEC) memalign(
                32,
                size_of(MB_ROW_DEC) * cast(u64) pbi.decoding_thread_count
            );

        if pbi.mb_row_di == null {
            internal_error(
                *pbi.common.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate (pbi->mb_row_di)")
            );
        }

        fill_memory(pbi.mb_row_di, 0, cast,no_check(u64) pbi.decoding_thread_count * size_of(MB_ROW_DEC));
        pbi.de_thread_data =
            cast(*DECODETHREAD_DATA) calloc_2(
                size_of(DECODETHREAD_DATA),
                cast,no_check(u64) pbi.decoding_thread_count
            );

        if pbi.de_thread_data == null {
            internal_error(
                *pbi.common.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate (pbi->de_thread_data)")
            );
        }

        if sem_init(*pbi.h_event_end_decoding, 0, 0) != 0 {
            internal_error(
                *pbi.common.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to initialize semaphore")
            );
        }

        ithread = 0;
        while ithread < pbi.decoding_thread_count {
            if sem_init(*(cast(*Sem_T) (pbi.h_event_start_decoding))[ithread], 0, 0) != 0 {
                break;
            }

            vp8_setup_block_dptrs(*pbi.mb_row_di[ithread].mbd);

            pbi.de_thread_data[ithread].ithread = cast,no_check(s32) ithread;
            pbi.de_thread_data[ithread].ptr1 = cast(*void) pbi;
            pbi.de_thread_data[ithread].ptr2 = cast(*void) (*pbi.mb_row_di[ithread]);

            if c_transpiler_pthread_create(
                *pbi.h_decoding_thread[ithread],
                null,
                cast,no_check(#type (_: *void) -> *void) thread_decoding_proc,
                cast(*void) (*pbi.de_thread_data[ithread])
            ) != 0 {
                sem_destroy(*(cast(*Sem_T) (pbi.h_event_start_decoding))[ithread]);
                break;
            }
            ithread += 1;
        }

        pbi.allocated_decoding_thread_count = cast,no_check(s32) ithread;
        if pbi.allocated_decoding_thread_count != cast,no_check(s32) pbi.decoding_thread_count {
            if pbi.allocated_decoding_thread_count == 0 {
                sem_destroy(*pbi.h_event_end_decoding);
            }
            internal_error(
                *pbi.common.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to create threads")
            );
        }
    }
}

thread_decoding_proc :: (p_data: *void) -> *void {
    ithread := (cast(*DECODETHREAD_DATA) p_data).ithread;
    pbi := cast(*VP8_D_COMP) (cast(*DECODETHREAD_DATA) p_data).ptr1;
    mbrd := cast(*MB_ROW_DEC) (cast(*DECODETHREAD_DATA) p_data).ptr2;
    mb_row_left_context: ENTROPY_CONTEXT_PLANES = ---;

    while ((cast(s32) 1) != 0) {
        if atomic_load_acquire_in_threading(*pbi.b_multithreaded_rd) == 0 {
            break;
        }

        if vp8_sem_wait_in_threading(*(cast(*Sem_T) (pbi.h_event_start_decoding))[ithread]) == 0 {
            if atomic_load_acquire_in_threading(*pbi.b_multithreaded_rd) == 0 {
                break;
            } else {
                xd := *mbrd.mbd;
                xd.left_context = *mb_row_left_context;
                if setjmp_2(xd.error_info.jmp.data) != 0 {
                    xd.error_info.setjmp = 0;

                    sem_post(*pbi.h_event_end_decoding);
                    continue;
                }
                xd.error_info.setjmp = 1;
                mt_decode_mb_rows(pbi, xd, ithread + 1);
                xd.error_info.setjmp = 0;
            }
        }
    }

    return null;
}

vp8mt_alloc_temp_buffers :: (pbi: *VP8_D_COMP, width: s32, prev_mb_rows: s32) {
    PC := *pbi.common;
    i: s32 = ---;
    uv_width: s32 = ---;

    if atomic_load_acquire_in_threading(*pbi.b_multithreaded_rd) != 0 {
        vp8mt_de_alloc_temp_buffers(pbi, prev_mb_rows);

        if width & 0xf != 0 {
            width += 16 - width & 0xf;
        }

        if width < 640 {
            pbi.sync_range = 1;
        } else if width <= 1280 {
            pbi.sync_range = 8;
        } else if width <= 2560 {
            pbi.sync_range = 16;
        } else {
            pbi.sync_range = 32;
        }

        uv_width = width >> 1;

        pbi.mt_current_mb_col =
            cast(*Atomic_Int) allocate_memory(
                size_of(Atomic_Int) * cast,no_check(u64) PC.mb_rows
            );

        if pbi.mt_current_mb_col == null {
            internal_error(
                *PC.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate pbi->mt_current_mb_col")
            );
        }
        i = 0;
        while i < PC.mb_rows {
            atomic_init_in_threading(*(cast(*Atomic_Int) (pbi.mt_current_mb_col))[i], 0);
            i += 1;
        }

        pbi.mt_yabove_row = cast(**u8) calloc_2(size_of(*u8), cast,no_check(u64) PC.mb_rows);

        if pbi.mt_yabove_row == null {
            internal_error(
                *pbi.common.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate (pbi->mt_yabove_row)")
            );
        }
        i = 0;
        while i < PC.mb_rows {
            pbi.mt_yabove_row[i] = cast(*u8) memalign(16, cast,no_check(u64) (width + (cast(s32) 32) << 1));

            if pbi.mt_yabove_row[i] == null {
                internal_error(
                    *PC.error,
                    cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                    c_string("Failed to allocate pbi->mt_yabove_row[i]")
                );
            }
            fill_memory(pbi.mt_yabove_row[i], 0, cast,no_check(u64) (width + (cast(s32) 32) << 1));
            i += 1;
        }

        pbi.mt_uabove_row = cast(**u8) calloc_2(size_of(*u8), cast,no_check(u64) PC.mb_rows);

        if pbi.mt_uabove_row == null {
            internal_error(
                *pbi.common.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate (pbi->mt_uabove_row)")
            );
        }
        i = 0;
        while i < PC.mb_rows {
            pbi.mt_uabove_row[i] = cast(*u8) memalign(16, cast,no_check(u64) (uv_width + 32));

            if pbi.mt_uabove_row[i] == null {
                internal_error(
                    *PC.error,
                    cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                    c_string("Failed to allocate pbi->mt_uabove_row[i]")
                );
            }
            fill_memory(pbi.mt_uabove_row[i], 0, cast,no_check(u64) (uv_width + 32));
            i += 1;
        }

        pbi.mt_vabove_row = cast(**u8) calloc_2(size_of(*u8), cast,no_check(u64) PC.mb_rows);

        if pbi.mt_vabove_row == null {
            internal_error(
                *pbi.common.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate (pbi->mt_vabove_row)")
            );
        }
        i = 0;
        while i < PC.mb_rows {
            pbi.mt_vabove_row[i] = cast(*u8) memalign(16, cast,no_check(u64) (uv_width + 32));

            if pbi.mt_vabove_row[i] == null {
                internal_error(
                    *PC.error,
                    cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                    c_string("Failed to allocate pbi->mt_vabove_row[i]")
                );
            }
            fill_memory(pbi.mt_vabove_row[i], 0, cast,no_check(u64) (uv_width + 32));
            i += 1;
        }

        pbi.mt_yleft_col = cast(**u8) calloc_2(size_of(*u8), cast,no_check(u64) PC.mb_rows);

        if pbi.mt_yleft_col == null {
            internal_error(
                *pbi.common.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate (pbi->mt_yleft_col)")
            );
        }
        i = 0;
        while i < PC.mb_rows {
            pbi.mt_yleft_col[i] = cast(*u8) calloc_2(16, 1);

            if pbi.mt_yleft_col[i] == null {
                internal_error(
                    *PC.error,
                    cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                    c_string("Failed to allocate pbi->mt_yleft_col[i]")
                );
            }
            i += 1;
        }

        pbi.mt_uleft_col = cast(**u8) calloc_2(size_of(*u8), cast,no_check(u64) PC.mb_rows);

        if pbi.mt_uleft_col == null {
            internal_error(
                *pbi.common.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate (pbi->mt_uleft_col)")
            );
        }
        i = 0;
        while i < PC.mb_rows {
            pbi.mt_uleft_col[i] = cast(*u8) calloc_2(8, 1);

            if pbi.mt_uleft_col[i] == null {
                internal_error(
                    *PC.error,
                    cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                    c_string("Failed to allocate pbi->mt_uleft_col[i]")
                );
            }
            i += 1;
        }

        pbi.mt_vleft_col = cast(**u8) calloc_2(size_of(*u8), cast,no_check(u64) PC.mb_rows);

        if pbi.mt_vleft_col == null {
            internal_error(
                *pbi.common.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate (pbi->mt_vleft_col)")
            );
        }
        i = 0;
        while i < PC.mb_rows {
            pbi.mt_vleft_col[i] = cast(*u8) calloc_2(8, 1);

            if pbi.mt_vleft_col[i] == null {
                internal_error(
                    *PC.error,
                    cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                    c_string("Failed to allocate pbi->mt_vleft_col[i]")
                );
            }
            i += 1;
        }
    }
}

