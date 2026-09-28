// Generated directly from C by cpp_transpiler.
MODE_CHECK_FREQ_MAP_SPLIT2: [12] s32;

MODE_CHECK_FREQ_MAP_SPLIT1: [10] s32;

MODE_CHECK_FREQ_MAP_NEW2: [14] s32;

MODE_CHECK_FREQ_MAP_NEW1: [8] s32;

MODE_CHECK_FREQ_MAP_VHBPRED: [10] s32;

MODE_CHECK_FREQ_MAP_NEAR2: [14] s32;

MODE_CHECK_FREQ_MAP_ZN2: [8] s32;

THRESH_MULT_MAP_SPLIT2: [18] s32;

THRESH_MULT_MAP_SPLIT1: [18] s32;

THRESH_MULT_MAP_NEW2: [14] s32;

THRESH_MULT_MAP_NEW1: [6] s32;

THRESH_MULT_MAP_TM: [14] s32;

THRESH_MULT_MAP_BPRED: [14] s32;

THRESH_MULT_MAP_VHPRED: [12] s32;

THRESH_MULT_MAP_ZNN: [10] s32;

Q_TRANS: [64] s32;

CONST_SOURCE: [16] u8;

INTER_MINQ: [128] u8;

GF_HIGH_MOTION_MINQ: [128] u8;

GF_MID_MOTION_MINQ: [128] u8;

GF_LOW_MOTION_MINQ: [128] u8;

KF_HIGH_MOTION_MINQ: [128] u8;

KF_LOW_MOTION_MINQ: [128] u8;

lock_in_onyx_if: Pthread_Once_T;

clip_pixel_in_onyx_if :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_onyx_if :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_onyx_if :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_onyx_if :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_onyx_if :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_onyx_if(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_onyx_if(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_onyx_if(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_onyx_if :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_onyx_if :: (FILTER: *s16) -> s32 {
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

vp8_sem_wait_in_onyx_if :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_0: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_0; assignment_0; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init_in_onyx_if :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release_in_onyx_if :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

atomic_load_acquire_in_onyx_if :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_atomic_spin_wait_in_onyx_if :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire_in_onyx_if(last_row_current_mb_col) - NSYNC {
    }
}

vp8_set_reference_value_in_onyx_if :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_onyx_if :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_onyx_if :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_onyx_if :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_onyx_if :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_onyx_if :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_onyx_if :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_onyx_if :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_onyx_if :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_onyx_if :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_onyx_if :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_onyx_if :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_onyx_if :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_onyx_if :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_onyx_if :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_onyx_if :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_onyx_if :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_onyx_if :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_onyx_if :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_onyx_if :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_onyx_if :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_onyx_if :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_onyx_if :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_onyx_if :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_onyx_if :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_onyx_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

scale2_ratio_in_onyx_if :: (mode: s32, hr: *s32, hs: *s32) {
    if mode == {
        case VP8E_NORMAL;
            hr.* = 1;
            hs.* = 1;
        case VP8E_FOURFIVE;
            hr.* = 4;
            hs.* = 5;
        case VP8E_THREEFIVE;
            hr.* = 3;
            hs.* = 5;
        case VP8E_ONETWO;
            hr.* = 1;
            hs.* = 2;
        case;
            hr.* = 1;
            hs.* = 1;
    }
}

vp8_create_compressor :: (oxcf: *VP8_CONFIG) -> *VP8_COMP {
    cpi := cast(*VP8_COMP) memalign(32, size_of(VP8_COMP));

    if cpi == null {
        return null;
    }

    cm := *cpi.common;

    fill_memory(cpi, 0, size_of(VP8_COMP));

    if setjmp_2(cm.error.jmp.data) != 0 {
        cpi.common.error.setjmp = 0;
        vp8_remove_compressor(*cpi);
        return null;
    }

    cpi.common.error.setjmp = 1;

    cpi.mb.ss =
        cast(*Search_Site) calloc_2(
            size_of(Search_Site),
            cast,no_check(u64) ((cast,no_check(s32) ((8 * 8))) + 1)
        );

    if cpi.mb.ss == null {
        internal_error(
            *cpi.common.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->mb.ss")
        );
    }

    vp8_create_common(*cpi.common);

    init_config(cpi, oxcf);

    copy_memory(
        cpi.base_skip_false_prob.data,
        VP8CX_BASE_SKIP_FALSE_PROB.data,
        VP8CX_BASE_SKIP_FALSE_PROB.count * size_of(s32)
    );
    cpi.common.current_video_frame = 0;
    cpi.temporal_pattern_counter = 0;
    cpi.temporal_layer_id = -1;
    cpi.kf_overspend_bits = 0;
    cpi.kf_bitrate_adjustment = 0;
    cpi.frames_till_gf_update_due = 0;
    cpi.gf_overspend_bits = 0;
    cpi.non_gf_bitrate_adjustment = 0;
    cpi.prob_last_coded = 128;
    cpi.prob_gf_coded = 128;
    cpi.prob_intra_coded = 63;

    cpi.recent_ref_frame_usage[INTRA_FRAME] = 1;
    cpi.recent_ref_frame_usage[LAST_FRAME] = 1;
    cpi.recent_ref_frame_usage[GOLDEN_FRAME] = 1;
    cpi.recent_ref_frame_usage[ALTREF_FRAME] = 1;

    cpi.common.ref_frame_sign_bias[ALTREF_FRAME] = 1;

    cpi.twopass.gf_decay_rate = 0;
    cpi.baseline_gf_interval = 7;

    cpi.gold_is_last = 0;
    cpi.alt_is_last = 0;
    cpi.gold_is_alt = 0;

    cpi.active_map_enabled = 0;

    cpi.use_roi_static_threshold = 0;

    cpi.mse_source_denoised = 0;

    cpi.cyclic_refresh_mode_enabled =
        cast(s32) (cpi.oxcf.error_resilient_mode != 0 ||
            cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER && cpi.oxcf.mode <= 2);
    cpi.cyclic_refresh_mode_max_mbs_perframe = cpi.common.mb_rows * cpi.common.mb_cols / 7;
    if cpi.oxcf.number_of_layers == 1 {
        cpi.cyclic_refresh_mode_max_mbs_perframe = cpi.common.mb_rows * cpi.common.mb_cols / 20;
    } else if cpi.oxcf.number_of_layers == 2 {
        cpi.cyclic_refresh_mode_max_mbs_perframe = cpi.common.mb_rows * cpi.common.mb_cols / 10;
    }
    cpi.cyclic_refresh_mode_index = 0;
    cpi.cyclic_refresh_q = 32;

    cpi.gf_update_onepass_cbr = 0;
    cpi.gf_noboost_onepass_cbr = 0;
    if cpi.oxcf.error_resilient_mode == 0 && cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER && cpi.oxcf.mode <= 2 {
        cpi.gf_update_onepass_cbr = 1;
        cpi.gf_noboost_onepass_cbr = 1;
        cpi.gf_interval_onepass_cbr =
            ifx cpi.cyclic_refresh_mode_max_mbs_perframe > 0 then 2 *
                (cpi.common.mb_rows * cpi.common.mb_cols) / cpi.cyclic_refresh_mode_max_mbs_perframe else 10;
        cpi.gf_interval_onepass_cbr = clamp_in_onyx_if(cpi.gf_interval_onepass_cbr, 6, 40);
        cpi.baseline_gf_interval = cpi.gf_interval_onepass_cbr;
    }

    if cpi.cyclic_refresh_mode_enabled != 0 {
        cpi.cyclic_refresh_map =
            cast(*s8) calloc_2(
                cast,no_check(u64) (cpi.common.mb_rows * cpi.common.mb_cols),
                1
            );

        if cpi.cyclic_refresh_map == null {
            internal_error(
                *cpi.common.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate cpi->cyclic_refresh_map")
            );
        }
    } else {
        cpi.cyclic_refresh_map = null;
    }

    cpi.skin_map = cast(*u8) calloc_2(cast,no_check(u64) (cm.mb_rows * cm.mb_cols), size_of(u8));

    if cpi.skin_map == null {
        internal_error(
            *cpi.common.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->skin_map")
        );
    }

    cpi.consec_zero_last = cast(*u8) calloc_2(cast,no_check(u64) (cm.mb_rows * cm.mb_cols), 1);

    if cpi.consec_zero_last == null {
        internal_error(
            *cpi.common.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->consec_zero_last")
        );
    }
    cpi.consec_zero_last_mvbias =
        cast(*u8) calloc_2(
            cast,no_check(u64) (cpi.common.mb_rows * cpi.common.mb_cols),
            1
        );

    if cpi.consec_zero_last_mvbias == null {
        internal_error(
            *cpi.common.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->consec_zero_last_mvbias")
        );
    }

    cpi.activity_avg = cast,no_check(u32) ((cast(s32) 90) << 12);

    cpi.frames_since_key = 8;
    cpi.key_frame_frequency = cast,no_check(u32) cpi.oxcf.key_freq;
    cpi.this_key_frame_forced = 0;
    cpi.next_key_frame_forced = 0;

    cpi.source_alt_ref_pending = 0;
    cpi.source_alt_ref_active = 0;
    cpi.common.refresh_alt_ref_frame = 0;

    cpi.force_maxqp = 0;
    cpi.frames_since_last_drop_overshoot = 0;
    cpi.rt_always_update_correction_factor = 0;
    cpi.rt_drop_recode_on_overshoot = 1;

    cpi.b_calculate_psnr = 0;

    cpi.first_time_stamp_ever = 0x7fffffff;

    cpi.frames_till_gf_update_due = 0;
    cpi.key_frame_count = 1;

    cpi.ni_av_qi = cpi.oxcf.worst_allowed_q;
    cpi.ni_tot_qi = 0;
    cpi.ni_frames = 0;
    cpi.total_byte_count = 0;

    cpi.drop_frame = 0;

    cpi.rate_correction_factor = 1.0;
    cpi.key_frame_rate_correction_factor = 1.0;
    cpi.gf_rate_correction_factor = 1.0;
    cpi.twopass.est_max_qcorrection_factor = 1.0;

    for i: 0..cast(s32) 5 - 1 {
        cpi.prior_key_frame_distance[i] = cast,no_check(s32) cpi.output_framerate;
    }

    cpi.output_pkt_list = oxcf.output_pkt_list;

    if cpi.pass == 1 {
        vp8_init_first_pass(cpi);
    } else if cpi.pass == 2 {
        packet_sz: u64 = cast(u64) size_of(FIRSTPASS_STATS);
        packets := cast,no_check(s32) (oxcf.two_pass_stats_in.sz / packet_sz);

        cpi.twopass.stats_in_start = cast(*FIRSTPASS_STATS) oxcf.two_pass_stats_in.buf;
        cpi.twopass.stats_in = cpi.twopass.stats_in_start;
        cpi.twopass.stats_in_end =
            cast(*FIRSTPASS_STATS) (cast(*void) ((cast(*s8) cpi.twopass.stats_in) +
                (cast,no_check(u64) (packets - 1)) * packet_sz));
        vp8_init_second_pass(cpi);
    }

    if cpi.compressor_speed == 2 {
        cpi.avg_encode_time = 0;
        cpi.avg_pick_mode_time = 0;
    }

    vp8_set_speed_features(cpi);

    for i: 0..cast(s32) 20 - 1 {
        cpi.mb.rd_thresh_mult[i] = 128;
    }

    if vp8cx_create_encoder_threads(cpi) != 0 {
        cpi.common.error.setjmp = 0;
        vp8_remove_compressor(*cpi);
        return null;
    }

    cpi.fn_ptr[BLOCK_16X16].sdf = sad16x16_c;
    cpi.fn_ptr[BLOCK_16X16].vf = variance16x16_c;
    cpi.fn_ptr[BLOCK_16X16].svf = sub_pixel_variance16x16_c;
    cpi.fn_ptr[BLOCK_16X16].sdx4df = sad16x16x4d_c;

    cpi.fn_ptr[BLOCK_16X8].sdf = sad16x8_c;
    cpi.fn_ptr[BLOCK_16X8].vf = variance16x8_c;
    cpi.fn_ptr[BLOCK_16X8].svf = sub_pixel_variance16x8_c;
    cpi.fn_ptr[BLOCK_16X8].sdx4df = sad16x8x4d_c;

    cpi.fn_ptr[BLOCK_8X16].sdf = sad8x16_c;
    cpi.fn_ptr[BLOCK_8X16].vf = variance8x16_c;
    cpi.fn_ptr[BLOCK_8X16].svf = sub_pixel_variance8x16_c;
    cpi.fn_ptr[BLOCK_8X16].sdx4df = sad8x16x4d_c;

    cpi.fn_ptr[BLOCK_8X8].sdf = sad8x8_c;
    cpi.fn_ptr[BLOCK_8X8].vf = variance8x8_c;
    cpi.fn_ptr[BLOCK_8X8].svf = sub_pixel_variance8x8_c;
    cpi.fn_ptr[BLOCK_8X8].sdx4df = sad8x8x4d_c;

    cpi.fn_ptr[BLOCK_4X4].sdf = sad4x4_c;
    cpi.fn_ptr[BLOCK_4X4].vf = variance4x4_c;
    cpi.fn_ptr[BLOCK_4X4].svf = sub_pixel_variance4x4_c;
    cpi.fn_ptr[BLOCK_4X4].sdx4df = sad4x4x4d_c;

    cpi.diamond_search_sad = vp8_diamond_search_sad_c;
    cpi.refining_search_sad = vp8_refining_search_sad_c;

    cpi.mb.error_bins[0] = cpi.common.m_bs;

    vp8cx_init_quantizer(cpi);

    vp8_loop_filter_init(cm);

    cpi.mb.mvcost[0] = cpi.rd_costs.mvcosts[0].data + (cast,no_check(s32) (MV_MAX)) + 1;
    cpi.mb.mvcost[1] = cpi.rd_costs.mvcosts[1].data + (cast,no_check(s32) (MV_MAX)) + 1;
    cpi.mb.mvsadcost[0] = cpi.rd_costs.mvsadcosts[0].data + (cast,no_check(s32) (MVFP_MAX)) + 1;
    cpi.mb.mvsadcost[1] = cpi.rd_costs.mvsadcosts[1].data + (cast,no_check(s32) (MVFP_MAX)) + 1;

    cal_mvsadcosts(cpi.mb.mvsadcost.data);

    cpi.mb.mbmode_cost = cpi.rd_costs.mbmode_cost.data;
    cpi.mb.intra_uv_mode_cost = cpi.rd_costs.intra_uv_mode_cost.data;
    cpi.mb.bmode_costs = cpi.rd_costs.bmode_costs.data;
    cpi.mb.inter_bmode_costs = cpi.rd_costs.inter_bmode_costs.data;
    cpi.mb.token_costs = cpi.rd_costs.token_costs.data;

    vp8_setup_block_ptrs(*cpi.mb);
    vp8_setup_block_dptrs(*cpi.mb.e_mbd);

    cpi.common.error.setjmp = 0;

    return cpi;
}

cal_mvsadcosts :: (mvsadcost: **s32) {
    i: s32 = 1;

    mvsadcost[0][0] = 300;
    mvsadcost[1][0] = 300;

    while true {
        {
            z := 256.0 * (2.0 * (c_transpiler_math_log(cast,no_check(float64) (8 * i)) / 0.6931471824645996 + 0.6));
            mvsadcost[0][i] = cast,no_check(s32) z;
            mvsadcost[1][i] = cast,no_check(s32) z;
            mvsadcost[0][-i] = cast,no_check(s32) z;
            mvsadcost[1][-i] = cast,no_check(s32) z;
        }
        if !(c_transpiler_pre_increment(*(i)) <= MVFP_MAX) break;
    }
}

vp8_remove_compressor :: (comp: **VP8_COMP) {
    cpi := comp.*;

    if cpi == null {
        return;
    }

    if cpi != null && cpi.common.current_video_frame > 0 {
        if cpi.pass == 2 {
            vp8_end_second_pass(cpi);
        }
    }

    vp8cx_remove_encoder_threads(cpi);

    vp8_denoiser_free(*cpi.denoiser);

    dealloc_compressor_data(cpi);
    deallocate_memory(cast(*void) cpi.mb.ss);
    deallocate_memory(cast(*void) cpi.tok);
    deallocate_memory(cast(*void) cpi.skin_map);
    deallocate_memory(cast(*void) cpi.cyclic_refresh_map);
    deallocate_memory(cast(*void) cpi.consec_zero_last);
    deallocate_memory(cast(*void) cpi.consec_zero_last_mvbias);

    vp8_remove_common(*cpi.common);
    deallocate_memory(cast(*void) cpi);
    comp.* = null;
}

dealloc_compressor_data :: (cpi: *VP8_COMP) {
    deallocate_memory(cast(*void) cpi.tplist);
    cpi.tplist = null;

    deallocate_memory(cast(*void) cpi.lfmv);
    cpi.lfmv = null;

    deallocate_memory(cast(*void) cpi.lf_ref_frame_sign_bias);
    cpi.lf_ref_frame_sign_bias = null;

    deallocate_memory(cast(*void) cpi.lf_ref_frame);
    cpi.lf_ref_frame = null;

    deallocate_memory(cast(*void) cpi.segmentation_map);
    cpi.segmentation_map = null;

    deallocate_memory(cast(*void) cpi.active_map);
    cpi.active_map = null;

    vp8_de_alloc_frame_buffers(*cpi.common);

    vp8_yv12_de_alloc_frame_buffer(*cpi.pick_lf_lvl_frame);
    vp8_yv12_de_alloc_frame_buffer(*cpi.scaled_source);
    dealloc_raw_frame_buffers(cpi);

    deallocate_memory(cast(*void) cpi.tok);
    cpi.tok = null;

    deallocate_memory(cast(*void) cpi.gf_active_flags);
    cpi.gf_active_flags = null;

    deallocate_memory(cast(*void) cpi.mb_activity_map);
    cpi.mb_activity_map = null;

    deallocate_memory(cast(*void) cpi.mb.pip);
    cpi.mb.pip = null;
}

dealloc_raw_frame_buffers :: (cpi: *VP8_COMP) {
    vp8_yv12_de_alloc_frame_buffer(*cpi.alt_ref_buffer);

    vp8_lookahead_destroy(cpi.lookahead);

    vp8_denoiser_free(*cpi.denoiser);
}

vp8_set_speed_features :: (cpi: *VP8_COMP) {
    sf := *cpi.sf;
    mode := cpi.compressor_speed;
    speed := cpi.speed;

    cm := *cpi.common;
    last_improved_quant := sf.improved_quant;

    i: s32 = 0;
    while i < 20 {
        cpi.mode_check_freq[i] = 0;
        i += 1;
    }

    cpi.mb.mbs_tested_so_far = 0;
    cpi.mb.mbs_zero_last_dot_suppress = 0;

    sf.rd = 1;
    sf.search_method = cast,no_check(SEARCH_METHODS) NSTEP;
    sf.improved_quant = 1;
    sf.improved_dct = 1;
    sf.auto_filter = 1;
    sf.recode_loop = 1;
    sf.quarter_pixel_search = 1;
    sf.half_pixel_search = 1;
    sf.iterative_sub_pixel = 1;
    sf.optimize_coefficients = 1;
    sf.use_fastquant_for_pick = 0;
    sf.no_skip_block4x4_search = 1;

    sf.first_step = 0;
    sf.max_step_search_steps = 8;
    sf.improved_mv_pred = 1;

    i = 0;
    while i < 20 {
        sf.thresh_mult[i] = 0;
        i += 1;
    }

    ref_frames: s32 = 1;
    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_LAST_FRAME) != 0 {
        ref_frames += 1;
    }
    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_GOLD_FRAME) != 0 {
        ref_frames += 1;
    }
    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_ALTR_FRAME) != 0 {
        ref_frames += 1;
    }

    if mode == 0 {
        speed = 0;
    } else if mode == 2 {
        speed = speed + 7;
    } else {
        if speed > 5 {
            speed = 5;
        }
        speed = speed + 1;
    }

    sf.thresh_mult[THR_DC] = 0;
    sf.thresh_mult[THR_NEAR1] = sf.thresh_mult[THR_DC];
    sf.thresh_mult[THR_NEAREST1] = sf.thresh_mult[THR_NEAR1];
    sf.thresh_mult[THR_ZERO1] = sf.thresh_mult[THR_NEAREST1];

    sf.thresh_mult[THR_NEAR3] = speed_map(speed, THRESH_MULT_MAP_ZNN.data);
    sf.thresh_mult[THR_NEAR2] = sf.thresh_mult[THR_NEAR3];
    sf.thresh_mult[THR_NEAREST3] = sf.thresh_mult[THR_NEAR2];
    sf.thresh_mult[THR_NEAREST2] = sf.thresh_mult[THR_NEAREST3];
    sf.thresh_mult[THR_ZERO3] = sf.thresh_mult[THR_NEAREST2];
    sf.thresh_mult[THR_ZERO2] = sf.thresh_mult[THR_ZERO3];

    sf.thresh_mult[THR_H_PRED] = speed_map(speed, THRESH_MULT_MAP_VHPRED.data);
    sf.thresh_mult[THR_V_PRED] = sf.thresh_mult[THR_H_PRED];
    sf.thresh_mult[THR_B_PRED] = speed_map(speed, THRESH_MULT_MAP_BPRED.data);
    sf.thresh_mult[THR_TM] = speed_map(speed, THRESH_MULT_MAP_TM.data);
    sf.thresh_mult[THR_NEW1] = speed_map(speed, THRESH_MULT_MAP_NEW1.data);
    sf.thresh_mult[THR_NEW3] = speed_map(speed, THRESH_MULT_MAP_NEW2.data);
    sf.thresh_mult[THR_NEW2] = sf.thresh_mult[THR_NEW3];
    sf.thresh_mult[THR_SPLIT1] = speed_map(speed, THRESH_MULT_MAP_SPLIT1.data);
    sf.thresh_mult[THR_SPLIT3] = speed_map(speed, THRESH_MULT_MAP_SPLIT2.data);
    sf.thresh_mult[THR_SPLIT2] = sf.thresh_mult[THR_SPLIT3];

    if cpi.speed <= 6 &&
        cpi.oxcf.number_of_layers > 1 &&
        cpi.ref_frame_flags & cast,no_check(s32) (VP8_LAST_FRAME) != 0 &&
        cpi.ref_frame_flags & cast,no_check(s32) (VP8_GOLD_FRAME) != 0 {
        if cpi.closest_reference_frame == cast,no_check(u32) GOLDEN_FRAME {
            sf.thresh_mult[THR_ZERO2] = sf.thresh_mult[THR_ZERO2] >> 3;
            sf.thresh_mult[THR_NEAREST2] = sf.thresh_mult[THR_NEAREST2] >> 3;
            sf.thresh_mult[THR_NEAR2] = sf.thresh_mult[THR_NEAR2] >> 3;
        } else {
            sf.thresh_mult[THR_ZERO2] = sf.thresh_mult[THR_ZERO2] >> 1;
            sf.thresh_mult[THR_NEAREST2] = sf.thresh_mult[THR_NEAREST2] >> 1;
            sf.thresh_mult[THR_NEAR2] = sf.thresh_mult[THR_NEAR2] >> 1;
        }
    }

    cpi.mode_check_freq[THR_DC] = 0;
    cpi.mode_check_freq[THR_TM] = cpi.mode_check_freq[THR_DC];
    cpi.mode_check_freq[THR_NEAR1] = cpi.mode_check_freq[THR_TM];
    cpi.mode_check_freq[THR_NEAREST1] = cpi.mode_check_freq[THR_NEAR1];
    cpi.mode_check_freq[THR_ZERO1] = cpi.mode_check_freq[THR_NEAREST1];

    cpi.mode_check_freq[THR_NEAREST3] = cast,no_check(u32) speed_map(speed, MODE_CHECK_FREQ_MAP_ZN2.data);
    cpi.mode_check_freq[THR_NEAREST2] = cpi.mode_check_freq[THR_NEAREST3];
    cpi.mode_check_freq[THR_ZERO3] = cpi.mode_check_freq[THR_NEAREST2];
    cpi.mode_check_freq[THR_ZERO2] = cpi.mode_check_freq[THR_ZERO3];

    cpi.mode_check_freq[THR_NEAR3] = cast,no_check(u32) speed_map(speed, MODE_CHECK_FREQ_MAP_NEAR2.data);
    cpi.mode_check_freq[THR_NEAR2] = cpi.mode_check_freq[THR_NEAR3];

    cpi.mode_check_freq[THR_B_PRED] = cast,no_check(u32) speed_map(speed, MODE_CHECK_FREQ_MAP_VHBPRED.data);
    cpi.mode_check_freq[THR_H_PRED] = cpi.mode_check_freq[THR_B_PRED];
    cpi.mode_check_freq[THR_V_PRED] = cpi.mode_check_freq[THR_H_PRED];

    speed2 := speed;
    if cpi.speed == 10 && mode == 2 {
        speed2 = cast,no_check(s32) ((9 + 7));
    }
    cpi.mode_check_freq[THR_NEW1] = cast,no_check(u32) speed_map(speed2, MODE_CHECK_FREQ_MAP_NEW1.data);

    cpi.mode_check_freq[THR_NEW3] = cast,no_check(u32) speed_map(speed, MODE_CHECK_FREQ_MAP_NEW2.data);
    cpi.mode_check_freq[THR_NEW2] = cpi.mode_check_freq[THR_NEW3];

    cpi.mode_check_freq[THR_SPLIT1] = cast,no_check(u32) speed_map(speed, MODE_CHECK_FREQ_MAP_SPLIT1.data);
    cpi.mode_check_freq[THR_SPLIT3] = cast,no_check(u32) speed_map(speed, MODE_CHECK_FREQ_MAP_SPLIT2.data);
    cpi.mode_check_freq[THR_SPLIT2] = cpi.mode_check_freq[THR_SPLIT3];
    speed = cpi.speed;
    if mode == {
        case 0;
            sf.first_step = 0;
            sf.max_step_search_steps = 8;
        case 1; #through;
        case 3;
            if speed > 0 {
                sf.optimize_coefficients = 0;
                sf.use_fastquant_for_pick = 1;
                sf.no_skip_block4x4_search = 0;

                sf.first_step = 1;
            }
            if speed > 2 {
                sf.improved_quant = 0;
                sf.improved_dct = 0;

                sf.recode_loop = 2;
            }
            if speed > 3 {
                sf.auto_filter = 1;
                sf.recode_loop = 0;
                sf.rd = 0;
            }
            if speed > 4 {
                sf.auto_filter = 0;
            }
        case 2;
            sf.optimize_coefficients = 0;
            sf.recode_loop = 0;
            sf.auto_filter = 1;
            sf.iterative_sub_pixel = 1;
            sf.search_method = cast,no_check(SEARCH_METHODS) NSTEP;
            if speed > 0 {
                sf.improved_quant = 0;
                sf.improved_dct = 0;

                sf.use_fastquant_for_pick = 1;
                sf.no_skip_block4x4_search = 0;
                sf.first_step = 1;
            }
            if speed > 2 {
                sf.auto_filter = 0;
            }
            if speed > 3 {
                sf.rd = 0;
                sf.auto_filter = 1;
            }
            if speed > 4 {
                sf.auto_filter = 0;
                sf.search_method = cast,no_check(SEARCH_METHODS) HEX;
                sf.iterative_sub_pixel = 0;
            }
            if speed > 6 {
                sum: u32 = 0;
                total_mbs := cast,no_check(u32) cm.m_bs;

                min: s32 = 2000;

                if cpi.oxcf.encode_breakout > 2000 {
                    min = cpi.oxcf.encode_breakout;
                }

                c_transpiler_compound_shr(*(min), (cast(s32) 7), s32, s32);
                if min >= 1024 {
                    min = cast,no_check(s32) ((1024 - 1));
                }

                i = 0;
                while i < min {
                    sum += cast,no_check(u32) cpi.mb.error_bins[i];
                    i += 1;
                }

                total_skip := sum;
                sum = 0;

                while i < 1024 {
                    sum += cast,no_check(u32) cpi.mb.error_bins[i];

                    if 10 * sum >= (cast,no_check(u32) (cpi.speed - 6)) * (total_mbs - total_skip) {
                        break;
                    }
                    i += 1;
                }

                i -= 1;
                thresh := i << 7;

                if thresh < 2000 {
                    thresh = 2000;
                }

                if ref_frames > 1 {
                    sf.thresh_mult[THR_NEW1] = thresh;
                    sf.thresh_mult[THR_NEAREST1] = thresh >> 1;
                    sf.thresh_mult[THR_NEAR1] = thresh >> 1;
                }

                if ref_frames > 2 {
                    sf.thresh_mult[THR_NEW2] = thresh << 1;
                    sf.thresh_mult[THR_NEAREST2] = thresh;
                    sf.thresh_mult[THR_NEAR2] = thresh;
                }

                if ref_frames > 3 {
                    sf.thresh_mult[THR_NEW3] = thresh << 1;
                    sf.thresh_mult[THR_NEAREST3] = thresh;
                    sf.thresh_mult[THR_NEAR3] = thresh;
                }

                sf.improved_mv_pred = 0;
            }
            if speed > 8 {
                sf.quarter_pixel_search = 0;
            }
            if cm.version == 0 {
                cm.filter_type = cast,no_check(LOOPFILTERTYPE) NORMAL_LOOPFILTER;

                if speed >= 14 {
                    cm.filter_type = cast,no_check(LOOPFILTERTYPE) SIMPLE_LOOPFILTER;
                }
            } else {
                cm.filter_type = cast,no_check(LOOPFILTERTYPE) SIMPLE_LOOPFILTER;
            }
            if speed >= 15 {
                sf.half_pixel_search = 0;
            }
            fill_memory(cpi.mb.error_bins.data, 0, cpi.mb.error_bins.count * size_of(s32));
    }

    if cpi.pass == 1 {
        sf.improved_quant = 0;
        sf.optimize_coefficients = 0;
        sf.improved_dct = 0;
    }

    if cpi.sf.search_method == cast,no_check(u32) NSTEP {
        vp8_init3smotion_compensation(*cpi.mb, cm.yv12_fb[cm.lst_fb_idx].y_stride);
    } else if cpi.sf.search_method == cast,no_check(u32) DIAMOND {
        vp8_init_dsmotion_compensation(*cpi.mb, cm.yv12_fb[cm.lst_fb_idx].y_stride);
    }

    if cpi.sf.improved_dct != 0 {
        cpi.mb.short_fdct8x4 = vp8_short_fdct8x4_c;
        cpi.mb.short_fdct4x4 = vp8_short_fdct4x4_c;
    } else {
        cpi.mb.short_fdct8x4 = vp8_short_fdct8x4_c;
        cpi.mb.short_fdct4x4 = vp8_short_fdct4x4_c;
    }

    cpi.mb.short_walsh4x4 = vp8_short_walsh4x4_c;

    if cpi.sf.improved_quant != 0 {
        cpi.mb.quantize_b = vp8_regular_quantize_b_c;
    } else {
        cpi.mb.quantize_b = vp8_fast_quantize_b_c;
    }
    if cpi.sf.improved_quant != last_improved_quant {
        vp8cx_init_quantizer(cpi);
    }

    if cpi.sf.iterative_sub_pixel == 1 {
        cpi.find_fractional_mv_step = vp8_find_best_sub_pixel_step_iteratively;
    } else if cpi.sf.quarter_pixel_search != 0 {
        cpi.find_fractional_mv_step = vp8_find_best_sub_pixel_step;
    } else if cpi.sf.half_pixel_search != 0 {
        cpi.find_fractional_mv_step = vp8_find_best_half_pixel_step;
    } else {
        cpi.find_fractional_mv_step = vp8_skip_fractional_mv_step;
    }

    if cpi.sf.optimize_coefficients == 1 && cpi.pass != 1 {
        cpi.mb.optimize = 1;
    } else {
        cpi.mb.optimize = 0;
    }

    if cpi.common.full_pixel != 0 {
        cpi.find_fractional_mv_step = vp8_skip_fractional_mv_step;
    }
}

