// Generated directly from C by cpp_transpiler.
SUB_PEL_FILTERS_12_in_vp9_encoder: [16] Interp_Kernel12 #align 256;

lock_in_vp9_encoder: Pthread_Once_T;

COUNT_TO_UPDATE_FACTOR_in_vp9_encoder: [21] s32;

COSPI_1_64_in_vp9_encoder: Tran_Coef_T;

COSPI_2_64_in_vp9_encoder: Tran_Coef_T;

COSPI_3_64_in_vp9_encoder: Tran_Coef_T;

COSPI_4_64_in_vp9_encoder: Tran_Coef_T;

COSPI_5_64_in_vp9_encoder: Tran_Coef_T;

COSPI_6_64_in_vp9_encoder: Tran_Coef_T;

COSPI_7_64_in_vp9_encoder: Tran_Coef_T;

COSPI_8_64_in_vp9_encoder: Tran_Coef_T;

COSPI_9_64_in_vp9_encoder: Tran_Coef_T;

COSPI_10_64_in_vp9_encoder: Tran_Coef_T;

COSPI_11_64_in_vp9_encoder: Tran_Coef_T;

COSPI_12_64_in_vp9_encoder: Tran_Coef_T;

COSPI_13_64_in_vp9_encoder: Tran_Coef_T;

COSPI_14_64_in_vp9_encoder: Tran_Coef_T;

COSPI_15_64_in_vp9_encoder: Tran_Coef_T;

COSPI_16_64_in_vp9_encoder: Tran_Coef_T;

COSPI_17_64_in_vp9_encoder: Tran_Coef_T;

COSPI_18_64_in_vp9_encoder: Tran_Coef_T;

COSPI_19_64_in_vp9_encoder: Tran_Coef_T;

COSPI_20_64_in_vp9_encoder: Tran_Coef_T;

COSPI_21_64_in_vp9_encoder: Tran_Coef_T;

COSPI_22_64_in_vp9_encoder: Tran_Coef_T;

COSPI_23_64_in_vp9_encoder: Tran_Coef_T;

COSPI_24_64_in_vp9_encoder: Tran_Coef_T;

COSPI_25_64_in_vp9_encoder: Tran_Coef_T;

COSPI_26_64_in_vp9_encoder: Tran_Coef_T;

COSPI_27_64_in_vp9_encoder: Tran_Coef_T;

COSPI_28_64_in_vp9_encoder: Tran_Coef_T;

COSPI_29_64_in_vp9_encoder: Tran_Coef_T;

COSPI_30_64_in_vp9_encoder: Tran_Coef_T;

COSPI_31_64_in_vp9_encoder: Tran_Coef_T;

SINPI_1_9_in_vp9_encoder: Tran_Coef_T;

SINPI_2_9_in_vp9_encoder: Tran_Coef_T;

SINPI_3_9_in_vp9_encoder: Tran_Coef_T;

SINPI_4_9_in_vp9_encoder: Tran_Coef_T;

FRAME_SCALE_FACTOR_in_vp9_encoder: [2] s32;

RATE_THRESH_MULT_in_vp9_encoder: [2] float64;

RCF_MULT_in_vp9_encoder: [2] float64;

VP9_LEVEL_DEFS: [14] Vp9_Level_Spec;

level_fail_messages: [9] *s8;

K_VP9_REF_FLAG_LIST_in_vp9_encoder: [4] s32;

