codec_control_vp8_set_reference_in_decodeframe :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *Ref_Frame_T) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_copy_reference_in_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Ref_Frame_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_set_postproc_in_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Vp8_Postproc_Cfg_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_get_reference_in_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Vp9_Ref_Frame_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_last_ref_updates_in_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_frame_corrupted_in_decodeframe :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_last_ref_used_in_decodeframe :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vpxd_set_decryptor_in_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Decrypt_Init
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_set_decryptor_in_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Decrypt_Init
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_frame_size_in_decodeframe :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_display_size_in_decodeframe :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_bit_depth_in_decodeframe :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *u32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_set_byte_alignment_in_decodeframe :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_invert_tile_decode_order_in_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_set_skip_loop_filter_in_decodeframe :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_decode_svc_spatial_layer_in_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vpxd_get_last_quantizer_in_decodeframe :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_set_row_mt_in_decodeframe :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_set_loop_filter_opt_in_decodeframe :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

vp8dx_decode_bool_in_decodeframe :: (br: *BOOL_DECODER, probability: s32) -> s32 {
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

vp8_decode_value_in_decodeframe :: (br: *BOOL_DECODER, bits: s32) -> s32 {
    z: s32 = 0;

    bit := bits - 1;
    while bit >= 0 {
        z |= vp8dx_decode_bool_in_decodeframe(br, 0x80) << ((bit) & 31);
        bit -= 1;
    }

    return z;
}

vp8dx_bool_error_in_decodeframe :: (br: *BOOL_DECODER) -> s32 {
    if br.count > (cast,no_check(s32) (cast(u64) size_of(VP8_BD_VALUE))) * 8 && br.count < 0x40000000 {
        return 1;
    }

    return 0;
}

vp8_treed_read_in_decodeframe :: (R: *Vp8_Reader_in_treereader, t: *Vp8_Tree_Index, P: *Vp8_Prob) -> s32 {
    i: Vp8_Tree_Index = 0;

    while (ifx true { assignment_1: Vp8_Tree_Index = cast,no_check(Vp8_Tree_Index) (t[(cast(s32) i) + vp8dx_decode_bool_in_decodeframe(R, cast,no_check(s32) P[(cast(s32) i) >> 1])]); (i) = assignment_1; assignment_1; }) > 0 {
    }

    return -(cast,no_check(s32) i);
}

vp8_sem_wait_in_decodeframe :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_2: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_2; assignment_2; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init_in_decodeframe :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release_in_decodeframe :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

atomic_load_acquire_in_decodeframe :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_atomic_spin_wait_in_decodeframe :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire_in_decodeframe(last_row_current_mb_col) - NSYNC {
    }
}

vp8cx_init_de_quantizer :: (pbi: *VP8_D_COMP) {
    PC := *pbi.common;

    for q: 0..cast(s32) (127 + 1) - 1 {
        PC.y1dequant[q][0] = cast,no_check(s16) vp8_dc_quant(q, PC.y1dc_delta_q);
        PC.y2dequant[q][0] = cast,no_check(s16) vp8_dc2quant(q, PC.y2dc_delta_q);
        PC.u_vdequant[q][0] = cast,no_check(s16) vp8_dc_uv_quant(q, PC.uvdc_delta_q);

        PC.y1dequant[q][1] = cast,no_check(s16) vp8_ac_yquant(q);
        PC.y2dequant[q][1] = cast,no_check(s16) vp8_ac2quant(q, PC.y2ac_delta_q);
        PC.u_vdequant[q][1] = cast,no_check(s16) vp8_ac_uv_quant(q, PC.uvac_delta_q);
    }
}

vp8_mb_init_dequantizer :: (pbi: *VP8_D_COMP, xd: *MACROBLOCKD_in_blockd) {
    q_index: s32 = ---;
    mbmi := *xd.mode_info_context.mbmi;
    PC := *pbi.common;

    if xd.segmentation_enabled != 0 {
        if xd.mb_segment_abs_delta == 1 {
            q_index = cast,no_check(s32) xd.segment_feature_data[MB_LVL_ALT_Q][mbmi.segment_id];
        } else {
            q_index = PC.base_qindex + cast(s32) xd.segment_feature_data[MB_LVL_ALT_Q][mbmi.segment_id];
        }

        q_index = ifx q_index >= 0 then (ifx q_index <= 127 then q_index else 127) else 0;
    } else {
        q_index = PC.base_qindex;
    }

    xd.dequant_y1_dc[0] = 1;
    xd.dequant_y1[0] = PC.y1dequant[q_index][0];
    xd.dequant_y2[0] = PC.y2dequant[q_index][0];
    xd.dequant_uv[0] = PC.u_vdequant[q_index][0];

    if 1 < 16 {
        for i: 1..cast(s32) 16 - 1 {
            xd.dequant_y1[i] = PC.y1dequant[q_index][1];
            xd.dequant_y1_dc[i] = xd.dequant_y1[i];
            xd.dequant_y2[i] = PC.y2dequant[q_index][1];
            xd.dequant_uv[i] = PC.u_vdequant[q_index][1];
        }
    }
}

