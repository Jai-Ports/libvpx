Rdcost_Block_Args :: struct {
    cpi: *VP9_COMP_in_vp9_encoder;
    x: *MACROBLOCK;
    t_above: [16] ENTROPY_CONTEXT;
    t_left: [16] ENTROPY_CONTEXT;
    this_rate: s32;
    this_dist: s64;
    this_sse: s64;
    this_rd: s64;
    best_rd: s64;
    exit_early: s32;
    use_fast_coef_costing: s32;
    so: *Scan_Order_in_vp9_scan;
    skippable: u8;
    this_recon: *Buf_2d;
}

MODE_DEFINITION :: struct {
    mode: PREDICTION_MODE;
    ref_frame: [2] MV_REFERENCE_FRAME;
}

BEST_SEG_INFO_in_vp9_rdopt :: struct {
    ref_mv: [2] *Int_Mv #align 8;
    mvp: Int_Mv #align 1;
    layout_padding_0: [4] u8 #align 1;
    segment_rd: s64 #align 1;
    r: s32 #align 1;
    layout_padding_1: [4] u8 #align 1;
    d: s64 #align 1;
    sse: s64 #align 1;
    segment_yrate: s32 #align 1;
    modes: [4] PREDICTION_MODE #align 1;
    rdstat: [4] [4] SEG_RDSTAT #align 1;
    mvthresh: s32 #align 1;
    layout_padding_2: [4] u8 #align 1;
} #no_padding;

SEG_RDSTAT :: struct {
    eobs: s32 #align 8;
    brate: s32 #align 1;
    byrate: s32 #align 1;
    layout_padding_0: [4] u8 #align 1;
    bdist: s64 #align 1;
    bsse: s64 #align 1;
    brdcost: s64 #align 1;
    mvs: [2] Int_Mv #align 1;
    ta: [2] ENTROPY_CONTEXT #align 1;
    tl: [2] ENTROPY_CONTEXT #align 1;
    layout_padding_1: [4] u8 #align 1;
} #no_padding;

REF_DEFINITION :: struct {
    ref_frame: [2] MV_REFERENCE_FRAME;
}

SUB_PEL_FILTERS_12_in_vp9_rdopt: [16] Interp_Kernel12 #align 256;

COUNT_TO_UPDATE_FACTOR_in_vp9_rdopt: [21] s32;

COSPI_1_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_2_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_3_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_4_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_5_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_6_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_7_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_8_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_9_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_10_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_11_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_12_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_13_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_14_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_15_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_16_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_17_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_18_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_19_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_20_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_21_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_22_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_23_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_24_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_25_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_26_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_27_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_28_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_29_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_30_64_in_vp9_rdopt: Tran_Coef_T;

COSPI_31_64_in_vp9_rdopt: Tran_Coef_T;

SINPI_1_9_in_vp9_rdopt: Tran_Coef_T;

SINPI_2_9_in_vp9_rdopt: Tran_Coef_T;

SINPI_3_9_in_vp9_rdopt: Tran_Coef_T;

SINPI_4_9_in_vp9_rdopt: Tran_Coef_T;

MODE_2_COUNTER_in_vp9_rdopt: [14] s32;

COUNTER_TO_CONTEXT_in_vp9_rdopt: [19] s32;

MV_REF_BLOCKS_in_vp9_rdopt: [13] [8] POSITION;

IDX_N_COLUMN_TO_SUBBLOCK_in_vp9_rdopt: [4] [2] s32;

FRAME_SCALE_FACTOR_in_vp9_rdopt: [2] s32;

RATE_THRESH_MULT_in_vp9_rdopt: [2] float64;

RCF_MULT_in_vp9_rdopt: [2] float64;

K_VP9_REF_FLAG_LIST_in_vp9_rdopt: [4] s32;

BAND_COUNTS: [4] [8] s16;

max_var_adjust: [3] u32;

VP9_MODE_ORDER: [30] MODE_DEFINITION;

VP9_REF_ORDER: [6] REF_DEFINITION;