clip_pixel_in_vp9_encoder :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_encoder :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_encoder :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_encoder :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_encoder :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_encoder(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_encoder(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_encoder(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_encoder :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_lsb_in_vp9_encoder :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_encoder :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_encoder :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_encoder(num_values) + 1 else 0;
}

get_filter_taps_in_vp9_encoder :: (FILTER: *s16) -> s32 {
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

once_in_vp9_encoder :: (func: Once_In_Vp9_Encoder_Parameter_0_Type) {
    pthread_once(*lock_in_vp9_encoder, cast,no_check(#type () #c_call) (func));
}

usec_timer_start_in_vp9_encoder :: (t: *Usec_Timer) {
    clock_gettime(4, *t.begin);
}

usec_timer_mark_in_vp9_encoder :: (t: *Usec_Timer) {
    clock_gettime(4, *t.end);
}

usec_timer_elapsed_in_vp9_encoder :: (t: *Usec_Timer) -> s64 {
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

get_prob_in_vp9_encoder :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_encoder :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_encoder(n0, DEN);
}

weighted_prob_in_vp9_encoder :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_encoder :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_encoder(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_encoder(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_encoder :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_encoder[COUNT];
        PROB := get_prob_in_vp9_encoder(ct[0], DEN);
        return weighted_prob_in_vp9_encoder(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_band_translate_in_vp9_encoder :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_encoder :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_encoder :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_encoder(above_ec, left_ec);
}

is_zero_mv_in_vp9_encoder :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_encoder :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_encoder :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_encoder(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_encoder(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_encoder :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_encoder :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_encoder :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_encoder :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

vp9_is_valid_scale_in_vp9_encoder :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_encoder :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_encoder(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_encoder :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_encoder :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_encoder :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_encoder :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_encoder :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_encoder :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_encoder :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_encoder :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_encoder :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_encoder :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_encoder :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_encoder(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_encoder :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_encoder(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_encoder(MI, ib)];
}

get_uv_tx_size_in_vp9_encoder :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_encoder :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_encoder :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_encoder(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_encoder :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

check_range_in_vp9_encoder :: (input: Tran_High_T) -> Tran_High_T {
    return input;
}

dct_const_round_shift_in_vp9_encoder :: (input: Tran_High_T) -> Tran_High_T {
    rv := (input + cast,no_check(Tran_High_T) (((cast(s32) 1) << (((14 - 1)) & 31)))) >> 14;
    return rv;
}

clip_pixel_add_in_vp9_encoder :: (dest: u8, trans: Tran_High_T) -> u8 {
    trans = check_range_in_vp9_encoder(trans);
    return clip_pixel_in_vp9_encoder((cast(s32) dest) + trans);
}

get_lfm_in_vp9_encoder :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_encoder :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_encoder :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_encoder :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_encoder :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_encoder :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_encoder :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_encoder :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_encoder :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_encoder :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_encoder :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_encoder :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_encoder(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_encoder :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_encoder(cm.mi_cols);

        if get_plane_type_in_vp9_encoder(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_encoder(cm, xd);
}

get_partition_probs_in_vp9_encoder :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_encoder :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_encoder :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_encoder :: (
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

update_partition_context_in_vp9_encoder :: (
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

partition_plane_context_in_vp9_encoder :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

inter_predictor_in_vp9_encoder :: (
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

scaled_buffer_offset_in_vp9_encoder :: (x_offset: s32, y_offset: s32, stride: s32, sf: *Scale_Factors) -> s64 {
    X := (ifx sf != null then sf.scale_value_x(x_offset, sf) else x_offset);
    Y := (ifx sf != null then sf.scale_value_y(y_offset, sf) else y_offset);
    return ((cast,no_check(s64) Y) * cast(s64) stride) + cast(s64) X;
}

setup_pred_plane_in_vp9_encoder :: (
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
    dst.buf = src + scaled_buffer_offset_in_vp9_encoder(X, Y, stride, scale);
    dst.stride = stride;
}

vp8_set_reference_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_vp9_encoder :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_vp9_encoder :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_vp9_encoder :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

gcd_in_vp9_encoder :: (a: s64, b: s32) -> s32 {
    while b != 0 {
        r := cast,no_check(s32) (a % cast(s64) b);
        a = cast,no_check(s64) b;
        b = r;
    }

    return cast,no_check(s32) a;
}

reduce_ratio_in_vp9_encoder :: (ratio: *Rational64_T) {
    DENOM := gcd_in_vp9_encoder(ratio.num, ratio.den);
    ratio.num /= cast,no_check(s64) DENOM;
    ratio.den /= DENOM;
}

cyclic_refresh_segment_id_boosted_in_vp9_encoder :: (segment_id: s32) -> s32 {
    if segment_id == 1 || segment_id == 2 {
        return 1;
    }
    return 0;
}

cyclic_refresh_segment_id_in_vp9_encoder :: (segment_id: s32) -> s32 {
    if segment_id == 1 {
        return 1;
    } else if segment_id == 2 {
        return 2;
    } else {
        return 0;
    }
}

fps_init_first_pass_info_in_vp9_encoder :: (
    first_pass_info: *FIRST_PASS_INFO,
    stats: *FIRSTPASS_STATS_in_vp9_cx_iface,
    num_frames: s32
) {
    first_pass_info.stats = stats;
    first_pass_info.num_frames = num_frames;
}

fps_get_num_frames_in_vp9_encoder :: (first_pass_info: *FIRST_PASS_INFO) -> s32 {
    return first_pass_info.num_frames;
}

fps_get_frame_stats_in_vp9_encoder :: (
    first_pass_info: *FIRST_PASS_INFO,
    show_idx: s32
) -> *FIRSTPASS_STATS_in_vp9_cx_iface {
    if show_idx < 0 || show_idx >= first_pass_info.num_frames {
        return null;
    }
    return *(cast(*FIRSTPASS_STATS_in_vp9_cx_iface) (first_pass_info.stats))[show_idx];
}

get_buf_from_mv_in_vp9_encoder :: (buf: *Buf_2d, mv: *MV) -> *u8 {
    return *buf.buf[(cast(s32) mv.row) * buf.stride + cast(s32) mv.col];
}

cost_branch256_in_vp9_encoder :: (ct: *u32, p: Prob) -> u64 {
    return ((cast,no_check(u64) ct[0]) * cast(u64) VP9_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP9_PROB_COST[256 - cast(s32) p];
}

treed_cost_in_vp9_encoder :: (tree: *Tree_Index, probs: *Prob, bits: s32, len: s32) -> s32 {
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

rd_less_than_thresh_in_vp9_encoder :: (best_rd: s64, thresh: s32, THRESH_FACT: *s32) -> s32 {
    if best_rd < ((cast,no_check(s64) thresh) * cast(s64) THRESH_FACT.*) >> 5 || thresh == 2147483647 {
        return 1;
    }
    return 0;
}

set_error_per_bit_in_vp9_encoder :: (x: *MACROBLOCK, rdmult: s32) {
    x.errorperbit = rdmult >> 6;
    x.errorperbit += cast(s32) (x.errorperbit == 0);
}

write_in_vp9_encoder :: (br: *Writer, bit: s32, probability: s32) {
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

write_bit_in_vp9_encoder :: (w: *Writer, bit: s32) {
    write_in_vp9_encoder(w, bit, 128);
}

write_literal_in_vp9_encoder :: (w: *Writer, data: s32, bits: s32) {
    bit := bits - 1;
    while bit >= 0 {
        write_bit_in_vp9_encoder(w, 1 & (data >> ((bit) & 31)));
        bit -= 1;
    }
}

vp9_write_tree_in_vp9_encoder :: (w: *Writer, tree: *Tree_Index, probs: *Prob, bits: s32, len: s32, i: Tree_Index) {
    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            write_in_vp9_encoder(w, BIT, cast,no_check(s32) probs[(cast(s32) i) >> 1]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }
}

vp9_write_token_in_vp9_encoder :: (w: *Writer, tree: *Tree_Index, probs: *Prob, token: *Vp9_Token) {
    vp9_write_tree_in_vp9_encoder(w, tree, probs, token.value, token.len, 0);
}

vp9_get_high_cost_table_in_vp9_encoder :: (bit_depth: s32) -> *u16 {
    return VP9_CAT6_HIGH_COST.data;
}

vp9_get_token_extra_in_vp9_encoder :: (v: s32, token: *s16, extra: *EXTRABIT) {
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

vp9_get_token_in_vp9_encoder :: (v: s32) -> s16 {
    if v >= 67 || v <= -67 {
        return 10;
    }
    return vp9_dct_cat_lt_10_value_tokens[v].token;
}

vp9_get_token_cost_in_vp9_encoder :: (v: s32, token: *s16, cat6_high_table: *u16) -> s32 {
    if v >= 67 || v <= -67 {
        token.* = 10;
        extrabits := cast,no_check(EXTRABIT) (absolute_value(v) - 67);
        return (cast(s32) VP9_CAT6_LOW_COST[extrabits & 0xff]) + cast(s32) cat6_high_table[(cast(s32) extrabits) >> 8];
    }
    token.* = vp9_dct_cat_lt_10_value_tokens[v].token;
    return vp9_dct_cat_lt_10_value_cost[v];
}

is_lossless_requested_in_vp9_encoder :: (cfg: *VP9_Encoder_Config) -> s32 {
    if cfg.best_allowed_q == 0 && cfg.worst_allowed_q == 0 {
        return 1;
    }
    return 0;
}

vp9_init_encode_frame_result :: (encode_frame_result: *ENCODE_FRAME_RESULT) {
    encode_frame_result.show_idx = -1;
}

vp9_initialize_enc :: () {
    once_in_vp9_encoder(cast,no_check(#type () #c_call) initialize_enc_in_vp9_encoder);
}

initialize_enc_in_vp9_encoder :: () #c_call {
    push_context {
        vp9_rtcd();
        dsp_rtcd();
        scale_rtcd();
        vp9_init_intra_predictors();
        vp9_init_me_luts();
        vp9_rc_init_minq_luts();
        vp9_entropy_mv_init();

        vp9_temporal_filter_init();
    }
}

vp9_create_compressor :: (oxcf: *VP9_Encoder_Config, POOL: *Buffer_Pool) -> *VP9_COMP_in_vp9_encoder {
    CPI :=
        cast(*VP9_COMP_in_vp9_encoder) memalign(
            32,
            size_of(VP9_COMP_in_vp9_encoder)
        );
    CM: *VP9_COMMON = (ifx CPI != null then *CPI.common else null);

    if CM == null {
        return null;
    }

    fill_memory(CPI, 0, size_of(VP9_COMP_in_vp9_encoder));

    if setjmp_2(CM.error.jmp.data) != 0 {
        CM.error.setjmp = 0;
        vp9_remove_compressor(CPI);
        return null;
    }

    CM.error.setjmp = 1;
    CM.alloc_mi = vp9_enc_alloc_mi;
    CM.free_mi = vp9_enc_free_mi;
    CM.setup_mi = vp9_enc_setup_mi;

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

    CPI.compute_frame_low_motion_onepass = 1;
    CPI.use_svc = 0;
    CPI.resize_state = cast,no_check(RESIZE_STATE) ORIG;
    CPI.external_resize = 0;
    CPI.resize_avg_qp = 0;
    CPI.resize_buffer_underflow = 0;
    CPI.use_skin_detection = 0;
    CPI.common.buffer_pool = POOL;
    init_ref_frame_bufs(CM);

    CPI.force_update_segmentation = 0;

    init_config_in_vp9_encoder(CPI, oxcf);
    vp9_get_frame_info(*CPI.frame_info, oxcf);

    (cast,no_check(#type (_: *VP9_Encoder_Config, _: s32, _: *RATE_CONTROL)) (cast(*void) vp9_rc_init))(
        *CPI.oxcf,
        oxcf.pass,
        *CPI.rc
    );
    vp9_init_rd_parameters(CPI);

    init_frame_indexes_in_vp9_encoder(CM);
    CPI.initial_width = CPI.oxcf.width;
    CPI.initial_height = CPI.oxcf.height;
    CPI.tile_data = null;

    realloc_segmentation_maps(CPI);

    CPI.skin_map = cast(*u8) calloc_2(cast,no_check(u64) (CM.mi_rows * CM.mi_cols), size_of(u8));

    if CPI.skin_map == null {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->skin_map")
        );
    }

    CPI.alt_ref_aq = vp9_alt_ref_aq_create();

    if CPI.alt_ref_aq == null {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->alt_ref_aq")
        );
    }

    CPI.consec_zero_mv = cast(*u8) calloc_2(cast,no_check(u64) (CM.mi_rows * CM.mi_cols), size_of(u8));

    if CPI.consec_zero_mv == null {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->consec_zero_mv")
        );
    }

    CPI.nmvcosts[0] =
        cast(*s32) calloc_2(
            cast,no_check(u64) (((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1) << 1 + 1),
            size_of(s32)
        );

    if CPI.nmvcosts[0] == null {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->nmvcosts[0]")
        );
    }
    CPI.nmvcosts[1] =
        cast(*s32) calloc_2(
            cast,no_check(u64) (((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1) << 1 + 1),
            size_of(s32)
        );

    if CPI.nmvcosts[1] == null {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->nmvcosts[1]")
        );
    }
    CPI.nmvcosts_hp[0] =
        cast(*s32) calloc_2(
            cast,no_check(u64) (((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1) << 1 + 1),
            size_of(s32)
        );

    if CPI.nmvcosts_hp[0] == null {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->nmvcosts_hp[0]")
        );
    }
    CPI.nmvcosts_hp[1] =
        cast(*s32) calloc_2(
            cast,no_check(u64) (((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1) << 1 + 1),
            size_of(s32)
        );

    if CPI.nmvcosts_hp[1] == null {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->nmvcosts_hp[1]")
        );
    }
    CPI.nmvsadcosts[0] =
        cast(*s32) calloc_2(
            cast,no_check(u64) (((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1) << 1 + 1),
            size_of(s32)
        );

    if CPI.nmvsadcosts[0] == null {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->nmvsadcosts[0]")
        );
    }
    CPI.nmvsadcosts[1] =
        cast(*s32) calloc_2(
            cast,no_check(u64) (((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1) << 1 + 1),
            size_of(s32)
        );

    if CPI.nmvsadcosts[1] == null {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->nmvsadcosts[1]")
        );
    }
    CPI.nmvsadcosts_hp[0] =
        cast(*s32) calloc_2(
            cast,no_check(u64) (((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1) << 1 + 1),
            size_of(s32)
        );

    if CPI.nmvsadcosts_hp[0] == null {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->nmvsadcosts_hp[0]")
        );
    }
    CPI.nmvsadcosts_hp[1] =
        cast(*s32) calloc_2(
            cast,no_check(u64) (((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1) << 1 + 1),
            size_of(s32)
        );

    if CPI.nmvsadcosts_hp[1] == null {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->nmvsadcosts_hp[1]")
        );
    }

    i: u32 = 0;
    while cast,no_check(u64) i < cast(u64) CPI.mbgraph_stats.count {
        CPI.mbgraph_stats[i].mb_stats =
            cast(*MBGRAPH_MB_STATS) calloc_2(
                (cast,no_check(u64) CM.m_bs) * size_of(MBGRAPH_MB_STATS),
                1
            );

        if CPI.mbgraph_stats[i].mb_stats == null {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate cpi->mbgraph_stats[i].mb_stats")
            );
        }
        i += 1;
    }

    CPI.refresh_alt_ref_frame = 0;
    CPI.b_calculate_psnr = 0;

    init_level_info(*CPI.level_info);
    init_level_constraint(*CPI.level_constraint);

    CPI.first_time_stamp_ever = 9223372036854775807;

    cal_nmvjointsadcost(CPI.td.mb.nmvjointsadcost.data);
    CPI.td.mb.nmvcost[0] = *CPI.nmvcosts[0][(cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1];
    CPI.td.mb.nmvcost[1] = *CPI.nmvcosts[1][(cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1];
    CPI.td.mb.nmvsadcost[0] = *CPI.nmvsadcosts[0][(cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1];
    CPI.td.mb.nmvsadcost[1] = *CPI.nmvsadcosts[1][(cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1];
    cal_nmvsadcosts(CPI.td.mb.nmvsadcost.data);

    CPI.td.mb.nmvcost_hp[0] = *CPI.nmvcosts_hp[0][(cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1];
    CPI.td.mb.nmvcost_hp[1] = *CPI.nmvcosts_hp[1][(cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1];
    CPI.td.mb.nmvsadcost_hp[0] =
        *CPI.nmvsadcosts_hp[0][(cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) -
            1];
    CPI.td.mb.nmvsadcost_hp[1] =
        *CPI.nmvsadcosts_hp[1][(cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) -
            1];
    cal_nmvsadcosts_hp(CPI.td.mb.nmvsadcost_hp.data);

    CPI.allow_encode_breakout = cast,no_check(ENCODE_BREAKOUT_TYPE) ENCODE_BREAKOUT_ENABLED;

    {
        codec_status :=
            (cast,no_check(#type (_: *EXT_RATECTRL) -> Codec_Err_T) (cast(*void) vp9_extrc_init))(
                *CPI.ext_ratectrl
            );
        if codec_status != cast,no_check(u32) CODEC_OK {
            internal_error(*CM.error, codec_status, c_string("vp9_extrc_init() failed"));
        }
    }

    if oxcf.pass == 1 {
        vp9_init_first_pass(CPI);
    } else if oxcf.pass == 2 {
        PACKET_SZ: u64 = cast(u64) size_of(FIRSTPASS_STATS_in_vp9_cx_iface);
        PACKETS := cast,no_check(s32) (oxcf.two_pass_stats_in.sz / PACKET_SZ);

        if CPI.svc.number_spatial_layers > 1 || CPI.svc.number_temporal_layers > 1 {
            STATS := cast(*FIRSTPASS_STATS_in_vp9_cx_iface) oxcf.two_pass_stats_in.buf;
            stats_copy: [5] *FIRSTPASS_STATS_in_vp9_cx_iface;

            n: s32 = 0;
            while n < oxcf.ss_number_layers {
                LAST_PACKET_FOR_LAYER := *STATS[PACKETS - oxcf.ss_number_layers + n];
                LAYER_ID := cast,no_check(s32) LAST_PACKET_FOR_LAYER.spatial_layer_id;
                PACKETS_IN_LAYER := (cast,no_check(s32) LAST_PACKET_FOR_LAYER.count) + 1;
                if LAYER_ID >= 0 && LAYER_ID < oxcf.ss_number_layers {
                    LC := CPI.svc.layer_context.data + LAYER_ID;

                    deallocate_memory(LC.rc_twopass_stats_in.buf);

                    LC.rc_twopass_stats_in.sz = (cast,no_check(u64) PACKETS_IN_LAYER) * PACKET_SZ;
                    LC.rc_twopass_stats_in.buf = allocate_memory(LC.rc_twopass_stats_in.sz);

                    if LC.rc_twopass_stats_in.buf == null {
                        internal_error(
                            *CM.error,
                            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                            c_string("Failed to allocate lc->rc_twopass_stats_in.buf")
                        );
                    }
                    LC.twopass.stats_in_start = cast(*FIRSTPASS_STATS_in_vp9_cx_iface) LC.rc_twopass_stats_in.buf;
                    LC.twopass.stats_in = LC.twopass.stats_in_start;
                    LC.twopass.stats_in_end = LC.twopass.stats_in_start + PACKETS_IN_LAYER - 1;

                    num_frames := PACKETS_IN_LAYER - 1;
                    fps_init_first_pass_info_in_vp9_encoder(
                        *LC.twopass.first_pass_info,
                        cast(*FIRSTPASS_STATS_in_vp9_cx_iface) LC.rc_twopass_stats_in.buf,
                        num_frames
                    );
                    stats_copy[LAYER_ID] = cast(*FIRSTPASS_STATS_in_vp9_cx_iface) LC.rc_twopass_stats_in.buf;
                }
                n += 1;
            }

            n = 0;
            while n < PACKETS {
                LAYER_ID := cast,no_check(s32) STATS[n].spatial_layer_id;
                if LAYER_ID >= 0 && LAYER_ID < oxcf.ss_number_layers && stats_copy[LAYER_ID] != null {
                    assignment_2: FIRSTPASS_STATS_in_vp9_cx_iface = STATS[n];
                    ((stats_copy[LAYER_ID]).*) = assignment_2;
                    stats_copy[LAYER_ID] += 1;
                }
                n += 1;
            }

            vp9_init_second_pass_spatial_svc(CPI);
        } else {
            CPI.twopass.stats_in_start = cast(*FIRSTPASS_STATS_in_vp9_cx_iface) oxcf.two_pass_stats_in.buf;
            CPI.twopass.stats_in = CPI.twopass.stats_in_start;
            CPI.twopass.stats_in_end = *(cast(*FIRSTPASS_STATS_in_vp9_cx_iface) (CPI.twopass.stats_in))[PACKETS - 1];

            num_frames := PACKETS - 1;
            fps_init_first_pass_info_in_vp9_encoder(
                *CPI.twopass.first_pass_info,
                cast(*FIRSTPASS_STATS_in_vp9_cx_iface) oxcf.two_pass_stats_in.buf,
                num_frames
            );

            vp9_init_second_pass(CPI);
        }
    }

    CPI.mb_wiener_var_cols = 0;
    CPI.mb_wiener_var_rows = 0;
    CPI.mb_wiener_variance = null;
    CPI.mi_ssim_rdmult_scaling_factors = null;
    CPI.mi_ssim_rdmult_scaling_factors_rows = 0;
    CPI.mi_ssim_rdmult_scaling_factors_cols = 0;

    vp9_set_speed_features_framesize_independent(CPI, oxcf.speed);
    vp9_set_speed_features_framesize_dependent(CPI, oxcf.speed);

    CPI.kmeans_data_arr_alloc = 0;

    i = 0;
    while i < cast,no_check(u32) (2 * 25) {
        CPI.tpl_stats[i].tpl_stats_ptr = null;
        i += 1;
    }

    CPI.fn_ptr[8].sdf = sad32x16_c;

    CPI.fn_ptr[8].sdsf = sad_skip_32x16_c;

    CPI.fn_ptr[8].sdaf = sad32x16_avg_c;

    CPI.fn_ptr[8].vf = variance32x16_c;

    CPI.fn_ptr[8].svf = sub_pixel_variance32x16_c;

    CPI.fn_ptr[8].svaf = sub_pixel_avg_variance32x16_c;

    CPI.fn_ptr[8].sdx4df = sad32x16x4d_c;

    CPI.fn_ptr[8].sdsx4df = sad_skip_32x16x4d_c;

    CPI.fn_ptr[7].sdf = sad16x32_c;

    CPI.fn_ptr[7].sdsf = sad_skip_16x32_c;

    CPI.fn_ptr[7].sdaf = sad16x32_avg_c;

    CPI.fn_ptr[7].vf = variance16x32_c;

    CPI.fn_ptr[7].svf = sub_pixel_variance16x32_c;

    CPI.fn_ptr[7].svaf = sub_pixel_avg_variance16x32_c;

    CPI.fn_ptr[7].sdx4df = sad16x32x4d_c;

    CPI.fn_ptr[7].sdsx4df = sad_skip_16x32x4d_c;

    CPI.fn_ptr[11].sdf = sad64x32_c;

    CPI.fn_ptr[11].sdsf = sad_skip_64x32_c;

    CPI.fn_ptr[11].sdaf = sad64x32_avg_c;

    CPI.fn_ptr[11].vf = variance64x32_c;

    CPI.fn_ptr[11].svf = sub_pixel_variance64x32_c;

    CPI.fn_ptr[11].svaf = sub_pixel_avg_variance64x32_c;

    CPI.fn_ptr[11].sdx4df = sad64x32x4d_c;

    CPI.fn_ptr[11].sdsx4df = sad_skip_64x32x4d_c;

    CPI.fn_ptr[10].sdf = sad32x64_c;

    CPI.fn_ptr[10].sdsf = sad_skip_32x64_c;

    CPI.fn_ptr[10].sdaf = sad32x64_avg_c;

    CPI.fn_ptr[10].vf = variance32x64_c;

    CPI.fn_ptr[10].svf = sub_pixel_variance32x64_c;

    CPI.fn_ptr[10].svaf = sub_pixel_avg_variance32x64_c;

    CPI.fn_ptr[10].sdx4df = sad32x64x4d_c;

    CPI.fn_ptr[10].sdsx4df = sad_skip_32x64x4d_c;

    CPI.fn_ptr[9].sdf = sad32x32_c;

    CPI.fn_ptr[9].sdsf = sad_skip_32x32_c;

    CPI.fn_ptr[9].sdaf = sad32x32_avg_c;

    CPI.fn_ptr[9].vf = variance32x32_c;

    CPI.fn_ptr[9].svf = sub_pixel_variance32x32_c;

    CPI.fn_ptr[9].svaf = sub_pixel_avg_variance32x32_c;

    CPI.fn_ptr[9].sdx4df = sad32x32x4d_c;

    CPI.fn_ptr[9].sdsx4df = sad_skip_32x32x4d_c;

    CPI.fn_ptr[12].sdf = sad64x64_c;

    CPI.fn_ptr[12].sdsf = sad_skip_64x64_c;

    CPI.fn_ptr[12].sdaf = sad64x64_avg_c;

    CPI.fn_ptr[12].vf = variance64x64_c;

    CPI.fn_ptr[12].svf = sub_pixel_variance64x64_c;

    CPI.fn_ptr[12].svaf = sub_pixel_avg_variance64x64_c;

    CPI.fn_ptr[12].sdx4df = sad64x64x4d_c;

    CPI.fn_ptr[12].sdsx4df = sad_skip_64x64x4d_c;

    CPI.fn_ptr[6].sdf = sad16x16_c;

    CPI.fn_ptr[6].sdsf = sad_skip_16x16_c;

    CPI.fn_ptr[6].sdaf = sad16x16_avg_c;

    CPI.fn_ptr[6].vf = variance16x16_c;

    CPI.fn_ptr[6].svf = sub_pixel_variance16x16_c;

    CPI.fn_ptr[6].svaf = sub_pixel_avg_variance16x16_c;

    CPI.fn_ptr[6].sdx4df = sad16x16x4d_c;

    CPI.fn_ptr[6].sdsx4df = sad_skip_16x16x4d_c;

    CPI.fn_ptr[5].sdf = sad16x8_c;

    CPI.fn_ptr[5].sdsf = sad_skip_16x8_c;

    CPI.fn_ptr[5].sdaf = sad16x8_avg_c;

    CPI.fn_ptr[5].vf = variance16x8_c;

    CPI.fn_ptr[5].svf = sub_pixel_variance16x8_c;

    CPI.fn_ptr[5].svaf = sub_pixel_avg_variance16x8_c;

    CPI.fn_ptr[5].sdx4df = sad16x8x4d_c;

    CPI.fn_ptr[5].sdsx4df = sad_skip_16x8x4d_c;

    CPI.fn_ptr[4].sdf = sad8x16_c;

    CPI.fn_ptr[4].sdsf = sad_skip_8x16_c;

    CPI.fn_ptr[4].sdaf = sad8x16_avg_c;

    CPI.fn_ptr[4].vf = variance8x16_c;

    CPI.fn_ptr[4].svf = sub_pixel_variance8x16_c;

    CPI.fn_ptr[4].svaf = sub_pixel_avg_variance8x16_c;

    CPI.fn_ptr[4].sdx4df = sad8x16x4d_c;

    CPI.fn_ptr[4].sdsx4df = sad_skip_8x16x4d_c;

    CPI.fn_ptr[3].sdf = sad8x8_c;

    CPI.fn_ptr[3].sdsf = sad_skip_8x8_c;

    CPI.fn_ptr[3].sdaf = sad8x8_avg_c;

    CPI.fn_ptr[3].vf = variance8x8_c;

    CPI.fn_ptr[3].svf = sub_pixel_variance8x8_c;

    CPI.fn_ptr[3].svaf = sub_pixel_avg_variance8x8_c;

    CPI.fn_ptr[3].sdx4df = sad8x8x4d_c;

    CPI.fn_ptr[3].sdsx4df = sad_skip_8x8x4d_c;

    CPI.fn_ptr[2].sdf = sad8x4_c;

    CPI.fn_ptr[2].sdsf = sad_skip_8x4_c;

    CPI.fn_ptr[2].sdaf = sad8x4_avg_c;

    CPI.fn_ptr[2].vf = variance8x4_c;

    CPI.fn_ptr[2].svf = sub_pixel_variance8x4_c;

    CPI.fn_ptr[2].svaf = sub_pixel_avg_variance8x4_c;

    CPI.fn_ptr[2].sdx4df = sad8x4x4d_c;

    CPI.fn_ptr[2].sdsx4df = sad_skip_8x4x4d_c;

    CPI.fn_ptr[1].sdf = sad4x8_c;

    CPI.fn_ptr[1].sdsf = sad_skip_4x8_c;

    CPI.fn_ptr[1].sdaf = sad4x8_avg_c;

    CPI.fn_ptr[1].vf = variance4x8_c;

    CPI.fn_ptr[1].svf = sub_pixel_variance4x8_c;

    CPI.fn_ptr[1].svaf = sub_pixel_avg_variance4x8_c;

    CPI.fn_ptr[1].sdx4df = sad4x8x4d_c;

    CPI.fn_ptr[1].sdsx4df = sad_skip_4x8x4d_c;

    CPI.fn_ptr[0].sdf = sad4x4_c;

    CPI.fn_ptr[0].sdsf = sad_skip_4x4_c;

    CPI.fn_ptr[0].sdaf = sad4x4_avg_c;

    CPI.fn_ptr[0].vf = variance4x4_c;

    CPI.fn_ptr[0].svf = sub_pixel_variance4x4_c;

    CPI.fn_ptr[0].svaf = sub_pixel_avg_variance4x4_c;

    CPI.fn_ptr[0].sdx4df = sad4x4x4d_c;

    CPI.fn_ptr[0].sdsx4df = sad_skip_4x4x4d_c;

    vp9_init_quantizer(CPI);

    vp9_loop_filter_init(CM);

    vp9_setup_scale_factors_for_frame(*CPI.me_sf, CM.width, CM.height, CM.width, CM.height);

    CPI.td.mb.me_sf = *CPI.me_sf;

    CM.error.setjmp = 0;

    return CPI;
}

cal_nmvsadcosts_hp :: (mvsadcost: **s32) {
    i: s32 = 1;

    mvsadcost[0][0] = 0;
    mvsadcost[1][0] = 0;

    while true {
        {
            z := 256.0 * (2.0 * (c_transpiler_math_log(cast,no_check(float64) (8 * i)) / 0.6931471824645996 + 0.6));
            mvsadcost[0][i] = cast,no_check(s32) z;
            mvsadcost[1][i] = cast,no_check(s32) z;
            mvsadcost[0][-i] = cast,no_check(s32) z;
            mvsadcost[1][-i] = cast,no_check(s32) z;
        }
        if !(c_transpiler_pre_increment(*(i)) <= (cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1) break;
    }
}

cal_nmvsadcosts :: (mvsadcost: **s32) {
    i: s32 = 1;

    mvsadcost[0][0] = 0;
    mvsadcost[1][0] = 0;

    while true {
        {
            z := 256.0 * (2.0 * (c_transpiler_math_log(cast,no_check(float64) (8 * i)) / 0.6931471824645996 + 0.6));
            mvsadcost[0][i] = cast,no_check(s32) z;
            mvsadcost[1][i] = cast,no_check(s32) z;
            mvsadcost[0][-i] = cast,no_check(s32) z;
            mvsadcost[1][-i] = cast,no_check(s32) z;
        }
        if !(c_transpiler_pre_increment(*(i)) <= (cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1) break;
    }
}

cal_nmvjointsadcost :: (mvjointsadcost: *s32) {
    mvjointsadcost[0] = 600;
    mvjointsadcost[1] = 300;
    mvjointsadcost[2] = 300;
    mvjointsadcost[3] = 300;
}

init_level_constraint :: (lc: *Level_Constraint) {
    lc.level_index = -1;
    lc.max_cpb_size = 2147483647.0;
    lc.max_frame_size = 2147483647;
    lc.fail_flag = 0;
}

init_level_info :: (level_info: *Vp9_Level_Info) {
    LEVEL_STATS := *level_info.level_stats;
    LEVEL_SPEC := *level_info.level_spec;

    fill_memory(LEVEL_STATS, 0, size_of(Vp9_Level_Stats));
    fill_memory(LEVEL_SPEC, 0, size_of(Vp9_Level_Spec));
    LEVEL_SPEC.level = cast,no_check(VP9_LEVEL) LEVEL_UNKNOWN;
    LEVEL_SPEC.min_altref_distance = 2147483647;
}

realloc_segmentation_maps :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;

    deallocate_memory(cast(*void) cpi.segmentation_map);
    cpi.segmentation_map = cast(*u8) calloc_2(cast,no_check(u64) (CM.mi_rows * CM.mi_cols), 1);

    if cpi.segmentation_map == null {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->segmentation_map")
        );
    }

    if cpi.cyclic_refresh != null {
        vp9_cyclic_refresh_free(cpi.cyclic_refresh);
    }
    cpi.cyclic_refresh = vp9_cyclic_refresh_alloc(CM.mi_rows, CM.mi_cols);

    if cpi.cyclic_refresh == null {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->cyclic_refresh")
        );
    }

    deallocate_memory(cast(*void) cpi.active_map.map);
    cpi.active_map.map = cast(*u8) calloc_2(cast,no_check(u64) (CM.mi_rows * CM.mi_cols), 1);

    if cpi.active_map.map == null {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->active_map.map")
        );
    }

    deallocate_memory(cast(*void) cpi.coding_context.last_frame_seg_map_copy);
    cpi.coding_context.last_frame_seg_map_copy =
        cast(*u8) calloc_2(
            cast,no_check(u64) (CM.mi_rows * CM.mi_cols),
            1
        );

    if cpi.coding_context.last_frame_seg_map_copy == null {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->coding_context.last_frame_seg_map_copy")
        );
    }
}

init_config_in_vp9_encoder :: (cpi: *VP9_COMP_in_vp9_encoder, oxcf: *VP9_Encoder_Config) {
    CM := *cpi.common;

    assignment_3: VP9_Encoder_Config = oxcf.*;
    ((*cpi.oxcf).*) = assignment_3;
    cpi.framerate = oxcf.init_framerate;
    CM.profile = oxcf.profile;
    CM.bit_depth = oxcf.bit_depth;

    CM.color_space = oxcf.color_space;
    CM.color_range = oxcf.color_range;

    cpi.target_level = cast,no_check(s32) oxcf.target_level;
    cpi.keep_level_stats = cast(s32) (oxcf.target_level != cast,no_check(u32) LEVEL_MAX);
    set_level_constraint(
        *cpi.level_constraint,
        cast,no_check(s8) get_level_index_in_vp9_encoder(cast,no_check(VP9_LEVEL) cpi.target_level)
    );

    CM.width = oxcf.width;
    CM.height = oxcf.height;
    alloc_compressor_data(cpi);

    cpi.svc.temporal_layering_mode = oxcf.temporal_layering_mode;

    cpi.td.counts = *CM.counts;

    cpi.svc.number_spatial_layers = oxcf.ss_number_layers;

    cpi.svc.number_temporal_layers = oxcf.ts_number_layers;

    if cpi.svc.number_temporal_layers > 1 || cpi.svc.number_spatial_layers > 1 {
        vp9_init_layer_context(cpi);
    }

    vp9_change_config(cpi, oxcf);

    cpi.static_mb_pct = 0;
    cpi.ref_frame_flags = 0;

    init_buffer_indices(cpi);

    vp9_noise_estimate_init(*cpi.noise_estimate, CM.width, CM.height);
    cpi.fixed_qp_onepass = 0;
}

init_buffer_indices :: (cpi: *VP9_COMP_in_vp9_encoder) {
    for ref_frame: 0..cast(s32) ((cast(s32) 1) << 3) - 1 {
        cpi.ref_fb_idx[ref_frame] = ref_frame;
    }

    cpi.lst_fb_idx = cpi.ref_fb_idx[1 - 1];
    cpi.gld_fb_idx = cpi.ref_fb_idx[2 - 1];
    cpi.alt_fb_idx = cpi.ref_fb_idx[3 - 1];
}

vp9_change_config :: (cpi: *VP9_COMP_in_vp9_encoder, oxcf: *VP9_Encoder_Config) {
    CM := *cpi.common;
    RC := *cpi.rc;
    last_w := cpi.oxcf.width;
    last_h := cpi.oxcf.height;

    vp9_init_quantizer(cpi);
    if CM.profile != oxcf.profile {
        CM.profile = oxcf.profile;
    }
    CM.bit_depth = oxcf.bit_depth;
    CM.color_space = oxcf.color_space;
    CM.color_range = oxcf.color_range;

    cpi.target_level = cast,no_check(s32) oxcf.target_level;
    cpi.keep_level_stats = cast(s32) (oxcf.target_level != cast,no_check(u32) LEVEL_MAX);
    set_level_constraint(
        *cpi.level_constraint,
        cast,no_check(s8) get_level_index_in_vp9_encoder(cast,no_check(VP9_LEVEL) cpi.target_level)
    );

    if CM.profile <= cast,no_check(u32) PROFILE_1 {
    } else {
    }

    assignment_4: VP9_Encoder_Config = oxcf.*;
    ((*cpi.oxcf).*) = assignment_4;

    if oxcf.pass == 0 && oxcf.rc_mode == cast,no_check(u32) Q {
        RC.baseline_gf_interval = 8;
    } else {
        RC.baseline_gf_interval = (cast,no_check(s32) ((4 + 16))) / 2;
    }

    cpi.refresh_golden_frame = 0;
    cpi.refresh_last_frame = 1;
    CM.refresh_frame_context = 1;
    CM.reset_frame_context = 0;

    vp9_reset_segment_features(*CM.seg);
    vp9_set_high_precision_mv(cpi, 0);

    {
        for i: 0..cast(s32) 8 - 1 {
            cpi.segment_encode_breakout[i] = cpi.oxcf.encode_breakout;
        }
    }
    cpi.encode_breakout = cpi.oxcf.encode_breakout;

    vp9_set_rc_buffer_sizes(cpi);

    vp9_new_framerate(cpi, cpi.framerate);

    RC.worst_quality = cpi.oxcf.worst_allowed_q;
    RC.best_quality = cpi.oxcf.best_allowed_q;

    CM.interp_filter = cpi.sf.default_interp_filter;

    if cpi.oxcf.render_width > 0 && cpi.oxcf.render_height > 0 {
        CM.render_width = cpi.oxcf.render_width;
        CM.render_height = cpi.oxcf.render_height;
    } else {
        CM.render_width = cpi.oxcf.width;
        CM.render_height = cpi.oxcf.height;
    }
    if last_w != cpi.oxcf.width || last_h != cpi.oxcf.height {
        CM.width = cpi.oxcf.width;
        CM.height = cpi.oxcf.height;
        cpi.external_resize = 1;
    }

    if cpi.initial_width != 0 && cpi.initial_height != 0 && (CM.width > cpi.initial_width || CM.height > cpi.initial_height) {
        vp9_free_context_buffers(CM);
        vp9_free_pc_tree(*cpi.td);
        deallocate_memory(cast(*void) cpi.mbmi_ext_base);
        deallocate_memory(cast(*void) cpi.content_state_sb_fd);
        cpi.content_state_sb_fd = null;
        alloc_compressor_data(cpi);
        realloc_segmentation_maps(cpi);
        cpi.initial_width = CM.width;
        cpi.initial_height = CM.height;
        cpi.external_resize = 0;
    }

    if CM.current_video_frame == 0 || last_w != cpi.oxcf.width || last_h != cpi.oxcf.height {
        update_frame_size(cpi);
    }

    if last_w != cpi.oxcf.width || last_h != cpi.oxcf.height {
        svc_alloc_mi_area := CM.mi_rows * CM.mi_cols;
        if cpi.svc.number_spatial_layers > 1 && cpi.initial_width != 0 && cpi.initial_height != 0 {
            init_mi_rows, init_mi_cols, init_mi_stride: s32 = ---;
            vp9_set_mi_size(*init_mi_rows, *init_mi_cols, *init_mi_stride, cpi.initial_width, cpi.initial_height);
            svc_alloc_mi_area =
                ifx svc_alloc_mi_area > init_mi_rows *
                    init_mi_cols then svc_alloc_mi_area else init_mi_rows * init_mi_cols;
        }
        deallocate_memory(cast(*void) cpi.consec_zero_mv);
        cpi.consec_zero_mv = cast(*u8) calloc_2(cast,no_check(u64) svc_alloc_mi_area, size_of(u8));

        if cpi.consec_zero_mv == null {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate cpi->consec_zero_mv")
            );
        }

        deallocate_memory(cast(*void) cpi.skin_map);
        cpi.skin_map = cast(*u8) calloc_2(cast,no_check(u64) svc_alloc_mi_area, size_of(u8));

        if cpi.skin_map == null {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate cpi->skin_map")
            );
        }

        if cpi.svc.number_spatial_layers > 1 {
            {
                sl: s32 = 0;
                while sl < cpi.svc.number_spatial_layers {
                    LAYER := sl * cpi.svc.number_temporal_layers + 0;
                    LC := cpi.svc.layer_context.data + LAYER;
                    LC.sb_index = 0;
                    LC.actual_num_seg1_blocks = 0;
                    LC.actual_num_seg2_blocks = 0;
                    LC.counter_encode_maxq_scene_change = 0;
                    deallocate_memory(cast(*void) LC.map);
                    LC.map = cast(*s8) calloc_2(cast,no_check(u64) svc_alloc_mi_area, size_of(s8));

                    if LC.map == null {
                        internal_error(
                            *CM.error,
                            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                            c_string("Failed to allocate lc->map")
                        );
                    }
                    deallocate_memory(cast(*void) LC.last_coded_q_map);
                    LC.last_coded_q_map = cast(*u8) allocate_memory(cast,no_check(u64) svc_alloc_mi_area);

                    if LC.last_coded_q_map == null {
                        internal_error(
                            *CM.error,
                            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                            c_string("Failed to allocate lc->last_coded_q_map")
                        );
                    }
                    fill_memory(LC.last_coded_q_map, 255, cast,no_check(u64) svc_alloc_mi_area);
                    deallocate_memory(cast(*void) LC.consec_zero_mv);
                    LC.consec_zero_mv =
                        cast(*u8) calloc_2(
                            cast,no_check(u64) svc_alloc_mi_area,
                            size_of(u8)
                        );

                    if LC.consec_zero_mv == null {
                        internal_error(
                            *CM.error,
                            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                            c_string("Failed to allocate lc->consec_zero_mv")
                        );
                    }
                    sl += 1;
                }
            }
            if cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ {
                cpi.refresh_golden_frame = 1;
                cpi.refresh_alt_ref_frame = 1;
            }
        }

        free_copy_partition_data(cpi);
        alloc_copy_partition_data(cpi);
        if cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ && cpi.svc.number_spatial_layers == 1 {
            vp9_cyclic_refresh_reset_resize(cpi);
        }
        deallocate_memory(cast(*void) cpi.count_arf_frame_usage);
        cpi.count_arf_frame_usage = null;
        deallocate_memory(cast(*void) cpi.count_lastgolden_frame_usage);
        cpi.count_lastgolden_frame_usage = null;
        RC.rc_1_frame = 0;
        RC.rc_2_frame = 0;
    }

    if cpi.svc.number_temporal_layers > 1 ||
        (cpi.svc.number_temporal_layers > 1 || cpi.svc.number_spatial_layers > 1) && cpi.oxcf.pass != 1 {
        vp9_update_layer_context_change_config(cpi, cast,no_check(s32) cpi.oxcf.target_bandwidth);
    }

    vp9_check_reset_rc_flag(cpi);

    cpi.alt_ref_source = null;
    RC.is_src_frame_alt_ref = 0;

    set_tile_limits(cpi);

    cpi.ext_refresh_frame_flags_pending = 0;
    cpi.ext_refresh_frame_context_pending = 0;

    vp9_set_row_mt(cpi);
}

vp9_set_row_mt :: (cpi: *VP9_COMP_in_vp9_encoder) {
    cpi.row_mt = 0;
    if (cpi.oxcf.mode == cast,no_check(u32) GOOD || cpi.oxcf.mode == cast,no_check(u32) BEST) &&
        cpi.oxcf.speed < 5 &&
        cpi.oxcf.pass == 1 &&
        cpi.oxcf.row_mt != 0 &&
        cpi.use_svc == 0 {
        cpi.row_mt = 1;
    }

    if cpi.oxcf.mode == cast,no_check(u32) GOOD &&
        cpi.oxcf.speed < 5 &&
        (cpi.oxcf.pass == 0 || cpi.oxcf.pass == 2) &&
        cpi.oxcf.row_mt != 0 &&
        cpi.use_svc == 0 {
        cpi.row_mt = 1;
    }

    if cpi.oxcf.mode == cast,no_check(u32) REALTIME && cpi.oxcf.speed >= 5 && cpi.oxcf.row_mt != 0 {
        cpi.row_mt = 1;
    }

    if cpi.row_mt != 0 {
        cpi.row_mt_bit_exact = 1;
    } else {
        cpi.row_mt_bit_exact = 0;
    }
}

set_tile_limits :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;

    min_log2_tile_cols, max_log2_tile_cols: s32 = ---;
    vp9_get_tile_n_bits(CM.mi_cols, *min_log2_tile_cols, *max_log2_tile_cols);

    CM.log2_tile_cols = clamp_in_vp9_encoder(cpi.oxcf.tile_columns, min_log2_tile_cols, max_log2_tile_cols);

    SB64_ROWS := mi_cols_aligned_to_sb_in_vp9_encoder(CM.mi_rows) >> 3;
    MAX_LOG2_TILE_ROWS := (ifx SB64_ROWS >= 4 then 2 else cast(s32) (SB64_ROWS >= 2));
    CM.log2_tile_rows = ifx cpi.oxcf.tile_rows < MAX_LOG2_TILE_ROWS then cpi.oxcf.tile_rows else MAX_LOG2_TILE_ROWS;

    if cpi.oxcf.target_level == cast,no_check(u32) LEVEL_AUTO {
        LEVEL_TILE_COLS :=
            log_tile_cols_from_picsize_level_in_vp9_encoder(
                cast,no_check(u32) cpi.common.width,
                cast,no_check(u32) cpi.common.height
            );
        if CM.log2_tile_cols > LEVEL_TILE_COLS {
            CM.log2_tile_cols = max(LEVEL_TILE_COLS, min_log2_tile_cols);
        }
    }
}

log_tile_cols_from_picsize_level_in_vp9_encoder :: (width: u32, height: u32) -> s32 {
    PIC_SIZE := width * height;
    PIC_BREADTH := max(width, height);
    for i: 0..cast(s32) 14 - 1 {
        if VP9_LEVEL_DEFS[i].max_luma_picture_size >= PIC_SIZE && VP9_LEVEL_DEFS[i].max_luma_picture_breadth >= PIC_BREADTH {
            return get_msb_in_vp9_encoder(cast,no_check(u32) VP9_LEVEL_DEFS[i].max_col_tiles);
        }
    }
    return 2147483647;
}

vp9_check_reset_rc_flag :: (cpi: *VP9_COMP_in_vp9_encoder) {
    rc := *cpi.rc;

    if cpi.common.current_video_frame > cast,no_check(u32) cpi.svc.number_spatial_layers {
        if cpi.use_svc != 0 {
            vp9_svc_check_reset_layer_rc_flag(cpi);
        } else if rc.avg_frame_bandwidth / 3 > rc.last_avg_frame_bandwidth >> 1 ||
            rc.avg_frame_bandwidth < rc.last_avg_frame_bandwidth >> 1 {
            rc.rc_1_frame = 0;
            rc.rc_2_frame = 0;
            rc.bits_off_target = rc.optimal_buffer_level;
            rc.buffer_level = rc.optimal_buffer_level;
        }
    }
}

alloc_copy_partition_data :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    if cpi.prev_partition == null {
        cpi.prev_partition =
            cast(*BLOCK_SIZE) calloc_2(
                cast,no_check(u64) (CM.mi_stride * CM.mi_rows),
                size_of(BLOCK_SIZE)
            );

        if cpi.prev_partition == null {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate cpi->prev_partition")
            );
        }
    }
    if cpi.prev_segment_id == null {
        cpi.prev_segment_id =
            cast(*s8) calloc_2(
                cast,no_check(u64) (CM.mi_stride >> 3 * (CM.mi_rows >> 3 + 1)),
                size_of(s8)
            );

        if cpi.prev_segment_id == null {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate cpi->prev_segment_id")
            );
        }
    }
    if cpi.prev_variance_low == null {
        cpi.prev_variance_low =
            cast(*u8) calloc_2(
                cast,no_check(u64) (CM.mi_stride >> 3 * (CM.mi_rows >> 3 + 1) * 25),
                size_of(u8)
            );

        if cpi.prev_variance_low == null {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate cpi->prev_variance_low")
            );
        }
    }
    if cpi.copied_frame_cnt == null {
        cpi.copied_frame_cnt =
            cast(*u8) calloc_2(
                cast,no_check(u64) (CM.mi_stride >> 3 * (CM.mi_rows >> 3 + 1)),
                size_of(u8)
            );

        if cpi.copied_frame_cnt == null {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate cpi->copied_frame_cnt")
            );
        }
    }
}

free_copy_partition_data :: (cpi: *VP9_COMP_in_vp9_encoder) {
    deallocate_memory(cast(*void) cpi.prev_partition);
    cpi.prev_partition = null;
    deallocate_memory(cast(*void) cpi.prev_segment_id);
    cpi.prev_segment_id = null;
    deallocate_memory(cast(*void) cpi.prev_variance_low);
    cpi.prev_variance_low = null;
    deallocate_memory(cast(*void) cpi.copied_frame_cnt);
    cpi.copied_frame_cnt = null;
}

update_frame_size :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    XD := *cpi.td.mb.e_mbd;

    vp9_set_mb_mi(CM, CM.width, CM.height);
    vp9_init_context_buffers(CM);
    vp9_init_macroblockd_in_vp9_encoder(CM, XD, null);
    cpi.td.mb.mbmi_ext_base = cpi.mbmi_ext_base;
    fill_memory(cpi.mbmi_ext_base, 0, cast,no_check(u64) (CM.mi_rows * CM.mi_cols) * size_of(MB_MODE_INFO_EXT));

    set_tile_limits(cpi);
}

alloc_compressor_data :: (cpi: *VP9_COMP_in_vp9_encoder) {
    cm := *cpi.common;

    if vp9_alloc_context_buffers(cm, cm.width, cm.height) != 0 {
        internal_error(
            *cm.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate context buffers")
        );
    }

    alloc_context_buffers_ext(cpi);

    deallocate_memory(cast(*void) cpi.tile_tok[0][0]);

    {
        tokens := get_token_alloc_in_vp9_encoder(cm.mb_rows, cm.mb_cols);

        cpi.tile_tok[0][0] =
            cast(*TOKENEXTRA_in_vp9_cx_iface) calloc_2(
                cast,no_check(u64) tokens,
                size_of(TOKENEXTRA_in_vp9_cx_iface)
            );

        if cpi.tile_tok[0][0] == null {
            internal_error(
                *cm.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate cpi->tile_tok[0][0]")
            );
        }
    }

    sb_rows := mi_cols_aligned_to_sb_in_vp9_encoder(cm.mi_rows) >> (((6 - 3)) & 31);
    deallocate_memory(cast(*void) cpi.tplist[0][0]);
    cpi.tplist[0][0] =
        cast(*TOKENLIST_in_vp9_cx_iface) calloc_2(
            cast,no_check(u64) (sb_rows * 4 * (cast(s32) 1) << 6),
            size_of(TOKENLIST_in_vp9_cx_iface)
        );

    if cpi.tplist[0][0] == null {
        internal_error(
            *cm.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->tplist[0][0]")
        );
    }

    vp9_setup_pc_tree(*cpi.common, *cpi.td);

    if cpi.kmeans_data_arr_alloc != 0 {
        pthread_mutex_destroy(*cpi.kmeans_mutex);

        deallocate_memory(cast(*void) cpi.kmeans_data_arr);
        cpi.kmeans_data_arr = null;
        cpi.kmeans_data_arr_alloc = 0;
    }
}

get_token_alloc_in_vp9_encoder :: (mb_rows: s32, mb_cols: s32) -> s64 {
    ALIGNED_MB_ROWS :=
        (mb_rows +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    ALIGNED_MB_COLS :=
        (mb_cols +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    return ((cast,no_check(s64) ALIGNED_MB_ROWS) * cast(s64) ALIGNED_MB_COLS) * cast,no_check(s64) ((cast,no_check(s32) ((16 * 16))) * 3 + 4);
}

alloc_context_buffers_ext :: (cpi: *VP9_COMP_in_vp9_encoder) {
    cm := *cpi.common;
    mi_size := cm.mi_cols * cm.mi_rows;

    cpi.mbmi_ext_base =
        cast(*MB_MODE_INFO_EXT) calloc_2(
            cast,no_check(u64) mi_size,
            size_of(MB_MODE_INFO_EXT)
        );

    if cpi.mbmi_ext_base == null {
        internal_error(
            *cm.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->mbmi_ext_base")
        );
    }
}

vp9_new_framerate :: (cpi: *VP9_COMP_in_vp9_encoder, framerate: float64) {
    cpi.framerate = ifx c_transpiler_float_less(framerate, 0.1) then 30.0 else framerate;
    vp9_rc_update_framerate(cpi);
}

vp9_set_rc_buffer_sizes :: (cpi: *VP9_COMP_in_vp9_encoder) {
    rc := *cpi.rc;
    oxcf := *cpi.oxcf;

    BANDWIDTH := oxcf.target_bandwidth;
    STARTING := oxcf.starting_buffer_level_ms;
    OPTIMAL := oxcf.optimal_buffer_level_ms;
    MAXIMUM := oxcf.maximum_buffer_size_ms;

    rc.starting_buffer_level = STARTING * BANDWIDTH / 1000;
    rc.optimal_buffer_level = ifx OPTIMAL == 0 then BANDWIDTH / 8 else OPTIMAL * BANDWIDTH / 1000;
    rc.maximum_buffer_size = ifx MAXIMUM == 0 then BANDWIDTH / 8 else MAXIMUM * BANDWIDTH / 1000;

    rc.bits_off_target =
        ifx rc.bits_off_target < rc.maximum_buffer_size then rc.bits_off_target else rc.maximum_buffer_size;
    rc.buffer_level = ifx rc.buffer_level < rc.maximum_buffer_size then rc.buffer_level else rc.maximum_buffer_size;
}

vp9_set_high_precision_mv :: (cpi: *VP9_COMP_in_vp9_encoder, allow_high_precision_mv: s32) {
    MB := *cpi.td.mb;
    cpi.common.allow_high_precision_mv = allow_high_precision_mv;
    if cpi.common.allow_high_precision_mv != 0 {
        MB.mvcost = MB.nmvcost_hp.data;
        MB.mvsadcost = MB.nmvsadcost_hp.data;
    } else {
        MB.mvcost = MB.nmvcost.data;
        MB.mvsadcost = MB.nmvsadcost.data;
    }
}

get_level_index_in_vp9_encoder :: (level: VP9_LEVEL) -> s32 {
    for i: 0..cast(s32) 14 - 1 {
        if level == VP9_LEVEL_DEFS[i].level {
            return i;
        }
    }
    return -1;
}

set_level_constraint :: (ls: *Level_Constraint, level_index: s8) {
    ls.level_index = level_index;
    if level_index >= 0 {
        ls.max_cpb_size = VP9_LEVEL_DEFS[level_index].max_cpb_size * 1000.0;
    }
}

init_ref_frame_bufs :: (cm: *VP9_COMMON) {
    POOL := cm.buffer_pool;
    cm.new_fb_idx = -1;
    for i: 0..cast(s32) ((cast(s32) 1) << 3) - 1 {
        cm.ref_frame_map[i] = -1;
    }
    for i: 0..cast(s32) ((cast(s32) 1) << 3 + 1 + 3) - 1 {
        POOL.frame_bufs[i].ref_count = 0;
    }
}

vp9_enc_setup_mi :: (cm: *VP9_COMMON) {
    cm.mi = cm.mip + cm.mi_stride + 1;
    fill_memory(cm.mip, 0, cast,no_check(u64) (cm.mi_stride * (cm.mi_rows + 1)) * size_of(MODE_INFO));
    cm.prev_mi = cm.prev_mip + cm.mi_stride + 1;

    fill_memory(cm.prev_mip, 0, size_of(MODE_INFO) * cast,no_check(u64) cm.mi_stride);

    i: s32 = 1;
    while i < cm.mi_rows + 1 {
        fill_memory(*(cast(*MODE_INFO) (cm.prev_mip))[i * cm.mi_stride], 0, size_of(MODE_INFO));
        i += 1;
    }

    cm.mi_grid_visible = cm.mi_grid_base + cm.mi_stride + 1;
    cm.prev_mi_grid_visible = cm.prev_mi_grid_base + cm.mi_stride + 1;

    fill_memory(cm.mi_grid_base, 0, cast,no_check(u64) (cm.mi_stride * (cm.mi_rows + 1)) * size_of(*MODE_INFO));
}

vp9_enc_free_mi :: (cm: *VP9_COMMON) {
    deallocate_memory(cast(*void) cm.mip);
    cm.mip = null;
    deallocate_memory(cast(*void) cm.prev_mip);
    cm.prev_mip = null;
    deallocate_memory(cast(*void) cm.mi_grid_base);
    cm.mi_grid_base = null;
    deallocate_memory(cast(*void) cm.prev_mi_grid_base);
    cm.prev_mi_grid_base = null;
    cm.mi_alloc_size = 0;
}

vp9_enc_alloc_mi :: (cm: *VP9_COMMON, mi_size: s32) -> s32 {
    cm.mip = cast(*MODE_INFO) calloc_2(cast,no_check(u64) mi_size, size_of(MODE_INFO));
    if cm.mip == null {
        return 1;
    }
    cm.prev_mip = cast(*MODE_INFO) calloc_2(cast,no_check(u64) mi_size, size_of(MODE_INFO));
    if cm.prev_mip == null {
        return 1;
    }
    cm.mi_alloc_size = mi_size;

    cm.mi_grid_base = cast(**MODE_INFO) calloc_2(cast,no_check(u64) mi_size, size_of(*MODE_INFO));
    if cm.mi_grid_base == null {
        return 1;
    }
    cm.prev_mi_grid_base = cast(**MODE_INFO) calloc_2(cast,no_check(u64) mi_size, size_of(*MODE_INFO));
    if cm.prev_mi_grid_base == null {
        return 1;
    }

    return 0;
}

vp9_remove_compressor :: (cpi: *VP9_COMP_in_vp9_encoder) {
    if cpi == null {
        return;
    }

    cm := *cpi.common;
    if cm.current_video_frame > 0 {
    }

    if cpi.kmeans_data_arr_alloc != 0 {
        pthread_mutex_destroy(*cpi.kmeans_mutex);

        deallocate_memory(cast(*void) cpi.kmeans_data_arr);
    }

    vp9_free_tpl_buffer(cpi);

    vp9_loop_filter_dealloc(*cpi.lf_row_sync);
    vp9_bitstream_encode_tiles_buffer_dealloc(cpi);
    vp9_row_mt_mem_dealloc(cpi);
    vp9_encode_free_mt_data(cpi);

    vp9_alt_ref_aq_destroy(cpi.alt_ref_aq);

    dealloc_compressor_data_in_vp9_encoder(cpi);

    i: u32 = 0;
    while i < cpi.mbgraph_stats.count {
        deallocate_memory(cast(*void) cpi.mbgraph_stats[i].mb_stats);
        i += 1;
    }

    (cast,no_check(#type (_: *EXT_RATECTRL) -> Codec_Err_T) (cast(*void) vp9_extrc_delete))(*cpi.ext_ratectrl);

    fill_memory(cm.error.detail.data, #char "A", cm.error.detail.count - 1);
    cm.error.detail[(cast,no_check(u64) (cm.error.detail.count)) - 1] = 0;

    vp9_remove_common(cm);
    vp9_free_ref_frame_buffers(cm.buffer_pool);

    deallocate_memory(cast(*void) cpi);
}

dealloc_compressor_data_in_vp9_encoder :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;

    deallocate_memory(cast(*void) cpi.mbmi_ext_base);
    cpi.mbmi_ext_base = null;

    deallocate_memory(cast(*void) cpi.tile_data);
    cpi.tile_data = null;

    deallocate_memory(cast(*void) cpi.segmentation_map);
    cpi.segmentation_map = null;
    deallocate_memory(cast(*void) cpi.coding_context.last_frame_seg_map_copy);
    cpi.coding_context.last_frame_seg_map_copy = null;

    deallocate_memory(cast(*void) cpi.nmvcosts[0]);
    deallocate_memory(cast(*void) cpi.nmvcosts[1]);
    cpi.nmvcosts[0] = null;
    cpi.nmvcosts[1] = null;

    deallocate_memory(cast(*void) cpi.nmvcosts_hp[0]);
    deallocate_memory(cast(*void) cpi.nmvcosts_hp[1]);
    cpi.nmvcosts_hp[0] = null;
    cpi.nmvcosts_hp[1] = null;

    deallocate_memory(cast(*void) cpi.nmvsadcosts[0]);
    deallocate_memory(cast(*void) cpi.nmvsadcosts[1]);
    cpi.nmvsadcosts[0] = null;
    cpi.nmvsadcosts[1] = null;

    deallocate_memory(cast(*void) cpi.nmvsadcosts_hp[0]);
    deallocate_memory(cast(*void) cpi.nmvsadcosts_hp[1]);
    cpi.nmvsadcosts_hp[0] = null;
    cpi.nmvsadcosts_hp[1] = null;

    deallocate_memory(cast(*void) cpi.skin_map);
    cpi.skin_map = null;

    deallocate_memory(cast(*void) cpi.prev_partition);
    cpi.prev_partition = null;

    deallocate_memory(cast(*void) cpi.svc.prev_partition_svc);
    cpi.svc.prev_partition_svc = null;

    deallocate_memory(cast(*void) cpi.prev_segment_id);
    cpi.prev_segment_id = null;

    deallocate_memory(cast(*void) cpi.prev_variance_low);
    cpi.prev_variance_low = null;

    deallocate_memory(cast(*void) cpi.copied_frame_cnt);
    cpi.copied_frame_cnt = null;

    deallocate_memory(cast(*void) cpi.content_state_sb_fd);
    cpi.content_state_sb_fd = null;

    deallocate_memory(cast(*void) cpi.count_arf_frame_usage);
    cpi.count_arf_frame_usage = null;
    deallocate_memory(cast(*void) cpi.count_lastgolden_frame_usage);
    cpi.count_lastgolden_frame_usage = null;

    vp9_cyclic_refresh_free(cpi.cyclic_refresh);
    cpi.cyclic_refresh = null;

    deallocate_memory(cast(*void) cpi.active_map.map);
    cpi.active_map.map = null;

    deallocate_memory(cast(*void) cpi.roi.roi_map);
    cpi.roi.roi_map = null;

    deallocate_memory(cast(*void) cpi.consec_zero_mv);
    cpi.consec_zero_mv = null;

    deallocate_memory(cast(*void) cpi.mb_wiener_variance);
    cpi.mb_wiener_variance = null;

    deallocate_memory(cast(*void) cpi.sb_mul_scale);
    cpi.sb_mul_scale = null;

    deallocate_memory(cast(*void) cpi.mi_ssim_rdmult_scaling_factors);
    cpi.mi_ssim_rdmult_scaling_factors = null;

    vp9_free_ref_frame_buffers(CM.buffer_pool);

    vp9_free_context_buffers(CM);

    free_frame_buffer(*cpi.last_frame_uf);
    free_frame_buffer(*cpi.scaled_source);
    free_frame_buffer(*cpi.scaled_last_source);
    free_frame_buffer(*cpi.tf_buffer);

    vp9_lookahead_destroy(cpi.lookahead);

    deallocate_memory(cast(*void) cpi.tile_tok[0][0]);
    cpi.tile_tok[0][0] = null;

    deallocate_memory(cast(*void) cpi.tplist[0][0]);
    cpi.tplist[0][0] = null;

    vp9_free_pc_tree(*cpi.td);

    i: s32 = 0;
    while i < cpi.svc.number_spatial_layers {
        LC := cpi.svc.layer_context.data + i;
        deallocate_memory(LC.rc_twopass_stats_in.buf);
        LC.rc_twopass_stats_in.buf = null;
        LC.rc_twopass_stats_in.sz = 0;
        i += 1;
    }

    i = 0;
    while i < 25 {
        free_frame_buffer(cpi.svc.scaled_frames.data + i);
        i += 1;
    }
    fill_memory(cpi.svc.scaled_frames.data + 0, 0, cast(u64) 25 * size_of(YV12_BUFFER_CONFIG));

    free_frame_buffer(*cpi.svc.scaled_temp);
    fill_memory(*cpi.svc.scaled_temp, 0, size_of(YV12_BUFFER_CONFIG));

    free_frame_buffer(*cpi.svc.empty_frame.img);
    fill_memory(*cpi.svc.empty_frame, 0, size_of(Lookahead_Entry_in_vp9_lookahead));

    vp9_free_svc_cyclic_refresh(cpi);
}

vp9_receive_raw_frame :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    frame_flags: Enc_Frame_Flags_T,
    sd: *YV12_BUFFER_CONFIG,
    time_stamp: s64,
    end_time: s64
) -> s32 {
    CM := *cpi.common;

    res: s32 = 0;
    SUBSAMPLING_X := sd.subsampling_x;
    SUBSAMPLING_Y := sd.subsampling_y;

    USE_HIGHBITDEPTH: s32 = 0;

    if (CM.profile == cast,no_check(u32) PROFILE_0 || CM.profile == cast,no_check(u32) PROFILE_2) &&
        (SUBSAMPLING_X != 1 || SUBSAMPLING_Y != 1) {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM,
            c_string("Non-4:2:0 color format requires profile 1 or 3")
        );
        return -1;
    }
    if (CM.profile == cast,no_check(u32) PROFILE_1 || CM.profile == cast,no_check(u32) PROFILE_3) &&
        SUBSAMPLING_X == 1 &&
        SUBSAMPLING_Y == 1 {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM,
            c_string("4:2:0 color format requires profile 0 or 2")
        );
        return -1;
    }
    if CM.color_space == cast,no_check(u32) CS_SRGB {
        if CM.profile == cast,no_check(u32) PROFILE_0 || CM.profile == cast,no_check(u32) PROFILE_2 {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM,
                c_string("SRGB color space requires profile 1 or 3")
            );
            return -1;
        }
        if SUBSAMPLING_X != 0 || SUBSAMPLING_Y != 0 {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM,
                c_string("SRGB color space requires 4:4:4")
            );
            return -1;
        }
    }

    update_initial_width(cpi, USE_HIGHBITDEPTH, SUBSAMPLING_X, SUBSAMPLING_Y);

    alloc_raw_frame_buffers_in_vp9_encoder(cpi);

    if vp9_lookahead_push(cpi.lookahead, sd, time_stamp, end_time, USE_HIGHBITDEPTH, frame_flags) != 0 {
        res = -1;
    }

    return res;
}

alloc_raw_frame_buffers_in_vp9_encoder :: (cpi: *VP9_COMP_in_vp9_encoder) {
    cm := *cpi.common;
    oxcf := *cpi.oxcf;

    if cpi.lookahead == null {
        cpi.lookahead =
            vp9_lookahead_init(
                cast,no_check(u32) oxcf.width,
                cast,no_check(u32) oxcf.height,
                cast,no_check(u32) cm.subsampling_x,
                cast,no_check(u32) cm.subsampling_y,
                cast,no_check(u32) oxcf.lag_in_frames
            );
    }
    if cpi.lookahead == null {
        internal_error(
            *cm.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate lag buffers")
        );
    }

    if realloc_frame_buffer(
        *cpi.tf_buffer,
        oxcf.width,
        oxcf.height,
        cm.subsampling_x,
        cm.subsampling_y,
        160,
        cm.byte_alignment,
        null,
        null,
        null
    ) != 0 {
        internal_error(
            *cm.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate temporal filter buffer")
        );
    }
}

update_initial_width :: (cpi: *VP9_COMP_in_vp9_encoder, use_highbitdepth: s32, subsampling_x: s32, subsampling_y: s32) {
    CM := *cpi.common;

    if cpi.initial_width == 0 || CM.subsampling_x != subsampling_x || CM.subsampling_y != subsampling_y {
        CM.subsampling_x = subsampling_x;
        CM.subsampling_y = subsampling_y;

        alloc_util_frame_buffers(cpi);

        if CM.width > cpi.initial_width || CM.height > cpi.initial_height {
            cpi.initial_width = CM.width;
            cpi.initial_height = CM.height;
        }
        cpi.initial_mbs = CM.m_bs;
    }
}

alloc_util_frame_buffers :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    if realloc_frame_buffer(
        *cpi.last_frame_uf,
        CM.width,
        CM.height,
        CM.subsampling_x,
        CM.subsampling_y,
        160,
        CM.byte_alignment,
        null,
        null,
        null
    ) != 0 {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate last frame buffer")
        );
    }

    if realloc_frame_buffer(
        *cpi.scaled_source,
        CM.width,
        CM.height,
        CM.subsampling_x,
        CM.subsampling_y,
        160,
        CM.byte_alignment,
        null,
        null,
        null
    ) != 0 {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate scaled source buffer")
        );
    }

    if is_one_pass_svc_in_vp9_encoder(cpi) != 0 && cpi.svc.scaled_temp_is_alloc == 0 && cpi.svc.number_spatial_layers > 2 {
        cpi.svc.scaled_temp_is_alloc = 1;
        if realloc_frame_buffer(
            *cpi.svc.scaled_temp,
            CM.width >> 1,
            CM.height >> 1,
            CM.subsampling_x,
            CM.subsampling_y,
            160,
            CM.byte_alignment,
            null,
            null,
            null
        ) != 0 {
            internal_error(
                *cpi.common.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate scaled_frame for svc ")
            );
        }
    }

    if realloc_frame_buffer(
        *cpi.scaled_last_source,
        CM.width,
        CM.height,
        CM.subsampling_x,
        CM.subsampling_y,
        160,
        CM.byte_alignment,
        null,
        null,
        null
    ) != 0 {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate scaled last source buffer")
        );
    }
}

is_one_pass_svc_in_vp9_encoder :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if CPI.use_svc != 0 && CPI.oxcf.pass == 0 {
        return 1;
    }
    return 0;
}

vp9_get_compressed_data :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    frame_flags: *u32,
    size: *u64,
    dest: *u8,
    dest_size: u64,
    time_stamp: *s64,
    time_end: *s64,
    flush: s32,
    encode_frame_result: *ENCODE_FRAME_RESULT
) -> s32 {
    OXCF := *cpi.oxcf;
    CM := *cpi.common;
    POOL := CM.buffer_pool;
    RC := *cpi.rc;

    force_src_buffer: *YV12_BUFFER_CONFIG = null;
    last_source: *Lookahead_Entry_in_vp9_lookahead = null;
    source: *Lookahead_Entry_in_vp9_lookahead = null;

    GF_GROUP_INDEX := cast,no_check(s32) cpi.twopass.gf_group.index;
    i: s32 = ---;

    if is_one_pass_svc_in_vp9_encoder(cpi) != 0 {
        vp9_one_pass_svc_start_layer(cpi);
    }

    vp9_set_high_precision_mv(cpi, 1);

    if OXCF.pass == 2 && cpi.use_svc == 0 && cpi.oxcf.enable_auto_arf >= 2 {
        cpi.multi_layer_arf = 1;
    } else {
        cpi.multi_layer_arf = 0;
    }

    CM.reset_frame_context = 0;
    CM.refresh_frame_context = 1;
    if is_one_pass_svc_in_vp9_encoder(cpi) == 0 {
        cpi.refresh_last_frame = 1;
        cpi.refresh_golden_frame = 0;
        cpi.refresh_alt_ref_frame = 0;
    }

    arf_src_index := get_arf_src_index(cpi);

    if arf_src_index != 0 {
        i = 0;
        while i <= arf_src_index {
            e := vp9_lookahead_peek(cpi.lookahead, i);

            if e == null {
                break;
            } else if e.flags == 1 {
                arf_src_index = 0;
                flush = 1;
                break;
            }
            i += 1;
        }
    }

    if GF_GROUP_INDEX == 1 {
        stack_init_in_vp9_encoder(cpi.twopass.gf_group.arf_index_stack.data, cast,no_check(s32) (25 * 2));
        cpi.twopass.gf_group.stack_size = 0;
    }

    if arf_src_index != 0 {
        if !(cpi.ext_ratectrl.ready != 0 && (cpi.ext_ratectrl.funcs.rc_type & cast,no_check(u32) RC_GOP) != 0 && cpi.ext_ratectrl.funcs.get_gop_decision != null) {
        }
        if (ifx true { assignment_5: *Lookahead_Entry_in_vp9_lookahead = cast,no_check(*Lookahead_Entry_in_vp9_lookahead) (vp9_lookahead_peek(cpi.lookahead, arf_src_index)); (source) = assignment_5; assignment_5; }) != null {
            cpi.alt_ref_source = source;

            if OXCF.mode != cast,no_check(u32) REALTIME && OXCF.arnr_max_frames > 0 && OXCF.arnr_strength > 0 {
                bitrate := cpi.rc.avg_frame_bandwidth / 40;
                not_low_bitrate := cast(s32) (bitrate > 150);

                not_last_frame := cast(s32) (cpi.lookahead.sz - arf_src_index > 1);
                not_last_frame |= 1;

                vp9_temporal_filter(cpi, arf_src_index);
                extend_frame_borders_c(*cpi.tf_buffer);

                if cpi.oxcf.alt_ref_aq != 0 && not_low_bitrate != 0 && not_last_frame != 0 {
                    vp9_alt_ref_aq_setup_mode(cpi.alt_ref_aq, cpi);
                }

                force_src_buffer = *cpi.tf_buffer;
            }

            CM.show_frame = 0;
            CM.intra_only = 0;
            cpi.refresh_alt_ref_frame = 1;
            cpi.refresh_golden_frame = 0;
            cpi.refresh_last_frame = 0;
            RC.is_src_frame_alt_ref = 0;
            RC.source_alt_ref_pending = 0;
        } else {
            RC.source_alt_ref_pending = 0;
        }
    }

    if source == null {
        if CM.current_video_frame > 0 {
            if (ifx true { assignment_6: *Lookahead_Entry_in_vp9_lookahead = cast,no_check(*Lookahead_Entry_in_vp9_lookahead) (vp9_lookahead_peek(cpi.lookahead, -1)); (last_source) = assignment_6; assignment_6; }) == null {
                return -1;
            }
        }

        if cpi.use_svc != 0 || cpi.svc.set_intra_only_frame != 0 {
            source = vp9_svc_lookahead_pop(cpi, cpi.lookahead, flush);
        } else {
            source = vp9_lookahead_pop(cpi.lookahead, flush);
        }

        if source != null {
            CM.show_frame = 1;
            CM.intra_only = 0;

            if source.flags & 1 != 0 && cpi.use_svc != 0 && cpi.svc.spatial_layer_id > cpi.svc.first_spatial_layer_to_encode {
                source.flags &= cast,no_check(Enc_Frame_Flags_T) (~(cast,no_check(u32) (1)));
            }

            check_src_altref(cpi, source);
        }
    }

    if source != null {
        cpi.source = (ifx force_src_buffer != null then force_src_buffer else *source.img);
        cpi.un_scaled_source = cpi.source;

        cpi.unscaled_last_source = ifx last_source != null then *last_source.img else null;

        time_stamp.* = source.ts_start;
        time_end.* = source.ts_end;
        frame_flags.* =
            cast,no_check(u32) ((ifx source.flags & 1 != 0 then cast,no_check(s32) (FRAMEFLAGS_KEY_in_vp9_cx_iface) else 0));
    } else {
        size.* = 0;
        return -1;
    }

    if source.ts_start < cpi.first_time_stamp_ever {
        cpi.first_time_stamp_ever = source.ts_start;
        cpi.last_end_time_stamp_seen = source.ts_start;
    }

    if CM.show_frame != 0 {
        if cpi.use_svc != 0 && cpi.svc.use_set_ref_frame_config != 0 && cpi.svc.duration[cpi.svc.spatial_layer_id] > 0 {
            if cpi.svc.timebase_fac > 0 && cpi.svc.duration[cpi.svc.spatial_layer_id] > 9223372036854775807 / cpi.svc.timebase_fac {
                internal_error(
                    *cpi.common.error,
                    cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM,
                    c_string("svc duration would overflow timebase conversion")
                );
            } else {
                vp9_svc_adjust_frame_rate(cpi);
            }
        } else {
            adjust_frame_rate(cpi, source);
        }
    }

    if is_one_pass_svc_in_vp9_encoder(cpi) != 0 {
        vp9_update_temporal_layer_framerate(cpi);
        vp9_restore_layer_context(cpi);
    }

    if CM.new_fb_idx != -1 {
        POOL.frame_bufs[CM.new_fb_idx].ref_count -= 1;
    }
    CM.new_fb_idx = get_free_fb_in_vp9_encoder(CM);

    if CM.new_fb_idx == -1 {
        return -1;
    }
    CM.cur_frame = POOL.frame_bufs.data + CM.new_fb_idx;

    if cpi.svc.spatial_layer_id > 0 && CM.cur_frame == CM.prev_frame {
        cpi.svc.use_base_mv = 0;
    }

    size.* = 0;

    cpi.frame_flags = cast,no_check(s32) frame_flags.*;

    if OXCF.pass == 2 && cpi.use_svc == 0 {
        vp9_rc_get_second_pass_params(cpi);
    } else if OXCF.pass == 1 {
        set_frame_size(cpi);
    }

    IS_KEY_TEMPORAL_FILTER_ENABLED :=
        cast(s32) (OXCF.enable_keyframe_filtering != 0 && cpi.oxcf.mode != cast,no_check(u32) REALTIME && OXCF.pass != 1 && cpi.use_svc == 0 &&
            is_lossless_requested_in_vp9_encoder(*cpi.oxcf) == 0 && CM.frame_type == cast,no_check(u32) KEY_FRAME && OXCF.arnr_max_frames > 0 && OXCF.arnr_strength > 0 && cpi.oxcf.speed < 2);

    source_buffer := cpi.un_scaled_source;

    if IS_KEY_TEMPORAL_FILTER_ENABLED != 0 && source != null {
        vp9_temporal_filter(cpi, -1);
        extend_frame_borders_c(*cpi.tf_buffer);
        force_src_buffer = *cpi.tf_buffer;
        cpi.source = (ifx force_src_buffer != null then force_src_buffer else *source.img);
        cpi.un_scaled_source = cpi.source;
    }

    if OXCF.pass != 1 && cpi.level_constraint.level_index >= 0 && cpi.level_constraint.fail_flag == 0 {
        level_rc_framerate(cpi, arf_src_index);
    }

    if cpi.oxcf.pass != 0 || cpi.use_svc != 0 || frame_is_intra_only_in_vp9_encoder(CM) == 1 {
        i = 0;
        while i < 3 {
            cpi.scaled_ref_idx[i] = -1;
            i += 1;
        }
    }

    if cpi.kmeans_data_arr_alloc == 0 {
        init_mi_rows, init_mi_cols, init_mi_stride: s32 = ---;
        vp9_set_mi_size(*init_mi_rows, *init_mi_cols, *init_mi_stride, cpi.initial_width, cpi.initial_height);
        MI_COLS := mi_cols_aligned_to_sb_in_vp9_encoder(init_mi_cols);
        MI_ROWS := mi_cols_aligned_to_sb_in_vp9_encoder(init_mi_rows);

        pthread_mutex_init(*cpi.kmeans_mutex, null);

        cpi.kmeans_data_arr =
            cast(*KMEANS_DATA) calloc_2(
                cast,no_check(u64) (MI_ROWS * MI_COLS),
                size_of(KMEANS_DATA)
            );

        if cpi.kmeans_data_arr == null {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate cpi->kmeans_data_arr")
            );
        }
        cpi.kmeans_data_stride = MI_COLS;
        cpi.kmeans_data_arr_alloc = 1;
    }

    if should_run_tpl(cpi, cast,no_check(s32) cpi.twopass.gf_group.index) != 0 {
        vp9_init_tpl_buffer(cpi);
        vp9_estimate_tpl_qp_gop(cpi);
        vp9_setup_tpl_stats(cpi);
    }

    cpi.td.mb.fp_src_pred = 0;

    if OXCF.pass == 1 && cpi.use_svc == 0 {
        LOSSLESS := is_lossless_requested_in_vp9_encoder(OXCF);

        cpi.td.mb.fwd_txfm4x4 =
            cast,no_check(#type (_: *s16, _: *Tran_Low_T, _: s32)) (ifx LOSSLESS != 0 then vp9_fwht4x4_c else fdct4x4_c);

        cpi.td.mb.inv_txfm_add =
            cast,no_check(#type (_: *Tran_Low_T, _: *u8, _: s32, _: s32)) (ifx LOSSLESS != 0 then vp9_iwht4x4_add else vp9_idct4x4_add);
        vp9_first_pass(cpi, source);
    } else if OXCF.pass == 2 && cpi.use_svc == 0 {
        pass2_encode_in_vp9_encoder(cpi, size, dest, dest_size, frame_flags, encode_frame_result);
        vp9_twopass_postencode_update(cpi);
    } else if cpi.use_svc != 0 {
        svc_encode(cpi, size, dest, dest_size, frame_flags);
    } else {
        pass0_encode(cpi, size, dest, dest_size, frame_flags);
    }

    if CM.show_frame != 0 {
        CM.cur_show_frame_fb_idx = CM.new_fb_idx;
    }

    if CM.refresh_frame_context != 0 {
        assignment_7: FRAME_CONTEXT = CM.fc.*;
        ((*(cast(*Frame_Contexts) (CM.frame_contexts))[CM.frame_context_idx]).*) = assignment_7;
    }

    if size.* == 0 && frame_is_intra_only_in_vp9_encoder(CM) == 0 {
        release_scaled_references(cpi);
    }

    if size.* > 0 {
        cpi.droppable = cast(s32) (frame_is_reference_in_vp9_encoder(cpi) == 0);
    }

    if is_one_pass_svc_in_vp9_encoder(cpi) != 0 ||
        (cpi.svc.number_temporal_layers > 1 || cpi.svc.number_spatial_layers > 1) && OXCF.pass == 2 {
        vp9_save_layer_context(cpi);
    }

    if cpi.svc.spatial_layer_id == cpi.svc.number_spatial_layers - 1 {
        cpi.fixed_qp_onepass = 0;
    }

    if cpi.keep_level_stats != 0 && OXCF.pass != 1 {
        update_level_info(cpi, size.*, arf_src_index);
    }

    if IS_KEY_TEMPORAL_FILTER_ENABLED != 0 && cpi.b_calculate_psnr != 0 {
        cpi.raw_source_frame =
            vp9_scale_if_required(
                CM,
                source_buffer,
                *cpi.scaled_source,
                cast(s32) (OXCF.pass == 0),
                0,
                0
            );
    }

    if is_one_pass_svc_in_vp9_encoder(cpi) != 0 {
        if CM.show_frame != 0 {
            cpi.svc.spatial_layer_to_encode += 1;
            if cpi.svc.spatial_layer_to_encode >= cpi.svc.number_spatial_layers {
                cpi.svc.spatial_layer_to_encode = 0;
            }
        }
    }

    return 0;
}

vp9_scale_if_required :: (
    cm: *VP9_COMMON,
    unscaled: *YV12_BUFFER_CONFIG,
    scaled: *YV12_BUFFER_CONFIG,
    use_normative_scaler: s32,
    filter_type: INTERP_FILTER,
    phase_scaler: s32
) -> *YV12_BUFFER_CONFIG {
    if cm.mi_cols * (cast(s32) 1) << 3 != unscaled.y_width || cm.mi_rows * (cast(s32) 1) << 3 != unscaled.y_height {
        if use_normative_scaler != 0 && unscaled.y_width <= scaled.y_width << 1 && unscaled.y_height <= scaled.y_height << 1 {
            vp9_scale_and_extend_frame_c(unscaled, scaled, filter_type, phase_scaler);
        } else {
            vp9_scale_and_extend_frame_nonnormative(unscaled, scaled);
        }

        return scaled;
    } else {
        return unscaled;
    }
}

vp9_scale_and_extend_frame_nonnormative :: (src: *YV12_BUFFER_CONFIG, dst: *YV12_BUFFER_CONFIG) {
    SRCS := *u8.[ src.y_buffer, src.u_buffer, src.v_buffer ];
    SRC_STRIDES := s32.[ src.y_stride, src.uv_stride, src.uv_stride ];
    SRC_WIDTHS := s32.[ src.y_crop_width, src.uv_crop_width, src.uv_crop_width ];
    SRC_HEIGHTS := s32.[ src.y_crop_height, src.uv_crop_height, src.uv_crop_height ];
    DSTS := *u8.[ dst.y_buffer, dst.u_buffer, dst.v_buffer ];
    DST_STRIDES := s32.[ dst.y_stride, dst.uv_stride, dst.uv_stride ];
    DST_WIDTHS := s32.[ dst.y_crop_width, dst.uv_crop_width, dst.uv_crop_width ];
    DST_HEIGHTS := s32.[ dst.y_crop_height, dst.uv_crop_height, dst.uv_crop_height ];

    for i: 0..cast(s32) 3 - 1 {
        vp9_resize_plane(
            SRCS[i],
            SRC_HEIGHTS[i],
            SRC_WIDTHS[i],
            SRC_STRIDES[i],
            DSTS[i],
            DST_HEIGHTS[i],
            DST_WIDTHS[i],
            DST_STRIDES[i]
        );
    }
    extend_frame_borders_c(dst);
}

update_level_info :: (cpi: *VP9_COMP_in_vp9_encoder, size: u64, arf_src_index: s32) {
    CM := *cpi.common;
    LEVEL_INFO := *cpi.level_info;
    LEVEL_SPEC := *LEVEL_INFO.level_spec;
    LEVEL_STATS := *LEVEL_INFO.level_stats;
    i, idx: s32 = ---;
    dur_end: u64 = ---;
    LUMA_PIC_SIZE := cast,no_check(u32) (CM.width * CM.height);
    LUMA_PIC_BREADTH := cast,no_check(u32) ((ifx CM.width > CM.height then CM.width else CM.height));
    LEVEL_CONSTRAINT := *cpi.level_constraint;
    LEVEL_INDEX := LEVEL_CONSTRAINT.level_index;

    LEVEL_STATS.total_compressed_size = cast,no_check(u64) (LEVEL_STATS.total_compressed_size + size);
    if CM.show_frame != 0 {
        LEVEL_STATS.total_uncompressed_size +=
            cast,no_check(u64) (LUMA_PIC_SIZE +
                2 * LUMA_PIC_SIZE >> (((CM.subsampling_x + CM.subsampling_y)) & 31));
        LEVEL_STATS.time_encoded =
            (cast,no_check(float64) (cpi.last_end_time_stamp_seen - cpi.first_time_stamp_ever)) /
                10000000.0;
    }

    if arf_src_index > 0 {
        if LEVEL_STATS.seen_first_altref == 0 {
            LEVEL_STATS.seen_first_altref = 1;
        } else if LEVEL_STATS.frames_since_last_altref < LEVEL_SPEC.min_altref_distance {
            LEVEL_SPEC.min_altref_distance = LEVEL_STATS.frames_since_last_altref;
        }
        LEVEL_STATS.frames_since_last_altref = 0;
    } else {
        LEVEL_STATS.frames_since_last_altref += 1;
    }

    if cast,no_check(s32) LEVEL_STATS.frame_window_buffer.len < 128 - 1 {
        idx =
            ((cast(s32) LEVEL_STATS.frame_window_buffer.start) + cast(s32) (c_transpiler_post_increment(*(LEVEL_STATS.frame_window_buffer.len)))) %
                128;
    } else {
        idx = cast,no_check(s32) LEVEL_STATS.frame_window_buffer.start;
        LEVEL_STATS.frame_window_buffer.start = cast,no_check(u8) ((idx + 1) % 128);
    }
    LEVEL_STATS.frame_window_buffer.buf[idx].ts = cpi.last_time_stamp_seen;
    LEVEL_STATS.frame_window_buffer.buf[idx].size = cast,no_check(u32) size;
    LEVEL_STATS.frame_window_buffer.buf[idx].luma_samples = LUMA_PIC_SIZE;

    if CM.frame_type == cast,no_check(u32) KEY_FRAME {
        LEVEL_STATS.ref_refresh_map = 0;
    } else {
        count: s32 = 0;
        LEVEL_STATS.ref_refresh_map |= vp9_get_refresh_mask(cpi);

        if CM.intra_only == 0 {
            LEVEL_STATS.ref_refresh_map |= (cast(s32) 1) << ((cpi.lst_fb_idx) & 31);
            LEVEL_STATS.ref_refresh_map |= (cast(s32) 1) << ((cpi.gld_fb_idx) & 31);
            LEVEL_STATS.ref_refresh_map |= (cast(s32) 1) << ((cpi.alt_fb_idx) & 31);
        }
        i = 0;
        while i < (cast(s32) 1) << 3 {
            count += LEVEL_STATS.ref_refresh_map >> ((i) & 31) & 1;
            i += 1;
        }
        if count > cast,no_check(s32) LEVEL_SPEC.max_ref_frame_buffers {
            LEVEL_SPEC.max_ref_frame_buffers = cast,no_check(u8) count;
        }
    }

    LEVEL_SPEC.average_bitrate =
        (cast,no_check(float64) LEVEL_STATS.total_compressed_size) /
            125.0 / LEVEL_STATS.time_encoded;

    luma_samples: u64 = 0;
    i = 0;
    while i < cast,no_check(s32) LEVEL_STATS.frame_window_buffer.len {
        idx =
            ((((cast(s32) LEVEL_STATS.frame_window_buffer.start) + cast(s32) LEVEL_STATS.frame_window_buffer.len) - 1) - i) %
                128;
        if i == 0 {
            dur_end = cast,no_check(u64) LEVEL_STATS.frame_window_buffer.buf[idx].ts;
        }
        if (dur_end - cast,no_check(u64) LEVEL_STATS.frame_window_buffer.buf[idx].ts) >= 10000000 {
            break;
        }
        luma_samples += cast,no_check(u64) LEVEL_STATS.frame_window_buffer.buf[idx].luma_samples;
        i += 1;
    }
    if luma_samples > LEVEL_SPEC.max_luma_sample_rate {
        LEVEL_SPEC.max_luma_sample_rate = luma_samples;
    }

    cpb_data_size: float64 = 0.0;
    i = 0;
    while i < 4 {
        if i >= cast,no_check(s32) LEVEL_STATS.frame_window_buffer.len {
            break;
        }
        idx =
            ((((cast(s32) LEVEL_STATS.frame_window_buffer.start) + cast(s32) LEVEL_STATS.frame_window_buffer.len) - 1) - i) %
                128;
        cpb_data_size += cast,no_check(float64) LEVEL_STATS.frame_window_buffer.buf[idx].size;
        i += 1;
    }
    cpb_data_size = cpb_data_size / 125.0;
    if c_transpiler_float_greater(cpb_data_size, LEVEL_SPEC.max_cpb_size) {
        LEVEL_SPEC.max_cpb_size = cpb_data_size;
    }

    if LUMA_PIC_SIZE > LEVEL_SPEC.max_luma_picture_size {
        LEVEL_SPEC.max_luma_picture_size = LUMA_PIC_SIZE;
    }

    if LUMA_PIC_BREADTH > LEVEL_SPEC.max_luma_picture_breadth {
        LEVEL_SPEC.max_luma_picture_breadth = LUMA_PIC_BREADTH;
    }

    LEVEL_SPEC.compression_ratio =
        ((cast,no_check(float64) LEVEL_STATS.total_uncompressed_size) * CM.bit_depth) /
            LEVEL_STATS.total_compressed_size / 8.0;

    if cast,no_check(s32) LEVEL_SPEC.max_col_tiles < (cast(s32) 1) << ((CM.log2_tile_cols) & 31) {
        LEVEL_SPEC.max_col_tiles = cast,no_check(u8) ((cast(s32) 1) << ((CM.log2_tile_cols) & 31));
    }

    if LEVEL_INDEX >= 0 && LEVEL_CONSTRAINT.fail_flag == 0 {
        if LEVEL_SPEC.max_luma_picture_size > VP9_LEVEL_DEFS[LEVEL_INDEX].max_luma_picture_size {
            LEVEL_CONSTRAINT.fail_flag = cast,no_check(u8) ((cast,no_check(s32) LEVEL_CONSTRAINT.fail_flag) | ((cast(s32) 1) << ((LUMA_PIC_SIZE_TOO_LARGE) & 31)));
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_ERROR,
                c_string("Failed to encode to the target level %d. %s"),
                VP9_LEVEL_DEFS[LEVEL_INDEX].level,
                level_fail_messages[LUMA_PIC_SIZE_TOO_LARGE]
            );
        }

        if LEVEL_SPEC.max_luma_picture_breadth > VP9_LEVEL_DEFS[LEVEL_INDEX].max_luma_picture_breadth {
            LEVEL_CONSTRAINT.fail_flag = cast,no_check(u8) ((cast,no_check(s32) LEVEL_CONSTRAINT.fail_flag) | ((cast(s32) 1) << ((LUMA_PIC_BREADTH_TOO_LARGE) & 31)));
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_ERROR,
                c_string("Failed to encode to the target level %d. %s"),
                VP9_LEVEL_DEFS[LEVEL_INDEX].level,
                level_fail_messages[LUMA_PIC_BREADTH_TOO_LARGE]
            );
        }

        if c_transpiler_float_greater(cast,no_check(float64) LEVEL_SPEC.max_luma_sample_rate, ((cast,no_check(float64) VP9_LEVEL_DEFS[LEVEL_INDEX].max_luma_sample_rate) * 1.015)) {
            LEVEL_CONSTRAINT.fail_flag = cast,no_check(u8) ((cast,no_check(s32) LEVEL_CONSTRAINT.fail_flag) | ((cast(s32) 1) << ((LUMA_SAMPLE_RATE_TOO_LARGE) & 31)));
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_ERROR,
                c_string("Failed to encode to the target level %d. %s"),
                VP9_LEVEL_DEFS[LEVEL_INDEX].level,
                level_fail_messages[LUMA_SAMPLE_RATE_TOO_LARGE]
            );
        }

        if LEVEL_SPEC.max_col_tiles > VP9_LEVEL_DEFS[LEVEL_INDEX].max_col_tiles {
            LEVEL_CONSTRAINT.fail_flag = cast,no_check(u8) ((cast,no_check(s32) LEVEL_CONSTRAINT.fail_flag) | ((cast(s32) 1) << ((TOO_MANY_COLUMN_TILE) & 31)));
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_ERROR,
                c_string("Failed to encode to the target level %d. %s"),
                VP9_LEVEL_DEFS[LEVEL_INDEX].level,
                level_fail_messages[TOO_MANY_COLUMN_TILE]
            );
        }

        if LEVEL_SPEC.min_altref_distance < VP9_LEVEL_DEFS[LEVEL_INDEX].min_altref_distance {
            LEVEL_CONSTRAINT.fail_flag = cast,no_check(u8) ((cast,no_check(s32) LEVEL_CONSTRAINT.fail_flag) | ((cast(s32) 1) << ((ALTREF_DIST_TOO_SMALL) & 31)));
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_ERROR,
                c_string("Failed to encode to the target level %d. %s"),
                VP9_LEVEL_DEFS[LEVEL_INDEX].level,
                level_fail_messages[ALTREF_DIST_TOO_SMALL]
            );
        }

        if LEVEL_SPEC.max_ref_frame_buffers > VP9_LEVEL_DEFS[LEVEL_INDEX].max_ref_frame_buffers {
            LEVEL_CONSTRAINT.fail_flag = cast,no_check(u8) ((cast,no_check(s32) LEVEL_CONSTRAINT.fail_flag) | ((cast(s32) 1) << ((TOO_MANY_REF_BUFFER) & 31)));
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_ERROR,
                c_string("Failed to encode to the target level %d. %s"),
                VP9_LEVEL_DEFS[LEVEL_INDEX].level,
                level_fail_messages[TOO_MANY_REF_BUFFER]
            );
        }

        if c_transpiler_float_greater(LEVEL_SPEC.max_cpb_size, VP9_LEVEL_DEFS[LEVEL_INDEX].max_cpb_size) {
            LEVEL_CONSTRAINT.fail_flag = cast,no_check(u8) ((cast,no_check(s32) LEVEL_CONSTRAINT.fail_flag) | ((cast(s32) 1) << ((CPB_TOO_LARGE) & 31)));
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_ERROR,
                c_string("Failed to encode to the target level %d. %s"),
                VP9_LEVEL_DEFS[LEVEL_INDEX].level,
                level_fail_messages[CPB_TOO_LARGE]
            );
        }

        cpb_data_size = 0.0;
        i = 0;
        while i < 4 - 1 {
            if i >= cast,no_check(s32) LEVEL_STATS.frame_window_buffer.len {
                break;
            }
            idx =
                ((((cast(s32) LEVEL_STATS.frame_window_buffer.start) + cast(s32) LEVEL_STATS.frame_window_buffer.len) - 1) - i) %
                    128;
            cpb_data_size += cast,no_check(float64) LEVEL_STATS.frame_window_buffer.buf[idx].size;
            i += 1;
        }
        cpb_data_size = cpb_data_size / 125.0;
        LEVEL_CONSTRAINT.max_frame_size =
            cast,no_check(s32) ((VP9_LEVEL_DEFS[LEVEL_INDEX].max_cpb_size - cpb_data_size) *
                1000.0);
        if cast,no_check(s32) LEVEL_STATS.frame_window_buffer.len < 4 - 1 {
            c_transpiler_compound_shr(*(LEVEL_CONSTRAINT.max_frame_size), (cast(s32) 1), s32, s32);
        }
    }
}