vp8_decode_frame :: (pbi: *VP8_D_COMP) -> s32 {
    BC := pbi.mbc.data + 8;
    PC := *pbi.common;
    XD := *pbi.mb;
    data := pbi.fragments.ptrs[0];
    DATA_SZ := pbi.fragments.sizes[0];
    data_end := data + DATA_SZ;
    first_partition_length_in_bytes: s32 = ---;

    i, j, k, l: s32 = ---;
    MB_FEATURE_DATA_BITS := VP8_MB_FEATURE_DATA_BITS.data;
    corrupt_tokens: s32 = 0;
    prev_independent_partitions := pbi.independent_partitions;

    yv12_fb_new := pbi.dec_fb_ref[INTRA_FRAME];

    XD.corrupted = 0;
    yv12_fb_new.corrupted = 0;

    if data_end - data < 3 {
        if pbi.ec_active == 0 {
            internal_error(*PC.error, cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME, c_string("Truncated packet"));
        }

        PC.frame_type = cast,no_check(FRAME_TYPE_in_alloccommon) INTER_FRAME_in_alloccommon;
        PC.version = 0;
        PC.show_frame = 1;
        first_partition_length_in_bytes = 0;
    } else {
        clear_buffer: [10] u8 = ---;
        clear := data;
        if pbi.decrypt_cb != null {
            n :=
                cast,no_check(s32) ((ifx clear_buffer.count < cast,no_check(u64) DATA_SZ then clear_buffer.count else cast,no_check(u64) DATA_SZ));
            pbi.decrypt_cb(pbi.decrypt_state, data, clear_buffer.data, n);
            clear = clear_buffer.data;
        }

        PC.frame_type = cast,no_check(FRAME_TYPE_in_alloccommon) ((cast(s32) clear[0]) & 1);
        PC.version = (cast(s32) clear[0]) >> 1 & 7;
        PC.show_frame = (cast(s32) clear[0]) >> 4 & 1;
        first_partition_length_in_bytes =
            (cast(s32) clear[0]) | ((cast(s32) clear[1]) << 8) | ((cast(s32) clear[2]) << 16) >> 5;

        if pbi.ec_active == 0 && first_partition_length_in_bytes == 0 {
            internal_error(
                *PC.error,
                cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                c_string("Corrupt partition 0 length")
            );
        }

        data += 3;
        clear += 3;

        vp8_setup_version(PC);

        if PC.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
            if data_end - data >= 7 {
                if clear[0] != 0x9d || clear[1] != 0x1 || clear[2] != 0x2a {
                    internal_error(
                        *PC.error,
                        cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM,
                        c_string("Invalid frame sync code")
                    );
                }

                PC.width = (cast(s32) clear[3]) | ((cast(s32) clear[4]) << 8) & 0x3fff;
                PC.horiz_scale = (cast(s32) clear[4]) >> 6;
                PC.height = (cast(s32) clear[5]) | ((cast(s32) clear[6]) << 8) & 0x3fff;
                PC.vert_scale = (cast(s32) clear[6]) >> 6;
                data += 7;
            } else if pbi.ec_active == 0 {
                internal_error(
                    *PC.error,
                    cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                    c_string("Truncated key frame header")
                );
            } else {
                data = data_end;
            }
        } else {
            XD.pre = yv12_fb_new.*;
            XD.dst = yv12_fb_new.*;
        }
    }
    if pbi.decoded_key_frame == 0 && PC.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
        return -1;
    }

    if pbi.ec_active == 0 && data_end - data < cast,no_check(s64) first_partition_length_in_bytes {
        internal_error(
            *PC.error,
            cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
            c_string("Truncated packet or corrupt partition 0 length")
        );
    }

    init_frame(pbi);

    if (cast,no_check(#type (_: *BOOL_DECODER, _: *u8, _: u32, _: Decrypt_Cb, _: *void) -> s32) (cast(*void) vp8dx_start_decode))(
        BC,
        data,
        cast,no_check(u32) (data_end - data),
        pbi.decrypt_cb,
        pbi.decrypt_state
    ) != 0 {
        internal_error(
            *PC.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate bool decoder 0")
        );
    }
    if PC.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
        vp8dx_decode_bool_in_decodeframe(BC, cast,no_check(s32) (cast(Vp8_Prob) 128));
        PC.clamp_type =
            cast,no_check(CLAMP_TYPE) vp8dx_decode_bool_in_decodeframe(
                BC,
                cast,no_check(s32) (cast(Vp8_Prob) 128)
            );
    }

    XD.segmentation_enabled =
        cast,no_check(u8) vp8dx_decode_bool_in_decodeframe(
            BC,
            cast,no_check(s32) (cast(Vp8_Prob) 128)
        );

    if XD.segmentation_enabled != 0 {
        XD.update_mb_segmentation_map =
            cast,no_check(u8) vp8dx_decode_bool_in_decodeframe(
                BC,
                cast,no_check(s32) (cast(Vp8_Prob) 128)
            );
        XD.update_mb_segmentation_data =
            cast,no_check(u8) vp8dx_decode_bool_in_decodeframe(
                BC,
                cast,no_check(s32) (cast(Vp8_Prob) 128)
            );

        if XD.update_mb_segmentation_data != 0 {
            XD.mb_segment_abs_delta =
                cast,no_check(u8) vp8dx_decode_bool_in_decodeframe(
                    BC,
                    cast,no_check(s32) (cast(Vp8_Prob) 128)
                );

            fill_memory(XD.segment_feature_data.data, 0, XD.segment_feature_data.count * size_of([4] s8));

            i = 0;
            while i < MB_LVL_MAX {
                j = 0;
                while j < 4 {
                    if vp8dx_decode_bool_in_decodeframe(BC, cast,no_check(s32) (cast(Vp8_Prob) 128)) != 0 {
                        XD.segment_feature_data[i][j] =
                            cast,no_check(s8) vp8_decode_value_in_decodeframe(
                                BC,
                                MB_FEATURE_DATA_BITS[i]
                            );

                        if vp8dx_decode_bool_in_decodeframe(BC, cast,no_check(s32) (cast(Vp8_Prob) 128)) != 0 {
                            XD.segment_feature_data[i][j] =
                                cast,no_check(s8) (-(cast,no_check(s32) XD.segment_feature_data[i][j]));
                        }
                    } else {
                        XD.segment_feature_data[i][j] = 0;
                    }
                    j += 1;
                }
                i += 1;
            }
        }

        if XD.update_mb_segmentation_map != 0 {
            fill_memory(XD.mb_segment_tree_probs.data, 255, XD.mb_segment_tree_probs.count);

            i = 0;
            while i < 3 {
                if vp8dx_decode_bool_in_decodeframe(BC, cast,no_check(s32) (cast(Vp8_Prob) 128)) != 0 {
                    XD.mb_segment_tree_probs[i] = cast,no_check(Vp8_Prob) vp8_decode_value_in_decodeframe(BC, 8);
                }
                i += 1;
            }
        }
    } else {
        XD.update_mb_segmentation_map = 0;
        XD.update_mb_segmentation_data = 0;
    }

    PC.filter_type =
        cast,no_check(LOOPFILTERTYPE) vp8dx_decode_bool_in_decodeframe(
            BC,
            cast,no_check(s32) (cast(Vp8_Prob) 128)
        );
    PC.filter_level = vp8_decode_value_in_decodeframe(BC, 6);
    PC.sharpness_level = vp8_decode_value_in_decodeframe(BC, 3);

    XD.mode_ref_lf_delta_update = 0;
    XD.mode_ref_lf_delta_enabled =
        cast,no_check(u8) vp8dx_decode_bool_in_decodeframe(
            BC,
            cast,no_check(s32) (cast(Vp8_Prob) 128)
        );

    if XD.mode_ref_lf_delta_enabled != 0 {
        XD.mode_ref_lf_delta_update =
            cast,no_check(u8) vp8dx_decode_bool_in_decodeframe(
                BC,
                cast,no_check(s32) (cast(Vp8_Prob) 128)
            );

        if XD.mode_ref_lf_delta_update != 0 {
            i = 0;
            while i < 4 {
                if vp8dx_decode_bool_in_decodeframe(BC, cast,no_check(s32) (cast(Vp8_Prob) 128)) != 0 {
                    XD.ref_lf_deltas[i] = cast,no_check(s8) vp8_decode_value_in_decodeframe(BC, 6);

                    if vp8dx_decode_bool_in_decodeframe(BC, cast,no_check(s32) (cast(Vp8_Prob) 128)) != 0 {
                        XD.ref_lf_deltas[i] = cast,no_check(s8) ((cast(s32) XD.ref_lf_deltas[i]) * -1);
                    }
                }
                i += 1;
            }

            i = 0;
            while i < 4 {
                if vp8dx_decode_bool_in_decodeframe(BC, cast,no_check(s32) (cast(Vp8_Prob) 128)) != 0 {
                    XD.mode_lf_deltas[i] = cast,no_check(s8) vp8_decode_value_in_decodeframe(BC, 6);

                    if vp8dx_decode_bool_in_decodeframe(BC, cast,no_check(s32) (cast(Vp8_Prob) 128)) != 0 {
                        XD.mode_lf_deltas[i] = cast,no_check(s8) ((cast(s32) XD.mode_lf_deltas[i]) * -1);
                    }
                }
                i += 1;
            }
        }
    }

    setup_token_decoder(pbi, data + first_partition_length_in_bytes);

    XD.current_bc = cast(*void) (pbi.mbc.data + 0);

    {
        q: s32 = ---;

        q = vp8_decode_value_in_decodeframe(BC, 7);
        PC.base_qindex = q;
        q_update: s32 = 0;
        PC.y1dc_delta_q = get_delta_q(BC, PC.y1dc_delta_q, *q_update);
        PC.y2dc_delta_q = get_delta_q(BC, PC.y2dc_delta_q, *q_update);
        PC.y2ac_delta_q = get_delta_q(BC, PC.y2ac_delta_q, *q_update);
        PC.uvdc_delta_q = get_delta_q(BC, PC.uvdc_delta_q, *q_update);
        PC.uvac_delta_q = get_delta_q(BC, PC.uvac_delta_q, *q_update);

        if q_update != 0 {
            vp8cx_init_de_quantizer(pbi);
        }

        vp8_mb_init_dequantizer(pbi, *pbi.mb);
    }

    if PC.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
        PC.refresh_golden_frame = vp8dx_decode_bool_in_decodeframe(BC, cast,no_check(s32) (cast(Vp8_Prob) 128));

        PC.refresh_alt_ref_frame = vp8dx_decode_bool_in_decodeframe(BC, cast,no_check(s32) (cast(Vp8_Prob) 128));

        PC.copy_buffer_to_gf = 0;

        if PC.refresh_golden_frame == 0 {
            PC.copy_buffer_to_gf = vp8_decode_value_in_decodeframe(BC, 2);
        }

        PC.copy_buffer_to_arf = 0;

        if PC.refresh_alt_ref_frame == 0 {
            PC.copy_buffer_to_arf = vp8_decode_value_in_decodeframe(BC, 2);
        }

        PC.ref_frame_sign_bias[GOLDEN_FRAME] =
            vp8dx_decode_bool_in_decodeframe(
                BC,
                cast,no_check(s32) (cast(Vp8_Prob) 128)
            );
        PC.ref_frame_sign_bias[ALTREF_FRAME] =
            vp8dx_decode_bool_in_decodeframe(
                BC,
                cast,no_check(s32) (cast(Vp8_Prob) 128)
            );
    }

    PC.refresh_entropy_probs = vp8dx_decode_bool_in_decodeframe(BC, cast,no_check(s32) (cast(Vp8_Prob) 128));

    if PC.refresh_entropy_probs == 0 {
        PC.lfc = PC.fc;
    }

    PC.refresh_last_frame =
        cast(s32) (PC.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon ||
            vp8dx_decode_bool_in_decodeframe(BC, cast,no_check(s32) (cast(Vp8_Prob) 128)) != 0);

    pbi.independent_partitions = 1;

    i = 0;
    while i < 4 {
        j = 0;
        while j < 8 {
            k = 0;
            while k < 3 {
                l = 0;
                while l < 11 {
                    P := PC.fc.coef_probs[i][j][k].data + l;

                    if vp8dx_decode_bool_in_decodeframe(BC, cast,no_check(s32) VP8_COEF_UPDATE_PROBS[i][j][k][l]) != 0 {
                        P.* = cast,no_check(Vp8_Prob) vp8_decode_value_in_decodeframe(BC, 8);
                    }
                    if k > 0 && P.* != PC.fc.coef_probs[i][j][k - 1][l] {
                        pbi.independent_partitions = 0;
                    }
                    l += 1;
                }
                k += 1;
            }
            j += 1;
        }
        i += 1;
    }

    fill_memory(XD.qcoeff.data, 0, XD.qcoeff.count * size_of(s16));

    vp8_decode_mode_mvs(pbi);

    fill_memory(PC.above_context, 0, size_of(ENTROPY_CONTEXT_PLANES) * cast,no_check(u64) PC.mb_cols);
    pbi.frame_corrupt_residual = 0;

    if atomic_load_acquire_in_decodeframe(*pbi.b_multithreaded_rd) != 0 &&
        PC.multi_token_partition != cast,no_check(u32) ONE_PARTITION {
        if vp8mt_decode_mb_rows(pbi, XD) != 0 {
            vp8_decoder_remove_threads(pbi);
            pbi.restart_threads = 1;
            internal_error(*pbi.common.error, cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME, null);
        }
        vp8_yv12_extend_frame_borders_c(yv12_fb_new);
        thread: u32 = 0;
        while thread < pbi.decoding_thread_count {
            corrupt_tokens |= pbi.mb_row_di[thread].mbd.corrupted;
            thread += 1;
        }
    } else {
        decode_mb_rows(pbi);
        corrupt_tokens |= XD.corrupted;
    }

    yv12_fb_new.corrupted = vp8dx_bool_error_in_decodeframe(BC);

    yv12_fb_new.corrupted |= corrupt_tokens;

    if pbi.decoded_key_frame == 0 {
        if PC.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon && yv12_fb_new.corrupted == 0 {
            pbi.decoded_key_frame = 1;
        } else {
            internal_error(
                *pbi.common.error,
                cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                c_string("A stream must start with a complete key frame")
            );
        }
    }

    if PC.refresh_entropy_probs == 0 {
        PC.fc = PC.lfc;
        pbi.independent_partitions = prev_independent_partitions;
    }

    return 0;
}