speed_map :: (speed: s32, map: *s32) -> s32 {
    res: s32 = ---;

    while true {
        res = (c_transpiler_post_increment(*(map))).*;
        if !(speed >= (c_transpiler_post_increment(*(map))).*) break;
    }
    return res;
}

init_config :: (cpi: *VP8_COMP, oxcf: *VP8_CONFIG) {
    cm := *cpi.common;

    cpi.oxcf = oxcf.*;

    cpi.auto_gold = 1;
    cpi.auto_adjust_gold_quantizer = 1;

    cm.version = oxcf.version;
    vp8_setup_version(cm);

    if oxcf.timebase.num > 0 {
        cpi.framerate = (cast,no_check(float64) oxcf.timebase.den) / cast,no_check(float64) oxcf.timebase.num;
    } else {
        cpi.framerate = 30.0;
    }

    if c_transpiler_float_greater(cpi.framerate, 180.0) {
        cpi.framerate = 30.0;
    }

    cpi.ref_framerate = cpi.framerate;

    cpi.ref_frame_flags =
        ((cast,no_check(s32) (VP8_ALTR_FRAME)) | cast,no_check(s32) (VP8_GOLD_FRAME)) | cast,no_check(s32) (VP8_LAST_FRAME);

    cm.refresh_golden_frame = 0;
    cm.refresh_last_frame = 1;
    cm.refresh_entropy_probs = 1;

    vp8_change_config(cpi, oxcf);

    cpi.active_worst_quality = cpi.oxcf.worst_allowed_q;
    cpi.active_best_quality = cpi.oxcf.best_allowed_q;
    cpi.avg_frame_qindex = cpi.oxcf.worst_allowed_q;

    cpi.buffer_level = cpi.oxcf.starting_buffer_level;
    cpi.bits_off_target = cpi.oxcf.starting_buffer_level;

    cpi.rolling_target_bits = cpi.av_per_frame_bandwidth;
    cpi.rolling_actual_bits = cpi.av_per_frame_bandwidth;
    cpi.long_rolling_target_bits = cpi.av_per_frame_bandwidth;
    cpi.long_rolling_actual_bits = cpi.av_per_frame_bandwidth;

    cpi.total_actual_bits = 0;
    cpi.total_target_vs_actual = 0;

    if cpi.oxcf.number_of_layers > 1 {
        prev_layer_framerate: float64 = 0.0;

        i: u32 = 0;
        while i < cpi.oxcf.number_of_layers {
            vp8_init_temporal_layer_context(cpi, oxcf, cast,no_check(s32) i, prev_layer_framerate);
            prev_layer_framerate = cpi.output_framerate / cpi.oxcf.rate_decimator[i];
            i += 1;
        }
    }

    {
        cpi.fixed_divide[0] = 0;

        if 1 < 512 {
            for i: 1..cast(s32) 512 - 1 {
                cpi.fixed_divide[i] = 0x80000 / i;
            }
        }
    }
}

vp8_init_temporal_layer_context :: (cpi: *VP8_COMP, oxcf: *VP8_CONFIG, LAYER: s32, prev_layer_framerate: float64) {
    lc := cpi.layer_context.data + LAYER;

    lc.framerate = cpi.output_framerate / cpi.oxcf.rate_decimator[LAYER];
    if cpi.oxcf.target_bitrate[LAYER] > cast,no_check(u32) (2147483647 / 1000) {
        lc.target_bandwidth = 2147483647;
    } else {
        lc.target_bandwidth = cast,no_check(s32) (cpi.oxcf.target_bitrate[LAYER] * 1000);
    }

    lc.starting_buffer_level_in_ms = oxcf.starting_buffer_level;
    lc.optimal_buffer_level_in_ms = oxcf.optimal_buffer_level;
    lc.maximum_buffer_size_in_ms = oxcf.maximum_buffer_size;

    lc.starting_buffer_level =
        cast,no_check(s64) rescale(
            cast,no_check(s32) oxcf.starting_buffer_level,
            lc.target_bandwidth,
            1000
        );

    if oxcf.optimal_buffer_level == 0 {
        lc.optimal_buffer_level = cast,no_check(s64) (lc.target_bandwidth / 8);
    } else {
        lc.optimal_buffer_level =
            cast,no_check(s64) rescale(
                cast,no_check(s32) oxcf.optimal_buffer_level,
                lc.target_bandwidth,
                1000
            );
    }

    if oxcf.maximum_buffer_size == 0 {
        lc.maximum_buffer_size = cast,no_check(s64) (lc.target_bandwidth / 8);
    } else {
        lc.maximum_buffer_size =
            cast,no_check(s64) rescale(
                cast,no_check(s32) oxcf.maximum_buffer_size,
                lc.target_bandwidth,
                1000
            );
    }

    if LAYER > 0 {
        lc.avg_frame_size_for_layer =
            cast,no_check(s32) c_transpiler_math_round(
                ((cpi.oxcf.target_bitrate[LAYER] - cpi.oxcf.target_bitrate[LAYER - 1]) * 1000) /
                (lc.framerate - prev_layer_framerate)
            );
    }

    lc.active_worst_quality = cpi.oxcf.worst_allowed_q;
    lc.active_best_quality = cpi.oxcf.best_allowed_q;
    lc.avg_frame_qindex = cpi.oxcf.worst_allowed_q;

    lc.buffer_level = lc.starting_buffer_level;
    lc.bits_off_target = lc.starting_buffer_level;

    lc.total_actual_bits = 0;
    lc.ni_av_qi = 0;
    lc.ni_tot_qi = 0;
    lc.ni_frames = 0;
    lc.rate_correction_factor = 1.0;
    lc.key_frame_rate_correction_factor = 1.0;
    lc.gf_rate_correction_factor = 1.0;
    lc.inter_frame_target = 0;
}

rescale :: (val: s32, num: s32, denom: s32) -> s32 {
    llnum := cast,no_check(s64) num;
    llden := cast,no_check(s64) denom;
    llval := cast,no_check(s64) val;

    result := llval * llnum / llden;
    if result <= 2147483647 {
        return cast,no_check(s32) result;
    } else {
        return 2147483647;
    }
}

vp8_change_config :: (cpi: *VP8_COMP, oxcf: *VP8_CONFIG) {
    cm := *cpi.common;

    if cpi == null {
        return;
    }

    if oxcf == null {
        return;
    }

    if cm.version != oxcf.version {
        cm.version = oxcf.version;
        vp8_setup_version(cm);
    }

    last_w := cpi.oxcf.width;
    last_h := cpi.oxcf.height;
    prev_number_of_layers := cpi.oxcf.number_of_layers;

    cpi.oxcf = oxcf.*;

    if cpi.oxcf.mode == {
        case MODE_REALTIME;
            cpi.pass = 0;
            cpi.compressor_speed = 2;
            if cpi.oxcf.cpu_used < -16 {
                cpi.oxcf.cpu_used = -16;
            }
            if cpi.oxcf.cpu_used > 16 {
                cpi.oxcf.cpu_used = 16;
            }
        case MODE_GOODQUALITY;
            cpi.pass = 0;
            cpi.compressor_speed = 1;
            if cpi.oxcf.cpu_used < -5 {
                cpi.oxcf.cpu_used = -5;
            }
            if cpi.oxcf.cpu_used > 5 {
                cpi.oxcf.cpu_used = 5;
            }
        case MODE_BESTQUALITY;
            cpi.pass = 0;
            cpi.compressor_speed = 0;
        case MODE_FIRSTPASS;
            cpi.pass = 1;
            cpi.compressor_speed = 1;
        case MODE_SECONDPASS;
            cpi.pass = 2;
            cpi.compressor_speed = 1;
            if cpi.oxcf.cpu_used < -5 {
                cpi.oxcf.cpu_used = -5;
            }
            if cpi.oxcf.cpu_used > 5 {
                cpi.oxcf.cpu_used = 5;
            }
        case MODE_SECONDPASS_BEST;
            cpi.pass = 2;
            cpi.compressor_speed = 0;
    }

    if cpi.pass == 0 {
        cpi.auto_worst_q = 1;
    }

    cpi.oxcf.worst_allowed_q = Q_TRANS[oxcf.worst_allowed_q];
    cpi.oxcf.best_allowed_q = Q_TRANS[oxcf.best_allowed_q];
    cpi.oxcf.cq_level = Q_TRANS[cpi.oxcf.cq_level];

    if oxcf.fixed_q >= 0 {
        if oxcf.worst_allowed_q < 0 {
            cpi.oxcf.fixed_q = Q_TRANS[0];
        } else {
            cpi.oxcf.fixed_q = Q_TRANS[oxcf.worst_allowed_q];
        }

        if oxcf.alt_q < 0 {
            cpi.oxcf.alt_q = Q_TRANS[0];
        } else {
            cpi.oxcf.alt_q = Q_TRANS[oxcf.alt_q];
        }

        if oxcf.key_q < 0 {
            cpi.oxcf.key_q = Q_TRANS[0];
        } else {
            cpi.oxcf.key_q = Q_TRANS[oxcf.key_q];
        }

        if oxcf.gold_q < 0 {
            cpi.oxcf.gold_q = Q_TRANS[0];
        } else {
            cpi.oxcf.gold_q = Q_TRANS[oxcf.gold_q];
        }
    }

    cpi.ext_refresh_frame_flags_pending = 0;

    cpi.baseline_gf_interval = ifx cpi.oxcf.alt_freq != 0 then cpi.oxcf.alt_freq else 7;

    if cpi.oxcf.error_resilient_mode == 0 && cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER && cpi.oxcf.mode == MODE_REALTIME {
        cpi.baseline_gf_interval = cpi.gf_interval_onepass_cbr;
    }

    if cpi.oxcf.token_partitions >= 0 && cpi.oxcf.token_partitions <= 3 {
        cm.multi_token_partition = cast,no_check(TOKEN_PARTITION) cpi.oxcf.token_partitions;
    }

    setup_features(cpi);

    if cpi.use_roi_static_threshold == 0 {
        for i: 0..cast(s32) 4 - 1 {
            cpi.segment_encode_breakout[i] = cast,no_check(u32) cpi.oxcf.encode_breakout;
        }
    }

    if cpi.oxcf.fixed_q > 127 {
        cpi.oxcf.fixed_q = 127;
    }

    if cpi.oxcf.end_usage == USAGE_LOCAL_FILE_PLAYBACK {
        cpi.oxcf.starting_buffer_level = 60000;
        cpi.oxcf.optimal_buffer_level = 60000;
        cpi.oxcf.maximum_buffer_size = 240000;
        cpi.oxcf.starting_buffer_level_in_ms = 60000;
        cpi.oxcf.optimal_buffer_level_in_ms = 60000;
        cpi.oxcf.maximum_buffer_size_in_ms = 240000;
    }

    raw_target_rate :=
        (((((cast,no_check(s64) cpi.oxcf.width) * cast(s64) cpi.oxcf.height) * 8) * 3) * cpi.framerate) /
            1000.0;
    if c_transpiler_float_greater(cast,no_check(float64) cpi.oxcf.target_bandwidth, raw_target_rate) {
        cpi.oxcf.target_bandwidth = cast,no_check(u32) raw_target_rate;
    }

    cpi.oxcf.target_bandwidth *= 1000;

    cpi.oxcf.starting_buffer_level =
        cast,no_check(s64) rescale(
            cast,no_check(s32) cpi.oxcf.starting_buffer_level,
            cast,no_check(s32) cpi.oxcf.target_bandwidth,
            1000
        );

    if cpi.oxcf.optimal_buffer_level == 0 {
        cpi.oxcf.optimal_buffer_level = cast,no_check(s64) (cpi.oxcf.target_bandwidth / 8);
    } else {
        cpi.oxcf.optimal_buffer_level =
            cast,no_check(s64) rescale(
                cast,no_check(s32) cpi.oxcf.optimal_buffer_level,
                cast,no_check(s32) cpi.oxcf.target_bandwidth,
                1000
            );
    }

    if cpi.oxcf.maximum_buffer_size == 0 {
        cpi.oxcf.maximum_buffer_size = cast,no_check(s64) (cpi.oxcf.target_bandwidth / 8);
    } else {
        cpi.oxcf.maximum_buffer_size =
            cast,no_check(s64) rescale(
                cast,no_check(s32) cpi.oxcf.maximum_buffer_size,
                cast,no_check(s32) cpi.oxcf.target_bandwidth,
                1000
            );
    }

    if cpi.bits_off_target > cpi.oxcf.maximum_buffer_size {
        cpi.bits_off_target = cpi.oxcf.maximum_buffer_size;
        cpi.buffer_level = cpi.bits_off_target;
    }

    vp8_new_framerate(cpi, cpi.framerate);

    cpi.worst_quality = cpi.oxcf.worst_allowed_q;
    cpi.best_quality = cpi.oxcf.best_allowed_q;

    if cpi.active_worst_quality > cpi.oxcf.worst_allowed_q {
        cpi.active_worst_quality = cpi.oxcf.worst_allowed_q;
    } else if cpi.active_worst_quality < cpi.oxcf.best_allowed_q {
        cpi.active_worst_quality = cpi.oxcf.best_allowed_q;
    }
    if cpi.active_best_quality < cpi.oxcf.best_allowed_q {
        cpi.active_best_quality = cpi.oxcf.best_allowed_q;
    } else if cpi.active_best_quality > cpi.oxcf.worst_allowed_q {
        cpi.active_best_quality = cpi.oxcf.worst_allowed_q;
    }

    cpi.buffered_mode = cast(s32) (cpi.oxcf.optimal_buffer_level > 0);

    cpi.cq_target_quality = cpi.oxcf.cq_level;

    cpi.drop_frames_allowed = cast(s32) (cpi.oxcf.allow_df != 0 && cpi.buffered_mode != 0);

    cpi.target_bandwidth = cast,no_check(s32) cpi.oxcf.target_bandwidth;

    if cpi.oxcf.number_of_layers != prev_number_of_layers {
        if cpi.temporal_layer_id > 0 {
            cpi.temporal_layer_id = 0;
        }
        cpi.temporal_pattern_counter = 0;
        vp8_reset_temporal_layer_change(cpi, oxcf, cast,no_check(s32) prev_number_of_layers);
    }

    if cpi.initial_width == 0 {
        cpi.initial_width = cpi.oxcf.width;
        cpi.initial_height = cpi.oxcf.height;
    }

    cm.width = cpi.oxcf.width;
    cm.height = cpi.oxcf.height;

    if cpi.oxcf.sharpness > 7 {
        cpi.oxcf.sharpness = 7;
    }

    cm.sharpness_level = cpi.oxcf.sharpness;

    if cm.horiz_scale != VP8E_NORMAL || cm.vert_scale != VP8E_NORMAL {
        hr, hs, vr, vs: s32 = ---;

        scale2_ratio_in_onyx_if(cm.horiz_scale, *hr, *hs);
        scale2_ratio_in_onyx_if(cm.vert_scale, *vr, *vs);

        cm.width = (hs - 1 + cpi.oxcf.width * hr) / hs;
        cm.height = (vs - 1 + cpi.oxcf.height * vr) / vs;
    }

    if last_w != cpi.oxcf.width || last_h != cpi.oxcf.height {
        cpi.force_next_frame_intra = 1;
    }

    if (cm.width + 15) & ~(cast(s32) 15) != cm.yv12_fb[cm.lst_fb_idx].y_width ||
        (cm.height + 15) & ~(cast(s32) 15) != cm.yv12_fb[cm.lst_fb_idx].y_height ||
        cm.yv12_fb[cm.lst_fb_idx].y_width == 0 {
        dealloc_raw_frame_buffers(cpi);
        alloc_raw_frame_buffers(cpi);
        vp8_alloc_compressor_data(cpi);
    }

    if cpi.oxcf.fixed_q >= 0 {
        cpi.last_q[0] = cpi.oxcf.fixed_q;
        cpi.last_q[1] = cpi.oxcf.fixed_q;
    }

    cpi.speed = cpi.oxcf.cpu_used;

    if cpi.oxcf.lag_in_frames == 0 {
        cpi.oxcf.allow_lag = 0;
    } else if cpi.oxcf.lag_in_frames > 25 {
        cpi.oxcf.lag_in_frames = ifx ((cast(s32) 0) != 0) then cast(s32) 1 else 25;
    }

    cpi.alt_ref_source = null;
    cpi.is_src_frame_alt_ref = 0;

    if cpi.oxcf.noise_sensitivity != 0 {
        if cpi.denoiser.yv12_mc_running_avg.buffer_alloc == null {
            width := (cpi.oxcf.width + 15) & ~(cast(s32) 15);
            height := (cpi.oxcf.height + 15) & ~(cast(s32) 15);
            if vp8_denoiser_allocate(*cpi.denoiser, width, height, cm.mb_rows, cm.mb_cols, cpi.oxcf.noise_sensitivity) != 0 {
                internal_error(
                    *cpi.common.error,
                    cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                    c_string("Failed to allocate denoiser")
                );
            }
        }
    }
}

vp8_alloc_compressor_data :: (cpi: *VP8_COMP) {
    cm := *cpi.common;

    width := cm.width;
    height := cm.height;

    if vp8_alloc_frame_buffers(cm, width, height) != 0 {
        internal_error(
            *cpi.common.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate frame buffers")
        );
    }

    if vp8_alloc_partition_data(cpi) != 0 {
        internal_error(
            *cpi.common.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate partition data")
        );
    }

    if width & 0xf != 0 {
        width += 16 - width & 0xf;
    }

    if height & 0xf != 0 {
        height += 16 - height & 0xf;
    }

    if vp8_yv12_alloc_frame_buffer(*cpi.pick_lf_lvl_frame, width, height, 32) != 0 {
        internal_error(
            *cpi.common.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate last frame buffer")
        );
    }

    if vp8_yv12_alloc_frame_buffer(*cpi.scaled_source, width, height, 32) != 0 {
        internal_error(
            *cpi.common.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate scaled source buffer")
        );
    }

    deallocate_memory(cast(*void) cpi.tok);

    {
        tokens := cast,no_check(u32) (cm.mb_rows * cm.mb_cols * 24 * 16);

        cpi.tok = cast(*TOKENEXTRA) calloc_2(cast,no_check(u64) tokens, size_of(TOKENEXTRA));

        if cpi.tok == null {
            internal_error(
                *cpi.common.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate cpi->tok")
            );
        }
    }

    cpi.zeromv_count = 0;

    deallocate_memory(cast(*void) cpi.gf_active_flags);
    cpi.gf_active_flags = cast(*u8) calloc_2(size_of(u8), cast,no_check(u64) (cm.mb_rows * cm.mb_cols));

    if cpi.gf_active_flags == null {
        internal_error(
            *cpi.common.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->gf_active_flags")
        );
    }
    cpi.gf_active_count = cm.mb_rows * cm.mb_cols;

    deallocate_memory(cast(*void) cpi.mb_activity_map);
    cpi.mb_activity_map = cast(*u32) calloc_2(size_of(u32), cast,no_check(u64) (cm.mb_rows * cm.mb_cols));

    if cpi.mb_activity_map == null {
        internal_error(
            *cpi.common.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->mb_activity_map")
        );
    }

    deallocate_memory(cast(*void) cpi.lfmv);
    cpi.lfmv =
        cast(*Int_Mv_in_mv) calloc_2(
            cast,no_check(u64) ((cm.mb_rows + 2) * (cm.mb_cols + 2)),
            size_of(Int_Mv_in_mv)
        );

    if cpi.lfmv == null {
        internal_error(
            *cpi.common.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->lfmv")
        );
    }
    deallocate_memory(cast(*void) cpi.lf_ref_frame_sign_bias);
    cpi.lf_ref_frame_sign_bias =
        cast(*s32) calloc_2(
            cast,no_check(u64) ((cm.mb_rows + 2) * (cm.mb_cols + 2)),
            size_of(s32)
        );

    if cpi.lf_ref_frame_sign_bias == null {
        internal_error(
            *cpi.common.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->lf_ref_frame_sign_bias")
        );
    }
    deallocate_memory(cast(*void) cpi.lf_ref_frame);
    cpi.lf_ref_frame =
        cast(*s32) calloc_2(
            cast,no_check(u64) ((cm.mb_rows + 2) * (cm.mb_cols + 2)),
            size_of(s32)
        );

    if cpi.lf_ref_frame == null {
        internal_error(
            *cpi.common.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->lf_ref_frame")
        );
    }

    deallocate_memory(cast(*void) cpi.segmentation_map);
    cpi.segmentation_map = cast(*u8) calloc_2(cast,no_check(u64) (cm.mb_rows * cm.mb_cols), size_of(u8));

    if cpi.segmentation_map == null {
        internal_error(
            *cpi.common.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->segmentation_map")
        );
    }
    cpi.cyclic_refresh_mode_index = 0;
    deallocate_memory(cast(*void) cpi.active_map);
    cpi.active_map = cast(*u8) calloc_2(cast,no_check(u64) (cm.mb_rows * cm.mb_cols), size_of(u8));

    if cpi.active_map == null {
        internal_error(
            *cpi.common.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->active_map")
        );
    }
    fill_memory(cpi.active_map, 1, cast,no_check(u64) (cm.mb_rows * cm.mb_cols));

    if width < 640 {
        cpi.mt_sync_range = 1;
    } else if width <= 1280 {
        cpi.mt_sync_range = 4;
    } else if width <= 2560 {
        cpi.mt_sync_range = 8;
    } else {
        cpi.mt_sync_range = 16;
    }

    deallocate_memory(cast(*void) cpi.tplist);
    cpi.tplist = cast(*TOKENLIST) allocate_memory(size_of(TOKENLIST) * cast,no_check(u64) cm.mb_rows);

    if cpi.tplist == null {
        internal_error(
            *cpi.common.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cpi->tplist")
        );
    }

    if cpi.oxcf.noise_sensitivity > 0 {
        vp8_denoiser_free(*cpi.denoiser);
        if vp8_denoiser_allocate(*cpi.denoiser, width, height, cm.mb_rows, cm.mb_cols, cpi.oxcf.noise_sensitivity) != 0 {
            internal_error(
                *cpi.common.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate denoiser")
            );
        }
    }
}

