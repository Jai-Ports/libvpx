COUNT_TO_UPDATE_FACTOR_in_vp9_decodemv: [21] s32;

SUB_PEL_FILTERS_12_in_vp9_decodemv: [16] Interp_Kernel12 #align 256;

MODE_2_COUNTER_in_vp9_decodemv: [14] s32;

COUNTER_TO_CONTEXT_in_vp9_decodemv: [19] s32;

MV_REF_BLOCKS_in_vp9_decodemv: [13] [8] POSITION;

IDX_N_COLUMN_TO_SUBBLOCK_in_vp9_decodemv: [4] [2] s32;

clip_pixel_in_vp9_decodemv :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_decodemv :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_decodemv :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_decodemv :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_decodemv :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_decodemv(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_decodemv(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_decodemv(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_decodemv :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_lsb_in_vp9_decodemv :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_decodemv :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_decodemv :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_decodemv(num_values) + 1 else 0;
}

get_prob_in_vp9_decodemv :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_decodemv :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_decodemv(n0, DEN);
}

weighted_prob_in_vp9_decodemv :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_decodemv :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_decodemv(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_decodemv(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_decodemv :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_decodemv[COUNT];
        PROB := get_prob_in_vp9_decodemv(ct[0], DEN);
        return weighted_prob_in_vp9_decodemv(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_band_translate_in_vp9_decodemv :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_decodemv :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_decodemv :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_decodemv(above_ec, left_ec);
}

is_zero_mv_in_vp9_decodemv :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_decodemv :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_decodemv :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_decodemv(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_decodemv(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_decodemv :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_decodemv :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_decodemv :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_decodemv :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

get_filter_taps_in_vp9_decodemv :: (FILTER: *s16) -> s32 {
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

vp9_is_valid_scale_in_vp9_decodemv :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_decodemv :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_decodemv(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_decodemv :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_decodemv :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_decodemv :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_decodemv :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_decodemv :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_decodemv :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_decodemv :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_decodemv :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_decodemv :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_decodemv :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_decodemv :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_decodemv(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_decodemv :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_decodemv(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_decodemv(MI, ib)];
}

get_uv_tx_size_in_vp9_decodemv :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_decodemv :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_decodemv :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_decodemv(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_decodemv :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_decodemv :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_decodemv :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_decodemv :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_decodemv :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_decodemv :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_decodemv :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_decodemv :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_decodemv :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_decodemv :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_decodemv :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_decodemv :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_decodemv :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_decodemv(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_decodemv :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_decodemv(cm.mi_cols);

        if get_plane_type_in_vp9_decodemv(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_decodemv(cm, xd);
}

get_partition_probs_in_vp9_decodemv :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_decodemv :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_decodemv :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_decodemv :: (
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

update_partition_context_in_vp9_decodemv :: (
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

partition_plane_context_in_vp9_decodemv :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

clamp_mv_ref_in_vp9_decodemv :: (mv: *MV, xd: *MACROBLOCKD) {
    clamp_mv_in_vp9_decodemv(
        mv,
        xd.mb_to_left_edge - (cast(s32) 16) << 3,
        xd.mb_to_right_edge + (cast(s32) 16) << 3,
        xd.mb_to_top_edge - (cast(s32) 16) << 3,
        xd.mb_to_bottom_edge + (cast(s32) 16) << 3
    );
}

get_sub_block_mv_in_vp9_decodemv :: (candidate: *MODE_INFO, which_mv: s32, search_col: s32, block_idx: s32) -> Int_Mv {
    return ifx block_idx >= 0 && candidate.sb_type < 3 then candidate.bmi[IDX_N_COLUMN_TO_SUBBLOCK_in_vp9_decodemv[block_idx][cast(s32) (search_col == 0)]].as_mv[which_mv] else candidate.mv[which_mv];
}

scale_mv_in_vp9_decodemv :: (
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

is_inside_in_vp9_decodemv :: (TILE: *Tile_Info, mi_col: s32, mi_row: s32, mi_rows: s32, mi_pos: *POSITION) -> s32 {
    if !(mi_row + mi_pos.row < 0 || mi_col + mi_pos.col < TILE.mi_col_start || mi_row + mi_pos.row >= mi_rows || mi_col + mi_pos.col >= TILE.mi_col_end) {
        return 1;
    }
    return 0;
}

clamp_mv2_in_vp9_decodemv :: (mv: *MV, xd: *MACROBLOCKD) {
    clamp_mv_in_vp9_decodemv(
        mv,
        xd.mb_to_left_edge - (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_right_edge + (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_top_edge - (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_bottom_edge + (cast,no_check(s32) ((160 - 4))) << 3
    );
}

lower_mv_precision_in_vp9_decodemv :: (mv: *MV, allow_hp: s32) {
    USE_HP := cast(s32) (allow_hp != 0 && use_mv_hp_in_vp9_decodemv(mv) != 0);
    if USE_HP == 0 {
        if mv.row & 1 != 0 {
            c_transpiler_compound_add(*(mv.row), ((ifx mv.row > 0 then cast(s32) -1 else 1)), s32, s32);
        }
        if mv.col & 1 != 0 {
            c_transpiler_compound_add(*(mv.col), ((ifx mv.col > 0 then cast(s32) -1 else 1)), s32, s32);
        }
    }
}

get_segment_id_in_vp9_decodemv :: (
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

vp9_get_pred_context_seg_id_in_vp9_decodemv :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    ABOVE_SIP := (ifx ABOVE_MI != null then cast,no_check(s32) ABOVE_MI.seg_id_predicted else 0);
    LEFT_SIP := (ifx LEFT_MI != null then cast,no_check(s32) LEFT_MI.seg_id_predicted else 0);

    return ABOVE_SIP + LEFT_SIP;
}

vp9_get_pred_prob_seg_id_in_vp9_decodemv :: (seg: *Segmentation, xd: *MACROBLOCKD) -> Prob {
    return seg.pred_probs[vp9_get_pred_context_seg_id_in_vp9_decodemv(xd)];
}

vp9_get_skip_context_in_vp9_decodemv :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    ABOVE_SKIP := (ifx ABOVE_MI != null then cast,no_check(s32) ABOVE_MI.skip else 0);
    LEFT_SKIP := (ifx LEFT_MI != null then cast,no_check(s32) LEFT_MI.skip else 0);
    return ABOVE_SKIP + LEFT_SKIP;
}

vp9_get_skip_prob_in_vp9_decodemv :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.skip_probs[vp9_get_skip_context_in_vp9_decodemv(xd)];
}

get_pred_context_switchable_interp_in_vp9_decodemv :: (xd: *MACROBLOCKD) -> s32 {
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

get_intra_inter_context_in_vp9_decodemv :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    HAS_ABOVE := cast(s32) (ABOVE_MI != null);
    HAS_LEFT := cast(s32) (LEFT_MI != null);

    if HAS_ABOVE != 0 && HAS_LEFT != 0 {
        ABOVE_INTRA := cast(s32) (is_inter_block_in_vp9_decodemv(ABOVE_MI) == 0);
        LEFT_INTRA := cast(s32) (is_inter_block_in_vp9_decodemv(LEFT_MI) == 0);
        return ifx LEFT_INTRA != 0 && ABOVE_INTRA != 0 then 3 else cast(s32) (LEFT_INTRA != 0 || ABOVE_INTRA != 0);
    } else if HAS_ABOVE != 0 || HAS_LEFT != 0 {
        return 2 * cast(s32) (is_inter_block_in_vp9_decodemv((ifx HAS_ABOVE != 0 then ABOVE_MI else LEFT_MI)) == 0);
    }
    return 0;
}

vp9_get_intra_inter_prob_in_vp9_decodemv :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.intra_inter_prob[get_intra_inter_context_in_vp9_decodemv(xd)];
}

vp9_get_reference_mode_prob_in_vp9_decodemv :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.comp_inter_prob[vp9_get_reference_mode_context(cm, xd)];
}

vp9_get_pred_prob_comp_ref_p_in_vp9_decodemv :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    PRED_CONTEXT := vp9_get_pred_context_comp_ref_p(cm, xd);
    return cm.fc.comp_ref_prob[PRED_CONTEXT];
}

vp9_get_pred_prob_single_ref_p1_in_vp9_decodemv :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return ((cm.fc.single_ref_prob[vp9_get_pred_context_single_ref_p1(xd)]).data)[0];
}

vp9_get_pred_prob_single_ref_p2_in_vp9_decodemv :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return ((cm.fc.single_ref_prob[vp9_get_pred_context_single_ref_p2(xd)]).data)[1];
}

get_tx_size_context_in_vp9_decodemv :: (xd: *MACROBLOCKD) -> s32 {
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

get_tx_probs_in_vp9_decodemv :: (max_tx_size: TX_SIZE, ctx: s32, tx_probs: *Tx_Probs) -> *Prob {
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

get_tx_counts_in_vp9_decodemv :: (max_tx_size: TX_SIZE, ctx: s32, tx_counts: *Tx_Counts) -> *u32 {
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

inter_predictor_in_vp9_decodemv :: (
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

scaled_buffer_offset_in_vp9_decodemv :: (x_offset: s32, y_offset: s32, stride: s32, sf: *Scale_Factors) -> s64 {
    X := (ifx sf != null then sf.scale_value_x(x_offset, sf) else x_offset);
    Y := (ifx sf != null then sf.scale_value_y(y_offset, sf) else y_offset);
    return ((cast,no_check(s64) Y) * cast(s64) stride) + cast(s64) X;
}

setup_pred_plane_in_vp9_decodemv :: (
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
    dst.buf = src + scaled_buffer_offset_in_vp9_decodemv(X, Y, stride, scale);
    dst.stride = stride;
}

vp8_set_reference_value_in_vp9_decodemv :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_vp9_decodemv :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_vp9_decodemv :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_vp9_decodemv :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_d_get_last_ref_updates_value_in_vp9_decodemv :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_d_get_frame_corrupted_value_in_vp9_decodemv :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_d_get_last_ref_used_value_in_vp9_decodemv :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

d_set_decryptor_value_in_vp9_decodemv :: (args: *Va_List_Tag) -> *Decrypt_Init {
    return c_transpiler_va_arg(cast(*void) (args), *Decrypt_Init);
}

vp8_d_set_decryptor_value_in_vp9_decodemv :: (args: *Va_List_Tag) -> *Decrypt_Init {
    return c_transpiler_va_arg(cast(*void) (args), *Decrypt_Init);
}

vp9_d_get_frame_size_value_in_vp9_decodemv :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_d_get_display_size_value_in_vp9_decodemv :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_d_get_bit_depth_value_in_vp9_decodemv :: (args: *Va_List_Tag) -> *u32 {
    return c_transpiler_va_arg(cast(*void) (args), *u32);
}

vp9_set_byte_alignment_value_in_vp9_decodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_invert_tile_decode_order_value_in_vp9_decodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_set_skip_loop_filter_value_in_vp9_decodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_decode_svc_spatial_layer_value_in_vp9_decodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

d_get_last_quantizer_value_in_vp9_decodemv :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_d_set_row_mt_value_in_vp9_decodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_d_set_loop_filter_opt_value_in_vp9_decodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

reader_has_error_in_vp9_decodemv :: (r: *Reader) -> s32 {
    if r.count > (cast,no_check(s32) (cast(u64) size_of(BD_VALUE))) * 8 && r.count < 0x40000000 {
        return 1;
    }
    return 0;
}

read_in_vp9_decodemv :: (r: *Reader, prob: s32) -> s32 {
    bit: u32 = 0;

    split := ((r.range * cast,no_check(u32) prob) + cast,no_check(u32) (256 - prob)) >> 8;

    if r.count < 0 {
        reader_fill(r);
    }

    value := r.value;
    count := r.count;

    bigsplit :=
        (cast,no_check(BD_VALUE) split) << ((((cast,no_check(s32) (cast(u64) size_of(BD_VALUE))) * 8 -
            8)) & 63);

    range := split;

    if value >= bigsplit {
        range = r.range - split;
        value = value - bigsplit;
        bit = 1;
    }

    {
        SHIFT: u8 = NORM[cast,no_check(u8) range];
        c_transpiler_compound_shl(*(range), (((cast,no_check(u32) (cast,no_check(s32) SHIFT)) & 31)), u32, u32);
        c_transpiler_compound_shl(*(value), (((cast,no_check(BD_VALUE) (cast,no_check(s32) SHIFT)) & 63)), BD_VALUE, BD_VALUE);
        count -= cast,no_check(s32) SHIFT;
    }
    r.value = value;
    r.count = count;
    r.range = range;

    return cast,no_check(s32) bit;
}

read_bit_in_vp9_decodemv :: (r: *Reader) -> s32 {
    return read_in_vp9_decodemv(r, 128);
}

read_literal_in_vp9_decodemv :: (r: *Reader, bits: s32) -> s32 {
    literal: s32 = 0;

    bit := bits - 1;
    while bit >= 0 {
        literal |= read_bit_in_vp9_decodemv(r) << ((bit) & 31);
        bit -= 1;
    }

    return literal;
}

read_tree_in_vp9_decodemv :: (r: *Reader, tree: *Tree_Index, probs: *Prob) -> s32 {
    i: Tree_Index = 0;

    while (ifx true { assignment_1: Tree_Index = cast,no_check(Tree_Index) (tree[(cast(s32) i) + read_in_vp9_decodemv(r, cast,no_check(s32) probs[(cast(s32) i) >> 1])]); (i) = assignment_1; assignment_1; }) > 0 {
        continue;
    }

    return -(cast,no_check(s32) i);
}

read_marker_in_vp9_decodemv :: (decrypt_cb: Decrypt_Cb, decrypt_state: *void, data: *u8) -> u8 {
    if decrypt_cb != null {
        marker: u8 = ---;
        decrypt_cb(decrypt_state, data, *marker, 1);
        return marker;
    }
    return data.*;
}

decrease_ref_count_in_vp9_decodemv :: (idx: s32, FRAME_BUFS: *Ref_Cnt_Buffer, POOL: *Buffer_Pool) {
    if idx >= 0 && FRAME_BUFS[idx].ref_count > 0 {
        FRAME_BUFS[idx].ref_count -= 1;

        if FRAME_BUFS[idx].released == 0 && FRAME_BUFS[idx].ref_count == 0 && FRAME_BUFS[idx].raw_frame_buffer.priv != null {
            POOL.release_fb_cb(POOL.cb_priv, *FRAME_BUFS[idx].raw_frame_buffer);
            FRAME_BUFS[idx].released = 1;
        }
    }
}

vp9_read_mode_info :: (twd: *Tile_Worker_Data, PBI: *VP9_Decoder, mi_row: s32, mi_col: s32, x_mis: s32, y_mis: s32) {
    r := *twd.bit_reader;
    XD := *twd.xd;
    CM := *PBI.common;
    MI := XD.mi[0];
    frame_mvs := CM.cur_frame.mvs + mi_row * CM.mi_cols + mi_col;
    w: s32 = ---;

    if frame_is_intra_only_in_vp9_decodemv(CM) != 0 {
        read_intra_frame_mode_info(CM, XD, mi_row, mi_col, r, x_mis, y_mis);
    } else {
        mi_ref_frame: [2] MV_REFERENCE_FRAME = ---;
        mi_mv: [2] Int_Mv = ---;

        read_inter_frame_mode_info(PBI, XD, mi_row, mi_col, r, x_mis, y_mis);

        copy_ref_frame_pair(mi_ref_frame.data, MI.ref_frame.data);
        copy_mv_pair(mi_mv.data, MI.mv.data);

        if 0 < y_mis {
            for h: 0..y_mis - 1 {
                w = 0;
                while w < x_mis {
                    MV_ := frame_mvs + w;
                    copy_ref_frame_pair(MV_.ref_frame.data, mi_ref_frame.data);
                    copy_mv_pair(MV_.mv.data, mi_mv.data);
                    w += 1;
                }
                frame_mvs += CM.mi_cols;
            }
        }
    }
}

copy_mv_pair :: (dst: *Int_Mv, src: *Int_Mv) {
    copy_memory(dst, src, size_of(Int_Mv) * cast(u64) 2);
}

copy_ref_frame_pair :: (dst: *MV_REFERENCE_FRAME, src: *MV_REFERENCE_FRAME) {
    copy_memory(dst, src, 2);
}

read_inter_frame_mode_info :: (
    PBI: *VP9_Decoder,
    XD: *MACROBLOCKD,
    mi_row: s32,
    mi_col: s32,
    r: *Reader,
    x_mis: s32,
    y_mis: s32
) {
    CM := *PBI.common;
    MI := XD.mi[0];

    MI.segment_id = cast,no_check(s8) read_inter_segment_id(CM, XD, mi_row, mi_col, r, x_mis, y_mis);
    MI.skip = cast,no_check(s8) read_skip(CM, XD, cast,no_check(s32) MI.segment_id, r);
    inter_block := read_is_inter_block(CM, XD, cast,no_check(s32) MI.segment_id, r);
    MI.tx_size = read_tx_size(CM, XD, cast(s32) (MI.skip == 0 || inter_block == 0), r);

    if inter_block != 0 {
        read_inter_block_mode_info(PBI, XD, MI, mi_row, mi_col, r);
    } else {
        read_intra_block_mode_info(CM, XD, MI, r);
    }
}

read_intra_block_mode_info :: (CM: *VP9_COMMON, XD: *MACROBLOCKD, mi: *MODE_INFO, r: *Reader) {
    BSIZE := mi.sb_type;
    i: s32 = ---;

    if cast,no_check(s32) BSIZE == {
        case 0;
            i = 0;
            while i < 4 {
                mi.bmi[i].as_mode = read_intra_mode_y(CM, XD, r, 0);
                i += 1;
            }
            mi.mode = mi.bmi[3].as_mode;
        case 1;
            mi.bmi[2].as_mode = read_intra_mode_y(CM, XD, r, 0);
            mi.bmi[0].as_mode = mi.bmi[2].as_mode;
            mi.mode = read_intra_mode_y(CM, XD, r, 0);
            mi.bmi[3].as_mode = mi.mode;
            mi.bmi[1].as_mode = mi.bmi[3].as_mode;
        case 2;
            mi.bmi[1].as_mode = read_intra_mode_y(CM, XD, r, 0);
            mi.bmi[0].as_mode = mi.bmi[1].as_mode;
            mi.mode = read_intra_mode_y(CM, XD, r, 0);
            mi.bmi[3].as_mode = mi.mode;
            mi.bmi[2].as_mode = mi.bmi[3].as_mode;
        case;
            mi.mode = read_intra_mode_y(CM, XD, r, cast,no_check(s32) SIZE_GROUP_LOOKUP[BSIZE]);
    }

    mi.uv_mode = read_intra_mode_uv(CM, XD, r, mi.mode);

    mi.interp_filter = 3;

    mi.ref_frame[0] = 0;
    mi.ref_frame[1] = -1;
}

read_intra_mode_uv :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, r: *Reader, y_mode: PREDICTION_MODE) -> PREDICTION_MODE {
    UV_MODE := read_intra_mode(r, cm.fc.uv_mode_prob[y_mode].data);
    counts := xd.counts;
    if counts != null {
        counts.uv_mode[y_mode][UV_MODE] += 1;
    }
    return UV_MODE;
}

read_intra_mode :: (r: *Reader, p: *Prob) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) read_tree_in_vp9_decodemv(r, VP9_INTRA_MODE_TREE.data, p);
}

read_intra_mode_y :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, r: *Reader, size_group: s32) -> PREDICTION_MODE {
    Y_MODE := read_intra_mode(r, cm.fc.y_mode_prob[size_group].data);
    counts := xd.counts;
    if counts != null {
        counts.y_mode[size_group][Y_MODE] += 1;
    }
    return Y_MODE;
}

read_inter_block_mode_info :: (
    PBI: *VP9_Decoder,
    XD: *MACROBLOCKD,
    MI: *MODE_INFO,
    mi_row: s32,
    mi_col: s32,
    r: *Reader
) {
    CM := *PBI.common;
    BSIZE := MI.sb_type;
    ALLOW_HP := CM.allow_high_precision_mv;
    best_ref_mvs: [2] Int_Mv;
    ref: s32 = ---;

    MV_REF_SEARCH := MV_REF_BLOCKS_in_vp9_decodemv[BSIZE].data;

    read_ref_frames(CM, XD, r, cast,no_check(s32) MI.segment_id, MI.ref_frame.data);
    is_compound := has_second_ref_in_vp9_decodemv(MI);
    inter_mode_ctx := get_mode_context(CM, XD, MV_REF_SEARCH, mi_row, mi_col);

    if segfeature_active_in_vp9_decodemv(
        *CM.seg,
        cast,no_check(s32) MI.segment_id,
        cast,no_check(SEG_LVL_FEATURES) SEG_LVL_SKIP
    ) != 0 {
        MI.mode = 12;
        if BSIZE < 3 {
            internal_error(
                XD.error_info,
                cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM,
                c_string("Invalid usage of segment feature on small blocks")
            );
            return;
        }
    } else if BSIZE >= 3 {
        MI.mode = read_inter_mode(CM, XD, r, cast,no_check(s32) inter_mode_ctx);
    }

    MI.interp_filter =
        cast,no_check(INTERP_FILTER) ((ifx CM.interp_filter == 4 then cast,no_check(s32) read_switchable_interp_filter(CM, XD, r) else cast,no_check(s32) CM.interp_filter));

    if BSIZE < 3 {
        NUM_4X4_W := (cast(s32) 1) << ((XD.bmode_blocks_wl) & 31);
        NUM_4X4_H := (cast(s32) 1) << ((XD.bmode_blocks_hl) & 31);
        idx: s32 = ---;
        b_mode: PREDICTION_MODE = ---;
        got_mv_refs_for_new: s32 = 0;
        best_sub8x8: [2] Int_Mv = ---;
        INVALID_MV: u32 = 0x80008000;

        best_sub8x8[1].as_int = INVALID_MV;
        idy: s32 = 0;
        while idy < 2 {
            idx = 0;
            while idx < 2 {
                J := idy * 2 + idx;
                b_mode = read_inter_mode(CM, XD, r, cast,no_check(s32) inter_mode_ctx);

                if b_mode == 10 || b_mode == 11 {
                    ref = 0;
                    while ref < 1 + is_compound {
                        append_sub8x8_mvs_for_idx(
                            CM,
                            XD,
                            MV_REF_SEARCH,
                            b_mode,
                            J,
                            ref,
                            mi_row,
                            mi_col,
                            best_sub8x8.data + ref
                        );
                        ref += 1;
                    }
                } else if b_mode == 13 && got_mv_refs_for_new == 0 {
                    ref = 0;
                    while ref < 1 + is_compound {
                        tmp_mvs: [2] Int_Mv = ---;
                        FRAME := MI.ref_frame[ref];

                        dec_find_mv_refs(CM, XD, 13, FRAME, MV_REF_SEARCH, tmp_mvs.data, mi_row, mi_col, -1);

                        lower_mv_precision_in_vp9_decodemv(*tmp_mvs[0].as_mv, ALLOW_HP);
                        best_ref_mvs[ref] = tmp_mvs[0];
                        got_mv_refs_for_new = 1;
                        ref += 1;
                    }
                }

                if assign_mv(
                    CM,
                    XD,
                    b_mode,
                    MI.bmi[J].as_mv.data,
                    best_ref_mvs.data,
                    best_sub8x8.data,
                    is_compound,
                    ALLOW_HP,
                    r
                ) == 0 {
                    XD.corrupted |= 1;
                    return;
                }

                if NUM_4X4_H == 2 {
                    MI.bmi[J + 2] = MI.bmi[J];
                }
                if NUM_4X4_W == 2 {
                    MI.bmi[J + 1] = MI.bmi[J];
                }
                idx += NUM_4X4_W;
            }
            idy += NUM_4X4_H;
        }

        MI.mode = b_mode;

        copy_mv_pair(MI.mv.data, MI.bmi[3].as_mv.data);
    } else {
        if MI.mode != 12 {
            ref = 0;
            while ref < 1 + is_compound {
                tmp_mvs: [2] Int_Mv = ---;
                FRAME := MI.ref_frame[ref];
                refmv_count :=
                    dec_find_mv_refs(
                        CM,
                        XD,
                        MI.mode,
                        FRAME,
                        MV_REF_SEARCH,
                        tmp_mvs.data,
                        mi_row,
                        mi_col,
                        -1
                    );
                lower_mv_precision_in_vp9_decodemv(*tmp_mvs[refmv_count - 1].as_mv, ALLOW_HP);
                best_ref_mvs[ref] = tmp_mvs[refmv_count - 1];
                ref += 1;
            }
        }
        XD.corrupted |=
            cast(s32) (assign_mv(
                CM,
                XD,
                MI.mode,
                MI.mv.data,
                best_ref_mvs.data,
                best_ref_mvs.data,
                is_compound,
                ALLOW_HP,
                r
            ) == 0);
    }
}

assign_mv :: (
    cm: *VP9_COMMON,
    xd: *MACROBLOCKD,
    mode: PREDICTION_MODE,
    mv: *Int_Mv,
    ref_mv: *Int_Mv,
    near_nearest_mv: *Int_Mv,
    is_compound: s32,
    allow_hp: s32,
    r: *Reader
) -> s32 {
    i: s32 = ---;
    ret: s32 = ---;
    counts: *FRAME_COUNTS = ---;
    MV_COUNTS: *Nmv_Context_Counts = ---;
    code_block_to_execute: s64 = 21;
    while c_transpiler_dispatch := true {
        if code_block_to_execute < 0 break;
        if code_block_to_execute == {
            case 12; {
                while c_transpiler_local_loop := true {
                    if i < 1 + is_compound {
                        read_mv_in_vp9_decodemv(r, *mv[i].as_mv, *ref_mv[i].as_mv, *cm.fc.nmvc, MV_COUNTS, allow_hp);
                        ret = cast(s32) (ret != 0 && is_mv_valid(*mv[i].as_mv) != 0);
                        i += 1;
                        continue c_transpiler_local_loop;
                    } else {
                        return ret;
                    }
                }
            }
            case 21; {
                ret = 1;
                c_transpiler_switch_value_21 := cast,no_check(s32) mode;
                if c_transpiler_switch_value_21 == {
                    case cast(s32) 13; {
                        counts = xd.counts;
                        MV_COUNTS = (ifx counts != null then *counts.mv else null);
                        i = 0;
                        code_block_to_execute = 12;
                        continue c_transpiler_dispatch;
                    }
                    case cast(s32) 11; {
                        copy_mv_pair(mv, near_nearest_mv);
                        return ret;
                    }
                    case cast(s32) 10; {
                        copy_mv_pair(mv, near_nearest_mv);
                        return ret;
                    }
                    case cast(s32) 12; {
                        zero_mv_pair(mv);
                        return ret;
                    }
                    case; {
                        return 0;
                    }
                }
            }
        }
        assert(false, tprint("invalid code block to execute %", code_block_to_execute));
        break;
    }
    return unreachable_value(s32);
}

zero_mv_pair :: (dst: *Int_Mv) {
    fill_memory(dst, 0, size_of(Int_Mv) * cast(u64) 2);
}

is_mv_valid :: (mv: *MV) -> s32 {
    if cast,no_check(s32) mv.row > -((cast(s32) 1) << 14) &&
        cast,no_check(s32) mv.row < (cast(s32) 1) << 14 - 1 &&
        cast,no_check(s32) mv.col > -((cast(s32) 1) << 14) &&
        cast,no_check(s32) mv.col < (cast(s32) 1) << 14 - 1 {
        return 1;
    }
    return 0;
}

read_mv_in_vp9_decodemv :: (
    r: *Reader,
    mv: *MV,
    ref: *MV,
    ctx: *Nmv_Context,
    counts: *Nmv_Context_Counts,
    allow_hp: s32
) {
    JOINT_TYPE :=
        cast,no_check(MV_JOINT_TYPE) read_tree_in_vp9_decodemv(
            r,
            cast(*Tree_Index) *(VP9_MV_JOINT_TREE),
            ctx.joints.data
        );
    USE_HP := cast(s32) (allow_hp != 0 && use_mv_hp_in_vp9_decodemv(ref) != 0);
    diff: MV;

    if mv_joint_vertical_in_vp9_decodemv(JOINT_TYPE) != 0 {
        diff.row = cast,no_check(s16) read_mv_component(r, ctx.comps.data + 0, USE_HP);
    }

    if mv_joint_horizontal_in_vp9_decodemv(JOINT_TYPE) != 0 {
        diff.col = cast,no_check(s16) read_mv_component(r, ctx.comps.data + 1, USE_HP);
    }

    vp9_inc_mv(*diff, counts);

    mv.row = cast,no_check(s16) ((cast(s32) ref.row) + cast(s32) diff.row);
    mv.col = cast,no_check(s16) ((cast(s32) ref.col) + cast(s32) diff.col);
}

read_mv_component :: (r: *Reader, mvcomp: *Nmv_Component, usehp: s32) -> s32 {
    mag: s32 = ---;
    d: s32 = ---;
    SIGN := read_in_vp9_decodemv(r, cast,no_check(s32) mvcomp.sign);
    MV_CLASS := read_tree_in_vp9_decodemv(r, cast(*Tree_Index) *(VP9_MV_CLASS_TREE), mvcomp.classes.data);
    CLASS0 := cast(s32) (MV_CLASS == MV_CLASS_0);

    if CLASS0 != 0 {
        d = read_in_vp9_decodemv(r, cast,no_check(s32) mvcomp.class0[0]);
        mag = 0;
    } else {
        N := MV_CLASS + 1 - 1;

        d = 0;
        if 0 < N {
            for i: 0..N - 1 {
                d |= read_in_vp9_decodemv(r, cast,no_check(s32) mvcomp.bits[i]) << ((i) & 31);
            }
        }
        mag = (cast(s32) 1) << 1 << (((MV_CLASS + 2)) & 31);
    }

    fr :=
        read_tree_in_vp9_decodemv(
            r,
            cast(*Tree_Index) *(VP9_MV_FP_TREE),
            (ifx CLASS0 != 0 then mvcomp.class0_fp[d].data else mvcomp.fp.data)
        );

    hp :=
        (ifx usehp != 0 then read_in_vp9_decodemv(
            r,
            (ifx CLASS0 != 0 then cast,no_check(s32) mvcomp.class0_hp else cast,no_check(s32) mvcomp.hp)
        ) else 1);

    mag += d << 3 | (fr << 1) | hp + 1;
    return ifx SIGN != 0 then -mag else mag;
}

dec_find_mv_refs :: (
    cm: *VP9_COMMON,
    xd: *MACROBLOCKD,
    mode: PREDICTION_MODE,
    ref_frame: MV_REFERENCE_FRAME,
    MV_REF_SEARCH: *POSITION,
    mv_ref_list: *Int_Mv,
    mi_row: s32,
    mi_col: s32,
    block: s32
) -> s32 {
    ref_sign_bias := cm.ref_frame_sign_bias.data;
    i: s32 = ---;
    refmv_count: s32 = 0;
    different_ref_found: s32 = 0;
    PREV_FRAME_MVS: *MV_REF =
        (ifx cm.use_prev_frame_mvs != 0 then cm.prev_frame.mvs +
            mi_row * cm.mi_cols + mi_col else null);
    TILE := *xd.tile;
    EARLY_BREAK := cast(s32) (mode != 11);
    fill_memory(mv_ref_list, 0, size_of(Int_Mv) * cast(u64) 2);
    i = 0;
    while done := true { // Forward-goto shim; executes at most once.
        if block >= 0 {
            i = 0;
            while i < 2 {
                MV_REF_ := *MV_REF_SEARCH[i];
                if is_inside_in_vp9_decodemv(TILE, mi_col, mi_row, cm.mi_rows, MV_REF_) != 0 {
                    CANDIDATE_MI := xd.mi[MV_REF_.col + MV_REF_.row * xd.mi_stride];
                    different_ref_found = 1;

                    if CANDIDATE_MI.ref_frame[0] == ref_frame {
                        if refmv_count != 0 {
                            if (get_sub_block_mv_in_vp9_decodemv(CANDIDATE_MI, 0, MV_REF_.col, block)).as_int != mv_ref_list[0].as_int {
                                mv_ref_list[refmv_count] =
                                    get_sub_block_mv_in_vp9_decodemv(
                                        CANDIDATE_MI,
                                        0,
                                        MV_REF_.col,
                                        block
                                    );

                                refmv_count += 1;

                                break done;
                            }
                        } else {
                            assignment_2: Int_Mv =
                                get_sub_block_mv_in_vp9_decodemv(CANDIDATE_MI, 0, MV_REF_.col, block);
                            (mv_ref_list[c_transpiler_post_increment(*(refmv_count))]) = assignment_2;

                            if EARLY_BREAK != 0 {
                                break done;
                            }
                        }
                    } else if CANDIDATE_MI.ref_frame[1] == ref_frame {
                        if refmv_count != 0 {
                            if (get_sub_block_mv_in_vp9_decodemv(CANDIDATE_MI, 1, MV_REF_.col, block)).as_int != mv_ref_list[0].as_int {
                                mv_ref_list[refmv_count] =
                                    get_sub_block_mv_in_vp9_decodemv(
                                        CANDIDATE_MI,
                                        1,
                                        MV_REF_.col,
                                        block
                                    );

                                refmv_count += 1;

                                break done;
                            }
                        } else {
                            assignment_3: Int_Mv =
                                get_sub_block_mv_in_vp9_decodemv(CANDIDATE_MI, 1, MV_REF_.col, block);
                            (mv_ref_list[c_transpiler_post_increment(*(refmv_count))]) = assignment_3;

                            if EARLY_BREAK != 0 {
                                break done;
                            }
                        }
                    }
                }
                i += 1;
            }
        }
        while i < 8 {
            MV_REF_ := *MV_REF_SEARCH[i];
            if is_inside_in_vp9_decodemv(TILE, mi_col, mi_row, cm.mi_rows, MV_REF_) != 0 {
                CANDIDATE := xd.mi[MV_REF_.col + MV_REF_.row * xd.mi_stride];
                different_ref_found = 1;

                if CANDIDATE.ref_frame[0] == ref_frame {
                    if refmv_count != 0 {
                        if CANDIDATE.mv[0].as_int != mv_ref_list[0].as_int {
                            mv_ref_list[refmv_count] = CANDIDATE.mv[0];

                            refmv_count += 1;

                            break done;
                        }
                    } else {
                        mv_ref_list[refmv_count] = CANDIDATE.mv[0];
                        refmv_count += 1;

                        if EARLY_BREAK != 0 {
                            break done;
                        }
                    }
                } else if CANDIDATE.ref_frame[1] == ref_frame {
                    if refmv_count != 0 {
                        if CANDIDATE.mv[1].as_int != mv_ref_list[0].as_int {
                            mv_ref_list[refmv_count] = CANDIDATE.mv[1];

                            refmv_count += 1;

                            break done;
                        }
                    } else {
                        mv_ref_list[refmv_count] = CANDIDATE.mv[1];
                        refmv_count += 1;

                        if EARLY_BREAK != 0 {
                            break done;
                        }
                    }
                }
            }
            i += 1;
        }
        if PREV_FRAME_MVS != null {
            if PREV_FRAME_MVS.ref_frame[0] == ref_frame {
                if refmv_count != 0 {
                    if PREV_FRAME_MVS.mv[0].as_int != mv_ref_list[0].as_int {
                        mv_ref_list[refmv_count] = PREV_FRAME_MVS.mv[0];

                        refmv_count += 1;

                        break done;
                    }
                } else {
                    mv_ref_list[refmv_count] = PREV_FRAME_MVS.mv[0];
                    refmv_count += 1;

                    if EARLY_BREAK != 0 {
                        break done;
                    }
                }
            } else if PREV_FRAME_MVS.ref_frame[1] == ref_frame {
                if refmv_count != 0 {
                    if PREV_FRAME_MVS.mv[1].as_int != mv_ref_list[0].as_int {
                        mv_ref_list[refmv_count] = PREV_FRAME_MVS.mv[1];

                        refmv_count += 1;

                        break done;
                    }
                } else {
                    mv_ref_list[refmv_count] = PREV_FRAME_MVS.mv[1];
                    refmv_count += 1;

                    if EARLY_BREAK != 0 {
                        break done;
                    }
                }
            }
        }
        if different_ref_found != 0 {
            i = 0;
            while i < 8 {
                mv_ref := *MV_REF_SEARCH[i];
                if is_inside_in_vp9_decodemv(TILE, mi_col, mi_row, cm.mi_rows, mv_ref) != 0 {
                    CANDIDATE := xd.mi[mv_ref.col + mv_ref.row * xd.mi_stride];

                    if is_inter_block_in_vp9_decodemv(CANDIDATE) != 0 {
                        if CANDIDATE.ref_frame[0] != ref_frame {
                            if refmv_count != 0 {
                                if (scale_mv_in_vp9_decodemv(CANDIDATE, 0, ref_frame, ref_sign_bias)).as_int != mv_ref_list[0].as_int {
                                    mv_ref_list[refmv_count] =
                                        scale_mv_in_vp9_decodemv(
                                            CANDIDATE,
                                            0,
                                            ref_frame,
                                            ref_sign_bias
                                        );

                                    refmv_count += 1;

                                    break done;
                                }
                            } else {
                                assignment_4: Int_Mv = scale_mv_in_vp9_decodemv(CANDIDATE, 0, ref_frame, ref_sign_bias);
                                (mv_ref_list[c_transpiler_post_increment(*(refmv_count))]) = assignment_4;

                                if EARLY_BREAK != 0 {
                                    break done;
                                }
                            }
                        }

                        if has_second_ref_in_vp9_decodemv(CANDIDATE) != 0 &&
                            CANDIDATE.ref_frame[1] != ref_frame &&
                            CANDIDATE.mv[1].as_int != CANDIDATE.mv[0].as_int {
                            if refmv_count != 0 {
                                if (scale_mv_in_vp9_decodemv(CANDIDATE, 1, ref_frame, ref_sign_bias)).as_int != mv_ref_list[0].as_int {
                                    mv_ref_list[refmv_count] =
                                        scale_mv_in_vp9_decodemv(
                                            CANDIDATE,
                                            1,
                                            ref_frame,
                                            ref_sign_bias
                                        );

                                    refmv_count += 1;

                                    break done;
                                }
                            } else {
                                assignment_5: Int_Mv = scale_mv_in_vp9_decodemv(CANDIDATE, 1, ref_frame, ref_sign_bias);
                                (mv_ref_list[c_transpiler_post_increment(*(refmv_count))]) = assignment_5;

                                if EARLY_BREAK != 0 {
                                    break done;
                                }
                            }
                        }
                    }
                }
                i += 1;
            }
        }
        if PREV_FRAME_MVS != null {
            if PREV_FRAME_MVS.ref_frame[0] != ref_frame && PREV_FRAME_MVS.ref_frame[0] > 0 {
                mv := PREV_FRAME_MVS.mv[0];
                if ref_sign_bias[PREV_FRAME_MVS.ref_frame[0]] != ref_sign_bias[ref_frame] {
                    mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mv.as_mv.row) * -1);
                    mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mv.as_mv.col) * -1);
                }
                if refmv_count != 0 {
                    if mv.as_int != mv_ref_list[0].as_int {
                        mv_ref_list[refmv_count] = mv;

                        refmv_count += 1;

                        break done;
                    }
                } else {
                    mv_ref_list[refmv_count] = mv;
                    refmv_count += 1;

                    if EARLY_BREAK != 0 {
                        break done;
                    }
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

                        refmv_count += 1;

                        break done;
                    }
                } else {
                    mv_ref_list[refmv_count] = mv;
                    refmv_count += 1;

                    if EARLY_BREAK != 0 {
                        break done;
                    }
                }
            }
        }
        if mode == 11 {
            refmv_count = 2;
        } else {
            refmv_count = 1;
        }
        break done;
    }
    i = 0;
    while i < refmv_count {
        clamp_mv_ref_in_vp9_decodemv(*mv_ref_list[i].as_mv, xd);
        i += 1;
    }
    return refmv_count;
}

append_sub8x8_mvs_for_idx :: (
    cm: *VP9_COMMON,
    xd: *MACROBLOCKD,
    MV_REF_SEARCH: *POSITION,
    b_mode: PREDICTION_MODE,
    block: s32,
    ref: s32,
    mi_row: s32,
    mi_col: s32,
    best_sub8x8: *Int_Mv
) {
    mv_list: [2] Int_Mv = ---;
    MI: *MODE_INFO = ---;
    bmi: *B_Mode_Info = ---;
    n: s32 = ---;
    refmv_count: s32 = ---;
    code_block_to_execute: s64 = 43;
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
                if n < 2 {
                    code_block_to_execute = 11;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 6;
                    continue c_transpiler_dispatch;
                }
            }
            case 11; {
                if bmi[2].as_mv[ref].as_int != mv_list[n].as_int {
                    best_sub8x8.as_int = mv_list[n].as_int;
                    code_block_to_execute = 6;
                    continue c_transpiler_dispatch;
                } else {
                    n += 1;
                    code_block_to_execute = 7;
                    continue c_transpiler_dispatch;
                }
            }
            case 23; {
                break c_transpiler_dispatch;
            }
            case 24; {
                if n < 2 {
                    code_block_to_execute = 28;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 23;
                    continue c_transpiler_dispatch;
                }
            }
            case 28; {
                if bmi[0].as_mv[ref].as_int != mv_list[n].as_int {
                    best_sub8x8.as_int = mv_list[n].as_int;
                    code_block_to_execute = 23;
                    continue c_transpiler_dispatch;
                } else {
                    n += 1;
                    code_block_to_execute = 24;
                    continue c_transpiler_dispatch;
                }
            }
            case 33; {
                if b_mode == 10 {
                    best_sub8x8.as_int = bmi[0].as_mv[ref].as_int;
                    code_block_to_execute = 23;
                    continue c_transpiler_dispatch;
                } else {
                    dec_find_mv_refs(
                        cm,
                        xd,
                        b_mode,
                        MI.ref_frame[ref],
                        MV_REF_SEARCH,
                        mv_list.data,
                        mi_row,
                        mi_col,
                        block
                    );
                    best_sub8x8.as_int = 0;
                    n = 0;
                    code_block_to_execute = 24;
                    continue c_transpiler_dispatch;
                }
            }
            case 43; {
                MI = xd.mi[0];
                bmi = MI.bmi.data;
                c_transpiler_switch_value_43 := block;
                if c_transpiler_switch_value_43 == {
                    case cast(s32) 0; {
                        refmv_count =
                            dec_find_mv_refs(
                                cm,
                                xd,
                                b_mode,
                                MI.ref_frame[ref],
                                MV_REF_SEARCH,
                                mv_list.data,
                                mi_row,
                                mi_col,
                                block
                            );
                        best_sub8x8.as_int = mv_list[refmv_count - 1].as_int;
                        break c_transpiler_dispatch;
                    }
                    case cast(s32) 1; {
                        code_block_to_execute = 33;
                        continue c_transpiler_dispatch;
                    }
                    case cast(s32) 2; {
                        code_block_to_execute = 33;
                        continue c_transpiler_dispatch;
                    }
                    case cast(s32) 3; {
                        if b_mode == 10 {
                            best_sub8x8.as_int = bmi[2].as_mv[ref].as_int;
                            code_block_to_execute = 6;
                            continue c_transpiler_dispatch;
                        } else {
                            best_sub8x8.as_int = 0;
                            if bmi[2].as_mv[ref].as_int != bmi[1].as_mv[ref].as_int {
                                best_sub8x8.as_int = bmi[1].as_mv[ref].as_int;
                                break c_transpiler_dispatch;
                            } else {
                                if bmi[2].as_mv[ref].as_int != bmi[0].as_mv[ref].as_int {
                                    best_sub8x8.as_int = bmi[0].as_mv[ref].as_int;
                                    break c_transpiler_dispatch;
                                } else {
                                    dec_find_mv_refs(
                                        cm,
                                        xd,
                                        b_mode,
                                        MI.ref_frame[ref],
                                        MV_REF_SEARCH,
                                        mv_list.data,
                                        mi_row,
                                        mi_col,
                                        block
                                    );
                                    n = 0;
                                    code_block_to_execute = 7;
                                    continue c_transpiler_dispatch;
                                }
                            }
                        }
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

read_inter_mode :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, r: *Reader, ctx: s32) -> PREDICTION_MODE {
    MODE_ := read_tree_in_vp9_decodemv(r, VP9_INTER_MODE_TREE.data, cm.fc.inter_mode_probs[ctx].data);
    counts := xd.counts;
    if counts != null {
        counts.inter_mode[ctx][MODE_] += 1;
    }

    return cast,no_check(PREDICTION_MODE) (10 + MODE_);
}

read_switchable_interp_filter :: (CM: *VP9_COMMON, XD: *MACROBLOCKD, r: *Reader) -> INTERP_FILTER {
    CTX := get_pred_context_switchable_interp_in_vp9_decodemv(XD);
    TYPE :=
        cast,no_check(INTERP_FILTER) read_tree_in_vp9_decodemv(
            r,
            VP9_SWITCHABLE_INTERP_TREE.data,
            CM.fc.switchable_interp_prob[CTX].data
        );
    counts := XD.counts;
    if counts != null {
        counts.switchable_interp[CTX][TYPE] += 1;
    }
    return TYPE;
}

get_mode_context :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, MV_REF_SEARCH: *POSITION, mi_row: s32, mi_col: s32) -> u8 {
    context_counter: s32 = 0;
    TILE := *xd.tile;

    for i: 0..cast(s32) 2 - 1 {
        MV_REF_ := *MV_REF_SEARCH[i];
        if is_inside_in_vp9_decodemv(TILE, mi_col, mi_row, cm.mi_rows, MV_REF_) != 0 {
            CANDIDATE := xd.mi[MV_REF_.col + MV_REF_.row * xd.mi_stride];

            context_counter += MODE_2_COUNTER_in_vp9_decodemv[CANDIDATE.mode];
        }
    }

    return cast,no_check(u8) COUNTER_TO_CONTEXT_in_vp9_decodemv[context_counter];
}

read_ref_frames :: (CM: *VP9_COMMON, XD: *MACROBLOCKD, r: *Reader, segment_id: s32, ref_frame: *MV_REFERENCE_FRAME) {
    FC := CM.fc;
    counts := XD.counts;

    if segfeature_active_in_vp9_decodemv(*CM.seg, segment_id, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME) != 0 {
        ref_frame[0] =
            cast,no_check(MV_REFERENCE_FRAME) get_segdata_in_vp9_decodemv(
                *CM.seg,
                segment_id,
                cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
            );
        ref_frame[1] = -1;
    } else {
        MODE_ := read_block_reference_mode(CM, XD, r);

        if MODE_ == cast,no_check(u32) COMPOUND_REFERENCE {
            IDX := CM.ref_frame_sign_bias[CM.comp_fixed_ref];
            CTX := vp9_get_pred_context_comp_ref_p(CM, XD);
            BIT := read_in_vp9_decodemv(r, cast,no_check(s32) FC.comp_ref_prob[CTX]);
            if counts != null {
                counts.comp_ref[CTX][BIT] += 1;
            }
            ref_frame[IDX] = CM.comp_fixed_ref;
            ref_frame[cast(s32) (IDX == 0)] = CM.comp_var_ref[BIT];
        } else if MODE_ == cast,no_check(u32) SINGLE_REFERENCE {
            CTX0 := vp9_get_pred_context_single_ref_p1(XD);
            BIT0 := read_in_vp9_decodemv(r, cast,no_check(s32) FC.single_ref_prob[CTX0][0]);
            if counts != null {
                counts.single_ref[CTX0][0][BIT0] += 1;
            }
            if BIT0 != 0 {
                CTX1 := vp9_get_pred_context_single_ref_p2(XD);
                BIT1 := read_in_vp9_decodemv(r, cast,no_check(s32) FC.single_ref_prob[CTX1][1]);
                if counts != null {
                    counts.single_ref[CTX1][1][BIT1] += 1;
                }
                ref_frame[0] = ifx BIT1 != 0 then cast(MV_REFERENCE_FRAME) 3 else 2;
            } else {
                ref_frame[0] = 1;
            }

            ref_frame[1] = -1;
        } else {
        }
    }
}

read_block_reference_mode :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, r: *Reader) -> REFERENCE_MODE {
    if cm.reference_mode == cast,no_check(u32) REFERENCE_MODE_SELECT {
        CTX := vp9_get_reference_mode_context(cm, xd);
        MODE_ :=
            cast,no_check(REFERENCE_MODE) read_in_vp9_decodemv(
                r,
                cast,no_check(s32) cm.fc.comp_inter_prob[CTX]
            );
        counts := xd.counts;
        if counts != null {
            counts.comp_inter[CTX][MODE_] += 1;
        }
        return MODE_;
    } else {
        return cm.reference_mode;
    }
}

read_tx_size :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, allow_select: s32, r: *Reader) -> TX_SIZE {
    tx_mode := cm.tx_mode;
    bsize := xd.mi[0].sb_type;
    MAX_TX_SIZE := MAX_TXSIZE_LOOKUP[bsize];
    if allow_select != 0 && tx_mode == cast,no_check(u32) TX_MODE_SELECT && bsize >= 3 {
        return read_selected_tx_size(cm, xd, MAX_TX_SIZE, r);
    } else {
        return cast,no_check(TX_SIZE) ((ifx MAX_TX_SIZE < TX_MODE_TO_BIGGEST_TX_SIZE[tx_mode] then cast,no_check(s32) MAX_TX_SIZE else cast,no_check(s32) TX_MODE_TO_BIGGEST_TX_SIZE[tx_mode]));
    }
}

read_selected_tx_size :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, max_tx_size: TX_SIZE, r: *Reader) -> TX_SIZE {
    counts := xd.counts;
    CTX := get_tx_size_context_in_vp9_decodemv(xd);
    tx_probs := get_tx_probs_in_vp9_decodemv(max_tx_size, CTX, *cm.fc.tx_probs);
    tx_size := read_in_vp9_decodemv(r, cast,no_check(s32) tx_probs[0]);
    if tx_size != cast,no_check(s32) (cast(TX_SIZE) 0) && max_tx_size >= cast(TX_SIZE) 2 {
        tx_size += read_in_vp9_decodemv(r, cast,no_check(s32) tx_probs[1]);
        if tx_size != cast,no_check(s32) (cast(TX_SIZE) 1) && max_tx_size >= cast(TX_SIZE) 3 {
            tx_size += read_in_vp9_decodemv(r, cast,no_check(s32) tx_probs[2]);
        }
    }

    if counts != null {
        (get_tx_counts_in_vp9_decodemv(max_tx_size, CTX, *counts.tx))[tx_size] += 1;
    }
    return cast,no_check(TX_SIZE) tx_size;
}

read_is_inter_block :: (CM: *VP9_COMMON, XD: *MACROBLOCKD, segment_id: s32, r: *Reader) -> s32 {
    if segfeature_active_in_vp9_decodemv(*CM.seg, segment_id, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME) != 0 {
        if get_segdata_in_vp9_decodemv(*CM.seg, segment_id, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME) != 0 {
            return 1;
        }
        return 0;
    } else {
        CTX := get_intra_inter_context_in_vp9_decodemv(XD);
        IS_INTER := read_in_vp9_decodemv(r, cast,no_check(s32) CM.fc.intra_inter_prob[CTX]);
        counts := XD.counts;
        if counts != null {
            counts.intra_inter[CTX][IS_INTER] += 1;
        }
        return IS_INTER;
    }
}

read_skip :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, segment_id: s32, r: *Reader) -> s32 {
    if segfeature_active_in_vp9_decodemv(*cm.seg, segment_id, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_SKIP) != 0 {
        return 1;
    } else {
        CTX := vp9_get_skip_context_in_vp9_decodemv(xd);
        SKIP := read_in_vp9_decodemv(r, cast,no_check(s32) cm.fc.skip_probs[CTX]);
        counts := xd.counts;
        if counts != null {
            counts.skip[CTX][SKIP] += 1;
        }
        return SKIP;
    }
}

