// Generated directly from C by cpp_transpiler.
QROUNDING_FACTORS_storage: [129] s32;

QZBIN_FACTORS_storage: [129] s32;

QROUNDING_FACTORS_Y2: [129] s32;

QZBIN_FACTORS_Y2: [129] s32;

get_lsb_in_vp8_quantize :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp8_quantize :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

vp8_set_reference_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_vp8_quantize :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_vp8_quantize :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_vp8_quantize :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

scale2_ratio_in_vp8_quantize :: (mode: s32, hr: *s32, hs: *s32) {
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

validate_buffer_in_vp8_quantize :: (start: *u8, len: u64, end: *u8, error: *Internal_Error_Info) -> s32 {
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

vp8_encode_bool_in_vp8_quantize :: (bc: *BOOL_CODER, bit: s32, probability: s32) {
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

        validate_buffer_in_vp8_quantize(bc.buffer + bc.pos, 1, bc.buffer_end, bc.error);
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

vp8_cost_branch_in_vp8_quantize :: (ct: *u32, p: Vp8_Prob) -> u32 {
    return cast,no_check(u32) ((((cast,no_check(u64) ct[0]) * cast(u64) VP8_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP8_PROB_COST[255 - cast(s32) p]) >> 8);
}

vp8_treed_write_in_vp8_quantize :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) {
    i: Vp8_Tree_Index = 0;

    while true {
        {
            B := v >> ((c_transpiler_pre_decrement(*(n))) & 31) & 1;
            vp8_encode_bool_in_vp8_quantize(W, B, cast,no_check(s32) P[(cast(s32) i) >> 1]);
            i = t[(cast(s32) i) + B];
        }
        if n == 0 break;
    }
}

vp8_write_token_in_vp8_quantize :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) {
    vp8_treed_write_in_vp8_quantize(W, t, P, X.value, X.len);
}

vp8_treed_cost_in_vp8_quantize :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) -> s32 {
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

vp8_cost_token_in_vp8_quantize :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) -> s32 {
    return vp8_treed_cost_in_vp8_quantize(t, P, X.value, X.len);
}

vp8_fast_quantize_b_c :: (b: *BLOCK, d: *BLOCKD) {
    coeff_ptr := b.coeff;
    round_ptr := b.round;
    quant_ptr := b.quant_fast;
    qcoeff_ptr := d.qcoeff;
    dqcoeff_ptr := d.dqcoeff;
    dequant_ptr := d.dequant;

    eob: s32 = -1;
    for i: 0..cast(s32) 16 - 1 {
        rc := VP8_DEFAULT_ZIG_ZAG1D[i];
        z := cast,no_check(s32) coeff_ptr[rc];

        sz := z >> 31;
        x := z ^ sz - sz;

        y := ((x + cast(s32) round_ptr[rc]) * cast(s32) quant_ptr[rc]) >> 16;
        x = y ^ sz - sz;
        qcoeff_ptr[rc] = cast,no_check(s16) x;
        dqcoeff_ptr[rc] = cast,no_check(s16) (x * cast(s32) dequant_ptr[rc]);

        if y != 0 {
            eob = i;
        }
    }
    d.eob.* = cast,no_check(s8) (eob + 1);
}

vp8_regular_quantize_b_c :: (b: *BLOCK, d: *BLOCKD) {
    y: s32 = ---;
    zbin_boost_ptr := b.zrun_zbin_boost;
    coeff_ptr := b.coeff;
    zbin_ptr := b.zbin;
    round_ptr := b.round;
    quant_ptr := b.quant;
    quant_shift_ptr := b.quant_shift;
    qcoeff_ptr := d.qcoeff;
    dqcoeff_ptr := d.dqcoeff;
    dequant_ptr := d.dequant;
    zbin_oq_value := b.zbin_extra;

    fill_memory(qcoeff_ptr, 0, 32);
    fill_memory(dqcoeff_ptr, 0, 32);

    eob: s32 = -1;

    for i: 0..cast(s32) 16 - 1 {
        rc := VP8_DEFAULT_ZIG_ZAG1D[i];
        z := cast,no_check(s32) coeff_ptr[rc];

        zbin := ((cast(s32) zbin_ptr[rc]) + cast(s32) zbin_boost_ptr.*) + cast(s32) zbin_oq_value;

        zbin_boost_ptr += 1;
        sz := z >> 31;
        x := z ^ sz - sz;

        if x >= zbin {
            x += cast,no_check(s32) round_ptr[rc];
            y = ((((x * cast(s32) quant_ptr[rc]) >> 16) + x) * cast(s32) quant_shift_ptr[rc]) >> 16;
            x = y ^ sz - sz;
            qcoeff_ptr[rc] = cast,no_check(s16) x;
            dqcoeff_ptr[rc] = cast,no_check(s16) (x * cast(s32) dequant_ptr[rc]);

            if y != 0 {
                eob = i;
                zbin_boost_ptr = b.zrun_zbin_boost;
            }
        }
    }

    d.eob.* = cast,no_check(s8) (eob + 1);
}

vp8_quantize_mb :: (x: *MACROBLOCK_in_block) {
    has_2nd_order :=
        cast(s32) (x.e_mbd.mode_info_context.mbmi.mode != cast,no_check(u8) B_PRED &&
            x.e_mbd.mode_info_context.mbmi.mode != cast,no_check(u8) SPLITMV);

    i: s32 = 0;
    while i < 24 + has_2nd_order {
        x.quantize_b(x.block.data + i, x.e_mbd.block.data + i);
        i += 1;
    }
}

vp8_quantize_mby :: (x: *MACROBLOCK_in_block) {
    has_2nd_order :=
        cast(s32) (x.e_mbd.mode_info_context.mbmi.mode != cast,no_check(u8) B_PRED &&
            x.e_mbd.mode_info_context.mbmi.mode != cast,no_check(u8) SPLITMV);

    for i: 0..cast(s32) 16 - 1 {
        x.quantize_b(x.block.data + i, x.e_mbd.block.data + i);
    }

    if has_2nd_order != 0 {
        x.quantize_b(x.block.data + 24, x.e_mbd.block.data + 24);
    }
}

vp8_quantize_mbuv :: (x: *MACROBLOCK_in_block) {
    if 16 < 24 {
        for i: 16..cast(s32) 24 - 1 {
            x.quantize_b(x.block.data + i, x.e_mbd.block.data + i);
        }
    }
}

vp8_set_quantizer :: (cpi: *VP8_COMP, q: s32) {
    cm := *cpi.common;
    mbd := *cpi.mb.e_mbd;
    update: s32 = 0;

    cm.base_qindex = q;

    cm.y1dc_delta_q = 0;
    cm.y2ac_delta_q = 0;

    new_delta_q: s32 = ifx q < 4
        then 4 - q
        else 0;

    update |= cast(s32) (cm.y2dc_delta_q != new_delta_q);
    cm.y2dc_delta_q = new_delta_q;

    new_uv_delta_q: s32 = 0;

    if cpi.oxcf.screen_content_mode != 0 && q > 40 {
        new_uv_delta_q = -(cast,no_check(s32) (0.15 * cast,no_check(float64) q));

        if new_uv_delta_q < -15 {
            new_uv_delta_q = -15;
        }
    }
    update |= cast(s32) (cm.uvdc_delta_q != new_uv_delta_q);
    cm.uvdc_delta_q = new_uv_delta_q;
    cm.uvac_delta_q = new_uv_delta_q;

    mbd.segment_feature_data[MB_LVL_ALT_Q][0] = cpi.segment_feature_data[MB_LVL_ALT_Q][0];
    mbd.segment_feature_data[MB_LVL_ALT_Q][1] = cpi.segment_feature_data[MB_LVL_ALT_Q][1];
    mbd.segment_feature_data[MB_LVL_ALT_Q][2] = cpi.segment_feature_data[MB_LVL_ALT_Q][2];
    mbd.segment_feature_data[MB_LVL_ALT_Q][3] = cpi.segment_feature_data[MB_LVL_ALT_Q][3];

    if update != 0 {
        vp8cx_init_quantizer(cpi);
    }
}

vp8cx_init_quantizer :: (cpi: *VP8_COMP) {
    i: s32 = ---;

    zbin_boost :=
        s32.[
            0,
            0,
            8,
            10,
            12,
            14,
            16,
            20,
            24,
            28,
            32,
            36,
            40,
            44,
            44,
            44
        ];

    for q: 0..cast(s32) (127 + 1) - 1 {
        quant_val := vp8_dc_quant(q, cpi.common.y1dc_delta_q);
        cpi.y1quant_fast[q][0] = cast,no_check(s16) ((cast(s32) 1) << 16 / quant_val);
        invert_quant(
            cpi.sf.improved_quant,
            cpi.y1quant[q].data,
            cpi.y1quant_shift[q].data,
            cast,no_check(s16) quant_val
        );
        cpi.y1zbin[q][0] = cast,no_check(s16) ((QZBIN_FACTORS_storage[q] * quant_val + 64) >> 7);
        cpi.y1round[q][0] = cast,no_check(s16) ((QROUNDING_FACTORS_storage[q] * quant_val) >> 7);
        cpi.common.y1dequant[q][0] = cast,no_check(s16) quant_val;
        cpi.zrun_zbin_boost_y1[q][0] = cast,no_check(s16) ((quant_val * zbin_boost[0]) >> 7);

        quant_val = vp8_dc2quant(q, cpi.common.y2dc_delta_q);
        cpi.y2quant_fast[q][0] = cast,no_check(s16) ((cast(s32) 1) << 16 / quant_val);
        invert_quant(
            cpi.sf.improved_quant,
            cpi.y2quant[q].data,
            cpi.y2quant_shift[q].data,
            cast,no_check(s16) quant_val
        );
        cpi.y2zbin[q][0] = cast,no_check(s16) ((QZBIN_FACTORS_Y2[q] * quant_val + 64) >> 7);
        cpi.y2round[q][0] = cast,no_check(s16) ((QROUNDING_FACTORS_Y2[q] * quant_val) >> 7);
        cpi.common.y2dequant[q][0] = cast,no_check(s16) quant_val;
        cpi.zrun_zbin_boost_y2[q][0] = cast,no_check(s16) ((quant_val * zbin_boost[0]) >> 7);

        quant_val = vp8_dc_uv_quant(q, cpi.common.uvdc_delta_q);
        cpi.u_vquant_fast[q][0] = cast,no_check(s16) ((cast(s32) 1) << 16 / quant_val);
        invert_quant(
            cpi.sf.improved_quant,
            cpi.u_vquant[q].data,
            cpi.u_vquant_shift[q].data,
            cast,no_check(s16) quant_val
        );
        cpi.u_vzbin[q][0] = cast,no_check(s16) ((QZBIN_FACTORS_storage[q] * quant_val + 64) >> 7);
        cpi.u_vround[q][0] = cast,no_check(s16) ((QROUNDING_FACTORS_storage[q] * quant_val) >> 7);
        cpi.common.u_vdequant[q][0] = cast,no_check(s16) quant_val;
        cpi.zrun_zbin_boost_uv[q][0] = cast,no_check(s16) ((quant_val * zbin_boost[0]) >> 7);

        quant_val = vp8_ac_yquant(q);
        cpi.y1quant_fast[q][1] = cast,no_check(s16) ((cast(s32) 1) << 16 / quant_val);
        invert_quant(
            cpi.sf.improved_quant,
            cpi.y1quant[q].data + 1,
            cpi.y1quant_shift[q].data + 1,
            cast,no_check(s16) quant_val
        );
        cpi.y1zbin[q][1] = cast,no_check(s16) ((QZBIN_FACTORS_storage[q] * quant_val + 64) >> 7);
        cpi.y1round[q][1] = cast,no_check(s16) ((QROUNDING_FACTORS_storage[q] * quant_val) >> 7);
        cpi.common.y1dequant[q][1] = cast,no_check(s16) quant_val;
        cpi.zrun_zbin_boost_y1[q][1] = cast,no_check(s16) ((quant_val * zbin_boost[1]) >> 7);

        quant_val = vp8_ac2quant(q, cpi.common.y2ac_delta_q);
        cpi.y2quant_fast[q][1] = cast,no_check(s16) ((cast(s32) 1) << 16 / quant_val);
        invert_quant(
            cpi.sf.improved_quant,
            cpi.y2quant[q].data + 1,
            cpi.y2quant_shift[q].data + 1,
            cast,no_check(s16) quant_val
        );
        cpi.y2zbin[q][1] = cast,no_check(s16) ((QZBIN_FACTORS_Y2[q] * quant_val + 64) >> 7);
        cpi.y2round[q][1] = cast,no_check(s16) ((QROUNDING_FACTORS_Y2[q] * quant_val) >> 7);
        cpi.common.y2dequant[q][1] = cast,no_check(s16) quant_val;
        cpi.zrun_zbin_boost_y2[q][1] = cast,no_check(s16) ((quant_val * zbin_boost[1]) >> 7);

        quant_val = vp8_ac_uv_quant(q, cpi.common.uvac_delta_q);
        cpi.u_vquant_fast[q][1] = cast,no_check(s16) ((cast(s32) 1) << 16 / quant_val);
        invert_quant(
            cpi.sf.improved_quant,
            cpi.u_vquant[q].data + 1,
            cpi.u_vquant_shift[q].data + 1,
            cast,no_check(s16) quant_val
        );
        cpi.u_vzbin[q][1] = cast,no_check(s16) ((QZBIN_FACTORS_storage[q] * quant_val + 64) >> 7);
        cpi.u_vround[q][1] = cast,no_check(s16) ((QROUNDING_FACTORS_storage[q] * quant_val) >> 7);
        cpi.common.u_vdequant[q][1] = cast,no_check(s16) quant_val;
        cpi.zrun_zbin_boost_uv[q][1] = cast,no_check(s16) ((quant_val * zbin_boost[1]) >> 7);

        i = 2;
        while i < 16 {
            cpi.y1quant_fast[q][i] = cpi.y1quant_fast[q][1];
            cpi.y1quant[q][i] = cpi.y1quant[q][1];
            cpi.y1quant_shift[q][i] = cpi.y1quant_shift[q][1];
            cpi.y1zbin[q][i] = cpi.y1zbin[q][1];
            cpi.y1round[q][i] = cpi.y1round[q][1];
            cpi.zrun_zbin_boost_y1[q][i] =
                cast,no_check(s16) (((cast(s32) cpi.common.y1dequant[q][1]) *
                    zbin_boost[i]) >> 7);

            cpi.y2quant_fast[q][i] = cpi.y2quant_fast[q][1];
            cpi.y2quant[q][i] = cpi.y2quant[q][1];
            cpi.y2quant_shift[q][i] = cpi.y2quant_shift[q][1];
            cpi.y2zbin[q][i] = cpi.y2zbin[q][1];
            cpi.y2round[q][i] = cpi.y2round[q][1];
            cpi.zrun_zbin_boost_y2[q][i] =
                cast,no_check(s16) (((cast(s32) cpi.common.y2dequant[q][1]) *
                    zbin_boost[i]) >> 7);

            cpi.u_vquant_fast[q][i] = cpi.u_vquant_fast[q][1];
            cpi.u_vquant[q][i] = cpi.u_vquant[q][1];
            cpi.u_vquant_shift[q][i] = cpi.u_vquant_shift[q][1];
            cpi.u_vzbin[q][i] = cpi.u_vzbin[q][1];
            cpi.u_vround[q][i] = cpi.u_vround[q][1];
            cpi.zrun_zbin_boost_uv[q][i] =
                cast,no_check(s16) (((cast(s32) cpi.common.u_vdequant[q][1]) *
                    zbin_boost[i]) >> 7);
            i += 1;
        }
    }
}

invert_quant :: (improved_quant: s32, quant: *s16, shift: *s16, d: s16) {
    if improved_quant != 0 {
        t := cast,no_check(u32) d;
        l := get_msb_in_vp8_quantize(t);
        m := 1 + (cast(s32) 1) << (((16 + l)) & 31) / cast(s32) d;
        quant.* = cast,no_check(s16) (m - (cast(s32) 1) << 16);
        shift.* = cast,no_check(s16) l;

        shift.* = cast,no_check(s16) ((cast(s32) 1) << (((16 - cast(s32) shift.*)) & 31));
    } else {
        quant.* = cast,no_check(s16) ((cast(s32) 1) << 16 / cast(s32) d);
        shift.* = 0;
    }
}

vp8cx_frame_init_quantizer :: (cpi: *VP8_COMP) {
    cpi.mb.zbin_mode_boost = 0;

    vp8cx_mb_init_quantizer(cpi, *cpi.mb, 0);
}

vp8cx_mb_init_quantizer :: (cpi: *VP8_COMP, x: *MACROBLOCK_in_block, ok_to_skip: s32) {
    q_index: s32 = ---;
    xd := *x.e_mbd;
    zbin_extra: s32 = ---;

    if xd.segmentation_enabled != 0 {
        if xd.mb_segment_abs_delta == 1 {
            q_index = cast,no_check(s32) xd.segment_feature_data[MB_LVL_ALT_Q][xd.mode_info_context.mbmi.segment_id];
        } else {
            q_index =
                cpi.common.base_qindex +
                    cast(s32) xd.segment_feature_data[MB_LVL_ALT_Q][xd.mode_info_context.mbmi.segment_id];

            q_index = ifx q_index >= 0 then (ifx q_index <= 127 then q_index else 127) else 0;
        }
    } else {
        q_index = cpi.common.base_qindex;
    }

    if ok_to_skip == 0 || q_index != x.q_index {
        xd.dequant_y1_dc[0] = 1;
        xd.dequant_y1[0] = cpi.common.y1dequant[q_index][0];
        xd.dequant_y2[0] = cpi.common.y2dequant[q_index][0];
        xd.dequant_uv[0] = cpi.common.u_vdequant[q_index][0];

        if 1 < 16 {
            for i: 1..cast(s32) 16 - 1 {
                xd.dequant_y1[i] = cpi.common.y1dequant[q_index][1];
                xd.dequant_y1_dc[i] = xd.dequant_y1[i];
                xd.dequant_y2[i] = cpi.common.y2dequant[q_index][1];
                xd.dequant_uv[i] = cpi.common.u_vdequant[q_index][1];
            }
        }

        for i: 0..cast(s32) 16 - 1 {
            x.e_mbd.block[i].dequant = xd.dequant_y1.data;
        }
        if 16 < 24 {
            for i: 16..cast(s32) 24 - 1 {
                x.e_mbd.block[i].dequant = xd.dequant_uv.data;
            }
        }
        x.e_mbd.block[24].dequant = xd.dequant_y2.data;

        zbin_extra =
            ((cast(s32) cpi.common.y1dequant[q_index][1]) *
                (x.zbin_over_quant + x.zbin_mode_boost + x.act_zbin_adj)) >> 7;

        for i: 0..cast(s32) 16 - 1 {
            x.block[i].quant = cpi.y1quant[q_index].data;
            x.block[i].quant_fast = cpi.y1quant_fast[q_index].data;
            x.block[i].quant_shift = cpi.y1quant_shift[q_index].data;
            x.block[i].zbin = cpi.y1zbin[q_index].data;
            x.block[i].round = cpi.y1round[q_index].data;
            x.block[i].zrun_zbin_boost = cpi.zrun_zbin_boost_y1[q_index].data;
            x.block[i].zbin_extra = cast,no_check(s16) zbin_extra;
        }

        zbin_extra =
            ((cast(s32) cpi.common.u_vdequant[q_index][1]) *
                (x.zbin_over_quant + x.zbin_mode_boost + x.act_zbin_adj)) >> 7;

        if 16 < 24 {
            for i: 16..cast(s32) 24 - 1 {
                x.block[i].quant = cpi.u_vquant[q_index].data;
                x.block[i].quant_fast = cpi.u_vquant_fast[q_index].data;
                x.block[i].quant_shift = cpi.u_vquant_shift[q_index].data;
                x.block[i].zbin = cpi.u_vzbin[q_index].data;
                x.block[i].round = cpi.u_vround[q_index].data;
                x.block[i].zrun_zbin_boost = cpi.zrun_zbin_boost_uv[q_index].data;
                x.block[i].zbin_extra = cast,no_check(s16) zbin_extra;
            }
        }

        zbin_extra =
            ((cast(s32) cpi.common.y2dequant[q_index][1]) *
                (x.zbin_over_quant / 2 + x.zbin_mode_boost + x.act_zbin_adj)) >> 7;

        x.block[24].quant_fast = cpi.y2quant_fast[q_index].data;
        x.block[24].quant = cpi.y2quant[q_index].data;
        x.block[24].quant_shift = cpi.y2quant_shift[q_index].data;
        x.block[24].zbin = cpi.y2zbin[q_index].data;
        x.block[24].round = cpi.y2round[q_index].data;
        x.block[24].zrun_zbin_boost = cpi.zrun_zbin_boost_y2[q_index].data;
        x.block[24].zbin_extra = cast,no_check(s16) zbin_extra;

        x.q_index = q_index;

        x.last_zbin_over_quant = x.zbin_over_quant;
        x.last_zbin_mode_boost = x.zbin_mode_boost;
        x.last_act_zbin_adj = x.act_zbin_adj;
    } else if x.last_zbin_over_quant != x.zbin_over_quant ||
        x.last_zbin_mode_boost != x.zbin_mode_boost ||
        x.last_act_zbin_adj != x.act_zbin_adj {
        zbin_extra =
            ((cast(s32) cpi.common.y1dequant[q_index][1]) *
                (x.zbin_over_quant + x.zbin_mode_boost + x.act_zbin_adj)) >> 7;

        for i: 0..cast(s32) 16 - 1 {
            x.block[i].zbin_extra = cast,no_check(s16) zbin_extra;
        }

        zbin_extra =
            ((cast(s32) cpi.common.u_vdequant[q_index][1]) *
                (x.zbin_over_quant + x.zbin_mode_boost + x.act_zbin_adj)) >> 7;

        if 16 < 24 {
            for i: 16..cast(s32) 24 - 1 {
                x.block[i].zbin_extra = cast,no_check(s16) zbin_extra;
            }
        }

        zbin_extra =
            ((cast(s32) cpi.common.y2dequant[q_index][1]) *
                (x.zbin_over_quant / 2 + x.zbin_mode_boost + x.act_zbin_adj)) >> 7;
        x.block[24].zbin_extra = cast,no_check(s16) zbin_extra;

        x.last_zbin_over_quant = x.zbin_over_quant;
        x.last_zbin_mode_boost = x.zbin_mode_boost;
        x.last_act_zbin_adj = x.act_zbin_adj;
    }
}

vp8_update_zbin_extra :: (cpi: *VP8_COMP, x: *MACROBLOCK_in_block) {
    q_index := x.q_index;
    zbin_extra :=
        ((cast(s32) cpi.common.y1dequant[q_index][1]) *
            (x.zbin_over_quant + x.zbin_mode_boost + x.act_zbin_adj)) >> 7;

    for i: 0..cast(s32) 16 - 1 {
        x.block[i].zbin_extra = cast,no_check(s16) zbin_extra;
    }

    zbin_extra =
        ((cast(s32) cpi.common.u_vdequant[q_index][1]) *
            (x.zbin_over_quant + x.zbin_mode_boost + x.act_zbin_adj)) >> 7;

    if 16 < 24 {
        for i: 16..cast(s32) 24 - 1 {
            x.block[i].zbin_extra = cast,no_check(s16) zbin_extra;
        }
    }

    zbin_extra =
        ((cast(s32) cpi.common.y2dequant[q_index][1]) *
            (x.zbin_over_quant / 2 + x.zbin_mode_boost + x.act_zbin_adj)) >> 7;
    x.block[24].zbin_extra = cast,no_check(s16) zbin_extra;
}

vp8_sem_wait_in_vp8_quantize :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_0: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_0; assignment_0; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init_in_vp8_quantize :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release_in_vp8_quantize :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

atomic_load_acquire_in_vp8_quantize :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_atomic_spin_wait_in_vp8_quantize :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire_in_vp8_quantize(last_row_current_mb_col) - NSYNC {
    }
}

