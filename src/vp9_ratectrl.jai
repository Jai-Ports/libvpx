// Generated directly from C by cpp_transpiler.
COUNT_TO_UPDATE_FACTOR_in_vp9_ratectrl: [21] s32;

SUB_PEL_FILTERS_12_in_vp9_ratectrl: [16] Interp_Kernel12 #align 256;

FRAME_SCALE_FACTOR_in_vp9_ratectrl: [2] s32;

RATE_THRESH_MULT_in_vp9_ratectrl: [2] float64;

RCF_MULT_in_vp9_ratectrl: [2] float64;

FACTOR_SAFE: float64;

rtc_minq_8: [256] s32;

inter_minq_8: [256] s32;

arfgf_high_motion_minq_8: [256] s32;

arfgf_low_motion_minq_8: [256] s32;

kf_high_motion_minq_8: [256] s32;

kf_low_motion_minq_8: [256] s32;

KF_RATIO: s32;

RATE_FACTOR_DELTAS: [5] float64;

CQ_ADJUST_THRESHOLD: float64;

gf_high: s32;

gf_low: s32;

kf_high: s32;

kf_low: s32;

CQ_ADJUST_THRESHOLD_storage: float64;

K_VP9_REF_FLAG_LIST_in_vp9_ratectrl: [4] s32;

