WEIGHT_TABLE: [256] float64;

CQ_LEVEL: [128] s32;

hscale_lookup: [7] s32;

vscale_lookup: [7] s32;

clip_pixel_in_firstpass :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_firstpass :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_firstpass :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_firstpass :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_firstpass :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_firstpass(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_firstpass(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_firstpass(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_firstpass :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_firstpass :: (FILTER: *s16) -> s32 {
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

vp8_set_reference_value_in_firstpass :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_firstpass :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_firstpass :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_firstpass :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_firstpass :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_firstpass :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_firstpass :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_firstpass :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_firstpass :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_firstpass :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_firstpass :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_firstpass :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_firstpass :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_firstpass :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_firstpass :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_firstpass :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_firstpass :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_firstpass :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_firstpass :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_firstpass :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_firstpass :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_firstpass :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_firstpass :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_firstpass :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_firstpass :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_firstpass :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

scale2_ratio_in_firstpass :: (mode: s32, hr: *s32, hs: *s32) {
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

validate_buffer_in_firstpass :: (start: *u8, len: u64, end: *u8, error: *Internal_Error_Info) -> s32 {
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

vp8_encode_bool_in_firstpass :: (bc: *BOOL_CODER, bit: s32, probability: s32) {
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

        validate_buffer_in_firstpass(bc.buffer + bc.pos, 1, bc.buffer_end, bc.error);
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

vp8_cost_branch_in_firstpass :: (ct: *u32, p: Vp8_Prob) -> u32 {
    return cast,no_check(u32) ((((cast,no_check(u64) ct[0]) * cast(u64) VP8_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP8_PROB_COST[255 - cast(s32) p]) >> 8);
}

vp8_treed_write_in_firstpass :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) {
    i: Vp8_Tree_Index = 0;

    while true {
        {
            B := v >> ((c_transpiler_pre_decrement(*(n))) & 31) & 1;
            vp8_encode_bool_in_firstpass(W, B, cast,no_check(s32) P[(cast(s32) i) >> 1]);
            i = t[(cast(s32) i) + B];
        }
        if n == 0 break;
    }
}

vp8_write_token_in_firstpass :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) {
    vp8_treed_write_in_firstpass(W, t, P, X.value, X.len);
}

vp8_treed_cost_in_firstpass :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) -> s32 {
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

vp8_cost_token_in_firstpass :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) -> s32 {
    return vp8_treed_cost_in_firstpass(t, P, X.value, X.len);
}

vp8_sem_wait_in_firstpass :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_0: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_0; assignment_0; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init_in_firstpass :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release_in_firstpass :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

atomic_load_acquire_in_firstpass :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_atomic_spin_wait_in_firstpass :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire_in_firstpass(last_row_current_mb_col) - NSYNC {
    }
}

mv_bias_in_firstpass :: (refmb_ref_frame_sign_bias: s32, refframe: s32, mvp: *Int_Mv_in_mv, ref_frame_sign_bias: *s32) {
    if refmb_ref_frame_sign_bias != ref_frame_sign_bias[refframe] {
        mvp.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.row) * -1);
        mvp.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.col) * -1);
    }
}

vp8_clamp_mv2_in_firstpass :: (mv: *Int_Mv_in_mv, xd: *MACROBLOCKD_in_blockd) {
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

vp8_clamp_mv_in_firstpass :: (
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

vp8_check_mv_bounds_in_firstpass :: (
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

left_block_mv_in_firstpass :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> u32 {
    if b & 3 == 0 {
        cur_mb -= 1;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 4;
    }

    return (((cur_mb.bmi.data + b - 1)).mv).as_int;
}

above_block_mv_in_firstpass :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> u32 {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 16;
    }

    return (((cur_mb.bmi.data + (b - 4))).mv).as_int;
}

left_block_mode_in_firstpass :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> B_PREDICTION_MODE {
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

above_block_mode_in_firstpass :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> B_PREDICTION_MODE {
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

setup_intra_recon_left_in_firstpass :: (y_buffer: *u8, u_buffer: *u8, v_buffer: *u8, y_stride: s32, uv_stride: s32) {
    for i: 0..cast(s32) 16 - 1 {
        y_buffer[y_stride * i] = 129;
    }

    for i: 0..cast(s32) 8 - 1 {
        u_buffer[uv_stride * i] = 129;
    }

    for i: 0..cast(s32) 8 - 1 {
        v_buffer[uv_stride * i] = 129;
    }
}

vp8_init_first_pass :: (cpi: *VP8_COMP) {
    zero_stats(*cpi.twopass.total_stats);
}

zero_stats :: (section: *FIRSTPASS_STATS) {
    section.frame = 0.0;
    section.intra_error = 0.0;
    section.coded_error = 0.0;
    section.ssim_weighted_pred_err = 0.0;
    section.pcnt_inter = 0.0;
    section.pcnt_motion = 0.0;
    section.pcnt_second_ref = 0.0;
    section.pcnt_neutral = 0.0;
    section.m_vr = 0.0;
    section.mvr_abs = 0.0;
    section.m_vc = 0.0;
    section.mvc_abs = 0.0;
    section.m_vrv = 0.0;
    section.m_vcv = 0.0;
    section.mv_in_out_count = 0.0;
    section.new_mv_count = 0.0;
    section.count = 0.0;
    section.duration = 1.0;
}

vp8_first_pass :: (cpi: *VP8_COMP) {
    mb_row, mb_col: s32 = ---;
    X := *cpi.mb;
    CM := *cpi.common;
    XD := *X.e_mbd;

    recon_yoffset, recon_uvoffset: s32 = ---;
    lst_yv12 := CM.yv12_fb.data + CM.lst_fb_idx;
    new_yv12 := CM.yv12_fb.data + CM.new_fb_idx;
    gld_yv12 := CM.yv12_fb.data + CM.gld_fb_idx;
    recon_y_stride := lst_yv12.y_stride;
    recon_uv_stride := lst_yv12.uv_stride;
    intra_error: s64 = 0;
    coded_error: s64 = 0;

    sum_mvr: s32 = 0;
    sum_mvc: s32 = 0;
    sum_mvr_abs: s32 = 0;
    sum_mvc_abs: s32 = 0;
    sum_mvrs: s32 = 0;
    sum_mvcs: s32 = 0;
    mvcount: s32 = 0;
    intercount: s32 = 0;
    second_ref_count: s32 = 0;
    intrapenalty: s32 = 256;
    neutral_count: s32 = 0;
    new_mv_count: s32 = 0;
    sum_in_vectors: s32 = 0;
    lastmv_as_int: u32 = 0;

    zero_ref_mv: Int_Mv_in_mv = ---;

    zero_ref_mv.as_int = 0;

    X.src = cpi.source.*;
    XD.pre = lst_yv12.*;
    XD.dst = new_yv12.*;

    X.partition_info = X.pi;

    XD.mode_info_context = CM.mi;

    if CM.use_bilinear_mc_filter == 0 {
        XD.subpixel_predict = vp8_sixtap_predict4x4_c;
        XD.subpixel_predict8x4 = vp8_sixtap_predict8x4_c;
        XD.subpixel_predict8x8 = vp8_sixtap_predict8x8_c;
        XD.subpixel_predict16x16 = vp8_sixtap_predict16x16_c;
    } else {
        XD.subpixel_predict = vp8_bilinear_predict4x4_c;
        XD.subpixel_predict8x4 = vp8_bilinear_predict8x4_c;
        XD.subpixel_predict8x8 = vp8_bilinear_predict8x8_c;
        XD.subpixel_predict16x16 = vp8_bilinear_predict16x16_c;
    }

    vp8_build_block_offsets(X);

    vp8_setup_intra_recon(new_yv12);
    vp8cx_frame_init_quantizer(cpi);

    {
        flag := s32.[ 1, 1 ];
        vp8_initialize_rd_consts(cpi, X, vp8_dc_quant(CM.base_qindex, CM.y1dc_delta_q));
        copy_memory(CM.fc.mvc.data, VP8_DEFAULT_MV_CONTEXT.data, VP8_DEFAULT_MV_CONTEXT.count * size_of(MV_CONTEXT));
        vp8_build_component_cost_table(cpi.mb.mvcost.data, CM.fc.mvc.data, flag.data);
    }

    mb_row = 0;
    while mb_row < CM.mb_rows {
        best_ref_mv: Int_Mv_in_mv = ---;

        best_ref_mv.as_int = 0;

        XD.up_available = cast(s32) (mb_row != 0);
        recon_yoffset = mb_row * recon_y_stride * 16;
        recon_uvoffset = mb_row * recon_uv_stride * 8;

        X.mv_row_min = -(mb_row * 16 + cast,no_check(s32) ((32 - 16)));
        X.mv_row_max = (CM.mb_rows - 1 - mb_row) * 16 + cast,no_check(s32) ((32 - 16));

        mb_col = 0;
        while loop := mb_col < CM.mb_cols {
            this_error: s32 = ---;
            gf_motion_error: s32 = 2147483647;
            use_dc_pred := cast(s32) ((mb_col != 0 || mb_row != 0) && (mb_col == 0 || mb_row == 0));

            XD.dst.y_buffer = new_yv12.y_buffer + recon_yoffset;
            XD.dst.u_buffer = new_yv12.u_buffer + recon_uvoffset;
            XD.dst.v_buffer = new_yv12.v_buffer + recon_uvoffset;
            XD.left_available = cast(s32) (mb_col != 0);

            vp8_copy_mem16x16_c(X.src.y_buffer, X.src.y_stride, X.thismb.data, 16);

            this_error = vp8_encode_intra(X, use_dc_pred);

            this_error += intrapenalty;

            intra_error += cast,no_check(s64) this_error;

            X.mv_col_min = -(mb_col * 16 + cast,no_check(s32) ((32 - 16)));
            X.mv_col_max = (CM.mb_cols - 1 - mb_col) * 16 + cast,no_check(s32) ((32 - 16));

            if CM.current_video_frame > 0 {
                d := X.e_mbd.block.data + 0;
                tmp_mv: MV_in_alloccommon;
                tmp_err: s32 = ---;
                motion_error: s32 = 2147483647;
                raw_motion_error: s32 = 2147483647;
                zz_motion_search(
                    X,
                    cpi.last_frame_unscaled_source,
                    *raw_motion_error,
                    lst_yv12,
                    *motion_error,
                    recon_yoffset
                );
                d.bmi.mv.as_mv.row = 0;
                d.bmi.mv.as_mv.col = 0;
                while skip_motion_search := true { // Forward-goto shim; executes at most once.
                    if raw_motion_error < cpi.oxcf.encode_breakout {
                        break skip_motion_search;
                    }
                    first_pass_motion_search(
                        cpi,
                        X,
                        *best_ref_mv,
                        *d.bmi.mv.as_mv,
                        lst_yv12,
                        *motion_error,
                        recon_yoffset
                    );
                    if best_ref_mv.as_int != 0 {
                        tmp_err = 2147483647;
                        first_pass_motion_search(cpi, X, *zero_ref_mv, *tmp_mv, lst_yv12, *tmp_err, recon_yoffset);

                        if tmp_err < motion_error {
                            motion_error = tmp_err;
                            d.bmi.mv.as_mv.row = tmp_mv.row;
                            d.bmi.mv.as_mv.col = tmp_mv.col;
                        }
                    }
                    if CM.current_video_frame > 1 {
                        first_pass_motion_search(
                            cpi,
                            X,
                            *zero_ref_mv,
                            *tmp_mv,
                            gld_yv12,
                            *gf_motion_error,
                            recon_yoffset
                        );

                        if gf_motion_error < motion_error && gf_motion_error < this_error {
                            second_ref_count += 1;
                        }

                        XD.pre.y_buffer = lst_yv12.y_buffer + recon_yoffset;
                        XD.pre.u_buffer = lst_yv12.u_buffer + recon_uvoffset;
                        XD.pre.v_buffer = lst_yv12.v_buffer + recon_uvoffset;
                    }
                    break skip_motion_search;
                }
                best_ref_mv.as_int = 0;
                if motion_error <= this_error {
                    if (this_error - intrapenalty) * 9 <= motion_error * 10 && this_error < 2 * intrapenalty {
                        neutral_count += 1;
                    }

                    d.bmi.mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) d.bmi.mv.as_mv.row) * 8);
                    d.bmi.mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) d.bmi.mv.as_mv.col) * 8);
                    this_error = motion_error;
                    (cast,no_check(#type (_: *MACROBLOCK_in_block, _: MB_PREDICTION_MODE, _: *Int_Mv_in_mv)) (cast(*void) vp8_set_mbmode_and_mvs))(
                        X,
                        cast,no_check(MB_PREDICTION_MODE) NEWMV,
                        *d.bmi.mv
                    );
                    vp8_encode_inter16x16y(X);
                    sum_mvr += cast,no_check(s32) d.bmi.mv.as_mv.row;
                    sum_mvr_abs += absolute_value(cast,no_check(s32) d.bmi.mv.as_mv.row);
                    sum_mvc += cast,no_check(s32) d.bmi.mv.as_mv.col;
                    sum_mvc_abs += absolute_value(cast,no_check(s32) d.bmi.mv.as_mv.col);
                    sum_mvrs += (cast(s32) d.bmi.mv.as_mv.row) * cast(s32) d.bmi.mv.as_mv.row;
                    sum_mvcs += (cast(s32) d.bmi.mv.as_mv.col) * cast(s32) d.bmi.mv.as_mv.col;
                    intercount += 1;

                    best_ref_mv.as_int = d.bmi.mv.as_int;

                    if d.bmi.mv.as_int != 0 {
                        mvcount += 1;

                        if d.bmi.mv.as_int != lastmv_as_int {
                            new_mv_count += 1;
                        }
                        lastmv_as_int = d.bmi.mv.as_int;

                        if mb_row < CM.mb_rows / 2 {
                            if d.bmi.mv.as_mv.row > 0 {
                                sum_in_vectors -= 1;
                            } else if d.bmi.mv.as_mv.row < 0 {
                                sum_in_vectors += 1;
                            }
                        } else if mb_row > CM.mb_rows / 2 {
                            if d.bmi.mv.as_mv.row > 0 {
                                sum_in_vectors += 1;
                            } else if d.bmi.mv.as_mv.row < 0 {
                                sum_in_vectors -= 1;
                            }
                        }

                        if mb_col < CM.mb_cols / 2 {
                            if d.bmi.mv.as_mv.col > 0 {
                                sum_in_vectors -= 1;
                            } else if d.bmi.mv.as_mv.col < 0 {
                                sum_in_vectors += 1;
                            }
                        } else if mb_col > CM.mb_cols / 2 {
                            if d.bmi.mv.as_mv.col > 0 {
                                sum_in_vectors += 1;
                            } else if d.bmi.mv.as_mv.col < 0 {
                                sum_in_vectors -= 1;
                            }
                        }
                    }
                }
            }

            coded_error += cast,no_check(s64) this_error;

            X.src.y_buffer += 16;
            X.src.u_buffer += 8;
            X.src.v_buffer += 8;

            recon_yoffset += 16;
            recon_uvoffset += 8;
            mb_col += 1;
        }

        X.src.y_buffer += 16 * X.src.y_stride - 16 * CM.mb_cols;
        X.src.u_buffer += 8 * X.src.uv_stride - 8 * CM.mb_cols;
        X.src.v_buffer += 8 * X.src.uv_stride - 8 * CM.mb_cols;

        vp8_extend_mb_row(new_yv12, XD.dst.y_buffer + 16, XD.dst.u_buffer + 8, XD.dst.v_buffer + 8);
        mb_row += 1;
    }

    {
        weight: float64 = 0.0;

        fps: FIRSTPASS_STATS = ---;

        fps.frame = cast,no_check(float64) CM.current_video_frame;
        fps.intra_error = cast,no_check(float64) (intra_error >> 8);
        fps.coded_error = cast,no_check(float64) (coded_error >> 8);
        weight = simple_weight(cpi.source);

        if c_transpiler_float_less(weight, 0.1) {
            weight = 0.1;
        }

        fps.ssim_weighted_pred_err = fps.coded_error * weight;

        fps.pcnt_inter = 0.0;
        fps.pcnt_motion = 0.0;
        fps.m_vr = 0.0;
        fps.mvr_abs = 0.0;
        fps.m_vc = 0.0;
        fps.mvc_abs = 0.0;
        fps.m_vrv = 0.0;
        fps.m_vcv = 0.0;
        fps.mv_in_out_count = 0.0;
        fps.new_mv_count = 0.0;
        fps.count = 1.0;

        fps.pcnt_inter = (1.0 * cast,no_check(float64) intercount) / CM.m_bs;
        fps.pcnt_second_ref = (1.0 * cast,no_check(float64) second_ref_count) / CM.m_bs;
        fps.pcnt_neutral = (1.0 * cast,no_check(float64) neutral_count) / CM.m_bs;

        if mvcount > 0 {
            fps.m_vr = (cast,no_check(float64) sum_mvr) / cast,no_check(float64) mvcount;
            fps.mvr_abs = (cast,no_check(float64) sum_mvr_abs) / cast,no_check(float64) mvcount;
            fps.m_vc = (cast,no_check(float64) sum_mvc) / cast,no_check(float64) mvcount;
            fps.mvc_abs = (cast,no_check(float64) sum_mvc_abs) / cast,no_check(float64) mvcount;
            fps.m_vrv =
                ((cast,no_check(float64) sum_mvrs) - fps.m_vr * fps.m_vr / cast,no_check(float64) mvcount) /
                    cast,no_check(float64) mvcount;
            fps.m_vcv =
                ((cast,no_check(float64) sum_mvcs) - fps.m_vc * fps.m_vc / cast,no_check(float64) mvcount) /
                    cast,no_check(float64) mvcount;
            fps.mv_in_out_count = (cast,no_check(float64) sum_in_vectors) / cast,no_check(float64) (mvcount * 2);
            fps.new_mv_count = cast,no_check(float64) new_mv_count;

            fps.pcnt_motion = (1.0 * cast,no_check(float64) mvcount) / cpi.common.m_bs;
        }

        fps.duration = cast,no_check(float64) (cpi.source_2.ts_end - cpi.source_2.ts_start);

        cpi.twopass.this_frame_stats = fps;
        output_stats(cpi.output_pkt_list, *cpi.twopass.this_frame_stats);
        accumulate_stats(*cpi.twopass.total_stats, *fps);
    }

    if CM.current_video_frame > 0 &&
        c_transpiler_float_greater(cpi.twopass.this_frame_stats.pcnt_inter, 0.2) &&
        c_transpiler_float_greater((cpi.twopass.this_frame_stats.intra_error / (ifx c_transpiler_float_less(cpi.twopass.this_frame_stats.coded_error, 0.0) then cpi.twopass.this_frame_stats.coded_error - 0.000001 else cpi.twopass.this_frame_stats.coded_error + 0.000001)), 2.0) {
        vp8_yv12_copy_frame_c(lst_yv12, gld_yv12);
    }

    vp8_swap_yv12_buffer(lst_yv12, new_yv12);
    vp8_yv12_extend_frame_borders_c(lst_yv12);

    if CM.current_video_frame == 0 {
        vp8_yv12_copy_frame_c(lst_yv12, gld_yv12);
    }

    CM.current_video_frame += 1;
}

