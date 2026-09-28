vp8_temporal_filter_apply_c :: (
    frame1: *u8,
    stride: u32,
    frame2: *u8,
    block_size: u32,
    strength: s32,
    filter_weight: s32,
    accumulator: *u32,
    count: *u16
) {
    i, j, k: u32 = ---;
    modifier: s32 = ---;
    byte: s32 = 0;
    ROUNDING := (ifx strength > 0 then (cast(s32) 1) << (((strength - 1)) & 31) else 0);

    i = 0;
    k = 0;
    while i < block_size {
        j = 0;
        while j < block_size {
            src_byte := cast,no_check(s32) frame1[byte];
            pixel_value := cast,no_check(s32) ((c_transpiler_post_increment(*(frame2))).*);

            modifier = src_byte - pixel_value;

            modifier *= modifier;
            modifier *= 3;
            modifier += ROUNDING;
            c_transpiler_compound_shr(*(modifier), (((strength) & 31)), s32, s32);

            if modifier > 16 {
                modifier = 16;
            }

            modifier = 16 - modifier;
            modifier *= filter_weight;

            count[k] = cast,no_check(u16) ((cast,no_check(s32) count[k]) + modifier);
            accumulator[k] += cast,no_check(u32) (modifier * pixel_value);

            byte += 1;
            j += 1;
            k += 1;
        }

        byte = cast,no_check(s32) ((cast,no_check(u32) byte) + (stride - block_size));
        i += 1;
    }
}

vp8_set_reference_value_in_temporal_filter :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_temporal_filter :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_temporal_filter :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_temporal_filter :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_temporal_filter :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_temporal_filter :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_temporal_filter :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_temporal_filter :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_temporal_filter :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_temporal_filter :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_temporal_filter :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_temporal_filter :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_temporal_filter :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_temporal_filter :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_temporal_filter :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_temporal_filter :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_temporal_filter :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_temporal_filter :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_temporal_filter :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_temporal_filter :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_temporal_filter :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_temporal_filter :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_temporal_filter :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_temporal_filter :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_temporal_filter :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_temporal_filter :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

scale2_ratio_in_temporal_filter :: (mode: s32, hr: *s32, hs: *s32) {
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

validate_buffer_in_temporal_filter :: (start: *u8, len: u64, end: *u8, error: *Internal_Error_Info) -> s32 {
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

vp8_encode_bool_in_temporal_filter :: (bc: *BOOL_CODER, bit: s32, probability: s32) {
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

        validate_buffer_in_temporal_filter(bc.buffer + bc.pos, 1, bc.buffer_end, bc.error);
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

vp8_cost_branch_in_temporal_filter :: (ct: *u32, p: Vp8_Prob) -> u32 {
    return cast,no_check(u32) ((((cast,no_check(u64) ct[0]) * cast(u64) VP8_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP8_PROB_COST[255 - cast(s32) p]) >> 8);
}

vp8_treed_write_in_temporal_filter :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) {
    i: Vp8_Tree_Index = 0;

    while true {
        {
            B := v >> ((c_transpiler_pre_decrement(*(n))) & 31) & 1;
            vp8_encode_bool_in_temporal_filter(W, B, cast,no_check(s32) P[(cast(s32) i) >> 1]);
            i = t[(cast(s32) i) + B];
        }
        if n == 0 break;
    }
}

vp8_write_token_in_temporal_filter :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) {
    vp8_treed_write_in_temporal_filter(W, t, P, X.value, X.len);
}

vp8_treed_cost_in_temporal_filter :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) -> s32 {
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

vp8_cost_token_in_temporal_filter :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) -> s32 {
    return vp8_treed_cost_in_temporal_filter(t, P, X.value, X.len);
}

vp8_sem_wait_in_temporal_filter :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_0: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_0; assignment_0; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init_in_temporal_filter :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release_in_temporal_filter :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

atomic_load_acquire_in_temporal_filter :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_atomic_spin_wait_in_temporal_filter :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire_in_temporal_filter(last_row_current_mb_col) - NSYNC {
    }
}

