// Generated directly from C by cpp_transpiler.
COUNT_TO_UPDATE_FACTOR_in_vp9_svc_layercontext: [21] s32;

SUB_PEL_FILTERS_12_in_vp9_svc_layercontext: [16] Interp_Kernel12 #align 256;

FRAME_SCALE_FACTOR_in_vp9_svc_layercontext: [2] s32;

RATE_THRESH_MULT_in_vp9_svc_layercontext: [2] float64;

RCF_MULT_in_vp9_svc_layercontext: [2] float64;

K_VP9_REF_FLAG_LIST_in_vp9_svc_layercontext: [4] s32;

clip_pixel_in_vp9_svc_layercontext :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_svc_layercontext :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_svc_layercontext :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_svc_layercontext :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_svc_layercontext :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_svc_layercontext(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_svc_layercontext(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_svc_layercontext(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_svc_layercontext :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_prob_in_vp9_svc_layercontext :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_svc_layercontext :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_svc_layercontext(n0, DEN);
}

weighted_prob_in_vp9_svc_layercontext :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_svc_layercontext :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_svc_layercontext(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_svc_layercontext(
        cast,no_check(s32) pre_prob,
        cast,no_check(s32) PROB,
        cast,no_check(s32) FACTOR
    );
}

mode_mv_merge_probs_in_vp9_svc_layercontext :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_svc_layercontext[COUNT];
        PROB := get_prob_in_vp9_svc_layercontext(ct[0], DEN);
        return weighted_prob_in_vp9_svc_layercontext(
            cast,no_check(s32) pre_prob,
            cast,no_check(s32) PROB,
            cast,no_check(s32) FACTOR
        );
    }
}

get_lsb_in_vp9_svc_layercontext :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_svc_layercontext :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_svc_layercontext :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_svc_layercontext(num_values) + 1 else 0;
}

get_band_translate_in_vp9_svc_layercontext :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_svc_layercontext :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_svc_layercontext :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
    above_ec: ENTROPY_CONTEXT = 0;
    left_ec: ENTROPY_CONTEXT = 0;

    if cast,no_check(s32) tx_size == {
        case cast,no_check(s32) cast(TX_SIZE) 0;
            above_ec = cast(ENTROPY_CONTEXT) (a[0] != 0);
            left_ec = cast(ENTROPY_CONTEXT) (l[0] != 0);
        case cast,no_check(s32) cast(TX_SIZE) 1;
            above_ec = cast(ENTROPY_CONTEXT) (((cast(*u16) a).*) != 0);
            left_ec = cast(ENTROPY_CONTEXT) (((cast(*u16) l).*) != 0);
        case cast,no_check(s32) cast(TX_SIZE) 2;
            above_ec = cast(ENTROPY_CONTEXT) (((cast(*u32) a).*) != 0);
            left_ec = cast(ENTROPY_CONTEXT) (((cast(*u32) l).*) != 0);
        case cast,no_check(s32) cast(TX_SIZE) 3;
            above_ec = cast(ENTROPY_CONTEXT) (((cast(*u64) a).*) != 0);
            left_ec = cast(ENTROPY_CONTEXT) (((cast(*u64) l).*) != 0);
        case;
    }

    return combine_entropy_contexts_in_vp9_svc_layercontext(above_ec, left_ec);
}