accumulate_stats :: (section: *FIRSTPASS_STATS, frame: *FIRSTPASS_STATS) {
    section.frame += frame.frame;
    section.intra_error += frame.intra_error;
    section.coded_error += frame.coded_error;
    section.ssim_weighted_pred_err += frame.ssim_weighted_pred_err;
    section.pcnt_inter += frame.pcnt_inter;
    section.pcnt_motion += frame.pcnt_motion;
    section.pcnt_second_ref += frame.pcnt_second_ref;
    section.pcnt_neutral += frame.pcnt_neutral;
    section.m_vr += frame.m_vr;
    section.mvr_abs += frame.mvr_abs;
    section.m_vc += frame.m_vc;
    section.mvc_abs += frame.mvc_abs;
    section.m_vrv += frame.m_vrv;
    section.m_vcv += frame.m_vcv;
    section.mv_in_out_count += frame.mv_in_out_count;
    section.new_mv_count += frame.new_mv_count;
    section.count += frame.count;
    section.duration += frame.duration;
}

output_stats :: (pktlist: *Codec_Pkt_List, stats: *FIRSTPASS_STATS) {
    pkt: Codec_Cx_Pkt = ---;
    pkt.kind = cast,no_check(Codec_Cx_Pkt_Kind) CODEC_STATS_PKT;
    pkt.data.twopass_stats.buf = cast(*void) stats;
    pkt.data.twopass_stats.sz = cast(u64) size_of(FIRSTPASS_STATS);
    codec_pkt_list_add(pktlist, *pkt);
}

simple_weight :: (source: *YV12_BUFFER_CONFIG) -> float64 {
    j: s32 = ---;

    src: *u8 = source.y_buffer;
    sum_weights: float64 = 0.0;

    i := source.y_height;
    while true {
        j = source.y_width;
        while true {
            sum_weights += WEIGHT_TABLE[src.*];
            src += 1;
            if c_transpiler_pre_decrement(*(j)) == 0 break;
        }
        src -= source.y_width;
        src += source.y_stride;
        if c_transpiler_pre_decrement(*(i)) == 0 break;
    }

    sum_weights /= cast,no_check(float64) (source.y_height * source.y_width);

    return sum_weights;
}

first_pass_motion_search :: (
    cpi: *VP8_COMP,
    x: *MACROBLOCK_in_block,
    ref_mv: *Int_Mv_in_mv,
    best_mv: *MV_in_alloccommon,
    recon_buffer: *YV12_BUFFER_CONFIG,
    best_motion_err: *s32,
    recon_yoffset: s32
) {
    XD := *x.e_mbd;
    b := x.block.data + 0;
    d := x.e_mbd.block.data + 0;
    num00: s32 = ---;

    tmp_mv: Int_Mv_in_mv = ---;
    ref_mv_full: Int_Mv_in_mv = ---;

    step_param: s32 = 3;
    further_steps := (cast,no_check(s32) ((8 - 1))) - step_param;

    v_fn_ptr := cpi.fn_ptr[BLOCK_16X16];
    new_mv_mode_penalty: s32 = 256;

    v_fn_ptr.vf = mse16x16_c;

    XD.pre.y_buffer = recon_buffer.y_buffer + recon_yoffset;

    tmp_mv.as_int = 0;
    ref_mv_full.as_mv.col = cast,no_check(s16) ((cast(s32) ref_mv.as_mv.col) >> 3);
    ref_mv_full.as_mv.row = cast,no_check(s16) ((cast(s32) ref_mv.as_mv.row) >> 3);
    tmp_err :=
        cpi.diamond_search_sad(
            x,
            b,
            d,
            *ref_mv_full,
            *tmp_mv,
            step_param,
            x.sadperbit16,
            *num00,
            *v_fn_ptr,
            x.mvcost.data,
            ref_mv
        );
    if tmp_err < 2147483647 - new_mv_mode_penalty {
        tmp_err += new_mv_mode_penalty;
    }

    if tmp_err < best_motion_err.* {
        best_motion_err.* = tmp_err;
        best_mv.row = tmp_mv.as_mv.row;
        best_mv.col = tmp_mv.as_mv.col;
    }

    n := num00;
    num00 = 0;

    while n < further_steps {
        n += 1;

        if num00 != 0 {
            num00 -= 1;
        } else {
            tmp_err =
                cpi.diamond_search_sad(
                    x,
                    b,
                    d,
                    *ref_mv_full,
                    *tmp_mv,
                    step_param + n,
                    x.sadperbit16,
                    *num00,
                    *v_fn_ptr,
                    x.mvcost.data,
                    ref_mv
                );
            if tmp_err < 2147483647 - new_mv_mode_penalty {
                tmp_err += new_mv_mode_penalty;
            }

            if tmp_err < best_motion_err.* {
                best_motion_err.* = tmp_err;
                best_mv.row = tmp_mv.as_mv.row;
                best_mv.col = tmp_mv.as_mv.col;
            }
        }
    }
}

zz_motion_search :: (
    x: *MACROBLOCK_in_block,
    raw_buffer: *YV12_BUFFER_CONFIG,
    raw_motion_err: *s32,
    recon_buffer: *YV12_BUFFER_CONFIG,
    best_motion_err: *s32,
    recon_yoffset: s32
) {
    XD := *x.e_mbd;
    b := x.block.data + 0;
    d := x.e_mbd.block.data + 0;

    src_ptr := b.base_src.* + b.src;
    src_stride := b.src_stride;

    raw_stride := raw_buffer.y_stride;

    ref_stride := x.e_mbd.pre.y_stride;

    raw_ptr := raw_buffer.y_buffer + recon_yoffset + d.offset;
    mse16x16_c(src_ptr, src_stride, raw_ptr, raw_stride, cast(*u32) raw_motion_err);

    XD.pre.y_buffer = recon_buffer.y_buffer + recon_yoffset;
    ref_ptr := XD.pre.y_buffer + d.offset;
    mse16x16_c(src_ptr, src_stride, ref_ptr, ref_stride, cast(*u32) best_motion_err);
}

vp8_end_first_pass :: (cpi: *VP8_COMP) {
    output_stats(cpi.output_pkt_list, *cpi.twopass.total_stats);
}

vp8_init_second_pass :: (cpi: *VP8_COMP) {
    this_frame: FIRSTPASS_STATS = ---;
    start_pos: *FIRSTPASS_STATS = ---;

    two_pass_min_rate :=
        cast,no_check(float64) ((cpi.oxcf.target_bandwidth * cast,no_check(u32) cpi.oxcf.two_pass_vbrmin_section) /
            100);

    zero_stats(*cpi.twopass.total_stats);
    zero_stats(*cpi.twopass.total_left_stats);

    if cpi.twopass.stats_in_end == null {
        return;
    }

    cpi.twopass.total_stats = cpi.twopass.stats_in_end.*;
    cpi.twopass.total_left_stats = cpi.twopass.total_stats;

    vp8_new_framerate(cpi, 10000000.0 * cpi.twopass.total_stats.count / cpi.twopass.total_stats.duration);

    cpi.twopass.bits_left =
        cast,no_check(s64) (cpi.twopass.total_stats.duration *
            cpi.oxcf.target_bandwidth / 10000000.0);
    cpi.twopass.bits_left -= cast,no_check(s64) (cpi.twopass.total_stats.duration * two_pass_min_rate / 10000000.0);

    cpi.twopass.kf_intra_err_min = cast,no_check(float64) (300 * cpi.common.m_bs);
    cpi.twopass.gf_intra_err_min = cast,no_check(float64) (200 * cpi.common.m_bs);

    {
        sum_iiratio: float64 = 0.0;

        start_pos = cpi.twopass.stats_in;

        while input_stats(cpi, *this_frame) != -1 {
            ii_ratio :=
                this_frame.intra_error /
                    (ifx c_transpiler_float_less(this_frame.coded_error, 0.0) then this_frame.coded_error - 0.000001 else this_frame.coded_error + 0.000001);
            ii_ratio =
                ifx c_transpiler_float_less(ii_ratio, 1.0) then 1.0 else (ifx c_transpiler_float_greater(ii_ratio, 20.0) then 20.0 else ii_ratio);
            sum_iiratio += ii_ratio;
        }

        cpi.twopass.avg_iiratio =
            sum_iiratio /
                (ifx c_transpiler_float_less(cpi.twopass.total_stats.count, 0.0) then cpi.twopass.total_stats.count - 0.000001 else cpi.twopass.total_stats.count + 0.000001);

        reset_fpf_position(cpi, start_pos);
    }

    start_pos = cpi.twopass.stats_in;

    cpi.twopass.modified_error_total = 0.0;
    cpi.twopass.modified_error_used = 0.0;

    while input_stats(cpi, *this_frame) != -1 {
        cpi.twopass.modified_error_total += calculate_modified_err(cpi, *this_frame);
    }
    cpi.twopass.modified_error_left = cpi.twopass.modified_error_total;

    reset_fpf_position(cpi, start_pos);
}

