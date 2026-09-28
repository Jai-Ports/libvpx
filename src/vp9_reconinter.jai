// Generated directly from C by cpp_transpiler.
COUNT_TO_UPDATE_FACTOR_in_vp9_reconinter: [21] s32;

SUB_PEL_FILTERS_12_in_vp9_reconinter: [16] Interp_Kernel12 #align 256;

clip_pixel_in_vp9_reconinter :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_reconinter :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_reconinter :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_reconinter :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_reconinter :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_reconinter(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_reconinter(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_reconinter(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_reconinter :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_prob_in_vp9_reconinter :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_reconinter :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_reconinter(n0, DEN);
}

weighted_prob_in_vp9_reconinter :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_reconinter :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_reconinter(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_reconinter(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_reconinter :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_reconinter[COUNT];
        PROB := get_prob_in_vp9_reconinter(ct[0], DEN);
        return weighted_prob_in_vp9_reconinter(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_lsb_in_vp9_reconinter :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_reconinter :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_reconinter :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_reconinter(num_values) + 1 else 0;
}

get_band_translate_in_vp9_reconinter :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_reconinter :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_reconinter :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_reconinter(above_ec, left_ec);
}

is_zero_mv_in_vp9_reconinter :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_reconinter :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_reconinter :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_reconinter(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_reconinter(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_reconinter :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_reconinter :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_reconinter :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_reconinter :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

get_filter_taps_in_vp9_reconinter :: (FILTER: *s16) -> s32 {
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

vp9_is_valid_scale_in_vp9_reconinter :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_reconinter :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_reconinter(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_reconinter :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_reconinter :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_reconinter :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_reconinter :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_reconinter :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_reconinter :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_reconinter :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_reconinter :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_reconinter :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_reconinter :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_reconinter :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_reconinter(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_reconinter :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_reconinter(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_reconinter(MI, ib)];
}

get_uv_tx_size_in_vp9_reconinter :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_reconinter :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_reconinter :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_reconinter(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_reconinter :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_reconinter :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_reconinter :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_reconinter :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_reconinter :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_reconinter :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_reconinter :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_reconinter :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_reconinter :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_reconinter :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_reconinter :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_reconinter :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_reconinter :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_reconinter(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_reconinter :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_reconinter(cm.mi_cols);

        if get_plane_type_in_vp9_reconinter(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_reconinter(cm, xd);
}

get_partition_probs_in_vp9_reconinter :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_reconinter :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_reconinter :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_reconinter :: (
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

update_partition_context_in_vp9_reconinter :: (
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

partition_plane_context_in_vp9_reconinter :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

inter_predictor_in_vp9_reconinter :: (
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

average_split_mvs :: (pd: *Macroblockd_Plane, mi: *MODE_INFO, ref: s32, block: s32) -> MV {
    SS_IDX := (cast(s32) (pd.subsampling_x > 0)) << 1 | cast(s32) (pd.subsampling_y > 0);
    res: MV;
    if SS_IDX == {
        case 0;
            res = mi.bmi[block].as_mv[ref].as_mv;
        case 1;
            res = mi_mv_pred_q2(mi, ref, block, block + 2);
        case 2;
            res = mi_mv_pred_q2(mi, ref, block, block + 1);
        case 3;
            res = mi_mv_pred_q4(mi, ref);
        case;
    }
    return res;
}

mi_mv_pred_q4 :: (mi: *MODE_INFO, idx: s32) -> MV {
    res :=
        MV.{row = cast,no_check(s16) round_mv_comp_q4(
            (((cast(s32) mi.bmi[0].as_mv[idx].as_mv.row) + cast(s32) mi.bmi[1].as_mv[idx].as_mv.row) + cast(s32) mi.bmi[2].as_mv[idx].as_mv.row) +
            cast(s32) mi.bmi[3].as_mv[idx].as_mv.row
        ), col = cast,no_check(s16) round_mv_comp_q4(
            (((cast(s32) mi.bmi[0].as_mv[idx].as_mv.col) + cast(s32) mi.bmi[1].as_mv[idx].as_mv.col) + cast(s32) mi.bmi[2].as_mv[idx].as_mv.col) +
            cast(s32) mi.bmi[3].as_mv[idx].as_mv.col
        )};
    return res;
}

round_mv_comp_q4 :: (value: s32) -> s32 {
    return (ifx value < 0 then value - 2 else value + 2) / 4;
}

mi_mv_pred_q2 :: (mi: *MODE_INFO, idx: s32, block0: s32, block1: s32) -> MV {
    res :=
        MV.{row = cast,no_check(s16) round_mv_comp_q2(
            (cast(s32) mi.bmi[block0].as_mv[idx].as_mv.row) + cast(s32) mi.bmi[block1].as_mv[idx].as_mv.row
        ), col = cast,no_check(s16) round_mv_comp_q2(
            (cast(s32) mi.bmi[block0].as_mv[idx].as_mv.col) + cast(s32) mi.bmi[block1].as_mv[idx].as_mv.col
        )};
    return res;
}

round_mv_comp_q2 :: (value: s32) -> s32 {
    return (ifx value < 0 then value - 1 else value + 1) / 2;
}

clamp_mv_to_umv_border_sb :: (xd: *MACROBLOCKD, src_mv: *MV, bw: s32, bh: s32, ss_x: s32, ss_y: s32) -> MV {
    SPEL_LEFT := (4 + bw) << 4;
    SPEL_RIGHT := SPEL_LEFT - (cast(s32) 1) << 4;
    SPEL_TOP := (4 + bh) << 4;
    SPEL_BOTTOM := SPEL_TOP - (cast(s32) 1) << 4;
    clamped_mv :=
        MV.{row = cast,no_check(s16) ((cast(s32) src_mv.row) *
            (cast(s32) 1) << (((1 - ss_y)) & 31)), col = cast,no_check(s16) ((cast(s32) src_mv.col) * (cast(s32) 1) << (((1 - ss_x)) & 31))};

    clamp_mv_in_vp9_reconinter(
        *clamped_mv,
        xd.mb_to_left_edge * (cast(s32) 1) << (((1 - ss_x)) & 31) - SPEL_LEFT,
        xd.mb_to_right_edge * (cast(s32) 1) << (((1 - ss_x)) & 31) + SPEL_RIGHT,
        xd.mb_to_top_edge * (cast(s32) 1) << (((1 - ss_y)) & 31) - SPEL_TOP,
        xd.mb_to_bottom_edge * (cast(s32) 1) << (((1 - ss_y)) & 31) + SPEL_BOTTOM
    );

    return clamped_mv;
}

vp9_build_inter_predictors_sby :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) {
    build_inter_predictors_for_planes(xd, bsize, mi_row, mi_col, 0, 0);
}

build_inter_predictors_for_planes :: (
    xd: *MACROBLOCKD,
    bsize: BLOCK_SIZE,
    mi_row: s32,
    mi_col: s32,
    plane_from: s32,
    plane_to: s32
) {
    MI_X := mi_col * (cast(s32) 1) << 3;
    MI_Y := mi_row * (cast(s32) 1) << 3;
    plane := plane_from;
    while plane <= plane_to {
        PLANE_BSIZE := get_plane_block_size_in_vp9_reconinter(bsize, xd.plane.data + plane);
        NUM_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE];
        NUM_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE];
        BW := 4 * NUM_4X4_W;
        BH := 4 * NUM_4X4_H;

        if xd.mi[0].sb_type < 3 {
            i: s32 = 0;
            x: s32 = ---;

            if 0 < NUM_4X4_H {
                for y: 0..NUM_4X4_H - 1 {
                    x = 0;
                    while x < NUM_4X4_W {
                        build_inter_predictors(
                            xd,
                            plane,
                            c_transpiler_post_increment(*(i)),
                            BW,
                            BH,
                            4 * x,
                            4 * y,
                            4,
                            4,
                            MI_X,
                            MI_Y
                        );
                        x += 1;
                    }
                }
            }
        } else {
            build_inter_predictors(xd, plane, 0, BW, BH, 0, 0, BW, BH, MI_X, MI_Y);
        }
        plane += 1;
    }
}

build_inter_predictors :: (
    xd: *MACROBLOCKD,
    plane: s32,
    block: s32,
    bw: s32,
    bh: s32,
    x: s32,
    y: s32,
    w: s32,
    h: s32,
    mi_x: s32,
    mi_y: s32
) {
    PD := xd.plane.data + plane;
    mi := xd.mi[0];
    IS_COMPOUND := has_second_ref_in_vp9_reconinter(mi);
    kernel := vp9_filter_kernels[mi.interp_filter];

    ref: s32 = 0;
    while ref < 1 + IS_COMPOUND {
        SF := *xd.block_refs[ref].sf;
        PRE_BUF := PD.pre.data + ref;
        DST_BUF := *PD.dst;
        DST := (DST_BUF.buf + (cast,no_check(s64) DST_BUF.stride) * cast(s64) y) + x;
        MV_ := (ifx mi.sb_type < 3 then average_split_mvs(PD, mi, ref, block) else mi.mv[ref].as_mv);

        MV_Q4 := clamp_mv_to_umv_border_sb(xd, *MV_, bw, bh, PD.subsampling_x, PD.subsampling_y);

        pre: *u8 = ---;
        scaled_mv: MV32 = ---;
        xs: s32 = ---;
        ys: s32 = ---;
        IS_SCALED := vp9_is_scaled_in_vp9_reconinter(SF);

        if IS_SCALED != 0 {
            X_START := -xd.mb_to_left_edge >> (((3 + PD.subsampling_x)) & 31);
            Y_START := -xd.mb_to_top_edge >> (((3 + PD.subsampling_y)) & 31);
            ref_buf := xd.block_refs[ref].buf;
            buf_array := *u8.[ ref_buf.y_buffer, ref_buf.u_buffer, ref_buf.v_buffer ];
            STRIDE_ARRAY := s32.[ ref_buf.y_stride, ref_buf.uv_stride, ref_buf.uv_stride ];

            PRE_BUF.buf = buf_array[plane];
            PRE_BUF.stride = STRIDE_ARRAY[plane];

            PRE_BUF.buf += scaled_buffer_offset_in_vp9_reconinter(X_START + x, Y_START + y, PRE_BUF.stride, SF);
            pre = PRE_BUF.buf;
            scaled_mv = vp9_scale_mv(*MV_Q4, mi_x + x, mi_y + y, SF);
            xs = SF.x_step_q4;
            ys = SF.y_step_q4;
        } else {
            pre = PRE_BUF.buf + (((cast,no_check(s64) y) * cast(s64) PRE_BUF.stride) + cast(s64) x);
            scaled_mv.row = cast,no_check(s32) MV_Q4.row;
            scaled_mv.col = cast,no_check(s32) MV_Q4.col;
            ys = 16;
            xs = ys;
        }
        subpel_x := scaled_mv.col & ((cast(s32) 1) << 4 - 1);
        subpel_y := scaled_mv.row & ((cast(s32) 1) << 4 - 1);
        pre += scaled_mv.row >> 4 * PRE_BUF.stride + scaled_mv.col >> 4;

        inter_predictor_in_vp9_reconinter(
            pre,
            PRE_BUF.stride,
            DST,
            DST_BUF.stride,
            subpel_x,
            subpel_y,
            SF,
            w,
            h,
            ref,
            kernel,
            xs,
            ys
        );
        ref += 1;
    }
}

scaled_buffer_offset_in_vp9_reconinter :: (x_offset: s32, y_offset: s32, stride: s32, sf: *Scale_Factors) -> s64 {
    X := (ifx sf != null then sf.scale_value_x(x_offset, sf) else x_offset);
    Y := (ifx sf != null then sf.scale_value_y(y_offset, sf) else y_offset);
    return ((cast,no_check(s64) Y) * cast(s64) stride) + cast(s64) X;
}

vp9_build_inter_predictors_sbp :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE, plane: s32) {
    build_inter_predictors_for_planes(xd, bsize, mi_row, mi_col, plane, plane);
}

vp9_build_inter_predictors_sbuv :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) {
    build_inter_predictors_for_planes(xd, bsize, mi_row, mi_col, 1, cast,no_check(s32) (3 - 1));
}

vp9_build_inter_predictors_sb :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) {
    build_inter_predictors_for_planes(xd, bsize, mi_row, mi_col, 0, cast,no_check(s32) (3 - 1));
}

vp9_build_inter_predictor :: (
    src: *u8,
    src_stride: s32,
    dst: *u8,
    dst_stride: s32,
    src_mv: *MV,
    sf: *Scale_Factors,
    w: s32,
    h: s32,
    ref: s32,
    kernel: *Interp_Kernel,
    precision: Mv_Precision,
    x: s32,
    y: s32
) {
    IS_Q4 := cast(s32) (precision == cast,no_check(u32) MV_PRECISION_Q4);
    MV_Q4 :=
        MV.{row = cast,no_check(s16) ((ifx IS_Q4 != 0 then cast,no_check(s32) src_mv.row else (cast(s32) src_mv.row) *
            2)), col = cast,no_check(s16) ((ifx IS_Q4 != 0 then cast,no_check(s32) src_mv.col else (cast(s32) src_mv.col) * 2))};
    mv := vp9_scale_mv(*MV_Q4, x, y, sf);
    SUBPEL_X: s32 = mv.col & ((cast(s32) 1) << 4 - 1);
    SUBPEL_Y: s32 = mv.row & ((cast(s32) 1) << 4 - 1);

    src += mv.row >> 4 * src_stride + mv.col >> 4;

    inter_predictor_in_vp9_reconinter(
        src,
        src_stride,
        dst,
        dst_stride,
        SUBPEL_X,
        SUBPEL_Y,
        sf,
        w,
        h,
        ref,
        kernel,
        sf.x_step_q4,
        sf.y_step_q4
    );
}

setup_pred_plane_in_vp9_reconinter :: (
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
    dst.buf = src + scaled_buffer_offset_in_vp9_reconinter(X, Y, stride, scale);
    dst.stride = stride;
}

vp9_setup_dst_planes :: (planes: *Macroblockd_Plane, src: *YV12_BUFFER_CONFIG, mi_row: s32, mi_col: s32) {
    BUFFERS := *u8.[ src.y_buffer, src.u_buffer, src.v_buffer ];
    STRIDES := s32.[ src.y_stride, src.uv_stride, src.uv_stride ];

    for i: 0..cast(s32) 3 - 1 {
        PD := *planes[i];
        setup_pred_plane_in_vp9_reconinter(
            *PD.dst,
            BUFFERS[i],
            STRIDES[i],
            mi_row,
            mi_col,
            null,
            PD.subsampling_x,
            PD.subsampling_y
        );
    }
}

vp9_setup_pre_planes :: (
    xd: *MACROBLOCKD,
    idx: s32,
    src: *YV12_BUFFER_CONFIG,
    mi_row: s32,
    mi_col: s32,
    sf: *Scale_Factors
) {
    if src != null {
        BUFFERS := *u8.[ src.y_buffer, src.u_buffer, src.v_buffer ];
        STRIDES := s32.[ src.y_stride, src.uv_stride, src.uv_stride ];
        for i: 0..cast(s32) 3 - 1 {
            PD := xd.plane.data + i;
            setup_pred_plane_in_vp9_reconinter(
                PD.pre.data + idx,
                BUFFERS[i],
                STRIDES[i],
                mi_row,
                mi_col,
                sf,
                PD.subsampling_x,
                PD.subsampling_y
            );
        }
    }
}

globals_initialization_state_for_vp9_reconinter: u32;
initialize_globals_for_vp9_reconinter :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_reconinter);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_reconinter, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_reconinter) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_vp9_reconinter =
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
    SUB_PEL_FILTERS_12_in_vp9_reconinter =
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
    atomic_store(*globals_initialization_state_for_vp9_reconinter, 2);
}

Mv_Precision :: u32;
MV_PRECISION_Q3 : s32 : 0;
MV_PRECISION_Q4 : s32 : 1;

