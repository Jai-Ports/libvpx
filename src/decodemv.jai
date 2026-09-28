Read_Mb_Modes_Mv_Values :: u32;
CNT_INTRA_in_decodemv : s32 : 0;
CNT_NEAREST_in_decodemv : s32 : 1;
CNT_NEAR_in_decodemv : s32 : 2;
CNT_SPLITMV_in_decodemv : s32 : 3;

MBSPLIT_FILL_COUNT: [4] u8;

MBSPLIT_FILL_OFFSET: [4] [16] u8;

VP8_SUB_MV_REF_PROB3: [8] [3] Vp8_Prob;

codec_control_vp8_set_reference_in_decodemv :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *Ref_Frame_T) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_copy_reference_in_decodemv :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *Ref_Frame_T) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_set_postproc_in_decodemv :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Vp8_Postproc_Cfg_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_get_reference_in_decodemv :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Vp9_Ref_Frame_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_last_ref_updates_in_decodemv :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_frame_corrupted_in_decodemv :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_last_ref_used_in_decodemv :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vpxd_set_decryptor_in_decodemv :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *Decrypt_Init) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_set_decryptor_in_decodemv :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *Decrypt_Init) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_frame_size_in_decodemv :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_display_size_in_decodemv :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_bit_depth_in_decodemv :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *u32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_set_byte_alignment_in_decodemv :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_invert_tile_decode_order_in_decodemv :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_set_skip_loop_filter_in_decodemv :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_decode_svc_spatial_layer_in_decodemv :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vpxd_get_last_quantizer_in_decodemv :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_set_row_mt_in_decodemv :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_set_loop_filter_opt_in_decodemv :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

vp8dx_decode_bool_in_decodemv :: (br: *BOOL_DECODER, probability: s32) -> s32 {
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

vp8_decode_value_in_decodemv :: (br: *BOOL_DECODER, bits: s32) -> s32 {
    z: s32 = 0;

    bit := bits - 1;
    while bit >= 0 {
        z |= vp8dx_decode_bool_in_decodemv(br, 0x80) << ((bit) & 31);
        bit -= 1;
    }

    return z;
}

vp8dx_bool_error_in_decodemv :: (br: *BOOL_DECODER) -> s32 {
    if br.count > (cast,no_check(s32) (cast(u64) size_of(VP8_BD_VALUE))) * 8 && br.count < 0x40000000 {
        return 1;
    }

    return 0;
}

vp8_treed_read_in_decodemv :: (R: *Vp8_Reader_in_treereader, t: *Vp8_Tree_Index, P: *Vp8_Prob) -> s32 {
    i: Vp8_Tree_Index = 0;

    while (ifx true { assignment_1: Vp8_Tree_Index = cast,no_check(Vp8_Tree_Index) (t[(cast(s32) i) + vp8dx_decode_bool_in_decodemv(R, cast,no_check(s32) P[(cast(s32) i) >> 1])]); (i) = assignment_1; assignment_1; }) > 0 {
    }

    return -(cast,no_check(s32) i);
}

vp8_sem_wait_in_decodemv :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_2: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_2; assignment_2; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init_in_decodemv :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release_in_decodemv :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

atomic_load_acquire_in_decodemv :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_atomic_spin_wait_in_decodemv :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire_in_decodemv(last_row_current_mb_col) - NSYNC {
    }
}

vp8_decode_mode_mvs :: (pbi: *VP8_D_COMP) {
    mi := pbi.common.mi;
    mb_row: s32 = -1;

    mb_mode_mv_init(pbi);

    pbi.mb.mb_to_top_edge = 0;
    pbi.mb.mb_to_bottom_edge = ((pbi.common.mb_rows - 1) * 16) << 3;
    mb_to_right_edge_start := ((pbi.common.mb_cols - 1) * 16) << 3;

    while c_transpiler_pre_increment(*(mb_row)) < pbi.common.mb_rows {
        mb_col: s32 = -1;

        pbi.mb.mb_to_left_edge = 0;
        pbi.mb.mb_to_right_edge = mb_to_right_edge_start;

        while c_transpiler_pre_increment(*(mb_col)) < pbi.common.mb_cols {
            decode_mb_mode_mvs(pbi, mi);

            pbi.mb.mb_to_left_edge -= (cast(s32) 16) << 3;
            pbi.mb.mb_to_right_edge -= (cast(s32) 16) << 3;
            mi += 1;
        }
        pbi.mb.mb_to_top_edge -= (cast(s32) 16) << 3;
        pbi.mb.mb_to_bottom_edge -= (cast(s32) 16) << 3;

        mi += 1;
    }
}