reset_fpf_position :: (cpi: *VP8_COMP, position: *FIRSTPASS_STATS) {
    cpi.twopass.stats_in = position;
}

calculate_modified_err :: (cpi: *VP8_COMP, this_frame: *FIRSTPASS_STATS) -> float64 {
    av_err := cpi.twopass.total_stats.ssim_weighted_pred_err / cpi.twopass.total_stats.count;
    this_err := this_frame.ssim_weighted_pred_err;

    modified_err: float64 = ifx c_transpiler_float_greater(this_err, av_err)
        then av_err * c_transpiler_math_pow(
            this_err / (ifx c_transpiler_float_less(av_err, 0.0) then av_err - 0.000001 else av_err + 0.000001),
            (cast,no_check(float64) cpi.oxcf.two_pass_vbrbias) / 100.0
        )
        else av_err * c_transpiler_math_pow(
            this_err / (ifx c_transpiler_float_less(av_err, 0.0) then av_err - 0.000001 else av_err + 0.000001),
            (cast,no_check(float64) cpi.oxcf.two_pass_vbrbias) / 100.0
        );

    return modified_err;
}

input_stats :: (cpi: *VP8_COMP, fps: *FIRSTPASS_STATS) -> s32 {
    if cpi.twopass.stats_in >= cpi.twopass.stats_in_end {
        return -1;
    }

    fps.* = cpi.twopass.stats_in.*;
    cpi.twopass.stats_in =
        cast(*FIRSTPASS_STATS) (cast(*void) ((cast(*s8) cpi.twopass.stats_in) +
            cast(u64) size_of(FIRSTPASS_STATS)));
    return 1;
}

vp8_second_pass :: (cpi: *VP8_COMP) {
    tmp_q: s32 = ---;
    frames_left := cast,no_check(s32) (cpi.twopass.total_stats.count - cpi.common.current_video_frame);

    this_frame: FIRSTPASS_STATS = ---;
    this_frame_copy: FIRSTPASS_STATS = ---;

    fill_memory(*this_frame, 0, size_of(FIRSTPASS_STATS));

    if cpi.twopass.stats_in == null {
        return;
    }

    if -1 == input_stats(cpi, *this_frame) {
        return;
    }

    this_frame_intra_error := this_frame.intra_error;
    this_frame_coded_error := this_frame.coded_error;

    if cpi.twopass.frames_to_key == 0 {
        this_frame_copy = this_frame;
        find_next_key_frame(cpi, *this_frame_copy);

        if cpi.oxcf.error_resilient_mode != 0 {
            cpi.twopass.gf_group_bits = cpi.twopass.kf_group_bits;
            cpi.twopass.gf_group_error_left = cast,no_check(s32) cpi.twopass.kf_group_error_left;
            cpi.baseline_gf_interval = cpi.twopass.frames_to_key;
            cpi.frames_till_gf_update_due = cpi.baseline_gf_interval;
            cpi.source_alt_ref_pending = 0;
        }
    }

    if cpi.frames_till_gf_update_due == 0 {
        this_frame_copy = this_frame;
        define_gf_group(cpi, *this_frame_copy);

        if cpi.source_alt_ref_pending != 0 && cpi.common.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
            bak := cpi.per_frame_bandwidth;
            this_frame_copy = this_frame;
            assign_std_frame_bits(cpi, *this_frame_copy);
            cpi.per_frame_bandwidth = bak;
        }
    } else if cpi.oxcf.error_resilient_mode != 0 {
        cpi.frames_till_gf_update_due = cpi.twopass.frames_to_key;

        if cpi.common.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
            this_frame_copy = this_frame;
            assign_std_frame_bits(cpi, *this_frame_copy);
        }
    } else {
        this_frame_copy = this_frame;
        assign_std_frame_bits(cpi, *this_frame_copy);
    }

    cpi.twopass.this_iiratio =
        cast,no_check(u32) (this_frame_intra_error /
            (ifx c_transpiler_float_less(this_frame_coded_error, 0.0) then this_frame_coded_error - 0.000001 else this_frame_coded_error + 0.000001));
    {
        next_frame: FIRSTPASS_STATS = ---;
        if lookup_next_frame_stats(cpi, *next_frame) != -1 {
            cpi.twopass.next_iiratio =
                cast,no_check(u32) (next_frame.intra_error /
                    (ifx c_transpiler_float_less(next_frame.coded_error, 0.0) then next_frame.coded_error - 0.000001 else next_frame.coded_error + 0.000001));
        }
    }

    cpi.target_bandwidth = cast,no_check(s32) (cpi.per_frame_bandwidth * cpi.output_framerate);
    if cpi.target_bandwidth < 0 {
        cpi.target_bandwidth = 0;
    }

    overhead_bits := cast,no_check(s32) estimate_modemvcost(cpi, *cpi.twopass.total_left_stats);

    if cpi.common.current_video_frame == 0 {
        cpi.twopass.est_max_qcorrection_factor = 1.0;

        section_target_bandwidth := cpi.twopass.bits_left / cast(s64) frames_left;
        section_target_bandwidth =
            ifx section_target_bandwidth < 2147483647 then section_target_bandwidth else 2147483647;

        if cpi.oxcf.end_usage == USAGE_CONSTRAINED_QUALITY {
            est_cq :=
                estimate_cq(
                    cpi,
                    *cpi.twopass.total_left_stats,
                    cast,no_check(s32) section_target_bandwidth,
                    overhead_bits
                );

            cpi.cq_target_quality = cpi.oxcf.cq_level;
            if est_cq > cpi.cq_target_quality {
                cpi.cq_target_quality = est_cq;
            }
        }

        cpi.twopass.maxq_max_limit = cpi.worst_quality;
        cpi.twopass.maxq_min_limit = cpi.best_quality;

        tmp_q =
            estimate_max_q(
                cpi,
                *cpi.twopass.total_left_stats,
                cast,no_check(s32) section_target_bandwidth,
                overhead_bits
            );

        cpi.twopass.maxq_max_limit = ifx tmp_q + 32 < cpi.worst_quality then tmp_q + 32 else cpi.worst_quality;
        cpi.twopass.maxq_min_limit = ifx tmp_q - 32 > cpi.best_quality then tmp_q - 32 else cpi.best_quality;

        cpi.active_worst_quality = tmp_q;
        cpi.ni_av_qi = tmp_q;
    } else if cpi.common.current_video_frame < ((cast,no_check(u32) cpi.twopass.total_stats.count) * 255) >> 8 &&
        (cpi.common.current_video_frame + cast,no_check(u32) cpi.baseline_gf_interval) < cast,no_check(u32) cpi.twopass.total_stats.count {
        if frames_left < 1 {
            frames_left = 1;
        }

        section_target_bandwidth := cpi.twopass.bits_left / cast(s64) frames_left;
        section_target_bandwidth =
            ifx section_target_bandwidth < 2147483647 then section_target_bandwidth else 2147483647;

        tmp_q =
            estimate_max_q(
                cpi,
                *cpi.twopass.total_left_stats,
                cast,no_check(s32) section_target_bandwidth,
                overhead_bits
            );

        if tmp_q > cpi.active_worst_quality {
            cpi.active_worst_quality += 1;
        } else if tmp_q < cpi.active_worst_quality {
            cpi.active_worst_quality -= 1;
        }

        cpi.active_worst_quality = (cpi.active_worst_quality * 3 + tmp_q + 2) / 4;
    }

    cpi.twopass.frames_to_key -= 1;

    subtract_stats(*cpi.twopass.total_left_stats, *this_frame);
}

subtract_stats :: (section: *FIRSTPASS_STATS, frame: *FIRSTPASS_STATS) {
    section.frame -= frame.frame;
    section.intra_error -= frame.intra_error;
    section.coded_error -= frame.coded_error;
    section.ssim_weighted_pred_err -= frame.ssim_weighted_pred_err;
    section.pcnt_inter -= frame.pcnt_inter;
    section.pcnt_motion -= frame.pcnt_motion;
    section.pcnt_second_ref -= frame.pcnt_second_ref;
    section.pcnt_neutral -= frame.pcnt_neutral;
    section.m_vr -= frame.m_vr;
    section.mvr_abs -= frame.mvr_abs;
    section.m_vc -= frame.m_vc;
    section.mvc_abs -= frame.mvc_abs;
    section.m_vrv -= frame.m_vrv;
    section.m_vcv -= frame.m_vcv;
    section.mv_in_out_count -= frame.mv_in_out_count;
    section.new_mv_count -= frame.new_mv_count;
    section.count -= frame.count;
    section.duration -= frame.duration;
}

estimate_max_q :: (
    cpi: *VP8_COMP,
    fpstats: *FIRSTPASS_STATS,
    section_target_bandwitdh: s32,
    overhead_bits: s32
) -> s32 {
    num_mbs := cpi.common.m_bs;

    section_err := fpstats.coded_error / fpstats.count;
    err_per_mb := section_err / num_mbs;

    speed_correction: float64 = 1.0;

    if section_target_bandwitdh <= 0 {
        return cpi.twopass.maxq_max_limit;
    }

    target_norm_bits_per_mb :=
        (ifx section_target_bandwitdh < (cast(s32) 1) << 20 then 512 *
            section_target_bandwitdh / num_mbs else 512 * (section_target_bandwitdh / num_mbs));

    if cpi.rolling_target_bits > 0 && cpi.active_worst_quality < cpi.worst_quality {
        rolling_ratio :=
            (cast,no_check(float64) cpi.rolling_actual_bits) /
                cast,no_check(float64) cpi.rolling_target_bits;

        if c_transpiler_float_less(rolling_ratio, 0.95) {
            cpi.twopass.est_max_qcorrection_factor -= 0.005;
        } else if c_transpiler_float_greater(rolling_ratio, 1.05) {
            cpi.twopass.est_max_qcorrection_factor += 0.005;
        }

        cpi.twopass.est_max_qcorrection_factor =
            ifx c_transpiler_float_less(cpi.twopass.est_max_qcorrection_factor, 0.1) then 0.1 else (ifx c_transpiler_float_greater(cpi.twopass.est_max_qcorrection_factor, 10.0) then 10.0 else cpi.twopass.est_max_qcorrection_factor);
    }

    if cpi.compressor_speed == 3 || cpi.compressor_speed == 1 {
        if cpi.oxcf.cpu_used <= 5 {
            speed_correction = 1.04 + (cast,no_check(float64) cpi.oxcf.cpu_used) * 0.04;
        } else {
            speed_correction = 1.25;
        }
    }

    overhead_bits_per_mb := overhead_bits / num_mbs;
    overhead_bits_per_mb =
        cast,no_check(s32) (overhead_bits_per_mb * c_transpiler_math_pow(
            0.98,
            cast,no_check(float64) cpi.twopass.maxq_min_limit
        ));

    q := cpi.twopass.maxq_min_limit;
    while q < cpi.twopass.maxq_max_limit {
        err_correction_factor := calc_correction_factor(err_per_mb, 150.0, 0.4, 0.9, q);

        bits_per_mb_at_this_q := VP8_BITS_PER_MB[INTER_FRAME_in_alloccommon][q] + overhead_bits_per_mb;

        bits_per_mb_at_this_q =
            cast,no_check(s32) (0.5 +
                err_correction_factor * speed_correction * cpi.twopass.est_max_qcorrection_factor * cpi.twopass.section_max_qfactor * cast,no_check(float64) bits_per_mb_at_this_q);

        overhead_bits_per_mb = cast,no_check(s32) ((cast,no_check(float64) overhead_bits_per_mb) * 0.98);

        if bits_per_mb_at_this_q <= target_norm_bits_per_mb {
            break;
        }
        q += 1;
    }

    if cpi.oxcf.end_usage == USAGE_CONSTRAINED_QUALITY && q < cpi.cq_target_quality {
        q = cpi.cq_target_quality;
    }

    if cpi.ni_frames > (cast,no_check(s32) cpi.twopass.total_stats.count) >> 8 && cpi.ni_frames > 150 {
        cpi.twopass.maxq_max_limit =
            ifx cpi.ni_av_qi + 32 < cpi.worst_quality then cpi.ni_av_qi +
                32 else cpi.worst_quality;
        cpi.twopass.maxq_min_limit =
            ifx cpi.ni_av_qi - 32 > cpi.best_quality then cpi.ni_av_qi -
                32 else cpi.best_quality;
    }

    return q;
}