mv_bias_in_vp8_quantize :: (
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

vp8_clamp_mv2_in_vp8_quantize :: (mv: *Int_Mv_in_mv, xd: *MACROBLOCKD_in_blockd) {
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

vp8_clamp_mv_in_vp8_quantize :: (
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

vp8_check_mv_bounds_in_vp8_quantize :: (
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

left_block_mv_in_vp8_quantize :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> u32 {
    if b & 3 == 0 {
        cur_mb -= 1;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 4;
    }

    return (((cur_mb.bmi.data + b - 1)).mv).as_int;
}

above_block_mv_in_vp8_quantize :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> u32 {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 16;
    }

    return (((cur_mb.bmi.data + (b - 4))).mv).as_int;
}

left_block_mode_in_vp8_quantize :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> B_PREDICTION_MODE {
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

above_block_mode_in_vp8_quantize :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> B_PREDICTION_MODE {
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

globals_initialization_state_for_vp8_quantize: u32;
initialize_globals_for_vp8_quantize :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp8_quantize);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp8_quantize, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp8_quantize) != 2 {}
            return;
        }
    }
    QROUNDING_FACTORS_storage =
        s32.[
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48
        ];
    QZBIN_FACTORS_storage =
        s32.[
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80
        ];
    QROUNDING_FACTORS_Y2 =
        s32.[
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48
        ];
    QZBIN_FACTORS_Y2 =
        s32.[
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            84,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80,
            80
        ];
    atomic_store(*globals_initialization_state_for_vp8_quantize, 2);
}