read_inter_segment_id :: (
    CM: *VP9_COMMON,
    XD: *MACROBLOCKD,
    mi_row: s32,
    mi_col: s32,
    r: *Reader,
    x_mis: s32,
    y_mis: s32
) -> s32 {
    SEG := *CM.seg;
    MI := XD.mi[0];
    segment_id: s32 = ---;
    MI_OFFSET := mi_row * CM.mi_cols + mi_col;

    if SEG.enabled == 0 {
        return 0;
    }

    predicted_segment_id :=
        (ifx CM.last_frame_seg_map != null then dec_get_segment_id(CM, CM.last_frame_seg_map, MI_OFFSET, x_mis, y_mis) else 0);

    if SEG.update_map == 0 {
        copy_segment_id(CM, CM.last_frame_seg_map, CM.current_frame_seg_map, MI_OFFSET, x_mis, y_mis);
        return predicted_segment_id;
    }

    if SEG.temporal_update != 0 {
        PRED_PROB := vp9_get_pred_prob_seg_id_in_vp9_decodemv(SEG, XD);
        MI.seg_id_predicted = cast,no_check(s8) read_in_vp9_decodemv(r, cast,no_check(s32) PRED_PROB);
        segment_id = ifx MI.seg_id_predicted != 0 then predicted_segment_id else read_segment_id(r, SEG);
    } else {
        segment_id = read_segment_id(r, SEG);
    }
    set_segment_id(CM, MI_OFFSET, x_mis, y_mis, segment_id);
    return segment_id;
}

