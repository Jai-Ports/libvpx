// Generated directly from C by cpp_transpiler.
SUB_PEL_FILTERS_12_in_vp9_rd: [16] Interp_Kernel12 #align 256;

COUNT_TO_UPDATE_FACTOR_in_vp9_rd: [21] s32;

MODE_2_COUNTER_in_vp9_rd: [14] s32;

COUNTER_TO_CONTEXT_in_vp9_rd: [19] s32;

MV_REF_BLOCKS_in_vp9_rd: [13] [8] POSITION;

IDX_N_COLUMN_TO_SUBBLOCK_in_vp9_rd: [4] [2] s32;

FRAME_SCALE_FACTOR_in_vp9_rd: [2] s32;

RATE_THRESH_MULT_in_vp9_rd: [2] float64;

RCF_MULT_in_vp9_rd: [2] float64;

RD_BOOST_FACTOR: [16] s32;

RD_FRAME_TYPE_FACTOR: [7] s32;

RD_THRESH_BLOCK_SIZE_FACTOR: [13] u8;

sad_per_bit4lut_8: [256] s32;

sad_per_bit16lut_8: [256] s32;

MAX_XSQ_Q10: u32;

XSQ_IQ_Q10: [104] s32;

DIST_TAB_Q10: [104] s32;

RATE_TAB_Q10: [104] s32;

THRESH_MULT: [2] [6] s32;

K_VP9_REF_FLAG_LIST_in_vp9_rd: [4] s32;

