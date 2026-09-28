// Generated directly from C by cpp_transpiler.
COUNT_TO_UPDATE_FACTOR_in_vp9_ethread: [21] s32;

SUB_PEL_FILTERS_12_in_vp9_ethread: [16] Interp_Kernel12 #align 256;

FRAME_SCALE_FACTOR_in_vp9_ethread: [2] s32;

RATE_THRESH_MULT_in_vp9_ethread: [2] float64;

RCF_MULT_in_vp9_ethread: [2] float64;

K_VP9_REF_FLAG_LIST_in_vp9_ethread: [4] s32;

clip_pixel_in_vp9_ethread :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_ethread :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_ethread :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_ethread :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_ethread :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_ethread(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_ethread(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_ethread(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_ethread :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_prob_in_vp9_ethread :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_ethread :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_ethread(n0, DEN);
}

weighted_prob_in_vp9_ethread :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_ethread :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_ethread(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_ethread(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_ethread :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_ethread[COUNT];
        PROB := get_prob_in_vp9_ethread(ct[0], DEN);
        return weighted_prob_in_vp9_ethread(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_lsb_in_vp9_ethread :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_ethread :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_ethread :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_ethread(num_values) + 1 else 0;
}

get_band_translate_in_vp9_ethread :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_ethread :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_ethread :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_ethread(above_ec, left_ec);
}

is_zero_mv_in_vp9_ethread :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_ethread :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_ethread :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_ethread(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_ethread(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_ethread :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_ethread :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_ethread :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_ethread :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

get_filter_taps_in_vp9_ethread :: (FILTER: *s16) -> s32 {
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

vp9_is_valid_scale_in_vp9_ethread :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_ethread :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_ethread(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_ethread :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_ethread :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_ethread :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_ethread :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_ethread :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_ethread :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_ethread :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_ethread :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_ethread :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_ethread :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_ethread :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_ethread(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_ethread :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_ethread(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_ethread(MI, ib)];
}

get_uv_tx_size_in_vp9_ethread :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_ethread :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_ethread :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_ethread(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_ethread :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_ethread :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

vp8_set_reference_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_vp9_ethread :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_vp9_ethread :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_vp9_ethread :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

gcd_in_vp9_ethread :: (a: s64, b: s32) -> s32 {
    while b != 0 {
        r := cast,no_check(s32) (a % cast(s64) b);
        a = cast,no_check(s64) b;
        b = r;
    }

    return cast,no_check(s32) a;
}

reduce_ratio_in_vp9_ethread :: (ratio: *Rational64_T) {
    DENOM := gcd_in_vp9_ethread(ratio.num, ratio.den);
    ratio.num /= cast,no_check(s64) DENOM;
    ratio.den /= DENOM;
}

init_frame_indexes_in_vp9_ethread :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_ethread :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_ethread :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_ethread :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_ethread :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_ethread :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_ethread :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_ethread :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_ethread :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_ethread :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_ethread :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_ethread(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_ethread :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_ethread(cm.mi_cols);

        if get_plane_type_in_vp9_ethread(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_ethread(cm, xd);
}

get_partition_probs_in_vp9_ethread :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_ethread :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_ethread :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_ethread :: (
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

update_partition_context_in_vp9_ethread :: (
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

partition_plane_context_in_vp9_ethread :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

cyclic_refresh_segment_id_boosted_in_vp9_ethread :: (segment_id: s32) -> s32 {
    if segment_id == 1 || segment_id == 2 {
        return 1;
    }
    return 0;
}

cyclic_refresh_segment_id_in_vp9_ethread :: (segment_id: s32) -> s32 {
    if segment_id == 1 {
        return 1;
    } else if segment_id == 2 {
        return 2;
    } else {
        return 0;
    }
}

vp9_encode_free_mt_data :: (cpi: *VP9_COMP_in_vp9_encoder) {
    t: s32 = 0;
    while t < cpi.num_workers {
        WORKER := *(cast(*Worker) (cpi.workers))[t];
        THREAD_DATA: *Enc_Worker_Data = *(cast(*Enc_Worker_Data) (cpi.tile_thr_data))[t];

        (get_worker_interface()).end(WORKER);

        if t < cpi.num_workers - 1 {
            deallocate_memory(cast(*void) THREAD_DATA.td.counts);
            vp9_free_pc_tree(THREAD_DATA.td);
            deallocate_memory(cast(*void) THREAD_DATA.td);
        }
        t += 1;
    }
    deallocate_memory(cast(*void) cpi.tile_thr_data);
    cpi.tile_thr_data = null;
    deallocate_memory(cast(*void) cpi.workers);
    cpi.workers = null;
    cpi.num_workers = 0;
}

vp9_encode_tiles_mt :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    NUM_WORKERS := (ifx cpi.oxcf.max_threads < TILE_COLS then cpi.oxcf.max_threads else TILE_COLS);

    vp9_init_tile_data(cpi);

    create_enc_workers(cpi, NUM_WORKERS);

    if 0 < NUM_WORKERS {
        for i: 0..NUM_WORKERS - 1 {
            THREAD_DATA: *Enc_Worker_Data = *(cast(*Enc_Worker_Data) (cpi.tile_thr_data))[i];

            if THREAD_DATA.td != *cpi.td {
                assignment_0: MACROBLOCK = cpi.td.mb;
                ((*THREAD_DATA.td.mb).*) = assignment_0;
                assignment_1: RD_COUNTS = cpi.td.rd_counts;
                ((*THREAD_DATA.td.rd_counts).*) = assignment_1;
            }
            if THREAD_DATA.td.counts != *cpi.common.counts {
                copy_memory(THREAD_DATA.td.counts, *cpi.common.counts, size_of(FRAME_COUNTS));
            }

            if cpi.sf.use_nonrd_pick_mode != 0 {
                X := *THREAD_DATA.td.mb;
                XD := *X.e_mbd;
                P := X.plane.data;
                PD := XD.plane.data;
                ctx := *THREAD_DATA.td.pc_root.none;

                for j: 0..cast(s32) 3 - 1 {
                    P[j].coeff = ctx.coeff_pbuf[j][0];
                    P[j].qcoeff = ctx.qcoeff_pbuf[j][0];
                    PD[j].dqcoeff = ctx.dqcoeff_pbuf[j][0];
                    P[j].eobs = ctx.eobs_pbuf[j][0];
                }
            }
        }
    }

    launch_enc_workers(cpi, cast,no_check(Worker_Hook) enc_worker_hook, null, NUM_WORKERS);

    if 0 < NUM_WORKERS {
        for i: 0..NUM_WORKERS - 1 {
            WORKER := *(cast(*Worker) (cpi.workers))[i];
            THREAD_DATA := cast(*Enc_Worker_Data) WORKER.data1;

            if i < cpi.num_workers - 1 {
                vp9_accumulate_frame_counts(*CM.counts, THREAD_DATA.td.counts, 0);
                accumulate_rd_opt(*cpi.td, THREAD_DATA.td);
            }
        }
    }
}

accumulate_rd_opt :: (td: *Thread_Data_in_vp9_encoder, td_t: *Thread_Data_in_vp9_encoder) {
    j: s32 = ---;
    k: s32 = ---;
    l: s32 = ---;
    m: s32 = ---;
    n: s32 = ---;

    i: s32 = 0;
    while i < REFERENCE_MODES {
        td.rd_counts.comp_pred_diff[i] += td_t.rd_counts.comp_pred_diff[i];
        i += 1;
    }

    i = 0;
    while i < 3 + 1 {
        td.rd_counts.filter_diff[i] += td_t.rd_counts.filter_diff[i];
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
                    while m < 6 {
                        n = 0;
                        while n < 12 {
                            td.rd_counts.coef_counts[i][j][k][l][m][n] += td_t.rd_counts.coef_counts[i][j][k][l][m][n];
                            n += 1;
                        }
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
}

enc_worker_hook :: (arg1: *void, unused: *void) -> s32 {
    THREAD_DATA := cast(*Enc_Worker_Data) arg1;
    CPI: *VP9_COMP_in_vp9_encoder = THREAD_DATA.cpi;
    CM := *CPI.common;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    TILE_ROWS := (cast(s32) 1) << ((CM.log2_tile_rows) & 31);

    t := THREAD_DATA.start;
    while t < TILE_ROWS * TILE_COLS {
        tile_row := t / TILE_COLS;
        tile_col := t % TILE_COLS;

        vp9_encode_tile(CPI, THREAD_DATA.td, tile_row, tile_col);
        t += CPI.num_workers;
    }

    return 1;
}

launch_enc_workers :: (cpi: *VP9_COMP_in_vp9_encoder, hook: Worker_Hook, data2: *void, num_workers: s32) {
    WINTERFACE := get_worker_interface();

    if 0 < num_workers {
        for i: 0..num_workers - 1 {
            WORKER := *(cast(*Worker) (cpi.workers))[i];
            WORKER.hook = hook;
            WORKER.data1 = cast(*void) (*(cast(*Enc_Worker_Data) (cpi.tile_thr_data))[i]);
            WORKER.data2 = data2;
        }
    }

    if 0 < num_workers {
        for i: 0..num_workers - 1 {
            WORKER := *(cast(*Worker) (cpi.workers))[i];
            THREAD_DATA := cast(*Enc_Worker_Data) WORKER.data1;

            THREAD_DATA.start = i;

            if i == cpi.num_workers - 1 {
                WINTERFACE.execute(WORKER);
            } else {
                WINTERFACE.launch(WORKER);
            }
        }
    }

    if 0 < num_workers {
        for i: 0..num_workers - 1 {
            WORKER := *(cast(*Worker) (cpi.workers))[i];
            WINTERFACE.sync(WORKER);
        }
    }
}

launch_enc_workers :: (cpi: *VP9_COMP_in_vp9_encoder, hook: Worker_Hook, data2: *$Value, num_workers: s32) {
    launch_enc_workers(cpi, hook, cast(*void) data2, num_workers);
}

create_enc_workers :: (cpi: *VP9_COMP_in_vp9_encoder, num_workers: s32) {
    CM := *cpi.common;
    WINTERFACE := get_worker_interface();

    if cpi.use_svc != 0 && cpi.row_mt == 0 {
        max_tile_cols := get_max_tile_cols(cpi);
        num_workers = ifx cpi.oxcf.max_threads < max_tile_cols then cpi.oxcf.max_threads else max_tile_cols;
    }

    if num_workers == cpi.num_workers {
        return;
    }
    vp9_loop_filter_dealloc(*cpi.lf_row_sync);
    vp9_bitstream_encode_tiles_buffer_dealloc(cpi);
    vp9_encode_free_mt_data(cpi);

    cpi.workers = cast(*Worker) allocate_memory((cast,no_check(u64) num_workers) * size_of(Worker));

    if cpi.workers == null {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->workers")
        );
    }

    cpi.tile_thr_data =
        cast(*Enc_Worker_Data) calloc_2(
            cast,no_check(u64) num_workers,
            size_of(Enc_Worker_Data)
        );

    if cpi.tile_thr_data == null {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->tile_thr_data")
        );
    }

    if 0 < num_workers {
        for i: 0..num_workers - 1 {
            WORKER := *(cast(*Worker) (cpi.workers))[i];
            thread_data: *Enc_Worker_Data = *(cast(*Enc_Worker_Data) (cpi.tile_thr_data))[i];

            cpi.num_workers += 1;
            WINTERFACE.init(WORKER);
            WORKER.thread_name = c_string("vpx enc worker");

            if i < num_workers - 1 {
                thread_data.cpi = cpi;

                thread_data.td =
                    cast(*Thread_Data_in_vp9_encoder) memalign(
                        32,
                        size_of(Thread_Data_in_vp9_encoder)
                    );

                if thread_data.td == null {
                    internal_error(
                        *CM.error,
                        cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                        c_string("Failed to allocate thread_data->td")
                    );
                }
                fill_memory(thread_data.td, 0, size_of(Thread_Data_in_vp9_encoder));

                thread_data.td.leaf_tree = null;
                thread_data.td.pc_tree = null;
                vp9_setup_pc_tree(CM, thread_data.td);

                thread_data.td.counts = cast(*FRAME_COUNTS) calloc_2(1, size_of(FRAME_COUNTS));

                if thread_data.td.counts == null {
                    internal_error(
                        *CM.error,
                        cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                        c_string("Failed to allocate thread_data->td->counts")
                    );
                }

                if WINTERFACE.reset(WORKER) == 0 {
                    internal_error(
                        *CM.error,
                        cast,no_check(Codec_Err_T) CODEC_ERROR,
                        c_string("Tile encoder thread creation failed")
                    );
                }
            } else {
                thread_data.cpi = cpi;
                thread_data.td = *cpi.td;
            }
            WINTERFACE.sync(WORKER);
        }
    }
}

get_max_tile_cols :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    ALIGNED_WIDTH := (cpi.oxcf.width + ((cast(s32) 1) << 3 - 1)) & ~((cast(s32) 1) << 3 - 1);
    mi_cols := ALIGNED_WIDTH >> 3;
    min_log2_tile_cols, max_log2_tile_cols: s32 = ---;

    vp9_get_tile_n_bits(mi_cols, *min_log2_tile_cols, *max_log2_tile_cols);
    log2_tile_cols := clamp_in_vp9_ethread(cpi.oxcf.tile_columns, min_log2_tile_cols, max_log2_tile_cols);
    if cpi.oxcf.target_level == cast,no_check(u32) LEVEL_AUTO {
        LEVEL_TILE_COLS :=
            log_tile_cols_from_picsize_level_in_vp9_ethread(
                cast,no_check(u32) cpi.common.width,
                cast,no_check(u32) cpi.common.height
            );
        if log2_tile_cols > LEVEL_TILE_COLS {
            log2_tile_cols = max(LEVEL_TILE_COLS, min_log2_tile_cols);
        }
    }
    return (cast(s32) 1) << ((log2_tile_cols) & 31);
}

log_tile_cols_from_picsize_level_in_vp9_ethread :: (width: u32, height: u32) -> s32 {
    PIC_SIZE := width * height;
    PIC_BREADTH := max(width, height);
    for i: 0..cast(s32) 14 - 1 {
        if VP9_LEVEL_DEFS[i].max_luma_picture_size >= PIC_SIZE && VP9_LEVEL_DEFS[i].max_luma_picture_breadth >= PIC_BREADTH {
            return get_msb_in_vp9_ethread(cast,no_check(u32) VP9_LEVEL_DEFS[i].max_col_tiles);
        }
    }
    return 2147483647;
}

vp9_encode_tiles_row_mt :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    TILE_ROWS := (cast(s32) 1) << ((CM.log2_tile_rows) & 31);
    multi_thread_ctxt := *cpi.multi_thread_ctxt;
    num_workers := (ifx cpi.oxcf.max_threads > 1 then cpi.oxcf.max_threads else 1);

    if multi_thread_ctxt.allocated_tile_cols < TILE_COLS ||
        multi_thread_ctxt.allocated_tile_rows < TILE_ROWS ||
        multi_thread_ctxt.allocated_vert_unit_rows < CM.mb_rows {
        vp9_row_mt_mem_dealloc(cpi);
        vp9_init_tile_data(cpi);
        vp9_row_mt_mem_alloc(cpi);
    } else {
        vp9_init_tile_data(cpi);
    }

    create_enc_workers(cpi, num_workers);

    vp9_assign_tile_to_thread(multi_thread_ctxt, TILE_COLS, cpi.num_workers);

    (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: JOB_TYPE)) (cast(*void) vp9_prepare_job_queue))(
        cpi,
        cast,no_check(JOB_TYPE) ENCODE_JOB
    );

    vp9_multi_thread_tile_init(cpi);

    if 0 < num_workers {
        for i: 0..num_workers - 1 {
            thread_data := *(cast(*Enc_Worker_Data) (cpi.tile_thr_data))[i];

            if thread_data.td != *cpi.td {
                assignment_2: MACROBLOCK = cpi.td.mb;
                ((*thread_data.td.mb).*) = assignment_2;
                assignment_3: RD_COUNTS = cpi.td.rd_counts;
                ((*thread_data.td.rd_counts).*) = assignment_3;
            }
            if thread_data.td.counts != *cpi.common.counts {
                copy_memory(thread_data.td.counts, *cpi.common.counts, size_of(FRAME_COUNTS));
            }

            if cpi.sf.use_nonrd_pick_mode != 0 {
                X := *thread_data.td.mb;
                XD := *X.e_mbd;
                P := X.plane.data;
                PD := XD.plane.data;
                ctx := *thread_data.td.pc_root.none;

                for j: 0..cast(s32) 3 - 1 {
                    P[j].coeff = ctx.coeff_pbuf[j][0];
                    P[j].qcoeff = ctx.qcoeff_pbuf[j][0];
                    PD[j].dqcoeff = ctx.dqcoeff_pbuf[j][0];
                    P[j].eobs = ctx.eobs_pbuf[j][0];
                }
            }
        }
    }

    launch_enc_workers(cpi, cast,no_check(Worker_Hook) enc_row_mt_worker_hook, multi_thread_ctxt, num_workers);

    if 0 < num_workers {
        for i: 0..num_workers - 1 {
            WORKER := *(cast(*Worker) (cpi.workers))[i];
            THREAD_DATA := cast(*Enc_Worker_Data) WORKER.data1;

            if i < cpi.num_workers - 1 {
                vp9_accumulate_frame_counts(*CM.counts, THREAD_DATA.td.counts, 0);
                accumulate_rd_opt(*cpi.td, THREAD_DATA.td);
            }
        }
    }
}

enc_row_mt_worker_hook :: (arg1: *void, arg2: *void) -> s32 {
    THREAD_DATA := cast(*Enc_Worker_Data) arg1;
    multi_thread_ctxt := cast(*Multi_Thread_Handle) arg2;
    CPI: *VP9_COMP_in_vp9_encoder = THREAD_DATA.cpi;
    CM := *CPI.common;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    tile_row, tile_col: s32 = ---;

    thread_id := THREAD_DATA.thread_id;
    cur_tile_id := multi_thread_ctxt.thread_id_to_tile_id[thread_id];
    proc_job: *Job_Node = null;
    mi_row: s32 = ---;

    end_of_frame: s32 = 0;
    while 0 == end_of_frame {
        proc_job = cast(*Job_Node) vp9_enc_grp_get_next_job(multi_thread_ctxt, cur_tile_id);
        if null == proc_job {
            end_of_frame =
                vp9_get_tiles_proc_status(
                    multi_thread_ctxt,
                    THREAD_DATA.tile_completion_status.data,
                    *cur_tile_id,
                    TILE_COLS
                );
        } else {
            tile_col = proc_job.tile_col_id;
            tile_row = proc_job.tile_row_id;
            mi_row = proc_job.vert_unit_row_num * (cast(s32) 1) << (((6 - 3)) & 31);

            vp9_encode_sb_row(CPI, THREAD_DATA.td, tile_row, tile_col, mi_row);
        }
    }
    return 1;
}

vp9_encode_fp_row_mt :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    TILE_ROWS := (cast(s32) 1) << ((CM.log2_tile_rows) & 31);
    multi_thread_ctxt := *cpi.multi_thread_ctxt;

    num_workers := (ifx cpi.oxcf.max_threads > 1 then cpi.oxcf.max_threads else 1);

    if multi_thread_ctxt.allocated_tile_cols < TILE_COLS ||
        multi_thread_ctxt.allocated_tile_rows < TILE_ROWS ||
        multi_thread_ctxt.allocated_vert_unit_rows < CM.mb_rows {
        vp9_row_mt_mem_dealloc(cpi);
        vp9_init_tile_data(cpi);
        vp9_row_mt_mem_alloc(cpi);
    } else {
        vp9_init_tile_data(cpi);
    }

    create_enc_workers(cpi, num_workers);

    vp9_assign_tile_to_thread(multi_thread_ctxt, TILE_COLS, cpi.num_workers);

    (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: JOB_TYPE)) (cast(*void) vp9_prepare_job_queue))(
        cpi,
        cast,no_check(JOB_TYPE) FIRST_PASS_JOB
    );

    vp9_multi_thread_tile_init(cpi);

    if 0 < num_workers {
        for i: 0..num_workers - 1 {
            thread_data := *(cast(*Enc_Worker_Data) (cpi.tile_thr_data))[i];

            if thread_data.td != *cpi.td {
                assignment_4: MACROBLOCK = cpi.td.mb;
                ((*thread_data.td.mb).*) = assignment_4;
            }
        }
    }

    launch_enc_workers(cpi, cast,no_check(Worker_Hook) first_pass_worker_hook, multi_thread_ctxt, num_workers);

    first_tile_col := *cpi.tile_data[0];
    if 1 < TILE_COLS {
        for i: 1..TILE_COLS - 1 {
            this_tile := *cpi.tile_data[i];
            accumulate_fp_tile_stat(first_tile_col, this_tile);
        }
    }
}

accumulate_fp_tile_stat :: (tile_data: *Tile_Data_Enc, tile_data_t: *Tile_Data_Enc) {
    tile_data.fp_data.intra_factor += tile_data_t.fp_data.intra_factor;
    tile_data.fp_data.brightness_factor += tile_data_t.fp_data.brightness_factor;
    tile_data.fp_data.coded_error += tile_data_t.fp_data.coded_error;
    tile_data.fp_data.sr_coded_error += tile_data_t.fp_data.sr_coded_error;
    tile_data.fp_data.frame_noise_energy += tile_data_t.fp_data.frame_noise_energy;
    tile_data.fp_data.intra_error += tile_data_t.fp_data.intra_error;
    tile_data.fp_data.intercount += tile_data_t.fp_data.intercount;
    tile_data.fp_data.second_ref_count += tile_data_t.fp_data.second_ref_count;
    tile_data.fp_data.neutral_count += tile_data_t.fp_data.neutral_count;
    tile_data.fp_data.intra_count_low += tile_data_t.fp_data.intra_count_low;
    tile_data.fp_data.intra_count_high += tile_data_t.fp_data.intra_count_high;
    tile_data.fp_data.intra_skip_count += tile_data_t.fp_data.intra_skip_count;
    tile_data.fp_data.mvcount += tile_data_t.fp_data.mvcount;
    tile_data.fp_data.new_mv_count += tile_data_t.fp_data.new_mv_count;
    tile_data.fp_data.sum_mvr += tile_data_t.fp_data.sum_mvr;
    tile_data.fp_data.sum_mvr_abs += tile_data_t.fp_data.sum_mvr_abs;
    tile_data.fp_data.sum_mvc += tile_data_t.fp_data.sum_mvc;
    tile_data.fp_data.sum_mvc_abs += tile_data_t.fp_data.sum_mvc_abs;
    tile_data.fp_data.sum_mvrs += tile_data_t.fp_data.sum_mvrs;
    tile_data.fp_data.sum_mvcs += tile_data_t.fp_data.sum_mvcs;
    tile_data.fp_data.sum_in_vectors += tile_data_t.fp_data.sum_in_vectors;
    tile_data.fp_data.intra_smooth_count += tile_data_t.fp_data.intra_smooth_count;
    MIN_START_ROW :=
        (ifx tile_data.fp_data.image_data_start_row < tile_data_t.fp_data.image_data_start_row then tile_data.fp_data.image_data_start_row else tile_data_t.fp_data.image_data_start_row);
    tile_data.fp_data.image_data_start_row =
        ifx MIN_START_ROW == -1 then (ifx tile_data.fp_data.image_data_start_row > tile_data_t.fp_data.image_data_start_row then tile_data.fp_data.image_data_start_row else tile_data_t.fp_data.image_data_start_row) else MIN_START_ROW;
}

first_pass_worker_hook :: (arg1: *void, arg2: *void) -> s32 {
    THREAD_DATA := cast(*Enc_Worker_Data) arg1;
    multi_thread_ctxt := cast(*Multi_Thread_Handle) arg2;
    CPI: *VP9_COMP_in_vp9_encoder = THREAD_DATA.cpi;
    CM := *CPI.common;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    tile_row, tile_col: s32 = ---;
    this_tile: *Tile_Data_Enc = ---;

    thread_id := THREAD_DATA.thread_id;
    cur_tile_id := multi_thread_ctxt.thread_id_to_tile_id[thread_id];
    proc_job: *Job_Node = null;
    fp_acc_data: FIRSTPASS_DATA = ---;
    zero_mv: MV;
    best_ref_mv: MV = ---;
    mb_row: s32 = ---;

    end_of_frame: s32 = 0;
    while 0 == end_of_frame {
        proc_job = cast(*Job_Node) vp9_enc_grp_get_next_job(multi_thread_ctxt, cur_tile_id);
        if null == proc_job {
            end_of_frame =
                vp9_get_tiles_proc_status(
                    multi_thread_ctxt,
                    THREAD_DATA.tile_completion_status.data,
                    *cur_tile_id,
                    TILE_COLS
                );
        } else {
            tile_col = proc_job.tile_col_id;
            tile_row = proc_job.tile_row_id;

            this_tile = *CPI.tile_data[tile_row * TILE_COLS + tile_col];
            mb_row = proc_job.vert_unit_row_num;

            best_ref_mv = zero_mv;
            fill_memory(*fp_acc_data, 0, size_of(FIRSTPASS_DATA));
            fp_acc_data.image_data_start_row = -1;
            (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *Thread_Data_in_vp9_encoder, _: *FIRSTPASS_DATA, _: *Tile_Data_Enc, _: *MV, _: s32)) (cast(*void) vp9_first_pass_encode_tile_mb_row))(
                CPI,
                THREAD_DATA.td,
                *fp_acc_data,
                this_tile,
                *best_ref_mv,
                mb_row
            );
        }
    }
    return 1;
}

vp9_row_mt_sync_read :: (ROW_MT_SYNC: *VP9_Row_MT_Sync, r: s32, c: s32) {
    NSYNC := ROW_MT_SYNC.sync_range;

    if r != 0 && c & (NSYNC - 1) == 0 {
        MUTEX := *(cast(*Pthread_Mutex_T) (ROW_MT_SYNC.mutex))[r - 1];
        pthread_mutex_lock(MUTEX);

        while c > ROW_MT_SYNC.cur_col[r - 1] - NSYNC + 1 {
            pthread_cond_wait(*(cast(*Pthread_Cond_T) (ROW_MT_SYNC.cond))[r - 1], MUTEX);
        }
        pthread_mutex_unlock(MUTEX);
    }
}

vp9_row_mt_sync_write :: (ROW_MT_SYNC: *VP9_Row_MT_Sync, r: s32, c: s32, COLS: s32) {
    NSYNC := ROW_MT_SYNC.sync_range;
    cur: s32 = ---;

    sig: s32 = 1;

    if c < COLS - 1 {
        cur = c;
        if c % NSYNC != NSYNC - 1 {
            sig = 0;
        }
    } else {
        cur = COLS + NSYNC;
    }

    if sig != 0 {
        pthread_mutex_lock(*(cast(*Pthread_Mutex_T) (ROW_MT_SYNC.mutex))[r]);

        ROW_MT_SYNC.cur_col[r] = cur;

        pthread_cond_signal(*(cast(*Pthread_Cond_T) (ROW_MT_SYNC.cond))[r]);
        pthread_mutex_unlock(*(cast(*Pthread_Mutex_T) (ROW_MT_SYNC.mutex))[r]);
    }
}

vp9_row_mt_sync_read_dummy :: (ROW_MT_SYNC: *VP9_Row_MT_Sync, r: s32, c: s32) {
}

vp9_row_mt_sync_write_dummy :: (ROW_MT_SYNC: *VP9_Row_MT_Sync, r: s32, c: s32, COLS: s32) {
}

vp9_row_mt_sync_mem_alloc :: (row_mt_sync: *VP9_Row_MT_Sync, cm: *VP9_COMMON, rows: s32) {
    row_mt_sync.rows = rows;

    {
        row_mt_sync.mutex =
            cast(*Pthread_Mutex_T) allocate_memory(
                size_of(Pthread_Mutex_T) * cast,no_check(u64) rows
            );

        if row_mt_sync.mutex == null {
            internal_error(
                *cm.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate row_mt_sync->mutex")
            );
        }
        if row_mt_sync.mutex != null {
            if 0 < rows {
                for i: 0..rows - 1 {
                    pthread_mutex_init(*(cast(*Pthread_Mutex_T) (row_mt_sync.mutex))[i], null);
                }
            }
        }

        row_mt_sync.cond =
            cast(*Pthread_Cond_T) allocate_memory(
                size_of(Pthread_Cond_T) * cast,no_check(u64) rows
            );

        if row_mt_sync.cond == null {
            internal_error(
                *cm.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate row_mt_sync->cond")
            );
        }
        if row_mt_sync.cond != null {
            if 0 < rows {
                for i: 0..rows - 1 {
                    pthread_cond_init(*(cast(*Pthread_Cond_T) (row_mt_sync.cond))[i], null);
                }
            }
        }
    }

    row_mt_sync.cur_col = cast(*s32) allocate_memory(size_of(s32) * cast,no_check(u64) rows);

    if row_mt_sync.cur_col == null {
        internal_error(
            *cm.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate row_mt_sync->cur_col")
        );
    }

    row_mt_sync.sync_range = 1;
}

vp9_row_mt_sync_mem_dealloc :: (row_mt_sync: *VP9_Row_MT_Sync) {
    if row_mt_sync != null {
        i: s32 = ---;

        if row_mt_sync.mutex != null {
            i = 0;
            while i < row_mt_sync.rows {
                pthread_mutex_destroy(*(cast(*Pthread_Mutex_T) (row_mt_sync.mutex))[i]);
                i += 1;
            }
            deallocate_memory(cast(*void) row_mt_sync.mutex);
        }
        if row_mt_sync.cond != null {
            i = 0;
            while i < row_mt_sync.rows {
                pthread_cond_destroy(*(cast(*Pthread_Cond_T) (row_mt_sync.cond))[i]);
                i += 1;
            }
            deallocate_memory(cast(*void) row_mt_sync.cond);
        }

        deallocate_memory(cast(*void) row_mt_sync.cur_col);

        fill_memory(row_mt_sync, 0, size_of(VP9_Row_MT_Sync));
    }
}

vp9_temporal_filter_row_mt :: (cpi: *VP9_COMP_in_vp9_encoder) {
    CM := *cpi.common;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    TILE_ROWS := (cast(s32) 1) << ((CM.log2_tile_rows) & 31);
    multi_thread_ctxt := *cpi.multi_thread_ctxt;
    num_workers := (ifx cpi.num_workers != 0 then cpi.num_workers else 1);

    if multi_thread_ctxt.allocated_tile_cols < TILE_COLS ||
        multi_thread_ctxt.allocated_tile_rows < TILE_ROWS ||
        multi_thread_ctxt.allocated_vert_unit_rows < CM.mb_rows {
        vp9_row_mt_mem_dealloc(cpi);
        vp9_init_tile_data(cpi);
        vp9_row_mt_mem_alloc(cpi);
    } else {
        vp9_init_tile_data(cpi);
    }

    create_enc_workers(cpi, num_workers);

    vp9_assign_tile_to_thread(multi_thread_ctxt, TILE_COLS, cpi.num_workers);

    (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: JOB_TYPE)) (cast(*void) vp9_prepare_job_queue))(
        cpi,
        cast,no_check(JOB_TYPE) ARNR_JOB
    );

    if 0 < num_workers {
        for i: 0..num_workers - 1 {
            thread_data := *(cast(*Enc_Worker_Data) (cpi.tile_thr_data))[i];

            if thread_data.td != *cpi.td {
                assignment_5: MACROBLOCK = cpi.td.mb;
                ((*thread_data.td.mb).*) = assignment_5;
            }
        }
    }

    launch_enc_workers(cpi, cast,no_check(Worker_Hook) temporal_filter_worker_hook, multi_thread_ctxt, num_workers);
}