clip_pixel_in_vp9_ratectrl :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_ratectrl :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_ratectrl :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_ratectrl :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_ratectrl :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_ratectrl(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_ratectrl(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_ratectrl(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_ratectrl :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_vp9_ratectrl :: (FILTER: *s16) -> s32 {
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

get_prob_in_vp9_ratectrl :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_ratectrl :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_ratectrl(n0, DEN);
}

weighted_prob_in_vp9_ratectrl :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_ratectrl :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_ratectrl(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_ratectrl(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_ratectrl :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_ratectrl[COUNT];
        PROB := get_prob_in_vp9_ratectrl(ct[0], DEN);
        return weighted_prob_in_vp9_ratectrl(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_lsb_in_vp9_ratectrl :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_ratectrl :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_ratectrl :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_ratectrl(num_values) + 1 else 0;
}

get_band_translate_in_vp9_ratectrl :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_ratectrl :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_ratectrl :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_ratectrl(above_ec, left_ec);
}

is_zero_mv_in_vp9_ratectrl :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_ratectrl :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_ratectrl :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_ratectrl(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_ratectrl(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_ratectrl :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_ratectrl :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_ratectrl :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_ratectrl :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

vp9_is_valid_scale_in_vp9_ratectrl :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_ratectrl :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_ratectrl(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_ratectrl :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_ratectrl :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_ratectrl :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_ratectrl :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_ratectrl :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_ratectrl :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_ratectrl :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_ratectrl :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_ratectrl :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_ratectrl :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_ratectrl :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_ratectrl(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_ratectrl :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_ratectrl(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_ratectrl(MI, ib)];
}

get_uv_tx_size_in_vp9_ratectrl :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_ratectrl :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_ratectrl :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_ratectrl(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_ratectrl :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_ratectrl :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_ratectrl :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_ratectrl :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_ratectrl :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_ratectrl :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_ratectrl :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_ratectrl :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_ratectrl :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_ratectrl :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_ratectrl :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_ratectrl :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_ratectrl :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_ratectrl(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_ratectrl :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_ratectrl(cm.mi_cols);

        if get_plane_type_in_vp9_ratectrl(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_ratectrl(cm, xd);
}

get_partition_probs_in_vp9_ratectrl :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_ratectrl :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_ratectrl :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_ratectrl :: (
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

update_partition_context_in_vp9_ratectrl :: (
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

partition_plane_context_in_vp9_ratectrl :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

cyclic_refresh_segment_id_boosted_in_vp9_ratectrl :: (segment_id: s32) -> s32 {
    if segment_id == 1 || segment_id == 2 {
        return 1;
    }
    return 0;
}

cyclic_refresh_segment_id_in_vp9_ratectrl :: (segment_id: s32) -> s32 {
    if segment_id == 1 {
        return 1;
    } else if segment_id == 2 {
        return 2;
    } else {
        return 0;
    }
}

vp8_set_reference_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_vp9_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

gcd_in_vp9_ratectrl :: (a: s64, b: s32) -> s32 {
    while b != 0 {
        r := cast,no_check(s32) (a % cast(s64) b);
        a = cast,no_check(s64) b;
        b = r;
    }

    return cast,no_check(s32) a;
}

reduce_ratio_in_vp9_ratectrl :: (ratio: *Rational64_T) {
    DENOM := gcd_in_vp9_ratectrl(ratio.num, ratio.den);
    ratio.num /= cast,no_check(s64) DENOM;
    ratio.den /= DENOM;
}

vp9_rc_init :: (oxcf: *VP9_Encoder_Config, pass: s32, rc: *RATE_CONTROL) {
    if pass == 0 && oxcf.rc_mode == cast,no_check(u32) CBR {
        rc.avg_frame_qindex[KEY_FRAME] = oxcf.worst_allowed_q;
        rc.avg_frame_qindex[INTER_FRAME] = oxcf.worst_allowed_q;
    } else {
        rc.avg_frame_qindex[KEY_FRAME] = (oxcf.worst_allowed_q + oxcf.best_allowed_q) / 2;
        rc.avg_frame_qindex[INTER_FRAME] = (oxcf.worst_allowed_q + oxcf.best_allowed_q) / 2;
    }

    rc.last_q[KEY_FRAME] = oxcf.best_allowed_q;
    rc.last_q[INTER_FRAME] = oxcf.worst_allowed_q;

    rc.buffer_level = rc.starting_buffer_level;
    rc.bits_off_target = rc.starting_buffer_level;

    rc.rolling_target_bits = rc.avg_frame_bandwidth;
    rc.rolling_actual_bits = rc.avg_frame_bandwidth;
    rc.long_rolling_target_bits = rc.avg_frame_bandwidth;
    rc.long_rolling_actual_bits = rc.avg_frame_bandwidth;

    rc.total_actual_bits = 0;
    rc.total_target_bits = 0;
    rc.total_target_vs_actual = 0;
    rc.avg_frame_low_motion = 0;
    rc.count_last_scene_change = 0;
    rc.af_ratio_onepass_vbr = 10;
    rc.prev_avg_source_sad_lag = 0;
    rc.high_source_sad = 0;
    rc.reset_high_source_sad = 0;
    rc.high_source_sad_lagindex = -1;
    rc.high_num_blocks_with_motion = 0;
    rc.hybrid_intra_scene_change = 0;
    rc.re_encode_maxq_scene_change = 0;
    rc.alt_ref_gf_group = 0;
    rc.last_frame_is_src_altref = 0;
    rc.fac_active_worst_inter = 150;
    rc.fac_active_worst_gf = 100;
    rc.force_qpmin = 0;
    i: s32 = 0;
    while i < 25 {
        rc.avg_source_sad[i] = 0;
        i += 1;
    }
    rc.frames_to_key = 0;
    rc.frames_since_key = 8;
    rc.this_key_frame_forced = 0;
    rc.next_key_frame_forced = 0;
    rc.source_alt_ref_pending = 0;
    rc.source_alt_ref_active = 0;

    rc.frames_till_gf_update_due = 0;
    rc.constrain_gf_key_freq_onepass_vbr = 1;
    rc.ni_av_qi = oxcf.worst_allowed_q;
    rc.ni_tot_qi = 0;
    rc.ni_frames = 0;

    rc.tot_q = 0.0;
    rc.avg_q = vp9_convert_qindex_to_q(oxcf.worst_allowed_q, oxcf.bit_depth);

    i = 0;
    while i < RATE_FACTOR_LEVELS {
        rc.rate_correction_factors[i] = 1.0;
        rc.damped_adjustment[i] = 0;
        i += 1;
    }

    rc.min_gf_interval = oxcf.min_gf_interval;
    rc.max_gf_interval = oxcf.max_gf_interval;
    if rc.min_gf_interval == 0 {
        rc.min_gf_interval = vp9_rc_get_default_min_gf_interval(oxcf.width, oxcf.height, oxcf.init_framerate);
    }
    if rc.max_gf_interval == 0 {
        rc.max_gf_interval = vp9_rc_get_default_max_gf_interval(oxcf.init_framerate, rc.min_gf_interval);
    }
    rc.baseline_gf_interval = (rc.min_gf_interval + rc.max_gf_interval) / 2;
    if oxcf.pass == 0 && oxcf.rc_mode == cast,no_check(u32) Q {
        rc.static_scene_max_gf_interval = 8;
    } else {
        rc.static_scene_max_gf_interval = 250;
    }

    rc.force_max_q = 0;
    rc.last_post_encode_dropped_scene_change = 0;
    rc.use_post_encode_drop = 0;
    rc.ext_use_post_encode_drop = 0;
    rc.disable_overshoot_maxq_cbr = 0;
    rc.arf_active_best_quality_adjustment_factor = 1.0;
    rc.arf_increase_active_best_quality = 0;
    rc.preserve_arf_as_gld = 0;
    rc.preserve_next_arf_as_gld = 0;
    rc.show_arf_as_gld = 0;
}

vp9_rc_get_default_max_gf_interval :: (framerate: float64, min_gf_interval: s32) -> s32 {
    interval :=
        (ifx 16 < cast,no_check(s32) c_transpiler_math_round(framerate *
            0.75) then 16 else cast,no_check(s32) c_transpiler_math_round(framerate * 0.75));
    interval += interval & 0x1;
    return max(interval, min_gf_interval);
}

vp9_rc_get_default_min_gf_interval :: (width: s32, height: s32, framerate: float64) -> s32 {
    FACTOR := (width * height) * framerate;
    DEFAULT_INTERVAL := clamp_in_vp9_ratectrl(cast,no_check(s32) c_transpiler_math_round(framerate * 0.125), 4, 16);

    if c_transpiler_float_less_equal(FACTOR, 165888000.0) {
        return DEFAULT_INTERVAL;
    } else {
        return ifx DEFAULT_INTERVAL > cast,no_check(s32) c_transpiler_math_round(4.0 * FACTOR / 165888000.0) then DEFAULT_INTERVAL else cast,no_check(s32) c_transpiler_math_round(4.0 * FACTOR / 165888000.0);
    }
}

vp9_convert_qindex_to_q :: (qindex: s32, bit_depth: Bit_Depth_T) -> float64 {
    return (cast,no_check(float64) vp9_ac_quant(qindex, 0, bit_depth)) / 4.0;
}

vp9_estimate_bits_at_q :: (
    frame_type: FRAME_TYPE,
    q: s32,
    mbs: s32,
    correction_factor: float64,
    bit_depth: Bit_Depth_T
) -> s32 {
    BPM := vp9_rc_bits_per_mb(frame_type, q, correction_factor, bit_depth);
    return ifx 200 > cast,no_check(s32) (((cast,no_check(u64) BPM) * cast,no_check(u64) mbs) >> 9) then 200 else cast,no_check(s32) (((cast,no_check(u64) BPM) * cast,no_check(u64) mbs) >> 9);
}

vp9_rc_bits_per_mb :: (frame_type: FRAME_TYPE, qindex: s32, correction_factor: float64, bit_depth: Bit_Depth_T) -> s32 {
    Q := vp9_convert_qindex_to_q(qindex, bit_depth);
    enumerator := (ifx frame_type == cast,no_check(u32) KEY_FRAME then cast(s32) 2700000 else 1800000);

    enumerator += (cast,no_check(s32) (enumerator * Q)) >> 12;
    return cast,no_check(s32) (enumerator * correction_factor / Q);
}

vp9_convert_q_to_qindex :: (q_val: float64, bit_depth: Bit_Depth_T) -> s32 {
    i: s32 = 0;
    while i < (cast,no_check(s32) ((255 - 0))) + 1 {
        if c_transpiler_float_greater_equal(vp9_convert_qindex_to_q(i, bit_depth), q_val) {
            break;
        }
        i += 1;
    }

    if i == (cast,no_check(s32) ((255 - 0))) + 1 {
        i -= 1;
    }

    return i;
}

vp9_rc_init_minq_luts :: () {
    init_minq_luts(
        kf_low_motion_minq_8.data,
        kf_high_motion_minq_8.data,
        arfgf_low_motion_minq_8.data,
        arfgf_high_motion_minq_8.data,
        inter_minq_8.data,
        rtc_minq_8.data,
        cast,no_check(Bit_Depth_T) BITS_8
    );
}

init_minq_luts :: (
    kf_low_m: *s32,
    kf_high_m: *s32,
    arfgf_low: *s32,
    arfgf_high: *s32,
    inter: *s32,
    rtc: *s32,
    bit_depth: Bit_Depth_T
) {
    for i: 0..cast(s32) ((cast,no_check(s32) ((255 - 0))) + 1) - 1 {
        MAXQ_ := vp9_convert_qindex_to_q(i, bit_depth);
        kf_low_m[i] = get_minq_index(MAXQ_, 0.000001, -0.0004, 0.15, bit_depth);
        kf_high_m[i] = get_minq_index(MAXQ_, 0.0000021, -0.00125, 0.45, bit_depth);

        arfgf_low[i] = get_minq_index(MAXQ_, 0.0000015, -0.0009, 0.3, bit_depth);
        inter[i] = get_minq_index(MAXQ_, 0.00000271, -0.00113, 0.7, bit_depth);

        arfgf_high[i] = get_minq_index(MAXQ_, 0.0000021, -0.00125, 0.55, bit_depth);
        rtc[i] = get_minq_index(MAXQ_, 0.00000271, -0.00113, 0.7, bit_depth);
    }
}

get_minq_index :: (maxq: float64, x3: float64, x2: float64, x1: float64, bit_depth: Bit_Depth_T) -> s32 {
    MINQTARGET :=
        (ifx c_transpiler_float_less((((x3 * maxq + x2) * maxq + x1) * maxq), maxq) then ((x3 * maxq + x2) * maxq + x1) *
            maxq else maxq);

    if c_transpiler_float_less_equal(MINQTARGET, 2.0) {
        return 0;
    }

    for i: 0..cast(s32) ((cast,no_check(s32) ((255 - 0))) + 1) - 1 {
        if c_transpiler_float_less_equal(MINQTARGET, vp9_convert_qindex_to_q(i, bit_depth)) {
            return i;
        }
    }

    return (cast,no_check(s32) ((255 - 0))) + 1 - 1;
}

vp9_rc_get_one_pass_vbr_params :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    RC := *cpi.rc;

    if cpi.refresh_alt_ref_frame == 0 &&
        (CM.current_video_frame == 0 ||
            cpi.frame_flags & cast,no_check(s32) (FRAMEFLAGS_KEY_in_vp9_cx_iface) != 0 ||
            RC.frames_to_key == 0 ||
            cpi.oxcf.mode != cpi.deadline_mode_previous_frame) {
        CM.frame_type = cast,no_check(FRAME_TYPE) KEY_FRAME;
        RC.this_key_frame_forced = cast(s32) (CM.current_video_frame != 0 && RC.frames_to_key == 0);
        RC.frames_to_key = cpi.oxcf.key_freq;
        RC.kf_boost = 2000;
        RC.source_alt_ref_active = 0;
    } else {
        CM.frame_type = cast,no_check(FRAME_TYPE) INTER_FRAME;
    }
    vp9_set_gf_update_one_pass_vbr(cpi);
    target: s32 = ifx CM.frame_type == cast,no_check(u32) KEY_FRAME
        then vp9_calc_iframe_target_size_one_pass_vbr(cpi)
        else vp9_calc_pframe_target_size_one_pass_vbr(cpi);
    vp9_rc_set_frame_target(cpi, target);
    if CM.show_frame != 0 {
        vp9_update_buffer_level_preencode(cpi);
    }
    if cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ && cpi.oxcf.pass == 0 {
        vp9_cyclic_refresh_update_parameters(cpi);
    }
}

vp9_update_buffer_level_preencode :: (cpi: *VP9_COMP_in_vp9_encoder) {
    RC := *cpi.rc;
    RC.bits_off_target += cast,no_check(s64) RC.avg_frame_bandwidth;

    RC.bits_off_target =
        ifx RC.bits_off_target < RC.maximum_buffer_size then RC.bits_off_target else RC.maximum_buffer_size;
    RC.buffer_level = RC.bits_off_target;
}

vp9_rc_set_frame_target :: (cpi: *VP9_COMP_in_vp9_encoder, target: s32) {
    CM := *cpi.common;
    RC := *cpi.rc;

    RC.this_frame_target = target;

    if cpi.oxcf.resize_mode == cast,no_check(u32) RESIZE_DYNAMIC && RC.frame_size_selector != cast,no_check(u32) UNSCALED {
        RC.this_frame_target =
            cast,no_check(s32) (RC.this_frame_target *
                RATE_THRESH_MULT_in_vp9_ratectrl[RC.frame_size_selector]);
    }

    SB64_TARGET_RATE := (((cast,no_check(s64) RC.this_frame_target) * 64) * 64) / cast(s64) (CM.width * CM.height);
    RC.sb64_target_rate =
        cast,no_check(s32) ((ifx SB64_TARGET_RATE < 2147483647 then SB64_TARGET_RATE else 2147483647));
}

vp9_calc_pframe_target_size_one_pass_vbr :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    RC := *cpi.rc;
    AF_RATIO := RC.af_ratio_onepass_vbr;
    target :=
        (ifx RC.is_src_frame_alt_ref == 0 &&
            (cpi.refresh_golden_frame != 0 || cpi.refresh_alt_ref_frame != 0) then (((cast,no_check(s64) RC.avg_frame_bandwidth) * cast(s64) RC.baseline_gf_interval) * cast(s64) AF_RATIO) / cast(s64) (RC.baseline_gf_interval + AF_RATIO - 1) else ((cast,no_check(s64) RC.avg_frame_bandwidth) * cast(s64) RC.baseline_gf_interval) / cast(s64) (RC.baseline_gf_interval + AF_RATIO - 1));

    if cpi.use_svc != 0 {
        target = cast,no_check(s64) vp9_calc_pframe_target_size_one_pass_cbr(cpi);
    }
    if target > 2147483647 {
        target = 2147483647;
    }
    return vp9_rc_clamp_pframe_target_size(cpi, cast,no_check(s32) target);
}

vp9_rc_clamp_pframe_target_size :: (CPI: *VP9_COMP_in_vp9_encoder, target: s32) -> s32 {
    rc := *CPI.rc;
    oxcf := *CPI.oxcf;

    MIN_FRAME_TARGET :=
        (ifx rc.min_frame_bandwidth > rc.avg_frame_bandwidth >> 5 then rc.min_frame_bandwidth else rc.avg_frame_bandwidth >> 5);
    if target < MIN_FRAME_TARGET {
        target = MIN_FRAME_TARGET;
    }
    if CPI.refresh_golden_frame != 0 && rc.is_src_frame_alt_ref != 0 {
        target = MIN_FRAME_TARGET;
    }

    if target > rc.max_frame_bandwidth {
        target = rc.max_frame_bandwidth;
    }

    if oxcf.rc_max_inter_bitrate_pct != 0 {
        MAX_RATE := ((cast,no_check(s64) rc.avg_frame_bandwidth) * cast(s64) oxcf.rc_max_inter_bitrate_pct) / 100;

        target = cast,no_check(s32) (min(cast,no_check(s64) target, MAX_RATE));
    }
    return target;
}

vp9_calc_pframe_target_size_one_pass_cbr :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    oxcf := *cpi.oxcf;
    rc := *cpi.rc;
    SVC_ := *cpi.svc;
    DIFF := rc.optimal_buffer_level - rc.buffer_level;
    ONE_PCT_BITS := 1 + rc.optimal_buffer_level / 100;
    min_frame_target := (ifx rc.avg_frame_bandwidth >> 4 > 200 then rc.avg_frame_bandwidth >> 4 else 200);
    target: s64 = ---;

    if oxcf.gf_cbr_boost_pct != 0 && rc.baseline_gf_interval != 2147483647 {
        AF_RATIO_PCT := cast,no_check(s32) (oxcf.gf_cbr_boost_pct + 100);
        target =
            ifx cpi.refresh_golden_frame != 0 then (((cast,no_check(s64) rc.avg_frame_bandwidth) * cast(s64) rc.baseline_gf_interval) * cast(s64) AF_RATIO_PCT) /
                cast(s64) (rc.baseline_gf_interval * 100 + AF_RATIO_PCT - 100) else (((cast,no_check(s64) rc.avg_frame_bandwidth) * cast(s64) rc.baseline_gf_interval) * 100) / cast(s64) (rc.baseline_gf_interval * 100 + AF_RATIO_PCT - 100);
    } else {
        target = cast,no_check(s64) rc.avg_frame_bandwidth;
    }
    if is_one_pass_svc_in_vp9_ratectrl(cpi) != 0 {
        layer := SVC_.spatial_layer_id * SVC_.number_temporal_layers + SVC_.temporal_layer_id;
        lc := SVC_.layer_context.data + layer;
        target = cast,no_check(s64) lc.avg_frame_size;
        min_frame_target = ifx lc.avg_frame_size >> 4 > 200 then lc.avg_frame_size >> 4 else 200;
    }
    if DIFF > 0 {
        PCT_LOW :=
            cast,no_check(s32) ((ifx DIFF / ONE_PCT_BITS < cast,no_check(s64) oxcf.under_shoot_pct then DIFF /
                ONE_PCT_BITS else cast,no_check(s64) oxcf.under_shoot_pct));
        target -= (target * cast(s64) PCT_LOW) / 200;
    } else if DIFF < 0 {
        PCT_HIGH :=
            cast,no_check(s32) ((ifx -DIFF / ONE_PCT_BITS < cast,no_check(s64) oxcf.over_shoot_pct then -DIFF /
                ONE_PCT_BITS else cast,no_check(s64) oxcf.over_shoot_pct));
        target += (target * cast(s64) PCT_HIGH) / 200;
    }
    if oxcf.rc_max_inter_bitrate_pct != 0 {
        MAX_RATE := ((cast,no_check(s64) rc.avg_frame_bandwidth) * cast(s64) oxcf.rc_max_inter_bitrate_pct) / 100;
        target = min(target, MAX_RATE);
    }
    if target > 2147483647 {
        target = 2147483647;
    }
    return ifx min_frame_target > cast,no_check(s32) target then min_frame_target else cast,no_check(s32) target;
}

is_one_pass_svc_in_vp9_ratectrl :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if CPI.use_svc != 0 && CPI.oxcf.pass == 0 {
        return 1;
    }
    return 0;
}

vp9_calc_iframe_target_size_one_pass_vbr :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    rc := *cpi.rc;
    target := rc.avg_frame_bandwidth;
    if target > 2147483647 / KF_RATIO {
        target = 2147483647;
    } else {
        target = rc.avg_frame_bandwidth * KF_RATIO;
    }
    return vp9_rc_clamp_iframe_target_size(cpi, target);
}

vp9_rc_clamp_iframe_target_size :: (CPI: *VP9_COMP_in_vp9_encoder, target: s32) -> s32 {
    rc := *CPI.rc;
    oxcf := *CPI.oxcf;
    if oxcf.rc_max_intra_bitrate_pct != 0 {
        MAX_RATE := ((cast,no_check(s64) rc.avg_frame_bandwidth) * cast(s64) oxcf.rc_max_intra_bitrate_pct) / 100;
        target = cast,no_check(s32) (min(cast,no_check(s64) target, MAX_RATE));
    }
    if target > rc.max_frame_bandwidth {
        target = rc.max_frame_bandwidth;
    }
    return target;
}

vp9_set_gf_update_one_pass_vbr :: (CPI: *VP9_COMP_in_vp9_encoder) {
    RC := *CPI.rc;
    CM := *CPI.common;
    if RC.frames_till_gf_update_due == 0 {
        rate_err: float64 = 1.0;
        RC.gfu_boost = 2000;
        if CPI.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ && CPI.oxcf.pass == 0 {
            vp9_cyclic_refresh_set_golden_update(CPI);
        } else {
            RC.baseline_gf_interval =
                ifx 20 < (ifx 10 > (RC.min_gf_interval + RC.max_gf_interval) / 2 then 10 else (RC.min_gf_interval + RC.max_gf_interval) /
                    2) then 20 else (ifx 10 > (RC.min_gf_interval + RC.max_gf_interval) / 2 then 10 else (RC.min_gf_interval + RC.max_gf_interval) / 2);
        }
        RC.af_ratio_onepass_vbr = 10;
        if RC.rolling_target_bits > 0 {
            rate_err = (cast,no_check(float64) RC.rolling_actual_bits) / cast,no_check(float64) RC.rolling_target_bits;
        }
        if CM.current_video_frame > 30 {
            if RC.avg_frame_qindex[INTER_FRAME] > (7 * RC.worst_quality) >> 3 && c_transpiler_float_greater(rate_err, 3.5) {
                RC.baseline_gf_interval =
                    ifx 15 < (3 * RC.baseline_gf_interval) >> 1 then 15 else (3 *
                        RC.baseline_gf_interval) >> 1;
            } else if RC.avg_frame_low_motion > 0 && RC.avg_frame_low_motion < 20 {
                RC.baseline_gf_interval = ifx 6 > RC.baseline_gf_interval >> 1 then 6 else RC.baseline_gf_interval >> 1;
            }

            if RC.avg_frame_low_motion > 0 {
                RC.gfu_boost =
                    ifx 500 > 2000 * RC.avg_frame_low_motion << 1 / (RC.avg_frame_low_motion + 100) then 500 else 2000 *
                        RC.avg_frame_low_motion << 1 / (RC.avg_frame_low_motion + 100);
            } else if RC.avg_frame_low_motion == 0 && c_transpiler_float_greater(rate_err, 1.0) {
                RC.gfu_boost = (cast(s32) 2000) >> 1;
            }
            RC.af_ratio_onepass_vbr =
                ifx 15 < (ifx 5 > 3 * RC.gfu_boost / 400 then 5 else 3 * RC.gfu_boost /
                    400) then 15 else (ifx 5 > 3 * RC.gfu_boost / 400 then 5 else 3 * RC.gfu_boost / 400);
        }
        if RC.constrain_gf_key_freq_onepass_vbr != 0 {
            adjust_gfint_frame_constraint(CPI, RC.frames_to_key);
        }
        RC.frames_till_gf_update_due = RC.baseline_gf_interval;
        CPI.refresh_golden_frame = 1;
        RC.source_alt_ref_pending = 0;
        RC.alt_ref_gf_group = 0;
        if CPI.sf.use_altref_onepass != 0 && CPI.oxcf.enable_auto_arf != 0 {
            RC.source_alt_ref_pending = 1;
            RC.alt_ref_gf_group = 1;
        }
    }
}

adjust_gfint_frame_constraint :: (cpi: *VP9_COMP_in_vp9_encoder, frame_constraint: s32) {
    RC := *cpi.rc;
    RC.constrained_gf_group = 0;

    if frame_constraint <= (7 * RC.baseline_gf_interval) >> 2 && frame_constraint > RC.baseline_gf_interval {
        RC.baseline_gf_interval = frame_constraint >> 1;
        if RC.baseline_gf_interval < 5 {
            RC.baseline_gf_interval = frame_constraint;
        }
        RC.constrained_gf_group = 1;
    } else if RC.baseline_gf_interval > frame_constraint {
        RC.baseline_gf_interval = frame_constraint;
        RC.constrained_gf_group = 1;
    }
}

vp9_rc_get_one_pass_cbr_params :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    RC := *cpi.rc;

    if CM.current_video_frame == 0 ||
        cpi.frame_flags & cast,no_check(s32) (FRAMEFLAGS_KEY_in_vp9_cx_iface) != 0 ||
        cpi.oxcf.auto_key != 0 && RC.frames_to_key == 0 ||
        cpi.oxcf.mode != cpi.deadline_mode_previous_frame {
        CM.frame_type = cast,no_check(FRAME_TYPE) KEY_FRAME;
        RC.frames_to_key = cpi.oxcf.key_freq;
        RC.kf_boost = 2000;
        RC.source_alt_ref_active = 0;
    } else {
        CM.frame_type = cast,no_check(FRAME_TYPE) INTER_FRAME;
    }
    if RC.frames_till_gf_update_due == 0 {
        if cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ {
            vp9_cyclic_refresh_set_golden_update(cpi);
        } else {
            RC.baseline_gf_interval = (RC.min_gf_interval + RC.max_gf_interval) / 2;
        }
        RC.frames_till_gf_update_due = RC.baseline_gf_interval;

        if RC.frames_till_gf_update_due > RC.frames_to_key {
            RC.frames_till_gf_update_due = RC.frames_to_key;
        }
        cpi.refresh_golden_frame = 1;
        RC.gfu_boost = 2000;
    }

    if cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ {
        vp9_cyclic_refresh_update_parameters(cpi);
    }

    target: s32 = ifx frame_is_intra_only_in_vp9_ratectrl(CM) != 0
        then vp9_calc_iframe_target_size_one_pass_cbr(cpi)
        else vp9_calc_pframe_target_size_one_pass_cbr(cpi);

    vp9_rc_set_frame_target(cpi, target);

    if CM.show_frame != 0 {
        vp9_update_buffer_level_preencode(cpi);
    }

    if cpi.oxcf.resize_mode == cast,no_check(u32) RESIZE_DYNAMIC {
        cpi.resize_pending = vp9_resize_one_pass_cbr(cpi);
    } else {
        cpi.resize_pending = 0;
    }
}

vp9_resize_one_pass_cbr :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    CM := *cpi.common;
    RC := *cpi.rc;
    resize_action := NO_RESIZE;
    avg_qp_thr1: s32 = 70;
    avg_qp_thr2: s32 = 50;

    min_width: s32 = (cast,no_check(s32) ((320 * 4))) / 3;
    min_height: s32 = (cast,no_check(s32) ((180 * 4))) / 3;
    down_size_on: s32 = 1;
    force_downsize_rate: s32 = 0;
    cpi.resize_scale_num = 1;
    cpi.resize_scale_den = 1;

    if CM.frame_type == cast,no_check(u32) KEY_FRAME {
        cpi.resize_avg_qp = 0;
        cpi.resize_count = 0;
        return 0;
    }

    if CM.width * CM.height < min_width * min_height {
        down_size_on = 0;
    }

    if cpi.resize_state == cast,no_check(u32) ORIG && CM.width * CM.height >= 1280 * 720 {
        if RC.avg_frame_bandwidth < 300000 / 30 {
            resize_action = DOWN_ONEHALF;
            cpi.resize_state = cast,no_check(RESIZE_STATE) ONE_HALF;
            force_downsize_rate = 1;
        } else if RC.avg_frame_bandwidth < 400000 / 30 {
            resize_action = cast,no_check(s32) (DOWN_THREEFOUR);
            cpi.resize_state = cast,no_check(RESIZE_STATE) (cast,no_check(s32) (THREE_QUARTER));
            force_downsize_rate = 1;
        }
    } else if cpi.resize_state == cast,no_check(u32) THREE_QUARTER && CM.width * CM.height >= 960 * 540 {
        if RC.avg_frame_bandwidth < 300000 / 30 {
            resize_action = DOWN_ONEHALF;
            cpi.resize_state = cast,no_check(RESIZE_STATE) ONE_HALF;
            force_downsize_rate = 1;
        }
    }

    if force_downsize_rate == 0 && c_transpiler_float_greater(cast,no_check(float64) cpi.rc.frames_since_key, cpi.framerate) {
        WINDOW :=
            (ifx 30 < cast,no_check(s32) c_transpiler_math_round(2.0 *
                cpi.framerate) then 30 else cast,no_check(s32) c_transpiler_math_round(2.0 * cpi.framerate));
        cpi.resize_avg_qp += RC.last_q[INTER_FRAME];
        if cpi.rc.buffer_level < cast,no_check(s64) (cast,no_check(s32) (30 * RC.optimal_buffer_level / 100)) {
            cpi.resize_buffer_underflow += 1;
        }
        cpi.resize_count += 1;

        if cpi.resize_count >= WINDOW {
            avg_qp := cpi.resize_avg_qp / cpi.resize_count;

            if cpi.resize_buffer_underflow > cpi.resize_count >> 2 && down_size_on != 0 {
                if cpi.resize_state == cast,no_check(u32) THREE_QUARTER {
                    resize_action = DOWN_ONEHALF;
                    cpi.resize_state = cast,no_check(RESIZE_STATE) ONE_HALF;
                } else if cpi.resize_state == cast,no_check(u32) ORIG {
                    resize_action = cast,no_check(s32) (DOWN_THREEFOUR);
                    cpi.resize_state = cast,no_check(RESIZE_STATE) (cast,no_check(s32) (THREE_QUARTER));
                }
            } else if cpi.resize_state != cast,no_check(u32) ORIG && avg_qp < avg_qp_thr1 * cpi.rc.worst_quality / 100 {
                if cpi.resize_state == cast,no_check(u32) THREE_QUARTER ||
                    avg_qp < avg_qp_thr2 * cpi.rc.worst_quality / 100 ||
                    ((cast(s32) 0) != 0) {
                    resize_action = UP_ORIG;
                    cpi.resize_state = cast,no_check(RESIZE_STATE) ORIG;
                } else if cpi.resize_state == cast,no_check(u32) ONE_HALF {
                    resize_action = UP_THREEFOUR;
                    cpi.resize_state = cast,no_check(RESIZE_STATE) THREE_QUARTER;
                }
            }

            cpi.resize_avg_qp = 0;
            cpi.resize_count = 0;
            cpi.resize_buffer_underflow = 0;
        }
    }

    if resize_action != NO_RESIZE {
        if resize_action == DOWN_THREEFOUR || resize_action == UP_THREEFOUR {
            cpi.resize_scale_num = 3;
            cpi.resize_scale_den = 4;
        } else if resize_action == DOWN_ONEHALF {
            cpi.resize_scale_num = 1;
            cpi.resize_scale_den = 2;
        } else {
            cpi.resize_scale_num = 1;
            cpi.resize_scale_den = 1;
        }
        tot_scale_change := cpi.resize_scale_den * cpi.resize_scale_den / (cpi.resize_scale_num * cpi.resize_scale_num);

        RC.buffer_level = RC.optimal_buffer_level;
        RC.bits_off_target = RC.optimal_buffer_level;
        RC.this_frame_target = vp9_calc_pframe_target_size_one_pass_cbr(cpi);

        target_bits_per_frame :=
            (ifx resize_action >= 0 then RC.this_frame_target *
                tot_scale_change else RC.this_frame_target / tot_scale_change);
        active_worst_quality := calc_active_worst_quality_one_pass_cbr(cpi);
        qindex := vp9_rc_regulate_q(cpi, target_bits_per_frame, RC.best_quality, active_worst_quality);

        if resize_action > 0 && qindex > 90 * cpi.rc.worst_quality / 100 {
            RC.rate_correction_factors[INTER_NORMAL] *= 0.85;
        }

        if resize_action < 0 && qindex > 130 * CM.base_qindex / 100 {
            RC.rate_correction_factors[INTER_NORMAL] *= 0.9;
        }
    }
    return resize_action;
}

vp9_rc_regulate_q :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    target_bits_per_frame: s32,
    active_best_quality: s32,
    active_worst_quality: s32
) -> s32 {
    CM := *cpi.common;
    CR := cpi.cyclic_refresh;
    q := active_worst_quality;
    last_error: s32 = 2147483647;
    bits_per_mb_at_this_q: s32 = ---;
    CORRECTION_FACTOR := get_rate_correction_factor(cpi);

    target_bits_per_mb :=
        cast,no_check(s32) ((cast,no_check(u64) target_bits_per_frame) << 9 /
            cast,no_check(u64) CM.m_bs);

    i := active_best_quality;

    while true {
        {
            if cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ &&
                CR.apply_cyclic_refresh != 0 &&
                (cpi.oxcf.gf_cbr_boost_pct == 0 || cpi.refresh_golden_frame == 0) {
                bits_per_mb_at_this_q = vp9_cyclic_refresh_rc_bits_per_mb(cpi, i, CORRECTION_FACTOR);
            } else {
                frame_type := (ifx CM.intra_only != 0 then cast,no_check(u32) KEY_FRAME else CM.frame_type);
                bits_per_mb_at_this_q = vp9_rc_bits_per_mb(frame_type, i, CORRECTION_FACTOR, CM.bit_depth);
            }

            diff_bits :=
                cast,no_check(s32) ((ifx (ifx ((cast,no_check(s64) target_bits_per_mb) - cast,no_check(s64) bits_per_mb_at_this_q) > -2147483647 then (cast,no_check(s64) target_bits_per_mb) -
                    cast,no_check(s64) bits_per_mb_at_this_q else -2147483647) < 2147483647 then (ifx ((cast,no_check(s64) target_bits_per_mb) - cast,no_check(s64) bits_per_mb_at_this_q) > -2147483647 then (cast,no_check(s64) target_bits_per_mb) - cast,no_check(s64) bits_per_mb_at_this_q else -2147483647) else 2147483647));
            if bits_per_mb_at_this_q <= target_bits_per_mb {
                if diff_bits <= last_error {
                    q = i;
                } else {
                    q = i - 1;
                }

                break;
            } else {
                last_error = -diff_bits;
            }
        }
        if !(c_transpiler_pre_increment(*(i)) <= active_worst_quality) break;
    }

    if cpi.oxcf.rc_mode == cast,no_check(u32) CBR {
        return adjust_q_cbr(cpi, q);
    }

    return q;
}

adjust_q_cbr :: (cpi: *VP9_COMP_in_vp9_encoder, q: s32) -> s32 {
    if cpi.rc.reset_high_source_sad == 0 &&
        (cpi.oxcf.gf_cbr_boost_pct == 0 || !(cpi.refresh_alt_ref_frame != 0 || cpi.refresh_golden_frame != 0)) &&
        cpi.rc.rc_1_frame * cpi.rc.rc_2_frame == -1 &&
        cpi.rc.q_1_frame != cpi.rc.q_2_frame {
        qclamp :=
            clamp_in_vp9_ratectrl(
                q,
                (ifx cpi.rc.q_1_frame < cpi.rc.q_2_frame then cpi.rc.q_1_frame else cpi.rc.q_2_frame),
                (ifx cpi.rc.q_1_frame > cpi.rc.q_2_frame then cpi.rc.q_1_frame else cpi.rc.q_2_frame)
            );

        if cpi.rc.rc_1_frame == -1 && q > qclamp {
            q = (q + qclamp) >> 1;
        } else {
            q = qclamp;
        }
    }
    if cpi.oxcf.content == cast,no_check(u32) VP9E_CONTENT_SCREEN && cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ {
        vp9_cyclic_refresh_limit_q(cpi, *q);
    }
    return ifx (ifx q < cpi.rc.worst_quality then q else cpi.rc.worst_quality) > cpi.rc.best_quality then (ifx q < cpi.rc.worst_quality then q else cpi.rc.worst_quality) else cpi.rc.best_quality;
}

get_rate_correction_factor :: (cpi: *VP9_COMP_in_vp9_encoder) -> float64 {
    RC := *cpi.rc;
    CM := *cpi.common;
    rcf: float64 = ---;

    if frame_is_intra_only_in_vp9_ratectrl(CM) != 0 {
        rcf = RC.rate_correction_factors[KF_STD];
    } else if cpi.oxcf.pass == 2 {
        rf_lvl := cpi.twopass.gf_group.rf_level[cpi.twopass.gf_group.index];
        rcf = RC.rate_correction_factors[rf_lvl];
    } else if (cpi.refresh_alt_ref_frame != 0 || cpi.refresh_golden_frame != 0) &&
        RC.is_src_frame_alt_ref == 0 &&
        cpi.use_svc == 0 &&
        (cpi.oxcf.rc_mode != cast,no_check(u32) CBR || cpi.oxcf.gf_cbr_boost_pct > 100) {
        rcf = RC.rate_correction_factors[GF_ARF_STD];
    } else {
        rcf = RC.rate_correction_factors[INTER_NORMAL];
    }
    rcf *= RCF_MULT_in_vp9_ratectrl[RC.frame_size_selector];
    return fclamp_in_vp9_ratectrl(rcf, 0.005, 50.0);
}

calc_active_worst_quality_one_pass_cbr :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    CM := *cpi.common;
    rc := *cpi.rc;

    critical_level := rc.optimal_buffer_level >> 3;
    buff_lvl_step: s64 = 0;
    adjustment: s32 = 0;

    num_frames_weight_key := cast,no_check(u32) (5 * cpi.svc.number_temporal_layers);
    if frame_is_intra_only_in_vp9_ratectrl(CM) != 0 || rc.reset_high_source_sad != 0 || rc.force_max_q != 0 {
        return rc.worst_quality;
    }

    ambient_qp :=
        (ifx CM.current_video_frame < num_frames_weight_key then (ifx rc.avg_frame_qindex[INTER_FRAME] < rc.avg_frame_qindex[KEY_FRAME] then rc.avg_frame_qindex[INTER_FRAME] else rc.avg_frame_qindex[KEY_FRAME]) else rc.avg_frame_qindex[INTER_FRAME]);
    active_worst_quality :=
        (ifx rc.worst_quality < (ambient_qp *
            5) >> 2 then rc.worst_quality else (ambient_qp * 5) >> 2);

    if cpi.use_svc != 0 && cpi.svc.spatial_layer_id > 0 {
        layer := 0 * cpi.svc.number_temporal_layers + cpi.svc.temporal_layer_id;
        lc := cpi.svc.layer_context.data + layer;
        if lc.is_key_frame != 0 {
            lrc := *lc.rc;
            ambient_qp = ifx ambient_qp < lrc.last_q[KEY_FRAME] then ambient_qp else lrc.last_q[KEY_FRAME];
            active_worst_quality =
                ifx rc.worst_quality < (ambient_qp *
                    9) >> 3 then rc.worst_quality else (ambient_qp * 9) >> 3;
        }
    }
    if rc.buffer_level > rc.optimal_buffer_level {
        max_adjustment_down := active_worst_quality / 3;
        if cpi.oxcf.content == cast,no_check(u32) VP9E_CONTENT_SCREEN {
            max_adjustment_down = active_worst_quality >> 3;
        }
        if max_adjustment_down != 0 {
            buff_lvl_step = (rc.maximum_buffer_size - rc.optimal_buffer_level) / cast(s64) max_adjustment_down;
            if buff_lvl_step != 0 {
                adjustment = cast,no_check(s32) ((rc.buffer_level - rc.optimal_buffer_level) / buff_lvl_step);
            }
            active_worst_quality -= adjustment;
        }
    } else if rc.buffer_level > critical_level {
        if critical_level != 0 {
            buff_lvl_step = rc.optimal_buffer_level - critical_level;
            if buff_lvl_step != 0 {
                adjustment =
                    cast,no_check(s32) ((cast(s64) (rc.worst_quality - ambient_qp)) *
                        (rc.optimal_buffer_level - rc.buffer_level) / buff_lvl_step);
            }
            active_worst_quality = ambient_qp + adjustment;
        }
    } else {
        active_worst_quality = rc.worst_quality;
    }
    return active_worst_quality;
}

vp9_calc_iframe_target_size_one_pass_cbr :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    rc := *cpi.rc;
    oxcf := *cpi.oxcf;
    SVC_ := *cpi.svc;
    target: s64 = ---;
    if cpi.common.current_video_frame == 0 {
        target = rc.starting_buffer_level / 2;
    } else {
        kf_boost: s32 = 32;
        framerate := cpi.framerate;
        if SVC_.number_temporal_layers > 1 && oxcf.rc_mode == cast,no_check(u32) CBR {
            LAYER := SVC_.spatial_layer_id * SVC_.number_temporal_layers + SVC_.temporal_layer_id;
            lc := SVC_.layer_context.data + LAYER;
            framerate = lc.framerate;
        }
        kf_boost =
            ifx kf_boost > cast,no_check(s32) c_transpiler_math_round(2.0 * framerate -
                16.0) then kf_boost else cast,no_check(s32) c_transpiler_math_round(2.0 * framerate - 16.0);
        if c_transpiler_float_less(cast,no_check(float64) rc.frames_since_key, (framerate / 2.0)) {
            kf_boost =
                cast,no_check(s32) c_transpiler_math_round(
                    (kf_boost * rc.frames_since_key) / (framerate / 2.0)
                );
        }

        target = ((cast,no_check(s64) (16 + kf_boost)) * cast(s64) rc.avg_frame_bandwidth) >> 4;
    }
    target = ifx 2147483647 < target then 2147483647 else target;
    return vp9_rc_clamp_iframe_target_size(cpi, cast,no_check(s32) target);
}

vp9_rc_get_svc_params :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    RC := *cpi.rc;
    SVC_ := *cpi.svc;
    target := RC.avg_frame_bandwidth;
    layer := SVC_.spatial_layer_id * SVC_.number_temporal_layers + SVC_.temporal_layer_id;
    if SVC_.first_spatial_layer_to_encode != 0 {
        SVC_.layer_context[SVC_.temporal_layer_id].is_key_frame = 0;
    }

    if CM.current_video_frame == 0 && SVC_.previous_frame_is_intra_only == 0 ||
        cpi.frame_flags & cast,no_check(s32) (FRAMEFLAGS_KEY_in_vp9_cx_iface) != 0 ||
        cpi.oxcf.auto_key != 0 &&
            SVC_.current_superframe % cpi.oxcf.key_freq == 0 &&
            SVC_.previous_frame_is_intra_only == 0 &&
            SVC_.spatial_layer_id == 0 ||
        SVC_.spatial_layer_sync[0] == 1 && SVC_.spatial_layer_id == 0 ||
        cpi.oxcf.mode != cpi.deadline_mode_previous_frame {
        CM.frame_type = cast,no_check(FRAME_TYPE) KEY_FRAME;
        RC.source_alt_ref_active = 0;
        if is_one_pass_svc_in_vp9_ratectrl(cpi) != 0 {
            if CM.current_video_frame > 0 {
                vp9_svc_reset_temporal_layers(cpi, 1);
            }
            layer = SVC_.spatial_layer_id * SVC_.number_temporal_layers + SVC_.temporal_layer_id;
            SVC_.layer_context[layer].is_key_frame = 1;
            cpi.ref_frame_flags &=
                ((cast,no_check(s32) (~(VP9_LAST_FLAG))) & cast,no_check(s32) (~(VP9_GOLD_FLAG))) & cast,no_check(s32) (~(VP9_ALT_FLAG));

            if cpi.oxcf.rc_mode == cast,no_check(u32) CBR {
                target = vp9_calc_iframe_target_size_one_pass_cbr(cpi);
            } else {
                target = vp9_calc_iframe_target_size_one_pass_vbr(cpi);
            }
        }
    } else {
        CM.frame_type = cast,no_check(FRAME_TYPE) INTER_FRAME;
        if is_one_pass_svc_in_vp9_ratectrl(cpi) != 0 {
            lc := SVC_.layer_context.data + layer;

            lc.is_key_frame =
                ifx SVC_.spatial_layer_id == 0 &&
                    CM.current_video_frame > 0 then 0 else SVC_.layer_context[SVC_.temporal_layer_id].is_key_frame;
            if cpi.oxcf.rc_mode == cast,no_check(u32) CBR {
                target = vp9_calc_pframe_target_size_one_pass_cbr(cpi);
            } else {
                rate_err: float64 = 0.0;
                RC.fac_active_worst_inter = 140;
                RC.fac_active_worst_gf = 100;
                if RC.rolling_target_bits > 0 {
                    rate_err =
                        (cast,no_check(float64) RC.rolling_actual_bits) /
                            cast,no_check(float64) RC.rolling_target_bits;
                    if c_transpiler_float_less(rate_err, 1.0) {
                        RC.fac_active_worst_inter = 120;
                    } else if c_transpiler_float_greater(rate_err, 2.0) {
                        RC.fac_active_worst_inter = 160;
                    }
                }
                target = vp9_calc_pframe_target_size_one_pass_vbr(cpi);
            }
        }
    }

    if SVC_.simulcast_mode != 0 {
        if SVC_.spatial_layer_id > 0 && SVC_.layer_context[layer].is_key_frame == 1 {
            CM.frame_type = cast,no_check(FRAME_TYPE) KEY_FRAME;
            cpi.ref_frame_flags &=
                ((cast,no_check(s32) (~(VP9_LAST_FLAG))) & cast,no_check(s32) (~(VP9_GOLD_FLAG))) & cast,no_check(s32) (~(VP9_ALT_FLAG));
            if cpi.oxcf.rc_mode == cast,no_check(u32) CBR {
                target = vp9_calc_iframe_target_size_one_pass_cbr(cpi);
            } else {
                target = vp9_calc_iframe_target_size_one_pass_vbr(cpi);
            }
        }

        if CM.frame_type == cast,no_check(u32) KEY_FRAME {
            if SVC_.number_spatial_layers == 2 {
                if SVC_.spatial_layer_id == 0 {
                    cpi.lst_fb_idx = 0;
                    cpi.gld_fb_idx = 2;
                    cpi.alt_fb_idx = 6;
                } else if SVC_.spatial_layer_id == 1 {
                    cpi.lst_fb_idx = 1;
                    cpi.gld_fb_idx = 3;
                    cpi.alt_fb_idx = 6;
                }
            } else if SVC_.number_spatial_layers == 3 {
                if SVC_.spatial_layer_id == 0 {
                    cpi.lst_fb_idx = 0;
                    cpi.gld_fb_idx = 3;
                    cpi.alt_fb_idx = 6;
                } else if SVC_.spatial_layer_id == 1 {
                    cpi.lst_fb_idx = 1;
                    cpi.gld_fb_idx = 4;
                    cpi.alt_fb_idx = 6;
                } else if SVC_.spatial_layer_id == 2 {
                    cpi.lst_fb_idx = 2;
                    cpi.gld_fb_idx = 5;
                    cpi.alt_fb_idx = 7;
                }
            }
            cpi.ext_refresh_last_frame = 1;
            cpi.ext_refresh_golden_frame = 1;
            cpi.ext_refresh_alt_ref_frame = 1;
        }
    }

    vp9_svc_check_spatial_layer_sync(cpi);

    if SVC_.use_gf_temporal_ref_current_layer != 0 {
        if SVC_.layer_context[SVC_.temporal_layer_id].is_key_frame == 0 {
            index := SVC_.spatial_layer_id;
            if SVC_.number_spatial_layers == 3 {
                index = SVC_.spatial_layer_id - 1;
            }

            cpi.gld_fb_idx = SVC_.buffer_gf_temporal_ref[index].idx;

            cpi.ref_frame_flags = (cast,no_check(s32) (VP9_LAST_FLAG)) | cast,no_check(s32) (VP9_GOLD_FLAG);
        }

        if SVC_.temporal_layer_id == 0 {
            if SVC_.layer_context[SVC_.temporal_layer_id].is_key_frame != 0 {
                index := SVC_.spatial_layer_id;
                if SVC_.number_spatial_layers == 3 {
                    index = SVC_.spatial_layer_id - 1;
                }

                cpi.alt_fb_idx = SVC_.buffer_gf_temporal_ref[index].idx;
                cpi.ext_refresh_alt_ref_frame = 1;
            } else if RC.frames_till_gf_update_due == 0 {
                RC.baseline_gf_interval = 20;
                RC.frames_till_gf_update_due = RC.baseline_gf_interval;
                cpi.ext_refresh_golden_frame = 1;
                RC.gfu_boost = 2000;
            }
        }
    } else if SVC_.use_gf_temporal_ref == 0 {
        RC.frames_till_gf_update_due = 2147483647;
        RC.baseline_gf_interval = 2147483647;
    }
    if SVC_.set_intra_only_frame != 0 {
        set_intra_only_frame(cpi);
        if cpi.oxcf.rc_mode == cast,no_check(u32) CBR {
            target = vp9_calc_iframe_target_size_one_pass_cbr(cpi);
        } else {
            target = vp9_calc_iframe_target_size_one_pass_vbr(cpi);
        }
    }

    if SVC_.previous_frame_is_intra_only != 0 {
        cpi.ref_frame_flags |= cast,no_check(s32) (VP9_LAST_FLAG);
    }

    if cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ {
        vp9_cyclic_refresh_update_parameters(cpi);
    }

    vp9_rc_set_frame_target(cpi, target);
    if CM.show_frame != 0 {
        vp9_update_buffer_level_svc_preencode(cpi);
    }

    if cpi.oxcf.resize_mode == cast,no_check(u32) RESIZE_DYNAMIC &&
        SVC_.single_layer_svc == 1 &&
        SVC_.spatial_layer_id == SVC_.first_spatial_layer_to_encode &&
        SVC_.temporal_layer_id == 0 {
        lc: *LAYER_CONTEXT_in_vp9_cx_iface = null;
        cpi.resize_pending = vp9_resize_one_pass_cbr(cpi);
        if cpi.resize_pending != 0 {
            width: s32 = ---;
            height: s32 = ---;

            tl: s32 = 0;
            while tl < SVC_.number_temporal_layers {
                lc = SVC_.layer_context.data + SVC_.spatial_layer_id * SVC_.number_temporal_layers + tl;
                lc.scaling_factor_num_resize = cpi.resize_scale_num * lc.scaling_factor_num;
                lc.scaling_factor_den_resize = cpi.resize_scale_den * lc.scaling_factor_den;

                lc.rc.buffer_level = lc.rc.optimal_buffer_level;
                lc.rc.bits_off_target = lc.rc.optimal_buffer_level;
                lc.rc.rate_correction_factors[INTER_FRAME] = RC.rate_correction_factors[INTER_FRAME];
                tl += 1;
            }

            lc = SVC_.layer_context.data + SVC_.spatial_layer_id * SVC_.number_temporal_layers + SVC_.temporal_layer_id;
            get_layer_resolution(
                cpi.oxcf.width,
                cpi.oxcf.height,
                lc.scaling_factor_num_resize,
                lc.scaling_factor_den_resize,
                *width,
                *height
            );
            vp9_set_size_literal(cpi, cast,no_check(u32) width, cast,no_check(u32) height);
            SVC_.resize_set = 1;
        }
    } else {
        cpi.resize_pending = 0;
        SVC_.resize_set = 0;
    }
}

