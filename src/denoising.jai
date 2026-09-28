// Generated directly from C by cpp_transpiler.
SSE_THRESHOLD_HIGH: u32;

SSE_THRESHOLD: u32;

NOISE_MOTION_THRESHOLD: u32;

SSE_DIFF_THRESHOLD: u32;

vp8_set_reference_value_in_denoising :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_denoising :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_denoising :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_denoising :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_denoising :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_denoising :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_denoising :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_denoising :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_denoising :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_denoising :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_denoising :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_denoising :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_denoising :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_denoising :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_denoising :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_denoising :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_denoising :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_denoising :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_denoising :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_denoising :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_denoising :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_denoising :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_denoising :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_denoising :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_denoising :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_denoising :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

scale2_ratio_in_denoising :: (mode: s32, hr: *s32, hs: *s32) {
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

vp8_denoiser_filter_c :: (
    mc_running_avg_y: *u8,
    mc_avg_y_stride: s32,
    running_avg_y: *u8,
    avg_y_stride: s32,
    sig: *u8,
    sig_stride: s32,
    motion_magnitude: u32,
    increase_denoising: s32
) -> s32 {
    running_avg_y_start := running_avg_y;
    sig_start := sig;
    c: s32 = ---;
    sum_diff: s32 = 0;
    adj_val := s32.[ 3, 4, 6 ];
    shift_inc1: s32 = 0;
    shift_inc2: s32 = 1;
    col_sum: [16] s32;

    if motion_magnitude <= cast,no_check(u32) (8 * 3) {
        if increase_denoising != 0 {
            shift_inc1 = 1;
            shift_inc2 = 2;
        }
        adj_val[0] += shift_inc2;
        adj_val[1] += shift_inc2;
        adj_val[2] += shift_inc2;
    }

    for r: 0..cast(s32) 16 - 1 {
        c = 0;
        while c < 16 {
            diff: s32 = 0;
            adjustment: s32 = 0;
            absdiff: s32 = 0;

            diff = (cast(s32) mc_running_avg_y[c]) - cast(s32) sig[c];
            absdiff = absolute_value(diff);

            if absdiff <= 3 + shift_inc1 {
                running_avg_y[c] = mc_running_avg_y[c];
                col_sum[c] += diff;
            } else {
                if absdiff >= 4 + shift_inc1 && absdiff <= 7 {
                    adjustment = adj_val[0];
                } else if absdiff >= 8 && absdiff <= 15 {
                    adjustment = adj_val[1];
                } else {
                    adjustment = adj_val[2];
                }

                if diff > 0 {
                    if (cast(s32) sig[c]) + adjustment > 255 {
                        running_avg_y[c] = 255;
                    } else {
                        running_avg_y[c] = cast,no_check(u8) ((cast(s32) sig[c]) + adjustment);
                    }

                    col_sum[c] += adjustment;
                } else {
                    if (cast(s32) sig[c]) - adjustment < 0 {
                        running_avg_y[c] = 0;
                    } else {
                        running_avg_y[c] = cast,no_check(u8) ((cast(s32) sig[c]) - adjustment);
                    }

                    col_sum[c] -= adjustment;
                }
            }
            c += 1;
        }

        sig += sig_stride;
        mc_running_avg_y += mc_avg_y_stride;
        running_avg_y += avg_y_stride;
    }

    c = 0;
    while c < 16 {
        if col_sum[c] >= 128 {
            col_sum[c] = 127;
        }
        sum_diff += col_sum[c];
        c += 1;
    }

    sum_diff_thresh: s32 = 512;
    if increase_denoising != 0 {
        sum_diff_thresh = 600;
    }
    if absolute_value(sum_diff) > sum_diff_thresh {
        delta := (absolute_value(sum_diff) - sum_diff_thresh) >> 8 + 1;

        if delta < 4 {
            sig -= sig_stride * 16;
            mc_running_avg_y -= mc_avg_y_stride * 16;
            running_avg_y -= avg_y_stride * 16;
            for r: 0..cast(s32) 16 - 1 {
                c = 0;
                while c < 16 {
                    diff := (cast(s32) mc_running_avg_y[c]) - cast(s32) sig[c];
                    adjustment := absolute_value(diff);
                    if adjustment > delta {
                        adjustment = delta;
                    }
                    if diff > 0 {
                        if (cast(s32) running_avg_y[c]) - adjustment < 0 {
                            running_avg_y[c] = 0;
                        } else {
                            running_avg_y[c] = cast,no_check(u8) ((cast(s32) running_avg_y[c]) - adjustment);
                        }
                        col_sum[c] -= adjustment;
                    } else if diff < 0 {
                        if (cast(s32) running_avg_y[c]) + adjustment > 255 {
                            running_avg_y[c] = 255;
                        } else {
                            running_avg_y[c] = cast,no_check(u8) ((cast(s32) running_avg_y[c]) + adjustment);
                        }
                        col_sum[c] += adjustment;
                    }
                    c += 1;
                }

                sig += sig_stride;
                mc_running_avg_y += mc_avg_y_stride;
                running_avg_y += avg_y_stride;
            }

            sum_diff = 0;
            c = 0;
            while c < 16 {
                if col_sum[c] >= 128 {
                    col_sum[c] = 127;
                }
                sum_diff += col_sum[c];
                c += 1;
            }

            if absolute_value(sum_diff) > sum_diff_thresh {
                return COPY_BLOCK;
            }
        } else {
            return COPY_BLOCK;
        }
    }

    vp8_copy_mem16x16_c(running_avg_y_start, avg_y_stride, sig_start, sig_stride);
    return FILTER_BLOCK;
}

vp8_denoiser_filter_uv_c :: (
    mc_running_avg: *u8,
    mc_avg_stride: s32,
    running_avg: *u8,
    avg_stride: s32,
    sig: *u8,
    sig_stride: s32,
    motion_magnitude: u32,
    increase_denoising: s32
) -> s32 {
    running_avg_start := running_avg;
    sig_start := sig;
    c: s32 = ---;
    sum_diff: s32 = 0;
    sum_block: s32 = 0;
    adj_val := s32.[ 3, 4, 6 ];
    shift_inc1: s32 = 0;
    shift_inc2: s32 = 1;

    if motion_magnitude <= cast,no_check(u32) (8 * 3) {
        if increase_denoising != 0 {
            shift_inc1 = 1;
            shift_inc2 = 2;
        }
        adj_val[0] += shift_inc2;
        adj_val[1] += shift_inc2;
        adj_val[2] += shift_inc2;
    }

    for r: 0..cast(s32) 8 - 1 {
        c = 0;
        while c < 8 {
            sum_block += cast,no_check(s32) sig[c];
            c += 1;
        }
        sig += sig_stride;
    }
    if absolute_value(sum_block - (cast,no_check(s32) ((128 * 8))) * 8) < (cast,no_check(s32) ((8 * 8))) * 8 {
        return COPY_BLOCK;
    }

    sig -= sig_stride * 8;
    for r: 0..cast(s32) 8 - 1 {
        c = 0;
        while c < 8 {
            diff: s32 = 0;
            adjustment: s32 = 0;
            absdiff: s32 = 0;

            diff = (cast(s32) mc_running_avg[c]) - cast(s32) sig[c];
            absdiff = absolute_value(diff);

            if absdiff <= 3 + shift_inc1 {
                running_avg[c] = mc_running_avg[c];
                sum_diff += diff;
            } else {
                if absdiff >= 4 && absdiff <= 7 {
                    adjustment = adj_val[0];
                } else if absdiff >= 8 && absdiff <= 15 {
                    adjustment = adj_val[1];
                } else {
                    adjustment = adj_val[2];
                }
                if diff > 0 {
                    if (cast(s32) sig[c]) + adjustment > 255 {
                        running_avg[c] = 255;
                    } else {
                        running_avg[c] = cast,no_check(u8) ((cast(s32) sig[c]) + adjustment);
                    }
                    sum_diff += adjustment;
                } else {
                    if (cast(s32) sig[c]) - adjustment < 0 {
                        running_avg[c] = 0;
                    } else {
                        running_avg[c] = cast,no_check(u8) ((cast(s32) sig[c]) - adjustment);
                    }
                    sum_diff -= adjustment;
                }
            }
            c += 1;
        }

        sig += sig_stride;
        mc_running_avg += mc_avg_stride;
        running_avg += avg_stride;
    }

    sum_diff_thresh: s32 = 96;
    if increase_denoising != 0 {
        sum_diff_thresh = (cast,no_check(s32) ((8 * 8))) * 2;
    }
    if absolute_value(sum_diff) > sum_diff_thresh {
        delta := (absolute_value(sum_diff) - sum_diff_thresh) >> 8 + 1;

        if delta < 4 {
            sig -= sig_stride * 8;
            mc_running_avg -= mc_avg_stride * 8;
            running_avg -= avg_stride * 8;
            for r: 0..cast(s32) 8 - 1 {
                c = 0;
                while c < 8 {
                    diff := (cast(s32) mc_running_avg[c]) - cast(s32) sig[c];
                    adjustment := absolute_value(diff);
                    if adjustment > delta {
                        adjustment = delta;
                    }
                    if diff > 0 {
                        if (cast(s32) running_avg[c]) - adjustment < 0 {
                            running_avg[c] = 0;
                        } else {
                            running_avg[c] = cast,no_check(u8) ((cast(s32) running_avg[c]) - adjustment);
                        }
                        sum_diff -= adjustment;
                    } else if diff < 0 {
                        if (cast(s32) running_avg[c]) + adjustment > 255 {
                            running_avg[c] = 255;
                        } else {
                            running_avg[c] = cast,no_check(u8) ((cast(s32) running_avg[c]) + adjustment);
                        }
                        sum_diff += adjustment;
                    }
                    c += 1;
                }

                sig += sig_stride;
                mc_running_avg += mc_avg_stride;
                running_avg += avg_stride;
            }
            if absolute_value(sum_diff) > sum_diff_thresh {
                return COPY_BLOCK;
            }
        } else {
            return COPY_BLOCK;
        }
    }

    vp8_copy_mem8x8_c(running_avg_start, avg_stride, sig_start, sig_stride);
    return FILTER_BLOCK;
}

vp8_denoiser_allocate :: (
    denoiser: *VP8_DENOISER,
    width: s32,
    height: s32,
    num_mb_rows: s32,
    num_mb_cols: s32,
    mode: s32
) -> s32 {
    denoiser.num_mb_cols = num_mb_cols;

    i: s32 = 0;
    while i < MAX_REF_FRAMES {
        denoiser.yv12_running_avg[i].flags = 0;

        if vp8_yv12_alloc_frame_buffer(denoiser.yv12_running_avg.data + i, width, height, 32) < 0 {
            vp8_denoiser_free(denoiser);
            return 1;
        }
        fill_memory(denoiser.yv12_running_avg[i].buffer_alloc, 0, denoiser.yv12_running_avg[i].frame_size);
        i += 1;
    }
    denoiser.yv12_mc_running_avg.flags = 0;

    if vp8_yv12_alloc_frame_buffer(*denoiser.yv12_mc_running_avg, width, height, 32) < 0 {
        vp8_denoiser_free(denoiser);
        return 1;
    }

    fill_memory(denoiser.yv12_mc_running_avg.buffer_alloc, 0, denoiser.yv12_mc_running_avg.frame_size);

    if vp8_yv12_alloc_frame_buffer(*denoiser.yv12_last_source, width, height, 32) < 0 {
        vp8_denoiser_free(denoiser);
        return 1;
    }
    fill_memory(denoiser.yv12_last_source.buffer_alloc, 0, denoiser.yv12_last_source.frame_size);

    denoiser.denoise_state = cast(*u8) calloc_2(cast,no_check(u64) (num_mb_rows * num_mb_cols), 1);
    if denoiser.denoise_state == null {
        vp8_denoiser_free(denoiser);
        return 1;
    }
    fill_memory(denoiser.denoise_state, 0, cast,no_check(u64) (num_mb_rows * num_mb_cols));
    vp8_denoiser_set_parameters(denoiser, mode);
    denoiser.nmse_source_diff = 0;
    denoiser.nmse_source_diff_count = 0;
    denoiser.qp_avg = 0;

    denoiser.qp_threshold_up = 80;

    denoiser.qp_threshold_down = 128;

    denoiser.bitrate_threshold = 400000;
    denoiser.threshold_aggressive_mode = 80;
    if width * height > 1280 * 720 {
        denoiser.bitrate_threshold = 3000000;
        denoiser.threshold_aggressive_mode = 200;
    } else if width * height > 960 * 540 {
        denoiser.bitrate_threshold = 1200000;
        denoiser.threshold_aggressive_mode = 120;
    } else if width * height > 640 * 480 {
        denoiser.bitrate_threshold = 600000;
        denoiser.threshold_aggressive_mode = 100;
    }
    return 0;
}

vp8_denoiser_set_parameters :: (denoiser: *VP8_DENOISER, mode: s32) {
    if mode == 1 {
        denoiser.denoiser_mode = cast,no_check(s32) (K_DENOISER_ON_Y_ONLY);
    } else if mode == 2 {
        denoiser.denoiser_mode = cast,no_check(s32) (K_DENOISER_ON_YUV);
    } else if mode == 3 {
        denoiser.denoiser_mode = cast,no_check(s32) (K_DENOISER_ON_YUV_AGGRESSIVE);
    } else {
        denoiser.denoiser_mode = cast,no_check(s32) (K_DENOISER_ON_YUV);
    }
    if denoiser.denoiser_mode != K_DENOISER_ON_YUV_AGGRESSIVE {
        denoiser.denoise_pars.scale_sse_thresh = 1;
        denoiser.denoise_pars.scale_motion_thresh = 8;
        denoiser.denoise_pars.scale_increase_filter = 0;
        denoiser.denoise_pars.denoise_mv_bias = 95;
        denoiser.denoise_pars.pickmode_mv_bias = 100;
        denoiser.denoise_pars.qp_thresh = 0;
        denoiser.denoise_pars.consec_zerolast = U32_MAX;
        denoiser.denoise_pars.spatial_blur = 0;
    } else {
        denoiser.denoise_pars.scale_sse_thresh = 2;
        denoiser.denoise_pars.scale_motion_thresh = 16;
        denoiser.denoise_pars.scale_increase_filter = 1;
        denoiser.denoise_pars.denoise_mv_bias = 60;
        denoiser.denoise_pars.pickmode_mv_bias = 75;
        denoiser.denoise_pars.qp_thresh = 80;
        denoiser.denoise_pars.consec_zerolast = 15;
        denoiser.denoise_pars.spatial_blur = 0;
    }
}

vp8_denoiser_free :: (denoiser: *VP8_DENOISER) {
    i: s32 = 0;
    while i < MAX_REF_FRAMES {
        vp8_yv12_de_alloc_frame_buffer(denoiser.yv12_running_avg.data + i);
        i += 1;
    }
    vp8_yv12_de_alloc_frame_buffer(*denoiser.yv12_mc_running_avg);
    vp8_yv12_de_alloc_frame_buffer(*denoiser.yv12_last_source);
    deallocate_memory(cast(*void) denoiser.denoise_state);
    denoiser.denoise_state = null;
}

vp8_denoiser_denoise_mb :: (
    denoiser: *VP8_DENOISER,
    x: *MACROBLOCK_in_block,
    best_sse: u32,
    zero_mv_sse: u32,
    recon_yoffset: s32,
    recon_uvoffset: s32,
    lfi_n: *Loop_Filter_Info_N,
    mb_row: s32,
    mb_col: s32,
    block_index: s32,
    consec_zero_last: s32
) {
    mv_row: s32 = ---;
    mv_col: s32 = ---;
    motion_threshold: u32 = ---;
    motion_magnitude2: u32 = ---;
    sse_thresh: u32 = ---;
    sse_diff_thresh: s32 = 0;

    apply_spatial_loop_filter: s32 = 1;
    frame := x.best_reference_frame;
    zero_frame := x.best_zeromv_reference_frame;

    decision := cast,no_check(Vp8_Denoiser_Decision) FILTER_BLOCK;
    decision_u := cast,no_check(Vp8_Denoiser_Decision) COPY_BLOCK;
    decision_v := cast,no_check(Vp8_Denoiser_Decision) COPY_BLOCK;

    if zero_frame != 0 {
        src := denoiser.yv12_running_avg.data + frame;
        dst := *denoiser.yv12_mc_running_avg;
        saved_pre, saved_dst: YV12_BUFFER_CONFIG = ---;
        saved_mbmi: MB_MODE_INFO = ---;
        filter_xd := *x.e_mbd;
        mbmi := *filter_xd.mode_info_context.mbmi;
        sse_diff: s32 = 0;

        ZERO_BIAS := cast,no_check(s32) denoiser.denoise_pars.denoise_mv_bias;
        zero_mv_sse = cast,no_check(u32) (((cast,no_check(s64) zero_mv_sse) * cast(s64) ZERO_BIAS) / 100);
        sse_diff = (cast,no_check(s32) zero_mv_sse) - cast,no_check(s32) best_sse;

        saved_mbmi = mbmi.*;

        mbmi.ref_frame = cast,no_check(u8) x.best_reference_frame;
        mbmi.mode = cast,no_check(u8) x.best_sse_inter_mode;
        mbmi.mv = x.best_sse_mv;
        mbmi.need_to_clamp_mvs = x.need_to_clamp_best_mvs;
        mv_col = cast,no_check(s32) x.best_sse_mv.as_mv.col;
        mv_row = cast,no_check(s32) x.best_sse_mv.as_mv.row;

        if cast,no_check(u32) (mv_row * mv_row + mv_col * mv_col) <= NOISE_MOTION_THRESHOLD {
            sse_diff_thresh = cast,no_check(s32) SSE_DIFF_THRESHOLD;
        }

        if frame == cast,no_check(u32) INTRA_FRAME || sse_diff <= sse_diff_thresh {
            x.denoise_zeromv = 1;
            mbmi.ref_frame = cast,no_check(u8) x.best_zeromv_reference_frame;

            src = denoiser.yv12_running_avg.data + zero_frame;

            mbmi.mode = cast,no_check(u8) ZEROMV;
            mbmi.mv.as_int = 0;
            x.best_sse_inter_mode = cast,no_check(MB_PREDICTION_MODE) ZEROMV;
            x.best_sse_mv.as_int = 0;
            best_sse = zero_mv_sse;
        }

        mv_row = cast,no_check(s32) x.best_sse_mv.as_mv.row;
        mv_col = cast,no_check(s32) x.best_sse_mv.as_mv.col;
        motion_magnitude2 = cast,no_check(u32) (mv_row * mv_row + mv_col * mv_col);
        motion_threshold = denoiser.denoise_pars.scale_motion_thresh * NOISE_MOTION_THRESHOLD;

        if motion_magnitude2 < denoiser.denoise_pars.scale_increase_filter * NOISE_MOTION_THRESHOLD {
            x.increase_denoising = 1;
        }

        sse_thresh = denoiser.denoise_pars.scale_sse_thresh * SSE_THRESHOLD;
        if x.increase_denoising != 0 {
            sse_thresh = denoiser.denoise_pars.scale_sse_thresh * SSE_THRESHOLD_HIGH;
        }

        if best_sse > sse_thresh || motion_magnitude2 > motion_threshold {
            decision = cast,no_check(Vp8_Denoiser_Decision) COPY_BLOCK;
        }

        if x.is_skin != 0 && (consec_zero_last < 2 || motion_magnitude2 > 0) {
            decision = cast,no_check(Vp8_Denoiser_Decision) COPY_BLOCK;
        }

        if decision == cast,no_check(u32) FILTER_BLOCK {
            saved_pre = filter_xd.pre;
            saved_dst = filter_xd.dst;

            filter_xd.pre.y_buffer = src.y_buffer + recon_yoffset;
            filter_xd.pre.u_buffer = src.u_buffer + recon_uvoffset;
            filter_xd.pre.v_buffer = src.v_buffer + recon_uvoffset;

            filter_xd.dst.y_buffer = dst.y_buffer + recon_yoffset;
            filter_xd.dst.u_buffer = dst.u_buffer + recon_uvoffset;
            filter_xd.dst.v_buffer = dst.v_buffer + recon_uvoffset;

            if x.skip == 0 {
                vp8_build_inter_predictors_mb(filter_xd);
            } else {
                vp8_build_inter16x16_predictors_mb(
                    filter_xd,
                    filter_xd.dst.y_buffer,
                    filter_xd.dst.u_buffer,
                    filter_xd.dst.v_buffer,
                    filter_xd.dst.y_stride,
                    filter_xd.dst.uv_stride
                );
            }
            filter_xd.pre = saved_pre;
            filter_xd.dst = saved_dst;
            mbmi.* = saved_mbmi;
        }
    } else {
        decision = cast,no_check(Vp8_Denoiser_Decision) COPY_BLOCK;
    }

    if decision == cast,no_check(u32) FILTER_BLOCK {
        mc_running_avg_y: *u8 = denoiser.yv12_mc_running_avg.y_buffer + recon_yoffset;
        mc_avg_y_stride := denoiser.yv12_mc_running_avg.y_stride;
        running_avg_y: *u8 = denoiser.yv12_running_avg[INTRA_FRAME].y_buffer + recon_yoffset;
        avg_y_stride := denoiser.yv12_running_avg[INTRA_FRAME].y_stride;

        decision =
            cast,no_check(Vp8_Denoiser_Decision) vp8_denoiser_filter_c(
                mc_running_avg_y,
                mc_avg_y_stride,
                running_avg_y,
                avg_y_stride,
                x.thismb.data,
                16,
                motion_magnitude2,
                x.increase_denoising
            );
        denoiser.denoise_state[block_index] =
            cast,no_check(u8) ((ifx motion_magnitude2 > 0 then cast,no_check(s32) (K_FILTER_NON_ZERO_MV) else cast,no_check(s32) (K_FILTER_ZERO_MV)));

        if denoiser.denoiser_mode != K_DENOISER_ON_Y_ONLY && motion_magnitude2 == 0 && decision == cast,no_check(u32) FILTER_BLOCK {
            mc_running_avg_u: *u8 = denoiser.yv12_mc_running_avg.u_buffer + recon_uvoffset;
            running_avg_u: *u8 = denoiser.yv12_running_avg[INTRA_FRAME].u_buffer + recon_uvoffset;
            mc_running_avg_v: *u8 = denoiser.yv12_mc_running_avg.v_buffer + recon_uvoffset;
            running_avg_v: *u8 = denoiser.yv12_running_avg[INTRA_FRAME].v_buffer + recon_uvoffset;
            mc_avg_uv_stride := denoiser.yv12_mc_running_avg.uv_stride;
            avg_uv_stride := denoiser.yv12_running_avg[INTRA_FRAME].uv_stride;
            signal_stride := x.block[16].src_stride;
            decision_u =
                cast,no_check(Vp8_Denoiser_Decision) vp8_denoiser_filter_uv_c(
                    mc_running_avg_u,
                    mc_avg_uv_stride,
                    running_avg_u,
                    avg_uv_stride,
                    x.block[16].src + x.block[16].base_src.*,
                    signal_stride,
                    motion_magnitude2,
                    0
                );
            decision_v =
                cast,no_check(Vp8_Denoiser_Decision) vp8_denoiser_filter_uv_c(
                    mc_running_avg_v,
                    mc_avg_uv_stride,
                    running_avg_v,
                    avg_uv_stride,
                    x.block[20].src + x.block[20].base_src.*,
                    signal_stride,
                    motion_magnitude2,
                    0
                );
        }
    }
    if decision == cast,no_check(u32) COPY_BLOCK {
        x.denoise_zeromv = 0;
        vp8_copy_mem16x16_c(
            x.thismb.data,
            16,
            denoiser.yv12_running_avg[INTRA_FRAME].y_buffer + recon_yoffset,
            denoiser.yv12_running_avg[INTRA_FRAME].y_stride
        );
        denoiser.denoise_state[block_index] = cast,no_check(u8) K_NO_FILTER;
    }
    if denoiser.denoiser_mode != K_DENOISER_ON_Y_ONLY {
        if decision_u == cast,no_check(u32) COPY_BLOCK {
            vp8_copy_mem8x8_c(
                x.block[16].src + x.block[16].base_src.*,
                x.block[16].src_stride,
                denoiser.yv12_running_avg[INTRA_FRAME].u_buffer + recon_uvoffset,
                denoiser.yv12_running_avg[INTRA_FRAME].uv_stride
            );
        }
        if decision_v == cast,no_check(u32) COPY_BLOCK {
            vp8_copy_mem8x8_c(
                x.block[20].src + x.block[20].base_src.*,
                x.block[16].src_stride,
                denoiser.yv12_running_avg[INTRA_FRAME].v_buffer + recon_uvoffset,
                denoiser.yv12_running_avg[INTRA_FRAME].uv_stride
            );
        }
    }

    if apply_spatial_loop_filter != 0 {
        lfi: Loop_Filter_Info = ---;
        apply_filter_col: s32 = 0;
        apply_filter_row: s32 = 0;
        apply_filter: s32 = 0;
        y_stride := denoiser.yv12_running_avg[INTRA_FRAME].y_stride;
        uv_stride := denoiser.yv12_running_avg[INTRA_FRAME].uv_stride;

        filter_level: s32 = 48;

        hev_index := cast,no_check(s32) lfi_n.hev_thr_lut[INTER_FRAME_in_alloccommon][filter_level];
        lfi.mblim = lfi_n.mblim[filter_level].data;
        lfi.blim = lfi_n.blim[filter_level].data;
        lfi.lim = lfi_n.lim[filter_level].data;
        lfi.hev_thr = lfi_n.hev_thr[hev_index].data;

        if mb_col > 0 {
            apply_filter_col =
                cast(s32) (!(denoiser.denoise_state[block_index] == denoiser.denoise_state[block_index - 1] &&
                    denoiser.denoise_state[block_index] != cast,no_check(u8) K_FILTER_NON_ZERO_MV));
            if apply_filter_col != 0 {
                apply_filter = 1;
                vp8_loop_filter_mbv_c(
                    denoiser.yv12_running_avg[INTRA_FRAME].y_buffer + recon_yoffset,
                    null,
                    null,
                    y_stride,
                    uv_stride,
                    *lfi
                );
            }
        }
        if mb_row > 0 {
            apply_filter_row =
                cast(s32) (!(denoiser.denoise_state[block_index] == denoiser.denoise_state[block_index - denoiser.num_mb_cols] &&
                    denoiser.denoise_state[block_index] != cast,no_check(u8) K_FILTER_NON_ZERO_MV));
            if apply_filter_row != 0 {
                apply_filter = 1;
                vp8_loop_filter_mbh_c(
                    denoiser.yv12_running_avg[INTRA_FRAME].y_buffer + recon_yoffset,
                    null,
                    null,
                    y_stride,
                    uv_stride,
                    *lfi
                );
            }
        }
        if apply_filter != 0 {
            vp8_copy_mem16x16_c(
                denoiser.yv12_running_avg[INTRA_FRAME].y_buffer + recon_yoffset,
                y_stride,
                x.thismb.data,
                16
            );
        }
    }
}

globals_initialization_state_for_denoising: u32;
initialize_globals_for_denoising :: () {
    {
        state := atomic_load(*globals_initialization_state_for_denoising);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_denoising, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_denoising) != 2 {}
            return;
        }
    }
    NOISE_MOTION_THRESHOLD = 25 * 25;
    SSE_DIFF_THRESHOLD = cast,no_check(u32) ((cast,no_check(s32) ((16 * 16))) * 20);
    SSE_THRESHOLD = cast,no_check(u32) ((cast,no_check(s32) ((16 * 16))) * 40);
    SSE_THRESHOLD_HIGH = cast,no_check(u32) ((cast,no_check(s32) ((16 * 16))) * 80);
    atomic_store(*globals_initialization_state_for_denoising, 2);
}

Vp8_Denoiser_Decision :: u32;
COPY_BLOCK : s32 : 0;
FILTER_BLOCK : s32 : 1;

Vp8_Denoiser_Mode :: u32;
K_DENOISER_OFF : s32 : 0;
K_DENOISER_ON_Y_ONLY : s32 : 1;
K_DENOISER_ON_YUV : s32 : 2;
K_DENOISER_ON_YUV_AGGRESSIVE : s32 : 3;
K_DENOISER_ON_ADAPTIVE : s32 : 4;

Vp8_Denoiser_Filter_State :: u32;
K_NO_FILTER : s32 : 0;
K_FILTER_ZERO_MV : s32 : 1;
K_FILTER_NON_ZERO_MV : s32 : 2;