temporal_filter_worker_hook :: (arg1: *void, arg2: *void) -> s32 {
    THREAD_DATA := cast(*Enc_Worker_Data) arg1;
    multi_thread_ctxt := cast(*Multi_Thread_Handle) arg2;
    CPI: *VP9_COMP_in_vp9_encoder = THREAD_DATA.cpi;
    CM := *CPI.common;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    tile_row, tile_col: s32 = ---;
    mb_col_start, mb_col_end: s32 = ---;
    this_tile: *Tile_Data_Enc = ---;

    thread_id := THREAD_DATA.thread_id;
    cur_tile_id := multi_thread_ctxt.thread_id_to_tile_id[thread_id];
    proc_job: *Job_Node = null;
    mb_row: s32 = ---;

    end_of_frame: s32 = 0;
    while 0 == end_of_frame {
        proc_job = cast(*Job_Node) vp9_enc_grp_get_next_job(multi_thread_ctxt, cur_tile_id);
        if null == proc_job {
            end_of_frame =
                vp9_get_tiles_proc_status(
                    multi_thread_ctxt,
                    THREAD_DATA.tile_completion_status.data,
                    *cur_tile_id,
                    TILE_COLS
                );
        } else {
            tile_col = proc_job.tile_col_id;
            tile_row = proc_job.tile_row_id;
            this_tile = *CPI.tile_data[tile_row * TILE_COLS + tile_col];
            mb_col_start = this_tile.tile_info.mi_col_start >> 2;
            mb_col_end = (this_tile.tile_info.mi_col_end + 3) >> 2;
            mb_row = proc_job.vert_unit_row_num;

            vp9_temporal_filter_iterate_row_c(CPI, THREAD_DATA.td, mb_row, mb_col_start, mb_col_end);
        }
    }
    return 1;
}

