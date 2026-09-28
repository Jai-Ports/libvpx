// Generated directly from C by cpp_transpiler.
COUNT_TO_UPDATE_FACTOR_in_vp9_alloccommon: [21] s32;

SUB_PEL_FILTERS_12: [16] Interp_Kernel12 #align 256;

vp9_remove_common :: (cm: *VP9_COMMON) {
    vp9_free_context_buffers(cm);

    deallocate_memory(cast(*void) cm.fc);
    cm.fc = null;
    deallocate_memory(cast(*void) cm.frame_contexts);
    cm.frame_contexts = null;
}

vp9_free_context_buffers :: (cm: *VP9_COMMON) {
    if cm.free_mi != null {
        cm.free_mi(cm);
    }
    free_seg_map(cm);
    deallocate_memory(cast(*void) cm.above_context);
    cm.above_context = null;
    deallocate_memory(cast(*void) cm.above_seg_context);
    cm.above_seg_context = null;
    cm.above_context_alloc_cols = 0;
    deallocate_memory(cast(*void) cm.lf.lfm);
    cm.lf.lfm = null;
}

free_seg_map :: (cm: *VP9_COMMON) {
    for i: 0..cast(s32) 2 - 1 {
        deallocate_memory(cast(*void) cm.seg_map_array[i]);
        cm.seg_map_array[i] = null;
    }
    cm.seg_map_alloc_size = 0;

    cm.current_frame_seg_map = null;
    cm.last_frame_seg_map = null;
}

vp9_alloc_loop_filter :: (cm: *VP9_COMMON) -> s32 {
    deallocate_memory(cast(*void) cm.lf.lfm);

    cm.lf.lfm_stride = (cm.mi_cols + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) >> 3;
    cm.lf.lfm =
        cast(*LOOP_FILTER_MASK) calloc_2(
            cast,no_check(u64) ((cm.mi_rows + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) >> 3 * cm.lf.lfm_stride),
            size_of(LOOP_FILTER_MASK)
        );
    if cm.lf.lfm == null {
        return 1;
    }
    return 0;
}

vp9_alloc_context_buffers :: (cm: *VP9_COMMON, width: s32, height: s32) -> s32 {
    new_mi_size: s32 = ---;
    vp9_set_mb_mi(cm, width, height);
    new_mi_size = cm.mi_stride * calc_mi_size(cm.mi_rows);
    while fail := true { // Forward-goto shim; executes at most once.
        if cm.mi_alloc_size < new_mi_size {
            cm.free_mi(cm);
            if cm.alloc_mi(cm, new_mi_size) != 0 {
                break fail;
            }
        }
        if cm.above_context_alloc_cols < cm.mi_cols {
            deallocate_memory(cast(*void) cm.above_context);
            cm.above_context =
                cast(*ENTROPY_CONTEXT) calloc_2(
                    cast,no_check(u64) (2 * mi_cols_aligned_to_sb(cm.mi_cols) * 3),
                    size_of(ENTROPY_CONTEXT)
                );
            if cm.above_context == null {
                break fail;
            }

            deallocate_memory(cast(*void) cm.above_seg_context);
            cm.above_seg_context =
                cast(*PARTITION_CONTEXT) calloc_2(
                    cast,no_check(u64) mi_cols_aligned_to_sb(cm.mi_cols),
                    size_of(PARTITION_CONTEXT)
                );
            if cm.above_seg_context == null {
                break fail;
            }
            cm.above_context_alloc_cols = cm.mi_cols;
        }
        if cm.seg_map_alloc_size < cm.mi_rows * cm.mi_cols {
            free_seg_map(cm);
            if alloc_seg_map(cm, cm.mi_rows * cm.mi_cols) != 0 {
                break fail;
            }
        }
        if vp9_alloc_loop_filter(cm) != 0 {
            break fail;
        }
        return 0;
    }
    vp9_set_mb_mi(cm, 0, 0);
    vp9_free_context_buffers(cm);
    return 1;
}

