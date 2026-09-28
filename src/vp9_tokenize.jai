Is_Skippable_Args :: struct {
    eobs: *u16;
    skippable: *s32;
}

Tokenize_B_Args :: struct {
    cpi: *VP9_COMP_in_vp9_encoder;
    td: *Thread_Data_in_vp9_encoder;
    tp: **TOKENEXTRA_in_vp9_cx_iface;
}

COUNT_TO_UPDATE_FACTOR_in_vp9_tokenize: [21] s32;

SUB_PEL_FILTERS_12_in_vp9_tokenize: [16] Interp_Kernel12 #align 256;

FRAME_SCALE_FACTOR_in_vp9_tokenize: [2] s32;

RATE_THRESH_MULT_in_vp9_tokenize: [2] float64;

RCF_MULT_in_vp9_tokenize: [2] float64;

VP9_COEF_TREE: [22] Tree_Index;

VP9_COEF_ENCODINGS: [12] Vp9_Token;

vp9_dct_cat_lt_10_value_tokens: *TOKENVALUE_in_vp9_cx_iface;

DCT_CAT_LT_10_VALUE_TOKENS: [133] TOKENVALUE_in_vp9_cx_iface;

VP9_EXTRA_BITS: [12] Vp9_Extra_Bit;

ZERO_COST: [1] s16;

CAT5_COST: [32] s16;

CAT4_COST: [16] s16;

CAT3_COST: [8] s16;

CAT2_COST: [4] s16;

CAT1_COST: [2] s16;

SIGN_COST: [1] s16;

vp9_dct_cat_lt_10_value_cost: *s32;

DCT_CAT_LT_10_VALUE_COST: [133] s32;

VP9_CAT6_LOW_COST: [256] s16;

VP9_CAT6_HIGH_COST: [64] u16;

K_VP9_REF_FLAG_LIST_in_vp9_tokenize: [4] s32;