decode_mb_rows :: (pbi: *VP8_D_COMP) {
    PC := *pbi.common;
    XD := *pbi.mb;

    lf_mic := XD.mode_info_context;

    ibc: s32 = 0;
    num_part := (cast(s32) 1) << ((PC.multi_token_partition) & 31);
    mb_col: s32 = ---;
    mb_idx: s32 = 0;

    yv12_fb_new := pbi.dec_fb_ref[INTRA_FRAME];

    recon_y_stride := yv12_fb_new.y_stride;
    recon_uv_stride := yv12_fb_new.uv_stride;

    ref_buffer: [4] [3] *u8 = ---;
    dst_buffer: [3] *u8 = ---;
    lf_dst: [3] *u8 = ---;
    eb_dst: [3] *u8 = ---;

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
    lf_dst[0] = dst_buffer[0];
    eb_dst[0] = lf_dst[0];
    dst_buffer[1] = yv12_fb_new.u_buffer;
    lf_dst[1] = dst_buffer[1];
    eb_dst[1] = lf_dst[1];
    dst_buffer[2] = yv12_fb_new.v_buffer;
    lf_dst[2] = dst_buffer[2];
    eb_dst[2] = lf_dst[2];

    XD.up_available = 0;

    if PC.filter_level != 0 {
        vp8_loop_filter_frame_init(PC, XD, PC.filter_level);
    }

    vp8_setup_intra_recon_top_line(yv12_fb_new);

    mb_row: s32 = 0;
    while mb_row < PC.mb_rows {
        if num_part > 1 {
            XD.current_bc = cast(*void) (pbi.mbc.data + ibc);
            ibc += 1;

            if ibc == num_part {
                ibc = 0;
            }
        }

        recon_yoffset := mb_row * recon_y_stride * 16;
        recon_uvoffset := mb_row * recon_uv_stride * 8;

        XD.above_context = PC.above_context;
        fill_memory(XD.left_context, 0, size_of(ENTROPY_CONTEXT_PLANES));

        XD.left_available = 0;

        XD.mb_to_top_edge = -((mb_row * 16) << 3);
        XD.mb_to_bottom_edge = ((PC.mb_rows - 1 - mb_row) * 16) << 3;

        XD.recon_above[0] = dst_buffer[0] + recon_yoffset;
        XD.recon_above[1] = dst_buffer[1] + recon_uvoffset;
        XD.recon_above[2] = dst_buffer[2] + recon_uvoffset;

        XD.recon_left[0] = XD.recon_above[0] - 1;
        XD.recon_left[1] = XD.recon_above[1] - 1;
        XD.recon_left[2] = XD.recon_above[2] - 1;

        XD.recon_above[0] -= XD.dst.y_stride;
        XD.recon_above[1] -= XD.dst.uv_stride;
        XD.recon_above[2] -= XD.dst.uv_stride;

        XD.recon_left_stride[0] = XD.dst.y_stride;
        XD.recon_left_stride[1] = XD.dst.uv_stride;

        setup_intra_recon_left_in_decodeframe(
            XD.recon_left[0],
            XD.recon_left[1],
            XD.recon_left[2],
            XD.dst.y_stride,
            XD.dst.uv_stride
        );

        mb_col = 0;
        while mb_col < PC.mb_cols {
            XD.mb_to_left_edge = -((mb_col * 16) << 3);
            XD.mb_to_right_edge = ((PC.mb_cols - 1 - mb_col) * 16) << 3;

            XD.dst.y_buffer = dst_buffer[0] + recon_yoffset;
            XD.dst.u_buffer = dst_buffer[1] + recon_uvoffset;
            XD.dst.v_buffer = dst_buffer[2] + recon_uvoffset;

            if XD.mode_info_context.mbmi.ref_frame >= cast,no_check(u8) LAST_FRAME {
                REF := cast,no_check(MV_REFERENCE_FRAME_in_alloccommon) XD.mode_info_context.mbmi.ref_frame;
                XD.pre.y_buffer = ref_buffer[REF][0] + recon_yoffset;
                XD.pre.u_buffer = ref_buffer[REF][1] + recon_uvoffset;
                XD.pre.v_buffer = ref_buffer[REF][2] + recon_uvoffset;
            } else {
                XD.pre.y_buffer = null;
                XD.pre.u_buffer = null;
                XD.pre.v_buffer = null;
            }

            XD.corrupted |= ref_fb_corrupted[XD.mode_info_context.mbmi.ref_frame];

            decode_macroblock(pbi, XD, cast,no_check(u32) mb_idx);

            mb_idx += 1;
            XD.left_available = 1;

            XD.corrupted |= vp8dx_bool_error_in_decodeframe(cast(*BOOL_DECODER) XD.current_bc);

            XD.recon_above[0] += 16;
            XD.recon_above[1] += 8;
            XD.recon_above[2] += 8;
            XD.recon_left[0] += 16;
            XD.recon_left[1] += 8;
            XD.recon_left[2] += 8;

            recon_yoffset += 16;
            recon_uvoffset += 8;

            XD.mode_info_context += 1;

            XD.above_context += 1;
            mb_col += 1;
        }

        vp8_extend_mb_row(yv12_fb_new, XD.dst.y_buffer + 16, XD.dst.u_buffer + 8, XD.dst.v_buffer + 8);

        XD.mode_info_context += 1;
        XD.up_available = 1;

        if PC.filter_level != 0 {
            if mb_row > 0 {
                if PC.filter_type == cast,no_check(u32) NORMAL_LOOPFILTER {
                    vp8_loop_filter_row_normal(
                        PC,
                        lf_mic,
                        mb_row - 1,
                        recon_y_stride,
                        recon_uv_stride,
                        lf_dst[0],
                        lf_dst[1],
                        lf_dst[2]
                    );
                } else {
                    vp8_loop_filter_row_simple(PC, lf_mic, mb_row - 1, recon_y_stride, lf_dst[0]);
                }
                if mb_row > 1 {
                    yv12_extend_frame_left_right_c(yv12_fb_new, eb_dst[0], eb_dst[1], eb_dst[2]);

                    eb_dst[0] += recon_y_stride * 16;
                    eb_dst[1] += recon_uv_stride * 8;
                    eb_dst[2] += recon_uv_stride * 8;
                }

                lf_dst[0] += recon_y_stride * 16;
                lf_dst[1] += recon_uv_stride * 8;
                lf_dst[2] += recon_uv_stride * 8;
                lf_mic += PC.mb_cols;
                lf_mic += 1;
            }
        } else if mb_row > 0 {
            yv12_extend_frame_left_right_c(yv12_fb_new, eb_dst[0], eb_dst[1], eb_dst[2]);
            eb_dst[0] += recon_y_stride * 16;
            eb_dst[1] += recon_uv_stride * 8;
            eb_dst[2] += recon_uv_stride * 8;
        }
        mb_row += 1;
    }

    if PC.filter_level != 0 {
        if PC.filter_type == cast,no_check(u32) NORMAL_LOOPFILTER {
            vp8_loop_filter_row_normal(
                PC,
                lf_mic,
                mb_row - 1,
                recon_y_stride,
                recon_uv_stride,
                lf_dst[0],
                lf_dst[1],
                lf_dst[2]
            );
        } else {
            vp8_loop_filter_row_simple(PC, lf_mic, mb_row - 1, recon_y_stride, lf_dst[0]);
        }

        yv12_extend_frame_left_right_c(yv12_fb_new, eb_dst[0], eb_dst[1], eb_dst[2]);
        eb_dst[0] += recon_y_stride * 16;
        eb_dst[1] += recon_uv_stride * 8;
        eb_dst[2] += recon_uv_stride * 8;
    }
    yv12_extend_frame_left_right_c(yv12_fb_new, eb_dst[0], eb_dst[1], eb_dst[2]);
    yv12_extend_frame_top_c(yv12_fb_new);
    yv12_extend_frame_bottom_c(yv12_fb_new);
}

