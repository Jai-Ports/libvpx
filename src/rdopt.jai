BEST_MODE :: Best_Mode_Struct;

Best_Mode_Struct :: struct {
    yrd: s32 #align 4;
    rd: s32 #align 1;
    intra_rd: s32 #align 1;
    mbmode: MB_MODE_INFO #align 1;
    bmodes: [16] B_Mode_Info_in_blockd #align 1;
    partition: PARTITION_INFO #align 1;
} #no_padding;

RATE_DISTORTION :: Rate_Distortion_Struct;

Rate_Distortion_Struct :: struct {
    rate2: s32;
    rate_y: s32;
    rate_uv: s32;
    distortion2: s32;
    distortion_uv: s32;
}

BEST_SEG_INFO :: struct {
    ref_mv: *Int_Mv_in_mv #align 8;
    mvp: Int_Mv_in_mv #align 1;
    segment_rd: s32 #align 1;
    segment_num: s32 #align 1;
    r: s32 #align 1;
    d: s32 #align 1;
    segment_yrate: s32 #align 1;
    modes: [16] B_PREDICTION_MODE #align 1;
    mvs: [16] Int_Mv_in_mv #align 1;
    eobs: [16] u8 #align 1;
    mvthresh: s32 #align 1;
    layout_padding_0: [4] u8 #align 1;
    mdcounts: *s32 #align 1;
    sv_mvp: [4] Int_Mv_in_mv #align 1;
    sv_istep: [2] s32 #align 1;
} #no_padding;

SAD_PER_BIT4LUT: [128] s32;

SAD_PER_BIT16LUT: [128] s32;

AUTO_SPEED_THRESH: [17] s32;

RD_IIFACTOR: [32] s32;

SEGMENTATION_TO_SSESHIFT: [4] u32;

VP8_REF_FRAME_ORDER: [20] s32;

VP8_MODE_ORDER: [20] MB_PREDICTION_MODE;

vp8_block_error_c :: (coeff: *s16, dqcoeff: *s16) -> s32 {
    error: s32 = 0;

    for i: 0..cast(s32) 16 - 1 {
        this_diff := (cast(s32) coeff[i]) - cast(s32) dqcoeff[i];
        error += this_diff * this_diff;
    }

    return error;
}

vp8_mbblock_error_c :: (mb: *MACROBLOCK_in_block, dc: s32) -> s32 {
    j: s32 = ---;
    error: s32 = 0;

    for i: 0..cast(s32) 16 - 1 {
        be := mb.block.data + i;
        bd := mb.e_mbd.block.data + i;

        berror: s32 = 0;

        j = dc;
        while j < 16 {
            this_diff := (cast(s32) be.coeff[j]) - cast(s32) bd.dqcoeff[j];
            berror += this_diff * this_diff;
            j += 1;
        }

        error += berror;
    }

    return error;
}

vp8_mbuverror_c :: (mb: *MACROBLOCK_in_block) -> s32 {
    error: s32 = 0;

    if 16 < 24 {
        for i: 16..cast(s32) 24 - 1 {
            be := mb.block.data + i;
            bd := mb.e_mbd.block.data + i;

            error += vp8_block_error_c(be.coeff, bd.dqcoeff);
        }
    }

    return error;
}

clip_pixel_in_rdopt :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_rdopt :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_rdopt :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_rdopt :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_rdopt :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_rdopt(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_rdopt(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_rdopt(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_rdopt :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_rdopt :: (FILTER: *s16) -> s32 {
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

vp8_set_reference_value_in_rdopt :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_rdopt :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_rdopt :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_rdopt :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_rdopt :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_rdopt :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_rdopt :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_rdopt :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_rdopt :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_rdopt :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_rdopt :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_rdopt :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_rdopt :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_rdopt :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_rdopt :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_rdopt :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_rdopt :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_rdopt :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_rdopt :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_rdopt :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_rdopt :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_rdopt :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_rdopt :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_rdopt :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_rdopt :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_rdopt :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

scale2_ratio_in_rdopt :: (mode: s32, hr: *s32, hs: *s32) {
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

validate_buffer_in_rdopt :: (start: *u8, len: u64, end: *u8, error: *Internal_Error_Info) -> s32 {
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

vp8_encode_bool_in_rdopt :: (bc: *BOOL_CODER, bit: s32, probability: s32) {
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

        validate_buffer_in_rdopt(bc.buffer + bc.pos, 1, bc.buffer_end, bc.error);
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

vp8_cost_branch_in_rdopt :: (ct: *u32, p: Vp8_Prob) -> u32 {
    return cast,no_check(u32) ((((cast,no_check(u64) ct[0]) * cast(u64) VP8_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP8_PROB_COST[255 - cast(s32) p]) >> 8);
}

vp8_treed_write_in_rdopt :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) {
    i: Vp8_Tree_Index = 0;

    while true {
        {
            B := v >> ((c_transpiler_pre_decrement(*(n))) & 31) & 1;
            vp8_encode_bool_in_rdopt(W, B, cast,no_check(s32) P[(cast(s32) i) >> 1]);
            i = t[(cast(s32) i) + B];
        }
        if n == 0 break;
    }
}

vp8_write_token_in_rdopt :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) {
    vp8_treed_write_in_rdopt(W, t, P, X.value, X.len);
}

vp8_treed_cost_in_rdopt :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) -> s32 {
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

vp8_cost_token_in_rdopt :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) -> s32 {
    return vp8_treed_cost_in_rdopt(t, P, X.value, X.len);
}

vp8_sem_wait_in_rdopt :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_0: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_0; assignment_0; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init_in_rdopt :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release_in_rdopt :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

atomic_load_acquire_in_rdopt :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_atomic_spin_wait_in_rdopt :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire_in_rdopt(last_row_current_mb_col) - NSYNC {
    }
}

mv_bias_in_rdopt :: (refmb_ref_frame_sign_bias: s32, refframe: s32, mvp: *Int_Mv_in_mv, ref_frame_sign_bias: *s32) {
    if refmb_ref_frame_sign_bias != ref_frame_sign_bias[refframe] {
        mvp.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.row) * -1);
        mvp.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.col) * -1);
    }
}

