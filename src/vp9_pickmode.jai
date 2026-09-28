Estimate_Block_Intra_Args :: struct {
    cpi: *VP9_COMP_in_vp9_encoder;
    x: *MACROBLOCK;
    mode: PREDICTION_MODE;
    skippable: s32;
    rdc: *RD_COST;
}

BEST_PICKMODE :: struct {
    best_pred: *PRED_BUFFER;
    best_mode: PREDICTION_MODE;
    best_tx_size: TX_SIZE;
    best_intra_tx_size: TX_SIZE;
    best_ref_frame: MV_REFERENCE_FRAME;
    best_second_ref_frame: MV_REFERENCE_FRAME;
    best_mode_skip_txfm: u8;
    best_pred_filter: INTERP_FILTER;
}

PRED_BUFFER :: struct {
    data: *u8;
    stride: s32;
    in_use: s32;
}

REF_MODE :: struct {
    ref_frame: MV_REFERENCE_FRAME;
    pred_mode: PREDICTION_MODE;
}

SUB_PEL_FILTERS_12_in_vp9_pickmode: [16] Interp_Kernel12 #align 256;

COUNT_TO_UPDATE_FACTOR_in_vp9_pickmode: [21] s32;

MODE_2_COUNTER_in_vp9_pickmode: [14] s32;

COUNTER_TO_CONTEXT_in_vp9_pickmode: [19] s32;

MV_REF_BLOCKS_in_vp9_pickmode: [13] [8] POSITION;

IDX_N_COLUMN_TO_SUBBLOCK_in_vp9_pickmode: [4] [2] s32;

FRAME_SCALE_FACTOR_in_vp9_pickmode: [2] s32;

RATE_THRESH_MULT_in_vp9_pickmode: [2] float64;

RCF_MULT_in_vp9_pickmode: [2] float64;

K_VP9_REF_FLAG_LIST_in_vp9_pickmode: [4] s32;

MODE_IDX: [4] [4] THR_MODES_in_vp9_cx_iface;

INTRA_MODE_LIST: [4] PREDICTION_MODE;

REF_MODE_SET_SVC: [8] REF_MODE;

REF_MODE_SET: [12] REF_MODE;

POS_SHIFT_16X16: [4] [4] s32;