vp8_alloc_partition_data :: (cpi: *VP8_COMP) -> s32 {
    deallocate_memory(cast(*void) cpi.mb.pip);

    cpi.mb.pip =
        cast(*PARTITION_INFO) calloc_2(
            cast,no_check(u64) ((cpi.common.mb_cols + 1) * (cpi.common.mb_rows + 1)),
            size_of(PARTITION_INFO)
        );
    if cpi.mb.pip == null {
        return 1;
    }

    cpi.mb.pi = cpi.mb.pip + cpi.common.mode_info_stride + 1;

    return 0;
}

alloc_raw_frame_buffers :: (cpi: *VP8_COMP) {
    width := (cpi.oxcf.width + 15) & ~(cast(s32) 15);
    height := (cpi.oxcf.height + 15) & ~(cast(s32) 15);

    cpi.lookahead =
        vp8_lookahead_init(
            cast,no_check(u32) cpi.oxcf.width,
            cast,no_check(u32) cpi.oxcf.height,
            cast,no_check(u32) cpi.oxcf.lag_in_frames
        );
    if cpi.lookahead == null {
        internal_error(
            *cpi.common.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate lag buffers")
        );
    }

    if vp8_yv12_alloc_frame_buffer(*cpi.alt_ref_buffer, width, height, 32) != 0 {
        internal_error(
            *cpi.common.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate altref buffer")
        );
    }
}

vp8_reset_temporal_layer_change :: (cpi: *VP8_COMP, oxcf: *VP8_CONFIG, PREV_NUM_LAYERS: s32) {
    prev_layer_framerate: float64 = 0.0;
    CURR_NUM_LAYERS := cast,no_check(s32) cpi.oxcf.number_of_layers;

    if PREV_NUM_LAYERS == 1 {
        cpi.current_layer = 0;
        vp8_save_layer_context(cpi);
    }
    if 0 < CURR_NUM_LAYERS {
        for i: 0..CURR_NUM_LAYERS - 1 {
            lc := cpi.layer_context.data + i;
            if i >= PREV_NUM_LAYERS {
                vp8_init_temporal_layer_context(cpi, oxcf, i, prev_layer_framerate);
            }

            lc.buffer_level = cpi.oxcf.starting_buffer_level_in_ms * cast(s64) cpi.oxcf.target_bitrate[i];
            lc.bits_off_target = lc.buffer_level;

            if CURR_NUM_LAYERS == 1 {
                lc.target_bandwidth = cast,no_check(s32) cpi.oxcf.target_bandwidth;
                lc.buffer_level = (cpi.oxcf.starting_buffer_level_in_ms * cast(s64) lc.target_bandwidth) / 1000;
                lc.bits_off_target = lc.buffer_level;
                vp8_restore_layer_context(cpi, 0);
            }
            prev_layer_framerate = cpi.output_framerate / cpi.oxcf.rate_decimator[i];
        }
    }
}

vp8_restore_layer_context :: (cpi: *VP8_COMP, LAYER: s32) {
    lc := cpi.layer_context.data + LAYER;

    cpi.current_layer = cast,no_check(u32) LAYER;
    cpi.target_bandwidth = lc.target_bandwidth;
    cpi.oxcf.target_bandwidth = cast,no_check(u32) lc.target_bandwidth;
    cpi.oxcf.starting_buffer_level = lc.starting_buffer_level;
    cpi.oxcf.optimal_buffer_level = lc.optimal_buffer_level;
    cpi.oxcf.maximum_buffer_size = lc.maximum_buffer_size;
    cpi.oxcf.starting_buffer_level_in_ms = lc.starting_buffer_level_in_ms;
    cpi.oxcf.optimal_buffer_level_in_ms = lc.optimal_buffer_level_in_ms;
    cpi.oxcf.maximum_buffer_size_in_ms = lc.maximum_buffer_size_in_ms;
    cpi.buffer_level = lc.buffer_level;
    cpi.bits_off_target = lc.bits_off_target;
    cpi.total_actual_bits = lc.total_actual_bits;
    cpi.active_worst_quality = lc.active_worst_quality;
    cpi.active_best_quality = lc.active_best_quality;
    cpi.ni_av_qi = lc.ni_av_qi;
    cpi.ni_tot_qi = lc.ni_tot_qi;
    cpi.ni_frames = lc.ni_frames;
    cpi.avg_frame_qindex = lc.avg_frame_qindex;
    cpi.rate_correction_factor = lc.rate_correction_factor;
    cpi.key_frame_rate_correction_factor = lc.key_frame_rate_correction_factor;
    cpi.gf_rate_correction_factor = lc.gf_rate_correction_factor;
    cpi.mb.zbin_over_quant = lc.zbin_over_quant;
    cpi.inter_frame_target = lc.inter_frame_target;
    cpi.total_byte_count = lc.total_byte_count;
    cpi.common.filter_level = lc.filter_level;
    cpi.frames_since_last_drop_overshoot = lc.frames_since_last_drop_overshoot;
    cpi.force_maxqp = lc.force_maxqp;
    cpi.last_frame_percent_intra = lc.last_frame_percent_intra;
    cpi.last_q[0] = lc.last_q[0];
    cpi.last_q[1] = lc.last_q[1];

    copy_memory(
        cpi.mb.count_mb_ref_frame_usage.data,
        lc.count_mb_ref_frame_usage.data,
        cpi.mb.count_mb_ref_frame_usage.count * size_of(s32)
    );
}

vp8_save_layer_context :: (cpi: *VP8_COMP) {
    lc := cpi.layer_context.data + cpi.current_layer;

    lc.target_bandwidth = cpi.target_bandwidth;
    lc.starting_buffer_level = cpi.oxcf.starting_buffer_level;
    lc.optimal_buffer_level = cpi.oxcf.optimal_buffer_level;
    lc.maximum_buffer_size = cpi.oxcf.maximum_buffer_size;
    lc.starting_buffer_level_in_ms = cpi.oxcf.starting_buffer_level_in_ms;
    lc.optimal_buffer_level_in_ms = cpi.oxcf.optimal_buffer_level_in_ms;
    lc.maximum_buffer_size_in_ms = cpi.oxcf.maximum_buffer_size_in_ms;
    lc.buffer_level = cpi.buffer_level;
    lc.bits_off_target = cpi.bits_off_target;
    lc.total_actual_bits = cpi.total_actual_bits;
    lc.worst_quality = cpi.worst_quality;
    lc.active_worst_quality = cpi.active_worst_quality;
    lc.best_quality = cpi.best_quality;
    lc.active_best_quality = cpi.active_best_quality;
    lc.ni_av_qi = cpi.ni_av_qi;
    lc.ni_tot_qi = cpi.ni_tot_qi;
    lc.ni_frames = cpi.ni_frames;
    lc.avg_frame_qindex = cpi.avg_frame_qindex;
    lc.rate_correction_factor = cpi.rate_correction_factor;
    lc.key_frame_rate_correction_factor = cpi.key_frame_rate_correction_factor;
    lc.gf_rate_correction_factor = cpi.gf_rate_correction_factor;
    lc.zbin_over_quant = cpi.mb.zbin_over_quant;
    lc.inter_frame_target = cpi.inter_frame_target;
    lc.total_byte_count = cpi.total_byte_count;
    lc.filter_level = cpi.common.filter_level;
    lc.frames_since_last_drop_overshoot = cpi.frames_since_last_drop_overshoot;
    lc.force_maxqp = cpi.force_maxqp;
    lc.last_frame_percent_intra = cpi.last_frame_percent_intra;
    lc.last_q[0] = cpi.last_q[0];
    lc.last_q[1] = cpi.last_q[1];

    copy_memory(
        lc.count_mb_ref_frame_usage.data,
        cpi.mb.count_mb_ref_frame_usage.data,
        cpi.mb.count_mb_ref_frame_usage.count * size_of(s32)
    );
}

vp8_new_framerate :: (cpi: *VP8_COMP, framerate: float64) {
    framerate = clamp_framerate(framerate);
    cpi.framerate = framerate;
    cpi.output_framerate = framerate;
    PER_FRAME_BANDWIDTH := c_transpiler_math_round(cpi.oxcf.target_bandwidth / cpi.output_framerate);
    cpi.per_frame_bandwidth =
        cast,no_check(s32) ((ifx c_transpiler_float_less(PER_FRAME_BANDWIDTH, 2147483647.0) then PER_FRAME_BANDWIDTH else 2147483647.0));
    cpi.av_per_frame_bandwidth = cpi.per_frame_bandwidth;
    VBR_MIN_BITS :=
        ((cast,no_check(s64) cpi.av_per_frame_bandwidth) * cast(s64) cpi.oxcf.two_pass_vbrmin_section) /
            100;
    cpi.min_frame_bandwidth = cast,no_check(s32) ((ifx VBR_MIN_BITS < 2147483647 then VBR_MIN_BITS else 2147483647));

    cpi.max_gf_interval = (cast,no_check(s32) (cpi.output_framerate / 2.0)) + 2;

    if cpi.max_gf_interval < 12 {
        cpi.max_gf_interval = 12;
    }

    cpi.twopass.static_scene_max_gf_interval = cast,no_check(s32) (cpi.key_frame_frequency >> 1);

    if cpi.oxcf.play_alternate != 0 && cpi.oxcf.lag_in_frames != 0 {
        if cpi.max_gf_interval > cpi.oxcf.lag_in_frames - 1 {
            cpi.max_gf_interval = cpi.oxcf.lag_in_frames - 1;
        }

        if cpi.twopass.static_scene_max_gf_interval > cpi.oxcf.lag_in_frames - 1 {
            cpi.twopass.static_scene_max_gf_interval = cpi.oxcf.lag_in_frames - 1;
        }
    }

    if cpi.max_gf_interval > cpi.twopass.static_scene_max_gf_interval {
        cpi.max_gf_interval = cpi.twopass.static_scene_max_gf_interval;
    }
}

clamp_framerate :: (framerate: float64) -> float64 {
    if c_transpiler_float_less(framerate, 0.1) {
        return 30.0;
    } else {
        return framerate;
    }
}

setup_features :: (cpi: *VP8_COMP) {
    if cpi.mb.e_mbd.segmentation_enabled != 0 {
        cpi.mb.e_mbd.update_mb_segmentation_map = 1;
        cpi.mb.e_mbd.update_mb_segmentation_data = 1;
    } else {
        cpi.mb.e_mbd.update_mb_segmentation_map = 0;
        cpi.mb.e_mbd.update_mb_segmentation_data = 0;
    }

    cpi.mb.e_mbd.mode_ref_lf_delta_enabled = 0;
    cpi.mb.e_mbd.mode_ref_lf_delta_update = 0;
    fill_memory(cpi.mb.e_mbd.ref_lf_deltas.data, 0, cpi.mb.e_mbd.ref_lf_deltas.count);
    fill_memory(cpi.mb.e_mbd.mode_lf_deltas.data, 0, cpi.mb.e_mbd.mode_lf_deltas.count);
    fill_memory(cpi.mb.e_mbd.last_ref_lf_deltas.data, 0, cpi.mb.e_mbd.ref_lf_deltas.count);
    fill_memory(cpi.mb.e_mbd.last_mode_lf_deltas.data, 0, cpi.mb.e_mbd.mode_lf_deltas.count);

    set_default_lf_deltas(cpi);
}

set_default_lf_deltas :: (cpi: *VP8_COMP) {
    cpi.mb.e_mbd.mode_ref_lf_delta_enabled = 1;
    cpi.mb.e_mbd.mode_ref_lf_delta_update = 1;

    fill_memory(cpi.mb.e_mbd.ref_lf_deltas.data, 0, cpi.mb.e_mbd.ref_lf_deltas.count);
    fill_memory(cpi.mb.e_mbd.mode_lf_deltas.data, 0, cpi.mb.e_mbd.mode_lf_deltas.count);

    cpi.mb.e_mbd.ref_lf_deltas[INTRA_FRAME] = 2;
    cpi.mb.e_mbd.ref_lf_deltas[LAST_FRAME] = 0;
    cpi.mb.e_mbd.ref_lf_deltas[GOLDEN_FRAME] = -2;
    cpi.mb.e_mbd.ref_lf_deltas[ALTREF_FRAME] = -2;

    cpi.mb.e_mbd.mode_lf_deltas[0] = 4;

    if cpi.oxcf.mode == MODE_REALTIME {
        cpi.mb.e_mbd.mode_lf_deltas[1] = -12;
    } else {
        cpi.mb.e_mbd.mode_lf_deltas[1] = -2;
    }

    cpi.mb.e_mbd.mode_lf_deltas[2] = 2;
    cpi.mb.e_mbd.mode_lf_deltas[3] = 4;
}

vp8_receive_raw_frame :: (
    cpi: *VP8_COMP,
    frame_flags: u32,
    sd: *YV12_BUFFER_CONFIG,
    time_stamp: s64,
    end_time: s64
) -> s32 {
    res: s32 = 0;

    if sd.y_width != cpi.oxcf.width || sd.y_height != cpi.oxcf.height {
        dealloc_raw_frame_buffers(cpi);
        alloc_raw_frame_buffers(cpi);
    }

    if vp8_lookahead_push(
        cpi.lookahead,
        sd,
        time_stamp,
        end_time,
        frame_flags,
        (ifx cpi.active_map_enabled != 0 then cpi.active_map else null)
    ) != 0 {
        res = -1;
    }

    return res;
}

vp8_get_compressed_data :: (
    cpi: *VP8_COMP,
    frame_flags: *u32,
    size: *u64,
    dest: *u8,
    dest_end: *u8,
    time_stamp: *s64,
    time_end: *s64,
    flush: s32
) -> s32 {
    ticktimer: Usec_Timer = ---;

    force_src_buffer: *YV12_BUFFER_CONFIG = null;

    if cpi == null {
        return -1;
    }

    cm := *cpi.common;

    cpi.source_2 = null;

    if cpi.oxcf.error_resilient_mode == 0 && cpi.oxcf.play_alternate != 0 && cpi.source_alt_ref_pending != 0 {
        if (((ifx true { assignment_1: *Lookahead_Entry = cast,no_check(*Lookahead_Entry) (vp8_lookahead_peek(cpi.lookahead, cast,no_check(u32) cpi.frames_till_gf_update_due, 1)); (cpi.source_2) = assignment_1; assignment_1; })) != null) {
            cpi.alt_ref_source = cpi.source_2;
            if cpi.oxcf.arnr_max_frames > 0 {
                vp8_temporal_filter_prepare_c(cpi, cpi.frames_till_gf_update_due);
                force_src_buffer = *cpi.alt_ref_buffer;
            }
            cpi.frames_till_alt_ref_frame = cast,no_check(u32) cpi.frames_till_gf_update_due;
            cm.refresh_alt_ref_frame = 1;
            cm.refresh_golden_frame = 0;
            cm.refresh_last_frame = 0;
            cm.show_frame = 0;

            cpi.source_alt_ref_pending = 0;
            cpi.is_src_frame_alt_ref = 0;
        }
    }

    if cpi.source_2 == null {
        if cpi.pass == 1 && cm.current_video_frame > 0 {
            if (ifx true { assignment_2: *Lookahead_Entry = cast,no_check(*Lookahead_Entry) (vp8_lookahead_peek(cpi.lookahead, 1, -1)); (cpi.last_source) = assignment_2; assignment_2; }) == null {
                return -1;
            }
        }

        if (((ifx true { assignment_3: *Lookahead_Entry = cast,no_check(*Lookahead_Entry) (vp8_lookahead_pop(cpi.lookahead, flush)); (cpi.source_2) = assignment_3; assignment_3; })) != null) {
            cm.show_frame = 1;

            cpi.is_src_frame_alt_ref = cast(s32) (cpi.alt_ref_source != null && cpi.source_2 == cpi.alt_ref_source);

            if cpi.is_src_frame_alt_ref != 0 {
                cpi.alt_ref_source = null;
            }
        }
    }

    if cpi.source_2 != null {
        cpi.source = ifx force_src_buffer != null then force_src_buffer else *cpi.source_2.img;
        cpi.un_scaled_source = cpi.source;
        time_stamp.* = cpi.source_2.ts_start;
        time_end.* = cpi.source_2.ts_end;
        frame_flags.* = cpi.source_2.flags;

        if cpi.pass == 1 && cm.current_video_frame > 0 {
            cpi.last_frame_unscaled_source = *cpi.last_source.img;
        }
    } else {
        size.* = 0;

        if flush != 0 && cpi.pass == 1 && cpi.twopass.first_pass_done == 0 {
            vp8_end_first_pass(cpi);
            cpi.twopass.first_pass_done = 1;
        }

        return -1;
    }

    if cpi.source_2.ts_start < cpi.first_time_stamp_ever {
        cpi.first_time_stamp_ever = cpi.source_2.ts_start;
        cpi.last_end_time_stamp_seen = cpi.source_2.ts_start;
    }

    if cm.show_frame != 0 {
        this_duration: s64 = ---;
        step: s32 = 0;

        if cpi.source_2.ts_start == cpi.first_time_stamp_ever {
            this_duration = cpi.source_2.ts_end - cpi.source_2.ts_start;
            step = 1;
        } else {
            this_duration = cpi.source_2.ts_end - cpi.last_end_time_stamp_seen;
            last_duration := cpi.last_end_time_stamp_seen - cpi.last_time_stamp_seen;

            this_duration =
                ifx this_duration < 9223372036854775807 /
                    10 then this_duration else cast,no_check(s64) ((9223372036854775807 / 10));

            if last_duration != 0 {
                step = cast,no_check(s32) (((this_duration - last_duration) * 10) / last_duration);
            }
        }

        if this_duration != 0 {
            if step != 0 {
                cpi.ref_framerate = 10000000.0 / cast,no_check(float64) this_duration;
            } else {
                interval: float64 = ---;

                interval = cast,no_check(float64) (cpi.source_2.ts_end - cpi.first_time_stamp_ever);
                if c_transpiler_float_greater(interval, 10000000.0) {
                    interval = 10000000.0;
                }

                avg_duration := 10000000.0 / cpi.ref_framerate;
                avg_duration *= interval - avg_duration + this_duration;
                avg_duration /= interval;

                cpi.ref_framerate = 10000000.0 / avg_duration;
            }

            cpi.ref_framerate = clamp_framerate(cpi.ref_framerate);
            if cpi.oxcf.number_of_layers > 1 {
                i: u32 = 0;
                while i < cpi.oxcf.number_of_layers && i < 5 {
                    lc := cpi.layer_context.data + i;
                    lc.framerate = cpi.ref_framerate / cpi.oxcf.rate_decimator[i];
                    i += 1;
                }
            } else {
                vp8_new_framerate(cpi, cpi.ref_framerate);
            }
        }

        cpi.last_time_stamp_seen = cpi.source_2.ts_start;
        cpi.last_end_time_stamp_seen = cpi.source_2.ts_end;
    }

    if cpi.oxcf.number_of_layers > 1 {
        vp8_update_layer_contexts(cpi);

        layer: s32 = ifx cpi.temporal_layer_id >= 0
            then cpi.temporal_layer_id
            else cast,no_check(s32) cpi.oxcf.layer_id[cpi.temporal_pattern_counter % cpi.oxcf.periodicity];
        vp8_restore_layer_context(cpi, layer);
        vp8_new_framerate(cpi, cpi.layer_context[layer].framerate);
    }

    if cpi.compressor_speed == 2 {
        usec_timer_start_in_onyx_if(*ticktimer);
    }

    cpi.lf_zeromv_pct = cpi.zeromv_count * 100 / cm.m_bs;

    size.* = 0;

    cm.frame_type = cast,no_check(FRAME_TYPE_in_alloccommon) INTER_FRAME_in_alloccommon;
    cm.frame_flags = cast,no_check(s32) frame_flags.*;

    {
        i: s32 = 0;
        while i < 4 {
            if cm.yv12_fb[i].flags == 0 {
                cm.new_fb_idx = i;
                break;
            }
            i += 1;
        }
    }
    if cpi.pass == {
        case 1;
            pass1_encode(cpi);
        case 2;
            pass2_encode(cpi, size, dest, dest_end, frame_flags);
        case;
            encode_frame_to_data_rate(cpi, size, dest, dest_end, frame_flags);
    }

    if cpi.compressor_speed == 2 {
        usec_timer_mark_in_onyx_if(*ticktimer);

        duration := cast,no_check(u32) (cast,no_check(s32) usec_timer_elapsed_in_onyx_if(*ticktimer));
        duration2 := cast,no_check(u32) ((cast,no_check(float64) duration) / 2.0);

        if cm.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
            if cpi.avg_encode_time == 0 {
                cpi.avg_encode_time = cast,no_check(s32) duration;
            } else {
                cpi.avg_encode_time =
                    cast,no_check(s32) (((cast,no_check(u32) (7 * cpi.avg_encode_time)) +
                        duration) >> 3);
            }
        }

        if duration2 != 0 {
            if cpi.avg_pick_mode_time == 0 {
                cpi.avg_pick_mode_time = cast,no_check(s32) duration2;
            } else {
                cpi.avg_pick_mode_time =
                    cast,no_check(s32) (((cast,no_check(u32) (7 * cpi.avg_pick_mode_time)) +
                        duration2) >> 3);
            }
        }
    }

    if cm.refresh_entropy_probs == 0 {
        cm.fc = cm.lfc;
    }

    if cm.refresh_alt_ref_frame != 0 {
        cpi.lfc_a = cm.fc;
    }

    if cm.refresh_golden_frame != 0 {
        cpi.lfc_g = cm.fc;
    }

    if cm.refresh_last_frame != 0 {
        cpi.lfc_n = cm.fc;
    }

    if size.* > 0 {
        cpi.droppable = cast(s32) (frame_is_reference(cpi) == 0);

        cm.refresh_entropy_probs = 1;
        cm.refresh_alt_ref_frame = 0;
        cm.refresh_golden_frame = 0;
        cm.refresh_last_frame = 1;
        cm.frame_type = cast,no_check(FRAME_TYPE_in_alloccommon) INTER_FRAME_in_alloccommon;
    }

    if cpi.oxcf.number_of_layers > 1 {
        vp8_save_layer_context(cpi);
    }

    if atomic_load_acquire_in_onyx_if(*cpi.b_multi_threaded) != 0 && cpi.b_lpf_running != 0 {
        vp8_sem_wait_in_onyx_if(*cpi.h_event_end_lpf);
        cpi.b_lpf_running = 0;
    }

    if cpi.b_calculate_psnr != 0 && cpi.pass != 1 && cm.show_frame != 0 {
        generate_psnr_packet(cpi);
    }

    return 0;
}

generate_psnr_packet :: (cpi: *VP8_COMP) {
    orig := cpi.source;
    recon := cpi.common.frame_to_show;
    pkt: Codec_Cx_Pkt = ---;

    width := cast,no_check(u32) cpi.common.width;
    height := cast,no_check(u32) cpi.common.height;

    pkt.kind = cast,no_check(Codec_Cx_Pkt_Kind) CODEC_PSNR_PKT;
    sse := calc_plane_error(orig.y_buffer, orig.y_stride, recon.y_buffer, recon.y_stride, width, height);
    pkt.data.psnr.sse[0] = sse;
    pkt.data.psnr.sse[1] = sse;
    pkt.data.psnr.samples[0] = width * height;
    pkt.data.psnr.samples[1] = width * height;

    width = (width + 1) / 2;
    height = (height + 1) / 2;

    sse = calc_plane_error(orig.u_buffer, orig.uv_stride, recon.u_buffer, recon.uv_stride, width, height);
    pkt.data.psnr.sse[0] += sse;
    pkt.data.psnr.sse[2] = sse;
    pkt.data.psnr.samples[0] += width * height;
    pkt.data.psnr.samples[2] = width * height;

    sse = calc_plane_error(orig.v_buffer, orig.uv_stride, recon.v_buffer, recon.uv_stride, width, height);
    pkt.data.psnr.sse[0] += sse;
    pkt.data.psnr.sse[3] = sse;
    pkt.data.psnr.samples[0] += width * height;
    pkt.data.psnr.samples[3] = width * height;

    for i: 0..cast(s32) 4 - 1 {
        pkt.data.psnr.psnr[i] =
            sse_to_psnr(
                cast,no_check(float64) pkt.data.psnr.samples[i],
                255.0,
                cast,no_check(float64) pkt.data.psnr.sse[i]
            );
    }

    codec_pkt_list_add(cpi.output_pkt_list, *pkt);
}