vp9_set_mb_mi :: (cm: *VP9_COMMON, width: s32, height: s32) {
    vp9_set_mi_size(*cm.mi_rows, *cm.mi_cols, *cm.mi_stride, width, height);
    vp9_set_mb_size(*cm.mb_rows, *cm.mb_cols, *cm.m_bs, cm.mi_rows, cm.mi_cols);
}

vp9_set_mb_size :: (mb_rows: *s32, mb_cols: *s32, mb_num: *s32, mi_rows: s32, mi_cols: s32) {
    mb_cols.* = (mi_cols + 1) >> 1;
    mb_rows.* = (mi_rows + 1) >> 1;
    mb_num.* = mb_rows.* * mb_cols.*;
}

vp9_set_mi_size :: (mi_rows: *s32, mi_cols: *s32, mi_stride: *s32, width: s32, height: s32) {
    ALIGNED_WIDTH := (width + ((cast(s32) 1) << 3 - 1)) & ~((cast(s32) 1) << 3 - 1);
    ALIGNED_HEIGHT := (height + ((cast(s32) 1) << 3 - 1)) & ~((cast(s32) 1) << 3 - 1);
    mi_cols.* = ALIGNED_WIDTH >> 3;
    mi_rows.* = ALIGNED_HEIGHT >> 3;
    mi_stride.* = calc_mi_size(mi_cols.*);
}

calc_mi_size :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

alloc_seg_map :: (cm: *VP9_COMMON, seg_map_size: s32) -> s32 {
    for i: 0..cast(s32) 2 - 1 {
        cm.seg_map_array[i] = cast(*u8) calloc_2(cast,no_check(u64) seg_map_size, 1);
        if cm.seg_map_array[i] == null {
            return 1;
        }
    }
    cm.seg_map_alloc_size = seg_map_size;

    cm.seg_map_idx = 0;
    cm.prev_seg_map_idx = 1;

    cm.current_frame_seg_map = cm.seg_map_array[cm.seg_map_idx];
    cm.last_frame_seg_map = cm.seg_map_array[cm.prev_seg_map_idx];

    return 0;
}

mi_cols_aligned_to_sb :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

vp9_init_context_buffers :: (cm: *VP9_COMMON) {
    cm.setup_mi(cm);
    if cm.last_frame_seg_map != null {
        fill_memory(cm.last_frame_seg_map, 0, cast,no_check(u64) (cm.mi_rows * cm.mi_cols));
    }
}

vp9_free_ref_frame_buffers :: (pool: *Buffer_Pool) {
    if pool == null {
        return;
    }

    for i: 0..cast(s32) ((cast(s32) 1) << 3 + 1 + 3) - 1 {
        if pool.frame_bufs[i].released == 0 && pool.frame_bufs[i].raw_frame_buffer.data != null {
            pool.release_fb_cb(pool.cb_priv, *pool.frame_bufs[i].raw_frame_buffer);
            pool.frame_bufs[i].ref_count = 0;
            pool.frame_bufs[i].released = 1;
        }
        deallocate_memory(cast(*void) pool.frame_bufs[i].mvs);
        pool.frame_bufs[i].mvs = null;
        free_frame_buffer(*pool.frame_bufs[i].buf);
    }
}

vp9_free_postproc_buffers :: (cm: *VP9_COMMON) {
}

vp9_swap_current_and_last_seg_map :: (cm: *VP9_COMMON) {
    TMP := cm.seg_map_idx;
    cm.seg_map_idx = cm.prev_seg_map_idx;
    cm.prev_seg_map_idx = TMP;

    cm.current_frame_seg_map = cm.seg_map_array[cm.seg_map_idx];
    cm.last_frame_seg_map = cm.seg_map_array[cm.prev_seg_map_idx];
}

