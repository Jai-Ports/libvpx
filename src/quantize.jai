// Generated directly from C by cpp_transpiler.
COUNT_TO_UPDATE_FACTOR_in_quantize: [21] s32;

clip_pixel_in_quantize :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_quantize :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_quantize :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_quantize :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_quantize :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_quantize(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_quantize(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_quantize(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_quantize :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_quantize :: (FILTER: *s16) -> s32 {
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

quantize_b_c :: (
    coeff_ptr: *Tran_Low_T,
    n_coeffs: s64,
    MB_PLANE: *Macroblock_Plane_in_vp9_block,
    qcoeff_ptr: *Tran_Low_T,
    dqcoeff_ptr: *Tran_Low_T,
    dequant_ptr: *s16,
    eob_ptr: *u16,
    SCAN_ORDER: *Scan_Order_in_vp9_scan
) {
    non_zero_count := cast,no_check(s32) n_coeffs;
    eob: s32 = -1;
    ZBINS := s32.[ cast,no_check(s32) MB_PLANE.zbin[0], cast,no_check(s32) MB_PLANE.zbin[1] ];
    NZBINS := s32.[ ZBINS[0] * -1, ZBINS[1] * -1 ];
    round_ptr := MB_PLANE.round;
    quant_ptr := MB_PLANE.quant;
    quant_shift_ptr := MB_PLANE.quant_shift;
    scan := SCAN_ORDER.scan;

    fill_memory(qcoeff_ptr, 0, cast,no_check(u64) n_coeffs * size_of(Tran_Low_T));
    fill_memory(dqcoeff_ptr, 0, cast,no_check(u64) n_coeffs * size_of(Tran_Low_T));

    i := (cast,no_check(s32) n_coeffs) - 1;
    while i >= 0 {
        RC := cast,no_check(s32) scan[i];
        COEFF := cast,no_check(s32) coeff_ptr[RC];

        if COEFF < ZBINS[cast(s32) (RC != 0)] && COEFF > NZBINS[cast(s32) (RC != 0)] {
            non_zero_count -= 1;
        } else {
            break;
        }
        i -= 1;
    }

    i = 0;
    while i < non_zero_count {
        RC := cast,no_check(s32) scan[i];
        COEFF := cast,no_check(s32) coeff_ptr[RC];
        COEFF_SIGN := COEFF >> 31;
        ABS_COEFF := COEFF ^ COEFF_SIGN - COEFF_SIGN;

        if ABS_COEFF >= ZBINS[cast(s32) (RC != 0)] {
            tmp :=
                clamp_in_quantize(
                    ABS_COEFF + cast(s32) round_ptr[cast(s32) (RC != 0)],
                    cast,no_check(s32) (-32767 - 1),
                    32767
                );
            tmp =
                ((((tmp * cast(s32) quant_ptr[cast(s32) (RC != 0)]) >> 16) + tmp) *
                    cast(s32) quant_shift_ptr[cast(s32) (RC != 0)]) >> 16;
            qcoeff_ptr[RC] = cast,no_check(Tran_Low_T) (tmp ^ COEFF_SIGN - COEFF_SIGN);
            dqcoeff_ptr[RC] =
                cast,no_check(Tran_Low_T) ((cast(s32) qcoeff_ptr[RC]) *
                    cast(s32) dequant_ptr[cast(s32) (RC != 0)]);

            if tmp != 0 {
                eob = i;
            }
        }
        i += 1;
    }
    eob_ptr.* = cast,no_check(u16) (eob + 1);
}

quantize_b_32x32_c :: (
    coeff_ptr: *Tran_Low_T,
    MB_PLANE: *Macroblock_Plane_in_vp9_block,
    qcoeff_ptr: *Tran_Low_T,
    dqcoeff_ptr: *Tran_Low_T,
    dequant_ptr: *s16,
    eob_ptr: *u16,
    SCAN_ORDER: *Scan_Order_in_vp9_scan
) {
    N_COEFFS: s32 = cast,no_check(s32) ((32 * 32));
    ZBINS :=
        s32.[ ((cast(s32) MB_PLANE.zbin[0]) + (cast(s32) 1) << (((1 - 1)) & 31)) >> 1, ((cast(s32) MB_PLANE.zbin[1]) +
            (cast(s32) 1) << (((1 - 1)) & 31)) >> 1 ];
    NZBINS := s32.[ ZBINS[0] * -1, ZBINS[1] * -1 ];
    round_ptr := MB_PLANE.round;
    quant_ptr := MB_PLANE.quant;
    quant_shift_ptr := MB_PLANE.quant_shift;
    scan := SCAN_ORDER.scan;

    idx: s32 = 0;
    idx_arr: [1024] s32 = ---;
    eob: s32 = -1;

    fill_memory(qcoeff_ptr, 0, cast,no_check(u64) N_COEFFS * size_of(Tran_Low_T));
    fill_memory(dqcoeff_ptr, 0, cast,no_check(u64) N_COEFFS * size_of(Tran_Low_T));

    if 0 < N_COEFFS {
        for i: 0..N_COEFFS - 1 {
            RC := cast,no_check(s32) scan[i];
            COEFF := cast,no_check(s32) coeff_ptr[RC];

            if COEFF >= ZBINS[cast(s32) (RC != 0)] || COEFF <= NZBINS[cast(s32) (RC != 0)] {
                idx_arr[idx] = i;
                idx += 1;
            }
        }
    }

    if 0 < idx {
        for i: 0..idx - 1 {
            RC := cast,no_check(s32) scan[idx_arr[i]];
            COEFF := cast,no_check(s32) coeff_ptr[RC];
            COEFF_SIGN := COEFF >> 31;

            abs_coeff := COEFF ^ COEFF_SIGN - COEFF_SIGN;
            abs_coeff += ((cast(s32) round_ptr[cast(s32) (RC != 0)]) + (cast(s32) 1) << (((1 - 1)) & 31)) >> 1;
            abs_coeff = clamp_in_quantize(abs_coeff, cast,no_check(s32) (-32767 - 1), 32767);
            tmp :=
                ((((abs_coeff * cast(s32) quant_ptr[cast(s32) (RC != 0)]) >> 16) + abs_coeff) *
                    cast(s32) quant_shift_ptr[cast(s32) (RC != 0)]) >> 15;

            qcoeff_ptr[RC] = cast,no_check(Tran_Low_T) (tmp ^ COEFF_SIGN - COEFF_SIGN);

            dqcoeff_ptr[RC] =
                cast,no_check(Tran_Low_T) (((cast(s32) qcoeff_ptr[RC]) * cast(s32) dequant_ptr[cast(s32) (RC != 0)]) /
                    2);

            if tmp != 0 {
                eob = idx_arr[i];
            }
        }
    }
    eob_ptr.* = cast,no_check(u16) (eob + 1);
}

quantize_dc :: (
    coeff_ptr: *Tran_Low_T,
    n_coeffs: s32,
    round_ptr: *s16,
    QUANT: s16,
    qcoeff_ptr: *Tran_Low_T,
    dqcoeff_ptr: *Tran_Low_T,
    DEQUANT: s16,
    eob_ptr: *u16
) {
    RC: s32 = 0;
    COEFF := cast,no_check(s32) coeff_ptr[RC];
    COEFF_SIGN := COEFF >> 31;
    ABS_COEFF := COEFF ^ COEFF_SIGN - COEFF_SIGN;
    eob: s32 = -1;

    fill_memory(qcoeff_ptr, 0, cast,no_check(u64) n_coeffs * size_of(Tran_Low_T));
    fill_memory(dqcoeff_ptr, 0, cast,no_check(u64) n_coeffs * size_of(Tran_Low_T));

    tmp :=
        clamp_in_quantize(
            ABS_COEFF + cast(s32) round_ptr[cast(s32) (RC != 0)],
            cast,no_check(s32) (-32767 - 1),
            32767
        );
    tmp = (tmp * cast(s32) QUANT) >> 16;
    qcoeff_ptr[RC] = cast,no_check(Tran_Low_T) (tmp ^ COEFF_SIGN - COEFF_SIGN);
    dqcoeff_ptr[RC] = cast,no_check(Tran_Low_T) ((cast(s32) qcoeff_ptr[RC]) * cast(s32) DEQUANT);
    if tmp != 0 {
        eob = 0;
    }

    eob_ptr.* = cast,no_check(u16) (eob + 1);
}

quantize_dc_32x32 :: (
    coeff_ptr: *Tran_Low_T,
    round_ptr: *s16,
    QUANT: s16,
    qcoeff_ptr: *Tran_Low_T,
    dqcoeff_ptr: *Tran_Low_T,
    DEQUANT: s16,
    eob_ptr: *u16
) {
    N_COEFFS: s32 = 1024;
    RC: s32 = 0;
    COEFF := cast,no_check(s32) coeff_ptr[RC];
    COEFF_SIGN := COEFF >> 31;
    ABS_COEFF := COEFF ^ COEFF_SIGN - COEFF_SIGN;
    eob: s32 = -1;

    fill_memory(qcoeff_ptr, 0, cast,no_check(u64) N_COEFFS * size_of(Tran_Low_T));
    fill_memory(dqcoeff_ptr, 0, cast,no_check(u64) N_COEFFS * size_of(Tran_Low_T));

    tmp :=
        clamp_in_quantize(
            ABS_COEFF + ((cast(s32) round_ptr[cast(s32) (RC != 0)]) + (cast(s32) 1) << (((1 - 1)) & 31)) >> 1,
            cast,no_check(s32) (-32767 - 1),
            32767
        );
    tmp = (tmp * cast(s32) QUANT) >> 15;
    qcoeff_ptr[RC] = cast,no_check(Tran_Low_T) (tmp ^ COEFF_SIGN - COEFF_SIGN);
    dqcoeff_ptr[RC] = cast,no_check(Tran_Low_T) (((cast(s32) qcoeff_ptr[RC]) * cast(s32) DEQUANT) / 2);
    if tmp != 0 {
        eob = 0;
    }

    eob_ptr.* = cast,no_check(u16) (eob + 1);
}

get_prob_in_quantize :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_quantize :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_quantize(n0, DEN);
}

weighted_prob_in_quantize :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_quantize :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_quantize(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_quantize(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_quantize :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_quantize[COUNT];
        PROB := get_prob_in_quantize(ct[0], DEN);
        return weighted_prob_in_quantize(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_lsb :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb(num_values) + 1 else 0;
}

get_band_translate :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts(above_ec, left_ec);
}

is_zero_mv :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_quantize(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_quantize(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

vp9_is_valid_scale :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale(sf) != 0 && (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4 :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode(MI, ib)];
}

get_uv_tx_size :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_coef_context :: (neighbors: *s16, token_cache: *u8, c: s32) -> s32 {
    return ((1 + cast(s32) token_cache[neighbors[2 * c + 0]]) + cast(s32) token_cache[neighbors[2 * c + 1]]) >> 1;
}

get_scan :: (xd: *MACROBLOCKD, tx_size: TX_SIZE, type: PLANE_TYPE, block_idx: s32) -> *Scan_Order_in_vp9_scan {
    MI := xd.mi[0];

    if is_inter_block(MI) != 0 || type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 {
        return VP9_DEFAULT_SCAN_ORDERS.data + tx_size;
    } else {
        MODE := get_y_mode(MI, block_idx);
        return VP9_SCAN_ORDERS[tx_size].data + INTRA_MODE_TO_TX_TYPE_LOOKUP[MODE];
    }
}

globals_initialization_state_for_quantize: u32;
initialize_globals_for_quantize :: () {
    {
        state := atomic_load(*globals_initialization_state_for_quantize);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_quantize, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_quantize) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_quantize =
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
    atomic_store(*globals_initialization_state_for_quantize, 2);
}

Macroblock_Plane_in_vp9_block :: struct {
    src_diff: [4096] s16 #align 16;
    qcoeff: *Tran_Low_T #align 1;
    coeff: *Tran_Low_T #align 1;
    eobs: *u16 #align 1;
    src: Buf_2d #align 1;
    round_fp: *s16 #align 1;
    quant_fp: *s16 #align 1;
    quant: *s16 #align 1;
    quant_shift: *s16 #align 1;
    zbin: *s16 #align 1;
    round: *s16 #align 1;
    quant_thred: [2] s64 #align 1;
    layout_padding_0: [8] u8 #align 1;
} #no_padding;

Scan_Order_in_vp9_scan :: struct {
    scan: *s16;
    iscan: *s16;
    neighbors: *s16;
}

TX_SIZE :: u8;

ENTROPY_CONTEXT :: s8;

MV :: Mv;

MV_JOINT_TYPE :: u32;
MV_JOINT_ZERO : s32 : 0;
MV_JOINT_HNZVZ : s32 : 1;
MV_JOINT_HZVNZ : s32 : 2;
MV_JOINT_HNZVNZ : s32 : 3;

Scale_Factors :: struct {
    x_scale_fp: s32;
    y_scale_fp: s32;
    x_step_q4: s32;
    y_step_q4: s32;
    scale_value_x: #type (_: s32, _: *Scale_Factors) -> s32;
    scale_value_y: #type (_: s32, _: *Scale_Factors) -> s32;
    predict: [2] [2] [2] Convolve_Fn_T;
}

Segmentation :: struct {
    enabled: u8;
    update_map: u8;
    update_data: u8;
    abs_delta: u8;
    temporal_update: u8;
    tree_probs: [7] Prob;
    pred_probs: [3] Prob;
    feature_data: [8] [4] s16;
    feature_mask: [8] u32;
    aq_av_offset: s32;
}

PREDICTION_MODE :: u8;

MV_REFERENCE_FRAME :: s8;

BLOCK_SIZE :: u8;

MACROBLOCKD :: Macroblockd;

PLANE_TYPE :: u32;
PLANE_TYPE_Y : s32 : 0;
PLANE_TYPE_UV : s32 : 1;
PLANE_TYPES : s32 : 2;

TX_TYPE :: u32;
DCT_DCT : s32 : 0;
ADST_DCT : s32 : 1;
DCT_ADST : s32 : 2;
ADST_ADST : s32 : 3;
TX_TYPES : s32 : 4;

Macroblockd_Plane :: struct {
    dqcoeff: *Tran_Low_T;
    subsampling_x: s32;
    subsampling_y: s32;
    dst: Buf_2d;
    pre: [2] Buf_2d;
    above_context: *ENTROPY_CONTEXT;
    left_context: *ENTROPY_CONTEXT;
    seg_dequant: [8] [2] s16;
    n4_w: u16;
    n4_h: u16;
    n4_wl: u8;
    n4_hl: u8;
    dequant: *s16;
    eob: *s32;
}

Buf_2d :: struct {
    buf: *u8;
    stride: s32;
}

Mv :: struct {
    row: s16;
    col: s16;
}

Convolve_Fn_T :: #type (
    _: *u8,
    _: s64,
    _: *u8,
    _: s64,
    _: *Interp_Kernel,
    _: s32,
    _: s32,
    _: s32,
    _: s32,
    _: s32,
    _: s32
);

SEG_LVL_FEATURES :: u32;
SEG_LVL_ALT_Q : s32 : 0;
SEG_LVL_ALT_LF : s32 : 1;
SEG_LVL_REF_FRAME : s32 : 2;
SEG_LVL_SKIP : s32 : 3;
SEG_LVL_MAX : s32 : 4;

MODE_INFO :: struct {
    sb_type: BLOCK_SIZE #align 4;
    mode: PREDICTION_MODE #align 1;
    tx_size: TX_SIZE #align 1;
    skip: s8 #align 1;
    segment_id: s8 #align 1;
    seg_id_predicted: s8 #align 1;
    uv_mode: PREDICTION_MODE #align 1;
    interp_filter: INTERP_FILTER #align 1;
    ref_frame: [2] MV_REFERENCE_FRAME #align 1;
    layout_padding_0: [2] u8 #align 1;
    mv: [2] Int_Mv #align 1;
    bmi: [4] B_Mode_Info #align 1;
} #no_padding;

PARTITION_TYPE :: u32;
PARTITION_NONE : s32 : 0;
PARTITION_HORZ : s32 : 1;
PARTITION_VERT : s32 : 2;
PARTITION_SPLIT : s32 : 3;
PARTITION_TYPES : s32 : 4;
PARTITION_INVALID : s32 : 4;

Macroblockd :: struct {
    plane: [3] Macroblockd_Plane;
    bmode_blocks_wl: u8;
    bmode_blocks_hl: u8;
    counts: *FRAME_COUNTS;
    tile: Tile_Info;
    mi_stride: s32;
    mi: **MODE_INFO;
    left_mi: *MODE_INFO;
    above_mi: *MODE_INFO;
    max_blocks_wide: u32;
    max_blocks_high: u32;
    partition_probs: *[3] Prob;
    mb_to_left_edge: s32;
    mb_to_right_edge: s32;
    mb_to_top_edge: s32;
    mb_to_bottom_edge: s32;
    fc: *FRAME_CONTEXT;
    block_refs: [2] *Ref_Buffer;
    cur_buf: *YV12_BUFFER_CONFIG;
    above_context: [3] *ENTROPY_CONTEXT;
    left_context: [3] [16] ENTROPY_CONTEXT;
    above_seg_context: *PARTITION_CONTEXT;
    left_seg_context: [8] PARTITION_CONTEXT;
    lossless: s32;
    corrupted: s32;
    error_info: *Internal_Error_Info_in_vp9_blockd;
    partition: *PARTITION_TYPE;
}

INTERP_FILTER :: u8;

FRAME_CONTEXT :: Frame_Contexts;

PARTITION_CONTEXT :: s8;

Int_Mv :: union {
    as_int: u32;
    as_mv: MV;
}

B_Mode_Info :: struct {
    as_mode: PREDICTION_MODE #align 4;
    layout_padding_0: [3] u8 #align 1;
    as_mv: [2] Int_Mv #align 1;
} #no_padding;

FRAME_COUNTS :: struct {
    y_mode: [4] [10] u32;
    uv_mode: [10] [10] u32;
    partition: [16] [4] u32;
    coef: [4] [2] Vp9_Coeff_Count_Model;
    eob_branch: [4] [2] [2] [6] [6] u32;
    switchable_interp: [4] [3] u32;
    inter_mode: [7] [4] u32;
    intra_inter: [4] [2] u32;
    comp_inter: [5] [2] u32;
    single_ref: [5] [2] [2] u32;
    comp_ref: [5] [2] u32;
    tx: Tx_Counts;
    skip: [3] [2] u32;
    mv: Nmv_Context_Counts;
}

Tile_Info :: struct {
    mi_row_start: s32;
    mi_row_end: s32;
    mi_col_start: s32;
    mi_col_end: s32;
}

Frame_Contexts :: struct {
    y_mode_prob: [4] [9] Prob;
    uv_mode_prob: [10] [9] Prob;
    partition_prob: [16] [3] Prob;
    coef_probs: [4] [2] Vp9_Coeff_Probs_Model;
    switchable_interp_prob: [4] [2] Prob;
    inter_mode_probs: [7] [3] Prob;
    intra_inter_prob: [4] Prob;
    comp_inter_prob: [5] Prob;
    single_ref_prob: [5] [2] Prob;
    comp_ref_prob: [5] Prob;
    tx_probs: Tx_Probs;
    skip_probs: [3] Prob;
    nmvc: Nmv_Context;
    initialized: s32;
}

Ref_Buffer :: struct {
    idx: s32;
    buf: *YV12_BUFFER_CONFIG;
    sf: Scale_Factors;
}

Vp9_Coeff_Count_Model :: [2] [6] [6] [4] u32;

Tx_Counts :: struct {
    p32x32: [2] [4] u32;
    p16x16: [2] [3] u32;
    p8x8: [2] [2] u32;
    tx_totals: [4] u32;
}

Vp9_Coeff_Probs_Model :: [2] [6] [6] [3] Prob;

Tx_Probs :: struct {
    p32x32: [2] [3] Prob;
    p16x16: [2] [2] Prob;
    p8x8: [2] [1] Prob;
}

Nmv_Context_Counts :: struct {
    joints: [4] u32;
    comps: [2] Nmv_Component_Counts;
}

Nmv_Context :: struct {
    joints: [3] Prob;
    comps: [2] Nmv_Component;
}

Nmv_Component_Counts :: struct {
    sign: [2] u32;
    classes: [11] u32;
    class0: [2] u32;
    bits: [10] [2] u32;
    class0_fp: [2] [4] u32;
    fp: [4] u32;
    class0_hp: [2] u32;
    hp: [2] u32;
}

Nmv_Component :: struct {
    sign: Prob;
    classes: [10] Prob;
    class0: [1] Prob;
    bits: [10] Prob;
    class0_fp: [2] [3] Prob;
    fp: [3] Prob;
    class0_hp: Prob;
    hp: Prob;
}