fps_init_first_pass_info_in_vp9_ethread :: (
    first_pass_info: *FIRST_PASS_INFO,
    stats: *FIRSTPASS_STATS_in_vp9_cx_iface,
    num_frames: s32
) {
    first_pass_info.stats = stats;
    first_pass_info.num_frames = num_frames;
}

fps_get_num_frames_in_vp9_ethread :: (first_pass_info: *FIRST_PASS_INFO) -> s32 {
    return first_pass_info.num_frames;
}

fps_get_frame_stats_in_vp9_ethread :: (
    first_pass_info: *FIRST_PASS_INFO,
    show_idx: s32
) -> *FIRSTPASS_STATS_in_vp9_cx_iface {
    if show_idx < 0 || show_idx >= first_pass_info.num_frames {
        return null;
    }
    return *(cast(*FIRSTPASS_STATS_in_vp9_cx_iface) (first_pass_info.stats))[show_idx];
}

get_buf_from_mv_in_vp9_ethread :: (buf: *Buf_2d, mv: *MV) -> *u8 {
    return *buf.buf[(cast(s32) mv.row) * buf.stride + cast(s32) mv.col];
}

cost_branch256_in_vp9_ethread :: (ct: *u32, p: Prob) -> u64 {
    return ((cast,no_check(u64) ct[0]) * cast(u64) VP9_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP9_PROB_COST[256 - cast(s32) p];
}

treed_cost_in_vp9_ethread :: (tree: *Tree_Index, probs: *Prob, bits: s32, len: s32) -> s32 {
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

rd_less_than_thresh_in_vp9_ethread :: (best_rd: s64, thresh: s32, THRESH_FACT: *s32) -> s32 {
    if best_rd < ((cast,no_check(s64) thresh) * cast(s64) THRESH_FACT.*) >> 5 || thresh == 2147483647 {
        return 1;
    }
    return 0;
}

set_error_per_bit_in_vp9_ethread :: (x: *MACROBLOCK, rdmult: s32) {
    x.errorperbit = rdmult >> 6;
    x.errorperbit += cast(s32) (x.errorperbit == 0);
}

write_in_vp9_ethread :: (br: *Writer, bit: s32, probability: s32) {
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

write_bit_in_vp9_ethread :: (w: *Writer, bit: s32) {
    write_in_vp9_ethread(w, bit, 128);
}

write_literal_in_vp9_ethread :: (w: *Writer, data: s32, bits: s32) {
    bit := bits - 1;
    while bit >= 0 {
        write_bit_in_vp9_ethread(w, 1 & (data >> ((bit) & 31)));
        bit -= 1;
    }
}

vp9_write_tree_in_vp9_ethread :: (w: *Writer, tree: *Tree_Index, probs: *Prob, bits: s32, len: s32, i: Tree_Index) {
    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            write_in_vp9_ethread(w, BIT, cast,no_check(s32) probs[(cast(s32) i) >> 1]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }
}

vp9_write_token_in_vp9_ethread :: (w: *Writer, tree: *Tree_Index, probs: *Prob, token: *Vp9_Token) {
    vp9_write_tree_in_vp9_ethread(w, tree, probs, token.value, token.len, 0);
}

vp9_get_high_cost_table_in_vp9_ethread :: (bit_depth: s32) -> *u16 {
    return VP9_CAT6_HIGH_COST.data;
}

vp9_get_token_extra_in_vp9_ethread :: (v: s32, token: *s16, extra: *EXTRABIT) {
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

vp9_get_token_in_vp9_ethread :: (v: s32) -> s16 {
    if v >= 67 || v <= -67 {
        return 10;
    }
    return vp9_dct_cat_lt_10_value_tokens[v].token;
}

vp9_get_token_cost_in_vp9_ethread :: (v: s32, token: *s16, cat6_high_table: *u16) -> s32 {
    if v >= 67 || v <= -67 {
        token.* = 10;
        extrabits := cast,no_check(EXTRABIT) (absolute_value(v) - 67);
        return (cast(s32) VP9_CAT6_LOW_COST[extrabits & 0xff]) + cast(s32) cat6_high_table[(cast(s32) extrabits) >> 8];
    }
    token.* = vp9_dct_cat_lt_10_value_tokens[v].token;
    return vp9_dct_cat_lt_10_value_cost[v];
}

is_lossless_requested_in_vp9_ethread :: (cfg: *VP9_Encoder_Config) -> s32 {
    if cfg.best_allowed_q == 0 && cfg.worst_allowed_q == 0 {
        return 1;
    }
    return 0;
}

stack_pop_in_vp9_ethread :: (stack: *s32, stack_size: s32) -> s32 {
    R := stack[0];
    if 1 < stack_size {
        for idx: 1..stack_size - 1 {
            stack[idx - 1] = stack[idx];
        }
    }

    return R;
}

stack_top_in_vp9_ethread :: (stack: *s32) -> s32 {
    return stack[0];
}

stack_push_in_vp9_ethread :: (stack: *s32, new_item: s32, stack_size: s32) {
    idx := stack_size;
    while idx > 0 {
        stack[idx] = stack[idx - 1];
        idx -= 1;
    }
    stack[0] = new_item;
}

stack_init_in_vp9_ethread :: (stack: *s32, length: s32) {
    if 0 < length {
        for idx: 0..length - 1 {
            stack[idx] = -1;
        }
    }
}

frame_is_kf_gf_arf_in_vp9_ethread :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if frame_is_intra_only_in_vp9_ethread(*cpi.common) != 0 ||
        cpi.refresh_alt_ref_frame != 0 ||
        cpi.refresh_golden_frame != 0 && cpi.rc.is_src_frame_alt_ref == 0 {
        return 1;
    }
    return 0;
}

ref_frame_to_flag_in_vp9_ethread :: (ref_frame: s8) -> s32 {

    return K_VP9_REF_FLAG_LIST_in_vp9_ethread[ref_frame];
}

get_ref_frame_map_idx_in_vp9_ethread :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame: MV_REFERENCE_FRAME) -> s32 {
    if ref_frame == 1 {
        return cpi.lst_fb_idx;
    } else if ref_frame == 2 {
        return cpi.gld_fb_idx;
    } else {
        return cpi.alt_fb_idx;
    }
}

get_ref_frame_buf_idx_in_vp9_ethread :: (CPI: *VP9_COMP_in_vp9_encoder, ref_frame: s32) -> s32 {
    CM := *CPI.common;
    MAP_IDX := get_ref_frame_map_idx_in_vp9_ethread(CPI, cast,no_check(MV_REFERENCE_FRAME) ref_frame);
    return ifx MAP_IDX != -1 then CM.ref_frame_map[MAP_IDX] else -1;
}

get_ref_cnt_buffer_in_vp9_ethread :: (cm: *VP9_COMMON, fb_idx: s32) -> *Ref_Cnt_Buffer {
    return ifx fb_idx != -1 then cm.buffer_pool.frame_bufs.data + fb_idx else null;
}

get_ref_frame_bufs_in_vp9_ethread :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame_bufs: **Ref_Cnt_Buffer) {
    CM := *cpi.common;

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame < 4 {
        ref_frame_buf_idx := get_ref_frame_buf_idx_in_vp9_ethread(cpi, cast,no_check(s32) ref_frame);
        inter_ref_idx := mv_ref_frame_to_inter_ref_idx_in_vp9_ethread(ref_frame);
        ref_frame_bufs[inter_ref_idx] = get_ref_cnt_buffer_in_vp9_ethread(CM, ref_frame_buf_idx);
        ref_frame += 1;
    }
}

get_ref_frame_buffer_in_vp9_ethread :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    ref_frame: MV_REFERENCE_FRAME
) -> *YV12_BUFFER_CONFIG {
    CM := *CPI.common;
    BUF_IDX := get_ref_frame_buf_idx_in_vp9_ethread(CPI, cast,no_check(s32) ref_frame);
    return ifx BUF_IDX != -1 then *CM.buffer_pool.frame_bufs[BUF_IDX].buf else null;
}