frame_is_reference_in_vp9_encoder :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    cm := *cpi.common;

    if cm.frame_type == cast,no_check(u32) KEY_FRAME ||
        cpi.refresh_last_frame != 0 ||
        cpi.refresh_golden_frame != 0 ||
        cpi.refresh_alt_ref_frame != 0 ||
        cm.refresh_frame_context != 0 ||
        cm.lf.mode_ref_delta_update != 0 ||
        cm.seg.update_map != 0 ||
        cm.seg.update_data != 0 {
        return 1;
    }
    return 0;
}

release_scaled_references :: (cpi: *VP9_COMP_in_vp9_encoder) {
    cm := *cpi.common;

    if cpi.oxcf.pass == 0 && cpi.use_svc == 0 {
        refresh: [3] s32 = ---;
        refresh[0] = cast(s32) (cpi.refresh_last_frame != 0);
        refresh[1] = cast(s32) (cpi.refresh_golden_frame != 0);
        refresh[2] = cast(s32) (cpi.refresh_alt_ref_frame != 0);
        if 1 <= 3 {
            for i: 1..cast(s32) 3 {
                IDX := cpi.scaled_ref_idx[i - 1];
                if IDX != -1 {
                    BUF := cm.buffer_pool.frame_bufs.data + IDX;
                    REF :=
                        get_ref_frame_buffer_in_vp9_encoder(
                            cpi,
                            cast,no_check(MV_REFERENCE_FRAME) i
                        );
                    if refresh[i - 1] != 0 || BUF.buf.y_crop_width == REF.y_crop_width && BUF.buf.y_crop_height == REF.y_crop_height {
                        BUF.ref_count -= 1;
                        cpi.scaled_ref_idx[i - 1] = -1;
                    }
                }
            }
        }
    } else {
        for i: 0..cast(s32) 3 - 1 {
            IDX := cpi.scaled_ref_idx[i];
            if IDX != -1 {
                BUF := cm.buffer_pool.frame_bufs.data + IDX;
                BUF.ref_count -= 1;
                cpi.scaled_ref_idx[i] = -1;
            }
        }
    }
}