is_zero_mv_in_vp9_svc_layercontext :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_svc_layercontext :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_svc_layercontext :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_svc_layercontext(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_svc_layercontext(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_svc_layercontext :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_svc_layercontext :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_svc_layercontext :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_svc_layercontext :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

get_filter_taps_in_vp9_svc_layercontext :: (FILTER: *s16) -> s32 {
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

vp9_is_valid_scale_in_vp9_svc_layercontext :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_svc_layercontext :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_svc_layercontext(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_svc_layercontext :: (
    ref_width: s32,
    ref_height: s32,
    this_width: s32,
    this_height: s32
) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_svc_layercontext :: (
    seg: *Segmentation,
    segment_id: s32,
    feature_id: SEG_LVL_FEATURES
) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_svc_layercontext :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_svc_layercontext :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_svc_layercontext :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_svc_layercontext :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_svc_layercontext :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_svc_layercontext :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_svc_layercontext :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_svc_layercontext :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_svc_layercontext :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_svc_layercontext(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_svc_layercontext :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_svc_layercontext(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_svc_layercontext(MI, ib)];
}

get_uv_tx_size_in_vp9_svc_layercontext :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_svc_layercontext :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_svc_layercontext :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_svc_layercontext(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_svc_layercontext :: (
    mi: *MODE_INFO,
    above_mi: *MODE_INFO,
    left_mi: *MODE_INFO,
    block: s32
) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

cyclic_refresh_segment_id_boosted_in_vp9_svc_layercontext :: (segment_id: s32) -> s32 {
    if segment_id == 1 || segment_id == 2 {
        return 1;
    }
    return 0;
}

cyclic_refresh_segment_id_in_vp9_svc_layercontext :: (segment_id: s32) -> s32 {
    if segment_id == 1 {
        return 1;
    } else if segment_id == 2 {
        return 2;
    } else {
        return 0;
    }
}

vp8_set_reference_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_vp9_svc_layercontext :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

gcd_in_vp9_svc_layercontext :: (a: s64, b: s32) -> s32 {
    while b != 0 {
        r := cast,no_check(s32) (a % cast(s64) b);
        a = cast,no_check(s64) b;
        b = r;
    }

    return cast,no_check(s32) a;
}

reduce_ratio_in_vp9_svc_layercontext :: (ratio: *Rational64_T) {
    DENOM := gcd_in_vp9_svc_layercontext(ratio.num, ratio.den);
    ratio.num /= cast,no_check(s64) DENOM;
    ratio.den /= DENOM;
}

get_lfm_in_vp9_svc_layercontext :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_svc_layercontext :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_svc_layercontext :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_svc_layercontext :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
    frame_info.frame_width = cm.width;
    frame_info.frame_height = cm.height;
    frame_info.render_frame_width = cm.render_width;
    frame_info.render_frame_height = cm.render_height;
    frame_info.mi_cols = cm.mi_cols;
    frame_info.mi_rows = cm.mi_rows;
    frame_info.mb_cols = cm.mb_cols;
    frame_info.mb_rows = cm.mb_rows;
    frame_info.num_mbs = cm.m_bs;
    frame_info.bit_depth = cm.bit_depth;
}

get_buf_frame_in_vp9_svc_layercontext :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_svc_layercontext :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_svc_layercontext :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_svc_layercontext :: (cm: *VP9_COMMON) -> s32 {
    FRAME_BUFS := cm.buffer_pool.frame_bufs.data;

    i: s32 = 0;
    while i < (cast(s32) 1) << 3 + 1 + 3 {
        if FRAME_BUFS[i].ref_count == 0 {
            break;
        }
        i += 1;
    }

    if i != (cast(s32) 1) << 3 + 1 + 3 {
        FRAME_BUFS[i].ref_count = 1;
    } else {
        i = -1;
    }

    return i;
}

ref_cnt_fb_in_vp9_svc_layercontext :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_svc_layercontext :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_svc_layercontext :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_svc_layercontext :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_svc_layercontext(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_svc_layercontext :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_svc_layercontext(cm.mi_cols);

        if get_plane_type_in_vp9_svc_layercontext(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_svc_layercontext(cm, xd);
}

get_partition_probs_in_vp9_svc_layercontext :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_svc_layercontext :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_svc_layercontext :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_svc_layercontext :: (
    xd: *MACROBLOCKD,
    TILE: *Tile_Info,
    mi_row: s32,
    bh: s32,
    mi_col: s32,
    bw: s32,
    mi_rows: s32,
    mi_cols: s32
) {
    xd.mb_to_top_edge = -(mi_row * (cast(s32) 1) << 3 * 8);
    xd.mb_to_bottom_edge = (mi_rows - bh - mi_row) * (cast(s32) 1) << 3 * 8;
    xd.mb_to_left_edge = -(mi_col * (cast(s32) 1) << 3 * 8);
    xd.mb_to_right_edge = (mi_cols - bw - mi_col) * (cast(s32) 1) << 3 * 8;

    xd.above_mi = ifx mi_row != 0 then xd.mi[-xd.mi_stride] else null;
    xd.left_mi = ifx mi_col > TILE.mi_col_start then xd.mi[-1] else null;
}

update_partition_context_in_vp9_svc_layercontext :: (
    xd: *MACROBLOCKD,
    mi_row: s32,
    mi_col: s32,
    subsize: BLOCK_SIZE,
    bsize: BLOCK_SIZE
) {
    ABOVE_CTX := xd.above_seg_context + mi_col;
    LEFT_CTX := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);

    BS := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize];

    fill_memory(ABOVE_CTX, cast,no_check(s32) PARTITION_CONTEXT_LOOKUP[subsize].above, cast,no_check(u64) BS);
    fill_memory(LEFT_CTX, cast,no_check(s32) PARTITION_CONTEXT_LOOKUP[subsize].left, cast,no_check(u64) BS);
}

partition_plane_context_in_vp9_svc_layercontext :: (
    xd: *MACROBLOCKD,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE
) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

fps_init_first_pass_info_in_vp9_svc_layercontext :: (
    first_pass_info: *FIRST_PASS_INFO,
    stats: *FIRSTPASS_STATS_in_vp9_cx_iface,
    num_frames: s32
) {
    first_pass_info.stats = stats;
    first_pass_info.num_frames = num_frames;
}

fps_get_num_frames_in_vp9_svc_layercontext :: (first_pass_info: *FIRST_PASS_INFO) -> s32 {
    return first_pass_info.num_frames;
}

fps_get_frame_stats_in_vp9_svc_layercontext :: (
    first_pass_info: *FIRST_PASS_INFO,
    show_idx: s32
) -> *FIRSTPASS_STATS_in_vp9_cx_iface {
    if show_idx < 0 || show_idx >= first_pass_info.num_frames {
        return null;
    }
    return *(cast(*FIRSTPASS_STATS_in_vp9_cx_iface) (first_pass_info.stats))[show_idx];
}

get_buf_from_mv_in_vp9_svc_layercontext :: (buf: *Buf_2d, mv: *MV) -> *u8 {
    return *buf.buf[(cast(s32) mv.row) * buf.stride + cast(s32) mv.col];
}

cost_branch256_in_vp9_svc_layercontext :: (ct: *u32, p: Prob) -> u64 {
    return ((cast,no_check(u64) ct[0]) * cast(u64) VP9_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP9_PROB_COST[256 - cast(s32) p];
}

treed_cost_in_vp9_svc_layercontext :: (tree: *Tree_Index, probs: *Prob, bits: s32, len: s32) -> s32 {
    cost: s32 = 0;
    i: Tree_Index = 0;

    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            cost +=
                cast,no_check(s32) (VP9_PROB_COST[(ifx BIT != 0 then 256 -
                    cast(s32) probs[(cast(s32) i) >> 1] else cast,no_check(s32) probs[(cast(s32) i) >> 1])]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }

    return cost;
}

rd_less_than_thresh_in_vp9_svc_layercontext :: (best_rd: s64, thresh: s32, THRESH_FACT: *s32) -> s32 {
    if best_rd < ((cast,no_check(s64) thresh) * cast(s64) THRESH_FACT.*) >> 5 || thresh == 2147483647 {
        return 1;
    }
    return 0;
}

set_error_per_bit_in_vp9_svc_layercontext :: (x: *MACROBLOCK, rdmult: s32) {
    x.errorperbit = rdmult >> 6;
    x.errorperbit += cast(s32) (x.errorperbit == 0);
}

vp9_init_layer_context :: (CPI: *VP9_COMP_in_vp9_encoder) {
    SVC_ := *CPI.svc;
    OXCF := *CPI.oxcf;
    mi_rows := CPI.common.mi_rows;
    mi_cols := CPI.common.mi_cols;
    tl: s32 = ---;
    alt_ref_idx := SVC_.number_spatial_layers;

    SVC_.spatial_layer_id = 0;
    SVC_.temporal_layer_id = 0;
    SVC_.force_zero_mode_spatial_ref = 0;
    SVC_.use_base_mv = 0;
    SVC_.use_partition_reuse = 0;
    SVC_.use_gf_temporal_ref = 1;
    SVC_.use_gf_temporal_ref_current_layer = 0;
    SVC_.scaled_temp_is_alloc = 0;
    SVC_.scaled_one_half = 0;
    SVC_.current_superframe = 0;
    SVC_.non_reference_frame = 0;
    SVC_.skip_enhancement_layer = 0;
    SVC_.disable_inter_layer_pred = cast,no_check(INTER_LAYER_PRED) INTER_LAYER_PRED_ON;
    SVC_.framedrop_mode = cast,no_check(SVC_LAYER_DROP_MODE) CONSTRAINED_LAYER_DROP;
    SVC_.set_intra_only_frame = 0;
    SVC_.previous_frame_is_intra_only = 0;
    SVC_.superframe_has_layer_sync = 0;
    SVC_.use_set_ref_frame_config = 0;
    SVC_.num_encoded_top_layer = 0;
    SVC_.simulcast_mode = 0;
    SVC_.single_layer_svc = 0;
    SVC_.resize_set = 0;

    i: s32 = 0;
    while i < (cast(s32) 1) << 3 {
        SVC_.fb_idx_spatial_layer_id[i] = 0xff;
        SVC_.fb_idx_temporal_layer_id[i] = 0xff;
        SVC_.fb_idx_base[i] = 0;
        i += 1;
    }
    sl: s32 = 0;
    while sl < OXCF.ss_number_layers {
        SVC_.last_layer_dropped[sl] = 0;
        SVC_.drop_spatial_layer[sl] = 0;
        SVC_.ext_frame_flags[sl] = 0;
        SVC_.lst_fb_idx[sl] = 0;
        SVC_.gld_fb_idx[sl] = 1;
        SVC_.alt_fb_idx[sl] = 2;
        SVC_.downsample_filter_type[sl] = 3;
        SVC_.downsample_filter_phase[sl] = 8;
        SVC_.framedrop_thresh[sl] = OXCF.drop_frames_water_mark;
        SVC_.fb_idx_upd_tl0[sl] = -1;
        SVC_.drop_count[sl] = 0;
        SVC_.spatial_layer_sync[sl] = 0;
        SVC_.force_drop_constrained_from_above[sl] = 0;
        sl += 1;
    }
    SVC_.max_consec_drop = 2147483647;

    SVC_.buffer_gf_temporal_ref[1].idx = 7;
    SVC_.buffer_gf_temporal_ref[0].idx = 6;
    SVC_.buffer_gf_temporal_ref[1].is_used = 0;
    SVC_.buffer_gf_temporal_ref[0].is_used = 0;

    if CPI.oxcf.error_resilient_mode == 0 && CPI.oxcf.pass == 2 {
        if realloc_frame_buffer(
            *CPI.svc.empty_frame.img,
            32,
            16,
            CPI.common.subsampling_x,
            CPI.common.subsampling_y,
            160,
            CPI.common.byte_alignment,
            null,
            null,
            null
        ) != 0 {
            internal_error(
                *CPI.common.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate empty frame for multiple frame contexts")
            );
        }

        fill_memory(CPI.svc.empty_frame.img.buffer_alloc, 0x80, CPI.svc.empty_frame.img.buffer_alloc_sz);
    }

    sl = 0;
    while sl < OXCF.ss_number_layers {
        tl = 0;
        while tl < OXCF.ts_number_layers {
            layer := sl * OXCF.ts_number_layers + tl;
            LC := SVC_.layer_context.data + layer;
            LRC := *LC.rc;
            LC.current_video_frame_in_layer = 0;
            LC.layer_size = 0;
            LC.frames_from_key_frame = 0;
            LC.last_frame_type = cast,no_check(FRAME_TYPE) FRAME_TYPES;
            LRC.ni_av_qi = OXCF.worst_allowed_q;
            LRC.total_actual_bits = 0;
            LRC.total_target_vs_actual = 0;
            LRC.ni_tot_qi = 0;
            LRC.tot_q = 0.0;
            LRC.avg_q = 0.0;
            LRC.ni_frames = 0;
            LRC.decimation_count = 0;
            LRC.decimation_factor = 0;
            LRC.worst_quality = OXCF.worst_allowed_q;
            LRC.best_quality = OXCF.best_allowed_q;

            i = 0;
            while i < RATE_FACTOR_LEVELS {
                LRC.rate_correction_factors[i] = 1.0;
                i += 1;
            }

            if CPI.oxcf.rc_mode == cast,no_check(u32) CBR {
                LC.target_bandwidth = OXCF.layer_target_bitrate[layer];
                LRC.last_q[INTER_FRAME] = OXCF.worst_allowed_q;
                LRC.avg_frame_qindex[INTER_FRAME] = OXCF.worst_allowed_q;
                LRC.avg_frame_qindex[KEY_FRAME] = OXCF.worst_allowed_q;
            } else {
                LC.target_bandwidth = OXCF.layer_target_bitrate[layer];
                LRC.last_q[KEY_FRAME] = OXCF.best_allowed_q;
                LRC.last_q[INTER_FRAME] = OXCF.best_allowed_q;
                LRC.avg_frame_qindex[KEY_FRAME] = (OXCF.worst_allowed_q + OXCF.best_allowed_q) / 2;
                LRC.avg_frame_qindex[INTER_FRAME] = (OXCF.worst_allowed_q + OXCF.best_allowed_q) / 2;
                if OXCF.ss_enable_auto_arf[sl] != 0 {
                    LC.alt_ref_idx = c_transpiler_post_increment(*(alt_ref_idx));
                } else {
                    LC.alt_ref_idx = -1;
                }
                LC.gold_ref_idx = -1;
            }

            LRC.buffer_level = (OXCF.starting_buffer_level_ms * cast(s64) LC.target_bandwidth) / 1000;
            LRC.bits_off_target = LRC.buffer_level;

            if OXCF.ss_number_layers > 1 && tl == 0 {
                CM := *CPI.common;
                LC.sb_index = 0;
                LC.actual_num_seg1_blocks = 0;
                LC.actual_num_seg2_blocks = 0;
                LC.counter_encode_maxq_scene_change = 0;
                LC.map = cast(*s8) allocate_memory(cast,no_check(u64) (mi_rows * mi_cols));

                if LC.map == null {
                    internal_error(
                        *CM.error,
                        cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                        c_string("Failed to allocate lc->map")
                    );
                }
                fill_memory(LC.map, 0, cast,no_check(u64) (mi_rows * mi_cols));
                last_coded_q_map_size := (cast,no_check(u64) (mi_rows * mi_cols)) * size_of(u8);
                LC.last_coded_q_map = cast(*u8) allocate_memory(last_coded_q_map_size);

                if LC.last_coded_q_map == null {
                    internal_error(
                        *CM.error,
                        cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                        c_string("Failed to allocate lc->last_coded_q_map")
                    );
                }

                fill_memory(LC.last_coded_q_map, 255, last_coded_q_map_size);
                consec_zero_mv_size := (cast,no_check(u64) (mi_rows * mi_cols)) * size_of(u8);
                LC.consec_zero_mv = cast(*u8) allocate_memory(consec_zero_mv_size);

                if LC.consec_zero_mv == null {
                    internal_error(
                        *CM.error,
                        cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                        c_string("Failed to allocate lc->consec_zero_mv")
                    );
                }
                fill_memory(LC.consec_zero_mv, 0, consec_zero_mv_size);
            }
            tl += 1;
        }
        sl += 1;
    }

    if !(SVC_.number_temporal_layers > 1 && CPI.oxcf.rc_mode == cast,no_check(u32) CBR) && alt_ref_idx < (cast(s32) 1) << 3 {
        SVC_.layer_context[0].gold_ref_idx = alt_ref_idx;
    }
}

vp9_update_layer_context_change_config :: (CPI: *VP9_COMP_in_vp9_encoder, TARGET_BANDWIDTH: s32) {
    SVC_ := *CPI.svc;
    OXCF := *CPI.oxcf;
    RC := *CPI.rc;
    sl: s32 = ---;
    tl: s32 = ---;
    layer: s32 = 0;
    spatial_layer_target: s32 = ---;
    bitrate_alloc: float32 = 1.0;
    num_spatial_layers_nonzero_rate: s32 = 0;

    CPI.svc.temporal_layering_mode = OXCF.temporal_layering_mode;

    if SVC_.temporal_layering_mode != cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_NOLAYERING {
        sl = 0;
        while sl < OXCF.ss_number_layers {
            tl = 0;
            while tl < OXCF.ts_number_layers {
                layer = sl * OXCF.ts_number_layers + tl;
                SVC_.layer_context[layer].target_bandwidth = OXCF.layer_target_bitrate[layer];
                tl += 1;
            }

            layer =
                sl * OXCF.ts_number_layers +
                    (ifx OXCF.ts_number_layers - 1 < 0 then 0 else OXCF.ts_number_layers - 1);
            SVC_.layer_context[layer].target_bandwidth = OXCF.layer_target_bitrate[layer];
            spatial_layer_target = SVC_.layer_context[layer].target_bandwidth;

            tl = 0;
            while tl < OXCF.ts_number_layers {
                LC := SVC_.layer_context.data + sl * OXCF.ts_number_layers + tl;
                LRC := *LC.rc;

                LC.spatial_layer_target_bandwidth = spatial_layer_target;
                if TARGET_BANDWIDTH != 0 {
                    bitrate_alloc = (cast,no_check(float32) LC.target_bandwidth) / TARGET_BANDWIDTH;
                }
                LRC.starting_buffer_level =
                    cast,no_check(s64) ((cast,no_check(float64) (RC.starting_buffer_level * bitrate_alloc)) +
                        0.5);
                LRC.optimal_buffer_level =
                    cast,no_check(s64) ((cast,no_check(float64) (RC.optimal_buffer_level * bitrate_alloc)) +
                        0.5);
                LRC.maximum_buffer_size =
                    cast,no_check(s64) ((cast,no_check(float64) (RC.maximum_buffer_size * bitrate_alloc)) +
                        0.5);
                LRC.bits_off_target =
                    ifx LRC.bits_off_target < LRC.maximum_buffer_size then LRC.bits_off_target else LRC.maximum_buffer_size;
                LRC.buffer_level =
                    ifx LRC.buffer_level < LRC.maximum_buffer_size then LRC.buffer_level else LRC.maximum_buffer_size;
                LC.framerate = CPI.framerate / OXCF.ts_rate_decimator[tl];
                LRC.avg_frame_bandwidth =
                    saturate_cast_double_to_int_in_vp9_svc_layercontext(
                        c_transpiler_math_round(LC.target_bandwidth / LC.framerate)
                    );
                LRC.max_frame_bandwidth = RC.max_frame_bandwidth;
                LRC.worst_quality = RC.worst_quality;
                LRC.best_quality = RC.best_quality;
                tl += 1;
            }
            sl += 1;
        }
    } else {
        layer_end := SVC_.number_spatial_layers;
        layer = 0;
        while layer < layer_end {
            LC := SVC_.layer_context.data + layer;
            LRC := *LC.rc;

            LC.target_bandwidth = OXCF.layer_target_bitrate[layer];

            if TARGET_BANDWIDTH != 0 {
                bitrate_alloc = (cast,no_check(float32) LC.target_bandwidth) / TARGET_BANDWIDTH;
            }

            LRC.starting_buffer_level = cast,no_check(s64) (RC.starting_buffer_level * bitrate_alloc);
            LRC.optimal_buffer_level = cast,no_check(s64) (RC.optimal_buffer_level * bitrate_alloc);
            LRC.maximum_buffer_size = cast,no_check(s64) (RC.maximum_buffer_size * bitrate_alloc);
            LRC.bits_off_target =
                ifx LRC.bits_off_target < LRC.maximum_buffer_size then LRC.bits_off_target else LRC.maximum_buffer_size;
            LRC.buffer_level =
                ifx LRC.buffer_level < LRC.maximum_buffer_size then LRC.buffer_level else LRC.maximum_buffer_size;
            LC.framerate = CPI.framerate;
            LRC.avg_frame_bandwidth =
                saturate_cast_double_to_int_in_vp9_svc_layercontext(
                    c_transpiler_math_round(LC.target_bandwidth / LC.framerate)
                );
            LRC.max_frame_bandwidth = RC.max_frame_bandwidth;

            LRC.worst_quality = RC.worst_quality;
            LRC.best_quality = RC.best_quality;
            layer += 1;
        }
    }
    sl = 0;
    while sl < OXCF.ss_number_layers {
        layer = sl * OXCF.ts_number_layers + (OXCF.ts_number_layers - 1);
        if OXCF.layer_target_bitrate[layer] > 0 {
            num_spatial_layers_nonzero_rate += 1;
        }
        sl += 1;
    }
    if num_spatial_layers_nonzero_rate == 1 {
        SVC_.single_layer_svc = 1;
    } else {
        SVC_.single_layer_svc = 0;
    }
}

vp9_update_temporal_layer_framerate :: (CPI: *VP9_COMP_in_vp9_encoder) {
    SVC_ := *CPI.svc;
    OXCF := *CPI.oxcf;
    LC := get_layer_context(CPI);
    LRC := *LC.rc;

    ST_IDX := SVC_.spatial_layer_id * SVC_.number_temporal_layers + SVC_.temporal_layer_id;
    TL := SVC_.temporal_layer_id;

    LC.framerate = CPI.framerate / OXCF.ts_rate_decimator[TL];
    LRC.avg_frame_bandwidth =
        saturate_cast_double_to_int_in_vp9_svc_layercontext(
            c_transpiler_math_round(LC.target_bandwidth / LC.framerate)
        );
    LRC.max_frame_bandwidth = CPI.rc.max_frame_bandwidth;

    if TL == 0 {
        LC.avg_frame_size = LRC.avg_frame_bandwidth;
    } else {
        PREV_LAYER_FRAMERATE := CPI.framerate / OXCF.ts_rate_decimator[TL - 1];
        PREV_LAYER_TARGET_BANDWIDTH := OXCF.layer_target_bitrate[ST_IDX - 1];
        LC.avg_frame_size =
            cast,no_check(s32) c_transpiler_math_round(
                (LC.target_bandwidth - PREV_LAYER_TARGET_BANDWIDTH) / (LC.framerate - PREV_LAYER_FRAMERATE)
            );
    }
}

get_layer_context :: (CPI: *VP9_COMP_in_vp9_encoder) -> *LAYER_CONTEXT_in_vp9_cx_iface {
    if is_one_pass_svc_in_vp9_svc_layercontext(CPI) != 0 {
        return CPI.svc.layer_context.data + CPI.svc.spatial_layer_id * CPI.svc.number_temporal_layers + CPI.svc.temporal_layer_id;
    } else {
        return ifx CPI.svc.number_temporal_layers > 1 && CPI.oxcf.rc_mode == cast,no_check(u32) CBR then CPI.svc.layer_context.data + CPI.svc.temporal_layer_id else CPI.svc.layer_context.data + CPI.svc.spatial_layer_id;
    }
}

is_one_pass_svc_in_vp9_svc_layercontext :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if CPI.use_svc != 0 && CPI.oxcf.pass == 0 {
        return 1;
    }
    return 0;
}

vp9_update_spatial_layer_framerate :: (CPI: *VP9_COMP_in_vp9_encoder, framerate: float64) {
    OXCF := *CPI.oxcf;
    LC := get_layer_context(CPI);
    LRC := *LC.rc;

    LC.framerate = framerate;
    LRC.avg_frame_bandwidth =
        saturate_cast_double_to_int_in_vp9_svc_layercontext(
            c_transpiler_math_round(LC.target_bandwidth / LC.framerate)
        );
    VBR_MIN_BITS := ((cast,no_check(s64) LRC.avg_frame_bandwidth) * cast(s64) OXCF.two_pass_vbrmin_section) / 100;
    LRC.min_frame_bandwidth = cast,no_check(s32) ((ifx VBR_MIN_BITS < 2147483647 then VBR_MIN_BITS else 2147483647));
    VBR_MAX_BITS := ((cast,no_check(s64) LRC.avg_frame_bandwidth) * cast(s64) OXCF.two_pass_vbrmax_section) / 100;
    LRC.max_frame_bandwidth = cast,no_check(s32) ((ifx VBR_MAX_BITS < 2147483647 then VBR_MAX_BITS else 2147483647));
    vp9_rc_set_gf_interval_range(CPI, LRC);
}

vp9_restore_layer_context :: (CPI: *VP9_COMP_in_vp9_encoder) {
    LC := get_layer_context(CPI);
    OLD_FRAME_SINCE_KEY := CPI.rc.frames_since_key;
    OLD_FRAME_TO_KEY := CPI.rc.frames_to_key;
    OLD_EXT_USE_POST_ENCODE_DROP := CPI.rc.ext_use_post_encode_drop;

    assignment_0: RATE_CONTROL = LC.rc;
    ((*CPI.rc).*) = assignment_0;
    assignment_1: TWO_PASS = LC.twopass;
    ((*CPI.twopass).*) = assignment_1;
    CPI.oxcf.target_bandwidth = cast,no_check(s64) LC.target_bandwidth;
    CPI.alt_ref_source = LC.alt_ref_source;

    if is_one_pass_svc_in_vp9_svc_layercontext(CPI) != 0 && LC.speed > 0 {
        CPI.oxcf.speed = cast,no_check(s32) LC.speed;
    }
    CPI.loopfilter_ctrl = cast,no_check(LOOPFILTER_CONTROL) LC.loopfilter_ctrl;

    if CPI.svc.number_temporal_layers > 1 || CPI.svc.number_spatial_layers > 1 {
        CPI.rc.frames_since_key = OLD_FRAME_SINCE_KEY;
        CPI.rc.frames_to_key = OLD_FRAME_TO_KEY;
    }
    CPI.rc.ext_use_post_encode_drop = OLD_EXT_USE_POST_ENCODE_DROP;

    if CPI.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ &&
        CPI.svc.number_spatial_layers > 1 &&
        CPI.svc.temporal_layer_id == 0 {
        CR := CPI.cyclic_refresh;
        swap_ptr(cast(*void) *CR.map, cast(*void) *LC.map);
        swap_ptr(cast(*void) *CR.last_coded_q_map, cast(*void) *LC.last_coded_q_map);
        swap_ptr(cast(*void) *CPI.consec_zero_mv, cast(*void) *LC.consec_zero_mv);
        CR.sb_index = LC.sb_index;
        CR.actual_num_seg1_blocks = LC.actual_num_seg1_blocks;
        CR.actual_num_seg2_blocks = LC.actual_num_seg2_blocks;
        CR.counter_encode_maxq_scene_change = LC.counter_encode_maxq_scene_change;
    }
}

swap_ptr :: (a: *void, b: *void) {
    a_p := cast(**void) a;
    b_p := cast(**void) b;
    c := a_p.*;
    a_p.* = b_p.*;
    b_p.* = c;
}

vp9_save_layer_context :: (CPI: *VP9_COMP_in_vp9_encoder) {
    OXCF := *CPI.oxcf;
    LC := get_layer_context(CPI);

    assignment_2: RATE_CONTROL = CPI.rc;
    ((*LC.rc).*) = assignment_2;
    assignment_3: TWO_PASS = CPI.twopass;
    ((*LC.twopass).*) = assignment_3;
    LC.target_bandwidth = cast,no_check(s32) OXCF.target_bandwidth;
    LC.alt_ref_source = CPI.alt_ref_source;
    LC.frame_qp = CPI.common.base_qindex;
    LC.m_bs = CPI.common.m_bs;

    if CPI.oxcf.aq_mode == cast,no_check(u32) CYCLIC_REFRESH_AQ &&
        CPI.svc.number_spatial_layers > 1 &&
        CPI.svc.temporal_layer_id == 0 {
        CR := CPI.cyclic_refresh;
        temp := LC.map;
        temp2 := LC.last_coded_q_map;
        temp3 := LC.consec_zero_mv;
        LC.map = CR.map;
        CR.map = temp;
        LC.last_coded_q_map = CR.last_coded_q_map;
        CR.last_coded_q_map = temp2;
        LC.consec_zero_mv = CPI.consec_zero_mv;
        CPI.consec_zero_mv = temp3;
        LC.sb_index = CR.sb_index;
        LC.actual_num_seg1_blocks = CR.actual_num_seg1_blocks;
        LC.actual_num_seg2_blocks = CR.actual_num_seg2_blocks;
        LC.counter_encode_maxq_scene_change = CR.counter_encode_maxq_scene_change;
        LC.qindex_delta[0] = CR.qindex_delta[0];
        LC.qindex_delta[1] = CR.qindex_delta[1];
        LC.qindex_delta[2] = CR.qindex_delta[2];
    }
}

vp9_init_second_pass_spatial_svc :: (cpi: *VP9_COMP_in_vp9_encoder) {
    SVC_ := *cpi.svc;

    i: s32 = 0;
    while i < SVC_.number_spatial_layers {
        TWOPASS := *SVC_.layer_context[i].twopass;

        SVC_.spatial_layer_id = i;
        vp9_init_second_pass(cpi);

        TWOPASS.total_stats.spatial_layer_id = cast,no_check(s64) i;
        TWOPASS.total_left_stats.spatial_layer_id = cast,no_check(s64) i;
        i += 1;
    }
    SVC_.spatial_layer_id = 0;
}

get_layer_resolution :: (WIDTH_ORG: s32, HEIGHT_ORG: s32, NUM: s32, DEN: s32, width_out: *s32, height_out: *s32) {
    if width_out == null || height_out == null {
        return;
    }

    if DEN == 0 || NUM == 0 {
        width_out.* = WIDTH_ORG;
        height_out.* = HEIGHT_ORG;
        return;
    }

    w := cast,no_check(s32) (((cast,no_check(s64) WIDTH_ORG) * cast(s64) NUM) / cast(s64) DEN);
    h := cast,no_check(s32) (((cast,no_check(s64) HEIGHT_ORG) * cast(s64) NUM) / cast(s64) DEN);

    w += w % 2;
    h += h % 2;

    width_out.* = w;
    height_out.* = h;
}

vp9_inc_frame_in_layer :: (CPI: *VP9_COMP_in_vp9_encoder) {
    LC := CPI.svc.layer_context.data + CPI.svc.spatial_layer_id * CPI.svc.number_temporal_layers;
    LC.current_video_frame_in_layer += 1;
    LC.frames_from_key_frame += 1;
    if CPI.svc.spatial_layer_id == CPI.svc.number_spatial_layers - 1 {
        CPI.svc.current_superframe += 1;
    }
}

vp9_svc_lookahead_pop :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    ctx: *Lookahead_Ctx_in_vp9_lookahead,
    drain: s32
) -> *Lookahead_Entry_in_vp9_lookahead {
    buf: *Lookahead_Entry_in_vp9_lookahead = null;
    if ctx.sz != 0 && (drain != 0 || ctx.sz == ctx.max_sz - 1) {
        buf = vp9_lookahead_peek(ctx, 0);
        if buf != null {
            if CPI.svc.spatial_layer_id == CPI.svc.number_spatial_layers - 1 {
                vp9_lookahead_pop(ctx, drain);
            }
        }
    }
    return buf;
}

vp9_copy_flags_ref_update_idx :: (CPI: *VP9_COMP_in_vp9_encoder) {
    SVC_ := *CPI.svc;
    sl := SVC_.spatial_layer_id;
    SVC_.lst_fb_idx[sl] = CPI.lst_fb_idx;
    SVC_.gld_fb_idx[sl] = CPI.gld_fb_idx;
    SVC_.alt_fb_idx[sl] = CPI.alt_fb_idx;

    if SVC_.temporal_layering_mode != cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_BYPASS {
        for ref: 0..cast(s32) ((cast(s32) 1) << 3) - 1 {
            SVC_.update_buffer_slot[sl] &= ~((cast(s32) 1) << ((ref) & 31));
            if ref == SVC_.lst_fb_idx[sl] && CPI.refresh_last_frame != 0 ||
                ref == SVC_.gld_fb_idx[sl] && CPI.refresh_golden_frame != 0 ||
                ref == SVC_.alt_fb_idx[sl] && CPI.refresh_alt_ref_frame != 0 {
                SVC_.update_buffer_slot[sl] |= (cast(s32) 1) << ((ref) & 31);
            }
        }
    }

    SVC_.update_last[sl] = cast,no_check(u8) CPI.refresh_last_frame;
    SVC_.update_golden[sl] = cast,no_check(u8) CPI.refresh_golden_frame;
    SVC_.update_altref[sl] = cast,no_check(u8) CPI.refresh_alt_ref_frame;

    SVC_.reference_last[sl] = cast,no_check(u8) (CPI.ref_frame_flags & cast,no_check(s32) (VP9_LAST_FLAG));
    SVC_.reference_golden[sl] = cast,no_check(u8) (CPI.ref_frame_flags & cast,no_check(s32) (VP9_GOLD_FLAG));
    SVC_.reference_altref[sl] = cast,no_check(u8) (CPI.ref_frame_flags & cast,no_check(s32) (VP9_ALT_FLAG));
}

vp9_one_pass_svc_start_layer :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    width: s32 = 0;
    height: s32 = 0;
    SVC_ := *CPI.svc;
    lc: *LAYER_CONTEXT_in_vp9_cx_iface = null;
    scaling_factor_num: s32 = 1;
    scaling_factor_den: s32 = 1;
    SVC_.skip_enhancement_layer = 0;

    if SVC_.disable_inter_layer_pred == cast,no_check(u32) INTER_LAYER_PRED_OFF &&
        SVC_.number_spatial_layers > 1 &&
        SVC_.number_spatial_layers <= 3 &&
        SVC_.number_temporal_layers <= 3 {
        SVC_.simulcast_mode = 1;
    } else {
        SVC_.simulcast_mode = 0;
    }

    if SVC_.number_spatial_layers > 1 {
        SVC_.use_base_mv = 1;
        SVC_.use_partition_reuse = 1;
    }
    SVC_.force_zero_mode_spatial_ref = 1;

    if SVC_.spatial_layer_to_encode == SVC_.first_spatial_layer_to_encode {
        sl: s32 = 0;
        while sl < SVC_.number_spatial_layers {
            SVC_.force_drop_constrained_from_above[sl] = 0;
            sl += 1;
        }
        if SVC_.framedrop_mode == cast,no_check(u32) CONSTRAINED_FROM_ABOVE_DROP {
            sl = SVC_.number_spatial_layers - 1;
            while sl >= SVC_.first_spatial_layer_to_encode {
                layer := sl * SVC_.number_temporal_layers + SVC_.temporal_layer_id;
                SL_LC := SVC_.layer_context.data + layer;
                assignment_4: RATE_CONTROL = SL_LC.rc;
                ((*CPI.rc).*) = assignment_4;
                CPI.oxcf.target_bandwidth = cast,no_check(s64) SL_LC.target_bandwidth;
                if vp9_test_drop(CPI) != 0 {
                    sl2 := sl;
                    while sl2 >= SVC_.first_spatial_layer_to_encode {
                        SVC_.force_drop_constrained_from_above[sl2] = 1;
                        sl2 -= 1;
                    }
                    break;
                }
                sl -= 1;
            }
        }
    }

    if SVC_.temporal_layering_mode == cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_0212 {
        set_flags_and_fb_idx_for_temporal_mode3(CPI);
    } else if SVC_.temporal_layering_mode == cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_NOLAYERING {
        set_flags_and_fb_idx_for_temporal_mode_no_layering(CPI);
    } else if SVC_.temporal_layering_mode == cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_0101 {
        set_flags_and_fb_idx_for_temporal_mode2(CPI);
    } else if SVC_.temporal_layering_mode == cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_BYPASS &&
        SVC_.use_set_ref_frame_config != 0 {
        set_flags_and_fb_idx_bypass_via_set_ref_frame_config(CPI);
    }

    if CPI.lst_fb_idx == SVC_.buffer_gf_temporal_ref[0].idx ||
        CPI.gld_fb_idx == SVC_.buffer_gf_temporal_ref[0].idx ||
        CPI.alt_fb_idx == SVC_.buffer_gf_temporal_ref[0].idx {
        SVC_.buffer_gf_temporal_ref[0].is_used = 1;
    }
    if CPI.lst_fb_idx == SVC_.buffer_gf_temporal_ref[1].idx ||
        CPI.gld_fb_idx == SVC_.buffer_gf_temporal_ref[1].idx ||
        CPI.alt_fb_idx == SVC_.buffer_gf_temporal_ref[1].idx {
        SVC_.buffer_gf_temporal_ref[1].is_used = 1;
    }

    SVC_.use_gf_temporal_ref_current_layer = 0;
    if SVC_.use_gf_temporal_ref != 0 &&
        SVC_.buffer_gf_temporal_ref[0].is_used == 0 &&
        SVC_.buffer_gf_temporal_ref[1].is_used == 0 &&
        SVC_.temporal_layering_mode != cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_BYPASS &&
        SVC_.disable_inter_layer_pred != cast,no_check(u32) INTER_LAYER_PRED_ON &&
        SVC_.number_spatial_layers <= 3 &&
        SVC_.number_temporal_layers <= 3 &&
        SVC_.spatial_layer_id >= SVC_.number_spatial_layers - 2 {
        SVC_.use_gf_temporal_ref_current_layer = 1;
    }

    if SVC_.spatial_layer_id == 0 {
        sl: s32 = 0;

        SVC_.superframe_has_layer_sync = 0;
        sl = 0;
        while sl < SVC_.number_spatial_layers {
            if CPI.svc.spatial_layer_sync[sl] != 0 {
                SVC_.superframe_has_layer_sync = 1;
            }
            sl += 1;
        }
    }

    if SVC_.spatial_layer_id == SVC_.first_spatial_layer_to_encode {
        fill_memory(*SVC_.drop_spatial_layer, 0, SVC_.drop_spatial_layer.count * size_of(s32));

        if SVC_.temporal_layering_mode != cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_BYPASS {
            fill_memory(*SVC_.lst_fb_idx, -1, SVC_.lst_fb_idx.count * size_of(s32));
            fill_memory(*SVC_.gld_fb_idx, -1, SVC_.lst_fb_idx.count * size_of(s32));
            fill_memory(*SVC_.alt_fb_idx, -1, SVC_.lst_fb_idx.count * size_of(s32));

            fill_memory(*SVC_.update_buffer_slot, 0, SVC_.update_buffer_slot.count * size_of(s32));
            fill_memory(*SVC_.reference_last, 0, SVC_.reference_last.count);
            fill_memory(*SVC_.reference_golden, 0, SVC_.reference_golden.count);
            fill_memory(*SVC_.reference_altref, 0, SVC_.reference_altref.count);

            fill_memory(*SVC_.update_last, 0, SVC_.update_last.count);
            fill_memory(*SVC_.update_golden, 0, SVC_.update_golden.count);
            fill_memory(*SVC_.update_altref, 0, SVC_.update_altref.count);
        }
    }

    lc = SVC_.layer_context.data + SVC_.spatial_layer_id * SVC_.number_temporal_layers + SVC_.temporal_layer_id;

    if SVC_.temporal_layering_mode != cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_BYPASS ||
        SVC_.use_set_ref_frame_config != 0 {
        LRC := *lc.rc;
        LRC.worst_quality = vp9_quantizer_to_qindex(lc.max_q);
        LRC.best_quality = vp9_quantizer_to_qindex(lc.min_q);
        if CPI.fixed_qp_onepass != 0 {
            LRC.worst_quality = CPI.rc.worst_quality;
            LRC.best_quality = CPI.rc.best_quality;
        }
    }

    if CPI.oxcf.resize_mode == cast,no_check(u32) RESIZE_DYNAMIC &&
        SVC_.single_layer_svc == 1 &&
        SVC_.spatial_layer_id == SVC_.first_spatial_layer_to_encode &&
        CPI.resize_state != cast,no_check(u32) ORIG {
        scaling_factor_num = lc.scaling_factor_num_resize;
        scaling_factor_den = lc.scaling_factor_den_resize;
    } else {
        scaling_factor_num = lc.scaling_factor_num;
        scaling_factor_den = lc.scaling_factor_den;
    }

    get_layer_resolution(CPI.oxcf.width, CPI.oxcf.height, scaling_factor_num, scaling_factor_den, *width, *height);

    if width * height <= 320 * 240 {
        SVC_.downsample_filter_type[SVC_.spatial_layer_id] = 1;
    }

    if cast,no_check(s64) scaling_factor_num > (3 * cast(s64) scaling_factor_den) >> 2 {
        SVC_.downsample_filter_phase[SVC_.spatial_layer_id] = 0;
    }

    if SVC_.number_spatial_layers > 1 {
        sl: s32 = 0;
        while sl < SVC_.number_spatial_layers - 1 {
            lc = SVC_.layer_context.data + sl * SVC_.number_temporal_layers + SVC_.temporal_layer_id;
            if lc.scaling_factor_num != lc.scaling_factor_den >> 1 &&
                !(lc.scaling_factor_num == lc.scaling_factor_den >> 2 && sl == 0 && SVC_.number_spatial_layers == 3) {
                SVC_.use_base_mv = 0;
                SVC_.use_partition_reuse = 0;
                break;
            }
            sl += 1;
        }

        if SVC_.spatial_layer_id > 0 && SVC_.drop_spatial_layer[SVC_.spatial_layer_id - 1] != 0 {
            SVC_.use_base_mv = 0;
            SVC_.use_partition_reuse = 0;
        }
    }

    SVC_.non_reference_frame = 0;
    if CPI.common.frame_type != cast,no_check(u32) KEY_FRAME &&
        CPI.ext_refresh_last_frame == 0 &&
        CPI.ext_refresh_golden_frame == 0 &&
        CPI.ext_refresh_alt_ref_frame == 0 {
        SVC_.non_reference_frame = 1;
    }

    if SVC_.temporal_layering_mode == cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_BYPASS {
        if SVC_.update_buffer_slot[SVC_.spatial_layer_id] != 0 {
            SVC_.non_reference_frame = 0;
        }
    }

    if SVC_.spatial_layer_id == 0 {
        SVC_.high_source_sad_superframe = 0;
        SVC_.high_num_blocks_with_motion = 0;
    }

    if SVC_.temporal_layering_mode != cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_BYPASS &&
        SVC_.last_layer_dropped[SVC_.spatial_layer_id] != 0 &&
        SVC_.fb_idx_upd_tl0[SVC_.spatial_layer_id] != -1 &&
        SVC_.layer_context[SVC_.temporal_layer_id].is_key_frame == 0 {
        CPI.lst_fb_idx = SVC_.fb_idx_upd_tl0[SVC_.spatial_layer_id];
    }

    if vp9_set_size_literal(CPI, cast,no_check(u32) width, cast,no_check(u32) height) != 0 {
        return CODEC_INVALID_PARAM;
    }

    SVC_.mi_stride[SVC_.spatial_layer_id] = CPI.common.mi_stride;
    SVC_.mi_rows[SVC_.spatial_layer_id] = CPI.common.mi_rows;
    SVC_.mi_cols[SVC_.spatial_layer_id] = CPI.common.mi_cols;
    return 0;
}

set_flags_and_fb_idx_bypass_via_set_ref_frame_config :: (CPI: *VP9_COMP_in_vp9_encoder) {
    SVC_ := *CPI.svc;
    SVC_.spatial_layer_id = SVC_.spatial_layer_to_encode;
    sl := SVC_.spatial_layer_id;
    CPI.svc.temporal_layer_id = CPI.svc.temporal_layer_id_per_spatial[sl];
    CPI.ext_refresh_frame_flags_pending = 1;
    CPI.lst_fb_idx = SVC_.lst_fb_idx[sl];
    CPI.gld_fb_idx = SVC_.gld_fb_idx[sl];
    CPI.alt_fb_idx = SVC_.alt_fb_idx[sl];
    CPI.ext_refresh_last_frame = 0;
    CPI.ext_refresh_golden_frame = 0;
    CPI.ext_refresh_alt_ref_frame = 0;
    CPI.ref_frame_flags = 0;
    if SVC_.reference_last[sl] != 0 {
        CPI.ref_frame_flags |= cast,no_check(s32) (VP9_LAST_FLAG);
    }
    if SVC_.reference_golden[sl] != 0 {
        CPI.ref_frame_flags |= cast,no_check(s32) (VP9_GOLD_FLAG);
    }
    if SVC_.reference_altref[sl] != 0 {
        CPI.ref_frame_flags |= cast,no_check(s32) (VP9_ALT_FLAG);
    }
}

set_flags_and_fb_idx_for_temporal_mode2 :: (CPI: *VP9_COMP_in_vp9_encoder) {
    spatial_id, temporal_id: s32 = ---;
    CPI.svc.spatial_layer_id = CPI.svc.spatial_layer_to_encode;
    spatial_id = CPI.svc.spatial_layer_id;
    CPI.svc.temporal_layer_id =
        cast,no_check(s32) (CPI.svc.layer_context[CPI.svc.spatial_layer_id *
            CPI.svc.number_temporal_layers].current_video_frame_in_layer & 1);
    temporal_id = CPI.svc.temporal_layer_id;
    CPI.ext_refresh_alt_ref_frame = 0;
    CPI.ext_refresh_golden_frame = CPI.ext_refresh_alt_ref_frame;
    CPI.ext_refresh_last_frame = CPI.ext_refresh_golden_frame;
    if temporal_id == 0 {
        CPI.ext_refresh_frame_flags_pending = 1;
        CPI.ext_refresh_last_frame = 1;
        if spatial_id == 0 {
            CPI.ref_frame_flags = cast,no_check(s32) (VP9_LAST_FLAG);
        } else if CPI.svc.layer_context[temporal_id].is_key_frame != 0 {
            CPI.ref_frame_flags = cast,no_check(s32) (VP9_LAST_FLAG);
            CPI.ext_refresh_last_frame = 0;
            CPI.ext_refresh_golden_frame = 1;
        } else {
            CPI.ref_frame_flags = (cast,no_check(s32) (VP9_LAST_FLAG)) | cast,no_check(s32) (VP9_GOLD_FLAG);
        }
    } else if temporal_id == 1 {
        CPI.ext_refresh_frame_flags_pending = 1;
        CPI.ext_refresh_alt_ref_frame = 1;
        if spatial_id == 0 {
            CPI.ref_frame_flags = cast,no_check(s32) (VP9_LAST_FLAG);
        } else {
            if spatial_id == CPI.svc.number_spatial_layers - 1 {
                CPI.ext_refresh_alt_ref_frame = 0;
            }
            CPI.ref_frame_flags = (cast,no_check(s32) (VP9_LAST_FLAG)) | cast,no_check(s32) (VP9_GOLD_FLAG);
        }
    }

    if temporal_id == 0 {
        CPI.lst_fb_idx = spatial_id;
        if spatial_id != 0 {
            if CPI.svc.layer_context[temporal_id].is_key_frame != 0 {
                CPI.lst_fb_idx = spatial_id - 1;
                CPI.gld_fb_idx = spatial_id;
            } else {
                CPI.gld_fb_idx = spatial_id - 1;
            }
        } else {
            CPI.gld_fb_idx = 0;
        }
        CPI.alt_fb_idx = 0;
    } else if temporal_id == 1 {
        CPI.lst_fb_idx = spatial_id;
        CPI.gld_fb_idx = CPI.svc.number_spatial_layers + spatial_id - 1;
        CPI.alt_fb_idx = CPI.svc.number_spatial_layers + spatial_id;
    }

    if CPI.svc.simulcast_mode != 0 {
        non_reference_frame_simulcast(CPI);
    }

    reset_fb_idx_unused(CPI);
}

reset_fb_idx_unused :: (CPI: *VP9_COMP_in_vp9_encoder) {
    first_ref: MV_REFERENCE_FRAME = 0;
    first_fb_idx: s32 = 0;
    fb_idx := s32.[ CPI.lst_fb_idx, CPI.gld_fb_idx, CPI.alt_fb_idx ];
    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame <= 3 {
        if CPI.ref_frame_flags & ref_frame_to_flag_in_vp9_svc_layercontext(ref_frame) != 0 {
            first_ref = ref_frame;
            first_fb_idx = fb_idx[(cast(s32) ref_frame) - 1];
            break;
        }
        ref_frame += 1;
    }
    if first_ref > 0 {
        if first_ref != 1 && CPI.ref_frame_flags & cast,no_check(s32) (VP9_LAST_FLAG) == 0 && CPI.ext_refresh_last_frame == 0 {
            CPI.lst_fb_idx = first_fb_idx;
        } else if first_ref != 2 && CPI.ref_frame_flags & cast,no_check(s32) (VP9_GOLD_FLAG) == 0 && CPI.ext_refresh_golden_frame == 0 {
            CPI.gld_fb_idx = first_fb_idx;
        } else if first_ref != 3 && CPI.ref_frame_flags & cast,no_check(s32) (VP9_ALT_FLAG) == 0 && CPI.ext_refresh_alt_ref_frame == 0 {
            CPI.alt_fb_idx = first_fb_idx;
        }
    }
}

ref_frame_to_flag_in_vp9_svc_layercontext :: (ref_frame: s8) -> s32 {

    return K_VP9_REF_FLAG_LIST_in_vp9_svc_layercontext[ref_frame];
}

non_reference_frame_simulcast :: (CPI: *VP9_COMP_in_vp9_encoder) {
    if CPI.svc.temporal_layer_id == CPI.svc.number_temporal_layers - 1 && CPI.svc.temporal_layer_id > 0 {
        CPI.ext_refresh_last_frame = 0;
        CPI.ext_refresh_golden_frame = 0;
        CPI.ext_refresh_alt_ref_frame = 0;
    }
}

set_flags_and_fb_idx_for_temporal_mode_no_layering :: (CPI: *VP9_COMP_in_vp9_encoder) {
    spatial_id: s32 = ---;
    CPI.svc.spatial_layer_id = CPI.svc.spatial_layer_to_encode;
    spatial_id = CPI.svc.spatial_layer_id;
    CPI.ext_refresh_alt_ref_frame = 0;
    CPI.ext_refresh_golden_frame = CPI.ext_refresh_alt_ref_frame;
    CPI.ext_refresh_last_frame = CPI.ext_refresh_golden_frame;
    CPI.ext_refresh_frame_flags_pending = 1;
    CPI.ext_refresh_last_frame = 1;
    if spatial_id == 0 {
        CPI.ref_frame_flags = cast,no_check(s32) (VP9_LAST_FLAG);
    } else if CPI.svc.layer_context[0].is_key_frame != 0 {
        CPI.ref_frame_flags = cast,no_check(s32) (VP9_LAST_FLAG);
        CPI.ext_refresh_last_frame = 0;
        CPI.ext_refresh_golden_frame = 1;
    } else {
        CPI.ref_frame_flags = (cast,no_check(s32) (VP9_LAST_FLAG)) | cast,no_check(s32) (VP9_GOLD_FLAG);
    }
    CPI.lst_fb_idx = spatial_id;
    if spatial_id != 0 {
        if CPI.svc.layer_context[0].is_key_frame != 0 {
            CPI.lst_fb_idx = spatial_id - 1;
            CPI.gld_fb_idx = spatial_id;
        } else {
            CPI.gld_fb_idx = spatial_id - 1;
        }
    } else {
        CPI.gld_fb_idx = 0;
    }

    if CPI.svc.simulcast_mode != 0 {
        non_reference_frame_simulcast(CPI);
    }

    reset_fb_idx_unused(CPI);
}

set_flags_and_fb_idx_for_temporal_mode3 :: (CPI: *VP9_COMP_in_vp9_encoder) {
    frame_num_within_temporal_struct: s32 = 0;
    spatial_id, temporal_id: s32 = ---;
    CPI.svc.spatial_layer_id = CPI.svc.spatial_layer_to_encode;
    spatial_id = CPI.svc.spatial_layer_id;
    frame_num_within_temporal_struct =
        cast,no_check(s32) (CPI.svc.layer_context[CPI.svc.spatial_layer_id * CPI.svc.number_temporal_layers].current_video_frame_in_layer %
            4);
    CPI.svc.temporal_layer_id =
        (ifx frame_num_within_temporal_struct & 1 != 0 then 2 else frame_num_within_temporal_struct >> 1);
    temporal_id = CPI.svc.temporal_layer_id;
    CPI.ext_refresh_alt_ref_frame = 0;
    CPI.ext_refresh_golden_frame = CPI.ext_refresh_alt_ref_frame;
    CPI.ext_refresh_last_frame = CPI.ext_refresh_golden_frame;
    if temporal_id == 0 {
        CPI.ext_refresh_frame_flags_pending = 1;
        CPI.ext_refresh_last_frame = 1;
        if spatial_id == 0 {
            CPI.ref_frame_flags = cast,no_check(s32) (VP9_LAST_FLAG);
        } else if CPI.svc.layer_context[temporal_id].is_key_frame != 0 {
            CPI.ref_frame_flags = cast,no_check(s32) (VP9_LAST_FLAG);
            CPI.ext_refresh_last_frame = 0;
            CPI.ext_refresh_golden_frame = 1;
        } else {
            CPI.ref_frame_flags = (cast,no_check(s32) (VP9_LAST_FLAG)) | cast,no_check(s32) (VP9_GOLD_FLAG);
        }
    } else if temporal_id == 1 {
        CPI.ext_refresh_frame_flags_pending = 1;
        CPI.ext_refresh_alt_ref_frame = 1;
        if spatial_id == 0 {
            CPI.ref_frame_flags = cast,no_check(s32) (VP9_LAST_FLAG);
        } else {
            CPI.ref_frame_flags = (cast,no_check(s32) (VP9_LAST_FLAG)) | cast,no_check(s32) (VP9_GOLD_FLAG);
        }
    } else if frame_num_within_temporal_struct == 1 {
        if spatial_id == CPI.svc.number_spatial_layers - 1 {
            CPI.ext_refresh_frame_flags_pending = 1;
            if spatial_id == 0 {
                CPI.ref_frame_flags = cast,no_check(s32) (VP9_LAST_FLAG);
            } else {
                CPI.ref_frame_flags = (cast,no_check(s32) (VP9_LAST_FLAG)) | cast,no_check(s32) (VP9_GOLD_FLAG);
            }
        } else if spatial_id == 0 {
            CPI.ext_refresh_frame_flags_pending = 1;
            CPI.ext_refresh_alt_ref_frame = 1;
            CPI.ref_frame_flags = cast,no_check(s32) (VP9_LAST_FLAG);
        } else if spatial_id < CPI.svc.number_spatial_layers - 1 {
            CPI.ext_refresh_frame_flags_pending = 1;
            CPI.ext_refresh_alt_ref_frame = 1;
            CPI.ref_frame_flags = (cast,no_check(s32) (VP9_LAST_FLAG)) | cast,no_check(s32) (VP9_GOLD_FLAG);
        }
    } else if spatial_id == CPI.svc.number_spatial_layers - 1 {
        CPI.ext_refresh_frame_flags_pending = 1;
        if spatial_id == 0 {
            CPI.ref_frame_flags = cast,no_check(s32) (VP9_LAST_FLAG);
        } else {
            CPI.ref_frame_flags = (cast,no_check(s32) (VP9_LAST_FLAG)) | cast,no_check(s32) (VP9_GOLD_FLAG);
        }
    } else if spatial_id == 0 {
        CPI.ext_refresh_frame_flags_pending = 1;
        CPI.ref_frame_flags = cast,no_check(s32) (VP9_LAST_FLAG);
        CPI.ext_refresh_alt_ref_frame = 1;
    } else {
        CPI.ext_refresh_frame_flags_pending = 1;
        CPI.ref_frame_flags = (cast,no_check(s32) (VP9_LAST_FLAG)) | cast,no_check(s32) (VP9_GOLD_FLAG);
        CPI.ext_refresh_alt_ref_frame = 1;
    }
    if temporal_id == 0 {
        CPI.lst_fb_idx = spatial_id;
        if spatial_id != 0 {
            if CPI.svc.layer_context[temporal_id].is_key_frame != 0 {
                CPI.lst_fb_idx = spatial_id - 1;
                CPI.gld_fb_idx = spatial_id;
            } else {
                CPI.gld_fb_idx = spatial_id - 1;
            }
        } else {
            CPI.gld_fb_idx = 0;
        }
        CPI.alt_fb_idx = 0;
    } else if temporal_id == 1 {
        CPI.lst_fb_idx = spatial_id;
        CPI.gld_fb_idx = CPI.svc.number_spatial_layers + spatial_id - 1;
        CPI.alt_fb_idx = CPI.svc.number_spatial_layers + spatial_id;
    } else if frame_num_within_temporal_struct == 1 {
        CPI.lst_fb_idx = spatial_id;
        CPI.gld_fb_idx = CPI.svc.number_spatial_layers + spatial_id - 1;
        CPI.alt_fb_idx = CPI.svc.number_spatial_layers + spatial_id;
    } else {
        CPI.lst_fb_idx = CPI.svc.number_spatial_layers + spatial_id;
        CPI.gld_fb_idx = CPI.svc.number_spatial_layers + spatial_id - 1;
        CPI.alt_fb_idx = CPI.svc.number_spatial_layers + spatial_id;
    }

    if CPI.svc.simulcast_mode != 0 {
        non_reference_frame_simulcast(CPI);
    }

    reset_fb_idx_unused(CPI);
}

vp9_free_svc_cyclic_refresh :: (CPI: *VP9_COMP_in_vp9_encoder) {
    tl: s32 = ---;
    SVC_ := *CPI.svc;
    OXCF := *CPI.oxcf;
    sl: s32 = 0;
    while sl < OXCF.ss_number_layers {
        tl = 0;
        while tl < OXCF.ts_number_layers {
            layer := sl * OXCF.ts_number_layers + tl;
            LC := SVC_.layer_context.data + layer;
            if LC.map != null {
                deallocate_memory(cast(*void) LC.map);
            }
            if LC.last_coded_q_map != null {
                deallocate_memory(cast(*void) LC.last_coded_q_map);
            }
            if LC.consec_zero_mv != null {
                deallocate_memory(cast(*void) LC.consec_zero_mv);
            }
            tl += 1;
        }
        sl += 1;
    }
}

vp9_svc_reset_temporal_layers :: (CPI: *VP9_COMP_in_vp9_encoder, is_key: s32) {
    tl: s32 = ---;
    SVC_ := *CPI.svc;
    lc: *LAYER_CONTEXT_in_vp9_cx_iface = null;
    sl: s32 = 0;
    while sl < SVC_.number_spatial_layers {
        tl = 0;
        while tl < SVC_.number_temporal_layers {
            lc = CPI.svc.layer_context.data + sl * SVC_.number_temporal_layers + tl;
            lc.current_video_frame_in_layer = 0;
            if is_key != 0 {
                lc.frames_from_key_frame = 0;
            }
            tl += 1;
        }
        sl += 1;
    }
    if SVC_.temporal_layering_mode == cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_0212 {
        set_flags_and_fb_idx_for_temporal_mode3(CPI);
    } else if SVC_.temporal_layering_mode == cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_NOLAYERING {
        set_flags_and_fb_idx_for_temporal_mode_no_layering(CPI);
    } else if SVC_.temporal_layering_mode == cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_0101 {
        set_flags_and_fb_idx_for_temporal_mode2(CPI);
    }
    vp9_update_temporal_layer_framerate(CPI);
    vp9_restore_layer_context(CPI);
}

vp9_svc_check_reset_layer_rc_flag :: (CPI: *VP9_COMP_in_vp9_encoder) {
    svc := *CPI.svc;
    tl: s32 = ---;
    sl: s32 = 0;
    while sl < svc.number_spatial_layers {
        SPATIAL_LAYER_IDX := sl * svc.number_temporal_layers + (svc.number_temporal_layers - 1);
        lc := svc.layer_context.data + SPATIAL_LAYER_IDX;
        lrc := *lc.rc;
        if lrc.avg_frame_bandwidth / 3 > lrc.last_avg_frame_bandwidth >> 1 ||
            lrc.avg_frame_bandwidth < lrc.last_avg_frame_bandwidth >> 1 {
            tl = 0;
            while tl < svc.number_temporal_layers {
                temporal_layer_idx := sl * svc.number_temporal_layers + tl;
                lrc = *svc.layer_context[temporal_layer_idx].rc;
                lrc.rc_1_frame = 0;
                lrc.rc_2_frame = 0;
                lrc.bits_off_target = lrc.optimal_buffer_level;
                lrc.buffer_level = lrc.optimal_buffer_level;
                tl += 1;
            }
        }
        sl += 1;
    }
}

vp9_svc_constrain_inter_layer_pred :: (CPI: *VP9_COMP_in_vp9_encoder) {
    CM := *CPI.common;
    SVC_ := *CPI.svc;
    SL := SVC_.spatial_layer_id;

    if SVC_.disable_inter_layer_pred == cast,no_check(u32) INTER_LAYER_PRED_OFF_NONKEY &&
        SVC_.layer_context[SVC_.temporal_layer_id].is_key_frame == 0 &&
        SVC_.superframe_has_layer_sync == 0 ||
        SVC_.disable_inter_layer_pred == cast,no_check(u32) INTER_LAYER_PRED_OFF ||
        SVC_.drop_spatial_layer[SL - 1] != 0 {
        ref_frame: MV_REFERENCE_FRAME = 1;
        while ref_frame <= 3 {
            yv12 := get_ref_frame_buffer_in_vp9_svc_layercontext(CPI, ref_frame);
            if yv12 != null && CPI.ref_frame_flags & ref_frame_to_flag_in_vp9_svc_layercontext(ref_frame) != 0 {
                SCALE_FAC := *CM.frame_refs[(cast(s32) ref_frame) - 1].sf;
                if vp9_is_scaled_in_vp9_svc_layercontext(SCALE_FAC) != 0 {
                    CPI.ref_frame_flags &= ~(ref_frame_to_flag_in_vp9_svc_layercontext(ref_frame));

                    if SVC_.simulcast_mode == 0 {
                        if ref_frame == 2 {
                            CPI.gld_fb_idx = CPI.lst_fb_idx;
                        } else if ref_frame == 3 {
                            CPI.alt_fb_idx = CPI.lst_fb_idx;
                        }
                    }
                }
            }
            ref_frame += 1;
        }
    }

    if SVC_.temporal_layering_mode != cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_BYPASS &&
        SVC_.disable_inter_layer_pred != cast,no_check(u32) INTER_LAYER_PRED_OFF {
        ref_frame: MV_REFERENCE_FRAME = 1;
        while ref_frame <= 2 {
            scale_fac := *CM.frame_refs[(cast(s32) ref_frame) - 1].sf;
            if vp9_is_scaled_in_vp9_svc_layercontext(scale_fac) != 0 {
                fb_idx := (ifx ref_frame == 1 then CPI.lst_fb_idx else CPI.gld_fb_idx);
                ref_flag :=
                    (ifx ref_frame == 1 then cast,no_check(s32) (VP9_LAST_FLAG) else cast,no_check(s32) (VP9_GOLD_FLAG));
                disable: s32 = 1;
                if fb_idx < 0 {
                    ref_frame += 1;
                    continue;
                }
                if fb_idx == SVC_.lst_fb_idx[SL - 1] && SVC_.update_buffer_slot[SL - 1] & ((cast(s32) 1) << ((fb_idx) & 31)) != 0 ||
                    fb_idx == SVC_.gld_fb_idx[SL - 1] && SVC_.update_buffer_slot[SL - 1] & ((cast(s32) 1) << ((fb_idx) & 31)) != 0 ||
                    fb_idx == SVC_.alt_fb_idx[SL - 1] && SVC_.update_buffer_slot[SL - 1] & ((cast(s32) 1) << ((fb_idx) & 31)) != 0 {
                    disable = 0;
                }
                if disable != 0 {
                    CPI.ref_frame_flags &= ~(ref_flag);
                }
            }
            ref_frame += 1;
        }
    }
}

get_ref_frame_buffer_in_vp9_svc_layercontext :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    ref_frame: MV_REFERENCE_FRAME
) -> *YV12_BUFFER_CONFIG {
    CM := *CPI.common;
    BUF_IDX := get_ref_frame_buf_idx_in_vp9_svc_layercontext(CPI, cast,no_check(s32) ref_frame);
    return ifx BUF_IDX != -1 then *CM.buffer_pool.frame_bufs[BUF_IDX].buf else null;
}

