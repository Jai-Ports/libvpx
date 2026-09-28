VP8_BITS_PER_MB: [2] [128] s32;

PRIOR_KEY_FRAME_WEIGHT: [5] u32;

GF_INTERVAL_TABLE: [101] s32;

KF_GF_BOOST_QLIMITS: [128] s32;

GF_ADJUST_TABLE: [101] s32;

GF_INTRA_USAGE_ADJUSTMENT: [20] s32;

VP8_GF_BOOST_QADJUSTMENT: [128] s32;

KF_BOOST_QADJUSTMENT: [128] s32;

vp8_set_reference_value_in_ratectrl :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_ratectrl :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_ratectrl :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_ratectrl :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_ratectrl :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_ratectrl :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_ratectrl :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_ratectrl :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_ratectrl :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_ratectrl :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_ratectrl :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_ratectrl :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_ratectrl :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_ratectrl :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_ratectrl :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_ratectrl :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_ratectrl :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_ratectrl :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_ratectrl :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_ratectrl :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_ratectrl :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_ratectrl :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_ratectrl :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_ratectrl :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_ratectrl :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_ratectrl :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

scale2_ratio_in_ratectrl :: (mode: s32, hr: *s32, hs: *s32) {
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

validate_buffer_in_ratectrl :: (start: *u8, len: u64, end: *u8, error: *Internal_Error_Info) -> s32 {
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

vp8_encode_bool_in_ratectrl :: (bc: *BOOL_CODER, bit: s32, probability: s32) {
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

        validate_buffer_in_ratectrl(bc.buffer + bc.pos, 1, bc.buffer_end, bc.error);
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

vp8_cost_branch_in_ratectrl :: (ct: *u32, p: Vp8_Prob) -> u32 {
    return cast,no_check(u32) ((((cast,no_check(u64) ct[0]) * cast(u64) VP8_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP8_PROB_COST[255 - cast(s32) p]) >> 8);
}

vp8_treed_write_in_ratectrl :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) {
    i: Vp8_Tree_Index = 0;

    while true {
        {
            B := v >> ((c_transpiler_pre_decrement(*(n))) & 31) & 1;
            vp8_encode_bool_in_ratectrl(W, B, cast,no_check(s32) P[(cast(s32) i) >> 1]);
            i = t[(cast(s32) i) + B];
        }
        if n == 0 break;
    }
}

vp8_write_token_in_ratectrl :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) {
    vp8_treed_write_in_ratectrl(W, t, P, X.value, X.len);
}

vp8_treed_cost_in_ratectrl :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) -> s32 {
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

vp8_cost_token_in_ratectrl :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) -> s32 {
    return vp8_treed_cost_in_ratectrl(t, P, X.value, X.len);
}

vp8_sem_wait_in_ratectrl :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_0: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_0; assignment_0; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init_in_ratectrl :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release_in_ratectrl :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

atomic_load_acquire_in_ratectrl :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_atomic_spin_wait_in_ratectrl :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire_in_ratectrl(last_row_current_mb_col) - NSYNC {
    }
}

mv_bias_in_ratectrl :: (refmb_ref_frame_sign_bias: s32, refframe: s32, mvp: *Int_Mv_in_mv, ref_frame_sign_bias: *s32) {
    if refmb_ref_frame_sign_bias != ref_frame_sign_bias[refframe] {
        mvp.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.row) * -1);
        mvp.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.col) * -1);
    }
}

