vp8_set_reference_value_in_encodemv :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_encodemv :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_encodemv :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_encodemv :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_encodemv :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_encodemv :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_encodemv :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_encodemv :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_encodemv :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_encodemv :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_encodemv :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_encodemv :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_encodemv :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_encodemv :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_encodemv :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_encodemv :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_encodemv :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_encodemv :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_encodemv :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_encodemv :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_encodemv :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_encodemv :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_encodemv :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_encodemv :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_encodemv :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_encodemv :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

scale2_ratio_in_encodemv :: (mode: s32, hr: *s32, hs: *s32) {
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

validate_buffer_in_encodemv :: (start: *u8, len: u64, end: *u8, error: *Internal_Error_Info) -> s32 {
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

vp8_encode_bool_in_encodemv :: (bc: *BOOL_CODER, bit: s32, probability: s32) {
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

        validate_buffer_in_encodemv(bc.buffer + bc.pos, 1, bc.buffer_end, bc.error);
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

vp8_cost_branch_in_encodemv :: (ct: *u32, p: Vp8_Prob) -> u32 {
    return cast,no_check(u32) ((((cast,no_check(u64) ct[0]) * cast(u64) VP8_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP8_PROB_COST[255 - cast(s32) p]) >> 8);
}

vp8_treed_write_in_encodemv :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) {
    i: Vp8_Tree_Index = 0;

    while true {
        {
            B := v >> ((c_transpiler_pre_decrement(*(n))) & 31) & 1;
            vp8_encode_bool_in_encodemv(W, B, cast,no_check(s32) P[(cast(s32) i) >> 1]);
            i = t[(cast(s32) i) + B];
        }
        if n == 0 break;
    }
}

vp8_write_token_in_encodemv :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) {
    vp8_treed_write_in_encodemv(W, t, P, X.value, X.len);
}

vp8_treed_cost_in_encodemv :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) -> s32 {
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

vp8_cost_token_in_encodemv :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) -> s32 {
    return vp8_treed_cost_in_encodemv(t, P, X.value, X.len);
}

vp8_sem_wait_in_encodemv :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_0: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_0; assignment_0; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init_in_encodemv :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release_in_encodemv :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

atomic_load_acquire_in_encodemv :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_atomic_spin_wait_in_encodemv :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire_in_encodemv(last_row_current_mb_col) - NSYNC {
    }
}

mv_bias_in_encodemv :: (refmb_ref_frame_sign_bias: s32, refframe: s32, mvp: *Int_Mv_in_mv, ref_frame_sign_bias: *s32) {
    if refmb_ref_frame_sign_bias != ref_frame_sign_bias[refframe] {
        mvp.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.row) * -1);
        mvp.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.col) * -1);
    }
}

