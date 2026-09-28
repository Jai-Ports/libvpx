RANGE :: struct {
    min: s32;
    max: s32;
}

COUNT_TO_UPDATE_FACTOR_in_vp9_firstpass: [21] s32;

SUB_PEL_FILTERS_12_in_vp9_firstpass: [16] Interp_Kernel12 #align 256;

FRAME_SCALE_FACTOR_in_vp9_firstpass: [2] s32;

RATE_THRESH_MULT_in_vp9_firstpass: [2] float64;

RCF_MULT_in_vp9_firstpass: [2] float64;

fp_dn_kernel_3: [9] u8;

Q_POW_TERM: [9] float64;

K_VP9_REF_FLAG_LIST_in_vp9_firstpass: [4] s32;

clip_pixel_in_vp9_firstpass :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_firstpass :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_firstpass :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_firstpass :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_firstpass :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_firstpass(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_firstpass(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_firstpass(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_firstpass :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_vp9_firstpass :: (FILTER: *s16) -> s32 {
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

get_prob_in_vp9_firstpass :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_firstpass :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_firstpass(n0, DEN);
}

weighted_prob_in_vp9_firstpass :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_firstpass :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_firstpass(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_firstpass(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_firstpass :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_firstpass[COUNT];
        PROB := get_prob_in_vp9_firstpass(ct[0], DEN);
        return weighted_prob_in_vp9_firstpass(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_lsb_in_vp9_firstpass :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_firstpass :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_firstpass :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_firstpass(num_values) + 1 else 0;
}

is_zero_mv_in_vp9_firstpass :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_firstpass :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_firstpass :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_firstpass(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_firstpass(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_firstpass :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_firstpass :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_firstpass :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_firstpass :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

segfeature_active_in_vp9_firstpass :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_firstpass :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

get_band_translate_in_vp9_firstpass :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_firstpass :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_firstpass :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_firstpass(above_ec, left_ec);
}

vp9_is_valid_scale_in_vp9_firstpass :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_firstpass :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_firstpass(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_firstpass :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

is_inter_mode_in_vp9_firstpass :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_firstpass :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_firstpass :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_firstpass :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_firstpass :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_firstpass :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_firstpass :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_firstpass :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_firstpass(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_firstpass :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_firstpass(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_firstpass(MI, ib)];
}

get_uv_tx_size_in_vp9_firstpass :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_firstpass :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_firstpass :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_firstpass(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_firstpass :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_firstpass :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_firstpass :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_firstpass :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_firstpass :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_firstpass :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_firstpass :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_firstpass :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_firstpass :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_firstpass :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_firstpass :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_firstpass :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_firstpass :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_firstpass(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_firstpass :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_firstpass(cm.mi_cols);

        if get_plane_type_in_vp9_firstpass(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_firstpass(cm, xd);
}

get_partition_probs_in_vp9_firstpass :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_firstpass :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_firstpass :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_firstpass :: (
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

update_partition_context_in_vp9_firstpass :: (
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

partition_plane_context_in_vp9_firstpass :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

inter_predictor_in_vp9_firstpass :: (
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

scaled_buffer_offset_in_vp9_firstpass :: (x_offset: s32, y_offset: s32, stride: s32, sf: *Scale_Factors) -> s64 {
    X := (ifx sf != null then sf.scale_value_x(x_offset, sf) else x_offset);
    Y := (ifx sf != null then sf.scale_value_y(y_offset, sf) else y_offset);
    return ((cast,no_check(s64) Y) * cast(s64) stride) + cast(s64) X;
}

setup_pred_plane_in_vp9_firstpass :: (
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
    dst.buf = src + scaled_buffer_offset_in_vp9_firstpass(X, Y, stride, scale);
    dst.stride = stride;
}

vp8_set_reference_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_vp9_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

gcd_in_vp9_firstpass :: (a: s64, b: s32) -> s32 {
    while b != 0 {
        r := cast,no_check(s32) (a % cast(s64) b);
        a = cast,no_check(s64) b;
        b = r;
    }

    return cast,no_check(s32) a;
}

reduce_ratio_in_vp9_firstpass :: (ratio: *Rational64_T) {
    DENOM := gcd_in_vp9_firstpass(ratio.num, ratio.den);
    ratio.num /= cast,no_check(s64) DENOM;
    ratio.den /= DENOM;
}

cyclic_refresh_segment_id_boosted_in_vp9_firstpass :: (segment_id: s32) -> s32 {
    if segment_id == 1 || segment_id == 2 {
        return 1;
    }
    return 0;
}

cyclic_refresh_segment_id_in_vp9_firstpass :: (segment_id: s32) -> s32 {
    if segment_id == 1 {
        return 1;
    } else if segment_id == 2 {
        return 2;
    } else {
        return 0;
    }
}

fps_init_first_pass_info_in_vp9_firstpass :: (
    first_pass_info: *FIRST_PASS_INFO,
    stats: *FIRSTPASS_STATS_in_vp9_cx_iface,
    num_frames: s32
) {
    first_pass_info.stats = stats;
    first_pass_info.num_frames = num_frames;
}

fps_get_num_frames_in_vp9_firstpass :: (first_pass_info: *FIRST_PASS_INFO) -> s32 {
    return first_pass_info.num_frames;
}

fps_get_frame_stats_in_vp9_firstpass :: (
    first_pass_info: *FIRST_PASS_INFO,
    show_idx: s32
) -> *FIRSTPASS_STATS_in_vp9_cx_iface {
    if show_idx < 0 || show_idx >= first_pass_info.num_frames {
        return null;
    }
    return *(cast(*FIRSTPASS_STATS_in_vp9_cx_iface) (first_pass_info.stats))[show_idx];
}

vp9_init_first_pass :: (cpi: *VP9_COMP_in_vp9_encoder) {
    zero_stats_in_vp9_firstpass(*cpi.twopass.total_stats);
}

zero_stats_in_vp9_firstpass :: (section: *FIRSTPASS_STATS_in_vp9_cx_iface) {
    section.frame = 0.0;
    section.weight = 0.0;
    section.intra_error = 0.0;
    section.coded_error = 0.0;
    section.sr_coded_error = 0.0;
    section.frame_noise_energy = 0.0;
    section.pcnt_inter = 0.0;
    section.pcnt_motion = 0.0;
    section.pcnt_second_ref = 0.0;
    section.pcnt_neutral = 0.0;
    section.intra_skip_pct = 0.0;
    section.intra_smooth_pct = 0.0;
    section.pcnt_intra_low = 0.0;
    section.pcnt_intra_high = 0.0;
    section.inactive_zone_rows = 0.0;
    section.inactive_zone_cols = 0.0;
    section.new_mv_count = 0.0;
    section.m_vr = 0.0;
    section.mvr_abs = 0.0;
    section.m_vc = 0.0;
    section.mvc_abs = 0.0;
    section.m_vrv = 0.0;
    section.m_vcv = 0.0;
    section.mv_in_out_count = 0.0;
    section.count = 0.0;
    section.duration = 1.0;
    section.spatial_layer_id = 0;
}

vp9_first_pass :: (cpi: *VP9_COMP_in_vp9_encoder, source: *Lookahead_Entry_in_vp9_lookahead) {
    X := *cpi.td.mb;
    CM := *cpi.common;
    XD := *X.e_mbd;
    twopass := *cpi.twopass;

    LST_YV12 := get_ref_frame_buffer_in_vp9_firstpass(cpi, 1);
    gld_yv12 := get_ref_frame_buffer_in_vp9_firstpass(cpi, 2);
    NEW_YV12 := get_frame_new_buffer_in_vp9_firstpass(CM);
    first_ref_buf := LST_YV12;

    POOL := CM.buffer_pool;

    fp_temp_data: FIRSTPASS_DATA = ---;
    fp_acc_data := *fp_temp_data;

    fill_memory(*fp_temp_data, 0, size_of(FIRSTPASS_DATA));
    fp_acc_data.image_data_start_row = -1;

    set_first_pass_params(cpi);
    vp9_set_quantizer(cpi, find_fp_qindex(CM.bit_depth), 0);

    vp9_setup_block_planes(*X.e_mbd, CM.subsampling_x, CM.subsampling_y);

    vp9_setup_src_planes(X, cpi.source, 0, 0);
    vp9_setup_dst_planes(XD.plane.data, NEW_YV12, 0, 0);

    if frame_is_intra_only_in_vp9_firstpass(CM) == 0 {
        vp9_setup_pre_planes(XD, 0, first_ref_buf, 0, 0, null);
    }

    XD.mi = CM.mi_grid_visible;
    XD.mi[0] = CM.mi;

    vp9_frame_init_quantizer(cpi);

    X.skip_recode = 0;

    vp9_init_mv_probs(CM);
    vp9_initialize_rd_consts(cpi);

    CM.log2_tile_rows = 0;

    if cpi.row_mt_bit_exact != 0 && cpi.twopass.fp_mb_float_stats == null {
        cpi.twopass.fp_mb_float_stats =
            cast(*FP_MB_FLOAT_STATS) calloc_2(
                (cast,no_check(u64) CM.m_bs) * size_of(FP_MB_FLOAT_STATS),
                1
            );

        if cpi.twopass.fp_mb_float_stats == null {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate cpi->twopass.fp_mb_float_stats")
            );
        }
    }

    {
        fps: FIRSTPASS_STATS_in_vp9_cx_iface = ---;
        first_tile_col: *Tile_Data_Enc = ---;
        if cpi.row_mt == 0 {
            CM.log2_tile_cols = 0;
            cpi.row_mt_sync_read_ptr = vp9_row_mt_sync_read_dummy;
            cpi.row_mt_sync_write_ptr = vp9_row_mt_sync_write_dummy;
            first_pass_encode(cpi, fp_acc_data);
            first_pass_stat_calc(cpi, *fps, fp_acc_data);
        } else {
            cpi.row_mt_sync_read_ptr = vp9_row_mt_sync_read;
            cpi.row_mt_sync_write_ptr = vp9_row_mt_sync_write;
            if cpi.row_mt_bit_exact != 0 {
                CM.log2_tile_cols = 0;
                fill_memory(cpi.twopass.fp_mb_float_stats, 0, cast,no_check(u64) CM.m_bs * size_of(FP_MB_FLOAT_STATS));
            }
            vp9_encode_fp_row_mt(cpi);
            first_tile_col = *cpi.tile_data[0];
            if cpi.row_mt_bit_exact != 0 {
                accumulate_floating_point_stats(cpi, first_tile_col);
            }
            first_pass_stat_calc(cpi, *fps, *first_tile_col.fp_data);
        }

        fps.duration =
            ifx c_transpiler_float_greater(1.0, cast,no_check(float64) (source.ts_end - source.ts_start)) then 1.0 else cast,no_check(float64) (source.ts_end -
                source.ts_start);

        assignment_0: FIRSTPASS_STATS_in_vp9_cx_iface = fps;
        ((*twopass.this_frame_stats).*) = assignment_0;
        output_stats_in_vp9_firstpass(*twopass.this_frame_stats);
        accumulate_stats_in_vp9_firstpass(*twopass.total_stats, *fps);
    }

    if twopass.sr_update_lag > 3 ||
        CM.current_video_frame > 0 &&
            c_transpiler_float_greater(twopass.this_frame_stats.pcnt_inter, 0.2) &&
            c_transpiler_float_greater((twopass.this_frame_stats.intra_error / (ifx c_transpiler_float_less(twopass.this_frame_stats.coded_error, 0.0) then twopass.this_frame_stats.coded_error - 0.000001 else twopass.this_frame_stats.coded_error + 0.000001)), 2.0) {
        if gld_yv12 != null {
            ref_cnt_fb_in_vp9_firstpass(
                POOL.frame_bufs.data,
                CM.ref_frame_map.data + cpi.gld_fb_idx,
                CM.ref_frame_map[cpi.lst_fb_idx]
            );
        }
        twopass.sr_update_lag = 1;
    } else {
        twopass.sr_update_lag += 1;
    }

    extend_frame_borders_c(NEW_YV12);

    ref_cnt_fb_in_vp9_firstpass(POOL.frame_bufs.data, CM.ref_frame_map.data + cpi.lst_fb_idx, CM.new_fb_idx);

    if CM.current_video_frame == 0 && cpi.gld_fb_idx != -1 {
        ref_cnt_fb_in_vp9_firstpass(
            POOL.frame_bufs.data,
            CM.ref_frame_map.data + cpi.gld_fb_idx,
            CM.ref_frame_map[cpi.lst_fb_idx]
        );
    }

    update_frame_indexes_in_vp9_firstpass(CM, 1);
    if cpi.use_svc != 0 {
        vp9_inc_frame_in_layer(cpi);
    }
}

get_ref_frame_buffer_in_vp9_firstpass :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    ref_frame: MV_REFERENCE_FRAME
) -> *YV12_BUFFER_CONFIG {
    CM := *CPI.common;
    BUF_IDX := get_ref_frame_buf_idx_in_vp9_firstpass(CPI, cast,no_check(s32) ref_frame);
    return ifx BUF_IDX != -1 then *CM.buffer_pool.frame_bufs[BUF_IDX].buf else null;
}

get_ref_frame_buf_idx_in_vp9_firstpass :: (CPI: *VP9_COMP_in_vp9_encoder, ref_frame: s32) -> s32 {
    CM := *CPI.common;
    MAP_IDX := get_ref_frame_map_idx_in_vp9_firstpass(CPI, cast,no_check(MV_REFERENCE_FRAME) ref_frame);
    return ifx MAP_IDX != -1 then CM.ref_frame_map[MAP_IDX] else -1;
}

get_ref_frame_map_idx_in_vp9_firstpass :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame: MV_REFERENCE_FRAME) -> s32 {
    if ref_frame == 1 {
        return cpi.lst_fb_idx;
    } else if ref_frame == 2 {
        return cpi.gld_fb_idx;
    } else {
        return cpi.alt_fb_idx;
    }
}

accumulate_stats_in_vp9_firstpass :: (
    section: *FIRSTPASS_STATS_in_vp9_cx_iface,
    frame: *FIRSTPASS_STATS_in_vp9_cx_iface
) {
    section.frame += frame.frame;
    section.weight += frame.weight;
    section.spatial_layer_id = frame.spatial_layer_id;
    section.intra_error += frame.intra_error;
    section.coded_error += frame.coded_error;
    section.sr_coded_error += frame.sr_coded_error;
    section.frame_noise_energy += frame.frame_noise_energy;
    section.pcnt_inter += frame.pcnt_inter;
    section.pcnt_motion += frame.pcnt_motion;
    section.pcnt_second_ref += frame.pcnt_second_ref;
    section.pcnt_neutral += frame.pcnt_neutral;
    section.intra_skip_pct += frame.intra_skip_pct;
    section.intra_smooth_pct += frame.intra_smooth_pct;
    section.pcnt_intra_low += frame.pcnt_intra_low;
    section.pcnt_intra_high += frame.pcnt_intra_high;
    section.inactive_zone_rows += frame.inactive_zone_rows;
    section.inactive_zone_cols += frame.inactive_zone_cols;
    section.new_mv_count += frame.new_mv_count;
    section.m_vr += frame.m_vr;
    section.mvr_abs += frame.mvr_abs;
    section.m_vc += frame.m_vc;
    section.mvc_abs += frame.mvc_abs;
    section.m_vrv += frame.m_vrv;
    section.m_vcv += frame.m_vcv;
    section.mv_in_out_count += frame.mv_in_out_count;
    section.count += frame.count;
    section.duration += frame.duration;
}

output_stats_in_vp9_firstpass :: (stats: *FIRSTPASS_STATS_in_vp9_cx_iface) {
}

first_pass_stat_calc :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    fps: *FIRSTPASS_STATS_in_vp9_cx_iface,
    fp_acc_data: *FIRSTPASS_DATA
) {
    CM := *cpi.common;

    NUM_MBS := (ifx cpi.oxcf.resize_mode != cast,no_check(u32) RESIZE_NONE then cpi.initial_mbs else cpi.common.m_bs);
    MIN_ERR := 200.0 * c_transpiler_libm_sqrt(cast,no_check(float64) NUM_MBS);

    if fp_acc_data.image_data_start_row > CM.mb_rows / 2 || fp_acc_data.image_data_start_row == -1 {
        fp_acc_data.image_data_start_row = CM.mb_rows / 2;
    }

    if fp_acc_data.image_data_start_row > 0 {
        fp_acc_data.intra_skip_count =
            ifx 0 > fp_acc_data.intra_skip_count - fp_acc_data.image_data_start_row * CM.mb_cols * 2 then 0 else fp_acc_data.intra_skip_count -
                fp_acc_data.image_data_start_row * CM.mb_cols * 2;
    }

    fp_acc_data.intra_factor = fp_acc_data.intra_factor / cast,no_check(float64) NUM_MBS;
    fp_acc_data.brightness_factor = fp_acc_data.brightness_factor / cast,no_check(float64) NUM_MBS;
    fps.weight = fp_acc_data.intra_factor * fp_acc_data.brightness_factor;

    fps.frame = cast,no_check(float64) CM.current_video_frame;
    fps.spatial_layer_id = cast,no_check(s64) cpi.svc.spatial_layer_id;

    fps.coded_error = ((cast,no_check(float64) (fp_acc_data.coded_error >> 8)) + MIN_ERR) / NUM_MBS;
    fps.sr_coded_error = ((cast,no_check(float64) (fp_acc_data.sr_coded_error >> 8)) + MIN_ERR) / NUM_MBS;
    fps.intra_error = ((cast,no_check(float64) (fp_acc_data.intra_error >> 8)) + MIN_ERR) / NUM_MBS;

    fps.frame_noise_energy = (cast,no_check(float64) fp_acc_data.frame_noise_energy) / cast,no_check(float64) NUM_MBS;
    fps.count = 1.0;
    fps.pcnt_inter = (cast,no_check(float64) fp_acc_data.intercount) / NUM_MBS;
    fps.pcnt_second_ref = (cast,no_check(float64) fp_acc_data.second_ref_count) / NUM_MBS;
    fps.pcnt_neutral = fp_acc_data.neutral_count / NUM_MBS;
    fps.pcnt_intra_low = fp_acc_data.intra_count_low / NUM_MBS;
    fps.pcnt_intra_high = fp_acc_data.intra_count_high / NUM_MBS;
    fps.intra_skip_pct = (cast,no_check(float64) fp_acc_data.intra_skip_count) / NUM_MBS;
    fps.intra_smooth_pct = (cast,no_check(float64) fp_acc_data.intra_smooth_count) / NUM_MBS;
    fps.inactive_zone_rows = cast,no_check(float64) fp_acc_data.image_data_start_row;

    fps.inactive_zone_cols = 0.0;

    if fp_acc_data.mvcount > 0 {
        fps.new_mv_count = (cast,no_check(float64) fp_acc_data.new_mv_count) / NUM_MBS;
        fps.m_vr = (cast,no_check(float64) fp_acc_data.sum_mvr) / fp_acc_data.mvcount;
        fps.mvr_abs = (cast,no_check(float64) fp_acc_data.sum_mvr_abs) / fp_acc_data.mvcount;
        fps.m_vc = (cast,no_check(float64) fp_acc_data.sum_mvc) / fp_acc_data.mvcount;
        fps.mvc_abs = (cast,no_check(float64) fp_acc_data.sum_mvc_abs) / fp_acc_data.mvcount;
        fps.m_vrv =
            ((cast,no_check(float64) fp_acc_data.sum_mvrs) - (cast,no_check(float64) fp_acc_data.sum_mvr) * fp_acc_data.sum_mvr / fp_acc_data.mvcount) /
                fp_acc_data.mvcount;
        fps.m_vcv =
            ((cast,no_check(float64) fp_acc_data.sum_mvcs) - (cast,no_check(float64) fp_acc_data.sum_mvc) * fp_acc_data.sum_mvc / fp_acc_data.mvcount) /
                fp_acc_data.mvcount;
        fps.mv_in_out_count = (cast,no_check(float64) fp_acc_data.sum_in_vectors) / (fp_acc_data.mvcount * 2);
        fps.pcnt_motion = (cast,no_check(float64) fp_acc_data.mvcount) / NUM_MBS;
    } else {
        fps.new_mv_count = 0.0;
        fps.m_vr = 0.0;
        fps.mvr_abs = 0.0;
        fps.m_vc = 0.0;
        fps.mvc_abs = 0.0;
        fps.m_vrv = 0.0;
        fps.m_vcv = 0.0;
        fps.mv_in_out_count = 0.0;
        fps.pcnt_motion = 0.0;
    }
}

accumulate_floating_point_stats :: (cpi: *VP9_COMP_in_vp9_encoder, first_tile_col: *Tile_Data_Enc) {
    CM := *cpi.common;
    mb_col: s32 = ---;
    first_tile_col.fp_data.intra_factor = 0.0;
    first_tile_col.fp_data.brightness_factor = 0.0;
    first_tile_col.fp_data.neutral_count = 0.0;
    mb_row: s32 = 0;
    while mb_row < CM.mb_rows {
        mb_col = 0;
        while mb_col < CM.mb_cols {
            MB_INDEX := mb_row * CM.mb_cols + mb_col;
            first_tile_col.fp_data.intra_factor += cpi.twopass.fp_mb_float_stats[MB_INDEX].frame_mb_intra_factor;
            first_tile_col.fp_data.brightness_factor +=
                cpi.twopass.fp_mb_float_stats[MB_INDEX].frame_mb_brightness_factor;
            first_tile_col.fp_data.neutral_count += cpi.twopass.fp_mb_float_stats[MB_INDEX].frame_mb_neutral_count;
            mb_col += 1;
        }
        mb_row += 1;
    }
}

first_pass_encode :: (cpi: *VP9_COMP_in_vp9_encoder, fp_acc_data: *FIRSTPASS_DATA) {
    CM := *cpi.common;

    tile_data: Tile_Data_Enc = ---;
    tile := *tile_data.tile_info;
    zero_mv: MV;
    best_ref_mv: MV = ---;

    vp9_tile_init(tile, CM, 0, 0);
    tile_data.firstpass_top_mv = zero_mv;

    mb_row: s32 = 0;
    while mb_row < CM.mb_rows {
        best_ref_mv = zero_mv;
        vp9_first_pass_encode_tile_mb_row(cpi, *cpi.td, fp_acc_data, *tile_data, *best_ref_mv, mb_row);
        mb_row += 1;
    }
}

vp9_first_pass_encode_tile_mb_row :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    td: *Thread_Data_in_vp9_encoder,
    fp_acc_data: *FIRSTPASS_DATA,
    tile_data: *Tile_Data_Enc,
    best_ref_mv: *MV,
    mb_row: s32
) {
    mb_col: s32 = ---;
    X := *td.mb;
    CM := *cpi.common;
    XD := *X.e_mbd;
    tile := tile_data.tile_info;
    MB_COL_START := (tile.mi_col_start + (cast(s32) 1) << (((1 - 1)) & 31)) >> 1;
    MB_COL_END := (tile.mi_col_end + (cast(s32) 1) << (((1 - 1)) & 31)) >> 1;
    P := X.plane.data;
    PD := XD.plane.data;
    ctx := *td.pc_root.none;
    c: s32 = ---;
    num_mb_cols := get_num_cols_in_vp9_firstpass(tile_data.tile_info, 1);

    INTRAPENALTY: s32 = 1024;
    ZERO_MV: MV;

    LST_YV12 := get_ref_frame_buffer_in_vp9_firstpass(cpi, 1);
    gld_yv12 := get_ref_frame_buffer_in_vp9_firstpass(cpi, 2);
    NEW_YV12 := get_frame_new_buffer_in_vp9_firstpass(CM);
    first_ref_buf := LST_YV12;

    mi_above, mi_left: MODE_INFO = ---;

    mb_intra_factor: float64 = ---;
    mb_brightness_factor: float64 = ---;
    mb_neutral_count: float64 = ---;
    scaled_low_intra_thresh := scale_sse_threshold(CM, 24000);

    first_top_mv := *tile_data.firstpass_top_mv;
    last_nonzero_mv: MV;

    XD.mi = CM.mi_grid_visible + XD.mi_stride * mb_row << 1 + MB_COL_START;
    XD.mi[0] = CM.mi + XD.mi_stride * mb_row << 1 + MB_COL_START;

    for i: 0..cast(s32) 3 - 1 {
        P[i].coeff = ctx.coeff_pbuf[i][1];
        P[i].qcoeff = ctx.qcoeff_pbuf[i][1];
        PD[i].dqcoeff = ctx.dqcoeff_pbuf[i][1];
        P[i].eobs = ctx.eobs_pbuf[i][1];
    }

    recon_y_stride := NEW_YV12.y_stride;
    recon_uv_stride := NEW_YV12.uv_stride;
    uv_mb_height := (cast(s32) 16) >> ((cast(s32) (NEW_YV12.y_height > NEW_YV12.uv_height)) & 31);

    recon_yoffset := mb_row * recon_y_stride * 16 + MB_COL_START * 16;
    recon_uvoffset := mb_row * recon_uv_stride * uv_mb_height + MB_COL_START * uv_mb_height;

    X.mv_limits.row_min = -(mb_row * 16 + cast,no_check(s32) ((16 + 4)));
    X.mv_limits.row_max = (CM.mb_rows - 1 - mb_row) * 16 + cast,no_check(s32) ((16 + 4));

    mb_col = MB_COL_START;
    c = 0;
    while mb_col < MB_COL_END {
        USE_DC_PRED := cast(s32) ((mb_col != 0 || mb_row != 0) && (mb_col == 0 || mb_row == 0));
        BSIZE := get_bsize(CM, mb_row, mb_col);

        MB_INDEX := mb_row * CM.mb_cols + mb_col;

        cpi.row_mt_sync_read_ptr(*tile_data.row_mt_sync, mb_row, c);

        if mb_col == MB_COL_START {
            last_nonzero_mv = first_top_mv.*;
        }

        X.plane[0].src.buf = cpi.source.y_buffer + mb_row * 16 * X.plane[0].src.stride + mb_col * 16;
        X.plane[1].src.buf =
            cpi.source.u_buffer + mb_row * uv_mb_height * X.plane[1].src.stride +
                mb_col * uv_mb_height;
        X.plane[2].src.buf =
            cpi.source.v_buffer + mb_row * uv_mb_height * X.plane[1].src.stride +
                mb_col * uv_mb_height;

        XD.plane[0].dst.buf = NEW_YV12.y_buffer + recon_yoffset;
        XD.plane[1].dst.buf = NEW_YV12.u_buffer + recon_uvoffset;
        XD.plane[2].dst.buf = NEW_YV12.v_buffer + recon_uvoffset;
        XD.mi[0].sb_type = BSIZE;
        XD.mi[0].ref_frame[0] = 0;
        set_mi_row_col_in_vp9_firstpass(
            XD,
            *tile,
            mb_row << 1,
            cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[BSIZE],
            mb_col << 1,
            cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[BSIZE],
            CM.mi_rows,
            CM.mi_cols
        );

        XD.above_mi = ifx mb_row != 0 then *mi_above else null;
        XD.left_mi = ifx mb_col << 1 > tile.mi_col_start then *mi_left else null;

        X.skip_encode = 0;
        X.fp_src_pred = 0;

        if mb_col == MB_COL_START && mb_col != 0 {
            XD.left_mi = *mi_left;
            X.fp_src_pred = 1;
        }
        XD.mi[0].mode = 0;
        XD.mi[0].tx_size =
            cast,no_check(TX_SIZE) ((ifx USE_DC_PRED != 0 then (ifx BSIZE >= 6 then cast,no_check(s32) (cast(TX_SIZE) 2) else cast,no_check(s32) (cast(TX_SIZE) 1)) else cast,no_check(s32) (cast(TX_SIZE) 0)));

        fill_memory(X.plane[0].src_diff.data, 0, cast(u64) 256 * size_of(s16));
        vp9_encode_intra_block_plane(X, BSIZE, 0, 0);
        this_error := cast,no_check(s32) get_mb_ss_c(X.plane[0].src_diff.data);
        this_intra_error := this_error;

        if this_error < get_ul_intra_threshold(CM) {
            fp_acc_data.intra_skip_count += 1;
        } else if mb_col > 0 && fp_acc_data.image_data_start_row == -1 {
            fp_acc_data.image_data_start_row = mb_row;
        }

        if this_error < get_smooth_intra_threshold(CM) {
            fp_acc_data.intra_smooth_count += 1;
        }

        if CM.current_video_frame == 0 {
            if this_intra_error < scale_sse_threshold(CM, 24000) {
                fp_acc_data.frame_noise_energy += cast,no_check(s64) fp_estimate_block_noise(X, BSIZE);
            } else {
                fp_acc_data.frame_noise_energy += cast,no_check(s64) (cast(float64) 250.0);
            }
        }

        log_intra := c_transpiler_math_log((cast,no_check(float64) this_error) + 1.0);
        if c_transpiler_float_less(log_intra, 10.0) {
            mb_intra_factor = 1.0 + (10.0 - log_intra) * 0.05;
            fp_acc_data.intra_factor += mb_intra_factor;
            if cpi.row_mt_bit_exact != 0 {
                cpi.twopass.fp_mb_float_stats[MB_INDEX].frame_mb_intra_factor = mb_intra_factor;
            }
        } else {
            fp_acc_data.intra_factor += 1.0;
            if cpi.row_mt_bit_exact != 0 {
                cpi.twopass.fp_mb_float_stats[MB_INDEX].frame_mb_intra_factor = 1.0;
            }
        }

        level_sample := cast,no_check(s32) X.plane[0].src.buf[0];

        if level_sample < 64 && c_transpiler_float_less(log_intra, 9.0) {
            mb_brightness_factor = 1.0 + 0.01 * cast,no_check(float64) (64 - level_sample);
            fp_acc_data.brightness_factor += mb_brightness_factor;
            if cpi.row_mt_bit_exact != 0 {
                cpi.twopass.fp_mb_float_stats[MB_INDEX].frame_mb_brightness_factor = mb_brightness_factor;
            }
        } else {
            fp_acc_data.brightness_factor += 1.0;
            if cpi.row_mt_bit_exact != 0 {
                cpi.twopass.fp_mb_float_stats[MB_INDEX].frame_mb_brightness_factor = 1.0;
            }
        }

        this_error += INTRAPENALTY;

        fp_acc_data.intra_error += cast,no_check(s64) this_error;

        X.mv_limits.col_min = -(mb_col * 16 + cast,no_check(s32) ((16 + 4)));
        X.mv_limits.col_max = (CM.mb_cols - 1 - mb_col) * 16 + cast,no_check(s32) ((16 + 4));

        if frame_is_intra_only_in_vp9_firstpass(CM) == 0 {
            tmp_err: s32 = ---;

            mv: MV;
            tmp_mv: MV;
            unscaled_last_source_buf_2d: Buf_2d = ---;
            v_fn_ptr := cpi.fn_ptr[BSIZE];

            XD.plane[0].pre[0].buf = first_ref_buf.y_buffer + recon_yoffset;

            motion_error :=
                cast,no_check(s32) get_prediction_error_in_vp9_firstpass(
                    BSIZE,
                    *X.plane[0].src,
                    XD.plane[0].pre.data + 0
                );
            this_motion_error := motion_error;

            unscaled_last_source_buf_2d.buf = cpi.unscaled_last_source.y_buffer + recon_yoffset;
            unscaled_last_source_buf_2d.stride = cpi.unscaled_last_source.y_stride;

            raw_motion_error :=
                cast,no_check(s32) get_prediction_error_in_vp9_firstpass(
                    BSIZE,
                    *X.plane[0].src,
                    *unscaled_last_source_buf_2d
                );

            if raw_motion_error > 128 {
                first_pass_motion_search_in_vp9_firstpass(cpi, X, best_ref_mv, *mv, *motion_error);

                v_fn_ptr.vf = get_block_variance_fn(BSIZE);

                this_motion_error = vp9_get_mvpred_var(X, *mv, best_ref_mv, *v_fn_ptr, 0);

                if is_zero_mv_in_vp9_firstpass(best_ref_mv) == 0 {
                    tmp_err = 2147483647;
                    first_pass_motion_search_in_vp9_firstpass(cpi, X, *ZERO_MV, *tmp_mv, *tmp_err);

                    if tmp_err < motion_error {
                        motion_error = tmp_err;
                        mv = tmp_mv;
                        this_motion_error = vp9_get_mvpred_var(X, *tmp_mv, *ZERO_MV, *v_fn_ptr, 0);
                    }
                }

                if CM.current_video_frame > 1 && gld_yv12 != null {
                    XD.plane[0].pre[0].buf = gld_yv12.y_buffer + recon_yoffset;

                    gf_motion_error :=
                        cast,no_check(s32) get_prediction_error_in_vp9_firstpass(
                            BSIZE,
                            *X.plane[0].src,
                            XD.plane[0].pre.data + 0
                        );

                    first_pass_motion_search_in_vp9_firstpass(cpi, X, *ZERO_MV, *tmp_mv, *gf_motion_error);

                    if gf_motion_error < motion_error && gf_motion_error < this_error {
                        fp_acc_data.second_ref_count += 1;
                    }

                    XD.plane[0].pre[0].buf = first_ref_buf.y_buffer + recon_yoffset;
                    XD.plane[1].pre[0].buf = first_ref_buf.u_buffer + recon_uvoffset;
                    XD.plane[2].pre[0].buf = first_ref_buf.v_buffer + recon_uvoffset;

                    if gf_motion_error < this_error {
                        fp_acc_data.sr_coded_error += cast,no_check(s64) gf_motion_error;
                    } else {
                        fp_acc_data.sr_coded_error += cast,no_check(s64) this_error;
                    }
                } else {
                    fp_acc_data.sr_coded_error += cast,no_check(s64) motion_error;
                }
            } else {
                fp_acc_data.sr_coded_error += cast,no_check(s64) motion_error;
            }

            best_ref_mv.row = 0;
            best_ref_mv.col = 0;

            if motion_error <= this_error {
                if (this_error - INTRAPENALTY) * 9 <= motion_error * 10 && this_error < 2 * INTRAPENALTY {
                    fp_acc_data.neutral_count += 1.0;
                    if cpi.row_mt_bit_exact != 0 {
                        cpi.twopass.fp_mb_float_stats[MB_INDEX].frame_mb_neutral_count = 1.0;
                    }
                } else if this_error > 8192 && this_error < 3 * motion_error {
                    mb_neutral_count =
                        (cast,no_check(float64) motion_error) /
                            (ifx c_transpiler_float_less(cast,no_check(float64) this_error, 0.0) then (cast,no_check(float64) this_error) - 0.000001 else (cast,no_check(float64) this_error) + 0.000001);
                    fp_acc_data.neutral_count += mb_neutral_count;
                    if cpi.row_mt_bit_exact != 0 {
                        cpi.twopass.fp_mb_float_stats[MB_INDEX].frame_mb_neutral_count = mb_neutral_count;
                    }
                }

                mv.row = cast,no_check(s16) ((cast,no_check(s32) mv.row) * 8);
                mv.col = cast,no_check(s16) ((cast,no_check(s32) mv.col) * 8);
                this_error = motion_error;
                XD.mi[0].mode = 13;
                XD.mi[0].mv[0].as_mv = mv;
                XD.mi[0].tx_size = 0;
                XD.mi[0].ref_frame[0] = 1;
                XD.mi[0].ref_frame[1] = -1;
                vp9_build_inter_predictors_sby(XD, mb_row << 1, mb_col << 1, BSIZE);
                vp9_encode_sby_pass1(X, BSIZE);
                fp_acc_data.sum_mvr += cast,no_check(s32) mv.row;
                fp_acc_data.sum_mvr_abs += absolute_value(cast,no_check(s32) mv.row);
                fp_acc_data.sum_mvc += cast,no_check(s32) mv.col;
                fp_acc_data.sum_mvc_abs += absolute_value(cast,no_check(s32) mv.col);
                fp_acc_data.sum_mvrs += cast,no_check(s64) ((cast(s32) mv.row) * cast(s32) mv.row);
                fp_acc_data.sum_mvcs += cast,no_check(s64) ((cast(s32) mv.col) * cast(s32) mv.col);
                fp_acc_data.intercount += 1;

                best_ref_mv.* = mv;

                if is_zero_mv_in_vp9_firstpass(*mv) == 0 {
                    fp_acc_data.mvcount += 1;
                    if is_equal_mv_in_vp9_firstpass(*mv, *last_nonzero_mv) == 0 {
                        fp_acc_data.new_mv_count += 1;
                    }
                    last_nonzero_mv = mv;

                    if mb_row < CM.mb_rows / 2 {
                        if mv.row > 0 {
                            fp_acc_data.sum_in_vectors -= 1;
                        } else if mv.row < 0 {
                            fp_acc_data.sum_in_vectors += 1;
                        }
                    } else if mb_row > CM.mb_rows / 2 {
                        if mv.row > 0 {
                            fp_acc_data.sum_in_vectors += 1;
                        } else if mv.row < 0 {
                            fp_acc_data.sum_in_vectors -= 1;
                        }
                    }

                    if mb_col < CM.mb_cols / 2 {
                        if mv.col > 0 {
                            fp_acc_data.sum_in_vectors -= 1;
                        } else if mv.col < 0 {
                            fp_acc_data.sum_in_vectors += 1;
                        }
                    } else if mb_col > CM.mb_cols / 2 {
                        if mv.col > 0 {
                            fp_acc_data.sum_in_vectors += 1;
                        } else if mv.col < 0 {
                            fp_acc_data.sum_in_vectors -= 1;
                        }
                    }
                }
                if this_intra_error < scaled_low_intra_thresh {
                    fp_acc_data.frame_noise_energy += cast,no_check(s64) fp_estimate_block_noise(X, BSIZE);
                } else {
                    fp_acc_data.frame_noise_energy += cast,no_check(s64) (cast(float64) 250.0);
                }
            } else if this_intra_error < scaled_low_intra_thresh {
                fp_acc_data.frame_noise_energy += cast,no_check(s64) fp_estimate_block_noise(X, BSIZE);
                if this_motion_error < scaled_low_intra_thresh {
                    fp_acc_data.intra_count_low += 1.0;
                } else {
                    fp_acc_data.intra_count_high += 1.0;
                }
            } else {
                fp_acc_data.frame_noise_energy += cast,no_check(s64) (cast(float64) 250.0);
                fp_acc_data.intra_count_high += 1.0;
            }
        } else {
            fp_acc_data.sr_coded_error += cast,no_check(s64) this_error;
        }
        fp_acc_data.coded_error += cast,no_check(s64) this_error;

        if mb_col == MB_COL_START {
            first_top_mv.* = last_nonzero_mv;
        }
        recon_yoffset += 16;
        recon_uvoffset += uv_mb_height;

        if cpi.row_mt != 0 && mb_col == MB_COL_END - 1 {
            accumulate_fp_mb_row_stat(tile_data, fp_acc_data);
        }

        cpi.row_mt_sync_write_ptr(*tile_data.row_mt_sync, mb_row, c, num_mb_cols);
        mb_col += 1;
        c += 1;
    }
}

get_num_cols_in_vp9_firstpass :: (tile: Tile_Info, shift: s32) -> s32 {
    num_cols := (tile.mi_col_end - tile.mi_col_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_cols;
}

accumulate_fp_mb_row_stat :: (this_tile: *Tile_Data_Enc, fp_acc_data: *FIRSTPASS_DATA) {
    this_tile.fp_data.intra_factor += fp_acc_data.intra_factor;
    this_tile.fp_data.brightness_factor += fp_acc_data.brightness_factor;
    this_tile.fp_data.coded_error += fp_acc_data.coded_error;
    this_tile.fp_data.sr_coded_error += fp_acc_data.sr_coded_error;
    this_tile.fp_data.frame_noise_energy += fp_acc_data.frame_noise_energy;
    this_tile.fp_data.intra_error += fp_acc_data.intra_error;
    this_tile.fp_data.intercount += fp_acc_data.intercount;
    this_tile.fp_data.second_ref_count += fp_acc_data.second_ref_count;
    this_tile.fp_data.neutral_count += fp_acc_data.neutral_count;
    this_tile.fp_data.intra_count_low += fp_acc_data.intra_count_low;
    this_tile.fp_data.intra_count_high += fp_acc_data.intra_count_high;
    this_tile.fp_data.intra_skip_count += fp_acc_data.intra_skip_count;
    this_tile.fp_data.new_mv_count += fp_acc_data.new_mv_count;
    this_tile.fp_data.mvcount += fp_acc_data.mvcount;
    this_tile.fp_data.sum_mvr += fp_acc_data.sum_mvr;
    this_tile.fp_data.sum_mvr_abs += fp_acc_data.sum_mvr_abs;
    this_tile.fp_data.sum_mvc += fp_acc_data.sum_mvc;
    this_tile.fp_data.sum_mvc_abs += fp_acc_data.sum_mvc_abs;
    this_tile.fp_data.sum_mvrs += fp_acc_data.sum_mvrs;
    this_tile.fp_data.sum_mvcs += fp_acc_data.sum_mvcs;
    this_tile.fp_data.sum_in_vectors += fp_acc_data.sum_in_vectors;
    this_tile.fp_data.intra_smooth_count += fp_acc_data.intra_smooth_count;
    MIN_START_ROW :=
        (ifx this_tile.fp_data.image_data_start_row < fp_acc_data.image_data_start_row then this_tile.fp_data.image_data_start_row else fp_acc_data.image_data_start_row);
    this_tile.fp_data.image_data_start_row =
        ifx MIN_START_ROW == -1 then (ifx this_tile.fp_data.image_data_start_row > fp_acc_data.image_data_start_row then this_tile.fp_data.image_data_start_row else fp_acc_data.image_data_start_row) else MIN_START_ROW;
}

scale_sse_threshold :: (cm: *VP9_COMMON, thresh: s32) -> s32 {
    ret_val := thresh;

    return ret_val;
}

get_bsize :: (cm: *VP9_COMMON, mb_row: s32, mb_col: s32) -> BLOCK_SIZE {
    if 2 * mb_col + 1 < cm.mi_cols {
        if 2 * mb_row + 1 < cm.mi_rows {
            return 6;
        }
        return 5;
    } else {
        if 2 * mb_row + 1 < cm.mi_rows {
            return 4;
        }
        return 3;
    }
}

fp_estimate_block_noise :: (x: *MACROBLOCK, bsize: BLOCK_SIZE) -> s32 {
    src_ptr := *x.plane[0].src.buf[0];
    WIDTH := (cast(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[bsize]) * 4;
    HEIGHT := (cast(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[bsize]) * 4;
    w: s32 = ---;
    stride := x.plane[0].src.stride;
    block_noise: s32 = 0;

    h: s32 = 0;
    while h < HEIGHT {
        w = 0;
        while w < WIDTH {
            block_noise += fp_estimate_point_noise(src_ptr, stride);

            src_ptr += 1;
            w += 2;
        }
        src_ptr += stride - WIDTH;
        h += 2;
    }
    return block_noise << 2;
}

fp_estimate_point_noise :: (src_ptr: *u8, STRIDE: s32) -> s32 {
    sum_weight: s32 = 0;
    sum_val: s32 = 0;
    j: s32 = ---;
    max_diff: s32 = 0;
    diff: s32 = ---;

    centre_val := src_ptr.*;

    kernel_ptr := fp_dn_kernel_3.data;

    tmp_ptr := src_ptr - STRIDE - 1;
    for i: 0..cast(s32) 3 - 1 {
        j = 0;
        while j < 3 {
            diff = absolute_value((cast,no_check(s32) centre_val) - cast,no_check(s32) tmp_ptr[j]);
            max_diff = max(max_diff, diff);
            if diff <= 8 {
                sum_weight += cast,no_check(s32) kernel_ptr.*;
                sum_val += (cast,no_check(s32) tmp_ptr[j]) * cast,no_check(s32) kernel_ptr.*;
            }
            kernel_ptr += 1;
            j += 1;
        }
        tmp_ptr += STRIDE;
    }

    dn_val: u8 = ifx max_diff < 24
        then cast,no_check(u8) ((sum_val + sum_weight >> 1) / sum_weight)
        else src_ptr.*;

    dn_diff := (cast,no_check(s32) src_ptr.*) - cast,no_check(s32) dn_val;
    return dn_diff * dn_diff;
}

first_pass_motion_search_in_vp9_firstpass :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    ref_mv: *MV,
    best_mv: *MV,
    best_motion_err: *s32
) {
    XD := *x.e_mbd;
    tmp_mv: MV;
    ref_mv_full :=
        MV.{row = cast,no_check(s16) ((cast(s32) ref_mv.row) >> 3), col = cast,no_check(s16) ((cast(s32) ref_mv.col) >> 3)};
    num00: s32 = ---;
    BSIZE := XD.mi[0].sb_type;
    v_fn_ptr := cpi.fn_ptr[BSIZE];
    NEW_MV_MODE_PENALTY_: s32 = 32;
    center_mv_full := ref_mv_full;

    sad_fn_ptr: Vp9_Sad_Fn_Ptr_T = ---;

    step_param: s32 = 3;
    further_steps := (cast,no_check(s32) ((11 - 1))) - step_param;
    SR := get_search_range(cpi);
    TMP_MV_LIMITS := x.mv_limits;
    step_param += SR;
    further_steps -= SR;

    if intersect_limits_with_mv_max(*x.mv_limits, ref_mv) == 0 {
        return;
    }

    v_fn_ptr.vf = get_block_variance_fn(BSIZE);

    clamp_mv_in_vp9_firstpass(
        *ref_mv_full,
        x.mv_limits.col_min,
        x.mv_limits.col_max,
        x.mv_limits.row_min,
        x.mv_limits.row_max
    );
    start_mv_sad :=
        get_start_mv_sad_in_vp9_firstpass(
            x,
            *ref_mv_full,
            *center_mv_full,
            cast,no_check(Sad_Fn_T) (cpi.fn_ptr[BSIZE].sdf),
            x.sadperbit16
        );
    sad_fn_ptr.sdf = cpi.fn_ptr[BSIZE].sdf;
    sad_fn_ptr.sdx4df = cpi.fn_ptr[BSIZE].sdx4df;

    tmp_err :=
        cpi.diamond_search_sad(
            x,
            *cpi.ss_cfg,
            *ref_mv_full,
            start_mv_sad,
            *tmp_mv,
            step_param,
            x.sadperbit16,
            *num00,
            *sad_fn_ptr,
            ref_mv
        );
    if tmp_err < 2147483647 {
        tmp_err = vp9_get_mvpred_var(x, *tmp_mv, ref_mv, *v_fn_ptr, 1);
    }
    if tmp_err < 2147483647 - NEW_MV_MODE_PENALTY_ {
        tmp_err += NEW_MV_MODE_PENALTY_;
    }

    if tmp_err < best_motion_err.* {
        best_motion_err.* = tmp_err;
        best_mv.* = tmp_mv;
    }

    n := num00;
    num00 = 0;

    while n < further_steps {
        n += 1;

        if num00 != 0 {
            num00 -= 1;
        } else {
            tmp_err =
                cpi.diamond_search_sad(
                    x,
                    *cpi.ss_cfg,
                    *ref_mv_full,
                    start_mv_sad,
                    *tmp_mv,
                    step_param + n,
                    x.sadperbit16,
                    *num00,
                    *sad_fn_ptr,
                    ref_mv
                );
            if tmp_err < 2147483647 {
                tmp_err = vp9_get_mvpred_var(x, *tmp_mv, ref_mv, *v_fn_ptr, 1);
            }
            if tmp_err < 2147483647 - NEW_MV_MODE_PENALTY_ {
                tmp_err += NEW_MV_MODE_PENALTY_;
            }

            if tmp_err < best_motion_err.* {
                best_motion_err.* = tmp_err;
                best_mv.* = tmp_mv;
            }
        }
    }
    x.mv_limits = TMP_MV_LIMITS;
}

get_start_mv_sad_in_vp9_firstpass :: (
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
    start_mv_sad += cast,no_check(u32) mvsad_err_cost_in_vp9_firstpass(x, mvp_full, ref_mv_full, sadpb);

    return start_mv_sad;
}

mvsad_err_cost_in_vp9_firstpass :: (x: *MACROBLOCK, mv: *MV, ref: *MV, sad_per_bit: s32) -> s32 {
    diff: MV = ---;
    diff.row = cast,no_check(s16) ((cast(s32) mv.row) - cast(s32) ref.row);
    diff.col = cast,no_check(s16) ((cast(s32) mv.col) - cast(s32) ref.col);
    return cast,no_check(s32) ((((cast,no_check(u32) mv_cost_in_vp9_firstpass(*diff, x.nmvjointsadcost.data, x.nmvsadcost.data)) * cast,no_check(u32) sad_per_bit) + cast,no_check(u32) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9);
}

mv_cost_in_vp9_firstpass :: (mv: *MV, joint_cost: *s32, comp_cost: **s32) -> s32 {
    return joint_cost[vp9_get_mv_joint_in_vp9_firstpass(mv)] + comp_cost[0][mv.row] + comp_cost[1][mv.col];
}

get_block_variance_fn :: (bsize: BLOCK_SIZE) -> Variance_Fn_T {
    if cast,no_check(s32) bsize == {
        case 3;
            return mse8x8_c;
        case 5;
            return mse16x8_c;
        case 4;
            return mse8x16_c;
        case;
            return mse16x16_c;
    }
    return unreachable_value(Variance_Fn_T);
}

intersect_limits_with_mv_max :: (mv_limits: *Mv_Limits, ref_mv: *MV) -> s32 {
    ROW_MIN :=
        (ifx mv_limits.row_min > ((cast(s32) ref_mv.row) + 7 - ((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1)) >> 3 then mv_limits.row_min else ((cast(s32) ref_mv.row) +
            7 - ((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1)) >> 3);
    ROW_MAX :=
        (ifx mv_limits.row_max < ((cast(s32) ref_mv.row) - 1 + ((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1)) >> 3 then mv_limits.row_max else ((cast(s32) ref_mv.row) -
            1 + ((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1)) >> 3);
    COL_MIN :=
        (ifx mv_limits.col_min > ((cast(s32) ref_mv.col) + 7 - ((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1)) >> 3 then mv_limits.col_min else ((cast(s32) ref_mv.col) +
            7 - ((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1)) >> 3);
    COL_MAX :=
        (ifx mv_limits.col_max < ((cast(s32) ref_mv.col) - 1 + ((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1)) >> 3 then mv_limits.col_max else ((cast(s32) ref_mv.col) -
            1 + ((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1)) >> 3);
    if ROW_MIN > ROW_MAX || COL_MIN > COL_MAX {
        return 0;
    }
    mv_limits.row_min = ROW_MIN;
    mv_limits.row_max = ROW_MAX;
    mv_limits.col_min = COL_MIN;
    mv_limits.col_max = COL_MAX;
    return 1;
}

get_search_range :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    sr: s32 = 0;
    dim := (ifx cpi.initial_width < cpi.initial_height then cpi.initial_width else cpi.initial_height);
    dim = ifx dim > (cast(s32) 1) << 3 then dim else (cast(s32) 1) << 3;

    while dim << ((sr) & 31) < (cast(s32) 1) << (((11 - 1)) & 31) - 1 {
        sr += 1;
    }
    return sr;
}

get_prediction_error_in_vp9_firstpass :: (bsize: BLOCK_SIZE, src: *Buf_2d, ref: *Buf_2d) -> u32 {
    sse: u32 = ---;
    FN := get_block_variance_fn(bsize);
    FN(src.buf, src.stride, ref.buf, ref.stride, *sse);
    return sse;
}

get_smooth_intra_threshold :: (cm: *VP9_COMMON) -> s32 {
    ret_val: s32 = 4000;

    return ret_val;
}

get_ul_intra_threshold :: (cm: *VP9_COMMON) -> s32 {
    ret_val: s32 = 50;

    return ret_val;
}

find_fp_qindex :: (bit_depth: Bit_Depth_T) -> s32 {
    i: s32 = 0;
    while i < (cast,no_check(s32) ((255 - 0))) + 1 {
        if c_transpiler_float_greater_equal(vp9_convert_qindex_to_q(i, bit_depth), 10.0) {
            break;
        }
        i += 1;
    }

    if i == (cast,no_check(s32) ((255 - 0))) + 1 {
        i -= 1;
    }

    return i;
}

set_first_pass_params :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    if cpi.refresh_alt_ref_frame == 0 &&
        (CM.current_video_frame == 0 || cpi.frame_flags & cast,no_check(s32) (FRAMEFLAGS_KEY_in_vp9_cx_iface) != 0) {
        CM.frame_type = cast,no_check(FRAME_TYPE) KEY_FRAME;
    } else {
        CM.frame_type = cast,no_check(FRAME_TYPE) INTER_FRAME;
    }

    cpi.rc.frames_to_key = 2147483647;
}

vp9_end_first_pass :: (cpi: *VP9_COMP_in_vp9_encoder) {
    output_stats_in_vp9_firstpass(*cpi.twopass.total_stats);
    cpi.twopass.first_pass_done = 1;
    deallocate_memory(cast(*void) cpi.twopass.fp_mb_float_stats);
    cpi.twopass.fp_mb_float_stats = null;
}

vp9_init_second_pass :: (cpi: *VP9_COMP_in_vp9_encoder) {
    OXCF := *cpi.oxcf;
    RC := *cpi.rc;
    TWOPASS := *cpi.twopass;

    zero_stats_in_vp9_firstpass(*TWOPASS.total_stats);
    zero_stats_in_vp9_firstpass(*TWOPASS.total_left_stats);

    if TWOPASS.stats_in_end == null {
        return;
    }

    stats := *TWOPASS.total_stats;

    assignment_1: FIRSTPASS_STATS_in_vp9_cx_iface = TWOPASS.stats_in_end.*;
    ((stats).*) = assignment_1;
    assignment_2: FIRSTPASS_STATS_in_vp9_cx_iface = stats.*;
    ((*TWOPASS.total_left_stats).*) = assignment_2;

    {
        modified_score_total: float64 = 0.0;
        s := TWOPASS.stats_in;
        av_err: float64 = ---;

        if OXCF.vbr_corpus_complexity != 0 {
            TWOPASS.mean_mod_score = (cast,no_check(float64) OXCF.vbr_corpus_complexity) / 10.0;
            av_err = get_distribution_av_err(cpi, TWOPASS);
        } else {
            av_err = get_distribution_av_err(cpi, TWOPASS);

            while s < TWOPASS.stats_in_end {
                modified_score_total += calculate_mod_frame_score(cpi, OXCF, s, av_err);
                s += 1;
            }

            TWOPASS.mean_mod_score =
                modified_score_total /
                    (ifx c_transpiler_float_less(stats.count, 0.0) then stats.count - 0.000001 else stats.count + 0.000001);
        }

        modified_score_total = 0.0;
        s = TWOPASS.stats_in;
        while s < TWOPASS.stats_in_end {
            modified_score_total += calculate_norm_frame_score(cpi, TWOPASS, OXCF, s, av_err);
            s += 1;
        }
        TWOPASS.normalized_score_left = modified_score_total;

        if OXCF.vbr_corpus_complexity != 0 {
            OXCF.target_bandwidth =
                cast,no_check(s64) ((cast,no_check(float64) OXCF.target_bandwidth) *
                    (TWOPASS.normalized_score_left / stats.count));
        }
    }

    frame_rate := 10000000.0 * stats.count / stats.duration;

    vp9_new_framerate(cpi, frame_rate);
    TWOPASS.bits_left = cast,no_check(s64) (stats.duration * OXCF.target_bandwidth / 10000000.0);

    TWOPASS.sr_update_lag = 1;

    RC.vbr_bits_off_target = 0;
    RC.vbr_bits_off_target_fast = 0;
    RC.rate_error_estimate = 0;

    TWOPASS.kf_zeromotion_pct = 100;
    TWOPASS.last_kfgroup_zeromotion_pct = 100;

    TWOPASS.bpm_factor = 1.0;

    TWOPASS.rolling_arf_group_target_bits = 1;
    TWOPASS.rolling_arf_group_actual_bits = 1;

    if OXCF.resize_mode != cast,no_check(u32) RESIZE_NONE {
        init_subsampling(cpi);
    }

    TWOPASS.arnr_strength_adjustment = 0;
}

init_subsampling :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    RC := *cpi.rc;
    W := CM.width;
    H := CM.height;

    i: s32 = 0;
    while i < FRAME_SCALE_STEPS {
        RC.frame_width[i] = W * 16 / FRAME_SCALE_FACTOR_in_vp9_firstpass[i];
        RC.frame_height[i] = H * 16 / FRAME_SCALE_FACTOR_in_vp9_firstpass[i];
        i += 1;
    }

    setup_rf_level_maxq(cpi);
}

setup_rf_level_maxq :: (cpi: *VP9_COMP_in_vp9_encoder) {
    RC := *cpi.rc;
    i := cast,no_check(s32) (INTER_NORMAL);
    while i < RATE_FACTOR_LEVELS {
        qdelta := vp9_frame_type_qdelta(cpi, i, RC.worst_quality);
        RC.rf_level_maxq[i] =
            ifx RC.worst_quality + qdelta > RC.best_quality then RC.worst_quality +
                qdelta else RC.best_quality;
        i += 1;
    }
}

calculate_norm_frame_score :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    twopass: *TWO_PASS,
    oxcf: *VP9_Encoder_Config,
    this_frame: *FIRSTPASS_STATS_in_vp9_cx_iface,
    AV_ERR: float64
) -> float64 {
    return calc_norm_frame_score(oxcf, *cpi.frame_info, this_frame, twopass.mean_mod_score, AV_ERR);
}

calc_norm_frame_score :: (
    oxcf: *VP9_Encoder_Config,
    frame_info: *FRAME_INFO,
    this_frame: *FIRSTPASS_STATS_in_vp9_cx_iface,
    mean_mod_score: float64,
    av_err: float64
) -> float64 {
    modified_score :=
        av_err * c_transpiler_math_pow(
            this_frame.coded_error * this_frame.weight /
            (ifx c_transpiler_float_less(av_err, 0.0) then av_err - 0.000001 else av_err + 0.000001),
            (cast,no_check(float64) oxcf.two_pass_vbrbias) / 100.0
        );

    MIN_SCORE := (cast,no_check(float64) oxcf.two_pass_vbrmin_section) / 100.0;
    MAX_SCORE := (cast,no_check(float64) oxcf.two_pass_vbrmax_section) / 100.0;

    modified_score *= c_transpiler_math_pow(calculate_active_area(frame_info, this_frame), 0.5);

    modified_score /=
        (ifx c_transpiler_float_less(mean_mod_score, 0.0) then mean_mod_score -
            0.000001 else mean_mod_score + 0.000001);
    return fclamp_in_vp9_firstpass(modified_score, MIN_SCORE, MAX_SCORE);
}

calculate_active_area :: (frame_info: *FRAME_INFO, this_frame: *FIRSTPASS_STATS_in_vp9_cx_iface) -> float64 {
    active_pct :=
        1.0 -
            (this_frame.intra_skip_pct / 2.0 + this_frame.inactive_zone_rows * 2.0 / cast,no_check(float64) frame_info.mb_rows);
    return fclamp_in_vp9_firstpass(active_pct, 0.5, 1.0);
}

calculate_mod_frame_score :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    oxcf: *VP9_Encoder_Config,
    this_frame: *FIRSTPASS_STATS_in_vp9_cx_iface,
    AV_ERR: float64
) -> float64 {
    modified_score :=
        AV_ERR * c_transpiler_math_pow(
            this_frame.coded_error * this_frame.weight /
            (ifx c_transpiler_float_less(AV_ERR, 0.0) then AV_ERR - 0.000001 else AV_ERR + 0.000001),
            (cast,no_check(float64) oxcf.two_pass_vbrbias) / 100.0
        );

    modified_score *= c_transpiler_math_pow(calculate_active_area(*cpi.frame_info, this_frame), 0.5);

    return modified_score;
}

get_distribution_av_err :: (cpi: *VP9_COMP_in_vp9_encoder, TWOPASS: *TWO_PASS) -> float64 {
    AV_WEIGHT := TWOPASS.total_stats.weight / TWOPASS.total_stats.count;

    if cpi.oxcf.vbr_corpus_complexity != 0 {
        return AV_WEIGHT * TWOPASS.mean_mod_score;
    } else {
        return TWOPASS.total_stats.coded_error * AV_WEIGHT / TWOPASS.total_stats.count;
    }
}

vp9_rc_get_second_pass_params :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    RC := *cpi.rc;
    TWOPASS := *cpi.twopass;
    GF_GROUP_ := *TWOPASS.gf_group;
    this_frame: FIRSTPASS_STATS_in_vp9_cx_iface = ---;
    SHOW_IDX := cast,no_check(s32) CM.current_video_frame;

    if cpi.common.current_frame_coding_index == 0 && cpi.ext_ratectrl.funcs.send_firstpass_stats != null {
        CODEC_STATUS :=
            (cast,no_check(#type (_: *EXT_RATECTRL, _: *FIRST_PASS_INFO) -> Codec_Err_T) (cast(*void) vp9_extrc_send_firstpass_stats))(
                *cpi.ext_ratectrl,
                *cpi.twopass.first_pass_info
            );
        if CODEC_STATUS != cast,no_check(u32) CODEC_OK {
            internal_error(*CM.error, CODEC_STATUS, c_string("vp9_extrc_send_firstpass_stats() failed"));
        }
    }

    if TWOPASS.stats_in == null {
        return;
    }

    if CM.current_video_frame == 0 {
        screen_area := cast,no_check(u32) (CM.width * CM.height);

        vp9_init_vizier_params(TWOPASS, cast,no_check(s32) screen_area);
    }

    if GF_GROUP_.update_type[GF_GROUP_.index] == cast,no_check(u32) ARF_UPDATE {
        fill_memory(*this_frame, 0, size_of(FIRSTPASS_STATS_in_vp9_cx_iface));
        assignment_3: FIRSTPASS_STATS_in_vp9_cx_iface =
            (cast(*FIRSTPASS_STATS_in_vp9_cx_iface) (cpi.twopass.stats_in_start))[CM.current_video_frame +
                cast(u32) GF_GROUP_.arf_src_offset[GF_GROUP_.index]];
        ((*this_frame).*) = assignment_3;

        vp9_configure_buffer_updates(cpi, cast,no_check(s32) GF_GROUP_.index);

        target_rate := GF_GROUP_.bit_allocation[GF_GROUP_.index];
        target_rate = vp9_rc_clamp_pframe_target_size(cpi, target_rate);
        RC.base_frame_target = target_rate;

        CM.frame_type = cast,no_check(FRAME_TYPE) INTER_FRAME;

        TWOPASS.mb_av_energy = c_transpiler_math_log(this_frame.intra_error * 256.0 + 1.0);
        TWOPASS.mb_smooth_pct = this_frame.intra_smooth_pct;

        return;
    }

    if cpi.oxcf.rc_mode == cast,no_check(u32) Q {
        TWOPASS.active_worst_quality = cpi.oxcf.cq_level;
    } else if CM.current_video_frame == 0 {
        FRAMES_LEFT := cast,no_check(s32) (TWOPASS.total_stats.count - CM.current_video_frame);

        section_target_bandwidth := TWOPASS.bits_left / cast(s64) FRAMES_LEFT;
        section_target_bandwidth =
            ifx section_target_bandwidth < 2147483647 then section_target_bandwidth else 2147483647;
        SECTION_LENGTH := TWOPASS.total_left_stats.count;
        SECTION_ERROR := TWOPASS.total_left_stats.coded_error / SECTION_LENGTH;
        SECTION_INTRA_SKIP := TWOPASS.total_left_stats.intra_skip_pct / SECTION_LENGTH;
        SECTION_INACTIVE_ZONE :=
            TWOPASS.total_left_stats.inactive_zone_rows * 2.0 /
                ((cast,no_check(float64) CM.mb_rows) * SECTION_LENGTH);
        SECTION_NOISE := TWOPASS.total_left_stats.frame_noise_energy / SECTION_LENGTH;
        tmp_q :=
            get_twopass_worst_quality(
                cpi,
                SECTION_ERROR,
                SECTION_INTRA_SKIP + SECTION_INACTIVE_ZONE,
                SECTION_NOISE,
                cast,no_check(s32) section_target_bandwidth
            );

        TWOPASS.active_worst_quality = tmp_q;
        TWOPASS.baseline_active_worst_quality = tmp_q;
        RC.ni_av_qi = tmp_q;
        RC.last_q[INTER_FRAME] = tmp_q;
        RC.avg_q = vp9_convert_qindex_to_q(tmp_q, CM.bit_depth);
        RC.avg_frame_qindex[INTER_FRAME] = tmp_q;
        RC.last_q[KEY_FRAME] = (tmp_q + cpi.oxcf.best_allowed_q) / 2;
        RC.avg_frame_qindex[KEY_FRAME] = RC.last_q[KEY_FRAME];
    }
    fill_memory(*this_frame, 0, size_of(FIRSTPASS_STATS_in_vp9_cx_iface));
    if -1 == input_stats_in_vp9_firstpass(TWOPASS, *this_frame) {
        return;
    }

    if c_transpiler_float_greater_equal(this_frame.intra_skip_pct, 0.15) {
        TWOPASS.fr_content_type = cast,no_check(FRAME_CONTENT_TYPE) FC_GRAPHICS_ANIMATION;
    } else {
        TWOPASS.fr_content_type = cast,no_check(FRAME_CONTENT_TYPE) FC_NORMAL;
    }

    if RC.frames_to_key == 0 || cpi.frame_flags & cast,no_check(s32) (FRAMEFLAGS_KEY_in_vp9_cx_iface) != 0 {
        find_next_key_frame_in_vp9_firstpass(cpi, SHOW_IDX);
    } else {
        CM.frame_type = cast,no_check(FRAME_TYPE) INTER_FRAME;
    }

    if RC.frames_till_gf_update_due == 0 {
        define_gf_group_in_vp9_firstpass(cpi, SHOW_IDX);
    }

    if RC.frames_till_gf_update_due == 0 {
        if cpi.ext_ratectrl.ready != 0 && cpi.ext_ratectrl.log_file != null {
            fprintf(cpi.ext_ratectrl.log_file, c_string("GOP_INFO show_frame_count %d\n"), RC.baseline_gf_interval);
        }
        RC.frames_till_gf_update_due = RC.baseline_gf_interval;
    }

    vp9_configure_buffer_updates(cpi, cast,no_check(s32) GF_GROUP_.index);

    RC.base_frame_target = GF_GROUP_.bit_allocation[GF_GROUP_.index];

    TWOPASS.mb_av_energy = c_transpiler_math_log(this_frame.intra_error * 256.0 + 1.0);
    TWOPASS.mb_smooth_pct = this_frame.intra_smooth_pct;

    subtract_stats_in_vp9_firstpass(*TWOPASS.total_left_stats, *this_frame);
}

subtract_stats_in_vp9_firstpass :: (
    section: *FIRSTPASS_STATS_in_vp9_cx_iface,
    frame: *FIRSTPASS_STATS_in_vp9_cx_iface
) {
    section.frame -= frame.frame;
    section.weight -= frame.weight;
    section.intra_error -= frame.intra_error;
    section.coded_error -= frame.coded_error;
    section.sr_coded_error -= frame.sr_coded_error;
    section.frame_noise_energy -= frame.frame_noise_energy;
    section.pcnt_inter -= frame.pcnt_inter;
    section.pcnt_motion -= frame.pcnt_motion;
    section.pcnt_second_ref -= frame.pcnt_second_ref;
    section.pcnt_neutral -= frame.pcnt_neutral;
    section.intra_skip_pct -= frame.intra_skip_pct;
    section.intra_smooth_pct -= frame.intra_smooth_pct;
    section.pcnt_intra_low -= frame.pcnt_intra_low;
    section.pcnt_intra_high -= frame.pcnt_intra_high;
    section.inactive_zone_rows -= frame.inactive_zone_rows;
    section.inactive_zone_cols -= frame.inactive_zone_cols;
    section.new_mv_count -= frame.new_mv_count;
    section.m_vr -= frame.m_vr;
    section.mvr_abs -= frame.mvr_abs;
    section.m_vc -= frame.m_vc;
    section.mvc_abs -= frame.mvc_abs;
    section.m_vrv -= frame.m_vrv;
    section.m_vcv -= frame.m_vcv;
    section.mv_in_out_count -= frame.mv_in_out_count;
    section.count -= frame.count;
    section.duration -= frame.duration;
}

define_gf_group_in_vp9_firstpass :: (cpi: *VP9_COMP_in_vp9_encoder, gf_start_show_idx: s32) {
    CM := *cpi.common;
    RC := *cpi.rc;
    OXCF := *cpi.oxcf;
    TWOPASS := *cpi.twopass;
    frame_info := *cpi.frame_info;
    first_pass_info := *TWOPASS.first_pass_info;
    START_POS := TWOPASS.stats_in;

    gf_group_err: float64 = 0.0;
    gf_group_raw_error: float64 = 0.0;
    gf_group_noise: float64 = 0.0;
    gf_group_skip_pct: float64 = 0.0;
    gf_group_inactive_zone_rows: float64 = 0.0;
    gf_group_inter: float64 = 0.0;
    gf_group_motion: float64 = 0.0;

    allow_alt_ref := is_altref_enabled_in_vp9_firstpass(cpi);
    use_alt_ref: s32 = ---;

    is_key_frame := frame_is_intra_only_in_vp9_firstpass(CM);

    gop_decision: Rc_Gop_Decision_T = ---;
    gop_decision_ready: s32 = 0;
    if cpi.ext_ratectrl.ready != 0 &&
        (cpi.ext_ratectrl.funcs.rc_type & cast,no_check(u32) RC_GOP) != 0 &&
        cpi.ext_ratectrl.funcs.get_gop_decision != null {
        codec_status :=
            (cast,no_check(#type (_: *EXT_RATECTRL, _: *Rc_Gop_Decision_T) -> Codec_Err_T) (cast(*void) vp9_extrc_get_gop_decision))(
                *cpi.ext_ratectrl,
                *gop_decision
            );
        if codec_status != cast,no_check(u32) CODEC_OK {
            internal_error(*CM.error, codec_status, c_string("vp9_extrc_get_gop_decision() failed"));
        }
        is_key_frame = gop_decision.use_key_frame;
        gop_decision_ready = 1;
    }

    ARF_ACTIVE_OR_KF := cast(s32) (is_key_frame != 0 || RC.source_alt_ref_active != 0);
    is_alt_ref_flash: s32 = 0;

    gop_intra_factor: float64 = ---;

    active_gf_interval: RANGE = ---;

    end_of_sequence: s32 = 0;

    if is_key_frame == 0 {
        fill_memory(*TWOPASS.gf_group, 0, size_of(GF_GROUP));
        RC.gop_global_index += 1;
    } else {
        RC.gop_global_index = 0;
    }

    active_gf_interval =
        get_active_gf_inverval_range(
            frame_info,
            RC,
            ARF_ACTIVE_OR_KF,
            gf_start_show_idx,
            TWOPASS.active_worst_quality,
            RC.last_boosted_qindex
        );

    if cpi.multi_layer_arf != 0 {
        arf_layers := get_arf_layers(cpi.multi_layer_arf, OXCF.enable_auto_arf, active_gf_interval.max);
        gop_intra_factor = 1.0 + 0.25 * cast,no_check(float64) arf_layers;
    } else {
        gop_intra_factor = 1.0;
    }

    gop_coding_frames :=
        get_gop_coding_frame_num(
            *use_alt_ref,
            frame_info,
            TWOPASS,
            RC,
            gf_start_show_idx,
            *active_gf_interval,
            gop_intra_factor,
            cpi.oxcf.lag_in_frames,
            *end_of_sequence
        );
    use_alt_ref &= allow_alt_ref;

    if gop_decision_ready != 0 {
        gop_coding_frames = gop_decision.gop_coding_frames;
        use_alt_ref = gop_decision.use_alt_ref;
    }

    RC.constrained_gf_group = cast(s32) (gop_coding_frames >= RC.frames_to_key);

    if use_alt_ref != 0 {
        F_FRAMES :=
            (ifx RC.frames_to_key - gop_coding_frames >= gop_coding_frames - 1 then gop_coding_frames -
                1 else (ifx 0 > RC.frames_to_key - gop_coding_frames then 0 else RC.frames_to_key - gop_coding_frames));
        B_FRAMES := gop_coding_frames - 1;
        AVG_INTER_FRAME_QINDEX := RC.avg_frame_qindex[INTER_FRAME];

        ARF_SHOW_IDX :=
            (ifx gf_start_show_idx + gop_coding_frames + 1 < fps_get_num_frames_in_vp9_firstpass(first_pass_info) then gf_start_show_idx +
                gop_coding_frames + 1 else fps_get_num_frames_in_vp9_firstpass(first_pass_info));

        RC.gfu_boost = compute_arf_boost(frame_info, TWOPASS, ARF_SHOW_IDX, F_FRAMES, B_FRAMES, AVG_INTER_FRAME_QINDEX);
        RC.source_alt_ref_pending = 1;
    } else {
        F_FRAMES := gop_coding_frames - 1;
        B_FRAMES: s32 = 0;
        AVG_INTER_FRAME_QINDEX := RC.avg_frame_qindex[INTER_FRAME];

        GLD_SHOW_IDX :=
            (ifx gf_start_show_idx + 1 < fps_get_num_frames_in_vp9_firstpass(first_pass_info) then gf_start_show_idx +
                1 else fps_get_num_frames_in_vp9_firstpass(first_pass_info));
        ARF_BOOST :=
            compute_arf_boost(
                frame_info,
                TWOPASS,
                GLD_SHOW_IDX,
                F_FRAMES,
                B_FRAMES,
                AVG_INTER_FRAME_QINDEX
            );
        RC.gfu_boost =
            ifx cast,no_check(s32) TWOPASS.gf_max_total_boost < ARF_BOOST then cast,no_check(s32) TWOPASS.gf_max_total_boost else ARF_BOOST;
        RC.source_alt_ref_pending = 0;
    }

    RC.arf_active_best_quality_adjustment_factor = 1.0;
    RC.arf_increase_active_best_quality = 0;

    if is_lossless_requested_in_vp9_firstpass(*cpi.oxcf) == 0 {
        if RC.frames_since_key >= RC.frames_to_key {
            RC.arf_active_best_quality_adjustment_factor =
                0.2 +
                    (0.8 * cast,no_check(float64) (RC.frames_to_key - gop_coding_frames)) / (ifx 1 > (RC.frames_to_key + RC.frames_since_key) / 2 - gop_coding_frames then 1 else (RC.frames_to_key + RC.frames_since_key) / 2 - gop_coding_frames);
            RC.arf_increase_active_best_quality = 1;
        } else if RC.frames_to_key - gop_coding_frames > 0 {
            RC.arf_active_best_quality_adjustment_factor =
                0.2 +
                    (0.8 * cast,no_check(float64) (RC.frames_since_key + gop_coding_frames)) / (ifx 1 > (RC.frames_to_key + RC.frames_since_key) / 2 + gop_coding_frames then 1 else (RC.frames_to_key + RC.frames_since_key) / 2 + gop_coding_frames);
            RC.arf_increase_active_best_quality = -1;
        }
    }

    RC.gfu_boost = ifx RC.gfu_boost < gop_coding_frames * 200 then RC.gfu_boost else gop_coding_frames * 200;

    if OXCF.aq_mode == cast,no_check(u32) PERCEPTUAL_AQ {
        RC.gfu_boost = ifx RC.gfu_boost < 250 then RC.gfu_boost else 250;
    }

    RC.baseline_gf_interval = gop_coding_frames - RC.source_alt_ref_pending;

    if RC.source_alt_ref_pending != 0 {
        is_alt_ref_flash = detect_flash_in_vp9_firstpass(TWOPASS, RC.baseline_gf_interval);
    }

    {
        AV_ERR := get_distribution_av_err(cpi, TWOPASS);
        MEAN_MOD_SCORE := TWOPASS.mean_mod_score;

        start_idx := cast(s32) (ARF_ACTIVE_OR_KF != 0);

        j := start_idx;
        while j < gop_coding_frames {
            show_idx := gf_start_show_idx + j;
            frame_stats :=
                fps_get_frame_stats_in_vp9_firstpass(
                    first_pass_info,
                    show_idx
                );
            if frame_stats == null {
                if cpi.ext_ratectrl.ready != 0 &&
                    (cpi.ext_ratectrl.funcs.rc_type & cast,no_check(u32) RC_GOP) != 0 &&
                    cpi.ext_ratectrl.funcs.get_gop_decision != null {
                    break;
                }
                internal_error(
                    *CM.error,
                    cast,no_check(Codec_Err_T) CODEC_ERROR,
                    c_string("In define_gf_group(), frame_stats is NULL when calculating gf_group_err.")
                );
                break;
            }

            gf_group_err += calc_norm_frame_score(OXCF, frame_info, frame_stats, MEAN_MOD_SCORE, AV_ERR);
            gf_group_raw_error += frame_stats.coded_error;
            gf_group_noise += frame_stats.frame_noise_energy;
            gf_group_skip_pct += frame_stats.intra_skip_pct;
            gf_group_inactive_zone_rows += frame_stats.inactive_zone_rows;
            gf_group_inter += frame_stats.pcnt_inter;
            gf_group_motion += frame_stats.pcnt_motion;
            j += 1;
        }
    }

    gf_group_bits := calculate_total_gf_group_bits(cpi, gf_group_err);

    gop_frames := RC.baseline_gf_interval + RC.source_alt_ref_pending - ARF_ACTIVE_OR_KF;

    if gop_frames > 0 {
        TWOPASS.gf_group.group_noise_energy = cast,no_check(s32) (gf_group_noise / gop_frames);
    } else {
        TWOPASS.gf_group.group_noise_energy = 0;
    }

    if cpi.oxcf.rc_mode != cast,no_check(u32) Q && RC.baseline_gf_interval > 1 {
        VBR_GROUP_BITS_PER_FRAME := cast,no_check(s32) (gf_group_bits / cast(s64) gop_frames);
        GROUP_AV_ERR := gf_group_raw_error / gop_frames;
        GROUP_AV_NOISE := gf_group_noise / gop_frames;
        GROUP_AV_SKIP_PCT := gf_group_skip_pct / gop_frames;
        GROUP_AV_INACTIVE_ZONE := gf_group_inactive_zone_rows * 2.0 / (gop_frames * cast,no_check(float64) CM.mb_rows);
        tmp_q :=
            get_twopass_worst_quality(
                cpi,
                GROUP_AV_ERR,
                GROUP_AV_SKIP_PCT + GROUP_AV_INACTIVE_ZONE,
                GROUP_AV_NOISE,
                VBR_GROUP_BITS_PER_FRAME
            );
        TWOPASS.active_worst_quality =
            cast,no_check(s32) ((tmp_q + TWOPASS.active_worst_quality * (TWOPASS.active_wq_factor - 1.0)) /
                TWOPASS.active_wq_factor);
    }

    if RC.baseline_gf_interval > 1 {
        adjust_group_arnr_filter(
            cpi,
            gf_group_noise / gop_frames,
            gf_group_inter / gop_frames,
            gf_group_motion / gop_frames
        );
    } else {
        TWOPASS.arnr_strength_adjustment = 0;
    }

    gf_arf_bits := calculate_boost_bits(RC.baseline_gf_interval - 1, RC.gfu_boost, gf_group_bits);

    TWOPASS.kf_group_error_left -= gf_group_err;

    if gop_decision_ready != 0 {
        ext_rc_define_gf_group_structure(*gop_decision, *TWOPASS.gf_group);

        cpi.lst_fb_idx = TWOPASS.gf_group.ext_rc_ref[0].last_index;
        cpi.gld_fb_idx = TWOPASS.gf_group.ext_rc_ref[0].golden_index;
        cpi.alt_fb_idx = TWOPASS.gf_group.ext_rc_ref[0].altref_index;
    } else {
        define_gf_group_structure(cpi);
    }

    allocate_gf_group_bits(cpi, gf_group_bits, gf_arf_bits);

    reset_fpf_position_in_vp9_firstpass(TWOPASS, START_POS);

    TWOPASS.section_intra_rating =
        cast,no_check(u32) calculate_section_intra_ratio(
            START_POS,
            TWOPASS.stats_in_end,
            RC.baseline_gf_interval
        );

    if OXCF.resize_mode == cast,no_check(u32) RESIZE_DYNAMIC {
        cpi.rc.next_frame_size_selector = cast,no_check(FRAME_SCALE_LEVEL) UNSCALED;
    }

    TWOPASS.rolling_arf_group_target_bits = 0;
    TWOPASS.rolling_arf_group_actual_bits = 0;

    RC.preserve_arf_as_gld = RC.preserve_next_arf_as_gld;
    RC.preserve_next_arf_as_gld = 0;

    if is_lossless_requested_in_vp9_firstpass(*cpi.oxcf) == 0 &&
        cpi.use_svc == 0 &&
        cpi.oxcf.aq_mode == cast,no_check(u32) NO_AQ &&
        cpi.multi_layer_arf != 0 &&
        is_alt_ref_flash == 0 {
        RC.preserve_next_arf_as_gld = 1;
    }
}

is_lossless_requested_in_vp9_firstpass :: (cfg: *VP9_Encoder_Config) -> s32 {
    if cfg.best_allowed_q == 0 && cfg.worst_allowed_q == 0 {
        return 1;
    }
    return 0;
}

calculate_section_intra_ratio :: (
    begin: *FIRSTPASS_STATS_in_vp9_cx_iface,
    end: *FIRSTPASS_STATS_in_vp9_cx_iface,
    section_length: s32
) -> s32 {
    s := begin;
    intra_error: float64 = 0.0;
    coded_error: float64 = 0.0;
    i: s32 = 0;

    while s < end && i < section_length {
        intra_error += s.intra_error;
        coded_error += s.coded_error;
        s += 1;
        i += 1;
    }

    return cast,no_check(s32) (intra_error / (ifx c_transpiler_float_less(coded_error, 0.0) then coded_error - 0.000001 else coded_error + 0.000001));
}

reset_fpf_position_in_vp9_firstpass :: (p: *TWO_PASS, position: *FIRSTPASS_STATS_in_vp9_cx_iface) {
    p.stats_in = position;
}

allocate_gf_group_bits :: (cpi: *VP9_COMP_in_vp9_encoder, gf_group_bits: s64, gf_arf_bits: s32) {
    OXCF := *cpi.oxcf;
    RC := *cpi.rc;
    TWOPASS := *cpi.twopass;
    GF_GROUP_ := *TWOPASS.gf_group;
    frame_stats: FIRSTPASS_STATS_in_vp9_cx_iface = ---;

    frame_index: s32 = 0;
    target_frame_size: s32 = ---;

    MAX_BITS := frame_max_bits_in_vp9_firstpass(*cpi.rc, OXCF);
    total_group_bits := gf_group_bits;

    last_frame_reduction: s32 = 0;
    av_score: float64 = 1.0;
    tot_norm_frame_score: float64 = 1.0;
    this_frame_score: float64 = 1.0;

    gop_frames := GF_GROUP_.gf_group_size;

    key_frame := cast(s32) (cpi.common.frame_type == cast,no_check(u32) KEY_FRAME);

    if key_frame == 0 {
        GF_GROUP_.bit_allocation[frame_index] = ifx RC.source_alt_ref_active != 0 then 0 else gf_arf_bits;
    }

    if RC.source_alt_ref_pending != 0 || key_frame == 0 {
        total_group_bits -= cast,no_check(s64) gf_arf_bits;
    }

    frame_index += 1;

    if RC.source_alt_ref_pending != 0 {
        GF_GROUP_.bit_allocation[frame_index] = gf_arf_bits;

        frame_index += 1;
    }

    mid_frame_idx := frame_index + RC.baseline_gf_interval >> 1 - 1;

    normal_frames := RC.baseline_gf_interval - 1;
    normal_frame_bits: s32 = ifx normal_frames > 1
        then cast,no_check(s32) (total_group_bits / cast(s64) normal_frames)
        else cast,no_check(s32) total_group_bits;

    GF_GROUP_.gfu_boost[1] = RC.gfu_boost;

    if cpi.multi_layer_arf != 0 {
        arf_depth_bits: [6] s32;
        arf_depth_count: [6] s32;
        arf_depth_boost: [6] s32;
        total_arfs: s32 = 1;

        idx: s32 = 0;
        while idx < gop_frames {
            if GF_GROUP_.update_type[idx] == cast,no_check(u32) ARF_UPDATE {
                arf_depth_boost[GF_GROUP_.layer_depth[idx]] += GF_GROUP_.gfu_boost[idx];
                arf_depth_count[GF_GROUP_.layer_depth[idx]] += 1;
            }
            idx += 1;
        }

        idx = 2;
        while idx < 6 {
            if arf_depth_boost[idx] == 0 {
                break;
            }
            arf_depth_bits[idx] =
                calculate_boost_bits(
                    RC.baseline_gf_interval - total_arfs - arf_depth_count[idx],
                    arf_depth_boost[idx],
                    total_group_bits
                );

            total_group_bits -= cast,no_check(s64) arf_depth_bits[idx];
            total_arfs += arf_depth_count[idx];
            idx += 1;
        }

        normal_frames -= total_arfs - 1;
        if normal_frames > 1 {
            normal_frame_bits = cast,no_check(s32) (total_group_bits / cast(s64) normal_frames);
        } else {
            normal_frame_bits = cast,no_check(s32) total_group_bits;
        }

        target_frame_size = normal_frame_bits;
        target_frame_size =
            clamp_in_vp9_firstpass(
                target_frame_size,
                0,
                (ifx MAX_BITS < cast,no_check(s32) total_group_bits then MAX_BITS else cast,no_check(s32) total_group_bits)
            );

        idx = frame_index;
        while idx < gop_frames {
            if GF_GROUP_.update_type[idx] == {
                case cast,no_check(u32) ARF_UPDATE;
                    GF_GROUP_.bit_allocation[idx] =
                        cast,no_check(s32) (((cast,no_check(s64) arf_depth_bits[GF_GROUP_.layer_depth[idx]]) * cast(s64) GF_GROUP_.gfu_boost[idx]) /
                            cast(s64) arf_depth_boost[GF_GROUP_.layer_depth[idx]]);
                case cast,no_check(u32) USE_BUF_FRAME;
                    GF_GROUP_.bit_allocation[idx] = 0;
                case;
                    GF_GROUP_.bit_allocation[idx] = target_frame_size;
            }
            idx += 1;
        }
        GF_GROUP_.bit_allocation[idx] = 0;

        return;
    }

    if OXCF.vbr_corpus_complexity != 0 {
        av_score = get_distribution_av_err(cpi, TWOPASS);
        tot_norm_frame_score = calculate_group_score(cpi, av_score, normal_frames);
    }

    if 0 < normal_frames {
        for i: 0..normal_frames - 1 {
            if -1 == input_stats_in_vp9_firstpass(TWOPASS, *frame_stats) {
                break;
            }
            if OXCF.vbr_corpus_complexity != 0 {
                this_frame_score = calculate_norm_frame_score(cpi, TWOPASS, OXCF, *frame_stats, av_score);
                normal_frame_bits =
                    cast,no_check(s32) ((cast,no_check(float64) total_group_bits) *
                        (this_frame_score / tot_norm_frame_score));
            }

            target_frame_size = normal_frame_bits;
            if i == normal_frames - 1 && i >= 1 {
                last_frame_reduction = normal_frame_bits / 16;
                target_frame_size -= last_frame_reduction;
            }

            target_frame_size =
                clamp_in_vp9_firstpass(
                    target_frame_size,
                    0,
                    (ifx MAX_BITS < cast,no_check(s32) total_group_bits then MAX_BITS else cast,no_check(s32) total_group_bits)
                );

            GF_GROUP_.bit_allocation[frame_index] = target_frame_size;
            frame_index += 1;
        }
    }

    GF_GROUP_.bit_allocation[mid_frame_idx] += last_frame_reduction;
}

frame_max_bits_in_vp9_firstpass :: (rc: *RATE_CONTROL, oxcf: *VP9_Encoder_Config) -> s32 {
    max_bits := ((cast,no_check(s64) rc.avg_frame_bandwidth) * cast,no_check(s64) oxcf.two_pass_vbrmax_section) / 100;
    if max_bits < 0 {
        max_bits = 0;
    } else if max_bits > cast,no_check(s64) rc.max_frame_bandwidth {
        max_bits = cast,no_check(s64) rc.max_frame_bandwidth;
    }

    return cast,no_check(s32) max_bits;
}

input_stats_in_vp9_firstpass :: (p: *TWO_PASS, fps: *FIRSTPASS_STATS_in_vp9_cx_iface) -> s32 {
    if p.stats_in >= p.stats_in_end {
        return -1;
    }

    assignment_4: FIRSTPASS_STATS_in_vp9_cx_iface = p.stats_in.*;
    ((fps).*) = assignment_4;
    p.stats_in += 1;
    return 1;
}

calculate_group_score :: (cpi: *VP9_COMP_in_vp9_encoder, av_score: float64, frame_count: s32) -> float64 {
    OXCF := *cpi.oxcf;
    TWOPASS := *cpi.twopass;
    s := TWOPASS.stats_in;
    score_total: float64 = 0.0;
    i: s32 = 0;

    if frame_count == 0 {
        return 1.0;
    }

    while i < frame_count && s < TWOPASS.stats_in_end {
        score_total += calculate_norm_frame_score(cpi, TWOPASS, OXCF, s, av_score);
        s += 1;
        i += 1;
    }

    return score_total;
}

calculate_boost_bits :: (frame_count: s32, boost: s32, total_group_bits: s64) -> s32 {
    if boost == 0 || total_group_bits <= 0 || frame_count < 0 {
        return 0;
    }

    allocation_chunks := frame_count * 100 + boost;

    if boost > 1023 {
        divisor := boost >> 10;
        boost /= divisor;
        allocation_chunks /= divisor;
    }

    return ifx cast,no_check(s32) ((cast,no_check(s64) boost) * total_group_bits / cast(s64) allocation_chunks) > 0 then cast,no_check(s32) ((cast,no_check(s64) boost) * total_group_bits / cast(s64) allocation_chunks) else 0;
}

define_gf_group_structure :: (cpi: *VP9_COMP_in_vp9_encoder) {
    RC := *cpi.rc;
    TWOPASS := *cpi.twopass;
    GF_GROUP_ := *TWOPASS.gf_group;
    frame_index: s32 = 0;
    key_frame := cast(s32) (cpi.common.frame_type == cast,no_check(u32) KEY_FRAME);
    layer_depth: s32 = 1;
    gop_frames := RC.baseline_gf_interval - cast(s32) (key_frame != 0 || RC.source_alt_ref_pending != 0);

    GF_GROUP_.frame_start = cast,no_check(s32) cpi.common.current_video_frame;
    GF_GROUP_.frame_end = GF_GROUP_.frame_start + RC.baseline_gf_interval;
    GF_GROUP_.max_layer_depth = 0;
    GF_GROUP_.allowed_max_layer_depth = 0;

    if key_frame == 0 {
        set_gf_overlay_frame_type(GF_GROUP_, frame_index, RC.source_alt_ref_active);
    }

    frame_index += 1;

    if RC.source_alt_ref_pending != 0 {
        GF_GROUP_.update_type[frame_index] = cast,no_check(FRAME_UPDATE_TYPE) ARF_UPDATE;
        GF_GROUP_.rf_level[frame_index] = cast,no_check(RATE_FACTOR_LEVEL) GF_ARF_STD;
        GF_GROUP_.layer_depth[frame_index] = cast,no_check(u8) layer_depth;
        GF_GROUP_.arf_src_offset[frame_index] = cast,no_check(u8) (RC.baseline_gf_interval - 1);
        GF_GROUP_.frame_gop_index[frame_index] = cast,no_check(u8) RC.baseline_gf_interval;
        GF_GROUP_.max_layer_depth = 1;
        frame_index += 1;
        layer_depth += 1;
        GF_GROUP_.allowed_max_layer_depth = cpi.oxcf.enable_auto_arf;
    }

    find_arf_order(cpi, GF_GROUP_, *frame_index, layer_depth, 1, gop_frames);

    set_gf_overlay_frame_type(GF_GROUP_, frame_index, RC.source_alt_ref_pending);
    GF_GROUP_.arf_src_offset[frame_index] = 0;
    GF_GROUP_.frame_gop_index[frame_index] = cast,no_check(u8) RC.baseline_gf_interval;

    GF_GROUP_.gf_group_size = frame_index;
}

set_gf_overlay_frame_type :: (gf_group: *GF_GROUP, frame_index: s32, source_alt_ref_active: s32) {
    if source_alt_ref_active != 0 {
        gf_group.update_type[frame_index] = cast,no_check(FRAME_UPDATE_TYPE) OVERLAY_UPDATE;
        gf_group.rf_level[frame_index] = cast,no_check(RATE_FACTOR_LEVEL) INTER_NORMAL;
        gf_group.layer_depth[frame_index] = cast,no_check(u8) (6 - 1);
        gf_group.gfu_boost[frame_index] = 100;
    } else {
        gf_group.update_type[frame_index] = cast,no_check(FRAME_UPDATE_TYPE) GF_UPDATE;
        gf_group.rf_level[frame_index] = cast,no_check(RATE_FACTOR_LEVEL) GF_ARF_STD;
        gf_group.layer_depth[frame_index] = 0;
    }
}

find_arf_order :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    gf_group: *GF_GROUP,
    index_counter: *s32,
    depth: s32,
    start: s32,
    end: s32
) {
    twopass := *cpi.twopass;
    START_POS := twopass.stats_in;
    fpf_frame: FIRSTPASS_STATS_in_vp9_cx_iface = ---;
    MID := (start + end + 1) >> 1;
    MIN_FRAME_INTERVAL: s32 = 2;
    idx: s32 = ---;

    if end - start < MIN_FRAME_INTERVAL || depth > gf_group.allowed_max_layer_depth {
        idx = start;
        while idx <= end {
            gf_group.update_type[index_counter.*] = cast,no_check(FRAME_UPDATE_TYPE) LF_UPDATE;
            gf_group.arf_src_offset[index_counter.*] = 0;
            gf_group.frame_gop_index[index_counter.*] = cast,no_check(u8) idx;
            gf_group.rf_level[index_counter.*] = cast,no_check(RATE_FACTOR_LEVEL) INTER_NORMAL;
            gf_group.layer_depth[index_counter.*] = cast,no_check(u8) depth;
            gf_group.gfu_boost[index_counter.*] = 100;
            index_counter.* += 1;
            idx += 1;
        }
        gf_group.max_layer_depth = ifx gf_group.max_layer_depth > depth then gf_group.max_layer_depth else depth;
        return;
    }

    gf_group.layer_depth[index_counter.*] = cast,no_check(u8) depth;
    gf_group.update_type[index_counter.*] = cast,no_check(FRAME_UPDATE_TYPE) ARF_UPDATE;
    gf_group.arf_src_offset[index_counter.*] = cast,no_check(u8) (MID - start);
    gf_group.frame_gop_index[index_counter.*] = cast,no_check(u8) MID;
    gf_group.rf_level[index_counter.*] = cast,no_check(RATE_FACTOR_LEVEL) GF_ARF_LOW;

    idx = 0;
    while idx <= MID {
        if -1 == input_stats_in_vp9_firstpass(twopass, *fpf_frame) {
            break;
        }
        idx += 1;
    }

    gf_group.gfu_boost[index_counter.*] =
        ifx 250 > calc_arf_boost_in_vp9_firstpass(cpi, end - MID + 1, MID -
            start) >> ((depth) & 31) then 250 else calc_arf_boost_in_vp9_firstpass(cpi, end - MID + 1, MID - start) >> ((depth) & 31);

    reset_fpf_position_in_vp9_firstpass(twopass, START_POS);

    index_counter.* += 1;

    find_arf_order(cpi, gf_group, index_counter, depth + 1, start, MID - 1);

    gf_group.update_type[index_counter.*] = cast,no_check(FRAME_UPDATE_TYPE) USE_BUF_FRAME;
    gf_group.arf_src_offset[index_counter.*] = 0;
    gf_group.frame_gop_index[index_counter.*] = cast,no_check(u8) MID;
    gf_group.rf_level[index_counter.*] = cast,no_check(RATE_FACTOR_LEVEL) INTER_NORMAL;
    gf_group.layer_depth[index_counter.*] = cast,no_check(u8) depth;
    index_counter.* += 1;

    find_arf_order(cpi, gf_group, index_counter, depth + 1, MID + 1, end);
}

calc_arf_boost_in_vp9_firstpass :: (cpi: *VP9_COMP_in_vp9_encoder, f_frames: s32, b_frames: s32) -> s32 {
    frame_info := *cpi.frame_info;
    TWOPASS := *cpi.twopass;
    AVG_INTER_FRAME_QINDEX := cpi.rc.avg_frame_qindex[INTER_FRAME];
    arf_show_idx := get_show_idx(TWOPASS);
    return compute_arf_boost(frame_info, TWOPASS, arf_show_idx, f_frames, b_frames, AVG_INTER_FRAME_QINDEX);
}

get_show_idx :: (twopass: *TWO_PASS) -> s32 {
    return cast,no_check(s32) (twopass.stats_in - twopass.stats_in_start);
}

compute_arf_boost :: (
    frame_info: *FRAME_INFO,
    TWOPASS: *TWO_PASS,
    arf_show_idx: s32,
    f_frames: s32,
    b_frames: s32,
    avg_frame_qindex: s32
) -> s32 {
    first_pass_info := *TWOPASS.first_pass_info;

    boost_score: float64 = 0.0;
    mv_ratio_accumulator: float64 = 0.0;
    decay_accumulator: float64 = 1.0;
    this_frame_mv_in_out: float64 = 0.0;
    mv_in_out_accumulator: float64 = 0.0;
    abs_mv_in_out_accumulator: float64 = 0.0;

    flash_detected: s32 = 0;

    i: s32 = 0;
    while i < f_frames {
        this_frame :=
            fps_get_frame_stats_in_vp9_firstpass(
                first_pass_info,
                arf_show_idx + i
            );
        next_frame :=
            fps_get_frame_stats_in_vp9_firstpass(
                first_pass_info,
                arf_show_idx + i + 1
            );
        if this_frame == null {
            break;
        }

        accumulate_frame_motion_stats_in_vp9_firstpass(
            this_frame,
            *this_frame_mv_in_out,
            *mv_in_out_accumulator,
            *abs_mv_in_out_accumulator,
            *mv_ratio_accumulator
        );

        flash_detected =
            cast(s32) (detect_flash_from_frame_stats(this_frame) != 0 ||
                detect_flash_from_frame_stats(next_frame) != 0);

        if flash_detected == 0 {
            decay_accumulator *= get_prediction_decay_rate_in_vp9_firstpass(TWOPASS, this_frame);
            decay_accumulator = ifx c_transpiler_float_less(decay_accumulator, 0.01) then 0.01 else decay_accumulator;
        }
        boost_score +=
            decay_accumulator * calc_frame_boost_in_vp9_firstpass(
                frame_info,
                this_frame,
                TWOPASS,
                avg_frame_qindex,
                this_frame_mv_in_out
            );
        i += 1;
    }

    arf_boost := cast,no_check(s32) boost_score;

    boost_score = 0.0;
    mv_ratio_accumulator = 0.0;
    decay_accumulator = 1.0;
    this_frame_mv_in_out = 0.0;
    mv_in_out_accumulator = 0.0;
    abs_mv_in_out_accumulator = 0.0;

    i = -1;
    while i >= -b_frames {
        this_frame :=
            fps_get_frame_stats_in_vp9_firstpass(
                first_pass_info,
                arf_show_idx + i
            );
        next_frame :=
            fps_get_frame_stats_in_vp9_firstpass(
                first_pass_info,
                arf_show_idx + i + 1
            );
        if this_frame == null {
            break;
        }

        accumulate_frame_motion_stats_in_vp9_firstpass(
            this_frame,
            *this_frame_mv_in_out,
            *mv_in_out_accumulator,
            *abs_mv_in_out_accumulator,
            *mv_ratio_accumulator
        );

        flash_detected =
            cast(s32) (detect_flash_from_frame_stats(this_frame) != 0 ||
                detect_flash_from_frame_stats(next_frame) != 0);

        if flash_detected == 0 {
            decay_accumulator *= get_prediction_decay_rate_in_vp9_firstpass(TWOPASS, this_frame);
            decay_accumulator = ifx c_transpiler_float_less(decay_accumulator, 0.01) then 0.01 else decay_accumulator;
        }
        boost_score +=
            decay_accumulator * calc_frame_boost_in_vp9_firstpass(
                frame_info,
                this_frame,
                TWOPASS,
                avg_frame_qindex,
                this_frame_mv_in_out
            );
        i -= 1;
    }
    arf_boost += cast,no_check(s32) boost_score;

    if arf_boost < (b_frames + f_frames) * 40 {
        arf_boost = (b_frames + f_frames) * 40;
    }
    arf_boost = ifx arf_boost > 250 then arf_boost else 250;

    return arf_boost;
}

calc_frame_boost_in_vp9_firstpass :: (
    frame_info: *FRAME_INFO,
    this_frame: *FIRSTPASS_STATS_in_vp9_cx_iface,
    TWOPASS: *TWO_PASS,
    avg_frame_qindex: s32,
    this_frame_mv_in_out: float64
) -> float64 {
    LQ := vp9_convert_qindex_to_q(avg_frame_qindex, frame_info.bit_depth);
    BOOST_Q_CORRECTION := (ifx c_transpiler_float_less((0.5 + LQ * 0.015), 1.5) then 0.5 + LQ * 0.015 else 1.5);
    ACTIVE_AREA := calculate_active_area(frame_info, this_frame);

    frame_boost :=
        TWOPASS.err_per_mb * ACTIVE_AREA /
            (ifx c_transpiler_float_less(this_frame.coded_error, 0.0) then this_frame.coded_error - 0.000001 else this_frame.coded_error + 0.000001);

    if c_transpiler_float_greater(this_frame_mv_in_out, 0.0) {
        frame_boost += frame_boost * (this_frame_mv_in_out * 2.0);
    }

    frame_boost = frame_boost * BOOST_Q_CORRECTION;

    return ifx c_transpiler_float_less(frame_boost, (TWOPASS.gf_frame_max_boost * BOOST_Q_CORRECTION)) then frame_boost else TWOPASS.gf_frame_max_boost * BOOST_Q_CORRECTION;
}

get_prediction_decay_rate_in_vp9_firstpass :: (
    TWOPASS: *TWO_PASS,
    frame_stats: *FIRSTPASS_STATS_in_vp9_cx_iface
) -> float64 {
    SR_DECAY_RATE := get_sr_decay_rate(TWOPASS, frame_stats);
    zero_motion_factor := TWOPASS.zm_factor * (frame_stats.pcnt_inter - frame_stats.pcnt_motion);

    return ifx c_transpiler_float_greater(zero_motion_factor, (SR_DECAY_RATE + (1.0 - SR_DECAY_RATE) * zero_motion_factor)) then zero_motion_factor else SR_DECAY_RATE + (1.0 - SR_DECAY_RATE) * zero_motion_factor;
}

get_sr_decay_rate :: (TWOPASS: *TWO_PASS, frame: *FIRSTPASS_STATS_in_vp9_cx_iface) -> float64 {
    sr_diff := frame.sr_coded_error - frame.coded_error;
    sr_decay: float64 = 1.0;

    if c_transpiler_float_greater(sr_diff, 0.1) {
        SR_DIFF_PART := TWOPASS.sr_diff_factor * (sr_diff * 0.25 / frame.intra_error);
        modified_pct_inter := frame.pcnt_inter;

        if c_transpiler_float_greater(frame.coded_error, 10.0) &&
            c_transpiler_float_less((frame.intra_error / (ifx c_transpiler_float_less(frame.coded_error, 0.0) then frame.coded_error - 0.000001 else frame.coded_error + 0.000001)), 6.0) {
            modified_pct_inter = frame.pcnt_inter + frame.pcnt_intra_low - frame.pcnt_neutral;
        }
        modified_pcnt_intra := 100.0 * (1.0 - modified_pct_inter);

        sr_decay = 1.0 - SR_DIFF_PART - 0.005 * modified_pcnt_intra;
    }
    return ifx c_transpiler_float_greater(sr_decay, TWOPASS.sr_default_decay_limit) then sr_decay else TWOPASS.sr_default_decay_limit;
}

detect_flash_from_frame_stats :: (frame_stats: *FIRSTPASS_STATS_in_vp9_cx_iface) -> s32 {
    if frame_stats == null {
        return 0;
    }
    if c_transpiler_float_less(frame_stats.sr_coded_error, frame_stats.coded_error) ||
        c_transpiler_float_greater(frame_stats.pcnt_second_ref, frame_stats.pcnt_inter) &&
            c_transpiler_float_greater_equal(frame_stats.pcnt_second_ref, 0.5) {
        return 1;
    }
    return 0;
}

accumulate_frame_motion_stats_in_vp9_firstpass :: (
    stats: *FIRSTPASS_STATS_in_vp9_cx_iface,
    mv_in_out: *float64,
    mv_in_out_accumulator: *float64,
    abs_mv_in_out_accumulator: *float64,
    mv_ratio_accumulator: *float64
) {
    PCT := stats.pcnt_motion;

    mv_in_out.* = stats.mv_in_out_count * PCT;
    mv_in_out_accumulator.* += mv_in_out.*;
    abs_mv_in_out_accumulator.* += c_transpiler_math_fabs(mv_in_out.*);

    if c_transpiler_float_greater(PCT, 0.05) {
        MVR_RATIO :=
            c_transpiler_math_fabs(stats.mvr_abs) /
                (ifx c_transpiler_float_less(c_transpiler_math_fabs(stats.m_vr), 0.0) then c_transpiler_math_fabs(stats.m_vr) - 0.000001 else c_transpiler_math_fabs(stats.m_vr) + 0.000001);
        MVC_RATIO :=
            c_transpiler_math_fabs(stats.mvc_abs) /
                (ifx c_transpiler_float_less(c_transpiler_math_fabs(stats.m_vc), 0.0) then c_transpiler_math_fabs(stats.m_vc) - 0.000001 else c_transpiler_math_fabs(stats.m_vc) + 0.000001);

        mv_ratio_accumulator.* +=
            PCT *
                (ifx c_transpiler_float_less(MVR_RATIO, stats.mvr_abs) then MVR_RATIO else stats.mvr_abs);
        mv_ratio_accumulator.* +=
            PCT *
                (ifx c_transpiler_float_less(MVC_RATIO, stats.mvc_abs) then MVC_RATIO else stats.mvc_abs);
    }
}

ext_rc_define_gf_group_structure :: (gop_decision: *Rc_Gop_Decision_T, gf_group: *GF_GROUP) {
    GOP_CODING_FRAMES := gop_decision.gop_coding_frames;

    SHOW_FRAME_COUNT := GOP_CODING_FRAMES - gop_decision.use_alt_ref;
    frame_index: s32 = 0;
    show_frame_index: s32 = 0;

    {
        i := frame_index;
        while i < GOP_CODING_FRAMES {
            set_gf_frame_type(gop_decision.update_type[i], SHOW_FRAME_COUNT, gf_group, *frame_index, *show_frame_index);

            gf_group.update_ref_idx[i] = gop_decision.update_ref_index[i];

            gf_group.ext_rc_ref[i].last_index = 0;
            gf_group.ext_rc_ref[i].golden_index = 0;
            gf_group.ext_rc_ref[i].altref_index = 0;
            for ref_frame: 0..cast(s32) 3 - 1 {
                EXT_REF_FRAME := gop_decision.ref_frame_list.data + i;
                REF_INDEX := EXT_REF_FRAME.index[ref_frame];
                gf_group.ref_frame_list[i][ref_frame] = EXT_REF_FRAME.index[ref_frame];
                if EXT_REF_FRAME.name[ref_frame] == {
                    case RC_LAST_FRAME;
                        gf_group.ext_rc_ref[i].last_index = REF_INDEX;
                    case RC_GOLDEN_FRAME;
                        gf_group.ext_rc_ref[i].golden_index = REF_INDEX;
                    case RC_ALTREF_FRAME;
                        gf_group.ext_rc_ref[i].altref_index = REF_INDEX;
                    case;
                }
            }
            if gf_group.update_type[i] == cast,no_check(u32) OVERLAY_UPDATE {
                gf_group.update_ref_idx[i] = gf_group.ext_rc_ref[i].altref_index;
            }
            i += 1;
        }
    }

    gf_group.max_layer_depth = 2;
    gf_group.allowed_max_layer_depth = 1;
    gf_group.gf_group_size = GOP_CODING_FRAMES;

    if gop_decision.use_alt_ref != 0 {
        gf_group_set_overlay_frame(gf_group, gf_group.gf_group_size, show_frame_index);
    } else {
        gf_group_set_inter_normal_frame(gf_group, gf_group.gf_group_size, show_frame_index);
    }

    gf_group.frame_start = 0;
    gf_group.frame_end = gf_group.gf_group_size - gop_decision.use_alt_ref;
}

gf_group_set_inter_normal_frame :: (gf_group: *GF_GROUP, frame_index: s32, show_frame_index: s32) {
    gf_group.update_type[frame_index] = cast,no_check(FRAME_UPDATE_TYPE) LF_UPDATE;
    gf_group.arf_src_offset[frame_index] = 0;
    gf_group.frame_gop_index[frame_index] = cast,no_check(u8) show_frame_index;
    gf_group.rf_level[frame_index] = cast,no_check(RATE_FACTOR_LEVEL) INTER_NORMAL;
    gf_group.layer_depth[frame_index] = 2;
}

gf_group_set_overlay_frame :: (gf_group: *GF_GROUP, frame_index: s32, show_frame_index: s32) {
    gf_group.update_type[frame_index] = cast,no_check(FRAME_UPDATE_TYPE) OVERLAY_UPDATE;
    gf_group.arf_src_offset[frame_index] = 0;
    gf_group.frame_gop_index[frame_index] = cast,no_check(u8) show_frame_index;
    gf_group.rf_level[frame_index] = cast,no_check(RATE_FACTOR_LEVEL) INTER_NORMAL;
    gf_group.layer_depth[frame_index] = cast,no_check(u8) (6 - 1);
}

set_gf_frame_type :: (
    update_type: Rc_Frame_Update_Type_T,
    show_frame_count: s32,
    gf_group: *GF_GROUP,
    frame_index: *s32,
    show_frame_index: *s32
) {
    if update_type == RC_KF_UPDATE {
        gf_group_set_key_frame(gf_group, frame_index.*, show_frame_index.*);
        frame_index.* += 1;
        show_frame_index.* += 1;
    } else if update_type == RC_OVERLAY_UPDATE {
        gf_group_set_overlay_frame(gf_group, frame_index.*, show_frame_index.*);
        frame_index.* += 1;
        show_frame_index.* += 1;
    } else if update_type == RC_ARF_UPDATE {
        gf_group_set_arf_frame(gf_group, frame_index.*, show_frame_count);
        frame_index.* += 1;
    } else if update_type == RC_LF_UPDATE {
        gf_group_set_inter_normal_frame(gf_group, frame_index.*, show_frame_index.*);
        frame_index.* += 1;
        show_frame_index.* += 1;
    } else {
    }
}

gf_group_set_arf_frame :: (gf_group: *GF_GROUP, frame_index: s32, show_frame_index: s32) {
    gf_group.update_type[frame_index] = cast,no_check(FRAME_UPDATE_TYPE) ARF_UPDATE;
    gf_group.arf_src_offset[frame_index] = cast,no_check(u8) (show_frame_index - frame_index);
    gf_group.frame_gop_index[frame_index] = cast,no_check(u8) show_frame_index;
    gf_group.rf_level[frame_index] = cast,no_check(RATE_FACTOR_LEVEL) GF_ARF_STD;
    gf_group.layer_depth[frame_index] = 1;
}

gf_group_set_key_frame :: (gf_group: *GF_GROUP, frame_index: s32, show_frame_index: s32) {
    gf_group.update_type[frame_index] = cast,no_check(FRAME_UPDATE_TYPE) KF_UPDATE;
    gf_group.arf_src_offset[frame_index] = 0;
    gf_group.frame_gop_index[frame_index] = cast,no_check(u8) show_frame_index;
    gf_group.rf_level[frame_index] = cast,no_check(RATE_FACTOR_LEVEL) KF_STD;
    gf_group.layer_depth[frame_index] = 0;
}

adjust_group_arnr_filter :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    section_noise: float64,
    section_inter: float64,
    section_motion: float64
) {
    TWOPASS := *cpi.twopass;
    section_zeromv := section_inter - section_motion;

    TWOPASS.arnr_strength_adjustment = 0;

    if c_transpiler_float_less(section_noise, 150.0) {
        TWOPASS.arnr_strength_adjustment -= 1;
        if c_transpiler_float_less(section_noise, 75.0) {
            TWOPASS.arnr_strength_adjustment -= 1;
        }
    } else if c_transpiler_float_greater(section_noise, 250.0) {
        TWOPASS.arnr_strength_adjustment += 1;
    }

    if c_transpiler_float_greater(section_zeromv, 0.5) {
        TWOPASS.arnr_strength_adjustment += 1;
    }
}

get_twopass_worst_quality :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    SECTION_ERR: float64,
    inactive_zone: float64,
    section_noise: float64,
    section_target_bandwidth: s32
) -> s32 {
    RC := *cpi.rc;
    OXCF := *cpi.oxcf;
    TWOPASS := *cpi.twopass;
    last_group_rate_err: float64 = ---;

    TARGET_RATE := vp9_rc_clamp_pframe_target_size(cpi, section_target_bandwidth);
    noise_factor := c_transpiler_math_pow(section_noise / 250.0, 0.5);
    noise_factor = fclamp_in_vp9_firstpass(noise_factor, 0.9, 1.1);
    inactive_zone = fclamp_in_vp9_firstpass(inactive_zone, 0.0, 1.0);

    if TARGET_RATE <= 0 {
        return RC.worst_quality;
    } else {
        NUM_MBS :=
            (ifx cpi.oxcf.resize_mode != cast,no_check(u32) RESIZE_NONE then cpi.initial_mbs else cpi.common.m_bs);
        ACTIVE_PCT := (ifx c_transpiler_float_greater(0.01, (1.0 - inactive_zone)) then 0.01 else 1.0 - inactive_zone);
        ACTIVE_MBS :=
            cast,no_check(s32) ((ifx c_transpiler_float_greater(1.0, ((cast,no_check(float64) NUM_MBS) * ACTIVE_PCT)) then 1.0 else (cast,no_check(float64) NUM_MBS) *
                ACTIVE_PCT));
        AV_ERR_PER_MB := SECTION_ERR / ACTIVE_PCT;
        SPEED_TERM := 1.0 + 0.04 * cast,no_check(float64) OXCF.speed;
        TARGET_NORM_BITS_PER_MB := (cast,no_check(u64) TARGET_RATE) << 9 / cast,no_check(u64) ACTIVE_MBS;

        last_group_rate_err =
            (cast,no_check(float64) TWOPASS.rolling_arf_group_actual_bits) /
                (ifx c_transpiler_float_less(cast,no_check(float64) TWOPASS.rolling_arf_group_target_bits, 0.0) then (cast,no_check(float64) TWOPASS.rolling_arf_group_target_bits) - 0.000001 else (cast,no_check(float64) TWOPASS.rolling_arf_group_target_bits) + 0.000001);
        last_group_rate_err = fclamp_in_vp9_firstpass(last_group_rate_err, 0.25, 4.0);
        TWOPASS.bpm_factor *= (3.0 + last_group_rate_err) / 4.0;
        TWOPASS.bpm_factor = fclamp_in_vp9_firstpass(TWOPASS.bpm_factor, 0.25, 4.0);

        q := RC.best_quality;
        while q < RC.worst_quality {
            FACTOR := calc_correction_factor_in_vp9_firstpass(AV_ERR_PER_MB, wq_err_divisor(cpi), q);
            BITS_PER_MB :=
                (cast,no_check(#type (_: FRAME_TYPE, _: s32, _: float64, _: Bit_Depth_T) -> s32) (cast(*void) vp9_rc_bits_per_mb))(
                    cast,no_check(FRAME_TYPE) INTER_FRAME,
                    q,
                    FACTOR * SPEED_TERM * cpi.twopass.bpm_factor * noise_factor,
                    cpi.common.bit_depth
                );
            if cast,no_check(u64) BITS_PER_MB <= TARGET_NORM_BITS_PER_MB {
                break;
            }
            q += 1;
        }

        if cpi.oxcf.rc_mode == cast,no_check(u32) CQ {
            q = ifx q > OXCF.cq_level then q else OXCF.cq_level;
        }
        return q;
    }
}

wq_err_divisor :: (cpi: *VP9_COMP_in_vp9_encoder) -> float64 {
    CM := *cpi.common;
    screen_area := cast,no_check(u32) (CM.width * CM.height);

    if screen_area <= cast,no_check(u32) (640 * 360) {
        return 115.0;
    } else if screen_area < cast,no_check(u32) (1280 * 720) {
        return 125.0;
    } else if screen_area <= cast,no_check(u32) (1920 * 1080) {
        return 130.0;
    } else if screen_area < cast,no_check(u32) (3840 * 2160) {
        return 150.0;
    }

    return 200.0;
}

calc_correction_factor_in_vp9_firstpass :: (err_per_mb: float64, err_divisor: float64, q: s32) -> float64 {
    ERROR_TERM :=
        err_per_mb /
            (ifx c_transpiler_float_less(err_divisor, 0.0) then err_divisor - 0.000001 else err_divisor + 0.000001);
    INDEX := q >> 5;

    power_term := Q_POW_TERM[INDEX] + (Q_POW_TERM[INDEX + 1] - Q_POW_TERM[INDEX]) * (q % 32) / 32.0;

    if c_transpiler_float_less(power_term, 1.0) {
    }

    return fclamp_in_vp9_firstpass(c_transpiler_math_pow(ERROR_TERM, power_term), 0.05, 5.0);
}

calculate_total_gf_group_bits :: (cpi: *VP9_COMP_in_vp9_encoder, gf_group_err: float64) -> s64 {
    CM := *cpi.common;
    RC := *cpi.rc;
    TWOPASS := *cpi.twopass;
    MAX_BITS := frame_max_bits_in_vp9_firstpass(RC, *cpi.oxcf);
    total_group_bits: s64 = ---;
    IS_KEY_FRAME := frame_is_intra_only_in_vp9_firstpass(CM);
    ARF_ACTIVE_OR_KF := cast(s32) (IS_KEY_FRAME != 0 || RC.source_alt_ref_active != 0);
    gop_frames := RC.baseline_gf_interval + RC.source_alt_ref_pending - ARF_ACTIVE_OR_KF;

    if TWOPASS.kf_group_bits > 0 && c_transpiler_float_greater(TWOPASS.kf_group_error_left, 0.0) {
        key_frame_interval := RC.frames_since_key + RC.frames_to_key;
        distance_from_next_key_frame := RC.frames_to_key - (RC.baseline_gf_interval + RC.source_alt_ref_pending);
        max_gf_bits_bias := RC.avg_frame_bandwidth;
        gf_interval_bias_bits_normalize_factor := (cast,no_check(float64) RC.baseline_gf_interval) / 16.0;
        total_group_bits = cast,no_check(s64) (TWOPASS.kf_group_bits * (gf_group_err / TWOPASS.kf_group_error_left));

        total_group_bits +=
            cast,no_check(s64) ((cast,no_check(float64) distance_from_next_key_frame) /
                key_frame_interval * max_gf_bits_bias * gf_interval_bias_bits_normalize_factor);
    } else {
        total_group_bits = 0;
    }

    total_group_bits =
        ifx total_group_bits < 0 then 0 else (ifx total_group_bits > TWOPASS.kf_group_bits then TWOPASS.kf_group_bits else total_group_bits);

    if total_group_bits > (cast,no_check(s64) MAX_BITS) * cast(s64) gop_frames {
        total_group_bits = (cast,no_check(s64) MAX_BITS) * cast(s64) gop_frames;
    }

    return total_group_bits;
}

detect_flash_in_vp9_firstpass :: (twopass: *TWO_PASS, offset: s32) -> s32 {
    NEXT_FRAME := read_frame_stats_in_vp9_firstpass(twopass, offset);
    return detect_flash_from_frame_stats(NEXT_FRAME);
}

read_frame_stats_in_vp9_firstpass :: (p: *TWO_PASS, offset: s32) -> *FIRSTPASS_STATS_in_vp9_cx_iface {
    if offset >= 0 && p.stats_in + offset >= p.stats_in_end || offset < 0 && p.stats_in + offset < p.stats_in_start {
        return null;
    }

    return *(cast(*FIRSTPASS_STATS_in_vp9_cx_iface) (p.stats_in))[offset];
}

is_altref_enabled_in_vp9_firstpass :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if !(CPI.oxcf.mode == cast,no_check(u32) REALTIME && CPI.oxcf.rc_mode == cast,no_check(u32) CBR) &&
        CPI.oxcf.lag_in_frames >= 4 &&
        CPI.oxcf.enable_auto_arf != 0 {
        return 1;
    }
    return 0;
}

get_gop_coding_frame_num :: (
    use_alt_ref: *s32,
    frame_info: *FRAME_INFO,
    TWOPASS: *TWO_PASS,
    rc: *RATE_CONTROL,
    gf_start_show_idx: s32,
    active_gf_interval: *RANGE,
    gop_intra_factor: float64,
    lag_in_frames: s32,
    end_of_sequence: *s32
) -> s32 {
    first_pass_info := *TWOPASS.first_pass_info;
    loop_decay_rate: float64 = 1.0;
    mv_ratio_accumulator: float64 = 0.0;
    this_frame_mv_in_out: float64 = 0.0;
    mv_in_out_accumulator: float64 = 0.0;
    abs_mv_in_out_accumulator: float64 = 0.0;
    sr_accumulator: float64 = 0.0;

    mv_ratio_accumulator_thresh := (cast,no_check(float64) (frame_info.frame_height + frame_info.frame_width)) / 4.0;
    zero_motion_accumulator: float64 = 1.0;

    use_alt_ref.* = 1;
    gop_coding_frames: s32 = 0;
    while gop_coding_frames < rc.static_scene_max_gf_interval && gop_coding_frames < rc.frames_to_key {
        gop_coding_frames += 1;

        next_frame := fps_get_frame_stats_in_vp9_firstpass(first_pass_info, gf_start_show_idx + gop_coding_frames);
        if next_frame == null {
            end_of_sequence.* = cast(s32) (gop_coding_frames == 1 && rc.source_alt_ref_active != 0);
            break;
        }

        next_next_frame :=
            fps_get_frame_stats_in_vp9_firstpass(
                first_pass_info,
                gf_start_show_idx + gop_coding_frames + 1
            );
        flash_detected := detect_flash_from_frame_stats(next_next_frame);

        accumulate_frame_motion_stats_in_vp9_firstpass(
            next_frame,
            *this_frame_mv_in_out,
            *mv_in_out_accumulator,
            *abs_mv_in_out_accumulator,
            *mv_ratio_accumulator
        );

        if rc.frames_since_key + gop_coding_frames - 1 > 1 {
            zero_motion_accumulator =
                ifx c_transpiler_float_less(zero_motion_accumulator, get_zero_motion_factor(TWOPASS, next_frame)) then zero_motion_accumulator else get_zero_motion_factor(TWOPASS, next_frame);
        }

        if flash_detected == 0 {
            last_loop_decay_rate := loop_decay_rate;
            loop_decay_rate = get_prediction_decay_rate_in_vp9_firstpass(TWOPASS, next_frame);

            if gop_coding_frames > rc.min_gf_interval &&
                c_transpiler_float_greater_equal(loop_decay_rate, 0.999) &&
                c_transpiler_float_less(last_loop_decay_rate, 0.9) {
                still_interval: s32 = 5;
                if check_transition_to_still(first_pass_info, gf_start_show_idx + gop_coding_frames, still_interval) != 0 {
                    use_alt_ref.* = 0;
                    break;
                }
            }

            if gop_coding_frames == 1 {
                sr_accumulator += next_frame.coded_error;
            } else {
                sr_accumulator += next_frame.sr_coded_error - next_frame.coded_error;
            }
        }

        if gop_coding_frames >= active_gf_interval.max &&
            (c_transpiler_float_less(zero_motion_accumulator, 0.995) || rc.source_alt_ref_active != 0) {
            break;
        }
        if gop_coding_frames >= active_gf_interval.min &&
            rc.frames_to_key - gop_coding_frames >= rc.min_gf_interval &&
            gop_coding_frames & 0x1 != 0 &&
            flash_detected == 0 &&
            (c_transpiler_float_greater(mv_ratio_accumulator, mv_ratio_accumulator_thresh) ||
                c_transpiler_float_greater(abs_mv_in_out_accumulator, 4.0) ||
                c_transpiler_float_greater(sr_accumulator, (gop_intra_factor * next_frame.intra_error))) {
            break;
        }
    }
    use_alt_ref.* &= cast(s32) (c_transpiler_float_less(zero_motion_accumulator, 0.995));
    use_alt_ref.* &= cast(s32) (gop_coding_frames < lag_in_frames);
    use_alt_ref.* &= cast(s32) (gop_coding_frames >= rc.min_gf_interval);
    return gop_coding_frames;
}

check_transition_to_still :: (first_pass_info: *FIRST_PASS_INFO, show_idx: s32, still_interval: s32) -> s32 {
    num_frames := fps_get_num_frames_in_vp9_firstpass(first_pass_info);
    if show_idx + still_interval > num_frames {
        return 0;
    }

    j: s32 = 0;
    while j < still_interval {
        stats := fps_get_frame_stats_in_vp9_firstpass(first_pass_info, show_idx + j);
        if c_transpiler_float_less((stats.pcnt_inter - stats.pcnt_motion), 0.999) {
            break;
        }
        j += 1;
    }

    if j == still_interval {
        return 1;
    }
    return 0;
}

get_zero_motion_factor :: (TWOPASS: *TWO_PASS, frame_stats: *FIRSTPASS_STATS_in_vp9_cx_iface) -> float64 {
    ZERO_MOTION_PCT := frame_stats.pcnt_inter - frame_stats.pcnt_motion;
    sr_decay := get_sr_decay_rate(TWOPASS, frame_stats);
    return ifx c_transpiler_float_less(sr_decay, ZERO_MOTION_PCT) then sr_decay else ZERO_MOTION_PCT;
}

get_arf_layers :: (multi_layer_arf: s32, max_layers: s32, coding_frame_num: s32) -> s32 {
    if multi_layer_arf != 0 {
        layers: s32 = 0;

        i := coding_frame_num;
        while i > 0 {
            layers += 1;
            c_transpiler_compound_shr(*(i), (cast(s32) 1), s32, s32);
        }
        layers = min(max_layers, layers);
        return layers;
    } else {
        return 1;
    }
}

get_active_gf_inverval_range :: (
    frame_info: *FRAME_INFO,
    rc: *RATE_CONTROL,
    arf_active_or_kf: s32,
    gf_start_show_idx: s32,
    active_worst_quality: s32,
    last_boosted_qindex: s32
) -> RANGE {
    active_gf_interval: RANGE = ---;
    int_max_q := cast,no_check(s32) vp9_convert_qindex_to_q(active_worst_quality, frame_info.bit_depth);
    q_term :=
        (ifx gf_start_show_idx == 0 then int_max_q /
            32 else cast,no_check(s32) (vp9_convert_qindex_to_q(last_boosted_qindex, frame_info.bit_depth) / 6.0));
    active_gf_interval.min =
        rc.min_gf_interval + arf_active_or_kf +
            (ifx 2 < int_max_q / 200 then 2 else int_max_q / 200);
    active_gf_interval.min =
        ifx active_gf_interval.min < rc.max_gf_interval +
            arf_active_or_kf then active_gf_interval.min else rc.max_gf_interval + arf_active_or_kf;

    active_gf_interval.max = 11 + arf_active_or_kf + (ifx 5 < q_term then 5 else q_term);

    active_gf_interval.max = active_gf_interval.max | 0x1;

    if active_gf_interval.max < active_gf_interval.min {
        active_gf_interval.max = active_gf_interval.min;
    } else {
        active_gf_interval.max =
            ifx active_gf_interval.max < rc.max_gf_interval +
                arf_active_or_kf then active_gf_interval.max else rc.max_gf_interval + arf_active_or_kf;
    }

    if active_gf_interval.max <= rc.frames_to_key && active_gf_interval.max >= rc.frames_to_key - rc.min_gf_interval {
        active_gf_interval.max = rc.frames_to_key / 2;
    }
    active_gf_interval.max =
        ifx active_gf_interval.max > active_gf_interval.min then active_gf_interval.max else active_gf_interval.min;
    return active_gf_interval;
}

find_next_key_frame_in_vp9_firstpass :: (cpi: *VP9_COMP_in_vp9_encoder, kf_show_idx: s32) {
    RC := *cpi.rc;
    TWOPASS := *cpi.twopass;
    GF_GROUP_ := *TWOPASS.gf_group;
    OXCF := *cpi.oxcf;
    first_pass_info := *TWOPASS.first_pass_info;
    frame_info := *cpi.frame_info;
    START_POSITION := TWOPASS.stats_in;
    keyframe_stats :=
        fps_get_frame_stats_in_vp9_firstpass(
            first_pass_info,
            kf_show_idx
        );
    next_frame: FIRSTPASS_STATS_in_vp9_cx_iface = ---;
    kf_bits: s32 = 0;

    zero_motion_accumulator: float64 = 1.0;
    zero_motion_sum: float64 = 0.0;
    zero_motion_avg: float64 = ---;
    motion_compensable_sum: float64 = 0.0;
    motion_compensable_avg: float64 = ---;
    num_frames: s32 = 0;
    kf_boost_scan_frames: s32 = 32;
    boost_score: float64 = 0.0;
    kf_mod_err: float64 = 0.0;
    kf_raw_err: float64 = 0.0;
    kf_group_err: float64 = 0.0;
    sr_accumulator: float64 = 0.0;
    abs_mv_in_out_accumulator: float64 = 0.0;
    AV_ERR := get_distribution_av_err(cpi, TWOPASS);
    MEAN_MOD_SCORE := TWOPASS.mean_mod_score;
    fill_memory(*next_frame, 0, size_of(FIRSTPASS_STATS_in_vp9_cx_iface));

    cpi.common.frame_type = cast,no_check(FRAME_TYPE) KEY_FRAME;
    RC.frames_since_key = 0;

    fill_memory(GF_GROUP_, 0, size_of(GF_GROUP));

    RC.this_key_frame_forced = RC.next_key_frame_forced;

    RC.source_alt_ref_active = 0;

    RC.frames_till_gf_update_due = 0;

    RC.frames_to_key = 1;

    TWOPASS.kf_group_bits = 0;
    TWOPASS.kf_group_error_left = 0.0;

    kf_raw_err = keyframe_stats.intra_error;
    kf_mod_err = calc_norm_frame_score(OXCF, frame_info, keyframe_stats, MEAN_MOD_SCORE, AV_ERR);

    if cpi.ext_ratectrl.ready != 0 &&
        (cpi.ext_ratectrl.funcs.rc_type & cast,no_check(u32) RC_GOP) != 0 &&
        cpi.ext_ratectrl.funcs.get_key_frame_decision != null {
        key_frame_decision: Rc_Key_Frame_Decision_T = ---;
        codec_status :=
            (cast,no_check(#type (_: *EXT_RATECTRL, _: *Rc_Key_Frame_Decision_T) -> Codec_Err_T) (cast(*void) vp9_extrc_get_key_frame_decision))(
                *cpi.ext_ratectrl,
                *key_frame_decision
            );
        if codec_status == cast,no_check(u32) CODEC_OK {
            RC.frames_to_key = key_frame_decision.key_frame_group_size;
        } else {
            internal_error(*cpi.common.error, codec_status, c_string("vp9_extrc_get_key_frame_decision() failed"));
        }
    } else {
        RC.frames_to_key = vp9_get_frames_to_next_key(OXCF, TWOPASS, kf_show_idx, RC.min_gf_interval);
    }

    if RC.frames_to_key >= cpi.oxcf.key_freq {
        RC.next_key_frame_forced = 1;
    } else {
        RC.next_key_frame_forced = 0;
    }

    i: s32 = 0;
    while i < RC.frames_to_key {
        frame_stats :=
            fps_get_frame_stats_in_vp9_firstpass(
                first_pass_info,
                kf_show_idx + i
            );

        kf_group_err += calc_norm_frame_score(OXCF, frame_info, frame_stats, MEAN_MOD_SCORE, AV_ERR);
        i += 1;
    }

    if TWOPASS.bits_left > 0 && c_transpiler_float_greater(TWOPASS.normalized_score_left, 0.0) {
        MAX_BITS := frame_max_bits_in_vp9_firstpass(RC, *cpi.oxcf);

        TWOPASS.kf_group_bits = cast,no_check(s64) (TWOPASS.bits_left * (kf_group_err / TWOPASS.normalized_score_left));

        max_grp_bits := (cast,no_check(s64) MAX_BITS) * cast,no_check(s64) RC.frames_to_key;
        if TWOPASS.kf_group_bits > max_grp_bits {
            TWOPASS.kf_group_bits = max_grp_bits;
        }
    } else {
        TWOPASS.kf_group_bits = 0;
    }
    TWOPASS.kf_group_bits = ifx 0 > TWOPASS.kf_group_bits then 0 else TWOPASS.kf_group_bits;

    boost_score = 0.0;

    i = 0;
    while i < (ifx 48 < RC.frames_to_key - 1 then 48 else RC.frames_to_key - 1) {
        if -1 == input_stats_in_vp9_firstpass(TWOPASS, *next_frame) {
            break;
        }

        zero_motion_sum += next_frame.pcnt_inter - next_frame.pcnt_motion;
        motion_compensable_sum += 1.0 - next_frame.coded_error / next_frame.intra_error;
        num_frames += 1;
        i += 1;
    }

    if num_frames >= 32 {
        zero_motion_avg = zero_motion_sum / num_frames;
        motion_compensable_avg = motion_compensable_sum / num_frames;
        kf_boost_scan_frames =
            cast,no_check(s32) ((ifx c_transpiler_float_greater((64.0 * zero_motion_avg - 16.0), (160.0 * motion_compensable_avg - 112.0)) then 64.0 * zero_motion_avg -
                16.0 else 160.0 * motion_compensable_avg - 112.0));
        kf_boost_scan_frames = clamp_in_vp9_firstpass(kf_boost_scan_frames, 32, 48);
    }
    reset_fpf_position_in_vp9_firstpass(TWOPASS, START_POSITION);

    i = 0;
    while i < RC.frames_to_key - 1 {
        if -1 == input_stats_in_vp9_firstpass(TWOPASS, *next_frame) {
            break;
        }

        if i <= kf_boost_scan_frames || c_transpiler_float_greater_equal(zero_motion_accumulator, 0.99) {
            if i > 0 {
                zero_motion_accumulator =
                    ifx c_transpiler_float_less(zero_motion_accumulator, get_zero_motion_factor(TWOPASS, *next_frame)) then zero_motion_accumulator else get_zero_motion_factor(TWOPASS, *next_frame);
            } else {
                zero_motion_accumulator = next_frame.pcnt_inter - next_frame.pcnt_motion;
            }

            zm_factor := 0.75 + zero_motion_accumulator / 2.0;

            if i < 2 {
                sr_accumulator = 0.0;
            }
            frame_boost := calc_kf_frame_boost(cpi, *next_frame, *sr_accumulator, 0.0, zm_factor);

            boost_score += frame_boost;

            abs_mv_in_out_accumulator += c_transpiler_math_fabs(next_frame.mv_in_out_count * next_frame.pcnt_motion);

            if c_transpiler_float_less(frame_boost, 25.0) ||
                c_transpiler_float_greater(abs_mv_in_out_accumulator, 6.0) ||
                c_transpiler_float_greater(sr_accumulator, (kf_raw_err * 1.5)) {
                break;
            }
        } else {
            break;
        }
        i += 1;
    }

    reset_fpf_position_in_vp9_firstpass(TWOPASS, START_POSITION);

    TWOPASS.kf_zeromotion_pct = cast,no_check(s32) (zero_motion_accumulator * 100.0);

    TWOPASS.key_frame_section_intra_rating =
        cast,no_check(u32) calculate_section_intra_ratio(
            START_POSITION,
            TWOPASS.stats_in_end,
            RC.frames_to_key
        );

    if c_transpiler_float_greater(zero_motion_accumulator, 0.99) && RC.frames_to_key > 8 {
        RC.kf_boost = cast,no_check(s32) TWOPASS.kf_max_total_boost;
    } else {
        RC.kf_boost =
            ifx cast,no_check(s32) boost_score > RC.frames_to_key *
                3 then cast,no_check(s32) boost_score else RC.frames_to_key * 3;
        RC.kf_boost = ifx RC.kf_boost > 300 then RC.kf_boost else 300;
        RC.kf_boost =
            ifx RC.kf_boost < cast,no_check(s32) TWOPASS.kf_max_total_boost then RC.kf_boost else cast,no_check(s32) TWOPASS.kf_max_total_boost;
    }

    kf_bits = calculate_boost_bits(RC.frames_to_key - 1, RC.kf_boost, TWOPASS.kf_group_bits);

    kf_bits += cast,no_check(s32) ((TWOPASS.kf_group_bits - cast(s64) kf_bits) * (kf_mod_err / kf_group_err));
    max_kf_bits := TWOPASS.kf_group_bits - cast(s64) ((RC.frames_to_key - 1) * 200);
    max_kf_bits = lclamp_in_vp9_firstpass(max_kf_bits, 0, 2147483647);
    kf_bits = ifx kf_bits < cast,no_check(s32) max_kf_bits then kf_bits else cast,no_check(s32) max_kf_bits;

    TWOPASS.kf_group_bits -= cast,no_check(s64) kf_bits;

    GF_GROUP_.bit_allocation[0] = kf_bits;
    GF_GROUP_.update_type[0] = cast,no_check(FRAME_UPDATE_TYPE) KF_UPDATE;
    GF_GROUP_.rf_level[0] = cast,no_check(RATE_FACTOR_LEVEL) KF_STD;
    GF_GROUP_.layer_depth[0] = 0;

    TWOPASS.kf_group_error_left = kf_group_err - kf_mod_err;

    TWOPASS.normalized_score_left -= kf_group_err;

    if OXCF.resize_mode == cast,no_check(u32) RESIZE_DYNAMIC {
        cpi.rc.next_frame_size_selector = cast,no_check(FRAME_SCALE_LEVEL) UNSCALED;
    }
}

calc_kf_frame_boost :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    this_frame: *FIRSTPASS_STATS_in_vp9_cx_iface,
    sr_accumulator: *float64,
    this_frame_mv_in_out: float64,
    zm_factor: float64
) -> float64 {
    TWOPASS := *cpi.twopass;

    LQ := vp9_convert_qindex_to_q(cpi.rc.avg_frame_qindex[INTER_FRAME], cpi.common.bit_depth);
    BOOST_Q_CORRECTION := (ifx c_transpiler_float_less((0.5 + LQ * 0.015), 2.0) then 0.5 + LQ * 0.015 else 2.0);
    ACTIVE_AREA := calculate_active_area(*cpi.frame_info, this_frame);

    frame_boost :=
        TWOPASS.kf_err_per_mb * ACTIVE_AREA /
            (ifx c_transpiler_float_less((this_frame.coded_error + sr_accumulator.*), 0.0) then this_frame.coded_error + sr_accumulator.* - 0.000001 else this_frame.coded_error + sr_accumulator.* + 0.000001);

    sr_accumulator.* += this_frame.sr_coded_error - this_frame.coded_error;
    sr_accumulator.* = ifx c_transpiler_float_greater(0.0, sr_accumulator.*) then 0.0 else sr_accumulator.*;

    if c_transpiler_float_greater(this_frame_mv_in_out, 0.0) {
        frame_boost += frame_boost * (this_frame_mv_in_out * 2.0);
    }

    frame_boost = (frame_boost + TWOPASS.kf_frame_min_boost) * BOOST_Q_CORRECTION;

    max_boost :=
        (ifx cpi.common.current_video_frame == 0 then TWOPASS.kf_frame_max_boost_first else TWOPASS.kf_frame_max_boost_subs);
    max_boost *= zm_factor * BOOST_Q_CORRECTION;

    return ifx c_transpiler_float_less(frame_boost, max_boost) then frame_boost else max_boost;
}

vp9_get_frames_to_next_key :: (
    oxcf: *VP9_Encoder_Config,
    TWOPASS: *TWO_PASS,
    kf_show_idx: s32,
    min_gf_interval: s32
) -> s32 {
    first_pass_info := *TWOPASS.first_pass_info;
    recent_loop_decay: [8] float64 = ---;

    frames_to_key: s32 = ---;
    max_frames_to_key := first_pass_info.num_frames - kf_show_idx;
    max_frames_to_key = ifx max_frames_to_key < oxcf.key_freq then max_frames_to_key else oxcf.key_freq;

    for j: 0..cast(s32) 8 - 1 {
        recent_loop_decay[j] = 1.0;
    }

    if oxcf.auto_key == 0 {
        frames_to_key = max_frames_to_key;
    } else {
        frames_to_key = 1;
        while frames_to_key < max_frames_to_key {
            if kf_show_idx + frames_to_key + 1 < first_pass_info.num_frames {
                next_frame :=
                    fps_get_frame_stats_in_vp9_firstpass(
                        first_pass_info,
                        kf_show_idx + frames_to_key + 1
                    );

                if test_candidate_kf_in_vp9_firstpass(first_pass_info, kf_show_idx + frames_to_key) != 0 {
                    break;
                }

                loop_decay_rate := get_prediction_decay_rate_in_vp9_firstpass(TWOPASS, next_frame);

                recent_loop_decay[(frames_to_key - 1) % 8] = loop_decay_rate;
                decay_accumulator: float64 = 1.0;
                for j: 0..cast(s32) 8 - 1 {
                    decay_accumulator *= recent_loop_decay[j];
                }

                if frames_to_key - 1 > min_gf_interval &&
                    c_transpiler_float_greater_equal(loop_decay_rate, 0.999) &&
                    c_transpiler_float_less(decay_accumulator, 0.9) {
                    still_interval := oxcf.key_freq - (frames_to_key - 1);

                    show_idx := kf_show_idx + frames_to_key;
                    if check_transition_to_still(first_pass_info, show_idx, still_interval) != 0 {
                        break;
                    }
                }
            }
            frames_to_key += 1;
        }
    }
    return frames_to_key;
}

test_candidate_kf_in_vp9_firstpass :: (first_pass_info: *FIRST_PASS_INFO, show_idx: s32) -> s32 {
    last_frame := fps_get_frame_stats_in_vp9_firstpass(first_pass_info, show_idx - 1);
    this_frame := fps_get_frame_stats_in_vp9_firstpass(first_pass_info, show_idx);
    next_frame := fps_get_frame_stats_in_vp9_firstpass(first_pass_info, show_idx + 1);
    is_viable_kf: s32 = 0;
    pcnt_intra := 1.0 - this_frame.pcnt_inter;

    detect_flash_from_frame_stats(next_frame);
    if detect_flash_from_frame_stats(this_frame) == 0 &&
        detect_flash_from_frame_stats(next_frame) == 0 &&
        c_transpiler_float_less(this_frame.pcnt_second_ref, 0.2) &&
        (c_transpiler_float_less(this_frame.pcnt_inter, 0.05) ||
            slide_transition(this_frame, last_frame, next_frame) != 0 ||
            intra_step_transition(this_frame, last_frame, next_frame) != 0 ||
            c_transpiler_float_greater(this_frame.coded_error, (next_frame.coded_error * 1.2)) &&
                c_transpiler_float_greater(this_frame.coded_error, (last_frame.coded_error * 1.2)) &&
                c_transpiler_float_greater(pcnt_intra, 0.25) &&
                c_transpiler_float_greater((pcnt_intra + this_frame.pcnt_neutral), 0.5) &&
                c_transpiler_float_less((this_frame.intra_error / (ifx c_transpiler_float_less(this_frame.coded_error, 0.0) then this_frame.coded_error - 0.000001 else this_frame.coded_error + 0.000001)), 2.5)) {
        boost_score: float64 = 0.0;
        old_boost_score: float64 = 0.0;
        decay_accumulator: float64 = 1.0;

        i: s32 = 0;
        while i < 16 {
            frame_stats :=
                fps_get_frame_stats_in_vp9_firstpass(
                    first_pass_info,
                    show_idx + 1 + i
                );
            next_iiratio :=
                12.5 * frame_stats.intra_error /
                    (ifx c_transpiler_float_less(frame_stats.coded_error, 0.0) then frame_stats.coded_error - 0.000001 else frame_stats.coded_error + 0.000001);

            if c_transpiler_float_greater(next_iiratio, 128.0) {
                next_iiratio = 128.0;
            }

            if c_transpiler_float_greater(frame_stats.pcnt_inter, 0.85) {
                decay_accumulator *= frame_stats.pcnt_inter;
            } else {
                decay_accumulator *= (0.85 + frame_stats.pcnt_inter) / 2.0;
            }

            boost_score += decay_accumulator * next_iiratio;

            if c_transpiler_float_less(frame_stats.pcnt_inter, 0.05) ||
                c_transpiler_float_less(next_iiratio, 1.5) ||
                c_transpiler_float_less((frame_stats.pcnt_inter - frame_stats.pcnt_neutral), 0.2) &&
                    c_transpiler_float_less(next_iiratio, 3.0) ||
                c_transpiler_float_less((boost_score - old_boost_score), 3.0) ||
                c_transpiler_float_less(frame_stats.intra_error, 0.5) {
                break;
            }

            old_boost_score = boost_score;

            if show_idx + 1 + i == fps_get_num_frames_in_vp9_firstpass(first_pass_info) - 1 {
                break;
            }
            i += 1;
        }

        if c_transpiler_float_greater(boost_score, 30.0) && i > 3 {
            is_viable_kf = 1;
        } else {
            is_viable_kf = 0;
        }
    }

    return is_viable_kf;
}

intra_step_transition :: (
    this_frame: *FIRSTPASS_STATS_in_vp9_cx_iface,
    last_frame: *FIRSTPASS_STATS_in_vp9_cx_iface,
    next_frame: *FIRSTPASS_STATS_in_vp9_cx_iface
) -> s32 {
    last_pcnt_intra := 1.0 - last_frame.pcnt_inter;
    this_pcnt_intra := 1.0 - this_frame.pcnt_inter;
    next_pcnt_intra := 1.0 - next_frame.pcnt_inter;
    mod_this_intra := this_pcnt_intra + this_frame.pcnt_neutral;

    last_ii_ratio :=
        last_frame.intra_error /
            (ifx c_transpiler_float_less(last_frame.coded_error, 0.0) then last_frame.coded_error - 0.000001 else last_frame.coded_error + 0.000001);
    this_ii_ratio :=
        this_frame.intra_error /
            (ifx c_transpiler_float_less(this_frame.coded_error, 0.0) then this_frame.coded_error - 0.000001 else this_frame.coded_error + 0.000001);
    next_ii_ratio :=
        next_frame.intra_error /
            (ifx c_transpiler_float_less(next_frame.coded_error, 0.0) then next_frame.coded_error - 0.000001 else next_frame.coded_error + 0.000001);

    if c_transpiler_float_less(this_ii_ratio, 2.0) &&
        c_transpiler_float_greater(last_ii_ratio, 2.25) &&
        c_transpiler_float_greater(next_ii_ratio, 2.25) &&
        c_transpiler_float_greater(this_pcnt_intra, (3.0 * last_pcnt_intra)) &&
        c_transpiler_float_greater(this_pcnt_intra, (3.0 * next_pcnt_intra)) &&
        (c_transpiler_float_greater(this_pcnt_intra, 0.075) || c_transpiler_float_greater(mod_this_intra, 0.85)) {
        return 1;
    } else if c_transpiler_float_less(this_ii_ratio, 1.25) &&
        c_transpiler_float_greater(mod_this_intra, 0.85) &&
        c_transpiler_float_less(this_ii_ratio, (last_ii_ratio * 0.9)) &&
        c_transpiler_float_less(this_ii_ratio, (next_ii_ratio * 0.9)) {
        return 1;
    } else {
        return 0;
    }
}

slide_transition :: (
    this_frame: *FIRSTPASS_STATS_in_vp9_cx_iface,
    last_frame: *FIRSTPASS_STATS_in_vp9_cx_iface,
    next_frame: *FIRSTPASS_STATS_in_vp9_cx_iface
) -> s32 {
    if c_transpiler_float_less(this_frame.intra_error, (this_frame.coded_error * 1.5)) &&
        c_transpiler_float_greater(this_frame.coded_error, (last_frame.coded_error * 5.0)) &&
        c_transpiler_float_greater(this_frame.coded_error, (next_frame.coded_error * 5.0)) {
        return 1;
    }
    return 0;
}

vp9_init_vizier_params :: (TWOPASS: *TWO_PASS, screen_area: s32) {
    if TWOPASS.use_vizier_rc_params != 0 {
        TWOPASS.active_wq_factor *= 4.0;
        TWOPASS.err_per_mb *= 12500.0;
        TWOPASS.sr_default_decay_limit *= 0.75;
        if c_transpiler_float_greater(TWOPASS.sr_default_decay_limit, 1.0) {
            TWOPASS.sr_default_decay_limit = 1.0;
        }
        TWOPASS.sr_diff_factor *= 1.0;
        TWOPASS.gf_frame_max_boost *= 96.0;
        TWOPASS.gf_max_total_boost *= 5400.0;

        TWOPASS.kf_frame_min_boost *= 40.0;
        TWOPASS.kf_frame_max_boost_first *= 96.0;
        TWOPASS.kf_frame_max_boost_subs *= 96.0;
        TWOPASS.kf_max_total_boost *= 5400.0;
        TWOPASS.zm_factor *= 0.5;
        if c_transpiler_float_greater(TWOPASS.zm_factor, 1.0) {
            TWOPASS.zm_factor = 1.0;
        }

        if screen_area < 1280 * 720 {
            TWOPASS.kf_err_per_mb *= 2000.0;
        } else if screen_area < 1920 * 1080 {
            TWOPASS.kf_err_per_mb *= 500.0;
        } else {
            TWOPASS.kf_err_per_mb *= 250.0;
        }
    } else {
        TWOPASS.active_wq_factor = 4.0;
        TWOPASS.err_per_mb = 12500.0;
        TWOPASS.sr_default_decay_limit = 0.75;
        TWOPASS.sr_diff_factor = 1.0;
        TWOPASS.gf_frame_max_boost = 96.0;
        TWOPASS.gf_max_total_boost = 5400.0;
        TWOPASS.kf_frame_min_boost = 40.0;
        TWOPASS.kf_frame_max_boost_first = 96.0;
        TWOPASS.kf_frame_max_boost_subs = 96.0;
        TWOPASS.kf_max_total_boost = 5400.0;
        TWOPASS.zm_factor = 0.5;

        if screen_area < 1280 * 720 {
            TWOPASS.kf_err_per_mb = 2000.0;
        } else if screen_area < 1920 * 1080 {
            TWOPASS.kf_err_per_mb = 500.0;
        } else {
            TWOPASS.kf_err_per_mb = 250.0;
        }
    }
}

vp9_twopass_postencode_update :: (cpi: *VP9_COMP_in_vp9_encoder) {
    TWOPASS := *cpi.twopass;
    RC := *cpi.rc;
    CM := *cpi.common;
    BITS_USED := RC.base_frame_target;

    RC.vbr_bits_off_target += cast,no_check(s64) (RC.base_frame_target - RC.projected_frame_size);
    TWOPASS.bits_left =
        ifx (TWOPASS.bits_left - cast(s64) BITS_USED) > 0 then TWOPASS.bits_left -
            cast(s64) BITS_USED else 0;

    TWOPASS.rolling_arf_group_target_bits += RC.this_frame_target;
    TWOPASS.rolling_arf_group_actual_bits += RC.projected_frame_size;

    if RC.total_actual_bits != 0 {
        RC.rate_error_estimate = cast,no_check(s32) ((RC.vbr_bits_off_target * 100) / RC.total_actual_bits);
        RC.rate_error_estimate = clamp_in_vp9_firstpass(RC.rate_error_estimate, -100, 100);
    } else {
        RC.rate_error_estimate = 0;
    }

    if cpi.common.frame_type != cast,no_check(u32) KEY_FRAME {
        TWOPASS.kf_group_bits -= cast,no_check(s64) BITS_USED;
        TWOPASS.last_kfgroup_zeromotion_pct = TWOPASS.kf_zeromotion_pct;
    }
    TWOPASS.kf_group_bits = ifx TWOPASS.kf_group_bits > 0 then TWOPASS.kf_group_bits else 0;

    TWOPASS.gf_group.index += 1;

    if cpi.oxcf.rc_mode != cast,no_check(u32) Q && cpi.rc.is_src_frame_alt_ref == 0 {
        MAXQ_ADJ_LIMIT := RC.worst_quality - TWOPASS.active_worst_quality;
        MINQ_ADJ_LIMIT_ := (ifx cpi.oxcf.rc_mode == cast,no_check(u32) CQ then cast(s32) 20 else 48);
        aq_extend_min: s32 = 0;
        aq_extend_max: s32 = 0;

        if cpi.oxcf.aq_mode != cast,no_check(u32) NO_AQ &&
            cpi.oxcf.aq_mode != cast,no_check(u32) PSNR_AQ &&
            cpi.oxcf.aq_mode != cast,no_check(u32) PERCEPTUAL_AQ {
            if CM.seg.aq_av_offset < 0 {
                aq_extend_min = 0;
                aq_extend_max = ifx MAXQ_ADJ_LIMIT < -CM.seg.aq_av_offset then MAXQ_ADJ_LIMIT else -CM.seg.aq_av_offset;
            } else {
                aq_extend_min = ifx MINQ_ADJ_LIMIT_ < CM.seg.aq_av_offset then MINQ_ADJ_LIMIT_ else CM.seg.aq_av_offset;
                aq_extend_max = 0;
            }
        }

        if RC.rate_error_estimate > cpi.oxcf.under_shoot_pct {
            TWOPASS.extend_maxq -= 1;
            if RC.rolling_target_bits >= RC.rolling_actual_bits {
                TWOPASS.extend_minq += 1;
            }
        } else if RC.rate_error_estimate < -cpi.oxcf.over_shoot_pct {
            TWOPASS.extend_minq -= 1;
            if RC.rolling_target_bits < RC.rolling_actual_bits {
                TWOPASS.extend_maxq += 1;
            }
        } else {
            if RC.projected_frame_size > 2 * RC.base_frame_target && RC.projected_frame_size > 2 * RC.avg_frame_bandwidth {
                TWOPASS.extend_maxq += 1;
            }

            if RC.rolling_target_bits < RC.rolling_actual_bits {
                TWOPASS.extend_minq -= 1;
            } else if RC.rolling_target_bits > RC.rolling_actual_bits {
                TWOPASS.extend_maxq -= 1;
            }
        }

        TWOPASS.extend_minq = clamp_in_vp9_firstpass(TWOPASS.extend_minq, aq_extend_min, MINQ_ADJ_LIMIT_);
        TWOPASS.extend_maxq = clamp_in_vp9_firstpass(TWOPASS.extend_maxq, aq_extend_max, MAXQ_ADJ_LIMIT);

        if frame_is_kf_gf_arf_in_vp9_firstpass(cpi) == 0 && cpi.rc.is_src_frame_alt_ref == 0 {
            fast_extra_thresh := RC.base_frame_target / 2;
            if RC.projected_frame_size < fast_extra_thresh {
                RC.vbr_bits_off_target_fast += cast,no_check(s64) (fast_extra_thresh - RC.projected_frame_size);
                RC.vbr_bits_off_target_fast =
                    ifx RC.vbr_bits_off_target_fast < 4 * cast,no_check(s64) RC.avg_frame_bandwidth then RC.vbr_bits_off_target_fast else 4 *
                        cast,no_check(s64) RC.avg_frame_bandwidth;

                if RC.avg_frame_bandwidth != 0 {
                    TWOPASS.extend_minq_fast =
                        cast,no_check(s32) ((RC.vbr_bits_off_target_fast * 8) /
                            cast(s64) RC.avg_frame_bandwidth);
                }
                TWOPASS.extend_minq_fast =
                    ifx TWOPASS.extend_minq_fast < MINQ_ADJ_LIMIT_ -
                        TWOPASS.extend_minq then TWOPASS.extend_minq_fast else MINQ_ADJ_LIMIT_ - TWOPASS.extend_minq;
            } else if RC.vbr_bits_off_target_fast != 0 {
                TWOPASS.extend_minq_fast =
                    ifx TWOPASS.extend_minq_fast < MINQ_ADJ_LIMIT_ -
                        TWOPASS.extend_minq then TWOPASS.extend_minq_fast else MINQ_ADJ_LIMIT_ - TWOPASS.extend_minq;
            } else {
                TWOPASS.extend_minq_fast = 0;
            }
        }
    }
}

frame_is_kf_gf_arf_in_vp9_firstpass :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if frame_is_intra_only_in_vp9_firstpass(*cpi.common) != 0 ||
        cpi.refresh_alt_ref_frame != 0 ||
        cpi.refresh_golden_frame != 0 && cpi.rc.is_src_frame_alt_ref == 0 {
        return 1;
    }
    return 0;
}

calculate_coded_size :: (cpi: *VP9_COMP_in_vp9_encoder, scaled_frame_width: *s32, scaled_frame_height: *s32) {
    RC := *cpi.rc;
    scaled_frame_width.* = RC.frame_width[RC.frame_size_selector];
    scaled_frame_height.* = RC.frame_height[RC.frame_size_selector];
}

vp9_get_frame_stats :: (result: *FIRSTPASS_STATS_in_vp9_cx_iface, twopass: *TWO_PASS) {
    result.* = twopass.this_frame_stats;
}

vp9_get_total_stats :: (result: *FIRSTPASS_STATS_in_vp9_cx_iface, twopass: *TWO_PASS) {
    result.* = twopass.total_stats;
}

get_buf_from_mv_in_vp9_firstpass :: (buf: *Buf_2d, mv: *MV) -> *u8 {
    return *buf.buf[(cast(s32) mv.row) * buf.stride + cast(s32) mv.col];
}

cost_branch256_in_vp9_firstpass :: (ct: *u32, p: Prob) -> u64 {
    return ((cast,no_check(u64) ct[0]) * cast(u64) VP9_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP9_PROB_COST[256 - cast(s32) p];
}

treed_cost_in_vp9_firstpass :: (tree: *Tree_Index, probs: *Prob, bits: s32, len: s32) -> s32 {
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

rd_less_than_thresh_in_vp9_firstpass :: (best_rd: s64, thresh: s32, THRESH_FACT: *s32) -> s32 {
    if best_rd < ((cast,no_check(s64) thresh) * cast(s64) THRESH_FACT.*) >> 5 || thresh == 2147483647 {
        return 1;
    }
    return 0;
}

set_error_per_bit_in_vp9_firstpass :: (x: *MACROBLOCK, rdmult: s32) {
    x.errorperbit = rdmult >> 6;
    x.errorperbit += cast(s32) (x.errorperbit == 0);
}

write_in_vp9_firstpass :: (br: *Writer, bit: s32, probability: s32) {
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

write_bit_in_vp9_firstpass :: (w: *Writer, bit: s32) {
    write_in_vp9_firstpass(w, bit, 128);
}

write_literal_in_vp9_firstpass :: (w: *Writer, data: s32, bits: s32) {
    bit := bits - 1;
    while bit >= 0 {
        write_bit_in_vp9_firstpass(w, 1 & (data >> ((bit) & 31)));
        bit -= 1;
    }
}

vp9_write_tree_in_vp9_firstpass :: (w: *Writer, tree: *Tree_Index, probs: *Prob, bits: s32, len: s32, i: Tree_Index) {
    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            write_in_vp9_firstpass(w, BIT, cast,no_check(s32) probs[(cast(s32) i) >> 1]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }
}

vp9_write_token_in_vp9_firstpass :: (w: *Writer, tree: *Tree_Index, probs: *Prob, token: *Vp9_Token) {
    vp9_write_tree_in_vp9_firstpass(w, tree, probs, token.value, token.len, 0);
}

vp9_get_high_cost_table_in_vp9_firstpass :: (bit_depth: s32) -> *u16 {
    return VP9_CAT6_HIGH_COST.data;
}

vp9_get_token_extra_in_vp9_firstpass :: (v: s32, token: *s16, extra: *EXTRABIT) {
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

vp9_get_token_in_vp9_firstpass :: (v: s32) -> s16 {
    if v >= 67 || v <= -67 {
        return 10;
    }
    return vp9_dct_cat_lt_10_value_tokens[v].token;
}

vp9_get_token_cost_in_vp9_firstpass :: (v: s32, token: *s16, cat6_high_table: *u16) -> s32 {
    if v >= 67 || v <= -67 {
        token.* = 10;
        extrabits := cast,no_check(EXTRABIT) (absolute_value(v) - 67);
        return (cast(s32) VP9_CAT6_LOW_COST[extrabits & 0xff]) + cast(s32) cat6_high_table[(cast(s32) extrabits) >> 8];
    }
    token.* = vp9_dct_cat_lt_10_value_tokens[v].token;
    return vp9_dct_cat_lt_10_value_cost[v];
}

stack_pop_in_vp9_firstpass :: (stack: *s32, stack_size: s32) -> s32 {
    R := stack[0];
    if 1 < stack_size {
        for idx: 1..stack_size - 1 {
            stack[idx - 1] = stack[idx];
        }
    }

    return R;
}

stack_top_in_vp9_firstpass :: (stack: *s32) -> s32 {
    return stack[0];
}

stack_push_in_vp9_firstpass :: (stack: *s32, new_item: s32, stack_size: s32) {
    idx := stack_size;
    while idx > 0 {
        stack[idx] = stack[idx - 1];
        idx -= 1;
    }
    stack[0] = new_item;
}

stack_init_in_vp9_firstpass :: (stack: *s32, length: s32) {
    if 0 < length {
        for idx: 0..length - 1 {
            stack[idx] = -1;
        }
    }
}

ref_frame_to_flag_in_vp9_firstpass :: (ref_frame: s8) -> s32 {

    return K_VP9_REF_FLAG_LIST_in_vp9_firstpass[ref_frame];
}

get_ref_cnt_buffer_in_vp9_firstpass :: (cm: *VP9_COMMON, fb_idx: s32) -> *Ref_Cnt_Buffer {
    return ifx fb_idx != -1 then cm.buffer_pool.frame_bufs.data + fb_idx else null;
}

get_ref_frame_bufs_in_vp9_firstpass :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame_bufs: **Ref_Cnt_Buffer) {
    CM := *cpi.common;

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame < 4 {
        ref_frame_buf_idx := get_ref_frame_buf_idx_in_vp9_firstpass(cpi, cast,no_check(s32) ref_frame);
        inter_ref_idx := mv_ref_frame_to_inter_ref_idx_in_vp9_firstpass(ref_frame);
        ref_frame_bufs[inter_ref_idx] = get_ref_cnt_buffer_in_vp9_firstpass(CM, ref_frame_buf_idx);
        ref_frame += 1;
    }
}

get_token_alloc_in_vp9_firstpass :: (mb_rows: s32, mb_cols: s32) -> s64 {
    ALIGNED_MB_ROWS :=
        (mb_rows +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    ALIGNED_MB_COLS :=
        (mb_cols +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    return ((cast,no_check(s64) ALIGNED_MB_ROWS) * cast(s64) ALIGNED_MB_COLS) * cast,no_check(s64) ((cast,no_check(s32) ((16 * 16))) * 3 + 4);
}

allocated_tokens_in_vp9_firstpass :: (tile: Tile_Info) -> s64 {
    tile_mb_rows := (tile.mi_row_end - tile.mi_row_start + 1) >> 1;
    tile_mb_cols := (tile.mi_col_end - tile.mi_col_start + 1) >> 1;

    return get_token_alloc_in_vp9_firstpass(tile_mb_rows, tile_mb_cols);
}

get_start_tok_in_vp9_firstpass :: (
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

    tok.* = cpi.tile_tok[tile_row][tile_col] + get_token_alloc_in_vp9_firstpass(MB_ROW, tile_mb_cols);
}

is_one_pass_svc_in_vp9_firstpass :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if CPI.use_svc != 0 && CPI.oxcf.pass == 0 {
        return 1;
    }
    return 0;
}

set_ref_ptrs_in_vp9_firstpass :: (
    CM: *VP9_COMMON,
    xd: *MACROBLOCKD,
    ref0: MV_REFERENCE_FRAME,
    ref1: MV_REFERENCE_FRAME
) {
    xd.block_refs[0] = CM.frame_refs.data + (ifx ref0 >= 1 then (cast(s32) ref0) - 1 else 0);
    xd.block_refs[1] = CM.frame_refs.data + (ifx ref1 >= 1 then (cast(s32) ref1) - 1 else 0);
}

get_chessboard_index_in_vp9_firstpass :: (FRAME_INDEX: s32) -> s32 {
    return FRAME_INDEX & 0x1;
}

cond_cost_list_in_vp9_firstpass :: (cpi: *VP9_COMP_in_vp9_encoder, cost_list: *s32) -> *s32 {
    return ifx cpi.sf.mv.subpel_search_method != cast,no_check(u32) SUBPEL_TREE then cost_list else null;
}

get_num_vert_units_in_vp9_firstpass :: (tile: Tile_Info, shift: s32) -> s32 {
    num_vert_units := (tile.mi_row_end - tile.mi_row_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_vert_units;
}

get_level_index_in_vp9_firstpass :: (level: VP9_LEVEL) -> s32 {
    for i: 0..cast(s32) 14 - 1 {
        if level == VP9_LEVEL_DEFS[i].level {
            return i;
        }
    }
    return -1;
}

log_tile_cols_from_picsize_level_in_vp9_firstpass :: (width: u32, height: u32) -> s32 {
    PIC_SIZE := width * height;
    PIC_BREADTH := max(width, height);
    for i: 0..cast(s32) 14 - 1 {
        if VP9_LEVEL_DEFS[i].max_luma_picture_size >= PIC_SIZE && VP9_LEVEL_DEFS[i].max_luma_picture_breadth >= PIC_BREADTH {
            return get_msb_in_vp9_firstpass(cast,no_check(u32) VP9_LEVEL_DEFS[i].max_col_tiles);
        }
    }
    return 2147483647;
}

alloc_frame_mvs_in_vp9_firstpass :: (CM: *VP9_COMMON, buffer_idx: s32) {
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

num_4x4_to_edge_in_vp9_firstpass :: (
    plane_4x4_dim: s32,
    mb_to_edge_dim: s32,
    subsampling_dim: s32,
    blk_dim: s32
) -> s32 {
    return plane_4x4_dim + mb_to_edge_dim >> (((5 + subsampling_dim)) & 31) - blk_dim;
}

sum_squares_visible_in_vp9_firstpass :: (
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
        num_4x4_to_edge_in_vp9_firstpass(
            PLANE_4X4_W,
            xd.mb_to_right_edge,
            PD.subsampling_x,
            blk_col
        );
    B4X4S_TO_BOTTOM_EDGE :=
        num_4x4_to_edge_in_vp9_firstpass(
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

do_trellis_opt_in_vp9_firstpass :: (
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
                    sum_squares_visible_in_vp9_firstpass(
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

globals_initialization_state_for_vp9_firstpass: u32;
initialize_globals_for_vp9_firstpass :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_firstpass);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_firstpass, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_firstpass) != 2 {}
            return;
        }
    }
    K_VP9_REF_FLAG_LIST_in_vp9_firstpass =
        s32.[ 0, cast,no_check(s32) (VP9_LAST_FLAG), cast,no_check(s32) (VP9_GOLD_FLAG), cast,no_check(s32) (VP9_ALT_FLAG) ];
    SUB_PEL_FILTERS_12_in_vp9_firstpass =
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
    COUNT_TO_UPDATE_FACTOR_in_vp9_firstpass =
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
    FRAME_SCALE_FACTOR_in_vp9_firstpass = s32.[ 16, 24 ];
    RATE_THRESH_MULT_in_vp9_firstpass = float64.[ 1.0, 2.0 ];
    RCF_MULT_in_vp9_firstpass = float64.[ 1.0, 2.0 ];
    fp_dn_kernel_3 =
        u8.[
            1,
            2,
            1,
            2,
            4,
            2,
            1,
            2,
            1
        ];
    Q_POW_TERM =
        float64.[
            0.65,
            0.7,
            0.75,
            0.85,
            0.9,
            0.9,
            0.9,
            1.0,
            1.25
        ];
    atomic_store(*globals_initialization_state_for_vp9_firstpass, 2);
}