set_segment_id :: (cm: *VP9_COMMON, mi_offset: s32, x_mis: s32, y_mis: s32, segment_id: s32) {
    x: s32 = ---;

    if 0 < y_mis {
        for y: 0..y_mis - 1 {
            x = 0;
            while x < x_mis {
                cm.current_frame_seg_map[mi_offset + y * cm.mi_cols + x] = cast,no_check(u8) segment_id;
                x += 1;
            }
        }
    }
}

read_segment_id :: (r: *Reader, seg: *Segmentation) -> s32 {
    return read_tree_in_vp9_decodemv(r, VP9_SEGMENT_TREE.data, seg.tree_probs.data);
}

copy_segment_id :: (
    cm: *VP9_COMMON,
    last_segment_ids: *u8,
    current_segment_ids: *u8,
    mi_offset: s32,
    x_mis: s32,
    y_mis: s32
) {
    x: s32 = ---;

    if 0 < y_mis {
        for y: 0..y_mis - 1 {
            x = 0;
            while x < x_mis {
                current_segment_ids[mi_offset + y * cm.mi_cols + x] =
                    cast,no_check(u8) ((ifx last_segment_ids != null then cast,no_check(s32) last_segment_ids[mi_offset +
                        y * cm.mi_cols + x] else 0));
                x += 1;
            }
        }
    }
}