get_ref_frame_buf_idx_in_vp9_svc_layercontext :: (CPI: *VP9_COMP_in_vp9_encoder, ref_frame: s32) -> s32 {
    CM := *CPI.common;
    MAP_IDX := get_ref_frame_map_idx_in_vp9_svc_layercontext(CPI, cast,no_check(MV_REFERENCE_FRAME) ref_frame);
    return ifx MAP_IDX != -1 then CM.ref_frame_map[MAP_IDX] else -1;
}

get_ref_frame_map_idx_in_vp9_svc_layercontext :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame: MV_REFERENCE_FRAME) -> s32 {
    if ref_frame == 1 {
        return cpi.lst_fb_idx;
    } else if ref_frame == 2 {
        return cpi.gld_fb_idx;
    } else {
        return cpi.alt_fb_idx;
    }
}

vp9_svc_assert_constraints_pattern :: (CPI: *VP9_COMP_in_vp9_encoder) {
    SVC_ := *CPI.svc;

    if SVC_.temporal_layering_mode != cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_BYPASS &&
        SVC_.disable_inter_layer_pred == cast,no_check(u32) INTER_LAYER_PRED_ON &&
        SVC_.framedrop_mode != cast,no_check(u32) LAYER_DROP {
        if SVC_.layer_context[SVC_.temporal_layer_id].is_key_frame == 0 {
            if SVC_.temporal_layer_id == 0 {
            } else {
            }
            if SVC_.spatial_layer_id > 0 &&
                CPI.ref_frame_flags & cast,no_check(s32) (VP9_GOLD_FLAG) != 0 &&
                SVC_.spatial_layer_id > SVC_.first_spatial_layer_to_encode {
            }
        } else if SVC_.spatial_layer_id > 0 && SVC_.spatial_layer_id > SVC_.first_spatial_layer_to_encode {
            if CPI.ref_frame_flags & cast,no_check(s32) (VP9_LAST_FLAG) != 0 {
            } else if CPI.ref_frame_flags & cast,no_check(s32) (VP9_GOLD_FLAG) != 0 {
            }
        }
    } else if SVC_.use_gf_temporal_ref_current_layer != 0 && SVC_.layer_context[SVC_.temporal_layer_id].is_key_frame == 0 {
        if cast,no_check(s32) SVC_.fb_idx_spatial_layer_id[CPI.gld_fb_idx] != SVC_.spatial_layer_id ||
            SVC_.fb_idx_temporal_layer_id[CPI.gld_fb_idx] != 0 {
            SVC_.use_gf_temporal_ref_current_layer = 0;
        }
    }
}

