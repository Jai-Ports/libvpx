V16x16 :: struct {
    part_variances: Partition_Variance;
    split: [4] V8x8;
}

V8x8 :: struct {
    part_variances: Partition_Variance;
    split: [4] V4x4;
}

V4x4 :: struct {
    part_variances: Partition_Variance;
    split: [4] Var;
}

Var :: struct {
    sum_square_error: u32;
    sum_error: s32;
    log2_count: s32;
    variance: s32;
}

Partition_Variance :: struct {
    none: Var;
    horz: [2] Var;
    vert: [2] Var;
}

V64x64 :: struct {
    part_variances: Partition_Variance;
    split: [4] V32x32;
}

V32x32 :: struct {
    part_variances: Partition_Variance;
    split: [4] V16x16;
}

Variance_Node :: struct {
    part_variances: *Partition_Variance;
    split: [4] *Var;
}

TREE_LEVEL :: u32;
V16X16 : s32 : 0;
V32X32 : s32 : 1;
V64X64 : s32 : 2;

SUB_PEL_FILTERS_12_in_vp9_encodeframe: [16] Interp_Kernel12 #align 256;

COUNT_TO_UPDATE_FACTOR_in_vp9_encodeframe: [21] s32;

COSPI_1_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_2_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_3_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_4_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_5_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_6_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_7_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_8_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_9_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_10_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_11_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_12_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_13_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_14_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_15_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_16_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_17_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_18_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_19_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_20_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_21_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_22_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_23_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_24_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_25_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_26_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_27_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_28_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_29_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_30_64_in_vp9_encodeframe: Tran_Coef_T;

COSPI_31_64_in_vp9_encodeframe: Tran_Coef_T;

SINPI_1_9_in_vp9_encodeframe: Tran_Coef_T;

SINPI_2_9_in_vp9_encodeframe: Tran_Coef_T;

SINPI_3_9_in_vp9_encodeframe: Tran_Coef_T;

SINPI_4_9_in_vp9_encodeframe: Tran_Coef_T;

MODE_2_COUNTER_in_vp9_encodeframe: [14] s32;

COUNTER_TO_CONTEXT_in_vp9_encodeframe: [19] s32;

MV_REF_BLOCKS_in_vp9_encodeframe: [13] [8] POSITION;

IDX_N_COLUMN_TO_SUBBLOCK_in_vp9_encodeframe: [4] [2] s32;

FRAME_SCALE_FACTOR_in_vp9_encodeframe: [2] s32;

RATE_THRESH_MULT_in_vp9_encodeframe: [2] float64;

RCF_MULT_in_vp9_encodeframe: [2] float64;

VP9_VAR_OFFS: [64] u8;

K_VP9_REF_FLAG_LIST_in_vp9_encodeframe: [4] s32;

VP9_RECT_PART_NNCONFIG_64: NN_CONFIG;

VP9_RECT_PART_NN_BIAS_64_LAYER1: [4] float32;

VP9_RECT_PART_NN_BIAS_64_LAYER0: [24] float32;

VP9_RECT_PART_NN_WEIGHTS_64_LAYER1: [96] float32;

VP9_RECT_PART_NN_WEIGHTS_64_LAYER0: [192] float32;

VP9_RECT_PART_NNCONFIG_32: NN_CONFIG;

VP9_RECT_PART_NN_BIAS_32_LAYER1: [4] float32;

VP9_RECT_PART_NN_BIAS_32_LAYER0: [16] float32;

VP9_RECT_PART_NN_WEIGHTS_32_LAYER1: [64] float32;

VP9_RECT_PART_NN_WEIGHTS_32_LAYER0: [128] float32;

VP9_RECT_PART_NNCONFIG_16: NN_CONFIG;

VP9_RECT_PART_NN_BIAS_16_LAYER1: [4] float32;

VP9_RECT_PART_NN_BIAS_16_LAYER0: [16] float32;

VP9_RECT_PART_NN_WEIGHTS_16_LAYER1: [64] float32;

VP9_RECT_PART_NN_WEIGHTS_16_LAYER0: [128] float32;

VP9_64_ZEROS: [64] u8 #align 16;

VP9_PARTITION_BREAKOUT_WEIGHTS_8: [2] [3] [5] float32;

VP9_PARTITION_BREAKOUT_WEIGHTS_16: [2] [3] [5] float32;

VP9_PARTITION_BREAKOUT_WEIGHTS_32: [2] [3] [5] float32;

VP9_PARTITION_BREAKOUT_WEIGHTS_64: [2] [3] [5] float32;

VP9_PARTITION_LINEAR_WEIGHTS: [24] float32;

VP9_PARTITION_FEATURE_STD: [24] float32;

VP9_PARTITION_FEATURE_MEAN: [24] float32;

VP9_PARTITION_NNCONFIG_16X16: NN_CONFIG;

VP9_PARTITION_NN_BIAS_16X16_LAYER1: [1] float32;

VP9_PARTITION_NN_BIAS_16X16_LAYER0: [8] float32;

VP9_PARTITION_NN_WEIGHTS_16X16_LAYER1: [8] float32;

VP9_PARTITION_NN_WEIGHTS_16X16_LAYER0: [56] float32;

VP9_PARTITION_NNCONFIG_32X32: NN_CONFIG;

VP9_PARTITION_NN_BIAS_32X32_LAYER1: [1] float32;

VP9_PARTITION_NN_BIAS_32X32_LAYER0: [8] float32;

VP9_PARTITION_NN_WEIGHTS_32X32_LAYER1: [8] float32;

VP9_PARTITION_NN_WEIGHTS_32X32_LAYER0: [56] float32;

VP9_PARTITION_NNCONFIG_64X64: NN_CONFIG;

VP9_PARTITION_NN_BIAS_64X64_LAYER1: [1] float32;

VP9_PARTITION_NN_BIAS_64X64_LAYER0: [8] float32;

VP9_PARTITION_NN_WEIGHTS_64X64_LAYER1: [8] float32;

VP9_PARTITION_NN_WEIGHTS_64X64_LAYER0: [56] float32;

VP9_PART_SPLIT_NNCONFIG_8: NN_CONFIG;

VP9_PART_SPLIT_NN_BIAS_8_LAYER1: [1] float32;

VP9_PART_SPLIT_NN_BIAS_8_LAYER0: [8] float32;

VP9_PART_SPLIT_NN_WEIGHTS_8_LAYER1: [8] float32;

VP9_PART_SPLIT_NN_WEIGHTS_8_LAYER0: [96] float32;

VP9_PART_SPLIT_NNCONFIG_16: NN_CONFIG;

VP9_PART_SPLIT_NN_BIAS_16_LAYER1: [1] float32;

VP9_PART_SPLIT_NN_BIAS_16_LAYER0: [8] float32;

VP9_PART_SPLIT_NN_WEIGHTS_16_LAYER1: [8] float32;

VP9_PART_SPLIT_NN_WEIGHTS_16_LAYER0: [96] float32;

VP9_PART_SPLIT_NNCONFIG_32: NN_CONFIG;

VP9_PART_SPLIT_NN_BIAS_32_LAYER1: [1] float32;

VP9_PART_SPLIT_NN_BIAS_32_LAYER0: [8] float32;

VP9_PART_SPLIT_NN_WEIGHTS_32_LAYER1: [8] float32;

VP9_PART_SPLIT_NN_WEIGHTS_32_LAYER0: [96] float32;

VP9_PART_SPLIT_NNCONFIG_64: NN_CONFIG;

VP9_PART_SPLIT_NN_BIAS_64_LAYER1: [1] float32;

VP9_PART_SPLIT_NN_BIAS_64_LAYER0: [8] float32;

VP9_PART_SPLIT_NN_WEIGHTS_64_LAYER1: [8] float32;

VP9_PART_SPLIT_NN_WEIGHTS_64_LAYER0: [96] float32;

MAX_PARTITION_SIZE: [13] BLOCK_SIZE;

MIN_PARTITION_SIZE: [13] BLOCK_SIZE;

NEXT_SQUARE_SIZE: [13] BLOCK_SIZE;

VP9_VAR_PART_NNCONFIG_16: NN_CONFIG;

VP9_VAR_PART_NN_BIAS_16_LAYER1: [1] float32;

VP9_VAR_PART_NN_BIAS_16_LAYER0: [8] float32;

VP9_VAR_PART_NN_WEIGHTS_16_LAYER1: [8] float32;

VP9_VAR_PART_NN_WEIGHTS_16_LAYER0: [48] float32;

VP9_VAR_PART_NNCONFIG_32: NN_CONFIG;

VP9_VAR_PART_NN_BIAS_32_LAYER1: [1] float32;

VP9_VAR_PART_NN_BIAS_32_LAYER0: [8] float32;

VP9_VAR_PART_NN_WEIGHTS_32_LAYER1: [8] float32;

VP9_VAR_PART_NN_WEIGHTS_32_LAYER0: [48] float32;

VP9_VAR_PART_NNCONFIG_64: NN_CONFIG;

VP9_VAR_PART_NN_BIAS_64_LAYER1: [1] float32;

VP9_VAR_PART_NN_BIAS_64_LAYER0: [8] float32;

VP9_VAR_PART_NN_WEIGHTS_64_LAYER1: [8] float32;

VP9_VAR_PART_NN_WEIGHTS_64_LAYER0: [48] float32;

clip_pixel_in_vp9_encodeframe :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_encodeframe :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_encodeframe :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_encodeframe :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_encodeframe :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_encodeframe(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_encodeframe(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_encodeframe(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_encodeframe :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_lsb_in_vp9_encodeframe :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_encodeframe :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_encodeframe :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_encodeframe(num_values) + 1 else 0;
}

get_filter_taps_in_vp9_encodeframe :: (FILTER: *s16) -> s32 {
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

usec_timer_start_in_vp9_encodeframe :: (t: *Usec_Timer) {
    clock_gettime(4, *t.begin);
}

usec_timer_mark_in_vp9_encodeframe :: (t: *Usec_Timer) {
    clock_gettime(4, *t.end);
}

usec_timer_elapsed_in_vp9_encodeframe :: (t: *Usec_Timer) -> s64 {
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

get_prob_in_vp9_encodeframe :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_encodeframe :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_encodeframe(n0, DEN);
}

weighted_prob_in_vp9_encodeframe :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_encodeframe :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_encodeframe(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_encodeframe(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_encodeframe :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_encodeframe[COUNT];
        PROB := get_prob_in_vp9_encodeframe(ct[0], DEN);
        return weighted_prob_in_vp9_encodeframe(
            cast,no_check(s32) pre_prob,
            cast,no_check(s32) PROB,
            cast,no_check(s32) FACTOR
        );
    }
}

get_band_translate_in_vp9_encodeframe :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_encodeframe :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_encodeframe :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_encodeframe(above_ec, left_ec);
}

is_zero_mv_in_vp9_encodeframe :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_encodeframe :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_encodeframe :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_encodeframe(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_encodeframe(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_encodeframe :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_encodeframe :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_encodeframe :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_encodeframe :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

check_range_in_vp9_encodeframe :: (input: Tran_High_T) -> Tran_High_T {
    return input;
}

dct_const_round_shift_in_vp9_encodeframe :: (input: Tran_High_T) -> Tran_High_T {
    rv := (input + cast,no_check(Tran_High_T) (((cast(s32) 1) << (((14 - 1)) & 31)))) >> 14;
    return rv;
}

clip_pixel_add_in_vp9_encodeframe :: (dest: u8, trans: Tran_High_T) -> u8 {
    trans = check_range_in_vp9_encodeframe(trans);
    return clip_pixel_in_vp9_encodeframe((cast(s32) dest) + trans);
}

vp9_is_valid_scale_in_vp9_encodeframe :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_encodeframe :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_encodeframe(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_encodeframe :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_encodeframe :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_encodeframe :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_encodeframe :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_encodeframe :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_encodeframe :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_encodeframe :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_encodeframe :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_encodeframe :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_encodeframe :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_encodeframe :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_encodeframe(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_encodeframe :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_encodeframe(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_encodeframe(MI, ib)];
}

get_uv_tx_size_in_vp9_encodeframe :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_encodeframe :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_encodeframe :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_encodeframe(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_encodeframe :: (
    mi: *MODE_INFO,
    above_mi: *MODE_INFO,
    left_mi: *MODE_INFO,
    block: s32
) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_encodeframe :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_encodeframe :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_encodeframe :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_encodeframe :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_encodeframe :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_encodeframe :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_encodeframe :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_encodeframe :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_encodeframe :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_encodeframe :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_encodeframe :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_encodeframe :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_encodeframe(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_encodeframe :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_encodeframe(cm.mi_cols);

        if get_plane_type_in_vp9_encodeframe(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_encodeframe(cm, xd);
}

get_partition_probs_in_vp9_encodeframe :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_encodeframe :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_encodeframe :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_encodeframe :: (
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

update_partition_context_in_vp9_encodeframe :: (
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

partition_plane_context_in_vp9_encodeframe :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

clamp_mv_ref_in_vp9_encodeframe :: (mv: *MV, xd: *MACROBLOCKD) {
    clamp_mv_in_vp9_encodeframe(
        mv,
        xd.mb_to_left_edge - (cast(s32) 16) << 3,
        xd.mb_to_right_edge + (cast(s32) 16) << 3,
        xd.mb_to_top_edge - (cast(s32) 16) << 3,
        xd.mb_to_bottom_edge + (cast(s32) 16) << 3
    );
}

get_sub_block_mv_in_vp9_encodeframe :: (
    candidate: *MODE_INFO,
    which_mv: s32,
    search_col: s32,
    block_idx: s32
) -> Int_Mv {
    return ifx block_idx >= 0 && candidate.sb_type < 3 then candidate.bmi[IDX_N_COLUMN_TO_SUBBLOCK_in_vp9_encodeframe[block_idx][cast(s32) (search_col == 0)]].as_mv[which_mv] else candidate.mv[which_mv];
}

scale_mv_in_vp9_encodeframe :: (
    mi: *MODE_INFO,
    ref: s32,
    THIS_REF_FRAME: MV_REFERENCE_FRAME,
    ref_sign_bias: *s32
) -> Int_Mv {
    mv := mi.mv[ref];
    if ref_sign_bias[mi.ref_frame[ref]] != ref_sign_bias[THIS_REF_FRAME] {
        mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mv.as_mv.row) * -1);
        mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mv.as_mv.col) * -1);
    }
    return mv;
}

is_inside_in_vp9_encodeframe :: (TILE: *Tile_Info, mi_col: s32, mi_row: s32, mi_rows: s32, mi_pos: *POSITION) -> s32 {
    if !(mi_row + mi_pos.row < 0 || mi_col + mi_pos.col < TILE.mi_col_start || mi_row + mi_pos.row >= mi_rows || mi_col + mi_pos.col >= TILE.mi_col_end) {
        return 1;
    }
    return 0;
}

clamp_mv2_in_vp9_encodeframe :: (mv: *MV, xd: *MACROBLOCKD) {
    clamp_mv_in_vp9_encodeframe(
        mv,
        xd.mb_to_left_edge - (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_right_edge + (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_top_edge - (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_bottom_edge + (cast,no_check(s32) ((160 - 4))) << 3
    );
}

lower_mv_precision_in_vp9_encodeframe :: (mv: *MV, allow_hp: s32) {
    USE_HP := cast(s32) (allow_hp != 0 && use_mv_hp_in_vp9_encodeframe(mv) != 0);
    if USE_HP == 0 {
        if mv.row & 1 != 0 {
            c_transpiler_compound_add(*(mv.row), ((ifx mv.row > 0 then cast(s32) -1 else 1)), s32, s32);
        }
        if mv.col & 1 != 0 {
            c_transpiler_compound_add(*(mv.col), ((ifx mv.col > 0 then cast(s32) -1 else 1)), s32, s32);
        }
    }
}

get_segment_id_in_vp9_encodeframe :: (
    cm: *VP9_COMMON,
    segment_ids: *u8,
    bsize: BLOCK_SIZE,
    mi_row: s32,
    mi_col: s32
) -> s32 {
    MI_OFFSET := mi_row * cm.mi_cols + mi_col;
    BW := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize];
    BH := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize];
    XMIS := (ifx cm.mi_cols - mi_col < BW then cm.mi_cols - mi_col else BW);
    YMIS := (ifx cm.mi_rows - mi_row < BH then cm.mi_rows - mi_row else BH);
    x: s32 = ---;
    segment_id: s32 = 8;

    if 0 < YMIS {
        for y: 0..YMIS - 1 {
            x = 0;
            while x < XMIS {
                segment_id =
                    ifx segment_id < cast,no_check(s32) segment_ids[MI_OFFSET + y * cm.mi_cols +
                        x] then segment_id else cast,no_check(s32) segment_ids[MI_OFFSET + y * cm.mi_cols + x];
                x += 1;
            }
        }
    }

    return segment_id;
}

vp9_get_pred_context_seg_id_in_vp9_encodeframe :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    ABOVE_SIP := (ifx ABOVE_MI != null then cast,no_check(s32) ABOVE_MI.seg_id_predicted else 0);
    LEFT_SIP := (ifx LEFT_MI != null then cast,no_check(s32) LEFT_MI.seg_id_predicted else 0);

    return ABOVE_SIP + LEFT_SIP;
}

vp9_get_pred_prob_seg_id_in_vp9_encodeframe :: (seg: *Segmentation, xd: *MACROBLOCKD) -> Prob {
    return seg.pred_probs[vp9_get_pred_context_seg_id_in_vp9_encodeframe(xd)];
}

vp9_get_skip_context_in_vp9_encodeframe :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    ABOVE_SKIP := (ifx ABOVE_MI != null then cast,no_check(s32) ABOVE_MI.skip else 0);
    LEFT_SKIP := (ifx LEFT_MI != null then cast,no_check(s32) LEFT_MI.skip else 0);
    return ABOVE_SKIP + LEFT_SKIP;
}

vp9_get_skip_prob_in_vp9_encodeframe :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.skip_probs[vp9_get_skip_context_in_vp9_encodeframe(xd)];
}

get_pred_context_switchable_interp_in_vp9_encodeframe :: (xd: *MACROBLOCKD) -> s32 {
    LEFT_MI := xd.left_mi;
    LEFT_TYPE := (ifx LEFT_MI != null then cast,no_check(s32) LEFT_MI.interp_filter else 3);
    ABOVE_MI := xd.above_mi;
    ABOVE_TYPE := (ifx ABOVE_MI != null then cast,no_check(s32) ABOVE_MI.interp_filter else 3);

    if LEFT_TYPE == ABOVE_TYPE {
        return LEFT_TYPE;
    } else if LEFT_TYPE == 3 {
        return ABOVE_TYPE;
    } else if ABOVE_TYPE == 3 {
        return LEFT_TYPE;
    } else {
        return 3;
    }
}

get_intra_inter_context_in_vp9_encodeframe :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    HAS_ABOVE := cast(s32) (ABOVE_MI != null);
    HAS_LEFT := cast(s32) (LEFT_MI != null);

    if HAS_ABOVE != 0 && HAS_LEFT != 0 {
        ABOVE_INTRA := cast(s32) (is_inter_block_in_vp9_encodeframe(ABOVE_MI) == 0);
        LEFT_INTRA := cast(s32) (is_inter_block_in_vp9_encodeframe(LEFT_MI) == 0);
        return ifx LEFT_INTRA != 0 && ABOVE_INTRA != 0 then 3 else cast(s32) (LEFT_INTRA != 0 || ABOVE_INTRA != 0);
    } else if HAS_ABOVE != 0 || HAS_LEFT != 0 {
        return 2 * cast(s32) (is_inter_block_in_vp9_encodeframe((ifx HAS_ABOVE != 0 then ABOVE_MI else LEFT_MI)) == 0);
    }
    return 0;
}

vp9_get_intra_inter_prob_in_vp9_encodeframe :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.intra_inter_prob[get_intra_inter_context_in_vp9_encodeframe(xd)];
}

vp9_get_reference_mode_prob_in_vp9_encodeframe :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.comp_inter_prob[vp9_get_reference_mode_context(cm, xd)];
}

vp9_get_pred_prob_comp_ref_p_in_vp9_encodeframe :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    PRED_CONTEXT := vp9_get_pred_context_comp_ref_p(cm, xd);
    return cm.fc.comp_ref_prob[PRED_CONTEXT];
}

vp9_get_pred_prob_single_ref_p1_in_vp9_encodeframe :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return ((cm.fc.single_ref_prob[vp9_get_pred_context_single_ref_p1(xd)]).data)[0];
}

vp9_get_pred_prob_single_ref_p2_in_vp9_encodeframe :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return ((cm.fc.single_ref_prob[vp9_get_pred_context_single_ref_p2(xd)]).data)[1];
}

get_tx_size_context_in_vp9_encodeframe :: (xd: *MACROBLOCKD) -> s32 {
    MAX_TX_SIZE := cast,no_check(s32) MAX_TXSIZE_LOOKUP[xd.mi[0].sb_type];
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    HAS_ABOVE := cast(s32) (ABOVE_MI != null);
    HAS_LEFT := cast(s32) (LEFT_MI != null);
    above_ctx := (ifx HAS_ABOVE != 0 && ABOVE_MI.skip == 0 then cast,no_check(s32) ABOVE_MI.tx_size else MAX_TX_SIZE);
    left_ctx := (ifx HAS_LEFT != 0 && LEFT_MI.skip == 0 then cast,no_check(s32) LEFT_MI.tx_size else MAX_TX_SIZE);
    if HAS_LEFT == 0 {
        left_ctx = above_ctx;
    }

    if HAS_ABOVE == 0 {
        above_ctx = left_ctx;
    }

    if above_ctx + left_ctx > MAX_TX_SIZE {
        return 1;
    }
    return 0;
}

get_tx_probs_in_vp9_encodeframe :: (max_tx_size: TX_SIZE, ctx: s32, tx_probs: *Tx_Probs) -> *Prob {
    if cast,no_check(s32) max_tx_size == {
        case cast,no_check(s32) cast(TX_SIZE) 1;
            return tx_probs.p8x8[ctx].data;
        case cast,no_check(s32) cast(TX_SIZE) 2;
            return tx_probs.p16x16[ctx].data;
        case cast,no_check(s32) cast(TX_SIZE) 3;
            return tx_probs.p32x32[ctx].data;
        case;
            return null;
    }
    return unreachable_value(*Prob);
}

get_tx_counts_in_vp9_encodeframe :: (max_tx_size: TX_SIZE, ctx: s32, tx_counts: *Tx_Counts) -> *u32 {
    if cast,no_check(s32) max_tx_size == {
        case cast,no_check(s32) cast(TX_SIZE) 1;
            return tx_counts.p8x8[ctx].data;
        case cast,no_check(s32) cast(TX_SIZE) 2;
            return tx_counts.p16x16[ctx].data;
        case cast,no_check(s32) cast(TX_SIZE) 3;
            return tx_counts.p32x32[ctx].data;
        case;
            return null;
    }
    return unreachable_value(*u32);
}

inter_predictor_in_vp9_encodeframe :: (
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

scaled_buffer_offset_in_vp9_encodeframe :: (x_offset: s32, y_offset: s32, stride: s32, sf: *Scale_Factors) -> s64 {
    X := (ifx sf != null then sf.scale_value_x(x_offset, sf) else x_offset);
    Y := (ifx sf != null then sf.scale_value_y(y_offset, sf) else y_offset);
    return ((cast,no_check(s64) Y) * cast(s64) stride) + cast(s64) X;
}

setup_pred_plane_in_vp9_encodeframe :: (
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
    dst.buf = src + scaled_buffer_offset_in_vp9_encodeframe(X, Y, stride, scale);
    dst.stride = stride;
}

vp8_set_reference_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_vp9_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

gcd_in_vp9_encodeframe :: (a: s64, b: s32) -> s32 {
    while b != 0 {
        r := cast,no_check(s32) (a % cast(s64) b);
        a = cast,no_check(s64) b;
        b = r;
    }

    return cast,no_check(s32) a;
}

reduce_ratio_in_vp9_encodeframe :: (ratio: *Rational64_T) {
    DENOM := gcd_in_vp9_encodeframe(ratio.num, ratio.den);
    ratio.num /= cast,no_check(s64) DENOM;
    ratio.den /= DENOM;
}

cyclic_refresh_segment_id_boosted_in_vp9_encodeframe :: (segment_id: s32) -> s32 {
    if segment_id == 1 || segment_id == 2 {
        return 1;
    }
    return 0;
}

cyclic_refresh_segment_id_in_vp9_encodeframe :: (segment_id: s32) -> s32 {
    if segment_id == 1 {
        return 1;
    } else if segment_id == 2 {
        return 2;
    } else {
        return 0;
    }
}

fps_init_first_pass_info_in_vp9_encodeframe :: (
    first_pass_info: *FIRST_PASS_INFO,
    stats: *FIRSTPASS_STATS_in_vp9_cx_iface,
    num_frames: s32
) {
    first_pass_info.stats = stats;
    first_pass_info.num_frames = num_frames;
}

fps_get_num_frames_in_vp9_encodeframe :: (first_pass_info: *FIRST_PASS_INFO) -> s32 {
    return first_pass_info.num_frames;
}

fps_get_frame_stats_in_vp9_encodeframe :: (
    first_pass_info: *FIRST_PASS_INFO,
    show_idx: s32
) -> *FIRSTPASS_STATS_in_vp9_cx_iface {
    if show_idx < 0 || show_idx >= first_pass_info.num_frames {
        return null;
    }
    return *(cast(*FIRSTPASS_STATS_in_vp9_cx_iface) (first_pass_info.stats))[show_idx];
}

get_buf_from_mv_in_vp9_encodeframe :: (buf: *Buf_2d, mv: *MV) -> *u8 {
    return *buf.buf[(cast(s32) mv.row) * buf.stride + cast(s32) mv.col];
}

cost_branch256_in_vp9_encodeframe :: (ct: *u32, p: Prob) -> u64 {
    return ((cast,no_check(u64) ct[0]) * cast(u64) VP9_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP9_PROB_COST[256 - cast(s32) p];
}

treed_cost_in_vp9_encodeframe :: (tree: *Tree_Index, probs: *Prob, bits: s32, len: s32) -> s32 {
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

rd_less_than_thresh_in_vp9_encodeframe :: (best_rd: s64, thresh: s32, THRESH_FACT: *s32) -> s32 {
    if best_rd < ((cast,no_check(s64) thresh) * cast(s64) THRESH_FACT.*) >> 5 || thresh == 2147483647 {
        return 1;
    }
    return 0;
}

set_error_per_bit_in_vp9_encodeframe :: (x: *MACROBLOCK, rdmult: s32) {
    x.errorperbit = rdmult >> 6;
    x.errorperbit += cast(s32) (x.errorperbit == 0);
}

vp9_get_sby_variance :: (cpi: *VP9_COMP_in_vp9_encoder, ref: *Buf_2d, bs: BLOCK_SIZE) -> u32 {
    sse: u32 = ---;
    VAR := cpi.fn_ptr[bs].vf(ref.buf, ref.stride, VP9_VAR_OFFS.data, 0, *sse);
    return VAR;
}

vp9_get_sby_perpixel_variance :: (cpi: *VP9_COMP_in_vp9_encoder, ref: *Buf_2d, bs: BLOCK_SIZE) -> u32 {
    return (vp9_get_sby_variance(cpi, ref, bs) + cast,no_check(u32) ((cast(s32) 1) << ((((cast(s32) NUM_PELS_LOG2_LOOKUP[bs]) - 1)) & 31))) >> ((NUM_PELS_LOG2_LOOKUP[bs]) & 31);
}

write_in_vp9_encodeframe :: (br: *Writer, bit: s32, probability: s32) {
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

write_bit_in_vp9_encodeframe :: (w: *Writer, bit: s32) {
    write_in_vp9_encodeframe(w, bit, 128);
}

write_literal_in_vp9_encodeframe :: (w: *Writer, data: s32, bits: s32) {
    bit := bits - 1;
    while bit >= 0 {
        write_bit_in_vp9_encodeframe(w, 1 & (data >> ((bit) & 31)));
        bit -= 1;
    }
}

vp9_write_tree_in_vp9_encodeframe :: (w: *Writer, tree: *Tree_Index, probs: *Prob, bits: s32, len: s32, i: Tree_Index) {
    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            write_in_vp9_encodeframe(w, BIT, cast,no_check(s32) probs[(cast(s32) i) >> 1]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }
}

vp9_write_token_in_vp9_encodeframe :: (w: *Writer, tree: *Tree_Index, probs: *Prob, token: *Vp9_Token) {
    vp9_write_tree_in_vp9_encodeframe(w, tree, probs, token.value, token.len, 0);
}

vp9_get_high_cost_table_in_vp9_encodeframe :: (bit_depth: s32) -> *u16 {
    return VP9_CAT6_HIGH_COST.data;
}

vp9_get_token_extra_in_vp9_encodeframe :: (v: s32, token: *s16, extra: *EXTRABIT) {
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

vp9_get_token_in_vp9_encodeframe :: (v: s32) -> s16 {
    if v >= 67 || v <= -67 {
        return 10;
    }
    return vp9_dct_cat_lt_10_value_tokens[v].token;
}

vp9_get_token_cost_in_vp9_encodeframe :: (v: s32, token: *s16, cat6_high_table: *u16) -> s32 {
    if v >= 67 || v <= -67 {
        token.* = 10;
        extrabits := cast,no_check(EXTRABIT) (absolute_value(v) - 67);
        return (cast(s32) VP9_CAT6_LOW_COST[extrabits & 0xff]) + cast(s32) cat6_high_table[(cast(s32) extrabits) >> 8];
    }
    token.* = vp9_dct_cat_lt_10_value_tokens[v].token;
    return vp9_dct_cat_lt_10_value_cost[v];
}

is_lossless_requested_in_vp9_encodeframe :: (cfg: *VP9_Encoder_Config) -> s32 {
    if cfg.best_allowed_q == 0 && cfg.worst_allowed_q == 0 {
        return 1;
    }
    return 0;
}

stack_pop_in_vp9_encodeframe :: (stack: *s32, stack_size: s32) -> s32 {
    R := stack[0];
    if 1 < stack_size {
        for idx: 1..stack_size - 1 {
            stack[idx - 1] = stack[idx];
        }
    }

    return R;
}

stack_top_in_vp9_encodeframe :: (stack: *s32) -> s32 {
    return stack[0];
}

stack_push_in_vp9_encodeframe :: (stack: *s32, new_item: s32, stack_size: s32) {
    idx := stack_size;
    while idx > 0 {
        stack[idx] = stack[idx - 1];
        idx -= 1;
    }
    stack[0] = new_item;
}

stack_init_in_vp9_encodeframe :: (stack: *s32, length: s32) {
    if 0 < length {
        for idx: 0..length - 1 {
            stack[idx] = -1;
        }
    }
}

frame_is_kf_gf_arf_in_vp9_encodeframe :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if frame_is_intra_only_in_vp9_encodeframe(*cpi.common) != 0 ||
        cpi.refresh_alt_ref_frame != 0 ||
        cpi.refresh_golden_frame != 0 && cpi.rc.is_src_frame_alt_ref == 0 {
        return 1;
    }
    return 0;
}

ref_frame_to_flag_in_vp9_encodeframe :: (ref_frame: s8) -> s32 {

    return K_VP9_REF_FLAG_LIST_in_vp9_encodeframe[ref_frame];
}

get_ref_frame_map_idx_in_vp9_encodeframe :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame: MV_REFERENCE_FRAME) -> s32 {
    if ref_frame == 1 {
        return cpi.lst_fb_idx;
    } else if ref_frame == 2 {
        return cpi.gld_fb_idx;
    } else {
        return cpi.alt_fb_idx;
    }
}

get_ref_frame_buf_idx_in_vp9_encodeframe :: (CPI: *VP9_COMP_in_vp9_encoder, ref_frame: s32) -> s32 {
    CM := *CPI.common;
    MAP_IDX := get_ref_frame_map_idx_in_vp9_encodeframe(CPI, cast,no_check(MV_REFERENCE_FRAME) ref_frame);
    return ifx MAP_IDX != -1 then CM.ref_frame_map[MAP_IDX] else -1;
}

get_ref_cnt_buffer_in_vp9_encodeframe :: (cm: *VP9_COMMON, fb_idx: s32) -> *Ref_Cnt_Buffer {
    return ifx fb_idx != -1 then cm.buffer_pool.frame_bufs.data + fb_idx else null;
}

get_ref_frame_bufs_in_vp9_encodeframe :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame_bufs: **Ref_Cnt_Buffer) {
    CM := *cpi.common;

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame < 4 {
        ref_frame_buf_idx := get_ref_frame_buf_idx_in_vp9_encodeframe(cpi, cast,no_check(s32) ref_frame);
        inter_ref_idx := mv_ref_frame_to_inter_ref_idx_in_vp9_encodeframe(ref_frame);
        ref_frame_bufs[inter_ref_idx] = get_ref_cnt_buffer_in_vp9_encodeframe(CM, ref_frame_buf_idx);
        ref_frame += 1;
    }
}

get_ref_frame_buffer_in_vp9_encodeframe :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    ref_frame: MV_REFERENCE_FRAME
) -> *YV12_BUFFER_CONFIG {
    CM := *CPI.common;
    BUF_IDX := get_ref_frame_buf_idx_in_vp9_encodeframe(CPI, cast,no_check(s32) ref_frame);
    return ifx BUF_IDX != -1 then *CM.buffer_pool.frame_bufs[BUF_IDX].buf else null;
}

get_token_alloc_in_vp9_encodeframe :: (mb_rows: s32, mb_cols: s32) -> s64 {
    ALIGNED_MB_ROWS :=
        (mb_rows +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    ALIGNED_MB_COLS :=
        (mb_cols +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    return ((cast,no_check(s64) ALIGNED_MB_ROWS) * cast(s64) ALIGNED_MB_COLS) * cast,no_check(s64) ((cast,no_check(s32) ((16 * 16))) * 3 + 4);
}

allocated_tokens_in_vp9_encodeframe :: (tile: Tile_Info) -> s64 {
    tile_mb_rows := (tile.mi_row_end - tile.mi_row_start + 1) >> 1;
    tile_mb_cols := (tile.mi_col_end - tile.mi_col_start + 1) >> 1;

    return get_token_alloc_in_vp9_encodeframe(tile_mb_rows, tile_mb_cols);
}

get_start_tok_in_vp9_encodeframe :: (
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

    tok.* = cpi.tile_tok[tile_row][tile_col] + get_token_alloc_in_vp9_encodeframe(MB_ROW, tile_mb_cols);
}

is_one_pass_svc_in_vp9_encodeframe :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if CPI.use_svc != 0 && CPI.oxcf.pass == 0 {
        return 1;
    }
    return 0;
}

is_altref_enabled_in_vp9_encodeframe :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if !(CPI.oxcf.mode == cast,no_check(u32) REALTIME && CPI.oxcf.rc_mode == cast,no_check(u32) CBR) &&
        CPI.oxcf.lag_in_frames >= 4 &&
        CPI.oxcf.enable_auto_arf != 0 {
        return 1;
    }
    return 0;
}

set_ref_ptrs_in_vp9_encodeframe :: (
    CM: *VP9_COMMON,
    xd: *MACROBLOCKD,
    ref0: MV_REFERENCE_FRAME,
    ref1: MV_REFERENCE_FRAME
) {
    xd.block_refs[0] = CM.frame_refs.data + (ifx ref0 >= 1 then (cast(s32) ref0) - 1 else 0);
    xd.block_refs[1] = CM.frame_refs.data + (ifx ref1 >= 1 then (cast(s32) ref1) - 1 else 0);
}

get_chessboard_index_in_vp9_encodeframe :: (FRAME_INDEX: s32) -> s32 {
    return FRAME_INDEX & 0x1;
}

cond_cost_list_in_vp9_encodeframe :: (cpi: *VP9_COMP_in_vp9_encoder, cost_list: *s32) -> *s32 {
    return ifx cpi.sf.mv.subpel_search_method != cast,no_check(u32) SUBPEL_TREE then cost_list else null;
}

get_num_vert_units_in_vp9_encodeframe :: (tile: Tile_Info, shift: s32) -> s32 {
    num_vert_units := (tile.mi_row_end - tile.mi_row_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_vert_units;
}

get_num_cols_in_vp9_encodeframe :: (tile: Tile_Info, shift: s32) -> s32 {
    num_cols := (tile.mi_col_end - tile.mi_col_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_cols;
}

get_level_index_in_vp9_encodeframe :: (level: VP9_LEVEL) -> s32 {
    for i: 0..cast(s32) 14 - 1 {
        if level == VP9_LEVEL_DEFS[i].level {
            return i;
        }
    }
    return -1;
}

log_tile_cols_from_picsize_level_in_vp9_encodeframe :: (width: u32, height: u32) -> s32 {
    PIC_SIZE := width * height;
    PIC_BREADTH := max(width, height);
    for i: 0..cast(s32) 14 - 1 {
        if VP9_LEVEL_DEFS[i].max_luma_picture_size >= PIC_SIZE && VP9_LEVEL_DEFS[i].max_luma_picture_breadth >= PIC_BREADTH {
            return get_msb_in_vp9_encodeframe(cast,no_check(u32) VP9_LEVEL_DEFS[i].max_col_tiles);
        }
    }
    return 2147483647;
}

alloc_frame_mvs_in_vp9_encodeframe :: (CM: *VP9_COMMON, buffer_idx: s32) {
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

mv_cost_in_vp9_encodeframe :: (mv: *MV, joint_cost: *s32, comp_cost: **s32) -> s32 {
    return joint_cost[vp9_get_mv_joint_in_vp9_encodeframe(mv)] + comp_cost[0][mv.row] + comp_cost[1][mv.col];
}

mvsad_err_cost_in_vp9_encodeframe :: (x: *MACROBLOCK, mv: *MV, ref: *MV, sad_per_bit: s32) -> s32 {
    diff: MV = ---;
    diff.row = cast,no_check(s16) ((cast(s32) mv.row) - cast(s32) ref.row);
    diff.col = cast,no_check(s16) ((cast(s32) mv.col) - cast(s32) ref.col);
    return cast,no_check(s32) ((((cast,no_check(u32) mv_cost_in_vp9_encodeframe(*diff, x.nmvjointsadcost.data, x.nmvsadcost.data)) * cast,no_check(u32) sad_per_bit) + cast,no_check(u32) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9);
}

get_start_mv_sad_in_vp9_encodeframe :: (
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
    start_mv_sad += cast,no_check(u32) mvsad_err_cost_in_vp9_encodeframe(x, mvp_full, ref_mv_full, sadpb);

    return start_mv_sad;
}

num_4x4_to_edge_in_vp9_encodeframe :: (
    plane_4x4_dim: s32,
    mb_to_edge_dim: s32,
    subsampling_dim: s32,
    blk_dim: s32
) -> s32 {
    return plane_4x4_dim + mb_to_edge_dim >> (((5 + subsampling_dim)) & 31) - blk_dim;
}

sum_squares_visible_in_vp9_encodeframe :: (
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
        num_4x4_to_edge_in_vp9_encodeframe(
            PLANE_4X4_W,
            xd.mb_to_right_edge,
            PD.subsampling_x,
            blk_col
        );
    B4X4S_TO_BOTTOM_EDGE :=
        num_4x4_to_edge_in_vp9_encodeframe(
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

do_trellis_opt_in_vp9_encodeframe :: (
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
                    sum_squares_visible_in_vp9_encodeframe(
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

vp9_setup_src_planes :: (x: *MACROBLOCK, src: *YV12_BUFFER_CONFIG, mi_row: s32, mi_col: s32) {
    BUFFERS := *u8.[ src.y_buffer, src.u_buffer, src.v_buffer ];
    STRIDES := s32.[ src.y_stride, src.uv_stride, src.uv_stride ];

    x.e_mbd.cur_buf = src;

    for i: 0..cast(s32) 3 - 1 {
        setup_pred_plane_in_vp9_encodeframe(
            *x.plane[i].src,
            BUFFERS[i],
            STRIDES[i],
            mi_row,
            mi_col,
            null,
            x.e_mbd.plane[i].subsampling_x,
            x.e_mbd.plane[i].subsampling_y
        );
    }
}

vp9_encode_frame :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;

    restore_encode_params(cpi);

    if frame_is_intra_only_in_vp9_encodeframe(CM) == 0 {
        if vp9_compound_reference_allowed(CM) != 0 {
            cpi.allow_comp_inter_inter = 1;
            vp9_setup_compound_reference_mode(CM);
        } else {
            cpi.allow_comp_inter_inter = 0;
        }
    }

    if cpi.sf.frame_parameter_update != 0 {
        RD_OPT_ := *cpi.rd;
        counts := cpi.td.counts;
        RDC := *cpi.td.rd_counts;

        FRAME_TYPE_ := get_frame_type(cpi);
        MODE_THRS := RD_OPT_.prediction_type_threshes[FRAME_TYPE_].data;
        FILTER_THRS := RD_OPT_.filter_threshes[FRAME_TYPE_].data;
        IS_ALT_REF := cast(s32) (FRAME_TYPE_ == 3);

        if IS_ALT_REF != 0 || cpi.allow_comp_inter_inter == 0 {
            CM.reference_mode = cast,no_check(REFERENCE_MODE) SINGLE_REFERENCE;
        } else if MODE_THRS[COMPOUND_REFERENCE] > MODE_THRS[SINGLE_REFERENCE] &&
            MODE_THRS[COMPOUND_REFERENCE] > MODE_THRS[REFERENCE_MODE_SELECT] &&
            check_dual_ref_flags(cpi) != 0 &&
            cpi.static_mb_pct == 100 {
            CM.reference_mode = cast,no_check(REFERENCE_MODE) COMPOUND_REFERENCE;
        } else if MODE_THRS[SINGLE_REFERENCE] > MODE_THRS[REFERENCE_MODE_SELECT] {
            CM.reference_mode = cast,no_check(REFERENCE_MODE) SINGLE_REFERENCE;
        } else {
            CM.reference_mode = cast,no_check(REFERENCE_MODE) REFERENCE_MODE_SELECT;
        }

        if CM.interp_filter == 4 {
            CM.interp_filter = get_interp_filter(FILTER_THRS, IS_ALT_REF);
        }

        encode_frame_internal(cpi);

        i: s32 = 0;
        while i < REFERENCE_MODES {
            MODE_THRS[i] = (MODE_THRS[i] + RDC.comp_pred_diff[i] / cast(s64) CM.m_bs) / 2;
            i += 1;
        }

        i = 0;
        while i < 3 + 1 {
            FILTER_THRS[i] = (FILTER_THRS[i] + RDC.filter_diff[i] / cast(s64) CM.m_bs) / 2;
            i += 1;
        }

        if CM.reference_mode == cast,no_check(u32) REFERENCE_MODE_SELECT {
            single_count_zero: s32 = 0;
            comp_count_zero: s32 = 0;

            i = 0;
            while i < 5 {
                single_count_zero = cast,no_check(s32) ((cast,no_check(u32) single_count_zero) + counts.comp_inter[i][0]);
                comp_count_zero = cast,no_check(s32) ((cast,no_check(u32) comp_count_zero) + counts.comp_inter[i][1]);
                i += 1;
            }

            if comp_count_zero == 0 {
                CM.reference_mode = cast,no_check(REFERENCE_MODE) SINGLE_REFERENCE;
                fill_memory(*counts.comp_inter, 0, counts.comp_inter.count * size_of([2] u32));
            } else if single_count_zero == 0 {
                CM.reference_mode = cast,no_check(REFERENCE_MODE) COMPOUND_REFERENCE;
                fill_memory(*counts.comp_inter, 0, counts.comp_inter.count * size_of([2] u32));
            }
        }

        if CM.tx_mode == cast,no_check(u32) TX_MODE_SELECT {
            count4x4: s32 = 0;
            count8x8_lp: s32 = 0;
            count8x8_8x8p: s32 = 0;
            count16x16_16x16p: s32 = 0;
            count16x16_lp: s32 = 0;
            count32x32: s32 = 0;

            i = 0;
            while i < 2 {
                count4x4 = cast,no_check(s32) ((cast,no_check(u32) count4x4) + counts.tx.p32x32[i][0]);
                count4x4 = cast,no_check(s32) ((cast,no_check(u32) count4x4) + counts.tx.p16x16[i][0]);
                count4x4 = cast,no_check(s32) ((cast,no_check(u32) count4x4) + counts.tx.p8x8[i][0]);

                count8x8_lp = cast,no_check(s32) ((cast,no_check(u32) count8x8_lp) + counts.tx.p32x32[i][1]);
                count8x8_lp = cast,no_check(s32) ((cast,no_check(u32) count8x8_lp) + counts.tx.p16x16[i][1]);
                count8x8_8x8p = cast,no_check(s32) ((cast,no_check(u32) count8x8_8x8p) + counts.tx.p8x8[i][1]);

                count16x16_16x16p = cast,no_check(s32) ((cast,no_check(u32) count16x16_16x16p) + counts.tx.p16x16[i][2]);
                count16x16_lp = cast,no_check(s32) ((cast,no_check(u32) count16x16_lp) + counts.tx.p32x32[i][2]);
                count32x32 = cast,no_check(s32) ((cast,no_check(u32) count32x32) + counts.tx.p32x32[i][3]);
                i += 1;
            }
            if count4x4 == 0 && count16x16_lp == 0 && count16x16_16x16p == 0 && count32x32 == 0 {
                CM.tx_mode = cast,no_check(TX_MODE) ALLOW_8X8;
                reset_skip_tx_size(CM, 1);
            } else if count8x8_8x8p == 0 && count16x16_16x16p == 0 && count8x8_lp == 0 && count16x16_lp == 0 && count32x32 == 0 {
                CM.tx_mode = cast,no_check(TX_MODE) ONLY_4X4;
                reset_skip_tx_size(CM, 0);
            } else if count8x8_lp == 0 && count16x16_lp == 0 && count4x4 == 0 {
                CM.tx_mode = cast,no_check(TX_MODE) ALLOW_32X32;
            } else if count32x32 == 0 && count8x8_lp == 0 && count4x4 == 0 {
                CM.tx_mode = cast,no_check(TX_MODE) ALLOW_16X16;
                reset_skip_tx_size(CM, 2);
            }
        }
    } else {
        counts := cpi.td.counts;
        CM.reference_mode = cast,no_check(REFERENCE_MODE) SINGLE_REFERENCE;
        if cpi.allow_comp_inter_inter != 0 &&
            cpi.sf.use_compound_nonrd_pickmode != 0 &&
            cpi.rc.alt_ref_gf_group != 0 &&
            cpi.rc.is_src_frame_alt_ref == 0 &&
            CM.frame_type != cast,no_check(u32) KEY_FRAME {
            CM.reference_mode = cast,no_check(REFERENCE_MODE) REFERENCE_MODE_SELECT;
        }

        encode_frame_internal(cpi);

        if CM.reference_mode == cast,no_check(u32) REFERENCE_MODE_SELECT {
            single_count_zero: s32 = 0;
            comp_count_zero: s32 = 0;

            for i: 0..cast(s32) 5 - 1 {
                single_count_zero = cast,no_check(s32) ((cast,no_check(u32) single_count_zero) + counts.comp_inter[i][0]);
                comp_count_zero = cast,no_check(s32) ((cast,no_check(u32) comp_count_zero) + counts.comp_inter[i][1]);
            }
            if comp_count_zero == 0 {
                CM.reference_mode = cast,no_check(REFERENCE_MODE) SINGLE_REFERENCE;
                fill_memory(*counts.comp_inter, 0, counts.comp_inter.count * size_of([2] u32));
            } else if single_count_zero == 0 {
                CM.reference_mode = cast,no_check(REFERENCE_MODE) COMPOUND_REFERENCE;
                fill_memory(*counts.comp_inter, 0, counts.comp_inter.count * size_of([2] u32));
            }
        }
    }

    if CM.seg.enabled != 0 &&
        cpi.oxcf.aq_mode != cast,no_check(u32) NO_AQ &&
        (CM.seg.update_map != 0 || CM.seg.update_data != 0) {
        CM.seg.aq_av_offset = compute_frame_aq_offset(cpi);
    }
}

compute_frame_aq_offset :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    CM := *cpi.common;
    mi_8x8_ptr := CM.mi_grid_visible;
    SEG := *CM.seg;
    mi_col: s32 = ---;
    sum_delta: s32 = 0;
    qdelta_index: s32 = ---;
    segment_id: s32 = ---;

    mi_row: s32 = 0;
    while mi_row < CM.mi_rows {
        mi_8x8 := mi_8x8_ptr;
        mi_col = 0;
        while mi_col < CM.mi_cols {
            segment_id = cast,no_check(s32) mi_8x8[0].segment_id;
            qdelta_index =
                get_segdata_in_vp9_encodeframe(
                    SEG,
                    segment_id,
                    cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_Q
                );
            sum_delta += qdelta_index;
            mi_col += 1;
            mi_8x8 += 1;
        }
        mi_8x8_ptr += CM.mi_stride;
        mi_row += 1;
    }

    return sum_delta / (CM.mi_rows * CM.mi_cols);
}

encode_frame_internal :: (cpi: *VP9_COMP_in_vp9_encoder) {
    SF := *cpi.sf;
    TD := *cpi.td;
    X := *TD.mb;
    CM := *cpi.common;
    XD := *X.e_mbd;
    GF_GROUP_INDEX := cast,no_check(s32) cpi.twopass.gf_group.index;

    XD.mi = CM.mi_grid_visible;
    XD.mi[0] = CM.mi;
    fill_memory(TD.counts, 0, size_of(FRAME_COUNTS));
    fill_memory(*cpi.td.rd_counts, 0, size_of(RD_COUNTS));

    XD.lossless =
        cast(s32) (CM.base_qindex == 0 && CM.y_dc_delta_q == 0 &&
            CM.uv_dc_delta_q == 0 && CM.uv_ac_delta_q == 0);

    X.fwd_txfm4x4 =
        cast,no_check(#type (_: *s16, _: *Tran_Low_T, _: s32)) (ifx XD.lossless != 0 then vp9_fwht4x4_c else fdct4x4_c);

    X.inv_txfm_add =
        cast,no_check(#type (_: *Tran_Low_T, _: *u8, _: s32, _: s32)) (ifx XD.lossless != 0 then vp9_iwht4x4_add else vp9_idct4x4_add);
    X.optimize = cast(s32) (SF.optimize_coefficients == 1 && cpi.oxcf.pass != 1);
    if XD.lossless != 0 {
        X.optimize = 0;
    }
    X.sharpness = cpi.oxcf.sharpness;
    X.adjust_rdmult_by_segment = cast(s32) (cpi.oxcf.aq_mode == cast,no_check(u32) VARIANCE_AQ);

    CM.tx_mode = select_tx_mode(cpi, XD);

    vp9_frame_init_quantizer(cpi);

    vp9_initialize_rd_consts(cpi);
    vp9_initialize_me_consts(cpi, X, CM.base_qindex);
    init_encode_frame_mb_context_in_vp9_encodeframe(cpi);
    CM.use_prev_frame_mvs =
        cast(s32) (CM.error_resilient_mode == 0 && CM.width == CM.last_width &&
            CM.height == CM.last_height && CM.intra_only == 0 && CM.last_show_frame != 0);

    CM.prev_mi = ifx CM.use_prev_frame_mvs != 0 then CM.prev_mip + CM.mi_stride + 1 else null;

    X.quant_fp = cpi.sf.use_quant_fp;
    fill_memory(*X.skip_txfm, 0, X.skip_txfm.count);
    if SF.use_nonrd_pick_mode != 0 {
        P := X.plane.data;
        PD := XD.plane.data;
        ctx := *cpi.td.pc_root.none;

        for i: 0..cast(s32) 3 - 1 {
            P[i].coeff = ctx.coeff_pbuf[i][0];
            P[i].qcoeff = ctx.qcoeff_pbuf[i][0];
            PD[i].dqcoeff = ctx.dqcoeff_pbuf[i][0];
            P[i].eobs = ctx.eobs_pbuf[i][0];
        }
        fill_memory(*X.zcoeff_blk, 0, X.zcoeff_blk.count * size_of([256] u8));

        if CM.frame_type != cast,no_check(u32) KEY_FRAME &&
            cpi.rc.frames_since_golden == 0 &&
            !(cpi.oxcf.lag_in_frames > 0 && cpi.oxcf.rc_mode == cast,no_check(u32) VBR) &&
            cpi.use_svc == 0 {
            cpi.ref_frame_flags &= cast,no_check(s32) (~(VP9_GOLD_FLAG));
        }
    } else if GF_GROUP_INDEX != 0 && GF_GROUP_INDEX < 2 * 25 && cpi.sf.enable_tpl_model != 0 {
        tpl_frame := cpi.tpl_stats.data + cpi.twopass.gf_group.index;
        tpl_stats := tpl_frame.tpl_stats_ptr;

        tpl_stride := tpl_frame.stride;
        intra_cost_base: s64 = 0;
        mc_dep_cost_base: s64 = 0;
        col: s32 = ---;

        row: s32 = 0;
        while row < CM.mi_rows && tpl_frame.is_valid != 0 {
            col = 0;
            while col < CM.mi_cols {
                this_stats := *tpl_stats[row * tpl_stride + col];
                intra_cost_base += this_stats.intra_cost;
                mc_dep_cost_base += this_stats.mc_dep_cost;
                col += 1;
            }
            row += 1;
        }

        if tpl_frame.is_valid != 0 {
            cpi.rd.r0 = (cast,no_check(float64) intra_cost_base) / mc_dep_cost_base;
        }
    }

    {
        ref_frame: MV_REFERENCE_FRAME = 1;
        while ref_frame <= 3 {
            if cpi.ref_frame_flags & ref_frame_to_flag_in_vp9_encodeframe(ref_frame) != 0 {
                if CM.frame_refs[(cast(s32) ref_frame) - 1].sf.x_scale_fp == -1 ||
                    CM.frame_refs[(cast(s32) ref_frame) - 1].sf.y_scale_fp == -1 {
                    cpi.ref_frame_flags &= ~(ref_frame_to_flag_in_vp9_encodeframe(ref_frame));
                }
            }
            ref_frame += 1;
        }
    }

    if cpi.oxcf.aq_mode == cast,no_check(u32) PERCEPTUAL_AQ {
        build_kmeans_segmentation(cpi);
    }

    if cpi.row_mt == 0 {
        cpi.row_mt_sync_read_ptr = vp9_row_mt_sync_read_dummy;
        cpi.row_mt_sync_write_ptr = vp9_row_mt_sync_write_dummy;

        if (ifx cpi.oxcf.max_threads < (cast(s32) 1) << ((CM.log2_tile_cols) & 31) then cpi.oxcf.max_threads else (cast(s32) 1) << ((CM.log2_tile_cols) & 31)) > 1 {
            vp9_encode_tiles_mt(cpi);
        } else {
            encode_tiles_in_vp9_encodeframe(cpi);
        }
    } else {
        cpi.row_mt_sync_read_ptr = vp9_row_mt_sync_read;
        cpi.row_mt_sync_write_ptr = vp9_row_mt_sync_write;
        vp9_encode_tiles_row_mt(cpi);
    }

    SF.skip_encode_frame = ifx SF.skip_encode_sb != 0 then get_skip_encode_frame(CM, TD) else 0;
}

get_skip_encode_frame :: (cm: *VP9_COMMON, TD: *Thread_Data_in_vp9_encoder) -> s32 {
    intra_count: u32 = 0;
    inter_count: u32 = 0;

    for j: 0..cast(s32) 4 - 1 {
        intra_count += TD.counts.intra_inter[j][0];
        inter_count += TD.counts.intra_inter[j][1];
    }

    if intra_count << 2 < inter_count && cm.frame_type != cast,no_check(u32) KEY_FRAME && cm.show_frame != 0 {
        return 1;
    }
    return 0;
}

encode_tiles_in_vp9_encodeframe :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    TILE_ROWS := (cast(s32) 1) << ((CM.log2_tile_rows) & 31);
    tile_col: s32 = ---;

    vp9_init_tile_data(cpi);

    if 0 < TILE_ROWS {
        for tile_row: 0..TILE_ROWS - 1 {
            tile_col = 0;
            while tile_col < TILE_COLS {
                vp9_encode_tile(cpi, *cpi.td, tile_row, tile_col);
                tile_col += 1;
            }
        }
    }
}

vp9_encode_tile :: (cpi: *VP9_COMP_in_vp9_encoder, td: *Thread_Data_in_vp9_encoder, tile_row: s32, tile_col: s32) {
    CM := *cpi.common;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    this_tile := *cpi.tile_data[tile_row * TILE_COLS + tile_col];
    TILE_INFO := *this_tile.tile_info;
    MI_ROW_START := TILE_INFO.mi_row_start;
    MI_ROW_END := TILE_INFO.mi_row_end;

    mi_row := MI_ROW_START;
    while mi_row < MI_ROW_END {
        vp9_encode_sb_row(cpi, td, tile_row, tile_col, mi_row);
        mi_row += (cast(s32) 1) << (((6 - 3)) & 31);
    }
}

vp9_encode_sb_row :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    td: *Thread_Data_in_vp9_encoder,
    tile_row: s32,
    tile_col: s32,
    mi_row: s32
) {
    CM := *cpi.common;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    this_tile := *cpi.tile_data[tile_row * TILE_COLS + tile_col];
    TILE_INFO := *this_tile.tile_info;
    tok: *TOKENEXTRA_in_vp9_cx_iface = null;

    tile_mb_cols := (TILE_INFO.mi_col_end - TILE_INFO.mi_col_start + 1) >> 1;

    tile_sb_row := mi_cols_aligned_to_sb_in_vp9_encodeframe(mi_row - TILE_INFO.mi_row_start) >> (((6 - 3)) & 31);
    get_start_tok_in_vp9_encodeframe(cpi, tile_row, tile_col, mi_row, *tok);
    cpi.tplist[tile_row][tile_col][tile_sb_row].start = tok;

    if cpi.sf.use_nonrd_pick_mode != 0 {
        encode_nonrd_sb_row(cpi, td, this_tile, mi_row, *tok);
    } else {
        encode_rd_sb_row(cpi, td, this_tile, mi_row, *tok);
    }

    cpi.tplist[tile_row][tile_col][tile_sb_row].stop = tok;
    cpi.tplist[tile_row][tile_col][tile_sb_row].count =
        cast,no_check(u32) (cpi.tplist[tile_row][tile_col][tile_sb_row].stop -
            cpi.tplist[tile_row][tile_col][tile_sb_row].start);
}

encode_rd_sb_row :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    td: *Thread_Data_in_vp9_encoder,
    tile_data: *Tile_Data_Enc,
    mi_row: s32,
    tp: **TOKENEXTRA_in_vp9_cx_iface
) {
    CM := *cpi.common;
    TILE_INFO := *tile_data.tile_info;
    X := *td.mb;
    XD := *X.e_mbd;
    SF := *cpi.sf;
    MI_COL_START := TILE_INFO.mi_col_start;
    MI_COL_END := TILE_INFO.mi_col_end;
    mi_col: s32 = ---;
    SB_ROW := mi_row >> (((6 - 3)) & 31);
    NUM_SB_COLS := get_num_cols_in_vp9_encodeframe(tile_data.tile_info, cast,no_check(s32) (6 - 3));
    sb_col_in_tile: s32 = ---;

    fill_memory(*XD.left_context, 0, XD.left_context.count * size_of([16] ENTROPY_CONTEXT));
    fill_memory(XD.left_seg_context.data, 0, XD.left_seg_context.count);

    mi_col = MI_COL_START;
    sb_col_in_tile = 0;
    while mi_col < MI_COL_END {
        SEG := *CM.seg;
        dummy_rate: s32 = ---;
        dummy_dist: s64 = ---;
        dummy_rdc: RD_COST = ---;

        seg_skip: s32 = 0;
        orig_rdmult := cpi.rd.rdmult;

        IDX_STR := CM.mi_stride * mi_row + mi_col;
        mi := CM.mi_grid_visible + IDX_STR;

        vp9_rd_cost_reset(*dummy_rdc);
        cpi.row_mt_sync_read_ptr(*tile_data.row_mt_sync, SB_ROW, sb_col_in_tile);

        if SF.adaptive_pred_interp_filter != 0 {
            for i: 0..cast(s32) 64 - 1 {
                (cast(*PICK_MODE_CONTEXT) (td.leaf_tree))[i].pred_interp_filter = 4;
            }

            for i: 0..cast(s32) 64 - 1 {
                (cast(*PC_TREE) (td.pc_tree))[i].vertical[0].pred_interp_filter = 4;
                (cast(*PC_TREE) (td.pc_tree))[i].vertical[1].pred_interp_filter = 4;
                (cast(*PC_TREE) (td.pc_tree))[i].horizontal[0].pred_interp_filter = 4;
                (cast(*PC_TREE) (td.pc_tree))[i].horizontal[1].pred_interp_filter = 4;
            }
        }

        for i: 0..cast(s32) 4 - 1 {
            X.pred_mv[i].row = 32767;
            X.pred_mv[i].col = 32767;
        }
        td.pc_root.index = 0;

        if SEG.enabled != 0 {
            MAP := (ifx SEG.update_map != 0 then cpi.segmentation_map else CM.last_frame_seg_map);
            segment_id := get_segment_id_in_vp9_encodeframe(CM, MAP, 12, mi_row, mi_col);
            seg_skip =
                segfeature_active_in_vp9_encodeframe(
                    SEG,
                    segment_id,
                    cast,no_check(SEG_LVL_FEATURES) SEG_LVL_SKIP
                );
        }

        X.source_variance = U32_MAX;

        X.cb_rdmult = orig_rdmult;

        if SF.partition_search_type == cast,no_check(u32) FIXED_PARTITION || seg_skip != 0 {
            BSIZE :=
                cast,no_check(BLOCK_SIZE) ((ifx seg_skip != 0 then 12 else cast,no_check(s32) SF.always_this_block_size));
            set_offsets(cpi, TILE_INFO, X, mi_row, mi_col, 12);
            set_fixed_partitioning(cpi, TILE_INFO, mi, mi_row, mi_col, BSIZE);
            rd_use_partition(cpi, td, tile_data, mi, tp, mi_row, mi_col, 12, *dummy_rate, *dummy_dist, 1, td.pc_root);
        } else if SF.partition_search_type == cast,no_check(u32) VAR_BASED_PARTITION && CM.frame_type != cast,no_check(u32) KEY_FRAME {
            choose_partitioning(cpi, TILE_INFO, X, mi_row, mi_col);
            rd_use_partition(cpi, td, tile_data, mi, tp, mi_row, mi_col, 12, *dummy_rate, *dummy_dist, 1, td.pc_root);
        } else {
            if cpi.twopass.gf_group.index > 0 && cpi.sf.enable_tpl_model != 0 {
                dr := get_rdmult_delta(cpi, 12, mi_row, mi_col, orig_rdmult);
                X.cb_rdmult = dr;
            }

            if cpi.oxcf.aq_mode == cast,no_check(u32) PERCEPTUAL_AQ && CM.show_frame != 0 {
                X.segment_id = wiener_var_segment(cpi, 12, mi_row, mi_col);
                X.cb_rdmult = vp9_compute_rd_mult(cpi, vp9_get_qindex(*CM.seg, X.segment_id, CM.base_qindex));
            }

            if SF.auto_min_max_partition_size != 0 {
                set_offsets(cpi, TILE_INFO, X, mi_row, mi_col, 12);
                rd_auto_partition_range(
                    cpi,
                    TILE_INFO,
                    XD,
                    mi_row,
                    mi_col,
                    *X.min_partition_size,
                    *X.max_partition_size
                );
            }
            td.pc_root.none.rdcost = 0;

            rd_pick_partition(cpi, td, tile_data, tp, mi_row, mi_col, 12, *dummy_rdc, dummy_rdc, td.pc_root);
        }
        cpi.row_mt_sync_write_ptr(*tile_data.row_mt_sync, SB_ROW, sb_col_in_tile, NUM_SB_COLS);
        mi_col += (cast(s32) 1) << (((6 - 3)) & 31);
        sb_col_in_tile += 1;
    }
}

rd_pick_partition :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    td: *Thread_Data_in_vp9_encoder,
    tile_data: *Tile_Data_Enc,
    tp: **TOKENEXTRA_in_vp9_cx_iface,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE,
    rd_cost: *RD_COST,
    best_rdc: RD_COST,
    pc_tree: *PC_TREE
) -> s32 {
    local_best_rdc: RD_COST = best_rdc;
    CM := *cpi.common;
    OXCF := *cpi.oxcf;
    TILE_INFO := *tile_data.tile_info;
    X := *td.mb;
    XD := *X.e_mbd;
    MI_STEP := (cast(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize]) / 2;
    l, a: [48] ENTROPY_CONTEXT = ---;
    sl, sa: [8] PARTITION_CONTEXT = ---;
    tp_orig := tp.*;
    CTX := *pc_tree.none;
    i: s32 = ---;
    PL := partition_plane_context_in_vp9_encodeframe(XD, mi_row, mi_col, bsize);
    subsize: BLOCK_SIZE = ---;
    this_rdc, sum_rdc: RD_COST = ---;
    do_split := cast(s32) (bsize >= 3);
    do_rect: s32 = 1;

    FORCE_HORZ_SPLIT := cast(s32) (mi_row + MI_STEP >= CM.mi_rows);
    FORCE_VERT_SPLIT := cast(s32) (mi_col + MI_STEP >= CM.mi_cols);
    XSS := X.e_mbd.plane[1].subsampling_x;
    YSS := X.e_mbd.plane[1].subsampling_y;

    min_size := X.min_partition_size;
    max_size := X.max_partition_size;

    partition_none_allowed := cast(s32) (FORCE_HORZ_SPLIT == 0 && FORCE_VERT_SPLIT == 0);
    partition_horz_allowed := cast(s32) (FORCE_VERT_SPLIT == 0 && YSS <= XSS && bsize >= 3);
    partition_vert_allowed := cast(s32) (FORCE_HORZ_SPLIT == 0 && XSS <= YSS && bsize >= 3);

    dist_breakout_thr := cpi.sf.partition_search_breakout_thr.dist;
    rate_breakout_thr := cpi.sf.partition_search_breakout_thr.rate;
    must_split: s32 = 0;
    should_encode_sb: s32 = 0;

    ref_frames_used: [4] u8;

    partition_mul := X.cb_rdmult;

    c_transpiler_compound_shr(*(dist_breakout_thr), (((cast,no_check(s64) (8 - ((cast(s32) B_WIDTH_LOG2_LOOKUP[bsize]) + cast(s32) B_HEIGHT_LOG2_LOOKUP[bsize]))) & 63)), s64, s64);

    rate_breakout_thr *= cast,no_check(s32) NUM_PELS_LOG2_LOOKUP[bsize];

    vp9_rd_cost_init(*this_rdc);
    vp9_rd_cost_init(*sum_rdc);

    set_offsets(cpi, TILE_INFO, X, mi_row, mi_col, bsize);

    if OXCF.tuning == cast,no_check(u32) VP8_TUNE_SSIM {
        set_ssim_rdmult(cpi, X, bsize, mi_row, mi_col, *partition_mul);
    }
    vp9_rd_cost_update(partition_mul, X.rddiv, *local_best_rdc);

    if bsize == 6 && cpi.oxcf.aq_mode != cast,no_check(u32) NO_AQ && cpi.oxcf.aq_mode != cast,no_check(u32) LOOKAHEAD_AQ {
        X.mb_energy = vp9_block_energy(cpi, X, bsize);
    }

    if cpi.sf.cb_partition_search != 0 && bsize == 6 {
        cb_partition_search_ctrl :=
            ((cast(s32) (pc_tree.index == 0 || pc_tree.index == 3)) + get_chessboard_index_in_vp9_encodeframe(
                cast,no_check(s32) CM.current_video_frame
            )) & 0x1;

        if cb_partition_search_ctrl != 0 && bsize > min_size && bsize < max_size {
            set_partition_range(CM, XD, mi_row, mi_col, bsize, *min_size, *max_size);
        }
    }

    if bsize >= 6 {
        min_energy, max_energy: s32 = ---;
        vp9_get_sub_block_energy(cpi, X, mi_row, mi_col, bsize, *min_energy, *max_energy);
        must_split = cast(s32) (min_energy < -3 && max_energy - min_energy > 2);
    }

    if cpi.sf.auto_min_max_partition_size != 0 {
        partition_none_allowed &= cast(s32) (bsize <= max_size);
        partition_horz_allowed &= cast(s32) (bsize <= max_size && bsize > min_size || FORCE_HORZ_SPLIT != 0);
        partition_vert_allowed &= cast(s32) (bsize <= max_size && bsize > min_size || FORCE_VERT_SPLIT != 0);
        do_split &= cast(s32) (bsize > min_size);
    }

    if cpi.sf.use_square_partition_only != 0 &&
        (bsize > cpi.sf.use_square_only_thresh_high || bsize < cpi.sf.use_square_only_thresh_low) {
        if cpi.use_svc != 0 {
            if vp9_active_h_edge(cpi, mi_row, MI_STEP) == 0 || X.e_mbd.lossless != 0 {
                partition_horz_allowed &= FORCE_HORZ_SPLIT;
            }
            if vp9_active_v_edge(cpi, mi_row, MI_STEP) == 0 || X.e_mbd.lossless != 0 {
                partition_vert_allowed &= FORCE_VERT_SPLIT;
            }
        } else {
            partition_horz_allowed &= FORCE_HORZ_SPLIT;
            partition_vert_allowed &= FORCE_VERT_SPLIT;
        }
    }

    save_context(X, mi_row, mi_col, a.data, l.data, sa.data, sl.data, bsize);

    pc_tree.partitioning = cast,no_check(PARTITION_TYPE) PARTITION_NONE;

    if cpi.sf.rd_ml_partition.var_pruning != 0 && frame_is_intra_only_in_vp9_encodeframe(CM) == 0 {
        DO_RD_ML_PARTITION_VAR_PRUNING :=
            cast(s32) (partition_none_allowed != 0 && do_split != 0 && (mi_row + cast(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize]) <= CM.mi_rows &&
                (mi_col + cast(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize]) <= CM.mi_cols);
        if DO_RD_ML_PARTITION_VAR_PRUNING != 0 {
            ml_predict_var_rd_partitioning(cpi, X, pc_tree, bsize, mi_row, mi_col, *partition_none_allowed, *do_split);

            if bsize == 3 && cpi.sf.disable_split_mask != 0 && partition_none_allowed == 0 {
                partition_none_allowed = 1;
            }
        } else {
            fill_memory(*pc_tree.mv, 0, size_of(MV));
        }
        if bsize > 3 {
            i = 0;
            while i < 4 {
                pc_tree.u.split[i].mv = pc_tree.mv;
                i += 1;
            }
        }
    }

    if partition_none_allowed != 0 {
        rd_pick_sb_modes(
            cpi,
            tile_data,
            X,
            mi_row,
            mi_col,
            *this_rdc,
            bsize,
            CTX,
            local_best_rdc.rate,
            local_best_rdc.dist
        );
        CTX.rdcost = this_rdc.rdcost;
        if this_rdc.rate != 2147483647 {
            if cpi.sf.prune_ref_frame_for_rect_partitions != 0 {
                REF1 := cast,no_check(s32) CTX.mic.ref_frame[0];
                REF2 := cast,no_check(s32) CTX.mic.ref_frame[1];
                i = 0;
                while i < 4 {
                    ref_frames_used[i] = cast,no_check(u8) ((cast,no_check(s32) ref_frames_used[i]) | ((cast(s32) 1) << ((REF1) & 31)));
                    if REF2 > 0 {
                        ref_frames_used[i] = cast,no_check(u8) ((cast,no_check(s32) ref_frames_used[i]) | ((cast(s32) 1) << ((REF2) & 31)));
                    }
                    i += 1;
                }
            }
            if bsize >= 3 {
                this_rdc.rate += cpi.partition_cost[PL][PARTITION_NONE];
                vp9_rd_cost_update(partition_mul, X.rddiv, *this_rdc);
            }

            if this_rdc.rdcost < local_best_rdc.rdcost {
                mi := XD.mi[0];

                assignment_2: RD_COST = this_rdc;
                ((*local_best_rdc).*) = assignment_2;
                should_encode_sb = 1;
                if bsize >= 3 {
                    pc_tree.partitioning = cast,no_check(PARTITION_TYPE) PARTITION_NONE;
                }

                if cpi.sf.rd_ml_partition.search_early_termination != 0 {
                    if X.e_mbd.lossless == 0 &&
                        segfeature_active_in_vp9_encodeframe(
                            *CM.seg,
                            cast,no_check(s32) mi.segment_id,
                            cast,no_check(SEG_LVL_FEATURES) SEG_LVL_SKIP
                        ) == 0 &&
                        cast,no_check(s32) CTX.mic.mode >= 9 + 1 &&
                        bsize >= 6 {
                        if ml_pruning_partition(CM, XD, CTX, mi_row, mi_col, bsize) != 0 {
                            do_split = 0;
                            do_rect = 0;
                        }
                    }
                }

                if (do_split != 0 || do_rect != 0) && X.e_mbd.lossless == 0 && CTX.skippable != 0 {
                    USE_ML_BASED_BREAKOUT :=
                        cast(s32) (cpi.sf.rd_ml_partition.search_breakout != 0 &&
                            CM.base_qindex >= 100);
                    if USE_ML_BASED_BREAKOUT != 0 {
                        if ml_predict_breakout(cpi, bsize, X, *this_rdc) != 0 {
                            do_split = 0;
                            do_rect = 0;
                        }
                    } else if cpi.sf.rd_ml_partition.search_early_termination == 0 {
                        if local_best_rdc.dist < dist_breakout_thr >> 2 ||
                            local_best_rdc.dist < dist_breakout_thr && local_best_rdc.rate < rate_breakout_thr {
                            do_split = 0;
                            do_rect = 0;
                        }
                    }
                }
            }
        }
        restore_context(X, mi_row, mi_col, a.data, l.data, sa.data, sl.data, bsize);
    } else {
        fill_memory(*CTX.pred_mv, 0, CTX.pred_mv.count * size_of(MV));
        CTX.mic.interp_filter = 0;
    }

    store_pred_mv(X, CTX);

    pred_interp_filter: INTERP_FILTER = ifx CTX.mic.interp_filter == 3
        then cast(INTERP_FILTER) 0
        else CTX.mic.interp_filter;

    pc_tree.u.split[0].none.rdcost = 0;
    pc_tree.u.split[1].none.rdcost = 0;
    pc_tree.u.split[2].none.rdcost = 0;
    pc_tree.u.split[3].none.rdcost = 0;
    if do_split != 0 || must_split != 0 {
        subsize = get_subsize_in_vp9_encodeframe(bsize, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT);
        load_pred_mv(X, CTX);
        if bsize == 3 {
            i = 4;
            if cpi.sf.adaptive_pred_interp_filter != 0 && partition_none_allowed != 0 {
                pc_tree.u.leaf_split[0].pred_interp_filter = pred_interp_filter;
            }
            rd_pick_sb_modes(
                cpi,
                tile_data,
                X,
                mi_row,
                mi_col,
                *sum_rdc,
                subsize,
                pc_tree.u.leaf_split[0],
                local_best_rdc.rate,
                local_best_rdc.dist
            );
            if sum_rdc.rate == 2147483647 {
                sum_rdc.rdcost = 9223372036854775807;
            } else if cpi.sf.prune_ref_frame_for_rect_partitions != 0 {
                REF1 := cast,no_check(s32) pc_tree.u.leaf_split[0].mic.ref_frame[0];
                REF2 := cast,no_check(s32) pc_tree.u.leaf_split[0].mic.ref_frame[1];
                i = 0;
                while i < 4 {
                    ref_frames_used[i] = cast,no_check(u8) ((cast,no_check(s32) ref_frames_used[i]) | ((cast(s32) 1) << ((REF1) & 31)));
                    if REF2 > 0 {
                        ref_frames_used[i] = cast,no_check(u8) ((cast,no_check(s32) ref_frames_used[i]) | ((cast(s32) 1) << ((REF2) & 31)));
                    }
                    i += 1;
                }
            }
        } else {
            i = 0;
            while i < 4 && (sum_rdc.rdcost < local_best_rdc.rdcost || must_split != 0) {
                X_IDX := i & 1 * MI_STEP;
                Y_IDX := i >> 1 * MI_STEP;
                found_best_rd: s32 = 0;
                best_rdc_split: RD_COST = ---;
                vp9_rd_cost_reset(*best_rdc_split);

                if local_best_rdc.rate < 2147483647 && local_best_rdc.dist < 9223372036854775807 {
                    best_rdc_split.rate = local_best_rdc.rate - sum_rdc.rate;
                    best_rdc_split.dist = local_best_rdc.dist - sum_rdc.dist;
                }

                if mi_row + Y_IDX >= CM.mi_rows || mi_col + X_IDX >= CM.mi_cols {
                    i += 1;
                    continue;
                }

                pc_tree.u.split[i].index = i;
                if cpi.sf.prune_ref_frame_for_rect_partitions != 0 {
                    pc_tree.u.split[i].none.rate = 2147483647;
                }
                found_best_rd =
                    rd_pick_partition(
                        cpi,
                        td,
                        tile_data,
                        tp,
                        mi_row + Y_IDX,
                        mi_col + X_IDX,
                        subsize,
                        *this_rdc,
                        best_rdc_split,
                        pc_tree.u.split[i]
                    );

                if found_best_rd == 0 {
                    sum_rdc.rdcost = 9223372036854775807;
                    break;
                } else {
                    if cpi.sf.prune_ref_frame_for_rect_partitions != 0 && pc_tree.u.split[i].none.rate != 2147483647 {
                        REF1 := cast,no_check(s32) pc_tree.u.split[i].none.mic.ref_frame[0];
                        REF2 := cast,no_check(s32) pc_tree.u.split[i].none.mic.ref_frame[1];
                        ref_frames_used[i] = cast,no_check(u8) ((cast,no_check(s32) ref_frames_used[i]) | ((cast(s32) 1) << ((REF1) & 31)));
                        if REF2 > 0 {
                            ref_frames_used[i] = cast,no_check(u8) ((cast,no_check(s32) ref_frames_used[i]) | ((cast(s32) 1) << ((REF2) & 31)));
                        }
                    }
                    sum_rdc.rate += this_rdc.rate;
                    sum_rdc.dist += this_rdc.dist;
                    vp9_rd_cost_update(partition_mul, X.rddiv, *sum_rdc);
                }
                i += 1;
            }
        }

        if (sum_rdc.rdcost < local_best_rdc.rdcost || must_split != 0) && i == 4 {
            sum_rdc.rate += cpi.partition_cost[PL][PARTITION_SPLIT];
            vp9_rd_cost_update(partition_mul, X.rddiv, *sum_rdc);

            if sum_rdc.rdcost < local_best_rdc.rdcost || must_split != 0 && sum_rdc.dist < local_best_rdc.dist {
                assignment_3: RD_COST = sum_rdc;
                ((*local_best_rdc).*) = assignment_3;
                should_encode_sb = 1;
                pc_tree.partitioning = cast,no_check(PARTITION_TYPE) PARTITION_SPLIT;

                if cpi.sf.rd_ml_partition.search_early_termination == 0 &&
                    X.e_mbd.lossless == 0 &&
                    (local_best_rdc.dist < dist_breakout_thr >> 2 ||
                        local_best_rdc.dist < dist_breakout_thr && local_best_rdc.rate < rate_breakout_thr) {
                    do_rect = 0;
                }
            }
        } else if cpi.sf.less_rectangular_check != 0 &&
            (bsize > cpi.sf.use_square_only_thresh_high || local_best_rdc.dist < dist_breakout_thr) {
            do_rect &= cast(s32) (partition_none_allowed == 0);
        }
        restore_context(X, mi_row, mi_col, a.data, l.data, sa.data, sl.data, bsize);
    }

    pc_tree.horizontal[0].skip_ref_frame_mask = 0;
    pc_tree.horizontal[1].skip_ref_frame_mask = 0;
    pc_tree.vertical[0].skip_ref_frame_mask = 0;
    pc_tree.vertical[1].skip_ref_frame_mask = 0;
    if cpi.sf.prune_ref_frame_for_rect_partitions != 0 {
        used_frames := cast,no_check(u8) ((cast(s32) ref_frames_used[0]) | cast(s32) ref_frames_used[1]);
        if used_frames != 0 {
            pc_tree.horizontal[0].skip_ref_frame_mask = cast,no_check(u8) (~(cast,no_check(s32) used_frames) & 0xff);
        }
        used_frames = cast,no_check(u8) ((cast(s32) ref_frames_used[2]) | cast(s32) ref_frames_used[3]);
        if used_frames != 0 {
            pc_tree.horizontal[1].skip_ref_frame_mask = cast,no_check(u8) (~(cast,no_check(s32) used_frames) & 0xff);
        }
        used_frames = cast,no_check(u8) ((cast(s32) ref_frames_used[0]) | cast(s32) ref_frames_used[2]);
        if used_frames != 0 {
            pc_tree.vertical[0].skip_ref_frame_mask = cast,no_check(u8) (~(cast,no_check(s32) used_frames) & 0xff);
        }
        used_frames = cast,no_check(u8) ((cast(s32) ref_frames_used[1]) | cast(s32) ref_frames_used[3]);
        if used_frames != 0 {
            pc_tree.vertical[1].skip_ref_frame_mask = cast,no_check(u8) (~(cast,no_check(s32) used_frames) & 0xff);
        }
    }

    {
        DO_ML_RECT_PARTITION_PRUNING :=
            cast(s32) (frame_is_intra_only_in_vp9_encodeframe(CM) == 0 && FORCE_HORZ_SPLIT == 0 &&
                FORCE_VERT_SPLIT == 0 && (partition_horz_allowed != 0 || partition_vert_allowed != 0) && bsize > 3);
        if DO_ML_RECT_PARTITION_PRUNING != 0 {
            ml_prune_rect_partition(
                cpi,
                X,
                bsize,
                pc_tree,
                *partition_horz_allowed,
                *partition_vert_allowed,
                local_best_rdc.rdcost
            );
        }
    }

    if partition_horz_allowed != 0 && (do_rect != 0 || vp9_active_h_edge(cpi, mi_row, MI_STEP) != 0) {
        PART_MODE_RATE := cpi.partition_cost[PL][PARTITION_HORZ];
        subsize = get_subsize_in_vp9_encodeframe(bsize, cast,no_check(PARTITION_TYPE) PARTITION_HORZ);
        load_pred_mv(X, CTX);
        if cpi.sf.adaptive_pred_interp_filter != 0 && bsize == 3 && partition_none_allowed != 0 {
            pc_tree.horizontal[0].pred_interp_filter = pred_interp_filter;
        }
        rd_pick_sb_modes(
            cpi,
            tile_data,
            X,
            mi_row,
            mi_col,
            *sum_rdc,
            subsize,
            pc_tree.horizontal.data + 0,
            local_best_rdc.rate - PART_MODE_RATE,
            local_best_rdc.dist
        );
        if sum_rdc.rdcost < 9223372036854775807 {
            sum_rdc.rate += PART_MODE_RATE;
            vp9_rd_cost_update(partition_mul, X.rddiv, *sum_rdc);
        }

        if sum_rdc.rdcost < local_best_rdc.rdcost && mi_row + MI_STEP < CM.mi_rows && bsize > 3 {
            hctx := pc_tree.horizontal.data + 0;
            update_state(cpi, td, hctx, mi_row, mi_col, subsize, 0);
            encode_superblock(cpi, td, tp, 0, mi_row, mi_col, subsize, hctx);
            if cpi.sf.adaptive_pred_interp_filter != 0 && bsize == 3 && partition_none_allowed != 0 {
                pc_tree.horizontal[1].pred_interp_filter = pred_interp_filter;
            }
            rd_pick_sb_modes(
                cpi,
                tile_data,
                X,
                mi_row + MI_STEP,
                mi_col,
                *this_rdc,
                subsize,
                pc_tree.horizontal.data + 1,
                local_best_rdc.rate - sum_rdc.rate,
                local_best_rdc.dist - sum_rdc.dist
            );
            if this_rdc.rate == 2147483647 {
                sum_rdc.rdcost = 9223372036854775807;
            } else {
                sum_rdc.rate += this_rdc.rate;
                sum_rdc.dist += this_rdc.dist;
                vp9_rd_cost_update(partition_mul, X.rddiv, *sum_rdc);
            }
        }

        if sum_rdc.rdcost < local_best_rdc.rdcost {
            assignment_4: RD_COST = sum_rdc;
            ((*local_best_rdc).*) = assignment_4;
            should_encode_sb = 1;
            pc_tree.partitioning = cast,no_check(PARTITION_TYPE) PARTITION_HORZ;

            if cpi.sf.less_rectangular_check != 0 && bsize > cpi.sf.use_square_only_thresh_high {
                do_rect = 0;
            }
        }
        restore_context(X, mi_row, mi_col, a.data, l.data, sa.data, sl.data, bsize);
    }

    if partition_vert_allowed != 0 && (do_rect != 0 || vp9_active_v_edge(cpi, mi_col, MI_STEP) != 0) {
        PART_MODE_RATE := cpi.partition_cost[PL][PARTITION_VERT];
        subsize = get_subsize_in_vp9_encodeframe(bsize, cast,no_check(PARTITION_TYPE) PARTITION_VERT);
        load_pred_mv(X, CTX);
        if cpi.sf.adaptive_pred_interp_filter != 0 && bsize == 3 && partition_none_allowed != 0 {
            pc_tree.vertical[0].pred_interp_filter = pred_interp_filter;
        }
        rd_pick_sb_modes(
            cpi,
            tile_data,
            X,
            mi_row,
            mi_col,
            *sum_rdc,
            subsize,
            pc_tree.vertical.data + 0,
            local_best_rdc.rate - PART_MODE_RATE,
            local_best_rdc.dist
        );
        if sum_rdc.rdcost < 9223372036854775807 {
            sum_rdc.rate += PART_MODE_RATE;
            vp9_rd_cost_update(partition_mul, X.rddiv, *sum_rdc);
        }

        if sum_rdc.rdcost < local_best_rdc.rdcost && mi_col + MI_STEP < CM.mi_cols && bsize > 3 {
            update_state(cpi, td, pc_tree.vertical.data + 0, mi_row, mi_col, subsize, 0);
            encode_superblock(cpi, td, tp, 0, mi_row, mi_col, subsize, pc_tree.vertical.data + 0);
            if cpi.sf.adaptive_pred_interp_filter != 0 && bsize == 3 && partition_none_allowed != 0 {
                pc_tree.vertical[1].pred_interp_filter = pred_interp_filter;
            }
            rd_pick_sb_modes(
                cpi,
                tile_data,
                X,
                mi_row,
                mi_col + MI_STEP,
                *this_rdc,
                subsize,
                pc_tree.vertical.data + 1,
                local_best_rdc.rate - sum_rdc.rate,
                local_best_rdc.dist - sum_rdc.dist
            );
            if this_rdc.rate == 2147483647 {
                sum_rdc.rdcost = 9223372036854775807;
            } else {
                sum_rdc.rate += this_rdc.rate;
                sum_rdc.dist += this_rdc.dist;
                vp9_rd_cost_update(partition_mul, X.rddiv, *sum_rdc);
            }
        }

        if sum_rdc.rdcost < local_best_rdc.rdcost {
            assignment_5: RD_COST = sum_rdc;
            ((*local_best_rdc).*) = assignment_5;
            should_encode_sb = 1;
            pc_tree.partitioning = cast,no_check(PARTITION_TYPE) PARTITION_VERT;
        }
        restore_context(X, mi_row, mi_col, a.data, l.data, sa.data, sl.data, bsize);
    }

    if bsize == 12 && local_best_rdc.rdcost == 9223372036854775807 {
        vp9_rd_cost_reset(*this_rdc);
        rd_pick_sb_modes(cpi, tile_data, X, mi_row, mi_col, *this_rdc, 12, CTX, 2147483647, 9223372036854775807);
        CTX.rdcost = this_rdc.rdcost;
        vp9_rd_cost_update(partition_mul, X.rddiv, *this_rdc);
        if this_rdc.rdcost < local_best_rdc.rdcost {
            assignment_6: RD_COST = this_rdc;
            ((*local_best_rdc).*) = assignment_6;
            should_encode_sb = 1;
            pc_tree.partitioning = cast,no_check(PARTITION_TYPE) PARTITION_NONE;
        }
    }

    assignment_7: RD_COST = local_best_rdc;
    ((rd_cost).*) = assignment_7;

    if should_encode_sb != 0 && pc_tree.index != 3 {
        output_enabled := cast(s32) (bsize == 12);

        encode_sb(cpi, td, TILE_INFO, tp, mi_row, mi_col, output_enabled, bsize, pc_tree);
    }

    if bsize == 12 {
    } else {
    }

    return should_encode_sb;
}

encode_sb :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    td: *Thread_Data_in_vp9_encoder,
    TILE: *Tile_Info,
    tp: **TOKENEXTRA_in_vp9_cx_iface,
    mi_row: s32,
    mi_col: s32,
    output_enabled: s32,
    bsize: BLOCK_SIZE,
    pc_tree: *PC_TREE
) {
    CM := *cpi.common;
    X := *td.mb;
    XD := *X.e_mbd;

    BSL := cast,no_check(s32) B_WIDTH_LOG2_LOOKUP[bsize];
    HBS := (cast(s32) 1) << ((BSL) & 31) / 4;
    ctx: s32 = ---;

    subsize := bsize;

    if mi_row >= CM.mi_rows || mi_col >= CM.mi_cols {
        return;
    }

    if bsize >= 3 {
        ctx = partition_plane_context_in_vp9_encodeframe(XD, mi_row, mi_col, bsize);
        subsize = get_subsize_in_vp9_encodeframe(bsize, pc_tree.partitioning);
    } else {
        ctx = 0;
        subsize = 0;
    }

    partition := (((cast(*[13] PARTITION_TYPE) *(PARTITION_LOOKUP))[BSL]).data)[subsize];
    if output_enabled != 0 && bsize != 0 {
        td.counts.partition[ctx][partition] += 1;
    }

    if partition == {
        case cast,no_check(u32) PARTITION_NONE;
            encode_b(cpi, TILE, td, tp, mi_row, mi_col, output_enabled, subsize, *pc_tree.none);
        case cast,no_check(u32) PARTITION_VERT;
            encode_b(cpi, TILE, td, tp, mi_row, mi_col, output_enabled, subsize, pc_tree.vertical.data + 0);
            if mi_col + HBS < CM.mi_cols && bsize > 3 {
                encode_b(cpi, TILE, td, tp, mi_row, mi_col + HBS, output_enabled, subsize, pc_tree.vertical.data + 1);
            }
        case cast,no_check(u32) PARTITION_HORZ;
            encode_b(cpi, TILE, td, tp, mi_row, mi_col, output_enabled, subsize, pc_tree.horizontal.data + 0);
            if mi_row + HBS < CM.mi_rows && bsize > 3 {
                encode_b(cpi, TILE, td, tp, mi_row + HBS, mi_col, output_enabled, subsize, pc_tree.horizontal.data + 1);
            }
        case;
            if bsize == 3 {
                encode_b(cpi, TILE, td, tp, mi_row, mi_col, output_enabled, subsize, pc_tree.u.leaf_split[0]);
            } else {
                encode_sb(cpi, td, TILE, tp, mi_row, mi_col, output_enabled, subsize, pc_tree.u.split[0]);
                encode_sb(cpi, td, TILE, tp, mi_row, mi_col + HBS, output_enabled, subsize, pc_tree.u.split[1]);
                encode_sb(cpi, td, TILE, tp, mi_row + HBS, mi_col, output_enabled, subsize, pc_tree.u.split[2]);
                encode_sb(cpi, td, TILE, tp, mi_row + HBS, mi_col + HBS, output_enabled, subsize, pc_tree.u.split[3]);
            }
    }

    if partition != cast,no_check(u32) PARTITION_SPLIT || bsize == 3 {
        update_partition_context_in_vp9_encodeframe(XD, mi_row, mi_col, subsize, bsize);
    }
}

encode_b :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    TILE: *Tile_Info,
    td: *Thread_Data_in_vp9_encoder,
    tp: **TOKENEXTRA_in_vp9_cx_iface,
    mi_row: s32,
    mi_col: s32,
    output_enabled: s32,
    bsize: BLOCK_SIZE,
    ctx: *PICK_MODE_CONTEXT
) {
    X := *td.mb;
    set_offsets(cpi, TILE, X, mi_row, mi_col, bsize);

    if cpi.sf.enable_tpl_model != 0 &&
        (cpi.oxcf.aq_mode == cast,no_check(u32) NO_AQ || cpi.oxcf.aq_mode == cast,no_check(u32) PERCEPTUAL_AQ) {
        OXCF := *cpi.oxcf;
        X.rdmult = X.cb_rdmult;
        if OXCF.tuning == cast,no_check(u32) VP8_TUNE_SSIM {
            set_ssim_rdmult(cpi, X, bsize, mi_row, mi_col, *X.rdmult);
        }
    }

    update_state(cpi, td, ctx, mi_row, mi_col, bsize, output_enabled);
    encode_superblock(cpi, td, tp, output_enabled, mi_row, mi_col, bsize, ctx);

    if output_enabled != 0 {
        update_stats(*cpi.common, td);

        tp.*.token = 127;
        tp.* += 1;
    }
}

update_stats :: (cm: *VP9_COMMON, td: *Thread_Data_in_vp9_encoder) {
    x := *td.mb;
    XD := *x.e_mbd;
    MI := XD.mi[0];
    MBMI_EXT := x.mbmi_ext;
    BSIZE := MI.sb_type;

    if frame_is_intra_only_in_vp9_encodeframe(cm) == 0 {
        COUNTS := td.counts;
        INTER_BLOCK := is_inter_block_in_vp9_encodeframe(MI);
        SEG_REF_ACTIVE :=
            segfeature_active_in_vp9_encodeframe(
                *cm.seg,
                cast,no_check(s32) MI.segment_id,
                cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
            );
        if SEG_REF_ACTIVE == 0 {
            ((COUNTS.intra_inter[get_intra_inter_context_in_vp9_encodeframe(XD)]).data)[INTER_BLOCK] += 1;

            if INTER_BLOCK != 0 {
                REF0 := MI.ref_frame[0];
                if cm.reference_mode == cast,no_check(u32) REFERENCE_MODE_SELECT {
                    ((COUNTS.comp_inter[vp9_get_reference_mode_context(cm, XD)]).data)[has_second_ref_in_vp9_encodeframe(MI)] += 1;
                }

                if has_second_ref_in_vp9_encodeframe(MI) != 0 {
                    IDX := cm.ref_frame_sign_bias[cm.comp_fixed_ref];
                    CTX := vp9_get_pred_context_comp_ref_p(cm, XD);
                    BIT := cast(s32) (MI.ref_frame[cast(s32) (IDX == 0)] == cm.comp_var_ref[1]);
                    COUNTS.comp_ref[CTX][BIT] += 1;
                } else {
                    ((((COUNTS.single_ref[vp9_get_pred_context_single_ref_p1(XD)]).data)[0]).data)[cast(s32) (REF0 != 1)] += 1;
                    if REF0 != 1 {
                        ((((COUNTS.single_ref[vp9_get_pred_context_single_ref_p2(XD)]).data)[1]).data)[cast(s32) (REF0 != 2)] += 1;
                    }
                }
            }
        }
        if INTER_BLOCK != 0 &&
            segfeature_active_in_vp9_encodeframe(
                *cm.seg,
                cast,no_check(s32) MI.segment_id,
                cast,no_check(SEG_LVL_FEATURES) SEG_LVL_SKIP
            ) == 0 {
            MODE_CTX := cast,no_check(s32) MBMI_EXT.mode_context[MI.ref_frame[0]];
            if BSIZE >= 3 {
                MODE_ := MI.mode;
                COUNTS.inter_mode[MODE_CTX][(cast(s32) MODE_) - 10] += 1;
            } else {
                NUM_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[BSIZE];
                NUM_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[BSIZE];
                idx: s32 = ---;
                idy: s32 = 0;
                while idy < 2 {
                    idx = 0;
                    while idx < 2 {
                        J := idy * 2 + idx;
                        B_MODE := MI.bmi[J].as_mode;
                        COUNTS.inter_mode[MODE_CTX][(cast(s32) B_MODE) - 10] += 1;
                        idx += NUM_4X4_W;
                    }
                    idy += NUM_4X4_H;
                }
            }
        }
    }
}

encode_superblock :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    td: *Thread_Data_in_vp9_encoder,
    t: **TOKENEXTRA_in_vp9_cx_iface,
    output_enabled: s32,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE,
    ctx: *PICK_MODE_CONTEXT
) {
    CM := *cpi.common;
    X := *td.mb;
    XD := *X.e_mbd;
    mi := XD.mi[0];
    SEG_SKIP :=
        segfeature_active_in_vp9_encodeframe(
            *CM.seg,
            cast,no_check(s32) mi.segment_id,
            cast,no_check(SEG_LVL_FEATURES) SEG_LVL_SKIP
        );
    X.skip_recode =
        cast(s32) (X.select_tx_size == 0 && mi.sb_type >= 3 && cpi.oxcf.aq_mode != cast,no_check(u32) COMPLEXITY_AQ &&
            cpi.oxcf.aq_mode != cast,no_check(u32) CYCLIC_REFRESH_AQ && cpi.sf.allow_skip_recode != 0);

    if X.skip_recode == 0 && cpi.sf.use_nonrd_pick_mode == 0 {
        fill_memory(X.skip_txfm.data, 0, X.skip_txfm.count);
    }

    X.skip_optimize = ctx.is_coded;
    ctx.is_coded = 1;
    X.use_lp32x32fdct = cpi.sf.use_lp32x32fdct;
    X.skip_encode = cast(s32) (output_enabled == 0 && cpi.sf.skip_encode_frame != 0 && X.q_index < 115);

    if X.skip_encode != 0 {
        return;
    }

    if is_inter_block_in_vp9_encodeframe(mi) == 0 {
        mi.skip = 1;
        for plane: 0..cast(s32) 3 - 1 {
            vp9_encode_intra_block_plane(
                X,
                cast,no_check(BLOCK_SIZE) ((ifx bsize > 3 then cast,no_check(s32) bsize else 3)),
                plane,
                1
            );
        }
        if output_enabled != 0 {
            sum_intra_stats_in_vp9_encodeframe(td.counts, mi);
        }
        (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *Thread_Data_in_vp9_encoder, _: **TOKENEXTRA_in_vp9_cx_iface, _: s32, _: s32, _: BLOCK_SIZE)) (cast(*void) vp9_tokenize_sb))(
            cpi,
            td,
            t,
            cast(s32) (output_enabled == 0),
            SEG_SKIP,
            cast,no_check(BLOCK_SIZE) ((ifx bsize > 3 then cast,no_check(s32) bsize else 3))
        );
    } else {
        IS_COMPOUND := has_second_ref_in_vp9_encodeframe(mi);
        set_ref_ptrs_in_vp9_encodeframe(CM, XD, mi.ref_frame[0], mi.ref_frame[1]);
        ref: s32 = 0;
        while ref < 1 + IS_COMPOUND {
            cfg := get_ref_frame_buffer_in_vp9_encodeframe(cpi, mi.ref_frame[ref]);

            vp9_setup_pre_planes(XD, ref, cfg, mi_row, mi_col, *XD.block_refs[ref].sf);
            ref += 1;
        }
        if !(cpi.sf.reuse_inter_pred_sby != 0 && ctx.pred_pixel_ready != 0) || SEG_SKIP != 0 {
            vp9_build_inter_predictors_sby(
                XD,
                mi_row,
                mi_col,
                cast,no_check(BLOCK_SIZE) ((ifx bsize > 3 then cast,no_check(s32) bsize else 3))
            );
        }

        vp9_build_inter_predictors_sbuv(
            XD,
            mi_row,
            mi_col,
            cast,no_check(BLOCK_SIZE) ((ifx bsize > 3 then cast,no_check(s32) bsize else 3))
        );

        vp9_encode_sb(
            X,
            cast,no_check(BLOCK_SIZE) ((ifx bsize > 3 then cast,no_check(s32) bsize else 3)),
            mi_row,
            mi_col,
            output_enabled
        );
        (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *Thread_Data_in_vp9_encoder, _: **TOKENEXTRA_in_vp9_cx_iface, _: s32, _: s32, _: BLOCK_SIZE)) (cast(*void) vp9_tokenize_sb))(
            cpi,
            td,
            t,
            cast(s32) (output_enabled == 0),
            SEG_SKIP,
            cast,no_check(BLOCK_SIZE) ((ifx bsize > 3 then cast,no_check(s32) bsize else 3))
        );
    }

    if SEG_SKIP != 0 {
    }

    if output_enabled != 0 {
        if CM.tx_mode == cast,no_check(u32) TX_MODE_SELECT &&
            mi.sb_type >= 3 &&
            !(is_inter_block_in_vp9_encodeframe(mi) != 0 && mi.skip != 0) {
            (get_tx_counts_in_vp9_encodeframe(
                MAX_TXSIZE_LOOKUP[bsize],
                get_tx_size_context_in_vp9_encodeframe(XD),
                *td.counts.tx
            ))[mi.tx_size] += 1;
        } else if is_inter_block_in_vp9_encodeframe(mi) != 0 {
            mi.tx_size =
                cast,no_check(TX_SIZE) ((ifx TX_MODE_TO_BIGGEST_TX_SIZE[CM.tx_mode] < MAX_TXSIZE_LOOKUP[bsize] then cast,no_check(s32) TX_MODE_TO_BIGGEST_TX_SIZE[CM.tx_mode] else cast,no_check(s32) MAX_TXSIZE_LOOKUP[bsize]));
        } else {
            mi.tx_size =
                cast,no_check(TX_SIZE) ((ifx bsize >= 3 then cast,no_check(s32) mi.tx_size else cast,no_check(s32) (cast(TX_SIZE) 0)));
        }

        td.counts.tx.tx_totals[mi.tx_size] += 1;
        td.counts.tx.tx_totals[get_uv_tx_size_in_vp9_encodeframe(mi, XD.plane.data + 1)] += 1;
        if CM.seg.enabled != 0 && cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ && cpi.cyclic_refresh.content_mode != 0 {
            vp9_cyclic_refresh_update_sb_postencode(cpi, mi, mi_row, mi_col, bsize);
        }
        if cpi.oxcf.pass == 0 &&
            cpi.svc.temporal_layer_id == 0 &&
            (cpi.use_svc == 0 ||
                cpi.use_svc != 0 &&
                    cpi.svc.layer_context[cpi.svc.temporal_layer_id].is_key_frame == 0 &&
                    cpi.svc.spatial_layer_id == cpi.svc.number_spatial_layers - 1) {
            update_zeromv_cnt(cpi, mi, mi_row, mi_col, bsize);
        }
    }
}

update_zeromv_cnt :: (CPI: *VP9_COMP_in_vp9_encoder, MI: *MODE_INFO, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) {
    CM := *CPI.common;
    mv := MI.mv[0].as_mv;
    BW := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize];
    BH := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize];
    XMIS := (ifx CM.mi_cols - mi_col < BW then CM.mi_cols - mi_col else BW);
    YMIS := (ifx CM.mi_rows - mi_row < BH then CM.mi_rows - mi_row else BH);
    BLOCK_INDEX := mi_row * CM.mi_cols + mi_col;
    x: s32 = ---;
    if 0 < YMIS {
        for y: 0..YMIS - 1 {
            x = 0;
            while x < XMIS {
                map_offset := BLOCK_INDEX + y * CM.mi_cols + x;
                if MI.ref_frame[0] == 1 && is_inter_block_in_vp9_encodeframe(MI) != 0 && MI.segment_id <= 2 {
                    if absolute_value(cast,no_check(s32) mv.row) < 8 && absolute_value(cast,no_check(s32) mv.col) < 8 {
                        if CPI.consec_zero_mv[map_offset] < 255 {
                            CPI.consec_zero_mv[map_offset] += 1;
                        }
                    } else {
                        CPI.consec_zero_mv[map_offset] = 0;
                    }
                }
                x += 1;
            }
        }
    }
}

sum_intra_stats_in_vp9_encodeframe :: (counts: *FRAME_COUNTS, mi: *MODE_INFO) {
    Y_MODE := mi.mode;
    UV_MODE := mi.uv_mode;
    BSIZE := mi.sb_type;

    if BSIZE < 3 {
        idx: s32 = ---;
        NUM_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[BSIZE];
        NUM_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[BSIZE];
        idy: s32 = 0;
        while idy < 2 {
            idx = 0;
            while idx < 2 {
                counts.y_mode[0][mi.bmi[idy * 2 + idx].as_mode] += 1;
                idx += NUM_4X4_W;
            }
            idy += NUM_4X4_H;
        }
    } else {
        counts.y_mode[SIZE_GROUP_LOOKUP[BSIZE]][Y_MODE] += 1;
    }

    counts.uv_mode[Y_MODE][UV_MODE] += 1;
}

update_state :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    td: *Thread_Data_in_vp9_encoder,
    ctx: *PICK_MODE_CONTEXT,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE,
    output_enabled: s32
) {
    x_idx: s32 = ---;
    CM := *cpi.common;
    RDC := *td.rd_counts;
    X := *td.mb;
    XD := *X.e_mbd;
    P := X.plane.data;
    PD := XD.plane.data;
    mi := *ctx.mic;
    XDMI := XD.mi[0];
    mi_addr := XD.mi[0];
    SEG := *CM.seg;
    BW := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[mi.sb_type];
    BH := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[mi.sb_type];
    X_MIS := (ifx BW < CM.mi_cols - mi_col then BW else CM.mi_cols - mi_col);
    Y_MIS := (ifx BH < CM.mi_rows - mi_row then BH else CM.mi_rows - mi_row);
    FRAME_MVS := CM.cur_frame.mvs + mi_row * CM.mi_cols + mi_col;
    w: s32 = ---;

    MIS := CM.mi_stride;
    MI_WIDTH := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize];
    MI_HEIGHT := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize];

    assignment_8: MODE_INFO = mi.*;
    ((mi_addr).*) = assignment_8;
    assignment_9: MB_MODE_INFO_EXT = ctx.mbmi_ext;
    ((X.mbmi_ext).*) = assignment_9;

    if SEG.enabled != 0 {
        if cpi.oxcf.aq_mode == cast,no_check(u32) COMPLEXITY_AQ {
            MAP := (ifx SEG.update_map != 0 then cpi.segmentation_map else CM.last_frame_seg_map);
            mi_addr.segment_id = cast,no_check(s8) get_segment_id_in_vp9_encodeframe(CM, MAP, bsize, mi_row, mi_col);
        }

        if cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ && cpi.cyclic_refresh.content_mode != 0 {
            vp9_cyclic_refresh_update_segment(
                cpi,
                XD.mi[0],
                mi_row,
                mi_col,
                bsize,
                cast,no_check(s64) ctx.rate,
                ctx.dist,
                X.skip,
                P
            );
        }
    }

    max_plane := (ifx is_inter_block_in_vp9_encodeframe(XDMI) != 0 then cast(s32) 3 else 1);
    i: s32 = 0;
    while i < max_plane {
        P[i].coeff = ctx.coeff_pbuf[i][1];
        P[i].qcoeff = ctx.qcoeff_pbuf[i][1];
        PD[i].dqcoeff = ctx.dqcoeff_pbuf[i][1];
        P[i].eobs = ctx.eobs_pbuf[i][1];
        i += 1;
    }

    i = max_plane;
    while i < 3 {
        P[i].coeff = ctx.coeff_pbuf[i][2];
        P[i].qcoeff = ctx.qcoeff_pbuf[i][2];
        PD[i].dqcoeff = ctx.dqcoeff_pbuf[i][2];
        P[i].eobs = ctx.eobs_pbuf[i][2];
        i += 1;
    }

    if 0 < MI_HEIGHT {
        for y: 0..MI_HEIGHT - 1 {
            x_idx = 0;
            while x_idx < MI_WIDTH {
                if XD.mb_to_right_edge >> (((3 + 3)) & 31) + MI_WIDTH > x_idx && XD.mb_to_bottom_edge >> (((3 + 3)) & 31) + MI_HEIGHT > y {
                    XD.mi[x_idx + y * MIS] = mi_addr;
                }
                x_idx += 1;
            }
        }
    }

    if cpi.oxcf.aq_mode != cast,no_check(u32) NO_AQ {
        vp9_init_plane_quantizers(cpi, X);
    }

    if is_inter_block_in_vp9_encodeframe(XDMI) != 0 && XDMI.sb_type < 3 {
        XDMI.mv[0].as_int = mi.bmi[3].as_mv[0].as_int;
        XDMI.mv[1].as_int = mi.bmi[3].as_mv[1].as_int;
    }

    X.skip = ctx.skip;
    copy_memory(X.zcoeff_blk[XDMI.tx_size].data, ctx.zcoeff_blk, cast,no_check(u64) ctx.num_4x4_blk);

    if output_enabled == 0 {
        return;
    }

    if frame_is_intra_only_in_vp9_encodeframe(CM) == 0 {
        if is_inter_block_in_vp9_encodeframe(XDMI) != 0 {
            vp9_update_mv_count(td);

            if CM.interp_filter == 4 {
                CTX_INTERP := get_pred_context_switchable_interp_in_vp9_encodeframe(XD);
                td.counts.switchable_interp[CTX_INTERP][XDMI.interp_filter] += 1;
            }
        }

        RDC.comp_pred_diff[SINGLE_REFERENCE] += cast,no_check(s64) ctx.single_pred_diff;
        RDC.comp_pred_diff[COMPOUND_REFERENCE] += cast,no_check(s64) ctx.comp_pred_diff;
        RDC.comp_pred_diff[REFERENCE_MODE_SELECT] += cast,no_check(s64) ctx.hybrid_pred_diff;

        i = 0;
        while i < 3 + 1 {
            RDC.filter_diff[i] += ctx.best_filter_diff[i];
            i += 1;
        }
    }

    if 0 < Y_MIS {
        for h: 0..Y_MIS - 1 {
            FRAME_MV := FRAME_MVS + h * CM.mi_cols;
            w = 0;
            while w < X_MIS {
                MV_ := FRAME_MV + w;
                MV_.ref_frame[0] = mi.ref_frame[0];
                MV_.ref_frame[1] = mi.ref_frame[1];
                MV_.mv[0].as_int = mi.mv[0].as_int;
                MV_.mv[1].as_int = mi.mv[1].as_int;
                w += 1;
            }
        }
    }
}

set_ssim_rdmult :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    X: *MACROBLOCK,
    BSIZE: BLOCK_SIZE,
    MI_ROW: s32,
    MI_COL: s32,
    RDMULT: *s32
) {
    CM := *CPI.common;

    BSIZE_BASE: s32 = 6;
    NUM_8X8_W := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[BSIZE_BASE];
    NUM_8X8_H := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[BSIZE_BASE];
    NUM_COLS := (CM.mi_cols + NUM_8X8_W - 1) / NUM_8X8_W;
    NUM_ROWS := (CM.mi_rows + NUM_8X8_H - 1) / NUM_8X8_H;
    NUM_BCOLS := ((cast(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[BSIZE]) + NUM_8X8_W - 1) / NUM_8X8_W;
    NUM_BROWS := ((cast(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[BSIZE]) + NUM_8X8_H - 1) / NUM_8X8_H;
    col: s32 = ---;
    num_of_mi: float64 = 0.0;
    geom_mean_of_scale: float64 = 0.0;

    row := MI_ROW / NUM_8X8_W;
    while row < NUM_ROWS && row < MI_ROW / NUM_8X8_W + NUM_BROWS {
        col = MI_COL / NUM_8X8_H;
        while col < NUM_COLS && col < MI_COL / NUM_8X8_H + NUM_BCOLS {
            INDEX := row * NUM_COLS + col;
            geom_mean_of_scale += c_transpiler_math_log(CPI.mi_ssim_rdmult_scaling_factors[INDEX]);
            num_of_mi += 1.0;
            col += 1;
        }
        row += 1;
    }
    geom_mean_of_scale = c_transpiler_math_exp(geom_mean_of_scale / num_of_mi);

    RDMULT.* = cast,no_check(s32) ((cast,no_check(float64) RDMULT.*) * geom_mean_of_scale);
    RDMULT.* = ifx RDMULT.* > 0 then RDMULT.* else 0;
    set_error_per_bit_in_vp9_encodeframe(X, RDMULT.*);
}

set_offsets :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    TILE: *Tile_Info,
    X: *MACROBLOCK,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE
) {
    CM := *cpi.common;
    OXCF := *cpi.oxcf;
    XD := *X.e_mbd;
    MI_WIDTH := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize];
    MI_HEIGHT := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize];
    MV_LIMITS := *X.mv_limits;

    set_skip_context_in_vp9_encodeframe(XD, mi_row, mi_col);

    set_mode_info_offsets(CM, X, XD, mi_row, mi_col);

    vp9_setup_dst_planes(XD.plane.data, get_frame_new_buffer_in_vp9_encodeframe(CM), mi_row, mi_col);

    MV_LIMITS.row_min = -((mi_row + MI_HEIGHT) * (cast(s32) 1) << 3 + 4);
    MV_LIMITS.col_min = -((mi_col + MI_WIDTH) * (cast(s32) 1) << 3 + 4);
    MV_LIMITS.row_max = (CM.mi_rows - mi_row) * (cast(s32) 1) << 3 + 4;
    MV_LIMITS.col_max = (CM.mi_cols - mi_col) * (cast(s32) 1) << 3 + 4;

    set_mi_row_col_in_vp9_encodeframe(XD, TILE, mi_row, MI_HEIGHT, mi_col, MI_WIDTH, CM.mi_rows, CM.mi_cols);

    vp9_setup_src_planes(X, cpi.source, mi_row, mi_col);

    X.rddiv = cpi.rd.rddiv;
    X.rdmult = cpi.rd.rdmult;
    if OXCF.tuning == cast,no_check(u32) VP8_TUNE_SSIM {
        set_ssim_rdmult(cpi, X, bsize, mi_row, mi_col, *X.rdmult);
    }

    XD.tile = TILE.*;
}

set_mode_info_offsets :: (CM: *VP9_COMMON, X: *MACROBLOCK, XD: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    IDX_STR := XD.mi_stride * mi_row + mi_col;
    XD.mi = CM.mi_grid_visible + IDX_STR;
    XD.mi[0] = CM.mi + IDX_STR;
    X.mbmi_ext = X.mbmi_ext_base + (mi_row * CM.mi_cols + mi_col);
}

rd_pick_sb_modes :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    tile_data: *Tile_Data_Enc,
    X: *MACROBLOCK,
    mi_row: s32,
    mi_col: s32,
    rd_cost: *RD_COST,
    bsize: BLOCK_SIZE,
    ctx: *PICK_MODE_CONTEXT,
    rate_in_best_rd: s32,
    dist_in_best_rd: s64
) {
    CM := *cpi.common;
    TILE_INFO := *tile_data.tile_info;
    XD := *X.e_mbd;

    P := X.plane.data;
    PD := XD.plane.data;
    AQ_MODE_ := cpi.oxcf.aq_mode;

    best_rd: s64 = 9223372036854775807;

    X.use_lp32x32fdct = 1;

    set_offsets(cpi, TILE_INFO, X, mi_row, mi_col, bsize);
    mi := XD.mi[0];
    mi.sb_type = bsize;

    for i: 0..cast(s32) 3 - 1 {
        P[i].coeff = ctx.coeff_pbuf[i][0];
        P[i].qcoeff = ctx.qcoeff_pbuf[i][0];
        PD[i].dqcoeff = ctx.dqcoeff_pbuf[i][0];
        P[i].eobs = ctx.eobs_pbuf[i][0];
    }
    ctx.is_coded = 0;
    ctx.skippable = 0;
    ctx.pred_pixel_ready = 0;
    X.skip_recode = 0;

    mi.skip = 0;

    X.source_variance = vp9_get_sby_perpixel_variance(cpi, *X.plane[0].src, bsize);

    orig_rdmult := X.rdmult;

    if c_transpiler_float_greater(cpi.sf.tx_domain_thresh, 0.0) ||
        c_transpiler_float_greater(cpi.sf.trellis_opt_tx_rd.thresh, 0.0) {
        logvar := vp9_log_block_var(cpi, X, bsize);

        X.block_tx_domain =
            cast(s32) (cpi.sf.allow_txfm_domain_distortion != 0 &&
                c_transpiler_float_greater_equal(logvar, cpi.sf.tx_domain_thresh));

        X.log_block_src_var = logvar;
    } else {
        X.block_tx_domain = cpi.sf.allow_txfm_domain_distortion;
        X.log_block_src_var = 0.0;
    }

    set_segment_index(cpi, X, mi_row, mi_col, bsize, 0);
    set_segment_rdmult(cpi, X, mi_row, mi_col, bsize, AQ_MODE_);
    if rate_in_best_rd < 2147483647 && dist_in_best_rd < 9223372036854775807 {
        best_rd = vp9_calculate_rd_cost(X.rdmult, X.rddiv, rate_in_best_rd, dist_in_best_rd);
    }

    if frame_is_intra_only_in_vp9_encodeframe(CM) != 0 {
        (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *Macroblock, _: *RD_COST, _: BLOCK_SIZE, _: *PICK_MODE_CONTEXT, _: s64)) (cast(*void) vp9_rd_pick_intra_mode_sb))(
            cpi,
            X,
            rd_cost,
            bsize,
            ctx,
            best_rd
        );
    } else if bsize >= 3 {
        if segfeature_active_in_vp9_encodeframe(
            *CM.seg,
            cast,no_check(s32) mi.segment_id,
            cast,no_check(SEG_LVL_FEATURES) SEG_LVL_SKIP
        ) != 0 {
            (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *Tile_Data_Enc, _: *Macroblock, _: *RD_COST, _: BLOCK_SIZE, _: *PICK_MODE_CONTEXT, _: s64)) (cast(*void) vp9_rd_pick_inter_mode_sb_seg_skip))(
                cpi,
                tile_data,
                X,
                rd_cost,
                bsize,
                ctx,
                best_rd
            );
        } else {
            (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *Tile_Data_Enc, _: *Macroblock, _: s32, _: s32, _: *RD_COST, _: BLOCK_SIZE, _: *PICK_MODE_CONTEXT, _: s64)) (cast(*void) vp9_rd_pick_inter_mode_sb))(
                cpi,
                tile_data,
                X,
                mi_row,
                mi_col,
                rd_cost,
                bsize,
                ctx,
                best_rd
            );
        }
    } else {
        (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *Tile_Data_Enc, _: *Macroblock, _: s32, _: s32, _: *RD_COST, _: BLOCK_SIZE, _: *PICK_MODE_CONTEXT, _: s64)) (cast(*void) vp9_rd_pick_inter_mode_sub8x8))(
            cpi,
            tile_data,
            X,
            mi_row,
            mi_col,
            rd_cost,
            bsize,
            ctx,
            best_rd
        );
    }

    if rd_cost.rate != 2147483647 &&
        AQ_MODE_ == cast,no_check(u32) COMPLEXITY_AQ &&
        bsize >= 6 &&
        (CM.frame_type == cast,no_check(u32) KEY_FRAME ||
            cpi.refresh_alt_ref_frame != 0 ||
            cpi.refresh_golden_frame != 0 && cpi.rc.is_src_frame_alt_ref == 0) {
        vp9_caq_select_segment(cpi, X, bsize, mi_row, mi_col, rd_cost.rate);
    }

    if rd_cost.rate == 2147483647 || rd_cost.dist == 9223372036854775807 {
        rd_cost.rdcost = 9223372036854775807;
    } else {
        rd_cost.rdcost =
            ((((cast,no_check(s64) rd_cost.rate) * cast(s64) X.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                rd_cost.dist << ((X.rddiv) & 63);
    }

    X.rdmult = orig_rdmult;

    ctx.rate = rd_cost.rate;
    ctx.dist = rd_cost.dist;
}

set_segment_rdmult :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    X: *MACROBLOCK,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE,
    aq_mode: AQ_MODE
) {
    CM := *CPI.common;
    OXCF := *CPI.oxcf;
    MAP := (ifx CM.seg.update_map != 0 then CPI.segmentation_map else CM.last_frame_seg_map);

    vp9_init_plane_quantizers(CPI, X);

    if aq_mode == cast,no_check(u32) NO_AQ || aq_mode == cast,no_check(u32) PSNR_AQ {
        if CPI.sf.enable_tpl_model != 0 {
            X.rdmult = X.cb_rdmult;
        }
    } else if aq_mode == cast,no_check(u32) PERCEPTUAL_AQ {
        X.rdmult = X.cb_rdmult;
    } else if aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ {
        if cyclic_refresh_segment_id_boosted_in_vp9_encodeframe(
            get_segment_id_in_vp9_encodeframe(CM, MAP, bsize, mi_row, mi_col)
        ) != 0 {
            X.rdmult = vp9_cyclic_refresh_get_rdmult(CPI.cyclic_refresh);
        }
    } else {
        X.rdmult = vp9_compute_rd_mult(CPI, CM.base_qindex + CM.y_dc_delta_q);
    }

    if OXCF.tuning == cast,no_check(u32) VP8_TUNE_SSIM {
        set_ssim_rdmult(CPI, X, bsize, mi_row, mi_col, *X.rdmult);
    }
}

set_segment_index :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    X: *MACROBLOCK,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE,
    segment_index: s32
) {
    CM := *cpi.common;
    SEG := *CM.seg;
    XD := *X.e_mbd;
    mi := XD.mi[0];

    AQ_MODE_ := cpi.oxcf.aq_mode;
    MAP := (ifx SEG.update_map != 0 then cpi.segmentation_map else CM.last_frame_seg_map);

    mi.segment_id = 0;

    if SEG.enabled == 0 {
        return;
    }

    if AQ_MODE_ == {
        case cast,no_check(u32) CYCLIC_REFRESH_AQ;
            mi.segment_id = cast,no_check(s8) get_segment_id_in_vp9_encodeframe(CM, MAP, bsize, mi_row, mi_col);
        case cast,no_check(u32) VARIANCE_AQ;
            if CM.frame_type == cast,no_check(u32) KEY_FRAME ||
                cpi.refresh_alt_ref_frame != 0 ||
                cpi.force_update_segmentation != 0 ||
                cpi.refresh_golden_frame != 0 && cpi.rc.is_src_frame_alt_ref == 0 {
                min_energy: s32 = ---;
                max_energy: s32 = ---;

                if bsize >= 9 {
                    vp9_get_sub_block_energy(cpi, X, mi_row, mi_col, bsize, *min_energy, *max_energy);
                } else {
                    min_energy = ifx bsize <= 6 then X.mb_energy else vp9_block_energy(cpi, X, bsize);
                }
                mi.segment_id = cast,no_check(s8) vp9_vaq_segment_id(min_energy);
            } else {
                mi.segment_id = cast,no_check(s8) get_segment_id_in_vp9_encodeframe(CM, MAP, bsize, mi_row, mi_col);
            }
        case cast,no_check(u32) EQUATOR360_AQ;
            if CM.frame_type == cast,no_check(u32) KEY_FRAME || cpi.force_update_segmentation != 0 {
                mi.segment_id = cast,no_check(s8) vp9_360aq_segment_id(mi_row, CM.mi_rows);
            } else {
                mi.segment_id = cast,no_check(s8) get_segment_id_in_vp9_encodeframe(CM, MAP, bsize, mi_row, mi_col);
            }
        case cast,no_check(u32) LOOKAHEAD_AQ;
            mi.segment_id = cast,no_check(s8) get_segment_id_in_vp9_encodeframe(CM, MAP, bsize, mi_row, mi_col);
        case cast,no_check(u32) PSNR_AQ;
            mi.segment_id = cast,no_check(s8) segment_index;
        case cast,no_check(u32) PERCEPTUAL_AQ;
            mi.segment_id = cast,no_check(s8) X.segment_id;
        case;
    }

    if cpi.roi.enabled != 0 || cpi.active_map.enabled != 0 {
        mi.segment_id = cast,no_check(s8) get_segment_id_in_vp9_encodeframe(CM, MAP, bsize, mi_row, mi_col);
    }

    vp9_init_plane_quantizers(cpi, X);
}

restore_context :: (
    X: *MACROBLOCK,
    mi_row: s32,
    mi_col: s32,
    a: *ENTROPY_CONTEXT,
    l: *ENTROPY_CONTEXT,
    sa: *PARTITION_CONTEXT,
    sl: *PARTITION_CONTEXT,
    bsize: BLOCK_SIZE
) {
    XD := *X.e_mbd;

    NUM_4X4_BLOCKS_WIDE := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[bsize];
    NUM_4X4_BLOCKS_HIGH := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[bsize];
    mi_width := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize];
    mi_height := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize];
    for p: 0..cast(s32) 3 - 1 {
        copy_memory(
            XD.above_context[p] + (mi_col * 2) >> ((XD.plane[p].subsampling_x) & 31),
            a + NUM_4X4_BLOCKS_WIDE * p,
            (size_of(ENTROPY_CONTEXT) * cast,no_check(u64) NUM_4X4_BLOCKS_WIDE) >> ((XD.plane[p].subsampling_x) & 63)
        );
        copy_memory(
            XD.left_context[p].data +
            (mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1) * 2) >> ((XD.plane[p].subsampling_y) & 31),
            l + NUM_4X4_BLOCKS_HIGH * p,
            (size_of(ENTROPY_CONTEXT) * cast,no_check(u64) NUM_4X4_BLOCKS_HIGH) >> ((XD.plane[p].subsampling_y) & 63)
        );
    }
    copy_memory(XD.above_seg_context + mi_col, sa, cast,no_check(u64) mi_width);
    copy_memory(
        XD.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1),
        sl,
        cast,no_check(u64) mi_height
    );
}

load_pred_mv :: (x: *MACROBLOCK, ctx: *PICK_MODE_CONTEXT) {
    copy_memory(x.pred_mv.data, ctx.pred_mv.data, x.pred_mv.count * size_of(MV));
}

ml_prune_rect_partition :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    X: *MACROBLOCK,
    bsize: BLOCK_SIZE,
    PC_TREE_: *PC_TREE,
    allow_horz: *s32,
    allow_vert: *s32,
    ref_rd: s64
) {
    nn_config: *NN_CONFIG = null;
    score := float32.[ 0.0, cast,no_check(float32) 0, cast,no_check(float32) 0, cast,no_check(float32) 0 ];
    thresh: s32 = -1;

    if ref_rd <= 0 || ref_rd > 1000000000 {
        return;
    }

    if cast,no_check(s32) bsize == {
        case 3;
        case 6;
            nn_config = *VP9_RECT_PART_NNCONFIG_16;
            thresh = CPI.sf.rd_ml_partition.prune_rect_thresh[1];
        case 9;
            nn_config = *VP9_RECT_PART_NNCONFIG_32;
            thresh = CPI.sf.rd_ml_partition.prune_rect_thresh[2];
        case 12;
            nn_config = *VP9_RECT_PART_NNCONFIG_64;
            thresh = CPI.sf.rd_ml_partition.prune_rect_thresh[3];
        case;
            return;
    }
    if nn_config == null || thresh < 0 {
        return;
    }

    {
        CM := *CPI.common;

        DC_Q := cast,no_check(s32) vp9_dc_quant(CM.base_qindex, 0, CM.bit_depth);

        BS := 4 * cast(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[bsize];
        feature_index: s32 = 0;
        features: [8] float32 = ---;

        assignment_10: float32 = logf((cast,no_check(float32) DC_Q) + 1.0);
        (features[c_transpiler_post_increment(*(feature_index))]) = assignment_10;
        features[feature_index] = cast,no_check(float32) (PC_TREE_.partitioning == cast,no_check(u32) PARTITION_NONE);
        feature_index += 1;
        assignment_11: float32 = logf((cast,no_check(float32) ref_rd) / BS / BS + 1.0);
        (features[c_transpiler_post_increment(*(feature_index))]) = assignment_11;

        {
            NORM_FACTOR := 1.0 / ((cast,no_check(float32) ref_rd) + 1.0);
            NONE_RDCOST := PC_TREE_.none.rdcost;
            rd_ratio: float32 = 2.0;
            if NONE_RDCOST > 0 && NONE_RDCOST < 1000000000 {
                rd_ratio = (cast,no_check(float32) NONE_RDCOST) * NORM_FACTOR;
            }
            features[feature_index] = (ifx c_transpiler_float_less(rd_ratio, 2.0) then rd_ratio else 2.0);
            feature_index += 1;

            for i: 0..cast(s32) 4 - 1 {
                THIS_RD := PC_TREE_.u.split[i].none.rdcost;
                RD_VALID := cast(s32) (THIS_RD > 0 && THIS_RD < 1000000000);

                features[feature_index] = (ifx RD_VALID != 0 then (cast,no_check(float32) THIS_RD) * NORM_FACTOR else 1.0);
                feature_index += 1;
            }
        }

        nn_predict(features.data, nn_config, score.data);
    }

    {
        max_score: s32 = -1000;
        horz: s32 = 0;
        vert: s32 = 0;
        int_score: [4] s32 = ---;
        for i: 0..cast(s32) 4 - 1 {
            int_score[i] = cast,no_check(s32) (100.0 * score[i]);
            max_score = ifx int_score[i] > max_score then int_score[i] else max_score;
        }
        thresh = max_score - thresh;
        for i: 0..cast(s32) 4 - 1 {
            if int_score[i] >= thresh {
                if i & 1 != 0 {
                    horz = 1;
                }
                if i >> 1 & 1 != 0 {
                    vert = 1;
                }
            }
        }
        allow_horz.* = cast(s32) (allow_horz.* != 0 && horz != 0);
        allow_vert.* = cast(s32) (allow_vert.* != 0 && vert != 0);
    }
}

nn_predict :: (features: *float32, nn_config: *NN_CONFIG, output: *float32) {
    num_input_nodes := nn_config.num_inputs;
    buf_index: s32 = 0;
    buf: [2] [128] float32 = ---;
    input_nodes := features;

    NUM_LAYERS := nn_config.num_hidden_layers;
    node: s32 = ---;
    i: s32 = ---;

    if 0 < NUM_LAYERS {
        for layer: 0..NUM_LAYERS - 1 {
            weights := nn_config.weights[layer];
            bias := nn_config.bias[layer];
            output_nodes := buf[buf_index].data;
            NUM_OUTPUT_NODES := nn_config.num_hidden_nodes[layer];

            node = 0;
            while node < NUM_OUTPUT_NODES {
                val: float32 = 0.0;
                i = 0;
                while i < num_input_nodes {
                    val += weights[i] * input_nodes[i];
                    i += 1;
                }
                val += bias[node];

                val = ifx c_transpiler_float_greater(val, 0.0) then val else 0.0;
                output_nodes[node] = val;
                weights += num_input_nodes;
                node += 1;
            }
            num_input_nodes = NUM_OUTPUT_NODES;
            input_nodes = output_nodes;
            buf_index = 1 - buf_index;
        }
    }

    {
        weights := nn_config.weights[NUM_LAYERS];
        node = 0;
        while node < nn_config.num_outputs {
            bias := nn_config.bias[NUM_LAYERS];
            val: float32 = 0.0;
            i = 0;
            while i < num_input_nodes {
                val += weights[i] * input_nodes[i];
                i += 1;
            }
            output[node] = val + bias[node];
            weights += num_input_nodes;
            node += 1;
        }
    }
}

store_pred_mv :: (x: *MACROBLOCK, ctx: *PICK_MODE_CONTEXT) {
    copy_memory(ctx.pred_mv.data, x.pred_mv.data, x.pred_mv.count * size_of(MV));
}

ml_predict_breakout :: (CPI: *VP9_COMP_in_vp9_encoder, bsize: BLOCK_SIZE, X: *MACROBLOCK, RD_COST_: *RD_COST) -> s32 {
    CM := *CPI.common;
    features: [4] float32 = ---;
    linear_weights: *float32 = null;
    linear_score: float32 = 0.0;
    QINDEX := CM.base_qindex;
    Q_CTX := (ifx QINDEX >= 200 then 0 else (ifx QINDEX >= 150 then cast(s32) 1 else 2));
    IS_720P_OR_LARGER := cast(s32) ((ifx CM.width < CM.height then CM.width else CM.height) >= 720);
    RESOLUTION_CTX := cast(s32) (IS_720P_OR_LARGER != 0);

    if cast,no_check(s32) bsize == {
        case 12;
            linear_weights = VP9_PARTITION_BREAKOUT_WEIGHTS_64[RESOLUTION_CTX][Q_CTX].data;
        case 9;
            linear_weights = VP9_PARTITION_BREAKOUT_WEIGHTS_32[RESOLUTION_CTX][Q_CTX].data;
        case 6;
            linear_weights = VP9_PARTITION_BREAKOUT_WEIGHTS_16[RESOLUTION_CTX][Q_CTX].data;
        case 3;
            linear_weights = VP9_PARTITION_BREAKOUT_WEIGHTS_8[RESOLUTION_CTX][Q_CTX].data;
        case;
            return 0;
    }
    if linear_weights == null {
        return 0;
    }

    {
        AC_Q := cast,no_check(s32) vp9_ac_quant(QINDEX, 0, CM.bit_depth);

        NUM_PELS_LOG2 := cast,no_check(s32) NUM_PELS_LOG2_LOOKUP[bsize];
        feature_index: s32 = 0;
        sse: u32 = ---;

        var := CPI.fn_ptr[bsize].vf(X.plane[0].src.buf, X.plane[0].src.stride, VP9_64_ZEROS.data, 0, *sse);

        var = var >> ((NUM_PELS_LOG2) & 31);

        rate_f := cast,no_check(float32) ((ifx RD_COST_.rate < 2147483647 then RD_COST_.rate else 2147483647));
        dist_f :=
            cast,no_check(float32) ((ifx RD_COST_.dist < 2147483647 then RD_COST_.dist else 2147483647) >> ((NUM_PELS_LOG2) & 63));
        rate_f =
            ((cast,no_check(float32) X.rdmult) / 128.0 / 512.0 / cast,no_check(float32) ((cast(s32) 1) << ((NUM_PELS_LOG2) & 31))) *
                rate_f;

        features[feature_index] = rate_f;
        feature_index += 1;
        features[feature_index] = dist_f;
        feature_index += 1;
        features[feature_index] = cast,no_check(float32) var;
        feature_index += 1;
        features[feature_index] = cast,no_check(float32) AC_Q;
        feature_index += 1;
    }

    {
        linear_score = linear_weights[4];
        for i: 0..cast(s32) 4 - 1 {
            linear_score += linear_weights[i] * features[i];
        }
    }

    if c_transpiler_float_greater_equal(linear_score, CPI.sf.rd_ml_partition.search_breakout_thresh[Q_CTX]) {
        return 1;
    }
    return 0;
}

ml_pruning_partition :: (
    CM: *VP9_COMMON,
    XD: *MACROBLOCKD,
    ctx: *PICK_MODE_CONTEXT,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE
) -> s32 {
    MAG_MV :=
        absolute_value(cast,no_check(s32) ctx.mic.mv[0].as_mv.col) +
            absolute_value(cast,no_check(s32) ctx.mic.mv[0].as_mv.row);
    LEFT_IN_IMAGE := cast(s32) (XD.left_mi != null);
    ABOVE_IN_IMAGE := cast(s32) (XD.above_mi != null);
    above_par: s32 = 0;
    left_par: s32 = 0;
    last_par: s32 = 0;
    offset: s32 = 0;

    context_size: BLOCK_SIZE = ---;
    nn_config: *NN_CONFIG = null;
    nn_score: float32 = ---;
    features: [7] float32 = ---;

    if cast,no_check(s32) bsize == {
        case 12;
            offset = 0;
            nn_config = *VP9_PARTITION_NNCONFIG_64X64;
        case 9;
            offset = 8;
            nn_config = *VP9_PARTITION_NNCONFIG_32X32;
        case 6;
            offset = 16;
            nn_config = *VP9_PARTITION_NNCONFIG_16X16;
        case;
            return 0;
    }

    if ABOVE_IN_IMAGE != 0 {
        context_size = XD.above_mi.sb_type;
        if context_size < bsize {
            above_par = 2;
        } else if context_size == bsize {
            above_par = 1;
        }
    }

    if LEFT_IN_IMAGE != 0 {
        context_size = XD.left_mi.sb_type;
        if context_size < bsize {
            left_par = 2;
        } else if context_size == bsize {
            left_par = 1;
        }
    }

    if CM.width == CM.last_width && CM.height == CM.last_height {
        prev_mi := *CM.prev_mi_grid_visible[mi_col + CM.mi_stride * mi_row];
        if prev_mi[0] != null {
            context_size = prev_mi[0].sb_type;
            if context_size < bsize {
                last_par = 2;
            } else if context_size == bsize {
                last_par = 1;
            }
        }
    }

    mean := VP9_PARTITION_FEATURE_MEAN.data + offset;
    sd := VP9_PARTITION_FEATURE_STD.data + offset;
    features[0] = ((cast,no_check(float32) ctx.rate) - mean[0]) / sd[0];
    features[1] = ((cast,no_check(float32) ctx.dist) - mean[1]) / sd[1];
    features[2] = ((cast,no_check(float32) MAG_MV) / 2.0 - mean[2]) * sd[2];
    features[3] = ((cast,no_check(float32) (left_par + above_par)) / 2.0 - mean[3]) * sd[3];
    features[4] = ((cast,no_check(float32) ctx.sum_y_eobs) - mean[4]) / sd[4];
    features[5] = ((cast,no_check(float32) CM.base_qindex) - mean[5]) * sd[5];
    features[6] = ((cast,no_check(float32) last_par) - mean[6]) * sd[6];

    linear_weights := VP9_PARTITION_LINEAR_WEIGHTS.data + offset;
    linear_score := linear_weights[7];
    for i: 0..cast(s32) 7 - 1 {
        linear_score += linear_weights[i] * features[i];
    }
    if c_transpiler_float_greater(linear_score, 0.1) {
        return 0;
    }

    nn_predict(features.data, nn_config, *nn_score);

    if c_transpiler_float_less(linear_score, -0.0) && c_transpiler_float_less(nn_score, 0.1) {
        return 1;
    }
    if c_transpiler_float_less(nn_score, -0.0) && c_transpiler_float_less(linear_score, 0.1) {
        return 1;
    }
    return 0;
}

ml_predict_var_rd_partitioning :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    X: *MACROBLOCK,
    PC_TREE_: *PC_TREE,
    bsize: BLOCK_SIZE,
    mi_row: s32,
    mi_col: s32,
    none: *s32,
    split: *s32
) {
    CM := *CPI.common;
    nn_config: *NN_CONFIG = null;
    XD := *X.e_mbd;

    pred_buffer: [4096] u8 = --- #align 16;
    PRED_BUF := pred_buffer.data;

    SPEED := CPI.oxcf.speed;
    thresh: float32 = 0.0;

    if cast,no_check(s32) bsize == {
        case 12;
            nn_config = *VP9_PART_SPLIT_NNCONFIG_64;
            thresh = ifx SPEED > 0 then 2.8 else 3.0;
        case 9;
            nn_config = *VP9_PART_SPLIT_NNCONFIG_32;
            thresh = ifx SPEED > 0 then 3.5 else 3.0;
        case 6;
            nn_config = *VP9_PART_SPLIT_NNCONFIG_16;
            thresh = ifx SPEED > 0 then 3.8 else 4.0;
        case 3;
            nn_config = *VP9_PART_SPLIT_NNCONFIG_8;
            if CM.width >= 720 && CM.height >= 720 {
                thresh = ifx SPEED > 0 then 2.5 else 2.0;
            } else {
                thresh = ifx SPEED > 0 then 3.8 else 2.0;
            }
        case;
            return;
    }

    if nn_config == null {
        return;
    }

    {
        ref_mv: MV = ---;
        REF := (ifx CPI.rc.is_src_frame_alt_ref != 0 then cast(MV_REFERENCE_FRAME) 3 else 1);

        if bsize == 12 {
            ref_mv.col = 0;
            ref_mv.row = ref_mv.col;
        } else {
            ref_mv = PC_TREE_.mv;
        }
        vp9_setup_src_planes(X, CPI.source, mi_row, mi_col);
        simple_motion_search(CPI, X, bsize, mi_row, mi_col, ref_mv, REF, PRED_BUF);
        PC_TREE_.mv = X.e_mbd.mi[0].mv[0].as_mv;
    }

    {
        features :=
            float32.[
                0.0,
                cast,no_check(float32) 0,
                cast,no_check(float32) 0,
                cast,no_check(float32) 0,
                cast,no_check(float32) 0,
                cast,no_check(float32) 0,
                cast,no_check(float32) 0,
                cast,no_check(float32) 0,
                cast,no_check(float32) 0,
                cast,no_check(float32) 0,
                cast,no_check(float32) 0,
                cast,no_check(float32) 0
            ];

        DC_Q := cast,no_check(s32) vp9_dc_quant(CM.base_qindex, 0, CM.bit_depth);

        feature_idx: s32 = 0;
        score: float32 = ---;

        assignment_12: float32 = logf((cast,no_check(float32) DC_Q) + 1.0);
        (features[c_transpiler_post_increment(*(feature_idx))]) = assignment_12;

        {
            BS := 4 * cast(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[bsize];
            SUBSIZE := get_subsize_in_vp9_encodeframe(bsize, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT);
            pred := PRED_BUF;
            src := X.plane[0].src.buf;
            SRC_STRIDE := X.plane[0].src.stride;
            PRED_STRIDE: s32 = 64;
            sse: u32 = ---;

            VAR := CPI.fn_ptr[bsize].vf(src, SRC_STRIDE, pred, PRED_STRIDE, *sse);
            FACTOR := (ifx VAR == 0 then 1.0 else 1.0 / cast,no_check(float32) VAR);
            HAS_ABOVE := cast(s32) (XD.above_mi != null);
            HAS_LEFT := cast(s32) (XD.left_mi != null);
            ABOVE_BSIZE :=
                cast,no_check(BLOCK_SIZE) ((ifx HAS_ABOVE != 0 then cast,no_check(s32) XD.above_mi.sb_type else cast,no_check(s32) bsize));
            LEFT_BSIZE :=
                cast,no_check(BLOCK_SIZE) ((ifx HAS_LEFT != 0 then cast,no_check(s32) XD.left_mi.sb_type else cast,no_check(s32) bsize));

            features[feature_idx] = cast,no_check(float32) HAS_ABOVE;
            feature_idx += 1;
            features[feature_idx] = cast,no_check(float32) B_WIDTH_LOG2_LOOKUP[ABOVE_BSIZE];
            feature_idx += 1;
            features[feature_idx] = cast,no_check(float32) B_HEIGHT_LOG2_LOOKUP[ABOVE_BSIZE];
            feature_idx += 1;
            features[feature_idx] = cast,no_check(float32) HAS_LEFT;
            feature_idx += 1;
            features[feature_idx] = cast,no_check(float32) B_WIDTH_LOG2_LOOKUP[LEFT_BSIZE];
            feature_idx += 1;
            features[feature_idx] = cast,no_check(float32) B_HEIGHT_LOG2_LOOKUP[LEFT_BSIZE];
            feature_idx += 1;
            assignment_13: float32 = logf((cast,no_check(float32) VAR) + 1.0);
            (features[c_transpiler_post_increment(*(feature_idx))]) = assignment_13;
            for i: 0..cast(s32) 4 - 1 {
                X_IDX := i & 1 * BS / 2;
                Y_IDX := i >> 1 * BS / 2;
                SRC_OFFSET := Y_IDX * SRC_STRIDE + X_IDX;
                PRED_OFFSET := Y_IDX * PRED_STRIDE + X_IDX;

                SUB_VAR :=
                    CPI.fn_ptr[SUBSIZE].vf(
                        src + SRC_OFFSET,
                        SRC_STRIDE,
                        pred + PRED_OFFSET,
                        PRED_STRIDE,
                        *sse
                    );
                VAR_RATIO := (ifx VAR == 0 then 1.0 else FACTOR * cast,no_check(float32) SUB_VAR);
                features[feature_idx] = VAR_RATIO;
                feature_idx += 1;
            }
        }

        nn_predict(features.data, nn_config, *score);

        if c_transpiler_float_greater(score, thresh) {
            none.* = 0;
        }
        if c_transpiler_float_less(score, -thresh) {
            split.* = 0;
        }
    }
}

simple_motion_search :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    X: *MACROBLOCK,
    bsize: BLOCK_SIZE,
    mi_row: s32,
    mi_col: s32,
    ref_mv: MV,
    ref: MV_REFERENCE_FRAME,
    PRED_BUF: *u8
) {
    local_ref_mv: MV = ref_mv;
    CM := *CPI.common;
    XD := *X.e_mbd;
    MI := XD.mi[0];
    yv12: *YV12_BUFFER_CONFIG = ---;
    scaled_ref_frame := vp9_get_scaled_ref_frame(CPI, cast,no_check(s32) ref);
    STEP_PARAM: s32 = 1;
    TMP_MV_LIMITS := X.mv_limits;
    SEARCH_METHOD := cast,no_check(SEARCH_METHODS_in_vp9_cx_iface) NSTEP_in_vp9_cx_iface;
    SADPB := X.sadperbit16;
    ref_mv_full :=
        MV.{row = cast,no_check(s16) ((cast(s32) local_ref_mv.row) >> 3), col = cast,no_check(s16) ((cast(s32) local_ref_mv.col) >> 3)};
    best_mv: MV;
    cost_list: [5] s32 = ---;
    backup_pre: [3] Buf_2d;

    if scaled_ref_frame != null {
        yv12 = scaled_ref_frame;

        for i: 0..cast(s32) 3 - 1 {
            backup_pre[i] = XD.plane[i].pre[0];
        }
    } else {
        yv12 = get_ref_frame_buffer_in_vp9_encodeframe(CPI, ref);
    }

    if yv12 == null {
        return;
    }
    vp9_setup_pre_planes(XD, 0, yv12, mi_row, mi_col, null);
    MI.ref_frame[0] = ref;
    MI.ref_frame[1] = -1;
    MI.sb_type = bsize;
    (cast,no_check(#type (_: *Mv_Limits, _: *MV)) (cast(*void) vp9_set_mv_search_range))(*X.mv_limits, *local_ref_mv);
    vp9_full_pixel_search(
        CPI,
        X,
        bsize,
        *ref_mv_full,
        STEP_PARAM,
        cast,no_check(s32) SEARCH_METHOD,
        SADPB,
        cond_cost_list_in_vp9_encodeframe(CPI, cost_list.data),
        *local_ref_mv,
        *best_mv,
        0,
        0
    );
    best_mv.row = cast,no_check(s16) ((cast,no_check(s32) best_mv.row) * 8);
    best_mv.col = cast,no_check(s16) ((cast,no_check(s32) best_mv.col) * 8);
    X.mv_limits = TMP_MV_LIMITS;
    MI.mv[0].as_mv = best_mv;

    if scaled_ref_frame != null {
        for i: 0..cast(s32) 3 - 1 {
            XD.plane[i].pre[0] = backup_pre[i];
        }
    }

    set_ref_ptrs_in_vp9_encodeframe(CM, XD, MI.ref_frame[0], MI.ref_frame[1]);
    XD.plane[0].dst.buf = PRED_BUF;
    XD.plane[0].dst.stride = 64;
    vp9_build_inter_predictors_sby(XD, mi_row, mi_col, bsize);
}

save_context :: (
    X: *MACROBLOCK,
    mi_row: s32,
    mi_col: s32,
    a: *ENTROPY_CONTEXT,
    l: *ENTROPY_CONTEXT,
    sa: *PARTITION_CONTEXT,
    sl: *PARTITION_CONTEXT,
    bsize: BLOCK_SIZE
) {
    XD := *X.e_mbd;

    NUM_4X4_BLOCKS_WIDE := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[bsize];
    NUM_4X4_BLOCKS_HIGH := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[bsize];
    mi_width := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize];
    mi_height := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize];

    for p: 0..cast(s32) 3 - 1 {
        copy_memory(
            a + NUM_4X4_BLOCKS_WIDE * p,
            XD.above_context[p] + (mi_col * 2) >> ((XD.plane[p].subsampling_x) & 31),
            (size_of(ENTROPY_CONTEXT) * cast,no_check(u64) NUM_4X4_BLOCKS_WIDE) >> ((XD.plane[p].subsampling_x) & 63)
        );
        copy_memory(
            l + NUM_4X4_BLOCKS_HIGH * p,
            XD.left_context[p].data +
            (mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1) * 2) >> ((XD.plane[p].subsampling_y) & 31),
            (size_of(ENTROPY_CONTEXT) * cast,no_check(u64) NUM_4X4_BLOCKS_HIGH) >> ((XD.plane[p].subsampling_y) & 63)
        );
    }
    copy_memory(sa, XD.above_seg_context + mi_col, cast,no_check(u64) mi_width);
    copy_memory(
        sl,
        XD.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1),
        cast,no_check(u64) mi_height
    );
}

set_partition_range :: (
    cm: *VP9_COMMON,
    xd: *MACROBLOCKD,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE,
    min_bs: *BLOCK_SIZE,
    max_bs: *BLOCK_SIZE
) {
    mi_width := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize];
    mi_height := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize];
    idx: s32 = ---;
    bs: BLOCK_SIZE = ---;
    min_size: BLOCK_SIZE = ---;

    min_size = 12;
    max_size: BLOCK_SIZE = 0;

    if cm.width != cm.last_width || cm.height != cm.last_height {
        min_bs.* = min_size;
        max_bs.* = max_size;
        return;
    }

    mi: *MODE_INFO = ---;
    IDX_STR := cm.mi_stride * mi_row + mi_col;
    prev_mi := *cm.prev_mi_grid_visible[IDX_STR];

    if 0 < mi_height {
        for idy: 0..mi_height - 1 {
            idx = 0;
            while idx < mi_width {
                mi = prev_mi[idy * cm.mi_stride + idx];
                bs =
                    cast,no_check(BLOCK_SIZE) ((ifx mi != null then cast,no_check(s32) mi.sb_type else cast,no_check(s32) bsize));
                min_size = cast,no_check(BLOCK_SIZE) (min(cast,no_check(s32) min_size, cast,no_check(s32) bs));
                max_size = cast,no_check(BLOCK_SIZE) (max(cast,no_check(s32) max_size, cast,no_check(s32) bs));
                idx += 1;
            }
        }
    }

    if xd.left_mi != null {
        if 0 < mi_height {
            for idy: 0..mi_height - 1 {
                mi = xd.mi[idy * cm.mi_stride - 1];
                bs =
                    cast,no_check(BLOCK_SIZE) ((ifx mi != null then cast,no_check(s32) mi.sb_type else cast,no_check(s32) bsize));
                min_size = cast,no_check(BLOCK_SIZE) (min(cast,no_check(s32) min_size, cast,no_check(s32) bs));
                max_size = cast,no_check(BLOCK_SIZE) (max(cast,no_check(s32) max_size, cast,no_check(s32) bs));
            }
        }
    }

    if xd.above_mi != null {
        idx = 0;
        while idx < mi_width {
            mi = xd.mi[idx - cm.mi_stride];
            bs =
                cast,no_check(BLOCK_SIZE) ((ifx mi != null then cast,no_check(s32) mi.sb_type else cast,no_check(s32) bsize));
            min_size = cast,no_check(BLOCK_SIZE) (min(cast,no_check(s32) min_size, cast,no_check(s32) bs));
            max_size = cast,no_check(BLOCK_SIZE) (max(cast,no_check(s32) max_size, cast,no_check(s32) bs));
            idx += 1;
        }
    }

    if min_size == max_size {
        min_size = MIN_PARTITION_SIZE[min_size];
        max_size = MAX_PARTITION_SIZE[max_size];
    }

    min_bs.* = min_size;
    max_bs.* = max_size;
}

rd_auto_partition_range :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    TILE: *Tile_Info,
    XD: *MACROBLOCKD,
    mi_row: s32,
    mi_col: s32,
    min_block_size: *BLOCK_SIZE,
    max_block_size: *BLOCK_SIZE
) {
    CM := *cpi.common;
    mi := XD.mi;
    LEFT_IN_IMAGE := cast(s32) (XD.left_mi != null);
    ABOVE_IN_IMAGE := cast(s32) (XD.above_mi != null);
    ROW8X8_REMAINING := TILE.mi_row_end - mi_row;
    COL8X8_REMAINING := TILE.mi_col_end - mi_col;
    bh, bw: s32 = ---;
    min_size: BLOCK_SIZE = 0;
    max_size: BLOCK_SIZE = 12;
    bs_hist: [13] s32;

    if LEFT_IN_IMAGE != 0 || ABOVE_IN_IMAGE != 0 || CM.frame_type != cast,no_check(u32) KEY_FRAME {
        min_size = 12;
        max_size = 0;

        if CM.frame_type != cast,no_check(u32) KEY_FRAME && CM.width == CM.last_width && CM.height == CM.last_height {
            prev_mi := *CM.prev_mi_grid_visible[mi_row * XD.mi_stride + mi_col];
            get_sb_partition_size_range(XD, prev_mi, *min_size, *max_size, bs_hist.data);
        }

        if LEFT_IN_IMAGE != 0 {
            left_sb64_mi := *mi[-((cast(s32) 1) << (((6 - 3)) & 31))];
            get_sb_partition_size_range(XD, left_sb64_mi, *min_size, *max_size, bs_hist.data);
        }

        if ABOVE_IN_IMAGE != 0 {
            above_sb64_mi := *mi[-XD.mi_stride * (cast(s32) 1) << (((6 - 3)) & 31)];
            get_sb_partition_size_range(XD, above_sb64_mi, *min_size, *max_size, bs_hist.data);
        }

        if cpi.sf.auto_min_max_partition_size == cast,no_check(u32) RELAXED_NEIGHBORING_MIN_MAX {
            min_size = MIN_PARTITION_SIZE[min_size];
            max_size = MAX_PARTITION_SIZE[max_size];
        }
    }

    max_size = find_partition_size(max_size, ROW8X8_REMAINING, COL8X8_REMAINING, *bh, *bw);

    if vp9_active_edge_sb(cpi, mi_row, mi_col) != 0 {
        min_size = 0;
    } else {
        min_size =
            cast,no_check(BLOCK_SIZE) ((ifx cast,no_check(s32) cpi.sf.rd_auto_partition_min_limit < min(cast,no_check(s32) min_size, cast,no_check(s32) max_size) then cast,no_check(s32) cpi.sf.rd_auto_partition_min_limit else min(cast,no_check(s32) min_size, cast,no_check(s32) max_size)));
    }

    if cpi.sf.use_square_partition_only != 0 && NEXT_SQUARE_SIZE[max_size] < min_size {
        min_size = NEXT_SQUARE_SIZE[max_size];
    }

    min_block_size.* = min_size;
    max_block_size.* = max_size;
}

find_partition_size :: (bsize: BLOCK_SIZE, rows_left: s32, cols_left: s32, bh: *s32, bw: *s32) -> BLOCK_SIZE {
    if rows_left <= 0 || cols_left <= 0 {
        return cast,no_check(BLOCK_SIZE) ((ifx bsize < 3 then cast,no_check(s32) bsize else 3));
    } else {
        while bsize > 0 {
            bh.* = cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize];
            bw.* = cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize];
            if bh.* <= rows_left && bw.* <= cols_left {
                break;
            }
            bsize = cast,no_check(BLOCK_SIZE) ((cast,no_check(s32) bsize) - 3);
        }
    }
    return bsize;
}

get_sb_partition_size_range :: (
    xd: *MACROBLOCKD,
    mi_8x8: **MODE_INFO,
    min_block_size: *BLOCK_SIZE,
    max_block_size: *BLOCK_SIZE,
    bs_hist: *s32
) {
    sb_width_in_blocks: s32 = (cast(s32) 1) << (((6 - 3)) & 31);
    sb_height_in_blocks: s32 = (cast(s32) 1) << (((6 - 3)) & 31);
    j: s32 = ---;
    index: s32 = 0;

    if 0 < sb_height_in_blocks {
        for i: 0..sb_height_in_blocks - 1 {
            j = 0;
            while j < sb_width_in_blocks {
                mi := mi_8x8[index + j];
                sb_type := cast,no_check(BLOCK_SIZE) ((ifx mi != null then cast,no_check(s32) mi.sb_type else 0));
                bs_hist[sb_type] += 1;
                min_block_size.* =
                    cast,no_check(BLOCK_SIZE) (min(cast,no_check(s32) min_block_size.*, cast,no_check(s32) sb_type));
                max_block_size.* =
                    cast,no_check(BLOCK_SIZE) (max(cast,no_check(s32) max_block_size.*, cast,no_check(s32) sb_type));
                j += 1;
            }
            index += xd.mi_stride;
        }
    }
}

wiener_var_segment :: (cpi: *VP9_COMP_in_vp9_encoder, bsize: BLOCK_SIZE, mi_row: s32, mi_col: s32) -> s32 {
    cm := *cpi.common;
    mb_row_start := mi_row >> 1;
    mb_col_start := mi_col >> 1;
    mb_row_end :=
        (ifx ((mi_row + cast(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize]) >> 1) < cm.mb_rows then (mi_row +
            cast(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize]) >> 1 else cm.mb_rows);
    mb_col_end :=
        (ifx ((mi_col + cast(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize]) >> 1) < cm.mb_cols then (mi_col +
            cast(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize]) >> 1 else cm.mb_cols);
    col: s32 = ---;
    wiener_variance: s64 = 0;
    segment_id: s32 = ---;
    seg_hist: [8] s8;
    max_count: s8 = 0;
    max_index: s8 = -1;

    row := mb_row_start;
    while row < mb_row_end {
        col = mb_col_start;
        while col < mb_col_end {
            wiener_variance = cpi.mb_wiener_variance[row * cm.mb_cols + col];
            segment_id =
                vp9_get_group_idx(
                    log_wiener_var(wiener_variance),
                    cpi.kmeans_boundary_ls.data,
                    cpi.kmeans_ctr_num
                );
            seg_hist[segment_id] += 1;
            col += 1;
        }
        row += 1;
    }

    idx: s32 = 0;
    while idx < cpi.kmeans_ctr_num {
        if seg_hist[idx] > max_count {
            max_count = seg_hist[idx];
            max_index = cast,no_check(s8) idx;
        }
        idx += 1;
    }

    segment_id = cast,no_check(s32) max_index;

    return segment_id;
}

log_wiener_var :: (wiener_variance: s64) -> float64 {
    return c_transpiler_math_log(1.0 + cast,no_check(float64) wiener_variance) / c_transpiler_math_log(2.0);
}

vp9_get_group_idx :: (value: float64, boundary_ls: *float64, k: s32) -> s32 {
    group_idx: s32 = 0;
    while c_transpiler_float_greater_equal(value, boundary_ls[group_idx]) {
        group_idx += 1;
        if group_idx == k - 1 {
            break;
        }
    }
    return group_idx;
}

get_rdmult_delta :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    bsize: BLOCK_SIZE,
    mi_row: s32,
    mi_col: s32,
    orig_rdmult: s32
) -> s32 {
    GF_GROUP_INDEX := cast,no_check(s32) cpi.twopass.gf_group.index;
    intra_cost: s64 = 0;
    mc_dep_cost: s64 = 0;
    mi_wide := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize];
    mi_high := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize];
    col: s32 = ---;

    dr: s32 = 0;

    if GF_GROUP_INDEX >= 2 * 25 {
        return orig_rdmult;
    }
    tpl_frame := cpi.tpl_stats.data + GF_GROUP_INDEX;

    if tpl_frame.is_valid == 0 {
        return orig_rdmult;
    }
    tpl_stats := tpl_frame.tpl_stats_ptr;
    tpl_stride := tpl_frame.stride;

    if cpi.twopass.gf_group.layer_depth[GF_GROUP_INDEX] > 1 {
        return orig_rdmult;
    }

    if cpi.ext_ratectrl.ready != 0 &&
        (cpi.ext_ratectrl.funcs.rc_type & cast,no_check(u32) RC_QP) != 0 &&
        cpi.ext_ratectrl.funcs.get_encodeframe_decision != null {
        sb_size := (cast(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[12]) * (cast(s32) 1) << 3;
        sb_stride := (cpi.common.width + sb_size - 1) / sb_size;
        sby := mi_row / 8;
        sbx := mi_col / 8;
        return cast,no_check(s32) ((cpi.sb_mul_scale[sby * sb_stride + sbx] * cast(s64) orig_rdmult) / 256);
    }

    row := mi_row;
    while row < mi_row + mi_high {
        col = mi_col;
        while col < mi_col + mi_wide {
            this_stats := *tpl_stats[row * tpl_stride + col];

            if row >= cpi.common.mi_rows || col >= cpi.common.mi_cols {
                col += 1;
                continue;
            }

            intra_cost += this_stats.intra_cost;
            mc_dep_cost += this_stats.mc_dep_cost;
            col += 1;
        }
        row += 1;
    }

    r0 := cpi.rd.r0;
    rk := (cast,no_check(float64) intra_cost) / mc_dep_cost;
    beta := r0 / rk;
    dr = vp9_get_adaptive_rdmult(cpi, beta);

    dr = clamp_in_vp9_encodeframe(dr, orig_rdmult * 1 / 2, orig_rdmult * 3 / 2);
    dr = ifx 1 > dr then 1 else dr;

    return dr;
}

rd_use_partition :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    td: *Thread_Data_in_vp9_encoder,
    tile_data: *Tile_Data_Enc,
    mi_8x8: **MODE_INFO,
    tp: **TOKENEXTRA_in_vp9_cx_iface,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE,
    rate: *s32,
    dist: *s64,
    do_recon: s32,
    pc_tree: *PC_TREE
) {
    CM: *VP9_COMMON = ---;
    TILE_INFO: *Tile_Info = ---;
    X: *MACROBLOCK = ---;
    XD: *MACROBLOCKD = ---;
    MIS: s32 = ---;
    BSL: s32 = ---;
    MI_STEP: s32 = ---;
    BSS: s32 = ---;
    i: s32 = ---;
    pl: s32 = ---;
    partition: PARTITION_TYPE = ---;
    subsize: BLOCK_SIZE = ---;
    l: [48] ENTROPY_CONTEXT = ---;
    a: [48] ENTROPY_CONTEXT = ---;
    sl: [8] PARTITION_CONTEXT = ---;
    sa: [8] PARTITION_CONTEXT = ---;
    last_part_rdc: RD_COST = ---;
    none_rdc: RD_COST = ---;
    chosen_rdc: RD_COST = ---;
    sub_subsize: BLOCK_SIZE = ---;
    splits_below: s32 = ---;
    bs_type: BLOCK_SIZE = ---;
    do_partition_search: s32 = ---;
    ctx: *PICK_MODE_CONTEXT = ---;
    jj: s32 = ---;
    ii: s32 = ---;
    this_mi: *MODE_INFO = ---;
    tmp_rdc: RD_COST = ---;
    hctx: *PICK_MODE_CONTEXT = ---;
    tmp_rdc_2: RD_COST = ---;
    vctx: *PICK_MODE_CONTEXT = ---;
    x_idx: s32 = ---;
    y_idx: s32 = ---;
    jj_2: s32 = ---;
    ii_2: s32 = ---;
    tmp_rdc_3: RD_COST = ---;
    split_subsize: BLOCK_SIZE = ---;
    x_idx_2: s32 = ---;
    y_idx_2: s32 = ---;
    tmp_rdc_4: RD_COST = ---;
    output_enabled: s32 = ---;
    code_block_to_execute: s64 = 169;
    while c_transpiler_dispatch := true {
        if code_block_to_execute < 0 break;
        if code_block_to_execute == {
            case 5; {
                rate.* = chosen_rdc.rate;
                dist.* = chosen_rdc.dist;
                break c_transpiler_dispatch;
            }
            case 8; {
                if do_recon != 0 {
                    output_enabled = cast(s32) (bsize == 12);
                    encode_sb(cpi, td, TILE_INFO, tp, mi_row, mi_col, output_enabled, bsize, pc_tree);
                    code_block_to_execute = 5;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 5;
                    continue c_transpiler_dispatch;
                }
            }
            case 11; {
                restore_context(X, mi_row, mi_col, a.data, l.data, sa.data, sl.data, bsize);
                if bsize == 12 {
                    code_block_to_execute = 8;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 8;
                    continue c_transpiler_dispatch;
                }
            }
            case 12; {
                assignment_14: RD_COST = none_rdc;
                ((*chosen_rdc).*) = assignment_14;
                code_block_to_execute = 11;
                continue c_transpiler_dispatch;
            }
            case 15; {
                if none_rdc.rdcost < chosen_rdc.rdcost {
                    if bsize >= 3 {
                        pc_tree.partitioning = cast,no_check(PARTITION_TYPE) PARTITION_NONE;
                        code_block_to_execute = 12;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 12;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 11;
                    continue c_transpiler_dispatch;
                }
            }
            case 16; {
                assignment_15: RD_COST = last_part_rdc;
                ((*chosen_rdc).*) = assignment_15;
                code_block_to_execute = 15;
                continue c_transpiler_dispatch;
            }
            case 20; {
                if last_part_rdc.rdcost < chosen_rdc.rdcost {
                    mi_8x8[0].sb_type = bsize;
                    if bsize >= 3 {
                        pc_tree.partitioning = partition;
                        code_block_to_execute = 16;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 16;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 15;
                    continue c_transpiler_dispatch;
                }
            }
            case 24; {
                pl = partition_plane_context_in_vp9_encodeframe(XD, mi_row, mi_col, bsize);
                if chosen_rdc.rate < 2147483647 {
                    chosen_rdc.rate += cpi.partition_cost[pl][PARTITION_SPLIT];
                    chosen_rdc.rdcost =
                        ((((cast,no_check(s64) chosen_rdc.rate) * cast(s64) X.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                            chosen_rdc.dist << ((X.rddiv) & 63);
                    code_block_to_execute = 20;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 20;
                    continue c_transpiler_dispatch;
                }
            }
            case 25; {
                if i < 4 {
                    code_block_to_execute = 44;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 24;
                    continue c_transpiler_dispatch;
                }
            }
            case 26; {
                i += 1;
                code_block_to_execute = 25;
                continue c_transpiler_dispatch;
            }
            case 28; {
                pl = partition_plane_context_in_vp9_encodeframe(XD, mi_row + y_idx_2, mi_col + x_idx_2, split_subsize);
                chosen_rdc.rate += cpi.partition_cost[pl][PARTITION_NONE];
                code_block_to_execute = 26;
                continue c_transpiler_dispatch;
            }
            case 44; {
                x_idx_2 = i & 1 * MI_STEP >> 1;
                y_idx_2 = i >> 1 * MI_STEP >> 1;
                if mi_row + y_idx_2 >= CM.mi_rows || mi_col + x_idx_2 >= CM.mi_cols {
                    code_block_to_execute = 26;
                    continue c_transpiler_dispatch;
                } else {
                    save_context(X, mi_row, mi_col, a.data, l.data, sa.data, sl.data, bsize);
                    pc_tree.u.split[i].partitioning = cast,no_check(PARTITION_TYPE) PARTITION_NONE;
                    rd_pick_sb_modes(
                        cpi,
                        tile_data,
                        X,
                        mi_row + y_idx_2,
                        mi_col + x_idx_2,
                        *tmp_rdc_4,
                        split_subsize,
                        *pc_tree.u.split[i].none,
                        2147483647,
                        9223372036854775807
                    );
                    restore_context(X, mi_row, mi_col, a.data, l.data, sa.data, sl.data, bsize);
                    if tmp_rdc_4.rate == 2147483647 || tmp_rdc_4.dist == 9223372036854775807 {
                        vp9_rd_cost_reset(*chosen_rdc);
                        code_block_to_execute = 24;
                        continue c_transpiler_dispatch;
                    } else {
                        chosen_rdc.rate += tmp_rdc_4.rate;
                        chosen_rdc.dist += tmp_rdc_4.dist;
                        if i != 3 {
                            encode_sb(
                                cpi,
                                td,
                                TILE_INFO,
                                tp,
                                mi_row + y_idx_2,
                                mi_col + x_idx_2,
                                0,
                                split_subsize,
                                pc_tree.u.split[i]
                            );
                            code_block_to_execute = 28;
                            continue c_transpiler_dispatch;
                        } else {
                            code_block_to_execute = 28;
                            continue c_transpiler_dispatch;
                        }
                    }
                }
            }
            case 51; {
                if do_partition_search != 0 && cpi.sf.adjust_partitioning_from_last_frame != 0 && cpi.sf.partition_search_type == cast,no_check(u32) SEARCH_PARTITION && partition != cast,no_check(u32) PARTITION_SPLIT && bsize > 3 && (mi_row + MI_STEP < CM.mi_rows || mi_row + MI_STEP >> 1 == CM.mi_rows) && (mi_col + MI_STEP < CM.mi_cols || mi_col + MI_STEP >> 1 == CM.mi_cols) {
                    split_subsize = get_subsize_in_vp9_encodeframe(bsize, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT);
                    chosen_rdc.rate = 0;
                    chosen_rdc.dist = 0;
                    restore_context(X, mi_row, mi_col, a.data, l.data, sa.data, sl.data, bsize);
                    pc_tree.partitioning = cast,no_check(PARTITION_TYPE) PARTITION_SPLIT;
                    i = 0;
                    code_block_to_execute = 25;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 20;
                    continue c_transpiler_dispatch;
                }
            }
            case 55; {
                pl = partition_plane_context_in_vp9_encodeframe(XD, mi_row, mi_col, bsize);
                if last_part_rdc.rate < 2147483647 {
                    last_part_rdc.rate += cpi.partition_cost[pl][partition];
                    last_part_rdc.rdcost =
                        ((((cast,no_check(s64) last_part_rdc.rate) * cast(s64) X.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                            last_part_rdc.dist << ((X.rddiv) & 63);
                    code_block_to_execute = 51;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 51;
                    continue c_transpiler_dispatch;
                }
            }
            case 57; {
                if i < 4 {
                    code_block_to_execute = 71;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 55;
                    continue c_transpiler_dispatch;
                }
            }
            case 58; {
                i += 1;
                code_block_to_execute = 57;
                continue c_transpiler_dispatch;
            }
            case 71; {
                x_idx = i & 1 * MI_STEP >> 1;
                y_idx = i >> 1 * MI_STEP >> 1;
                jj_2 = i >> 1;
                ii_2 = i & 0x1;
                if mi_row + y_idx >= CM.mi_rows || mi_col + x_idx >= CM.mi_cols {
                    code_block_to_execute = 58;
                    continue c_transpiler_dispatch;
                } else {
                    vp9_rd_cost_init(*tmp_rdc_3);
                    rd_use_partition(
                        cpi,
                        td,
                        tile_data,
                        mi_8x8 + jj_2 * BSS * MIS + ii_2 * BSS,
                        tp,
                        mi_row + y_idx,
                        mi_col + x_idx,
                        subsize,
                        *tmp_rdc_3.rate,
                        *tmp_rdc_3.dist,
                        cast(s32) (i != 3),
                        pc_tree.u.split[i]
                    );
                    if tmp_rdc_3.rate == 2147483647 || tmp_rdc_3.dist == 9223372036854775807 {
                        vp9_rd_cost_reset(*last_part_rdc);
                        code_block_to_execute = 55;
                        continue c_transpiler_dispatch;
                    } else {
                        last_part_rdc.rate += tmp_rdc_3.rate;
                        last_part_rdc.dist += tmp_rdc_3.dist;
                        code_block_to_execute = 58;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 79; {
                if bsize == 3 {
                    rd_pick_sb_modes(
                        cpi,
                        tile_data,
                        X,
                        mi_row,
                        mi_col,
                        *last_part_rdc,
                        subsize,
                        pc_tree.u.leaf_split[0],
                        2147483647,
                        9223372036854775807
                    );
                    code_block_to_execute = 55;
                    continue c_transpiler_dispatch;
                } else {
                    last_part_rdc.rate = 0;
                    last_part_rdc.dist = 0;
                    last_part_rdc.rdcost = 0;
                    i = 0;
                    code_block_to_execute = 57;
                    continue c_transpiler_dispatch;
                }
            }
            case 116; {
                c_transpiler_switch_value_116 := partition;
                if c_transpiler_switch_value_116 == {
                    case cast,no_check(u32) PARTITION_NONE; {
                        rd_pick_sb_modes(
                            cpi,
                            tile_data,
                            X,
                            mi_row,
                            mi_col,
                            *last_part_rdc,
                            bsize,
                            ctx,
                            2147483647,
                            9223372036854775807
                        );
                        code_block_to_execute = 55;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) PARTITION_HORZ; {
                        pc_tree.horizontal[0].skip_ref_frame_mask = 0;
                        rd_pick_sb_modes(
                            cpi,
                            tile_data,
                            X,
                            mi_row,
                            mi_col,
                            *last_part_rdc,
                            subsize,
                            pc_tree.horizontal.data + 0,
                            2147483647,
                            9223372036854775807
                        );
                        if last_part_rdc.rate != 2147483647 && bsize >= 3 && mi_row + MI_STEP >> 1 < CM.mi_rows {
                            hctx = pc_tree.horizontal.data + 0;
                            vp9_rd_cost_init(*tmp_rdc);
                            update_state(cpi, td, hctx, mi_row, mi_col, subsize, 0);
                            encode_superblock(cpi, td, tp, 0, mi_row, mi_col, subsize, hctx);
                            pc_tree.horizontal[1].skip_ref_frame_mask = 0;
                            rd_pick_sb_modes(
                                cpi,
                                tile_data,
                                X,
                                mi_row + MI_STEP >> 1,
                                mi_col,
                                *tmp_rdc,
                                subsize,
                                pc_tree.horizontal.data + 1,
                                2147483647,
                                9223372036854775807
                            );
                            if tmp_rdc.rate == 2147483647 || tmp_rdc.dist == 9223372036854775807 {
                                vp9_rd_cost_reset(*last_part_rdc);
                                code_block_to_execute = 55;
                                continue c_transpiler_dispatch;
                            } else {
                                last_part_rdc.rate += tmp_rdc.rate;
                                last_part_rdc.dist += tmp_rdc.dist;
                                last_part_rdc.rdcost += tmp_rdc.rdcost;
                                code_block_to_execute = 55;
                                continue c_transpiler_dispatch;
                            }
                        } else {
                            code_block_to_execute = 55;
                            continue c_transpiler_dispatch;
                        }
                    }
                    case cast,no_check(u32) PARTITION_VERT; {
                        pc_tree.vertical[0].skip_ref_frame_mask = 0;
                        rd_pick_sb_modes(
                            cpi,
                            tile_data,
                            X,
                            mi_row,
                            mi_col,
                            *last_part_rdc,
                            subsize,
                            pc_tree.vertical.data + 0,
                            2147483647,
                            9223372036854775807
                        );
                        if last_part_rdc.rate != 2147483647 && bsize >= 3 && mi_col + MI_STEP >> 1 < CM.mi_cols {
                            vctx = pc_tree.vertical.data + 0;
                            vp9_rd_cost_init(*tmp_rdc_2);
                            update_state(cpi, td, vctx, mi_row, mi_col, subsize, 0);
                            encode_superblock(cpi, td, tp, 0, mi_row, mi_col, subsize, vctx);
                            pc_tree.vertical[cast(s32) (bsize > 3)].skip_ref_frame_mask = 0;
                            rd_pick_sb_modes(
                                cpi,
                                tile_data,
                                X,
                                mi_row,
                                mi_col + MI_STEP >> 1,
                                *tmp_rdc_2,
                                subsize,
                                pc_tree.vertical.data + cast(s32) (bsize > 3),
                                2147483647,
                                9223372036854775807
                            );
                            if tmp_rdc_2.rate == 2147483647 || tmp_rdc_2.dist == 9223372036854775807 {
                                vp9_rd_cost_reset(*last_part_rdc);
                                code_block_to_execute = 55;
                                continue c_transpiler_dispatch;
                            } else {
                                last_part_rdc.rate += tmp_rdc_2.rate;
                                last_part_rdc.dist += tmp_rdc_2.dist;
                                last_part_rdc.rdcost += tmp_rdc_2.rdcost;
                                code_block_to_execute = 55;
                                continue c_transpiler_dispatch;
                            }
                        } else {
                            code_block_to_execute = 55;
                            continue c_transpiler_dispatch;
                        }
                    }
                    case; {
                        code_block_to_execute = 79;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 119; {
                restore_context(X, mi_row, mi_col, a.data, l.data, sa.data, sl.data, bsize);
                mi_8x8[0].sb_type = bs_type;
                pc_tree.partitioning = partition;
                code_block_to_execute = 116;
                continue c_transpiler_dispatch;
            }
            case 126; {
                if partition != cast,no_check(u32) PARTITION_NONE && splits_below == 0 && mi_row + MI_STEP >> 1 < CM.mi_rows && mi_col + MI_STEP >> 1 < CM.mi_cols {
                    pc_tree.partitioning = cast,no_check(PARTITION_TYPE) PARTITION_NONE;
                    rd_pick_sb_modes(
                        cpi,
                        tile_data,
                        X,
                        mi_row,
                        mi_col,
                        *none_rdc,
                        bsize,
                        ctx,
                        2147483647,
                        9223372036854775807
                    );
                    pl = partition_plane_context_in_vp9_encodeframe(XD, mi_row, mi_col, bsize);
                    if none_rdc.rate < 2147483647 {
                        none_rdc.rate += cpi.partition_cost[pl][PARTITION_NONE];
                        none_rdc.rdcost =
                            ((((cast,no_check(s64) none_rdc.rate) * cast(s64) X.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                                none_rdc.dist << ((X.rddiv) & 63);
                        code_block_to_execute = 119;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 119;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 116;
                    continue c_transpiler_dispatch;
                }
            }
            case 127; {
                if i < 4 {
                    code_block_to_execute = 132;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 126;
                    continue c_transpiler_dispatch;
                }
            }
            case 128; {
                i += 1;
                code_block_to_execute = 127;
                continue c_transpiler_dispatch;
            }
            case 132; {
                jj = i >> 1;
                ii = i & 0x1;
                this_mi = mi_8x8[jj * BSS * MIS + ii * BSS];
                if this_mi != null && this_mi.sb_type >= sub_subsize {
                    splits_below = 0;
                    code_block_to_execute = 128;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 128;
                    continue c_transpiler_dispatch;
                }
            }
            case 137; {
                if do_partition_search != 0 && cpi.sf.partition_search_type == cast,no_check(u32) SEARCH_PARTITION && cpi.sf.adjust_partitioning_from_last_frame != 0 {
                    if partition == cast,no_check(u32) PARTITION_SPLIT && subsize > 3 {
                        sub_subsize =
                            get_subsize_in_vp9_encodeframe(
                                subsize,
                                cast,no_check(PARTITION_TYPE) PARTITION_SPLIT
                            );
                        splits_below = 1;
                        i = 0;
                        code_block_to_execute = 127;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 126;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 116;
                    continue c_transpiler_dispatch;
                }
            }
            case 169; {
                CM = *cpi.common;
                TILE_INFO = *tile_data.tile_info;
                X = *td.mb;
                XD = *X.e_mbd;
                MIS = CM.mi_stride;
                BSL = cast,no_check(s32) B_WIDTH_LOG2_LOOKUP[bsize];
                MI_STEP = (cast(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[bsize]) / 2;
                BSS = (cast(s32) 1) << ((BSL) & 31) / 4;
                partition = cast,no_check(PARTITION_TYPE) PARTITION_NONE;
                sub_subsize = 0;
                splits_below = 0;
                bs_type = mi_8x8[0].sb_type;
                do_partition_search = 1;
                ctx = *pc_tree.none;
                if mi_row >= CM.mi_rows || mi_col >= CM.mi_cols {
                    return;
                } else {
                    vp9_rd_cost_reset(*last_part_rdc);
                    vp9_rd_cost_reset(*none_rdc);
                    vp9_rd_cost_reset(*chosen_rdc);
                    partition = (((cast(*[13] PARTITION_TYPE) *(PARTITION_LOOKUP))[BSL]).data)[bs_type];
                    subsize = get_subsize_in_vp9_encodeframe(bsize, partition);
                    pc_tree.partitioning = partition;
                    save_context(X, mi_row, mi_col, a.data, l.data, sa.data, sl.data, bsize);
                    if bsize == 6 && cpi.oxcf.aq_mode != cast,no_check(u32) NO_AQ {
                        set_offsets(cpi, TILE_INFO, X, mi_row, mi_col, bsize);
                        X.mb_energy = vp9_block_energy(cpi, X, bsize);
                        code_block_to_execute = 137;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 137;
                        continue c_transpiler_dispatch;
                    }
                }
            }
        }
        assert(false, tprint("invalid code block to execute %", code_block_to_execute));
        break;
    }
}

choose_partitioning :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    TILE: *Tile_Info,
    x: *MACROBLOCK,
    mi_row: s32,
    mi_col: s32
) -> s32 {
    CM := *cpi.common;
    xd := *x.e_mbd;
    j: s32 = ---;
    k: s32 = ---;
    m: s32 = ---;
    vt: V64x64 = ---;
    vt2: *V16x16 = null;
    force_split: [21] s32 = ---;

    max_var_32x32: s32 = 0;
    min_var_32x32: s32 = 2147483647;
    var_32x32: s32 = ---;
    avg_16x16: [4] s32 = ---;
    maxvar_16x16: [4] s32 = ---;
    minvar_16x16: [4] s32 = ---;

    noise_level := cast,no_check(NOISE_LEVEL) K_LOW;
    content_state: s32 = 0;

    d: *u8 = ---;

    dp: s32 = ---;
    compute_minmax_variance: s32 = 1;
    y_sad: u32 = U32_MAX;
    bsize: BLOCK_SIZE = 12;

    ref_frame_partition: MV_REFERENCE_FRAME = 1;
    pixels_wide: s32 = 64;
    pixels_high: s32 = 64;
    thresholds := s64.[ cpi.vbp_thresholds[0], cpi.vbp_thresholds[1], cpi.vbp_thresholds[2], cpi.vbp_thresholds[3] ];
    scene_change_detected :=
        cast(s32) (cpi.rc.high_source_sad != 0 ||
            cpi.use_svc != 0 && cpi.svc.high_source_sad_superframe != 0);
    force_64_split :=
        cast(s32) (scene_change_detected != 0 ||
            cpi.oxcf.content == cast,no_check(u32) VP9E_CONTENT_SCREEN && cpi.compute_source_sad_onepass != 0 && cpi.sf.use_source_sad != 0 && x.zero_temp_sad_source == 0);

    is_key_frame :=
        cast(s32) (frame_is_intra_only_in_vp9_encodeframe(CM) != 0 ||
            is_one_pass_svc_in_vp9_encodeframe(cpi) != 0 && cpi.svc.layer_context[cpi.svc.temporal_layer_id].is_key_frame != 0);

    if is_key_frame == 0 {
        if CM.frame_refs[1 - 1].sf.x_scale_fp == -1 || CM.frame_refs[1 - 1].sf.y_scale_fp == -1 {
            is_key_frame = 1;
        }
    }

    USE_4X4_PARTITION := cast(s32) (frame_is_intra_only_in_vp9_encodeframe(CM) != 0 && cpi.sf.nonrd_keyframe == 0);
    LOW_RES := cast(s32) (CM.width <= 352 && CM.height <= 288);
    variance4x4downsample: [16] s32 = ---;

    sb_offset := CM.mi_stride >> 3 * mi_row >> 3 + mi_col >> 3;

    if cpi.use_svc != 0 {
        REF := get_ref_frame_buffer_in_vp9_encodeframe(cpi, 1);
        if REF == null || REF.y_crop_height != CM.height || REF.y_crop_width != CM.width {
            is_key_frame = 1;
        }
    }

    set_offsets(cpi, TILE, x, mi_row, mi_col, 12);
    set_segment_index(cpi, x, mi_row, mi_col, 12, 0);
    segment_id := cast,no_check(s32) xd.mi[0].segment_id;

    if cpi.oxcf.speed >= 8 || cpi.use_svc != 0 && cpi.svc.non_reference_frame != 0 {
        compute_minmax_variance = 0;
    }

    fill_memory(x.variance_low.data, 0, x.variance_low.count);

    if cpi.sf.use_source_sad != 0 && is_key_frame == 0 {
        sb_offset2 := (CM.mi_cols + 7) >> 3 * mi_row >> 3 + mi_col >> 3;
        content_state = cast,no_check(s32) x.content_state_sb;
        x.skip_low_source_sad =
            cast(u8) (content_state == K_LOW_SAD_LOW_SUMDIFF ||
                content_state == K_LOW_SAD_HIGH_SUMDIFF);
        x.lowvar_highsumdiff = cast(u8) (content_state == K_LOW_VAR_HIGH_SUMDIFF);
        if cpi.content_state_sb_fd != null {
            x.last_sb_high_content = cpi.content_state_sb_fd[sb_offset2];
        }

        if cpi.sf.svc_use_lowres_part != 0 &&
            cpi.svc.spatial_layer_id == cpi.svc.number_spatial_layers - 1 &&
            cpi.svc.prev_partition_svc != null &&
            content_state != K_VERY_HIGH_SAD {
            if scale_partitioning_svc(cpi, x, xd, 12, mi_row >> 1, mi_col >> 1, mi_row, mi_col) == 0 {
                if cpi.sf.copy_partition_flag != 0 {
                    update_prev_partition(cpi, x, segment_id, mi_row, mi_col, sb_offset);
                }
                return 0;
            }
        }

        if x.skip_low_source_sad != 0 &&
            cpi.sf.copy_partition_flag != 0 &&
            force_64_split == 0 &&
            copy_partitioning(cpi, x, xd, mi_row, mi_col, segment_id, sb_offset) != 0 {
            x.sb_use_mv_part = 1;
            if cpi.sf.svc_use_lowres_part != 0 && cpi.svc.spatial_layer_id == cpi.svc.number_spatial_layers - 2 {
                update_partition_svc(cpi, 12, mi_row, mi_col);
            }
            return 0;
        }
    }

    if cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ &&
        CM.seg.enabled != 0 &&
        cyclic_refresh_segment_id_boosted_in_vp9_encodeframe(segment_id) != 0 {
        q := vp9_get_qindex(*CM.seg, segment_id, CM.base_qindex);
        set_vbp_thresholds(cpi, thresholds.data, q, content_state);
    } else {
        set_vbp_thresholds(cpi, thresholds.data, CM.base_qindex, content_state);
    }

    if cpi.oxcf.content == cast,no_check(u32) VP9E_CONTENT_SCREEN && cpi.svc.spatial_layer_id == 0 && force_64_split != 0 {
        thresholds[1] = (3 * thresholds[1]) >> 2;
    }

    threshold_4x4avg := (ifx cpi.oxcf.speed < 8 then thresholds[1] << 1 else 9223372036854775807);

    if xd.mb_to_right_edge < 0 {
        pixels_wide += xd.mb_to_right_edge >> 3;
    }
    if xd.mb_to_bottom_edge < 0 {
        pixels_high += xd.mb_to_bottom_edge >> 3;
    }

    s := x.plane[0].src.buf;
    sp := x.plane[0].src.stride;

    force_split[0] = force_64_split;

    if is_key_frame == 0 {
        mi := xd.mi[0];
        yv12 := get_ref_frame_buffer_in_vp9_encodeframe(cpi, 1);

        yv12_g: *YV12_BUFFER_CONFIG = null;
        y_sad_g: u32 = ---;
        bsize =
            cast,no_check(BLOCK_SIZE) (9 + (cast(s32) (mi_col + 4 < CM.mi_cols)) * 2 +
                cast(s32) (mi_row + 4 < CM.mi_rows));

        if !(is_one_pass_svc_in_vp9_encodeframe(cpi) != 0 && cpi.svc.spatial_layer_id != 0) ||
            cpi.svc.use_gf_temporal_ref_current_layer != 0 {
            yv12_g = get_ref_frame_buffer_in_vp9_encodeframe(cpi, 2);
        }

        if cpi.oxcf.speed < 8 && yv12_g != null && yv12_g != yv12 && cpi.ref_frame_flags & cast,no_check(s32) (VP9_GOLD_FLAG) != 0 {
            vp9_setup_pre_planes(xd, 0, yv12_g, mi_row, mi_col, *CM.frame_refs[2 - 1].sf);
            y_sad_g =
                cpi.fn_ptr[bsize].sdf(
                    x.plane[0].src.buf,
                    x.plane[0].src.stride,
                    xd.plane[0].pre[0].buf,
                    xd.plane[0].pre[0].stride
                );
        } else {
            y_sad_g = U32_MAX;
        }

        if cpi.oxcf.lag_in_frames > 0 && cpi.oxcf.rc_mode == cast,no_check(u32) VBR && cpi.rc.is_src_frame_alt_ref != 0 {
            yv12 = get_ref_frame_buffer_in_vp9_encodeframe(cpi, 3);
            vp9_setup_pre_planes(xd, 0, yv12, mi_row, mi_col, *CM.frame_refs[3 - 1].sf);
            mi.ref_frame[0] = 3;
            y_sad_g = U32_MAX;
        } else {
            vp9_setup_pre_planes(xd, 0, yv12, mi_row, mi_col, *CM.frame_refs[1 - 1].sf);
            mi.ref_frame[0] = 1;
        }
        mi.ref_frame[1] = -1;
        mi.sb_type = 12;
        mi.mv[0].as_int = 0;
        mi.interp_filter = 3;

        if cpi.oxcf.speed >= 8 && LOW_RES == 0 && x.content_state_sb != cast,no_check(u8) K_VERY_HIGH_SAD {
            y_sad =
                cpi.fn_ptr[bsize].sdf(
                    x.plane[0].src.buf,
                    x.plane[0].src.stride,
                    xd.plane[0].pre[0].buf,
                    xd.plane[0].pre[0].stride
                );
        } else {
            DUMMY_MV: MV;
            y_sad = vp9_int_pro_motion_estimation(cpi, x, bsize, mi_row, mi_col, *DUMMY_MV);
            x.sb_use_mv_part = 1;
            x.sb_mvcol_part = cast,no_check(s32) mi.mv[0].as_mv.col;
            x.sb_mvrow_part = cast,no_check(s32) mi.mv[0].as_mv.row;
            if cpi.oxcf.content == cast,no_check(u32) VP9E_CONTENT_SCREEN &&
                cpi.svc.spatial_layer_id == cpi.svc.first_spatial_layer_to_encode &&
                cpi.svc.high_num_blocks_with_motion != 0 &&
                x.zero_temp_sad_source == 0 &&
                CM.width > 640 &&
                CM.height > 480 {
                if (absolute_value(x.sb_mvrow_part) >= 48 && absolute_value(x.sb_mvcol_part) <= 8 ||
                    absolute_value(x.sb_mvcol_part) >= 48 && absolute_value(x.sb_mvrow_part) <= 8) &&
                    y_sad < 100000 {
                    compute_minmax_variance = 0;
                    thresholds[2] = 9223372036854775807;
                }
            }
        }

        y_sad_last := y_sad;

        y_sad_thr := (ifx cpi.sf.short_circuit_low_temp_var != 0 then (y_sad * 7) >> 3 else y_sad);
        if y_sad_g < y_sad_thr {
            vp9_setup_pre_planes(xd, 0, yv12_g, mi_row, mi_col, *CM.frame_refs[2 - 1].sf);
            mi.ref_frame[0] = 2;
            mi.mv[0].as_int = 0;
            y_sad = y_sad_g;
            ref_frame_partition = 2;
        } else {
            x.pred_mv[1] = mi.mv[0].as_mv;
            ref_frame_partition = 1;
        }

        set_ref_ptrs_in_vp9_encodeframe(CM, xd, mi.ref_frame[0], mi.ref_frame[1]);
        vp9_build_inter_predictors_sb(xd, mi_row, mi_col, 12);

        if cpi.use_skin_detection != 0 {
            x.sb_is_skin = cast,no_check(u8) skin_sb_split(cpi, LOW_RES, mi_row, mi_col, force_split.data);
        }

        d = xd.plane[0].dst.buf;
        dp = xd.plane[0].dst.stride;

        if segment_id == 0 && cast,no_check(s64) y_sad < cpi.vbp_threshold_sad {
            BLOCK_WIDTH := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[12];
            BLOCK_HEIGHT := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[12];
            if mi_col + BLOCK_WIDTH / 2 < CM.mi_cols && mi_row + BLOCK_HEIGHT / 2 < CM.mi_rows {
                set_block_size(cpi, x, xd, mi_row, mi_col, 12);
                x.variance_low[0] = 1;
                chroma_check(cpi, x, cast,no_check(s32) bsize, y_sad, is_key_frame, scene_change_detected);
                if cpi.sf.svc_use_lowres_part != 0 && cpi.svc.spatial_layer_id == cpi.svc.number_spatial_layers - 2 {
                    update_partition_svc(cpi, 12, mi_row, mi_col);
                }
                if cpi.sf.copy_partition_flag != 0 {
                    update_prev_partition(cpi, x, segment_id, mi_row, mi_col, sb_offset);
                }
                return 0;
            }
        }

        if cpi.sf.copy_partition_flag != 0 &&
            cast,no_check(s64) y_sad_last < cpi.vbp_threshold_copy &&
            copy_partitioning(cpi, x, xd, mi_row, mi_col, segment_id, sb_offset) != 0 {
            chroma_check(cpi, x, cast,no_check(s32) bsize, y_sad, is_key_frame, scene_change_detected);
            if cpi.sf.svc_use_lowres_part != 0 && cpi.svc.spatial_layer_id == cpi.svc.number_spatial_layers - 2 {
                update_partition_svc(cpi, 12, mi_row, mi_col);
            }
            return 0;
        }
    } else {
        d = VP9_VAR_OFFS.data;
        dp = 0;
    }

    if LOW_RES != 0 && threshold_4x4avg < 9223372036854775807 {
        vt2 = cast(*V16x16) calloc_2(16, size_of(V16x16));

        if vt2 == null {
            internal_error(*CM.error, cast,no_check(Codec_Err_T) CODEC_MEM_ERROR, c_string("Failed to allocate vt2"));
        }
    }

    for i: 0..cast(s32) 4 - 1 {
        X32_IDX := i & 1 << 5;
        Y32_IDX := i >> 1 << 5;
        I2 := i << 2;
        force_split[i + 1] = 0;
        avg_16x16[i] = 0;
        maxvar_16x16[i] = 0;
        minvar_16x16[i] = 2147483647;
        j = 0;
        while j < 4 {
            X16_IDX := X32_IDX + j & 1 << 4;
            Y16_IDX := Y32_IDX + j >> 1 << 4;
            SPLIT_INDEX := 5 + I2 + j;
            vst := vt.split[i].split.data + j;
            force_split[SPLIT_INDEX] = 0;
            variance4x4downsample[I2 + j] = 0;
            if is_key_frame == 0 {
                fill_variance_8x8avg(s, sp, d, dp, X16_IDX, Y16_IDX, vst, pixels_wide, pixels_high, is_key_frame);
                fill_variance_tree(vt.split[i].split.data + j, 6);
                get_variance(*vt.split[i].split[j].part_variances.none);
                avg_16x16[i] += vt.split[i].split[j].part_variances.none.variance;
                if vt.split[i].split[j].part_variances.none.variance < minvar_16x16[i] {
                    minvar_16x16[i] = vt.split[i].split[j].part_variances.none.variance;
                }
                if vt.split[i].split[j].part_variances.none.variance > maxvar_16x16[i] {
                    maxvar_16x16[i] = vt.split[i].split[j].part_variances.none.variance;
                }
                if cast,no_check(s64) vt.split[i].split[j].part_variances.none.variance > thresholds[2] {
                    force_split[SPLIT_INDEX] = 1;
                    force_split[i + 1] = 1;
                    force_split[0] = 1;
                } else if compute_minmax_variance != 0 &&
                    cast,no_check(s64) vt.split[i].split[j].part_variances.none.variance > thresholds[1] &&
                    cyclic_refresh_segment_id_boosted_in_vp9_encodeframe(segment_id) == 0 {
                    minmax := compute_minmax_8x8(s, sp, d, dp, X16_IDX, Y16_IDX, pixels_wide, pixels_high);
                    thresh_minmax := cast,no_check(s32) cpi.vbp_threshold_minmax;
                    if x.content_state_sb == cast,no_check(u8) K_VERY_HIGH_SAD {
                        thresh_minmax = thresh_minmax << 1;
                    }
                    if minmax > thresh_minmax {
                        force_split[SPLIT_INDEX] = 1;
                        force_split[i + 1] = 1;
                        force_split[0] = 1;
                    }
                }
            }
            if is_key_frame != 0 ||
                LOW_RES != 0 && cast,no_check(s64) vt.split[i].split[j].part_variances.none.variance > threshold_4x4avg {
                force_split[SPLIT_INDEX] = 0;

                variance4x4downsample[I2 + j] = 1;
                k = 0;
                while k < 4 {
                    x8_idx := X16_IDX + k & 1 << 3;
                    y8_idx := Y16_IDX + k >> 1 << 3;
                    vst2 := (ifx is_key_frame != 0 then vst.split.data + k else vt2[I2 + j].split.data + k);
                    fill_variance_4x4avg(s, sp, d, dp, x8_idx, y8_idx, vst2, pixels_wide, pixels_high, is_key_frame);
                    k += 1;
                }
            }
            j += 1;
        }
    }
    if cpi.noise_estimate.enabled != 0 {
        noise_level = vp9_noise_estimate_extract_level(*cpi.noise_estimate);
    }

    avg_32x32: s32 = 0;
    for i: 0..cast(s32) 4 - 1 {
        I2 := i << 2;
        j = 0;
        while j < 4 {
            if variance4x4downsample[I2 + j] == 1 {
                vtemp := (ifx is_key_frame == 0 then *vt2[I2 + j] else vt.split[i].split.data + j);
                m = 0;
                while m < 4 {
                    fill_variance_tree(vtemp.split.data + m, 3);
                    m += 1;
                }
                fill_variance_tree(vtemp, 6);

                get_variance(*vtemp.part_variances.none);
                if cast,no_check(s64) vtemp.part_variances.none.variance > thresholds[2] {
                    force_split[5 + I2 + j] = 1;
                    force_split[i + 1] = 1;
                    force_split[0] = 1;
                }
            }
            j += 1;
        }
        fill_variance_tree(vt.split.data + i, 9);

        if force_split[i + 1] == 0 {
            get_variance(*vt.split[i].part_variances.none);
            var_32x32 = vt.split[i].part_variances.none.variance;
            max_var_32x32 = max(var_32x32, max_var_32x32);
            min_var_32x32 = min(var_32x32, min_var_32x32);
            if cast,no_check(s64) vt.split[i].part_variances.none.variance > thresholds[1] ||
                is_key_frame == 0 &&
                    cast,no_check(s64) vt.split[i].part_variances.none.variance > thresholds[1] >> 1 &&
                    vt.split[i].part_variances.none.variance > avg_16x16[i] >> 1 {
                force_split[i + 1] = 1;
                force_split[0] = 1;
            } else if is_key_frame == 0 &&
                noise_level < cast,no_check(u32) K_LOW &&
                CM.height <= 360 &&
                cast,no_check(s64) (maxvar_16x16[i] - minvar_16x16[i]) > thresholds[1] >> 1 &&
                cast,no_check(s64) maxvar_16x16[i] > thresholds[1] {
                force_split[i + 1] = 1;
                force_split[0] = 1;
            }
            avg_32x32 += var_32x32;
        }
    }
    if force_split[0] == 0 {
        fill_variance_tree(*vt, 12);
        get_variance(*vt.part_variances.none);

        if is_key_frame == 0 &&
            noise_level >= cast,no_check(u32) K_MEDIUM &&
            vt.part_variances.none.variance > (9 * avg_32x32) >> 5 {
            force_split[0] = 1;
        } else if is_key_frame == 0 &&
            noise_level < cast,no_check(u32) K_MEDIUM &&
            cast,no_check(s64) (max_var_32x32 - min_var_32x32) > 3 * thresholds[0] >> 3 &&
            cast,no_check(s64) max_var_32x32 > thresholds[0] >> 1 {
            force_split[0] = 1;
        }
    }

    if mi_col + 8 > CM.mi_cols ||
        mi_row + 8 > CM.mi_rows ||
        set_vt_partitioning(cpi, x, xd, *vt, 12, mi_row, mi_col, thresholds[0], 6, force_split[0]) == 0 {
        for i: 0..cast(s32) 4 - 1 {
            X32_IDX := i & 1 << 2;
            Y32_IDX := i >> 1 << 2;
            I2 := i << 2;
            if set_vt_partitioning(
                cpi,
                x,
                xd,
                vt.split.data + i,
                9,
                mi_row + Y32_IDX,
                mi_col + X32_IDX,
                thresholds[1],
                6,
                force_split[i + 1]
            ) == 0 {
                j = 0;
                while j < 4 {
                    X16_IDX := j & 1 << 1;
                    Y16_IDX := j >> 1 << 1;

                    vtemp :=
                        (ifx is_key_frame == 0 &&
                            variance4x4downsample[I2 + j] == 1 then *vt2[I2 + j] else vt.split[i].split.data + j);
                    if set_vt_partitioning(
                        cpi,
                        x,
                        xd,
                        vtemp,
                        6,
                        mi_row + Y32_IDX + Y16_IDX,
                        mi_col + X32_IDX + X16_IDX,
                        thresholds[2],
                        cpi.vbp_bsize_min,
                        force_split[5 + I2 + j]
                    ) == 0 {
                        k = 0;
                        while k < 4 {
                            X8_IDX := k & 1;
                            Y8_IDX := k >> 1;
                            if USE_4X4_PARTITION != 0 {
                                if set_vt_partitioning(
                                    cpi,
                                    x,
                                    xd,
                                    vtemp.split.data + k,
                                    3,
                                    mi_row + Y32_IDX + Y16_IDX + Y8_IDX,
                                    mi_col + X32_IDX + X16_IDX + X8_IDX,
                                    thresholds[3],
                                    3,
                                    0
                                ) == 0 {
                                    set_block_size(
                                        cpi,
                                        x,
                                        xd,
                                        mi_row + Y32_IDX + Y16_IDX + Y8_IDX,
                                        mi_col + X32_IDX + X16_IDX + X8_IDX,
                                        0
                                    );
                                }
                            } else {
                                set_block_size(
                                    cpi,
                                    x,
                                    xd,
                                    mi_row + Y32_IDX + Y16_IDX + Y8_IDX,
                                    mi_col + X32_IDX + X16_IDX + X8_IDX,
                                    3
                                );
                            }
                            k += 1;
                        }
                    }
                    j += 1;
                }
            }
        }
    }

    if frame_is_intra_only_in_vp9_encodeframe(CM) == 0 && cpi.sf.copy_partition_flag != 0 {
        update_prev_partition(cpi, x, segment_id, mi_row, mi_col, sb_offset);
    }

    if frame_is_intra_only_in_vp9_encodeframe(CM) == 0 &&
        cpi.sf.svc_use_lowres_part != 0 &&
        cpi.svc.spatial_layer_id == cpi.svc.number_spatial_layers - 2 {
        update_partition_svc(cpi, 12, mi_row, mi_col);
    }

    if cpi.sf.short_circuit_low_temp_var != 0 {
        set_low_temp_var_flag(cpi, x, xd, *vt, thresholds.data, ref_frame_partition, mi_col, mi_row);
    }

    chroma_check(cpi, x, cast,no_check(s32) bsize, y_sad, is_key_frame, scene_change_detected);
    if vt2 != null {
        deallocate_memory(cast(*void) vt2);
    }
    return 0;
}

chroma_check :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    bsize: s32,
    y_sad: u32,
    is_key_frame: s32,
    scene_change_detected: s32
) {
    xd := *x.e_mbd;
    shift: s32 = 2;

    if is_key_frame != 0 {
        return;
    }

    if cpi.oxcf.speed > 8 {
        if cast,no_check(s64) y_sad > cpi.vbp_thresholds[1] &&
            (cpi.noise_estimate.enabled == 0 || vp9_noise_estimate_extract_level(*cpi.noise_estimate) < cast,no_check(u32) K_MEDIUM) {
            return;
        }
    }

    if cpi.oxcf.content == cast,no_check(u32) VP9E_CONTENT_SCREEN && scene_change_detected != 0 {
        shift = 5;
    }

    if 1 <= 2 {
        for i: 1..cast(s32) 2 {
            uv_sad: u32 = U32_MAX;
            p := x.plane.data + i;
            pd := xd.plane.data + i;
            BS := get_plane_block_size_in_vp9_encodeframe(cast,no_check(BLOCK_SIZE) bsize, pd);

            if BS != 13 {
                uv_sad = cpi.fn_ptr[BS].sdf(p.src.buf, p.src.stride, pd.dst.buf, pd.dst.stride);
            }

            x.color_sensitivity[i - 1] = cast(u8) (uv_sad > y_sad >> ((shift) & 31));
        }
    }
}

set_low_temp_var_flag :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    xd: *MACROBLOCKD,
    vt: *V64x64,
    thresholds: *s64,
    ref_frame_partition: MV_REFERENCE_FRAME,
    mi_col: s32,
    mi_row: s32
) {
    j: s32 = ---;
    CM := *cpi.common;
    MV_THR := (ifx CM.width > 640 then cast(s32) 8 else 4);

    if ref_frame_partition == 1 &&
        (cpi.sf.short_circuit_low_temp_var == 1 ||
            cast,no_check(s32) xd.mi[0].mv[0].as_mv.col < MV_THR &&
                cast,no_check(s32) xd.mi[0].mv[0].as_mv.col > -MV_THR &&
                cast,no_check(s32) xd.mi[0].mv[0].as_mv.row < MV_THR &&
                cast,no_check(s32) xd.mi[0].mv[0].as_mv.row > -MV_THR) {
        if xd.mi[0].sb_type == 12 {
            if cast,no_check(s64) vt.part_variances.none.variance < thresholds[0] >> 1 {
                x.variance_low[0] = 1;
            }
        } else if xd.mi[0].sb_type == 11 {
            for i: 0..cast(s32) 2 - 1 {
                if cast,no_check(s64) vt.part_variances.horz[i].variance < thresholds[0] >> 2 {
                    x.variance_low[i + 1] = 1;
                }
            }
        } else if xd.mi[0].sb_type == 10 {
            for i: 0..cast(s32) 2 - 1 {
                if cast,no_check(s64) vt.part_variances.vert[i].variance < thresholds[0] >> 2 {
                    x.variance_low[i + 3] = 1;
                }
            }
        } else {
            for i: 0..cast(s32) 4 - 1 {
                IDX :=
                    [2] s32.[
                        s32.[ 0, 0 ],
                        s32.[ 0, 4 ],
                        s32.[ 4, 0 ],
                        s32.[ 4, 4 ]
                    ];
                IDX_STR := CM.mi_stride * (mi_row + IDX[i][0]) + mi_col + IDX[i][1];
                this_mi := CM.mi_grid_visible + IDX_STR;

                if CM.mi_cols <= mi_col + IDX[i][1] || CM.mi_rows <= mi_row + IDX[i][0] {
                    continue;
                }

                if this_mi.*.sb_type == 9 {
                    threshold_32x32 :=
                        (ifx cpi.sf.short_circuit_low_temp_var == 1 ||
                            cpi.sf.short_circuit_low_temp_var == 3 then (5 * thresholds[1]) >> 3 else thresholds[1] >> 1);
                    if cast,no_check(s64) vt.split[i].part_variances.none.variance < threshold_32x32 {
                        x.variance_low[i + 5] = 1;
                    }
                } else if cpi.sf.short_circuit_low_temp_var >= 2 {
                    if this_mi.*.sb_type == 6 || this_mi.*.sb_type == 8 || this_mi.*.sb_type == 7 {
                        j = 0;
                        while j < 4 {
                            if cast,no_check(s64) vt.split[i].split[j].part_variances.none.variance < thresholds[2] >> 8 {
                                x.variance_low[i << 2 + j + 9] = 1;
                            }
                            j += 1;
                        }
                    }
                }
            }
        }
    }
}

update_partition_svc :: (cpi: *VP9_COMP_in_vp9_encoder, bsize: BLOCK_SIZE, mi_row: s32, mi_col: s32) {
    CM := *cpi.common;
    prev_part := cpi.svc.prev_partition_svc;
    start_pos := mi_row * CM.mi_stride + mi_col;
    BSL := cast,no_check(s32) B_WIDTH_LOG2_LOOKUP[bsize];
    BS := (cast(s32) 1) << ((BSL) & 31) >> 2;

    mi: *MODE_INFO = null;
    xx_, yy: s32 = ---;

    if mi_row >= CM.mi_rows || mi_col >= CM.mi_cols {
        return;
    }

    mi = CM.mi_grid_visible[start_pos];
    partition := (((cast(*[13] PARTITION_TYPE) *(PARTITION_LOOKUP))[BSL]).data)[mi.sb_type];
    subsize := get_subsize_in_vp9_encodeframe(bsize, partition);
    if subsize < 3 {
        prev_part[start_pos] = bsize;
    } else {
        if partition == {
            case cast,no_check(u32) PARTITION_NONE;
                prev_part[start_pos] = bsize;
                if bsize == 12 {
                    xx_ = 0;
                    while xx_ < 8 {
                        yy = 0;
                        while yy < 8 {
                            if mi_row + xx_ < CM.mi_rows && mi_col + yy < CM.mi_cols {
                                prev_part[start_pos + xx_ * CM.mi_stride + yy] = bsize;
                            }
                            yy += 4;
                        }
                        xx_ += 4;
                    }
                }
            case cast,no_check(u32) PARTITION_HORZ;
                prev_part[start_pos] = subsize;
                if mi_row + BS < CM.mi_rows {
                    prev_part[start_pos + BS * CM.mi_stride] = subsize;
                }
            case cast,no_check(u32) PARTITION_VERT;
                prev_part[start_pos] = subsize;
                if mi_col + BS < CM.mi_cols {
                    prev_part[start_pos + BS] = subsize;
                }
            case;
                update_partition_svc(cpi, subsize, mi_row, mi_col);
                update_partition_svc(cpi, subsize, mi_row + BS, mi_col);
                update_partition_svc(cpi, subsize, mi_row, mi_col + BS);
                update_partition_svc(cpi, subsize, mi_row + BS, mi_col + BS);
        }
    }
}

update_prev_partition :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    segment_id: s32,
    mi_row: s32,
    mi_col: s32,
    sb_offset: s32
) {
    update_prev_partition_helper(cpi, 12, mi_row, mi_col);
    cpi.prev_segment_id[sb_offset] = cast,no_check(s8) segment_id;
    copy_memory(*cpi.prev_variance_low[sb_offset * 25], x.variance_low.data, x.variance_low.count);

    cpi.copied_frame_cnt[sb_offset] = 0;
}

update_prev_partition_helper :: (cpi: *VP9_COMP_in_vp9_encoder, bsize: BLOCK_SIZE, mi_row: s32, mi_col: s32) {
    CM := *cpi.common;
    prev_part := cpi.prev_partition;
    start_pos := mi_row * CM.mi_stride + mi_col;
    BSL := cast,no_check(s32) B_WIDTH_LOG2_LOOKUP[bsize];
    BS := (cast(s32) 1) << ((BSL) & 31) >> 2;

    mi: *MODE_INFO = null;

    if mi_row >= CM.mi_rows || mi_col >= CM.mi_cols {
        return;
    }

    mi = CM.mi_grid_visible[start_pos];
    partition := (((cast(*[13] PARTITION_TYPE) *(PARTITION_LOOKUP))[BSL]).data)[mi.sb_type];
    subsize := get_subsize_in_vp9_encodeframe(bsize, partition);
    if subsize < 3 {
        prev_part[start_pos] = bsize;
    } else {
        if partition == {
            case cast,no_check(u32) PARTITION_NONE;
                prev_part[start_pos] = bsize;
            case cast,no_check(u32) PARTITION_HORZ;
                prev_part[start_pos] = subsize;
                if mi_row + BS < CM.mi_rows {
                    prev_part[start_pos + BS * CM.mi_stride] = subsize;
                }
            case cast,no_check(u32) PARTITION_VERT;
                prev_part[start_pos] = subsize;
                if mi_col + BS < CM.mi_cols {
                    prev_part[start_pos + BS] = subsize;
                }
            case;
                update_prev_partition_helper(cpi, subsize, mi_row, mi_col);
                update_prev_partition_helper(cpi, subsize, mi_row + BS, mi_col);
                update_prev_partition_helper(cpi, subsize, mi_row, mi_col + BS);
                update_prev_partition_helper(cpi, subsize, mi_row + BS, mi_col + BS);
        }
    }
}

set_block_size :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    X: *MACROBLOCK,
    XD: *MACROBLOCKD,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE
) {
    if CPI.common.mi_cols > mi_col && CPI.common.mi_rows > mi_row {
        set_mode_info_offsets(*CPI.common, X, XD, mi_row, mi_col);
        XD.mi[0].sb_type = bsize;
    }
}

set_vt_partitioning :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    X: *MACROBLOCK,
    XD: *MACROBLOCKD,
    data: *void,
    bsize: BLOCK_SIZE,
    mi_row: s32,
    mi_col: s32,
    threshold: s64,
    bsize_min: BLOCK_SIZE,
    force_split: s32
) -> s32 {
    CM := *cpi.common;
    vt: Variance_Node = ---;
    BLOCK_WIDTH := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize];
    BLOCK_HEIGHT := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize];

    tree_to_node(data, bsize, *vt);

    if force_split == 1 {
        return 0;
    }

    if bsize == bsize_min {
        if frame_is_intra_only_in_vp9_encodeframe(CM) != 0 {
            get_variance(*vt.part_variances.none);
        }
        if mi_col + BLOCK_WIDTH / 2 < CM.mi_cols &&
            mi_row + BLOCK_HEIGHT / 2 < CM.mi_rows &&
            cast,no_check(s64) vt.part_variances.none.variance < threshold {
            set_block_size(cpi, X, XD, mi_row, mi_col, bsize);
            return 1;
        }
        return 0;
    } else if bsize > bsize_min {
        if frame_is_intra_only_in_vp9_encodeframe(CM) != 0 {
            get_variance(*vt.part_variances.none);
        }

        if frame_is_intra_only_in_vp9_encodeframe(CM) != 0 &&
            (bsize > 9 || cast,no_check(s64) vt.part_variances.none.variance > threshold << 4) {
            return 0;
        }

        if mi_col + BLOCK_WIDTH / 2 < CM.mi_cols &&
            mi_row + BLOCK_HEIGHT / 2 < CM.mi_rows &&
            cast,no_check(s64) vt.part_variances.none.variance < threshold {
            set_block_size(cpi, X, XD, mi_row, mi_col, bsize);
            return 1;
        }

        if mi_row + BLOCK_HEIGHT / 2 < CM.mi_rows {
            subsize := get_subsize_in_vp9_encodeframe(bsize, cast,no_check(PARTITION_TYPE) PARTITION_VERT);
            get_variance(vt.part_variances.vert.data + 0);
            get_variance(vt.part_variances.vert.data + 1);
            if cast,no_check(s64) vt.part_variances.vert[0].variance < threshold &&
                cast,no_check(s64) vt.part_variances.vert[1].variance < threshold &&
                get_plane_block_size_in_vp9_encodeframe(subsize, XD.plane.data + 1) < 13 {
                set_block_size(cpi, X, XD, mi_row, mi_col, subsize);
                set_block_size(cpi, X, XD, mi_row, mi_col + BLOCK_WIDTH / 2, subsize);
                return 1;
            }
        }

        if mi_col + BLOCK_WIDTH / 2 < CM.mi_cols {
            subsize := get_subsize_in_vp9_encodeframe(bsize, cast,no_check(PARTITION_TYPE) PARTITION_HORZ);
            get_variance(vt.part_variances.horz.data + 0);
            get_variance(vt.part_variances.horz.data + 1);
            if cast,no_check(s64) vt.part_variances.horz[0].variance < threshold &&
                cast,no_check(s64) vt.part_variances.horz[1].variance < threshold &&
                get_plane_block_size_in_vp9_encodeframe(subsize, XD.plane.data + 1) < 13 {
                set_block_size(cpi, X, XD, mi_row, mi_col, subsize);
                set_block_size(cpi, X, XD, mi_row + BLOCK_HEIGHT / 2, mi_col, subsize);
                return 1;
            }
        }

        return 0;
    }
    return 0;
}

set_vt_partitioning :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    X: *MACROBLOCK,
    XD: *MACROBLOCKD,
    data: *$Value,
    bsize: BLOCK_SIZE,
    mi_row: s32,
    mi_col: s32,
    threshold: s64,
    bsize_min: BLOCK_SIZE,
    force_split: s32
) -> s32 {
    return set_vt_partitioning(cpi, X, XD, cast(*void) data, bsize, mi_row, mi_col, threshold, bsize_min, force_split);
}

get_variance :: (v: *Var) {
    v.variance =
        cast,no_check(s32) ((256 *
            (v.sum_square_error - cast,no_check(u32) (((cast,no_check(s64) v.sum_error) * cast(s64) v.sum_error) >> ((v.log2_count) & 63)))) >> ((v.log2_count) & 31));
}

tree_to_node :: (data: *void, bsize: BLOCK_SIZE, node: *Variance_Node) {
    i: s32 = ---;
    vt: *V64x64 = ---;
    vt_2: *V32x32 = ---;
    vt_3: *V16x16 = ---;
    vt_4: *V8x8 = ---;
    vt_5: *V4x4 = ---;
    code_block_to_execute: s64 = 43;
    while c_transpiler_dispatch := true {
        if code_block_to_execute < 0 break;
        if code_block_to_execute == {
            case 6; {
                while c_transpiler_local_loop := true {
                    if i < 4 {
                        node.split[i] = vt_5.split.data + i;
                        i += 1;
                        continue c_transpiler_local_loop;
                    } else {
                        break c_transpiler_dispatch;
                    }
                }
            }
            case 12; {
                vt_5 = cast(*V4x4) data;
                node.part_variances = *vt_5.part_variances;
                i = 0;
                code_block_to_execute = 6;
                continue c_transpiler_dispatch;
            }
            case 14; {
                while c_transpiler_local_loop := true {
                    if i < 4 {
                        node.split[i] = *vt_4.split[i].part_variances.none;
                        i += 1;
                        continue c_transpiler_local_loop;
                    } else {
                        break c_transpiler_dispatch;
                    }
                }
            }
            case 21; {
                while c_transpiler_local_loop := true {
                    if i < 4 {
                        node.split[i] = *vt_3.split[i].part_variances.none;
                        i += 1;
                        continue c_transpiler_local_loop;
                    } else {
                        break c_transpiler_dispatch;
                    }
                }
            }
            case 28; {
                while c_transpiler_local_loop := true {
                    if i < 4 {
                        node.split[i] = *vt_2.split[i].part_variances.none;
                        i += 1;
                        continue c_transpiler_local_loop;
                    } else {
                        break c_transpiler_dispatch;
                    }
                }
            }
            case 35; {
                while c_transpiler_local_loop := true {
                    if i < 4 {
                        node.split[i] = *vt.split[i].part_variances.none;
                        i += 1;
                        continue c_transpiler_local_loop;
                    } else {
                        break c_transpiler_dispatch;
                    }
                }
            }
            case 43; {
                node.part_variances = null;
                c_transpiler_switch_value_43 := cast,no_check(s32) bsize;
                if c_transpiler_switch_value_43 == {
                    case cast(s32) 12; {
                        vt = cast(*V64x64) data;
                        node.part_variances = *vt.part_variances;
                        i = 0;
                        code_block_to_execute = 35;
                        continue c_transpiler_dispatch;
                    }
                    case cast(s32) 9; {
                        vt_2 = cast(*V32x32) data;
                        node.part_variances = *vt_2.part_variances;
                        i = 0;
                        code_block_to_execute = 28;
                        continue c_transpiler_dispatch;
                    }
                    case cast(s32) 6; {
                        vt_3 = cast(*V16x16) data;
                        node.part_variances = *vt_3.part_variances;
                        i = 0;
                        code_block_to_execute = 21;
                        continue c_transpiler_dispatch;
                    }
                    case cast(s32) 3; {
                        vt_4 = cast(*V8x8) data;
                        node.part_variances = *vt_4.part_variances;
                        i = 0;
                        code_block_to_execute = 14;
                        continue c_transpiler_dispatch;
                    }
                    case; {
                        code_block_to_execute = 12;
                        continue c_transpiler_dispatch;
                    }
                }
            }
        }
        assert(false, tprint("invalid code block to execute %", code_block_to_execute));
        break;
    }
}

tree_to_node :: (data: *$Value, bsize: BLOCK_SIZE, node: *Variance_Node) {
    tree_to_node(cast(*void) data, bsize, node);
}

fill_variance_tree :: (data: *void, bsize: BLOCK_SIZE) {
    node: Variance_Node = ---;
    fill_memory(*node, 0, size_of(Variance_Node));
    tree_to_node(data, bsize, *node);
    sum_2_variances(node.split[0], node.split[1], node.part_variances.horz.data + 0);
    sum_2_variances(node.split[2], node.split[3], node.part_variances.horz.data + 1);
    sum_2_variances(node.split[0], node.split[2], node.part_variances.vert.data + 0);
    sum_2_variances(node.split[1], node.split[3], node.part_variances.vert.data + 1);
    sum_2_variances(node.part_variances.vert.data + 0, node.part_variances.vert.data + 1, *node.part_variances.none);
}

fill_variance_tree :: (data: *$Value, bsize: BLOCK_SIZE) {
    fill_variance_tree(cast(*void) data, bsize);
}

sum_2_variances :: (a: *Var, b: *Var, r: *Var) {
    fill_variance(a.sum_square_error + b.sum_square_error, a.sum_error + b.sum_error, a.log2_count + 1, r);
}

fill_variance :: (s2: u32, s: s32, c: s32, v: *Var) {
    v.sum_square_error = s2;
    v.sum_error = s;
    v.log2_count = c;
}

fill_variance_4x4avg :: (
    s: *u8,
    sp: s32,
    d: *u8,
    dp: s32,
    x8_idx: s32,
    y8_idx: s32,
    vst: *V8x8,
    pixels_wide: s32,
    pixels_high: s32,
    is_key_frame: s32
) {
    for k: 0..cast(s32) 4 - 1 {
        x4_idx := x8_idx + k & 1 << 2;
        y4_idx := y8_idx + k >> 1 << 2;
        sse: u32 = 0;
        sum: s32 = 0;
        if x4_idx < pixels_wide && y4_idx < pixels_high {
            d_avg: s32 = 128;

            s_avg := cast,no_check(s32) avg_4x4_c(s + y4_idx * sp + x4_idx, sp);
            if is_key_frame == 0 {
                d_avg = cast,no_check(s32) avg_4x4_c(d + y4_idx * dp + x4_idx, dp);
            }

            sum = s_avg - d_avg;
            sse = cast,no_check(u32) (sum * sum);
        }
        fill_variance(sse, sum, 0, *vst.split[k].part_variances.none);
    }
}

compute_minmax_8x8 :: (
    s: *u8,
    sp: s32,
    d: *u8,
    dp: s32,
    x16_idx: s32,
    y16_idx: s32,
    pixels_wide: s32,
    pixels_high: s32
) -> s32 {
    minmax_max: s32 = 0;
    minmax_min: s32 = 255;

    for k: 0..cast(s32) 4 - 1 {
        x8_idx := x16_idx + k & 1 << 3;
        y8_idx := y16_idx + k >> 1 << 3;
        min: s32 = 0;
        max: s32 = 0;
        if x8_idx < pixels_wide && y8_idx < pixels_high {
            minmax_8x8_c(s + y8_idx * sp + x8_idx, sp, d + y8_idx * dp + x8_idx, dp, *min, *max);

            if max - min > minmax_max {
                minmax_max = max - min;
            }
            if max - min < minmax_min {
                minmax_min = max - min;
            }
        }
    }
    return minmax_max - minmax_min;
}

fill_variance_8x8avg :: (
    s: *u8,
    sp: s32,
    d: *u8,
    dp: s32,
    x16_idx: s32,
    y16_idx: s32,
    vst: *V16x16,
    pixels_wide: s32,
    pixels_high: s32,
    is_key_frame: s32
) {
    for k: 0..cast(s32) 4 - 1 {
        x8_idx := x16_idx + k & 1 << 3;
        y8_idx := y16_idx + k >> 1 << 3;
        sse: u32 = 0;
        sum: s32 = 0;
        if x8_idx < pixels_wide && y8_idx < pixels_high {
            d_avg: s32 = 128;

            s_avg := cast,no_check(s32) avg_8x8_c(s + y8_idx * sp + x8_idx, sp);
            if is_key_frame == 0 {
                d_avg = cast,no_check(s32) avg_8x8_c(d + y8_idx * dp + x8_idx, dp);
            }

            sum = s_avg - d_avg;
            sse = cast,no_check(u32) (sum * sum);
        }
        fill_variance(sse, sum, 0, *vst.split[k].part_variances.none);
    }
}

copy_partitioning :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    xd: *MACROBLOCKD,
    mi_row: s32,
    mi_col: s32,
    segment_id: s32,
    sb_offset: s32
) -> s32 {
    svc_copy_allowed: s32 = 1;
    frames_since_key_thresh: s32 = 1;
    if cpi.use_svc != 0 {
        layer := 0 * cpi.svc.number_temporal_layers + cpi.svc.temporal_layer_id;
        lc := cpi.svc.layer_context.data + layer;
        if lc.is_key_frame != 0 || cpi.svc.non_reference_frame == 0 {
            svc_copy_allowed = 0;
        }
        frames_since_key_thresh = cpi.svc.number_spatial_layers << 1;
    }
    if cpi.rc.frames_since_key > frames_since_key_thresh &&
        svc_copy_allowed != 0 &&
        cpi.resize_pending == 0 &&
        segment_id == 0 &&
        cpi.prev_segment_id[sb_offset] == 0 &&
        cpi.copied_frame_cnt[sb_offset] < cpi.max_copied_frame {
        if cpi.prev_partition != null {
            copy_partitioning_helper(cpi, x, xd, 12, mi_row, mi_col);
            cpi.copied_frame_cnt[sb_offset] = cast,no_check(u8) ((cast,no_check(s32) cpi.copied_frame_cnt[sb_offset]) + 1);
            copy_memory(x.variance_low.data, *cpi.prev_variance_low[sb_offset * 25], x.variance_low.count);
            return 1;
        }
    }

    return 0;
}

copy_partitioning_helper :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    xd: *MACROBLOCKD,
    bsize: BLOCK_SIZE,
    mi_row: s32,
    mi_col: s32
) {
    CM := *cpi.common;
    prev_part := cpi.prev_partition;
    start_pos := mi_row * CM.mi_stride + mi_col;

    BSL := cast,no_check(s32) B_WIDTH_LOG2_LOOKUP[bsize];
    BS := (cast(s32) 1) << ((BSL) & 31) >> 2;

    if mi_row >= CM.mi_rows || mi_col >= CM.mi_cols {
        return;
    }

    partition := (((cast(*[13] PARTITION_TYPE) *(PARTITION_LOOKUP))[BSL]).data)[prev_part[start_pos]];
    subsize := get_subsize_in_vp9_encodeframe(bsize, partition);

    if subsize < 3 {
        set_block_size(cpi, x, xd, mi_row, mi_col, bsize);
    } else {
        if partition == {
            case cast,no_check(u32) PARTITION_NONE;
                set_block_size(cpi, x, xd, mi_row, mi_col, bsize);
            case cast,no_check(u32) PARTITION_HORZ;
                set_block_size(cpi, x, xd, mi_row, mi_col, subsize);
                set_block_size(cpi, x, xd, mi_row + BS, mi_col, subsize);
            case cast,no_check(u32) PARTITION_VERT;
                set_block_size(cpi, x, xd, mi_row, mi_col, subsize);
                set_block_size(cpi, x, xd, mi_row, mi_col + BS, subsize);
            case;
                copy_partitioning_helper(cpi, x, xd, subsize, mi_row, mi_col);
                copy_partitioning_helper(cpi, x, xd, subsize, mi_row + BS, mi_col);
                copy_partitioning_helper(cpi, x, xd, subsize, mi_row, mi_col + BS);
                copy_partitioning_helper(cpi, x, xd, subsize, mi_row + BS, mi_col + BS);
        }
    }
}

skin_sb_split :: (cpi: *VP9_COMP_in_vp9_encoder, LOW_RES: s32, mi_row: s32, mi_col: s32, force_split: *s32) -> s32 {
    CM := *cpi.common;

    if LOW_RES == 0 && mi_col >= 8 && mi_col + 8 < CM.mi_cols && mi_row >= 8 && mi_row + 8 < CM.mi_rows {
        num_16x16_skin: s32 = 0;
        num_16x16_nonskin: s32 = 0;
        BLOCK_INDEX := mi_row * CM.mi_cols + mi_col;
        BW := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[12];
        BH := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[12];
        XMIS := (ifx CM.mi_cols - mi_col < BW then CM.mi_cols - mi_col else BW);
        YMIS := (ifx CM.mi_rows - mi_row < BH then CM.mi_rows - mi_row else BH);
        j: s32 = ---;
        i: s32 = 0;
        while i < YMIS {
            j = 0;
            while j < XMIS {
                bl_index := BLOCK_INDEX + i * CM.mi_cols + j;
                is_skin := cast,no_check(s32) cpi.skin_map[bl_index];
                num_16x16_skin += is_skin;
                num_16x16_nonskin += 1 - is_skin;
                if num_16x16_nonskin > 3 {
                    i = YMIS;
                    break;
                }
                j += 2;
            }
            i += 2;
        }
        if num_16x16_skin > 12 {
            force_split.* = 1;
            return 1;
        }
    }
    return 0;
}

set_vbp_thresholds :: (cpi: *VP9_COMP_in_vp9_encoder, thresholds: *s64, q: s32, content_state: s32) {
    CM := *cpi.common;
    IS_KEY_FRAME := frame_is_intra_only_in_vp9_encodeframe(CM);
    THRESHOLD_MULTIPLIER := (ifx IS_KEY_FRAME != 0 then 20 else cpi.sf.variance_part_thresh_mult);
    threshold_base := cast,no_check(s64) (THRESHOLD_MULTIPLIER * cast(s32) cpi.y_dequant[q][1]);

    if IS_KEY_FRAME != 0 {
        thresholds[0] = threshold_base;
        thresholds[1] = threshold_base >> 2;
        thresholds[2] = threshold_base >> 2;
        thresholds[3] = threshold_base << 2;
    } else {
        if cpi.noise_estimate.enabled != 0 && CM.width >= 640 && CM.height >= 480 {
            noise_level := vp9_noise_estimate_extract_level(*cpi.noise_estimate);
            if noise_level == cast,no_check(u32) K_HIGH {
                threshold_base = 3 * threshold_base;
            } else if noise_level == cast,no_check(u32) K_MEDIUM {
                threshold_base = threshold_base << 1;
            } else if noise_level < cast,no_check(u32) K_LOW {
                threshold_base = (7 * threshold_base) >> 3;
            }
        }

        threshold_base = scale_part_thresh_sumdiff(threshold_base, cpi.oxcf.speed, CM.width, CM.height, content_state);

        thresholds[0] = threshold_base;
        thresholds[2] = threshold_base << ((cpi.oxcf.speed) & 63);
        if CM.width >= 1280 && CM.height >= 720 && cpi.oxcf.speed < 7 {
            thresholds[2] = thresholds[2] << 1;
        }
        if CM.width <= 352 && CM.height <= 288 {
            thresholds[0] = threshold_base >> 3;
            thresholds[1] = threshold_base >> 1;
            thresholds[2] = threshold_base << 3;
            if cpi.rc.avg_frame_qindex[INTER_FRAME] > 220 {
                thresholds[2] = thresholds[2] << 2;
            } else if cpi.rc.avg_frame_qindex[INTER_FRAME] > 200 {
                thresholds[2] = thresholds[2] << 1;
            }
        } else if CM.width < 1280 && CM.height < 720 {
            thresholds[1] = (5 * threshold_base) >> 2;
        } else if CM.width < 1920 && CM.height < 1080 {
            thresholds[1] = threshold_base << 1;
        } else {
            thresholds[1] = (5 * threshold_base) >> 1;
        }
        if cpi.sf.disable_16x16part_nonkey != 0 {
            thresholds[2] = 9223372036854775807;
        }
    }
}

scale_part_thresh_sumdiff :: (threshold_base: s64, speed: s32, width: s32, height: s32, content_state: s32) -> s64 {
    if speed >= 8 {
        if width <= 640 && height <= 480 {
            return (5 * threshold_base) >> 2;
        } else if content_state == K_LOW_SAD_LOW_SUMDIFF ||
            content_state == K_HIGH_SAD_LOW_SUMDIFF ||
            content_state == K_LOW_VAR_HIGH_SUMDIFF {
            return (5 * threshold_base) >> 2;
        }
    } else if speed == 7 {
        if content_state == K_LOW_SAD_LOW_SUMDIFF ||
            content_state == K_HIGH_SAD_LOW_SUMDIFF ||
            content_state == K_LOW_VAR_HIGH_SUMDIFF {
            return (5 * threshold_base) >> 2;
        }
    }
    return threshold_base;
}

scale_partitioning_svc :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    xd: *MACROBLOCKD,
    bsize: BLOCK_SIZE,
    mi_row: s32,
    mi_col: s32,
    mi_row_high: s32,
    mi_col_high: s32
) -> s32 {
    CM := *cpi.common;
    SVC_ := *cpi.svc;
    prev_part := SVC_.prev_partition_svc;

    bsize_high: s32 = 0;
    subsize_high: s32 = 0;
    BSL := cast,no_check(s32) B_WIDTH_LOG2_LOOKUP[bsize];
    BS := (cast(s32) 1) << ((BSL) & 31) >> 2;
    HAS_ROWS := cast(s32) (mi_row_high + BS < CM.mi_rows);
    HAS_COLS := cast(s32) (mi_col_high + BS < CM.mi_cols);

    if mi_row >= SVC_.mi_rows[SVC_.spatial_layer_id - 1] || mi_col >= SVC_.mi_cols[SVC_.spatial_layer_id - 1] {
        return 1;
    }

    if HAS_ROWS == 0 || HAS_COLS == 0 {
        return 1;
    }

    start_pos := mi_row * SVC_.mi_stride[SVC_.spatial_layer_id - 1] + mi_col;
    bsize_low := prev_part[start_pos];

    if cpi.svc.non_reference_frame == 0 && x.skip_low_source_sad == 0 && bsize_low < 9 {
        return 1;
    }

    if bsize_low < 9 {
        bsize_high = (cast(s32) bsize_low) + 3;
    } else if bsize_low >= 9 {
        bsize_high = 12;
    }

    partition_high := (((cast(*[13] PARTITION_TYPE) *(PARTITION_LOOKUP))[BSL]).data)[bsize_high];
    subsize_high = cast,no_check(s32) get_subsize_in_vp9_encodeframe(bsize, partition_high);

    if subsize_high < 3 {
        set_block_size(cpi, x, xd, mi_row_high, mi_col_high, cast,no_check(BLOCK_SIZE) bsize_high);
    } else {
        if partition_high == {
            case cast,no_check(u32) PARTITION_NONE;
                set_block_size(cpi, x, xd, mi_row_high, mi_col_high, cast,no_check(BLOCK_SIZE) bsize_high);
            case cast,no_check(u32) PARTITION_HORZ;
                set_block_size(cpi, x, xd, mi_row_high, mi_col_high, cast,no_check(BLOCK_SIZE) subsize_high);
                if subsize_high < 12 {
                    set_block_size(cpi, x, xd, mi_row_high + BS, mi_col_high, cast,no_check(BLOCK_SIZE) subsize_high);
                }
            case cast,no_check(u32) PARTITION_VERT;
                set_block_size(cpi, x, xd, mi_row_high, mi_col_high, cast,no_check(BLOCK_SIZE) subsize_high);
                if subsize_high < 12 {
                    set_block_size(cpi, x, xd, mi_row_high, mi_col_high + BS, cast,no_check(BLOCK_SIZE) subsize_high);
                }
            case;
                if scale_partitioning_svc(
                    cpi,
                    x,
                    xd,
                    cast,no_check(BLOCK_SIZE) subsize_high,
                    mi_row,
                    mi_col,
                    mi_row_high,
                    mi_col_high
                ) != 0 {
                    return 1;
                }
                if scale_partitioning_svc(
                    cpi,
                    x,
                    xd,
                    cast,no_check(BLOCK_SIZE) subsize_high,
                    mi_row + BS >> 1,
                    mi_col,
                    mi_row_high + BS,
                    mi_col_high
                ) != 0 {
                    return 1;
                }
                if scale_partitioning_svc(
                    cpi,
                    x,
                    xd,
                    cast,no_check(BLOCK_SIZE) subsize_high,
                    mi_row,
                    mi_col + BS >> 1,
                    mi_row_high,
                    mi_col_high + BS
                ) != 0 {
                    return 1;
                }
                if scale_partitioning_svc(
                    cpi,
                    x,
                    xd,
                    cast,no_check(BLOCK_SIZE) subsize_high,
                    mi_row + BS >> 1,
                    mi_col + BS >> 1,
                    mi_row_high + BS,
                    mi_col_high + BS
                ) != 0 {
                    return 1;
                }
        }
    }

    return 0;
}

set_fixed_partitioning :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    TILE: *Tile_Info,
    mi_8x8: **MODE_INFO,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE
) {
    CM := *cpi.common;
    MIS := CM.mi_stride;
    ROW8X8_REMAINING := TILE.mi_row_end - mi_row;
    COL8X8_REMAINING := TILE.mi_col_end - mi_col;
    block_row, block_col: s32 = ---;
    mi_upper_left := CM.mi + mi_row * MIS + mi_col;
    bh := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize];
    bw := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize];

    if COL8X8_REMAINING >= (cast(s32) 1) << (((6 - 3)) & 31) && ROW8X8_REMAINING >= (cast(s32) 1) << (((6 - 3)) & 31) {
        block_row = 0;
        while block_row < (cast(s32) 1) << (((6 - 3)) & 31) {
            block_col = 0;
            while block_col < (cast(s32) 1) << (((6 - 3)) & 31) {
                index := block_row * MIS + block_col;
                mi_8x8[index] = mi_upper_left + index;
                mi_8x8[index].sb_type = bsize;
                block_col += bw;
            }
            block_row += bh;
        }
    } else {
        set_partial_b64x64_partition(mi_upper_left, MIS, bh, bw, ROW8X8_REMAINING, COL8X8_REMAINING, bsize, mi_8x8);
    }
}

set_partial_b64x64_partition :: (
    mi: *MODE_INFO,
    mis: s32,
    bh_in: s32,
    bw_in: s32,
    row8x8_remaining: s32,
    col8x8_remaining: s32,
    bsize: BLOCK_SIZE,
    mi_8x8: **MODE_INFO
) {
    bh := bh_in;
    c: s32 = ---;
    r: s32 = 0;
    while r < (cast(s32) 1) << (((6 - 3)) & 31) {
        bw := bw_in;
        c = 0;
        while c < (cast(s32) 1) << (((6 - 3)) & 31) {
            INDEX := r * mis + c;
            mi_8x8[INDEX] = mi + INDEX;
            mi_8x8[INDEX].sb_type = find_partition_size(bsize, row8x8_remaining - r, col8x8_remaining - c, *bh, *bw);
            c += bw;
        }
        r += bh;
    }
}

encode_nonrd_sb_row :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    td: *Thread_Data_in_vp9_encoder,
    tile_data: *Tile_Data_Enc,
    mi_row: s32,
    tp: **TOKENEXTRA_in_vp9_cx_iface
) {
    SF := *cpi.sf;
    CM := *cpi.common;
    TILE_INFO := *tile_data.tile_info;
    X := *td.mb;
    XD := *X.e_mbd;
    MI_COL_START := TILE_INFO.mi_col_start;
    MI_COL_END := TILE_INFO.mi_col_end;
    mi_col: s32 = ---;
    SB_ROW := mi_row >> (((6 - 3)) & 31);
    NUM_SB_COLS := get_num_cols_in_vp9_encodeframe(tile_data.tile_info, cast,no_check(s32) (6 - 3));
    sb_col_in_tile: s32 = ---;

    fill_memory(*XD.left_context, 0, XD.left_context.count * size_of([16] ENTROPY_CONTEXT));
    fill_memory(XD.left_seg_context.data, 0, XD.left_seg_context.count);

    mi_col = MI_COL_START;
    sb_col_in_tile = 0;
    while mi_col < MI_COL_END {
        SEG := *CM.seg;
        dummy_rdc: RD_COST = ---;
        IDX_STR := CM.mi_stride * mi_row + mi_col;
        mi := CM.mi_grid_visible + IDX_STR;
        partition_search_type := SF.partition_search_type;
        bsize: BLOCK_SIZE = 12;
        seg_skip: s32 = 0;

        cpi.row_mt_sync_read_ptr(*tile_data.row_mt_sync, SB_ROW, sb_col_in_tile);

        if cpi.use_skin_detection != 0 {
            vp9_compute_skin_sb(cpi, 6, mi_row, mi_col);
        }

        X.source_variance = U32_MAX;
        for i: 0..cast(s32) 4 - 1 {
            X.pred_mv[i].row = 32767;
            X.pred_mv[i].col = 32767;
        }
        vp9_rd_cost_init(*dummy_rdc);
        X.color_sensitivity[0] = 0;
        X.color_sensitivity[1] = 0;
        X.sb_is_skin = 0;
        X.skip_low_source_sad = 0;
        X.lowvar_highsumdiff = 0;
        X.content_state_sb = 0;
        X.zero_temp_sad_source = 0;
        X.sb_use_mv_part = 0;
        X.sb_mvcol_part = 0;
        X.sb_mvrow_part = 0;
        X.sb_pickmode_part = 0;
        X.arf_frame_usage = 0;
        X.lastgolden_frame_usage = 0;

        if cpi.compute_source_sad_onepass != 0 && cpi.sf.use_source_sad != 0 {
            shift := cpi.source.y_stride * mi_row << 3 + mi_col << 3;
            sb_offset2 := (CM.mi_cols + 7) >> 3 * mi_row >> 3 + mi_col >> 3;
            source_sad := cast,no_check(s64) avg_source_sad(cpi, X, shift, sb_offset2);
            if SF.adapt_partition_source_sad != 0 &&
                cpi.oxcf.rc_mode == cast,no_check(u32) VBR &&
                cpi.rc.is_src_frame_alt_ref == 0 &&
                source_sad > cast,no_check(s64) SF.adapt_partition_thresh &&
                (cpi.refresh_golden_frame != 0 || cpi.refresh_alt_ref_frame != 0) {
                partition_search_type = cast,no_check(PARTITION_SEARCH_TYPE) REFERENCE_PARTITION;
            }
        }

        if SEG.enabled != 0 {
            MAP := (ifx SEG.update_map != 0 then cpi.segmentation_map else CM.last_frame_seg_map);
            segment_id := get_segment_id_in_vp9_encodeframe(CM, MAP, 12, mi_row, mi_col);
            seg_skip =
                segfeature_active_in_vp9_encodeframe(
                    SEG,
                    segment_id,
                    cast,no_check(SEG_LVL_FEATURES) SEG_LVL_SKIP
                );

            if cpi.roi.enabled != 0 &&
                cpi.roi.skip[3] != 0 &&
                cpi.rc.frames_since_key > 20 &&
                X.content_state_sb > cast,no_check(u8) K_LOW_SAD_LOW_SUMDIFF {
                xi: s32 = ---;
                BW := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[12];
                BH := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[12];
                XMIS := (ifx CM.mi_cols - mi_col < BW then CM.mi_cols - mi_col else BW);
                YMIS := (ifx CM.mi_rows - mi_row < BH then CM.mi_rows - mi_row else BH);
                BLOCK_INDEX := mi_row * CM.mi_cols + mi_col;
                set_mode_info_offsets(CM, X, XD, mi_row, mi_col);
                if 0 < YMIS {
                    for yi: 0..YMIS - 1 {
                        xi = 0;
                        while xi < XMIS {
                            map_offset := BLOCK_INDEX + yi * CM.mi_cols + xi;
                            cpi.segmentation_map[map_offset] = 0;
                            xi += 1;
                        }
                    }
                }
                set_segment_index(cpi, X, mi_row, mi_col, 12, 0);
                seg_skip = 0;
            }
            if seg_skip != 0 {
                partition_search_type = cast,no_check(PARTITION_SEARCH_TYPE) FIXED_PARTITION;
            }
        }

        if partition_search_type == {
            case cast,no_check(u32) VAR_BASED_PARTITION;
                choose_partitioning(cpi, TILE_INFO, X, mi_row, mi_col);
                nonrd_use_partition(cpi, td, tile_data, mi, tp, mi_row, mi_col, 12, 1, *dummy_rdc, td.pc_root);
            case cast,no_check(u32) ML_BASED_PARTITION;
                get_estimated_pred(cpi, TILE_INFO, X, mi_row, mi_col);
                X.max_partition_size = 12;
                X.min_partition_size = 3;
                X.sb_pickmode_part = 1;
                nonrd_pick_partition(
                    cpi,
                    td,
                    tile_data,
                    tp,
                    mi_row,
                    mi_col,
                    12,
                    *dummy_rdc,
                    1,
                    9223372036854775807,
                    td.pc_root
                );
            case cast,no_check(u32) FIXED_PARTITION;
                if seg_skip == 0 {
                    bsize = SF.always_this_block_size;
                }
                set_fixed_partitioning(cpi, TILE_INFO, mi, mi_row, mi_col, bsize);
                nonrd_use_partition(cpi, td, tile_data, mi, tp, mi_row, mi_col, 12, 1, *dummy_rdc, td.pc_root);
            case;
                X.sb_pickmode_part = 1;
                set_offsets(cpi, TILE_INFO, X, mi_row, mi_col, 12);
                if cpi.oxcf.rc_mode == cast,no_check(u32) VBR &&
                    cpi.rc.high_source_sad != 0 &&
                    cpi.oxcf.speed < 6 &&
                    frame_is_intra_only_in_vp9_encodeframe(CM) == 0 &&
                    (cpi.refresh_golden_frame != 0 || cpi.refresh_alt_ref_frame != 0) {
                    if CM.width <= 352 && CM.height <= 288 {
                        X.max_partition_size = 9;
                    } else {
                        X.max_partition_size = 12;
                    }
                    X.min_partition_size = 3;
                    nonrd_pick_partition(
                        cpi,
                        td,
                        tile_data,
                        tp,
                        mi_row,
                        mi_col,
                        12,
                        *dummy_rdc,
                        1,
                        9223372036854775807,
                        td.pc_root
                    );
                } else {
                    choose_partitioning(cpi, TILE_INFO, X, mi_row, mi_col);

                    if frame_is_intra_only_in_vp9_encodeframe(CM) != 0 {
                        nonrd_use_partition(cpi, td, tile_data, mi, tp, mi_row, mi_col, 12, 1, *dummy_rdc, td.pc_root);
                    } else {
                        nonrd_select_partition(
                            cpi,
                            td,
                            tile_data,
                            mi,
                            tp,
                            mi_row,
                            mi_col,
                            12,
                            1,
                            *dummy_rdc,
                            td.pc_root
                        );
                    }
                }
        }

        if cpi.rc.is_src_frame_alt_ref == 0 &&
            cpi.refresh_golden_frame == 0 &&
            cpi.refresh_alt_ref_frame == 0 &&
            cpi.rc.alt_ref_gf_group != 0 &&
            cpi.sf.use_altref_onepass != 0 {
            sboffset := (CM.mi_cols + 7) >> 3 * mi_row >> 3 + mi_col >> 3;
            if cpi.count_arf_frame_usage != null {
                cpi.count_arf_frame_usage[sboffset] = X.arf_frame_usage;
            }
            if cpi.count_lastgolden_frame_usage != null {
                cpi.count_lastgolden_frame_usage[sboffset] = X.lastgolden_frame_usage;
            }
        }

        cpi.row_mt_sync_write_ptr(*tile_data.row_mt_sync, SB_ROW, sb_col_in_tile, NUM_SB_COLS);
        mi_col += (cast(s32) 1) << (((6 - 3)) & 31);
        sb_col_in_tile += 1;
    }
}

nonrd_select_partition :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    td: *Thread_Data_in_vp9_encoder,
    tile_data: *Tile_Data_Enc,
    mi: **MODE_INFO,
    tp: **TOKENEXTRA_in_vp9_cx_iface,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE,
    output_enabled: s32,
    rd_cost: *RD_COST,
    pc_tree: *PC_TREE
) {
    CM := *cpi.common;
    TILE_INFO := *tile_data.tile_info;
    X := *td.mb;
    XD := *X.e_mbd;
    BSL := cast,no_check(s32) B_WIDTH_LOG2_LOOKUP[bsize];
    HBS := (cast(s32) 1) << ((BSL) & 31) / 4;
    MIS := CM.mi_stride;

    this_rdc: RD_COST = ---;
    subsize_ref := (ifx cpi.sf.adapt_partition_source_sad != 0 then cast(BLOCK_SIZE) 3 else 6);

    vp9_rd_cost_reset(*this_rdc);
    if mi_row >= CM.mi_rows || mi_col >= CM.mi_cols {
        return;
    }

    subsize := cast,no_check(BLOCK_SIZE) ((ifx bsize >= 3 then cast,no_check(s32) mi[0].sb_type else 0));
    partition := (((cast(*[13] PARTITION_TYPE) *(PARTITION_LOOKUP))[BSL]).data)[subsize];

    if bsize == 9 && subsize == 9 {
        X.max_partition_size = 9;
        X.min_partition_size = 6;
        nonrd_pick_partition(cpi, td, tile_data, tp, mi_row, mi_col, bsize, rd_cost, 0, 9223372036854775807, pc_tree);
    } else if bsize == 9 && partition != cast,no_check(u32) PARTITION_NONE && subsize >= subsize_ref {
        X.max_partition_size = 9;
        X.min_partition_size = 3;
        nonrd_pick_partition(cpi, td, tile_data, tp, mi_row, mi_col, bsize, rd_cost, 0, 9223372036854775807, pc_tree);
    } else if bsize == 6 && partition != cast,no_check(u32) PARTITION_NONE {
        X.max_partition_size = 6;
        X.min_partition_size = 3;
        nonrd_pick_partition(cpi, td, tile_data, tp, mi_row, mi_col, bsize, rd_cost, 0, 9223372036854775807, pc_tree);
    } else {
        if partition == {
            case cast,no_check(u32) PARTITION_NONE;
                pc_tree.none.pred_pixel_ready = 1;
                nonrd_pick_sb_modes(cpi, tile_data, X, mi_row, mi_col, rd_cost, subsize, *pc_tree.none);
                assignment_16: MODE_INFO = XD.mi[0].*;
                ((*pc_tree.none.mic).*) = assignment_16;
                assignment_17: MB_MODE_INFO_EXT = X.mbmi_ext.*;
                ((*pc_tree.none.mbmi_ext).*) = assignment_17;
                pc_tree.none.skip_txfm[0] = X.skip_txfm[0];
                pc_tree.none.skip = X.skip;
            case cast,no_check(u32) PARTITION_VERT;
                pc_tree.vertical[0].pred_pixel_ready = 1;
                nonrd_pick_sb_modes(cpi, tile_data, X, mi_row, mi_col, rd_cost, subsize, pc_tree.vertical.data + 0);
                assignment_18: MODE_INFO = XD.mi[0].*;
                ((*pc_tree.vertical[0].mic).*) = assignment_18;
                assignment_19: MB_MODE_INFO_EXT = X.mbmi_ext.*;
                ((*pc_tree.vertical[0].mbmi_ext).*) = assignment_19;
                pc_tree.vertical[0].skip_txfm[0] = X.skip_txfm[0];
                pc_tree.vertical[0].skip = X.skip;
                if mi_col + HBS < CM.mi_cols {
                    pc_tree.vertical[1].pred_pixel_ready = 1;
                    nonrd_pick_sb_modes(
                        cpi,
                        tile_data,
                        X,
                        mi_row,
                        mi_col + HBS,
                        *this_rdc,
                        subsize,
                        pc_tree.vertical.data + 1
                    );
                    assignment_20: MODE_INFO = XD.mi[0].*;
                    ((*pc_tree.vertical[1].mic).*) = assignment_20;
                    assignment_21: MB_MODE_INFO_EXT = X.mbmi_ext.*;
                    ((*pc_tree.vertical[1].mbmi_ext).*) = assignment_21;
                    pc_tree.vertical[1].skip_txfm[0] = X.skip_txfm[0];
                    pc_tree.vertical[1].skip = X.skip;
                    if this_rdc.rate != 2147483647 &&
                        this_rdc.dist != 9223372036854775807 &&
                        rd_cost.rate != 2147483647 &&
                        rd_cost.dist != 9223372036854775807 {
                        rd_cost.rate += this_rdc.rate;
                        rd_cost.dist += this_rdc.dist;
                    }
                }
            case cast,no_check(u32) PARTITION_HORZ;
                pc_tree.horizontal[0].pred_pixel_ready = 1;
                nonrd_pick_sb_modes(cpi, tile_data, X, mi_row, mi_col, rd_cost, subsize, pc_tree.horizontal.data + 0);
                assignment_22: MODE_INFO = XD.mi[0].*;
                ((*pc_tree.horizontal[0].mic).*) = assignment_22;
                assignment_23: MB_MODE_INFO_EXT = X.mbmi_ext.*;
                ((*pc_tree.horizontal[0].mbmi_ext).*) = assignment_23;
                pc_tree.horizontal[0].skip_txfm[0] = X.skip_txfm[0];
                pc_tree.horizontal[0].skip = X.skip;
                if mi_row + HBS < CM.mi_rows {
                    pc_tree.horizontal[1].pred_pixel_ready = 1;
                    nonrd_pick_sb_modes(
                        cpi,
                        tile_data,
                        X,
                        mi_row + HBS,
                        mi_col,
                        *this_rdc,
                        subsize,
                        pc_tree.horizontal.data + 1
                    );
                    assignment_24: MODE_INFO = XD.mi[0].*;
                    ((*pc_tree.horizontal[1].mic).*) = assignment_24;
                    assignment_25: MB_MODE_INFO_EXT = X.mbmi_ext.*;
                    ((*pc_tree.horizontal[1].mbmi_ext).*) = assignment_25;
                    pc_tree.horizontal[1].skip_txfm[0] = X.skip_txfm[0];
                    pc_tree.horizontal[1].skip = X.skip;
                    if this_rdc.rate != 2147483647 &&
                        this_rdc.dist != 9223372036854775807 &&
                        rd_cost.rate != 2147483647 &&
                        rd_cost.dist != 9223372036854775807 {
                        rd_cost.rate += this_rdc.rate;
                        rd_cost.dist += this_rdc.dist;
                    }
                }
            case;
                subsize = get_subsize_in_vp9_encodeframe(bsize, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT);
                nonrd_select_partition(
                    cpi,
                    td,
                    tile_data,
                    mi,
                    tp,
                    mi_row,
                    mi_col,
                    subsize,
                    output_enabled,
                    rd_cost,
                    pc_tree.u.split[0]
                );
                nonrd_select_partition(
                    cpi,
                    td,
                    tile_data,
                    mi + HBS,
                    tp,
                    mi_row,
                    mi_col + HBS,
                    subsize,
                    output_enabled,
                    *this_rdc,
                    pc_tree.u.split[1]
                );
                if this_rdc.rate != 2147483647 &&
                    this_rdc.dist != 9223372036854775807 &&
                    rd_cost.rate != 2147483647 &&
                    rd_cost.dist != 9223372036854775807 {
                    rd_cost.rate += this_rdc.rate;
                    rd_cost.dist += this_rdc.dist;
                }
                nonrd_select_partition(
                    cpi,
                    td,
                    tile_data,
                    mi + HBS * MIS,
                    tp,
                    mi_row + HBS,
                    mi_col,
                    subsize,
                    output_enabled,
                    *this_rdc,
                    pc_tree.u.split[2]
                );
                if this_rdc.rate != 2147483647 &&
                    this_rdc.dist != 9223372036854775807 &&
                    rd_cost.rate != 2147483647 &&
                    rd_cost.dist != 9223372036854775807 {
                    rd_cost.rate += this_rdc.rate;
                    rd_cost.dist += this_rdc.dist;
                }
                nonrd_select_partition(
                    cpi,
                    td,
                    tile_data,
                    mi + HBS * MIS + HBS,
                    tp,
                    mi_row + HBS,
                    mi_col + HBS,
                    subsize,
                    output_enabled,
                    *this_rdc,
                    pc_tree.u.split[3]
                );
                if this_rdc.rate != 2147483647 &&
                    this_rdc.dist != 9223372036854775807 &&
                    rd_cost.rate != 2147483647 &&
                    rd_cost.dist != 9223372036854775807 {
                    rd_cost.rate += this_rdc.rate;
                    rd_cost.dist += this_rdc.dist;
                }
        }
    }

    if bsize == 12 && output_enabled != 0 {
        encode_sb_rt(cpi, td, TILE_INFO, tp, mi_row, mi_col, 1, bsize, pc_tree);
    }
}

encode_sb_rt :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    td: *Thread_Data_in_vp9_encoder,
    TILE: *Tile_Info,
    tp: **TOKENEXTRA_in_vp9_cx_iface,
    mi_row: s32,
    mi_col: s32,
    output_enabled: s32,
    bsize: BLOCK_SIZE,
    pc_tree: *PC_TREE
) {
    CM := *cpi.common;
    X := *td.mb;
    XD := *X.e_mbd;

    BSL := cast,no_check(s32) B_WIDTH_LOG2_LOOKUP[bsize];
    HBS := (cast(s32) 1) << ((BSL) & 31) / 4;
    ctx: s32 = ---;

    subsize: BLOCK_SIZE = ---;

    if mi_row >= CM.mi_rows || mi_col >= CM.mi_cols {
        return;
    }

    if bsize >= 3 {
        IDX_STR := XD.mi_stride * mi_row + mi_col;
        mi_8x8 := CM.mi_grid_visible + IDX_STR;
        ctx = partition_plane_context_in_vp9_encodeframe(XD, mi_row, mi_col, bsize);
        subsize = mi_8x8[0].sb_type;
    } else {
        ctx = 0;
        subsize = 0;
    }

    partition := (((cast(*[13] PARTITION_TYPE) *(PARTITION_LOOKUP))[BSL]).data)[subsize];
    if output_enabled != 0 && bsize != 0 {
        td.counts.partition[ctx][partition] += 1;
    }

    if partition == {
        case cast,no_check(u32) PARTITION_NONE;
            encode_b_rt(cpi, td, TILE, tp, mi_row, mi_col, output_enabled, subsize, *pc_tree.none);
        case cast,no_check(u32) PARTITION_VERT;
            encode_b_rt(cpi, td, TILE, tp, mi_row, mi_col, output_enabled, subsize, pc_tree.vertical.data + 0);
            if mi_col + HBS < CM.mi_cols && bsize > 3 {
                encode_b_rt(cpi, td, TILE, tp, mi_row, mi_col + HBS, output_enabled, subsize, pc_tree.vertical.data + 1);
            }
        case cast,no_check(u32) PARTITION_HORZ;
            encode_b_rt(cpi, td, TILE, tp, mi_row, mi_col, output_enabled, subsize, pc_tree.horizontal.data + 0);
            if mi_row + HBS < CM.mi_rows && bsize > 3 {
                encode_b_rt(
                    cpi,
                    td,
                    TILE,
                    tp,
                    mi_row + HBS,
                    mi_col,
                    output_enabled,
                    subsize,
                    pc_tree.horizontal.data + 1
                );
            }
        case;
            subsize = get_subsize_in_vp9_encodeframe(bsize, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT);
            encode_sb_rt(cpi, td, TILE, tp, mi_row, mi_col, output_enabled, subsize, pc_tree.u.split[0]);
            encode_sb_rt(cpi, td, TILE, tp, mi_row, mi_col + HBS, output_enabled, subsize, pc_tree.u.split[1]);
            encode_sb_rt(cpi, td, TILE, tp, mi_row + HBS, mi_col, output_enabled, subsize, pc_tree.u.split[2]);
            encode_sb_rt(cpi, td, TILE, tp, mi_row + HBS, mi_col + HBS, output_enabled, subsize, pc_tree.u.split[3]);
    }

    if partition != cast,no_check(u32) PARTITION_SPLIT || bsize == 3 {
        update_partition_context_in_vp9_encodeframe(XD, mi_row, mi_col, subsize, bsize);
    }
}

encode_b_rt :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    td: *Thread_Data_in_vp9_encoder,
    TILE: *Tile_Info,
    tp: **TOKENEXTRA_in_vp9_cx_iface,
    mi_row: s32,
    mi_col: s32,
    output_enabled: s32,
    bsize: BLOCK_SIZE,
    ctx: *PICK_MODE_CONTEXT
) {
    X := *td.mb;
    set_offsets(cpi, TILE, X, mi_row, mi_col, bsize);
    update_state_rt(cpi, td, ctx, mi_row, mi_col, cast,no_check(s32) bsize);

    encode_superblock(cpi, td, tp, output_enabled, mi_row, mi_col, bsize, ctx);
    update_stats(*cpi.common, td);

    tp.*.token = 127;
    tp.* += 1;
}

update_state_rt :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    td: *Thread_Data_in_vp9_encoder,
    ctx: *PICK_MODE_CONTEXT,
    mi_row: s32,
    mi_col: s32,
    bsize: s32
) {
    CM := *cpi.common;
    X := *td.mb;
    XD := *X.e_mbd;
    MI := XD.mi[0];
    P := X.plane.data;
    SEG := *CM.seg;
    BW := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[MI.sb_type];
    BH := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[MI.sb_type];
    X_MIS := (ifx BW < CM.mi_cols - mi_col then BW else CM.mi_cols - mi_col);
    Y_MIS := (ifx BH < CM.mi_rows - mi_row then BH else CM.mi_rows - mi_row);

    assignment_26: MODE_INFO = ctx.mic;
    ((XD.mi[0]).*) = assignment_26;
    assignment_27: MB_MODE_INFO_EXT = ctx.mbmi_ext;
    ((X.mbmi_ext).*) = assignment_27;

    if SEG.enabled != 0 &&
        (cpi.oxcf.aq_mode != cast,no_check(u32) NO_AQ || cpi.roi.enabled != 0 || cpi.active_map.enabled != 0) {
        if cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ && cpi.cyclic_refresh.content_mode != 0 {
            vp9_cyclic_refresh_update_segment(
                cpi,
                MI,
                mi_row,
                mi_col,
                cast,no_check(BLOCK_SIZE) bsize,
                cast,no_check(s64) ctx.rate,
                ctx.dist,
                X.skip,
                P
            );
        } else {
            MAP := (ifx SEG.update_map != 0 then cpi.segmentation_map else CM.last_frame_seg_map);
            MI.segment_id =
                cast,no_check(s8) get_segment_id_in_vp9_encodeframe(
                    CM,
                    MAP,
                    cast,no_check(BLOCK_SIZE) bsize,
                    mi_row,
                    mi_col
                );
        }
        vp9_init_plane_quantizers(cpi, X);
    }

    if is_inter_block_in_vp9_encodeframe(MI) != 0 {
        vp9_update_mv_count(td);
        if CM.interp_filter == 4 {
            PRED_CTX := get_pred_context_switchable_interp_in_vp9_encodeframe(XD);
            td.counts.switchable_interp[PRED_CTX][MI.interp_filter] += 1;
        }

        if MI.sb_type < 3 {
            MI.mv[0].as_int = MI.bmi[3].as_mv[0].as_int;
            MI.mv[1].as_int = MI.bmi[3].as_mv[1].as_int;
        }
    }

    if CM.use_prev_frame_mvs != 0 ||
        CM.error_resilient_mode == 0 ||
        cpi.svc.use_base_mv != 0 &&
            cpi.svc.number_spatial_layers > 1 &&
            cpi.svc.spatial_layer_id != cpi.svc.number_spatial_layers - 1 {
        FRAME_MVS := CM.cur_frame.mvs + mi_row * CM.mi_cols + mi_col;
        w: s32 = ---;

        if 0 < Y_MIS {
            for h: 0..Y_MIS - 1 {
                FRAME_MV := FRAME_MVS + h * CM.mi_cols;
                w = 0;
                while w < X_MIS {
                    MV_ := FRAME_MV + w;
                    MV_.ref_frame[0] = MI.ref_frame[0];
                    MV_.ref_frame[1] = MI.ref_frame[1];
                    MV_.mv[0].as_int = MI.mv[0].as_int;
                    MV_.mv[1].as_int = MI.mv[1].as_int;
                    w += 1;
                }
            }
        }
    }

    X.skip = ctx.skip;
    X.skip_txfm[0] =
        cast,no_check(u8) ((ifx MI.segment_id != 0 ||
            XD.lossless != 0 then 0 else cast,no_check(s32) ctx.skip_txfm[0]));
}

nonrd_pick_sb_modes :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    tile_data: *Tile_Data_Enc,
    X: *MACROBLOCK,
    mi_row: s32,
    mi_col: s32,
    rd_cost: *RD_COST,
    bsize: BLOCK_SIZE,
    ctx: *PICK_MODE_CONTEXT
) {
    CM := *cpi.common;
    TILE_INFO := *tile_data.tile_info;
    XD := *X.e_mbd;

    l, a: [48] ENTROPY_CONTEXT = ---;
    bs := cast,no_check(BLOCK_SIZE) ((ifx bsize > 3 then cast,no_check(s32) bsize else 3));
    NUM_4X4_BLOCKS_WIDE := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[bs];
    NUM_4X4_BLOCKS_HIGH := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[bs];

    set_offsets(cpi, TILE_INFO, X, mi_row, mi_col, bsize);

    set_segment_index(cpi, X, mi_row, mi_col, bsize, 0);

    X.skip_recode = 0;

    mi := XD.mi[0];
    mi.sb_type = bsize;

    for plane: 0..cast(s32) 3 - 1 {
        pd := XD.plane.data + plane;
        copy_memory(
            a.data + NUM_4X4_BLOCKS_WIDE * plane,
            pd.above_context,
            (size_of(ENTROPY_CONTEXT) * cast,no_check(u64) NUM_4X4_BLOCKS_WIDE) >> ((pd.subsampling_x) & 63)
        );
        copy_memory(
            l.data + NUM_4X4_BLOCKS_HIGH * plane,
            pd.left_context,
            (size_of(ENTROPY_CONTEXT) * cast,no_check(u64) NUM_4X4_BLOCKS_HIGH) >> ((pd.subsampling_y) & 63)
        );
    }

    if cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ && CM.seg.enabled != 0 {
        if cyclic_refresh_segment_id_boosted_in_vp9_encodeframe(cast,no_check(s32) mi.segment_id) != 0 {
            X.rdmult = vp9_cyclic_refresh_get_rdmult(cpi.cyclic_refresh);
        }
    }

    if frame_is_intra_only_in_vp9_encodeframe(CM) != 0 {
        hybrid_intra_mode_search(cpi, X, rd_cost, bsize, ctx);
    } else if cpi.svc.layer_context[cpi.svc.temporal_layer_id].is_key_frame != 0 {
        hybrid_search_svc_baseiskey(cpi, X, rd_cost, bsize, ctx, tile_data, mi_row, mi_col);
    } else if segfeature_active_in_vp9_encodeframe(
        *CM.seg,
        cast,no_check(s32) mi.segment_id,
        cast,no_check(SEG_LVL_FEATURES) SEG_LVL_SKIP
    ) != 0 {
        set_mode_info_seg_skip(X, CM.tx_mode, CM.interp_filter, rd_cost, bsize);
    } else if bsize >= 3 {
        if cpi.rc.hybrid_intra_scene_change != 0 {
            hybrid_search_scene_change(cpi, X, rd_cost, bsize, ctx, tile_data, mi_row, mi_col);
        } else {
            (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *MACROBLOCK, _: *Tile_Data_Enc, _: s32, _: s32, _: *RD_COST, _: BLOCK_SIZE, _: *PICK_MODE_CONTEXT)) (cast(*void) vp9_pick_inter_mode))(
                cpi,
                X,
                tile_data,
                mi_row,
                mi_col,
                rd_cost,
                bsize,
                ctx
            );
        }
    } else {
        (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *MACROBLOCK, _: s32, _: s32, _: *RD_COST, _: BLOCK_SIZE, _: *PICK_MODE_CONTEXT)) (cast(*void) vp9_pick_inter_mode_sub8x8))(
            cpi,
            X,
            mi_row,
            mi_col,
            rd_cost,
            bsize,
            ctx
        );
    }

    duplicate_mode_info_in_sb(CM, XD, mi_row, mi_col, bsize);

    for plane: 0..cast(s32) 3 - 1 {
        pd := XD.plane.data + plane;
        copy_memory(
            pd.above_context,
            a.data + NUM_4X4_BLOCKS_WIDE * plane,
            (size_of(ENTROPY_CONTEXT) * cast,no_check(u64) NUM_4X4_BLOCKS_WIDE) >> ((pd.subsampling_x) & 63)
        );
        copy_memory(
            pd.left_context,
            l.data + NUM_4X4_BLOCKS_HIGH * plane,
            (size_of(ENTROPY_CONTEXT) * cast,no_check(u64) NUM_4X4_BLOCKS_HIGH) >> ((pd.subsampling_y) & 63)
        );
    }

    if rd_cost.rate == 2147483647 {
        vp9_rd_cost_reset(rd_cost);
    }

    ctx.rate = rd_cost.rate;
    ctx.dist = rd_cost.dist;
}

duplicate_mode_info_in_sb :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) {
    BLOCK_WIDTH :=
        (ifx cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize] < cm.mi_cols -
            mi_col then cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize] else cm.mi_cols - mi_col);
    BLOCK_HEIGHT :=
        (ifx cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize] < cm.mi_rows -
            mi_row then cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize] else cm.mi_rows - mi_row);
    MI_STRIDE := xd.mi_stride;
    SRC_MI := xd.mi[0];
    i: s32 = ---;

    if 0 < BLOCK_HEIGHT {
        for j: 0..BLOCK_HEIGHT - 1 {
            i = 0;
            while i < BLOCK_WIDTH {
                xd.mi[j * MI_STRIDE + i] = SRC_MI;
                i += 1;
            }
        }
    }
}

hybrid_search_scene_change :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    X: *MACROBLOCK,
    rd_cost: *RD_COST,
    bsize: BLOCK_SIZE,
    ctx: *PICK_MODE_CONTEXT,
    tile_data: *Tile_Data_Enc,
    mi_row: s32,
    mi_col: s32
) {
    if cpi.sf.nonrd_keyframe == 0 && bsize <= 3 {
        (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *Macroblock, _: *RD_COST, _: BLOCK_SIZE, _: *PICK_MODE_CONTEXT, _: s64)) (cast(*void) vp9_rd_pick_intra_mode_sb))(
            cpi,
            X,
            rd_cost,
            bsize,
            ctx,
            9223372036854775807
        );
    } else {
        (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *MACROBLOCK, _: *Tile_Data_Enc, _: s32, _: s32, _: *RD_COST, _: BLOCK_SIZE, _: *PICK_MODE_CONTEXT)) (cast(*void) vp9_pick_inter_mode))(
            cpi,
            X,
            tile_data,
            mi_row,
            mi_col,
            rd_cost,
            bsize,
            ctx
        );
    }
}

set_mode_info_seg_skip :: (
    x: *MACROBLOCK,
    tx_mode: TX_MODE,
    interp_filter: INTERP_FILTER,
    rd_cost: *RD_COST,
    bsize: BLOCK_SIZE
) {
    XD := *x.e_mbd;
    MI := XD.mi[0];
    filter_ref := cast,no_check(INTERP_FILTER) get_pred_context_switchable_interp_in_vp9_encodeframe(XD);
    if interp_filter == 3 {
        filter_ref = 3;
    } else if filter_ref == 3 {
        filter_ref = 0;
    }

    MI.sb_type = bsize;
    MI.mode = 12;
    MI.tx_size =
        cast,no_check(TX_SIZE) ((ifx MAX_TXSIZE_LOOKUP[bsize] < TX_MODE_TO_BIGGEST_TX_SIZE[tx_mode] then cast,no_check(s32) MAX_TXSIZE_LOOKUP[bsize] else cast,no_check(s32) TX_MODE_TO_BIGGEST_TX_SIZE[tx_mode]));
    MI.skip = 1;
    MI.uv_mode = 0;
    MI.ref_frame[0] = 1;
    MI.ref_frame[1] = -1;
    MI.mv[0].as_int = 0;
    MI.interp_filter = filter_ref;

    XD.mi[0].bmi[0].as_mv[0].as_int = 0;
    x.skip = 1;

    vp9_rd_cost_init(rd_cost);
}

hybrid_search_svc_baseiskey :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    X: *MACROBLOCK,
    rd_cost: *RD_COST,
    bsize: BLOCK_SIZE,
    ctx: *PICK_MODE_CONTEXT,
    tile_data: *Tile_Data_Enc,
    mi_row: s32,
    mi_col: s32
) {
    if cpi.sf.nonrd_keyframe == 0 && bsize <= 3 {
        (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *Macroblock, _: *RD_COST, _: BLOCK_SIZE, _: *PICK_MODE_CONTEXT, _: s64)) (cast(*void) vp9_rd_pick_intra_mode_sb))(
            cpi,
            X,
            rd_cost,
            bsize,
            ctx,
            9223372036854775807
        );
    } else if cpi.svc.disable_inter_layer_pred == cast,no_check(u32) INTER_LAYER_PRED_OFF {
        (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *MACROBLOCK, _: *RD_COST, _: BLOCK_SIZE, _: *PICK_MODE_CONTEXT)) (cast(*void) vp9_pick_intra_mode))(
            cpi,
            X,
            rd_cost,
            bsize,
            ctx
        );
    } else if bsize >= 3 {
        (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *MACROBLOCK, _: *Tile_Data_Enc, _: s32, _: s32, _: *RD_COST, _: BLOCK_SIZE, _: *PICK_MODE_CONTEXT)) (cast(*void) vp9_pick_inter_mode))(
            cpi,
            X,
            tile_data,
            mi_row,
            mi_col,
            rd_cost,
            bsize,
            ctx
        );
    } else {
        (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *MACROBLOCK, _: s32, _: s32, _: *RD_COST, _: BLOCK_SIZE, _: *PICK_MODE_CONTEXT)) (cast(*void) vp9_pick_inter_mode_sub8x8))(
            cpi,
            X,
            mi_row,
            mi_col,
            rd_cost,
            bsize,
            ctx
        );
    }
}

hybrid_intra_mode_search :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    X: *MACROBLOCK,
    rd_cost: *RD_COST,
    bsize: BLOCK_SIZE,
    ctx: *PICK_MODE_CONTEXT
) {
    if cpi.sf.nonrd_keyframe == 0 && bsize < 6 {
        (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *Macroblock, _: *RD_COST, _: BLOCK_SIZE, _: *PICK_MODE_CONTEXT, _: s64)) (cast(*void) vp9_rd_pick_intra_mode_sb))(
            cpi,
            X,
            rd_cost,
            bsize,
            ctx,
            9223372036854775807
        );
    } else {
        (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *MACROBLOCK, _: *RD_COST, _: BLOCK_SIZE, _: *PICK_MODE_CONTEXT)) (cast(*void) vp9_pick_intra_mode))(
            cpi,
            X,
            rd_cost,
            bsize,
            ctx
        );
    }
}

nonrd_pick_partition :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    td: *Thread_Data_in_vp9_encoder,
    tile_data: *Tile_Data_Enc,
    tp: **TOKENEXTRA_in_vp9_cx_iface,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE,
    rd_cost: *RD_COST,
    do_recon: s32,
    best_rd: s64,
    pc_tree: *PC_TREE
) {
    SF := *cpi.sf;
    CM := *cpi.common;
    TILE_INFO := *tile_data.tile_info;
    X := *td.mb;
    XD := *X.e_mbd;
    MS := (cast(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize]) / 2;
    tp_orig := tp.*;
    ctx := *pc_tree.none;
    i: s32 = ---;
    subsize := bsize;
    this_rdc, sum_rdc, best_rdc: RD_COST = ---;
    do_split := cast(s32) (bsize >= 3);
    do_rect: s32 = 1;

    FORCE_HORZ_SPLIT := cast(s32) (mi_row + MS >= CM.mi_rows);
    FORCE_VERT_SPLIT := cast(s32) (mi_col + MS >= CM.mi_cols);
    XSS := X.e_mbd.plane[1].subsampling_x;
    YSS := X.e_mbd.plane[1].subsampling_y;

    partition_none_allowed := cast(s32) (FORCE_HORZ_SPLIT == 0 && FORCE_VERT_SPLIT == 0);
    partition_horz_allowed := cast(s32) (FORCE_VERT_SPLIT == 0 && YSS <= XSS && bsize >= 3);
    partition_vert_allowed := cast(s32) (FORCE_HORZ_SPLIT == 0 && XSS <= YSS && bsize >= 3);
    USE_ML_BASED_PARTITIONING := cast(s32) (SF.partition_search_type == cast,no_check(u32) ML_BASED_PARTITION);

    if cpi.oxcf.speed >= 5 {
        do_rect = 0;
    }

    vp9_rd_cost_init(*sum_rdc);
    vp9_rd_cost_reset(*best_rdc);
    best_rdc.rdcost = best_rd;

    if SF.auto_min_max_partition_size != 0 {
        partition_none_allowed &= cast(s32) (bsize <= X.max_partition_size && bsize >= X.min_partition_size);
        partition_horz_allowed &=
            cast(s32) (bsize <= X.max_partition_size && bsize > X.min_partition_size ||
                FORCE_HORZ_SPLIT != 0);
        partition_vert_allowed &=
            cast(s32) (bsize <= X.max_partition_size && bsize > X.min_partition_size ||
                FORCE_VERT_SPLIT != 0);
        do_split &= cast(s32) (bsize > X.min_partition_size);
    }
    if SF.use_square_partition_only != 0 {
        partition_horz_allowed &= FORCE_HORZ_SPLIT;
        partition_vert_allowed &= FORCE_VERT_SPLIT;
    }

    if USE_ML_BASED_PARTITIONING != 0 {
        if partition_none_allowed != 0 || do_split != 0 {
            do_rect = 0;
        }
        if partition_none_allowed != 0 && do_split != 0 {
            ML_PREDICTED_PARTITION := ml_predict_var_partitioning(cpi, X, bsize, mi_row, mi_col);
            if ML_PREDICTED_PARTITION == PARTITION_NONE {
                do_split = 0;
            }
            if ML_PREDICTED_PARTITION == PARTITION_SPLIT {
                partition_none_allowed = 0;
            }
        }
    }

    if partition_none_allowed == 0 && do_split == 0 {
        do_rect = 1;
    }

    ctx.pred_pixel_ready = cast(s32) (!(partition_vert_allowed != 0 || partition_horz_allowed != 0 || do_split != 0));

    if partition_none_allowed != 0 {
        nonrd_pick_sb_modes(cpi, tile_data, X, mi_row, mi_col, *this_rdc, bsize, ctx);
        assignment_28: MODE_INFO = XD.mi[0].*;
        ((*ctx.mic).*) = assignment_28;
        assignment_29: MB_MODE_INFO_EXT = X.mbmi_ext.*;
        ((*ctx.mbmi_ext).*) = assignment_29;
        ctx.skip_txfm[0] = X.skip_txfm[0];
        ctx.skip = X.skip;

        if this_rdc.rate != 2147483647 {
            PL := partition_plane_context_in_vp9_encodeframe(XD, mi_row, mi_col, bsize);
            this_rdc.rate += cpi.partition_cost[PL][PARTITION_NONE];
            this_rdc.rdcost =
                ((((cast,no_check(s64) this_rdc.rate) * cast(s64) X.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                    this_rdc.dist << ((X.rddiv) & 63);
            if this_rdc.rdcost < best_rdc.rdcost {
                assignment_30: RD_COST = this_rdc;
                ((*best_rdc).*) = assignment_30;
                if bsize >= 3 {
                    pc_tree.partitioning = cast,no_check(PARTITION_TYPE) PARTITION_NONE;
                }

                if USE_ML_BASED_PARTITIONING == 0 {
                    dist_breakout_thr := SF.partition_search_breakout_thr.dist;
                    rate_breakout_thr := cast,no_check(s64) SF.partition_search_breakout_thr.rate;
                    c_transpiler_compound_shr(*(dist_breakout_thr), (((cast,no_check(s64) (8 - ((cast(s32) B_WIDTH_LOG2_LOOKUP[bsize]) + cast(s32) B_HEIGHT_LOG2_LOOKUP[bsize]))) & 63)), s64, s64);
                    rate_breakout_thr *= cast,no_check(s64) NUM_PELS_LOG2_LOOKUP[bsize];
                    if X.e_mbd.lossless == 0 && cast,no_check(s64) this_rdc.rate < rate_breakout_thr && this_rdc.dist < dist_breakout_thr {
                        do_split = 0;
                        do_rect = 0;
                    }
                }
            }
        }
    }

    store_pred_mv(X, ctx);

    if do_split != 0 {
        pl := partition_plane_context_in_vp9_encodeframe(XD, mi_row, mi_col, bsize);
        sum_rdc.rate += cpi.partition_cost[pl][PARTITION_SPLIT];
        sum_rdc.rdcost =
            ((((cast,no_check(s64) sum_rdc.rate) * cast(s64) X.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                sum_rdc.dist << ((X.rddiv) & 63);
        subsize = get_subsize_in_vp9_encodeframe(bsize, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT);
        i = 0;
        while i < 4 && sum_rdc.rdcost < best_rdc.rdcost {
            X_IDX := i & 1 * MS;
            Y_IDX := i >> 1 * MS;

            if mi_row + Y_IDX >= CM.mi_rows || mi_col + X_IDX >= CM.mi_cols {
                i += 1;
                continue;
            }
            load_pred_mv(X, ctx);
            nonrd_pick_partition(
                cpi,
                td,
                tile_data,
                tp,
                mi_row + Y_IDX,
                mi_col + X_IDX,
                subsize,
                *this_rdc,
                0,
                best_rdc.rdcost - sum_rdc.rdcost,
                pc_tree.u.split[i]
            );

            if this_rdc.rate == 2147483647 {
                vp9_rd_cost_reset(*sum_rdc);
            } else {
                sum_rdc.rate += this_rdc.rate;
                sum_rdc.dist += this_rdc.dist;
                sum_rdc.rdcost += this_rdc.rdcost;
            }
            i += 1;
        }

        if sum_rdc.rdcost < best_rdc.rdcost {
            assignment_31: RD_COST = sum_rdc;
            ((*best_rdc).*) = assignment_31;
            pc_tree.partitioning = cast,no_check(PARTITION_TYPE) PARTITION_SPLIT;
        } else if SF.less_rectangular_check != 0 {
            do_rect &= cast(s32) (partition_none_allowed == 0);
        }
    }

    if partition_horz_allowed != 0 && do_rect != 0 {
        subsize = get_subsize_in_vp9_encodeframe(bsize, cast,no_check(PARTITION_TYPE) PARTITION_HORZ);
        load_pred_mv(X, ctx);
        pc_tree.horizontal[0].pred_pixel_ready = 1;
        nonrd_pick_sb_modes(cpi, tile_data, X, mi_row, mi_col, *sum_rdc, subsize, pc_tree.horizontal.data + 0);

        assignment_32: MODE_INFO = XD.mi[0].*;
        ((*pc_tree.horizontal[0].mic).*) = assignment_32;
        assignment_33: MB_MODE_INFO_EXT = X.mbmi_ext.*;
        ((*pc_tree.horizontal[0].mbmi_ext).*) = assignment_33;
        pc_tree.horizontal[0].skip_txfm[0] = X.skip_txfm[0];
        pc_tree.horizontal[0].skip = X.skip;

        if sum_rdc.rdcost < best_rdc.rdcost && mi_row + MS < CM.mi_rows {
            load_pred_mv(X, ctx);
            pc_tree.horizontal[1].pred_pixel_ready = 1;
            nonrd_pick_sb_modes(cpi, tile_data, X, mi_row + MS, mi_col, *this_rdc, subsize, pc_tree.horizontal.data + 1);

            assignment_34: MODE_INFO = XD.mi[0].*;
            ((*pc_tree.horizontal[1].mic).*) = assignment_34;
            assignment_35: MB_MODE_INFO_EXT = X.mbmi_ext.*;
            ((*pc_tree.horizontal[1].mbmi_ext).*) = assignment_35;
            pc_tree.horizontal[1].skip_txfm[0] = X.skip_txfm[0];
            pc_tree.horizontal[1].skip = X.skip;

            if this_rdc.rate == 2147483647 {
                vp9_rd_cost_reset(*sum_rdc);
            } else {
                pl := partition_plane_context_in_vp9_encodeframe(XD, mi_row, mi_col, bsize);
                this_rdc.rate += cpi.partition_cost[pl][PARTITION_HORZ];
                sum_rdc.rate += this_rdc.rate;
                sum_rdc.dist += this_rdc.dist;
                sum_rdc.rdcost =
                    ((((cast,no_check(s64) sum_rdc.rate) * cast(s64) X.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                        sum_rdc.dist << ((X.rddiv) & 63);
            }
        }

        if sum_rdc.rdcost < best_rdc.rdcost {
            assignment_36: RD_COST = sum_rdc;
            ((*best_rdc).*) = assignment_36;
            pc_tree.partitioning = cast,no_check(PARTITION_TYPE) PARTITION_HORZ;
        } else {
            pred_pixel_ready_reset(pc_tree, bsize);
        }
    }

    if partition_vert_allowed != 0 && do_rect != 0 {
        subsize = get_subsize_in_vp9_encodeframe(bsize, cast,no_check(PARTITION_TYPE) PARTITION_VERT);
        load_pred_mv(X, ctx);
        pc_tree.vertical[0].pred_pixel_ready = 1;
        nonrd_pick_sb_modes(cpi, tile_data, X, mi_row, mi_col, *sum_rdc, subsize, pc_tree.vertical.data + 0);
        assignment_37: MODE_INFO = XD.mi[0].*;
        ((*pc_tree.vertical[0].mic).*) = assignment_37;
        assignment_38: MB_MODE_INFO_EXT = X.mbmi_ext.*;
        ((*pc_tree.vertical[0].mbmi_ext).*) = assignment_38;
        pc_tree.vertical[0].skip_txfm[0] = X.skip_txfm[0];
        pc_tree.vertical[0].skip = X.skip;

        if sum_rdc.rdcost < best_rdc.rdcost && mi_col + MS < CM.mi_cols {
            load_pred_mv(X, ctx);
            pc_tree.vertical[1].pred_pixel_ready = 1;
            nonrd_pick_sb_modes(cpi, tile_data, X, mi_row, mi_col + MS, *this_rdc, subsize, pc_tree.vertical.data + 1);
            assignment_39: MODE_INFO = XD.mi[0].*;
            ((*pc_tree.vertical[1].mic).*) = assignment_39;
            assignment_40: MB_MODE_INFO_EXT = X.mbmi_ext.*;
            ((*pc_tree.vertical[1].mbmi_ext).*) = assignment_40;
            pc_tree.vertical[1].skip_txfm[0] = X.skip_txfm[0];
            pc_tree.vertical[1].skip = X.skip;

            if this_rdc.rate == 2147483647 {
                vp9_rd_cost_reset(*sum_rdc);
            } else {
                pl := partition_plane_context_in_vp9_encodeframe(XD, mi_row, mi_col, bsize);
                sum_rdc.rate += cpi.partition_cost[pl][PARTITION_VERT];
                sum_rdc.rate += this_rdc.rate;
                sum_rdc.dist += this_rdc.dist;
                sum_rdc.rdcost =
                    ((((cast,no_check(s64) sum_rdc.rate) * cast(s64) X.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                        sum_rdc.dist << ((X.rddiv) & 63);
            }
        }

        if sum_rdc.rdcost < best_rdc.rdcost {
            assignment_41: RD_COST = sum_rdc;
            ((*best_rdc).*) = assignment_41;
            pc_tree.partitioning = cast,no_check(PARTITION_TYPE) PARTITION_VERT;
        } else {
            pred_pixel_ready_reset(pc_tree, bsize);
        }
    }

    assignment_42: RD_COST = best_rdc;
    ((rd_cost).*) = assignment_42;

    if best_rdc.rate == 2147483647 {
        vp9_rd_cost_reset(rd_cost);
        return;
    }

    fill_mode_info_sb(CM, X, mi_row, mi_col, bsize, pc_tree);

    if best_rdc.rate < 2147483647 && best_rdc.dist < 9223372036854775807 && do_recon != 0 {
        output_enabled := cast(s32) (bsize == 12);
        encode_sb_rt(cpi, td, TILE_INFO, tp, mi_row, mi_col, output_enabled, bsize, pc_tree);
    }

    if bsize == 12 && do_recon != 0 {
    } else {
    }
}

fill_mode_info_sb :: (cm: *VP9_COMMON, x: *MACROBLOCK, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE, pc_tree: *PC_TREE) {
    xd: *MACROBLOCKD = ---;
    bsl: s32 = ---;
    hbs: s32 = ---;
    partition: PARTITION_TYPE = ---;
    subsize: BLOCK_SIZE = ---;
    code_block_to_execute: s64 = 43;
    while c_transpiler_dispatch := true {
        if code_block_to_execute < 0 break;
        if code_block_to_execute == {
            case 5; {
                break c_transpiler_dispatch;
            }
            case 11; {
                break c_transpiler_dispatch;
            }
            case 21; {
                break c_transpiler_dispatch;
            }
            case 43; {
                xd = *x.e_mbd;
                bsl = cast,no_check(s32) B_WIDTH_LOG2_LOOKUP[bsize];
                hbs = (cast(s32) 1) << ((bsl) & 31) / 4;
                partition = pc_tree.partitioning;
                subsize = get_subsize_in_vp9_encodeframe(bsize, partition);
                if mi_row >= cm.mi_rows || mi_col >= cm.mi_cols {
                    return;
                } else {
                    c_transpiler_switch_value_36 := partition;
                    if c_transpiler_switch_value_36 == {
                        case cast,no_check(u32) PARTITION_NONE; {
                            set_mode_info_offsets(cm, x, xd, mi_row, mi_col);
                            assignment_43: MODE_INFO = pc_tree.none.mic;
                            ((xd.mi[0]).*) = assignment_43;
                            assignment_44: MB_MODE_INFO_EXT = pc_tree.none.mbmi_ext;
                            ((x.mbmi_ext).*) = assignment_44;
                            duplicate_mode_info_in_sb(cm, xd, mi_row, mi_col, bsize);
                            break c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) PARTITION_VERT; {
                            set_mode_info_offsets(cm, x, xd, mi_row, mi_col);
                            assignment_45: MODE_INFO = pc_tree.vertical[0].mic;
                            ((xd.mi[0]).*) = assignment_45;
                            assignment_46: MB_MODE_INFO_EXT = pc_tree.vertical[0].mbmi_ext;
                            ((x.mbmi_ext).*) = assignment_46;
                            duplicate_mode_info_in_sb(cm, xd, mi_row, mi_col, subsize);
                            if mi_col + hbs < cm.mi_cols {
                                set_mode_info_offsets(cm, x, xd, mi_row, mi_col + hbs);
                                assignment_47: MODE_INFO = pc_tree.vertical[1].mic;
                                ((xd.mi[0]).*) = assignment_47;
                                assignment_48: MB_MODE_INFO_EXT = pc_tree.vertical[1].mbmi_ext;
                                ((x.mbmi_ext).*) = assignment_48;
                                duplicate_mode_info_in_sb(cm, xd, mi_row, mi_col + hbs, subsize);
                                code_block_to_execute = 21;
                                continue c_transpiler_dispatch;
                            } else {
                                code_block_to_execute = 21;
                                continue c_transpiler_dispatch;
                            }
                        }
                        case cast,no_check(u32) PARTITION_HORZ; {
                            set_mode_info_offsets(cm, x, xd, mi_row, mi_col);
                            assignment_49: MODE_INFO = pc_tree.horizontal[0].mic;
                            ((xd.mi[0]).*) = assignment_49;
                            assignment_50: MB_MODE_INFO_EXT = pc_tree.horizontal[0].mbmi_ext;
                            ((x.mbmi_ext).*) = assignment_50;
                            duplicate_mode_info_in_sb(cm, xd, mi_row, mi_col, subsize);
                            if mi_row + hbs < cm.mi_rows {
                                set_mode_info_offsets(cm, x, xd, mi_row + hbs, mi_col);
                                assignment_51: MODE_INFO = pc_tree.horizontal[1].mic;
                                ((xd.mi[0]).*) = assignment_51;
                                assignment_52: MB_MODE_INFO_EXT = pc_tree.horizontal[1].mbmi_ext;
                                ((x.mbmi_ext).*) = assignment_52;
                                duplicate_mode_info_in_sb(cm, xd, mi_row + hbs, mi_col, subsize);
                                code_block_to_execute = 11;
                                continue c_transpiler_dispatch;
                            } else {
                                code_block_to_execute = 11;
                                continue c_transpiler_dispatch;
                            }
                        }
                        case cast,no_check(u32) PARTITION_SPLIT; {
                            fill_mode_info_sb(cm, x, mi_row, mi_col, subsize, pc_tree.u.split[0]);
                            fill_mode_info_sb(cm, x, mi_row, mi_col + hbs, subsize, pc_tree.u.split[1]);
                            fill_mode_info_sb(cm, x, mi_row + hbs, mi_col, subsize, pc_tree.u.split[2]);
                            fill_mode_info_sb(cm, x, mi_row + hbs, mi_col + hbs, subsize, pc_tree.u.split[3]);
                            break c_transpiler_dispatch;
                        }
                        case; {
                            code_block_to_execute = 5;
                            continue c_transpiler_dispatch;
                        }
                    }
                }
            }
        }
        assert(false, tprint("invalid code block to execute %", code_block_to_execute));
        break;
    }
}

pred_pixel_ready_reset :: (pc_tree: *PC_TREE, bsize: BLOCK_SIZE) {
    pc_tree.none.pred_pixel_ready = 0;
    pc_tree.horizontal[0].pred_pixel_ready = 0;
    pc_tree.horizontal[1].pred_pixel_ready = 0;
    pc_tree.vertical[0].pred_pixel_ready = 0;
    pc_tree.vertical[1].pred_pixel_ready = 0;

    if bsize > 3 {
        subsize := get_subsize_in_vp9_encodeframe(bsize, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT);

        for i: 0..cast(s32) 4 - 1 {
            pred_pixel_ready_reset(pc_tree.u.split[i], subsize);
        }
    }
}

ml_predict_var_partitioning :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    bsize: BLOCK_SIZE,
    mi_row: s32,
    mi_col: s32
) -> s32 {
    CM := *cpi.common;
    nn_config: *NN_CONFIG = null;

    if cast,no_check(s32) bsize == {
        case 12;
            nn_config = *VP9_VAR_PART_NNCONFIG_64;
        case 9;
            nn_config = *VP9_VAR_PART_NNCONFIG_32;
        case 6;
            nn_config = *VP9_VAR_PART_NNCONFIG_16;
        case 3;
        case;
            return -1;
    }

    if nn_config == null {
        return -1;
    }

    {
        THRESH: float32 = (ifx cpi.oxcf.speed <= 5 then 1.25 else 0.0);
        features :=
            float32.[
                0.0,
                cast,no_check(float32) 0,
                cast,no_check(float32) 0,
                cast,no_check(float32) 0,
                cast,no_check(float32) 0,
                cast,no_check(float32) 0
            ];
        DC_Q := cast,no_check(s32) vp9_dc_quant(CM.base_qindex, 0, CM.bit_depth);
        feature_idx: s32 = 0;
        score: [2] float32 = ---;

        assignment_53: float32 = logf((cast,no_check(float32) (DC_Q * DC_Q)) / 256.0 + 1.0);
        (features[c_transpiler_post_increment(*(feature_idx))]) = assignment_53;
        vp9_setup_src_planes(x, cpi.source, mi_row, mi_col);
        {
            BS := 4 * cast(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[bsize];
            SUBSIZE := get_subsize_in_vp9_encodeframe(bsize, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT);
            SB_OFFSET_ROW := 8 * mi_row & 7;
            SB_OFFSET_COL := 8 * mi_col & 7;
            pred := x.est_pred.data + SB_OFFSET_ROW * 64 + SB_OFFSET_COL;
            src := x.plane[0].src.buf;
            SRC_STRIDE := x.plane[0].src.stride;
            PRED_STRIDE: s32 = 64;
            sse: u32 = ---;

            VAR := cpi.fn_ptr[bsize].vf(src, SRC_STRIDE, pred, PRED_STRIDE, *sse);
            FACTOR := (ifx VAR == 0 then 1.0 else 1.0 / cast,no_check(float32) VAR);

            assignment_54: float32 = logf((cast,no_check(float32) VAR) + 1.0);
            (features[c_transpiler_post_increment(*(feature_idx))]) = assignment_54;
            for i: 0..cast(s32) 4 - 1 {
                X_IDX := i & 1 * BS / 2;
                Y_IDX := i >> 1 * BS / 2;
                SRC_OFFSET := Y_IDX * SRC_STRIDE + X_IDX;
                PRED_OFFSET := Y_IDX * PRED_STRIDE + X_IDX;

                SUB_VAR :=
                    cpi.fn_ptr[SUBSIZE].vf(
                        src + SRC_OFFSET,
                        SRC_STRIDE,
                        pred + PRED_OFFSET,
                        PRED_STRIDE,
                        *sse
                    );
                VAR_RATIO := (ifx VAR == 0 then 1.0 else FACTOR * cast,no_check(float32) SUB_VAR);
                features[feature_idx] = VAR_RATIO;
                feature_idx += 1;
            }
        }

        nn_predict(features.data, nn_config, score.data);
        if c_transpiler_float_greater(score[0], THRESH) {
            return PARTITION_SPLIT;
        }
        if c_transpiler_float_less(score[0], -THRESH) {
            return PARTITION_NONE;
        }
        return -1;
    }
}

nonrd_use_partition :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    td: *Thread_Data_in_vp9_encoder,
    tile_data: *Tile_Data_Enc,
    mi: **MODE_INFO,
    tp: **TOKENEXTRA_in_vp9_cx_iface,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE,
    output_enabled: s32,
    dummy_cost: *RD_COST,
    pc_tree: *PC_TREE
) {
    CM := *cpi.common;
    tile_info := *tile_data.tile_info;
    X := *td.mb;
    XD := *X.e_mbd;
    BSL := cast,no_check(s32) B_WIDTH_LOG2_LOOKUP[bsize];
    HBS := (cast(s32) 1) << ((BSL) & 31) / 4;
    MIS := CM.mi_stride;

    if mi_row >= CM.mi_rows || mi_col >= CM.mi_cols {
        return;
    }

    subsize := cast,no_check(BLOCK_SIZE) ((ifx bsize >= 3 then cast,no_check(s32) mi[0].sb_type else 0));
    partition := (((cast(*[13] PARTITION_TYPE) *(PARTITION_LOOKUP))[BSL]).data)[subsize];

    if output_enabled != 0 && bsize != 0 {
        ctx := partition_plane_context_in_vp9_encodeframe(XD, mi_row, mi_col, bsize);
        td.counts.partition[ctx][partition] += 1;
    }

    if partition == {
        case cast,no_check(u32) PARTITION_NONE;
            pc_tree.none.pred_pixel_ready = 1;
            nonrd_pick_sb_modes(cpi, tile_data, X, mi_row, mi_col, dummy_cost, subsize, *pc_tree.none);
            assignment_55: MODE_INFO = XD.mi[0].*;
            ((*pc_tree.none.mic).*) = assignment_55;
            assignment_56: MB_MODE_INFO_EXT = X.mbmi_ext.*;
            ((*pc_tree.none.mbmi_ext).*) = assignment_56;
            pc_tree.none.skip_txfm[0] = X.skip_txfm[0];
            pc_tree.none.skip = X.skip;
            encode_b_rt(cpi, td, tile_info, tp, mi_row, mi_col, output_enabled, subsize, *pc_tree.none);
        case cast,no_check(u32) PARTITION_VERT;
            pc_tree.vertical[0].pred_pixel_ready = 1;
            nonrd_pick_sb_modes(cpi, tile_data, X, mi_row, mi_col, dummy_cost, subsize, pc_tree.vertical.data + 0);
            assignment_57: MODE_INFO = XD.mi[0].*;
            ((*pc_tree.vertical[0].mic).*) = assignment_57;
            assignment_58: MB_MODE_INFO_EXT = X.mbmi_ext.*;
            ((*pc_tree.vertical[0].mbmi_ext).*) = assignment_58;
            pc_tree.vertical[0].skip_txfm[0] = X.skip_txfm[0];
            pc_tree.vertical[0].skip = X.skip;
            encode_b_rt(cpi, td, tile_info, tp, mi_row, mi_col, output_enabled, subsize, pc_tree.vertical.data + 0);
            if mi_col + HBS < CM.mi_cols && bsize > 3 {
                pc_tree.vertical[1].pred_pixel_ready = 1;
                nonrd_pick_sb_modes(
                    cpi,
                    tile_data,
                    X,
                    mi_row,
                    mi_col + HBS,
                    dummy_cost,
                    subsize,
                    pc_tree.vertical.data + 1
                );
                assignment_59: MODE_INFO = XD.mi[0].*;
                ((*pc_tree.vertical[1].mic).*) = assignment_59;
                assignment_60: MB_MODE_INFO_EXT = X.mbmi_ext.*;
                ((*pc_tree.vertical[1].mbmi_ext).*) = assignment_60;
                pc_tree.vertical[1].skip_txfm[0] = X.skip_txfm[0];
                pc_tree.vertical[1].skip = X.skip;
                encode_b_rt(
                    cpi,
                    td,
                    tile_info,
                    tp,
                    mi_row,
                    mi_col + HBS,
                    output_enabled,
                    subsize,
                    pc_tree.vertical.data + 1
                );
            }
        case cast,no_check(u32) PARTITION_HORZ;
            pc_tree.horizontal[0].pred_pixel_ready = 1;
            nonrd_pick_sb_modes(cpi, tile_data, X, mi_row, mi_col, dummy_cost, subsize, pc_tree.horizontal.data + 0);
            assignment_61: MODE_INFO = XD.mi[0].*;
            ((*pc_tree.horizontal[0].mic).*) = assignment_61;
            assignment_62: MB_MODE_INFO_EXT = X.mbmi_ext.*;
            ((*pc_tree.horizontal[0].mbmi_ext).*) = assignment_62;
            pc_tree.horizontal[0].skip_txfm[0] = X.skip_txfm[0];
            pc_tree.horizontal[0].skip = X.skip;
            encode_b_rt(cpi, td, tile_info, tp, mi_row, mi_col, output_enabled, subsize, pc_tree.horizontal.data + 0);
            if mi_row + HBS < CM.mi_rows && bsize > 3 {
                pc_tree.horizontal[1].pred_pixel_ready = 1;
                nonrd_pick_sb_modes(
                    cpi,
                    tile_data,
                    X,
                    mi_row + HBS,
                    mi_col,
                    dummy_cost,
                    subsize,
                    pc_tree.horizontal.data + 1
                );
                assignment_63: MODE_INFO = XD.mi[0].*;
                ((*pc_tree.horizontal[1].mic).*) = assignment_63;
                assignment_64: MB_MODE_INFO_EXT = X.mbmi_ext.*;
                ((*pc_tree.horizontal[1].mbmi_ext).*) = assignment_64;
                pc_tree.horizontal[1].skip_txfm[0] = X.skip_txfm[0];
                pc_tree.horizontal[1].skip = X.skip;
                encode_b_rt(
                    cpi,
                    td,
                    tile_info,
                    tp,
                    mi_row + HBS,
                    mi_col,
                    output_enabled,
                    subsize,
                    pc_tree.horizontal.data + 1
                );
            }
        case;
            subsize = get_subsize_in_vp9_encodeframe(bsize, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT);
            if bsize == 3 {
                nonrd_pick_sb_modes(cpi, tile_data, X, mi_row, mi_col, dummy_cost, subsize, pc_tree.u.leaf_split[0]);
                encode_b_rt(cpi, td, tile_info, tp, mi_row, mi_col, output_enabled, subsize, pc_tree.u.leaf_split[0]);
            } else {
                nonrd_use_partition(
                    cpi,
                    td,
                    tile_data,
                    mi,
                    tp,
                    mi_row,
                    mi_col,
                    subsize,
                    output_enabled,
                    dummy_cost,
                    pc_tree.u.split[0]
                );
                nonrd_use_partition(
                    cpi,
                    td,
                    tile_data,
                    mi + HBS,
                    tp,
                    mi_row,
                    mi_col + HBS,
                    subsize,
                    output_enabled,
                    dummy_cost,
                    pc_tree.u.split[1]
                );
                nonrd_use_partition(
                    cpi,
                    td,
                    tile_data,
                    mi + HBS * MIS,
                    tp,
                    mi_row + HBS,
                    mi_col,
                    subsize,
                    output_enabled,
                    dummy_cost,
                    pc_tree.u.split[2]
                );
                nonrd_use_partition(
                    cpi,
                    td,
                    tile_data,
                    mi + HBS * MIS + HBS,
                    tp,
                    mi_row + HBS,
                    mi_col + HBS,
                    subsize,
                    output_enabled,
                    dummy_cost,
                    pc_tree.u.split[3]
                );
            }
    }

    if partition != cast,no_check(u32) PARTITION_SPLIT || bsize == 3 {
        update_partition_context_in_vp9_encodeframe(XD, mi_row, mi_col, subsize, bsize);
    }
}

get_estimated_pred :: (cpi: *VP9_COMP_in_vp9_encoder, TILE: *Tile_Info, x: *MACROBLOCK, mi_row: s32, mi_col: s32) {
    CM := *cpi.common;
    IS_KEY_FRAME := frame_is_intra_only_in_vp9_encodeframe(CM);
    xd := *x.e_mbd;

    set_offsets(cpi, TILE, x, mi_row, mi_col, 12);

    if IS_KEY_FRAME == 0 {
        mi := xd.mi[0];
        yv12 := get_ref_frame_buffer_in_vp9_encodeframe(cpi, 1);
        yv12_g: *YV12_BUFFER_CONFIG = null;
        BSIZE :=
            cast,no_check(BLOCK_SIZE) (9 + (cast(s32) (mi_col + 4 < CM.mi_cols)) * 2 +
                cast(s32) (mi_row + 4 < CM.mi_rows));
        y_sad_g: u32 = ---;
        y_sad: u32 = U32_MAX;

        if !(is_one_pass_svc_in_vp9_encodeframe(cpi) != 0 && cpi.svc.spatial_layer_id != 0) ||
            cpi.svc.use_gf_temporal_ref_current_layer != 0 {
            yv12_g = get_ref_frame_buffer_in_vp9_encodeframe(cpi, 2);
        }

        if cpi.oxcf.speed < 8 && yv12_g != null && yv12_g != yv12 && cpi.ref_frame_flags & cast,no_check(s32) (VP9_GOLD_FLAG) != 0 {
            vp9_setup_pre_planes(xd, 0, yv12_g, mi_row, mi_col, *CM.frame_refs[2 - 1].sf);
            y_sad_g =
                cpi.fn_ptr[BSIZE].sdf(
                    x.plane[0].src.buf,
                    x.plane[0].src.stride,
                    xd.plane[0].pre[0].buf,
                    xd.plane[0].pre[0].stride
                );
        } else {
            y_sad_g = U32_MAX;
        }

        if cpi.oxcf.lag_in_frames > 0 && cpi.oxcf.rc_mode == cast,no_check(u32) VBR && cpi.rc.is_src_frame_alt_ref != 0 {
            yv12 = get_ref_frame_buffer_in_vp9_encodeframe(cpi, 3);
            vp9_setup_pre_planes(xd, 0, yv12, mi_row, mi_col, *CM.frame_refs[3 - 1].sf);
            mi.ref_frame[0] = 3;
            y_sad_g = U32_MAX;
        } else {
            vp9_setup_pre_planes(xd, 0, yv12, mi_row, mi_col, *CM.frame_refs[1 - 1].sf);
            mi.ref_frame[0] = 1;
        }
        mi.ref_frame[1] = -1;
        mi.sb_type = 12;
        mi.mv[0].as_int = 0;
        mi.interp_filter = 3;

        {
            DUMMY_MV: MV;
            y_sad = vp9_int_pro_motion_estimation(cpi, x, BSIZE, mi_row, mi_col, *DUMMY_MV);
            x.sb_use_mv_part = 1;
            x.sb_mvcol_part = cast,no_check(s32) mi.mv[0].as_mv.col;
            x.sb_mvrow_part = cast,no_check(s32) mi.mv[0].as_mv.row;
        }

        y_sad_thr := (ifx cpi.sf.short_circuit_low_temp_var != 0 then (y_sad * 7) >> 3 else y_sad);
        if y_sad_g < y_sad_thr {
            vp9_setup_pre_planes(xd, 0, yv12_g, mi_row, mi_col, *CM.frame_refs[2 - 1].sf);
            mi.ref_frame[0] = 2;
            mi.mv[0].as_int = 0;
        } else {
            x.pred_mv[1] = mi.mv[0].as_mv;
        }

        set_ref_ptrs_in_vp9_encodeframe(CM, xd, mi.ref_frame[0], mi.ref_frame[1]);
        xd.plane[0].dst.buf = x.est_pred.data;
        xd.plane[0].dst.stride = 64;
        vp9_build_inter_predictors_sb(xd, mi_row, mi_col, 12);
    } else {
        fill_memory(x.est_pred.data, 128, cast,no_check(u64) (64 * 64));
    }
}

avg_source_sad :: (cpi: *VP9_COMP_in_vp9_encoder, x: *MACROBLOCK, shift: s32, sb_offset: s32) -> u64 {
    tmp_sse: u32 = ---;

    BSIZE: BLOCK_SIZE = 12;
    src_y := cpi.source.y_buffer;
    src_ystride := cpi.source.y_stride;
    last_src_y := cpi.last_source.y_buffer;
    last_src_ystride := cpi.last_source.y_stride;
    avg_source_sad_threshold: u64 = 10000;
    avg_source_sad_threshold2: u64 = 12000;

    src_y += shift;
    last_src_y += shift;
    tmp_sad := cast,no_check(u64) cpi.fn_ptr[BSIZE].sdf(src_y, src_ystride, last_src_y, last_src_ystride);
    tmp_variance := variance64x64_c(src_y, src_ystride, last_src_y, last_src_ystride, *tmp_sse);

    if tmp_sad < avg_source_sad_threshold {
        x.content_state_sb =
            cast,no_check(u8) ((ifx tmp_sse -
                tmp_variance < 25 then cast,no_check(s32) (K_LOW_SAD_LOW_SUMDIFF) else cast,no_check(s32) (K_LOW_SAD_HIGH_SUMDIFF)));
    } else {
        x.content_state_sb =
            cast,no_check(u8) ((ifx tmp_sse -
                tmp_variance < 25 then cast,no_check(s32) (K_HIGH_SAD_LOW_SUMDIFF) else cast,no_check(s32) (K_HIGH_SAD_HIGH_SUMDIFF)));
    }

    if cpi.oxcf.content != cast,no_check(u32) VP9E_CONTENT_SCREEN &&
        cpi.oxcf.rc_mode == cast,no_check(u32) CBR &&
        tmp_variance < tmp_sse >> 3 &&
        tmp_sse - tmp_variance > 10000 {
        x.content_state_sb = cast,no_check(u8) K_LOW_VAR_HIGH_SUMDIFF;
    } else if tmp_sad > avg_source_sad_threshold << 1 {
        x.content_state_sb = cast,no_check(u8) K_VERY_HIGH_SAD;
    }

    if cpi.content_state_sb_fd != null {
        if tmp_sad < avg_source_sad_threshold2 {
            if cpi.content_state_sb_fd[sb_offset] < 255 {
                cpi.content_state_sb_fd[sb_offset] += 1;
            }
        } else {
            cpi.content_state_sb_fd[sb_offset] = 0;
        }
    }
    if tmp_sad == 0 {
        x.zero_temp_sad_source = 1;
    }
    return tmp_sad;
}

vp9_init_tile_data :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    TILE_ROWS := (cast(s32) 1) << ((CM.log2_tile_rows) & 31);
    tile_col: s32 = ---;
    pre_tok := cpi.tile_tok[0][0];
    tplist := cpi.tplist[0][0];
    tile_tok: s64 = 0;
    tplist_count: s32 = 0;

    if cpi.tile_data == null || cpi.allocated_tiles < TILE_COLS * TILE_ROWS {
        if cpi.tile_data != null {
            vp9_row_mt_mem_dealloc(cpi);
            deallocate_memory(cast(*void) cpi.tile_data);
        }
        cpi.allocated_tiles = 0;
        cpi.tile_data =
            cast(*Tile_Data_Enc) allocate_memory(
                (cast,no_check(u64) (TILE_COLS * TILE_ROWS)) * size_of(Tile_Data_Enc)
            );

        if cpi.tile_data == null {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate cpi->tile_data")
            );
        }
        cpi.allocated_tiles = TILE_COLS * TILE_ROWS;

        if 0 < TILE_ROWS {
            for tile_row: 0..TILE_ROWS - 1 {
                tile_col = 0;
                while tile_col < TILE_COLS {
                    tile_data := *cpi.tile_data[tile_row * TILE_COLS + tile_col];
                    j: s32 = ---;
                    ZERO_MV: MV;
                    for i: 0..cast(s32) 13 - 1 {
                        j = 0;
                        while j < 30 {
                            tile_data.thresh_freq_fact[i][j] = 32;
                            tile_data.thresh_freq_fact_prev[i][j] = 32;
                            tile_data.mode_map[i][j] = cast,no_check(s8) j;
                            j += 1;
                        }
                    }
                    tile_data.firstpass_top_mv = ZERO_MV;

                    tile_data.row_base_thresh_freq_fact = null;
                    tile_col += 1;
                }
            }
        }
    }

    if 0 < TILE_ROWS {
        for tile_row: 0..TILE_ROWS - 1 {
            tile_col = 0;
            while tile_col < TILE_COLS {
                this_tile := *cpi.tile_data[tile_row * TILE_COLS + tile_col];
                tile_info := *this_tile.tile_info;
                if cpi.sf.adaptive_rd_thresh_row_mt != 0 {
                    vp9_row_mt_alloc_rd_thresh(cpi, this_tile);
                }
                vp9_tile_init(tile_info, CM, tile_row, tile_col);

                cpi.tile_tok[tile_row][tile_col] = pre_tok + tile_tok;
                pre_tok = cpi.tile_tok[tile_row][tile_col];
                tile_tok = allocated_tokens_in_vp9_encodeframe(tile_info.*);

                cpi.tplist[tile_row][tile_col] = tplist + tplist_count;
                tplist = cpi.tplist[tile_row][tile_col];
                tplist_count = get_num_vert_units_in_vp9_encodeframe(tile_info.*, cast,no_check(s32) (6 - 3));
                tile_col += 1;
            }
        }
    }
}

build_kmeans_segmentation :: (cpi: *VP9_COMP_in_vp9_encoder) {
    cm := *cpi.common;
    bsize: BLOCK_SIZE = 12;
    kmeans_data: *KMEANS_DATA = ---;

    vp9_disable_segmentation(*cm.seg);
    if cm.show_frame != 0 {
        mi_col: s32 = ---;
        cpi.kmeans_data_size = 0;
        cpi.kmeans_ctr_num = 8;

        mi_row: s32 = 0;
        while mi_row < cm.mi_rows {
            mi_col = 0;
            while mi_col < cm.mi_cols {
                mb_row_start := mi_row >> 1;
                mb_col_start := mi_col >> 1;
                mb_row_end :=
                    (ifx ((mi_row + cast(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize]) >> 1) < cm.mb_rows then (mi_row +
                        cast(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize]) >> 1 else cm.mb_rows);
                mb_col_end :=
                    (ifx ((mi_col + cast(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize]) >> 1) < cm.mb_cols then (mi_col +
                        cast(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize]) >> 1 else cm.mb_cols);
                col: s32 = ---;
                wiener_variance: s64 = 0;

                row := mb_row_start;
                while row < mb_row_end {
                    col = mb_col_start;
                    while col < mb_col_end {
                        wiener_variance += cpi.mb_wiener_variance[row * cm.mb_cols + col];
                        col += 1;
                    }
                    row += 1;
                }

                wiener_variance /= cast,no_check(s64) ((mb_row_end - mb_row_start) * (mb_col_end - mb_col_start));

                pthread_mutex_lock(*cpi.kmeans_mutex);

                kmeans_data = *cpi.kmeans_data_arr[c_transpiler_post_increment(*(cpi.kmeans_data_size))];
                kmeans_data.value = log_wiener_var(wiener_variance);
                kmeans_data.pos = mi_row * cpi.kmeans_data_stride + mi_col;

                pthread_mutex_unlock(*cpi.kmeans_mutex);
                mi_col += (cast(s32) 1) << (((6 - 3)) & 31);
            }
            mi_row += (cast(s32) 1) << (((6 - 3)) & 31);
        }

        vp9_kmeans(
            cpi.kmeans_ctr_ls.data,
            cpi.kmeans_boundary_ls.data,
            cpi.kmeans_count_ls.data,
            cpi.kmeans_ctr_num,
            cpi.kmeans_data_arr,
            cpi.kmeans_data_size
        );

        vp9_perceptual_aq_mode_setup(cpi, *cm.seg);
    }
}

vp9_kmeans :: (ctr_ls: *float64, boundary_ls: *float64, count_ls: *s32, k: s32, arr: *KMEANS_DATA, size: s32) {
    i: s32 = ---;

    group_idx: s32 = ---;
    sum: [8] float64 = ---;
    count: [8] s32 = ---;

    c_transpiler_qsort(
        cast(*void) arr,
        cast,no_check(u64) size,
        size_of(KMEANS_DATA),
        cast,no_check(Compar_Fn_T) compare_kmeans_data
    );

    if 0 < k {
        for j: 0..k - 1 {
            ctr_ls[j] = arr[size * (2 * j + 1) / (2 * k)].value;
        }
    }

    for itr: 0..cast(s32) 10 - 1 {
        compute_boundary_ls(ctr_ls, k, boundary_ls);
        i = 0;
        while i < 8 {
            sum[i] = 0.0;
            count[i] = 0;
            i += 1;
        }

        group_idx = 0;
        i = 0;
        while i < size {
            while c_transpiler_float_greater_equal(arr[i].value, boundary_ls[group_idx]) {
                group_idx += 1;
                if group_idx == k - 1 {
                    break;
                }
            }
            sum[group_idx] += arr[i].value;
            count[group_idx] += 1;
            i += 1;
        }

        group_idx = 0;
        while group_idx < k {
            if count[group_idx] > 0 {
                ctr_ls[group_idx] = sum[group_idx] / count[group_idx];
            }

            sum[group_idx] = 0.0;
            count[group_idx] = 0;
            group_idx += 1;
        }
    }

    if 0 < k {
        for j: 0..k - 1 {
            count_ls[j] = 0;
        }
    }
    compute_boundary_ls(ctr_ls, k, boundary_ls);
    group_idx = 0;
    i = 0;
    while i < size {
        while c_transpiler_float_greater_equal(arr[i].value, boundary_ls[group_idx]) {
            group_idx += 1;
            if group_idx == k - 1 {
                break;
            }
        }
        arr[i].group_idx = group_idx;
        count_ls[group_idx] += 1;
        i += 1;
    }
}

compute_boundary_ls :: (ctr_ls: *float64, k: s32, boundary_ls: *float64) {
    j: s32 = 0;
    while j < k - 1 {
        boundary_ls[j] = (ctr_ls[j] + ctr_ls[j + 1]) / 2.0;
        j += 1;
    }
    boundary_ls[k - 1] = 1.7976931348623157e308;
}

compare_kmeans_data :: (a: *void, b: *void) -> s32 {
    if c_transpiler_float_greater((cast(*KMEANS_DATA) a).value, (cast(*KMEANS_DATA) b).value) {
        return 1;
    } else if c_transpiler_float_less((cast(*KMEANS_DATA) a).value, (cast(*KMEANS_DATA) b).value) {
        return -1;
    } else {
        return 0;
    }
}

init_encode_frame_mb_context_in_vp9_encodeframe :: (cpi: *VP9_COMP_in_vp9_encoder) {
    X := *cpi.td.mb;
    CM := *cpi.common;
    XD := *X.e_mbd;
    ALIGNED_MI_COLS := mi_cols_aligned_to_sb_in_vp9_encodeframe(CM.mi_cols);

    vp9_setup_src_planes(X, cpi.source, 0, 0);

    vp9_setup_block_planes(*X.e_mbd, CM.subsampling_x, CM.subsampling_y);

    fill_memory(
        XD.above_context[0],
        0,
        (((cast,no_check(u64) (size_of(ENTROPY_CONTEXT))) * 2) * cast,no_check(u64) ALIGNED_MI_COLS) * 3
    );
    fill_memory(XD.above_seg_context, 0, cast,no_check(u64) ALIGNED_MI_COLS);
}

select_tx_mode :: (cpi: *VP9_COMP_in_vp9_encoder, XD: *MACROBLOCKD) -> TX_MODE {
    if XD.lossless != 0 {
        return cast,no_check(TX_MODE) ONLY_4X4;
    }
    if cpi.common.frame_type == cast,no_check(u32) KEY_FRAME && cpi.sf.use_nonrd_pick_mode != 0 {
        return cast,no_check(TX_MODE) ALLOW_16X16;
    }
    if cpi.sf.tx_size_search_method == cast,no_check(u32) USE_LARGESTALL {
        return cast,no_check(TX_MODE) ALLOW_32X32;
    } else if cpi.sf.tx_size_search_method == cast,no_check(u32) USE_FULL_RD ||
        cpi.sf.tx_size_search_method == cast,no_check(u32) USE_TX_8X8 {
        return cast,no_check(TX_MODE) TX_MODE_SELECT;
    } else {
        return cpi.common.tx_mode;
    }
}

reset_skip_tx_size :: (cm: *VP9_COMMON, max_tx_size: TX_SIZE) {
    mi_col: s32 = ---;
    MIS := cm.mi_stride;
    mi_ptr := cm.mi_grid_visible;

    mi_row: s32 = 0;
    while mi_row < cm.mi_rows {
        mi_col = 0;
        while mi_col < cm.mi_cols {
            if mi_ptr[mi_col].tx_size > max_tx_size {
                mi_ptr[mi_col].tx_size = max_tx_size;
            }
            mi_col += 1;
        }
        mi_row += 1;
        mi_ptr += MIS;
    }
}

get_frame_type :: (cpi: *VP9_COMP_in_vp9_encoder) -> MV_REFERENCE_FRAME {
    if frame_is_intra_only_in_vp9_encodeframe(*cpi.common) != 0 {
        return 0;
    } else if cpi.rc.is_src_frame_alt_ref != 0 && cpi.refresh_golden_frame != 0 {
        return 3;
    } else if cpi.refresh_golden_frame != 0 || cpi.refresh_alt_ref_frame != 0 {
        return 2;
    } else {
        return 1;
    }
}

get_interp_filter :: (threshes: *s64, is_alt_ref: s32) -> INTERP_FILTER {
    if is_alt_ref == 0 && threshes[1] > threshes[0] && threshes[1] > threshes[2] && threshes[1] > threshes[4 - 1] {
        return 1;
    } else if threshes[2] > threshes[0] && threshes[2] > threshes[4 - 1] {
        return 2;
    } else if threshes[0] > threshes[4 - 1] {
        return 0;
    } else {
        return 4;
    }
}

check_dual_ref_flags :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    REF_FLAGS := cpi.ref_frame_flags;

    if segfeature_active_in_vp9_encodeframe(*cpi.common.seg, 1, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME) != 0 {
        return 0;
    } else {
        if (((cast(s32) (REF_FLAGS & cast,no_check(s32) (VP9_GOLD_FLAG) != 0)) + cast(s32) (REF_FLAGS & cast,no_check(s32) (VP9_LAST_FLAG) != 0)) + cast(s32) (REF_FLAGS & cast,no_check(s32) (VP9_ALT_FLAG) != 0)) >= 2 {
            return 1;
        }
        return 0;
    }
}

restore_encode_params :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    j: s32 = ---;

    rd_opt := *cpi.rd;
    for i: 0..cast(s32) 4 - 1 {
        j = 0;
        while j < REFERENCE_MODES {
            rd_opt.prediction_type_threshes[i][j] = rd_opt.prediction_type_threshes_prev[i][j];
            j += 1;
        }

        j = 0;
        while j < 3 + 1 {
            rd_opt.filter_threshes[i][j] = rd_opt.filter_threshes_prev[i][j];
            j += 1;
        }
    }

    tile_idx: s32 = 0;
    while tile_idx < cpi.allocated_tiles {
        tile_data := *cpi.tile_data[tile_idx];
        {
            #assert tile_data.thresh_freq_fact.count * size_of([30] s32) == tile_data.thresh_freq_fact_prev.count * size_of([30] s32);

            copy_memory(
                tile_data.thresh_freq_fact.data,
                tile_data.thresh_freq_fact_prev.data,
                tile_data.thresh_freq_fact_prev.count * size_of([30] s32)
            );
        }
        tile_idx += 1;
    }

    CM.interp_filter = cpi.sf.default_interp_filter;
}

vp9_set_variance_partition_thresholds :: (cpi: *VP9_COMP_in_vp9_encoder, q: s32, content_state: s32) {
    CM := *cpi.common;
    SF := *cpi.sf;
    IS_KEY_FRAME := frame_is_intra_only_in_vp9_encodeframe(CM);
    if SF.partition_search_type != cast,no_check(u32) VAR_BASED_PARTITION &&
        SF.partition_search_type != cast,no_check(u32) REFERENCE_PARTITION {
        return;
    } else {
        set_vbp_thresholds(cpi, cpi.vbp_thresholds.data, q, content_state);

        if IS_KEY_FRAME != 0 {
            cpi.vbp_threshold_sad = 0;
            cpi.vbp_threshold_copy = 0;
            cpi.vbp_bsize_min = 3;
        } else {
            if CM.width <= 352 && CM.height <= 288 {
                cpi.vbp_threshold_sad = 10;
            } else {
                cpi.vbp_threshold_sad =
                    cast,no_check(s64) ((ifx (cast(s32) cpi.y_dequant[q][1]) << 1 > 1000 then (cast(s32) cpi.y_dequant[q][1]) << 1 else 1000));
            }
            cpi.vbp_bsize_min = 6;
            if CM.width <= 352 && CM.height <= 288 {
                cpi.vbp_threshold_copy = 4000;
            } else if CM.width <= 640 && CM.height <= 360 {
                cpi.vbp_threshold_copy = 8000;
            } else {
                cpi.vbp_threshold_copy =
                    cast,no_check(s64) ((ifx (cast(s32) cpi.y_dequant[q][1]) << 3 > 8000 then (cast(s32) cpi.y_dequant[q][1]) << 3 else 8000));
            }
            if cpi.rc.high_source_sad != 0 || cpi.use_svc != 0 && cpi.svc.high_source_sad_superframe != 0 {
                cpi.vbp_threshold_sad = 0;
                cpi.vbp_threshold_copy = 0;
            }
        }
        cpi.vbp_threshold_minmax = cast,no_check(s64) (15 + q >> 3);
    }
}

globals_initialization_state_for_vp9_encodeframe: u32;
initialize_globals_for_vp9_encodeframe :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_encodeframe);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_encodeframe, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_encodeframe) != 2 {}
            return;
        }
    }
    K_VP9_REF_FLAG_LIST_in_vp9_encodeframe =
        s32.[ 0, cast,no_check(s32) (VP9_LAST_FLAG), cast,no_check(s32) (VP9_GOLD_FLAG), cast,no_check(s32) (VP9_ALT_FLAG) ];
    SUB_PEL_FILTERS_12_in_vp9_encodeframe =
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
    COUNT_TO_UPDATE_FACTOR_in_vp9_encodeframe =
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
    COSPI_1_64_in_vp9_encodeframe = 16364;
    COSPI_2_64_in_vp9_encodeframe = 16305;
    COSPI_3_64_in_vp9_encodeframe = 16207;
    COSPI_4_64_in_vp9_encodeframe = 16069;
    COSPI_5_64_in_vp9_encodeframe = 15893;
    COSPI_6_64_in_vp9_encodeframe = 15679;
    COSPI_7_64_in_vp9_encodeframe = 15426;
    COSPI_8_64_in_vp9_encodeframe = 15137;
    COSPI_9_64_in_vp9_encodeframe = 14811;
    COSPI_10_64_in_vp9_encodeframe = 14449;
    COSPI_11_64_in_vp9_encodeframe = 14053;
    COSPI_12_64_in_vp9_encodeframe = 13623;
    COSPI_13_64_in_vp9_encodeframe = 13160;
    COSPI_14_64_in_vp9_encodeframe = 12665;
    COSPI_15_64_in_vp9_encodeframe = 12140;
    COSPI_16_64_in_vp9_encodeframe = 11585;
    COSPI_17_64_in_vp9_encodeframe = 11003;
    COSPI_18_64_in_vp9_encodeframe = 10394;
    COSPI_19_64_in_vp9_encodeframe = 9760;
    COSPI_20_64_in_vp9_encodeframe = 9102;
    COSPI_21_64_in_vp9_encodeframe = 8423;
    COSPI_22_64_in_vp9_encodeframe = 7723;
    COSPI_23_64_in_vp9_encodeframe = 7005;
    COSPI_24_64_in_vp9_encodeframe = 6270;
    COSPI_25_64_in_vp9_encodeframe = 5520;
    COSPI_26_64_in_vp9_encodeframe = 4756;
    COSPI_27_64_in_vp9_encodeframe = 3981;
    COSPI_28_64_in_vp9_encodeframe = 3196;
    COSPI_29_64_in_vp9_encodeframe = 2404;
    COSPI_30_64_in_vp9_encodeframe = 1606;
    COSPI_31_64_in_vp9_encodeframe = 804;
    SINPI_1_9_in_vp9_encodeframe = 5283;
    SINPI_2_9_in_vp9_encodeframe = 9929;
    SINPI_3_9_in_vp9_encodeframe = 13377;
    SINPI_4_9_in_vp9_encodeframe = 15212;
    MODE_2_COUNTER_in_vp9_encodeframe =
        s32.[
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            0,
            0,
            3,
            1
        ];
    COUNTER_TO_CONTEXT_in_vp9_encodeframe =
        s32.[
            cast,no_check(s32) (BOTH_PREDICTED),
            cast,no_check(s32) (NEW_PLUS_NON_INTRA),
            cast,no_check(s32) (BOTH_NEW),
            cast,no_check(s32) (ZERO_PLUS_PREDICTED),
            cast,no_check(s32) (NEW_PLUS_NON_INTRA),
            cast,no_check(s32) (INVALID_CASE),
            cast,no_check(s32) (BOTH_ZERO),
            cast,no_check(s32) (INVALID_CASE),
            cast,no_check(s32) (INVALID_CASE),
            cast,no_check(s32) (INTRA_PLUS_NON_INTRA),
            cast,no_check(s32) (INTRA_PLUS_NON_INTRA),
            cast,no_check(s32) (INVALID_CASE),
            cast,no_check(s32) (INTRA_PLUS_NON_INTRA),
            cast,no_check(s32) (INVALID_CASE),
            cast,no_check(s32) (INVALID_CASE),
            cast,no_check(s32) (INVALID_CASE),
            cast,no_check(s32) (INVALID_CASE),
            cast,no_check(s32) (INVALID_CASE),
            cast,no_check(s32) (BOTH_INTRA)
        ];
    MV_REF_BLOCKS_in_vp9_encodeframe =
        [8] POSITION.[
            POSITION.[ POSITION.{row = -1, col = 0}, POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = -1}, POSITION.{row = -2, col = 0}, POSITION.{row = 0, col = -2}, POSITION.{row = -2, col = -1}, POSITION.{row = -1, col = -2}, POSITION.{row = -2, col = -2} ],
            POSITION.[ POSITION.{row = -1, col = 0}, POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = -1}, POSITION.{row = -2, col = 0}, POSITION.{row = 0, col = -2}, POSITION.{row = -2, col = -1}, POSITION.{row = -1, col = -2}, POSITION.{row = -2, col = -2} ],
            POSITION.[ POSITION.{row = -1, col = 0}, POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = -1}, POSITION.{row = -2, col = 0}, POSITION.{row = 0, col = -2}, POSITION.{row = -2, col = -1}, POSITION.{row = -1, col = -2}, POSITION.{row = -2, col = -2} ],
            POSITION.[ POSITION.{row = -1, col = 0}, POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = -1}, POSITION.{row = -2, col = 0}, POSITION.{row = 0, col = -2}, POSITION.{row = -2, col = -1}, POSITION.{row = -1, col = -2}, POSITION.{row = -2, col = -2} ],
            POSITION.[ POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = 0}, POSITION.{row = 1, col = -1}, POSITION.{row = -1, col = -1}, POSITION.{row = 0, col = -2}, POSITION.{row = -2, col = 0}, POSITION.{row = -2, col = -1}, POSITION.{row = -1, col = -2} ],
            POSITION.[ POSITION.{row = -1, col = 0}, POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = 1}, POSITION.{row = -1, col = -1}, POSITION.{row = -2, col = 0}, POSITION.{row = 0, col = -2}, POSITION.{row = -1, col = -2}, POSITION.{row = -2, col = -1} ],
            POSITION.[ POSITION.{row = -1, col = 0}, POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = 1}, POSITION.{row = 1, col = -1}, POSITION.{row = -1, col = -1}, POSITION.{row = -3, col = 0}, POSITION.{row = 0, col = -3}, POSITION.{row = -3, col = -3} ],
            POSITION.[ POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = 0}, POSITION.{row = 2, col = -1}, POSITION.{row = -1, col = -1}, POSITION.{row = -1, col = 1}, POSITION.{row = 0, col = -3}, POSITION.{row = -3, col = 0}, POSITION.{row = -3, col = -3} ],
            POSITION.[ POSITION.{row = -1, col = 0}, POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = 2}, POSITION.{row = -1, col = -1}, POSITION.{row = 1, col = -1}, POSITION.{row = -3, col = 0}, POSITION.{row = 0, col = -3}, POSITION.{row = -3, col = -3} ],
            POSITION.[ POSITION.{row = -1, col = 1}, POSITION.{row = 1, col = -1}, POSITION.{row = -1, col = 2}, POSITION.{row = 2, col = -1}, POSITION.{row = -1, col = -1}, POSITION.{row = -3, col = 0}, POSITION.{row = 0, col = -3}, POSITION.{row = -3, col = -3} ],
            POSITION.[ POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = 0}, POSITION.{row = 4, col = -1}, POSITION.{row = -1, col = 2}, POSITION.{row = -1, col = -1}, POSITION.{row = 0, col = -3}, POSITION.{row = -3, col = 0}, POSITION.{row = 2, col = -1} ],
            POSITION.[ POSITION.{row = -1, col = 0}, POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = 4}, POSITION.{row = 2, col = -1}, POSITION.{row = -1, col = -1}, POSITION.{row = -3, col = 0}, POSITION.{row = 0, col = -3}, POSITION.{row = -1, col = 2} ],
            POSITION.[ POSITION.{row = -1, col = 3}, POSITION.{row = 3, col = -1}, POSITION.{row = -1, col = 4}, POSITION.{row = 4, col = -1}, POSITION.{row = -1, col = -1}, POSITION.{row = -1, col = 0}, POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = 6} ]
        ];
    IDX_N_COLUMN_TO_SUBBLOCK_in_vp9_encodeframe =
        [2] s32.[
            s32.[ 1, 2 ],
            s32.[ 1, 3 ],
            s32.[ 3, 2 ],
            s32.[ 3, 3 ]
        ];
    FRAME_SCALE_FACTOR_in_vp9_encodeframe = s32.[ 16, 24 ];
    RATE_THRESH_MULT_in_vp9_encodeframe = float64.[ 1.0, 2.0 ];
    RCF_MULT_in_vp9_encodeframe = float64.[ 1.0, 2.0 ];
    VP9_VAR_OFFS =
        u8.[
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128
        ];
    MIN_PARTITION_SIZE =
        BLOCK_SIZE.[
            0,
            0,
            0,
            0,
            0,
            0,
            3,
            3,
            3,
            6,
            6,
            6,
            6
        ];
    MAX_PARTITION_SIZE =
        BLOCK_SIZE.[
            3,
            6,
            6,
            6,
            9,
            9,
            9,
            12,
            12,
            12,
            12,
            12,
            12
        ];
    NEXT_SQUARE_SIZE =
        BLOCK_SIZE.[
            0,
            0,
            0,
            3,
            3,
            3,
            6,
            6,
            6,
            9,
            9,
            9,
            12
        ];
    VP9_PARTITION_BREAKOUT_WEIGHTS_64 =
        [3] [5] float32.[
            [5] float32.[ float32.[ cast(float32) -0.016673000529408456, cast(float32) -0.001025000005029142, cast(float32) -0.00003199999991920777, 0.000833, cast(float32) -0.1573810577392578 ], float32.[ cast(float32) -0.16086700558662415, cast(float32) -0.0021009999327361585, 0.000011, 0.002448, cast(float32) -0.8426185846328735 ], float32.[ cast(float32) -0.6289340257644653, cast(float32) -0.011459000408649445, cast(float32) -0.000009000000318337698, 0.013833, cast(float32) -0.12017357349395752 ] ],
            [5] float32.[ float32.[ cast(float32) -0.0643090009689331, cast(float32) -0.006120999809354544, 0.000232, 0.005778, cast(float32) -4.201053619384766 ], float32.[ cast(float32) -0.31495699286460879, cast(float32) -0.009345999918878079, cast(float32) -0.00022499999613501132, 0.010072, cast(float32) -2.6930441856384279 ], float32.[ cast(float32) -0.6355350017547607, cast(float32) -0.015135000459849835, 0.000091, 0.015247, cast(float32) -2.0961875915527345 ] ]
        ];
    VP9_PARTITION_BREAKOUT_WEIGHTS_32 =
        [3] [5] float32.[
            [5] float32.[ float32.[ cast(float32) -0.010553999803960324, cast(float32) -0.003080999944359064, cast(float32) -0.0001340000017080456, 0.004491, cast(float32) -1.815540075302124 ], float32.[ cast(float32) -0.05148899927735329, cast(float32) -0.007608999963849783, 0.000016, 0.009792, cast(float32) -1.2191059589385987 ], float32.[ cast(float32) -0.16309699416160584, cast(float32) -0.013081000186502934, 0.000022, 0.019006, cast(float32) -1.8387060165405274 ] ],
            [5] float32.[ float32.[ cast(float32) -0.024629000574350358, cast(float32) -0.006492000073194504, cast(float32) -0.00025400001322850585, 0.004895, cast(float32) -3.220808267593384 ], float32.[ cast(float32) -0.08393599838018418, cast(float32) -0.009827000088989735, cast(float32) -0.00019999999494757503, 0.010399, cast(float32) -1.7626893520355225 ], float32.[ cast(float32) -0.2790519893169403, cast(float32) -0.013333999551832676, 0.000289, 0.023203, cast(float32) -1.0640428066253663 ] ]
        ];
    VP9_PARTITION_BREAKOUT_WEIGHTS_16 =
        [3] [5] float32.[
            [5] float32.[ float32.[ cast(float32) -0.013154000043869019, cast(float32) -0.002403999911621213, cast(float32) -0.0009769999887794257, 0.008450, cast(float32) -2.9259543418884279 ], float32.[ cast(float32) -0.01914599910378456, cast(float32) -0.004017999861389399, 0.000064, 0.008187, cast(float32) -0.3495607376098633 ], float32.[ cast(float32) -0.07575500011444092, cast(float32) -0.010858000256121159, 0.000030, 0.024505, cast(float32) -0.4315187931060791 ] ],
            [5] float32.[ float32.[ cast(float32) -0.00763599993661046, cast(float32) -0.002750999992713332, cast(float32) -0.0006820000126026571, 0.005968, cast(float32) -4.307742595672607 ], float32.[ cast(float32) -0.04730600118637085, cast(float32) -0.009112999774515629, cast(float32) -0.0005179999861866236, 0.016007, cast(float32) -1.3893113136291505 ], float32.[ cast(float32) -0.06933599710464478, cast(float32) -0.010448000393807888, cast(float32) -0.001120000029914081, 0.023083, cast(float32) -4.024089336395264 ] ]
        ];
    VP9_PARTITION_BREAKOUT_WEIGHTS_8 =
        [3] [5] float32.[
            [5] float32.[ float32.[ cast(float32) -0.011807000264525414, cast(float32) -0.009872999973595143, cast(float32) -0.0009309999877586961, 0.034768, cast(float32) -0.677451491355896 ], float32.[ cast(float32) -0.0038610000628978016, cast(float32) -0.002701000077649951, 0.000100, 0.013876, cast(float32) 0.4675511121749878 ], float32.[ cast(float32) -0.013522000052034855, cast(float32) -0.008677000179886818, cast(float32) -0.0005619999719783664, 0.034468, cast(float32) 0.03440356254577637 ] ],
            [5] float32.[ float32.[ cast(float32) -0.0032210000790655615, cast(float32) -0.0021250001154839994, 0.000993, 0.012768, cast(float32) -1.964585781097412 ], float32.[ cast(float32) -0.006068999879062176, cast(float32) -0.007335000205785036, 0.000229, 0.026104, cast(float32) -1.3286468982696534 ], float32.[ cast(float32) -0.03989399969577789, cast(float32) -0.01141900010406971, 0.000070, 0.061817, cast(float32) -0.826002299785614 ] ]
        ];
    VP9_RECT_PART_NN_WEIGHTS_16_LAYER0 =
        float32.[
            cast(float32) -0.4325219988822937,
            0.133070,
            cast(float32) -0.16918699443340302,
            0.768340,
            0.891228,
            0.554458,
            0.356000,
            0.403621,
            0.809165,
            0.778214,
            cast(float32) -0.5203570127487183,
            0.301451,
            cast(float32) -0.38697201013565066,
            cast(float32) -0.3144020140171051,
            0.021878,
            1.148746,
            cast(float32) -0.4622580111026764,
            cast(float32) -0.17552399635314942,
            cast(float32) -0.3445889949798584,
            cast(float32) -0.4751589894294739,
            cast(float32) -0.23232200741767884,
            0.471147,
            cast(float32) -0.48994800448417666,
            0.467740,
            cast(float32) -0.3915500044822693,
            0.208601,
            0.054138,
            0.076859,
            cast(float32) -0.30949699878692629,
            cast(float32) -0.09592700004577637,
            0.225917,
            0.011582,
            cast(float32) -0.5207300186157227,
            cast(float32) -0.5854970216751099,
            0.174036,
            0.072521,
            0.120771,
            cast(float32) -0.5172340273857117,
            cast(float32) -0.5819079875946045,
            cast(float32) -0.03400300070643425,
            cast(float32) -0.6947219967842102,
            cast(float32) -0.3643679916858673,
            0.290584,
            0.038373,
            0.685654,
            0.394019,
            0.759667,
            1.257502,
            cast(float32) -0.6105160117149353,
            cast(float32) -0.1854339987039566,
            0.211997,
            cast(float32) -0.1724579930305481,
            0.044605,
            0.145316,
            cast(float32) -0.18252499401569367,
            cast(float32) -0.14737600088119508,
            0.578742,
            0.312412,
            cast(float32) -0.446135014295578,
            cast(float32) -0.3891119956970215,
            0.454033,
            0.260490,
            0.664285,
            0.395856,
            cast(float32) -0.2318270057439804,
            0.215228,
            0.014856,
            cast(float32) -0.3954620063304901,
            0.479646,
            cast(float32) -0.39144501090049746,
            cast(float32) -0.35778799653053286,
            0.166238,
            cast(float32) -0.056818000972270969,
            cast(float32) -0.027783000841736795,
            0.060880,
            cast(float32) -1.6047099828720093,
            0.531268,
            0.282184,
            0.714944,
            0.093523,
            cast(float32) -0.21831199526786805,
            cast(float32) -0.09554599970579148,
            cast(float32) -0.2856209874153137,
            cast(float32) -0.190871000289917,
            cast(float32) -0.4483399987220764,
            cast(float32) -0.016611000522971154,
            0.413913,
            cast(float32) -0.28672000765800478,
            cast(float32) -0.158828005194664,
            cast(float32) -0.09263499826192856,
            cast(float32) -0.2795509994029999,
            0.166509,
            cast(float32) -0.08816199749708176,
            0.446543,
            cast(float32) -0.2768299877643585,
            cast(float32) -0.06564199924468994,
            cast(float32) -0.17634600400924684,
            cast(float32) -0.9847540259361267,
            0.338738,
            0.403809,
            0.738065,
            1.154439,
            0.750764,
            0.770959,
            cast(float32) -0.26940301060676577,
            0.295651,
            cast(float32) -0.3318580090999603,
            0.367144,
            0.279279,
            0.157419,
            cast(float32) -0.34822699427604678,
            cast(float32) -0.16860799491405488,
            cast(float32) -0.9559999704360962,
            cast(float32) -0.6471359729766846,
            0.250516,
            0.858084,
            0.809802,
            0.492408,
            0.804841,
            0.282802,
            0.079395,
            cast(float32) -0.2917709946632385,
            cast(float32) -0.024382000789046289,
            cast(float32) -1.615880012512207,
            cast(float32) -0.4451659917831421,
            cast(float32) -0.4073350131511688,
            cast(float32) -0.48304399847984316,
            0.141126
        ];
    VP9_RECT_PART_NN_BIAS_16_LAYER0 =
        float32.[
            0.275384,
            cast(float32) -0.053745001554489139,
            0.000000,
            0.000000,
            cast(float32) -0.1781029999256134,
            0.513965,
            cast(float32) -0.1613519936800003,
            0.228551,
            0.000000,
            1.013712,
            0.000000,
            0.000000,
            cast(float32) -1.144008994102478,
            cast(float32) -0.000006000000212225132,
            cast(float32) -0.24172699451446534,
            2.048764
        ];
    VP9_RECT_PART_NN_WEIGHTS_16_LAYER1 =
        float32.[
            cast(float32) -1.435278058052063,
            2.204691,
            cast(float32) -0.41071799397468569,
            0.202708,
            0.109208,
            1.059142,
            cast(float32) -0.30636000633239748,
            0.845906,
            0.489654,
            cast(float32) -1.1219149827957154,
            cast(float32) -0.1691329926252365,
            cast(float32) -0.003384999930858612,
            0.660590,
            cast(float32) -0.018711000680923463,
            1.227158,
            cast(float32) -2.9675040245056154,
            1.407345,
            cast(float32) -1.2932430505752564,
            cast(float32) -0.3869209885597229,
            0.300492,
            0.338824,
            cast(float32) -0.0832500010728836,
            cast(float32) -0.06945399940013886,
            cast(float32) -1.0018270015716553,
            cast(float32) -0.3278909921646118,
            0.899353,
            0.367397,
            cast(float32) -0.1186010017991066,
            cast(float32) -0.1719360053539276,
            cast(float32) -0.4206460118293762,
            cast(float32) -0.803318977355957,
            2.029634,
            0.940268,
            cast(float32) -0.6644840240478516,
            0.339916,
            0.315944,
            0.157374,
            cast(float32) -0.4024820029735565,
            cast(float32) -0.49169498682022097,
            0.595827,
            0.015031,
            0.255887,
            cast(float32) -0.4663270115852356,
            cast(float32) -0.21259799599647523,
            0.136485,
            0.033363,
            cast(float32) -0.7969210147857666,
            1.414304,
            cast(float32) -0.28218498826026919,
            cast(float32) -2.6735711097717287,
            cast(float32) -0.2809939980506897,
            0.382658,
            cast(float32) -0.3509019911289215,
            0.227926,
            0.062602,
            cast(float32) -1.0001989603042603,
            0.433731,
            1.176439,
            cast(float32) -0.1632159948348999,
            cast(float32) -0.22901499271392823,
            cast(float32) -0.640097975730896,
            cast(float32) -0.4388520121574402,
            cast(float32) -0.947700023651123,
            2.203434
        ];
    VP9_RECT_PART_NN_BIAS_16_LAYER1 =
        float32.[ cast(float32) -0.8755099773406982, 0.982408, 0.560854, cast(float32) -0.41520899534225466 ];
    VP9_RECT_PART_NNCONFIG_16 =
        NN_CONFIG.{
            num_inputs = 8,
            num_outputs = 4,
            num_hidden_layers = 1,
            num_hidden_nodes =
                s32.[ 16, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0 ],
            weights =
                *float32.[ VP9_RECT_PART_NN_WEIGHTS_16_LAYER0.data, VP9_RECT_PART_NN_WEIGHTS_16_LAYER1.data, null, null, null, null, null, null, null, null, null ],
            bias =
                *float32.[ VP9_RECT_PART_NN_BIAS_16_LAYER0.data, VP9_RECT_PART_NN_BIAS_16_LAYER1.data, null, null, null, null, null, null, null, null, null ]
        };
    VP9_RECT_PART_NN_WEIGHTS_32_LAYER0 =
        float32.[
            cast(float32) -0.1473120003938675,
            cast(float32) -0.7532479763031006,
            0.540206,
            0.661415,
            0.484117,
            cast(float32) -0.34160900115966799,
            0.016183,
            0.064177,
            0.781580,
            0.902232,
            cast(float32) -0.5053420066833496,
            0.325183,
            cast(float32) -0.23107199370861054,
            cast(float32) -0.120107002556324,
            cast(float32) -0.07621599733829498,
            0.120038,
            0.403695,
            cast(float32) -0.46330100297927859,
            cast(float32) -0.19215799868106843,
            0.407442,
            0.106633,
            1.072371,
            cast(float32) -0.4467790126800537,
            0.467353,
            0.318812,
            cast(float32) -0.5059959888458252,
            cast(float32) -0.008767999708652497,
            cast(float32) -0.23959800601005555,
            0.085480,
            0.284640,
            cast(float32) -0.3650450110435486,
            cast(float32) -0.048082999885082248,
            cast(float32) -0.11208999902009964,
            cast(float32) -0.06708899885416031,
            0.304138,
            cast(float32) -0.22880899906158448,
            0.383651,
            cast(float32) -0.1968819946050644,
            0.477039,
            cast(float32) -0.21797800064086915,
            cast(float32) -0.5069310069084168,
            cast(float32) -0.1256749927997589,
            0.050456,
            1.086598,
            0.732128,
            0.326941,
            0.103952,
            0.121769,
            cast(float32) -0.1544869989156723,
            cast(float32) -0.255513995885849,
            0.030591,
            cast(float32) -0.3827970027923584,
            cast(float32) -0.01998100057244301,
            cast(float32) -0.3265700042247772,
            0.149691,
            cast(float32) -0.43563300371170046,
            cast(float32) -0.07079499959945679,
            0.167691,
            0.251413,
            cast(float32) -0.15340499579906465,
            0.160347,
            0.455107,
            cast(float32) -0.9685800075531006,
            cast(float32) -0.5758789777755737,
            0.623115,
            cast(float32) -0.06979300081729889,
            cast(float32) -0.3797680139541626,
            cast(float32) -0.9658070206642151,
            cast(float32) -0.062056999653577808,
            0.071312,
            0.457098,
            0.350372,
            cast(float32) -0.460658997297287,
            cast(float32) -0.9853929877281189,
            0.359963,
            cast(float32) -0.09367699921131134,
            0.404272,
            cast(float32) -0.3268960118293762,
            cast(float32) -0.27775201201438906,
            0.609322,
            cast(float32) -0.11419299989938736,
            cast(float32) -0.2307009994983673,
            0.089208,
            0.645381,
            0.494485,
            0.467876,
            cast(float32) -0.16618700325489045,
            0.251044,
            cast(float32) -0.394661009311676,
            0.192895,
            cast(float32) -0.34477698802948,
            cast(float32) -0.04189300164580345,
            cast(float32) -0.11116299778223038,
            0.066347,
            0.378158,
            cast(float32) -0.4554649889469147,
            0.339839,
            cast(float32) -0.41820698976516726,
            cast(float32) -0.35651499032974245,
            cast(float32) -0.22753599286079408,
            cast(float32) -0.21109099686145783,
            cast(float32) -0.12294500321149826,
            0.361772,
            cast(float32) -0.3380950093269348,
            0.004564,
            cast(float32) -0.39851000905036929,
            0.060876,
            cast(float32) -2.1325039863586427,
            cast(float32) -0.086776003241539,
            cast(float32) -0.029165999963879586,
            0.039241,
            0.222534,
            cast(float32) -0.18856500089168549,
            cast(float32) -0.2887920141220093,
            cast(float32) -0.16078899800777436,
            cast(float32) -0.1239050030708313,
            0.397916,
            cast(float32) -0.06377899646759033,
            0.167210,
            cast(float32) -0.4450039863586426,
            0.056889,
            0.207280,
            0.000101,
            0.384507,
            cast(float32) -1.7212389707565308,
            cast(float32) -2.0364019870758058,
            cast(float32) -2.0844030380249025,
            cast(float32) -2.060482978820801
        ];
    VP9_RECT_PART_NN_BIAS_32_LAYER0 =
        float32.[
            cast(float32) -0.8592510223388672,
            cast(float32) -0.10993800312280655,
            0.091838,
            0.187817,
            cast(float32) -0.7282649874687195,
            0.253080,
            0.000000,
            cast(float32) -0.3571949899196625,
            cast(float32) -0.031289998441934589,
            cast(float32) -1.3732370138168336,
            cast(float32) -0.7610859870910645,
            0.000000,
            cast(float32) -0.024504000321030618,
            1.765711,
            0.000000,
            1.505390
        ];
    VP9_RECT_PART_NN_WEIGHTS_32_LAYER1 =
        float32.[
            0.680940,
            1.367178,
            0.403075,
            0.029957,
            0.500917,
            1.407776,
            cast(float32) -0.3540019989013672,
            0.011667,
            1.663767,
            0.959155,
            0.428323,
            cast(float32) -0.2053450047969818,
            cast(float32) -0.08184999972581864,
            cast(float32) -3.920103073120117,
            cast(float32) -0.2438019961118698,
            cast(float32) -4.253932952880859,
            cast(float32) -0.03401999920606613,
            cast(float32) -1.3610570430755616,
            0.128236,
            cast(float32) -0.13842199742794038,
            cast(float32) -0.025790000334382058,
            cast(float32) -0.5635179877281189,
            cast(float32) -0.14871500432491303,
            cast(float32) -0.3443810045719147,
            cast(float32) -1.6773890256881714,
            cast(float32) -0.868332028388977,
            cast(float32) -0.06379199773073197,
            0.052052,
            0.359591,
            2.739808,
            cast(float32) -0.4143039882183075,
            3.036597,
            cast(float32) -0.0753680020570755,
            cast(float32) -1.0196800231933594,
            0.642501,
            0.209779,
            cast(float32) -0.37453898787498476,
            cast(float32) -0.7182940244674683,
            cast(float32) -0.11661600321531296,
            cast(float32) -0.04321200028061867,
            cast(float32) -1.7878090143203736,
            cast(float32) -0.7732620239257813,
            0.068734,
            0.508309,
            0.099334,
            1.802239,
            cast(float32) -0.3335379958152771,
            2.708645,
            cast(float32) -0.4476819932460785,
            cast(float32) -2.3555550575256349,
            cast(float32) -0.5066739916801453,
            cast(float32) -0.061027999967336658,
            cast(float32) -0.31030499935150149,
            cast(float32) -0.3754749894142151,
            0.194572,
            0.431788,
            cast(float32) -0.7896239757537842,
            cast(float32) -0.03196199983358383,
            0.358353,
            0.382937,
            0.232002,
            2.321813,
            cast(float32) -0.03752300143241882,
            2.104652
        ];
    VP9_RECT_PART_NN_BIAS_32_LAYER1 =
        float32.[ cast(float32) -0.693382978439331, 0.773661, 0.426878, cast(float32) -0.07061900198459625 ];
    VP9_RECT_PART_NNCONFIG_32 =
        NN_CONFIG.{
            num_inputs = 8,
            num_outputs = 4,
            num_hidden_layers = 1,
            num_hidden_nodes =
                s32.[ 16, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0 ],
            weights =
                *float32.[ VP9_RECT_PART_NN_WEIGHTS_32_LAYER0.data, VP9_RECT_PART_NN_WEIGHTS_32_LAYER1.data, null, null, null, null, null, null, null, null, null ],
            bias =
                *float32.[ VP9_RECT_PART_NN_BIAS_32_LAYER0.data, VP9_RECT_PART_NN_BIAS_32_LAYER1.data, null, null, null, null, null, null, null, null, null ]
        };
    VP9_RECT_PART_NN_WEIGHTS_64_LAYER0 =
        float32.[
            0.024671,
            cast(float32) -0.22060999274253846,
            cast(float32) -0.28436198830604555,
            cast(float32) -0.06955599784851074,
            cast(float32) -0.3156999945640564,
            0.187861,
            0.139782,
            0.063110,
            0.796561,
            0.172868,
            cast(float32) -0.662194013595581,
            cast(float32) -1.3930740356445313,
            0.085003,
            0.393381,
            0.358477,
            cast(float32) -0.18726800382137299,
            cast(float32) -0.3707450032234192,
            0.218287,
            0.027271,
            cast(float32) -0.25408899784088137,
            cast(float32) -0.048236001282930377,
            cast(float32) -0.4591369926929474,
            0.253171,
            0.122598,
            cast(float32) -0.5501070022583008,
            cast(float32) -0.5684559941291809,
            0.159866,
            cast(float32) -0.24653400480747224,
            0.096384,
            cast(float32) -0.2554599940776825,
            0.077864,
            cast(float32) -0.3348369896411896,
            0.026921,
            cast(float32) -0.6972519755363464,
            0.345262,
            1.343578,
            0.815984,
            1.118211,
            1.574016,
            0.578476,
            cast(float32) -0.28596699237823489,
            cast(float32) -0.5086719989776611,
            0.118137,
            0.037695,
            1.540510,
            1.256648,
            1.163819,
            1.172027,
            0.661551,
            cast(float32) -0.11197999864816666,
            cast(float32) -0.43420401215553286,
            cast(float32) -0.8942170143127441,
            0.570524,
            0.050292,
            cast(float32) -0.11367999762296677,
            0.000784,
            cast(float32) -0.21155400574207307,
            cast(float32) -0.3693940043449402,
            0.158306,
            cast(float32) -0.5125049948692322,
            cast(float32) -0.23869599401950837,
            0.091498,
            cast(float32) -0.4484899938106537,
            cast(float32) -0.49126800894737246,
            cast(float32) -0.35311201214790347,
            cast(float32) -0.30331501364707949,
            cast(float32) -0.4284380078315735,
            0.127998,
            cast(float32) -0.40678998827934267,
            cast(float32) -0.4017859995365143,
            cast(float32) -0.27988800406455996,
            cast(float32) -0.38422301411628725,
            0.026100,
            0.041621,
            cast(float32) -0.31581801176071169,
            cast(float32) -0.08788800239562988,
            0.353497,
            0.163123,
            cast(float32) -0.38012799620628359,
            cast(float32) -0.09033399820327759,
            cast(float32) -0.21664699912071229,
            cast(float32) -0.11784899979829788,
            cast(float32) -0.17350199818611146,
            0.301871,
            0.070854,
            0.114627,
            cast(float32) -0.05054499953985214,
            cast(float32) -0.1603810042142868,
            0.595294,
            0.492696,
            cast(float32) -0.45385798811912539,
            cast(float32) -1.1541390419006348,
            0.126000,
            0.034550,
            0.456665,
            cast(float32) -0.23661799728870393,
            cast(float32) -0.11264000087976456,
            0.050759,
            cast(float32) -0.44916200637817385,
            0.110059,
            0.147116,
            0.249358,
            cast(float32) -0.049894001334905627,
            0.063351,
            cast(float32) -0.004466999787837267,
            0.057242,
            cast(float32) -0.4820150136947632,
            cast(float32) -0.17433500289916993,
            cast(float32) -0.08561699837446213,
            cast(float32) -0.3338080048561096,
            cast(float32) -0.35844001173973086,
            cast(float32) -0.06900600343942642,
            0.099260,
            cast(float32) -1.2434300184249879,
            cast(float32) -0.052962999790906909,
            0.112088,
            cast(float32) -2.6611149311065676,
            cast(float32) -2.4458930492401125,
            cast(float32) -2.68817400932312,
            cast(float32) -2.624232053756714,
            0.030494,
            0.161311,
            0.012136,
            0.207564,
            cast(float32) -2.776855945587158,
            cast(float32) -2.7919399738311769,
            cast(float32) -2.623961925506592,
            cast(float32) -2.9188199043273927,
            1.231619,
            cast(float32) -0.376691997051239,
            cast(float32) -0.6980779767036438,
            0.110336,
            cast(float32) -0.28537800908088686,
            0.258367,
            cast(float32) -0.18015900254249574,
            cast(float32) -0.3766080141067505,
            cast(float32) -0.03434799984097481,
            cast(float32) -0.13020600378513337,
            0.160020,
            0.852977,
            0.580573,
            1.450782,
            1.357596,
            0.787382,
            cast(float32) -0.5440040230751038,
            cast(float32) -0.014794999733567238,
            0.032121,
            cast(float32) -0.5576959848403931,
            0.159994,
            cast(float32) -0.5409079790115356,
            0.180380,
            cast(float32) -0.39804500341415408,
            0.705095,
            0.515103,
            cast(float32) -0.5115209817886353,
            cast(float32) -1.271373987197876,
            cast(float32) -0.2310190051794052,
            0.423647,
            0.064907,
            cast(float32) -0.25533801317214968,
            cast(float32) -0.8777480125427246,
            cast(float32) -0.6672049760818481,
            0.267847,
            0.135229,
            0.617844,
            1.349849,
            1.012623,
            0.730506,
            cast(float32) -0.07857099920511246,
            0.058401,
            0.053221,
            cast(float32) -2.4261460304260256,
            cast(float32) -0.09880799800157547,
            cast(float32) -0.13850800693035127,
            cast(float32) -0.1532990038394928,
            0.149116,
            cast(float32) -0.44424301385879519,
            0.301807,
            0.065066,
            0.092929,
            cast(float32) -0.37278398871421816,
            cast(float32) -0.09554000198841095,
            0.192269,
            0.237894,
            0.080228,
            cast(float32) -0.2140740007162094,
            cast(float32) -0.01142599992454052,
            cast(float32) -2.3523669242858888,
            cast(float32) -0.0853940024971962,
            cast(float32) -0.19036099314689637,
            cast(float32) -0.0011769999982789159,
            0.089197
        ];
    VP9_RECT_PART_NN_BIAS_64_LAYER0 =
        float32.[
            0.000000,
            cast(float32) -0.05765200033783913,
            cast(float32) -0.17541299760341645,
            cast(float32) -0.17538900673389436,
            cast(float32) -1.0840970277786255,
            cast(float32) -1.4238009452819825,
            cast(float32) -0.07630699872970581,
            cast(float32) -0.19380299746990205,
            0.000000,
            cast(float32) -0.06647399812936783,
            cast(float32) -0.050317998975515369,
            cast(float32) -0.019832000136375428,
            cast(float32) -0.0388140007853508,
            cast(float32) -0.14418399333953858,
            2.652451,
            2.415006,
            0.197464,
            cast(float32) -0.7298420071601868,
            cast(float32) -0.17377400398254395,
            0.239171,
            0.486425,
            2.463304,
            cast(float32) -0.17527900636196137,
            2.352637
        ];
    VP9_RECT_PART_NN_WEIGHTS_64_LAYER1 =
        float32.[
            cast(float32) -0.06323699653148651,
            1.925696,
            cast(float32) -0.18214499950408936,
            cast(float32) -0.2266869992017746,
            0.602941,
            cast(float32) -0.9411399960517883,
            0.814598,
            cast(float32) -0.1170630007982254,
            0.282988,
            0.066369,
            0.096951,
            1.049735,
            cast(float32) -0.18818800151348115,
            cast(float32) -0.2812269926071167,
            cast(float32) -4.8367462158203129,
            cast(float32) -5.047797203063965,
            0.892358,
            0.417145,
            cast(float32) -0.27984899282455447,
            1.335945,
            0.660338,
            cast(float32) -2.7579379081726076,
            cast(float32) -0.11571399867534638,
            cast(float32) -1.8621829748153687,
            cast(float32) -0.045979999005794528,
            cast(float32) -1.5976239442825318,
            cast(float32) -0.586821973323822,
            cast(float32) -0.6155890226364136,
            cast(float32) -0.33053699135780337,
            1.068496,
            cast(float32) -0.16729000210762025,
            0.141290,
            cast(float32) -0.11209999769926071,
            0.232761,
            0.252307,
            cast(float32) -0.39965298771858218,
            0.353118,
            0.241583,
            2.635241,
            4.026119,
            cast(float32) -1.137326955795288,
            cast(float32) -0.05244600027799606,
            cast(float32) -0.13981400430202485,
            cast(float32) -1.1042560338974,
            cast(float32) -0.7593910098075867,
            2.508457,
            cast(float32) -0.5262969732284546,
            2.095348,
            cast(float32) -0.444472998380661,
            cast(float32) -1.090451955795288,
            0.584122,
            0.468729,
            cast(float32) -0.3688650131225586,
            1.041425,
            cast(float32) -1.0795040130615235,
            0.348837,
            0.390091,
            0.416191,
            0.212906,
            cast(float32) -0.6602550148963928,
            0.053630,
            0.209476,
            3.595525,
            2.257293,
            cast(float32) -0.5140299797058106,
            0.074203,
            cast(float32) -0.3758620023727417,
            cast(float32) -1.9983069896697999,
            cast(float32) -0.9303100109100342,
            1.866686,
            cast(float32) -0.24713699519634248,
            1.087789,
            0.100186,
            0.298150,
            0.165265,
            0.050478,
            0.249167,
            0.371789,
            cast(float32) -0.294497013092041,
            0.202954,
            0.037310,
            0.193159,
            0.161551,
            0.301597,
            0.299286,
            0.185946,
            0.822976,
            2.066130,
            cast(float32) -1.7245880365371705,
            0.055977,
            cast(float32) -0.33074700832366946,
            cast(float32) -0.06774699687957764,
            cast(float32) -0.4758009910583496,
            1.555958,
            cast(float32) -0.025807999074459077,
            cast(float32) -0.08151599764823914
        ];
    VP9_RECT_PART_NN_BIAS_64_LAYER1 =
        float32.[ cast(float32) -0.09072300046682358, 0.894968, 0.844754, cast(float32) -3.4961938858032228 ];
    VP9_RECT_PART_NNCONFIG_64 =
        NN_CONFIG.{
            num_inputs = 8,
            num_outputs = 4,
            num_hidden_layers = 1,
            num_hidden_nodes =
                s32.[ 24, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0 ],
            weights =
                *float32.[ VP9_RECT_PART_NN_WEIGHTS_64_LAYER0.data, VP9_RECT_PART_NN_WEIGHTS_64_LAYER1.data, null, null, null, null, null, null, null, null, null ],
            bias =
                *float32.[ VP9_RECT_PART_NN_BIAS_64_LAYER0.data, VP9_RECT_PART_NN_BIAS_64_LAYER1.data, null, null, null, null, null, null, null, null, null ]
        };
    VP9_PARTITION_NN_WEIGHTS_64X64_LAYER0 =
        float32.[
            cast(float32) -3.571347951889038,
            0.014835,
            cast(float32) -3.2553930282592775,
            cast(float32) -0.09809000045061112,
            cast(float32) -0.013120000250637532,
            0.000221,
            0.056273,
            0.190179,
            cast(float32) -0.26813000440597536,
            cast(float32) -1.8282419443130494,
            cast(float32) -0.010654999874532223,
            0.937244,
            cast(float32) -0.43511998653411868,
            0.512125,
            1.610679,
            0.190816,
            cast(float32) -0.7990750074386597,
            cast(float32) -0.37734800577163699,
            cast(float32) -0.14423200488090516,
            0.614383,
            cast(float32) -0.9803879857063294,
            1.754150,
            cast(float32) -0.18560299277305604,
            cast(float32) -0.06185400113463402,
            cast(float32) -0.8071720004081726,
            1.240177,
            1.419531,
            cast(float32) -0.43854400515556338,
            cast(float32) -5.98077392578125,
            0.139045,
            cast(float32) -0.03235900029540062,
            cast(float32) -0.06888700276613236,
            cast(float32) -1.2379180192947388,
            0.115706,
            0.003164,
            2.924212,
            1.246838,
            cast(float32) -0.035833001136779788,
            0.810011,
            cast(float32) -0.8058940172195435,
            0.010966,
            0.076463,
            cast(float32) -4.226379871368408,
            cast(float32) -2.4377639293670656,
            cast(float32) -0.010618999600410462,
            cast(float32) -0.020935000851750375,
            cast(float32) -0.4514940083026886,
            0.300079,
            cast(float32) -0.16896100342273713,
            cast(float32) -3.3264501094818117,
            cast(float32) -2.7310938835144045,
            0.002518,
            0.018840,
            cast(float32) -1.6568150520324708,
            0.068039,
            0.010586
        ];
    VP9_PARTITION_NN_BIAS_64X64_LAYER0 =
        float32.[
            cast(float32) -3.469882011413574,
            0.683989,
            0.194010,
            0.313782,
            cast(float32) -3.1533350944519045,
            2.245849,
            cast(float32) -1.9461899995803834,
            cast(float32) -3.7400200366973879
        ];
    VP9_PARTITION_NN_WEIGHTS_64X64_LAYER1 =
        float32.[
            cast(float32) -8.058566093444825,
            0.108306,
            cast(float32) -0.2806200087070465,
            cast(float32) -0.818822979927063,
            cast(float32) -6.445116996765137,
            0.865364,
            cast(float32) -1.1271270513534547,
            cast(float32) -8.808659553527832
        ];
    VP9_PARTITION_NN_BIAS_64X64_LAYER1 = float32.[ cast(float32) 6.469094276428223 ];
    VP9_PARTITION_NNCONFIG_64X64 =
        NN_CONFIG.{
            num_inputs = 7,
            num_outputs = 1,
            num_hidden_layers = 1,
            num_hidden_nodes =
                s32.[ 8, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0 ],
            weights =
                *float32.[ VP9_PARTITION_NN_WEIGHTS_64X64_LAYER0.data, VP9_PARTITION_NN_WEIGHTS_64X64_LAYER1.data, null, null, null, null, null, null, null, null, null ],
            bias =
                *float32.[ VP9_PARTITION_NN_BIAS_64X64_LAYER0.data, VP9_PARTITION_NN_BIAS_64X64_LAYER1.data, null, null, null, null, null, null, null, null, null ]
        };
    VP9_PARTITION_NN_WEIGHTS_32X32_LAYER0 =
        float32.[
            cast(float32) -0.2954370081424713,
            cast(float32) -4.002647876739502,
            cast(float32) -0.20539900660514832,
            cast(float32) -0.06091900169849396,
            0.708037,
            0.027221,
            cast(float32) -0.03913699835538864,
            cast(float32) -0.9077240228652954,
            cast(float32) -3.1516621112823488,
            0.007106,
            0.018726,
            cast(float32) -0.534928023815155,
            0.022744,
            0.000159,
            cast(float32) -1.7171889543533326,
            cast(float32) -3.2290310859680177,
            cast(float32) -0.027310999110341073,
            0.269863,
            cast(float32) -0.40074700117111208,
            cast(float32) -0.39436599612236025,
            cast(float32) -0.1088780015707016,
            0.603027,
            0.455369,
            cast(float32) -0.19717000424861909,
            1.241746,
            cast(float32) -1.3478200435638428,
            cast(float32) -0.5756360292434692,
            cast(float32) -0.4628790020942688,
            cast(float32) -2.2964260578155519,
            0.196696,
            cast(float32) -0.13834699988365174,
            cast(float32) -0.030753999948501588,
            cast(float32) -0.20077399909496308,
            0.453795,
            0.055625,
            cast(float32) -3.163115978240967,
            cast(float32) -0.09100300073623657,
            cast(float32) -0.027027999982237817,
            cast(float32) -0.0429840013384819,
            cast(float32) -0.6051849722862244,
            0.143240,
            cast(float32) -0.03643900156021118,
            cast(float32) -0.8012279868125916,
            0.313409,
            cast(float32) -0.15994200110435487,
            0.031267,
            0.886454,
            cast(float32) -1.5316439867019654,
            cast(float32) -0.08965499699115753,
            0.037683,
            cast(float32) -0.163441002368927,
            cast(float32) -0.13045400381088258,
            cast(float32) -0.058343999087810519,
            0.060011,
            0.275387,
            1.552226
        ];
    VP9_PARTITION_NN_BIAS_32X32_LAYER0 =
        float32.[
            cast(float32) -0.838371992111206,
            cast(float32) -2.609088897705078,
            cast(float32) -0.05576299875974655,
            1.329485,
            cast(float32) -1.2976380586624146,
            cast(float32) -2.6366219520568849,
            cast(float32) -0.8269090056419373,
            1.012644
        ];
    VP9_PARTITION_NN_WEIGHTS_32X32_LAYER1 =
        float32.[
            cast(float32) -1.792631983757019,
            cast(float32) -7.322352886199951,
            cast(float32) -0.6833860278129578,
            0.676564,
            cast(float32) -1.488118052482605,
            cast(float32) -7.527719020843506,
            1.240163,
            0.614309
        ];
    VP9_PARTITION_NN_BIAS_32X32_LAYER1 = float32.[ cast(float32) 4.9742255210876469 ];
    VP9_PARTITION_NNCONFIG_32X32 =
        NN_CONFIG.{
            num_inputs = 7,
            num_outputs = 1,
            num_hidden_layers = 1,
            num_hidden_nodes =
                s32.[ 8, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0 ],
            weights =
                *float32.[ VP9_PARTITION_NN_WEIGHTS_32X32_LAYER0.data, VP9_PARTITION_NN_WEIGHTS_32X32_LAYER1.data, null, null, null, null, null, null, null, null, null ],
            bias =
                *float32.[ VP9_PARTITION_NN_BIAS_32X32_LAYER0.data, VP9_PARTITION_NN_BIAS_32X32_LAYER1.data, null, null, null, null, null, null, null, null, null ]
        };
    VP9_PARTITION_NN_WEIGHTS_16X16_LAYER0 =
        float32.[
            cast(float32) -1.7176729440689088,
            cast(float32) -4.718130111694336,
            cast(float32) -0.12572500109672547,
            cast(float32) -0.18342700600624085,
            cast(float32) -0.5117639899253845,
            0.035328,
            0.130891,
            cast(float32) -3.096752882003784,
            0.174968,
            cast(float32) -0.18876899778842927,
            cast(float32) -0.6407960057258606,
            1.305661,
            1.700638,
            cast(float32) -0.07380600273609162,
            cast(float32) -4.006781101226807,
            cast(float32) -1.630998969078064,
            cast(float32) -0.06486299633979798,
            cast(float32) -0.08641000092029572,
            cast(float32) -0.1486169993877411,
            0.172733,
            cast(float32) -0.018619000911712648,
            2.152595,
            0.778405,
            cast(float32) -0.15645499527454377,
            0.612995,
            cast(float32) -0.4678780138492584,
            0.152022,
            cast(float32) -0.23618300259113313,
            0.339635,
            cast(float32) -0.08711899816989899,
            cast(float32) -3.1966099739074709,
            cast(float32) -1.0804009437561036,
            cast(float32) -0.6377040147781372,
            cast(float32) -0.05997399985790253,
            1.706298,
            cast(float32) -0.7937049865722656,
            cast(float32) -6.3992600440979,
            0.010624,
            cast(float32) -0.06419900059700012,
            cast(float32) -0.6506209969520569,
            0.338087,
            cast(float32) -0.0015310000162571669,
            1.023655,
            cast(float32) -3.7002720832824709,
            cast(float32) -0.05528099834918976,
            cast(float32) -0.38688400387763979,
            0.375504,
            cast(float32) -0.8986780047416687,
            0.281156,
            cast(float32) -0.3146109879016876,
            0.863354,
            cast(float32) -0.04058200120925903,
            cast(float32) -0.14501899480819703,
            0.029329,
            cast(float32) -2.1978800296783449,
            cast(float32) -0.10873299837112427
        ];
    VP9_PARTITION_NN_BIAS_16X16_LAYER0 =
        float32.[
            0.411516,
            cast(float32) -2.1437370777130129,
            cast(float32) -3.6931920051574709,
            2.123142,
            cast(float32) -1.356909990310669,
            cast(float32) -3.561016082763672,
            cast(float32) -0.7650449872016907,
            cast(float32) -2.4170820713043215
        ];
    VP9_PARTITION_NN_WEIGHTS_16X16_LAYER1 =
        float32.[
            cast(float32) -0.6197550296783447,
            cast(float32) -2.2023909091949465,
            cast(float32) -4.3371710777282719,
            0.611319,
            0.377677,
            cast(float32) -4.998723030090332,
            cast(float32) -1.0522350072860718,
            1.949922
        ];
    VP9_PARTITION_NN_BIAS_16X16_LAYER1 = float32.[ cast(float32) 3.2098171710968019 ];
    VP9_PARTITION_NNCONFIG_16X16 =
        NN_CONFIG.{
            num_inputs = 7,
            num_outputs = 1,
            num_hidden_layers = 1,
            num_hidden_nodes =
                s32.[ 8, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0 ],
            weights =
                *float32.[ VP9_PARTITION_NN_WEIGHTS_16X16_LAYER0.data, VP9_PARTITION_NN_WEIGHTS_16X16_LAYER1.data, null, null, null, null, null, null, null, null, null ],
            bias =
                *float32.[ VP9_PARTITION_NN_BIAS_16X16_LAYER0.data, VP9_PARTITION_NN_BIAS_16X16_LAYER1.data, null, null, null, null, null, null, null, null, null ]
        };
    VP9_VAR_PART_NN_WEIGHTS_64_LAYER0 =
        float32.[
            cast(float32) -0.2495719939470291,
            0.205532,
            cast(float32) -2.175607919692993,
            1.094836,
            cast(float32) -2.986370086669922,
            0.193160,
            cast(float32) -0.14382299780845643,
            0.378511,
            cast(float32) -1.9977879524230958,
            cast(float32) -2.1668660640716554,
            cast(float32) -1.930158019065857,
            cast(float32) -1.2021269798278809,
            cast(float32) -0.6118749976158142,
            cast(float32) -0.5064219832420349,
            cast(float32) -0.43248701095581057,
            0.071205,
            0.578172,
            cast(float32) -0.1542849987745285,
            cast(float32) -0.051830001175403598,
            0.331681,
            cast(float32) -1.4571770429611207,
            cast(float32) -2.4435460567474367,
            cast(float32) -2.0003020763397219,
            cast(float32) -1.3892829418182374,
            0.372084,
            cast(float32) -0.46491700410842898,
            2.265235,
            2.385787,
            2.312722,
            2.127868,
            cast(float32) -0.40396299958229067,
            cast(float32) -0.17786000669002534,
            cast(float32) -0.43675100803375246,
            cast(float32) -0.5605390071868897,
            0.254903,
            0.193976,
            cast(float32) -0.3056110143661499,
            0.256632,
            0.309388,
            cast(float32) -0.4374389946460724,
            1.702640,
            cast(float32) -5.007069110870361,
            cast(float32) -0.3234499990940094,
            0.294227,
            1.267193,
            1.056601,
            0.387181,
            cast(float32) -0.19121499359607697
        ];
    VP9_VAR_PART_NN_BIAS_64_LAYER0 =
        float32.[
            cast(float32) -0.04439600184559822,
            cast(float32) -0.9381660223007202,
            0.000000,
            cast(float32) -0.9163749814033508,
            1.242299,
            0.000000,
            cast(float32) -0.40573400259017947,
            0.014206
        ];
    VP9_VAR_PART_NN_WEIGHTS_64_LAYER1 =
        float32.[
            1.635945,
            0.979557,
            0.455315,
            1.197199,
            cast(float32) -2.251024007797241,
            cast(float32) -0.4649530053138733,
            1.378676,
            cast(float32) -0.11192700266838074
        ];
    VP9_VAR_PART_NN_BIAS_64_LAYER1 = float32.[ cast(float32) -0.3797244727611542 ];
    VP9_VAR_PART_NNCONFIG_64 =
        NN_CONFIG.{
            num_inputs = 6,
            num_outputs = 1,
            num_hidden_layers = 1,
            num_hidden_nodes =
                s32.[ 8, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0 ],
            weights =
                *float32.[ VP9_VAR_PART_NN_WEIGHTS_64_LAYER0.data, VP9_VAR_PART_NN_WEIGHTS_64_LAYER1.data, null, null, null, null, null, null, null, null, null ],
            bias =
                *float32.[ VP9_VAR_PART_NN_BIAS_64_LAYER0.data, VP9_VAR_PART_NN_BIAS_64_LAYER1.data, null, null, null, null, null, null, null, null, null ]
        };
    VP9_VAR_PART_NN_WEIGHTS_32_LAYER0 =
        float32.[
            0.067243,
            cast(float32) -0.08359800279140473,
            cast(float32) -2.1911590099334719,
            2.726434,
            cast(float32) -3.3240129947662355,
            3.477977,
            0.323736,
            cast(float32) -0.5101990103721619,
            2.960693,
            2.937661,
            2.888476,
            2.938315,
            cast(float32) -0.3076019883155823,
            cast(float32) -0.5033529996871948,
            cast(float32) -0.08072499930858612,
            cast(float32) -0.4739089906215668,
            cast(float32) -0.4171620011329651,
            0.457089,
            0.665153,
            cast(float32) -0.27320998907089236,
            0.028279,
            0.972220,
            cast(float32) -0.44559600949287417,
            1.756611,
            cast(float32) -0.17789199948310853,
            cast(float32) -0.09175799787044525,
            0.436661,
            cast(float32) -0.5215060114860535,
            0.133786,
            0.266743,
            0.637367,
            cast(float32) -0.16008399426937104,
            cast(float32) -1.3962689638137818,
            1.020841,
            cast(float32) -1.1129709482192994,
            0.919496,
            cast(float32) -0.23588299751281739,
            0.651954,
            0.109061,
            cast(float32) -0.4294629991054535,
            0.740839,
            cast(float32) -0.9620599746704102,
            0.299519,
            cast(float32) -0.3862980008125305,
            1.550231,
            2.464915,
            1.311969,
            2.561612
        ];
    VP9_VAR_PART_NN_BIAS_32_LAYER0 =
        float32.[
            0.368242,
            0.736617,
            0.000000,
            0.757287,
            0.000000,
            0.613248,
            cast(float32) -0.776390016078949,
            0.928497
        ];
    VP9_VAR_PART_NN_WEIGHTS_32_LAYER1 =
        float32.[
            0.939884,
            cast(float32) -2.4208500385284426,
            cast(float32) -0.4104889929294586,
            cast(float32) -0.18669000267982484,
            0.063287,
            cast(float32) -0.5220109820365906,
            0.484527,
            cast(float32) -0.6396250128746033
        ];
    VP9_VAR_PART_NN_BIAS_32_LAYER1 = float32.[ cast(float32) -0.6455006003379822 ];
    VP9_VAR_PART_NNCONFIG_32 =
        NN_CONFIG.{
            num_inputs = 6,
            num_outputs = 1,
            num_hidden_layers = 1,
            num_hidden_nodes =
                s32.[ 8, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0 ],
            weights =
                *float32.[ VP9_VAR_PART_NN_WEIGHTS_32_LAYER0.data, VP9_VAR_PART_NN_WEIGHTS_32_LAYER1.data, null, null, null, null, null, null, null, null, null ],
            bias =
                *float32.[ VP9_VAR_PART_NN_BIAS_32_LAYER0.data, VP9_VAR_PART_NN_BIAS_32_LAYER1.data, null, null, null, null, null, null, null, null, null ]
        };
    VP9_VAR_PART_NN_WEIGHTS_16_LAYER0 =
        float32.[
            0.742567,
            cast(float32) -0.580623984336853,
            cast(float32) -0.24452799558639527,
            0.331661,
            cast(float32) -0.1139490008354187,
            cast(float32) -0.5592949986457825,
            cast(float32) -0.38606101274490359,
            0.438653,
            1.467463,
            0.211589,
            0.513972,
            1.067855,
            cast(float32) -0.876679003238678,
            0.088560,
            cast(float32) -0.687483012676239,
            cast(float32) -0.3803040087223053,
            cast(float32) -0.016411999240517618,
            0.146380,
            0.015318,
            0.000351,
            cast(float32) -2.7648870944976808,
            3.269717,
            2.752428,
            cast(float32) -2.2367539405822756,
            0.561539,
            cast(float32) -0.8520500063896179,
            cast(float32) -0.08466699719429016,
            0.202057,
            0.197049,
            0.364922,
            cast(float32) -0.46380099654197695,
            0.431790,
            1.872096,
            cast(float32) -0.09188699722290039,
            cast(float32) -0.05503400042653084,
            2.443492,
            cast(float32) -0.15695799887180329,
            cast(float32) -0.18957099318504334,
            cast(float32) -0.5424240231513977,
            cast(float32) -0.5898039937019348,
            cast(float32) -0.354422003030777,
            0.401605,
            0.642021,
            cast(float32) -0.8751170039176941,
            2.040794,
            1.921070,
            1.792413,
            1.839727
        ];
    VP9_VAR_PART_NN_BIAS_16_LAYER0 =
        float32.[
            2.901234,
            cast(float32) -1.940932035446167,
            cast(float32) -0.1989700049161911,
            cast(float32) -0.40652400255203249,
            0.059422,
            cast(float32) -1.8792070150375367,
            cast(float32) -0.2323399931192398,
            2.979821
        ];
    VP9_VAR_PART_NN_WEIGHTS_16_LAYER1 =
        float32.[
            cast(float32) -0.5287309885025024,
            0.375234,
            cast(float32) -0.08842200040817261,
            0.668629,
            0.870449,
            0.578735,
            0.546103,
            cast(float32) -1.9572069644927979
        ];
    VP9_VAR_PART_NN_BIAS_16_LAYER1 = float32.[ cast(float32) -1.9576940536499024 ];
    VP9_VAR_PART_NNCONFIG_16 =
        NN_CONFIG.{
            num_inputs = 6,
            num_outputs = 1,
            num_hidden_layers = 1,
            num_hidden_nodes =
                s32.[ 8, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0 ],
            weights =
                *float32.[ VP9_VAR_PART_NN_WEIGHTS_16_LAYER0.data, VP9_VAR_PART_NN_WEIGHTS_16_LAYER1.data, null, null, null, null, null, null, null, null, null ],
            bias =
                *float32.[ VP9_VAR_PART_NN_BIAS_16_LAYER0.data, VP9_VAR_PART_NN_BIAS_16_LAYER1.data, null, null, null, null, null, null, null, null, null ]
        };
    VP9_PART_SPLIT_NN_WEIGHTS_64_LAYER0 =
        float32.[
            cast(float32) -0.6097279787063599,
            cast(float32) -0.4090990126132965,
            cast(float32) -0.47244900465011599,
            0.183769,
            cast(float32) -0.45774000883102419,
            0.081089,
            0.171003,
            0.578696,
            cast(float32) -0.019043000414967538,
            cast(float32) -0.856141984462738,
            0.557369,
            cast(float32) -1.7794239521026612,
            cast(float32) -0.274044007062912,
            cast(float32) -0.3206320106983185,
            cast(float32) -0.39253100752830508,
            cast(float32) -0.3594619929790497,
            cast(float32) -0.4041059911251068,
            cast(float32) -0.2883569896221161,
            0.200620,
            0.038013,
            cast(float32) -0.430092990398407,
            0.235083,
            cast(float32) -0.4874419867992401,
            0.424814,
            cast(float32) -0.23275800049304963,
            cast(float32) -0.4429430067539215,
            0.229397,
            cast(float32) -0.5403010249137878,
            cast(float32) -0.6484209895133972,
            cast(float32) -0.6497470140457153,
            cast(float32) -0.17163799703121186,
            0.603824,
            0.468497,
            cast(float32) -0.4215799868106842,
            0.178840,
            cast(float32) -0.5338379740715027,
            cast(float32) -0.029471000656485559,
            cast(float32) -0.07629600167274475,
            0.197426,
            cast(float32) -0.18790799379348756,
            cast(float32) -0.003949999809265137,
            cast(float32) -0.06573999673128128,
            0.085165,
            cast(float32) -0.039673998951911929,
            cast(float32) -5.640701770782471,
            1.909538,
            cast(float32) -1.4346040487289429,
            3.294606,
            cast(float32) -0.788811981678009,
            0.196864,
            0.057012,
            cast(float32) -0.019757000729441644,
            0.336233,
            0.075378,
            0.081503,
            0.491864,
            cast(float32) -1.8994699716567994,
            cast(float32) -1.7641730308532715,
            cast(float32) -1.8881369829177857,
            cast(float32) -1.7623430490493775,
            0.845542,
            0.202285,
            0.381948,
            cast(float32) -0.15099599957466126,
            0.556893,
            cast(float32) -0.3053539991378784,
            0.561482,
            cast(float32) -0.021973999217152597,
            cast(float32) -0.7031170129776001,
            0.268638,
            cast(float32) -0.6657360196113586,
            1.191005,
            cast(float32) -0.08156800270080567,
            cast(float32) -0.11565300077199936,
            0.272029,
            cast(float32) -0.1400739997625351,
            0.072683,
            0.092651,
            cast(float32) -0.47228699922561648,
            cast(float32) -0.055789999663829806,
            cast(float32) -0.4344249963760376,
            0.352055,
            0.048246,
            0.372865,
            0.111499,
            cast(float32) -0.3383040130138397,
            0.739133,
            0.156519,
            cast(float32) -0.5946440100669861,
            0.137295,
            0.613350,
            cast(float32) -0.1651020050048828,
            cast(float32) -1.0037310123443604,
            0.043070,
            cast(float32) -0.8878960013389587,
            cast(float32) -0.17420199513435365
        ];
    VP9_PART_SPLIT_NN_BIAS_64_LAYER0 =
        float32.[
            1.182714,
            0.000000,
            0.902019,
            0.953115,
            cast(float32) -1.3724859952926636,
            cast(float32) -1.2887400388717652,
            cast(float32) -0.15514400601387025,
            cast(float32) -3.0413620471954347
        ];
    VP9_PART_SPLIT_NN_WEIGHTS_64_LAYER1 =
        float32.[
            0.841214,
            0.456016,
            0.869270,
            1.692999,
            cast(float32) -1.7004940509796143,
            cast(float32) -0.9117609858512878,
            0.030111,
            cast(float32) -1.4475480318069459
        ];
    VP9_PART_SPLIT_NN_BIAS_64_LAYER1 = float32.[ cast(float32) 1.1778254508972169 ];
    VP9_PART_SPLIT_NNCONFIG_64 =
        NN_CONFIG.{
            num_inputs = 12,
            num_outputs = 1,
            num_hidden_layers = 1,
            num_hidden_nodes =
                s32.[ 8, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0 ],
            weights =
                *float32.[ VP9_PART_SPLIT_NN_WEIGHTS_64_LAYER0.data, VP9_PART_SPLIT_NN_WEIGHTS_64_LAYER1.data, null, null, null, null, null, null, null, null, null ],
            bias =
                *float32.[ VP9_PART_SPLIT_NN_BIAS_64_LAYER0.data, VP9_PART_SPLIT_NN_BIAS_64_LAYER1.data, null, null, null, null, null, null, null, null, null ]
        };
    VP9_PART_SPLIT_NN_WEIGHTS_32_LAYER0 =
        float32.[
            cast(float32) -0.10548800230026245,
            cast(float32) -0.21866199374198914,
            0.010980,
            cast(float32) -0.22697900235652924,
            0.028076,
            0.743430,
            0.789266,
            0.031907,
            cast(float32) -1.4642000198364258,
            0.222336,
            cast(float32) -1.0684930086135865,
            cast(float32) -0.05271200090646744,
            cast(float32) -0.17618100345134736,
            cast(float32) -0.10265400260686875,
            cast(float32) -0.9739320278167725,
            cast(float32) -0.18263700604438783,
            cast(float32) -0.1979999989271164,
            0.335977,
            0.271346,
            0.133005,
            1.674203,
            0.689567,
            0.657133,
            0.283524,
            0.115529,
            0.738327,
            0.317184,
            cast(float32) -0.17973600327968598,
            0.403691,
            0.679350,
            0.048925,
            0.271338,
            cast(float32) -1.5389209985733033,
            cast(float32) -0.9007369875907898,
            cast(float32) -1.377845048904419,
            0.084245,
            0.803122,
            cast(float32) -0.107805997133255,
            0.103045,
            cast(float32) -0.02333500050008297,
            cast(float32) -0.09811600297689438,
            cast(float32) -0.12780900299549104,
            0.037665,
            cast(float32) -0.5232250094413757,
            1.622185,
            1.903999,
            1.358889,
            1.680785,
            0.027743,
            0.117906,
            cast(float32) -0.15881000459194184,
            0.057775,
            0.168257,
            0.062414,
            0.086228,
            cast(float32) -0.08738099783658982,
            cast(float32) -3.066082000732422,
            3.021855,
            cast(float32) -4.0921549797058109,
            2.550104,
            cast(float32) -0.23002199828624726,
            cast(float32) -0.20744499564170838,
            cast(float32) -0.00034699999378062785,
            0.034042,
            0.097057,
            0.220088,
            cast(float32) -0.22884100675582887,
            cast(float32) -0.029404999688267709,
            cast(float32) -1.507174015045166,
            cast(float32) -1.455183982849121,
            2.624904,
            2.643355,
            0.319912,
            0.585531,
            cast(float32) -1.0182249546051026,
            cast(float32) -0.6996060013771057,
            1.026490,
            0.169952,
            cast(float32) -0.09357900172472,
            cast(float32) -0.14235199987888337,
            cast(float32) -0.10725600272417069,
            0.059598,
            0.043190,
            0.507543,
            cast(float32) -0.13861699402332307,
            0.030197,
            0.059574,
            cast(float32) -0.6340510249137878,
            cast(float32) -0.5867239832878113,
            cast(float32) -0.14801999926567079,
            cast(float32) -0.33438000082969668,
            0.459547,
            1.620600,
            0.496850,
            0.639480,
            cast(float32) -0.4657149910926819
        ];
    VP9_PART_SPLIT_NN_BIAS_32_LAYER0 =
        float32.[
            cast(float32) -1.125885009765625,
            0.753197,
            cast(float32) -0.8258079886436462,
            0.004839,
            0.583920,
            0.718062,
            0.976741,
            0.796188
        ];
    VP9_PART_SPLIT_NN_WEIGHTS_32_LAYER1 =
        float32.[
            cast(float32) -0.45874500274658205,
            0.724624,
            cast(float32) -0.47971999645233157,
            cast(float32) -2.1998720169067385,
            1.162661,
            1.194153,
            cast(float32) -0.7168959975242615,
            0.824080
        ];
    VP9_PART_SPLIT_NN_BIAS_32_LAYER1 = float32.[ 0.71644074 ];
    VP9_PART_SPLIT_NNCONFIG_32 =
        NN_CONFIG.{
            num_inputs = 12,
            num_outputs = 1,
            num_hidden_layers = 1,
            num_hidden_nodes =
                s32.[ 8, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0 ],
            weights =
                *float32.[ VP9_PART_SPLIT_NN_WEIGHTS_32_LAYER0.data, VP9_PART_SPLIT_NN_WEIGHTS_32_LAYER1.data, null, null, null, null, null, null, null, null, null ],
            bias =
                *float32.[ VP9_PART_SPLIT_NN_BIAS_32_LAYER0.data, VP9_PART_SPLIT_NN_BIAS_32_LAYER1.data, null, null, null, null, null, null, null, null, null ]
        };
    VP9_PART_SPLIT_NN_WEIGHTS_16_LAYER0 =
        float32.[
            cast(float32) -0.003628999926149845,
            cast(float32) -0.046852000057697299,
            0.220428,
            cast(float32) -0.033041998744010928,
            0.049365,
            0.112818,
            cast(float32) -0.3061490058898926,
            cast(float32) -0.005872000008821487,
            1.066947,
            cast(float32) -2.2902259826660158,
            2.159505,
            cast(float32) -0.6187139749526978,
            cast(float32) -0.21329399943351746,
            0.451372,
            cast(float32) -0.1994590014219284,
            0.223730,
            cast(float32) -0.321709007024765,
            0.063364,
            0.148704,
            cast(float32) -0.2933709919452667,
            0.077225,
            cast(float32) -0.42194700241088869,
            cast(float32) -0.5155429840087891,
            cast(float32) -0.2409750074148178,
            cast(float32) -0.41851601004600527,
            1.036523,
            cast(float32) -0.009165000170469284,
            0.032484,
            1.086549,
            0.220322,
            cast(float32) -0.2475849986076355,
            cast(float32) -0.22123199701309205,
            cast(float32) -0.22505000233650208,
            0.993051,
            0.285907,
            1.308846,
            0.707456,
            0.335152,
            0.234556,
            0.264590,
            cast(float32) -0.07803300023078919,
            0.542226,
            0.057777,
            0.163471,
            0.039245,
            cast(float32) -0.7259600162506104,
            0.963780,
            cast(float32) -0.9720010161399841,
            0.252237,
            cast(float32) -0.19274500012397767,
            cast(float32) -0.8365709781646729,
            cast(float32) -0.4605390131473541,
            cast(float32) -0.5287129878997803,
            cast(float32) -0.16019800305366517,
            cast(float32) -0.6211079955101013,
            0.486405,
            cast(float32) -0.22192299365997315,
            1.519426,
            cast(float32) -0.8578709959983826,
            0.411595,
            0.947188,
            0.203339,
            0.174526,
            0.016382,
            0.256879,
            0.049818,
            0.057836,
            cast(float32) -0.6590960025787354,
            0.459894,
            0.174695,
            0.379359,
            0.062530,
            cast(float32) -0.21020099520683289,
            cast(float32) -0.355787992477417,
            cast(float32) -0.20843200385570527,
            cast(float32) -0.4017229974269867,
            cast(float32) -0.11537300050258637,
            0.191336,
            cast(float32) -0.10934200137853623,
            0.002455,
            cast(float32) -0.078745998442173,
            cast(float32) -0.39187100529670718,
            0.149892,
            cast(float32) -0.23961499333381654,
            cast(float32) -0.5207089781761169,
            0.118568,
            cast(float32) -0.4379749894142151,
            0.118116,
            cast(float32) -0.5654259920120239,
            cast(float32) -0.20644600689411164,
            0.113407,
            0.558894,
            0.534627,
            1.154350,
            cast(float32) -0.11683300137519837,
            1.723311
        ];
    VP9_PART_SPLIT_NN_BIAS_16_LAYER0 =
        float32.[
            0.013109,
            cast(float32) -0.034341000020504,
            0.679845,
            cast(float32) -0.035780999809503558,
            cast(float32) -0.10418300330638886,
            0.098055,
            cast(float32) -0.04112999886274338,
            0.160107
        ];
    VP9_PART_SPLIT_NN_WEIGHTS_16_LAYER1 =
        float32.[
            1.499564,
            cast(float32) -0.4032590091228485,
            1.366532,
            cast(float32) -0.469868004322052,
            0.482227,
            cast(float32) -2.0766971111297609,
            0.527691,
            0.540495
        ];
    VP9_PART_SPLIT_NN_BIAS_16_LAYER1 = float32.[ 0.01134653 ];
    VP9_PART_SPLIT_NNCONFIG_16 =
        NN_CONFIG.{
            num_inputs = 12,
            num_outputs = 1,
            num_hidden_layers = 1,
            num_hidden_nodes =
                s32.[ 8, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0 ],
            weights =
                *float32.[ VP9_PART_SPLIT_NN_WEIGHTS_16_LAYER0.data, VP9_PART_SPLIT_NN_WEIGHTS_16_LAYER1.data, null, null, null, null, null, null, null, null, null ],
            bias =
                *float32.[ VP9_PART_SPLIT_NN_BIAS_16_LAYER0.data, VP9_PART_SPLIT_NN_BIAS_16_LAYER1.data, null, null, null, null, null, null, null, null, null ]
        };
    VP9_PART_SPLIT_NN_WEIGHTS_8_LAYER0 =
        float32.[
            cast(float32) -0.668874979019165,
            cast(float32) -0.15907800197601319,
            cast(float32) -0.0626629963517189,
            cast(float32) -0.4837850034236908,
            cast(float32) -0.1468140035867691,
            cast(float32) -0.6089749932289124,
            cast(float32) -0.5891450047492981,
            0.203704,
            cast(float32) -0.051006998866796496,
            cast(float32) -0.11376900225877762,
            cast(float32) -0.4775109887123108,
            cast(float32) -0.12260299921035767,
            cast(float32) -1.3298900127410889,
            1.403386,
            0.199636,
            cast(float32) -0.16113899648189546,
            2.182090,
            cast(float32) -0.014306999742984772,
            0.015755,
            cast(float32) -0.2084680050611496,
            0.884353,
            0.815920,
            0.632464,
            0.838225,
            1.369483,
            cast(float32) -0.029068000614643098,
            0.570213,
            cast(float32) -0.5735459923744202,
            0.029617,
            0.562054,
            cast(float32) -0.6530929803848267,
            cast(float32) -0.21190999448299409,
            cast(float32) -0.6610130071640015,
            cast(float32) -0.3844180107116699,
            cast(float32) -0.574038028717041,
            cast(float32) -0.5100690126419067,
            0.173047,
            cast(float32) -0.2742309868335724,
            cast(float32) -1.0440080165863038,
            cast(float32) -0.4220399856567383,
            cast(float32) -0.8102959990501404,
            0.144069,
            cast(float32) -0.40670400857925417,
            0.411230,
            cast(float32) -0.14402300119400025,
            0.745651,
            cast(float32) -0.5950909852981567,
            0.111787,
            0.840651,
            0.030123,
            cast(float32) -0.24215500056743623,
            0.101486,
            cast(float32) -0.017889000475406648,
            cast(float32) -0.2544670104980469,
            cast(float32) -0.28540700674057009,
            cast(float32) -0.07667499780654907,
            cast(float32) -0.5495420098304749,
            cast(float32) -0.013543999753892422,
            cast(float32) -0.6865659952163696,
            cast(float32) -0.7551500201225281,
            1.623949,
            cast(float32) -0.2863689959049225,
            0.170976,
            0.016442,
            cast(float32) -0.5983530282974243,
            cast(float32) -0.03853999823331833,
            0.202597,
            cast(float32) -0.9335820078849793,
            0.599510,
            0.362273,
            0.577722,
            0.477603,
            0.767097,
            0.431532,
            0.457034,
            0.223279,
            0.381349,
            0.033777,
            0.423923,
            cast(float32) -0.664762020111084,
            0.385662,
            0.075744,
            0.182681,
            0.024118,
            0.319408,
            cast(float32) -0.5288640260696411,
            0.976537,
            cast(float32) -0.3059709966182709,
            cast(float32) -0.1893800050020218,
            cast(float32) -0.24168899655342103,
            cast(float32) -1.3180919885635377,
            0.088647,
            cast(float32) -0.10903000086545944,
            cast(float32) -0.9456539750099182,
            1.082797,
            0.184564
        ];
    VP9_PART_SPLIT_NN_BIAS_8_LAYER0 =
        float32.[
            cast(float32) -0.23747199773788453,
            2.051396,
            0.297062,
            cast(float32) -0.7301939725875855,
            0.060472,
            cast(float32) -0.5659589767456055,
            0.560869,
            cast(float32) -0.3954479992389679
        ];
    VP9_PART_SPLIT_NN_WEIGHTS_8_LAYER1 =
        float32.[
            0.568121,
            1.575915,
            cast(float32) -0.5443090200424194,
            0.751595,
            cast(float32) -0.11791100353002548,
            cast(float32) -1.3407299518585206,
            cast(float32) -0.739670991897583,
            0.661216
        ];
    VP9_PART_SPLIT_NN_BIAS_8_LAYER1 = float32.[ cast(float32) -0.6337530612945557 ];
    VP9_PART_SPLIT_NNCONFIG_8 =
        NN_CONFIG.{
            num_inputs = 12,
            num_outputs = 1,
            num_hidden_layers = 1,
            num_hidden_nodes =
                s32.[ 8, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0 ],
            weights =
                *float32.[ VP9_PART_SPLIT_NN_WEIGHTS_8_LAYER0.data, VP9_PART_SPLIT_NN_WEIGHTS_8_LAYER1.data, null, null, null, null, null, null, null, null, null ],
            bias =
                *float32.[ VP9_PART_SPLIT_NN_BIAS_8_LAYER0.data, VP9_PART_SPLIT_NN_BIAS_8_LAYER1.data, null, null, null, null, null, null, null, null, null ]
        };
    VP9_PARTITION_FEATURE_MEAN =
        float32.[
            cast(float32) 303501.6875,
            cast(float32) 3042630.25,
            24.694696,
            1.392182,
            cast(float32) 689.4135131835938,
            cast(float32) 162.02700805664063,
            1.478213,
            0.0,
            cast(float32) 135382.265625,
            cast(float32) 912738.5,
            28.845217,
            1.515230,
            cast(float32) 544.1585083007813,
            cast(float32) 131.80799865722657,
            1.436863,
            0.0,
            cast(float32) 43682.37890625,
            cast(float32) 208131.71875,
            28.084737,
            1.356677,
            cast(float32) 138.25411987304688,
            cast(float32) 119.52255249023438,
            1.252322,
            0.0
        ];
    VP9_PARTITION_FEATURE_STD =
        float32.[
            cast(float32) 673689.1875,
            cast(float32) 5996652.5,
            0.024449,
            1.989792,
            cast(float32) 985.880859375,
            0.014638,
            2.001898,
            0.0,
            cast(float32) 208798.78125,
            cast(float32) 1812548.5,
            0.018693,
            1.838009,
            cast(float32) 396.9869079589844,
            0.015657,
            1.332541,
            0.0,
            cast(float32) 55888.84765625,
            cast(float32) 448587.96875,
            0.017900,
            1.904776,
            98.652832,
            0.016598,
            1.320992,
            0.0
        ];
    VP9_PARTITION_LINEAR_WEIGHTS =
        float32.[
            0.111736,
            0.289977,
            0.042219,
            0.204765,
            0.120410,
            cast(float32) -0.1438630074262619,
            0.282376,
            0.847811,
            0.637161,
            0.131570,
            0.018636,
            0.202134,
            0.112797,
            0.028162,
            0.182450,
            1.124367,
            0.386133,
            0.083700,
            0.050028,
            0.150873,
            0.061119,
            0.109318,
            0.127255,
            0.625211
        ];
    atomic_store(*globals_initialization_state_for_vp9_encodeframe, 2);
}

#run System_Library_Compiler.compiler_add_library_search_directory("/usr/lib");
System_Library_libm_so_6 :: #library,system "libm.so.6";
logf :: (x: float32) -> float32 #foreign System_Library_libm_so_6;

RD_COST :: struct {
    rate: s32;
    dist: s64;
    rdcost: s64;
}

CONTENT_STATE_SB :: u32;
K_INVALID : s32 : 0;
K_LOW_SAD_LOW_SUMDIFF : s32 : 1;
K_LOW_SAD_HIGH_SUMDIFF : s32 : 2;
K_HIGH_SAD_LOW_SUMDIFF : s32 : 3;
K_HIGH_SAD_HIGH_SUMDIFF : s32 : 4;
K_LOW_VAR_HIGH_SUMDIFF : s32 : 5;
K_VERY_HIGH_SAD : s32 : 6;

Compar_Fn_T :: #type (_: *void, _: *void) -> s32;

NN_CONFIG :: struct {
    num_inputs: s32;
    num_outputs: s32;
    num_hidden_layers: s32;
    num_hidden_nodes: [10] s32;
    weights: [11] *float32;
    bias: [11] *float32;
}