clip_pixel_in_vp9_rdopt :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_rdopt :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_rdopt :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_rdopt :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_rdopt :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_rdopt(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_rdopt(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_rdopt(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_rdopt :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_lsb_in_vp9_rdopt :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_rdopt :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_rdopt :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_rdopt(num_values) + 1 else 0;
}

get_filter_taps_in_vp9_rdopt :: (FILTER: *s16) -> s32 {
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

vp9_block_error_c :: (coeff: *Tran_Low_T, dqcoeff: *Tran_Low_T, block_size: s64, ssz: *s64) -> s64 {
    error: s64 = 0;
    sqcoeff: s64 = 0;

    i: s32 = 0;
    while cast,no_check(s64) i < block_size {
        DIFF := (cast(s32) coeff[i]) - cast(s32) dqcoeff[i];
        error += cast,no_check(s64) (DIFF * DIFF);
        sqcoeff += cast,no_check(s64) ((cast(s32) coeff[i]) * cast(s32) coeff[i]);
        i += 1;
    }

    ssz.* = sqcoeff;
    return error;
}

vp9_block_error_fp_c :: (coeff: *Tran_Low_T, dqcoeff: *Tran_Low_T, block_size: s32) -> s64 {
    error: s64 = 0;

    if 0 < block_size {
        for i: 0..block_size - 1 {
            DIFF := (cast(s32) coeff[i]) - cast(s32) dqcoeff[i];
            error += cast,no_check(s64) (DIFF * DIFF);
        }
    }

    return error;
}

get_prob_in_vp9_rdopt :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_rdopt :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_rdopt(n0, DEN);
}

weighted_prob_in_vp9_rdopt :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_rdopt :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_rdopt(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_rdopt(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_rdopt :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_rdopt[COUNT];
        PROB := get_prob_in_vp9_rdopt(ct[0], DEN);
        return weighted_prob_in_vp9_rdopt(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_band_translate_in_vp9_rdopt :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_rdopt :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_rdopt :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_rdopt(above_ec, left_ec);
}

is_zero_mv_in_vp9_rdopt :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_rdopt :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_rdopt :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_rdopt(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_rdopt(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_rdopt :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_rdopt :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_rdopt :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_rdopt :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

check_range_in_vp9_rdopt :: (input: Tran_High_T) -> Tran_High_T {
    return input;
}

dct_const_round_shift_in_vp9_rdopt :: (input: Tran_High_T) -> Tran_High_T {
    rv := (input + cast,no_check(Tran_High_T) (((cast(s32) 1) << (((14 - 1)) & 31)))) >> 14;
    return rv;
}

clip_pixel_add_in_vp9_rdopt :: (dest: u8, trans: Tran_High_T) -> u8 {
    trans = check_range_in_vp9_rdopt(trans);
    return clip_pixel_in_vp9_rdopt((cast(s32) dest) + trans);
}

vp9_is_valid_scale_in_vp9_rdopt :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_rdopt :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_rdopt(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_rdopt :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_rdopt :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_rdopt :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_rdopt :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_rdopt :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_rdopt :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_rdopt :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_rdopt :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_rdopt :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_rdopt :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_rdopt :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_rdopt(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_rdopt :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_rdopt(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_rdopt(MI, ib)];
}

get_uv_tx_size_in_vp9_rdopt :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_rdopt :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_rdopt :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_rdopt(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_rdopt :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_rdopt :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_rdopt :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_rdopt :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_rdopt :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_rdopt :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_rdopt :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_rdopt :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_rdopt :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_rdopt :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_rdopt :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_rdopt :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_rdopt :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_rdopt(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_rdopt :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_rdopt(cm.mi_cols);

        if get_plane_type_in_vp9_rdopt(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_rdopt(cm, xd);
}

get_partition_probs_in_vp9_rdopt :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_rdopt :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_rdopt :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_rdopt :: (
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

update_partition_context_in_vp9_rdopt :: (
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

partition_plane_context_in_vp9_rdopt :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

clamp_mv_ref_in_vp9_rdopt :: (mv: *MV, xd: *MACROBLOCKD) {
    clamp_mv_in_vp9_rdopt(
        mv,
        xd.mb_to_left_edge - (cast(s32) 16) << 3,
        xd.mb_to_right_edge + (cast(s32) 16) << 3,
        xd.mb_to_top_edge - (cast(s32) 16) << 3,
        xd.mb_to_bottom_edge + (cast(s32) 16) << 3
    );
}

get_sub_block_mv_in_vp9_rdopt :: (candidate: *MODE_INFO, which_mv: s32, search_col: s32, block_idx: s32) -> Int_Mv {
    return ifx block_idx >= 0 && candidate.sb_type < 3 then candidate.bmi[IDX_N_COLUMN_TO_SUBBLOCK_in_vp9_rdopt[block_idx][cast(s32) (search_col == 0)]].as_mv[which_mv] else candidate.mv[which_mv];
}

scale_mv_in_vp9_rdopt :: (mi: *MODE_INFO, ref: s32, THIS_REF_FRAME: MV_REFERENCE_FRAME, ref_sign_bias: *s32) -> Int_Mv {
    mv := mi.mv[ref];
    if ref_sign_bias[mi.ref_frame[ref]] != ref_sign_bias[THIS_REF_FRAME] {
        mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mv.as_mv.row) * -1);
        mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mv.as_mv.col) * -1);
    }
    return mv;
}

is_inside_in_vp9_rdopt :: (TILE: *Tile_Info, mi_col: s32, mi_row: s32, mi_rows: s32, mi_pos: *POSITION) -> s32 {
    if !(mi_row + mi_pos.row < 0 || mi_col + mi_pos.col < TILE.mi_col_start || mi_row + mi_pos.row >= mi_rows || mi_col + mi_pos.col >= TILE.mi_col_end) {
        return 1;
    }
    return 0;
}

clamp_mv2_in_vp9_rdopt :: (mv: *MV, xd: *MACROBLOCKD) {
    clamp_mv_in_vp9_rdopt(
        mv,
        xd.mb_to_left_edge - (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_right_edge + (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_top_edge - (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_bottom_edge + (cast,no_check(s32) ((160 - 4))) << 3
    );
}

lower_mv_precision_in_vp9_rdopt :: (mv: *MV, allow_hp: s32) {
    USE_HP := cast(s32) (allow_hp != 0 && use_mv_hp_in_vp9_rdopt(mv) != 0);
    if USE_HP == 0 {
        if mv.row & 1 != 0 {
            c_transpiler_compound_add(*(mv.row), ((ifx mv.row > 0 then cast(s32) -1 else 1)), s32, s32);
        }
        if mv.col & 1 != 0 {
            c_transpiler_compound_add(*(mv.col), ((ifx mv.col > 0 then cast(s32) -1 else 1)), s32, s32);
        }
    }
}

get_segment_id_in_vp9_rdopt :: (cm: *VP9_COMMON, segment_ids: *u8, bsize: BLOCK_SIZE, mi_row: s32, mi_col: s32) -> s32 {
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

vp9_get_pred_context_seg_id_in_vp9_rdopt :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    ABOVE_SIP := (ifx ABOVE_MI != null then cast,no_check(s32) ABOVE_MI.seg_id_predicted else 0);
    LEFT_SIP := (ifx LEFT_MI != null then cast,no_check(s32) LEFT_MI.seg_id_predicted else 0);

    return ABOVE_SIP + LEFT_SIP;
}

vp9_get_pred_prob_seg_id_in_vp9_rdopt :: (seg: *Segmentation, xd: *MACROBLOCKD) -> Prob {
    return seg.pred_probs[vp9_get_pred_context_seg_id_in_vp9_rdopt(xd)];
}

vp9_get_skip_context_in_vp9_rdopt :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    ABOVE_SKIP := (ifx ABOVE_MI != null then cast,no_check(s32) ABOVE_MI.skip else 0);
    LEFT_SKIP := (ifx LEFT_MI != null then cast,no_check(s32) LEFT_MI.skip else 0);
    return ABOVE_SKIP + LEFT_SKIP;
}

vp9_get_skip_prob_in_vp9_rdopt :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.skip_probs[vp9_get_skip_context_in_vp9_rdopt(xd)];
}

get_pred_context_switchable_interp_in_vp9_rdopt :: (xd: *MACROBLOCKD) -> s32 {
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

get_intra_inter_context_in_vp9_rdopt :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    HAS_ABOVE := cast(s32) (ABOVE_MI != null);
    HAS_LEFT := cast(s32) (LEFT_MI != null);

    if HAS_ABOVE != 0 && HAS_LEFT != 0 {
        ABOVE_INTRA := cast(s32) (is_inter_block_in_vp9_rdopt(ABOVE_MI) == 0);
        LEFT_INTRA := cast(s32) (is_inter_block_in_vp9_rdopt(LEFT_MI) == 0);
        return ifx LEFT_INTRA != 0 && ABOVE_INTRA != 0 then 3 else cast(s32) (LEFT_INTRA != 0 || ABOVE_INTRA != 0);
    } else if HAS_ABOVE != 0 || HAS_LEFT != 0 {
        return 2 * cast(s32) (is_inter_block_in_vp9_rdopt((ifx HAS_ABOVE != 0 then ABOVE_MI else LEFT_MI)) == 0);
    }
    return 0;
}

vp9_get_intra_inter_prob_in_vp9_rdopt :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.intra_inter_prob[get_intra_inter_context_in_vp9_rdopt(xd)];
}

vp9_get_reference_mode_prob_in_vp9_rdopt :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.comp_inter_prob[vp9_get_reference_mode_context(cm, xd)];
}

vp9_get_pred_prob_comp_ref_p_in_vp9_rdopt :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    PRED_CONTEXT := vp9_get_pred_context_comp_ref_p(cm, xd);
    return cm.fc.comp_ref_prob[PRED_CONTEXT];
}

vp9_get_pred_prob_single_ref_p1_in_vp9_rdopt :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return ((cm.fc.single_ref_prob[vp9_get_pred_context_single_ref_p1(xd)]).data)[0];
}

vp9_get_pred_prob_single_ref_p2_in_vp9_rdopt :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return ((cm.fc.single_ref_prob[vp9_get_pred_context_single_ref_p2(xd)]).data)[1];
}

get_tx_size_context_in_vp9_rdopt :: (xd: *MACROBLOCKD) -> s32 {
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

get_tx_probs_in_vp9_rdopt :: (max_tx_size: TX_SIZE, ctx: s32, tx_probs: *Tx_Probs) -> *Prob {
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

get_tx_counts_in_vp9_rdopt :: (max_tx_size: TX_SIZE, ctx: s32, tx_counts: *Tx_Counts) -> *u32 {
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

inter_predictor_in_vp9_rdopt :: (
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

scaled_buffer_offset_in_vp9_rdopt :: (x_offset: s32, y_offset: s32, stride: s32, sf: *Scale_Factors) -> s64 {
    X := (ifx sf != null then sf.scale_value_x(x_offset, sf) else x_offset);
    Y := (ifx sf != null then sf.scale_value_y(y_offset, sf) else y_offset);
    return ((cast,no_check(s64) Y) * cast(s64) stride) + cast(s64) X;
}

setup_pred_plane_in_vp9_rdopt :: (
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
    dst.buf = src + scaled_buffer_offset_in_vp9_rdopt(X, Y, stride, scale);
    dst.stride = stride;
}

get_coef_context_in_vp9_rdopt :: (neighbors: *s16, token_cache: *u8, c: s32) -> s32 {
    return ((1 + cast(s32) token_cache[neighbors[2 * c + 0]]) + cast(s32) token_cache[neighbors[2 * c + 1]]) >> 1;
}

get_scan_in_vp9_rdopt :: (
    xd: *MACROBLOCKD,
    tx_size: TX_SIZE,
    type: PLANE_TYPE,
    block_idx: s32
) -> *Scan_Order_in_vp9_scan {
    MI := xd.mi[0];

    if is_inter_block_in_vp9_rdopt(MI) != 0 || type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 {
        return VP9_DEFAULT_SCAN_ORDERS.data + tx_size;
    } else {
        MODE_ := get_y_mode_in_vp9_rdopt(MI, block_idx);
        return VP9_SCAN_ORDERS[tx_size].data + INTRA_MODE_TO_TX_TYPE_LOOKUP[MODE_];
    }
}

vp8_set_reference_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_vp9_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

gcd_in_vp9_rdopt :: (a: s64, b: s32) -> s32 {
    while b != 0 {
        r := cast,no_check(s32) (a % cast(s64) b);
        a = cast,no_check(s64) b;
        b = r;
    }

    return cast,no_check(s32) a;
}

reduce_ratio_in_vp9_rdopt :: (ratio: *Rational64_T) {
    DENOM := gcd_in_vp9_rdopt(ratio.num, ratio.den);
    ratio.num /= cast,no_check(s64) DENOM;
    ratio.den /= DENOM;
}

cyclic_refresh_segment_id_boosted_in_vp9_rdopt :: (segment_id: s32) -> s32 {
    if segment_id == 1 || segment_id == 2 {
        return 1;
    }
    return 0;
}

cyclic_refresh_segment_id_in_vp9_rdopt :: (segment_id: s32) -> s32 {
    if segment_id == 1 {
        return 1;
    } else if segment_id == 2 {
        return 2;
    } else {
        return 0;
    }
}

fps_init_first_pass_info_in_vp9_rdopt :: (
    first_pass_info: *FIRST_PASS_INFO,
    stats: *FIRSTPASS_STATS_in_vp9_cx_iface,
    num_frames: s32
) {
    first_pass_info.stats = stats;
    first_pass_info.num_frames = num_frames;
}

fps_get_num_frames_in_vp9_rdopt :: (first_pass_info: *FIRST_PASS_INFO) -> s32 {
    return first_pass_info.num_frames;
}

fps_get_frame_stats_in_vp9_rdopt :: (
    first_pass_info: *FIRST_PASS_INFO,
    show_idx: s32
) -> *FIRSTPASS_STATS_in_vp9_cx_iface {
    if show_idx < 0 || show_idx >= first_pass_info.num_frames {
        return null;
    }
    return *(cast(*FIRSTPASS_STATS_in_vp9_cx_iface) (first_pass_info.stats))[show_idx];
}

get_buf_from_mv_in_vp9_rdopt :: (buf: *Buf_2d, mv: *MV) -> *u8 {
    return *buf.buf[(cast(s32) mv.row) * buf.stride + cast(s32) mv.col];
}

cost_branch256_in_vp9_rdopt :: (ct: *u32, p: Prob) -> u64 {
    return ((cast,no_check(u64) ct[0]) * cast(u64) VP9_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP9_PROB_COST[256 - cast(s32) p];
}

treed_cost_in_vp9_rdopt :: (tree: *Tree_Index, probs: *Prob, bits: s32, len: s32) -> s32 {
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

rd_less_than_thresh_in_vp9_rdopt :: (best_rd: s64, thresh: s32, THRESH_FACT: *s32) -> s32 {
    if best_rd < ((cast,no_check(s64) thresh) * cast(s64) THRESH_FACT.*) >> 5 || thresh == 2147483647 {
        return 1;
    }
    return 0;
}

set_error_per_bit_in_vp9_rdopt :: (x: *MACROBLOCK, rdmult: s32) {
    x.errorperbit = rdmult >> 6;
    x.errorperbit += cast(s32) (x.errorperbit == 0);
}

write_in_vp9_rdopt :: (br: *Writer, bit: s32, probability: s32) {
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

write_bit_in_vp9_rdopt :: (w: *Writer, bit: s32) {
    write_in_vp9_rdopt(w, bit, 128);
}

write_literal_in_vp9_rdopt :: (w: *Writer, data: s32, bits: s32) {
    bit := bits - 1;
    while bit >= 0 {
        write_bit_in_vp9_rdopt(w, 1 & (data >> ((bit) & 31)));
        bit -= 1;
    }
}

vp9_write_tree_in_vp9_rdopt :: (w: *Writer, tree: *Tree_Index, probs: *Prob, bits: s32, len: s32, i: Tree_Index) {
    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            write_in_vp9_rdopt(w, BIT, cast,no_check(s32) probs[(cast(s32) i) >> 1]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }
}

vp9_write_token_in_vp9_rdopt :: (w: *Writer, tree: *Tree_Index, probs: *Prob, token: *Vp9_Token) {
    vp9_write_tree_in_vp9_rdopt(w, tree, probs, token.value, token.len, 0);
}

vp9_get_high_cost_table_in_vp9_rdopt :: (bit_depth: s32) -> *u16 {
    return VP9_CAT6_HIGH_COST.data;
}

vp9_get_token_extra_in_vp9_rdopt :: (v: s32, token: *s16, extra: *EXTRABIT) {
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

vp9_get_token_in_vp9_rdopt :: (v: s32) -> s16 {
    if v >= 67 || v <= -67 {
        return 10;
    }
    return vp9_dct_cat_lt_10_value_tokens[v].token;
}

vp9_get_token_cost_in_vp9_rdopt :: (v: s32, token: *s16, cat6_high_table: *u16) -> s32 {
    if v >= 67 || v <= -67 {
        token.* = 10;
        extrabits := cast,no_check(EXTRABIT) (absolute_value(v) - 67);
        return (cast(s32) VP9_CAT6_LOW_COST[extrabits & 0xff]) + cast(s32) cat6_high_table[(cast(s32) extrabits) >> 8];
    }
    token.* = vp9_dct_cat_lt_10_value_tokens[v].token;
    return vp9_dct_cat_lt_10_value_cost[v];
}

is_lossless_requested_in_vp9_rdopt :: (cfg: *VP9_Encoder_Config) -> s32 {
    if cfg.best_allowed_q == 0 && cfg.worst_allowed_q == 0 {
        return 1;
    }
    return 0;
}

stack_pop_in_vp9_rdopt :: (stack: *s32, stack_size: s32) -> s32 {
    R := stack[0];
    if 1 < stack_size {
        for idx: 1..stack_size - 1 {
            stack[idx - 1] = stack[idx];
        }
    }

    return R;
}

stack_top_in_vp9_rdopt :: (stack: *s32) -> s32 {
    return stack[0];
}

stack_push_in_vp9_rdopt :: (stack: *s32, new_item: s32, stack_size: s32) {
    idx := stack_size;
    while idx > 0 {
        stack[idx] = stack[idx - 1];
        idx -= 1;
    }
    stack[0] = new_item;
}

stack_init_in_vp9_rdopt :: (stack: *s32, length: s32) {
    if 0 < length {
        for idx: 0..length - 1 {
            stack[idx] = -1;
        }
    }
}

frame_is_kf_gf_arf_in_vp9_rdopt :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if frame_is_intra_only_in_vp9_rdopt(*cpi.common) != 0 ||
        cpi.refresh_alt_ref_frame != 0 ||
        cpi.refresh_golden_frame != 0 && cpi.rc.is_src_frame_alt_ref == 0 {
        return 1;
    }
    return 0;
}

ref_frame_to_flag_in_vp9_rdopt :: (ref_frame: s8) -> s32 {

    return K_VP9_REF_FLAG_LIST_in_vp9_rdopt[ref_frame];
}

get_ref_frame_map_idx_in_vp9_rdopt :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame: MV_REFERENCE_FRAME) -> s32 {
    if ref_frame == 1 {
        return cpi.lst_fb_idx;
    } else if ref_frame == 2 {
        return cpi.gld_fb_idx;
    } else {
        return cpi.alt_fb_idx;
    }
}

get_ref_frame_buf_idx_in_vp9_rdopt :: (CPI: *VP9_COMP_in_vp9_encoder, ref_frame: s32) -> s32 {
    CM := *CPI.common;
    MAP_IDX := get_ref_frame_map_idx_in_vp9_rdopt(CPI, cast,no_check(MV_REFERENCE_FRAME) ref_frame);
    return ifx MAP_IDX != -1 then CM.ref_frame_map[MAP_IDX] else -1;
}

get_ref_cnt_buffer_in_vp9_rdopt :: (cm: *VP9_COMMON, fb_idx: s32) -> *Ref_Cnt_Buffer {
    return ifx fb_idx != -1 then cm.buffer_pool.frame_bufs.data + fb_idx else null;
}

get_ref_frame_bufs_in_vp9_rdopt :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame_bufs: **Ref_Cnt_Buffer) {
    CM := *cpi.common;

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame < 4 {
        ref_frame_buf_idx := get_ref_frame_buf_idx_in_vp9_rdopt(cpi, cast,no_check(s32) ref_frame);
        inter_ref_idx := mv_ref_frame_to_inter_ref_idx_in_vp9_rdopt(ref_frame);
        ref_frame_bufs[inter_ref_idx] = get_ref_cnt_buffer_in_vp9_rdopt(CM, ref_frame_buf_idx);
        ref_frame += 1;
    }
}

get_ref_frame_buffer_in_vp9_rdopt :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    ref_frame: MV_REFERENCE_FRAME
) -> *YV12_BUFFER_CONFIG {
    CM := *CPI.common;
    BUF_IDX := get_ref_frame_buf_idx_in_vp9_rdopt(CPI, cast,no_check(s32) ref_frame);
    return ifx BUF_IDX != -1 then *CM.buffer_pool.frame_bufs[BUF_IDX].buf else null;
}

get_token_alloc_in_vp9_rdopt :: (mb_rows: s32, mb_cols: s32) -> s64 {
    ALIGNED_MB_ROWS :=
        (mb_rows +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    ALIGNED_MB_COLS :=
        (mb_cols +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    return ((cast,no_check(s64) ALIGNED_MB_ROWS) * cast(s64) ALIGNED_MB_COLS) * cast,no_check(s64) ((cast,no_check(s32) ((16 * 16))) * 3 + 4);
}

allocated_tokens_in_vp9_rdopt :: (tile: Tile_Info) -> s64 {
    tile_mb_rows := (tile.mi_row_end - tile.mi_row_start + 1) >> 1;
    tile_mb_cols := (tile.mi_col_end - tile.mi_col_start + 1) >> 1;

    return get_token_alloc_in_vp9_rdopt(tile_mb_rows, tile_mb_cols);
}

get_start_tok_in_vp9_rdopt :: (
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

    tok.* = cpi.tile_tok[tile_row][tile_col] + get_token_alloc_in_vp9_rdopt(MB_ROW, tile_mb_cols);
}

is_one_pass_svc_in_vp9_rdopt :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if CPI.use_svc != 0 && CPI.oxcf.pass == 0 {
        return 1;
    }
    return 0;
}

is_altref_enabled_in_vp9_rdopt :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if !(CPI.oxcf.mode == cast,no_check(u32) REALTIME && CPI.oxcf.rc_mode == cast,no_check(u32) CBR) &&
        CPI.oxcf.lag_in_frames >= 4 &&
        CPI.oxcf.enable_auto_arf != 0 {
        return 1;
    }
    return 0;
}

set_ref_ptrs_in_vp9_rdopt :: (CM: *VP9_COMMON, xd: *MACROBLOCKD, ref0: MV_REFERENCE_FRAME, ref1: MV_REFERENCE_FRAME) {
    xd.block_refs[0] = CM.frame_refs.data + (ifx ref0 >= 1 then (cast(s32) ref0) - 1 else 0);
    xd.block_refs[1] = CM.frame_refs.data + (ifx ref1 >= 1 then (cast(s32) ref1) - 1 else 0);
}

get_chessboard_index_in_vp9_rdopt :: (FRAME_INDEX: s32) -> s32 {
    return FRAME_INDEX & 0x1;
}

cond_cost_list_in_vp9_rdopt :: (cpi: *VP9_COMP_in_vp9_encoder, cost_list: *s32) -> *s32 {
    return ifx cpi.sf.mv.subpel_search_method != cast,no_check(u32) SUBPEL_TREE then cost_list else null;
}

get_num_vert_units_in_vp9_rdopt :: (tile: Tile_Info, shift: s32) -> s32 {
    num_vert_units := (tile.mi_row_end - tile.mi_row_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_vert_units;
}

get_num_cols_in_vp9_rdopt :: (tile: Tile_Info, shift: s32) -> s32 {
    num_cols := (tile.mi_col_end - tile.mi_col_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_cols;
}

get_level_index_in_vp9_rdopt :: (level: VP9_LEVEL) -> s32 {
    for i: 0..cast(s32) 14 - 1 {
        if level == VP9_LEVEL_DEFS[i].level {
            return i;
        }
    }
    return -1;
}

log_tile_cols_from_picsize_level_in_vp9_rdopt :: (width: u32, height: u32) -> s32 {
    PIC_SIZE := width * height;
    PIC_BREADTH := max(width, height);
    for i: 0..cast(s32) 14 - 1 {
        if VP9_LEVEL_DEFS[i].max_luma_picture_size >= PIC_SIZE && VP9_LEVEL_DEFS[i].max_luma_picture_breadth >= PIC_BREADTH {
            return get_msb_in_vp9_rdopt(cast,no_check(u32) VP9_LEVEL_DEFS[i].max_col_tiles);
        }
    }
    return 2147483647;
}

alloc_frame_mvs_in_vp9_rdopt :: (CM: *VP9_COMMON, buffer_idx: s32) {
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

mv_cost_in_vp9_rdopt :: (mv: *MV, joint_cost: *s32, comp_cost: **s32) -> s32 {
    return joint_cost[vp9_get_mv_joint_in_vp9_rdopt(mv)] + comp_cost[0][mv.row] + comp_cost[1][mv.col];
}

mvsad_err_cost_in_vp9_rdopt :: (x: *MACROBLOCK, mv: *MV, ref: *MV, sad_per_bit: s32) -> s32 {
    diff: MV = ---;
    diff.row = cast,no_check(s16) ((cast(s32) mv.row) - cast(s32) ref.row);
    diff.col = cast,no_check(s16) ((cast(s32) mv.col) - cast(s32) ref.col);
    return cast,no_check(s32) ((((cast,no_check(u32) mv_cost_in_vp9_rdopt(*diff, x.nmvjointsadcost.data, x.nmvsadcost.data)) * cast,no_check(u32) sad_per_bit) + cast,no_check(u32) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9);
}

get_start_mv_sad_in_vp9_rdopt :: (
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
    start_mv_sad += cast,no_check(u32) mvsad_err_cost_in_vp9_rdopt(x, mvp_full, ref_mv_full, sadpb);

    return start_mv_sad;
}

num_4x4_to_edge_in_vp9_rdopt :: (plane_4x4_dim: s32, mb_to_edge_dim: s32, subsampling_dim: s32, blk_dim: s32) -> s32 {
    return plane_4x4_dim + mb_to_edge_dim >> (((5 + subsampling_dim)) & 31) - blk_dim;
}

sum_squares_visible_in_vp9_rdopt :: (
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
    B4X4S_TO_RIGHT_EDGE := num_4x4_to_edge_in_vp9_rdopt(PLANE_4X4_W, xd.mb_to_right_edge, PD.subsampling_x, blk_col);
    B4X4S_TO_BOTTOM_EDGE :=
        num_4x4_to_edge_in_vp9_rdopt(
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

do_trellis_opt_in_vp9_rdopt :: (
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
                    sum_squares_visible_in_vp9_rdopt(
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

vp9_rd_pick_intra_mode_sb :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    rd_cost: *RD_COST,
    bsize: BLOCK_SIZE,
    ctx: *PICK_MODE_CONTEXT,
    best_rd: s64
) {
    CM := *cpi.common;
    XD := *x.e_mbd;
    PD := XD.plane.data;
    rate_y: s32 = 0;
    rate_uv: s32 = 0;
    rate_y_tokenonly: s32 = 0;
    rate_uv_tokenonly: s32 = 0;
    y_skip: s32 = 0;
    uv_skip: s32 = 0;
    dist_y: s64 = 0;
    dist_uv: s64 = 0;

    x.skip_encode = 0;
    ctx.skip = 0;
    XD.mi[0].ref_frame[0] = 0;
    XD.mi[0].ref_frame[1] = -1;

    XD.mi[0].interp_filter = 3;

    if bsize >= 3 {
        if rd_pick_intra_sby_mode(cpi, x, *rate_y, *rate_y_tokenonly, *dist_y, *y_skip, bsize, best_rd) >= best_rd {
            rd_cost.rate = 2147483647;
            return;
        }
    } else {
        y_skip = 0;
        if rd_pick_intra_sub_8x8_y_mode(cpi, x, *rate_y, *rate_y_tokenonly, *dist_y, best_rd) >= best_rd {
            rd_cost.rate = 2147483647;
            return;
        }
    }
    max_uv_tx_size := UV_TXSIZE_LOOKUP[bsize][XD.mi[0].tx_size][PD[1].subsampling_x][PD[1].subsampling_y];
    rd_pick_intra_sbuv_mode(
        cpi,
        x,
        ctx,
        *rate_uv,
        *rate_uv_tokenonly,
        *dist_uv,
        *uv_skip,
        cast,no_check(BLOCK_SIZE) ((ifx 3 > bsize then 3 else cast,no_check(s32) bsize)),
        max_uv_tx_size
    );

    if y_skip != 0 && uv_skip != 0 {
        rd_cost.rate =
            rate_y + rate_uv - rate_y_tokenonly - rate_uv_tokenonly +
                cast(s32) (VP9_PROB_COST[(256 - cast(s32) vp9_get_skip_prob_in_vp9_rdopt(CM, XD))]);
        rd_cost.dist = dist_y + dist_uv;
    } else {
        rd_cost.rate =
            rate_y + rate_uv +
                cast(s32) (VP9_PROB_COST[cast,no_check(s32) vp9_get_skip_prob_in_vp9_rdopt(CM, XD)]);
        rd_cost.dist = dist_y + dist_uv;
    }

    assignment_0: MODE_INFO = XD.mi[0].*;
    ((*ctx.mic).*) = assignment_0;
    assignment_1: MB_MODE_INFO_EXT = x.mbmi_ext.*;
    ((*ctx.mbmi_ext).*) = assignment_1;
    rd_cost.rdcost =
        ((((cast,no_check(s64) rd_cost.rate) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
            rd_cost.dist << ((x.rddiv) & 63);
}

rd_pick_intra_sbuv_mode :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    ctx: *PICK_MODE_CONTEXT,
    rate: *s32,
    rate_tokenonly: *s32,
    distortion: *s64,
    skippable: *s32,
    bsize: BLOCK_SIZE,
    max_tx_size: TX_SIZE
) -> s64 {
    xd := *x.e_mbd;

    mode_selected: PREDICTION_MODE = 0;
    best_rd: s64 = 9223372036854775807;
    this_rate_tokenonly: s32 = ---;
    s: s32 = ---;
    this_distortion, this_sse: s64 = ---;

    fill_memory(x.skip_txfm.data, 0, x.skip_txfm.count);
    mode: PREDICTION_MODE = 0;
    while mode <= 9 {
        if cpi.sf.intra_uv_mode_mask[max_tx_size] & ((cast(s32) 1) << ((mode) & 31)) == 0 {
            mode += 1;
            continue;
        }

        xd.mi[0].uv_mode = mode;

        if super_block_uvrd(cpi, x, *this_rate_tokenonly, *this_distortion, *s, *this_sse, bsize, best_rd) == 0 {
            mode += 1;
            continue;
        }
        this_rate := this_rate_tokenonly + cpi.intra_uv_mode_cost[cpi.common.frame_type][xd.mi[0].mode][mode];
        this_rd :=
            ((((cast,no_check(s64) this_rate) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                this_distortion << ((x.rddiv) & 63);

        if this_rd < best_rd {
            mode_selected = mode;
            best_rd = this_rd;
            rate.* = this_rate;
            rate_tokenonly.* = this_rate_tokenonly;
            distortion.* = this_distortion;
            skippable.* = s;
            if x.select_tx_size == 0 {
                swap_block_ptr(x, ctx, 2, 0, 1, 3);
            }
        }
        mode += 1;
    }

    xd.mi[0].uv_mode = mode_selected;
    return best_rd;
}

swap_block_ptr :: (x: *MACROBLOCK, ctx: *PICK_MODE_CONTEXT, m: s32, n: s32, min_plane: s32, max_plane: s32) {
    i := min_plane;
    while i < max_plane {
        P := x.plane.data + i;
        PD := x.e_mbd.plane.data + i;

        P.coeff = ctx.coeff_pbuf[i][m];
        P.qcoeff = ctx.qcoeff_pbuf[i][m];
        PD.dqcoeff = ctx.dqcoeff_pbuf[i][m];
        P.eobs = ctx.eobs_pbuf[i][m];

        ctx.coeff_pbuf[i][m] = ctx.coeff_pbuf[i][n];
        ctx.qcoeff_pbuf[i][m] = ctx.qcoeff_pbuf[i][n];
        ctx.dqcoeff_pbuf[i][m] = ctx.dqcoeff_pbuf[i][n];
        ctx.eobs_pbuf[i][m] = ctx.eobs_pbuf[i][n];

        ctx.coeff_pbuf[i][n] = P.coeff;
        ctx.qcoeff_pbuf[i][n] = P.qcoeff;
        ctx.dqcoeff_pbuf[i][n] = PD.dqcoeff;
        ctx.eobs_pbuf[i][n] = P.eobs;
        i += 1;
    }
}

super_block_uvrd :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    rate: *s32,
    distortion: *s64,
    skippable: *s32,
    sse: *s64,
    bsize: BLOCK_SIZE,
    ref_best_rd: s64
) -> s32 {
    XD := *x.e_mbd;
    MI := XD.mi[0];
    UV_TX_SIZE := get_uv_tx_size_in_vp9_rdopt(MI, XD.plane.data + 1);

    pnrate: s32 = 0;
    pnskip: s32 = 1;
    pndist: s64 = 0;
    pnsse: s64 = 0;
    is_cost_valid: s32 = 1;

    if ref_best_rd < 0 {
        is_cost_valid = 0;
    }

    if is_inter_block_in_vp9_rdopt(MI) != 0 && is_cost_valid != 0 {
        if 1 < 3 {
            for plane: 1..cast(s32) 3 - 1 {
                vp9_subtract_plane(x, bsize, plane);
            }
        }
    }

    rate.* = 0;
    distortion.* = 0;
    sse.* = 0;
    skippable.* = 1;

    if 1 < 3 {
        for plane: 1..cast(s32) 3 - 1 {
            txfm_rd_in_plane(
                cpi,
                x,
                *pnrate,
                *pndist,
                *pnskip,
                *pnsse,
                ref_best_rd,
                plane,
                bsize,
                UV_TX_SIZE,
                cpi.sf.use_fast_coef_costing,
                null
            );
            if pnrate == 2147483647 {
                is_cost_valid = 0;
                break;
            }
            rate.* += pnrate;
            distortion.* += pndist;
            sse.* += pnsse;
            skippable.* &= pnskip;
        }
    }

    if is_cost_valid == 0 {
        rate.* = 2147483647;
        distortion.* = 9223372036854775807;
        sse.* = 9223372036854775807;
        skippable.* = 0;
    }

    return is_cost_valid;
}

txfm_rd_in_plane :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    rate: *s32,
    distortion: *s64,
    skippable: *s32,
    sse: *s64,
    ref_best_rd: s64,
    plane: s32,
    bsize: BLOCK_SIZE,
    tx_size: TX_SIZE,
    use_fast_coef_costing: s32,
    recon: *Buf_2d
) {
    XD := *x.e_mbd;
    PD := XD.plane.data + plane;
    args: Rdcost_Block_Args = ---;
    fill_memory(*args, 0, size_of(Rdcost_Block_Args));
    args.cpi = cpi;
    args.x = x;
    args.best_rd = ref_best_rd;
    args.use_fast_coef_costing = use_fast_coef_costing;
    args.skippable = 1;
    args.this_recon = recon;

    if plane == 0 {
        XD.mi[0].tx_size = tx_size;
    }

    vp9_get_entropy_contexts(bsize, tx_size, PD, args.t_above.data, args.t_left.data);

    args.so = get_scan_in_vp9_rdopt(XD, tx_size, get_plane_type_in_vp9_rdopt(plane), 0);

    vp9_foreach_transformed_block_in_plane(
        XD,
        bsize,
        plane,
        cast,no_check(Foreach_Transformed_Block_Visitor) block_rd_txfm,
        cast(*void) *args
    );
    if args.exit_early != 0 {
        rate.* = 2147483647;
        distortion.* = 9223372036854775807;
        sse.* = 9223372036854775807;
        skippable.* = 0;
    } else {
        distortion.* = args.this_dist;
        rate.* = args.this_rate;
        sse.* = args.this_sse;
        skippable.* = cast,no_check(s32) args.skippable;
    }
}

block_rd_txfm :: (
    plane: s32,
    block: s32,
    blk_row: s32,
    blk_col: s32,
    plane_bsize: BLOCK_SIZE,
    tx_size: TX_SIZE,
    arg: *void
) {
    args := cast(*Rdcost_Block_Args) arg;
    X := args.x;
    XD := *X.e_mbd;
    MI := XD.mi[0];

    dist: s64 = 9223372036854775807;
    sse: s64 = 9223372036854775807;
    COEFF_CTX := combine_entropy_contexts_in_vp9_rdopt(args.t_left[blk_row], args.t_above[blk_col]);
    recon := args.this_recon;
    TX_BSIZE := TXSIZE_TO_BSIZE[tx_size];
    PD := XD.plane.data + plane;
    DST_STRIDE := PD.dst.stride;
    dst := *PD.dst.buf[4 * (blk_row * DST_STRIDE + blk_col)];
    ENABLE_TRELLIS_OPT := cast,no_check(s32) args.cpi.sf.trellis_opt_tx_rd.method;
    TRELLIS_OPT_THRESH := args.cpi.sf.trellis_opt_tx_rd.thresh;
    sse_calc_done: s32 = 0;

    encode_b_arg :=
        Encode_B_Args.{
            x = X,
            enable_trellis_opt = ENABLE_TRELLIS_OPT,
            trellis_opt_thresh = TRELLIS_OPT_THRESH,
            sse_calc_done = *sse_calc_done,
            sse = *sse,
            ta = args.t_above.data,
            tl = args.t_left.data,
            skip = *MI.skip
        };

    if args.exit_early != 0 {
        return;
    }

    if is_inter_block_in_vp9_rdopt(MI) == 0 {
        vp9_encode_block_intra(plane, block, blk_row, blk_col, plane_bsize, tx_size, cast(*void) *encode_b_arg);
        if recon != null {
            rec_ptr := *recon.buf[4 * (blk_row * recon.stride + blk_col)];
            copy_block_visible(XD, PD, dst, DST_STRIDE, rec_ptr, recon.stride, blk_row, blk_col, plane_bsize, TX_BSIZE);
        }
        if X.block_tx_domain != 0 {
            dist_block(
                args.cpi,
                X,
                plane,
                plane_bsize,
                block,
                blk_row,
                blk_col,
                tx_size,
                *dist,
                *sse,
                null,
                sse_calc_done
            );
        } else {
            P := X.plane.data + plane;
            SRC_STRIDE := P.src.stride;
            src := *P.src.buf[4 * (blk_row * SRC_STRIDE + blk_col)];

            if sse_calc_done == 0 {
                DIFF_STRIDE := 4 * cast(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[plane_bsize];
                diff := P.src_diff.data + 4 * (blk_row * DIFF_STRIDE + blk_col);
                visible_width, visible_height: s32 = ---;
                sse =
                    sum_squares_visible_in_vp9_rdopt(
                        XD,
                        PD,
                        diff,
                        DIFF_STRIDE,
                        blk_row,
                        blk_col,
                        plane_bsize,
                        TX_BSIZE,
                        *visible_width,
                        *visible_height
                    );
            }

            sse = sse * 16;
            tmp :=
                pixel_sse(
                    args.cpi,
                    XD,
                    PD,
                    src,
                    SRC_STRIDE,
                    dst,
                    DST_STRIDE,
                    blk_row,
                    blk_col,
                    plane_bsize,
                    TX_BSIZE
                );
            dist = (cast,no_check(s64) tmp) * 16;
        }
    } else {
        skip_txfm_flag: s32 = 0;
        if MAX_TXSIZE_LOOKUP[plane_bsize] == tx_size {
            skip_txfm_flag = cast,no_check(s32) X.skip_txfm[plane << 2 + block >> ((((cast(s32) tx_size) << 1)) & 31)];
        }

        if args.cpi.sf.allow_skip_txfm_ac_dc == 0 && skip_txfm_flag == 1 {
            skip_txfm_flag = 0;
        }

        if skip_txfm_flag == 0 || recon != null && skip_txfm_flag == 2 {
            P := X.plane.data + plane;
            DIFF_STRIDE := 4 * cast(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[plane_bsize];
            DIFF := P.src_diff.data + 4 * (blk_row * DIFF_STRIDE + blk_col);
            USE_TRELLIS_OPT :=
                do_trellis_opt_in_vp9_rdopt(
                    PD,
                    DIFF,
                    DIFF_STRIDE,
                    blk_row,
                    blk_col,
                    plane_bsize,
                    tx_size,
                    cast(*void) *encode_b_arg
                );

            vp9_xform_quant(X, plane, block, blk_row, blk_col, plane_bsize, tx_size);
            if USE_TRELLIS_OPT != 0 {
                vp9_optimize_b(X, plane, block, tx_size, COEFF_CTX);
            }
            dist_block(
                args.cpi,
                X,
                plane,
                plane_bsize,
                block,
                blk_row,
                blk_col,
                tx_size,
                *dist,
                *sse,
                recon,
                sse_calc_done
            );
        } else if skip_txfm_flag == 2 {
            COEFF := X.plane[plane].coeff + block * 16;
            DQCOEFF := XD.plane[plane].dqcoeff + block * 16;
            vp9_xform_quant_dc(X, plane, block, blk_row, blk_col, plane_bsize, tx_size);
            sse = X.bsse[plane << 2 + block >> ((((cast(s32) tx_size) << 1)) & 31)] << 4;
            dist = sse;
            if X.plane[plane].eobs[block] != 0 {
                ORIG_SSE := (cast,no_check(s64) COEFF[0]) * cast(s64) COEFF[0];
                RESD_SSE := cast,no_check(s64) ((cast(s32) COEFF[0]) - cast(s32) DQCOEFF[0]);
                dc_correct := ORIG_SSE - RESD_SSE * RESD_SSE;

                if tx_size != cast(TX_SIZE) 3 {
                    c_transpiler_compound_shr(*(dc_correct), (cast(s32) 2), s64, s64);
                }

                dist = ifx 0 > sse - dc_correct then 0 else sse - dc_correct;
            }
        } else {
        }
    }

    rd :=
        (((0 * cast(s64) X.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
            dist << ((X.rddiv) & 63);
    if args.this_rd + rd > args.best_rd {
        args.exit_early = 1;
        return;
    }

    rate := rate_block(plane, block, tx_size, COEFF_CTX, args);
    args.t_above[blk_col] = cast(ENTROPY_CONTEXT) (X.plane[plane].eobs[block] > 0);
    args.t_left[blk_row] = cast(ENTROPY_CONTEXT) (X.plane[plane].eobs[block] > 0);
    rd1 :=
        ((((cast,no_check(s64) rate) * cast(s64) X.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
            dist << ((X.rddiv) & 63);
    rd2 :=
        (((0 * cast(s64) X.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
            sse << ((X.rddiv) & 63);

    rd = min(rd1, rd2);
    if plane == 0 {
        X.zcoeff_blk[tx_size][block] =
            cast(u8) (X.plane[plane].eobs[block] == 0 ||
                X.sharpness == 0 && rd1 > rd2 && XD.lossless == 0);
        X.sum_y_eobs[tx_size] = cast,no_check(s32) (X.sum_y_eobs[tx_size] + cast,no_check(s32) X.plane[plane].eobs[block]);
    }

    args.this_rate += rate;
    args.this_dist += dist;
    args.this_sse += sse;
    args.this_rd += rd;

    if args.this_rd > args.best_rd {
        args.exit_early = 1;
        return;
    }

    args.skippable = cast,no_check(u8) ((cast,no_check(s32) args.skippable) & cast(s32) (X.plane[plane].eobs[block] == 0));
}

rate_block :: (plane: s32, block: s32, tx_size: TX_SIZE, coeff_ctx: s32, args: *Rdcost_Block_Args) -> s32 {
    return cost_coeffs_in_vp9_rdopt(
        args.x,
        plane,
        block,
        tx_size,
        coeff_ctx,
        args.so.scan,
        args.so.neighbors,
        args.use_fast_coef_costing
    );
}

cost_coeffs_in_vp9_rdopt :: (
    x: *MACROBLOCK,
    plane: s32,
    block: s32,
    tx_size: TX_SIZE,
    pt: s32,
    scan: *s16,
    nb: *s16,
    use_fast_coef_costing: s32
) -> s32 {
    XD := *x.e_mbd;
    mi := XD.mi[0];
    p := x.plane.data + plane;
    TYPE := get_plane_type_in_vp9_rdopt(plane);
    band_count := BAND_COUNTS[tx_size].data + 1;
    EOB := cast,no_check(s32) p.eobs[block];
    QCOEFF := p.qcoeff + block * 16;
    token_costs: *[2] [6] [12] u32 = (x.token_costs[tx_size][TYPE][is_inter_block_in_vp9_rdopt(mi)]).data;
    token_cache: [1024] u8 = ---;
    cost: s32 = ---;

    cat6_high_cost := vp9_get_high_cost_table_in_vp9_rdopt(8);

    if EOB == 0 {
        cost = cast,no_check(s32) token_costs[0][0][pt][11];
    } else if use_fast_coef_costing != 0 {
        band_left := cast,no_check(s32) ((c_transpiler_post_increment(*(band_count))).*);

        v := cast,no_check(s32) QCOEFF[0];
        prev_t: s16 = ---;
        cost = vp9_get_token_cost_in_vp9_rdopt(v, *prev_t, cat6_high_cost);
        cost = cast,no_check(s32) ((cast,no_check(u32) cost) + token_costs.*[0][pt][prev_t]);

        token_cache[0] = VP9_PT_ENERGY_CLASS[prev_t];
        token_costs += 1;

        if 1 < EOB {
            for c: 1..EOB - 1 {
                RC := cast,no_check(s32) scan[c];
                t: s16 = ---;

                v = cast,no_check(s32) QCOEFF[RC];
                cost += vp9_get_token_cost_in_vp9_rdopt(v, *t, cat6_high_cost);
                cost = cast,no_check(s32) ((cast,no_check(u32) cost) + token_costs.*[cast(s32) (prev_t == 0)][cast(s32) (prev_t == 0)][t]);
                prev_t = t;
                if c_transpiler_pre_decrement(*(band_left)) == 0 {
                    band_left = cast,no_check(s32) ((c_transpiler_post_increment(*(band_count))).*);
                    token_costs += 1;
                }
            }
        }

        if band_left != 0 {
            cost = cast,no_check(s32) ((cast,no_check(u32) cost) + token_costs.*[0][cast(s32) (prev_t == 0)][11]);
        }
    } else {
        band_left := cast,no_check(s32) ((c_transpiler_post_increment(*(band_count))).*);

        v := cast,no_check(s32) QCOEFF[0];
        tok: s16 = ---;

        cost = vp9_get_token_cost_in_vp9_rdopt(v, *tok, cat6_high_cost);
        cost = cast,no_check(s32) ((cast,no_check(u32) cost) + token_costs.*[0][pt][tok]);

        token_cache[0] = VP9_PT_ENERGY_CLASS[tok];
        token_costs += 1;

        tok_cost_ptr := token_costs.*.data + cast(s32) (tok == 0);

        c: s32 = 1;
        while c < EOB {
            RC := cast,no_check(s32) scan[c];

            v = cast,no_check(s32) QCOEFF[RC];
            cost += vp9_get_token_cost_in_vp9_rdopt(v, *tok, cat6_high_cost);
            pt = get_coef_context_in_vp9_rdopt(nb, token_cache.data, c);
            cost = cast,no_check(s32) ((cast,no_check(u32) cost) + tok_cost_ptr.*[pt][tok]);
            token_cache[RC] = VP9_PT_ENERGY_CLASS[tok];
            if c_transpiler_pre_decrement(*(band_left)) == 0 {
                band_left = cast,no_check(s32) ((c_transpiler_post_increment(*(band_count))).*);
                token_costs += 1;
            }
            tok_cost_ptr = token_costs.*.data + cast(s32) (tok == 0);
            c += 1;
        }

        if band_left != 0 {
            pt = get_coef_context_in_vp9_rdopt(nb, token_cache.data, c);
            cost = cast,no_check(s32) ((cast,no_check(u32) cost) + token_costs.*[0][pt][11]);
        }
    }

    return cost;
}

dist_block :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    plane: s32,
    plane_bsize: BLOCK_SIZE,
    block: s32,
    blk_row: s32,
    blk_col: s32,
    tx_size: TX_SIZE,
    out_dist: *s64,
    out_sse: *s64,
    out_recon: *Buf_2d,
    sse_calc_done: s32
) {
    XD := *x.e_mbd;
    P := x.plane.data + plane;
    PD := XD.plane.data + plane;
    EOB := cast,no_check(s32) P.eobs[block];

    if out_recon == null && x.block_tx_domain != 0 && EOB != 0 {
        SS_TXFRM_SIZE := (cast(s32) tx_size) << 1;
        this_sse: s64 = ---;
        SHIFT := (ifx tx_size == cast(TX_SIZE) 3 then cast(s32) 0 else 2);
        COEFF := P.coeff + block * 16;
        DQCOEFF := PD.dqcoeff + block * 16;

        out_dist.* =
            vp9_block_error_c(
                COEFF,
                DQCOEFF,
                cast,no_check(s64) ((cast(s32) 16) << ((SS_TXFRM_SIZE) & 31)),
                *this_sse
            ) >> ((SHIFT) & 63);

        out_sse.* = this_sse >> ((SHIFT) & 63);

        if x.skip_encode != 0 && is_inter_block_in_vp9_rdopt(XD.mi[0]) == 0 {
            MEAN_QUANT_ERROR :=
                cast,no_check(s64) ((((cast(s32) PD.dequant[1]) * cast(s32) PD.dequant[1]) *
                    (cast(s32) 1) << ((SS_TXFRM_SIZE) & 31)) >> (((SHIFT + 2)) & 31));

            out_dist.* += MEAN_QUANT_ERROR >> 4;
            out_sse.* += MEAN_QUANT_ERROR;
        }
    } else {
        TX_BSIZE := TXSIZE_TO_BSIZE[tx_size];
        BS := 4 * cast(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[TX_BSIZE];
        SRC_STRIDE := P.src.stride;
        DST_STRIDE := PD.dst.stride;
        SRC_IDX := 4 * (blk_row * SRC_STRIDE + blk_col);
        DST_IDX := 4 * (blk_row * DST_STRIDE + blk_col);
        src := *P.src.buf[SRC_IDX];
        dst := *PD.dst.buf[DST_IDX];
        out_recon_ptr: *u8 = null;

        dqcoeff := PD.dqcoeff + block * 16;

        tmp: u32 = ifx sse_calc_done != 0
            then cast,no_check(u32) out_sse.*
            else pixel_sse(cpi, XD, PD, src, SRC_STRIDE, dst, DST_STRIDE, blk_row, blk_col, plane_bsize, TX_BSIZE);
        out_sse.* = (cast,no_check(s64) tmp) * 16;
        if out_recon != null {
            OUT_RECON_IDX := 4 * (blk_row * out_recon.stride + blk_col);
            out_recon_ptr = *out_recon.buf[OUT_RECON_IDX];
            copy_block_visible(
                XD,
                PD,
                dst,
                DST_STRIDE,
                out_recon_ptr,
                out_recon.stride,
                blk_row,
                blk_col,
                plane_bsize,
                TX_BSIZE
            );
        }

        if EOB != 0 {
            recon: [1024] u8 = --- #align 16;

            convolve_copy_c(dst, cast,no_check(s64) DST_STRIDE, recon.data, 32, null, 0, 0, 0, 0, BS, BS);
            if cast,no_check(s32) tx_size == {
                case cast,no_check(s32) cast(TX_SIZE) 3;
                    vp9_idct32x32_add(dqcoeff, recon.data, 32, EOB);
                case cast,no_check(s32) cast(TX_SIZE) 2;
                    vp9_idct16x16_add(dqcoeff, recon.data, 32, EOB);
                case cast,no_check(s32) cast(TX_SIZE) 1;
                    vp9_idct8x8_add(dqcoeff, recon.data, 32, EOB);
                case;
                    x.inv_txfm_add(dqcoeff, recon.data, 32, EOB);
            }

            tmp = pixel_sse(cpi, XD, PD, src, SRC_STRIDE, recon.data, 32, blk_row, blk_col, plane_bsize, TX_BSIZE);
            if out_recon != null {
                copy_block_visible(
                    XD,
                    PD,
                    recon.data,
                    32,
                    out_recon_ptr,
                    out_recon.stride,
                    blk_row,
                    blk_col,
                    plane_bsize,
                    TX_BSIZE
                );
            }
        }

        out_dist.* = (cast,no_check(s64) tmp) * 16;
    }
}

copy_block_visible :: (
    xd: *MACROBLOCKD,
    PD: *Macroblockd_Plane,
    src: *u8,
    SRC_STRIDE: s32,
    dst: *u8,
    DST_STRIDE: s32,
    blk_row: s32,
    blk_col: s32,
    PLANE_BSIZE: BLOCK_SIZE,
    TX_BSIZE: BLOCK_SIZE
) {
    PLANE_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE];
    PLANE_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE];
    TX_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[TX_BSIZE];
    TX_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[TX_BSIZE];
    b4x4s_to_right_edge := num_4x4_to_edge_in_vp9_rdopt(PLANE_4X4_W, xd.mb_to_right_edge, PD.subsampling_x, blk_col);
    b4x4s_to_bottom_edge :=
        num_4x4_to_edge_in_vp9_rdopt(
            PLANE_4X4_H,
            xd.mb_to_bottom_edge,
            PD.subsampling_y,
            blk_row
        );
    IS_HIGHBD := xd.cur_buf.flags & 8;
    if TX_BSIZE == 0 || b4x4s_to_right_edge >= TX_4X4_W && b4x4s_to_bottom_edge >= TX_4X4_H {
        W := TX_4X4_W << 2;
        H := TX_4X4_H << 2;

        convolve_copy_c(src, cast,no_check(s64) SRC_STRIDE, dst, cast,no_check(s64) DST_STRIDE, null, 0, 0, 0, 0, W, H);
    } else {
        c: s32 = ---;
        max_r := min(b4x4s_to_bottom_edge, TX_4X4_H);
        max_c := min(b4x4s_to_right_edge, TX_4X4_W);

        if 0 < max_r {
            for r: 0..max_r - 1 {
                c = 0;
                while c < max_c {
                    src_ptr := src + r * SRC_STRIDE * 4 + c * 4;
                    dst_ptr := dst + r * DST_STRIDE * 4 + c * 4;

                    convolve_copy_c(
                        src_ptr,
                        cast,no_check(s64) SRC_STRIDE,
                        dst_ptr,
                        cast,no_check(s64) DST_STRIDE,
                        null,
                        0,
                        0,
                        0,
                        0,
                        4,
                        4
                    );
                    c += 1;
                }
            }
        }
    }
}

pixel_sse :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    xd: *MACROBLOCKD,
    PD: *Macroblockd_Plane,
    src: *u8,
    SRC_STRIDE: s32,
    dst: *u8,
    DST_STRIDE: s32,
    blk_row: s32,
    blk_col: s32,
    PLANE_BSIZE: BLOCK_SIZE,
    TX_BSIZE: BLOCK_SIZE
) -> u32 {
    sse: u32 = 0;
    PLANE_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE];
    PLANE_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE];
    TX_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[TX_BSIZE];
    TX_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[TX_BSIZE];
    b4x4s_to_right_edge := num_4x4_to_edge_in_vp9_rdopt(PLANE_4X4_W, xd.mb_to_right_edge, PD.subsampling_x, blk_col);
    b4x4s_to_bottom_edge :=
        num_4x4_to_edge_in_vp9_rdopt(
            PLANE_4X4_H,
            xd.mb_to_bottom_edge,
            PD.subsampling_y,
            blk_row
        );
    if TX_BSIZE == 0 || b4x4s_to_right_edge >= TX_4X4_W && b4x4s_to_bottom_edge >= TX_4X4_H {
        CPI.fn_ptr[TX_BSIZE].vf(src, SRC_STRIDE, dst, DST_STRIDE, *sse);
    } else {
        VF_4X4 := CPI.fn_ptr[0].vf;
        c: s32 = ---;
        this_sse: u32 = 0;
        max_r := min(b4x4s_to_bottom_edge, TX_4X4_H);
        max_c := min(b4x4s_to_right_edge, TX_4X4_W);
        sse = 0;

        if 0 < max_r {
            for r: 0..max_r - 1 {
                c = 0;
                while c < max_c {
                    VF_4X4(
                        src + r * SRC_STRIDE * 4 + c * 4,
                        SRC_STRIDE,
                        dst + r * DST_STRIDE * 4 + c * 4,
                        DST_STRIDE,
                        *this_sse
                    );
                    sse += this_sse;
                    c += 1;
                }
            }
        }
    }
    return sse;
}

rd_pick_intra_sub_8x8_y_mode :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    mb: *MACROBLOCK,
    rate: *s32,
    rate_y: *s32,
    distortion: *s64,
    best_rd: s64
) -> s64 {
    i, j: s32 = ---;
    XD := *mb.e_mbd;
    MIC := XD.mi[0];
    above_mi := XD.above_mi;
    left_mi := XD.left_mi;
    BSIZE := XD.mi[0].sb_type;
    NUM_4X4_BLOCKS_WIDE := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[BSIZE];
    NUM_4X4_BLOCKS_HIGH := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[BSIZE];
    idx: s32 = ---;
    cost: s32 = 0;
    total_distortion: s64 = 0;
    tot_rate_y: s32 = 0;
    total_rd: s64 = 0;
    bmode_costs := cpi.mbmode_cost.data;

    idy: s32 = 0;
    while idy < 2 {
        idx = 0;
        while idx < 2 {
            best_mode: PREDICTION_MODE = 0;
            r: s32 = 2147483647;
            ry: s32 = 2147483647;
            d: s64 = 9223372036854775807;
            this_rd: s64 = 9223372036854775807;
            i = idy * 2 + idx;
            if cpi.common.frame_type == cast,no_check(u32) KEY_FRAME {
                A := vp9_above_block_mode(MIC, above_mi, i);
                L := vp9_left_block_mode(MIC, left_mi, i);

                bmode_costs = cpi.y_mode_costs[A][L].data;
            }

            this_rd =
                rd_pick_intra4x4block_in_vp9_rdopt(
                    cpi,
                    mb,
                    idy,
                    idx,
                    *best_mode,
                    bmode_costs,
                    XD.plane[0].above_context + idx,
                    XD.plane[0].left_context + idy,
                    *r,
                    *ry,
                    *d,
                    BSIZE,
                    best_rd - total_rd
                );

            if this_rd >= best_rd - total_rd {
                return 9223372036854775807;
            }

            total_rd += this_rd;
            cost += r;
            total_distortion += d;
            tot_rate_y += ry;

            MIC.bmi[i].as_mode = best_mode;
            j = 1;
            while j < NUM_4X4_BLOCKS_HIGH {
                MIC.bmi[i + j * 2].as_mode = best_mode;
                j += 1;
            }
            j = 1;
            while j < NUM_4X4_BLOCKS_WIDE {
                MIC.bmi[i + j].as_mode = best_mode;
                j += 1;
            }

            if total_rd >= best_rd {
                return 9223372036854775807;
            }
            idx += NUM_4X4_BLOCKS_WIDE;
        }
        idy += NUM_4X4_BLOCKS_HIGH;
    }

    rate.* = cost;
    rate_y.* = tot_rate_y;
    distortion.* = total_distortion;
    MIC.mode = MIC.bmi[3].as_mode;

    return ((((cast,no_check(s64) cost) * cast(s64) mb.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + total_distortion << ((mb.rddiv) & 63);
}

rd_pick_intra4x4block_in_vp9_rdopt :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    row: s32,
    col: s32,
    best_mode: *PREDICTION_MODE,
    bmode_costs: *s32,
    a: *ENTROPY_CONTEXT,
    l: *ENTROPY_CONTEXT,
    bestrate: *s32,
    bestratey: *s32,
    bestdistortion: *s64,
    bsize: BLOCK_SIZE,
    rd_thresh: s64
) -> s64 {
    mode: PREDICTION_MODE = ---;
    XD := *x.e_mbd;
    best_rd := rd_thresh;
    p := x.plane.data + 0;
    pd := XD.plane.data + 0;
    SRC_STRIDE := p.src.stride;
    DST_STRIDE := pd.dst.stride;
    src_init := *p.src.buf[row * 4 * SRC_STRIDE + col * 4];
    dst_init := *pd.dst.buf[row * 4 * SRC_STRIDE + col * 4];
    ta, tempa: [2] ENTROPY_CONTEXT = ---;
    tl, templ: [2] ENTROPY_CONTEXT = ---;
    NUM_4X4_BLOCKS_WIDE := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[bsize];
    NUM_4X4_BLOCKS_HIGH := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[bsize];
    idx, idy: s32 = ---;
    best_dst: [64] u8 = ---;

    copy_memory(ta.data, a, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE);
    copy_memory(tl.data, l, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH);

    XD.mi[0].tx_size = 0;

    mode = 0;
    while loop := mode <= 9 {
        this_rd: s64 = ---;
        ratey: s32 = 0;
        distortion: s64 = 0;
        rate := bmode_costs[mode];
        if cpi.sf.intra_y_mode_mask[0] & ((cast(s32) 1) << ((mode) & 31)) == 0 {
            mode += 1;
            continue;
        }
        if cpi.sf.mode_search_skip_flags & cast,no_check(u32) FLAG_SKIP_INTRA_DIRMISMATCH != 0 {
            if conditional_skipintra(mode, best_mode.*) != 0 {
                mode += 1;
                continue;
            }
        }
        copy_memory(tempa.data, ta.data, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE);
        copy_memory(templ.data, tl.data, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH);
        while next := true { // Forward-goto shim; executes at most once.
            idy = 0;
            while idy < NUM_4X4_BLOCKS_HIGH {
                idx = 0;
                while idx < NUM_4X4_BLOCKS_WIDE {
                    BLOCK_ := (row + idy) * 2 + (col + idx);
                    SRC := *src_init[idx * 4 + idy * 4 * SRC_STRIDE];
                    DST := *dst_init[idx * 4 + idy * 4 * DST_STRIDE];
                    SRC_DIFF := vp9_raster_block_offset_int16(3, BLOCK_, p.src_diff.data);
                    COEFF := p.coeff + BLOCK_ * 16;
                    QCOEFF := p.qcoeff + BLOCK_ * 16;
                    DQCOEFF := pd.dqcoeff + BLOCK_ * 16;
                    EOB := *p.eobs[BLOCK_];
                    XD.mi[0].bmi[BLOCK_].as_mode = mode;
                    vp9_predict_intra_block(
                        XD,
                        1,
                        0,
                        mode,
                        (ifx x.skip_encode != 0 then SRC else DST),
                        (ifx x.skip_encode != 0 then SRC_STRIDE else DST_STRIDE),
                        DST,
                        DST_STRIDE,
                        col + idx,
                        row + idy,
                        0
                    );
                    subtract_block_c(
                        4,
                        4,
                        SRC_DIFF,
                        8,
                        SRC,
                        cast,no_check(s64) SRC_STRIDE,
                        DST,
                        cast,no_check(s64) DST_STRIDE
                    );

                    if XD.lossless != 0 {
                        so := VP9_DEFAULT_SCAN_ORDERS.data + 0;
                        COEFF_CTX := combine_entropy_contexts_in_vp9_rdopt(tempa[idx], templ[idy]);
                        vp9_fwht4x4_c(SRC_DIFF, COEFF, 8);
                        quantize_b_c(COEFF, 4 * 4, p, QCOEFF, DQCOEFF, pd.dequant, EOB, so);
                        ratey +=
                            cost_coeffs_in_vp9_rdopt(
                                x,
                                0,
                                BLOCK_,
                                0,
                                COEFF_CTX,
                                so.scan,
                                so.neighbors,
                                cpi.sf.use_fast_coef_costing
                            );
                        templ[idy] = cast(ENTROPY_CONTEXT) (x.plane[0].eobs[BLOCK_] > 0);
                        tempa[idx] = templ[idy];
                        if (((((cast,no_check(s64) ratey) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + distortion << ((x.rddiv) & 63)) >= best_rd {
                            break next;
                        }
                        vp9_iwht4x4_add(pd.dqcoeff + BLOCK_ * 16, DST, DST_STRIDE, cast,no_check(s32) p.eobs[BLOCK_]);
                    } else {
                        unused: s64 = ---;
                        TX_TYPE_ :=
                            get_tx_type_4x4_in_vp9_rdopt(
                                cast,no_check(PLANE_TYPE) PLANE_TYPE_Y,
                                XD,
                                BLOCK_
                            );
                        so := VP9_SCAN_ORDERS[0].data + TX_TYPE_;
                        COEFF_CTX := combine_entropy_contexts_in_vp9_rdopt(tempa[idx], templ[idy]);
                        vp9_fht4x4_c(SRC_DIFF, COEFF, 8, cast,no_check(s32) TX_TYPE_);
                        quantize_b_c(COEFF, 4 * 4, p, QCOEFF, DQCOEFF, pd.dequant, EOB, so);
                        ratey +=
                            cost_coeffs_in_vp9_rdopt(
                                x,
                                0,
                                BLOCK_,
                                0,
                                COEFF_CTX,
                                so.scan,
                                so.neighbors,
                                cpi.sf.use_fast_coef_costing
                            );
                        templ[idy] = cast(ENTROPY_CONTEXT) (x.plane[0].eobs[BLOCK_] > 0);
                        tempa[idx] = templ[idy];
                        distortion += vp9_block_error_c(COEFF, pd.dqcoeff + BLOCK_ * 16, 16, *unused) >> 2;
                        if (((((cast,no_check(s64) ratey) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + distortion << ((x.rddiv) & 63)) >= best_rd {
                            break next;
                        }
                        vp9_iht4x4_add(
                            TX_TYPE_,
                            pd.dqcoeff + BLOCK_ * 16,
                            DST,
                            DST_STRIDE,
                            cast,no_check(s32) p.eobs[BLOCK_]
                        );
                    }
                    idx += 1;
                }
                idy += 1;
            }
            rate += ratey;
            this_rd =
                ((((cast,no_check(s64) rate) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                    distortion << ((x.rddiv) & 63);
            if this_rd < best_rd {
                bestrate.* = rate;
                bestratey.* = ratey;
                bestdistortion.* = distortion;
                best_rd = this_rd;
                best_mode.* = mode;
                copy_memory(a, tempa.data, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE);
                copy_memory(l, templ.data, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH);
                idy = 0;
                while idy < NUM_4X4_BLOCKS_HIGH * 4 {
                    copy_memory(
                        best_dst.data + idy * 8,
                        dst_init + idy * DST_STRIDE,
                        cast,no_check(u64) (NUM_4X4_BLOCKS_WIDE * 4)
                    );
                    idy += 1;
                }
            }
            break next;
        }
        {
        }
        mode += 1;
    }

    if best_rd >= rd_thresh || x.skip_encode != 0 {
        return best_rd;
    }

    idy = 0;
    while idy < NUM_4X4_BLOCKS_HIGH * 4 {
        copy_memory(dst_init + idy * DST_STRIDE, best_dst.data + idy * 8, cast,no_check(u64) (NUM_4X4_BLOCKS_WIDE * 4));
        idy += 1;
    }

    return best_rd;
}

conditional_skipintra :: (mode: PREDICTION_MODE, best_intra_mode: PREDICTION_MODE) -> s32 {
    if mode == 5 && best_intra_mode != 1 && best_intra_mode != 4 {
        return 1;
    }
    if mode == 8 && best_intra_mode != 1 && best_intra_mode != 3 {
        return 1;
    }
    if mode == 7 && best_intra_mode != 2 && best_intra_mode != 3 {
        return 1;
    }
    if mode == 6 && best_intra_mode != 2 && best_intra_mode != 4 {
        return 1;
    }
    return 0;
}

rd_pick_intra_sby_mode :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    rate: *s32,
    rate_tokenonly: *s32,
    distortion: *s64,
    skippable: *s32,
    bsize: BLOCK_SIZE,
    best_rd: s64
) -> s64 {
    mode_selected: PREDICTION_MODE = 0;
    XD := *x.e_mbd;
    MIC := XD.mi[0];
    this_rate_tokenonly: s32 = ---;
    s: s32 = ---;
    this_distortion: s64 = ---;
    best_tx: TX_SIZE = 0;

    above_mi := XD.above_mi;
    left_mi := XD.left_mi;
    A := vp9_above_block_mode(MIC, above_mi, 0);
    L := vp9_left_block_mode(MIC, left_mi, 0);
    bmode_costs := cpi.y_mode_costs[A][L].data;

    fill_memory(x.skip_txfm.data, 0, x.skip_txfm.count);

    mode: PREDICTION_MODE = 0;
    while mode <= 9 {
        if cpi.sf.use_nonrd_pick_mode != 0 {
            if conditional_skipintra(mode, mode_selected) != 0 {
                mode += 1;
                continue;
            }
            if skippable.* != 0 {
                break;
            }
        }

        MIC.mode = mode;

        super_block_yrd(cpi, x, *this_rate_tokenonly, *this_distortion, *s, null, bsize, best_rd, null);

        if this_rate_tokenonly == 2147483647 {
            mode += 1;
            continue;
        }

        this_rate := this_rate_tokenonly + bmode_costs[mode];
        this_rd :=
            ((((cast,no_check(s64) this_rate) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                this_distortion << ((x.rddiv) & 63);

        if this_rd < best_rd {
            mode_selected = mode;
            best_rd = this_rd;
            best_tx = MIC.tx_size;
            rate.* = this_rate;
            rate_tokenonly.* = this_rate_tokenonly;
            distortion.* = this_distortion;
            skippable.* = s;
        }
        mode += 1;
    }

    MIC.mode = mode_selected;
    MIC.tx_size = best_tx;

    return best_rd;
}

super_block_yrd :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    rate: *s32,
    distortion: *s64,
    skip: *s32,
    psse: *s64,
    bs: BLOCK_SIZE,
    ref_best_rd: s64,
    recon: *Buf_2d
) {
    xd := *x.e_mbd;
    sse: s64 = ---;
    ret_sse := (ifx psse != null then psse else *sse);

    if cpi.sf.tx_size_search_method == cast,no_check(u32) USE_LARGESTALL || xd.lossless != 0 {
        choose_largest_tx_size(cpi, x, rate, distortion, skip, ret_sse, ref_best_rd, bs, recon);
    } else {
        choose_tx_size_from_rd(cpi, x, rate, distortion, skip, ret_sse, ref_best_rd, bs, recon);
    }
}

choose_tx_size_from_rd :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    rate: *s32,
    distortion: *s64,
    skip: *s32,
    psse: *s64,
    ref_best_rd: s64,
    bs: BLOCK_SIZE,
    recon: *Buf_2d
) {
    MAX_TX_SIZE := MAX_TXSIZE_LOOKUP[bs];
    CM := *cpi.common;
    XD := *x.e_mbd;
    MI := XD.mi[0];
    skip_prob := vp9_get_skip_prob_in_vp9_rdopt(CM, XD);
    r: [4] [2] s32 = ---;
    s: [4] s32 = ---;
    d, sse: [4] s64 = ---;
    rd :=
        [2] s64.[
            s64.[ 9223372036854775807, 9223372036854775807 ],
            s64.[ 9223372036854775807, 9223372036854775807 ],
            s64.[ 9223372036854775807, 9223372036854775807 ],
            s64.[ 9223372036854775807, 9223372036854775807 ]
        ];

    best_rd := ref_best_rd;
    best_tx := MAX_TX_SIZE;
    start_tx, end_tx: s32 = ---;
    TX_SIZE_CTX := get_tx_size_context_in_vp9_rdopt(XD);

    recon_buf: [4] [4096] u8 = --- #align 16;

    s0 := cast,no_check(s32) (VP9_PROB_COST[cast,no_check(s32) skip_prob]);
    s1 := cast,no_check(s32) (VP9_PROB_COST[(256 - cast(s32) skip_prob)]);

    if CM.tx_mode == cast,no_check(u32) TX_MODE_SELECT {
        start_tx = cast,no_check(s32) MAX_TX_SIZE;
        end_tx = ifx start_tx - cpi.sf.tx_size_search_depth > 0 then start_tx - cpi.sf.tx_size_search_depth else 0;
        if bs > 9 {
            end_tx = ifx end_tx + 1 < start_tx then end_tx + 1 else start_tx;
        }
    } else {
        chosen_tx_size :=
            cast,no_check(TX_SIZE) ((ifx MAX_TX_SIZE < TX_MODE_TO_BIGGEST_TX_SIZE[CM.tx_mode] then cast,no_check(s32) MAX_TX_SIZE else cast,no_check(s32) TX_MODE_TO_BIGGEST_TX_SIZE[CM.tx_mode]));
        start_tx = cast,no_check(s32) chosen_tx_size;
        end_tx = cast,no_check(s32) chosen_tx_size;
    }

    n := start_tx;
    while n >= end_tx {
        R_TX_SIZE := cpi.tx_size_cost[(cast(s32) MAX_TX_SIZE) - 1][TX_SIZE_CTX][n];
        if recon != null {
            this_recon: Buf_2d = ---;
            this_recon.buf = recon_buf[n].data;
            this_recon.stride = recon.stride;
            txfm_rd_in_plane(
                cpi,
                x,
                r[n].data + 0,
                d.data + n,
                s.data + n,
                sse.data + n,
                best_rd,
                0,
                bs,
                cast,no_check(TX_SIZE) n,
                cpi.sf.use_fast_coef_costing,
                *this_recon
            );
        } else {
            txfm_rd_in_plane(
                cpi,
                x,
                r[n].data + 0,
                d.data + n,
                s.data + n,
                sse.data + n,
                best_rd,
                0,
                bs,
                cast,no_check(TX_SIZE) n,
                cpi.sf.use_fast_coef_costing,
                null
            );
        }
        r[n][1] = r[n][0];
        if r[n][0] < 2147483647 {
            r[n][1] += R_TX_SIZE;
        }
        if d[n] == 9223372036854775807 || r[n][0] == 2147483647 {
            rd[n][1] = 9223372036854775807;
            rd[n][0] = rd[n][1];
        } else if s[n] != 0 {
            if is_inter_block_in_vp9_rdopt(MI) != 0 {
                rd[n][1] =
                    (((((cast,no_check(s64) s1) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                        sse[n] << ((x.rddiv) & 63));
                rd[n][0] = rd[n][1];
                r[n][1] -= R_TX_SIZE;
            } else {
                rd[n][0] =
                    ((((cast,no_check(s64) s1) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                        sse[n] << ((x.rddiv) & 63);
                rd[n][1] =
                    ((((cast,no_check(s64) (s1 + R_TX_SIZE)) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                        sse[n] << ((x.rddiv) & 63);
            }
        } else {
            rd[n][0] =
                ((((cast,no_check(s64) (r[n][0] + s0)) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                    d[n] << ((x.rddiv) & 63);
            rd[n][1] =
                ((((cast,no_check(s64) (r[n][1] + s0)) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                    d[n] << ((x.rddiv) & 63);
        }

        if is_inter_block_in_vp9_rdopt(MI) != 0 && XD.lossless == 0 && s[n] == 0 && sse[n] != 9223372036854775807 {
            rd[n][0] =
                ifx rd[n][0] < ((((cast,no_check(s64) s1) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                    sse[n] << ((x.rddiv) & 63) then rd[n][0] else ((((cast,no_check(s64) s1) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + sse[n] << ((x.rddiv) & 63);
            rd[n][1] =
                ifx rd[n][1] < ((((cast,no_check(s64) s1) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                    sse[n] << ((x.rddiv) & 63) then rd[n][1] else ((((cast,no_check(s64) s1) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + sse[n] << ((x.rddiv) & 63);
        }

        if cpi.sf.tx_size_search_breakout != 0 &&
            (rd[n][1] == 9223372036854775807 || n < cast,no_check(s32) MAX_TX_SIZE && rd[n][1] > rd[n + 1][1] || s[n] == 1) {
            break;
        }

        if rd[n][1] < best_rd {
            best_tx = cast,no_check(TX_SIZE) n;
            best_rd = rd[n][1];
        }
        n -= 1;
    }
    MI.tx_size = best_tx;

    distortion.* = d[MI.tx_size];
    rate.* = r[MI.tx_size][cast(s32) (CM.tx_mode == cast,no_check(u32) TX_MODE_SELECT)];
    skip.* = s[MI.tx_size];
    psse.* = sse[MI.tx_size];
    if recon != null {
        copy_memory(recon.buf, recon_buf[MI.tx_size].data, cast,no_check(u64) (64 * 64));
    }
}

choose_largest_tx_size :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    rate: *s32,
    distortion: *s64,
    skip: *s32,
    sse: *s64,
    ref_best_rd: s64,
    bs: BLOCK_SIZE,
    recon: *Buf_2d
) {
    MAX_TX_SIZE := MAX_TXSIZE_LOOKUP[bs];
    CM := *cpi.common;
    LARGEST_TX_SIZE := TX_MODE_TO_BIGGEST_TX_SIZE[CM.tx_mode];
    XD := *x.e_mbd;
    MI := XD.mi[0];

    MI.tx_size = cast,no_check(TX_SIZE) (min(cast,no_check(s32) MAX_TX_SIZE, cast,no_check(s32) LARGEST_TX_SIZE));

    txfm_rd_in_plane(
        cpi,
        x,
        rate,
        distortion,
        skip,
        sse,
        ref_best_rd,
        0,
        bs,
        MI.tx_size,
        cpi.sf.use_fast_coef_costing,
        recon
    );
}

vp9_rd_pick_inter_mode_sb :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    tile_data: *Tile_Data_Enc,
    x: *MACROBLOCK,
    mi_row: s32,
    mi_col: s32,
    rd_cost: *RD_COST,
    bsize: BLOCK_SIZE,
    ctx: *PICK_MODE_CONTEXT,
    best_rd_so_far: s64
) {
    CM := *cpi.common;
    TILE_INFO := *tile_data.tile_info;
    RD_OPT_ := *cpi.rd;
    SF := *cpi.sf;
    XD := *x.e_mbd;
    MI := XD.mi[0];
    MBMI_EXT := x.mbmi_ext;
    SEG := *CM.seg;

    segment_id := cast,no_check(u8) MI.segment_id;
    k: s32 = ---;
    frame_mv: [14] [4] Int_Mv = ---;
    yv12_mb: [4] [3] Buf_2d;
    single_newmv: [4] Int_Mv;
    single_inter_filter: [14] [4] INTERP_FILTER = ---;
    single_skippable: [14] [4] s32 = ---;
    single_mode_rate: [4] [4] s32 = ---;
    best_rd := best_rd_so_far;
    best_pred_diff: [3] s64 = ---;
    best_pred_rd: [3] s64 = ---;
    best_filter_rd: [4] s64 = ---;
    best_filter_diff: [4] s64 = ---;
    best_mbmode: MODE_INFO = ---;
    best_mode_skippable: s32 = 0;
    best_mode_index: s32 = -1;
    ref_costs_single, ref_costs_comp: [4] u32 = ---;
    comp_mode_p: Prob = ---;
    best_intra_rd: s64 = 9223372036854775807;
    best_pred_sse: u32 = U32_MAX;
    best_intra_mode: PREDICTION_MODE = 0;
    rate_uv_intra, rate_uv_tokenonly: [4] s32 = ---;
    dist_uv: [4] s64 = ---;
    skip_uv: [4] s32 = ---;
    mode_uv: [4] PREDICTION_MODE = ---;
    INTRA_COST_PENALTY := vp9_get_intra_cost_penalty(cpi, bsize, CM.base_qindex, CM.y_dc_delta_q);
    best_skip2: s32 = 0;
    ref_frame_skip_mask := u8.[ 0, 1 ];
    mode_skip_mask: [4] u16;
    mode_skip_start := SF.mode_skip_start + 1;
    RD_THRESHES := RD_OPT_.threshes[segment_id][bsize].data;
    RD_THRESH_FREQ_FACT := tile_data.thresh_freq_fact[bsize].data;
    mode_threshold: [30] s64 = ---;
    tile_mode_map := tile_data.mode_map[bsize].data;
    mode_map: [30] s8 = ---;

    MODE_SEARCH_SKIP_FLAGS := cast,no_check(s32) SF.mode_search_skip_flags;
    IS_RECT_PARTITION := cast(s32) (NUM_4X4_BLOCKS_WIDE_LOOKUP[bsize] != NUM_4X4_BLOCKS_HIGH_LOOKUP[bsize]);
    mask_filter: s64 = 0;
    filter_cache: [4] s64 = ---;

    recon_buf: Buf_2d = ---;

    recon8: [4096] u8 = --- #align 16;
    recon_buf.buf = recon8.data;

    recon_buf.stride = 64;
    recon: *Buf_2d = (ifx cpi.oxcf.content == cast,no_check(u32) VP9E_CONTENT_FILM then *recon_buf else null);

    fill_memory(*best_mbmode, 0, size_of(MODE_INFO));

    x.skip_encode = cast(s32) (SF.skip_encode_frame != 0 && x.q_index < 115);

    i: s32 = 0;
    while i < 3 + 1 {
        filter_cache[i] = 9223372036854775807;
        i += 1;
    }

    estimate_ref_frame_costs(
        CM,
        XD,
        cast,no_check(s32) segment_id,
        ref_costs_single.data,
        ref_costs_comp.data,
        *comp_mode_p
    );

    i = 0;
    while i < REFERENCE_MODES {
        best_pred_rd[i] = 9223372036854775807;
        i += 1;
    }
    i = 0;
    while i < 3 + 1 {
        best_filter_rd[i] = 9223372036854775807;
        i += 1;
    }
    i = 0;
    while i < cast,no_check(s32) (cast(TX_SIZE) 4) {
        rate_uv_intra[i] = 2147483647;
        i += 1;
    }
    i = 0;
    while i < 4 {
        x.pred_sse[i] = 2147483647;
        i += 1;
    }
    i = 0;
    while i < 14 {
        k = 0;
        while k < 4 {
            single_inter_filter[i][k] = 4;
            single_skippable[i][k] = 0;
            k += 1;
        }
        i += 1;
    }

    rd_cost.rate = 2147483647;

    init_frame_mv(frame_mv.data);

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame <= 3 {
        x.pred_mv_sad[ref_frame] = 2147483647;
        if cpi.ref_frame_flags & ref_frame_to_flag_in_vp9_rdopt(ref_frame) != 0 &&
            !(IS_RECT_PARTITION != 0 && (cast(s32) ctx.skip_ref_frame_mask) & ((cast(s32) 1) << ((ref_frame) & 31)) != 0) {
            setup_buffer_inter(
                cpi,
                x,
                ref_frame,
                bsize,
                mi_row,
                mi_col,
                frame_mv[10].data,
                frame_mv[11].data,
                yv12_mb.data
            );
        }
        frame_mv[13][ref_frame].as_int = 0x80008000;
        frame_mv[12][ref_frame].as_int = 0;
        ref_frame += 1;
    }

    ref_frame = 1;
    while ref_frame <= 3 {
        if cpi.ref_frame_flags & ref_frame_to_flag_in_vp9_rdopt(ref_frame) == 0 {
            ref_frame_skip_mask[0] = cast,no_check(u8) ((cast,no_check(s32) ref_frame_skip_mask[0]) | ((cast(s32) 1) << ((ref_frame) & 31)));
            ref_frame_skip_mask[1] = cast,no_check(u8) ((cast,no_check(s32) ref_frame_skip_mask[1]) | ((cast(s32) 1) << 3 | 0x1));
        } else if SF.reference_masking != 0 {
            i = 1;
            while i <= 3 {
                if x.pred_mv_sad[ref_frame] >> 2 > x.pred_mv_sad[i] {
                    mode_skip_mask[ref_frame] = cast,no_check(u16) ((cast,no_check(s32) mode_skip_mask[ref_frame]) | cast,no_check(s32) (INTER_NEAREST_NEAR_ZERO));
                    break;
                }
                i += 1;
            }
        }

        if segfeature_active_in_vp9_rdopt(
            SEG,
            cast,no_check(s32) segment_id,
            cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
        ) != 0 &&
            get_segdata_in_vp9_rdopt(SEG, cast,no_check(s32) segment_id, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME) != cast,no_check(s32) ref_frame {
            ref_frame_skip_mask[0] = cast,no_check(u8) ((cast,no_check(s32) ref_frame_skip_mask[0]) | ((cast(s32) 1) << ((ref_frame) & 31)));
            ref_frame_skip_mask[1] = cast,no_check(u8) ((cast,no_check(s32) ref_frame_skip_mask[1]) | ((cast(s32) 1) << 3 | 0x1));
        }
        ref_frame += 1;
    }

    if segfeature_active_in_vp9_rdopt(
        SEG,
        cast,no_check(s32) segment_id,
        cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
    ) == 0 {
        if cpi.rc.is_src_frame_alt_ref != 0 && cpi.oxcf.arnr_max_frames == 0 {
            ref_frame_skip_mask[0] = cast,no_check(u8) ((cast(s32) 1) << 1 | ((cast(s32) 1) << 2));
            ref_frame_skip_mask[1] = cast,no_check(u8) ((cast(s32) 1) << 3 | 0x1);
            mode_skip_mask[3] = cast,no_check(u16) (~(INTER_NEAREST_NEAR_ZERO));
            if frame_mv[11][3].as_int != 0 {
                mode_skip_mask[3] = cast,no_check(u16) ((cast,no_check(s32) mode_skip_mask[3]) | ((cast(s32) 1) << 11));
            }
            if frame_mv[10][3].as_int != 0 {
                mode_skip_mask[3] = cast,no_check(u16) ((cast,no_check(s32) mode_skip_mask[3]) | ((cast(s32) 1) << 10));
            }
        }
    }

    if cpi.rc.is_src_frame_alt_ref != 0 {
        if SF.alt_ref_search_fp != 0 {
            mode_skip_mask[3] = 0;
            ref_frame_skip_mask[0] = cast,no_check(u8) (~((cast(s32) 1) << 3) & 0xff);
            ref_frame_skip_mask[1] = cast,no_check(u8) ((cast(s32) 1) << 3 | 0x1);
        }
    }

    if SF.alt_ref_search_fp != 0 {
        if CM.show_frame == 0 && x.pred_mv_sad[2] < 2147483647 {
            if x.pred_mv_sad[3] > x.pred_mv_sad[2] << 1 {
                mode_skip_mask[3] = cast,no_check(u16) ((cast,no_check(s32) mode_skip_mask[3]) | cast,no_check(s32) (INTER_ALL));
            }
        }
    }

    if SF.adaptive_mode_search != 0 {
        if CM.show_frame != 0 &&
            cpi.rc.is_src_frame_alt_ref == 0 &&
            cpi.rc.frames_since_golden >= 3 &&
            x.pred_mv_sad[1] < 2147483647 {
            if x.pred_mv_sad[2] > x.pred_mv_sad[1] << 1 {
                mode_skip_mask[2] = cast,no_check(u16) ((cast,no_check(s32) mode_skip_mask[2]) | cast,no_check(s32) (INTER_ALL));
            }
        }
    }

    if bsize > SF.max_intra_bsize && cpi.ref_frame_flags != 0 {
        ref_frame_skip_mask[0] = cast,no_check(u8) ((cast,no_check(s32) ref_frame_skip_mask[0]) | 1);
        ref_frame_skip_mask[1] = cast,no_check(u8) ((cast,no_check(s32) ref_frame_skip_mask[1]) | 1);
    }

    mode_skip_mask[0] = cast,no_check(u16) ((cast,no_check(s32) mode_skip_mask[0]) | cast,no_check(s32) (cast,no_check(u16) (~(SF.intra_y_mode_mask[MAX_TXSIZE_LOOKUP[bsize]]))));

    i = 0;
    while i <= 6 {
        mode_threshold[i] = 0;
        i += 1;
    }

    i = cast,no_check(s32) ((6 + 1));
    while i < 30 {
        mode_threshold[i] = ((cast,no_check(s64) RD_THRESHES[i]) * cast(s64) RD_THRESH_FREQ_FACT[i]) >> 5;
        i += 1;
    }

    midx := (ifx SF.schedule_mode_search != 0 then mode_skip_start else 0);

    while midx > 4 {
        end_pos: u8 = 0;
        i = 5;
        while i < midx {
            if mode_threshold[tile_mode_map[i - 1]] > mode_threshold[tile_mode_map[i]] {
                tmp := cast,no_check(u8) tile_mode_map[i];
                tile_mode_map[i] = tile_mode_map[i - 1];
                tile_mode_map[i - 1] = cast,no_check(s8) tmp;
                end_pos = cast,no_check(u8) i;
            }
            i += 1;
        }
        midx = cast,no_check(s32) end_pos;
    }

    copy_memory(mode_map.data, tile_mode_map, mode_map.count);

    midx = 0;
    while midx < 30 {
        mode_index := cast,no_check(s32) mode_map[midx];
        mode_excluded: s32 = 0;
        this_rd: s64 = 9223372036854775807;
        disable_skip: s32 = 0;
        compmode_cost: s32 = 0;
        rate2: s32 = 0;
        rate_y: s32 = 0;
        rate_uv: s32 = 0;
        distortion2: s64 = 0;
        distortion_y: s64 = 0;
        distortion_uv: s64 = 0;
        skippable: s32 = 0;
        this_skip2: s32 = 0;
        total_sse: s64 = 9223372036854775807;
        early_term: s32 = 0;

        this_mode := VP9_MODE_ORDER[mode_index].mode;
        ref_frame = VP9_MODE_ORDER[mode_index].ref_frame[0];
        second_ref_frame := VP9_MODE_ORDER[mode_index].ref_frame[1];

        fill_memory(*x.sum_y_eobs, 0, x.sum_y_eobs.count * size_of(s32));
        comp_pred := cast(s32) (second_ref_frame > 0);
        if comp_pred == 0 && ref_frame != 0 && SF.prune_single_mode_based_on_mv_diff_mode_rate != 0 {
            single_mode_rate[ref_frame][(cast(s32) this_mode) - 10] = 2147483647;
        }

        if IS_RECT_PARTITION != 0 {
            if (cast(s32) ctx.skip_ref_frame_mask) & ((cast(s32) 1) << ((ref_frame) & 31)) != 0 {
                midx += 1;
                continue;
            }
            if second_ref_frame > 0 && (cast(s32) ctx.skip_ref_frame_mask) & ((cast(s32) 1) << ((second_ref_frame) & 31)) != 0 {
                midx += 1;
                continue;
            }
        }

        if midx == mode_skip_start && best_mode_index >= 0 {
            if cast,no_check(s32) best_mbmode.ref_frame[0] == {
                case 0;
                case 1;
                    ref_frame_skip_mask[0] = cast,no_check(u8) ((cast,no_check(s32) ref_frame_skip_mask[0]) | ((cast(s32) 1) << 2 | ((cast(s32) 1) << 3) | 1));
                case 2;
                    ref_frame_skip_mask[0] = cast,no_check(u8) ((cast,no_check(s32) ref_frame_skip_mask[0]) | ((cast(s32) 1) << 1 | ((cast(s32) 1) << 3) | 1));
                case 3;
                    ref_frame_skip_mask[0] = cast,no_check(u8) ((cast,no_check(s32) ref_frame_skip_mask[0]) | ((cast(s32) 1) << 1 | ((cast(s32) 1) << 2) | 1));
                case -1; #through;
                case 4;
            }
        }

        if (cast(s32) ref_frame_skip_mask[0]) & ((cast(s32) 1) << ((ref_frame) & 31)) != 0 &&
            (cast(s32) ref_frame_skip_mask[1]) & ((cast(s32) 1) << (((ifx 0 > second_ref_frame then 0 else cast,no_check(s32) second_ref_frame)) & 31)) != 0 {
            midx += 1;
            continue;
        }

        if (cast(s32) mode_skip_mask[ref_frame]) & ((cast(s32) 1) << ((this_mode) & 31)) != 0 {
            midx += 1;
            continue;
        }

        if best_mode_skippable != 0 && SF.schedule_mode_search != 0 {
            c_transpiler_compound_shl(*(mode_threshold[mode_index]), (cast(s32) 1), s64, s64);
        }

        if best_rd < mode_threshold[mode_index] {
            midx += 1;
            continue;
        }

        if cpi.oxcf.motion_vector_unit_test != 0 && ref_frame == 0 {
            midx += 1;
            continue;
        }

        if SF.motion_field_mode_search != 0 {
            MI_WIDTH :=
                (ifx cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize] < TILE_INFO.mi_col_end -
                    mi_col then cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize] else TILE_INFO.mi_col_end - mi_col);
            MI_HEIGHT :=
                (ifx cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize] < TILE_INFO.mi_row_end -
                    mi_row then cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize] else TILE_INFO.mi_row_end - mi_row);
            BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
            cb_partition_search_ctrl :=
                ((mi_row + mi_col) >> ((BSL) & 31) +
                    get_chessboard_index_in_vp9_rdopt(cast,no_check(s32) CM.current_video_frame)) & 0x1;
            ref_mi: *MODE_INFO = ---;
            const_motion: s32 = 1;
            skip_ref_frame := cast(s32) (cb_partition_search_ctrl == 0);
            rf: MV_REFERENCE_FRAME = -1;
            ref_mv: Int_Mv = ---;
            ref_mv.as_int = 0x80008000;

            if mi_row - 1 >= TILE_INFO.mi_row_start {
                ref_mv = XD.mi[-XD.mi_stride].mv[0];
                rf = XD.mi[-XD.mi_stride].ref_frame[0];
                i = 0;
                while i < MI_WIDTH {
                    ref_mi = XD.mi[-XD.mi_stride + i];
                    const_motion &=
                        cast(s32) (ref_mv.as_int == ref_mi.mv[0].as_int &&
                            ref_frame == ref_mi.ref_frame[0]);
                    skip_ref_frame &= cast(s32) (rf == ref_mi.ref_frame[0]);
                    i += 1;
                }
            }

            if mi_col - 1 >= TILE_INFO.mi_col_start {
                if ref_mv.as_int == 0x80008000 {
                    ref_mv = XD.mi[-1].mv[0];
                }
                if rf == -1 {
                    rf = XD.mi[-1].ref_frame[0];
                }
                i = 0;
                while i < MI_HEIGHT {
                    ref_mi = XD.mi[i * XD.mi_stride - 1];
                    const_motion &=
                        cast(s32) (ref_mv.as_int == ref_mi.mv[0].as_int &&
                            ref_frame == ref_mi.ref_frame[0]);
                    skip_ref_frame &= cast(s32) (rf == ref_mi.ref_frame[0]);
                    i += 1;
                }
            }

            if skip_ref_frame != 0 && this_mode != 10 && this_mode != 13 {
                if rf > 0 {
                    if ref_frame != rf {
                        midx += 1;
                        continue;
                    }
                }
            }

            if const_motion != 0 {
                if this_mode == 11 || this_mode == 12 {
                    midx += 1;
                    continue;
                }
            }
        }

        if comp_pred != 0 {
            if cpi.allow_comp_inter_inter == 0 {
                midx += 1;
                continue;
            }

            if CM.ref_frame_sign_bias[ref_frame] == CM.ref_frame_sign_bias[second_ref_frame] {
                midx += 1;
                continue;
            }

            if cpi.ref_frame_flags & ref_frame_to_flag_in_vp9_rdopt(second_ref_frame) == 0 {
                midx += 1;
                continue;
            }

            if segfeature_active_in_vp9_rdopt(
                SEG,
                cast,no_check(s32) segment_id,
                cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
            ) != 0 {
                midx += 1;
                continue;
            }

            if MODE_SEARCH_SKIP_FLAGS & cast,no_check(s32) (FLAG_SKIP_COMP_BESTINTRA) != 0 &&
                best_mode_index >= 0 &&
                best_mbmode.ref_frame[0] == 0 {
                midx += 1;
                continue;
            }

            mode_excluded = cast(s32) (CM.reference_mode == cast,no_check(u32) SINGLE_REFERENCE);
        } else if ref_frame != 0 {
            mode_excluded = cast(s32) (CM.reference_mode == cast,no_check(u32) COMPOUND_REFERENCE);
        }

        if ref_frame == 0 {
            if SF.adaptive_mode_search != 0 {
                if (x.source_variance << ((NUM_PELS_LOG2_LOOKUP[bsize]) & 31)) > best_pred_sse {
                    midx += 1;
                    continue;
                }
            }

            if this_mode != 0 {
                SKIP_INTRA_VAR_THRESH :=
                    (ifx cpi.oxcf.content == cast,no_check(u32) VP9E_CONTENT_FILM then cast(u32) 0 else 64);
                if MODE_SEARCH_SKIP_FLAGS & cast,no_check(s32) (FLAG_SKIP_INTRA_LOWVAR) != 0 && x.source_variance < SKIP_INTRA_VAR_THRESH {
                    midx += 1;
                    continue;
                }

                if MODE_SEARCH_SKIP_FLAGS & cast,no_check(s32) (FLAG_SKIP_INTRA_BESTINTER) != 0 && this_mode >= 3 && this_mode <= 9 {
                    if best_mode_index >= 0 && best_mbmode.ref_frame[0] > 0 {
                        midx += 1;
                        continue;
                    }
                }
                if MODE_SEARCH_SKIP_FLAGS & cast,no_check(s32) (FLAG_SKIP_INTRA_DIRMISMATCH) != 0 {
                    if conditional_skipintra(this_mode, best_intra_mode) != 0 {
                        midx += 1;
                        continue;
                    }
                }
            }
        } else {
            REF_FRAMES_ := MV_REFERENCE_FRAME.[ ref_frame, second_ref_frame ];
            if check_best_zero_mv(
                cpi,
                MBMI_EXT.mode_context.data,
                frame_mv.data,
                cast,no_check(s32) this_mode,
                REF_FRAMES_.data
            ) == 0 {
                midx += 1;
                continue;
            }
        }

        MI.mode = this_mode;
        MI.uv_mode = 0;
        MI.ref_frame[0] = ref_frame;
        MI.ref_frame[1] = second_ref_frame;

        MI.interp_filter =
            cast,no_check(INTERP_FILTER) ((ifx CM.interp_filter == 4 then 0 else cast,no_check(s32) CM.interp_filter));
        MI.mv[1].as_int = 0;
        MI.mv[0].as_int = MI.mv[1].as_int;

        x.skip = 0;
        set_ref_ptrs_in_vp9_rdopt(CM, XD, ref_frame, second_ref_frame);

        i = 0;
        while i < 3 {
            XD.plane[i].pre[0] = yv12_mb[ref_frame][i];
            if comp_pred != 0 {
                XD.plane[i].pre[1] = yv12_mb[second_ref_frame][i];
            }
            i += 1;
        }

        if ref_frame == 0 {
            PD := XD.plane.data + 1;

            fill_memory(x.skip_txfm.data, 0, x.skip_txfm.count);
            super_block_yrd(cpi, x, *rate_y, *distortion_y, *skippable, null, bsize, best_rd, recon);

            if rate_y == 2147483647 {
                midx += 1;
                continue;
            }

            uv_tx := UV_TXSIZE_LOOKUP[bsize][MI.tx_size][PD.subsampling_x][PD.subsampling_y];

            if rate_uv_intra[uv_tx] == 2147483647 {
                choose_intra_uv_mode(
                    cpi,
                    x,
                    ctx,
                    bsize,
                    uv_tx,
                    rate_uv_intra.data + uv_tx,
                    rate_uv_tokenonly.data + uv_tx,
                    dist_uv.data + uv_tx,
                    skip_uv.data + uv_tx,
                    mode_uv.data + uv_tx
                );
            }

            rate_uv = rate_uv_tokenonly[uv_tx];
            distortion_uv = dist_uv[uv_tx];
            skippable = cast(s32) (skippable != 0 && skip_uv[uv_tx] != 0);
            MI.uv_mode = mode_uv[uv_tx];

            rate2 = rate_y + cpi.mbmode_cost[MI.mode] + rate_uv_intra[uv_tx];
            if this_mode != 0 && this_mode != 9 {
                rate2 += INTRA_COST_PENALTY;
            }
            distortion2 = distortion_y + distortion_uv;
        } else {
            this_rd =
                handle_inter_mode(
                    cpi,
                    x,
                    bsize,
                    *rate2,
                    *distortion2,
                    *skippable,
                    *rate_y,
                    *rate_uv,
                    recon,
                    *disable_skip,
                    frame_mv.data,
                    mi_row,
                    mi_col,
                    single_newmv.data,
                    single_inter_filter.data,
                    single_skippable.data,
                    single_mode_rate[ref_frame].data + 0,
                    *total_sse,
                    best_rd,
                    *mask_filter,
                    filter_cache.data,
                    best_mode_index
                );

            if this_rd == 9223372036854775807 {
                midx += 1;
                continue;
            }

            compmode_cost =
                cast,no_check(s32) (VP9_PROB_COST[(ifx comp_pred != 0 then 256 -
                    cast(s32) comp_mode_p else cast,no_check(s32) comp_mode_p)]);

            if CM.reference_mode == cast,no_check(u32) REFERENCE_MODE_SELECT {
                rate2 += compmode_cost;
            }
        }

        if comp_pred != 0 {
            rate2 = cast,no_check(s32) ((cast,no_check(u32) rate2) + ref_costs_comp[ref_frame]);
        } else {
            rate2 = cast,no_check(s32) ((cast,no_check(u32) rate2) + ref_costs_single[ref_frame]);
        }

        if disable_skip == 0 {
            SKIP_PROB := vp9_get_skip_prob_in_vp9_rdopt(CM, XD);
            SKIP_COST0 := cast,no_check(s32) (VP9_PROB_COST[cast,no_check(s32) SKIP_PROB]);
            SKIP_COST1 := cast,no_check(s32) (VP9_PROB_COST[(256 - cast(s32) SKIP_PROB)]);

            if skippable != 0 {
                rate2 -= rate_y + rate_uv;

                rate2 += SKIP_COST1;
            } else if ref_frame != 0 && XD.lossless == 0 && cpi.oxcf.sharpness == 0 {
                if (((((cast,no_check(s64) (rate_y + rate_uv + SKIP_COST0)) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + distortion2 << ((x.rddiv) & 63)) < ((((cast,no_check(s64) SKIP_COST1) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + total_sse << ((x.rddiv) & 63) {
                    rate2 += SKIP_COST0;
                } else {
                    rate2 += SKIP_COST1;
                    distortion2 = total_sse;
                    rate2 -= rate_y + rate_uv;
                    this_skip2 = 1;
                }
            } else {
                rate2 += SKIP_COST0;
            }

            this_rd =
                ((((cast,no_check(s64) rate2) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                    distortion2 << ((x.rddiv) & 63);
        }

        if recon != null {
            if cpi.oxcf.content == cast,no_check(u32) VP9E_CONTENT_FILM {
                if bsize >= 6 {
                    min_energy, max_energy: s32 = ---;
                    vp9_get_sub_block_energy(cpi, x, mi_row, mi_col, bsize, *min_energy, *max_energy);
                    if max_energy > min_energy {
                        if ref_frame == 0 {
                            if this_mode == 0 {
                                this_rd += this_rd * cast(s64) (max_energy - min_energy);
                            } else {
                                this_rd += (this_rd * cast(s64) (max_energy - min_energy)) / 4;
                            }
                        } else if second_ref_frame > 0 {
                            this_rd += this_rd / 4;
                        }
                    }
                }
            }

            rd_variance_adjustment(cpi, x, bsize, *this_rd, recon, ref_frame, second_ref_frame, this_mode);
        }

        if ref_frame == 0 {
            if this_rd < best_intra_rd {
                best_intra_rd = this_rd;
                best_intra_mode = MI.mode;
            }
        }

        if disable_skip == 0 && ref_frame == 0 {
            i = 0;
            while i < REFERENCE_MODES {
                best_pred_rd[i] = ifx best_pred_rd[i] < this_rd then best_pred_rd[i] else this_rd;
                i += 1;
            }
            i = 0;
            while i < 3 + 1 {
                best_filter_rd[i] = ifx best_filter_rd[i] < this_rd then best_filter_rd[i] else this_rd;
                i += 1;
            }
        }

        if this_rd < best_rd || x.skip != 0 {
            max_plane: s32 = 3;
            if mode_excluded == 0 {
                best_mode_index = mode_index;

                if ref_frame == 0 {
                    MI.mv[0].as_int = 0;
                    max_plane = 1;

                    MI.interp_filter = 3;
                } else {
                    best_pred_sse = x.pred_sse[ref_frame];
                }

                rd_cost.rate = rate2;
                rd_cost.dist = distortion2;
                rd_cost.rdcost = this_rd;
                best_rd = this_rd;
                assignment_2: MODE_INFO = MI.*;
                ((*best_mbmode).*) = assignment_2;
                best_skip2 = this_skip2;
                best_mode_skippable = skippable;

                if x.select_tx_size == 0 {
                    swap_block_ptr(x, ctx, 1, 0, 0, max_plane);
                }
                copy_memory(ctx.zcoeff_blk, x.zcoeff_blk[MI.tx_size].data, cast,no_check(u64) ctx.num_4x4_blk);
                ctx.sum_y_eobs = x.sum_y_eobs[MI.tx_size];

                if MODE_SEARCH_SKIP_FLAGS & cast,no_check(s32) (FLAG_EARLY_TERMINATE) != 0 && mode_index > 3 {
                    qstep := cast,no_check(s32) XD.plane[0].dequant[1];

                    scale: s32 = 4;

                    if x.source_variance < U32_MAX {
                        VAR_ADJUST := cast(s32) (x.source_variance < 16);
                        scale -= VAR_ADJUST;
                    }
                    if ref_frame > 0 && (distortion2 * cast(s64) scale) < cast,no_check(s64) (qstep * qstep) {
                        early_term = 1;
                    }
                }
            }
        }

        if disable_skip == 0 && ref_frame != 0 {
            single_rate: s64 = ---;
            hybrid_rate: s64 = ---;

            if CM.reference_mode == cast,no_check(u32) REFERENCE_MODE_SELECT {
                single_rate = cast,no_check(s64) (rate2 - compmode_cost);
                hybrid_rate = cast,no_check(s64) rate2;
            } else {
                single_rate = cast,no_check(s64) rate2;
                hybrid_rate = cast,no_check(s64) (rate2 + compmode_cost);
            }

            single_rd :=
                (((single_rate * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                    distortion2 << ((x.rddiv) & 63);
            hybrid_rd :=
                (((hybrid_rate * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                    distortion2 << ((x.rddiv) & 63);

            if comp_pred == 0 {
                if single_rd < best_pred_rd[SINGLE_REFERENCE] {
                    best_pred_rd[SINGLE_REFERENCE] = single_rd;
                }
            } else if single_rd < best_pred_rd[COMPOUND_REFERENCE] {
                best_pred_rd[COMPOUND_REFERENCE] = single_rd;
            }
            if hybrid_rd < best_pred_rd[REFERENCE_MODE_SELECT] {
                best_pred_rd[REFERENCE_MODE_SELECT] = hybrid_rd;
            }

            if mode_excluded == 0 && CM.interp_filter != 3 {
                ref := filter_cache[(ifx CM.interp_filter == 4 then 3 else cast,no_check(s32) CM.interp_filter)];

                i = 0;
                while i < 3 + 1 {
                    adj_rd: s64 = ifx ref == 9223372036854775807
                        then cast(s64) 0
                        else ifx filter_cache[i] == 9223372036854775807
                            then mask_filter - ref + 10
                            else filter_cache[i] - ref;

                    adj_rd += this_rd;
                    best_filter_rd[i] = ifx best_filter_rd[i] < adj_rd then best_filter_rd[i] else adj_rd;
                    i += 1;
                }
            }
        }

        if early_term != 0 {
            break;
        }

        if x.skip != 0 && comp_pred == 0 {
            break;
        }
        midx += 1;
    }

    if best_mbmode.mode == 13 {
        REFS := MV_REFERENCE_FRAME.[ best_mbmode.ref_frame[0], best_mbmode.ref_frame[1] ];
        comp_pred_mode := cast(s32) (REFS[1] > 0);

        if frame_mv[10][REFS[0]].as_int == best_mbmode.mv[0].as_int &&
            (comp_pred_mode != 0 && frame_mv[10][REFS[1]].as_int == best_mbmode.mv[1].as_int || comp_pred_mode == 0) {
            best_mbmode.mode = 10;
        } else if frame_mv[11][REFS[0]].as_int == best_mbmode.mv[0].as_int &&
            (comp_pred_mode != 0 && frame_mv[11][REFS[1]].as_int == best_mbmode.mv[1].as_int || comp_pred_mode == 0) {
            best_mbmode.mode = 11;
        } else if best_mbmode.mv[0].as_int == 0 && (comp_pred_mode != 0 && best_mbmode.mv[1].as_int == 0 || comp_pred_mode == 0) {
            best_mbmode.mode = 12;
        }
    }

    if best_mode_index < 0 || best_rd >= best_rd_so_far {
        if bsize == 3 {
            assignment_3: MODE_INFO = XD.mi[0].*;
            ((*ctx.mic).*) = assignment_3;
        }
        rd_cost.rate = 2147483647;
        rd_cost.rdcost = 9223372036854775807;
        return;
    }

    if SF.use_uv_intra_rd_estimate != 0 {
        if best_mbmode.ref_frame[0] == 0 {
            assignment_4: MODE_INFO = best_mbmode;
            ((MI).*) = assignment_4;
            uv_tx_size := get_uv_tx_size_in_vp9_rdopt(MI, XD.plane.data + 1);
            rd_pick_intra_sbuv_mode(
                cpi,
                x,
                ctx,
                rate_uv_intra.data + uv_tx_size,
                rate_uv_tokenonly.data + uv_tx_size,
                dist_uv.data + uv_tx_size,
                skip_uv.data + uv_tx_size,
                cast,no_check(BLOCK_SIZE) ((ifx bsize < 3 then 3 else cast,no_check(s32) bsize)),
                uv_tx_size
            );
        }
    }

    if cpi.rc.is_src_frame_alt_ref == 0 {
        vp9_update_rd_thresh_fact(
            tile_data.thresh_freq_fact.data,
            SF.adaptive_rd_thresh,
            cast,no_check(s32) bsize,
            best_mode_index
        );
    }

    assignment_5: MODE_INFO = best_mbmode;
    ((MI).*) = assignment_5;
    x.skip |= best_skip2;

    i = 0;
    while i < REFERENCE_MODES {
        if best_pred_rd[i] == 9223372036854775807 {
            best_pred_diff[i] = cast,no_check(s64) (-2147483647 - 1);
        } else {
            best_pred_diff[i] = best_rd - best_pred_rd[i];
        }
        i += 1;
    }

    if x.skip == 0 {
        i = 0;
        while i < 3 + 1 {
            if best_filter_rd[i] == 9223372036854775807 {
                best_filter_diff[i] = 0;
            } else {
                best_filter_diff[i] = best_rd - best_filter_rd[i];
            }
            i += 1;
        }
        if CM.interp_filter == 4 {
        }
    } else {
        fill_memory(*best_filter_diff, 0, best_filter_diff.count * size_of(s64));
    }

    x.skip |= best_mode_skippable;

    if x.skip == 0 && x.select_tx_size == 0 {
        has_high_freq_coeff: s32 = 0;

        max_plane := (ifx is_inter_block_in_vp9_rdopt(XD.mi[0]) != 0 then cast(s32) 3 else 1);
        plane: s32 = 0;
        while plane < max_plane {
            x.plane[plane].eobs = ctx.eobs_pbuf[plane][1];
            has_high_freq_coeff |= vp9_has_high_freq_in_plane(x, bsize, plane);
            plane += 1;
        }

        plane = max_plane;
        while plane < 3 {
            x.plane[plane].eobs = ctx.eobs_pbuf[plane][2];
            has_high_freq_coeff |= vp9_has_high_freq_in_plane(x, bsize, plane);
            plane += 1;
        }

        best_mode_skippable |= cast(s32) (has_high_freq_coeff == 0);
    }

    store_coding_context(x, ctx, best_mode_index, best_pred_diff.data, best_filter_diff.data, best_mode_skippable);
}

store_coding_context :: (
    x: *MACROBLOCK,
    ctx: *PICK_MODE_CONTEXT,
    mode_index: s32,
    comp_pred_diff: *s64,
    best_filter_diff: *s64,
    skippable: s32
) {
    XD := *x.e_mbd;

    ctx.skip = x.skip;
    ctx.skippable = skippable;
    ctx.best_mode_index = mode_index;
    assignment_6: MODE_INFO = XD.mi[0].*;
    ((*ctx.mic).*) = assignment_6;
    assignment_7: MB_MODE_INFO_EXT = x.mbmi_ext.*;
    ((*ctx.mbmi_ext).*) = assignment_7;
    ctx.single_pred_diff = cast,no_check(s32) comp_pred_diff[SINGLE_REFERENCE];
    ctx.comp_pred_diff = cast,no_check(s32) comp_pred_diff[COMPOUND_REFERENCE];
    ctx.hybrid_pred_diff = cast,no_check(s32) comp_pred_diff[REFERENCE_MODE_SELECT];

    copy_memory(ctx.best_filter_diff.data, best_filter_diff, size_of(s64) * cast,no_check(u64) (3 + 1));
}

rd_variance_adjustment :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    bsize: BLOCK_SIZE,
    this_rd: *s64,
    recon: *Buf_2d,
    ref_frame: MV_REFERENCE_FRAME,
    second_ref_frame: MV_REFERENCE_FRAME,
    this_mode: PREDICTION_MODE
) {
    XD := *x.e_mbd;

    var_diff: u32 = 0;
    var_factor: u32 = 0;

    low_var_thresh: u32 = 250;
    BW := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize];
    BH := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize];
    content_type := cpi.oxcf.content;

    if this_rd.* == 9223372036854775807 {
        return;
    }

    rec_variance := vp9_get_sby_variance(cpi, recon, bsize);
    src_variance := vp9_get_sby_variance(cpi, *x.plane[0].src, bsize);

    rec_variance /= cast,no_check(u32) (BW * BH);
    src_variance /= cast,no_check(u32) (BW * BH);

    if content_type == cast,no_check(u32) VP9E_CONTENT_FILM {
        if cpi.oxcf.pass == 2 {
            noise_factor := (cast,no_check(float64) cpi.twopass.gf_group.group_noise_energy) / 250.0;
            low_var_thresh = cast,no_check(u32) (low_var_thresh * noise_factor);

            if ref_frame == 0 {
                low_var_thresh *= 2;
                if this_mode == 0 {
                    low_var_thresh *= 5;
                }
            } else if second_ref_frame > 0 {
                low_var_thresh *= 2;
            }
        }
    } else {
        low_var_thresh = cast,no_check(u32) (250 / 2);
    }

    src_rec_min := min(src_variance, rec_variance);

    if src_rec_min > low_var_thresh {
        return;
    }

    var_diff =
        ifx src_variance > rec_variance then (src_variance - rec_variance) *
            2 else (rec_variance - src_variance) / 2;

    adj_max := max_var_adjust[content_type];

    var_factor = (cast,no_check(u32) (250 * cast(s64) var_diff)) / (ifx 1 > src_variance then 1 else src_variance);
    var_factor = min(adj_max, var_factor);

    if content_type == cast,no_check(u32) VP9E_CONTENT_FILM && (ref_frame == 0 || second_ref_frame > 0) {
        var_factor *= 2;
    }

    this_rd.* += (this_rd.* * cast(s64) var_factor) / 100;
}

handle_inter_mode :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    bsize: BLOCK_SIZE,
    rate2: *s32,
    distortion: *s64,
    skippable: *s32,
    rate_y: *s32,
    rate_uv: *s32,
    recon: *Buf_2d,
    disable_skip: *s32,
    mode_mv: *[4] Int_Mv,
    mi_row: s32,
    mi_col: s32,
    single_newmv: *Int_Mv,
    single_filter: *[4] INTERP_FILTER,
    single_skippable: *[4] s32,
    single_mode_rate: *s32,
    psse: *s64,
    REF_BEST_RD: s64,
    mask_filter: *s64,
    filter_cache: *s64,
    best_mode_index: s32
) -> s64 {
    cm := *cpi.common;
    xd := *x.e_mbd;
    mi := xd.mi[0];
    MBMI_EXT := x.mbmi_ext;
    IS_COMP_PRED := has_second_ref_in_vp9_rdopt(mi);
    THIS_MODE := cast,no_check(s32) mi.mode;
    frame_mv := mode_mv[THIS_MODE].data;

    refs :=
        s32.[ cast,no_check(s32) mi.ref_frame[0], (ifx mi.ref_frame[1] < 0 then 0 else cast,no_check(s32) mi.ref_frame[1]) ];
    cur_mv: [2] Int_Mv = ---;

    tmp_buf: [12288] u8 = --- #align 16;

    rd: s64 = ---;
    tmp_rd: s64 = 9223372036854775807;
    best_rd: s64 = 9223372036854775807;
    best_needs_copy: s32 = 0;
    orig_dst: [3] *u8 = ---;
    orig_dst_stride: [3] s32 = ---;
    rs: s32 = 0;
    best_filter: INTERP_FILTER = 4;
    skip_txfm: [12] u8;
    bsse: [12] s64;

    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    BLK_PARITY :=
        ((mi_row + mi_col) >> ((BSL) & 31) +
            get_chessboard_index_in_vp9_rdopt(cast,no_check(s32) cm.current_video_frame)) & 0x1;
    PRED_FILTER_SEARCH := cast(s32) (cpi.sf.cb_pred_filter_search >= 2 && BLK_PARITY != 0);

    skip_txfm_sb: s32 = 0;
    skip_sse_sb: s64 = 9223372036854775807;
    distortion_y: s64 = 0;
    distortion_uv: s64 = 0;

    if PRED_FILTER_SEARCH != 0 {
        af: INTERP_FILTER = 4;
        lf: INTERP_FILTER = 4;
        if xd.above_mi != null && is_inter_block_in_vp9_rdopt(xd.above_mi) != 0 {
            af = xd.above_mi.interp_filter;
        }
        if xd.left_mi != null && is_inter_block_in_vp9_rdopt(xd.left_mi) != 0 {
            lf = xd.left_mi.interp_filter;
        }

        if THIS_MODE != 13 || af == lf {
            best_filter = af;
        }
    }

    if IS_COMP_PRED != 0 {
        if frame_mv[refs[0]].as_int == 0x80008000 || frame_mv[refs[1]].as_int == 0x80008000 {
            return 9223372036854775807;
        }

        if cpi.sf.adaptive_mode_search != 0 {
            if single_filter[THIS_MODE][refs[0]] == single_filter[THIS_MODE][refs[1]] {
                best_filter = single_filter[THIS_MODE][refs[0]];
            }
        }
    }

    if THIS_MODE == 13 {
        rate_mv: s32 = ---;
        if IS_COMP_PRED != 0 {
            NUM_JOINT_SEARCH_ITERS := get_joint_search_iters(cpi.sf.comp_inter_joint_search_iter_level, bsize);

            frame_mv[refs[0]].as_int = single_newmv[refs[0]].as_int;
            frame_mv[refs[1]].as_int = single_newmv[refs[1]].as_int;

            if NUM_JOINT_SEARCH_ITERS != 0 {
                joint_motion_search(
                    cpi,
                    x,
                    bsize,
                    frame_mv,
                    mi_row,
                    mi_col,
                    single_newmv,
                    *rate_mv,
                    NUM_JOINT_SEARCH_ITERS
                );
            } else {
                rate_mv =
                    vp9_mv_bit_cost(
                        *frame_mv[refs[0]].as_mv,
                        *x.mbmi_ext.ref_mvs[refs[0]][0].as_mv,
                        x.nmvjointcost.data,
                        x.mvcost,
                        108
                    );
                rate_mv +=
                    vp9_mv_bit_cost(
                        *frame_mv[refs[1]].as_mv,
                        *x.mbmi_ext.ref_mvs[refs[1]][0].as_mv,
                        x.nmvjointcost.data,
                        x.mvcost,
                        108
                    );
            }
            rate2.* += rate_mv;
        } else {
            tmp_mv: Int_Mv = ---;

            single_motion_search(cpi, x, bsize, mi_row, mi_col, *tmp_mv, *rate_mv);

            if tmp_mv.as_int == 0x80008000 {
                return 9223372036854775807;
            }

            xd.mi[0].bmi[0].as_mv[0].as_int = tmp_mv.as_int;
            frame_mv[refs[0]].as_int = xd.mi[0].bmi[0].as_mv[0].as_int;
            single_newmv[refs[0]].as_int = tmp_mv.as_int;

            if discount_newmv_test(cpi, THIS_MODE, tmp_mv, mode_mv, refs[0], mi_row, mi_col, bsize) != 0 {
                rate2.* += (ifx rate_mv / 8 > 1 then rate_mv / 8 else 1);
            } else {
                rate2.* += rate_mv;
            }
        }
    }

    i: s32 = 0;
    while i < IS_COMP_PRED + 1 {
        cur_mv[i] = frame_mv[refs[i]];

        if THIS_MODE != 13 {
            clamp_mv2_in_vp9_rdopt(*cur_mv[i].as_mv, xd);
        }

        if mv_check_bounds(*x.mv_limits, *cur_mv[i].as_mv) != 0 {
            return 9223372036854775807;
        }
        mi.mv[i].as_int = cur_mv[i].as_int;
        i += 1;
    }

    i = 0;
    while i < 3 {
        orig_dst[i] = xd.plane[i].dst.buf;
        orig_dst_stride[i] = xd.plane[i].dst.stride;
        i += 1;
    }

    if discount_newmv_test(cpi, THIS_MODE, frame_mv[refs[0]], mode_mv, refs[0], mi_row, mi_col, bsize) != 0 {
        rate2.* +=
            (ifx cost_mv_ref(
                cpi,
                cast,no_check(PREDICTION_MODE) THIS_MODE,
                cast,no_check(s32) MBMI_EXT.mode_context[refs[0]]
            ) < cost_mv_ref(cpi, 10, cast,no_check(s32) MBMI_EXT.mode_context[refs[0]]) then cost_mv_ref(
                cpi,
                cast,no_check(PREDICTION_MODE) THIS_MODE,
                cast,no_check(s32) MBMI_EXT.mode_context[refs[0]]
            ) else cost_mv_ref(cpi, 10, cast,no_check(s32) MBMI_EXT.mode_context[refs[0]]));
    } else {
        rate2.* +=
            cost_mv_ref(
                cpi,
                cast,no_check(PREDICTION_MODE) THIS_MODE,
                cast,no_check(s32) MBMI_EXT.mode_context[refs[0]]
            );
    }

    if IS_COMP_PRED == 0 && cpi.sf.prune_single_mode_based_on_mv_diff_mode_rate != 0 {
        single_mode_rate[THIS_MODE - 10] = rate2.*;

        if skip_single_mode_based_on_mode_rate(mode_mv, single_mode_rate, THIS_MODE, refs[0], rate2.*, best_mode_index) != 0 {
            return 9223372036854775807;
        }
    }
    if (((((cast,no_check(s64) rate2.*) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + cast(s64) ((cast(s32) 0) << ((x.rddiv) & 31))) > REF_BEST_RD &&
        mi.mode != 10 {
        return 9223372036854775807;
    }

    intpel_mv := cast(s32) (mv_has_subpel(*mi.mv[0].as_mv) == 0);
    if IS_COMP_PRED != 0 {
        intpel_mv &= cast(s32) (mv_has_subpel(*mi.mv[1].as_mv) == 0);
    }

    i = 0;
    while i < 3 + 1 {
        filter_cache[i] = 9223372036854775807;
        i += 1;
    }

    if cm.interp_filter != 3 {
        ENABLE_INTERP_SEARCH := (ifx cpi.sf.cb_pred_filter_search != 0 && cm.interp_filter != 4 then BLK_PARITY else 1);
        if x.source_variance < cpi.sf.disable_filter_search_var_thresh {
            best_filter = 0;
        } else if best_filter == 4 && ENABLE_INTERP_SEARCH != 0 {
            tmp_rate_sum: s32 = 0;
            tmp_dist_sum: s64 = 0;

            i = 0;
            while i < 3 {
                tmp_skip_sb: s32 = 0;
                tmp_skip_sse: s64 = 9223372036854775807;
                ENABLE_EARLYTERM :=
                    cast(s32) (cpi.sf.early_term_interp_search_plane_rd != 0 &&
                        cast,no_check(s32) cm.interp_filter != i);
                filt_best_rd: s64 = ---;

                mi.interp_filter = cast,no_check(INTERP_FILTER) i;
                rs = vp9_get_switchable_rate(cpi, xd);
                rs_rd :=
                    ((((cast,no_check(s64) rs) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                        cast(s64) ((cast(s32) 0) << ((x.rddiv) & 31));

                if i > 0 && intpel_mv != 0 {
                    rd =
                        ((((cast,no_check(s64) tmp_rate_sum) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                            tmp_dist_sum << ((x.rddiv) & 63);
                    filter_cache[i] = rd;
                    filter_cache[3] = ifx filter_cache[3] < rd + rs_rd then filter_cache[3] else rd + rs_rd;
                    if cm.interp_filter == 4 {
                        rd += rs_rd;
                    }
                    mask_filter.* = max(mask_filter.*, rd);
                } else {
                    rate_sum: s32 = 0;
                    dist_sum: s64 = 0;
                    if i > 0 &&
                        cpi.sf.adaptive_interp_filter_search != 0 &&
                        cpi.sf.interp_filter_search_mask & cast,no_check(u32) ((cast(s32) 1) << ((i) & 31)) != 0 {
                        rate_sum = 2147483647;
                        dist_sum = 9223372036854775807;
                        i += 1;
                        continue;
                    }

                    if cm.interp_filter == 4 && (i == 0 || best_needs_copy != 0) ||
                        cm.interp_filter != 4 && (cm.interp_filter == mi.interp_filter || i == 0 && intpel_mv != 0) {
                        restore_dst_buf(xd, orig_dst.data, orig_dst_stride.data);
                    } else {
                        for j: 0..cast(s32) 3 - 1 {
                            xd.plane[j].dst.buf = tmp_buf.data + j * 64 * 64;
                            xd.plane[j].dst.stride = 64;
                        }
                    }

                    filt_best_rd = ifx cm.interp_filter == 4 then best_rd - rs_rd else best_rd;
                    if build_inter_pred_model_rd_earlyterm(
                        cpi,
                        mi_row,
                        mi_col,
                        bsize,
                        x,
                        xd,
                        *rate_sum,
                        *dist_sum,
                        *tmp_skip_sb,
                        *tmp_skip_sse,
                        ENABLE_EARLYTERM,
                        filt_best_rd
                    ) != 0 {
                        filter_cache[i] = 9223372036854775807;
                        i += 1;
                        continue;
                    }

                    rd =
                        ((((cast,no_check(s64) rate_sum) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                            dist_sum << ((x.rddiv) & 63);
                    filter_cache[i] = rd;
                    filter_cache[3] = ifx filter_cache[3] < rd + rs_rd then filter_cache[3] else rd + rs_rd;
                    if cm.interp_filter == 4 {
                        rd += rs_rd;
                    }
                    mask_filter.* = max(mask_filter.*, rd);

                    if i == 0 && intpel_mv != 0 {
                        tmp_rate_sum = rate_sum;
                        tmp_dist_sum = dist_sum;
                    }
                }

                if i == 0 && cpi.sf.use_rd_breakout != 0 && REF_BEST_RD < 9223372036854775807 {
                    if (rd / 2) > REF_BEST_RD {
                        restore_dst_buf(xd, orig_dst.data, orig_dst_stride.data);
                        return 9223372036854775807;
                    }
                }
                newbest := cast(s32) (i == 0 || rd < best_rd);

                if newbest != 0 {
                    best_rd = rd;
                    best_filter = mi.interp_filter;
                    if cm.interp_filter == 4 && i != 0 && intpel_mv == 0 {
                        best_needs_copy = cast(s32) (best_needs_copy == 0);
                    }
                }

                if cm.interp_filter == 4 && newbest != 0 || cm.interp_filter != 4 && cm.interp_filter == mi.interp_filter {
                    tmp_rd = best_rd;

                    skip_txfm_sb = tmp_skip_sb;
                    skip_sse_sb = tmp_skip_sse;
                    copy_memory(skip_txfm.data, x.skip_txfm.data, skip_txfm.count);
                    copy_memory(bsse.data, x.bsse.data, bsse.count * size_of(s64));
                }
                i += 1;
            }
            restore_dst_buf(xd, orig_dst.data, orig_dst_stride.data);
        }
    }

    mi.interp_filter =
        cast,no_check(INTERP_FILTER) ((ifx cm.interp_filter != 4 then cast,no_check(s32) cm.interp_filter else cast,no_check(s32) best_filter));
    rs = ifx cm.interp_filter == 4 then vp9_get_switchable_rate(cpi, xd) else 0;

    if tmp_rd != 9223372036854775807 {
        if best_needs_copy != 0 {
            i = 0;
            while i < 3 {
                xd.plane[i].dst.buf = tmp_buf.data + i * 64 * 64;
                xd.plane[i].dst.stride = 64;
                i += 1;
            }
        }
        rd =
            (tmp_rd + (((cast,no_check(s64) rs) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                cast(s64) ((cast(s32) 0) << ((x.rddiv) & 31));
    } else {
        tmp_rate: s32 = ---;
        tmp_dist: s64 = ---;

        build_inter_pred_model_rd_earlyterm(
            cpi,
            mi_row,
            mi_col,
            bsize,
            x,
            xd,
            *tmp_rate,
            *tmp_dist,
            *skip_txfm_sb,
            *skip_sse_sb,
            0,
            9223372036854775807
        );
        rd =
            ((((cast,no_check(s64) (rs + tmp_rate)) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                tmp_dist << ((x.rddiv) & 63);
        copy_memory(skip_txfm.data, x.skip_txfm.data, skip_txfm.count);
        copy_memory(bsse.data, x.bsse.data, bsse.count * size_of(s64));
    }

    if IS_COMP_PRED == 0 {
        single_filter[THIS_MODE][refs[0]] = mi.interp_filter;
    }

    if cpi.sf.adaptive_mode_search != 0 {
        if IS_COMP_PRED != 0 {
            if single_skippable[THIS_MODE][refs[0]] != 0 && single_skippable[THIS_MODE][refs[1]] != 0 {
                fill_memory(skip_txfm.data, 1, skip_txfm.count);
            }
        }
    }

    if cpi.sf.use_rd_breakout != 0 && REF_BEST_RD < 9223372036854775807 {
        if (rd / 2) > REF_BEST_RD {
            restore_dst_buf(xd, orig_dst.data, orig_dst_stride.data);
            return 9223372036854775807;
        }
    }

    if cm.interp_filter == 4 {
        rate2.* += rs;
    }

    copy_memory(x.skip_txfm.data, skip_txfm.data, skip_txfm.count);
    copy_memory(x.bsse.data, bsse.data, bsse.count * size_of(s64));

    if skip_txfm_sb == 0 || xd.lossless != 0 {
        skippable_y, skippable_uv: s32 = ---;
        sseuv: s64 = 9223372036854775807;
        rdcosty: s64 = 9223372036854775807;

        vp9_subtract_plane(x, bsize, 0);
        super_block_yrd(cpi, x, rate_y, *distortion_y, *skippable_y, psse, bsize, REF_BEST_RD, recon);

        if rate_y.* == 2147483647 {
            rate2.* = 2147483647;
            distortion.* = 9223372036854775807;
            restore_dst_buf(xd, orig_dst.data, orig_dst_stride.data);
            return 9223372036854775807;
        }

        rate2.* += rate_y.*;
        distortion.* += distortion_y;

        rdcosty =
            ((((cast,no_check(s64) rate2.*) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                distortion.* << ((x.rddiv) & 63);
        rdcosty =
            ifx rdcosty < (((0 * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                psse.* << ((x.rddiv) & 63) then rdcosty else (((0 * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + psse.* << ((x.rddiv) & 63);

        if super_block_uvrd(cpi, x, rate_uv, *distortion_uv, *skippable_uv, *sseuv, bsize, REF_BEST_RD - rdcosty) == 0 {
            rate2.* = 2147483647;
            distortion.* = 9223372036854775807;
            restore_dst_buf(xd, orig_dst.data, orig_dst_stride.data);
            return 9223372036854775807;
        }

        psse.* += sseuv;
        rate2.* += rate_uv.*;
        distortion.* += distortion_uv;
        skippable.* = cast(s32) (skippable_y != 0 && skippable_uv != 0);
    } else {
        x.skip = 1;
        disable_skip.* = 1;

        rate2.* += cast,no_check(s32) (VP9_PROB_COST[(256 - cast(s32) vp9_get_skip_prob_in_vp9_rdopt(cm, xd))]);

        distortion.* = skip_sse_sb;
    }

    if IS_COMP_PRED == 0 {
        single_skippable[THIS_MODE][refs[0]] = skippable.*;
    }

    restore_dst_buf(xd, orig_dst.data, orig_dst_stride.data);
    return 0;
}

restore_dst_buf :: (xd: *MACROBLOCKD, orig_dst: **u8, orig_dst_stride: *s32) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dst.buf = orig_dst[i];
        xd.plane[i].dst.stride = orig_dst_stride[i];
    }
}

build_inter_pred_model_rd_earlyterm :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE,
    x: *MACROBLOCK,
    xd: *MACROBLOCKD,
    out_rate_sum: *s32,
    out_dist_sum: *s64,
    skip_txfm_sb: *s32,
    skip_sse_sb: *s64,
    do_earlyterm: s32,
    best_rd: s64
) -> s32 {
    rate_sum: s64 = 0;
    dist_sum: s64 = 0;
    REF := cast,no_check(s32) xd.mi[0].ref_frame[0];
    sse: u32 = ---;
    var: u32 = 0;
    total_sse: s64 = 0;
    skip_flag: s32 = 1;
    SHIFT: s32 = 6;
    DEQUANT_SHIFT: s32 = 3;

    x.pred_sse[REF] = 0;

    for i: 0..cast(s32) 3 - 1 {
        P := x.plane.data + i;
        PD := xd.plane.data + i;
        BS := get_plane_block_size_in_vp9_rdopt(bsize, PD);
        MAX_TX_SIZE := MAX_TXSIZE_LOOKUP[BS];
        UNIT_SIZE := TXSIZE_TO_BSIZE[MAX_TX_SIZE];
        DC_THR := P.quant_thred[0] >> ((SHIFT) & 63);
        AC_THR := P.quant_thred[1] >> ((SHIFT) & 63);
        sum_sse: u32 = 0;

        LOW_DC_THR := (ifx 50 < DC_THR >> 2 then 50 else DC_THR >> 2);
        LOW_AC_THR := (ifx 80 < AC_THR >> 2 then 80 else AC_THR >> 2);
        bw :=
            (cast(s32) 1) << ((((cast(s32) B_WIDTH_LOG2_LOOKUP[BS]) -
                cast(s32) B_WIDTH_LOG2_LOOKUP[UNIT_SIZE])) & 31);
        bh :=
            (cast(s32) 1) << ((((cast(s32) B_HEIGHT_LOG2_LOOKUP[BS]) -
                cast(s32) B_WIDTH_LOG2_LOOKUP[UNIT_SIZE])) & 31);
        idx: s32 = ---;
        lw := (cast(s32) B_WIDTH_LOG2_LOOKUP[UNIT_SIZE]) + 2;
        lh := (cast(s32) B_HEIGHT_LOG2_LOOKUP[UNIT_SIZE]) + 2;

        dist: s64 = 0;

        vp9_build_inter_predictors_sbp(xd, mi_row, mi_col, bsize, i);

        if 0 < bh {
            for idy: 0..bh - 1 {
                idx = 0;
                while idx < bw {
                    src := P.src.buf + (idy * P.src.stride) << ((lh) & 31) + idx << ((lw) & 31);
                    dst := PD.dst.buf + (idy * PD.dst.stride) << ((lh) & 31) + idx << ((lh) & 31);
                    block_idx := idy << 1 + idx;
                    low_err_skip: s32 = 0;

                    var = cpi.fn_ptr[UNIT_SIZE].vf(src, P.src.stride, dst, PD.dst.stride, *sse);
                    x.bsse[i << 2 + block_idx] = cast,no_check(s64) sse;
                    sum_sse += sse;

                    x.skip_txfm[i << 2 + block_idx] = 0;
                    if x.select_tx_size == 0 {
                        if cast,no_check(s64) var < AC_THR || var == 0 {
                            x.skip_txfm[i << 2 + block_idx] = 2;

                            if cast,no_check(s64) (sse - var) < DC_THR || sse == var {
                                x.skip_txfm[i << 2 + block_idx] = 1;

                                if sse == 0 || cast,no_check(s64) var < LOW_AC_THR && cast,no_check(s64) (sse - var) < LOW_DC_THR {
                                    low_err_skip = 1;
                                }
                            }
                        }
                    }

                    if skip_flag != 0 && low_err_skip == 0 {
                        skip_flag = 0;
                    }

                    if i == 0 {
                        x.pred_sse[REF] += sse;
                    }
                    idx += 1;
                }
            }
        }

        total_sse += cast,no_check(s64) sum_sse;
        qstep := cast,no_check(u32) ((cast(s32) PD.dequant[1]) >> ((DEQUANT_SHIFT) & 31));
        nlog2 := cast,no_check(u32) NUM_PELS_LOG2_LOOKUP[BS];

        if cpi.sf.simple_model_rd_from_var != 0 {
            rate: s64 = ifx qstep < 120
                then ((cast,no_check(s64) sum_sse) * cast(s64) (280 - qstep)) >> (((16 - 9)) & 63)
                else 0;
            dist = ((cast,no_check(s64) sum_sse) * cast(s64) qstep) >> 8;
            rate_sum += rate;
        } else {
            rate: s32 = ---;
            vp9_model_rd_from_var_lapndz(sum_sse, nlog2, qstep, *rate, *dist);
            rate_sum += cast,no_check(s64) rate;
        }
        dist_sum += dist;
        if do_earlyterm != 0 {
            if ((((rate_sum * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + dist_sum << 4 << ((x.rddiv) & 63)) >= best_rd {
                return 1;
            }
        }
    }
    skip_txfm_sb.* = skip_flag;
    skip_sse_sb.* = total_sse << 4;
    out_rate_sum.* = cast,no_check(s32) rate_sum;
    out_dist_sum.* = dist_sum << 4;

    return 0;
}

mv_has_subpel :: (mv: *MV) -> s32 {
    if mv.row & 0xf != 0 || mv.col & 0xf != 0 {
        return 1;
    }
    return 0;
}

skip_single_mode_based_on_mode_rate :: (
    mode_mv: *[4] Int_Mv,
    single_mode_rate: *s32,
    this_mode: s32,
    ref0: s32,
    this_mode_rate: s32,
    best_mode_index: s32
) -> s32 {
    this_mv := mode_mv[this_mode][ref0].as_mv;
    MV_THRESH: s32 = 3;

    if this_mode == 10 || this_mode == 13 {
        return 0;
    }

    if best_mode_index > 0 && ref0 == cast,no_check(s32) VP9_MODE_ORDER[best_mode_index].ref_frame[0] {
        return 0;
    }

    if compare_mv_mode_rate(this_mv, mode_mv[10][ref0].as_mv, this_mode_rate, single_mode_rate[10 - 10], MV_THRESH) != 0 {
        return 1;
    }

    if compare_mv_mode_rate(this_mv, mode_mv[13][ref0].as_mv, this_mode_rate, single_mode_rate[13 - 10], MV_THRESH) != 0 {
        return 1;
    }

    if this_mode == 11 {
        return 0;
    }

    if compare_mv_mode_rate(this_mv, mode_mv[11][ref0].as_mv, this_mode_rate, single_mode_rate[11 - 10], MV_THRESH) != 0 {
        return 1;
    }
    return 0;
}

compare_mv_mode_rate :: (this_mv: MV, mode_mv: MV, this_mode_rate: s32, mode_rate: s32, mv_thresh: s32) -> s32 {
    MV_DIFF :=
        absolute_value((cast(s32) mode_mv.col) - cast(s32) this_mv.col) +
            absolute_value((cast(s32) mode_mv.row) - cast(s32) this_mv.row);
    if MV_DIFF <= mv_thresh && mode_rate < this_mode_rate {
        return 1;
    }
    return 0;
}

cost_mv_ref :: (cpi: *VP9_COMP_in_vp9_encoder, mode: PREDICTION_MODE, mode_context: s32) -> s32 {
    return cast,no_check(s32) cpi.inter_mode_cost[mode_context][(cast(s32) mode) - 10];
}

discount_newmv_test :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    this_mode: s32,
    this_mv: Int_Mv,
    mode_mv: *[4] Int_Mv,
    ref_frame: s32,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE
) -> s32 {
    if cpi.rc.is_src_frame_alt_ref == 0 &&
        this_mode == 13 &&
        this_mv.as_int != 0 &&
        (mode_mv[10][ref_frame].as_int == 0 || mode_mv[10][ref_frame].as_int == 0x80008000) &&
        (mode_mv[11][ref_frame].as_int == 0 || mode_mv[11][ref_frame].as_int == 0x80008000) {
        return 1;
    }
    return 0;
}

mv_check_bounds :: (mv_limits: *Mv_Limits, mv: *MV) -> s32 {
    if (cast(s32) mv.row) >> 3 < mv_limits.row_min ||
        (cast(s32) mv.row) >> 3 > mv_limits.row_max ||
        (cast(s32) mv.col) >> 3 < mv_limits.col_min ||
        (cast(s32) mv.col) >> 3 > mv_limits.col_max {
        return 1;
    }
    return 0;
}

single_motion_search :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    bsize: BLOCK_SIZE,
    mi_row: s32,
    mi_col: s32,
    tmp_mv: *Int_Mv,
    rate_mv: *s32
) {
    xd := *x.e_mbd;
    cm := *cpi.common;
    mi := xd.mi[0];
    backup_yv12: [3] Buf_2d;

    mvp_full: MV = ---;
    ref := cast,no_check(s32) mi.ref_frame[0];
    ref_mv := x.mbmi_ext.ref_mvs[ref][0].as_mv;
    TMP_MV_LIMITS := x.mv_limits;
    cost_list: [5] s32 = ---;
    BEST_PREDMV_IDX := x.mv_best_ref_index[ref];
    scaled_ref_frame := vp9_get_scaled_ref_frame(cpi, ref);
    PW := (cast(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[bsize]) << 2;
    PH := (cast(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[bsize]) << 2;
    pred_mv: [3] MV = ---;

    bestsme: s32 = 2147483647;

    sadpb := x.sadperbit16;

    pred_mv[0] = x.mbmi_ext.ref_mvs[ref][0].as_mv;
    pred_mv[1] = x.mbmi_ext.ref_mvs[ref][1].as_mv;
    pred_mv[2] = x.pred_mv[ref];

    if scaled_ref_frame != null {
        for i: 0..cast(s32) 3 - 1 {
            backup_yv12[i] = xd.plane[i].pre[0];
        }

        vp9_setup_pre_planes(xd, 0, scaled_ref_frame, mi_row, mi_col, null);
    }

    step_param: s32 = ifx cpi.sf.mv.auto_mv_step_size != 0 && cm.show_frame != 0
        then (vp9_init_search_range(cast,no_check(s32) x.max_mv_context[ref]) + cpi.mv_step_param) / 2
        else cpi.mv_step_param;

    if cpi.sf.adaptive_motion_search != 0 && bsize < 12 {
        BOFFSET :=
            2 *
                ((cast(s32) B_WIDTH_LOG2_LOOKUP[12]) - (ifx B_HEIGHT_LOG2_LOOKUP[bsize] < B_WIDTH_LOG2_LOOKUP[bsize] then cast,no_check(s32) B_HEIGHT_LOG2_LOOKUP[bsize] else cast,no_check(s32) B_WIDTH_LOG2_LOOKUP[bsize]));
        step_param = max(step_param, BOFFSET);
    }

    if cpi.sf.adaptive_motion_search != 0 {
        bwl := cast,no_check(s32) B_WIDTH_LOG2_LOOKUP[bsize];
        bhl := cast,no_check(s32) B_HEIGHT_LOG2_LOOKUP[bsize];
        tlevel := x.pred_mv_sad[ref] >> (((bwl + bhl + 4)) & 31);

        if tlevel < 5 {
            step_param += 2;
        }

        if cpi.oxcf.resize_mode != cast,no_check(u32) RESIZE_DYNAMIC {
            i: s32 = 1;
            while i <= 3 && cm.show_frame != 0 {
                if x.pred_mv_sad[ref] >> 3 > x.pred_mv_sad[i] {
                    x.pred_mv[ref].row = 32767;
                    x.pred_mv[ref].col = 32767;
                    tmp_mv.as_int = 0x80008000;

                    if scaled_ref_frame != null {
                        for j: 0..cast(s32) 3 - 1 {
                            xd.plane[j].pre[0] = backup_yv12[j];
                        }
                    }
                    return;
                }
                i += 1;
            }
        }
    }

    vp9_set_mv_search_range(*x.mv_limits, *ref_mv);

    mvp_full = pred_mv[BEST_PREDMV_IDX];
    c_transpiler_compound_shr(*(mvp_full.col), (cast(s32) 3), s32, s32);
    c_transpiler_compound_shr(*(mvp_full.row), (cast(s32) 3), s32, s32);

    bestsme =
        vp9_full_pixel_search(
            cpi,
            x,
            bsize,
            *mvp_full,
            step_param,
            cast,no_check(s32) cpi.sf.mv.search_method,
            sadpb,
            cond_cost_list_in_vp9_rdopt(cpi, cost_list.data),
            *ref_mv,
            *tmp_mv.as_mv,
            2147483647,
            1
        );

    if cpi.sf.enhanced_full_pixel_motion_search != 0 {
        for i: 0..cast(s32) 3 - 1 {
            this_mv: MV = ---;

            if pred_mv[i].row == 32767 || pred_mv[i].col == 32767 {
                continue;
            }
            if i == BEST_PREDMV_IDX {
                continue;
            }

            diff_row :=
                ((cast,no_check(s32) pred_mv[i].row) -
                    cast(s32) ((pred_mv[(ifx i > 0 then i - 1 else BEST_PREDMV_IDX)]).row)) >> 3;
            diff_col :=
                ((cast,no_check(s32) pred_mv[i].col) -
                    cast(s32) ((pred_mv[(ifx i > 0 then i - 1 else BEST_PREDMV_IDX)]).col)) >> 3;
            if diff_row == 0 && diff_col == 0 {
                continue;
            }
            if diff_row < 0 {
                diff_row = -diff_row;
            }
            if diff_col < 0 {
                diff_col = -diff_col;
            }
            step := get_msb_in_vp9_rdopt(cast,no_check(u32) ((diff_row + diff_col + 1) >> 1));
            if step <= 0 {
                continue;
            }

            mvp_full = pred_mv[i];
            c_transpiler_compound_shr(*(mvp_full.col), (cast(s32) 3), s32, s32);
            c_transpiler_compound_shr(*(mvp_full.row), (cast(s32) 3), s32, s32);

            this_me :=
                vp9_full_pixel_search(
                    cpi,
                    x,
                    bsize,
                    *mvp_full,
                    (ifx step_param > 11 - step then step_param else 11 - step),
                    cast,no_check(s32) cpi.sf.mv.search_method,
                    sadpb,
                    cond_cost_list_in_vp9_rdopt(cpi, cost_list.data),
                    *ref_mv,
                    *this_mv,
                    2147483647,
                    1
                );

            if this_me < bestsme {
                tmp_mv.as_mv = this_mv;
                bestsme = this_me;
            }
        }
    }

    x.mv_limits = TMP_MV_LIMITS;

    if bestsme < 2147483647 {
        dis: u32 = ---;
        cpi.find_fractional_mv_step(
            x,
            *tmp_mv.as_mv,
            *ref_mv,
            cm.allow_high_precision_mv,
            x.errorperbit,
            cpi.fn_ptr.data + bsize,
            cast,no_check(s32) cpi.sf.mv.subpel_force_stop,
            cpi.sf.mv.subpel_search_level,
            cond_cost_list_in_vp9_rdopt(cpi, cost_list.data),
            x.nmvjointcost.data,
            x.mvcost,
            *dis,
            x.pred_sse.data + ref,
            null,
            PW,
            PH,
            cast,no_check(s32) cpi.sf.use_accurate_subpel_search
        );
    }
    rate_mv.* = vp9_mv_bit_cost(*tmp_mv.as_mv, *ref_mv, x.nmvjointcost.data, x.mvcost, 108);

    x.pred_mv[ref] = tmp_mv.as_mv;

    if scaled_ref_frame != null {
        for i: 0..cast(s32) 3 - 1 {
            xd.plane[i].pre[0] = backup_yv12[i];
        }
    }
}

get_joint_search_iters :: (sf_level: s32, bsize: BLOCK_SIZE) -> s32 {
    num_iters: s32 = 4;
    if sf_level >= 2 {
        num_iters = 0;
    } else if sf_level >= 1 {
        num_iters = ifx bsize < 3 then 0 else (ifx bsize <= 6 then cast(s32) 2 else 4);
    }
    return num_iters;
}

joint_motion_search :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    bsize: BLOCK_SIZE,
    frame_mv: *Int_Mv,
    mi_row: s32,
    mi_col: s32,
    single_newmv: *Int_Mv,
    rate_mv: *s32,
    num_iters: s32
) {
    CM := *cpi.common;
    PW := 4 * cast(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[bsize];
    PH := 4 * cast(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[bsize];
    xd := *x.e_mbd;
    mi := xd.mi[0];
    REFS :=
        s32.[ cast,no_check(s32) mi.ref_frame[0], (ifx mi.ref_frame[1] < 0 then 0 else cast,no_check(s32) mi.ref_frame[1]) ];
    ref_mv: [2] Int_Mv = ---;
    iter_mvs: [4] [2] Int_Mv = ---;

    kernel := vp9_filter_kernels[mi.interp_filter];
    sf: Scale_Factors = ---;

    backup_yv12: [2] [3] Buf_2d = ---;
    last_besterr := u32.[ U32_MAX, U32_MAX ];
    SCALED_REF_FRAME :=
        *YV12_BUFFER_CONFIG.[ vp9_get_scaled_ref_frame(cpi, cast,no_check(s32) mi.ref_frame[0]), vp9_get_scaled_ref_frame(cpi, cast,no_check(s32) mi.ref_frame[1]) ];

    second_pred: [4096] u8 = --- #align 32;

    for ref: 0..cast(s32) 2 - 1 {
        ref_mv[ref] = x.mbmi_ext.ref_mvs[REFS[ref]][0];

        if SCALED_REF_FRAME[ref] != null {
            for i: 0..cast(s32) 3 - 1 {
                backup_yv12[ref][i] = xd.plane[i].pre[ref];
            }
            vp9_setup_pre_planes(xd, ref, SCALED_REF_FRAME[ref], mi_row, mi_col, null);
        }

        frame_mv[REFS[ref]].as_int = single_newmv[REFS[ref]].as_int;
        iter_mvs[0][ref].as_int = single_newmv[REFS[ref]].as_int;
    }

    vp9_setup_scale_factors_for_frame(*sf, CM.width, CM.height, CM.width, CM.height);

    if 0 < num_iters {
        for ite: 0..num_iters - 1 {
            ref_yv12: [2] Buf_2d = ---;
            bestsme: u32 = U32_MAX;
            sadpb := x.sadperbit16;
            tmp_mv: MV = ---;
            search_range: s32 = 3;

            TMP_MV_LIMITS := x.mv_limits;
            id := ite % 2;

            if skip_iters(iter_mvs.data, ite, id) != 0 {
                break;
            }

            ref_yv12[0] = xd.plane[0].pre[0];
            ref_yv12[1] = xd.plane[0].pre[1];

            vp9_build_inter_predictor(
                ref_yv12[cast(s32) (id == 0)].buf,
                ref_yv12[cast(s32) (id == 0)].stride,
                second_pred.data,
                PW,
                *frame_mv[REFS[cast(s32) (id == 0)]].as_mv,
                *sf,
                PW,
                PH,
                0,
                kernel,
                cast,no_check(Mv_Precision) MV_PRECISION_Q3,
                mi_col * (cast(s32) 1) << 3,
                mi_row * (cast(s32) 1) << 3
            );

            if id != 0 {
                xd.plane[0].pre[0] = ref_yv12[id];
            }
            vp9_set_mv_search_range(*x.mv_limits, *ref_mv[id].as_mv);

            tmp_mv = frame_mv[REFS[id]].as_mv;

            c_transpiler_compound_shr(*(tmp_mv.col), (cast(s32) 3), s32, s32);
            c_transpiler_compound_shr(*(tmp_mv.row), (cast(s32) 3), s32, s32);

            bestsme =
                cast,no_check(u32) vp9_refining_search_8p_c(
                    x,
                    *tmp_mv,
                    sadpb,
                    search_range,
                    cpi.fn_ptr.data + bsize,
                    *ref_mv[id].as_mv,
                    second_pred.data
                );
            if bestsme < U32_MAX {
                bestsme =
                    cast,no_check(u32) vp9_get_mvpred_av_var(
                        x,
                        *tmp_mv,
                        *ref_mv[id].as_mv,
                        second_pred.data,
                        cpi.fn_ptr.data + bsize,
                        1
                    );
            }

            x.mv_limits = TMP_MV_LIMITS;

            if bestsme < U32_MAX {
                dis: u32 = ---;
                sse: u32 = ---;
                bestsme =
                    cpi.find_fractional_mv_step(
                        x,
                        *tmp_mv,
                        *ref_mv[id].as_mv,
                        cpi.common.allow_high_precision_mv,
                        x.errorperbit,
                        cpi.fn_ptr.data + bsize,
                        0,
                        cpi.sf.mv.subpel_search_level,
                        null,
                        x.nmvjointcost.data,
                        x.mvcost,
                        *dis,
                        *sse,
                        second_pred.data,
                        PW,
                        PH,
                        cast,no_check(s32) cpi.sf.use_accurate_subpel_search
                    );
            }

            if id != 0 {
                xd.plane[0].pre[0] = ref_yv12[0];
            }

            if bestsme < last_besterr[id] {
                frame_mv[REFS[id]].as_mv = tmp_mv;
                last_besterr[id] = bestsme;
            } else {
                break;
            }
            if ite < num_iters - 1 {
                iter_mvs[ite + 1][0].as_int = frame_mv[REFS[0]].as_int;
                iter_mvs[ite + 1][1].as_int = frame_mv[REFS[1]].as_int;
            }
        }
    }

    rate_mv.* = 0;

    for ref: 0..cast(s32) 2 - 1 {
        if SCALED_REF_FRAME[ref] != null {
            for i: 0..cast(s32) 3 - 1 {
                xd.plane[i].pre[ref] = backup_yv12[ref][i];
            }
        }

        rate_mv.* +=
            vp9_mv_bit_cost(
                *frame_mv[REFS[ref]].as_mv,
                *x.mbmi_ext.ref_mvs[REFS[ref]][0].as_mv,
                x.nmvjointcost.data,
                x.mvcost,
                108
            );
    }
}

skip_iters :: (iter_mvs: *[2] Int_Mv, ite: s32, id: s32) -> s32 {
    if ite >= 2 && iter_mvs[ite - 2][cast(s32) (id == 0)].as_int == iter_mvs[ite][cast(s32) (id == 0)].as_int {
        cur_fullpel_mv, prev_fullpel_mv: Int_Mv = ---;
        cur_fullpel_mv.as_mv.row = cast,no_check(s16) ((cast(s32) iter_mvs[ite][id].as_mv.row) >> 3);
        cur_fullpel_mv.as_mv.col = cast,no_check(s16) ((cast(s32) iter_mvs[ite][id].as_mv.col) >> 3);
        prev_fullpel_mv.as_mv.row = cast,no_check(s16) ((cast(s32) iter_mvs[ite - 2][id].as_mv.row) >> 3);
        prev_fullpel_mv.as_mv.col = cast,no_check(s16) ((cast(s32) iter_mvs[ite - 2][id].as_mv.col) >> 3);
        if cur_fullpel_mv.as_int == prev_fullpel_mv.as_int {
            return 1;
        }
    }
    return 0;
}

choose_intra_uv_mode :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    X: *MACROBLOCK,
    ctx: *PICK_MODE_CONTEXT,
    bsize: BLOCK_SIZE,
    max_tx_size: TX_SIZE,
    rate_uv: *s32,
    rate_uv_tokenonly: *s32,
    dist_uv: *s64,
    skip_uv: *s32,
    mode_uv: *PREDICTION_MODE
) {
    if cpi.sf.use_uv_intra_rd_estimate != 0 {
        rd_sbuv_dcpred(
            cpi,
            X,
            rate_uv,
            rate_uv_tokenonly,
            dist_uv,
            skip_uv,
            cast,no_check(BLOCK_SIZE) ((ifx bsize < 3 then 3 else cast,no_check(s32) bsize))
        );
    } else {
        rd_pick_intra_sbuv_mode(
            cpi,
            X,
            ctx,
            rate_uv,
            rate_uv_tokenonly,
            dist_uv,
            skip_uv,
            cast,no_check(BLOCK_SIZE) ((ifx bsize < 3 then 3 else cast,no_check(s32) bsize)),
            max_tx_size
        );
    }
    mode_uv.* = X.e_mbd.mi[0].uv_mode;
}

rd_sbuv_dcpred :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    rate: *s32,
    rate_tokenonly: *s32,
    distortion: *s64,
    skippable: *s32,
    bsize: BLOCK_SIZE
) -> s64 {
    cm := *cpi.common;
    unused: s64 = ---;

    x.e_mbd.mi[0].uv_mode = 0;
    fill_memory(x.skip_txfm.data, 0, x.skip_txfm.count);
    super_block_uvrd(cpi, x, rate_tokenonly, distortion, skippable, *unused, bsize, 9223372036854775807);
    rate.* = rate_tokenonly.* + cpi.intra_uv_mode_cost[cm.frame_type][x.e_mbd.mi[0].mode][0];
    return ((((cast,no_check(s64) rate.*) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + distortion.* << ((x.rddiv) & 63);
}

check_best_zero_mv :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    mode_context: *u8,
    frame_mv: *[4] Int_Mv,
    this_mode: s32,
    ref_frames: *MV_REFERENCE_FRAME
) -> s32 {
    if (this_mode == 11 || this_mode == 10 || this_mode == 12) &&
        frame_mv[this_mode][ref_frames[0]].as_int == 0 &&
        (ref_frames[1] == -1 || frame_mv[this_mode][ref_frames[1]].as_int == 0) {
        rfc := cast,no_check(s32) mode_context[ref_frames[0]];
        c1 := cost_mv_ref(cpi, 11, rfc);
        c2 := cost_mv_ref(cpi, 10, rfc);
        c3 := cost_mv_ref(cpi, 12, rfc);

        if this_mode == 11 {
            if c1 > c3 {
                return 0;
            }
        } else if this_mode == 10 {
            if c2 > c3 {
                return 0;
            }
        } else {
            if ref_frames[1] == -1 {
                if c3 >= c2 && frame_mv[10][ref_frames[0]].as_int == 0 || c3 >= c1 && frame_mv[11][ref_frames[0]].as_int == 0 {
                    return 0;
                }
            } else if c3 >= c2 && frame_mv[10][ref_frames[0]].as_int == 0 && frame_mv[10][ref_frames[1]].as_int == 0 ||
                c3 >= c1 && frame_mv[11][ref_frames[0]].as_int == 0 && frame_mv[11][ref_frames[1]].as_int == 0 {
                return 0;
            }
        }
    }
    return 1;
}

setup_buffer_inter :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    ref_frame: MV_REFERENCE_FRAME,
    block_size: BLOCK_SIZE,
    mi_row: s32,
    mi_col: s32,
    frame_nearest_mv: *Int_Mv,
    frame_near_mv: *Int_Mv,
    yv12_mb: *[3] Buf_2d
) {
    cm := *cpi.common;
    yv12 := get_ref_frame_buffer_in_vp9_rdopt(cpi, ref_frame);
    XD := *x.e_mbd;
    MI := XD.mi[0];
    CANDIDATES := x.mbmi_ext.ref_mvs[ref_frame].data;
    SF := *cm.frame_refs[(cast(s32) ref_frame) - 1].sf;
    MBMI_EXT := x.mbmi_ext;

    vp9_setup_pred_block(XD, yv12_mb[ref_frame].data, yv12, mi_row, mi_col, SF, SF);

    vp9_find_mv_refs(cm, XD, MI, ref_frame, CANDIDATES, mi_row, mi_col, MBMI_EXT.mode_context.data);

    vp9_find_best_ref_mvs(
        XD,
        cm.allow_high_precision_mv,
        CANDIDATES,
        *frame_nearest_mv[ref_frame],
        *frame_near_mv[ref_frame]
    );

    if vp9_is_scaled_in_vp9_rdopt(SF) == 0 && block_size >= 3 {
        vp9_mv_pred(cpi, x, yv12_mb[ref_frame][0].buf, yv12.y_stride, cast,no_check(s32) ref_frame, block_size);
    }
}

init_frame_mv :: (frame_mv: *[4] Int_Mv) {
    for mode: 0..cast(s32) 14 - 1 {
        for ref_frame: 0..cast(s32) 4 - 1 {
            frame_mv[mode][ref_frame].as_int = 0x80008000;
        }
    }
}

estimate_ref_frame_costs :: (
    cm: *VP9_COMMON,
    xd: *MACROBLOCKD,
    segment_id: s32,
    ref_costs_single: *u32,
    ref_costs_comp: *u32,
    comp_mode_p: *Prob
) {
    seg_ref_active :=
        segfeature_active_in_vp9_rdopt(
            *cm.seg,
            segment_id,
            cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
        );
    if seg_ref_active != 0 {
        fill_memory(ref_costs_single, 0, cast(u64) 4 * size_of(u32));
        fill_memory(ref_costs_comp, 0, cast(u64) 4 * size_of(u32));
        comp_mode_p.* = 128;
    } else {
        intra_inter_p := vp9_get_intra_inter_prob_in_vp9_rdopt(cm, xd);
        comp_inter_p: Prob = 128;

        if cm.reference_mode == cast,no_check(u32) REFERENCE_MODE_SELECT {
            comp_inter_p = vp9_get_reference_mode_prob_in_vp9_rdopt(cm, xd);
            comp_mode_p.* = comp_inter_p;
        } else {
            comp_mode_p.* = 128;
        }

        ref_costs_single[0] = cast,no_check(u32) (VP9_PROB_COST[cast,no_check(s32) intra_inter_p]);

        if cm.reference_mode != cast,no_check(u32) COMPOUND_REFERENCE {
            ref_single_p1 := vp9_get_pred_prob_single_ref_p1_in_vp9_rdopt(cm, xd);
            ref_single_p2 := vp9_get_pred_prob_single_ref_p2_in_vp9_rdopt(cm, xd);
            base_cost := cast,no_check(u32) (VP9_PROB_COST[(256 - cast(s32) intra_inter_p)]);

            if cm.reference_mode == cast,no_check(u32) REFERENCE_MODE_SELECT {
                base_cost += cast,no_check(u32) (VP9_PROB_COST[cast,no_check(s32) comp_inter_p]);
            }

            ref_costs_single[3] = base_cost;
            ref_costs_single[2] = ref_costs_single[3];
            ref_costs_single[1] = ref_costs_single[2];
            ref_costs_single[1] += cast,no_check(u32) (VP9_PROB_COST[cast,no_check(s32) ref_single_p1]);
            ref_costs_single[2] += cast,no_check(u32) (VP9_PROB_COST[(256 - cast(s32) ref_single_p1)]);
            ref_costs_single[3] += cast,no_check(u32) (VP9_PROB_COST[(256 - cast(s32) ref_single_p1)]);
            ref_costs_single[2] += cast,no_check(u32) (VP9_PROB_COST[cast,no_check(s32) ref_single_p2]);
            ref_costs_single[3] += cast,no_check(u32) (VP9_PROB_COST[(256 - cast(s32) ref_single_p2)]);
        } else {
            ref_costs_single[1] = 512;
            ref_costs_single[2] = 512;
            ref_costs_single[3] = 512;
        }
        if cm.reference_mode != cast,no_check(u32) SINGLE_REFERENCE {
            ref_comp_p := vp9_get_pred_prob_comp_ref_p_in_vp9_rdopt(cm, xd);
            base_cost := cast,no_check(u32) (VP9_PROB_COST[(256 - cast(s32) intra_inter_p)]);

            if cm.reference_mode == cast,no_check(u32) REFERENCE_MODE_SELECT {
                base_cost += cast,no_check(u32) (VP9_PROB_COST[(256 - cast(s32) comp_inter_p)]);
            }

            ref_costs_comp[1] = base_cost + cast(u32) (VP9_PROB_COST[cast,no_check(s32) ref_comp_p]);
            ref_costs_comp[2] = base_cost + cast(u32) (VP9_PROB_COST[(256 - cast(s32) ref_comp_p)]);
        } else {
            ref_costs_comp[1] = 512;
            ref_costs_comp[2] = 512;
        }
    }
}

vp9_rd_pick_inter_mode_sb_seg_skip :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    tile_data: *Tile_Data_Enc,
    x: *MACROBLOCK,
    rd_cost: *RD_COST,
    bsize: BLOCK_SIZE,
    ctx: *PICK_MODE_CONTEXT,
    best_rd_so_far: s64
) {
    CM := *cpi.common;
    XD := *x.e_mbd;
    MI := XD.mi[0];
    segment_id := cast,no_check(u8) MI.segment_id;
    COMP_PRED: s32 = 0;

    best_pred_diff: [3] s64 = ---;
    best_filter_diff: [4] s64 = ---;
    ref_costs_single, ref_costs_comp: [4] u32 = ---;
    comp_mode_p: Prob = ---;
    best_filter: INTERP_FILTER = 4;
    this_rd: s64 = 9223372036854775807;
    rate2: s32 = 0;
    DISTORTION2: s64 = 0;

    x.skip_encode = cast(s32) (cpi.sf.skip_encode_frame != 0 && x.q_index < 115);

    estimate_ref_frame_costs(
        CM,
        XD,
        cast,no_check(s32) segment_id,
        ref_costs_single.data,
        ref_costs_comp.data,
        *comp_mode_p
    );

    for i: 0..cast(s32) 4 - 1 {
        x.pred_sse[i] = 2147483647;
    }
    if 1 < 4 {
        for i: 1..cast(s32) 4 - 1 {
            x.pred_mv_sad[i] = 2147483647;
        }
    }

    rd_cost.rate = 2147483647;

    MI.mode = 12;
    MI.uv_mode = 0;
    MI.ref_frame[0] = 1;
    MI.ref_frame[1] = -1;
    MI.mv[0].as_int = 0;
    x.skip = 1;

    ctx.sum_y_eobs = 0;

    if CM.interp_filter != 3 {
        best_filter = 0;
        if CM.interp_filter == 4 && x.source_variance >= cpi.sf.disable_filter_search_var_thresh {
            best_rs: s32 = 2147483647;
            for i: 0..cast(s32) 3 - 1 {
                MI.interp_filter = cast,no_check(INTERP_FILTER) i;
                rs := vp9_get_switchable_rate(cpi, XD);
                if rs < best_rs {
                    best_rs = rs;
                    best_filter = MI.interp_filter;
                }
            }
        }
    }

    if CM.interp_filter == 4 {
        MI.interp_filter = best_filter;
        rate2 += vp9_get_switchable_rate(cpi, XD);
    } else {
        MI.interp_filter = CM.interp_filter;
    }

    if CM.reference_mode == cast,no_check(u32) REFERENCE_MODE_SELECT {
        rate2 += cast,no_check(s32) (VP9_PROB_COST[cast,no_check(s32) comp_mode_p]);
    }

    rate2 = cast,no_check(s32) ((cast,no_check(u32) rate2) + ref_costs_single[1]);
    this_rd =
        ((((cast,no_check(s64) rate2) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
            DISTORTION2 << ((x.rddiv) & 63);

    rd_cost.rate = rate2;
    rd_cost.dist = DISTORTION2;
    rd_cost.rdcost = this_rd;

    if this_rd >= best_rd_so_far {
        rd_cost.rate = 2147483647;
        rd_cost.rdcost = 9223372036854775807;
        return;
    }

    vp9_update_rd_thresh_fact(
        tile_data.thresh_freq_fact.data,
        cpi.sf.adaptive_rd_thresh,
        cast,no_check(s32) bsize,
        cast,no_check(s32) (THR_ZEROMV)
    );

    fill_memory(*best_pred_diff, 0, best_pred_diff.count * size_of(s64));
    fill_memory(*best_filter_diff, 0, best_filter_diff.count * size_of(s64));

    if x.select_tx_size == 0 {
        swap_block_ptr(x, ctx, 1, 0, 0, 3);
    }
    store_coding_context(x, ctx, cast,no_check(s32) (THR_ZEROMV), best_pred_diff.data, best_filter_diff.data, 0);
}

vp9_internal_image_edge :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if cpi.oxcf.pass == 2 &&
        (c_transpiler_float_greater(cpi.twopass.this_frame_stats.inactive_zone_rows, 0.0) ||
            c_transpiler_float_greater(cpi.twopass.this_frame_stats.inactive_zone_cols, 0.0)) {
        return 1;
    }
    return 0;
}

vp9_active_h_edge :: (cpi: *VP9_COMP_in_vp9_encoder, mi_row: s32, mi_step: s32) -> s32 {
    top_edge: s32 = 0;
    bottom_edge := cpi.common.mi_rows;
    is_active_h_edge: s32 = 0;

    if cpi.oxcf.pass == 2 {
        twopass := *cpi.twopass;

        top_edge += cast,no_check(s32) (twopass.this_frame_stats.inactive_zone_rows * 2.0);

        bottom_edge -= cast,no_check(s32) (twopass.this_frame_stats.inactive_zone_rows * 2.0);
        bottom_edge = max(top_edge, bottom_edge);
    }

    if top_edge >= mi_row && top_edge < mi_row + mi_step || bottom_edge >= mi_row && bottom_edge < mi_row + mi_step {
        is_active_h_edge = 1;
    }
    return is_active_h_edge;
}

vp9_active_v_edge :: (cpi: *VP9_COMP_in_vp9_encoder, mi_col: s32, mi_step: s32) -> s32 {
    left_edge: s32 = 0;
    right_edge := cpi.common.mi_cols;
    is_active_v_edge: s32 = 0;

    if cpi.oxcf.pass == 2 {
        twopass := *cpi.twopass;

        left_edge += cast,no_check(s32) (twopass.this_frame_stats.inactive_zone_cols * 2.0);

        right_edge -= cast,no_check(s32) (twopass.this_frame_stats.inactive_zone_cols * 2.0);
        right_edge = max(left_edge, right_edge);
    }

    if left_edge >= mi_col && left_edge < mi_col + mi_step || right_edge >= mi_col && right_edge < mi_col + mi_step {
        is_active_v_edge = 1;
    }
    return is_active_v_edge;
}

vp9_active_edge_sb :: (cpi: *VP9_COMP_in_vp9_encoder, mi_row: s32, mi_col: s32) -> s32 {
    if vp9_active_h_edge(cpi, mi_row, (cast(s32) 1) << (((6 - 3)) & 31)) != 0 ||
        vp9_active_v_edge(cpi, mi_col, (cast(s32) 1) << (((6 - 3)) & 31)) != 0 {
        return 1;
    }
    return 0;
}

vp9_rd_pick_inter_mode_sub8x8 :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    tile_data: *Tile_Data_Enc,
    x: *MACROBLOCK,
    mi_row: s32,
    mi_col: s32,
    rd_cost: *RD_COST,
    bsize: BLOCK_SIZE,
    ctx: *PICK_MODE_CONTEXT,
    best_rd_so_far: s64
) {
    CM := *cpi.common;
    RD_OPT_ := *cpi.rd;
    SF := *cpi.sf;
    XD := *x.e_mbd;
    MI := XD.mi[0];
    SEG := *CM.seg;

    segment_id := cast,no_check(u8) MI.segment_id;

    frame_mv: [14] [4] Int_Mv = ---;
    yv12_mb: [4] [3] Buf_2d;
    best_rd := best_rd_so_far;
    best_yrd := best_rd_so_far;
    best_pred_diff: [3] s64 = ---;
    best_pred_rd: [3] s64 = ---;
    best_filter_rd: [4] s64 = ---;
    best_filter_diff: [4] s64 = ---;
    best_mbmode: MODE_INFO = ---;
    best_ref_index: s32 = 0;
    ref_costs_single, ref_costs_comp: [4] u32 = ---;
    comp_mode_p: Prob = ---;
    tmp_best_filter: INTERP_FILTER = 4;
    rate_uv_tokenonly: s32 = ---;
    dist_uv: s64 = ---;
    skip_uv: s32 = ---;
    mode_uv: PREDICTION_MODE = 0;
    INTRA_COST_PENALTY := vp9_get_intra_cost_penalty(cpi, bsize, CM.base_qindex, CM.y_dc_delta_q);
    seg_mvs: [4] [4] Int_Mv = ---;
    best_bmodes: [4] B_Mode_Info = ---;
    best_skip2: s32 = 0;
    ref_frame_skip_mask: [2] s32;
    mask_filter: s64 = 0;
    filter_cache: [4] s64 = ---;
    internal_active_edge :=
        cast(s32) (vp9_active_edge_sb(cpi, mi_row, mi_col) != 0 &&
            vp9_internal_image_edge(cpi) != 0);
    RD_THRESH_FREQ_FACT := tile_data.thresh_freq_fact[bsize].data;

    x.skip_encode = cast(s32) (SF.skip_encode_frame != 0 && x.q_index < 115);
    fill_memory(x.zcoeff_blk[0].data, 0, 4);
    fill_memory(*best_mbmode, 0, size_of(MODE_INFO));

    i: s32 = 0;
    while i < 3 + 1 {
        filter_cache[i] = 9223372036854775807;
        i += 1;
    }

    i = 0;
    while i < 4 {
        for j: 0..cast(s32) 4 - 1 {
            seg_mvs[i][j].as_int = 0x80008000;
        }
        i += 1;
    }

    estimate_ref_frame_costs(
        CM,
        XD,
        cast,no_check(s32) segment_id,
        ref_costs_single.data,
        ref_costs_comp.data,
        *comp_mode_p
    );

    i = 0;
    while i < REFERENCE_MODES {
        best_pred_rd[i] = 9223372036854775807;
        i += 1;
    }
    i = 0;
    while i < 3 + 1 {
        best_filter_rd[i] = 9223372036854775807;
        i += 1;
    }
    rate_uv_intra: s32 = 2147483647;

    rd_cost.rate = 2147483647;

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame <= 3 {
        if cpi.ref_frame_flags & ref_frame_to_flag_in_vp9_rdopt(ref_frame) != 0 {
            setup_buffer_inter(
                cpi,
                x,
                ref_frame,
                bsize,
                mi_row,
                mi_col,
                frame_mv[10].data,
                frame_mv[11].data,
                yv12_mb.data
            );
        } else {
            ref_frame_skip_mask[0] |= (cast(s32) 1) << ((ref_frame) & 31);
            ref_frame_skip_mask[1] |= (cast(s32) 1) << 3 | 0x1;
        }
        frame_mv[13][ref_frame].as_int = 0x80008000;
        frame_mv[12][ref_frame].as_int = 0;
        ref_frame += 1;
    }

    for ref_index: 0..cast(s32) 6 - 1 {
        mode_excluded: s32 = 0;
        this_rd: s64 = 9223372036854775807;
        disable_skip: s32 = 0;
        compmode_cost: s32 = 0;
        rate2: s32 = 0;
        rate_y: s32 = 0;
        rate_uv: s32 = 0;
        distortion2: s64 = 0;
        distortion_y: s64 = 0;
        distortion_uv: s64 = 0;
        skippable: s32 = 0;
        this_skip2: s32 = 0;
        total_sse: s64 = 2147483647;
        early_term: s32 = 0;
        backup_yv12: [2] [3] Buf_2d = ---;

        ref_frame = VP9_REF_ORDER[ref_index].ref_frame[0];
        second_ref_frame := VP9_REF_ORDER[ref_index].ref_frame[1];

        fill_memory(*x.sum_y_eobs, 0, x.sum_y_eobs.count * size_of(s32));

        if ref_index > 2 && SF.mode_skip_start < 30 {
            if ref_index == 3 {
                if cast,no_check(s32) best_mbmode.ref_frame[0] == {
                    case 0;
                    case 1;
                        ref_frame_skip_mask[0] |= (cast(s32) 1) << 2 | ((cast(s32) 1) << 3);
                        ref_frame_skip_mask[1] |= (cast(s32) 1) << 3 | 0x1;
                    case 2;
                        ref_frame_skip_mask[0] |= (cast(s32) 1) << 1 | ((cast(s32) 1) << 3);
                        ref_frame_skip_mask[1] |= (cast(s32) 1) << 3 | 0x1;
                    case 3;
                        ref_frame_skip_mask[0] |= (cast(s32) 1) << 2 | ((cast(s32) 1) << 1);
                    case -1; #through;
                    case 4;
                }
            }
        }

        if ref_frame_skip_mask[0] & ((cast(s32) 1) << ((ref_frame) & 31)) != 0 &&
            ref_frame_skip_mask[1] & ((cast(s32) 1) << (((ifx 0 > second_ref_frame then 0 else cast,no_check(s32) second_ref_frame)) & 31)) != 0 {
            continue;
        }

        if internal_active_edge == 0 &&
            rd_less_than_thresh_in_vp9_rdopt(
                best_rd,
                RD_OPT_.threshes[segment_id][bsize][ref_index],
                *RD_THRESH_FREQ_FACT[ref_index]
            ) != 0 {
            continue;
        }

        if cpi.oxcf.motion_vector_unit_test != 0 && ref_frame == 0 {
            continue;
        }

        comp_pred := cast(s32) (second_ref_frame > 0);
        if comp_pred != 0 {
            if cpi.allow_comp_inter_inter == 0 {
                continue;
            }

            if CM.ref_frame_sign_bias[ref_frame] == CM.ref_frame_sign_bias[second_ref_frame] {
                continue;
            }

            if cpi.ref_frame_flags & ref_frame_to_flag_in_vp9_rdopt(second_ref_frame) == 0 {
                continue;
            }

            if segfeature_active_in_vp9_rdopt(
                SEG,
                cast,no_check(s32) segment_id,
                cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
            ) != 0 {
                continue;
            }

            if SF.mode_search_skip_flags & cast,no_check(u32) FLAG_SKIP_COMP_BESTINTRA != 0 && best_mbmode.ref_frame[0] == 0 {
                continue;
            }
        }

        if comp_pred != 0 {
            mode_excluded = cast(s32) (CM.reference_mode == cast,no_check(u32) SINGLE_REFERENCE);
        } else if ref_frame != 0 {
            mode_excluded = cast(s32) (CM.reference_mode == cast,no_check(u32) COMPOUND_REFERENCE);
        }

        if segfeature_active_in_vp9_rdopt(
            SEG,
            cast,no_check(s32) segment_id,
            cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
        ) != 0 &&
            get_segdata_in_vp9_rdopt(SEG, cast,no_check(s32) segment_id, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME) != cast,no_check(s32) ref_frame {
            continue;
        } else if segfeature_active_in_vp9_rdopt(
            SEG,
            cast,no_check(s32) segment_id,
            cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
        ) == 0 {
            if cpi.rc.is_src_frame_alt_ref != 0 && cpi.oxcf.arnr_max_frames == 0 {
                continue;
            }
        }

        MI.tx_size = 0;
        MI.uv_mode = 0;
        MI.ref_frame[0] = ref_frame;
        MI.ref_frame[1] = second_ref_frame;

        MI.interp_filter =
            cast,no_check(INTERP_FILTER) ((ifx CM.interp_filter == 4 then 0 else cast,no_check(s32) CM.interp_filter));
        x.skip = 0;
        set_ref_ptrs_in_vp9_rdopt(CM, XD, ref_frame, second_ref_frame);

        i = 0;
        while i < 3 {
            XD.plane[i].pre[0] = yv12_mb[ref_frame][i];
            if comp_pred != 0 {
                XD.plane[i].pre[1] = yv12_mb[second_ref_frame][i];
            }
            i += 1;
        }

        if ref_frame == 0 {
            rate: s32 = ---;
            if rd_pick_intra_sub_8x8_y_mode(cpi, x, *rate, *rate_y, *distortion_y, best_rd) >= best_rd {
                continue;
            }
            rate2 += rate;
            rate2 += INTRA_COST_PENALTY;
            distortion2 += distortion_y;

            if rate_uv_intra == 2147483647 {
                choose_intra_uv_mode(
                    cpi,
                    x,
                    ctx,
                    bsize,
                    0,
                    *rate_uv_intra,
                    *rate_uv_tokenonly,
                    *dist_uv,
                    *skip_uv,
                    *mode_uv
                );
            }
            rate2 += rate_uv_intra;
            rate_uv = rate_uv_tokenonly;
            distortion2 += dist_uv;
            distortion_uv = dist_uv;
            MI.uv_mode = mode_uv;
        } else {
            rate: s32 = ---;
            distortion: s64 = ---;

            tmp_rd: s64 = ---;
            tmp_best_rd: s64 = 9223372036854775807;
            tmp_best_rdu: s64 = 9223372036854775807;
            tmp_best_rate: s32 = 2147483647;
            tmp_best_ratey: s32 = 2147483647;
            tmp_best_distortion: s64 = 2147483647;
            tmp_best_sse: s64 = ---;
            uv_sse: s64 = ---;
            tmp_best_skippable: s32 = 0;

            second_ref: *Int_Mv = (ifx comp_pred != 0 then x.mbmi_ext.ref_mvs[second_ref_frame].data + 0 else null);
            tmp_best_bmodes: [16] B_Mode_Info = ---;
            tmp_best_mbmode: MODE_INFO = ---;
            bsi: [3] BEST_SEG_INFO_in_vp9_rdopt = ---;
            pred_exists: s32 = 0;
            uv_skippable: s32 = ---;

            scaled_ref_frame: [2] *YV12_BUFFER_CONFIG;

            for ref: 0..cast(s32) 2 - 1 {
                scaled_ref_frame[ref] =
                    ifx MI.ref_frame[ref] > 0 then vp9_get_scaled_ref_frame(cpi, cast,no_check(s32) MI.ref_frame[ref]) else null;

                if scaled_ref_frame[ref] != null {
                    i = 0;
                    while i < 3 {
                        backup_yv12[ref][i] = XD.plane[i].pre[ref];
                        i += 1;
                    }
                    vp9_setup_pre_planes(XD, ref, scaled_ref_frame[ref], mi_row, mi_col, null);
                }
            }

            this_rd_thresh :=
                cast,no_check(s64) ((ifx ref_frame == 1 then RD_OPT_.threshes[segment_id][bsize][THR_LAST] else RD_OPT_.threshes[segment_id][bsize][THR_ALTR]));
            this_rd_thresh =
                ifx ref_frame == 2 then cast,no_check(s64) RD_OPT_.threshes[segment_id][bsize][THR_GOLD] else this_rd_thresh;
            i = 0;
            while i < 3 + 1 {
                filter_cache[i] = 9223372036854775807;
                i += 1;
            }

            if CM.interp_filter != 3 {
                tmp_best_filter = 0;
                if x.source_variance < SF.disable_filter_search_var_thresh {
                    tmp_best_filter = 0;
                } else if SF.adaptive_pred_interp_filter == 1 && ctx.pred_interp_filter < 4 {
                    tmp_best_filter = ctx.pred_interp_filter;
                } else if SF.adaptive_pred_interp_filter == 2 {
                    tmp_best_filter =
                        cast,no_check(INTERP_FILTER) ((ifx ctx.pred_interp_filter < 4 then cast,no_check(s32) ctx.pred_interp_filter else 0));
                } else {
                    for switchable_filter_index: 0..cast(s32) 3 - 1 {
                        mbmi_ext := x.mbmi_ext;
                        MI.interp_filter = cast,no_check(INTERP_FILTER) switchable_filter_index;
                        tmp_rd =
                            rd_pick_best_sub8x8_mode(
                                cpi,
                                x,
                                mbmi_ext.ref_mvs[ref_frame].data + 0,
                                second_ref,
                                best_yrd,
                                *rate,
                                *rate_y,
                                *distortion,
                                *skippable,
                                *total_sse,
                                cast,no_check(s32) this_rd_thresh,
                                seg_mvs.data,
                                bsi.data,
                                switchable_filter_index,
                                mi_row,
                                mi_col
                            );

                        if tmp_rd == 9223372036854775807 {
                            continue;
                        }
                        rs := vp9_get_switchable_rate(cpi, XD);
                        rs_rd :=
                            ((((cast,no_check(s64) rs) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                                cast(s64) ((cast(s32) 0) << ((x.rddiv) & 31));
                        filter_cache[switchable_filter_index] = tmp_rd;
                        filter_cache[3] = ifx filter_cache[3] < tmp_rd + rs_rd then filter_cache[3] else tmp_rd + rs_rd;
                        if CM.interp_filter == 4 {
                            tmp_rd += rs_rd;
                        }

                        mask_filter = max(mask_filter, tmp_rd);

                        newbest := cast(s32) (tmp_rd < tmp_best_rd);
                        if newbest != 0 {
                            tmp_best_filter = MI.interp_filter;
                            tmp_best_rd = tmp_rd;
                        }
                        if newbest != 0 && CM.interp_filter == 4 || MI.interp_filter == CM.interp_filter && CM.interp_filter != 4 {
                            tmp_best_rdu = tmp_rd;
                            tmp_best_rate = rate;
                            tmp_best_ratey = rate_y;
                            tmp_best_distortion = distortion;
                            tmp_best_sse = total_sse;
                            tmp_best_skippable = skippable;
                            assignment_8: MODE_INFO = MI.*;
                            ((*tmp_best_mbmode).*) = assignment_8;
                            x.sum_y_eobs[0] = 0;
                            i = 0;
                            while i < 4 {
                                tmp_best_bmodes[i] = XD.mi[0].bmi[i];
                                x.zcoeff_blk[0][i] = cast(u8) (x.plane[0].eobs[i] == 0);
                                x.sum_y_eobs[0] = cast,no_check(s32) (x.sum_y_eobs[0] + cast,no_check(s32) x.plane[0].eobs[i]);
                                i += 1;
                            }
                            pred_exists = 1;
                            if switchable_filter_index == 0 && SF.use_rd_breakout != 0 && best_rd < 9223372036854775807 {
                                if (tmp_best_rdu / 2) > best_rd {
                                    tmp_best_filter = MI.interp_filter;
                                    tmp_best_rdu = 9223372036854775807;
                                    break;
                                }
                            }
                        }
                    }
                }
            }

            if tmp_best_rdu == 9223372036854775807 && pred_exists != 0 {
                continue;
            }

            MI.interp_filter =
                cast,no_check(INTERP_FILTER) ((ifx CM.interp_filter == 4 then cast,no_check(s32) tmp_best_filter else cast,no_check(s32) CM.interp_filter));
            if pred_exists == 0 {
                tmp_rd =
                    rd_pick_best_sub8x8_mode(
                        cpi,
                        x,
                        x.mbmi_ext.ref_mvs[ref_frame].data + 0,
                        second_ref,
                        best_yrd,
                        *rate,
                        *rate_y,
                        *distortion,
                        *skippable,
                        *total_sse,
                        cast,no_check(s32) this_rd_thresh,
                        seg_mvs.data,
                        bsi.data,
                        0,
                        mi_row,
                        mi_col
                    );
                if tmp_rd == 9223372036854775807 {
                    continue;
                }
                x.sum_y_eobs[0] = 0;
                i = 0;
                while i < 4 {
                    x.zcoeff_blk[0][i] = cast(u8) (x.plane[0].eobs[i] == 0);
                    x.sum_y_eobs[0] = cast,no_check(s32) (x.sum_y_eobs[0] + cast,no_check(s32) x.plane[0].eobs[i]);
                    i += 1;
                }
            } else {
                total_sse = tmp_best_sse;
                rate = tmp_best_rate;
                rate_y = tmp_best_ratey;
                distortion = tmp_best_distortion;
                skippable = tmp_best_skippable;
                assignment_9: MODE_INFO = tmp_best_mbmode;
                ((MI).*) = assignment_9;
                i = 0;
                while i < 4 {
                    XD.mi[0].bmi[i] = tmp_best_bmodes[i];
                    i += 1;
                }
            }

            rate2 += rate;
            distortion2 += distortion;

            if CM.interp_filter == 4 {
                rate2 += vp9_get_switchable_rate(cpi, XD);
            }

            if mode_excluded == 0 {
                mode_excluded =
                    ifx comp_pred != 0 then cast(s32) (CM.reference_mode == cast,no_check(u32) SINGLE_REFERENCE) else cast(s32) (CM.reference_mode == cast,no_check(u32) COMPOUND_REFERENCE);
            }

            compmode_cost =
                cast,no_check(s32) (VP9_PROB_COST[(ifx comp_pred != 0 then 256 -
                    cast(s32) comp_mode_p else cast,no_check(s32) comp_mode_p)]);

            tmp_best_rdu =
                best_rd -
                    (ifx (((((cast,no_check(s64) rate2) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + distortion2 << ((x.rddiv) & 63)) < (((0 * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + total_sse << ((x.rddiv) & 63) then ((((cast,no_check(s64) rate2) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + distortion2 << ((x.rddiv) & 63) else (((0 * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + total_sse << ((x.rddiv) & 63));

            if tmp_best_rdu > 0 {
                vp9_build_inter_predictors_sbuv(*x.e_mbd, mi_row, mi_col, 3);
                fill_memory(x.skip_txfm.data, 0, x.skip_txfm.count);
                if super_block_uvrd(cpi, x, *rate_uv, *distortion_uv, *uv_skippable, *uv_sse, 3, tmp_best_rdu) == 0 {
                    for ref: 0..cast(s32) 2 - 1 {
                        if scaled_ref_frame[ref] != null {
                            i = 0;
                            while i < 3 {
                                XD.plane[i].pre[ref] = backup_yv12[ref][i];
                                i += 1;
                            }
                        }
                    }
                    continue;
                }

                rate2 += rate_uv;
                distortion2 += distortion_uv;
                skippable = cast(s32) (skippable != 0 && uv_skippable != 0);
                total_sse += uv_sse;
            }

            for ref: 0..cast(s32) 2 - 1 {
                if scaled_ref_frame[ref] != null {
                    i = 0;
                    while i < 3 {
                        XD.plane[i].pre[ref] = backup_yv12[ref][i];
                        i += 1;
                    }
                }
            }
        }

        if CM.reference_mode == cast,no_check(u32) REFERENCE_MODE_SELECT {
            rate2 += compmode_cost;
        }

        if second_ref_frame > 0 {
            rate2 = cast,no_check(s32) ((cast,no_check(u32) rate2) + ref_costs_comp[ref_frame]);
        } else {
            rate2 = cast,no_check(s32) ((cast,no_check(u32) rate2) + ref_costs_single[ref_frame]);
        }

        if disable_skip == 0 {
            SKIP_PROB := vp9_get_skip_prob_in_vp9_rdopt(CM, XD);
            SKIP_COST0 := cast,no_check(s32) (VP9_PROB_COST[cast,no_check(s32) SKIP_PROB]);
            SKIP_COST1 := cast,no_check(s32) (VP9_PROB_COST[(256 - cast(s32) SKIP_PROB)]);

            if ref_frame != 0 && XD.lossless == 0 {
                if (((((cast,no_check(s64) (rate_y + rate_uv + SKIP_COST0)) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + distortion2 << ((x.rddiv) & 63)) < ((((cast,no_check(s64) SKIP_COST1) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + total_sse << ((x.rddiv) & 63) {
                    rate2 += SKIP_COST0;
                } else {
                    rate2 += SKIP_COST1;
                    distortion2 = total_sse;

                    rate2 -= rate_y + rate_uv;
                    rate_y = 0;
                    rate_uv = 0;
                    this_skip2 = 1;
                }
            } else {
                rate2 += SKIP_COST0;
            }

            this_rd =
                ((((cast,no_check(s64) rate2) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                    distortion2 << ((x.rddiv) & 63);
        }

        if disable_skip == 0 && ref_frame == 0 {
            i = 0;
            while i < REFERENCE_MODES {
                best_pred_rd[i] = ifx best_pred_rd[i] < this_rd then best_pred_rd[i] else this_rd;
                i += 1;
            }
            i = 0;
            while i < 3 + 1 {
                best_filter_rd[i] = ifx best_filter_rd[i] < this_rd then best_filter_rd[i] else this_rd;
                i += 1;
            }
        }

        if this_rd < best_rd || x.skip != 0 {
            if mode_excluded == 0 {
                max_plane: s32 = 3;

                best_ref_index = ref_index;

                if ref_frame == 0 {
                    MI.mv[0].as_int = 0;
                    max_plane = 1;

                    MI.interp_filter = 3;
                }

                rd_cost.rate = rate2;
                rd_cost.dist = distortion2;
                rd_cost.rdcost = this_rd;
                best_rd = this_rd;
                best_yrd =
                    (best_rd - (((cast,no_check(s64) rate_uv) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                        distortion_uv << ((x.rddiv) & 63);
                assignment_10: MODE_INFO = MI.*;
                ((*best_mbmode).*) = assignment_10;
                best_skip2 = this_skip2;
                if x.select_tx_size == 0 {
                    swap_block_ptr(x, ctx, 1, 0, 0, max_plane);
                }
                copy_memory(ctx.zcoeff_blk, x.zcoeff_blk[0].data, cast,no_check(u64) ctx.num_4x4_blk);
                ctx.sum_y_eobs = x.sum_y_eobs[0];

                i = 0;
                while i < 4 {
                    best_bmodes[i] = XD.mi[0].bmi[i];
                    i += 1;
                }

                if SF.mode_search_skip_flags & cast,no_check(u32) FLAG_EARLY_TERMINATE != 0 && ref_index > 3 {
                    qstep := cast,no_check(s32) XD.plane[0].dequant[1];

                    scale: s32 = 4;

                    if x.source_variance < U32_MAX {
                        VAR_ADJUST := cast(s32) (x.source_variance < 16);
                        scale -= VAR_ADJUST;
                    }
                    if ref_frame > 0 && (distortion2 * cast(s64) scale) < cast,no_check(s64) (qstep * qstep) {
                        early_term = 1;
                    }
                }
            }
        }

        if disable_skip == 0 && ref_frame != 0 {
            single_rate: s64 = ---;
            hybrid_rate: s64 = ---;

            if CM.reference_mode == cast,no_check(u32) REFERENCE_MODE_SELECT {
                single_rate = cast,no_check(s64) (rate2 - compmode_cost);
                hybrid_rate = cast,no_check(s64) rate2;
            } else {
                single_rate = cast,no_check(s64) rate2;
                hybrid_rate = cast,no_check(s64) (rate2 + compmode_cost);
            }

            single_rd :=
                (((single_rate * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                    distortion2 << ((x.rddiv) & 63);
            hybrid_rd :=
                (((hybrid_rate * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                    distortion2 << ((x.rddiv) & 63);

            if comp_pred == 0 && single_rd < best_pred_rd[SINGLE_REFERENCE] {
                best_pred_rd[SINGLE_REFERENCE] = single_rd;
            } else if comp_pred != 0 && single_rd < best_pred_rd[COMPOUND_REFERENCE] {
                best_pred_rd[COMPOUND_REFERENCE] = single_rd;
            }

            if hybrid_rd < best_pred_rd[REFERENCE_MODE_SELECT] {
                best_pred_rd[REFERENCE_MODE_SELECT] = hybrid_rd;
            }
        }

        if mode_excluded == 0 && disable_skip == 0 && ref_frame != 0 && CM.interp_filter != 3 {
            ref := filter_cache[(ifx CM.interp_filter == 4 then 3 else cast,no_check(s32) CM.interp_filter)];

            i = 0;
            while i < 3 + 1 {
                adj_rd: s64 = ifx ref == 9223372036854775807
                    then cast(s64) 0
                    else ifx filter_cache[i] == 9223372036854775807
                        then mask_filter - ref + 10
                        else filter_cache[i] - ref;

                adj_rd += this_rd;
                best_filter_rd[i] = ifx best_filter_rd[i] < adj_rd then best_filter_rd[i] else adj_rd;
                i += 1;
            }
        }

        if early_term != 0 {
            break;
        }

        if x.skip != 0 && comp_pred == 0 {
            break;
        }
    }

    if best_rd >= best_rd_so_far {
        rd_cost.rate = 2147483647;
        rd_cost.rdcost = 9223372036854775807;
        return;
    }

    if SF.use_uv_intra_rd_estimate != 0 {
        if best_mbmode.ref_frame[0] == 0 {
            assignment_11: MODE_INFO = best_mbmode;
            ((MI).*) = assignment_11;
            rd_pick_intra_sbuv_mode(cpi, x, ctx, *rate_uv_intra, *rate_uv_tokenonly, *dist_uv, *skip_uv, 3, 0);
        }
    }

    if best_rd == 9223372036854775807 {
        rd_cost.rate = 2147483647;
        rd_cost.dist = 9223372036854775807;
        rd_cost.rdcost = 9223372036854775807;
        return;
    }

    vp9_update_rd_thresh_fact(
        tile_data.thresh_freq_fact.data,
        SF.adaptive_rd_thresh,
        cast,no_check(s32) bsize,
        best_ref_index
    );

    assignment_12: MODE_INFO = best_mbmode;
    ((MI).*) = assignment_12;
    x.skip |= best_skip2;
    if is_inter_block_in_vp9_rdopt(*best_mbmode) == 0 {
        i = 0;
        while i < 4 {
            XD.mi[0].bmi[i].as_mode = best_bmodes[i].as_mode;
            i += 1;
        }
    } else {
        i = 0;
        while i < 4 {
            XD.mi[0].bmi[i] = best_bmodes[i];
            i += 1;
        }

        MI.mv[0].as_int = XD.mi[0].bmi[3].as_mv[0].as_int;
        MI.mv[1].as_int = XD.mi[0].bmi[3].as_mv[1].as_int;
    }

    if MI.ref_frame[1] == -1 {
        MI.mv[1].as_int = 0;
        i = 0;
        while i < 4 {
            MI.bmi[i].as_mv[1].as_int = 0;
            i += 1;
        }
    }

    i = 0;
    while i < REFERENCE_MODES {
        if best_pred_rd[i] == 9223372036854775807 {
            best_pred_diff[i] = cast,no_check(s64) (-2147483647 - 1);
        } else {
            best_pred_diff[i] = best_rd - best_pred_rd[i];
        }
        i += 1;
    }

    if x.skip == 0 {
        i = 0;
        while i < 3 + 1 {
            if best_filter_rd[i] == 9223372036854775807 {
                best_filter_diff[i] = 0;
            } else {
                best_filter_diff[i] = best_rd - best_filter_rd[i];
            }
            i += 1;
        }
        if CM.interp_filter == 4 {
        }
    } else {
        fill_memory(*best_filter_diff, 0, best_filter_diff.count * size_of(s64));
    }

    store_coding_context(x, ctx, best_ref_index, best_pred_diff.data, best_filter_diff.data, 0);
}

rd_pick_best_sub8x8_mode :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    best_ref_mv: *Int_Mv,
    second_best_ref_mv: *Int_Mv,
    best_rd_so_far: s64,
    returntotrate: *s32,
    returnyrate: *s32,
    returndistortion: *s64,
    skippable: *s32,
    psse: *s64,
    mvthresh: s32,
    seg_mvs: *[4] Int_Mv,
    bsi_buf: *BEST_SEG_INFO_in_vp9_rdopt,
    filter_idx: s32,
    mi_row: s32,
    mi_col: s32
) -> s64 {
    bsi := bsi_buf + filter_idx;
    xd := *x.e_mbd;
    mi := xd.mi[0];
    mode_idx: s32 = ---;
    br: s32 = 0;
    idx: s32 = ---;
    bd: s64 = 0;
    block_sse: s64 = 0;
    this_mode: PREDICTION_MODE = ---;
    cm := *cpi.common;
    P := x.plane.data + 0;
    PD := xd.plane.data + 0;
    LABEL_COUNT: s32 = 4;
    this_segment_rd: s64 = 0;

    segmentyrate: s32 = 0;
    BSIZE := mi.sb_type;
    NUM_4X4_BLOCKS_WIDE := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[BSIZE];
    NUM_4X4_BLOCKS_HIGH := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[BSIZE];
    PW := NUM_4X4_BLOCKS_WIDE << 2;
    PH := NUM_4X4_BLOCKS_HIGH << 2;
    t_above, t_left: [2] ENTROPY_CONTEXT = ---;
    subpelmv: s32 = 1;
    have_ref: s32 = 0;
    SF := *cpi.sf;
    HAS_SECOND_RF := has_second_ref_in_vp9_rdopt(mi);
    INTER_MODE_MASK := SF.inter_mode_mask[BSIZE];
    MBMI_EXT := x.mbmi_ext;

    fill_memory(bsi, 0, size_of(BEST_SEG_INFO_in_vp9_rdopt));

    bsi.segment_rd = best_rd_so_far;
    bsi.ref_mv[0] = best_ref_mv;
    bsi.ref_mv[1] = second_best_ref_mv;
    bsi.mvp.as_int = best_ref_mv.as_int;
    bsi.mvthresh = mvthresh;

    for i: 0..cast(s32) 4 - 1 {
        bsi.modes[i] = 12;
    }

    copy_memory(t_above.data, PD.above_context, t_above.count);
    copy_memory(t_left.data, PD.left_context, t_left.count);

    label_mv_thresh := 1 * bsi.mvthresh / LABEL_COUNT;

    idy: s32 = 0;
    while idy < 2 {
        idx = 0;
        while idx < 2 {
            mode_mv: [14] [2] Int_Mv = ---;
            frame_mv: [14] [4] Int_Mv = ---;
            mode_selected: PREDICTION_MODE = 12;
            best_rd: s64 = 9223372036854775807;
            BLOCK_ := idy * 2 + idx;

            ref: s32 = 0;
            while ref < 1 + HAS_SECOND_RF {
                FRAME := mi.ref_frame[ref];
                frame_mv[12][FRAME].as_int = 0;
                vp9_append_sub8x8_mvs_for_idx(
                    cm,
                    xd,
                    BLOCK_,
                    ref,
                    mi_row,
                    mi_col,
                    frame_mv[10].data + FRAME,
                    frame_mv[11].data + FRAME,
                    MBMI_EXT.mode_context.data
                );
                ref += 1;
            }

            this_mode = 10;
            while this_mode <= 13 {
                ORIG_SRC := x.plane[0].src;
                orig_pre: [2] Buf_2d = ---;

                mode_idx = (cast(s32) this_mode) - 10;
                bsi.rdstat[BLOCK_][mode_idx].brdcost = 9223372036854775807;
                if INTER_MODE_MASK & ((cast(s32) 1) << ((this_mode) & 31)) == 0 {
                    this_mode += 1;
                    continue;
                }

                if check_best_zero_mv(
                    cpi,
                    MBMI_EXT.mode_context.data,
                    frame_mv.data,
                    cast,no_check(s32) this_mode,
                    mi.ref_frame.data
                ) == 0 {
                    this_mode += 1;
                    continue;
                }

                copy_memory(orig_pre.data, PD.pre.data, orig_pre.count * size_of(Buf_2d));
                copy_memory(bsi.rdstat[BLOCK_][mode_idx].ta.data, t_above.data, 2 * cast(u64) size_of(ENTROPY_CONTEXT));
                copy_memory(bsi.rdstat[BLOCK_][mode_idx].tl.data, t_left.data, 2 * cast(u64) size_of(ENTROPY_CONTEXT));

                if HAS_SECOND_RF == 0 && this_mode == 13 && seg_mvs[BLOCK_][mi.ref_frame[0]].as_int == 0x80008000 {
                    NEW_MV := *mode_mv[13][0].as_mv;
                    step_param: s32 = 0;
                    bestsme: u32 = U32_MAX;
                    sadpb := x.sadperbit4;
                    mvp_full: MV = ---;

                    cost_list: [5] s32 = ---;
                    TMP_MV_LIMITS := x.mv_limits;

                    if best_rd < cast,no_check(s64) label_mv_thresh {
                        break;
                    }

                    if cpi.oxcf.mode != cast,no_check(u32) BEST {
                        if BLOCK_ > 0 {
                            bsi.mvp.as_int = mi.bmi[BLOCK_ - 1].as_mv[0].as_int;
                            if BLOCK_ == 2 {
                                bsi.mvp.as_int = mi.bmi[BLOCK_ - 2].as_mv[0].as_int;
                            }
                        }
                    }
                    max_mv: s32 = ifx BLOCK_ == 0
                        then cast,no_check(s32) x.max_mv_context[mi.ref_frame[0]]
                        else (ifx absolute_value(cast,no_check(s32) bsi.mvp.as_mv.row) > absolute_value(cast,no_check(s32) bsi.mvp.as_mv.col) then absolute_value(cast,no_check(s32) bsi.mvp.as_mv.row) else absolute_value(cast,no_check(s32) bsi.mvp.as_mv.col)) >> 3;

                    if SF.mv.auto_mv_step_size != 0 && cm.show_frame != 0 {
                        step_param = (vp9_init_search_range(max_mv) + cpi.mv_step_param) / 2;
                    } else {
                        step_param = cpi.mv_step_param;
                    }

                    mvp_full.row = cast,no_check(s16) ((cast(s32) bsi.mvp.as_mv.row) >> 3);
                    mvp_full.col = cast,no_check(s16) ((cast(s32) bsi.mvp.as_mv.col) >> 3);

                    if SF.adaptive_motion_search != 0 {
                        if x.pred_mv[mi.ref_frame[0]].row != 32767 && x.pred_mv[mi.ref_frame[0]].col != 32767 {
                            mvp_full.row = cast,no_check(s16) ((cast(s32) x.pred_mv[mi.ref_frame[0]].row) >> 3);
                            mvp_full.col = cast,no_check(s16) ((cast(s32) x.pred_mv[mi.ref_frame[0]].col) >> 3);
                        }
                        step_param = ifx step_param > 8 then step_param else 8;
                    }

                    mi_buf_shift(x, BLOCK_);

                    vp9_set_mv_search_range(*x.mv_limits, *bsi.ref_mv[0].as_mv);

                    bestsme =
                        cast,no_check(u32) vp9_full_pixel_search(
                            cpi,
                            x,
                            BSIZE,
                            *mvp_full,
                            step_param,
                            cast,no_check(s32) cpi.sf.mv.search_method,
                            sadpb,
                            (ifx SF.mv.subpel_search_method != cast,no_check(u32) SUBPEL_TREE then cost_list.data else null),
                            *bsi.ref_mv[0].as_mv,
                            NEW_MV,
                            2147483647,
                            1
                        );

                    x.mv_limits = TMP_MV_LIMITS;

                    if bestsme < U32_MAX {
                        distortion: u32 = ---;
                        cpi.find_fractional_mv_step(
                            x,
                            NEW_MV,
                            *bsi.ref_mv[0].as_mv,
                            cm.allow_high_precision_mv,
                            x.errorperbit,
                            cpi.fn_ptr.data + BSIZE,
                            cast,no_check(s32) SF.mv.subpel_force_stop,
                            SF.mv.subpel_search_level,
                            cond_cost_list_in_vp9_rdopt(cpi, cost_list.data),
                            x.nmvjointcost.data,
                            x.mvcost,
                            *distortion,
                            x.pred_sse.data + mi.ref_frame[0],
                            null,
                            PW,
                            PH,
                            cast,no_check(s32) cpi.sf.use_accurate_subpel_search
                        );

                        seg_mvs[BLOCK_][mi.ref_frame[0]].as_mv = NEW_MV.*;
                    }

                    x.pred_mv[mi.ref_frame[0]] = NEW_MV.*;

                    mi_buf_restore(x, ORIG_SRC, orig_pre.data);
                }

                if HAS_SECOND_RF != 0 {
                    if seg_mvs[BLOCK_][mi.ref_frame[1]].as_int == 0x80008000 || seg_mvs[BLOCK_][mi.ref_frame[0]].as_int == 0x80008000 {
                        this_mode += 1;
                        continue;
                    }
                }

                if HAS_SECOND_RF != 0 && this_mode == 13 && mi.interp_filter == 0 {
                    NUM_JOINT_SEARCH_ITERS :=
                        get_joint_search_iters(
                            cpi.sf.comp_inter_joint_search_iter_level,
                            BSIZE
                        );

                    mi_buf_shift(x, BLOCK_);
                    if NUM_JOINT_SEARCH_ITERS != 0 {
                        rate_mv: s32 = ---;
                        joint_motion_search(
                            cpi,
                            x,
                            BSIZE,
                            frame_mv[this_mode].data,
                            mi_row,
                            mi_col,
                            seg_mvs[BLOCK_].data,
                            *rate_mv,
                            NUM_JOINT_SEARCH_ITERS
                        );
                        seg_mvs[BLOCK_][mi.ref_frame[0]].as_int = frame_mv[this_mode][mi.ref_frame[0]].as_int;
                        seg_mvs[BLOCK_][mi.ref_frame[1]].as_int = frame_mv[this_mode][mi.ref_frame[1]].as_int;
                    }

                    mi_buf_restore(x, ORIG_SRC, orig_pre.data);
                }

                bsi.rdstat[BLOCK_][mode_idx].brate =
                    set_and_cost_bmi_mvs(
                        cpi,
                        x,
                        xd,
                        BLOCK_,
                        this_mode,
                        mode_mv[this_mode].data,
                        frame_mv.data,
                        seg_mvs[BLOCK_].data,
                        bsi.ref_mv.data,
                        x.nmvjointcost.data,
                        x.mvcost
                    );

                ref = 0;
                while ref < 1 + HAS_SECOND_RF {
                    bsi.rdstat[BLOCK_][mode_idx].mvs[ref].as_int = mode_mv[this_mode][ref].as_int;
                    if NUM_4X4_BLOCKS_WIDE > 1 {
                        bsi.rdstat[BLOCK_ + 1][mode_idx].mvs[ref].as_int = mode_mv[this_mode][ref].as_int;
                    }
                    if NUM_4X4_BLOCKS_HIGH > 1 {
                        bsi.rdstat[BLOCK_ + 2][mode_idx].mvs[ref].as_int = mode_mv[this_mode][ref].as_int;
                    }
                    ref += 1;
                }

                if mv_check_bounds(*x.mv_limits, *mode_mv[this_mode][0].as_mv) != 0 ||
                    HAS_SECOND_RF != 0 && mv_check_bounds(*x.mv_limits, *mode_mv[this_mode][1].as_mv) != 0 {
                    this_mode += 1;
                    continue;
                }

                if filter_idx > 0 {
                    ref_bsi := bsi_buf;
                    subpelmv = 0;
                    have_ref = 1;

                    ref = 0;
                    while ref < 1 + HAS_SECOND_RF {
                        subpelmv |= mv_has_subpel(*mode_mv[this_mode][ref].as_mv);
                        have_ref &=
                            cast(s32) (mode_mv[this_mode][ref].as_int == ref_bsi.rdstat[BLOCK_][mode_idx].mvs[ref].as_int);
                        ref += 1;
                    }

                    if filter_idx > 1 && subpelmv == 0 && have_ref == 0 {
                        ref_bsi = bsi_buf + 1;
                        have_ref = 1;
                        ref = 0;
                        while ref < 1 + HAS_SECOND_RF {
                            have_ref &=
                                cast(s32) (mode_mv[this_mode][ref].as_int == ref_bsi.rdstat[BLOCK_][mode_idx].mvs[ref].as_int);
                            ref += 1;
                        }
                    }

                    if subpelmv == 0 && have_ref != 0 && ref_bsi.rdstat[BLOCK_][mode_idx].brdcost < 9223372036854775807 {
                        assignment_13: SEG_RDSTAT = ref_bsi.rdstat[BLOCK_][mode_idx];
                        ((bsi.rdstat[BLOCK_].data + mode_idx).*) = assignment_13;
                        if NUM_4X4_BLOCKS_WIDE > 1 {
                            bsi.rdstat[BLOCK_ + 1][mode_idx].eobs = ref_bsi.rdstat[BLOCK_ + 1][mode_idx].eobs;
                        }
                        if NUM_4X4_BLOCKS_HIGH > 1 {
                            bsi.rdstat[BLOCK_ + 2][mode_idx].eobs = ref_bsi.rdstat[BLOCK_ + 2][mode_idx].eobs;
                        }

                        if bsi.rdstat[BLOCK_][mode_idx].brdcost < best_rd {
                            mode_selected = this_mode;
                            best_rd = bsi.rdstat[BLOCK_][mode_idx].brdcost;
                        }
                        this_mode += 1;
                        continue;
                    }
                }

                bsi.rdstat[BLOCK_][mode_idx].brdcost =
                    encode_inter_mb_segment(
                        cpi,
                        x,
                        bsi.segment_rd - this_segment_rd,
                        BLOCK_,
                        *bsi.rdstat[BLOCK_][mode_idx].byrate,
                        *bsi.rdstat[BLOCK_][mode_idx].bdist,
                        *bsi.rdstat[BLOCK_][mode_idx].bsse,
                        bsi.rdstat[BLOCK_][mode_idx].ta.data,
                        bsi.rdstat[BLOCK_][mode_idx].tl.data,
                        mi_row,
                        mi_col
                    );
                if bsi.rdstat[BLOCK_][mode_idx].brdcost < 9223372036854775807 {
                    bsi.rdstat[BLOCK_][mode_idx].brdcost +=
                        ((((cast,no_check(s64) bsi.rdstat[BLOCK_][mode_idx].brate) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                            cast(s64) ((cast(s32) 0) << ((x.rddiv) & 31));
                    bsi.rdstat[BLOCK_][mode_idx].brate += bsi.rdstat[BLOCK_][mode_idx].byrate;
                    bsi.rdstat[BLOCK_][mode_idx].eobs = cast,no_check(s32) P.eobs[BLOCK_];
                    if NUM_4X4_BLOCKS_WIDE > 1 {
                        bsi.rdstat[BLOCK_ + 1][mode_idx].eobs = cast,no_check(s32) P.eobs[BLOCK_ + 1];
                    }
                    if NUM_4X4_BLOCKS_HIGH > 1 {
                        bsi.rdstat[BLOCK_ + 2][mode_idx].eobs = cast,no_check(s32) P.eobs[BLOCK_ + 2];
                    }
                }

                if bsi.rdstat[BLOCK_][mode_idx].brdcost < best_rd {
                    mode_selected = this_mode;
                    best_rd = bsi.rdstat[BLOCK_][mode_idx].brdcost;
                }
                this_mode += 1;
            }

            if best_rd == 9223372036854775807 {
                midx: s32 = ---;
                iy := BLOCK_ + 1;
                while iy < 4 {
                    midx = 0;
                    while midx < (cast,no_check(s32) ((1 + 13))) - 10 {
                        bsi.rdstat[iy][midx].brdcost = 9223372036854775807;
                        midx += 1;
                    }
                    iy += 1;
                }
                bsi.segment_rd = 9223372036854775807;
                return 9223372036854775807;
            }

            mode_idx = (cast(s32) mode_selected) - 10;
            copy_memory(t_above.data, bsi.rdstat[BLOCK_][mode_idx].ta.data, t_above.count);
            copy_memory(t_left.data, bsi.rdstat[BLOCK_][mode_idx].tl.data, t_left.count);

            set_and_cost_bmi_mvs(
                cpi,
                x,
                xd,
                BLOCK_,
                mode_selected,
                mode_mv[mode_selected].data,
                frame_mv.data,
                seg_mvs[BLOCK_].data,
                bsi.ref_mv.data,
                x.nmvjointcost.data,
                x.mvcost
            );

            br += bsi.rdstat[BLOCK_][mode_idx].brate;
            bd += bsi.rdstat[BLOCK_][mode_idx].bdist;
            block_sse += bsi.rdstat[BLOCK_][mode_idx].bsse;
            segmentyrate += bsi.rdstat[BLOCK_][mode_idx].byrate;
            this_segment_rd += bsi.rdstat[BLOCK_][mode_idx].brdcost;

            if this_segment_rd > bsi.segment_rd {
                midx: s32 = ---;
                iy := BLOCK_ + 1;
                while iy < 4 {
                    midx = 0;
                    while midx < (cast,no_check(s32) ((1 + 13))) - 10 {
                        bsi.rdstat[iy][midx].brdcost = 9223372036854775807;
                        midx += 1;
                    }
                    iy += 1;
                }
                bsi.segment_rd = 9223372036854775807;
                return 9223372036854775807;
            }
            idx += NUM_4X4_BLOCKS_WIDE;
        }
        idy += NUM_4X4_BLOCKS_HIGH;
    }

    bsi.r = br;
    bsi.d = bd;
    bsi.segment_yrate = segmentyrate;
    bsi.segment_rd = this_segment_rd;
    bsi.sse = block_sse;

    for k: 0..cast(s32) 4 - 1 {
        bsi.modes[k] = mi.bmi[k].as_mode;
    }

    if bsi.segment_rd > best_rd_so_far {
        return 9223372036854775807;
    }

    for i: 0..cast(s32) 4 - 1 {
        mode_idx = (cast(s32) bsi.modes[i]) - 10;
        mi.bmi[i].as_mv[0].as_int = bsi.rdstat[i][mode_idx].mvs[0].as_int;
        if has_second_ref_in_vp9_rdopt(mi) != 0 {
            mi.bmi[i].as_mv[1].as_int = bsi.rdstat[i][mode_idx].mvs[1].as_int;
        }
        x.plane[0].eobs[i] = cast,no_check(u16) bsi.rdstat[i][mode_idx].eobs;
        mi.bmi[i].as_mode = bsi.modes[i];
    }

    returntotrate.* = bsi.r;
    returndistortion.* = bsi.d;
    returnyrate.* = bsi.segment_yrate;
    skippable.* = vp9_is_skippable_in_plane(x, 3, 0);
    psse.* = bsi.sse;
    mi.mode = bsi.modes[3];

    return bsi.segment_rd;
}

set_and_cost_bmi_mvs :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    xd: *MACROBLOCKD,
    i: s32,
    mode: PREDICTION_MODE,
    this_mv: *Int_Mv,
    frame_mv: *[4] Int_Mv,
    seg_mvs: *Int_Mv,
    best_ref_mv: **Int_Mv,
    mvjcost: *s32,
    mvcost: **s32
) -> s32 {
    MI := xd.mi[0];
    MBMI_EXT := x.mbmi_ext;
    thismvcost: s32 = 0;
    idx: s32 = ---;
    NUM_4X4_BLOCKS_WIDE := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[MI.sb_type];
    NUM_4X4_BLOCKS_HIGH := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[MI.sb_type];
    IS_COMPOUND := has_second_ref_in_vp9_rdopt(MI);

    if cast,no_check(s32) mode == {
        case 13;
            this_mv[0].as_int = seg_mvs[MI.ref_frame[0]].as_int;
            thismvcost += vp9_mv_bit_cost(*this_mv[0].as_mv, *best_ref_mv[0].as_mv, mvjcost, mvcost, 120);
            if IS_COMPOUND != 0 {
                this_mv[1].as_int = seg_mvs[MI.ref_frame[1]].as_int;
                thismvcost += vp9_mv_bit_cost(*this_mv[1].as_mv, *best_ref_mv[1].as_mv, mvjcost, mvcost, 120);
            }
        case 11; #through;
        case 10;
            this_mv[0].as_int = frame_mv[mode][MI.ref_frame[0]].as_int;
            if IS_COMPOUND != 0 {
                this_mv[1].as_int = frame_mv[mode][MI.ref_frame[1]].as_int;
            }
        case;
            this_mv[0].as_int = 0;
            if IS_COMPOUND != 0 {
                this_mv[1].as_int = 0;
            }
    }

    MI.bmi[i].as_mv[0].as_int = this_mv[0].as_int;
    if IS_COMPOUND != 0 {
        MI.bmi[i].as_mv[1].as_int = this_mv[1].as_int;
    }

    MI.bmi[i].as_mode = mode;

    if 0 < NUM_4X4_BLOCKS_HIGH {
        for idy: 0..NUM_4X4_BLOCKS_HIGH - 1 {
            idx = 0;
            while idx < NUM_4X4_BLOCKS_WIDE {
                move_memory(MI.bmi.data + i + idy * 2 + idx, MI.bmi.data + i, size_of(B_Mode_Info));
                idx += 1;
            }
        }
    }

    return cost_mv_ref(cpi, mode, cast,no_check(s32) MBMI_EXT.mode_context[MI.ref_frame[0]]) + thismvcost;
}

encode_inter_mb_segment :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    best_yrd: s64,
    i: s32,
    labelyrate: *s32,
    distortion: *s64,
    sse: *s64,
    ta: *ENTROPY_CONTEXT,
    tl: *ENTROPY_CONTEXT,
    mi_row: s32,
    mi_col: s32
) -> s64 {
    xd := *x.e_mbd;
    PD := xd.plane.data + 0;
    P := x.plane.data + 0;
    MI := xd.mi[0];
    PLANE_BSIZE := get_plane_block_size_in_vp9_rdopt(MI.sb_type, PD);
    WIDTH := 4 * cast(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE];
    HEIGHT := 4 * cast(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE];
    idx: s32 = ---;

    SRC := *P.src.buf[vp9_raster_block_offset(3, i, P.src.stride)];
    DST := *PD.dst.buf[vp9_raster_block_offset(3, i, PD.dst.stride)];
    thisdistortion: s64 = 0;
    thissse: s64 = 0;
    thisrate: s32 = 0;
    so := VP9_DEFAULT_SCAN_ORDERS.data + 0;
    IS_COMPOUND := has_second_ref_in_vp9_rdopt(MI);
    kernel := vp9_filter_kernels[MI.interp_filter];

    ref: s32 = 0;
    while ref < 1 + IS_COMPOUND {
        BW := cast,no_check(s32) B_WIDTH_LOG2_LOOKUP[3];
        H := 4 * i >> ((BW) & 31);
        W := 4 * i & ((cast(s32) 1) << ((BW) & 31) - 1);
        sf := *xd.block_refs[ref].sf;
        y_stride := PD.pre[ref].stride;
        pre := PD.pre[ref].buf + (H * PD.pre[ref].stride + W);

        if vp9_is_scaled_in_vp9_rdopt(sf) != 0 {
            X_START := -xd.mb_to_left_edge >> (((3 + PD.subsampling_x)) & 31);
            Y_START := -xd.mb_to_top_edge >> (((3 + PD.subsampling_y)) & 31);

            y_stride = xd.block_refs[ref].buf.y_stride;
            pre = xd.block_refs[ref].buf.y_buffer;
            pre += scaled_buffer_offset_in_vp9_rdopt(X_START + W, Y_START + H, y_stride, sf);
        }

        vp9_build_inter_predictor(
            pre,
            y_stride,
            DST,
            PD.dst.stride,
            *MI.bmi[i].as_mv[ref].as_mv,
            *xd.block_refs[ref].sf,
            WIDTH,
            HEIGHT,
            ref,
            kernel,
            cast,no_check(Mv_Precision) MV_PRECISION_Q3,
            mi_col * (cast(s32) 1) << 3 + 4 * (i % 2),
            mi_row * (cast(s32) 1) << 3 + 4 * (i / 2)
        );
        ref += 1;
    }

    subtract_block_c(
        HEIGHT,
        WIDTH,
        vp9_raster_block_offset_int16(3, i, P.src_diff.data),
        8,
        SRC,
        cast,no_check(s64) P.src.stride,
        DST,
        cast,no_check(s64) PD.dst.stride
    );

    k := i;
    idy: s32 = 0;
    while idy < HEIGHT / 4 {
        idx = 0;
        while idx < WIDTH / 4 {
            ssz: s64 = ---;

            k += idy * 2 + idx;
            coeff_ctx := combine_entropy_contexts_in_vp9_rdopt(ta[k & 1], tl[k >> 1]);
            coeff := P.coeff + k * 16;
            qcoeff := P.qcoeff + k * 16;
            dqcoeff := PD.dqcoeff + k * 16;
            eob := *P.eobs[k];

            x.fwd_txfm4x4(vp9_raster_block_offset_int16(3, k, P.src_diff.data), coeff, 8);

            quantize_b_c(coeff, 4 * 4, P, qcoeff, dqcoeff, PD.dequant, eob, so);
            thisdistortion += vp9_block_error_c(coeff, PD.dqcoeff + k * 16, 16, *ssz);

            thissse += ssz;
            thisrate +=
                cost_coeffs_in_vp9_rdopt(
                    x,
                    0,
                    k,
                    0,
                    coeff_ctx,
                    so.scan,
                    so.neighbors,
                    cpi.sf.use_fast_coef_costing
                );
            tl[k >> 1] = cast(ENTROPY_CONTEXT) (x.plane[0].eobs[k] > 0);
            ta[k & 1] = tl[k >> 1];
            rd1 :=
                ((((cast,no_check(s64) thisrate) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                    thisdistortion >> 2 << ((x.rddiv) & 63);
            rd2 :=
                (((0 * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                    thissse >> 2 << ((x.rddiv) & 63);
            rd := min(rd1, rd2);
            if rd >= best_yrd {
                return 9223372036854775807;
            }
            idx += 1;
        }
        idy += 1;
    }

    distortion.* = thisdistortion >> 2;
    labelyrate.* = thisrate;
    sse.* = thissse >> 2;

    return ((((cast,no_check(s64) labelyrate.*) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + distortion.* << ((x.rddiv) & 63);
}

mi_buf_restore :: (x: *MACROBLOCK, orig_src: Buf_2d, orig_pre: *Buf_2d) {
    mi := x.e_mbd.mi[0];
    x.plane[0].src = orig_src;
    x.e_mbd.plane[0].pre[0] = orig_pre[0];
    if has_second_ref_in_vp9_rdopt(mi) != 0 {
        x.e_mbd.plane[0].pre[1] = orig_pre[1];
    }
}

mi_buf_shift :: (x: *MACROBLOCK, i: s32) {
    MI := x.e_mbd.mi[0];
    P := x.plane.data + 0;
    PD := x.e_mbd.plane.data + 0;

    P.src.buf = *P.src.buf[vp9_raster_block_offset(3, i, P.src.stride)];

    PD.pre[0].buf = *PD.pre[0].buf[vp9_raster_block_offset(3, i, PD.pre[0].stride)];
    if has_second_ref_in_vp9_rdopt(MI) != 0 {
        PD.pre[1].buf = *PD.pre[1].buf[vp9_raster_block_offset(3, i, PD.pre[1].stride)];
    }
}

globals_initialization_state_for_vp9_rdopt: u32;
initialize_globals_for_vp9_rdopt :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_rdopt);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_rdopt, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_rdopt) != 2 {}
            return;
        }
    }
    K_VP9_REF_FLAG_LIST_in_vp9_rdopt =
        s32.[ 0, cast,no_check(s32) (VP9_LAST_FLAG), cast,no_check(s32) (VP9_GOLD_FLAG), cast,no_check(s32) (VP9_ALT_FLAG) ];
    SUB_PEL_FILTERS_12_in_vp9_rdopt =
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
    COSPI_1_64_in_vp9_rdopt = 16364;
    COSPI_2_64_in_vp9_rdopt = 16305;
    COSPI_3_64_in_vp9_rdopt = 16207;
    COSPI_4_64_in_vp9_rdopt = 16069;
    COSPI_5_64_in_vp9_rdopt = 15893;
    COSPI_6_64_in_vp9_rdopt = 15679;
    COSPI_7_64_in_vp9_rdopt = 15426;
    COSPI_8_64_in_vp9_rdopt = 15137;
    COSPI_9_64_in_vp9_rdopt = 14811;
    COSPI_10_64_in_vp9_rdopt = 14449;
    COSPI_11_64_in_vp9_rdopt = 14053;
    COSPI_12_64_in_vp9_rdopt = 13623;
    COSPI_13_64_in_vp9_rdopt = 13160;
    COSPI_14_64_in_vp9_rdopt = 12665;
    COSPI_15_64_in_vp9_rdopt = 12140;
    COSPI_16_64_in_vp9_rdopt = 11585;
    COSPI_17_64_in_vp9_rdopt = 11003;
    COSPI_18_64_in_vp9_rdopt = 10394;
    COSPI_19_64_in_vp9_rdopt = 9760;
    COSPI_20_64_in_vp9_rdopt = 9102;
    COSPI_21_64_in_vp9_rdopt = 8423;
    COSPI_22_64_in_vp9_rdopt = 7723;
    COSPI_23_64_in_vp9_rdopt = 7005;
    COSPI_24_64_in_vp9_rdopt = 6270;
    COSPI_25_64_in_vp9_rdopt = 5520;
    COSPI_26_64_in_vp9_rdopt = 4756;
    COSPI_27_64_in_vp9_rdopt = 3981;
    COSPI_28_64_in_vp9_rdopt = 3196;
    COSPI_29_64_in_vp9_rdopt = 2404;
    COSPI_30_64_in_vp9_rdopt = 1606;
    COSPI_31_64_in_vp9_rdopt = 804;
    SINPI_1_9_in_vp9_rdopt = 5283;
    SINPI_2_9_in_vp9_rdopt = 9929;
    SINPI_3_9_in_vp9_rdopt = 13377;
    SINPI_4_9_in_vp9_rdopt = 15212;
    COUNT_TO_UPDATE_FACTOR_in_vp9_rdopt =
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
    MODE_2_COUNTER_in_vp9_rdopt =
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
    COUNTER_TO_CONTEXT_in_vp9_rdopt =
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
    MV_REF_BLOCKS_in_vp9_rdopt =
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
    IDX_N_COLUMN_TO_SUBBLOCK_in_vp9_rdopt =
        [2] s32.[
            s32.[ 1, 2 ],
            s32.[ 1, 3 ],
            s32.[ 3, 2 ],
            s32.[ 3, 3 ]
        ];
    FRAME_SCALE_FACTOR_in_vp9_rdopt = s32.[ 16, 24 ];
    RATE_THRESH_MULT_in_vp9_rdopt = float64.[ 1.0, 2.0 ];
    RCF_MULT_in_vp9_rdopt = float64.[ 1.0, 2.0 ];
    VP9_MODE_ORDER =
        MODE_DEFINITION.[
            MODE_DEFINITION.{mode = 10, ref_frame = MV_REFERENCE_FRAME.[ 1, -1 ]},
            MODE_DEFINITION.{mode = 10, ref_frame = MV_REFERENCE_FRAME.[ 3, -1 ]},
            MODE_DEFINITION.{mode = 10, ref_frame = MV_REFERENCE_FRAME.[ 2, -1 ]},
            MODE_DEFINITION.{mode = 0, ref_frame = MV_REFERENCE_FRAME.[ 0, -1 ]},
            MODE_DEFINITION.{mode = 13, ref_frame = MV_REFERENCE_FRAME.[ 1, -1 ]},
            MODE_DEFINITION.{mode = 13, ref_frame = MV_REFERENCE_FRAME.[ 3, -1 ]},
            MODE_DEFINITION.{mode = 13, ref_frame = MV_REFERENCE_FRAME.[ 2, -1 ]},
            MODE_DEFINITION.{mode = 11, ref_frame = MV_REFERENCE_FRAME.[ 1, -1 ]},
            MODE_DEFINITION.{mode = 11, ref_frame = MV_REFERENCE_FRAME.[ 3, -1 ]},
            MODE_DEFINITION.{mode = 11, ref_frame = MV_REFERENCE_FRAME.[ 2, -1 ]},
            MODE_DEFINITION.{mode = 12, ref_frame = MV_REFERENCE_FRAME.[ 1, -1 ]},
            MODE_DEFINITION.{mode = 12, ref_frame = MV_REFERENCE_FRAME.[ 2, -1 ]},
            MODE_DEFINITION.{mode = 12, ref_frame = MV_REFERENCE_FRAME.[ 3, -1 ]},
            MODE_DEFINITION.{mode = 10, ref_frame = MV_REFERENCE_FRAME.[ 1, 3 ]},
            MODE_DEFINITION.{mode = 10, ref_frame = MV_REFERENCE_FRAME.[ 2, 3 ]},
            MODE_DEFINITION.{mode = 9, ref_frame = MV_REFERENCE_FRAME.[ 0, -1 ]},
            MODE_DEFINITION.{mode = 11, ref_frame = MV_REFERENCE_FRAME.[ 1, 3 ]},
            MODE_DEFINITION.{mode = 13, ref_frame = MV_REFERENCE_FRAME.[ 1, 3 ]},
            MODE_DEFINITION.{mode = 11, ref_frame = MV_REFERENCE_FRAME.[ 2, 3 ]},
            MODE_DEFINITION.{mode = 13, ref_frame = MV_REFERENCE_FRAME.[ 2, 3 ]},
            MODE_DEFINITION.{mode = 12, ref_frame = MV_REFERENCE_FRAME.[ 1, 3 ]},
            MODE_DEFINITION.{mode = 12, ref_frame = MV_REFERENCE_FRAME.[ 2, 3 ]},
            MODE_DEFINITION.{mode = 2, ref_frame = MV_REFERENCE_FRAME.[ 0, -1 ]},
            MODE_DEFINITION.{mode = 1, ref_frame = MV_REFERENCE_FRAME.[ 0, -1 ]},
            MODE_DEFINITION.{mode = 4, ref_frame = MV_REFERENCE_FRAME.[ 0, -1 ]},
            MODE_DEFINITION.{mode = 7, ref_frame = MV_REFERENCE_FRAME.[ 0, -1 ]},
            MODE_DEFINITION.{mode = 6, ref_frame = MV_REFERENCE_FRAME.[ 0, -1 ]},
            MODE_DEFINITION.{mode = 8, ref_frame = MV_REFERENCE_FRAME.[ 0, -1 ]},
            MODE_DEFINITION.{mode = 5, ref_frame = MV_REFERENCE_FRAME.[ 0, -1 ]},
            MODE_DEFINITION.{mode = 3, ref_frame = MV_REFERENCE_FRAME.[ 0, -1 ]}
        ];
    VP9_REF_ORDER =
        REF_DEFINITION.[
            REF_DEFINITION.{ref_frame = MV_REFERENCE_FRAME.[ 1, -1 ]},
            REF_DEFINITION.{ref_frame = MV_REFERENCE_FRAME.[ 2, -1 ]},
            REF_DEFINITION.{ref_frame = MV_REFERENCE_FRAME.[ 3, -1 ]},
            REF_DEFINITION.{ref_frame = MV_REFERENCE_FRAME.[ 1, 3 ]},
            REF_DEFINITION.{ref_frame = MV_REFERENCE_FRAME.[ 2, 3 ]},
            REF_DEFINITION.{ref_frame = MV_REFERENCE_FRAME.[ 0, -1 ]}
        ];
    BAND_COUNTS =
        [8] s16.[
            s16.[ 1, 2, 3, 4, 3, cast,no_check(s16) (16 - 13), 0, cast,no_check(s16) 0 ],
            s16.[ 1, 2, 3, 4, 11, cast,no_check(s16) (64 - 21), 0, cast,no_check(s16) 0 ],
            s16.[ 1, 2, 3, 4, 11, cast,no_check(s16) (256 - 21), 0, cast,no_check(s16) 0 ],
            s16.[ 1, 2, 3, 4, 11, cast,no_check(s16) (1024 - 21), 0, cast,no_check(s16) 0 ]
        ];
    max_var_adjust = u32.[ 16, 16, 250 ];
    atomic_store(*globals_initialization_state_for_vp9_rdopt, 2);
}

MODE_SEARCH_SKIP_LOGIC :: u32;
FLAG_EARLY_TERMINATE : s32 : 1;
FLAG_SKIP_COMP_BESTINTRA : s32 : 2;
FLAG_SKIP_INTRA_BESTINTER : s32 : 8;
FLAG_SKIP_INTRA_DIRMISMATCH : s32 : 16;
FLAG_SKIP_INTRA_LOWVAR : s32 : 32;

INTER_Values :: u32;
INTER_ALL : s32 : 15360;
INTER_NEAREST : s32 : 1024;
INTER_NEAREST_NEW : s32 : 9216;
INTER_NEAREST_ZERO : s32 : 5120;
INTER_NEAREST_NEW_ZERO : s32 : 13312;
INTER_NEAREST_NEAR_NEW : s32 : 11264;
INTER_NEAREST_NEAR_ZERO : s32 : 7168;

THR_MODES_SUB8_X8 :: u32;
THR_LAST : s32 : 0;
THR_GOLD : s32 : 1;
THR_ALTR : s32 : 2;
THR_COMP_LA : s32 : 3;
THR_COMP_GA : s32 : 4;
THR_INTRA : s32 : 5;