get_ref_frame_buffer_in_vp9_encoder :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    ref_frame: MV_REFERENCE_FRAME
) -> *YV12_BUFFER_CONFIG {
    CM := *CPI.common;
    BUF_IDX := get_ref_frame_buf_idx_in_vp9_encoder(CPI, cast,no_check(s32) ref_frame);
    return ifx BUF_IDX != -1 then *CM.buffer_pool.frame_bufs[BUF_IDX].buf else null;
}

get_ref_frame_buf_idx_in_vp9_encoder :: (CPI: *VP9_COMP_in_vp9_encoder, ref_frame: s32) -> s32 {
    CM := *CPI.common;
    MAP_IDX := get_ref_frame_map_idx_in_vp9_encoder(CPI, cast,no_check(MV_REFERENCE_FRAME) ref_frame);
    return ifx MAP_IDX != -1 then CM.ref_frame_map[MAP_IDX] else -1;
}

get_ref_frame_map_idx_in_vp9_encoder :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame: MV_REFERENCE_FRAME) -> s32 {
    if ref_frame == 1 {
        return cpi.lst_fb_idx;
    } else if ref_frame == 2 {
        return cpi.gld_fb_idx;
    } else {
        return cpi.alt_fb_idx;
    }
}

pass0_encode :: (cpi: *VP9_COMP_in_vp9_encoder, size: *u64, dest: *u8, dest_size: u64, frame_flags: *u32) {
    if cpi.oxcf.rc_mode == cast,no_check(u32) CBR {
        vp9_rc_get_one_pass_cbr_params(cpi);
    } else {
        vp9_rc_get_one_pass_vbr_params(cpi);
    }
    encode_frame_to_data_rate_in_vp9_encoder(cpi, size, dest, dest_size, frame_flags, null);
}

encode_frame_to_data_rate_in_vp9_encoder :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    size: *u64,
    dest: *u8,
    dest_size: u64,
    frame_flags: *u32,
    encode_frame_result: *ENCODE_FRAME_RESULT
) {
    CM := *cpi.common;
    OXCF := *cpi.oxcf;
    SEG := *CM.seg;
    t: TX_SIZE = ---;

    if vp9_svc_check_skip_enhancement_layer(cpi) != 0 {
        return;
    }

    set_ext_overrides(cpi);

    if CM.show_existing_frame == 0 {
        set_frame_index(cpi, CM);

        set_ref_sign_bias(cpi);
    }

    if cpi.common.current_video_frame == 0 {
        cpi.deadline_mode_previous_frame = cpi.oxcf.mode;
    }

    CM.lf.mode_ref_delta_update = 0;

    if cpi.oxcf.pass == 2 && cpi.sf.adaptive_interp_filter_search != 0 {
        cpi.sf.interp_filter_search_mask = cast,no_check(INTERP_FILTER_MASK) setup_interp_filter_search_mask(cpi);
    }

    if frame_is_intra_only_in_vp9_encoder(CM) != 0 {
        vp9_reset_segment_features(*CM.seg);

        if SEG.enabled != 0 {
            SEG.update_map = 1;
            SEG.update_data = 1;
        }

        cpi.rc.source_alt_ref_active = 0;

        CM.error_resilient_mode = cast,no_check(s32) OXCF.error_resilient_mode;
        CM.frame_parallel_decoding_mode = cast,no_check(s32) OXCF.frame_parallel_decoding_mode;

        if CM.error_resilient_mode != 0 {
            CM.frame_parallel_decoding_mode = 1;
            CM.reset_frame_context = 0;
            CM.refresh_frame_context = 0;
        } else if CM.intra_only != 0 {
            CM.reset_frame_context = 2;
        }
    }

    if OXCF.tuning == cast,no_check(u32) VP8_TUNE_SSIM {
        init_mb_ssim_rdmult_scaling_buffer(cpi);
        set_mb_ssim_rdmult_scaling(cpi);
    }

    if OXCF.aq_mode == cast,no_check(u32) PERCEPTUAL_AQ {
        init_mb_wiener_var_buffer(cpi);
        set_mb_wiener_variance(cpi);
    }

    init_sb_mul_scale_buffer(cpi);

    save_encode_params(cpi);
    if cpi.ext_ratectrl.ready != 0 &&
        (cpi.ext_ratectrl.funcs.rc_type & cast,no_check(u32) RC_RDMULT) != 0 &&
        cpi.ext_ratectrl.funcs.get_frame_rdmult != null {
        gf_group := *cpi.twopass.gf_group;
        update_type := gf_group.update_type[gf_group.index];
        REF_FRAME_FLAGS := get_ref_frame_flags(cpi);
        ref_frame_bufs: [3] *Ref_Cnt_Buffer = ---;
        curr_frame_buf := get_ref_cnt_buffer_in_vp9_encoder(CM, CM.new_fb_idx);

        USE_ALT_REF := cast(s32) (gf_group.update_type[1] == cast,no_check(u32) ARF_UPDATE);
        ext_rdmult: s32 = -1;
        get_ref_frame_bufs_in_vp9_encoder(cpi, ref_frame_bufs.data);
        codec_status :=
            (cast,no_check(#type (_: *EXT_RATECTRL, _: s32, _: s32, _: s32, _: FRAME_UPDATE_TYPE, _: s32, _: s32, _: **Ref_Cnt_Buffer, _: s32, _: *s32) -> Codec_Err_T) (cast(*void) vp9_extrc_get_frame_rdmult))(
                *cpi.ext_ratectrl,
                curr_frame_buf.frame_index,
                CM.current_frame_coding_index,
                cast,no_check(s32) gf_group.index,
                update_type,
                gf_group.gf_group_size,
                USE_ALT_REF,
                ref_frame_bufs.data,
                REF_FRAME_FLAGS,
                *ext_rdmult
            );
        if codec_status != cast,no_check(u32) CODEC_OK {
            internal_error(*CM.error, codec_status, c_string("vp9_extrc_get_frame_rdmult() failed"));
        }
        cpi.ext_ratectrl.ext_rdmult = ext_rdmult;
    }

    if cpi.sf.recode_loop == cast,no_check(u32) DISALLOW_RECODE {
        if encode_without_recode_loop(cpi, size, dest, dest_size) == 0 {
            return;
        }
    } else {
        encode_with_recode_loop(cpi, size, dest, dest_size);
    }

    if CM.show_existing_frame != 0 {
        ref_cnt_fb_in_vp9_encoder(CM.buffer_pool.frame_bufs.data, *CM.new_fb_idx, CM.ref_frame_map[cpi.alt_fb_idx]);
    }

    if cpi.oxcf.aq_mode == cast,no_check(u32) LOOKAHEAD_AQ {
        vp9_try_disable_lookahead_aq(cpi, size, dest, dest_size);
    }

    if cpi.rc.next_key_frame_forced != 0 && cpi.rc.frames_to_key == 1 {
        cpi.ambient_err = get_y_sse(cpi.source, get_frame_new_buffer_in_vp9_encoder(CM));
    }

    if CM.frame_type == cast,no_check(u32) KEY_FRAME {
        cpi.refresh_last_frame = 1;
    }

    CM.frame_to_show = get_frame_new_buffer_in_vp9_encoder(CM);
    CM.frame_to_show.color_space = CM.color_space;
    CM.frame_to_show.color_range = CM.color_range;
    CM.frame_to_show.render_width = CM.render_width;
    CM.frame_to_show.render_height = CM.render_height;

    loopfilter_frame(cpi, CM);

    if cpi.rc.use_post_encode_drop != 0 {
        save_coding_context(cpi);
    }

    vp9_pack_bitstream(cpi, dest, dest_size, size);

    if cpi.ext_ratectrl.ready != 0 && cpi.ext_ratectrl.funcs.update_encodeframe_result != null {
        codec_status :=
            (cast,no_check(#type (_: *EXT_RATECTRL, _: s64, _: s32) -> Codec_Err_T) (cast(*void) vp9_extrc_update_encodeframe_result))(
                *cpi.ext_ratectrl,
                cast,no_check(s64) (size.* << 3),
                CM.base_qindex
            );
        if codec_status != cast,no_check(u32) CODEC_OK {
            internal_error(*CM.error, codec_status, c_string("vp9_extrc_update_encodeframe_result() failed"));
        }
    }

    if encode_frame_result != null {
        coded_frame_buf := get_ref_cnt_buffer_in_vp9_encoder(CM, CM.new_fb_idx);
        ref_frame_bufs: [3] *Ref_Cnt_Buffer = ---;
        update_type := cpi.twopass.gf_group.update_type[cpi.twopass.gf_group.index];
        quantize_index := vp9_get_quantizer(cpi);
        get_ref_frame_bufs_in_vp9_encoder(cpi, ref_frame_bufs.data);

        update_encode_frame_result_basic(update_type, coded_frame_buf.frame_index, quantize_index, encode_frame_result);
        if cpi.ext_ratectrl.ready != 0 && cpi.ext_ratectrl.log_file != null {
            psnr: PSNR_STATS = ---;
            compute_psnr_stats(
                *psnr,
                cpi.source,
                *coded_frame_buf.buf,
                CM.bit_depth,
                cpi.oxcf.input_bit_depth,
                cpi.svc.spatial_layer_id
            );
            fprintf(
                cpi.ext_ratectrl.log_file,
                c_string("ENCODE_FRAME_RESULT gop_index %d psnr %f bits %zu\n"),
                cast,no_check(s32) cpi.twopass.gf_group.index,
                psnr.psnr[0],
                size.* << 3
            );
        }
    }

    if cpi.rc.use_post_encode_drop != 0 &&
        CM.base_qindex < cpi.rc.worst_quality &&
        cpi.svc.spatial_layer_id == 0 &&
        post_encode_drop_cbr(cpi, size) != 0 {
        restore_coding_context(cpi);
        return;
    }

    cpi.last_frame_dropped = 0;
    cpi.svc.last_layer_dropped[cpi.svc.spatial_layer_id] = 0;
    if cpi.svc.spatial_layer_id == cpi.svc.number_spatial_layers - 1 {
        cpi.svc.num_encoded_top_layer += 1;
    }

    if cpi.svc.temporal_layer_id == 0 {
        if cpi.refresh_last_frame != 0 {
            cpi.svc.fb_idx_upd_tl0[cpi.svc.spatial_layer_id] = cpi.lst_fb_idx;
        } else if cpi.refresh_golden_frame != 0 {
            cpi.svc.fb_idx_upd_tl0[cpi.svc.spatial_layer_id] = cpi.gld_fb_idx;
        } else if cpi.refresh_alt_ref_frame != 0 {
            cpi.svc.fb_idx_upd_tl0[cpi.svc.spatial_layer_id] = cpi.alt_fb_idx;
        }
    }

    if CM.seg.update_map != 0 {
        update_reference_segmentation_map(cpi);
    }

    if frame_is_intra_only_in_vp9_encoder(CM) == 0 {
        release_scaled_references(cpi);
    }
    vp9_update_reference_frames(cpi);

    if CM.show_existing_frame == 0 {
        t = 0;
        while t <= cast(TX_SIZE) 3 {
            full_to_model_counts(cpi.td.counts.coef[t].data, cpi.td.rd_counts.coef_counts[t].data);
            t += 1;
        }

        if CM.error_resilient_mode == 0 && CM.frame_parallel_decoding_mode == 0 {
            if frame_is_intra_only_in_vp9_encoder(CM) == 0 {
                vp9_adapt_mode_probs(CM);
                vp9_adapt_mv_probs(CM, CM.allow_high_precision_mv);
            }
            vp9_adapt_coef_probs(CM);
        }
    }

    cpi.ext_refresh_frame_flags_pending = 0;

    if cpi.refresh_golden_frame == 1 {
        cpi.frame_flags |= cast,no_check(s32) (FRAMEFLAGS_GOLDEN_in_vp9_cx_iface);
    } else {
        cpi.frame_flags &= cast,no_check(s32) (~(FRAMEFLAGS_GOLDEN_in_vp9_cx_iface));
    }

    if cpi.refresh_alt_ref_frame == 1 {
        cpi.frame_flags |= cast,no_check(s32) (FRAMEFLAGS_ALTREF_in_vp9_cx_iface);
    } else {
        cpi.frame_flags &= cast,no_check(s32) (~(FRAMEFLAGS_ALTREF_in_vp9_cx_iface));
    }

    cpi.ref_frame_flags = get_ref_frame_flags(cpi);

    CM.last_frame_type = CM.frame_type;

    vp9_rc_postencode_update(cpi, size.*);

    if cpi.compute_frame_low_motion_onepass != 0 &&
        OXCF.pass == 0 &&
        frame_is_intra_only_in_vp9_encoder(CM) == 0 &&
        (cpi.use_svc == 0 ||
            cpi.use_svc != 0 &&
                cpi.svc.layer_context[cpi.svc.temporal_layer_id].is_key_frame == 0 &&
                cpi.svc.spatial_layer_id == cpi.svc.number_spatial_layers - 1) {
        vp9_compute_frame_low_motion(cpi);
    }

    size.* = ifx 1 > size.* then 1 else size.*;

    if CM.frame_type == cast,no_check(u32) KEY_FRAME {
        frame_flags.* = cast,no_check(u32) (cpi.frame_flags | cast,no_check(s32) (FRAMEFLAGS_KEY_in_vp9_cx_iface));
    } else {
        frame_flags.* = cast,no_check(u32) (cpi.frame_flags & cast,no_check(s32) (~(FRAMEFLAGS_KEY_in_vp9_cx_iface)));
    }

    CM.seg.update_map = 0;
    CM.seg.update_data = 0;
    CM.lf.mode_ref_delta_update = 0;

    CM.last_width = CM.width;
    CM.last_height = CM.height;

    if CM.show_existing_frame == 0 {
        CM.last_show_frame = CM.show_frame;
        CM.prev_frame = CM.cur_frame;
    }

    if CM.show_frame != 0 {
        vp9_swap_mi_and_prev_mi(CM);
        if cpi.use_svc != 0 {
            vp9_inc_frame_in_layer(cpi);
        }
    }
    update_frame_indexes_in_vp9_encoder(CM, CM.show_frame);

    if cpi.use_svc != 0 {
        cpi.svc.layer_context[cpi.svc.spatial_layer_id * cpi.svc.number_temporal_layers + cpi.svc.temporal_layer_id].last_frame_type =
            CM.frame_type;

        cpi.svc.spatial_layer_sync[cpi.svc.spatial_layer_id] = 0;
    }

    cpi.force_update_segmentation = 0;

    if cpi.oxcf.aq_mode == cast,no_check(u32) LOOKAHEAD_AQ {
        vp9_alt_ref_aq_unset_all(cpi.alt_ref_aq, cpi);
    }

    cpi.svc.previous_frame_is_intra_only = CM.intra_only;
    cpi.svc.set_intra_only_frame = 0;
}

vp9_swap_mi_and_prev_mi :: (cm: *VP9_COMMON) {
    temp_base := cm.prev_mi_grid_base;
    temp := cm.prev_mip;

    if cm.show_existing_frame != 0 {
        return;
    }

    cm.prev_mip = cm.mip;
    cm.mip = temp;

    cm.mi = cm.mip + cm.mi_stride + 1;
    cm.prev_mi = cm.prev_mip + cm.mi_stride + 1;

    cm.prev_mi_grid_base = cm.mi_grid_base;
    cm.mi_grid_base = temp_base;
    cm.mi_grid_visible = cm.mi_grid_base + cm.mi_stride + 1;
    cm.prev_mi_grid_visible = cm.prev_mi_grid_base + cm.mi_stride + 1;
}

get_ref_frame_flags :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    MAP := cpi.common.ref_frame_map.data;
    GOLD_IS_LAST := cast(s32) (MAP[cpi.gld_fb_idx] == MAP[cpi.lst_fb_idx]);
    ALT_IS_LAST := cast(s32) (MAP[cpi.alt_fb_idx] == MAP[cpi.lst_fb_idx]);
    GOLD_IS_ALT := cast(s32) (MAP[cpi.gld_fb_idx] == MAP[cpi.alt_fb_idx]);
    flags :=
        ((cast,no_check(s32) (VP9_ALT_FLAG)) | cast,no_check(s32) (VP9_GOLD_FLAG)) | cast,no_check(s32) (VP9_LAST_FLAG);

    if GOLD_IS_LAST != 0 {
        flags &= cast,no_check(s32) (~(VP9_GOLD_FLAG));
    }

    if cpi.rc.frames_till_gf_update_due == 2147483647 &&
        cpi.svc.number_temporal_layers == 1 &&
        cpi.svc.number_spatial_layers == 1 {
        flags &= cast,no_check(s32) (~(VP9_GOLD_FLAG));
    }

    if ALT_IS_LAST != 0 {
        flags &= cast,no_check(s32) (~(VP9_ALT_FLAG));
    }

    if GOLD_IS_ALT != 0 {
        flags &= cast,no_check(s32) (~(VP9_ALT_FLAG));
    }

    return flags;
}

full_to_model_counts :: (model_count: *Vp9_Coeff_Count_Model, full_count: *Vp9_Coeff_Count) {
    j: s32 = ---;
    k: s32 = ---;
    l: s32 = ---;

    i: s32 = 0;
    while i < PLANE_TYPES {
        j = 0;
        while j < 2 {
            k = 0;
            while k < 6 {
                l = 0;
                while l < (ifx k == 0 then cast(s32) 3 else 6) {
                    full_to_model_count(model_count[i][j][k][l].data, full_count[i][j][k][l].data);
                    l += 1;
                }
                k += 1;
            }
            j += 1;
        }
        i += 1;
    }
}

full_to_model_count :: (model_count: *u32, full_count: *u32) {
    model_count[0] = full_count[0];
    model_count[1] = full_count[1];
    model_count[2] = full_count[2];
    if 3 < 11 {
        for n: 3..cast(s32) 11 - 1 {
            model_count[2] += full_count[n];
        }
    }
    model_count[3] = full_count[11];
}

vp9_update_reference_frames :: (cpi: *VP9_COMP_in_vp9_encoder) {
    update_ref_frames(cpi);

    if is_one_pass_svc_in_vp9_encoder(cpi) != 0 {
        vp9_svc_update_ref_frame(cpi);
    }
}

update_ref_frames :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    POOL := CM.buffer_pool;
    GF_GROUP_ := *cpi.twopass.gf_group;

    if cpi.ext_ratectrl.ready != 0 &&
        (cpi.ext_ratectrl.funcs.rc_type & cast,no_check(u32) RC_GOP) != 0 &&
        cpi.ext_ratectrl.funcs.get_gop_decision != null {
        THIS_GF_INDEX := cast,no_check(s32) GF_GROUP_.index;
        UPDATE_REF_IDX := GF_GROUP_.update_ref_idx[THIS_GF_INDEX];
        if GF_GROUP_.update_type[THIS_GF_INDEX] == cast,no_check(u32) KF_UPDATE {
            ref_cnt_fb_in_vp9_encoder(POOL.frame_bufs.data, CM.ref_frame_map.data + 0, CM.new_fb_idx);
            ref_cnt_fb_in_vp9_encoder(POOL.frame_bufs.data, CM.ref_frame_map.data + 1, CM.new_fb_idx);
            ref_cnt_fb_in_vp9_encoder(POOL.frame_bufs.data, CM.ref_frame_map.data + 2, CM.new_fb_idx);
        } else if UPDATE_REF_IDX != -1 {
            ref_cnt_fb_in_vp9_encoder(
                POOL.frame_bufs.data,
                CM.ref_frame_map.data + GF_GROUP_.update_ref_idx[THIS_GF_INDEX],
                CM.new_fb_idx
            );
        }

        NEXT_GF_INDEX := (cast(s32) GF_GROUP_.index) + 1;

        if NEXT_GF_INDEX < GF_GROUP_.gf_group_size {
            cpi.lst_fb_idx = GF_GROUP_.ext_rc_ref[NEXT_GF_INDEX].last_index;
            cpi.gld_fb_idx = GF_GROUP_.ext_rc_ref[NEXT_GF_INDEX].golden_index;
            cpi.alt_fb_idx = GF_GROUP_.ext_rc_ref[NEXT_GF_INDEX].altref_index;
        }

        return;
    }

    if cpi.rc.show_arf_as_gld != 0 {
        tmp := cpi.alt_fb_idx;
        cpi.alt_fb_idx = cpi.gld_fb_idx;
        cpi.gld_fb_idx = tmp;
    } else if CM.show_existing_frame != 0 {
        cpi.lst_fb_idx = cpi.alt_fb_idx;
        cpi.alt_fb_idx = stack_pop_in_vp9_encoder(GF_GROUP_.arf_index_stack.data, GF_GROUP_.stack_size);
        GF_GROUP_.stack_size -= 1;
    }

    if CM.frame_type == cast,no_check(u32) KEY_FRAME {
        ref_cnt_fb_in_vp9_encoder(POOL.frame_bufs.data, CM.ref_frame_map.data + cpi.gld_fb_idx, CM.new_fb_idx);
        ref_cnt_fb_in_vp9_encoder(POOL.frame_bufs.data, CM.ref_frame_map.data + cpi.alt_fb_idx, CM.new_fb_idx);
    } else if vp9_preserve_existing_gf_in_vp9_encoder(cpi) != 0 {
        ref_cnt_fb_in_vp9_encoder(POOL.frame_bufs.data, CM.ref_frame_map.data + cpi.alt_fb_idx, CM.new_fb_idx);

        tmp := cpi.alt_fb_idx;
        cpi.alt_fb_idx = cpi.gld_fb_idx;
        cpi.gld_fb_idx = tmp;
    } else {
        if cpi.refresh_alt_ref_frame != 0 {
            arf_idx := GF_GROUP_.top_arf_idx;

            stack_push_in_vp9_encoder(GF_GROUP_.arf_index_stack.data, cpi.alt_fb_idx, GF_GROUP_.stack_size);
            GF_GROUP_.stack_size += 1;

            ref_cnt_fb_in_vp9_encoder(POOL.frame_bufs.data, CM.ref_frame_map.data + arf_idx, CM.new_fb_idx);
            copy_memory(
                cpi.interp_filter_selected[3].data,
                cpi.interp_filter_selected[0].data,
                4 * cast(u64) size_of(s32)
            );

            cpi.alt_fb_idx = arf_idx;
        }

        if cpi.refresh_golden_frame != 0 {
            ref_cnt_fb_in_vp9_encoder(POOL.frame_bufs.data, CM.ref_frame_map.data + cpi.gld_fb_idx, CM.new_fb_idx);
            if cpi.rc.is_src_frame_alt_ref == 0 {
                copy_memory(
                    cpi.interp_filter_selected[2].data,
                    cpi.interp_filter_selected[0].data,
                    4 * cast(u64) size_of(s32)
                );
            } else {
                copy_memory(
                    cpi.interp_filter_selected[2].data,
                    cpi.interp_filter_selected[3].data,
                    4 * cast(u64) size_of(s32)
                );
            }
        }
    }

    if cpi.refresh_last_frame != 0 {
        ref_cnt_fb_in_vp9_encoder(POOL.frame_bufs.data, CM.ref_frame_map.data + cpi.lst_fb_idx, CM.new_fb_idx);
        if cpi.rc.is_src_frame_alt_ref == 0 {
            copy_memory(
                cpi.interp_filter_selected[1].data,
                cpi.interp_filter_selected[0].data,
                4 * cast(u64) size_of(s32)
            );
        }
    }

    if GF_GROUP_.update_type[GF_GROUP_.index] == cast,no_check(u32) MID_OVERLAY_UPDATE {
        cpi.alt_fb_idx = stack_pop_in_vp9_encoder(GF_GROUP_.arf_index_stack.data, GF_GROUP_.stack_size);
        GF_GROUP_.stack_size -= 1;
    }
}

stack_pop_in_vp9_encoder :: (stack: *s32, stack_size: s32) -> s32 {
    R := stack[0];
    if 1 < stack_size {
        for idx: 1..stack_size - 1 {
            stack[idx - 1] = stack[idx];
        }
    }

    return R;
}

stack_push_in_vp9_encoder :: (stack: *s32, new_item: s32, stack_size: s32) {
    idx := stack_size;
    while idx > 0 {
        stack[idx] = stack[idx - 1];
        idx -= 1;
    }
    stack[0] = new_item;
}

vp9_preserve_existing_gf_in_vp9_encoder :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if cpi.refresh_golden_frame != 0 && cpi.rc.is_src_frame_alt_ref != 0 && cpi.use_svc == 0 {
        return 1;
    }
    return 0;
}

update_reference_segmentation_map :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    mi_8x8_ptr := CM.mi_grid_visible;
    cache_ptr := CM.last_frame_seg_map;
    col: s32 = ---;

    row: s32 = 0;
    while row < CM.mi_rows {
        mi_8x8 := mi_8x8_ptr;
        cache := cache_ptr;
        col = 0;
        while col < CM.mi_cols {
            cache[0] = cast,no_check(u8) mi_8x8[0].segment_id;
            col += 1;
            mi_8x8 += 1;
            cache += 1;
        }
        mi_8x8_ptr += CM.mi_stride;
        cache_ptr += CM.mi_cols;
        row += 1;
    }
}

