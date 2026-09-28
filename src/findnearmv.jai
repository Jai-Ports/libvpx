// Generated directly from C by cpp_transpiler.
Vp8_Find_Near_Mvs_Values :: u32;
CNT_INTRA : s32 : 0;
CNT_NEAREST : s32 : 1;
CNT_NEAR : s32 : 2;
CNT_SPLITMV : s32 : 3;

VP8_MBSPLIT_OFFSET: [4] [16] u8;

mv_bias_in_findnearmv :: (
    refmb_ref_frame_sign_bias: s32,
    refframe: s32,
    mvp: *Int_Mv_in_mv,
    ref_frame_sign_bias: *s32
) {
    if refmb_ref_frame_sign_bias != ref_frame_sign_bias[refframe] {
        mvp.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.row) * -1);
        mvp.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.col) * -1);
    }
}

vp8_clamp_mv2_in_findnearmv :: (mv: *Int_Mv_in_mv, xd: *MACROBLOCKD_in_blockd) {
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

vp8_clamp_mv_in_findnearmv :: (
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

vp8_check_mv_bounds_in_findnearmv :: (
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

vp8_find_near_mvs :: (
    xd: *MACROBLOCKD_in_blockd,
    here: *MODE_INFO_in_blockd,
    nearest: *Int_Mv_in_mv,
    nearby: *Int_Mv_in_mv,
    best_mv: *Int_Mv_in_mv,
    near_mv_ref_cnts: *s32,
    refframe: s32,
    ref_frame_sign_bias: *s32
) {
    above := here - xd.mode_info_stride;
    left := here - 1;
    aboveleft := above - 1;
    near_mvs: [4] Int_Mv_in_mv = ---;
    mv := near_mvs.data;
    cntx := near_mv_ref_cnts;

    mv[2].as_int = 0;
    mv[1].as_int = mv[2].as_int;
    mv[0].as_int = mv[1].as_int;
    near_mv_ref_cnts[3] = 0;
    near_mv_ref_cnts[2] = near_mv_ref_cnts[3];
    near_mv_ref_cnts[1] = near_mv_ref_cnts[2];
    near_mv_ref_cnts[0] = near_mv_ref_cnts[1];

    if above.mbmi.ref_frame != cast,no_check(u8) INTRA_FRAME {
        if above.mbmi.mv.as_int != 0 {
            assignment_0: u32 = above.mbmi.mv.as_int;
            ((c_transpiler_pre_increment(*(mv))).as_int) = assignment_0;
            mv_bias_in_findnearmv(ref_frame_sign_bias[above.mbmi.ref_frame], refframe, mv, ref_frame_sign_bias);
            cntx += 1;
        }

        cntx.* += 2;
    }

    if left.mbmi.ref_frame != cast,no_check(u8) INTRA_FRAME {
        if left.mbmi.mv.as_int != 0 {
            this_mv: Int_Mv_in_mv = ---;

            this_mv.as_int = left.mbmi.mv.as_int;
            mv_bias_in_findnearmv(ref_frame_sign_bias[left.mbmi.ref_frame], refframe, *this_mv, ref_frame_sign_bias);

            if this_mv.as_int != mv.as_int {
                assignment_1: u32 = this_mv.as_int;
                ((c_transpiler_pre_increment(*(mv))).as_int) = assignment_1;
                cntx += 1;
            }

            cntx.* += 2;
        } else {
            near_mv_ref_cnts[CNT_INTRA] += 2;
        }
    }

    if aboveleft.mbmi.ref_frame != cast,no_check(u8) INTRA_FRAME {
        if aboveleft.mbmi.mv.as_int != 0 {
            this_mv: Int_Mv_in_mv = ---;

            this_mv.as_int = aboveleft.mbmi.mv.as_int;
            mv_bias_in_findnearmv(
                ref_frame_sign_bias[aboveleft.mbmi.ref_frame],
                refframe,
                *this_mv,
                ref_frame_sign_bias
            );

            if this_mv.as_int != mv.as_int {
                assignment_2: u32 = this_mv.as_int;
                ((c_transpiler_pre_increment(*(mv))).as_int) = assignment_2;
                cntx += 1;
            }

            cntx.* += 1;
        } else {
            near_mv_ref_cnts[CNT_INTRA] += 1;
        }
    }

    if near_mv_ref_cnts[CNT_SPLITMV] != 0 {
        if mv.as_int == near_mvs[CNT_NEAREST].as_int {
            near_mv_ref_cnts[CNT_NEAREST] += 1;
        }
    }

    near_mv_ref_cnts[CNT_SPLITMV] =
        (((cast(s32) (above.mbmi.mode == cast,no_check(u8) SPLITMV)) + cast(s32) (left.mbmi.mode == cast,no_check(u8) SPLITMV)) * 2) +
            cast(s32) (aboveleft.mbmi.mode == cast,no_check(u8) SPLITMV);

    if near_mv_ref_cnts[CNT_NEAR] > near_mv_ref_cnts[CNT_NEAREST] {
        tmp := near_mv_ref_cnts[CNT_NEAREST];
        near_mv_ref_cnts[CNT_NEAREST] = near_mv_ref_cnts[CNT_NEAR];
        near_mv_ref_cnts[CNT_NEAR] = tmp;
        tmp = cast,no_check(s32) near_mvs[CNT_NEAREST].as_int;
        near_mvs[CNT_NEAREST].as_int = near_mvs[CNT_NEAR].as_int;
        near_mvs[CNT_NEAR].as_int = cast,no_check(u32) tmp;
    }

    if near_mv_ref_cnts[CNT_NEAREST] >= near_mv_ref_cnts[CNT_INTRA] {
        near_mvs[CNT_INTRA] = near_mvs[CNT_NEAREST];
    }

    best_mv.as_int = near_mvs[0].as_int;
    nearest.as_int = near_mvs[CNT_NEAREST].as_int;
    nearby.as_int = near_mvs[CNT_NEAR].as_int;
}

vp8_find_near_mvs_bias :: (
    xd: *MACROBLOCKD_in_blockd,
    here: *MODE_INFO_in_blockd,
    mode_mv_sb: *[10] Int_Mv_in_mv,
    best_mv_sb: *Int_Mv_in_mv,
    cnt: *s32,
    refframe: s32,
    ref_frame_sign_bias: *s32
) -> s32 {
    sign_bias := ref_frame_sign_bias[refframe];

    vp8_find_near_mvs(
        xd,
        here,
        mode_mv_sb[sign_bias].data + NEARESTMV,
        mode_mv_sb[sign_bias].data + NEARMV,
        *best_mv_sb[sign_bias],
        cnt,
        refframe,
        ref_frame_sign_bias
    );

    invert_and_clamp_mvs(
        mode_mv_sb[cast(s32) (sign_bias == 0)].data + NEARESTMV,
        mode_mv_sb[sign_bias].data + NEARESTMV,
        xd
    );
    invert_and_clamp_mvs(mode_mv_sb[cast(s32) (sign_bias == 0)].data + NEARMV, mode_mv_sb[sign_bias].data + NEARMV, xd);
    invert_and_clamp_mvs(*best_mv_sb[cast(s32) (sign_bias == 0)], *best_mv_sb[sign_bias], xd);

    return sign_bias;
}

invert_and_clamp_mvs :: (inv: *Int_Mv_in_mv, src: *Int_Mv_in_mv, xd: *MACROBLOCKD_in_blockd) {
    inv.as_mv.row = cast,no_check(s16) ((cast(s32) src.as_mv.row) * -1);
    inv.as_mv.col = cast,no_check(s16) ((cast(s32) src.as_mv.col) * -1);
    vp8_clamp_mv2_in_findnearmv(inv, xd);
    vp8_clamp_mv2_in_findnearmv(src, xd);
}

vp8_mv_ref_probs :: (p: *Vp8_Prob, near_mv_ref_ct: *s32) -> *Vp8_Prob {
    p[0] = cast,no_check(Vp8_Prob) VP8_MODE_CONTEXTS[near_mv_ref_ct[0]][0];
    p[1] = cast,no_check(Vp8_Prob) VP8_MODE_CONTEXTS[near_mv_ref_ct[1]][1];
    p[2] = cast,no_check(Vp8_Prob) VP8_MODE_CONTEXTS[near_mv_ref_ct[2]][2];
    p[3] = cast,no_check(Vp8_Prob) VP8_MODE_CONTEXTS[near_mv_ref_ct[3]][3];

    return p;
}

left_block_mv_in_findnearmv :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> u32 {
    if b & 3 == 0 {
        cur_mb -= 1;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 4;
    }

    return (((cur_mb.bmi.data + b - 1)).mv).as_int;
}

above_block_mv_in_findnearmv :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> u32 {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 16;
    }

    return (((cur_mb.bmi.data + (b - 4))).mv).as_int;
}

left_block_mode_in_findnearmv :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> B_PREDICTION_MODE {
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

above_block_mode_in_findnearmv :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> B_PREDICTION_MODE {
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

globals_initialization_state_for_findnearmv: u32;
initialize_globals_for_findnearmv :: () {
    {
        state := atomic_load(*globals_initialization_state_for_findnearmv);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_findnearmv, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_findnearmv) != 2 {}
            return;
        }
    }
    VP8_MBSPLIT_OFFSET =
        [16] u8.[
            u8.[ 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
            u8.[ 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
            u8.[ 0, 2, 8, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
            u8.[ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]
        ];
    atomic_store(*globals_initialization_state_for_findnearmv, 2);
}

MV_REFERENCE_FRAME_in_alloccommon :: u32;
INTRA_FRAME : s32 : 0;
LAST_FRAME : s32 : 1;
GOLDEN_FRAME : s32 : 2;
ALTREF_FRAME : s32 : 3;
MAX_REF_FRAMES : s32 : 4;