vp8_clamp_mv2_in_rdopt :: (mv: *Int_Mv_in_mv, xd: *MACROBLOCKD_in_blockd) {
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

vp8_clamp_mv_in_rdopt :: (
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

vp8_check_mv_bounds_in_rdopt :: (
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

left_block_mv_in_rdopt :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> u32 {
    if b & 3 == 0 {
        cur_mb -= 1;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 4;
    }

    return (((cur_mb.bmi.data + b - 1)).mv).as_int;
}

above_block_mv_in_rdopt :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> u32 {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 16;
    }

    return (((cur_mb.bmi.data + (b - 4))).mv).as_int;
}

left_block_mode_in_rdopt :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> B_PREDICTION_MODE {
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

above_block_mode_in_rdopt :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> B_PREDICTION_MODE {
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

intra_prediction_down_copy_in_rdopt :: (xd: *MACROBLOCKD_in_blockd, above_right_src: *u8) {
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

vp8cx_initialize_me_consts :: (cpi: *VP8_COMP, q_index: s32) {
    cpi.mb.sadperbit16 = SAD_PER_BIT16LUT[q_index];
    cpi.mb.sadperbit4 = SAD_PER_BIT4LUT[q_index];
}

vp8_auto_select_speed :: (cpi: *VP8_COMP) {
    milliseconds_for_compress := cast,no_check(s32) (1000000.0 / cpi.framerate);

    milliseconds_for_compress = milliseconds_for_compress * (16 - cpi.oxcf.cpu_used) / 16;

    if cpi.avg_pick_mode_time < milliseconds_for_compress &&
        cpi.avg_encode_time - cpi.avg_pick_mode_time < milliseconds_for_compress {
        if cpi.avg_pick_mode_time == 0 {
            cpi.speed = 4;
        } else {
            if milliseconds_for_compress * 100 < cpi.avg_encode_time * 95 {
                cpi.speed += 2;
                cpi.avg_pick_mode_time = 0;
                cpi.avg_encode_time = 0;

                if cpi.speed > 16 {
                    cpi.speed = 16;
                }
            }

            if milliseconds_for_compress * 100 > cpi.avg_encode_time * AUTO_SPEED_THRESH[cpi.speed] {
                cpi.speed -= 1;
                cpi.avg_pick_mode_time = 0;
                cpi.avg_encode_time = 0;

                if cpi.speed < 4 {
                    cpi.speed = 4;
                }
            }
        }
    } else {
        cpi.speed += 4;

        if cpi.speed > 16 {
            cpi.speed = 16;
        }

        cpi.avg_pick_mode_time = 0;
        cpi.avg_encode_time = 0;
    }
}

insertsortmv_in_rdopt :: (arr: *s32, len: s32) {
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

insertsortsad_in_rdopt :: (arr: *s32, idx: *s32, len: s32) {
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

vp8_initialize_rd_consts :: (cpi: *VP8_COMP, x: *MACROBLOCK_in_block, qvalue: s32) {
    capped_q := (ifx qvalue < 160 then cast,no_check(float64) qvalue else 160.0);
    rdconst: float64 = 2.8;

    cpi.rdmult = cast,no_check(s32) (rdconst * (capped_q * capped_q));

    if cpi.mb.zbin_over_quant > 0 {
        oq_factor := 1.0 + 0.0015625 * cast,no_check(float64) cpi.mb.zbin_over_quant;
        modq := cast,no_check(float64) (cast,no_check(s32) (capped_q * oq_factor));
        cpi.rdmult = cast,no_check(s32) (rdconst * (modq * modq));
    }

    if cpi.pass == 2 && cpi.common.frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
        if cpi.twopass.next_iiratio > 31 {
            cpi.rdmult += (cpi.rdmult * RD_IIFACTOR[31]) >> 4;
        } else {
            cpi.rdmult += (cpi.rdmult * RD_IIFACTOR[cpi.twopass.next_iiratio]) >> 4;
        }
    }

    cpi.mb.errorperbit = cpi.rdmult / 110;
    cpi.mb.errorperbit += cast(s32) (cpi.mb.errorperbit == 0);

    vp8_set_speed_features(cpi);

    for i: 0..cast(s32) 20 - 1 {
        x.mode_test_hit_counts[i] = 0;
    }

    q := cast,no_check(s32) c_transpiler_math_pow(cast,no_check(float64) qvalue, 1.25);

    if q < 8 {
        q = 8;
    }

    if cpi.rdmult > 1000 {
        cpi.rddiv = 1;
        cpi.rdmult /= 100;

        for i: 0..cast(s32) 20 - 1 {
            if cpi.sf.thresh_mult[i] < 2147483647 {
                x.rd_threshes[i] = cpi.sf.thresh_mult[i] * q / 100;
            } else {
                x.rd_threshes[i] = 2147483647;
            }

            cpi.rd_baseline_thresh[i] = x.rd_threshes[i];
        }
    } else {
        cpi.rddiv = 100;

        for i: 0..cast(s32) 20 - 1 {
            if cpi.sf.thresh_mult[i] < 2147483647 / q {
                x.rd_threshes[i] = cpi.sf.thresh_mult[i] * q;
            } else {
                x.rd_threshes[i] = 2147483647;
            }

            cpi.rd_baseline_thresh[i] = x.rd_threshes[i];
        }
    }

    {
        l := *cpi.lfc_n;

        if cpi.common.refresh_alt_ref_frame != 0 {
            l = *cpi.lfc_a;
        } else if cpi.common.refresh_golden_frame != 0 {
            l = *cpi.lfc_g;
        }

        fill_token_costs(cpi.mb.token_costs, l.coef_probs.data);

        vp8_init_mode_costs(cpi);
    }
}

fill_token_costs :: (c: *[8] [3] [12] s32, p: *[8] [3] [11] Vp8_Prob) {
    j: s32 = ---;
    k: s32 = ---;

    for i: 0..cast(s32) 4 - 1 {
        j = 0;
        while j < 8 {
            k = 0;
            while k < 3 {
                if k == 0 && j > cast(s32) (i == 0) {
                    vp8_cost_tokens2(c[i][j][k].data, p[i][j][k].data, cast(*Vp8_Tree_Index) *(VP8_COEF_TREE), 2);
                } else {
                    vp8_cost_tokens(c[i][j][k].data, p[i][j][k].data, cast(*Vp8_Tree_Index) *(VP8_COEF_TREE));
                }
                k += 1;
            }
            j += 1;
        }
    }
}

vp8_rd_pick_inter_mode :: (
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
    b: *BLOCK = ---;
    d: *BLOCKD = ---;
    xd: *MACROBLOCKD_in_blockd = ---;
    best_ref_mv_sb: [2] Int_Mv_in_mv = ---;
    mode_mv_sb: [2] [10] Int_Mv_in_mv = ---;
    best_ref_mv: Int_Mv_in_mv = ---;
    mode_mv: *Int_Mv_in_mv = ---;
    this_mode: MB_PREDICTION_MODE = ---;
    num00: s32 = ---;
    best_mode_index: s32 = ---;
    best_mode: Best_Mode_Struct = ---;
    i: s32 = ---;
    mode_index: s32 = ---;
    mdcounts: [4] s32 = ---;
    rate: s32 = ---;
    rd: Rate_Distortion_Struct = ---;
    uv_intra_rate: s32 = ---;
    uv_intra_distortion: s32 = ---;
    uv_intra_rate_tokenonly: s32 = ---;
    uv_intra_tteob: s32 = ---;
    uv_intra_done: s32 = ---;
    uv_intra_mode: MB_PREDICTION_MODE = ---;
    mvp: Int_Mv_in_mv = ---;
    near_sadidx: [8] s32 = ---;
    saddone: s32 = ---;
    sr: s32 = ---;
    plane: [4] [3] *u8 = ---;
    ref_frame_map: [4] s32 = ---;
    sign_bias: s32 = ---;
    intra_rd_penalty: s32 = ---;
    zero_mv_sse: u32 = ---;
    best_sse: u32 = ---;
    best_rd_sse: u32 = ---;
    this_rd: s32 = ---;
    disable_skip: s32 = ---;
    other_cost: s32 = ---;
    this_ref_frame: s32 = ---;
    tmp_rd: s32 = ---;
    distortion: s32 = ---;
    tmp_rd_2: s32 = ---;
    this_rd_thresh: s32 = ---;
    distortion_2: s32 = ---;
    distortion_3: s32 = ---;
    thissme: s32 = ---;
    bestsme: s32 = ---;
    step_param: s32 = ---;
    further_steps: s32 = ---;
    n: s32 = ---;
    do_refine: s32 = ---;
    sadpb: s32 = ---;
    mvp_full: Int_Mv_in_mv = ---;
    col_min: s32 = ---;
    row_min: s32 = ---;
    col_max: s32 = ---;
    row_max: s32 = ---;
    tmp_col_min: s32 = ---;
    tmp_col_max: s32 = ---;
    tmp_row_min: s32 = ---;
    tmp_row_max: s32 = ---;
    search_range: s32 = ---;
    dis: s32 = ---;
    sse: u32 = ---;
    sse_2: u32 = ---;
    best_adjustment: s32 = ---;
    block_index: s32 = ---;
    this_rd_2: s32 = ---;
    disable_skip_2: s32 = ---;
    other_cost_2: s32 = ---;
    this_ref_frame_2: s32 = ---;
    code_block_to_execute: s64 = 324;
    while c_transpiler_dispatch := true {
        if code_block_to_execute < 0 break;
        if code_block_to_execute == {
            case 11; {
                rd_update_mvcount(x, *best_ref_mv);
                break c_transpiler_dispatch;
            }
            case 13; {
                if sign_bias != cpi.common.ref_frame_sign_bias[xd.mode_info_context.mbmi.ref_frame] {
                    best_ref_mv.as_int = best_ref_mv_sb[cast(s32) (sign_bias == 0)].as_int;
                    code_block_to_execute = 11;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 11;
                    continue c_transpiler_dispatch;
                }
            }
            case 16; {
                while c_transpiler_local_loop := true {
                    if i < 16 {
                        xd.mode_info_context.bmi[i].mv.as_int = best_mode.bmodes[i].mv.as_int;
                        i += 1;
                        continue c_transpiler_local_loop;
                    } else {
                        x.partition_info.* = best_mode.partition;
                        x.e_mbd.mode_info_context.mbmi.mv.as_int = x.partition_info.bmi[15].mv.as_int;
                        code_block_to_execute = 13;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 20; {
                if best_mode.mbmode.mode == cast,no_check(u8) SPLITMV {
                    i = 0;
                    code_block_to_execute = 16;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 13;
                    continue c_transpiler_dispatch;
                }
            }
            case 21; {
                while c_transpiler_local_loop := true {
                    if i < 16 {
                        xd.mode_info_context.bmi[i].as_mode = best_mode.bmodes[i].as_mode;
                        i += 1;
                        continue c_transpiler_local_loop;
                    } else {
                        code_block_to_execute = 20;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 34; {
                if cpi.is_src_frame_alt_ref != 0 && (best_mode.mbmode.mode != cast,no_check(u8) ZEROMV || best_mode.mbmode.ref_frame != cast,no_check(u8) ALTREF_FRAME) {
                    x.e_mbd.mode_info_context.mbmi.mode = cast,no_check(u8) ZEROMV;
                    x.e_mbd.mode_info_context.mbmi.ref_frame = cast,no_check(u8) ALTREF_FRAME;
                    x.e_mbd.mode_info_context.mbmi.mv.as_int = 0;
                    x.e_mbd.mode_info_context.mbmi.uv_mode = cast,no_check(u8) DC_PRED;
                    x.e_mbd.mode_info_context.mbmi.mb_skip_coeff = cast,no_check(u8) cpi.common.mb_no_coeff_skip;
                    x.e_mbd.mode_info_context.mbmi.partitioning = 0;
                    return;
                } else {
                    x.e_mbd.mode_info_context.mbmi = best_mode.mbmode;
                    if best_mode.mbmode.mode == cast,no_check(u8) B_PRED {
                        i = 0;
                        code_block_to_execute = 21;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 20;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 55; {
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
                    0
                );
                if best_mode.mbmode.ref_frame == cast,no_check(u8) INTRA_FRAME && x.best_zeromv_reference_frame != cast,no_check(u32) INTRA_FRAME {
                    this_rd_2 = 2147483647;
                    disable_skip_2 = 0;
                    other_cost_2 = 0;
                    this_ref_frame_2 = cast,no_check(s32) x.best_zeromv_reference_frame;
                    rd.rate2 =
                        x.ref_frame_cost[this_ref_frame_2] +
                            vp8_cost_mv_ref(cast,no_check(MB_PREDICTION_MODE) ZEROMV, mdcounts.data);
                    rd.distortion2 = 0;
                    x.e_mbd.mode_info_context.mbmi.ref_frame = cast,no_check(u8) this_ref_frame_2;
                    x.e_mbd.pre.y_buffer = plane[this_ref_frame_2][0];
                    x.e_mbd.pre.u_buffer = plane[this_ref_frame_2][1];
                    x.e_mbd.pre.v_buffer = plane[this_ref_frame_2][2];
                    x.e_mbd.mode_info_context.mbmi.mode = cast,no_check(u8) ZEROMV;
                    x.e_mbd.mode_info_context.mbmi.uv_mode = cast,no_check(u8) DC_PRED;
                    x.e_mbd.mode_info_context.mbmi.mv.as_int = 0;
                    this_rd_2 = evaluate_inter_mode_rd(mdcounts.data, *rd, *disable_skip_2, cpi, x);
                    this_rd_2 =
                        calculate_final_rd_costs(
                            this_rd_2,
                            *rd,
                            *other_cost_2,
                            disable_skip_2,
                            uv_intra_tteob,
                            intra_rd_penalty,
                            cpi,
                            x
                        );
                    if this_rd_2 < best_mode.rd || x.skip != 0 {
                        returnrate.* = rd.rate2;
                        returndistortion.* = rd.distortion2;
                        update_best_mode(*best_mode, this_rd_2, *rd, other_cost_2, x);
                        code_block_to_execute = 34;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 34;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 34;
                    continue c_transpiler_dispatch;
                }
            }
            case 63; {
                if cpi.oxcf.noise_sensitivity != 0 {
                    block_index = mb_row * cpi.common.mb_cols + mb_col;
                    if x.best_sse_inter_mode == cast,no_check(u32) DC_PRED {
                        x.best_sse_inter_mode = cast,no_check(MB_PREDICTION_MODE) best_mode.mbmode.mode;
                        x.best_sse_mv = best_mode.mbmode.mv;
                        x.need_to_clamp_best_mvs = best_mode.mbmode.need_to_clamp_mvs;
                        x.best_reference_frame =
                            cast,no_check(MV_REFERENCE_FRAME_in_alloccommon) best_mode.mbmode.ref_frame;
                        best_sse = best_rd_sse;
                        code_block_to_execute = 55;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 55;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 34;
                    continue c_transpiler_dispatch;
                }
            }
            case 67; {
                if cpi.rd_baseline_thresh[best_mode_index] > 0 && cpi.rd_baseline_thresh[best_mode_index] < S32_MAX >> 2 {
                    best_adjustment = x.rd_thresh_mult[best_mode_index] >> 2;
                    x.rd_thresh_mult[best_mode_index] =
                        ifx x.rd_thresh_mult[best_mode_index] >= 32 +
                            best_adjustment then x.rd_thresh_mult[best_mode_index] - best_adjustment else 32;
                    x.rd_threshes[best_mode_index] =
                        cpi.rd_baseline_thresh[best_mode_index] >> 7 *
                            x.rd_thresh_mult[best_mode_index];
                    code_block_to_execute = 63;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 63;
                    continue c_transpiler_dispatch;
                }
            }
            case 68; {
                if mode_index < 20 {
                    code_block_to_execute = 275;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 67;
                    continue c_transpiler_dispatch;
                }
            }
            case 69; {
                mode_index += 1;
                code_block_to_execute = 68;
                continue c_transpiler_dispatch;
            }
            case 72; {
                x.rd_threshes[mode_index] = cpi.rd_baseline_thresh[mode_index] >> 7 * x.rd_thresh_mult[mode_index];
                if x.skip != 0 {
                    code_block_to_execute = 67;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 69;
                    continue c_transpiler_dispatch;
                }
            }
            case 77; {
                update_best_mode(*best_mode, this_rd, *rd, other_cost, x);
                x.rd_thresh_mult[mode_index] =
                    ifx x.rd_thresh_mult[mode_index] >= 32 +
                        2 then x.rd_thresh_mult[mode_index] - 2 else 32;
                code_block_to_execute = 72;
                continue c_transpiler_dispatch;
            }
            case 84; {
                if this_rd < best_mode.rd || x.skip != 0 {
                    best_mode_index = mode_index;
                    returnrate.* = rd.rate2;
                    returndistortion.* = rd.distortion2;
                    if this_mode <= cast,no_check(u32) B_PRED {
                        x.e_mbd.mode_info_context.mbmi.uv_mode = cast,no_check(u8) uv_intra_mode;
                        x.e_mbd.mode_info_context.mbmi.mv.as_int = 0;
                        code_block_to_execute = 77;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 77;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    x.rd_thresh_mult[mode_index] += 4;
                    if x.rd_thresh_mult[mode_index] > 512 {
                        x.rd_thresh_mult[mode_index] = 512;
                        code_block_to_execute = 72;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 72;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 91; {
                if x.e_mbd.mode_info_context.mbmi.mode == cast,no_check(u8) NEWMV && sse_2 < best_sse {
                    best_sse = sse_2;
                    vp8_get_inter_mbpred_error(x, cpi.fn_ptr.data + BLOCK_16X16, *best_sse, mode_mv[this_mode]);
                    x.best_sse_inter_mode = cast,no_check(MB_PREDICTION_MODE) NEWMV;
                    x.best_sse_mv = x.e_mbd.mode_info_context.mbmi.mv;
                    x.need_to_clamp_best_mvs = x.e_mbd.mode_info_context.mbmi.need_to_clamp_mvs;
                    x.best_reference_frame =
                        cast,no_check(MV_REFERENCE_FRAME_in_alloccommon) x.e_mbd.mode_info_context.mbmi.ref_frame;
                    code_block_to_execute = 84;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 84;
                    continue c_transpiler_dispatch;
                }
            }
            case 94; {
                if this_mode == cast,no_check(u32) ZEROMV && sse_2 < zero_mv_sse {
                    zero_mv_sse = sse_2;
                    x.best_zeromv_reference_frame =
                        cast,no_check(MV_REFERENCE_FRAME_in_alloccommon) x.e_mbd.mode_info_context.mbmi.ref_frame;
                    code_block_to_execute = 91;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 91;
                    continue c_transpiler_dispatch;
                }
            }
            case 99; {
                if cpi.oxcf.noise_sensitivity != 0 {
                    vp8_get_inter_mbpred_error(x, cpi.fn_ptr.data + BLOCK_16X16, *sse_2, mode_mv[this_mode]);
                    if sse_2 < best_rd_sse {
                        best_rd_sse = sse_2;
                        code_block_to_execute = 94;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 94;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 84;
                    continue c_transpiler_dispatch;
                }
            }
            case 103; {
                this_rd =
                    calculate_final_rd_costs(
                        this_rd,
                        *rd,
                        *other_cost,
                        disable_skip,
                        uv_intra_tteob,
                        intra_rd_penalty,
                        cpi,
                        x
                    );
                if x.e_mbd.mode_info_context.mbmi.ref_frame == cast,no_check(u8) INTRA_FRAME && this_rd < best_mode.intra_rd {
                    best_mode.intra_rd = this_rd;
                    returnintra.* = rd.distortion2;
                    code_block_to_execute = 99;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 99;
                    continue c_transpiler_dispatch;
                }
            }
            case 109; {
                if (cast(s32) mode_mv[this_mode].as_mv.row) >> 3 < x.mv_row_min || (cast(s32) mode_mv[this_mode].as_mv.row) >> 3 > x.mv_row_max || (cast(s32) mode_mv[this_mode].as_mv.col) >> 3 < x.mv_col_min || (cast(s32) mode_mv[this_mode].as_mv.col) >> 3 > x.mv_col_max {
                    code_block_to_execute = 69;
                    continue c_transpiler_dispatch;
                } else {
                    vp8_set_mbmode_and_mvs(x, this_mode, *mode_mv[this_mode]);
                    this_rd = evaluate_inter_mode_rd(mdcounts.data, *rd, *disable_skip, cpi, x);
                    code_block_to_execute = 103;
                    continue c_transpiler_dispatch;
                }
            }
            case 112; {
                vp8_clamp_mv2_in_rdopt(*mode_mv[this_mode], xd);
                if (this_mode == cast,no_check(u32) NEARMV || this_mode == cast,no_check(u32) NEARESTMV) && mode_mv[this_mode].as_int == 0 {
                    code_block_to_execute = 69;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 109;
                    continue c_transpiler_dispatch;
                }
            }
            case 114; {
                mode_mv[NEWMV].as_int = d.bmi.mv.as_int;
                rd.rate2 += vp8_mv_bit_cost(*mode_mv[NEWMV], *best_ref_mv, x.mvcost.data, 96);
                code_block_to_execute = 112;
                continue c_transpiler_dispatch;
            }
            case 122; {
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
                        x.mvcost.data,
                        *dis,
                        *sse
                    );
                    code_block_to_execute = 114;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 114;
                    continue c_transpiler_dispatch;
                }
            }
            case 131; {
                if n < further_steps {
                    code_block_to_execute = 141;
                    continue c_transpiler_dispatch;
                } else {
                    if do_refine == 1 {
                        search_range = 8;
                        thissme =
                            cpi.refining_search_sad(
                                x,
                                b,
                                d,
                                *d.bmi.mv,
                                sadpb,
                                search_range,
                                cpi.fn_ptr.data + BLOCK_16X16,
                                x.mvcost.data,
                                *best_ref_mv
                            );
                        if thissme < bestsme {
                            bestsme = thissme;
                            mode_mv[NEWMV].as_int = d.bmi.mv.as_int;
                            code_block_to_execute = 122;
                            continue c_transpiler_dispatch;
                        } else {
                            d.bmi.mv.as_int = mode_mv[NEWMV].as_int;
                            code_block_to_execute = 122;
                            continue c_transpiler_dispatch;
                        }
                    } else {
                        code_block_to_execute = 122;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 135; {
                if thissme < bestsme {
                    bestsme = thissme;
                    mode_mv[NEWMV].as_int = d.bmi.mv.as_int;
                    code_block_to_execute = 131;
                    continue c_transpiler_dispatch;
                } else {
                    d.bmi.mv.as_int = mode_mv[NEWMV].as_int;
                    code_block_to_execute = 131;
                    continue c_transpiler_dispatch;
                }
            }
            case 141; {
                n += 1;
                if num00 != 0 {
                    num00 -= 1;
                    code_block_to_execute = 131;
                    continue c_transpiler_dispatch;
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
                    if num00 > further_steps - n {
                        do_refine = 0;
                        code_block_to_execute = 135;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 135;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 148; {
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
                further_steps = cpi.sf.max_step_search_steps - 1 - step_param;
                n = num00;
                num00 = 0;
                if n > further_steps {
                    do_refine = 0;
                    code_block_to_execute = 131;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 131;
                    continue c_transpiler_dispatch;
                }
            }
            case 150; {
                if sr > step_param {
                    step_param = sr;
                    code_block_to_execute = 148;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 148;
                    continue c_transpiler_dispatch;
                }
            }
            case 152; {
                if x.mv_row_max > row_max {
                    x.mv_row_max = row_max;
                    code_block_to_execute = 150;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 150;
                    continue c_transpiler_dispatch;
                }
            }
            case 154; {
                if x.mv_row_min < row_min {
                    x.mv_row_min = row_min;
                    code_block_to_execute = 152;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 152;
                    continue c_transpiler_dispatch;
                }
            }
            case 156; {
                if x.mv_col_max > col_max {
                    x.mv_col_max = col_max;
                    code_block_to_execute = 154;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 154;
                    continue c_transpiler_dispatch;
                }
            }
            case 161; {
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
                mvp_full.as_mv.col = cast,no_check(s16) ((cast(s32) mvp.as_mv.col) >> 3);
                mvp_full.as_mv.row = cast,no_check(s16) ((cast(s32) mvp.as_mv.row) >> 3);
                if x.mv_col_min < col_min {
                    x.mv_col_min = col_min;
                    code_block_to_execute = 156;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 156;
                    continue c_transpiler_dispatch;
                }
            }
            case 193; {
                x.e_mbd.mode_info_context.mbmi.ref_frame = cast,no_check(u8) INTRA_FRAME;
                vp8_build_intra_predictors_mby_s(
                    xd,
                    xd.dst.y_buffer - xd.dst.y_stride,
                    xd.dst.y_buffer - 1,
                    xd.dst.y_stride,
                    xd.predictor.data,
                    16
                );
                macro_block_yrd(x, *rd.rate_y, *distortion_3);
                rd.rate2 += rd.rate_y;
                rd.distortion2 += distortion_3;
                rd.rate2 += x.mbmode_cost[x.e_mbd.frame_type][x.e_mbd.mode_info_context.mbmi.mode];
                rd.rate2 += uv_intra_rate;
                rd.rate_uv = uv_intra_rate_tokenonly;
                rd.distortion2 += uv_intra_distortion;
                rd.distortion_uv = uv_intra_distortion;
                code_block_to_execute = 103;
                continue c_transpiler_dispatch;
            }
            case 223; {
                c_transpiler_switch_value_223 := this_mode;
                if c_transpiler_switch_value_223 == {
                    case cast,no_check(u32) B_PRED; {
                        tmp_rd = rd_pick_intra4x4mby_modes(x, *rate, *rd.rate_y, *distortion, best_mode.yrd);
                        rd.rate2 += rate;
                        rd.distortion2 += distortion;
                        if tmp_rd < best_mode.yrd {
                            rd.rate2 += uv_intra_rate;
                            rd.rate_uv = uv_intra_rate_tokenonly;
                            rd.distortion2 += uv_intra_distortion;
                            rd.distortion_uv = uv_intra_distortion;
                            code_block_to_execute = 103;
                            continue c_transpiler_dispatch;
                        } else {
                            this_rd = 2147483647;
                            disable_skip = 1;
                            code_block_to_execute = 103;
                            continue c_transpiler_dispatch;
                        }
                    }
                    case cast,no_check(u32) SPLITMV; {
                        this_rd_thresh =
                            ifx VP8_REF_FRAME_ORDER[mode_index] == 1 then x.rd_threshes[THR_NEW1] else x.rd_threshes[THR_NEW3];
                        this_rd_thresh =
                            ifx VP8_REF_FRAME_ORDER[mode_index] == 2 then x.rd_threshes[THR_NEW2] else this_rd_thresh;
                        tmp_rd_2 =
                            vp8_rd_pick_best_mbsegmentation(
                                cpi,
                                x,
                                *best_ref_mv,
                                best_mode.yrd,
                                mdcounts.data,
                                *rate,
                                *rd.rate_y,
                                *distortion_2,
                                this_rd_thresh
                            );
                        rd.rate2 += rate;
                        rd.distortion2 += distortion_2;
                        if tmp_rd_2 < best_mode.yrd {
                            rd_inter4x4_uv(cpi, x, *rd.rate_uv, *rd.distortion_uv, cpi.common.full_pixel);
                            rd.rate2 += rd.rate_uv;
                            rd.distortion2 += rd.distortion_uv;
                            code_block_to_execute = 103;
                            continue c_transpiler_dispatch;
                        } else {
                            this_rd = 2147483647;
                            disable_skip = 1;
                            code_block_to_execute = 103;
                            continue c_transpiler_dispatch;
                        }
                    }
                    case cast,no_check(u32) DC_PRED; {
                        code_block_to_execute = 193;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) V_PRED; {
                        code_block_to_execute = 193;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) H_PRED; {
                        code_block_to_execute = 193;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) TM_PRED; {
                        code_block_to_execute = 193;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) NEWMV; {
                        bestsme = 2147483647;
                        step_param = cpi.sf.first_step;
                        do_refine = 1;
                        sadpb = x.sadperbit16;
                        col_min = ((cast(s32) best_ref_mv.as_mv.col) + 7) >> 3 - ((cast(s32) 1) << 8 - 1);
                        row_min = ((cast(s32) best_ref_mv.as_mv.row) + 7) >> 3 - ((cast(s32) 1) << 8 - 1);
                        col_max = (cast(s32) best_ref_mv.as_mv.col) >> 3 + ((cast(s32) 1) << 8 - 1);
                        row_max = (cast(s32) best_ref_mv.as_mv.row) >> 3 + ((cast(s32) 1) << 8 - 1);
                        tmp_col_min = x.mv_col_min;
                        tmp_col_max = x.mv_col_max;
                        tmp_row_min = x.mv_row_min;
                        tmp_row_max = x.mv_row_max;
                        if saddone == 0 {
                            vp8_cal_sad(cpi, xd, x, recon_yoffset, near_sadidx.data + 0);
                            saddone = 1;
                            code_block_to_execute = 161;
                            continue c_transpiler_dispatch;
                        } else {
                            code_block_to_execute = 161;
                            continue c_transpiler_dispatch;
                        }
                    }
                    case cast,no_check(u32) NEARESTMV; {
                        code_block_to_execute = 112;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) NEARMV; {
                        code_block_to_execute = 112;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) ZEROMV; {
                        code_block_to_execute = 109;
                        continue c_transpiler_dispatch;
                    }
                    case; {
                        code_block_to_execute = 103;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 225; {
                while c_transpiler_local_loop := true {
                    if i < 24 {
                        uv_intra_tteob += cast,no_check(s32) x.e_mbd.eobs[i];
                        i += 1;
                        continue c_transpiler_local_loop;
                    } else {
                        uv_intra_done = 1;
                        code_block_to_execute = 223;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 231; {
                if uv_intra_done == 0 && this_ref_frame == INTRA_FRAME {
                    rd_pick_intra_mbuv_mode(x, *uv_intra_rate, *uv_intra_rate_tokenonly, *uv_intra_distortion);
                    uv_intra_mode = cast,no_check(MB_PREDICTION_MODE) x.e_mbd.mode_info_context.mbmi.uv_mode;
                    i = 16;
                    code_block_to_execute = 225;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 223;
                    continue c_transpiler_dispatch;
                }
            }
            case 232; {
                vp8_update_zbin_extra(cpi, x);
                code_block_to_execute = 231;
                continue c_transpiler_dispatch;
            }
            case 243; {
                x.mode_test_hit_counts[mode_index] += 1;
                if x.zbin_mode_boost_enabled != 0 {
                    if this_ref_frame == INTRA_FRAME {
                        x.zbin_mode_boost = 0;
                        code_block_to_execute = 232;
                        continue c_transpiler_dispatch;
                    } else {
                        if VP8_MODE_ORDER[mode_index] == cast,no_check(u32) ZEROMV {
                            if this_ref_frame != LAST_FRAME {
                                x.zbin_mode_boost = 12;
                                code_block_to_execute = 232;
                                continue c_transpiler_dispatch;
                            } else {
                                x.zbin_mode_boost = 6;
                                code_block_to_execute = 232;
                                continue c_transpiler_dispatch;
                            }
                        } else {
                            if VP8_MODE_ORDER[mode_index] == cast,no_check(u32) SPLITMV {
                                x.zbin_mode_boost = 0;
                                code_block_to_execute = 232;
                                continue c_transpiler_dispatch;
                            } else {
                                x.zbin_mode_boost = 4;
                                code_block_to_execute = 232;
                                continue c_transpiler_dispatch;
                            }
                        }
                    }
                } else {
                    code_block_to_execute = 231;
                    continue c_transpiler_dispatch;
                }
            }
            case 245; {
                x.rd_threshes[mode_index] = cpi.rd_baseline_thresh[mode_index] >> 7 * x.rd_thresh_mult[mode_index];
                code_block_to_execute = 69;
                continue c_transpiler_dispatch;
            }
            case 250; {
                if x.mode_test_hit_counts[mode_index] != 0 && cpi.mode_check_freq[mode_index] > 1 {
                    if x.mbs_tested_so_far <= cpi.mode_check_freq[mode_index] * x.mode_test_hit_counts[mode_index] {
                        x.rd_thresh_mult[mode_index] += 4;
                        if x.rd_thresh_mult[mode_index] > 512 {
                            x.rd_thresh_mult[mode_index] = 512;
                            code_block_to_execute = 245;
                            continue c_transpiler_dispatch;
                        } else {
                            code_block_to_execute = 245;
                            continue c_transpiler_dispatch;
                        }
                    } else {
                        code_block_to_execute = 243;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 243;
                    continue c_transpiler_dispatch;
                }
            }
            case 259; {
                if x.e_mbd.mode_info_context.mbmi.ref_frame != 0 {
                    x.e_mbd.pre.y_buffer = plane[this_ref_frame][0];
                    x.e_mbd.pre.u_buffer = plane[this_ref_frame][1];
                    x.e_mbd.pre.v_buffer = plane[this_ref_frame][2];
                    if sign_bias != cpi.common.ref_frame_sign_bias[this_ref_frame] {
                        sign_bias = cpi.common.ref_frame_sign_bias[this_ref_frame];
                        mode_mv = mode_mv_sb[sign_bias].data;
                        best_ref_mv.as_int = best_ref_mv_sb[sign_bias].as_int;
                        code_block_to_execute = 250;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 250;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 250;
                    continue c_transpiler_dispatch;
                }
            }
            case 275; {
                this_rd = 2147483647;
                disable_skip = 0;
                other_cost = 0;
                this_ref_frame = ref_frame_map[VP8_REF_FRAME_ORDER[mode_index]];
                if best_mode.rd <= x.rd_threshes[mode_index] {
                    code_block_to_execute = 69;
                    continue c_transpiler_dispatch;
                } else {
                    if this_ref_frame < 0 {
                        code_block_to_execute = 69;
                        continue c_transpiler_dispatch;
                    } else {
                        rd.rate2 = 0;
                        rd.distortion2 = 0;
                        this_mode = VP8_MODE_ORDER[mode_index];
                        x.e_mbd.mode_info_context.mbmi.mode = cast,no_check(u8) this_mode;
                        x.e_mbd.mode_info_context.mbmi.ref_frame = cast,no_check(u8) this_ref_frame;
                        if cpi.is_src_frame_alt_ref != 0 && cpi.oxcf.arnr_max_frames == 0 {
                            if this_mode != cast,no_check(u32) ZEROMV || x.e_mbd.mode_info_context.mbmi.ref_frame != cast,no_check(u8) ALTREF_FRAME {
                                code_block_to_execute = 69;
                                continue c_transpiler_dispatch;
                            } else {
                                code_block_to_execute = 259;
                                continue c_transpiler_dispatch;
                            }
                        } else {
                            code_block_to_execute = 259;
                            continue c_transpiler_dispatch;
                        }
                    }
                }
            }
            case 280; {
                get_predictor_pointers_in_rdopt(
                    cpi,
                    plane.data,
                    cast,no_check(u32) recon_yoffset,
                    cast,no_check(u32) recon_uvoffset
                );
                returnintra.* = 2147483647;
                x.mbs_tested_so_far += 1;
                x.skip = 0;
                mode_index = 0;
                code_block_to_execute = 68;
                continue c_transpiler_dispatch;
            }
            case 324; {
                b = x.block.data + 0;
                d = x.e_mbd.block.data + 0;
                xd = *x.e_mbd;
                best_mode_index = 0;
                uv_intra_tteob = 0;
                uv_intra_done = 0;
                uv_intra_mode = cast,no_check(MB_PREDICTION_MODE) (cast(s32) 0);
                near_sadidx = s32.[
                    0,
                    1,
                    2,
                    3,
                    4,
                    5,
                    6,
                    7
                ];
                saddone = 0;
                sr = 0;
                plane = [3] *u8.[
                    *u8.[ null, null, null ],
                    *u8.[ null, null, null ],
                    *u8.[ null, null, null ],
                    *u8.[ null, null, null ]
                ];
                sign_bias = 0;
                intra_rd_penalty = 10 * vp8_dc_quant(cpi.common.base_qindex, cpi.common.y1dc_delta_q);
                zero_mv_sse = U32_MAX;
                best_sse = U32_MAX;
                best_rd_sse = U32_MAX;
                rd.rate_uv = 0;
                rd.distortion_uv = 0;
                mode_mv = mode_mv_sb[sign_bias].data;
                best_ref_mv.as_int = 0;
                best_mode.rd = 2147483647;
                best_mode.yrd = 2147483647;
                best_mode.intra_rd = 2147483647;
                fill_memory(mode_mv_sb.data, 0, mode_mv_sb.count * size_of([10] Int_Mv_in_mv));
                fill_memory(*best_mode.mbmode, 0, size_of(MB_MODE_INFO));
                fill_memory(*best_mode.bmodes, 0, best_mode.bmodes.count * size_of(B_Mode_Info_in_blockd));
                get_reference_search_order_in_rdopt(cpi, ref_frame_map.data);
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
                    code_block_to_execute = 280;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 280;
                    continue c_transpiler_dispatch;
                }
            }
        }
        assert(false, tprint("invalid code block to execute %", code_block_to_execute));
        break;
    }
}

rd_update_mvcount :: (x: *MACROBLOCK_in_block, best_ref_mv: *Int_Mv_in_mv) {
    if x.e_mbd.mode_info_context.mbmi.mode == cast,no_check(u8) SPLITMV {
        i: s32 = 0;
        while i < x.partition_info.count {
            if x.partition_info.bmi[i].mode == cast,no_check(u32) NEW4X4 {
                ROW_VAL := ((cast(s32) x.partition_info.bmi[i].mv.as_mv.row) - cast(s32) best_ref_mv.as_mv.row) >> 1;
                ROW_IDX := (cast,no_check(s32) (MV_MAX)) + ROW_VAL;
                COL_VAL := ((cast(s32) x.partition_info.bmi[i].mv.as_mv.col) - cast(s32) best_ref_mv.as_mv.col) >> 1;
                COL_IDX := (cast,no_check(s32) (MV_MAX)) + COL_VAL;
                if ROW_IDX >= 0 && ROW_IDX < M_VVALS && COL_IDX >= 0 && COL_IDX < M_VVALS {
                    x.m_vcount[0][ROW_IDX] += 1;
                    x.m_vcount[1][COL_IDX] += 1;
                }
            }
            i += 1;
        }
    } else if x.e_mbd.mode_info_context.mbmi.mode == cast,no_check(u8) NEWMV {
        ROW_VAL := ((cast(s32) x.e_mbd.mode_info_context.mbmi.mv.as_mv.row) - cast(s32) best_ref_mv.as_mv.row) >> 1;
        ROW_IDX := (cast,no_check(s32) (MV_MAX)) + ROW_VAL;
        COL_VAL := ((cast(s32) x.e_mbd.mode_info_context.mbmi.mv.as_mv.col) - cast(s32) best_ref_mv.as_mv.col) >> 1;
        COL_IDX := (cast,no_check(s32) (MV_MAX)) + COL_VAL;
        if ROW_IDX >= 0 && ROW_IDX < M_VVALS && COL_IDX >= 0 && COL_IDX < M_VVALS {
            x.m_vcount[0][ROW_IDX] += 1;
            x.m_vcount[1][COL_IDX] += 1;
        }
    }
}

update_best_mode :: (
    best_mode: *Best_Mode_Struct,
    this_rd: s32,
    rd: *Rate_Distortion_Struct,
    other_cost: s32,
    x: *MACROBLOCK_in_block
) {
    this_mode := cast,no_check(MB_PREDICTION_MODE) x.e_mbd.mode_info_context.mbmi.mode;

    other_cost += x.ref_frame_cost[x.e_mbd.mode_info_context.mbmi.ref_frame];

    best_mode.yrd =
        (128 + (rd.rate2 - rd.rate_uv - other_cost) * x.rdmult) >> 8 +
            x.rddiv * (rd.distortion2 - rd.distortion_uv);

    best_mode.rd = this_rd;
    best_mode.mbmode = x.e_mbd.mode_info_context.mbmi;
    best_mode.partition = x.partition_info.*;

    if this_mode == cast,no_check(u32) B_PRED || this_mode == cast,no_check(u32) SPLITMV {
        for i: 0..cast(s32) 16 - 1 {
            best_mode.bmodes[i] = x.e_mbd.block[i].bmi;
        }
    }
}

calculate_final_rd_costs :: (
    this_rd: s32,
    rd: *Rate_Distortion_Struct,
    other_cost: *s32,
    disable_skip: s32,
    uv_intra_tteob: s32,
    intra_rd_penalty: s32,
    cpi: *VP8_COMP,
    x: *MACROBLOCK_in_block
) -> s32 {
    this_mode := cast,no_check(MB_PREDICTION_MODE) x.e_mbd.mode_info_context.mbmi.mode;

    if cpi.common.mb_no_coeff_skip != 0 {
        c_transpiler_compound_add(*(other_cost.*), (VP8_PROB_COST[cpi.prob_skip_false]), u32, u32);
        rd.rate2 += other_cost.*;
    }

    rd.rate2 += x.ref_frame_cost[x.e_mbd.mode_info_context.mbmi.ref_frame];

    if disable_skip == 0 {
        if cpi.common.mb_no_coeff_skip != 0 {
            has_y2_block :=
                cast(s32) (this_mode != cast,no_check(u32) SPLITMV &&
                    this_mode != cast,no_check(u32) B_PRED);

            tteob: s32 = 0;
            if has_y2_block != 0 {
                tteob += cast,no_check(s32) x.e_mbd.eobs[24];
            }

            for i: 0..cast(s32) 16 - 1 {
                tteob += cast(s32) (cast,no_check(s32) x.e_mbd.eobs[i] > has_y2_block);
            }

            if x.e_mbd.mode_info_context.mbmi.ref_frame != 0 {
                if 16 < 24 {
                    for i: 16..cast(s32) 24 - 1 {
                        tteob += cast,no_check(s32) x.e_mbd.eobs[i];
                    }
                }
            } else {
                tteob += uv_intra_tteob;
            }

            if tteob == 0 {
                rd.rate2 -= rd.rate_y + rd.rate_uv;

                rd.rate_uv = 0;

                if cpi.prob_skip_false != 0 {
                    prob_skip_cost := cast,no_check(s32) (VP8_PROB_COST[(255 - cpi.prob_skip_false)]);
                    prob_skip_cost -= cast,no_check(s32) (VP8_PROB_COST[cpi.prob_skip_false]);
                    rd.rate2 += prob_skip_cost;
                    other_cost.* += prob_skip_cost;
                }
            }
        }

        this_rd = (128 + rd.rate2 * x.rdmult) >> 8 + x.rddiv * rd.distortion2;
        if this_rd < 2147483647 && x.e_mbd.mode_info_context.mbmi.ref_frame == cast,no_check(u8) INTRA_FRAME {
            this_rd += intra_rd_penalty;
        }
    }
    return this_rd;
}

evaluate_inter_mode_rd :: (
    mdcounts: *s32,
    rd: *Rate_Distortion_Struct,
    disable_skip: *s32,
    cpi: *VP8_COMP,
    x: *MACROBLOCK_in_block
) -> s32 {
    this_mode := cast,no_check(MB_PREDICTION_MODE) x.e_mbd.mode_info_context.mbmi.mode;
    b := x.block.data + 0;
    xd := *x.e_mbd;
    distortion: s32 = ---;
    vp8_build_inter16x16_predictors_mby(*x.e_mbd, x.e_mbd.predictor.data, 16);

    if cpi.active_map_enabled != 0 && x.active_ptr[0] == 0 {
        x.skip = 1;
    } else if x.encode_breakout != 0 {
        sse: u32 = ---;

        threshold := cast,no_check(u32) (((cast(s32) xd.block[0].dequant[1]) * cast(s32) xd.block[0].dequant[1]) >> 4);

        if threshold < x.encode_breakout {
            threshold = x.encode_breakout;
        }

        var := variance16x16_c(b.base_src.*, b.src_stride, x.e_mbd.predictor.data, 16, *sse);

        if sse < threshold {
            q2dc := cast,no_check(u32) xd.block[24].dequant[0];

            if sse - var < (q2dc * q2dc) >> 4 || (sse / 2) > var && sse - var < 64 {
                sse2 := cast,no_check(u32) vp8_uvsse(x);
                if (sse2 * 2) < threshold {
                    x.skip = 1;
                    rd.distortion2 = cast,no_check(s32) (sse + sse2);
                    rd.rate2 = 500;

                    rd.rate_uv = 0;
                    rd.distortion_uv = cast,no_check(s32) sse2;

                    disable_skip.* = 1;
                    return (128 + rd.rate2 * x.rdmult) >> 8 + x.rddiv * rd.distortion2;
                }
            }
        }
    }

    rd.rate2 += vp8_cost_mv_ref(this_mode, mdcounts);

    macro_block_yrd(x, *rd.rate_y, *distortion);
    rd.rate2 += rd.rate_y;
    rd.distortion2 += distortion;

    rd_inter16x16_uv(cpi, x, *rd.rate_uv, *rd.distortion_uv, cpi.common.full_pixel);
    rd.rate2 += rd.rate_uv;
    rd.distortion2 += rd.distortion_uv;
    return 2147483647;
}

rd_inter16x16_uv :: (cpi: *VP8_COMP, x: *MACROBLOCK_in_block, rate: *s32, distortion: *s32, fullpixel: s32) -> s32 {
    vp8_build_inter16x16_predictors_mbuv(*x.e_mbd);
    vp8_subtract_mbuv(
        x.src_diff.data,
        x.src.u_buffer,
        x.src.v_buffer,
        x.src.uv_stride,
        x.e_mbd.predictor.data + 256,
        x.e_mbd.predictor.data + 320,
        8
    );

    vp8_transform_mbuv(x);
    vp8_quantize_mbuv(x);

    rate.* = rd_cost_mbuv(x);
    distortion.* = vp8_mbuverror_c(x) / 4;

    return (128 + rate.* * x.rdmult) >> 8 + x.rddiv * distortion.*;
}

rd_cost_mbuv :: (mb: *MACROBLOCK_in_block) -> s32 {
    cost: s32 = 0;
    x := *mb.e_mbd;
    t_above, t_left: ENTROPY_CONTEXT_PLANES = ---;

    t_above = mb.e_mbd.above_context.*;
    t_left = mb.e_mbd.left_context.*;

    ta := cast(*ENTROPY_CONTEXT) *t_above;
    tl := cast(*ENTROPY_CONTEXT) *t_left;

    if 16 < 24 {
        for b: 16..cast(s32) 24 - 1 {
            cost +=
                cost_coeffs(
                    mb,
                    x.block.data + b,
                    2,
                    ta + cast,no_check(s32) VP8_BLOCK2ABOVE[b],
                    tl + cast,no_check(s32) VP8_BLOCK2LEFT[b]
                );
        }
    }

    return cost;
}

cost_coeffs :: (mb: *MACROBLOCK_in_block, b: *BLOCKD, type: s32, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
    c := cast(s32) (type == 0);
    eob := cast,no_check(s32) b.eob.*;

    cost: s32 = 0;
    qcoeff_ptr := b.qcoeff;

    pt := (cast(s32) a.*) + cast(s32) l.*;

    while c < eob {
        V := cast,no_check(s32) qcoeff_ptr[VP8_DEFAULT_ZIG_ZAG1D[c]];
        T := cast,no_check(s32) VP8_DCT_VALUE_TOKENS_PTR[V].token;
        cost += mb.token_costs[type][VP8_COEF_BANDS[c]][pt][T];
        cost += cast,no_check(s32) VP8_DCT_VALUE_COST_PTR[V];
        pt = cast,no_check(s32) VP8_PREV_TOKEN_CLASS[T];
        c += 1;
    }

    if c < 16 {
        cost += mb.token_costs[type][VP8_COEF_BANDS[c]][pt][11];
    }

    pt = cast(s32) (c != cast(s32) (type == 0));
    l.* = cast,no_check(ENTROPY_CONTEXT) pt;
    a.* = l.*;

    return cost;
}

macro_block_yrd :: (mb: *MACROBLOCK_in_block, rate: *s32, distortion: *s32) {
    X := *mb.e_mbd;
    MB_Y2 := mb.block.data + 24;
    X_Y2 := X.block.data + 24;
    y2_dc_ptr := MB_Y2.src_diff;

    vp8_subtract_mby(mb.src_diff.data, mb.block[0].base_src.*, mb.block[0].src_stride, mb.e_mbd.predictor.data, 16);

    beptr := mb.block.data;
    while beptr < mb.block.data + 16 {
        mb.short_fdct8x4(beptr.src_diff, beptr.coeff, 32);
        y2_dc_ptr.* = beptr.coeff[0];
        y2_dc_ptr += 1;
        y2_dc_ptr.* = beptr.coeff[16];
        y2_dc_ptr += 1;
        beptr += 2;
    }

    mb.short_walsh4x4(MB_Y2.src_diff, MB_Y2.coeff, 8);

    for b: 0..cast(s32) 16 - 1 {
        mb.quantize_b(mb.block.data + b, mb.e_mbd.block.data + b);
    }

    mb.quantize_b(MB_Y2, X_Y2);

    d := vp8_mbblock_error_c(mb, 1) << 2;
    d += vp8_block_error_c(MB_Y2.coeff, X_Y2.dqcoeff);

    distortion.* = d >> 4;

    rate.* = vp8_rdcost_mby(mb);
}

vp8_rdcost_mby :: (mb: *MACROBLOCK_in_block) -> s32 {
    cost: s32 = 0;

    x := *mb.e_mbd;
    t_above, t_left: ENTROPY_CONTEXT_PLANES = ---;

    t_above = mb.e_mbd.above_context.*;
    t_left = mb.e_mbd.left_context.*;

    ta := cast(*ENTROPY_CONTEXT) *t_above;
    tl := cast(*ENTROPY_CONTEXT) *t_left;

    for b: 0..cast(s32) 16 - 1 {
        cost +=
            cost_coeffs(
                mb,
                x.block.data + b,
                0,
                ta + cast,no_check(s32) VP8_BLOCK2ABOVE[b],
                tl + cast,no_check(s32) VP8_BLOCK2LEFT[b]
            );
    }

    cost +=
        cost_coeffs(
            mb,
            x.block.data + 24,
            1,
            ta + cast,no_check(s32) VP8_BLOCK2ABOVE[24],
            tl + cast,no_check(s32) VP8_BLOCK2LEFT[24]
        );

    return cost;
}

vp8_cost_mv_ref :: (m: MB_PREDICTION_MODE, near_mv_ref_ct: *s32) -> s32 {
    p: [4] Vp8_Prob = ---;

    vp8_mv_ref_probs(p.data, near_mv_ref_ct);
    return vp8_cost_token_in_rdopt(
        cast(*Vp8_Tree_Index) *(VP8_MV_REF_TREE),
        p.data,
        VP8_MV_REF_ENCODING_ARRAY.data + (m - cast,no_check(u32) NEARESTMV)
    );
}

vp8_uvsse :: (x: *MACROBLOCK_in_block) -> s32 {
    upred_ptr := x.block[16].base_src.* + x.block[16].src;
    vpred_ptr := x.block[20].base_src.* + x.block[20].src;
    uv_stride := x.block[16].src_stride;

    sse1: u32 = 0;
    sse2: u32 = 0;
    mv_row := cast,no_check(s32) x.e_mbd.mode_info_context.mbmi.mv.as_mv.row;
    mv_col := cast,no_check(s32) x.e_mbd.mode_info_context.mbmi.mv.as_mv.col;

    pre_stride := x.e_mbd.pre.uv_stride;

    if mv_row < 0 {
        mv_row -= 1;
    } else {
        mv_row += 1;
    }

    if mv_col < 0 {
        mv_col -= 1;
    } else {
        mv_col += 1;
    }

    mv_row /= 2;
    mv_col /= 2;

    offset := mv_row >> 3 * pre_stride + mv_col >> 3;
    uptr := x.e_mbd.pre.u_buffer + offset;
    vptr := x.e_mbd.pre.v_buffer + offset;

    if mv_row | mv_col & 7 != 0 {
        sub_pixel_variance8x8_c(uptr, pre_stride, mv_col & 7, mv_row & 7, upred_ptr, uv_stride, *sse2);
        sub_pixel_variance8x8_c(vptr, pre_stride, mv_col & 7, mv_row & 7, vpred_ptr, uv_stride, *sse1);
        sse2 += sse1;
    } else {
        variance8x8_c(uptr, pre_stride, upred_ptr, uv_stride, *sse2);
        variance8x8_c(vptr, pre_stride, vpred_ptr, uv_stride, *sse1);
        sse2 += sse1;
    }
    return cast,no_check(s32) sse2;
}

vp8_set_mbmode_and_mvs :: (x: *MACROBLOCK_in_block, mb: MB_PREDICTION_MODE, mv: *Int_Mv_in_mv) {
    x.e_mbd.mode_info_context.mbmi.mode = cast,no_check(u8) mb;
    x.e_mbd.mode_info_context.mbmi.mv.as_int = mv.as_int;
}

vp8_mv_pred :: (
    cpi: *VP8_COMP,
    xd: *MACROBLOCKD_in_blockd,
    here: *MODE_INFO_in_blockd,
    mvp: *Int_Mv_in_mv,
    refframe: s32,
    ref_frame_sign_bias: *s32,
    sr: *s32,
    near_sadidx: *s32
) {
    above := here - xd.mode_info_stride;
    left := here - 1;
    aboveleft := above - 1;
    near_mvs: [8] Int_Mv_in_mv = ---;
    near_ref: [8] s32 = ---;
    mv: Int_Mv_in_mv = ---;
    vcnt: s32 = 0;
    find: s32 = 0;
    mb_offset: s32 = ---;

    mvx: [8] s32 = ---;
    mvy: [8] s32 = ---;

    mv.as_int = 0;

    if here.mbmi.ref_frame != cast,no_check(u8) INTRA_FRAME {
        near_mvs[7].as_int = 0;
        near_mvs[6].as_int = near_mvs[7].as_int;
        near_mvs[5].as_int = near_mvs[6].as_int;
        near_mvs[4].as_int = near_mvs[5].as_int;
        near_mvs[3].as_int = near_mvs[4].as_int;
        near_mvs[2].as_int = near_mvs[3].as_int;
        near_mvs[1].as_int = near_mvs[2].as_int;
        near_mvs[0].as_int = near_mvs[1].as_int;
        near_ref[7] = 0;
        near_ref[6] = near_ref[7];
        near_ref[5] = near_ref[6];
        near_ref[4] = near_ref[5];
        near_ref[3] = near_ref[4];
        near_ref[2] = near_ref[3];
        near_ref[1] = near_ref[2];
        near_ref[0] = near_ref[1];

        if above.mbmi.ref_frame != cast,no_check(u8) INTRA_FRAME {
            near_mvs[vcnt].as_int = above.mbmi.mv.as_int;
            mv_bias_in_rdopt(
                ref_frame_sign_bias[above.mbmi.ref_frame],
                refframe,
                near_mvs.data + vcnt,
                ref_frame_sign_bias
            );
            near_ref[vcnt] = cast,no_check(s32) above.mbmi.ref_frame;
        }
        vcnt += 1;
        if left.mbmi.ref_frame != cast,no_check(u8) INTRA_FRAME {
            near_mvs[vcnt].as_int = left.mbmi.mv.as_int;
            mv_bias_in_rdopt(
                ref_frame_sign_bias[left.mbmi.ref_frame],
                refframe,
                near_mvs.data + vcnt,
                ref_frame_sign_bias
            );
            near_ref[vcnt] = cast,no_check(s32) left.mbmi.ref_frame;
        }
        vcnt += 1;
        if aboveleft.mbmi.ref_frame != cast,no_check(u8) INTRA_FRAME {
            near_mvs[vcnt].as_int = aboveleft.mbmi.mv.as_int;
            mv_bias_in_rdopt(
                ref_frame_sign_bias[aboveleft.mbmi.ref_frame],
                refframe,
                near_mvs.data + vcnt,
                ref_frame_sign_bias
            );
            near_ref[vcnt] = cast,no_check(s32) aboveleft.mbmi.ref_frame;
        }
        vcnt += 1;

        if cpi.common.last_frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
            mb_offset = (-xd.mb_to_top_edge / 128 + 1) * (xd.mode_info_stride + 1) + (-xd.mb_to_left_edge / 128 + 1);

            if cpi.lf_ref_frame[mb_offset] != INTRA_FRAME {
                near_mvs[vcnt].as_int = (cast(*Int_Mv_in_mv) (cpi.lfmv))[mb_offset].as_int;
                mv_bias_in_rdopt(
                    cpi.lf_ref_frame_sign_bias[mb_offset],
                    refframe,
                    near_mvs.data + vcnt,
                    ref_frame_sign_bias
                );
                near_ref[vcnt] = cpi.lf_ref_frame[mb_offset];
            }
            vcnt += 1;

            if cpi.lf_ref_frame[mb_offset - xd.mode_info_stride - 1] != INTRA_FRAME {
                near_mvs[vcnt].as_int = (cast(*Int_Mv_in_mv) (cpi.lfmv))[mb_offset - xd.mode_info_stride - 1].as_int;
                mv_bias_in_rdopt(
                    cpi.lf_ref_frame_sign_bias[mb_offset - xd.mode_info_stride - 1],
                    refframe,
                    near_mvs.data + vcnt,
                    ref_frame_sign_bias
                );
                near_ref[vcnt] = cpi.lf_ref_frame[mb_offset - xd.mode_info_stride - 1];
            }
            vcnt += 1;

            if cpi.lf_ref_frame[mb_offset - 1] != INTRA_FRAME {
                near_mvs[vcnt].as_int = (cast(*Int_Mv_in_mv) (cpi.lfmv))[mb_offset - 1].as_int;
                mv_bias_in_rdopt(
                    cpi.lf_ref_frame_sign_bias[mb_offset - 1],
                    refframe,
                    near_mvs.data + vcnt,
                    ref_frame_sign_bias
                );
                near_ref[vcnt] = cpi.lf_ref_frame[mb_offset - 1];
            }
            vcnt += 1;

            if cpi.lf_ref_frame[mb_offset + 1] != INTRA_FRAME {
                near_mvs[vcnt].as_int = (cast(*Int_Mv_in_mv) (cpi.lfmv))[mb_offset + 1].as_int;
                mv_bias_in_rdopt(
                    cpi.lf_ref_frame_sign_bias[mb_offset + 1],
                    refframe,
                    near_mvs.data + vcnt,
                    ref_frame_sign_bias
                );
                near_ref[vcnt] = cpi.lf_ref_frame[mb_offset + 1];
            }
            vcnt += 1;

            if cpi.lf_ref_frame[mb_offset + xd.mode_info_stride + 1] != INTRA_FRAME {
                near_mvs[vcnt].as_int = (cast(*Int_Mv_in_mv) (cpi.lfmv))[mb_offset + xd.mode_info_stride + 1].as_int;
                mv_bias_in_rdopt(
                    cpi.lf_ref_frame_sign_bias[mb_offset + xd.mode_info_stride + 1],
                    refframe,
                    near_mvs.data + vcnt,
                    ref_frame_sign_bias
                );
                near_ref[vcnt] = cpi.lf_ref_frame[mb_offset + xd.mode_info_stride + 1];
            }
            vcnt += 1;
        }

        if 0 < vcnt {
            for i: 0..vcnt - 1 {
                if near_ref[near_sadidx[i]] != INTRA_FRAME {
                    if cast,no_check(s32) here.mbmi.ref_frame == near_ref[near_sadidx[i]] {
                        mv.as_int = near_mvs[near_sadidx[i]].as_int;
                        find = 1;
                        if i < 3 {
                            sr.* = 3;
                        } else {
                            sr.* = 2;
                        }
                        break;
                    }
                }
            }
        }

        if find == 0 {
            if 0 < vcnt {
                for i: 0..vcnt - 1 {
                    mvx[i] = cast,no_check(s32) near_mvs[i].as_mv.row;
                    mvy[i] = cast,no_check(s32) near_mvs[i].as_mv.col;
                }
            }

            insertsortmv_in_rdopt(mvx.data, vcnt);
            insertsortmv_in_rdopt(mvy.data, vcnt);
            mv.as_mv.row = cast,no_check(s16) mvx[vcnt / 2];
            mv.as_mv.col = cast,no_check(s16) mvy[vcnt / 2];

            sr.* = 0;
        }
    }

    mvp.as_int = mv.as_int;
    vp8_clamp_mv2_in_rdopt(mvp, xd);
}

vp8_cal_sad :: (
    cpi: *VP8_COMP,
    xd: *MACROBLOCKD_in_blockd,
    x: *MACROBLOCK_in_block,
    recon_yoffset: s32,
    near_sadidx: *s32
) {
    near_sad: [8] s32;
    b := x.block.data + 0;
    src_y_ptr := b.base_src.*;

    if xd.mb_to_top_edge == 0 && xd.mb_to_left_edge == 0 {
        near_sad[2] = 2147483647;
        near_sad[1] = near_sad[2];
        near_sad[0] = near_sad[1];
    } else if xd.mb_to_top_edge == 0 {
        near_sad[2] = 2147483647;
        near_sad[0] = near_sad[2];
        near_sad[1] =
            cast,no_check(s32) cpi.fn_ptr[BLOCK_16X16].sdf(
                src_y_ptr,
                b.src_stride,
                xd.dst.y_buffer - 16,
                xd.dst.y_stride
            );
    } else if xd.mb_to_left_edge == 0 {
        near_sad[2] = 2147483647;
        near_sad[1] = near_sad[2];
        near_sad[0] =
            cast,no_check(s32) cpi.fn_ptr[BLOCK_16X16].sdf(
                src_y_ptr,
                b.src_stride,
                xd.dst.y_buffer - xd.dst.y_stride * 16,
                xd.dst.y_stride
            );
    } else {
        near_sad[0] =
            cast,no_check(s32) cpi.fn_ptr[BLOCK_16X16].sdf(
                src_y_ptr,
                b.src_stride,
                xd.dst.y_buffer - xd.dst.y_stride * 16,
                xd.dst.y_stride
            );
        near_sad[1] =
            cast,no_check(s32) cpi.fn_ptr[BLOCK_16X16].sdf(
                src_y_ptr,
                b.src_stride,
                xd.dst.y_buffer - 16,
                xd.dst.y_stride
            );
        near_sad[2] =
            cast,no_check(s32) cpi.fn_ptr[BLOCK_16X16].sdf(
                src_y_ptr,
                b.src_stride,
                xd.dst.y_buffer - xd.dst.y_stride * 16 - 16,
                xd.dst.y_stride
            );
    }

    if cpi.common.last_frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
        pre_y_buffer: *u8 = cpi.common.yv12_fb[cpi.common.lst_fb_idx].y_buffer + recon_yoffset;
        pre_y_stride := cpi.common.yv12_fb[cpi.common.lst_fb_idx].y_stride;

        if xd.mb_to_top_edge == 0 {
            near_sad[4] = 2147483647;
        }
        if xd.mb_to_left_edge == 0 {
            near_sad[5] = 2147483647;
        }
        if xd.mb_to_right_edge == 0 {
            near_sad[6] = 2147483647;
        }
        if xd.mb_to_bottom_edge == 0 {
            near_sad[7] = 2147483647;
        }

        if near_sad[4] != 2147483647 {
            near_sad[4] =
                cast,no_check(s32) cpi.fn_ptr[BLOCK_16X16].sdf(
                    src_y_ptr,
                    b.src_stride,
                    pre_y_buffer - pre_y_stride * 16,
                    pre_y_stride
                );
        }
        if near_sad[5] != 2147483647 {
            near_sad[5] =
                cast,no_check(s32) cpi.fn_ptr[BLOCK_16X16].sdf(
                    src_y_ptr,
                    b.src_stride,
                    pre_y_buffer - 16,
                    pre_y_stride
                );
        }
        near_sad[3] =
            cast,no_check(s32) cpi.fn_ptr[BLOCK_16X16].sdf(
                src_y_ptr,
                b.src_stride,
                pre_y_buffer,
                pre_y_stride
            );
        if near_sad[6] != 2147483647 {
            near_sad[6] =
                cast,no_check(s32) cpi.fn_ptr[BLOCK_16X16].sdf(
                    src_y_ptr,
                    b.src_stride,
                    pre_y_buffer + 16,
                    pre_y_stride
                );
        }
        if near_sad[7] != 2147483647 {
            near_sad[7] =
                cast,no_check(s32) cpi.fn_ptr[BLOCK_16X16].sdf(
                    src_y_ptr,
                    b.src_stride,
                    pre_y_buffer + pre_y_stride * 16,
                    pre_y_stride
                );
        }
    }

    if cpi.common.last_frame_type != cast,no_check(u32) KEY_FRAME_in_alloccommon {
        insertsortsad_in_rdopt(near_sad.data, near_sadidx, 8);
    } else {
        insertsortsad_in_rdopt(near_sad.data, near_sadidx, 3);
    }
}

rd_inter4x4_uv :: (cpi: *VP8_COMP, x: *MACROBLOCK_in_block, rate: *s32, distortion: *s32, fullpixel: s32) -> s32 {
    vp8_build_inter4x4_predictors_mbuv(*x.e_mbd);
    vp8_subtract_mbuv(
        x.src_diff.data,
        x.src.u_buffer,
        x.src.v_buffer,
        x.src.uv_stride,
        x.e_mbd.predictor.data + 256,
        x.e_mbd.predictor.data + 320,
        8
    );

    vp8_transform_mbuv(x);
    vp8_quantize_mbuv(x);

    rate.* = rd_cost_mbuv(x);
    distortion.* = vp8_mbuverror_c(x) / 4;

    return (128 + rate.* * x.rdmult) >> 8 + x.rddiv * distortion.*;
}

vp8_rd_pick_best_mbsegmentation :: (
    cpi: *VP8_COMP,
    x: *MACROBLOCK_in_block,
    best_ref_mv: *Int_Mv_in_mv,
    best_rd: s32,
    mdcounts: *s32,
    returntotrate: *s32,
    returnyrate: *s32,
    returndistortion: *s32,
    mvthresh: s32
) -> s32 {
    bsi: BEST_SEG_INFO = ---;

    fill_memory(*bsi, 0, size_of(BEST_SEG_INFO));

    bsi.segment_rd = best_rd;
    bsi.ref_mv = best_ref_mv;
    bsi.mvp.as_int = best_ref_mv.as_int;
    bsi.mvthresh = mvthresh;
    bsi.mdcounts = mdcounts;

    i: s32 = 0;
    while i < 16 {
        bsi.modes[i] = cast,no_check(B_PREDICTION_MODE) ZERO4X4;
        i += 1;
    }

    if cpi.compressor_speed == 0 {
        rd_check_segment(cpi, x, *bsi, cast,no_check(u32) BLOCK_16X8);
        rd_check_segment(cpi, x, *bsi, cast,no_check(u32) BLOCK_8X16);
        rd_check_segment(cpi, x, *bsi, cast,no_check(u32) BLOCK_8X8);
        rd_check_segment(cpi, x, *bsi, cast,no_check(u32) BLOCK_4X4);
    } else {
        sr: s32 = ---;

        rd_check_segment(cpi, x, *bsi, cast,no_check(u32) BLOCK_8X8);

        if bsi.segment_rd < best_rd {
            col_min := ((cast(s32) best_ref_mv.as_mv.col) + 7) >> 3 - ((cast(s32) 1) << 8 - 1);
            row_min := ((cast(s32) best_ref_mv.as_mv.row) + 7) >> 3 - ((cast(s32) 1) << 8 - 1);
            col_max := (cast(s32) best_ref_mv.as_mv.col) >> 3 + ((cast(s32) 1) << 8 - 1);
            row_max := (cast(s32) best_ref_mv.as_mv.row) >> 3 + ((cast(s32) 1) << 8 - 1);

            tmp_col_min := x.mv_col_min;
            tmp_col_max := x.mv_col_max;
            tmp_row_min := x.mv_row_min;
            tmp_row_max := x.mv_row_max;

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

            bsi.sv_mvp[0].as_int = bsi.mvs[0].as_int;
            bsi.sv_mvp[1].as_int = bsi.mvs[2].as_int;
            bsi.sv_mvp[2].as_int = bsi.mvs[8].as_int;
            bsi.sv_mvp[3].as_int = bsi.mvs[10].as_int;

            sr =
                ifx (absolute_value((cast(s32) bsi.sv_mvp[0].as_mv.row) - cast(s32) bsi.sv_mvp[2].as_mv.row) >> 3) > absolute_value((cast(s32) bsi.sv_mvp[0].as_mv.col) -
                    cast(s32) bsi.sv_mvp[2].as_mv.col) >> 3 then absolute_value((cast(s32) bsi.sv_mvp[0].as_mv.row) - cast(s32) bsi.sv_mvp[2].as_mv.row) >> 3 else absolute_value((cast(s32) bsi.sv_mvp[0].as_mv.col) - cast(s32) bsi.sv_mvp[2].as_mv.col) >> 3;
            vp8_cal_step_param(sr, bsi.sv_istep.data + 0);

            sr =
                ifx (absolute_value((cast(s32) bsi.sv_mvp[1].as_mv.row) - cast(s32) bsi.sv_mvp[3].as_mv.row) >> 3) > absolute_value((cast(s32) bsi.sv_mvp[1].as_mv.col) -
                    cast(s32) bsi.sv_mvp[3].as_mv.col) >> 3 then absolute_value((cast(s32) bsi.sv_mvp[1].as_mv.row) - cast(s32) bsi.sv_mvp[3].as_mv.row) >> 3 else absolute_value((cast(s32) bsi.sv_mvp[1].as_mv.col) - cast(s32) bsi.sv_mvp[3].as_mv.col) >> 3;
            vp8_cal_step_param(sr, bsi.sv_istep.data + 1);

            rd_check_segment(cpi, x, *bsi, cast,no_check(u32) BLOCK_8X16);

            sr =
                ifx (absolute_value((cast(s32) bsi.sv_mvp[0].as_mv.row) - cast(s32) bsi.sv_mvp[1].as_mv.row) >> 3) > absolute_value((cast(s32) bsi.sv_mvp[0].as_mv.col) -
                    cast(s32) bsi.sv_mvp[1].as_mv.col) >> 3 then absolute_value((cast(s32) bsi.sv_mvp[0].as_mv.row) - cast(s32) bsi.sv_mvp[1].as_mv.row) >> 3 else absolute_value((cast(s32) bsi.sv_mvp[0].as_mv.col) - cast(s32) bsi.sv_mvp[1].as_mv.col) >> 3;
            vp8_cal_step_param(sr, bsi.sv_istep.data + 0);

            sr =
                ifx (absolute_value((cast(s32) bsi.sv_mvp[2].as_mv.row) - cast(s32) bsi.sv_mvp[3].as_mv.row) >> 3) > absolute_value((cast(s32) bsi.sv_mvp[2].as_mv.col) -
                    cast(s32) bsi.sv_mvp[3].as_mv.col) >> 3 then absolute_value((cast(s32) bsi.sv_mvp[2].as_mv.row) - cast(s32) bsi.sv_mvp[3].as_mv.row) >> 3 else absolute_value((cast(s32) bsi.sv_mvp[2].as_mv.col) - cast(s32) bsi.sv_mvp[3].as_mv.col) >> 3;
            vp8_cal_step_param(sr, bsi.sv_istep.data + 1);

            rd_check_segment(cpi, x, *bsi, cast,no_check(u32) BLOCK_16X8);

            if cpi.sf.no_skip_block4x4_search != 0 || bsi.segment_num == BLOCK_8X8 {
                bsi.mvp.as_int = bsi.sv_mvp[0].as_int;
                rd_check_segment(cpi, x, *bsi, cast,no_check(u32) BLOCK_4X4);
            }

            x.mv_col_min = tmp_col_min;
            x.mv_col_max = tmp_col_max;
            x.mv_row_min = tmp_row_min;
            x.mv_row_max = tmp_row_max;
        }
    }

    i = 0;
    while i < 16 {
        bd := x.e_mbd.block.data + i;

        bd.bmi.mv.as_int = bsi.mvs[i].as_int;
        bd.eob.* = cast,no_check(s8) bsi.eobs[i];
        i += 1;
    }

    returntotrate.* = bsi.r;
    returndistortion.* = bsi.d;
    returnyrate.* = bsi.segment_yrate;

    x.e_mbd.mode_info_context.mbmi.partitioning = cast,no_check(u8) bsi.segment_num;
    x.partition_info.count = VP8_MBSPLIT_COUNT[bsi.segment_num];

    i = 0;
    while i < x.partition_info.count {
        j := cast,no_check(s32) VP8_MBSPLIT_OFFSET[bsi.segment_num][i];

        x.partition_info.bmi[i].mode = bsi.modes[j];
        x.partition_info.bmi[i].mv.as_mv = bsi.mvs[j].as_mv;
        i += 1;
    }

    x.partition_info.bmi[15].mv.as_int = bsi.mvs[15].as_int;

    return bsi.segment_rd;
}

rd_check_segment :: (cpi: *VP8_COMP, x: *MACROBLOCK_in_block, bsi: *BEST_SEG_INFO, segmentation: u32) {
    br: s32 = 0;
    bd: s32 = 0;
    this_mode: B_PREDICTION_MODE = ---;

    this_segment_rd: s32 = 0;

    rate: s32 = 0;
    sbr: s32 = 0;
    sbd: s32 = 0;
    segmentyrate: s32 = 0;

    t_above, t_left: ENTROPY_CONTEXT_PLANES = ---;
    t_above_b, t_left_b: ENTROPY_CONTEXT_PLANES = ---;

    t_above = x.e_mbd.above_context.*;
    t_left = x.e_mbd.left_context.*;

    fill_memory(*t_above_b, 0, size_of(ENTROPY_CONTEXT_PLANES));
    fill_memory(*t_left_b, 0, size_of(ENTROPY_CONTEXT_PLANES));

    br = 0;
    bd = 0;

    v_fn_ptr := cpi.fn_ptr.data + segmentation;
    labels := VP8_MBSPLITS[segmentation].data;
    label_count := VP8_MBSPLIT_COUNT[segmentation];

    label_mv_thresh := 1 * bsi.mvthresh / label_count;

    rate =
        vp8_cost_token_in_rdopt(
            cast(*Vp8_Tree_Index) *(VP8_MBSPLIT_TREE),
            VP8_MBSPLIT_PROBS.data,
            VP8_MBSPLIT_ENCODINGS.data + segmentation
        );
    rate += vp8_cost_mv_ref(cast,no_check(MB_PREDICTION_MODE) SPLITMV, bsi.mdcounts);
    this_segment_rd += (128 + rate * x.rdmult) >> 8 + x.rddiv * 0;
    br += rate;

    if 0 < label_count {
        for i: 0..label_count - 1 {
            mode_mv: [14] Int_Mv_in_mv;
            best_label_rd: s32 = 2147483647;
            mode_selected := cast,no_check(B_PREDICTION_MODE) ZERO4X4;
            bestlabelyrate: s32 = 0;

            this_mode = cast,no_check(B_PREDICTION_MODE) LEFT4X4;
            while this_mode <= cast,no_check(u32) NEW4X4 {
                t_above_s, t_left_s: ENTROPY_CONTEXT_PLANES = ---;

                t_above_s = t_above;
                t_left_s = t_left;

                ta_s := cast(*ENTROPY_CONTEXT) *t_above_s;
                tl_s := cast(*ENTROPY_CONTEXT) *t_left_s;

                if this_mode == cast,no_check(u32) NEW4X4 {
                    sseshift: s32 = ---;
                    num00: s32 = ---;
                    step_param: s32 = 0;

                    n: s32 = ---;
                    thissme: s32 = ---;
                    bestsme: s32 = 2147483647;
                    temp_mv: Int_Mv_in_mv = ---;
                    c: *BLOCK = ---;
                    e: *BLOCKD = ---;

                    if best_label_rd < label_mv_thresh {
                        break;
                    }

                    if cpi.compressor_speed != 0 {
                        if segmentation == cast,no_check(u32) BLOCK_8X16 || segmentation == cast,no_check(u32) BLOCK_16X8 {
                            bsi.mvp.as_int = bsi.sv_mvp[i].as_int;
                            if i == 1 && segmentation == cast,no_check(u32) BLOCK_16X8 {
                                bsi.mvp.as_int = bsi.sv_mvp[2].as_int;
                            }

                            step_param = bsi.sv_istep[i];
                        }

                        if segmentation == cast,no_check(u32) BLOCK_4X4 && i > 0 {
                            bsi.mvp.as_int = x.e_mbd.block[i - 1].bmi.mv.as_int;
                            if i == 4 || i == 8 || i == 12 {
                                bsi.mvp.as_int = x.e_mbd.block[i - 4].bmi.mv.as_int;
                            }
                            step_param = 2;
                        }
                    }

                    further_steps := (cast,no_check(s32) ((8 - 1))) - step_param;

                    {
                        sadpb := x.sadperbit4;
                        mvp_full: Int_Mv_in_mv = ---;

                        mvp_full.as_mv.row = cast,no_check(s16) ((cast(s32) bsi.mvp.as_mv.row) >> 3);
                        mvp_full.as_mv.col = cast,no_check(s16) ((cast(s32) bsi.mvp.as_mv.col) >> 3);

                        n = cast,no_check(s32) VP8_MBSPLIT_OFFSET[segmentation][i];

                        c = x.block.data + n;
                        e = x.e_mbd.block.data + n;

                        bestsme =
                            cpi.diamond_search_sad(
                                x,
                                c,
                                e,
                                *mvp_full,
                                mode_mv.data + NEW4X4,
                                step_param,
                                sadpb,
                                *num00,
                                v_fn_ptr,
                                x.mvcost.data,
                                bsi.ref_mv
                            );

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
                                        c,
                                        e,
                                        *mvp_full,
                                        *temp_mv,
                                        step_param + n,
                                        sadpb,
                                        *num00,
                                        v_fn_ptr,
                                        x.mvcost.data,
                                        bsi.ref_mv
                                    );

                                if thissme < bestsme {
                                    bestsme = thissme;
                                    mode_mv[NEW4X4].as_int = temp_mv.as_int;
                                }
                            }
                        }

                        sseshift = cast,no_check(s32) SEGMENTATION_TO_SSESHIFT[segmentation];

                        if cpi.compressor_speed == 0 && bestsme >> ((sseshift) & 31) > 4000 {
                            vp8_clamp_mv_in_rdopt(*mvp_full, x.mv_col_min, x.mv_col_max, x.mv_row_min, x.mv_row_max);

                            thissme =
                                vp8_full_search_sad(
                                    x,
                                    c,
                                    e,
                                    *mvp_full,
                                    sadpb,
                                    16,
                                    v_fn_ptr,
                                    x.mvcost.data,
                                    bsi.ref_mv
                                );

                            if thissme < bestsme {
                                bestsme = thissme;
                                mode_mv[NEW4X4].as_int = e.bmi.mv.as_int;
                            } else {
                                e.bmi.mv.as_int = mode_mv[NEW4X4].as_int;
                            }
                        }
                    }

                    if bestsme < 2147483647 {
                        disto: s32 = ---;
                        sse: u32 = ---;
                        cpi.find_fractional_mv_step(
                            x,
                            c,
                            e,
                            mode_mv.data + NEW4X4,
                            bsi.ref_mv,
                            x.errorperbit,
                            v_fn_ptr,
                            x.mvcost.data,
                            *disto,
                            *sse
                        );
                    }
                }

                rate = labels2mode(x, labels, i, this_mode, mode_mv.data + this_mode, bsi.ref_mv, x.mvcost.data);

                if (cast(s32) mode_mv[this_mode].as_mv.row) >> 3 < x.mv_row_min ||
                    (cast(s32) mode_mv[this_mode].as_mv.row) >> 3 > x.mv_row_max ||
                    (cast(s32) mode_mv[this_mode].as_mv.col) >> 3 < x.mv_col_min ||
                    (cast(s32) mode_mv[this_mode].as_mv.col) >> 3 > x.mv_col_max {
                    this_mode += 1;
                    continue;
                }

                distortion := cast,no_check(s32) (vp8_encode_inter_mb_segment(x, labels, i) / 4);

                labelyrate := rdcost_mbsegment_y(x, labels, i, ta_s, tl_s);
                rate += labelyrate;

                this_rd := (128 + rate * x.rdmult) >> 8 + x.rddiv * distortion;

                if this_rd < best_label_rd {
                    sbr = rate;
                    sbd = distortion;
                    bestlabelyrate = labelyrate;
                    mode_selected = this_mode;
                    best_label_rd = this_rd;

                    t_above_b = t_above_s;
                    t_left_b = t_left_s;
                }
                this_mode += 1;
            }

            t_above = t_above_b;
            t_left = t_left_b;

            labels2mode(x, labels, i, mode_selected, mode_mv.data + mode_selected, bsi.ref_mv, x.mvcost.data);

            br += sbr;
            bd += sbd;
            segmentyrate += bestlabelyrate;
            this_segment_rd += best_label_rd;

            if this_segment_rd >= bsi.segment_rd {
                break;
            }
        }
    }

    if this_segment_rd < bsi.segment_rd {
        bsi.r = br;
        bsi.d = bd;
        bsi.segment_yrate = segmentyrate;
        bsi.segment_rd = this_segment_rd;
        bsi.segment_num = cast,no_check(s32) segmentation;

        for i: 0..cast(s32) 16 - 1 {
            bsi.mvs[i].as_mv = x.partition_info.bmi[i].mv.as_mv;
            bsi.modes[i] = x.partition_info.bmi[i].mode;
            bsi.eobs[i] = cast,no_check(u8) x.e_mbd.eobs[i];
        }
    }
}

labels2mode :: (
    x: *MACROBLOCK_in_block,
    labelings: *s32,
    which_label: s32,
    this_mode: B_PREDICTION_MODE,
    this_mv: *Int_Mv_in_mv,
    best_ref_mv: *Int_Mv_in_mv,
    mvcost: **s32
) -> s32 {
    XD := *x.e_mbd;
    MIC := XD.mode_info_context;
    MIS := XD.mode_info_stride;

    cost: s32 = 0;
    thismvcost: s32 = 0;

    i: s32 = 0;

    while loop := true {
        while loop_2 := true {
            D := XD.block.data + i;
            ROW := i >> 2;
            COL := i & 3;

            m: B_PREDICTION_MODE = ---;

            if labelings[i] != which_label {
                break loop_2;
            }

            if COL != 0 && labelings[i] == labelings[i - 1] {
                m = cast,no_check(B_PREDICTION_MODE) LEFT4X4;
            } else if ROW != 0 && labelings[i] == labelings[i - 4] {
                m = cast,no_check(B_PREDICTION_MODE) ABOVE4X4;
            } else {
                if (ifx true { assignment_1: B_PREDICTION_MODE = cast,no_check(B_PREDICTION_MODE) (this_mode); (m) = assignment_1; assignment_1; }) == {
                    case cast,no_check(u32) NEW4X4;
                        thismvcost = vp8_mv_bit_cost(this_mv, best_ref_mv, mvcost, 102);
                    case cast,no_check(u32) LEFT4X4;
                        this_mv.as_int = ifx COL != 0 then D[-1].bmi.mv.as_int else left_block_mv_in_rdopt(MIC, i);
                    case cast,no_check(u32) ABOVE4X4;
                        this_mv.as_int =
                            ifx ROW != 0 then D[-4].bmi.mv.as_int else above_block_mv_in_rdopt(MIC, i, MIS);
                    case cast,no_check(u32) ZERO4X4;
                        this_mv.as_int = 0;
                    case;
                }

                if m == cast,no_check(u32) ABOVE4X4 {
                    left_mv: Int_Mv_in_mv = ---;

                    left_mv.as_int = ifx COL != 0 then D[-1].bmi.mv.as_int else left_block_mv_in_rdopt(MIC, i);

                    if left_mv.as_int == this_mv.as_int {
                        m = cast,no_check(B_PREDICTION_MODE) LEFT4X4;
                    }
                }

                cost = x.inter_bmode_costs[m];
            }

            D.bmi.mv.as_int = this_mv.as_int;

            x.partition_info.bmi[i].mode = m;
            x.partition_info.bmi[i].mv.as_int = this_mv.as_int;
            break loop_2;
        }
        if !(c_transpiler_pre_increment(*(i)) < 16) break loop;
    }

    cost += thismvcost;
    return cost;
}

rdcost_mbsegment_y :: (
    mb: *MACROBLOCK_in_block,
    labels: *s32,
    which_label: s32,
    ta: *ENTROPY_CONTEXT,
    tl: *ENTROPY_CONTEXT
) -> s32 {
    cost: s32 = 0;

    x := *mb.e_mbd;

    for b: 0..cast(s32) 16 - 1 {
        if labels[b] == which_label {
            cost +=
                cost_coeffs(
                    mb,
                    x.block.data + b,
                    3,
                    ta + cast,no_check(s32) VP8_BLOCK2ABOVE[b],
                    tl + cast,no_check(s32) VP8_BLOCK2LEFT[b]
                );
        }
    }

    return cost;
}

vp8_encode_inter_mb_segment :: (x: *MACROBLOCK_in_block, labels: *s32, which_label: s32) -> u32 {
    distortion: u32 = 0;
    pre_stride := x.e_mbd.pre.y_stride;
    base_pre: *u8 = x.e_mbd.pre.y_buffer;

    for i: 0..cast(s32) 16 - 1 {
        if labels[i] == which_label {
            bd := x.e_mbd.block.data + i;
            be := x.block.data + i;

            vp8_build_inter_predictors_b(
                bd,
                16,
                base_pre,
                pre_stride,
                cast,no_check(Vp8_Subpix_Fn_T) (x.e_mbd.subpixel_predict)
            );
            vp8_subtract_b(be, bd, 16);
            x.short_fdct4x4(be.src_diff, be.coeff, 32);
            x.quantize_b(be, bd);

            distortion += cast,no_check(u32) vp8_block_error_c(be.coeff, bd.dqcoeff);
        }
    }

    return distortion;
}

vp8_cal_step_param :: (sr: s32, sp: *s32) {
    step: s32 = 0;

    if sr > (cast(s32) 1) << (((8 - 1)) & 31) {
        sr = (cast(s32) 1) << (((8 - 1)) & 31);
    } else if sr < 1 {
        sr = 1;
    }

    while ((c_transpiler_compound_shr(*(sr), (cast(s32) 1), s32, s32)) != 0) {
        step += 1;
    }

    sp.* = (cast,no_check(s32) ((8 - 1))) - step;
}

rd_pick_intra4x4mby_modes :: (
    mb: *MACROBLOCK_in_block,
    rate: *s32,
    rate_y: *s32,
    distortion_value: *s32,
    best_rd: s32
) -> s32 {
    XD := *mb.e_mbd;

    cost := mb.mbmode_cost[XD.frame_type][B_PRED];
    distortion: s32 = 0;
    tot_rate_y: s32 = 0;
    total_rd: s64 = 0;
    t_above, t_left: ENTROPY_CONTEXT_PLANES = ---;

    t_above = mb.e_mbd.above_context.*;
    t_left = mb.e_mbd.left_context.*;

    ta := cast(*ENTROPY_CONTEXT) *t_above;
    tl := cast(*ENTROPY_CONTEXT) *t_left;

    intra_prediction_down_copy_in_rdopt(XD, XD.dst.y_buffer - XD.dst.y_stride + 16);

    bmode_costs := mb.inter_bmode_costs;

    for i: 0..cast(s32) 16 - 1 {
        MIC := XD.mode_info_context;
        MIS := XD.mode_info_stride;
        best_mode := cast,no_check(B_PREDICTION_MODE) B_MODE_COUNT;
        r: s32 = 0;
        ry: s32 = 0;
        d: s32 = 0;

        if mb.e_mbd.frame_type == cast,no_check(u32) KEY_FRAME_in_alloccommon {
            A := above_block_mode_in_rdopt(MIC, i, MIS);
            L := left_block_mode_in_rdopt(MIC, i);

            bmode_costs = mb.bmode_costs[A][L].data;
        }

        total_rd +=
            cast,no_check(s64) rd_pick_intra4x4block(
                mb,
                mb.block.data + i,
                XD.block.data + i,
                *best_mode,
                bmode_costs,
                ta + cast,no_check(s32) VP8_BLOCK2ABOVE[i],
                tl + cast,no_check(s32) VP8_BLOCK2LEFT[i],
                *r,
                *ry,
                *d
            );

        cost += r;
        distortion += d;
        tot_rate_y += ry;

        MIC.bmi[i].as_mode = best_mode;

        if total_rd >= cast,no_check(s64) best_rd {
            break;
        }
    }

    if total_rd >= cast,no_check(s64) best_rd {
        return 2147483647;
    }

    rate.* = cost;
    rate_y.* = tot_rate_y;
    distortion_value.* = distortion;

    return (128 + cost * mb.rdmult) >> 8 + mb.rddiv * distortion;
}

rd_pick_intra4x4block :: (
    x: *MACROBLOCK_in_block,
    be: *BLOCK,
    b: *BLOCKD,
    best_mode: *B_PREDICTION_MODE,
    bmode_costs: *s32,
    a: *ENTROPY_CONTEXT,
    l: *ENTROPY_CONTEXT,
    bestrate: *s32,
    bestratey: *s32,
    bestdistortion: *s32
) -> s32 {
    best_rd: s32 = 2147483647;
    rate: s32 = 0;

    ta := a.*;
    tempa := a.*;
    tl := l.*;
    templ := l.*;

    best_predictor: [64] u8 = --- #align 16;
    best_dqcoeff: [16] s16 = --- #align 16;
    dst_stride := x.e_mbd.dst.y_stride;
    dst: *u8 = x.e_mbd.dst.y_buffer + b.offset;

    above := dst - dst_stride;
    yleft := dst - 1;
    top_left := above[-1];

    mode := cast,no_check(B_PREDICTION_MODE) B_DC_PRED;
    while mode <= cast,no_check(u32) B_HU_PRED {
        rate = bmode_costs[mode];

        vp8_intra4x4_predict(above, yleft, dst_stride, mode, b.predictor, 16, top_left);
        vp8_subtract_b(be, b, 16);
        x.short_fdct4x4(be.src_diff, be.coeff, 32);
        x.quantize_b(be, b);

        tempa = ta;
        templ = tl;

        ratey := cost_coeffs(x, b, 3, *tempa, *templ);
        rate += ratey;
        distortion := vp8_block_error_c(be.coeff, b.dqcoeff) >> 2;

        this_rd := (128 + rate * x.rdmult) >> 8 + x.rddiv * distortion;

        if this_rd < best_rd {
            bestrate.* = rate;
            bestratey.* = ratey;
            bestdistortion.* = distortion;
            best_rd = this_rd;
            best_mode.* = mode;
            a.* = tempa;
            l.* = templ;
            copy_predictor(best_predictor.data, b.predictor);
            copy_memory(best_dqcoeff.data, b.dqcoeff, 32);
        }
        mode += 1;
    }
    b.bmi.as_mode = best_mode.*;

    vp8_short_idct4x4llm_c(best_dqcoeff.data, best_predictor.data, 16, dst, dst_stride);

    return best_rd;
}

copy_predictor :: (dst: *u8, predictor: *u8) {
    p := cast(*u32) predictor;
    d := cast(*u32) dst;
    d[0] = p[0];
    d[4] = p[4];
    d[8] = p[8];
    d[12] = p[12];
}

rd_pick_intra_mbuv_mode :: (x: *MACROBLOCK_in_block, rate: *s32, rate_tokenonly: *s32, distortion: *s32) {
    mode_selected := cast,no_check(MB_PREDICTION_MODE) MB_MODE_COUNT;
    best_rd: s32 = 2147483647;
    d: s32 = 0;
    r: s32 = 0;

    xd := *x.e_mbd;

    mode := cast,no_check(MB_PREDICTION_MODE) DC_PRED;
    while mode <= cast,no_check(u32) TM_PRED {
        xd.mode_info_context.mbmi.uv_mode = cast,no_check(u8) mode;

        vp8_build_intra_predictors_mbuv_s(
            xd,
            xd.dst.u_buffer - xd.dst.uv_stride,
            xd.dst.v_buffer - xd.dst.uv_stride,
            xd.dst.u_buffer - 1,
            xd.dst.v_buffer - 1,
            xd.dst.uv_stride,
            xd.predictor.data + 256,
            xd.predictor.data + 320,
            8
        );

        vp8_subtract_mbuv(
            x.src_diff.data,
            x.src.u_buffer,
            x.src.v_buffer,
            x.src.uv_stride,
            xd.predictor.data + 256,
            xd.predictor.data + 320,
            8
        );
        vp8_transform_mbuv(x);
        vp8_quantize_mbuv(x);

        rate_to := rd_cost_mbuv(x);
        this_rate := rate_to + x.intra_uv_mode_cost[xd.frame_type][xd.mode_info_context.mbmi.uv_mode];

        this_distortion := vp8_mbuverror_c(x) / 4;

        this_rd := (128 + this_rate * x.rdmult) >> 8 + x.rddiv * this_distortion;

        if this_rd < best_rd {
            best_rd = this_rd;
            d = this_distortion;
            r = this_rate;
            rate_tokenonly.* = rate_to;
            mode_selected = mode;
        }
        mode += 1;
    }

    rate.* = r;
    distortion.* = d;

    xd.mode_info_context.mbmi.uv_mode = cast,no_check(u8) mode_selected;
}

get_predictor_pointers_in_rdopt :: (cpi: *VP8_COMP, plane: *[3] *u8, recon_yoffset: u32, recon_uvoffset: u32) {
    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_LAST_FRAME) != 0 {
        get_plane_pointers_in_rdopt(
            cpi.common.yv12_fb.data + cpi.common.lst_fb_idx,
            plane[LAST_FRAME].data,
            recon_yoffset,
            recon_uvoffset
        );
    }

    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_GOLD_FRAME) != 0 {
        get_plane_pointers_in_rdopt(
            cpi.common.yv12_fb.data + cpi.common.gld_fb_idx,
            plane[GOLDEN_FRAME].data,
            recon_yoffset,
            recon_uvoffset
        );
    }

    if cpi.ref_frame_flags & cast,no_check(s32) (VP8_ALTR_FRAME) != 0 {
        get_plane_pointers_in_rdopt(
            cpi.common.yv12_fb.data + cpi.common.alt_fb_idx,
            plane[ALTREF_FRAME].data,
            recon_yoffset,
            recon_uvoffset
        );
    }
}

get_plane_pointers_in_rdopt :: (fb: *YV12_BUFFER_CONFIG, plane: **u8, recon_yoffset: u32, recon_uvoffset: u32) {
    plane[0] = fb.y_buffer + recon_yoffset;
    plane[1] = fb.u_buffer + recon_uvoffset;
    plane[2] = fb.v_buffer + recon_uvoffset;
}

get_reference_search_order_in_rdopt :: (cpi: *VP8_COMP, ref_frame_map: *s32) {
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

vp8_rd_pick_intra_mode :: (x: *MACROBLOCK_in_block, rate: *s32) {
    rate4x4: s32 = ---;
    rate16x16: s32 = 0;
    rateuv: s32 = ---;
    dist4x4, dist16x16, distuv: s32 = ---;

    rate4x4_tokenonly: s32 = 0;
    rate16x16_tokenonly: s32 = 0;
    rateuv_tokenonly: s32 = 0;

    x.e_mbd.mode_info_context.mbmi.ref_frame = cast,no_check(u8) INTRA_FRAME;

    rd_pick_intra_mbuv_mode(x, *rateuv, *rateuv_tokenonly, *distuv);
    rate_value := rateuv;

    error16x16 := rd_pick_intra16x16mby_mode(x, *rate16x16, *rate16x16_tokenonly, *dist16x16);

    error4x4 := rd_pick_intra4x4mby_modes(x, *rate4x4, *rate4x4_tokenonly, *dist4x4, error16x16);

    if error4x4 < error16x16 {
        x.e_mbd.mode_info_context.mbmi.mode = cast,no_check(u8) B_PRED;
        rate_value += rate4x4;
    } else {
        rate_value += rate16x16;
    }

    rate.* = rate_value;
}

rd_pick_intra16x16mby_mode :: (x: *MACROBLOCK_in_block, rate_value: *s32, rate_y: *s32, distortion_value: *s32) -> s32 {
    mode_selected := cast,no_check(MB_PREDICTION_MODE) MB_MODE_COUNT;
    ratey: s32 = ---;
    distortion: s32 = ---;
    best_rd: s32 = 2147483647;

    xd := *x.e_mbd;

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

        macro_block_yrd(x, *ratey, *distortion);
        rate := ratey + x.mbmode_cost[xd.frame_type][xd.mode_info_context.mbmi.mode];

        this_rd := (128 + rate * x.rdmult) >> 8 + x.rddiv * distortion;

        if this_rd < best_rd {
            mode_selected = mode;
            best_rd = this_rd;
            rate_value.* = rate;
            rate_y.* = ratey;
            distortion_value.* = distortion;
        }
        mode += 1;
    }

    xd.mode_info_context.mbmi.mode = cast,no_check(u8) mode_selected;
    return best_rd;
}

globals_initialization_state_for_rdopt: u32;
initialize_globals_for_rdopt :: () {
    {
        state := atomic_load(*globals_initialization_state_for_rdopt);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_rdopt, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_rdopt) != 2 {}
            return;
        }
    }
    AUTO_SPEED_THRESH =
        s32.[
            1000,
            200,
            150,
            130,
            150,
            125,
            120,
            115,
            115,
            115,
            115,
            115,
            115,
            115,
            115,
            115,
            105
        ];
    VP8_MODE_ORDER =
        MB_PREDICTION_MODE.[
            cast,no_check(MB_PREDICTION_MODE) ZEROMV,
            cast,no_check(MB_PREDICTION_MODE) DC_PRED,
            cast,no_check(MB_PREDICTION_MODE) NEARESTMV,
            cast,no_check(MB_PREDICTION_MODE) NEARMV,
            cast,no_check(MB_PREDICTION_MODE) ZEROMV,
            cast,no_check(MB_PREDICTION_MODE) NEARESTMV,
            cast,no_check(MB_PREDICTION_MODE) ZEROMV,
            cast,no_check(MB_PREDICTION_MODE) NEARESTMV,
            cast,no_check(MB_PREDICTION_MODE) NEARMV,
            cast,no_check(MB_PREDICTION_MODE) NEARMV,
            cast,no_check(MB_PREDICTION_MODE) V_PRED,
            cast,no_check(MB_PREDICTION_MODE) H_PRED,
            cast,no_check(MB_PREDICTION_MODE) TM_PRED,
            cast,no_check(MB_PREDICTION_MODE) NEWMV,
            cast,no_check(MB_PREDICTION_MODE) NEWMV,
            cast,no_check(MB_PREDICTION_MODE) NEWMV,
            cast,no_check(MB_PREDICTION_MODE) SPLITMV,
            cast,no_check(MB_PREDICTION_MODE) SPLITMV,
            cast,no_check(MB_PREDICTION_MODE) SPLITMV,
            cast,no_check(MB_PREDICTION_MODE) B_PRED
        ];
    VP8_REF_FRAME_ORDER =
        s32.[
            1,
            0,
            1,
            1,
            2,
            2,
            3,
            3,
            2,
            3,
            0,
            0,
            0,
            1,
            2,
            3,
            1,
            2,
            3,
            0
        ];
    RD_IIFACTOR =
        s32.[
            4,
            4,
            3,
            2,
            1,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0
        ];
    SAD_PER_BIT16LUT =
        s32.[
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            4,
            4,
            4,
            4,
            4,
            4,
            4,
            4,
            4,
            4,
            4,
            4,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
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
            11,
            11,
            11,
            11,
            11,
            11,
            12,
            12,
            12,
            12,
            12,
            12,
            13,
            13,
            13,
            13,
            14,
            14
        ];
    SAD_PER_BIT4LUT =
        s32.[
            2,
            2,
            2,
            2,
            2,
            2,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            4,
            4,
            4,
            4,
            4,
            4,
            4,
            4,
            4,
            4,
            5,
            5,
            5,
            5,
            5,
            5,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
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
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            12,
            12,
            12,
            12,
            12,
            12,
            12,
            12,
            13,
            13,
            13,
            13,
            13,
            13,
            13,
            14,
            14,
            14,
            14,
            14,
            15,
            15,
            15,
            15,
            16,
            16,
            16,
            16,
            17,
            17,
            17,
            18,
            18,
            18,
            19,
            19,
            19,
            20,
            20,
            20
        ];
    SEGMENTATION_TO_SSESHIFT = u32.[ 3, 3, 2, 0 ];
    atomic_store(*globals_initialization_state_for_rdopt, 2);
}