vp9_svc_check_spatial_layer_sync :: (CPI: *VP9_COMP_in_vp9_encoder) {
    SVC_ := *CPI.svc;

    if SVC_.layer_context[SVC_.temporal_layer_id].is_key_frame == 0 {
        if SVC_.spatial_layer_id == 0 {
            if SVC_.superframe_has_layer_sync != 0 {
                vp9_svc_reset_temporal_layers(CPI, cast(s32) (CPI.common.frame_type == cast,no_check(u32) KEY_FRAME));
            }
        }

        if SVC_.spatial_layer_id > 0 && SVC_.spatial_layer_sync[SVC_.spatial_layer_id] != 0 {
            CPI.ref_frame_flags &= cast,no_check(s32) (~(VP9_LAST_FLAG));
            if SVC_.use_gf_temporal_ref_current_layer != 0 {
                index := SVC_.spatial_layer_id;

                SVC_.use_gf_temporal_ref_current_layer = 0;
                CPI.rc.baseline_gf_interval = 0;
                CPI.rc.frames_till_gf_update_due = 0;

                if SVC_.number_spatial_layers == 3 {
                    index = SVC_.spatial_layer_id - 1;
                }

                CPI.alt_fb_idx = SVC_.buffer_gf_temporal_ref[index].idx;
                CPI.ext_refresh_alt_ref_frame = 1;
            }
        }
    }
}