calc_correction_factor :: (
    err_per_mb: float64,
    err_devisor: float64,
    pt_low: float64,
    pt_high: float64,
    q: s32
) -> float64 {
    error_term := err_per_mb / err_devisor;

    power_term := pt_low + (cast,no_check(float64) q) * 0.01;
    power_term = ifx c_transpiler_float_greater(power_term, pt_high) then pt_high else power_term;

    correction_factor := c_transpiler_math_pow(error_term, power_term);

    correction_factor =
        ifx c_transpiler_float_less(correction_factor, 0.05) then 0.05 else (ifx c_transpiler_float_greater(correction_factor, 5.0) then 5.0 else correction_factor);

    return correction_factor;
}

estimate_cq :: (cpi: *VP8_COMP, fpstats: *FIRSTPASS_STATS, section_target_bandwitdh: s32, overhead_bits: s32) -> s32 {
    num_mbs := cpi.common.m_bs;

    section_err := fpstats.coded_error / fpstats.count;
    err_per_mb := section_err / num_mbs;

    speed_correction: float64 = 1.0;

    target_norm_bits_per_mb :=
        (ifx section_target_bandwitdh < (cast(s32) 1) << 20 then 512 *
            section_target_bandwitdh / num_mbs else 512 * (section_target_bandwitdh / num_mbs));

    overhead_bits_per_mb := overhead_bits / num_mbs;

    if cpi.compressor_speed == 3 || cpi.compressor_speed == 1 {
        if cpi.oxcf.cpu_used <= 5 {
            speed_correction = 1.04 + (cast,no_check(float64) cpi.oxcf.cpu_used) * 0.04;
        } else {
            speed_correction = 1.25;
        }
    }

    clip_iiratio :=
        cpi.twopass.total_stats.intra_error /
            (ifx c_transpiler_float_less(cpi.twopass.total_stats.coded_error, 0.0) then cpi.twopass.total_stats.coded_error - 0.000001 else cpi.twopass.total_stats.coded_error + 0.000001);
    clip_iifactor := 1.0 - (clip_iiratio - 10.0) * 0.025;
    if c_transpiler_float_less(clip_iifactor, 0.8) {
        clip_iifactor = 0.8;
    }

    q: s32 = 0;
    while q < 127 {
        err_correction_factor := calc_correction_factor(err_per_mb, 100.0, 0.4, 0.9, q);

        bits_per_mb_at_this_q := VP8_BITS_PER_MB[INTER_FRAME_in_alloccommon][q] + overhead_bits_per_mb;

        bits_per_mb_at_this_q =
            cast,no_check(s32) (0.5 +
                err_correction_factor * speed_correction * clip_iifactor * cast,no_check(float64) bits_per_mb_at_this_q);

        overhead_bits_per_mb = cast,no_check(s32) ((cast,no_check(float64) overhead_bits_per_mb) * 0.98);

        if bits_per_mb_at_this_q <= target_norm_bits_per_mb {
            break;
        }
        q += 1;
    }

    q = CQ_LEVEL[q];
    if q >= cpi.worst_quality {
        q = cpi.worst_quality - 1;
    }
    if q < cpi.best_quality {
        q = cpi.best_quality;
    }

    return q;
}

estimate_modemvcost :: (cpi: *VP8_COMP, fpstats: *FIRSTPASS_STATS) -> s64 {
    av_pct_inter := fpstats.pcnt_inter / fpstats.count;
    av_pct_motion := fpstats.pcnt_motion / fpstats.count;
    av_intra := 1.0 - av_pct_inter;

    zz_cost := bitcost(av_pct_inter - av_pct_motion);
    motion_cost := bitcost(av_pct_motion);
    intra_cost := bitcost(av_intra);

    mv_cost := ((cast,no_check(s32) (fpstats.new_mv_count / fpstats.count)) * 8) << 9;

    mode_cost :=
        (cast,no_check(s64) (((av_pct_inter - av_pct_motion) * zz_cost + av_pct_motion * motion_cost + av_intra * intra_cost) * cpi.common.m_bs)) *
            512;

    return (cast(s64) mv_cost) + mode_cost;
}

bitcost :: (prob: float64) -> float64 {
    if c_transpiler_float_greater(prob, 0.000122) {
        return -c_transpiler_math_log(prob) / c_transpiler_math_log(2.0);
    } else {
        return 13.0;
    }
}

lookup_next_frame_stats :: (cpi: *VP8_COMP, next_frame: *FIRSTPASS_STATS) -> s32 {
    if cpi.twopass.stats_in >= cpi.twopass.stats_in_end {
        return -1;
    }

    next_frame.* = cpi.twopass.stats_in.*;
    return 1;
}

assign_std_frame_bits :: (cpi: *VP8_COMP, this_frame: *FIRSTPASS_STATS) {
    max_bits := frame_max_bits(cpi);

    modified_err := calculate_modified_err(cpi, this_frame);

    err_fraction: float64 = ifx cpi.twopass.gf_group_error_left > 0
        then modified_err / cpi.twopass.gf_group_error_left
        else 0.0;

    target_frame_size :=
        saturate_cast_double_to_int_in_firstpass(
            (cast,no_check(float64) cpi.twopass.gf_group_bits) * err_fraction
        );

    if target_frame_size < 0 {
        target_frame_size = 0;
    } else {
        if target_frame_size > max_bits {
            target_frame_size = max_bits;
        }

        if cast,no_check(s64) target_frame_size > cpi.twopass.gf_group_bits {
            target_frame_size = cast,no_check(s32) cpi.twopass.gf_group_bits;
        }
    }

    cpi.twopass.gf_group_error_left -= cast,no_check(s32) modified_err;
    cpi.twopass.gf_group_bits -= cast,no_check(s64) target_frame_size;

    if cpi.twopass.gf_group_bits < 0 {
        cpi.twopass.gf_group_bits = 0;
    }

    target_frame_size += cpi.min_frame_bandwidth;

    if cpi.frames_since_golden & 0x1 != 0 && cpi.frames_till_gf_update_due > 0 {
        target_frame_size += cpi.twopass.alt_extra_bits;
    }

    cpi.per_frame_bandwidth = target_frame_size;
}

frame_max_bits :: (cpi: *VP8_COMP) -> s32 {
    max_bits: s32 = ---;

    if cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER {
        buffer_fullness_ratio :=
            (cast,no_check(float64) cpi.buffer_level) /
                (ifx c_transpiler_float_less(cast,no_check(float64) cpi.oxcf.optimal_buffer_level, 0.0) then (cast,no_check(float64) cpi.oxcf.optimal_buffer_level) - 0.000001 else (cast,no_check(float64) cpi.oxcf.optimal_buffer_level) + 0.000001);

        max_bits =
            cast,no_check(s32) (cpi.av_per_frame_bandwidth *
                ((cast,no_check(float64) cpi.oxcf.two_pass_vbrmax_section) / 100.0));

        if c_transpiler_float_less(buffer_fullness_ratio, 1.0) {
            min_max_bits :=
                (ifx cpi.av_per_frame_bandwidth >> 2 < max_bits >> 2 then cpi.av_per_frame_bandwidth >> 2 else max_bits >> 2);

            max_bits = cast,no_check(s32) (max_bits * buffer_fullness_ratio);

            if max_bits < min_max_bits {
                max_bits = min_max_bits;
            }
        }
    } else {
        max_bits =
            saturate_cast_double_to_int_in_firstpass(
                ((cast,no_check(float64) cpi.twopass.bits_left) / (cpi.twopass.total_stats.count - cast,no_check(float64) cpi.common.current_video_frame)) *
                ((cast,no_check(float64) cpi.oxcf.two_pass_vbrmax_section) / 100.0)
            );
    }

    if max_bits < 0 {
        max_bits = 0;
    }

    return max_bits;
}

