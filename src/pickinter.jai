clip_pixel_in_pickinter :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_pickinter :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_pickinter :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_pickinter :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_pickinter :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_pickinter(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_pickinter(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_pickinter(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_pickinter :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_pickinter :: (FILTER: *s16) -> s32 {
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

vp8_set_reference_value_in_pickinter :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_pickinter :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_pickinter :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_pickinter :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_pickinter :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_pickinter :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_pickinter :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_pickinter :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_pickinter :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_pickinter :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_pickinter :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_pickinter :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_pickinter :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_pickinter :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_pickinter :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_pickinter :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_pickinter :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_pickinter :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_pickinter :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_pickinter :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_pickinter :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_pickinter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_pickinter :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_pickinter :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_pickinter :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_pickinter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

scale2_ratio_in_pickinter :: (mode: s32, hr: *s32, hs: *s32) {
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

validate_buffer_in_pickinter :: (start: *u8, len: u64, end: *u8, error: *Internal_Error_Info) -> s32 {
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

vp8_encode_bool_in_pickinter :: (bc: *BOOL_CODER, bit: s32, probability: s32) {
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

        validate_buffer_in_pickinter(bc.buffer + bc.pos, 1, bc.buffer_end, bc.error);
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

vp8_cost_branch_in_pickinter :: (ct: *u32, p: Vp8_Prob) -> u32 {
    return cast,no_check(u32) ((((cast,no_check(u64) ct[0]) * cast(u64) VP8_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP8_PROB_COST[255 - cast(s32) p]) >> 8);
}

vp8_treed_write_in_pickinter :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) {
    i: Vp8_Tree_Index = 0;

    while true {
        {
            B := v >> ((c_transpiler_pre_decrement(*(n))) & 31) & 1;
            vp8_encode_bool_in_pickinter(W, B, cast,no_check(s32) P[(cast(s32) i) >> 1]);
            i = t[(cast(s32) i) + B];
        }
        if n == 0 break;
    }
}

vp8_write_token_in_pickinter :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) {
    vp8_treed_write_in_pickinter(W, t, P, X.value, X.len);
}

vp8_treed_cost_in_pickinter :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) -> s32 {
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

vp8_cost_token_in_pickinter :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) -> s32 {
    return vp8_treed_cost_in_pickinter(t, P, X.value, X.len);
}

vp8_sem_wait_in_pickinter :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_0: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_0; assignment_0; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init_in_pickinter :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release_in_pickinter :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

atomic_load_acquire_in_pickinter :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_atomic_spin_wait_in_pickinter :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire_in_pickinter(last_row_current_mb_col) - NSYNC {
    }
}

vp8_skip_fractional_mv_step :: (
    mb: *MACROBLOCK_in_block,
    b: *BLOCK,
    d: *BLOCKD,
    bestmv: *Int_Mv_in_mv,
    ref_mv: *Int_Mv_in_mv,
    error_per_bit: s32,
    vfp: *Vp8_Variance_Fn_Ptr_T,
    mvcost: **s32,
    distortion: *s32,
    sse: *u32
) -> s32 {
    bestmv.as_mv.row =
        cast,no_check(s16) clamp_in_pickinter(
            (cast(s32) bestmv.as_mv.row) * 8,
            cast,no_check(s32) (-32767 - 1),
            32767
        );
    bestmv.as_mv.col =
        cast,no_check(s16) clamp_in_pickinter(
            (cast(s32) bestmv.as_mv.col) * 8,
            cast,no_check(s32) (-32767 - 1),
            32767
        );
    return 0;
}

mv_bias_in_pickinter :: (refmb_ref_frame_sign_bias: s32, refframe: s32, mvp: *Int_Mv_in_mv, ref_frame_sign_bias: *s32) {
    if refmb_ref_frame_sign_bias != ref_frame_sign_bias[refframe] {
        mvp.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.row) * -1);
        mvp.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.col) * -1);
    }
}

