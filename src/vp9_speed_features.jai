COUNT_TO_UPDATE_FACTOR_in_vp9_speed_features: [21] s32;

SUB_PEL_FILTERS_12_in_vp9_speed_features: [16] Interp_Kernel12 #align 256;

FRAME_SCALE_FACTOR_in_vp9_speed_features: [2] s32;

RATE_THRESH_MULT_in_vp9_speed_features: [2] float64;

RCF_MULT_in_vp9_speed_features: [2] float64;

good_quality_mesh_patterns: [3] [4] MESH_PATTERN;

qopt_thresholds: [6] float64;

tx_dom_thresholds: [6] float64;

K_VP9_REF_FLAG_LIST_in_vp9_speed_features: [4] s32;

best_quality_mesh_pattern: [2] [4] MESH_PATTERN;

clip_pixel_in_vp9_speed_features :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_speed_features :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_speed_features :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_speed_features :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_speed_features :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_speed_features(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_speed_features(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_speed_features(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_speed_features :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_vp9_speed_features :: (FILTER: *s16) -> s32 {
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

vp8_set_reference_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_vp9_speed_features :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

gcd_in_vp9_speed_features :: (a: s64, b: s32) -> s32 {
    while b != 0 {
        r := cast,no_check(s32) (a % cast(s64) b);
        a = cast,no_check(s64) b;
        b = r;
    }

    return cast,no_check(s32) a;
}

reduce_ratio_in_vp9_speed_features :: (ratio: *Rational64_T) {
    DENOM := gcd_in_vp9_speed_features(ratio.num, ratio.den);
    ratio.num /= cast,no_check(s64) DENOM;
    ratio.den /= DENOM;
}

get_prob_in_vp9_speed_features :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_speed_features :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_speed_features(n0, DEN);
}

weighted_prob_in_vp9_speed_features :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_speed_features :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_speed_features(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_speed_features(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_speed_features :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_speed_features[COUNT];
        PROB := get_prob_in_vp9_speed_features(ct[0], DEN);
        return weighted_prob_in_vp9_speed_features(
            cast,no_check(s32) pre_prob,
            cast,no_check(s32) PROB,
            cast,no_check(s32) FACTOR
        );
    }
}

get_lsb_in_vp9_speed_features :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_speed_features :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_speed_features :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_speed_features(num_values) + 1 else 0;
}

get_band_translate_in_vp9_speed_features :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_speed_features :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_speed_features :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_speed_features(above_ec, left_ec);
}

is_zero_mv_in_vp9_speed_features :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_speed_features :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_speed_features :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_speed_features(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_speed_features(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_speed_features :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_speed_features :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_speed_features :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_speed_features :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

vp9_is_valid_scale_in_vp9_speed_features :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_speed_features :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_speed_features(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_speed_features :: (
    ref_width: s32,
    ref_height: s32,
    this_width: s32,
    this_height: s32
) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_speed_features :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_speed_features :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_speed_features :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_speed_features :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_speed_features :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_speed_features :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_speed_features :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_speed_features :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_speed_features :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_speed_features :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_speed_features(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_speed_features :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_speed_features(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_speed_features(MI, ib)];
}

get_uv_tx_size_in_vp9_speed_features :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_speed_features :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_speed_features :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_speed_features(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_speed_features :: (
    mi: *MODE_INFO,
    above_mi: *MODE_INFO,
    left_mi: *MODE_INFO,
    block: s32
) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_speed_features :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_speed_features :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_speed_features :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_speed_features :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_speed_features :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_speed_features :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_speed_features :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_speed_features :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_speed_features :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_speed_features :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_speed_features :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_speed_features :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_speed_features(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_speed_features :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_speed_features(cm.mi_cols);

        if get_plane_type_in_vp9_speed_features(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_speed_features(cm, xd);
}

get_partition_probs_in_vp9_speed_features :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_speed_features :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_speed_features :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_speed_features :: (
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

update_partition_context_in_vp9_speed_features :: (
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

partition_plane_context_in_vp9_speed_features :: (
    xd: *MACROBLOCKD,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE
) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

cyclic_refresh_segment_id_boosted_in_vp9_speed_features :: (segment_id: s32) -> s32 {
    if segment_id == 1 || segment_id == 2 {
        return 1;
    }
    return 0;
}

cyclic_refresh_segment_id_in_vp9_speed_features :: (segment_id: s32) -> s32 {
    if segment_id == 1 {
        return 1;
    } else if segment_id == 2 {
        return 2;
    } else {
        return 0;
    }
}

fps_init_first_pass_info_in_vp9_speed_features :: (
    first_pass_info: *FIRST_PASS_INFO,
    stats: *FIRSTPASS_STATS_in_vp9_cx_iface,
    num_frames: s32
) {
    first_pass_info.stats = stats;
    first_pass_info.num_frames = num_frames;
}

fps_get_num_frames_in_vp9_speed_features :: (first_pass_info: *FIRST_PASS_INFO) -> s32 {
    return first_pass_info.num_frames;
}

fps_get_frame_stats_in_vp9_speed_features :: (
    first_pass_info: *FIRST_PASS_INFO,
    show_idx: s32
) -> *FIRSTPASS_STATS_in_vp9_cx_iface {
    if show_idx < 0 || show_idx >= first_pass_info.num_frames {
        return null;
    }
    return *(cast(*FIRSTPASS_STATS_in_vp9_cx_iface) (first_pass_info.stats))[show_idx];
}

get_buf_from_mv_in_vp9_speed_features :: (buf: *Buf_2d, mv: *MV) -> *u8 {
    return *buf.buf[(cast(s32) mv.row) * buf.stride + cast(s32) mv.col];
}

cost_branch256_in_vp9_speed_features :: (ct: *u32, p: Prob) -> u64 {
    return ((cast,no_check(u64) ct[0]) * cast(u64) VP9_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP9_PROB_COST[256 - cast(s32) p];
}

treed_cost_in_vp9_speed_features :: (tree: *Tree_Index, probs: *Prob, bits: s32, len: s32) -> s32 {
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

rd_less_than_thresh_in_vp9_speed_features :: (best_rd: s64, thresh: s32, THRESH_FACT: *s32) -> s32 {
    if best_rd < ((cast,no_check(s64) thresh) * cast(s64) THRESH_FACT.*) >> 5 || thresh == 2147483647 {
        return 1;
    }
    return 0;
}

set_error_per_bit_in_vp9_speed_features :: (x: *MACROBLOCK, rdmult: s32) {
    x.errorperbit = rdmult >> 6;
    x.errorperbit += cast(s32) (x.errorperbit == 0);
}

vp9_set_speed_features_framesize_independent :: (cpi: *VP9_COMP_in_vp9_encoder, speed: s32) {
    SF := *cpi.sf;

    CM := *cpi.common;

    X := *cpi.td.mb;
    OXCF := *cpi.oxcf;

    SF.frame_parameter_update = 1;
    SF.mv.search_method = cast,no_check(SEARCH_METHODS_in_vp9_cx_iface) NSTEP_in_vp9_cx_iface;
    SF.recode_loop = cast,no_check(RECODE_LOOP_TYPE) ALLOW_RECODE_FIRST;
    SF.mv.subpel_search_method = cast,no_check(SUBPEL_SEARCH_METHODS) SUBPEL_TREE;
    SF.mv.subpel_search_level = 2;
    SF.mv.subpel_force_stop = cast,no_check(SUBPEL_FORCE_STOP) EIGHTH_PEL;
    SF.optimize_coefficients = cast(s32) (is_lossless_requested_in_vp9_speed_features(*cpi.oxcf) == 0);
    SF.mv.reduce_first_step_size = 0;
    SF.coeff_prob_appx_step = 1;
    SF.mv.auto_mv_step_size = 0;
    SF.mv.fullpel_search_step_param = 6;
    SF.mv.use_downsampled_sad = 0;
    SF.comp_inter_joint_search_iter_level = 0;
    SF.tx_size_search_method = cast,no_check(TX_SIZE_SEARCH_METHOD) USE_FULL_RD;
    SF.use_lp32x32fdct = 0;
    SF.adaptive_motion_search = 0;
    SF.enhanced_full_pixel_motion_search = 1;
    SF.adaptive_pred_interp_filter = 0;
    SF.adaptive_mode_search = 0;
    SF.prune_single_mode_based_on_mv_diff_mode_rate = 0;
    SF.cb_pred_filter_search = 0;
    SF.early_term_interp_search_plane_rd = 0;
    SF.cb_partition_search = 0;
    SF.motion_field_mode_search = 0;
    SF.alt_ref_search_fp = 0;
    SF.use_quant_fp = 0;
    SF.reference_masking = 0;
    SF.partition_search_type = cast,no_check(PARTITION_SEARCH_TYPE) SEARCH_PARTITION;
    SF.less_rectangular_check = 0;
    SF.use_square_partition_only = 0;
    SF.use_square_only_thresh_high = 13;
    SF.use_square_only_thresh_low = 0;
    SF.auto_min_max_partition_size = cast,no_check(AUTO_MIN_MAX_MODE) NOT_IN_USE;
    SF.rd_auto_partition_min_limit = 0;
    SF.default_max_partition_size = 12;
    SF.default_min_partition_size = 0;
    SF.adjust_partitioning_from_last_frame = 0;
    SF.last_partitioning_redo_frequency = 4;
    SF.disable_split_mask = 0;
    SF.mode_search_skip_flags = 0;
    SF.force_frame_boost = 0;
    SF.max_delta_qindex = 0;
    SF.disable_filter_search_var_thresh = 0;
    SF.adaptive_interp_filter_search = 0;
    SF.allow_txfm_domain_distortion = 0;
    SF.tx_domain_thresh = 99.0;
    SF.trellis_opt_tx_rd.method =
        cast,no_check(ENABLE_TRELLIS_OPT_METHOD) ((ifx SF.optimize_coefficients != 0 then cast,no_check(s32) (ENABLE_TRELLIS_OPT) else cast,no_check(s32) (DISABLE_TRELLIS_OPT)));
    SF.trellis_opt_tx_rd.thresh = 99.0;
    SF.allow_acl = 1;
    SF.enable_tpl_model = OXCF.enable_tpl_model;
    SF.prune_ref_frame_for_rect_partitions = 0;
    SF.temporal_filter_search_method = cast,no_check(SEARCH_METHODS_in_vp9_cx_iface) MESH;
    SF.allow_skip_txfm_ac_dc = 0;

    i: s32 = 0;
    while i < cast,no_check(s32) (cast(TX_SIZE) 4) {
        SF.intra_y_mode_mask[i] = cast,no_check(s32) (INTRA_ALL);
        SF.intra_uv_mode_mask[i] = cast,no_check(s32) (INTRA_ALL);
        i += 1;
    }
    SF.use_rd_breakout = 0;
    SF.skip_encode_sb = 0;
    SF.use_uv_intra_rd_estimate = 0;
    SF.allow_skip_recode = 0;
    SF.lpf_pick = cast,no_check(LPF_PICK_METHOD) LPF_PICK_FROM_FULL_IMAGE;
    SF.use_fast_coef_updates = cast,no_check(FAST_COEFF_UPDATE) TWO_LOOP;
    SF.use_fast_coef_costing = 0;
    SF.mode_skip_start = 30;
    SF.schedule_mode_search = 0;
    SF.use_nonrd_pick_mode = 0;
    i = 0;
    while i < 13 {
        SF.inter_mode_mask[i] = cast,no_check(s32) (INTER_ALL);
        i += 1;
    }
    SF.max_intra_bsize = 12;
    SF.reuse_inter_pred_sby = 0;

    SF.always_this_block_size = 6;
    SF.encode_breakout_thresh = 0;

    SF.recode_tolerance_low = 12;
    SF.recode_tolerance_high = 25;
    SF.default_interp_filter = 4;
    SF.simple_model_rd_from_var = 0;
    SF.short_circuit_flat_blocks = 0;
    SF.short_circuit_low_temp_var = 0;
    SF.limit_newmv_early_exit = 0;
    SF.bias_golden = 0;
    SF.base_mv_aggressive = 0;
    SF.rd_ml_partition.prune_rect_thresh[0] = -1;
    SF.rd_ml_partition.prune_rect_thresh[1] = -1;
    SF.rd_ml_partition.prune_rect_thresh[2] = -1;
    SF.rd_ml_partition.prune_rect_thresh[3] = -1;
    SF.rd_ml_partition.var_pruning = 0;
    SF.use_accurate_subpel_search = cast,no_check(SUBPEL_SEARCH_TYPE) USE_8_TAPS;

    SF.adaptive_rd_thresh = 1;
    SF.tx_size_search_breakout = 1;
    SF.tx_size_search_depth = 2;

    SF.exhaustive_searches_thresh =
        ifx cpi.twopass.fr_content_type == cast,no_check(u32) FC_GRAPHICS_ANIMATION then (cast(s32) 1) << 20 else 2147483647;
    {
        MESH_DENSITY_LEVEL :=
            (ifx cpi.twopass.fr_content_type == cast,no_check(u32) FC_GRAPHICS_ANIMATION then cast(s32) 0 else 1);
        i = 0;
        while i < 4 {
            SF.mesh_patterns[i].range = best_quality_mesh_pattern[MESH_DENSITY_LEVEL][i].range;
            SF.mesh_patterns[i].interval = best_quality_mesh_pattern[MESH_DENSITY_LEVEL][i].interval;
            i += 1;
        }
    }

    if OXCF.mode == cast,no_check(u32) REALTIME {
        set_rt_speed_feature_framesize_independent(cpi, SF, speed, OXCF.content);
    } else if OXCF.mode == cast,no_check(u32) GOOD {
        set_good_speed_feature_framesize_independent(cpi, CM, SF, speed);
    }

    cpi.diamond_search_sad = vp9_diamond_search_sad_c;

    if OXCF.pass == 1 {
        SF.optimize_coefficients = 0;
    }

    if OXCF.pass == 0 {
        SF.recode_loop = cast,no_check(RECODE_LOOP_TYPE) DISALLOW_RECODE;
        SF.optimize_coefficients = 0;
    }

    if SF.mv.subpel_force_stop == cast,no_check(u32) FULL_PEL {
        cpi.find_fractional_mv_step = vp9_skip_sub_pixel_tree;
    } else if SF.mv.subpel_search_method == cast,no_check(u32) SUBPEL_TREE {
        cpi.find_fractional_mv_step = vp9_find_best_sub_pixel_tree;
    } else if SF.mv.subpel_search_method == cast,no_check(u32) SUBPEL_TREE_PRUNED {
        cpi.find_fractional_mv_step = vp9_find_best_sub_pixel_tree_pruned;
    } else if SF.mv.subpel_search_method == cast,no_check(u32) SUBPEL_TREE_PRUNED_MORE {
        cpi.find_fractional_mv_step = vp9_find_best_sub_pixel_tree_pruned_more;
    } else if SF.mv.subpel_search_method == cast,no_check(u32) SUBPEL_TREE_PRUNED_EVENMORE {
        cpi.find_fractional_mv_step = vp9_find_best_sub_pixel_tree_pruned_evenmore;
    }

    if cpi.oxcf.motion_vector_unit_test == 1 {
        cpi.find_fractional_mv_step = vp9_return_max_sub_pixel_mv;
    } else if cpi.oxcf.motion_vector_unit_test == 2 {
        cpi.find_fractional_mv_step = vp9_return_min_sub_pixel_mv;
    }

    X.optimize = cast(s32) (SF.optimize_coefficients == 1 && OXCF.pass != 1);

    X.min_partition_size = SF.default_min_partition_size;
    X.max_partition_size = SF.default_max_partition_size;

    if cpi.oxcf.frame_periodic_boost == 0 {
        SF.max_delta_qindex = 0;
    }

    if SF.adaptive_rd_thresh_row_mt == 0 && cpi.row_mt_bit_exact != 0 && OXCF.max_threads > 1 {
        SF.adaptive_rd_thresh = 0;
    }
}

set_good_speed_feature_framesize_independent :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    cm: *VP9_COMMON,
    sf: *SPEED_FEATURES_in_vp9_speed_features,
    speed: s32
) {
    OXCF := *cpi.oxcf;
    BOOSTED := frame_is_boosted(cpi);

    sf.adaptive_interp_filter_search = 1;
    sf.adaptive_pred_interp_filter = 1;
    sf.adaptive_rd_thresh = 1;
    sf.adaptive_rd_thresh_row_mt = 0;
    sf.allow_skip_recode = 1;
    sf.less_rectangular_check = 1;
    sf.mv.auto_mv_step_size = 1;
    sf.mv.use_downsampled_sad = 1;
    sf.prune_ref_frame_for_rect_partitions = 1;
    sf.temporal_filter_search_method = cast,no_check(SEARCH_METHODS_in_vp9_cx_iface) NSTEP_in_vp9_cx_iface;
    sf.tx_size_search_breakout = 1;
    sf.use_square_partition_only = cast(s32) (BOOSTED == 0);
    sf.early_term_interp_search_plane_rd = 1;
    sf.cb_pred_filter_search = 1;
    sf.trellis_opt_tx_rd.method =
        cast,no_check(ENABLE_TRELLIS_OPT_METHOD) ((ifx sf.optimize_coefficients != 0 then cast,no_check(s32) (ENABLE_TRELLIS_OPT_TX_RD_RESIDUAL_MSE) else cast,no_check(s32) (DISABLE_TRELLIS_OPT)));
    sf.trellis_opt_tx_rd.thresh = ifx BOOSTED != 0 then cast(float64) 4.0 else 3.0;

    sf.intra_y_mode_mask[3] = cast,no_check(s32) (INTRA_DC_H_V);
    sf.comp_inter_joint_search_iter_level = 1;

    sf.reference_masking = cast(s32) (OXCF.resize_mode != cast,no_check(u32) RESIZE_DYNAMIC);

    sf.rd_ml_partition.var_pruning = 1;
    sf.rd_ml_partition.prune_rect_thresh[0] = -1;
    sf.rd_ml_partition.prune_rect_thresh[1] = 350;
    sf.rd_ml_partition.prune_rect_thresh[2] = 325;
    sf.rd_ml_partition.prune_rect_thresh[3] = 250;

    if cpi.twopass.fr_content_type == cast,no_check(u32) FC_GRAPHICS_ANIMATION {
        sf.exhaustive_searches_thresh = (cast(s32) 1) << 22;
    } else {
        sf.exhaustive_searches_thresh = 2147483647;
    }

    i: s32 = 0;
    while i < 4 {
        MESH_DENSITY_LEVEL: s32 = 0;
        sf.mesh_patterns[i].range = good_quality_mesh_patterns[MESH_DENSITY_LEVEL][i].range;
        sf.mesh_patterns[i].interval = good_quality_mesh_patterns[MESH_DENSITY_LEVEL][i].interval;
        i += 1;
    }

    if speed >= 1 {
        sf.rd_ml_partition.var_pruning = cast(s32) (BOOSTED == 0);
        sf.rd_ml_partition.prune_rect_thresh[1] = 225;
        sf.rd_ml_partition.prune_rect_thresh[2] = 225;
        sf.rd_ml_partition.prune_rect_thresh[3] = 225;

        if OXCF.pass == 2 {
            TWOPASS := *cpi.twopass;
            if TWOPASS.fr_content_type == cast,no_check(u32) FC_GRAPHICS_ANIMATION || vp9_internal_image_edge(cpi) != 0 {
                sf.use_square_partition_only = cast(s32) (BOOSTED == 0);
            } else {
                sf.use_square_partition_only = cast(s32) (frame_is_intra_only_in_vp9_speed_features(cm) == 0);
            }
        } else {
            sf.use_square_partition_only = cast(s32) (frame_is_intra_only_in_vp9_speed_features(cm) == 0);
        }

        sf.allow_txfm_domain_distortion = 1;
        sf.tx_domain_thresh = tx_dom_thresholds[(ifx speed < 6 then speed else 5)];
        sf.trellis_opt_tx_rd.method =
            cast,no_check(ENABLE_TRELLIS_OPT_METHOD) ((ifx sf.optimize_coefficients != 0 then cast,no_check(s32) (ENABLE_TRELLIS_OPT_TX_RD_SRC_VAR) else cast,no_check(s32) (DISABLE_TRELLIS_OPT)));
        sf.trellis_opt_tx_rd.thresh = qopt_thresholds[(ifx speed < 6 then speed else 5)];
        sf.less_rectangular_check = 1;
        sf.use_rd_breakout = 1;
        sf.adaptive_motion_search = 1;
        sf.adaptive_rd_thresh = 2;
        sf.mv.subpel_search_level = 1;
        if cpi.oxcf.content != cast,no_check(u32) VP9E_CONTENT_FILM {
            sf.mode_skip_start = 10;
        }
        sf.allow_acl = 0;

        sf.intra_uv_mode_mask[3] = cast,no_check(s32) (INTRA_DC_H_V);
        if cpi.oxcf.content != cast,no_check(u32) VP9E_CONTENT_FILM {
            sf.intra_y_mode_mask[2] = cast,no_check(s32) (INTRA_DC_H_V);
            sf.intra_uv_mode_mask[2] = cast,no_check(s32) (INTRA_DC_H_V);
        }

        sf.recode_tolerance_low = 15;
        sf.recode_tolerance_high = 30;

        sf.exhaustive_searches_thresh =
            ifx cpi.twopass.fr_content_type == cast,no_check(u32) FC_GRAPHICS_ANIMATION then (cast(s32) 1) << 23 else 2147483647;
        sf.use_accurate_subpel_search = cast,no_check(SUBPEL_SEARCH_TYPE) USE_4_TAPS;
    }

    if speed >= 2 {
        sf.rd_ml_partition.var_pruning = 0;
        if OXCF.vbr_corpus_complexity != 0 {
            sf.recode_loop = cast,no_check(RECODE_LOOP_TYPE) ALLOW_RECODE_FIRST;
        } else {
            sf.recode_loop = cast,no_check(RECODE_LOOP_TYPE) ALLOW_RECODE_KFARFGF;
        }

        sf.tx_size_search_method =
            cast,no_check(TX_SIZE_SEARCH_METHOD) ((ifx frame_is_boosted(cpi) != 0 then cast,no_check(s32) (USE_FULL_RD) else cast,no_check(s32) (USE_LARGESTALL)));

        sf.mode_search_skip_flags =
            cast,no_check(u32) ((ifx cm.frame_type == cast,no_check(u32) KEY_FRAME then 0 else (((cast,no_check(s32) (FLAG_SKIP_INTRA_DIRMISMATCH)) | cast,no_check(s32) (FLAG_SKIP_INTRA_BESTINTER)) | cast,no_check(s32) (FLAG_SKIP_COMP_BESTINTRA)) | cast,no_check(s32) (FLAG_SKIP_INTRA_LOWVAR)));
        sf.disable_filter_search_var_thresh = 100;
        sf.comp_inter_joint_search_iter_level = 2;
        sf.auto_min_max_partition_size = cast,no_check(AUTO_MIN_MAX_MODE) RELAXED_NEIGHBORING_MIN_MAX;
        sf.recode_tolerance_high = 45;
        sf.enhanced_full_pixel_motion_search = 0;
        sf.prune_ref_frame_for_rect_partitions = 0;
        sf.rd_ml_partition.prune_rect_thresh[1] = -1;
        sf.rd_ml_partition.prune_rect_thresh[2] = -1;
        sf.rd_ml_partition.prune_rect_thresh[3] = -1;
        sf.mv.subpel_search_level = 0;

        if cpi.twopass.fr_content_type == cast,no_check(u32) FC_GRAPHICS_ANIMATION {
            i = 0;
            while i < 4 {
                mesh_density_level: s32 = 1;
                sf.mesh_patterns[i].range = good_quality_mesh_patterns[mesh_density_level][i].range;
                sf.mesh_patterns[i].interval = good_quality_mesh_patterns[mesh_density_level][i].interval;
                i += 1;
            }
        }

        sf.use_accurate_subpel_search = cast,no_check(SUBPEL_SEARCH_TYPE) USE_2_TAPS;
    }

    if speed >= 3 {
        sf.use_square_partition_only = cast(s32) (frame_is_intra_only_in_vp9_speed_features(cm) == 0);
        sf.tx_size_search_method =
            cast,no_check(TX_SIZE_SEARCH_METHOD) ((ifx frame_is_intra_only_in_vp9_speed_features(
                cm
            ) != 0 then cast,no_check(s32) (USE_FULL_RD) else cast,no_check(s32) (USE_LARGESTALL)));
        sf.mv.subpel_search_method = cast,no_check(SUBPEL_SEARCH_METHODS) SUBPEL_TREE_PRUNED;
        sf.adaptive_pred_interp_filter = 0;
        sf.adaptive_mode_search = 1;
        sf.cb_partition_search = cast(s32) (BOOSTED == 0);
        sf.cb_pred_filter_search = 2;
        sf.alt_ref_search_fp = 1;
        sf.recode_loop = cast,no_check(RECODE_LOOP_TYPE) ALLOW_RECODE_KFMAXBW;
        sf.adaptive_rd_thresh = 3;
        sf.mode_skip_start = 6;
        sf.intra_y_mode_mask[3] = cast,no_check(s32) (INTRA_DC);
        sf.intra_uv_mode_mask[3] = cast,no_check(s32) (INTRA_DC);

        if cpi.twopass.fr_content_type == cast,no_check(u32) FC_GRAPHICS_ANIMATION {
            i = 0;
            while i < 4 {
                mesh_density_level: s32 = 2;
                sf.mesh_patterns[i].range = good_quality_mesh_patterns[mesh_density_level][i].range;
                sf.mesh_patterns[i].interval = good_quality_mesh_patterns[mesh_density_level][i].interval;
                i += 1;
            }
        }
    }

    if speed >= 4 {
        sf.use_square_partition_only = 1;
        sf.tx_size_search_method = cast,no_check(TX_SIZE_SEARCH_METHOD) USE_LARGESTALL;
        sf.mv.search_method = cast,no_check(SEARCH_METHODS_in_vp9_cx_iface) BIGDIA;
        sf.mv.subpel_search_method = cast,no_check(SUBPEL_SEARCH_METHODS) SUBPEL_TREE_PRUNED_MORE;
        sf.adaptive_rd_thresh = 4;
        if cm.frame_type != cast,no_check(u32) KEY_FRAME {
            sf.mode_search_skip_flags |= cast,no_check(u32) FLAG_EARLY_TERMINATE;
        }
        sf.disable_filter_search_var_thresh = 200;
        sf.use_lp32x32fdct = 1;
        sf.use_fast_coef_updates = cast,no_check(FAST_COEFF_UPDATE) ONE_LOOP_REDUCED;
        sf.use_fast_coef_costing = 1;
        sf.motion_field_mode_search = cast(s32) (BOOSTED == 0);
    }

    if speed >= 5 {
        sf.optimize_coefficients = 0;
        sf.mv.search_method = cast,no_check(SEARCH_METHODS_in_vp9_cx_iface) HEX_in_vp9_cx_iface;
        sf.disable_filter_search_var_thresh = 500;
        i = 0;
        while i < cast,no_check(s32) (cast(TX_SIZE) 4) {
            sf.intra_y_mode_mask[i] = cast,no_check(s32) (INTRA_DC);
            sf.intra_uv_mode_mask[i] = cast,no_check(s32) (INTRA_DC);
            i += 1;
        }
        sf.mv.reduce_first_step_size = 1;
        sf.simple_model_rd_from_var = 1;
    }
}

frame_is_boosted :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    return frame_is_kf_gf_arf_in_vp9_speed_features(cpi);
}

frame_is_kf_gf_arf_in_vp9_speed_features :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if frame_is_intra_only_in_vp9_speed_features(*cpi.common) != 0 ||
        cpi.refresh_alt_ref_frame != 0 ||
        cpi.refresh_golden_frame != 0 && cpi.rc.is_src_frame_alt_ref == 0 {
        return 1;
    }
    return 0;
}

set_rt_speed_feature_framesize_independent :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    sf: *SPEED_FEATURES_in_vp9_speed_features,
    speed: s32,
    content: Vp9e_Tune_Content
) {
    CM := *cpi.common;
    SVC_ := *cpi.svc;
    IS_KEYFRAME := cast(s32) (CM.frame_type == cast,no_check(u32) KEY_FRAME);
    FRAMES_SINCE_KEY := (ifx IS_KEYFRAME != 0 then 0 else cpi.rc.frames_since_key);
    sf.static_segmentation = 0;
    sf.adaptive_rd_thresh = 1;
    sf.adaptive_rd_thresh_row_mt = 0;
    sf.use_fast_coef_costing = 1;
    sf.exhaustive_searches_thresh = 2147483647;
    sf.allow_acl = 0;
    sf.copy_partition_flag = 0;
    sf.use_source_sad = 0;
    sf.use_simple_block_yrd = 0;
    sf.adapt_partition_source_sad = 0;
    sf.use_altref_onepass = 0;
    sf.use_compound_nonrd_pickmode = 0;
    sf.nonrd_keyframe = 0;
    sf.svc_use_lowres_part = 0;
    sf.overshoot_detection_cbr_rt = cast,no_check(OVERSHOOT_DETECTION_CBR_RT) NO_DETECTION;
    sf.disable_16x16part_nonkey = 0;
    sf.disable_golden_ref = 0;
    sf.enable_tpl_model = 0;
    sf.enhanced_full_pixel_motion_search = 0;
    sf.use_accurate_subpel_search = cast,no_check(SUBPEL_SEARCH_TYPE) USE_2_TAPS;
    sf.nonrd_use_ml_partition = 0;
    sf.variance_part_thresh_mult = 1;
    sf.cb_pred_filter_search = 0;
    sf.force_smooth_interpol = 0;
    sf.rt_intra_dc_only_low_content = 0;
    sf.mv.enable_adaptive_subpel_force_stop = 0;

    if speed >= 1 {
        sf.allow_txfm_domain_distortion = 1;
        sf.tx_domain_thresh = 0.0;
        sf.trellis_opt_tx_rd.method = cast,no_check(ENABLE_TRELLIS_OPT_METHOD) DISABLE_TRELLIS_OPT;
        sf.trellis_opt_tx_rd.thresh = 0.0;
        sf.use_square_partition_only = cast(s32) (frame_is_intra_only_in_vp9_speed_features(CM) == 0);
        sf.less_rectangular_check = 1;
        sf.tx_size_search_method =
            cast,no_check(TX_SIZE_SEARCH_METHOD) ((ifx frame_is_intra_only_in_vp9_speed_features(
                CM
            ) != 0 then cast,no_check(s32) (USE_FULL_RD) else cast,no_check(s32) (USE_LARGESTALL)));

        sf.use_rd_breakout = 1;

        sf.adaptive_motion_search = 1;
        sf.adaptive_pred_interp_filter = 1;
        sf.mv.auto_mv_step_size = 1;
        sf.adaptive_rd_thresh = 2;
        sf.intra_y_mode_mask[3] = cast,no_check(s32) (INTRA_DC_H_V);
        sf.intra_uv_mode_mask[3] = cast,no_check(s32) (INTRA_DC_H_V);
        sf.intra_uv_mode_mask[2] = cast,no_check(s32) (INTRA_DC_H_V);
    }

    if speed >= 2 {
        sf.mode_search_skip_flags =
            cast,no_check(u32) ((ifx CM.frame_type == cast,no_check(u32) KEY_FRAME then 0 else (((cast,no_check(s32) (FLAG_SKIP_INTRA_DIRMISMATCH)) | cast,no_check(s32) (FLAG_SKIP_INTRA_BESTINTER)) | cast,no_check(s32) (FLAG_SKIP_COMP_BESTINTRA)) | cast,no_check(s32) (FLAG_SKIP_INTRA_LOWVAR)));
        sf.adaptive_pred_interp_filter = 2;

        sf.reference_masking = cast(s32) (SVC_.number_spatial_layers == 1);
        if sf.reference_masking == 1 && (cpi.external_resize == 1 || cpi.oxcf.resize_mode == cast,no_check(u32) RESIZE_DYNAMIC) {
            ref_frame: MV_REFERENCE_FRAME = 1;
            while ref_frame <= 3 {
                yv12 := get_ref_frame_buffer_in_vp9_speed_features(cpi, ref_frame);
                if yv12 != null && cpi.ref_frame_flags & ref_frame_to_flag_in_vp9_speed_features(ref_frame) != 0 {
                    SCALE_FAC := *CM.frame_refs[(cast(s32) ref_frame) - 1].sf;
                    if vp9_is_scaled_in_vp9_speed_features(SCALE_FAC) != 0 {
                        sf.reference_masking = 0;
                    }
                }
                ref_frame += 1;
            }
        }

        sf.disable_filter_search_var_thresh = 50;
        sf.comp_inter_joint_search_iter_level = 2;
        sf.auto_min_max_partition_size = cast,no_check(AUTO_MIN_MAX_MODE) RELAXED_NEIGHBORING_MIN_MAX;
        sf.lf_motion_threshold = cast,no_check(MOTION_THRESHOLD) LOW_MOTION_THRESHOLD;
        sf.adjust_partitioning_from_last_frame = 1;
        sf.last_partitioning_redo_frequency = 3;
        sf.use_lp32x32fdct = 1;
        sf.mode_skip_start = 11;
        sf.intra_y_mode_mask[2] = cast,no_check(s32) (INTRA_DC_H_V);
    }

    if speed >= 3 {
        sf.use_square_partition_only = 1;
        sf.disable_filter_search_var_thresh = 100;
        sf.use_uv_intra_rd_estimate = 1;
        sf.skip_encode_sb = 1;
        sf.mv.subpel_search_level = 0;
        sf.adaptive_rd_thresh = 4;
        sf.mode_skip_start = 6;
        sf.allow_skip_recode = 0;
        sf.optimize_coefficients = 0;
        sf.disable_split_mask = cast,no_check(s32) (DISABLE_ALL_SPLIT);
        sf.lpf_pick = cast,no_check(LPF_PICK_METHOD) LPF_PICK_FROM_Q;
    }

    if speed >= 4 {
        if cpi.oxcf.rc_mode == cast,no_check(u32) VBR && cpi.oxcf.lag_in_frames > 0 {
            sf.use_altref_onepass = 1;
        }
        sf.mv.subpel_force_stop = cast,no_check(SUBPEL_FORCE_STOP) QUARTER_PEL;
        i: s32 = 0;
        while i < cast,no_check(s32) (cast(TX_SIZE) 4) {
            sf.intra_y_mode_mask[i] = cast,no_check(s32) (INTRA_DC_H_V);
            sf.intra_uv_mode_mask[i] = cast,no_check(s32) (INTRA_DC);
            i += 1;
        }
        sf.intra_y_mode_mask[3] = cast,no_check(s32) (INTRA_DC);
        sf.frame_parameter_update = 0;
        sf.mv.search_method = cast,no_check(SEARCH_METHODS_in_vp9_cx_iface) FAST_HEX;
        sf.allow_skip_recode = 0;
        sf.max_intra_bsize = 9;
        sf.use_fast_coef_costing = 0;
        sf.use_quant_fp = cast(s32) (IS_KEYFRAME == 0);
        sf.inter_mode_mask[9] = cast,no_check(s32) (INTER_NEAREST_NEW_ZERO);
        sf.inter_mode_mask[10] = cast,no_check(s32) (INTER_NEAREST_NEW_ZERO);
        sf.inter_mode_mask[11] = cast,no_check(s32) (INTER_NEAREST_NEW_ZERO);
        sf.inter_mode_mask[12] = cast,no_check(s32) (INTER_NEAREST_NEW_ZERO);
        sf.adaptive_rd_thresh = 2;
        sf.use_fast_coef_updates =
            cast,no_check(FAST_COEFF_UPDATE) ((ifx IS_KEYFRAME != 0 then cast,no_check(s32) (TWO_LOOP) else cast,no_check(s32) (ONE_LOOP_REDUCED)));
        sf.mode_search_skip_flags = cast,no_check(u32) FLAG_SKIP_INTRA_DIRMISMATCH;
        sf.tx_size_search_method =
            cast,no_check(TX_SIZE_SEARCH_METHOD) ((ifx IS_KEYFRAME != 0 then cast,no_check(s32) (USE_LARGESTALL) else cast,no_check(s32) (USE_TX_8X8)));
        sf.partition_search_type = cast,no_check(PARTITION_SEARCH_TYPE) VAR_BASED_PARTITION;
    }

    if speed >= 5 {
        sf.use_altref_onepass = 0;
        sf.use_quant_fp = cast(s32) (IS_KEYFRAME == 0);
        sf.auto_min_max_partition_size =
            cast,no_check(AUTO_MIN_MAX_MODE) ((ifx IS_KEYFRAME != 0 then cast,no_check(s32) (RELAXED_NEIGHBORING_MIN_MAX) else cast,no_check(s32) (STRICT_NEIGHBORING_MIN_MAX)));
        sf.default_max_partition_size = 9;
        sf.default_min_partition_size = 3;
        sf.force_frame_boost =
            cast(s32) (IS_KEYFRAME != 0 ||
                FRAMES_SINCE_KEY % sf.last_partitioning_redo_frequency << 1 == 1);
        sf.max_delta_qindex = ifx IS_KEYFRAME != 0 then cast(s32) 20 else 15;
        sf.partition_search_type = cast,no_check(PARTITION_SEARCH_TYPE) REFERENCE_PARTITION;
        if cpi.oxcf.rc_mode == cast,no_check(u32) VBR && cpi.oxcf.lag_in_frames > 0 && cpi.rc.is_src_frame_alt_ref != 0 {
            sf.partition_search_type = cast,no_check(PARTITION_SEARCH_TYPE) VAR_BASED_PARTITION;
        }
        sf.use_nonrd_pick_mode = 1;
        sf.allow_skip_recode = 0;
        sf.inter_mode_mask[9] = cast,no_check(s32) (INTER_NEAREST_NEW_ZERO);
        sf.inter_mode_mask[10] = cast,no_check(s32) (INTER_NEAREST_NEW_ZERO);
        sf.inter_mode_mask[11] = cast,no_check(s32) (INTER_NEAREST_NEW_ZERO);
        sf.inter_mode_mask[12] = cast,no_check(s32) (INTER_NEAREST_NEW_ZERO);
        sf.adaptive_rd_thresh = 2;

        sf.reuse_inter_pred_sby = 1;
        sf.coeff_prob_appx_step = 4;
        sf.use_fast_coef_updates =
            cast,no_check(FAST_COEFF_UPDATE) ((ifx IS_KEYFRAME != 0 then cast,no_check(s32) (TWO_LOOP) else cast,no_check(s32) (ONE_LOOP_REDUCED)));
        sf.mode_search_skip_flags = cast,no_check(u32) FLAG_SKIP_INTRA_DIRMISMATCH;
        sf.tx_size_search_method =
            cast,no_check(TX_SIZE_SEARCH_METHOD) ((ifx IS_KEYFRAME != 0 then cast,no_check(s32) (USE_LARGESTALL) else cast,no_check(s32) (USE_TX_8X8)));
        sf.simple_model_rd_from_var = 1;
        if cpi.oxcf.rc_mode == cast,no_check(u32) VBR {
            sf.mv.search_method = cast,no_check(SEARCH_METHODS_in_vp9_cx_iface) NSTEP_in_vp9_cx_iface;
        }

        if IS_KEYFRAME == 0 {
            if content == cast,no_check(u32) VP9E_CONTENT_SCREEN {
                for i: 0..cast(s32) 13 - 1 {
                    if i >= 9 {
                        sf.intra_y_mode_bsize_mask[i] = cast,no_check(s32) (INTRA_DC_H_V);
                    } else {
                        sf.intra_y_mode_bsize_mask[i] = cast,no_check(s32) (INTRA_DC_TM_H_V);
                    }
                }
            } else {
                for i: 0..cast(s32) 13 - 1 {
                    if i > 6 {
                        sf.intra_y_mode_bsize_mask[i] = cast,no_check(s32) (INTRA_DC);
                    } else {
                        sf.intra_y_mode_bsize_mask[i] = cast,no_check(s32) (INTRA_DC_H_V);
                    }
                }
            }
        }
        if content == cast,no_check(u32) VP9E_CONTENT_SCREEN {
            sf.short_circuit_flat_blocks = 1;
        }
        if cpi.oxcf.rc_mode == cast,no_check(u32) CBR && cpi.oxcf.content != cast,no_check(u32) VP9E_CONTENT_SCREEN {
            sf.limit_newmv_early_exit = 1;
            if cpi.use_svc == 0 {
                sf.bias_golden = 1;
            }
        }

        if cpi.use_svc != 0 && SVC_.spatial_layer_id > 0 {
            sf.nonrd_keyframe = 1;
        }
        if CM.frame_type != cast,no_check(u32) KEY_FRAME &&
            cpi.resize_state == cast,no_check(u32) ORIG &&
            cpi.oxcf.rc_mode == cast,no_check(u32) CBR &&
            cpi.rc.disable_overshoot_maxq_cbr == 0 {
            if CM.width * CM.height <= 352 * 288 && cpi.use_svc == 0 && cpi.oxcf.content != cast,no_check(u32) VP9E_CONTENT_SCREEN {
                sf.overshoot_detection_cbr_rt = cast,no_check(OVERSHOOT_DETECTION_CBR_RT) RE_ENCODE_MAXQ;
            } else {
                sf.overshoot_detection_cbr_rt = cast,no_check(OVERSHOOT_DETECTION_CBR_RT) FAST_DETECTION_MAXQ;
            }
        }
        if cpi.oxcf.rc_mode == cast,no_check(u32) VBR && cpi.oxcf.lag_in_frames > 0 && CM.width <= 1280 && CM.height <= 720 {
            sf.use_altref_onepass = 1;
            sf.use_compound_nonrd_pickmode = 1;
        }
        if CM.width * CM.height > 1280 * 720 {
            sf.cb_pred_filter_search = 2;
        }
        if cpi.external_resize == 0 {
            sf.use_source_sad = 1;
        }
    }

    if speed >= 6 {
        if cpi.oxcf.rc_mode == cast,no_check(u32) VBR && cpi.oxcf.lag_in_frames > 0 {
            sf.use_altref_onepass = 1;
            sf.use_compound_nonrd_pickmode = 1;
        }
        sf.partition_search_type = cast,no_check(PARTITION_SEARCH_TYPE) VAR_BASED_PARTITION;
        sf.mv.search_method = cast,no_check(SEARCH_METHODS_in_vp9_cx_iface) NSTEP_in_vp9_cx_iface;
        sf.mv.reduce_first_step_size = 1;
        sf.skip_encode_sb = 0;

        if sf.use_source_sad != 0 {
            sf.adapt_partition_source_sad = 1;
            sf.adapt_partition_thresh = ifx CM.width * CM.height <= 640 * 360 then cast(s32) 40000 else 60000;
            if cpi.content_state_sb_fd == null && (cpi.use_svc == 0 || SVC_.spatial_layer_id == SVC_.number_spatial_layers - 1) {
                init_mi_rows, init_mi_cols, init_mi_stride: s32 = ---;
                vp9_set_mi_size(*init_mi_rows, *init_mi_cols, *init_mi_stride, cpi.initial_width, cpi.initial_height);
                cpi.content_state_sb_fd =
                    cast(*u8) calloc_2(
                        cast,no_check(u64) (init_mi_stride >> 3 * (init_mi_rows >> 3 + 1)),
                        size_of(u8)
                    );

                if cpi.content_state_sb_fd == null {
                    internal_error(
                        *CM.error,
                        cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                        c_string("Failed to allocate cpi->content_state_sb_fd")
                    );
                }
            }
        }
        if cpi.oxcf.rc_mode == cast,no_check(u32) CBR && content != cast,no_check(u32) VP9E_CONTENT_SCREEN {
            sf.short_circuit_low_temp_var = 1;
        }
        if SVC_.temporal_layer_id > 0 {
            sf.adaptive_rd_thresh = 4;
            sf.limit_newmv_early_exit = 0;
            sf.base_mv_aggressive = 1;
        }
        if CM.frame_type != cast,no_check(u32) KEY_FRAME &&
            cpi.resize_state == cast,no_check(u32) ORIG &&
            cpi.oxcf.rc_mode == cast,no_check(u32) CBR &&
            cpi.rc.disable_overshoot_maxq_cbr == 0 {
            sf.overshoot_detection_cbr_rt = cast,no_check(OVERSHOOT_DETECTION_CBR_RT) FAST_DETECTION_MAXQ;
        }
    }

    if speed >= 7 {
        sf.adapt_partition_source_sad = 0;
        sf.adaptive_rd_thresh = 3;
        sf.mv.search_method = cast,no_check(SEARCH_METHODS_in_vp9_cx_iface) FAST_DIAMOND;
        sf.mv.fullpel_search_step_param = 10;

        if SVC_.number_temporal_layers > 2 &&
            SVC_.temporal_layer_id == 0 &&
            (SVC_.spatial_layer_id == 0 || cpi.oxcf.width * cpi.oxcf.height <= 640 * 360) {
            sf.mv.search_method = cast,no_check(SEARCH_METHODS_in_vp9_cx_iface) NSTEP_in_vp9_cx_iface;
            sf.mv.fullpel_search_step_param = 6;
        }
        if SVC_.temporal_layer_id > 0 || SVC_.spatial_layer_id > 1 {
            sf.use_simple_block_yrd = 1;
            if SVC_.non_reference_frame != 0 {
                sf.mv.subpel_search_method = cast,no_check(SUBPEL_SEARCH_METHODS) SUBPEL_TREE_PRUNED_EVENMORE;
            }
        }
        if cpi.use_svc != 0 && cpi.row_mt != 0 && cpi.oxcf.max_threads > 1 {
            sf.adaptive_rd_thresh_row_mt = 1;
        }

        cpi.max_copied_frame = 0;
        if cpi.last_frame_dropped == 0 &&
            cpi.resize_state == cast,no_check(u32) ORIG &&
            cpi.external_resize == 0 &&
            (cpi.use_svc == 0 ||
                SVC_.spatial_layer_id == SVC_.number_spatial_layers - 1 && SVC_.last_layer_dropped[SVC_.number_spatial_layers - 1] == 0) {
            sf.copy_partition_flag = 1;
            cpi.max_copied_frame = 2;

            if SVC_.number_temporal_layers > 1 && SVC_.temporal_layer_id == SVC_.number_temporal_layers - 1 {
                cpi.max_copied_frame = 255;
            }
        }

        if cpi.use_svc != 0 &&
            SVC_.use_partition_reuse != 0 &&
            SVC_.number_spatial_layers == 3 &&
            SVC_.temporal_layer_id > 0 &&
            cpi.oxcf.width * cpi.oxcf.height > 640 * 480 {
            sf.svc_use_lowres_part = 1;
        }

        if cpi.use_svc != 0 && SVC_.use_gf_temporal_ref_current_layer != 0 && SVC_.temporal_layer_id > 0 {
            cpi.ref_frame_flags &= cast,no_check(s32) (~(VP9_GOLD_FLAG));
        }
        if CM.width * CM.height > 640 * 480 {
            sf.cb_pred_filter_search = 2;
        }
    }

    if speed >= 8 {
        sf.adaptive_rd_thresh = 4;
        sf.skip_encode_sb = 1;
        if cpi.svc.number_spatial_layers > 1 && cpi.svc.simulcast_mode == 0 {
            sf.nonrd_keyframe = 0;
        } else {
            sf.nonrd_keyframe = 1;
        }
        if cpi.use_svc == 0 {
            cpi.max_copied_frame = 4;
        }
        if cpi.row_mt != 0 && cpi.oxcf.max_threads > 1 {
            sf.adaptive_rd_thresh_row_mt = 1;
        }

        if frame_is_intra_only_in_vp9_speed_features(CM) == 0 && CM.width * CM.height <= 352 * 288 {
            sf.nonrd_use_ml_partition = 1;
        }

        if content == cast,no_check(u32) VP9E_CONTENT_SCREEN {
            sf.mv.subpel_force_stop = cast,no_check(SUBPEL_FORCE_STOP) HALF_PEL;
        }
        sf.rt_intra_dc_only_low_content = 1;
        if cpi.use_svc == 0 && cpi.oxcf.rc_mode == cast,no_check(u32) CBR && content != cast,no_check(u32) VP9E_CONTENT_SCREEN {
            sf.short_circuit_low_temp_var = 3;

            if cpi.noise_estimate.enabled != 0 && CM.width >= 1280 && CM.height >= 720 {
                noise_level := vp9_noise_estimate_extract_level(*cpi.noise_estimate);
                if noise_level >= cast,no_check(u32) K_MEDIUM {
                    sf.short_circuit_low_temp_var = 2;
                }
            }

            if CM.width * CM.height > 352 * 288 {
                sf.adaptive_rd_thresh = 1;
            } else {
                sf.adaptive_rd_thresh = 2;
            }
        }
        sf.limit_newmv_early_exit = 0;
        sf.use_simple_block_yrd = 1;
        if CM.width * CM.height > 352 * 288 {
            sf.cb_pred_filter_search = 2;
        }
    }

    if speed >= 9 {
        if IS_KEYFRAME == 0 {
            i: s32 = 0;
            i = 0;
            while i < 13 {
                sf.intra_y_mode_bsize_mask[i] = cast,no_check(s32) (INTRA_DC);
                i += 1;
            }
        }
        sf.cb_pred_filter_search = 2;
        sf.mv.enable_adaptive_subpel_force_stop = 1;
        sf.mv.adapt_subpel_force_stop.mv_thresh = 1;
        sf.mv.adapt_subpel_force_stop.force_stop_below = cast,no_check(SUBPEL_FORCE_STOP) QUARTER_PEL;
        sf.mv.adapt_subpel_force_stop.force_stop_above = cast,no_check(SUBPEL_FORCE_STOP) HALF_PEL;

        if CM.frame_type != cast,no_check(u32) KEY_FRAME && CM.width >= 320 && CM.height >= 240 {
            sf.disable_16x16part_nonkey = 1;
        }

        if cpi.oxcf.rc_mode == cast,no_check(u32) CBR {
            sf.disable_golden_ref = 1;
        }
        if cpi.rc.avg_frame_low_motion < 70 {
            sf.default_interp_filter = 3;
        }
        if CM.width * CM.height >= 640 * 360 {
            sf.variance_part_thresh_mult = 2;
        }
    }

    if CM.frame_type != cast,no_check(u32) KEY_FRAME &&
        CM.width * CM.height <= 320 * 240 &&
        sf.partition_search_type == cast,no_check(u32) VAR_BASED_PARTITION &&
        cpi.rc.avg_frame_qindex[INTER_FRAME] > 208 &&
        cpi.common.current_video_frame > 8 {
        sf.disable_16x16part_nonkey = 1;
    }

    if sf.nonrd_use_ml_partition != 0 {
        sf.partition_search_type = cast,no_check(PARTITION_SEARCH_TYPE) ML_BASED_PARTITION;
    }

    if sf.use_altref_onepass != 0 {
        if cpi.rc.is_src_frame_alt_ref != 0 && CM.frame_type != cast,no_check(u32) KEY_FRAME {
            sf.partition_search_type = cast,no_check(PARTITION_SEARCH_TYPE) FIXED_PARTITION;
            sf.always_this_block_size = 12;
        }
        if cpi.count_arf_frame_usage == null {
            cpi.count_arf_frame_usage =
                cast(*u8) calloc_2(
                    cast,no_check(u64) (CM.mi_stride >> 3 * (CM.mi_rows >> 3 + 1)),
                    size_of(u8)
                );

            if cpi.count_arf_frame_usage == null {
                internal_error(
                    *CM.error,
                    cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                    c_string("Failed to allocate cpi->count_arf_frame_usage")
                );
            }
        }
        if cpi.count_lastgolden_frame_usage == null {
            cpi.count_lastgolden_frame_usage =
                cast(*u8) calloc_2(
                    cast,no_check(u64) (CM.mi_stride >> 3 * (CM.mi_rows >> 3 + 1)),
                    size_of(u8)
                );

            if cpi.count_lastgolden_frame_usage == null {
                internal_error(
                    *CM.error,
                    cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                    c_string("Failed to allocate cpi->count_lastgolden_frame_usage")
                );
            }
        }
    }
    if SVC_.previous_frame_is_intra_only != 0 {
        sf.partition_search_type = cast,no_check(PARTITION_SEARCH_TYPE) FIXED_PARTITION;
        sf.always_this_block_size = 12;
    }

    if cpi.oxcf.content == cast,no_check(u32) VP9E_CONTENT_SCREEN &&
        cpi.oxcf.speed >= 5 &&
        (SVC_.high_num_blocks_with_motion != 0 || SVC_.last_layer_dropped[0] != 0) {
        sf.mv.search_method = cast,no_check(SEARCH_METHODS_in_vp9_cx_iface) NSTEP_in_vp9_cx_iface;

        sf.mv.fullpel_search_step_param = 2;
    }

    if speed <= 3 && cpi.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ {
        cpi.oxcf.aq_mode = cast,no_check(AQ_MODE) (cast(s32) 0);
    }

    if cpi.oxcf.mode != cpi.deadline_mode_previous_frame {
        sf.nonrd_keyframe = 1;
    }

    sf.svc_use_lowres_part = 0;
}

ref_frame_to_flag_in_vp9_speed_features :: (ref_frame: s8) -> s32 {

    return K_VP9_REF_FLAG_LIST_in_vp9_speed_features[ref_frame];
}

get_ref_frame_buffer_in_vp9_speed_features :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    ref_frame: MV_REFERENCE_FRAME
) -> *YV12_BUFFER_CONFIG {
    CM := *CPI.common;
    BUF_IDX := get_ref_frame_buf_idx_in_vp9_speed_features(CPI, cast,no_check(s32) ref_frame);
    return ifx BUF_IDX != -1 then *CM.buffer_pool.frame_bufs[BUF_IDX].buf else null;
}

get_ref_frame_buf_idx_in_vp9_speed_features :: (CPI: *VP9_COMP_in_vp9_encoder, ref_frame: s32) -> s32 {
    CM := *CPI.common;
    MAP_IDX := get_ref_frame_map_idx_in_vp9_speed_features(CPI, cast,no_check(MV_REFERENCE_FRAME) ref_frame);
    return ifx MAP_IDX != -1 then CM.ref_frame_map[MAP_IDX] else -1;
}

get_ref_frame_map_idx_in_vp9_speed_features :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame: MV_REFERENCE_FRAME) -> s32 {
    if ref_frame == 1 {
        return cpi.lst_fb_idx;
    } else if ref_frame == 2 {
        return cpi.gld_fb_idx;
    } else {
        return cpi.alt_fb_idx;
    }
}

is_lossless_requested_in_vp9_speed_features :: (cfg: *VP9_Encoder_Config) -> s32 {
    if cfg.best_allowed_q == 0 && cfg.worst_allowed_q == 0 {
        return 1;
    }
    return 0;
}

vp9_set_speed_features_framesize_dependent :: (cpi: *VP9_COMP_in_vp9_encoder, speed: s32) {
    SF := *cpi.sf;
    OXCF := *cpi.oxcf;
    RD := *cpi.rd;

    SF.partition_search_breakout_thr.dist = cast,no_check(s64) ((cast(s32) 1) << 19);
    SF.partition_search_breakout_thr.rate = 80;
    SF.rd_ml_partition.search_early_termination = 0;
    SF.rd_ml_partition.search_breakout = 0;

    if OXCF.mode == cast,no_check(u32) REALTIME {
        set_rt_speed_feature_framesize_dependent(cpi, SF, speed);
    } else if OXCF.mode == cast,no_check(u32) GOOD {
        set_good_speed_feature_framesize_dependent(cpi, SF, speed);
    }

    if SF.disable_split_mask == DISABLE_ALL_SPLIT {
        SF.adaptive_pred_interp_filter = 0;
    }

    if cpi.encode_breakout != 0 && OXCF.mode == cast,no_check(u32) REALTIME && SF.encode_breakout_thresh > cpi.encode_breakout {
        cpi.encode_breakout = SF.encode_breakout_thresh;
    }

    for i: 0..cast(s32) 6 - 1 {
        if SF.disable_split_mask & ((cast(s32) 1) << ((i) & 31)) != 0 {
            RD.thresh_mult_sub8x8[i] = 2147483647;
        }
    }

    if SF.adaptive_rd_thresh_row_mt == 0 && cpi.row_mt_bit_exact != 0 && OXCF.max_threads > 1 {
        SF.adaptive_rd_thresh = 0;
    }
}

set_good_speed_feature_framesize_dependent :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    sf: *SPEED_FEATURES_in_vp9_speed_features,
    speed: s32
) {
    CM := *cpi.common;
    MIN_FRAME_SIZE := (ifx CM.width < CM.height then CM.width else CM.height);
    IS_480P_OR_LARGER := cast(s32) (MIN_FRAME_SIZE >= 480);
    IS_720P_OR_LARGER := cast(s32) (MIN_FRAME_SIZE >= 720);
    IS_1080P_OR_LARGER := cast(s32) (MIN_FRAME_SIZE >= 1080);
    IS_2160P_OR_LARGER := cast(s32) (MIN_FRAME_SIZE >= 2160);
    BOOSTED := frame_is_boosted(cpi);

    sf.partition_search_breakout_thr.dist = cast,no_check(s64) ((cast(s32) 1) << 20);
    sf.partition_search_breakout_thr.rate = 80;
    sf.use_square_only_thresh_high = 13;
    sf.use_square_only_thresh_low = 0;

    if IS_480P_OR_LARGER != 0 {
        sf.rd_ml_partition.search_early_termination = 1;
        sf.recode_tolerance_high = 45;
    } else {
        sf.use_square_only_thresh_high = 9;
    }
    if IS_720P_OR_LARGER != 0 {
        sf.alt_ref_search_fp = 1;
    }

    if IS_1080P_OR_LARGER == 0 {
        sf.rd_ml_partition.search_breakout = 1;
        if IS_720P_OR_LARGER != 0 {
            sf.rd_ml_partition.search_breakout_thresh[0] = 0.0;
            sf.rd_ml_partition.search_breakout_thresh[1] = 0.0;
            sf.rd_ml_partition.search_breakout_thresh[2] = 0.0;
        } else {
            sf.rd_ml_partition.search_breakout_thresh[0] = 2.5;
            sf.rd_ml_partition.search_breakout_thresh[1] = 1.5;
            sf.rd_ml_partition.search_breakout_thresh[2] = 1.5;
        }
    }

    if IS_720P_OR_LARGER == 0 {
        if IS_480P_OR_LARGER != 0 {
            sf.prune_single_mode_based_on_mv_diff_mode_rate = ifx BOOSTED != 0 then cast(s32) 0 else 1;
        } else {
            sf.prune_single_mode_based_on_mv_diff_mode_rate = 1;
        }
    }

    if speed >= 1 {
        sf.rd_ml_partition.search_early_termination = 0;
        sf.rd_ml_partition.search_breakout = 1;
        if IS_480P_OR_LARGER != 0 {
            sf.use_square_only_thresh_high = 12;
        } else {
            sf.use_square_only_thresh_high = 9;
        }
        sf.use_square_only_thresh_low = 6;
        if IS_720P_OR_LARGER != 0 {
            sf.disable_split_mask =
                ifx CM.show_frame != 0 then cast,no_check(s32) (DISABLE_ALL_SPLIT) else cast,no_check(s32) (DISABLE_ALL_INTER_SPLIT);
            sf.partition_search_breakout_thr.dist = cast,no_check(s64) ((cast(s32) 1) << 22);
            sf.rd_ml_partition.search_breakout_thresh[0] = -5.0;
            sf.rd_ml_partition.search_breakout_thresh[1] = -5.0;
            sf.rd_ml_partition.search_breakout_thresh[2] = -9.0;
        } else {
            sf.disable_split_mask = cast,no_check(s32) (DISABLE_COMPOUND_SPLIT);
            sf.partition_search_breakout_thr.dist = cast,no_check(s64) ((cast(s32) 1) << 21);
            sf.rd_ml_partition.search_breakout_thresh[0] = -1.0;
            sf.rd_ml_partition.search_breakout_thresh[1] = -1.0;
            sf.rd_ml_partition.search_breakout_thresh[2] = -1.0;
        }
    }

    if speed >= 2 {
        sf.use_square_only_thresh_high = 0;
        sf.use_square_only_thresh_low = 13;
        if IS_720P_OR_LARGER != 0 {
            sf.disable_split_mask =
                ifx CM.show_frame != 0 then cast,no_check(s32) (DISABLE_ALL_SPLIT) else cast,no_check(s32) (DISABLE_ALL_INTER_SPLIT);
            sf.adaptive_pred_interp_filter = 0;
            sf.partition_search_breakout_thr.dist = cast,no_check(s64) ((cast(s32) 1) << 24);
            sf.partition_search_breakout_thr.rate = 120;
            sf.rd_ml_partition.search_breakout = 0;
        } else {
            sf.disable_split_mask = cast,no_check(s32) (LAST_AND_INTRA_SPLIT_ONLY);
            sf.partition_search_breakout_thr.dist = cast,no_check(s64) ((cast(s32) 1) << 22);
            sf.partition_search_breakout_thr.rate = 100;
            sf.rd_ml_partition.search_breakout_thresh[0] = 0.0;
            sf.rd_ml_partition.search_breakout_thresh[1] = -1.0;
            sf.rd_ml_partition.search_breakout_thresh[2] = -4.0;
        }
        sf.rd_auto_partition_min_limit = set_partition_min_limit(CM);

        if IS_2160P_OR_LARGER != 0 {
            sf.use_square_partition_only = 1;
            sf.intra_y_mode_mask[3] = cast,no_check(s32) (INTRA_DC);
            sf.intra_uv_mode_mask[3] = cast,no_check(s32) (INTRA_DC);
            sf.alt_ref_search_fp = 1;
            sf.cb_pred_filter_search = 2;
            sf.adaptive_interp_filter_search = 1;
            sf.disable_split_mask = cast,no_check(s32) (DISABLE_ALL_SPLIT);
        }
    }

    if speed >= 3 {
        sf.rd_ml_partition.search_breakout = 0;
        if IS_720P_OR_LARGER != 0 {
            sf.disable_split_mask = cast,no_check(s32) (DISABLE_ALL_SPLIT);
            sf.schedule_mode_search = cast(s32) (CM.base_qindex < 220);
            sf.partition_search_breakout_thr.dist = cast,no_check(s64) ((cast(s32) 1) << 25);
            sf.partition_search_breakout_thr.rate = 200;
        } else {
            sf.max_intra_bsize = 9;
            sf.disable_split_mask = cast,no_check(s32) (DISABLE_ALL_INTER_SPLIT);
            sf.schedule_mode_search = cast(s32) (CM.base_qindex < 175);
            sf.partition_search_breakout_thr.dist = cast,no_check(s64) ((cast(s32) 1) << 23);
            sf.partition_search_breakout_thr.rate = 120;
        }
    }

    if speed >= 1 &&
        cpi.oxcf.pass == 2 &&
        (cpi.twopass.fr_content_type == cast,no_check(u32) FC_GRAPHICS_ANIMATION || vp9_internal_image_edge(cpi) != 0) {
        sf.disable_split_mask = cast,no_check(s32) (DISABLE_COMPOUND_SPLIT);
    }

    if speed >= 4 {
        sf.partition_search_breakout_thr.rate = 300;
        if IS_720P_OR_LARGER != 0 {
            sf.partition_search_breakout_thr.dist = cast,no_check(s64) ((cast(s32) 1) << 26);
        } else {
            sf.partition_search_breakout_thr.dist = cast,no_check(s64) ((cast(s32) 1) << 24);
        }
        sf.disable_split_mask = cast,no_check(s32) (DISABLE_ALL_SPLIT);
    }

    if speed >= 5 {
        sf.partition_search_breakout_thr.rate = 500;
    }
}

set_partition_min_limit :: (CM: *VP9_COMMON) -> BLOCK_SIZE {
    screen_area := cast,no_check(u32) (CM.width * CM.height);

    if screen_area < cast,no_check(u32) (1280 * 720) {
        return 0;
    } else if screen_area < cast,no_check(u32) (1920 * 1080) {
        return 3;
    } else {
        return 6;
    }
}

set_rt_speed_feature_framesize_dependent :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    sf: *SPEED_FEATURES_in_vp9_speed_features,
    speed: s32
) {
    CM := *cpi.common;

    if speed >= 1 {
        if (ifx CM.width < CM.height then CM.width else CM.height) >= 720 {
            sf.disable_split_mask =
                ifx CM.show_frame != 0 then cast,no_check(s32) (DISABLE_ALL_SPLIT) else cast,no_check(s32) (DISABLE_ALL_INTER_SPLIT);
        } else {
            sf.disable_split_mask = cast,no_check(s32) (DISABLE_COMPOUND_SPLIT);
        }
    }

    if speed >= 2 {
        if (ifx CM.width < CM.height then CM.width else CM.height) >= 720 {
            sf.disable_split_mask =
                ifx CM.show_frame != 0 then cast,no_check(s32) (DISABLE_ALL_SPLIT) else cast,no_check(s32) (DISABLE_ALL_INTER_SPLIT);
        } else {
            sf.disable_split_mask = cast,no_check(s32) (LAST_AND_INTRA_SPLIT_ONLY);
        }
    }

    if speed >= 5 {
        sf.partition_search_breakout_thr.rate = 200;
        if (ifx CM.width < CM.height then CM.width else CM.height) >= 720 {
            sf.partition_search_breakout_thr.dist = cast,no_check(s64) ((cast(s32) 1) << 25);
        } else {
            sf.partition_search_breakout_thr.dist = cast,no_check(s64) ((cast(s32) 1) << 23);
        }
    }

    if speed >= 7 {
        sf.encode_breakout_thresh =
            ifx (ifx CM.width < CM.height then CM.width else CM.height) >= 720 then cast(s32) 800 else 300;
    }
}

write_in_vp9_speed_features :: (br: *Writer, bit: s32, probability: s32) {
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

write_bit_in_vp9_speed_features :: (w: *Writer, bit: s32) {
    write_in_vp9_speed_features(w, bit, 128);
}

write_literal_in_vp9_speed_features :: (w: *Writer, data: s32, bits: s32) {
    bit := bits - 1;
    while bit >= 0 {
        write_bit_in_vp9_speed_features(w, 1 & (data >> ((bit) & 31)));
        bit -= 1;
    }
}

vp9_write_tree_in_vp9_speed_features :: (
    w: *Writer,
    tree: *Tree_Index,
    probs: *Prob,
    bits: s32,
    len: s32,
    i: Tree_Index
) {
    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            write_in_vp9_speed_features(w, BIT, cast,no_check(s32) probs[(cast(s32) i) >> 1]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }
}

vp9_write_token_in_vp9_speed_features :: (w: *Writer, tree: *Tree_Index, probs: *Prob, token: *Vp9_Token) {
    vp9_write_tree_in_vp9_speed_features(w, tree, probs, token.value, token.len, 0);
}

vp9_get_high_cost_table_in_vp9_speed_features :: (bit_depth: s32) -> *u16 {
    return VP9_CAT6_HIGH_COST.data;
}

vp9_get_token_extra_in_vp9_speed_features :: (v: s32, token: *s16, extra: *EXTRABIT) {
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

vp9_get_token_in_vp9_speed_features :: (v: s32) -> s16 {
    if v >= 67 || v <= -67 {
        return 10;
    }
    return vp9_dct_cat_lt_10_value_tokens[v].token;
}

vp9_get_token_cost_in_vp9_speed_features :: (v: s32, token: *s16, cat6_high_table: *u16) -> s32 {
    if v >= 67 || v <= -67 {
        token.* = 10;
        extrabits := cast,no_check(EXTRABIT) (absolute_value(v) - 67);
        return (cast(s32) VP9_CAT6_LOW_COST[extrabits & 0xff]) + cast(s32) cat6_high_table[(cast(s32) extrabits) >> 8];
    }
    token.* = vp9_dct_cat_lt_10_value_tokens[v].token;
    return vp9_dct_cat_lt_10_value_cost[v];
}

stack_pop_in_vp9_speed_features :: (stack: *s32, stack_size: s32) -> s32 {
    R := stack[0];
    if 1 < stack_size {
        for idx: 1..stack_size - 1 {
            stack[idx - 1] = stack[idx];
        }
    }

    return R;
}

stack_top_in_vp9_speed_features :: (stack: *s32) -> s32 {
    return stack[0];
}

stack_push_in_vp9_speed_features :: (stack: *s32, new_item: s32, stack_size: s32) {
    idx := stack_size;
    while idx > 0 {
        stack[idx] = stack[idx - 1];
        idx -= 1;
    }
    stack[0] = new_item;
}

stack_init_in_vp9_speed_features :: (stack: *s32, length: s32) {
    if 0 < length {
        for idx: 0..length - 1 {
            stack[idx] = -1;
        }
    }
}

get_ref_cnt_buffer_in_vp9_speed_features :: (cm: *VP9_COMMON, fb_idx: s32) -> *Ref_Cnt_Buffer {
    return ifx fb_idx != -1 then cm.buffer_pool.frame_bufs.data + fb_idx else null;
}

get_ref_frame_bufs_in_vp9_speed_features :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame_bufs: **Ref_Cnt_Buffer) {
    CM := *cpi.common;

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame < 4 {
        ref_frame_buf_idx := get_ref_frame_buf_idx_in_vp9_speed_features(cpi, cast,no_check(s32) ref_frame);
        inter_ref_idx := mv_ref_frame_to_inter_ref_idx_in_vp9_speed_features(ref_frame);
        ref_frame_bufs[inter_ref_idx] = get_ref_cnt_buffer_in_vp9_speed_features(CM, ref_frame_buf_idx);
        ref_frame += 1;
    }
}

get_token_alloc_in_vp9_speed_features :: (mb_rows: s32, mb_cols: s32) -> s64 {
    ALIGNED_MB_ROWS :=
        (mb_rows +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    ALIGNED_MB_COLS :=
        (mb_cols +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    return ((cast,no_check(s64) ALIGNED_MB_ROWS) * cast(s64) ALIGNED_MB_COLS) * cast,no_check(s64) ((cast,no_check(s32) ((16 * 16))) * 3 + 4);
}

allocated_tokens_in_vp9_speed_features :: (tile: Tile_Info) -> s64 {
    tile_mb_rows := (tile.mi_row_end - tile.mi_row_start + 1) >> 1;
    tile_mb_cols := (tile.mi_col_end - tile.mi_col_start + 1) >> 1;

    return get_token_alloc_in_vp9_speed_features(tile_mb_rows, tile_mb_cols);
}

get_start_tok_in_vp9_speed_features :: (
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

    tok.* = cpi.tile_tok[tile_row][tile_col] + get_token_alloc_in_vp9_speed_features(MB_ROW, tile_mb_cols);
}

is_one_pass_svc_in_vp9_speed_features :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if CPI.use_svc != 0 && CPI.oxcf.pass == 0 {
        return 1;
    }
    return 0;
}

is_altref_enabled_in_vp9_speed_features :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if !(CPI.oxcf.mode == cast,no_check(u32) REALTIME && CPI.oxcf.rc_mode == cast,no_check(u32) CBR) &&
        CPI.oxcf.lag_in_frames >= 4 &&
        CPI.oxcf.enable_auto_arf != 0 {
        return 1;
    }
    return 0;
}

set_ref_ptrs_in_vp9_speed_features :: (
    CM: *VP9_COMMON,
    xd: *MACROBLOCKD,
    ref0: MV_REFERENCE_FRAME,
    ref1: MV_REFERENCE_FRAME
) {
    xd.block_refs[0] = CM.frame_refs.data + (ifx ref0 >= 1 then (cast(s32) ref0) - 1 else 0);
    xd.block_refs[1] = CM.frame_refs.data + (ifx ref1 >= 1 then (cast(s32) ref1) - 1 else 0);
}

get_chessboard_index_in_vp9_speed_features :: (FRAME_INDEX: s32) -> s32 {
    return FRAME_INDEX & 0x1;
}

cond_cost_list_in_vp9_speed_features :: (cpi: *VP9_COMP_in_vp9_encoder, cost_list: *s32) -> *s32 {
    return ifx cpi.sf.mv.subpel_search_method != cast,no_check(u32) SUBPEL_TREE then cost_list else null;
}

get_num_vert_units_in_vp9_speed_features :: (tile: Tile_Info, shift: s32) -> s32 {
    num_vert_units := (tile.mi_row_end - tile.mi_row_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_vert_units;
}

get_num_cols_in_vp9_speed_features :: (tile: Tile_Info, shift: s32) -> s32 {
    num_cols := (tile.mi_col_end - tile.mi_col_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_cols;
}

get_level_index_in_vp9_speed_features :: (level: VP9_LEVEL) -> s32 {
    for i: 0..cast(s32) 14 - 1 {
        if level == VP9_LEVEL_DEFS[i].level {
            return i;
        }
    }
    return -1;
}

log_tile_cols_from_picsize_level_in_vp9_speed_features :: (width: u32, height: u32) -> s32 {
    PIC_SIZE := width * height;
    PIC_BREADTH := max(width, height);
    for i: 0..cast(s32) 14 - 1 {
        if VP9_LEVEL_DEFS[i].max_luma_picture_size >= PIC_SIZE && VP9_LEVEL_DEFS[i].max_luma_picture_breadth >= PIC_BREADTH {
            return get_msb_in_vp9_speed_features(cast,no_check(u32) VP9_LEVEL_DEFS[i].max_col_tiles);
        }
    }
    return 2147483647;
}

alloc_frame_mvs_in_vp9_speed_features :: (CM: *VP9_COMMON, buffer_idx: s32) {
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

mv_cost_in_vp9_speed_features :: (mv: *MV, joint_cost: *s32, comp_cost: **s32) -> s32 {
    return joint_cost[vp9_get_mv_joint_in_vp9_speed_features(mv)] + comp_cost[0][mv.row] + comp_cost[1][mv.col];
}

mvsad_err_cost_in_vp9_speed_features :: (x: *MACROBLOCK, mv: *MV, ref: *MV, sad_per_bit: s32) -> s32 {
    diff: MV = ---;
    diff.row = cast,no_check(s16) ((cast(s32) mv.row) - cast(s32) ref.row);
    diff.col = cast,no_check(s16) ((cast(s32) mv.col) - cast(s32) ref.col);
    return cast,no_check(s32) ((((cast,no_check(u32) mv_cost_in_vp9_speed_features(*diff, x.nmvjointsadcost.data, x.nmvsadcost.data)) * cast,no_check(u32) sad_per_bit) + cast,no_check(u32) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9);
}

get_start_mv_sad_in_vp9_speed_features :: (
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
    start_mv_sad += cast,no_check(u32) mvsad_err_cost_in_vp9_speed_features(x, mvp_full, ref_mv_full, sadpb);

    return start_mv_sad;
}

num_4x4_to_edge_in_vp9_speed_features :: (
    plane_4x4_dim: s32,
    mb_to_edge_dim: s32,
    subsampling_dim: s32,
    blk_dim: s32
) -> s32 {
    return plane_4x4_dim + mb_to_edge_dim >> (((5 + subsampling_dim)) & 31) - blk_dim;
}

sum_squares_visible_in_vp9_speed_features :: (
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
        num_4x4_to_edge_in_vp9_speed_features(
            PLANE_4X4_W,
            xd.mb_to_right_edge,
            PD.subsampling_x,
            blk_col
        );
    B4X4S_TO_BOTTOM_EDGE :=
        num_4x4_to_edge_in_vp9_speed_features(
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

do_trellis_opt_in_vp9_speed_features :: (
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
                    sum_squares_visible_in_vp9_speed_features(
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

globals_initialization_state_for_vp9_speed_features: u32;
initialize_globals_for_vp9_speed_features :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_speed_features);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_speed_features, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_speed_features) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_vp9_speed_features =
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
    SUB_PEL_FILTERS_12_in_vp9_speed_features =
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
    FRAME_SCALE_FACTOR_in_vp9_speed_features = s32.[ 16, 24 ];
    RATE_THRESH_MULT_in_vp9_speed_features = float64.[ 1.0, 2.0 ];
    RCF_MULT_in_vp9_speed_features = float64.[ 1.0, 2.0 ];
    K_VP9_REF_FLAG_LIST_in_vp9_speed_features =
        s32.[ 0, cast,no_check(s32) (VP9_LAST_FLAG), cast,no_check(s32) (VP9_GOLD_FLAG), cast,no_check(s32) (VP9_ALT_FLAG) ];
    best_quality_mesh_pattern =
        [4] MESH_PATTERN.[
            MESH_PATTERN.[ MESH_PATTERN.{range = 64, interval = 4}, MESH_PATTERN.{range = 28, interval = 2}, MESH_PATTERN.{range = 15, interval = 1}, MESH_PATTERN.{range = 7, interval = 1} ],
            MESH_PATTERN.[ MESH_PATTERN.{range = 64, interval = 8}, MESH_PATTERN.{range = 28, interval = 4}, MESH_PATTERN.{range = 15, interval = 1}, MESH_PATTERN.{range = 7, interval = 1} ]
        ];
    good_quality_mesh_patterns =
        [4] MESH_PATTERN.[
            MESH_PATTERN.[ MESH_PATTERN.{range = 64, interval = 8}, MESH_PATTERN.{range = 28, interval = 4}, MESH_PATTERN.{range = 15, interval = 1}, MESH_PATTERN.{range = 7, interval = 1} ],
            MESH_PATTERN.[ MESH_PATTERN.{range = 64, interval = 8}, MESH_PATTERN.{range = 14, interval = 2}, MESH_PATTERN.{range = 7, interval = 1}, MESH_PATTERN.{range = 7, interval = 1} ],
            MESH_PATTERN.[ MESH_PATTERN.{range = 64, interval = 16}, MESH_PATTERN.{range = 24, interval = 8}, MESH_PATTERN.{range = 12, interval = 4}, MESH_PATTERN.{range = 7, interval = 1} ]
        ];
    tx_dom_thresholds =
        float64.[
            99.0,
            14.0,
            12.0,
            8.0,
            4.0,
            0.0
        ];
    qopt_thresholds =
        float64.[
            99.0,
            12.0,
            10.0,
            4.0,
            2.0,
            0.0
        ];
    atomic_store(*globals_initialization_state_for_vp9_speed_features, 2);
}

INTRA_Values :: u32;
INTRA_ALL : s32 : 1023;
INTRA_DC : s32 : 1;
INTRA_DC_TM : s32 : 513;
INTRA_DC_H_V : s32 : 7;
INTRA_DC_TM_H_V : s32 : 519;

Unnamed_30163 :: u32;
DISABLE_ALL_INTER_SPLIT : s32 : 31;
DISABLE_ALL_SPLIT : s32 : 63;
DISABLE_COMPOUND_SPLIT : s32 : 24;
LAST_AND_INTRA_SPLIT_ONLY : s32 : 30;