decode_mb_mode_mvs :: (pbi: *VP8_D_COMP, mi: *MODE_INFO_in_blockd) {
    if pbi.mb.update_mb_segmentation_map != 0 {
        read_mb_features(pbi.mbc.data + 8, *mi.mbmi, *pbi.mb);
    } else if pbi.common.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
        mi.mbmi.segment_id = 0;
    }

    if pbi.common.mb_no_coeff_skip != 0 {
        mi.mbmi.mb_skip_coeff =
            cast,no_check(u8) vp8dx_decode_bool_in_decodemv(
                pbi.mbc.data + 8,
                cast,no_check(s32) pbi.prob_skip_false
            );
    } else {
        mi.mbmi.mb_skip_coeff = 0;
    }

    mi.mbmi.is_4x4 = 0;
    if pbi.common.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
        read_kf_modes(pbi, mi);
    } else {
        read_mb_modes_mv(pbi, mi, *mi.mbmi);
    }
}

read_mb_modes_mv :: (pbi: *VP8_D_COMP, mi: *MODE_INFO_in_blockd, mbmi: *MB_MODE_INFO) {
    BC := pbi.mbc.data + 8;
    mbmi.ref_frame =
        cast,no_check(u8) (cast,no_check(MV_REFERENCE_FRAME_in_alloccommon) vp8dx_decode_bool_in_decodemv(
            BC,
            cast,no_check(s32) pbi.prob_intra
        ));
    if mbmi.ref_frame != 0 {
        cnt: [4] s32 = ---;
        cntx := cnt.data;
        near_mvs: [4] Int_Mv_in_mv = ---;
        nmv := near_mvs.data;
        MIS := pbi.mb.mode_info_stride;
        above := mi - MIS;
        left := mi - 1;
        aboveleft := above - 1;
        ref_frame_sign_bias := pbi.common.ref_frame_sign_bias.data;

        mbmi.need_to_clamp_mvs = 0;

        if vp8dx_decode_bool_in_decodemv(BC, cast,no_check(s32) pbi.prob_last) != 0 {
            mbmi.ref_frame =
                cast,no_check(u8) (cast,no_check(MV_REFERENCE_FRAME_in_alloccommon) (2 + vp8dx_decode_bool_in_decodemv(
                    BC,
                    cast,no_check(s32) pbi.prob_gf
                )));
        }

        nmv[2].as_int = 0;
        nmv[1].as_int = nmv[2].as_int;
        nmv[0].as_int = nmv[1].as_int;
        cnt[3] = 0;
        cnt[2] = cnt[3];
        cnt[1] = cnt[2];
        cnt[0] = cnt[1];

        if above.mbmi.ref_frame != cast,no_check(u8) INTRA_FRAME {
            if above.mbmi.mv.as_int != 0 {
                assignment_3: u32 = above.mbmi.mv.as_int;
                ((c_transpiler_pre_increment(*(nmv))).as_int) = assignment_3;
                mv_bias_in_decodemv(
                    ref_frame_sign_bias[above.mbmi.ref_frame],
                    cast,no_check(s32) mbmi.ref_frame,
                    nmv,
                    ref_frame_sign_bias
                );
                cntx += 1;
            }

            cntx.* += 2;
        }

        if left.mbmi.ref_frame != cast,no_check(u8) INTRA_FRAME {
            if left.mbmi.mv.as_int != 0 {
                this_mv: Int_Mv_in_mv = ---;

                this_mv.as_int = left.mbmi.mv.as_int;
                mv_bias_in_decodemv(
                    ref_frame_sign_bias[left.mbmi.ref_frame],
                    cast,no_check(s32) mbmi.ref_frame,
                    *this_mv,
                    ref_frame_sign_bias
                );

                if this_mv.as_int != nmv.as_int {
                    assignment_4: u32 = this_mv.as_int;
                    ((c_transpiler_pre_increment(*(nmv))).as_int) = assignment_4;
                    cntx += 1;
                }

                cntx.* += 2;
            } else {
                cnt[CNT_INTRA_in_decodemv] += 2;
            }
        }

        if aboveleft.mbmi.ref_frame != cast,no_check(u8) INTRA_FRAME {
            if aboveleft.mbmi.mv.as_int != 0 {
                this_mv: Int_Mv_in_mv = ---;

                this_mv.as_int = aboveleft.mbmi.mv.as_int;
                mv_bias_in_decodemv(
                    ref_frame_sign_bias[aboveleft.mbmi.ref_frame],
                    cast,no_check(s32) mbmi.ref_frame,
                    *this_mv,
                    ref_frame_sign_bias
                );

                if this_mv.as_int != nmv.as_int {
                    assignment_5: u32 = this_mv.as_int;
                    ((c_transpiler_pre_increment(*(nmv))).as_int) = assignment_5;
                    cntx += 1;
                }

                cntx.* += 1;
            } else {
                cnt[CNT_INTRA_in_decodemv] += 1;
            }
        }

        if vp8dx_decode_bool_in_decodemv(BC, VP8_MODE_CONTEXTS[cnt[CNT_INTRA_in_decodemv]][0]) != 0 {
            cnt[CNT_NEAREST_in_decodemv] +=
                (cast(s32) (cnt[CNT_SPLITMV_in_decodemv] > 0)) & cast(s32) (nmv.as_int == near_mvs[CNT_NEAREST_in_decodemv].as_int);

            if cnt[CNT_NEAR_in_decodemv] > cnt[CNT_NEAREST_in_decodemv] {
                tmp := cnt[CNT_NEAREST_in_decodemv];
                cnt[CNT_NEAREST_in_decodemv] = cnt[CNT_NEAR_in_decodemv];
                cnt[CNT_NEAR_in_decodemv] = tmp;
                tmp = cast,no_check(s32) near_mvs[CNT_NEAREST_in_decodemv].as_int;
                near_mvs[CNT_NEAREST_in_decodemv].as_int = near_mvs[CNT_NEAR_in_decodemv].as_int;
                near_mvs[CNT_NEAR_in_decodemv].as_int = cast,no_check(u32) tmp;
            }

            if vp8dx_decode_bool_in_decodemv(BC, VP8_MODE_CONTEXTS[cnt[CNT_NEAREST_in_decodemv]][1]) != 0 {
                if vp8dx_decode_bool_in_decodemv(BC, VP8_MODE_CONTEXTS[cnt[CNT_NEAR_in_decodemv]][2]) != 0 {
                    MVC := pbi.common.fc.mvc.data;

                    mb_to_top_edge := pbi.mb.mb_to_top_edge;
                    mb_to_bottom_edge := pbi.mb.mb_to_bottom_edge;
                    mb_to_top_edge -= (cast(s32) 16) << 3;
                    mb_to_bottom_edge += (cast(s32) 16) << 3;
                    mb_to_right_edge := pbi.mb.mb_to_right_edge;
                    mb_to_right_edge += (cast(s32) 16) << 3;
                    mb_to_left_edge := pbi.mb.mb_to_left_edge;
                    mb_to_left_edge -= (cast(s32) 16) << 3;

                    near_index :=
                        (cast,no_check(s32) (CNT_INTRA_in_decodemv)) +
                            cast(s32) (cnt[CNT_NEAREST_in_decodemv] >= cnt[CNT_INTRA_in_decodemv]);

                    vp8_clamp_mv2_in_decodemv(near_mvs.data + near_index, *pbi.mb);

                    cnt[CNT_SPLITMV_in_decodemv] =
                        (((cast(s32) (above.mbmi.mode == cast,no_check(u8) SPLITMV)) + cast(s32) (left.mbmi.mode == cast,no_check(u8) SPLITMV)) * 2) +
                            cast(s32) (aboveleft.mbmi.mode == cast,no_check(u8) SPLITMV);

                    if vp8dx_decode_bool_in_decodemv(BC, VP8_MODE_CONTEXTS[cnt[CNT_SPLITMV_in_decodemv]][3]) != 0 {
                        decode_split_mv(
                            BC,
                            mi,
                            left,
                            above,
                            mbmi,
                            near_mvs[near_index],
                            MVC,
                            mb_to_left_edge,
                            mb_to_right_edge,
                            mb_to_top_edge,
                            mb_to_bottom_edge
                        );
                        mbmi.mv.as_int = mi.bmi[15].mv.as_int;
                        mbmi.mode = cast,no_check(u8) SPLITMV;
                        mbmi.is_4x4 = 1;
                    } else {
                        MBMI_MV := *mbmi.mv;
                        read_mv(BC, *MBMI_MV.as_mv, MVC);
                        MBMI_MV.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) MBMI_MV.as_mv.row) + cast,no_check(s32) near_mvs[near_index].as_mv.row);
                        MBMI_MV.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) MBMI_MV.as_mv.col) + cast,no_check(s32) near_mvs[near_index].as_mv.col);

                        mbmi.need_to_clamp_mvs =
                            cast,no_check(u8) vp8_check_mv_bounds_in_decodemv(
                                MBMI_MV,
                                mb_to_left_edge,
                                mb_to_right_edge,
                                mb_to_top_edge,
                                mb_to_bottom_edge
                            );
                        mbmi.mode = cast,no_check(u8) NEWMV;
                    }
                } else {
                    mbmi.mode = cast,no_check(u8) NEARMV;
                    mbmi.mv.as_int = near_mvs[CNT_NEAR_in_decodemv].as_int;
                    vp8_clamp_mv2_in_decodemv(*mbmi.mv, *pbi.mb);
                }
            } else {
                mbmi.mode = cast,no_check(u8) NEARESTMV;
                mbmi.mv.as_int = near_mvs[CNT_NEAREST_in_decodemv].as_int;
                vp8_clamp_mv2_in_decodemv(*mbmi.mv, *pbi.mb);
            }
        } else {
            mbmi.mode = cast,no_check(u8) ZEROMV;
            mbmi.mv.as_int = 0;
        }
    } else {
        mbmi.mv.as_int = 0;

        if (ifx true { assignment_7: u8 = cast,no_check(u8) (cast,no_check(u8) read_ymode(BC, pbi.common.fc.ymode_prob.data)); (mbmi.mode) = assignment_7; assignment_7; }) == cast,no_check(u8) B_PRED {
            j: s32 = 0;
            mbmi.is_4x4 = 1;
            while true {
                mi.bmi[j].as_mode = read_bmode(BC, pbi.common.fc.bmode_prob.data);
                if !(c_transpiler_pre_increment(*(j)) < 16) break;
            }
        }

        mbmi.uv_mode = cast,no_check(u8) read_uv_mode(BC, pbi.common.fc.uv_mode_prob.data);
    }
}

