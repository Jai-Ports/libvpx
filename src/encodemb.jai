// Generated directly from C by cpp_transpiler.
Vp8_Token_State :: struct {
    rate: s32;
    error: s32;
    next: s8;
    token: s8;
    qc: s16;
}

PLANE_RD_MULT: [4] s32;

clip_pixel_in_encodemb :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_encodemb :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_encodemb :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_encodemb :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_encodemb :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_encodemb(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_encodemb(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_encodemb(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_encodemb :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_encodemb :: (FILTER: *s16) -> s32 {
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

vp8_set_reference_value_in_encodemb :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_encodemb :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_encodemb :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_encodemb :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_encodemb :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_encodemb :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_encodemb :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_encodemb :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_encodemb :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_encodemb :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_encodemb :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_encodemb :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_encodemb :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_encodemb :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_encodemb :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_encodemb :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_encodemb :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_encodemb :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_encodemb :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_encodemb :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_encodemb :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_encodemb :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_encodemb :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_encodemb :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_encodemb :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_encodemb :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

scale2_ratio_in_encodemb :: (mode: s32, hr: *s32, hs: *s32) {
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

validate_buffer_in_encodemb :: (start: *u8, len: u64, end: *u8, error: *Internal_Error_Info) -> s32 {
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

vp8_encode_bool_in_encodemb :: (bc: *BOOL_CODER, bit: s32, probability: s32) {
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

        validate_buffer_in_encodemb(bc.buffer + bc.pos, 1, bc.buffer_end, bc.error);
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

vp8_cost_branch_in_encodemb :: (ct: *u32, p: Vp8_Prob) -> u32 {
    return cast,no_check(u32) ((((cast,no_check(u64) ct[0]) * cast(u64) VP8_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP8_PROB_COST[255 - cast(s32) p]) >> 8);
}

vp8_treed_write_in_encodemb :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) {
    i: Vp8_Tree_Index = 0;

    while true {
        {
            B := v >> ((c_transpiler_pre_decrement(*(n))) & 31) & 1;
            vp8_encode_bool_in_encodemb(W, B, cast,no_check(s32) P[(cast(s32) i) >> 1]);
            i = t[(cast(s32) i) + B];
        }
        if n == 0 break;
    }
}

vp8_write_token_in_encodemb :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) {
    vp8_treed_write_in_encodemb(W, t, P, X.value, X.len);
}

vp8_treed_cost_in_encodemb :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) -> s32 {
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

vp8_cost_token_in_encodemb :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) -> s32 {
    return vp8_treed_cost_in_encodemb(t, P, X.value, X.len);
}

vp8_sem_wait_in_encodemb :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_0: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_0; assignment_0; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init_in_encodemb :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release_in_encodemb :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

atomic_load_acquire_in_encodemb :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_atomic_spin_wait_in_encodemb :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire_in_encodemb(last_row_current_mb_col) - NSYNC {
    }
}

mv_bias_in_encodemb :: (refmb_ref_frame_sign_bias: s32, refframe: s32, mvp: *Int_Mv_in_mv, ref_frame_sign_bias: *s32) {
    if refmb_ref_frame_sign_bias != ref_frame_sign_bias[refframe] {
        mvp.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.row) * -1);
        mvp.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.col) * -1);
    }
}