get_token_alloc_in_vp9_ethread :: (mb_rows: s32, mb_cols: s32) -> s64 {
    ALIGNED_MB_ROWS :=
        (mb_rows +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    ALIGNED_MB_COLS :=
        (mb_cols +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    return ((cast,no_check(s64) ALIGNED_MB_ROWS) * cast(s64) ALIGNED_MB_COLS) * cast,no_check(s64) ((cast,no_check(s32) ((16 * 16))) * 3 + 4);
}

allocated_tokens_in_vp9_ethread :: (tile: Tile_Info) -> s64 {
    tile_mb_rows := (tile.mi_row_end - tile.mi_row_start + 1) >> 1;
    tile_mb_cols := (tile.mi_col_end - tile.mi_col_start + 1) >> 1;

    return get_token_alloc_in_vp9_ethread(tile_mb_rows, tile_mb_cols);
}

get_start_tok_in_vp9_ethread :: (
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

    tok.* = cpi.tile_tok[tile_row][tile_col] + get_token_alloc_in_vp9_ethread(MB_ROW, tile_mb_cols);
}

is_one_pass_svc_in_vp9_ethread :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if CPI.use_svc != 0 && CPI.oxcf.pass == 0 {
        return 1;
    }
    return 0;
}

is_altref_enabled_in_vp9_ethread :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if !(CPI.oxcf.mode == cast,no_check(u32) REALTIME && CPI.oxcf.rc_mode == cast,no_check(u32) CBR) &&
        CPI.oxcf.lag_in_frames >= 4 &&
        CPI.oxcf.enable_auto_arf != 0 {
        return 1;
    }
    return 0;
}