vp8_clamp_mv2_in_encodemv :: (mv: *Int_Mv_in_mv, xd: *MACROBLOCKD_in_blockd) {
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

vp8_clamp_mv_in_encodemv :: (
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

vp8_check_mv_bounds_in_encodemv :: (
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

left_block_mv_in_encodemv :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> u32 {
    if b & 3 == 0 {
        cur_mb -= 1;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 4;
    }

    return (((cur_mb.bmi.data + b - 1)).mv).as_int;
}

above_block_mv_in_encodemv :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> u32 {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 16;
    }

    return (((cur_mb.bmi.data + (b - 4))).mv).as_int;
}

left_block_mode_in_encodemv :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> B_PREDICTION_MODE {
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

above_block_mode_in_encodemv :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> B_PREDICTION_MODE {
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

vp8_write_mvprobs :: (cpi: *VP8_COMP) {
    W := cpi.bc.data;
    mvc := cpi.common.fc.mvc.data;
    flags: [2] s32;
    write_component_probs(
        W,
        *mvc[0],
        VP8_DEFAULT_MV_CONTEXT.data + 0,
        VP8_MV_UPDATE_PROBS.data + 0,
        cpi.mb.m_vcount[0].data,
        0,
        flags.data + 0
    );
    write_component_probs(
        W,
        *mvc[1],
        VP8_DEFAULT_MV_CONTEXT.data + 1,
        VP8_MV_UPDATE_PROBS.data + 1,
        cpi.mb.m_vcount[1].data,
        1,
        flags.data + 1
    );

    if flags[0] != 0 || flags[1] != 0 {
        vp8_build_component_cost_table(cpi.mb.mvcost.data, cpi.common.fc.mvc.data, flags.data);
    }
}

vp8_build_component_cost_table :: (mvcost: **s32, mvc: *MV_CONTEXT, mvc_flag: *s32) {
    i: s32 = 1;
    cost0: u32 = 0;
    cost1: u32 = 0;

    i = 1;

    if mvc_flag[0] != 0 {
        mvcost[0][0] = cast,no_check(s32) cost_mvcomponent(0, *mvc[0]);

        while true {
            cost0 = cost_mvcomponent(i, *mvc[0]);

            mvcost[0][i] = cast,no_check(s32) (cost0 + VP8_PROB_COST[mvc[0].prob[MV_PSIGN]]);
            mvcost[0][-i] = cast,no_check(s32) (cost0 + VP8_PROB_COST[255 - cast(s32) mvc[0].prob[MV_PSIGN]]);
            if !(c_transpiler_pre_increment(*(i)) <= MV_MAX) break;
        }
    }

    i = 1;

    if mvc_flag[1] != 0 {
        mvcost[1][0] = cast,no_check(s32) cost_mvcomponent(0, *mvc[1]);

        while true {
            cost1 = cost_mvcomponent(i, *mvc[1]);

            mvcost[1][i] = cast,no_check(s32) (cost1 + VP8_PROB_COST[mvc[1].prob[MV_PSIGN]]);
            mvcost[1][-i] = cast,no_check(s32) (cost1 + VP8_PROB_COST[255 - cast(s32) mvc[1].prob[MV_PSIGN]]);
            if !(c_transpiler_pre_increment(*(i)) <= MV_MAX) break;
        }
    }
}

cost_mvcomponent :: (V: s32, mvc: *Mv_Context) -> u32 {
    p := mvc.prob.data;
    X := V;
    cost: u32 = ---;

    if X < MVNUM_SHORT {
        cost =
            VP8_PROB_COST[p[MVPIS_SHORT]] +
                cast,no_check(u32) vp8_treed_cost_in_encodemv(cast(*Vp8_Tree_Index) *(VP8_SMALL_MVTREE), p + MV_PSHORT, X, 3);

        if X == 0 {
            return cost;
        }
    } else {
        i: s32 = 0;
        cost = VP8_PROB_COST[255 - cast(s32) p[MVPIS_SHORT]];

        while true {
            cost +=
                VP8_PROB_COST[(ifx X >> ((i) & 31) & 1 != 0 then 255 -
                    cast(s32) p[(cast,no_check(s32) (MV_PBITS)) + i] else cast,no_check(s32) p[(cast,no_check(s32) (MV_PBITS)) + i])];
            if !(c_transpiler_pre_increment(*(i)) < 3) break;
        }

        i = (cast,no_check(s32) (MVLONG_WIDTH)) - 1;

        while true {
            cost +=
                VP8_PROB_COST[(ifx X >> ((i) & 31) & 1 != 0 then 255 -
                    cast(s32) p[(cast,no_check(s32) (MV_PBITS)) + i] else cast,no_check(s32) p[(cast,no_check(s32) (MV_PBITS)) + i])];
            if !(c_transpiler_pre_decrement(*(i)) > 3) break;
        }

        if X & 0xfff0 != 0 {
            cost +=
                VP8_PROB_COST[(ifx X >> 3 & 1 != 0 then 255 -
                    cast(s32) p[(cast,no_check(s32) (MV_PBITS)) + 3] else cast,no_check(s32) p[(cast,no_check(s32) (MV_PBITS)) + 3])];
        }
    }

    return cost;
}

write_component_probs :: (
    W: *Vp8_Writer_in_treewriter,
    cur_mvc: *Mv_Context,
    default_mvc_mv_context: *Mv_Context,
    update_mvc: *Mv_Context,
    events: *u32,
    rc: u32,
    updated: *s32
) {
    pcur := cur_mvc.prob.data;
    default_mvc := default_mvc_mv_context.prob.data;
    pupdate := update_mvc.prob.data;
    is_short_ct, sign_ct: [2] u32 = ---;

    bit_ct: [10] [2] u32 = ---;

    short_ct: [8] u32 = ---;
    short_bct: [7] [2] u32 = ---;

    pnew: [19] Vp8_Prob = ---;

    {
        #assert cast(u64) size_of(Vp8_Prob) == cast(u64) size_of(Vp8_Prob);

        copy_memory(pnew.data, default_mvc, cast,no_check(u64) MV_PCOUNT);
    }

    fill_memory(*is_short_ct, 0, is_short_ct.count * size_of(u32));
    fill_memory(*sign_ct, 0, sign_ct.count * size_of(u32));
    fill_memory(*bit_ct, 0, bit_ct.count * size_of([2] u32));
    fill_memory(*short_ct, 0, short_ct.count * size_of(u32));
    fill_memory(*short_bct, 0, short_bct.count * size_of([2] u32));

    {
        C := cast,no_check(s32) events[MV_MAX];

        is_short_ct[0] += cast,no_check(u32) C;
        short_ct[0] += cast,no_check(u32) C;
    }

    {
        j: s32 = 1;

        while true {
            {
                C1 := cast,no_check(s32) events[(cast,no_check(s32) (MV_MAX)) + j];
                C2 := cast,no_check(s32) events[(cast,no_check(s32) (MV_MAX)) - j];
                C := C1 + C2;
                a := j;

                sign_ct[0] += cast,no_check(u32) C1;
                sign_ct[1] += cast,no_check(u32) C2;

                if a < MVNUM_SHORT {
                    is_short_ct[0] += cast,no_check(u32) C;
                    short_ct[a] += cast,no_check(u32) C;
                } else {
                    k := (cast,no_check(s32) (MVLONG_WIDTH)) - 1;
                    is_short_ct[1] += cast,no_check(u32) C;

                    while true {
                        bit_ct[k][a >> ((k) & 31) & 1] += cast,no_check(u32) C;
                        if !(c_transpiler_pre_decrement(*(k)) >= 0) break;
                    }
                }
            }
            if !(c_transpiler_pre_increment(*(j)) <= MV_MAX) break;
        }
    }

    calc_prob(pnew.data + MVPIS_SHORT, is_short_ct.data);

    calc_prob(pnew.data + MV_PSIGN, sign_ct.data);

    {
        p: [7] Vp8_Prob = ---;
        j: s32 = 0;

        vp8_tree_probs_from_distribution(
            8,
            VP8_SMALL_MVENCODINGS.data,
            cast(*Vp8_Tree_Index) *(VP8_SMALL_MVTREE),
            p.data,
            short_bct.data,
            short_ct.data,
            256,
            1
        );

        while true {
            calc_prob(pnew.data + MV_PSHORT + j, short_bct[j].data);
            if !(c_transpiler_pre_increment(*(j)) < (cast,no_check(s32) (MVNUM_SHORT)) - 1) break;
        }
    }

    {
        j: s32 = 0;

        while true {
            calc_prob(pnew.data + MV_PBITS + j, bit_ct[j].data);
            if !(c_transpiler_pre_increment(*(j)) < MVLONG_WIDTH) break;
        }
    }

    update(
        W,
        is_short_ct.data,
        pcur + MVPIS_SHORT,
        pnew[MVPIS_SHORT],
        (c_transpiler_post_increment(*(pupdate))).*,
        updated
    );

    update(W, sign_ct.data, pcur + MV_PSIGN, pnew[MV_PSIGN], (c_transpiler_post_increment(*(pupdate))).*, updated);

    {
        NEW_P := pnew.data + MV_PSHORT;
        CUR_P := pcur + MV_PSHORT;

        j: s32 = 0;

        while true {
            update(W, short_bct[j].data, CUR_P + j, NEW_P[j], (c_transpiler_post_increment(*(pupdate))).*, updated);
            if !(c_transpiler_pre_increment(*(j)) < (cast,no_check(s32) (MVNUM_SHORT)) - 1) break;
        }
    }

    {
        NEW_P := pnew.data + MV_PBITS;
        CUR_P := pcur + MV_PBITS;

        j: s32 = 0;

        while true {
            update(W, bit_ct[j].data, CUR_P + j, NEW_P[j], (c_transpiler_post_increment(*(pupdate))).*, updated);
            if !(c_transpiler_pre_increment(*(j)) < MVLONG_WIDTH) break;
        }
    }
}

update :: (
    W: *Vp8_Writer_in_treewriter,
    ct: *u32,
    CUR_P: *Vp8_Prob,
    NEW_P: Vp8_Prob,
    UPDATE_P: Vp8_Prob,
    updated: *s32
) {
    CUR_B := cast,no_check(s32) vp8_cost_branch_in_encodemv(ct, CUR_P.*);
    NEW_B := cast,no_check(s32) vp8_cost_branch_in_encodemv(ct, NEW_P);
    COST :=
        cast,no_check(s32) ((cast,no_check(u32) (7 + -1)) +
            ((VP8_PROB_COST[255 - cast(s32) UPDATE_P] - VP8_PROB_COST[UPDATE_P]) + 128) >> 8);

    if CUR_B - NEW_B > COST {
        CUR_P.* = NEW_P;
        vp8_encode_bool_in_encodemv(W, 1, cast,no_check(s32) UPDATE_P);
        (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(
            W,
            (cast(s32) NEW_P) >> 1,
            7
        );
        updated.* = 1;
    } else {
        vp8_encode_bool_in_encodemv(W, 0, cast,no_check(s32) UPDATE_P);
    }
}

calc_prob :: (p: *Vp8_Prob, ct: *u32) {
    TOT := ct[0] + ct[1];

    if TOT != 0 {
        X := cast,no_check(Vp8_Prob) (((ct[0] * 255) / TOT) & ~(cast(u32) 1));
        p.* = cast,no_check(Vp8_Prob) ((ifx X != 0 then cast,no_check(s32) X else 1));
    }
}

vp8_encode_motion_vector :: (w: *Vp8_Writer_in_treewriter, mv: *MV_in_alloccommon, mvc: *MV_CONTEXT) {
    encode_mvcomponent(w, (cast(s32) mv.row) >> 1, *mvc[0]);
    encode_mvcomponent(w, (cast(s32) mv.col) >> 1, *mvc[1]);
}

encode_mvcomponent :: (W: *Vp8_Writer_in_treewriter, V: s32, mvc: *Mv_Context) {
    p := mvc.prob.data;
    X := (ifx V < 0 then -V else V);

    if X < MVNUM_SHORT {
        vp8_encode_bool_in_encodemv(W, 0, cast,no_check(s32) p[MVPIS_SHORT]);
        vp8_treed_write_in_encodemv(W, cast(*Vp8_Tree_Index) *(VP8_SMALL_MVTREE), p + MV_PSHORT, X, 3);

        if X == 0 {
            return;
        }
    } else {
        i: s32 = 0;

        vp8_encode_bool_in_encodemv(W, 1, cast,no_check(s32) p[MVPIS_SHORT]);

        while true {
            vp8_encode_bool_in_encodemv(
                W,
                X >> ((i) & 31) & 1,
                cast,no_check(s32) p[(cast,no_check(s32) (MV_PBITS)) + i]
            );
            if !(c_transpiler_pre_increment(*(i)) < 3) break;
        }

        i = (cast,no_check(s32) (MVLONG_WIDTH)) - 1;

        while true {
            vp8_encode_bool_in_encodemv(
                W,
                X >> ((i) & 31) & 1,
                cast,no_check(s32) p[(cast,no_check(s32) (MV_PBITS)) + i]
            );
            if !(c_transpiler_pre_decrement(*(i)) > 3) break;
        }

        if X & 0xfff0 != 0 {
            vp8_encode_bool_in_encodemv(W, X >> 3 & 1, cast,no_check(s32) p[(cast,no_check(s32) (MV_PBITS)) + 3]);
        }
    }

    vp8_encode_bool_in_encodemv(W, cast(s32) (V < 0), cast,no_check(s32) p[MV_PSIGN]);
}