clip_pixel_in_vp9_rd :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_rd :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_rd :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_rd :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_rd :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_rd(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_rd(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_rd(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_rd :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_lsb_in_vp9_rd :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_rd :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_rd :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_rd(num_values) + 1 else 0;
}

get_filter_taps_in_vp9_rd :: (FILTER: *s16) -> s32 {
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

get_prob_in_vp9_rd :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_rd :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_rd(n0, DEN);
}

weighted_prob_in_vp9_rd :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_rd :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_rd(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_rd(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_rd :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_rd[COUNT];
        PROB := get_prob_in_vp9_rd(ct[0], DEN);
        return weighted_prob_in_vp9_rd(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_band_translate_in_vp9_rd :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_rd :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_rd :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_rd(above_ec, left_ec);
}

is_zero_mv_in_vp9_rd :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_rd :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_rd :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_rd(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_rd(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_rd :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_rd :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_rd :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_rd :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

vp9_is_valid_scale_in_vp9_rd :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_rd :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_rd(sf) != 0 && (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_rd :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_rd :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_rd :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_rd :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_rd :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_rd :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_rd :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_rd :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_rd :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_rd :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_rd :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_rd(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_rd :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_rd(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_rd(MI, ib)];
}

get_uv_tx_size_in_vp9_rd :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_rd :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_rd :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_rd(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_rd :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_rd :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_rd :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_rd :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_rd :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_rd :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_rd :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_rd :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_rd :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_rd :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_rd :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_rd :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_rd :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_rd(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_rd :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_rd(cm.mi_cols);

        if get_plane_type_in_vp9_rd(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_rd(cm, xd);
}

get_partition_probs_in_vp9_rd :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_rd :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_rd :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_rd :: (
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

update_partition_context_in_vp9_rd :: (
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

partition_plane_context_in_vp9_rd :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

clamp_mv_ref_in_vp9_rd :: (mv: *MV, xd: *MACROBLOCKD) {
    clamp_mv_in_vp9_rd(
        mv,
        xd.mb_to_left_edge - (cast(s32) 16) << 3,
        xd.mb_to_right_edge + (cast(s32) 16) << 3,
        xd.mb_to_top_edge - (cast(s32) 16) << 3,
        xd.mb_to_bottom_edge + (cast(s32) 16) << 3
    );
}

get_sub_block_mv_in_vp9_rd :: (candidate: *MODE_INFO, which_mv: s32, search_col: s32, block_idx: s32) -> Int_Mv {
    return ifx block_idx >= 0 && candidate.sb_type < 3 then candidate.bmi[IDX_N_COLUMN_TO_SUBBLOCK_in_vp9_rd[block_idx][cast(s32) (search_col == 0)]].as_mv[which_mv] else candidate.mv[which_mv];
}

scale_mv_in_vp9_rd :: (mi: *MODE_INFO, ref: s32, THIS_REF_FRAME: MV_REFERENCE_FRAME, ref_sign_bias: *s32) -> Int_Mv {
    mv := mi.mv[ref];
    if ref_sign_bias[mi.ref_frame[ref]] != ref_sign_bias[THIS_REF_FRAME] {
        mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mv.as_mv.row) * -1);
        mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mv.as_mv.col) * -1);
    }
    return mv;
}

is_inside_in_vp9_rd :: (TILE: *Tile_Info, mi_col: s32, mi_row: s32, mi_rows: s32, mi_pos: *POSITION) -> s32 {
    if !(mi_row + mi_pos.row < 0 || mi_col + mi_pos.col < TILE.mi_col_start || mi_row + mi_pos.row >= mi_rows || mi_col + mi_pos.col >= TILE.mi_col_end) {
        return 1;
    }
    return 0;
}

clamp_mv2_in_vp9_rd :: (mv: *MV, xd: *MACROBLOCKD) {
    clamp_mv_in_vp9_rd(
        mv,
        xd.mb_to_left_edge - (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_right_edge + (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_top_edge - (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_bottom_edge + (cast,no_check(s32) ((160 - 4))) << 3
    );
}

lower_mv_precision_in_vp9_rd :: (mv: *MV, allow_hp: s32) {
    USE_HP := cast(s32) (allow_hp != 0 && use_mv_hp_in_vp9_rd(mv) != 0);
    if USE_HP == 0 {
        if mv.row & 1 != 0 {
            c_transpiler_compound_add(*(mv.row), ((ifx mv.row > 0 then cast(s32) -1 else 1)), s32, s32);
        }
        if mv.col & 1 != 0 {
            c_transpiler_compound_add(*(mv.col), ((ifx mv.col > 0 then cast(s32) -1 else 1)), s32, s32);
        }
    }
}

get_segment_id_in_vp9_rd :: (cm: *VP9_COMMON, segment_ids: *u8, bsize: BLOCK_SIZE, mi_row: s32, mi_col: s32) -> s32 {
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

vp9_get_pred_context_seg_id_in_vp9_rd :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    ABOVE_SIP := (ifx ABOVE_MI != null then cast,no_check(s32) ABOVE_MI.seg_id_predicted else 0);
    LEFT_SIP := (ifx LEFT_MI != null then cast,no_check(s32) LEFT_MI.seg_id_predicted else 0);

    return ABOVE_SIP + LEFT_SIP;
}

vp9_get_pred_prob_seg_id_in_vp9_rd :: (seg: *Segmentation, xd: *MACROBLOCKD) -> Prob {
    return seg.pred_probs[vp9_get_pred_context_seg_id_in_vp9_rd(xd)];
}

vp9_get_skip_context_in_vp9_rd :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    ABOVE_SKIP := (ifx ABOVE_MI != null then cast,no_check(s32) ABOVE_MI.skip else 0);
    LEFT_SKIP := (ifx LEFT_MI != null then cast,no_check(s32) LEFT_MI.skip else 0);
    return ABOVE_SKIP + LEFT_SKIP;
}

vp9_get_skip_prob_in_vp9_rd :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.skip_probs[vp9_get_skip_context_in_vp9_rd(xd)];
}

get_pred_context_switchable_interp_in_vp9_rd :: (xd: *MACROBLOCKD) -> s32 {
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

get_intra_inter_context_in_vp9_rd :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    HAS_ABOVE := cast(s32) (ABOVE_MI != null);
    HAS_LEFT := cast(s32) (LEFT_MI != null);

    if HAS_ABOVE != 0 && HAS_LEFT != 0 {
        ABOVE_INTRA := cast(s32) (is_inter_block_in_vp9_rd(ABOVE_MI) == 0);
        LEFT_INTRA := cast(s32) (is_inter_block_in_vp9_rd(LEFT_MI) == 0);
        return ifx LEFT_INTRA != 0 && ABOVE_INTRA != 0 then 3 else cast(s32) (LEFT_INTRA != 0 || ABOVE_INTRA != 0);
    } else if HAS_ABOVE != 0 || HAS_LEFT != 0 {
        return 2 * cast(s32) (is_inter_block_in_vp9_rd((ifx HAS_ABOVE != 0 then ABOVE_MI else LEFT_MI)) == 0);
    }
    return 0;
}

vp9_get_intra_inter_prob_in_vp9_rd :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.intra_inter_prob[get_intra_inter_context_in_vp9_rd(xd)];
}

vp9_get_reference_mode_prob_in_vp9_rd :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.comp_inter_prob[vp9_get_reference_mode_context(cm, xd)];
}

vp9_get_pred_prob_comp_ref_p_in_vp9_rd :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    PRED_CONTEXT := vp9_get_pred_context_comp_ref_p(cm, xd);
    return cm.fc.comp_ref_prob[PRED_CONTEXT];
}

vp9_get_pred_prob_single_ref_p1_in_vp9_rd :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return ((cm.fc.single_ref_prob[vp9_get_pred_context_single_ref_p1(xd)]).data)[0];
}

vp9_get_pred_prob_single_ref_p2_in_vp9_rd :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return ((cm.fc.single_ref_prob[vp9_get_pred_context_single_ref_p2(xd)]).data)[1];
}

get_tx_size_context_in_vp9_rd :: (xd: *MACROBLOCKD) -> s32 {
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

get_tx_probs_in_vp9_rd :: (max_tx_size: TX_SIZE, ctx: s32, tx_probs: *Tx_Probs) -> *Prob {
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

get_tx_counts_in_vp9_rd :: (max_tx_size: TX_SIZE, ctx: s32, tx_counts: *Tx_Counts) -> *u32 {
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

inter_predictor_in_vp9_rd :: (
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

scaled_buffer_offset_in_vp9_rd :: (x_offset: s32, y_offset: s32, stride: s32, sf: *Scale_Factors) -> s64 {
    X := (ifx sf != null then sf.scale_value_x(x_offset, sf) else x_offset);
    Y := (ifx sf != null then sf.scale_value_y(y_offset, sf) else y_offset);
    return ((cast,no_check(s64) Y) * cast(s64) stride) + cast(s64) X;
}

setup_pred_plane_in_vp9_rd :: (
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
    dst.buf = src + scaled_buffer_offset_in_vp9_rd(X, Y, stride, scale);
    dst.stride = stride;
}

cost_branch256_in_vp9_rd :: (ct: *u32, p: Prob) -> u64 {
    return ((cast,no_check(u64) ct[0]) * cast(u64) VP9_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP9_PROB_COST[256 - cast(s32) p];
}

treed_cost_in_vp9_rd :: (tree: *Tree_Index, probs: *Prob, bits: s32, len: s32) -> s32 {
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

vp8_set_reference_value_in_vp9_rd :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_vp9_rd :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_vp9_rd :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_vp9_rd :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_vp9_rd :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_vp9_rd :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_vp9_rd :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_vp9_rd :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_vp9_rd :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_vp9_rd :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_vp9_rd :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_vp9_rd :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_vp9_rd :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_vp9_rd :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_vp9_rd :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_vp9_rd :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_vp9_rd :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_vp9_rd :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_vp9_rd :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_vp9_rd :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_vp9_rd :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_vp9_rd :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_vp9_rd :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_vp9_rd :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_vp9_rd :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_vp9_rd :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

gcd_in_vp9_rd :: (a: s64, b: s32) -> s32 {
    while b != 0 {
        r := cast,no_check(s32) (a % cast(s64) b);
        a = cast,no_check(s64) b;
        b = r;
    }

    return cast,no_check(s32) a;
}

reduce_ratio_in_vp9_rd :: (ratio: *Rational64_T) {
    DENOM := gcd_in_vp9_rd(ratio.num, ratio.den);
    ratio.num /= cast,no_check(s64) DENOM;
    ratio.den /= DENOM;
}

cyclic_refresh_segment_id_boosted_in_vp9_rd :: (segment_id: s32) -> s32 {
    if segment_id == 1 || segment_id == 2 {
        return 1;
    }
    return 0;
}

cyclic_refresh_segment_id_in_vp9_rd :: (segment_id: s32) -> s32 {
    if segment_id == 1 {
        return 1;
    } else if segment_id == 2 {
        return 2;
    } else {
        return 0;
    }
}

fps_init_first_pass_info_in_vp9_rd :: (
    first_pass_info: *FIRST_PASS_INFO,
    stats: *FIRSTPASS_STATS_in_vp9_cx_iface,
    num_frames: s32
) {
    first_pass_info.stats = stats;
    first_pass_info.num_frames = num_frames;
}

fps_get_num_frames_in_vp9_rd :: (first_pass_info: *FIRST_PASS_INFO) -> s32 {
    return first_pass_info.num_frames;
}

fps_get_frame_stats_in_vp9_rd :: (
    first_pass_info: *FIRST_PASS_INFO,
    show_idx: s32
) -> *FIRSTPASS_STATS_in_vp9_cx_iface {
    if show_idx < 0 || show_idx >= first_pass_info.num_frames {
        return null;
    }
    return *(cast(*FIRSTPASS_STATS_in_vp9_cx_iface) (first_pass_info.stats))[show_idx];
}

get_buf_from_mv_in_vp9_rd :: (buf: *Buf_2d, mv: *MV) -> *u8 {
    return *buf.buf[(cast(s32) mv.row) * buf.stride + cast(s32) mv.col];
}

vp9_rd_cost_reset :: (rd_cost: *RD_COST) {
    rd_cost.rate = 2147483647;
    rd_cost.dist = 9223372036854775807;
    rd_cost.rdcost = 9223372036854775807;
}

vp9_rd_cost_init :: (rd_cost: *RD_COST) {
    rd_cost.rate = 0;
    rd_cost.dist = 0;
    rd_cost.rdcost = 0;
}

vp9_calculate_rd_cost :: (mult: s32, div: s32, rate: s32, dist: s64) -> s64 {
    if rate >= 0 && dist >= 0 {
        return ((((cast,no_check(s64) rate) * cast(s64) mult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + dist << ((div) & 63);
    }
    if rate >= 0 && dist < 0 {
        return ((((cast,no_check(s64) rate) * cast(s64) mult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) - -dist << ((div) & 63);
    }
    if rate < 0 && dist >= 0 {
        return dist << ((div) & 63) - (((cast,no_check(s64) (-rate)) * cast(s64) mult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9;
    }
    return -((((cast,no_check(s64) (-rate)) * cast(s64) mult) + cast,no_check(s64) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9) + -dist << ((div) & 63);
}

vp9_rd_cost_update :: (mult: s32, div: s32, rd_cost: *RD_COST) {
    if rd_cost.rate < 2147483647 && rd_cost.dist < 9223372036854775807 {
        rd_cost.rdcost = vp9_calculate_rd_cost(mult, div, rd_cost.rate, rd_cost.dist);
    } else {
        vp9_rd_cost_reset(rd_cost);
    }
}

vp9_init_rd_parameters :: (cpi: *VP9_COMP_in_vp9_encoder) {
    RDC := *cpi.rd_ctrl;

    if cpi.twopass.use_vizier_rc_params != 0 {
        return;
    }

    RDC.rd_mult_inter_qp_fac = 1.0;
    RDC.rd_mult_arf_qp_fac = 1.0;
    RDC.rd_mult_key_qp_fac = 1.0;
}

vp9_compute_rd_mult_based_on_qindex :: (cpi: *VP9_COMP_in_vp9_encoder, qindex: s32) -> s32 {
    rdc := *cpi.rd_ctrl;
    Q := cast,no_check(s32) vp9_dc_quant(qindex, 0, cpi.common.bit_depth);

    rdmult := Q * Q;

    if cpi.ext_ratectrl.ready != 0 &&
        (cpi.ext_ratectrl.funcs.rc_type & cast,no_check(u32) RC_RDMULT) != 0 &&
        cpi.ext_ratectrl.ext_rdmult != -1 {
        return cpi.ext_ratectrl.ext_rdmult;
    }

    if cpi.common.frame_type == cast,no_check(u32) KEY_FRAME {
        def_rd_q_mult := def_kf_rd_multiplier(qindex);
        rdmult = cast,no_check(s32) ((cast,no_check(float64) rdmult) * def_rd_q_mult * rdc.rd_mult_key_qp_fac);
    } else if cpi.rc.is_src_frame_alt_ref == 0 && (cpi.refresh_golden_frame != 0 || cpi.refresh_alt_ref_frame != 0) {
        def_rd_q_mult := def_arf_rd_multiplier(qindex);
        rdmult = cast,no_check(s32) ((cast,no_check(float64) rdmult) * def_rd_q_mult * rdc.rd_mult_arf_qp_fac);
    } else {
        def_rd_q_mult := def_inter_rd_multiplier(qindex);
        rdmult = cast,no_check(s32) ((cast,no_check(float64) rdmult) * def_rd_q_mult * rdc.rd_mult_inter_qp_fac);
    }

    return ifx rdmult > 0 then rdmult else 1;
}

def_inter_rd_multiplier :: (qindex: s32) -> float64 {
    return 4.15 + 0.001 * cast,no_check(float64) qindex;
}

def_arf_rd_multiplier :: (qindex: s32) -> float64 {
    return 4.25 + 0.001 * cast,no_check(float64) qindex;
}

def_kf_rd_multiplier :: (qindex: s32) -> float64 {
    return 4.35 + 0.001 * cast,no_check(float64) qindex;
}

vp9_compute_rd_mult :: (cpi: *VP9_COMP_in_vp9_encoder, qindex: s32) -> s32 {
    rdmult := vp9_compute_rd_mult_based_on_qindex(cpi, qindex);
    if cpi.ext_ratectrl.ready != 0 &&
        (cpi.ext_ratectrl.funcs.rc_type & cast,no_check(u32) RC_RDMULT) != 0 &&
        cpi.ext_ratectrl.ext_rdmult != -1 {
        return cpi.ext_ratectrl.ext_rdmult;
    }
    return modulate_rdmult(cpi, rdmult);
}

modulate_rdmult :: (cpi: *VP9_COMP_in_vp9_encoder, rdmult: s32) -> s32 {
    rdmult_64 := cast,no_check(s64) rdmult;
    if cpi.oxcf.pass == 2 && cpi.common.frame_type != cast,no_check(u32) KEY_FRAME {
        GF_GROUP_ := *cpi.twopass.gf_group;
        FRAME_TYPE_ := GF_GROUP_.update_type[GF_GROUP_.index];
        GFU_BOOST := (ifx cpi.multi_layer_arf != 0 then GF_GROUP_.gfu_boost[GF_GROUP_.index] else cpi.rc.gfu_boost);
        BOOST_INDEX := (ifx 15 < GFU_BOOST / 100 then 15 else GFU_BOOST / 100);

        rdmult_64 = (rdmult_64 * cast(s64) RD_FRAME_TYPE_FACTOR[FRAME_TYPE_]) >> 7;
        rdmult_64 += (rdmult_64 * cast(s64) RD_BOOST_FACTOR[BOOST_INDEX]) >> 7;
    }
    return cast,no_check(s32) rdmult_64;
}

vp9_get_adaptive_rdmult :: (cpi: *VP9_COMP_in_vp9_encoder, beta: float64) -> s32 {
    rdmult := vp9_compute_rd_mult_based_on_qindex(cpi, cpi.common.base_qindex);
    rdmult = cast,no_check(s32) ((cast,no_check(float64) rdmult) / beta);
    rdmult = ifx rdmult > 0 then rdmult else 1;
    return modulate_rdmult(cpi, rdmult);
}

vp9_initialize_rd_consts :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    X := *cpi.td.mb;
    XD := *cpi.td.mb.e_mbd;
    RD := *cpi.rd;

    RD.rddiv = 7;
    RD.rdmult = vp9_compute_rd_mult(cpi, CM.base_qindex + CM.y_dc_delta_q);

    set_error_per_bit_in_vp9_rd(X, RD.rdmult);

    X.select_tx_size =
        ifx cpi.sf.tx_size_search_method == cast,no_check(u32) USE_LARGESTALL &&
            CM.frame_type != cast,no_check(u32) KEY_FRAME then cast(s32) 0 else 1;

    set_block_thresholds(CM, RD);
    set_partition_probs_in_vp9_rd(CM, XD);

    if cpi.oxcf.pass == 1 {
        if frame_is_intra_only_in_vp9_rd(CM) == 0 {
            vp9_build_nmv_cost_table(
                X.nmvjointcost.data,
                (ifx CM.allow_high_precision_mv != 0 then X.nmvcost_hp.data else X.nmvcost.data),
                *CM.fc.nmvc,
                CM.allow_high_precision_mv
            );
        }
    } else {
        if cpi.sf.use_nonrd_pick_mode == 0 || CM.frame_type == cast,no_check(u32) KEY_FRAME {
            fill_token_costs_in_vp9_rd(X.token_costs.data, CM.fc.coef_probs.data);
        }

        if cpi.sf.partition_search_type != cast,no_check(u32) VAR_BASED_PARTITION || CM.frame_type == cast,no_check(u32) KEY_FRAME {
            for i: 0..cast(s32) (4 * 4) - 1 {
                vp9_cost_tokens(
                    cpi.partition_cost[i].data,
                    get_partition_probs_in_vp9_rd(XD, i),
                    VP9_PARTITION_TREE.data
                );
            }
        }

        if cpi.sf.use_nonrd_pick_mode == 0 || (CM.current_video_frame & 0x7) == 1 || CM.frame_type == cast,no_check(u32) KEY_FRAME {
            fill_mode_costs(cpi);

            if frame_is_intra_only_in_vp9_rd(CM) == 0 {
                vp9_build_nmv_cost_table(
                    X.nmvjointcost.data,
                    (ifx CM.allow_high_precision_mv != 0 then X.nmvcost_hp.data else X.nmvcost.data),
                    *CM.fc.nmvc,
                    CM.allow_high_precision_mv
                );
                vp9_build_inter_mode_cost(cpi);
            }
        }
    }
}

vp9_build_inter_mode_cost :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;

    for i: 0..cast(s32) 7 - 1 {
        vp9_cost_tokens(
            cast(*s32) cpi.inter_mode_cost[i].data,
            CM.fc.inter_mode_probs[i].data,
            VP9_INTER_MODE_TREE.data
        );
    }
}

fill_mode_costs :: (cpi: *VP9_COMP_in_vp9_encoder) {
    FC := cpi.common.fc;
    j: s32 = ---;

    i: s32 = 0;
    while i < 9 + 1 {
        j = 0;
        while j < 9 + 1 {
            vp9_cost_tokens(cpi.y_mode_costs[i][j].data, VP9_KF_Y_MODE_PROB[i][j].data, VP9_INTRA_MODE_TREE.data);
            j += 1;
        }
        i += 1;
    }

    vp9_cost_tokens(cpi.mbmode_cost.data, FC.y_mode_prob[1].data, VP9_INTRA_MODE_TREE.data);
    i = 0;
    while i < 9 + 1 {
        vp9_cost_tokens(
            cpi.intra_uv_mode_cost[KEY_FRAME][i].data,
            VP9_KF_UV_MODE_PROB[i].data,
            VP9_INTRA_MODE_TREE.data
        );
        vp9_cost_tokens(cpi.intra_uv_mode_cost[INTER_FRAME][i].data, FC.uv_mode_prob[i].data, VP9_INTRA_MODE_TREE.data);
        i += 1;
    }

    i = 0;
    while i < 3 + 1 {
        vp9_cost_tokens(
            cpi.switchable_interp_costs[i].data,
            FC.switchable_interp_prob[i].data,
            VP9_SWITCHABLE_INTERP_TREE.data
        );
        i += 1;
    }

    i = cast,no_check(s32) (cast(TX_SIZE) 1);
    while i < cast,no_check(s32) (cast(TX_SIZE) 4) {
        j = 0;
        while j < 2 {
            tx_probs := get_tx_probs_in_vp9_rd(cast,no_check(TX_SIZE) i, j, *FC.tx_probs);

            if 0 <= i {
                for k: 0..i {
                    cost: s32 = 0;

                    m: s32 = 0;
                    while m <= k - cast(s32) (k == i) {
                        if m == k {
                            cost += cast,no_check(s32) VP9_PROB_COST[tx_probs[m]];
                        } else {
                            cost += cast,no_check(s32) VP9_PROB_COST[256 - cast(s32) tx_probs[m]];
                        }
                        m += 1;
                    }
                    cpi.tx_size_cost[i - 1][j][k] = cost;
                }
            }
            j += 1;
        }
        i += 1;
    }
}

fill_token_costs_in_vp9_rd :: (c: *Vp9_Coeff_Cost, p: *[2] Vp9_Coeff_Probs_Model) {
    i, j, k, l: s32 = ---;

    t: TX_SIZE = 0;
    while t <= cast(TX_SIZE) 3 {
        i = 0;
        while i < PLANE_TYPES {
            j = 0;
            while j < 2 {
                k = 0;
                while k < 6 {
                    l = 0;
                    while l < (ifx k == 0 then cast(s32) 3 else 6) {
                        probs: [11] Prob = ---;
                        vp9_model_to_full_probs(p[t][i][j][k][l].data, probs.data);
                        vp9_cost_tokens(
                            cast(*s32) c[t][i][j][k][0][l].data,
                            probs.data,
                            cast(*Tree_Index) *(VP9_COEF_TREE)
                        );
                        vp9_cost_tokens_skip(
                            cast(*s32) c[t][i][j][k][1][l].data,
                            probs.data,
                            cast(*Tree_Index) *(VP9_COEF_TREE)
                        );
                        l += 1;
                    }
                    k += 1;
                }
                j += 1;
            }
            i += 1;
        }
        t += 1;
    }
}

set_block_thresholds :: (cm: *VP9_COMMON, rd: *RD_OPT) {
    i: s32 = ---;
    bsize: s32 = ---;

    for segment_id: 0..cast(s32) 8 - 1 {
        QINDEX := clamp_in_vp9_rd(vp9_get_qindex(*cm.seg, segment_id, cm.base_qindex) + cm.y_dc_delta_q, 0, 255);
        Q := compute_rd_thresh_factor(QINDEX, cm.bit_depth);

        bsize = 0;
        while bsize < 13 {
            T := Q * cast(s32) RD_THRESH_BLOCK_SIZE_FACTOR[bsize];
            THRESH_MAX := 2147483647 / T;

            if bsize >= 3 {
                i = 0;
                while i < 30 {
                    rd.threshes[segment_id][bsize][i] =
                        ifx rd.thresh_mult[i] < THRESH_MAX then rd.thresh_mult[i] *
                            T / 4 else 2147483647;
                    i += 1;
                }
            } else {
                i = 0;
                while i < 6 {
                    rd.threshes[segment_id][bsize][i] =
                        ifx rd.thresh_mult_sub8x8[i] < THRESH_MAX then rd.thresh_mult_sub8x8[i] *
                            T / 4 else 2147483647;
                    i += 1;
                }
            }
            bsize += 1;
        }
    }
}

compute_rd_thresh_factor :: (qindex: s32, bit_depth: Bit_Depth_T) -> s32 {
    q := (cast,no_check(float64) vp9_dc_quant(qindex, 0, cast,no_check(Bit_Depth_T) BITS_8)) / 4.0;

    return ifx cast,no_check(s32) (c_transpiler_math_pow(q, 1.25) * 5.12) > 8 then cast,no_check(s32) (c_transpiler_math_pow(q, 1.25) * 5.12) else 8;
}

set_error_per_bit_in_vp9_rd :: (x: *MACROBLOCK, rdmult: s32) {
    x.errorperbit = rdmult >> 6;
    x.errorperbit += cast(s32) (x.errorperbit == 0);
}

vp9_initialize_me_consts :: (cpi: *VP9_COMP_in_vp9_encoder, x: *MACROBLOCK, qindex: s32) {
    x.sadperbit16 = sad_per_bit16lut_8[qindex];
    x.sadperbit4 = sad_per_bit4lut_8[qindex];
}

vp9_model_rd_from_var_lapndz :: (var: u32, n_log2: u32, qstep: u32, rate: *s32, dist: *s64) {
    if var == 0 {
        rate.* = 0;
        dist.* = 0;
    } else {
        d_q10, r_q10: s32 = ---;
        XSQ_Q10_64 :=
            ((((cast,no_check(u64) qstep) * cast(u64) qstep) << (((n_log2 + 10)) & 63)) + cast(u64) (var >> 1)) /
                cast(u64) var;
        XSQ_Q10 := cast,no_check(s32) (min(XSQ_Q10_64, cast,no_check(u64) MAX_XSQ_Q10));
        model_rd_norm(XSQ_Q10, *r_q10, *d_q10);
        rate.* =
            (r_q10 << ((n_log2) & 31) +
                (cast(s32) 1) << ((((cast,no_check(s32) ((10 - 9))) - 1)) & 31)) >> (((10 - 9)) & 31);
        dist.* = (((cast(s64) var) * cast,no_check(s64) d_q10) + 512) >> 10;
    }
}

model_rd_norm :: (xsq_q10: s32, r_q10: *s32, d_q10: *s32) {
    TMP := xsq_q10 >> 2 + 8;
    K := get_msb_in_vp9_rd(cast,no_check(u32) TMP) - 3;
    XQ := K << 3 + TMP >> ((K) & 31) & 0x7;
    ONE_Q10: s32 = (cast(s32) 1) << 10;
    A_Q10 := (xsq_q10 - XSQ_IQ_Q10[XQ]) << 10 >> (((2 + K)) & 31);
    B_Q10 := ONE_Q10 - A_Q10;
    r_q10.* = (RATE_TAB_Q10[XQ] * B_Q10 + RATE_TAB_Q10[XQ + 1] * A_Q10) >> 10;
    d_q10.* = (DIST_TAB_Q10[XQ] * B_Q10 + DIST_TAB_Q10[XQ + 1] * A_Q10) >> 10;
}

vp9_get_switchable_rate :: (cpi: *VP9_COMP_in_vp9_encoder, XD: *MACROBLOCKD) -> s32 {
    MI := XD.mi[0];
    CTX := get_pred_context_switchable_interp_in_vp9_rd(XD);
    return 1 * cpi.switchable_interp_costs[CTX][MI.interp_filter];
}

vp9_raster_block_offset :: (plane_bsize: BLOCK_SIZE, raster_block: s32, stride: s32) -> s32 {
    BW := cast,no_check(s32) B_WIDTH_LOG2_LOOKUP[plane_bsize];
    Y := 4 * raster_block >> ((BW) & 31);
    X := 4 * raster_block & ((cast(s32) 1) << ((BW) & 31) - 1);
    return Y * stride + X;
}

vp9_raster_block_offset_int16 :: (plane_bsize: BLOCK_SIZE, raster_block: s32, base: *s16) -> *s16 {
    STRIDE := 4 * cast(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[plane_bsize];
    return base + vp9_raster_block_offset(plane_bsize, raster_block, STRIDE);
}

vp9_get_scaled_ref_frame :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame: s32) -> *YV12_BUFFER_CONFIG {
    CM := *cpi.common;
    SCALED_IDX := cpi.scaled_ref_idx[ref_frame - 1];
    REF_IDX := get_ref_frame_buf_idx_in_vp9_rd(cpi, ref_frame);

    return ifx SCALED_IDX != REF_IDX && SCALED_IDX != -1 then *CM.buffer_pool.frame_bufs[SCALED_IDX].buf else null;
}

get_ref_frame_buf_idx_in_vp9_rd :: (CPI: *VP9_COMP_in_vp9_encoder, ref_frame: s32) -> s32 {
    CM := *CPI.common;
    MAP_IDX := get_ref_frame_map_idx_in_vp9_rd(CPI, cast,no_check(MV_REFERENCE_FRAME) ref_frame);
    return ifx MAP_IDX != -1 then CM.ref_frame_map[MAP_IDX] else -1;
}

get_ref_frame_map_idx_in_vp9_rd :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame: MV_REFERENCE_FRAME) -> s32 {
    if ref_frame == 1 {
        return cpi.lst_fb_idx;
    } else if ref_frame == 2 {
        return cpi.gld_fb_idx;
    } else {
        return cpi.alt_fb_idx;
    }
}

vp9_init_me_luts :: () {
    init_me_luts_bd(
        sad_per_bit16lut_8.data,
        sad_per_bit4lut_8.data,
        (cast,no_check(s32) ((255 - 0))) + 1,
        cast,no_check(Bit_Depth_T) BITS_8
    );
}

init_me_luts_bd :: (bit16lut: *s32, bit4lut: *s32, range: s32, bit_depth: Bit_Depth_T) {
    if 0 < range {
        for i: 0..range - 1 {
            Q := vp9_convert_qindex_to_q(i, bit_depth);
            bit16lut[i] = cast,no_check(s32) (0.0418 * Q + 2.4107);
            bit4lut[i] = cast,no_check(s32) (0.063 * Q + 2.742);
        }
    }
}

vp9_get_entropy_contexts :: (
    bsize: BLOCK_SIZE,
    tx_size: TX_SIZE,
    pd: *Macroblockd_Plane,
    t_above: *ENTROPY_CONTEXT,
    t_left: *ENTROPY_CONTEXT
) {
    PLANE_BSIZE := get_plane_block_size_in_vp9_rd(bsize, pd);
    NUM_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE];
    NUM_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE];
    ABOVE := pd.above_context;
    LEFT := pd.left_context;

    i: s32 = ---;
    if cast,no_check(s32) tx_size == {
        case cast,no_check(s32) cast(TX_SIZE) 0;
            copy_memory(t_above, ABOVE, cast,no_check(u64) NUM_4X4_W);
            copy_memory(t_left, LEFT, cast,no_check(u64) NUM_4X4_H);
        case cast,no_check(s32) cast(TX_SIZE) 1;
            i = 0;
            while i < NUM_4X4_W {
                t_above[i] = cast(ENTROPY_CONTEXT) (((cast(*u16) (*ABOVE[i])).*) != 0);
                i += 2;
            }
            i = 0;
            while i < NUM_4X4_H {
                t_left[i] = cast(ENTROPY_CONTEXT) (((cast(*u16) (*LEFT[i])).*) != 0);
                i += 2;
            }
        case cast,no_check(s32) cast(TX_SIZE) 2;
            i = 0;
            while i < NUM_4X4_W {
                t_above[i] = cast(ENTROPY_CONTEXT) (((cast(*u32) (*ABOVE[i])).*) != 0);
                i += 4;
            }
            i = 0;
            while i < NUM_4X4_H {
                t_left[i] = cast(ENTROPY_CONTEXT) (((cast(*u32) (*LEFT[i])).*) != 0);
                i += 4;
            }
        case;
            i = 0;
            while i < NUM_4X4_W {
                t_above[i] = cast(ENTROPY_CONTEXT) (((cast(*u64) (*ABOVE[i])).*) != 0);
                i += 8;
            }
            i = 0;
            while i < NUM_4X4_H {
                t_left[i] = cast(ENTROPY_CONTEXT) (((cast(*u64) (*LEFT[i])).*) != 0);
                i += 8;
            }
    }
}

vp9_set_rd_speed_thresholds :: (cpi: *VP9_COMP_in_vp9_encoder) {
    RD := *cpi.rd;
    SF := *cpi.sf;

    for i: 0..cast(s32) 30 - 1 {
        RD.thresh_mult[i] = ifx cpi.oxcf.mode == cast,no_check(u32) BEST then cast(s32) -500 else 0;
    }

    if SF.adaptive_rd_thresh != 0 {
        RD.thresh_mult[THR_NEARESTMV] = 300;
        RD.thresh_mult[THR_NEARESTG] = 300;
        RD.thresh_mult[THR_NEARESTA] = 300;
    } else {
        RD.thresh_mult[THR_NEARESTMV] = 0;
        RD.thresh_mult[THR_NEARESTG] = 0;
        RD.thresh_mult[THR_NEARESTA] = 0;
    }

    RD.thresh_mult[THR_DC_in_vp9_cx_iface] += 1000;

    RD.thresh_mult[THR_NEWMV] += 1000;
    RD.thresh_mult[THR_NEWA] += 1000;
    RD.thresh_mult[THR_NEWG] += 1000;

    RD.thresh_mult[THR_NEARMV] += 1000;
    RD.thresh_mult[THR_NEARA] += 1000;
    RD.thresh_mult[THR_COMP_NEARESTLA] += 1000;
    RD.thresh_mult[THR_COMP_NEARESTGA] += 1000;

    RD.thresh_mult[THR_TM_in_vp9_cx_iface] += 1000;

    RD.thresh_mult[THR_COMP_NEARLA] += 1500;
    RD.thresh_mult[THR_COMP_NEWLA] += 2000;
    RD.thresh_mult[THR_NEARG] += 1000;
    RD.thresh_mult[THR_COMP_NEARGA] += 1500;
    RD.thresh_mult[THR_COMP_NEWGA] += 2000;

    RD.thresh_mult[THR_ZEROMV] += 2000;
    RD.thresh_mult[THR_ZEROG] += 2000;
    RD.thresh_mult[THR_ZEROA] += 2000;
    RD.thresh_mult[THR_COMP_ZEROLA] += 2500;
    RD.thresh_mult[THR_COMP_ZEROGA] += 2500;

    RD.thresh_mult[THR_H_PRED_in_vp9_cx_iface] += 2000;
    RD.thresh_mult[THR_V_PRED_in_vp9_cx_iface] += 2000;
    RD.thresh_mult[THR_D45_PRED] += 2500;
    RD.thresh_mult[THR_D135_PRED] += 2500;
    RD.thresh_mult[THR_D117_PRED] += 2500;
    RD.thresh_mult[THR_D153_PRED] += 2500;
    RD.thresh_mult[THR_D207_PRED] += 2500;
    RD.thresh_mult[THR_D63_PRED] += 2500;
}

vp9_set_rd_speed_thresholds_sub8x8 :: (cpi: *VP9_COMP_in_vp9_encoder) {
    RD := *cpi.rd;
    IDX := cast(s32) (cpi.oxcf.mode == cast,no_check(u32) BEST);
    copy_memory(RD.thresh_mult_sub8x8.data, THRESH_MULT[IDX].data, 6 * cast(u64) size_of(s32));
}

vp9_update_rd_thresh_fact :: (factor_buf: *[30] s32, rd_thresh: s32, bsize: s32, best_mode_index: s32) {
    if rd_thresh > 0 {
        TOP_MODE := (ifx bsize < 3 then cast(s32) 6 else 30);

        if 0 < TOP_MODE {
            for mode: 0..TOP_MODE - 1 {
                MIN_SIZE := cast,no_check(BLOCK_SIZE) ((ifx bsize - 1 > 0 then bsize - 1 else 0));
                MAX_SIZE := cast,no_check(BLOCK_SIZE) ((ifx bsize + 2 < 12 then bsize + 2 else 12));

                bs := MIN_SIZE;
                while bs <= MAX_SIZE {
                    FACT := factor_buf[bs].data + mode;
                    if mode == best_mode_index {
                        FACT.* -= FACT.* >> 4;
                    } else {
                        FACT.* = ifx FACT.* + 1 < rd_thresh * 64 then FACT.* + 1 else rd_thresh * 64;
                    }
                    bs += 1;
                }
            }
        }
    }
}

rd_less_than_thresh_in_vp9_rd :: (best_rd: s64, thresh: s32, THRESH_FACT: *s32) -> s32 {
    if best_rd < ((cast,no_check(s64) thresh) * cast(s64) THRESH_FACT.*) >> 5 || thresh == 2147483647 {
        return 1;
    }
    return 0;
}

vp9_mv_pred :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    ref_y_buffer: *u8,
    ref_y_stride: s32,
    ref_frame: s32,
    block_size: BLOCK_SIZE
) {
    zero_seen: s32 = 0;
    best_index: s32 = 0;
    best_sad: s32 = 2147483647;
    this_sad: s32 = 2147483647;
    max_mv: s32 = 0;

    src_y_ptr := x.plane[0].src.buf;

    NUM_MV_REFS := 2 + cast(s32) (block_size < x.max_partition_size);

    pred_mv: [3] MV = ---;
    pred_mv[0] = x.mbmi_ext.ref_mvs[ref_frame][0].as_mv;
    pred_mv[1] = x.mbmi_ext.ref_mvs[ref_frame][1].as_mv;
    pred_mv[2] = x.pred_mv[ref_frame];

    near_same_nearest := cast(s32) (x.mbmi_ext.ref_mvs[ref_frame][0].as_int == x.mbmi_ext.ref_mvs[ref_frame][1].as_int);

    if 0 < NUM_MV_REFS {
        for i: 0..NUM_MV_REFS - 1 {
            this_mv := pred_mv.data + i;

            if this_mv.row == 32767 || this_mv.col == 32767 {
                continue;
            }
            if i == 1 && near_same_nearest != 0 {
                continue;
            }
            fp_row := ((cast(s32) this_mv.row) + 3 + cast(s32) (this_mv.row >= 0)) >> 3;
            fp_col := ((cast(s32) this_mv.col) + 3 + cast(s32) (this_mv.col >= 0)) >> 3;
            max_mv =
                ifx max_mv > (ifx absolute_value(cast,no_check(s32) this_mv.row) > absolute_value(cast,no_check(s32) this_mv.col) then absolute_value(cast,no_check(s32) this_mv.row) else absolute_value(cast,no_check(s32) this_mv.col)) >> 3 then max_mv else (ifx absolute_value(cast,no_check(s32) this_mv.row) > absolute_value(cast,no_check(s32) this_mv.col) then absolute_value(cast,no_check(s32) this_mv.row) else absolute_value(cast,no_check(s32) this_mv.col)) >> 3;

            if fp_row == 0 && fp_col == 0 && zero_seen != 0 {
                continue;
            }
            zero_seen |= cast(s32) (fp_row == 0 && fp_col == 0);

            ref_y_ptr := *ref_y_buffer[ref_y_stride * fp_row + fp_col];

            this_sad =
                cast,no_check(s32) cpi.fn_ptr[block_size].sdf(
                    src_y_ptr,
                    x.plane[0].src.stride,
                    ref_y_ptr,
                    ref_y_stride
                );

            if this_sad < best_sad {
                best_sad = this_sad;
                best_index = i;
            }
        }
    }

    x.mv_best_ref_index[ref_frame] = best_index;
    x.max_mv_context[ref_frame] = cast,no_check(u32) max_mv;
    x.pred_mv_sad[ref_frame] = best_sad;
}

vp9_setup_pred_block :: (
    xd: *MACROBLOCKD,
    dst: *Buf_2d,
    src: *YV12_BUFFER_CONFIG,
    mi_row: s32,
    mi_col: s32,
    scale: *Scale_Factors,
    scale_uv: *Scale_Factors
) {
    dst[0].buf = src.y_buffer;
    dst[0].stride = src.y_stride;
    dst[1].buf = src.u_buffer;
    dst[2].buf = src.v_buffer;
    dst[2].stride = src.uv_stride;
    dst[1].stride = dst[2].stride;

    for i: 0..cast(s32) 3 - 1 {
        setup_pred_plane_in_vp9_rd(
            dst + i,
            dst[i].buf,
            dst[i].stride,
            mi_row,
            mi_col,
            (ifx i != 0 then scale_uv else scale),
            xd.plane[i].subsampling_x,
            xd.plane[i].subsampling_y
        );
    }
}

vp9_get_intra_cost_penalty :: (CPI: *VP9_COMP_in_vp9_encoder, bsize: BLOCK_SIZE, qindex: s32, qdelta: s32) -> s32 {
    reduction_fac := (ifx bsize <= 6 then (ifx bsize <= 3 then cast(s32) 4 else 2) else 0);

    if CPI.noise_estimate.enabled != 0 && CPI.noise_estimate.level == cast,no_check(u32) K_HIGH {
        reduction_fac = 0;
    }

    return (20 * cast(s32) vp9_dc_quant(qindex, qdelta, cast,no_check(Bit_Depth_T) BITS_8)) >> ((reduction_fac) & 31);
}

write_in_vp9_rd :: (br: *Writer, bit: s32, probability: s32) {
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

write_bit_in_vp9_rd :: (w: *Writer, bit: s32) {
    write_in_vp9_rd(w, bit, 128);
}

write_literal_in_vp9_rd :: (w: *Writer, data: s32, bits: s32) {
    bit := bits - 1;
    while bit >= 0 {
        write_bit_in_vp9_rd(w, 1 & (data >> ((bit) & 31)));
        bit -= 1;
    }
}

vp9_write_tree_in_vp9_rd :: (w: *Writer, tree: *Tree_Index, probs: *Prob, bits: s32, len: s32, i: Tree_Index) {
    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            write_in_vp9_rd(w, BIT, cast,no_check(s32) probs[(cast(s32) i) >> 1]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }
}

vp9_write_token_in_vp9_rd :: (w: *Writer, tree: *Tree_Index, probs: *Prob, token: *Vp9_Token) {
    vp9_write_tree_in_vp9_rd(w, tree, probs, token.value, token.len, 0);
}

vp9_get_high_cost_table_in_vp9_rd :: (bit_depth: s32) -> *u16 {
    return VP9_CAT6_HIGH_COST.data;
}

vp9_get_token_extra_in_vp9_rd :: (v: s32, token: *s16, extra: *EXTRABIT) {
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

vp9_get_token_in_vp9_rd :: (v: s32) -> s16 {
    if v >= 67 || v <= -67 {
        return 10;
    }
    return vp9_dct_cat_lt_10_value_tokens[v].token;
}

vp9_get_token_cost_in_vp9_rd :: (v: s32, token: *s16, cat6_high_table: *u16) -> s32 {
    if v >= 67 || v <= -67 {
        token.* = 10;
        extrabits := cast,no_check(EXTRABIT) (absolute_value(v) - 67);
        return (cast(s32) VP9_CAT6_LOW_COST[extrabits & 0xff]) + cast(s32) cat6_high_table[(cast(s32) extrabits) >> 8];
    }
    token.* = vp9_dct_cat_lt_10_value_tokens[v].token;
    return vp9_dct_cat_lt_10_value_cost[v];
}

is_lossless_requested_in_vp9_rd :: (cfg: *VP9_Encoder_Config) -> s32 {
    if cfg.best_allowed_q == 0 && cfg.worst_allowed_q == 0 {
        return 1;
    }
    return 0;
}

stack_pop_in_vp9_rd :: (stack: *s32, stack_size: s32) -> s32 {
    R := stack[0];
    if 1 < stack_size {
        for idx: 1..stack_size - 1 {
            stack[idx - 1] = stack[idx];
        }
    }

    return R;
}

stack_top_in_vp9_rd :: (stack: *s32) -> s32 {
    return stack[0];
}

stack_push_in_vp9_rd :: (stack: *s32, new_item: s32, stack_size: s32) {
    idx := stack_size;
    while idx > 0 {
        stack[idx] = stack[idx - 1];
        idx -= 1;
    }
    stack[0] = new_item;
}

stack_init_in_vp9_rd :: (stack: *s32, length: s32) {
    if 0 < length {
        for idx: 0..length - 1 {
            stack[idx] = -1;
        }
    }
}

frame_is_kf_gf_arf_in_vp9_rd :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if frame_is_intra_only_in_vp9_rd(*cpi.common) != 0 ||
        cpi.refresh_alt_ref_frame != 0 ||
        cpi.refresh_golden_frame != 0 && cpi.rc.is_src_frame_alt_ref == 0 {
        return 1;
    }
    return 0;
}

ref_frame_to_flag_in_vp9_rd :: (ref_frame: s8) -> s32 {

    return K_VP9_REF_FLAG_LIST_in_vp9_rd[ref_frame];
}

get_ref_cnt_buffer_in_vp9_rd :: (cm: *VP9_COMMON, fb_idx: s32) -> *Ref_Cnt_Buffer {
    return ifx fb_idx != -1 then cm.buffer_pool.frame_bufs.data + fb_idx else null;
}

get_ref_frame_bufs_in_vp9_rd :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame_bufs: **Ref_Cnt_Buffer) {
    CM := *cpi.common;

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame < 4 {
        ref_frame_buf_idx := get_ref_frame_buf_idx_in_vp9_rd(cpi, cast,no_check(s32) ref_frame);
        inter_ref_idx := mv_ref_frame_to_inter_ref_idx_in_vp9_rd(ref_frame);
        ref_frame_bufs[inter_ref_idx] = get_ref_cnt_buffer_in_vp9_rd(CM, ref_frame_buf_idx);
        ref_frame += 1;
    }
}

get_ref_frame_buffer_in_vp9_rd :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    ref_frame: MV_REFERENCE_FRAME
) -> *YV12_BUFFER_CONFIG {
    CM := *CPI.common;
    BUF_IDX := get_ref_frame_buf_idx_in_vp9_rd(CPI, cast,no_check(s32) ref_frame);
    return ifx BUF_IDX != -1 then *CM.buffer_pool.frame_bufs[BUF_IDX].buf else null;
}

get_token_alloc_in_vp9_rd :: (mb_rows: s32, mb_cols: s32) -> s64 {
    ALIGNED_MB_ROWS :=
        (mb_rows +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    ALIGNED_MB_COLS :=
        (mb_cols +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    return ((cast,no_check(s64) ALIGNED_MB_ROWS) * cast(s64) ALIGNED_MB_COLS) * cast,no_check(s64) ((cast,no_check(s32) ((16 * 16))) * 3 + 4);
}

allocated_tokens_in_vp9_rd :: (tile: Tile_Info) -> s64 {
    tile_mb_rows := (tile.mi_row_end - tile.mi_row_start + 1) >> 1;
    tile_mb_cols := (tile.mi_col_end - tile.mi_col_start + 1) >> 1;

    return get_token_alloc_in_vp9_rd(tile_mb_rows, tile_mb_cols);
}

get_start_tok_in_vp9_rd :: (
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

    tok.* = cpi.tile_tok[tile_row][tile_col] + get_token_alloc_in_vp9_rd(MB_ROW, tile_mb_cols);
}

is_one_pass_svc_in_vp9_rd :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if CPI.use_svc != 0 && CPI.oxcf.pass == 0 {
        return 1;
    }
    return 0;
}

is_altref_enabled_in_vp9_rd :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if !(CPI.oxcf.mode == cast,no_check(u32) REALTIME && CPI.oxcf.rc_mode == cast,no_check(u32) CBR) &&
        CPI.oxcf.lag_in_frames >= 4 &&
        CPI.oxcf.enable_auto_arf != 0 {
        return 1;
    }
    return 0;
}

set_ref_ptrs_in_vp9_rd :: (CM: *VP9_COMMON, xd: *MACROBLOCKD, ref0: MV_REFERENCE_FRAME, ref1: MV_REFERENCE_FRAME) {
    xd.block_refs[0] = CM.frame_refs.data + (ifx ref0 >= 1 then (cast(s32) ref0) - 1 else 0);
    xd.block_refs[1] = CM.frame_refs.data + (ifx ref1 >= 1 then (cast(s32) ref1) - 1 else 0);
}

get_chessboard_index_in_vp9_rd :: (FRAME_INDEX: s32) -> s32 {
    return FRAME_INDEX & 0x1;
}

cond_cost_list_in_vp9_rd :: (cpi: *VP9_COMP_in_vp9_encoder, cost_list: *s32) -> *s32 {
    return ifx cpi.sf.mv.subpel_search_method != cast,no_check(u32) SUBPEL_TREE then cost_list else null;
}

get_num_vert_units_in_vp9_rd :: (tile: Tile_Info, shift: s32) -> s32 {
    num_vert_units := (tile.mi_row_end - tile.mi_row_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_vert_units;
}

get_num_cols_in_vp9_rd :: (tile: Tile_Info, shift: s32) -> s32 {
    num_cols := (tile.mi_col_end - tile.mi_col_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_cols;
}

get_level_index_in_vp9_rd :: (level: VP9_LEVEL) -> s32 {
    for i: 0..cast(s32) 14 - 1 {
        if level == VP9_LEVEL_DEFS[i].level {
            return i;
        }
    }
    return -1;
}

log_tile_cols_from_picsize_level_in_vp9_rd :: (width: u32, height: u32) -> s32 {
    PIC_SIZE := width * height;
    PIC_BREADTH := max(width, height);
    for i: 0..cast(s32) 14 - 1 {
        if VP9_LEVEL_DEFS[i].max_luma_picture_size >= PIC_SIZE && VP9_LEVEL_DEFS[i].max_luma_picture_breadth >= PIC_BREADTH {
            return get_msb_in_vp9_rd(cast,no_check(u32) VP9_LEVEL_DEFS[i].max_col_tiles);
        }
    }
    return 2147483647;
}

alloc_frame_mvs_in_vp9_rd :: (CM: *VP9_COMMON, buffer_idx: s32) {
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

mv_cost_in_vp9_rd :: (mv: *MV, joint_cost: *s32, comp_cost: **s32) -> s32 {
    return joint_cost[vp9_get_mv_joint_in_vp9_rd(mv)] + comp_cost[0][mv.row] + comp_cost[1][mv.col];
}

mvsad_err_cost_in_vp9_rd :: (x: *MACROBLOCK, mv: *MV, ref: *MV, sad_per_bit: s32) -> s32 {
    diff: MV = ---;
    diff.row = cast,no_check(s16) ((cast(s32) mv.row) - cast(s32) ref.row);
    diff.col = cast,no_check(s16) ((cast(s32) mv.col) - cast(s32) ref.col);
    return cast,no_check(s32) ((((cast,no_check(u32) mv_cost_in_vp9_rd(*diff, x.nmvjointsadcost.data, x.nmvsadcost.data)) * cast,no_check(u32) sad_per_bit) + cast,no_check(u32) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9);
}

get_start_mv_sad_in_vp9_rd :: (
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
    start_mv_sad += cast,no_check(u32) mvsad_err_cost_in_vp9_rd(x, mvp_full, ref_mv_full, sadpb);

    return start_mv_sad;
}

num_4x4_to_edge_in_vp9_rd :: (plane_4x4_dim: s32, mb_to_edge_dim: s32, subsampling_dim: s32, blk_dim: s32) -> s32 {
    return plane_4x4_dim + mb_to_edge_dim >> (((5 + subsampling_dim)) & 31) - blk_dim;
}

sum_squares_visible_in_vp9_rd :: (
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
    B4X4S_TO_RIGHT_EDGE := num_4x4_to_edge_in_vp9_rd(PLANE_4X4_W, xd.mb_to_right_edge, PD.subsampling_x, blk_col);
    B4X4S_TO_BOTTOM_EDGE := num_4x4_to_edge_in_vp9_rd(PLANE_4X4_H, xd.mb_to_bottom_edge, PD.subsampling_y, blk_row);
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

do_trellis_opt_in_vp9_rd :: (
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
                    sum_squares_visible_in_vp9_rd(
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

globals_initialization_state_for_vp9_rd: u32;
initialize_globals_for_vp9_rd :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_rd);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_rd, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_rd) != 2 {}
            return;
        }
    }
    K_VP9_REF_FLAG_LIST_in_vp9_rd =
        s32.[ 0, cast,no_check(s32) (VP9_LAST_FLAG), cast,no_check(s32) (VP9_GOLD_FLAG), cast,no_check(s32) (VP9_ALT_FLAG) ];
    SUB_PEL_FILTERS_12_in_vp9_rd =
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
    MODE_2_COUNTER_in_vp9_rd =
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
    COUNTER_TO_CONTEXT_in_vp9_rd =
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
    MV_REF_BLOCKS_in_vp9_rd =
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
    IDX_N_COLUMN_TO_SUBBLOCK_in_vp9_rd =
        [2] s32.[
            s32.[ 1, 2 ],
            s32.[ 1, 3 ],
            s32.[ 3, 2 ],
            s32.[ 3, 3 ]
        ];
    COUNT_TO_UPDATE_FACTOR_in_vp9_rd =
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
    FRAME_SCALE_FACTOR_in_vp9_rd = s32.[ 16, 24 ];
    RATE_THRESH_MULT_in_vp9_rd = float64.[ 1.0, 2.0 ];
    RCF_MULT_in_vp9_rd = float64.[ 1.0, 2.0 ];
    RD_THRESH_BLOCK_SIZE_FACTOR =
        u8.[
            2,
            3,
            3,
            4,
            6,
            6,
            8,
            12,
            12,
            16,
            24,
            24,
            32
        ];
    RD_BOOST_FACTOR =
        s32.[
            64,
            32,
            32,
            32,
            24,
            16,
            12,
            12,
            8,
            8,
            4,
            4,
            2,
            2,
            1,
            0
        ];
    RD_FRAME_TYPE_FACTOR =
        s32.[
            128,
            144,
            128,
            128,
            144,
            144,
            cast,no_check(s32) 0
        ];
    RATE_TAB_Q10 =
        s32.[
            65536,
            6086,
            5574,
            5275,
            5063,
            4899,
            4764,
            4651,
            4553,
            4389,
            4255,
            4142,
            4044,
            3958,
            3881,
            3811,
            3748,
            3635,
            3538,
            3453,
            3376,
            3307,
            3244,
            3186,
            3133,
            3037,
            2952,
            2877,
            2809,
            2747,
            2690,
            2638,
            2589,
            2501,
            2423,
            2353,
            2290,
            2232,
            2179,
            2130,
            2084,
            2001,
            1928,
            1862,
            1802,
            1748,
            1698,
            1651,
            1608,
            1530,
            1460,
            1398,
            1342,
            1290,
            1243,
            1199,
            1159,
            1086,
            1021,
            963,
            911,
            864,
            821,
            781,
            745,
            680,
            623,
            574,
            530,
            490,
            455,
            424,
            395,
            345,
            304,
            269,
            239,
            213,
            190,
            171,
            154,
            126,
            104,
            87,
            73,
            61,
            52,
            44,
            38,
            28,
            21,
            16,
            12,
            10,
            8,
            6,
            5,
            3,
            2,
            1,
            1,
            1,
            0,
            0
        ];
    DIST_TAB_Q10 =
        s32.[
            0,
            0,
            1,
            1,
            1,
            2,
            2,
            2,
            3,
            3,
            4,
            5,
            5,
            6,
            7,
            7,
            8,
            9,
            11,
            12,
            13,
            15,
            16,
            17,
            18,
            21,
            24,
            26,
            29,
            31,
            34,
            36,
            39,
            44,
            49,
            54,
            59,
            64,
            69,
            73,
            78,
            88,
            97,
            106,
            115,
            124,
            133,
            142,
            151,
            167,
            184,
            200,
            215,
            231,
            245,
            260,
            274,
            301,
            327,
            351,
            375,
            397,
            418,
            439,
            458,
            495,
            528,
            559,
            587,
            613,
            637,
            659,
            680,
            717,
            749,
            777,
            801,
            823,
            842,
            859,
            874,
            899,
            919,
            936,
            949,
            960,
            969,
            977,
            983,
            994,
            1001,
            1006,
            1010,
            1013,
            1015,
            1017,
            1018,
            1020,
            1022,
            1022,
            1023,
            1023,
            1023,
            1024
        ];
    XSQ_IQ_Q10 =
        s32.[
            0,
            4,
            8,
            12,
            16,
            20,
            24,
            28,
            32,
            40,
            48,
            56,
            64,
            72,
            80,
            88,
            96,
            112,
            128,
            144,
            160,
            176,
            192,
            208,
            224,
            256,
            288,
            320,
            352,
            384,
            416,
            448,
            480,
            544,
            608,
            672,
            736,
            800,
            864,
            928,
            992,
            1120,
            1248,
            1376,
            1504,
            1632,
            1760,
            1888,
            2016,
            2272,
            2528,
            2784,
            3040,
            3296,
            3552,
            3808,
            4064,
            4576,
            5088,
            5600,
            6112,
            6624,
            7136,
            7648,
            8160,
            9184,
            10208,
            11232,
            12256,
            13280,
            14304,
            15328,
            16352,
            18400,
            20448,
            22496,
            24544,
            26592,
            28640,
            30688,
            32736,
            36832,
            40928,
            45024,
            49120,
            53216,
            57312,
            61408,
            65504,
            73696,
            81888,
            90080,
            98272,
            106464,
            114656,
            122848,
            131040,
            147424,
            163808,
            180192,
            196576,
            212960,
            229344,
            245728
        ];
    MAX_XSQ_Q10 = 245727;
    THRESH_MULT =
        [6] s32.[
            s32.[ 2500, 2500, 2500, 4500, 4500, 2500 ],
            s32.[ 2000, 2000, 2000, 4000, 4000, 2000 ]
        ];
    atomic_store(*globals_initialization_state_for_vp9_rd, 2);
}

THR_MODES_in_vp9_cx_iface :: u32;
THR_NEARESTMV : s32 : 0;
THR_NEARESTA : s32 : 1;
THR_NEARESTG : s32 : 2;
THR_DC_in_vp9_cx_iface : s32 : 3;
THR_NEWMV : s32 : 4;
THR_NEWA : s32 : 5;
THR_NEWG : s32 : 6;
THR_NEARMV : s32 : 7;
THR_NEARA : s32 : 8;
THR_NEARG : s32 : 9;
THR_ZEROMV : s32 : 10;
THR_ZEROG : s32 : 11;
THR_ZEROA : s32 : 12;
THR_COMP_NEARESTLA : s32 : 13;
THR_COMP_NEARESTGA : s32 : 14;
THR_TM_in_vp9_cx_iface : s32 : 15;
THR_COMP_NEARLA : s32 : 16;
THR_COMP_NEWLA : s32 : 17;
THR_COMP_NEARGA : s32 : 18;
THR_COMP_NEWGA : s32 : 19;
THR_COMP_ZEROLA : s32 : 20;
THR_COMP_ZEROGA : s32 : 21;
THR_H_PRED_in_vp9_cx_iface : s32 : 22;
THR_V_PRED_in_vp9_cx_iface : s32 : 23;
THR_D135_PRED : s32 : 24;
THR_D207_PRED : s32 : 25;
THR_D153_PRED : s32 : 26;
THR_D63_PRED : s32 : 27;
THR_D117_PRED : s32 : 28;
THR_D45_PRED : s32 : 29;