vp8_clamp_mv2_in_ratectrl :: (mv: *Int_Mv_in_mv, xd: *MACROBLOCKD_in_blockd) {
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

vp8_clamp_mv_in_ratectrl :: (
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

vp8_check_mv_bounds_in_ratectrl :: (
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

left_block_mv_in_ratectrl :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> u32 {
    if b & 3 == 0 {
        cur_mb -= 1;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 4;
    }

    return (((cur_mb.bmi.data + b - 1)).mv).as_int;
}

above_block_mv_in_ratectrl :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> u32 {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 16;
    }

    return (((cur_mb.bmi.data + (b - 4))).mv).as_int;
}

left_block_mode_in_ratectrl :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> B_PREDICTION_MODE {
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

above_block_mode_in_ratectrl :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> B_PREDICTION_MODE {
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

vp8_save_coding_context :: (cpi: *VP8_COMP) {
    CC := *cpi.coding_context;

    CC.frames_since_key = cpi.frames_since_key;
    CC.filter_level = cpi.common.filter_level;
    CC.frames_till_gf_update_due = cpi.frames_till_gf_update_due;
    CC.frames_since_golden = cast,no_check(u32) cpi.frames_since_golden;

    {
        #assert CC.mvc.count * size_of(MV_CONTEXT) == cpi.common.fc.mvc.count * size_of(MV_CONTEXT);

        copy_memory(CC.mvc.data, cpi.common.fc.mvc.data, cpi.common.fc.mvc.count * size_of(MV_CONTEXT));
    }
    {
        #assert CC.mvcosts.count * size_of([2048] s32) == cpi.rd_costs.mvcosts.count * size_of([2048] s32);

        copy_memory(CC.mvcosts.data, cpi.rd_costs.mvcosts.data, cpi.rd_costs.mvcosts.count * size_of([2048] s32));
    }

    {
        #assert CC.ymode_prob.count == cpi.common.fc.ymode_prob.count;

        copy_memory(CC.ymode_prob.data, cpi.common.fc.ymode_prob.data, cpi.common.fc.ymode_prob.count);
    }
    {
        #assert CC.uv_mode_prob.count == cpi.common.fc.uv_mode_prob.count;

        copy_memory(CC.uv_mode_prob.data, cpi.common.fc.uv_mode_prob.data, cpi.common.fc.uv_mode_prob.count);
    }

    {
        #assert CC.ymode_count.count * size_of(s32) == cpi.mb.ymode_count.count * size_of(s32);

        copy_memory(CC.ymode_count.data, cpi.mb.ymode_count.data, cpi.mb.ymode_count.count * size_of(s32));
    }
    {
        #assert CC.uv_mode_count.count * size_of(s32) == cpi.mb.uv_mode_count.count * size_of(s32);

        copy_memory(CC.uv_mode_count.data, cpi.mb.uv_mode_count.data, cpi.mb.uv_mode_count.count * size_of(s32));
    }

    CC.this_frame_percent_intra = cpi.this_frame_percent_intra;
}

vp8_restore_coding_context :: (cpi: *VP8_COMP) {
    CC := *cpi.coding_context;

    cpi.frames_since_key = CC.frames_since_key;
    cpi.common.filter_level = CC.filter_level;
    cpi.frames_till_gf_update_due = CC.frames_till_gf_update_due;
    cpi.frames_since_golden = cast,no_check(s32) CC.frames_since_golden;

    {
        #assert cpi.common.fc.mvc.count * size_of(MV_CONTEXT) == CC.mvc.count * size_of(MV_CONTEXT);

        copy_memory(cpi.common.fc.mvc.data, CC.mvc.data, CC.mvc.count * size_of(MV_CONTEXT));
    }

    {
        #assert cpi.rd_costs.mvcosts.count * size_of([2048] s32) == CC.mvcosts.count * size_of([2048] s32);

        copy_memory(cpi.rd_costs.mvcosts.data, CC.mvcosts.data, CC.mvcosts.count * size_of([2048] s32));
    }

    {
        #assert cpi.common.fc.ymode_prob.count == CC.ymode_prob.count;

        copy_memory(cpi.common.fc.ymode_prob.data, CC.ymode_prob.data, CC.ymode_prob.count);
    }
    {
        #assert cpi.common.fc.uv_mode_prob.count == CC.uv_mode_prob.count;

        copy_memory(cpi.common.fc.uv_mode_prob.data, CC.uv_mode_prob.data, CC.uv_mode_prob.count);
    }

    {
        #assert cpi.mb.ymode_count.count * size_of(s32) == CC.ymode_count.count * size_of(s32);

        copy_memory(cpi.mb.ymode_count.data, CC.ymode_count.data, CC.ymode_count.count * size_of(s32));
    }
    {
        #assert cpi.mb.uv_mode_count.count * size_of(s32) == CC.uv_mode_count.count * size_of(s32);

        copy_memory(cpi.mb.uv_mode_count.data, CC.uv_mode_count.data, CC.uv_mode_count.count * size_of(s32));
    }

    cpi.this_frame_percent_intra = CC.this_frame_percent_intra;
}

vp8_setup_key_frame :: (cpi: *VP8_COMP) {
    vp8_default_coef_probs(*cpi.common);

    copy_memory(cpi.common.fc.mvc.data, VP8_DEFAULT_MV_CONTEXT.data, VP8_DEFAULT_MV_CONTEXT.count * size_of(MV_CONTEXT));
    {
        flag := s32.[ 1, 1 ];
        vp8_build_component_cost_table(cpi.mb.mvcost.data, cpi.common.fc.mvc.data, flag.data);
    }

    cpi.lfc_a = cpi.common.fc;
    cpi.lfc_g = cpi.common.fc;
    cpi.lfc_n = cpi.common.fc;

    cpi.common.filter_level = cpi.common.base_qindex * 3 / 8;

    if cpi.auto_gold != 0 {
        cpi.frames_till_gf_update_due = cpi.baseline_gf_interval;
    } else {
        cpi.frames_till_gf_update_due = 7;
    }

    cpi.common.refresh_golden_frame = 1;
    cpi.common.refresh_alt_ref_frame = 1;
}

vp8_update_rate_correction_factors :: (cpi: *VP8_COMP, damp_var: s32) {
    q := cpi.common.base_qindex;
    correction_factor: s32 = 100;

    adjustment_limit: float64 = ---;

    projected_size_based_on_q: s32 = 0;

    rate_correction_factor: float64 = ifx cpi.common.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon
        then cpi.key_frame_rate_correction_factor
        else ifx cpi.oxcf.number_of_layers == 1 &&
            cpi.gf_noboost_onepass_cbr == 0 &&
            (cpi.common.refresh_alt_ref_frame != 0 || cpi.common.refresh_golden_frame != 0)
            then cpi.gf_rate_correction_factor
            else cpi.rate_correction_factor;

    projected_size_based_on_q =
        cast,no_check(s32) ((0.5 + rate_correction_factor * VP8_BITS_PER_MB[cpi.common.frame_type][q]) *
            cpi.common.m_bs / 512.0);

    if cpi.mb.zbin_over_quant > 0 {
        z := cpi.mb.zbin_over_quant;
        factor: float64 = 0.99;
        factor_adjustment: float64 = 0.0000390625;

        while z > 0 {
            z -= 1;
            projected_size_based_on_q = cast,no_check(s32) (factor * projected_size_based_on_q);
            factor += factor_adjustment;

            if c_transpiler_float_greater_equal(factor, 0.999) {
                factor = 0.999;
            }
        }
    }

    if projected_size_based_on_q > 0 {
        correction_factor =
            cast,no_check(s32) ((100 * cast,no_check(s64) cpi.projected_frame_size) /
                cast(s64) projected_size_based_on_q);
    }

    if damp_var == {
        case 0;
            adjustment_limit = 0.75;
        case 1;
            adjustment_limit = 0.375;
        case 2; #through;
        case;
            adjustment_limit = 0.25;
    }

    if correction_factor > 102 {
        correction_factor = cast,no_check(s32) (100.5 + (correction_factor - 100) * adjustment_limit);
        rate_correction_factor = rate_correction_factor * correction_factor / 100.0;

        if c_transpiler_float_greater(rate_correction_factor, 50.0) {
            rate_correction_factor = 50.0;
        }
    } else if correction_factor < 99 {
        correction_factor = cast,no_check(s32) (100.5 - (100 - correction_factor) * adjustment_limit);
        rate_correction_factor = rate_correction_factor * correction_factor / 100.0;

        if c_transpiler_float_less(rate_correction_factor, 0.01) {
            rate_correction_factor = 0.01;
        }
    }

    if cpi.common.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
        cpi.key_frame_rate_correction_factor = rate_correction_factor;
    } else if cpi.oxcf.number_of_layers == 1 &&
        cpi.gf_noboost_onepass_cbr == 0 &&
        (cpi.common.refresh_alt_ref_frame != 0 || cpi.common.refresh_golden_frame != 0) {
        cpi.gf_rate_correction_factor = rate_correction_factor;
    } else {
        cpi.rate_correction_factor = rate_correction_factor;
    }
}

vp8_regulate_q :: (cpi: *VP8_COMP, target_bits_per_frame: s32) -> s32 {
    q := cpi.active_worst_quality;

    if cpi.force_maxqp == 1 {
        cpi.active_worst_quality = cpi.worst_quality;
        return cpi.worst_quality;
    }

    cpi.mb.zbin_over_quant = 0;

    if cpi.oxcf.fixed_q >= 0 {
        q = cpi.oxcf.fixed_q;

        if cpi.common.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
            q = cpi.oxcf.key_q;
        } else if cpi.oxcf.number_of_layers == 1 && cpi.common.refresh_alt_ref_frame != 0 && cpi.gf_noboost_onepass_cbr == 0 {
            q = cpi.oxcf.alt_q;
        } else if cpi.oxcf.number_of_layers == 1 && cpi.common.refresh_golden_frame != 0 && cpi.gf_noboost_onepass_cbr == 0 {
            q = cpi.oxcf.gold_q;
        }
    } else {
        last_error: s32 = 2147483647;
        target_bits_per_mb: s32 = ---;
        bits_per_mb_at_this_q: s32 = ---;

        correction_factor: float64 = ifx cpi.common.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon
            then cpi.key_frame_rate_correction_factor
            else ifx cpi.oxcf.number_of_layers == 1 &&
                cpi.gf_noboost_onepass_cbr == 0 &&
                (cpi.common.refresh_alt_ref_frame != 0 || cpi.common.refresh_golden_frame != 0)
                then cpi.gf_rate_correction_factor
                else cpi.rate_correction_factor;

        if target_bits_per_frame > S32_MAX >> 9 {
            temp := target_bits_per_frame / cpi.common.m_bs;
            if temp > S32_MAX >> 9 {
                target_bits_per_mb = 2147483647;
            } else {
                target_bits_per_mb = temp << 9;
            }
        } else {
            target_bits_per_mb = target_bits_per_frame << 9 / cpi.common.m_bs;
        }

        i := cpi.active_best_quality;

        while true {
            bits_per_mb_at_this_q =
                cast,no_check(s32) (0.5 +
                    correction_factor * VP8_BITS_PER_MB[cpi.common.frame_type][i]);

            if bits_per_mb_at_this_q <= target_bits_per_mb {
                if target_bits_per_mb - bits_per_mb_at_this_q <= last_error {
                    q = i;
                } else {
                    q = i - 1;
                }

                break;
            } else {
                last_error = bits_per_mb_at_this_q - target_bits_per_mb;
            }
            if !(c_transpiler_pre_increment(*(i)) <= cpi.active_worst_quality) break;
        }

        if q >= 127 {
            factor: float64 = 0.99;
            factor_adjustment: float64 = 0.0000390625;

            zbin_oqmax: s32 = ifx cpi.common.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon
                then cast(s32) 0
                else ifx cpi.oxcf.number_of_layers == 1 &&
                    cpi.gf_noboost_onepass_cbr == 0 &&
                    (cpi.common.refresh_alt_ref_frame != 0 || cpi.common.refresh_golden_frame != 0 && cpi.source_alt_ref_active == 0)
                    then cast(s32) 16
                    else 192;

            while cpi.mb.zbin_over_quant < zbin_oqmax {
                cpi.mb.zbin_over_quant += 1;

                if cpi.mb.zbin_over_quant > zbin_oqmax {
                    cpi.mb.zbin_over_quant = zbin_oqmax;
                }

                bits_per_mb_at_this_q = cast,no_check(s32) (factor * bits_per_mb_at_this_q);
                factor += factor_adjustment;

                if c_transpiler_float_greater_equal(factor, 0.999) {
                    factor = 0.999;
                }

                if bits_per_mb_at_this_q <= target_bits_per_mb {
                    break;
                }
            }
        }
    }

    if cpi.common.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon &&
        cpi.pass == 0 &&
        cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER &&
        cpi.oxcf.screen_content_mode != 0 {
        q = limit_q_cbr_inter(cpi.last_q[1], q);
    }

    return q;
}

limit_q_cbr_inter :: (last_q: s32, current_q: s32) -> s32 {
    limit_down: s32 = 12;
    if last_q - current_q > limit_down {
        return last_q - limit_down;
    } else {
        return current_q;
    }
}

vp8_adjust_key_frame_context :: (cpi: *VP8_COMP) {
    if cpi.pass != 2 && cpi.projected_frame_size > cpi.per_frame_bandwidth {
        overspend := cpi.projected_frame_size - cpi.per_frame_bandwidth;

        if cpi.oxcf.number_of_layers > 1 {
            cpi.kf_overspend_bits += overspend;
        } else {
            cpi.kf_overspend_bits += overspend * 7 / 8;
            cpi.gf_overspend_bits += overspend * 1 / 8;
        }

        cpi.kf_bitrate_adjustment = cpi.kf_overspend_bits / estimate_keyframe_frequency(cpi);
    }

    cpi.frames_since_key = 0;
    cpi.key_frame_count += 1;
}

estimate_keyframe_frequency :: (cpi: *VP8_COMP) -> s32 {
    av_key_frame_frequency: s32 = 0;

    if cpi.key_frame_count == 1 {
        key_freq := (ifx cpi.oxcf.key_freq > 0 then cpi.oxcf.key_freq else 1);
        av_key_frame_frequency = 1 + (cast,no_check(s32) cpi.output_framerate) * 2;

        if cpi.oxcf.auto_key != 0 && av_key_frame_frequency > key_freq {
            av_key_frame_frequency = key_freq;
        }

        cpi.prior_key_frame_distance[5 - 1] = av_key_frame_frequency;
    } else {
        total_weight: u32 = 0;
        last_kf_interval := cast,no_check(s32) ((ifx cpi.frames_since_key > 0 then cpi.frames_since_key else 1));

        for i: 0..cast(s32) 5 - 1 {
            if i < 5 - 1 {
                cpi.prior_key_frame_distance[i] = cpi.prior_key_frame_distance[i + 1];
            } else {
                cpi.prior_key_frame_distance[i] = last_kf_interval;
            }

            av_key_frame_frequency = cast,no_check(s32) ((cast,no_check(u32) av_key_frame_frequency) + (PRIOR_KEY_FRAME_WEIGHT[i] * cast,no_check(u32) cpi.prior_key_frame_distance[i]));
            total_weight += PRIOR_KEY_FRAME_WEIGHT[i];
        }

        av_key_frame_frequency = cast,no_check(s32) ((cast,no_check(u32) av_key_frame_frequency) / total_weight);
    }

    if av_key_frame_frequency == 0 {
        av_key_frame_frequency = 1;
    }
    return av_key_frame_frequency;
}

vp8_compute_frame_size_bounds :: (cpi: *VP8_COMP, frame_under_shoot_limit: *s32, frame_over_shoot_limit: *s32) {
    if cpi.oxcf.fixed_q >= 0 {
        frame_under_shoot_limit.* = 0;
        frame_over_shoot_limit.* = 2147483647;
    } else {
        THIS_FRAME_TARGET := cast,no_check(s64) cpi.this_frame_target;
        over_shoot_limit, under_shoot_limit: s64 = ---;

        if cpi.common.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
            over_shoot_limit = (THIS_FRAME_TARGET * 9) / 8;
            under_shoot_limit = (THIS_FRAME_TARGET * 7) / 8;
        } else if cpi.oxcf.number_of_layers > 1 || cpi.common.refresh_alt_ref_frame != 0 || cpi.common.refresh_golden_frame != 0 {
            over_shoot_limit = (THIS_FRAME_TARGET * 9) / 8;
            under_shoot_limit = (THIS_FRAME_TARGET * 7) / 8;
        } else if cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER {
            if cpi.buffer_level >= (cpi.oxcf.optimal_buffer_level + cpi.oxcf.maximum_buffer_size) >> 1 {
                over_shoot_limit = (THIS_FRAME_TARGET * 12) / 8;
                under_shoot_limit = (THIS_FRAME_TARGET * 6) / 8;
            } else if cpi.buffer_level <= cpi.oxcf.optimal_buffer_level >> 1 {
                over_shoot_limit = (THIS_FRAME_TARGET * 10) / 8;
                under_shoot_limit = (THIS_FRAME_TARGET * 4) / 8;
            } else {
                over_shoot_limit = (THIS_FRAME_TARGET * 11) / 8;
                under_shoot_limit = (THIS_FRAME_TARGET * 5) / 8;
            }
        } else if cpi.oxcf.end_usage == USAGE_CONSTRAINED_QUALITY {
            over_shoot_limit = (THIS_FRAME_TARGET * 11) / 8;
            under_shoot_limit = (THIS_FRAME_TARGET * 2) / 8;
        } else {
            over_shoot_limit = (THIS_FRAME_TARGET * 11) / 8;
            under_shoot_limit = (THIS_FRAME_TARGET * 5) / 8;
        }

        over_shoot_limit += 200;
        under_shoot_limit -= 200;
        if under_shoot_limit < 0 {
            under_shoot_limit = 0;
        }
        if under_shoot_limit > 2147483647 {
            under_shoot_limit = 2147483647;
        }
        if over_shoot_limit > 2147483647 {
            over_shoot_limit = 2147483647;
        }
        frame_under_shoot_limit.* = cast,no_check(s32) under_shoot_limit;
        frame_over_shoot_limit.* = cast,no_check(s32) over_shoot_limit;
    }
}

vp8_pick_frame_size :: (cpi: *VP8_COMP) -> s32 {
    cm := *cpi.common;

    if cm.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
        calc_iframe_target_size(cpi);
    } else {
        calc_pframe_target_size(cpi);

        if cpi.drop_frame != 0 {
            cpi.drop_frame = 0;
            return 0;
        }
    }
    return 1;
}