restore_coding_context :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CC := *cpi.coding_context;
    cm := *cpi.common;

    {
        #assert cpi.td.mb.nmvjointcost.count * size_of(s32) == CC.nmvjointcost.count * size_of(s32);

        copy_memory(cpi.td.mb.nmvjointcost.data, CC.nmvjointcost.data, CC.nmvjointcost.count * size_of(s32));
    }

    copy_memory(
        cpi.nmvcosts[0],
        CC.nmvcosts[0].data,
        cast,no_check(u64) (((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1) << 1 + 1) *
        size_of(s32)
    );
    copy_memory(
        cpi.nmvcosts[1],
        CC.nmvcosts[1].data,
        cast,no_check(u64) (((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1) << 1 + 1) *
        size_of(s32)
    );
    copy_memory(
        cpi.nmvcosts_hp[0],
        CC.nmvcosts_hp[0].data,
        cast,no_check(u64) (((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1) << 1 + 1) *
        size_of(s32)
    );
    copy_memory(
        cpi.nmvcosts_hp[1],
        CC.nmvcosts_hp[1].data,
        cast,no_check(u64) (((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1) << 1 + 1) *
        size_of(s32)
    );

    {
        #assert cm.seg.pred_probs.count == CC.segment_pred_probs.count;

        copy_memory(cm.seg.pred_probs.data, CC.segment_pred_probs.data, CC.segment_pred_probs.count);
    }

    copy_memory(
        cm.last_frame_seg_map,
        cpi.coding_context.last_frame_seg_map_copy,
        cast,no_check(u64) (cm.mi_rows * cm.mi_cols)
    );

    {
        #assert cm.lf.last_ref_deltas.count == CC.last_ref_lf_deltas.count;

        copy_memory(cm.lf.last_ref_deltas.data, CC.last_ref_lf_deltas.data, CC.last_ref_lf_deltas.count);
    }
    {
        #assert cm.lf.last_mode_deltas.count == CC.last_mode_lf_deltas.count;

        copy_memory(cm.lf.last_mode_deltas.data, CC.last_mode_lf_deltas.data, CC.last_mode_lf_deltas.count);
    }

    assignment_8: FRAME_CONTEXT = CC.fc;
    ((cm.fc).*) = assignment_8;
}

get_ref_cnt_buffer_in_vp9_encoder :: (cm: *VP9_COMMON, fb_idx: s32) -> *Ref_Cnt_Buffer {
    return ifx fb_idx != -1 then cm.buffer_pool.frame_bufs.data + fb_idx else null;
}

compute_psnr_stats :: (
    result: *PSNR_STATS,
    source_frame: *YV12_BUFFER_CONFIG,
    coded_frame: *YV12_BUFFER_CONFIG,
    bit_depth: u32,
    input_bit_depth: u32,
    spatial_layer_id: s32
) {
    psnr: PSNR_STATS = ---;

    calc_psnr(source_frame, coded_frame, *psnr, spatial_layer_id);

    result.* = psnr;
}

vp9_get_quantizer :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    return cpi.common.base_qindex;
}

update_encode_frame_result_basic :: (
    update_type: FRAME_UPDATE_TYPE,
    show_idx: s32,
    quantize_index: s32,
    encode_frame_result: *ENCODE_FRAME_RESULT
) {
    encode_frame_result.show_idx = show_idx;
    encode_frame_result.update_type = update_type;
    encode_frame_result.quantize_index = quantize_index;
}

get_ref_frame_bufs_in_vp9_encoder :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame_bufs: **Ref_Cnt_Buffer) {
    CM := *cpi.common;

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame < 4 {
        ref_frame_buf_idx := get_ref_frame_buf_idx_in_vp9_encoder(cpi, cast,no_check(s32) ref_frame);
        inter_ref_idx := mv_ref_frame_to_inter_ref_idx_in_vp9_encoder(ref_frame);
        ref_frame_bufs[inter_ref_idx] = get_ref_cnt_buffer_in_vp9_encoder(CM, ref_frame_buf_idx);
        ref_frame += 1;
    }
}

save_coding_context :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CC := *cpi.coding_context;
    cm := *cpi.common;

    {
        #assert CC.nmvjointcost.count * size_of(s32) == cpi.td.mb.nmvjointcost.count * size_of(s32);

        copy_memory(CC.nmvjointcost.data, cpi.td.mb.nmvjointcost.data, cpi.td.mb.nmvjointcost.count * size_of(s32));
    }

    copy_memory(
        CC.nmvcosts[0].data,
        cpi.nmvcosts[0],
        cast,no_check(u64) (((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1) << 1 + 1) *
        size_of(s32)
    );
    copy_memory(
        CC.nmvcosts[1].data,
        cpi.nmvcosts[1],
        cast,no_check(u64) (((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1) << 1 + 1) *
        size_of(s32)
    );
    copy_memory(
        CC.nmvcosts_hp[0].data,
        cpi.nmvcosts_hp[0],
        cast,no_check(u64) (((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1) << 1 + 1) *
        size_of(s32)
    );
    copy_memory(
        CC.nmvcosts_hp[1].data,
        cpi.nmvcosts_hp[1],
        cast,no_check(u64) (((cast(s32) 1) << ((((cast,no_check(s32) ((11 + 1))) + 2)) & 31) - 1) << 1 + 1) *
        size_of(s32)
    );

    {
        #assert CC.segment_pred_probs.count == cm.seg.pred_probs.count;

        copy_memory(CC.segment_pred_probs.data, cm.seg.pred_probs.data, cm.seg.pred_probs.count);
    }

    copy_memory(
        cpi.coding_context.last_frame_seg_map_copy,
        cm.last_frame_seg_map,
        cast,no_check(u64) (cm.mi_rows * cm.mi_cols)
    );

    {
        #assert CC.last_ref_lf_deltas.count == cm.lf.last_ref_deltas.count;

        copy_memory(CC.last_ref_lf_deltas.data, cm.lf.last_ref_deltas.data, cm.lf.last_ref_deltas.count);
    }
    {
        #assert CC.last_mode_lf_deltas.count == cm.lf.last_mode_deltas.count;

        copy_memory(CC.last_mode_lf_deltas.data, cm.lf.last_mode_deltas.data, cm.lf.last_mode_deltas.count);
    }

    assignment_9: FRAME_CONTEXT = cm.fc.*;
    ((*CC.fc).*) = assignment_9;
}

loopfilter_frame :: (cpi: *VP9_COMP_in_vp9_encoder, cm: *VP9_COMMON) {
    xd := *cpi.td.mb.e_mbd;
    lf := *cm.lf;
    is_reference_frame :=
        cast(s32) (cm.frame_type == cast,no_check(u32) KEY_FRAME || cpi.refresh_last_frame != 0 ||
            cpi.refresh_golden_frame != 0 || cpi.refresh_alt_ref_frame != 0);
    if cpi.use_svc != 0 && cpi.svc.temporal_layering_mode == cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_BYPASS {
        is_reference_frame = cast(s32) (cpi.svc.non_reference_frame == 0);
    }

    if cm.show_existing_frame != 0 {
        lf.filter_level = 0;
        return;
    }

    if cpi.loopfilter_ctrl == cast,no_check(u32) NO_LOOPFILTER ||
        is_reference_frame == 0 && cpi.loopfilter_ctrl == cast,no_check(u32) LOOPFILTER_REFERENCE {
        lf.filter_level = 0;
        extend_frame_inner_borders_c(cm.frame_to_show);
        return;
    }

    if xd.lossless != 0 {
        lf.filter_level = 0;
        lf.last_filt_level = 0;
    } else {
        if cpi.rc.is_src_frame_alt_ref == 0 {
            if cpi.common.frame_type == cast,no_check(u32) KEY_FRAME && cpi.rc.this_key_frame_forced == 0 {
                lf.last_filt_level = 0;
            }
            (cast,no_check(#type (_: *Yv12_Buffer_Config, _: *VP9_COMP_in_vp9_encoder, _: LPF_PICK_METHOD)) (cast(*void) vp9_pick_filter_level))(
                cpi.source,
                cpi,
                cpi.sf.lpf_pick
            );
            lf.last_filt_level = lf.filter_level;
        } else {
            lf.filter_level = 0;
        }
    }

    if lf.filter_level > 0 && is_reference_frame != 0 {
        vp9_build_mask_frame(cm, lf.filter_level, 0);

        if cpi.num_workers > 1 {
            vp9_loop_filter_frame_mt(
                cm.frame_to_show,
                cm,
                xd.plane.data,
                lf.filter_level,
                0,
                0,
                cpi.workers,
                cpi.num_workers,
                *cpi.lf_row_sync
            );
        } else {
            vp9_loop_filter_frame(cm.frame_to_show, cm, xd, lf.filter_level, 0, 0);
        }
    }

    extend_frame_inner_borders_c(cm.frame_to_show);
}

vp9_try_disable_lookahead_aq :: (cpi: *VP9_COMP_in_vp9_encoder, size: *u64, dest: *u8, dest_size: u64) {
    if cpi.common.seg.enabled != 0 {
    }
}

encode_with_recode_loop :: (cpi: *VP9_COMP_in_vp9_encoder, size: *u64, dest: *u8, dest_size: u64) {
    OXCF := *cpi.oxcf;
    CM := *cpi.common;
    RC := *cpi.rc;
    bottom_index, top_index: s32 = ---;
    loop_count: s32 = 0;
    loop_at_this_size: s32 = 0;
    loop: s32 = 0;
    overshoot_seen: s32 = 0;
    undershoot_seen: s32 = 0;
    frame_over_shoot_limit: s32 = ---;
    frame_under_shoot_limit: s32 = ---;
    q: s32 = 0;
    q_low: s32 = 0;
    q_high: s32 = 0;

    ORIG_RC_MAX_FRAME_BANDWIDTH := RC.max_frame_bandwidth;

    if CM.show_existing_frame != 0 {
        RC.this_frame_target = 0;
        if is_psnr_calc_enabled(cpi) != 0 {
            set_raw_source_frame(cpi);
        }
        return;
    }

    set_size_independent_vars(cpi);

    enable_acl :=
        (ifx cpi.sf.allow_acl != 0 then cast(s32) (CM.frame_type == cast,no_check(u32) KEY_FRAME ||
            cpi.twopass.gf_group.index == 1) else 0);

    while loop_label := true {
        while loop_2 := true {
            set_frame_size(cpi);

            if loop_count == 0 || cpi.resize_pending != 0 {
                set_size_dependent_vars(cpi, *q, *bottom_index, *top_index);

                set_mv_search_params(cpi);

                overshoot_seen = 0;
                undershoot_seen = 0;

                cpi.resize_pending = 0;

                q_low = bottom_index;
                q_high = top_index;

                loop_at_this_size = 0;
            }

            if loop_count == 0 {
                vp9_rc_compute_frame_size_bounds(
                    cpi,
                    RC.this_frame_target,
                    *frame_under_shoot_limit,
                    *frame_over_shoot_limit
                );
            }

            cpi.source =
                vp9_scale_if_required(
                    CM,
                    cpi.un_scaled_source,
                    *cpi.scaled_source,
                    cast(s32) (OXCF.pass == 0),
                    0,
                    0
                );

            if is_psnr_calc_enabled(cpi) != 0 {
                cpi.raw_source_frame = cpi.source;
            }

            if cpi.unscaled_last_source != null {
                cpi.last_source =
                    vp9_scale_if_required(
                        CM,
                        cpi.unscaled_last_source,
                        *cpi.scaled_last_source,
                        cast(s32) (OXCF.pass == 0),
                        0,
                        0
                    );
            }

            if frame_is_intra_only_in_vp9_encoder(CM) == 0 {
                if loop_count > 0 {
                    release_scaled_references(cpi);
                }
                vp9_scale_references(cpi);
            }

            gf_group := *cpi.twopass.gf_group;
            ext_rc_delta_q_uv: s32 = 0;
            if cpi.ext_ratectrl.ready != 0 &&
                (cpi.ext_ratectrl.funcs.rc_type & cast,no_check(u32) RC_QP) != 0 &&
                cpi.ext_ratectrl.funcs.get_encodeframe_decision != null {
                encode_frame_decision: Rc_Encodeframe_Decision_T = ---;
                sb_size := (cast(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[12]) * (cast(s32) 1) << 3;
                frame_height_sb := (CM.height + sb_size - 1) / sb_size;
                frame_width_sb := (CM.width + sb_size - 1) / sb_size;
                encode_frame_decision.sb_params_list =
                    cast(*Sb_Params) calloc_2(
                        cast,no_check(u64) (frame_height_sb * frame_width_sb),
                        size_of(Sb_Params)
                    );

                if encode_frame_decision.sb_params_list == null {
                    internal_error(
                        *CM.error,
                        cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                        c_string("Failed to allocate encode_frame_decision.sb_params_list")
                    );
                }
                codec_status :=
                    (cast,no_check(#type (_: *EXT_RATECTRL, _: s32, _: *Rc_Encodeframe_Decision_T) -> Codec_Err_T) (cast(*void) vp9_extrc_get_encodeframe_decision))(
                        *cpi.ext_ratectrl,
                        cast,no_check(s32) gf_group.index,
                        *encode_frame_decision
                    );
                if codec_status != cast,no_check(u32) CODEC_OK {
                    internal_error(*CM.error, codec_status, c_string("vp9_extrc_get_encodeframe_decision() failed"));
                }
                {
                    idx: s32 = 0;
                    while idx < frame_height_sb * frame_width_sb {
                        cpi.sb_mul_scale[idx] =
                            ((cast,no_check(s64) encode_frame_decision.sb_params_list[idx].rdmult) * 256) /
                                cast(s64) (encode_frame_decision.rdmult + 1);
                        idx += 1;
                    }
                }
                deallocate_memory(cast(*void) encode_frame_decision.sb_params_list);

                if encode_frame_decision.q_index != -1 {
                    q = encode_frame_decision.q_index;
                }
                ext_rc_delta_q_uv = encode_frame_decision.delta_q_uv;
            }

            if cpi.ext_ratectrl.ready != 0 && cpi.ext_ratectrl.log_file != null {
                fprintf(
                    cpi.ext_ratectrl.log_file,
                    c_string("ENCODE_FRAME_INFO gop_index %d update_type %d q %d\n"),
                    cast,no_check(s32) gf_group.index,
                    gf_group.update_type[gf_group.index],
                    q
                );
            }

            vp9_set_quantizer(cpi, q, ext_rc_delta_q_uv);

            if loop_count == 0 {
                setup_frame(cpi);
            }

            if OXCF.aq_mode == cast,no_check(u32) VARIANCE_AQ {
                vp9_vaq_frame_setup(cpi);
            } else if OXCF.aq_mode == cast,no_check(u32) EQUATOR360_AQ {
                vp9_360aq_frame_setup(cpi);
            } else if OXCF.aq_mode == cast,no_check(u32) COMPLEXITY_AQ {
                vp9_setup_in_frame_q_adj(cpi);
            } else if OXCF.aq_mode == cast,no_check(u32) LOOKAHEAD_AQ {
                vp9_alt_ref_aq_setup_map(cpi.alt_ref_aq, cpi);
            } else if OXCF.aq_mode == cast,no_check(u32) PSNR_AQ {
                vp9_psnr_aq_mode_setup(*CM.seg);
            }

            vp9_encode_frame(cpi);

            if cpi.sf.recode_loop >= cast,no_check(u32) ALLOW_RECODE_KFARFGF {
                save_coding_context(cpi);
                if cpi.sf.use_nonrd_pick_mode == 0 {
                    vp9_pack_bitstream(cpi, dest, dest_size, size);
                }

                RC.projected_frame_size = (cast,no_check(s32) size.*) << 3;

                if frame_over_shoot_limit == 0 {
                    frame_over_shoot_limit = 1;
                }
            }

            if cpi.ext_ratectrl.ready != 0 && (cpi.ext_ratectrl.funcs.rc_type & cast,no_check(u32) RC_QP) != 0 {
                break loop_label;
            }

            if OXCF.rc_mode == cast,no_check(u32) Q {
                loop = 0;
            } else if CM.frame_type == cast,no_check(u32) KEY_FRAME &&
                RC.this_key_frame_forced != 0 &&
                RC.projected_frame_size < RC.max_frame_bandwidth {
                last_q := q;

                high_err_target := cpi.ambient_err;
                low_err_target := cpi.ambient_err >> 1;

                kf_err := get_y_sse(cpi.source, get_frame_new_buffer_in_vp9_encoder(CM));

                kf_err += cast(s64) (kf_err == 0);

                if kf_err > high_err_target && RC.projected_frame_size <= frame_over_shoot_limit ||
                    kf_err > low_err_target && RC.projected_frame_size <= frame_under_shoot_limit {
                    q_high = ifx q > q_low then q - 1 else q_low;

                    q = cast,no_check(s32) ((cast(s64) q) * high_err_target / kf_err);
                    q = ifx q < (q_high + q_low) >> 1 then q else (q_high + q_low) >> 1;
                } else if kf_err < low_err_target && RC.projected_frame_size >= frame_under_shoot_limit {
                    q_low = ifx q < q_high then q + 1 else q_high;

                    q = cast,no_check(s32) ((cast(s64) q) * low_err_target / kf_err);
                    q = ifx q < (q_high + q_low + 1) >> 1 then q else (q_high + q_low + 1) >> 1;
                }

                q = clamp_in_vp9_encoder(q, q_low, q_high);

                loop = cast(s32) (q != last_q);
            } else if recode_loop_test_in_vp9_encoder(
                cpi,
                frame_over_shoot_limit,
                frame_under_shoot_limit,
                q,
                max(q_high, top_index),
                bottom_index
            ) != 0 {
                last_q := q;
                retries: s32 = 0;
                qstep: s32 = ---;

                if cpi.resize_pending == 1 {
                    cpi.rc.frame_size_selector = ((cast,no_check(u32) SCALE_STEP1) - cpi.rc.frame_size_selector);
                    cpi.rc.next_frame_size_selector = cpi.rc.frame_size_selector;

                    loop_count += 1;
                    loop = 1;
                    break loop_2;
                }

                if RC.projected_frame_size > RC.this_frame_target {
                    if q == q_high &&
                        (RC.projected_frame_size >= RC.max_frame_bandwidth ||
                            RC.is_src_frame_alt_ref == 0 && RC.projected_frame_size >= big_rate_miss_high_threshold(cpi)) {
                        max_rate :=
                            (ifx 1 > (ifx RC.max_frame_bandwidth < big_rate_miss_high_threshold(cpi) then RC.max_frame_bandwidth else big_rate_miss_high_threshold(cpi)) then 1 else (ifx RC.max_frame_bandwidth < big_rate_miss_high_threshold(cpi) then RC.max_frame_bandwidth else big_rate_miss_high_threshold(cpi)));
                        q_val_high := vp9_convert_qindex_to_q(q_high, CM.bit_depth);
                        q_val_high = q_val_high * ((cast,no_check(float64) RC.projected_frame_size) / max_rate);
                        q_high = vp9_convert_q_to_qindex(q_val_high, CM.bit_depth);
                        q_high = clamp_in_vp9_encoder(q_high, RC.best_quality, RC.worst_quality);
                    }

                    qstep = get_qstep_adj(RC.projected_frame_size, RC.this_frame_target);
                    q_low = ifx q + qstep < q_high then q + qstep else q_high;

                    if undershoot_seen != 0 || loop_at_this_size > 1 {
                        vp9_rc_update_rate_correction_factors(cpi);

                        q = (q_high + q_low + 1) / 2;
                    } else {
                        vp9_rc_update_rate_correction_factors(cpi);

                        q = vp9_rc_regulate_q(cpi, RC.this_frame_target, bottom_index, max(q_high, top_index));

                        while q < q_low && retries < 10 {
                            vp9_rc_update_rate_correction_factors(cpi);
                            q = vp9_rc_regulate_q(cpi, RC.this_frame_target, bottom_index, max(q_high, top_index));
                            retries += 1;
                        }
                    }

                    overshoot_seen = 1;
                } else {
                    qstep = get_qstep_adj(RC.this_frame_target, RC.projected_frame_size);
                    q_high = ifx q - qstep > q_low then q - qstep else q_low;

                    if overshoot_seen != 0 || loop_at_this_size > 1 {
                        vp9_rc_update_rate_correction_factors(cpi);
                        q = (q_high + q_low) / 2;
                    } else {
                        vp9_rc_update_rate_correction_factors(cpi);
                        q = vp9_rc_regulate_q(cpi, RC.this_frame_target, min(q_low, bottom_index), top_index);

                        if OXCF.rc_mode == cast,no_check(u32) CQ && q < q_low {
                            q_low = q;
                        }

                        while q > q_high && retries < 10 {
                            vp9_rc_update_rate_correction_factors(cpi);
                            q = vp9_rc_regulate_q(cpi, RC.this_frame_target, min(q_low, bottom_index), top_index);
                            retries += 1;
                        }
                    }
                    undershoot_seen = 1;
                }

                q = clamp_in_vp9_encoder(q, q_low, q_high);

                loop = cast(s32) (q != last_q);
            } else {
                loop = 0;
            }

            if RC.is_src_frame_alt_ref != 0 && RC.projected_frame_size < RC.max_frame_bandwidth {
                loop = 0;
            }

            if loop != 0 {
                loop_count += 1;
                loop_at_this_size += 1;
            }

            if cpi.sf.recode_loop >= cast,no_check(u32) ALLOW_RECODE_KFARFGF {
                if loop != 0 {
                    restore_coding_context(cpi);
                }
            }
            break loop_2;
        }
        if loop == 0 break loop_label;
    }

    RC.max_frame_bandwidth = ORIG_RC_MAX_FRAME_BANDWIDTH;

    if frame_is_kf_gf_arf_in_vp9_encoder(cpi) == 0 {
        if RC.is_src_frame_alt_ref == 0 && q > cpi.twopass.active_worst_quality {
            cpi.twopass.active_worst_quality = q;
        } else if OXCF.vbr_corpus_complexity != 0 && q == q_low && RC.projected_frame_size < RC.this_frame_target {
            cpi.twopass.active_worst_quality =
                ifx q > cpi.twopass.active_worst_quality -
                    1 then q else cpi.twopass.active_worst_quality - 1;
        }
    }

    if enable_acl != 0 {
        THRESH := compute_context_model_thresh(cpi);
        DIFF := compute_context_model_diff(CM);
        if DIFF >= THRESH {
            vp9_encode_frame(cpi);
        }
    }
    if cpi.sf.recode_loop >= cast,no_check(u32) ALLOW_RECODE_KFARFGF {
        restore_coding_context(cpi);
    }
}

compute_context_model_thresh :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    CM := *CPI.common;
    OXCF := *CPI.oxcf;
    FRAME_SIZE := (CM.width * CM.height) >> 10;
    BITRATE := cast,no_check(s32) (OXCF.target_bandwidth >> 10);
    QINDEX_FACTOR := CM.base_qindex + (cast(s32) 255) >> 1;

    THRESH := ((128 * FRAME_SIZE - 8 * BITRATE) * QINDEX_FACTOR) >> 9;

    return THRESH;
}

compute_context_model_diff :: (CM: *VP9_COMMON) -> s32 {
    PRE_FC := *(cast(*Frame_Contexts) (CM.frame_contexts))[CM.frame_context_idx];
    CUR_FC := CM.fc;
    counts := *CM.counts;
    pre_last_prob, cur_last_prob: Prob = ---;
    diff: s32 = 0;
    j: s32 = ---;
    k: s32 = ---;
    l: s32 = ---;
    m: s32 = ---;
    n: s32 = ---;

    i: s32 = 0;
    while i < 4 {
        j = 0;
        while j < (cast,no_check(s32) ((9 + 1))) - 1 {
            diff +=
                (cast,no_check(s32) counts.y_mode[i][j]) *
                    ((cast(s32) PRE_FC.y_mode_prob[i][j]) - cast(s32) CUR_FC.y_mode_prob[i][j]);
            j += 1;
        }
        pre_last_prob = cast,no_check(Prob) (255 - cast(s32) PRE_FC.y_mode_prob[i][(cast,no_check(s32) ((9 + 1))) - 2]);
        cur_last_prob = cast,no_check(Prob) (255 - cast(s32) CUR_FC.y_mode_prob[i][(cast,no_check(s32) ((9 + 1))) - 2]);

        diff +=
            (cast,no_check(s32) counts.y_mode[i][(cast,no_check(s32) ((9 + 1))) - 1]) *
                ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);
        i += 1;
    }

    i = 0;
    while i < 9 + 1 {
        j = 0;
        while j < (cast,no_check(s32) ((9 + 1))) - 1 {
            diff +=
                (cast,no_check(s32) counts.uv_mode[i][j]) *
                    ((cast(s32) PRE_FC.uv_mode_prob[i][j]) - cast(s32) CUR_FC.uv_mode_prob[i][j]);
            j += 1;
        }
        pre_last_prob =
            cast,no_check(Prob) (255 -
                cast(s32) PRE_FC.uv_mode_prob[i][(cast,no_check(s32) ((9 + 1))) - 2]);
        cur_last_prob =
            cast,no_check(Prob) (255 -
                cast(s32) CUR_FC.uv_mode_prob[i][(cast,no_check(s32) ((9 + 1))) - 2]);

        diff +=
            (cast,no_check(s32) counts.uv_mode[i][(cast,no_check(s32) ((9 + 1))) - 1]) *
                ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);
        i += 1;
    }

    i = 0;
    while i < 4 * 4 {
        j = 0;
        while j < (cast,no_check(s32) (PARTITION_TYPES)) - 1 {
            diff +=
                (cast,no_check(s32) counts.partition[i][j]) *
                    ((cast(s32) PRE_FC.partition_prob[i][j]) - cast(s32) CUR_FC.partition_prob[i][j]);
            j += 1;
        }
        pre_last_prob =
            cast,no_check(Prob) (255 -
                cast(s32) PRE_FC.partition_prob[i][(cast,no_check(s32) (PARTITION_TYPES)) - 2]);
        cur_last_prob =
            cast,no_check(Prob) (255 -
                cast(s32) CUR_FC.partition_prob[i][(cast,no_check(s32) (PARTITION_TYPES)) - 2]);

        diff +=
            (cast,no_check(s32) counts.partition[i][(cast,no_check(s32) (PARTITION_TYPES)) - 1]) *
                ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);
        i += 1;
    }

    i = 0;
    while i < cast,no_check(s32) (cast(TX_SIZE) 4) {
        j = 0;
        while j < PLANE_TYPES {
            k = 0;
            while k < 2 {
                l = 0;
                while l < 6 {
                    m = 0;
                    while m < (ifx l == 0 then cast(s32) 3 else 6) {
                        n = 0;
                        while n < 3 {
                            diff +=
                                (cast,no_check(s32) counts.coef[i][j][k][l][m][n]) *
                                    ((cast(s32) PRE_FC.coef_probs[i][j][k][l][m][n]) - cast(s32) CUR_FC.coef_probs[i][j][k][l][m][n]);
                            n += 1;
                        }

                        pre_last_prob = cast,no_check(Prob) (255 - cast(s32) PRE_FC.coef_probs[i][j][k][l][m][3 - 1]);
                        cur_last_prob = cast,no_check(Prob) (255 - cast(s32) CUR_FC.coef_probs[i][j][k][l][m][3 - 1]);

                        diff +=
                            (cast,no_check(s32) counts.coef[i][j][k][l][m][3]) *
                                ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);
                        m += 1;
                    }
                    l += 1;
                }
                k += 1;
            }
            j += 1;
        }
        i += 1;
    }

    i = 0;
    while i < 3 + 1 {
        j = 0;
        while j < 3 - 1 {
            diff +=
                (cast,no_check(s32) counts.switchable_interp[i][j]) *
                    ((cast(s32) PRE_FC.switchable_interp_prob[i][j]) - cast(s32) CUR_FC.switchable_interp_prob[i][j]);
            j += 1;
        }
        pre_last_prob = cast,no_check(Prob) (255 - cast(s32) PRE_FC.switchable_interp_prob[i][3 - 2]);
        cur_last_prob = cast,no_check(Prob) (255 - cast(s32) CUR_FC.switchable_interp_prob[i][3 - 2]);

        diff +=
            (cast,no_check(s32) counts.switchable_interp[i][3 - 1]) *
                ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);
        i += 1;
    }

    i = 0;
    while i < 7 {
        j = 0;
        while j < (cast,no_check(s32) ((1 + 13))) - 10 - 1 {
            diff +=
                (cast,no_check(s32) counts.inter_mode[i][j]) *
                    ((cast(s32) PRE_FC.inter_mode_probs[i][j]) - cast(s32) CUR_FC.inter_mode_probs[i][j]);
            j += 1;
        }
        pre_last_prob =
            cast,no_check(Prob) (255 -
                cast(s32) PRE_FC.inter_mode_probs[i][(cast,no_check(s32) ((1 + 13))) - 10 - 2]);
        cur_last_prob =
            cast,no_check(Prob) (255 -
                cast(s32) CUR_FC.inter_mode_probs[i][(cast,no_check(s32) ((1 + 13))) - 10 - 2]);

        diff +=
            (cast,no_check(s32) counts.inter_mode[i][(cast,no_check(s32) ((1 + 13))) - 10 - 1]) *
                ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);
        i += 1;
    }

    i = 0;
    while i < 4 {
        diff +=
            (cast,no_check(s32) counts.intra_inter[i][0]) *
                ((cast(s32) PRE_FC.intra_inter_prob[i]) - cast(s32) CUR_FC.intra_inter_prob[i]);

        pre_last_prob = cast,no_check(Prob) (255 - cast(s32) PRE_FC.intra_inter_prob[i]);
        cur_last_prob = cast,no_check(Prob) (255 - cast(s32) CUR_FC.intra_inter_prob[i]);

        diff += (cast,no_check(s32) counts.intra_inter[i][1]) * ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);
        i += 1;
    }

    i = 0;
    while i < 5 {
        diff +=
            (cast,no_check(s32) counts.comp_inter[i][0]) *
                ((cast(s32) PRE_FC.comp_inter_prob[i]) - cast(s32) CUR_FC.comp_inter_prob[i]);

        pre_last_prob = cast,no_check(Prob) (255 - cast(s32) PRE_FC.comp_inter_prob[i]);
        cur_last_prob = cast,no_check(Prob) (255 - cast(s32) CUR_FC.comp_inter_prob[i]);

        diff += (cast,no_check(s32) counts.comp_inter[i][1]) * ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);
        i += 1;
    }

    i = 0;
    while i < 5 {
        j = 0;
        while j < 2 {
            diff +=
                (cast,no_check(s32) counts.single_ref[i][j][0]) *
                    ((cast(s32) PRE_FC.single_ref_prob[i][j]) - cast(s32) CUR_FC.single_ref_prob[i][j]);

            pre_last_prob = cast,no_check(Prob) (255 - cast(s32) PRE_FC.single_ref_prob[i][j]);
            cur_last_prob = cast,no_check(Prob) (255 - cast(s32) CUR_FC.single_ref_prob[i][j]);

            diff +=
                (cast,no_check(s32) counts.single_ref[i][j][1]) *
                    ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);
            j += 1;
        }
        i += 1;
    }

    i = 0;
    while i < 5 {
        diff +=
            (cast,no_check(s32) counts.comp_ref[i][0]) *
                ((cast(s32) PRE_FC.comp_ref_prob[i]) - cast(s32) CUR_FC.comp_ref_prob[i]);

        pre_last_prob = cast,no_check(Prob) (255 - cast(s32) PRE_FC.comp_ref_prob[i]);
        cur_last_prob = cast,no_check(Prob) (255 - cast(s32) CUR_FC.comp_ref_prob[i]);

        diff += (cast,no_check(s32) counts.comp_ref[i][1]) * ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);
        i += 1;
    }

    i = 0;
    while i < 2 {
        j = 0;
        while j < (cast,no_check(s32) (cast(TX_SIZE) 4)) - 1 {
            diff +=
                (cast,no_check(s32) counts.tx.p32x32[i][j]) *
                    ((cast(s32) PRE_FC.tx_probs.p32x32[i][j]) - cast(s32) CUR_FC.tx_probs.p32x32[i][j]);
            j += 1;
        }
        pre_last_prob =
            cast,no_check(Prob) (255 -
                cast(s32) PRE_FC.tx_probs.p32x32[i][(cast,no_check(s32) (cast(TX_SIZE) 4)) - 2]);
        cur_last_prob =
            cast,no_check(Prob) (255 -
                cast(s32) CUR_FC.tx_probs.p32x32[i][(cast,no_check(s32) (cast(TX_SIZE) 4)) - 2]);

        diff +=
            (cast,no_check(s32) counts.tx.p32x32[i][(cast,no_check(s32) (cast(TX_SIZE) 4)) - 1]) *
                ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);

        j = 0;
        while j < (cast,no_check(s32) (cast(TX_SIZE) 4)) - 2 {
            diff +=
                (cast,no_check(s32) counts.tx.p16x16[i][j]) *
                    ((cast(s32) PRE_FC.tx_probs.p16x16[i][j]) - cast(s32) CUR_FC.tx_probs.p16x16[i][j]);
            j += 1;
        }
        pre_last_prob =
            cast,no_check(Prob) (255 -
                cast(s32) PRE_FC.tx_probs.p16x16[i][(cast,no_check(s32) (cast(TX_SIZE) 4)) - 3]);
        cur_last_prob =
            cast,no_check(Prob) (255 -
                cast(s32) CUR_FC.tx_probs.p16x16[i][(cast,no_check(s32) (cast(TX_SIZE) 4)) - 3]);

        diff +=
            (cast,no_check(s32) counts.tx.p16x16[i][(cast,no_check(s32) (cast(TX_SIZE) 4)) - 2]) *
                ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);

        j = 0;
        while j < (cast,no_check(s32) (cast(TX_SIZE) 4)) - 3 {
            diff +=
                (cast,no_check(s32) counts.tx.p8x8[i][j]) *
                    ((cast(s32) PRE_FC.tx_probs.p8x8[i][j]) - cast(s32) CUR_FC.tx_probs.p8x8[i][j]);
            j += 1;
        }
        pre_last_prob =
            cast,no_check(Prob) (255 -
                cast(s32) PRE_FC.tx_probs.p8x8[i][(cast,no_check(s32) (cast(TX_SIZE) 4)) - 4]);
        cur_last_prob =
            cast,no_check(Prob) (255 -
                cast(s32) CUR_FC.tx_probs.p8x8[i][(cast,no_check(s32) (cast(TX_SIZE) 4)) - 4]);

        diff +=
            (cast,no_check(s32) counts.tx.p8x8[i][(cast,no_check(s32) (cast(TX_SIZE) 4)) - 3]) *
                ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);
        i += 1;
    }

    i = 0;
    while i < 3 {
        diff +=
            (cast,no_check(s32) counts.skip[i][0]) *
                ((cast(s32) PRE_FC.skip_probs[i]) - cast(s32) CUR_FC.skip_probs[i]);

        pre_last_prob = cast,no_check(Prob) (255 - cast(s32) PRE_FC.skip_probs[i]);
        cur_last_prob = cast,no_check(Prob) (255 - cast(s32) CUR_FC.skip_probs[i]);

        diff += (cast,no_check(s32) counts.skip[i][1]) * ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);
        i += 1;
    }

    i = 0;
    while i < 4 - 1 {
        diff +=
            (cast,no_check(s32) counts.mv.joints[i]) *
                ((cast(s32) PRE_FC.nmvc.joints[i]) - cast(s32) CUR_FC.nmvc.joints[i]);
        i += 1;
    }
    pre_last_prob = cast,no_check(Prob) (255 - cast(s32) PRE_FC.nmvc.joints[4 - 2]);
    cur_last_prob = cast,no_check(Prob) (255 - cast(s32) CUR_FC.nmvc.joints[4 - 2]);

    diff += (cast,no_check(s32) counts.mv.joints[4 - 1]) * ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);

    i = 0;
    while i < 2 {
        nmv_count := counts.mv.comps.data + i;
        pre_nmv_prob := PRE_FC.nmvc.comps.data + i;
        cur_nmv_prob := CUR_FC.nmvc.comps.data + i;

        diff += (cast,no_check(s32) nmv_count.sign[0]) * ((cast(s32) pre_nmv_prob.sign) - cast(s32) cur_nmv_prob.sign);

        pre_last_prob = cast,no_check(Prob) (255 - cast(s32) pre_nmv_prob.sign);
        cur_last_prob = cast,no_check(Prob) (255 - cast(s32) cur_nmv_prob.sign);

        diff += (cast,no_check(s32) nmv_count.sign[1]) * ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);

        j = 0;
        while j < 11 - 1 {
            diff +=
                (cast,no_check(s32) nmv_count.classes[j]) *
                    ((cast(s32) pre_nmv_prob.classes[j]) - cast(s32) cur_nmv_prob.classes[j]);
            j += 1;
        }
        pre_last_prob = cast,no_check(Prob) (255 - cast(s32) pre_nmv_prob.classes[11 - 2]);
        cur_last_prob = cast,no_check(Prob) (255 - cast(s32) cur_nmv_prob.classes[11 - 2]);

        diff += (cast,no_check(s32) nmv_count.classes[11 - 1]) * ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);

        j = 0;
        while j < (cast(s32) 1) << 1 - 1 {
            diff +=
                (cast,no_check(s32) nmv_count.class0[j]) *
                    ((cast(s32) pre_nmv_prob.class0[j]) - cast(s32) cur_nmv_prob.class0[j]);
            j += 1;
        }
        pre_last_prob = cast,no_check(Prob) (255 - cast(s32) pre_nmv_prob.class0[(cast(s32) 1) << 1 - 2]);
        cur_last_prob = cast,no_check(Prob) (255 - cast(s32) cur_nmv_prob.class0[(cast(s32) 1) << 1 - 2]);

        diff +=
            (cast,no_check(s32) nmv_count.class0[(cast(s32) 1) << 1 - 1]) *
                ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);

        j = 0;
        while j < (cast,no_check(s32) ((11 + 1))) - 2 {
            diff +=
                (cast,no_check(s32) nmv_count.bits[j][0]) *
                    ((cast(s32) pre_nmv_prob.bits[j]) - cast(s32) cur_nmv_prob.bits[j]);

            pre_last_prob = cast,no_check(Prob) (255 - cast(s32) pre_nmv_prob.bits[j]);
            cur_last_prob = cast,no_check(Prob) (255 - cast(s32) cur_nmv_prob.bits[j]);

            diff += (cast,no_check(s32) nmv_count.bits[j][1]) * ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);
            j += 1;
        }

        j = 0;
        while j < (cast(s32) 1) << 1 {
            k = 0;
            while k < 4 - 1 {
                diff +=
                    (cast,no_check(s32) nmv_count.class0_fp[j][k]) *
                        ((cast(s32) pre_nmv_prob.class0_fp[j][k]) - cast(s32) cur_nmv_prob.class0_fp[j][k]);
                k += 1;
            }
            pre_last_prob = cast,no_check(Prob) (255 - cast(s32) pre_nmv_prob.class0_fp[j][4 - 2]);
            cur_last_prob = cast,no_check(Prob) (255 - cast(s32) cur_nmv_prob.class0_fp[j][4 - 2]);

            diff +=
                (cast,no_check(s32) nmv_count.class0_fp[j][4 - 1]) *
                    ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);
            j += 1;
        }

        j = 0;
        while j < 4 - 1 {
            diff +=
                (cast,no_check(s32) nmv_count.fp[j]) *
                    ((cast(s32) pre_nmv_prob.fp[j]) - cast(s32) cur_nmv_prob.fp[j]);
            j += 1;
        }
        pre_last_prob = cast,no_check(Prob) (255 - cast(s32) pre_nmv_prob.fp[4 - 2]);
        cur_last_prob = cast,no_check(Prob) (255 - cast(s32) cur_nmv_prob.fp[4 - 2]);

        diff += (cast,no_check(s32) nmv_count.fp[4 - 1]) * ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);

        diff +=
            (cast,no_check(s32) nmv_count.class0_hp[0]) *
                ((cast(s32) pre_nmv_prob.class0_hp) - cast(s32) cur_nmv_prob.class0_hp);

        pre_last_prob = cast,no_check(Prob) (255 - cast(s32) pre_nmv_prob.class0_hp);
        cur_last_prob = cast,no_check(Prob) (255 - cast(s32) cur_nmv_prob.class0_hp);

        diff += (cast,no_check(s32) nmv_count.class0_hp[1]) * ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);

        diff += (cast,no_check(s32) nmv_count.hp[0]) * ((cast(s32) pre_nmv_prob.hp) - cast(s32) cur_nmv_prob.hp);

        pre_last_prob = cast,no_check(Prob) (255 - cast(s32) pre_nmv_prob.hp);
        cur_last_prob = cast,no_check(Prob) (255 - cast(s32) cur_nmv_prob.hp);

        diff += (cast,no_check(s32) nmv_count.hp[1]) * ((cast(s32) pre_last_prob) - cast(s32) cur_last_prob);
        i += 1;
    }

    return -diff;
}