read_uv_mode :: (bc: *Vp8_Reader_in_treereader, p: *Vp8_Prob) -> MB_PREDICTION_MODE {
    I := vp8_treed_read_in_decodemv(bc, cast(*Vp8_Tree_Index) *(VP8_UV_MODE_TREE), p);

    return cast,no_check(MB_PREDICTION_MODE) I;
}

read_bmode :: (bc: *Vp8_Reader_in_treereader, p: *Vp8_Prob) -> B_PREDICTION_MODE {
    I := vp8_treed_read_in_decodemv(bc, cast(*Vp8_Tree_Index) *(VP8_BMODE_TREE), p);

    return cast,no_check(B_PREDICTION_MODE) I;
}

read_ymode :: (bc: *Vp8_Reader_in_treereader, p: *Vp8_Prob) -> MB_PREDICTION_MODE {
    I := vp8_treed_read_in_decodemv(bc, cast(*Vp8_Tree_Index) *(VP8_YMODE_TREE), p);

    return cast,no_check(MB_PREDICTION_MODE) I;
}

vp8_clamp_mv2_in_decodemv :: (mv: *Int_Mv_in_mv, xd: *MACROBLOCKD_in_blockd) {
    if cast,no_check(s32) mv.as_mv.col < xd.mb_to_left_edge - (cast(s32) 16) << 3 {
        mv.as_mv.col = cast,no_check(s16) (xd.mb_to_left_edge - (cast(s32) 16) << 3);
    } else if cast,no_check(s32) mv.as_mv.col > xd.mb_to_right_edge + (cast(s32) 16) << 3 {
        mv.as_mv.col = cast,no_check(s16) (xd.mb_to_right_edge + (cast(s32) 16) << 3);
    }

    if cast,no_check(s32) mv.as_mv.row < xd.mb_to_top_edge - (cast(s32) 16) << 3 {
        mv.as_mv.row = cast,no_check(s16) (xd.mb_to_top_edge - (cast(s32) 16) << 3);
    } else if cast,no_check(s32) mv.as_mv.row > xd.mb_to_bottom_edge + (cast(s32) 16) << 3 {
        mv.as_mv.row = cast,no_check(s16) (xd.mb_to_bottom_edge + (cast(s32) 16) << 3);
    }
}