clip_pixel_in_vp9_alloccommon :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_alloccommon :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_alloccommon :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_alloccommon :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_alloccommon :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_alloccommon(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_alloccommon(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_alloccommon(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_alloccommon :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_prob_in_vp9_alloccommon :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_alloccommon :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_alloccommon(n0, DEN);
}

weighted_prob_in_vp9_alloccommon :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_alloccommon :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_alloccommon(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_alloccommon(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_alloccommon :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_alloccommon[COUNT];
        PROB := get_prob_in_vp9_alloccommon(ct[0], DEN);
        return weighted_prob_in_vp9_alloccommon(
            cast,no_check(s32) pre_prob,
            cast,no_check(s32) PROB,
            cast,no_check(s32) FACTOR
        );
    }
}

get_lsb_in_vp9_alloccommon :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_alloccommon :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_alloccommon :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_alloccommon(num_values) + 1 else 0;
}

get_band_translate_in_vp9_alloccommon :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_alloccommon :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_alloccommon :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_alloccommon(above_ec, left_ec);
}

is_zero_mv_in_vp9_alloccommon :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_alloccommon :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_alloccommon :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_alloccommon(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_alloccommon(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_alloccommon :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_alloccommon :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_alloccommon :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_alloccommon :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

get_filter_taps_in_vp9_alloccommon :: (FILTER: *s16) -> s32 {
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

vp9_is_valid_scale_in_vp9_alloccommon :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_alloccommon :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_alloccommon(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_alloccommon :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_alloccommon :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_alloccommon :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_alloccommon :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_alloccommon :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_alloccommon :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_alloccommon :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_alloccommon :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_alloccommon :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_alloccommon :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_alloccommon :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_alloccommon(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_alloccommon :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_alloccommon(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_alloccommon(MI, ib)];
}

get_uv_tx_size_in_vp9_alloccommon :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_alloccommon :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_alloccommon :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_alloccommon(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_alloccommon :: (
    mi: *MODE_INFO,
    above_mi: *MODE_INFO,
    left_mi: *MODE_INFO,
    block: s32
) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_alloccommon :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_alloccommon :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

frame_is_intra_only :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb(cm.mi_cols);

        if get_plane_type_in_vp9_alloccommon(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs(cm, xd);
}

get_partition_probs :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

set_mi_row_col :: (
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

update_partition_context :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, subsize: BLOCK_SIZE, bsize: BLOCK_SIZE) {
    ABOVE_CTX := xd.above_seg_context + mi_col;
    LEFT_CTX := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);

    BS := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize];

    fill_memory(ABOVE_CTX, cast,no_check(s32) PARTITION_CONTEXT_LOOKUP[subsize].above, cast,no_check(u64) BS);
    fill_memory(LEFT_CTX, cast,no_check(s32) PARTITION_CONTEXT_LOOKUP[subsize].left, cast,no_check(u64) BS);
}

partition_plane_context :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

globals_initialization_state_for_vp9_alloccommon: u32;
initialize_globals_for_vp9_alloccommon :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_alloccommon);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_alloccommon, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_alloccommon) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_vp9_alloccommon =
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
    SUB_PEL_FILTERS_12 =
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
    atomic_store(*globals_initialization_state_for_vp9_alloccommon, 2);
}

Interp_Kernel12 :: [12] s16;