vp9_update_buffer_level_svc_preencode :: (cpi: *VP9_COMP_in_vp9_encoder) {
    SVC_ := *cpi.svc;

    use_timestamp: s32 = 1;
    TS_DELTA := SVC_.time_stamp_superframe - SVC_.time_stamp_prev[SVC_.spatial_layer_id];
    i := SVC_.temporal_layer_id;
    while i < SVC_.number_temporal_layers {
        LAYER := SVC_.spatial_layer_id * SVC_.number_temporal_layers + i;
        LC := SVC_.layer_context.data + LAYER;
        LRC := *LC.rc;
        if use_timestamp != 0 &&
            cpi.svc.use_set_ref_frame_config != 0 &&
            SVC_.number_temporal_layers == 1 &&
            TS_DELTA > 0 &&
            SVC_.current_superframe > 0 {
            FRAMERATE_PTS := 10000000.0 / cast,no_check(float64) TS_DELTA;
            LRC.bits_off_target +=
                cast,no_check(s64) saturate_cast_double_to_int_in_vp9_ratectrl(
                    c_transpiler_math_round(LC.target_bandwidth / FRAMERATE_PTS)
                );
        } else {
            LRC.bits_off_target +=
                cast,no_check(s64) saturate_cast_double_to_int_in_vp9_ratectrl(
                    c_transpiler_math_round(LC.target_bandwidth / LC.framerate)
                );
        }

        LRC.bits_off_target =
            ifx LRC.bits_off_target < LRC.maximum_buffer_size then LRC.bits_off_target else LRC.maximum_buffer_size;
        LRC.buffer_level = LRC.bits_off_target;
        if i == SVC_.temporal_layer_id {
            cpi.rc.bits_off_target = LRC.bits_off_target;
            cpi.rc.buffer_level = LRC.buffer_level;
        }
        i += 1;
    }
}

set_intra_only_frame :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    SVC_ := *cpi.svc;

    if CM.current_video_frame == 0 && SVC_.number_temporal_layers > 1 ||
        SVC_.number_spatial_layers > 3 ||
        SVC_.number_temporal_layers > 3 ||
        SVC_.number_spatial_layers == 1 {
        return;
    }
    CM.show_frame = 0;
    CM.intra_only = 1;
    CM.frame_type = cast,no_check(FRAME_TYPE) INTER_FRAME;
    cpi.ext_refresh_frame_flags_pending = 1;
    cpi.ext_refresh_last_frame = 1;
    cpi.ext_refresh_golden_frame = 1;
    cpi.ext_refresh_alt_ref_frame = 1;
    if CM.current_video_frame == 0 {
        cpi.lst_fb_idx = 0;
        cpi.gld_fb_idx = 1;
        cpi.alt_fb_idx = 2;
    } else {
        count: s32 = 0;
        cpi.lst_fb_idx = -1;
        cpi.gld_fb_idx = -1;
        cpi.alt_fb_idx = -1;
        SVC_.update_buffer_slot[0] = 0;

        for i: 0..cast(s32) ((cast(s32) 1) << 3) - 1 {
            if SVC_.fb_idx_base[i] == 1 {
                SVC_.update_buffer_slot[0] |= (cast(s32) 1) << ((i) & 31);
                count += 1;
            }
            if count == 1 && cpi.lst_fb_idx == -1 {
                cpi.lst_fb_idx = i;
            }
            if count == 2 && cpi.gld_fb_idx == -1 {
                cpi.gld_fb_idx = i;
            }
            if count == 3 && cpi.alt_fb_idx == -1 {
                cpi.alt_fb_idx = i;
            }
        }

        if cpi.gld_fb_idx == -1 {
            cpi.gld_fb_idx = cpi.lst_fb_idx;
        }
        if cpi.alt_fb_idx == -1 {
            cpi.alt_fb_idx = cpi.lst_fb_idx;
        }
        if SVC_.temporal_layering_mode == cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_BYPASS {
            cpi.ext_refresh_last_frame = 0;
            cpi.ext_refresh_golden_frame = 0;
            cpi.ext_refresh_alt_ref_frame = 0;
            cpi.ref_frame_flags = 0;
        }
    }
}

