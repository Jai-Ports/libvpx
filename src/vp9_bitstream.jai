COUNT_TO_UPDATE_FACTOR_in_vp9_bitstream: [21] s32;

SUB_PEL_FILTERS_12_in_vp9_bitstream: [16] Interp_Kernel12 #align 256;

MODE_2_COUNTER_storage: [14] s32;

COUNTER_TO_CONTEXT_storage: [19] s32;

MV_REF_BLOCKS_storage: [13] [8] POSITION;

IDX_N_COLUMN_TO_SUBBLOCK_storage: [4] [2] s32;

FRAME_SCALE_FACTOR_storage: [2] s32;

RATE_THRESH_MULT_storage: [2] float64;

RCF_MULT_storage: [2] float64;

K_VP9_REF_FLAG_LIST_storage: [4] s32;

INTER_MODE_ENCODINGS: [4] Vp9_Token;

SWITCHABLE_INTERP_ENCODINGS: [3] Vp9_Token;

INTRA_MODE_ENCODINGS: [10] Vp9_Token;

PARTITION_ENCODINGS: [4] Vp9_Token;

clip_pixel_in_vp9_bitstream :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_bitstream :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_bitstream :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_bitstream :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_bitstream :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_bitstream(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_bitstream(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_bitstream(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_bitstream :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

mem_get_be16_aligned_as_int :: (vmem: *void) -> u32 {
    mem := cast(*u16) vmem;

    val: u32 = ---;
    raw := cast,no_check(u32) mem.*;

    val = cast,no_check(u32) (cast,no_check(u16) ((raw >> 8 & 0xff) | (raw << 8 & 0xff00)));

    return val;
}

mem_get_be32_aligned_as_int :: (vmem: *void) -> u32 {
    mem := cast(*u32) vmem;

    val: u32 = ---;
    raw: u32 = mem.*;

    val = (((raw >> 24 & 0xff) | (raw >> 8 & 0xff00)) | (raw << 8 & 0xff0000)) | (raw << 24 & 0xff000000);

    return val;
}

mem_get_le16_aligned_as_int :: (vmem: *void) -> u32 {
    mem := cast(*u16) vmem;

    return cast,no_check(u32) mem.*;
}

mem_get_le32_aligned_as_int :: (vmem: *void) -> u32 {
    mem := cast(*u32) vmem;

    return mem.*;
}

mem_get_sbe16_aligned_as_int :: (vmem: *void) -> s32 {
    mem := cast(*s16) vmem;

    val: u32 = ---;
    raw := cast,no_check(u32) mem.*;

    val = cast,no_check(u32) (cast,no_check(u16) ((raw >> 8 & 0xff) | (raw << 8 & 0xff00)));

    val = val << 16 >> 16;

    return cast,no_check(s32) val;
}

mem_get_sbe32_aligned_as_int :: (vmem: *void) -> s32 {
    mem := cast(*s32) vmem;

    val: u32 = ---;
    raw := cast,no_check(u32) mem.*;

    val = (((raw >> 24 & 0xff) | (raw >> 8 & 0xff00)) | (raw << 8 & 0xff0000)) | (raw << 24 & 0xff000000);

    return cast,no_check(s32) val;
}

mem_get_sle16_aligned_as_int :: (vmem: *void) -> s32 {
    mem := cast(*s16) vmem;

    return cast,no_check(s32) mem.*;
}

mem_get_sle32_aligned_as_int :: (vmem: *void) -> s32 {
    mem := cast(*s32) vmem;

    return mem.*;
}

mem_put_be16_aligned_as_int :: (vmem: *void, val: s32) {
    mem := cast(*u16) vmem;
    raw: u16 = ---;

    raw = cast,no_check(u16) (val >> 8 & 0xff | (val << 8 & 0xff00));

    mem.* = raw;
}

mem_put_be32_aligned_as_int :: (vmem: *void, val: s32) {
    mem := cast(*u32) vmem;
    raw: u32 = ---;

    raw =
        (cast,no_check(u32) (val >> 24 & 0xff | (val >> 8 & 0xff00) | (val << 8 & 0xff0000))) | ((cast,no_check(u32) (val << 24)) & 0xff000000);

    mem.* = raw;
}

mem_put_le16_aligned_as_int :: (vmem: *void, val: s32) {
    mem := cast(*u16) vmem;

    mem.* = cast,no_check(u16) val;
}

mem_put_le32_aligned_as_int :: (vmem: *void, val: s32) {
    mem := cast(*u32) vmem;

    mem.* = cast,no_check(u32) val;
}

mem_get_be16_as_int :: (vmem: *void) -> u32 {
    mem := cast(*u8) vmem;

    val := cast,no_check(u32) ((cast(s32) mem[0]) << 8);
    val |= cast,no_check(u32) mem[1];
    return val;
}

mem_get_be24_as_int :: (vmem: *void) -> u32 {
    mem := cast(*u8) vmem;

    val := cast,no_check(u32) ((cast(s32) mem[0]) << 16);
    val |= cast,no_check(u32) ((cast(s32) mem[1]) << 8);
    val |= cast,no_check(u32) mem[2];
    return val;
}

mem_get_be32_as_int :: (vmem: *void) -> u32 {
    mem := cast(*u8) vmem;

    val := (cast,no_check(u32) mem[0]) << 24;
    val |= cast,no_check(u32) ((cast(s32) mem[1]) << 16);
    val |= cast,no_check(u32) ((cast(s32) mem[2]) << 8);
    val |= cast,no_check(u32) mem[3];
    return val;
}

mem_get_le16_as_int :: (vmem: *void) -> u32 {
    mem := cast(*u8) vmem;

    val := cast,no_check(u32) ((cast(s32) mem[1]) << 8);
    val |= cast,no_check(u32) mem[0];
    return val;
}

mem_get_le24_as_int :: (vmem: *void) -> u32 {
    mem := cast(*u8) vmem;

    val := cast,no_check(u32) ((cast(s32) mem[2]) << 16);
    val |= cast,no_check(u32) ((cast(s32) mem[1]) << 8);
    val |= cast,no_check(u32) mem[0];
    return val;
}

mem_get_le32_as_int :: (vmem: *void) -> u32 {
    mem := cast(*u8) vmem;

    val := (cast,no_check(u32) mem[3]) << 24;
    val |= cast,no_check(u32) ((cast(s32) mem[2]) << 16);
    val |= cast,no_check(u32) ((cast(s32) mem[1]) << 8);
    val |= cast,no_check(u32) mem[0];
    return val;
}

mem_get_sbe16_as_int :: (vmem: *void) -> s32 {
    mem := cast(*u8) vmem;

    val := cast,no_check(s32) mem_get_be16_as_int(cast(*void) mem);

    return (val << ((((cast(u64) size_of(s32)) << 3 - 16)) & 31)) >> ((((cast(u64) size_of(s32)) << 3 - 16)) & 31);
}

mem_get_sbe24_as_int :: (vmem: *void) -> s32 {
    mem := cast(*u8) vmem;

    val := cast,no_check(s32) mem_get_be24_as_int(cast(*void) mem);

    return (val << ((((cast(u64) size_of(s32)) << 3 - 24)) & 31)) >> ((((cast(u64) size_of(s32)) << 3 - 24)) & 31);
}

mem_get_sbe32_as_int :: (vmem: *void) -> s32 {
    mem := cast(*u8) vmem;

    val := cast,no_check(s32) mem_get_be32_as_int(cast(*void) mem);

    return (val << ((((cast(u64) size_of(s32)) << 3 - 32)) & 31)) >> ((((cast(u64) size_of(s32)) << 3 - 32)) & 31);
}

mem_get_sle16_as_int :: (vmem: *void) -> s32 {
    mem := cast(*u8) vmem;

    val := cast,no_check(s32) mem_get_le16_as_int(cast(*void) mem);

    return (val << ((((cast(u64) size_of(s32)) << 3 - 16)) & 31)) >> ((((cast(u64) size_of(s32)) << 3 - 16)) & 31);
}

mem_get_sle24_as_int :: (vmem: *void) -> s32 {
    mem := cast(*u8) vmem;

    val := cast,no_check(s32) mem_get_le24_as_int(cast(*void) mem);

    return (val << ((((cast(u64) size_of(s32)) << 3 - 24)) & 31)) >> ((((cast(u64) size_of(s32)) << 3 - 24)) & 31);
}

mem_get_sle32_as_int :: (vmem: *void) -> s32 {
    mem := cast(*u8) vmem;

    val := cast,no_check(s32) mem_get_le32_as_int(cast(*void) mem);

    return (val << ((((cast(u64) size_of(s32)) << 3 - 32)) & 31)) >> ((((cast(u64) size_of(s32)) << 3 - 32)) & 31);
}

mem_put_be16_as_int :: (vmem: *void, val: s32) {
    mem := cast(*u8) vmem;

    mem[0] = cast,no_check(u8) (val >> 8 & 0xff);
    mem[1] = cast,no_check(u8) (val & 0xff);
}

mem_put_be24_as_int :: (vmem: *void, val: s32) {
    mem := cast(*u8) vmem;

    mem[0] = cast,no_check(u8) (val >> 16 & 0xff);
    mem[1] = cast,no_check(u8) (val >> 8 & 0xff);
    mem[2] = cast,no_check(u8) (val & 0xff);
}

mem_put_be32_as_int :: (vmem: *void, val: s32) {
    mem := cast(*u8) vmem;

    mem[0] = cast,no_check(u8) (val >> 24 & 0xff);
    mem[1] = cast,no_check(u8) (val >> 16 & 0xff);
    mem[2] = cast,no_check(u8) (val >> 8 & 0xff);
    mem[3] = cast,no_check(u8) (val & 0xff);
}

mem_put_le16_as_int :: (vmem: *void, val: s32) {
    mem := cast(*u8) vmem;

    mem[0] = cast,no_check(u8) (val & 0xff);
    mem[1] = cast,no_check(u8) (val >> 8 & 0xff);
}

mem_put_le24_as_int :: (vmem: *void, val: s32) {
    mem := cast(*u8) vmem;

    mem[0] = cast,no_check(u8) (val & 0xff);
    mem[1] = cast,no_check(u8) (val >> 8 & 0xff);
    mem[2] = cast,no_check(u8) (val >> 16 & 0xff);
}

mem_put_le32_as_int :: (vmem: *void, val: s32) {
    mem := cast(*u8) vmem;

    mem[0] = cast,no_check(u8) (val & 0xff);
    mem[1] = cast,no_check(u8) (val >> 8 & 0xff);
    mem[2] = cast,no_check(u8) (val >> 16 & 0xff);
    mem[3] = cast,no_check(u8) (val >> 24 & 0xff);
}

get_prob_in_vp9_bitstream :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_bitstream :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_bitstream(n0, DEN);
}

weighted_prob_in_vp9_bitstream :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_bitstream :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_bitstream(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_bitstream(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_bitstream :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_bitstream[COUNT];
        PROB := get_prob_in_vp9_bitstream(ct[0], DEN);
        return weighted_prob_in_vp9_bitstream(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_lsb_in_vp9_bitstream :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_bitstream :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_bitstream :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_bitstream(num_values) + 1 else 0;
}

get_band_translate_in_vp9_bitstream :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_bitstream :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_bitstream :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_bitstream(above_ec, left_ec);
}

is_zero_mv_in_vp9_bitstream :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_bitstream :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_bitstream :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_bitstream(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_bitstream(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_bitstream :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_bitstream :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_bitstream :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_bitstream :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

get_filter_taps_in_vp9_bitstream :: (FILTER: *s16) -> s32 {
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

vp9_is_valid_scale_in_vp9_bitstream :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_bitstream :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_bitstream(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_bitstream :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_bitstream :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_bitstream :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_bitstream :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_bitstream :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_bitstream :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_bitstream :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_bitstream :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_bitstream :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_bitstream :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_bitstream :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_bitstream(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_bitstream :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_bitstream(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_bitstream(MI, ib)];
}

get_uv_tx_size_in_vp9_bitstream :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_bitstream :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_bitstream :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_bitstream(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_bitstream :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_bitstream :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_bitstream :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_bitstream :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_bitstream :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_bitstream :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_bitstream :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_bitstream :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_bitstream :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_bitstream :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_bitstream :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_bitstream :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_bitstream :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_bitstream(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_bitstream :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_bitstream(cm.mi_cols);

        if get_plane_type_in_vp9_bitstream(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_bitstream(cm, xd);
}

get_partition_probs_in_vp9_bitstream :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_bitstream :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_bitstream :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_bitstream :: (
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

update_partition_context_in_vp9_bitstream :: (
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

partition_plane_context_in_vp9_bitstream :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

clamp_mv_ref_in_vp9_bitstream :: (mv: *MV, xd: *MACROBLOCKD) {
    clamp_mv_in_vp9_bitstream(
        mv,
        xd.mb_to_left_edge - (cast(s32) 16) << 3,
        xd.mb_to_right_edge + (cast(s32) 16) << 3,
        xd.mb_to_top_edge - (cast(s32) 16) << 3,
        xd.mb_to_bottom_edge + (cast(s32) 16) << 3
    );
}

get_sub_block_mv_in_vp9_bitstream :: (candidate: *MODE_INFO, which_mv: s32, search_col: s32, block_idx: s32) -> Int_Mv {
    return ifx block_idx >= 0 && candidate.sb_type < 3 then candidate.bmi[IDX_N_COLUMN_TO_SUBBLOCK_storage[block_idx][cast(s32) (search_col == 0)]].as_mv[which_mv] else candidate.mv[which_mv];
}

scale_mv_in_vp9_bitstream :: (
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

is_inside_in_vp9_bitstream :: (TILE: *Tile_Info, mi_col: s32, mi_row: s32, mi_rows: s32, mi_pos: *POSITION) -> s32 {
    if !(mi_row + mi_pos.row < 0 || mi_col + mi_pos.col < TILE.mi_col_start || mi_row + mi_pos.row >= mi_rows || mi_col + mi_pos.col >= TILE.mi_col_end) {
        return 1;
    }
    return 0;
}

clamp_mv2_in_vp9_bitstream :: (mv: *MV, xd: *MACROBLOCKD) {
    clamp_mv_in_vp9_bitstream(
        mv,
        xd.mb_to_left_edge - (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_right_edge + (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_top_edge - (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_bottom_edge + (cast,no_check(s32) ((160 - 4))) << 3
    );
}

lower_mv_precision_in_vp9_bitstream :: (mv: *MV, allow_hp: s32) {
    USE_HP := cast(s32) (allow_hp != 0 && use_mv_hp_in_vp9_bitstream(mv) != 0);
    if USE_HP == 0 {
        if mv.row & 1 != 0 {
            c_transpiler_compound_add(*(mv.row), ((ifx mv.row > 0 then cast(s32) -1 else 1)), s32, s32);
        }
        if mv.col & 1 != 0 {
            c_transpiler_compound_add(*(mv.col), ((ifx mv.col > 0 then cast(s32) -1 else 1)), s32, s32);
        }
    }
}

get_segment_id_in_vp9_bitstream :: (
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

vp9_get_pred_context_seg_id_in_vp9_bitstream :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    ABOVE_SIP := (ifx ABOVE_MI != null then cast,no_check(s32) ABOVE_MI.seg_id_predicted else 0);
    LEFT_SIP := (ifx LEFT_MI != null then cast,no_check(s32) LEFT_MI.seg_id_predicted else 0);

    return ABOVE_SIP + LEFT_SIP;
}

vp9_get_pred_prob_seg_id_in_vp9_bitstream :: (seg: *Segmentation, xd: *MACROBLOCKD) -> Prob {
    return seg.pred_probs[vp9_get_pred_context_seg_id_in_vp9_bitstream(xd)];
}

vp9_get_skip_context_in_vp9_bitstream :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    ABOVE_SKIP := (ifx ABOVE_MI != null then cast,no_check(s32) ABOVE_MI.skip else 0);
    LEFT_SKIP := (ifx LEFT_MI != null then cast,no_check(s32) LEFT_MI.skip else 0);
    return ABOVE_SKIP + LEFT_SKIP;
}

vp9_get_skip_prob_in_vp9_bitstream :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.skip_probs[vp9_get_skip_context_in_vp9_bitstream(xd)];
}

get_pred_context_switchable_interp_in_vp9_bitstream :: (xd: *MACROBLOCKD) -> s32 {
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

get_intra_inter_context_in_vp9_bitstream :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    HAS_ABOVE := cast(s32) (ABOVE_MI != null);
    HAS_LEFT := cast(s32) (LEFT_MI != null);

    if HAS_ABOVE != 0 && HAS_LEFT != 0 {
        ABOVE_INTRA := cast(s32) (is_inter_block_in_vp9_bitstream(ABOVE_MI) == 0);
        LEFT_INTRA := cast(s32) (is_inter_block_in_vp9_bitstream(LEFT_MI) == 0);
        return ifx LEFT_INTRA != 0 && ABOVE_INTRA != 0 then 3 else cast(s32) (LEFT_INTRA != 0 || ABOVE_INTRA != 0);
    } else if HAS_ABOVE != 0 || HAS_LEFT != 0 {
        return 2 * cast(s32) (is_inter_block_in_vp9_bitstream((ifx HAS_ABOVE != 0 then ABOVE_MI else LEFT_MI)) == 0);
    }
    return 0;
}

vp9_get_intra_inter_prob_in_vp9_bitstream :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.intra_inter_prob[get_intra_inter_context_in_vp9_bitstream(xd)];
}

vp9_get_reference_mode_prob_in_vp9_bitstream :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.comp_inter_prob[vp9_get_reference_mode_context(cm, xd)];
}

vp9_get_pred_prob_comp_ref_p_in_vp9_bitstream :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    PRED_CONTEXT := vp9_get_pred_context_comp_ref_p(cm, xd);
    return cm.fc.comp_ref_prob[PRED_CONTEXT];
}

vp9_get_pred_prob_single_ref_p1_in_vp9_bitstream :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return ((cm.fc.single_ref_prob[vp9_get_pred_context_single_ref_p1(xd)]).data)[0];
}

vp9_get_pred_prob_single_ref_p2_in_vp9_bitstream :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return ((cm.fc.single_ref_prob[vp9_get_pred_context_single_ref_p2(xd)]).data)[1];
}

get_tx_size_context_in_vp9_bitstream :: (xd: *MACROBLOCKD) -> s32 {
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

get_tx_probs_in_vp9_bitstream :: (max_tx_size: TX_SIZE, ctx: s32, tx_probs: *Tx_Probs) -> *Prob {
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

get_tx_counts_in_vp9_bitstream :: (max_tx_size: TX_SIZE, ctx: s32, tx_counts: *Tx_Counts) -> *u32 {
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

cost_branch256_in_vp9_bitstream :: (ct: *u32, p: Prob) -> u64 {
    return ((cast,no_check(u64) ct[0]) * cast(u64) VP9_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP9_PROB_COST[256 - cast(s32) p];
}

treed_cost_in_vp9_bitstream :: (tree: *Tree_Index, probs: *Prob, bits: s32, len: s32) -> s32 {
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

vp8_set_reference_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_vp9_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

gcd_in_vp9_bitstream :: (a: s64, b: s32) -> s32 {
    while b != 0 {
        r := cast,no_check(s32) (a % cast(s64) b);
        a = cast,no_check(s64) b;
        b = r;
    }

    return cast,no_check(s32) a;
}

reduce_ratio_in_vp9_bitstream :: (ratio: *Rational64_T) {
    DENOM := gcd_in_vp9_bitstream(ratio.num, ratio.den);
    ratio.num /= cast,no_check(s64) DENOM;
    ratio.den /= DENOM;
}

cyclic_refresh_segment_id_boosted_in_vp9_bitstream :: (segment_id: s32) -> s32 {
    if segment_id == 1 || segment_id == 2 {
        return 1;
    }
    return 0;
}

cyclic_refresh_segment_id_in_vp9_bitstream :: (segment_id: s32) -> s32 {
    if segment_id == 1 {
        return 1;
    } else if segment_id == 2 {
        return 2;
    } else {
        return 0;
    }
}

fps_init_first_pass_info_in_vp9_bitstream :: (
    first_pass_info: *FIRST_PASS_INFO,
    stats: *FIRSTPASS_STATS_in_vp9_cx_iface,
    num_frames: s32
) {
    first_pass_info.stats = stats;
    first_pass_info.num_frames = num_frames;
}

fps_get_num_frames_in_vp9_bitstream :: (first_pass_info: *FIRST_PASS_INFO) -> s32 {
    return first_pass_info.num_frames;
}

fps_get_frame_stats_in_vp9_bitstream :: (
    first_pass_info: *FIRST_PASS_INFO,
    show_idx: s32
) -> *FIRSTPASS_STATS_in_vp9_cx_iface {
    if show_idx < 0 || show_idx >= first_pass_info.num_frames {
        return null;
    }
    return *(cast(*FIRSTPASS_STATS_in_vp9_cx_iface) (first_pass_info.stats))[show_idx];
}

get_buf_from_mv_in_vp9_bitstream :: (buf: *Buf_2d, mv: *MV) -> *u8 {
    return *buf.buf[(cast(s32) mv.row) * buf.stride + cast(s32) mv.col];
}

rd_less_than_thresh_in_vp9_bitstream :: (best_rd: s64, thresh: s32, THRESH_FACT: *s32) -> s32 {
    if best_rd < ((cast,no_check(s64) thresh) * cast(s64) THRESH_FACT.*) >> 5 || thresh == 2147483647 {
        return 1;
    }
    return 0;
}

set_error_per_bit_in_vp9_bitstream :: (x: *MACROBLOCK, rdmult: s32) {
    x.errorperbit = rdmult >> 6;
    x.errorperbit += cast(s32) (x.errorperbit == 0);
}

write_in_vp9_bitstream :: (br: *Writer, bit: s32, probability: s32) {
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

write_bit_in_vp9_bitstream :: (w: *Writer, bit: s32) {
    write_in_vp9_bitstream(w, bit, 128);
}

write_literal_in_vp9_bitstream :: (w: *Writer, data: s32, bits: s32) {
    bit := bits - 1;
    while bit >= 0 {
        write_bit_in_vp9_bitstream(w, 1 & (data >> ((bit) & 31)));
        bit -= 1;
    }
}

vp9_write_tree_in_vp9_bitstream :: (w: *Writer, tree: *Tree_Index, probs: *Prob, bits: s32, len: s32, i: Tree_Index) {
    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            write_in_vp9_bitstream(w, BIT, cast,no_check(s32) probs[(cast(s32) i) >> 1]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }
}

vp9_write_token_in_vp9_bitstream :: (w: *Writer, tree: *Tree_Index, probs: *Prob, token: *Vp9_Token) {
    vp9_write_tree_in_vp9_bitstream(w, tree, probs, token.value, token.len, 0);
}

vp9_get_high_cost_table_in_vp9_bitstream :: (bit_depth: s32) -> *u16 {
    return VP9_CAT6_HIGH_COST.data;
}

vp9_get_token_extra_in_vp9_bitstream :: (v: s32, token: *s16, extra: *EXTRABIT) {
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

vp9_get_token_in_vp9_bitstream :: (v: s32) -> s16 {
    if v >= 67 || v <= -67 {
        return 10;
    }
    return vp9_dct_cat_lt_10_value_tokens[v].token;
}

vp9_get_token_cost_in_vp9_bitstream :: (v: s32, token: *s16, cat6_high_table: *u16) -> s32 {
    if v >= 67 || v <= -67 {
        token.* = 10;
        extrabits := cast,no_check(EXTRABIT) (absolute_value(v) - 67);
        return (cast(s32) VP9_CAT6_LOW_COST[extrabits & 0xff]) + cast(s32) cat6_high_table[(cast(s32) extrabits) >> 8];
    }
    token.* = vp9_dct_cat_lt_10_value_tokens[v].token;
    return vp9_dct_cat_lt_10_value_cost[v];
}

is_lossless_requested_in_vp9_bitstream :: (cfg: *VP9_Encoder_Config) -> s32 {
    if cfg.best_allowed_q == 0 && cfg.worst_allowed_q == 0 {
        return 1;
    }
    return 0;
}

stack_pop_in_vp9_bitstream :: (stack: *s32, stack_size: s32) -> s32 {
    R := stack[0];
    if 1 < stack_size {
        for idx: 1..stack_size - 1 {
            stack[idx - 1] = stack[idx];
        }
    }

    return R;
}

stack_top_in_vp9_bitstream :: (stack: *s32) -> s32 {
    return stack[0];
}

stack_push_in_vp9_bitstream :: (stack: *s32, new_item: s32, stack_size: s32) {
    idx := stack_size;
    while idx > 0 {
        stack[idx] = stack[idx - 1];
        idx -= 1;
    }
    stack[0] = new_item;
}

stack_init_in_vp9_bitstream :: (stack: *s32, length: s32) {
    if 0 < length {
        for idx: 0..length - 1 {
            stack[idx] = -1;
        }
    }
}

frame_is_kf_gf_arf_in_vp9_bitstream :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if frame_is_intra_only_in_vp9_bitstream(*cpi.common) != 0 ||
        cpi.refresh_alt_ref_frame != 0 ||
        cpi.refresh_golden_frame != 0 && cpi.rc.is_src_frame_alt_ref == 0 {
        return 1;
    }
    return 0;
}

ref_frame_to_flag_in_vp9_bitstream :: (ref_frame: s8) -> s32 {

    return K_VP9_REF_FLAG_LIST_storage[ref_frame];
}

get_ref_frame_map_idx_in_vp9_bitstream :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame: MV_REFERENCE_FRAME) -> s32 {
    if ref_frame == 1 {
        return cpi.lst_fb_idx;
    } else if ref_frame == 2 {
        return cpi.gld_fb_idx;
    } else {
        return cpi.alt_fb_idx;
    }
}

get_ref_frame_buf_idx_in_vp9_bitstream :: (CPI: *VP9_COMP_in_vp9_encoder, ref_frame: s32) -> s32 {
    CM := *CPI.common;
    MAP_IDX := get_ref_frame_map_idx_in_vp9_bitstream(CPI, cast,no_check(MV_REFERENCE_FRAME) ref_frame);
    return ifx MAP_IDX != -1 then CM.ref_frame_map[MAP_IDX] else -1;
}

get_ref_cnt_buffer_in_vp9_bitstream :: (cm: *VP9_COMMON, fb_idx: s32) -> *Ref_Cnt_Buffer {
    return ifx fb_idx != -1 then cm.buffer_pool.frame_bufs.data + fb_idx else null;
}

get_ref_frame_bufs_in_vp9_bitstream :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame_bufs: **Ref_Cnt_Buffer) {
    CM := *cpi.common;

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame < 4 {
        ref_frame_buf_idx := get_ref_frame_buf_idx_in_vp9_bitstream(cpi, cast,no_check(s32) ref_frame);
        inter_ref_idx := mv_ref_frame_to_inter_ref_idx_in_vp9_bitstream(ref_frame);
        ref_frame_bufs[inter_ref_idx] = get_ref_cnt_buffer_in_vp9_bitstream(CM, ref_frame_buf_idx);
        ref_frame += 1;
    }
}

get_ref_frame_buffer_in_vp9_bitstream :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    ref_frame: MV_REFERENCE_FRAME
) -> *YV12_BUFFER_CONFIG {
    CM := *CPI.common;
    BUF_IDX := get_ref_frame_buf_idx_in_vp9_bitstream(CPI, cast,no_check(s32) ref_frame);
    return ifx BUF_IDX != -1 then *CM.buffer_pool.frame_bufs[BUF_IDX].buf else null;
}

get_token_alloc_in_vp9_bitstream :: (mb_rows: s32, mb_cols: s32) -> s64 {
    ALIGNED_MB_ROWS :=
        (mb_rows +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    ALIGNED_MB_COLS :=
        (mb_cols +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    return ((cast,no_check(s64) ALIGNED_MB_ROWS) * cast(s64) ALIGNED_MB_COLS) * cast,no_check(s64) ((cast,no_check(s32) ((16 * 16))) * 3 + 4);
}

allocated_tokens_in_vp9_bitstream :: (tile: Tile_Info) -> s64 {
    tile_mb_rows := (tile.mi_row_end - tile.mi_row_start + 1) >> 1;
    tile_mb_cols := (tile.mi_col_end - tile.mi_col_start + 1) >> 1;

    return get_token_alloc_in_vp9_bitstream(tile_mb_rows, tile_mb_cols);
}

get_start_tok_in_vp9_bitstream :: (
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

    tok.* = cpi.tile_tok[tile_row][tile_col] + get_token_alloc_in_vp9_bitstream(MB_ROW, tile_mb_cols);
}

is_one_pass_svc_in_vp9_bitstream :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if CPI.use_svc != 0 && CPI.oxcf.pass == 0 {
        return 1;
    }
    return 0;
}

is_altref_enabled_in_vp9_bitstream :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if !(CPI.oxcf.mode == cast,no_check(u32) REALTIME && CPI.oxcf.rc_mode == cast,no_check(u32) CBR) &&
        CPI.oxcf.lag_in_frames >= 4 &&
        CPI.oxcf.enable_auto_arf != 0 {
        return 1;
    }
    return 0;
}

set_ref_ptrs_in_vp9_bitstream :: (
    CM: *VP9_COMMON,
    xd: *MACROBLOCKD,
    ref0: MV_REFERENCE_FRAME,
    ref1: MV_REFERENCE_FRAME
) {
    xd.block_refs[0] = CM.frame_refs.data + (ifx ref0 >= 1 then (cast(s32) ref0) - 1 else 0);
    xd.block_refs[1] = CM.frame_refs.data + (ifx ref1 >= 1 then (cast(s32) ref1) - 1 else 0);
}

get_chessboard_index_in_vp9_bitstream :: (FRAME_INDEX: s32) -> s32 {
    return FRAME_INDEX & 0x1;
}

cond_cost_list_in_vp9_bitstream :: (cpi: *VP9_COMP_in_vp9_encoder, cost_list: *s32) -> *s32 {
    return ifx cpi.sf.mv.subpel_search_method != cast,no_check(u32) SUBPEL_TREE then cost_list else null;
}

get_num_vert_units_in_vp9_bitstream :: (tile: Tile_Info, shift: s32) -> s32 {
    num_vert_units := (tile.mi_row_end - tile.mi_row_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_vert_units;
}

get_num_cols_in_vp9_bitstream :: (tile: Tile_Info, shift: s32) -> s32 {
    num_cols := (tile.mi_col_end - tile.mi_col_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_cols;
}

get_level_index_in_vp9_bitstream :: (level: VP9_LEVEL) -> s32 {
    for i: 0..cast(s32) 14 - 1 {
        if level == VP9_LEVEL_DEFS[i].level {
            return i;
        }
    }
    return -1;
}

log_tile_cols_from_picsize_level_in_vp9_bitstream :: (width: u32, height: u32) -> s32 {
    PIC_SIZE := width * height;
    PIC_BREADTH := max(width, height);
    for i: 0..cast(s32) 14 - 1 {
        if VP9_LEVEL_DEFS[i].max_luma_picture_size >= PIC_SIZE && VP9_LEVEL_DEFS[i].max_luma_picture_breadth >= PIC_BREADTH {
            return get_msb_in_vp9_bitstream(cast,no_check(u32) VP9_LEVEL_DEFS[i].max_col_tiles);
        }
    }
    return 2147483647;
}

alloc_frame_mvs_in_vp9_bitstream :: (CM: *VP9_COMMON, buffer_idx: s32) {
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

mv_cost_in_vp9_bitstream :: (mv: *MV, joint_cost: *s32, comp_cost: **s32) -> s32 {
    return joint_cost[vp9_get_mv_joint_in_vp9_bitstream(mv)] + comp_cost[0][mv.row] + comp_cost[1][mv.col];
}

mvsad_err_cost_in_vp9_bitstream :: (x: *MACROBLOCK, mv: *MV, ref: *MV, sad_per_bit: s32) -> s32 {
    diff: MV = ---;
    diff.row = cast,no_check(s16) ((cast(s32) mv.row) - cast(s32) ref.row);
    diff.col = cast,no_check(s16) ((cast(s32) mv.col) - cast(s32) ref.col);
    return cast,no_check(s32) ((((cast,no_check(u32) mv_cost_in_vp9_bitstream(*diff, x.nmvjointsadcost.data, x.nmvsadcost.data)) * cast,no_check(u32) sad_per_bit) + cast,no_check(u32) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9);
}

get_start_mv_sad_in_vp9_bitstream :: (
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
    start_mv_sad += cast,no_check(u32) mvsad_err_cost_in_vp9_bitstream(x, mvp_full, ref_mv_full, sadpb);

    return start_mv_sad;
}

num_4x4_to_edge_in_vp9_bitstream :: (
    plane_4x4_dim: s32,
    mb_to_edge_dim: s32,
    subsampling_dim: s32,
    blk_dim: s32
) -> s32 {
    return plane_4x4_dim + mb_to_edge_dim >> (((5 + subsampling_dim)) & 31) - blk_dim;
}

sum_squares_visible_in_vp9_bitstream :: (
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
        num_4x4_to_edge_in_vp9_bitstream(
            PLANE_4X4_W,
            xd.mb_to_right_edge,
            PD.subsampling_x,
            blk_col
        );
    B4X4S_TO_BOTTOM_EDGE :=
        num_4x4_to_edge_in_vp9_bitstream(
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

do_trellis_opt_in_vp9_bitstream :: (
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
                    sum_squares_visible_in_vp9_bitstream(
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

vp9_get_refresh_mask :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if cpi.ext_ratectrl.ready != 0 &&
        (cpi.ext_ratectrl.funcs.rc_type & cast,no_check(u32) RC_GOP) != 0 &&
        cpi.ext_ratectrl.funcs.get_gop_decision != null {
        GF_GROUP_ := *cpi.twopass.gf_group;
        THIS_GF_INDEX := cast,no_check(s32) GF_GROUP_.index;
        UPDATE_REF_IDX := GF_GROUP_.update_ref_idx[THIS_GF_INDEX];

        if UPDATE_REF_IDX != -1 {
            return (cast(s32) 1) << ((UPDATE_REF_IDX) & 31);
        } else {
            return 0;
        }
    }
    if vp9_preserve_existing_gf(cpi) != 0 {
        return cpi.refresh_last_frame << ((cpi.lst_fb_idx) & 31) | (cpi.refresh_golden_frame << ((cpi.alt_fb_idx) & 31));
    } else {
        arf_idx := cpi.alt_fb_idx;
        GF_GROUP_ := *cpi.twopass.gf_group;

        if cpi.multi_layer_arf != 0 {
            arf_idx = 0;
            while arf_idx < (cast(s32) 1) << 3 {
                if arf_idx != cpi.alt_fb_idx && arf_idx != cpi.lst_fb_idx && arf_idx != cpi.gld_fb_idx {
                    idx: s32 = 0;
                    while idx < GF_GROUP_.stack_size {
                        if arf_idx == GF_GROUP_.arf_index_stack[idx] {
                            break;
                        }
                        idx += 1;
                    }
                    if idx == GF_GROUP_.stack_size {
                        break;
                    }
                }
                arf_idx += 1;
            }
        }
        cpi.twopass.gf_group.top_arf_idx = arf_idx;

        if cpi.use_svc != 0 &&
            cpi.svc.use_set_ref_frame_config != 0 &&
            cpi.svc.temporal_layering_mode == cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_BYPASS {
            return cpi.svc.update_buffer_slot[cpi.svc.spatial_layer_id];
        }
        return cpi.refresh_last_frame << ((cpi.lst_fb_idx) & 31) | (cpi.refresh_golden_frame << ((cpi.gld_fb_idx) & 31)) | (cpi.refresh_alt_ref_frame << ((arf_idx) & 31));
    }
}

vp9_preserve_existing_gf :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if cpi.refresh_golden_frame != 0 && cpi.rc.is_src_frame_alt_ref != 0 && cpi.use_svc == 0 {
        return 1;
    }
    return 0;
}

vp9_bitstream_encode_tiles_buffer_dealloc :: (CPI: *VP9_COMP_in_vp9_encoder) {
    if CPI.vp9_bitstream_worker_data != null {
        i: s32 = 1;
        while i < CPI.num_workers {
            deallocate_memory(
                cast(*void) (cast(*VP9_Bitstream_Worker_Data_in_vp9_bitstream) (CPI.vp9_bitstream_worker_data))[i].dest
            );
            i += 1;
        }
        deallocate_memory(cast(*void) CPI.vp9_bitstream_worker_data);
        CPI.vp9_bitstream_worker_data = null;
    }
}

vp9_pack_bitstream :: (cpi: *VP9_COMP_in_vp9_encoder, dest: *u8, dest_size: u64, size: *u64) {
    CM := *cpi.common;
    data := dest;
    data_size := dest_size;
    uncompressed_hdr_size: u64 = ---;
    wb: Write_Bit_Buffer = ---;
    saved_wb: Write_Bit_Buffer = ---;

    wb_init(*wb, data, data_size);
    write_uncompressed_header(cpi, *wb);
    if wb_has_error(*wb) != 0 {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_ERROR,
            c_string("vp9_pack_bitstream: output buffer full")
        );
    }

    if CM.show_existing_frame != 0 {
        uncompressed_hdr_size = wb_bytes_written(*wb);
        data += uncompressed_hdr_size;
        size.* = cast,no_check(u64) (data - dest);
        return;
    }

    assignment_0: Write_Bit_Buffer = wb;
    ((*saved_wb).*) = assignment_0;

    wb_write_literal(*wb, 0, 16);
    if wb_has_error(*wb) != 0 {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_ERROR,
            c_string("vp9_pack_bitstream: output buffer full")
        );
    }

    uncompressed_hdr_size = wb_bytes_written(*wb);
    data += uncompressed_hdr_size;
    data_size -= uncompressed_hdr_size;

    compressed_hdr_size := write_compressed_header(cpi, data, data_size);
    data += compressed_hdr_size;
    data_size -= compressed_hdr_size;
    if compressed_hdr_size > 65535 {
        internal_error(*CM.error, cast,no_check(Codec_Err_T) CODEC_ERROR, c_string("compressed_hdr_size > 16 bits"));
    }
    wb_write_literal(*saved_wb, cast,no_check(s32) compressed_hdr_size, 16);

    data += encode_tiles(cpi, data, data_size);

    size.* = cast,no_check(u64) (data - dest);
}

encode_tiles :: (cpi: *VP9_COMP_in_vp9_encoder, data_ptr: *u8, data_size: u64) -> u64 {
    CM := *cpi.common;
    XD := *cpi.td.mb.e_mbd;
    residual_bc: Writer = ---;
    tile_col: s32 = ---;
    total_size: u64 = 0;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    TILE_ROWS := (cast(s32) 1) << ((CM.log2_tile_rows) & 31);

    fill_memory(CM.above_seg_context, 0, cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_bitstream(CM.mi_cols));

    if cpi.oxcf.mode == cast,no_check(u32) REALTIME && cpi.num_workers > 1 && TILE_ROWS == 1 && TILE_COLS > 1 {
        return encode_tiles_mt(cpi, data_ptr, data_size);
    }

    if 0 < TILE_ROWS {
        for tile_row: 0..TILE_ROWS - 1 {
            tile_col = 0;
            while tile_col < TILE_COLS {
                tile_idx := tile_row * TILE_COLS + tile_col;

                offset: u64 = ifx tile_col < TILE_COLS - 1 || tile_row < TILE_ROWS - 1
                    then total_size + 4
                    else total_size;
                if data_size < offset {
                    internal_error(
                        *CM.error,
                        cast,no_check(Codec_Err_T) CODEC_ERROR,
                        c_string("encode_tiles: output buffer full")
                    );
                }
                start_encode(*residual_bc, data_ptr + offset, data_size - offset);

                write_modes(
                    cpi,
                    XD,
                    *cpi.tile_data[tile_idx].tile_info,
                    *residual_bc,
                    tile_row,
                    tile_col,
                    *cpi.max_mv_magnitude,
                    cpi.interp_filter_selected.data
                );

                if stop_encode(*residual_bc) != 0 {
                    internal_error(
                        *CM.error,
                        cast,no_check(Codec_Err_T) CODEC_ERROR,
                        c_string("encode_tiles: output buffer full")
                    );
                }
                if tile_col < TILE_COLS - 1 || tile_row < TILE_ROWS - 1 {
                    mem_put_be32_as_int(cast(*void) (data_ptr + total_size), cast,no_check(s32) residual_bc.pos);
                    total_size += 4;
                }

                total_size += cast,no_check(u64) residual_bc.pos;
                tile_col += 1;
            }
        }
    }
    return total_size;
}

write_modes :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    XD: *MACROBLOCKD,
    TILE: *Tile_Info,
    w: *Writer,
    tile_row: s32,
    tile_col: s32,
    MAX_MV_MAGNITUDE: *u32,
    interp_filter_selected: *[4] s32
) {
    CM := *cpi.common;
    mi_col: s32 = ---;
    tok: *TOKENEXTRA_in_vp9_cx_iface = null;
    tok_end: *TOKENEXTRA_in_vp9_cx_iface = null;

    set_partition_probs_in_vp9_bitstream(CM, XD);

    mi_row := TILE.mi_row_start;
    while mi_row < TILE.mi_row_end {
        tile_sb_row := mi_cols_aligned_to_sb_in_vp9_bitstream(mi_row - TILE.mi_row_start) >> (((6 - 3)) & 31);
        tok = cpi.tplist[tile_row][tile_col][tile_sb_row].start;
        tok_end = tok + cpi.tplist[tile_row][tile_col][tile_sb_row].count;

        fill_memory(*XD.left_seg_context, 0, XD.left_seg_context.count);
        mi_col = TILE.mi_col_start;
        while mi_col < TILE.mi_col_end {
            write_modes_sb(
                cpi,
                XD,
                TILE,
                w,
                *tok,
                tok_end,
                mi_row,
                mi_col,
                12,
                MAX_MV_MAGNITUDE,
                interp_filter_selected
            );
            mi_col += (cast(s32) 1) << (((6 - 3)) & 31);
        }
        mi_row += (cast(s32) 1) << (((6 - 3)) & 31);
    }
}

write_modes_sb :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    XD: *MACROBLOCKD,
    TILE: *Tile_Info,
    w: *Writer,
    tok: **TOKENEXTRA_in_vp9_cx_iface,
    TOK_END: *TOKENEXTRA_in_vp9_cx_iface,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE,
    MAX_MV_MAGNITUDE: *u32,
    interp_filter_selected: *[4] s32
) {
    CM := *cpi.common;
    BSL := cast,no_check(s32) B_WIDTH_LOG2_LOOKUP[bsize];
    BS := (cast(s32) 1) << ((BSL) & 31) / 4;

    m: *MODE_INFO = null;

    if mi_row >= CM.mi_rows || mi_col >= CM.mi_cols {
        return;
    }

    m = CM.mi_grid_visible[mi_row * CM.mi_stride + mi_col];

    partition := (((cast(*[13] PARTITION_TYPE) *(PARTITION_LOOKUP))[BSL]).data)[m.sb_type];
    write_partition(CM, XD, BS, mi_row, mi_col, partition, bsize, w);
    subsize := get_subsize_in_vp9_bitstream(bsize, partition);
    if subsize < 3 {
        write_modes_b(cpi, XD, TILE, w, tok, TOK_END, mi_row, mi_col, MAX_MV_MAGNITUDE, interp_filter_selected);
    } else {
        if partition == {
            case cast,no_check(u32) PARTITION_NONE;
                write_modes_b(cpi, XD, TILE, w, tok, TOK_END, mi_row, mi_col, MAX_MV_MAGNITUDE, interp_filter_selected);
            case cast,no_check(u32) PARTITION_HORZ;
                write_modes_b(cpi, XD, TILE, w, tok, TOK_END, mi_row, mi_col, MAX_MV_MAGNITUDE, interp_filter_selected);
                if mi_row + BS < CM.mi_rows {
                    write_modes_b(
                        cpi,
                        XD,
                        TILE,
                        w,
                        tok,
                        TOK_END,
                        mi_row + BS,
                        mi_col,
                        MAX_MV_MAGNITUDE,
                        interp_filter_selected
                    );
                }
            case cast,no_check(u32) PARTITION_VERT;
                write_modes_b(cpi, XD, TILE, w, tok, TOK_END, mi_row, mi_col, MAX_MV_MAGNITUDE, interp_filter_selected);
                if mi_col + BS < CM.mi_cols {
                    write_modes_b(
                        cpi,
                        XD,
                        TILE,
                        w,
                        tok,
                        TOK_END,
                        mi_row,
                        mi_col + BS,
                        MAX_MV_MAGNITUDE,
                        interp_filter_selected
                    );
                }
            case;
                write_modes_sb(
                    cpi,
                    XD,
                    TILE,
                    w,
                    tok,
                    TOK_END,
                    mi_row,
                    mi_col,
                    subsize,
                    MAX_MV_MAGNITUDE,
                    interp_filter_selected
                );
                write_modes_sb(
                    cpi,
                    XD,
                    TILE,
                    w,
                    tok,
                    TOK_END,
                    mi_row,
                    mi_col + BS,
                    subsize,
                    MAX_MV_MAGNITUDE,
                    interp_filter_selected
                );
                write_modes_sb(
                    cpi,
                    XD,
                    TILE,
                    w,
                    tok,
                    TOK_END,
                    mi_row + BS,
                    mi_col,
                    subsize,
                    MAX_MV_MAGNITUDE,
                    interp_filter_selected
                );
                write_modes_sb(
                    cpi,
                    XD,
                    TILE,
                    w,
                    tok,
                    TOK_END,
                    mi_row + BS,
                    mi_col + BS,
                    subsize,
                    MAX_MV_MAGNITUDE,
                    interp_filter_selected
                );
        }
    }

    if bsize >= 3 && (bsize == 3 || partition != cast,no_check(u32) PARTITION_SPLIT) {
        update_partition_context_in_vp9_bitstream(XD, mi_row, mi_col, subsize, bsize);
    }
}

write_modes_b :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    XD: *MACROBLOCKD,
    TILE: *Tile_Info,
    w: *Writer,
    tok: **TOKENEXTRA_in_vp9_cx_iface,
    TOK_END: *TOKENEXTRA_in_vp9_cx_iface,
    mi_row: s32,
    mi_col: s32,
    MAX_MV_MAGNITUDE: *u32,
    interp_filter_selected: *[4] s32
) {
    CM := *cpi.common;
    MBMI_EXT := cpi.td.mb.mbmi_ext_base + (mi_row * CM.mi_cols + mi_col);

    XD.mi = CM.mi_grid_visible + (mi_row * CM.mi_stride + mi_col);
    m := XD.mi[0];

    set_mi_row_col_in_vp9_bitstream(
        XD,
        TILE,
        mi_row,
        cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[m.sb_type],
        mi_col,
        cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[m.sb_type],
        CM.mi_rows,
        CM.mi_cols
    );
    if frame_is_intra_only_in_vp9_bitstream(CM) != 0 {
        write_mb_modes_kf(CM, XD, w);
    } else {
        pack_inter_mode_mvs_in_vp9_bitstream(cpi, XD, MBMI_EXT, w, MAX_MV_MAGNITUDE, interp_filter_selected);
    }

    pack_mb_tokens(w, tok, TOK_END, CM.bit_depth);
}

pack_mb_tokens :: (
    w: *Writer,
    tp: **TOKENEXTRA_in_vp9_cx_iface,
    STOP: *TOKENEXTRA_in_vp9_cx_iface,
    bit_depth: Bit_Depth_T
) {
    EXTRA_BITS := VP9_EXTRA_BITS.data;

    p := tp.*;
    while p < STOP && p.token != 127 {
        if p.token == 11 {
            write_in_vp9_bitstream(w, 0, cast,no_check(s32) p.context_tree[0]);
            p += 1;
            continue;
        }
        write_in_vp9_bitstream(w, 1, cast,no_check(s32) p.context_tree[0]);
        while p.token == 0 {
            write_in_vp9_bitstream(w, 0, cast,no_check(s32) p.context_tree[1]);
            p += 1;
            if p == STOP || p.token == 127 {
                tp.* = (cast,no_check(*TOKENEXTRA_in_vp9_cx_iface) cast,no_check(u64) p) + cast(s32) ((p.token == 127));
                return;
            }
        }

        {
            T := cast,no_check(s32) p.token;
            CONTEXT_TREE := p.context_tree;

            write_in_vp9_bitstream(w, 1, cast,no_check(s32) CONTEXT_TREE[1]);
            if T == 1 {
                write_in_vp9_bitstream(w, 0, cast,no_check(s32) CONTEXT_TREE[2]);
                write_bit_in_vp9_bitstream(w, (cast(s32) p.extra) & 1);
            } else {
                A := *(cast(*Vp9_Token) *(VP9_COEF_ENCODINGS))[T];
                v := A.value;
                n := A.len;
                E := cast,no_check(s32) p.extra;
                write_in_vp9_bitstream(w, 1, cast,no_check(s32) CONTEXT_TREE[2]);
                vp9_write_tree_in_vp9_bitstream(
                    w,
                    VP9_COEF_CON_TREE.data,
                    VP9_PARETO8_FULL[(cast(s32) CONTEXT_TREE[2]) - 1].data,
                    v,
                    n - 3,
                    0
                );
                if T >= 5 {
                    B := *EXTRA_BITS[T];
                    pb: *u8 = B.prob;
                    v = E >> 1;
                    n = B.len;
                    while true {
                        {
                            BB := v >> ((c_transpiler_pre_decrement(*(n))) & 31) & 1;
                            write_in_vp9_bitstream(w, BB, cast,no_check(s32) ((c_transpiler_post_increment(*(pb))).*));
                        }
                        if n == 0 break;
                    }
                }
                write_bit_in_vp9_bitstream(w, E & 1);
            }
        }
        p += 1;
    }
    tp.* = (cast,no_check(*TOKENEXTRA_in_vp9_cx_iface) cast,no_check(u64) p) + cast(s32) ((p.token == 127));
}

pack_inter_mode_mvs_in_vp9_bitstream :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    XD: *MACROBLOCKD,
    MBMI_EXT: *MB_MODE_INFO_EXT,
    w: *Writer,
    MAX_MV_MAGNITUDE: *u32,
    interp_filter_selected: *[4] s32
) {
    CM := *cpi.common;
    nmvc := *CM.fc.nmvc;
    SEG := *CM.seg;
    MI := XD.mi[0];
    MODE_ := MI.mode;
    SEGMENT_ID := cast,no_check(s32) MI.segment_id;
    BSIZE := MI.sb_type;
    ALLOW_HP := CM.allow_high_precision_mv;
    IS_INTER := is_inter_block_in_vp9_bitstream(MI);
    IS_COMPOUND := has_second_ref_in_vp9_bitstream(MI);
    ref: s32 = ---;

    if SEG.update_map != 0 {
        if SEG.temporal_update != 0 {
            PRED_FLAG := cast,no_check(s32) MI.seg_id_predicted;
            pred_prob := vp9_get_pred_prob_seg_id_in_vp9_bitstream(SEG, XD);
            write_in_vp9_bitstream(w, PRED_FLAG, cast,no_check(s32) pred_prob);
            if PRED_FLAG == 0 {
                write_segment_id(w, SEG, SEGMENT_ID);
            }
        } else {
            write_segment_id(w, SEG, SEGMENT_ID);
        }
    }

    skip := write_skip(CM, XD, SEGMENT_ID, MI, w);

    if segfeature_active_in_vp9_bitstream(SEG, SEGMENT_ID, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME) == 0 {
        write_in_vp9_bitstream(w, IS_INTER, cast,no_check(s32) vp9_get_intra_inter_prob_in_vp9_bitstream(CM, XD));
    }

    if BSIZE >= 3 && CM.tx_mode == cast,no_check(u32) TX_MODE_SELECT && !(IS_INTER != 0 && skip != 0) {
        write_selected_tx_size(CM, XD, w);
    }

    if IS_INTER == 0 {
        if BSIZE >= 3 {
            write_intra_mode(w, MODE_, CM.fc.y_mode_prob[SIZE_GROUP_LOOKUP[BSIZE]].data);
        } else {
            idx: s32 = ---;
            NUM_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[BSIZE];
            NUM_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[BSIZE];
            idy: s32 = 0;
            while idy < 2 {
                idx = 0;
                while idx < 2 {
                    B_MODE := MI.bmi[idy * 2 + idx].as_mode;
                    write_intra_mode(w, B_MODE, CM.fc.y_mode_prob[0].data);
                    idx += NUM_4X4_W;
                }
                idy += NUM_4X4_H;
            }
        }
        write_intra_mode(w, MI.uv_mode, CM.fc.uv_mode_prob[MODE_].data);
    } else {
        MODE_CTX := cast,no_check(s32) MBMI_EXT.mode_context[MI.ref_frame[0]];
        INTER_PROBS := CM.fc.inter_mode_probs[MODE_CTX].data;
        write_ref_frames(CM, XD, w);

        if segfeature_active_in_vp9_bitstream(SEG, SEGMENT_ID, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_SKIP) == 0 {
            if BSIZE >= 3 {
                write_inter_mode(w, MODE_, INTER_PROBS);
            }
        }

        if CM.interp_filter == 4 {
            CTX := get_pred_context_switchable_interp_in_vp9_bitstream(XD);
            vp9_write_token_in_vp9_bitstream(
                w,
                VP9_SWITCHABLE_INTERP_TREE.data,
                CM.fc.switchable_interp_prob[CTX].data,
                SWITCHABLE_INTERP_ENCODINGS.data + MI.interp_filter
            );
            interp_filter_selected[0][MI.interp_filter] += 1;
        } else {
        }

        if BSIZE < 3 {
            NUM_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[BSIZE];
            NUM_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[BSIZE];
            idx: s32 = ---;
            idy: s32 = 0;
            while idy < 2 {
                idx = 0;
                while idx < 2 {
                    J := idy * 2 + idx;
                    B_MODE := MI.bmi[J].as_mode;
                    write_inter_mode(w, B_MODE, INTER_PROBS);
                    if B_MODE == 13 {
                        ref = 0;
                        while ref < 1 + IS_COMPOUND {
                            (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *Writer, _: *MV, _: *MV, _: *Nmv_Context, _: s32, _: *u32)) (cast(*void) vp9_encode_mv))(
                                cpi,
                                w,
                                *MI.bmi[J].as_mv[ref].as_mv,
                                *MBMI_EXT.ref_mvs[MI.ref_frame[ref]][0].as_mv,
                                nmvc,
                                ALLOW_HP,
                                MAX_MV_MAGNITUDE
                            );
                            ref += 1;
                        }
                    }
                    idx += NUM_4X4_W;
                }
                idy += NUM_4X4_H;
            }
        } else if MODE_ == 13 {
            ref = 0;
            while ref < 1 + IS_COMPOUND {
                (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *Writer, _: *MV, _: *MV, _: *Nmv_Context, _: s32, _: *u32)) (cast(*void) vp9_encode_mv))(
                    cpi,
                    w,
                    *MI.mv[ref].as_mv,
                    *MBMI_EXT.ref_mvs[MI.ref_frame[ref]][0].as_mv,
                    nmvc,
                    ALLOW_HP,
                    MAX_MV_MAGNITUDE
                );
                ref += 1;
            }
        }
    }
}

write_inter_mode :: (w: *Writer, mode: PREDICTION_MODE, probs: *Prob) {
    vp9_write_token_in_vp9_bitstream(
        w,
        VP9_INTER_MODE_TREE.data,
        probs,
        INTER_MODE_ENCODINGS.data + (cast(s32) mode) - 10
    );
}

write_ref_frames :: (cm: *VP9_COMMON, XD: *MACROBLOCKD, w: *Writer) {
    MI := XD.mi[0];
    IS_COMPOUND := has_second_ref_in_vp9_bitstream(MI);
    SEGMENT_ID := cast,no_check(s32) MI.segment_id;

    if segfeature_active_in_vp9_bitstream(*cm.seg, SEGMENT_ID, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME) != 0 {
    } else {
        if cm.reference_mode == cast,no_check(u32) REFERENCE_MODE_SELECT {
            write_in_vp9_bitstream(
                w,
                IS_COMPOUND,
                cast,no_check(s32) vp9_get_reference_mode_prob_in_vp9_bitstream(cm, XD)
            );
        } else {
        }

        if IS_COMPOUND != 0 {
            IDX := cm.ref_frame_sign_bias[cm.comp_fixed_ref];
            write_in_vp9_bitstream(
                w,
                cast(s32) (MI.ref_frame[cast(s32) (IDX == 0)] == cm.comp_var_ref[1]),
                cast,no_check(s32) vp9_get_pred_prob_comp_ref_p_in_vp9_bitstream(cm, XD)
            );
        } else {
            BIT0 := cast(s32) (MI.ref_frame[0] != 1);
            write_in_vp9_bitstream(w, BIT0, cast,no_check(s32) vp9_get_pred_prob_single_ref_p1_in_vp9_bitstream(cm, XD));
            if BIT0 != 0 {
                BIT1 := cast(s32) (MI.ref_frame[0] != 2);
                write_in_vp9_bitstream(
                    w,
                    BIT1,
                    cast,no_check(s32) vp9_get_pred_prob_single_ref_p2_in_vp9_bitstream(cm, XD)
                );
            }
        }
    }
}

write_intra_mode :: (w: *Writer, mode: PREDICTION_MODE, probs: *Prob) {
    vp9_write_token_in_vp9_bitstream(w, VP9_INTRA_MODE_TREE.data, probs, INTRA_MODE_ENCODINGS.data + mode);
}

write_selected_tx_size :: (cm: *VP9_COMMON, XD: *MACROBLOCKD, w: *Writer) {
    tx_size := XD.mi[0].tx_size;
    bsize := XD.mi[0].sb_type;
    MAX_TX_SIZE := MAX_TXSIZE_LOOKUP[bsize];
    TX_PROBS :=
        get_tx_probs_in_vp9_bitstream(
            MAX_TX_SIZE,
            get_tx_size_context_in_vp9_bitstream(XD),
            *cm.fc.tx_probs
        );
    write_in_vp9_bitstream(w, cast(s32) (tx_size != cast(TX_SIZE) 0), cast,no_check(s32) TX_PROBS[0]);
    if tx_size != cast(TX_SIZE) 0 && MAX_TX_SIZE >= cast(TX_SIZE) 2 {
        write_in_vp9_bitstream(w, cast(s32) (tx_size != cast(TX_SIZE) 1), cast,no_check(s32) TX_PROBS[1]);
        if tx_size != cast(TX_SIZE) 1 && MAX_TX_SIZE >= cast(TX_SIZE) 3 {
            write_in_vp9_bitstream(w, cast(s32) (tx_size != cast(TX_SIZE) 2), cast,no_check(s32) TX_PROBS[2]);
        }
    }
}

write_skip :: (cm: *VP9_COMMON, XD: *MACROBLOCKD, segment_id: s32, mi: *MODE_INFO, w: *Writer) -> s32 {
    if segfeature_active_in_vp9_bitstream(*cm.seg, segment_id, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_SKIP) != 0 {
        return 1;
    } else {
        SKIP := cast,no_check(s32) mi.skip;
        write_in_vp9_bitstream(w, SKIP, cast,no_check(s32) vp9_get_skip_prob_in_vp9_bitstream(cm, XD));
        return SKIP;
    }
}

write_segment_id :: (w: *Writer, seg: *Segmentation, segment_id: s32) {
    if seg.enabled != 0 && seg.update_map != 0 {
        vp9_write_tree_in_vp9_bitstream(w, VP9_SEGMENT_TREE.data, seg.tree_probs.data, segment_id, 3, 0);
    }
}

write_mb_modes_kf :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, w: *Writer) {
    SEG := *cm.seg;
    MI := xd.mi[0];
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    BSIZE := MI.sb_type;

    if SEG.update_map != 0 {
        write_segment_id(w, SEG, cast,no_check(s32) MI.segment_id);
    }

    write_skip(cm, xd, cast,no_check(s32) MI.segment_id, MI, w);

    if BSIZE >= 3 && cm.tx_mode == cast,no_check(u32) TX_MODE_SELECT {
        write_selected_tx_size(cm, xd, w);
    }

    if BSIZE >= 3 {
        write_intra_mode(w, MI.mode, get_y_mode_probs_in_vp9_bitstream(MI, ABOVE_MI, LEFT_MI, 0));
    } else {
        NUM_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[BSIZE];
        NUM_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[BSIZE];
        idx: s32 = ---;

        idy: s32 = 0;
        while idy < 2 {
            idx = 0;
            while idx < 2 {
                BLOCK_ := idy * 2 + idx;
                write_intra_mode(
                    w,
                    MI.bmi[BLOCK_].as_mode,
                    get_y_mode_probs_in_vp9_bitstream(MI, ABOVE_MI, LEFT_MI, BLOCK_)
                );
                idx += NUM_4X4_W;
            }
            idy += NUM_4X4_H;
        }
    }

    write_intra_mode(w, MI.uv_mode, VP9_KF_UV_MODE_PROB[MI.mode].data);
}

write_partition :: (
    CM: *VP9_COMMON,
    XD: *MACROBLOCKD,
    hbs: s32,
    mi_row: s32,
    mi_col: s32,
    p: PARTITION_TYPE,
    bsize: BLOCK_SIZE,
    w: *Writer
) {
    CTX := partition_plane_context_in_vp9_bitstream(XD, mi_row, mi_col, bsize);
    PROBS := XD.partition_probs[CTX].data;
    HAS_ROWS := cast(s32) (mi_row + hbs < CM.mi_rows);
    HAS_COLS := cast(s32) (mi_col + hbs < CM.mi_cols);

    if HAS_ROWS != 0 && HAS_COLS != 0 {
        vp9_write_token_in_vp9_bitstream(w, VP9_PARTITION_TREE.data, PROBS, PARTITION_ENCODINGS.data + p);
    } else if HAS_ROWS == 0 && HAS_COLS != 0 {
        write_in_vp9_bitstream(w, cast(s32) (p == cast,no_check(u32) PARTITION_SPLIT), cast,no_check(s32) PROBS[1]);
    } else if HAS_ROWS != 0 && HAS_COLS == 0 {
        write_in_vp9_bitstream(w, cast(s32) (p == cast,no_check(u32) PARTITION_SPLIT), cast,no_check(s32) PROBS[2]);
    } else {
    }
}

encode_tiles_mt :: (cpi: *VP9_COMP_in_vp9_encoder, data_ptr: *u8, data_size: u64) -> u64 {
    WINTERFACE := get_worker_interface();
    CM := *cpi.common;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    NUM_WORKERS := cpi.num_workers;
    total_size: u64 = 0;
    tile_col: s32 = 0;
    error: s32 = 0;

    BUFFER_ALLOC_SIZE := encode_tiles_buffer_alloc_size(cpi);
    if cpi.vp9_bitstream_worker_data == null ||
        (cast(*VP9_Bitstream_Worker_Data_in_vp9_bitstream) (cpi.vp9_bitstream_worker_data))[1].dest_size != BUFFER_ALLOC_SIZE {
        vp9_bitstream_encode_tiles_buffer_dealloc(cpi);
        encode_tiles_buffer_alloc(cpi, BUFFER_ALLOC_SIZE);
    }

    while tile_col < TILE_COLS {
        i: s32 = 0;
        while i < NUM_WORKERS && tile_col < TILE_COLS {
            WORKER := *(cast(*Worker) (cpi.workers))[i];
            DATA: *VP9_Bitstream_Worker_Data_in_vp9_bitstream =
                *(cast(*VP9_Bitstream_Worker_Data_in_vp9_bitstream) (cpi.vp9_bitstream_worker_data))[i];

            assignment_1: MACROBLOCKD = cpi.td.mb.e_mbd;
            ((*DATA.xd).*) = assignment_1;
            DATA.tile_idx = tile_col;
            DATA.max_mv_magnitude = cpi.max_mv_magnitude;
            fill_memory(DATA.interp_filter_selected.data, 0, size_of(s32) * cast(u64) 4);

            if i == 0 {
                OFFSET := total_size + (ifx tile_col == TILE_COLS - 1 then cast(u64) 0 else 4);
                if data_size < OFFSET {
                    internal_error(
                        *CM.error,
                        cast,no_check(Codec_Err_T) CODEC_ERROR,
                        c_string("encode_tiles_mt: output buffer full")
                    );
                }
                DATA.dest = data_ptr + OFFSET;
                DATA.dest_size = data_size - OFFSET;
            }
            WORKER.data1 = cast(*void) cpi;
            WORKER.data2 = cast(*void) DATA;
            WORKER.hook = encode_tile_worker;
            WORKER.had_error = 0;

            if i < NUM_WORKERS - 1 {
                WINTERFACE.launch(WORKER);
            } else {
                WINTERFACE.execute(WORKER);
            }
            tile_col += 1;
            i += 1;
        }
        if 0 < i {
            for j: 0..i - 1 {
                WORKER := *(cast(*Worker) (cpi.workers))[j];
                DATA := cast(*VP9_Bitstream_Worker_Data_in_vp9_bitstream) WORKER.data2;

                if WINTERFACE.sync(WORKER) == 0 {
                    error = 1;
                    continue;
                }

                tile_size := DATA.bit_writer.pos;

                cpi.max_mv_magnitude =
                    ifx cpi.max_mv_magnitude > DATA.max_mv_magnitude then cpi.max_mv_magnitude else DATA.max_mv_magnitude;
                for k: 0..cast(s32) 4 - 1 {
                    cpi.interp_filter_selected[0][k] += DATA.interp_filter_selected[0][k];
                }

                if tile_col != TILE_COLS || j < i - 1 {
                    if data_size - total_size < 4 {
                        error = 1;
                        continue;
                    }
                    mem_put_be32_as_int(cast(*void) (data_ptr + total_size), cast,no_check(s32) tile_size);
                    total_size += 4;
                }
                if j > 0 {
                    if data_size - total_size < cast,no_check(u64) tile_size {
                        error = 1;
                        continue;
                    }
                    copy_memory(data_ptr + total_size, DATA.dest, cast,no_check(u64) tile_size);
                }
                total_size += cast,no_check(u64) tile_size;
            }
        }
        if error != 0 {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_ERROR,
                c_string("encode_tiles_mt: output buffer full")
            );
        }
    }
    return total_size;
}

encode_tile_worker :: (arg1: *void, arg2: *void) -> s32 {
    cpi := cast(*VP9_COMP_in_vp9_encoder) arg1;
    data := cast(*VP9_Bitstream_Worker_Data_in_vp9_bitstream) arg2;
    XD := *data.xd;
    TILE_ROW: s32 = 0;
    start_encode(*data.bit_writer, data.dest, data.dest_size);
    write_modes(
        cpi,
        XD,
        *cpi.tile_data[data.tile_idx].tile_info,
        *data.bit_writer,
        TILE_ROW,
        data.tile_idx,
        *data.max_mv_magnitude,
        data.interp_filter_selected.data
    );
    if stop_encode(*data.bit_writer) == 0 {
        return 1;
    }
    return 0;
}

encode_tiles_buffer_alloc_size :: (cpi: *VP9_COMP_in_vp9_encoder) -> u64 {
    cm := *cpi.common;
    IMAGE_BPS :=
        (8 + 2 * (cast(s32) 8) >> (((cm.subsampling_x + cm.subsampling_y)) & 31)) *
            (1 + cast(s32) (cm.bit_depth > 8));
    SIZE := (((cast,no_check(s64) cpi.oxcf.width) * cast(s64) cpi.oxcf.height) * cast(s64) IMAGE_BPS) / 8;
    return cast,no_check(u64) SIZE;
}

encode_tiles_buffer_alloc :: (CPI: *VP9_COMP_in_vp9_encoder, buffer_alloc_size: u64) {
    CM := *CPI.common;

    WORKER_DATA_SIZE: u64 = (cast,no_check(u64) CPI.num_workers) * size_of(VP9_Bitstream_Worker_Data_in_vp9_bitstream);
    CPI.vp9_bitstream_worker_data =
        cast(*VP9_Bitstream_Worker_Data_in_vp9_bitstream) memalign(
            16,
            WORKER_DATA_SIZE
        );

    if CPI.vp9_bitstream_worker_data == null {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->vp9_bitstream_worker_data")
        );
    }
    fill_memory(CPI.vp9_bitstream_worker_data, 0, WORKER_DATA_SIZE);
    i: s32 = 1;
    while i < CPI.num_workers {
        (cast(*VP9_Bitstream_Worker_Data_in_vp9_bitstream) (CPI.vp9_bitstream_worker_data))[i].dest =
            cast(*u8) allocate_memory(
                buffer_alloc_size
            );

        if (cast(*VP9_Bitstream_Worker_Data_in_vp9_bitstream) (CPI.vp9_bitstream_worker_data))[i].dest == null {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate cpi->vp9_bitstream_worker_data[i].dest")
            );
        }
        (cast(*VP9_Bitstream_Worker_Data_in_vp9_bitstream) (CPI.vp9_bitstream_worker_data))[i].dest_size =
            buffer_alloc_size;
        i += 1;
    }
}

write_compressed_header :: (cpi: *VP9_COMP_in_vp9_encoder, data: *u8, data_size: u64) -> u64 {
    CM := *cpi.common;
    XD := *cpi.td.mb.e_mbd;
    FC := CM.fc;
    counts := cpi.td.counts;
    header_bc: Writer = ---;

    start_encode(*header_bc, data, data_size);

    if XD.lossless != 0 {
        CM.tx_mode = cast,no_check(TX_MODE) ONLY_4X4;
    } else {
        encode_txfm_probs(CM, *header_bc, counts);
    }

    update_coef_probs(cpi, *header_bc);
    update_skip_probs(CM, *header_bc, counts);

    if frame_is_intra_only_in_vp9_bitstream(CM) == 0 {
        for i: 0..cast(s32) 7 - 1 {
            prob_diff_update(
                VP9_INTER_MODE_TREE.data,
                CM.fc.inter_mode_probs[i].data,
                counts.inter_mode[i].data,
                (cast,no_check(s32) ((1 + 13))) - 10,
                *header_bc
            );
        }

        if CM.interp_filter == 4 {
            update_switchable_interp_probs(CM, *header_bc, counts);
        }

        for i: 0..cast(s32) 4 - 1 {
            vp9_cond_prob_diff_update(*header_bc, FC.intra_inter_prob.data + i, counts.intra_inter[i].data);
        }

        if cpi.allow_comp_inter_inter != 0 {
            USE_COMPOUND_PRED := cast(s32) (CM.reference_mode != cast,no_check(u32) SINGLE_REFERENCE);
            USE_HYBRID_PRED := cast(s32) (CM.reference_mode == cast,no_check(u32) REFERENCE_MODE_SELECT);

            write_bit_in_vp9_bitstream(*header_bc, USE_COMPOUND_PRED);
            if USE_COMPOUND_PRED != 0 {
                write_bit_in_vp9_bitstream(*header_bc, USE_HYBRID_PRED);
                if USE_HYBRID_PRED != 0 {
                    for i: 0..cast(s32) 5 - 1 {
                        vp9_cond_prob_diff_update(*header_bc, FC.comp_inter_prob.data + i, counts.comp_inter[i].data);
                    }
                }
            }
        }

        if CM.reference_mode != cast,no_check(u32) COMPOUND_REFERENCE {
            for i: 0..cast(s32) 5 - 1 {
                vp9_cond_prob_diff_update(*header_bc, FC.single_ref_prob[i].data + 0, counts.single_ref[i][0].data);
                vp9_cond_prob_diff_update(*header_bc, FC.single_ref_prob[i].data + 1, counts.single_ref[i][1].data);
            }
        }

        if CM.reference_mode != cast,no_check(u32) SINGLE_REFERENCE {
            for i: 0..cast(s32) 5 - 1 {
                vp9_cond_prob_diff_update(*header_bc, FC.comp_ref_prob.data + i, counts.comp_ref[i].data);
            }
        }

        for i: 0..cast(s32) 4 - 1 {
            prob_diff_update(
                VP9_INTRA_MODE_TREE.data,
                CM.fc.y_mode_prob[i].data,
                counts.y_mode[i].data,
                cast,no_check(s32) (9 + 1),
                *header_bc
            );
        }

        for i: 0..cast(s32) (4 * 4) - 1 {
            prob_diff_update(
                VP9_PARTITION_TREE.data,
                FC.partition_prob[i].data,
                counts.partition[i].data,
                cast,no_check(s32) (PARTITION_TYPES),
                *header_bc
            );
        }

        (cast,no_check(#type (_: *VP9_COMMON, _: s32, _: *Writer, _: *Nmv_Context_Counts)) (cast(*void) vp9_write_nmv_probs))(
            CM,
            CM.allow_high_precision_mv,
            *header_bc,
            *counts.mv
        );
    }

    if stop_encode(*header_bc) != 0 {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_ERROR,
            c_string("write_compressed_header: output buffer full")
        );
    }

    return cast,no_check(u64) header_bc.pos;
}

prob_diff_update :: (tree: *Tree_Index, probs: *Prob, counts: *u32, n: s32, w: *Writer) {
    branch_ct: [32] [2] u32 = ---;

    vp9_tree_probs_from_distribution(tree, branch_ct.data, counts);
    i: s32 = 0;
    while i < n - 1 {
        vp9_cond_prob_diff_update(w, *probs[i], branch_ct[i].data);
        i += 1;
    }
}

update_switchable_interp_probs :: (cm: *VP9_COMMON, w: *Writer, counts: *FRAME_COUNTS) {
    for j: 0..cast(s32) (3 + 1) - 1 {
        prob_diff_update(
            VP9_SWITCHABLE_INTERP_TREE.data,
            cm.fc.switchable_interp_prob[j].data,
            counts.switchable_interp[j].data,
            3,
            w
        );
    }
}

update_skip_probs :: (cm: *VP9_COMMON, w: *Writer, counts: *FRAME_COUNTS) {
    for k: 0..cast(s32) 3 - 1 {
        vp9_cond_prob_diff_update(w, cm.fc.skip_probs.data + k, counts.skip[k].data);
    }
}

update_coef_probs :: (cpi: *VP9_COMP_in_vp9_encoder, w: *Writer) {
    TX_MODE_ := cpi.common.tx_mode;
    MAX_TX_SIZE := TX_MODE_TO_BIGGEST_TX_SIZE[TX_MODE_];

    tx_size: TX_SIZE = 0;
    while tx_size <= MAX_TX_SIZE {
        frame_branch_ct: [2] Vp9_Coeff_Stats = ---;
        frame_coef_probs: [2] Vp9_Coeff_Probs_Model = ---;
        if cpi.td.counts.tx.tx_totals[tx_size] <= 20 ||
            tx_size >= cast(TX_SIZE) 2 && cpi.sf.tx_size_search_method == cast,no_check(u32) USE_TX_8X8 {
            write_bit_in_vp9_bitstream(w, 0);
        } else {
            build_tree_distribution(cpi, tx_size, frame_branch_ct.data, frame_coef_probs.data);
            update_coef_probs_common(w, cpi, tx_size, frame_branch_ct.data, frame_coef_probs.data);
        }
        tx_size += 1;
    }
}

update_coef_probs_common :: (
    BC: *Writer,
    cpi: *VP9_COMP_in_vp9_encoder,
    tx_size: TX_SIZE,
    frame_branch_ct: *Vp9_Coeff_Stats,
    new_coef_probs: *Vp9_Coeff_Probs_Model
) {
    old_coef_probs := cpi.common.fc.coef_probs[tx_size].data;
    UPD: Prob = 252;
    ENTROPY_NODES_UPDATE: s32 = 3;
    i, j, k, l, t: s32 = ---;
    stepsize := cpi.sf.coeff_prob_appx_step;

    if cpi.sf.use_fast_coef_updates == {
        case cast,no_check(u32) TWO_LOOP;
            {
                savings: s64 = 0;
                update: [2] s32;
                i = 0;
                while i < PLANE_TYPES {
                    j = 0;
                    while j < 2 {
                        k = 0;
                        while k < 6 {
                            l = 0;
                            while l < (ifx k == 0 then cast(s32) 3 else 6) {
                                t = 0;
                                while t < ENTROPY_NODES_UPDATE {
                                    newp := new_coef_probs[i][j][k][l][t];
                                    OLDP := old_coef_probs[i][j][k][l][t];

                                    u: s32 = 0;
                                    s: s64 = ifx t == 2
                                        then vp9_prob_diff_update_savings_search_model(
                                            frame_branch_ct[i][j][k][l][0].data,
                                            OLDP,
                                            *newp,
                                            UPD,
                                            stepsize
                                        )
                                        else vp9_prob_diff_update_savings_search(
                                            frame_branch_ct[i][j][k][l][t].data,
                                            OLDP,
                                            *newp,
                                            UPD
                                        );
                                    if s > 0 && newp != OLDP {
                                        u = 1;
                                    }
                                    if u != 0 {
                                        savings += s - cast(s64) (cast,no_check(s32) VP9_PROB_COST[UPD]);
                                    } else {
                                        savings -= cast,no_check(s64) (cast,no_check(s32) VP9_PROB_COST[UPD]);
                                    }
                                    update[u] += 1;
                                    t += 1;
                                }
                                l += 1;
                            }
                            k += 1;
                        }
                        j += 1;
                    }
                    i += 1;
                }

                if update[1] == 0 || savings < 0 {
                    write_bit_in_vp9_bitstream(BC, 0);
                    return;
                }
                write_bit_in_vp9_bitstream(BC, 1);
                i = 0;
                while i < PLANE_TYPES {
                    j = 0;
                    while j < 2 {
                        k = 0;
                        while k < 6 {
                            l = 0;
                            while l < (ifx k == 0 then cast(s32) 3 else 6) {
                                t = 0;
                                while t < ENTROPY_NODES_UPDATE {
                                    newp := new_coef_probs[i][j][k][l][t];
                                    oldp := old_coef_probs[i][j][k][l].data + t;

                                    u: s32 = 0;
                                    s: s64 = ifx t == 2
                                        then vp9_prob_diff_update_savings_search_model(
                                            frame_branch_ct[i][j][k][l][0].data,
                                            oldp.*,
                                            *newp,
                                            UPD,
                                            stepsize
                                        )
                                        else vp9_prob_diff_update_savings_search(
                                            frame_branch_ct[i][j][k][l][t].data,
                                            oldp.*,
                                            *newp,
                                            UPD
                                        );
                                    if s > 0 && newp != oldp.* {
                                        u = 1;
                                    }
                                    write_in_vp9_bitstream(BC, u, cast,no_check(s32) UPD);
                                    if u != 0 {
                                        vp9_write_prob_diff_update(BC, newp, oldp.*);
                                        oldp.* = newp;
                                    }
                                    t += 1;
                                }
                                l += 1;
                            }
                            k += 1;
                        }
                        j += 1;
                    }
                    i += 1;
                }
                return;
            }
        case;
            {
                updates: s32 = 0;
                noupdates_before_first: s32 = 0;

                i = 0;
                while i < PLANE_TYPES {
                    j = 0;
                    while j < 2 {
                        k = 0;
                        while k < 6 {
                            l = 0;
                            while l < (ifx k == 0 then cast(s32) 3 else 6) {
                                t = 0;
                                while t < ENTROPY_NODES_UPDATE {
                                    newp := new_coef_probs[i][j][k][l][t];
                                    oldp := old_coef_probs[i][j][k][l].data + t;

                                    u: s32 = 0;

                                    s: s64 = ifx t == 2
                                        then vp9_prob_diff_update_savings_search_model(
                                            frame_branch_ct[i][j][k][l][0].data,
                                            oldp.*,
                                            *newp,
                                            UPD,
                                            stepsize
                                        )
                                        else vp9_prob_diff_update_savings_search(
                                            frame_branch_ct[i][j][k][l][t].data,
                                            oldp.*,
                                            *newp,
                                            UPD
                                        );

                                    if s > 0 && newp != oldp.* {
                                        u = 1;
                                    }
                                    updates += u;
                                    if u == 0 && updates == 0 {
                                        noupdates_before_first += 1;
                                        t += 1;
                                        continue;
                                    }
                                    if u == 1 && updates == 1 {
                                        write_bit_in_vp9_bitstream(BC, 1);
                                        if 0 < noupdates_before_first {
                                            for v: 0..noupdates_before_first - 1 {
                                                write_in_vp9_bitstream(BC, 0, cast,no_check(s32) UPD);
                                            }
                                        }
                                    }
                                    write_in_vp9_bitstream(BC, u, cast,no_check(s32) UPD);
                                    if u != 0 {
                                        vp9_write_prob_diff_update(BC, newp, oldp.*);
                                        oldp.* = newp;
                                    }
                                    t += 1;
                                }
                                l += 1;
                            }
                            k += 1;
                        }
                        j += 1;
                    }
                    i += 1;
                }
                if updates == 0 {
                    write_bit_in_vp9_bitstream(BC, 0);
                }
                return;
            }
    }
}

build_tree_distribution :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    tx_size: TX_SIZE,
    coef_branch_ct: *Vp9_Coeff_Stats,
    coef_probs: *Vp9_Coeff_Probs_Model
) {
    coef_counts := cpi.td.rd_counts.coef_counts[tx_size].data;
    eob_branch_ct: *[2] [6] [6] u32 = cpi.common.counts.eob_branch[tx_size].data;
    j: s32 = ---;
    k: s32 = ---;
    l: s32 = ---;
    m: s32 = ---;

    i: s32 = 0;
    while i < PLANE_TYPES {
        j = 0;
        while j < 2 {
            k = 0;
            while k < 6 {
                l = 0;
                while l < (ifx k == 0 then cast(s32) 3 else 6) {
                    vp9_tree_probs_from_distribution(
                        cast(*Tree_Index) *(VP9_COEF_TREE),
                        coef_branch_ct[i][j][k][l].data,
                        coef_counts[i][j][k][l].data
                    );
                    coef_branch_ct[i][j][k][l][0][1] = eob_branch_ct[i][j][k][l] - coef_branch_ct[i][j][k][l][0][0];
                    m = 0;
                    while m < 3 {
                        coef_probs[i][j][k][l][m] =
                            get_binary_prob_in_vp9_bitstream(
                                coef_branch_ct[i][j][k][l][m][0],
                                coef_branch_ct[i][j][k][l][m][1]
                            );
                        m += 1;
                    }
                    l += 1;
                }
                k += 1;
            }
            j += 1;
        }
        i += 1;
    }
}

encode_txfm_probs :: (cm: *VP9_COMMON, w: *Writer, counts: *FRAME_COUNTS) {
    write_literal_in_vp9_bitstream(
        w,
        cast,no_check(s32) ((ifx cm.tx_mode < cast,no_check(u32) ALLOW_32X32 then cm.tx_mode else cast,no_check(u32) ALLOW_32X32)),
        2
    );
    if cm.tx_mode >= cast,no_check(u32) ALLOW_32X32 {
        write_bit_in_vp9_bitstream(w, cast(s32) (cm.tx_mode == cast,no_check(u32) TX_MODE_SELECT));
    }

    if cm.tx_mode == cast,no_check(u32) TX_MODE_SELECT {
        j: s32 = ---;
        ct_8x8p: [1] [2] u32 = ---;
        ct_16x16p: [2] [2] u32 = ---;
        ct_32x32p: [3] [2] u32 = ---;

        for i: 0..cast(s32) 2 - 1 {
            tx_counts_to_branch_counts_8x8(counts.tx.p8x8[i].data, ct_8x8p.data);
            j = 0;
            while j < (cast,no_check(s32) (cast(TX_SIZE) 4)) - 3 {
                vp9_cond_prob_diff_update(w, cm.fc.tx_probs.p8x8[i].data + j, ct_8x8p[j].data);
                j += 1;
            }
        }

        for i: 0..cast(s32) 2 - 1 {
            tx_counts_to_branch_counts_16x16(counts.tx.p16x16[i].data, ct_16x16p.data);
            j = 0;
            while j < (cast,no_check(s32) (cast(TX_SIZE) 4)) - 2 {
                vp9_cond_prob_diff_update(w, cm.fc.tx_probs.p16x16[i].data + j, ct_16x16p[j].data);
                j += 1;
            }
        }

        for i: 0..cast(s32) 2 - 1 {
            tx_counts_to_branch_counts_32x32(counts.tx.p32x32[i].data, ct_32x32p.data);
            j = 0;
            while j < (cast,no_check(s32) (cast(TX_SIZE) 4)) - 1 {
                vp9_cond_prob_diff_update(w, cm.fc.tx_probs.p32x32[i].data + j, ct_32x32p[j].data);
                j += 1;
            }
        }
    }
}

write_uncompressed_header :: (cpi: *VP9_COMP_in_vp9_encoder, wb: *Write_Bit_Buffer) {
    CM := *cpi.common;
    XD := *cpi.td.mb.e_mbd;

    wb_write_literal(wb, 0x2, 2);

    write_profile(CM.profile, wb);

    wb_write_bit(wb, CM.show_existing_frame);
    if CM.show_existing_frame != 0 {
        wb_write_literal(wb, cpi.alt_fb_idx, 3);
        return;
    }

    wb_write_bit(wb, cast,no_check(s32) CM.frame_type);
    wb_write_bit(wb, CM.show_frame);
    wb_write_bit(wb, CM.error_resilient_mode);

    if CM.frame_type == cast,no_check(u32) KEY_FRAME {
        write_sync_code(wb);
        write_bitdepth_colorspace_sampling(CM, wb);
        write_frame_size(CM, wb);
    } else {
        if CM.show_frame == 0 {
            wb_write_bit(wb, cast,no_check(s32) CM.intra_only);
        }

        if CM.error_resilient_mode == 0 {
            wb_write_literal(wb, CM.reset_frame_context, 2);
        }

        if CM.intra_only != 0 {
            write_sync_code(wb);

            if CM.profile > cast,no_check(u32) PROFILE_0 {
                write_bitdepth_colorspace_sampling(CM, wb);
            }

            wb_write_literal(wb, vp9_get_refresh_mask(cpi), (cast(s32) 1) << 3);
            write_frame_size(CM, wb);
        } else {
            wb_write_literal(wb, vp9_get_refresh_mask(cpi), (cast(s32) 1) << 3);
            ref_frame: MV_REFERENCE_FRAME = 1;
            while ref_frame <= 3 {
                wb_write_literal(wb, get_ref_frame_map_idx_in_vp9_bitstream(cpi, ref_frame), 3);
                wb_write_bit(wb, CM.ref_frame_sign_bias[ref_frame]);
                ref_frame += 1;
            }

            write_frame_size_with_refs(cpi, wb);

            wb_write_bit(wb, CM.allow_high_precision_mv);

            fix_interp_filter(CM, cpi.td.counts);
            write_interp_filter(CM.interp_filter, wb);
        }
    }

    if CM.error_resilient_mode == 0 {
        wb_write_bit(wb, CM.refresh_frame_context);
        wb_write_bit(wb, CM.frame_parallel_decoding_mode);
    }

    wb_write_literal(wb, cast,no_check(s32) CM.frame_context_idx, 2);

    encode_loopfilter(*CM.lf, wb);
    encode_quantization(CM, wb);
    encode_segmentation(CM, XD, wb);

    write_tile_info(CM, wb);
}

write_tile_info :: (CM: *VP9_COMMON, wb: *Write_Bit_Buffer) {
    min_log2_tile_cols: s32 = ---;
    max_log2_tile_cols: s32 = ---;
    vp9_get_tile_n_bits(CM.mi_cols, *min_log2_tile_cols, *max_log2_tile_cols);

    ones := CM.log2_tile_cols - min_log2_tile_cols;
    while ((c_transpiler_post_decrement(*(ones))) != 0) {
        wb_write_bit(wb, 1);
    }

    if CM.log2_tile_cols < max_log2_tile_cols {
        wb_write_bit(wb, 0);
    }

    wb_write_bit(wb, cast(s32) (CM.log2_tile_rows != 0));
    if CM.log2_tile_rows != 0 {
        wb_write_bit(wb, cast(s32) (CM.log2_tile_rows != 1));
    }
}

encode_segmentation :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, wb: *Write_Bit_Buffer) {
    j: s32 = ---;

    seg := *cm.seg;

    wb_write_bit(wb, cast,no_check(s32) seg.enabled);
    if seg.enabled == 0 {
        return;
    }

    wb_write_bit(wb, cast,no_check(s32) seg.update_map);
    if seg.update_map != 0 {
        vp9_choose_segmap_coding_method(cm, xd);

        for i: 0..cast(s32) (8 - 1) - 1 {
            PROB := cast,no_check(s32) seg.tree_probs[i];
            UPDATE := cast(s32) (PROB != 255);
            wb_write_bit(wb, UPDATE);
            if UPDATE != 0 {
                wb_write_literal(wb, PROB, 8);
            }
        }

        wb_write_bit(wb, cast,no_check(s32) seg.temporal_update);
        if seg.temporal_update != 0 {
            for i: 0..cast(s32) 3 - 1 {
                PROB := cast,no_check(s32) seg.pred_probs[i];
                UPDATE := cast(s32) (PROB != 255);
                wb_write_bit(wb, UPDATE);
                if UPDATE != 0 {
                    wb_write_literal(wb, PROB, 8);
                }
            }
        }
    }

    wb_write_bit(wb, cast,no_check(s32) seg.update_data);
    if seg.update_data != 0 {
        wb_write_bit(wb, cast,no_check(s32) seg.abs_delta);

        for i: 0..cast(s32) 8 - 1 {
            j = 0;
            while j < SEG_LVL_MAX {
                ACTIVE := segfeature_active_in_vp9_bitstream(seg, i, cast,no_check(SEG_LVL_FEATURES) j);
                wb_write_bit(wb, ACTIVE);
                if ACTIVE != 0 {
                    DATA := get_segdata_in_vp9_bitstream(seg, i, cast,no_check(SEG_LVL_FEATURES) j);
                    DATA_MAX := vp9_seg_feature_data_max(cast,no_check(SEG_LVL_FEATURES) j);

                    if vp9_is_segfeature_signed(cast,no_check(SEG_LVL_FEATURES) j) != 0 {
                        encode_unsigned_max(wb, absolute_value(DATA), DATA_MAX);
                        wb_write_bit(wb, cast(s32) (DATA < 0));
                    } else {
                        encode_unsigned_max(wb, DATA, DATA_MAX);
                    }
                }
                j += 1;
            }
        }
    }
}

encode_unsigned_max :: (wb: *Write_Bit_Buffer, data: s32, max: s32) {
    wb_write_literal(wb, data, get_unsigned_bits_in_vp9_bitstream(cast,no_check(u32) max));
}

encode_quantization :: (CM: *VP9_COMMON, wb: *Write_Bit_Buffer) {
    wb_write_literal(wb, CM.base_qindex, 8);
    write_delta_q(wb, CM.y_dc_delta_q);
    write_delta_q(wb, CM.uv_dc_delta_q);
    write_delta_q(wb, CM.uv_ac_delta_q);
}

write_delta_q :: (wb: *Write_Bit_Buffer, delta_q: s32) {
    if delta_q != 0 {
        wb_write_bit(wb, 1);
        wb_write_literal(wb, absolute_value(delta_q), 4);
        wb_write_bit(wb, cast(s32) (delta_q < 0));
    } else {
        wb_write_bit(wb, 0);
    }
}

encode_loopfilter :: (lf: *Loopfilter, wb: *Write_Bit_Buffer) {
    wb_write_literal(wb, lf.filter_level, 6);
    wb_write_literal(wb, lf.sharpness_level, 3);

    wb_write_bit(wb, cast,no_check(s32) lf.mode_ref_delta_enabled);

    if lf.mode_ref_delta_enabled != 0 {
        wb_write_bit(wb, cast,no_check(s32) lf.mode_ref_delta_update);
        if lf.mode_ref_delta_update != 0 {
            for i: 0..cast(s32) 4 - 1 {
                DELTA := cast,no_check(s32) lf.ref_deltas[i];
                CHANGED := cast(s32) (DELTA != cast,no_check(s32) lf.last_ref_deltas[i]);
                wb_write_bit(wb, CHANGED);
                if CHANGED != 0 {
                    lf.last_ref_deltas[i] = cast,no_check(s8) DELTA;
                    wb_write_literal(wb, absolute_value(DELTA) & 0x3f, 6);
                    wb_write_bit(wb, cast(s32) (DELTA < 0));
                }
            }

            for i: 0..cast(s32) 2 - 1 {
                DELTA := cast,no_check(s32) lf.mode_deltas[i];
                CHANGED := cast(s32) (DELTA != cast,no_check(s32) lf.last_mode_deltas[i]);
                wb_write_bit(wb, CHANGED);
                if CHANGED != 0 {
                    lf.last_mode_deltas[i] = cast,no_check(s8) DELTA;
                    wb_write_literal(wb, absolute_value(DELTA) & 0x3f, 6);
                    wb_write_bit(wb, cast(s32) (DELTA < 0));
                }
            }
        }
    }
}

write_interp_filter :: (filter: INTERP_FILTER, wb: *Write_Bit_Buffer) {
    FILTER_TO_LITERAL := s32.[ 1, 0, 2, 3 ];

    wb_write_bit(wb, cast(s32) (filter == 4));
    if filter != 4 {
        wb_write_literal(wb, FILTER_TO_LITERAL[filter], 2);
    }
}

fix_interp_filter :: (cm: *VP9_COMMON, counts: *FRAME_COUNTS) {
    if cm.interp_filter == 4 {
        count: [3] s32 = ---;
        j: s32 = ---;
        c: s32 = 0;
        for i: 0..cast(s32) 3 - 1 {
            count[i] = 0;
            j = 0;
            while j < 3 + 1 {
                count[i] = cast,no_check(s32) ((cast,no_check(u32) count[i]) + counts.switchable_interp[j][i]);
                j += 1;
            }
            c += cast(s32) (count[i] > 0);
        }
        if c == 1 {
            for i: 0..cast(s32) 3 - 1 {
                if count[i] != 0 {
                    cm.interp_filter = cast,no_check(INTERP_FILTER) i;
                    break;
                }
            }
        }
    }
}

write_frame_size_with_refs :: (cpi: *VP9_COMP_in_vp9_encoder, wb: *Write_Bit_Buffer) {
    CM := *cpi.common;
    found: s32 = 0;

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame <= 3 {
        cfg := get_ref_frame_buffer_in_vp9_bitstream(cpi, ref_frame);

        if cpi.use_svc != 0 &&
            (cpi.svc.number_temporal_layers > 1 && cpi.oxcf.rc_mode == cast,no_check(u32) CBR ||
                cpi.svc.number_spatial_layers > 1 && cpi.svc.layer_context[cpi.svc.spatial_layer_id].is_key_frame != 0) {
            found = 0;
        } else if cfg != null {
            found = cast(s32) (CM.width == cfg.y_crop_width && CM.height == cfg.y_crop_height);
        }
        wb_write_bit(wb, found);
        if found != 0 {
            break;
        }
        ref_frame += 1;
    }

    if found == 0 {
        wb_write_literal(wb, CM.width - 1, 16);
        wb_write_literal(wb, CM.height - 1, 16);
    }

    write_render_size(CM, wb);
}

write_render_size :: (cm: *VP9_COMMON, wb: *Write_Bit_Buffer) {
    SCALING_ACTIVE := cast(s32) (cm.width != cm.render_width || cm.height != cm.render_height);
    wb_write_bit(wb, SCALING_ACTIVE);
    if SCALING_ACTIVE != 0 {
        wb_write_literal(wb, cm.render_width - 1, 16);
        wb_write_literal(wb, cm.render_height - 1, 16);
    }
}

write_frame_size :: (cm: *VP9_COMMON, wb: *Write_Bit_Buffer) {
    wb_write_literal(wb, cm.width - 1, 16);
    wb_write_literal(wb, cm.height - 1, 16);

    write_render_size(cm, wb);
}

write_bitdepth_colorspace_sampling :: (CM: *VP9_COMMON, wb: *Write_Bit_Buffer) {
    if CM.profile >= cast,no_check(u32) PROFILE_2 {
        wb_write_bit(wb, (ifx CM.bit_depth == cast,no_check(u32) BITS_10 then cast(s32) 0 else 1));
    }
    wb_write_literal(wb, cast,no_check(s32) CM.color_space, 3);
    if CM.color_space != cast,no_check(u32) CS_SRGB {
        wb_write_bit(wb, cast,no_check(s32) CM.color_range);
        if CM.profile == cast,no_check(u32) PROFILE_1 || CM.profile == cast,no_check(u32) PROFILE_3 {
            wb_write_bit(wb, CM.subsampling_x);
            wb_write_bit(wb, CM.subsampling_y);
            wb_write_bit(wb, 0);
        } else {
        }
    } else {
        wb_write_bit(wb, 0);
    }
}

write_sync_code :: (wb: *Write_Bit_Buffer) {
    wb_write_literal(wb, 0x49, 8);
    wb_write_literal(wb, 0x83, 8);
    wb_write_literal(wb, 0x42, 8);
}

write_profile :: (profile: BITSTREAM_PROFILE, wb: *Write_Bit_Buffer) {
    if profile == {
        case cast,no_check(u32) PROFILE_0;
            wb_write_literal(wb, 0, 2);
        case cast,no_check(u32) PROFILE_1;
            wb_write_literal(wb, 2, 2);
        case cast,no_check(u32) PROFILE_2;
            wb_write_literal(wb, 1, 2);
        case;
            wb_write_literal(wb, 6, 3);
    }
}

globals_initialization_state_for_vp9_bitstream: u32;
initialize_globals_for_vp9_bitstream :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_bitstream);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_bitstream, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_bitstream) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_vp9_bitstream =
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
    SUB_PEL_FILTERS_12_in_vp9_bitstream =
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
    MODE_2_COUNTER_storage =
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
    COUNTER_TO_CONTEXT_storage =
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
    MV_REF_BLOCKS_storage =
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
    IDX_N_COLUMN_TO_SUBBLOCK_storage =
        [2] s32.[
            s32.[ 1, 2 ],
            s32.[ 1, 3 ],
            s32.[ 3, 2 ],
            s32.[ 3, 3 ]
        ];
    FRAME_SCALE_FACTOR_storage = s32.[ 16, 24 ];
    RATE_THRESH_MULT_storage = float64.[ 1.0, 2.0 ];
    RCF_MULT_storage = float64.[ 1.0, 2.0 ];
    K_VP9_REF_FLAG_LIST_storage =
        s32.[ 0, cast,no_check(s32) (VP9_LAST_FLAG), cast,no_check(s32) (VP9_GOLD_FLAG), cast,no_check(s32) (VP9_ALT_FLAG) ];
    INTRA_MODE_ENCODINGS =
        Vp9_Token.[
            Vp9_Token.{value = 0, len = 1},
            Vp9_Token.{value = 6, len = 3},
            Vp9_Token.{value = 28, len = 5},
            Vp9_Token.{value = 30, len = 5},
            Vp9_Token.{value = 58, len = 6},
            Vp9_Token.{value = 59, len = 6},
            Vp9_Token.{value = 126, len = 7},
            Vp9_Token.{value = 127, len = 7},
            Vp9_Token.{value = 62, len = 6},
            Vp9_Token.{value = 2, len = 2}
        ];
    SWITCHABLE_INTERP_ENCODINGS =
        Vp9_Token.[
            Vp9_Token.{value = 0, len = 1},
            Vp9_Token.{value = 2, len = 2},
            Vp9_Token.{value = 3, len = 2}
        ];
    PARTITION_ENCODINGS =
        Vp9_Token.[
            Vp9_Token.{value = 0, len = 1},
            Vp9_Token.{value = 2, len = 2},
            Vp9_Token.{value = 6, len = 3},
            Vp9_Token.{value = 7, len = 3}
        ];
    INTER_MODE_ENCODINGS =
        Vp9_Token.[
            Vp9_Token.{value = 2, len = 2},
            Vp9_Token.{value = 6, len = 3},
            Vp9_Token.{value = 0, len = 1},
            Vp9_Token.{value = 7, len = 3}
        ];
    atomic_store(*globals_initialization_state_for_vp9_bitstream, 2);
}

VP9_Bitstream_Worker_Data_in_vp9_bitstream :: struct {
    dest: *u8 #align 16;
    dest_size: u64 #align 1;
    bit_writer: Writer #align 1;
    tile_idx: s32 #align 1;
    max_mv_magnitude: u32 #align 1;
    interp_filter_selected: [1] [4] s32 #align 1;
    layout_padding_0: [8] u8 #align 1;
    xd: MACROBLOCKD #align 1;
    layout_padding_1: [8] u8 #align 1;
} #no_padding;

Vp9_Coeff_Stats :: [2] [6] [6] [11] [2] u32;

Vp9_Extra_Bit :: struct {
    prob: *Prob;
    len: s32;
    base_val: s32;
    cost: *s16;
}

