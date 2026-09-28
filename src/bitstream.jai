DEFAULT_COEF_COUNTS: [4] [8] [3] [12] u32;

VP8CX_BASE_SKIP_FALSE_PROB: [128] s32;

vp8_set_reference_value_in_bitstream :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_bitstream :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_bitstream :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_bitstream :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_bitstream :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_bitstream :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_bitstream :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_bitstream :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_bitstream :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_bitstream :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_bitstream :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_bitstream :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_bitstream :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_bitstream :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_bitstream :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_bitstream :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_bitstream :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_bitstream :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_bitstream :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_bitstream :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_bitstream :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_bitstream :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_bitstream :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_bitstream :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_bitstream :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_bitstream :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

scale2_ratio_in_bitstream :: (mode: s32, hr: *s32, hs: *s32) {
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

validate_buffer_in_bitstream :: (start: *u8, len: u64, end: *u8, error: *Internal_Error_Info) -> s32 {
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

vp8_encode_bool_in_bitstream :: (bc: *BOOL_CODER, bit: s32, probability: s32) {
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

        validate_buffer_in_bitstream(bc.buffer + bc.pos, 1, bc.buffer_end, bc.error);
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

vp8_cost_branch_in_bitstream :: (ct: *u32, p: Vp8_Prob) -> u32 {
    return cast,no_check(u32) ((((cast,no_check(u64) ct[0]) * cast(u64) VP8_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP8_PROB_COST[255 - cast(s32) p]) >> 8);
}

vp8_treed_write_in_bitstream :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) {
    i: Vp8_Tree_Index = 0;

    while true {
        {
            B := v >> ((c_transpiler_pre_decrement(*(n))) & 31) & 1;
            vp8_encode_bool_in_bitstream(W, B, cast,no_check(s32) P[(cast(s32) i) >> 1]);
            i = t[(cast(s32) i) + B];
        }
        if n == 0 break;
    }
}

vp8_write_token_in_bitstream :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) {
    vp8_treed_write_in_bitstream(W, t, P, X.value, X.len);
}

vp8_treed_cost_in_bitstream :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) -> s32 {
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

vp8_cost_token_in_bitstream :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) -> s32 {
    return vp8_treed_cost_in_bitstream(t, P, X.value, X.len);
}

vp8_sem_wait_in_bitstream :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_0: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_0; assignment_0; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init_in_bitstream :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release_in_bitstream :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

atomic_load_acquire_in_bitstream :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_atomic_spin_wait_in_bitstream :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire_in_bitstream(last_row_current_mb_col) - NSYNC {
    }
}

mv_bias_in_bitstream :: (refmb_ref_frame_sign_bias: s32, refframe: s32, mvp: *Int_Mv_in_mv, ref_frame_sign_bias: *s32) {
    if refmb_ref_frame_sign_bias != ref_frame_sign_bias[refframe] {
        mvp.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.row) * -1);
        mvp.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.col) * -1);
    }
}