vp9_rc_postencode_update :: (cpi: *VP9_COMP_in_vp9_encoder, bytes_used: u64) {
    CM := *cpi.common;
    OXCF := *cpi.oxcf;
    RC := *cpi.rc;
    SVC_ := *cpi.svc;
    QINDEX := CM.base_qindex;
    gf_group := *cpi.twopass.gf_group;
    GF_GROUP_INDEX := cast,no_check(s32) cpi.twopass.gf_group.index;
    LAYER_DEPTH := cast,no_check(s32) gf_group.layer_depth[GF_GROUP_INDEX];

    RC.projected_frame_size = cast,no_check(s32) (bytes_used << 3);

    vp9_rc_update_rate_correction_factors(cpi);

    if frame_is_intra_only_in_vp9_ratectrl(CM) != 0 {
        RC.last_q[KEY_FRAME] = QINDEX;
        RC.avg_frame_qindex[KEY_FRAME] =
            (3 * RC.avg_frame_qindex[KEY_FRAME] + QINDEX +
                (cast(s32) 1) << (((2 - 1)) & 31)) >> 2;
        if cpi.use_svc != 0 {
            i: s32 = 0;
            while i < SVC_.number_temporal_layers {
                LAYER := SVC_.spatial_layer_id * SVC_.number_temporal_layers + i;
                lc := SVC_.layer_context.data + LAYER;
                lrc := *lc.rc;
                lrc.last_q[KEY_FRAME] = RC.last_q[KEY_FRAME];
                lrc.avg_frame_qindex[KEY_FRAME] = RC.avg_frame_qindex[KEY_FRAME];
                i += 1;
            }
        }
    } else if cpi.use_svc != 0 || RC.is_src_frame_alt_ref == 0 && !(cpi.refresh_golden_frame != 0 || cpi.refresh_alt_ref_frame != 0) {
        RC.last_q[INTER_FRAME] = QINDEX;
        RC.avg_frame_qindex[INTER_FRAME] =
            (3 * RC.avg_frame_qindex[INTER_FRAME] + QINDEX +
                (cast(s32) 1) << (((2 - 1)) & 31)) >> 2;
        RC.ni_frames += 1;
        RC.tot_q += vp9_convert_qindex_to_q(QINDEX, CM.bit_depth);
        RC.avg_q = RC.tot_q / RC.ni_frames;

        RC.ni_tot_qi += QINDEX;
        RC.ni_av_qi = RC.ni_tot_qi / RC.ni_frames;
    }

    if cpi.use_svc != 0 {
        vp9_svc_adjust_avg_frame_qindex(cpi);
    }

    if QINDEX < RC.last_boosted_qindex ||
        CM.frame_type == cast,no_check(u32) KEY_FRAME ||
        RC.constrained_gf_group == 0 &&
            (cpi.refresh_alt_ref_frame != 0 || cpi.refresh_golden_frame != 0 && RC.is_src_frame_alt_ref == 0) {
        RC.last_boosted_qindex = QINDEX;
    }

    if QINDEX < cpi.twopass.last_qindex_of_arf_layer[LAYER_DEPTH] ||
        CM.frame_type == cast,no_check(u32) KEY_FRAME ||
        RC.constrained_gf_group == 0 &&
            (cpi.refresh_alt_ref_frame != 0 || cpi.refresh_golden_frame != 0 && RC.is_src_frame_alt_ref == 0) {
        cpi.twopass.last_qindex_of_arf_layer[LAYER_DEPTH] = QINDEX;
    }

    if frame_is_intra_only_in_vp9_ratectrl(CM) != 0 {
        RC.last_kf_qindex = QINDEX;
    }

    update_buffer_level_postencode(cpi, RC.projected_frame_size);

    if frame_is_intra_only_in_vp9_ratectrl(CM) == 0 {
        RC.rolling_target_bits =
            cast,no_check(s32) (((cast,no_check(u64) (((cast,no_check(s64) RC.rolling_target_bits) * 3) + cast(s64) RC.this_frame_target)) +
                (cast(u64) 1) << (((2 - 1)) & 63)) >> 2);
        RC.rolling_actual_bits =
            cast,no_check(s32) (((cast,no_check(u64) (((cast,no_check(s64) RC.rolling_actual_bits) * 3) + cast(s64) RC.projected_frame_size)) +
                (cast(u64) 1) << (((2 - 1)) & 63)) >> 2);
        RC.long_rolling_target_bits =
            cast,no_check(s32) (((cast,no_check(u64) (((cast,no_check(s64) RC.long_rolling_target_bits) * 31) + cast(s64) RC.this_frame_target)) +
                (cast(u64) 1) << (((5 - 1)) & 63)) >> 5);
        RC.long_rolling_actual_bits =
            cast,no_check(s32) (((cast,no_check(u64) (((cast,no_check(s64) RC.long_rolling_actual_bits) * 31) + cast(s64) RC.projected_frame_size)) +
                (cast(u64) 1) << (((5 - 1)) & 63)) >> 5);
    }

    RC.total_actual_bits += cast,no_check(s64) RC.projected_frame_size;
    RC.total_target_bits += cast,no_check(s64) ((ifx CM.show_frame != 0 then RC.avg_frame_bandwidth else 0));

    RC.total_target_vs_actual = RC.total_actual_bits - RC.total_target_bits;

    if cpi.use_svc == 0 {
        if is_altref_enabled_in_vp9_ratectrl(cpi) != 0 &&
            cpi.refresh_alt_ref_frame != 0 &&
            frame_is_intra_only_in_vp9_ratectrl(CM) == 0 {
            update_alt_ref_frame_stats_in_vp9_ratectrl(cpi);
        } else {
            update_golden_frame_stats_in_vp9_ratectrl(cpi);
        }
    }

    if cpi.use_svc != 0 && SVC_.use_gf_temporal_ref_current_layer != 0 && SVC_.temporal_layer_id == 0 {
        i: s32 = 0;
        if cpi.refresh_golden_frame != 0 {
            RC.frames_since_golden = 0;
        } else {
            RC.frames_since_golden += 1;
        }

        if RC.frames_till_gf_update_due > 0 {
            RC.frames_till_gf_update_due -= 1;
        }

        i = 1;
        while i < SVC_.number_temporal_layers {
            LAYER := SVC_.spatial_layer_id * SVC_.number_temporal_layers + i;
            LC := SVC_.layer_context.data + LAYER;
            LRC := *LC.rc;
            LRC.frames_since_golden = RC.frames_since_golden;
            i += 1;
        }
    }

    if frame_is_intra_only_in_vp9_ratectrl(CM) != 0 {
        RC.frames_since_key = 0;
    }
    if CM.show_frame != 0 {
        RC.frames_since_key += 1;
        RC.frames_to_key -= 1;
    }

    if OXCF.pass != 0 {
        cpi.resize_pending = cast(s32) (RC.next_frame_size_selector != RC.frame_size_selector);
        RC.frame_size_selector = RC.next_frame_size_selector;
    }

    if OXCF.pass == 0 {
        if frame_is_intra_only_in_vp9_ratectrl(CM) == 0 {
            if cpi.sf.use_altref_onepass != 0 {
                update_altref_usage(cpi);
            }
        }
        cpi.rc.last_frame_is_src_altref = cpi.rc.is_src_frame_alt_ref;
    }

    if frame_is_intra_only_in_vp9_ratectrl(CM) == 0 {
        RC.reset_high_source_sad = 0;
    }

    RC.last_avg_frame_bandwidth = RC.avg_frame_bandwidth;
    if cpi.use_svc != 0 && SVC_.spatial_layer_id < SVC_.number_spatial_layers - 1 {
        SVC_.lower_layer_qindex = CM.base_qindex;
    }
    cpi.deadline_mode_previous_frame = cpi.oxcf.mode;
}

update_altref_usage :: (CPI: *VP9_COMP_in_vp9_encoder) {
    CM := *CPI.common;
    sum_ref_frame_usage: s32 = 0;
    arf_frame_usage: s32 = 0;
    mi_row, mi_col: s32 = ---;
    if CPI.rc.alt_ref_gf_group != 0 &&
        CPI.rc.is_src_frame_alt_ref == 0 &&
        CPI.refresh_golden_frame == 0 &&
        CPI.refresh_alt_ref_frame == 0 &&
        CPI.count_arf_frame_usage != null &&
        CPI.count_lastgolden_frame_usage != null {
        mi_row = 0;
        while mi_row < CM.mi_rows {
            mi_col = 0;
            while mi_col < CM.mi_cols {
                sboffset := (CM.mi_cols + 7) >> 3 * mi_row >> 3 + mi_col >> 3;
                sum_ref_frame_usage +=
                    (cast(s32) CPI.count_arf_frame_usage[sboffset]) +
                        cast(s32) CPI.count_lastgolden_frame_usage[sboffset];
                arf_frame_usage += cast,no_check(s32) CPI.count_arf_frame_usage[sboffset];
                mi_col += 8;
            }
            mi_row += 8;
        }
    }
    if sum_ref_frame_usage > 0 {
        altref_count := (100.0 * cast,no_check(float64) arf_frame_usage) / sum_ref_frame_usage;
        CPI.rc.perc_arf_usage = 0.75 * CPI.rc.perc_arf_usage + 0.25 * altref_count;
    }
}

update_golden_frame_stats_in_vp9_ratectrl :: (cpi: *VP9_COMP_in_vp9_encoder) {
    RC := *cpi.rc;

    if cpi.refresh_golden_frame != 0 {
        RC.frames_since_golden = 0;

        if cpi.oxcf.pass == 2 {
            if RC.source_alt_ref_pending == 0 && cpi.twopass.gf_group.index == 0 {
                RC.source_alt_ref_active = 0;
            }
        } else if RC.source_alt_ref_pending == 0 {
            RC.source_alt_ref_active = 0;
        }

        if RC.frames_till_gf_update_due > 0 {
            RC.frames_till_gf_update_due -= 1;
        }
    } else if cpi.refresh_alt_ref_frame == 0 {
        if RC.frames_till_gf_update_due > 0 {
            RC.frames_till_gf_update_due -= 1;
        }

        RC.frames_since_golden += 1;

        if RC.show_arf_as_gld != 0 {
            RC.frames_since_golden = 0;

            if RC.source_alt_ref_pending == 0 && cpi.twopass.gf_group.index == 0 {
                RC.source_alt_ref_active = 0;
            }
        }
    }
}

update_alt_ref_frame_stats_in_vp9_ratectrl :: (cpi: *VP9_COMP_in_vp9_encoder) {
    RC := *cpi.rc;
    RC.frames_since_golden = 0;

    RC.source_alt_ref_pending = 0;

    RC.source_alt_ref_active = 1;
}

is_altref_enabled_in_vp9_ratectrl :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if !(CPI.oxcf.mode == cast,no_check(u32) REALTIME && CPI.oxcf.rc_mode == cast,no_check(u32) CBR) &&
        CPI.oxcf.lag_in_frames >= 4 &&
        CPI.oxcf.enable_auto_arf != 0 {
        return 1;
    }
    return 0;
}

update_buffer_level_postencode :: (cpi: *VP9_COMP_in_vp9_encoder, encoded_frame_size: s32) {
    RC := *cpi.rc;
    RC.bits_off_target -= cast,no_check(s64) encoded_frame_size;

    RC.bits_off_target =
        ifx RC.bits_off_target < RC.maximum_buffer_size then RC.bits_off_target else RC.maximum_buffer_size;

    if cpi.oxcf.content == cast,no_check(u32) VP9E_CONTENT_SCREEN && cpi.oxcf.drop_frames_water_mark == 0 {
        RC.bits_off_target =
            ifx RC.bits_off_target > -RC.maximum_buffer_size then RC.bits_off_target else -RC.maximum_buffer_size;
    }

    RC.buffer_level = RC.bits_off_target;

    if is_one_pass_svc_in_vp9_ratectrl(cpi) != 0 {
        update_layer_buffer_level_postencode(*cpi.svc, encoded_frame_size);
    }
}

update_layer_buffer_level_postencode :: (svc: *SVC, encoded_frame_size: s32) {
    i: s32 = 0;
    CURRENT_TEMPORAL_LAYER := svc.temporal_layer_id;
    i = CURRENT_TEMPORAL_LAYER + 1;
    while i < svc.number_temporal_layers {
        LAYER := svc.spatial_layer_id * svc.number_temporal_layers + i;
        lc := svc.layer_context.data + LAYER;
        lrc := *lc.rc;
        lrc.bits_off_target -= cast,no_check(s64) encoded_frame_size;

        lrc.bits_off_target =
            ifx lrc.bits_off_target < lrc.maximum_buffer_size then lrc.bits_off_target else lrc.maximum_buffer_size;
        lrc.buffer_level = lrc.bits_off_target;
        i += 1;
    }
}

vp9_rc_update_rate_correction_factors :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    correction_factor: s32 = 100;
    rate_correction_factor := get_rate_correction_factor(cpi);
    adjustment_limit: float64 = ---;
    rf_lvl := cpi.twopass.gf_group.rf_level[cpi.twopass.gf_group.index];

    projected_size_based_on_q: s32 = 0;

    if cpi.rc.is_src_frame_alt_ref != 0 {
        return;
    }

    if cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ && cpi.common.seg.enabled != 0 {
        projected_size_based_on_q = vp9_cyclic_refresh_estimate_bits_at_q(cpi, rate_correction_factor);
    } else {
        frame_type := (ifx CM.intra_only != 0 then cast,no_check(u32) KEY_FRAME else CM.frame_type);
        projected_size_based_on_q =
            vp9_estimate_bits_at_q(
                frame_type,
                CM.base_qindex,
                CM.m_bs,
                rate_correction_factor,
                CM.bit_depth
            );
    }

    if projected_size_based_on_q > 200 {
        correction_factor =
            cast,no_check(s32) ((100 * cast,no_check(s64) cpi.rc.projected_frame_size) /
                cast(s64) projected_size_based_on_q);
    }

    if cpi.rc.damped_adjustment[rf_lvl] == 0 {
        adjustment_limit = 1.0;
        cpi.rc.damped_adjustment[rf_lvl] = 1;
    } else {
        adjustment_limit =
            0.25 + 0.5 * (ifx c_transpiler_float_less(1.0, c_transpiler_math_fabs(
                c_transpiler_math_log10(0.01 * cast,no_check(float64) correction_factor)
            )) then 1.0 else c_transpiler_math_fabs(
                c_transpiler_math_log10(0.01 * cast,no_check(float64) correction_factor)
            ));
    }

    cpi.rc.q_2_frame = cpi.rc.q_1_frame;
    cpi.rc.q_1_frame = CM.base_qindex;
    cpi.rc.rc_2_frame = cpi.rc.rc_1_frame;
    if correction_factor > 110 {
        cpi.rc.rc_1_frame = -1;
    } else if correction_factor < 90 {
        cpi.rc.rc_1_frame = 1;
    } else {
        cpi.rc.rc_1_frame = 0;
    }

    if cpi.rc.rc_1_frame == -1 && cpi.rc.rc_2_frame == 1 && correction_factor > 1000 {
        cpi.rc.rc_2_frame = 0;
    }

    if correction_factor > 102 {
        correction_factor = cast,no_check(s32) (100.0 + (correction_factor - 100) * adjustment_limit);
        rate_correction_factor = rate_correction_factor * correction_factor / 100.0;

        if c_transpiler_float_greater(rate_correction_factor, 50.0) {
            rate_correction_factor = 50.0;
        }
    } else if correction_factor < 99 {
        correction_factor = cast,no_check(s32) (100.0 - (100 - correction_factor) * adjustment_limit);
        rate_correction_factor = rate_correction_factor * correction_factor / 100.0;

        if c_transpiler_float_less(rate_correction_factor, 0.005) {
            rate_correction_factor = 0.005;
        }
    }

    set_rate_correction_factor(cpi, rate_correction_factor);
}

set_rate_correction_factor :: (cpi: *VP9_COMP_in_vp9_encoder, factor: float64) {
    RC := *cpi.rc;
    CM := *cpi.common;

    factor /= RCF_MULT_in_vp9_ratectrl[cpi.rc.frame_size_selector];

    factor = fclamp_in_vp9_ratectrl(factor, 0.005, 50.0);

    if frame_is_intra_only_in_vp9_ratectrl(CM) != 0 {
        RC.rate_correction_factors[KF_STD] = factor;
    } else if cpi.oxcf.pass == 2 {
        rf_lvl := cpi.twopass.gf_group.rf_level[cpi.twopass.gf_group.index];
        RC.rate_correction_factors[rf_lvl] = factor;
    } else if (cpi.refresh_alt_ref_frame != 0 || cpi.refresh_golden_frame != 0) &&
        RC.is_src_frame_alt_ref == 0 &&
        cpi.use_svc == 0 &&
        (cpi.oxcf.rc_mode != cast,no_check(u32) CBR || cpi.oxcf.gf_cbr_boost_pct > 100) {
        RC.rate_correction_factors[GF_ARF_STD] = factor;
    } else {
        RC.rate_correction_factors[INTER_NORMAL] = factor;
    }
}

vp9_rc_postencode_update_drop_frame :: (cpi: *VP9_COMP_in_vp9_encoder) {
    cpi.common.current_video_frame += 1;
    cpi.rc.frames_since_key += 1;
    cpi.rc.frames_to_key -= 1;
    cpi.rc.rc_2_frame = 0;
    cpi.rc.rc_1_frame = 0;
    cpi.rc.last_avg_frame_bandwidth = cpi.rc.avg_frame_bandwidth;
    cpi.rc.last_q[INTER_FRAME] = cpi.common.base_qindex;

    if cpi.use_svc != 0 &&
        cpi.svc.framedrop_mode != cast,no_check(u32) LAYER_DROP &&
        cpi.rc.buffer_level > cpi.rc.optimal_buffer_level {
        cpi.rc.buffer_level = cpi.rc.optimal_buffer_level;
        cpi.rc.bits_off_target = cpi.rc.optimal_buffer_level;
    }
    cpi.deadline_mode_previous_frame = cpi.oxcf.mode;
}

post_encode_drop_cbr :: (cpi: *VP9_COMP_in_vp9_encoder, size: *u64) -> s32 {
    frame_size := size.* << 3;
    new_buffer_level := (cpi.rc.buffer_level + cast(s64) cpi.rc.avg_frame_bandwidth) - cast,no_check(s64) frame_size;

    if new_buffer_level < 0 {
        size.* = 0;
        vp9_rc_postencode_update_drop_frame(cpi);

        if cpi.rc.high_source_sad != 0 || cpi.use_svc != 0 && cpi.svc.high_source_sad_superframe != 0 {
            cpi.rc.last_post_encode_dropped_scene_change = 1;
        }

        cpi.rc.force_max_q = 1;
        cpi.rc.avg_frame_qindex[INTER_FRAME] = cpi.rc.worst_quality;
        cpi.last_frame_dropped = 1;
        cpi.ext_refresh_frame_flags_pending = 0;
        if cpi.use_svc != 0 {
            svc := *cpi.svc;
            sl: s32 = 0;
            tl: s32 = 0;
            svc.last_layer_dropped[svc.spatial_layer_id] = 1;
            svc.drop_spatial_layer[svc.spatial_layer_id] = 1;
            svc.drop_count[svc.spatial_layer_id] += 1;
            svc.skip_enhancement_layer = 1;

            sl = 0;
            while sl < svc.number_spatial_layers {
                tl = 0;
                while tl < svc.number_temporal_layers {
                    LAYER := sl * svc.number_temporal_layers + tl;
                    lc := svc.layer_context.data + LAYER;
                    lrc := *lc.rc;
                    lrc.force_max_q = 1;
                    lrc.avg_frame_qindex[INTER_FRAME] = cpi.rc.worst_quality;
                    tl += 1;
                }
                sl += 1;
            }
        }
        return 1;
    }

    cpi.rc.force_max_q = 0;
    cpi.rc.last_post_encode_dropped_scene_change = 0;
    return 0;
}

vp9_test_drop :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    oxcf := *cpi.oxcf;
    RC := *cpi.rc;
    svc := *cpi.svc;
    drop_frames_water_mark := oxcf.drop_frames_water_mark;
    if cpi.use_svc != 0 {
        if svc.drop_count[svc.spatial_layer_id] == svc.max_consec_drop {
            svc.drop_count[svc.spatial_layer_id] = 0;
            return 0;
        } else {
            drop_frames_water_mark = svc.framedrop_thresh[svc.spatial_layer_id];
        }
    }
    if drop_frames_water_mark == 0 || svc.spatial_layer_id > 0 && svc.framedrop_mode == cast,no_check(u32) FULL_SUPERFRAME_DROP {
        return 0;
    } else if RC.buffer_level < 0 && svc.framedrop_mode != cast,no_check(u32) FULL_SUPERFRAME_DROP ||
        check_buffer_below_thresh(cpi, -1) != 0 && svc.framedrop_mode == cast,no_check(u32) FULL_SUPERFRAME_DROP {
        return 1;
    } else {
        drop_mark := cast,no_check(s32) ((cast(s64) drop_frames_water_mark) * RC.optimal_buffer_level / 100);
        if check_buffer_above_thresh(cpi, drop_mark) != 0 && RC.decimation_factor > 0 {
            RC.decimation_factor -= 1;
        } else if check_buffer_below_thresh(cpi, drop_mark) != 0 && RC.decimation_factor == 0 {
            RC.decimation_factor = 1;
        }
        if RC.decimation_factor > 0 {
            if RC.decimation_count > 0 {
                RC.decimation_count -= 1;
                return 1;
            } else {
                RC.decimation_count = RC.decimation_factor;
                return 0;
            }
        } else {
            RC.decimation_count = 0;
            return 0;
        }
    }
}

check_buffer_below_thresh :: (cpi: *VP9_COMP_in_vp9_encoder, drop_mark: s32) -> s32 {
    svc := *cpi.svc;
    if cpi.use_svc == 0 || cpi.svc.framedrop_mode == cast,no_check(u32) LAYER_DROP {
        RC := *cpi.rc;
        if RC.buffer_level <= cast,no_check(s64) drop_mark {
            return 1;
        }
        return 0;
    } else {
        i := svc.spatial_layer_id;
        while i < svc.number_spatial_layers {
            LAYER := i * svc.number_temporal_layers + svc.temporal_layer_id;
            lc := svc.layer_context.data + LAYER;
            lrc := *lc.rc;

            if lc.target_bandwidth > 0 {
                DROP_MARK_LAYER :=
                    cast,no_check(s32) ((cast(s64) cpi.svc.framedrop_thresh[i]) *
                        lrc.optimal_buffer_level / 100);
                if cpi.svc.framedrop_mode == cast,no_check(u32) FULL_SUPERFRAME_DROP {
                    if lrc.buffer_level <= cast,no_check(s64) DROP_MARK_LAYER {
                        return 1;
                    }
                } else if !(lrc.buffer_level <= cast,no_check(s64) DROP_MARK_LAYER) {
                    return 0;
                }
            }
            i += 1;
        }
        if cpi.svc.framedrop_mode == cast,no_check(u32) FULL_SUPERFRAME_DROP {
            return 0;
        } else {
            return 1;
        }
    }
}

check_buffer_above_thresh :: (cpi: *VP9_COMP_in_vp9_encoder, drop_mark: s32) -> s32 {
    svc := *cpi.svc;
    if cpi.use_svc == 0 || cpi.svc.framedrop_mode != cast,no_check(u32) FULL_SUPERFRAME_DROP {
        RC := *cpi.rc;
        if RC.buffer_level > cast,no_check(s64) drop_mark {
            return 1;
        }
        return 0;
    } else {
        i := svc.spatial_layer_id;
        while i < svc.number_spatial_layers {
            LAYER := i * svc.number_temporal_layers + svc.temporal_layer_id;
            lc := svc.layer_context.data + LAYER;
            lrc := *lc.rc;

            if lc.target_bandwidth > 0 {
                DROP_MARK_LAYER :=
                    cast,no_check(s32) ((cast(s64) cpi.svc.framedrop_thresh[i]) *
                        lrc.optimal_buffer_level / 100);
                if !(lrc.buffer_level > cast,no_check(s64) DROP_MARK_LAYER) {
                    return 0;
                }
            }
            i += 1;
        }
        return 1;
    }
}