set_ref_ptrs_in_vp9_ethread :: (CM: *VP9_COMMON, xd: *MACROBLOCKD, ref0: MV_REFERENCE_FRAME, ref1: MV_REFERENCE_FRAME) {
    xd.block_refs[0] = CM.frame_refs.data + (ifx ref0 >= 1 then (cast(s32) ref0) - 1 else 0);
    xd.block_refs[1] = CM.frame_refs.data + (ifx ref1 >= 1 then (cast(s32) ref1) - 1 else 0);
}

get_chessboard_index_in_vp9_ethread :: (FRAME_INDEX: s32) -> s32 {
    return FRAME_INDEX & 0x1;
}

cond_cost_list_in_vp9_ethread :: (cpi: *VP9_COMP_in_vp9_encoder, cost_list: *s32) -> *s32 {
    return ifx cpi.sf.mv.subpel_search_method != cast,no_check(u32) SUBPEL_TREE then cost_list else null;
}

get_num_vert_units_in_vp9_ethread :: (tile: Tile_Info, shift: s32) -> s32 {
    num_vert_units := (tile.mi_row_end - tile.mi_row_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_vert_units;
}

get_num_cols_in_vp9_ethread :: (tile: Tile_Info, shift: s32) -> s32 {
    num_cols := (tile.mi_col_end - tile.mi_col_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_cols;
}

get_level_index_in_vp9_ethread :: (level: VP9_LEVEL) -> s32 {
    for i: 0..cast(s32) 14 - 1 {
        if level == VP9_LEVEL_DEFS[i].level {
            return i;
        }
    }
    return -1;
}

alloc_frame_mvs_in_vp9_ethread :: (CM: *VP9_COMMON, buffer_idx: s32) {
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

mv_cost_in_vp9_ethread :: (mv: *MV, joint_cost: *s32, comp_cost: **s32) -> s32 {
    return joint_cost[vp9_get_mv_joint_in_vp9_ethread(mv)] + comp_cost[0][mv.row] + comp_cost[1][mv.col];
}

mvsad_err_cost_in_vp9_ethread :: (x: *MACROBLOCK, mv: *MV, ref: *MV, sad_per_bit: s32) -> s32 {
    diff: MV = ---;
    diff.row = cast,no_check(s16) ((cast(s32) mv.row) - cast(s32) ref.row);
    diff.col = cast,no_check(s16) ((cast(s32) mv.col) - cast(s32) ref.col);
    return cast,no_check(s32) ((((cast,no_check(u32) mv_cost_in_vp9_ethread(*diff, x.nmvjointsadcost.data, x.nmvsadcost.data)) * cast,no_check(u32) sad_per_bit) + cast,no_check(u32) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9);
}

get_start_mv_sad_in_vp9_ethread :: (
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
    start_mv_sad += cast,no_check(u32) mvsad_err_cost_in_vp9_ethread(x, mvp_full, ref_mv_full, sadpb);

    return start_mv_sad;
}

num_4x4_to_edge_in_vp9_ethread :: (plane_4x4_dim: s32, mb_to_edge_dim: s32, subsampling_dim: s32, blk_dim: s32) -> s32 {
    return plane_4x4_dim + mb_to_edge_dim >> (((5 + subsampling_dim)) & 31) - blk_dim;
}

sum_squares_visible_in_vp9_ethread :: (
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
        num_4x4_to_edge_in_vp9_ethread(
            PLANE_4X4_W,
            xd.mb_to_right_edge,
            PD.subsampling_x,
            blk_col
        );
    B4X4S_TO_BOTTOM_EDGE :=
        num_4x4_to_edge_in_vp9_ethread(
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

do_trellis_opt_in_vp9_ethread :: (
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
                    sum_squares_visible_in_vp9_ethread(
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

vp9_preserve_existing_gf_in_vp9_ethread :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if cpi.refresh_golden_frame != 0 && cpi.rc.is_src_frame_alt_ref != 0 && cpi.use_svc == 0 {
        return 1;
    }
    return 0;
}

globals_initialization_state_for_vp9_ethread: u32;
initialize_globals_for_vp9_ethread :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_ethread);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_ethread, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_ethread) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_vp9_ethread =
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
    SUB_PEL_FILTERS_12_in_vp9_ethread =
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
    FRAME_SCALE_FACTOR_in_vp9_ethread = s32.[ 16, 24 ];
    RATE_THRESH_MULT_in_vp9_ethread = float64.[ 1.0, 2.0 ];
    RCF_MULT_in_vp9_ethread = float64.[ 1.0, 2.0 ];
    K_VP9_REF_FLAG_LIST_in_vp9_ethread =
        s32.[ 0, cast,no_check(s32) (VP9_LAST_FLAG), cast,no_check(s32) (VP9_GOLD_FLAG), cast,no_check(s32) (VP9_ALT_FLAG) ];
    atomic_store(*globals_initialization_state_for_vp9_ethread, 2);
}

JOB_TYPE :: u32;
FIRST_PASS_JOB : s32 : 0;
ENCODE_JOB : s32 : 1;
ARNR_JOB : s32 : 2;
NUM_JOB_TYPES : s32 : 3;

