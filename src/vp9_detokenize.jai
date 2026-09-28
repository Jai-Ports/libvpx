COUNT_TO_UPDATE_FACTOR_in_vp9_detokenize: [21] s32;

SUB_PEL_FILTERS_12_in_vp9_detokenize: [16] Interp_Kernel12 #align 256;

clip_pixel_in_vp9_detokenize :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_detokenize :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_detokenize :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_detokenize :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_detokenize :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_detokenize(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_detokenize(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_detokenize(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_detokenize :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_prob_in_vp9_detokenize :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_detokenize :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_detokenize(n0, DEN);
}

weighted_prob_in_vp9_detokenize :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_detokenize :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_detokenize(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_detokenize(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_detokenize :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_detokenize[COUNT];
        PROB := get_prob_in_vp9_detokenize(ct[0], DEN);
        return weighted_prob_in_vp9_detokenize(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_lsb_in_vp9_detokenize :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_detokenize :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_detokenize :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_detokenize(num_values) + 1 else 0;
}

get_band_translate_in_vp9_detokenize :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_detokenize :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_detokenize :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_detokenize(above_ec, left_ec);
}

is_zero_mv_in_vp9_detokenize :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_detokenize :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_detokenize :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_detokenize(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_detokenize(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_detokenize :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_detokenize :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_detokenize :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_detokenize :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

get_filter_taps_in_vp9_detokenize :: (FILTER: *s16) -> s32 {
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

vp9_is_valid_scale_in_vp9_detokenize :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_detokenize :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_detokenize(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_detokenize :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_detokenize :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_detokenize :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_detokenize :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_detokenize :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_detokenize :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_detokenize :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_detokenize :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_detokenize :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_detokenize :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_detokenize :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_detokenize(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_detokenize :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_detokenize(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_detokenize(MI, ib)];
}

get_uv_tx_size_in_vp9_detokenize :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_detokenize :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_detokenize :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_detokenize(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_detokenize :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

codec_control_vp8_set_reference_in_vp9_detokenize :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Ref_Frame_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_copy_reference_in_vp9_detokenize :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Ref_Frame_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_set_postproc_in_vp9_detokenize :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Vp8_Postproc_Cfg_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_get_reference_in_vp9_detokenize :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Vp9_Ref_Frame_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_last_ref_updates_in_vp9_detokenize :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_frame_corrupted_in_vp9_detokenize :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_last_ref_used_in_vp9_detokenize :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vpxd_set_decryptor_in_vp9_detokenize :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Decrypt_Init
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_set_decryptor_in_vp9_detokenize :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Decrypt_Init
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_frame_size_in_vp9_detokenize :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_display_size_in_vp9_detokenize :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_bit_depth_in_vp9_detokenize :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *u32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_set_byte_alignment_in_vp9_detokenize :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_invert_tile_decode_order_in_vp9_detokenize :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_set_skip_loop_filter_in_vp9_detokenize :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_decode_svc_spatial_layer_in_vp9_detokenize :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vpxd_get_last_quantizer_in_vp9_detokenize :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_set_row_mt_in_vp9_detokenize :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_set_loop_filter_opt_in_vp9_detokenize :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

reader_has_error_in_vp9_detokenize :: (r: *Reader) -> s32 {
    if r.count > (cast,no_check(s32) (cast(u64) size_of(BD_VALUE))) * 8 && r.count < 0x40000000 {
        return 1;
    }
    return 0;
}

read_in_vp9_detokenize :: (r: *Reader, prob: s32) -> s32 {
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

read_bit_in_vp9_detokenize :: (r: *Reader) -> s32 {
    return read_in_vp9_detokenize(r, 128);
}

read_literal_in_vp9_detokenize :: (r: *Reader, bits: s32) -> s32 {
    literal: s32 = 0;

    bit := bits - 1;
    while bit >= 0 {
        literal |= read_bit_in_vp9_detokenize(r) << ((bit) & 31);
        bit -= 1;
    }

    return literal;
}

read_tree_in_vp9_detokenize :: (r: *Reader, tree: *Tree_Index, probs: *Prob) -> s32 {
    i: Tree_Index = 0;

    while (ifx true { assignment_1: Tree_Index = cast,no_check(Tree_Index) (tree[(cast(s32) i) + read_in_vp9_detokenize(r, cast,no_check(s32) probs[(cast(s32) i) >> 1])]); (i) = assignment_1; assignment_1; }) > 0 {
        continue;
    }

    return -(cast,no_check(s32) i);
}

get_lfm_in_vp9_detokenize :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_detokenize :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_detokenize :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_detokenize :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_detokenize :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_detokenize :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_detokenize :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_detokenize :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_detokenize :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_detokenize :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_detokenize :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_detokenize :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_detokenize(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_detokenize :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_detokenize(cm.mi_cols);

        if get_plane_type_in_vp9_detokenize(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_detokenize(cm, xd);
}

get_partition_probs_in_vp9_detokenize :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_detokenize :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_detokenize :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_detokenize :: (
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

update_partition_context_in_vp9_detokenize :: (
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

partition_plane_context_in_vp9_detokenize :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

read_marker_in_vp9_detokenize :: (decrypt_cb: Decrypt_Cb, decrypt_state: *void, data: *u8) -> u8 {
    if decrypt_cb != null {
        marker: u8 = ---;
        decrypt_cb(decrypt_state, data, *marker, 1);
        return marker;
    }
    return data.*;
}

decrease_ref_count_in_vp9_detokenize :: (idx: s32, FRAME_BUFS: *Ref_Cnt_Buffer, POOL: *Buffer_Pool) {
    if idx >= 0 && FRAME_BUFS[idx].ref_count > 0 {
        FRAME_BUFS[idx].ref_count -= 1;

        if FRAME_BUFS[idx].released == 0 && FRAME_BUFS[idx].ref_count == 0 && FRAME_BUFS[idx].raw_frame_buffer.priv != null {
            POOL.release_fb_cb(POOL.cb_priv, *FRAME_BUFS[idx].raw_frame_buffer);
            FRAME_BUFS[idx].released = 1;
        }
    }
}

get_coef_context_in_vp9_detokenize :: (neighbors: *s16, token_cache: *u8, c: s32) -> s32 {
    return ((1 + cast(s32) token_cache[neighbors[2 * c + 0]]) + cast(s32) token_cache[neighbors[2 * c + 1]]) >> 1;
}

get_scan_in_vp9_detokenize :: (
    xd: *MACROBLOCKD,
    tx_size: TX_SIZE,
    type: PLANE_TYPE,
    block_idx: s32
) -> *Scan_Order_in_vp9_scan {
    MI := xd.mi[0];

    if is_inter_block_in_vp9_detokenize(MI) != 0 || type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 {
        return VP9_DEFAULT_SCAN_ORDERS.data + tx_size;
    } else {
        MODE_ := get_y_mode_in_vp9_detokenize(MI, block_idx);
        return VP9_SCAN_ORDERS[tx_size].data + INTRA_MODE_TO_TX_TYPE_LOOKUP[MODE_];
    }
}

vp9_decode_block_tokens :: (
    twd: *Tile_Worker_Data,
    plane: s32,
    sc: *Scan_Order_in_vp9_scan,
    x: s32,
    y: s32,
    tx_size: TX_SIZE,
    seg_id: s32
) -> s32 {
    r := *twd.bit_reader;
    xd := *twd.xd;
    PD := xd.plane.data + plane;
    DEQUANT := PD.seg_dequant[seg_id].data;
    eob: s32 = ---;
    a := PD.above_context + x;
    l := PD.left_context + y;
    ctx: s32 = ---;
    ctx_shift_a: s32 = 0;
    ctx_shift_l: s32 = 0;

    if cast,no_check(s32) tx_size == {
        case cast,no_check(s32) cast(TX_SIZE) 0;
            ctx = cast(s32) (a[0] != 0);
            ctx += cast(s32) (l[0] != 0);
            eob =
                decode_coefs(
                    xd,
                    get_plane_type_in_vp9_detokenize(plane),
                    PD.dqcoeff,
                    tx_size,
                    DEQUANT,
                    ctx,
                    sc.scan,
                    sc.neighbors,
                    r
                );
            l[0] = cast(ENTROPY_CONTEXT) (eob > 0);
            a[0] = l[0];
        case cast,no_check(s32) cast(TX_SIZE) 1;
            get_ctx_shift(
                xd,
                *ctx_shift_a,
                *ctx_shift_l,
                x,
                y,
                cast,no_check(u32) ((cast(s32) 1) << ((cast(TX_SIZE) 1) & 31))
            );
            ctx = cast(s32) (((cast(*u16) a).*) != 0);
            ctx += cast(s32) (((cast(*u16) l).*) != 0);
            eob =
                decode_coefs(
                    xd,
                    get_plane_type_in_vp9_detokenize(plane),
                    PD.dqcoeff,
                    tx_size,
                    DEQUANT,
                    ctx,
                    sc.scan,
                    sc.neighbors,
                    r
                );
            assignment_2: u16 = cast,no_check(u16) (((cast(s32) (eob > 0)) * 0x101) >> ((ctx_shift_a) & 31));
            ((cast(*u16) a).*) = assignment_2;
            assignment_3: u16 = cast,no_check(u16) (((cast(s32) (eob > 0)) * 0x101) >> ((ctx_shift_l) & 31));
            ((cast(*u16) l).*) = assignment_3;
        case cast,no_check(s32) cast(TX_SIZE) 2;
            get_ctx_shift(
                xd,
                *ctx_shift_a,
                *ctx_shift_l,
                x,
                y,
                cast,no_check(u32) ((cast(s32) 1) << ((cast(TX_SIZE) 2) & 31))
            );
            ctx = cast(s32) (((cast(*u32) a).*) != 0);
            ctx += cast(s32) (((cast(*u32) l).*) != 0);
            eob =
                decode_coefs(
                    xd,
                    get_plane_type_in_vp9_detokenize(plane),
                    PD.dqcoeff,
                    tx_size,
                    DEQUANT,
                    ctx,
                    sc.scan,
                    sc.neighbors,
                    r
                );
            assignment_4: u32 = cast,no_check(u32) (((cast(s32) (eob > 0)) * 0x1010101) >> ((ctx_shift_a) & 31));
            ((cast(*u32) a).*) = assignment_4;
            assignment_5: u32 = cast,no_check(u32) (((cast(s32) (eob > 0)) * 0x1010101) >> ((ctx_shift_l) & 31));
            ((cast(*u32) l).*) = assignment_5;
        case cast,no_check(s32) cast(TX_SIZE) 3;
            get_ctx_shift(
                xd,
                *ctx_shift_a,
                *ctx_shift_l,
                x,
                y,
                cast,no_check(u32) ((cast(s32) 1) << ((cast(TX_SIZE) 3) & 31))
            );
            ctx = cast(s32) (((cast(*u64) a).*) != 0);
            ctx += cast(s32) (((cast(*u64) l).*) != 0);
            eob =
                decode_coefs(
                    xd,
                    get_plane_type_in_vp9_detokenize(plane),
                    PD.dqcoeff,
                    tx_size,
                    DEQUANT,
                    ctx,
                    sc.scan,
                    sc.neighbors,
                    r
                );
            assignment_6: u64 = (((cast(u64) (eob > 0)) * 0x101010101010101) >> ((ctx_shift_a) & 63));
            ((cast(*u64) a).*) = assignment_6;
            assignment_7: u64 = (((cast(u64) (eob > 0)) * 0x101010101010101) >> ((ctx_shift_l) & 63));
            ((cast(*u64) l).*) = assignment_7;
        case;
            eob = 0;
    }

    return eob;
}

decode_coefs :: (
    xd: *MACROBLOCKD,
    type: PLANE_TYPE,
    dqcoeff: *Tran_Low_T,
    tx_size: TX_SIZE,
    dq: *s16,
    ctx: s32,
    scan: *s16,
    nb: *s16,
    r: *Reader
) -> s32 {
    counts := xd.counts;
    MAX_EOB := (cast(s32) 16) << ((((cast(s32) tx_size) << 1)) & 31);
    FC := xd.fc;
    REF := is_inter_block_in_vp9_detokenize(xd.mi[0]);
    c: s32 = 0;
    coef_probs: *[6] [3] Prob = FC.coef_probs[tx_size][type][REF].data;

    coef_counts: *[6] [4] u32 = ---;
    eob_branch_count: *[6] u32 = ---;
    token_cache: [1024] u8 = ---;
    band_translate := get_band_translate_in_vp9_detokenize(tx_size);
    DQ_SHIFT := cast(s32) (tx_size == cast(TX_SIZE) 3);
    v: s32 = ---;
    dqv := dq[0];
    CAT6_PROB := VP9_CAT6_PROB.data;
    CAT6_BITS: s32 = 14;

    value := r.value;
    range := r.range;
    count := r.count;

    if counts != null {
        coef_counts = counts.coef[tx_size][type][REF].data;
        eob_branch_count = counts.eob_branch[tx_size][type][REF].data;
    }

    while c < MAX_EOB {
        val: s32 = -1;
        band := cast,no_check(s32) ((c_transpiler_post_increment(*(band_translate))).*);
        prob := coef_probs[band][ctx].data;
        if counts != null {
            eob_branch_count[band][ctx] += 1;
        }
        if read_bool(r, cast,no_check(s32) prob[0], *value, *count, *range) == 0 {
            if counts != null {
                coef_counts[band][ctx][3] += 1;
            }
            break;
        }

        while read_bool(r, cast,no_check(s32) prob[1], *value, *count, *range) == 0 {
            if counts != null {
                coef_counts[band][ctx][0] += 1;
            }
            dqv = dq[1];
            token_cache[scan[c]] = 0;
            c += 1;
            if c >= MAX_EOB {
                r.value = value;
                r.range = range;
                r.count = count;
                return c;
            }
            ctx = get_coef_context_in_vp9_detokenize(nb, token_cache.data, c);
            band = cast,no_check(s32) ((c_transpiler_post_increment(*(band_translate))).*);
            prob = coef_probs[band][ctx].data;
        }

        if read_bool(r, cast,no_check(s32) prob[2], *value, *count, *range) != 0 {
            p := VP9_PARETO8_FULL[(cast(s32) prob[2]) - 1].data;
            if counts != null {
                coef_counts[band][ctx][2] += 1;
            }
            if read_bool(r, cast,no_check(s32) p[0], *value, *count, *range) != 0 {
                if read_bool(r, cast,no_check(s32) p[3], *value, *count, *range) != 0 {
                    token_cache[scan[c]] = 5;
                    if read_bool(r, cast,no_check(s32) p[5], *value, *count, *range) != 0 {
                        if read_bool(r, cast,no_check(s32) p[7], *value, *count, *range) != 0 {
                            val = 67 + read_coeff(r, CAT6_PROB, CAT6_BITS, *value, *count, *range);
                        } else {
                            val = 35 + read_coeff(r, VP9_CAT5_PROB.data, 5, *value, *count, *range);
                        }
                    } else if read_bool(r, cast,no_check(s32) p[6], *value, *count, *range) != 0 {
                        val = 19 + read_coeff(r, VP9_CAT4_PROB.data, 4, *value, *count, *range);
                    } else {
                        val = 11 + read_coeff(r, VP9_CAT3_PROB.data, 3, *value, *count, *range);
                    }
                } else {
                    token_cache[scan[c]] = 4;
                    if read_bool(r, cast,no_check(s32) p[4], *value, *count, *range) != 0 {
                        val = 7 + read_coeff(r, VP9_CAT2_PROB.data, 2, *value, *count, *range);
                    } else {
                        val = 5 + read_coeff(r, VP9_CAT1_PROB.data, 1, *value, *count, *range);
                    }
                }

                v = (val * cast(s32) dqv) >> ((DQ_SHIFT) & 31);
            } else if read_bool(r, cast,no_check(s32) p[1], *value, *count, *range) != 0 {
                token_cache[scan[c]] = 3;
                v =
                    ((3 + read_bool(r, cast,no_check(s32) p[2], *value, *count, *range)) *
                        cast(s32) dqv) >> ((DQ_SHIFT) & 31);
            } else {
                token_cache[scan[c]] = 2;
                v = (2 * cast(s32) dqv) >> ((DQ_SHIFT) & 31);
            }
        } else {
            if counts != null {
                coef_counts[band][ctx][1] += 1;
            }
            token_cache[scan[c]] = 1;
            v = (cast(s32) dqv) >> ((DQ_SHIFT) & 31);
        }

        if read_bool(r, 128, *value, *count, *range) != 0 {
            dqcoeff[scan[c]] = cast,no_check(Tran_Low_T) (-v);
        } else {
            dqcoeff[scan[c]] = cast,no_check(Tran_Low_T) v;
        }

        c += 1;
        ctx = get_coef_context_in_vp9_detokenize(nb, token_cache.data, c);
        dqv = dq[1];
    }

    r.value = value;
    r.range = range;
    r.count = count;
    return c;
}

read_bool :: (r: *Reader, prob: s32, value: *BD_VALUE, count: *s32, range: *u32) -> s32 {
    SPLIT := ((range.* * cast,no_check(u32) prob) + cast,no_check(u32) (256 - prob)) >> 8;
    BIGSPLIT :=
        (cast,no_check(BD_VALUE) SPLIT) << ((((cast,no_check(s32) (cast(u64) size_of(BD_VALUE))) * 8 -
            8)) & 63);

    if count.* < 0 {
        r.value = value.*;
        r.count = count.*;
        reader_fill(r);
        value.* = r.value;
        count.* = r.count;
    }

    if value.* >= BIGSPLIT {
        range.* = range.* - SPLIT;
        value.* = value.* - BIGSPLIT;
        {
            SHIFT := cast,no_check(s32) NORM[range.*];
            c_transpiler_compound_shl(*(range.*), (((cast,no_check(u32) SHIFT) & 31)), u32, u32);
            c_transpiler_compound_shl(*(value.*), (((cast,no_check(BD_VALUE) SHIFT) & 63)), BD_VALUE, BD_VALUE);
            count.* -= SHIFT;
        }

        return 1;
    }
    range.* = SPLIT;
    {
        SHIFT := cast,no_check(s32) NORM[range.*];
        c_transpiler_compound_shl(*(range.*), (((cast,no_check(u32) SHIFT) & 31)), u32, u32);
        c_transpiler_compound_shl(*(value.*), (((cast,no_check(BD_VALUE) SHIFT) & 63)), BD_VALUE, BD_VALUE);
        count.* -= SHIFT;
    }

    return 0;
}

read_coeff :: (r: *Reader, probs: *Prob, n: s32, value: *BD_VALUE, count: *s32, range: *u32) -> s32 {
    val: s32 = 0;
    if 0 < n {
        for i: 0..n - 1 {
            val = val << 1 | read_bool(r, cast,no_check(s32) probs[i], value, count, range);
        }
    }
    return val;
}

get_ctx_shift :: (xd: *MACROBLOCKD, ctx_shift_a: *s32, ctx_shift_l: *s32, x: s32, y: s32, tx_size_in_blocks: u32) {
    if xd.max_blocks_wide != 0 {
        if (tx_size_in_blocks + cast,no_check(u32) x) > xd.max_blocks_wide {
            ctx_shift_a.* = cast,no_check(s32) ((tx_size_in_blocks - (xd.max_blocks_wide - cast,no_check(u32) x)) * 8);
        }
    }
    if xd.max_blocks_high != 0 {
        if (tx_size_in_blocks + cast,no_check(u32) y) > xd.max_blocks_high {
            ctx_shift_l.* = cast,no_check(s32) ((tx_size_in_blocks - (xd.max_blocks_high - cast,no_check(u32) y)) * 8);
        }
    }
}

globals_initialization_state_for_vp9_detokenize: u32;
initialize_globals_for_vp9_detokenize :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_detokenize);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_detokenize, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_detokenize) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_vp9_detokenize =
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
    SUB_PEL_FILTERS_12_in_vp9_detokenize =
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
    atomic_store(*globals_initialization_state_for_vp9_detokenize, 2);
}