frame_is_kf_gf_arf_in_vp9_encoder :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if frame_is_intra_only_in_vp9_encoder(*cpi.common) != 0 ||
        cpi.refresh_alt_ref_frame != 0 ||
        cpi.refresh_golden_frame != 0 && cpi.rc.is_src_frame_alt_ref == 0 {
        return 1;
    }
    return 0;
}

get_qstep_adj :: (rate_excess: s32, rate_limit: s32) -> s32 {
    qstep := (ifx rate_limit != 0 then (rate_excess + rate_limit / 2) / rate_limit else 2147483647);
    return ifx qstep < 4 then qstep else 4;
}

big_rate_miss_high_threshold :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    RC := *cpi.rc;

    big_miss_high: s32 = ifx frame_is_kf_gf_arf_in_vp9_encoder(cpi) != 0
        then RC.this_frame_target * 3 / 2
        else RC.this_frame_target * 2;

    return big_miss_high;
}

recode_loop_test_in_vp9_encoder :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    high_limit: s32,
    low_limit: s32,
    q: s32,
    maxq: s32,
    minq: s32
) -> s32 {
    RC := *cpi.rc;
    OXCF := *cpi.oxcf;
    FRAME_IS_KFGFARF := frame_is_kf_gf_arf_in_vp9_encoder(cpi);
    force_recode: s32 = 0;

    if RC.projected_frame_size >= RC.max_frame_bandwidth ||
        big_rate_miss(cpi) != 0 ||
        cpi.sf.recode_loop == cast,no_check(u32) ALLOW_RECODE ||
        two_pass_first_group_inter(cpi) != 0 && cpi.sf.recode_loop == cast,no_check(u32) ALLOW_RECODE_FIRST ||
        FRAME_IS_KFGFARF != 0 && cpi.sf.recode_loop >= cast,no_check(u32) ALLOW_RECODE_KFARFGF {
        if FRAME_IS_KFGFARF != 0 && OXCF.resize_mode == cast,no_check(u32) RESIZE_DYNAMIC && scale_down(cpi, q) != 0 {
            cpi.resize_pending = 1;
            return 1;
        }

        if RC.projected_frame_size >= RC.max_frame_bandwidth ||
            cpi.sf.recode_loop >= cast,no_check(u32) ALLOW_RECODE_KFARFGF &&
                RC.projected_frame_size >= big_rate_miss_high_threshold(cpi) {
            return 1;
        }

        if RC.projected_frame_size > high_limit && q < maxq || RC.projected_frame_size < low_limit && q > minq {
            force_recode = 1;
        } else if cpi.oxcf.rc_mode == cast,no_check(u32) CQ {
            if q > OXCF.cq_level && RC.projected_frame_size < (RC.this_frame_target * 7) >> 3 {
                force_recode = 1;
            }
        }
    }
    return force_recode;
}

scale_down :: (cpi: *VP9_COMP_in_vp9_encoder, q: s32) -> s32 {
    RC := *cpi.rc;
    GF_GROUP_ := *cpi.twopass.gf_group;
    scale: s32 = 0;

    if RC.frame_size_selector == cast,no_check(u32) UNSCALED && q >= RC.rf_level_maxq[GF_GROUP_.rf_level[GF_GROUP_.index]] {
        MAX_SIZE_THRESH :=
            cast,no_check(s32) (2.0 *
                cast,no_check(float64) ((ifx RC.this_frame_target > RC.avg_frame_bandwidth then RC.this_frame_target else RC.avg_frame_bandwidth)));
        scale = cast(s32) (RC.projected_frame_size > MAX_SIZE_THRESH);
    }
    return scale;
}

two_pass_first_group_inter :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if cpi.oxcf.pass == 2 {
        TWOPASS := *cpi.twopass;
        GF_GROUP_ := *TWOPASS.gf_group;
        GFG_INDEX := cast,no_check(s32) GF_GROUP_.index;

        if GFG_INDEX == 0 {
            if GF_GROUP_.update_type[GFG_INDEX] == cast,no_check(u32) LF_UPDATE {
                return 1;
            }
            return 0;
        }
        if GF_GROUP_.update_type[GFG_INDEX - 1] != cast,no_check(u32) LF_UPDATE &&
            GF_GROUP_.update_type[GFG_INDEX] == cast,no_check(u32) LF_UPDATE {
            return 1;
        }
        return 0;
    } else {
        return 0;
    }
}

big_rate_miss :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    RC := *cpi.rc;
    big_miss_high: s32 = ---;
    big_miss_low: s32 = ---;

    if RC.is_src_frame_alt_ref != 0 {
        return 0;
    } else {
        big_miss_low = RC.this_frame_target / 2;
        big_miss_high = big_rate_miss_high_threshold(cpi);

        if RC.projected_frame_size > big_miss_high || RC.projected_frame_size < big_miss_low {
            return 1;
        }
        return 0;
    }
}

setup_frame :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;

    if frame_is_intra_only_in_vp9_encoder(CM) != 0 || CM.error_resilient_mode != 0 {
        vp9_setup_past_independence(CM);
    } else if cpi.use_svc == 0 {
        CM.frame_context_idx = cast,no_check(u32) cpi.refresh_alt_ref_frame;
    }

    if cpi.multi_layer_arf != 0 && cpi.use_svc == 0 {
        GF_GROUP_ := *cpi.twopass.gf_group;
        GF_GROUP_INDEX := cast,no_check(s32) GF_GROUP_.index;
        BOOST_FRAME :=
            cast(s32) (cpi.rc.is_src_frame_alt_ref == 0 &&
                (cpi.refresh_golden_frame != 0 || cpi.refresh_alt_ref_frame != 0));

        if frame_is_intra_only_in_vp9_encoder(CM) != 0 {
            CM.frame_context_idx = 0;
        } else if BOOST_FRAME != 0 {
            if GF_GROUP_.rf_level[GF_GROUP_INDEX] == cast,no_check(u32) GF_ARF_STD {
                CM.frame_context_idx = 0;
            } else if GF_GROUP_.layer_depth[GF_GROUP_INDEX] <= 3 {
                CM.frame_context_idx = 1;
            } else {
                CM.frame_context_idx = 2;
            }
        } else {
            CM.frame_context_idx = 3;
        }
    }

    if CM.frame_type == cast,no_check(u32) KEY_FRAME {
        cpi.refresh_golden_frame = 1;
        cpi.refresh_alt_ref_frame = 1;
        fill_memory(*cpi.interp_filter_selected, 0, cpi.interp_filter_selected.count * size_of([4] s32));
    } else {
        assignment_10: FRAME_CONTEXT = (cast(*Frame_Contexts) (CM.frame_contexts))[CM.frame_context_idx];
        ((CM.fc).*) = assignment_10;
        fill_memory(cpi.interp_filter_selected.data + 0, 0, 4 * cast(u64) size_of(s32));
    }
}

vp9_scale_references :: (cpi: *VP9_COMP_in_vp9_encoder) {
    cm := *cpi.common;

    REF_MASK :=
        VP9_REFFRAME.[ cast,no_check(VP9_REFFRAME) VP9_LAST_FLAG, cast,no_check(VP9_REFFRAME) VP9_GOLD_FLAG, cast,no_check(VP9_REFFRAME) VP9_ALT_FLAG ];

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame <= 3 {
        if (cast,no_check(u32) cpi.ref_frame_flags) & REF_MASK[(cast(s32) ref_frame) - 1] != 0 {
            POOL := cm.buffer_pool;
            REF := get_ref_frame_buffer_in_vp9_encoder(cpi, ref_frame);

            if REF == null {
                cpi.scaled_ref_idx[(cast(s32) ref_frame) - 1] = -1;
                ref_frame += 1;
                continue;
            }

            if REF.y_crop_width != cm.width || REF.y_crop_height != cm.height {
                new_fb_ptr: *Ref_Cnt_Buffer = null;
                force_scaling: s32 = 0;
                new_fb := cpi.scaled_ref_idx[(cast(s32) ref_frame) - 1];
                if new_fb == -1 {
                    new_fb = get_free_fb_in_vp9_encoder(cm);
                    if new_fb == -1 {
                        internal_error(
                            *cm.error,
                            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                            c_string("Unable to find free frame buffer")
                        );
                    }
                    force_scaling = 1;
                }
                new_fb_ptr = POOL.frame_bufs.data + new_fb;
                if force_scaling != 0 || new_fb_ptr.buf.y_crop_width != cm.width || new_fb_ptr.buf.y_crop_height != cm.height {
                    if realloc_frame_buffer(
                        *new_fb_ptr.buf,
                        cm.width,
                        cm.height,
                        cm.subsampling_x,
                        cm.subsampling_y,
                        160,
                        cm.byte_alignment,
                        null,
                        null,
                        null
                    ) != 0 {
                        internal_error(
                            *cm.error,
                            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                            c_string("Failed to allocate frame buffer")
                        );
                    }
                    vp9_scale_and_extend_frame_c(REF, *new_fb_ptr.buf, 0, 0);

                    cpi.scaled_ref_idx[(cast(s32) ref_frame) - 1] = new_fb;
                    alloc_frame_mvs_in_vp9_encoder(cm, new_fb);
                }
            } else {
                buf_idx: s32 = ---;
                buf: *Ref_Cnt_Buffer = null;
                if cpi.oxcf.pass == 0 && cpi.use_svc == 0 {
                    buf_idx = cpi.scaled_ref_idx[(cast(s32) ref_frame) - 1];
                    if buf_idx != -1 {
                        buf = POOL.frame_bufs.data + buf_idx;
                        buf.ref_count -= 1;
                        cpi.scaled_ref_idx[(cast(s32) ref_frame) - 1] = -1;
                    }
                }
                buf_idx = get_ref_frame_buf_idx_in_vp9_encoder(cpi, cast,no_check(s32) ref_frame);
                buf = POOL.frame_bufs.data + buf_idx;
                buf.buf.y_crop_width = REF.y_crop_width;
                buf.buf.y_crop_height = REF.y_crop_height;
                cpi.scaled_ref_idx[(cast(s32) ref_frame) - 1] = buf_idx;
                buf.ref_count += 1;
            }
        } else if cpi.oxcf.pass != 0 || cpi.use_svc != 0 {
            cpi.scaled_ref_idx[(cast(s32) ref_frame) - 1] = -1;
        }
        ref_frame += 1;
    }
}

alloc_frame_mvs_in_vp9_encoder :: (CM: *VP9_COMMON, buffer_idx: s32) {
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

is_psnr_calc_enabled :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    CM := *cpi.common;
    OXCF := *cpi.oxcf;

    if cpi.b_calculate_psnr != 0 && OXCF.pass != 1 && CM.show_frame != 0 {
        return 1;
    }
    return 0;
}

set_mv_search_params :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    MAX_MV_DEF := cast,no_check(u32) ((ifx CM.width < CM.height then CM.width else CM.height));

    cpi.mv_step_param = vp9_init_search_range(cast,no_check(s32) MAX_MV_DEF);

    if cpi.sf.mv.auto_mv_step_size != 0 {
        if frame_is_intra_only_in_vp9_encoder(CM) != 0 {
            cpi.max_mv_magnitude = MAX_MV_DEF;
        } else {
            if CM.show_frame != 0 {
                cpi.mv_step_param =
                    vp9_init_search_range(
                        cast,no_check(s32) ((ifx MAX_MV_DEF < 2 *
                        cpi.max_mv_magnitude then MAX_MV_DEF else 2 * cpi.max_mv_magnitude))
                    );
            }
            cpi.max_mv_magnitude = 0;
        }
    }
}

set_size_dependent_vars :: (cpi: *VP9_COMP_in_vp9_encoder, q: *s32, bottom_index: *s32, top_index: *s32) {
    CM := *cpi.common;

    vp9_set_speed_features_framesize_dependent(cpi, cpi.oxcf.speed);

    q.* = vp9_rc_pick_q_and_bounds(cpi, bottom_index, top_index);

    if cpi.oxcf.rc_mode == cast,no_check(u32) CBR && cpi.rc.force_max_q != 0 {
        q.* = cpi.rc.worst_quality;
        cpi.rc.force_max_q = 0;
    }

    if cpi.use_svc != 0 {
        cpi.svc.base_qindex[cpi.svc.spatial_layer_id] = q.*;
    }

    if frame_is_intra_only_in_vp9_encoder(CM) == 0 {
        vp9_set_high_precision_mv(cpi, cast(s32) (q.* < 200));
    }

    if cpi.oxcf.pass == 2 && cpi.sf.static_segmentation != 0 {
        configure_static_seg_features(cpi);
    }
}

configure_static_seg_features :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    RC := *cpi.rc;
    SEG := *CM.seg;

    high_q := cast(s32) (c_transpiler_float_greater(RC.avg_q, 48.0));
    qi_delta: s32 = ---;

    if CM.frame_type == cast,no_check(u32) KEY_FRAME {
        fill_memory(cpi.segmentation_map, 0, cast,no_check(u64) (CM.mi_rows * CM.mi_cols));
        SEG.update_map = 0;
        SEG.update_data = 0;
        cpi.static_mb_pct = 0;

        vp9_disable_segmentation(SEG);

        vp9_clearall_segfeatures(SEG);
    } else if cpi.refresh_alt_ref_frame != 0 {
        fill_memory(cpi.segmentation_map, 0, cast,no_check(u64) (CM.mi_rows * CM.mi_cols));
        SEG.update_map = 0;
        SEG.update_data = 0;
        cpi.static_mb_pct = 0;

        vp9_disable_segmentation(SEG);
        vp9_clearall_segfeatures(SEG);

        vp9_update_mbgraph_stats(cpi);

        if SEG.enabled != 0 {
            SEG.update_map = 1;
            SEG.update_data = 1;

            qi_delta =
                (cast,no_check(#type (_: *RATE_CONTROL, _: float64, _: float64, _: Bit_Depth_T) -> s32) (cast(*void) vp9_compute_qdelta))(
                    RC,
                    RC.avg_q,
                    RC.avg_q * 0.875,
                    CM.bit_depth
                );
            vp9_set_segdata(SEG, 1, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_Q, qi_delta - 2);
            vp9_set_segdata(SEG, 1, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_LF, -2);

            vp9_enable_segfeature(SEG, 1, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_Q);
            vp9_enable_segfeature(SEG, 1, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_LF);

            SEG.abs_delta = 0;
        }
    } else if SEG.enabled != 0 {
        if RC.frames_since_golden == 0 {
            if RC.source_alt_ref_active != 0 {
                SEG.update_map = 0;
                SEG.update_data = 1;
                SEG.abs_delta = 0;

                qi_delta =
                    (cast,no_check(#type (_: *RATE_CONTROL, _: float64, _: float64, _: Bit_Depth_T) -> s32) (cast(*void) vp9_compute_qdelta))(
                        RC,
                        RC.avg_q,
                        RC.avg_q * 1.125,
                        CM.bit_depth
                    );
                vp9_set_segdata(SEG, 1, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_Q, qi_delta + 2);
                vp9_enable_segfeature(SEG, 1, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_Q);

                vp9_set_segdata(SEG, 1, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_LF, -2);
                vp9_enable_segfeature(SEG, 1, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_LF);

                if high_q != 0 || cpi.static_mb_pct == 100 {
                    vp9_set_segdata(SEG, 1, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME, 3);
                    vp9_enable_segfeature(SEG, 1, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME);
                    vp9_enable_segfeature(SEG, 1, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_SKIP);
                }
            } else {
                vp9_disable_segmentation(SEG);

                fill_memory(cpi.segmentation_map, 0, cast,no_check(u64) (CM.mi_rows * CM.mi_cols));

                SEG.update_map = 0;
                SEG.update_data = 0;

                vp9_clearall_segfeatures(SEG);
            }
        } else if RC.is_src_frame_alt_ref != 0 {
            vp9_enable_segfeature(SEG, 0, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME);
            vp9_enable_segfeature(SEG, 1, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME);

            (cast,no_check(#type (_: *Segmentation, _: s32, _: SEG_LVL_FEATURES)) (cast(*void) vp9_clear_segdata))(
                SEG,
                0,
                cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
            );
            vp9_set_segdata(SEG, 0, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME, 3);
            (cast,no_check(#type (_: *Segmentation, _: s32, _: SEG_LVL_FEATURES)) (cast(*void) vp9_clear_segdata))(
                SEG,
                1,
                cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME
            );
            vp9_set_segdata(SEG, 1, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME, 3);

            if high_q != 0 {
                vp9_enable_segfeature(SEG, 0, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_SKIP);
                vp9_enable_segfeature(SEG, 1, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_SKIP);
            }

            SEG.update_data = 1;
        } else {
            SEG.update_map = 0;
            SEG.update_data = 0;
        }
    }
}

set_frame_size :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    OXCF := *cpi.oxcf;
    XD := *cpi.td.mb.e_mbd;

    if OXCF.pass == 2 &&
        OXCF.rc_mode == cast,no_check(u32) VBR &&
        (OXCF.resize_mode == cast,no_check(u32) RESIZE_FIXED && CM.current_video_frame == 0 ||
            OXCF.resize_mode == cast,no_check(u32) RESIZE_DYNAMIC && cpi.resize_pending != 0) {
        calculate_coded_size(cpi, *OXCF.scaled_frame_width, *OXCF.scaled_frame_height);

        vp9_set_size_literal(
            cpi,
            cast,no_check(u32) OXCF.scaled_frame_width,
            cast,no_check(u32) OXCF.scaled_frame_height
        );
    }

    if OXCF.pass == 0 &&
        OXCF.rc_mode == cast,no_check(u32) CBR &&
        OXCF.resize_mode == cast,no_check(u32) RESIZE_DYNAMIC &&
        cpi.resize_pending != 0 {
        if cpi.use_svc == 0 || cpi.svc.resize_set == 0 {
            OXCF.scaled_frame_width = OXCF.width * cpi.resize_scale_num / cpi.resize_scale_den;
            OXCF.scaled_frame_height = OXCF.height * cpi.resize_scale_num / cpi.resize_scale_den;

            vp9_set_size_literal(
                cpi,
                cast,no_check(u32) OXCF.scaled_frame_width,
                cast,no_check(u32) OXCF.scaled_frame_height
            );
        }

        set_mv_search_params(cpi);

        vp9_noise_estimate_init(*cpi.noise_estimate, CM.width, CM.height);
    }

    if OXCF.pass == 2 && cpi.use_svc == 0 {
        vp9_set_target_rate(cpi);
    }

    alloc_frame_mvs_in_vp9_encoder(CM, CM.new_fb_idx);

    if realloc_frame_buffer(
        get_frame_new_buffer_in_vp9_encoder(CM),
        CM.width,
        CM.height,
        CM.subsampling_x,
        CM.subsampling_y,
        160,
        CM.byte_alignment,
        null,
        null,
        null
    ) != 0 {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate frame buffer")
        );
    }

    alloc_util_frame_buffers(cpi);
    init_motion_estimation(cpi);

    has_valid_ref_frame: s32 = 0;
    if 1 <= 3 {
        for ref_frame: 1..cast(s32) 3 {
            REF_BUF := CM.frame_refs.data + ref_frame - 1;
            BUF_IDX := get_ref_frame_buf_idx_in_vp9_encoder(cpi, ref_frame);

            REF_BUF.idx = BUF_IDX;

            if BUF_IDX != -1 {
                BUF := *CM.buffer_pool.frame_bufs[BUF_IDX].buf;
                REF_BUF.buf = BUF;

                vp9_setup_scale_factors_for_frame(*REF_BUF.sf, BUF.y_crop_width, BUF.y_crop_height, CM.width, CM.height);

                has_valid_ref_frame |= vp9_is_valid_scale_in_vp9_encoder(*REF_BUF.sf);
                if vp9_is_scaled_in_vp9_encoder(*REF_BUF.sf) != 0 {
                    extend_frame_borders_c(BUF);
                }
            } else {
                REF_BUF.buf = null;
            }
        }
    }
    if frame_is_intra_only_in_vp9_encoder(CM) == 0 && has_valid_ref_frame == 0 {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_ERROR,
            c_string("Can't find at least one reference frame with valid size")
        );
    }

    set_ref_ptrs_in_vp9_encoder(CM, XD, 1, 1);
}

set_ref_ptrs_in_vp9_encoder :: (CM: *VP9_COMMON, xd: *MACROBLOCKD, ref0: MV_REFERENCE_FRAME, ref1: MV_REFERENCE_FRAME) {
    xd.block_refs[0] = CM.frame_refs.data + (ifx ref0 >= 1 then (cast(s32) ref0) - 1 else 0);
    xd.block_refs[1] = CM.frame_refs.data + (ifx ref1 >= 1 then (cast(s32) ref1) - 1 else 0);
}

init_motion_estimation :: (cpi: *VP9_COMP_in_vp9_encoder) {
    y_stride := cpi.scaled_source.y_stride;

    if cpi.sf.mv.search_method == cast,no_check(u32) NSTEP_in_vp9_cx_iface {
        vp9_init3smotion_compensation(*cpi.ss_cfg, y_stride);
    } else if cpi.sf.mv.search_method == cast,no_check(u32) DIAMOND_in_vp9_cx_iface {
        vp9_init_dsmotion_compensation(*cpi.ss_cfg, y_stride);
    }
}

vp9_set_size_literal :: (cpi: *VP9_COMP_in_vp9_encoder, width: u32, height: u32) -> s32 {
    cm := *cpi.common;

    update_initial_width(cpi, 0, cpi.common.subsampling_x, cpi.common.subsampling_y);

    alloc_raw_frame_buffers_in_vp9_encoder(cpi);
    if width != 0 {
        cm.width = cast,no_check(s32) width;
        if cm.width > cpi.initial_width {
            cm.width = cpi.initial_width;
        }
    }

    if height != 0 {
        cm.height = cast,no_check(s32) height;
        if cm.height > cpi.initial_height {
            cm.height = cpi.initial_height;
        }
    }

    update_frame_size(cpi);

    return 0;
}

set_size_independent_vars :: (cpi: *VP9_COMP_in_vp9_encoder) {
    vp9_set_speed_features_framesize_independent(cpi, cpi.oxcf.speed);
    vp9_set_rd_speed_thresholds(cpi);
    vp9_set_rd_speed_thresholds_sub8x8(cpi);
    cpi.common.interp_filter = cpi.sf.default_interp_filter;
}

set_raw_source_frame :: (cpi: *VP9_COMP_in_vp9_encoder) {
    cpi.raw_source_frame = cpi.source;
}