define_gf_group :: (cpi: *VP8_COMP, this_frame: *FIRSTPASS_STATS) {
    next_frame: FIRSTPASS_STATS = ---;

    boost_score: float64 = 0.0;
    old_boost_score: float64 = 0.0;
    gf_group_err: float64 = 0.0;
    gf_first_frame_err: float64 = 0.0;
    mod_frame_err: float64 = 0.0;

    mv_ratio_accumulator: float64 = 0.0;
    decay_accumulator: float64 = 1.0;

    loop_decay_rate: float64 = 1.0;

    this_frame_mv_in_out: float64 = 0.0;
    mv_in_out_accumulator: float64 = 0.0;
    abs_mv_in_out_accumulator: float64 = 0.0;

    max_bits := frame_max_bits(cpi);

    allow_alt_ref := cast(u32) (cpi.oxcf.play_alternate != 0 && cpi.oxcf.lag_in_frames != 0);

    alt_boost: s32 = 0;
    f_boost: s32 = 0;
    b_boost: s32 = 0;

    cpi.twopass.gf_group_bits = 0;
    cpi.twopass.gf_decay_rate = 0;

    start_pos := cpi.twopass.stats_in;

    fill_memory(*next_frame, 0, size_of(FIRSTPASS_STATS));

    mod_frame_err = calculate_modified_err(cpi, this_frame);

    gf_first_frame_err = mod_frame_err;

    if cpi.common.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
        gf_group_err -= gf_first_frame_err;
    }

    i: s32 = 0;

    while (i < cpi.twopass.static_scene_max_gf_interval || cpi.twopass.frames_to_key - i < 4) && i < cpi.twopass.frames_to_key {
        i += 1;

        mod_frame_err = calculate_modified_err(cpi, this_frame);

        gf_group_err += mod_frame_err;

        if -1 == input_stats(cpi, *next_frame) {
            break;
        }

        flash_detected := detect_flash(cpi, 0);

        accumulate_frame_motion_stats(
            *next_frame,
            *this_frame_mv_in_out,
            *mv_in_out_accumulator,
            *abs_mv_in_out_accumulator,
            *mv_ratio_accumulator
        );

        r := calc_frame_boost(cpi, *next_frame, this_frame_mv_in_out);

        if flash_detected == 0 {
            loop_decay_rate = get_prediction_decay_rate(*next_frame);
            decay_accumulator = decay_accumulator * loop_decay_rate;
            decay_accumulator = ifx c_transpiler_float_less(decay_accumulator, 0.1) then 0.1 else decay_accumulator;
        }
        boost_score += decay_accumulator * r;

        if detect_transition_to_still(cpi, i, 5, loop_decay_rate, decay_accumulator) != 0 {
            allow_alt_ref = 0;
            boost_score = old_boost_score;
            break;
        }

        if i >= cpi.max_gf_interval && c_transpiler_float_less(decay_accumulator, 0.995) ||
            i > 4 &&
                cpi.twopass.frames_to_key - i >= 4 &&
                (c_transpiler_float_greater(boost_score, 20.0) || c_transpiler_float_less(next_frame.pcnt_inter, 0.75)) &&
                flash_detected == 0 &&
                (c_transpiler_float_greater(mv_ratio_accumulator, 100.0) ||
                    c_transpiler_float_greater(abs_mv_in_out_accumulator, 3.0) ||
                    c_transpiler_float_less(mv_in_out_accumulator, -2.0) ||
                    c_transpiler_float_less((boost_score - old_boost_score), 2.0)) {
            boost_score = old_boost_score;
            break;
        }

        this_frame.* = next_frame;

        old_boost_score = boost_score;
    }

    cpi.twopass.gf_decay_rate = ifx i > 0 then (cast,no_check(s32) (100.0 * (1.0 - decay_accumulator))) / i else 0;

    if cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER {
        max_boost: float64 = ---;

        if cpi.drop_frames_allowed != 0 {
            df_buffer_level := (cast(s64) cpi.oxcf.drop_frames_water_mark) * (cpi.oxcf.optimal_buffer_level / 100);

            if cpi.buffer_level > df_buffer_level {
                max_boost =
                    (cast,no_check(float64) (((cpi.buffer_level - df_buffer_level) * 2) / 3)) * 16.0 /
                        (ifx c_transpiler_float_less(cast,no_check(float64) cpi.av_per_frame_bandwidth, 0.0) then (cast,no_check(float64) cpi.av_per_frame_bandwidth) - 0.000001 else (cast,no_check(float64) cpi.av_per_frame_bandwidth) + 0.000001);
            } else {
                max_boost = 0.0;
            }
        } else if cpi.buffer_level > 0 {
            max_boost =
                (cast,no_check(float64) ((cpi.buffer_level * 2) / 3)) * 16.0 /
                    (ifx c_transpiler_float_less(cast,no_check(float64) cpi.av_per_frame_bandwidth, 0.0) then (cast,no_check(float64) cpi.av_per_frame_bandwidth) - 0.000001 else (cast,no_check(float64) cpi.av_per_frame_bandwidth) + 0.000001);
        } else {
            max_boost = 0.0;
        }

        if c_transpiler_float_greater(boost_score, max_boost) {
            boost_score = max_boost;
        }
    }

    if cpi.twopass.frames_to_key - i < 4 {
        while i < cpi.twopass.frames_to_key {
            i += 1;

            if -1 == input_stats(cpi, this_frame) {
                break;
            }

            if i < cpi.twopass.frames_to_key {
                mod_frame_err = calculate_modified_err(cpi, this_frame);
                gf_group_err += mod_frame_err;
            }
        }
    }

    cpi.gfu_boost = (cast,no_check(s32) (boost_score * 100.0)) >> 4;

    alt_boost = calc_arf_boost(cpi, 0, i - 1, i - 1, *f_boost, *b_boost);

    if allow_alt_ref != 0 &&
        i >= 4 &&
        i <= cpi.twopass.frames_to_key - 4 &&
        (c_transpiler_float_greater(next_frame.pcnt_inter, 0.75) || c_transpiler_float_greater(next_frame.pcnt_second_ref, 0.5)) &&
        (c_transpiler_float_greater((mv_in_out_accumulator / cast,no_check(float64) i), -0.2) ||
            c_transpiler_float_greater(mv_in_out_accumulator, -2.0)) &&
        b_boost > 100 &&
        f_boost > 100 {
        q := (ifx cpi.oxcf.fixed_q < 0 then cpi.last_q[INTER_FRAME_in_alloccommon] else cpi.oxcf.fixed_q);

        arf_frame_bits: s32 = 0;

        cpi.gfu_boost = alt_boost;

        group_bits: s32 = ifx cpi.twopass.kf_group_bits > 0 && cpi.twopass.kf_group_error_left > 0
            then cast,no_check(s32) ((cast,no_check(float64) cpi.twopass.kf_group_bits) * (gf_group_err / cast,no_check(float64) cpi.twopass.kf_group_error_left))
            else 0;

        boost := alt_boost * VP8_GF_BOOST_QADJUSTMENT[q] / 100;

        boost += i * 50;

        if boost > (cpi.baseline_gf_interval + 1) * 200 {
            boost = (cpi.baseline_gf_interval + 1) * 200;
        } else if boost < 125 {
            boost = 125;
        }

        allocation_chunks := i * 100 + boost;

        while boost > 1000 {
            boost /= 2;
            allocation_chunks /= 2;
        }

        arf_frame_bits =
            cast,no_check(s32) ((cast,no_check(float64) boost) *
                (group_bits / cast,no_check(float64) allocation_chunks));

        tmp_q := estimate_q(cpi, mod_frame_err, arf_frame_bits);

        if tmp_q < cpi.worst_quality {
            frames_bwd := cpi.oxcf.arnr_max_frames - 1;
            frames_fwd := cpi.oxcf.arnr_max_frames - 1;

            cpi.source_alt_ref_pending = 1;

            cpi.baseline_gf_interval = i;

            half_gf_int := cpi.baseline_gf_interval >> 1;
            frames_after_arf := cast,no_check(s32) (cpi.twopass.total_stats.count - this_frame.frame - 1.0);

            if cpi.oxcf.arnr_type == {
                case 1;
                    frames_fwd = 0;
                    if frames_bwd > half_gf_int {
                        frames_bwd = half_gf_int;
                    }
                case 2;
                    if frames_fwd > half_gf_int {
                        frames_fwd = half_gf_int;
                    }
                    if frames_fwd > frames_after_arf {
                        frames_fwd = frames_after_arf;
                    }
                    frames_bwd = 0;
                case 3; #through;
                case;
                    c_transpiler_compound_shr(*(frames_fwd), (cast(s32) 1), s32, s32);
                    if frames_fwd > frames_after_arf {
                        frames_fwd = frames_after_arf;
                    }
                    if frames_fwd > half_gf_int {
                        frames_fwd = half_gf_int;
                    }
                    frames_bwd = frames_fwd;
                    if frames_bwd < half_gf_int {
                        frames_bwd += (cpi.oxcf.arnr_max_frames + 1) & 0x1;
                    }
            }

            cpi.active_arnr_frames = frames_bwd + 1 + frames_fwd;
        } else {
            cpi.source_alt_ref_pending = 0;
            cpi.baseline_gf_interval = i;
        }
    } else {
        cpi.source_alt_ref_pending = 0;
        cpi.baseline_gf_interval = i;
    }

    if cpi.twopass.frames_to_key >= cast,no_check(s32) (cpi.twopass.total_stats.count - cpi.common.current_video_frame) {
        cpi.twopass.kf_group_bits = ifx cpi.twopass.bits_left > 0 then cpi.twopass.bits_left else 0;
    }

    if cpi.twopass.kf_group_bits > 0 && cpi.twopass.kf_group_error_left > 0 {
        cpi.twopass.gf_group_bits =
            cast,no_check(s64) (cpi.twopass.kf_group_bits *
                (gf_group_err / cpi.twopass.kf_group_error_left));
    } else {
        cpi.twopass.gf_group_bits = 0;
    }

    cpi.twopass.gf_group_bits =
        ifx cpi.twopass.gf_group_bits < 0 then 0 else (ifx cpi.twopass.gf_group_bits > cpi.twopass.kf_group_bits then cpi.twopass.kf_group_bits else cpi.twopass.gf_group_bits);

    if cpi.twopass.gf_group_bits > (cast,no_check(s64) max_bits) * cast(s64) cpi.baseline_gf_interval {
        cpi.twopass.gf_group_bits = (cast,no_check(s64) max_bits) * cast(s64) cpi.baseline_gf_interval;
    }

    reset_fpf_position(cpi, start_pos);

    cpi.twopass.modified_error_used += gf_group_err;

    i = 0;
    while i <= cast(s32) (cpi.source_alt_ref_pending != 0 && cpi.common.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon) {
        boost: s32 = ---;
        allocation_chunks: s32 = ---;
        q := (ifx cpi.oxcf.fixed_q < 0 then cpi.last_q[INTER_FRAME_in_alloccommon] else cpi.oxcf.fixed_q);

        if cpi.source_alt_ref_pending != 0 && i == 0 {
            boost = alt_boost * VP8_GF_BOOST_QADJUSTMENT[q] / 100;

            boost += cpi.baseline_gf_interval * 50;

            if boost > (cpi.baseline_gf_interval + 1) * 200 {
                boost = (cpi.baseline_gf_interval + 1) * 200;
            } else if boost < 125 {
                boost = 125;
            }

            allocation_chunks = (cpi.baseline_gf_interval + 1) * 100 + boost;
        } else {
            boost = cpi.gfu_boost * VP8_GF_BOOST_QADJUSTMENT[q] / 100;

            if boost > cpi.baseline_gf_interval * 150 {
                boost = cpi.baseline_gf_interval * 150;
            } else if boost < 125 {
                boost = 125;
            }

            allocation_chunks = cpi.baseline_gf_interval * 100 + (boost - 100);
        }

        while boost > 1000 {
            boost /= 2;
            allocation_chunks /= 2;
        }

        gf_bits :=
            saturate_cast_double_to_int_in_firstpass(
                (cast,no_check(float64) boost) * (cpi.twopass.gf_group_bits / cast,no_check(float64) allocation_chunks)
            );

        if c_transpiler_float_less(mod_frame_err, (gf_group_err / cast,no_check(float64) cpi.baseline_gf_interval)) {
            alt_gf_grp_bits :=
                ((cast,no_check(float64) cpi.twopass.kf_group_bits) * (mod_frame_err * cast,no_check(float64) cpi.baseline_gf_interval)) /
                    (ifx c_transpiler_float_less(cast,no_check(float64) cpi.twopass.kf_group_error_left, 0.0) then (cast,no_check(float64) cpi.twopass.kf_group_error_left) - 0.000001 else (cast,no_check(float64) cpi.twopass.kf_group_error_left) + 0.000001);

            alt_gf_bits :=
                cast,no_check(s32) ((cast,no_check(float64) boost) *
                    (alt_gf_grp_bits / cast,no_check(float64) allocation_chunks));

            if gf_bits > alt_gf_bits {
                gf_bits = alt_gf_bits;
            }
        } else {
            alt_gf_bits :=
                saturate_cast_double_to_int_in_firstpass(
                    (cast,no_check(float64) cpi.twopass.kf_group_bits) * mod_frame_err /
                    cast,no_check(float64) ((ifx cpi.twopass.kf_group_error_left > 1 then cpi.twopass.kf_group_error_left else 1))
                );

            if alt_gf_bits > gf_bits {
                gf_bits = alt_gf_bits;
            }
        }

        if cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER {
            if cpi.twopass.gf_bits > cast,no_check(s32) (cpi.buffer_level >> 1) {
                cpi.twopass.gf_bits = cast,no_check(s32) (cpi.buffer_level >> 1);
            }
        }

        if gf_bits < 0 {
            gf_bits = 0;
        }

        gf_bits += cpi.min_frame_bandwidth;

        if i == 0 {
            cpi.twopass.gf_bits = gf_bits;
        }
        if i == 1 || cpi.source_alt_ref_pending == 0 && cpi.common.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
            cpi.per_frame_bandwidth = gf_bits;
        }
        i += 1;
    }

    cpi.twopass.kf_group_error_left -= cast,no_check(s64) gf_group_err;
    cpi.twopass.kf_group_bits -= cpi.twopass.gf_group_bits;

    if cpi.twopass.kf_group_bits < 0 {
        cpi.twopass.kf_group_bits = 0;
    }

    if cpi.source_alt_ref_pending == 0 && cpi.common.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
        cpi.twopass.gf_group_error_left = cast,no_check(s32) (gf_group_err - gf_first_frame_err);
    } else {
        cpi.twopass.gf_group_error_left = cast,no_check(s32) gf_group_err;
    }

    cpi.twopass.gf_group_bits -= cast,no_check(s64) (cpi.twopass.gf_bits - cpi.min_frame_bandwidth);

    if cpi.twopass.gf_group_bits < 0 {
        cpi.twopass.gf_group_bits = 0;
    }

    if cpi.baseline_gf_interval >= 3 {
        boost := (ifx cpi.source_alt_ref_pending != 0 then b_boost else cpi.gfu_boost);

        if boost >= 150 {
            pct_extra := (boost - 100) / 50;
            pct_extra = ifx pct_extra > 20 then 20 else pct_extra;

            cpi.twopass.alt_extra_bits = (cast,no_check(s32) (cpi.twopass.gf_group_bits * cast(s64) pct_extra)) / 100;
            cpi.twopass.gf_group_bits -= cast,no_check(s64) cpi.twopass.alt_extra_bits;
            cpi.twopass.alt_extra_bits /= (cpi.baseline_gf_interval - 1) >> 1;
        } else {
            cpi.twopass.alt_extra_bits = 0;
        }
    } else {
        cpi.twopass.alt_extra_bits = 0;
    }

    if cpi.common.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
        sectionstats: FIRSTPASS_STATS = ---;

        zero_stats(*sectionstats);
        reset_fpf_position(cpi, start_pos);

        i = 0;
        while i < cpi.baseline_gf_interval {
            input_stats(cpi, *next_frame);
            accumulate_stats(*sectionstats, *next_frame);
            i += 1;
        }

        avg_stats(*sectionstats);

        cpi.twopass.section_intra_rating =
            cast,no_check(u32) (sectionstats.intra_error /
                (ifx c_transpiler_float_less(sectionstats.coded_error, 0.0) then sectionstats.coded_error - 0.000001 else sectionstats.coded_error + 0.000001));

        ratio :=
            sectionstats.intra_error /
                (ifx c_transpiler_float_less(sectionstats.coded_error, 0.0) then sectionstats.coded_error - 0.000001 else sectionstats.coded_error + 0.000001);
        cpi.twopass.section_max_qfactor = 1.0 - (ratio - 10.0) * 0.025;

        if c_transpiler_float_less(cpi.twopass.section_max_qfactor, 0.8) {
            cpi.twopass.section_max_qfactor = 0.8;
        }

        reset_fpf_position(cpi, start_pos);
    }
}

avg_stats :: (section: *FIRSTPASS_STATS) {
    if c_transpiler_float_less(section.count, 1.0) {
        return;
    }

    section.intra_error /= section.count;
    section.coded_error /= section.count;
    section.ssim_weighted_pred_err /= section.count;
    section.pcnt_inter /= section.count;
    section.pcnt_second_ref /= section.count;
    section.pcnt_neutral /= section.count;
    section.pcnt_motion /= section.count;
    section.m_vr /= section.count;
    section.mvr_abs /= section.count;
    section.m_vc /= section.count;
    section.mvc_abs /= section.count;
    section.m_vrv /= section.count;
    section.m_vcv /= section.count;
    section.mv_in_out_count /= section.count;
    section.duration /= section.count;
}

estimate_q :: (cpi: *VP8_COMP, section_err: float64, section_target_bandwitdh: s32) -> s32 {
    num_mbs := cpi.common.m_bs;

    err_per_mb := section_err / num_mbs;

    speed_correction: float64 = 1.0;

    target_norm_bits_per_mb :=
        (ifx section_target_bandwitdh < (cast(s32) 1) << 20 then 512 *
            section_target_bandwitdh / num_mbs else 512 * (section_target_bandwitdh / num_mbs));

    if cpi.compressor_speed == 3 || cpi.compressor_speed == 1 {
        if cpi.oxcf.cpu_used <= 5 {
            speed_correction = 1.04 + (cast,no_check(float64) cpi.oxcf.cpu_used) * 0.04;
        } else {
            speed_correction = 1.25;
        }
    }

    q: s32 = 0;
    while q < 127 {
        err_correction_factor := calc_correction_factor(err_per_mb, 150.0, 0.4, 0.9, q);

        bits_per_mb_at_this_q :=
            cast,no_check(s32) (0.5 +
                (err_correction_factor * speed_correction * cpi.twopass.est_max_qcorrection_factor * cast,no_check(float64) VP8_BITS_PER_MB[INTER_FRAME_in_alloccommon][q]) / 1.0);

        if bits_per_mb_at_this_q <= target_norm_bits_per_mb {
            break;
        }
        q += 1;
    }

    return q;
}