mv_bias_in_temporal_filter :: (
    refmb_ref_frame_sign_bias: s32,
    refframe: s32,
    mvp: *Int_Mv_in_mv,
    ref_frame_sign_bias: *s32
) {
    if refmb_ref_frame_sign_bias != ref_frame_sign_bias[refframe] {
        mvp.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.row) * -1);
        mvp.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.col) * -1);
    }
}

vp8_clamp_mv2_in_temporal_filter :: (mv: *Int_Mv_in_mv, xd: *MACROBLOCKD_in_blockd) {
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

vp8_clamp_mv_in_temporal_filter :: (
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

vp8_check_mv_bounds_in_temporal_filter :: (
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

left_block_mv_in_temporal_filter :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> u32 {
    if b & 3 == 0 {
        cur_mb -= 1;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 4;
    }

    return (((cur_mb.bmi.data + b - 1)).mv).as_int;
}

above_block_mv_in_temporal_filter :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> u32 {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 16;
    }

    return (((cur_mb.bmi.data + (b - 4))).mv).as_int;
}

left_block_mode_in_temporal_filter :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> B_PREDICTION_MODE {
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

above_block_mode_in_temporal_filter :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> B_PREDICTION_MODE {
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

vp8_temporal_filter_prepare_c :: (cpi: *VP8_COMP, distance: s32) {
    frame: s32 = 0;

    num_frames_backward: s32 = 0;
    num_frames_forward: s32 = 0;
    frames_to_blur_backward: s32 = 0;
    frames_to_blur_forward: s32 = 0;
    frames_to_blur: s32 = 0;
    start_frame: s32 = 0;

    strength := cpi.oxcf.arnr_strength;

    blur_type := cpi.oxcf.arnr_type;

    max_frames := cpi.active_arnr_frames;

    num_frames_backward = distance;
    num_frames_forward =
        cast,no_check(s32) (vp8_lookahead_depth(cpi.lookahead) -
            cast,no_check(u32) (num_frames_backward + 1));

    if blur_type == {
        case 1;
            frames_to_blur_backward = num_frames_backward;
            if frames_to_blur_backward >= max_frames {
                frames_to_blur_backward = max_frames - 1;
            }
            frames_to_blur = frames_to_blur_backward + 1;
        case 2;
            frames_to_blur_forward = num_frames_forward;
            if frames_to_blur_forward >= max_frames {
                frames_to_blur_forward = max_frames - 1;
            }
            frames_to_blur = frames_to_blur_forward + 1;
        case 3; #through;
        case;
            frames_to_blur_forward = num_frames_forward;
            frames_to_blur_backward = num_frames_backward;
            if frames_to_blur_forward > frames_to_blur_backward {
                frames_to_blur_forward = frames_to_blur_backward;
            }
            if frames_to_blur_backward > frames_to_blur_forward {
                frames_to_blur_backward = frames_to_blur_forward;
            }
            if frames_to_blur_forward > (max_frames - 1) / 2 {
                frames_to_blur_forward = (max_frames - 1) / 2;
            }
            if frames_to_blur_backward > max_frames / 2 {
                frames_to_blur_backward = max_frames / 2;
            }
            frames_to_blur = frames_to_blur_backward + frames_to_blur_forward + 1;
    }

    start_frame = distance + frames_to_blur_forward;

    fill_memory(cpi.frames.data, 0, cast,no_check(u64) max_frames * size_of(*YV12_BUFFER_CONFIG));
    frame = 0;
    while frame < frames_to_blur {
        which_buffer := start_frame - frame;
        buf := vp8_lookahead_peek(cpi.lookahead, cast,no_check(u32) which_buffer, 1);
        cpi.frames[frames_to_blur - 1 - frame] = *buf.img;
        frame += 1;
    }

    vp8_temporal_filter_iterate_c(cpi, frames_to_blur, frames_to_blur_backward, strength);
}

vp8_temporal_filter_iterate_c :: (cpi: *VP8_COMP, frame_count: s32, alt_ref_index: s32, strength: s32) {
    byte: s32 = ---;
    frame: s32 = ---;
    mb_col: s32 = ---;
    filter_weight: u32 = ---;
    mb_cols := cpi.common.mb_cols;
    mb_rows := cpi.common.mb_rows;
    mb_y_offset: s32 = 0;
    mb_uv_offset: s32 = 0;
    accumulator: [384] u32 = --- #align 16;
    count: [384] u16 = --- #align 16;
    mbd := *cpi.mb.e_mbd;
    f := cpi.frames[alt_ref_index];
    dst1, dst2: *u8 = ---;
    predictor: [384] u8 = --- #align 16;

    y_buffer: *u8 = mbd.pre.y_buffer;
    u_buffer: *u8 = mbd.pre.u_buffer;
    v_buffer: *u8 = mbd.pre.v_buffer;

    if 0 < mb_rows {
        for mb_row: 0..mb_rows - 1 {
            cpi.mb.mv_row_min = -(mb_row * 16 + cast,no_check(s32) ((16 - 5)));
            cpi.mb.mv_row_max = (cpi.common.mb_rows - 1 - mb_row) * 16 + cast,no_check(s32) ((16 - 5));

            mb_col = 0;
            while mb_col < mb_cols {
                i, j, k: s32 = ---;

                fill_memory(accumulator.data, 0, cast(u64) 384 * size_of(u32));
                fill_memory(count.data, 0, cast(u64) 384 * size_of(u16));

                cpi.mb.mv_col_min = -(mb_col * 16 + cast,no_check(s32) ((16 - 5)));
                cpi.mb.mv_col_max = (cpi.common.mb_cols - 1 - mb_col) * 16 + cast,no_check(s32) ((16 - 5));

                frame = 0;
                while frame < frame_count {
                    if cpi.frames[frame] == null {
                        frame += 1;
                        continue;
                    }

                    mbd.block[0].bmi.mv.as_mv.row = 0;
                    mbd.block[0].bmi.mv.as_mv.col = 0;

                    if frame == alt_ref_index {
                        filter_weight = 2;
                    } else {
                        err: s32 = 0;

                        err =
                            vp8_temporal_filter_find_matching_mb_c(
                                cpi,
                                cpi.frames[alt_ref_index],
                                cpi.frames[frame],
                                mb_y_offset,
                                10000
                            );

                        filter_weight = cast,no_check(u32) ((ifx err < 10000 then 2 else cast(s32) (err < 20000)));
                    }

                    if filter_weight != 0 {
                        vp8_temporal_filter_predictors_mb_c(
                            mbd,
                            cpi.frames[frame].y_buffer + mb_y_offset,
                            cpi.frames[frame].u_buffer + mb_uv_offset,
                            cpi.frames[frame].v_buffer + mb_uv_offset,
                            cpi.frames[frame].y_stride,
                            cast,no_check(s32) mbd.block[0].bmi.mv.as_mv.row,
                            cast,no_check(s32) mbd.block[0].bmi.mv.as_mv.col,
                            predictor.data
                        );

                        vp8_temporal_filter_apply_c(
                            f.y_buffer + mb_y_offset,
                            cast,no_check(u32) f.y_stride,
                            predictor.data,
                            16,
                            strength,
                            cast,no_check(s32) filter_weight,
                            accumulator.data,
                            count.data
                        );

                        vp8_temporal_filter_apply_c(
                            f.u_buffer + mb_uv_offset,
                            cast,no_check(u32) f.uv_stride,
                            predictor.data + 256,
                            8,
                            strength,
                            cast,no_check(s32) filter_weight,
                            accumulator.data + 256,
                            count.data + 256
                        );

                        vp8_temporal_filter_apply_c(
                            f.v_buffer + mb_uv_offset,
                            cast,no_check(u32) f.uv_stride,
                            predictor.data + 320,
                            8,
                            strength,
                            cast,no_check(s32) filter_weight,
                            accumulator.data + 320,
                            count.data + 320
                        );
                    }
                    frame += 1;
                }

                dst1 = cpi.alt_ref_buffer.y_buffer;
                stride := cpi.alt_ref_buffer.y_stride;
                byte = mb_y_offset;
                i = 0;
                k = 0;
                while i < 16 {
                    j = 0;
                    while j < 16 {
                        pval := accumulator[k] + cast,no_check(u32) ((cast(s32) count[k]) >> 1);
                        pval *= cast,no_check(u32) cpi.fixed_divide[count[k]];
                        c_transpiler_compound_shr(*(pval), (cast(s32) 19), u32, u32);

                        dst1[byte] = cast,no_check(u8) pval;

                        byte += 1;
                        j += 1;
                        k += 1;
                    }

                    byte += stride - 16;
                    i += 1;
                }

                dst1 = cpi.alt_ref_buffer.u_buffer;
                dst2 = cpi.alt_ref_buffer.v_buffer;
                stride = cpi.alt_ref_buffer.uv_stride;
                byte = mb_uv_offset;
                i = 0;
                k = 256;
                while i < 8 {
                    j = 0;
                    while j < 8 {
                        m := k + 64;

                        pval := accumulator[k] + cast,no_check(u32) ((cast(s32) count[k]) >> 1);
                        pval *= cast,no_check(u32) cpi.fixed_divide[count[k]];
                        c_transpiler_compound_shr(*(pval), (cast(s32) 19), u32, u32);
                        dst1[byte] = cast,no_check(u8) pval;

                        pval = accumulator[m] + cast,no_check(u32) ((cast(s32) count[m]) >> 1);
                        pval *= cast,no_check(u32) cpi.fixed_divide[count[m]];
                        c_transpiler_compound_shr(*(pval), (cast(s32) 19), u32, u32);
                        dst2[byte] = cast,no_check(u8) pval;

                        byte += 1;
                        j += 1;
                        k += 1;
                    }

                    byte += stride - 8;
                    i += 1;
                }

                mb_y_offset += 16;
                mb_uv_offset += 8;
                mb_col += 1;
            }

            mb_y_offset += 16 * (f.y_stride - mb_cols);
            mb_uv_offset += 8 * (f.uv_stride - mb_cols);
        }
    }

    mbd.pre.y_buffer = y_buffer;
    mbd.pre.u_buffer = u_buffer;
    mbd.pre.v_buffer = v_buffer;
}

vp8_temporal_filter_predictors_mb_c :: (
    x: *MACROBLOCKD_in_blockd,
    y_mb_ptr: *u8,
    u_mb_ptr: *u8,
    v_mb_ptr: *u8,
    stride: s32,
    mv_row: s32,
    mv_col: s32,
    pred: *u8
) {
    yptr: *u8 = ---;

    yptr = y_mb_ptr + mv_row >> 3 * stride + mv_col >> 3;

    if mv_row | mv_col & 7 != 0 {
        x.subpixel_predict16x16(yptr, stride, mv_col & 7, mv_row & 7, *pred[0], 16);
    } else {
        vp8_copy_mem16x16_c(yptr, stride, *pred[0], 16);
    }

    c_transpiler_compound_shr(*(mv_row), (cast(s32) 1), s32, s32);
    c_transpiler_compound_shr(*(mv_col), (cast(s32) 1), s32, s32);
    stride = (stride + 1) >> 1;
    offset := mv_row >> 3 * stride + mv_col >> 3;
    uptr := u_mb_ptr + offset;
    vptr := v_mb_ptr + offset;

    if mv_row | mv_col & 7 != 0 {
        x.subpixel_predict8x8(uptr, stride, mv_col & 7, mv_row & 7, *pred[256], 8);
        x.subpixel_predict8x8(vptr, stride, mv_col & 7, mv_row & 7, *pred[320], 8);
    } else {
        vp8_copy_mem8x8_c(uptr, stride, *pred[256], 8);
        vp8_copy_mem8x8_c(vptr, stride, *pred[320], 8);
    }
}

vp8_temporal_filter_find_matching_mb_c :: (
    cpi: *VP8_COMP,
    arf_frame: *YV12_BUFFER_CONFIG,
    frame_ptr: *YV12_BUFFER_CONFIG,
    mb_offset: s32,
    error_thresh: s32
) -> s32 {
    x := *cpi.mb;

    sadpb := x.sadperbit16;
    bestsme: s32 = 2147483647;

    b := x.block.data + 0;
    d := x.e_mbd.block.data + 0;
    best_ref_mv1: Int_Mv_in_mv = ---;
    best_ref_mv1_full: Int_Mv_in_mv = ---;

    base_src := b.base_src;
    src := b.src;
    src_stride := b.src_stride;
    base_pre: *u8 = x.e_mbd.pre.y_buffer;
    pre := d.offset;
    pre_stride := x.e_mbd.pre.y_stride;

    best_ref_mv1.as_int = 0;
    best_ref_mv1_full.as_mv.col = cast,no_check(s16) ((cast(s32) best_ref_mv1.as_mv.col) >> 3);
    best_ref_mv1_full.as_mv.row = cast,no_check(s16) ((cast(s32) best_ref_mv1.as_mv.row) >> 3);

    b.base_src = *arf_frame.y_buffer;
    b.src_stride = arf_frame.y_stride;
    b.src = mb_offset;

    x.e_mbd.pre.y_buffer = frame_ptr.y_buffer;
    x.e_mbd.pre.y_stride = frame_ptr.y_stride;
    d.offset = mb_offset;

    step_param: s32 = ifx cpi.speed < 8
        then cpi.sf.first_step + cast(s32) (cpi.speed > 5)
        else cpi.sf.first_step + 2;

    bestsme =
        vp8_hex_search(
            x,
            b,
            d,
            *best_ref_mv1_full,
            *d.bmi.mv,
            step_param,
            sadpb,
            cpi.fn_ptr.data + BLOCK_16X16,
            null,
            *best_ref_mv1
        );

    {
        distortion: s32 = ---;
        sse: u32 = ---;

        bestsme =
            cpi.find_fractional_mv_step(
                x,
                b,
                d,
                *d.bmi.mv,
                *best_ref_mv1,
                x.errorperbit,
                cpi.fn_ptr.data + BLOCK_16X16,
                null,
                *distortion,
                *sse
            );
    }

    b.base_src = base_src;
    b.src = src;
    b.src_stride = src_stride;
    x.e_mbd.pre.y_buffer = base_pre;
    d.offset = pre;
    x.e_mbd.pre.y_stride = pre_stride;

    return bestsme;
}

usec_timer_start_in_temporal_filter :: (t: *Usec_Timer) {
    clock_gettime(4, *t.begin);
}

usec_timer_mark_in_temporal_filter :: (t: *Usec_Timer) {
    clock_gettime(4, *t.end);
}

usec_timer_elapsed_in_temporal_filter :: (t: *Usec_Timer) -> s64 {
    diff: C_Transpiler_POSIX.timespec = ---;

    assignment_1: Time_T = (t.end.tv_sec - t.begin.tv_sec);
    (diff.tv_sec) = assignment_1;

    assignment_2: Syscall_Slong_T = (t.end.tv_nsec - t.begin.tv_nsec);
    (diff.tv_nsec) = assignment_2;

    if diff.tv_nsec < 0 {
        diff.tv_sec -= 1;

        c_transpiler_compound_add(*(diff.tv_nsec), (cast(Syscall_Slong_T) 1000000000), Syscall_Slong_T, Syscall_Slong_T);
    }
    return (diff.tv_sec * 1000000) + diff.tv_nsec / 1000;
}