vp9_svc_update_ref_frame_buffer_idx :: (CPI: *VP9_COMP_in_vp9_encoder) {
    SVC_ := *CPI.svc;
    i: s32 = 0;

    if SVC_.spatial_layer_id == 0 {
        if CPI.ref_frame_flags & cast,no_check(s32) (VP9_LAST_FLAG) != 0 || CPI.refresh_last_frame != 0 {
            SVC_.fb_idx_base[CPI.lst_fb_idx] = 1;
        }
        if CPI.ref_frame_flags & cast,no_check(s32) (VP9_GOLD_FLAG) != 0 || CPI.refresh_golden_frame != 0 {
            SVC_.fb_idx_base[CPI.gld_fb_idx] = 1;
        }
        if CPI.ref_frame_flags & cast,no_check(s32) (VP9_ALT_FLAG) != 0 || CPI.refresh_alt_ref_frame != 0 {
            SVC_.fb_idx_base[CPI.alt_fb_idx] = 1;
        }

        if SVC_.temporal_layering_mode == cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_BYPASS {
            i = 0;
            while i < (cast(s32) 1) << 3 {
                if SVC_.update_buffer_slot[0] & ((cast(s32) 1) << ((i) & 31)) != 0 {
                    SVC_.fb_idx_base[i] = 1;
                }
                i += 1;
            }
        }
    }
}