yv12_extend_frame_bottom_c :: (ybf: *YV12_BUFFER_CONFIG) {
    border := cast,no_check(u32) ybf.border;
    plane_stride := ybf.y_stride;
    plane_height := ybf.y_height;

    src_ptr1 := ybf.y_buffer - border;
    src_ptr2 := src_ptr1 + plane_height * plane_stride - plane_stride;
    dest_ptr2 := src_ptr2 + plane_stride;

    i: s32 = 0;
    while i < cast,no_check(s32) border {
        copy_memory(dest_ptr2, src_ptr2, cast,no_check(u64) plane_stride);
        dest_ptr2 += plane_stride;
        i += 1;
    }

    plane_stride = ybf.uv_stride;
    plane_height = ybf.uv_height;
    border /= 2;

    src_ptr1 = ybf.u_buffer - border;
    src_ptr2 = src_ptr1 + plane_height * plane_stride - plane_stride;
    dest_ptr2 = src_ptr2 + plane_stride;

    i = 0;
    while i < cast,no_check(s32) border {
        copy_memory(dest_ptr2, src_ptr2, cast,no_check(u64) plane_stride);
        dest_ptr2 += plane_stride;
        i += 1;
    }

    src_ptr1 = ybf.v_buffer - border;
    src_ptr2 = src_ptr1 + plane_height * plane_stride - plane_stride;
    dest_ptr2 = src_ptr2 + plane_stride;

    i = 0;
    while i < cast,no_check(s32) border {
        copy_memory(dest_ptr2, src_ptr2, cast,no_check(u64) plane_stride);
        dest_ptr2 += plane_stride;
        i += 1;
    }
}