vp9_rc_drop_frame :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    svc := *cpi.svc;
    svc_prev_layer_dropped: s32 = 0;

    if cpi.use_svc != 0 && svc.spatial_layer_id > 0 && svc.drop_spatial_layer[svc.spatial_layer_id - 1] != 0 {
        svc_prev_layer_dropped = 1;
    }
    if svc_prev_layer_dropped != 0 &&
        svc.framedrop_mode != cast,no_check(u32) LAYER_DROP &&
        svc.framedrop_mode != cast,no_check(u32) CONSTRAINED_FROM_ABOVE_DROP ||
        svc.force_drop_constrained_from_above[svc.spatial_layer_id] != 0 ||
        vp9_test_drop(cpi) != 0 {
        vp9_rc_postencode_update_drop_frame(cpi);
        cpi.ext_refresh_frame_flags_pending = 0;
        cpi.last_frame_dropped = 1;
        if cpi.use_svc != 0 {
            svc.last_layer_dropped[svc.spatial_layer_id] = 1;
            svc.drop_spatial_layer[svc.spatial_layer_id] = 1;
            svc.drop_count[svc.spatial_layer_id] += 1;
            svc.skip_enhancement_layer = 1;
            if svc.framedrop_mode == cast,no_check(u32) LAYER_DROP ||
                svc.framedrop_mode == cast,no_check(u32) CONSTRAINED_FROM_ABOVE_DROP &&
                    svc.force_drop_constrained_from_above[svc.number_spatial_layers - 1] == 0 ||
                svc.drop_spatial_layer[0] == 0 {
                vp9_inc_frame_in_layer(cpi);
            }
            if svc.spatial_layer_id == svc.number_spatial_layers - 1 {
                all_layers_drop: s32 = 1;
                i: s32 = 0;
                while i < svc.spatial_layer_id {
                    if svc.drop_spatial_layer[i] == 0 {
                        all_layers_drop = 0;
                        break;
                    }
                    i += 1;
                }
                if all_layers_drop == 1 {
                    svc.skip_enhancement_layer = 0;
                }
            }
        }
        return 1;
    }
    return 0;
}

vp9_rc_compute_frame_size_bounds :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    frame_target: s32,
    frame_under_shoot_limit: *s32,
    frame_over_shoot_limit: *s32
) {
    if cpi.oxcf.rc_mode == cast,no_check(u32) Q {
        frame_under_shoot_limit.* = 0;
        frame_over_shoot_limit.* = 2147483647;
    } else {
        TOL_LOW :=
            cast,no_check(s32) (((cast,no_check(s64) cpi.sf.recode_tolerance_low) * cast(s64) frame_target) /
                100);
        TOL_HIGH :=
            cast,no_check(s32) (((cast,no_check(s64) cpi.sf.recode_tolerance_high) * cast(s64) frame_target) /
                100);
        frame_under_shoot_limit.* = ifx frame_target - TOL_LOW - 100 > 0 then frame_target - TOL_LOW - 100 else 0;
        frame_over_shoot_limit.* =
            ifx frame_target + TOL_HIGH + 100 < cpi.rc.max_frame_bandwidth then frame_target +
                TOL_HIGH + 100 else cpi.rc.max_frame_bandwidth;
    }
}

vp9_rc_pick_q_and_bounds :: (cpi: *VP9_COMP_in_vp9_encoder, bottom_index: *s32, top_index: *s32) -> s32 {
    GF_GROUP_INDEX := cast,no_check(s32) cpi.twopass.gf_group.index;
    q: s32 = ifx cpi.oxcf.pass == 0
        then ifx cpi.oxcf.rc_mode == cast,no_check(u32) CBR
            then rc_pick_q_and_bounds_one_pass_cbr(cpi, bottom_index, top_index)
            else rc_pick_q_and_bounds_one_pass_vbr(cpi, bottom_index, top_index)
        else vp9_rc_pick_q_and_bounds_two_pass(cpi, bottom_index, top_index, GF_GROUP_INDEX);
    if cpi.sf.use_nonrd_pick_mode != 0 {
        if cpi.sf.force_frame_boost == 1 {
            q =
                ifx q - cpi.sf.max_delta_qindex > cpi.rc.best_quality then q -
                    cpi.sf.max_delta_qindex else cpi.rc.best_quality;
        }
        if q < bottom_index.* {
            bottom_index.* = q;
        } else if q > top_index.* {
            top_index.* = q;
        }
    }
    return q;
}

vp9_rc_pick_q_and_bounds_two_pass :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    bottom_index: *s32,
    top_index: *s32,
    gf_group_index: s32
) -> s32 {
    CM := *cpi.common;
    RC := *cpi.rc;
    OXCF := *cpi.oxcf;
    gf_group := *cpi.twopass.gf_group;
    CQ_LEVEL := get_active_cq_level_two_pass(*cpi.twopass, RC, OXCF);
    active_best_quality: s32 = ---;
    active_worst_quality := cpi.twopass.active_worst_quality;
    q: s32 = ---;
    inter_minq: *s32 = ---;
    arf_active_best_quality_hl: s32 = ---;
    arfgf_high_motion_minq, arfgf_low_motion_minq: *s32 = ---;
    BOOST_FRAME :=
        cast(s32) (RC.is_src_frame_alt_ref == 0 &&
            (cpi.refresh_golden_frame != 0 || cpi.refresh_alt_ref_frame != 0));

    CM.bit_depth;

    inter_minq = inter_minq_8.data;

    if OXCF.rc_mode == cast,no_check(u32) Q {
        return rc_constant_q(cpi, bottom_index, top_index, gf_group_index);
    }

    if frame_is_intra_only_in_vp9_ratectrl(CM) != 0 {
        pick_kf_q_bound_two_pass(cpi, *active_best_quality, *active_worst_quality);
    } else if BOOST_FRAME != 0 {
        if RC.frames_since_key > 1 && RC.avg_frame_qindex[INTER_FRAME] < active_worst_quality {
            q = RC.avg_frame_qindex[INTER_FRAME];
        } else {
            q = active_worst_quality;
        }

        if OXCF.rc_mode == cast,no_check(u32) CQ {
            if q < CQ_LEVEL {
                q = CQ_LEVEL;
            }
        }
        active_best_quality = get_gf_active_quality(cpi, q, CM.bit_depth);
        arf_active_best_quality_hl = active_best_quality;

        if RC.arf_increase_active_best_quality == 1 {
            CM.bit_depth;

            arfgf_high_motion_minq = arfgf_high_motion_minq_8.data;
            arf_active_best_quality_hl = arfgf_high_motion_minq[q];
        } else if RC.arf_increase_active_best_quality == -1 {
            CM.bit_depth;

            arfgf_low_motion_minq = arfgf_low_motion_minq_8.data;
            arf_active_best_quality_hl = arfgf_low_motion_minq[q];
        }
        active_best_quality =
            cast,no_check(s32) ((cast,no_check(float64) active_best_quality) * RC.arf_active_best_quality_adjustment_factor +
                (cast,no_check(float64) arf_active_best_quality_hl) * (1.0 - RC.arf_active_best_quality_adjustment_factor));

        if gf_group.rf_level[gf_group_index] == cast,no_check(u32) GF_ARF_LOW {
            LAYER_DEPTH := cast,no_check(s32) gf_group.layer_depth[gf_group_index];

            active_best_quality = ((LAYER_DEPTH - 1) * q + active_best_quality + LAYER_DEPTH / 2) / LAYER_DEPTH;
        }
    } else {
        active_best_quality = inter_minq[active_worst_quality];

        if OXCF.rc_mode == cast,no_check(u32) CQ && active_best_quality < CQ_LEVEL {
            active_best_quality = CQ_LEVEL;
        }
    }

    if frame_is_intra_only_in_vp9_ratectrl(CM) != 0 || BOOST_FRAME != 0 {
        LAYER_DEPTH := cast,no_check(s32) gf_group.layer_depth[gf_group_index];
        active_best_quality -= cpi.twopass.extend_minq + cpi.twopass.extend_minq_fast;
        active_worst_quality += cpi.twopass.extend_maxq / 2;

        if gf_group.rf_level[gf_group_index] == cast,no_check(u32) GF_ARF_LOW {
            active_best_quality =
                ifx active_best_quality > cpi.twopass.last_qindex_of_arf_layer[LAYER_DEPTH -
                    1] then active_best_quality else cpi.twopass.last_qindex_of_arf_layer[LAYER_DEPTH - 1];
        }
    } else {
        MAX_LAYER_DEPTH := gf_group.max_layer_depth;

        active_best_quality -= (cpi.twopass.extend_minq + cpi.twopass.extend_minq_fast) / 2;
        active_worst_quality += cpi.twopass.extend_maxq;

        active_best_quality =
            ifx active_best_quality > cpi.twopass.last_qindex_of_arf_layer[MAX_LAYER_DEPTH -
                1] then active_best_quality else cpi.twopass.last_qindex_of_arf_layer[MAX_LAYER_DEPTH - 1];
    }

    if frame_is_intra_only_in_vp9_ratectrl(CM) == 0 ||
        RC.this_key_frame_forced == 0 ||
        cpi.twopass.last_kfgroup_zeromotion_pct < 95 {
        qdelta :=
            vp9_frame_type_qdelta(
                cpi,
                cast,no_check(s32) gf_group.rf_level[gf_group_index],
                active_worst_quality
            );
        active_worst_quality =
            ifx active_worst_quality + qdelta > active_best_quality then active_worst_quality +
                qdelta else active_best_quality;
    }

    if RC.frame_size_selector != cast,no_check(u32) UNSCALED && frame_is_kf_gf_arf_in_vp9_ratectrl(cpi) == 0 {
        qdelta := vp9_compute_qdelta_by_rate(RC, CM.frame_type, active_best_quality, 2.0, CM.bit_depth);
        active_best_quality =
            ifx active_best_quality + qdelta > RC.best_quality then active_best_quality +
                qdelta else RC.best_quality;
    }

    active_best_quality = clamp_in_vp9_ratectrl(active_best_quality, RC.best_quality, RC.worst_quality);
    active_worst_quality = clamp_in_vp9_ratectrl(active_worst_quality, active_best_quality, RC.worst_quality);

    if frame_is_intra_only_in_vp9_ratectrl(CM) != 0 && RC.this_key_frame_forced != 0 {
        if cpi.twopass.last_kfgroup_zeromotion_pct >= 95 {
            q = ifx RC.last_kf_qindex < RC.last_boosted_qindex then RC.last_kf_qindex else RC.last_boosted_qindex;
        } else {
            q = RC.last_boosted_qindex;
        }
    } else if frame_is_intra_only_in_vp9_ratectrl(CM) != 0 && RC.this_key_frame_forced == 0 {
        q = active_best_quality;
    } else {
        q = vp9_rc_regulate_q(cpi, RC.this_frame_target, active_best_quality, active_worst_quality);
        if q > active_worst_quality {
            if RC.this_frame_target >= RC.max_frame_bandwidth {
                active_worst_quality = q;
            } else {
                q = active_worst_quality;
            }
        }
    }

    top_index.* = active_worst_quality;
    bottom_index.* = active_best_quality;

    return q;
}

vp9_compute_qdelta_by_rate :: (
    rc: *RATE_CONTROL,
    frame_type: FRAME_TYPE,
    qindex: s32,
    rate_target_ratio: float64,
    bit_depth: Bit_Depth_T
) -> s32 {
    target_index := rc.worst_quality;

    BASE_BITS_PER_MB := vp9_rc_bits_per_mb(frame_type, qindex, 1.0, bit_depth);

    TARGET_BITS_PER_MB := cast,no_check(s32) (rate_target_ratio * BASE_BITS_PER_MB);

    i := rc.best_quality;
    while i < rc.worst_quality {
        if vp9_rc_bits_per_mb(frame_type, i, 1.0, bit_depth) <= TARGET_BITS_PER_MB {
            target_index = i;
            break;
        }
        i += 1;
    }
    return target_index - qindex;
}

frame_is_kf_gf_arf_in_vp9_ratectrl :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if frame_is_intra_only_in_vp9_ratectrl(*cpi.common) != 0 ||
        cpi.refresh_alt_ref_frame != 0 ||
        cpi.refresh_golden_frame != 0 && cpi.rc.is_src_frame_alt_ref == 0 {
        return 1;
    }
    return 0;
}

vp9_frame_type_qdelta :: (cpi: *VP9_COMP_in_vp9_encoder, rf_level: s32, q: s32) -> s32 {
    CM := *cpi.common;

    qdelta := vp9_compute_qdelta_by_rate(*cpi.rc, CM.frame_type, q, RATE_FACTOR_DELTAS[rf_level], CM.bit_depth);
    return qdelta;
}

get_active_cq_level_two_pass :: (twopass: *TWO_PASS, rc: *RATE_CONTROL, OXCF: *VP9_Encoder_Config) -> s32 {
    active_cq_level := OXCF.cq_level;
    if OXCF.rc_mode == cast,no_check(u32) CQ {
        if c_transpiler_float_greater(twopass.mb_smooth_pct, 0.1) {
            active_cq_level -= cast,no_check(s32) ((twopass.mb_smooth_pct - 0.1) / 0.05);
            active_cq_level = ifx active_cq_level > 0 then active_cq_level else 0;
        }
        if rc.total_target_bits > 0 {
            X := (cast,no_check(float64) rc.total_actual_bits) / rc.total_target_bits;
            if c_transpiler_float_less(X, 0.1) {
                active_cq_level = cast,no_check(s32) (active_cq_level * X / 0.1);
            }
        }
    }
    return active_cq_level;
}

get_gf_active_quality :: (CPI: *VP9_COMP_in_vp9_encoder, q: s32, bit_depth: Bit_Depth_T) -> s32 {
    GF_GROUP_ := *CPI.twopass.gf_group;
    RC := *CPI.rc;

    arfgf_low_motion_minq: *s32 = ---;
    arfgf_high_motion_minq: *s32 = ---;
    GFU_BOOST := (ifx CPI.multi_layer_arf != 0 then GF_GROUP_.gfu_boost[GF_GROUP_.index] else RC.gfu_boost);
    arfgf_low_motion_minq = arfgf_low_motion_minq_8.data;
    arfgf_high_motion_minq = arfgf_high_motion_minq_8.data;
    return get_active_quality(q, GFU_BOOST, gf_low, gf_high, arfgf_low_motion_minq, arfgf_high_motion_minq);
}

get_active_quality :: (
    q: s32,
    gfu_boost: s32,
    low: s32,
    high: s32,
    low_motion_minq: *s32,
    high_motion_minq: *s32
) -> s32 {
    if gfu_boost > high {
        return low_motion_minq[q];
    } else if gfu_boost < low {
        return high_motion_minq[q];
    } else {
        GAP := high - low;
        OFFSET := high - gfu_boost;
        QDIFF := high_motion_minq[q] - low_motion_minq[q];
        ADJUSTMENT := (OFFSET * QDIFF + GAP >> 1) / GAP;
        return low_motion_minq[q] + ADJUSTMENT;
    }
}

pick_kf_q_bound_two_pass :: (cpi: *VP9_COMP_in_vp9_encoder, bottom_index: *s32, top_index: *s32) {
    CM := *cpi.common;
    RC := *cpi.rc;
    active_best_quality: s32 = ---;
    active_worst_quality := cpi.twopass.active_worst_quality;

    if RC.this_key_frame_forced != 0 {
        last_boosted_q: float64 = ---;
        delta_qindex: s32 = ---;
        qindex: s32 = ---;

        if cpi.twopass.last_kfgroup_zeromotion_pct >= 95 {
            qindex = ifx RC.last_kf_qindex < RC.last_boosted_qindex then RC.last_kf_qindex else RC.last_boosted_qindex;
            active_best_quality = qindex;
            last_boosted_q = vp9_convert_qindex_to_q(qindex, CM.bit_depth);
            delta_qindex = vp9_compute_qdelta(RC, last_boosted_q, last_boosted_q * 1.25, CM.bit_depth);
            active_worst_quality =
                ifx qindex + delta_qindex < active_worst_quality then qindex +
                    delta_qindex else active_worst_quality;
        } else {
            qindex = RC.last_boosted_qindex;
            last_boosted_q = vp9_convert_qindex_to_q(qindex, CM.bit_depth);
            delta_qindex = vp9_compute_qdelta(RC, last_boosted_q, last_boosted_q * 0.75, CM.bit_depth);
            active_best_quality =
                ifx qindex + delta_qindex > RC.best_quality then qindex +
                    delta_qindex else RC.best_quality;
        }
    } else {
        q_adj_factor: float64 = 1.0;

        active_best_quality = get_kf_active_quality(RC, active_worst_quality, CM.bit_depth);
        if cpi.twopass.kf_zeromotion_pct >= 99 {
            active_best_quality /= 4;
        }

        active_best_quality =
            ifx active_worst_quality < (ifx 1 > active_best_quality then 1 else active_best_quality) then active_worst_quality else (ifx 1 > active_best_quality then 1 else active_best_quality);

        if CM.width * CM.height <= 352 * 288 {
            q_adj_factor -= 0.25;
        }

        q_adj_factor += 0.05 - 0.001 * cast,no_check(float64) cpi.twopass.kf_zeromotion_pct;

        q_val := vp9_convert_qindex_to_q(active_best_quality, CM.bit_depth);
        active_best_quality += vp9_compute_qdelta(RC, q_val, q_val * q_adj_factor, CM.bit_depth);
    }
    top_index.* = active_worst_quality;
    bottom_index.* = active_best_quality;
}

vp9_compute_qdelta :: (rc: *RATE_CONTROL, qstart: float64, qtarget: float64, bit_depth: Bit_Depth_T) -> s32 {
    start_index := rc.worst_quality;
    target_index := rc.worst_quality;

    i := rc.best_quality;
    while i < rc.worst_quality {
        start_index = i;
        if c_transpiler_float_greater_equal(vp9_convert_qindex_to_q(i, bit_depth), qstart) {
            break;
        }
        i += 1;
    }

    i = rc.best_quality;
    while i < rc.worst_quality {
        target_index = i;
        if c_transpiler_float_greater_equal(vp9_convert_qindex_to_q(i, bit_depth), qtarget) {
            break;
        }
        i += 1;
    }

    return target_index - start_index;
}

get_kf_active_quality :: (RC: *RATE_CONTROL, q: s32, bit_depth: Bit_Depth_T) -> s32 {
    kf_low_motion_minq: *s32 = ---;
    kf_high_motion_minq: *s32 = ---;
    kf_low_motion_minq = kf_low_motion_minq_8.data;
    kf_high_motion_minq = kf_high_motion_minq_8.data;
    return get_active_quality(q, RC.kf_boost, kf_low, kf_high, kf_low_motion_minq, kf_high_motion_minq);
}

rc_constant_q :: (cpi: *VP9_COMP_in_vp9_encoder, bottom_index: *s32, top_index: *s32, gf_group_index: s32) -> s32 {
    CM := *cpi.common;
    RC := *cpi.rc;
    OXCF := *cpi.oxcf;
    gf_group := *cpi.twopass.gf_group;
    IS_INTRA_FRAME := frame_is_intra_only_in_vp9_ratectrl(CM);

    CQ_LEVEL := get_active_cq_level_two_pass(*cpi.twopass, RC, OXCF);

    q := CQ_LEVEL;
    active_best_quality := CQ_LEVEL;
    active_worst_quality := CQ_LEVEL;

    if IS_INTRA_FRAME != 0 && RC.frames_to_key > 1 {
        pick_kf_q_bound_two_pass(cpi, *active_best_quality, *active_worst_quality);
    }

    if IS_INTRA_FRAME == 0 && RC.is_src_frame_alt_ref == 0 && cpi.refresh_alt_ref_frame != 0 {
        active_best_quality = get_gf_active_quality(cpi, q, CM.bit_depth);

        if gf_group.rf_level[gf_group_index] == cast,no_check(u32) GF_ARF_LOW {
            LAYER_DEPTH := cast,no_check(s32) gf_group.layer_depth[gf_group_index];

            active_best_quality = ((LAYER_DEPTH - 1) * CQ_LEVEL + active_best_quality + LAYER_DEPTH / 2) / LAYER_DEPTH;
        }
    }

    q = active_best_quality;
    top_index.* = active_worst_quality;
    bottom_index.* = active_best_quality;
    return q;
}