calc_arf_boost :: (cpi: *VP8_COMP, offset: s32, f_frames: s32, b_frames: s32, f_boost: *s32, b_boost: *s32) -> s32 {
    this_frame: FIRSTPASS_STATS = ---;

    boost_score: float64 = 0.0;
    mv_ratio_accumulator: float64 = 0.0;
    decay_accumulator: float64 = 1.0;
    this_frame_mv_in_out: float64 = 0.0;
    mv_in_out_accumulator: float64 = 0.0;
    abs_mv_in_out_accumulator: float64 = 0.0;
    r: float64 = ---;
    flash_detected: s32 = 0;

    i: s32 = 0;
    while i < f_frames {
        if read_frame_stats(cpi, *this_frame, i + offset) == -1 {
            break;
        }

        accumulate_frame_motion_stats(
            *this_frame,
            *this_frame_mv_in_out,
            *mv_in_out_accumulator,
            *abs_mv_in_out_accumulator,
            *mv_ratio_accumulator
        );

        r = calc_frame_boost(cpi, *this_frame, this_frame_mv_in_out);

        flash_detected = cast(s32) (detect_flash(cpi, i + offset) != 0 || detect_flash(cpi, i + offset + 1) != 0);

        if flash_detected == 0 {
            decay_accumulator = decay_accumulator * get_prediction_decay_rate(*this_frame);
            decay_accumulator = ifx c_transpiler_float_less(decay_accumulator, 0.1) then 0.1 else decay_accumulator;
        }
        boost_score += decay_accumulator * r;

        if flash_detected == 0 &&
            (c_transpiler_float_greater(mv_ratio_accumulator, 100.0) ||
                c_transpiler_float_greater(abs_mv_in_out_accumulator, 3.0) ||
                c_transpiler_float_less(mv_in_out_accumulator, -2.0)) {
            break;
        }
        i += 1;
    }

    f_boost.* = (cast,no_check(s32) (boost_score * 100.0)) >> 4;

    boost_score = 0.0;
    mv_ratio_accumulator = 0.0;
    decay_accumulator = 1.0;
    this_frame_mv_in_out = 0.0;
    mv_in_out_accumulator = 0.0;
    abs_mv_in_out_accumulator = 0.0;

    i = -1;
    while i >= -b_frames {
        if read_frame_stats(cpi, *this_frame, i + offset) == -1 {
            break;
        }

        accumulate_frame_motion_stats(
            *this_frame,
            *this_frame_mv_in_out,
            *mv_in_out_accumulator,
            *abs_mv_in_out_accumulator,
            *mv_ratio_accumulator
        );

        r = calc_frame_boost(cpi, *this_frame, this_frame_mv_in_out);

        flash_detected = cast(s32) (detect_flash(cpi, i + offset) != 0 || detect_flash(cpi, i + offset + 1) != 0);

        if flash_detected == 0 {
            decay_accumulator = decay_accumulator * get_prediction_decay_rate(*this_frame);
            decay_accumulator = ifx c_transpiler_float_less(decay_accumulator, 0.1) then 0.1 else decay_accumulator;
        }

        boost_score += decay_accumulator * r;

        if flash_detected == 0 &&
            (c_transpiler_float_greater(mv_ratio_accumulator, 100.0) ||
                c_transpiler_float_greater(abs_mv_in_out_accumulator, 3.0) ||
                c_transpiler_float_less(mv_in_out_accumulator, -2.0)) {
            break;
        }
        i -= 1;
    }
    b_boost.* = (cast,no_check(s32) (boost_score * 100.0)) >> 4;

    return f_boost.* + b_boost.*;
}

get_prediction_decay_rate :: (next_frame: *FIRSTPASS_STATS) -> float64 {
    motion_pct := next_frame.pcnt_motion;

    prediction_decay_rate := next_frame.pcnt_inter;

    motion_decay := 1.0 - motion_pct / 20.0;
    if c_transpiler_float_less(motion_decay, prediction_decay_rate) {
        prediction_decay_rate = motion_decay;
    }

    {
        this_mv_rabs := c_transpiler_math_fabs(next_frame.mvr_abs * motion_pct);
        this_mv_cabs := c_transpiler_math_fabs(next_frame.mvc_abs * motion_pct);

        distance_factor := c_transpiler_libm_sqrt(this_mv_rabs * this_mv_rabs + this_mv_cabs * this_mv_cabs) / 250.0;
        distance_factor = ifx c_transpiler_float_greater(distance_factor, 1.0) then 0.0 else 1.0 - distance_factor;
        if c_transpiler_float_less(distance_factor, prediction_decay_rate) {
            prediction_decay_rate = distance_factor;
        }
    }

    return prediction_decay_rate;
}

detect_flash :: (cpi: *VP8_COMP, offset: s32) -> s32 {
    next_frame: FIRSTPASS_STATS = ---;

    flash_detected: s32 = 0;

    if read_frame_stats(cpi, *next_frame, offset) != -1 {
        if c_transpiler_float_greater(next_frame.pcnt_second_ref, next_frame.pcnt_inter) &&
            c_transpiler_float_greater_equal(next_frame.pcnt_second_ref, 0.5) {
            flash_detected = 1;
        }
    }

    return flash_detected;
}

read_frame_stats :: (cpi: *VP8_COMP, frame_stats: *FIRSTPASS_STATS, offset: s32) -> s32 {
    fps_ptr := cpi.twopass.stats_in;

    if offset >= 0 {
        if *fps_ptr[offset] >= cpi.twopass.stats_in_end {
            return -1;
        }
    } else if offset < 0 {
        if *fps_ptr[offset] < cpi.twopass.stats_in_start {
            return -1;
        }
    }

    frame_stats.* = fps_ptr[offset];
    return 1;
}

calc_frame_boost :: (cpi: *VP8_COMP, this_frame: *FIRSTPASS_STATS, this_frame_mv_in_out: float64) -> float64 {
    frame_boost: float64 = ifx c_transpiler_float_greater(this_frame.intra_error, cpi.twopass.gf_intra_err_min)
        then 1.5 * this_frame.intra_error / (ifx c_transpiler_float_less(this_frame.coded_error, 0.0) then this_frame.coded_error - 0.000001 else this_frame.coded_error + 0.000001)
        else 1.5 * cpi.twopass.gf_intra_err_min / (ifx c_transpiler_float_less(this_frame.coded_error, 0.0) then this_frame.coded_error - 0.000001 else this_frame.coded_error + 0.000001);

    if c_transpiler_float_greater(this_frame_mv_in_out, 0.0) {
        frame_boost += frame_boost * (this_frame_mv_in_out * 2.0);
    } else {
        frame_boost += frame_boost * (this_frame_mv_in_out / 2.0);
    }

    if c_transpiler_float_greater(frame_boost, 48.0) {
        frame_boost = 48.0;
    }

    return frame_boost;
}

accumulate_frame_motion_stats :: (
    this_frame: *FIRSTPASS_STATS,
    this_frame_mv_in_out: *float64,
    mv_in_out_accumulator: *float64,
    abs_mv_in_out_accumulator: *float64,
    mv_ratio_accumulator: *float64
) {
    this_frame_mvr_ratio: float64 = ---;
    this_frame_mvc_ratio: float64 = ---;
    motion_pct := this_frame.pcnt_motion;

    this_frame_mv_in_out.* = this_frame.mv_in_out_count * motion_pct;
    mv_in_out_accumulator.* += this_frame.mv_in_out_count * motion_pct;
    abs_mv_in_out_accumulator.* += c_transpiler_math_fabs(this_frame.mv_in_out_count * motion_pct);

    if c_transpiler_float_greater(motion_pct, 0.05) {
        this_frame_mvr_ratio =
            c_transpiler_math_fabs(this_frame.mvr_abs) /
                (ifx c_transpiler_float_less(c_transpiler_math_fabs(this_frame.m_vr), 0.0) then c_transpiler_math_fabs(this_frame.m_vr) - 0.000001 else c_transpiler_math_fabs(this_frame.m_vr) + 0.000001);

        this_frame_mvc_ratio =
            c_transpiler_math_fabs(this_frame.mvc_abs) /
                (ifx c_transpiler_float_less(c_transpiler_math_fabs(this_frame.m_vc), 0.0) then c_transpiler_math_fabs(this_frame.m_vc) - 0.000001 else c_transpiler_math_fabs(this_frame.m_vc) + 0.000001);

        mv_ratio_accumulator.* +=
            (ifx c_transpiler_float_less(this_frame_mvr_ratio, this_frame.mvr_abs) then this_frame_mvr_ratio *
                motion_pct else this_frame.mvr_abs * motion_pct);

        mv_ratio_accumulator.* +=
            (ifx c_transpiler_float_less(this_frame_mvc_ratio, this_frame.mvc_abs) then this_frame_mvc_ratio *
                motion_pct else this_frame.mvc_abs * motion_pct);
    }
}

detect_transition_to_still :: (
    cpi: *VP8_COMP,
    frame_interval: s32,
    still_interval: s32,
    loop_decay_rate: float64,
    decay_accumulator: float64
) -> s32 {
    trans_to_still: s32 = 0;

    if frame_interval > 4 &&
        c_transpiler_float_greater_equal(loop_decay_rate, 0.999) &&
        c_transpiler_float_less(decay_accumulator, 0.9) {
        position := cpi.twopass.stats_in;
        tmp_next_frame: FIRSTPASS_STATS = ---;

        j: s32 = 0;
        while j < still_interval {
            if -1 == input_stats(cpi, *tmp_next_frame) {
                break;
            }

            decay_rate := get_prediction_decay_rate(*tmp_next_frame);
            if c_transpiler_float_less(decay_rate, 0.999) {
                break;
            }
            j += 1;
        }

        reset_fpf_position(cpi, position);

        if j == still_interval {
            trans_to_still = 1;
        }
    }

    return trans_to_still;
}