calc_pframe_target_size :: (cpi: *VP8_COMP) {
    old_per_frame_bandwidth := cpi.per_frame_bandwidth;

    if cpi.current_layer > 0 {
        cpi.per_frame_bandwidth = cpi.layer_context[cpi.current_layer].avg_frame_size_for_layer;
    }

    min_frame_target: s32 = 0;

    if cpi.pass == 2 {
        min_frame_target = cpi.min_frame_bandwidth;

        if min_frame_target < cpi.av_per_frame_bandwidth >> 5 {
            min_frame_target = cpi.av_per_frame_bandwidth >> 5;
        }
    } else if min_frame_target < cpi.per_frame_bandwidth / 4 {
        min_frame_target = cpi.per_frame_bandwidth / 4;
    }

    if cpi.common.refresh_alt_ref_frame != 0 && cpi.oxcf.number_of_layers == 1 {
        if cpi.pass == 2 {
            cpi.per_frame_bandwidth = cpi.twopass.gf_bits;
            cpi.this_frame_target = cpi.per_frame_bandwidth;
        }
    } else if cpi.pass == 2 {
        cpi.this_frame_target = cpi.per_frame_bandwidth;
    } else {
        adjustment: s32 = ---;

        if cpi.kf_overspend_bits > 0 {
            adjustment =
                ifx cpi.kf_bitrate_adjustment <= cpi.kf_overspend_bits then cpi.kf_bitrate_adjustment else cpi.kf_overspend_bits;

            if adjustment > cpi.per_frame_bandwidth - min_frame_target {
                adjustment = cpi.per_frame_bandwidth - min_frame_target;
            }

            cpi.kf_overspend_bits -= adjustment;

            cpi.this_frame_target = cpi.per_frame_bandwidth - adjustment;

            if cpi.this_frame_target < min_frame_target {
                cpi.this_frame_target = min_frame_target;
            }
        } else {
            cpi.this_frame_target = cpi.per_frame_bandwidth;
        }

        if cpi.gf_overspend_bits > 0 && cpi.this_frame_target > min_frame_target {
            adjustment =
                ifx cpi.non_gf_bitrate_adjustment <= cpi.gf_overspend_bits then cpi.non_gf_bitrate_adjustment else cpi.gf_overspend_bits;

            if adjustment > cpi.this_frame_target - min_frame_target {
                adjustment = cpi.this_frame_target - min_frame_target;
            }

            cpi.gf_overspend_bits -= adjustment;
            cpi.this_frame_target -= adjustment;
        }

        if cpi.last_boost > 150 && cpi.frames_till_gf_update_due > 0 && cpi.current_gf_interval >= (cast(s32) 4) << 1 {
            adjustment = (cpi.last_boost - 100) >> 5;

            if adjustment > 10 {
                adjustment = 10;
            }

            adjustment = cpi.this_frame_target * adjustment / 100;

            if adjustment > cpi.this_frame_target - min_frame_target {
                adjustment = cpi.this_frame_target - min_frame_target;
            }

            if cpi.frames_since_golden == cpi.current_gf_interval >> 1 {
                adjustment = (cpi.current_gf_interval - 1) * adjustment;

                if adjustment > 10 * cpi.this_frame_target / 100 {
                    adjustment = 10 * cpi.this_frame_target / 100;
                }
                cpi.this_frame_target += adjustment;
            } else {
                cpi.this_frame_target -= adjustment;
            }
        }
    }

    if cpi.this_frame_target < min_frame_target {
        cpi.this_frame_target = min_frame_target;
    }

    if cpi.common.refresh_alt_ref_frame == 0 {
        cpi.inter_frame_target = cpi.this_frame_target;
    }

    if cpi.pass == 0 {
        if cpi.buffered_mode != 0 {
            one_percent_bits := cast,no_check(s32) (1 + cpi.oxcf.optimal_buffer_level / 100);

            if cpi.buffer_level < cpi.oxcf.optimal_buffer_level || cpi.bits_off_target < cpi.oxcf.optimal_buffer_level {
                percent_low: s32 = 0;

                if cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER && cpi.buffer_level < cpi.oxcf.optimal_buffer_level {
                    percent_low =
                        cast,no_check(s32) ((cpi.oxcf.optimal_buffer_level - cpi.buffer_level) /
                            cast(s64) one_percent_bits);
                } else if cpi.bits_off_target < 0 {
                    percent_low = cast,no_check(s32) (100 * -cpi.bits_off_target / (cpi.total_byte_count * 8));
                }

                if percent_low > cpi.oxcf.under_shoot_pct {
                    percent_low = cpi.oxcf.under_shoot_pct;
                } else if percent_low < 0 {
                    percent_low = 0;
                }

                cpi.this_frame_target -=
                    cast,no_check(s32) (((cast,no_check(s64) cpi.this_frame_target) * cast(s64) percent_low) /
                        200);

                if cpi.auto_worst_q != 0 && cpi.ni_frames > 150 {
                    critical_buffer_level: s64 = ifx cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER
                        then (ifx cpi.buffer_level < cpi.bits_off_target then cpi.buffer_level else cpi.bits_off_target)
                        else cpi.bits_off_target;

                    if critical_buffer_level < cpi.oxcf.optimal_buffer_level {
                        if critical_buffer_level > cpi.oxcf.optimal_buffer_level >> 2 {
                            qadjustment_range := cast,no_check(s64) (cpi.worst_quality - cpi.ni_av_qi);
                            above_base := critical_buffer_level - cpi.oxcf.optimal_buffer_level >> 2;

                            cpi.active_worst_quality =
                                cpi.worst_quality -
                                    cast,no_check(s32) (qadjustment_range * above_base / (cpi.oxcf.optimal_buffer_level * 3) >> 2);
                        } else {
                            cpi.active_worst_quality = cpi.worst_quality;
                        }
                    } else {
                        cpi.active_worst_quality = cpi.ni_av_qi;
                    }
                } else {
                    cpi.active_worst_quality = cpi.worst_quality;
                }
            } else {
                percent_high: s32 = 0;
                target := cast,no_check(s64) cpi.this_frame_target;

                if cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER && cpi.buffer_level > cpi.oxcf.optimal_buffer_level {
                    percent_high =
                        cast,no_check(s32) ((cpi.buffer_level - cpi.oxcf.optimal_buffer_level) /
                            cast(s64) one_percent_bits);
                } else if cpi.bits_off_target > cpi.oxcf.optimal_buffer_level {
                    if cpi.total_byte_count > 0 {
                        percent_high = cast,no_check(s32) (100 * cpi.bits_off_target / (cpi.total_byte_count * 8));
                    } else {
                        percent_high = cpi.oxcf.over_shoot_pct;
                    }
                }

                if percent_high > cpi.oxcf.over_shoot_pct {
                    percent_high = cpi.oxcf.over_shoot_pct;
                } else if percent_high < 0 {
                    percent_high = 0;
                }

                target += (target * cast(s64) percent_high) / 200;
                target = ifx target < 2147483647 then target else 2147483647;
                cpi.this_frame_target = cast,no_check(s32) target;

                if cpi.auto_worst_q != 0 && cpi.ni_frames > 150 {
                    cpi.active_worst_quality = cpi.ni_av_qi;
                } else {
                    cpi.active_worst_quality = cpi.worst_quality;
                }
            }

            cpi.active_best_quality = cpi.best_quality;

            if cpi.active_worst_quality <= cpi.active_best_quality {
                cpi.active_worst_quality = cpi.active_best_quality + 1;
            }

            if cpi.active_worst_quality > 127 {
                cpi.active_worst_quality = 127;
            }
        } else {
            cpi.active_worst_quality = cpi.worst_quality;
        }

        if cpi.oxcf.end_usage == USAGE_CONSTRAINED_QUALITY && cpi.active_worst_quality < cpi.cq_target_quality {
            cpi.active_worst_quality = cpi.cq_target_quality;
        }
    }

    if cpi.drop_frames_allowed != 0 &&
        cpi.oxcf.end_usage == USAGE_STREAM_FROM_SERVER &&
        cpi.common.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
        if cpi.buffer_level < 0 {
            cpi.drop_frame = 1;

            cpi.bits_off_target += cast,no_check(s64) cpi.av_per_frame_bandwidth;
            if cpi.bits_off_target > cpi.oxcf.maximum_buffer_size {
                cpi.bits_off_target = cast,no_check(s64) (cast,no_check(s32) cpi.oxcf.maximum_buffer_size);
            }
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
        }
    }

    if cpi.oxcf.error_resilient_mode == 0 && cpi.frames_till_gf_update_due == 0 && cpi.drop_frame == 0 {
        if cpi.gf_update_onepass_cbr == 0 {
            q := (ifx cpi.oxcf.fixed_q < 0 then cpi.last_q[INTER_FRAME_in_alloccommon] else cpi.oxcf.fixed_q);

            gf_frame_usage: s32 = 0;
            tot_mbs :=
                cpi.recent_ref_frame_usage[INTRA_FRAME] + cpi.recent_ref_frame_usage[LAST_FRAME] +
                    cpi.recent_ref_frame_usage[GOLDEN_FRAME] + cpi.recent_ref_frame_usage[ALTREF_FRAME];

            pct_gf_active := 100 * cpi.gf_active_count / (cpi.common.mb_rows * cpi.common.mb_cols);

            if tot_mbs != 0 {
                gf_frame_usage =
                    (cpi.recent_ref_frame_usage[GOLDEN_FRAME] + cpi.recent_ref_frame_usage[ALTREF_FRAME]) *
                        100 / tot_mbs;
            }

            if pct_gf_active > gf_frame_usage {
                gf_frame_usage = pct_gf_active;
            }

            if cpi.auto_gold != 0 {
                if cpi.pass == 0 && (cpi.this_frame_percent_intra < 15 || gf_frame_usage >= 5) {
                    cpi.common.refresh_golden_frame = 1;
                } else if cpi.pass == 2 {
                    cpi.common.refresh_golden_frame = 1;
                }
            }

            if cpi.common.refresh_golden_frame == 1 {
                if cpi.auto_adjust_gold_quantizer != 0 {
                    calc_gf_params(cpi);
                }

                if cpi.source_alt_ref_active == 0 {
                    if cpi.oxcf.fixed_q < 0 {
                        if cpi.pass == 2 {
                            cpi.this_frame_target = cpi.per_frame_bandwidth;
                        } else {
                            boost := cpi.last_boost;
                            frames_in_section := cpi.frames_till_gf_update_due + 1;
                            allocation_chunks := frames_in_section * 100 + (boost - 100);
                            bits_in_section :=
                                cast,no_check(s32) ((ifx 2147483647 < (cast,no_check(s64) cpi.inter_frame_target) *
                                    cast(s64) frames_in_section then 2147483647 else (cast,no_check(s64) cpi.inter_frame_target) * cast(s64) frames_in_section));

                            while boost > 1000 {
                                boost /= 2;
                                allocation_chunks /= 2;
                            }

                            if bits_in_section >> 7 > allocation_chunks {
                                cpi.this_frame_target = boost * (bits_in_section / allocation_chunks);
                            } else {
                                cpi.this_frame_target = boost * bits_in_section / allocation_chunks;
                            }
                        }
                    } else {
                        cpi.this_frame_target = estimate_bits_at_q(1, q, cpi.common.m_bs, 1.0) * cpi.last_boost / 100;
                    }
                } else {
                    cpi.this_frame_target = 0;
                }

                cpi.current_gf_interval = cpi.frames_till_gf_update_due;
            }
        } else {
            cpi.gf_noboost_onepass_cbr = cast(s32) (cpi.oxcf.gf_cbr_boost_pct <= 100);
            cpi.baseline_gf_interval = cpi.gf_interval_onepass_cbr;

            if cpi.zeromv_count > cpi.common.m_bs >> 1 {
                cpi.common.refresh_golden_frame = 1;
                cpi.this_frame_target =
                    cast,no_check(s32) ((cast,no_check(u32) cpi.this_frame_target) *
                        (100 + cpi.oxcf.gf_cbr_boost_pct) / 100);
            }
            cpi.frames_till_gf_update_due = cpi.baseline_gf_interval;
            cpi.current_gf_interval = cpi.frames_till_gf_update_due;
        }
    }

    cpi.per_frame_bandwidth = old_per_frame_bandwidth;
}