rc_pick_q_and_bounds_one_pass_vbr :: (cpi: *VP9_COMP_in_vp9_encoder, bottom_index: *s32, top_index: *s32) -> s32 {
    CM := *cpi.common;
    RC := *cpi.rc;
    OXCF := *cpi.oxcf;
    CQ_LEVEL := get_active_cq_level_one_pass(RC, OXCF);
    active_best_quality: s32 = ---;
    active_worst_quality := calc_active_worst_quality_one_pass_vbr(cpi);
    q: s32 = ---;
    inter_minq: *s32 = ---;
    CM.bit_depth;

    inter_minq = inter_minq_8.data;

    if frame_is_intra_only_in_vp9_ratectrl(CM) != 0 {
        if OXCF.rc_mode == cast,no_check(u32) Q {
            qindex := CQ_LEVEL;
            qstart := vp9_convert_qindex_to_q(qindex, CM.bit_depth);
            delta_qindex := vp9_compute_qdelta(RC, qstart, qstart * 0.25, CM.bit_depth);
            active_best_quality =
                ifx qindex + delta_qindex > RC.best_quality then qindex +
                    delta_qindex else RC.best_quality;
        } else if RC.this_key_frame_forced != 0 {
            qindex := RC.last_boosted_qindex;
            last_boosted_q := vp9_convert_qindex_to_q(qindex, CM.bit_depth);
            delta_qindex := vp9_compute_qdelta(RC, last_boosted_q, last_boosted_q * 0.75, CM.bit_depth);
            active_best_quality =
                ifx qindex + delta_qindex > RC.best_quality then qindex +
                    delta_qindex else RC.best_quality;
        } else {
            q_adj_factor: float64 = 1.0;

            active_best_quality = get_kf_active_quality(RC, RC.avg_frame_qindex[KEY_FRAME], CM.bit_depth);

            if CM.width * CM.height <= 352 * 288 {
                q_adj_factor -= 0.25;
            }

            q_val := vp9_convert_qindex_to_q(active_best_quality, CM.bit_depth);
            active_best_quality += vp9_compute_qdelta(RC, q_val, q_val * q_adj_factor, CM.bit_depth);
        }
    } else if RC.is_src_frame_alt_ref == 0 && (cpi.refresh_golden_frame != 0 || cpi.refresh_alt_ref_frame != 0) {
        if RC.frames_since_key > 1 {
            if RC.avg_frame_qindex[INTER_FRAME] < active_worst_quality {
                q = RC.avg_frame_qindex[INTER_FRAME];
            } else {
                q = active_worst_quality;
            }
        } else {
            q = RC.avg_frame_qindex[KEY_FRAME];
        }

        if OXCF.rc_mode == cast,no_check(u32) CQ {
            if q < CQ_LEVEL {
                q = CQ_LEVEL;
            }

            active_best_quality = get_gf_active_quality(cpi, q, CM.bit_depth);

            active_best_quality = active_best_quality * 15 / 16;
        } else if OXCF.rc_mode == cast,no_check(u32) Q {
            qindex := CQ_LEVEL;
            qstart := vp9_convert_qindex_to_q(qindex, CM.bit_depth);

            delta_qindex: s32 = ifx cpi.refresh_alt_ref_frame != 0
                then vp9_compute_qdelta(RC, qstart, qstart * 0.4, CM.bit_depth)
                else vp9_compute_qdelta(RC, qstart, qstart * 0.5, CM.bit_depth);
            active_best_quality =
                ifx qindex + delta_qindex > RC.best_quality then qindex +
                    delta_qindex else RC.best_quality;
        } else {
            active_best_quality = get_gf_active_quality(cpi, q, CM.bit_depth);
        }
    } else if OXCF.rc_mode == cast,no_check(u32) Q {
        qindex := CQ_LEVEL;
        qstart := vp9_convert_qindex_to_q(qindex, CM.bit_depth);
        delta_rate :=
            float64.[
                0.5,
                1.0,
                0.85,
                1.0,
                0.7,
                1.0,
                0.85,
                1.0
            ];
        delta_qindex :=
            vp9_compute_qdelta(
                RC,
                qstart,
                qstart * delta_rate[CM.current_video_frame % 8],
                CM.bit_depth
            );
        active_best_quality =
            ifx qindex + delta_qindex > RC.best_quality then qindex +
                delta_qindex else RC.best_quality;
    } else {
        if CM.current_video_frame > 1 {
            q =
                ifx RC.avg_frame_qindex[INTER_FRAME] < active_worst_quality then RC.avg_frame_qindex[INTER_FRAME] else active_worst_quality;
            active_best_quality = inter_minq[q];
        } else {
            active_best_quality = inter_minq[RC.avg_frame_qindex[KEY_FRAME]];
        }

        if OXCF.rc_mode == cast,no_check(u32) CQ && active_best_quality < CQ_LEVEL {
            active_best_quality = CQ_LEVEL;
        }
    }

    active_best_quality = clamp_in_vp9_ratectrl(active_best_quality, RC.best_quality, RC.worst_quality);
    active_worst_quality = clamp_in_vp9_ratectrl(active_worst_quality, active_best_quality, RC.worst_quality);

    top_index.* = active_worst_quality;
    bottom_index.* = active_best_quality;

    {
        qdelta: s32 = 0;

        if CM.frame_type == cast,no_check(u32) KEY_FRAME && RC.this_key_frame_forced == 0 && CM.current_video_frame != 0 {
            qdelta = vp9_compute_qdelta_by_rate(*cpi.rc, CM.frame_type, active_worst_quality, 2.0, CM.bit_depth);
        } else if RC.is_src_frame_alt_ref == 0 && (cpi.refresh_golden_frame != 0 || cpi.refresh_alt_ref_frame != 0) {
            qdelta = vp9_compute_qdelta_by_rate(*cpi.rc, CM.frame_type, active_worst_quality, 1.75, CM.bit_depth);
        }
        if RC.high_source_sad != 0 && cpi.sf.use_altref_onepass != 0 {
            qdelta = 0;
        }
        top_index.* = active_worst_quality + qdelta;
        top_index.* = max(top_index.*, bottom_index.*);
    }

    if OXCF.rc_mode == cast,no_check(u32) Q {
        q = active_best_quality;
    } else if CM.frame_type == cast,no_check(u32) KEY_FRAME && RC.this_key_frame_forced != 0 {
        q = clamp_in_vp9_ratectrl(RC.last_boosted_qindex, RC.best_quality, RC.worst_quality);
    } else {
        q = vp9_rc_regulate_q(cpi, RC.this_frame_target, active_best_quality, active_worst_quality);

        QP_THRESH: s32 = 32;
        BITRATE_ERR :=
            cast,no_check(s64) ((cpi.framerate * (RC.buffer_level - RC.starting_buffer_level - cast(s64) RC.avg_frame_bandwidth)) /
                (CM.current_video_frame + 1));

        if cpi.oxcf.lag_in_frames == 0 &&
            (BITRATE_ERR / 1000) < -10 &&
            QP_THRESH < RC.worst_quality &&
            (q < QP_THRESH || top_index.* < QP_THRESH) {
            q = QP_THRESH;
            top_index.* = max(top_index.*, q);
        }

        if q > top_index.* {
            if RC.this_frame_target >= RC.max_frame_bandwidth {
                top_index.* = q;
            } else {
                q = top_index.*;
            }
        }
    }

    return q;
}

calc_active_worst_quality_one_pass_vbr :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    RC := *cpi.rc;
    CURR_FRAME := cpi.common.current_video_frame;

    active_worst_quality: s32 = ifx cpi.common.frame_type == cast,no_check(u32) KEY_FRAME
        then (ifx CURR_FRAME == 0 then RC.worst_quality else RC.last_q[KEY_FRAME] << 1)
        else ifx RC.is_src_frame_alt_ref == 0 && cpi.use_svc == 0 && (cpi.refresh_golden_frame != 0 || cpi.refresh_alt_ref_frame != 0)
            then (ifx CURR_FRAME == 1 then (RC.last_q[KEY_FRAME] * 5) >> 2 else RC.last_q[INTER_FRAME] * RC.fac_active_worst_gf / 100)
            else (ifx CURR_FRAME == 1 then RC.last_q[KEY_FRAME] << 1 else RC.avg_frame_qindex[INTER_FRAME] * RC.fac_active_worst_inter / 100);
    return ifx active_worst_quality < RC.worst_quality then active_worst_quality else RC.worst_quality;
}

get_active_cq_level_one_pass :: (rc: *RATE_CONTROL, OXCF: *VP9_Encoder_Config) -> s32 {
    active_cq_level := OXCF.cq_level;
    if OXCF.rc_mode == cast,no_check(u32) CQ && rc.total_target_bits > 0 {
        X := (cast,no_check(float64) rc.total_actual_bits) / rc.total_target_bits;
        if c_transpiler_float_less(X, 0.1) {
            active_cq_level = cast,no_check(s32) (active_cq_level * X / 0.1);
        }
    }
    return active_cq_level;
}

rc_pick_q_and_bounds_one_pass_cbr :: (cpi: *VP9_COMP_in_vp9_encoder, bottom_index: *s32, top_index: *s32) -> s32 {
    CM := *cpi.common;
    RC := *cpi.rc;
    active_best_quality: s32 = ---;
    active_worst_quality := calc_active_worst_quality_one_pass_cbr(cpi);
    q: s32 = ---;
    rtc_minq: *s32 = ---;
    CM.bit_depth;

    rtc_minq = rtc_minq_8.data;

    if frame_is_intra_only_in_vp9_ratectrl(CM) != 0 {
        active_best_quality = RC.best_quality;

        if RC.this_key_frame_forced != 0 {
            qindex := RC.last_boosted_qindex;
            last_boosted_q := vp9_convert_qindex_to_q(qindex, CM.bit_depth);
            delta_qindex := vp9_compute_qdelta(RC, last_boosted_q, last_boosted_q * 0.75, CM.bit_depth);
            active_best_quality =
                ifx qindex + delta_qindex > RC.best_quality then qindex +
                    delta_qindex else RC.best_quality;
        } else if CM.current_video_frame > 0 {
            q_adj_factor: float64 = 1.0;

            active_best_quality = get_kf_active_quality(RC, RC.avg_frame_qindex[KEY_FRAME], CM.bit_depth);

            if CM.width * CM.height <= 352 * 288 {
                q_adj_factor -= 0.25;
            }

            q_val := vp9_convert_qindex_to_q(active_best_quality, CM.bit_depth);
            active_best_quality += vp9_compute_qdelta(RC, q_val, q_val * q_adj_factor, CM.bit_depth);
        }
    } else if RC.is_src_frame_alt_ref == 0 &&
        cpi.use_svc == 0 &&
        cpi.oxcf.gf_cbr_boost_pct != 0 &&
        (cpi.refresh_golden_frame != 0 || cpi.refresh_alt_ref_frame != 0) {
        if RC.frames_since_key > 1 && RC.avg_frame_qindex[INTER_FRAME] < active_worst_quality {
            q = RC.avg_frame_qindex[INTER_FRAME];
        } else {
            q = active_worst_quality;
        }
        active_best_quality = get_gf_active_quality(cpi, q, CM.bit_depth);
    } else if CM.current_video_frame > 1 {
        if RC.avg_frame_qindex[INTER_FRAME] < active_worst_quality {
            active_best_quality = rtc_minq[RC.avg_frame_qindex[INTER_FRAME]];
        } else {
            active_best_quality = rtc_minq[active_worst_quality];
        }
    } else if RC.avg_frame_qindex[KEY_FRAME] < active_worst_quality {
        active_best_quality = rtc_minq[RC.avg_frame_qindex[KEY_FRAME]];
    } else {
        active_best_quality = rtc_minq[active_worst_quality];
    }

    active_best_quality = clamp_in_vp9_ratectrl(active_best_quality, RC.best_quality, RC.worst_quality);
    active_worst_quality = clamp_in_vp9_ratectrl(active_worst_quality, active_best_quality, RC.worst_quality);

    top_index.* = active_worst_quality;
    bottom_index.* = active_best_quality;

    if frame_is_intra_only_in_vp9_ratectrl(CM) != 0 && RC.this_key_frame_forced != 0 {
        q = clamp_in_vp9_ratectrl(RC.last_boosted_qindex, RC.best_quality, RC.worst_quality);
    } else {
        q = vp9_rc_regulate_q(cpi, RC.this_frame_target, active_best_quality, active_worst_quality);
        if q > top_index.* {
            if RC.this_frame_target >= RC.max_frame_bandwidth {
                top_index.* = q;
            } else {
                q = top_index.*;
            }
        }
    }

    return q;
}

vp9_rc_update_framerate :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    OXCF := *cpi.oxcf;
    RC := *cpi.rc;

    RC.avg_frame_bandwidth =
        saturate_cast_double_to_int_in_vp9_ratectrl(
            c_transpiler_math_round(OXCF.target_bandwidth / cpi.framerate)
        );

    vbr_min_bits := ((cast,no_check(s64) RC.avg_frame_bandwidth) * cast(s64) OXCF.two_pass_vbrmin_section) / 100;
    vbr_min_bits = ifx vbr_min_bits < 2147483647 then vbr_min_bits else 2147483647;

    RC.min_frame_bandwidth = ifx cast,no_check(s32) vbr_min_bits > 200 then cast,no_check(s32) vbr_min_bits else 200;

    vbr_max_bits := ((cast,no_check(s64) RC.avg_frame_bandwidth) * cast(s64) OXCF.two_pass_vbrmax_section) / 100;
    vbr_max_bits = ifx vbr_max_bits < 2147483647 then vbr_max_bits else 2147483647;

    RC.max_frame_bandwidth =
        ifx (ifx CM.m_bs * 250 > 4000000 then CM.m_bs * 250 else 4000000) > cast,no_check(s32) vbr_max_bits then (ifx CM.m_bs *
            250 > 4000000 then CM.m_bs * 250 else 4000000) else cast,no_check(s32) vbr_max_bits;

    vp9_rc_set_gf_interval_range(cpi, RC);
}

vp9_rc_set_gf_interval_range :: (CPI: *VP9_COMP_in_vp9_encoder, RC: *RATE_CONTROL) {
    OXCF := *CPI.oxcf;

    if OXCF.pass == 0 && OXCF.rc_mode == cast,no_check(u32) Q {
        RC.max_gf_interval = 8;
        RC.min_gf_interval = 8;
        RC.static_scene_max_gf_interval = 8;
    } else {
        framerate := CPI.framerate;

        RC.max_gf_interval = OXCF.max_gf_interval;
        RC.min_gf_interval = OXCF.min_gf_interval;
        if RC.min_gf_interval == 0 {
            RC.min_gf_interval = vp9_rc_get_default_min_gf_interval(OXCF.width, OXCF.height, framerate);
        }
        if RC.max_gf_interval == 0 {
            RC.max_gf_interval = vp9_rc_get_default_max_gf_interval(framerate, RC.min_gf_interval);
        }

        RC.static_scene_max_gf_interval = 250;

        if RC.max_gf_interval > RC.static_scene_max_gf_interval {
            RC.max_gf_interval = RC.static_scene_max_gf_interval;
        }

        RC.min_gf_interval =
            ifx RC.min_gf_interval < RC.max_gf_interval then RC.min_gf_interval else RC.max_gf_interval;

        if OXCF.target_level == cast,no_check(u32) LEVEL_AUTO {
            PIC_SIZE := cast,no_check(u32) (CPI.common.width * CPI.common.height);
            PIC_BREADTH :=
                cast,no_check(u32) ((ifx CPI.common.width > CPI.common.height then CPI.common.width else CPI.common.height));

            for i: 0..cast(s32) 14 - 1 {
                if VP9_LEVEL_DEFS[i].max_luma_picture_size >= PIC_SIZE && VP9_LEVEL_DEFS[i].max_luma_picture_breadth >= PIC_BREADTH {
                    if RC.min_gf_interval <= cast,no_check(s32) VP9_LEVEL_DEFS[i].min_altref_distance {
                        RC.min_gf_interval = cast,no_check(s32) VP9_LEVEL_DEFS[i].min_altref_distance;
                        RC.max_gf_interval =
                            ifx RC.max_gf_interval > RC.min_gf_interval then RC.max_gf_interval else RC.min_gf_interval;
                    }
                    break;
                }
            }
        }
    }
}

vp9_set_target_rate :: (cpi: *VP9_COMP_in_vp9_encoder) {
    RC := *cpi.rc;
    target_rate := RC.base_frame_target;

    if cpi.common.frame_type == cast,no_check(u32) KEY_FRAME {
        target_rate = vp9_rc_clamp_iframe_target_size(cpi, target_rate);
    } else {
        target_rate = vp9_rc_clamp_pframe_target_size(cpi, target_rate);
    }

    if cpi.oxcf.vbr_corpus_complexity == 0 {
        if cpi.oxcf.rc_mode == cast,no_check(u32) VBR || cpi.oxcf.rc_mode == cast,no_check(u32) CQ {
            vbr_rate_correction(cpi, *target_rate);
        }
    }
    vp9_rc_set_frame_target(cpi, target_rate);
}

vbr_rate_correction :: (cpi: *VP9_COMP_in_vp9_encoder, this_frame_target: *s32) {
    RC := *cpi.rc;
    vbr_bits_off_target := RC.vbr_bits_off_target;
    frame_target := cast,no_check(s64) this_frame_target.*;
    frame_window :=
        cast,no_check(s32) ((ifx c_transpiler_float_less(16.0, (cpi.twopass.total_stats.count - cpi.common.current_video_frame)) then 16.0 else cpi.twopass.total_stats.count -
            cpi.common.current_video_frame));

    if frame_window > 0 {
        max_delta :=
            (ifx vbr_bits_off_target > 0 then vbr_bits_off_target /
                cast(s64) frame_window else -vbr_bits_off_target / cast(s64) frame_window);

        max_delta = ifx max_delta < (frame_target * 50) / 100 then max_delta else (frame_target * 50) / 100;

        if vbr_bits_off_target > 0 {
            frame_target += min(vbr_bits_off_target, max_delta);
        } else {
            frame_target -= (ifx -vbr_bits_off_target < max_delta then -vbr_bits_off_target else max_delta);
        }
    }

    if frame_is_kf_gf_arf_in_vp9_ratectrl(cpi) == 0 && RC.is_src_frame_alt_ref == 0 && RC.vbr_bits_off_target_fast != 0 {
        one_frame_bits :=
            (ifx cast,no_check(s64) RC.avg_frame_bandwidth > frame_target then cast,no_check(s64) RC.avg_frame_bandwidth else frame_target);
        fast_extra_bits :=
            (ifx RC.vbr_bits_off_target_fast < one_frame_bits then RC.vbr_bits_off_target_fast else one_frame_bits);
        fast_extra_bits =
            ifx fast_extra_bits < (ifx (one_frame_bits / 8) > RC.vbr_bits_off_target_fast / 8 then one_frame_bits / 8 else RC.vbr_bits_off_target_fast /
                8) then fast_extra_bits else (ifx (one_frame_bits / 8) > RC.vbr_bits_off_target_fast / 8 then one_frame_bits / 8 else RC.vbr_bits_off_target_fast / 8);
        frame_target += fast_extra_bits;
        RC.vbr_bits_off_target_fast -= fast_extra_bits;
    }

    this_frame_target.* = cast,no_check(s32) ((ifx frame_target < 2147483647 then frame_target else 2147483647));
}