find_next_key_frame :: (cpi: *VP8_COMP, this_frame: *FIRSTPASS_STATS) {
    last_frame: FIRSTPASS_STATS = ---;
    first_frame: FIRSTPASS_STATS = ---;
    next_frame: FIRSTPASS_STATS = ---;

    decay_accumulator: float64 = 1.0;
    boost_score: float64 = 0.0;
    old_boost_score: float64 = 0.0;
    loop_decay_rate: float64 = ---;

    kf_mod_err: float64 = 0.0;
    kf_group_err: float64 = 0.0;
    kf_group_intra_err: float64 = 0.0;
    kf_group_coded_err: float64 = 0.0;
    recent_loop_decay :=
        float64.[
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0
        ];

    fill_memory(*next_frame, 0, size_of(FIRSTPASS_STATS));

    start_position := cpi.twopass.stats_in;

    cpi.common.frame_type = cast,no_check(FRAME_TYPE_in_alloccommon) KEY_FRAME_in_alloccommon;

    cpi.this_key_frame_forced = cpi.next_key_frame_forced;

    cpi.source_alt_ref_active = 0;

    cpi.frames_till_gf_update_due = 0;

    cpi.twopass.frames_to_key = 1;

    first_frame = this_frame.*;

    cpi.twopass.kf_group_bits = 0;
    cpi.twopass.kf_group_error_left = 0;

    kf_mod_err = calculate_modified_err(cpi, this_frame);

    i: s32 = 0;
    while cpi.twopass.stats_in < cpi.twopass.stats_in_end {
        kf_group_err += calculate_modified_err(cpi, this_frame);

        kf_group_intra_err += this_frame.intra_error;
        kf_group_coded_err += this_frame.coded_error;

        last_frame = this_frame.*;
        input_stats(cpi, this_frame);

        if cpi.oxcf.auto_key != 0 && lookup_next_frame_stats(cpi, *next_frame) != -1 {
            if i >= 4 && test_candidate_kf(cpi, *last_frame, this_frame, *next_frame) != 0 {
                break;
            }

            loop_decay_rate = get_prediction_decay_rate(*next_frame);

            recent_loop_decay[i % 8] = loop_decay_rate;
            decay_accumulator = 1.0;
            for j: 0..cast(s32) 8 - 1 {
                decay_accumulator = decay_accumulator * recent_loop_decay[j];
            }

            if detect_transition_to_still(
                cpi,
                i,
                (cast,no_check(s32) cpi.key_frame_frequency) - i,
                loop_decay_rate,
                decay_accumulator
            ) != 0 {
                break;
            }

            cpi.twopass.frames_to_key += 1;

            if cpi.twopass.frames_to_key >= 2 * cast,no_check(s32) cpi.key_frame_frequency {
                break;
            }
        } else {
            cpi.twopass.frames_to_key += 1;
        }

        i += 1;
    }

    if cpi.oxcf.auto_key != 0 && cpi.twopass.frames_to_key > cast,no_check(s32) cpi.key_frame_frequency {
        current_pos := cpi.twopass.stats_in;
        tmp_frame: FIRSTPASS_STATS = ---;

        cpi.twopass.frames_to_key /= 2;

        tmp_frame = first_frame;

        reset_fpf_position(cpi, start_position);

        kf_group_err = 0.0;
        kf_group_intra_err = 0.0;
        kf_group_coded_err = 0.0;

        i = 0;
        while i < cpi.twopass.frames_to_key {
            kf_group_err += calculate_modified_err(cpi, *tmp_frame);
            kf_group_intra_err += tmp_frame.intra_error;
            kf_group_coded_err += tmp_frame.coded_error;

            input_stats(cpi, *tmp_frame);
            i += 1;
        }

        reset_fpf_position(cpi, current_pos);

        cpi.next_key_frame_forced = 1;
    } else {
        cpi.next_key_frame_forced = 0;
    }

    if cpi.twopass.stats_in >= cpi.twopass.stats_in_end {
        kf_group_err += calculate_modified_err(cpi, this_frame);

        kf_group_intra_err += this_frame.intra_error;
        kf_group_coded_err += this_frame.coded_error;
    }

    if cpi.twopass.bits_left > 0 && c_transpiler_float_greater(cpi.twopass.modified_error_left, 0.0) {
        max_bits := frame_max_bits(cpi);

        cpi.twopass.kf_group_bits =
            cast,no_check(s64) (cpi.twopass.bits_left *
                (kf_group_err / cpi.twopass.modified_error_left));

        max_grp_bits := (cast,no_check(s64) max_bits) * cast,no_check(s64) cpi.twopass.frames_to_key;
        if cpi.twopass.kf_group_bits > max_grp_bits {
            cpi.twopass.kf_group_bits = max_grp_bits;
        }

        if cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER {
            opt_buffer_lvl := cpi.oxcf.optimal_buffer_level;
            buffer_lvl := cpi.buffer_level;

            if buffer_lvl >= opt_buffer_lvl {
                high_water_mark := (opt_buffer_lvl + cpi.oxcf.maximum_buffer_size) >> 1;

                av_group_bits :=
                    (cast,no_check(s64) cpi.av_per_frame_bandwidth) *
                        cast,no_check(s64) cpi.twopass.frames_to_key;

                if cpi.buffer_level >= high_water_mark {
                    min_group_bits := av_group_bits + (buffer_lvl - high_water_mark);

                    if cpi.twopass.kf_group_bits < min_group_bits {
                        cpi.twopass.kf_group_bits = min_group_bits;
                    }
                } else if cpi.twopass.kf_group_bits < av_group_bits {
                    bits_below_av := av_group_bits - cpi.twopass.kf_group_bits;

                    cpi.twopass.kf_group_bits +=
                        cast,no_check(s64) (((cast,no_check(float64) bits_below_av) * cast,no_check(float64) (buffer_lvl - opt_buffer_lvl)) /
                            cast,no_check(float64) (high_water_mark - opt_buffer_lvl));
                }
            }
        }
    } else {
        cpi.twopass.kf_group_bits = 0;
    }

    reset_fpf_position(cpi, start_position);

    decay_accumulator = 1.0;
    boost_score = 0.0;

    i = 0;
    while i < cpi.twopass.frames_to_key {
        if -1 == input_stats(cpi, *next_frame) {
            break;
        }

        r: float64 = ifx c_transpiler_float_greater(next_frame.intra_error, cpi.twopass.kf_intra_err_min)
            then 1.5 * next_frame.intra_error / (ifx c_transpiler_float_less(next_frame.coded_error, 0.0) then next_frame.coded_error - 0.000001 else next_frame.coded_error + 0.000001)
            else 1.5 * cpi.twopass.kf_intra_err_min / (ifx c_transpiler_float_less(next_frame.coded_error, 0.0) then next_frame.coded_error - 0.000001 else next_frame.coded_error + 0.000001);

        if c_transpiler_float_greater(r, 14.0) {
            r = 14.0;
        }

        loop_decay_rate = get_prediction_decay_rate(*next_frame);

        decay_accumulator = decay_accumulator * loop_decay_rate;
        decay_accumulator = ifx c_transpiler_float_less(decay_accumulator, 0.1) then 0.1 else decay_accumulator;

        boost_score += decay_accumulator * r;

        if i > 4 && c_transpiler_float_less((boost_score - old_boost_score), 1.0) {
            break;
        }

        old_boost_score = boost_score;
        i += 1;
    }

    {
        sectionstats: FIRSTPASS_STATS = ---;

        zero_stats(*sectionstats);
        reset_fpf_position(cpi, start_position);

        i = 0;
        while i < cpi.twopass.frames_to_key {
            input_stats(cpi, *next_frame);
            accumulate_stats(*sectionstats, *next_frame);
            i += 1;
        }

        avg_stats(*sectionstats);

        cpi.twopass.section_intra_rating =
            cast,no_check(u32) (sectionstats.intra_error /
                (ifx c_transpiler_float_less(sectionstats.coded_error, 0.0) then sectionstats.coded_error - 0.000001 else sectionstats.coded_error + 0.000001));

        ratio :=
            sectionstats.intra_error /
                (ifx c_transpiler_float_less(sectionstats.coded_error, 0.0) then sectionstats.coded_error - 0.000001 else sectionstats.coded_error + 0.000001);
        cpi.twopass.section_max_qfactor = 1.0 - (ratio - 10.0) * 0.025;

        if c_transpiler_float_less(cpi.twopass.section_max_qfactor, 0.8) {
            cpi.twopass.section_max_qfactor = 0.8;
        }
    }

    if cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER {
        max_boost: float64 = ---;

        if cpi.drop_frames_allowed != 0 {
            df_buffer_level :=
                cast,no_check(s32) ((cast(s64) cpi.oxcf.drop_frames_water_mark) *
                    (cpi.oxcf.optimal_buffer_level / 100));

            if cpi.buffer_level > cast,no_check(s64) df_buffer_level {
                max_boost =
                    ((cast,no_check(float64) (((cpi.buffer_level - cast(s64) df_buffer_level) * 2) / 3)) * 16.0) /
                        (ifx c_transpiler_float_less(cast,no_check(float64) cpi.av_per_frame_bandwidth, 0.0) then (cast,no_check(float64) cpi.av_per_frame_bandwidth) - 0.000001 else (cast,no_check(float64) cpi.av_per_frame_bandwidth) + 0.000001);
            } else {
                max_boost = 0.0;
            }
        } else if cpi.buffer_level > 0 {
            max_boost =
                (cast,no_check(float64) ((cpi.buffer_level * 2) / 3)) * 16.0 /
                    (ifx c_transpiler_float_less(cast,no_check(float64) cpi.av_per_frame_bandwidth, 0.0) then (cast,no_check(float64) cpi.av_per_frame_bandwidth) - 0.000001 else (cast,no_check(float64) cpi.av_per_frame_bandwidth) + 0.000001);
        } else {
            max_boost = 0.0;
        }

        if c_transpiler_float_greater(boost_score, max_boost) {
            boost_score = max_boost;
        }
    }

    reset_fpf_position(cpi, start_position);

    {
        kf_boost := cast,no_check(s32) boost_score;

        counter := cpi.twopass.frames_to_key;
        alt_kf_bits: s32 = ---;
        lst_yv12 := cpi.common.yv12_fb.data + cpi.common.lst_fb_idx;

        if kf_boost < 48 {
            kf_boost += (counter + 1) >> 1;

            if kf_boost > 48 {
                kf_boost = 48;
            }
        }

        if lst_yv12.y_width * lst_yv12.y_height > 320 * 240 {
            kf_boost += 2 * (lst_yv12.y_width * lst_yv12.y_height) / cast,no_check(s32) ((320 * 240));
        } else if lst_yv12.y_width * lst_yv12.y_height < 320 * 240 {
            kf_boost -= (4 * cast,no_check(s32) ((320 * 240))) / (lst_yv12.y_width * lst_yv12.y_height);
        }

        kf_boost = (cast,no_check(s32) ((cast,no_check(float64) kf_boost) * 100.0)) >> 4;
        if kf_boost < 250 {
            kf_boost = 250;
        }

        allocation_chunks: s32 = ifx c_transpiler_float_greater_equal(decay_accumulator, 0.99)
            then (cpi.twopass.frames_to_key - 1) * 10 + kf_boost
            else (cpi.twopass.frames_to_key - 1) * 100 + kf_boost;

        while kf_boost > 1000 {
            kf_boost /= 2;
            allocation_chunks /= 2;
        }

        cpi.twopass.kf_group_bits = ifx cpi.twopass.kf_group_bits < 0 then 0 else cpi.twopass.kf_group_bits;

        cpi.twopass.kf_bits =
            cast,no_check(s32) ((cast,no_check(float64) kf_boost) *
                ((cast,no_check(float64) cpi.twopass.kf_group_bits) / cast,no_check(float64) allocation_chunks));

        if cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER {
            if cpi.twopass.kf_bits > cast,no_check(s32) ((3 * cpi.buffer_level) >> 2) {
                cpi.twopass.kf_bits = cast,no_check(s32) ((3 * cpi.buffer_level) >> 2);
            }
        }

        if c_transpiler_float_less(kf_mod_err, (kf_group_err / cpi.twopass.frames_to_key)) {
            alt_kf_grp_bits :=
                ((cast,no_check(float64) cpi.twopass.bits_left) * (kf_mod_err * cast,no_check(float64) cpi.twopass.frames_to_key)) /
                    (ifx c_transpiler_float_less(cpi.twopass.modified_error_left, 0.0) then cpi.twopass.modified_error_left - 0.000001 else cpi.twopass.modified_error_left + 0.000001);

            alt_kf_bits =
                cast,no_check(s32) ((cast,no_check(float64) kf_boost) *
                    (alt_kf_grp_bits / cast,no_check(float64) allocation_chunks));

            if cpi.twopass.kf_bits > alt_kf_bits {
                cpi.twopass.kf_bits = alt_kf_bits;
            }
        } else {
            alt_kf_bits =
                cast,no_check(s32) ((cast,no_check(float64) cpi.twopass.bits_left) *
                    (kf_mod_err / (ifx c_transpiler_float_less(cpi.twopass.modified_error_left, 0.0) then cpi.twopass.modified_error_left - 0.000001 else cpi.twopass.modified_error_left + 0.000001)));

            if alt_kf_bits > cpi.twopass.kf_bits {
                cpi.twopass.kf_bits = alt_kf_bits;
            }
        }

        cpi.twopass.kf_group_bits -= cast,no_check(s64) cpi.twopass.kf_bits;

        cpi.twopass.kf_bits += cpi.min_frame_bandwidth;

        cpi.per_frame_bandwidth = cpi.twopass.kf_bits;

        cpi.target_bandwidth = cast,no_check(s32) (cpi.twopass.kf_bits * cpi.output_framerate);
    }

    cpi.twopass.kf_group_error_left = cast,no_check(s64) (cast,no_check(s32) (kf_group_err - kf_mod_err));

    cpi.twopass.modified_error_left -= kf_group_err;

    if cpi.oxcf.allow_spatial_resampling != 0 {
        resample_trigger: s32 = 0;
        last_kf_resampled: s32 = 0;

        scale_val: s32 = 0;
        hr, hs, vr, vs: s32 = ---;
        new_width := cpi.oxcf.width;
        new_height := cpi.oxcf.height;

        group_iiratio :=
            (kf_group_intra_err - first_frame.intra_error) /
                (kf_group_coded_err - first_frame.coded_error);
        err_per_frame := kf_group_err / cpi.twopass.frames_to_key;
        bits_per_frame: float64 = ---;

        effective_size_ratio: float64 = ---;

        if cpi.common.width != cpi.oxcf.width || cpi.common.height != cpi.oxcf.height {
            last_kf_resampled = 1;
        }

        cpi.common.horiz_scale = cast,no_check(s32) (VP8E_NORMAL);
        cpi.common.vert_scale = cast,no_check(s32) (VP8E_NORMAL);

        av_bits_per_frame :=
            cpi.oxcf.target_bandwidth /
                (ifx c_transpiler_float_less(cpi.framerate, 0.0) then cpi.framerate - 0.000001 else cpi.framerate + 0.000001);

        if cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER {
            bits_per_frame = av_bits_per_frame;
        } else {
            bits_per_frame = cast,no_check(float64) (cpi.twopass.kf_group_bits / cast(s64) cpi.twopass.frames_to_key);

            if c_transpiler_float_less(bits_per_frame, av_bits_per_frame) {
                bits_per_frame = av_bits_per_frame;
            }
        }

        if c_transpiler_float_less(bits_per_frame, cast,no_check(float64) ((cpi.oxcf.target_bandwidth * cast,no_check(u32) cpi.oxcf.two_pass_vbrmin_section) / 100)) {
            bits_per_frame =
                cast,no_check(float64) ((cpi.oxcf.target_bandwidth * cast,no_check(u32) cpi.oxcf.two_pass_vbrmin_section) /
                    100);
        }

        kf_q := estimate_kf_group_q(cpi, err_per_frame, cast,no_check(s32) bits_per_frame, group_iiratio);

        projected_bits_perframe := bits_per_frame;
        tmp_q := kf_q;

        while tmp_q > cpi.worst_quality {
            projected_bits_perframe *= 1.04;
            tmp_q -= 1;
        }

        projected_buffer_level :=
            cast,no_check(s32) (cpi.buffer_level -
                cast(s64) (cast,no_check(s32) ((projected_bits_perframe - av_bits_per_frame) * cpi.twopass.frames_to_key)));

        if cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER {
            if cast,no_check(s64) projected_buffer_level < (cast(s64) cpi.oxcf.resample_down_water_mark) * cpi.oxcf.optimal_buffer_level / 100 ||
                last_kf_resampled != 0 &&
                    cast,no_check(s64) projected_buffer_level < (cast(s64) cpi.oxcf.resample_up_water_mark) * cpi.oxcf.optimal_buffer_level / 100 {
                resample_trigger = 1;
            } else {
                resample_trigger = 0;
            }
        } else {
            clip_bits :=
                cast,no_check(s64) (cpi.twopass.total_stats.count * cpi.oxcf.target_bandwidth /
                    (ifx c_transpiler_float_less(cpi.framerate, 0.0) then cpi.framerate - 0.000001 else cpi.framerate + 0.000001));
            over_spend := cpi.oxcf.starting_buffer_level - cpi.buffer_level;

            if last_kf_resampled != 0 && kf_q > cpi.worst_quality || kf_q > cpi.worst_quality && over_spend > clip_bits / 20 {
                resample_trigger = 1;
            } else {
                resample_trigger = 0;
            }
        }

        if resample_trigger != 0 {
            while kf_q >= cpi.worst_quality && scale_val < 6 {
                scale_val += 1;

                cpi.common.vert_scale = vscale_lookup[scale_val];
                cpi.common.horiz_scale = hscale_lookup[scale_val];

                scale2_ratio_in_firstpass(cpi.common.horiz_scale, *hr, *hs);
                scale2_ratio_in_firstpass(cpi.common.vert_scale, *vr, *vs);

                new_width = (hs - 1 + cpi.oxcf.width * hr) / hs;
                new_height = (vs - 1 + cpi.oxcf.height * vr) / vs;

                effective_size_ratio =
                    (cast,no_check(float64) (new_width * new_height)) /
                        cast,no_check(float64) (cpi.oxcf.width * cpi.oxcf.height);
                effective_size_ratio = (1.0 + 3.0 * effective_size_ratio) / 4.0;

                kf_q =
                    estimate_kf_group_q(
                        cpi,
                        err_per_frame * effective_size_ratio,
                        cast,no_check(s32) bits_per_frame,
                        group_iiratio
                    );
            }
        }

        if cpi.common.width != new_width || cpi.common.height != new_height {
            cpi.common.width = new_width;
            cpi.common.height = new_height;
            vp8_alloc_compressor_data(cpi);
        }
    }
}