calc_plane_error :: (orig: *u8, orig_stride: s32, recon: *u8, recon_stride: s32, cols: u32, rows: u32) -> u64 {
    col: u32 = ---;
    total_sse: u64 = 0;
    diff: s32 = ---;

    row: u32 = 0;
    while (row + 16) <= rows {
        col = 0;
        while (col + 16) <= cols {
            sse: u32 = ---;

            mse16x16_c(orig + col, orig_stride, recon + col, recon_stride, *sse);
            total_sse += cast,no_check(u64) sse;
            col += 16;
        }

        if col < cols {
            border_col: u32 = ---;
            border_orig := orig;
            border_recon := recon;

            for border_row: 0..cast(u32) 16 - 1 {
                border_col = col;
                while border_col < cols {
                    diff = (cast(s32) border_orig[border_col]) - cast(s32) border_recon[border_col];
                    total_sse += cast,no_check(u64) (diff * diff);
                    border_col += 1;
                }

                border_orig += orig_stride;
                border_recon += recon_stride;
            }
        }

        orig += orig_stride * 16;
        recon += recon_stride * 16;
        row += 16;
    }

    while row < rows {
        col = 0;
        while col < cols {
            diff = (cast(s32) orig[col]) - cast(s32) recon[col];
            total_sse += cast,no_check(u64) (diff * diff);
            col += 1;
        }

        orig += orig_stride;
        recon += recon_stride;
        row += 1;
    }

    return total_sse;
}

frame_is_reference :: (cpi: *VP8_COMP) -> s32 {
    cm := *cpi.common;
    xd := *cpi.mb.e_mbd;

    if cm.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon ||
        cm.refresh_last_frame != 0 ||
        cm.refresh_golden_frame != 0 ||
        cm.refresh_alt_ref_frame != 0 ||
        cm.copy_buffer_to_gf != 0 ||
        cm.copy_buffer_to_arf != 0 ||
        cm.refresh_entropy_probs != 0 ||
        xd.mode_ref_lf_delta_update != 0 ||
        xd.update_mb_segmentation_map != 0 ||
        xd.update_mb_segmentation_data != 0 {
        return 1;
    }
    return 0;
}

usec_timer_elapsed_in_onyx_if :: (t: *Usec_Timer) -> s64 {
    diff: C_Transpiler_POSIX.timespec = ---;

    assignment_4: Time_T = (t.end.tv_sec - t.begin.tv_sec);
    (diff.tv_sec) = assignment_4;

    assignment_5: Syscall_Slong_T = (t.end.tv_nsec - t.begin.tv_nsec);
    (diff.tv_nsec) = assignment_5;

    if diff.tv_nsec < 0 {
        diff.tv_sec -= 1;

        c_transpiler_compound_add(*(diff.tv_nsec), (cast(Syscall_Slong_T) 1000000000), Syscall_Slong_T, Syscall_Slong_T);
    }
    return (diff.tv_sec * 1000000) + diff.tv_nsec / 1000;
}

usec_timer_mark_in_onyx_if :: (t: *Usec_Timer) {
    clock_gettime(4, *t.end);
}

