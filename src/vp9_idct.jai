SUB_PEL_FILTERS_12_in_vp9_idct: [16] Interp_Kernel12 #align 256;

IHT_16: [4] Transform_2d;

IHT_8: [4] Transform_2d;

COUNT_TO_UPDATE_FACTOR_in_vp9_idct: [21] s32;

COSPI_1_64_in_vp9_idct: Tran_Coef_T;

COSPI_2_64_in_vp9_idct: Tran_Coef_T;

COSPI_3_64_in_vp9_idct: Tran_Coef_T;

COSPI_4_64_in_vp9_idct: Tran_Coef_T;

COSPI_5_64_in_vp9_idct: Tran_Coef_T;

COSPI_6_64_in_vp9_idct: Tran_Coef_T;

COSPI_7_64_in_vp9_idct: Tran_Coef_T;

COSPI_8_64_in_vp9_idct: Tran_Coef_T;

COSPI_9_64_in_vp9_idct: Tran_Coef_T;

COSPI_10_64_in_vp9_idct: Tran_Coef_T;

COSPI_11_64_in_vp9_idct: Tran_Coef_T;

COSPI_12_64_in_vp9_idct: Tran_Coef_T;

COSPI_13_64_in_vp9_idct: Tran_Coef_T;

COSPI_14_64_in_vp9_idct: Tran_Coef_T;

COSPI_15_64_in_vp9_idct: Tran_Coef_T;

COSPI_16_64_in_vp9_idct: Tran_Coef_T;

COSPI_17_64_in_vp9_idct: Tran_Coef_T;

COSPI_18_64_in_vp9_idct: Tran_Coef_T;

COSPI_19_64_in_vp9_idct: Tran_Coef_T;

COSPI_20_64_in_vp9_idct: Tran_Coef_T;

COSPI_21_64_in_vp9_idct: Tran_Coef_T;

COSPI_22_64_in_vp9_idct: Tran_Coef_T;

COSPI_23_64_in_vp9_idct: Tran_Coef_T;

COSPI_24_64_in_vp9_idct: Tran_Coef_T;

COSPI_25_64_in_vp9_idct: Tran_Coef_T;

COSPI_26_64_in_vp9_idct: Tran_Coef_T;

COSPI_27_64_in_vp9_idct: Tran_Coef_T;

COSPI_28_64_in_vp9_idct: Tran_Coef_T;

COSPI_29_64_in_vp9_idct: Tran_Coef_T;

COSPI_30_64_in_vp9_idct: Tran_Coef_T;

COSPI_31_64_in_vp9_idct: Tran_Coef_T;

SINPI_1_9_in_vp9_idct: Tran_Coef_T;

SINPI_2_9_in_vp9_idct: Tran_Coef_T;

SINPI_3_9_in_vp9_idct: Tran_Coef_T;

SINPI_4_9_in_vp9_idct: Tran_Coef_T;