vp9_scene_detection_onepass :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    RC := *cpi.rc;
    unscaled_src := cpi.un_scaled_source;
    unscaled_last_src := cpi.unscaled_last_source;

    if cpi.un_scaled_source == null || cpi.unscaled_last_source == null || cpi.use_svc != 0 && cpi.svc.current_superframe == 0 {
        return;
    }
    src_y := unscaled_src.y_buffer;
    src_ystride := unscaled_src.y_stride;
    src_width := unscaled_src.y_width;
    src_height := unscaled_src.y_height;
    last_src_y := unscaled_last_src.y_buffer;
    last_src_ystride := unscaled_last_src.y_stride;
    last_src_width := unscaled_last_src.y_width;
    last_src_height := unscaled_last_src.y_height;

    RC.high_source_sad = 0;
    RC.high_num_blocks_with_motion = 0;

    if cpi.svc.spatial_layer_id == cpi.svc.first_spatial_layer_to_encode &&
        src_width == last_src_width &&
        src_height == last_src_height {
        frames: [25] *YV12_BUFFER_CONFIG;
        num_mi_cols := CM.mi_cols;
        num_mi_rows := CM.mi_rows;
        start_frame: s32 = 0;
        frames_to_buffer: s32 = 1;
        frame: s32 = 0;
        scene_cut_force_key_frame: s32 = 0;
        num_zero_temp_sad: s32 = 0;
        avg_sad_current: u64 = 0;
        min_thresh: u32 = 20000;
        thresh: float32 = 8.0;
        thresh_key: u32 = 140000;
        if cpi.oxcf.speed <= 5 {
            thresh_key = 240000;
        }
        if cpi.oxcf.content != cast,no_check(u32) VP9E_CONTENT_SCREEN {
            min_thresh = 65000;
        }
        if cpi.oxcf.rc_mode == cast,no_check(u32) VBR {
            thresh = 2.1;
        }
        if cpi.use_svc != 0 && cpi.svc.number_spatial_layers > 1 {
            ALIGNED_WIDTH := (src_width + ((cast(s32) 1) << 3 - 1)) & ~((cast(s32) 1) << 3 - 1);
            ALIGNED_HEIGHT := (src_height + ((cast(s32) 1) << 3 - 1)) & ~((cast(s32) 1) << 3 - 1);
            num_mi_cols = ALIGNED_WIDTH >> 3;
            num_mi_rows = ALIGNED_HEIGHT >> 3;
        }
        if cpi.oxcf.lag_in_frames > 0 {
            frames_to_buffer =
                ifx CM.current_video_frame == 1 then (cast,no_check(s32) vp9_lookahead_depth(cpi.lookahead)) -
                    1 else 2;
            start_frame = (cast,no_check(s32) vp9_lookahead_depth(cpi.lookahead)) - 1;
            frame = 0;
            while frame < frames_to_buffer {
                LAGFRAME_IDX := start_frame - frame;
                if LAGFRAME_IDX >= 0 {
                    buf := vp9_lookahead_peek(cpi.lookahead, LAGFRAME_IDX);
                    frames[frame] = *buf.img;
                }
                frame += 1;
            }

            avg_sad_current = RC.avg_source_sad[1];
            if avg_sad_current > cast,no_check(u64) ((ifx min_thresh > cast,no_check(u32) (RC.avg_source_sad[0] * thresh) then min_thresh else cast,no_check(u32) (RC.avg_source_sad[0] * thresh))) &&
                CM.current_video_frame > cast,no_check(u32) cpi.oxcf.lag_in_frames {
                RC.high_source_sad = 1;
            } else {
                RC.high_source_sad = 0;
            }
            if RC.high_source_sad != 0 && avg_sad_current > cast,no_check(u64) thresh_key {
                scene_cut_force_key_frame = 1;
            }

            if avg_sad_current > 0 {
                RC.avg_source_sad[0] = (3 * RC.avg_source_sad[0] + avg_sad_current) >> 2;
            }

            frame = 1;
            while frame < cpi.oxcf.lag_in_frames - 1 {
                RC.avg_source_sad[frame] = RC.avg_source_sad[frame + 1];
                frame += 1;
            }
        }
        frame = 0;
        while frame < frames_to_buffer {
            if cpi.oxcf.lag_in_frames == 0 ||
                frames[frame] != null &&
                    frames[frame + 1] != null &&
                    frames[frame].y_width == frames[frame + 1].y_width &&
                    frames[frame].y_height == frames[frame + 1].y_height {
                sbi_col: s32 = ---;
                LAGFRAME_IDX := (ifx cpi.oxcf.lag_in_frames == 0 then 0 else start_frame - frame + 1);
                BSIZE: BLOCK_SIZE = 12;

                avg_sad: u64 = 0;
                tmp_sad: u64 = 0;
                num_samples: s32 = 0;
                sb_cols := (num_mi_cols + (cast(s32) 1) << (((6 - 3)) & 31) - 1) / (cast(s32) 1) << (((6 - 3)) & 31);
                sb_rows := (num_mi_rows + (cast(s32) 1) << (((6 - 3)) & 31) - 1) / (cast(s32) 1) << (((6 - 3)) & 31);
                if cpi.oxcf.lag_in_frames > 0 {
                    src_y = frames[frame].y_buffer;
                    src_ystride = frames[frame].y_stride;
                    last_src_y = frames[frame + 1].y_buffer;
                    last_src_ystride = frames[frame + 1].y_stride;
                }
                num_zero_temp_sad = 0;
                if 0 < sb_rows {
                    for sbi_row: 0..sb_rows - 1 {
                        sbi_col = 0;
                        while sbi_col < sb_cols {
                            if sbi_row > 0 &&
                                sbi_col > 0 &&
                                sbi_row < sb_rows - 1 &&
                                sbi_col < sb_cols - 1 &&
                                (sbi_row % 2 == 0 && sbi_col % 2 == 0 || sbi_row % 2 != 0 && sbi_col % 2 != 0) {
                                tmp_sad =
                                    cast,no_check(u64) cpi.fn_ptr[BSIZE].sdf(
                                        src_y,
                                        src_ystride,
                                        last_src_y,
                                        last_src_ystride
                                    );
                                avg_sad += tmp_sad;
                                num_samples += 1;
                                if tmp_sad == 0 {
                                    num_zero_temp_sad += 1;
                                }
                            }
                            src_y += 64;
                            last_src_y += 64;
                            sbi_col += 1;
                        }
                        src_y += src_ystride << 6 - sb_cols << 6;
                        last_src_y += last_src_ystride << 6 - sb_cols << 6;
                    }
                }
                if num_samples > 0 {
                    avg_sad = avg_sad / cast,no_check(u64) num_samples;
                }

                if LAGFRAME_IDX == 0 {
                    if avg_sad > cast,no_check(u64) ((ifx min_thresh > cast,no_check(u32) (RC.avg_source_sad[0] * thresh) then min_thresh else cast,no_check(u32) (RC.avg_source_sad[0] * thresh))) &&
                        RC.frames_since_key > 1 + cpi.svc.number_spatial_layers &&
                        num_zero_temp_sad < 3 * num_samples >> 2 {
                        RC.high_source_sad = 1;
                    } else {
                        RC.high_source_sad = 0;
                    }
                    if RC.high_source_sad != 0 && avg_sad > cast,no_check(u64) thresh_key {
                        scene_cut_force_key_frame = 1;
                    }
                    if avg_sad > 0 || cpi.oxcf.rc_mode == cast,no_check(u32) CBR {
                        RC.avg_source_sad[0] = (3 * RC.avg_source_sad[0] + avg_sad) >> 2;
                    }
                } else {
                    RC.avg_source_sad[LAGFRAME_IDX] = avg_sad;
                }
                if num_zero_temp_sad < (3 * num_samples) >> 2 {
                    RC.high_num_blocks_with_motion = 1;
                }
            }
            frame += 1;
        }

        if cpi.oxcf.rc_mode == cast,no_check(u32) CBR &&
            cpi.oxcf.content != cast,no_check(u32) VP9E_CONTENT_SCREEN &&
            cpi.use_svc == 0 {
            if RC.high_source_sad != 0 &&
                RC.last_q[INTER_FRAME] == RC.best_quality &&
                RC.avg_frame_qindex[INTER_FRAME] < RC.best_quality << 1 &&
                c_transpiler_float_equal(RC.rate_correction_factors[INTER_NORMAL], 0.005) {
                RC.rate_correction_factors[INTER_NORMAL] = 0.5;
                RC.avg_frame_qindex[INTER_FRAME] = RC.worst_quality;
                RC.buffer_level = RC.optimal_buffer_level;
                RC.bits_off_target = RC.optimal_buffer_level;
                RC.reset_high_source_sad = 1;
            }
            if CM.frame_type != cast,no_check(u32) KEY_FRAME && RC.reset_high_source_sad != 0 {
                RC.this_frame_target = RC.avg_frame_bandwidth;
            }
        }

        if cpi.use_svc != 0 {
            tl: s32 = ---;
            SVC_ := *cpi.svc;
            sl: s32 = 0;
            while sl < SVC_.number_spatial_layers {
                tl = 0;
                while tl < SVC_.number_temporal_layers {
                    layer := sl * SVC_.number_temporal_layers + tl;
                    LC := SVC_.layer_context.data + layer;
                    LRC := *LC.rc;
                    LRC.avg_source_sad[0] = RC.avg_source_sad[0];
                    tl += 1;
                }
                sl += 1;
            }
        }

        if cpi.oxcf.rc_mode == cast,no_check(u32) VBR &&
            CM.frame_type != cast,no_check(u32) KEY_FRAME &&
            RC.high_source_sad != 0 &&
            RC.frames_to_key > 3 &&
            RC.count_last_scene_change > 4 &&
            cpi.ext_refresh_frame_flags_pending == 0 {
            cpi.refresh_golden_frame = 1;
            if scene_cut_force_key_frame != 0 {
                CM.frame_type = cast,no_check(FRAME_TYPE) KEY_FRAME;
            }
            RC.source_alt_ref_pending = 0;
            if cpi.sf.use_altref_onepass != 0 && cpi.oxcf.enable_auto_arf != 0 {
                RC.source_alt_ref_pending = 1;
            }
            RC.gfu_boost = (cast(s32) 2000) >> 1;
            RC.baseline_gf_interval =
                ifx 20 < (ifx 10 > RC.baseline_gf_interval then 10 else RC.baseline_gf_interval) then 20 else (ifx 10 > RC.baseline_gf_interval then 10 else RC.baseline_gf_interval);
            adjust_gfint_frame_constraint(cpi, RC.frames_to_key);
            RC.frames_till_gf_update_due = RC.baseline_gf_interval;
            target := vp9_calc_pframe_target_size_one_pass_vbr(cpi);
            vp9_rc_set_frame_target(cpi, target);
            RC.count_last_scene_change = 0;
        } else {
            RC.count_last_scene_change += 1;
        }

        if cpi.oxcf.lag_in_frames > 0 {
            adjust_gf_boost_lag_one_pass_vbr(cpi, avg_sad_current);
        }
    }
}

adjust_gf_boost_lag_one_pass_vbr :: (cpi: *VP9_COMP_in_vp9_encoder, avg_sad_current: u64) {
    CM := *cpi.common;
    RC := *cpi.rc;
    target: s32 = ---;
    found: s32 = 0;
    found2: s32 = 0;

    i: s32 = ---;
    avg_source_sad_lag := avg_sad_current;
    high_source_sad_lagindex: s32 = -1;
    steady_sad_lagindex: s32 = -1;
    sad_thresh1: u32 = 70000;
    sad_thresh2: u32 = 120000;
    low_content: s32 = 0;
    high_content: s32 = 0;
    rate_err: float64 = 1.0;

    tot_frames := (cast,no_check(s32) vp9_lookahead_depth(cpi.lookahead)) - 1;
    frame := tot_frames;
    while frame >= 1 {
        LAGFRAME_IDX := tot_frames - frame + 1;
        reference_sad := RC.avg_source_sad[0];
        i = 1;
        while i < LAGFRAME_IDX {
            if RC.avg_source_sad[i] > 0 {
                reference_sad = (3 * reference_sad + RC.avg_source_sad[i]) >> 2;
            }
            i += 1;
        }

        if found == 0 &&
            (RC.avg_source_sad[LAGFRAME_IDX] > cast,no_check(u64) ((ifx sad_thresh1 > cast,no_check(u32) (reference_sad << 1) then sad_thresh1 else cast,no_check(u32) (reference_sad << 1))) ||
                RC.avg_source_sad[LAGFRAME_IDX] > cast,no_check(u64) ((ifx (3 * sad_thresh1) >> 2 > cast,no_check(u32) (reference_sad << 2) then (3 * sad_thresh1) >> 2 else cast,no_check(u32) (reference_sad << 2)))) {
            high_source_sad_lagindex = LAGFRAME_IDX;
            found = 1;
        }

        if found2 == 0 &&
            LAGFRAME_IDX > 1 &&
            LAGFRAME_IDX < tot_frames &&
            RC.avg_source_sad[LAGFRAME_IDX - 1] > cast,no_check(u64) (sad_thresh1 >> 2) {
            found2 = 1;
            i = LAGFRAME_IDX;
            while i < tot_frames {
                if !(RC.avg_source_sad[i] > 0 && RC.avg_source_sad[i] < cast,no_check(u64) (sad_thresh1 >> 2) && RC.avg_source_sad[i] < RC.avg_source_sad[LAGFRAME_IDX - 1] >> 1) {
                    found2 = 0;
                    i = tot_frames;
                }
                i += 1;
            }
            if found2 != 0 {
                steady_sad_lagindex = LAGFRAME_IDX;
            }
        }
        avg_source_sad_lag += RC.avg_source_sad[LAGFRAME_IDX];
        frame -= 1;
    }
    if tot_frames > 0 {
        avg_source_sad_lag = avg_source_sad_lag / cast,no_check(u64) tot_frames;
    }

    if high_source_sad_lagindex != -1 &&
        high_source_sad_lagindex != RC.high_source_sad_lagindex - 1 &&
        absolute_value(high_source_sad_lagindex - RC.high_source_sad_lagindex) < 4 {
        RC.high_source_sad_lagindex = -1;
    } else {
        RC.high_source_sad_lagindex = high_source_sad_lagindex;
    }

    if cpi.refresh_golden_frame == 1 && CM.current_video_frame > 30 && cpi.oxcf.lag_in_frames > 8 {
        if RC.rolling_target_bits > 0 {
            rate_err = (cast,no_check(float64) RC.rolling_actual_bits) / cast,no_check(float64) RC.rolling_target_bits;
        }
        high_content =
            cast(s32) (high_source_sad_lagindex != -1 || avg_source_sad_lag > RC.prev_avg_source_sad_lag << 1 ||
                avg_source_sad_lag > cast,no_check(u64) sad_thresh2);
        low_content =
            cast(s32) (high_source_sad_lagindex == -1 &&
                (avg_source_sad_lag < RC.prev_avg_source_sad_lag >> 1 || avg_source_sad_lag < cast,no_check(u64) sad_thresh1));
        if low_content != 0 {
            RC.gfu_boost = 2000;
            RC.baseline_gf_interval =
                ifx 15 < (3 * RC.baseline_gf_interval) >> 1 then 15 else (3 *
                    RC.baseline_gf_interval) >> 1;
        } else if high_content != 0 {
            RC.gfu_boost = (cast(s32) 2000) >> 1;
            RC.baseline_gf_interval =
                ifx c_transpiler_float_greater(rate_err, 3.0) then (ifx 10 > RC.baseline_gf_interval >> 1 then 10 else RC.baseline_gf_interval >> 1) else (ifx 6 > RC.baseline_gf_interval >> 1 then 6 else RC.baseline_gf_interval >> 1);
        }
        if RC.baseline_gf_interval > cpi.oxcf.lag_in_frames - 1 {
            RC.baseline_gf_interval = cpi.oxcf.lag_in_frames - 1;
        }

        frame_constraint := RC.frames_to_key;
        if RC.high_source_sad_lagindex > 0 && frame_constraint > RC.high_source_sad_lagindex {
            frame_constraint = RC.high_source_sad_lagindex;
        }
        if steady_sad_lagindex > 3 && frame_constraint > steady_sad_lagindex {
            frame_constraint = steady_sad_lagindex;
        }
        adjust_gfint_frame_constraint(cpi, frame_constraint);
        RC.frames_till_gf_update_due = RC.baseline_gf_interval;

        RC.fac_active_worst_inter = 150;
        RC.fac_active_worst_gf = 100;
        if c_transpiler_float_less(rate_err, 2.0) && high_content == 0 {
            RC.fac_active_worst_inter = 120;
            RC.fac_active_worst_gf = 90;
        } else if c_transpiler_float_greater(rate_err, 8.0) && RC.avg_frame_qindex[INTER_FRAME] < 16 {
            RC.fac_active_worst_inter = 200;
            if RC.avg_frame_qindex[INTER_FRAME] < 8 {
                RC.fac_active_worst_inter = 400;
            }
        }
        if low_content != 0 && RC.avg_frame_low_motion > 80 {
            RC.af_ratio_onepass_vbr = 15;
        } else if high_content != 0 || RC.avg_frame_low_motion < 30 {
            RC.af_ratio_onepass_vbr = 5;
            RC.gfu_boost = (cast(s32) 2000) >> 2;
        }
        if cpi.sf.use_altref_onepass != 0 && cpi.oxcf.enable_auto_arf != 0 {
            arf_usage_low :=
                cast(s32) (CM.frame_type != cast,no_check(u32) KEY_FRAME && RC.high_source_sad == 0 &&
                    c_transpiler_float_less(cpi.rc.perc_arf_usage, 15.0) && cpi.oxcf.speed >= 5);

            if arf_usage_low != 0 ||
                RC.high_source_sad_lagindex > 0 && RC.high_source_sad_lagindex <= RC.frames_till_gf_update_due ||
                avg_source_sad_lag > cast,no_check(u64) ((3 * sad_thresh1) >> 3) {
                RC.source_alt_ref_pending = 0;
                RC.alt_ref_gf_group = 0;
            } else {
                RC.source_alt_ref_pending = 1;
                RC.alt_ref_gf_group = 1;

                if RC.baseline_gf_interval > 12 {
                    RC.baseline_gf_interval = 12;
                    RC.frames_till_gf_update_due = RC.baseline_gf_interval;
                }
            }
        }
        target = vp9_calc_pframe_target_size_one_pass_vbr(cpi);
        vp9_rc_set_frame_target(cpi, target);
    }
    RC.prev_avg_source_sad_lag = avg_source_sad_lag;
}

vp9_encodedframe_overshoot :: (cpi: *VP9_COMP_in_vp9_encoder, frame_size: s32, q: *s32) -> s32 {
    CM := *cpi.common;
    RC := *cpi.rc;
    SF := *cpi.sf;
    thresh_qp := 7 * RC.worst_quality >> 3;
    thresh_rate := RC.avg_frame_bandwidth << 3;

    if cpi.oxcf.content != cast,no_check(u32) VP9E_CONTENT_SCREEN {
        thresh_qp = 3 * RC.worst_quality >> 2;
    }

    if (SF.overshoot_detection_cbr_rt == cast,no_check(u32) FAST_DETECTION_MAXQ || frame_size > thresh_rate) &&
        CM.base_qindex < thresh_qp {
        rate_correction_factor := cpi.rc.rate_correction_factors[INTER_NORMAL];
        TARGET_SIZE := cpi.rc.avg_frame_bandwidth;
        SAD_THR: u64 = cast,no_check(u64) ((cast,no_check(s32) ((64 * 64))) * 32);
        force_maxqp: s32 = 1;

        if cpi.oxcf.content != cast,no_check(u32) VP9E_CONTENT_SCREEN &&
            RC.buffer_level > (3 * RC.optimal_buffer_level) >> 2 &&
            cpi.rc.avg_source_sad[0] < SAD_THR {
            q.* = (q.* + cpi.rc.worst_quality) >> 1;
            force_maxqp = 0;
        } else {
            q.* = cpi.rc.worst_quality;
        }
        cpi.cyclic_refresh.counter_encode_maxq_scene_change = 0;
        cpi.rc.re_encode_maxq_scene_change = 1;

        if SF.overshoot_detection_cbr_rt == cast,no_check(u32) RE_ENCODE_MAXQ &&
            frame_size > thresh_rate << 1 &&
            cpi.svc.spatial_layer_id == 0 {
            mi := CM.mi_grid_visible;
            sum_intra_usage: s32 = 0;
            mi_col: s32 = ---;
            mi_row: s32 = 0;
            while mi_row < CM.mi_rows {
                mi_col = 0;
                while mi_col < CM.mi_cols {
                    if mi[0].ref_frame[0] == 0 {
                        sum_intra_usage += 1;
                    }
                    mi += 1;
                    mi_col += 1;
                }
                mi += 8;
                mi_row += 1;
            }
            sum_intra_usage = 100 * sum_intra_usage / (CM.mi_rows * CM.mi_cols);
            if sum_intra_usage > 60 {
                cpi.rc.hybrid_intra_scene_change = 1;
            }
        }

        cpi.rc.avg_frame_qindex[INTER_FRAME] = q.*;
        RC.buffer_level = RC.optimal_buffer_level;
        RC.bits_off_target = RC.optimal_buffer_level;

        cpi.rc.rc_1_frame = 0;
        cpi.rc.rc_2_frame = 0;

        target_bits_per_mb := cast,no_check(s32) ((cast,no_check(u64) TARGET_SIZE) << 9 / cast,no_check(u64) CM.m_bs);

        q2 := vp9_convert_qindex_to_q(q.*, CM.bit_depth);
        enumerator: s32 = 1800000;
        enumerator += (cast,no_check(s32) (enumerator * q2)) >> 12;
        new_correction_factor := (cast,no_check(float64) target_bits_per_mb) * q2 / enumerator;
        if c_transpiler_float_greater(new_correction_factor, rate_correction_factor) {
            rate_correction_factor =
                ifx c_transpiler_float_less((2.0 * rate_correction_factor), new_correction_factor) then 2.0 *
                    rate_correction_factor else new_correction_factor;
            if c_transpiler_float_greater(rate_correction_factor, 50.0) {
                rate_correction_factor = 50.0;
            }
            cpi.rc.rate_correction_factors[INTER_NORMAL] = rate_correction_factor;
        }

        if cpi.use_svc != 0 {
            tl: s32 = 0;
            sl: s32 = 0;
            svc := *cpi.svc;
            num_spatial_layers :=
                (ifx 1 > svc.first_spatial_layer_to_encode then 1 else svc.first_spatial_layer_to_encode);
            if svc.disable_inter_layer_pred != cast,no_check(u32) INTER_LAYER_PRED_ON {
                num_spatial_layers = svc.number_spatial_layers;
            }
            sl = 0;
            while sl < num_spatial_layers {
                tl = 0;
                while tl < svc.number_temporal_layers {
                    LAYER := sl * svc.number_temporal_layers + tl;
                    lc := svc.layer_context.data + LAYER;
                    lrc := *lc.rc;
                    lrc.avg_frame_qindex[INTER_FRAME] = q.*;
                    lrc.buffer_level = lrc.optimal_buffer_level;
                    lrc.bits_off_target = lrc.optimal_buffer_level;
                    lrc.rc_1_frame = 0;
                    lrc.rc_2_frame = 0;
                    lrc.rate_correction_factors[INTER_NORMAL] = rate_correction_factor;
                    lrc.force_max_q = force_maxqp;
                    tl += 1;
                }
                sl += 1;
            }
        }
        return 1;
    } else {
        return 0;
    }
}