yv12_extend_frame_top_c :: (ybf: *YV12_BUFFER_CONFIG) {
    border := cast,no_check(u32) ybf.border;
    plane_stride := ybf.y_stride;
    src_ptr1 := ybf.y_buffer - border;
    dest_ptr1 := src_ptr1 - border * cast,no_check(u32) plane_stride;

    i: s32 = 0;
    while i < cast,no_check(s32) border {
        copy_memory(dest_ptr1, src_ptr1, cast,no_check(u64) plane_stride);
        dest_ptr1 += plane_stride;
        i += 1;
    }

    plane_stride = ybf.uv_stride;
    border /= 2;
    src_ptr1 = ybf.u_buffer - border;
    dest_ptr1 = src_ptr1 - border * cast,no_check(u32) plane_stride;

    i = 0;
    while i < cast,no_check(s32) border {
        copy_memory(dest_ptr1, src_ptr1, cast,no_check(u64) plane_stride);
        dest_ptr1 += plane_stride;
        i += 1;
    }

    src_ptr1 = ybf.v_buffer - border;
    dest_ptr1 = src_ptr1 - border * cast,no_check(u32) plane_stride;

    i = 0;
    while i < cast,no_check(s32) border {
        copy_memory(dest_ptr1, src_ptr1, cast,no_check(u64) plane_stride);
        dest_ptr1 += plane_stride;
        i += 1;
    }
}