vp8_check_mv_bounds_in_decodemv :: (
    mv: *Int_Mv_in_mv,
    mb_to_left_edge: s32,
    mb_to_right_edge: s32,
    mb_to_top_edge: s32,
    mb_to_bottom_edge: s32
) -> u32 {
    need_to_clamp := cast(u32) (cast,no_check(s32) mv.as_mv.col < mb_to_left_edge);
    need_to_clamp |= cast(u32) (cast,no_check(s32) mv.as_mv.col > mb_to_right_edge);
    need_to_clamp |= cast(u32) (cast,no_check(s32) mv.as_mv.row < mb_to_top_edge);
    need_to_clamp |= cast(u32) (cast,no_check(s32) mv.as_mv.row > mb_to_bottom_edge);
    return need_to_clamp;
}

read_mv :: (r: *Vp8_Reader_in_treereader, mv: *MV_in_alloccommon, mvc: *MV_CONTEXT) {
    mv.row = cast,no_check(s16) (read_mvcomponent(r, mvc) * 2);
    mv.col = cast,no_check(s16) (read_mvcomponent(r, c_transpiler_pre_increment(*(mvc))) * 2);
}

read_mvcomponent :: (r: *Vp8_Reader_in_treereader, mvc: *MV_CONTEXT) -> s32 {
    P := cast(*Vp8_Prob) mvc;
    x: s32 = 0;

    if vp8dx_decode_bool_in_decodemv(r, cast,no_check(s32) P[MVPIS_SHORT]) != 0 {
        i: s32 = 0;

        while true {
            x +=
                vp8dx_decode_bool_in_decodemv(r, cast,no_check(s32) P[(cast,no_check(s32) (MV_PBITS)) +
                    i]) << ((i) & 31);
            if !(c_transpiler_pre_increment(*(i)) < 3) break;
        }

        i = (cast,no_check(s32) (MVLONG_WIDTH)) - 1;

        while true {
            x +=
                vp8dx_decode_bool_in_decodemv(r, cast,no_check(s32) P[(cast,no_check(s32) (MV_PBITS)) +
                    i]) << ((i) & 31);
            if !(c_transpiler_pre_decrement(*(i)) > 3) break;
        }

        if x & 0xfff0 == 0 || vp8dx_decode_bool_in_decodemv(r, cast,no_check(s32) P[(cast,no_check(s32) (MV_PBITS)) + 3]) != 0 {
            x += 8;
        }
    } else {
        x = vp8_treed_read_in_decodemv(r, cast(*Vp8_Tree_Index) *(VP8_SMALL_MVTREE), P + MV_PSHORT);
    }

    if x != 0 && vp8dx_decode_bool_in_decodemv(r, cast,no_check(s32) P[MV_PSIGN]) != 0 {
        x = -x;
    }

    return x;
}