clip_pixel_in_vp9_pickmode :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_pickmode :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_pickmode :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_pickmode :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_pickmode :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_pickmode(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_pickmode(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_pickmode(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_pickmode :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_lsb_in_vp9_pickmode :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_pickmode :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_pickmode :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_pickmode(num_values) + 1 else 0;
}

get_filter_taps_in_vp9_pickmode :: (FILTER: *s16) -> s32 {
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

get_prob_in_vp9_pickmode :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_pickmode :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_pickmode(n0, DEN);
}

weighted_prob_in_vp9_pickmode :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_pickmode :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_pickmode(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_pickmode(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_pickmode :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_pickmode[COUNT];
        PROB := get_prob_in_vp9_pickmode(ct[0], DEN);
        return weighted_prob_in_vp9_pickmode(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_band_translate_in_vp9_pickmode :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_pickmode :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_pickmode :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_pickmode(above_ec, left_ec);
}

is_zero_mv_in_vp9_pickmode :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_pickmode :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_pickmode :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_pickmode(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_pickmode(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_pickmode :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_pickmode :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_pickmode :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_pickmode :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

vp9_is_valid_scale_in_vp9_pickmode :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_pickmode :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_pickmode(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_pickmode :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_pickmode :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_pickmode :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_pickmode :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_pickmode :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_pickmode :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_pickmode :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_pickmode :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_pickmode :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_pickmode :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_pickmode :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_pickmode(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_pickmode :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_pickmode(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_pickmode(MI, ib)];
}

get_uv_tx_size_in_vp9_pickmode :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_pickmode :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_pickmode :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_pickmode(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_pickmode :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_pickmode :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_pickmode :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_pickmode :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_pickmode :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_pickmode :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_pickmode :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_pickmode :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_pickmode :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_pickmode :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_pickmode :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_pickmode :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_pickmode :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_pickmode(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_pickmode :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_pickmode(cm.mi_cols);

        if get_plane_type_in_vp9_pickmode(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_pickmode(cm, xd);
}

get_partition_probs_in_vp9_pickmode :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_pickmode :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_pickmode :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_pickmode :: (
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

update_partition_context_in_vp9_pickmode :: (
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

partition_plane_context_in_vp9_pickmode :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

clamp_mv_ref_in_vp9_pickmode :: (mv: *MV, xd: *MACROBLOCKD) {
    clamp_mv_in_vp9_pickmode(
        mv,
        xd.mb_to_left_edge - (cast(s32) 16) << 3,
        xd.mb_to_right_edge + (cast(s32) 16) << 3,
        xd.mb_to_top_edge - (cast(s32) 16) << 3,
        xd.mb_to_bottom_edge + (cast(s32) 16) << 3
    );
}

get_sub_block_mv_in_vp9_pickmode :: (candidate: *MODE_INFO, which_mv: s32, search_col: s32, block_idx: s32) -> Int_Mv {
    return ifx block_idx >= 0 && candidate.sb_type < 3 then candidate.bmi[IDX_N_COLUMN_TO_SUBBLOCK_in_vp9_pickmode[block_idx][cast(s32) (search_col == 0)]].as_mv[which_mv] else candidate.mv[which_mv];
}

scale_mv_in_vp9_pickmode :: (
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

is_inside_in_vp9_pickmode :: (TILE: *Tile_Info, mi_col: s32, mi_row: s32, mi_rows: s32, mi_pos: *POSITION) -> s32 {
    if !(mi_row + mi_pos.row < 0 || mi_col + mi_pos.col < TILE.mi_col_start || mi_row + mi_pos.row >= mi_rows || mi_col + mi_pos.col >= TILE.mi_col_end) {
        return 1;
    }
    return 0;
}

clamp_mv2_in_vp9_pickmode :: (mv: *MV, xd: *MACROBLOCKD) {
    clamp_mv_in_vp9_pickmode(
        mv,
        xd.mb_to_left_edge - (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_right_edge + (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_top_edge - (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_bottom_edge + (cast,no_check(s32) ((160 - 4))) << 3
    );
}

lower_mv_precision_in_vp9_pickmode :: (mv: *MV, allow_hp: s32) {
    USE_HP := cast(s32) (allow_hp != 0 && use_mv_hp_in_vp9_pickmode(mv) != 0);
    if USE_HP == 0 {
        if mv.row & 1 != 0 {
            c_transpiler_compound_add(*(mv.row), ((ifx mv.row > 0 then cast(s32) -1 else 1)), s32, s32);
        }
        if mv.col & 1 != 0 {
            c_transpiler_compound_add(*(mv.col), ((ifx mv.col > 0 then cast(s32) -1 else 1)), s32, s32);
        }
    }
}

get_segment_id_in_vp9_pickmode :: (
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

vp9_get_pred_context_seg_id_in_vp9_pickmode :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    ABOVE_SIP := (ifx ABOVE_MI != null then cast,no_check(s32) ABOVE_MI.seg_id_predicted else 0);
    LEFT_SIP := (ifx LEFT_MI != null then cast,no_check(s32) LEFT_MI.seg_id_predicted else 0);

    return ABOVE_SIP + LEFT_SIP;
}

vp9_get_pred_prob_seg_id_in_vp9_pickmode :: (seg: *Segmentation, xd: *MACROBLOCKD) -> Prob {
    return seg.pred_probs[vp9_get_pred_context_seg_id_in_vp9_pickmode(xd)];
}

vp9_get_skip_context_in_vp9_pickmode :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    ABOVE_SKIP := (ifx ABOVE_MI != null then cast,no_check(s32) ABOVE_MI.skip else 0);
    LEFT_SKIP := (ifx LEFT_MI != null then cast,no_check(s32) LEFT_MI.skip else 0);
    return ABOVE_SKIP + LEFT_SKIP;
}

vp9_get_skip_prob_in_vp9_pickmode :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.skip_probs[vp9_get_skip_context_in_vp9_pickmode(xd)];
}

get_pred_context_switchable_interp_in_vp9_pickmode :: (xd: *MACROBLOCKD) -> s32 {
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

get_intra_inter_context_in_vp9_pickmode :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    HAS_ABOVE := cast(s32) (ABOVE_MI != null);
    HAS_LEFT := cast(s32) (LEFT_MI != null);

    if HAS_ABOVE != 0 && HAS_LEFT != 0 {
        ABOVE_INTRA := cast(s32) (is_inter_block_in_vp9_pickmode(ABOVE_MI) == 0);
        LEFT_INTRA := cast(s32) (is_inter_block_in_vp9_pickmode(LEFT_MI) == 0);
        return ifx LEFT_INTRA != 0 && ABOVE_INTRA != 0 then 3 else cast(s32) (LEFT_INTRA != 0 || ABOVE_INTRA != 0);
    } else if HAS_ABOVE != 0 || HAS_LEFT != 0 {
        return 2 * cast(s32) (is_inter_block_in_vp9_pickmode((ifx HAS_ABOVE != 0 then ABOVE_MI else LEFT_MI)) == 0);
    }
    return 0;
}

vp9_get_intra_inter_prob_in_vp9_pickmode :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.intra_inter_prob[get_intra_inter_context_in_vp9_pickmode(xd)];
}

vp9_get_reference_mode_prob_in_vp9_pickmode :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.comp_inter_prob[vp9_get_reference_mode_context(cm, xd)];
}

vp9_get_pred_prob_comp_ref_p_in_vp9_pickmode :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    PRED_CONTEXT := vp9_get_pred_context_comp_ref_p(cm, xd);
    return cm.fc.comp_ref_prob[PRED_CONTEXT];
}

vp9_get_pred_prob_single_ref_p1_in_vp9_pickmode :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return ((cm.fc.single_ref_prob[vp9_get_pred_context_single_ref_p1(xd)]).data)[0];
}

vp9_get_pred_prob_single_ref_p2_in_vp9_pickmode :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return ((cm.fc.single_ref_prob[vp9_get_pred_context_single_ref_p2(xd)]).data)[1];
}

get_tx_size_context_in_vp9_pickmode :: (xd: *MACROBLOCKD) -> s32 {
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

get_tx_probs_in_vp9_pickmode :: (max_tx_size: TX_SIZE, ctx: s32, tx_probs: *Tx_Probs) -> *Prob {
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

get_tx_counts_in_vp9_pickmode :: (max_tx_size: TX_SIZE, ctx: s32, tx_counts: *Tx_Counts) -> *u32 {
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

inter_predictor_in_vp9_pickmode :: (
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

scaled_buffer_offset_in_vp9_pickmode :: (x_offset: s32, y_offset: s32, stride: s32, sf: *Scale_Factors) -> s64 {
    X := (ifx sf != null then sf.scale_value_x(x_offset, sf) else x_offset);
    Y := (ifx sf != null then sf.scale_value_y(y_offset, sf) else y_offset);
    return ((cast,no_check(s64) Y) * cast(s64) stride) + cast(s64) X;
}

setup_pred_plane_in_vp9_pickmode :: (
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
    dst.buf = src + scaled_buffer_offset_in_vp9_pickmode(X, Y, stride, scale);
    dst.stride = stride;
}

get_coef_context_in_vp9_pickmode :: (neighbors: *s16, token_cache: *u8, c: s32) -> s32 {
    return ((1 + cast(s32) token_cache[neighbors[2 * c + 0]]) + cast(s32) token_cache[neighbors[2 * c + 1]]) >> 1;
}

get_scan_in_vp9_pickmode :: (
    xd: *MACROBLOCKD,
    tx_size: TX_SIZE,
    type: PLANE_TYPE,
    block_idx: s32
) -> *Scan_Order_in_vp9_scan {
    MI := xd.mi[0];

    if is_inter_block_in_vp9_pickmode(MI) != 0 || type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 {
        return VP9_DEFAULT_SCAN_ORDERS.data + tx_size;
    } else {
        MODE_ := get_y_mode_in_vp9_pickmode(MI, block_idx);
        return VP9_SCAN_ORDERS[tx_size].data + INTRA_MODE_TO_TX_TYPE_LOOKUP[MODE_];
    }
}

cost_branch256_in_vp9_pickmode :: (ct: *u32, p: Prob) -> u64 {
    return ((cast,no_check(u64) ct[0]) * cast(u64) VP9_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP9_PROB_COST[256 - cast(s32) p];
}

treed_cost_in_vp9_pickmode :: (tree: *Tree_Index, probs: *Prob, bits: s32, len: s32) -> s32 {
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

vp8_set_reference_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_vp9_pickmode :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

gcd_in_vp9_pickmode :: (a: s64, b: s32) -> s32 {
    while b != 0 {
        r := cast,no_check(s32) (a % cast(s64) b);
        a = cast,no_check(s64) b;
        b = r;
    }

    return cast,no_check(s32) a;
}

reduce_ratio_in_vp9_pickmode :: (ratio: *Rational64_T) {
    DENOM := gcd_in_vp9_pickmode(ratio.num, ratio.den);
    ratio.num /= cast,no_check(s64) DENOM;
    ratio.den /= DENOM;
}

cyclic_refresh_segment_id_boosted_in_vp9_pickmode :: (segment_id: s32) -> s32 {
    if segment_id == 1 || segment_id == 2 {
        return 1;
    }
    return 0;
}

cyclic_refresh_segment_id_in_vp9_pickmode :: (segment_id: s32) -> s32 {
    if segment_id == 1 {
        return 1;
    } else if segment_id == 2 {
        return 2;
    } else {
        return 0;
    }
}

fps_init_first_pass_info_in_vp9_pickmode :: (
    first_pass_info: *FIRST_PASS_INFO,
    stats: *FIRSTPASS_STATS_in_vp9_cx_iface,
    num_frames: s32
) {
    first_pass_info.stats = stats;
    first_pass_info.num_frames = num_frames;
}

fps_get_num_frames_in_vp9_pickmode :: (first_pass_info: *FIRST_PASS_INFO) -> s32 {
    return first_pass_info.num_frames;
}

fps_get_frame_stats_in_vp9_pickmode :: (
    first_pass_info: *FIRST_PASS_INFO,
    show_idx: s32
) -> *FIRSTPASS_STATS_in_vp9_cx_iface {
    if show_idx < 0 || show_idx >= first_pass_info.num_frames {
        return null;
    }
    return *(cast(*FIRSTPASS_STATS_in_vp9_cx_iface) (first_pass_info.stats))[show_idx];
}

get_buf_from_mv_in_vp9_pickmode :: (buf: *Buf_2d, mv: *MV) -> *u8 {
    return *buf.buf[(cast(s32) mv.row) * buf.stride + cast(s32) mv.col];
}

rd_less_than_thresh_in_vp9_pickmode :: (best_rd: s64, thresh: s32, THRESH_FACT: *s32) -> s32 {
    if best_rd < ((cast,no_check(s64) thresh) * cast(s64) THRESH_FACT.*) >> 5 || thresh == 2147483647 {
        return 1;
    }
    return 0;
}

set_error_per_bit_in_vp9_pickmode :: (x: *MACROBLOCK, rdmult: s32) {
    x.errorperbit = rdmult >> 6;
    x.errorperbit += cast(s32) (x.errorperbit == 0);
}

write_in_vp9_pickmode :: (br: *Writer, bit: s32, probability: s32) {
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

write_bit_in_vp9_pickmode :: (w: *Writer, bit: s32) {
    write_in_vp9_pickmode(w, bit, 128);
}

write_literal_in_vp9_pickmode :: (w: *Writer, data: s32, bits: s32) {
    bit := bits - 1;
    while bit >= 0 {
        write_bit_in_vp9_pickmode(w, 1 & (data >> ((bit) & 31)));
        bit -= 1;
    }
}

vp9_write_tree_in_vp9_pickmode :: (w: *Writer, tree: *Tree_Index, probs: *Prob, bits: s32, len: s32, i: Tree_Index) {
    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            write_in_vp9_pickmode(w, BIT, cast,no_check(s32) probs[(cast(s32) i) >> 1]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }
}

vp9_write_token_in_vp9_pickmode :: (w: *Writer, tree: *Tree_Index, probs: *Prob, token: *Vp9_Token) {
    vp9_write_tree_in_vp9_pickmode(w, tree, probs, token.value, token.len, 0);
}

vp9_get_high_cost_table_in_vp9_pickmode :: (bit_depth: s32) -> *u16 {
    return VP9_CAT6_HIGH_COST.data;
}

vp9_get_token_extra_in_vp9_pickmode :: (v: s32, token: *s16, extra: *EXTRABIT) {
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

vp9_get_token_in_vp9_pickmode :: (v: s32) -> s16 {
    if v >= 67 || v <= -67 {
        return 10;
    }
    return vp9_dct_cat_lt_10_value_tokens[v].token;
}

vp9_get_token_cost_in_vp9_pickmode :: (v: s32, token: *s16, cat6_high_table: *u16) -> s32 {
    if v >= 67 || v <= -67 {
        token.* = 10;
        extrabits := cast,no_check(EXTRABIT) (absolute_value(v) - 67);
        return (cast(s32) VP9_CAT6_LOW_COST[extrabits & 0xff]) + cast(s32) cat6_high_table[(cast(s32) extrabits) >> 8];
    }
    token.* = vp9_dct_cat_lt_10_value_tokens[v].token;
    return vp9_dct_cat_lt_10_value_cost[v];
}

is_lossless_requested_in_vp9_pickmode :: (cfg: *VP9_Encoder_Config) -> s32 {
    if cfg.best_allowed_q == 0 && cfg.worst_allowed_q == 0 {
        return 1;
    }
    return 0;
}

stack_pop_in_vp9_pickmode :: (stack: *s32, stack_size: s32) -> s32 {
    R := stack[0];
    if 1 < stack_size {
        for idx: 1..stack_size - 1 {
            stack[idx - 1] = stack[idx];
        }
    }

    return R;
}

stack_top_in_vp9_pickmode :: (stack: *s32) -> s32 {
    return stack[0];
}

stack_push_in_vp9_pickmode :: (stack: *s32, new_item: s32, stack_size: s32) {
    idx := stack_size;
    while idx > 0 {
        stack[idx] = stack[idx - 1];
        idx -= 1;
    }
    stack[0] = new_item;
}

stack_init_in_vp9_pickmode :: (stack: *s32, length: s32) {
    if 0 < length {
        for idx: 0..length - 1 {
            stack[idx] = -1;
        }
    }
}

frame_is_kf_gf_arf_in_vp9_pickmode :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if frame_is_intra_only_in_vp9_pickmode(*cpi.common) != 0 ||
        cpi.refresh_alt_ref_frame != 0 ||
        cpi.refresh_golden_frame != 0 && cpi.rc.is_src_frame_alt_ref == 0 {
        return 1;
    }
    return 0;
}

ref_frame_to_flag_in_vp9_pickmode :: (ref_frame: s8) -> s32 {

    return K_VP9_REF_FLAG_LIST_in_vp9_pickmode[ref_frame];
}

get_ref_frame_map_idx_in_vp9_pickmode :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame: MV_REFERENCE_FRAME) -> s32 {
    if ref_frame == 1 {
        return cpi.lst_fb_idx;
    } else if ref_frame == 2 {
        return cpi.gld_fb_idx;
    } else {
        return cpi.alt_fb_idx;
    }
}

get_ref_frame_buf_idx_in_vp9_pickmode :: (CPI: *VP9_COMP_in_vp9_encoder, ref_frame: s32) -> s32 {
    CM := *CPI.common;
    MAP_IDX := get_ref_frame_map_idx_in_vp9_pickmode(CPI, cast,no_check(MV_REFERENCE_FRAME) ref_frame);
    return ifx MAP_IDX != -1 then CM.ref_frame_map[MAP_IDX] else -1;
}

get_ref_cnt_buffer_in_vp9_pickmode :: (cm: *VP9_COMMON, fb_idx: s32) -> *Ref_Cnt_Buffer {
    return ifx fb_idx != -1 then cm.buffer_pool.frame_bufs.data + fb_idx else null;
}

get_ref_frame_bufs_in_vp9_pickmode :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame_bufs: **Ref_Cnt_Buffer) {
    CM := *cpi.common;

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame < 4 {
        ref_frame_buf_idx := get_ref_frame_buf_idx_in_vp9_pickmode(cpi, cast,no_check(s32) ref_frame);
        inter_ref_idx := mv_ref_frame_to_inter_ref_idx_in_vp9_pickmode(ref_frame);
        ref_frame_bufs[inter_ref_idx] = get_ref_cnt_buffer_in_vp9_pickmode(CM, ref_frame_buf_idx);
        ref_frame += 1;
    }
}

get_ref_frame_buffer_in_vp9_pickmode :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    ref_frame: MV_REFERENCE_FRAME
) -> *YV12_BUFFER_CONFIG {
    CM := *CPI.common;
    BUF_IDX := get_ref_frame_buf_idx_in_vp9_pickmode(CPI, cast,no_check(s32) ref_frame);
    return ifx BUF_IDX != -1 then *CM.buffer_pool.frame_bufs[BUF_IDX].buf else null;
}

get_token_alloc_in_vp9_pickmode :: (mb_rows: s32, mb_cols: s32) -> s64 {
    ALIGNED_MB_ROWS :=
        (mb_rows +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    ALIGNED_MB_COLS :=
        (mb_cols +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    return ((cast,no_check(s64) ALIGNED_MB_ROWS) * cast(s64) ALIGNED_MB_COLS) * cast,no_check(s64) ((cast,no_check(s32) ((16 * 16))) * 3 + 4);
}

allocated_tokens_in_vp9_pickmode :: (tile: Tile_Info) -> s64 {
    tile_mb_rows := (tile.mi_row_end - tile.mi_row_start + 1) >> 1;
    tile_mb_cols := (tile.mi_col_end - tile.mi_col_start + 1) >> 1;

    return get_token_alloc_in_vp9_pickmode(tile_mb_rows, tile_mb_cols);
}

get_start_tok_in_vp9_pickmode :: (
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

    tok.* = cpi.tile_tok[tile_row][tile_col] + get_token_alloc_in_vp9_pickmode(MB_ROW, tile_mb_cols);
}

is_one_pass_svc_in_vp9_pickmode :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if CPI.use_svc != 0 && CPI.oxcf.pass == 0 {
        return 1;
    }
    return 0;
}

is_altref_enabled_in_vp9_pickmode :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if !(CPI.oxcf.mode == cast,no_check(u32) REALTIME && CPI.oxcf.rc_mode == cast,no_check(u32) CBR) &&
        CPI.oxcf.lag_in_frames >= 4 &&
        CPI.oxcf.enable_auto_arf != 0 {
        return 1;
    }
    return 0;
}

set_ref_ptrs_in_vp9_pickmode :: (
    CM: *VP9_COMMON,
    xd: *MACROBLOCKD,
    ref0: MV_REFERENCE_FRAME,
    ref1: MV_REFERENCE_FRAME
) {
    xd.block_refs[0] = CM.frame_refs.data + (ifx ref0 >= 1 then (cast(s32) ref0) - 1 else 0);
    xd.block_refs[1] = CM.frame_refs.data + (ifx ref1 >= 1 then (cast(s32) ref1) - 1 else 0);
}

get_chessboard_index_in_vp9_pickmode :: (FRAME_INDEX: s32) -> s32 {
    return FRAME_INDEX & 0x1;
}

cond_cost_list_in_vp9_pickmode :: (cpi: *VP9_COMP_in_vp9_encoder, cost_list: *s32) -> *s32 {
    return ifx cpi.sf.mv.subpel_search_method != cast,no_check(u32) SUBPEL_TREE then cost_list else null;
}

get_num_vert_units_in_vp9_pickmode :: (tile: Tile_Info, shift: s32) -> s32 {
    num_vert_units := (tile.mi_row_end - tile.mi_row_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_vert_units;
}

get_num_cols_in_vp9_pickmode :: (tile: Tile_Info, shift: s32) -> s32 {
    num_cols := (tile.mi_col_end - tile.mi_col_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_cols;
}

get_level_index_in_vp9_pickmode :: (level: VP9_LEVEL) -> s32 {
    for i: 0..cast(s32) 14 - 1 {
        if level == VP9_LEVEL_DEFS[i].level {
            return i;
        }
    }
    return -1;
}

log_tile_cols_from_picsize_level_in_vp9_pickmode :: (width: u32, height: u32) -> s32 {
    PIC_SIZE := width * height;
    PIC_BREADTH := max(width, height);
    for i: 0..cast(s32) 14 - 1 {
        if VP9_LEVEL_DEFS[i].max_luma_picture_size >= PIC_SIZE && VP9_LEVEL_DEFS[i].max_luma_picture_breadth >= PIC_BREADTH {
            return get_msb_in_vp9_pickmode(cast,no_check(u32) VP9_LEVEL_DEFS[i].max_col_tiles);
        }
    }
    return 2147483647;
}

alloc_frame_mvs_in_vp9_pickmode :: (CM: *VP9_COMMON, buffer_idx: s32) {
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

mv_cost_in_vp9_pickmode :: (mv: *MV, joint_cost: *s32, comp_cost: **s32) -> s32 {
    return joint_cost[vp9_get_mv_joint_in_vp9_pickmode(mv)] + comp_cost[0][mv.row] + comp_cost[1][mv.col];
}

mvsad_err_cost_in_vp9_pickmode :: (x: *MACROBLOCK, mv: *MV, ref: *MV, sad_per_bit: s32) -> s32 {
    diff: MV = ---;
    diff.row = cast,no_check(s16) ((cast(s32) mv.row) - cast(s32) ref.row);
    diff.col = cast,no_check(s16) ((cast(s32) mv.col) - cast(s32) ref.col);
    return cast,no_check(s32) ((((cast,no_check(u32) mv_cost_in_vp9_pickmode(*diff, x.nmvjointsadcost.data, x.nmvsadcost.data)) * cast,no_check(u32) sad_per_bit) + cast,no_check(u32) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9);
}

get_start_mv_sad_in_vp9_pickmode :: (
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
    start_mv_sad += cast,no_check(u32) mvsad_err_cost_in_vp9_pickmode(x, mvp_full, ref_mv_full, sadpb);

    return start_mv_sad;
}

num_4x4_to_edge_in_vp9_pickmode :: (
    plane_4x4_dim: s32,
    mb_to_edge_dim: s32,
    subsampling_dim: s32,
    blk_dim: s32
) -> s32 {
    return plane_4x4_dim + mb_to_edge_dim >> (((5 + subsampling_dim)) & 31) - blk_dim;
}

sum_squares_visible_in_vp9_pickmode :: (
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
        num_4x4_to_edge_in_vp9_pickmode(
            PLANE_4X4_W,
            xd.mb_to_right_edge,
            PD.subsampling_x,
            blk_col
        );
    B4X4S_TO_BOTTOM_EDGE :=
        num_4x4_to_edge_in_vp9_pickmode(
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

do_trellis_opt_in_vp9_pickmode :: (
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
                    sum_squares_visible_in_vp9_pickmode(
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

vp9_pick_intra_mode :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    rd_cost: *RD_COST,
    bsize: BLOCK_SIZE,
    ctx: *PICK_MODE_CONTEXT
) {
    XD := *x.e_mbd;
    MI := XD.mi[0];
    this_rdc, best_rdc: RD_COST = ---;

    args :=
        Estimate_Block_Intra_Args.{
            cpi = cpi,
            x = x,
            mode = 0,
            skippable = 1,
            rdc = null
        };
    INTRA_TX_SIZE :=
        cast,no_check(TX_SIZE) ((ifx MAX_TXSIZE_LOOKUP[bsize] < TX_MODE_TO_BIGGEST_TX_SIZE[cpi.common.tx_mode] then cast,no_check(s32) MAX_TXSIZE_LOOKUP[bsize] else cast,no_check(s32) TX_MODE_TO_BIGGEST_TX_SIZE[cpi.common.tx_mode]));
    MIC := XD.mi[0];

    above_mi := XD.above_mi;
    left_mi := XD.left_mi;
    A := vp9_above_block_mode(MIC, above_mi, 0);
    L := vp9_left_block_mode(MIC, left_mi, 0);
    bmode_costs := cpi.y_mode_costs[A][L].data;

    vp9_rd_cost_reset(*best_rdc);
    vp9_rd_cost_reset(*this_rdc);

    MI.ref_frame[0] = 0;

    MI.interp_filter = 3;

    MI.mv[0].as_int = 0x80008000;
    MI.uv_mode = 0;
    fill_memory(x.skip_txfm.data, 0, x.skip_txfm.count);

    this_mode: PREDICTION_MODE = 0;
    while this_mode <= 2 {
        this_rdc.dist =
            cast,no_check(s64) ((ifx true { assignment_0: s32 = cast,no_check(s32) (cast(s32) 0); (this_rdc.rate) = assignment_0; assignment_0; }));
        args.mode = this_mode;
        args.skippable = 1;
        args.rdc = *this_rdc;
        MI.tx_size = INTRA_TX_SIZE;
        vp9_foreach_transformed_block_in_plane(
            XD,
            bsize,
            0,
            cast,no_check(Foreach_Transformed_Block_Visitor) estimate_block_intra,
            cast(*void) *args
        );
        if args.skippable != 0 {
            x.skip_txfm[0] = 1;
            this_rdc.rate =
                cast,no_check(s32) (VP9_PROB_COST[(256 -
                    cast(s32) vp9_get_skip_prob_in_vp9_pickmode(*cpi.common, XD))]);
        } else {
            x.skip_txfm[0] = 0;
            this_rdc.rate +=
                cast,no_check(s32) (VP9_PROB_COST[cast,no_check(s32) vp9_get_skip_prob_in_vp9_pickmode(*cpi.common, XD)]);
        }
        this_rdc.rate += bmode_costs[this_mode];
        this_rdc.rdcost =
            ((((cast,no_check(s64) this_rdc.rate) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                this_rdc.dist << ((x.rddiv) & 63);

        if this_rdc.rdcost < best_rdc.rdcost {
            assignment_1: RD_COST = this_rdc;
            ((*best_rdc).*) = assignment_1;
            MI.mode = this_mode;
        }
        this_mode += 1;
    }

    assignment_2: RD_COST = best_rdc;
    ((rd_cost).*) = assignment_2;
}

estimate_block_intra :: (
    plane: s32,
    block: s32,
    row: s32,
    col: s32,
    plane_bsize: BLOCK_SIZE,
    tx_size: TX_SIZE,
    arg: *void
) {
    ARGS := cast(*Estimate_Block_Intra_Args) arg;
    CPI := ARGS.cpi;
    X := ARGS.x;
    XD := *X.e_mbd;
    P := X.plane.data + plane;
    PD := XD.plane.data + plane;
    BSIZE_TX := TXSIZE_TO_BSIZE[tx_size];
    SRC_BUF_BASE := P.src.buf;
    DST_BUF_BASE := PD.dst.buf;
    SRC_STRIDE := P.src.stride;
    DST_STRIDE := PD.dst.stride;
    this_rdc: RD_COST = ---;

    P.src.buf = *SRC_BUF_BASE[4 * (((cast(s64) row) * cast,no_check(s64) SRC_STRIDE) + cast(s64) col)];
    PD.dst.buf = *DST_BUF_BASE[4 * (((cast(s64) row) * cast,no_check(s64) DST_STRIDE) + cast(s64) col)];

    vp9_predict_intra_block(
        XD,
        cast,no_check(s32) B_WIDTH_LOG2_LOOKUP[plane_bsize],
        tx_size,
        ARGS.mode,
        (ifx X.skip_encode != 0 then P.src.buf else PD.dst.buf),
        (ifx X.skip_encode != 0 then SRC_STRIDE else DST_STRIDE),
        PD.dst.buf,
        DST_STRIDE,
        col,
        row,
        plane
    );

    if plane == 0 {
        this_sse: s64 = 9223372036854775807;
        block_yrd(
            CPI,
            X,
            *this_rdc,
            *ARGS.skippable,
            *this_sse,
            BSIZE_TX,
            cast,no_check(TX_SIZE) ((ifx tx_size < cast(TX_SIZE) 2 then cast,no_check(s32) tx_size else cast,no_check(s32) (cast(TX_SIZE) 2))),
            0,
            1
        );
    } else {
        var: u32 = 0;
        sse: u32 = 0;
        model_rd_for_sb_uv(CPI, BSIZE_TX, X, XD, *this_rdc, *var, *sse, plane, plane);
    }

    P.src.buf = SRC_BUF_BASE;
    PD.dst.buf = DST_BUF_BASE;
    ARGS.rdc.rate += this_rdc.rate;
    ARGS.rdc.dist += this_rdc.dist;
}

model_rd_for_sb_uv :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    plane_bsize: BLOCK_SIZE,
    x: *MACROBLOCK,
    xd: *MACROBLOCKD,
    this_rdc: *RD_COST,
    var_y: *u32,
    sse_y: *u32,
    start_plane: s32,
    stop_plane: s32
) {
    sse: u32 = ---;
    rate: s32 = ---;
    dist: s64 = ---;

    tot_var: u32 = var_y.*;
    tot_sse: u32 = sse_y.*;

    this_rdc.rate = 0;
    this_rdc.dist = 0;

    i := start_plane;
    while i <= stop_plane {
        P := x.plane.data + i;
        PD := xd.plane.data + i;
        DC_QUANT := cast,no_check(u32) PD.dequant[0];
        AC_QUANT := cast,no_check(u32) PD.dequant[1];
        BS := plane_bsize;

        if x.color_sensitivity[i - 1] == 0 {
            i += 1;
            continue;
        }

        var := cpi.fn_ptr[BS].vf(P.src.buf, P.src.stride, PD.dst.buf, PD.dst.stride, *sse);

        tot_var = cast,no_check(u32) (tot_var + var);
        tot_sse = cast,no_check(u32) (tot_sse + sse);

        vp9_model_rd_from_var_lapndz(
            sse - var,
            cast,no_check(u32) NUM_PELS_LOG2_LOOKUP[BS],
            DC_QUANT >> 3,
            *rate,
            *dist
        );

        this_rdc.rate += rate >> 1;
        this_rdc.dist += dist << 3;

        vp9_model_rd_from_var_lapndz(var, cast,no_check(u32) NUM_PELS_LOG2_LOOKUP[BS], AC_QUANT >> 3, *rate, *dist);

        this_rdc.rate += rate;
        this_rdc.dist += dist << 4;
        i += 1;
    }

    var_y.* = tot_var;
    sse_y.* = tot_sse;
}

block_yrd :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    this_rdc: *RD_COST,
    skippable: *s32,
    sse: *s64,
    bsize: BLOCK_SIZE,
    tx_size: TX_SIZE,
    rd_computed: s32,
    is_intra: s32
) {
    xd := *x.e_mbd;
    pd := xd.plane.data + 0;
    P := x.plane.data + 0;
    NUM_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[bsize];
    NUM_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[bsize];
    STEP := (cast(s32) 1) << ((((cast(s32) tx_size) << 1)) & 31);
    BLOCK_STEP := (cast(s32) 1) << ((tx_size) & 31);
    block: s32 = 0;
    c: s32 = ---;
    MAX_BLOCKS_WIDE := NUM_4X4_W + (ifx xd.mb_to_right_edge >= 0 then 0 else xd.mb_to_right_edge >> 5);
    MAX_BLOCKS_HIGH := NUM_4X4_H + (ifx xd.mb_to_bottom_edge >= 0 then 0 else xd.mb_to_bottom_edge >> 5);
    eob_cost: s32 = 0;
    BW := 4 * NUM_4X4_W;
    BH := 4 * NUM_4X4_H;

    if cpi.sf.use_simple_block_yrd != 0 &&
        cpi.common.frame_type != cast,no_check(u32) KEY_FRAME &&
        (bsize < 9 || cpi.use_svc != 0 && (bsize < 9 || cpi.svc.temporal_layer_id > 0)) {
        var_y, sse_y: u32 = ---;

        if rd_computed == 0 {
            model_rd_for_sb_y(cpi, bsize, x, xd, *this_rdc.rate, *this_rdc.dist, *var_y, *sse_y, is_intra);
        }
        sse.* = 2147483647;
        skippable.* = 0;
        return;
    }

    subtract_block_c(
        BH,
        BW,
        P.src_diff.data,
        cast,no_check(s64) BW,
        P.src.buf,
        cast,no_check(s64) P.src.stride,
        pd.dst.buf,
        cast,no_check(s64) pd.dst.stride
    );

    skippable.* = 1;

    r: s32 = 0;
    while r < MAX_BLOCKS_HIGH {
        c = 0;
        while c < NUM_4X4_W {
            if c < MAX_BLOCKS_WIDE {
                SCAN_ORDER := VP9_DEFAULT_SCAN_ORDERS.data + tx_size;
                COEFF := P.coeff + block * 16;
                QCOEFF := P.qcoeff + block * 16;
                DQCOEFF := pd.dqcoeff + block * 16;
                EOB := *P.eobs[block];
                DIFF_STRIDE := BW;
                src_diff := P.src_diff.data + (r * DIFF_STRIDE + c) << 2;

                if cast,no_check(s32) tx_size == {
                    case cast,no_check(s32) cast(TX_SIZE) 2;
                        hadamard_16x16_c(src_diff, cast,no_check(s64) DIFF_STRIDE, COEFF);
                        vp9_quantize_fp_c(COEFF, 256, P, QCOEFF, DQCOEFF, pd.dequant, EOB, SCAN_ORDER);
                    case cast,no_check(s32) cast(TX_SIZE) 1;
                        hadamard_8x8_c(src_diff, cast,no_check(s64) DIFF_STRIDE, COEFF);
                        vp9_quantize_fp_c(COEFF, 64, P, QCOEFF, DQCOEFF, pd.dequant, EOB, SCAN_ORDER);
                    case;
                        x.fwd_txfm4x4(src_diff, COEFF, DIFF_STRIDE);
                        vp9_quantize_fp_c(COEFF, 16, P, QCOEFF, DQCOEFF, pd.dequant, EOB, SCAN_ORDER);
                }
                skippable.* &= cast(s32) (EOB.* == 0);
                eob_cost += 1;
            }
            block += STEP;
            c += BLOCK_STEP;
        }
        r += BLOCK_STEP;
    }

    this_rdc.rate = 0;
    if sse.* < 9223372036854775807 {
        sse.* = sse.* << 6 >> 2;
        if skippable.* != 0 {
            this_rdc.dist = sse.*;
            return;
        }
    }

    block = 0;
    this_rdc.dist = 0;
    r = 0;
    while r < MAX_BLOCKS_HIGH {
        c = 0;
        while c < NUM_4X4_W {
            if c < MAX_BLOCKS_WIDE {
                COEFF := P.coeff + block * 16;
                QCOEFF := P.qcoeff + block * 16;
                DQCOEFF := pd.dqcoeff + block * 16;
                EOB := *P.eobs[block];

                if EOB.* == 1 {
                    this_rdc.rate += absolute_value(cast,no_check(s32) QCOEFF[0]);
                } else if EOB.* > 1 {
                    this_rdc.rate += satd_c(QCOEFF, STEP << 4);
                }

                this_rdc.dist += vp9_block_error_fp_c(COEFF, DQCOEFF, STEP << 4) >> 2;
            }
            block += STEP;
            c += BLOCK_STEP;
        }
        r += BLOCK_STEP;
    }

    c_transpiler_compound_shl(*(this_rdc.rate), (((cast,no_check(s32) ((2 + 9))) & 31)), s32, s32);
    this_rdc.rate += eob_cost << 9;
}

model_rd_for_sb_y :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    bsize: BLOCK_SIZE,
    x: *MACROBLOCK,
    xd: *MACROBLOCKD,
    out_rate_sum: *s32,
    out_dist_sum: *s64,
    var_y: *u32,
    sse_y: *u32,
    is_intra: s32
) {
    sse: u32 = ---;
    rate: s32 = ---;
    dist: s64 = ---;
    P := x.plane.data + 0;
    PD := xd.plane.data + 0;
    DC_THR := P.quant_thred[0] >> 6;
    AC_THR := P.quant_thred[1] >> 6;
    DC_QUANT := cast,no_check(u32) PD.dequant[0];
    AC_QUANT := cast,no_check(u32) PD.dequant[1];
    var := cpi.fn_ptr[bsize].vf(P.src.buf, P.src.stride, PD.dst.buf, PD.dst.stride, *sse);
    skip_dc: s32 = 0;

    var_y.* = var;
    sse_y.* = sse;

    xd.mi[0].tx_size = calculate_tx_size(cpi, bsize, xd, var, sse, AC_THR, x.source_variance, is_intra);

    {
        UNIT_SIZE := TXSIZE_TO_BSIZE[xd.mi[0].tx_size];
        NUM_BLK_LOG2 :=
            cast,no_check(u32) (((cast(s32) B_WIDTH_LOG2_LOOKUP[bsize]) - cast(s32) B_WIDTH_LOG2_LOOKUP[UNIT_SIZE]) +
                ((cast(s32) B_HEIGHT_LOG2_LOOKUP[bsize]) - cast(s32) B_HEIGHT_LOG2_LOOKUP[UNIT_SIZE]));
        SSE_TX := sse >> ((NUM_BLK_LOG2) & 31);
        VAR_TX := var >> ((NUM_BLK_LOG2) & 31);

        x.skip_txfm[0] = 0;

        if cast,no_check(s64) VAR_TX < AC_THR || var == 0 {
            x.skip_txfm[0] = 2;

            if cast,no_check(s64) (SSE_TX - VAR_TX) < DC_THR || sse == var {
                x.skip_txfm[0] = 1;
            }
        } else if cast,no_check(s64) (SSE_TX - VAR_TX) < DC_THR || sse == var {
            skip_dc = 1;
        }
    }

    if x.skip_txfm[0] == 1 {
        out_rate_sum.* = 0;
        out_dist_sum.* = cast,no_check(s64) (sse << 4);
        return;
    }

    if skip_dc == 0 {
        vp9_model_rd_from_var_lapndz(
            sse - var,
            cast,no_check(u32) NUM_PELS_LOG2_LOOKUP[bsize],
            DC_QUANT >> 3,
            *rate,
            *dist
        );
    }

    if skip_dc == 0 {
        out_rate_sum.* = rate >> 1;
        out_dist_sum.* = dist << 3;
    } else {
        out_rate_sum.* = 0;
        out_dist_sum.* = cast,no_check(s64) ((sse - var) << 4);
    }

    vp9_model_rd_from_var_lapndz(var, cast,no_check(u32) NUM_PELS_LOG2_LOOKUP[bsize], AC_QUANT >> 3, *rate, *dist);

    out_rate_sum.* += rate;
    out_dist_sum.* += dist << 4;
}

calculate_tx_size :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    bsize: BLOCK_SIZE,
    XD: *MACROBLOCKD,
    var: u32,
    sse: u32,
    ac_thr: s64,
    source_variance: u32,
    is_intra: s32
) -> TX_SIZE {
    tx_size: TX_SIZE = ---;
    var_thresh := (ifx is_intra != 0 then cast,no_check(u32) ac_thr else 1);
    limit_tx: s32 = 1;
    if CPI.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ && (source_variance == 0 || var < var_thresh) {
        limit_tx = 0;
    }
    if CPI.common.tx_mode == cast,no_check(u32) TX_MODE_SELECT {
        if sse > var << 2 {
            tx_size =
                cast,no_check(TX_SIZE) ((ifx MAX_TXSIZE_LOOKUP[bsize] < TX_MODE_TO_BIGGEST_TX_SIZE[CPI.common.tx_mode] then cast,no_check(s32) MAX_TXSIZE_LOOKUP[bsize] else cast,no_check(s32) TX_MODE_TO_BIGGEST_TX_SIZE[CPI.common.tx_mode]));
        } else {
            tx_size = 1;
        }
        if CPI.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ &&
            limit_tx != 0 &&
            cyclic_refresh_segment_id_boosted_in_vp9_pickmode(cast,no_check(s32) XD.mi[0].segment_id) != 0 {
            tx_size = 1;
        } else if tx_size > cast(TX_SIZE) 2 && limit_tx != 0 {
            tx_size = 2;
        }

        if CPI.oxcf.content == cast,no_check(u32) VP9E_CONTENT_SCREEN &&
            tx_size == cast(TX_SIZE) 1 &&
            bsize <= 6 &&
            var >> 5 > cast,no_check(u32) ac_thr {
            tx_size = 0;
        }
    } else {
        tx_size =
            cast,no_check(TX_SIZE) ((ifx MAX_TXSIZE_LOOKUP[bsize] < TX_MODE_TO_BIGGEST_TX_SIZE[CPI.common.tx_mode] then cast,no_check(s32) MAX_TXSIZE_LOOKUP[bsize] else cast,no_check(s32) TX_MODE_TO_BIGGEST_TX_SIZE[CPI.common.tx_mode]));
    }
    return tx_size;
}

vp9_pick_inter_mode :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    tile_data: *Tile_Data_Enc,
    mi_row: s32,
    mi_col: s32,
    rd_cost: *RD_COST,
    bsize: BLOCK_SIZE,
    ctx: *PICK_MODE_CONTEXT
) {
    CM := *cpi.common;
    SF := *cpi.sf;
    SVC_ := *cpi.svc;
    XD := *x.e_mbd;
    MI := XD.mi[0];
    PD := XD.plane.data + 0;

    best_pickmode: BEST_PICKMODE = ---;

    frame_mv: [14] [4] Int_Mv = ---;
    mode_checked: [14] [4] u8 = ---;
    yv12_mb: [4] [3] Buf_2d;
    this_rdc, best_rdc: RD_COST = ---;

    var_y: u32 = U32_MAX;
    sse_y: u32 = U32_MAX;
    INTRA_COST_PENALTY := vp9_get_intra_cost_penalty(cpi, bsize, CM.base_qindex, CM.y_dc_delta_q);
    inter_mode_thresh :=
        ((((cast,no_check(s64) INTRA_COST_PENALTY) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
            cast(s64) ((cast(s32) 0) << ((x.rddiv) & 31));
    RD_THRESHES := cpi.rd.threshes[MI.segment_id][bsize].data;
    SB_ROW := mi_row >> (((6 - 3)) & 31);
    thresh_freq_fact_idx := (SB_ROW * 13 + cast(s32) bsize) * 30;
    RD_THRESH_FREQ_FACT :=
        (ifx cpi.sf.adaptive_rd_thresh_row_mt != 0 then *tile_data.row_base_thresh_freq_fact[thresh_freq_fact_idx] else tile_data.thresh_freq_fact[bsize].data);

    pred_filter_search := cast(s32) (CM.interp_filter == 4);
    const_motion: [4] s32;
    BH := (cast(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[bsize]) << 2;
    BW := (cast(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[bsize]) << 2;

    tmp: [4] PRED_BUFFER = ---;
    pred_buf: [12288] u8 = --- #align 16;

    orig_dst := PD.dst;
    this_mode_pred: *PRED_BUFFER = null;
    PIXELS_IN_BLOCK := BH * BW;
    reuse_inter_pred := cast(s32) (cpi.sf.reuse_inter_pred_sby != 0 && ctx.pred_pixel_ready != 0);
    ref_frame_skip_mask: s32 = 0;

    best_pred_sad: s32 = 2147483647;
    best_early_term: s32 = 0;
    ref_frame_cost: [4] s32 = ---;
    svc_force_zero_mode: [3] s32;
    perform_intra_pred: s32 = 1;
    use_golden_nonzeromv: s32 = 1;
    force_skip_low_temp_var: s32 = 0;
    skip_ref_find_pred: [4] s32;
    sse_zeromv_normalized: u32 = U32_MAX;
    best_sse_sofar: u32 = U32_MAX;
    gf_temporal_ref: s32 = 0;
    force_test_gf_zeromv: s32 = 0;

    filter_gf_svc: INTERP_FILTER = 0;
    inter_layer_ref: MV_REFERENCE_FRAME = 2;
    SEG := *CM.seg;
    comp_modes: s32 = 0;
    num_inter_modes := (ifx cpi.use_svc != 0 then cast(s32) 8 else 12);
    flag_svc_subpel: s32 = 0;
    svc_mv_col: s32 = 0;
    svc_mv_row: s32 = 0;
    no_scaling: s32 = 0;
    large_block: s32 = 0;
    use_model_yrd_large: s32 = 0;
    thresh_svc_skip_golden: u32 = 500;
    thresh_skip_golden: u32 = 500;
    force_smooth_filter := cpi.sf.force_smooth_interpol;
    scene_change_detected :=
        cast(s32) (cpi.rc.high_source_sad != 0 ||
            cpi.use_svc != 0 && cpi.svc.high_source_sad_superframe != 0);

    init_best_pickmode(*best_pickmode);

    x.encode_breakout = ifx SEG.enabled != 0 then cpi.segment_encode_breakout[MI.segment_id] else cpi.encode_breakout;

    x.source_variance = U32_MAX;
    if cpi.sf.default_interp_filter == 3 {
        best_pickmode.best_pred_filter = 3;
        filter_gf_svc = 3;
    }
    if cpi.use_svc != 0 && SVC_.spatial_layer_id > 0 {
        layer := (SVC_.spatial_layer_id - 1) * SVC_.number_temporal_layers + SVC_.temporal_layer_id;
        LC := SVC_.layer_context.data + layer;
        if LC.scaling_factor_num == LC.scaling_factor_den {
            no_scaling = 1;
        }
    }
    if SVC_.spatial_layer_id > 0 && (SVC_.high_source_sad_superframe != 0 || no_scaling != 0) {
        thresh_svc_skip_golden = 0;
    } else if SVC_.spatial_layer_id > 0 && CM.base_qindex > 150 && CM.base_qindex > SVC_.lower_layer_qindex + 15 {
        thresh_svc_skip_golden = 100;
    } else if SVC_.spatial_layer_id > 0 && CM.base_qindex < 140 && CM.base_qindex < SVC_.lower_layer_qindex - 20 {
        thresh_svc_skip_golden = 1000;
    }

    if cpi.use_svc == 0 ||
        SVC_.use_gf_temporal_ref_current_layer != 0 && SVC_.layer_context[SVC_.temporal_layer_id].is_key_frame == 0 {
        SF_LAST := *CM.frame_refs[1 - 1].sf;
        SF_GOLDEN := *CM.frame_refs[2 - 1].sf;
        gf_temporal_ref = 1;

        if SF_LAST.x_scale_fp != SF_GOLDEN.x_scale_fp || SF_LAST.y_scale_fp != SF_GOLDEN.y_scale_fp {
            gf_temporal_ref = 0;
        } else if cpi.rc.avg_frame_low_motion > 70 {
            thresh_svc_skip_golden = 500;
        } else {
            thresh_svc_skip_golden = 0;
        }
    }

    init_ref_frame_cost(CM, XD, ref_frame_cost.data);
    fill_memory(mode_checked[0].data + 0, 0, cast,no_check(u64) (14 * 4));

    if reuse_inter_pred != 0 {
        for i: 0..cast(s32) 3 - 1 {
            tmp[i].data = pred_buf.data + PIXELS_IN_BLOCK * i;

            tmp[i].stride = BW;
            tmp[i].in_use = 0;
        }
        tmp[3].data = PD.dst.buf;
        tmp[3].stride = PD.dst.stride;
        tmp[3].in_use = 0;
    }

    x.skip_encode = cast(s32) (cpi.sf.skip_encode_frame != 0 && x.q_index < 115);
    x.skip = 0;

    if cpi.sf.cb_pred_filter_search != 0 {
        BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
        pred_filter_search =
            ifx CM.interp_filter == 4 then ((mi_row + mi_col) >> ((BSL) & 31) +
                get_chessboard_index_in_vp9_pickmode(cast,no_check(s32) CM.current_video_frame)) & 0x1 else 0;
    }

    filter_ref := CM.interp_filter;
    if cpi.sf.default_interp_filter != 3 {
        if XD.above_mi != null && is_inter_block_in_vp9_pickmode(XD.above_mi) != 0 {
            filter_ref = XD.above_mi.interp_filter;
        } else if XD.left_mi != null && is_inter_block_in_vp9_pickmode(XD.left_mi) != 0 {
            filter_ref = XD.left_mi.interp_filter;
        }
    }

    vp9_rd_cost_reset(*best_rdc);
    vp9_rd_cost_reset(rd_cost);
    MI.sb_type = bsize;
    MI.ref_frame[0] = -1;
    MI.ref_frame[1] = -1;

    MI.tx_size =
        cast,no_check(TX_SIZE) ((ifx MAX_TXSIZE_LOOKUP[bsize] < TX_MODE_TO_BIGGEST_TX_SIZE[CM.tx_mode] then cast,no_check(s32) MAX_TXSIZE_LOOKUP[bsize] else cast,no_check(s32) TX_MODE_TO_BIGGEST_TX_SIZE[CM.tx_mode]));

    if SF.short_circuit_flat_blocks != 0 || SF.limit_newmv_early_exit != 0 {
        x.source_variance = vp9_get_sby_perpixel_variance(cpi, *x.plane[0].src, bsize);

        if cpi.oxcf.content == cast,no_check(u32) VP9E_CONTENT_SCREEN &&
            cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ &&
            MI.segment_id > 0 &&
            x.zero_temp_sad_source != 0 &&
            x.source_variance == 0 {
            MI.segment_id = 0;
            vp9_init_plane_quantizers(cpi, x);
        }
    }

    usable_ref_frame: MV_REFERENCE_FRAME = ifx cpi.rc.frames_since_golden == 0 &&
        gf_temporal_ref != 0 &&
        cpi.rc.alt_ref_gf_group == 0 &&
        cpi.rc.last_frame_is_src_altref == 0
        then cast(MV_REFERENCE_FRAME) 1
        else 2;

    if cpi.oxcf.lag_in_frames > 0 && cpi.oxcf.rc_mode == cast,no_check(u32) VBR {
        if cpi.rc.alt_ref_gf_group != 0 || cpi.rc.is_src_frame_alt_ref != 0 {
            usable_ref_frame = 3;
        }

        if cpi.rc.is_src_frame_alt_ref != 0 {
            skip_ref_find_pred[1] = 1;
            skip_ref_find_pred[2] = 1;
        }
        if CM.show_frame == 0 {
            if cpi.rc.frames_since_key == 1 {
                usable_ref_frame = 1;
                skip_ref_find_pred[2] = 1;
                skip_ref_find_pred[3] = 1;
            }
        }
    }

    if cpi.use_svc != 0 && SVC_.force_zero_mode_spatial_ref != 0 && SVC_.spatial_layer_id > 0 && gf_temporal_ref == 0 {
        if cpi.ref_frame_flags & cast,no_check(s32) (VP9_LAST_FLAG) != 0 {
            REF_SF := *CM.frame_refs[1 - 1].sf;
            if vp9_is_scaled_in_vp9_pickmode(REF_SF) != 0 {
                svc_force_zero_mode[1 - 1] = 1;
                inter_layer_ref = 1;
            }
        }
        if cpi.ref_frame_flags & cast,no_check(s32) (VP9_GOLD_FLAG) != 0 {
            REF_SF := *CM.frame_refs[2 - 1].sf;
            if vp9_is_scaled_in_vp9_pickmode(REF_SF) != 0 {
                svc_force_zero_mode[2 - 1] = 1;
                inter_layer_ref = 2;
            }
        }
    }

    if cpi.sf.short_circuit_low_temp_var != 0 {
        force_skip_low_temp_var = get_force_skip_low_temp_var(x.variance_low.data + 0, mi_row, mi_col, bsize);

        if (cpi.sf.short_circuit_low_temp_var == 1 || cpi.sf.short_circuit_low_temp_var == 3) && force_skip_low_temp_var != 0 {
            usable_ref_frame = 1;
        }
    }

    if SF.disable_golden_ref != 0 &&
        (x.content_state_sb != cast,no_check(u8) K_VERY_HIGH_SAD || cpi.rc.avg_frame_low_motion < 60) {
        usable_ref_frame = 1;
    }

    if !(cpi.ref_frame_flags & cast,no_check(s32) (VP9_GOLD_FLAG) != 0 && svc_force_zero_mode[2 - 1] == 0 && force_skip_low_temp_var == 0) {
        use_golden_nonzeromv = 0;
    }

    if cpi.oxcf.speed >= 8 &&
        cpi.use_svc == 0 &&
        (cpi.rc.frames_since_golden + 1 < cast,no_check(s32) x.last_sb_high_content ||
            x.last_sb_high_content > 40 ||
            cpi.rc.frames_since_golden > 120) {
        usable_ref_frame = 1;
    }

    if CM.reference_mode == cast,no_check(u32) REFERENCE_MODE_SELECT &&
        cpi.sf.use_compound_nonrd_pickmode != 0 &&
        usable_ref_frame == 3 {
        comp_modes = 2;
    }

    if segfeature_active_in_vp9_pickmode(
        SEG,
        cast,no_check(s32) MI.segment_id,
        cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
    ) != 0 &&
        get_segdata_in_vp9_pickmode(
            SEG,
            cast,no_check(s32) MI.segment_id,
            cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
        ) == 2 {
        usable_ref_frame = 2;
        skip_ref_find_pred[2] = 0;
        thresh_svc_skip_golden = 0;
    }

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame <= usable_ref_frame {
        skip_ref_find_pred[ref_frame] =
            cast(s32) (cpi.ref_frame_flags & ref_frame_to_flag_in_vp9_pickmode(ref_frame) == 0);
        if skip_ref_find_pred[ref_frame] == 0 {
            find_predictors(
                cpi,
                x,
                ref_frame,
                frame_mv.data,
                const_motion.data,
                *ref_frame_skip_mask,
                tile_data,
                mi_row,
                mi_col,
                yv12_mb.data,
                bsize,
                force_skip_low_temp_var,
                cast(s32) (comp_modes > 0)
            );
        }
        ref_frame += 1;
    }

    if cpi.use_svc != 0 || cpi.oxcf.speed <= 7 || bsize < 9 {
        x.sb_use_mv_part = 0;
    }

    if cpi.use_svc != 0 &&
        SVC_.spatial_layer_id > 0 &&
        svc_force_zero_mode[(cast(s32) inter_layer_ref) - 1] != 0 &&
        SVC_.downsample_filter_phase[SVC_.spatial_layer_id - 1] == 8 &&
        gf_temporal_ref == 0 {
        svc_mv_col = -4;
        svc_mv_row = -4;
        flag_svc_subpel = 1;
    }

    if SVC_.spatial_layer_id > 0 &&
        no_scaling != 0 &&
        cpi.ref_frame_flags & cast,no_check(s32) (VP9_GOLD_FLAG) != 0 &&
        CM.base_qindex > SVC_.lower_layer_qindex + 10 {
        force_test_gf_zeromv = 1;
    }

    large_block =
        ifx x.content_state_sb == cast,no_check(u8) K_VERY_HIGH_SAD || x.sb_is_skin != 0 && cpi.rc.avg_frame_low_motion > 70 ||
            cpi.oxcf.speed < 7 then cast(s32) (bsize > 9) else cast(s32) (bsize >= 9);
    use_model_yrd_large =
        cast(s32) (cpi.oxcf.rc_mode == cast,no_check(u32) CBR && large_block != 0 &&
            cyclic_refresh_segment_id_boosted_in_vp9_pickmode(cast,no_check(s32) XD.mi[0].segment_id) == 0 && CM.base_qindex != 0);

    idx: s32 = 0;
    while idx < num_inter_modes + comp_modes {
        rate_mv: s32 = 0;

        i: s32 = ---;
        this_sse: s64 = ---;
        is_skippable: s32 = ---;
        this_early_term: s32 = 0;
        rd_computed: s32 = 0;
        flag_preduv_computed: [2] s32;
        inter_mv_mode: s32 = 0;
        skip_this_mv: s32 = 0;
        comp_pred: s32 = 0;
        force_mv_inter_layer: s32 = 0;
        this_mode: PREDICTION_MODE = ---;
        second_ref_frame: MV_REFERENCE_FRAME = -1;

        if idx < num_inter_modes {
            this_mode = REF_MODE_SET[idx].pred_mode;
            ref_frame = REF_MODE_SET[idx].ref_frame;

            if cpi.use_svc != 0 {
                this_mode = REF_MODE_SET_SVC[idx].pred_mode;
                ref_frame = REF_MODE_SET_SVC[idx].ref_frame;
            }
        } else {
            this_mode = 12;
            ref_frame = 1;
            if idx == num_inter_modes + comp_modes - 1 {
                ref_frame = 2;
            }
            second_ref_frame = 3;
            comp_pred = 1;
        }

        if ref_frame > usable_ref_frame {
            idx += 1;
            continue;
        }
        if skip_ref_find_pred[ref_frame] != 0 {
            idx += 1;
            continue;
        }

        if SVC_.previous_frame_is_intra_only != 0 {
            if ref_frame != 1 || frame_mv[this_mode][ref_frame].as_int != 0 {
                idx += 1;
                continue;
            }
        }

        if segfeature_active_in_vp9_pickmode(
            SEG,
            cast,no_check(s32) MI.segment_id,
            cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
        ) != 0 &&
            get_segdata_in_vp9_pickmode(
                SEG,
                cast,no_check(s32) MI.segment_id,
                cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
            ) != cast,no_check(s32) ref_frame {
            idx += 1;
            continue;
        }

        if flag_svc_subpel != 0 && ref_frame == inter_layer_ref {
            force_mv_inter_layer = 1;

            if this_mode == 13 {
                frame_mv[this_mode][ref_frame].as_mv.col = cast,no_check(s16) svc_mv_col;
                frame_mv[this_mode][ref_frame].as_mv.row = cast,no_check(s16) svc_mv_row;
            } else if cast,no_check(s32) frame_mv[this_mode][ref_frame].as_mv.col != svc_mv_col ||
                cast,no_check(s32) frame_mv[this_mode][ref_frame].as_mv.row != svc_mv_row {
                idx += 1;
                continue;
            }
        }

        if comp_pred != 0 {
            if cpi.allow_comp_inter_inter == 0 {
                idx += 1;
                continue;
            }

            if cpi.ref_frame_flags & ref_frame_to_flag_in_vp9_pickmode(second_ref_frame) == 0 {
                idx += 1;
                continue;
            }

            if segfeature_active_in_vp9_pickmode(
                SEG,
                cast,no_check(s32) MI.segment_id,
                cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
            ) != 0 {
                idx += 1;
                continue;
            }
        }

        if ref_frame == 2 &&
            cpi.oxcf.rc_mode == cast,no_check(u32) CBR &&
            (cpi.use_svc != 0 && sse_zeromv_normalized < thresh_svc_skip_golden ||
                cpi.use_svc == 0 && sse_zeromv_normalized < thresh_skip_golden) {
            idx += 1;
            continue;
        }

        if cpi.ref_frame_flags & ref_frame_to_flag_in_vp9_pickmode(ref_frame) == 0 {
            idx += 1;
            continue;
        }

        if cpi.oxcf.content == cast,no_check(u32) VP9E_CONTENT_SCREEN {
            if cpi.compute_source_sad_onepass != 0 && cpi.sf.use_source_sad != 0 {
                if frame_mv[this_mode][ref_frame].as_int != 0 && x.zero_temp_sad_source != 0 ||
                    frame_mv[this_mode][ref_frame].as_int == 0 && x.source_variance == 0 && ref_frame == 1 && x.zero_temp_sad_source == 0 {
                    idx += 1;
                    continue;
                }
            } else if frame_mv[this_mode][ref_frame].as_int != 0 && x.source_variance == 0 {
                idx += 1;
                continue;
            }
        }

        if cpi.sf.inter_mode_mask[bsize] & ((cast(s32) 1) << ((this_mode) & 31)) == 0 {
            idx += 1;
            continue;
        }

        if cpi.oxcf.lag_in_frames > 0 && cpi.oxcf.rc_mode == cast,no_check(u32) VBR {
            if cpi.rc.is_src_frame_alt_ref != 0 && (ref_frame != 3 || frame_mv[this_mode][ref_frame].as_int != 0) {
                idx += 1;
                continue;
            }

            if CM.show_frame == 0 && ref_frame == 3 && frame_mv[this_mode][ref_frame].as_int != 0 {
                idx += 1;
                continue;
            }

            if cpi.rc.alt_ref_gf_group != 0 &&
                CM.show_frame != 0 &&
                cpi.rc.frames_since_golden > cpi.rc.baseline_gf_interval >> 1 &&
                ref_frame == 2 &&
                frame_mv[this_mode][ref_frame].as_int != 0 {
                idx += 1;
                continue;
            }

            if cpi.rc.alt_ref_gf_group != 0 &&
                CM.show_frame != 0 &&
                cpi.rc.frames_since_golden > 0 &&
                cpi.rc.frames_since_golden < cpi.rc.baseline_gf_interval >> 1 &&
                ref_frame == 3 &&
                frame_mv[this_mode][ref_frame].as_int != 0 {
                idx += 1;
                continue;
            }
        }

        if const_motion[ref_frame] != 0 && this_mode == 11 {
            idx += 1;
            continue;
        }

        if force_mv_inter_layer == 0 &&
            force_skip_low_temp_var != 0 &&
            ref_frame == 2 &&
            frame_mv[this_mode][ref_frame].as_int != 0 {
            idx += 1;
            continue;
        }

        if x.content_state_sb != cast,no_check(u8) K_VERY_HIGH_SAD &&
            (cpi.sf.short_circuit_low_temp_var >= 2 || cpi.sf.short_circuit_low_temp_var == 1 && bsize == 12) &&
            force_skip_low_temp_var != 0 &&
            ref_frame == 1 &&
            this_mode == 13 {
            idx += 1;
            continue;
        }

        if cpi.use_svc != 0 {
            if force_mv_inter_layer == 0 &&
                svc_force_zero_mode[(cast(s32) ref_frame) - 1] != 0 &&
                frame_mv[this_mode][ref_frame].as_int != 0 {
                idx += 1;
                continue;
            }
        }

        if segfeature_active_in_vp9_pickmode(
            SEG,
            cast,no_check(s32) MI.segment_id,
            cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
        ) == 0 {
            if SF.reference_masking != 0 && !(frame_mv[this_mode][ref_frame].as_int == 0 && ref_frame == 1) {
                if usable_ref_frame < 3 {
                    if force_skip_low_temp_var == 0 && usable_ref_frame > 1 {
                        i = ifx ref_frame == 1 then cast(s32) 2 else 1;
                        if cpi.ref_frame_flags & ref_frame_to_flag_in_vp9_pickmode(cast,no_check(s8) i) != 0 {
                            if x.pred_mv_sad[i] < 2147483647 {
                                if x.pred_mv_sad[ref_frame] > x.pred_mv_sad[i] << 1 {
                                    ref_frame_skip_mask |= (cast(s32) 1) << ((ref_frame) & 31);
                                }
                            }
                        }
                    }
                } else if cpi.rc.is_src_frame_alt_ref == 0 && !(frame_mv[this_mode][ref_frame].as_int == 0 && ref_frame == 3) {
                    ref1 := (ifx ref_frame == 2 then cast(s32) 1 else 2);
                    ref2 := (ifx ref_frame == 3 then cast(s32) 1 else 3);
                    if cpi.ref_frame_flags & ref_frame_to_flag_in_vp9_pickmode(cast,no_check(s8) ref1) != 0 &&
                        x.pred_mv_sad[ref1] < 2147483647 &&
                        x.pred_mv_sad[ref_frame] > x.pred_mv_sad[ref1] << 1 ||
                        cpi.ref_frame_flags & ref_frame_to_flag_in_vp9_pickmode(cast,no_check(s8) ref2) != 0 &&
                            x.pred_mv_sad[ref2] < 2147483647 &&
                            x.pred_mv_sad[ref_frame] > x.pred_mv_sad[ref2] << 1 {
                        ref_frame_skip_mask |= (cast(s32) 1) << ((ref_frame) & 31);
                    }
                }
            }
            if ref_frame_skip_mask & ((cast(s32) 1) << ((ref_frame) & 31)) != 0 {
                idx += 1;
                continue;
            }
        }

        i = 0;
        while i < 3 {
            XD.plane[i].pre[0] = yv12_mb[ref_frame][i];
            if comp_pred != 0 {
                XD.plane[i].pre[1] = yv12_mb[second_ref_frame][i];
            }
            i += 1;
        }

        MI.ref_frame[0] = ref_frame;
        MI.ref_frame[1] = second_ref_frame;
        set_ref_ptrs_in_vp9_pickmode(CM, XD, ref_frame, second_ref_frame);

        mode_index := cast,no_check(s32) MODE_IDX[ref_frame][(cast(s32) this_mode) - 10];
        mode_rd_thresh :=
            (ifx best_pickmode.best_mode_skip_txfm != 0 then RD_THRESHES[mode_index] << 1 else RD_THRESHES[mode_index]);

        if cpi.sf.bias_golden != 0 && ref_frame == 2 && cpi.rc.frames_since_golden > 4 {
            mode_rd_thresh = mode_rd_thresh << 3;
        }

        if cpi.sf.adaptive_rd_thresh_row_mt != 0 &&
            rd_less_than_thresh_row_mt(best_rdc.rdcost, mode_rd_thresh, *RD_THRESH_FREQ_FACT[mode_index]) != 0 ||
            cpi.sf.adaptive_rd_thresh_row_mt == 0 &&
                rd_less_than_thresh_in_vp9_pickmode(best_rdc.rdcost, mode_rd_thresh, *RD_THRESH_FREQ_FACT[mode_index]) != 0 {
            if frame_mv[this_mode][ref_frame].as_int != 0 {
                idx += 1;
                continue;
            }
        }

        if this_mode == 13 && force_mv_inter_layer == 0 {
            if search_new_mv(
                cpi,
                x,
                frame_mv.data,
                ref_frame,
                gf_temporal_ref,
                bsize,
                mi_row,
                mi_col,
                best_pred_sad,
                *rate_mv,
                best_sse_sofar,
                *best_rdc
            ) != 0 {
                idx += 1;
                continue;
            }
        }

        inter_mv_mode = 10;
        while inter_mv_mode <= 13 {
            if inter_mv_mode == cast,no_check(s32) this_mode || comp_pred != 0 {
                inter_mv_mode += 1;
                continue;
            }
            if mode_checked[inter_mv_mode][ref_frame] != 0 &&
                frame_mv[this_mode][ref_frame].as_int == frame_mv[inter_mv_mode][ref_frame].as_int &&
                frame_mv[inter_mv_mode][ref_frame].as_int == 0 {
                skip_this_mv = 1;
                break;
            }
            inter_mv_mode += 1;
        }

        if skip_this_mv != 0 {
            idx += 1;
            continue;
        }

        if use_golden_nonzeromv != 0 && this_mode == 13 && ref_frame == 1 && frame_mv[13][1].as_int != 0x80008000 {
            backup_yv12: [3] Buf_2d;
            scaled_ref_frame := vp9_get_scaled_ref_frame(cpi, cast,no_check(s32) ref_frame);
            if scaled_ref_frame != null {
                i = 0;
                while i < 3 {
                    backup_yv12[i] = XD.plane[i].pre[0];
                    i += 1;
                }
                vp9_setup_pre_planes(XD, 0, scaled_ref_frame, mi_row, mi_col, null);
            }
            PRE_STRIDE := XD.plane[0].pre[0].stride;
            PRE_BUF :=
                XD.plane[0].pre[0].buf + (cast(s32) frame_mv[13][1].as_mv.row) >> 3 * PRE_STRIDE +
                    (cast(s32) frame_mv[13][1].as_mv.col) >> 3;
            best_pred_sad =
                cast,no_check(s32) cpi.fn_ptr[bsize].sdf(
                    x.plane[0].src.buf,
                    x.plane[0].src.stride,
                    PRE_BUF,
                    PRE_STRIDE
                );
            x.pred_mv_sad[1] = best_pred_sad;
            if scaled_ref_frame != null {
                i = 0;
                while i < 3 {
                    XD.plane[i].pre[0] = backup_yv12[i];
                    i += 1;
                }
            }
        }

        if this_mode != 10 && comp_pred == 0 && frame_mv[this_mode][ref_frame].as_int == frame_mv[10][ref_frame].as_int {
            idx += 1;
            continue;
        }

        MI.mode = this_mode;
        MI.mv[0].as_int = frame_mv[this_mode][ref_frame].as_int;
        MI.mv[1].as_int = 0;

        if reuse_inter_pred != 0 {
            if this_mode_pred == null {
                this_mode_pred = tmp.data + 3;
            } else {
                this_mode_pred = tmp.data + get_pred_buffer(tmp.data, 3);
                PD.dst.buf = this_mode_pred.data;
                PD.dst.stride = BW;
            }
        }

        if (this_mode == 13 || filter_ref == 4) &&
            pred_filter_search != 0 &&
            (ref_frame == 1 ||
                ref_frame == 2 && force_mv_inter_layer == 0 && (cpi.use_svc != 0 || cpi.oxcf.rc_mode == cast,no_check(u32) VBR)) &&
            (((cast(s32) MI.mv[0].as_mv.row) | cast(s32) MI.mv[0].as_mv.col) & 0x7) != 0 {
            rd_computed = 1;
            search_filter_ref(
                cpi,
                x,
                *this_rdc,
                mi_row,
                mi_col,
                tmp.data,
                bsize,
                reuse_inter_pred,
                *this_mode_pred,
                *var_y,
                *sse_y,
                force_smooth_filter,
                *this_early_term,
                flag_preduv_computed.data,
                use_model_yrd_large
            );
        } else {
            MI.interp_filter =
                cast,no_check(INTERP_FILTER) ((ifx filter_ref == 4 then 0 else cast,no_check(s32) filter_ref));

            if cpi.use_svc != 0 && ref_frame == 2 && svc_force_zero_mode[(cast(s32) ref_frame) - 1] != 0 {
                MI.interp_filter = filter_gf_svc;
            }

            vp9_build_inter_predictors_sby(XD, mi_row, mi_col, bsize);

            if use_model_yrd_large != 0 {
                rd_computed = 1;
                model_rd_for_sb_y_large(
                    cpi,
                    bsize,
                    x,
                    XD,
                    *this_rdc.rate,
                    *this_rdc.dist,
                    *var_y,
                    *sse_y,
                    mi_row,
                    mi_col,
                    *this_early_term,
                    flag_preduv_computed.data
                );
            } else {
                rd_computed = 1;
                model_rd_for_sb_y(cpi, bsize, x, XD, *this_rdc.rate, *this_rdc.dist, *var_y, *sse_y, 0);
            }

            if ref_frame == 1 && frame_mv[this_mode][ref_frame].as_int == 0 {
                sse_zeromv_normalized =
                    sse_y >> ((((cast(s32) B_WIDTH_LOG2_LOOKUP[bsize]) +
                        cast(s32) B_HEIGHT_LOG2_LOOKUP[bsize])) & 31);
            }
            if sse_y < best_sse_sofar {
                best_sse_sofar = sse_y;
            }
        }

        if this_early_term == 0 {
            this_sse = cast,no_check(s64) sse_y;
            block_yrd(
                cpi,
                x,
                *this_rdc,
                *is_skippable,
                *this_sse,
                bsize,
                cast,no_check(TX_SIZE) ((ifx MI.tx_size < cast(TX_SIZE) 2 then cast,no_check(s32) MI.tx_size else cast,no_check(s32) (cast(TX_SIZE) 2))),
                rd_computed,
                0
            );
            x.skip_txfm[0] = cast,no_check(u8) is_skippable;
            if is_skippable != 0 {
                this_rdc.rate =
                    cast,no_check(s32) (VP9_PROB_COST[(256 -
                        cast(s32) vp9_get_skip_prob_in_vp9_pickmode(CM, XD))]);
            } else if (((((cast,no_check(s64) this_rdc.rate) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + this_rdc.dist << ((x.rddiv) & 63)) < (((0 * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + this_sse << ((x.rddiv) & 63) {
                this_rdc.rate +=
                    cast,no_check(s32) (VP9_PROB_COST[cast,no_check(s32) vp9_get_skip_prob_in_vp9_pickmode(CM, XD)]);
            } else {
                this_rdc.rate =
                    cast,no_check(s32) (VP9_PROB_COST[(256 -
                        cast(s32) vp9_get_skip_prob_in_vp9_pickmode(CM, XD))]);
                this_rdc.dist = this_sse;
                x.skip_txfm[0] = 1;
            }

            if CM.interp_filter == 4 {
                if ((cast(s32) MI.mv[0].as_mv.row) | cast(s32) MI.mv[0].as_mv.col) & 0x7 != 0 {
                    this_rdc.rate += vp9_get_switchable_rate(cpi, XD);
                }
            }
        } else {
            if CM.interp_filter == 4 {
                if ((cast(s32) MI.mv[0].as_mv.row) | cast(s32) MI.mv[0].as_mv.col) & 0x7 != 0 {
                    this_rdc.rate += vp9_get_switchable_rate(cpi, XD);
                }
            }
            this_rdc.rate +=
                cast,no_check(s32) (VP9_PROB_COST[(256 -
                    cast(s32) vp9_get_skip_prob_in_vp9_pickmode(CM, XD))]);
        }

        if this_early_term == 0 && (x.color_sensitivity[0] != 0 || x.color_sensitivity[1] != 0) {
            rdc_uv: RD_COST = ---;
            UV_BSIZE := get_plane_block_size_in_vp9_pickmode(bsize, XD.plane.data + 1);
            if x.color_sensitivity[0] != 0 && flag_preduv_computed[0] == 0 {
                vp9_build_inter_predictors_sbp(XD, mi_row, mi_col, bsize, 1);
                flag_preduv_computed[0] = 1;
            }
            if x.color_sensitivity[1] != 0 && flag_preduv_computed[1] == 0 {
                vp9_build_inter_predictors_sbp(XD, mi_row, mi_col, bsize, 2);
                flag_preduv_computed[1] = 1;
            }
            model_rd_for_sb_uv(cpi, UV_BSIZE, x, XD, *rdc_uv, *var_y, *sse_y, 1, 2);
            this_rdc.rate += rdc_uv.rate;
            this_rdc.dist += rdc_uv.dist;
        }

        this_rdc.rate += rate_mv;
        this_rdc.rate = cast,no_check(s32) ((cast,no_check(u32) this_rdc.rate) + cpi.inter_mode_cost[x.mbmi_ext.mode_context[ref_frame]][(cast(s32) this_mode) - 10]);

        this_rdc.rate += ref_frame_cost[ref_frame];
        this_rdc.rdcost =
            ((((cast,no_check(s64) this_rdc.rate) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                this_rdc.dist << ((x.rddiv) & 63);

        if cpi.oxcf.rc_mode == cast,no_check(u32) CBR &&
            cpi.oxcf.speed >= 5 &&
            cpi.oxcf.content != cast,no_check(u32) VP9E_CONTENT_SCREEN {
            vp9_newmv_diff_bias(
                *cpi.noise_estimate,
                XD,
                this_mode,
                *this_rdc,
                bsize,
                cast,no_check(s32) frame_mv[this_mode][ref_frame].as_mv.row,
                cast,no_check(s32) frame_mv[this_mode][ref_frame].as_mv.col,
                cast(s32) (ref_frame == 1),
                cast,no_check(s32) x.lowvar_highsumdiff,
                cast,no_check(s32) x.sb_is_skin
            );
        }

        if ((cpi.allow_encode_breakout) != 0) &&
            XD.lossless == 0 &&
            scene_change_detected == 0 &&
            SVC_.high_num_blocks_with_motion == 0 {
            encode_breakout_test(
                cpi,
                x,
                bsize,
                mi_row,
                mi_col,
                ref_frame,
                this_mode,
                var_y,
                sse_y,
                yv12_mb.data,
                *this_rdc.rate,
                *this_rdc.dist,
                flag_preduv_computed.data
            );
            if x.skip != 0 {
                this_rdc.rate += rate_mv;
                this_rdc.rdcost =
                    ((((cast,no_check(s64) this_rdc.rate) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                        this_rdc.dist << ((x.rddiv) & 63);
            }
        }

        if cpi.oxcf.content == cast,no_check(u32) VP9E_CONTENT_SCREEN &&
            (scene_change_detected != 0 || SVC_.high_num_blocks_with_motion != 0) &&
            ref_frame == 1 &&
            frame_mv[this_mode][ref_frame].as_int == 0 &&
            SVC_.spatial_layer_id == 0 &&
            x.source_variance == 0 &&
            sse_y > 0 {
            this_rdc.rdcost = this_rdc.rdcost << 2;
        }

        mode_checked[this_mode][ref_frame] = 1;

        if this_rdc.rdcost < best_rdc.rdcost || x.skip != 0 {
            assignment_3: RD_COST = this_rdc;
            ((*best_rdc).*) = assignment_3;
            best_early_term = this_early_term;
            best_pickmode.best_mode = this_mode;
            best_pickmode.best_pred_filter = MI.interp_filter;
            best_pickmode.best_tx_size = MI.tx_size;
            best_pickmode.best_ref_frame = ref_frame;
            best_pickmode.best_mode_skip_txfm = x.skip_txfm[0];
            best_pickmode.best_second_ref_frame = second_ref_frame;

            if reuse_inter_pred != 0 {
                free_pred_buffer(best_pickmode.best_pred);
                best_pickmode.best_pred = this_mode_pred;
            }
        } else if reuse_inter_pred != 0 {
            free_pred_buffer(this_mode_pred);
        }

        if x.skip != 0 && (force_test_gf_zeromv == 0 || mode_checked[12][2] != 0) {
            break;
        }

        if best_early_term != 0 && idx > 0 && scene_change_detected == 0 && (force_test_gf_zeromv == 0 || mode_checked[12][2] != 0) {
            x.skip = 1;
            break;
        }
        idx += 1;
    }

    MI.mode = best_pickmode.best_mode;
    MI.interp_filter = best_pickmode.best_pred_filter;
    MI.tx_size = best_pickmode.best_tx_size;
    MI.ref_frame[0] = best_pickmode.best_ref_frame;
    MI.mv[0].as_int = frame_mv[best_pickmode.best_mode][best_pickmode.best_ref_frame].as_int;
    XD.mi[0].bmi[0].as_mv[0].as_int = MI.mv[0].as_int;
    x.skip_txfm[0] = best_pickmode.best_mode_skip_txfm;
    MI.ref_frame[1] = best_pickmode.best_second_ref_frame;

    if SVC_.spatial_layer_id != 0 && gf_temporal_ref == 0 {
        perform_intra_pred =
            cast(s32) (SVC_.temporal_layer_id == 0 || SVC_.layer_context[SVC_.temporal_layer_id].is_key_frame != 0 || cpi.ref_frame_flags & cast,no_check(s32) (VP9_GOLD_FLAG) == 0 ||
                SVC_.layer_context[SVC_.temporal_layer_id].is_key_frame == 0 && svc_force_zero_mode[(cast(s32) best_pickmode.best_ref_frame) - 1] != 0);
        inter_mode_thresh = inter_mode_thresh << 1 + inter_mode_thresh;
    }
    if cpi.oxcf.lag_in_frames > 0 && cpi.oxcf.rc_mode == cast,no_check(u32) VBR && cpi.rc.is_src_frame_alt_ref != 0 ||
        SVC_.previous_frame_is_intra_only != 0 {
        perform_intra_pred = 0;
    }

    if segfeature_active_in_vp9_pickmode(
        SEG,
        cast,no_check(s32) MI.segment_id,
        cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
    ) != 0 &&
        get_segdata_in_vp9_pickmode(
            SEG,
            cast,no_check(s32) MI.segment_id,
            cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
        ) > 0 {
        perform_intra_pred = 0;
    }

    if best_rdc.rdcost == 9223372036854775807 ||
        cpi.oxcf.content == cast,no_check(u32) VP9E_CONTENT_SCREEN && x.source_variance == 0 ||
        scene_change_detected != 0 && perform_intra_pred != 0 ||
        (force_skip_low_temp_var == 0 || bsize < 9 || x.content_state_sb == cast,no_check(u8) K_VERY_HIGH_SAD) &&
            perform_intra_pred != 0 &&
            x.skip == 0 &&
            best_rdc.rdcost > inter_mode_thresh &&
            bsize <= cpi.sf.max_intra_bsize &&
            x.skip_low_source_sad == 0 &&
            x.lowvar_highsumdiff == 0 {
        args :=
            Estimate_Block_Intra_Args.{
                cpi = cpi,
                x = x,
                mode = 0,
                skippable = 1,
                rdc = null
            };
        this_sse: s64 = 9223372036854775807;

        BEST_PRED := best_pickmode.best_pred;
        intra_tx_size :=
            cast,no_check(TX_SIZE) ((ifx MAX_TXSIZE_LOOKUP[bsize] < TX_MODE_TO_BIGGEST_TX_SIZE[cpi.common.tx_mode] then cast,no_check(s32) MAX_TXSIZE_LOOKUP[bsize] else cast,no_check(s32) TX_MODE_TO_BIGGEST_TX_SIZE[cpi.common.tx_mode]));

        if reuse_inter_pred != 0 && BEST_PRED != null {
            if BEST_PRED.data == orig_dst.buf {
                this_mode_pred = tmp.data + get_pred_buffer(tmp.data, 3);

                convolve_copy_c(
                    BEST_PRED.data,
                    cast,no_check(s64) BEST_PRED.stride,
                    this_mode_pred.data,
                    cast,no_check(s64) this_mode_pred.stride,
                    null,
                    0,
                    0,
                    0,
                    0,
                    BW,
                    BH
                );

                best_pickmode.best_pred = this_mode_pred;
            }
        }
        PD.dst = orig_dst;

        for i: 0..cast(s32) 4 - 1 {
            THIS_MODE := INTRA_MODE_LIST[i];
            mode_index := MODE_IDX[0][mode_offset(THIS_MODE)];
            mode_rd_thresh := RD_THRESHES[mode_index];

            if SF.short_circuit_flat_blocks != 0 && x.source_variance == 0 && (x.zero_temp_sad_source != 0 && THIS_MODE != 0 || i > 2) {
                continue;
            }

            if ((cast(s32) 1) << ((THIS_MODE) & 31)) & cpi.sf.intra_y_mode_bsize_mask[bsize] == 0 {
                continue;
            }

            if cpi.sf.rt_intra_dc_only_low_content != 0 && THIS_MODE != 0 && x.content_state_sb != cast,no_check(u8) K_VERY_HIGH_SAD {
                continue;
            }

            if cpi.sf.adaptive_rd_thresh_row_mt != 0 &&
                rd_less_than_thresh_row_mt(best_rdc.rdcost, mode_rd_thresh, *RD_THRESH_FREQ_FACT[mode_index]) != 0 ||
                cpi.sf.adaptive_rd_thresh_row_mt == 0 &&
                    rd_less_than_thresh_in_vp9_pickmode(best_rdc.rdcost, mode_rd_thresh, *RD_THRESH_FREQ_FACT[mode_index]) != 0 {
                if cpi.oxcf.content != cast,no_check(u32) VP9E_CONTENT_SCREEN ||
                    SVC_.spatial_layer_id > 0 ||
                    scene_change_detected == 0 && SVC_.high_num_blocks_with_motion == 0 {
                    continue;
                }
            }

            MI.mode = THIS_MODE;
            MI.ref_frame[0] = 0;
            this_rdc.dist =
                cast,no_check(s64) ((ifx true { assignment_4: s32 = cast,no_check(s32) (cast(s32) 0); (this_rdc.rate) = assignment_4; assignment_4; }));
            args.mode = THIS_MODE;
            args.skippable = 1;
            args.rdc = *this_rdc;
            MI.tx_size = intra_tx_size;

            compute_intra_yprediction(THIS_MODE, bsize, x, XD);
            model_rd_for_sb_y(cpi, bsize, x, XD, *this_rdc.rate, *this_rdc.dist, *var_y, *sse_y, 1);
            block_yrd(
                cpi,
                x,
                *this_rdc,
                *args.skippable,
                *this_sse,
                bsize,
                cast,no_check(TX_SIZE) ((ifx MI.tx_size < cast(TX_SIZE) 2 then cast,no_check(s32) MI.tx_size else cast,no_check(s32) (cast(TX_SIZE) 2))),
                1,
                1
            );

            if args.skippable != 0 {
                x.skip_txfm[0] = 1;
                this_rdc.rate =
                    cast,no_check(s32) (VP9_PROB_COST[(256 -
                        cast(s32) vp9_get_skip_prob_in_vp9_pickmode(*cpi.common, XD))]);
            } else {
                x.skip_txfm[0] = 0;
                this_rdc.rate +=
                    cast,no_check(s32) (VP9_PROB_COST[cast,no_check(s32) vp9_get_skip_prob_in_vp9_pickmode(*cpi.common, XD)]);
            }

            if cpi.oxcf.content == cast,no_check(u32) VP9E_CONTENT_SCREEN {
                if x.color_sensitivity[0] != 0 {
                    vp9_foreach_transformed_block_in_plane(
                        XD,
                        bsize,
                        1,
                        cast,no_check(Foreach_Transformed_Block_Visitor) estimate_block_intra,
                        cast(*void) *args
                    );
                }
                if x.color_sensitivity[1] != 0 {
                    vp9_foreach_transformed_block_in_plane(
                        XD,
                        bsize,
                        2,
                        cast,no_check(Foreach_Transformed_Block_Visitor) estimate_block_intra,
                        cast(*void) *args
                    );
                }
            }
            this_rdc.rate += cpi.mbmode_cost[THIS_MODE];
            this_rdc.rate += ref_frame_cost[0];
            this_rdc.rate += INTRA_COST_PENALTY;
            this_rdc.rdcost =
                ((((cast,no_check(s64) this_rdc.rate) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                    this_rdc.dist << ((x.rddiv) & 63);

            if this_rdc.rdcost < best_rdc.rdcost {
                assignment_5: RD_COST = this_rdc;
                ((*best_rdc).*) = assignment_5;
                best_pickmode.best_mode = THIS_MODE;
                best_pickmode.best_intra_tx_size = MI.tx_size;
                best_pickmode.best_ref_frame = 0;
                best_pickmode.best_second_ref_frame = -1;
                MI.uv_mode = THIS_MODE;
                MI.mv[0].as_int = 0x80008000;
                MI.mv[1].as_int = 0x80008000;
                best_pickmode.best_mode_skip_txfm = x.skip_txfm[0];
            }
        }

        if best_pickmode.best_ref_frame != 0 {
            MI.tx_size = best_pickmode.best_tx_size;
        } else {
            MI.tx_size = best_pickmode.best_intra_tx_size;
        }
    }

    PD.dst = orig_dst;
    MI.mode = best_pickmode.best_mode;
    MI.ref_frame[0] = best_pickmode.best_ref_frame;
    MI.ref_frame[1] = best_pickmode.best_second_ref_frame;
    x.skip_txfm[0] = best_pickmode.best_mode_skip_txfm;

    if is_inter_block_in_vp9_pickmode(MI) == 0 {
        MI.interp_filter = 3;
    }

    if reuse_inter_pred != 0 && best_pickmode.best_pred != null {
        BEST_PRED := best_pickmode.best_pred;
        if BEST_PRED.data != orig_dst.buf && is_inter_mode_in_vp9_pickmode(MI.mode) != 0 {
            convolve_copy_c(
                BEST_PRED.data,
                cast,no_check(s64) BEST_PRED.stride,
                PD.dst.buf,
                cast,no_check(s64) PD.dst.stride,
                null,
                0,
                0,
                0,
                0,
                BW,
                BH
            );
        }
    }

    if best_pickmode.best_ref_frame == 3 || best_pickmode.best_second_ref_frame == 3 {
        x.arf_frame_usage += 1;
    } else if best_pickmode.best_ref_frame != 0 {
        x.lastgolden_frame_usage += 1;
    }

    if cpi.sf.adaptive_rd_thresh != 0 {
        best_mode_idx := MODE_IDX[best_pickmode.best_ref_frame][mode_offset(MI.mode)];

        if best_pickmode.best_ref_frame == 0 {
            intra_modes: s32 = cast,no_check(s32) (cast(u64) INTRA_MODE_LIST.count);

            if 0 < intra_modes {
                for i: 0..intra_modes - 1 {
                    if cpi.sf.adaptive_rd_thresh_row_mt != 0 {
                        update_thresh_freq_fact_row_mt(
                            cpi,
                            tile_data,
                            x.source_variance,
                            thresh_freq_fact_idx,
                            0,
                            best_mode_idx,
                            INTRA_MODE_LIST[i]
                        );
                    } else {
                        update_thresh_freq_fact(
                            cpi,
                            tile_data,
                            x.source_variance,
                            bsize,
                            0,
                            best_mode_idx,
                            INTRA_MODE_LIST[i]
                        );
                    }
                }
            }
        } else {
            ref_frame = 1;
            while ref_frame <= 2 {
                if best_pickmode.best_ref_frame != ref_frame {
                    ref_frame += 1;
                    continue;
                }
                this_mode: PREDICTION_MODE = 10;
                while this_mode <= 13 {
                    if cpi.sf.adaptive_rd_thresh_row_mt != 0 {
                        update_thresh_freq_fact_row_mt(
                            cpi,
                            tile_data,
                            x.source_variance,
                            thresh_freq_fact_idx,
                            ref_frame,
                            best_mode_idx,
                            this_mode
                        );
                    } else {
                        update_thresh_freq_fact(
                            cpi,
                            tile_data,
                            x.source_variance,
                            bsize,
                            ref_frame,
                            best_mode_idx,
                            this_mode
                        );
                    }
                    this_mode += 1;
                }
                ref_frame += 1;
            }
        }
    }

    assignment_6: RD_COST = best_rdc;
    ((rd_cost).*) = assignment_6;
}

mode_offset :: (MODE_: PREDICTION_MODE) -> s32 {
    if MODE_ >= 10 {
        return (cast(s32) MODE_) - 10;
    } else {
        if cast,no_check(s32) MODE_ == {
            case 0;
                return 0;
            case 1;
                return 1;
            case 2;
                return 2;
            case 9;
                return 3;
            case;
                return -1;
        }
    }
    return unreachable_value(s32);
}

update_thresh_freq_fact :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    tile_data: *Tile_Data_Enc,
    source_variance: u32,
    bsize: BLOCK_SIZE,
    ref_frame: MV_REFERENCE_FRAME,
    best_mode_idx: THR_MODES_in_vp9_cx_iface,
    mode: PREDICTION_MODE
) {
    thr_mode_idx := MODE_IDX[ref_frame][mode_offset(mode)];
    freq_fact := tile_data.thresh_freq_fact[bsize].data + thr_mode_idx;
    if thr_mode_idx == best_mode_idx {
        freq_fact.* -= freq_fact.* >> 4;
    } else if cpi.sf.limit_newmv_early_exit != 0 && mode == 13 && ref_frame == 1 && source_variance < 5 {
        freq_fact.* = ifx freq_fact.* + 1 < 32 then freq_fact.* + 1 else 32;
    } else {
        freq_fact.* =
            ifx freq_fact.* + 1 < cpi.sf.adaptive_rd_thresh * 64 then freq_fact.* +
                1 else cpi.sf.adaptive_rd_thresh * 64;
    }
}

update_thresh_freq_fact_row_mt :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    tile_data: *Tile_Data_Enc,
    source_variance: u32,
    thresh_freq_fact_idx: s32,
    ref_frame: MV_REFERENCE_FRAME,
    best_mode_idx: THR_MODES_in_vp9_cx_iface,
    mode: PREDICTION_MODE
) {
    thr_mode_idx := MODE_IDX[ref_frame][mode_offset(mode)];
    freq_fact_idx := cast,no_check(s32) ((cast,no_check(u32) thresh_freq_fact_idx) + thr_mode_idx);
    freq_fact := *tile_data.row_base_thresh_freq_fact[freq_fact_idx];
    if thr_mode_idx == best_mode_idx {
        freq_fact.* -= freq_fact.* >> 4;
    } else if cpi.sf.limit_newmv_early_exit != 0 && mode == 13 && ref_frame == 1 && source_variance < 5 {
        freq_fact.* = ifx freq_fact.* + 1 < 32 then freq_fact.* + 1 else 32;
    } else {
        freq_fact.* =
            ifx freq_fact.* + 1 < cpi.sf.adaptive_rd_thresh * 64 then freq_fact.* +
                1 else cpi.sf.adaptive_rd_thresh * 64;
    }
}

compute_intra_yprediction :: (mode: PREDICTION_MODE, bsize: BLOCK_SIZE, x: *MACROBLOCK, xd: *MACROBLOCKD) {
    PD := xd.plane.data + 0;
    P := x.plane.data + 0;
    SRC_BUF_BASE := P.src.buf;
    DST_BUF_BASE := PD.dst.buf;
    SRC_STRIDE := P.src.stride;
    DST_STRIDE := PD.dst.stride;

    TX_SIZE_ := MAX_TXSIZE_LOOKUP[bsize];
    NUM_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[bsize];
    NUM_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[bsize];
    col: s32 = ---;

    MAX_BLOCKS_WIDE :=
        NUM_4X4_W +
            (ifx xd.mb_to_right_edge >= 0 then 0 else xd.mb_to_right_edge >> (((5 + PD.subsampling_x)) & 31));
    MAX_BLOCKS_HIGH :=
        NUM_4X4_H +
            (ifx xd.mb_to_bottom_edge >= 0 then 0 else xd.mb_to_bottom_edge >> (((5 + PD.subsampling_y)) & 31));

    row: s32 = 0;
    while row < MAX_BLOCKS_HIGH {
        col = 0;
        while col < MAX_BLOCKS_WIDE {
            P.src.buf = *SRC_BUF_BASE[4 * (((cast(s64) row) * cast,no_check(s64) SRC_STRIDE) + cast(s64) col)];
            PD.dst.buf = *DST_BUF_BASE[4 * (((cast(s64) row) * cast,no_check(s64) DST_STRIDE) + cast(s64) col)];
            vp9_predict_intra_block(
                xd,
                cast,no_check(s32) B_WIDTH_LOG2_LOOKUP[bsize],
                TX_SIZE_,
                mode,
                (ifx x.skip_encode != 0 then P.src.buf else PD.dst.buf),
                (ifx x.skip_encode != 0 then SRC_STRIDE else DST_STRIDE),
                PD.dst.buf,
                DST_STRIDE,
                col,
                row,
                0
            );
            col += (cast(s32) 1) << ((TX_SIZE_) & 31);
        }
        row += (cast(s32) 1) << ((TX_SIZE_) & 31);
    }
    P.src.buf = SRC_BUF_BASE;
    PD.dst.buf = DST_BUF_BASE;
}

rd_less_than_thresh_row_mt :: (best_rd: s64, thresh: s32, THRESH_FACT: *s32) -> s32 {
    is_rd_less_than_thresh :=
        cast(s32) (best_rd < ((cast,no_check(s64) thresh) * cast(s64) THRESH_FACT.*) >> 5 ||
            thresh == 2147483647);
    return is_rd_less_than_thresh;
}

get_pred_buffer :: (p: *PRED_BUFFER, len: s32) -> s32 {
    if 0 < len {
        for i: 0..len - 1 {
            if p[i].in_use == 0 {
                p[i].in_use = 1;
                return i;
            }
        }
    }
    return -1;
}

free_pred_buffer :: (p: *PRED_BUFFER) {
    if p != null {
        p.in_use = 0;
    }
}

encode_breakout_test :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    bsize: BLOCK_SIZE,
    mi_row: s32,
    mi_col: s32,
    ref_frame: MV_REFERENCE_FRAME,
    this_mode: PREDICTION_MODE,
    var_y: u32,
    sse_y: u32,
    yv12_mb: *[3] Buf_2d,
    rate: *s32,
    dist: *s64,
    flag_preduv_computed: *s32
) {
    xd := *x.e_mbd;
    MI := xd.mi[0];
    UV_SIZE := get_plane_block_size_in_vp9_pickmode(bsize, xd.plane.data + 1);
    var := var_y;
    sse := sse_y;

    thresh_ac: u32 = ---;

    thresh_dc: u32 = ---;
    motion_low: s32 = 1;

    if cpi.use_svc != 0 && ref_frame == 2 {
        return;
    }
    if MI.mv[0].as_mv.row > 64 || MI.mv[0].as_mv.row < -64 || MI.mv[0].as_mv.col > 64 || MI.mv[0].as_mv.col < -64 {
        motion_low = 0;
    }
    if x.encode_breakout > 0 && motion_low == 1 {
        MAX_THRESH: u32 = 36000;

        MIN_THRESH :=
            (ifx (cast,no_check(u32) x.encode_breakout) << 4 < MAX_THRESH then (cast,no_check(u32) x.encode_breakout) << 4 else MAX_THRESH);

        thresh_ac = cast,no_check(u32) (((cast(s32) xd.plane[0].dequant[1]) * cast(s32) xd.plane[0].dequant[1]) >> 3);

        thresh_ac =
            cast,no_check(u32) clamp_in_vp9_pickmode(
                cast,no_check(s32) thresh_ac,
                cast,no_check(s32) MIN_THRESH,
                cast,no_check(s32) MAX_THRESH
            );

        c_transpiler_compound_shr(*(thresh_ac), (((cast,no_check(u32) (8 - ((cast(s32) B_WIDTH_LOG2_LOOKUP[bsize]) + cast(s32) B_HEIGHT_LOG2_LOOKUP[bsize]))) & 31)), u32, u32);

        thresh_dc = cast,no_check(u32) (((cast(s32) xd.plane[0].dequant[0]) * cast(s32) xd.plane[0].dequant[0]) >> 6);
    } else {
        thresh_ac = 0;
        thresh_dc = 0;
    }

    if var <= thresh_ac && sse - var <= thresh_dc {
        sse_u, sse_v: u32 = ---;
        var_v: u32 = ---;
        thresh_ac_uv := thresh_ac;
        thresh_dc_uv := thresh_dc;
        if x.sb_is_skin != 0 {
            thresh_ac_uv = 0;
            thresh_dc_uv = 0;
        }

        if flag_preduv_computed[0] == 0 || flag_preduv_computed[1] == 0 {
            xd.plane[1].pre[0] = yv12_mb[ref_frame][1];
            xd.plane[2].pre[0] = yv12_mb[ref_frame][2];
            vp9_build_inter_predictors_sbuv(xd, mi_row, mi_col, bsize);
        }

        var_u :=
            cpi.fn_ptr[UV_SIZE].vf(
                x.plane[1].src.buf,
                x.plane[1].src.stride,
                xd.plane[1].dst.buf,
                xd.plane[1].dst.stride,
                *sse_u
            );

        if var_u << 2 <= thresh_ac_uv && sse_u - var_u <= thresh_dc_uv {
            var_v =
                cpi.fn_ptr[UV_SIZE].vf(
                    x.plane[2].src.buf,
                    x.plane[2].src.stride,
                    xd.plane[2].dst.buf,
                    xd.plane[2].dst.stride,
                    *sse_v
                );

            if var_v << 2 <= thresh_ac_uv && sse_v - var_v <= thresh_dc_uv {
                x.skip = 1;

                rate.* =
                    cast,no_check(s32) cpi.inter_mode_cost[x.mbmi_ext.mode_context[ref_frame]][(cast(s32) this_mode) -
                        10];

                dist.* = cast,no_check(s64) (sse << 4);
            }
        }
    }
}

vp9_newmv_diff_bias :: (
    ne: *NOISE_ESTIMATE,
    xd: *MACROBLOCKD,
    this_mode: PREDICTION_MODE,
    this_rdc: *RD_COST,
    bsize: BLOCK_SIZE,
    mv_row: s32,
    mv_col: s32,
    is_last_frame: s32,
    lowvar_highsumdiff: s32,
    is_skin: s32
) {
    if this_mode == 13 {
        al_mv_average_row: s32 = ---;
        al_mv_average_col: s32 = ---;
        left_row, left_col: s32 = ---;

        above_mv_valid: s32 = 0;
        left_mv_valid: s32 = 0;
        above_row: s32 = 0;
        above_col: s32 = 0;

        if xd.above_mi != null {
            above_mv_valid = cast(s32) (xd.above_mi.mv[0].as_int != 0x80008000);
            above_row = cast,no_check(s32) xd.above_mi.mv[0].as_mv.row;
            above_col = cast,no_check(s32) xd.above_mi.mv[0].as_mv.col;
        }
        if xd.left_mi != null {
            left_mv_valid = cast(s32) (xd.left_mi.mv[0].as_int != 0x80008000);
            left_row = cast,no_check(s32) xd.left_mi.mv[0].as_mv.row;
            left_col = cast,no_check(s32) xd.left_mi.mv[0].as_mv.col;
        }
        if above_mv_valid != 0 && left_mv_valid != 0 {
            al_mv_average_row = (above_row + left_row + 1) >> 1;
            al_mv_average_col = (above_col + left_col + 1) >> 1;
        } else if above_mv_valid != 0 {
            al_mv_average_row = above_row;
            al_mv_average_col = above_col;
        } else if left_mv_valid != 0 {
            al_mv_average_row = left_row;
            al_mv_average_col = left_col;
        } else {
            al_mv_average_col = 0;
            al_mv_average_row = al_mv_average_col;
        }
        row_diff := al_mv_average_row - mv_row;
        col_diff := al_mv_average_col - mv_col;
        if row_diff > 48 || row_diff < -48 || col_diff > 48 || col_diff < -48 {
            if bsize > 9 {
                this_rdc.rdcost = this_rdc.rdcost << 1;
            } else {
                this_rdc.rdcost = (3 * this_rdc.rdcost) >> 1;
            }
        }
    }

    if ne.enabled != 0 &&
        ne.level >= cast,no_check(u32) K_MEDIUM &&
        bsize >= 9 &&
        is_last_frame != 0 &&
        mv_row < 8 &&
        mv_row > -8 &&
        mv_col < 8 &&
        mv_col > -8 {
        this_rdc.rdcost = 7 * this_rdc.rdcost >> 3;
    } else if lowvar_highsumdiff != 0 &&
        is_skin == 0 &&
        bsize >= 6 &&
        is_last_frame != 0 &&
        mv_row < 16 &&
        mv_row > -16 &&
        mv_col < 16 &&
        mv_col > -16 {
        this_rdc.rdcost = 7 * this_rdc.rdcost >> 3;
    }
}

model_rd_for_sb_y_large :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    bsize: BLOCK_SIZE,
    x: *MACROBLOCK,
    xd: *MACROBLOCKD,
    out_rate_sum: *s32,
    out_dist_sum: *s64,
    var_y: *u32,
    sse_y: *u32,
    mi_row: s32,
    mi_col: s32,
    early_term: *s32,
    flag_preduv_computed: *s32
) {
    sse: u32 = ---;
    rate: s32 = ---;
    dist: s64 = ---;
    P := x.plane.data + 0;
    PD := xd.plane.data + 0;
    DC_QUANT := cast,no_check(u32) PD.dequant[0];
    AC_QUANT := cast,no_check(u32) PD.dequant[1];
    dc_thr := cast,no_check(s64) ((DC_QUANT * DC_QUANT) >> 6);
    ac_thr := cast,no_check(s64) ((AC_QUANT * AC_QUANT) >> 6);

    sum: s32 = ---;
    skip_dc: s32 = 0;

    BW := cast,no_check(s32) B_WIDTH_LOG2_LOOKUP[bsize];
    BH := cast,no_check(s32) B_HEIGHT_LOG2_LOOKUP[bsize];
    NUM8X8 := (cast(s32) 1) << (((BW + BH - 2)) & 31);
    sse8x8: [64] u32;
    sum8x8: [64] s32;
    var8x8: [64] u32;

    block_variance(
        P.src.buf,
        P.src.stride,
        PD.dst.buf,
        PD.dst.stride,
        (cast(s32) 4) << ((BW) & 31),
        (cast(s32) 4) << ((BH) & 31),
        *sse,
        *sum,
        8,
        sse8x8.data,
        sum8x8.data,
        var8x8.data
    );
    sum_sqr := (cast,no_check(u32) ((cast,no_check(s64) sum) * cast(s64) sum)) >> (((BW + BH + 4)) & 31);
    var := (ifx sse > sum_sqr then sse - sum_sqr else sum_sqr - sse);

    var_y.* = var;
    sse_y.* = sse;

    ac_thr *=
        cast,no_check(s64) ac_thr_factor(
            cpi.oxcf.speed,
            cpi.common.width,
            cpi.common.height,
            absolute_value(sum) >> (((BW + BH)) & 31)
        );

    tx_size := calculate_tx_size(cpi, bsize, xd, var, sse, ac_thr, x.source_variance, 0);

    if tx_size < cast(TX_SIZE) 1 {
        tx_size = 1;
    }
    xd.mi[0].tx_size = tx_size;

    if cpi.oxcf.content == cast,no_check(u32) VP9E_CONTENT_SCREEN && x.zero_temp_sad_source != 0 && x.source_variance == 0 {
        dc_thr = dc_thr << 1;
    }

    {
        sse16x16: [16] u32;
        sum16x16: [16] s32;
        var16x16: [16] u32;
        NUM16X16 := NUM8X8 >> 2;

        sse32x32: [4] u32;
        sum32x32: [4] s32;
        var32x32: [4] u32;
        NUM32X32 := NUM8X8 >> 4;

        ac_test: s32 = 1;
        dc_test: s32 = 1;
        NUM :=
            (ifx tx_size == cast(TX_SIZE) 1 then NUM8X8 else (ifx tx_size == cast(TX_SIZE) 2 then NUM16X16 else NUM32X32));
        sse_tx :=
            (ifx tx_size == cast(TX_SIZE) 1 then sse8x8.data else (ifx tx_size == cast(TX_SIZE) 2 then sse16x16.data else sse32x32.data));
        var_tx :=
            (ifx tx_size == cast(TX_SIZE) 1 then var8x8.data else (ifx tx_size == cast(TX_SIZE) 2 then var16x16.data else var32x32.data));

        if tx_size >= cast(TX_SIZE) 2 {
            calculate_variance(BW, BH, 1, sse8x8.data, sum8x8.data, var16x16.data, sse16x16.data, sum16x16.data);
        }
        if tx_size == cast(TX_SIZE) 3 {
            calculate_variance(BW, BH, 2, sse16x16.data, sum16x16.data, var32x32.data, sse32x32.data, sum32x32.data);
        }

        x.skip_txfm[0] = 0;
        if 0 < NUM {
            for k: 0..NUM - 1 {
                if !(cast,no_check(s64) var_tx[k] < ac_thr || var == 0) {
                    ac_test = 0;
                    break;
                }
            }
        }

        if 0 < NUM {
            for k: 0..NUM - 1 {
                if !(cast,no_check(s64) (sse_tx[k] - var_tx[k]) < dc_thr || sse == var) {
                    dc_test = 0;
                    break;
                }
            }
        }

        if ac_test != 0 {
            x.skip_txfm[0] = 2;

            if dc_test != 0 {
                x.skip_txfm[0] = 1;
            }
        } else if dc_test != 0 {
            skip_dc = 1;
        }
    }

    if x.skip_txfm[0] == 1 {
        skip_uv: [2] s32;
        var_uv: [2] u32 = ---;
        sse_uv: [2] u32 = ---;

        out_rate_sum.* = 0;
        out_dist_sum.* = cast,no_check(s64) (sse << 4);

        if 1 <= 2 {
            for i: 1..cast(s32) 2 {
                P_UV := x.plane.data + i;
                PD_UV := xd.plane.data + i;
                UV_TX_SIZE := get_uv_tx_size_in_vp9_pickmode(xd.mi[0], PD_UV);
                UNIT_SIZE := TXSIZE_TO_BSIZE[UV_TX_SIZE];
                UV_BSIZE := get_plane_block_size_in_vp9_pickmode(bsize, PD_UV);
                UV_BW := cast,no_check(s32) B_WIDTH_LOG2_LOOKUP[UV_BSIZE];
                UV_BH := cast,no_check(s32) B_HEIGHT_LOG2_LOOKUP[UV_BSIZE];
                SF :=
                    (UV_BW - cast(s32) B_WIDTH_LOG2_LOOKUP[UNIT_SIZE]) +
                        (UV_BH - cast(s32) B_HEIGHT_LOG2_LOOKUP[UNIT_SIZE]);
                UV_DC_THR :=
                    cast,no_check(u32) (((cast(s32) PD_UV.dequant[0]) *
                        cast(s32) PD_UV.dequant[0]) >> (((6 - SF)) & 31));
                UV_AC_THR :=
                    cast,no_check(u32) (((cast(s32) PD_UV.dequant[1]) *
                        cast(s32) PD_UV.dequant[1]) >> (((6 - SF)) & 31));
                j := i - 1;

                vp9_build_inter_predictors_sbp(xd, mi_row, mi_col, bsize, i);
                flag_preduv_computed[i - 1] = 1;
                var_uv[j] =
                    cpi.fn_ptr[UV_BSIZE].vf(
                        P_UV.src.buf,
                        P_UV.src.stride,
                        PD_UV.dst.buf,
                        PD_UV.dst.stride,
                        sse_uv.data + j
                    );

                if (var_uv[j] < UV_AC_THR || var_uv[j] == 0) && (sse_uv[j] - var_uv[j] < UV_DC_THR || sse_uv[j] == var_uv[j]) {
                    skip_uv[j] = 1;
                } else {
                    break;
                }
            }
        }

        if skip_uv[0] & skip_uv[1] != 0 {
            early_term.* = 1;
        }
        return;
    }

    if skip_dc == 0 {
        vp9_model_rd_from_var_lapndz(
            sse - var,
            cast,no_check(u32) NUM_PELS_LOG2_LOOKUP[bsize],
            DC_QUANT >> 3,
            *rate,
            *dist
        );
    }

    if skip_dc == 0 {
        out_rate_sum.* = rate >> 1;
        out_dist_sum.* = dist << 3;
    } else {
        out_rate_sum.* = 0;
        out_dist_sum.* = cast,no_check(s64) ((sse - var) << 4);
    }

    vp9_model_rd_from_var_lapndz(var, cast,no_check(u32) NUM_PELS_LOG2_LOOKUP[bsize], AC_QUANT >> 3, *rate, *dist);

    out_rate_sum.* += rate;
    out_dist_sum.* += dist << 4;
}

calculate_variance :: (
    bw: s32,
    bh: s32,
    tx_size: TX_SIZE,
    sse_i: *u32,
    sum_i: *s32,
    var_o: *u32,
    sse_o: *u32,
    sum_o: *s32
) {
    UNIT_SIZE := TXSIZE_TO_BSIZE[tx_size];
    NW := (cast(s32) 1) << (((bw - cast(s32) B_WIDTH_LOG2_LOOKUP[UNIT_SIZE])) & 31);
    NH := (cast(s32) 1) << (((bh - cast(s32) B_HEIGHT_LOG2_LOOKUP[UNIT_SIZE])) & 31);
    j: s32 = ---;
    k: s32 = 0;
    k_sqr: u32 = 0;

    i: s32 = 0;
    while i < NH {
        j = 0;
        while j < NW {
            sse_o[k] =
                sse_i[i * NW + j] + sse_i[i * NW + j + 1] +
                    sse_i[(i + 1) * NW + j] + sse_i[(i + 1) * NW + j + 1];
            sum_o[k] =
                sum_i[i * NW + j] + sum_i[i * NW + j + 1] +
                    sum_i[(i + 1) * NW + j] + sum_i[(i + 1) * NW + j + 1];
            k_sqr =
                cast,no_check(u32) (((cast,no_check(s64) sum_o[k]) *
                    cast(s64) sum_o[k]) >> (((((cast(s32) B_WIDTH_LOG2_LOOKUP[UNIT_SIZE]) + cast(s32) B_HEIGHT_LOG2_LOOKUP[UNIT_SIZE]) + 6)) & 63));
            var_o[k] = ifx sse_o[k] > k_sqr then sse_o[k] - k_sqr else k_sqr - sse_o[k];
            k += 1;
            j += 2;
        }
        i += 2;
    }
}

ac_thr_factor :: (SPEED: s32, WIDTH: s32, HEIGHT: s32, NORM_SUM: s32) -> s32 {
    if SPEED >= 8 && NORM_SUM < 5 {
        if WIDTH <= 640 && HEIGHT <= 480 {
            return 4;
        } else {
            return 2;
        }
    }
    return 1;
}

block_variance :: (
    src: *u8,
    src_stride: s32,
    ref: *u8,
    ref_stride: s32,
    w: s32,
    h: s32,
    sse: *u32,
    sum: *s32,
    block_size: s32,
    sse8x8: *u32,
    sum8x8: *s32,
    var8x8: *u32
) {
    j: s32 = ---;
    k: s32 = 0;
    k_sqr: u32 = 0;

    sse.* = 0;
    sum.* = 0;

    i: s32 = 0;
    while i < h {
        j = 0;
        while j < w {
            get8x8var_c(
                src + src_stride * i + j,
                src_stride,
                ref + ref_stride * i + j,
                ref_stride,
                *sse8x8[k],
                *sum8x8[k]
            );

            sse.* = cast,no_check(u32) (sse.* + sse8x8[k]);
            sum.* += sum8x8[k];
            k_sqr = cast,no_check(u32) (((cast,no_check(s64) sum8x8[k]) * cast(s64) sum8x8[k]) >> 6);
            var8x8[k] = ifx sse8x8[k] > k_sqr then sse8x8[k] - k_sqr else k_sqr - sse8x8[k];
            k += 1;
            j += block_size;
        }
        i += block_size;
    }
}

search_filter_ref :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    this_rdc: *RD_COST,
    mi_row: s32,
    mi_col: s32,
    tmp: *PRED_BUFFER,
    bsize: BLOCK_SIZE,
    reuse_inter_pred: s32,
    this_mode_pred: **PRED_BUFFER,
    var_y: *u32,
    sse_y: *u32,
    force_smooth_filter: s32,
    this_early_term: *s32,
    flag_preduv_computed: *s32,
    use_model_yrd_large: s32
) {
    XD := *x.e_mbd;
    MI := XD.mi[0];
    PD := XD.plane.data + 0;
    BW := (cast(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[bsize]) << 2;

    pf_rate: [3] s32;
    pf_dist: [3] s64;
    curr_rate: [3] s32;
    pf_var: [3] u32;
    pf_sse: [3] u32;
    pf_tx_size: [3] TX_SIZE;
    best_cost: s64 = 9223372036854775807;
    best_filter: INTERP_FILTER = 4;
    current_pred := this_mode_pred.*;
    skip_txfm: u8 = 0;
    best_early_term: s32 = 0;
    best_flag_preduv_computed: [2] s32;
    filter_start := cast(INTERP_FILTER) (force_smooth_filter != 0);
    filter_end: INTERP_FILTER = 1;
    filter := filter_start;
    while filter <= filter_end {
        MI.interp_filter = filter;
        vp9_build_inter_predictors_sby(XD, mi_row, mi_col, bsize);

        if use_model_yrd_large != 0 {
            model_rd_for_sb_y_large(
                cpi,
                bsize,
                x,
                XD,
                pf_rate.data + filter,
                pf_dist.data + filter,
                pf_var.data + filter,
                pf_sse.data + filter,
                mi_row,
                mi_col,
                this_early_term,
                flag_preduv_computed
            );
        } else {
            model_rd_for_sb_y(
                cpi,
                bsize,
                x,
                XD,
                pf_rate.data + filter,
                pf_dist.data + filter,
                pf_var.data + filter,
                pf_sse.data + filter,
                0
            );
        }
        curr_rate[filter] = pf_rate[filter];
        pf_rate[filter] += vp9_get_switchable_rate(cpi, XD);
        cost :=
            ((((cast,no_check(s64) pf_rate[filter]) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                pf_dist[filter] << ((x.rddiv) & 63);
        pf_tx_size[filter] = MI.tx_size;
        if cost < best_cost {
            best_filter = filter;
            best_cost = cost;
            skip_txfm = x.skip_txfm[0];
            best_early_term = this_early_term.*;
            best_flag_preduv_computed[0] = flag_preduv_computed[0];
            best_flag_preduv_computed[1] = flag_preduv_computed[1];

            if reuse_inter_pred != 0 {
                if this_mode_pred.* != current_pred {
                    free_pred_buffer(this_mode_pred.*);
                    this_mode_pred.* = current_pred;
                }
                if filter != filter_end {
                    current_pred = *tmp[get_pred_buffer(tmp, 3)];
                    PD.dst.buf = current_pred.data;
                    PD.dst.stride = BW;
                }
            }
        }
        filter += 1;
    }

    if reuse_inter_pred != 0 && this_mode_pred.* != current_pred {
        free_pred_buffer(current_pred);
    }

    MI.interp_filter = best_filter;
    MI.tx_size = pf_tx_size[best_filter];
    this_rdc.rate = curr_rate[best_filter];
    this_rdc.dist = pf_dist[best_filter];
    var_y.* = pf_var[best_filter];
    sse_y.* = pf_sse[best_filter];
    x.skip_txfm[0] = skip_txfm;
    this_early_term.* = best_early_term;
    flag_preduv_computed[0] = best_flag_preduv_computed[0];
    flag_preduv_computed[1] = best_flag_preduv_computed[1];
    if reuse_inter_pred != 0 {
        PD.dst.buf = this_mode_pred.*.data;
        PD.dst.stride = this_mode_pred.*.stride;
    } else if best_filter < filter_end {
        MI.interp_filter = best_filter;
        vp9_build_inter_predictors_sby(XD, mi_row, mi_col, bsize);
    }
}

search_new_mv :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    frame_mv: *[4] Int_Mv,
    ref_frame: MV_REFERENCE_FRAME,
    gf_temporal_ref: s32,
    bsize: BLOCK_SIZE,
    mi_row: s32,
    mi_col: s32,
    best_pred_sad: s32,
    rate_mv: *s32,
    best_sse_sofar: u32,
    best_rdc: *RD_COST
) -> s32 {
    SVC_ := *cpi.svc;
    XD := *x.e_mbd;
    MI := XD.mi[0];
    SF := *cpi.sf;

    if ref_frame > 1 && gf_temporal_ref != 0 && cpi.oxcf.rc_mode == cast,no_check(u32) CBR {
        dis: u32 = ---;
        cost_list :=
            s32.[
                2147483647,
                2147483647,
                2147483647,
                2147483647,
                2147483647
            ];

        if bsize < 6 {
            return -1;
        }

        tmp_sad :=
            cast,no_check(s32) vp9_int_pro_motion_estimation(
                cpi,
                x,
                bsize,
                mi_row,
                mi_col,
                *x.mbmi_ext.ref_mvs[ref_frame][0].as_mv
            );

        if tmp_sad > x.pred_mv_sad[1] {
            return -1;
        }
        if tmp_sad + (cast(s32) NUM_PELS_LOG2_LOOKUP[bsize]) << 4 > best_pred_sad {
            return -1;
        }

        frame_mv[13][ref_frame].as_int = MI.mv[0].as_int;
        rate_mv.* =
            vp9_mv_bit_cost(
                *frame_mv[13][ref_frame].as_mv,
                *x.mbmi_ext.ref_mvs[ref_frame][0].as_mv,
                x.nmvjointcost.data,
                x.mvcost,
                108
            );
        c_transpiler_compound_shr(*(frame_mv[13][ref_frame].as_mv.row), (cast(s32) 3), s32, s32);
        c_transpiler_compound_shr(*(frame_mv[13][ref_frame].as_mv.col), (cast(s32) 3), s32, s32);

        cpi.find_fractional_mv_step(
            x,
            *frame_mv[13][ref_frame].as_mv,
            *x.mbmi_ext.ref_mvs[ref_frame][0].as_mv,
            cpi.common.allow_high_precision_mv,
            x.errorperbit,
            cpi.fn_ptr.data + bsize,
            cast,no_check(s32) cpi.sf.mv.subpel_force_stop,
            cpi.sf.mv.subpel_search_level,
            cond_cost_list_in_vp9_pickmode(cpi, cost_list.data),
            x.nmvjointcost.data,
            x.mvcost,
            *dis,
            x.pred_sse.data + ref_frame,
            null,
            0,
            0,
            cast,no_check(s32) cpi.sf.use_accurate_subpel_search
        );
    } else if SVC_.use_base_mv != 0 && SVC_.spatial_layer_id != 0 {
        if frame_mv[13][ref_frame].as_int != 0x80008000 {
            PRE_STRIDE := XD.plane[0].pre[0].stride;
            base_mv_sse: u32 = U32_MAX;
            scale := (ifx cpi.rc.avg_frame_low_motion > 60 then cast(s32) 2 else 4);
            PRE_BUF :=
                XD.plane[0].pre[0].buf + (cast(s32) frame_mv[13][ref_frame].as_mv.row) >> 3 * PRE_STRIDE +
                    (cast(s32) frame_mv[13][ref_frame].as_mv.col) >> 3;
            cpi.fn_ptr[bsize].vf(x.plane[0].src.buf, x.plane[0].src.stride, PRE_BUF, PRE_STRIDE, *base_mv_sse);

            if cpi.use_svc != 0 &&
                SVC_.use_base_mv != 0 &&
                bsize < 6 &&
                frame_mv[13][ref_frame].as_mv.row == 0 &&
                frame_mv[13][ref_frame].as_mv.col == 0 {
                return -1;
            }

            if SF.base_mv_aggressive != 0 && base_mv_sse >> ((scale) & 31) > best_sse_sofar {
                return -1;
            }
            if base_mv_sse >> 1 < best_sse_sofar {
                base_mv_sse_normalized :=
                    base_mv_sse >> ((((cast(s32) B_WIDTH_LOG2_LOOKUP[bsize]) +
                        cast(s32) B_HEIGHT_LOG2_LOOKUP[bsize])) & 31);
                if SF.base_mv_aggressive != 0 &&
                    base_mv_sse <= best_sse_sofar &&
                    base_mv_sse_normalized < 400 &&
                    frame_mv[13][ref_frame].as_mv.row == 0 &&
                    frame_mv[13][ref_frame].as_mv.col == 0 {
                    return -1;
                }
                if combined_motion_search(
                    cpi,
                    x,
                    bsize,
                    mi_row,
                    mi_col,
                    frame_mv[13].data + ref_frame,
                    rate_mv,
                    best_rdc.rdcost,
                    1
                ) == 0 {
                    return -1;
                }
            } else if combined_motion_search(
                cpi,
                x,
                bsize,
                mi_row,
                mi_col,
                frame_mv[13].data + ref_frame,
                rate_mv,
                best_rdc.rdcost,
                0
            ) == 0 {
                return -1;
            }
        } else if combined_motion_search(
            cpi,
            x,
            bsize,
            mi_row,
            mi_col,
            frame_mv[13].data + ref_frame,
            rate_mv,
            best_rdc.rdcost,
            0
        ) == 0 {
            return -1;
        }
    } else if combined_motion_search(cpi, x, bsize, mi_row, mi_col, frame_mv[13].data + ref_frame, rate_mv, best_rdc.rdcost, 0) == 0 {
        return -1;
    }

    return 0;
}

combined_motion_search :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    bsize: BLOCK_SIZE,
    mi_row: s32,
    mi_col: s32,
    tmp_mv: *Int_Mv,
    rate_mv: *s32,
    best_rd_sofar: s64,
    use_base_mv: s32
) -> s32 {
    xd := *x.e_mbd;
    mi := xd.mi[0];
    backup_yv12: [3] Buf_2d;
    STEP_PARAM := cpi.sf.mv.fullpel_search_step_param;
    SADPB := x.sadperbit16;
    mvp_full: MV = ---;
    REF := cast,no_check(s32) mi.ref_frame[0];
    REF_MV := x.mbmi_ext.ref_mvs[REF][0].as_mv;
    center_mv: MV = ---;
    dis: u32 = ---;

    TMP_MV_LIMITS := x.mv_limits;
    rv: s32 = 0;
    cost_list: [5] s32 = ---;
    search_subpel: s32 = 1;
    scaled_ref_frame := vp9_get_scaled_ref_frame(cpi, REF);
    if scaled_ref_frame != null {
        for i: 0..cast(s32) 3 - 1 {
            backup_yv12[i] = xd.plane[i].pre[0];
        }
        vp9_setup_pre_planes(xd, 0, scaled_ref_frame, mi_row, mi_col, null);
    }
    vp9_set_mv_search_range(*x.mv_limits, *REF_MV);

    if cpi.oxcf.speed > 5 && x.lowvar_highsumdiff != 0 {
        x.mv_limits.col_min = ifx x.mv_limits.col_min > -10 then x.mv_limits.col_min else -10;
        x.mv_limits.row_min = ifx x.mv_limits.row_min > -10 then x.mv_limits.row_min else -10;
        x.mv_limits.col_max = ifx x.mv_limits.col_max < 10 then x.mv_limits.col_max else 10;
        x.mv_limits.row_max = ifx x.mv_limits.row_max < 10 then x.mv_limits.row_max else 10;
    }

    if x.mv_best_ref_index[REF] < 2 {
        mvp_full = x.mbmi_ext.ref_mvs[REF][x.mv_best_ref_index[REF]].as_mv;
    } else {
        mvp_full = x.pred_mv[REF];
    }

    c_transpiler_compound_shr(*(mvp_full.col), (cast(s32) 3), s32, s32);
    c_transpiler_compound_shr(*(mvp_full.row), (cast(s32) 3), s32, s32);

    if use_base_mv == 0 {
        center_mv = REF_MV;
    } else {
        center_mv = tmp_mv.as_mv;
    }

    if x.sb_use_mv_part != 0 {
        tmp_mv.as_mv.row = cast,no_check(s16) (x.sb_mvrow_part >> 3);
        tmp_mv.as_mv.col = cast,no_check(s16) (x.sb_mvcol_part >> 3);
    } else {
        vp9_full_pixel_search(
            cpi,
            x,
            bsize,
            *mvp_full,
            STEP_PARAM,
            cast,no_check(s32) cpi.sf.mv.search_method,
            SADPB,
            cond_cost_list_in_vp9_pickmode(cpi, cost_list.data),
            *center_mv,
            *tmp_mv.as_mv,
            2147483647,
            0
        );
    }

    x.mv_limits = TMP_MV_LIMITS;

    mvp_full.row = cast,no_check(s16) ((cast(s32) tmp_mv.as_mv.row) * 8);
    mvp_full.col = cast,no_check(s16) ((cast(s32) tmp_mv.as_mv.col) * 8);

    rate_mv.* = vp9_mv_bit_cost(*mvp_full, *REF_MV, x.nmvjointcost.data, x.mvcost, 108);

    rate_mode := cast,no_check(s32) cpi.inter_mode_cost[x.mbmi_ext.mode_context[REF]][13 - 10];
    rv =
        cast(s32) (!((((((cast,no_check(s64) (rate_mv.* + rate_mode)) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
            cast(s64) ((cast(s32) 0) << ((x.rddiv) & 31))) > best_rd_sofar));

    if cpi.use_svc != 0 && cpi.svc.non_reference_frame != 0 {
        if mvp_full.row == 0 && mvp_full.col == 0 {
            search_subpel = 0;
        }
    }

    if rv != 0 && search_subpel != 0 {
        subpel_force_stop := cpi.sf.mv.subpel_force_stop;
        if use_base_mv != 0 && cpi.sf.base_mv_aggressive != 0 {
            subpel_force_stop = cast,no_check(SUBPEL_FORCE_STOP) HALF_PEL;
        }
        if cpi.sf.mv.enable_adaptive_subpel_force_stop != 0 {
            MV_THRESH := cpi.sf.mv.adapt_subpel_force_stop.mv_thresh;
            if absolute_value(cast,no_check(s32) tmp_mv.as_mv.row) >= MV_THRESH ||
                absolute_value(cast,no_check(s32) tmp_mv.as_mv.col) >= MV_THRESH {
                subpel_force_stop = cpi.sf.mv.adapt_subpel_force_stop.force_stop_above;
            } else {
                subpel_force_stop = cpi.sf.mv.adapt_subpel_force_stop.force_stop_below;
            }
        }
        cpi.find_fractional_mv_step(
            x,
            *tmp_mv.as_mv,
            *REF_MV,
            cpi.common.allow_high_precision_mv,
            x.errorperbit,
            cpi.fn_ptr.data + bsize,
            cast,no_check(s32) subpel_force_stop,
            cpi.sf.mv.subpel_search_level,
            cond_cost_list_in_vp9_pickmode(cpi, cost_list.data),
            x.nmvjointcost.data,
            x.mvcost,
            *dis,
            x.pred_sse.data + REF,
            null,
            0,
            0,
            cast,no_check(s32) cpi.sf.use_accurate_subpel_search
        );
        rate_mv.* = vp9_mv_bit_cost(*tmp_mv.as_mv, *REF_MV, x.nmvjointcost.data, x.mvcost, 108);
    }

    if scaled_ref_frame != null {
        for i: 0..cast(s32) 3 - 1 {
            xd.plane[i].pre[0] = backup_yv12[i];
        }
    }
    return rv;
}

find_predictors :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    ref_frame: MV_REFERENCE_FRAME,
    frame_mv: *[4] Int_Mv,
    const_motion: *s32,
    ref_frame_skip_mask: *s32,
    tile_data: *Tile_Data_Enc,
    mi_row: s32,
    mi_col: s32,
    yv12_mb: *[3] Buf_2d,
    bsize: BLOCK_SIZE,
    force_skip_low_temp_var: s32,
    comp_pred_allowed: s32
) {
    CM := *cpi.common;
    XD := *x.e_mbd;
    yv12 := get_ref_frame_buffer_in_vp9_pickmode(cpi, ref_frame);
    TILE_INFO := *tile_data.tile_info;

    x.pred_mv_sad[ref_frame] = 2147483647;
    frame_mv[13][ref_frame].as_int = 0x80008000;
    frame_mv[12][ref_frame].as_int = 0;

    if cpi.ref_frame_flags & ref_frame_to_flag_in_vp9_pickmode(ref_frame) != 0 && yv12 != null {
        CANDIDATES := x.mbmi_ext.ref_mvs[ref_frame].data;
        SF := *CM.frame_refs[(cast(s32) ref_frame) - 1].sf;
        vp9_setup_pred_block(XD, yv12_mb[ref_frame].data, yv12, mi_row, mi_col, SF, SF);
        if CM.use_prev_frame_mvs != 0 || comp_pred_allowed != 0 {
            vp9_find_mv_refs(CM, XD, XD.mi[0], ref_frame, CANDIDATES, mi_row, mi_col, x.mbmi_ext.mode_context.data);
        } else {
            const_motion[ref_frame] =
                mv_refs_rt(
                    cpi,
                    CM,
                    x,
                    XD,
                    TILE_INFO,
                    XD.mi[0],
                    ref_frame,
                    CANDIDATES,
                    frame_mv[13].data + ref_frame,
                    mi_row,
                    mi_col,
                    cast(s32) (cpi.svc.use_base_mv != 0 && cpi.svc.spatial_layer_id != 0)
                );
        }
        vp9_find_best_ref_mvs(
            XD,
            CM.allow_high_precision_mv,
            CANDIDATES,
            frame_mv[10].data + ref_frame,
            frame_mv[11].data + ref_frame
        );

        if vp9_is_scaled_in_vp9_pickmode(SF) == 0 && bsize >= 3 && !(force_skip_low_temp_var != 0 && ref_frame == 2) {
            vp9_mv_pred(cpi, x, yv12_mb[ref_frame][0].buf, yv12.y_stride, cast,no_check(s32) ref_frame, bsize);
        }
    } else {
        ref_frame_skip_mask.* |= (cast(s32) 1) << ((ref_frame) & 31);
    }
}

mv_refs_rt :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    cm: *VP9_COMMON,
    x: *MACROBLOCK,
    xd: *MACROBLOCKD,
    TILE: *Tile_Info,
    mi: *MODE_INFO,
    ref_frame: MV_REFERENCE_FRAME,
    mv_ref_list: *Int_Mv,
    base_mv: *Int_Mv,
    mi_row: s32,
    mi_col: s32,
    use_base_mv: s32
) -> s32 {
    ref_sign_bias := cm.ref_frame_sign_bias.data;
    i: s32 = ---;
    refmv_count: s32 = 0;
    MV_REF_SEARCH := MV_REF_BLOCKS_in_vp9_pickmode[mi.sb_type].data;
    different_ref_found: s32 = 0;
    context_counter: s32 = 0;
    const_motion: s32 = 0;
    fill_memory(mv_ref_list, 0, size_of(Int_Mv) * cast(u64) 2);
    while done := true { // Forward-goto shim; executes at most once.
        i = 0;
        while i < 2 {
            MV_REF_ := *MV_REF_SEARCH[i];
            if is_inside_in_vp9_pickmode(TILE, mi_col, mi_row, cm.mi_rows, MV_REF_) != 0 {
                CANDIDATE_MI := xd.mi[MV_REF_.col + MV_REF_.row * xd.mi_stride];

                context_counter += MODE_2_COUNTER_in_vp9_pickmode[CANDIDATE_MI.mode];
                different_ref_found = 1;

                if CANDIDATE_MI.ref_frame[0] == ref_frame {
                    if refmv_count != 0 {
                        if (get_sub_block_mv_in_vp9_pickmode(CANDIDATE_MI, 0, MV_REF_.col, -1)).as_int != mv_ref_list[0].as_int {
                            mv_ref_list[refmv_count] =
                                get_sub_block_mv_in_vp9_pickmode(
                                    CANDIDATE_MI,
                                    0,
                                    MV_REF_.col,
                                    -1
                                );

                            break done;
                        }
                    } else {
                        assignment_7: Int_Mv = get_sub_block_mv_in_vp9_pickmode(CANDIDATE_MI, 0, MV_REF_.col, -1);
                        (mv_ref_list[c_transpiler_post_increment(*(refmv_count))]) = assignment_7;
                    }
                }
            }
            i += 1;
        }
        const_motion = 1;
        while i < 8 && refmv_count == 0 {
            MV_REF_ := *MV_REF_SEARCH[i];
            if is_inside_in_vp9_pickmode(TILE, mi_col, mi_row, cm.mi_rows, MV_REF_) != 0 {
                CANDIDATE_MI := xd.mi[MV_REF_.col + MV_REF_.row * xd.mi_stride];
                different_ref_found = 1;

                if CANDIDATE_MI.ref_frame[0] == ref_frame {
                    if refmv_count != 0 {
                        if CANDIDATE_MI.mv[0].as_int != mv_ref_list[0].as_int {
                            mv_ref_list[refmv_count] = CANDIDATE_MI.mv[0];

                            break done;
                        }
                    } else {
                        mv_ref_list[refmv_count] = CANDIDATE_MI.mv[0];
                        refmv_count += 1;
                    }
                }
            }
            i += 1;
        }
        if different_ref_found != 0 && refmv_count == 0 {
            i = 0;
            while i < 8 {
                mv_ref := *MV_REF_SEARCH[i];
                if is_inside_in_vp9_pickmode(TILE, mi_col, mi_row, cm.mi_rows, mv_ref) != 0 {
                    CANDIDATE_MI := xd.mi[mv_ref.col + mv_ref.row * xd.mi_stride];

                    if is_inter_block_in_vp9_pickmode(CANDIDATE_MI) != 0 {
                        if CANDIDATE_MI.ref_frame[0] != ref_frame {
                            if refmv_count != 0 {
                                if (scale_mv_in_vp9_pickmode(CANDIDATE_MI, 0, ref_frame, ref_sign_bias)).as_int != mv_ref_list[0].as_int {
                                    mv_ref_list[refmv_count] =
                                        scale_mv_in_vp9_pickmode(
                                            CANDIDATE_MI,
                                            0,
                                            ref_frame,
                                            ref_sign_bias
                                        );

                                    break done;
                                }
                            } else {
                                assignment_8: Int_Mv =
                                    scale_mv_in_vp9_pickmode(CANDIDATE_MI, 0, ref_frame, ref_sign_bias);
                                (mv_ref_list[c_transpiler_post_increment(*(refmv_count))]) = assignment_8;
                            }
                        }

                        if has_second_ref_in_vp9_pickmode(CANDIDATE_MI) != 0 &&
                            CANDIDATE_MI.ref_frame[1] != ref_frame &&
                            CANDIDATE_MI.mv[1].as_int != CANDIDATE_MI.mv[0].as_int {
                            if refmv_count != 0 {
                                if (scale_mv_in_vp9_pickmode(CANDIDATE_MI, 1, ref_frame, ref_sign_bias)).as_int != mv_ref_list[0].as_int {
                                    mv_ref_list[refmv_count] =
                                        scale_mv_in_vp9_pickmode(
                                            CANDIDATE_MI,
                                            1,
                                            ref_frame,
                                            ref_sign_bias
                                        );

                                    break done;
                                }
                            } else {
                                assignment_9: Int_Mv =
                                    scale_mv_in_vp9_pickmode(CANDIDATE_MI, 1, ref_frame, ref_sign_bias);
                                (mv_ref_list[c_transpiler_post_increment(*(refmv_count))]) = assignment_9;
                            }
                        }
                    }
                }
                i += 1;
            }
        }
        if use_base_mv != 0 && cpi.svc.layer_context[cpi.svc.temporal_layer_id].is_key_frame == 0 && ref_frame == 1 {
            PREV_LAYER := cpi.svc.spatial_layer_id - 1;
            INDEX := mi_col >> 1 + mi_row >> 1 * cpi.svc.mi_cols[PREV_LAYER];

            if INDEX < cpi.svc.mi_cols[PREV_LAYER] * cpi.svc.mi_rows[PREV_LAYER] {
                candidate := *cm.prev_frame.mvs[INDEX];

                if candidate.mv[0].as_int != 0x80008000 &&
                    absolute_value(cast,no_check(s32) candidate.mv[0].as_mv.row) <= (cast(s32) 32767) >> 1 &&
                    absolute_value(cast,no_check(s32) candidate.mv[0].as_mv.col) <= (cast(s32) 32767) >> 1 {
                    base_mv.as_mv.row = cast,no_check(s16) ((cast(s32) candidate.mv[0].as_mv.row) * 2);
                    base_mv.as_mv.col = cast,no_check(s16) ((cast(s32) candidate.mv[0].as_mv.col) * 2);
                    clamp_mv_ref_in_vp9_pickmode(*base_mv.as_mv, xd);
                } else {
                    base_mv.as_int = 0x80008000;
                }
            }
        }
        break done;
    }
    x.mbmi_ext.mode_context[ref_frame] = cast,no_check(u8) COUNTER_TO_CONTEXT_in_vp9_pickmode[context_counter];
    i = 0;
    while i < 2 {
        clamp_mv_ref_in_vp9_pickmode(*mv_ref_list[i].as_mv, xd);
        i += 1;
    }
    return const_motion;
}

get_force_skip_low_temp_var :: (variance_low: *u8, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    I := mi_row & 0x7 >> 1;
    J := mi_col & 0x7 >> 1;
    force_skip_low_temp_var: s32 = 0;

    if bsize == 12 {
        force_skip_low_temp_var = cast,no_check(s32) variance_low[0];
    } else if bsize == 11 {
        if mi_col & 0x7 == 0 && mi_row & 0x7 == 0 {
            force_skip_low_temp_var = cast,no_check(s32) variance_low[1];
        } else if mi_col & 0x7 == 0 && mi_row & 0x7 != 0 {
            force_skip_low_temp_var = cast,no_check(s32) variance_low[2];
        }
    } else if bsize == 10 {
        if mi_col & 0x7 == 0 && mi_row & 0x7 == 0 {
            force_skip_low_temp_var = cast,no_check(s32) variance_low[3];
        } else if mi_col & 0x7 != 0 && mi_row & 0x7 == 0 {
            force_skip_low_temp_var = cast,no_check(s32) variance_low[4];
        }
    } else if bsize == 9 {
        if mi_col & 0x7 == 0 && mi_row & 0x7 == 0 {
            force_skip_low_temp_var = cast,no_check(s32) variance_low[5];
        } else if mi_col & 0x7 != 0 && mi_row & 0x7 == 0 {
            force_skip_low_temp_var = cast,no_check(s32) variance_low[6];
        } else if mi_col & 0x7 == 0 && mi_row & 0x7 != 0 {
            force_skip_low_temp_var = cast,no_check(s32) variance_low[7];
        } else if mi_col & 0x7 != 0 && mi_row & 0x7 != 0 {
            force_skip_low_temp_var = cast,no_check(s32) variance_low[8];
        }
    } else if bsize == 6 {
        force_skip_low_temp_var = cast,no_check(s32) variance_low[POS_SHIFT_16X16[I][J]];
    } else if bsize == 8 {
        J2 := (mi_col + 2) & 0x7 >> 1;

        force_skip_low_temp_var =
            cast(s32) (variance_low[POS_SHIFT_16X16[I][J]] != 0 &&
                variance_low[POS_SHIFT_16X16[I][J2]] != 0);
    } else if bsize == 7 {
        I2 := (mi_row + 2) & 0x7 >> 1;
        force_skip_low_temp_var =
            cast(s32) (variance_low[POS_SHIFT_16X16[I][J]] != 0 &&
                variance_low[POS_SHIFT_16X16[I2][J]] != 0);
    }
    return force_skip_low_temp_var;
}

init_ref_frame_cost :: (CM: *VP9_COMMON, XD: *MACROBLOCKD, ref_frame_cost: *s32) {
    intra_inter_p := vp9_get_intra_inter_prob_in_vp9_pickmode(CM, XD);
    ref_single_p1 := vp9_get_pred_prob_single_ref_p1_in_vp9_pickmode(CM, XD);
    ref_single_p2 := vp9_get_pred_prob_single_ref_p2_in_vp9_pickmode(CM, XD);

    ref_frame_cost[0] = cast,no_check(s32) (VP9_PROB_COST[cast,no_check(s32) intra_inter_p]);
    ref_frame_cost[3] = cast,no_check(s32) (VP9_PROB_COST[(256 - cast(s32) intra_inter_p)]);
    ref_frame_cost[2] = ref_frame_cost[3];
    ref_frame_cost[1] = ref_frame_cost[2];

    ref_frame_cost[1] += cast,no_check(s32) (VP9_PROB_COST[cast,no_check(s32) ref_single_p1]);
    ref_frame_cost[2] += cast,no_check(s32) (VP9_PROB_COST[(256 - cast(s32) ref_single_p1)]);
    ref_frame_cost[3] += cast,no_check(s32) (VP9_PROB_COST[(256 - cast(s32) ref_single_p1)]);
    ref_frame_cost[2] += cast,no_check(s32) (VP9_PROB_COST[cast,no_check(s32) ref_single_p2]);
    ref_frame_cost[3] += cast,no_check(s32) (VP9_PROB_COST[(256 - cast(s32) ref_single_p2)]);
}

init_best_pickmode :: (bp: *BEST_PICKMODE) {
    bp.best_mode = 12;
    bp.best_ref_frame = 1;
    bp.best_tx_size = 4;
    bp.best_intra_tx_size = 4;
    bp.best_pred_filter = 0;
    bp.best_mode_skip_txfm = 0;
    bp.best_second_ref_frame = -1;
    bp.best_pred = null;
}

vp9_pick_inter_mode_sub8x8 :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    mi_row: s32,
    mi_col: s32,
    rd_cost: *RD_COST,
    bsize: BLOCK_SIZE,
    ctx: *PICK_MODE_CONTEXT
) {
    CM := *cpi.common;
    SF := *cpi.sf;
    XD := *x.e_mbd;
    MI := XD.mi[0];
    MBMI_EXT := x.mbmi_ext;
    SEG := *CM.seg;
    second_ref_frame: MV_REFERENCE_FRAME = -1;
    best_ref_frame: MV_REFERENCE_FRAME = -1;
    segment_id := cast,no_check(u8) MI.segment_id;
    yv12_mb: [4] [3] Buf_2d = ---;
    best_rd: s64 = 9223372036854775807;
    bsi: [4] [4] B_Mode_Info = ---;
    ref_frame_skip_mask: s32 = 0;
    NUM_4X4_BLOCKS_WIDE := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[bsize];
    NUM_4X4_BLOCKS_HIGH := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[bsize];
    idx, idy: s32 = ---;

    x.skip_encode = cast(s32) (SF.skip_encode_frame != 0 && x.q_index < 115);
    ctx.pred_pixel_ready = 0;

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame <= 2 {
        yv12 := get_ref_frame_buffer_in_vp9_pickmode(cpi, ref_frame);
        dummy_mv: [2] Int_Mv = ---;
        x.pred_mv_sad[ref_frame] = 2147483647;

        if cpi.ref_frame_flags & ref_frame_to_flag_in_vp9_pickmode(ref_frame) != 0 && yv12 != null {
            CANDIDATES := MBMI_EXT.ref_mvs[ref_frame].data;
            REF_SF := *CM.frame_refs[(cast(s32) ref_frame) - 1].sf;
            vp9_setup_pred_block(XD, yv12_mb[ref_frame].data, yv12, mi_row, mi_col, REF_SF, REF_SF);
            vp9_find_mv_refs(CM, XD, XD.mi[0], ref_frame, CANDIDATES, mi_row, mi_col, MBMI_EXT.mode_context.data);

            vp9_find_best_ref_mvs(XD, CM.allow_high_precision_mv, CANDIDATES, dummy_mv.data + 0, dummy_mv.data + 1);
        } else {
            ref_frame_skip_mask |= (cast(s32) 1) << ((ref_frame) & 31);
        }
        ref_frame += 1;
    }

    MI.sb_type = bsize;
    MI.tx_size = 0;
    MI.uv_mode = 0;
    MI.ref_frame[0] = 1;
    MI.ref_frame[1] = -1;
    MI.interp_filter =
        cast,no_check(INTERP_FILTER) ((ifx CM.interp_filter == 4 then 0 else cast,no_check(s32) CM.interp_filter));

    ref_frame = 1;
    while ref_frame <= 2 {
        this_rd: s64 = 0;

        if ref_frame_skip_mask & ((cast(s32) 1) << ((ref_frame) & 31)) != 0 {
            ref_frame += 1;
            continue;
        }

        if ref_frame > 0 && vp9_is_scaled_in_vp9_pickmode(*CM.frame_refs[(cast(s32) ref_frame) - 1].sf) != 0 {
            ref_frame += 1;
            continue;
        }

        if segfeature_active_in_vp9_pickmode(
            SEG,
            cast,no_check(s32) segment_id,
            cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
        ) != 0 &&
            get_segdata_in_vp9_pickmode(
                SEG,
                cast,no_check(s32) segment_id,
                cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
            ) != cast,no_check(s32) ref_frame {
            ref_frame += 1;
            continue;
        }

        MI.ref_frame[0] = ref_frame;
        x.skip = 0;
        set_ref_ptrs_in_vp9_pickmode(CM, XD, ref_frame, second_ref_frame);

        for plane: 0..cast(s32) 3 - 1 {
            XD.plane[plane].pre[0] = yv12_mb[ref_frame][plane];
        }

        idy = 0;
        while idy < 2 {
            idx = 0;
            while idx < 2 {
                b_mv: [14] Int_Mv = ---;
                b_best_rd: s64 = 9223372036854775807;
                I := idy * 2 + idx;

                this_rdc: RD_COST = ---;
                var_y, sse_y: u32 = ---;

                p := x.plane.data + 0;
                pd := XD.plane.data + 0;

                ORIG_SRC := p.src;
                ORIG_DST := pd.dst;
                orig_pre: [2] Buf_2d = ---;
                copy_memory(orig_pre.data, XD.plane[0].pre.data, orig_pre.count * size_of(Buf_2d));

                p.src.buf = *p.src.buf[vp9_raster_block_offset(3, I, p.src.stride)];
                pd.dst.buf = *pd.dst.buf[vp9_raster_block_offset(3, I, pd.dst.stride)];
                pd.pre[0].buf = *pd.pre[0].buf[vp9_raster_block_offset(3, I, pd.pre[0].stride)];

                b_mv[12].as_int = 0;
                b_mv[13].as_int = 0x80008000;
                vp9_append_sub8x8_mvs_for_idx(
                    CM,
                    XD,
                    I,
                    0,
                    mi_row,
                    mi_col,
                    b_mv.data + 10,
                    b_mv.data + 11,
                    MBMI_EXT.mode_context.data
                );

                this_mode: PREDICTION_MODE = 10;
                while this_mode <= 13 {
                    b_rate: s32 = 0;
                    XD.mi[0].bmi[I].as_mv[0].as_int = b_mv[this_mode].as_int;

                    if this_mode == 13 {
                        STEP_PARAM := cpi.sf.mv.fullpel_search_step_param;
                        mvp_full: MV = ---;
                        tmp_mv: MV = ---;
                        cost_list: [5] s32 = ---;
                        TMP_MV_LIMITS := x.mv_limits;
                        dummy_dist: u32 = ---;

                        if I == 0 {
                            mvp_full.row = cast,no_check(s16) ((cast(s32) b_mv[10].as_mv.row) >> 3);
                            mvp_full.col = cast,no_check(s16) ((cast(s32) b_mv[10].as_mv.col) >> 3);
                        } else {
                            mvp_full.row = cast,no_check(s16) ((cast(s32) XD.mi[0].bmi[0].as_mv[0].as_mv.row) >> 3);
                            mvp_full.col = cast,no_check(s16) ((cast(s32) XD.mi[0].bmi[0].as_mv[0].as_mv.col) >> 3);
                        }

                        vp9_set_mv_search_range(*x.mv_limits, *MBMI_EXT.ref_mvs[ref_frame][0].as_mv);

                        vp9_full_pixel_search(
                            cpi,
                            x,
                            bsize,
                            *mvp_full,
                            STEP_PARAM,
                            cast,no_check(s32) cpi.sf.mv.search_method,
                            x.sadperbit4,
                            cond_cost_list_in_vp9_pickmode(cpi, cost_list.data),
                            *MBMI_EXT.ref_mvs[ref_frame][0].as_mv,
                            *tmp_mv,
                            2147483647,
                            0
                        );

                        x.mv_limits = TMP_MV_LIMITS;

                        mvp_full.row = cast,no_check(s16) ((cast(s32) tmp_mv.row) * 8);
                        mvp_full.col = cast,no_check(s16) ((cast(s32) tmp_mv.col) * 8);

                        b_rate +=
                            vp9_mv_bit_cost(
                                *mvp_full,
                                *MBMI_EXT.ref_mvs[ref_frame][0].as_mv,
                                x.nmvjointcost.data,
                                x.mvcost,
                                108
                            );

                        b_rate = cast,no_check(s32) ((cast,no_check(u32) b_rate) + cpi.inter_mode_cost[x.mbmi_ext.mode_context[ref_frame]][13 - 10]);
                        if (((((cast,no_check(s64) b_rate) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + cast(s64) ((cast(s32) 0) << ((x.rddiv) & 31))) > b_best_rd {
                            this_mode += 1;
                            continue;
                        }

                        cpi.find_fractional_mv_step(
                            x,
                            *tmp_mv,
                            *MBMI_EXT.ref_mvs[ref_frame][0].as_mv,
                            cpi.common.allow_high_precision_mv,
                            x.errorperbit,
                            cpi.fn_ptr.data + bsize,
                            cast,no_check(s32) cpi.sf.mv.subpel_force_stop,
                            cpi.sf.mv.subpel_search_level,
                            cond_cost_list_in_vp9_pickmode(cpi, cost_list.data),
                            x.nmvjointcost.data,
                            x.mvcost,
                            *dummy_dist,
                            x.pred_sse.data + ref_frame,
                            null,
                            0,
                            0,
                            cast,no_check(s32) cpi.sf.use_accurate_subpel_search
                        );

                        XD.mi[0].bmi[I].as_mv[0].as_mv = tmp_mv;
                    } else {
                        b_rate = cast,no_check(s32) ((cast,no_check(u32) b_rate) + cpi.inter_mode_cost[x.mbmi_ext.mode_context[ref_frame]][(cast(s32) this_mode) - 10]);
                    }

                    vp9_build_inter_predictor(
                        pd.pre[0].buf,
                        pd.pre[0].stride,
                        pd.dst.buf,
                        pd.dst.stride,
                        *XD.mi[0].bmi[I].as_mv[0].as_mv,
                        *XD.block_refs[0].sf,
                        4 * NUM_4X4_BLOCKS_WIDE,
                        4 * NUM_4X4_BLOCKS_HIGH,
                        0,
                        vp9_filter_kernels[MI.interp_filter],
                        cast,no_check(Mv_Precision) MV_PRECISION_Q3,
                        mi_col * (cast(s32) 1) << 3 + 4 * I & 0x1,
                        mi_row * (cast(s32) 1) << 3 + 4 * I >> 1
                    );

                    model_rd_for_sb_y(cpi, bsize, x, XD, *this_rdc.rate, *this_rdc.dist, *var_y, *sse_y, 0);

                    this_rdc.rate += b_rate;
                    this_rdc.rdcost =
                        ((((cast,no_check(s64) this_rdc.rate) * cast(s64) x.rdmult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) +
                            this_rdc.dist << ((x.rddiv) & 63);
                    if this_rdc.rdcost < b_best_rd {
                        b_best_rd = this_rdc.rdcost;
                        bsi[ref_frame][I].as_mode = this_mode;
                        bsi[ref_frame][I].as_mv[0].as_mv = XD.mi[0].bmi[I].as_mv[0].as_mv;
                    }
                    this_mode += 1;
                }

                p.src = ORIG_SRC;
                pd.pre[0] = orig_pre[0];
                pd.dst = ORIG_DST;
                this_rd += b_best_rd;

                XD.mi[0].bmi[I] = bsi[ref_frame][I];
                if NUM_4X4_BLOCKS_WIDE > 1 {
                    XD.mi[0].bmi[I + 1] = XD.mi[0].bmi[I];
                }
                if NUM_4X4_BLOCKS_HIGH > 1 {
                    XD.mi[0].bmi[I + 2] = XD.mi[0].bmi[I];
                }
                idx += NUM_4X4_BLOCKS_WIDE;
            }
            idy += NUM_4X4_BLOCKS_HIGH;
        }

        if this_rd < best_rd {
            best_rd = this_rd;
            best_ref_frame = ref_frame;
        }
        ref_frame += 1;
    }

    MI.tx_size = 0;
    MI.ref_frame[0] = best_ref_frame;
    idy = 0;
    while idy < 2 {
        idx = 0;
        while idx < 2 {
            BLOCK_ := idy * 2 + idx;
            XD.mi[0].bmi[BLOCK_] = bsi[best_ref_frame][BLOCK_];
            if NUM_4X4_BLOCKS_WIDE > 1 {
                XD.mi[0].bmi[BLOCK_ + 1] = bsi[best_ref_frame][BLOCK_];
            }
            if NUM_4X4_BLOCKS_HIGH > 1 {
                XD.mi[0].bmi[BLOCK_ + 2] = bsi[best_ref_frame][BLOCK_];
            }
            idx += NUM_4X4_BLOCKS_WIDE;
        }
        idy += NUM_4X4_BLOCKS_HIGH;
    }
    MI.mode = XD.mi[0].bmi[3].as_mode;
    assignment_10: MODE_INFO = XD.mi[0].*;
    ((*ctx.mic).*) = assignment_10;
    assignment_11: MB_MODE_INFO_EXT = x.mbmi_ext.*;
    ((*ctx.mbmi_ext).*) = assignment_11;
    ctx.skip_txfm[0] = 0;
    ctx.skip = 0;

    rd_cost.rdcost = best_rd;
}

globals_initialization_state_for_vp9_pickmode: u32;
initialize_globals_for_vp9_pickmode :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_pickmode);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_pickmode, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_pickmode) != 2 {}
            return;
        }
    }
    K_VP9_REF_FLAG_LIST_in_vp9_pickmode =
        s32.[ 0, cast,no_check(s32) (VP9_LAST_FLAG), cast,no_check(s32) (VP9_GOLD_FLAG), cast,no_check(s32) (VP9_ALT_FLAG) ];
    SUB_PEL_FILTERS_12_in_vp9_pickmode =
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
    COUNT_TO_UPDATE_FACTOR_in_vp9_pickmode =
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
    MODE_2_COUNTER_in_vp9_pickmode =
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
    COUNTER_TO_CONTEXT_in_vp9_pickmode =
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
    MV_REF_BLOCKS_in_vp9_pickmode =
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
    IDX_N_COLUMN_TO_SUBBLOCK_in_vp9_pickmode =
        [2] s32.[
            s32.[ 1, 2 ],
            s32.[ 1, 3 ],
            s32.[ 3, 2 ],
            s32.[ 3, 3 ]
        ];
    FRAME_SCALE_FACTOR_in_vp9_pickmode = s32.[ 16, 24 ];
    RATE_THRESH_MULT_in_vp9_pickmode = float64.[ 1.0, 2.0 ];
    RCF_MULT_in_vp9_pickmode = float64.[ 1.0, 2.0 ];
    POS_SHIFT_16X16 =
        [4] s32.[
            s32.[ 9, 10, 13, 14 ],
            s32.[ 11, 12, 15, 16 ],
            s32.[ 17, 18, 21, 22 ],
            s32.[ 19, 20, 23, 24 ]
        ];
    MODE_IDX =
        [4] THR_MODES_in_vp9_cx_iface.[
            THR_MODES_in_vp9_cx_iface.[ cast,no_check(THR_MODES_in_vp9_cx_iface) THR_DC_in_vp9_cx_iface, cast,no_check(THR_MODES_in_vp9_cx_iface) THR_V_PRED_in_vp9_cx_iface, cast,no_check(THR_MODES_in_vp9_cx_iface) THR_H_PRED_in_vp9_cx_iface, cast,no_check(THR_MODES_in_vp9_cx_iface) THR_TM_in_vp9_cx_iface ],
            THR_MODES_in_vp9_cx_iface.[ cast,no_check(THR_MODES_in_vp9_cx_iface) THR_NEARESTMV, cast,no_check(THR_MODES_in_vp9_cx_iface) THR_NEARMV, cast,no_check(THR_MODES_in_vp9_cx_iface) THR_ZEROMV, cast,no_check(THR_MODES_in_vp9_cx_iface) THR_NEWMV ],
            THR_MODES_in_vp9_cx_iface.[ cast,no_check(THR_MODES_in_vp9_cx_iface) THR_NEARESTG, cast,no_check(THR_MODES_in_vp9_cx_iface) THR_NEARG, cast,no_check(THR_MODES_in_vp9_cx_iface) THR_ZEROG, cast,no_check(THR_MODES_in_vp9_cx_iface) THR_NEWG ],
            THR_MODES_in_vp9_cx_iface.[ cast,no_check(THR_MODES_in_vp9_cx_iface) THR_NEARESTA, cast,no_check(THR_MODES_in_vp9_cx_iface) THR_NEARA, cast,no_check(THR_MODES_in_vp9_cx_iface) THR_ZEROA, cast,no_check(THR_MODES_in_vp9_cx_iface) THR_NEWA ]
        ];
    INTRA_MODE_LIST = PREDICTION_MODE.[ 0, 1, 2, 9 ];
    REF_MODE_SET =
        REF_MODE.[
            REF_MODE.{ref_frame = 1, pred_mode = 12},
            REF_MODE.{ref_frame = 1, pred_mode = 10},
            REF_MODE.{ref_frame = 2, pred_mode = 12},
            REF_MODE.{ref_frame = 1, pred_mode = 11},
            REF_MODE.{ref_frame = 1, pred_mode = 13},
            REF_MODE.{ref_frame = 2, pred_mode = 10},
            REF_MODE.{ref_frame = 2, pred_mode = 11},
            REF_MODE.{ref_frame = 2, pred_mode = 13},
            REF_MODE.{ref_frame = 3, pred_mode = 12},
            REF_MODE.{ref_frame = 3, pred_mode = 10},
            REF_MODE.{ref_frame = 3, pred_mode = 11},
            REF_MODE.{ref_frame = 3, pred_mode = 13}
        ];
    REF_MODE_SET_SVC =
        REF_MODE.[
            REF_MODE.{ref_frame = 1, pred_mode = 12},
            REF_MODE.{ref_frame = 1, pred_mode = 10},
            REF_MODE.{ref_frame = 1, pred_mode = 11},
            REF_MODE.{ref_frame = 2, pred_mode = 12},
            REF_MODE.{ref_frame = 2, pred_mode = 10},
            REF_MODE.{ref_frame = 2, pred_mode = 11},
            REF_MODE.{ref_frame = 1, pred_mode = 13},
            REF_MODE.{ref_frame = 2, pred_mode = 13}
        ];
    atomic_store(*globals_initialization_state_for_vp9_pickmode, 2);
}