vp8_clamp_mv2_in_bitstream :: (mv: *Int_Mv_in_mv, xd: *MACROBLOCKD_in_blockd) {
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

vp8_clamp_mv_in_bitstream :: (
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

vp8_check_mv_bounds_in_bitstream :: (
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

left_block_mv_in_bitstream :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> u32 {
    if b & 3 == 0 {
        cur_mb -= 1;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 4;
    }

    return (((cur_mb.bmi.data + b - 1)).mv).as_int;
}

above_block_mv_in_bitstream :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> u32 {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 16;
    }

    return (((cur_mb.bmi.data + (b - 4))).mv).as_int;
}

left_block_mode_in_bitstream :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> B_PREDICTION_MODE {
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

above_block_mode_in_bitstream :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> B_PREDICTION_MODE {
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

vp8_pack_bitstream :: (cpi: *VP8_COMP, dest: *u8, dest_end: *u8, size: *u64) {
    i, j: s32 = ---;
    oh: VP8_HEADER = ---;
    PC := *cpi.common;
    BC := cpi.bc.data;
    XD := *cpi.mb.e_mbd;
    extra_bytes_packed: s32 = 0;

    cx_data := dest;
    cx_data_end := dest_end;

    assignment_1: u32 = cast,no_check(u32) PC.show_frame;
    c_transpiler_bitfield_assign(cast(*void) *(oh), 4, 1, false, (assignment_1), u32);
    assignment_2: u32 = cast,no_check(u32) (cast,no_check(s32) PC.frame_type);
    c_transpiler_bitfield_assign(cast(*void) *(oh), 0, 1, false, (assignment_2), u32);
    assignment_3: u32 = cast,no_check(u32) PC.version;
    c_transpiler_bitfield_assign(cast(*void) *(oh), 1, 3, false, (assignment_3), u32);
    assignment_4: u32 = 0;
    c_transpiler_bitfield_assign(cast(*void) *(oh), 5, 19, false, (assignment_4), u32);

    mb_feature_data_bits := VP8_MB_FEATURE_DATA_BITS.data;

    BC[0].error = *PC.error;

    validate_buffer_in_bitstream(cx_data, 3, cx_data_end, *PC.error);
    cx_data += 3;

    if cast,no_check(s32) c_transpiler_bitfield_read(cast(*void) *(oh), 0, 1, u32, false) == KEY_FRAME_in_alloccommon {
        validate_buffer_in_bitstream(cx_data, 7, cx_data_end, *PC.error);

        cx_data[0] = 0x9d;
        cx_data[1] = 0x1;
        cx_data[2] = 0x2a;

        v := PC.horiz_scale << 14 | PC.width;
        cx_data[3] = cast,no_check(u8) (v & 0xff);
        cx_data[4] = cast,no_check(u8) (v >> 8);

        v = PC.vert_scale << 14 | PC.height;
        cx_data[5] = cast,no_check(u8) (v & 0xff);
        cx_data[6] = cast,no_check(u8) (v >> 8);

        extra_bytes_packed = 7;
        cx_data += extra_bytes_packed;

        (cast,no_check(#type (_: *BOOL_CODER, _: *u8, _: *u8)) (cast(*void) vp8_start_encode))(BC, cx_data, cx_data_end);

        vp8_encode_bool_in_bitstream(BC, 0, cast,no_check(s32) (cast(Vp8_Prob) 128));
        vp8_encode_bool_in_bitstream(BC, cast,no_check(s32) PC.clamp_type, cast,no_check(s32) (cast(Vp8_Prob) 128));
    } else {
        (cast,no_check(#type (_: *BOOL_CODER, _: *u8, _: *u8)) (cast(*void) vp8_start_encode))(BC, cx_data, cx_data_end);
    }

    vp8_encode_bool_in_bitstream(
        BC,
        cast,no_check(s32) XD.segmentation_enabled,
        cast,no_check(s32) (cast(Vp8_Prob) 128)
    );

    if XD.segmentation_enabled != 0 {
        vp8_encode_bool_in_bitstream(
            BC,
            cast,no_check(s32) XD.update_mb_segmentation_map,
            cast,no_check(s32) (cast(Vp8_Prob) 128)
        );
        vp8_encode_bool_in_bitstream(
            BC,
            cast,no_check(s32) XD.update_mb_segmentation_data,
            cast,no_check(s32) (cast(Vp8_Prob) 128)
        );

        if XD.update_mb_segmentation_data != 0 {
            data: s8 = ---;

            vp8_encode_bool_in_bitstream(
                BC,
                cast,no_check(s32) XD.mb_segment_abs_delta,
                cast,no_check(s32) (cast(Vp8_Prob) 128)
            );

            i = 0;
            while i < MB_LVL_MAX {
                j = 0;
                while j < 4 {
                    data = XD.segment_feature_data[i][j];

                    if data != 0 {
                        vp8_encode_bool_in_bitstream(BC, 1, cast,no_check(s32) (cast(Vp8_Prob) 128));

                        if data < 0 {
                            data = cast,no_check(s8) (-(cast,no_check(s32) data));
                            (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(
                                BC,
                                cast,no_check(s32) data,
                                mb_feature_data_bits[i]
                            );
                            vp8_encode_bool_in_bitstream(BC, 1, cast,no_check(s32) (cast(Vp8_Prob) 128));
                        } else {
                            (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(
                                BC,
                                cast,no_check(s32) data,
                                mb_feature_data_bits[i]
                            );
                            vp8_encode_bool_in_bitstream(BC, 0, cast,no_check(s32) (cast(Vp8_Prob) 128));
                        }
                    } else {
                        vp8_encode_bool_in_bitstream(BC, 0, cast,no_check(s32) (cast(Vp8_Prob) 128));
                    }
                    j += 1;
                }
                i += 1;
            }
        }

        if XD.update_mb_segmentation_map != 0 {
            i = 0;
            while i < 3 {
                data := cast,no_check(s32) XD.mb_segment_tree_probs[i];

                if data != 255 {
                    vp8_encode_bool_in_bitstream(BC, 1, cast,no_check(s32) (cast(Vp8_Prob) 128));
                    (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(BC, data, 8);
                } else {
                    vp8_encode_bool_in_bitstream(BC, 0, cast,no_check(s32) (cast(Vp8_Prob) 128));
                }
                i += 1;
            }
        }
    }

    vp8_encode_bool_in_bitstream(BC, cast,no_check(s32) PC.filter_type, cast,no_check(s32) (cast(Vp8_Prob) 128));
    (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(BC, PC.filter_level, 6);
    (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(BC, PC.sharpness_level, 3);

    vp8_encode_bool_in_bitstream(
        BC,
        cast,no_check(s32) XD.mode_ref_lf_delta_enabled,
        cast,no_check(s32) (cast(Vp8_Prob) 128)
    );

    if XD.mode_ref_lf_delta_enabled != 0 {
        send_update := cast(s32) (XD.mode_ref_lf_delta_update != 0 || cpi.oxcf.error_resilient_mode != 0);

        vp8_encode_bool_in_bitstream(BC, send_update, cast,no_check(s32) (cast(Vp8_Prob) 128));
        if send_update != 0 {
            data: s32 = ---;

            i = 0;
            while i < 4 {
                data = cast,no_check(s32) XD.ref_lf_deltas[i];

                if XD.ref_lf_deltas[i] != XD.last_ref_lf_deltas[i] || cpi.oxcf.error_resilient_mode != 0 {
                    XD.last_ref_lf_deltas[i] = XD.ref_lf_deltas[i];
                    vp8_encode_bool_in_bitstream(BC, 1, cast,no_check(s32) (cast(Vp8_Prob) 128));

                    if data > 0 {
                        (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(
                            BC,
                            data & 0x3f,
                            6
                        );
                        vp8_encode_bool_in_bitstream(BC, 0, cast,no_check(s32) (cast(Vp8_Prob) 128));
                    } else {
                        data = -data;
                        (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(
                            BC,
                            data & 0x3f,
                            6
                        );
                        vp8_encode_bool_in_bitstream(BC, 1, cast,no_check(s32) (cast(Vp8_Prob) 128));
                    }
                } else {
                    vp8_encode_bool_in_bitstream(BC, 0, cast,no_check(s32) (cast(Vp8_Prob) 128));
                }
                i += 1;
            }

            i = 0;
            while i < 4 {
                data = cast,no_check(s32) XD.mode_lf_deltas[i];

                if XD.mode_lf_deltas[i] != XD.last_mode_lf_deltas[i] || cpi.oxcf.error_resilient_mode != 0 {
                    XD.last_mode_lf_deltas[i] = XD.mode_lf_deltas[i];
                    vp8_encode_bool_in_bitstream(BC, 1, cast,no_check(s32) (cast(Vp8_Prob) 128));

                    if data > 0 {
                        (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(
                            BC,
                            data & 0x3f,
                            6
                        );
                        vp8_encode_bool_in_bitstream(BC, 0, cast,no_check(s32) (cast(Vp8_Prob) 128));
                    } else {
                        data = -data;
                        (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(
                            BC,
                            data & 0x3f,
                            6
                        );
                        vp8_encode_bool_in_bitstream(BC, 1, cast,no_check(s32) (cast(Vp8_Prob) 128));
                    }
                } else {
                    vp8_encode_bool_in_bitstream(BC, 0, cast,no_check(s32) (cast(Vp8_Prob) 128));
                }
                i += 1;
            }
        }
    }

    (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(
        BC,
        cast,no_check(s32) PC.multi_token_partition,
        2
    );

    (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(BC, PC.base_qindex, 7);

    put_delta_q(BC, PC.y1dc_delta_q);
    put_delta_q(BC, PC.y2dc_delta_q);
    put_delta_q(BC, PC.y2ac_delta_q);
    put_delta_q(BC, PC.uvdc_delta_q);
    put_delta_q(BC, PC.uvac_delta_q);

    if PC.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
        vp8_encode_bool_in_bitstream(BC, PC.refresh_golden_frame, cast,no_check(s32) (cast(Vp8_Prob) 128));
        vp8_encode_bool_in_bitstream(BC, PC.refresh_alt_ref_frame, cast,no_check(s32) (cast(Vp8_Prob) 128));

        if PC.refresh_golden_frame == 0 {
            (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(
                BC,
                PC.copy_buffer_to_gf,
                2
            );
        }

        if PC.refresh_alt_ref_frame == 0 {
            (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(
                BC,
                PC.copy_buffer_to_arf,
                2
            );
        }

        vp8_encode_bool_in_bitstream(BC, PC.ref_frame_sign_bias[GOLDEN_FRAME], cast,no_check(s32) (cast(Vp8_Prob) 128));
        vp8_encode_bool_in_bitstream(BC, PC.ref_frame_sign_bias[ALTREF_FRAME], cast,no_check(s32) (cast(Vp8_Prob) 128));
    }

    if cpi.oxcf.error_resilient_mode & 0x2 != 0 {
        if PC.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
            PC.refresh_entropy_probs = 1;
        } else {
            PC.refresh_entropy_probs = 0;
        }
    }

    vp8_encode_bool_in_bitstream(BC, PC.refresh_entropy_probs, cast,no_check(s32) (cast(Vp8_Prob) 128));

    if PC.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
        vp8_encode_bool_in_bitstream(BC, PC.refresh_last_frame, cast,no_check(s32) (cast(Vp8_Prob) 128));
    }

    if PC.refresh_entropy_probs == 0 {
        PC.lfc = PC.fc;
    }

    vp8_update_coef_probs(cpi);

    vp8_encode_bool_in_bitstream(BC, PC.mb_no_coeff_skip, cast,no_check(s32) (cast(Vp8_Prob) 128));

    if PC.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
        write_kfmodes(cpi);
    } else {
        pack_inter_mode_mvs(cpi);
    }

    (cast,no_check(#type (_: *BOOL_CODER)) (cast(*void) vp8_stop_encode))(BC);

    cx_data += BC.pos;

    assignment_5: u32 = cpi.bc[0].pos;
    c_transpiler_bitfield_assign(cast(*void) *(oh), 5, 19, false, (assignment_5), u32);

    {
        v :=
            (cast,no_check(s32) c_transpiler_bitfield_read(cast(*void) *(oh), 5, 19, u32, false)) << 5 | ((cast,no_check(s32) c_transpiler_bitfield_read(cast(*void) *(oh), 4, 1, u32, false)) << 4) | ((cast,no_check(s32) c_transpiler_bitfield_read(cast(*void) *(oh), 1, 3, u32, false)) << 1) | cast,no_check(s32) c_transpiler_bitfield_read(cast(*void) *(oh), 0, 1, u32, false);

        dest[0] = cast,no_check(u8) (v & 0xff);
        dest[1] = cast,no_check(u8) (v >> 8 & 0xff);
        dest[2] = cast,no_check(u8) (v >> 16);
    }

    size.* = cast,no_check(u64) ((cast,no_check(u32) (3 + extra_bytes_packed)) + cpi.bc[0].pos);

    cpi.partition_sz[0] = cast,no_check(u32) size.*;

    if PC.multi_token_partition != cast,no_check(u32) ONE_PARTITION {
        num_part := (cast(s32) 1) << ((PC.multi_token_partition) & 31);

        cpi.partition_sz[0] += cast,no_check(u32) (3 * (num_part - 1));
        size.* += cast,no_check(u64) (3 * (num_part - 1));

        validate_buffer_in_bitstream(cx_data, cast,no_check(u64) (3 * (num_part - 1)), cx_data_end, *PC.error);

        i = 1;
        while i < num_part + 1 {
            cpi.bc[i].error = *PC.error;
            i += 1;
        }

        pack_tokens_into_partitions(cpi, cx_data + 3 * (num_part - 1), cx_data_end, num_part);

        i = 1;
        while i < num_part {
            cpi.partition_sz[i] = cpi.bc[i].pos;
            write_partition_size(cx_data, cast,no_check(s32) cpi.partition_sz[i]);
            cx_data += 3;
            size.* += cast,no_check(u64) cpi.partition_sz[i];
            i += 1;
        }

        cpi.partition_sz[i] = cpi.bc[i].pos;
        size.* += cast,no_check(u64) cpi.partition_sz[i];
    } else {
        BC[1].error = *PC.error;

        (cast,no_check(#type (_: *BOOL_CODER, _: *u8, _: *u8)) (cast(*void) vp8_start_encode))(
            cpi.bc.data + 1,
            cx_data,
            cx_data_end
        );

        if atomic_load_acquire_in_bitstream(*cpi.b_multi_threaded) != 0 {
            pack_mb_row_tokens(cpi, cpi.bc.data + 1);
        } else {
            vp8_pack_tokens(cpi.bc.data + 1, cpi.tok, cast,no_check(s32) cpi.tok_count);
        }

        (cast,no_check(#type (_: *BOOL_CODER)) (cast(*void) vp8_stop_encode))(cpi.bc.data + 1);

        size.* += cast,no_check(u64) cpi.bc[1].pos;
        cpi.partition_sz[1] = cpi.bc[1].pos;
    }
}

vp8_pack_tokens :: (w: *Vp8_Writer_in_treewriter, p: *TOKENEXTRA, xcount: s32) {
    stop := p + xcount;
    split: u32 = ---;
    shift: s32 = ---;
    count := w.count;
    range := w.range;
    lowvalue := w.lowvalue;

    while p < stop {
        T := cast,no_check(s32) p.token;
        a: *Vp8_Token = VP8_COEF_ENCODINGS.data + T;
        b := VP8_EXTRA_BITS.data + T;
        i: s32 = 0;
        pp: *u8 = p.context_tree;
        v := a.value;
        n := a.len;

        if p.skip_eob_node != 0 {
            n -= 1;
            i = 2;
        }

        while true {
            {
                BB := v >> ((c_transpiler_pre_decrement(*(n))) & 31) & 1;
                split = 1 + ((range - 1) * cast(u32) pp[i >> 1]) >> 8;
                i = cast,no_check(s32) ((cast(*Vp8_Tree_Index) *(VP8_COEF_TREE))[i + BB]);

                if BB != 0 {
                    lowvalue += split;
                    range = range - split;
                } else {
                    range = split;
                }

                shift = cast,no_check(s32) VP8_NORM[range];
                c_transpiler_compound_shl(*(range), (((cast,no_check(u32) shift) & 31)), u32, u32);
                count += shift;

                if count >= 0 {
                    offset := shift - count;

                    if lowvalue << (((offset - 1)) & 31) & 0x80000000 != 0 {
                        x := cast,no_check(s32) (w.pos - 1);

                        while x >= 0 && w.buffer[x] == 0xff {
                            w.buffer[x] = 0;
                            x -= 1;
                        }

                        w.buffer[x] = cast,no_check(u8) ((cast,no_check(s32) w.buffer[x]) + 1);
                    }

                    validate_buffer_in_bitstream(w.buffer + w.pos, 1, w.buffer_end, w.error);

                    w.buffer[w.pos] = cast,no_check(u8) (lowvalue >> (((24 - offset)) & 31) & 0xff);
                    w.pos += 1;
                    shift = count;
                    lowvalue =
                        cast,no_check(u32) (cast,no_check(s32) ((cast,no_check(u64) lowvalue) << ((offset) & 63) & 0xffffff));
                    count -= 8;
                }

                c_transpiler_compound_shl(*(lowvalue), (((cast,no_check(u32) shift) & 31)), u32, u32);
            }
            if n == 0 break;
        }

        if b.base_val != 0 {
            E := cast,no_check(s32) p.extra;
            L := b.len;

            if L != 0 {
                proba: *u8 = b.prob;
                V2 := E >> 1;
                n2 := L;
                i = 0;

                while true {
                    {
                        BB := V2 >> ((c_transpiler_pre_decrement(*(n2))) & 31) & 1;
                        split = 1 + ((range - 1) * cast(u32) proba[i >> 1]) >> 8;
                        i = cast,no_check(s32) b.tree[i + BB];

                        if BB != 0 {
                            lowvalue += split;
                            range = range - split;
                        } else {
                            range = split;
                        }

                        shift = cast,no_check(s32) VP8_NORM[range];
                        c_transpiler_compound_shl(*(range), (((cast,no_check(u32) shift) & 31)), u32, u32);
                        count += shift;

                        if count >= 0 {
                            offset := shift - count;

                            if lowvalue << (((offset - 1)) & 31) & 0x80000000 != 0 {
                                x := cast,no_check(s32) (w.pos - 1);

                                while x >= 0 && w.buffer[x] == 0xff {
                                    w.buffer[x] = 0;
                                    x -= 1;
                                }

                                w.buffer[x] = cast,no_check(u8) ((cast,no_check(s32) w.buffer[x]) + 1);
                            }

                            validate_buffer_in_bitstream(w.buffer + w.pos, 1, w.buffer_end, w.error);

                            w.buffer[w.pos] = cast,no_check(u8) (lowvalue >> (((24 - offset)) & 31) & 0xff);
                            w.pos += 1;
                            shift = count;
                            lowvalue =
                                cast,no_check(u32) (cast,no_check(s32) ((cast,no_check(u64) lowvalue) << ((offset) & 63) & 0xffffff));
                            count -= 8;
                        }

                        c_transpiler_compound_shl(*(lowvalue), (((cast,no_check(u32) shift) & 31)), u32, u32);
                    }
                    if n2 == 0 break;
                }
            }

            split = (range + 1) >> 1;

            if E & 1 != 0 {
                lowvalue += split;
                range = range - split;
            } else {
                range = split;
            }

            c_transpiler_compound_shl(*(range), (cast(s32) 1), u32, u32);

            if lowvalue & 0x80000000 != 0 {
                x := cast,no_check(s32) (w.pos - 1);

                while x >= 0 && w.buffer[x] == 0xff {
                    w.buffer[x] = 0;
                    x -= 1;
                }

                w.buffer[x] = cast,no_check(u8) ((cast,no_check(s32) w.buffer[x]) + 1);
            }

            c_transpiler_compound_shl(*(lowvalue), (cast(s32) 1), u32, u32);

            if c_transpiler_pre_increment(*(count)) == 0 {
                count = -8;

                validate_buffer_in_bitstream(w.buffer + w.pos, 1, w.buffer_end, w.error);

                w.buffer[w.pos] = cast,no_check(u8) (lowvalue >> 24);
                w.pos += 1;
                lowvalue &= 0xffffff;
            }
        }

        p += 1;
    }

    w.count = count;
    w.lowvalue = lowvalue;
    w.range = range;
}

pack_mb_row_tokens :: (cpi: *VP8_COMP, w: *Vp8_Writer_in_treewriter) {
    mb_row: s32 = 0;
    while mb_row < cpi.common.mb_rows {
        p := cpi.tplist[mb_row].start;
        stop := cpi.tplist[mb_row].stop;
        tokens := cast,no_check(s32) (stop - p);

        vp8_pack_tokens(w, p, tokens);
        mb_row += 1;
    }
}

write_partition_size :: (cx_data: *u8, size: s32) {
    csize := cast,no_check(s8) (size & 0xff);
    cx_data.* = cast,no_check(u8) csize;
    csize = cast,no_check(s8) (size >> 8 & 0xff);
    assignment_6: u8 = cast,no_check(u8) csize;
    ((cx_data + 1).*) = assignment_6;
    csize = cast,no_check(s8) (size >> 16 & 0xff);
    assignment_7: u8 = cast,no_check(u8) csize;
    ((cx_data + 2).*) = assignment_7;
}

pack_tokens_into_partitions :: (cpi: *VP8_COMP, cx_data: *u8, cx_data_end: *u8, num_part: s32) {
    ptr := cx_data;
    ptr_end := cx_data_end;

    if 0 < num_part {
        for i: 0..num_part - 1 {
            w := cpi.bc.data + i + 1;

            (cast,no_check(#type (_: *BOOL_CODER, _: *u8, _: *u8)) (cast(*void) vp8_start_encode))(w, ptr, ptr_end);

            mb_row := i;
            while mb_row < cpi.common.mb_rows {
                p := cpi.tplist[mb_row].start;
                stop := cpi.tplist[mb_row].stop;
                tokens := cast,no_check(s32) (stop - p);

                vp8_pack_tokens(w, p, tokens);
                mb_row += num_part;
            }

            (cast,no_check(#type (_: *BOOL_CODER)) (cast(*void) vp8_stop_encode))(w);
            ptr += w.pos;
        }
    }
}

pack_inter_mode_mvs :: (CPI: *VP8_COMP) {
    PC: *VP8_COMMON = ---;
    W: *Vp8_Writer_in_treewriter = ---;
    mvc: *MV_CONTEXT = ---;
    m: *MODE_INFO_in_blockd = ---;
    MIS: s32 = ---;
    mb_row: s32 = ---;
    prob_skip_false: s32 = ---;
    total_mbs: s32 = ---;
    mb_col: s32 = ---;
    MI: *MB_MODE_INFO = ---;
    RF: MV_REFERENCE_FRAME_in_alloccommon = ---;
    MODE_: MB_PREDICTION_MODE = ---;
    xd: *MACROBLOCKD_in_blockd = ---;
    j: s32 = ---;
    best_mv: Int_Mv_in_mv = ---;
    mv_ref_p: [4] Vp8_Prob = ---;
    n1: Int_Mv_in_mv = ---;
    n2: Int_Mv_in_mv = ---;
    ct: [4] s32 = ---;
    j_2: s32 = ---;
    blockmode: B_PREDICTION_MODE = ---;
    blockmv: Int_Mv_in_mv = ---;
    L: *s32 = ---;
    k: s32 = ---;
    mv_contz: s32 = ---;
    leftmv: Int_Mv_in_mv = ---;
    abovemv: Int_Mv_in_mv = ---;
    code_block_to_execute: s64 = 89;
    while c_transpiler_dispatch := true {
        if code_block_to_execute < 0 break;
        if code_block_to_execute == {
            case 3; {
                if c_transpiler_pre_increment(*(mb_row)) < PC.mb_rows {
                    code_block_to_execute = 66;
                    continue c_transpiler_dispatch;
                } else {
                    break c_transpiler_dispatch;
                }
            }
            case 6; {
                if c_transpiler_pre_increment(*(mb_col)) < PC.mb_cols {
                    code_block_to_execute = 65;
                    continue c_transpiler_dispatch;
                } else {
                    m += 1;
                    CPI.mb.partition_info += 1;
                    code_block_to_execute = 3;
                    continue c_transpiler_dispatch;
                }
            }
            case 8; {
                m += 1;
                CPI.mb.partition_info += 1;
                code_block_to_execute = 6;
                continue c_transpiler_dispatch;
            }
            case 11; {
                if c_transpiler_pre_increment(*(j_2)) < CPI.mb.partition_info.count {
                    code_block_to_execute = 27;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 8;
                    continue c_transpiler_dispatch;
                }
            }
            case 18; {
                while c_transpiler_local_loop := true {
                    if j_2 != L[c_transpiler_pre_increment(*(k))] {
                        continue c_transpiler_local_loop;
                    } else {
                        leftmv.as_int = left_block_mv_in_bitstream(m, k);
                        abovemv.as_int = above_block_mv_in_bitstream(m, k, MIS);
                        mv_contz = vp8_mv_cont(*leftmv, *abovemv);
                        write_sub_mv_ref(W, blockmode, VP8_SUB_MV_REF_PROB2[mv_contz].data);
                        if blockmode == cast,no_check(u32) NEW4X4 {
                            write_mv(W, *blockmv.as_mv, *best_mv, mvc);
                            code_block_to_execute = 11;
                            continue c_transpiler_dispatch;
                        } else {
                            code_block_to_execute = 11;
                            continue c_transpiler_dispatch;
                        }
                    }
                }
            }
            case 27; {
                L = VP8_MBSPLITS[MI.partitioning].data;
                k = -1;
                blockmode = CPI.mb.partition_info.bmi[j_2].mode;
                blockmv = CPI.mb.partition_info.bmi[j_2].mv;
                code_block_to_execute = 18;
                continue c_transpiler_dispatch;
            }
            case 38; {
                vp8_find_near_mvs(
                    xd,
                    m,
                    *n1,
                    *n2,
                    *best_mv,
                    ct.data,
                    cast,no_check(s32) RF,
                    PC.ref_frame_sign_bias.data
                );
                vp8_clamp_mv2_in_bitstream(*best_mv, xd);
                vp8_mv_ref_probs(mv_ref_p.data, ct.data);
                write_mv_ref(W, MODE_, mv_ref_p.data);
                c_transpiler_switch_value_38 := MODE_;
                if c_transpiler_switch_value_38 == {
                    case cast,no_check(u32) NEWMV; {
                        write_mv(W, *MI.mv.as_mv, *best_mv, mvc);
                        code_block_to_execute = 8;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) SPLITMV; {
                        j_2 = 0;
                        write_split(W, cast,no_check(s32) MI.partitioning);
                        code_block_to_execute = 27;
                        continue c_transpiler_dispatch;
                    }
                    case; {
                        code_block_to_execute = 8;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 46; {
                write_uv_mode(W, cast,no_check(s32) MI.uv_mode, PC.fc.uv_mode_prob.data);
                code_block_to_execute = 8;
                continue c_transpiler_dispatch;
            }
            case 48; {
                while c_transpiler_local_loop := true {
                    write_bmode(W, cast,no_check(s32) m.bmi[j].as_mode, PC.fc.bmode_prob.data);
                    if c_transpiler_pre_increment(*(j)) < 16 {
                        continue c_transpiler_local_loop;
                    } else {
                        code_block_to_execute = 46;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 53; {
                if RF == cast,no_check(u32) INTRA_FRAME {
                    vp8_encode_bool_in_bitstream(W, 0, CPI.prob_intra_coded);
                    write_ymode(W, cast,no_check(s32) MODE_, PC.fc.ymode_prob.data);
                    if MODE_ == cast,no_check(u32) B_PRED {
                        j = 0;
                        code_block_to_execute = 48;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 46;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    vp8_encode_bool_in_bitstream(W, 1, CPI.prob_intra_coded);
                    if RF == cast,no_check(u32) LAST_FRAME {
                        vp8_encode_bool_in_bitstream(W, 0, CPI.prob_last_coded);
                        code_block_to_execute = 38;
                        continue c_transpiler_dispatch;
                    } else {
                        vp8_encode_bool_in_bitstream(W, 1, CPI.prob_last_coded);
                        vp8_encode_bool_in_bitstream(
                            W,
                            (ifx RF == cast,no_check(u32) GOLDEN_FRAME then cast(s32) 0 else 1),
                            CPI.prob_gf_coded
                        );
                        code_block_to_execute = 38;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 55; {
                if PC.mb_no_coeff_skip != 0 {
                    vp8_encode_bool_in_bitstream(W, cast,no_check(s32) m.mbmi.mb_skip_coeff, prob_skip_false);
                    code_block_to_execute = 53;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 53;
                    continue c_transpiler_dispatch;
                }
            }
            case 65; {
                MI = *m.mbmi;
                RF = cast,no_check(MV_REFERENCE_FRAME_in_alloccommon) MI.ref_frame;
                MODE_ = cast,no_check(MB_PREDICTION_MODE) MI.mode;
                xd = *CPI.mb.e_mbd;
                xd.mb_to_left_edge = -((mb_col * 16) << 3);
                xd.mb_to_right_edge = ((PC.mb_cols - 1 - mb_col) * 16) << 3;
                xd.mb_to_top_edge = -((mb_row * 16) << 3);
                xd.mb_to_bottom_edge = ((PC.mb_rows - 1 - mb_row) * 16) << 3;
                if CPI.mb.e_mbd.update_mb_segmentation_map != 0 {
                    write_mb_features(W, MI, *CPI.mb.e_mbd);
                    code_block_to_execute = 55;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 55;
                    continue c_transpiler_dispatch;
                }
            }
            case 66; {
                mb_col = -1;
                code_block_to_execute = 6;
                continue c_transpiler_dispatch;
            }
            case 71; {
                (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(
                    W,
                    CPI.prob_intra_coded,
                    8
                );
                (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(
                    W,
                    CPI.prob_last_coded,
                    8
                );
                (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(
                    W,
                    CPI.prob_gf_coded,
                    8
                );
                update_mbintra_mode_probs(CPI);
                vp8_write_mvprobs(CPI);
                code_block_to_execute = 3;
                continue c_transpiler_dispatch;
            }
            case 73; {
                CPI.prob_skip_false = prob_skip_false;
                (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(
                    W,
                    prob_skip_false,
                    8
                );
                code_block_to_execute = 71;
                continue c_transpiler_dispatch;
            }
            case 75; {
                if prob_skip_false > 255 {
                    prob_skip_false = 255;
                    code_block_to_execute = 73;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 73;
                    continue c_transpiler_dispatch;
                }
            }
            case 89; {
                PC = *CPI.common;
                W = CPI.bc.data;
                mvc = PC.fc.mvc.data;
                m = PC.mi;
                MIS = PC.mode_info_stride;
                mb_row = -1;
                prob_skip_false = 0;
                CPI.mb.partition_info = CPI.mb.pi;
                vp8_convert_rfct_to_prob(CPI);
                if PC.mb_no_coeff_skip != 0 {
                    total_mbs = PC.mb_rows * PC.mb_cols;
                    prob_skip_false = (total_mbs - CPI.mb.skip_true_count) * 256 / total_mbs;
                    if prob_skip_false <= 1 {
                        prob_skip_false = 1;
                        code_block_to_execute = 75;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 75;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 71;
                    continue c_transpiler_dispatch;
                }
            }
        }
        assert(false, tprint("invalid code block to execute %", code_block_to_execute));
        break;
    }
}

write_mv :: (w: *Vp8_Writer_in_treewriter, mv: *MV_in_alloccommon, ref: *Int_Mv_in_mv, mvc: *MV_CONTEXT) {
    e: MV_in_alloccommon = ---;
    e.row = cast,no_check(s16) ((cast(s32) mv.row) - cast(s32) ref.as_mv.row);
    e.col = cast,no_check(s16) ((cast(s32) mv.col) - cast(s32) ref.as_mv.col);

    (cast,no_check(#type (_: *Vp8_Writer_in_treewriter, _: *MV_in_alloccommon, _: *MV_CONTEXT)) (cast(*void) vp8_encode_motion_vector))(
        w,
        *e,
        mvc
    );
}

write_sub_mv_ref :: (w: *Vp8_Writer_in_treewriter, m: B_PREDICTION_MODE, p: *Vp8_Prob) {
    vp8_write_token_in_bitstream(
        w,
        cast(*Vp8_Tree_Index) *(VP8_SUB_MV_REF_TREE),
        p,
        VP8_SUB_MV_REF_ENCODING_ARRAY.data + (m - cast,no_check(u32) LEFT4X4)
    );
}

write_split :: (bc: *Vp8_Writer_in_treewriter, x: s32) {
    vp8_write_token_in_bitstream(
        bc,
        cast(*Vp8_Tree_Index) *(VP8_MBSPLIT_TREE),
        VP8_MBSPLIT_PROBS.data,
        VP8_MBSPLIT_ENCODINGS.data + x
    );
}

write_mv_ref :: (w: *Vp8_Writer_in_treewriter, m: MB_PREDICTION_MODE, p: *Vp8_Prob) {
    vp8_write_token_in_bitstream(
        w,
        cast(*Vp8_Tree_Index) *(VP8_MV_REF_TREE),
        p,
        VP8_MV_REF_ENCODING_ARRAY.data + (m - cast,no_check(u32) NEARESTMV)
    );
}

write_uv_mode :: (bc: *Vp8_Writer_in_treewriter, m: s32, p: *Vp8_Prob) {
    vp8_write_token_in_bitstream(bc, cast(*Vp8_Tree_Index) *(VP8_UV_MODE_TREE), p, VP8_UV_MODE_ENCODINGS.data + m);
}

write_bmode :: (bc: *Vp8_Writer_in_treewriter, m: s32, p: *Vp8_Prob) {
    vp8_write_token_in_bitstream(bc, cast(*Vp8_Tree_Index) *(VP8_BMODE_TREE), p, VP8_BMODE_ENCODINGS.data + m);
}

write_ymode :: (bc: *Vp8_Writer_in_treewriter, m: s32, p: *Vp8_Prob) {
    vp8_write_token_in_bitstream(bc, cast(*Vp8_Tree_Index) *(VP8_YMODE_TREE), p, VP8_YMODE_ENCODINGS.data + m);
}

write_mb_features :: (w: *Vp8_Writer_in_treewriter, mi: *MB_MODE_INFO, x: *MACROBLOCKD_in_blockd) {
    if x.segmentation_enabled != 0 && x.update_mb_segmentation_map != 0 {
        if cast,no_check(s32) mi.segment_id == {
            case 0;
                vp8_encode_bool_in_bitstream(w, 0, cast,no_check(s32) x.mb_segment_tree_probs[0]);
                vp8_encode_bool_in_bitstream(w, 0, cast,no_check(s32) x.mb_segment_tree_probs[1]);
            case 1;
                vp8_encode_bool_in_bitstream(w, 0, cast,no_check(s32) x.mb_segment_tree_probs[0]);
                vp8_encode_bool_in_bitstream(w, 1, cast,no_check(s32) x.mb_segment_tree_probs[1]);
            case 2;
                vp8_encode_bool_in_bitstream(w, 1, cast,no_check(s32) x.mb_segment_tree_probs[0]);
                vp8_encode_bool_in_bitstream(w, 0, cast,no_check(s32) x.mb_segment_tree_probs[2]);
            case 3;
                vp8_encode_bool_in_bitstream(w, 1, cast,no_check(s32) x.mb_segment_tree_probs[0]);
                vp8_encode_bool_in_bitstream(w, 1, cast,no_check(s32) x.mb_segment_tree_probs[2]);
            case;
                vp8_encode_bool_in_bitstream(w, 0, cast,no_check(s32) x.mb_segment_tree_probs[0]);
                vp8_encode_bool_in_bitstream(w, 0, cast,no_check(s32) x.mb_segment_tree_probs[1]);
        }
    }
}

update_mbintra_mode_probs :: (cpi: *VP8_COMP) {
    X := *cpi.common;

    W := cpi.bc.data;

    {
        pnew: [4] Vp8_Prob = ---;
        bct: [4] [2] u32 = ---;

        update_mode(
            W,
            (cast,no_check(s32) (B_PRED)) + 1,
            VP8_YMODE_ENCODINGS.data,
            cast(*Vp8_Tree_Index) *(VP8_YMODE_TREE),
            pnew.data,
            X.fc.ymode_prob.data,
            bct.data,
            cast(*u32) cpi.mb.ymode_count.data
        );
    }
    {
        pnew: [3] Vp8_Prob = ---;
        bct: [3] [2] u32 = ---;

        update_mode(
            W,
            (cast,no_check(s32) (TM_PRED)) + 1,
            VP8_UV_MODE_ENCODINGS.data,
            cast(*Vp8_Tree_Index) *(VP8_UV_MODE_TREE),
            pnew.data,
            X.fc.uv_mode_prob.data,
            bct.data,
            cast(*u32) cpi.mb.uv_mode_count.data
        );
    }
}

update_mode :: (
    W: *Vp8_Writer_in_treewriter,
    n: s32,
    tok: *Vp8_Token,
    tree: *Vp8_Tree_Index,
    pnew: *Vp8_Prob,
    pcur: *Vp8_Prob,
    bct: *[2] u32,
    num_events: *u32
) {
    new_b: u32 = 0;
    old_b: u32 = 0;
    i: s32 = 0;

    vp8_tree_probs_from_distribution(c_transpiler_post_decrement(*(n)), tok, tree, pnew, bct, num_events, 256, 1);

    while true {
        new_b += vp8_cost_branch_in_bitstream(bct[i].data, pnew[i]);
        old_b += vp8_cost_branch_in_bitstream(bct[i].data, pcur[i]);
        if !(c_transpiler_pre_increment(*(i)) < n) break;
    }

    if (new_b + cast,no_check(u32) (n << 8)) < old_b {
        j: s32 = 0;

        vp8_encode_bool_in_bitstream(W, 1, cast,no_check(s32) (cast(Vp8_Prob) 128));

        while true {
            {
                P := pnew[j];

                (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(
                    W,
                    cast,no_check(s32) ((ifx true { assignment_8: Vp8_Prob = cast,no_check(Vp8_Prob) (cast,no_check(Vp8_Prob) ((ifx P != 0 then cast,no_check(s32) P else 1))); (pcur[j]) = assignment_8; assignment_8; })),
                    8
                );
            }
            if !(c_transpiler_pre_increment(*(j)) < n) break;
        }
    } else {
        vp8_encode_bool_in_bitstream(W, 0, cast,no_check(s32) (cast(Vp8_Prob) 128));
    }
}

vp8_convert_rfct_to_prob :: (CPI: *VP8_COMP) {
    RFCT := CPI.mb.count_mb_ref_frame_usage.data;
    RF_INTRA := RFCT[INTRA_FRAME];
    RF_INTER := RFCT[LAST_FRAME] + RFCT[GOLDEN_FRAME] + RFCT[ALTREF_FRAME];

    if (ifx true { assignment_9: s32 = cast,no_check(s32) ((RF_INTRA * 255 / (RF_INTRA + RF_INTER))); (CPI.prob_intra_coded) = assignment_9; assignment_9; }) == 0 {
        CPI.prob_intra_coded = 1;
    }

    CPI.prob_last_coded = ifx RF_INTER != 0 then RFCT[LAST_FRAME] * 255 / RF_INTER else 128;

    if CPI.prob_last_coded == 0 {
        CPI.prob_last_coded = 1;
    }

    CPI.prob_gf_coded =
        ifx (((RFCT[GOLDEN_FRAME] + RFCT[ALTREF_FRAME])) != 0) then RFCT[GOLDEN_FRAME] *
            255 / (RFCT[GOLDEN_FRAME] + RFCT[ALTREF_FRAME]) else 128;

    if CPI.prob_gf_coded == 0 {
        CPI.prob_gf_coded = 1;
    }
}

write_kfmodes :: (cpi: *VP8_COMP) {
    BC := cpi.bc.data;
    C := *cpi.common;

    m := C.mi;

    mb_row: s32 = -1;
    prob_skip_false: s32 = 0;

    if C.mb_no_coeff_skip != 0 {
        total_mbs := C.mb_rows * C.mb_cols;

        prob_skip_false = (total_mbs - cpi.mb.skip_true_count) * 256 / total_mbs;

        if prob_skip_false <= 1 {
            prob_skip_false = 1;
        }

        if prob_skip_false >= 255 {
            prob_skip_false = 255;
        }

        cpi.prob_skip_false = prob_skip_false;
        (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(BC, prob_skip_false, 8);
    }

    while c_transpiler_pre_increment(*(mb_row)) < C.mb_rows {
        mb_col: s32 = -1;

        while c_transpiler_pre_increment(*(mb_col)) < C.mb_cols {
            YM := cast,no_check(s32) m.mbmi.mode;

            if cpi.mb.e_mbd.update_mb_segmentation_map != 0 {
                write_mb_features(BC, *m.mbmi, *cpi.mb.e_mbd);
            }

            if C.mb_no_coeff_skip != 0 {
                vp8_encode_bool_in_bitstream(BC, cast,no_check(s32) m.mbmi.mb_skip_coeff, prob_skip_false);
            }

            kfwrite_ymode(BC, YM, VP8_KF_YMODE_PROB.data);

            if YM == B_PRED {
                MIS := C.mode_info_stride;
                i: s32 = 0;

                while true {
                    {
                        A := above_block_mode_in_bitstream(m, i, MIS);
                        L := left_block_mode_in_bitstream(m, i);
                        BM := cast,no_check(s32) m.bmi[i].as_mode;

                        write_bmode(BC, BM, VP8_KF_BMODE_PROB[A][L].data);
                    }
                    if !(c_transpiler_pre_increment(*(i)) < 16) break;
                }
            }

            write_uv_mode(
                BC,
                cast,no_check(s32) (((c_transpiler_post_increment(*(m))).mbmi).uv_mode),
                VP8_KF_UV_MODE_PROB.data
            );
        }

        m += 1;
    }
}

kfwrite_ymode :: (bc: *Vp8_Writer_in_treewriter, m: s32, p: *Vp8_Prob) {
    vp8_write_token_in_bitstream(bc, cast(*Vp8_Tree_Index) *(VP8_KF_YMODE_TREE), p, VP8_KF_YMODE_ENCODINGS.data + m);
}

vp8_update_coef_probs :: (cpi: *VP8_COMP) {
    i: s32 = 0;

    W := cpi.bc.data;

    while true {
        {
            j: s32 = 0;

            while true {
                {
                    k: s32 = 0;
                    prev_coef_savings: [11] s32;
                    if cpi.oxcf.error_resilient_mode & 0x2 != 0 {
                        k = 0;
                        while k < 3 {
                            for t: 0..cast(s32) 11 - 1 {
                                ct := cpi.frame_branch_ct[i][j][k][t].data;
                                NEWP := cpi.frame_coef_probs[i][j][k][t];
                                OLDP := cpi.common.fc.coef_probs[i][j][k][t];
                                UPD := VP8_COEF_UPDATE_PROBS[i][j][k][t];

                                prev_coef_savings[t] += prob_update_savings(ct, OLDP, NEWP, UPD);
                            }
                            k += 1;
                        }
                        k = 0;
                    }
                    while true {
                        {
                            t: s32 = 0;

                            while true {
                                {
                                    NEWP := cpi.frame_coef_probs[i][j][k][t];

                                    pold := cpi.common.fc.coef_probs[i][j][k].data + t;
                                    UPD := VP8_COEF_UPDATE_PROBS[i][j][k][t];

                                    s := prev_coef_savings[t];
                                    u: s32 = 0;

                                    if cpi.oxcf.error_resilient_mode & 0x2 == 0 {
                                        s =
                                            prob_update_savings(cpi.frame_branch_ct[i][j][k][t].data, pold.*, NEWP, UPD);
                                    }

                                    if s > 0 {
                                        u = 1;
                                    }

                                    if cpi.oxcf.error_resilient_mode & 0x2 != 0 &&
                                        cpi.common.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon &&
                                        NEWP != pold.* {
                                        u = 1;
                                    }

                                    vp8_encode_bool_in_bitstream(W, u, cast,no_check(s32) UPD);

                                    if u != 0 {
                                        pold.* = NEWP;

                                        (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(
                                            W,
                                            cast,no_check(s32) NEWP,
                                            8
                                        );
                                    }
                                }
                                if !(c_transpiler_pre_increment(*(t)) < 11) break;
                            }
                        }
                        if !(c_transpiler_pre_increment(*(k)) < 3) break;
                    }
                }
                if !(c_transpiler_pre_increment(*(j)) < 8) break;
            }
        }
        if !(c_transpiler_pre_increment(*(i)) < 4) break;
    }
}

prob_update_savings :: (ct: *u32, OLDP: Vp8_Prob, NEWP: Vp8_Prob, UPD: Vp8_Prob) -> s32 {
    OLD_B := cast,no_check(s32) vp8_cost_branch_in_bitstream(ct, OLDP);
    NEW_B := cast,no_check(s32) vp8_cost_branch_in_bitstream(ct, NEWP);
    UPDATE_B := cast,no_check(s32) (8 + (VP8_PROB_COST[255 - cast(s32) UPD] - VP8_PROB_COST[UPD]) >> 8);

    return OLD_B - NEW_B - UPDATE_B;
}

put_delta_q :: (bc: *Vp8_Writer_in_treewriter, delta_q: s32) {
    if delta_q != 0 {
        vp8_encode_bool_in_bitstream(bc, 1, cast,no_check(s32) (cast(Vp8_Prob) 128));
        (cast,no_check(#type (_: *BOOL_CODER, _: s32, _: s32)) (cast(*void) vp8_encode_value))(
            bc,
            absolute_value(delta_q),
            4
        );

        if delta_q < 0 {
            vp8_encode_bool_in_bitstream(bc, 1, cast,no_check(s32) (cast(Vp8_Prob) 128));
        } else {
            vp8_encode_bool_in_bitstream(bc, 0, cast,no_check(s32) (cast(Vp8_Prob) 128));
        }
    } else {
        vp8_encode_bool_in_bitstream(bc, 0, cast,no_check(s32) (cast(Vp8_Prob) 128));
    }
}

vp8_calc_ref_frame_costs :: (ref_frame_cost: *s32, prob_intra: s32, prob_last: s32, prob_garf: s32) {
    ref_frame_cost[INTRA_FRAME] = cast,no_check(s32) VP8_PROB_COST[prob_intra];
    ref_frame_cost[LAST_FRAME] = cast,no_check(s32) (VP8_PROB_COST[255 - prob_intra] + VP8_PROB_COST[prob_last]);
    ref_frame_cost[GOLDEN_FRAME] =
        cast,no_check(s32) (VP8_PROB_COST[255 - prob_intra] +
            VP8_PROB_COST[255 - prob_last] + VP8_PROB_COST[prob_garf]);
    ref_frame_cost[ALTREF_FRAME] =
        cast,no_check(s32) (VP8_PROB_COST[255 - prob_intra] +
            VP8_PROB_COST[255 - prob_last] + VP8_PROB_COST[255 - prob_garf]);
}

vp8_estimate_entropy_savings :: (cpi: *VP8_COMP) -> s32 {
    savings: s32 = 0;

    RFCT := cpi.mb.count_mb_ref_frame_usage.data;
    RF_INTRA := RFCT[INTRA_FRAME];
    RF_INTER := RFCT[LAST_FRAME] + RFCT[GOLDEN_FRAME] + RFCT[ALTREF_FRAME];
    new_intra, new_last, new_garf, oldtotal, newtotal: s32 = ---;
    ref_frame_cost: [4] s32 = ---;

    if cpi.common.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
        if (ifx true { assignment_10: s32 = cast,no_check(s32) ((RF_INTRA * 255 / (RF_INTRA + RF_INTER))); (new_intra) = assignment_10; assignment_10; }) == 0 {
            new_intra = 1;
        }

        new_last = ifx RF_INTER != 0 then RFCT[LAST_FRAME] * 255 / RF_INTER else 128;

        new_garf =
            ifx (((RFCT[GOLDEN_FRAME] + RFCT[ALTREF_FRAME])) != 0) then RFCT[GOLDEN_FRAME] *
                255 / (RFCT[GOLDEN_FRAME] + RFCT[ALTREF_FRAME]) else 128;

        vp8_calc_ref_frame_costs(ref_frame_cost.data, new_intra, new_last, new_garf);

        newtotal =
            RFCT[INTRA_FRAME] * ref_frame_cost[INTRA_FRAME] + RFCT[LAST_FRAME] * ref_frame_cost[LAST_FRAME] +
                RFCT[GOLDEN_FRAME] * ref_frame_cost[GOLDEN_FRAME] + RFCT[ALTREF_FRAME] * ref_frame_cost[ALTREF_FRAME];

        vp8_calc_ref_frame_costs(ref_frame_cost.data, cpi.prob_intra_coded, cpi.prob_last_coded, cpi.prob_gf_coded);

        oldtotal =
            RFCT[INTRA_FRAME] * ref_frame_cost[INTRA_FRAME] + RFCT[LAST_FRAME] * ref_frame_cost[LAST_FRAME] +
                RFCT[GOLDEN_FRAME] * ref_frame_cost[GOLDEN_FRAME] + RFCT[ALTREF_FRAME] * ref_frame_cost[ALTREF_FRAME];

        savings += (oldtotal - newtotal) / 256;
    }

    if cpi.oxcf.error_resilient_mode & 0x2 != 0 {
        savings += independent_coef_context_savings(cpi);
    } else {
        savings += default_coef_context_savings(cpi);
    }

    return savings;
}

default_coef_context_savings :: (cpi: *VP8_COMP) -> s32 {
    X := *cpi.mb;
    savings: s32 = 0;
    i: s32 = 0;
    while true {
        {
            j: s32 = 0;
            while true {
                {
                    k: s32 = 0;
                    while true {
                        {
                            t: s32 = 0;

                            vp8_tree_probs_from_distribution(
                                12,
                                VP8_COEF_ENCODINGS.data,
                                cast(*Vp8_Tree_Index) *(VP8_COEF_TREE),
                                cpi.frame_coef_probs[i][j][k].data,
                                cpi.frame_branch_ct[i][j][k].data,
                                X.coef_counts[i][j][k].data,
                                256,
                                1
                            );

                            while true {
                                {
                                    ct := cpi.frame_branch_ct[i][j][k][t].data;
                                    NEWP := cpi.frame_coef_probs[i][j][k][t];
                                    OLDP := cpi.common.fc.coef_probs[i][j][k][t];
                                    UPD := VP8_COEF_UPDATE_PROBS[i][j][k][t];
                                    S := prob_update_savings(ct, OLDP, NEWP, UPD);

                                    if S > 0 {
                                        savings += S;
                                    }
                                }
                                if !(c_transpiler_pre_increment(*(t)) < 11) break;
                            }
                        }
                        if !(c_transpiler_pre_increment(*(k)) < 3) break;
                    }
                }
                if !(c_transpiler_pre_increment(*(j)) < 8) break;
            }
        }
        if !(c_transpiler_pre_increment(*(i)) < 4) break;
    }
    return savings;
}

independent_coef_context_savings :: (cpi: *VP8_COMP) -> s32 {
    X := *cpi.mb;
    savings: s32 = 0;
    i: s32 = 0;
    while true {
        {
            j: s32 = 0;
            while true {
                {
                    k: s32 = 0;
                    prev_coef_count_sum: [12] u32;
                    prev_coef_savings: [12] s32;
                    probs := X.coef_counts[i][j].data;

                    if cpi.common.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
                        probs = DEFAULT_COEF_COUNTS[i][j].data;
                    }

                    sum_probs_over_prev_coef_context(probs, prev_coef_count_sum.data);

                    while true {
                        {
                            t: s32 = 0;

                            vp8_tree_probs_from_distribution(
                                12,
                                VP8_COEF_ENCODINGS.data,
                                cast(*Vp8_Tree_Index) *(VP8_COEF_TREE),
                                cpi.frame_coef_probs[i][j][k].data,
                                cpi.frame_branch_ct[i][j][k].data,
                                prev_coef_count_sum.data,
                                256,
                                1
                            );

                            while true {
                                {
                                    ct := cpi.frame_branch_ct[i][j][k][t].data;
                                    NEWP := cpi.frame_coef_probs[i][j][k][t];
                                    OLDP := cpi.common.fc.coef_probs[i][j][k][t];
                                    UPD := VP8_COEF_UPDATE_PROBS[i][j][k][t];
                                    S := prob_update_savings(ct, OLDP, NEWP, UPD);

                                    if cpi.common.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon ||
                                        cpi.common.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon && NEWP != OLDP {
                                        prev_coef_savings[t] += S;
                                    }
                                }
                                if !(c_transpiler_pre_increment(*(t)) < 11) break;
                            }
                        }
                        if !(c_transpiler_pre_increment(*(k)) < 3) break;
                    }
                    k = 0;
                    while true {
                        if prev_coef_savings[k] > 0 || cpi.common.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
                            savings += prev_coef_savings[k];
                        }
                        if !(c_transpiler_pre_increment(*(k)) < 11) break;
                    }
                }
                if !(c_transpiler_pre_increment(*(j)) < 8) break;
            }
        }
        if !(c_transpiler_pre_increment(*(i)) < 4) break;
    }
    return savings;
}

sum_probs_over_prev_coef_context :: (probs: *[12] u32, out: *u32) {
    j: s32 = ---;
    for i: 0..cast(s32) 12 - 1 {
        j = 0;
        while j < 3 {
            TMP := out[i];
            out[i] += probs[j][i];

            if out[i] < TMP {
                out[i] = U32_MAX;
            }
            j += 1;
        }
    }
}

globals_initialization_state_for_bitstream: u32;
initialize_globals_for_bitstream :: () {
    {
        state := atomic_load(*globals_initialization_state_for_bitstream);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_bitstream, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_bitstream) != 2 {}
            return;
        }
    }
    DEFAULT_COEF_COUNTS =
        [8] [3] [12] u32.[
            [3] [12] u32.[ [12] u32.[ u32.[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], u32.[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], u32.[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ], [12] u32.[ u32.[ 30190, 26544, 225, 24, 4, 0, 0, 0, 0, 0, 0, 4171593 ], u32.[ 26846, 25157, 1241, 130, 26, 6, 1, 0, 0, 0, 0, 149987 ], u32.[ 10484, 9538, 1006, 160, 36, 18, 0, 0, 0, 0, 0, 15104 ] ], [12] u32.[ u32.[ 25842, 40456, 1126, 83, 11, 2, 0, 0, 0, 0, 0, 0 ], u32.[ 9338, 8010, 512, 73, 7, 3, 2, 0, 0, 0, 0, 43294 ], u32.[ 1047, 751, 149, 31, 13, 6, 1, 0, 0, 0, 0, 879 ] ], [12] u32.[ u32.[ 26136, 9826, 252, 13, 0, 0, 0, 0, 0, 0, 0, 0 ], u32.[ 8134, 5574, 191, 14, 2, 0, 0, 0, 0, 0, 0, 35302 ], u32.[ 605, 677, 116, 9, 1, 0, 0, 0, 0, 0, 0, 611 ] ], [12] u32.[ u32.[ 10263, 15463, 283, 17, 0, 0, 0, 0, 0, 0, 0, 0 ], u32.[ 2773, 2191, 128, 9, 2, 2, 0, 0, 0, 0, 0, 10073 ], u32.[ 134, 125, 32, 4, 0, 2, 0, 0, 0, 0, 0, 50 ] ], [12] u32.[ u32.[ 10483, 2663, 23, 1, 0, 0, 0, 0, 0, 0, 0, 0 ], u32.[ 2137, 1251, 27, 1, 1, 0, 0, 0, 0, 0, 0, 14362 ], u32.[ 116, 156, 14, 2, 1, 0, 0, 0, 0, 0, 0, 190 ] ], [12] u32.[ u32.[ 40977, 27614, 412, 28, 0, 0, 0, 0, 0, 0, 0, 0 ], u32.[ 6113, 5213, 261, 22, 3, 0, 0, 0, 0, 0, 0, 26164 ], u32.[ 382, 312, 50, 14, 2, 0, 0, 0, 0, 0, 0, 345 ] ], [12] u32.[ u32.[ 0, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], u32.[ 0, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 319 ], u32.[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8 ] ] ],
            [3] [12] u32.[ [12] u32.[ u32.[ 3268, 19382, 1043, 250, 93, 82, 49, 26, 17, 8, 25, 82289 ], u32.[ 8758, 32110, 5436, 1832, 827, 668, 420, 153, 24, 0, 3, 52914 ], u32.[ 9337, 23725, 8487, 3954, 2107, 1836, 1069, 399, 59, 0, 0, 18620 ] ], [12] u32.[ u32.[ 12419, 8420, 452, 62, 9, 1, 0, 0, 0, 0, 0, 0 ], u32.[ 11715, 8705, 693, 92, 15, 7, 2, 0, 0, 0, 0, 53988 ], u32.[ 7603, 8585, 2306, 778, 270, 145, 39, 5, 0, 0, 0, 9136 ] ], [12] u32.[ u32.[ 15938, 14335, 1207, 184, 55, 13, 4, 1, 0, 0, 0, 0 ], u32.[ 7415, 6829, 1138, 244, 71, 26, 7, 0, 0, 0, 0, 9980 ], u32.[ 1580, 1824, 655, 241, 89, 46, 10, 2, 0, 0, 0, 429 ] ], [12] u32.[ u32.[ 19453, 5260, 201, 19, 0, 0, 0, 0, 0, 0, 0, 0 ], u32.[ 9173, 3758, 213, 22, 1, 1, 0, 0, 0, 0, 0, 9820 ], u32.[ 1689, 1277, 276, 51, 17, 4, 0, 0, 0, 0, 0, 679 ] ], [12] u32.[ u32.[ 12076, 10667, 620, 85, 19, 9, 5, 0, 0, 0, 0, 0 ], u32.[ 4665, 3625, 423, 55, 19, 9, 0, 0, 0, 0, 0, 5127 ], u32.[ 415, 440, 143, 34, 20, 7, 2, 0, 0, 0, 0, 101 ] ], [12] u32.[ u32.[ 12183, 4846, 115, 11, 1, 0, 0, 0, 0, 0, 0, 0 ], u32.[ 4226, 3149, 177, 21, 2, 0, 0, 0, 0, 0, 0, 7157 ], u32.[ 375, 621, 189, 51, 11, 4, 1, 0, 0, 0, 0, 198 ] ], [12] u32.[ u32.[ 61658, 37743, 1203, 94, 10, 3, 0, 0, 0, 0, 0, 0 ], u32.[ 15514, 11563, 903, 111, 14, 5, 0, 0, 0, 0, 0, 25195 ], u32.[ 929, 1077, 291, 78, 14, 7, 1, 0, 0, 0, 0, 507 ] ], [12] u32.[ u32.[ 0, 990, 15, 3, 0, 0, 0, 0, 0, 0, 0, 0 ], u32.[ 0, 412, 13, 0, 0, 0, 0, 0, 0, 0, 0, 1641 ], u32.[ 0, 18, 7, 1, 0, 0, 0, 0, 0, 0, 0, 30 ] ] ],
            [3] [12] u32.[ [12] u32.[ u32.[ 953, 24519, 628, 120, 28, 12, 4, 0, 0, 0, 0, 2248798 ], u32.[ 1525, 25654, 2647, 617, 239, 143, 42, 5, 0, 0, 0, 66837 ], u32.[ 1180, 11011, 3001, 1237, 532, 448, 239, 54, 5, 0, 0, 7122 ] ], [12] u32.[ u32.[ 1356, 2220, 67, 10, 4, 1, 0, 0, 0, 0, 0, 0 ], u32.[ 1450, 2544, 102, 18, 4, 3, 0, 0, 0, 0, 0, 57063 ], u32.[ 1182, 2110, 470, 130, 41, 21, 0, 0, 0, 0, 0, 6047 ] ], [12] u32.[ u32.[ 370, 3378, 200, 30, 5, 4, 1, 0, 0, 0, 0, 0 ], u32.[ 293, 1006, 131, 29, 11, 0, 0, 0, 0, 0, 0, 5404 ], u32.[ 114, 387, 98, 23, 4, 8, 1, 0, 0, 0, 0, 236 ] ], [12] u32.[ u32.[ 579, 194, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], u32.[ 395, 213, 5, 1, 0, 0, 0, 0, 0, 0, 0, 4157 ], u32.[ 119, 122, 4, 0, 0, 0, 0, 0, 0, 0, 0, 300 ] ], [12] u32.[ u32.[ 38, 557, 19, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], u32.[ 21, 114, 12, 1, 0, 0, 0, 0, 0, 0, 0, 427 ], u32.[ 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7 ] ], [12] u32.[ u32.[ 52, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], u32.[ 18, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 652 ], u32.[ 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 30 ] ], [12] u32.[ u32.[ 640, 569, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], u32.[ 25, 77, 2, 0, 0, 0, 0, 0, 0, 0, 0, 517 ], u32.[ 4, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3 ] ], [12] u32.[ u32.[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], u32.[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], u32.[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ] ],
            [3] [12] u32.[ [12] u32.[ u32.[ 2506, 20161, 2707, 767, 261, 178, 107, 30, 14, 3, 0, 100694 ], u32.[ 8806, 36478, 8817, 3268, 1280, 850, 401, 114, 42, 0, 0, 58572 ], u32.[ 11003, 27214, 11798, 5716, 2482, 2072, 1048, 175, 32, 0, 0, 19284 ] ], [12] u32.[ u32.[ 9738, 11313, 959, 205, 70, 18, 11, 1, 0, 0, 0, 0 ], u32.[ 12628, 15085, 1507, 273, 52, 19, 9, 0, 0, 0, 0, 54280 ], u32.[ 10701, 15846, 5561, 1926, 813, 570, 249, 36, 0, 0, 0, 6460 ] ], [12] u32.[ u32.[ 6781, 22539, 2784, 634, 182, 123, 20, 4, 0, 0, 0, 0 ], u32.[ 6263, 11544, 2649, 790, 259, 168, 27, 5, 0, 0, 0, 20539 ], u32.[ 3109, 4075, 2031, 896, 457, 386, 158, 29, 0, 0, 0, 1138 ] ], [12] u32.[ u32.[ 11515, 4079, 465, 73, 5, 14, 2, 0, 0, 0, 0, 0 ], u32.[ 9361, 5834, 650, 96, 24, 8, 4, 0, 0, 0, 0, 22181 ], u32.[ 4343, 3974, 1360, 415, 132, 96, 14, 1, 0, 0, 0, 1267 ] ], [12] u32.[ u32.[ 4787, 9297, 823, 168, 44, 12, 4, 0, 0, 0, 0, 0 ], u32.[ 3619, 4472, 719, 198, 60, 31, 3, 0, 0, 0, 0, 8401 ], u32.[ 1157, 1175, 483, 182, 88, 31, 8, 0, 0, 0, 0, 268 ] ], [12] u32.[ u32.[ 8299, 1226, 32, 5, 1, 0, 0, 0, 0, 0, 0, 0 ], u32.[ 3502, 1568, 57, 4, 1, 1, 0, 0, 0, 0, 0, 9811 ], u32.[ 1055, 1070, 166, 29, 6, 1, 0, 0, 0, 0, 0, 527 ] ], [12] u32.[ u32.[ 27414, 27927, 1989, 347, 69, 26, 0, 0, 0, 0, 0, 0 ], u32.[ 5876, 10074, 1574, 341, 91, 24, 4, 0, 0, 0, 0, 21954 ], u32.[ 1571, 2171, 778, 324, 124, 65, 16, 0, 0, 0, 0, 979 ] ], [12] u32.[ u32.[ 0, 29, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], u32.[ 0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 459 ], u32.[ 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13 ] ] ]
        ];
    VP8CX_BASE_SKIP_FALSE_PROB =
        s32.[
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            255,
            251,
            248,
            244,
            240,
            236,
            232,
            229,
            225,
            221,
            217,
            213,
            208,
            204,
            199,
            194,
            190,
            187,
            183,
            179,
            175,
            172,
            168,
            164,
            160,
            157,
            153,
            149,
            145,
            142,
            138,
            134,
            130,
            127,
            124,
            120,
            117,
            114,
            110,
            107,
            104,
            101,
            98,
            95,
            92,
            89,
            86,
            83,
            80,
            77,
            74,
            71,
            68,
            65,
            62,
            59,
            56,
            53,
            50,
            47,
            44,
            41,
            38,
            35,
            32,
            30,
            28,
            26,
            24,
            22,
            20,
            18,
            16
        ];
    atomic_store(*globals_initialization_state_for_bitstream, 2);
}

VP8_HEADER :: struct {
    bitfield_storage_0: [1] u8 #align 1;
    bitfield_storage_1: [2] u8 #align 1;
    layout_padding_2: [1] u8 #align 1;
    alignment_marker_3: [0] u8 #align 4;
} #no_padding;