encode_without_recode_loop :: (cpi: *VP9_COMP_in_vp9_encoder, size: *u64, dest: *u8, dest_size: u64) -> s32 {
    CM := *cpi.common;
    SVC_ := *cpi.svc;
    q: s32 = 0;
    bottom_index: s32 = 0;
    top_index: s32 = 0;
    no_drop_scene_change: s32 = 0;
    FILTER_SCALER :=
        cast,no_check(INTERP_FILTER) ((ifx is_one_pass_svc_in_vp9_encoder(cpi) != 0 then cast,no_check(s32) SVC_.downsample_filter_type[SVC_.spatial_layer_id] else 0));
    PHASE_SCALER :=
        (ifx is_one_pass_svc_in_vp9_encoder(cpi) != 0 then SVC_.downsample_filter_phase[SVC_.spatial_layer_id] else 0);

    if CM.show_existing_frame != 0 {
        cpi.rc.this_frame_target = 0;
        if is_psnr_calc_enabled(cpi) != 0 {
            set_raw_source_frame(cpi);
        }
        return 1;
    }

    SVC_.time_stamp_prev[SVC_.spatial_layer_id] = SVC_.time_stamp_superframe;

    cpi.compute_source_sad_onepass = cast(s32) (cpi.oxcf.mode == cast,no_check(u32) REALTIME);

    set_frame_size(cpi);

    if is_one_pass_svc_in_vp9_encoder(cpi) != 0 &&
        cpi.un_scaled_source.y_width == CM.width << 2 &&
        cpi.un_scaled_source.y_height == CM.height << 2 &&
        SVC_.scaled_temp.y_width == CM.width << 1 &&
        SVC_.scaled_temp.y_height == CM.height << 1 {
        FILTER_SCALER2 := SVC_.downsample_filter_type[1];
        PHASE_SCALER2 := SVC_.downsample_filter_phase[1];
        cpi.source =
            svc_twostage_scale(
                CM,
                cpi.un_scaled_source,
                *cpi.scaled_source,
                *SVC_.scaled_temp,
                FILTER_SCALER,
                PHASE_SCALER,
                FILTER_SCALER2,
                PHASE_SCALER2
            );
        SVC_.scaled_one_half = 1;
    } else if is_one_pass_svc_in_vp9_encoder(cpi) != 0 &&
        cpi.un_scaled_source.y_width == CM.width << 1 &&
        cpi.un_scaled_source.y_height == CM.height << 1 &&
        SVC_.scaled_one_half != 0 {
        cpi.source = *SVC_.scaled_temp;
        SVC_.scaled_one_half = 0;
    } else {
        cpi.source =
            vp9_scale_if_required(
                CM,
                cpi.un_scaled_source,
                *cpi.scaled_source,
                cast(s32) (cpi.oxcf.pass == 0),
                FILTER_SCALER,
                PHASE_SCALER
            );
    }

    if is_psnr_calc_enabled(cpi) != 0 {
        cpi.raw_source_frame = cpi.source;
    }

    if cpi.use_svc != 0 &&
        (SVC_.spatial_layer_id < SVC_.number_spatial_layers - 1 ||
            SVC_.temporal_layer_id < SVC_.number_temporal_layers - 1 ||
            SVC_.current_superframe < 1) ||
        cpi.resize_pending != 0 ||
        ((cpi.resize_state) != 0) ||
        cpi.external_resize != 0 ||
        cpi.resize_state != cast,no_check(u32) ORIG {
        cpi.compute_source_sad_onepass = 0;
        if cpi.content_state_sb_fd != null {
            fill_memory(cpi.content_state_sb_fd, 0, cast,no_check(u64) (CM.mi_stride >> 3 * (CM.mi_rows >> 3 + 1)));
        }
    }

    if cpi.unscaled_last_source != null &&
        (cpi.oxcf.content == cast,no_check(u32) VP9E_CONTENT_SCREEN ||
            cpi.oxcf.pass == 0 &&
                cpi.oxcf.rc_mode == cast,no_check(u32) VBR &&
                cpi.oxcf.mode == cast,no_check(u32) REALTIME &&
                cpi.oxcf.speed >= 5 ||
            cpi.noise_estimate.enabled != 0 && cpi.oxcf.noise_sensitivity == 0 ||
            cpi.compute_source_sad_onepass != 0) {
        cpi.last_source =
            vp9_scale_if_required(
                CM,
                cpi.unscaled_last_source,
                *cpi.scaled_last_source,
                cast(s32) (cpi.oxcf.pass == 0),
                0,
                0
            );
    }

    if cpi.last_source == null ||
        cpi.last_source.y_width != cpi.source.y_width ||
        cpi.last_source.y_height != cpi.source.y_height {
        cpi.compute_source_sad_onepass = 0;
    }

    if frame_is_intra_only_in_vp9_encoder(CM) != 0 || cpi.resize_pending != 0 {
        fill_memory(cpi.consec_zero_mv, 0, cast,no_check(u64) (CM.mi_rows * CM.mi_cols));
    }

    cpi.rc.high_source_sad = 0;
    cpi.rc.hybrid_intra_scene_change = 0;
    cpi.rc.re_encode_maxq_scene_change = 0;
    if CM.show_frame != 0 &&
        cpi.oxcf.mode == cast,no_check(u32) REALTIME &&
        cpi.disable_scene_detection_rtc_ratectrl == 0 &&
        (cpi.oxcf.rc_mode == cast,no_check(u32) VBR ||
            cpi.oxcf.content == cast,no_check(u32) VP9E_CONTENT_SCREEN ||
            cpi.oxcf.speed >= 5) {
        vp9_scene_detection_onepass(cpi);
    }

    if SVC_.spatial_layer_id == SVC_.first_spatial_layer_to_encode {
        SVC_.high_source_sad_superframe = cpi.rc.high_source_sad;
        SVC_.high_num_blocks_with_motion = cpi.rc.high_num_blocks_with_motion;

        if SVC_.high_source_sad_superframe != 0 &&
            SVC_.temporal_layer_id > 0 &&
            SVC_.temporal_layering_mode == cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_BYPASS {
            tmp_high_source_sad := cpi.rc.high_source_sad;
            vp9_svc_reset_temporal_layers(cpi, cast(s32) (CM.frame_type == cast,no_check(u32) KEY_FRAME));
            cpi.rc.high_source_sad = tmp_high_source_sad;
        }
    }

    vp9_update_noise_estimate(cpi);

    if (cpi.rc.high_source_sad != 0 || SVC_.high_source_sad_superframe != 0) &&
        !(cpi.rc.use_post_encode_drop != 0 && SVC_.last_layer_dropped[0] != 0) {
        no_drop_scene_change = 1;
    }
    if cpi.oxcf.pass == 0 &&
        cpi.oxcf.rc_mode == cast,no_check(u32) CBR &&
        frame_is_intra_only_in_vp9_encoder(CM) == 0 &&
        no_drop_scene_change == 0 &&
        SVC_.superframe_has_layer_sync == 0 &&
        (cpi.use_svc == 0 || SVC_.layer_context[SVC_.temporal_layer_id].is_key_frame == 0) {
        if vp9_rc_drop_frame(cpi) != 0 {
            return 0;
        }
    }

    if frame_is_intra_only_in_vp9_encoder(CM) == 0 &&
        (SVC_.single_layer_svc != 0 && cpi.oxcf.resize_mode == cast,no_check(u32) RESIZE_DYNAMIC ||
            !(is_one_pass_svc_in_vp9_encoder(cpi) != 0 && SVC_.force_zero_mode_spatial_ref != 0 && cpi.sf.use_nonrd_pick_mode != 0)) {
        vp9_scale_references(cpi);
    }

    set_size_independent_vars(cpi);
    set_size_dependent_vars(cpi, *q, *bottom_index, *top_index);

    init_motion_estimation(cpi);

    if cpi.sf.copy_partition_flag != 0 {
        alloc_copy_partition_data(cpi);
    }

    if cpi.sf.svc_use_lowres_part != 0 && SVC_.spatial_layer_id == SVC_.number_spatial_layers - 2 {
        if SVC_.prev_partition_svc == null {
            SVC_.prev_partition_svc =
                cast(*BLOCK_SIZE) calloc_2(
                    cast,no_check(u64) (CM.mi_stride * CM.mi_rows),
                    size_of(BLOCK_SIZE)
                );

            if SVC_.prev_partition_svc == null {
                internal_error(
                    *CM.error,
                    cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                    c_string("Failed to allocate svc->prev_partition_svc")
                );
            }
        }
    }

    if CM.bit_depth == 8 &&
        cpi.oxcf.speed >= 5 &&
        cpi.oxcf.pass == 0 &&
        cpi.oxcf.rc_mode == cast,no_check(u32) CBR &&
        cpi.oxcf.content != cast,no_check(u32) VP9E_CONTENT_SCREEN &&
        cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ {
        cpi.use_skin_detection = 1;
    }

    cpi.rc.use_post_encode_drop =
        cast(s32) (cpi.rc.ext_use_post_encode_drop != 0 &&
            cpi.oxcf.rc_mode == cast,no_check(u32) CBR && CM.frame_type != cast,no_check(u32) KEY_FRAME);

    vp9_set_quantizer(cpi, q, 0);
    vp9_set_variance_partition_thresholds(cpi, q, 0);

    setup_frame(cpi);

    suppress_active_map(cpi);

    if cpi.use_svc != 0 {
        if SVC_.spatial_layer_id > 0 {
            vp9_svc_constrain_inter_layer_pred(cpi);
        }
        vp9_svc_assert_constraints_pattern(cpi);
    }

    if cpi.rc.last_post_encode_dropped_scene_change != 0 {
        cpi.rc.high_source_sad = 1;
        SVC_.high_source_sad_superframe = 1;

        cpi.sf.use_source_sad = 0;
        cpi.rc.last_post_encode_dropped_scene_change = 0;
    }

    if cpi.sf.overshoot_detection_cbr_rt == cast,no_check(u32) FAST_DETECTION_MAXQ &&
        (cpi.rc.high_source_sad != 0 || cpi.use_svc != 0 && SVC_.high_source_sad_superframe != 0) {
        if vp9_encodedframe_overshoot(cpi, -1, *q) != 0 {
            vp9_set_quantizer(cpi, q, 0);
            vp9_set_variance_partition_thresholds(cpi, q, 0);
        }
    }

    if cpi.oxcf.aq_mode == cast,no_check(u32) VARIANCE_AQ {
        vp9_vaq_frame_setup(cpi);
    } else if cpi.oxcf.aq_mode == cast,no_check(u32) EQUATOR360_AQ {
        vp9_360aq_frame_setup(cpi);
    } else if cpi.oxcf.aq_mode == cast,no_check(u32) COMPLEXITY_AQ {
        vp9_setup_in_frame_q_adj(cpi);
    } else if cpi.oxcf.aq_mode == cast,no_check(u32) LOOKAHEAD_AQ {
        vp9_alt_ref_aq_setup_map(cpi.alt_ref_aq, cpi);
    } else if cpi.roi.enabled != 0 && frame_is_intra_only_in_vp9_encoder(CM) == 0 {
        if cpi.roi.skip[3] != 0 {
            if cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ {
                vp9_cyclic_refresh_setup(cpi);
            }
            if cpi.rc.frames_since_key > 20 {
                apply_roi_map(cpi);
            }
        } else {
            apply_roi_map(cpi);
        }
    } else if cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ {
        vp9_cyclic_refresh_setup(cpi);
    }

    apply_active_map(cpi);

    vp9_encode_frame(cpi);

    if cpi.sf.overshoot_detection_cbr_rt == cast,no_check(u32) RE_ENCODE_MAXQ &&
        (cpi.rc.high_source_sad != 0 || cpi.use_svc != 0 && SVC_.high_source_sad_superframe != 0) {
        frame_size: s32 = 0;

        save_coding_context(cpi);
        vp9_pack_bitstream(cpi, dest, dest_size, size);
        restore_coding_context(cpi);
        frame_size = (cast,no_check(s32) size.*) << 3;

        if vp9_encodedframe_overshoot(cpi, frame_size, *q) != 0 {
            vp9_set_quantizer(cpi, q, 0);
            vp9_set_variance_partition_thresholds(cpi, q, 0);
            suppress_active_map(cpi);

            if cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ {
                CR := cpi.cyclic_refresh;
                SEG_MAP: *u8 = cpi.segmentation_map;
                fill_memory(SEG_MAP, 0, cast,no_check(u64) (CM.mi_rows * CM.mi_cols));
                fill_memory(CR.last_coded_q_map, 255, cast,no_check(u64) (CM.mi_rows * CM.mi_cols));
                CR.sb_index = 0;
                vp9_disable_segmentation(*CM.seg);
            }
            apply_active_map(cpi);
            vp9_encode_frame(cpi);
        }
    }

    if cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ &&
        CM.seg.enabled != 0 &&
        frame_is_intra_only_in_vp9_encoder(CM) == 0 &&
        cpi.cyclic_refresh.content_mode != 0 {
        vp9_cyclic_refresh_postencode(cpi);
    }

    return 1;
}

apply_active_map :: (cpi: *VP9_COMP_in_vp9_encoder) {
    SEG := *cpi.common.seg;
    SEG_MAP: *u8 = cpi.segmentation_map;
    ACTIVE_MAP := cpi.active_map.map;
    i: s32 = ---;

    if frame_is_intra_only_in_vp9_encoder(*cpi.common) != 0 {
        cpi.active_map.enabled = 0;
        cpi.active_map.update = 1;
    }

    if cpi.active_map.update != 0 {
        if cpi.active_map.enabled != 0 {
            i = 0;
            while i < cpi.common.mi_rows * cpi.common.mi_cols {
                if SEG_MAP[i] == 0 {
                    SEG_MAP[i] = ACTIVE_MAP[i];
                }
                i += 1;
            }
            vp9_enable_segmentation(SEG);
            vp9_enable_segfeature(SEG, 7, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_SKIP);
            vp9_enable_segfeature(SEG, 7, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_LF);

            vp9_set_segdata(SEG, 7, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_LF, -63);
        } else {
            (cast,no_check(#type (_: *Segmentation, _: s32, _: SEG_LVL_FEATURES)) (cast(*void) vp9_disable_segfeature))(
                SEG,
                7,
                cast,no_check(SEG_LVL_FEATURES) SEG_LVL_SKIP
            );
            (cast,no_check(#type (_: *Segmentation, _: s32, _: SEG_LVL_FEATURES)) (cast(*void) vp9_disable_segfeature))(
                SEG,
                7,
                cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_LF
            );
            if SEG.enabled != 0 {
                SEG.update_data = 1;
                SEG.update_map = 1;
            }
        }
        cpi.active_map.update = 0;
    }
}

suppress_active_map :: (cpi: *VP9_COMP_in_vp9_encoder) {
    SEG_MAP: *u8 = cpi.segmentation_map;

    if cpi.active_map.enabled != 0 || cpi.active_map.update != 0 {
        ROWS := cpi.common.mi_rows;
        COLS := cpi.common.mi_cols;

        i: s32 = 0;
        while i < ROWS * COLS {
            if SEG_MAP[i] == 7 {
                SEG_MAP[i] = 0;
            }
            i += 1;
        }
    }
}

apply_roi_map :: (cpi: *VP9_COMP_in_vp9_encoder) {
    cm := *cpi.common;
    SEG := *cm.seg;
    roi := *cpi.roi;
    delta_q := roi.delta_q.data;
    delta_lf := roi.delta_lf.data;
    skip := roi.skip.data;
    ref_frame: [8] s32 = ---;
    internal_delta_q: [8] s32 = ---;

    if cpi.oxcf.mode != cast,no_check(u32) REALTIME || cpi.oxcf.speed < 5 {
        return;
    }
    if roi.enabled == 0 {
        return;
    }

    copy_memory(*ref_frame, roi.ref_frame.data, ref_frame.count * size_of(s32));

    vp9_enable_segmentation(SEG);
    vp9_clearall_segfeatures(SEG);

    SEG.abs_delta = 0;

    copy_memory(cpi.segmentation_map, roi.roi_map, cast,no_check(u64) (cm.mi_rows * cm.mi_cols));

    for i: 0..cast(s32) 8 - 1 {
        internal_delta_q[i] = vp9_quantizer_to_qindex(absolute_value(delta_q[i]));
        if delta_q[i] < 0 {
            internal_delta_q[i] = -internal_delta_q[i];
        }
        (cast,no_check(#type (_: *Segmentation, _: s32, _: SEG_LVL_FEATURES)) (cast(*void) vp9_disable_segfeature))(
            SEG,
            i,
            cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_Q
        );
        (cast,no_check(#type (_: *Segmentation, _: s32, _: SEG_LVL_FEATURES)) (cast(*void) vp9_disable_segfeature))(
            SEG,
            i,
            cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_LF
        );
        if internal_delta_q[i] != 0 {
            vp9_enable_segfeature(SEG, i, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_Q);
            vp9_set_segdata(SEG, i, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_Q, internal_delta_q[i]);
        }
        if delta_lf[i] != 0 {
            vp9_enable_segfeature(SEG, i, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_LF);
            vp9_set_segdata(SEG, i, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_LF, delta_lf[i]);
        }
        if skip[i] != 0 {
            vp9_enable_segfeature(SEG, i, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_SKIP);
            vp9_set_segdata(SEG, i, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_SKIP, 0);
        }
        if ref_frame[i] >= 0 {
            valid_ref: s32 = 1;

            if ref_frame[i] == 3 && cpi.sf.use_nonrd_pick_mode != 0 {
                valid_ref = 0;
            }

            if ref_frame[i] == 2 && cpi.ref_frame_flags & ref_frame_to_flag_in_vp9_encoder(cast,no_check(s8) ref_frame[i]) == 0 {
                valid_ref = 0;
            }

            if ref_frame[i] == 2 && cpi.rc.frames_since_golden == 0 {
                ref_frame[i] = 1;
            }
            if valid_ref != 0 {
                vp9_enable_segfeature(SEG, i, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME);
                vp9_set_segdata(SEG, i, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_REF_FRAME, ref_frame[i]);
            }
        }
    }
    roi.enabled = 1;
}

ref_frame_to_flag_in_vp9_encoder :: (ref_frame: s8) -> s32 {

    return K_VP9_REF_FLAG_LIST_in_vp9_encoder[ref_frame];
}

svc_twostage_scale :: (
    cm: *VP9_COMMON,
    unscaled: *YV12_BUFFER_CONFIG,
    scaled: *YV12_BUFFER_CONFIG,
    scaled_temp: *YV12_BUFFER_CONFIG,
    filter_type: INTERP_FILTER,
    phase_scaler: s32,
    filter_type2: INTERP_FILTER,
    phase_scaler2: s32
) -> *YV12_BUFFER_CONFIG {
    if cm.mi_cols * (cast(s32) 1) << 3 != unscaled.y_width || cm.mi_rows * (cast(s32) 1) << 3 != unscaled.y_height {
        vp9_scale_and_extend_frame_c(unscaled, scaled_temp, filter_type2, phase_scaler2);
        vp9_scale_and_extend_frame_c(scaled_temp, scaled, filter_type, phase_scaler);

        return scaled;
    } else {
        return unscaled;
    }
}

save_encode_params :: (cpi: *VP9_COMP_in_vp9_encoder) {
    j: s32 = ---;

    rd_opt := *cpi.rd;
    for i: 0..cast(s32) 4 - 1 {
        j = 0;
        while j < REFERENCE_MODES {
            rd_opt.prediction_type_threshes_prev[i][j] = rd_opt.prediction_type_threshes[i][j];
            j += 1;
        }

        j = 0;
        while j < 3 + 1 {
            rd_opt.filter_threshes_prev[i][j] = rd_opt.filter_threshes[i][j];
            j += 1;
        }
    }

    tile_idx: s32 = 0;
    while tile_idx < cpi.allocated_tiles {
        tile_data := *cpi.tile_data[tile_idx];
        {
            #assert tile_data.thresh_freq_fact_prev.count * size_of([30] s32) == tile_data.thresh_freq_fact.count * size_of([30] s32);

            copy_memory(
                tile_data.thresh_freq_fact_prev.data,
                tile_data.thresh_freq_fact.data,
                tile_data.thresh_freq_fact.count * size_of([30] s32)
            );
        }
        tile_idx += 1;
    }
}

init_sb_mul_scale_buffer :: (cpi: *VP9_COMP_in_vp9_encoder) {
    cm := *cpi.common;

    if cpi.mb_wiener_var_rows >= cm.mb_rows && cpi.mb_wiener_var_cols >= cm.mb_cols {
        return;
    }

    deallocate_memory(cast(*void) cpi.sb_mul_scale);
    cpi.sb_mul_scale = null;

    cpi.sb_mul_scale = cast(*s64) calloc_2(cast,no_check(u64) (cm.mb_rows * cm.mb_cols), size_of(s64));

    if cpi.sb_mul_scale == null {
        internal_error(
            *cm.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->sb_mul_scale")
        );
    }
    cpi.mb_wiener_var_rows = cm.mb_rows;
    cpi.mb_wiener_var_cols = cm.mb_cols;
}

set_mb_wiener_variance :: (cpi: *VP9_COMP_in_vp9_encoder) {
    cm := *cpi.common;
    buffer := cpi.source.y_buffer;
    buf_stride := cpi.source.y_stride;

    zero_pred: [1024] u8 = --- #align 16;

    src_diff: [1024] s16 = --- #align 16;
    coeff: [1024] Tran_Low_T = --- #align 16;
    mb_col: s32 = ---;
    count: s32 = 0;

    BLOCK_SIZE_: s32 = 16;
    COEFF_COUNT := BLOCK_SIZE_ * BLOCK_SIZE_;
    TX_SIZE_: TX_SIZE = 2;

    fill_memory(zero_pred.data, 0, cast,no_check(u64) COEFF_COUNT);

    cpi.norm_wiener_variance = 0;

    mb_row: s32 = 0;
    while mb_row < cm.mb_rows {
        mb_col = 0;
        while mb_col < cm.mb_cols {
            median_val: s16 = 0;
            mb_buffer := buffer + mb_row * BLOCK_SIZE_ * buf_stride + mb_col * BLOCK_SIZE_;
            wiener_variance: s64 = 0;

            subtract_block_c(
                BLOCK_SIZE_,
                BLOCK_SIZE_,
                src_diff.data,
                cast,no_check(s64) BLOCK_SIZE_,
                mb_buffer,
                cast,no_check(s64) buf_stride,
                zero_pred.data,
                cast,no_check(s64) BLOCK_SIZE_
            );
            vp9_wht_fwd_txfm(src_diff.data, BLOCK_SIZE_, coeff.data, TX_SIZE_);

            coeff[0] = 0;
            if 1 < COEFF_COUNT {
                for idx: 1..COEFF_COUNT - 1 {
                    coeff[idx] = cast,no_check(Tran_Low_T) absolute_value(cast,no_check(s32) coeff[idx]);
                }
            }

            c_transpiler_qsort(
                cast(*void) coeff.data,
                cast,no_check(u64) COEFF_COUNT,
                size_of(Tran_Low_T),
                cast,no_check(Compar_Fn_T) qsort_comp
            );

            median_val = coeff[COEFF_COUNT / 2];

            if 1 < COEFF_COUNT {
                for idx: 1..COEFF_COUNT - 1 {
                    sqr_coeff := (cast,no_check(s64) coeff[idx]) * cast(s64) coeff[idx];
                    tmp_coeff := cast,no_check(s64) coeff[idx];
                    if median_val != 0 {
                        tmp_coeff =
                            (sqr_coeff * cast(s64) coeff[idx]) /
                                (sqr_coeff + (cast,no_check(s64) median_val) * cast(s64) median_val);
                    }
                    wiener_variance += tmp_coeff * tmp_coeff;
                }
            }
            cpi.mb_wiener_variance[mb_row * cm.mb_cols + mb_col] = wiener_variance / cast(s64) COEFF_COUNT;
            cpi.norm_wiener_variance += cpi.mb_wiener_variance[mb_row * cm.mb_cols + mb_col];
            count += 1;
            mb_col += 1;
        }
        mb_row += 1;
    }

    if count != 0 {
        cpi.norm_wiener_variance /= cast,no_check(s64) count;
    }
    cpi.norm_wiener_variance = ifx 1 > cpi.norm_wiener_variance then 1 else cpi.norm_wiener_variance;
}

qsort_comp :: (elem1: *void, elem2: *void) -> s32 {
    a := cast,no_check(s32) ((cast(*Tran_Low_T) elem1).*);
    b := cast,no_check(s32) ((cast(*Tran_Low_T) elem2).*);
    if a > b {
        return 1;
    }
    if a < b {
        return -1;
    }
    return 0;
}

init_mb_wiener_var_buffer :: (cpi: *VP9_COMP_in_vp9_encoder) {
    cm := *cpi.common;

    if cpi.mb_wiener_variance != null && cpi.mb_wiener_var_rows >= cm.mb_rows && cpi.mb_wiener_var_cols >= cm.mb_cols {
        return;
    }

    deallocate_memory(cast(*void) cpi.mb_wiener_variance);
    cpi.mb_wiener_variance = null;

    cpi.mb_wiener_variance =
        cast(*s64) calloc_2(
            cast,no_check(u64) (cm.mb_rows * cm.mb_cols),
            size_of(s64)
        );

    if cpi.mb_wiener_variance == null {
        internal_error(
            *cm.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->mb_wiener_variance")
        );
    }
    cpi.mb_wiener_var_rows = cm.mb_rows;
    cpi.mb_wiener_var_cols = cm.mb_cols;
}

set_mb_ssim_rdmult_scaling :: (cpi: *VP9_COMP_in_vp9_encoder) {
    cm := *cpi.common;
    td := *cpi.td;
    x := *td.mb;
    xd := *x.e_mbd;
    y_buffer := cpi.source.y_buffer;
    Y_STRIDE := cpi.source.y_stride;
    BLOCK_SIZE_: s32 = 6;

    NUM_8X8_W := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[BLOCK_SIZE_];
    NUM_8X8_H := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[BLOCK_SIZE_];
    NUM_COLS := (cm.mi_cols + NUM_8X8_W - 1) / NUM_8X8_W;
    NUM_ROWS := (cm.mi_rows + NUM_8X8_H - 1) / NUM_8X8_H;
    log_sum: float64 = 0.0;
    col: s32 = ---;

    if 0 < NUM_ROWS {
        for row: 0..NUM_ROWS - 1 {
            col = 0;
            while col < NUM_COLS {
                mi_col: s32 = ---;
                var: float64 = 0.0;
                num_of_var: float64 = 0.0;
                INDEX := row * NUM_COLS + col;

                mi_row := row * NUM_8X8_H;
                while mi_row < cm.mi_rows && mi_row < (row + 1) * NUM_8X8_H {
                    mi_col = col * NUM_8X8_W;
                    while mi_col < cm.mi_cols && mi_col < (col + 1) * NUM_8X8_W {
                        buf: Buf_2d = ---;
                        ROW_OFFSET_Y := mi_row << 3;
                        COL_OFFSET_Y := mi_col << 3;

                        buf.buf = y_buffer + ROW_OFFSET_Y * Y_STRIDE + COL_OFFSET_Y;
                        buf.stride = Y_STRIDE;

                        var += cast,no_check(float64) vp9_get_sby_variance(cpi, *buf, 3);

                        num_of_var += 1.0;
                        mi_col += 1;
                    }
                    mi_row += 1;
                }
                var = var / num_of_var / 64.0;

                var = 67.035434 * (1.0 - c_transpiler_math_exp(-0.0021489 * var)) + 17.492222;
                cpi.mi_ssim_rdmult_scaling_factors[INDEX] = var;
                log_sum += c_transpiler_math_log(var);
                col += 1;
            }
        }
    }
    log_sum = c_transpiler_math_exp(log_sum / cast,no_check(float64) (NUM_ROWS * NUM_COLS));

    if 0 < NUM_ROWS {
        for row: 0..NUM_ROWS - 1 {
            col = 0;
            while col < NUM_COLS {
                INDEX := row * NUM_COLS + col;
                cpi.mi_ssim_rdmult_scaling_factors[INDEX] /= log_sum;
                col += 1;
            }
        }
    }
}

init_mb_ssim_rdmult_scaling_buffer :: (cpi: *VP9_COMP_in_vp9_encoder) {
    cm := *cpi.common;

    if cpi.mi_ssim_rdmult_scaling_factors != null &&
        cpi.mi_ssim_rdmult_scaling_factors_rows >= cm.mb_rows &&
        cpi.mi_ssim_rdmult_scaling_factors_cols >= cm.mb_cols {
        return;
    }

    deallocate_memory(cast(*void) cpi.mi_ssim_rdmult_scaling_factors);
    cpi.mi_ssim_rdmult_scaling_factors = null;

    cpi.mi_ssim_rdmult_scaling_factors =
        cast(*float64) calloc_2(
            cast,no_check(u64) (cm.mb_rows * cm.mb_cols),
            size_of(float64)
        );

    if cpi.mi_ssim_rdmult_scaling_factors == null {
        internal_error(
            *cm.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->mi_ssim_rdmult_scaling_factors")
        );
    }
    cpi.mi_ssim_rdmult_scaling_factors_rows = cm.mb_rows;
    cpi.mi_ssim_rdmult_scaling_factors_cols = cm.mb_cols;
}

setup_interp_filter_search_mask :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    ifilter: INTERP_FILTER = ---;
    ref_total: [4] s32;

    mask: s32 = 0;
    if cpi.common.last_frame_type == cast,no_check(u32) KEY_FRAME || cpi.refresh_alt_ref_frame != 0 {
        return mask;
    }
    ref: MV_REFERENCE_FRAME = 1;
    while ref <= 3 {
        ifilter = 0;
        while ifilter <= 2 {
            ref_total[ref] += cpi.interp_filter_selected[ref][ifilter];
            ifilter += 1;
        }
        ref += 1;
    }

    ifilter = 0;
    while ifilter <= 2 {
        if ref_total[1] != 0 &&
            cpi.interp_filter_selected[1][ifilter] == 0 &&
            (ref_total[2] == 0 || cpi.interp_filter_selected[2][ifilter] * 50 < ref_total[2]) &&
            (ref_total[3] == 0 || cpi.interp_filter_selected[3][ifilter] * 50 < ref_total[3]) {
            mask |= (cast(s32) 1) << ((ifilter) & 31);
        }
        ifilter += 1;
    }
    return mask;
}

set_ref_sign_bias :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    REF_BUFFER := get_ref_cnt_buffer_in_vp9_encoder(CM, CM.new_fb_idx);
    CUR_FRAME_INDEX := REF_BUFFER.frame_index;

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame < 4 {
        BUF_IDX := get_ref_frame_buf_idx_in_vp9_encoder(cpi, cast,no_check(s32) ref_frame);
        REF_CNT_BUF := get_ref_cnt_buffer_in_vp9_encoder(*cpi.common, BUF_IDX);
        if REF_CNT_BUF != null {
            CM.ref_frame_sign_bias[ref_frame] = cast(s32) (CUR_FRAME_INDEX < REF_CNT_BUF.frame_index);
        }
        ref_frame += 1;
    }
}

set_frame_index :: (cpi: *VP9_COMP_in_vp9_encoder, cm: *VP9_COMMON) {
    REF_BUFFER := get_ref_cnt_buffer_in_vp9_encoder(cm, cm.new_fb_idx);

    if REF_BUFFER != null {
        GF_GROUP_ := *cpi.twopass.gf_group;
        REF_BUFFER.frame_index =
            cast,no_check(s32) (cm.current_video_frame +
                cast(u32) GF_GROUP_.arf_src_offset[GF_GROUP_.index]);
        REF_BUFFER.frame_coding_index = cm.current_frame_coding_index;
    }
}

set_ext_overrides :: (cpi: *VP9_COMP_in_vp9_encoder) {
    if cpi.ext_refresh_frame_context_pending != 0 {
        cpi.common.refresh_frame_context = cpi.ext_refresh_frame_context;
        cpi.ext_refresh_frame_context_pending = 0;
    }
    if cpi.ext_refresh_frame_flags_pending != 0 {
        cpi.refresh_last_frame = cpi.ext_refresh_last_frame;
        cpi.refresh_golden_frame = cpi.ext_refresh_golden_frame;
        cpi.refresh_alt_ref_frame = cpi.ext_refresh_alt_ref_frame;
    }
}

svc_encode :: (cpi: *VP9_COMP_in_vp9_encoder, size: *u64, dest: *u8, dest_size: u64, frame_flags: *u32) {
    vp9_rc_get_svc_params(cpi);
    encode_frame_to_data_rate_in_vp9_encoder(cpi, size, dest, dest_size, frame_flags, null);
}

pass2_encode_in_vp9_encoder :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    size: *u64,
    dest: *u8,
    dest_size: u64,
    frame_flags: *u32,
    encode_frame_result: *ENCODE_FRAME_RESULT
) {
    cpi.allow_encode_breakout = cast,no_check(ENCODE_BREAKOUT_TYPE) ENCODE_BREAKOUT_ENABLED;

    encode_frame_to_data_rate_in_vp9_encoder(cpi, size, dest, dest_size, frame_flags, encode_frame_result);
}

should_run_tpl :: (cpi: *VP9_COMP_in_vp9_encoder, gf_group_index: s32) -> s32 {
    RC := *cpi.rc;
    if cpi.sf.enable_tpl_model == 0 {
        return 0;
    }

    if gf_group_index == 1 && cpi.twopass.gf_group.update_type[gf_group_index] == cast,no_check(u32) ARF_UPDATE {
        return 1;
    }

    if cpi.ext_ratectrl.ready != 0 &&
        cpi.ext_ratectrl.funcs.send_tpl_gop_stats != null &&
        RC.frames_till_gf_update_due == RC.baseline_gf_interval &&
        cpi.twopass.gf_group.update_type[1] != cast,no_check(u32) ARF_UPDATE {
        return 1;
    }
    return 0;
}

level_rc_framerate :: (cpi: *VP9_COMP_in_vp9_encoder, arf_src_index: s32) {
    RC := *cpi.rc;
    LS := *cpi.level_constraint;
    CM := *cpi.common;
    MAX_CPB_SIZE := LS.max_cpb_size;

    RC.max_frame_bandwidth =
        ifx RC.max_frame_bandwidth < LS.max_frame_size then RC.max_frame_bandwidth else LS.max_frame_size;
    if frame_is_intra_only_in_vp9_encoder(CM) != 0 {
        RC.max_frame_bandwidth =
            ifx RC.max_frame_bandwidth < cast,no_check(s32) (MAX_CPB_SIZE *
                0.5) then RC.max_frame_bandwidth else cast,no_check(s32) (MAX_CPB_SIZE * 0.5);
    } else if arf_src_index > 0 {
        RC.max_frame_bandwidth =
            ifx RC.max_frame_bandwidth < cast,no_check(s32) (MAX_CPB_SIZE *
                0.4) then RC.max_frame_bandwidth else cast,no_check(s32) (MAX_CPB_SIZE * 0.4);
    } else {
        RC.max_frame_bandwidth =
            ifx RC.max_frame_bandwidth < cast,no_check(s32) (MAX_CPB_SIZE *
                0.2) then RC.max_frame_bandwidth else cast,no_check(s32) (MAX_CPB_SIZE * 0.2);
    }
}

adjust_frame_rate :: (cpi: *VP9_COMP_in_vp9_encoder, source: *Lookahead_Entry_in_vp9_lookahead) {
    this_duration: s64 = ---;
    step: s32 = 0;

    if source.ts_start == cpi.first_time_stamp_ever {
        this_duration = source.ts_end - source.ts_start;
        step = 1;
    } else {
        last_duration := cpi.last_end_time_stamp_seen - cpi.last_time_stamp_seen;

        this_duration = source.ts_end - cpi.last_end_time_stamp_seen;

        if last_duration != 0 {
            step = cast,no_check(s32) (((this_duration - last_duration) * 10) / last_duration);
        }
    }

    if this_duration != 0 {
        if step != 0 {
            vp9_new_framerate(cpi, 10000000.0 / cast,no_check(float64) this_duration);
        } else {
            INTERVAL :=
                (ifx c_transpiler_float_less(cast,no_check(float64) (source.ts_end - cpi.first_time_stamp_ever), 10000000.0) then cast,no_check(float64) (source.ts_end -
                    cpi.first_time_stamp_ever) else 10000000.0);
            avg_duration := 10000000.0 / cpi.framerate;
            avg_duration *= INTERVAL - avg_duration + this_duration;
            avg_duration /= INTERVAL;

            vp9_new_framerate(cpi, 10000000.0 / avg_duration);
        }
    }
    cpi.last_time_stamp_seen = source.ts_start;
    cpi.last_end_time_stamp_seen = source.ts_end;
}

check_src_altref :: (cpi: *VP9_COMP_in_vp9_encoder, source: *Lookahead_Entry_in_vp9_lookahead) {
    RC := *cpi.rc;

    if cpi.oxcf.pass == 2 {
        GF_GROUP_ := *cpi.twopass.gf_group;
        RC.is_src_frame_alt_ref =
            cast(s32) (GF_GROUP_.update_type[GF_GROUP_.index] == cast,no_check(u32) OVERLAY_UPDATE);
    } else {
        RC.is_src_frame_alt_ref = cast(s32) (cpi.alt_ref_source != null && source == cpi.alt_ref_source);
    }

    if RC.is_src_frame_alt_ref != 0 {
        cpi.alt_ref_source = null;

        cpi.refresh_last_frame = 0;
    }
}

stack_init_in_vp9_encoder :: (stack: *s32, length: s32) {
    if 0 < length {
        for idx: 0..length - 1 {
            stack[idx] = -1;
        }
    }
}

get_arf_src_index :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    RC := *cpi.rc;
    arf_src_index: s32 = 0;
    if is_altref_enabled_in_vp9_encoder(cpi) != 0 {
        if cpi.oxcf.pass == 2 {
            GF_GROUP_ := *cpi.twopass.gf_group;
            if GF_GROUP_.update_type[GF_GROUP_.index] == cast,no_check(u32) ARF_UPDATE {
                arf_src_index = cast,no_check(s32) GF_GROUP_.arf_src_offset[GF_GROUP_.index];
            }
        } else if RC.source_alt_ref_pending != 0 {
            arf_src_index = RC.frames_till_gf_update_due;
        }
    }
    return arf_src_index;
}

