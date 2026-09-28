// Generated directly from C by cpp_transpiler.
SUB_PEL_FILTERS_12_in_vp9_mvref_common: [16] Interp_Kernel12 #align 256;

COUNT_TO_UPDATE_FACTOR_in_vp9_mvref_common: [21] s32;

MODE_2_COUNTER: [14] s32;

COUNTER_TO_CONTEXT: [19] s32;

MV_REF_BLOCKS: [13] [8] POSITION;

IDX_N_COLUMN_TO_SUBBLOCK: [4] [2] s32;

clip_pixel_in_vp9_mvref_common :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_mvref_common :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_mvref_common :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_mvref_common :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_mvref_common :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_mvref_common(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_mvref_common(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_mvref_common(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_mvref_common :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_lsb_in_vp9_mvref_common :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_mvref_common :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_mvref_common :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_mvref_common(num_values) + 1 else 0;
}

get_filter_taps_in_vp9_mvref_common :: (FILTER: *s16) -> s32 {
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

get_prob_in_vp9_mvref_common :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_mvref_common :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_mvref_common(n0, DEN);
}

weighted_prob_in_vp9_mvref_common :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_mvref_common :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_mvref_common(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_mvref_common(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_mvref_common :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_mvref_common[COUNT];
        PROB := get_prob_in_vp9_mvref_common(ct[0], DEN);
        return weighted_prob_in_vp9_mvref_common(
            cast,no_check(s32) pre_prob,
            cast,no_check(s32) PROB,
            cast,no_check(s32) FACTOR
        );
    }
}

get_band_translate_in_vp9_mvref_common :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_mvref_common :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_mvref_common :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_mvref_common(above_ec, left_ec);
}

is_zero_mv_in_vp9_mvref_common :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_mvref_common :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_mvref_common :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_mvref_common(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_mvref_common(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_mvref_common :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_mvref_common :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_mvref_common :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_mvref_common :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

vp9_is_valid_scale_in_vp9_mvref_common :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_mvref_common :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_mvref_common(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_mvref_common :: (
    ref_width: s32,
    ref_height: s32,
    this_width: s32,
    this_height: s32
) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_mvref_common :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_mvref_common :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_mvref_common :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_mvref_common :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_mvref_common :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_mvref_common :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_mvref_common :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_mvref_common :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_mvref_common :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_mvref_common :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_mvref_common(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_mvref_common :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_mvref_common(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_mvref_common(MI, ib)];
}

get_uv_tx_size_in_vp9_mvref_common :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_mvref_common :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_mvref_common :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_mvref_common(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_mvref_common :: (
    mi: *MODE_INFO,
    above_mi: *MODE_INFO,
    left_mi: *MODE_INFO,
    block: s32
) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_mvref_common :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_mvref_common :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_mvref_common :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_mvref_common :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_mvref_common :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_mvref_common :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_mvref_common :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_mvref_common :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_mvref_common :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_mvref_common :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_mvref_common :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_mvref_common :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_mvref_common(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_mvref_common :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_mvref_common(cm.mi_cols);

        if get_plane_type_in_vp9_mvref_common(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_mvref_common(cm, xd);
}

get_partition_probs_in_vp9_mvref_common :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_mvref_common :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_mvref_common :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_mvref_common :: (
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

update_partition_context_in_vp9_mvref_common :: (
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

partition_plane_context_in_vp9_mvref_common :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

clamp_mv_ref :: (mv: *MV, xd: *MACROBLOCKD) {
    clamp_mv_in_vp9_mvref_common(
        mv,
        xd.mb_to_left_edge - (cast(s32) 16) << 3,
        xd.mb_to_right_edge + (cast(s32) 16) << 3,
        xd.mb_to_top_edge - (cast(s32) 16) << 3,
        xd.mb_to_bottom_edge + (cast(s32) 16) << 3
    );
}

get_sub_block_mv :: (candidate: *MODE_INFO, which_mv: s32, search_col: s32, block_idx: s32) -> Int_Mv {
    return ifx block_idx >= 0 && candidate.sb_type < 3 then candidate.bmi[IDX_N_COLUMN_TO_SUBBLOCK[block_idx][cast(s32) (search_col == 0)]].as_mv[which_mv] else candidate.mv[which_mv];
}

scale_mv :: (mi: *MODE_INFO, ref: s32, THIS_REF_FRAME: MV_REFERENCE_FRAME, ref_sign_bias: *s32) -> Int_Mv {
    mv := mi.mv[ref];
    if ref_sign_bias[mi.ref_frame[ref]] != ref_sign_bias[THIS_REF_FRAME] {
        mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mv.as_mv.row) * -1);
        mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mv.as_mv.col) * -1);
    }
    return mv;
}

is_inside :: (TILE: *Tile_Info, mi_col: s32, mi_row: s32, mi_rows: s32, mi_pos: *POSITION) -> s32 {
    if !(mi_row + mi_pos.row < 0 || mi_col + mi_pos.col < TILE.mi_col_start || mi_row + mi_pos.row >= mi_rows || mi_col + mi_pos.col >= TILE.mi_col_end) {
        return 1;
    }
    return 0;
}

clamp_mv2 :: (mv: *MV, xd: *MACROBLOCKD) {
    clamp_mv_in_vp9_mvref_common(
        mv,
        xd.mb_to_left_edge - (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_right_edge + (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_top_edge - (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_bottom_edge + (cast,no_check(s32) ((160 - 4))) << 3
    );
}

lower_mv_precision :: (mv: *MV, allow_hp: s32) {
    USE_HP := cast(s32) (allow_hp != 0 && use_mv_hp_in_vp9_mvref_common(mv) != 0);
    if USE_HP == 0 {
        if mv.row & 1 != 0 {
            c_transpiler_compound_add(*(mv.row), ((ifx mv.row > 0 then cast(s32) -1 else 1)), s32, s32);
        }
        if mv.col & 1 != 0 {
            c_transpiler_compound_add(*(mv.col), ((ifx mv.col > 0 then cast(s32) -1 else 1)), s32, s32);
        }
    }
}

vp9_find_mv_refs :: (
    cm: *VP9_COMMON,
    xd: *MACROBLOCKD,
    mi: *MODE_INFO,
    ref_frame: MV_REFERENCE_FRAME,
    mv_ref_list: *Int_Mv,
    mi_row: s32,
    mi_col: s32,
    mode_context: *u8
) {
    find_mv_refs_idx(cm, xd, mi, ref_frame, mv_ref_list, -1, mi_row, mi_col, mode_context);
}

find_mv_refs_idx :: (
    cm: *VP9_COMMON,
    xd: *MACROBLOCKD,
    mi: *MODE_INFO,
    ref_frame: MV_REFERENCE_FRAME,
    mv_ref_list: *Int_Mv,
    block: s32,
    mi_row: s32,
    mi_col: s32,
    mode_context: *u8
) {
    ref_sign_bias := cm.ref_frame_sign_bias.data;
    i: s32 = ---;
    refmv_count: s32 = 0;
    MV_REF_SEARCH := MV_REF_BLOCKS[mi.sb_type].data;
    different_ref_found: s32 = 0;
    context_counter: s32 = 0;
    PREV_FRAME_MVS: *MV_REF =
        (ifx cm.use_prev_frame_mvs != 0 then cm.prev_frame.mvs +
            mi_row * cm.mi_cols + mi_col else null);
    TILE := *xd.tile;
    fill_memory(mv_ref_list, 0, size_of(Int_Mv) * cast(u64) 2);
    while done := true { // Forward-goto shim; executes at most once.
        i = 0;
        while i < 2 {
            MV_REF_ := *MV_REF_SEARCH[i];
            if is_inside(TILE, mi_col, mi_row, cm.mi_rows, MV_REF_) != 0 {
                CANDIDATE_MI := xd.mi[MV_REF_.col + MV_REF_.row * xd.mi_stride];

                context_counter += MODE_2_COUNTER[CANDIDATE_MI.mode];
                different_ref_found = 1;

                if CANDIDATE_MI.ref_frame[0] == ref_frame {
                    if refmv_count != 0 {
                        if (get_sub_block_mv(CANDIDATE_MI, 0, MV_REF_.col, block)).as_int != mv_ref_list[0].as_int {
                            mv_ref_list[refmv_count] = get_sub_block_mv(CANDIDATE_MI, 0, MV_REF_.col, block);

                            break done;
                        }
                    } else {
                        assignment_0: Int_Mv = get_sub_block_mv(CANDIDATE_MI, 0, MV_REF_.col, block);
                        (mv_ref_list[c_transpiler_post_increment(*(refmv_count))]) = assignment_0;
                    }
                } else if CANDIDATE_MI.ref_frame[1] == ref_frame {
                    if refmv_count != 0 {
                        if (get_sub_block_mv(CANDIDATE_MI, 1, MV_REF_.col, block)).as_int != mv_ref_list[0].as_int {
                            mv_ref_list[refmv_count] = get_sub_block_mv(CANDIDATE_MI, 1, MV_REF_.col, block);

                            break done;
                        }
                    } else {
                        assignment_1: Int_Mv = get_sub_block_mv(CANDIDATE_MI, 1, MV_REF_.col, block);
                        (mv_ref_list[c_transpiler_post_increment(*(refmv_count))]) = assignment_1;
                    }
                }
            }
            i += 1;
        }
        while i < 8 {
            MV_REF_ := *MV_REF_SEARCH[i];
            if is_inside(TILE, mi_col, mi_row, cm.mi_rows, MV_REF_) != 0 {
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
                } else if CANDIDATE_MI.ref_frame[1] == ref_frame {
                    if refmv_count != 0 {
                        if CANDIDATE_MI.mv[1].as_int != mv_ref_list[0].as_int {
                            mv_ref_list[refmv_count] = CANDIDATE_MI.mv[1];

                            break done;
                        }
                    } else {
                        mv_ref_list[refmv_count] = CANDIDATE_MI.mv[1];
                        refmv_count += 1;
                    }
                }
            }
            i += 1;
        }
        if cm.use_prev_frame_mvs != 0 {
            if PREV_FRAME_MVS.ref_frame[0] == ref_frame {
                if refmv_count != 0 {
                    if PREV_FRAME_MVS.mv[0].as_int != mv_ref_list[0].as_int {
                        mv_ref_list[refmv_count] = PREV_FRAME_MVS.mv[0];

                        break done;
                    }
                } else {
                    mv_ref_list[refmv_count] = PREV_FRAME_MVS.mv[0];
                    refmv_count += 1;
                }
            } else if PREV_FRAME_MVS.ref_frame[1] == ref_frame {
                if refmv_count != 0 {
                    if PREV_FRAME_MVS.mv[1].as_int != mv_ref_list[0].as_int {
                        mv_ref_list[refmv_count] = PREV_FRAME_MVS.mv[1];

                        break done;
                    }
                } else {
                    mv_ref_list[refmv_count] = PREV_FRAME_MVS.mv[1];
                    refmv_count += 1;
                }
            }
        }
        if different_ref_found != 0 {
            i = 0;
            while i < 8 {
                mv_ref := *MV_REF_SEARCH[i];
                if is_inside(TILE, mi_col, mi_row, cm.mi_rows, mv_ref) != 0 {
                    CANDIDATE_MI := xd.mi[mv_ref.col + mv_ref.row * xd.mi_stride];

                    if is_inter_block_in_vp9_mvref_common(CANDIDATE_MI) != 0 {
                        if CANDIDATE_MI.ref_frame[0] != ref_frame {
                            if refmv_count != 0 {
                                if (scale_mv(CANDIDATE_MI, 0, ref_frame, ref_sign_bias)).as_int != mv_ref_list[0].as_int {
                                    mv_ref_list[refmv_count] = scale_mv(CANDIDATE_MI, 0, ref_frame, ref_sign_bias);

                                    break done;
                                }
                            } else {
                                assignment_2: Int_Mv = scale_mv(CANDIDATE_MI, 0, ref_frame, ref_sign_bias);
                                (mv_ref_list[c_transpiler_post_increment(*(refmv_count))]) = assignment_2;
                            }
                        }

                        if has_second_ref_in_vp9_mvref_common(CANDIDATE_MI) != 0 &&
                            CANDIDATE_MI.ref_frame[1] != ref_frame &&
                            CANDIDATE_MI.mv[1].as_int != CANDIDATE_MI.mv[0].as_int {
                            if refmv_count != 0 {
                                if (scale_mv(CANDIDATE_MI, 1, ref_frame, ref_sign_bias)).as_int != mv_ref_list[0].as_int {
                                    mv_ref_list[refmv_count] = scale_mv(CANDIDATE_MI, 1, ref_frame, ref_sign_bias);

                                    break done;
                                }
                            } else {
                                assignment_3: Int_Mv = scale_mv(CANDIDATE_MI, 1, ref_frame, ref_sign_bias);
                                (mv_ref_list[c_transpiler_post_increment(*(refmv_count))]) = assignment_3;
                            }
                        }
                    }
                }
                i += 1;
            }
        }
        if cm.use_prev_frame_mvs != 0 {
            if PREV_FRAME_MVS.ref_frame[0] != ref_frame && PREV_FRAME_MVS.ref_frame[0] > 0 {
                mv := PREV_FRAME_MVS.mv[0];
                if ref_sign_bias[PREV_FRAME_MVS.ref_frame[0]] != ref_sign_bias[ref_frame] {
                    mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mv.as_mv.row) * -1);
                    mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mv.as_mv.col) * -1);
                }
                if refmv_count != 0 {
                    if mv.as_int != mv_ref_list[0].as_int {
                        mv_ref_list[refmv_count] = mv;

                        break done;
                    }
                } else {
                    mv_ref_list[refmv_count] = mv;
                    refmv_count += 1;
                }
            }

            if PREV_FRAME_MVS.ref_frame[1] > 0 &&
                PREV_FRAME_MVS.ref_frame[1] != ref_frame &&
                PREV_FRAME_MVS.mv[1].as_int != PREV_FRAME_MVS.mv[0].as_int {
                mv := PREV_FRAME_MVS.mv[1];
                if ref_sign_bias[PREV_FRAME_MVS.ref_frame[1]] != ref_sign_bias[ref_frame] {
                    mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mv.as_mv.row) * -1);
                    mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mv.as_mv.col) * -1);
                }
                if refmv_count != 0 {
                    if mv.as_int != mv_ref_list[0].as_int {
                        mv_ref_list[refmv_count] = mv;

                        break done;
                    }
                } else {
                    mv_ref_list[refmv_count] = mv;
                    refmv_count += 1;
                }
            }
        }
        break done;
    }
    mode_context[ref_frame] = cast,no_check(u8) COUNTER_TO_CONTEXT[context_counter];
    i = 0;
    while i < 2 {
        clamp_mv_ref(*mv_ref_list[i].as_mv, xd);
        i += 1;
    }
}

