// Generated directly from C by cpp_transpiler.
COUNT_TO_UPDATE_FACTOR_in_vp9_pred_common: [21] s32;

SUB_PEL_FILTERS_12_in_vp9_pred_common: [16] Interp_Kernel12 #align 256;

clip_pixel_in_vp9_pred_common :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_pred_common :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_pred_common :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_pred_common :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_pred_common :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_pred_common(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_pred_common(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_pred_common(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_pred_common :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_lsb_in_vp9_pred_common :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_pred_common :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_pred_common :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_pred_common(num_values) + 1 else 0;
}

get_prob_in_vp9_pred_common :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_pred_common :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_pred_common(n0, DEN);
}

weighted_prob_in_vp9_pred_common :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_pred_common :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_pred_common(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_pred_common(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_pred_common :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_pred_common[COUNT];
        PROB := get_prob_in_vp9_pred_common(ct[0], DEN);
        return weighted_prob_in_vp9_pred_common(
            cast,no_check(s32) pre_prob,
            cast,no_check(s32) PROB,
            cast,no_check(s32) FACTOR
        );
    }
}

get_band_translate_in_vp9_pred_common :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_pred_common :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_pred_common :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_pred_common(above_ec, left_ec);
}

is_zero_mv_in_vp9_pred_common :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_pred_common :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_pred_common :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_pred_common(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_pred_common(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_pred_common :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_pred_common :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_pred_common :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_pred_common :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

get_filter_taps_in_vp9_pred_common :: (FILTER: *s16) -> s32 {
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

vp9_is_valid_scale_in_vp9_pred_common :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_pred_common :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_pred_common(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_pred_common :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_pred_common :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_pred_common :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_pred_common :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_pred_common :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_pred_common :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_pred_common :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_pred_common :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_pred_common :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_pred_common :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_pred_common :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_pred_common(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_pred_common :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_pred_common(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_pred_common(MI, ib)];
}

get_uv_tx_size_in_vp9_pred_common :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_pred_common :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_pred_common :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_pred_common(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_pred_common :: (
    mi: *MODE_INFO,
    above_mi: *MODE_INFO,
    left_mi: *MODE_INFO,
    block: s32
) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_pred_common :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_pred_common :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_pred_common :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_pred_common :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_pred_common :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_pred_common :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_pred_common :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_pred_common :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_pred_common :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_pred_common :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_pred_common :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_pred_common :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_pred_common(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_pred_common :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_pred_common(cm.mi_cols);

        if get_plane_type_in_vp9_pred_common(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_pred_common(cm, xd);
}

get_partition_probs_in_vp9_pred_common :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_pred_common :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_pred_common :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_pred_common :: (
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

update_partition_context_in_vp9_pred_common :: (
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

partition_plane_context_in_vp9_pred_common :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

get_segment_id :: (cm: *VP9_COMMON, segment_ids: *u8, bsize: BLOCK_SIZE, mi_row: s32, mi_col: s32) -> s32 {
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

vp9_get_pred_context_seg_id :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    ABOVE_SIP := (ifx ABOVE_MI != null then cast,no_check(s32) ABOVE_MI.seg_id_predicted else 0);
    LEFT_SIP := (ifx LEFT_MI != null then cast,no_check(s32) LEFT_MI.seg_id_predicted else 0);

    return ABOVE_SIP + LEFT_SIP;
}

vp9_get_pred_prob_seg_id :: (seg: *Segmentation, xd: *MACROBLOCKD) -> Prob {
    return seg.pred_probs[vp9_get_pred_context_seg_id(xd)];
}

vp9_get_skip_context :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    ABOVE_SKIP := (ifx ABOVE_MI != null then cast,no_check(s32) ABOVE_MI.skip else 0);
    LEFT_SKIP := (ifx LEFT_MI != null then cast,no_check(s32) LEFT_MI.skip else 0);
    return ABOVE_SKIP + LEFT_SKIP;
}

vp9_get_skip_prob :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.skip_probs[vp9_get_skip_context(xd)];
}

get_pred_context_switchable_interp :: (xd: *MACROBLOCKD) -> s32 {
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

get_intra_inter_context :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    HAS_ABOVE := cast(s32) (ABOVE_MI != null);
    HAS_LEFT := cast(s32) (LEFT_MI != null);

    if HAS_ABOVE != 0 && HAS_LEFT != 0 {
        ABOVE_INTRA := cast(s32) (is_inter_block_in_vp9_pred_common(ABOVE_MI) == 0);
        LEFT_INTRA := cast(s32) (is_inter_block_in_vp9_pred_common(LEFT_MI) == 0);
        return ifx LEFT_INTRA != 0 && ABOVE_INTRA != 0 then 3 else cast(s32) (LEFT_INTRA != 0 || ABOVE_INTRA != 0);
    } else if HAS_ABOVE != 0 || HAS_LEFT != 0 {
        return 2 * cast(s32) (is_inter_block_in_vp9_pred_common((ifx HAS_ABOVE != 0 then ABOVE_MI else LEFT_MI)) == 0);
    }
    return 0;
}

vp9_get_intra_inter_prob :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.intra_inter_prob[get_intra_inter_context(xd)];
}

vp9_get_reference_mode_context :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> s32 {
    ctx: s32 = ---;
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    HAS_ABOVE := cast(s32) (ABOVE_MI != null);
    HAS_LEFT := cast(s32) (LEFT_MI != null);

    if HAS_ABOVE != 0 && HAS_LEFT != 0 {
        if has_second_ref_in_vp9_pred_common(ABOVE_MI) == 0 && has_second_ref_in_vp9_pred_common(LEFT_MI) == 0 {
            ctx =
                (cast(s32) (ABOVE_MI.ref_frame[0] == cm.comp_fixed_ref)) ^ cast(s32) (LEFT_MI.ref_frame[0] == cm.comp_fixed_ref);
        } else if has_second_ref_in_vp9_pred_common(ABOVE_MI) == 0 {
            ctx =
                2 +
                    cast(s32) (ABOVE_MI.ref_frame[0] == cm.comp_fixed_ref || is_inter_block_in_vp9_pred_common(ABOVE_MI) == 0);
        } else if has_second_ref_in_vp9_pred_common(LEFT_MI) == 0 {
            ctx =
                2 +
                    cast(s32) (LEFT_MI.ref_frame[0] == cm.comp_fixed_ref || is_inter_block_in_vp9_pred_common(LEFT_MI) == 0);
        } else {
            ctx = 4;
        }
    } else if HAS_ABOVE != 0 || HAS_LEFT != 0 {
        edge_mi := (ifx HAS_ABOVE != 0 then ABOVE_MI else LEFT_MI);

        if has_second_ref_in_vp9_pred_common(edge_mi) == 0 {
            ctx = cast(s32) (edge_mi.ref_frame[0] == cm.comp_fixed_ref);
        } else {
            ctx = 3;
        }
    } else {
        ctx = 1;
    }

    return ctx;
}

vp9_get_reference_mode_prob :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.comp_inter_prob[vp9_get_reference_mode_context(cm, xd)];
}

vp9_get_pred_context_comp_ref_p :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> s32 {
    pred_context: s32 = ---;
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    ABOVE_IN_IMAGE := cast(s32) (ABOVE_MI != null);
    LEFT_IN_IMAGE := cast(s32) (LEFT_MI != null);

    FIX_REF_IDX := cm.ref_frame_sign_bias[cm.comp_fixed_ref];
    VAR_REF_IDX := cast(s32) (FIX_REF_IDX == 0);

    if ABOVE_IN_IMAGE != 0 && LEFT_IN_IMAGE != 0 {
        ABOVE_INTRA := cast(s32) (is_inter_block_in_vp9_pred_common(ABOVE_MI) == 0);
        LEFT_INTRA := cast(s32) (is_inter_block_in_vp9_pred_common(LEFT_MI) == 0);

        if ABOVE_INTRA != 0 && LEFT_INTRA != 0 {
            pred_context = 2;
        } else if ABOVE_INTRA != 0 || LEFT_INTRA != 0 {
            edge_mi := (ifx ABOVE_INTRA != 0 then LEFT_MI else ABOVE_MI);

            if has_second_ref_in_vp9_pred_common(edge_mi) == 0 {
                pred_context = 1 + 2 * cast(s32) (edge_mi.ref_frame[0] != cm.comp_var_ref[1]);
            } else {
                pred_context = 1 + 2 * cast(s32) (edge_mi.ref_frame[VAR_REF_IDX] != cm.comp_var_ref[1]);
            }
        } else {
            L_SG := cast(s32) (has_second_ref_in_vp9_pred_common(LEFT_MI) == 0);
            A_SG := cast(s32) (has_second_ref_in_vp9_pred_common(ABOVE_MI) == 0);
            VRFA :=
                cast,no_check(MV_REFERENCE_FRAME) ((ifx A_SG != 0 then cast,no_check(s32) ABOVE_MI.ref_frame[0] else cast,no_check(s32) ABOVE_MI.ref_frame[VAR_REF_IDX]));
            VRFL :=
                cast,no_check(MV_REFERENCE_FRAME) ((ifx L_SG != 0 then cast,no_check(s32) LEFT_MI.ref_frame[0] else cast,no_check(s32) LEFT_MI.ref_frame[VAR_REF_IDX]));

            if VRFA == VRFL && cm.comp_var_ref[1] == VRFA {
                pred_context = 0;
            } else if L_SG != 0 && A_SG != 0 {
                if VRFA == cm.comp_fixed_ref && VRFL == cm.comp_var_ref[0] || VRFL == cm.comp_fixed_ref && VRFA == cm.comp_var_ref[0] {
                    pred_context = 4;
                } else if VRFA == VRFL {
                    pred_context = 3;
                } else {
                    pred_context = 1;
                }
            } else if L_SG != 0 || A_SG != 0 {
                VRFC :=
                    cast,no_check(MV_REFERENCE_FRAME) ((ifx L_SG != 0 then cast,no_check(s32) VRFA else cast,no_check(s32) VRFL));
                RFS :=
                    cast,no_check(MV_REFERENCE_FRAME) ((ifx A_SG != 0 then cast,no_check(s32) VRFA else cast,no_check(s32) VRFL));
                if VRFC == cm.comp_var_ref[1] && RFS != cm.comp_var_ref[1] {
                    pred_context = 1;
                } else if RFS == cm.comp_var_ref[1] && VRFC != cm.comp_var_ref[1] {
                    pred_context = 2;
                } else {
                    pred_context = 4;
                }
            } else if VRFA == VRFL {
                pred_context = 4;
            } else {
                pred_context = 2;
            }
        }
    } else if ABOVE_IN_IMAGE != 0 || LEFT_IN_IMAGE != 0 {
        edge_mi := (ifx ABOVE_IN_IMAGE != 0 then ABOVE_MI else LEFT_MI);

        if is_inter_block_in_vp9_pred_common(edge_mi) == 0 {
            pred_context = 2;
        } else if has_second_ref_in_vp9_pred_common(edge_mi) != 0 {
            pred_context = 4 * cast(s32) (edge_mi.ref_frame[VAR_REF_IDX] != cm.comp_var_ref[1]);
        } else {
            pred_context = 3 * cast(s32) (edge_mi.ref_frame[0] != cm.comp_var_ref[1]);
        }
    } else {
        pred_context = 2;
    }

    return pred_context;
}

vp9_get_pred_prob_comp_ref_p :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    PRED_CONTEXT := vp9_get_pred_context_comp_ref_p(cm, xd);
    return cm.fc.comp_ref_prob[PRED_CONTEXT];
}

vp9_get_pred_context_single_ref_p1 :: (xd: *MACROBLOCKD) -> s32 {
    pred_context: s32 = ---;
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    HAS_ABOVE := cast(s32) (ABOVE_MI != null);
    HAS_LEFT := cast(s32) (LEFT_MI != null);

    if HAS_ABOVE != 0 && HAS_LEFT != 0 {
        ABOVE_INTRA := cast(s32) (is_inter_block_in_vp9_pred_common(ABOVE_MI) == 0);
        LEFT_INTRA := cast(s32) (is_inter_block_in_vp9_pred_common(LEFT_MI) == 0);

        if ABOVE_INTRA != 0 && LEFT_INTRA != 0 {
            pred_context = 2;
        } else if ABOVE_INTRA != 0 || LEFT_INTRA != 0 {
            edge_mi := (ifx ABOVE_INTRA != 0 then LEFT_MI else ABOVE_MI);
            if has_second_ref_in_vp9_pred_common(edge_mi) == 0 {
                pred_context = 4 * cast(s32) (edge_mi.ref_frame[0] == 1);
            } else {
                pred_context = 1 + cast(s32) (edge_mi.ref_frame[0] == 1 || edge_mi.ref_frame[1] == 1);
            }
        } else {
            ABOVE_HAS_SECOND := has_second_ref_in_vp9_pred_common(ABOVE_MI);
            LEFT_HAS_SECOND := has_second_ref_in_vp9_pred_common(LEFT_MI);
            ABOVE0 := ABOVE_MI.ref_frame[0];
            ABOVE1 := ABOVE_MI.ref_frame[1];
            LEFT0 := LEFT_MI.ref_frame[0];
            LEFT1 := LEFT_MI.ref_frame[1];

            if ABOVE_HAS_SECOND != 0 && LEFT_HAS_SECOND != 0 {
                pred_context = 1 + cast(s32) (ABOVE0 == 1 || ABOVE1 == 1 || LEFT0 == 1 || LEFT1 == 1);
            } else if ABOVE_HAS_SECOND != 0 || LEFT_HAS_SECOND != 0 {
                RFS :=
                    cast,no_check(MV_REFERENCE_FRAME) ((ifx ABOVE_HAS_SECOND == 0 then cast,no_check(s32) ABOVE0 else cast,no_check(s32) LEFT0));
                CRF1 :=
                    cast,no_check(MV_REFERENCE_FRAME) ((ifx ABOVE_HAS_SECOND != 0 then cast,no_check(s32) ABOVE0 else cast,no_check(s32) LEFT0));
                CRF2 :=
                    cast,no_check(MV_REFERENCE_FRAME) ((ifx ABOVE_HAS_SECOND != 0 then cast,no_check(s32) ABOVE1 else cast,no_check(s32) LEFT1));

                if RFS == 1 {
                    pred_context = 3 + cast(s32) (CRF1 == 1 || CRF2 == 1);
                } else {
                    pred_context = cast(s32) (CRF1 == 1 || CRF2 == 1);
                }
            } else {
                pred_context = (2 * cast(s32) (ABOVE0 == 1)) + 2 * cast(s32) (LEFT0 == 1);
            }
        }
    } else if HAS_ABOVE != 0 || HAS_LEFT != 0 {
        edge_mi := (ifx HAS_ABOVE != 0 then ABOVE_MI else LEFT_MI);
        if is_inter_block_in_vp9_pred_common(edge_mi) == 0 {
            pred_context = 2;
        } else if has_second_ref_in_vp9_pred_common(edge_mi) == 0 {
            pred_context = 4 * cast(s32) (edge_mi.ref_frame[0] == 1);
        } else {
            pred_context = 1 + cast(s32) (edge_mi.ref_frame[0] == 1 || edge_mi.ref_frame[1] == 1);
        }
    } else {
        pred_context = 2;
    }

    return pred_context;
}

vp9_get_pred_prob_single_ref_p1 :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return ((cm.fc.single_ref_prob[vp9_get_pred_context_single_ref_p1(xd)]).data)[0];
}

vp9_get_pred_context_single_ref_p2 :: (xd: *MACROBLOCKD) -> s32 {
    pred_context: s32 = ---;
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    HAS_ABOVE := cast(s32) (ABOVE_MI != null);
    HAS_LEFT := cast(s32) (LEFT_MI != null);

    if HAS_ABOVE != 0 && HAS_LEFT != 0 {
        ABOVE_INTRA := cast(s32) (is_inter_block_in_vp9_pred_common(ABOVE_MI) == 0);
        LEFT_INTRA := cast(s32) (is_inter_block_in_vp9_pred_common(LEFT_MI) == 0);

        if ABOVE_INTRA != 0 && LEFT_INTRA != 0 {
            pred_context = 2;
        } else if ABOVE_INTRA != 0 || LEFT_INTRA != 0 {
            edge_mi := (ifx ABOVE_INTRA != 0 then LEFT_MI else ABOVE_MI);
            if has_second_ref_in_vp9_pred_common(edge_mi) == 0 {
                if edge_mi.ref_frame[0] == 1 {
                    pred_context = 3;
                } else {
                    pred_context = 4 * cast(s32) (edge_mi.ref_frame[0] == 2);
                }
            } else {
                pred_context = 1 + 2 * cast(s32) (edge_mi.ref_frame[0] == 2 || edge_mi.ref_frame[1] == 2);
            }
        } else {
            ABOVE_HAS_SECOND := has_second_ref_in_vp9_pred_common(ABOVE_MI);
            LEFT_HAS_SECOND := has_second_ref_in_vp9_pred_common(LEFT_MI);
            ABOVE0 := ABOVE_MI.ref_frame[0];
            ABOVE1 := ABOVE_MI.ref_frame[1];
            LEFT0 := LEFT_MI.ref_frame[0];
            LEFT1 := LEFT_MI.ref_frame[1];

            if ABOVE_HAS_SECOND != 0 && LEFT_HAS_SECOND != 0 {
                if ABOVE0 == LEFT0 && ABOVE1 == LEFT1 {
                    pred_context = 3 * cast(s32) (ABOVE0 == 2 || ABOVE1 == 2 || LEFT0 == 2 || LEFT1 == 2);
                } else {
                    pred_context = 2;
                }
            } else if ABOVE_HAS_SECOND != 0 || LEFT_HAS_SECOND != 0 {
                RFS :=
                    cast,no_check(MV_REFERENCE_FRAME) ((ifx ABOVE_HAS_SECOND == 0 then cast,no_check(s32) ABOVE0 else cast,no_check(s32) LEFT0));
                CRF1 :=
                    cast,no_check(MV_REFERENCE_FRAME) ((ifx ABOVE_HAS_SECOND != 0 then cast,no_check(s32) ABOVE0 else cast,no_check(s32) LEFT0));
                CRF2 :=
                    cast,no_check(MV_REFERENCE_FRAME) ((ifx ABOVE_HAS_SECOND != 0 then cast,no_check(s32) ABOVE1 else cast,no_check(s32) LEFT1));

                if RFS == 2 {
                    pred_context = 3 + cast(s32) (CRF1 == 2 || CRF2 == 2);
                } else if RFS == 3 {
                    pred_context = cast(s32) (CRF1 == 2 || CRF2 == 2);
                } else {
                    pred_context = 1 + 2 * cast(s32) (CRF1 == 2 || CRF2 == 2);
                }
            } else if ABOVE0 == 1 && LEFT0 == 1 {
                pred_context = 3;
            } else if ABOVE0 == 1 || LEFT0 == 1 {
                EDGE0 :=
                    cast,no_check(MV_REFERENCE_FRAME) ((ifx ABOVE0 == 1 then cast,no_check(s32) LEFT0 else cast,no_check(s32) ABOVE0));
                pred_context = 4 * cast(s32) (EDGE0 == 2);
            } else {
                pred_context = (2 * cast(s32) (ABOVE0 == 2)) + 2 * cast(s32) (LEFT0 == 2);
            }
        }
    } else if HAS_ABOVE != 0 || HAS_LEFT != 0 {
        edge_mi := (ifx HAS_ABOVE != 0 then ABOVE_MI else LEFT_MI);

        if is_inter_block_in_vp9_pred_common(edge_mi) == 0 ||
            edge_mi.ref_frame[0] == 1 && has_second_ref_in_vp9_pred_common(edge_mi) == 0 {
            pred_context = 2;
        } else if has_second_ref_in_vp9_pred_common(edge_mi) == 0 {
            pred_context = 4 * cast(s32) (edge_mi.ref_frame[0] == 2);
        } else {
            pred_context = 3 * cast(s32) (edge_mi.ref_frame[0] == 2 || edge_mi.ref_frame[1] == 2);
        }
    } else {
        pred_context = 2;
    }

    return pred_context;
}

vp9_get_pred_prob_single_ref_p2 :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return ((cm.fc.single_ref_prob[vp9_get_pred_context_single_ref_p2(xd)]).data)[1];
}

vp9_compound_reference_allowed :: (cm: *VP9_COMMON) -> s32 {
    if 1 < 3 {
        for i: 1..cast(s32) 3 - 1 {
            if cm.ref_frame_sign_bias[i + 1] != cm.ref_frame_sign_bias[1] {
                return 1;
            }
        }
    }

    return 0;
}

vp9_setup_compound_reference_mode :: (cm: *VP9_COMMON) {
    if cm.ref_frame_sign_bias[1] == cm.ref_frame_sign_bias[2] {
        cm.comp_fixed_ref = 3;
        cm.comp_var_ref[0] = 1;
        cm.comp_var_ref[1] = 2;
    } else if cm.ref_frame_sign_bias[1] == cm.ref_frame_sign_bias[3] {
        cm.comp_fixed_ref = 2;
        cm.comp_var_ref[0] = 1;
        cm.comp_var_ref[1] = 3;
    } else {
        cm.comp_fixed_ref = 1;
        cm.comp_var_ref[0] = 2;
        cm.comp_var_ref[1] = 3;
    }
}

get_tx_size_context :: (xd: *MACROBLOCKD) -> s32 {
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

get_tx_probs :: (max_tx_size: TX_SIZE, ctx: s32, tx_probs: *Tx_Probs) -> *Prob {
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

get_tx_counts :: (max_tx_size: TX_SIZE, ctx: s32, tx_counts: *Tx_Counts) -> *u32 {
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

globals_initialization_state_for_vp9_pred_common: u32;
initialize_globals_for_vp9_pred_common :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_pred_common);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_pred_common, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_pred_common) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_vp9_pred_common =
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
    SUB_PEL_FILTERS_12_in_vp9_pred_common =
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
    atomic_store(*globals_initialization_state_for_vp9_pred_common, 2);
}