estimate_kf_group_q :: (
    cpi: *VP8_COMP,
    section_err: float64,
    section_target_bandwitdh: s32,
    group_iiratio: float64
) -> s32 {
    num_mbs := cpi.common.m_bs;
    target_norm_bits_per_mb := 512 * section_target_bandwitdh / num_mbs;
    bits_per_mb_at_this_q: s32 = ---;

    err_per_mb := section_err / num_mbs;

    speed_correction: float64 = 1.0;
    current_spend_ratio: float64 = 1.0;

    pow_highq :=
        (ifx c_transpiler_float_less(((cast,no_check(float64) cpi.oxcf.two_pass_vbrbias) / 100.0), 0.6) then (cast,no_check(float64) cpi.oxcf.two_pass_vbrbias) / 100.0 +
            0.3 else 0.9);
    pow_lowq :=
        (ifx c_transpiler_float_less(((cast,no_check(float64) cpi.oxcf.two_pass_vbrbias) / 100.0), 0.7) then (cast,no_check(float64) cpi.oxcf.two_pass_vbrbias) / 100.0 +
            0.1 else 0.8);

    iiratio_correction_factor: float64 = 1.0;

    if target_norm_bits_per_mb <= 0 {
        return 127 * 2;
    }

    if cpi.long_rolling_target_bits <= 0 {
        current_spend_ratio = 10.0;
    } else {
        current_spend_ratio =
            (cast,no_check(float64) cpi.long_rolling_actual_bits) /
                cast,no_check(float64) cpi.long_rolling_target_bits;
        current_spend_ratio =
            ifx c_transpiler_float_greater(current_spend_ratio, 10.0) then 10.0 else (ifx c_transpiler_float_less(current_spend_ratio, 0.1) then 0.1 else current_spend_ratio);
    }

    iiratio_correction_factor = 1.0 - (group_iiratio - 6.0) * 0.1;

    if c_transpiler_float_less(iiratio_correction_factor, 0.5) {
        iiratio_correction_factor = 0.5;
    }

    if cpi.compressor_speed == 3 || cpi.compressor_speed == 1 {
        if cpi.oxcf.cpu_used <= 5 {
            speed_correction = 1.04 + (cast,no_check(float64) cpi.oxcf.cpu_used) * 0.04;
        } else {
            speed_correction = 1.25;
        }
    }

    combined_correction_factor := speed_correction * iiratio_correction_factor * current_spend_ratio;

    q: s32 = 0;
    while q < 127 {
        err_correction_factor := calc_correction_factor(err_per_mb, 150.0, pow_lowq, pow_highq, q);

        bits_per_mb_at_this_q =
            cast,no_check(s32) (0.5 +
                err_correction_factor * combined_correction_factor * cast,no_check(float64) VP8_BITS_PER_MB[INTER_FRAME_in_alloccommon][q]);

        if bits_per_mb_at_this_q <= target_norm_bits_per_mb {
            break;
        }
        q += 1;
    }

    while bits_per_mb_at_this_q > target_norm_bits_per_mb && q < 127 * 2 {
        bits_per_mb_at_this_q = cast,no_check(s32) (0.96 * cast,no_check(float64) bits_per_mb_at_this_q);
        q += 1;
    }

    return q;
}

test_candidate_kf :: (
    cpi: *VP8_COMP,
    last_frame: *FIRSTPASS_STATS,
    this_frame: *FIRSTPASS_STATS,
    next_frame: *FIRSTPASS_STATS
) -> s32 {
    is_viable_kf: s32 = 0;

    if c_transpiler_float_less(this_frame.pcnt_second_ref, 0.1) &&
        c_transpiler_float_less(next_frame.pcnt_second_ref, 0.1) &&
        (c_transpiler_float_less(this_frame.pcnt_inter, 0.05) ||
            c_transpiler_float_less((this_frame.pcnt_inter - this_frame.pcnt_neutral), 0.25) &&
                c_transpiler_float_less((this_frame.intra_error / (ifx c_transpiler_float_less(this_frame.coded_error, 0.0) then this_frame.coded_error - 0.000001 else this_frame.coded_error + 0.000001)), 2.5) &&
                (c_transpiler_float_greater((c_transpiler_math_fabs(last_frame.coded_error - this_frame.coded_error) / (ifx c_transpiler_float_less(this_frame.coded_error, 0.0) then this_frame.coded_error - 0.000001 else this_frame.coded_error + 0.000001)), 0.4) ||
                    c_transpiler_float_greater((c_transpiler_math_fabs(last_frame.intra_error - this_frame.intra_error) / (ifx c_transpiler_float_less(this_frame.intra_error, 0.0) then this_frame.intra_error - 0.000001 else this_frame.intra_error + 0.000001)), 0.4) ||
                    c_transpiler_float_greater((next_frame.intra_error / (ifx c_transpiler_float_less(next_frame.coded_error, 0.0) then next_frame.coded_error - 0.000001 else next_frame.coded_error + 0.000001)), 3.5))) {
        local_next_frame: FIRSTPASS_STATS = ---;

        boost_score: float64 = 0.0;
        old_boost_score: float64 = 0.0;
        decay_accumulator: float64 = 1.0;

        local_next_frame = next_frame.*;

        start_pos := cpi.twopass.stats_in;

        i: s32 = 0;
        while i < 16 {
            next_iiratio :=
                1.4 * local_next_frame.intra_error /
                    (ifx c_transpiler_float_less(local_next_frame.coded_error, 0.0) then local_next_frame.coded_error - 0.000001 else local_next_frame.coded_error + 0.000001);

            if c_transpiler_float_greater(next_iiratio, 14.0) {
                next_iiratio = 14.0;
            }

            if c_transpiler_float_greater(local_next_frame.pcnt_inter, 0.85) {
                decay_accumulator = decay_accumulator * local_next_frame.pcnt_inter;
            } else {
                decay_accumulator = decay_accumulator * ((0.85 + local_next_frame.pcnt_inter) / 2.0);
            }

            boost_score += decay_accumulator * next_iiratio;

            if c_transpiler_float_less(local_next_frame.pcnt_inter, 0.05) ||
                c_transpiler_float_less(next_iiratio, 1.5) ||
                c_transpiler_float_less((local_next_frame.pcnt_inter - local_next_frame.pcnt_neutral), 0.2) &&
                    c_transpiler_float_less(next_iiratio, 3.0) ||
                c_transpiler_float_less((boost_score - old_boost_score), 0.5) ||
                c_transpiler_float_less(local_next_frame.intra_error, 200.0) {
                break;
            }

            old_boost_score = boost_score;

            if -1 == input_stats(cpi, *local_next_frame) {
                break;
            }
            i += 1;
        }

        if c_transpiler_float_greater(boost_score, 5.0) && i > 3 {
            is_viable_kf = 1;
        } else {
            reset_fpf_position(cpi, start_pos);

            is_viable_kf = 0;
        }
    }

    return is_viable_kf;
}

vp8_end_second_pass :: (cpi: *VP8_COMP) {
}

insertsortmv_in_firstpass :: (arr: *s32, len: s32) {
    j: s32 = ---;
    k: s32 = ---;

    i: s32 = 1;
    while i <= len - 1 {
        j = 0;
        while j < i {
            if arr[j] > arr[i] {
                temp := arr[i];

                k = i;
                while k > j {
                    arr[k] = arr[k - 1];
                    k -= 1;
                }

                arr[j] = temp;
            }
            j += 1;
        }
        i += 1;
    }
}

insertsortsad_in_firstpass :: (arr: *s32, idx: *s32, len: s32) {
    j: s32 = ---;
    k: s32 = ---;

    i: s32 = 1;
    while i <= len - 1 {
        j = 0;
        while j < i {
            if arr[j] > arr[i] {
                temp: s32 = ---;

                temp = arr[i];
                tempi := idx[i];

                k = i;
                while k > j {
                    arr[k] = arr[k - 1];
                    idx[k] = idx[k - 1];
                    k -= 1;
                }

                arr[j] = temp;
                idx[j] = tempi;
            }
            j += 1;
        }
        i += 1;
    }
}

get_plane_pointers_in_firstpass :: (fb: *YV12_BUFFER_CONFIG, plane: **u8, recon_yoffset: u32, recon_uvoffset: u32) {
    plane[0] = fb.y_buffer + recon_yoffset;
    plane[1] = fb.u_buffer + recon_uvoffset;
    plane[2] = fb.v_buffer + recon_uvoffset;
}

get_predictor_pointers_in_firstpass :: (cpi: *VP8_COMP, plane: *[3] *u8, recon_yoffset: u32, recon_uvoffset: u32) {
    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_LAST_FRAME) != 0 {
        get_plane_pointers_in_firstpass(
            cpi.common.yv12_fb.data + cpi.common.lst_fb_idx,
            plane[LAST_FRAME].data,
            recon_yoffset,
            recon_uvoffset
        );
    }

    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_GOLD_FRAME) != 0 {
        get_plane_pointers_in_firstpass(
            cpi.common.yv12_fb.data + cpi.common.gld_fb_idx,
            plane[GOLDEN_FRAME].data,
            recon_yoffset,
            recon_uvoffset
        );
    }

    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_ALTR_FRAME) != 0 {
        get_plane_pointers_in_firstpass(
            cpi.common.yv12_fb.data + cpi.common.alt_fb_idx,
            plane[ALTREF_FRAME].data,
            recon_yoffset,
            recon_uvoffset
        );
    }
}

get_reference_search_order_in_firstpass :: (cpi: *VP8_COMP, ref_frame_map: *s32) {
    i: s32 = 0;

    ref_frame_map[i] = cast,no_check(s32) (INTRA_FRAME);
    i += 1;
    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_LAST_FRAME) != 0 {
        ref_frame_map[i] = cast,no_check(s32) (LAST_FRAME);
        i += 1;
    }
    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_GOLD_FRAME) != 0 {
        ref_frame_map[i] = cast,no_check(s32) (GOLDEN_FRAME);
        i += 1;
    }
    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_ALTR_FRAME) != 0 {
        ref_frame_map[i] = cast,no_check(s32) (ALTREF_FRAME);
        i += 1;
    }
    while i < 4 {
        ref_frame_map[i] = -1;
        i += 1;
    }
}

globals_initialization_state_for_firstpass: u32;
initialize_globals_for_firstpass :: () {
    {
        state := atomic_load(*globals_initialization_state_for_firstpass);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_firstpass, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_firstpass) != 2 {}
            return;
        }
    }
    vscale_lookup =
        s32.[
            0,
            1,
            1,
            2,
            2,
            3,
            3
        ];
    hscale_lookup =
        s32.[
            0,
            0,
            1,
            1,
            2,
            2,
            3
        ];
    CQ_LEVEL =
        s32.[
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
    WEIGHT_TABLE =
        float64.[
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.02,
            0.03125,
            0.0625,
            0.09375,
            0.125,
            0.15625,
            0.1875,
            0.21875,
            0.25,
            0.28125,
            0.3125,
            0.34375,
            0.375,
            0.40625,
            0.4375,
            0.46875,
            0.5,
            0.53125,
            0.5625,
            0.59375,
            0.625,
            0.65625,
            0.6875,
            0.71875,
            0.75,
            0.78125,
            0.8125,
            0.84375,
            0.875,
            0.90625,
            0.9375,
            0.96875,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0,
            1.0
        ];
    atomic_store(*globals_initialization_state_for_firstpass, 2);
}

BLOCK_Values :: u32;
BLOCK_16X8 : s32 : 0;
BLOCK_8X16 : s32 : 1;
BLOCK_8X8 : s32 : 2;
BLOCK_4X4 : s32 : 3;
BLOCK_16X16 : s32 : 4;
BLOCK_MAX_SEGMENTS : s32 : 5;