VP9_Common_in_vp9_onyxc_int :: struct {
    error: Internal_Error_Info #align 16;
    color_space: Color_Space_T #align 1;
    color_range: Color_Range_T #align 1;
    width: s32 #align 1;
    height: s32 #align 1;
    render_width: s32 #align 1;
    render_height: s32 #align 1;
    last_width: s32 #align 1;
    last_height: s32 #align 1;
    subsampling_x: s32 #align 1;
    subsampling_y: s32 #align 1;
    frame_to_show: *YV12_BUFFER_CONFIG #align 1;
    prev_frame: *Ref_Cnt_Buffer #align 1;
    cur_frame: *Ref_Cnt_Buffer #align 1;
    ref_frame_map: [8] s32 #align 1;
    next_ref_frame_map: [8] s32 #align 1;
    frame_refs: [3] Ref_Buffer #align 1;
    new_fb_idx: s32 #align 1;
    cur_show_frame_fb_idx: s32 #align 1;
    last_frame_type: FRAME_TYPE #align 1;
    frame_type: FRAME_TYPE #align 1;
    show_frame: s32 #align 1;
    last_show_frame: s32 #align 1;
    show_existing_frame: s32 #align 1;
    intra_only: u8 #align 1;
    last_intra_only: u8 #align 1;
    layout_padding_0: [2] u8 #align 1;
    allow_high_precision_mv: s32 #align 1;
    reset_frame_context: s32 #align 1;
    m_bs: s32 #align 1;
    mb_rows: s32 #align 1;
    mi_rows: s32 #align 1;
    mb_cols: s32 #align 1;
    mi_cols: s32 #align 1;
    mi_stride: s32 #align 1;
    tx_mode: TX_MODE #align 1;
    base_qindex: s32 #align 1;
    y_dc_delta_q: s32 #align 1;
    uv_dc_delta_q: s32 #align 1;
    uv_ac_delta_q: s32 #align 1;
    y_dequant: [8] [2] s16 #align 1;
    uv_dequant: [8] [2] s16 #align 1;
    mi_alloc_size: s32 #align 1;
    mip: *MODE_INFO #align 1;
    mi: *MODE_INFO #align 1;
    prev_mip: *MODE_INFO #align 1;
    prev_mi: *MODE_INFO #align 1;
    alloc_mi: #type (_: *VP9_Common_in_vp9_onyxc_int, _: s32) -> s32;
    free_mi: #type (_: *VP9_Common_in_vp9_onyxc_int);
    setup_mi: #type (_: *VP9_Common_in_vp9_onyxc_int);
    mi_grid_base: **MODE_INFO #align 1;
    mi_grid_visible: **MODE_INFO #align 1;
    prev_mi_grid_base: **MODE_INFO #align 1;
    prev_mi_grid_visible: **MODE_INFO #align 1;
    use_prev_frame_mvs: s32 #align 1;
    seg_map_idx: s32 #align 1;
    prev_seg_map_idx: s32 #align 1;
    layout_padding_1: [4] u8 #align 1;
    seg_map_array: [2] *u8 #align 1;
    last_frame_seg_map: *u8 #align 1;
    current_frame_seg_map: *u8 #align 1;
    seg_map_alloc_size: s32 #align 1;
    interp_filter: INTERP_FILTER #align 1;
    layout_padding_2: [3] u8 #align 1;
    lf_info: Loop_Filter_Info_N_in_vp9_alloccommon #align 1;
    refresh_frame_context: s32 #align 1;
    ref_frame_sign_bias: [4] s32 #align 1;
    layout_padding_3: [4] u8 #align 1;
    lf: Loopfilter #align 1;
    seg: Segmentation #align 1;
    comp_fixed_ref: MV_REFERENCE_FRAME #align 1;
    comp_var_ref: [2] MV_REFERENCE_FRAME #align 1;
    layout_padding_4: [1] u8 #align 1;
    reference_mode: REFERENCE_MODE #align 1;
    layout_padding_5: [4] u8 #align 1;
    fc: *FRAME_CONTEXT #align 1;
    frame_contexts: *FRAME_CONTEXT #align 1;
    frame_context_idx: u32 #align 1;
    counts: FRAME_COUNTS #align 1;
    current_video_frame: u32 #align 1;
    current_frame_coding_index: s32 #align 1;
    profile: BITSTREAM_PROFILE #align 1;
    bit_depth: Bit_Depth_T #align 1;
    dequant_bit_depth: Bit_Depth_T #align 1;
    error_resilient_mode: s32 #align 1;
    frame_parallel_decoding_mode: s32 #align 1;
    log2_tile_cols: s32 #align 1;
    log2_tile_rows: s32 #align 1;
    byte_alignment: s32 #align 1;
    skip_loop_filter: s32 #align 1;
    buffer_pool: *Buffer_Pool #align 1;
    above_seg_context: *PARTITION_CONTEXT #align 1;
    above_context: *ENTROPY_CONTEXT #align 1;
    above_context_alloc_cols: s32 #align 1;
    lf_row: s32 #align 1;
} #no_padding;

