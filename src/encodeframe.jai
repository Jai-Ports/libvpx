// Generated directly from C by cpp_transpiler.
VP8_VAR_OFFS: [16] u8;

eob_adjust :: (eobs: *s8, diff: *s16) {
    for js: 0..cast(s32) 16 - 1 {
        if eobs[js] == 0 && diff[0] != 0 {
            eobs[js] += 1;
        }
        diff += 16;
    }
}

vp8_inverse_transform_mby :: (xd: *MACROBLOCKD_in_blockd) {
    dqc := xd.dequant_y1.data;

    if xd.mode_info_context.mbmi.mode != cast,no_check(u8) SPLITMV {
        if xd.eobs[24] > 1 {
            vp8_short_inv_walsh4x4_c(*xd.block[24].dqcoeff[0], xd.qcoeff.data);
        } else {
            vp8_short_inv_walsh4x4_1_c(*xd.block[24].dqcoeff[0], xd.qcoeff.data);
        }
        eob_adjust(xd.eobs.data, xd.qcoeff.data);

        dqc = xd.dequant_y1_dc.data;
    }
    vp8_dequant_idct_add_y_block_c(xd.qcoeff.data, dqc, xd.dst.y_buffer, xd.dst.y_stride, xd.eobs.data);
}

setup_intra_recon_left_in_encodeframe :: (y_buffer: *u8, u_buffer: *u8, v_buffer: *u8, y_stride: s32, uv_stride: s32) {
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

vp8_sem_wait_in_encodeframe :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_0: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_0; assignment_0; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init_in_encodeframe :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release_in_encodeframe :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

atomic_load_acquire_in_encodeframe :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_atomic_spin_wait_in_encodeframe :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire_in_encodeframe(last_row_current_mb_col) - NSYNC {
    }
}

validate_buffer_in_encodeframe :: (start: *u8, len: u64, end: *u8, error: *Internal_Error_Info) -> s32 {
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

vp8_encode_bool_in_encodeframe :: (bc: *Vp8_Writer, bit: s32, probability: s32) {
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

        validate_buffer_in_encodeframe(bc.buffer + bc.pos, 1, bc.buffer_end, bc.error);
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

vp8_cost_branch_in_encodeframe :: (ct: *u32, p: Vp8_Prob) -> u32 {
    return cast,no_check(u32) ((((cast,no_check(u64) ct[0]) * cast(u64) VP8_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP8_PROB_COST[255 - cast(s32) p]) >> 8);
}

vp8_treed_write_in_encodeframe :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) {
    i: Vp8_Tree_Index = 0;

    while true {
        {
            B := v >> ((c_transpiler_pre_decrement(*(n))) & 31) & 1;
            vp8_encode_bool_in_encodeframe(W, B, cast,no_check(s32) P[(cast(s32) i) >> 1]);
            i = t[(cast(s32) i) + B];
        }
        if n == 0 break;
    }
}

vp8_write_token_in_encodeframe :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) {
    vp8_treed_write_in_encodeframe(W, t, P, X.value, X.len);
}

vp8_treed_cost_in_encodeframe :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) -> s32 {
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

vp8_cost_token_in_encodeframe :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) -> s32 {
    return vp8_treed_cost_in_encodeframe(t, P, X.value, X.len);
}

vp8_set_reference_value_in_encodeframe :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_encodeframe :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_encodeframe :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_encodeframe :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_encodeframe :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_encodeframe :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_encodeframe :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_encodeframe :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_encodeframe :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_encodeframe :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_encodeframe :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_encodeframe :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_encodeframe :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_encodeframe :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_encodeframe :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_encodeframe :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_encodeframe :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_encodeframe :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_encodeframe :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_encodeframe :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_encodeframe :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_encodeframe :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_encodeframe :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_encodeframe :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_encodeframe :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_encodeframe :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

