// Generated directly from C by cpp_transpiler.
vp8_init_mode_costs :: (c: *VP8_COMP) {
    x := *c.common;
    rd_costs: *Rd_Costs_Struct = *c.rd_costs;

    {
        T := cast(*Vp8_Tree_Index) *(VP8_BMODE_TREE);

        i: s32 = 0;

        while true {
            {
                j: s32 = 0;

                while true {
                    vp8_cost_tokens(rd_costs.bmode_costs[i][j].data, VP8_KF_BMODE_PROB[i][j].data, T);
                    if !(c_transpiler_pre_increment(*(j)) < (cast,no_check(s32) (B_HU_PRED)) + 1) break;
                }
            }
            if !(c_transpiler_pre_increment(*(i)) < (cast,no_check(s32) (B_HU_PRED)) + 1) break;
        }

        vp8_cost_tokens(rd_costs.inter_bmode_costs.data, x.fc.bmode_prob.data, T);
    }
    vp8_cost_tokens(
        rd_costs.inter_bmode_costs.data,
        x.fc.sub_mv_ref_prob.data,
        cast(*Vp8_Tree_Index) *(VP8_SUB_MV_REF_TREE)
    );

    vp8_cost_tokens(rd_costs.mbmode_cost[1].data, x.fc.ymode_prob.data, cast(*Vp8_Tree_Index) *(VP8_YMODE_TREE));
    vp8_cost_tokens(rd_costs.mbmode_cost[0].data, VP8_KF_YMODE_PROB.data, cast(*Vp8_Tree_Index) *(VP8_KF_YMODE_TREE));

    vp8_cost_tokens(
        rd_costs.intra_uv_mode_cost[1].data,
        x.fc.uv_mode_prob.data,
        cast(*Vp8_Tree_Index) *(VP8_UV_MODE_TREE)
    );
    vp8_cost_tokens(
        rd_costs.intra_uv_mode_cost[0].data,
        VP8_KF_UV_MODE_PROB.data,
        cast(*Vp8_Tree_Index) *(VP8_UV_MODE_TREE)
    );
}

vp8_set_reference_value_in_modecosts :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_modecosts :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_modecosts :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_modecosts :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_modecosts :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_modecosts :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_modecosts :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_modecosts :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_modecosts :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_modecosts :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_modecosts :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_modecosts :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_modecosts :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_modecosts :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_modecosts :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_modecosts :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_modecosts :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_modecosts :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_modecosts :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_modecosts :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_modecosts :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_modecosts :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_modecosts :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_modecosts :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_modecosts :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_modecosts :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

scale2_ratio_in_modecosts :: (mode: s32, hr: *s32, hs: *s32) {
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

validate_buffer_in_modecosts :: (start: *u8, len: u64, end: *u8, error: *Internal_Error_Info) -> s32 {
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

vp8_encode_bool_in_modecosts :: (bc: *BOOL_CODER, bit: s32, probability: s32) {
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

        validate_buffer_in_modecosts(bc.buffer + bc.pos, 1, bc.buffer_end, bc.error);
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

vp8_cost_branch_in_modecosts :: (ct: *u32, p: Vp8_Prob) -> u32 {
    return cast,no_check(u32) ((((cast,no_check(u64) ct[0]) * cast(u64) VP8_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP8_PROB_COST[255 - cast(s32) p]) >> 8);
}

vp8_treed_write_in_modecosts :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) {
    i: Vp8_Tree_Index = 0;

    while true {
        {
            B := v >> ((c_transpiler_pre_decrement(*(n))) & 31) & 1;
            vp8_encode_bool_in_modecosts(W, B, cast,no_check(s32) P[(cast(s32) i) >> 1]);
            i = t[(cast(s32) i) + B];
        }
        if n == 0 break;
    }
}

vp8_write_token_in_modecosts :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) {
    vp8_treed_write_in_modecosts(W, t, P, X.value, X.len);
}

vp8_treed_cost_in_modecosts :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) -> s32 {
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

vp8_cost_token_in_modecosts :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) -> s32 {
    return vp8_treed_cost_in_modecosts(t, P, X.value, X.len);
}

vp8_sem_wait_in_modecosts :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_0: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_0; assignment_0; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init_in_modecosts :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release_in_modecosts :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

atomic_load_acquire_in_modecosts :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_atomic_spin_wait_in_modecosts :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire_in_modecosts(last_row_current_mb_col) - NSYNC {
    }
}

mv_bias_in_modecosts :: (refmb_ref_frame_sign_bias: s32, refframe: s32, mvp: *Int_Mv_in_mv, ref_frame_sign_bias: *s32) {
    if refmb_ref_frame_sign_bias != ref_frame_sign_bias[refframe] {
        mvp.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.row) * -1);
        mvp.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.col) * -1);
    }
}

vp8_clamp_mv2_in_modecosts :: (mv: *Int_Mv_in_mv, xd: *MACROBLOCKD_in_blockd) {
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

vp8_clamp_mv_in_modecosts :: (
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

vp8_check_mv_bounds_in_modecosts :: (
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

left_block_mv_in_modecosts :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> u32 {
    if b & 3 == 0 {
        cur_mb -= 1;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 4;
    }

    return (((cur_mb.bmi.data + b - 1)).mv).as_int;
}

above_block_mv_in_modecosts :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> u32 {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 16;
    }

    return (((cur_mb.bmi.data + (b - 4))).mv).as_int;
}

left_block_mode_in_modecosts :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> B_PREDICTION_MODE {
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

above_block_mode_in_modecosts :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> B_PREDICTION_MODE {
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