vp9_svc_update_ref_frame :: (CPI: *VP9_COMP_in_vp9_encoder) {
    CM := *CPI.common;
    SVC_ := *CPI.svc;
    POOL := CM.buffer_pool;

    if SVC_.temporal_layering_mode == cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_BYPASS &&
        SVC_.use_set_ref_frame_config != 0 {
        vp9_svc_update_ref_frame_bypass_mode(CPI);
    } else if CM.frame_type == cast,no_check(u32) KEY_FRAME && SVC_.simulcast_mode == 0 {
        for i: 0..cast(s32) ((cast(s32) 1) << 3) - 1 {
            SVC_.fb_idx_spatial_layer_id[i] = cast,no_check(u8) SVC_.spatial_layer_id;
            SVC_.fb_idx_temporal_layer_id[i] = cast,no_check(u8) SVC_.temporal_layer_id;

            if i != CPI.lst_fb_idx && i != CPI.gld_fb_idx && i != CPI.alt_fb_idx {
                ref_cnt_fb_in_vp9_svc_layercontext(POOL.frame_bufs.data, CM.ref_frame_map.data + i, CM.new_fb_idx);
            }
        }
    } else {
        if CPI.refresh_last_frame != 0 {
            SVC_.fb_idx_spatial_layer_id[CPI.lst_fb_idx] = cast,no_check(u8) SVC_.spatial_layer_id;
            SVC_.fb_idx_temporal_layer_id[CPI.lst_fb_idx] = cast,no_check(u8) SVC_.temporal_layer_id;
        }
        if CPI.refresh_golden_frame != 0 {
            SVC_.fb_idx_spatial_layer_id[CPI.gld_fb_idx] = cast,no_check(u8) SVC_.spatial_layer_id;
            SVC_.fb_idx_temporal_layer_id[CPI.gld_fb_idx] = cast,no_check(u8) SVC_.temporal_layer_id;
        }
        if CPI.refresh_alt_ref_frame != 0 {
            SVC_.fb_idx_spatial_layer_id[CPI.alt_fb_idx] = cast,no_check(u8) SVC_.spatial_layer_id;
            SVC_.fb_idx_temporal_layer_id[CPI.alt_fb_idx] = cast,no_check(u8) SVC_.temporal_layer_id;
        }
    }

    vp9_copy_flags_ref_update_idx(CPI);
    vp9_svc_update_ref_frame_buffer_idx(CPI);
}