scale2_ratio_in_encodeframe :: (mode: s32, hr: *s32, hs: *s32) {
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

vp8_activity_masking :: (cpi: *VP8_COMP, x: *MACROBLOCK_in_block) {
    act := cast,no_check(s64) x.mb_activity_ptr.*;

    a := act + cast(s64) (2 * cpi.activity_avg);
    b := 2 * act + cast(s64) cpi.activity_avg;

    x.rdmult = cast,no_check(s32) (cast,no_check(u32) (((cast,no_check(s64) x.rdmult) * b + a >> 1) / a));
    x.errorperbit = x.rdmult * 100 / (110 * x.rddiv);
    x.errorperbit += cast(s32) (x.errorperbit == 0);

    adjust_act_zbin(cpi, x);
}

adjust_act_zbin :: (cpi: *VP8_COMP, x: *MACROBLOCK_in_block) {
    act := cast,no_check(s64) x.mb_activity_ptr.*;

    a := act + cast(s64) (4 * cpi.activity_avg);
    b := 4 * act + cast(s64) cpi.activity_avg;

    if act > cast,no_check(s64) cpi.activity_avg {
        x.act_zbin_adj = (cast,no_check(s32) ((b + a >> 1) / a)) - 1;
    } else {
        x.act_zbin_adj = 1 - cast,no_check(s32) ((a + b >> 1) / b);
    }
}

vp8_build_block_offsets :: (x: *MACROBLOCK_in_block) {
    block: s32 = 0;
    bc: s32 = ---;

    vp8_build_block_doffsets(*x.e_mbd);

    x.thismb_ptr = x.thismb.data + 0;
    for br: 0..cast(s32) 4 - 1 {
        bc = 0;
        while bc < 4 {
            this_block := x.block.data + block;
            this_block.base_src = *x.thismb_ptr;
            this_block.src_stride = 16;
            this_block.src = 4 * br * 16 + 4 * bc;
            block += 1;
            bc += 1;
        }
    }

    for br: 0..cast(s32) 2 - 1 {
        bc = 0;
        while bc < 2 {
            this_block := x.block.data + block;
            this_block.base_src = *x.src.u_buffer;
            this_block.src_stride = x.src.uv_stride;
            this_block.src = 4 * br * this_block.src_stride + 4 * bc;
            block += 1;
            bc += 1;
        }
    }

    for br: 0..cast(s32) 2 - 1 {
        bc = 0;
        while bc < 2 {
            this_block := x.block.data + block;
            this_block.base_src = *x.src.v_buffer;
            this_block.src_stride = x.src.uv_stride;
            this_block.src = 4 * br * this_block.src_stride + 4 * bc;
            block += 1;
            bc += 1;
        }
    }
}

vp8_setup_block_ptrs :: (x: *MACROBLOCK_in_block) {
    c: s32 = ---;

    for r: 0..cast(s32) 4 - 1 {
        c = 0;
        while c < 4 {
            x.block[r * 4 + c].src_diff = x.src_diff.data + r * 4 * 16 + c * 4;
            c += 1;
        }
    }

    for r: 0..cast(s32) 2 - 1 {
        c = 0;
        while c < 2 {
            x.block[16 + r * 2 + c].src_diff = x.src_diff.data + 256 + r * 4 * 8 + c * 4;
            c += 1;
        }
    }

    for r: 0..cast(s32) 2 - 1 {
        c = 0;
        while c < 2 {
            x.block[20 + r * 2 + c].src_diff = x.src_diff.data + 320 + r * 4 * 8 + c * 4;
            c += 1;
        }
    }

    x.block[24].src_diff = x.src_diff.data + 384;

    for i: 0..cast(s32) 25 - 1 {
        x.block[i].coeff = x.coeff.data + i * 16;
    }
}

vp8_encode_frame :: (cpi: *VP8_COMP) {
    mb_row: s32 = ---;
    X := *cpi.mb;
    CM := *cpi.common;
    XD := *X.e_mbd;
    tp := cpi.tok;
    segment_counts: [4] s32 = ---;

    fill_memory(segment_counts.data, 0, segment_counts.count * size_of(s32));
    totalrate: s32 = 0;

    if cpi.compressor_speed == 2 {
        if cpi.oxcf.cpu_used < 0 {
            cpi.speed = -cpi.oxcf.cpu_used;
        } else {
            vp8_auto_select_speed(cpi);
        }
    }

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

    cpi.mb.skip_true_count = 0;
    cpi.tok_count = 0;

    XD.mode_info_context = CM.mi;

    fill_memory(*cpi.mb.m_vcount, 0, cpi.mb.m_vcount.count * size_of([2047] u32));

    vp8cx_frame_init_quantizer(cpi);

    vp8_initialize_rd_consts(cpi, X, vp8_dc_quant(CM.base_qindex, CM.y1dc_delta_q));

    vp8cx_initialize_me_consts(cpi, CM.base_qindex);

    if cpi.oxcf.tuning == cast,no_check(u32) VP8_TUNE_SSIM {
        init_encode_frame_mb_context(cpi);

        build_activity_map(cpi);
    }

    init_encode_frame_mb_context(cpi);

    if atomic_load_acquire_in_encodeframe(*cpi.b_multi_threaded) != 0 {
        (cast,no_check(#type (_: *VP8_COMP, _: *Macroblock_in_block, _: *MB_ROW_COMP, _: s32)) (cast(*void) vp8cx_init_mbrthread_data))(
            cpi,
            X,
            cpi.mb_row_ei,
            cpi.encoding_thread_count
        );

        if cpi.mt_current_mb_col_size != CM.mb_rows {
            deallocate_memory(cast(*void) cpi.mt_current_mb_col);
            cpi.mt_current_mb_col = null;
            cpi.mt_current_mb_col_size = 0;
            cpi.mt_current_mb_col =
                cast(*Atomic_Int) allocate_memory(
                    size_of(Atomic_Int) * cast,no_check(u64) CM.mb_rows
                );

            if cpi.mt_current_mb_col == null {
                internal_error(
                    *cpi.common.error,
                    cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                    c_string("Failed to allocate cpi->mt_current_mb_col")
                );
            }
            cpi.mt_current_mb_col_size = CM.mb_rows;
        }
        i: s32 = 0;
        while i < CM.mb_rows {
            atomic_store_release_in_encodeframe(*(cast(*Atomic_Int) (cpi.mt_current_mb_col))[i], -1);
            i += 1;
        }

        i = 0;
        while i < cpi.encoding_thread_count {
            sem_post(*(cast(*Sem_T) (cpi.h_event_start_encoding))[i]);
            i += 1;
        }

        mb_row = 0;
        while mb_row < CM.mb_rows {
            fill_memory(*CM.left_context, 0, size_of(ENTROPY_CONTEXT_PLANES));

            tp = cpi.tok + mb_row * (CM.mb_cols * 16 * 24);

            encode_mb_row(cpi, CM, mb_row, X, XD, *tp, segment_counts.data, *totalrate);

            X.src.y_buffer += 16 * X.src.y_stride * (cpi.encoding_thread_count + 1) - 16 * CM.mb_cols;
            X.src.u_buffer += 8 * X.src.uv_stride * (cpi.encoding_thread_count + 1) - 8 * CM.mb_cols;
            X.src.v_buffer += 8 * X.src.uv_stride * (cpi.encoding_thread_count + 1) - 8 * CM.mb_cols;

            XD.mode_info_context += XD.mode_info_stride * cpi.encoding_thread_count;
            X.partition_info += XD.mode_info_stride * cpi.encoding_thread_count;
            X.gf_active_ptr += CM.mb_cols * cpi.encoding_thread_count;
            mb_row += cpi.encoding_thread_count + 1;
        }

        i = 0;
        while i < cpi.encoding_thread_count {
            vp8_sem_wait_in_encodeframe(*(cast(*Sem_T) (cpi.h_event_end_encoding))[i]);
            i += 1;
        }

        mb_row = 0;
        while mb_row < CM.mb_rows {
            cpi.tok_count += cast,no_check(u32) (cpi.tplist[mb_row].stop - cpi.tplist[mb_row].start);
            mb_row += 1;
        }

        if XD.segmentation_enabled != 0 {
            j: s32 = ---;

            if XD.segmentation_enabled != 0 {
                i = 0;
                while i < cpi.encoding_thread_count {
                    j = 0;
                    while j < 4 {
                        segment_counts[j] += cpi.mb_row_ei[i].segment_counts[j];
                        j += 1;
                    }
                    i += 1;
                }
            }
        }

        i = 0;
        while i < cpi.encoding_thread_count {
            THREAD_RATE := cpi.mb_row_ei[i].totalrate;
            if 2147483647 - totalrate > THREAD_RATE {
                totalrate += THREAD_RATE;
            } else {
                totalrate = 2147483647;
            }

            cpi.mb.skip_true_count += cpi.mb_row_ei[i].mb.skip_true_count;

            mode_count: s32 = 0;
            while mode_count < (cast,no_check(s32) (B_PRED)) + 1 {
                cpi.mb.ymode_count[mode_count] += cpi.mb_row_ei[i].mb.ymode_count[mode_count];
                mode_count += 1;
            }

            mode_count = 0;
            while mode_count < (cast,no_check(s32) (TM_PRED)) + 1 {
                cpi.mb.uv_mode_count[mode_count] += cpi.mb_row_ei[i].mb.uv_mode_count[mode_count];
                mode_count += 1;
            }

            c_idx: s32 = 0;
            while c_idx < M_VVALS {
                cpi.mb.m_vcount[0][c_idx] += cpi.mb_row_ei[i].mb.m_vcount[0][c_idx];
                cpi.mb.m_vcount[1][c_idx] += cpi.mb_row_ei[i].mb.m_vcount[1][c_idx];
                c_idx += 1;
            }

            cpi.mb.prediction_error += cpi.mb_row_ei[i].mb.prediction_error;
            cpi.mb.intra_error += cpi.mb_row_ei[i].mb.intra_error;

            c_idx = 0;
            while c_idx < MAX_REF_FRAMES {
                cpi.mb.count_mb_ref_frame_usage[c_idx] += cpi.mb_row_ei[i].mb.count_mb_ref_frame_usage[c_idx];
                c_idx += 1;
            }

            c_idx = 0;
            while c_idx < 1024 {
                cpi.mb.error_bins[c_idx] += cpi.mb_row_ei[i].mb.error_bins[c_idx];
                c_idx += 1;
            }

            sum_coef_counts(X, *cpi.mb_row_ei[i].mb);
            i += 1;
        }
    } else {
        mb_row = 0;
        while mb_row < CM.mb_rows {
            fill_memory(*CM.left_context, 0, size_of(ENTROPY_CONTEXT_PLANES));

            encode_mb_row(cpi, CM, mb_row, X, XD, *tp, segment_counts.data, *totalrate);

            X.src.y_buffer += 16 * X.src.y_stride - 16 * CM.mb_cols;
            X.src.u_buffer += 8 * X.src.uv_stride - 8 * CM.mb_cols;
            X.src.v_buffer += 8 * X.src.uv_stride - 8 * CM.mb_cols;
            mb_row += 1;
        }

        cpi.tok_count = cast,no_check(u32) (tp - cpi.tok);
    }

    if XD.segmentation_enabled != 0 && XD.update_mb_segmentation_map != 0 {
        fill_memory(XD.mb_segment_tree_probs.data, 255, XD.mb_segment_tree_probs.count);

        tot_count := segment_counts[0] + segment_counts[1] + segment_counts[2] + segment_counts[3];

        if tot_count != 0 {
            XD.mb_segment_tree_probs[0] =
                cast,no_check(Vp8_Prob) ((segment_counts[0] + segment_counts[1]) *
                    255 / tot_count);

            tot_count = segment_counts[0] + segment_counts[1];

            if tot_count > 0 {
                XD.mb_segment_tree_probs[1] = cast,no_check(Vp8_Prob) (segment_counts[0] * 255 / tot_count);
            }

            tot_count = segment_counts[2] + segment_counts[3];

            if tot_count > 0 {
                XD.mb_segment_tree_probs[2] = cast,no_check(Vp8_Prob) (segment_counts[2] * 255 / tot_count);
            }

            for i: 0..cast(s32) 3 - 1 {
                if XD.mb_segment_tree_probs[i] == 0 {
                    XD.mb_segment_tree_probs[i] = 1;
                }
            }
        }
    }

    cpi.projected_frame_size = totalrate >> 8;

    if CM.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
        cpi.this_frame_percent_intra = 100;
    } else {
        tot_modes :=
            cpi.mb.count_mb_ref_frame_usage[INTRA_FRAME] + cpi.mb.count_mb_ref_frame_usage[LAST_FRAME] +
                cpi.mb.count_mb_ref_frame_usage[GOLDEN_FRAME] + cpi.mb.count_mb_ref_frame_usage[ALTREF_FRAME];

        if tot_modes != 0 {
            cpi.this_frame_percent_intra = cpi.mb.count_mb_ref_frame_usage[INTRA_FRAME] * 100 / tot_modes;
        }
    }

    if CM.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon &&
        (cpi.oxcf.number_of_layers > 1 || CM.refresh_alt_ref_frame == 0 && CM.refresh_golden_frame == 0) {
        vp8_convert_rfct_to_prob(cpi);
    }
}

encode_mb_row :: (
    cpi: *VP8_COMP,
    cm: *VP8_COMMON,
    mb_row: s32,
    x: *MACROBLOCK_in_block,
    xd: *MACROBLOCKD_in_blockd,
    tp: **TOKENEXTRA,
    segment_counts: *s32,
    totalrate: *s32
) {
    ref_fb_idx := cm.lst_fb_idx;
    dst_fb_idx := cm.new_fb_idx;
    recon_y_stride := cm.yv12_fb[ref_fb_idx].y_stride;
    recon_uv_stride := cm.yv12_fb[ref_fb_idx].uv_stride;
    map_index := mb_row * cpi.common.mb_cols;

    NSYNC := cpi.mt_sync_range;
    rightmost_col := Atomic_Int.{value = cm.mb_cols + NSYNC};

    current_mb_col: *Atomic_Int = null;

    if atomic_load_acquire_in_encodeframe(*cpi.b_multi_threaded) != 0 {
        current_mb_col = *(cast(*Atomic_Int) (cpi.mt_current_mb_col))[mb_row];
    }
    last_row_current_mb_col: *Atomic_Int = ifx atomic_load_acquire_in_encodeframe(*cpi.b_multi_threaded) != 0 && mb_row != 0
        then *(cast(*Atomic_Int) (cpi.mt_current_mb_col))[mb_row - 1]
        else *rightmost_col;

    xd.above_context = cm.above_context;

    xd.up_available = cast(s32) (mb_row != 0);
    recon_yoffset := mb_row * recon_y_stride * 16;
    recon_uvoffset := mb_row * recon_uv_stride * 8;

    cpi.tplist[mb_row].start = tp.*;

    xd.mb_to_top_edge = -((mb_row * 16) << 3);
    xd.mb_to_bottom_edge = ((cm.mb_rows - 1 - mb_row) * 16) << 3;

    x.mv_row_min = -(mb_row * 16 + cast,no_check(s32) ((32 - 16)));
    x.mv_row_max = (cm.mb_rows - 1 - mb_row) * 16 + cast,no_check(s32) ((32 - 16));

    x.mb_activity_ptr = *cpi.mb_activity_map[map_index];

    mb_col: s32 = 0;
    while mb_col < cm.mb_cols {
        xd.mb_to_left_edge = -((mb_col * 16) << 3);
        xd.mb_to_right_edge = ((cm.mb_cols - 1 - mb_col) * 16) << 3;

        x.mv_col_min = -(mb_col * 16 + cast,no_check(s32) ((32 - 16)));
        x.mv_col_max = (cm.mb_cols - 1 - mb_col) * 16 + cast,no_check(s32) ((32 - 16));

        xd.dst.y_buffer = cm.yv12_fb[dst_fb_idx].y_buffer + recon_yoffset;
        xd.dst.u_buffer = cm.yv12_fb[dst_fb_idx].u_buffer + recon_uvoffset;
        xd.dst.v_buffer = cm.yv12_fb[dst_fb_idx].v_buffer + recon_uvoffset;
        xd.left_available = cast(s32) (mb_col != 0);

        x.rddiv = cpi.rddiv;
        x.rdmult = cpi.rdmult;

        vp8_copy_mem16x16_c(x.src.y_buffer, x.src.y_stride, x.thismb.data, 16);

        if atomic_load_acquire_in_encodeframe(*cpi.b_multi_threaded) != 0 {
            if (mb_col - 1) % NSYNC == 0 {
                atomic_store_release_in_encodeframe(current_mb_col, mb_col - 1);
            }

            if mb_row != 0 && mb_col & (NSYNC - 1) == 0 {
                vp8_atomic_spin_wait_in_encodeframe(mb_col, last_row_current_mb_col, NSYNC);
            }
        }

        if cpi.oxcf.tuning == cast,no_check(u32) VP8_TUNE_SSIM {
            vp8_activity_masking(cpi, x);
        }

        if xd.segmentation_enabled != 0 {
            if cpi.segmentation_map[map_index + mb_col] <= 3 {
                xd.mode_info_context.mbmi.segment_id = cpi.segmentation_map[map_index + mb_col];
            } else {
                xd.mode_info_context.mbmi.segment_id = 0;
            }

            vp8cx_mb_init_quantizer(cpi, x, 1);
        } else {
            xd.mode_info_context.mbmi.segment_id = 0;
        }

        x.active_ptr = cpi.active_map + map_index + mb_col;

        if cm.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
            INTRA_RATE_COST := vp8cx_encode_intra_macroblock(cpi, x, tp);
            if 2147483647 - totalrate.* > INTRA_RATE_COST {
                totalrate.* += INTRA_RATE_COST;
            } else {
                totalrate.* = 2147483647;
            }
        } else {
            INTER_RATE_COST :=
                vp8cx_encode_inter_macroblock(
                    cpi,
                    x,
                    tp,
                    recon_yoffset,
                    recon_uvoffset,
                    mb_row,
                    mb_col
                );
            if 2147483647 - totalrate.* > INTER_RATE_COST {
                totalrate.* += INTER_RATE_COST;
            } else {
                totalrate.* = 2147483647;
            }

            if cpi.current_layer == 0 {
                if xd.mode_info_context.mbmi.mode == cast,no_check(u8) ZEROMV &&
                    xd.mode_info_context.mbmi.ref_frame == cast,no_check(u8) LAST_FRAME {
                    if cpi.consec_zero_last[map_index + mb_col] < 255 {
                        cpi.consec_zero_last[map_index + mb_col] = cast,no_check(u8) ((cast,no_check(s32) cpi.consec_zero_last[map_index + mb_col]) + 1);
                    }
                    if cpi.consec_zero_last_mvbias[map_index + mb_col] < 255 {
                        cpi.consec_zero_last_mvbias[map_index + mb_col] = cast,no_check(u8) ((cast,no_check(s32) cpi.consec_zero_last_mvbias[map_index + mb_col]) + 1);
                    }
                } else {
                    cpi.consec_zero_last[map_index + mb_col] = 0;
                    cpi.consec_zero_last_mvbias[map_index + mb_col] = 0;
                }
                if x.zero_last_dot_suppress != 0 {
                    cpi.consec_zero_last_mvbias[map_index + mb_col] = 0;
                }
            }

            if cpi.current_layer == 0 && cpi.cyclic_refresh_mode_enabled != 0 && xd.segmentation_enabled != 0 {
                cpi.segmentation_map[map_index + mb_col] = xd.mode_info_context.mbmi.segment_id;

                if xd.mode_info_context.mbmi.segment_id != 0 {
                    cpi.cyclic_refresh_map[map_index + mb_col] = -1;
                } else if xd.mode_info_context.mbmi.mode == cast,no_check(u8) ZEROMV &&
                    xd.mode_info_context.mbmi.ref_frame == cast,no_check(u8) LAST_FRAME {
                    if cpi.cyclic_refresh_map[map_index + mb_col] == 1 {
                        cpi.cyclic_refresh_map[map_index + mb_col] = 0;
                    }
                } else {
                    cpi.cyclic_refresh_map[map_index + mb_col] = 1;
                }
            }
        }

        cpi.tplist[mb_row].stop = tp.*;

        x.gf_active_ptr += 1;

        x.mb_activity_ptr += 1;

        x.src.y_buffer += 16;
        x.src.u_buffer += 8;
        x.src.v_buffer += 8;

        recon_yoffset += 16;
        recon_uvoffset += 8;

        segment_counts[xd.mode_info_context.mbmi.segment_id] += 1;

        xd.mode_info_context += 1;
        x.partition_info += 1;
        xd.above_context += 1;
        mb_col += 1;
    }

    vp8_extend_mb_row(cm.yv12_fb.data + dst_fb_idx, xd.dst.y_buffer + 16, xd.dst.u_buffer + 8, xd.dst.v_buffer + 8);

    if atomic_load_acquire_in_encodeframe(*cpi.b_multi_threaded) != 0 {
        atomic_store_release_in_encodeframe(current_mb_col, atomic_load_acquire_in_encodeframe(*rightmost_col));
    }

    xd.mode_info_context += 1;
    x.partition_info += 1;
}