vp9_configure_buffer_updates :: (cpi: *VP9_COMP_in_vp9_encoder, gf_group_index: s32) {
    cm := *cpi.common;
    TWOPASS := *cpi.twopass;

    cpi.rc.is_src_frame_alt_ref = 0;
    cm.show_existing_frame = 0;
    cpi.rc.show_arf_as_gld = 0;
    if TWOPASS.gf_group.update_type[gf_group_index] == {
        case cast,no_check(u32) KF_UPDATE;
            cpi.refresh_last_frame = 1;
            cpi.refresh_golden_frame = 1;
            cpi.refresh_alt_ref_frame = 1;
        case cast,no_check(u32) LF_UPDATE;
            cpi.refresh_last_frame = 1;
            cpi.refresh_golden_frame = 0;
            cpi.refresh_alt_ref_frame = 0;
        case cast,no_check(u32) GF_UPDATE;
            cpi.refresh_last_frame = 1;
            cpi.refresh_golden_frame = 1;
            cpi.refresh_alt_ref_frame = 0;
        case cast,no_check(u32) OVERLAY_UPDATE;
            cpi.refresh_last_frame = 0;
            cpi.refresh_golden_frame = 1;
            cpi.refresh_alt_ref_frame = 0;
            cpi.rc.is_src_frame_alt_ref = 1;
            if cpi.rc.preserve_arf_as_gld != 0 {
                cpi.rc.show_arf_as_gld = 1;
                cpi.refresh_golden_frame = 0;
                cm.show_existing_frame = 1;
                cm.refresh_frame_context = 0;
            }
        case cast,no_check(u32) MID_OVERLAY_UPDATE;
            cpi.refresh_last_frame = 1;
            cpi.refresh_golden_frame = 0;
            cpi.refresh_alt_ref_frame = 0;
            cpi.rc.is_src_frame_alt_ref = 1;
        case cast,no_check(u32) USE_BUF_FRAME;
            cpi.refresh_last_frame = 0;
            cpi.refresh_golden_frame = 0;
            cpi.refresh_alt_ref_frame = 0;
            cpi.rc.is_src_frame_alt_ref = 1;
            cm.show_existing_frame = 1;
            cm.refresh_frame_context = 0;
        case;
            cpi.refresh_last_frame = 0;
            cpi.refresh_golden_frame = 0;
            cpi.refresh_alt_ref_frame = 1;
    }
}

vp9_compute_frame_low_motion :: (CPI: *VP9_COMP_in_vp9_encoder) {
    CM := *CPI.common;
    SVC_ := *CPI.svc;
    mi_col: s32 = ---;
    mi := CM.mi_grid_visible;
    RC := *CPI.rc;
    ROWS := CM.mi_rows;
    COLS := CM.mi_cols;
    cnt_zeromv: s32 = 0;
    if 0 < ROWS {
        for mi_row: 0..ROWS - 1 {
            mi_col = 0;
            while mi_col < COLS {
                if mi[0].ref_frame[0] == 1 &&
                    absolute_value(cast,no_check(s32) mi[0].mv[0].as_mv.row) < 16 &&
                    absolute_value(cast,no_check(s32) mi[0].mv[0].as_mv.col) < 16 {
                    cnt_zeromv += 1;
                }
                mi += 1;
                mi_col += 1;
            }
            mi += 8;
        }
    }
    cnt_zeromv = 100 * cnt_zeromv / (ROWS * COLS);
    RC.avg_frame_low_motion = (3 * RC.avg_frame_low_motion + cnt_zeromv) >> 2;

    if CPI.use_svc != 0 && SVC_.spatial_layer_id == SVC_.number_spatial_layers - 1 {
        i: s32 = 0;
        while i < SVC_.number_spatial_layers - 1 {
            LAYER := i * SVC_.number_temporal_layers + SVC_.temporal_layer_id;
            LC := SVC_.layer_context.data + LAYER;
            LRC := *LC.rc;
            LRC.avg_frame_low_motion = RC.avg_frame_low_motion;
            i += 1;
        }
    }
}

fps_init_first_pass_info_in_vp9_ratectrl :: (
    first_pass_info: *FIRST_PASS_INFO,
    stats: *FIRSTPASS_STATS_in_vp9_cx_iface,
    num_frames: s32
) {
    first_pass_info.stats = stats;
    first_pass_info.num_frames = num_frames;
}

fps_get_num_frames_in_vp9_ratectrl :: (first_pass_info: *FIRST_PASS_INFO) -> s32 {
    return first_pass_info.num_frames;
}

fps_get_frame_stats_in_vp9_ratectrl :: (
    first_pass_info: *FIRST_PASS_INFO,
    show_idx: s32
) -> *FIRSTPASS_STATS_in_vp9_cx_iface {
    if show_idx < 0 || show_idx >= first_pass_info.num_frames {
        return null;
    }
    return *(cast(*FIRSTPASS_STATS_in_vp9_cx_iface) (first_pass_info.stats))[show_idx];
}

get_buf_from_mv_in_vp9_ratectrl :: (buf: *Buf_2d, mv: *MV) -> *u8 {
    return *buf.buf[(cast(s32) mv.row) * buf.stride + cast(s32) mv.col];
}

cost_branch256_in_vp9_ratectrl :: (ct: *u32, p: Prob) -> u64 {
    return ((cast,no_check(u64) ct[0]) * cast(u64) VP9_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP9_PROB_COST[256 - cast(s32) p];
}

treed_cost_in_vp9_ratectrl :: (tree: *Tree_Index, probs: *Prob, bits: s32, len: s32) -> s32 {
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

rd_less_than_thresh_in_vp9_ratectrl :: (best_rd: s64, thresh: s32, THRESH_FACT: *s32) -> s32 {
    if best_rd < ((cast,no_check(s64) thresh) * cast(s64) THRESH_FACT.*) >> 5 || thresh == 2147483647 {
        return 1;
    }
    return 0;
}

set_error_per_bit_in_vp9_ratectrl :: (x: *MACROBLOCK, rdmult: s32) {
    x.errorperbit = rdmult >> 6;
    x.errorperbit += cast(s32) (x.errorperbit == 0);
}

write_in_vp9_ratectrl :: (br: *Writer, bit: s32, probability: s32) {
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

write_bit_in_vp9_ratectrl :: (w: *Writer, bit: s32) {
    write_in_vp9_ratectrl(w, bit, 128);
}

write_literal_in_vp9_ratectrl :: (w: *Writer, data: s32, bits: s32) {
    bit := bits - 1;
    while bit >= 0 {
        write_bit_in_vp9_ratectrl(w, 1 & (data >> ((bit) & 31)));
        bit -= 1;
    }
}

vp9_write_tree_in_vp9_ratectrl :: (w: *Writer, tree: *Tree_Index, probs: *Prob, bits: s32, len: s32, i: Tree_Index) {
    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            write_in_vp9_ratectrl(w, BIT, cast,no_check(s32) probs[(cast(s32) i) >> 1]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }
}

vp9_write_token_in_vp9_ratectrl :: (w: *Writer, tree: *Tree_Index, probs: *Prob, token: *Vp9_Token) {
    vp9_write_tree_in_vp9_ratectrl(w, tree, probs, token.value, token.len, 0);
}

vp9_get_high_cost_table_in_vp9_ratectrl :: (bit_depth: s32) -> *u16 {
    return VP9_CAT6_HIGH_COST.data;
}

vp9_get_token_extra_in_vp9_ratectrl :: (v: s32, token: *s16, extra: *EXTRABIT) {
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

vp9_get_token_in_vp9_ratectrl :: (v: s32) -> s16 {
    if v >= 67 || v <= -67 {
        return 10;
    }
    return vp9_dct_cat_lt_10_value_tokens[v].token;
}

vp9_get_token_cost_in_vp9_ratectrl :: (v: s32, token: *s16, cat6_high_table: *u16) -> s32 {
    if v >= 67 || v <= -67 {
        token.* = 10;
        extrabits := cast,no_check(EXTRABIT) (absolute_value(v) - 67);
        return (cast(s32) VP9_CAT6_LOW_COST[extrabits & 0xff]) + cast(s32) cat6_high_table[(cast(s32) extrabits) >> 8];
    }
    token.* = vp9_dct_cat_lt_10_value_tokens[v].token;
    return vp9_dct_cat_lt_10_value_cost[v];
}

is_lossless_requested_in_vp9_ratectrl :: (cfg: *VP9_Encoder_Config) -> s32 {
    if cfg.best_allowed_q == 0 && cfg.worst_allowed_q == 0 {
        return 1;
    }
    return 0;
}

stack_pop_in_vp9_ratectrl :: (stack: *s32, stack_size: s32) -> s32 {
    R := stack[0];
    if 1 < stack_size {
        for idx: 1..stack_size - 1 {
            stack[idx - 1] = stack[idx];
        }
    }

    return R;
}

stack_top_in_vp9_ratectrl :: (stack: *s32) -> s32 {
    return stack[0];
}

stack_push_in_vp9_ratectrl :: (stack: *s32, new_item: s32, stack_size: s32) {
    idx := stack_size;
    while idx > 0 {
        stack[idx] = stack[idx - 1];
        idx -= 1;
    }
    stack[0] = new_item;
}

stack_init_in_vp9_ratectrl :: (stack: *s32, length: s32) {
    if 0 < length {
        for idx: 0..length - 1 {
            stack[idx] = -1;
        }
    }
}

ref_frame_to_flag_in_vp9_ratectrl :: (ref_frame: s8) -> s32 {

    return K_VP9_REF_FLAG_LIST_in_vp9_ratectrl[ref_frame];
}

get_ref_frame_map_idx_in_vp9_ratectrl :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame: MV_REFERENCE_FRAME) -> s32 {
    if ref_frame == 1 {
        return cpi.lst_fb_idx;
    } else if ref_frame == 2 {
        return cpi.gld_fb_idx;
    } else {
        return cpi.alt_fb_idx;
    }
}

get_ref_frame_buf_idx_in_vp9_ratectrl :: (CPI: *VP9_COMP_in_vp9_encoder, ref_frame: s32) -> s32 {
    CM := *CPI.common;
    MAP_IDX := get_ref_frame_map_idx_in_vp9_ratectrl(CPI, cast,no_check(MV_REFERENCE_FRAME) ref_frame);
    return ifx MAP_IDX != -1 then CM.ref_frame_map[MAP_IDX] else -1;
}

get_ref_cnt_buffer_in_vp9_ratectrl :: (cm: *VP9_COMMON, fb_idx: s32) -> *Ref_Cnt_Buffer {
    return ifx fb_idx != -1 then cm.buffer_pool.frame_bufs.data + fb_idx else null;
}

get_ref_frame_bufs_in_vp9_ratectrl :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame_bufs: **Ref_Cnt_Buffer) {
    CM := *cpi.common;

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame < 4 {
        ref_frame_buf_idx := get_ref_frame_buf_idx_in_vp9_ratectrl(cpi, cast,no_check(s32) ref_frame);
        inter_ref_idx := mv_ref_frame_to_inter_ref_idx_in_vp9_ratectrl(ref_frame);
        ref_frame_bufs[inter_ref_idx] = get_ref_cnt_buffer_in_vp9_ratectrl(CM, ref_frame_buf_idx);
        ref_frame += 1;
    }
}

get_ref_frame_buffer_in_vp9_ratectrl :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    ref_frame: MV_REFERENCE_FRAME
) -> *YV12_BUFFER_CONFIG {
    CM := *CPI.common;
    BUF_IDX := get_ref_frame_buf_idx_in_vp9_ratectrl(CPI, cast,no_check(s32) ref_frame);
    return ifx BUF_IDX != -1 then *CM.buffer_pool.frame_bufs[BUF_IDX].buf else null;
}

get_token_alloc_in_vp9_ratectrl :: (mb_rows: s32, mb_cols: s32) -> s64 {
    ALIGNED_MB_ROWS :=
        (mb_rows +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    ALIGNED_MB_COLS :=
        (mb_cols +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    return ((cast,no_check(s64) ALIGNED_MB_ROWS) * cast(s64) ALIGNED_MB_COLS) * cast,no_check(s64) ((cast,no_check(s32) ((16 * 16))) * 3 + 4);
}

allocated_tokens_in_vp9_ratectrl :: (tile: Tile_Info) -> s64 {
    tile_mb_rows := (tile.mi_row_end - tile.mi_row_start + 1) >> 1;
    tile_mb_cols := (tile.mi_col_end - tile.mi_col_start + 1) >> 1;

    return get_token_alloc_in_vp9_ratectrl(tile_mb_rows, tile_mb_cols);
}

get_start_tok_in_vp9_ratectrl :: (
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

    tok.* = cpi.tile_tok[tile_row][tile_col] + get_token_alloc_in_vp9_ratectrl(MB_ROW, tile_mb_cols);
}

set_ref_ptrs_in_vp9_ratectrl :: (
    CM: *VP9_COMMON,
    xd: *MACROBLOCKD,
    ref0: MV_REFERENCE_FRAME,
    ref1: MV_REFERENCE_FRAME
) {
    xd.block_refs[0] = CM.frame_refs.data + (ifx ref0 >= 1 then (cast(s32) ref0) - 1 else 0);
    xd.block_refs[1] = CM.frame_refs.data + (ifx ref1 >= 1 then (cast(s32) ref1) - 1 else 0);
}

get_chessboard_index_in_vp9_ratectrl :: (FRAME_INDEX: s32) -> s32 {
    return FRAME_INDEX & 0x1;
}

cond_cost_list_in_vp9_ratectrl :: (cpi: *VP9_COMP_in_vp9_encoder, cost_list: *s32) -> *s32 {
    return ifx cpi.sf.mv.subpel_search_method != cast,no_check(u32) SUBPEL_TREE then cost_list else null;
}

get_num_vert_units_in_vp9_ratectrl :: (tile: Tile_Info, shift: s32) -> s32 {
    num_vert_units := (tile.mi_row_end - tile.mi_row_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_vert_units;
}

get_num_cols_in_vp9_ratectrl :: (tile: Tile_Info, shift: s32) -> s32 {
    num_cols := (tile.mi_col_end - tile.mi_col_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_cols;
}

get_level_index_in_vp9_ratectrl :: (level: VP9_LEVEL) -> s32 {
    for i: 0..cast(s32) 14 - 1 {
        if level == VP9_LEVEL_DEFS[i].level {
            return i;
        }
    }
    return -1;
}

log_tile_cols_from_picsize_level_in_vp9_ratectrl :: (width: u32, height: u32) -> s32 {
    PIC_SIZE := width * height;
    PIC_BREADTH := max(width, height);
    for i: 0..cast(s32) 14 - 1 {
        if VP9_LEVEL_DEFS[i].max_luma_picture_size >= PIC_SIZE && VP9_LEVEL_DEFS[i].max_luma_picture_breadth >= PIC_BREADTH {
            return get_msb_in_vp9_ratectrl(cast,no_check(u32) VP9_LEVEL_DEFS[i].max_col_tiles);
        }
    }
    return 2147483647;
}

alloc_frame_mvs_in_vp9_ratectrl :: (CM: *VP9_COMMON, buffer_idx: s32) {
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

mv_cost_in_vp9_ratectrl :: (mv: *MV, joint_cost: *s32, comp_cost: **s32) -> s32 {
    return joint_cost[vp9_get_mv_joint_in_vp9_ratectrl(mv)] + comp_cost[0][mv.row] + comp_cost[1][mv.col];
}

mvsad_err_cost_in_vp9_ratectrl :: (x: *MACROBLOCK, mv: *MV, ref: *MV, sad_per_bit: s32) -> s32 {
    diff: MV = ---;
    diff.row = cast,no_check(s16) ((cast(s32) mv.row) - cast(s32) ref.row);
    diff.col = cast,no_check(s16) ((cast(s32) mv.col) - cast(s32) ref.col);
    return cast,no_check(s32) ((((cast,no_check(u32) mv_cost_in_vp9_ratectrl(*diff, x.nmvjointsadcost.data, x.nmvsadcost.data)) * cast,no_check(u32) sad_per_bit) + cast,no_check(u32) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9);
}

get_start_mv_sad_in_vp9_ratectrl :: (
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
    start_mv_sad += cast,no_check(u32) mvsad_err_cost_in_vp9_ratectrl(x, mvp_full, ref_mv_full, sadpb);

    return start_mv_sad;
}

num_4x4_to_edge_in_vp9_ratectrl :: (
    plane_4x4_dim: s32,
    mb_to_edge_dim: s32,
    subsampling_dim: s32,
    blk_dim: s32
) -> s32 {
    return plane_4x4_dim + mb_to_edge_dim >> (((5 + subsampling_dim)) & 31) - blk_dim;
}

sum_squares_visible_in_vp9_ratectrl :: (
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
        num_4x4_to_edge_in_vp9_ratectrl(
            PLANE_4X4_W,
            xd.mb_to_right_edge,
            PD.subsampling_x,
            blk_col
        );
    B4X4S_TO_BOTTOM_EDGE :=
        num_4x4_to_edge_in_vp9_ratectrl(
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

do_trellis_opt_in_vp9_ratectrl :: (
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
                    sum_squares_visible_in_vp9_ratectrl(
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

globals_initialization_state_for_vp9_ratectrl: u32;
initialize_globals_for_vp9_ratectrl :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_ratectrl);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_ratectrl, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_ratectrl) != 2 {}
            return;
        }
    }
    K_VP9_REF_FLAG_LIST_in_vp9_ratectrl =
        s32.[ 0, cast,no_check(s32) (VP9_LAST_FLAG), cast,no_check(s32) (VP9_GOLD_FLAG), cast,no_check(s32) (VP9_ALT_FLAG) ];
    COUNT_TO_UPDATE_FACTOR_in_vp9_ratectrl =
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
    SUB_PEL_FILTERS_12_in_vp9_ratectrl =
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
    FRAME_SCALE_FACTOR_in_vp9_ratectrl = s32.[ 16, 24 ];
    RATE_THRESH_MULT_in_vp9_ratectrl = float64.[ 1.0, 2.0 ];
    RCF_MULT_in_vp9_ratectrl = float64.[ 1.0, 2.0 ];
    gf_high = 2000;
    gf_low = 400;
    kf_high = 4800;
    kf_low = 300;
    FACTOR_SAFE = 165888000.0;
    CQ_ADJUST_THRESHOLD_storage = 0.1;
    CQ_ADJUST_THRESHOLD = 0.1;
    RATE_FACTOR_DELTAS =
        float64.[
            1.0,
            1.0,
            1.5,
            1.75,
            2.0
        ];
    KF_RATIO = 25;
    atomic_store(*globals_initialization_state_for_vp9_ratectrl, 2);
}

RESIZE_ACTION :: s32;
NO_RESIZE : s32 : 0;
DOWN_THREEFOUR : s32 : 1;
DOWN_ONEHALF : s32 : 2;
UP_THREEFOUR : s32 : -1;
UP_ORIG : s32 : -2;