clip_pixel_in_vp9_idct :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_idct :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_idct :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_idct :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_idct :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_idct(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_idct(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_idct(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_idct :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_lsb_in_vp9_idct :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_idct :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_idct :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_idct(num_values) + 1 else 0;
}

get_filter_taps_in_vp9_idct :: (FILTER: *s16) -> s32 {
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

vp9_iht16x16_256_add_c :: (input: *Tran_Low_T, dest: *u8, stride: s32, tx_type: s32) {
    j: s32 = ---;
    out: [256] Tran_Low_T = ---;
    outptr := out.data;
    temp_in, temp_out: [16] Tran_Low_T = ---;
    HT := IHT_16[tx_type];

    for i: 0..cast(s32) 16 - 1 {
        HT.rows(input, outptr);
        input += 16;
        outptr += 16;
    }

    for i: 0..cast(s32) 16 - 1 {
        j = 0;
        while j < 16 {
            temp_in[j] = out[j * 16 + i];
            j += 1;
        }
        HT.cols(temp_in.data, temp_out.data);
        j = 0;
        while j < 16 {
            dest[j * stride + i] =
                clip_pixel_add_in_vp9_idct(
                    dest[j * stride + i],
                    ((cast(s32) temp_out[j]) + (cast(s32) 1) << (((6 - 1)) & 31)) >> 6
                );
            j += 1;
        }
    }
}

clip_pixel_add_in_vp9_idct :: (dest: u8, trans: Tran_High_T) -> u8 {
    trans = check_range_in_vp9_idct(trans);
    return clip_pixel_in_vp9_idct((cast(s32) dest) + trans);
}

check_range_in_vp9_idct :: (input: Tran_High_T) -> Tran_High_T {
    return input;
}

vp9_iht4x4_16_add_c :: (input: *Tran_Low_T, dest: *u8, stride: s32, tx_type: s32) {
    IHT_4 :=
        Transform_2d.[
            Transform_2d.{cols = idct4_c, rows = idct4_c},
            Transform_2d.{cols = iadst4_c, rows = idct4_c},
            Transform_2d.{cols = idct4_c, rows = iadst4_c},
            Transform_2d.{cols = iadst4_c, rows = iadst4_c}
        ];
    j: s32 = ---;
    out: [16] Tran_Low_T = ---;
    outptr := out.data;
    temp_in, temp_out: [4] Tran_Low_T = ---;

    for i: 0..cast(s32) 4 - 1 {
        IHT_4[tx_type].rows(input, outptr);
        input += 4;
        outptr += 4;
    }

    for i: 0..cast(s32) 4 - 1 {
        j = 0;
        while j < 4 {
            temp_in[j] = out[j * 4 + i];
            j += 1;
        }
        IHT_4[tx_type].cols(temp_in.data, temp_out.data);
        j = 0;
        while j < 4 {
            dest[j * stride + i] =
                clip_pixel_add_in_vp9_idct(
                    dest[j * stride + i],
                    ((cast(s32) temp_out[j]) + (cast(s32) 1) << (((4 - 1)) & 31)) >> 4
                );
            j += 1;
        }
    }
}

vp9_iht8x8_64_add_c :: (input: *Tran_Low_T, dest: *u8, stride: s32, tx_type: s32) {
    j: s32 = ---;
    out: [64] Tran_Low_T = ---;
    outptr := out.data;
    temp_in, temp_out: [8] Tran_Low_T = ---;
    HT := IHT_8[tx_type];

    for i: 0..cast(s32) 8 - 1 {
        HT.rows(input, outptr);
        input += 8;
        outptr += 8;
    }

    for i: 0..cast(s32) 8 - 1 {
        j = 0;
        while j < 8 {
            temp_in[j] = out[j * 8 + i];
            j += 1;
        }
        HT.cols(temp_in.data, temp_out.data);
        j = 0;
        while j < 8 {
            dest[j * stride + i] =
                clip_pixel_add_in_vp9_idct(
                    dest[j * stride + i],
                    ((cast(s32) temp_out[j]) + (cast(s32) 1) << (((5 - 1)) & 31)) >> 5
                );
            j += 1;
        }
    }
}

get_prob_in_vp9_idct :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_idct :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_idct(n0, DEN);
}

weighted_prob_in_vp9_idct :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_idct :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_idct(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_idct(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_idct :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_idct[COUNT];
        PROB := get_prob_in_vp9_idct(ct[0], DEN);
        return weighted_prob_in_vp9_idct(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_band_translate_in_vp9_idct :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_idct :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_idct :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_idct(above_ec, left_ec);
}

is_zero_mv_in_vp9_idct :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_idct :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_idct :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_idct(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_idct(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_idct :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_idct :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_idct :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_idct :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

vp9_is_valid_scale_in_vp9_idct :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_idct :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_idct(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_idct :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_idct :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_idct :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_idct :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_idct :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_idct :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_idct :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_idct :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_idct :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_idct :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_idct :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_idct(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_idct :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_idct(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_idct(MI, ib)];
}

get_uv_tx_size_in_vp9_idct :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_idct :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_idct :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_idct(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_idct :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

dct_const_round_shift_in_vp9_idct :: (input: Tran_High_T) -> Tran_High_T {
    rv := (input + cast,no_check(Tran_High_T) (((cast(s32) 1) << (((14 - 1)) & 31)))) >> 14;
    return rv;
}

vp9_iwht4x4_add :: (input: *Tran_Low_T, dest: *u8, stride: s32, eob: s32) {
    if eob > 1 {
        iwht4x4_16_add_c(input, dest, stride);
    } else {
        iwht4x4_1_add_c(input, dest, stride);
    }
}

vp9_idct4x4_add :: (input: *Tran_Low_T, dest: *u8, stride: s32, eob: s32) {
    if eob > 1 {
        idct4x4_16_add_c(input, dest, stride);
    } else {
        idct4x4_1_add_c(input, dest, stride);
    }
}

vp9_idct8x8_add :: (input: *Tran_Low_T, dest: *u8, stride: s32, eob: s32) {
    if eob == 1 {
        idct8x8_1_add_c(input, dest, stride);
    } else if eob <= 12 {
        idct8x8_12_add_c(input, dest, stride);
    } else {
        idct8x8_64_add_c(input, dest, stride);
    }
}

vp9_idct16x16_add :: (input: *Tran_Low_T, dest: *u8, stride: s32, eob: s32) {
    if eob == 1 {
        idct16x16_1_add_c(input, dest, stride);
    } else if eob <= 10 {
        idct16x16_10_add_c(input, dest, stride);
    } else if eob <= 38 {
        idct16x16_38_add_c(input, dest, stride);
    } else {
        idct16x16_256_add_c(input, dest, stride);
    }
}

vp9_idct32x32_add :: (input: *Tran_Low_T, dest: *u8, stride: s32, eob: s32) {
    if eob == 1 {
        idct32x32_1_add_c(input, dest, stride);
    } else if eob <= 34 {
        idct32x32_34_add_c(input, dest, stride);
    } else if eob <= 135 {
        idct32x32_135_add_c(input, dest, stride);
    } else {
        idct32x32_1024_add_c(input, dest, stride);
    }
}

vp9_iht4x4_add :: (tx_type: TX_TYPE, input: *Tran_Low_T, dest: *u8, stride: s32, eob: s32) {
    if tx_type == cast,no_check(u32) DCT_DCT {
        vp9_idct4x4_add(input, dest, stride, eob);
    } else {
        vp9_iht4x4_16_add_c(input, dest, stride, cast,no_check(s32) tx_type);
    }
}

vp9_iht8x8_add :: (tx_type: TX_TYPE, input: *Tran_Low_T, dest: *u8, stride: s32, eob: s32) {
    if tx_type == cast,no_check(u32) DCT_DCT {
        vp9_idct8x8_add(input, dest, stride, eob);
    } else {
        vp9_iht8x8_64_add_c(input, dest, stride, cast,no_check(s32) tx_type);
    }
}

vp9_iht16x16_add :: (tx_type: TX_TYPE, input: *Tran_Low_T, dest: *u8, stride: s32, eob: s32) {
    if tx_type == cast,no_check(u32) DCT_DCT {
        vp9_idct16x16_add(input, dest, stride, eob);
    } else {
        vp9_iht16x16_256_add_c(input, dest, stride, cast,no_check(s32) tx_type);
    }
}

globals_initialization_state_for_vp9_idct: u32;
initialize_globals_for_vp9_idct :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_idct);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_idct, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_idct) != 2 {}
            return;
        }
    }
    SUB_PEL_FILTERS_12_in_vp9_idct =
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
    IHT_8 =
        Transform_2d.[
            Transform_2d.{cols = idct8_c, rows = idct8_c},
            Transform_2d.{cols = iadst8_c, rows = idct8_c},
            Transform_2d.{cols = idct8_c, rows = iadst8_c},
            Transform_2d.{cols = iadst8_c, rows = iadst8_c}
        ];
    IHT_16 =
        Transform_2d.[
            Transform_2d.{cols = idct16_c, rows = idct16_c},
            Transform_2d.{cols = iadst16_c, rows = idct16_c},
            Transform_2d.{cols = idct16_c, rows = iadst16_c},
            Transform_2d.{cols = iadst16_c, rows = iadst16_c}
        ];
    COUNT_TO_UPDATE_FACTOR_in_vp9_idct =
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
    COSPI_1_64_in_vp9_idct = 16364;
    COSPI_2_64_in_vp9_idct = 16305;
    COSPI_3_64_in_vp9_idct = 16207;
    COSPI_4_64_in_vp9_idct = 16069;
    COSPI_5_64_in_vp9_idct = 15893;
    COSPI_6_64_in_vp9_idct = 15679;
    COSPI_7_64_in_vp9_idct = 15426;
    COSPI_8_64_in_vp9_idct = 15137;
    COSPI_9_64_in_vp9_idct = 14811;
    COSPI_10_64_in_vp9_idct = 14449;
    COSPI_11_64_in_vp9_idct = 14053;
    COSPI_12_64_in_vp9_idct = 13623;
    COSPI_13_64_in_vp9_idct = 13160;
    COSPI_14_64_in_vp9_idct = 12665;
    COSPI_15_64_in_vp9_idct = 12140;
    COSPI_16_64_in_vp9_idct = 11585;
    COSPI_17_64_in_vp9_idct = 11003;
    COSPI_18_64_in_vp9_idct = 10394;
    COSPI_19_64_in_vp9_idct = 9760;
    COSPI_20_64_in_vp9_idct = 9102;
    COSPI_21_64_in_vp9_idct = 8423;
    COSPI_22_64_in_vp9_idct = 7723;
    COSPI_23_64_in_vp9_idct = 7005;
    COSPI_24_64_in_vp9_idct = 6270;
    COSPI_25_64_in_vp9_idct = 5520;
    COSPI_26_64_in_vp9_idct = 4756;
    COSPI_27_64_in_vp9_idct = 3981;
    COSPI_28_64_in_vp9_idct = 3196;
    COSPI_29_64_in_vp9_idct = 2404;
    COSPI_30_64_in_vp9_idct = 1606;
    COSPI_31_64_in_vp9_idct = 804;
    SINPI_1_9_in_vp9_idct = 5283;
    SINPI_2_9_in_vp9_idct = 9929;
    SINPI_3_9_in_vp9_idct = 13377;
    SINPI_4_9_in_vp9_idct = 15212;
    atomic_store(*globals_initialization_state_for_vp9_idct, 2);
}

Transform_1d :: #type (_: *Tran_Low_T, _: *Tran_Low_T);

Transform_2d :: struct {
    cols: Transform_1d;
    rows: Transform_1d;
}