vp8cx_encode_inter_macroblock :: (
    cpi: *VP8_COMP,
    x: *MACROBLOCK_in_block,
    t: **TOKENEXTRA,
    recon_yoffset: s32,
    recon_uvoffset: s32,
    mb_row: s32,
    mb_col: s32
) -> s32 {
    XD := *x.e_mbd;
    intra_error: s32 = 0;
    rate: s32 = ---;
    distortion: s32 = ---;

    x.skip = 0;

    if XD.segmentation_enabled != 0 {
        x.encode_breakout = cpi.segment_encode_breakout[XD.mode_info_context.mbmi.segment_id];
    } else {
        x.encode_breakout = cast,no_check(u32) cpi.oxcf.encode_breakout;
    }

    x.best_reference_frame = cast,no_check(MV_REFERENCE_FRAME_in_alloccommon) INTRA_FRAME;
    x.best_zeromv_reference_frame = cast,no_check(MV_REFERENCE_FRAME_in_alloccommon) INTRA_FRAME;
    x.best_sse_inter_mode = cast,no_check(MB_PREDICTION_MODE) (cast(s32) 0);
    x.best_sse_mv.as_int = 0;
    x.need_to_clamp_best_mvs = 0;

    if cpi.sf.rd != 0 {
        zbin_mode_boost_enabled := x.zbin_mode_boost_enabled;

        if cpi.sf.use_fastquant_for_pick != 0 {
            x.quantize_b = vp8_fast_quantize_b_c;

            x.zbin_mode_boost_enabled = 0;
        }
        vp8_rd_pick_inter_mode(cpi, x, recon_yoffset, recon_uvoffset, *rate, *distortion, *intra_error, mb_row, mb_col);

        if cpi.sf.improved_quant != 0 {
            x.quantize_b = vp8_regular_quantize_b_c;
        }

        x.zbin_mode_boost_enabled = zbin_mode_boost_enabled;
    } else {
        vp8_pick_inter_mode(cpi, x, recon_yoffset, recon_uvoffset, *rate, *distortion, *intra_error, mb_row, mb_col);
    }

    x.prediction_error += cast,no_check(s64) distortion;
    x.intra_error += cast,no_check(s64) intra_error;

    if cpi.oxcf.tuning == cast,no_check(u32) VP8_TUNE_SSIM {
        adjust_act_zbin(cpi, x);
    }

    if XD.segmentation_enabled != 0 {
        if cpi.current_layer == 0 && cpi.cyclic_refresh_mode_enabled != 0 {
            if XD.mode_info_context.mbmi.segment_id == 1 &&
                (XD.mode_info_context.mbmi.ref_frame != cast,no_check(u8) LAST_FRAME ||
                    XD.mode_info_context.mbmi.mode != cast,no_check(u8) ZEROMV) {
                XD.mode_info_context.mbmi.segment_id = 0;

                vp8cx_mb_init_quantizer(cpi, x, 1);
            }
        }
    }

    x.zbin_mode_boost = 0;
    if x.zbin_mode_boost_enabled != 0 {
        if XD.mode_info_context.mbmi.ref_frame != cast,no_check(u8) INTRA_FRAME {
            if XD.mode_info_context.mbmi.mode == cast,no_check(u8) ZEROMV {
                if XD.mode_info_context.mbmi.ref_frame != cast,no_check(u8) LAST_FRAME && cpi.oxcf.number_of_layers == 1 {
                    x.zbin_mode_boost = 12;
                } else {
                    x.zbin_mode_boost = 6;
                }
            } else if XD.mode_info_context.mbmi.mode == cast,no_check(u8) SPLITMV {
                x.zbin_mode_boost = 0;
            } else {
                x.zbin_mode_boost = 4;
            }
        }
    }

    if cpi.sf.improved_quant != 0 {
        vp8_update_zbin_extra(cpi, x);
    }

    x.count_mb_ref_frame_usage[XD.mode_info_context.mbmi.ref_frame] += 1;

    if XD.mode_info_context.mbmi.ref_frame == cast,no_check(u8) INTRA_FRAME {
        vp8_encode_intra16x16mbuv(x);

        if XD.mode_info_context.mbmi.mode == cast,no_check(u8) B_PRED {
            vp8_encode_intra4x4mby(x);
        } else {
            vp8_encode_intra16x16mby(x);
        }

        sum_intra_stats(cpi, x);
    } else {
        ref_fb_idx: s32 = ifx XD.mode_info_context.mbmi.ref_frame == cast,no_check(u8) LAST_FRAME
            then cpi.common.lst_fb_idx
            else ifx XD.mode_info_context.mbmi.ref_frame == cast,no_check(u8) GOLDEN_FRAME
                then cpi.common.gld_fb_idx
                else cpi.common.alt_fb_idx;

        XD.pre.y_buffer = cpi.common.yv12_fb[ref_fb_idx].y_buffer + recon_yoffset;
        XD.pre.u_buffer = cpi.common.yv12_fb[ref_fb_idx].u_buffer + recon_uvoffset;
        XD.pre.v_buffer = cpi.common.yv12_fb[ref_fb_idx].v_buffer + recon_uvoffset;

        if x.skip == 0 {
            vp8_encode_inter16x16(x);
        } else {
            vp8_build_inter16x16_predictors_mb(
                XD,
                XD.dst.y_buffer,
                XD.dst.u_buffer,
                XD.dst.v_buffer,
                XD.dst.y_stride,
                XD.dst.uv_stride
            );
        }
    }

    if x.skip == 0 {
        (cast,no_check(#type (_: *VP8_COMP, _: *MACROBLOCK_in_block, _: **TOKENEXTRA)) (cast(*void) vp8_tokenize_mb))(
            cpi,
            x,
            t
        );

        if XD.mode_info_context.mbmi.mode != cast,no_check(u8) B_PRED {
            vp8_inverse_transform_mby(XD);
        }

        vp8_dequant_idct_add_uv_block_c(
            XD.qcoeff.data + 16 * 16,
            XD.dequant_uv.data,
            XD.dst.u_buffer,
            XD.dst.v_buffer,
            XD.dst.uv_stride,
            XD.eobs.data + 16
        );
    } else {
        XD.mode_info_context.mbmi.mb_skip_coeff = 1;

        if cpi.common.mb_no_coeff_skip != 0 {
            x.skip_true_count += 1;
            vp8_fix_contexts(XD);
        } else {
            vp8_stuff_mb(cpi, x, t);
        }
    }

    return rate;
}

sum_intra_stats :: (cpi: *VP8_COMP, x: *MACROBLOCK_in_block) {
    xd := *x.e_mbd;
    M := cast,no_check(MB_PREDICTION_MODE) xd.mode_info_context.mbmi.mode;
    UVM := cast,no_check(MB_PREDICTION_MODE) xd.mode_info_context.mbmi.uv_mode;

    x.ymode_count[M] += 1;
    x.uv_mode_count[UVM] += 1;
}

vp8cx_encode_intra_macroblock :: (cpi: *VP8_COMP, x: *MACROBLOCK_in_block, t: **TOKENEXTRA) -> s32 {
    xd := *x.e_mbd;
    rate: s32 = ---;

    if cpi.sf.rd != 0 && cpi.compressor_speed != 2 {
        vp8_rd_pick_intra_mode(x, *rate);
    } else {
        vp8_pick_intra_mode(x, *rate);
    }

    if cpi.oxcf.tuning == cast,no_check(u32) VP8_TUNE_SSIM {
        adjust_act_zbin(cpi, x);
        vp8_update_zbin_extra(cpi, x);
    }

    if x.e_mbd.mode_info_context.mbmi.mode == cast,no_check(u8) B_PRED {
        vp8_encode_intra4x4mby(x);
    } else {
        vp8_encode_intra16x16mby(x);
    }

    vp8_encode_intra16x16mbuv(x);

    sum_intra_stats(cpi, x);

    (cast,no_check(#type (_: *VP8_COMP, _: *MACROBLOCK_in_block, _: **TOKENEXTRA)) (cast(*void) vp8_tokenize_mb))(
        cpi,
        x,
        t
    );

    if xd.mode_info_context.mbmi.mode != cast,no_check(u8) B_PRED {
        vp8_inverse_transform_mby(xd);
    }

    vp8_dequant_idct_add_uv_block_c(
        xd.qcoeff.data + 16 * 16,
        xd.dequant_uv.data,
        xd.dst.u_buffer,
        xd.dst.v_buffer,
        xd.dst.uv_stride,
        xd.eobs.data + 16
    );
    return rate;
}

sum_coef_counts :: (x: *MACROBLOCK_in_block, x_thread: *MACROBLOCK_in_block) {
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

                            while true {
                                x.coef_counts[i][j][k][t] += x_thread.coef_counts[i][j][k][t];
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

init_encode_frame_mb_context :: (cpi: *VP8_COMP) {
    X := *cpi.mb;
    CM := *cpi.common;
    XD := *X.e_mbd;

    X.gf_active_ptr = cast(*s8) cpi.gf_active_flags;

    X.mb_activity_ptr = cpi.mb_activity_map;

    X.act_zbin_adj = 0;

    X.partition_info = X.pi;

    XD.mode_info_context = CM.mi;
    XD.mode_info_stride = CM.mode_info_stride;

    XD.frame_type = CM.frame_type;

    if CM.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
        vp8_init_mbmode_probs(CM);
    }

    X.src = cpi.source.*;
    XD.pre = CM.yv12_fb[CM.lst_fb_idx];
    XD.dst = CM.yv12_fb[CM.new_fb_idx];

    vp8_setup_intra_recon(CM.yv12_fb.data + CM.new_fb_idx);

    vp8_build_block_offsets(X);

    XD.mode_info_context.mbmi.mode = cast,no_check(u8) DC_PRED;
    XD.mode_info_context.mbmi.uv_mode = cast,no_check(u8) DC_PRED;

    XD.left_context = *CM.left_context;

    X.mvc = CM.fc.mvc.data;

    XD.above_context = CM.above_context;
    fill_memory(CM.above_context, 0, size_of(ENTROPY_CONTEXT_PLANES) * cast,no_check(u64) CM.mb_cols);

    if cpi.ref_frame_flags == VP8_LAST_FRAME {
        vp8_calc_ref_frame_costs(X.ref_frame_cost.data, cpi.prob_intra_coded, 255, 128);
    } else if cpi.oxcf.number_of_layers > 1 && cpi.ref_frame_flags == VP8_GOLD_FRAME {
        vp8_calc_ref_frame_costs(X.ref_frame_cost.data, cpi.prob_intra_coded, 1, 255);
    } else if cpi.oxcf.number_of_layers > 1 && cpi.ref_frame_flags == VP8_ALTR_FRAME {
        vp8_calc_ref_frame_costs(X.ref_frame_cost.data, cpi.prob_intra_coded, 1, 1);
    } else {
        vp8_calc_ref_frame_costs(X.ref_frame_cost.data, cpi.prob_intra_coded, cpi.prob_last_coded, cpi.prob_gf_coded);
    }

    XD.fullpixel_mask = ~(cast(s32) 0);
    if CM.full_pixel != 0 {
        XD.fullpixel_mask = ~(cast(s32) 7);
    }

    fill_memory(*X.coef_counts, 0, X.coef_counts.count * size_of([8] [3] [12] u32));
    fill_memory(*X.ymode_count, 0, X.ymode_count.count * size_of(s32));
    fill_memory(*X.uv_mode_count, 0, X.uv_mode_count.count * size_of(s32));
    X.prediction_error = 0;
    X.intra_error = 0;
    fill_memory(*X.count_mb_ref_frame_usage, 0, X.count_mb_ref_frame_usage.count * size_of(s32));
}

build_activity_map :: (cpi: *VP8_COMP) {
    X := *cpi.mb;
    xd := *X.e_mbd;
    CM := *cpi.common;

    new_yv12 := CM.yv12_fb.data + CM.new_fb_idx;

    recon_y_stride := new_yv12.y_stride;
    mb_col: s32 = ---;
    mb_activity: u32 = ---;
    activity_sum: s64 = 0;

    mb_row: s32 = 0;
    while mb_row < CM.mb_rows {
        xd.up_available = cast(s32) (mb_row != 0);
        recon_yoffset := mb_row * recon_y_stride * 16;

        mb_col = 0;
        while mb_col < CM.mb_cols {
            xd.dst.y_buffer = new_yv12.y_buffer + recon_yoffset;
            xd.left_available = cast(s32) (mb_col != 0);
            recon_yoffset += 16;

            vp8_copy_mem16x16_c(X.src.y_buffer, X.src.y_stride, X.thismb.data, 16);

            mb_activity = mb_activity_measure(X, mb_row, mb_col);

            activity_sum += cast,no_check(s64) mb_activity;

            X.mb_activity_ptr.* = mb_activity;

            X.mb_activity_ptr += 1;

            X.src.y_buffer += 16;
            mb_col += 1;
        }

        X.src.y_buffer += 16 * X.src.y_stride - 16 * CM.mb_cols;

        vp8_extend_mb_row(new_yv12, xd.dst.y_buffer + 16, xd.dst.u_buffer + 8, xd.dst.v_buffer + 8);
        mb_row += 1;
    }

    calc_av_activity(cpi, activity_sum);
}

calc_av_activity :: (cpi: *VP8_COMP, activity_sum: s64) {
    cpi.activity_avg = cast,no_check(u32) (activity_sum / cast(s64) cpi.common.m_bs);

    if cpi.activity_avg < 64 {
        cpi.activity_avg = 64;
    }

    cpi.activity_avg = 100000;
}

mb_activity_measure :: (x: *MACROBLOCK_in_block, mb_row: s32, mb_col: s32) -> u32 {
    mb_activity: u32 = ---;

    {
        use_dc_pred := cast(s32) (mb_col > 1 && mb_row > 1);

        mb_activity = cast,no_check(u32) vp8_encode_intra(x, use_dc_pred);
    }

    if mb_activity < 64 {
        mb_activity = 64;
    }

    return mb_activity;
}

tt_activity_measure :: (x: *MACROBLOCK_in_block) -> u32 {
    sse: u32 = ---;

    act := variance16x16_c(x.src.y_buffer, x.src.y_stride, VP8_VAR_OFFS.data, 0, *sse);
    act = act << 4;

    if act < cast,no_check(u32) ((cast(s32) 8) << 12) {
        act = ifx act < cast,no_check(u32) ((cast(s32) 5) << 12) then act else cast,no_check(u32) ((cast(s32) 5) << 12);
    }

    return act;
}

mv_bias_in_encodeframe :: (
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

vp8_clamp_mv2_in_encodeframe :: (mv: *Int_Mv_in_mv, xd: *MACROBLOCKD_in_blockd) {
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

vp8_clamp_mv_in_encodeframe :: (
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

vp8_check_mv_bounds_in_encodeframe :: (
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

left_block_mv_in_encodeframe :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> u32 {
    if b & 3 == 0 {
        cur_mb -= 1;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 4;
    }

    return (((cur_mb.bmi.data + b - 1)).mv).as_int;
}

above_block_mv_in_encodeframe :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> u32 {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 16;
    }

    return (((cur_mb.bmi.data + (b - 4))).mv).as_int;
}

left_block_mode_in_encodeframe :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> B_PREDICTION_MODE {
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

above_block_mode_in_encodeframe :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> B_PREDICTION_MODE {
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

insertsortmv :: (arr: *s32, len: s32) {
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

insertsortsad :: (arr: *s32, idx: *s32, len: s32) {
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

get_plane_pointers :: (fb: *YV12_BUFFER_CONFIG, plane: **u8, recon_yoffset: u32, recon_uvoffset: u32) {
    plane[0] = fb.y_buffer + recon_yoffset;
    plane[1] = fb.u_buffer + recon_uvoffset;
    plane[2] = fb.v_buffer + recon_uvoffset;
}

get_predictor_pointers :: (cpi: *VP8_COMP, plane: *[3] *u8, recon_yoffset: u32, recon_uvoffset: u32) {
    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_LAST_FRAME) != 0 {
        get_plane_pointers(
            cpi.common.yv12_fb.data + cpi.common.lst_fb_idx,
            plane[LAST_FRAME].data,
            recon_yoffset,
            recon_uvoffset
        );
    }

    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_GOLD_FRAME) != 0 {
        get_plane_pointers(
            cpi.common.yv12_fb.data + cpi.common.gld_fb_idx,
            plane[GOLDEN_FRAME].data,
            recon_yoffset,
            recon_uvoffset
        );
    }

    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_ALTR_FRAME) != 0 {
        get_plane_pointers(
            cpi.common.yv12_fb.data + cpi.common.alt_fb_idx,
            plane[ALTREF_FRAME].data,
            recon_yoffset,
            recon_uvoffset
        );
    }
}

get_reference_search_order :: (cpi: *VP8_COMP, ref_frame_map: *s32) {
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

clip_pixel_in_encodeframe :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_encodeframe :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_encodeframe :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_encodeframe :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_encodeframe :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_encodeframe(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_encodeframe(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_encodeframe(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_encodeframe :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_encodeframe :: (FILTER: *s16) -> s32 {
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

usec_timer_start :: (t: *Usec_Timer) {
    clock_gettime(4, *t.begin);
}

usec_timer_mark :: (t: *Usec_Timer) {
    clock_gettime(4, *t.end);
}

usec_timer_elapsed :: (t: *Usec_Timer) -> s64 {
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

globals_initialization_state_for_encodeframe: u32;
initialize_globals_for_encodeframe :: () {
    {
        state := atomic_load(*globals_initialization_state_for_encodeframe);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_encodeframe, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_encodeframe) != 2 {}
            return;
        }
    }
    VP8_VAR_OFFS =
        u8.[
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128,
            128
        ];
    atomic_store(*globals_initialization_state_for_encodeframe, 2);
}

sem_post :: (sem: *Sem_T) -> s32 #foreign System_Library_libc_so_6;

clock_gettime :: (clock_id: Clockid_T, tp: *C_Transpiler_POSIX.timespec) -> s32 #foreign System_Library_libc_so_6;

Unnamed_2903 :: u32;
MV_MAX : s32 : 1023;
M_VVALS : s32 : 2047;
MVFP_MAX : s32 : 255;
M_VFPVALS : s32 : 511;
MVLONG_WIDTH : s32 : 10;
MVNUM_SHORT : s32 : 8;
MVPIS_SHORT : s32 : 0;
MV_PSIGN : s32 : 1;
MV_PSHORT : s32 : 2;
MV_PBITS : s32 : 9;
MV_PCOUNT : s32 : 19;

Usec_Timer :: struct {
    begin: C_Transpiler_POSIX.timespec;
    end: C_Transpiler_POSIX.timespec;
}

Time_T :: s64;

Syscall_Slong_T :: s64;

Clockid_T :: s32;