estimate_bits_at_q :: (frame_kind: s32, q: s32, m_bs: s32, correction_factor: float64) -> s32 {
    bpm := cast,no_check(s32) (0.5 + correction_factor * VP8_BITS_PER_MB[frame_kind][q]);

    if m_bs > (cast(s32) 1) << 11 {
        return bpm >> 9 * m_bs;
    } else {
        return (bpm * m_bs) >> 9;
    }
}

calc_gf_params :: (cpi: *VP8_COMP) {
    q := (ifx cpi.oxcf.fixed_q < 0 then cpi.last_q[INTER_FRAME_in_alloccommon] else cpi.oxcf.fixed_q);
    boost: s32 = 0;

    gf_frame_usage: s32 = 0;
    tot_mbs :=
        cpi.recent_ref_frame_usage[INTRA_FRAME] + cpi.recent_ref_frame_usage[LAST_FRAME] +
            cpi.recent_ref_frame_usage[GOLDEN_FRAME] + cpi.recent_ref_frame_usage[ALTREF_FRAME];

    pct_gf_active := 100 * cpi.gf_active_count / (cpi.common.mb_rows * cpi.common.mb_cols);

    if tot_mbs != 0 {
        gf_frame_usage =
            (cpi.recent_ref_frame_usage[GOLDEN_FRAME] + cpi.recent_ref_frame_usage[ALTREF_FRAME]) *
                100 / tot_mbs;
    }

    if pct_gf_active > gf_frame_usage {
        gf_frame_usage = pct_gf_active;
    }

    if cpi.pass != 2 {
        boost = VP8_GF_BOOST_QADJUSTMENT[q];

        boost =
            boost *
                GF_INTRA_USAGE_ADJUSTMENT[(ifx cpi.this_frame_percent_intra < 15 then cpi.this_frame_percent_intra else 14)] / 100;

        boost = boost * GF_ADJUST_TABLE[gf_frame_usage] / 100;

        if cpi.sf.recode_loop == 0 {
            if cpi.compressor_speed == 2 {
                boost = boost / 2;
            }
        }

        if boost > KF_GF_BOOST_QLIMITS[q] && cpi.pass == 0 {
            boost = KF_GF_BOOST_QLIMITS[q];
        } else if boost < 110 {
            boost = 110;
        }

        cpi.last_boost = boost;
    }

    if cpi.oxcf.fixed_q == -1 {
        if cpi.pass == 2 {
            cpi.frames_till_gf_update_due = cpi.baseline_gf_interval;
        } else {
            cpi.frames_till_gf_update_due = cpi.baseline_gf_interval;

            if cpi.last_boost > 750 {
                cpi.frames_till_gf_update_due += 1;
            }

            if cpi.last_boost > 1000 {
                cpi.frames_till_gf_update_due += 1;
            }

            if cpi.last_boost > 1250 {
                cpi.frames_till_gf_update_due += 1;
            }

            if cpi.last_boost >= 1500 {
                cpi.frames_till_gf_update_due += 1;
            }

            if GF_INTERVAL_TABLE[gf_frame_usage] > cpi.frames_till_gf_update_due {
                cpi.frames_till_gf_update_due = GF_INTERVAL_TABLE[gf_frame_usage];
            }

            if cpi.frames_till_gf_update_due > cpi.max_gf_interval {
                cpi.frames_till_gf_update_due = cpi.max_gf_interval;
            }
        }
    } else {
        cpi.frames_till_gf_update_due = cpi.baseline_gf_interval;
    }

    if cpi.pass != 2 {
        cpi.source_alt_ref_pending = 0;
    }
}

