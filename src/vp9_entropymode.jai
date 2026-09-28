SUB_PEL_FILTERS_12_in_vp9_entropymode: [16] Interp_Kernel12 #align 256;

COUNT_TO_UPDATE_FACTOR_in_vp9_entropymode: [21] s32;

VP9_KF_UV_MODE_PROB: [10] [9] Prob;

VP9_KF_Y_MODE_PROB: [10] [10] [9] Prob;

VP9_KF_PARTITION_PROBS: [16] [3] Prob;

VP9_INTRA_MODE_TREE: [18] Tree_Index;

VP9_INTER_MODE_TREE: [6] Tree_Index;

VP9_PARTITION_TREE: [6] Tree_Index;

VP9_SWITCHABLE_INTERP_TREE: [4] Tree_Index;

DEFAULT_INTER_MODE_PROBS: [7] [3] Prob;

DEFAULT_SKIP_PROBS: [3] Prob;

DEFAULT_TX_PROBS: Tx_Probs;

DEFAULT_SINGLE_REF_P: [5] [2] Prob;

DEFAULT_COMP_REF_P: [5] Prob;

DEFAULT_COMP_INTER_P: [5] Prob;

DEFAULT_INTRA_INTER_P: [4] Prob;

DEFAULT_PARTITION_PROBS: [16] [3] Prob;

DEFAULT_SWITCHABLE_INTERP_PROB: [4] [2] Prob;

DEFAULT_IF_Y_PROBS: [4] [9] Prob;

DEFAULT_IF_UV_PROBS: [10] [9] Prob;

