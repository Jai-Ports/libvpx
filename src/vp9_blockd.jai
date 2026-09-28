COUNT_TO_UPDATE_FACTOR_in_vp9_blockd: [21] s32;

clip_pixel_in_vp9_blockd :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_blockd :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_blockd :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_blockd :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_blockd :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_blockd(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_blockd(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_blockd(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_blockd :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_prob_in_vp9_blockd :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_blockd :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_blockd(n0, DEN);
}

weighted_prob_in_vp9_blockd :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_blockd :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_blockd(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_blockd(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_blockd :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_blockd[COUNT];
        PROB := get_prob_in_vp9_blockd(ct[0], DEN);
        return weighted_prob_in_vp9_blockd(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_lsb_in_vp9_blockd :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_blockd :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_blockd :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_blockd(num_values) + 1 else 0;
}

get_band_translate_in_vp9_blockd :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_blockd :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_blockd :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_blockd(above_ec, left_ec);
}

is_zero_mv_in_vp9_blockd :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_blockd :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_blockd :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_blockd(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_blockd(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_blockd :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_blockd :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_blockd :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_blockd :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

get_filter_taps_in_vp9_blockd :: (FILTER: *s16) -> s32 {
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

vp9_is_valid_scale_in_vp9_blockd :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_blockd :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_blockd(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_blockd :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_blockd :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_blockd :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_blockd :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_blockd :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_blockd :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_blockd :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_blockd :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

vp9_left_block_mode :: (cur_mi: *MODE_INFO, left_mi: *MODE_INFO, b: s32) -> PREDICTION_MODE {
    if b == 0 || b == 2 {
        if left_mi == null || is_inter_block_in_vp9_blockd(left_mi) != 0 {
            return 0;
        }

        return get_y_mode_in_vp9_blockd(left_mi, b + 1);
    } else {
        return cur_mi.bmi[b - 1].as_mode;
    }
}

vp9_above_block_mode :: (cur_mi: *MODE_INFO, above_mi: *MODE_INFO, b: s32) -> PREDICTION_MODE {
    if b == 0 || b == 1 {
        if above_mi == null || is_inter_block_in_vp9_blockd(above_mi) != 0 {
            return 0;
        }

        return get_y_mode_in_vp9_blockd(above_mi, b + 2);
    } else {
        return cur_mi.bmi[b - 2].as_mode;
    }
}

get_plane_type_in_vp9_blockd :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_blockd :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_blockd :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_blockd(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_blockd :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_blockd(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_blockd(MI, ib)];
}

vp9_setup_block_planes :: (xd: *MACROBLOCKD, ss_x: s32, ss_y: s32) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].subsampling_x = ifx i != 0 then ss_x else 0;
        xd.plane[i].subsampling_y = ifx i != 0 then ss_y else 0;
    }
}

get_uv_tx_size_in_vp9_blockd :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_blockd :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_blockd :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_blockd(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_blockd :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

vp9_foreach_transformed_block_in_plane :: (
    XD: *MACROBLOCKD,
    bsize: BLOCK_SIZE,
    plane: s32,
    visit: Foreach_Transformed_Block_Visitor,
    arg: *void
) {
    PD := XD.plane.data + plane;
    mi := XD.mi[0];

    TX_SIZE_ :=
        cast,no_check(TX_SIZE) ((ifx plane != 0 then cast,no_check(s32) get_uv_tx_size_in_vp9_blockd(mi, PD) else cast,no_check(s32) mi.tx_size));
    PLANE_BSIZE := get_plane_block_size_in_vp9_blockd(bsize, PD);
    NUM_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE];
    NUM_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE];
    STEP := (cast(s32) 1) << ((((cast(s32) TX_SIZE_) << 1)) & 31);
    i: s32 = 0;
    c: s32 = ---;

    MAX_BLOCKS_WIDE :=
        NUM_4X4_W +
            (ifx XD.mb_to_right_edge >= 0 then 0 else XD.mb_to_right_edge >> (((5 + PD.subsampling_x)) & 31));
    MAX_BLOCKS_HIGH :=
        NUM_4X4_H +
            (ifx XD.mb_to_bottom_edge >= 0 then 0 else XD.mb_to_bottom_edge >> (((5 + PD.subsampling_y)) & 31));
    EXTRA_STEP := ((NUM_4X4_W - MAX_BLOCKS_WIDE) >> ((TX_SIZE_) & 31)) * STEP;

    r: s32 = 0;
    while r < MAX_BLOCKS_HIGH {
        c = 0;
        while c < MAX_BLOCKS_WIDE {
            visit(plane, i, r, c, PLANE_BSIZE, TX_SIZE_, arg);
            i += STEP;
            c += (cast(s32) 1) << ((TX_SIZE_) & 31);
        }
        i += EXTRA_STEP;
        r += (cast(s32) 1) << ((TX_SIZE_) & 31);
    }
}

vp9_foreach_transformed_block :: (
    XD: *MACROBLOCKD,
    bsize: BLOCK_SIZE,
    visit: Foreach_Transformed_Block_Visitor,
    arg: *void
) {
    for plane: 0..cast(s32) 3 - 1 {
        vp9_foreach_transformed_block_in_plane(
            XD,
            bsize,
            plane,
            cast,no_check(Foreach_Transformed_Block_Visitor) (visit),
            arg
        );
    }
}

vp9_set_contexts :: (
    xd: *MACROBLOCKD,
    pd: *Macroblockd_Plane,
    plane_bsize: BLOCK_SIZE,
    tx_size: TX_SIZE,
    has_eob: s32,
    aoff: s32,
    loff: s32
) {
    A := pd.above_context + aoff;
    L := pd.left_context + loff;
    TX_SIZE_IN_BLOCKS := (cast(s32) 1) << ((tx_size) & 31);

    if has_eob != 0 && xd.mb_to_right_edge < 0 {
        BLOCKS_WIDE :=
            (cast(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[plane_bsize]) +
                xd.mb_to_right_edge >> (((5 + pd.subsampling_x)) & 31);
        above_contexts := TX_SIZE_IN_BLOCKS;
        if above_contexts + aoff > BLOCKS_WIDE {
            above_contexts = BLOCKS_WIDE - aoff;
        }

        i: s32 = 0;
        while i < above_contexts {
            A[i] = cast,no_check(ENTROPY_CONTEXT) has_eob;
            i += 1;
        }
        i = above_contexts;
        while i < TX_SIZE_IN_BLOCKS {
            A[i] = 0;
            i += 1;
        }
    } else {
        fill_memory(A, has_eob, cast,no_check(u64) TX_SIZE_IN_BLOCKS);
    }

    if has_eob != 0 && xd.mb_to_bottom_edge < 0 {
        BLOCKS_HIGH :=
            (cast(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[plane_bsize]) +
                xd.mb_to_bottom_edge >> (((5 + pd.subsampling_y)) & 31);
        left_contexts := TX_SIZE_IN_BLOCKS;
        if left_contexts + loff > BLOCKS_HIGH {
            left_contexts = BLOCKS_HIGH - loff;
        }

        i: s32 = 0;
        while i < left_contexts {
            L[i] = cast,no_check(ENTROPY_CONTEXT) has_eob;
            i += 1;
        }
        i = left_contexts;
        while i < TX_SIZE_IN_BLOCKS {
            L[i] = 0;
            i += 1;
        }
    } else {
        fill_memory(L, has_eob, cast,no_check(u64) TX_SIZE_IN_BLOCKS);
    }
}

globals_initialization_state_for_vp9_blockd: u32;
initialize_globals_for_vp9_blockd :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_blockd);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_blockd, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_blockd) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_vp9_blockd =
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
    atomic_store(*globals_initialization_state_for_vp9_blockd, 2);
}

Foreach_Transformed_Block_Visitor :: #type (_: s32, _: s32, _: s32, _: s32, _: BLOCK_SIZE, _: TX_SIZE, _: *void);