calc_iframe_target_size :: (cpi: *VP8_COMP) {
    kf_boost: s32 = ---;
    target: u64 = ---;

    if cpi.oxcf.fixed_q >= 0 {
        q := cpi.oxcf.key_q;

        target =
            cast,no_check(u64) estimate_bits_at_q(
                cast,no_check(s32) (INTRA_FRAME),
                q,
                cpi.common.m_bs,
                cpi.key_frame_rate_correction_factor
            );
    } else if cpi.pass == 2 {
        target = cast,no_check(u64) cpi.per_frame_bandwidth;
    } else if cpi.common.current_video_frame == 0 {
        target = (cast,no_check(u64) cpi.oxcf.starting_buffer_level) / 2;

        if target > cast,no_check(u64) ((cpi.oxcf.target_bandwidth * 3) / 2) {
            target = cast,no_check(u64) ((cpi.oxcf.target_bandwidth * 3) / 2);
        }
    } else {
        q :=
            (ifx cpi.common.frame_flags & cast,no_check(s32) (FRAMEFLAGS_KEY) != 0 then cpi.avg_frame_qindex else cpi.ni_av_qi);

        initial_boost: s32 = 32;

        if cpi.oxcf.number_of_layers == 1 {
            kf_boost =
                ifx initial_boost > cast,no_check(s32) c_transpiler_math_round(2.0 * cpi.output_framerate -
                    16.0) then initial_boost else cast,no_check(s32) c_transpiler_math_round(2.0 * cpi.output_framerate - 16.0);

            K_MAX_KF_BOOST: s32 = 2000;
            if kf_boost > K_MAX_KF_BOOST {
                kf_boost = K_MAX_KF_BOOST;
            }
        } else {
            kf_boost = initial_boost;
        }

        kf_boost = kf_boost * KF_BOOST_QADJUSTMENT[q] / 100;

        if c_transpiler_float_less(cast,no_check(float64) cpi.frames_since_key, (cpi.output_framerate / 2.0)) {
            kf_boost =
                cast,no_check(s32) (((cast,no_check(u32) kf_boost) * cpi.frames_since_key) /
                    (cpi.output_framerate / 2.0));
        }

        if kf_boost < 16 {
            kf_boost = 16;
        }

        target = ((cast,no_check(u64) (16 + kf_boost)) * cast,no_check(u64) cpi.per_frame_bandwidth) >> 4;
        target = ifx 2147483647 < target then 2147483647 else target;
    }

    if cpi.oxcf.rc_max_intra_bitrate_pct != 0 {
        product := cast,no_check(u64) cpi.per_frame_bandwidth;
        product *= cast,no_check(u64) cpi.oxcf.rc_max_intra_bitrate_pct;
        product /= 100;
        max_rate := cast,no_check(u32) ((ifx 2147483647 < product then 2147483647 else product));

        if target > cast,no_check(u64) max_rate {
            target = cast,no_check(u64) max_rate;
        }
    }

    cpi.this_frame_target = cast,no_check(s32) target;

    if cpi.pass != 2 {
        cpi.active_worst_quality = cpi.worst_quality;
    }
}

