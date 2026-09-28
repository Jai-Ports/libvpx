// Generated directly from C by cpp_transpiler.
clip_pixel_in_picklpf :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_picklpf :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_picklpf :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_picklpf :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_picklpf :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_picklpf(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_picklpf(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_picklpf(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_picklpf :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_picklpf :: (FILTER: *s16) -> s32 {
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

vp8_set_reference_value_in_picklpf :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_picklpf :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_picklpf :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_picklpf :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_picklpf :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_picklpf :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_picklpf :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_picklpf :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_picklpf :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_picklpf :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_picklpf :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_picklpf :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_picklpf :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_picklpf :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_picklpf :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_picklpf :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_picklpf :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_picklpf :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_picklpf :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_picklpf :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_picklpf :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_picklpf :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_picklpf :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_picklpf :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_picklpf :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_picklpf :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

scale2_ratio_in_picklpf :: (mode: s32, hr: *s32, hs: *s32) {
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

validate_buffer_in_picklpf :: (start: *u8, len: u64, end: *u8, error: *Internal_Error_Info) -> s32 {
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

vp8_encode_bool_in_picklpf :: (bc: *BOOL_CODER, bit: s32, probability: s32) {
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

        validate_buffer_in_picklpf(bc.buffer + bc.pos, 1, bc.buffer_end, bc.error);
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

vp8_cost_branch_in_picklpf :: (ct: *u32, p: Vp8_Prob) -> u32 {
    return cast,no_check(u32) ((((cast,no_check(u64) ct[0]) * cast(u64) VP8_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP8_PROB_COST[255 - cast(s32) p]) >> 8);
}

vp8_treed_write_in_picklpf :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) {
    i: Vp8_Tree_Index = 0;

    while true {
        {
            B := v >> ((c_transpiler_pre_decrement(*(n))) & 31) & 1;
            vp8_encode_bool_in_picklpf(W, B, cast,no_check(s32) P[(cast(s32) i) >> 1]);
            i = t[(cast(s32) i) + B];
        }
        if n == 0 break;
    }
}

vp8_write_token_in_picklpf :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) {
    vp8_treed_write_in_picklpf(W, t, P, X.value, X.len);
}

vp8_treed_cost_in_picklpf :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) -> s32 {
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

vp8_cost_token_in_picklpf :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) -> s32 {
    return vp8_treed_cost_in_picklpf(t, P, X.value, X.len);
}

vp8_sem_wait_in_picklpf :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_0: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_0; assignment_0; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init_in_picklpf :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release_in_picklpf :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

atomic_load_acquire_in_picklpf :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_atomic_spin_wait_in_picklpf :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire_in_picklpf(last_row_current_mb_col) - NSYNC {
    }
}

mv_bias_in_picklpf :: (refmb_ref_frame_sign_bias: s32, refframe: s32, mvp: *Int_Mv_in_mv, ref_frame_sign_bias: *s32) {
    if refmb_ref_frame_sign_bias != ref_frame_sign_bias[refframe] {
        mvp.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.row) * -1);
        mvp.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.col) * -1);
    }
}

