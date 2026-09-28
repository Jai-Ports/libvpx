SUB_PEL_FILTERS_12_in_vp9_decoder: [16] Interp_Kernel12 #align 256;

lock_in_vp9_decoder: Pthread_Once_T;

COUNT_TO_UPDATE_FACTOR_in_vp9_decoder: [21] s32;

init_done_storage: s32;

clip_pixel_in_vp9_decoder :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_decoder :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_decoder :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_decoder :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_decoder :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_decoder(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_decoder(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_decoder(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_decoder :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_lsb_in_vp9_decoder :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_decoder :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_decoder :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_decoder(num_values) + 1 else 0;
}

get_filter_taps_in_vp9_decoder :: (FILTER: *s16) -> s32 {
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

once_in_vp9_decoder :: (func: Once_In_Vp9_Decoder_Parameter_0_Type) {
    pthread_once(*lock_in_vp9_decoder, cast,no_check(#type () #c_call) (func));
}

usec_timer_start_in_vp9_decoder :: (t: *Usec_Timer) {
    clock_gettime(4, *t.begin);
}

usec_timer_mark_in_vp9_decoder :: (t: *Usec_Timer) {
    clock_gettime(4, *t.end);
}

usec_timer_elapsed_in_vp9_decoder :: (t: *Usec_Timer) -> s64 {
    diff: C_Transpiler_POSIX.timespec = ---;

    assignment_0: Time_T = (t.end.tv_sec - t.begin.tv_sec);
    (diff.tv_sec) = assignment_0;

    assignment_1: Syscall_Slong_T = (t.end.tv_nsec - t.begin.tv_nsec);
    (diff.tv_nsec) = assignment_1;

    if diff.tv_nsec < 0 {
        diff.tv_sec -= 1;

        c_transpiler_compound_add(*(diff.tv_nsec), (cast(Syscall_Slong_T) 1000000000), Syscall_Slong_T, Syscall_Slong_T);
    }
    return (diff.tv_sec * 1000000) + diff.tv_nsec / 1000;
}

get_prob_in_vp9_decoder :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_decoder :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_decoder(n0, DEN);
}

weighted_prob_in_vp9_decoder :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_decoder :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_decoder(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_decoder(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_decoder :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_decoder[COUNT];
        PROB := get_prob_in_vp9_decoder(ct[0], DEN);
        return weighted_prob_in_vp9_decoder(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_band_translate_in_vp9_decoder :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_decoder :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_decoder :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_decoder(above_ec, left_ec);
}

is_zero_mv_in_vp9_decoder :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_decoder :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_decoder :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_decoder(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_decoder(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_decoder :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_decoder :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_decoder :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_decoder :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

vp9_is_valid_scale_in_vp9_decoder :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_decoder :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_decoder(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_decoder :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_decoder :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_decoder :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_decoder :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_decoder :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_decoder :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_decoder :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_decoder :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_decoder :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_decoder :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_decoder :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_decoder(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_decoder :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_decoder(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_decoder(MI, ib)];
}

get_uv_tx_size_in_vp9_decoder :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_decoder :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_decoder :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_decoder(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_decoder :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_decoder :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_decoder :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_decoder :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_decoder :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_decoder :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_decoder :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_decoder :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_decoder :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_decoder :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_decoder :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_decoder :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_decoder :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_decoder(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_decoder :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_decoder(cm.mi_cols);

        if get_plane_type_in_vp9_decoder(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_decoder(cm, xd);
}

get_partition_probs_in_vp9_decoder :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_decoder :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_decoder :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_decoder :: (
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

update_partition_context_in_vp9_decoder :: (
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

partition_plane_context_in_vp9_decoder :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

vp8_set_reference_value_in_vp9_decoder :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_vp9_decoder :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_vp9_decoder :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_vp9_decoder :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_d_get_last_ref_updates_value_in_vp9_decoder :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_d_get_frame_corrupted_value_in_vp9_decoder :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_d_get_last_ref_used_value_in_vp9_decoder :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

d_set_decryptor_value_in_vp9_decoder :: (args: *Va_List_Tag) -> *Decrypt_Init {
    return c_transpiler_va_arg(cast(*void) (args), *Decrypt_Init);
}

vp8_d_set_decryptor_value_in_vp9_decoder :: (args: *Va_List_Tag) -> *Decrypt_Init {
    return c_transpiler_va_arg(cast(*void) (args), *Decrypt_Init);
}

vp9_d_get_frame_size_value_in_vp9_decoder :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_d_get_display_size_value_in_vp9_decoder :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_d_get_bit_depth_value_in_vp9_decoder :: (args: *Va_List_Tag) -> *u32 {
    return c_transpiler_va_arg(cast(*void) (args), *u32);
}

vp9_set_byte_alignment_value_in_vp9_decoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_invert_tile_decode_order_value_in_vp9_decoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_set_skip_loop_filter_value_in_vp9_decoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_decode_svc_spatial_layer_value_in_vp9_decoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

d_get_last_quantizer_value_in_vp9_decoder :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_d_set_row_mt_value_in_vp9_decoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_d_set_loop_filter_opt_value_in_vp9_decoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

reader_has_error_in_vp9_decoder :: (r: *Reader) -> s32 {
    if r.count > (cast,no_check(s32) (cast(u64) size_of(BD_VALUE))) * 8 && r.count < 0x40000000 {
        return 1;
    }
    return 0;
}

read_in_vp9_decoder :: (r: *Reader, prob: s32) -> s32 {
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

read_bit_in_vp9_decoder :: (r: *Reader) -> s32 {
    return read_in_vp9_decoder(r, 128);
}

read_literal_in_vp9_decoder :: (r: *Reader, bits: s32) -> s32 {
    literal: s32 = 0;

    bit := bits - 1;
    while bit >= 0 {
        literal |= read_bit_in_vp9_decoder(r) << ((bit) & 31);
        bit -= 1;
    }

    return literal;
}

read_tree_in_vp9_decoder :: (r: *Reader, tree: *Tree_Index, probs: *Prob) -> s32 {
    i: Tree_Index = 0;

    while (ifx true { assignment_3: Tree_Index = cast,no_check(Tree_Index) (tree[(cast(s32) i) + read_in_vp9_decoder(r, cast,no_check(s32) probs[(cast(s32) i) >> 1])]); (i) = assignment_3; assignment_3; }) > 0 {
        continue;
    }

    return -(cast,no_check(s32) i);
}

vp9_receive_compressed_data :: (pbi: *VP9_Decoder, size: u64, psource: **u8) -> s32 {
    CM := *pbi.common;
    POOL := CM.buffer_pool;
    FRAME_BUFS := CM.buffer_pool.frame_bufs.data;
    source := psource.*;
    retcode: s32 = 0;
    CM.error.error_code = cast,no_check(Codec_Err_T) CODEC_OK;

    if size == 0 {
        if CM.frame_refs[0].idx > 0 {
            CM.frame_refs[0].buf.corrupted = 1;
        }
    }

    pbi.ready_for_new_data = 0;

    if CM.new_fb_idx >= 0 && (FRAME_BUFS[CM.new_fb_idx]).ref_count == 0 && (FRAME_BUFS[CM.new_fb_idx]).released == 0 {
        POOL.release_fb_cb(POOL.cb_priv, *((FRAME_BUFS[CM.new_fb_idx]).raw_frame_buffer));
        (FRAME_BUFS[CM.new_fb_idx]).released = 1;
    }

    CM.new_fb_idx = get_free_fb_in_vp9_decoder(CM);
    if CM.new_fb_idx == -1 {
        pbi.ready_for_new_data = 1;
        release_fb_on_decoder_exit(pbi);

        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Unable to find free frame buffer")
        );
        return cast,no_check(s32) CM.error.error_code;
    }

    CM.cur_frame = POOL.frame_bufs.data + CM.new_fb_idx;

    pbi.hold_ref_buf = 0;
    pbi.cur_buf = *FRAME_BUFS[CM.new_fb_idx];

    if setjmp_2(CM.error.jmp.data) != 0 {
        CM.error.setjmp = 0;
        pbi.ready_for_new_data = 1;
        release_fb_on_decoder_exit(pbi);

        decrease_ref_count_in_vp9_decoder(CM.new_fb_idx, FRAME_BUFS, POOL);

        return -1;
    }

    CM.error.setjmp = 1;
    vp9_decode_frame(pbi, source, source + size, psource);

    swap_frame_buffers_in_vp9_decoder(pbi);

    if CM.show_existing_frame == 0 {
        CM.last_show_frame = CM.show_frame;
        CM.prev_frame = CM.cur_frame;
        if CM.seg.enabled != 0 {
            vp9_swap_current_and_last_seg_map(CM);
        }
    }

    if CM.show_frame != 0 {
        CM.cur_show_frame_fb_idx = CM.new_fb_idx;
    }

    CM.last_width = CM.width;
    CM.last_height = CM.height;
    if CM.show_frame != 0 {
        CM.current_video_frame += 1;
    }

    CM.error.setjmp = 0;
    return retcode;
}

swap_frame_buffers_in_vp9_decoder :: (pbi: *VP9_Decoder) {
    ref_index: s32 = 0;
    CM := *pbi.common;
    POOL := CM.buffer_pool;
    FRAME_BUFS := CM.buffer_pool.frame_bufs.data;

    mask := pbi.refresh_frame_flags;
    while mask != 0 {
        OLD_IDX := CM.ref_frame_map[ref_index];

        decrease_ref_count_in_vp9_decoder(OLD_IDX, FRAME_BUFS, POOL);

        if mask & 1 != 0 {
            decrease_ref_count_in_vp9_decoder(OLD_IDX, FRAME_BUFS, POOL);
        }
        CM.ref_frame_map[ref_index] = CM.next_ref_frame_map[ref_index];
        ref_index += 1;
        c_transpiler_compound_shr(*(mask), (cast(s32) 1), s32, s32);
    }

    while ref_index < (cast(s32) 1) << 3 && CM.show_existing_frame == 0 {
        OLD_IDX := CM.ref_frame_map[ref_index];
        decrease_ref_count_in_vp9_decoder(OLD_IDX, FRAME_BUFS, POOL);
        CM.ref_frame_map[ref_index] = CM.next_ref_frame_map[ref_index];
        ref_index += 1;
    }
    pbi.hold_ref_buf = 0;
    CM.frame_to_show = get_frame_new_buffer_in_vp9_decoder(CM);

    FRAME_BUFS[CM.new_fb_idx].ref_count -= 1;

    ref_index = 0;
    while ref_index < 3 {
        CM.frame_refs[ref_index].idx = -1;
        ref_index += 1;
    }
}

decrease_ref_count_in_vp9_decoder :: (idx: s32, FRAME_BUFS: *Ref_Cnt_Buffer, POOL: *Buffer_Pool) {
    if idx >= 0 && FRAME_BUFS[idx].ref_count > 0 {
        FRAME_BUFS[idx].ref_count -= 1;

        if FRAME_BUFS[idx].released == 0 && FRAME_BUFS[idx].ref_count == 0 && FRAME_BUFS[idx].raw_frame_buffer.priv != null {
            POOL.release_fb_cb(POOL.cb_priv, *FRAME_BUFS[idx].raw_frame_buffer);
            FRAME_BUFS[idx].released = 1;
        }
    }
}

release_fb_on_decoder_exit :: (pbi: *VP9_Decoder) {
    WINTERFACE := get_worker_interface();
    CM := *pbi.common;
    POOL := CM.buffer_pool;
    FRAME_BUFS := CM.buffer_pool.frame_bufs.data;

    WINTERFACE.sync(*pbi.lf_worker);
    i: s32 = 0;
    while i < pbi.num_tile_workers {
        WINTERFACE.sync(*(cast(*Worker) (pbi.tile_workers))[i]);
        i += 1;
    }

    if pbi.hold_ref_buf == 1 {
        ref_index: s32 = 0;
        mask := pbi.refresh_frame_flags;
        while mask != 0 {
            OLD_IDX := CM.ref_frame_map[ref_index];

            decrease_ref_count_in_vp9_decoder(OLD_IDX, FRAME_BUFS, POOL);

            if mask & 1 != 0 {
                decrease_ref_count_in_vp9_decoder(OLD_IDX, FRAME_BUFS, POOL);
            }
            ref_index += 1;
            c_transpiler_compound_shr(*(mask), (cast(s32) 1), s32, s32);
        }

        while ref_index < (cast(s32) 1) << 3 && CM.show_existing_frame == 0 {
            OLD_IDX := CM.ref_frame_map[ref_index];
            decrease_ref_count_in_vp9_decoder(OLD_IDX, FRAME_BUFS, POOL);
            ref_index += 1;
        }
        pbi.hold_ref_buf = 0;
    }
}

vp9_get_raw_frame :: (pbi: *VP9_Decoder, sd: *YV12_BUFFER_CONFIG, flags: *Vp9_Ppflags_T) -> s32 {
    CM := *pbi.common;
    ret: s32 = -1;

    if pbi.ready_for_new_data == 1 {
        return ret;
    }

    pbi.ready_for_new_data = 1;

    if CM.show_frame == 0 {
        return ret;
    }

    pbi.ready_for_new_data = 1;

    sd.* = CM.frame_to_show.*;
    ret = 0;

    return ret;
}

vp9_copy_reference_dec :: (pbi: *VP9_Decoder, ref_frame_flag: VP9_REFFRAME, sd: *YV12_BUFFER_CONFIG) -> Codec_Err_T {
    cm := *pbi.common;

    if ref_frame_flag == cast,no_check(u32) VP9_LAST_FLAG {
        CFG := get_ref_frame_in_vp9_decoder(cm, 0);
        if CFG == null {
            internal_error(*cm.error, cast,no_check(Codec_Err_T) CODEC_ERROR, c_string("No 'last' reference frame"));
            return cast,no_check(Codec_Err_T) CODEC_ERROR;
        }
        if equal_dimensions(CFG, sd) == 0 {
            internal_error(*cm.error, cast,no_check(Codec_Err_T) CODEC_ERROR, c_string("Incorrect buffer dimensions"));
        } else {
            yv12_copy_frame_c(CFG, sd);
        }
    } else {
        internal_error(*cm.error, cast,no_check(Codec_Err_T) CODEC_ERROR, c_string("Invalid reference frame"));
    }

    return cm.error.error_code;
}

equal_dimensions :: (a: *YV12_BUFFER_CONFIG, b: *YV12_BUFFER_CONFIG) -> s32 {
    if a.y_height == b.y_height && a.y_width == b.y_width && a.uv_height == b.uv_height && a.uv_width == b.uv_width {
        return 1;
    }
    return 0;
}

vp9_set_reference_dec :: (cm: *VP9_COMMON, ref_frame_flag: VP9_REFFRAME, sd: *YV12_BUFFER_CONFIG) -> Codec_Err_T {
    idx: s32 = ---;
    ref_buf: *YV12_BUFFER_CONFIG = null;

    if ref_frame_flag == cast,no_check(u32) VP9_LAST_FLAG {
        idx = cm.ref_frame_map[0];
    } else if ref_frame_flag == cast,no_check(u32) VP9_GOLD_FLAG {
        idx = cm.ref_frame_map[1];
    } else if ref_frame_flag == cast,no_check(u32) VP9_ALT_FLAG {
        idx = cm.ref_frame_map[2];
    } else {
        internal_error(*cm.error, cast,no_check(Codec_Err_T) CODEC_ERROR, c_string("Invalid reference frame"));
        return cm.error.error_code;
    }

    if idx < 0 || idx >= (cast(s32) 1) << 3 + 1 + 3 {
        internal_error(*cm.error, cast,no_check(Codec_Err_T) CODEC_ERROR, c_string("Invalid reference frame map"));
        return cm.error.error_code;
    }

    ref_buf = *cm.buffer_pool.frame_bufs[idx].buf;

    if equal_dimensions(ref_buf, sd) == 0 {
        internal_error(*cm.error, cast,no_check(Codec_Err_T) CODEC_ERROR, c_string("Incorrect buffer dimensions"));
    } else {
        yv12_copy_frame_c(sd, ref_buf);
    }

    return cm.error.error_code;
}

read_marker_in_vp9_decoder :: (decrypt_cb: Decrypt_Cb, decrypt_state: *void, data: *u8) -> u8 {
    if decrypt_cb != null {
        marker: u8 = ---;
        decrypt_cb(decrypt_state, data, *marker, 1);
        return marker;
    }
    return data.*;
}

vp9_parse_superframe_index :: (
    data: *u8,
    data_sz: u64,
    sizes: *u32,
    count: *s32,
    decrypt_cb: Decrypt_Cb,
    decrypt_state: *void
) -> Codec_Err_T {
    marker := read_marker_in_vp9_decoder(cast,no_check(Decrypt_Cb) (decrypt_cb), decrypt_state, data + data_sz - 1);
    count.* = 0;

    if (cast(s32) marker) & 0xe0 == 0xc0 {
        FRAMES := cast,no_check(u32) ((cast(s32) marker) & 0x7 + 1);
        MAG := cast,no_check(u32) ((cast(s32) marker) >> 3 & 0x3 + 1);
        INDEX_SZ := cast,no_check(u64) (2 + MAG * FRAMES);

        if data_sz < INDEX_SZ {
            return cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME;
        }

        {
            MARKER2 :=
                read_marker_in_vp9_decoder(
                    cast,no_check(Decrypt_Cb) (decrypt_cb),
                    decrypt_state,
                    data + data_sz - INDEX_SZ
                );

            if marker != MARKER2 {
                return cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME;
            }
        }

        {
            j: u32 = ---;
            x := *data[data_sz - INDEX_SZ + 1];

            clear_buffer: [32] u8 = ---;

            if decrypt_cb != null {
                decrypt_cb(decrypt_state, x, clear_buffer.data, cast,no_check(s32) (FRAMES * MAG));
                x = clear_buffer.data;
            }

            if 0 < FRAMES {
                for i: 0..FRAMES - 1 {
                    this_sz: u32 = 0;

                    j = 0;
                    while j < MAG {
                        this_sz |= (cast,no_check(u32) ((c_transpiler_post_increment(*(x))).*)) << (((j * 8)) & 31);
                        j += 1;
                    }
                    sizes[i] = this_sz;
                }
            }
            count.* = cast,no_check(s32) FRAMES;
        }
    }
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

vp9_decoder_create :: (POOL: *Buffer_Pool) -> *VP9_Decoder {
    PBI := cast(*VP9_Decoder) memalign(32, size_of(VP9_Decoder));
    CM: *VP9_COMMON = (ifx PBI != null then *PBI.common else null);

    if CM == null {
        return null;
    }

    fill_memory(PBI, 0, size_of(VP9_Decoder));

    if setjmp_2(CM.error.jmp.data) != 0 {
        CM.error.setjmp = 0;
        vp9_decoder_remove(PBI);
        return null;
    }

    CM.error.setjmp = 1;

    CM.fc = cast(*FRAME_CONTEXT) calloc_2(1, size_of(FRAME_CONTEXT));

    if CM.fc == null {
        internal_error(*CM.error, cast,no_check(Codec_Err_T) CODEC_MEM_ERROR, c_string("Failed to allocate cm->fc"));
    }
    CM.frame_contexts =
        cast(*FRAME_CONTEXT) calloc_2(
            cast,no_check(u64) ((cast(s32) 1) << 2),
            size_of(FRAME_CONTEXT)
        );

    if CM.frame_contexts == null {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cm->frame_contexts")
        );
    }

    PBI.need_resync = 1;
    once_in_vp9_decoder(cast,no_check(#type () #c_call) initialize_dec_in_vp9_decoder);

    fill_memory(*CM.ref_frame_map, -1, CM.ref_frame_map.count * size_of(s32));
    fill_memory(*CM.next_ref_frame_map, -1, CM.next_ref_frame_map.count * size_of(s32));

    init_frame_indexes_in_vp9_decoder(CM);
    PBI.ready_for_new_data = 1;
    PBI.common.buffer_pool = POOL;

    CM.bit_depth = cast,no_check(Bit_Depth_T) BITS_8;
    CM.dequant_bit_depth = cast,no_check(Bit_Depth_T) BITS_8;

    CM.alloc_mi = vp9_dec_alloc_mi;
    CM.free_mi = vp9_dec_free_mi;
    CM.setup_mi = vp9_dec_setup_mi;

    vp9_loop_filter_init(CM);

    CM.error.setjmp = 0;

    (get_worker_interface()).init(*PBI.lf_worker);
    PBI.lf_worker.thread_name = c_string("vpx lf worker");

    return PBI;
}

vp9_dec_setup_mi :: (cm: *VP9_COMMON) {
    cm.mi = cm.mip + cm.mi_stride + 1;
    cm.mi_grid_visible = cm.mi_grid_base + cm.mi_stride + 1;
    fill_memory(cm.mi_grid_base, 0, cast,no_check(u64) (cm.mi_stride * (cm.mi_rows + 1)) * size_of(*MODE_INFO));
}

vp9_dec_free_mi :: (cm: *VP9_COMMON) {
    deallocate_memory(cast(*void) cm.mip);
    cm.mip = null;
    deallocate_memory(cast(*void) cm.mi_grid_base);
    cm.mi_grid_base = null;
    cm.mi_alloc_size = 0;
}

vp9_dec_alloc_mi :: (cm: *VP9_COMMON, mi_size: s32) -> s32 {
    cm.mip = cast(*MODE_INFO) calloc_2(cast,no_check(u64) mi_size, size_of(MODE_INFO));
    if cm.mip == null {
        return 1;
    }
    cm.mi_alloc_size = mi_size;
    cm.mi_grid_base = cast(**MODE_INFO) calloc_2(cast,no_check(u64) mi_size, size_of(*MODE_INFO));
    if cm.mi_grid_base == null {
        return 1;
    }
    return 0;
}

initialize_dec_in_vp9_decoder :: () #c_call {
    push_context {

        if init_done_storage == 0 {
            vp9_rtcd();
            dsp_rtcd();
            scale_rtcd();
            vp9_init_intra_predictors();
            init_done_storage = 1;
        }
    }
}

vp9_decoder_remove :: (pbi: *VP9_Decoder) {
    if pbi == null {
        return;
    }

    (get_worker_interface()).end(*pbi.lf_worker);
    deallocate_memory(pbi.lf_worker.data1);

    i: s32 = 0;
    while i < pbi.num_tile_workers {
        WORKER := *(cast(*Worker) (pbi.tile_workers))[i];
        (get_worker_interface()).end(WORKER);
        i += 1;
    }

    deallocate_memory(cast(*void) pbi.tile_worker_data);
    deallocate_memory(cast(*void) pbi.tile_workers);

    if pbi.num_tile_workers > 0 {
        vp9_loop_filter_dealloc(*pbi.lf_row_sync);
    }

    if pbi.row_mt == 1 {
        vp9_dec_free_row_mt_mem(pbi.row_mt_worker_data);
        if pbi.row_mt_worker_data != null {
            (cast,no_check(#type (_: *Job_Queue_Row_Mt)) (cast(*void) vp9_jobq_deinit))(*pbi.row_mt_worker_data.jobq);
            deallocate_memory(cast(*void) pbi.row_mt_worker_data.jobq_buf);

            pthread_mutex_destroy(*pbi.row_mt_worker_data.recon_done_mutex);
        }
        deallocate_memory(cast(*void) pbi.row_mt_worker_data);
    }

    vp9_remove_common(*pbi.common);
    deallocate_memory(cast(*void) pbi);
}

vp9_dec_free_row_mt_mem :: (row_mt_worker_data: *Row_MT_Worker_Data) {
    if row_mt_worker_data != null {
        i: s32 = ---;
        if row_mt_worker_data.recon_sync_mutex != null {
            i = 0;
            while i < row_mt_worker_data.num_jobs {
                pthread_mutex_destroy(*(cast(*Pthread_Mutex_T) (row_mt_worker_data.recon_sync_mutex))[i]);
                i += 1;
            }
            deallocate_memory(cast(*void) row_mt_worker_data.recon_sync_mutex);
            row_mt_worker_data.recon_sync_mutex = null;
        }
        if row_mt_worker_data.recon_sync_cond != null {
            i = 0;
            while i < row_mt_worker_data.num_jobs {
                pthread_cond_destroy(*(cast(*Pthread_Cond_T) (row_mt_worker_data.recon_sync_cond))[i]);
                i += 1;
            }
            deallocate_memory(cast(*void) row_mt_worker_data.recon_sync_cond);
            row_mt_worker_data.recon_sync_cond = null;
        }

        for plane: 0..cast(s32) 3 - 1 {
            deallocate_memory(cast(*void) row_mt_worker_data.eob[plane]);
            row_mt_worker_data.eob[plane] = null;
            deallocate_memory(cast(*void) row_mt_worker_data.dqcoeff[plane]);
            row_mt_worker_data.dqcoeff[plane] = null;
        }
        deallocate_memory(cast(*void) row_mt_worker_data.partition);
        row_mt_worker_data.partition = null;
        deallocate_memory(cast(*void) row_mt_worker_data.recon_map);
        row_mt_worker_data.recon_map = null;
        deallocate_memory(cast(*void) row_mt_worker_data.thread_data);
        row_mt_worker_data.thread_data = null;
    }
}

vp9_dec_alloc_row_mt_mem :: (
    row_mt_worker_data: *Row_MT_Worker_Data,
    cm: *VP9_COMMON,
    num_sbs: s32,
    max_threads: s32,
    num_jobs: s32
) {
    if cast,no_check(u64) num_sbs > (cast(u64) 18446744073709551615) / (cast(u64) size_of(Tran_Low_T)) << 12 {
        internal_error(*cm.error, cast,no_check(Codec_Err_T) CODEC_ERROR, c_string("num_sbs too big"));
    }
    DQCOEFF_SIZE := (cast,no_check(u64) num_sbs) << 12 * size_of(Tran_Low_T);
    row_mt_worker_data.num_jobs = num_jobs;

    {
        row_mt_worker_data.recon_sync_mutex =
            cast(*Pthread_Mutex_T) allocate_memory(
                size_of(Pthread_Mutex_T) * cast,no_check(u64) num_jobs
            );

        if row_mt_worker_data.recon_sync_mutex == null {
            internal_error(
                *cm.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate row_mt_worker_data->recon_sync_mutex")
            );
        }
        if row_mt_worker_data.recon_sync_mutex != null {
            if 0 < num_jobs {
                for i: 0..num_jobs - 1 {
                    pthread_mutex_init(*(cast(*Pthread_Mutex_T) (row_mt_worker_data.recon_sync_mutex))[i], null);
                }
            }
        }

        row_mt_worker_data.recon_sync_cond =
            cast(*Pthread_Cond_T) allocate_memory(
                size_of(Pthread_Cond_T) * cast,no_check(u64) num_jobs
            );

        if row_mt_worker_data.recon_sync_cond == null {
            internal_error(
                *cm.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate row_mt_worker_data->recon_sync_cond")
            );
        }
        if row_mt_worker_data.recon_sync_cond != null {
            if 0 < num_jobs {
                for i: 0..num_jobs - 1 {
                    pthread_cond_init(*(cast(*Pthread_Cond_T) (row_mt_worker_data.recon_sync_cond))[i], null);
                }
            }
        }
    }

    row_mt_worker_data.num_sbs = num_sbs;
    for plane: 0..cast(s32) 3 - 1 {
        row_mt_worker_data.dqcoeff[plane] = cast(*Tran_Low_T) memalign(32, DQCOEFF_SIZE);

        if row_mt_worker_data.dqcoeff[plane] == null {
            internal_error(
                *cm.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate row_mt_worker_data->dqcoeff[plane]")
            );
        }
        fill_memory(row_mt_worker_data.dqcoeff[plane], 0, DQCOEFF_SIZE);
        row_mt_worker_data.eob[plane] =
            cast(*s32) calloc_2(
                (cast,no_check(u64) num_sbs) << 8,
                size_of(s32)
            );

        if row_mt_worker_data.eob[plane] == null {
            internal_error(
                *cm.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate row_mt_worker_data->eob[plane]")
            );
        }
    }
    row_mt_worker_data.partition =
        cast(*PARTITION_TYPE) calloc_2(
            (cast,no_check(u64) num_sbs) * 85,
            size_of(PARTITION_TYPE)
        );

    if row_mt_worker_data.partition == null {
        internal_error(
            *cm.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate row_mt_worker_data->partition")
        );
    }
    row_mt_worker_data.recon_map = cast(*s8) calloc_2(cast,no_check(u64) num_sbs, size_of(s8));

    if row_mt_worker_data.recon_map == null {
        internal_error(
            *cm.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate row_mt_worker_data->recon_map")
        );
    }

    if row_mt_worker_data.thread_data == null {
        THREAD_SIZE: u64 = (cast,no_check(u64) max_threads) * size_of(Thread_Data_in_vp9_decoder);
        row_mt_worker_data.thread_data = cast(*Thread_Data_in_vp9_decoder) memalign(32, THREAD_SIZE);

        if row_mt_worker_data.thread_data == null {
            internal_error(
                *cm.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate row_mt_worker_data->thread_data")
            );
        }
    }
}

get_coef_context_in_vp9_decoder :: (neighbors: *s16, token_cache: *u8, c: s32) -> s32 {
    return ((1 + cast(s32) token_cache[neighbors[2 * c + 0]]) + cast(s32) token_cache[neighbors[2 * c + 1]]) >> 1;
}

get_scan_in_vp9_decoder :: (
    xd: *MACROBLOCKD,
    tx_size: TX_SIZE,
    type: PLANE_TYPE,
    block_idx: s32
) -> *Scan_Order_in_vp9_scan {
    MI := xd.mi[0];

    if is_inter_block_in_vp9_decoder(MI) != 0 || type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 {
        return VP9_DEFAULT_SCAN_ORDERS.data + tx_size;
    } else {
        MODE_ := get_y_mode_in_vp9_decoder(MI, block_idx);
        return VP9_SCAN_ORDERS[tx_size].data + INTRA_MODE_TO_TX_TYPE_LOOKUP[MODE_];
    }
}

globals_initialization_state_for_vp9_decoder: u32;
initialize_globals_for_vp9_decoder :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_decoder);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_decoder, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_decoder) != 2 {}
            return;
        }
    }
    SUB_PEL_FILTERS_12_in_vp9_decoder =
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
    lock_in_vp9_decoder = 0;
    COUNT_TO_UPDATE_FACTOR_in_vp9_decoder =
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
    init_done_storage = 0;
    atomic_store(*globals_initialization_state_for_vp9_decoder, 2);
}


Once_In_Vp9_Decoder_Parameter_0_Type :: #type () #c_call;