vp9_svc_update_ref_frame_bypass_mode :: (CPI: *VP9_COMP_in_vp9_encoder) {
    SVC_ := *CPI.svc;
    CM := *CPI.common;
    POOL := CM.buffer_pool;

    for i: 0..cast(s32) ((cast(s32) 1) << 3) - 1 {
        if CM.frame_type == cast,no_check(u32) KEY_FRAME && SVC_.simulcast_mode == 0 ||
            SVC_.update_buffer_slot[SVC_.spatial_layer_id] & ((cast(s32) 1) << ((i) & 31)) != 0 {
            ref_cnt_fb_in_vp9_svc_layercontext(POOL.frame_bufs.data, CM.ref_frame_map.data + i, CM.new_fb_idx);
            SVC_.fb_idx_spatial_layer_id[i] = cast,no_check(u8) SVC_.spatial_layer_id;
            SVC_.fb_idx_temporal_layer_id[i] = cast,no_check(u8) SVC_.temporal_layer_id;
        }
    }
}

vp9_svc_adjust_frame_rate :: (CPI: *VP9_COMP_in_vp9_encoder) {
    this_duration := CPI.svc.timebase_fac * CPI.svc.duration[CPI.svc.spatial_layer_id];
    vp9_new_framerate(CPI, 10000000.0 / cast,no_check(float64) this_duration);
}

vp9_svc_adjust_avg_frame_qindex :: (CPI: *VP9_COMP_in_vp9_encoder) {
    CM := *CPI.common;
    SVC_ := *CPI.svc;
    RC := *CPI.rc;

    if CM.frame_type == cast,no_check(u32) KEY_FRAME &&
        CPI.oxcf.rc_mode == cast,no_check(u32) CBR &&
        SVC_.simulcast_mode == 0 &&
        RC.projected_frame_size / 3 > RC.avg_frame_bandwidth {
        RC.avg_frame_qindex[INTER_FRAME] =
            ifx RC.avg_frame_qindex[INTER_FRAME] > (CM.base_qindex +
                RC.worst_quality) >> 1 then RC.avg_frame_qindex[INTER_FRAME] else (CM.base_qindex + RC.worst_quality) >> 1;
        tl: s32 = 0;
        while tl < SVC_.number_temporal_layers {
            LAYER := 0 * SVC_.number_temporal_layers + tl;
            lc := SVC_.layer_context.data + LAYER;
            lrc := *lc.rc;
            lrc.avg_frame_qindex[INTER_FRAME] = RC.avg_frame_qindex[INTER_FRAME];
            tl += 1;
        }
    }
}

vp9_svc_check_skip_enhancement_layer :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if CPI.use_svc != 0 &&
        CPI.svc.spatial_layer_id > 0 &&
        CPI.oxcf.target_bandwidth == 0 &&
        !(CPI.svc.framedrop_mode != cast,no_check(u32) LAYER_DROP && (CPI.svc.framedrop_mode != cast,no_check(u32) CONSTRAINED_FROM_ABOVE_DROP || CPI.svc.force_drop_constrained_from_above[CPI.svc.number_spatial_layers - 1] != 0) && CPI.svc.drop_spatial_layer[0] != 0) {
        CPI.svc.skip_enhancement_layer = 1;
        vp9_rc_postencode_update_drop_frame(CPI);
        CPI.ext_refresh_frame_flags_pending = 0;
        CPI.last_frame_dropped = 1;
        CPI.svc.last_layer_dropped[CPI.svc.spatial_layer_id] = 1;
        CPI.svc.drop_spatial_layer[CPI.svc.spatial_layer_id] = 1;
        vp9_inc_frame_in_layer(CPI);
        return 1;
    }
    return 0;
}

write_in_vp9_svc_layercontext :: (br: *Writer, bit: s32, probability: s32) {
    count := br.count;
    range := br.range;
    lowvalue := br.lowvalue;

    split := 1 + ((range - 1) * cast,no_check(u32) probability) >> 8;

    range = split;

    if bit != 0 {
        lowvalue += split;
        range = br.range - split;
    }

    shift := cast,no_check(s32) NORM[range];

    c_transpiler_compound_shl(*(range), (((cast,no_check(u32) shift) & 31)), u32, u32);
    count += shift;

    if count >= 0 {
        offset := shift - count;

        if br.error == 0 {
            if lowvalue << (((offset - 1)) & 31) & 0x80000000 != 0 {
                x := (cast,no_check(s32) br.pos) - 1;

                while x >= 0 && br.buffer[x] == 0xff {
                    br.buffer[x] = 0;
                    x -= 1;
                }

                br.buffer[x] = cast,no_check(u8) ((cast,no_check(s32) br.buffer[x]) + 1);
            }

            if br.pos < br.size {
                br.buffer[br.pos] = cast,no_check(u8) (lowvalue >> (((24 - offset)) & 31) & 0xff);
                br.pos += 1;
            } else {
                br.error = 1;
            }
        }
        c_transpiler_compound_shl(*(lowvalue), (((cast,no_check(u32) offset) & 31)), u32, u32);
        shift = count;
        lowvalue &= 0xffffff;
        count -= 8;
    }

    c_transpiler_compound_shl(*(lowvalue), (((cast,no_check(u32) shift) & 31)), u32, u32);
    br.count = count;
    br.lowvalue = lowvalue;
    br.range = range;
}

write_bit_in_vp9_svc_layercontext :: (w: *Writer, bit: s32) {
    write_in_vp9_svc_layercontext(w, bit, 128);
}

write_literal_in_vp9_svc_layercontext :: (w: *Writer, data: s32, bits: s32) {
    bit := bits - 1;
    while bit >= 0 {
        write_bit_in_vp9_svc_layercontext(w, 1 & (data >> ((bit) & 31)));
        bit -= 1;
    }
}

vp9_write_tree_in_vp9_svc_layercontext :: (
    w: *Writer,
    tree: *Tree_Index,
    probs: *Prob,
    bits: s32,
    len: s32,
    i: Tree_Index
) {
    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            write_in_vp9_svc_layercontext(w, BIT, cast,no_check(s32) probs[(cast(s32) i) >> 1]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }
}

vp9_write_token_in_vp9_svc_layercontext :: (w: *Writer, tree: *Tree_Index, probs: *Prob, token: *Vp9_Token) {
    vp9_write_tree_in_vp9_svc_layercontext(w, tree, probs, token.value, token.len, 0);
}

vp9_get_high_cost_table_in_vp9_svc_layercontext :: (bit_depth: s32) -> *u16 {
    return VP9_CAT6_HIGH_COST.data;
}

vp9_get_token_extra_in_vp9_svc_layercontext :: (v: s32, token: *s16, extra: *EXTRABIT) {
    if v >= 67 || v <= -67 {
        token.* = 10;
        if v >= 67 {
            extra.* = cast,no_check(EXTRABIT) (2 * v - cast,no_check(s32) ((2 * 67)));
        } else {
            extra.* = cast,no_check(EXTRABIT) ((-2 * v - cast,no_check(s32) ((2 * 67))) + 1);
        }
        return;
    }
    token.* = vp9_dct_cat_lt_10_value_tokens[v].token;
    extra.* = vp9_dct_cat_lt_10_value_tokens[v].extra;
}

vp9_get_token_in_vp9_svc_layercontext :: (v: s32) -> s16 {
    if v >= 67 || v <= -67 {
        return 10;
    }
    return vp9_dct_cat_lt_10_value_tokens[v].token;
}

vp9_get_token_cost_in_vp9_svc_layercontext :: (v: s32, token: *s16, cat6_high_table: *u16) -> s32 {
    if v >= 67 || v <= -67 {
        token.* = 10;
        extrabits := cast,no_check(EXTRABIT) (absolute_value(v) - 67);
        return (cast(s32) VP9_CAT6_LOW_COST[extrabits & 0xff]) + cast(s32) cat6_high_table[(cast(s32) extrabits) >> 8];
    }
    token.* = vp9_dct_cat_lt_10_value_tokens[v].token;
    return vp9_dct_cat_lt_10_value_cost[v];
}

is_lossless_requested_in_vp9_svc_layercontext :: (cfg: *VP9_Encoder_Config) -> s32 {
    if cfg.best_allowed_q == 0 && cfg.worst_allowed_q == 0 {
        return 1;
    }
    return 0;
}

stack_pop_in_vp9_svc_layercontext :: (stack: *s32, stack_size: s32) -> s32 {
    R := stack[0];
    if 1 < stack_size {
        for idx: 1..stack_size - 1 {
            stack[idx - 1] = stack[idx];
        }
    }

    return R;
}

stack_top_in_vp9_svc_layercontext :: (stack: *s32) -> s32 {
    return stack[0];
}

stack_push_in_vp9_svc_layercontext :: (stack: *s32, new_item: s32, stack_size: s32) {
    idx := stack_size;
    while idx > 0 {
        stack[idx] = stack[idx - 1];
        idx -= 1;
    }
    stack[0] = new_item;
}

stack_init_in_vp9_svc_layercontext :: (stack: *s32, length: s32) {
    if 0 < length {
        for idx: 0..length - 1 {
            stack[idx] = -1;
        }
    }
}

frame_is_kf_gf_arf_in_vp9_svc_layercontext :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if frame_is_intra_only_in_vp9_svc_layercontext(*cpi.common) != 0 ||
        cpi.refresh_alt_ref_frame != 0 ||
        cpi.refresh_golden_frame != 0 && cpi.rc.is_src_frame_alt_ref == 0 {
        return 1;
    }
    return 0;
}

get_ref_cnt_buffer_in_vp9_svc_layercontext :: (cm: *VP9_COMMON, fb_idx: s32) -> *Ref_Cnt_Buffer {
    return ifx fb_idx != -1 then cm.buffer_pool.frame_bufs.data + fb_idx else null;
}

get_ref_frame_bufs_in_vp9_svc_layercontext :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame_bufs: **Ref_Cnt_Buffer) {
    CM := *cpi.common;

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame < 4 {
        ref_frame_buf_idx := get_ref_frame_buf_idx_in_vp9_svc_layercontext(cpi, cast,no_check(s32) ref_frame);
        inter_ref_idx := mv_ref_frame_to_inter_ref_idx_in_vp9_svc_layercontext(ref_frame);
        ref_frame_bufs[inter_ref_idx] = get_ref_cnt_buffer_in_vp9_svc_layercontext(CM, ref_frame_buf_idx);
        ref_frame += 1;
    }
}

get_token_alloc_in_vp9_svc_layercontext :: (mb_rows: s32, mb_cols: s32) -> s64 {
    ALIGNED_MB_ROWS :=
        (mb_rows +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    ALIGNED_MB_COLS :=
        (mb_cols +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    return ((cast,no_check(s64) ALIGNED_MB_ROWS) * cast(s64) ALIGNED_MB_COLS) * cast,no_check(s64) ((cast,no_check(s32) ((16 * 16))) * 3 + 4);
}

allocated_tokens_in_vp9_svc_layercontext :: (tile: Tile_Info) -> s64 {
    tile_mb_rows := (tile.mi_row_end - tile.mi_row_start + 1) >> 1;
    tile_mb_cols := (tile.mi_col_end - tile.mi_col_start + 1) >> 1;

    return get_token_alloc_in_vp9_svc_layercontext(tile_mb_rows, tile_mb_cols);
}

get_start_tok_in_vp9_svc_layercontext :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    tile_row: s32,
    tile_col: s32,
    mi_row: s32,
    tok: **TOKENEXTRA_in_vp9_cx_iface
) {
    CM := *cpi.common;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    this_tile := *cpi.tile_data[tile_row * TILE_COLS + tile_col];
    TILE_INFO := *this_tile.tile_info;

    tile_mb_cols := (TILE_INFO.mi_col_end - TILE_INFO.mi_col_start + 1) >> 1;
    MB_ROW := (mi_row - TILE_INFO.mi_row_start) >> 1;

    tok.* = cpi.tile_tok[tile_row][tile_col] + get_token_alloc_in_vp9_svc_layercontext(MB_ROW, tile_mb_cols);
}

is_altref_enabled_in_vp9_svc_layercontext :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if !(CPI.oxcf.mode == cast,no_check(u32) REALTIME && CPI.oxcf.rc_mode == cast,no_check(u32) CBR) &&
        CPI.oxcf.lag_in_frames >= 4 &&
        CPI.oxcf.enable_auto_arf != 0 {
        return 1;
    }
    return 0;
}

set_ref_ptrs_in_vp9_svc_layercontext :: (
    CM: *VP9_COMMON,
    xd: *MACROBLOCKD,
    ref0: MV_REFERENCE_FRAME,
    ref1: MV_REFERENCE_FRAME
) {
    xd.block_refs[0] = CM.frame_refs.data + (ifx ref0 >= 1 then (cast(s32) ref0) - 1 else 0);
    xd.block_refs[1] = CM.frame_refs.data + (ifx ref1 >= 1 then (cast(s32) ref1) - 1 else 0);
}