dec_get_segment_id :: (cm: *VP9_COMMON, segment_ids: *u8, mi_offset: s32, x_mis: s32, y_mis: s32) -> s32 {
    x: s32 = ---;
    segment_id: s32 = 2147483647;

    if 0 < y_mis {
        for y: 0..y_mis - 1 {
            x = 0;
            while x < x_mis {
                segment_id =
                    ifx segment_id < cast,no_check(s32) segment_ids[mi_offset + y * cm.mi_cols +
                        x] then segment_id else cast,no_check(s32) segment_ids[mi_offset + y * cm.mi_cols + x];
                x += 1;
            }
        }
    }

    return segment_id;
}

read_intra_frame_mode_info :: (
    CM: *VP9_COMMON,
    XD: *MACROBLOCKD,
    mi_row: s32,
    mi_col: s32,
    r: *Reader,
    x_mis: s32,
    y_mis: s32
) {
    MI := XD.mi[0];
    above_mi := XD.above_mi;
    left_mi := XD.left_mi;
    BSIZE := MI.sb_type;
    i: s32 = ---;
    MI_OFFSET := mi_row * CM.mi_cols + mi_col;

    MI.segment_id = cast,no_check(s8) read_intra_segment_id(CM, MI_OFFSET, x_mis, y_mis, r);
    MI.skip = cast,no_check(s8) read_skip(CM, XD, cast,no_check(s32) MI.segment_id, r);
    MI.tx_size = read_tx_size(CM, XD, 1, r);
    MI.ref_frame[0] = 0;
    MI.ref_frame[1] = -1;

    if cast,no_check(s32) BSIZE == {
        case 0;
            i = 0;
            while i < 4 {
                MI.bmi[i].as_mode = read_intra_mode(r, get_y_mode_probs_in_vp9_decodemv(MI, above_mi, left_mi, i));
                i += 1;
            }
            MI.mode = MI.bmi[3].as_mode;
        case 1;
            MI.bmi[2].as_mode = read_intra_mode(r, get_y_mode_probs_in_vp9_decodemv(MI, above_mi, left_mi, 0));
            MI.bmi[0].as_mode = MI.bmi[2].as_mode;
            MI.mode = read_intra_mode(r, get_y_mode_probs_in_vp9_decodemv(MI, above_mi, left_mi, 1));
            MI.bmi[3].as_mode = MI.mode;
            MI.bmi[1].as_mode = MI.bmi[3].as_mode;
        case 2;
            MI.bmi[1].as_mode = read_intra_mode(r, get_y_mode_probs_in_vp9_decodemv(MI, above_mi, left_mi, 0));
            MI.bmi[0].as_mode = MI.bmi[1].as_mode;
            MI.mode = read_intra_mode(r, get_y_mode_probs_in_vp9_decodemv(MI, above_mi, left_mi, 2));
            MI.bmi[3].as_mode = MI.mode;
            MI.bmi[2].as_mode = MI.bmi[3].as_mode;
        case;
            MI.mode = read_intra_mode(r, get_y_mode_probs_in_vp9_decodemv(MI, above_mi, left_mi, 0));
    }

    MI.uv_mode = read_intra_mode(r, VP9_KF_UV_MODE_PROB[MI.mode].data);
}