encode_frame_to_data_rate :: (cpi: *VP8_COMP, size: *u64, dest: *u8, dest_end: *u8, frame_flags: *u32) {
    q: s32 = ---;
    frame_over_shoot_limit: s32 = ---;
    frame_under_shoot_limit: s32 = ---;
    loop: s32 = ---;
    cm: *VP8_COMMON = ---;
    active_worst_qchanged: s32 = ---;
    q_low: s32 = ---;
    q_high: s32 = ---;
    zbin_oq_high: s32 = ---;
    zbin_oq_low: s32 = ---;
    top_index: s32 = ---;
    bottom_index: s32 = ---;
    overshoot_seen: s32 = ---;
    undershoot_seen: s32 = ---;
    PER_FRAME_BANDWIDTH: float64 = ---;
    i: s32 = ---;
    closest_ref: MV_REFERENCE_FRAME_in_alloccommon = ---;
    ref_frame_type: Ref_Frame_Type_T = ---;
    i_2: s32 = ---;
    adjustment: s32 = ---;
    buff_lvl_step: s32 = ---;
    fraction: s32 = ---;
    min_qadjustment: s32 = ---;
    disable_cr_gf: s32 = ---;
    over_size_percent: s32 = ---;
    last_q: s32 = ---;
    kf_err: s32 = ---;
    last_q_2: s32 = ---;
    retries: s32 = ---;
    mb_row: s32 = ---;
    mb_col: s32 = ---;
    tmp: *MODE_INFO_in_blockd = ---;
    mb_row_2: s32 = ---;
    mb_col_2: s32 = ---;
    tmp_2: *MODE_INFO_in_blockd = ---;
    i_3: u32 = ---;
    i_4: u32 = ---;
    lc: *LAYER_CONTEXT = ---;
    bits_off_for_this_layer: s32 = ---;
    code_block_to_execute: s64 = 465;
    while c_transpiler_dispatch := true {
        if code_block_to_execute < 0 break;
        if code_block_to_execute == {
            case 8; {
                cpi.mb.e_mbd.update_mb_segmentation_map = 0;
                cpi.mb.e_mbd.update_mb_segmentation_data = 0;
                cpi.mb.e_mbd.mode_ref_lf_delta_update = 0;
                if cm.show_frame != 0 {
                    cm.current_video_frame += 1;
                    cpi.frames_since_key += 1;
                    cpi.temporal_pattern_counter += 1;
                    break c_transpiler_dispatch;
                } else {
                    break c_transpiler_dispatch;
                }
            }
            case 14; {
                if cm.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
                    frame_flags.* = cast,no_check(u32) (cm.frame_flags | cast,no_check(s32) (FRAMEFLAGS_KEY));
                    cm.frame_type = cast,no_check(FRAME_TYPE_in_alloccommon) INTER_FRAME_in_alloccommon;
                    cpi.last_frame_percent_intra = 100;
                    code_block_to_execute = 8;
                    continue c_transpiler_dispatch;
                } else {
                    frame_flags.* = cast,no_check(u32) (cm.frame_flags & cast,no_check(s32) (~(FRAMEFLAGS_KEY)));
                    cpi.last_frame_percent_intra = cpi.this_frame_percent_intra;
                    code_block_to_execute = 8;
                    continue c_transpiler_dispatch;
                }
            }
            case 18; {
                if cpi.oxcf.error_resilient_mode == 0 {
                    if cpi.oxcf.play_alternate != 0 && cm.refresh_alt_ref_frame != 0 && cm.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
                        update_alt_ref_frame_stats(cpi);
                        code_block_to_execute = 14;
                        continue c_transpiler_dispatch;
                    } else {
                        update_golden_frame_stats(cpi);
                        code_block_to_execute = 14;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 14;
                    continue c_transpiler_dispatch;
                }
            }
            case 20; {
                if cpi.gold_is_alt != 0 {
                    cpi.ref_frame_flags &= cast,no_check(s32) (~(VP8_ALTR_FRAME));
                    code_block_to_execute = 18;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 18;
                    continue c_transpiler_dispatch;
                }
            }
            case 22; {
                if cpi.alt_is_last != 0 {
                    cpi.ref_frame_flags &= cast,no_check(s32) (~(VP8_ALTR_FRAME));
                    code_block_to_execute = 20;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 20;
                    continue c_transpiler_dispatch;
                }
            }
            case 25; {
                cpi.ref_frame_flags =
                    ((cast,no_check(s32) (VP8_ALTR_FRAME)) | cast,no_check(s32) (VP8_GOLD_FRAME)) | cast,no_check(s32) (VP8_LAST_FRAME);
                if cpi.gold_is_last != 0 {
                    cpi.ref_frame_flags &= cast,no_check(s32) (~(VP8_GOLD_FRAME));
                    code_block_to_execute = 22;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 22;
                    continue c_transpiler_dispatch;
                }
            }
            case 29; {
                if cm.refresh_alt_ref_frame & cm.refresh_golden_frame != 0 {
                    cpi.gold_is_alt = 1;
                    code_block_to_execute = 25;
                    continue c_transpiler_dispatch;
                } else {
                    if cm.refresh_alt_ref_frame ^ cm.refresh_golden_frame != 0 {
                        cpi.gold_is_alt = 0;
                        code_block_to_execute = 25;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 25;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 33; {
                if cm.refresh_last_frame & cm.refresh_alt_ref_frame != 0 {
                    cpi.alt_is_last = 1;
                    code_block_to_execute = 29;
                    continue c_transpiler_dispatch;
                } else {
                    if cm.refresh_last_frame ^ cm.refresh_alt_ref_frame != 0 {
                        cpi.alt_is_last = 0;
                        code_block_to_execute = 29;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 29;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 37; {
                if cm.refresh_last_frame & cm.refresh_golden_frame != 0 {
                    cpi.gold_is_last = 1;
                    code_block_to_execute = 33;
                    continue c_transpiler_dispatch;
                } else {
                    if cm.refresh_last_frame ^ cm.refresh_golden_frame != 0 {
                        cpi.gold_is_last = 0;
                        code_block_to_execute = 33;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 33;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 40; {
                if cm.refresh_alt_ref_frame == 1 {
                    cm.frame_flags = cm.frame_flags | cast,no_check(s32) (FRAMEFLAGS_ALTREF);
                    code_block_to_execute = 37;
                    continue c_transpiler_dispatch;
                } else {
                    cm.frame_flags = cm.frame_flags & cast,no_check(s32) (~(FRAMEFLAGS_ALTREF));
                    code_block_to_execute = 37;
                    continue c_transpiler_dispatch;
                }
            }
            case 44; {
                cpi.ext_refresh_frame_flags_pending = 0;
                if cm.refresh_golden_frame == 1 {
                    cm.frame_flags = cm.frame_flags | cast,no_check(s32) (FRAMEFLAGS_GOLDEN);
                    code_block_to_execute = 40;
                    continue c_transpiler_dispatch;
                } else {
                    cm.frame_flags = cm.frame_flags & cast,no_check(s32) (~(FRAMEFLAGS_GOLDEN));
                    code_block_to_execute = 40;
                    continue c_transpiler_dispatch;
                }
            }
            case 54; {
                if cm.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
                    if cpi.common.refresh_alt_ref_frame != 0 {
                        cpi.last_skip_false_probs[2] = cpi.prob_skip_false;
                        cpi.last_skip_probs_q[2] = cm.base_qindex;
                        code_block_to_execute = 44;
                        continue c_transpiler_dispatch;
                    } else {
                        if cpi.common.refresh_golden_frame != 0 {
                            cpi.last_skip_false_probs[1] = cpi.prob_skip_false;
                            cpi.last_skip_probs_q[1] = cm.base_qindex;
                            code_block_to_execute = 44;
                            continue c_transpiler_dispatch;
                        } else {
                            cpi.last_skip_false_probs[0] = cpi.prob_skip_false;
                            cpi.last_skip_probs_q[0] = cm.base_qindex;
                            cpi.base_skip_false_prob[cm.base_qindex] = cpi.prob_skip_false;
                            code_block_to_execute = 44;
                            continue c_transpiler_dispatch;
                        }
                    }
                } else {
                    code_block_to_execute = 44;
                    continue c_transpiler_dispatch;
                }
            }
            case 62; {
                if cm.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
                    cpi.twopass.kf_group_bits += cast,no_check(s64) (cpi.this_frame_target - cpi.projected_frame_size);
                    if cpi.twopass.kf_group_bits < 0 {
                        cpi.twopass.kf_group_bits = 0;
                        code_block_to_execute = 54;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 54;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    if cm.refresh_golden_frame != 0 || cm.refresh_alt_ref_frame != 0 {
                        cpi.twopass.gf_group_bits +=
                            cast,no_check(s64) (cpi.this_frame_target -
                                cpi.projected_frame_size);
                        if cpi.twopass.gf_group_bits < 0 {
                            cpi.twopass.gf_group_bits = 0;
                            code_block_to_execute = 54;
                            continue c_transpiler_dispatch;
                        } else {
                            code_block_to_execute = 54;
                            continue c_transpiler_dispatch;
                        }
                    } else {
                        code_block_to_execute = 54;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 63; {
                if i_4 < cpi.oxcf.number_of_layers {
                    code_block_to_execute = 72;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 62;
                    continue c_transpiler_dispatch;
                }
            }
            case 67; {
                lc.total_actual_bits += cast,no_check(s64) cpi.projected_frame_size;
                lc.total_target_vs_actual += cast,no_check(s64) bits_off_for_this_layer;
                lc.buffer_level = lc.bits_off_target;
                i_4 += 1;
                code_block_to_execute = 63;
                continue c_transpiler_dispatch;
            }
            case 72; {
                lc = cpi.layer_context.data + i_4;
                bits_off_for_this_layer = cast,no_check(s32) c_transpiler_math_round(lc.target_bandwidth / lc.framerate - cpi.projected_frame_size);
                lc.bits_off_target += cast,no_check(s64) bits_off_for_this_layer;
                if lc.bits_off_target > lc.maximum_buffer_size {
                    lc.bits_off_target = lc.maximum_buffer_size;
                    code_block_to_execute = 67;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 67;
                    continue c_transpiler_dispatch;
                }
            }
            case 81; {
                cpi.rolling_target_bits =
                    cast,no_check(s32) (((cast,no_check(u64) (((cast,no_check(s64) cpi.rolling_target_bits) * 3) + cast(s64) cpi.this_frame_target)) +
                        (cast(u64) 1) << (((2 - 1)) & 63)) >> 2);
                cpi.rolling_actual_bits =
                    cast,no_check(s32) (((cast,no_check(u64) (((cast,no_check(s64) cpi.rolling_actual_bits) * 3) + cast(s64) cpi.projected_frame_size)) +
                        (cast(u64) 1) << (((2 - 1)) & 63)) >> 2);
                cpi.long_rolling_target_bits =
                    cast,no_check(s32) (((cast,no_check(u64) (((cast,no_check(s64) cpi.long_rolling_target_bits) * 31) + cast(s64) cpi.this_frame_target)) +
                        (cast(u64) 1) << (((5 - 1)) & 63)) >> 5);
                cpi.long_rolling_actual_bits =
                    cast,no_check(s32) (((cast,no_check(u64) (((cast,no_check(s64) cpi.long_rolling_actual_bits) * 31) + cast(s64) cpi.projected_frame_size)) +
                        (cast(u64) 1) << (((5 - 1)) & 63)) >> 5);
                cpi.total_actual_bits += cast,no_check(s64) cpi.projected_frame_size;
                cpi.buffer_level = cpi.bits_off_target;
                if cpi.oxcf.number_of_layers > 1 {
                    i_4 = cpi.current_layer + 1;
                    code_block_to_execute = 63;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 62;
                    continue c_transpiler_dispatch;
                }
            }
            case 83; {
                if cpi.oxcf.screen_content_mode != 0 && cpi.bits_off_target < -cpi.oxcf.maximum_buffer_size {
                    cpi.bits_off_target = -cpi.oxcf.maximum_buffer_size;
                    code_block_to_execute = 81;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 81;
                    continue c_transpiler_dispatch;
                }
            }
            case 85; {
                if cpi.bits_off_target > cpi.oxcf.maximum_buffer_size {
                    cpi.bits_off_target = cpi.oxcf.maximum_buffer_size;
                    code_block_to_execute = 83;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 83;
                    continue c_transpiler_dispatch;
                }
            }
            case 88; {
                if cm.show_frame == 0 {
                    cpi.bits_off_target -= cast,no_check(s64) cpi.projected_frame_size;
                    code_block_to_execute = 85;
                    continue c_transpiler_dispatch;
                } else {
                    cpi.bits_off_target += cast,no_check(s64) (cpi.av_per_frame_bandwidth - cpi.projected_frame_size);
                    code_block_to_execute = 85;
                    continue c_transpiler_dispatch;
                }
            }
            case 90; {
                if q > cpi.ni_av_qi {
                    cpi.ni_av_qi = q - 1;
                    code_block_to_execute = 88;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 88;
                    continue c_transpiler_dispatch;
                }
            }
            case 100; {
                if cm.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon && (cpi.oxcf.number_of_layers > 1 || cm.refresh_golden_frame == 0 && cm.refresh_alt_ref_frame == 0) {
                    cpi.ni_frames += 1;
                    if cpi.pass == 2 {
                        cpi.ni_tot_qi += q;
                        cpi.ni_av_qi = cpi.ni_tot_qi / cpi.ni_frames;
                        code_block_to_execute = 88;
                        continue c_transpiler_dispatch;
                    } else {
                        if cpi.ni_frames > 150 {
                            cpi.ni_tot_qi += q;
                            cpi.ni_av_qi = cpi.ni_tot_qi / cpi.ni_frames;
                            code_block_to_execute = 90;
                            continue c_transpiler_dispatch;
                        } else {
                            cpi.ni_tot_qi += q;
                            cpi.ni_av_qi = (cpi.ni_tot_qi / cpi.ni_frames + cpi.worst_quality + 1) / 2;
                            code_block_to_execute = 90;
                            continue c_transpiler_dispatch;
                        }
                    }
                } else {
                    code_block_to_execute = 88;
                    continue c_transpiler_dispatch;
                }
            }
            case 102; {
                if cm.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
                    cpi.avg_frame_qindex = (2 + 3 * cpi.avg_frame_qindex + cm.base_qindex) >> 2;
                    code_block_to_execute = 100;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 100;
                    continue c_transpiler_dispatch;
                }
            }
            case 105; {
                cpi.last_q[cm.frame_type] = cm.base_qindex;
                if cm.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
                    vp8_adjust_key_frame_context(cpi);
                    code_block_to_execute = 102;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 102;
                    continue c_transpiler_dispatch;
                }
            }
            case 107; {
                if active_worst_qchanged == 0 {
                    vp8_update_rate_correction_factors(cpi, 2);
                    code_block_to_execute = 105;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 105;
                    continue c_transpiler_dispatch;
                }
            }
            case 108; {
                while c_transpiler_local_loop := true {
                    if i_3 < cpi.oxcf.number_of_layers {
                        cpi.layer_context[i_3].total_byte_count = cast,no_check(s64) ((cast,no_check(u64) cpi.layer_context[i_3].total_byte_count) + size.*);
                        i_3 += 1;
                        continue c_transpiler_local_loop;
                    } else {
                        code_block_to_execute = 107;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 117; {
                vp8_pack_bitstream(cpi, dest, dest_end, size);
                cm.last_frame_type = cm.frame_type;
                cpi.total_byte_count = cast,no_check(s64) ((cast,no_check(u64) cpi.total_byte_count) + size.*);
                cpi.projected_frame_size = (cast,no_check(s32) size.*) << 3;
                if cpi.oxcf.number_of_layers > 1 {
                    i_3 = cpi.current_layer + 1;
                    code_block_to_execute = 108;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 107;
                    continue c_transpiler_dispatch;
                }
            }
            case 120; {
                update_reference_frames(cpi);
                if cpi.oxcf.error_resilient_mode != 0 {
                    cm.refresh_entropy_probs = 0;
                    code_block_to_execute = 117;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 117;
                    continue c_transpiler_dispatch;
                }
            }
            case 125; {
                if atomic_load_acquire_in_onyx_if(*cpi.b_multi_threaded) != 0 {
                    sem_post(*cpi.h_event_start_lpf);
                    cpi.b_lpf_running = 1;
                    vp8_sem_wait_in_onyx_if(*cpi.h_event_end_lpf);
                    code_block_to_execute = 120;
                    continue c_transpiler_dispatch;
                } else {
                    vp8_loopfilter_frame(cpi, cm);
                    code_block_to_execute = 120;
                    continue c_transpiler_dispatch;
                }
            }
            case 127; {
                if cpi.oxcf.noise_sensitivity == 4 && cpi.oxcf.screen_content_mode == 0 && (cpi.frames_since_key % 8) == 0 && cm.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
                    process_denoiser_mode_change(cpi);
                    code_block_to_execute = 125;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 125;
                    continue c_transpiler_dispatch;
                }
            }
            case 130; {
                cm.frame_to_show = cm.yv12_fb.data + cm.new_fb_idx;
                if cpi.oxcf.noise_sensitivity > 0 && cpi.oxcf.noise_sensitivity < 4 && cpi.oxcf.screen_content_mode == 0 && (cpi.frames_since_key % 8) == 0 && cm.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
                    cpi.mse_source_denoised =
                        measure_square_diff_partial(
                            cpi.denoiser.yv12_running_avg.data + INTRA_FRAME,
                            cpi.source,
                            cpi
                        );
                    code_block_to_execute = 127;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 127;
                    continue c_transpiler_dispatch;
                }
            }
            case 133; {
                if cpi.oxcf.error_resilient_mode == 0 && cm.refresh_golden_frame != 0 && cpi.ext_refresh_frame_flags_pending == 0 {
                    cm.copy_buffer_to_arf = 2;
                    code_block_to_execute = 130;
                    continue c_transpiler_dispatch;
                } else {
                    cm.copy_buffer_to_arf = 0;
                    code_block_to_execute = 130;
                    continue c_transpiler_dispatch;
                }
            }
            case 135; {
                if cm.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
                    cm.refresh_last_frame = 1;
                    code_block_to_execute = 133;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 133;
                    continue c_transpiler_dispatch;
                }
            }
            case 137; {
                if cpi.oxcf.number_of_layers == 1 {
                    vp8_update_gf_usage_maps(cpi, cm, *cpi.mb);
                    code_block_to_execute = 135;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 135;
                    continue c_transpiler_dispatch;
                }
            }
            case 138; {
                if mb_row_2 < cm.mb_rows {
                    code_block_to_execute = 146;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 137;
                    continue c_transpiler_dispatch;
                }
            }
            case 141; {
                if mb_col_2 < cm.mb_cols {
                    code_block_to_execute = 145;
                    continue c_transpiler_dispatch;
                } else {
                    tmp_2 += 1;
                    mb_row_2 += 1;
                    code_block_to_execute = 138;
                    continue c_transpiler_dispatch;
                }
            }
            case 143; {
                tmp_2 += 1;
                mb_col_2 += 1;
                code_block_to_execute = 141;
                continue c_transpiler_dispatch;
            }
            case 145; {
                if tmp_2.mbmi.mode == cast,no_check(u8) ZEROMV && tmp_2.mbmi.ref_frame == cast,no_check(u8) LAST_FRAME {
                    cpi.zeromv_count += 1;
                    code_block_to_execute = 143;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 143;
                    continue c_transpiler_dispatch;
                }
            }
            case 146; {
                mb_col_2 = 0;
                code_block_to_execute = 141;
                continue c_transpiler_dispatch;
            }
            case 152; {
                tmp_2 = cm.mi;
                cpi.zeromv_count = 0;
                if cm.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
                    mb_row_2 = 0;
                    code_block_to_execute = 138;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 137;
                    continue c_transpiler_dispatch;
                }
            }
            case 153; {
                if mb_row < cm.mb_rows + 1 {
                    code_block_to_execute = 162;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 152;
                    continue c_transpiler_dispatch;
                }
            }
            case 155; {
                if mb_col < cm.mb_cols + 1 {
                    code_block_to_execute = 161;
                    continue c_transpiler_dispatch;
                } else {
                    mb_row += 1;
                    code_block_to_execute = 153;
                    continue c_transpiler_dispatch;
                }
            }
            case 159; {
                cpi.lf_ref_frame_sign_bias[mb_col + mb_row * (cm.mode_info_stride + 1)] =
                    cm.ref_frame_sign_bias[tmp.mbmi.ref_frame];
                cpi.lf_ref_frame[mb_col + mb_row * (cm.mode_info_stride + 1)] = cast,no_check(s32) tmp.mbmi.ref_frame;
                tmp += 1;
                mb_col += 1;
                code_block_to_execute = 155;
                continue c_transpiler_dispatch;
            }
            case 161; {
                if tmp.mbmi.ref_frame != cast,no_check(u8) INTRA_FRAME {
                    (cast(*Int_Mv_in_mv) (cpi.lfmv))[mb_col + mb_row * (cm.mode_info_stride + 1)].as_int =
                        tmp.mbmi.mv.as_int;
                    code_block_to_execute = 159;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 159;
                    continue c_transpiler_dispatch;
                }
            }
            case 162; {
                mb_col = 0;
                code_block_to_execute = 155;
                continue c_transpiler_dispatch;
            }
            case 168; {
                if cm.show_frame != 0 {
                    tmp = cm.mip;
                    if cm.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
                        mb_row = 0;
                        code_block_to_execute = 153;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 152;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 152;
                    continue c_transpiler_dispatch;
                }
            }
            case 171; {
                if loop == 1 {
                    code_block_to_execute = 305;
                    continue c_transpiler_dispatch;
                } else {
                    if cpi.next_key_frame_forced != 0 && cpi.twopass.frames_to_key == 0 {
                        cpi.ambient_err = vp8_calc_ss_err(cpi.source, cm.yv12_fb.data + cm.new_fb_idx);
                        code_block_to_execute = 168;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 168;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 173; {
                if loop == 1 {
                    vp8_restore_coding_context(cpi);
                    code_block_to_execute = 171;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 171;
                    continue c_transpiler_dispatch;
                }
            }
            case 175; {
                if cpi.is_src_frame_alt_ref != 0 {
                    loop = 0;
                    code_block_to_execute = 173;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 173;
                    continue c_transpiler_dispatch;
                }
            }
            case 178; {
                cpi.mb.zbin_over_quant =
                    ifx cpi.mb.zbin_over_quant < zbin_oq_low then zbin_oq_low else (ifx cpi.mb.zbin_over_quant > zbin_oq_high then zbin_oq_high else cpi.mb.zbin_over_quant);
                loop = cast(s32) (q != last_q_2);
                code_block_to_execute = 175;
                continue c_transpiler_dispatch;
            }
            case 182; {
                if q > q_high {
                    q = q_high;
                    code_block_to_execute = 178;
                    continue c_transpiler_dispatch;
                } else {
                    if q < q_low {
                        q = q_low;
                        code_block_to_execute = 178;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 178;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 183; {
                undershoot_seen = 1;
                code_block_to_execute = 182;
                continue c_transpiler_dispatch;
            }
            case 184; {
                while c_transpiler_local_loop := true {
                    if (q > q_high || cpi.mb.zbin_over_quant > zbin_oq_high) && retries < 10 {
                        vp8_update_rate_correction_factors(cpi, 0);
                        q = vp8_regulate_q(cpi, cpi.this_frame_target);
                        retries += 1;
                        continue c_transpiler_local_loop;
                    } else {
                        code_block_to_execute = 183;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 190; {
                q = vp8_regulate_q(cpi, cpi.this_frame_target);
                if cpi.oxcf.end_usage == USAGE_CONSTRAINED_QUALITY && q < q_low {
                    q_low = q;
                    code_block_to_execute = 184;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 184;
                    continue c_transpiler_dispatch;
                }
            }
            case 196; {
                q = (q_high + q_low) / 2;
                if q < 127 {
                    cpi.mb.zbin_over_quant = 0;
                    code_block_to_execute = 183;
                    continue c_transpiler_dispatch;
                } else {
                    cpi.mb.zbin_over_quant = (zbin_oq_high + zbin_oq_low) / 2;
                    code_block_to_execute = 183;
                    continue c_transpiler_dispatch;
                }
            }
            case 199; {
                if overshoot_seen != 0 {
                    if active_worst_qchanged == 0 {
                        vp8_update_rate_correction_factors(cpi, 1);
                        code_block_to_execute = 196;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 196;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    if active_worst_qchanged == 0 {
                        vp8_update_rate_correction_factors(cpi, 0);
                        code_block_to_execute = 190;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 190;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 203; {
                overshoot_seen = 1;
                code_block_to_execute = 182;
                continue c_transpiler_dispatch;
            }
            case 204; {
                while c_transpiler_local_loop := true {
                    if (q < q_low || cpi.mb.zbin_over_quant < zbin_oq_low) && retries < 10 {
                        vp8_update_rate_correction_factors(cpi, 0);
                        q = vp8_regulate_q(cpi, cpi.this_frame_target);
                        retries += 1;
                        continue c_transpiler_local_loop;
                    } else {
                        code_block_to_execute = 203;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 208; {
                q = vp8_regulate_q(cpi, cpi.this_frame_target);
                code_block_to_execute = 204;
                continue c_transpiler_dispatch;
            }
            case 215; {
                q = (q_high + q_low + 1) / 2;
                if q < 127 {
                    cpi.mb.zbin_over_quant = 0;
                    code_block_to_execute = 203;
                    continue c_transpiler_dispatch;
                } else {
                    zbin_oq_low =
                        ifx cpi.mb.zbin_over_quant < zbin_oq_high then cpi.mb.zbin_over_quant +
                            1 else zbin_oq_high;
                    cpi.mb.zbin_over_quant = (zbin_oq_high + zbin_oq_low) / 2;
                    code_block_to_execute = 203;
                    continue c_transpiler_dispatch;
                }
            }
            case 218; {
                if undershoot_seen != 0 {
                    if active_worst_qchanged == 0 {
                        vp8_update_rate_correction_factors(cpi, 1);
                        code_block_to_execute = 215;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 215;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    if active_worst_qchanged == 0 {
                        vp8_update_rate_correction_factors(cpi, 0);
                        code_block_to_execute = 208;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 208;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 226; {
                loop = cast(s32) (q != last_q);
                code_block_to_execute = 175;
                continue c_transpiler_dispatch;
            }
            case 230; {
                if q > q_high {
                    q = q_high;
                    code_block_to_execute = 226;
                    continue c_transpiler_dispatch;
                } else {
                    if q < q_low {
                        q = q_low;
                        code_block_to_execute = 226;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 226;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 239; {
                if cm.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon && cpi.this_key_frame_forced != 0 {
                    last_q = q;
                    kf_err = vp8_calc_ss_err(cpi.source, cm.yv12_fb.data + cm.new_fb_idx);
                    if kf_err > (cpi.ambient_err * 7) >> 3 {
                        q_high = ifx q > q_low then q - 1 else q_low;
                        q = (q_high + q_low) >> 1;
                        code_block_to_execute = 230;
                        continue c_transpiler_dispatch;
                    } else {
                        if kf_err < cpi.ambient_err >> 1 {
                            q_low = ifx q < q_high then q + 1 else q_high;
                            q = (q_high + q_low + 1) >> 1;
                            code_block_to_execute = 230;
                            continue c_transpiler_dispatch;
                        } else {
                            code_block_to_execute = 230;
                            continue c_transpiler_dispatch;
                        }
                    }
                } else {
                    if recode_loop_test(cpi, frame_over_shoot_limit, frame_under_shoot_limit, q, top_index, bottom_index) != 0 {
                        last_q_2 = q;
                        retries = 0;
                        if cpi.projected_frame_size > cpi.this_frame_target {
                            q_low = ifx q < q_high then q + 1 else q_high;
                            if cpi.mb.zbin_over_quant > 0 {
                                zbin_oq_low =
                                    ifx cpi.mb.zbin_over_quant < zbin_oq_high then cpi.mb.zbin_over_quant +
                                        1 else zbin_oq_high;
                                code_block_to_execute = 218;
                                continue c_transpiler_dispatch;
                            } else {
                                code_block_to_execute = 218;
                                continue c_transpiler_dispatch;
                            }
                        } else {
                            if cpi.mb.zbin_over_quant == 0 {
                                q_high = ifx q > q_low then q - 1 else q_low;
                                code_block_to_execute = 199;
                                continue c_transpiler_dispatch;
                            } else {
                                zbin_oq_high =
                                    ifx cpi.mb.zbin_over_quant > zbin_oq_low then cpi.mb.zbin_over_quant -
                                        1 else zbin_oq_low;
                                code_block_to_execute = 199;
                                continue c_transpiler_dispatch;
                            }
                        }
                    } else {
                        loop = 0;
                        code_block_to_execute = 175;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 243; {
                while c_transpiler_local_loop := true {
                    if cpi.active_worst_quality < cpi.worst_quality && over_size_percent > 0 {
                        cpi.active_worst_quality += 1;
                        over_size_percent = cast,no_check(s32) ((cast,no_check(float64) over_size_percent) * 0.96);
                        continue c_transpiler_local_loop;
                    } else {
                        top_index = cpi.active_worst_quality;
                        active_worst_qchanged = 1;
                        code_block_to_execute = 239;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 247; {
                if cpi.rt_always_update_correction_factor == 0 && (cpi.pass != 2 || cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER) && q == cpi.active_worst_quality && cpi.active_worst_quality < cpi.worst_quality && cpi.projected_frame_size > frame_over_shoot_limit {
                    over_size_percent = (cpi.projected_frame_size - frame_over_shoot_limit) * 100 / frame_over_shoot_limit;
                    code_block_to_execute = 243;
                    continue c_transpiler_dispatch;
                } else {
                    active_worst_qchanged = 0;
                    code_block_to_execute = 239;
                    continue c_transpiler_dispatch;
                }
            }
            case 250; {
                if frame_over_shoot_limit == 0 {
                    frame_over_shoot_limit = 1;
                    code_block_to_execute = 247;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 247;
                    continue c_transpiler_dispatch;
                }
            }
            case 268; {
                cpi.projected_frame_size -= vp8_estimate_entropy_savings(cpi);
                cpi.projected_frame_size = ifx cpi.projected_frame_size > 0 then cpi.projected_frame_size else 0;
                if cpi.pass != 2 && cpi.oxcf.auto_key != 0 && cm.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon && cpi.compressor_speed != 2 {
                    if decide_key_frame(cpi) != 0 {
                        cm.frame_type = cast,no_check(FRAME_TYPE_in_alloccommon) KEY_FRAME_in_alloccommon;
                        vp8_pick_frame_size(cpi);
                        cpi.source_alt_ref_active = 0;
                        setup_features(cpi);
                        vp8_restore_coding_context(cpi);
                        q = vp8_regulate_q(cpi, cpi.this_frame_target);
                        vp8_compute_frame_size_bounds(cpi, *frame_under_shoot_limit, *frame_over_shoot_limit);
                        bottom_index = cpi.active_best_quality;
                        top_index = cpi.active_worst_quality;
                        q_low = cpi.active_best_quality;
                        q_high = cpi.active_worst_quality;
                        loop = 1;
                        code_block_to_execute = 171;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 250;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 250;
                    continue c_transpiler_dispatch;
                }
            }
            case 275; {
                vp8_encode_frame(cpi);
                if cpi.pass == 0 && cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER && cpi.rt_drop_recode_on_overshoot == 1 {
                    if vp8_drop_encodedframe_overshoot(cpi, q) != 0 {
                        return;
                    } else {
                        if cm.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
                            cpi.last_pred_err_mb =
                                cast,no_check(s32) (cpi.mb.prediction_error /
                                    cast(s64) cpi.common.m_bs);
                            code_block_to_execute = 268;
                            continue c_transpiler_dispatch;
                        } else {
                            code_block_to_execute = 268;
                            continue c_transpiler_dispatch;
                        }
                    }
                } else {
                    code_block_to_execute = 268;
                    continue c_transpiler_dispatch;
                }
            }
            case 276; {
                vp8_setup_key_frame(cpi);
                code_block_to_execute = 275;
                continue c_transpiler_dispatch;
            }
            case 279; {
                fill_memory(cpi.consec_zero_last, 0, cast,no_check(u64) (cm.mb_rows * cm.mb_cols));
                fill_memory(
                    cpi.consec_zero_last_mvbias,
                    0,
                    cast,no_check(u64) (cpi.common.mb_rows * cpi.common.mb_cols)
                );
                vp8_set_quantizer(cpi, q);
                code_block_to_execute = 276;
                continue c_transpiler_dispatch;
            }
            case 286; {
                if cm.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
                    if resize_key_frame(cpi) != 0 {
                        q = vp8_regulate_q(cpi, cpi.this_frame_target);
                        if cpi.cyclic_refresh_mode_enabled != 0 {
                            if cpi.current_layer == 0 {
                                cyclic_background_refresh(cpi, q, 0);
                                code_block_to_execute = 279;
                                continue c_transpiler_dispatch;
                            } else {
                                disable_segmentation(cpi);
                                code_block_to_execute = 279;
                                continue c_transpiler_dispatch;
                            }
                        } else {
                            code_block_to_execute = 279;
                            continue c_transpiler_dispatch;
                        }
                    } else {
                        code_block_to_execute = 276;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 275;
                    continue c_transpiler_dispatch;
                }
            }
            case 288; {
                if cpi.oxcf.number_of_layers == 1 && cpi.is_src_frame_alt_ref != 0 {
                    cpi.prob_skip_false = 1;
                    code_block_to_execute = 286;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 286;
                    continue c_transpiler_dispatch;
                }
            }
            case 290; {
                if cpi.prob_skip_false > 250 {
                    cpi.prob_skip_false = 250;
                    code_block_to_execute = 288;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 288;
                    continue c_transpiler_dispatch;
                }
            }
            case 292; {
                if cpi.prob_skip_false < 5 {
                    cpi.prob_skip_false = 5;
                    code_block_to_execute = 290;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 290;
                    continue c_transpiler_dispatch;
                }
            }
            case 305; {
                vp8_set_quantizer(cpi, q);
                if cpi.common.mb_no_coeff_skip != 0 {
                    cpi.prob_skip_false = cpi.base_skip_false_prob[q];
                    if cm.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
                        if cpi.common.refresh_alt_ref_frame != 0 {
                            if cpi.last_skip_false_probs[2] != 0 {
                                cpi.prob_skip_false = cpi.last_skip_false_probs[2];
                                code_block_to_execute = 292;
                                continue c_transpiler_dispatch;
                            } else {
                                code_block_to_execute = 292;
                                continue c_transpiler_dispatch;
                            }
                        } else {
                            if cpi.common.refresh_golden_frame != 0 {
                                if cpi.last_skip_false_probs[1] != 0 {
                                    cpi.prob_skip_false = cpi.last_skip_false_probs[1];
                                    code_block_to_execute = 292;
                                    continue c_transpiler_dispatch;
                                } else {
                                    code_block_to_execute = 292;
                                    continue c_transpiler_dispatch;
                                }
                            } else {
                                if cpi.last_skip_false_probs[0] != 0 {
                                    cpi.prob_skip_false = cpi.last_skip_false_probs[0];
                                    code_block_to_execute = 292;
                                    continue c_transpiler_dispatch;
                                } else {
                                    code_block_to_execute = 292;
                                    continue c_transpiler_dispatch;
                                }
                            }
                        }
                    } else {
                        code_block_to_execute = 286;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 286;
                    continue c_transpiler_dispatch;
                }
            }
            case 312; {
                vp8_compute_frame_size_bounds(cpi, *frame_under_shoot_limit, *frame_over_shoot_limit);
                bottom_index = cpi.active_best_quality;
                top_index = cpi.active_worst_quality;
                q_low = cpi.active_best_quality;
                q_high = cpi.active_worst_quality;
                vp8_save_coding_context(cpi);
                scale_and_extend_source(cpi.un_scaled_source, cpi);
                code_block_to_execute = 305;
                continue c_transpiler_dispatch;
            }
            case 318; {
                compute_skin_map(cpi);
                if cpi.cyclic_refresh_mode_enabled != 0 {
                    disable_cr_gf = cast(s32) (cpi.oxcf.screen_content_mode == 2 && cm.refresh_golden_frame != 0);
                    if cpi.current_layer == 0 && cpi.force_maxqp == 0 && disable_cr_gf == 0 {
                        cyclic_background_refresh(cpi, q, 0);
                        code_block_to_execute = 312;
                        continue c_transpiler_dispatch;
                    } else {
                        disable_segmentation(cpi);
                        code_block_to_execute = 312;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 312;
                    continue c_transpiler_dispatch;
                }
            }
            case 324; {
                q = vp8_regulate_q(cpi, cpi.this_frame_target);
                if cm.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
                    zbin_oq_high = 0;
                    code_block_to_execute = 318;
                    continue c_transpiler_dispatch;
                } else {
                    if cpi.oxcf.number_of_layers == 1 && (cm.refresh_alt_ref_frame != 0 || cm.refresh_golden_frame != 0 && cpi.source_alt_ref_active == 0) {
                        zbin_oq_high = 16;
                        code_block_to_execute = 318;
                        continue c_transpiler_dispatch;
                    } else {
                        zbin_oq_high = 192;
                        code_block_to_execute = 318;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 326; {
                if cpi.active_worst_quality < cpi.active_best_quality {
                    cpi.active_worst_quality = cpi.active_best_quality;
                    code_block_to_execute = 324;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 324;
                    continue c_transpiler_dispatch;
                }
            }
            case 328; {
                if cpi.active_best_quality < cpi.best_quality {
                    cpi.active_best_quality = cpi.best_quality;
                    code_block_to_execute = 326;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 326;
                    continue c_transpiler_dispatch;
                }
            }
            case 330; {
                if cpi.active_worst_quality > cpi.worst_quality {
                    cpi.active_worst_quality = cpi.worst_quality;
                    code_block_to_execute = 328;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 328;
                    continue c_transpiler_dispatch;
                }
            }
            case 342; {
                if cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER {
                    if cpi.buffer_level >= cpi.oxcf.maximum_buffer_size {
                        cpi.active_best_quality = cpi.best_quality;
                        code_block_to_execute = 330;
                        continue c_transpiler_dispatch;
                    } else {
                        if cpi.buffer_level > cpi.oxcf.optimal_buffer_level {
                            fraction = cast,no_check(s32) (((cpi.buffer_level - cpi.oxcf.optimal_buffer_level) * 128) / (cpi.oxcf.maximum_buffer_size - cpi.oxcf.optimal_buffer_level));
                            min_qadjustment = (cpi.active_best_quality - cpi.best_quality) * fraction / 128;
                            cpi.active_best_quality -= min_qadjustment;
                            code_block_to_execute = 330;
                            continue c_transpiler_dispatch;
                        } else {
                            code_block_to_execute = 330;
                            continue c_transpiler_dispatch;
                        }
                    }
                } else {
                    code_block_to_execute = 330;
                    continue c_transpiler_dispatch;
                }
            }
            case 350; {
                if cpi.oxcf.end_usage == USAGE_CONSTRAINED_QUALITY {
                    cpi.active_best_quality = cpi.active_best_quality * 15 / 16;
                    code_block_to_execute = 342;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 342;
                    continue c_transpiler_dispatch;
                }
            }
            case 356; {
                if cpi.pass == 2 {
                    if cpi.gfu_boost > 1000 {
                        cpi.active_best_quality = cast,no_check(s32) GF_LOW_MOTION_MINQ[q];
                        code_block_to_execute = 350;
                        continue c_transpiler_dispatch;
                    } else {
                        if cpi.gfu_boost < 400 {
                            cpi.active_best_quality = cast,no_check(s32) GF_HIGH_MOTION_MINQ[q];
                            code_block_to_execute = 350;
                            continue c_transpiler_dispatch;
                        } else {
                            cpi.active_best_quality = cast,no_check(s32) GF_MID_MOTION_MINQ[q];
                            code_block_to_execute = 350;
                            continue c_transpiler_dispatch;
                        }
                    }
                } else {
                    cpi.active_best_quality = cast,no_check(s32) GF_HIGH_MOTION_MINQ[q];
                    code_block_to_execute = 342;
                    continue c_transpiler_dispatch;
                }
            }
            case 358; {
                if cpi.oxcf.end_usage == USAGE_CONSTRAINED_QUALITY && q < cpi.cq_target_quality {
                    q = cpi.cq_target_quality;
                    code_block_to_execute = 356;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 356;
                    continue c_transpiler_dispatch;
                }
            }
            case 367; {
                if cpi.this_key_frame_forced != 0 {
                    if cpi.active_best_quality > cpi.avg_frame_qindex * 7 / 8 {
                        cpi.active_best_quality = cpi.avg_frame_qindex * 7 / 8;
                        code_block_to_execute = 342;
                        continue c_transpiler_dispatch;
                    } else {
                        if cpi.active_best_quality < cpi.avg_frame_qindex >> 2 {
                            cpi.active_best_quality = cpi.avg_frame_qindex >> 2;
                            code_block_to_execute = 342;
                            continue c_transpiler_dispatch;
                        } else {
                            code_block_to_execute = 342;
                            continue c_transpiler_dispatch;
                        }
                    }
                } else {
                    code_block_to_execute = 342;
                    continue c_transpiler_dispatch;
                }
            }
            case 375; {
                if cpi.pass == 2 || cpi.ni_frames > 150 {
                    q = cpi.active_worst_quality;
                    if cm.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
                        if cpi.pass == 2 {
                            if cpi.gfu_boost > 600 {
                                cpi.active_best_quality = cast,no_check(s32) KF_LOW_MOTION_MINQ[q];
                                code_block_to_execute = 367;
                                continue c_transpiler_dispatch;
                            } else {
                                cpi.active_best_quality = cast,no_check(s32) KF_HIGH_MOTION_MINQ[q];
                                code_block_to_execute = 367;
                                continue c_transpiler_dispatch;
                            }
                        } else {
                            cpi.active_best_quality = cast,no_check(s32) KF_HIGH_MOTION_MINQ[q];
                            code_block_to_execute = 342;
                            continue c_transpiler_dispatch;
                        }
                    } else {
                        if cpi.oxcf.number_of_layers == 1 && (cm.refresh_golden_frame != 0 || cpi.common.refresh_alt_ref_frame != 0) {
                            if cpi.frames_since_key > 1 && cpi.avg_frame_qindex < cpi.active_worst_quality {
                                q = cpi.avg_frame_qindex;
                                code_block_to_execute = 358;
                                continue c_transpiler_dispatch;
                            } else {
                                code_block_to_execute = 358;
                                continue c_transpiler_dispatch;
                            }
                        } else {
                            cpi.active_best_quality = cast,no_check(s32) INTER_MINQ[q];
                            if cpi.oxcf.end_usage == USAGE_CONSTRAINED_QUALITY && cpi.active_best_quality < cpi.cq_target_quality {
                                if cpi.rolling_actual_bits < cpi.min_frame_bandwidth {
                                    cpi.active_best_quality = cpi.oxcf.cq_level;
                                    code_block_to_execute = 342;
                                    continue c_transpiler_dispatch;
                                } else {
                                    cpi.active_best_quality = cpi.cq_target_quality;
                                    code_block_to_execute = 342;
                                    continue c_transpiler_dispatch;
                                }
                            } else {
                                code_block_to_execute = 342;
                                continue c_transpiler_dispatch;
                            }
                        }
                    }
                } else {
                    if cpi.oxcf.end_usage == USAGE_CONSTRAINED_QUALITY {
                        if cm.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon || cm.refresh_golden_frame != 0 || cpi.common.refresh_alt_ref_frame != 0 {
                            cpi.active_best_quality = cpi.best_quality;
                            code_block_to_execute = 330;
                            continue c_transpiler_dispatch;
                        } else {
                            if cpi.active_best_quality < cpi.cq_target_quality {
                                cpi.active_best_quality = cpi.cq_target_quality;
                                code_block_to_execute = 330;
                                continue c_transpiler_dispatch;
                            } else {
                                code_block_to_execute = 330;
                                continue c_transpiler_dispatch;
                            }
                        }
                    } else {
                        code_block_to_execute = 330;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 378; {
                cpi.active_worst_quality -= adjustment;
                if cpi.active_worst_quality < cpi.active_best_quality {
                    cpi.active_worst_quality = cpi.active_best_quality;
                    code_block_to_execute = 375;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 375;
                    continue c_transpiler_dispatch;
                }
            }
            case 396; {
                update_rd_ref_frame_probs(cpi);
                if vp8_check_drop_buffer(cpi) != 0 {
                    return;
                } else {
                    if vp8_pick_frame_size(cpi) == 0 {
                        cm.current_video_frame += 1;
                        cpi.frames_since_key += 1;
                        cpi.ext_refresh_frame_flags_pending = 0;
                        cpi.temporal_pattern_counter += 1;
                        return;
                    } else {
                        if cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER && cpi.buffer_level >= cpi.oxcf.optimal_buffer_level && cpi.buffered_mode != 0 {
                            adjustment = cpi.active_worst_quality / 4;
                            if adjustment != 0 {
                                if cpi.buffer_level < cpi.oxcf.maximum_buffer_size {
                                    buff_lvl_step =
                                        cast,no_check(s32) ((cpi.oxcf.maximum_buffer_size - cpi.oxcf.optimal_buffer_level) /
                                            cast(s64) adjustment);
                                    if buff_lvl_step != 0 {
                                        adjustment =
                                            cast,no_check(s32) ((cpi.buffer_level - cpi.oxcf.optimal_buffer_level) /
                                                cast(s64) buff_lvl_step);
                                        code_block_to_execute = 378;
                                        continue c_transpiler_dispatch;
                                    } else {
                                        adjustment = 0;
                                        code_block_to_execute = 378;
                                        continue c_transpiler_dispatch;
                                    }
                                } else {
                                    code_block_to_execute = 378;
                                    continue c_transpiler_dispatch;
                                }
                            } else {
                                code_block_to_execute = 375;
                                continue c_transpiler_dispatch;
                            }
                        } else {
                            code_block_to_execute = 375;
                            continue c_transpiler_dispatch;
                        }
                    }
                }
            }
            case 399; {
                while c_transpiler_local_loop := true {
                    if i_2 < 20 {
                        cpi.mb.rd_thresh_mult[i_2] = 128;
                        i_2 += 1;
                        continue c_transpiler_local_loop;
                    } else {
                        fill_memory(cpi.consec_zero_last, 0, cast,no_check(u64) (cm.mb_rows * cm.mb_cols));
                        fill_memory(
                            cpi.consec_zero_last_mvbias,
                            0,
                            cast,no_check(u64) (cpi.common.mb_rows * cpi.common.mb_cols)
                        );
                        code_block_to_execute = 396;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 406; {
                if cm.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
                    setup_features(cpi);
                    cpi.source_alt_ref_active = 0;
                    i_2 = 0;
                    code_block_to_execute = 399;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 396;
                    continue c_transpiler_dispatch;
                }
            }
            case 408; {
                if i <= 3 {
                    code_block_to_execute = 413;
                    continue c_transpiler_dispatch;
                } else {
                    cpi.closest_reference_frame = closest_ref;
                    code_block_to_execute = 406;
                    continue c_transpiler_dispatch;
                }
            }
            case 409; {
                i += 1;
                code_block_to_execute = 408;
                continue c_transpiler_dispatch;
            }
            case 413; {
                ref_frame_type = cast,no_check(Ref_Frame_Type_T) ((ifx i == 3 then 4 else i));
                if (cast,no_check(u32) cpi.ref_frame_flags) & ref_frame_type != 0 {
                    if cm.current_video_frame - cpi.current_ref_frames[i] < cm.current_video_frame - cpi.current_ref_frames[closest_ref] {
                        closest_ref = cast,no_check(MV_REFERENCE_FRAME_in_alloccommon) i;
                        code_block_to_execute = 409;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 409;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 409;
                    continue c_transpiler_dispatch;
                }
            }
            case 414; {
                i = 1;
                code_block_to_execute = 408;
                continue c_transpiler_dispatch;
            }
            case 424; {
                cpi.closest_reference_frame = cast,no_check(MV_REFERENCE_FRAME_in_alloccommon) LAST_FRAME;
                if cm.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
                    closest_ref = cast,no_check(MV_REFERENCE_FRAME_in_alloccommon) INTRA_FRAME;
                    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_LAST_FRAME) != 0 {
                        closest_ref = cast,no_check(MV_REFERENCE_FRAME_in_alloccommon) LAST_FRAME;
                        code_block_to_execute = 414;
                        continue c_transpiler_dispatch;
                    } else {
                        if cpi.ref_frame_flags & cast,no_check(s32) (VP8_GOLD_FRAME) != 0 {
                            closest_ref = cast,no_check(MV_REFERENCE_FRAME_in_alloccommon) GOLDEN_FRAME;
                            code_block_to_execute = 414;
                            continue c_transpiler_dispatch;
                        } else {
                            if cpi.ref_frame_flags & cast,no_check(s32) (VP8_ALTR_FRAME) != 0 {
                                closest_ref = cast,no_check(MV_REFERENCE_FRAME_in_alloccommon) ALTREF_FRAME;
                                code_block_to_execute = 414;
                                continue c_transpiler_dispatch;
                            } else {
                                code_block_to_execute = 414;
                                continue c_transpiler_dispatch;
                            }
                        }
                    }
                } else {
                    code_block_to_execute = 406;
                    continue c_transpiler_dispatch;
                }
            }
            case 428; {
                if cm.current_video_frame == 0 || cm.frame_flags & cast,no_check(s32) (FRAMEFLAGS_KEY) != 0 || cpi.oxcf.auto_key != 0 && cpi.frames_since_key % cpi.key_frame_frequency == 0 {
                    cm.frame_type = cast,no_check(FRAME_TYPE_in_alloccommon) KEY_FRAME_in_alloccommon;
                    if cpi.oxcf.noise_sensitivity == 4 {
                        vp8_denoiser_set_parameters(*cpi.denoiser, cast,no_check(s32) (K_DENOISER_ON_YUV));
                        code_block_to_execute = 424;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 424;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 424;
                    continue c_transpiler_dispatch;
                }
            }
            case 431; {
                if cpi.source_alt_ref_active != 0 {
                    cpi.common.ref_frame_sign_bias[ALTREF_FRAME] = 1;
                    code_block_to_execute = 428;
                    continue c_transpiler_dispatch;
                } else {
                    cpi.common.ref_frame_sign_bias[ALTREF_FRAME] = 0;
                    code_block_to_execute = 428;
                    continue c_transpiler_dispatch;
                }
            }
            case 439; {
                cm.copy_buffer_to_gf = 0;
                cm.copy_buffer_to_arf = 0;
                cpi.mb.zbin_over_quant = 0;
                cpi.mb.zbin_mode_boost = 0;
                cpi.mb.zbin_mode_boost_enabled = 1;
                if cpi.pass == 2 {
                    if cpi.gfu_boost <= 400 {
                        cpi.mb.zbin_mode_boost_enabled = 0;
                        code_block_to_execute = 431;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 431;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 431;
                    continue c_transpiler_dispatch;
                }
            }
            case 442; {
                PER_FRAME_BANDWIDTH = c_transpiler_math_round(cpi.target_bandwidth / cpi.output_framerate);
                cpi.per_frame_bandwidth =
                    cast,no_check(s32) ((ifx c_transpiler_float_less(PER_FRAME_BANDWIDTH, 2147483647.0) then PER_FRAME_BANDWIDTH else 2147483647.0));
                code_block_to_execute = 439;
                continue c_transpiler_dispatch;
            }
            case 447; {
                c_transpiler_switch_value_447 := cpi.pass;
                if c_transpiler_switch_value_447 == {
                    case cast(s32) 2; {
                        if cpi.common.refresh_alt_ref_frame != 0 {
                            cpi.per_frame_bandwidth = cpi.twopass.gf_bits;
                            cpi.target_bandwidth = cast,no_check(s32) (cpi.twopass.gf_bits * cpi.output_framerate);
                            code_block_to_execute = 439;
                            continue c_transpiler_dispatch;
                        } else {
                            code_block_to_execute = 439;
                            continue c_transpiler_dispatch;
                        }
                    }
                    case; {
                        code_block_to_execute = 442;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 465; {
                loop = 0;
                cm = *cpi.common;
                active_worst_qchanged = 0;
                zbin_oq_low = 0;
                overshoot_seen = 0;
                undershoot_seen = 0;
                if cpi.force_next_frame_intra != 0 {
                    cm.frame_type = cast,no_check(FRAME_TYPE_in_alloccommon) KEY_FRAME_in_alloccommon;
                    cpi.force_next_frame_intra = 0;
                    code_block_to_execute = 447;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 447;
                    continue c_transpiler_dispatch;
                }
            }
        }
        assert(false, tprint("invalid code block to execute %", code_block_to_execute));
        break;
    }
}

update_golden_frame_stats :: (cpi: *VP8_COMP) {
    cm := *cpi.common;

    if cm.refresh_golden_frame != 0 {
        if cpi.auto_gold == 0 {
            cpi.frames_till_gf_update_due = 7;
        }

        if cpi.pass != 2 && cpi.frames_till_gf_update_due > 0 {
            cpi.current_gf_interval = cpi.frames_till_gf_update_due;

            if cm.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon && cpi.source_alt_ref_active == 0 {
                cpi.gf_overspend_bits += cpi.projected_frame_size - cpi.inter_frame_target;
            }

            cpi.non_gf_bitrate_adjustment = cpi.gf_overspend_bits / cpi.frames_till_gf_update_due;
        }

        fill_memory(cpi.gf_active_flags, 1, cast,no_check(u64) (cm.mb_rows * cm.mb_cols));
        cpi.gf_active_count = cm.mb_rows * cm.mb_cols;

        cm.refresh_golden_frame = 0;
        cpi.frames_since_golden = 0;

        cpi.recent_ref_frame_usage[INTRA_FRAME] = 1;
        cpi.recent_ref_frame_usage[LAST_FRAME] = 1;
        cpi.recent_ref_frame_usage[GOLDEN_FRAME] = 1;
        cpi.recent_ref_frame_usage[ALTREF_FRAME] = 1;

        if cpi.oxcf.fixed_q >= 0 && cpi.oxcf.play_alternate != 0 && cpi.common.refresh_alt_ref_frame == 0 {
            cpi.source_alt_ref_pending = 1;
            cpi.frames_till_gf_update_due = cpi.baseline_gf_interval;
        }

        if cpi.source_alt_ref_pending == 0 {
            cpi.source_alt_ref_active = 0;
        }

        if cpi.frames_till_gf_update_due > 0 {
            cpi.frames_till_gf_update_due -= 1;
        }
    } else if cpi.common.refresh_alt_ref_frame == 0 {
        if cpi.frames_till_gf_update_due > 0 {
            cpi.frames_till_gf_update_due -= 1;
        }

        if cpi.frames_till_alt_ref_frame != 0 {
            cpi.frames_till_alt_ref_frame -= 1;
        }

        cpi.frames_since_golden += 1;

        if cpi.frames_since_golden > 1 {
            cpi.recent_ref_frame_usage[INTRA_FRAME] += cpi.mb.count_mb_ref_frame_usage[INTRA_FRAME];
            cpi.recent_ref_frame_usage[LAST_FRAME] += cpi.mb.count_mb_ref_frame_usage[LAST_FRAME];
            cpi.recent_ref_frame_usage[GOLDEN_FRAME] += cpi.mb.count_mb_ref_frame_usage[GOLDEN_FRAME];
            cpi.recent_ref_frame_usage[ALTREF_FRAME] += cpi.mb.count_mb_ref_frame_usage[ALTREF_FRAME];
        }
    }
}

update_alt_ref_frame_stats :: (cpi: *VP8_COMP) {
    cm := *cpi.common;

    if cpi.auto_gold == 0 {
        cpi.frames_till_gf_update_due = 7;
    }

    if cpi.pass != 2 && cpi.frames_till_gf_update_due != 0 {
        cpi.current_gf_interval = cpi.frames_till_gf_update_due;

        cpi.gf_overspend_bits += cpi.projected_frame_size;
        cpi.non_gf_bitrate_adjustment = cpi.gf_overspend_bits / cpi.frames_till_gf_update_due;
    }

    fill_memory(cpi.gf_active_flags, 1, cast,no_check(u64) (cm.mb_rows * cm.mb_cols));
    cpi.gf_active_count = cm.mb_rows * cm.mb_cols;

    cpi.frames_since_golden = 0;

    cpi.source_alt_ref_pending = 0;

    cpi.source_alt_ref_active = 1;
}

update_reference_frames :: (cpi: *VP8_COMP) {
    cm := *cpi.common;
    yv12_fb := cm.yv12_fb.data;

    if cm.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
        yv12_fb[cm.new_fb_idx].flags |= (cast,no_check(s32) (VP8_GOLD_FRAME)) | cast,no_check(s32) (VP8_ALTR_FRAME);

        yv12_fb[cm.gld_fb_idx].flags &= cast,no_check(s32) (~(VP8_GOLD_FRAME));
        yv12_fb[cm.alt_fb_idx].flags &= cast,no_check(s32) (~(VP8_ALTR_FRAME));

        cm.gld_fb_idx = cm.new_fb_idx;
        cm.alt_fb_idx = cm.gld_fb_idx;

        cpi.current_ref_frames[GOLDEN_FRAME] = cm.current_video_frame;
        cpi.current_ref_frames[ALTREF_FRAME] = cm.current_video_frame;
    } else {
        if cm.refresh_alt_ref_frame != 0 {
            cm.yv12_fb[cm.new_fb_idx].flags |= cast,no_check(s32) (VP8_ALTR_FRAME);
            cm.yv12_fb[cm.alt_fb_idx].flags &= cast,no_check(s32) (~(VP8_ALTR_FRAME));
            cm.alt_fb_idx = cm.new_fb_idx;

            cpi.current_ref_frames[ALTREF_FRAME] = cm.current_video_frame;
        } else if cm.copy_buffer_to_arf != 0 {
            if cm.copy_buffer_to_arf == 1 {
                if cm.alt_fb_idx != cm.lst_fb_idx {
                    yv12_fb[cm.lst_fb_idx].flags |= cast,no_check(s32) (VP8_ALTR_FRAME);
                    yv12_fb[cm.alt_fb_idx].flags &= cast,no_check(s32) (~(VP8_ALTR_FRAME));
                    cm.alt_fb_idx = cm.lst_fb_idx;

                    cpi.current_ref_frames[ALTREF_FRAME] = cpi.current_ref_frames[LAST_FRAME];
                }
            } else if cm.alt_fb_idx != cm.gld_fb_idx {
                yv12_fb[cm.gld_fb_idx].flags |= cast,no_check(s32) (VP8_ALTR_FRAME);
                yv12_fb[cm.alt_fb_idx].flags &= cast,no_check(s32) (~(VP8_ALTR_FRAME));
                cm.alt_fb_idx = cm.gld_fb_idx;

                cpi.current_ref_frames[ALTREF_FRAME] = cpi.current_ref_frames[GOLDEN_FRAME];
            }
        }

        if cm.refresh_golden_frame != 0 {
            cm.yv12_fb[cm.new_fb_idx].flags |= cast,no_check(s32) (VP8_GOLD_FRAME);
            cm.yv12_fb[cm.gld_fb_idx].flags &= cast,no_check(s32) (~(VP8_GOLD_FRAME));
            cm.gld_fb_idx = cm.new_fb_idx;

            cpi.current_ref_frames[GOLDEN_FRAME] = cm.current_video_frame;
        } else if cm.copy_buffer_to_gf != 0 {
            if cm.copy_buffer_to_gf == 1 {
                if cm.gld_fb_idx != cm.lst_fb_idx {
                    yv12_fb[cm.lst_fb_idx].flags |= cast,no_check(s32) (VP8_GOLD_FRAME);
                    yv12_fb[cm.gld_fb_idx].flags &= cast,no_check(s32) (~(VP8_GOLD_FRAME));
                    cm.gld_fb_idx = cm.lst_fb_idx;

                    cpi.current_ref_frames[GOLDEN_FRAME] = cpi.current_ref_frames[LAST_FRAME];
                }
            } else if cm.alt_fb_idx != cm.gld_fb_idx {
                yv12_fb[cm.alt_fb_idx].flags |= cast,no_check(s32) (VP8_GOLD_FRAME);
                yv12_fb[cm.gld_fb_idx].flags &= cast,no_check(s32) (~(VP8_GOLD_FRAME));
                cm.gld_fb_idx = cm.alt_fb_idx;

                cpi.current_ref_frames[GOLDEN_FRAME] = cpi.current_ref_frames[ALTREF_FRAME];
            }
        }
    }

    if cm.refresh_last_frame != 0 {
        cm.yv12_fb[cm.new_fb_idx].flags |= cast,no_check(s32) (VP8_LAST_FRAME);
        cm.yv12_fb[cm.lst_fb_idx].flags &= cast,no_check(s32) (~(VP8_LAST_FRAME));
        cm.lst_fb_idx = cm.new_fb_idx;

        cpi.current_ref_frames[LAST_FRAME] = cm.current_video_frame;
    }

    if cpi.oxcf.noise_sensitivity != 0 {
        if cm.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
            i := cast,no_check(s32) (LAST_FRAME);
            while i < MAX_REF_FRAMES {
                vp8_yv12_copy_frame_c(cpi.source, cpi.denoiser.yv12_running_avg.data + i);
                i += 1;
            }
        } else {
            vp8_yv12_extend_frame_borders_c(cpi.denoiser.yv12_running_avg.data + INTRA_FRAME);

            if cm.refresh_alt_ref_frame != 0 || cm.copy_buffer_to_arf != 0 {
                vp8_yv12_copy_frame_c(
                    cpi.denoiser.yv12_running_avg.data + INTRA_FRAME,
                    cpi.denoiser.yv12_running_avg.data + ALTREF_FRAME
                );
            }
            if cm.refresh_golden_frame != 0 || cm.copy_buffer_to_gf != 0 {
                vp8_yv12_copy_frame_c(
                    cpi.denoiser.yv12_running_avg.data + INTRA_FRAME,
                    cpi.denoiser.yv12_running_avg.data + GOLDEN_FRAME
                );
            }
            if cm.refresh_last_frame != 0 {
                if cpi.denoiser.denoiser_mode == K_DENOISER_ON_Y_ONLY {
                    vp8_yv12_copy_frame_c(
                        cpi.denoiser.yv12_running_avg.data + INTRA_FRAME,
                        cpi.denoiser.yv12_running_avg.data + LAST_FRAME
                    );
                } else {
                    tmp := cpi.denoiser.yv12_running_avg[INTRA_FRAME];
                    cpi.denoiser.yv12_running_avg[INTRA_FRAME] = cpi.denoiser.yv12_running_avg[LAST_FRAME];
                    cpi.denoiser.yv12_running_avg[LAST_FRAME] = tmp;
                }
            }
        }
        if cpi.oxcf.noise_sensitivity == 4 {
            vp8_yv12_copy_frame_c(cpi.source, *cpi.denoiser.yv12_last_source);
        }
    }
}

vp8_loopfilter_frame :: (cpi: *VP8_COMP, cm: *VP8_COMMON) {
    FRAME_TYPE_ := cm.frame_type;

    update_any_ref_buffers: s32 = 1;
    if cpi.common.refresh_last_frame == 0 && cpi.common.refresh_golden_frame == 0 && cpi.common.refresh_alt_ref_frame == 0 {
        update_any_ref_buffers = 0;
    }

    if cm.no_lpf != 0 {
        cm.filter_level = 0;
    } else {
        if cpi.sf.auto_filter == 0 {
            if cpi.oxcf.noise_sensitivity != 0 && cm.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
                vp8cx_pick_filter_level_fast(cpi.denoiser.yv12_running_avg.data + INTRA_FRAME, cpi);
            } else {
                vp8cx_pick_filter_level_fast(cpi.source, cpi);
            }
        } else if cpi.oxcf.noise_sensitivity != 0 && cm.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
            vp8cx_pick_filter_level(cpi.denoiser.yv12_running_avg.data + INTRA_FRAME, cpi);
        } else {
            vp8cx_pick_filter_level(cpi.source, cpi);
        }

        if cm.filter_level > 0 {
            vp8cx_set_alt_lf_level(cpi, cm.filter_level);
        }
    }

    if atomic_load_acquire_in_onyx_if(*cpi.b_multi_threaded) != 0 {
        sem_post(*cpi.h_event_end_lpf);
    }

    if cm.filter_level > 0 && update_any_ref_buffers != 0 {
        vp8_loop_filter_frame(cm, *cpi.mb.e_mbd, cast,no_check(s32) FRAME_TYPE_);
    }

    vp8_yv12_extend_frame_borders_c(cm.frame_to_show);
}

process_denoiser_mode_change :: (cpi: *VP8_COMP) {
    CM := *cpi.common;
    j: s32 = ---;
    total: s32 = 0;
    num_blocks: s32 = 0;

    skip: s32 = 2;

    min_consec_zero_last := cast,no_check(s32) (12 / cpi.oxcf.number_of_layers);

    num_mode_change: s32 = 20;

    fac_framerate := (ifx c_transpiler_float_less(cpi.ref_framerate, 25.0) then cast(s32) 80 else 100);
    tot_num_blocks := CM.mb_rows * CM.mb_cols;
    ystride := cpi.source.y_stride;
    src: *u8 = cpi.source.y_buffer;
    dst: *u8 = cpi.denoiser.yv12_last_source.y_buffer;
    bandwidth := cpi.target_bandwidth;

    if cpi.oxcf.number_of_layers > 1 {
        lc := cpi.layer_context.data + cpi.oxcf.number_of_layers - 1;
        bandwidth = lc.target_bandwidth;
    }

    i: s32 = 0;
    while i < CM.height {
        block_index_row := i >> 4 * CM.mb_cols;
        j = 0;
        while j < CM.width {
            index := block_index_row + j >> 4;
            if cast,no_check(s32) cpi.consec_zero_last[index] >= min_consec_zero_last {
                sse: u32 = ---;
                VAR := variance16x16_c(src + j, ystride, dst + j, ystride, *sse);

                if sse - VAR < 128 {
                    sse2: u32 = ---;
                    ACT := variance16x16_c(src + j, ystride, CONST_SOURCE.data, 0, *sse2);
                    if ACT > 0 {
                        total = cast,no_check(s32) ((cast,no_check(u32) total) + (sse / ACT));
                    }
                    num_blocks += 1;
                }
            }
            j += 16 * skip;
        }
        src += 16 * skip * ystride;
        dst += 16 * skip * ystride;
        i += 16 * skip;
    }
    total = total * fac_framerate / 100;

    if total > 0 && num_blocks > tot_num_blocks >> 4 {
        total = total << 8 / num_blocks;
        if cpi.denoiser.nmse_source_diff_count == 0 {
            cpi.denoiser.nmse_source_diff = total;
            cpi.denoiser.qp_avg = CM.base_qindex;
        } else {
            cpi.denoiser.nmse_source_diff = (total + 3 * cpi.denoiser.nmse_source_diff) >> 2;
            cpi.denoiser.qp_avg = (CM.base_qindex + 3 * cpi.denoiser.qp_avg) >> 2;
        }
        cpi.denoiser.nmse_source_diff_count += 1;
    }

    if cpi.denoiser.nmse_source_diff_count == num_mode_change {
        if cpi.denoiser.denoiser_mode == K_DENOISER_ON_YUV &&
            cpi.denoiser.nmse_source_diff > cpi.denoiser.threshold_aggressive_mode &&
            cpi.denoiser.qp_avg < cpi.denoiser.qp_threshold_up &&
            bandwidth > cpi.denoiser.bitrate_threshold {
            vp8_denoiser_set_parameters(*cpi.denoiser, cast,no_check(s32) (K_DENOISER_ON_YUV_AGGRESSIVE));
        } else if cpi.denoiser.denoiser_mode == K_DENOISER_ON_YUV_AGGRESSIVE &&
            cpi.denoiser.nmse_source_diff < cpi.denoiser.threshold_aggressive_mode ||
            cpi.denoiser.denoiser_mode == K_DENOISER_ON_YUV_AGGRESSIVE &&
                (cpi.denoiser.qp_avg > cpi.denoiser.qp_threshold_down || bandwidth < cpi.denoiser.bitrate_threshold) {
            vp8_denoiser_set_parameters(*cpi.denoiser, cast,no_check(s32) (K_DENOISER_ON_YUV));
        }

        cpi.denoiser.nmse_source_diff = 0;
        cpi.denoiser.qp_avg = 0;
        cpi.denoiser.nmse_source_diff_count = 0;
    }
}

measure_square_diff_partial :: (source: *YV12_BUFFER_CONFIG, dest: *YV12_BUFFER_CONFIG, cpi: *VP8_COMP) -> s32 {
    j: s32 = ---;
    total: s32 = 0;
    num_blocks: s32 = 0;
    skip: s32 = 2;
    min_consec_zero_last: s32 = 10;
    tot_num_blocks := (source.y_height * source.y_width) >> 8;
    src: *u8 = source.y_buffer;
    dst: *u8 = dest.y_buffer;

    i: s32 = 0;
    while i < source.y_height {
        block_index_row := i >> 4 * cpi.common.mb_cols;
        j = 0;
        while j < source.y_width {
            index := block_index_row + j >> 4;
            if cast,no_check(s32) cpi.consec_zero_last[index] >= min_consec_zero_last {
                sse: u32 = ---;
                c_transpiler_compound_add(*(total), (mse16x16_c(src + j, source.y_stride, dst + j, dest.y_stride, *sse)), u32, u32);
                num_blocks += 1;
            }
            j += 16 * skip;
        }
        src += 16 * skip * source.y_stride;
        dst += 16 * skip * dest.y_stride;
        i += 16 * skip;
    }

    if num_blocks > tot_num_blocks >> 4 {
        return total / num_blocks;
    } else {
        return 0;
    }
}

vp8_calc_ss_err :: (source: *YV12_BUFFER_CONFIG, dest: *YV12_BUFFER_CONFIG) -> s32 {
    j: s32 = ---;
    total: s32 = 0;

    src: *u8 = source.y_buffer;
    dst: *u8 = dest.y_buffer;

    i: s32 = 0;
    while i < source.y_height {
        j = 0;
        while j < source.y_width {
            sse: u32 = ---;
            c_transpiler_compound_add(*(total), (mse16x16_c(src + j, source.y_stride, dst + j, dest.y_stride, *sse)), u32, u32);
            j += 16;
        }

        src += 16 * source.y_stride;
        dst += 16 * dest.y_stride;
        i += 16;
    }

    return total;
}

recode_loop_test :: (cpi: *VP8_COMP, high_limit: s32, low_limit: s32, q: s32, maxq: s32, minq: s32) -> s32 {
    force_recode: s32 = 0;
    cm := *cpi.common;

    if cpi.sf.recode_loop == 1 ||
        cpi.sf.recode_loop == 2 &&
            (cm.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon ||
                cm.refresh_golden_frame != 0 ||
                cm.refresh_alt_ref_frame != 0) {
        if cpi.projected_frame_size > high_limit && q < maxq || cpi.projected_frame_size < low_limit && q > minq {
            force_recode = 1;
        } else if cpi.oxcf.end_usage == USAGE_CONSTRAINED_QUALITY {
            if q > cpi.cq_target_quality && cpi.projected_frame_size < (cpi.this_frame_target * 7) >> 3 {
                force_recode = 1;
            } else if q > cpi.oxcf.cq_level &&
                cpi.projected_frame_size < cpi.min_frame_bandwidth &&
                cpi.active_best_quality > cpi.oxcf.cq_level {
                force_recode = 1;
                cpi.active_best_quality = cpi.oxcf.cq_level;
            }
        }
    }

    return force_recode;
}

decide_key_frame :: (cpi: *VP8_COMP) -> s32 {
    cm := *cpi.common;

    code_key_frame: s32 = 0;

    cpi.kf_boost = 0;

    if cpi.speed > 11 {
        return 0;
    }

    if cpi.compressor_speed == 2 && cpi.speed >= 5 && cpi.sf.rd == 0 {
        change :=
            (1.0 * cast,no_check(float64) absolute_value(cast,no_check(s32) (cpi.mb.intra_error - cpi.last_intra_error))) /
                (1 + cpi.last_intra_error);
        change2 :=
            (1.0 * cast,no_check(float64) absolute_value(cast,no_check(s32) (cpi.mb.prediction_error - cpi.last_prediction_error))) /
                (1 + cpi.last_prediction_error);
        minerror := cast,no_check(float64) (cm.m_bs * 256);

        cpi.last_intra_error = cpi.mb.intra_error;
        cpi.last_prediction_error = cpi.mb.prediction_error;

        if 10 * cpi.mb.intra_error / (1 + cpi.mb.prediction_error) < 15 &&
            c_transpiler_float_greater(cast,no_check(float64) cpi.mb.prediction_error, minerror) &&
            (c_transpiler_float_greater(change, 0.25) || c_transpiler_float_greater(change2, 0.25)) {
            return 1;
        }

        return 0;
    }

    if cpi.this_frame_percent_intra == 100 && cpi.this_frame_percent_intra > cpi.last_frame_percent_intra + 2 ||
        cpi.this_frame_percent_intra > 95 && cpi.this_frame_percent_intra >= cpi.last_frame_percent_intra + 5 {
        code_key_frame = 1;
    } else if cpi.this_frame_percent_intra > 60 && cpi.this_frame_percent_intra > cpi.last_frame_percent_intra * 2 ||
        cpi.this_frame_percent_intra > 75 && cpi.this_frame_percent_intra > cpi.last_frame_percent_intra * 3 / 2 ||
        cpi.this_frame_percent_intra > 90 && cpi.this_frame_percent_intra > cpi.last_frame_percent_intra + 10 {
        if cm.refresh_golden_frame == 0 {
            code_key_frame = 1;
        }
    }

    return code_key_frame;
}

disable_segmentation :: (cpi: *VP8_COMP) {
    cpi.mb.e_mbd.segmentation_enabled = 0;
}

cyclic_background_refresh :: (cpi: *VP8_COMP, q: s32, lf_adjustment: s32) {
    seg_map := cpi.segmentation_map;
    feature_data: [2] [4] s8 = ---;
    i: s32 = ---;
    block_count := cpi.cyclic_refresh_mode_max_mbs_perframe;
    mbs_in_frame := cpi.common.mb_rows * cpi.common.mb_cols;

    cpi.cyclic_refresh_q = q / 2;

    if cpi.oxcf.screen_content_mode != 0 {
        qp_thresh := (ifx cpi.oxcf.screen_content_mode == 2 then cast(s32) 80 else 100);
        if q >= qp_thresh {
            cpi.cyclic_refresh_mode_max_mbs_perframe = cpi.common.mb_rows * cpi.common.mb_cols / 10;
        } else if cpi.frames_since_key > 250 &&
            q < 20 &&
            cpi.mb.skip_true_count > cast,no_check(s32) (0.95 * cast,no_check(float64) mbs_in_frame) {
            cpi.cyclic_refresh_mode_max_mbs_perframe = 0;
        } else {
            cpi.cyclic_refresh_mode_max_mbs_perframe = cpi.common.mb_rows * cpi.common.mb_cols / 20;
        }
        block_count = cpi.cyclic_refresh_mode_max_mbs_perframe;
    }

    fill_memory(cpi.segmentation_map, 0, cast,no_check(u64) mbs_in_frame);

    if cpi.common.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon && block_count > 0 {
        i = cpi.cyclic_refresh_mode_index;

        while true {
            if cpi.cyclic_refresh_map[i] == 0 {
                seg_map[i] = 1;
                block_count -= 1;
            } else if cpi.cyclic_refresh_map[i] < 0 {
                cpi.cyclic_refresh_map[i] += 1;
            }

            i += 1;
            if i == mbs_in_frame {
                i = 0;
            }
            if !(block_count != 0 && i != cpi.cyclic_refresh_mode_index) break;
        }

        cpi.cyclic_refresh_mode_index = i;

        if cpi.oxcf.noise_sensitivity > 0 {
            if cpi.denoiser.denoiser_mode == K_DENOISER_ON_YUV_AGGRESSIVE &&
                q < cast,no_check(s32) cpi.denoiser.denoise_pars.qp_thresh &&
                cpi.frames_since_key > 2 * cpi.denoiser.denoise_pars.consec_zerolast {
                cpi.cyclic_refresh_q = q;

                lf_adjustment = -40;
                i = 0;
                while i < mbs_in_frame {
                    seg_map[i] =
                        cast(u8) (cast,no_check(u32) cpi.consec_zero_last[i] > cpi.denoiser.denoise_pars.consec_zerolast);
                    i += 1;
                }
            }
        }
    }

    cpi.mb.e_mbd.update_mb_segmentation_map = 1;
    cpi.mb.e_mbd.update_mb_segmentation_data = 1;
    enable_segmentation(cpi);

    feature_data[MB_LVL_ALT_Q][0] = 0;
    feature_data[MB_LVL_ALT_Q][1] = cast,no_check(s8) (cpi.cyclic_refresh_q - q);
    feature_data[MB_LVL_ALT_Q][2] = 0;
    feature_data[MB_LVL_ALT_Q][3] = 0;

    feature_data[MB_LVL_ALT_LF][0] = 0;
    feature_data[MB_LVL_ALT_LF][1] = cast,no_check(s8) lf_adjustment;
    feature_data[MB_LVL_ALT_LF][2] = 0;
    feature_data[MB_LVL_ALT_LF][3] = 0;

    set_segment_data(cpi, feature_data[0].data + 0, 0);
}

set_segment_data :: (cpi: *VP8_COMP, feature_data: *s8, abs_delta: u8) {
    cpi.mb.e_mbd.mb_segment_abs_delta = abs_delta;
    copy_memory(cpi.segment_feature_data.data, feature_data, cpi.segment_feature_data.count * size_of([4] s8));
}

enable_segmentation :: (cpi: *VP8_COMP) {
    cpi.mb.e_mbd.segmentation_enabled = 1;
    cpi.mb.e_mbd.update_mb_segmentation_map = 1;
    cpi.mb.e_mbd.update_mb_segmentation_data = 1;
}

resize_key_frame :: (cpi: *VP8_COMP) -> s32 {
    cm := *cpi.common;

    if cpi.oxcf.allow_spatial_resampling != 0 && cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER {
        hr, hs, vr, vs: s32 = ---;

        if cpi.buffer_level < (cast(s64) cpi.oxcf.resample_down_water_mark) * cpi.oxcf.optimal_buffer_level / 100 {
            cm.horiz_scale =
                ifx cm.horiz_scale < VP8E_ONETWO then cm.horiz_scale +
                    1 else cast,no_check(s32) (VP8E_ONETWO);
            cm.vert_scale =
                ifx cm.vert_scale < VP8E_ONETWO then cm.vert_scale +
                    1 else cast,no_check(s32) (VP8E_ONETWO);
        } else if cpi.buffer_level > (cast(s64) cpi.oxcf.resample_up_water_mark) * cpi.oxcf.optimal_buffer_level / 100 {
            cm.horiz_scale =
                ifx cm.horiz_scale > VP8E_NORMAL then cm.horiz_scale -
                    1 else cast,no_check(s32) (VP8E_NORMAL);
            cm.vert_scale =
                ifx cm.vert_scale > VP8E_NORMAL then cm.vert_scale -
                    1 else cast,no_check(s32) (VP8E_NORMAL);
        }

        scale2_ratio_in_onyx_if(cm.horiz_scale, *hr, *hs);
        scale2_ratio_in_onyx_if(cm.vert_scale, *vr, *vs);
        new_width := (hs - 1 + cpi.oxcf.width * hr) / hs;
        new_height := (vs - 1 + cpi.oxcf.height * vr) / vs;

        if cm.width != new_width || cm.height != new_height {
            cm.width = new_width;
            cm.height = new_height;
            vp8_alloc_compressor_data(cpi);
            scale_and_extend_source(cpi.un_scaled_source, cpi);
            return 1;
        }
    }

    return 0;
}

scale_and_extend_source :: (sd: *YV12_BUFFER_CONFIG, cpi: *VP8_COMP) {
    cm := *cpi.common;

    if cm.horiz_scale != 0 || cm.vert_scale != 0 {
        hr, hs, vr, vs: s32 = ---;

        tmp_height: s32 = ifx cm.vert_scale == 3
            then cast(s32) 9
            else 11;

        scale2_ratio_in_onyx_if(cm.horiz_scale, *hr, *hs);
        scale2_ratio_in_onyx_if(cm.vert_scale, *vr, *vs);

        scale_frame(
            sd,
            *cpi.scaled_source,
            cm.temp_scale_frame.y_buffer,
            cast,no_check(u8) tmp_height,
            cast,no_check(u32) hs,
            cast,no_check(u32) hr,
            cast,no_check(u32) vs,
            cast,no_check(u32) vr,
            0
        );

        vp8_yv12_extend_frame_borders_c(*cpi.scaled_source);
        cpi.source = *cpi.scaled_source;
    } else {
        cpi.source = sd;
    }
}

compute_skin_map :: (cpi: *VP8_COMP) {
    mb_col: s32 = ---;
    cm := *cpi.common;
    src_y := cpi.source.y_buffer;
    src_u := cpi.source.u_buffer;
    src_v := cpi.source.v_buffer;
    SRC_YSTRIDE := cpi.source.y_stride;
    SRC_UVSTRIDE := cpi.source.uv_stride;

    BSIZE :=
        cast,no_check(SKIN_DETECTION_BLOCK_SIZE) ((ifx cm.width * cm.height <= 352 *
            288 then cast,no_check(s32) (SKIN_8X8) else cast,no_check(s32) (SKIN_16X16)));

    mb_row: s32 = 0;
    while mb_row < cm.mb_rows {
        num_bl: s32 = 0;
        mb_col = 0;
        while mb_col < cm.mb_cols {
            BL_INDEX := mb_row * cm.mb_cols + mb_col;
            cpi.skin_map[BL_INDEX] =
                cast,no_check(u8) (cast,no_check(#type (_: *u8, _: *u8, _: *u8, _: s32, _: s32, _: SKIN_DETECTION_BLOCK_SIZE, _: s32, _: s32) -> s32) (cast(*void) vp8_compute_skin_block))(
                    src_y,
                    src_u,
                    src_v,
                    SRC_YSTRIDE,
                    SRC_UVSTRIDE,
                    BSIZE,
                    cast,no_check(s32) cpi.consec_zero_last[BL_INDEX],
                    0
                );
            num_bl += 1;
            src_y += 16;
            src_u += 8;
            src_v += 8;
            mb_col += 1;
        }
        src_y += SRC_YSTRIDE << 4 - num_bl << 4;
        src_u += SRC_UVSTRIDE << 3 - num_bl << 3;
        src_v += SRC_UVSTRIDE << 3 - num_bl << 3;
        mb_row += 1;
    }

    mb_row = 1;
    while mb_row < cm.mb_rows - 1 {
        mb_col = 1;
        while mb_col < cm.mb_cols - 1 {
            BL_INDEX := mb_row * cm.mb_cols + mb_col;
            num_neighbor: s32 = 0;
            mj: s32 = ---;
            non_skin_threshold: s32 = 8;

            mi: s32 = -1;
            while mi <= 1 {
                mj = -1;
                while mj <= 1 {
                    bl_neighbor_index := (mb_row + mi) * cm.mb_cols + mb_col + mj;
                    if cpi.skin_map[bl_neighbor_index] != 0 {
                        num_neighbor += 1;
                    }
                    mj += 1;
                }
                mi += 1;
            }

            if cpi.skin_map[BL_INDEX] != 0 && num_neighbor < 2 {
                cpi.skin_map[BL_INDEX] = 0;
            }
            if cpi.skin_map[BL_INDEX] == 0 && num_neighbor == non_skin_threshold {
                cpi.skin_map[BL_INDEX] = 1;
            }
            mb_col += 1;
        }
        mb_row += 1;
    }
}

vp8_check_drop_buffer :: (cpi: *VP8_COMP) -> s32 {
    cm := *cpi.common;
    drop_mark := cast,no_check(s32) ((cast(s64) cpi.oxcf.drop_frames_water_mark) * cpi.oxcf.optimal_buffer_level / 100);
    drop_mark75 := drop_mark * 2 / 3;
    drop_mark50 := drop_mark / 4;
    drop_mark25 := drop_mark / 8;
    if cpi.drop_frames_allowed != 0 {
        if cpi.buffer_level > cast,no_check(s64) drop_mark && cpi.decimation_factor > 0 {
            cpi.decimation_factor -= 1;
        }

        if cpi.buffer_level > cast,no_check(s64) drop_mark75 && cpi.decimation_factor > 0 {
            cpi.decimation_factor = 1;
        } else if cpi.buffer_level < cast,no_check(s64) drop_mark25 && (cpi.decimation_factor == 2 || cpi.decimation_factor == 3) {
            cpi.decimation_factor = 3;
        } else if cpi.buffer_level < cast,no_check(s64) drop_mark50 && (cpi.decimation_factor == 1 || cpi.decimation_factor == 2) {
            cpi.decimation_factor = 2;
        } else if cpi.buffer_level < cast,no_check(s64) drop_mark75 && (cpi.decimation_factor == 0 || cpi.decimation_factor == 1) {
            cpi.decimation_factor = 1;
        }
    }

    if cpi.decimation_factor > 0 && cpi.drop_frames_allowed != 0 {
        if cpi.decimation_factor == {
            case 1;
                cpi.per_frame_bandwidth = cpi.per_frame_bandwidth * 3 / 2;
            case 2;
                cpi.per_frame_bandwidth = cpi.per_frame_bandwidth * 5 / 4;
            case 3;
                cpi.per_frame_bandwidth = cpi.per_frame_bandwidth * 5 / 4;
        }

        if cm.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
            cpi.decimation_count = cpi.decimation_factor;
        } else if cpi.decimation_count > 0 {
            cpi.decimation_count -= 1;

            cpi.bits_off_target += cast,no_check(s64) cpi.av_per_frame_bandwidth;
            if cpi.bits_off_target > cpi.oxcf.maximum_buffer_size {
                cpi.bits_off_target = cpi.oxcf.maximum_buffer_size;
            }

            cm.current_video_frame += 1;
            cpi.frames_since_key += 1;
            cpi.ext_refresh_frame_flags_pending = 0;

            cpi.temporal_pattern_counter += 1;

            cpi.buffer_level = cpi.bits_off_target;

            if cpi.oxcf.number_of_layers > 1 {
                i := cpi.current_layer + 1;
                while i < cpi.oxcf.number_of_layers {
                    lc := cpi.layer_context.data + i;
                    lc.bits_off_target += cast,no_check(s64) (cast,no_check(s32) (lc.target_bandwidth / lc.framerate));
                    if lc.bits_off_target > lc.maximum_buffer_size {
                        lc.bits_off_target = lc.maximum_buffer_size;
                    }
                    lc.buffer_level = lc.bits_off_target;
                    i += 1;
                }
            }
            return 1;
        } else {
            cpi.decimation_count = cpi.decimation_factor;
        }
    } else {
        cpi.decimation_count = 0;
    }
    return 0;
}

update_rd_ref_frame_probs :: (cpi: *VP8_COMP) {
    cm := *cpi.common;

    RFCT := cpi.mb.count_mb_ref_frame_usage.data;
    RF_INTRA := RFCT[INTRA_FRAME];
    RF_INTER := RFCT[LAST_FRAME] + RFCT[GOLDEN_FRAME] + RFCT[ALTREF_FRAME];

    if cm.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
        cpi.prob_intra_coded = 255;
        cpi.prob_last_coded = 128;
        cpi.prob_gf_coded = 128;
    } else if RF_INTRA + RF_INTER == 0 {
        cpi.prob_intra_coded = 63;
        cpi.prob_last_coded = 128;
        cpi.prob_gf_coded = 128;
    }

    if cpi.oxcf.number_of_layers == 1 {
        if cpi.common.refresh_alt_ref_frame != 0 {
            cpi.prob_intra_coded += 40;
            if cpi.prob_intra_coded > 255 {
                cpi.prob_intra_coded = 255;
            }
            cpi.prob_last_coded = 200;
            cpi.prob_gf_coded = 1;
        } else if cpi.frames_since_golden == 0 {
            cpi.prob_last_coded = 214;
        } else if cpi.frames_since_golden == 1 {
            cpi.prob_last_coded = 192;
            cpi.prob_gf_coded = 220;
        } else if cpi.source_alt_ref_active != 0 {
            cpi.prob_gf_coded -= 20;

            if cpi.prob_gf_coded < 10 {
                cpi.prob_gf_coded = 10;
            }
        }
        if cpi.source_alt_ref_active == 0 {
            cpi.prob_gf_coded = 255;
        }
    }
}

pass2_encode :: (cpi: *VP8_COMP, size: *u64, dest: *u8, dest_end: *u8, frame_flags: *u32) {
    if cpi.common.refresh_alt_ref_frame == 0 {
        vp8_second_pass(cpi);
    }

    encode_frame_to_data_rate(cpi, size, dest, dest_end, frame_flags);
    cpi.twopass.bits_left -= cast,no_check(s64) (8 * cast,no_check(s32) size.*);

    if cpi.common.refresh_alt_ref_frame == 0 {
        two_pass_min_rate :=
            cast,no_check(float64) ((cpi.oxcf.target_bandwidth * cast,no_check(u32) cpi.oxcf.two_pass_vbrmin_section) /
                100);
        cpi.twopass.bits_left += cast,no_check(s64) (two_pass_min_rate / cpi.framerate);
    }
}

pass1_encode :: (cpi: *VP8_COMP) {
    vp8_set_quantizer(cpi, 26);
    vp8_first_pass(cpi);
}

usec_timer_start_in_onyx_if :: (t: *Usec_Timer) {
    clock_gettime(4, *t.begin);
}

vp8_update_layer_contexts :: (cpi: *VP8_COMP) {
    oxcf := *cpi.oxcf;

    if oxcf.number_of_layers > 1 {
        prev_layer_framerate: float64 = 0.0;

        i: u32 = 0;
        while i < oxcf.number_of_layers && i < 5 {
            lc := cpi.layer_context.data + i;

            lc.framerate = cpi.ref_framerate / oxcf.rate_decimator[i];
            if oxcf.target_bitrate[i] > cast,no_check(u32) (2147483647 / 1000) {
                lc.target_bandwidth = 2147483647;
            } else {
                lc.target_bandwidth = cast,no_check(s32) (oxcf.target_bitrate[i] * 1000);
            }

            lc.starting_buffer_level =
                cast,no_check(s64) rescale(
                    cast,no_check(s32) oxcf.starting_buffer_level_in_ms,
                    lc.target_bandwidth,
                    1000
                );

            if oxcf.optimal_buffer_level == 0 {
                lc.optimal_buffer_level = cast,no_check(s64) (lc.target_bandwidth / 8);
            } else {
                lc.optimal_buffer_level =
                    cast,no_check(s64) rescale(
                        cast,no_check(s32) oxcf.optimal_buffer_level_in_ms,
                        lc.target_bandwidth,
                        1000
                    );
            }

            if oxcf.maximum_buffer_size == 0 {
                lc.maximum_buffer_size = cast,no_check(s64) (lc.target_bandwidth / 8);
            } else {
                lc.maximum_buffer_size =
                    cast,no_check(s64) rescale(
                        cast,no_check(s32) oxcf.maximum_buffer_size_in_ms,
                        lc.target_bandwidth,
                        1000
                    );
            }

            if i > 0 {
                lc.avg_frame_size_for_layer =
                    cast,no_check(s32) c_transpiler_math_round(
                        ((oxcf.target_bitrate[i] - oxcf.target_bitrate[i - 1]) * 1000) /
                        (lc.framerate - prev_layer_framerate)
                    );
            }

            prev_layer_framerate = lc.framerate;
            i += 1;
        }
    }
}

vp8_get_preview_raw_frame :: (cpi: *VP8_COMP, dest: *YV12_BUFFER_CONFIG, flags: *Vp8_Ppflags_T) -> s32 {
    if cpi.common.refresh_alt_ref_frame != 0 {
        return -1;
    } else {
        ret: s32 = ---;

        if cpi.common.frame_to_show != null {
            dest.* = cpi.common.frame_to_show.*;
            dest.y_width = cpi.common.width;
            dest.y_height = cpi.common.height;
            dest.uv_height = cpi.common.height / 2;
            ret = 0;
        } else {
            ret = -1;
        }

        return ret;
    }
}

vp8_use_as_reference :: (cpi: *VP8_COMP, ref_frame_flags: s32) -> s32 {
    if ref_frame_flags > 7 {
        return -1;
    }

    cpi.ref_frame_flags = ref_frame_flags;
    return 0;
}

vp8_update_reference :: (cpi: *VP8_COMP, ref_frame_flags: s32) -> s32 {
    if ref_frame_flags > 7 {
        return -1;
    }

    cpi.common.refresh_golden_frame = 0;
    cpi.common.refresh_alt_ref_frame = 0;
    cpi.common.refresh_last_frame = 0;

    if ref_frame_flags & cast,no_check(s32) (VP8_LAST_FRAME) != 0 {
        cpi.common.refresh_last_frame = 1;
    }

    if ref_frame_flags & cast,no_check(s32) (VP8_GOLD_FRAME) != 0 {
        cpi.common.refresh_golden_frame = 1;
    }

    if ref_frame_flags & cast,no_check(s32) (VP8_ALTR_FRAME) != 0 {
        cpi.common.refresh_alt_ref_frame = 1;
    }

    cpi.ext_refresh_frame_flags_pending = 1;
    return 0;
}

vp8_get_reference :: (cpi: *VP8_COMP, ref_frame_flag: Ref_Frame_Type, sd: *YV12_BUFFER_CONFIG) -> s32 {
    cm := *cpi.common;
    ref_fb_idx: s32 = ---;

    if ref_frame_flag == cast,no_check(u32) VP8_LAST_FRAME {
        ref_fb_idx = cm.lst_fb_idx;
    } else if ref_frame_flag == cast,no_check(u32) VP8_GOLD_FRAME {
        ref_fb_idx = cm.gld_fb_idx;
    } else if ref_frame_flag == cast,no_check(u32) VP8_ALTR_FRAME {
        ref_fb_idx = cm.alt_fb_idx;
    } else {
        return -1;
    }

    if cm.yv12_fb[ref_fb_idx].y_width != sd.y_width || cm.yv12_fb[ref_fb_idx].y_height != sd.y_height {
        return -1;
    }

    vp8_yv12_copy_frame_c(cm.yv12_fb.data + ref_fb_idx, sd);

    return 0;
}

vp8_set_reference :: (cpi: *VP8_COMP, ref_frame_flag: Ref_Frame_Type, sd: *YV12_BUFFER_CONFIG) -> s32 {
    cm := *cpi.common;

    ref_fb_idx: s32 = ---;

    if ref_frame_flag == cast,no_check(u32) VP8_LAST_FRAME {
        ref_fb_idx = cm.lst_fb_idx;
    } else if ref_frame_flag == cast,no_check(u32) VP8_GOLD_FRAME {
        ref_fb_idx = cm.gld_fb_idx;
    } else if ref_frame_flag == cast,no_check(u32) VP8_ALTR_FRAME {
        ref_fb_idx = cm.alt_fb_idx;
    } else {
        return -1;
    }

    if cm.yv12_fb[ref_fb_idx].y_width != sd.y_width || cm.yv12_fb[ref_fb_idx].y_height != sd.y_height {
        return -1;
    }

    vp8_yv12_copy_frame_c(sd, cm.yv12_fb.data + ref_fb_idx);

    return 0;
}

vp8_update_entropy :: (cpi: *VP8_COMP, update: s32) -> s32 {
    cm := *cpi.common;
    cm.refresh_entropy_probs = update;

    return 0;
}

vp8_set_roimap :: (
    cpi: *VP8_COMP,
    map: *u8,
    rows: u32,
    cols: u32,
    delta_q: *s32,
    delta_lf: *s32,
    threshold: *u32
) -> s32 {
    feature_data: [2] [4] s8 = ---;
    internal_delta_q: [4] s32 = ---;
    RANGE: s32 = 63;

    if cpi.common.mb_rows != cast,no_check(s32) rows || cpi.common.mb_cols != cast,no_check(s32) cols {
        return -1;
    }

    for i: 0..cast(s32) 4 - 1 {
        if delta_q[i] > RANGE || delta_q[i] < -RANGE || delta_lf[i] > RANGE || delta_lf[i] < -RANGE {
            return -1;
        }
    }

    if map == null ||
        delta_q[0] == 0 &&
            delta_q[1] == 0 &&
            delta_q[2] == 0 &&
            delta_q[3] == 0 &&
            delta_lf[0] == 0 &&
            delta_lf[1] == 0 &&
            delta_lf[2] == 0 &&
            delta_lf[3] == 0 &&
            threshold[0] == 0 &&
            threshold[1] == 0 &&
            threshold[2] == 0 &&
            threshold[3] == 0 {
        disable_segmentation(cpi);
        return 0;
    }

    for i: 0..cast(s32) 4 - 1 {
        internal_delta_q[i] = ifx delta_q[i] >= 0 then Q_TRANS[delta_q[i]] else -Q_TRANS[-delta_q[i]];
    }

    set_segmentation_map(cpi, map);

    enable_segmentation(cpi);

    feature_data[MB_LVL_ALT_Q][0] = cast,no_check(s8) internal_delta_q[0];
    feature_data[MB_LVL_ALT_Q][1] = cast,no_check(s8) internal_delta_q[1];
    feature_data[MB_LVL_ALT_Q][2] = cast,no_check(s8) internal_delta_q[2];
    feature_data[MB_LVL_ALT_Q][3] = cast,no_check(s8) internal_delta_q[3];

    feature_data[MB_LVL_ALT_LF][0] = cast,no_check(s8) delta_lf[0];
    feature_data[MB_LVL_ALT_LF][1] = cast,no_check(s8) delta_lf[1];
    feature_data[MB_LVL_ALT_LF][2] = cast,no_check(s8) delta_lf[2];
    feature_data[MB_LVL_ALT_LF][3] = cast,no_check(s8) delta_lf[3];

    cpi.segment_encode_breakout[0] = threshold[0];
    cpi.segment_encode_breakout[1] = threshold[1];
    cpi.segment_encode_breakout[2] = threshold[2];
    cpi.segment_encode_breakout[3] = threshold[3];

    set_segment_data(cpi, feature_data[0].data + 0, 0);

    if threshold[0] != 0 || threshold[1] != 0 || threshold[2] != 0 || threshold[3] != 0 {
        cpi.use_roi_static_threshold = 1;
    }
    cpi.cyclic_refresh_mode_enabled = 0;

    return 0;
}

set_segmentation_map :: (cpi: *VP8_COMP, segmentation_map: *u8) {
    copy_memory(cpi.segmentation_map, segmentation_map, cast,no_check(u64) (cpi.common.mb_rows * cpi.common.mb_cols));

    cpi.mb.e_mbd.update_mb_segmentation_map = 1;
    cpi.mb.e_mbd.update_mb_segmentation_data = 1;
}

vp8_set_active_map :: (cpi: *VP8_COMP, map: *u8, rows: u32, cols: u32) -> s32 {
    if cast,no_check(s32) rows == cpi.common.mb_rows && cast,no_check(s32) cols == cpi.common.mb_cols {
        if map != null {
            copy_memory(cpi.active_map, map, cast,no_check(u64) (rows * cols));
            cpi.active_map_enabled = 1;
        } else {
            cpi.active_map_enabled = 0;
        }

        return 0;
    } else {
        return -1;
    }
}

vp8_set_internal_size :: (cpi: *VP8_COMP, horiz_mode: SCALING_MODE, vert_mode: SCALING_MODE) -> s32 {
    if horiz_mode <= cast,no_check(u32) VP8E_ONETWO {
        cpi.common.horiz_scale = cast,no_check(s32) horiz_mode;
    } else {
        return -1;
    }

    if vert_mode <= cast,no_check(u32) VP8E_ONETWO {
        cpi.common.vert_scale = cast,no_check(s32) vert_mode;
    } else {
        return -1;
    }

    return 0;
}

vp8_get_quantizer :: (cpi: *VP8_COMP) -> s32 {
    return cpi.common.base_qindex;
}

validate_buffer_in_onyx_if :: (start: *u8, len: u64, end: *u8, error: *Internal_Error_Info) -> s32 {
    if start + len > start && start + len < end {
        return 1;
    } else {
        internal_error(
            error,
            cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
            c_string("Truncated packet or corrupt partition ")
        );
    }

    return 0;
}

vp8_encode_bool_in_onyx_if :: (bc: *BOOL_CODER, bit: s32, probability: s32) {
    count := bc.count;
    range := bc.range;
    lowvalue := bc.lowvalue;

    split := 1 + ((range - 1) * cast,no_check(u32) probability) >> 8;

    range = split;

    if bit != 0 {
        lowvalue += split;
        range = bc.range - split;
    }

    shift := cast,no_check(s32) VP8_NORM[range];

    c_transpiler_compound_shl(*(range), (((cast,no_check(u32) shift) & 31)), u32, u32);
    count += shift;

    if count >= 0 {
        offset := shift - count;

        if lowvalue << (((offset - 1)) & 31) & 0x80000000 != 0 {
            x := cast,no_check(s32) (bc.pos - 1);

            while x >= 0 && bc.buffer[x] == 0xff {
                bc.buffer[x] = 0;
                x -= 1;
            }

            bc.buffer[x] = cast,no_check(u8) ((cast,no_check(s32) bc.buffer[x]) + 1);
        }

        validate_buffer_in_onyx_if(bc.buffer + bc.pos, 1, bc.buffer_end, bc.error);
        bc.buffer[bc.pos] = cast,no_check(u8) (lowvalue >> (((24 - offset)) & 31) & 0xff);
        bc.pos += 1;

        shift = count;
        lowvalue =
            cast,no_check(u32) (cast,no_check(s32) ((cast,no_check(u64) lowvalue) << ((offset) & 63) & 0xffffff));
        count -= 8;
    }

    c_transpiler_compound_shl(*(lowvalue), (((cast,no_check(u32) shift) & 31)), u32, u32);
    bc.count = count;
    bc.lowvalue = lowvalue;
    bc.range = range;
}

vp8_cost_branch_in_onyx_if :: (ct: *u32, p: Vp8_Prob) -> u32 {
    return cast,no_check(u32) ((((cast,no_check(u64) ct[0]) * cast(u64) VP8_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP8_PROB_COST[255 - cast(s32) p]) >> 8);
}

vp8_treed_write_in_onyx_if :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) {
    i: Vp8_Tree_Index = 0;

    while true {
        {
            B := v >> ((c_transpiler_pre_decrement(*(n))) & 31) & 1;
            vp8_encode_bool_in_onyx_if(W, B, cast,no_check(s32) P[(cast(s32) i) >> 1]);
            i = t[(cast(s32) i) + B];
        }
        if n == 0 break;
    }
}

vp8_write_token_in_onyx_if :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) {
    vp8_treed_write_in_onyx_if(W, t, P, X.value, X.len);
}

vp8_treed_cost_in_onyx_if :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) -> s32 {
    c: s32 = 0;
    i: Vp8_Tree_Index = 0;

    while true {
        {
            B := v >> ((c_transpiler_pre_decrement(*(n))) & 31) & 1;
            c_transpiler_compound_add(*(c), (VP8_PROB_COST[(ifx B != 0 then 255 - cast(s32) P[(cast(s32) i) >> 1] else cast,no_check(s32) P[(cast(s32) i) >> 1])]), u32, u32);
            i = t[(cast(s32) i) + B];
        }
        if n == 0 break;
    }

    return c;
}

vp8_cost_token_in_onyx_if :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) -> s32 {
    return vp8_treed_cost_in_onyx_if(t, P, X.value, X.len);
}

mv_bias_in_onyx_if :: (refmb_ref_frame_sign_bias: s32, refframe: s32, mvp: *Int_Mv_in_mv, ref_frame_sign_bias: *s32) {
    if refmb_ref_frame_sign_bias != ref_frame_sign_bias[refframe] {
        mvp.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.row) * -1);
        mvp.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.col) * -1);
    }
}

vp8_clamp_mv2_in_onyx_if :: (mv: *Int_Mv_in_mv, xd: *MACROBLOCKD_in_blockd) {
    if cast,no_check(s32) mv.as_mv.col < xd.mb_to_left_edge - (cast(s32) 16) << 3 {
        mv.as_mv.col = cast,no_check(s16) (xd.mb_to_left_edge - (cast(s32) 16) << 3);
    } else if cast,no_check(s32) mv.as_mv.col > xd.mb_to_right_edge + (cast(s32) 16) << 3 {
        mv.as_mv.col = cast,no_check(s16) (xd.mb_to_right_edge + (cast(s32) 16) << 3);
    }

    if cast,no_check(s32) mv.as_mv.row < xd.mb_to_top_edge - (cast(s32) 16) << 3 {
        mv.as_mv.row = cast,no_check(s16) (xd.mb_to_top_edge - (cast(s32) 16) << 3);
    } else if cast,no_check(s32) mv.as_mv.row > xd.mb_to_bottom_edge + (cast(s32) 16) << 3 {
        mv.as_mv.row = cast,no_check(s16) (xd.mb_to_bottom_edge + (cast(s32) 16) << 3);
    }
}

vp8_clamp_mv_in_onyx_if :: (
    mv: *Int_Mv_in_mv,
    mb_to_left_edge: s32,
    mb_to_right_edge: s32,
    mb_to_top_edge: s32,
    mb_to_bottom_edge: s32
) {
    mv.as_mv.col =
        cast,no_check(s16) ((ifx cast,no_check(s32) mv.as_mv.col < mb_to_left_edge then mb_to_left_edge else cast,no_check(s32) mv.as_mv.col));
    mv.as_mv.col =
        cast,no_check(s16) ((ifx cast,no_check(s32) mv.as_mv.col > mb_to_right_edge then mb_to_right_edge else cast,no_check(s32) mv.as_mv.col));
    mv.as_mv.row =
        cast,no_check(s16) ((ifx cast,no_check(s32) mv.as_mv.row < mb_to_top_edge then mb_to_top_edge else cast,no_check(s32) mv.as_mv.row));
    mv.as_mv.row =
        cast,no_check(s16) ((ifx cast,no_check(s32) mv.as_mv.row > mb_to_bottom_edge then mb_to_bottom_edge else cast,no_check(s32) mv.as_mv.row));
}

vp8_check_mv_bounds_in_onyx_if :: (
    mv: *Int_Mv_in_mv,
    mb_to_left_edge: s32,
    mb_to_right_edge: s32,
    mb_to_top_edge: s32,
    mb_to_bottom_edge: s32
) -> u32 {
    need_to_clamp := cast(u32) (cast,no_check(s32) mv.as_mv.col < mb_to_left_edge);
    need_to_clamp |= cast(u32) (cast,no_check(s32) mv.as_mv.col > mb_to_right_edge);
    need_to_clamp |= cast(u32) (cast,no_check(s32) mv.as_mv.row < mb_to_top_edge);
    need_to_clamp |= cast(u32) (cast,no_check(s32) mv.as_mv.row > mb_to_bottom_edge);
    return need_to_clamp;
}

left_block_mv_in_onyx_if :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> u32 {
    if b & 3 == 0 {
        cur_mb -= 1;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 4;
    }

    return (((cur_mb.bmi.data + b - 1)).mv).as_int;
}

above_block_mv_in_onyx_if :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> u32 {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 16;
    }

    return (((cur_mb.bmi.data + (b - 4))).mv).as_int;
}

left_block_mode_in_onyx_if :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> B_PREDICTION_MODE {
    if b & 3 == 0 {
        cur_mb -= 1;
        if cast,no_check(s32) cur_mb.mbmi.mode == {
            case B_PRED;
                return ((cur_mb.bmi.data + b + 3)).as_mode;
            case DC_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_DC_PRED;
            case V_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_VE_PRED;
            case H_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_HE_PRED;
            case TM_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_TM_PRED;
            case;
                return cast,no_check(B_PREDICTION_MODE) B_DC_PRED;
        }
    }

    return ((cur_mb.bmi.data + b - 1)).as_mode;
}

above_block_mode_in_onyx_if :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> B_PREDICTION_MODE {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cast,no_check(s32) cur_mb.mbmi.mode == {
            case B_PRED;
                return ((cur_mb.bmi.data + b + 12)).as_mode;
            case DC_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_DC_PRED;
            case V_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_VE_PRED;
            case H_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_HE_PRED;
            case TM_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_TM_PRED;
            case;
                return cast,no_check(B_PREDICTION_MODE) B_DC_PRED;
        }
    }

    return ((cur_mb.bmi.data + b - 4)).as_mode;
}

vp8_initialize_enc :: () {
    once_in_onyx_if(cast,no_check(#type () #c_call) initialize_enc);
}

initialize_enc :: () #c_call {
    push_context {
        dsp_rtcd();
        vp8_init_intra_predictors();
    }
}

once_in_onyx_if :: (func: Once_In_Onyx_If_Parameter_0_Type) {
    pthread_once(*lock_in_onyx_if, cast,no_check(#type () #c_call) (func));
}

vp8_reverse_trans :: (x: s32) -> s32 {
    for i: 0..cast(s32) 64 - 1 {
        if Q_TRANS[i] >= x {
            return i;
        }
    }

    return 63;
}

globals_initialization_state_for_onyx_if: u32;
initialize_globals_for_onyx_if :: () {
    {
        state := atomic_load(*globals_initialization_state_for_onyx_if);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_onyx_if, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_onyx_if) != 2 {}
            return;
        }
    }
    lock_in_onyx_if = 0;
    KF_LOW_MOTION_MINQ =
        u8.[
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            2,
            2,
            2,
            2,
            3,
            3,
            3,
            3,
            3,
            3,
            4,
            4,
            4,
            5,
            5,
            5,
            5,
            5,
            6,
            6,
            6,
            6,
            7,
            7,
            8,
            8,
            8,
            8,
            9,
            9,
            10,
            10,
            10,
            10,
            11,
            11,
            11,
            11,
            12,
            12,
            13,
            13,
            13,
            13,
            14,
            14,
            15,
            15,
            15,
            15,
            16,
            16,
            16,
            16,
            17,
            17,
            18,
            18,
            18,
            18,
            19,
            20,
            20,
            21,
            21,
            22,
            23,
            23
        ];
    KF_HIGH_MOTION_MINQ =
        u8.[
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            2,
            2,
            2,
            2,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            4,
            4,
            4,
            4,
            5,
            5,
            5,
            5,
            5,
            5,
            6,
            6,
            6,
            6,
            7,
            7,
            8,
            8,
            8,
            8,
            9,
            9,
            10,
            10,
            10,
            10,
            11,
            11,
            11,
            11,
            12,
            12,
            13,
            13,
            13,
            13,
            14,
            14,
            15,
            15,
            15,
            15,
            16,
            16,
            16,
            16,
            17,
            17,
            18,
            18,
            18,
            18,
            19,
            19,
            20,
            20,
            20,
            20,
            21,
            21,
            21,
            21,
            22,
            22,
            23,
            23,
            24,
            25,
            25,
            26,
            26,
            27,
            28,
            28,
            29,
            30
        ];
    GF_LOW_MOTION_MINQ =
        u8.[
            0,
            0,
            0,
            0,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            2,
            2,
            2,
            2,
            3,
            3,
            3,
            3,
            4,
            4,
            4,
            4,
            5,
            5,
            5,
            5,
            6,
            6,
            6,
            6,
            7,
            7,
            7,
            7,
            8,
            8,
            8,
            8,
            9,
            9,
            9,
            9,
            10,
            10,
            10,
            10,
            11,
            11,
            12,
            12,
            13,
            13,
            14,
            14,
            15,
            15,
            16,
            16,
            17,
            17,
            18,
            18,
            19,
            19,
            20,
            20,
            21,
            21,
            22,
            22,
            23,
            23,
            24,
            24,
            25,
            25,
            26,
            26,
            27,
            27,
            28,
            28,
            29,
            29,
            30,
            30,
            31,
            31,
            32,
            32,
            33,
            33,
            34,
            34,
            35,
            35,
            36,
            36,
            37,
            37,
            38,
            38,
            39,
            39,
            40,
            40,
            41,
            41,
            42,
            42,
            43,
            44,
            45,
            46,
            47,
            48,
            49,
            50,
            51,
            52,
            53,
            54,
            55,
            56,
            57,
            58
        ];
    GF_MID_MOTION_MINQ =
        u8.[
            0,
            0,
            0,
            0,
            1,
            1,
            1,
            1,
            1,
            1,
            2,
            2,
            3,
            3,
            3,
            4,
            4,
            4,
            5,
            5,
            5,
            6,
            6,
            6,
            7,
            7,
            7,
            8,
            8,
            8,
            9,
            9,
            9,
            10,
            10,
            10,
            10,
            11,
            11,
            11,
            12,
            12,
            12,
            12,
            13,
            13,
            13,
            14,
            14,
            14,
            15,
            15,
            16,
            16,
            17,
            17,
            18,
            18,
            19,
            19,
            20,
            20,
            21,
            21,
            22,
            22,
            23,
            23,
            24,
            24,
            25,
            25,
            26,
            26,
            27,
            27,
            28,
            28,
            29,
            29,
            30,
            30,
            31,
            31,
            32,
            32,
            33,
            33,
            34,
            34,
            35,
            35,
            36,
            36,
            37,
            37,
            38,
            39,
            39,
            40,
            40,
            41,
            41,
            42,
            42,
            43,
            43,
            44,
            45,
            46,
            47,
            48,
            49,
            50,
            51,
            52,
            53,
            54,
            55,
            56,
            57,
            58,
            59,
            60,
            61,
            62,
            63,
            64
        ];
    GF_HIGH_MOTION_MINQ =
        u8.[
            0,
            0,
            0,
            0,
            1,
            1,
            1,
            1,
            1,
            2,
            2,
            2,
            3,
            3,
            3,
            4,
            4,
            4,
            5,
            5,
            5,
            6,
            6,
            6,
            7,
            7,
            7,
            8,
            8,
            8,
            9,
            9,
            9,
            10,
            10,
            10,
            11,
            11,
            12,
            12,
            13,
            13,
            14,
            14,
            15,
            15,
            16,
            16,
            17,
            17,
            18,
            18,
            19,
            19,
            20,
            20,
            21,
            21,
            22,
            22,
            23,
            23,
            24,
            24,
            25,
            25,
            26,
            26,
            27,
            27,
            28,
            28,
            29,
            29,
            30,
            30,
            31,
            31,
            32,
            32,
            33,
            33,
            34,
            34,
            35,
            35,
            36,
            36,
            37,
            37,
            38,
            38,
            39,
            39,
            40,
            40,
            41,
            41,
            42,
            42,
            43,
            44,
            45,
            46,
            47,
            48,
            49,
            50,
            51,
            52,
            53,
            54,
            55,
            56,
            57,
            58,
            59,
            60,
            62,
            64,
            66,
            68,
            70,
            72,
            74,
            76,
            78,
            80
        ];
    INTER_MINQ =
        u8.[
            0,
            0,
            1,
            1,
            2,
            3,
            3,
            4,
            4,
            5,
            6,
            6,
            7,
            8,
            8,
            9,
            9,
            10,
            11,
            11,
            12,
            13,
            13,
            14,
            15,
            15,
            16,
            17,
            17,
            18,
            19,
            20,
            20,
            21,
            22,
            22,
            23,
            24,
            24,
            25,
            26,
            27,
            27,
            28,
            29,
            30,
            30,
            31,
            32,
            33,
            33,
            34,
            35,
            36,
            36,
            37,
            38,
            39,
            39,
            40,
            41,
            42,
            42,
            43,
            44,
            45,
            46,
            46,
            47,
            48,
            49,
            50,
            50,
            51,
            52,
            53,
            54,
            55,
            55,
            56,
            57,
            58,
            59,
            60,
            60,
            61,
            62,
            63,
            64,
            65,
            66,
            67,
            67,
            68,
            69,
            70,
            71,
            72,
            73,
            74,
            75,
            75,
            76,
            77,
            78,
            79,
            80,
            81,
            82,
            83,
            84,
            85,
            86,
            86,
            87,
            88,
            89,
            90,
            91,
            92,
            93,
            94,
            95,
            96,
            97,
            98,
            99,
            100
        ];
    THRESH_MULT_MAP_ZNN =
        s32.[
            0,
            cast,no_check(s32) ((2 + 1)),
            1500,
            cast,no_check(s32) ((3 + 1)),
            2000,
            cast,no_check(s32) ((0 + 7)),
            1000,
            cast,no_check(s32) ((2 + 7)),
            2000,
            2147483647
        ];
    THRESH_MULT_MAP_VHPRED =
        s32.[
            1000,
            cast,no_check(s32) ((2 + 1)),
            1500,
            cast,no_check(s32) ((3 + 1)),
            2000,
            cast,no_check(s32) ((0 + 7)),
            1000,
            cast,no_check(s32) ((1 + 7)),
            2000,
            cast,no_check(s32) ((7 + 7)),
            2147483647,
            2147483647
        ];
    THRESH_MULT_MAP_BPRED =
        s32.[
            2000,
            cast,no_check(s32) ((0 + 1)),
            2500,
            cast,no_check(s32) ((2 + 1)),
            5000,
            cast,no_check(s32) ((3 + 1)),
            7500,
            cast,no_check(s32) ((0 + 7)),
            2500,
            cast,no_check(s32) ((1 + 7)),
            5000,
            cast,no_check(s32) ((6 + 7)),
            2147483647,
            2147483647
        ];
    THRESH_MULT_MAP_TM =
        s32.[
            1000,
            cast,no_check(s32) ((2 + 1)),
            1500,
            cast,no_check(s32) ((3 + 1)),
            2000,
            cast,no_check(s32) ((0 + 7)),
            0,
            cast,no_check(s32) ((1 + 7)),
            1000,
            cast,no_check(s32) ((2 + 7)),
            2000,
            cast,no_check(s32) ((7 + 7)),
            2147483647,
            2147483647
        ];
    THRESH_MULT_MAP_NEW1 =
        s32.[
            1000,
            cast,no_check(s32) ((2 + 1)),
            2000,
            cast,no_check(s32) ((0 + 7)),
            2000,
            2147483647
        ];
    THRESH_MULT_MAP_NEW2 =
        s32.[
            1000,
            cast,no_check(s32) ((2 + 1)),
            2000,
            cast,no_check(s32) ((3 + 1)),
            2500,
            cast,no_check(s32) ((5 + 1)),
            4000,
            cast,no_check(s32) ((0 + 7)),
            2000,
            cast,no_check(s32) ((2 + 7)),
            2500,
            cast,no_check(s32) ((5 + 7)),
            4000,
            2147483647
        ];
    THRESH_MULT_MAP_SPLIT1 =
        s32.[
            2500,
            cast,no_check(s32) ((0 + 1)),
            1700,
            cast,no_check(s32) ((2 + 1)),
            10000,
            cast,no_check(s32) ((3 + 1)),
            25000,
            cast,no_check(s32) ((4 + 1)),
            2147483647,
            cast,no_check(s32) ((0 + 7)),
            5000,
            cast,no_check(s32) ((1 + 7)),
            10000,
            cast,no_check(s32) ((2 + 7)),
            25000,
            cast,no_check(s32) ((3 + 7)),
            2147483647,
            2147483647
        ];
    THRESH_MULT_MAP_SPLIT2 =
        s32.[
            5000,
            cast,no_check(s32) ((0 + 1)),
            4500,
            cast,no_check(s32) ((2 + 1)),
            20000,
            cast,no_check(s32) ((3 + 1)),
            50000,
            cast,no_check(s32) ((4 + 1)),
            2147483647,
            cast,no_check(s32) ((0 + 7)),
            10000,
            cast,no_check(s32) ((1 + 7)),
            20000,
            cast,no_check(s32) ((2 + 7)),
            50000,
            cast,no_check(s32) ((3 + 7)),
            2147483647,
            2147483647
        ];
    MODE_CHECK_FREQ_MAP_ZN2 =
        s32.[
            0,
            cast,no_check(s32) ((10 + 7)),
            (cast(s32) 1) << 1,
            cast,no_check(s32) ((11 + 7)),
            (cast(s32) 1) << 2,
            cast,no_check(s32) ((12 + 7)),
            (cast(s32) 1) << 3,
            2147483647
        ];
    MODE_CHECK_FREQ_MAP_VHBPRED =
        s32.[
            0,
            cast,no_check(s32) ((5 + 1)),
            2,
            cast,no_check(s32) ((0 + 7)),
            0,
            cast,no_check(s32) ((3 + 7)),
            2,
            cast,no_check(s32) ((5 + 7)),
            4,
            2147483647
        ];
    MODE_CHECK_FREQ_MAP_NEAR2 =
        s32.[
            0,
            cast,no_check(s32) ((5 + 1)),
            2,
            cast,no_check(s32) ((0 + 7)),
            0,
            cast,no_check(s32) ((3 + 7)),
            2,
            cast,no_check(s32) ((10 + 7)),
            (cast(s32) 1) << 2,
            cast,no_check(s32) ((11 + 7)),
            (cast(s32) 1) << 3,
            cast,no_check(s32) ((12 + 7)),
            (cast(s32) 1) << 4,
            2147483647
        ];
    MODE_CHECK_FREQ_MAP_NEW1 =
        s32.[
            0,
            cast,no_check(s32) ((10 + 7)),
            (cast(s32) 1) << 1,
            cast,no_check(s32) ((11 + 7)),
            (cast(s32) 1) << 2,
            cast,no_check(s32) ((12 + 7)),
            (cast(s32) 1) << 3,
            2147483647
        ];
    MODE_CHECK_FREQ_MAP_NEW2 =
        s32.[
            0,
            cast,no_check(s32) ((5 + 1)),
            4,
            cast,no_check(s32) ((0 + 7)),
            0,
            cast,no_check(s32) ((3 + 7)),
            4,
            cast,no_check(s32) ((10 + 7)),
            (cast(s32) 1) << 3,
            cast,no_check(s32) ((11 + 7)),
            (cast(s32) 1) << 4,
            cast,no_check(s32) ((12 + 7)),
            (cast(s32) 1) << 5,
            2147483647
        ];
    MODE_CHECK_FREQ_MAP_SPLIT1 =
        s32.[
            0,
            cast,no_check(s32) ((2 + 1)),
            2,
            cast,no_check(s32) ((3 + 1)),
            7,
            cast,no_check(s32) ((1 + 7)),
            2,
            cast,no_check(s32) ((2 + 7)),
            7,
            2147483647
        ];
    MODE_CHECK_FREQ_MAP_SPLIT2 =
        s32.[
            0,
            cast,no_check(s32) ((1 + 1)),
            2,
            cast,no_check(s32) ((2 + 1)),
            4,
            cast,no_check(s32) ((3 + 1)),
            15,
            cast,no_check(s32) ((1 + 7)),
            4,
            cast,no_check(s32) ((2 + 7)),
            15,
            2147483647
        ];
    Q_TRANS =
        s32.[
            0,
            1,
            2,
            3,
            4,
            5,
            7,
            8,
            9,
            10,
            12,
            13,
            15,
            17,
            18,
            19,
            20,
            21,
            23,
            24,
            25,
            26,
            27,
            28,
            29,
            30,
            31,
            33,
            35,
            37,
            39,
            41,
            43,
            45,
            47,
            49,
            51,
            53,
            55,
            57,
            59,
            61,
            64,
            67,
            70,
            73,
            76,
            79,
            82,
            85,
            88,
            91,
            94,
            97,
            100,
            103,
            106,
            109,
            112,
            115,
            118,
            121,
            124,
            127
        ];
    CONST_SOURCE =
        u8.[
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128
        ];
    atomic_store(*globals_initialization_state_for_onyx_if, 2);
}

THR_MODES :: u32;
THR_ZERO1 : s32 : 0;
THR_DC : s32 : 1;
THR_NEAREST1 : s32 : 2;
THR_NEAR1 : s32 : 3;
THR_ZERO2 : s32 : 4;
THR_NEAREST2 : s32 : 5;
THR_ZERO3 : s32 : 6;
THR_NEAREST3 : s32 : 7;
THR_NEAR2 : s32 : 8;
THR_NEAR3 : s32 : 9;
THR_V_PRED : s32 : 10;
THR_H_PRED : s32 : 11;
THR_TM : s32 : 12;
THR_NEW1 : s32 : 13;
THR_NEW2 : s32 : 14;
THR_NEW3 : s32 : 15;
THR_SPLIT1 : s32 : 16;
THR_SPLIT2 : s32 : 17;
THR_SPLIT3 : s32 : 18;
THR_B_PRED : s32 : 19;

SKIN_DETECTION_BLOCK_SIZE :: u32;
SKIN_8X8 : s32 : 0;
SKIN_16X16 : s32 : 1;


Once_In_Onyx_If_Parameter_0_Type :: #type () #c_call;