yv12_extend_frame_left_right_c :: (ybf: *YV12_BUFFER_CONFIG, y_src: *u8, u_src: *u8, v_src: *u8) {
    border := cast,no_check(u32) ybf.border;
    plane_stride := ybf.y_stride;
    plane_height: s32 = 16;
    plane_width := ybf.y_width;

    src_ptr1 := y_src;
    src_ptr2 := src_ptr1 + plane_width - 1;
    dest_ptr1 := src_ptr1 - border;
    dest_ptr2 := src_ptr2 + 1;

    if 0 < plane_height {
        for i: 0..plane_height - 1 {
            fill_memory(dest_ptr1, cast,no_check(s32) src_ptr1[0], cast,no_check(u64) border);
            fill_memory(dest_ptr2, cast,no_check(s32) src_ptr2[0], cast,no_check(u64) border);
            src_ptr1 += plane_stride;
            src_ptr2 += plane_stride;
            dest_ptr1 += plane_stride;
            dest_ptr2 += plane_stride;
        }
    }

    plane_stride = ybf.uv_stride;
    plane_height = 8;
    plane_width = ybf.uv_width;
    border /= 2;

    src_ptr1 = u_src;
    src_ptr2 = src_ptr1 + plane_width - 1;
    dest_ptr1 = src_ptr1 - border;
    dest_ptr2 = src_ptr2 + 1;

    if 0 < plane_height {
        for i: 0..plane_height - 1 {
            fill_memory(dest_ptr1, cast,no_check(s32) src_ptr1[0], cast,no_check(u64) border);
            fill_memory(dest_ptr2, cast,no_check(s32) src_ptr2[0], cast,no_check(u64) border);
            src_ptr1 += plane_stride;
            src_ptr2 += plane_stride;
            dest_ptr1 += plane_stride;
            dest_ptr2 += plane_stride;
        }
    }

    src_ptr1 = v_src;
    src_ptr2 = src_ptr1 + plane_width - 1;
    dest_ptr1 = src_ptr1 - border;
    dest_ptr2 = src_ptr2 + 1;

    if 0 < plane_height {
        for i: 0..plane_height - 1 {
            fill_memory(dest_ptr1, cast,no_check(s32) src_ptr1[0], cast,no_check(u64) border);
            fill_memory(dest_ptr2, cast,no_check(s32) src_ptr2[0], cast,no_check(u64) border);
            src_ptr1 += plane_stride;
            src_ptr2 += plane_stride;
            dest_ptr1 += plane_stride;
            dest_ptr2 += plane_stride;
        }
    }
}