vp9_find_best_ref_mvs :: (xd: *MACROBLOCKD, allow_hp: s32, mvlist: *Int_Mv, nearest_mv: *Int_Mv, near_mv: *Int_Mv) {
    for i: 0..cast(s32) 2 - 1 {
        lower_mv_precision(*mvlist[i].as_mv, allow_hp);
        clamp_mv2(*mvlist[i].as_mv, xd);
    }
    nearest_mv.* = mvlist[0];
    near_mv.* = mvlist[1];
}

vp9_append_sub8x8_mvs_for_idx :: (
    cm: *VP9_COMMON,
    xd: *MACROBLOCKD,
    block: s32,
    ref: s32,
    mi_row: s32,
    mi_col: s32,
    nearest_mv: *Int_Mv,
    near_mv: *Int_Mv,
    mode_context: *u8
) {
    mv_list: [2] Int_Mv = ---;
    MI: *MODE_INFO = ---;
    bmi: *B_Mode_Info = ---;
    n: s32 = ---;
    candidates: [4] Int_Mv = ---;
    code_block_to_execute: s64 = 37;
    while c_transpiler_dispatch := true {
        if code_block_to_execute < 0 break;
        if code_block_to_execute == {
            case 5; {
                break c_transpiler_dispatch;
            }
            case 6; {
                break c_transpiler_dispatch;
            }
            case 7; {
                if n < 2 + 2 {
                    code_block_to_execute = 11;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 6;
                    continue c_transpiler_dispatch;
                }
            }
            case 11; {
                if nearest_mv.as_int != candidates[n].as_int {
                    near_mv.as_int = candidates[n].as_int;
                    code_block_to_execute = 6;
                    continue c_transpiler_dispatch;
                } else {
                    n += 1;
                    code_block_to_execute = 7;
                    continue c_transpiler_dispatch;
                }
            }
            case 19; {
                break c_transpiler_dispatch;
            }
            case 20; {
                if n < 2 {
                    code_block_to_execute = 24;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 19;
                    continue c_transpiler_dispatch;
                }
            }
            case 24; {
                if nearest_mv.as_int != mv_list[n].as_int {
                    near_mv.as_int = mv_list[n].as_int;
                    code_block_to_execute = 19;
                    continue c_transpiler_dispatch;
                } else {
                    n += 1;
                    code_block_to_execute = 20;
                    continue c_transpiler_dispatch;
                }
            }
            case 26; {
                nearest_mv.as_int = bmi[0].as_mv[ref].as_int;
                n = 0;
                code_block_to_execute = 20;
                continue c_transpiler_dispatch;
            }
            case 37; {
                MI = xd.mi[0];
                bmi = MI.bmi.data;
                find_mv_refs_idx(cm, xd, MI, MI.ref_frame[ref], mv_list.data, block, mi_row, mi_col, mode_context);
                near_mv.as_int = 0;
                c_transpiler_switch_value_37 := block;
                if c_transpiler_switch_value_37 == {
                    case cast(s32) 0; {
                        nearest_mv.as_int = mv_list[0].as_int;
                        near_mv.as_int = mv_list[1].as_int;
                        break c_transpiler_dispatch;
                    }
                    case cast(s32) 1; {
                        code_block_to_execute = 26;
                        continue c_transpiler_dispatch;
                    }
                    case cast(s32) 2; {
                        code_block_to_execute = 26;
                        continue c_transpiler_dispatch;
                    }
                    case cast(s32) 3; {
                        candidates[0] = bmi[1].as_mv[ref];
                        candidates[1] = bmi[0].as_mv[ref];
                        candidates[2] = mv_list[0];
                        candidates[3] = mv_list[1];
                        nearest_mv.as_int = bmi[2].as_mv[ref].as_int;
                        n = 0;
                        code_block_to_execute = 7;
                        continue c_transpiler_dispatch;
                    }
                    case; {
                        code_block_to_execute = 5;
                        continue c_transpiler_dispatch;
                    }
                }
            }
        }
        assert(false, tprint("invalid code block to execute %", code_block_to_execute));
        break;
    }
}