vp8_clamp_mv2_in_encodemb :: (mv: *Int_Mv_in_mv, xd: *MACROBLOCKD_in_blockd) {
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

vp8_clamp_mv_in_encodemb :: (
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

vp8_check_mv_bounds_in_encodemb :: (
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

left_block_mv_in_encodemb :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> u32 {
    if b & 3 == 0 {
        cur_mb -= 1;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 4;
    }

    return (((cur_mb.bmi.data + b - 1)).mv).as_int;
}

above_block_mv_in_encodemb :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> u32 {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 16;
    }

    return (((cur_mb.bmi.data + (b - 4))).mv).as_int;
}

left_block_mode_in_encodemb :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> B_PREDICTION_MODE {
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

above_block_mode_in_encodemb :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> B_PREDICTION_MODE {
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

vp8_encode_inter16x16 :: (x: *MACROBLOCK_in_block) {
    vp8_build_inter_predictors_mb(*x.e_mbd);

    vp8_subtract_mb(x);

    transform_mb(x);

    vp8_quantize_mb(x);

    if x.optimize != 0 {
        optimize_mb(x);
    }
}

optimize_mb :: (x: *MACROBLOCK_in_block) {
    t_above, t_left: ENTROPY_CONTEXT_PLANES = ---;

    t_above = x.e_mbd.above_context.*;
    t_left = x.e_mbd.left_context.*;

    ta := cast(*ENTROPY_CONTEXT) *t_above;
    tl := cast(*ENTROPY_CONTEXT) *t_left;

    has_2nd_order :=
        cast(s32) (x.e_mbd.mode_info_context.mbmi.mode != cast,no_check(u8) B_PRED &&
            x.e_mbd.mode_info_context.mbmi.mode != cast,no_check(u8) SPLITMV);
    type := (ifx has_2nd_order != 0 then cast(s32) 0 else 3);

    b: s32 = 0;
    while b < 16 {
        optimize_b(x, b, type, ta + cast,no_check(s32) VP8_BLOCK2ABOVE[b], tl + cast,no_check(s32) VP8_BLOCK2LEFT[b]);
        b += 1;
    }

    b = 16;
    while b < 24 {
        optimize_b(x, b, 2, ta + cast,no_check(s32) VP8_BLOCK2ABOVE[b], tl + cast,no_check(s32) VP8_BLOCK2LEFT[b]);
        b += 1;
    }

    if has_2nd_order != 0 {
        b = 24;
        optimize_b(x, b, 1, ta + cast,no_check(s32) VP8_BLOCK2ABOVE[b], tl + cast,no_check(s32) VP8_BLOCK2LEFT[b]);
        check_reset_2nd_coeffs(
            *x.e_mbd,
            1,
            ta + cast,no_check(s32) VP8_BLOCK2ABOVE[b],
            tl + cast,no_check(s32) VP8_BLOCK2LEFT[b]
        );
    }
}

check_reset_2nd_coeffs :: (x: *MACROBLOCKD_in_blockd, type: s32, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) {
    sum: s32 = 0;

    bd := x.block.data + 24;

    if bd.dequant[0] >= 35 && bd.dequant[1] >= 35 {
        return;
    }

    i: s32 = 0;
    while i < cast,no_check(s32) bd.eob.* {
        coef := cast,no_check(s32) bd.dqcoeff[VP8_DEFAULT_ZIG_ZAG1D[i]];
        sum += (ifx coef >= 0 then coef else -coef);
        if sum >= 35 {
            return;
        }
        i += 1;
    }

    if sum < 35 {
        i = 0;
        while i < cast,no_check(s32) bd.eob.* {
            rc := VP8_DEFAULT_ZIG_ZAG1D[i];
            bd.qcoeff[rc] = 0;
            bd.dqcoeff[rc] = 0;
            i += 1;
        }
        bd.eob.* = 0;
        l.* = cast(ENTROPY_CONTEXT) (cast,no_check(s32) bd.eob.* != cast(s32) (type == 0));
        a.* = l.*;
    }
}

optimize_b :: (mb: *MACROBLOCK_in_block, ib: s32, type: s32, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) {
    tokens: [17] [2] Vp8_Token_State = ---;
    best_mask: [2] u32 = ---;

    rc: s32 = ---;
    x: s32 = ---;
    sz: s32 = 0;

    rd_cost0: s32 = ---;
    rd_cost1: s32 = ---;
    rate0: s32 = ---;
    rate1: s32 = ---;
    error0: s32 = ---;
    error1: s32 = ---;
    t0: s32 = ---;
    t1: s32 = ---;
    best: s32 = ---;
    band: s32 = ---;
    pt: s32 = ---;

    err_mult := PLANE_RD_MULT[type];

    b := mb.block.data + ib;
    d := mb.e_mbd.block.data + ib;

    dequant_ptr := d.dequant;
    coeff_ptr := b.coeff;
    qcoeff_ptr := d.qcoeff;
    dqcoeff_ptr := d.dqcoeff;
    i0 := cast(s32) (type == 0);
    eob := cast,no_check(s32) d.eob.*;

    rdmult := mb.rdmult * err_mult;
    if mb.e_mbd.mode_info_context.mbmi.ref_frame == cast,no_check(u8) INTRA_FRAME {
        rdmult = (rdmult * 9) >> 4;
    }

    rddiv := mb.rddiv;
    best_mask[1] = 0;
    best_mask[0] = best_mask[1];

    tokens[eob][0].rate = 0;
    tokens[eob][0].error = 0;
    tokens[eob][0].next = 16;
    tokens[eob][0].token = 11;
    tokens[eob][0].qc = 0;
    assignment_1: Vp8_Token_State = (tokens[eob].data).*;
    ((tokens[eob].data + 1).*) = assignment_1;
    next := eob;
    i := eob;
    while c_transpiler_post_decrement(*(i)) > i0 {
        base_bits: s32 = ---;
        d2: s32 = ---;
        dx: s32 = ---;

        rc = VP8_DEFAULT_ZIG_ZAG1D[i];
        x = cast,no_check(s32) qcoeff_ptr[rc];

        if x != 0 {
            shortcut: s32 = 0;
            error0 = tokens[next][0].error;
            error1 = tokens[next][1].error;

            rate0 = tokens[next][0].rate;
            rate1 = tokens[next][1].rate;
            t0 = cast,no_check(s32) (((VP8_DCT_VALUE_TOKENS_PTR + x)).token);

            if next < 16 {
                band = cast,no_check(s32) VP8_COEF_BANDS[i + 1];
                pt = cast,no_check(s32) VP8_PREV_TOKEN_CLASS[t0];
                rate0 += mb.token_costs[type][band][pt][tokens[next][0].token];
                rate1 += mb.token_costs[type][band][pt][tokens[next][1].token];
            }
            rd_cost0 = (128 + rate0 * rdmult) >> 8 + rddiv * error0;
            rd_cost1 = (128 + rate1 * rdmult) >> 8 + rddiv * error1;
            if rd_cost0 == rd_cost1 {
                rd_cost0 = (128 + rate0 * rdmult) & 0xff;
                rd_cost1 = (128 + rate1 * rdmult) & 0xff;
            }

            best = cast(s32) (rd_cost1 < rd_cost0);
            base_bits = cast,no_check(s32) ((VP8_DCT_VALUE_COST_PTR + x).*);
            dx = (cast(s32) dqcoeff_ptr[rc]) - cast(s32) coeff_ptr[rc];
            d2 = dx * dx;
            tokens[i][0].rate = base_bits + (ifx best != 0 then rate1 else rate0);
            tokens[i][0].error = d2 + (ifx best != 0 then error1 else error0);
            tokens[i][0].next = cast,no_check(s8) next;
            tokens[i][0].token = cast,no_check(s8) t0;
            tokens[i][0].qc = cast,no_check(s16) x;
            best_mask[0] |= cast,no_check(u32) (best << ((i) & 31));

            rate0 = tokens[next][0].rate;
            rate1 = tokens[next][1].rate;

            if (absolute_value(x) * cast(s32) dequant_ptr[rc]) > absolute_value(cast,no_check(s32) coeff_ptr[rc]) &&
                (absolute_value(x) * cast(s32) dequant_ptr[rc]) < absolute_value(cast,no_check(s32) coeff_ptr[rc]) + cast(s32) dequant_ptr[rc] {
                shortcut = 1;
            } else {
                shortcut = 0;
            }

            if shortcut != 0 {
                sz = -(cast(s32) (x < 0));
                x -= 2 * sz + 1;
            }

            if x == 0 {
                t0 = ifx tokens[next][0].token == 11 then cast(s32) 11 else 0;
                t1 = ifx tokens[next][1].token == 11 then cast(s32) 11 else 0;
            } else {
                t1 = cast,no_check(s32) (((VP8_DCT_VALUE_TOKENS_PTR + x)).token);
                t0 = t1;
            }
            if next < 16 {
                band = cast,no_check(s32) VP8_COEF_BANDS[i + 1];
                if t0 != 11 {
                    pt = cast,no_check(s32) VP8_PREV_TOKEN_CLASS[t0];
                    rate0 += mb.token_costs[type][band][pt][tokens[next][0].token];
                }
                if t1 != 11 {
                    pt = cast,no_check(s32) VP8_PREV_TOKEN_CLASS[t1];
                    rate1 += mb.token_costs[type][band][pt][tokens[next][1].token];
                }
            }

            rd_cost0 = (128 + rate0 * rdmult) >> 8 + rddiv * error0;
            rd_cost1 = (128 + rate1 * rdmult) >> 8 + rddiv * error1;
            if rd_cost0 == rd_cost1 {
                rd_cost0 = (128 + rate0 * rdmult) & 0xff;
                rd_cost1 = (128 + rate1 * rdmult) & 0xff;
            }

            best = cast(s32) (rd_cost1 < rd_cost0);
            base_bits = cast,no_check(s32) ((VP8_DCT_VALUE_COST_PTR + x).*);

            if shortcut != 0 {
                dx -= ((cast(s32) dequant_ptr[rc]) + sz) ^ sz;
                d2 = dx * dx;
            }
            tokens[i][1].rate = base_bits + (ifx best != 0 then rate1 else rate0);
            tokens[i][1].error = d2 + (ifx best != 0 then error1 else error0);
            tokens[i][1].next = cast,no_check(s8) next;
            tokens[i][1].token = cast,no_check(s8) ((ifx best != 0 then t1 else t0));
            tokens[i][1].qc = cast,no_check(s16) x;
            best_mask[1] |= cast,no_check(u32) (best << ((i) & 31));

            next = i;
        } else {
            band = cast,no_check(s32) VP8_COEF_BANDS[i + 1];
            t0 = cast,no_check(s32) tokens[next][0].token;
            t1 = cast,no_check(s32) tokens[next][1].token;

            if t0 != 11 {
                tokens[next][0].rate += mb.token_costs[type][band][0][t0];
                tokens[next][0].token = 0;
            }
            if t1 != 11 {
                tokens[next][1].rate += mb.token_costs[type][band][0][t1];
                tokens[next][1].token = 0;
            }
        }
    }

    band = cast,no_check(s32) VP8_COEF_BANDS[i + 1];
    pt = (cast(s32) a.*) + cast(s32) l.*;
    rate0 = tokens[next][0].rate;
    rate1 = tokens[next][1].rate;
    error0 = tokens[next][0].error;
    error1 = tokens[next][1].error;
    t0 = cast,no_check(s32) tokens[next][0].token;
    t1 = cast,no_check(s32) tokens[next][1].token;
    rate0 += mb.token_costs[type][band][pt][t0];
    rate1 += mb.token_costs[type][band][pt][t1];
    rd_cost0 = (128 + rate0 * rdmult) >> 8 + rddiv * error0;
    rd_cost1 = (128 + rate1 * rdmult) >> 8 + rddiv * error1;
    if rd_cost0 == rd_cost1 {
        rd_cost0 = (128 + rate0 * rdmult) & 0xff;
        rd_cost1 = (128 + rate1 * rdmult) & 0xff;
    }
    best = cast(s32) (rd_cost1 < rd_cost0);
    final_eob := i0 - 1;
    i = next;
    while i < eob {
        x = cast,no_check(s32) tokens[i][best].qc;
        if x != 0 {
            final_eob = i;
        }
        rc = VP8_DEFAULT_ZIG_ZAG1D[i];
        qcoeff_ptr[rc] = cast,no_check(s16) x;
        dqcoeff_ptr[rc] = cast,no_check(s16) (x * cast(s32) dequant_ptr[rc]);
        next = cast,no_check(s32) tokens[i][best].next;
        best = cast,no_check(s32) (best_mask[best] >> ((i) & 31) & 1);
        i = next;
    }
    final_eob += 1;

    l.* = cast(ENTROPY_CONTEXT) (final_eob != cast(s32) (type == 0));
    a.* = l.*;
    d.eob.* = cast,no_check(s8) final_eob;
}

transform_mb :: (x: *MACROBLOCK_in_block) {
    i: s32 = 0;
    while i < 16 {
        x.short_fdct8x4(*x.block[i].src_diff[0], *x.block[i].coeff[0], 32);
        i += 2;
    }

    if x.e_mbd.mode_info_context.mbmi.mode != cast,no_check(u8) SPLITMV {
        build_dcblock(x);
    }

    i = 16;
    while i < 24 {
        x.short_fdct8x4(*x.block[i].src_diff[0], *x.block[i].coeff[0], 16);
        i += 2;
    }

    if x.e_mbd.mode_info_context.mbmi.mode != cast,no_check(u8) SPLITMV {
        x.short_walsh4x4(*x.block[24].src_diff[0], *x.block[24].coeff[0], 8);
    }
}

build_dcblock :: (x: *MACROBLOCK_in_block) {
    src_diff_ptr := x.src_diff.data + 384;

    for i: 0..cast(s32) 16 - 1 {
        src_diff_ptr[i] = x.coeff[i * 16];
    }
}

vp8_subtract_mb :: (x: *MACROBLOCK_in_block) {
    b := x.block.data + 0;

    vp8_subtract_mby(x.src_diff.data, b.base_src.*, b.src_stride, x.e_mbd.dst.y_buffer, x.e_mbd.dst.y_stride);
    vp8_subtract_mbuv(
        x.src_diff.data,
        x.src.u_buffer,
        x.src.v_buffer,
        x.src.uv_stride,
        x.e_mbd.dst.u_buffer,
        x.e_mbd.dst.v_buffer,
        x.e_mbd.dst.uv_stride
    );
}

vp8_subtract_mbuv :: (diff: *s16, usrc: *u8, vsrc: *u8, src_stride: s32, upred: *u8, vpred: *u8, pred_stride: s32) {
    udiff := diff + 256;
    vdiff := diff + 320;

    subtract_block_c(8, 8, udiff, 8, usrc, cast,no_check(s64) src_stride, upred, cast,no_check(s64) pred_stride);
    subtract_block_c(8, 8, vdiff, 8, vsrc, cast,no_check(s64) src_stride, vpred, cast,no_check(s64) pred_stride);
}

vp8_subtract_mby :: (diff: *s16, src: *u8, src_stride: s32, pred: *u8, pred_stride: s32) {
    subtract_block_c(16, 16, diff, 16, src, cast,no_check(s64) src_stride, pred, cast,no_check(s64) pred_stride);
}

vp8_subtract_b :: (be: *BLOCK, bd: *BLOCKD, pitch: s32) {
    src_ptr := be.base_src.* + be.src;
    diff_ptr := be.src_diff;
    pred_ptr := bd.predictor;
    src_stride := be.src_stride;

    subtract_block_c(
        4,
        4,
        diff_ptr,
        cast,no_check(s64) pitch,
        src_ptr,
        cast,no_check(s64) src_stride,
        pred_ptr,
        cast,no_check(s64) pitch
    );
}

vp8_transform_mbuv :: (x: *MACROBLOCK_in_block) {
    i: s32 = 16;
    while i < 24 {
        x.short_fdct8x4(*x.block[i].src_diff[0], *x.block[i].coeff[0], 16);
        i += 2;
    }
}

vp8_transform_intra_mby :: (x: *MACROBLOCK_in_block) {
    i: s32 = 0;
    while i < 16 {
        x.short_fdct8x4(*x.block[i].src_diff[0], *x.block[i].coeff[0], 32);
        i += 2;
    }

    build_dcblock(x);

    x.short_walsh4x4(*x.block[24].src_diff[0], *x.block[24].coeff[0], 8);
}

vp8_optimize_mby :: (x: *MACROBLOCK_in_block) {
    t_above, t_left: ENTROPY_CONTEXT_PLANES = ---;

    if x.e_mbd.above_context == null {
        return;
    }

    if x.e_mbd.left_context == null {
        return;
    }

    t_above = x.e_mbd.above_context.*;
    t_left = x.e_mbd.left_context.*;

    ta := cast(*ENTROPY_CONTEXT) *t_above;
    tl := cast(*ENTROPY_CONTEXT) *t_left;

    has_2nd_order :=
        cast(s32) (x.e_mbd.mode_info_context.mbmi.mode != cast,no_check(u8) B_PRED &&
            x.e_mbd.mode_info_context.mbmi.mode != cast,no_check(u8) SPLITMV);
    type := (ifx has_2nd_order != 0 then cast(s32) 0 else 3);

    b: s32 = 0;
    while b < 16 {
        optimize_b(x, b, type, ta + cast,no_check(s32) VP8_BLOCK2ABOVE[b], tl + cast,no_check(s32) VP8_BLOCK2LEFT[b]);
        b += 1;
    }

    if has_2nd_order != 0 {
        b = 24;
        optimize_b(x, b, 1, ta + cast,no_check(s32) VP8_BLOCK2ABOVE[b], tl + cast,no_check(s32) VP8_BLOCK2LEFT[b]);
        check_reset_2nd_coeffs(
            *x.e_mbd,
            1,
            ta + cast,no_check(s32) VP8_BLOCK2ABOVE[b],
            tl + cast,no_check(s32) VP8_BLOCK2LEFT[b]
        );
    }
}

vp8_optimize_mbuv :: (x: *MACROBLOCK_in_block) {
    t_above, t_left: ENTROPY_CONTEXT_PLANES = ---;

    if x.e_mbd.above_context == null {
        return;
    }

    if x.e_mbd.left_context == null {
        return;
    }

    t_above = x.e_mbd.above_context.*;
    t_left = x.e_mbd.left_context.*;

    ta := cast(*ENTROPY_CONTEXT) *t_above;
    tl := cast(*ENTROPY_CONTEXT) *t_left;

    if 16 < 24 {
        for b: 16..cast(s32) 24 - 1 {
            optimize_b(x, b, 2, ta + cast,no_check(s32) VP8_BLOCK2ABOVE[b], tl + cast,no_check(s32) VP8_BLOCK2LEFT[b]);
        }
    }
}

vp8_encode_inter16x16y :: (x: *MACROBLOCK_in_block) {
    b := x.block.data + 0;

    vp8_build_inter16x16_predictors_mby(*x.e_mbd, x.e_mbd.dst.y_buffer, x.e_mbd.dst.y_stride);

    vp8_subtract_mby(x.src_diff.data, b.base_src.*, b.src_stride, x.e_mbd.dst.y_buffer, x.e_mbd.dst.y_stride);

    transform_mby(x);

    vp8_quantize_mby(x);

    vp8_inverse_transform_mby_in_encodemb(*x.e_mbd);
}

vp8_inverse_transform_mby_in_encodemb :: (xd: *MACROBLOCKD_in_blockd) {
    dqc := xd.dequant_y1.data;

    if xd.mode_info_context.mbmi.mode != cast,no_check(u8) SPLITMV {
        if xd.eobs[24] > 1 {
            vp8_short_inv_walsh4x4_c(*xd.block[24].dqcoeff[0], xd.qcoeff.data);
        } else {
            vp8_short_inv_walsh4x4_1_c(*xd.block[24].dqcoeff[0], xd.qcoeff.data);
        }
        eob_adjust_in_encodemb(xd.eobs.data, xd.qcoeff.data);

        dqc = xd.dequant_y1_dc.data;
    }
    vp8_dequant_idct_add_y_block_c(xd.qcoeff.data, dqc, xd.dst.y_buffer, xd.dst.y_stride, xd.eobs.data);
}

eob_adjust_in_encodemb :: (eobs: *s8, diff: *s16) {
    for js: 0..cast(s32) 16 - 1 {
        if eobs[js] == 0 && diff[0] != 0 {
            eobs[js] += 1;
        }
        diff += 16;
    }
}

transform_mby :: (x: *MACROBLOCK_in_block) {
    i: s32 = 0;
    while i < 16 {
        x.short_fdct8x4(*x.block[i].src_diff[0], *x.block[i].coeff[0], 32);
        i += 2;
    }

    if x.e_mbd.mode_info_context.mbmi.mode != cast,no_check(u8) SPLITMV {
        build_dcblock(x);
        x.short_walsh4x4(*x.block[24].src_diff[0], *x.block[24].coeff[0], 8);
    }
}

insertsortmv_in_encodemb :: (arr: *s32, len: s32) {
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

insertsortsad_in_encodemb :: (arr: *s32, idx: *s32, len: s32) {
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

get_plane_pointers_in_encodemb :: (fb: *YV12_BUFFER_CONFIG, plane: **u8, recon_yoffset: u32, recon_uvoffset: u32) {
    plane[0] = fb.y_buffer + recon_yoffset;
    plane[1] = fb.u_buffer + recon_uvoffset;
    plane[2] = fb.v_buffer + recon_uvoffset;
}

get_predictor_pointers_in_encodemb :: (cpi: *VP8_COMP, plane: *[3] *u8, recon_yoffset: u32, recon_uvoffset: u32) {
    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_LAST_FRAME) != 0 {
        get_plane_pointers_in_encodemb(
            cpi.common.yv12_fb.data + cpi.common.lst_fb_idx,
            plane[LAST_FRAME].data,
            recon_yoffset,
            recon_uvoffset
        );
    }

    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_GOLD_FRAME) != 0 {
        get_plane_pointers_in_encodemb(
            cpi.common.yv12_fb.data + cpi.common.gld_fb_idx,
            plane[GOLDEN_FRAME].data,
            recon_yoffset,
            recon_uvoffset
        );
    }

    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_ALTR_FRAME) != 0 {
        get_plane_pointers_in_encodemb(
            cpi.common.yv12_fb.data + cpi.common.alt_fb_idx,
            plane[ALTREF_FRAME].data,
            recon_yoffset,
            recon_uvoffset
        );
    }
}

get_reference_search_order_in_encodemb :: (cpi: *VP8_COMP, ref_frame_map: *s32) {
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

globals_initialization_state_for_encodemb: u32;
initialize_globals_for_encodemb :: () {
    {
        state := atomic_load(*globals_initialization_state_for_encodemb);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_encodemb, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_encodemb) != 2 {}
            return;
        }
    }
    PLANE_RD_MULT = s32.[ 4, 16, 2, 4 ];
    atomic_store(*globals_initialization_state_for_encodemb, 2);
}

TOKENVALUE :: struct {
    token: s16;
    extra: s16;
}