decode_split_mv :: (
    BC: *Vp8_Reader_in_treereader,
    mi: *MODE_INFO_in_blockd,
    left_mb: *MODE_INFO_in_blockd,
    above_mb: *MODE_INFO_in_blockd,
    mbmi: *MB_MODE_INFO,
    best_mv: Int_Mv_in_mv,
    MVC: *MV_CONTEXT,
    mb_to_left_edge: s32,
    mb_to_right_edge: s32,
    mb_to_top_edge: s32,
    mb_to_bottom_edge: s32
) {
    j: s32 = 0;

    s: s32 = 3;
    num_p: s32 = 16;
    if vp8dx_decode_bool_in_decodemv(BC, 110) != 0 {
        s = 2;
        num_p = 4;
        if vp8dx_decode_bool_in_decodemv(BC, 111) != 0 {
            s = vp8dx_decode_bool_in_decodemv(BC, 150);
            num_p = 2;
        }
    }

    while true {
        {
            leftmv, abovemv: Int_Mv_in_mv = ---;
            blockmv: Int_Mv_in_mv = ---;

            k := cast,no_check(s32) VP8_MBSPLIT_OFFSET[s][j];

            if k & 3 == 0 {
                if left_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
                    leftmv.as_int = left_mb.mbmi.mv.as_int;
                } else {
                    leftmv.as_int = (((left_mb.bmi.data + k + 4 - 1)).mv).as_int;
                }
            } else {
                leftmv.as_int = (((mi.bmi.data + k - 1)).mv).as_int;
            }

            if k >> 2 == 0 {
                if above_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
                    abovemv.as_int = above_mb.mbmi.mv.as_int;
                } else {
                    abovemv.as_int = (((above_mb.bmi.data + k + 16 - 4)).mv).as_int;
                }
            } else {
                abovemv.as_int = (((mi.bmi.data + k - 4)).mv).as_int;
            }

            prob := get_sub_mv_ref_prob(leftmv.as_int, abovemv.as_int);

            if vp8dx_decode_bool_in_decodemv(BC, cast,no_check(s32) prob[0]) != 0 {
                if vp8dx_decode_bool_in_decodemv(BC, cast,no_check(s32) prob[1]) != 0 {
                    blockmv.as_int = 0;
                    if vp8dx_decode_bool_in_decodemv(BC, cast,no_check(s32) prob[2]) != 0 {
                        blockmv.as_mv.row = cast,no_check(s16) (read_mvcomponent(BC, *MVC[0]) * 2);
                        blockmv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) blockmv.as_mv.row) + cast,no_check(s32) best_mv.as_mv.row);
                        blockmv.as_mv.col = cast,no_check(s16) (read_mvcomponent(BC, *MVC[1]) * 2);
                        blockmv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) blockmv.as_mv.col) + cast,no_check(s32) best_mv.as_mv.col);
                    }
                } else {
                    blockmv.as_int = abovemv.as_int;
                }
            } else {
                blockmv.as_int = leftmv.as_int;
            }

            c_transpiler_compound_or(*(mbmi.need_to_clamp_mvs), (vp8_check_mv_bounds_in_decodemv(
                *blockmv,
                mb_to_left_edge,
                mb_to_right_edge,
                mb_to_top_edge,
                mb_to_bottom_edge
            )), u32, u32);

            {
                fill_count := cast,no_check(u32) MBSPLIT_FILL_COUNT[s];

                fill_offset :=
                    MBSPLIT_FILL_OFFSET[s].data +
                        (cast(s32) (cast,no_check(u8) j)) * cast(s32) MBSPLIT_FILL_COUNT[s];

                while true {
                    mi.bmi[fill_offset.*].mv.as_int = blockmv.as_int;
                    fill_offset += 1;
                    if c_transpiler_pre_decrement(*(fill_count)) == 0 break;
                }
            }
        }
        if !(c_transpiler_pre_increment(*(j)) < num_p) break;
    }

    mbmi.partitioning = cast,no_check(u8) s;
}