read_intra_segment_id :: (CM: *VP9_COMMON, mi_offset: s32, x_mis: s32, y_mis: s32, r: *Reader) -> s32 {
    SEG := *CM.seg;

    if SEG.enabled == 0 {
        return 0;
    }

    if SEG.update_map == 0 {
        copy_segment_id(CM, CM.last_frame_seg_map, CM.current_frame_seg_map, mi_offset, x_mis, y_mis);
        return 0;
    }

    segment_id := read_segment_id(r, SEG);
    set_segment_id(CM, mi_offset, x_mis, y_mis, segment_id);
    return segment_id;
}

globals_initialization_state_for_vp9_decodemv: u32;
initialize_globals_for_vp9_decodemv :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_decodemv);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_decodemv, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_decodemv) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_vp9_decodemv =
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
    SUB_PEL_FILTERS_12_in_vp9_decodemv =
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
    MODE_2_COUNTER_in_vp9_decodemv =
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
    COUNTER_TO_CONTEXT_in_vp9_decodemv =
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
    MV_REF_BLOCKS_in_vp9_decodemv =
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
    IDX_N_COLUMN_TO_SUBBLOCK_in_vp9_decodemv =
        [2] s32.[
            s32.[ 1, 2 ],
            s32.[ 1, 3 ],
            s32.[ 3, 2 ],
            s32.[ 3, 3 ]
        ];
    atomic_store(*globals_initialization_state_for_vp9_decodemv, 2);
}