vp8_clamp_mv2_in_picklpf :: (mv: *Int_Mv_in_mv, xd: *MACROBLOCKD_in_blockd) {
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

vp8_clamp_mv_in_picklpf :: (
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

vp8_check_mv_bounds_in_picklpf :: (
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

left_block_mv_in_picklpf :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> u32 {
    if b & 3 == 0 {
        cur_mb -= 1;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 4;
    }

    return (((cur_mb.bmi.data + b - 1)).mv).as_int;
}

above_block_mv_in_picklpf :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> u32 {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 16;
    }

    return (((cur_mb.bmi.data + (b - 4))).mv).as_int;
}

left_block_mode_in_picklpf :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> B_PREDICTION_MODE {
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

above_block_mode_in_picklpf :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> B_PREDICTION_MODE {
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

vp8cx_pick_filter_level_fast :: (sd: *YV12_BUFFER_CONFIG, cpi: *VP8_COMP) {
    cm := *cpi.common;

    best_err: s32 = 0;
    filt_err: s32 = 0;
    min_filter_level := get_min_filter_level(cpi, cm.base_qindex);
    max_filter_level := get_max_filter_level(cpi, cm.base_qindex);

    saved_frame := cm.frame_to_show;

    cm.frame_to_show = *cpi.pick_lf_lvl_frame;

    if cm.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
        cm.sharpness_level = 0;
    } else {
        cm.sharpness_level = cpi.oxcf.sharpness;
    }

    if cm.sharpness_level != cm.last_sharpness_level {
        vp8_loop_filter_update_sharpness(*cm.lf_info, cm.sharpness_level);
        cm.last_sharpness_level = cm.sharpness_level;
    }

    if cm.filter_level < min_filter_level {
        cm.filter_level = min_filter_level;
    } else if cm.filter_level > max_filter_level {
        cm.filter_level = max_filter_level;
    }

    filt_val := cm.filter_level;
    best_filt_val := filt_val;

    yv12_copy_partial_frame(saved_frame, cm.frame_to_show);
    vp8_loop_filter_partial_frame(cm, *cpi.mb.e_mbd, filt_val);

    best_err = calc_partial_ssl_err(sd, cm.frame_to_show);

    filt_val -= 1 + cast(s32) (filt_val > 10);

    while filt_val >= min_filter_level {
        yv12_copy_partial_frame(saved_frame, cm.frame_to_show);
        vp8_loop_filter_partial_frame(cm, *cpi.mb.e_mbd, filt_val);

        filt_err = calc_partial_ssl_err(sd, cm.frame_to_show);

        if filt_err < best_err {
            best_err = filt_err;
            best_filt_val = filt_val;
        } else {
            break;
        }

        filt_val -= 1 + cast(s32) (filt_val > 10);
    }

    filt_val = cm.filter_level + 1 + cast(s32) (filt_val > 10);

    if best_filt_val == cm.filter_level {
        best_err -= best_err >> 10;

        while filt_val < max_filter_level {
            yv12_copy_partial_frame(saved_frame, cm.frame_to_show);

            vp8_loop_filter_partial_frame(cm, *cpi.mb.e_mbd, filt_val);

            filt_err = calc_partial_ssl_err(sd, cm.frame_to_show);

            if filt_err < best_err {
                best_err = filt_err - filt_err >> 10;

                best_filt_val = filt_val;
            } else {
                break;
            }

            filt_val += 1 + cast(s32) (filt_val > 10);
        }
    }

    cm.filter_level = best_filt_val;

    if cm.filter_level < min_filter_level {
        cm.filter_level = min_filter_level;
    }

    if cm.filter_level > max_filter_level {
        cm.filter_level = max_filter_level;
    }

    cm.frame_to_show = saved_frame;
}

get_max_filter_level :: (cpi: *VP8_COMP, base_qindex: s32) -> s32 {
    max_filter_level: s32 = 63;

    if cpi.twopass.section_intra_rating > 8 {
        max_filter_level = (cast,no_check(s32) ((63 * 3))) / 4;
    }

    return max_filter_level;
}

get_min_filter_level :: (cpi: *VP8_COMP, base_qindex: s32) -> s32 {
    min_filter_level: s32 = ifx cpi.source_alt_ref_active != 0 && cpi.common.refresh_golden_frame != 0 && cpi.common.refresh_alt_ref_frame == 0
        then cast(s32) 0
        else ifx base_qindex <= 6
            then cast(s32) 0
            else ifx base_qindex <= 16
                then cast(s32) 1
                else base_qindex / 8;

    return min_filter_level;
}

calc_partial_ssl_err :: (source: *YV12_BUFFER_CONFIG, dest: *YV12_BUFFER_CONFIG) -> s32 {
    j: s32 = ---;
    total: s32 = 0;

    src: *u8 = source.y_buffer;
    dst: *u8 = dest.y_buffer;

    linestocopy := source.y_height >> 4 / 8;
    linestocopy = ifx linestocopy != 0 then linestocopy << 4 else 16;

    srcoffset := source.y_stride * (dest.y_height >> 5 * 16);
    dstoffset := dest.y_stride * (dest.y_height >> 5 * 16);

    src += srcoffset;
    dst += dstoffset;

    i: s32 = 0;
    while i < linestocopy {
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

yv12_copy_partial_frame :: (src_ybc: *YV12_BUFFER_CONFIG, dst_ybc: *YV12_BUFFER_CONFIG) {
    yheight := src_ybc.y_height;
    ystride := src_ybc.y_stride;

    linestocopy := yheight >> 4 / 8;
    linestocopy = ifx linestocopy != 0 then linestocopy << 4 else 16;

    linestocopy += 4;

    yoffset := ystride * (yheight >> 5 * 16 - 4);
    src_y := src_ybc.y_buffer + yoffset;
    dst_y := dst_ybc.y_buffer + yoffset;

    TOP_ROW := src_ybc.y_buffer;
    {
        i := yoffset;
        while i < 0 {
            copy_memory(dst_y, TOP_ROW, cast,no_check(u64) ystride);
            dst_y += ystride;
            src_y += ystride;
            i += ystride;
            linestocopy -= 1;
        }
    }
    copy_memory(dst_y, src_y, cast,no_check(u64) (ystride * linestocopy));
}

vp8cx_set_alt_lf_level :: (cpi: *VP8_COMP, filt_val: s32) {
    mbd := *cpi.mb.e_mbd;

    mbd.segment_feature_data[MB_LVL_ALT_LF][0] = cpi.segment_feature_data[MB_LVL_ALT_LF][0];
    mbd.segment_feature_data[MB_LVL_ALT_LF][1] = cpi.segment_feature_data[MB_LVL_ALT_LF][1];
    mbd.segment_feature_data[MB_LVL_ALT_LF][2] = cpi.segment_feature_data[MB_LVL_ALT_LF][2];
    mbd.segment_feature_data[MB_LVL_ALT_LF][3] = cpi.segment_feature_data[MB_LVL_ALT_LF][3];
}

vp8cx_pick_filter_level :: (sd: *YV12_BUFFER_CONFIG, cpi: *VP8_COMP) {
    cm := *cpi.common;

    best_err: s32 = 0;
    filt_err: s32 = 0;
    min_filter_level := get_min_filter_level(cpi, cm.base_qindex);
    max_filter_level := get_max_filter_level(cpi, cm.base_qindex);

    filt_high: s32 = 0;

    filt_low: s32 = 0;

    filt_direction: s32 = 0;

    bias: s32 = 0;

    ss_err: [64] s32 = ---;

    saved_frame := cm.frame_to_show;

    fill_memory(ss_err.data, 0, ss_err.count * size_of(s32));

    cm.frame_to_show = *cpi.pick_lf_lvl_frame;

    if cm.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
        cm.sharpness_level = 0;
    } else {
        cm.sharpness_level = cpi.oxcf.sharpness;
    }

    filt_mid := cm.filter_level;

    if filt_mid < min_filter_level {
        filt_mid = min_filter_level;
    } else if filt_mid > max_filter_level {
        filt_mid = max_filter_level;
    }

    filter_step := (ifx filt_mid < 16 then 4 else filt_mid / 4);

    yv12_copy_y_c(saved_frame, cm.frame_to_show);

    vp8cx_set_alt_lf_level(cpi, filt_mid);
    vp8_loop_filter_frame_yonly(cm, *cpi.mb.e_mbd, filt_mid);

    best_err = vp8_calc_ss_err(sd, cm.frame_to_show);

    ss_err[filt_mid] = best_err;

    filt_best := filt_mid;

    while filter_step > 0 {
        bias = best_err >> (((15 - filt_mid / 8)) & 31) * filter_step;

        if cpi.twopass.section_intra_rating < 20 {
            bias = cast,no_check(s32) ((cast,no_check(u32) bias) * cpi.twopass.section_intra_rating / 20);
        }

        filt_high = ifx filt_mid + filter_step > max_filter_level then max_filter_level else filt_mid + filter_step;
        filt_low = ifx filt_mid - filter_step < min_filter_level then min_filter_level else filt_mid - filter_step;

        if filt_direction <= 0 && filt_low != filt_mid {
            if ss_err[filt_low] == 0 {
                yv12_copy_y_c(saved_frame, cm.frame_to_show);
                vp8cx_set_alt_lf_level(cpi, filt_low);
                vp8_loop_filter_frame_yonly(cm, *cpi.mb.e_mbd, filt_low);

                filt_err = vp8_calc_ss_err(sd, cm.frame_to_show);
                ss_err[filt_low] = filt_err;
            } else {
                filt_err = ss_err[filt_low];
            }

            if filt_err - bias < best_err {
                if filt_err < best_err {
                    best_err = filt_err;
                }

                filt_best = filt_low;
            }
        }

        if filt_direction >= 0 && filt_high != filt_mid {
            if ss_err[filt_high] == 0 {
                yv12_copy_y_c(saved_frame, cm.frame_to_show);
                vp8cx_set_alt_lf_level(cpi, filt_high);
                vp8_loop_filter_frame_yonly(cm, *cpi.mb.e_mbd, filt_high);

                filt_err = vp8_calc_ss_err(sd, cm.frame_to_show);
                ss_err[filt_high] = filt_err;
            } else {
                filt_err = ss_err[filt_high];
            }

            if filt_err < best_err - bias {
                best_err = filt_err;
                filt_best = filt_high;
            }
        }

        if filt_best == filt_mid {
            filter_step = filter_step / 2;
            filt_direction = 0;
        } else {
            filt_direction = ifx filt_best < filt_mid then cast(s32) -1 else 1;
            filt_mid = filt_best;
        }
    }

    cm.filter_level = filt_best;

    cm.frame_to_show = saved_frame;
}