vp8_drop_encodedframe_overshoot :: (cpi: *VP8_COMP, q: s32) -> s32 {
    force_drop_overshoot: s32 = 0;

    if cpi.common.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon &&
        (cpi.oxcf.screen_content_mode == 2 ||
            cpi.drop_frames_allowed != 0 &&
                (force_drop_overshoot != 0 ||
                    c_transpiler_float_less(cpi.rate_correction_factor, 0.08) &&
                        cpi.frames_since_last_drop_overshoot > cast,no_check(s32) cpi.framerate)) {
        thresh_qp := (3 * cpi.worst_quality) >> 2;

        thresh_rate := 2 * cpi.av_per_frame_bandwidth >> 3;

        thresh_pred_err_mb: s32 = (cast(s32) 200) << 4;
        pred_err_mb := cast,no_check(s32) (cpi.mb.prediction_error / cast(s64) cpi.common.m_bs);

        if cpi.drop_frames_allowed != 0 && pred_err_mb > thresh_pred_err_mb << 4 {
            thresh_rate = thresh_rate >> 3;
        }
        if q < thresh_qp &&
            cpi.projected_frame_size > thresh_rate &&
            pred_err_mb > thresh_pred_err_mb &&
            pred_err_mb > 2 * cpi.last_pred_err_mb ||
            force_drop_overshoot != 0 {
            i: u32 = ---;

            target_bits_per_mb: s32 = ---;
            TARGET_SIZE := cpi.av_per_frame_bandwidth;

            cpi.force_maxqp = 1;

            cpi.buffer_level = cpi.oxcf.optimal_buffer_level;
            cpi.bits_off_target = cpi.oxcf.optimal_buffer_level;

            if TARGET_SIZE > S32_MAX >> 9 {
                temp := TARGET_SIZE / cpi.common.m_bs;
                if temp > S32_MAX >> 9 {
                    target_bits_per_mb = 2147483647;
                } else {
                    target_bits_per_mb = temp << 9;
                }
            } else {
                target_bits_per_mb = TARGET_SIZE << 9 / cpi.common.m_bs;
            }

            new_correction_factor :=
                (cast,no_check(float64) target_bits_per_mb) /
                    cast,no_check(float64) VP8_BITS_PER_MB[INTER_FRAME_in_alloccommon][cpi.worst_quality];
            if c_transpiler_float_greater(new_correction_factor, cpi.rate_correction_factor) {
                cpi.rate_correction_factor =
                    ifx c_transpiler_float_less((2.0 * cpi.rate_correction_factor), new_correction_factor) then 2.0 *
                        cpi.rate_correction_factor else new_correction_factor;
            }
            if c_transpiler_float_greater(cpi.rate_correction_factor, 50.0) {
                cpi.rate_correction_factor = 50.0;
            }

            cpi.common.current_video_frame += 1;
            cpi.frames_since_key += 1;
            cpi.temporal_pattern_counter += 1;
            cpi.frames_since_last_drop_overshoot = 0;
            if cpi.oxcf.number_of_layers > 1 {
                i = 0;
                while i < cpi.oxcf.number_of_layers {
                    lc := cpi.layer_context.data + i;
                    lc.force_maxqp = 1;
                    lc.frames_since_last_drop_overshoot = 0;
                    lc.rate_correction_factor = cpi.rate_correction_factor;
                    i += 1;
                }
            }

            return 1;
        }
        cpi.force_maxqp = 0;
        cpi.frames_since_last_drop_overshoot += 1;

        return 0;
    }
    cpi.force_maxqp = 0;
    cpi.frames_since_last_drop_overshoot += 1;

    return 0;
}