VP9_COMMON :: VP9_Common_in_vp9_onyxc_int;

Buffer_Pool :: struct {
    cb_priv: *void;
    get_fb_cb: Get_Frame_Buffer_Cb_Fn_T;
    release_fb_cb: Release_Frame_Buffer_Cb_Fn_T;
    frame_bufs: [12] Ref_Cnt_Buffer;
    int_frame_buffers: Internal_Frame_Buffer_List;
}

Loopfilter :: struct {
    filter_level: s32;
    last_filt_level: s32;
    sharpness_level: s32;
    last_sharpness_level: s32;
    mode_ref_delta_enabled: u8;
    mode_ref_delta_update: u8;
    ref_deltas: [4] s8;
    last_ref_deltas: [4] s8;
    mode_deltas: [2] s8;
    last_mode_deltas: [2] s8;
    lfm: *LOOP_FILTER_MASK;
    lfm_stride: s32;
}

FRAME_TYPE :: u32;
KEY_FRAME : s32 : 0;
INTER_FRAME : s32 : 1;
FRAME_TYPES : s32 : 2;

Partition_Context_Lookup_Entry :: struct {
    above: PARTITION_CONTEXT;
    left: PARTITION_CONTEXT;
}

LOOP_FILTER_MASK :: struct {
    left_y: [4] u64;
    above_y: [4] u64;
    int_4x4_y: u64;
    left_uv: [4] u16;
    above_uv: [4] u16;
    int_4x4_uv: u16;
    lfl_y: [64] u8;
}

MV_REF :: struct {
    mv: [2] Int_Mv #align 4;
    ref_frame: [2] MV_REFERENCE_FRAME #align 1;
    layout_padding_0: [2] u8 #align 1;
} #no_padding;

FRAME_INFO :: struct {
    frame_width: s32;
    frame_height: s32;
    render_frame_width: s32;
    render_frame_height: s32;
    mi_rows: s32;
    mi_cols: s32;
    mb_rows: s32;
    mb_cols: s32;
    num_mbs: s32;
    bit_depth: Bit_Depth_T;
}

Ref_Cnt_Buffer :: struct {
    ref_count: s32;
    mvs: *MV_REF;
    mi_rows: s32;
    mi_cols: s32;
    released: u8;
    frame_index: s32;
    frame_coding_index: s32;
    raw_frame_buffer: Codec_Frame_Buffer_T;
    buf: YV12_BUFFER_CONFIG;
}

TX_MODE :: u32;
ONLY_4X4 : s32 : 0;
ALLOW_8X8 : s32 : 1;
ALLOW_16X16 : s32 : 2;
ALLOW_32X32 : s32 : 3;
TX_MODE_SELECT : s32 : 4;
TX_MODES : s32 : 5;

Loop_Filter_Info_N_in_vp9_alloccommon :: struct {
    lfthr: [64] Loop_Filter_Thresh #align 16;
    lvl: [8] [4] [2] u8 #align 1;
} #no_padding;

REFERENCE_MODE :: u32;
SINGLE_REFERENCE : s32 : 0;
COMPOUND_REFERENCE : s32 : 1;
REFERENCE_MODE_SELECT : s32 : 2;
REFERENCE_MODES : s32 : 3;

BITSTREAM_PROFILE :: u32;
PROFILE_0 : s32 : 0;
PROFILE_1 : s32 : 1;
PROFILE_2 : s32 : 2;
PROFILE_3 : s32 : 3;
MAX_PROFILES : s32 : 4;

Internal_Frame_Buffer_List :: struct {
    num_internal_frame_buffers: s32;
    int_fb: *Internal_Frame_Buffer;
}

Loop_Filter_Thresh :: struct {
    mblim: [16] u8 #align 16;
    lim: [16] u8 #align 1;
    hev_thr: [16] u8 #align 1;
} #no_padding;

Internal_Frame_Buffer :: struct {
    data: *u8;
    size: u64;
    in_use: s32;
}