get_chessboard_index_in_vp9_svc_layercontext :: (FRAME_INDEX: s32) -> s32 {
    return FRAME_INDEX & 0x1;
}

cond_cost_list_in_vp9_svc_layercontext :: (cpi: *VP9_COMP_in_vp9_encoder, cost_list: *s32) -> *s32 {
    return ifx cpi.sf.mv.subpel_search_method != cast,no_check(u32) SUBPEL_TREE then cost_list else null;
}

get_num_vert_units_in_vp9_svc_layercontext :: (tile: Tile_Info, shift: s32) -> s32 {
    num_vert_units := (tile.mi_row_end - tile.mi_row_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_vert_units;
}

get_num_cols_in_vp9_svc_layercontext :: (tile: Tile_Info, shift: s32) -> s32 {
    num_cols := (tile.mi_col_end - tile.mi_col_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_cols;
}

get_level_index_in_vp9_svc_layercontext :: (level: VP9_LEVEL) -> s32 {
    for i: 0..cast(s32) 14 - 1 {
        if level == VP9_LEVEL_DEFS[i].level {
            return i;
        }
    }
    return -1;
}

log_tile_cols_from_picsize_level_in_vp9_svc_layercontext :: (width: u32, height: u32) -> s32 {
    PIC_SIZE := width * height;
    PIC_BREADTH := max(width, height);
    for i: 0..cast(s32) 14 - 1 {
        if VP9_LEVEL_DEFS[i].max_luma_picture_size >= PIC_SIZE && VP9_LEVEL_DEFS[i].max_luma_picture_breadth >= PIC_BREADTH {
            return get_msb_in_vp9_svc_layercontext(cast,no_check(u32) VP9_LEVEL_DEFS[i].max_col_tiles);
        }
    }
    return 2147483647;
}

alloc_frame_mvs_in_vp9_svc_layercontext :: (CM: *VP9_COMMON, buffer_idx: s32) {
    NEW_FB_PTR := CM.buffer_pool.frame_bufs.data + buffer_idx;
    if NEW_FB_PTR.mvs == null || NEW_FB_PTR.mi_rows < CM.mi_rows || NEW_FB_PTR.mi_cols < CM.mi_cols {
        deallocate_memory(cast(*void) NEW_FB_PTR.mvs);
        NEW_FB_PTR.mvs =
            cast(*MV_REF) calloc_2(
                cast,no_check(u64) (CM.mi_rows * CM.mi_cols),
                size_of(MV_REF)
            );

        if NEW_FB_PTR.mvs == null {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate new_fb_ptr->mvs")
            );
        }
        NEW_FB_PTR.mi_rows = CM.mi_rows;
        NEW_FB_PTR.mi_cols = CM.mi_cols;
    }
}

mv_cost_in_vp9_svc_layercontext :: (mv: *MV, joint_cost: *s32, comp_cost: **s32) -> s32 {
    return joint_cost[vp9_get_mv_joint_in_vp9_svc_layercontext(mv)] + comp_cost[0][mv.row] + comp_cost[1][mv.col];
}

mvsad_err_cost_in_vp9_svc_layercontext :: (x: *MACROBLOCK, mv: *MV, ref: *MV, sad_per_bit: s32) -> s32 {
    diff: MV = ---;
    diff.row = cast,no_check(s16) ((cast(s32) mv.row) - cast(s32) ref.row);
    diff.col = cast,no_check(s16) ((cast(s32) mv.col) - cast(s32) ref.col);
    return cast,no_check(s32) ((((cast,no_check(u32) mv_cost_in_vp9_svc_layercontext(*diff, x.nmvjointsadcost.data, x.nmvsadcost.data)) * cast,no_check(u32) sad_per_bit) + cast,no_check(u32) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9);
}

get_start_mv_sad_in_vp9_svc_layercontext :: (
    x: *MACROBLOCK,
    mvp_full: *MV,
    ref_mv_full: *MV,
    sad_fn_ptr: Sad_Fn_T,
    sadpb: s32
) -> u32 {
    SRC_BUF_STRIDE := x.plane[0].src.stride;
    SRC_BUF := x.plane[0].src.buf;
    XD := *x.e_mbd;
    PRED_BUF_STRIDE := XD.plane[0].pre[0].stride;
    PRED_BUF := XD.plane[0].pre[0].buf + (cast(s32) mvp_full.row) * PRED_BUF_STRIDE + cast,no_check(s32) mvp_full.col;
    start_mv_sad: u32 = sad_fn_ptr(SRC_BUF, SRC_BUF_STRIDE, PRED_BUF, PRED_BUF_STRIDE);
    start_mv_sad += cast,no_check(u32) mvsad_err_cost_in_vp9_svc_layercontext(x, mvp_full, ref_mv_full, sadpb);

    return start_mv_sad;
}

num_4x4_to_edge_in_vp9_svc_layercontext :: (
    plane_4x4_dim: s32,
    mb_to_edge_dim: s32,
    subsampling_dim: s32,
    blk_dim: s32
) -> s32 {
    return plane_4x4_dim + mb_to_edge_dim >> (((5 + subsampling_dim)) & 31) - blk_dim;
}

sum_squares_visible_in_vp9_svc_layercontext :: (
    xd: *MACROBLOCKD,
    PD: *Macroblockd_Plane,
    diff: *s16,
    DIFF_STRIDE: s32,
    blk_row: s32,
    blk_col: s32,
    PLANE_BSIZE: BLOCK_SIZE,
    TX_BSIZE: BLOCK_SIZE,
    visible_width: *s32,
    visible_height: *s32
) -> s64 {
    sse: s64 = ---;
    PLANE_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE];
    PLANE_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE];
    TX_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[TX_BSIZE];
    TX_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[TX_BSIZE];
    B4X4S_TO_RIGHT_EDGE :=
        num_4x4_to_edge_in_vp9_svc_layercontext(
            PLANE_4X4_W,
            xd.mb_to_right_edge,
            PD.subsampling_x,
            blk_col
        );
    B4X4S_TO_BOTTOM_EDGE :=
        num_4x4_to_edge_in_vp9_svc_layercontext(
            PLANE_4X4_H,
            xd.mb_to_bottom_edge,
            PD.subsampling_y,
            blk_row
        );
    if TX_BSIZE == 0 || B4X4S_TO_RIGHT_EDGE >= TX_4X4_W && B4X4S_TO_BOTTOM_EDGE >= TX_4X4_H {
        sse = cast,no_check(s64) sum_squares_2d_i16_c(diff, DIFF_STRIDE, TX_4X4_W << 2);
        visible_width.* = TX_4X4_W << 2;
        visible_height.* = TX_4X4_H << 2;
    } else {
        c: s32 = ---;
        MAX_R := min(B4X4S_TO_BOTTOM_EDGE, TX_4X4_H);
        MAX_C := min(B4X4S_TO_RIGHT_EDGE, TX_4X4_W);
        sse = 0;

        if 0 < MAX_R {
            for r: 0..MAX_R - 1 {
                c = 0;
                while c < MAX_C {
                    sse +=
                        cast,no_check(s64) sum_squares_2d_i16_c(
                            diff + r * DIFF_STRIDE * 4 + c * 4,
                            DIFF_STRIDE,
                            4
                        );
                    c += 1;
                }
            }
        }
        visible_width.* = MAX_C << 2;
        visible_height.* = MAX_R << 2;
    }
    return sse;
}

do_trellis_opt_in_vp9_svc_layercontext :: (
    pd: *Macroblockd_Plane,
    src_diff: *s16,
    diff_stride: s32,
    blk_row: s32,
    blk_col: s32,
    plane_bsize: BLOCK_SIZE,
    tx_size: TX_SIZE,
    arg: *void
) -> s32 {
    ARGS := cast(*Encode_B_Args) arg;
    X := ARGS.x;

    if ARGS.enable_trellis_opt == {
        case DISABLE_TRELLIS_OPT;
            return 0;
        case ENABLE_TRELLIS_OPT;
            return 1;
        case ENABLE_TRELLIS_OPT_TX_RD_SRC_VAR;
            {
                return ifx c_transpiler_float_greater(ARGS.trellis_opt_thresh, 0.0) then cast(s32) (c_transpiler_float_less_equal(X.log_block_src_var, ARGS.trellis_opt_thresh)) else 1;
            }
        case ENABLE_TRELLIS_OPT_TX_RD_RESIDUAL_MSE;
            {
                XD := *X.e_mbd;
                TX_BSIZE := TXSIZE_TO_BSIZE[tx_size];

                DEQUANT_SHIFT: s32 = 3;

                QSTEP := (cast(s32) pd.dequant[1]) >> ((DEQUANT_SHIFT) & 31);
                sse_calc_done := ARGS.sse_calc_done;
                sse := ARGS.sse;
                visible_width: s32 = 0;
                visible_height: s32 = 0;

                if XD.cur_buf.flags & 8 != 0 || sse == null || sse_calc_done == null {
                    return 1;
                }

                sse.* =
                    sum_squares_visible_in_vp9_svc_layercontext(
                        XD,
                        pd,
                        src_diff,
                        diff_stride,
                        blk_row,
                        blk_col,
                        plane_bsize,
                        TX_BSIZE,
                        *visible_width,
                        *visible_height
                    );
                sse_calc_done.* = 1;

                if c_transpiler_float_less_equal(cast,no_check(float64) sse.*, (((((cast,no_check(s64) visible_width) * cast(s64) visible_height) * cast(s64) QSTEP) * cast(s64) QSTEP) * ARGS.trellis_opt_thresh)) {
                    return 1;
                }
                return 0;
            }
        case;
            return 1;
    }
    return unreachable_value(s32);
}

globals_initialization_state_for_vp9_svc_layercontext: u32;
initialize_globals_for_vp9_svc_layercontext :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_svc_layercontext);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_svc_layercontext, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_svc_layercontext) != 2 {}
            return;
        }
    }
    K_VP9_REF_FLAG_LIST_in_vp9_svc_layercontext =
        s32.[ 0, cast,no_check(s32) (VP9_LAST_FLAG), cast,no_check(s32) (VP9_GOLD_FLAG), cast,no_check(s32) (VP9_ALT_FLAG) ];
    COUNT_TO_UPDATE_FACTOR_in_vp9_svc_layercontext =
        s32.[
            0,
            6,
            12,
            19,
            25,
            32,
            38,
            44,
            51,
            57,
            64,
            70,
            76,
            83,
            89,
            96,
            102,
            108,
            115,
            121,
            128
        ];
    SUB_PEL_FILTERS_12_in_vp9_svc_layercontext =
        Interp_Kernel12.[
            s16.[ 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, 0, 0 ],
            s16.[ 0, 1, -2, 3, -7, 127, 8, -4, 2, -1, 1, 0 ],
            s16.[ -1, 2, -3, 6, -13, 124, 18, -8, 4, -2, 2, -1 ],
            s16.[ -1, 3, -4, 8, -18, 120, 28, -12, 7, -4, 2, -1 ],
            s16.[ -1, 3, -6, 10, -21, 115, 38, -15, 8, -5, 3, -1 ],
            s16.[ -2, 4, -6, 12, -24, 108, 49, -18, 10, -6, 3, -2 ],
            s16.[ -2, 4, -7, 13, -25, 100, 60, -21, 11, -7, 4, -2 ],
            s16.[ -2, 4, -7, 13, -26, 91, 71, -24, 13, -7, 4, -2 ],
            s16.[ -2, 4, -7, 13, -25, 81, 81, -25, 13, -7, 4, -2 ],
            s16.[ -2, 4, -7, 13, -24, 71, 91, -26, 13, -7, 4, -2 ],
            s16.[ -2, 4, -7, 11, -21, 60, 100, -25, 13, -7, 4, -2 ],
            s16.[ -2, 3, -6, 10, -18, 49, 108, -24, 12, -6, 4, -2 ],
            s16.[ -1, 3, -5, 8, -15, 38, 115, -21, 10, -6, 3, -1 ],
            s16.[ -1, 2, -4, 7, -12, 28, 120, -18, 8, -4, 3, -1 ],
            s16.[ -1, 2, -2, 4, -8, 18, 124, -13, 6, -3, 2, -1 ],
            s16.[ 0, 1, -1, 2, -4, 8, 127, -7, 3, -2, 1, 0 ]
        ];
    FRAME_SCALE_FACTOR_in_vp9_svc_layercontext = s32.[ 16, 24 ];
    RATE_THRESH_MULT_in_vp9_svc_layercontext = float64.[ 1.0, 2.0 ];
    RCF_MULT_in_vp9_svc_layercontext = float64.[ 1.0, 2.0 ];
    atomic_store(*globals_initialization_state_for_vp9_svc_layercontext, 2);
}