clip_pixel_in_ratectrl :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_ratectrl :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_ratectrl :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_ratectrl :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_ratectrl :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_ratectrl(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_ratectrl(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_ratectrl(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_ratectrl :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

globals_initialization_state_for_ratectrl: u32;
initialize_globals_for_ratectrl :: () {
    {
        state := atomic_load(*globals_initialization_state_for_ratectrl);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_ratectrl, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_ratectrl) != 2 {}
            return;
        }
    }
    VP8_BITS_PER_MB =
        [128] s32.[
            s32.[ 1125000, 900000, 750000, 642857, 562500, 500000, 450000, 450000, 409090, 375000, 346153, 321428, 300000, 281250, 264705, 264705, 250000, 236842, 225000, 225000, 214285, 214285, 204545, 204545, 195652, 195652, 187500, 180000, 180000, 173076, 166666, 160714, 155172, 150000, 145161, 140625, 136363, 132352, 128571, 125000, 121621, 121621, 118421, 115384, 112500, 109756, 107142, 104651, 102272, 100000, 97826, 97826, 95744, 93750, 91836, 90000, 88235, 86538, 84905, 83333, 81818, 80357, 78947, 77586, 76271, 75000, 73770, 72580, 71428, 70312, 69230, 68181, 67164, 66176, 65217, 64285, 63380, 62500, 61643, 60810, 60000, 59210, 59210, 58441, 57692, 56962, 56250, 55555, 54878, 54216, 53571, 52941, 52325, 51724, 51136, 50561, 49450, 48387, 47368, 46875, 45918, 45000, 44554, 44117, 43269, 42452, 41666, 40909, 40178, 39473, 38793, 38135, 36885, 36290, 35714, 35156, 34615, 34090, 33582, 33088, 32608, 32142, 31468, 31034, 30405, 29801, 29220, 28662 ],
            s32.[ 712500, 570000, 475000, 407142, 356250, 316666, 285000, 259090, 237500, 219230, 203571, 190000, 178125, 167647, 158333, 150000, 142500, 135714, 129545, 123913, 118750, 114000, 109615, 105555, 101785, 98275, 95000, 91935, 89062, 86363, 83823, 81428, 79166, 77027, 75000, 73076, 71250, 69512, 67857, 66279, 64772, 63333, 61956, 60638, 59375, 58163, 57000, 55882, 54807, 53773, 52777, 51818, 50892, 50000, 49137, 47500, 45967, 44531, 43181, 41911, 40714, 39583, 38513, 37500, 36538, 35625, 34756, 33928, 33139, 32386, 31666, 30978, 30319, 29687, 29081, 28500, 27941, 27403, 26886, 26388, 25909, 25446, 25000, 24568, 23949, 23360, 22800, 22265, 21755, 21268, 20802, 20357, 19930, 19520, 19127, 18750, 18387, 18037, 17701, 17378, 17065, 16764, 16473, 16101, 15745, 15405, 15079, 14766, 14467, 14179, 13902, 13636, 13380, 13133, 12895, 12666, 12445, 12179, 11924, 11632, 11445, 11220, 11003, 10795, 10594, 10401, 10215, 10035 ]
        ];
    KF_BOOST_QADJUSTMENT =
        s32.[
            128,
            129,
            130,
            131,
            132,
            133,
            134,
            135,
            136,
            137,
            138,
            139,
            140,
            141,
            142,
            143,
            144,
            145,
            146,
            147,
            148,
            149,
            150,
            151,
            152,
            153,
            154,
            155,
            156,
            157,
            158,
            159,
            160,
            161,
            162,
            163,
            164,
            165,
            166,
            167,
            168,
            169,
            170,
            171,
            172,
            173,
            174,
            175,
            176,
            177,
            178,
            179,
            180,
            181,
            182,
            183,
            184,
            185,
            186,
            187,
            188,
            189,
            190,
            191,
            192,
            193,
            194,
            195,
            196,
            197,
            198,
            199,
            200,
            200,
            201,
            201,
            202,
            203,
            203,
            203,
            204,
            204,
            205,
            205,
            206,
            206,
            207,
            207,
            208,
            208,
            209,
            209,
            210,
            210,
            211,
            211,
            212,
            212,
            213,
            213,
            214,
            214,
            215,
            215,
            216,
            216,
            217,
            217,
            218,
            218,
            219,
            219,
            220,
            220,
            220,
            220,
            220,
            220,
            220,
            220,
            220,
            220,
            220,
            220,
            220,
            220,
            220,
            220
        ];
    VP8_GF_BOOST_QADJUSTMENT =
        s32.[
            80,
            82,
            84,
            86,
            88,
            90,
            92,
            94,
            96,
            97,
            98,
            99,
            100,
            101,
            102,
            103,
            104,
            105,
            106,
            107,
            108,
            109,
            110,
            111,
            112,
            113,
            114,
            115,
            116,
            117,
            118,
            119,
            120,
            121,
            122,
            123,
            124,
            125,
            126,
            127,
            128,
            129,
            130,
            131,
            132,
            133,
            134,
            135,
            136,
            137,
            138,
            139,
            140,
            141,
            142,
            143,
            144,
            145,
            146,
            147,
            148,
            149,
            150,
            151,
            152,
            153,
            154,
            155,
            156,
            157,
            158,
            159,
            160,
            161,
            162,
            163,
            164,
            165,
            166,
            167,
            168,
            169,
            170,
            171,
            172,
            173,
            174,
            175,
            176,
            177,
            178,
            179,
            180,
            181,
            182,
            183,
            184,
            184,
            185,
            185,
            186,
            186,
            187,
            187,
            188,
            188,
            189,
            189,
            190,
            190,
            191,
            191,
            192,
            192,
            193,
            193,
            194,
            194,
            194,
            194,
            195,
            195,
            196,
            196,
            197,
            197,
            198,
            198
        ];
    KF_GF_BOOST_QLIMITS =
        s32.[
            150,
            155,
            160,
            165,
            170,
            175,
            180,
            185,
            190,
            195,
            200,
            205,
            210,
            215,
            220,
            225,
            230,
            235,
            240,
            245,
            250,
            255,
            260,
            265,
            270,
            275,
            280,
            285,
            290,
            295,
            300,
            305,
            310,
            320,
            330,
            340,
            350,
            360,
            370,
            380,
            390,
            400,
            410,
            420,
            430,
            440,
            450,
            460,
            470,
            480,
            490,
            500,
            510,
            520,
            530,
            540,
            550,
            560,
            570,
            580,
            590,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600,
            600
        ];
    GF_ADJUST_TABLE =
        s32.[
            100,
            115,
            130,
            145,
            160,
            175,
            190,
            200,
            210,
            220,
            230,
            240,
            260,
            270,
            280,
            290,
            300,
            310,
            320,
            330,
            340,
            350,
            360,
            370,
            380,
            390,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400,
            400
        ];
    GF_INTRA_USAGE_ADJUSTMENT =
        s32.[
            125,
            120,
            115,
            110,
            105,
            100,
            95,
            85,
            80,
            75,
            70,
            65,
            60,
            55,
            50,
            50,
            50,
            50,
            50,
            50
        ];
    GF_INTERVAL_TABLE =
        s32.[
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            7,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11
        ];
    PRIOR_KEY_FRAME_WEIGHT =
        u32.[
            1,
            2,
            3,
            4,
            5
        ];
    atomic_store(*globals_initialization_state_for_ratectrl, 2);
}