get_sub_mv_ref_prob :: (LEFT: u32, ABOVE: u32) -> *Vp8_Prob {
    lez := cast(s32) (LEFT == 0);
    aez := cast(s32) (ABOVE == 0);
    lea := cast(s32) (LEFT == ABOVE);
    prob := VP8_SUB_MV_REF_PROB3[aez << 2 | (lez << 1) | lea].data;

    return prob;
}

mv_bias_in_decodemv :: (refmb_ref_frame_sign_bias: s32, refframe: s32, mvp: *Int_Mv_in_mv, ref_frame_sign_bias: *s32) {
    if refmb_ref_frame_sign_bias != ref_frame_sign_bias[refframe] {
        mvp.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.row) * -1);
        mvp.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.col) * -1);
    }
}

read_kf_modes :: (pbi: *VP8_D_COMP, mi: *MODE_INFO_in_blockd) {
    BC := pbi.mbc.data + 8;
    MIS := pbi.common.mode_info_stride;

    mi.mbmi.ref_frame = cast,no_check(u8) INTRA_FRAME;
    mi.mbmi.mode = cast,no_check(u8) read_kf_ymode(BC, VP8_KF_YMODE_PROB.data);

    if mi.mbmi.mode == cast,no_check(u8) B_PRED {
        i: s32 = 0;
        mi.mbmi.is_4x4 = 1;

        while true {
            {
                A := above_block_mode_in_decodemv(mi, i, MIS);
                L := left_block_mode_in_decodemv(mi, i);

                mi.bmi[i].as_mode = read_bmode(BC, VP8_KF_BMODE_PROB[A][L].data);
            }
            if !(c_transpiler_pre_increment(*(i)) < 16) break;
        }
    }

    mi.mbmi.uv_mode = cast,no_check(u8) read_uv_mode(BC, VP8_KF_UV_MODE_PROB.data);
}