globals_initialization_state_for_vp9_mvref_common: u32;
initialize_globals_for_vp9_mvref_common :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_mvref_common);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_mvref_common, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_mvref_common) != 2 {}
            return;
        }
    }
    SUB_PEL_FILTERS_12_in_vp9_mvref_common =
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
    COUNT_TO_UPDATE_FACTOR_in_vp9_mvref_common =
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
    MODE_2_COUNTER =
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
    COUNTER_TO_CONTEXT =
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
    MV_REF_BLOCKS =
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
    IDX_N_COLUMN_TO_SUBBLOCK =
        [2] s32.[
            s32.[ 1, 2 ],
            s32.[ 1, 3 ],
            s32.[ 3, 2 ],
            s32.[ 3, 3 ]
        ];
    atomic_store(*globals_initialization_state_for_vp9_mvref_common, 2);
}

POSITION :: Position;

Motion_Vector_Context :: u32;
BOTH_ZERO : s32 : 0;
ZERO_PLUS_PREDICTED : s32 : 1;
BOTH_PREDICTED : s32 : 2;
NEW_PLUS_NON_INTRA : s32 : 3;
BOTH_NEW : s32 : 4;
INTRA_PLUS_NON_INTRA : s32 : 5;
BOTH_INTRA : s32 : 6;
INVALID_CASE : s32 : 9;

Position :: struct {
    row: s32;
    col: s32;
}