is_altref_enabled_in_vp9_encoder :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if !(CPI.oxcf.mode == cast,no_check(u32) REALTIME && CPI.oxcf.rc_mode == cast,no_check(u32) CBR) &&
        CPI.oxcf.lag_in_frames >= 4 &&
        CPI.oxcf.enable_auto_arf != 0 {
        return 1;
    }
    return 0;
}

vp9_get_preview_raw_frame :: (cpi: *VP9_COMP_in_vp9_encoder, dest: *YV12_BUFFER_CONFIG, flags: *Vp9_Ppflags_T) -> s32 {
    cm := *cpi.common;

    if cm.show_frame == 0 {
        return -1;
    } else {
        ret: s32 = ---;

        if cm.frame_to_show != null {
            assignment_11: YV12_BUFFER_CONFIG = cm.frame_to_show.*;
            ((dest).*) = assignment_11;
            dest.y_width = cm.width;
            dest.y_height = cm.height;
            dest.uv_width = cm.width >> ((cm.subsampling_x) & 31);
            dest.uv_height = cm.height >> ((cm.subsampling_y) & 31);
            ret = 0;
        } else {
            ret = -1;
        }

        return ret;
    }
}

vp9_use_as_reference :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame_flags: s32) -> s32 {
    if ref_frame_flags > 7 {
        return -1;
    }

    cpi.ref_frame_flags = ref_frame_flags;
    return 0;
}

vp9_update_reference :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame_flags: s32) {
    cpi.ext_refresh_golden_frame = cast(s32) ((ref_frame_flags & cast,no_check(s32) (VP9_GOLD_FLAG)) != 0);
    cpi.ext_refresh_alt_ref_frame = cast(s32) ((ref_frame_flags & cast,no_check(s32) (VP9_ALT_FLAG)) != 0);
    cpi.ext_refresh_last_frame = cast(s32) ((ref_frame_flags & cast,no_check(s32) (VP9_LAST_FLAG)) != 0);
    cpi.ext_refresh_frame_flags_pending = 1;
}

vp9_copy_reference_enc :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    ref_frame_flag: VP9_REFFRAME,
    sd: *YV12_BUFFER_CONFIG
) -> s32 {
    cfg := get_vp9_ref_frame_buffer(cpi, ref_frame_flag);
    if cfg != null {
        yv12_copy_frame_c(cfg, sd);
        return 0;
    } else {
        return -1;
    }
}

get_vp9_ref_frame_buffer :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame_flag: VP9_REFFRAME) -> *YV12_BUFFER_CONFIG {
    ref_frame: MV_REFERENCE_FRAME = -1;
    if ref_frame_flag == cast,no_check(u32) VP9_LAST_FLAG {
        ref_frame = 1;
    } else if ref_frame_flag == cast,no_check(u32) VP9_GOLD_FLAG {
        ref_frame = 2;
    } else if ref_frame_flag == cast,no_check(u32) VP9_ALT_FLAG {
        ref_frame = 3;
    }

    return ifx ref_frame == -1 then null else get_ref_frame_buffer_in_vp9_encoder(cpi, ref_frame);
}

vp9_set_reference_enc :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame_flag: VP9_REFFRAME, sd: *YV12_BUFFER_CONFIG) -> s32 {
    cfg := get_vp9_ref_frame_buffer(cpi, ref_frame_flag);
    if cfg != null {
        yv12_copy_frame_c(sd, cfg);
        return 0;
    } else {
        return -1;
    }
}

vp9_update_entropy :: (cpi: *VP9_COMP_in_vp9_encoder, update: s32) -> s32 {
    cpi.ext_refresh_frame_context = update;
    cpi.ext_refresh_frame_context_pending = 1;
    return 0;
}

vp9_set_active_map :: (cpi: *VP9_COMP_in_vp9_encoder, new_map_16x16: *u8, rows: s32, cols: s32) -> s32 {
    if rows == cpi.common.mb_rows && cols == cpi.common.mb_cols {
        ACTIVE_MAP_8X8 := cpi.active_map.map;
        MI_ROWS := cpi.common.mi_rows;
        MI_COLS := cpi.common.mi_cols;
        cpi.active_map.update = 1;
        if new_map_16x16 != null {
            c: s32 = ---;
            if 0 < MI_ROWS {
                for r: 0..MI_ROWS - 1 {
                    c = 0;
                    while c < MI_COLS {
                        ACTIVE_MAP_8X8[r * MI_COLS + c] =
                            ifx new_map_16x16[r >> 1 * cols +
                                c >> 1] != 0 then cast(u8) 0 else 7;
                        c += 1;
                    }
                }
            }
            cpi.active_map.enabled = 1;
        } else {
            cpi.active_map.enabled = 0;
        }
        return 0;
    } else {
        return -1;
    }
}

vp9_get_active_map :: (cpi: *VP9_COMP_in_vp9_encoder, new_map_16x16: *u8, rows: s32, cols: s32) -> s32 {
    if rows == cpi.common.mb_rows && cols == cpi.common.mb_cols && new_map_16x16 != null {
        SEG_MAP_8X8: *u8 = cpi.segmentation_map;
        MI_ROWS := cpi.common.mi_rows;
        MI_COLS := cpi.common.mi_cols;
        fill_memory(new_map_16x16, cast(s32) (cpi.active_map.enabled == 0), cast,no_check(u64) (rows * cols));
        if cpi.active_map.enabled != 0 {
            c: s32 = ---;
            if 0 < MI_ROWS {
                for r: 0..MI_ROWS - 1 {
                    c = 0;
                    while c < MI_COLS {
                        new_map_16x16[r >> 1 * cols + c >> 1] = cast,no_check(u8) ((cast,no_check(s32) new_map_16x16[r >> 1 * cols + c >> 1]) | cast(s32) (SEG_MAP_8X8[r * MI_COLS + c] != 7));
                        c += 1;
                    }
                }
            }
        }
        return 0;
    } else {
        return -1;
    }
}

vp9_set_internal_size :: (cpi: *VP9_COMP_in_vp9_encoder, horiz_mode: SCALING_MODE, vert_mode: SCALING_MODE) -> s32 {
    cm := *cpi.common;
    hr: s32 = 0;
    hs: s32 = 0;
    vr: s32 = 0;
    vs: s32 = 0;

    if horiz_mode > cast,no_check(u32) VP8E_ONETWO || vert_mode > cast,no_check(u32) VP8E_ONETWO {
        return -1;
    }

    scale2_ratio_in_vp9_encoder(horiz_mode, *hr, *hs);
    scale2_ratio_in_vp9_encoder(vert_mode, *vr, *vs);

    cm.width = (hs - 1 + cpi.oxcf.width * hr) / hs;
    cm.height = (vs - 1 + cpi.oxcf.height * vr) / vs;
    if cm.current_video_frame != 0 {
    }

    update_frame_size(cpi);

    return 0;
}

scale2_ratio_in_vp9_encoder :: (mode: SCALING_MODE, hr: *s32, hs: *s32) {
    if mode == {
        case cast,no_check(u32) VP8E_NORMAL;
            hr.* = 1;
            hs.* = 1;
        case cast,no_check(u32) VP8E_FOURFIVE;
            hr.* = 4;
            hs.* = 5;
        case cast,no_check(u32) VP8E_THREEFIVE;
            hr.* = 3;
            hs.* = 5;
        case;
            hr.* = 1;
            hs.* = 2;
    }
}

vp9_set_svc :: (cpi: *VP9_COMP_in_vp9_encoder, use_svc: s32) {
    cpi.use_svc = use_svc;
}

stack_top_in_vp9_encoder :: (stack: *s32) -> s32 {
    return stack[0];
}

allocated_tokens_in_vp9_encoder :: (tile: Tile_Info) -> s64 {
    tile_mb_rows := (tile.mi_row_end - tile.mi_row_start + 1) >> 1;
    tile_mb_cols := (tile.mi_col_end - tile.mi_col_start + 1) >> 1;

    return get_token_alloc_in_vp9_encoder(tile_mb_rows, tile_mb_cols);
}

get_start_tok_in_vp9_encoder :: (
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

    tok.* = cpi.tile_tok[tile_row][tile_col] + get_token_alloc_in_vp9_encoder(MB_ROW, tile_mb_cols);
}

vp9_get_ref_frame_info :: (
    update_type: FRAME_UPDATE_TYPE,
    ref_frame_flags: s32,
    ref_frame_bufs: **Ref_Cnt_Buffer,
    ref_frame_coding_indexes: *s32,
    ref_frame_valid_list: *s32
) {
    if update_type != cast,no_check(u32) KF_UPDATE {
        INTER_REF_FLAGS :=
            VP9_REFFRAME.[ cast,no_check(VP9_REFFRAME) VP9_LAST_FLAG, cast,no_check(VP9_REFFRAME) VP9_GOLD_FLAG, cast,no_check(VP9_REFFRAME) VP9_ALT_FLAG ];

        for i: 0..cast(s32) 3 - 1 {
            ref_frame_coding_indexes[i] = ref_frame_bufs[i].frame_coding_index;
            ref_frame_valid_list[i] = cast(s32) (((cast,no_check(u32) ref_frame_flags) & INTER_REF_FLAGS[i]) != 0);
        }
    } else {
        for i: 0..cast(s32) 3 - 1 {
            ref_frame_coding_indexes[i] = -1;
            ref_frame_valid_list[i] = 0;
        }
    }
}

vp9_apply_encoding_flags :: (cpi: *VP9_COMP_in_vp9_encoder, flags: Enc_Frame_Flags_T) {
    if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 16 | ((cast(s32) 1) << 17) | ((cast(s32) 1) << 21)) != 0 {
        ref: s32 = 7;

        if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 16) != 0 {
            ref ^= cast,no_check(s32) (VP9_LAST_FLAG);
        }

        if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 17) != 0 {
            ref ^= cast,no_check(s32) (VP9_GOLD_FLAG);
        }

        if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 21) != 0 {
            ref ^= cast,no_check(s32) (VP9_ALT_FLAG);
        }

        vp9_use_as_reference(cpi, ref);
    }

    if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 18 | ((cast(s32) 1) << 22) | ((cast(s32) 1) << 23) | ((cast(s32) 1) << 19) | ((cast(s32) 1) << 24)) != 0 {
        upd: s32 = 7;

        if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 18) != 0 {
            upd ^= cast,no_check(s32) (VP9_LAST_FLAG);
        }

        if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 22) != 0 {
            upd ^= cast,no_check(s32) (VP9_GOLD_FLAG);
        }

        if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 23) != 0 {
            upd ^= cast,no_check(s32) (VP9_ALT_FLAG);
        }

        vp9_update_reference(cpi, upd);
    }

    if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 20) != 0 {
        vp9_update_entropy(cpi, 0);
    }
}

get_chessboard_index_in_vp9_encoder :: (FRAME_INDEX: s32) -> s32 {
    return FRAME_INDEX & 0x1;
}

cond_cost_list_in_vp9_encoder :: (cpi: *VP9_COMP_in_vp9_encoder, cost_list: *s32) -> *s32 {
    return ifx cpi.sf.mv.subpel_search_method != cast,no_check(u32) SUBPEL_TREE then cost_list else null;
}

get_num_vert_units_in_vp9_encoder :: (tile: Tile_Info, shift: s32) -> s32 {
    num_vert_units := (tile.mi_row_end - tile.mi_row_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_vert_units;
}

get_num_cols_in_vp9_encoder :: (tile: Tile_Info, shift: s32) -> s32 {
    num_cols := (tile.mi_col_end - tile.mi_col_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_cols;
}

vp9_get_level :: (LEVEL_SPEC: *Vp9_Level_Spec) -> VP9_LEVEL {
    i: s32 = 0;
    while i < 14 {
        this_level := VP9_LEVEL_DEFS.data + i;
        if c_transpiler_float_greater(cast,no_check(float64) LEVEL_SPEC.max_luma_sample_rate, ((cast,no_check(float64) this_level.max_luma_sample_rate) * 1.015)) ||
            LEVEL_SPEC.max_luma_picture_size > this_level.max_luma_picture_size ||
            LEVEL_SPEC.max_luma_picture_breadth > this_level.max_luma_picture_breadth ||
            c_transpiler_float_greater(LEVEL_SPEC.average_bitrate, this_level.average_bitrate) ||
            c_transpiler_float_greater(LEVEL_SPEC.max_cpb_size, this_level.max_cpb_size) ||
            c_transpiler_float_less(LEVEL_SPEC.compression_ratio, this_level.compression_ratio) ||
            LEVEL_SPEC.max_col_tiles > this_level.max_col_tiles ||
            LEVEL_SPEC.min_altref_distance < this_level.min_altref_distance ||
            LEVEL_SPEC.max_ref_frame_buffers > this_level.max_ref_frame_buffers {
            i += 1;
            continue;
        }
        break;
    }
    return ifx i == 14 then cast,no_check(u32) LEVEL_UNKNOWN else VP9_LEVEL_DEFS[i].level;
}

vp9_set_roi_map :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    map: *u8,
    rows: u32,
    cols: u32,
    delta_q: *s32,
    delta_lf: *s32,
    skip: *s32,
    ref_frame: *s32
) -> Codec_Err_T {
    cm := *cpi.common;
    roi := *cpi.roi;
    RANGE_: s32 = 63;
    REF_FRAME_RANGE: s32 = 3;
    SKIP_RANGE: s32 = 1;
    FRAME_ROWS := cpi.common.mi_rows;
    FRAME_COLS := cpi.common.mi_cols;

    if FRAME_ROWS != cast,no_check(s32) rows || FRAME_COLS != cast,no_check(s32) cols {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if check_seg_range(delta_q, RANGE_) == 0 ||
        check_seg_range(delta_lf, RANGE_) == 0 ||
        check_seg_range(ref_frame, REF_FRAME_RANGE) == 0 ||
        check_seg_range(skip, SKIP_RANGE) == 0 {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if map == null ||
        delta_q[0] | delta_q[1] | delta_q[2] | delta_q[3] | delta_q[4] | delta_q[5] | delta_q[6] | delta_q[7] | delta_lf[0] | delta_lf[1] | delta_lf[2] | delta_lf[3] | delta_lf[4] | delta_lf[5] | delta_lf[6] | delta_lf[7] | skip[0] | skip[1] | skip[2] | skip[3] | skip[4] | skip[5] | skip[6] | skip[7] == 0 &&
            ref_frame[0] == -1 &&
            ref_frame[1] == -1 &&
            ref_frame[2] == -1 &&
            ref_frame[3] == -1 &&
            ref_frame[4] == -1 &&
            ref_frame[5] == -1 &&
            ref_frame[6] == -1 &&
            ref_frame[7] == -1 {
        vp9_disable_segmentation(*cm.seg);
        cpi.roi.enabled = 0;
        return cast,no_check(Codec_Err_T) CODEC_OK;
    }

    if roi.roi_map != null {
        deallocate_memory(cast(*void) roi.roi_map);
        roi.roi_map = null;
    }
    roi.roi_map = cast(*u8) allocate_memory(cast,no_check(u64) (rows * cols));
    if roi.roi_map == null {
        return cast,no_check(Codec_Err_T) CODEC_MEM_ERROR;
    }

    copy_memory(roi.roi_map, map, cast,no_check(u64) (rows * cols));
    copy_memory(*roi.delta_q, delta_q, cast(u64) 8 * size_of(s32));
    copy_memory(*roi.delta_lf, delta_lf, cast(u64) 8 * size_of(s32));
    copy_memory(*roi.skip, skip, cast(u64) 8 * size_of(s32));
    copy_memory(*roi.ref_frame, ref_frame, cast(u64) 8 * size_of(s32));
    roi.enabled = 1;
    roi.rows = rows;
    roi.cols = cols;

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

check_seg_range :: (seg_data: *s32, range: s32) -> s32 {
    for i: 0..cast(s32) 8 - 1 {
        if seg_data[i] > range || seg_data[i] < -range {
            return 0;
        }
    }
    return 1;
}

vp9_get_psnr :: (cpi: *VP9_COMP_in_vp9_encoder, psnr: *PSNR_STATS) -> s32 {
    if is_psnr_calc_enabled(cpi) != 0 {
        calc_psnr(cpi.raw_source_frame, cpi.common.frame_to_show, psnr, cpi.svc.spatial_layer_id);

        return 1;
    } else {
        fill_memory(psnr, 0, size_of(PSNR_STATS));
        return 0;
    }
}

mv_cost_in_vp9_encoder :: (mv: *MV, joint_cost: *s32, comp_cost: **s32) -> s32 {
    return joint_cost[vp9_get_mv_joint_in_vp9_encoder(mv)] + comp_cost[0][mv.row] + comp_cost[1][mv.col];
}

mvsad_err_cost_in_vp9_encoder :: (x: *MACROBLOCK, mv: *MV, ref: *MV, sad_per_bit: s32) -> s32 {
    diff: MV = ---;
    diff.row = cast,no_check(s16) ((cast(s32) mv.row) - cast(s32) ref.row);
    diff.col = cast,no_check(s16) ((cast(s32) mv.col) - cast(s32) ref.col);
    return cast,no_check(s32) ((((cast,no_check(u32) mv_cost_in_vp9_encoder(*diff, x.nmvjointsadcost.data, x.nmvsadcost.data)) * cast,no_check(u32) sad_per_bit) + cast,no_check(u32) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9);
}

get_start_mv_sad_in_vp9_encoder :: (
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
    start_mv_sad += cast,no_check(u32) mvsad_err_cost_in_vp9_encoder(x, mvp_full, ref_mv_full, sadpb);

    return start_mv_sad;
}

num_4x4_to_edge_in_vp9_encoder :: (plane_4x4_dim: s32, mb_to_edge_dim: s32, subsampling_dim: s32, blk_dim: s32) -> s32 {
    return plane_4x4_dim + mb_to_edge_dim >> (((5 + subsampling_dim)) & 31) - blk_dim;
}

sum_squares_visible_in_vp9_encoder :: (
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
        num_4x4_to_edge_in_vp9_encoder(
            PLANE_4X4_W,
            xd.mb_to_right_edge,
            PD.subsampling_x,
            blk_col
        );
    B4X4S_TO_BOTTOM_EDGE :=
        num_4x4_to_edge_in_vp9_encoder(
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

do_trellis_opt_in_vp9_encoder :: (
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
                    sum_squares_visible_in_vp9_encoder(
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

timebase_units_to_ticks_in_vp9_encoder :: (timestamp_ratio: *Rational64_T, n: s64) -> s64 {
    return n * timestamp_ratio.num / cast(s64) timestamp_ratio.den;
}

ticks_to_timebase_units_in_vp9_encoder :: (timestamp_ratio: *Rational64_T, n: s64) -> s64 {
    round := timestamp_ratio.num / 2;
    if round > 0 {
        round -= 1;
    }
    return ((n * cast(s64) timestamp_ratio.den) + round) / timestamp_ratio.num;
}

globals_initialization_state_for_vp9_encoder: u32;
initialize_globals_for_vp9_encoder :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_encoder);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_encoder, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_encoder) != 2 {}
            return;
        }
    }
    K_VP9_REF_FLAG_LIST_in_vp9_encoder =
        s32.[ 0, cast,no_check(s32) (VP9_LAST_FLAG), cast,no_check(s32) (VP9_GOLD_FLAG), cast,no_check(s32) (VP9_ALT_FLAG) ];
    SUB_PEL_FILTERS_12_in_vp9_encoder =
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
    lock_in_vp9_encoder = 0;
    COUNT_TO_UPDATE_FACTOR_in_vp9_encoder =
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
    COSPI_1_64_in_vp9_encoder = 16364;
    COSPI_2_64_in_vp9_encoder = 16305;
    COSPI_3_64_in_vp9_encoder = 16207;
    COSPI_4_64_in_vp9_encoder = 16069;
    COSPI_5_64_in_vp9_encoder = 15893;
    COSPI_6_64_in_vp9_encoder = 15679;
    COSPI_7_64_in_vp9_encoder = 15426;
    COSPI_8_64_in_vp9_encoder = 15137;
    COSPI_9_64_in_vp9_encoder = 14811;
    COSPI_10_64_in_vp9_encoder = 14449;
    COSPI_11_64_in_vp9_encoder = 14053;
    COSPI_12_64_in_vp9_encoder = 13623;
    COSPI_13_64_in_vp9_encoder = 13160;
    COSPI_14_64_in_vp9_encoder = 12665;
    COSPI_15_64_in_vp9_encoder = 12140;
    COSPI_16_64_in_vp9_encoder = 11585;
    COSPI_17_64_in_vp9_encoder = 11003;
    COSPI_18_64_in_vp9_encoder = 10394;
    COSPI_19_64_in_vp9_encoder = 9760;
    COSPI_20_64_in_vp9_encoder = 9102;
    COSPI_21_64_in_vp9_encoder = 8423;
    COSPI_22_64_in_vp9_encoder = 7723;
    COSPI_23_64_in_vp9_encoder = 7005;
    COSPI_24_64_in_vp9_encoder = 6270;
    COSPI_25_64_in_vp9_encoder = 5520;
    COSPI_26_64_in_vp9_encoder = 4756;
    COSPI_27_64_in_vp9_encoder = 3981;
    COSPI_28_64_in_vp9_encoder = 3196;
    COSPI_29_64_in_vp9_encoder = 2404;
    COSPI_30_64_in_vp9_encoder = 1606;
    COSPI_31_64_in_vp9_encoder = 804;
    SINPI_1_9_in_vp9_encoder = 5283;
    SINPI_2_9_in_vp9_encoder = 9929;
    SINPI_3_9_in_vp9_encoder = 13377;
    SINPI_4_9_in_vp9_encoder = 15212;
    FRAME_SCALE_FACTOR_in_vp9_encoder = s32.[ 16, 24 ];
    RATE_THRESH_MULT_in_vp9_encoder = float64.[ 1.0, 2.0 ];
    RCF_MULT_in_vp9_encoder = float64.[ 1.0, 2.0 ];
    VP9_LEVEL_DEFS =
        Vp9_Level_Spec.[
            Vp9_Level_Spec.{level = cast,no_check(VP9_LEVEL) LEVEL_1, max_luma_sample_rate = 829440, max_luma_picture_size = 36864, max_luma_picture_breadth = 512, average_bitrate = 200.0, max_cpb_size = 400.0, compression_ratio = 2.0, max_col_tiles = 1, min_altref_distance = 4, max_ref_frame_buffers = 8},
            Vp9_Level_Spec.{level = cast,no_check(VP9_LEVEL) LEVEL_1_1, max_luma_sample_rate = 2764800, max_luma_picture_size = 73728, max_luma_picture_breadth = 768, average_bitrate = 800.0, max_cpb_size = 1000.0, compression_ratio = 2.0, max_col_tiles = 1, min_altref_distance = 4, max_ref_frame_buffers = 8},
            Vp9_Level_Spec.{level = cast,no_check(VP9_LEVEL) LEVEL_2, max_luma_sample_rate = 4608000, max_luma_picture_size = 122880, max_luma_picture_breadth = 960, average_bitrate = 1800.0, max_cpb_size = 1500.0, compression_ratio = 2.0, max_col_tiles = 1, min_altref_distance = 4, max_ref_frame_buffers = 8},
            Vp9_Level_Spec.{level = cast,no_check(VP9_LEVEL) LEVEL_2_1, max_luma_sample_rate = 9216000, max_luma_picture_size = 245760, max_luma_picture_breadth = 1344, average_bitrate = 3600.0, max_cpb_size = 2800.0, compression_ratio = 2.0, max_col_tiles = 2, min_altref_distance = 4, max_ref_frame_buffers = 8},
            Vp9_Level_Spec.{level = cast,no_check(VP9_LEVEL) LEVEL_3, max_luma_sample_rate = 20736000, max_luma_picture_size = 552960, max_luma_picture_breadth = 2048, average_bitrate = 7200.0, max_cpb_size = 6000.0, compression_ratio = 2.0, max_col_tiles = 4, min_altref_distance = 4, max_ref_frame_buffers = 8},
            Vp9_Level_Spec.{level = cast,no_check(VP9_LEVEL) LEVEL_3_1, max_luma_sample_rate = 36864000, max_luma_picture_size = 983040, max_luma_picture_breadth = 2752, average_bitrate = 12000.0, max_cpb_size = 10000.0, compression_ratio = 2.0, max_col_tiles = 4, min_altref_distance = 4, max_ref_frame_buffers = 8},
            Vp9_Level_Spec.{level = cast,no_check(VP9_LEVEL) LEVEL_4, max_luma_sample_rate = 83558400, max_luma_picture_size = 2228224, max_luma_picture_breadth = 4160, average_bitrate = 18000.0, max_cpb_size = 16000.0, compression_ratio = 4.0, max_col_tiles = 4, min_altref_distance = 4, max_ref_frame_buffers = 8},
            Vp9_Level_Spec.{level = cast,no_check(VP9_LEVEL) LEVEL_4_1, max_luma_sample_rate = 160432128, max_luma_picture_size = 2228224, max_luma_picture_breadth = 4160, average_bitrate = 30000.0, max_cpb_size = 18000.0, compression_ratio = 4.0, max_col_tiles = 4, min_altref_distance = 5, max_ref_frame_buffers = 6},
            Vp9_Level_Spec.{level = cast,no_check(VP9_LEVEL) LEVEL_5, max_luma_sample_rate = 311951360, max_luma_picture_size = 8912896, max_luma_picture_breadth = 8384, average_bitrate = 60000.0, max_cpb_size = 36000.0, compression_ratio = 6.0, max_col_tiles = 8, min_altref_distance = 6, max_ref_frame_buffers = 4},
            Vp9_Level_Spec.{level = cast,no_check(VP9_LEVEL) LEVEL_5_1, max_luma_sample_rate = 588251136, max_luma_picture_size = 8912896, max_luma_picture_breadth = 8384, average_bitrate = 120000.0, max_cpb_size = 46000.0, compression_ratio = 8.0, max_col_tiles = 8, min_altref_distance = 10, max_ref_frame_buffers = 4},
            Vp9_Level_Spec.{level = cast,no_check(VP9_LEVEL) LEVEL_5_2, max_luma_sample_rate = 1176502272, max_luma_picture_size = 8912896, max_luma_picture_breadth = 8384, average_bitrate = 180000.0, max_cpb_size = 90000.0, compression_ratio = 8.0, max_col_tiles = 8, min_altref_distance = 10, max_ref_frame_buffers = 4},
            Vp9_Level_Spec.{level = cast,no_check(VP9_LEVEL) LEVEL_6, max_luma_sample_rate = 1176502272, max_luma_picture_size = 35651584, max_luma_picture_breadth = 16832, average_bitrate = 180000.0, max_cpb_size = 90000.0, compression_ratio = 8.0, max_col_tiles = 16, min_altref_distance = 10, max_ref_frame_buffers = 4},
            Vp9_Level_Spec.{level = cast,no_check(VP9_LEVEL) LEVEL_6_1, max_luma_sample_rate = 2353004544, max_luma_picture_size = 35651584, max_luma_picture_breadth = 16832, average_bitrate = 240000.0, max_cpb_size = 180000.0, compression_ratio = 8.0, max_col_tiles = 16, min_altref_distance = 10, max_ref_frame_buffers = 4},
            Vp9_Level_Spec.{level = cast,no_check(VP9_LEVEL) LEVEL_6_2, max_luma_sample_rate = 4706009088, max_luma_picture_size = 35651584, max_luma_picture_breadth = 16832, average_bitrate = 480000.0, max_cpb_size = 360000.0, compression_ratio = 8.0, max_col_tiles = 16, min_altref_distance = 10, max_ref_frame_buffers = 4}
        ];
    level_fail_messages =
        *s8.[
            c_string("The average bit-rate is too high."),
            c_string("The picture size is too large."),
            c_string("The picture width/height is too large."),
            c_string("The luma sample rate is too large."),
            c_string("The CPB size is too large."),
            c_string("The compression ratio is too small"),
            c_string("Too many column tiles are used."),
            c_string("The alt-ref distance is too small."),
            c_string("Too many reference buffers are used.")
        ];
    atomic_store(*globals_initialization_state_for_vp9_encoder, 2);
}

TARGET_LEVEL_FAIL_ID :: u32;
BITRATE_TOO_LARGE : s32 : 0;
LUMA_PIC_SIZE_TOO_LARGE : s32 : 1;
LUMA_PIC_BREADTH_TOO_LARGE : s32 : 2;
LUMA_SAMPLE_RATE_TOO_LARGE : s32 : 3;
CPB_TOO_LARGE : s32 : 4;
COMPRESSION_RATIO_TOO_SMALL : s32 : 5;
TOO_MANY_COLUMN_TILE : s32 : 6;
ALTREF_DIST_TOO_SMALL : s32 : 7;
TOO_MANY_REF_BUFFER : s32 : 8;
TARGET_LEVEL_FAIL_IDS : s32 : 9;


Once_In_Vp9_Encoder_Parameter_0_Type :: #type () #c_call;