left_block_mode_in_decodemv :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> B_PREDICTION_MODE {
    if b & 3 == 0 {
        cur_mb -= 1;
        if cast,no_check(s32) cur_mb.mbmi.mode == {
            case B_PRED;
                return ((cur_mb.bmi.data + b + 3)).as_mode;
            case DC_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_DC_PRED;
            case V_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_VE_PRED;
            case H_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_HE_PRED;
            case TM_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_TM_PRED;
            case;
                return cast,no_check(B_PREDICTION_MODE) B_DC_PRED;
        }
    }

    return ((cur_mb.bmi.data + b - 1)).as_mode;
}

above_block_mode_in_decodemv :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> B_PREDICTION_MODE {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cast,no_check(s32) cur_mb.mbmi.mode == {
            case B_PRED;
                return ((cur_mb.bmi.data + b + 12)).as_mode;
            case DC_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_DC_PRED;
            case V_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_VE_PRED;
            case H_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_HE_PRED;
            case TM_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_TM_PRED;
            case;
                return cast,no_check(B_PREDICTION_MODE) B_DC_PRED;
        }
    }

    return ((cur_mb.bmi.data + b - 4)).as_mode;
}

read_kf_ymode :: (bc: *Vp8_Reader_in_treereader, p: *Vp8_Prob) -> MB_PREDICTION_MODE {
    I := vp8_treed_read_in_decodemv(bc, cast(*Vp8_Tree_Index) *(VP8_KF_YMODE_TREE), p);

    return cast,no_check(MB_PREDICTION_MODE) I;
}

read_mb_features :: (r: *Vp8_Reader_in_treereader, mi: *MB_MODE_INFO, x: *MACROBLOCKD_in_blockd) {
    if x.segmentation_enabled != 0 && x.update_mb_segmentation_map != 0 {
        if vp8dx_decode_bool_in_decodemv(r, cast,no_check(s32) x.mb_segment_tree_probs[0]) != 0 {
            mi.segment_id =
                cast,no_check(u8) (2 + vp8dx_decode_bool_in_decodemv(
                    r,
                    cast,no_check(s32) x.mb_segment_tree_probs[2]
                ));
        } else {
            mi.segment_id =
                cast,no_check(u8) vp8dx_decode_bool_in_decodemv(
                    r,
                    cast,no_check(s32) x.mb_segment_tree_probs[1]
                );
        }
    }
}

mb_mode_mv_init :: (pbi: *VP8_D_COMP) {
    BC := pbi.mbc.data + 8;
    MVC := pbi.common.fc.mvc.data;

    pbi.common.mb_no_coeff_skip = vp8dx_decode_bool_in_decodemv(BC, cast,no_check(s32) (cast(Vp8_Prob) 128));

    pbi.prob_skip_false = 0;
    if pbi.common.mb_no_coeff_skip != 0 {
        pbi.prob_skip_false = cast,no_check(Vp8_Prob) vp8_decode_value_in_decodemv(BC, 8);
    }

    if pbi.common.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
        pbi.prob_intra = cast,no_check(Vp8_Prob) vp8_decode_value_in_decodemv(BC, 8);
        pbi.prob_last = cast,no_check(Vp8_Prob) vp8_decode_value_in_decodemv(BC, 8);
        pbi.prob_gf = cast,no_check(Vp8_Prob) vp8_decode_value_in_decodemv(BC, 8);

        if vp8dx_decode_bool_in_decodemv(BC, cast,no_check(s32) (cast(Vp8_Prob) 128)) != 0 {
            i: s32 = 0;

            while true {
                pbi.common.fc.ymode_prob[i] = cast,no_check(Vp8_Prob) vp8_decode_value_in_decodemv(BC, 8);
                if !(c_transpiler_pre_increment(*(i)) < 4) break;
            }
        }

        if vp8dx_decode_bool_in_decodemv(BC, cast,no_check(s32) (cast(Vp8_Prob) 128)) != 0 {
            i: s32 = 0;

            while true {
                pbi.common.fc.uv_mode_prob[i] = cast,no_check(Vp8_Prob) vp8_decode_value_in_decodemv(BC, 8);
                if !(c_transpiler_pre_increment(*(i)) < 3) break;
            }
        }

        read_mvcontexts(BC, MVC);
    }
}