clip_pixel_in_vp9_entropymode :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_entropymode :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_entropymode :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_entropymode :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_entropymode :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_entropymode(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_entropymode(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_entropymode(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_entropymode :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_lsb_in_vp9_entropymode :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_entropymode :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_entropymode :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_entropymode(num_values) + 1 else 0;
}

get_filter_taps_in_vp9_entropymode :: (FILTER: *s16) -> s32 {
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

get_prob_in_vp9_entropymode :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_entropymode :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_entropymode(n0, DEN);
}

weighted_prob_in_vp9_entropymode :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_entropymode :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_entropymode(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_entropymode(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_entropymode :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_entropymode[COUNT];
        PROB := get_prob_in_vp9_entropymode(ct[0], DEN);
        return weighted_prob_in_vp9_entropymode(
            cast,no_check(s32) pre_prob,
            cast,no_check(s32) PROB,
            cast,no_check(s32) FACTOR
        );
    }
}

get_band_translate_in_vp9_entropymode :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_entropymode :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_entropymode :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_entropymode(above_ec, left_ec);
}

is_zero_mv_in_vp9_entropymode :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_entropymode :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_entropymode :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_entropymode(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_entropymode(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_entropymode :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_entropymode :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_entropymode :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_entropymode :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

vp9_setup_past_independence :: (cm: *VP9_COMMON) {
    LF := *cm.lf;

    vp9_clearall_segfeatures(*cm.seg);
    cm.seg.abs_delta = 0;

    if cm.last_frame_seg_map != null {
        fill_memory(cm.last_frame_seg_map, 0, cast,no_check(u64) (cm.mi_rows * cm.mi_cols));
    }

    if cm.current_frame_seg_map != null {
        fill_memory(cm.current_frame_seg_map, 0, cast,no_check(u64) (cm.mi_rows * cm.mi_cols));
    }

    fill_memory(*LF.last_ref_deltas, 0, LF.last_ref_deltas.count);
    fill_memory(*LF.last_mode_deltas, 0, LF.last_mode_deltas.count);
    set_default_lf_deltas_in_vp9_entropymode(LF);

    LF.last_sharpness_level = -1;

    vp9_default_coef_probs(cm);
    init_mode_probs(cm.fc);
    vp9_init_mv_probs(cm);
    cm.fc.initialized = 1;

    if cm.frame_type == cast,no_check(u32) KEY_FRAME || cm.error_resilient_mode != 0 || cm.reset_frame_context == 3 {
        for i: 0..cast(s32) ((cast(s32) 1) << 2) - 1 {
            (cast(*Frame_Contexts) (cm.frame_contexts))[i] = cm.fc.*;
        }
    } else if cm.reset_frame_context == 2 {
        (cast(*Frame_Contexts) (cm.frame_contexts))[cm.frame_context_idx] = cm.fc.*;
    }

    if frame_is_intra_only_in_vp9_entropymode(cm) != 0 && cm.prev_mip != null {
        fill_memory(cm.prev_mip, 0, cast,no_check(u64) (cm.mi_stride * (cm.mi_rows + 1)) * size_of(MODE_INFO));
    }

    fill_memory(*cm.ref_frame_sign_bias, 0, cm.ref_frame_sign_bias.count * size_of(s32));

    cm.frame_context_idx = 0;
}

frame_is_intra_only_in_vp9_entropymode :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

init_mode_probs :: (fc: *FRAME_CONTEXT) {
    {
        #assert fc.uv_mode_prob.count * size_of([9] Prob) == DEFAULT_IF_UV_PROBS.count * size_of([9] Prob);

        copy_memory(fc.uv_mode_prob.data, DEFAULT_IF_UV_PROBS.data, DEFAULT_IF_UV_PROBS.count * size_of([9] Prob));
    }
    {
        #assert fc.y_mode_prob.count * size_of([9] Prob) == DEFAULT_IF_Y_PROBS.count * size_of([9] Prob);

        copy_memory(fc.y_mode_prob.data, DEFAULT_IF_Y_PROBS.data, DEFAULT_IF_Y_PROBS.count * size_of([9] Prob));
    }
    {
        #assert fc.switchable_interp_prob.count * size_of([2] Prob) == DEFAULT_SWITCHABLE_INTERP_PROB.count * size_of([2] Prob);

        copy_memory(
            fc.switchable_interp_prob.data,
            DEFAULT_SWITCHABLE_INTERP_PROB.data,
            DEFAULT_SWITCHABLE_INTERP_PROB.count * size_of([2] Prob)
        );
    }
    {
        #assert fc.partition_prob.count * size_of([3] Prob) == DEFAULT_PARTITION_PROBS.count * size_of([3] Prob);

        copy_memory(
            fc.partition_prob.data,
            DEFAULT_PARTITION_PROBS.data,
            DEFAULT_PARTITION_PROBS.count * size_of([3] Prob)
        );
    }
    {
        #assert fc.intra_inter_prob.count == DEFAULT_INTRA_INTER_P.count;

        copy_memory(fc.intra_inter_prob.data, DEFAULT_INTRA_INTER_P.data, DEFAULT_INTRA_INTER_P.count);
    }
    {
        #assert fc.comp_inter_prob.count == DEFAULT_COMP_INTER_P.count;

        copy_memory(fc.comp_inter_prob.data, DEFAULT_COMP_INTER_P.data, DEFAULT_COMP_INTER_P.count);
    }
    {
        #assert fc.comp_ref_prob.count == DEFAULT_COMP_REF_P.count;

        copy_memory(fc.comp_ref_prob.data, DEFAULT_COMP_REF_P.data, DEFAULT_COMP_REF_P.count);
    }
    {
        #assert fc.single_ref_prob.count * size_of([2] Prob) == DEFAULT_SINGLE_REF_P.count * size_of([2] Prob);

        copy_memory(fc.single_ref_prob.data, DEFAULT_SINGLE_REF_P.data, DEFAULT_SINGLE_REF_P.count * size_of([2] Prob));
    }
    fc.tx_probs = DEFAULT_TX_PROBS;
    {
        #assert fc.skip_probs.count == DEFAULT_SKIP_PROBS.count;

        copy_memory(fc.skip_probs.data, DEFAULT_SKIP_PROBS.data, DEFAULT_SKIP_PROBS.count);
    }
    {
        #assert fc.inter_mode_probs.count * size_of([3] Prob) == DEFAULT_INTER_MODE_PROBS.count * size_of([3] Prob);

        copy_memory(
            fc.inter_mode_probs.data,
            DEFAULT_INTER_MODE_PROBS.data,
            DEFAULT_INTER_MODE_PROBS.count * size_of([3] Prob)
        );
    }
}

set_default_lf_deltas_in_vp9_entropymode :: (lf: *Loopfilter) {
    lf.mode_ref_delta_enabled = 1;
    lf.mode_ref_delta_update = 1;

    lf.ref_deltas[0] = 1;
    lf.ref_deltas[1] = 0;
    lf.ref_deltas[2] = -1;
    lf.ref_deltas[3] = -1;

    lf.mode_deltas[0] = 0;
    lf.mode_deltas[1] = 0;
}

vp9_adapt_mode_probs :: (cm: *VP9_COMMON) {
    j: s32 = ---;
    fc := cm.fc;
    pre_fc := *(cast(*Frame_Contexts) (cm.frame_contexts))[cm.frame_context_idx];
    counts := *cm.counts;

    for i: 0..cast(s32) 4 - 1 {
        fc.intra_inter_prob[i] =
            mode_mv_merge_probs_in_vp9_entropymode(
                pre_fc.intra_inter_prob[i],
                counts.intra_inter[i].data
            );
    }
    for i: 0..cast(s32) 5 - 1 {
        fc.comp_inter_prob[i] =
            mode_mv_merge_probs_in_vp9_entropymode(
                pre_fc.comp_inter_prob[i],
                counts.comp_inter[i].data
            );
    }
    for i: 0..cast(s32) 5 - 1 {
        fc.comp_ref_prob[i] = mode_mv_merge_probs_in_vp9_entropymode(pre_fc.comp_ref_prob[i], counts.comp_ref[i].data);
    }
    for i: 0..cast(s32) 5 - 1 {
        j = 0;
        while j < 2 {
            fc.single_ref_prob[i][j] =
                mode_mv_merge_probs_in_vp9_entropymode(
                    pre_fc.single_ref_prob[i][j],
                    counts.single_ref[i][j].data
                );
            j += 1;
        }
    }

    for i: 0..cast(s32) 7 - 1 {
        tree_merge_probs(
            VP9_INTER_MODE_TREE.data,
            pre_fc.inter_mode_probs[i].data,
            counts.inter_mode[i].data,
            fc.inter_mode_probs[i].data
        );
    }

    for i: 0..cast(s32) 4 - 1 {
        tree_merge_probs(
            VP9_INTRA_MODE_TREE.data,
            pre_fc.y_mode_prob[i].data,
            counts.y_mode[i].data,
            fc.y_mode_prob[i].data
        );
    }

    for i: 0..cast(s32) (9 + 1) - 1 {
        tree_merge_probs(
            VP9_INTRA_MODE_TREE.data,
            pre_fc.uv_mode_prob[i].data,
            counts.uv_mode[i].data,
            fc.uv_mode_prob[i].data
        );
    }

    for i: 0..cast(s32) (4 * 4) - 1 {
        tree_merge_probs(
            VP9_PARTITION_TREE.data,
            pre_fc.partition_prob[i].data,
            counts.partition[i].data,
            fc.partition_prob[i].data
        );
    }

    if cm.interp_filter == 4 {
        for i: 0..cast(s32) (3 + 1) - 1 {
            tree_merge_probs(
                VP9_SWITCHABLE_INTERP_TREE.data,
                pre_fc.switchable_interp_prob[i].data,
                counts.switchable_interp[i].data,
                fc.switchable_interp_prob[i].data
            );
        }
    }

    if cm.tx_mode == cast,no_check(u32) TX_MODE_SELECT {
        branch_ct_8x8p: [1] [2] u32 = ---;
        branch_ct_16x16p: [2] [2] u32 = ---;
        branch_ct_32x32p: [3] [2] u32 = ---;

        for i: 0..cast(s32) 2 - 1 {
            tx_counts_to_branch_counts_8x8(counts.tx.p8x8[i].data, branch_ct_8x8p.data);
            j = 0;
            while j < (cast,no_check(s32) (cast(TX_SIZE) 4)) - 3 {
                fc.tx_probs.p8x8[i][j] =
                    mode_mv_merge_probs_in_vp9_entropymode(
                        pre_fc.tx_probs.p8x8[i][j],
                        branch_ct_8x8p[j].data
                    );
                j += 1;
            }

            tx_counts_to_branch_counts_16x16(counts.tx.p16x16[i].data, branch_ct_16x16p.data);
            j = 0;
            while j < (cast,no_check(s32) (cast(TX_SIZE) 4)) - 2 {
                fc.tx_probs.p16x16[i][j] =
                    mode_mv_merge_probs_in_vp9_entropymode(
                        pre_fc.tx_probs.p16x16[i][j],
                        branch_ct_16x16p[j].data
                    );
                j += 1;
            }

            tx_counts_to_branch_counts_32x32(counts.tx.p32x32[i].data, branch_ct_32x32p.data);
            j = 0;
            while j < (cast,no_check(s32) (cast(TX_SIZE) 4)) - 1 {
                fc.tx_probs.p32x32[i][j] =
                    mode_mv_merge_probs_in_vp9_entropymode(
                        pre_fc.tx_probs.p32x32[i][j],
                        branch_ct_32x32p[j].data
                    );
                j += 1;
            }
        }
    }

    for i: 0..cast(s32) 3 - 1 {
        fc.skip_probs[i] = mode_mv_merge_probs_in_vp9_entropymode(pre_fc.skip_probs[i], counts.skip[i].data);
    }
}

tx_counts_to_branch_counts_32x32 :: (tx_count_32x32p: *u32, ct_32x32p: *[2] u32) {
    ct_32x32p[0][0] = tx_count_32x32p[0];
    ct_32x32p[0][1] = tx_count_32x32p[1] + tx_count_32x32p[2] + tx_count_32x32p[3];
    ct_32x32p[1][0] = tx_count_32x32p[1];
    ct_32x32p[1][1] = tx_count_32x32p[2] + tx_count_32x32p[3];
    ct_32x32p[2][0] = tx_count_32x32p[2];
    ct_32x32p[2][1] = tx_count_32x32p[3];
}

tx_counts_to_branch_counts_16x16 :: (tx_count_16x16p: *u32, ct_16x16p: *[2] u32) {
    ct_16x16p[0][0] = tx_count_16x16p[0];
    ct_16x16p[0][1] = tx_count_16x16p[1] + tx_count_16x16p[2];
    ct_16x16p[1][0] = tx_count_16x16p[1];
    ct_16x16p[1][1] = tx_count_16x16p[2];
}

tx_counts_to_branch_counts_8x8 :: (tx_count_8x8p: *u32, ct_8x8p: *[2] u32) {
    ct_8x8p[0][0] = tx_count_8x8p[0];
    ct_8x8p[0][1] = tx_count_8x8p[1];
}

vp9_is_valid_scale_in_vp9_entropymode :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_entropymode :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_entropymode(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_entropymode :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_entropymode :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_entropymode :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_entropymode :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_entropymode :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_entropymode :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_entropymode :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_entropymode :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_entropymode :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_entropymode :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_entropymode :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_entropymode(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_entropymode :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_entropymode(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_entropymode(MI, ib)];
}

get_uv_tx_size_in_vp9_entropymode :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_entropymode :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_entropymode :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_entropymode(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_entropymode :: (
    mi: *MODE_INFO,
    above_mi: *MODE_INFO,
    left_mi: *MODE_INFO,
    block: s32
) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_entropymode :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_entropymode :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_entropymode :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_entropymode :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_entropymode :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_entropymode :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_entropymode :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_entropymode :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_entropymode :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_entropymode :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

set_partition_probs_in_vp9_entropymode :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_entropymode(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_entropymode :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_entropymode(cm.mi_cols);

        if get_plane_type_in_vp9_entropymode(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_entropymode(cm, xd);
}

get_partition_probs_in_vp9_entropymode :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_entropymode :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_entropymode :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_entropymode :: (
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

update_partition_context_in_vp9_entropymode :: (
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

partition_plane_context_in_vp9_entropymode :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

globals_initialization_state_for_vp9_entropymode: u32;
initialize_globals_for_vp9_entropymode :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_entropymode);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_entropymode, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_entropymode) != 2 {}
            return;
        }
    }
    SUB_PEL_FILTERS_12_in_vp9_entropymode =
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
    COUNT_TO_UPDATE_FACTOR_in_vp9_entropymode =
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
    VP9_KF_Y_MODE_PROB =
        [10] [9] Prob.[
            [9] Prob.[ Prob.[ 137, 30, 42, 148, 151, 207, 70, 52, 91 ], Prob.[ 92, 45, 102, 136, 116, 180, 74, 90, 100 ], Prob.[ 73, 32, 19, 187, 222, 215, 46, 34, 100 ], Prob.[ 91, 30, 32, 116, 121, 186, 93, 86, 94 ], Prob.[ 72, 35, 36, 149, 68, 206, 68, 63, 105 ], Prob.[ 73, 31, 28, 138, 57, 124, 55, 122, 151 ], Prob.[ 67, 23, 21, 140, 126, 197, 40, 37, 171 ], Prob.[ 86, 27, 28, 128, 154, 212, 45, 43, 53 ], Prob.[ 74, 32, 27, 107, 86, 160, 63, 134, 102 ], Prob.[ 59, 67, 44, 140, 161, 202, 78, 67, 119 ] ],
            [9] Prob.[ Prob.[ 63, 36, 126, 146, 123, 158, 60, 90, 96 ], Prob.[ 43, 46, 168, 134, 107, 128, 69, 142, 92 ], Prob.[ 44, 29, 68, 159, 201, 177, 50, 57, 77 ], Prob.[ 58, 38, 76, 114, 97, 172, 78, 133, 92 ], Prob.[ 46, 41, 76, 140, 63, 184, 69, 112, 57 ], Prob.[ 38, 32, 85, 140, 46, 112, 54, 151, 133 ], Prob.[ 39, 27, 61, 131, 110, 175, 44, 75, 136 ], Prob.[ 52, 30, 74, 113, 130, 175, 51, 64, 58 ], Prob.[ 47, 35, 80, 100, 74, 143, 64, 163, 74 ], Prob.[ 36, 61, 116, 114, 128, 162, 80, 125, 82 ] ],
            [9] Prob.[ Prob.[ 82, 26, 26, 171, 208, 204, 44, 32, 105 ], Prob.[ 55, 44, 68, 166, 179, 192, 57, 57, 108 ], Prob.[ 42, 26, 11, 199, 241, 228, 23, 15, 85 ], Prob.[ 68, 42, 19, 131, 160, 199, 55, 52, 83 ], Prob.[ 58, 50, 25, 139, 115, 232, 39, 52, 118 ], Prob.[ 50, 35, 33, 153, 104, 162, 64, 59, 131 ], Prob.[ 44, 24, 16, 150, 177, 202, 33, 19, 156 ], Prob.[ 55, 27, 12, 153, 203, 218, 26, 27, 49 ], Prob.[ 53, 49, 21, 110, 116, 168, 59, 80, 76 ], Prob.[ 38, 72, 19, 168, 203, 212, 50, 50, 107 ] ],
            [9] Prob.[ Prob.[ 103, 26, 36, 129, 132, 201, 83, 80, 93 ], Prob.[ 59, 38, 83, 112, 103, 162, 98, 136, 90 ], Prob.[ 62, 30, 23, 158, 200, 207, 59, 57, 50 ], Prob.[ 67, 30, 29, 84, 86, 191, 102, 91, 59 ], Prob.[ 60, 32, 33, 112, 71, 220, 64, 89, 104 ], Prob.[ 53, 26, 34, 130, 56, 149, 84, 120, 103 ], Prob.[ 53, 21, 23, 133, 109, 210, 56, 77, 172 ], Prob.[ 77, 19, 29, 112, 142, 228, 55, 66, 36 ], Prob.[ 61, 29, 29, 93, 97, 165, 83, 175, 162 ], Prob.[ 47, 47, 43, 114, 137, 181, 100, 99, 95 ] ],
            [9] Prob.[ Prob.[ 69, 23, 29, 128, 83, 199, 46, 44, 101 ], Prob.[ 53, 40, 55, 139, 69, 183, 61, 80, 110 ], Prob.[ 40, 29, 19, 161, 180, 207, 43, 24, 91 ], Prob.[ 60, 34, 19, 105, 61, 198, 53, 64, 89 ], Prob.[ 52, 31, 22, 158, 40, 209, 58, 62, 89 ], Prob.[ 44, 31, 29, 147, 46, 158, 56, 102, 198 ], Prob.[ 35, 19, 12, 135, 87, 209, 41, 45, 167 ], Prob.[ 55, 25, 21, 118, 95, 215, 38, 39, 66 ], Prob.[ 51, 38, 25, 113, 58, 164, 70, 93, 97 ], Prob.[ 47, 54, 34, 146, 108, 203, 72, 103, 151 ] ],
            [9] Prob.[ Prob.[ 64, 19, 37, 156, 66, 138, 49, 95, 133 ], Prob.[ 46, 27, 80, 150, 55, 124, 55, 121, 135 ], Prob.[ 36, 23, 27, 165, 149, 166, 54, 64, 118 ], Prob.[ 53, 21, 36, 131, 63, 163, 60, 109, 81 ], Prob.[ 40, 26, 35, 154, 40, 185, 51, 97, 123 ], Prob.[ 35, 19, 34, 179, 19, 97, 48, 129, 124 ], Prob.[ 36, 20, 26, 136, 62, 164, 33, 77, 154 ], Prob.[ 45, 18, 32, 130, 90, 157, 40, 79, 91 ], Prob.[ 45, 26, 28, 129, 45, 129, 49, 147, 123 ], Prob.[ 38, 44, 51, 136, 74, 162, 57, 97, 121 ] ],
            [9] Prob.[ Prob.[ 75, 17, 22, 136, 138, 185, 32, 34, 166 ], Prob.[ 56, 39, 58, 133, 117, 173, 48, 53, 187 ], Prob.[ 35, 21, 12, 161, 212, 207, 20, 23, 145 ], Prob.[ 56, 29, 19, 117, 109, 181, 55, 68, 112 ], Prob.[ 47, 29, 17, 153, 64, 220, 59, 51, 114 ], Prob.[ 46, 16, 24, 136, 76, 147, 41, 64, 172 ], Prob.[ 34, 17, 11, 108, 152, 187, 13, 15, 209 ], Prob.[ 51, 24, 14, 115, 133, 209, 32, 26, 104 ], Prob.[ 55, 30, 18, 122, 79, 179, 44, 88, 116 ], Prob.[ 37, 49, 25, 129, 168, 164, 41, 54, 148 ] ],
            [9] Prob.[ Prob.[ 82, 22, 32, 127, 143, 213, 39, 41, 70 ], Prob.[ 62, 44, 61, 123, 105, 189, 48, 57, 64 ], Prob.[ 47, 25, 17, 175, 222, 220, 24, 30, 86 ], Prob.[ 68, 36, 17, 106, 102, 206, 59, 74, 74 ], Prob.[ 57, 39, 23, 151, 68, 216, 55, 63, 58 ], Prob.[ 49, 30, 35, 141, 70, 168, 82, 40, 115 ], Prob.[ 51, 25, 15, 136, 129, 202, 38, 35, 139 ], Prob.[ 68, 26, 16, 111, 141, 215, 29, 28, 28 ], Prob.[ 59, 39, 19, 114, 75, 180, 77, 104, 42 ], Prob.[ 40, 61, 26, 126, 152, 206, 61, 59, 93 ] ],
            [9] Prob.[ Prob.[ 78, 23, 39, 111, 117, 170, 74, 124, 94 ], Prob.[ 48, 34, 86, 101, 92, 146, 78, 179, 134 ], Prob.[ 47, 22, 24, 138, 187, 178, 68, 69, 59 ], Prob.[ 56, 25, 33, 105, 112, 187, 95, 177, 129 ], Prob.[ 48, 31, 27, 114, 63, 183, 82, 116, 56 ], Prob.[ 43, 28, 37, 121, 63, 123, 61, 192, 169 ], Prob.[ 42, 17, 24, 109, 97, 177, 56, 76, 122 ], Prob.[ 58, 18, 28, 105, 139, 182, 70, 92, 63 ], Prob.[ 46, 23, 32, 74, 86, 150, 67, 183, 88 ], Prob.[ 36, 38, 48, 92, 122, 165, 88, 137, 91 ] ],
            [9] Prob.[ Prob.[ 65, 70, 60, 155, 159, 199, 61, 60, 81 ], Prob.[ 44, 78, 115, 132, 119, 173, 71, 112, 93 ], Prob.[ 39, 38, 21, 184, 227, 206, 42, 32, 64 ], Prob.[ 58, 47, 36, 124, 137, 193, 80, 82, 78 ], Prob.[ 49, 50, 35, 144, 95, 205, 63, 78, 59 ], Prob.[ 41, 53, 52, 148, 71, 142, 65, 128, 51 ], Prob.[ 40, 36, 28, 143, 143, 202, 40, 55, 137 ], Prob.[ 52, 34, 29, 129, 183, 227, 42, 35, 43 ], Prob.[ 42, 44, 44, 104, 105, 164, 64, 130, 80 ], Prob.[ 43, 81, 53, 140, 169, 204, 68, 84, 72 ] ]
        ];
    VP9_KF_UV_MODE_PROB =
        [9] Prob.[
            Prob.[ 144, 11, 54, 157, 195, 130, 46, 58, 108 ],
            Prob.[ 118, 15, 123, 148, 131, 101, 44, 93, 131 ],
            Prob.[ 113, 12, 23, 188, 226, 142, 26, 32, 125 ],
            Prob.[ 120, 11, 50, 123, 163, 135, 64, 77, 103 ],
            Prob.[ 113, 9, 36, 155, 111, 157, 32, 44, 161 ],
            Prob.[ 116, 9, 55, 176, 76, 96, 37, 61, 149 ],
            Prob.[ 115, 9, 28, 141, 161, 167, 21, 25, 193 ],
            Prob.[ 120, 12, 32, 145, 195, 142, 32, 38, 86 ],
            Prob.[ 116, 12, 64, 120, 140, 125, 49, 115, 121 ],
            Prob.[ 102, 19, 66, 162, 182, 122, 35, 59, 128 ]
        ];
    DEFAULT_IF_Y_PROBS =
        [9] Prob.[
            Prob.[ 65, 32, 18, 144, 162, 194, 41, 51, 98 ],
            Prob.[ 132, 68, 18, 165, 217, 196, 45, 40, 78 ],
            Prob.[ 173, 80, 19, 176, 240, 193, 64, 35, 46 ],
            Prob.[ 221, 135, 38, 194, 248, 121, 96, 85, 29 ]
        ];
    DEFAULT_IF_UV_PROBS =
        [9] Prob.[
            Prob.[ 120, 7, 76, 176, 208, 126, 28, 54, 103 ],
            Prob.[ 48, 12, 154, 155, 139, 90, 34, 117, 119 ],
            Prob.[ 67, 6, 25, 204, 243, 158, 13, 21, 96 ],
            Prob.[ 97, 5, 44, 131, 176, 139, 48, 68, 97 ],
            Prob.[ 83, 5, 42, 156, 111, 152, 26, 49, 152 ],
            Prob.[ 80, 5, 58, 178, 74, 83, 33, 62, 145 ],
            Prob.[ 86, 5, 32, 154, 192, 168, 14, 22, 163 ],
            Prob.[ 85, 5, 32, 156, 216, 148, 19, 29, 73 ],
            Prob.[ 77, 7, 64, 116, 132, 122, 37, 126, 120 ],
            Prob.[ 101, 21, 107, 181, 192, 103, 19, 67, 125 ]
        ];
    VP9_KF_PARTITION_PROBS =
        [3] Prob.[
            Prob.[ 158, 97, 94 ],
            Prob.[ 93, 24, 99 ],
            Prob.[ 85, 119, 44 ],
            Prob.[ 62, 59, 67 ],
            Prob.[ 149, 53, 53 ],
            Prob.[ 94, 20, 48 ],
            Prob.[ 83, 53, 24 ],
            Prob.[ 52, 18, 18 ],
            Prob.[ 150, 40, 39 ],
            Prob.[ 78, 12, 26 ],
            Prob.[ 67, 33, 11 ],
            Prob.[ 24, 7, 5 ],
            Prob.[ 174, 35, 49 ],
            Prob.[ 68, 11, 27 ],
            Prob.[ 57, 15, 9 ],
            Prob.[ 12, 3, 3 ]
        ];
    DEFAULT_PARTITION_PROBS =
        [3] Prob.[
            Prob.[ 199, 122, 141 ],
            Prob.[ 147, 63, 159 ],
            Prob.[ 148, 133, 118 ],
            Prob.[ 121, 104, 114 ],
            Prob.[ 174, 73, 87 ],
            Prob.[ 92, 41, 83 ],
            Prob.[ 82, 99, 50 ],
            Prob.[ 53, 39, 39 ],
            Prob.[ 177, 58, 59 ],
            Prob.[ 68, 26, 63 ],
            Prob.[ 52, 79, 25 ],
            Prob.[ 17, 14, 12 ],
            Prob.[ 222, 34, 30 ],
            Prob.[ 72, 16, 44 ],
            Prob.[ 58, 32, 12 ],
            Prob.[ 10, 7, 6 ]
        ];
    DEFAULT_INTER_MODE_PROBS =
        [3] Prob.[
            Prob.[ 2, 173, 34 ],
            Prob.[ 7, 145, 85 ],
            Prob.[ 7, 166, 63 ],
            Prob.[ 7, 94, 66 ],
            Prob.[ 8, 64, 46 ],
            Prob.[ 17, 81, 31 ],
            Prob.[ 25, 29, 30 ]
        ];
    VP9_INTRA_MODE_TREE =
        Tree_Index.[
            -0,
            2,
            -9,
            4,
            -1,
            6,
            8,
            12,
            -2,
            10,
            -4,
            -5,
            -3,
            14,
            -8,
            16,
            -6,
            -7
        ];
    VP9_INTER_MODE_TREE =
        Tree_Index.[
            cast,no_check(Tree_Index) (-(12 - 10)),
            2,
            cast,no_check(Tree_Index) (-(10 - 10)),
            4,
            cast,no_check(Tree_Index) (-(11 - 10)),
            cast,no_check(Tree_Index) (-(13 - 10))
        ];
    VP9_PARTITION_TREE =
        Tree_Index.[
            cast,no_check(Tree_Index) (-PARTITION_NONE),
            2,
            cast,no_check(Tree_Index) (-PARTITION_HORZ),
            4,
            cast,no_check(Tree_Index) (-PARTITION_VERT),
            cast,no_check(Tree_Index) (-PARTITION_SPLIT)
        ];
    DEFAULT_INTRA_INTER_P = Prob.[ 9, 102, 187, 225 ];
    DEFAULT_COMP_INTER_P =
        Prob.[
            239,
            183,
            119,
            96,
            41
        ];
    DEFAULT_COMP_REF_P =
        Prob.[
            50,
            126,
            123,
            221,
            226
        ];
    DEFAULT_SINGLE_REF_P =
        [2] Prob.[
            Prob.[ 33, 16 ],
            Prob.[ 77, 74 ],
            Prob.[ 142, 142 ],
            Prob.[ 172, 170 ],
            Prob.[ 238, 247 ]
        ];
    DEFAULT_TX_PROBS =
        Tx_Probs.{p32x32 = [3] Prob.[ Prob.[ 3, 136, 37 ], Prob.[ 5, 52, 13 ] ], p16x16 = [2] Prob.[ Prob.[ 20, 152 ], Prob.[ 15, 101 ] ], p8x8 = [1] Prob.[ Prob.[ 100 ], Prob.[ 66 ] ]};
    DEFAULT_SKIP_PROBS = Prob.[ 192, 128, 64 ];
    DEFAULT_SWITCHABLE_INTERP_PROB =
        [2] Prob.[
            Prob.[ 235, 162 ],
            Prob.[ 36, 255 ],
            Prob.[ 34, 3 ],
            Prob.[ 149, 144 ]
        ];
    VP9_SWITCHABLE_INTERP_TREE = Tree_Index.[ -0, 2, -1, -2 ];
    atomic_store(*globals_initialization_state_for_vp9_entropymode, 2);
}