vp8_clamp_mv2_in_pickinter :: (mv: *Int_Mv_in_mv, xd: *MACROBLOCKD_in_blockd) {
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

vp8_clamp_mv_in_pickinter :: (
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

vp8_check_mv_bounds_in_pickinter :: (
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

left_block_mv_in_pickinter :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> u32 {
    if b & 3 == 0 {
        cur_mb -= 1;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 4;
    }

    return (((cur_mb.bmi.data + b - 1)).mv).as_int;
}

above_block_mv_in_pickinter :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> u32 {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 16;
    }

    return (((cur_mb.bmi.data + (b - 4))).mv).as_int;
}

left_block_mode_in_pickinter :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> B_PREDICTION_MODE {
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

above_block_mode_in_pickinter :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> B_PREDICTION_MODE {
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

vp8_pick_inter_mode :: (
    cpi: *VP8_COMP,
    x: *MACROBLOCK_in_block,
    recon_yoffset: s32,
    recon_uvoffset: s32,
    returnrate: *s32,
    returndistortion: *s32,
    returnintra: *s32,
    mb_row: s32,
    mb_col: s32
) {
    b := x.block.data + 0;
    d := x.e_mbd.block.data + 0;
    xd := *x.e_mbd;
    best_mbmode: MB_MODE_INFO = ---;

    best_ref_mv_sb: [2] Int_Mv_in_mv;
    mode_mv_sb: [2] [10] Int_Mv_in_mv = ---;
    best_ref_mv: Int_Mv_in_mv = ---;

    num00: s32 = ---;
    mdcounts: [4] s32 = ---;
    best_rd: s32 = 2147483647;
    rd_adjustment: s32 = 100;
    best_intra_rd: s32 = 2147483647;

    rate: s32 = ---;
    rate2: s32 = ---;
    distortion2: s32 = ---;
    bestsme: s32 = 2147483647;
    best_mode_index: s32 = 0;
    sse: u32 = U32_MAX;
    best_rd_sse: u32 = U32_MAX;

    zero_mv_sse: u32 = U32_MAX;
    best_sse: u32 = U32_MAX;

    sf_improved_mv_pred := cpi.sf.improved_mv_pred;

    mvp: Int_Mv_in_mv = ---;

    near_sadidx :=
        s32.[
            0,
            1,
            2,
            3,
            4,
            5,
            6,
            7
        ];
    saddone: s32 = 0;

    sr: s32 = 0;

    plane: [4] [3] *u8;
    ref_frame_map: [4] s32 = ---;
    sign_bias: s32 = 0;
    dot_artifact_candidate: s32 = 0;
    get_predictor_pointers_in_pickinter(
        cpi,
        plane.data,
        cast,no_check(u32) recon_yoffset,
        cast,no_check(u32) recon_uvoffset
    );

    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_LAST_FRAME) != 0 {
        target_y: *u8 = x.src.y_buffer;
        target_u := x.block[16].src + x.block[16].base_src.*;
        target_v := x.block[20].src + x.block[20].base_src.*;
        stride := x.src.y_stride;
        stride_uv := x.block[16].src_stride;

        if cpi.oxcf.noise_sensitivity != 0 {
            UV_DENOISE := cast(s32) (cpi.oxcf.noise_sensitivity >= 2);
            target_y = cpi.denoiser.yv12_running_avg[LAST_FRAME].y_buffer + recon_yoffset;
            stride = cpi.denoiser.yv12_running_avg[LAST_FRAME].y_stride;
            if UV_DENOISE != 0 {
                target_u = cpi.denoiser.yv12_running_avg[LAST_FRAME].u_buffer + recon_uvoffset;
                target_v = cpi.denoiser.yv12_running_avg[LAST_FRAME].v_buffer + recon_uvoffset;
                stride_uv = cpi.denoiser.yv12_running_avg[LAST_FRAME].uv_stride;
            }
        }

        dot_artifact_candidate =
            check_dot_artifact_candidate(
                cpi,
                x,
                target_y,
                stride,
                plane[LAST_FRAME][0],
                mb_row,
                mb_col,
                0
            );

        if dot_artifact_candidate == 0 {
            dot_artifact_candidate =
                check_dot_artifact_candidate(
                    cpi,
                    x,
                    target_u,
                    stride_uv,
                    plane[LAST_FRAME][1],
                    mb_row,
                    mb_col,
                    1
                );
            if dot_artifact_candidate == 0 {
                dot_artifact_candidate =
                    check_dot_artifact_candidate(
                        cpi,
                        x,
                        target_v,
                        stride_uv,
                        plane[LAST_FRAME][2],
                        mb_row,
                        mb_col,
                        2
                    );
            }
        }
    }

    x.is_skin = 0;
    if cpi.oxcf.screen_content_mode == 0 {
        block_index := mb_row * cpi.common.mb_cols + mb_col;
        x.is_skin = cast,no_check(s32) cpi.skin_map[block_index];
    }

    if cpi.oxcf.noise_sensitivity != 0 {
    }

    mode_mv := mode_mv_sb[sign_bias].data;
    best_ref_mv.as_int = 0;
    fill_memory(mode_mv_sb.data, 0, mode_mv_sb.count * size_of([10] Int_Mv_in_mv));
    fill_memory(*best_mbmode, 0, size_of(MB_MODE_INFO));

    get_reference_search_order_in_pickinter(cpi, ref_frame_map.data);

    if ref_frame_map[1] > 0 {
        sign_bias =
            vp8_find_near_mvs_bias(
                *x.e_mbd,
                x.e_mbd.mode_info_context,
                mode_mv_sb.data,
                best_ref_mv_sb.data,
                mdcounts.data,
                ref_frame_map[1],
                cpi.common.ref_frame_sign_bias.data
            );

        mode_mv = mode_mv_sb[sign_bias].data;
        best_ref_mv.as_int = best_ref_mv_sb[sign_bias].as_int;
    }

    x.mbs_tested_so_far += 1;

    returnintra.* = 2147483647;
    x.skip = 0;

    x.e_mbd.mode_info_context.mbmi.ref_frame = cast,no_check(u8) INTRA_FRAME;

    if cpi.speed < 12 {
        calculate_zeromv_rd_adjustment(cpi, x, *rd_adjustment);
    }

    if cpi.oxcf.noise_sensitivity != 0 {
        rd_adjustment =
            cast,no_check(s32) ((cast,no_check(u32) rd_adjustment) *
                cpi.denoiser.denoise_pars.pickmode_mv_bias / 100);
    }

    if dot_artifact_candidate != 0 {
        rd_adjustment = 150;
    }

    for mode_index: 0..cast(s32) 20 - 1 {
        this_rd: s32 = 2147483647;
        this_ref_frame := ref_frame_map[VP8_REF_FRAME_ORDER[mode_index]];

        if best_rd <= x.rd_threshes[mode_index] {
            continue;
        }

        if this_ref_frame < 0 {
            continue;
        }

        x.e_mbd.mode_info_context.mbmi.ref_frame = cast,no_check(u8) this_ref_frame;

        if x.e_mbd.mode_info_context.mbmi.ref_frame != 0 {
            x.e_mbd.pre.y_buffer = plane[this_ref_frame][0];
            x.e_mbd.pre.u_buffer = plane[this_ref_frame][1];
            x.e_mbd.pre.v_buffer = plane[this_ref_frame][2];

            if sign_bias != cpi.common.ref_frame_sign_bias[this_ref_frame] {
                sign_bias = cpi.common.ref_frame_sign_bias[this_ref_frame];
                mode_mv = mode_mv_sb[sign_bias].data;
                best_ref_mv.as_int = best_ref_mv_sb[sign_bias].as_int;
            }
        }

        if x.mode_test_hit_counts[mode_index] != 0 && cpi.mode_check_freq[mode_index] > 1 {
            if x.mbs_tested_so_far <= cpi.mode_check_freq[mode_index] * x.mode_test_hit_counts[mode_index] {
                x.rd_thresh_mult[mode_index] += 4;

                if x.rd_thresh_mult[mode_index] > 512 {
                    x.rd_thresh_mult[mode_index] = 512;
                }

                x.rd_threshes[mode_index] = cpi.rd_baseline_thresh[mode_index] >> 7 * x.rd_thresh_mult[mode_index];
                continue;
            }
        }

        x.mode_test_hit_counts[mode_index] += 1;

        rate2 = 0;
        distortion2 = 0;

        this_mode := VP8_MODE_ORDER[mode_index];

        x.e_mbd.mode_info_context.mbmi.mode = cast,no_check(u8) this_mode;
        x.e_mbd.mode_info_context.mbmi.uv_mode = cast,no_check(u8) DC_PRED;

        frame_cost := x.ref_frame_cost[x.e_mbd.mode_info_context.mbmi.ref_frame];
        rate2 += frame_cost;

        if cpi.is_src_frame_alt_ref != 0 && cpi.oxcf.arnr_max_frames == 0 {
            if this_mode != cast,no_check(u32) ZEROMV || x.e_mbd.mode_info_context.mbmi.ref_frame != cast,no_check(u8) ALTREF_FRAME {
                continue;
            }
        }

        if this_mode == {
            case cast,no_check(u32) B_PRED;
                distortion2 = cast,no_check(s32) best_rd_sse;
                pick_intra4x4mby_modes(x, *rate, *distortion2);
                if distortion2 == 2147483647 {
                    this_rd = 2147483647;
                } else {
                    rate2 += rate;
                    distortion2 =
                        cast,no_check(s32) variance16x16_c(
                            b.base_src.*,
                            b.src_stride,
                            x.e_mbd.predictor.data,
                            16,
                            *sse
                        );
                    this_rd = (128 + rate2 * x.rdmult) >> 8 + x.rddiv * distortion2;

                    if this_rd < best_intra_rd {
                        best_intra_rd = this_rd;
                        returnintra.* = distortion2;
                    }
                }
            case cast,no_check(u32) SPLITMV;
            case cast,no_check(u32) DC_PRED; #through;
            case cast,no_check(u32) V_PRED; #through;
            case cast,no_check(u32) H_PRED; #through;
            case cast,no_check(u32) TM_PRED;
                vp8_build_intra_predictors_mby_s(
                    xd,
                    xd.dst.y_buffer - xd.dst.y_stride,
                    xd.dst.y_buffer - 1,
                    xd.dst.y_stride,
                    xd.predictor.data,
                    16
                );
                distortion2 =
                    cast,no_check(s32) variance16x16_c(
                        b.base_src.*,
                        b.src_stride,
                        x.e_mbd.predictor.data,
                        16,
                        *sse
                    );
                rate2 += x.mbmode_cost[x.e_mbd.frame_type][x.e_mbd.mode_info_context.mbmi.mode];
                this_rd = (128 + rate2 * x.rdmult) >> 8 + x.rddiv * distortion2;
                if this_rd < best_intra_rd {
                    best_intra_rd = this_rd;
                    returnintra.* = distortion2;
                }
            case cast,no_check(u32) NEWMV;
                {
                    thissme: s32 = ---;

                    further_steps: s32 = ---;
                    n: s32 = 0;
                    sadpb := x.sadperbit16;
                    mvp_full: Int_Mv_in_mv = ---;

                    col_min := ((cast(s32) best_ref_mv.as_mv.col) + 7) >> 3 - ((cast(s32) 1) << 8 - 1);
                    row_min := ((cast(s32) best_ref_mv.as_mv.row) + 7) >> 3 - ((cast(s32) 1) << 8 - 1);
                    col_max := (cast(s32) best_ref_mv.as_mv.col) >> 3 + ((cast(s32) 1) << 8 - 1);
                    row_max := (cast(s32) best_ref_mv.as_mv.row) >> 3 + ((cast(s32) 1) << 8 - 1);

                    tmp_col_min := x.mv_col_min;
                    tmp_col_max := x.mv_col_max;
                    tmp_row_min := x.mv_row_min;
                    tmp_row_max := x.mv_row_max;

                    speed_adjust := (ifx cpi.speed > 5 then (ifx cpi.speed >= 8 then cast(s32) 3 else 2) else 1);

                    step_param := cpi.sf.first_step + speed_adjust;

                    if sf_improved_mv_pred != 0 {
                        if saddone == 0 {
                            vp8_cal_sad(cpi, xd, x, recon_yoffset, near_sadidx.data + 0);
                            saddone = 1;
                        }

                        vp8_mv_pred(
                            cpi,
                            *x.e_mbd,
                            x.e_mbd.mode_info_context,
                            *mvp,
                            cast,no_check(s32) x.e_mbd.mode_info_context.mbmi.ref_frame,
                            cpi.common.ref_frame_sign_bias.data,
                            *sr,
                            near_sadidx.data + 0
                        );

                        sr += speed_adjust;

                        if sr > step_param {
                            step_param = sr;
                        }

                        mvp_full.as_mv.col = cast,no_check(s16) ((cast(s32) mvp.as_mv.col) >> 3);
                        mvp_full.as_mv.row = cast,no_check(s16) ((cast(s32) mvp.as_mv.row) >> 3);
                    } else {
                        mvp.as_int = best_ref_mv.as_int;
                        mvp_full.as_mv.col = cast,no_check(s16) ((cast(s32) best_ref_mv.as_mv.col) >> 3);
                        mvp_full.as_mv.row = cast,no_check(s16) ((cast(s32) best_ref_mv.as_mv.row) >> 3);
                    }

                    if x.mv_col_min < col_min {
                        x.mv_col_min = col_min;
                    }
                    if x.mv_col_max > col_max {
                        x.mv_col_max = col_max;
                    }
                    if x.mv_row_min < row_min {
                        x.mv_row_min = row_min;
                    }
                    if x.mv_row_max > row_max {
                        x.mv_row_max = row_max;
                    }

                    further_steps = ifx cpi.speed >= 8 then 0 else cpi.sf.max_step_search_steps - 1 - step_param;

                    if cpi.sf.search_method == cast,no_check(u32) HEX {
                        bestsme =
                            vp8_hex_search(
                                x,
                                b,
                                d,
                                *mvp_full,
                                *d.bmi.mv,
                                step_param,
                                sadpb,
                                cpi.fn_ptr.data + BLOCK_16X16,
                                x.mvsadcost.data,
                                *best_ref_mv
                            );
                        mode_mv[NEWMV].as_int = d.bmi.mv.as_int;
                    } else {
                        bestsme =
                            cpi.diamond_search_sad(
                                x,
                                b,
                                d,
                                *mvp_full,
                                *d.bmi.mv,
                                step_param,
                                sadpb,
                                *num00,
                                cpi.fn_ptr.data + BLOCK_16X16,
                                x.mvcost.data,
                                *best_ref_mv
                            );
                        mode_mv[NEWMV].as_int = d.bmi.mv.as_int;

                        n = num00;
                        num00 = 0;

                        while n < further_steps {
                            n += 1;

                            if num00 != 0 {
                                num00 -= 1;
                            } else {
                                thissme =
                                    cpi.diamond_search_sad(
                                        x,
                                        b,
                                        d,
                                        *mvp_full,
                                        *d.bmi.mv,
                                        step_param + n,
                                        sadpb,
                                        *num00,
                                        cpi.fn_ptr.data + BLOCK_16X16,
                                        x.mvcost.data,
                                        *best_ref_mv
                                    );
                                if thissme < bestsme {
                                    bestsme = thissme;
                                    mode_mv[NEWMV].as_int = d.bmi.mv.as_int;
                                } else {
                                    d.bmi.mv.as_int = mode_mv[NEWMV].as_int;
                                }
                            }
                        }
                    }

                    x.mv_col_min = tmp_col_min;
                    x.mv_col_max = tmp_col_max;
                    x.mv_row_min = tmp_row_min;
                    x.mv_row_max = tmp_row_max;

                    if bestsme < 2147483647 {
                        cpi.find_fractional_mv_step(
                            x,
                            b,
                            d,
                            *d.bmi.mv,
                            *best_ref_mv,
                            x.errorperbit,
                            cpi.fn_ptr.data + BLOCK_16X16,
                            cpi.mb.mvcost.data,
                            *distortion2,
                            *sse
                        );
                    }

                    mode_mv[NEWMV].as_int = d.bmi.mv.as_int;

                    vp8_clamp_mv2_in_pickinter(*mode_mv[this_mode], xd);

                    rate2 += vp8_mv_bit_cost(*mode_mv[NEWMV], *best_ref_mv, cpi.mb.mvcost.data, 128);
                }
                #through;
            case cast,no_check(u32) NEARESTMV; #through;
            case cast,no_check(u32) NEARMV;
                if mode_mv[this_mode].as_int == 0 {
                    continue;
                }
                #through;
            case cast,no_check(u32) ZEROMV;
                if (cast(s32) mode_mv[this_mode].as_mv.row) >> 3 < x.mv_row_min ||
                    (cast(s32) mode_mv[this_mode].as_mv.row) >> 3 > x.mv_row_max ||
                    (cast(s32) mode_mv[this_mode].as_mv.col) >> 3 < x.mv_col_min ||
                    (cast(s32) mode_mv[this_mode].as_mv.col) >> 3 > x.mv_col_max {
                    continue;
                }
                rate2 +=
                    (cast,no_check(#type (_: MB_PREDICTION_MODE, _: *s32) -> s32) (cast(*void) vp8_cost_mv_ref))(
                        this_mode,
                        mdcounts.data
                    );
                x.e_mbd.mode_info_context.mbmi.mv.as_int = mode_mv[this_mode].as_int;
                this_rd = evaluate_inter_mode(*sse, rate2, *distortion2, cpi, x, rd_adjustment);
            case;
        }

        if cpi.oxcf.noise_sensitivity != 0 {
            skip_old_reference :=
                cast(s32) (this_ref_frame != LAST_FRAME &&
                    cpi.common.current_video_frame - cpi.current_ref_frames[this_ref_frame] > 8);
            if this_mode == cast,no_check(u32) ZEROMV && sse < zero_mv_sse && skip_old_reference == 0 {
                zero_mv_sse = sse;
                x.best_zeromv_reference_frame =
                    cast,no_check(MV_REFERENCE_FRAME_in_alloccommon) x.e_mbd.mode_info_context.mbmi.ref_frame;
            }

            if x.e_mbd.mode_info_context.mbmi.mode == cast,no_check(u8) NEWMV && sse < best_sse && skip_old_reference == 0 {
                best_sse = sse;
                x.best_sse_inter_mode = cast,no_check(MB_PREDICTION_MODE) NEWMV;
                x.best_sse_mv = x.e_mbd.mode_info_context.mbmi.mv;
                x.need_to_clamp_best_mvs = x.e_mbd.mode_info_context.mbmi.need_to_clamp_mvs;
                x.best_reference_frame =
                    cast,no_check(MV_REFERENCE_FRAME_in_alloccommon) x.e_mbd.mode_info_context.mbmi.ref_frame;
            }
        }

        if this_rd < best_rd || x.skip != 0 {
            best_mode_index = mode_index;

            returnrate.* = rate2;
            returndistortion.* = distortion2;
            best_rd_sse = sse;
            best_rd = this_rd;
            copy_memory(*best_mbmode, *x.e_mbd.mode_info_context.mbmi, size_of(MB_MODE_INFO));

            x.rd_thresh_mult[mode_index] =
                ifx x.rd_thresh_mult[mode_index] >= 32 +
                    2 then x.rd_thresh_mult[mode_index] - 2 else 32;
            x.rd_threshes[mode_index] = cpi.rd_baseline_thresh[mode_index] >> 7 * x.rd_thresh_mult[mode_index];
        } else {
            x.rd_thresh_mult[mode_index] += 4;

            if x.rd_thresh_mult[mode_index] > 512 {
                x.rd_thresh_mult[mode_index] = 512;
            }

            x.rd_threshes[mode_index] = cpi.rd_baseline_thresh[mode_index] >> 7 * x.rd_thresh_mult[mode_index];
        }

        if x.skip != 0 {
            break;
        }
    }

    if cpi.rd_baseline_thresh[best_mode_index] > 0 && cpi.rd_baseline_thresh[best_mode_index] < S32_MAX >> 2 {
        best_adjustment := x.rd_thresh_mult[best_mode_index] >> 3;

        x.rd_thresh_mult[best_mode_index] =
            ifx x.rd_thresh_mult[best_mode_index] >= 32 +
                best_adjustment then x.rd_thresh_mult[best_mode_index] - best_adjustment else 32;
        x.rd_threshes[best_mode_index] =
            cpi.rd_baseline_thresh[best_mode_index] >> 7 *
                x.rd_thresh_mult[best_mode_index];
    }

    {
        this_rdbin := returndistortion.* >> 7;

        if this_rdbin >= 1024 {
            this_rdbin = 1023;
        }

        x.error_bins[this_rdbin] += 1;
    }

    if cpi.oxcf.noise_sensitivity != 0 {
        block_index := mb_row * cpi.common.mb_cols + mb_col;
        reevaluate: s32 = 0;
        is_noisy: s32 = 0;
        if x.best_sse_inter_mode == cast,no_check(u32) DC_PRED {
            x.best_sse_inter_mode = cast,no_check(MB_PREDICTION_MODE) best_mbmode.mode;
            x.best_sse_mv = best_mbmode.mv;
            x.need_to_clamp_best_mvs = best_mbmode.need_to_clamp_mvs;
            x.best_reference_frame = cast,no_check(MV_REFERENCE_FRAME_in_alloccommon) best_mbmode.ref_frame;
            best_sse = best_rd_sse;
        }

        if cpi.oxcf.noise_sensitivity == 4 {
            if cpi.denoiser.nmse_source_diff > 70 * cpi.denoiser.threshold_aggressive_mode / 100 {
                is_noisy = 1;
            }
        } else if cpi.mse_source_denoised > 1000 {
            is_noisy = 1;
        }
        x.increase_denoising = 0;
        if x.is_skin == 0 &&
            x.best_sse_inter_mode == cast,no_check(u32) ZEROMV &&
            (x.best_reference_frame == cast,no_check(u32) LAST_FRAME || x.best_reference_frame == cpi.closest_reference_frame) &&
            cpi.consec_zero_last[block_index] >= 20 &&
            is_noisy != 0 {
            x.increase_denoising = 1;
        }
        x.denoise_zeromv = 0;
        vp8_denoiser_denoise_mb(
            *cpi.denoiser,
            x,
            best_sse,
            zero_mv_sse,
            recon_yoffset,
            recon_uvoffset,
            *cpi.common.lf_info,
            mb_row,
            mb_col,
            block_index,
            cast,no_check(s32) cpi.consec_zero_last_mvbias[block_index]
        );

        reevaluate =
            cast(s32) (best_mbmode.ref_frame == cast,no_check(u8) INTRA_FRAME ||
                best_mbmode.mode != cast,no_check(u8) ZEROMV && x.denoise_zeromv != 0 && cpi.mse_source_denoised > 2000);
        if dot_artifact_candidate == 0 && reevaluate != 0 && x.best_zeromv_reference_frame != cast,no_check(u32) INTRA_FRAME {
            this_rd: s32 = 0;
            this_ref_frame := cast,no_check(s32) x.best_zeromv_reference_frame;
            rd_adjustment = 100;
            rate2 =
                x.ref_frame_cost[this_ref_frame] + (cast,no_check(#type (_: MB_PREDICTION_MODE, _: *s32) -> s32) (cast(*void) vp8_cost_mv_ref))(
                    cast,no_check(MB_PREDICTION_MODE) ZEROMV,
                    mdcounts.data
                );
            distortion2 = 0;

            x.e_mbd.mode_info_context.mbmi.ref_frame = cast,no_check(u8) this_ref_frame;
            x.e_mbd.pre.y_buffer = plane[this_ref_frame][0];
            x.e_mbd.pre.u_buffer = plane[this_ref_frame][1];
            x.e_mbd.pre.v_buffer = plane[this_ref_frame][2];

            x.e_mbd.mode_info_context.mbmi.mode = cast,no_check(u8) ZEROMV;
            x.e_mbd.mode_info_context.mbmi.uv_mode = cast,no_check(u8) DC_PRED;
            x.e_mbd.mode_info_context.mbmi.mv.as_int = 0;
            this_rd = evaluate_inter_mode(*sse, rate2, *distortion2, cpi, x, rd_adjustment);

            if this_rd < best_rd {
                copy_memory(*best_mbmode, *x.e_mbd.mode_info_context.mbmi, size_of(MB_MODE_INFO));
            }
        }
    }

    if cpi.is_src_frame_alt_ref != 0 &&
        (best_mbmode.mode != cast,no_check(u8) ZEROMV || best_mbmode.ref_frame != cast,no_check(u8) ALTREF_FRAME) {
        x.e_mbd.mode_info_context.mbmi.mode = cast,no_check(u8) ZEROMV;
        x.e_mbd.mode_info_context.mbmi.ref_frame = cast,no_check(u8) ALTREF_FRAME;
        x.e_mbd.mode_info_context.mbmi.mv.as_int = 0;
        x.e_mbd.mode_info_context.mbmi.uv_mode = cast,no_check(u8) DC_PRED;
        x.e_mbd.mode_info_context.mbmi.mb_skip_coeff = cast,no_check(u8) cpi.common.mb_no_coeff_skip;
        x.e_mbd.mode_info_context.mbmi.partitioning = 0;

        return;
    }

    if x.skip == 0 {
        copy_memory(*x.e_mbd.mode_info_context.mbmi, *best_mbmode, size_of(MB_MODE_INFO));
    }

    if best_mbmode.mode <= cast,no_check(u8) B_PRED {
        pick_intra_mbuv_mode(x);
    }

    if sign_bias != cpi.common.ref_frame_sign_bias[xd.mode_info_context.mbmi.ref_frame] {
        best_ref_mv.as_int = best_ref_mv_sb[cast(s32) (sign_bias == 0)].as_int;
    }

    update_mvcount(x, *best_ref_mv);
}

update_mvcount :: (x: *MACROBLOCK_in_block, best_ref_mv: *Int_Mv_in_mv) {
    xd := *x.e_mbd;

    if xd.mode_info_context.mbmi.mode == cast,no_check(u8) NEWMV {
        ROW_VAL := ((cast(s32) xd.mode_info_context.mbmi.mv.as_mv.row) - cast(s32) best_ref_mv.as_mv.row) >> 1;
        ROW_IDX := (cast,no_check(s32) (MV_MAX)) + ROW_VAL;
        COL_VAL := ((cast(s32) xd.mode_info_context.mbmi.mv.as_mv.col) - cast(s32) best_ref_mv.as_mv.col) >> 1;
        COL_IDX := (cast,no_check(s32) (MV_MAX)) + COL_VAL;
        if ROW_IDX >= 0 && ROW_IDX < M_VVALS && COL_IDX >= 0 && COL_IDX < M_VVALS {
            x.m_vcount[0][ROW_IDX] += 1;
            x.m_vcount[1][COL_IDX] += 1;
        }
    }
}

pick_intra_mbuv_mode :: (mb: *MACROBLOCK_in_block) {
    x := *mb.e_mbd;
    uabove_row: *u8 = x.dst.u_buffer - x.dst.uv_stride;
    vabove_row: *u8 = x.dst.v_buffer - x.dst.uv_stride;
    usrc_ptr := mb.block[16].src + mb.block[16].base_src.*;
    vsrc_ptr := mb.block[20].src + mb.block[20].base_src.*;
    uvsrc_stride := mb.block[16].src_stride;
    uleft_col: [8] u8 = ---;
    vleft_col: [8] u8 = ---;
    utop_left := uabove_row[-1];
    vtop_left := vabove_row[-1];
    j: s32 = ---;
    expected_udc: s32 = ---;
    expected_vdc: s32 = ---;
    shift: s32 = ---;
    uaverage: s32 = 0;
    vaverage: s32 = 0;
    diff: s32 = ---;
    pred_error: [4] s32;
    best_error: s32 = 2147483647;
    best_mode := cast,no_check(MB_PREDICTION_MODE) MB_MODE_COUNT;

    i: s32 = 0;
    while i < 8 {
        uleft_col[i] = x.dst.u_buffer[i * x.dst.uv_stride - 1];
        vleft_col[i] = x.dst.v_buffer[i * x.dst.uv_stride - 1];
        i += 1;
    }

    if x.up_available == 0 && x.left_available == 0 {
        expected_udc = 128;
        expected_vdc = 128;
    } else {
        shift = 2;

        if x.up_available != 0 {
            i = 0;
            while i < 8 {
                uaverage += cast,no_check(s32) uabove_row[i];
                vaverage += cast,no_check(s32) vabove_row[i];
                i += 1;
            }

            shift += 1;
        }

        if x.left_available != 0 {
            i = 0;
            while i < 8 {
                uaverage += cast,no_check(s32) uleft_col[i];
                vaverage += cast,no_check(s32) vleft_col[i];
                i += 1;
            }

            shift += 1;
        }

        expected_udc = (uaverage + (cast(s32) 1) << (((shift - 1)) & 31)) >> ((shift) & 31);
        expected_vdc = (vaverage + (cast(s32) 1) << (((shift - 1)) & 31)) >> ((shift) & 31);
    }

    i = 0;
    while i < 8 {
        j = 0;
        while j < 8 {
            predu := ((cast(s32) uleft_col[i]) + cast(s32) uabove_row[j]) - cast(s32) utop_left;
            predv := ((cast(s32) vleft_col[i]) + cast(s32) vabove_row[j]) - cast(s32) vtop_left;
            u_p: s32 = ---;

            u_p = cast,no_check(s32) usrc_ptr[j];
            v_p := cast,no_check(s32) vsrc_ptr[j];

            if predu < 0 {
                predu = 0;
            }

            if predu > 255 {
                predu = 255;
            }

            if predv < 0 {
                predv = 0;
            }

            if predv > 255 {
                predv = 255;
            }

            diff = u_p - expected_udc;
            pred_error[DC_PRED] += diff * diff;
            diff = v_p - expected_vdc;
            pred_error[DC_PRED] += diff * diff;

            diff = u_p - cast(s32) uabove_row[j];
            pred_error[V_PRED] += diff * diff;
            diff = v_p - cast(s32) vabove_row[j];
            pred_error[V_PRED] += diff * diff;

            diff = u_p - cast(s32) uleft_col[i];
            pred_error[H_PRED] += diff * diff;
            diff = v_p - cast(s32) vleft_col[i];
            pred_error[H_PRED] += diff * diff;

            diff = u_p - predu;
            pred_error[TM_PRED] += diff * diff;
            diff = v_p - predv;
            pred_error[TM_PRED] += diff * diff;
            j += 1;
        }

        usrc_ptr += uvsrc_stride;
        vsrc_ptr += uvsrc_stride;

        if i == 3 {
            usrc_ptr = mb.block[18].src + mb.block[18].base_src.*;
            vsrc_ptr = mb.block[22].src + mb.block[22].base_src.*;
        }
        i += 1;
    }

    i = cast,no_check(s32) (DC_PRED);
    while i <= TM_PRED {
        if best_error > pred_error[i] {
            best_error = pred_error[i];
            best_mode = cast,no_check(MB_PREDICTION_MODE) i;
        }
        i += 1;
    }

    mb.e_mbd.mode_info_context.mbmi.uv_mode = cast,no_check(u8) best_mode;
}

evaluate_inter_mode :: (
    sse: *u32,
    rate2: s32,
    distortion2: *s32,
    cpi: *VP8_COMP,
    x: *MACROBLOCK_in_block,
    rd_adj: s32
) -> s32 {
    this_mode := cast,no_check(MB_PREDICTION_MODE) x.e_mbd.mode_info_context.mbmi.mode;
    mv := x.e_mbd.mode_info_context.mbmi.mv;

    denoise_aggressive: s32 = 0;

    if cpi.active_map_enabled != 0 && x.active_ptr[0] == 0 {
        sse.* = 0;
        distortion2.* = 0;
        x.skip = 1;
        return 2147483647;
    }

    if this_mode != cast,no_check(u32) NEWMV || cpi.sf.half_pixel_search == 0 || cpi.common.full_pixel == 1 {
        distortion2.* = vp8_get_inter_mbpred_error(x, cpi.fn_ptr.data + BLOCK_16X16, sse, mv);
    }

    this_rd := (128 + rate2 * x.rdmult) >> 8 + x.rddiv * distortion2.*;

    if cpi.oxcf.noise_sensitivity > 0 {
        denoise_aggressive = cast(s32) (cpi.denoiser.denoiser_mode == K_DENOISER_ON_YUV_AGGRESSIVE);
    }

    if cpi.oxcf.screen_content_mode == 0 &&
        this_mode == cast,no_check(u32) ZEROMV &&
        x.e_mbd.mode_info_context.mbmi.ref_frame == cast,no_check(u8) LAST_FRAME &&
        (denoise_aggressive != 0 || cpi.closest_reference_frame == cast,no_check(u32) LAST_FRAME) {
        if x.is_skin != 0 {
            rd_adj = 100;
        }

        this_rd = cast,no_check(s32) (((cast,no_check(s64) this_rd) * cast(s64) rd_adj) / 100);
    }

    check_for_encode_breakout(sse.*, x);
    return this_rd;
}

check_for_encode_breakout :: (sse: u32, x: *MACROBLOCK_in_block) {
    xd := *x.e_mbd;

    threshold := cast,no_check(u32) (((cast(s32) xd.block[0].dequant[1]) * cast(s32) xd.block[0].dequant[1]) >> 4);

    if threshold < x.encode_breakout {
        threshold = x.encode_breakout;
    }

    if sse < threshold {
        sse2: u32 = 0;

        sse2 = cast,no_check(u32) vp8_uvsse(x);

        if (sse2 * 2) < x.encode_breakout {
            x.skip = 1;
        } else {
            x.skip = 0;
        }
    }
}

vp8_get_inter_mbpred_error :: (
    mb: *MACROBLOCK_in_block,
    vfp: *Vp8_Variance_Fn_Ptr_T,
    sse: *u32,
    this_mv: Int_Mv_in_mv
) -> s32 {
    b := mb.block.data + 0;
    d := mb.e_mbd.block.data + 0;
    what := b.base_src.* + b.src;
    what_stride := b.src_stride;
    pre_stride := mb.e_mbd.pre.y_stride;
    in_what: *u8 = mb.e_mbd.pre.y_buffer + d.offset;
    in_what_stride := pre_stride;
    xoffset := (cast(s32) this_mv.as_mv.col) & 7;
    yoffset := (cast(s32) this_mv.as_mv.row) & 7;

    in_what += (cast(s32) this_mv.as_mv.row) >> 3 * pre_stride + (cast(s32) this_mv.as_mv.col) >> 3;

    if xoffset | yoffset != 0 {
        return cast,no_check(s32) vfp.svf(in_what, in_what_stride, xoffset, yoffset, what, what_stride, sse);
    } else {
        return cast,no_check(s32) vfp.vf(what, what_stride, in_what, in_what_stride, sse);
    }
}

pick_intra4x4mby_modes :: (mb: *MACROBLOCK_in_block, rate: *s32, best_dist: *s32) -> s32 {
    XD := *mb.e_mbd;

    cost := mb.mbmode_cost[XD.frame_type][B_PRED];
    error: s32 = ---;
    distortion: s32 = 0;

    intra_prediction_down_copy_in_pickinter(XD, XD.dst.y_buffer - XD.dst.y_stride + 16);

    bmode_costs := mb.inter_bmode_costs;

    i: s32 = 0;
    while i < 16 {
        MIC := XD.mode_info_context;
        MIS := XD.mode_info_stride;

        best_mode := cast,no_check(B_PREDICTION_MODE) B_MODE_COUNT;
        r: s32 = 0;
        d: s32 = 0;

        if mb.e_mbd.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
            A := above_block_mode_in_pickinter(MIC, i, MIS);
            L := left_block_mode_in_pickinter(MIC, i);

            bmode_costs = mb.bmode_costs[A][L].data;
        }

        pick_intra4x4block(mb, i, *best_mode, bmode_costs, *r, *d);

        cost += r;
        distortion += d;

        MIC.bmi[i].as_mode = best_mode;

        if distortion > best_dist.* {
            break;
        }
        i += 1;
    }

    rate.* = cost;

    if i == 16 {
        best_dist.* = distortion;
        error = (128 + cost * mb.rdmult) >> 8 + mb.rddiv * distortion;
    } else {
        best_dist.* = 2147483647;
        error = 2147483647;
    }

    return error;
}

pick_intra4x4block :: (
    x: *MACROBLOCK_in_block,
    ib: s32,
    best_mode: *B_PREDICTION_MODE,
    mode_costs: *s32,
    bestrate: *s32,
    bestdistortion: *s32
) -> s32 {
    b := x.e_mbd.block.data + ib;
    be := x.block.data + ib;
    dst_stride := x.e_mbd.dst.y_stride;
    dst: *u8 = x.e_mbd.dst.y_buffer + b.offset;

    best_rd: s32 = 2147483647;

    above := dst - dst_stride;
    yleft := dst - 1;
    top_left := above[-1];

    mode := cast,no_check(B_PREDICTION_MODE) B_DC_PRED;
    while mode <= cast,no_check(u32) B_HE_PRED {
        rate := mode_costs[mode];

        vp8_intra4x4_predict(above, yleft, dst_stride, mode, b.predictor, 16, top_left);
        distortion := get_prediction_error(be, b);
        this_rd := (128 + rate * x.rdmult) >> 8 + x.rddiv * distortion;

        if this_rd < best_rd {
            bestrate.* = rate;
            bestdistortion.* = distortion;
            best_rd = this_rd;
            best_mode.* = mode;
        }
        mode += 1;
    }

    b.bmi.as_mode = best_mode.*;
    vp8_encode_intra4x4block(x, ib);
    return best_rd;
}

get_prediction_error :: (be: *BLOCK, b: *BLOCKD) -> s32 {
    sptr := be.base_src.* + be.src;
    dptr := b.predictor;

    return cast,no_check(s32) get4x4sse_cs_c(sptr, be.src_stride, dptr, 16);
}

intra_prediction_down_copy_in_pickinter :: (xd: *MACROBLOCKD_in_blockd, above_right_src: *u8) {
    dst_stride := xd.dst.y_stride;
    above_right_dst: *u8 = xd.dst.y_buffer - dst_stride + 16;

    src_ptr := cast(*u32) above_right_src;
    dst_ptr0 := cast(*u32) (above_right_dst + 4 * dst_stride);
    dst_ptr1 := cast(*u32) (above_right_dst + 8 * dst_stride);
    dst_ptr2 := cast(*u32) (above_right_dst + 12 * dst_stride);

    dst_ptr0.* = src_ptr.*;
    dst_ptr1.* = src_ptr.*;
    dst_ptr2.* = src_ptr.*;
}

calculate_zeromv_rd_adjustment :: (cpi: *VP8_COMP, x: *MACROBLOCK_in_block, rd_adjustment: *s32) {
    mic := x.e_mbd.mode_info_context;
    mv_l, mv_a, mv_al: Int_Mv_in_mv = ---;
    local_motion_check: s32 = 0;

    if cpi.lf_zeromv_pct > 40 {
        mic -= 1;
        mv_l = mic.mbmi.mv;

        if mic.mbmi.ref_frame != cast,no_check(u8) INTRA_FRAME {
            if absolute_value(cast,no_check(s32) mv_l.as_mv.row) < 8 && absolute_value(cast,no_check(s32) mv_l.as_mv.col) < 8 {
                local_motion_check += 1;
            }
        }

        mic -= x.e_mbd.mode_info_stride;
        mv_al = mic.mbmi.mv;

        if mic.mbmi.ref_frame != cast,no_check(u8) INTRA_FRAME {
            if absolute_value(cast,no_check(s32) mv_al.as_mv.row) < 8 && absolute_value(cast,no_check(s32) mv_al.as_mv.col) < 8 {
                local_motion_check += 1;
            }
        }

        mic += 1;
        mv_a = mic.mbmi.mv;

        if mic.mbmi.ref_frame != cast,no_check(u8) INTRA_FRAME {
            if absolute_value(cast,no_check(s32) mv_a.as_mv.row) < 8 && absolute_value(cast,no_check(s32) mv_a.as_mv.col) < 8 {
                local_motion_check += 1;
            }
        }

        if (x.e_mbd.mb_to_top_edge == 0 || x.e_mbd.mb_to_left_edge == 0) && local_motion_check > 0 || local_motion_check > 2 {
            rd_adjustment.* = 80;
        } else if local_motion_check > 0 {
            rd_adjustment.* = 90;
        }
    }
}

get_reference_search_order_in_pickinter :: (cpi: *VP8_COMP, ref_frame_map: *s32) {
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

check_dot_artifact_candidate :: (
    cpi: *VP8_COMP,
    x: *MACROBLOCK_in_block,
    target_last: *u8,
    stride: s32,
    last_ref: *u8,
    mb_row: s32,
    mb_col: s32,
    channel: s32
) -> s32 {
    threshold1: s32 = 6;
    threshold2: s32 = 3;
    max_num := cast,no_check(u32) (cpi.common.m_bs / 10);
    grad_last: s32 = 0;
    grad_source: s32 = 0;
    index := mb_row * cpi.common.mb_cols + mb_col;

    num_frames: s32 = 30;
    shift: s32 = 15;
    if channel > 0 {
        shift = 7;
    }
    if cpi.oxcf.number_of_layers > 1 {
        num_frames = 20;
    }
    x.zero_last_dot_suppress = 0;

    if cpi.current_layer == 0 &&
        cast,no_check(s32) cpi.consec_zero_last_mvbias[index] > num_frames &&
        x.mbs_zero_last_dot_suppress < max_num &&
        cpi.oxcf.screen_content_mode == 0 {
        x.zero_last_dot_suppress = 1;

        grad_last = macroblock_corner_grad(last_ref, stride, 0, 0, 1, 1);
        grad_source = macroblock_corner_grad(target_last, stride, 0, 0, 1, 1);
        if grad_last >= threshold1 && grad_source <= threshold2 {
            x.mbs_zero_last_dot_suppress += 1;
            return 1;
        }

        grad_last = macroblock_corner_grad(last_ref, stride, 0, shift, 1, -1);
        grad_source = macroblock_corner_grad(target_last, stride, 0, shift, 1, -1);
        if grad_last >= threshold1 && grad_source <= threshold2 {
            x.mbs_zero_last_dot_suppress += 1;
            return 1;
        }

        grad_last = macroblock_corner_grad(last_ref, stride, shift, 0, -1, 1);
        grad_source = macroblock_corner_grad(target_last, stride, shift, 0, -1, 1);
        if grad_last >= threshold1 && grad_source <= threshold2 {
            x.mbs_zero_last_dot_suppress += 1;
            return 1;
        }

        grad_last = macroblock_corner_grad(last_ref, stride, shift, shift, -1, -1);
        grad_source = macroblock_corner_grad(target_last, stride, shift, shift, -1, -1);
        if grad_last >= threshold1 && grad_source <= threshold2 {
            x.mbs_zero_last_dot_suppress += 1;
            return 1;
        }
        return 0;
    }
    return 0;
}

macroblock_corner_grad :: (signal: *u8, stride: s32, offsetx: s32, offsety: s32, sgnx: s32, sgny: s32) -> s32 {
    y1 := cast,no_check(s32) signal[offsetx * stride + offsety];
    y2 := cast,no_check(s32) signal[offsetx * stride + offsety + sgny];
    y3 := cast,no_check(s32) signal[(offsetx + sgnx) * stride + offsety];
    y4 := cast,no_check(s32) signal[(offsetx + sgnx) * stride + offsety + sgny];
    return ifx (ifx absolute_value(y1 - y2) > absolute_value(y1 - y3) then absolute_value(y1 - y2) else absolute_value(y1 - y3)) > absolute_value(y1 - y4) then (ifx absolute_value(y1 - y2) > absolute_value(y1 - y3) then absolute_value(y1 - y2) else absolute_value(y1 - y3)) else absolute_value(y1 - y4);
}

get_predictor_pointers_in_pickinter :: (cpi: *VP8_COMP, plane: *[3] *u8, recon_yoffset: u32, recon_uvoffset: u32) {
    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_LAST_FRAME) != 0 {
        get_plane_pointers_in_pickinter(
            cpi.common.yv12_fb.data + cpi.common.lst_fb_idx,
            plane[LAST_FRAME].data,
            recon_yoffset,
            recon_uvoffset
        );
    }

    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_GOLD_FRAME) != 0 {
        get_plane_pointers_in_pickinter(
            cpi.common.yv12_fb.data + cpi.common.gld_fb_idx,
            plane[GOLDEN_FRAME].data,
            recon_yoffset,
            recon_uvoffset
        );
    }

    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_ALTR_FRAME) != 0 {
        get_plane_pointers_in_pickinter(
            cpi.common.yv12_fb.data + cpi.common.alt_fb_idx,
            plane[ALTREF_FRAME].data,
            recon_yoffset,
            recon_uvoffset
        );
    }
}

get_plane_pointers_in_pickinter :: (fb: *YV12_BUFFER_CONFIG, plane: **u8, recon_yoffset: u32, recon_uvoffset: u32) {
    plane[0] = fb.y_buffer + recon_yoffset;
    plane[1] = fb.u_buffer + recon_uvoffset;
    plane[2] = fb.v_buffer + recon_uvoffset;
}

vp8_pick_intra_mode :: (x: *MACROBLOCK_in_block, rate: *s32) {
    error16x16: s32 = 2147483647;
    rate_value: s32 = ---;
    best_rate: s32 = 0;
    best_sse: s32 = ---;
    best_mode := cast,no_check(MB_PREDICTION_MODE) DC_PRED;

    sse: u32 = ---;
    b := x.block.data + 0;
    xd := *x.e_mbd;

    xd.mode_info_context.mbmi.ref_frame = cast,no_check(u8) INTRA_FRAME;

    pick_intra_mbuv_mode(x);

    mode := cast,no_check(MB_PREDICTION_MODE) DC_PRED;
    while mode <= cast,no_check(u32) TM_PRED {
        xd.mode_info_context.mbmi.mode = cast,no_check(u8) mode;
        vp8_build_intra_predictors_mby_s(
            xd,
            xd.dst.y_buffer - xd.dst.y_stride,
            xd.dst.y_buffer - 1,
            xd.dst.y_stride,
            xd.predictor.data,
            16
        );
        distortion := cast,no_check(s32) variance16x16_c(b.base_src.*, b.src_stride, xd.predictor.data, 16, *sse);
        rate_value = x.mbmode_cost[xd.frame_type][mode];
        this_rd := (128 + rate_value * x.rdmult) >> 8 + x.rddiv * distortion;

        if error16x16 > this_rd {
            error16x16 = this_rd;
            best_mode = mode;
            best_sse = cast,no_check(s32) sse;
            best_rate = rate_value;
        }
        mode += 1;
    }
    xd.mode_info_context.mbmi.mode = cast,no_check(u8) best_mode;

    error4x4 := pick_intra4x4mby_modes(x, *rate_value, *best_sse);
    if error4x4 < error16x16 {
        xd.mode_info_context.mbmi.mode = cast,no_check(u8) B_PRED;
        best_rate = rate_value;
    }

    rate.* = best_rate;
}

insertsortmv_in_pickinter :: (arr: *s32, len: s32) {
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

insertsortsad_in_pickinter :: (arr: *s32, idx: *s32, len: s32) {
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