clip_pixel_in_vp9_tokenize :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_tokenize :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_tokenize :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_tokenize :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_tokenize :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_tokenize(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_tokenize(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_tokenize(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_tokenize :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_prob_in_vp9_tokenize :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_tokenize :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_tokenize(n0, DEN);
}

weighted_prob_in_vp9_tokenize :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_tokenize :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_tokenize(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_tokenize(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_tokenize :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_tokenize[COUNT];
        PROB := get_prob_in_vp9_tokenize(ct[0], DEN);
        return weighted_prob_in_vp9_tokenize(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_lsb_in_vp9_tokenize :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_tokenize :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_tokenize :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_tokenize(num_values) + 1 else 0;
}

get_band_translate_in_vp9_tokenize :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_tokenize :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_tokenize :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_tokenize(above_ec, left_ec);
}

is_zero_mv_in_vp9_tokenize :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_tokenize :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_tokenize :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_tokenize(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_tokenize(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_tokenize :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_tokenize :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_tokenize :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_tokenize :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

get_filter_taps_in_vp9_tokenize :: (FILTER: *s16) -> s32 {
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

vp9_is_valid_scale_in_vp9_tokenize :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_tokenize :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_tokenize(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_tokenize :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_tokenize :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_tokenize :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_tokenize :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_tokenize :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_tokenize :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_tokenize :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_tokenize :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_tokenize :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_tokenize :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_tokenize :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_tokenize(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_tokenize :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_tokenize(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_tokenize(MI, ib)];
}

get_uv_tx_size_in_vp9_tokenize :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_tokenize :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_tokenize :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_tokenize(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_tokenize :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_tokenize :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_tokenize :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_tokenize :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_tokenize :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_tokenize :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_tokenize :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_tokenize :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_tokenize :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_tokenize :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_tokenize :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_tokenize :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_tokenize :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_tokenize(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_tokenize :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_tokenize(cm.mi_cols);

        if get_plane_type_in_vp9_tokenize(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_tokenize(cm, xd);
}

get_partition_probs_in_vp9_tokenize :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_tokenize :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_tokenize :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_tokenize :: (
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

update_partition_context_in_vp9_tokenize :: (
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

partition_plane_context_in_vp9_tokenize :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

get_segment_id_in_vp9_tokenize :: (
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

vp9_get_pred_context_seg_id_in_vp9_tokenize :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    ABOVE_SIP := (ifx ABOVE_MI != null then cast,no_check(s32) ABOVE_MI.seg_id_predicted else 0);
    LEFT_SIP := (ifx LEFT_MI != null then cast,no_check(s32) LEFT_MI.seg_id_predicted else 0);

    return ABOVE_SIP + LEFT_SIP;
}

vp9_get_pred_prob_seg_id_in_vp9_tokenize :: (seg: *Segmentation, xd: *MACROBLOCKD) -> Prob {
    return seg.pred_probs[vp9_get_pred_context_seg_id_in_vp9_tokenize(xd)];
}

vp9_get_skip_context_in_vp9_tokenize :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    ABOVE_SKIP := (ifx ABOVE_MI != null then cast,no_check(s32) ABOVE_MI.skip else 0);
    LEFT_SKIP := (ifx LEFT_MI != null then cast,no_check(s32) LEFT_MI.skip else 0);
    return ABOVE_SKIP + LEFT_SKIP;
}

vp9_get_skip_prob_in_vp9_tokenize :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.skip_probs[vp9_get_skip_context_in_vp9_tokenize(xd)];
}

get_pred_context_switchable_interp_in_vp9_tokenize :: (xd: *MACROBLOCKD) -> s32 {
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

get_intra_inter_context_in_vp9_tokenize :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    HAS_ABOVE := cast(s32) (ABOVE_MI != null);
    HAS_LEFT := cast(s32) (LEFT_MI != null);

    if HAS_ABOVE != 0 && HAS_LEFT != 0 {
        ABOVE_INTRA := cast(s32) (is_inter_block_in_vp9_tokenize(ABOVE_MI) == 0);
        LEFT_INTRA := cast(s32) (is_inter_block_in_vp9_tokenize(LEFT_MI) == 0);
        return ifx LEFT_INTRA != 0 && ABOVE_INTRA != 0 then 3 else cast(s32) (LEFT_INTRA != 0 || ABOVE_INTRA != 0);
    } else if HAS_ABOVE != 0 || HAS_LEFT != 0 {
        return 2 * cast(s32) (is_inter_block_in_vp9_tokenize((ifx HAS_ABOVE != 0 then ABOVE_MI else LEFT_MI)) == 0);
    }
    return 0;
}

vp9_get_intra_inter_prob_in_vp9_tokenize :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.intra_inter_prob[get_intra_inter_context_in_vp9_tokenize(xd)];
}

vp9_get_reference_mode_prob_in_vp9_tokenize :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.comp_inter_prob[vp9_get_reference_mode_context(cm, xd)];
}

vp9_get_pred_prob_comp_ref_p_in_vp9_tokenize :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    PRED_CONTEXT := vp9_get_pred_context_comp_ref_p(cm, xd);
    return cm.fc.comp_ref_prob[PRED_CONTEXT];
}

vp9_get_pred_prob_single_ref_p1_in_vp9_tokenize :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return ((cm.fc.single_ref_prob[vp9_get_pred_context_single_ref_p1(xd)]).data)[0];
}

vp9_get_pred_prob_single_ref_p2_in_vp9_tokenize :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return ((cm.fc.single_ref_prob[vp9_get_pred_context_single_ref_p2(xd)]).data)[1];
}

get_tx_size_context_in_vp9_tokenize :: (xd: *MACROBLOCKD) -> s32 {
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

get_tx_probs_in_vp9_tokenize :: (max_tx_size: TX_SIZE, ctx: s32, tx_probs: *Tx_Probs) -> *Prob {
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

get_tx_counts_in_vp9_tokenize :: (max_tx_size: TX_SIZE, ctx: s32, tx_counts: *Tx_Counts) -> *u32 {
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

get_coef_context_in_vp9_tokenize :: (neighbors: *s16, token_cache: *u8, c: s32) -> s32 {
    return ((1 + cast(s32) token_cache[neighbors[2 * c + 0]]) + cast(s32) token_cache[neighbors[2 * c + 1]]) >> 1;
}

get_scan_in_vp9_tokenize :: (
    xd: *MACROBLOCKD,
    tx_size: TX_SIZE,
    type: PLANE_TYPE,
    block_idx: s32
) -> *Scan_Order_in_vp9_scan {
    MI := xd.mi[0];

    if is_inter_block_in_vp9_tokenize(MI) != 0 || type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 {
        return VP9_DEFAULT_SCAN_ORDERS.data + tx_size;
    } else {
        MODE_ := get_y_mode_in_vp9_tokenize(MI, block_idx);
        return VP9_SCAN_ORDERS[tx_size].data + INTRA_MODE_TO_TX_TYPE_LOOKUP[MODE_];
    }
}

cost_branch256_in_vp9_tokenize :: (ct: *u32, p: Prob) -> u64 {
    return ((cast,no_check(u64) ct[0]) * cast(u64) VP9_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP9_PROB_COST[256 - cast(s32) p];
}

treed_cost_in_vp9_tokenize :: (tree: *Tree_Index, probs: *Prob, bits: s32, len: s32) -> s32 {
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

vp8_set_reference_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_vp9_tokenize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

gcd_in_vp9_tokenize :: (a: s64, b: s32) -> s32 {
    while b != 0 {
        r := cast,no_check(s32) (a % cast(s64) b);
        a = cast,no_check(s64) b;
        b = r;
    }

    return cast,no_check(s32) a;
}

reduce_ratio_in_vp9_tokenize :: (ratio: *Rational64_T) {
    DENOM := gcd_in_vp9_tokenize(ratio.num, ratio.den);
    ratio.num /= cast,no_check(s64) DENOM;
    ratio.den /= DENOM;
}

cyclic_refresh_segment_id_boosted_in_vp9_tokenize :: (segment_id: s32) -> s32 {
    if segment_id == 1 || segment_id == 2 {
        return 1;
    }
    return 0;
}

cyclic_refresh_segment_id_in_vp9_tokenize :: (segment_id: s32) -> s32 {
    if segment_id == 1 {
        return 1;
    } else if segment_id == 2 {
        return 2;
    } else {
        return 0;
    }
}

fps_init_first_pass_info_in_vp9_tokenize :: (
    first_pass_info: *FIRST_PASS_INFO,
    stats: *FIRSTPASS_STATS_in_vp9_cx_iface,
    num_frames: s32
) {
    first_pass_info.stats = stats;
    first_pass_info.num_frames = num_frames;
}

fps_get_num_frames_in_vp9_tokenize :: (first_pass_info: *FIRST_PASS_INFO) -> s32 {
    return first_pass_info.num_frames;
}

fps_get_frame_stats_in_vp9_tokenize :: (
    first_pass_info: *FIRST_PASS_INFO,
    show_idx: s32
) -> *FIRSTPASS_STATS_in_vp9_cx_iface {
    if show_idx < 0 || show_idx >= first_pass_info.num_frames {
        return null;
    }
    return *(cast(*FIRSTPASS_STATS_in_vp9_cx_iface) (first_pass_info.stats))[show_idx];
}

get_buf_from_mv_in_vp9_tokenize :: (buf: *Buf_2d, mv: *MV) -> *u8 {
    return *buf.buf[(cast(s32) mv.row) * buf.stride + cast(s32) mv.col];
}

rd_less_than_thresh_in_vp9_tokenize :: (best_rd: s64, thresh: s32, THRESH_FACT: *s32) -> s32 {
    if best_rd < ((cast,no_check(s64) thresh) * cast(s64) THRESH_FACT.*) >> 5 || thresh == 2147483647 {
        return 1;
    }
    return 0;
}

set_error_per_bit_in_vp9_tokenize :: (x: *MACROBLOCK, rdmult: s32) {
    x.errorperbit = rdmult >> 6;
    x.errorperbit += cast(s32) (x.errorperbit == 0);
}

write_in_vp9_tokenize :: (br: *Writer, bit: s32, probability: s32) {
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

write_bit_in_vp9_tokenize :: (w: *Writer, bit: s32) {
    write_in_vp9_tokenize(w, bit, 128);
}

write_literal_in_vp9_tokenize :: (w: *Writer, data: s32, bits: s32) {
    bit := bits - 1;
    while bit >= 0 {
        write_bit_in_vp9_tokenize(w, 1 & (data >> ((bit) & 31)));
        bit -= 1;
    }
}

vp9_write_tree_in_vp9_tokenize :: (w: *Writer, tree: *Tree_Index, probs: *Prob, bits: s32, len: s32, i: Tree_Index) {
    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            write_in_vp9_tokenize(w, BIT, cast,no_check(s32) probs[(cast(s32) i) >> 1]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }
}

vp9_write_token_in_vp9_tokenize :: (w: *Writer, tree: *Tree_Index, probs: *Prob, token: *Vp9_Token) {
    vp9_write_tree_in_vp9_tokenize(w, tree, probs, token.value, token.len, 0);
}

vp9_is_skippable_in_plane :: (x: *MACROBLOCK, bsize: BLOCK_SIZE, plane: s32) -> s32 {
    result: s32 = 1;
    args := Is_Skippable_Args.{eobs = x.plane[plane].eobs, skippable = *result};
    vp9_foreach_transformed_block_in_plane(
        *x.e_mbd,
        bsize,
        plane,
        cast,no_check(Foreach_Transformed_Block_Visitor) is_skippable,
        cast(*void) *args
    );
    return result;
}

is_skippable :: (plane: s32, block: s32, row: s32, col: s32, plane_bsize: BLOCK_SIZE, tx_size: TX_SIZE, argv: *void) {
    args := cast(*Is_Skippable_Args) argv;

    args.skippable[0] &= cast(s32) (args.eobs[block] == 0);
}

vp9_has_high_freq_in_plane :: (x: *MACROBLOCK, bsize: BLOCK_SIZE, plane: s32) -> s32 {
    result: s32 = 0;
    args := Is_Skippable_Args.{eobs = x.plane[plane].eobs, skippable = *result};
    vp9_foreach_transformed_block_in_plane(
        *x.e_mbd,
        bsize,
        plane,
        cast,no_check(Foreach_Transformed_Block_Visitor) has_high_freq_coeff,
        cast(*void) *args
    );
    return result;
}

has_high_freq_coeff :: (
    plane: s32,
    block: s32,
    row: s32,
    col: s32,
    plane_bsize: BLOCK_SIZE,
    tx_size: TX_SIZE,
    argv: *void
) {
    args := cast(*Is_Skippable_Args) argv;
    eobs := (ifx tx_size == cast(TX_SIZE) 0 then cast(s32) 3 else 10);

    args.skippable.* |= cast(s32) (cast,no_check(s32) args.eobs[block] > eobs);
}

vp9_tokenize_sb :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    td: *Thread_Data_in_vp9_encoder,
    t: **TOKENEXTRA_in_vp9_cx_iface,
    dry_run: s32,
    seg_skip: s32,
    bsize: BLOCK_SIZE
) {
    X := *td.mb;
    XD := *X.e_mbd;
    MI := XD.mi[0];
    CTX := vp9_get_skip_context_in_vp9_tokenize(XD);
    arg := Tokenize_B_Args.{cpi = cpi, td = td, tp = t};

    if seg_skip != 0 {
    }

    if MI.skip != 0 {
        if dry_run == 0 && seg_skip == 0 {
            td.counts.skip[CTX][1] += 1;
        }
        reset_skip_context_in_vp9_tokenize(XD, bsize);
        return;
    }

    if dry_run == 0 {
        td.counts.skip[CTX][0] += 1;
        vp9_foreach_transformed_block(
            XD,
            bsize,
            cast,no_check(Foreach_Transformed_Block_Visitor) tokenize_b,
            cast(*void) *arg
        );
    } else {
        vp9_foreach_transformed_block(
            XD,
            bsize,
            cast,no_check(Foreach_Transformed_Block_Visitor) set_entropy_context_b,
            cast(*void) *arg
        );
    }
}

set_entropy_context_b :: (
    plane: s32,
    block: s32,
    row: s32,
    col: s32,
    plane_bsize: BLOCK_SIZE,
    tx_size: TX_SIZE,
    arg: *void
) {
    ARGS := cast(*Tokenize_B_Args) arg;
    TD := ARGS.td;
    X := *TD.mb;
    XD := *X.e_mbd;
    p := X.plane.data + plane;
    pd := XD.plane.data + plane;
    vp9_set_contexts(XD, pd, plane_bsize, tx_size, cast(s32) (p.eobs[block] > 0), col, row);
}

tokenize_b :: (plane: s32, block: s32, row: s32, col: s32, plane_bsize: BLOCK_SIZE, tx_size: TX_SIZE, arg: *void) {
    ARGS := cast(*Tokenize_B_Args) arg;
    cpi := ARGS.cpi;
    TD := ARGS.td;
    X := *TD.mb;
    XD := *X.e_mbd;
    tp := ARGS.tp;
    token_cache: [1024] u8 = ---;
    p := X.plane.data + plane;
    pd := XD.plane.data + plane;
    mi := XD.mi[0];

    t := tp.*;
    eob := cast,no_check(s32) p.eobs[block];
    TYPE := get_plane_type_in_vp9_tokenize(plane);
    qcoeff := p.qcoeff + block * 16;

    REF := is_inter_block_in_vp9_tokenize(mi);
    COUNTS: *[6] [12] u32 = TD.rd_counts.coef_counts[tx_size][TYPE][REF].data;
    COEF_PROBS: *[6] [3] Prob = cpi.common.fc.coef_probs[tx_size][TYPE][REF].data;
    EOB_BRANCH: *[6] u32 = TD.counts.eob_branch[tx_size][TYPE][REF].data;
    BAND := get_band_translate_in_vp9_tokenize(tx_size);
    TX_EOB := (cast(s32) 16) << ((((cast(s32) tx_size) << 1)) & 31);
    token: s16 = ---;
    extra: EXTRABIT = ---;
    pt := get_entropy_context_in_vp9_tokenize(tx_size, pd.above_context + col, pd.left_context + row);
    so := get_scan_in_vp9_tokenize(XD, tx_size, TYPE, block);
    scan := so.scan;
    nb := so.neighbors;
    c: s32 = 0;

    while c < eob {
        v: s32 = 0;
        v = cast,no_check(s32) qcoeff[scan[c]];
        EOB_BRANCH[BAND[c]][pt] += 1;

        while v == 0 {
            add_token_no_extra(*t, COEF_PROBS[BAND[c]][pt].data, 0, COUNTS[BAND[c]][pt].data);

            token_cache[scan[c]] = 0;
            c += 1;
            pt = get_coef_context_in_vp9_tokenize(nb, token_cache.data, c);
            v = cast,no_check(s32) qcoeff[scan[c]];
        }

        vp9_get_token_extra_in_vp9_tokenize(v, *token, *extra);

        add_token(*t, COEF_PROBS[BAND[c]][pt].data, token, extra, COUNTS[BAND[c]][pt].data);

        token_cache[scan[c]] = VP9_PT_ENERGY_CLASS[token];
        c += 1;
        pt = get_coef_context_in_vp9_tokenize(nb, token_cache.data, c);
    }
    if c < TX_EOB {
        EOB_BRANCH[BAND[c]][pt] += 1;
        add_token_no_extra(*t, COEF_PROBS[BAND[c]][pt].data, 11, COUNTS[BAND[c]][pt].data);
    }

    tp.* = t;

    vp9_set_contexts(XD, pd, plane_bsize, tx_size, cast(s32) (c > 0), col, row);
}

add_token_no_extra :: (t: **TOKENEXTRA_in_vp9_cx_iface, context_tree: *Prob, token: s16, counts: *u32) {
    t.*.context_tree = context_tree;
    t.*.token = token;
    t.* += 1;
    counts[token] += 1;
}

add_token :: (t: **TOKENEXTRA_in_vp9_cx_iface, context_tree: *Prob, token: s16, extra: EXTRABIT, counts: *u32) {
    t.*.context_tree = context_tree;
    t.*.token = token;
    t.*.extra = extra;
    t.* += 1;
    counts[token] += 1;
}

vp9_get_token_extra_in_vp9_tokenize :: (v: s32, token: *s16, extra: *EXTRABIT) {
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

vp9_get_high_cost_table_in_vp9_tokenize :: (bit_depth: s32) -> *u16 {
    return VP9_CAT6_HIGH_COST.data;
}

vp9_get_token_in_vp9_tokenize :: (v: s32) -> s16 {
    if v >= 67 || v <= -67 {
        return 10;
    }
    return vp9_dct_cat_lt_10_value_tokens[v].token;
}

vp9_get_token_cost_in_vp9_tokenize :: (v: s32, token: *s16, cat6_high_table: *u16) -> s32 {
    if v >= 67 || v <= -67 {
        token.* = 10;
        extrabits := cast,no_check(EXTRABIT) (absolute_value(v) - 67);
        return (cast(s32) VP9_CAT6_LOW_COST[extrabits & 0xff]) + cast(s32) cat6_high_table[(cast(s32) extrabits) >> 8];
    }
    token.* = vp9_dct_cat_lt_10_value_tokens[v].token;
    return vp9_dct_cat_lt_10_value_cost[v];
}

is_lossless_requested_in_vp9_tokenize :: (cfg: *VP9_Encoder_Config) -> s32 {
    if cfg.best_allowed_q == 0 && cfg.worst_allowed_q == 0 {
        return 1;
    }
    return 0;
}

stack_pop_in_vp9_tokenize :: (stack: *s32, stack_size: s32) -> s32 {
    R := stack[0];
    if 1 < stack_size {
        for idx: 1..stack_size - 1 {
            stack[idx - 1] = stack[idx];
        }
    }

    return R;
}

stack_top_in_vp9_tokenize :: (stack: *s32) -> s32 {
    return stack[0];
}

stack_push_in_vp9_tokenize :: (stack: *s32, new_item: s32, stack_size: s32) {
    idx := stack_size;
    while idx > 0 {
        stack[idx] = stack[idx - 1];
        idx -= 1;
    }
    stack[0] = new_item;
}

stack_init_in_vp9_tokenize :: (stack: *s32, length: s32) {
    if 0 < length {
        for idx: 0..length - 1 {
            stack[idx] = -1;
        }
    }
}

frame_is_kf_gf_arf_in_vp9_tokenize :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if frame_is_intra_only_in_vp9_tokenize(*cpi.common) != 0 ||
        cpi.refresh_alt_ref_frame != 0 ||
        cpi.refresh_golden_frame != 0 && cpi.rc.is_src_frame_alt_ref == 0 {
        return 1;
    }
    return 0;
}

ref_frame_to_flag_in_vp9_tokenize :: (ref_frame: s8) -> s32 {

    return K_VP9_REF_FLAG_LIST_in_vp9_tokenize[ref_frame];
}

get_ref_frame_map_idx_in_vp9_tokenize :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame: MV_REFERENCE_FRAME) -> s32 {
    if ref_frame == 1 {
        return cpi.lst_fb_idx;
    } else if ref_frame == 2 {
        return cpi.gld_fb_idx;
    } else {
        return cpi.alt_fb_idx;
    }
}

get_ref_frame_buf_idx_in_vp9_tokenize :: (CPI: *VP9_COMP_in_vp9_encoder, ref_frame: s32) -> s32 {
    CM := *CPI.common;
    MAP_IDX := get_ref_frame_map_idx_in_vp9_tokenize(CPI, cast,no_check(MV_REFERENCE_FRAME) ref_frame);
    return ifx MAP_IDX != -1 then CM.ref_frame_map[MAP_IDX] else -1;
}

get_ref_cnt_buffer_in_vp9_tokenize :: (cm: *VP9_COMMON, fb_idx: s32) -> *Ref_Cnt_Buffer {
    return ifx fb_idx != -1 then cm.buffer_pool.frame_bufs.data + fb_idx else null;
}

get_ref_frame_bufs_in_vp9_tokenize :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame_bufs: **Ref_Cnt_Buffer) {
    CM := *cpi.common;

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame < 4 {
        ref_frame_buf_idx := get_ref_frame_buf_idx_in_vp9_tokenize(cpi, cast,no_check(s32) ref_frame);
        inter_ref_idx := mv_ref_frame_to_inter_ref_idx_in_vp9_tokenize(ref_frame);
        ref_frame_bufs[inter_ref_idx] = get_ref_cnt_buffer_in_vp9_tokenize(CM, ref_frame_buf_idx);
        ref_frame += 1;
    }
}

get_ref_frame_buffer_in_vp9_tokenize :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    ref_frame: MV_REFERENCE_FRAME
) -> *YV12_BUFFER_CONFIG {
    CM := *CPI.common;
    BUF_IDX := get_ref_frame_buf_idx_in_vp9_tokenize(CPI, cast,no_check(s32) ref_frame);
    return ifx BUF_IDX != -1 then *CM.buffer_pool.frame_bufs[BUF_IDX].buf else null;
}

get_token_alloc_in_vp9_tokenize :: (mb_rows: s32, mb_cols: s32) -> s64 {
    ALIGNED_MB_ROWS :=
        (mb_rows +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    ALIGNED_MB_COLS :=
        (mb_cols +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    return ((cast,no_check(s64) ALIGNED_MB_ROWS) * cast(s64) ALIGNED_MB_COLS) * cast,no_check(s64) ((cast,no_check(s32) ((16 * 16))) * 3 + 4);
}

allocated_tokens_in_vp9_tokenize :: (tile: Tile_Info) -> s64 {
    tile_mb_rows := (tile.mi_row_end - tile.mi_row_start + 1) >> 1;
    tile_mb_cols := (tile.mi_col_end - tile.mi_col_start + 1) >> 1;

    return get_token_alloc_in_vp9_tokenize(tile_mb_rows, tile_mb_cols);
}

get_start_tok_in_vp9_tokenize :: (
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

    tok.* = cpi.tile_tok[tile_row][tile_col] + get_token_alloc_in_vp9_tokenize(MB_ROW, tile_mb_cols);
}

is_one_pass_svc_in_vp9_tokenize :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if CPI.use_svc != 0 && CPI.oxcf.pass == 0 {
        return 1;
    }
    return 0;
}

is_altref_enabled_in_vp9_tokenize :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if !(CPI.oxcf.mode == cast,no_check(u32) REALTIME && CPI.oxcf.rc_mode == cast,no_check(u32) CBR) &&
        CPI.oxcf.lag_in_frames >= 4 &&
        CPI.oxcf.enable_auto_arf != 0 {
        return 1;
    }
    return 0;
}

set_ref_ptrs_in_vp9_tokenize :: (
    CM: *VP9_COMMON,
    xd: *MACROBLOCKD,
    ref0: MV_REFERENCE_FRAME,
    ref1: MV_REFERENCE_FRAME
) {
    xd.block_refs[0] = CM.frame_refs.data + (ifx ref0 >= 1 then (cast(s32) ref0) - 1 else 0);
    xd.block_refs[1] = CM.frame_refs.data + (ifx ref1 >= 1 then (cast(s32) ref1) - 1 else 0);
}

get_chessboard_index_in_vp9_tokenize :: (FRAME_INDEX: s32) -> s32 {
    return FRAME_INDEX & 0x1;
}

cond_cost_list_in_vp9_tokenize :: (cpi: *VP9_COMP_in_vp9_encoder, cost_list: *s32) -> *s32 {
    return ifx cpi.sf.mv.subpel_search_method != cast,no_check(u32) SUBPEL_TREE then cost_list else null;
}

get_num_vert_units_in_vp9_tokenize :: (tile: Tile_Info, shift: s32) -> s32 {
    num_vert_units := (tile.mi_row_end - tile.mi_row_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_vert_units;
}

get_num_cols_in_vp9_tokenize :: (tile: Tile_Info, shift: s32) -> s32 {
    num_cols := (tile.mi_col_end - tile.mi_col_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_cols;
}

get_level_index_in_vp9_tokenize :: (level: VP9_LEVEL) -> s32 {
    for i: 0..cast(s32) 14 - 1 {
        if level == VP9_LEVEL_DEFS[i].level {
            return i;
        }
    }
    return -1;
}

log_tile_cols_from_picsize_level_in_vp9_tokenize :: (width: u32, height: u32) -> s32 {
    PIC_SIZE := width * height;
    PIC_BREADTH := max(width, height);
    for i: 0..cast(s32) 14 - 1 {
        if VP9_LEVEL_DEFS[i].max_luma_picture_size >= PIC_SIZE && VP9_LEVEL_DEFS[i].max_luma_picture_breadth >= PIC_BREADTH {
            return get_msb_in_vp9_tokenize(cast,no_check(u32) VP9_LEVEL_DEFS[i].max_col_tiles);
        }
    }
    return 2147483647;
}

alloc_frame_mvs_in_vp9_tokenize :: (CM: *VP9_COMMON, buffer_idx: s32) {
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

mv_cost_in_vp9_tokenize :: (mv: *MV, joint_cost: *s32, comp_cost: **s32) -> s32 {
    return joint_cost[vp9_get_mv_joint_in_vp9_tokenize(mv)] + comp_cost[0][mv.row] + comp_cost[1][mv.col];
}

mvsad_err_cost_in_vp9_tokenize :: (x: *MACROBLOCK, mv: *MV, ref: *MV, sad_per_bit: s32) -> s32 {
    diff: MV = ---;
    diff.row = cast,no_check(s16) ((cast(s32) mv.row) - cast(s32) ref.row);
    diff.col = cast,no_check(s16) ((cast(s32) mv.col) - cast(s32) ref.col);
    return cast,no_check(s32) ((((cast,no_check(u32) mv_cost_in_vp9_tokenize(*diff, x.nmvjointsadcost.data, x.nmvsadcost.data)) * cast,no_check(u32) sad_per_bit) + cast,no_check(u32) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9);
}

get_start_mv_sad_in_vp9_tokenize :: (
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
    start_mv_sad += cast,no_check(u32) mvsad_err_cost_in_vp9_tokenize(x, mvp_full, ref_mv_full, sadpb);

    return start_mv_sad;
}

num_4x4_to_edge_in_vp9_tokenize :: (
    plane_4x4_dim: s32,
    mb_to_edge_dim: s32,
    subsampling_dim: s32,
    blk_dim: s32
) -> s32 {
    return plane_4x4_dim + mb_to_edge_dim >> (((5 + subsampling_dim)) & 31) - blk_dim;
}

sum_squares_visible_in_vp9_tokenize :: (
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
        num_4x4_to_edge_in_vp9_tokenize(
            PLANE_4X4_W,
            xd.mb_to_right_edge,
            PD.subsampling_x,
            blk_col
        );
    B4X4S_TO_BOTTOM_EDGE :=
        num_4x4_to_edge_in_vp9_tokenize(
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

do_trellis_opt_in_vp9_tokenize :: (
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
                    sum_squares_visible_in_vp9_tokenize(
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

globals_initialization_state_for_vp9_tokenize: u32;
initialize_globals_for_vp9_tokenize :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_tokenize);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_tokenize, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_tokenize) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_vp9_tokenize =
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
    K_VP9_REF_FLAG_LIST_in_vp9_tokenize =
        s32.[ 0, cast,no_check(s32) (VP9_LAST_FLAG), cast,no_check(s32) (VP9_GOLD_FLAG), cast,no_check(s32) (VP9_ALT_FLAG) ];
    SUB_PEL_FILTERS_12_in_vp9_tokenize =
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
    FRAME_SCALE_FACTOR_in_vp9_tokenize = s32.[ 16, 24 ];
    RATE_THRESH_MULT_in_vp9_tokenize = float64.[ 1.0, 2.0 ];
    RCF_MULT_in_vp9_tokenize = float64.[ 1.0, 2.0 ];
    DCT_CAT_LT_10_VALUE_TOKENS =
        TOKENVALUE_in_vp9_cx_iface.[
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 63},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 61},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 59},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 57},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 55},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 53},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 51},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 49},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 47},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 45},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 43},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 41},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 39},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 37},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 35},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 33},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 31},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 29},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 27},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 25},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 23},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 21},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 19},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 17},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 15},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 13},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 11},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 9},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 7},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 5},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 3},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 1},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 31},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 29},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 27},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 25},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 23},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 21},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 19},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 17},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 15},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 13},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 11},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 9},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 7},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 5},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 3},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 1},
            TOKENVALUE_in_vp9_cx_iface.{token = 7, extra = 15},
            TOKENVALUE_in_vp9_cx_iface.{token = 7, extra = 13},
            TOKENVALUE_in_vp9_cx_iface.{token = 7, extra = 11},
            TOKENVALUE_in_vp9_cx_iface.{token = 7, extra = 9},
            TOKENVALUE_in_vp9_cx_iface.{token = 7, extra = 7},
            TOKENVALUE_in_vp9_cx_iface.{token = 7, extra = 5},
            TOKENVALUE_in_vp9_cx_iface.{token = 7, extra = 3},
            TOKENVALUE_in_vp9_cx_iface.{token = 7, extra = 1},
            TOKENVALUE_in_vp9_cx_iface.{token = 6, extra = 7},
            TOKENVALUE_in_vp9_cx_iface.{token = 6, extra = 5},
            TOKENVALUE_in_vp9_cx_iface.{token = 6, extra = 3},
            TOKENVALUE_in_vp9_cx_iface.{token = 6, extra = 1},
            TOKENVALUE_in_vp9_cx_iface.{token = 5, extra = 3},
            TOKENVALUE_in_vp9_cx_iface.{token = 5, extra = 1},
            TOKENVALUE_in_vp9_cx_iface.{token = 4, extra = 1},
            TOKENVALUE_in_vp9_cx_iface.{token = 3, extra = 1},
            TOKENVALUE_in_vp9_cx_iface.{token = 2, extra = 1},
            TOKENVALUE_in_vp9_cx_iface.{token = 1, extra = 1},
            TOKENVALUE_in_vp9_cx_iface.{token = 0, extra = 0},
            TOKENVALUE_in_vp9_cx_iface.{token = 1, extra = 0},
            TOKENVALUE_in_vp9_cx_iface.{token = 2, extra = 0},
            TOKENVALUE_in_vp9_cx_iface.{token = 3, extra = 0},
            TOKENVALUE_in_vp9_cx_iface.{token = 4, extra = 0},
            TOKENVALUE_in_vp9_cx_iface.{token = 5, extra = 0},
            TOKENVALUE_in_vp9_cx_iface.{token = 5, extra = 2},
            TOKENVALUE_in_vp9_cx_iface.{token = 6, extra = 0},
            TOKENVALUE_in_vp9_cx_iface.{token = 6, extra = 2},
            TOKENVALUE_in_vp9_cx_iface.{token = 6, extra = 4},
            TOKENVALUE_in_vp9_cx_iface.{token = 6, extra = 6},
            TOKENVALUE_in_vp9_cx_iface.{token = 7, extra = 0},
            TOKENVALUE_in_vp9_cx_iface.{token = 7, extra = 2},
            TOKENVALUE_in_vp9_cx_iface.{token = 7, extra = 4},
            TOKENVALUE_in_vp9_cx_iface.{token = 7, extra = 6},
            TOKENVALUE_in_vp9_cx_iface.{token = 7, extra = 8},
            TOKENVALUE_in_vp9_cx_iface.{token = 7, extra = 10},
            TOKENVALUE_in_vp9_cx_iface.{token = 7, extra = 12},
            TOKENVALUE_in_vp9_cx_iface.{token = 7, extra = 14},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 0},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 2},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 4},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 6},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 8},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 10},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 12},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 14},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 16},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 18},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 20},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 22},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 24},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 26},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 28},
            TOKENVALUE_in_vp9_cx_iface.{token = 8, extra = 30},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 0},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 2},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 4},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 6},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 8},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 10},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 12},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 14},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 16},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 18},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 20},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 22},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 24},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 26},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 28},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 30},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 32},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 34},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 36},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 38},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 40},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 42},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 44},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 46},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 48},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 50},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 52},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 54},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 56},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 58},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 60},
            TOKENVALUE_in_vp9_cx_iface.{token = 9, extra = 62}
        ];
    vp9_dct_cat_lt_10_value_tokens = DCT_CAT_LT_10_VALUE_TOKENS.data + (cast(u64) DCT_CAT_LT_10_VALUE_TOKENS.count) / 2;
    DCT_CAT_LT_10_VALUE_COST =
        s32.[
            3773,
            3750,
            3704,
            3681,
            3623,
            3600,
            3554,
            3531,
            3432,
            3409,
            3363,
            3340,
            3282,
            3259,
            3213,
            3190,
            3136,
            3113,
            3067,
            3044,
            2986,
            2963,
            2917,
            2894,
            2795,
            2772,
            2726,
            2703,
            2645,
            2622,
            2576,
            2553,
            3197,
            3116,
            3058,
            2977,
            2881,
            2800,
            2742,
            2661,
            2615,
            2534,
            2476,
            2395,
            2299,
            2218,
            2160,
            2079,
            2566,
            2427,
            2334,
            2195,
            2023,
            1884,
            1791,
            1652,
            1893,
            1696,
            1453,
            1256,
            1229,
            864,
            512,
            512,
            512,
            512,
            0,
            512,
            512,
            512,
            512,
            864,
            1229,
            1256,
            1453,
            1696,
            1893,
            1652,
            1791,
            1884,
            2023,
            2195,
            2334,
            2427,
            2566,
            2079,
            2160,
            2218,
            2299,
            2395,
            2476,
            2534,
            2615,
            2661,
            2742,
            2800,
            2881,
            2977,
            3058,
            3116,
            3197,
            2553,
            2576,
            2622,
            2645,
            2703,
            2726,
            2772,
            2795,
            2894,
            2917,
            2963,
            2986,
            3044,
            3067,
            3113,
            3136,
            3190,
            3213,
            3259,
            3282,
            3340,
            3363,
            3409,
            3432,
            3531,
            3554,
            3600,
            3623,
            3681,
            3704,
            3750,
            3773
        ];
    vp9_dct_cat_lt_10_value_cost = DCT_CAT_LT_10_VALUE_COST.data + (cast(u64) DCT_CAT_LT_10_VALUE_COST.count) / 2;
    VP9_COEF_TREE =
        Tree_Index.[
            -11,
            2,
            -0,
            4,
            -1,
            6,
            8,
            12,
            -2,
            10,
            -3,
            -4,
            14,
            16,
            -5,
            -6,
            18,
            20,
            -7,
            -8,
            -9,
            -10
        ];
    SIGN_COST = s16.[ 512 ];
    CAT1_COST = s16.[ 864, 1229 ];
    CAT2_COST = s16.[ 1256, 1453, 1696, 1893 ];
    CAT3_COST =
        s16.[
            1652,
            1791,
            1884,
            2023,
            2195,
            2334,
            2427,
            2566
        ];
    CAT4_COST =
        s16.[
            2079,
            2160,
            2218,
            2299,
            2395,
            2476,
            2534,
            2615,
            2661,
            2742,
            2800,
            2881,
            2977,
            3058,
            3116,
            3197
        ];
    CAT5_COST =
        s16.[
            2553,
            2576,
            2622,
            2645,
            2703,
            2726,
            2772,
            2795,
            2894,
            2917,
            2963,
            2986,
            3044,
            3067,
            3113,
            3136,
            3190,
            3213,
            3259,
            3282,
            3340,
            3363,
            3409,
            3432,
            3531,
            3554,
            3600,
            3623,
            3681,
            3704,
            3750,
            3773
        ];
    VP9_CAT6_LOW_COST =
        s16.[
            3378,
            3390,
            3401,
            3413,
            3435,
            3447,
            3458,
            3470,
            3517,
            3529,
            3540,
            3552,
            3574,
            3586,
            3597,
            3609,
            3671,
            3683,
            3694,
            3706,
            3728,
            3740,
            3751,
            3763,
            3810,
            3822,
            3833,
            3845,
            3867,
            3879,
            3890,
            3902,
            3973,
            3985,
            3996,
            4008,
            4030,
            4042,
            4053,
            4065,
            4112,
            4124,
            4135,
            4147,
            4169,
            4181,
            4192,
            4204,
            4266,
            4278,
            4289,
            4301,
            4323,
            4335,
            4346,
            4358,
            4405,
            4417,
            4428,
            4440,
            4462,
            4474,
            4485,
            4497,
            4253,
            4265,
            4276,
            4288,
            4310,
            4322,
            4333,
            4345,
            4392,
            4404,
            4415,
            4427,
            4449,
            4461,
            4472,
            4484,
            4546,
            4558,
            4569,
            4581,
            4603,
            4615,
            4626,
            4638,
            4685,
            4697,
            4708,
            4720,
            4742,
            4754,
            4765,
            4777,
            4848,
            4860,
            4871,
            4883,
            4905,
            4917,
            4928,
            4940,
            4987,
            4999,
            5010,
            5022,
            5044,
            5056,
            5067,
            5079,
            5141,
            5153,
            5164,
            5176,
            5198,
            5210,
            5221,
            5233,
            5280,
            5292,
            5303,
            5315,
            5337,
            5349,
            5360,
            5372,
            4988,
            5000,
            5011,
            5023,
            5045,
            5057,
            5068,
            5080,
            5127,
            5139,
            5150,
            5162,
            5184,
            5196,
            5207,
            5219,
            5281,
            5293,
            5304,
            5316,
            5338,
            5350,
            5361,
            5373,
            5420,
            5432,
            5443,
            5455,
            5477,
            5489,
            5500,
            5512,
            5583,
            5595,
            5606,
            5618,
            5640,
            5652,
            5663,
            5675,
            5722,
            5734,
            5745,
            5757,
            5779,
            5791,
            5802,
            5814,
            5876,
            5888,
            5899,
            5911,
            5933,
            5945,
            5956,
            5968,
            6015,
            6027,
            6038,
            6050,
            6072,
            6084,
            6095,
            6107,
            5863,
            5875,
            5886,
            5898,
            5920,
            5932,
            5943,
            5955,
            6002,
            6014,
            6025,
            6037,
            6059,
            6071,
            6082,
            6094,
            6156,
            6168,
            6179,
            6191,
            6213,
            6225,
            6236,
            6248,
            6295,
            6307,
            6318,
            6330,
            6352,
            6364,
            6375,
            6387,
            6458,
            6470,
            6481,
            6493,
            6515,
            6527,
            6538,
            6550,
            6597,
            6609,
            6620,
            6632,
            6654,
            6666,
            6677,
            6689,
            6751,
            6763,
            6774,
            6786,
            6808,
            6820,
            6831,
            6843,
            6890,
            6902,
            6913,
            6925,
            6947,
            6959,
            6970,
            6982
        ];
    VP9_CAT6_HIGH_COST =
        u16.[
            88,
            2251,
            2727,
            4890,
            3148,
            5311,
            5787,
            7950,
            3666,
            5829,
            6305,
            8468,
            6726,
            8889,
            9365,
            11528,
            3666,
            5829,
            6305,
            8468,
            6726,
            8889,
            9365,
            11528,
            7244,
            9407,
            9883,
            12046,
            10304,
            12467,
            12943,
            15106,
            3666,
            5829,
            6305,
            8468,
            6726,
            8889,
            9365,
            11528,
            7244,
            9407,
            9883,
            12046,
            10304,
            12467,
            12943,
            15106,
            7244,
            9407,
            9883,
            12046,
            10304,
            12467,
            12943,
            15106,
            10822,
            12985,
            13461,
            15624,
            13882,
            16045,
            16521,
            18684
        ];
    VP9_EXTRA_BITS =
        Vp9_Extra_Bit.[
            Vp9_Extra_Bit.{prob = null, len = 0, base_val = 0, cost = ZERO_COST.data},
            Vp9_Extra_Bit.{prob = null, len = 0, base_val = 1, cost = SIGN_COST.data},
            Vp9_Extra_Bit.{prob = null, len = 0, base_val = 2, cost = SIGN_COST.data},
            Vp9_Extra_Bit.{prob = null, len = 0, base_val = 3, cost = SIGN_COST.data},
            Vp9_Extra_Bit.{prob = null, len = 0, base_val = 4, cost = SIGN_COST.data},
            Vp9_Extra_Bit.{prob = VP9_CAT1_PROB.data, len = 1, base_val = 5, cost = CAT1_COST.data},
            Vp9_Extra_Bit.{prob = VP9_CAT2_PROB.data, len = 2, base_val = 7, cost = CAT2_COST.data},
            Vp9_Extra_Bit.{prob = VP9_CAT3_PROB.data, len = 3, base_val = 11, cost = CAT3_COST.data},
            Vp9_Extra_Bit.{prob = VP9_CAT4_PROB.data, len = 4, base_val = 19, cost = CAT4_COST.data},
            Vp9_Extra_Bit.{prob = VP9_CAT5_PROB.data, len = 5, base_val = 35, cost = CAT5_COST.data},
            Vp9_Extra_Bit.{prob = VP9_CAT6_PROB.data, len = 14, base_val = 67, cost = null},
            Vp9_Extra_Bit.{prob = null, len = 0, base_val = 0, cost = ZERO_COST.data}
        ];
    VP9_COEF_ENCODINGS =
        Vp9_Token.[
            Vp9_Token.{value = 2, len = 2},
            Vp9_Token.{value = 6, len = 3},
            Vp9_Token.{value = 28, len = 5},
            Vp9_Token.{value = 58, len = 6},
            Vp9_Token.{value = 59, len = 6},
            Vp9_Token.{value = 60, len = 6},
            Vp9_Token.{value = 61, len = 6},
            Vp9_Token.{value = 124, len = 7},
            Vp9_Token.{value = 125, len = 7},
            Vp9_Token.{value = 126, len = 7},
            Vp9_Token.{value = 127, len = 7},
            Vp9_Token.{value = 0, len = 1}
        ];
    atomic_store(*globals_initialization_state_for_vp9_tokenize, 2);
}