decode_macroblock :: (pbi: *VP8_D_COMP, xd: *MACROBLOCKD_in_blockd, mb_idx: u32) {
    if xd.mode_info_context.mbmi.mb_skip_coeff != 0 {
        vp8_reset_mb_tokens_context(xd);
    } else if vp8dx_bool_error_in_decodeframe(cast(*BOOL_DECODER) xd.current_bc) == 0 {
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

            intra_prediction_down_copy_in_decodeframe(xd, xd.recon_above[0] + 16);

            for i: 0..cast(s32) 16 - 1 {
                b := xd.block.data + i;
                dst: *u8 = xd.dst.y_buffer + b.offset;
                b_mode := xd.mode_info_context.bmi[i].as_mode;
                above := dst - dst_stride;
                yleft := dst - 1;
                left_stride := dst_stride;
                top_left := above[-1];

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

intra_prediction_down_copy_in_decodeframe :: (xd: *MACROBLOCKD_in_blockd, above_right_src: *u8) {
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

setup_intra_recon_left_in_decodeframe :: (y_buffer: *u8, u_buffer: *u8, v_buffer: *u8, y_stride: s32, uv_stride: s32) {
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

get_delta_q :: (bc: *Vp8_Reader_in_treereader, prev: s32, q_update: *s32) -> s32 {
    ret_val: s32 = 0;

    if vp8dx_decode_bool_in_decodeframe(bc, cast,no_check(s32) (cast(Vp8_Prob) 128)) != 0 {
        ret_val = vp8_decode_value_in_decodeframe(bc, 4);

        if vp8dx_decode_bool_in_decodeframe(bc, cast,no_check(s32) (cast(Vp8_Prob) 128)) != 0 {
            ret_val = -ret_val;
        }
    }

    if ret_val != prev {
        q_update.* = 1;
    }

    return ret_val;
}

setup_token_decoder :: (pbi: *VP8_D_COMP, token_part_sizes: *u8) {
    bool_decoder := pbi.mbc.data + 0;

    first_fragment_end := pbi.fragments.ptrs[0] + pbi.fragments.sizes[0];

    multi_token_partition :=
        cast,no_check(TOKEN_PARTITION) vp8_decode_value_in_decodeframe(
            pbi.mbc.data + 8,
            2
        );
    if vp8dx_bool_error_in_decodeframe(pbi.mbc.data + 8) == 0 {
        pbi.common.multi_token_partition = multi_token_partition;
    }
    num_token_partitions := cast,no_check(u32) ((cast(s32) 1) << ((pbi.common.multi_token_partition) & 31));

    fragment_idx: u32 = 0;
    while fragment_idx < pbi.fragments.count {
        fragment_size := pbi.fragments.sizes[fragment_idx];
        fragment_end := pbi.fragments.ptrs[fragment_idx] + fragment_size;

        if fragment_idx == 0 {
            ext_first_part_size :=
                token_part_sizes - pbi.fragments.ptrs[0] +
                    cast(s64) (3 * (num_token_partitions - 1));
            if fragment_size < cast,no_check(u32) ext_first_part_size {
                internal_error(
                    *pbi.common.error,
                    cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                    c_string("Corrupted fragment size %d"),
                    fragment_size
                );
            }
            fragment_size -= cast,no_check(u32) ext_first_part_size;
            if fragment_size > 0 {
                pbi.fragments.sizes[0] = cast,no_check(u32) ext_first_part_size;

                fragment_idx += 1;
                pbi.fragments.ptrs[fragment_idx] = pbi.fragments.ptrs[0] + pbi.fragments.sizes[0];
            }
        }

        while fragment_size > 0 {
            partition_size :=
                cast,no_check(s64) read_available_partition_size(
                    pbi,
                    token_part_sizes,
                    pbi.fragments.ptrs[fragment_idx],
                    first_fragment_end,
                    fragment_end,
                    cast,no_check(s32) (fragment_idx - 1),
                    cast,no_check(s32) num_token_partitions
                );
            pbi.fragments.sizes[fragment_idx] = cast,no_check(u32) partition_size;
            if fragment_size < cast,no_check(u32) partition_size {
                internal_error(
                    *pbi.common.error,
                    cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                    c_string("Corrupted fragment size %d"),
                    fragment_size
                );
            }
            fragment_size -= cast,no_check(u32) partition_size;

            if fragment_size > 0 {
                fragment_idx += 1;
                pbi.fragments.ptrs[fragment_idx] = pbi.fragments.ptrs[fragment_idx - 1] + partition_size;
            }
        }
        fragment_idx += 1;
    }

    pbi.fragments.count = num_token_partitions + 1;

    partition_idx: u32 = 1;
    while partition_idx < pbi.fragments.count {
        if (cast,no_check(#type (_: *BOOL_DECODER, _: *u8, _: u32, _: Decrypt_Cb, _: *void) -> s32) (cast(*void) vp8dx_start_decode))(
            bool_decoder,
            pbi.fragments.ptrs[partition_idx],
            pbi.fragments.sizes[partition_idx],
            pbi.decrypt_cb,
            pbi.decrypt_state
        ) != 0 {
            internal_error(
                *pbi.common.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate bool decoder %d"),
                partition_idx
            );
        }

        bool_decoder += 1;
        partition_idx += 1;
    }

    if pbi.decoding_thread_count > num_token_partitions - 1 {
        pbi.decoding_thread_count = num_token_partitions - 1;
    }
    if cast,no_check(s32) pbi.decoding_thread_count > pbi.common.mb_rows - 1 {
        pbi.decoding_thread_count = cast,no_check(u32) (pbi.common.mb_rows - 1);
    }
}

read_available_partition_size :: (
    pbi: *VP8_D_COMP,
    token_part_sizes: *u8,
    fragment_start: *u8,
    first_fragment_end: *u8,
    fragment_end: *u8,
    i: s32,
    num_part: s32
) -> u32 {
    pc := *pbi.common;
    partition_size_ptr := token_part_sizes + i * 3;
    partition_size: u32 = 0;
    bytes_left := fragment_end - fragment_start;
    if bytes_left < 0 {
        internal_error(
            *pc.error,
            cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
            c_string("Truncated packet or corrupt partition. No bytes left %d."),
            cast,no_check(s32) bytes_left
        );
    }

    if i < num_part - 1 {
        if read_is_valid(partition_size_ptr, 3, first_fragment_end) != 0 {
            partition_size = read_partition_size(pbi, partition_size_ptr);
        } else if pbi.ec_active != 0 {
            partition_size = cast,no_check(u32) bytes_left;
        } else {
            internal_error(
                *pc.error,
                cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                c_string("Truncated partition size data")
            );
        }
    } else {
        partition_size = cast,no_check(u32) bytes_left;
    }

    if read_is_valid(fragment_start, cast,no_check(u64) partition_size, fragment_end) == 0 {
        if pbi.ec_active != 0 {
            partition_size = cast,no_check(u32) bytes_left;
        } else {
            internal_error(
                *pc.error,
                cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                c_string("Truncated packet or corrupt partition %d length"),
                i + 1
            );
        }
    }
    return partition_size;
}

read_is_valid :: (start: *u8, len: u64, end: *u8) -> s32 {
    if len != 0 && end > start && len <= cast,no_check(u64) (end - start) {
        return 1;
    }
    return 0;
}

read_partition_size :: (pbi: *VP8_D_COMP, cx_size: *u8) -> u32 {
    temp: [3] u8 = ---;
    if pbi.decrypt_cb != null {
        pbi.decrypt_cb(pbi.decrypt_state, cx_size, temp.data, 3);
        cx_size = temp.data;
    }
    return cast,no_check(u32) ((cast(s32) cx_size[0]) + (cast(s32) cx_size[1]) << 8 + (cast(s32) cx_size[2]) << 16);
}

init_frame :: (pbi: *VP8_D_COMP) {
    PC := *pbi.common;
    XD := *pbi.mb;

    if PC.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
        copy_memory(PC.fc.mvc.data, VP8_DEFAULT_MV_CONTEXT.data, VP8_DEFAULT_MV_CONTEXT.count * size_of(MV_CONTEXT));

        vp8_init_mbmode_probs(PC);

        vp8_default_coef_probs(PC);

        fill_memory(XD.segment_feature_data.data, 0, XD.segment_feature_data.count * size_of([4] s8));
        XD.mb_segment_abs_delta = 0;

        fill_memory(XD.ref_lf_deltas.data, 0, XD.ref_lf_deltas.count);
        fill_memory(XD.mode_lf_deltas.data, 0, XD.mode_lf_deltas.count);

        PC.refresh_golden_frame = 1;
        PC.refresh_alt_ref_frame = 1;
        PC.copy_buffer_to_gf = 0;
        PC.copy_buffer_to_arf = 0;

        PC.ref_frame_sign_bias[GOLDEN_FRAME] = 0;
        PC.ref_frame_sign_bias[ALTREF_FRAME] = 0;
    } else {
        if PC.use_bilinear_mc_filter == 0 {
            XD.subpixel_predict = vp8_sixtap_predict4x4_c;
            XD.subpixel_predict8x4 = vp8_sixtap_predict8x4_c;
            XD.subpixel_predict8x8 = vp8_sixtap_predict8x8_c;
            XD.subpixel_predict16x16 = vp8_sixtap_predict16x16_c;
        } else {
            XD.subpixel_predict = vp8_bilinear_predict4x4_c;
            XD.subpixel_predict8x4 = vp8_bilinear_predict8x4_c;
            XD.subpixel_predict8x8 = vp8_bilinear_predict8x8_c;
            XD.subpixel_predict16x16 = vp8_bilinear_predict16x16_c;
        }

        if pbi.decoded_key_frame != 0 && pbi.ec_enabled != 0 && pbi.ec_active == 0 {
            pbi.ec_active = 1;
        }
    }

    XD.left_context = *PC.left_context;
    XD.mode_info_context = PC.mi;
    XD.frame_type = PC.frame_type;
    XD.mode_info_context.mbmi.mode = cast,no_check(u8) DC_PRED;
    XD.mode_info_stride = PC.mode_info_stride;
    XD.corrupted = 0;

    XD.fullpixel_mask = ~(cast(s32) 0);
    if PC.full_pixel != 0 {
        XD.fullpixel_mask = ~(cast(s32) 7);
    }
}

eob_adjust_in_decodeframe :: (eobs: *s8, diff: *s16) {
    for js: 0..cast(s32) 16 - 1 {
        if eobs[js] == 0 && diff[0] != 0 {
            eobs[js] += 1;
        }
        diff += 16;
    }
}

vp8_inverse_transform_mby_in_decodeframe :: (xd: *MACROBLOCKD_in_blockd) {
    dqc := xd.dequant_y1.data;

    if xd.mode_info_context.mbmi.mode != cast,no_check(u8) SPLITMV {
        if xd.eobs[24] > 1 {
            vp8_short_inv_walsh4x4_c(*xd.block[24].dqcoeff[0], xd.qcoeff.data);
        } else {
            vp8_short_inv_walsh4x4_1_c(*xd.block[24].dqcoeff[0], xd.qcoeff.data);
        }
        eob_adjust_in_decodeframe(xd.eobs.data, xd.qcoeff.data);

        dqc = xd.dequant_y1_dc.data;
    }
    vp8_dequant_idct_add_y_block_c(xd.qcoeff.data, dqc, xd.dst.y_buffer, xd.dst.y_stride, xd.eobs.data);
}

clip_pixel_in_decodeframe :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_decodeframe :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_decodeframe :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_decodeframe :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_decodeframe :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_decodeframe(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_decodeframe(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_decodeframe(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_decodeframe :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