read_mvcontexts :: (bc: *Vp8_Reader_in_treereader, mvc: *MV_CONTEXT) {
    i: s32 = 0;

    while true {
        {
            up := VP8_MV_UPDATE_PROBS[i].prob.data;
            p := cast(*Vp8_Prob) (mvc + i);
            PSTOP := p + MV_PCOUNT;

            while true {
                if vp8dx_decode_bool_in_decodemv(bc, cast,no_check(s32) ((c_transpiler_post_increment(*(up))).*)) != 0 {
                    X := cast,no_check(Vp8_Prob) vp8_decode_value_in_decodemv(bc, 7);

                    p.* = cast,no_check(Vp8_Prob) ((ifx X != 0 then (cast(s32) X) << 1 else 1));
                }
                if !(c_transpiler_pre_increment(*(p)) < PSTOP) break;
            }
        }
        if !(c_transpiler_pre_increment(*(i)) < 2) break;
    }
}

vp8_clamp_mv_in_decodemv :: (
    mv: *Int_Mv_in_mv,
    mb_to_left_edge: s32,
    mb_to_right_edge: s32,
    mb_to_top_edge: s32,
    mb_to_bottom_edge: s32
) {
    mv.as_mv.col =
        cast,no_check(s16) ((ifx cast,no_check(s32) mv.as_mv.col < mb_to_left_edge then mb_to_left_edge else cast,no_check(s32) mv.as_mv.col));
    mv.as_mv.col =
        cast,no_check(s16) ((ifx cast,no_check(s32) mv.as_mv.col > mb_to_right_edge then mb_to_right_edge else cast,no_check(s32) mv.as_mv.col));
    mv.as_mv.row =
        cast,no_check(s16) ((ifx cast,no_check(s32) mv.as_mv.row < mb_to_top_edge then mb_to_top_edge else cast,no_check(s32) mv.as_mv.row));
    mv.as_mv.row =
        cast,no_check(s16) ((ifx cast,no_check(s32) mv.as_mv.row > mb_to_bottom_edge then mb_to_bottom_edge else cast,no_check(s32) mv.as_mv.row));
}

left_block_mv_in_decodemv :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> u32 {
    if b & 3 == 0 {
        cur_mb -= 1;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 4;
    }

    return (((cur_mb.bmi.data + b - 1)).mv).as_int;
}

above_block_mv_in_decodemv :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> u32 {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 16;
    }

    return (((cur_mb.bmi.data + (b - 4))).mv).as_int;
}

globals_initialization_state_for_decodemv: u32;
initialize_globals_for_decodemv :: () {
    {
        state := atomic_load(*globals_initialization_state_for_decodemv);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_decodemv, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_decodemv) != 2 {}
            return;
        }
    }
    MBSPLIT_FILL_COUNT = u8.[ 8, 8, 4, 1 ];
    MBSPLIT_FILL_OFFSET =
        [16] u8.[
            u8.[ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ],
            u8.[ 0, 1, 4, 5, 8, 9, 12, 13, 2, 3, 6, 7, 10, 11, 14, 15 ],
            u8.[ 0, 1, 4, 5, 2, 3, 6, 7, 8, 9, 12, 13, 10, 11, 14, 15 ],
            u8.[ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]
        ];
    VP8_SUB_MV_REF_PROB3 =
        [3] Vp8_Prob.[
            Vp8_Prob.[ 147, 136, 18 ],
            Vp8_Prob.[ 223, 1, 34 ],
            Vp8_Prob.[ 106, 145, 1 ],
            Vp8_Prob.[ 208, 1, 1 ],
            Vp8_Prob.[ 179, 121, 1 ],
            Vp8_Prob.[ 223, 1, 34 ],
            Vp8_Prob.[ 179, 121, 1 ],
            Vp8_Prob.[ 208, 1, 1 ]
        ];
    atomic_store(*globals_initialization_state_for_decodemv, 2);
}

