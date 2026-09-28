// Generated directly from C by cpp_transpiler.
NEXT_CHKPTS: [6] [3] MV_in_alloccommon;

vp8_diamond_search_sad_c :: (
    x: *MACROBLOCK_in_block,
    b: *BLOCK,
    d: *BLOCKD,
    ref_mv: *Int_Mv_in_mv,
    best_mv: *Int_Mv_in_mv,
    search_param: s32,
    sad_per_bit: s32,
    num00: *s32,
    fn_ptr: *Vp8_Variance_Fn_Ptr_T,
    mvcost: **s32,
    center_mv: *Int_Mv_in_mv
) -> s32 {
    j: s32 = ---;

    what := b.base_src.* + b.src;
    what_stride := b.src_stride;

    pre_stride := x.e_mbd.pre.y_stride;
    base_pre: *u8 = x.e_mbd.pre.y_buffer;
    in_what_stride := pre_stride;

    this_mv: Int_Mv_in_mv = ---;

    thissad: u32 = ---;
    best_site: s32 = 0;
    last_site: s32 = 0;

    this_row_offset: s32 = ---;
    this_col_offset: s32 = ---;

    check_here: *u8 = ---;

    mvsadcost: [2] *s32 = ---;
    fcenter_mv: Int_Mv_in_mv = ---;

    mvsadcost[0] = x.mvsadcost[0];
    mvsadcost[1] = x.mvsadcost[1];
    fcenter_mv.as_mv.row = cast,no_check(s16) ((cast(s32) center_mv.as_mv.row) >> 3);
    fcenter_mv.as_mv.col = cast,no_check(s16) ((cast(s32) center_mv.as_mv.col) >> 3);

    vp8_clamp_mv_in_mcomp(ref_mv, x.mv_col_min, x.mv_col_max, x.mv_row_min, x.mv_row_max);
    ref_row := cast,no_check(s32) ref_mv.as_mv.row;
    ref_col := cast,no_check(s32) ref_mv.as_mv.col;
    num00.* = 0;
    best_mv.as_mv.row = cast,no_check(s16) ref_row;
    best_mv.as_mv.col = cast,no_check(s16) ref_col;

    in_what := base_pre + d.offset + ref_row * pre_stride + ref_col;
    best_address := in_what;

    bestsad :=
        fn_ptr.sdf(what, what_stride, in_what, in_what_stride) +
            cast,no_check(u32) mvsad_err_cost(best_mv, *fcenter_mv, mvsadcost.data, sad_per_bit);

    ss := *x.ss[search_param * x.searches_per_step];
    tot_steps := x.ss_count / x.searches_per_step - search_param;

    i: s32 = 1;

    if 0 < tot_steps {
        for step: 0..tot_steps - 1 {
            j = 0;
            while j < x.searches_per_step {
                this_row_offset = (cast(s32) best_mv.as_mv.row) + cast(s32) ss[i].mv.row;
                this_col_offset = (cast(s32) best_mv.as_mv.col) + cast(s32) ss[i].mv.col;

                if this_col_offset > x.mv_col_min &&
                    this_col_offset < x.mv_col_max &&
                    this_row_offset > x.mv_row_min &&
                    this_row_offset < x.mv_row_max {
                    check_here = ss[i].offset + best_address;
                    thissad = fn_ptr.sdf(what, what_stride, check_here, in_what_stride);

                    if thissad < bestsad {
                        this_mv.as_mv.row = cast,no_check(s16) this_row_offset;
                        this_mv.as_mv.col = cast,no_check(s16) this_col_offset;
                        thissad +=
                            cast,no_check(u32) mvsad_err_cost(
                                *this_mv,
                                *fcenter_mv,
                                mvsadcost.data,
                                sad_per_bit
                            );

                        if thissad < bestsad {
                            bestsad = thissad;
                            best_site = i;
                        }
                    }
                }

                i += 1;
                j += 1;
            }

            if best_site != last_site {
                best_mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) best_mv.as_mv.row) + cast,no_check(s32) ss[best_site].mv.row);
                best_mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) best_mv.as_mv.col) + cast,no_check(s32) ss[best_site].mv.col);
                best_address += ss[best_site].offset;
                last_site = best_site;
            } else if best_address == in_what {
                num00.* += 1;
            }
        }
    }

    this_mv.as_mv.row =
        cast,no_check(s16) clamp_in_mcomp(
            (cast(s32) best_mv.as_mv.row) * 8,
            cast,no_check(s32) (-32767 - 1),
            32767
        );
    this_mv.as_mv.col =
        cast,no_check(s16) clamp_in_mcomp(
            (cast(s32) best_mv.as_mv.col) * 8,
            cast,no_check(s32) (-32767 - 1),
            32767
        );

    return cast,no_check(s32) (fn_ptr.vf(what, what_stride, best_address, in_what_stride, *thissad) + cast,no_check(u32) mv_err_cost(*this_mv, center_mv, mvcost, x.errorperbit));
}

mv_err_cost :: (mv: *Int_Mv_in_mv, ref: *Int_Mv_in_mv, mvcost: **s32, error_per_bit: s32) -> s32 {
    if mvcost != null {
        MV_IDX_ROW :=
            clamp_in_mcomp(
                ((cast(s32) mv.as_mv.row) - cast(s32) ref.as_mv.row) >> 1,
                0,
                cast,no_check(s32) (M_VVALS)
            );
        MV_IDX_COL :=
            clamp_in_mcomp(
                ((cast(s32) mv.as_mv.col) - cast(s32) ref.as_mv.col) >> 1,
                0,
                cast,no_check(s32) (M_VVALS)
            );
        return ((mvcost[0][MV_IDX_ROW] + mvcost[1][MV_IDX_COL]) * error_per_bit + 128) >> 8;
    }
    return 0;
}

clamp_in_mcomp :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

mvsad_err_cost :: (mv: *Int_Mv_in_mv, ref: *Int_Mv_in_mv, mvsadcost: **s32, error_per_bit: s32) -> s32 {
    if mvsadcost != null {
        return (((mvsadcost[0][(cast(s32) mv.as_mv.row) - cast(s32) ref.as_mv.row] + mvsadcost[1][(cast(s32) mv.as_mv.col) - cast(s32) ref.as_mv.col]) * error_per_bit) + 128) >> 8;
    }
    return 0;
}

vp8_clamp_mv_in_mcomp :: (
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

vp8_refining_search_sad_c :: (
    x: *MACROBLOCK_in_block,
    b: *BLOCK,
    d: *BLOCKD,
    ref_mv: *Int_Mv_in_mv,
    error_per_bit: s32,
    search_range: s32,
    fn_ptr: *Vp8_Variance_Fn_Ptr_T,
    mvcost: **s32,
    center_mv: *Int_Mv_in_mv
) -> s32 {
    neighbors :=
        MV_in_alloccommon.[
            MV_in_alloccommon.{row = -1, col = 0},
            MV_in_alloccommon.{row = 0, col = -1},
            MV_in_alloccommon.{row = 0, col = 1},
            MV_in_alloccommon.{row = 1, col = 0}
        ];
    j: s32 = ---;
    this_row_offset, this_col_offset: s16 = ---;

    what_stride := b.src_stride;
    pre_stride := x.e_mbd.pre.y_stride;
    base_pre: *u8 = x.e_mbd.pre.y_buffer;
    in_what_stride := pre_stride;
    what := b.base_src.* + b.src;
    best_address :=
        base_pre + d.offset + (cast(s32) ref_mv.as_mv.row) * pre_stride +
            cast,no_check(s32) ref_mv.as_mv.col;
    check_here: *u8 = ---;
    this_mv: Int_Mv_in_mv = ---;

    thissad: u32 = ---;

    mvsadcost: [2] *s32 = ---;
    fcenter_mv: Int_Mv_in_mv = ---;

    mvsadcost[0] = x.mvsadcost[0];
    mvsadcost[1] = x.mvsadcost[1];
    fcenter_mv.as_mv.row = cast,no_check(s16) ((cast(s32) center_mv.as_mv.row) >> 3);
    fcenter_mv.as_mv.col = cast,no_check(s16) ((cast(s32) center_mv.as_mv.col) >> 3);

    bestsad :=
        fn_ptr.sdf(what, what_stride, best_address, in_what_stride) +
            cast,no_check(u32) mvsad_err_cost(ref_mv, *fcenter_mv, mvsadcost.data, error_per_bit);

    if 0 < search_range {
        for i: 0..search_range - 1 {
            best_site: s32 = -1;

            j = 0;
            while j < 4 {
                this_row_offset = cast,no_check(s16) ((cast(s32) ref_mv.as_mv.row) + cast(s32) neighbors[j].row);
                this_col_offset = cast,no_check(s16) ((cast(s32) ref_mv.as_mv.col) + cast(s32) neighbors[j].col);

                if cast,no_check(s32) this_col_offset > x.mv_col_min &&
                    cast,no_check(s32) this_col_offset < x.mv_col_max &&
                    cast,no_check(s32) this_row_offset > x.mv_row_min &&
                    cast,no_check(s32) this_row_offset < x.mv_row_max {
                    check_here =
                        ((cast(s32) neighbors[j].row) * in_what_stride + cast(s32) neighbors[j].col) +
                            best_address;
                    thissad = fn_ptr.sdf(what, what_stride, check_here, in_what_stride);

                    if thissad < bestsad {
                        this_mv.as_mv.row = this_row_offset;
                        this_mv.as_mv.col = this_col_offset;
                        thissad +=
                            cast,no_check(u32) mvsad_err_cost(
                                *this_mv,
                                *fcenter_mv,
                                mvsadcost.data,
                                error_per_bit
                            );

                        if thissad < bestsad {
                            bestsad = thissad;
                            best_site = j;
                        }
                    }
                }
                j += 1;
            }

            if best_site == -1 {
                break;
            } else {
                ref_mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) ref_mv.as_mv.row) + cast,no_check(s32) neighbors[best_site].row);
                ref_mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) ref_mv.as_mv.col) + cast,no_check(s32) neighbors[best_site].col);
                best_address += (cast(s32) neighbors[best_site].row) * in_what_stride + cast(s32) neighbors[best_site].col;
            }
        }
    }

    this_mv.as_mv.row =
        cast,no_check(s16) clamp_in_mcomp(
            (cast(s32) ref_mv.as_mv.row) * 8,
            cast,no_check(s32) (-32767 - 1),
            32767
        );
    this_mv.as_mv.col =
        cast,no_check(s16) clamp_in_mcomp(
            (cast(s32) ref_mv.as_mv.col) * 8,
            cast,no_check(s32) (-32767 - 1),
            32767
        );

    return cast,no_check(s32) (fn_ptr.vf(what, what_stride, best_address, in_what_stride, *thissad) + cast,no_check(u32) mv_err_cost(*this_mv, center_mv, mvcost, x.errorperbit));
}

clip_pixel_in_mcomp :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

fclamp_in_mcomp :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_mcomp :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_mcomp :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_mcomp(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_mcomp(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_mcomp(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_mcomp :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_mcomp :: (FILTER: *s16) -> s32 {
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

vp8_set_reference_value_in_mcomp :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_mcomp :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_mcomp :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_mcomp :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_mcomp :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_mcomp :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_mcomp :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_mcomp :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_mcomp :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_mcomp :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_mcomp :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_mcomp :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_mcomp :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_mcomp :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_mcomp :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_mcomp :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_mcomp :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_mcomp :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_mcomp :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_mcomp :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_mcomp :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_mcomp :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_mcomp :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_mcomp :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

scale2_ratio_in_mcomp :: (mode: s32, hr: *s32, hs: *s32) {
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

validate_buffer_in_mcomp :: (start: *u8, len: u64, end: *u8, error: *Internal_Error_Info) -> s32 {
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

vp8_encode_bool_in_mcomp :: (bc: *BOOL_CODER, bit: s32, probability: s32) {
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

        validate_buffer_in_mcomp(bc.buffer + bc.pos, 1, bc.buffer_end, bc.error);
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

vp8_cost_branch_in_mcomp :: (ct: *u32, p: Vp8_Prob) -> u32 {
    return cast,no_check(u32) ((((cast,no_check(u64) ct[0]) * cast(u64) VP8_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP8_PROB_COST[255 - cast(s32) p]) >> 8);
}

vp8_treed_write_in_mcomp :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) {
    i: Vp8_Tree_Index = 0;

    while true {
        {
            B := v >> ((c_transpiler_pre_decrement(*(n))) & 31) & 1;
            vp8_encode_bool_in_mcomp(W, B, cast,no_check(s32) P[(cast(s32) i) >> 1]);
            i = t[(cast(s32) i) + B];
        }
        if n == 0 break;
    }
}

vp8_write_token_in_mcomp :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) {
    vp8_treed_write_in_mcomp(W, t, P, X.value, X.len);
}

vp8_treed_cost_in_mcomp :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) -> s32 {
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

vp8_cost_token_in_mcomp :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) -> s32 {
    return vp8_treed_cost_in_mcomp(t, P, X.value, X.len);
}

vp8_sem_wait_in_mcomp :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_0: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_0; assignment_0; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init_in_mcomp :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release_in_mcomp :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

atomic_load_acquire_in_mcomp :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_atomic_spin_wait_in_mcomp :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire_in_mcomp(last_row_current_mb_col) - NSYNC {
    }
}

vp8_mv_bit_cost :: (mv: *Int_Mv_in_mv, ref: *Int_Mv_in_mv, mvcost: **s32, weight: s32) -> s32 {
    MV_IDX_ROW :=
        clamp_in_mcomp(
            ((cast(s32) mv.as_mv.row) - cast(s32) ref.as_mv.row) >> 1,
            0,
            cast,no_check(s32) (M_VVALS)
        );
    MV_IDX_COL :=
        clamp_in_mcomp(
            ((cast(s32) mv.as_mv.col) - cast(s32) ref.as_mv.col) >> 1,
            0,
            cast,no_check(s32) (M_VVALS)
        );
    return ((mvcost[0][MV_IDX_ROW] + mvcost[1][MV_IDX_COL]) * weight) >> 7;
}

vp8_init_dsmotion_compensation :: (x: *MACROBLOCK_in_block, stride: s32) {
    search_site_count: s32 = 0;

    len: s32 = (cast(s32) 1) << (((8 - 1)) & 31);
    x.ss[search_site_count].mv.col = 0;
    x.ss[search_site_count].mv.row = 0;
    x.ss[search_site_count].offset = 0;
    search_site_count += 1;

    while len > 0 {
        x.ss[search_site_count].mv.col = 0;
        x.ss[search_site_count].mv.row = cast,no_check(s16) (-len);
        x.ss[search_site_count].offset = -len * stride;
        search_site_count += 1;

        x.ss[search_site_count].mv.col = 0;
        x.ss[search_site_count].mv.row = cast,no_check(s16) len;
        x.ss[search_site_count].offset = len * stride;
        search_site_count += 1;

        x.ss[search_site_count].mv.col = cast,no_check(s16) (-len);
        x.ss[search_site_count].mv.row = 0;
        x.ss[search_site_count].offset = -len;
        search_site_count += 1;

        x.ss[search_site_count].mv.col = cast,no_check(s16) len;
        x.ss[search_site_count].mv.row = 0;
        x.ss[search_site_count].offset = len;
        search_site_count += 1;

        len /= 2;
    }

    x.ss_count = search_site_count;
    x.searches_per_step = 4;
}

vp8_init3smotion_compensation :: (x: *MACROBLOCK_in_block, stride: s32) {
    search_site_count: s32 = 0;

    len: s32 = (cast(s32) 1) << (((8 - 1)) & 31);
    x.ss[search_site_count].mv.col = 0;
    x.ss[search_site_count].mv.row = 0;
    x.ss[search_site_count].offset = 0;
    search_site_count += 1;

    while len > 0 {
        x.ss[search_site_count].mv.col = 0;
        x.ss[search_site_count].mv.row = cast,no_check(s16) (-len);
        x.ss[search_site_count].offset = -len * stride;
        search_site_count += 1;

        x.ss[search_site_count].mv.col = 0;
        x.ss[search_site_count].mv.row = cast,no_check(s16) len;
        x.ss[search_site_count].offset = len * stride;
        search_site_count += 1;

        x.ss[search_site_count].mv.col = cast,no_check(s16) (-len);
        x.ss[search_site_count].mv.row = 0;
        x.ss[search_site_count].offset = -len;
        search_site_count += 1;

        x.ss[search_site_count].mv.col = cast,no_check(s16) len;
        x.ss[search_site_count].mv.row = 0;
        x.ss[search_site_count].offset = len;
        search_site_count += 1;

        x.ss[search_site_count].mv.col = cast,no_check(s16) (-len);
        x.ss[search_site_count].mv.row = cast,no_check(s16) (-len);
        x.ss[search_site_count].offset = -len * stride - len;
        search_site_count += 1;

        x.ss[search_site_count].mv.col = cast,no_check(s16) len;
        x.ss[search_site_count].mv.row = cast,no_check(s16) (-len);
        x.ss[search_site_count].offset = -len * stride + len;
        search_site_count += 1;

        x.ss[search_site_count].mv.col = cast,no_check(s16) (-len);
        x.ss[search_site_count].mv.row = cast,no_check(s16) len;
        x.ss[search_site_count].offset = len * stride - len;
        search_site_count += 1;

        x.ss[search_site_count].mv.col = cast,no_check(s16) len;
        x.ss[search_site_count].mv.row = cast,no_check(s16) len;
        x.ss[search_site_count].offset = len * stride + len;
        search_site_count += 1;

        len /= 2;
    }

    x.ss_count = search_site_count;
    x.searches_per_step = 8;
}

vp8_hex_search :: (
    x: *MACROBLOCK_in_block,
    b: *BLOCK,
    d: *BLOCKD,
    ref_mv: *Int_Mv_in_mv,
    best_mv: *Int_Mv_in_mv,
    search_param: s32,
    sad_per_bit: s32,
    vfp: *Vp8_Variance_Fn_Ptr_T,
    mvsadcost: **s32,
    center_mv: *Int_Mv_in_mv
) -> s32 {
    hex :=
        MV_in_alloccommon.[
            MV_in_alloccommon.{row = -1, col = -2},
            MV_in_alloccommon.{row = 1, col = -2},
            MV_in_alloccommon.{row = 2, col = 0},
            MV_in_alloccommon.{row = 1, col = 2},
            MV_in_alloccommon.{row = -1, col = 2},
            MV_in_alloccommon.{row = -2, col = 0}
        ];
    neighbors :=
        MV_in_alloccommon.[
            MV_in_alloccommon.{row = 0, col = -1},
            MV_in_alloccommon.{row = -1, col = 0},
            MV_in_alloccommon.{row = 1, col = 0},
            MV_in_alloccommon.{row = 0, col = 1}
        ];
    i, j: s32 = ---;
    what := b.base_src.* + b.src;
    what_stride := b.src_stride;
    pre_stride := x.e_mbd.pre.y_stride;
    base_pre: *u8 = x.e_mbd.pre.y_buffer;
    in_what_stride := pre_stride;
    br, bc: s32 = ---;
    this_mv: Int_Mv_in_mv = ---;
    bestsad: u32 = ---;
    thissad: u32 = ---;
    base_offset: *u8 = ---;
    this_offset: *u8 = ---;
    k: s32 = -1;
    all_in: s32 = ---;
    best_site: s32 = -1;
    hex_range: s32 = 127;
    dia_range: s32 = 8;
    fcenter_mv: Int_Mv_in_mv = ---;
    fcenter_mv.as_mv.row = cast,no_check(s16) ((cast(s32) center_mv.as_mv.row) >> 3);
    fcenter_mv.as_mv.col = cast,no_check(s16) ((cast(s32) center_mv.as_mv.col) >> 3);
    vp8_clamp_mv_in_mcomp(ref_mv, x.mv_col_min, x.mv_col_max, x.mv_row_min, x.mv_row_max);
    br = cast,no_check(s32) ref_mv.as_mv.row;
    bc = cast,no_check(s32) ref_mv.as_mv.col;
    base_offset = base_pre + d.offset;
    this_offset = base_offset + br * pre_stride + bc;
    this_mv.as_mv.row = cast,no_check(s16) br;
    this_mv.as_mv.col = cast,no_check(s16) bc;
    bestsad =
        vfp.sdf(what, what_stride, this_offset, in_what_stride) +
            cast,no_check(u32) mvsad_err_cost(*this_mv, *fcenter_mv, mvsadcost, sad_per_bit);
    all_in = 1;

    all_in &= cast(s32) (br - 2 >= x.mv_row_min);

    all_in &= cast(s32) (br + 2 <= x.mv_row_max);

    all_in &= cast(s32) (bc - 2 >= x.mv_col_min);

    all_in &= cast(s32) (bc + 2 <= x.mv_col_max);
    if all_in != 0 {
        i = 0;
        while i < 6 {
            this_mv.as_mv.row = cast,no_check(s16) (br + cast(s32) hex[i].row);
            this_mv.as_mv.col = cast,no_check(s16) (bc + cast(s32) hex[i].col);
            this_offset =
                base_offset + (cast(s32) this_mv.as_mv.row) * in_what_stride +
                    cast,no_check(s32) this_mv.as_mv.col;
            thissad = vfp.sdf(what, what_stride, this_offset, in_what_stride);
            if thissad < bestsad {
                thissad += cast,no_check(u32) mvsad_err_cost(*this_mv, *fcenter_mv, mvsadcost, sad_per_bit);

                if thissad < bestsad {
                    bestsad = thissad;

                    best_site = i;
                }
            }
            i += 1;
        }
    } else {
        i = 0;
        while i < 6 {
            this_mv.as_mv.row = cast,no_check(s16) (br + cast(s32) hex[i].row);
            this_mv.as_mv.col = cast,no_check(s16) (bc + cast(s32) hex[i].col);
            if cast,no_check(s32) this_mv.as_mv.col < x.mv_col_min {
                i += 1;
                continue;
            }

            if cast,no_check(s32) this_mv.as_mv.col > x.mv_col_max {
                i += 1;
                continue;
            }

            if cast,no_check(s32) this_mv.as_mv.row < x.mv_row_min {
                i += 1;
                continue;
            }

            if cast,no_check(s32) this_mv.as_mv.row > x.mv_row_max {
                i += 1;
                continue;
            }
            this_offset =
                base_offset + (cast(s32) this_mv.as_mv.row) * in_what_stride +
                    cast,no_check(s32) this_mv.as_mv.col;
            thissad = vfp.sdf(what, what_stride, this_offset, in_what_stride);
            if thissad < bestsad {
                thissad += cast,no_check(u32) mvsad_err_cost(*this_mv, *fcenter_mv, mvsadcost, sad_per_bit);

                if thissad < bestsad {
                    bestsad = thissad;

                    best_site = i;
                }
            }
            i += 1;
        }
    }
    while cal_neighbors := true { // Forward-goto shim; executes at most once.
        if best_site == -1 {
            break cal_neighbors;
        } else {
            br += cast,no_check(s32) hex[best_site].row;
            bc += cast,no_check(s32) hex[best_site].col;
            k = best_site;
        }
        j = 1;
        while j < hex_range {
            best_site = -1;
            all_in = 1;

            all_in &= cast(s32) (br - 2 >= x.mv_row_min);

            all_in &= cast(s32) (br + 2 <= x.mv_row_max);

            all_in &= cast(s32) (bc - 2 >= x.mv_col_min);

            all_in &= cast(s32) (bc + 2 <= x.mv_col_max);

            if all_in != 0 {
                i = 0;
                while i < 3 {
                    this_mv.as_mv.row = cast,no_check(s16) (br + cast(s32) NEXT_CHKPTS[k][i].row);
                    this_mv.as_mv.col = cast,no_check(s16) (bc + cast(s32) NEXT_CHKPTS[k][i].col);
                    this_offset =
                        base_offset + (cast(s32) this_mv.as_mv.row) * in_what_stride +
                            cast,no_check(s32) this_mv.as_mv.col;
                    thissad = vfp.sdf(what, what_stride, this_offset, in_what_stride);
                    if thissad < bestsad {
                        thissad += cast,no_check(u32) mvsad_err_cost(*this_mv, *fcenter_mv, mvsadcost, sad_per_bit);

                        if thissad < bestsad {
                            bestsad = thissad;

                            best_site = i;
                        }
                    }
                    i += 1;
                }
            } else {
                i = 0;
                while i < 3 {
                    this_mv.as_mv.row = cast,no_check(s16) (br + cast(s32) NEXT_CHKPTS[k][i].row);
                    this_mv.as_mv.col = cast,no_check(s16) (bc + cast(s32) NEXT_CHKPTS[k][i].col);
                    if cast,no_check(s32) this_mv.as_mv.col < x.mv_col_min {
                        i += 1;
                        continue;
                    }

                    if cast,no_check(s32) this_mv.as_mv.col > x.mv_col_max {
                        i += 1;
                        continue;
                    }

                    if cast,no_check(s32) this_mv.as_mv.row < x.mv_row_min {
                        i += 1;
                        continue;
                    }

                    if cast,no_check(s32) this_mv.as_mv.row > x.mv_row_max {
                        i += 1;
                        continue;
                    }
                    this_offset =
                        base_offset + (cast(s32) this_mv.as_mv.row) * in_what_stride +
                            cast,no_check(s32) this_mv.as_mv.col;
                    thissad = vfp.sdf(what, what_stride, this_offset, in_what_stride);
                    if thissad < bestsad {
                        thissad += cast,no_check(u32) mvsad_err_cost(*this_mv, *fcenter_mv, mvsadcost, sad_per_bit);

                        if thissad < bestsad {
                            bestsad = thissad;

                            best_site = i;
                        }
                    }
                    i += 1;
                }
            }

            if best_site == -1 {
                break;
            } else {
                br += cast,no_check(s32) NEXT_CHKPTS[k][best_site].row;
                bc += cast,no_check(s32) NEXT_CHKPTS[k][best_site].col;
                k += 5 + best_site;
                if k >= 12 {
                    k -= 12;
                } else if k >= 6 {
                    k -= 6;
                }
            }
            j += 1;
        }
        break cal_neighbors;
    }
    j = 0;
    while j < dia_range {
        best_site = -1;
        all_in = 1;

        all_in &= cast(s32) (br - 1 >= x.mv_row_min);

        all_in &= cast(s32) (br + 1 <= x.mv_row_max);

        all_in &= cast(s32) (bc - 1 >= x.mv_col_min);

        all_in &= cast(s32) (bc + 1 <= x.mv_col_max);

        if all_in != 0 {
            i = 0;
            while i < 4 {
                this_mv.as_mv.row = cast,no_check(s16) (br + cast(s32) neighbors[i].row);
                this_mv.as_mv.col = cast,no_check(s16) (bc + cast(s32) neighbors[i].col);
                this_offset =
                    base_offset + (cast(s32) this_mv.as_mv.row) * in_what_stride +
                        cast,no_check(s32) this_mv.as_mv.col;
                thissad = vfp.sdf(what, what_stride, this_offset, in_what_stride);
                if thissad < bestsad {
                    thissad += cast,no_check(u32) mvsad_err_cost(*this_mv, *fcenter_mv, mvsadcost, sad_per_bit);

                    if thissad < bestsad {
                        bestsad = thissad;

                        best_site = i;
                    }
                }
                i += 1;
            }
        } else {
            i = 0;
            while i < 4 {
                this_mv.as_mv.row = cast,no_check(s16) (br + cast(s32) neighbors[i].row);
                this_mv.as_mv.col = cast,no_check(s16) (bc + cast(s32) neighbors[i].col);
                if cast,no_check(s32) this_mv.as_mv.col < x.mv_col_min {
                    i += 1;
                    continue;
                }

                if cast,no_check(s32) this_mv.as_mv.col > x.mv_col_max {
                    i += 1;
                    continue;
                }

                if cast,no_check(s32) this_mv.as_mv.row < x.mv_row_min {
                    i += 1;
                    continue;
                }

                if cast,no_check(s32) this_mv.as_mv.row > x.mv_row_max {
                    i += 1;
                    continue;
                }
                this_offset =
                    base_offset + (cast(s32) this_mv.as_mv.row) * in_what_stride +
                        cast,no_check(s32) this_mv.as_mv.col;
                thissad = vfp.sdf(what, what_stride, this_offset, in_what_stride);
                if thissad < bestsad {
                    thissad += cast,no_check(u32) mvsad_err_cost(*this_mv, *fcenter_mv, mvsadcost, sad_per_bit);

                    if thissad < bestsad {
                        bestsad = thissad;

                        best_site = i;
                    }
                }
                i += 1;
            }
        }

        if best_site == -1 {
            break;
        } else {
            br += cast,no_check(s32) neighbors[best_site].row;
            bc += cast,no_check(s32) neighbors[best_site].col;
        }
        j += 1;
    }
    best_mv.as_mv.row = cast,no_check(s16) br;
    best_mv.as_mv.col = cast,no_check(s16) bc;
    return cast,no_check(s32) bestsad;
}

vp8_find_best_sub_pixel_step_iteratively :: (
    x: *MACROBLOCK_in_block,
    b: *BLOCK,
    d: *BLOCKD,
    bestmv: *Int_Mv_in_mv,
    ref_mv: *Int_Mv_in_mv,
    error_per_bit: s32,
    vfp: *Vp8_Variance_Fn_Ptr_T,
    mvcost: **s32,
    distortion: *s32,
    sse1: *u32
) -> s32 {
    z := b.base_src.* + b.src;

    rr := (cast(s32) ref_mv.as_mv.row) >> 1;
    rc := (cast(s32) ref_mv.as_mv.col) >> 1;
    br := (cast(s32) bestmv.as_mv.row) * 4;
    bc := (cast(s32) bestmv.as_mv.col) * 4;
    tr := br;
    tc := bc;

    left, right, up, down, diag: u32 = ---;
    sse: u32 = ---;
    whichdir: u32 = ---;
    halfiters: u32 = 4;
    quarteriters: u32 = 4;
    thismse: s32 = ---;

    minc :=
        (ifx x.mv_col_min * 4 > (cast(s32) ref_mv.as_mv.col) >> 1 -
            ((cast(s32) 1) << ((MVLONG_WIDTH) & 31) - 1) then x.mv_col_min * 4 else (cast(s32) ref_mv.as_mv.col) >> 1 - ((cast(s32) 1) << ((MVLONG_WIDTH) & 31) - 1));
    maxc :=
        (ifx x.mv_col_max * 4 < (cast(s32) ref_mv.as_mv.col) >> 1 +
            ((cast(s32) 1) << ((MVLONG_WIDTH) & 31) - 1) then x.mv_col_max * 4 else (cast(s32) ref_mv.as_mv.col) >> 1 + ((cast(s32) 1) << ((MVLONG_WIDTH) & 31) - 1));
    minr :=
        (ifx x.mv_row_min * 4 > (cast(s32) ref_mv.as_mv.row) >> 1 -
            ((cast(s32) 1) << ((MVLONG_WIDTH) & 31) - 1) then x.mv_row_min * 4 else (cast(s32) ref_mv.as_mv.row) >> 1 - ((cast(s32) 1) << ((MVLONG_WIDTH) & 31) - 1));
    maxr :=
        (ifx x.mv_row_max * 4 < (cast(s32) ref_mv.as_mv.row) >> 1 +
            ((cast(s32) 1) << ((MVLONG_WIDTH) & 31) - 1) then x.mv_row_max * 4 else (cast(s32) ref_mv.as_mv.row) >> 1 + ((cast(s32) 1) << ((MVLONG_WIDTH) & 31) - 1));

    pre_stride := x.e_mbd.pre.y_stride;
    base_pre: *u8 = x.e_mbd.pre.y_buffer;

    y := base_pre + d.offset + (cast(s32) bestmv.as_mv.row) * pre_stride + cast,no_check(s32) bestmv.as_mv.col;
    y_stride := pre_stride;

    offset := (cast(s32) bestmv.as_mv.row) * y_stride + cast(s32) bestmv.as_mv.col;

    bestmv.as_mv.row =
        cast,no_check(s16) clamp_in_mcomp(
            (cast(s32) bestmv.as_mv.row) * 8,
            cast,no_check(s32) (-32767 - 1),
            32767
        );
    bestmv.as_mv.col =
        cast,no_check(s16) clamp_in_mcomp(
            (cast(s32) bestmv.as_mv.col) * 8,
            cast,no_check(s32) (-32767 - 1),
            32767
        );

    besterr := vfp.vf(y, y_stride, z, b.src_stride, sse1);
    distortion.* = cast,no_check(s32) besterr;
    besterr += cast,no_check(u32) mv_err_cost(bestmv, ref_mv, mvcost, error_per_bit);

    while ((c_transpiler_pre_decrement(*(halfiters))) != 0) {
        if tc - 2 >= minc && tc - 2 <= maxc && tr >= minr && tr <= maxr {
            thismse =
                cast,no_check(s32) vfp.svf(
                    y + (tr >> 2 * y_stride + (tc - 2) >> 2 - offset),
                    y_stride,
                    (tc - 2) & 3 << 1,
                    tr & 3 << 1,
                    z,
                    b.src_stride,
                    *sse
                );

            if (ifx true { assignment_1: u32 = cast,no_check(u32) (cast,no_check(u32) ((ifx mvcost != null then ((mvcost[0][tr - rr] + mvcost[1][tc - 2 - rc]) * error_per_bit + 128) >> 8 else 0) + thismse)); (left) = assignment_1; assignment_1; }) < besterr {
                besterr = left;

                br = tr;

                bc = tc - 2;

                distortion.* = thismse;

                sse1.* = sse;
            }
        } else {
            left = (cast,no_check(u32) (2147483647)) * 2 + 1;
        }
        if tc + 2 >= minc && tc + 2 <= maxc && tr >= minr && tr <= maxr {
            thismse =
                cast,no_check(s32) vfp.svf(
                    y + (tr >> 2 * y_stride + (tc + 2) >> 2 - offset),
                    y_stride,
                    (tc + 2) & 3 << 1,
                    tr & 3 << 1,
                    z,
                    b.src_stride,
                    *sse
                );

            if (ifx true { assignment_2: u32 = cast,no_check(u32) (cast,no_check(u32) ((ifx mvcost != null then ((mvcost[0][tr - rr] + mvcost[1][tc + 2 - rc]) * error_per_bit + 128) >> 8 else 0) + thismse)); (right) = assignment_2; assignment_2; }) < besterr {
                besterr = right;

                br = tr;

                bc = tc + 2;

                distortion.* = thismse;

                sse1.* = sse;
            }
        } else {
            right = (cast,no_check(u32) (2147483647)) * 2 + 1;
        }
        if tc >= minc && tc <= maxc && tr - 2 >= minr && tr - 2 <= maxr {
            thismse =
                cast,no_check(s32) vfp.svf(
                    y + ((tr - 2) >> 2 * y_stride + tc >> 2 - offset),
                    y_stride,
                    tc & 3 << 1,
                    (tr - 2) & 3 << 1,
                    z,
                    b.src_stride,
                    *sse
                );

            if (ifx true { assignment_3: u32 = cast,no_check(u32) (cast,no_check(u32) ((ifx mvcost != null then ((mvcost[0][tr - 2 - rr] + mvcost[1][tc - rc]) * error_per_bit + 128) >> 8 else 0) + thismse)); (up) = assignment_3; assignment_3; }) < besterr {
                besterr = up;

                br = tr - 2;

                bc = tc;

                distortion.* = thismse;

                sse1.* = sse;
            }
        } else {
            up = (cast,no_check(u32) (2147483647)) * 2 + 1;
        }
        if tc >= minc && tc <= maxc && tr + 2 >= minr && tr + 2 <= maxr {
            thismse =
                cast,no_check(s32) vfp.svf(
                    y + ((tr + 2) >> 2 * y_stride + tc >> 2 - offset),
                    y_stride,
                    tc & 3 << 1,
                    (tr + 2) & 3 << 1,
                    z,
                    b.src_stride,
                    *sse
                );

            if (ifx true { assignment_4: u32 = cast,no_check(u32) (cast,no_check(u32) ((ifx mvcost != null then ((mvcost[0][tr + 2 - rr] + mvcost[1][tc - rc]) * error_per_bit + 128) >> 8 else 0) + thismse)); (down) = assignment_4; assignment_4; }) < besterr {
                besterr = down;

                br = tr + 2;

                bc = tc;

                distortion.* = thismse;

                sse1.* = sse;
            }
        } else {
            down = (cast,no_check(u32) (2147483647)) * 2 + 1;
        }

        whichdir =
            cast,no_check(u32) ((ifx left < right then cast(s32) 0 else 1) +
                (ifx up < down then cast(s32) 0 else 2));

        if whichdir == {
            case 0;
                if tc - 2 >= minc && tc - 2 <= maxc && tr - 2 >= minr && tr - 2 <= maxr {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            y + ((tr - 2) >> 2 * y_stride + (tc - 2) >> 2 - offset),
                            y_stride,
                            (tc - 2) & 3 << 1,
                            (tr - 2) & 3 << 1,
                            z,
                            b.src_stride,
                            *sse
                        );

                    if (ifx true { assignment_5: u32 = cast,no_check(u32) (cast,no_check(u32) ((ifx mvcost != null then ((mvcost[0][tr - 2 - rr] + mvcost[1][tc - 2 - rc]) * error_per_bit + 128) >> 8 else 0) + thismse)); (diag) = assignment_5; assignment_5; }) < besterr {
                        besterr = diag;

                        br = tr - 2;

                        bc = tc - 2;

                        distortion.* = thismse;

                        sse1.* = sse;
                    }
                } else {
                    diag = (cast,no_check(u32) (2147483647)) * 2 + 1;
                }
            case 1;
                if tc + 2 >= minc && tc + 2 <= maxc && tr - 2 >= minr && tr - 2 <= maxr {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            y + ((tr - 2) >> 2 * y_stride + (tc + 2) >> 2 - offset),
                            y_stride,
                            (tc + 2) & 3 << 1,
                            (tr - 2) & 3 << 1,
                            z,
                            b.src_stride,
                            *sse
                        );

                    if (ifx true { assignment_6: u32 = cast,no_check(u32) (cast,no_check(u32) ((ifx mvcost != null then ((mvcost[0][tr - 2 - rr] + mvcost[1][tc + 2 - rc]) * error_per_bit + 128) >> 8 else 0) + thismse)); (diag) = assignment_6; assignment_6; }) < besterr {
                        besterr = diag;

                        br = tr - 2;

                        bc = tc + 2;

                        distortion.* = thismse;

                        sse1.* = sse;
                    }
                } else {
                    diag = (cast,no_check(u32) (2147483647)) * 2 + 1;
                }
            case 2;
                if tc - 2 >= minc && tc - 2 <= maxc && tr + 2 >= minr && tr + 2 <= maxr {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            y + ((tr + 2) >> 2 * y_stride + (tc - 2) >> 2 - offset),
                            y_stride,
                            (tc - 2) & 3 << 1,
                            (tr + 2) & 3 << 1,
                            z,
                            b.src_stride,
                            *sse
                        );

                    if (ifx true { assignment_7: u32 = cast,no_check(u32) (cast,no_check(u32) ((ifx mvcost != null then ((mvcost[0][tr + 2 - rr] + mvcost[1][tc - 2 - rc]) * error_per_bit + 128) >> 8 else 0) + thismse)); (diag) = assignment_7; assignment_7; }) < besterr {
                        besterr = diag;

                        br = tr + 2;

                        bc = tc - 2;

                        distortion.* = thismse;

                        sse1.* = sse;
                    }
                } else {
                    diag = (cast,no_check(u32) (2147483647)) * 2 + 1;
                }
            case 3;
                if tc + 2 >= minc && tc + 2 <= maxc && tr + 2 >= minr && tr + 2 <= maxr {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            y + ((tr + 2) >> 2 * y_stride + (tc + 2) >> 2 - offset),
                            y_stride,
                            (tc + 2) & 3 << 1,
                            (tr + 2) & 3 << 1,
                            z,
                            b.src_stride,
                            *sse
                        );

                    if (ifx true { assignment_8: u32 = cast,no_check(u32) (cast,no_check(u32) ((ifx mvcost != null then ((mvcost[0][tr + 2 - rr] + mvcost[1][tc + 2 - rc]) * error_per_bit + 128) >> 8 else 0) + thismse)); (diag) = assignment_8; assignment_8; }) < besterr {
                        besterr = diag;

                        br = tr + 2;

                        bc = tc + 2;

                        distortion.* = thismse;

                        sse1.* = sse;
                    }
                } else {
                    diag = (cast,no_check(u32) (2147483647)) * 2 + 1;
                }
        }

        if tr == br && tc == bc {
            break;
        }

        tr = br;
        tc = bc;
    }

    while ((c_transpiler_pre_decrement(*(quarteriters))) != 0) {
        if tc - 1 >= minc && tc - 1 <= maxc && tr >= minr && tr <= maxr {
            thismse =
                cast,no_check(s32) vfp.svf(
                    y + (tr >> 2 * y_stride + (tc - 1) >> 2 - offset),
                    y_stride,
                    (tc - 1) & 3 << 1,
                    tr & 3 << 1,
                    z,
                    b.src_stride,
                    *sse
                );

            if (ifx true { assignment_9: u32 = cast,no_check(u32) (cast,no_check(u32) ((ifx mvcost != null then ((mvcost[0][tr - rr] + mvcost[1][tc - 1 - rc]) * error_per_bit + 128) >> 8 else 0) + thismse)); (left) = assignment_9; assignment_9; }) < besterr {
                besterr = left;

                br = tr;

                bc = tc - 1;

                distortion.* = thismse;

                sse1.* = sse;
            }
        } else {
            left = (cast,no_check(u32) (2147483647)) * 2 + 1;
        }
        if tc + 1 >= minc && tc + 1 <= maxc && tr >= minr && tr <= maxr {
            thismse =
                cast,no_check(s32) vfp.svf(
                    y + (tr >> 2 * y_stride + (tc + 1) >> 2 - offset),
                    y_stride,
                    (tc + 1) & 3 << 1,
                    tr & 3 << 1,
                    z,
                    b.src_stride,
                    *sse
                );

            if (ifx true { assignment_10: u32 = cast,no_check(u32) (cast,no_check(u32) ((ifx mvcost != null then ((mvcost[0][tr - rr] + mvcost[1][tc + 1 - rc]) * error_per_bit + 128) >> 8 else 0) + thismse)); (right) = assignment_10; assignment_10; }) < besterr {
                besterr = right;

                br = tr;

                bc = tc + 1;

                distortion.* = thismse;

                sse1.* = sse;
            }
        } else {
            right = (cast,no_check(u32) (2147483647)) * 2 + 1;
        }
        if tc >= minc && tc <= maxc && tr - 1 >= minr && tr - 1 <= maxr {
            thismse =
                cast,no_check(s32) vfp.svf(
                    y + ((tr - 1) >> 2 * y_stride + tc >> 2 - offset),
                    y_stride,
                    tc & 3 << 1,
                    (tr - 1) & 3 << 1,
                    z,
                    b.src_stride,
                    *sse
                );

            if (ifx true { assignment_11: u32 = cast,no_check(u32) (cast,no_check(u32) ((ifx mvcost != null then ((mvcost[0][tr - 1 - rr] + mvcost[1][tc - rc]) * error_per_bit + 128) >> 8 else 0) + thismse)); (up) = assignment_11; assignment_11; }) < besterr {
                besterr = up;

                br = tr - 1;

                bc = tc;

                distortion.* = thismse;

                sse1.* = sse;
            }
        } else {
            up = (cast,no_check(u32) (2147483647)) * 2 + 1;
        }
        if tc >= minc && tc <= maxc && tr + 1 >= minr && tr + 1 <= maxr {
            thismse =
                cast,no_check(s32) vfp.svf(
                    y + ((tr + 1) >> 2 * y_stride + tc >> 2 - offset),
                    y_stride,
                    tc & 3 << 1,
                    (tr + 1) & 3 << 1,
                    z,
                    b.src_stride,
                    *sse
                );

            if (ifx true { assignment_12: u32 = cast,no_check(u32) (cast,no_check(u32) ((ifx mvcost != null then ((mvcost[0][tr + 1 - rr] + mvcost[1][tc - rc]) * error_per_bit + 128) >> 8 else 0) + thismse)); (down) = assignment_12; assignment_12; }) < besterr {
                besterr = down;

                br = tr + 1;

                bc = tc;

                distortion.* = thismse;

                sse1.* = sse;
            }
        } else {
            down = (cast,no_check(u32) (2147483647)) * 2 + 1;
        }

        whichdir =
            cast,no_check(u32) ((ifx left < right then cast(s32) 0 else 1) +
                (ifx up < down then cast(s32) 0 else 2));

        if whichdir == {
            case 0;
                if tc - 1 >= minc && tc - 1 <= maxc && tr - 1 >= minr && tr - 1 <= maxr {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            y + ((tr - 1) >> 2 * y_stride + (tc - 1) >> 2 - offset),
                            y_stride,
                            (tc - 1) & 3 << 1,
                            (tr - 1) & 3 << 1,
                            z,
                            b.src_stride,
                            *sse
                        );

                    if (ifx true { assignment_13: u32 = cast,no_check(u32) (cast,no_check(u32) ((ifx mvcost != null then ((mvcost[0][tr - 1 - rr] + mvcost[1][tc - 1 - rc]) * error_per_bit + 128) >> 8 else 0) + thismse)); (diag) = assignment_13; assignment_13; }) < besterr {
                        besterr = diag;

                        br = tr - 1;

                        bc = tc - 1;

                        distortion.* = thismse;

                        sse1.* = sse;
                    }
                } else {
                    diag = (cast,no_check(u32) (2147483647)) * 2 + 1;
                }
            case 1;
                if tc + 1 >= minc && tc + 1 <= maxc && tr - 1 >= minr && tr - 1 <= maxr {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            y + ((tr - 1) >> 2 * y_stride + (tc + 1) >> 2 - offset),
                            y_stride,
                            (tc + 1) & 3 << 1,
                            (tr - 1) & 3 << 1,
                            z,
                            b.src_stride,
                            *sse
                        );

                    if (ifx true { assignment_14: u32 = cast,no_check(u32) (cast,no_check(u32) ((ifx mvcost != null then ((mvcost[0][tr - 1 - rr] + mvcost[1][tc + 1 - rc]) * error_per_bit + 128) >> 8 else 0) + thismse)); (diag) = assignment_14; assignment_14; }) < besterr {
                        besterr = diag;

                        br = tr - 1;

                        bc = tc + 1;

                        distortion.* = thismse;

                        sse1.* = sse;
                    }
                } else {
                    diag = (cast,no_check(u32) (2147483647)) * 2 + 1;
                }
            case 2;
                if tc - 1 >= minc && tc - 1 <= maxc && tr + 1 >= minr && tr + 1 <= maxr {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            y + ((tr + 1) >> 2 * y_stride + (tc - 1) >> 2 - offset),
                            y_stride,
                            (tc - 1) & 3 << 1,
                            (tr + 1) & 3 << 1,
                            z,
                            b.src_stride,
                            *sse
                        );

                    if (ifx true { assignment_15: u32 = cast,no_check(u32) (cast,no_check(u32) ((ifx mvcost != null then ((mvcost[0][tr + 1 - rr] + mvcost[1][tc - 1 - rc]) * error_per_bit + 128) >> 8 else 0) + thismse)); (diag) = assignment_15; assignment_15; }) < besterr {
                        besterr = diag;

                        br = tr + 1;

                        bc = tc - 1;

                        distortion.* = thismse;

                        sse1.* = sse;
                    }
                } else {
                    diag = (cast,no_check(u32) (2147483647)) * 2 + 1;
                }
            case 3;
                if tc + 1 >= minc && tc + 1 <= maxc && tr + 1 >= minr && tr + 1 <= maxr {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            y + ((tr + 1) >> 2 * y_stride + (tc + 1) >> 2 - offset),
                            y_stride,
                            (tc + 1) & 3 << 1,
                            (tr + 1) & 3 << 1,
                            z,
                            b.src_stride,
                            *sse
                        );

                    if (ifx true { assignment_16: u32 = cast,no_check(u32) (cast,no_check(u32) ((ifx mvcost != null then ((mvcost[0][tr + 1 - rr] + mvcost[1][tc + 1 - rc]) * error_per_bit + 128) >> 8 else 0) + thismse)); (diag) = assignment_16; assignment_16; }) < besterr {
                        besterr = diag;

                        br = tr + 1;

                        bc = tc + 1;

                        distortion.* = thismse;

                        sse1.* = sse;
                    }
                } else {
                    diag = (cast,no_check(u32) (2147483647)) * 2 + 1;
                }
        }

        if tr == br && tc == bc {
            break;
        }

        tr = br;
        tc = bc;
    }

    bestmv.as_mv.row = cast,no_check(s16) clamp_in_mcomp(br * 2, cast,no_check(s32) (-32767 - 1), 32767);
    bestmv.as_mv.col = cast,no_check(s16) clamp_in_mcomp(bc * 2, cast,no_check(s32) (-32767 - 1), 32767);

    if absolute_value((cast(s32) bestmv.as_mv.col) - cast(s32) ref_mv.as_mv.col) > ((cast(s32) 1) << 8 - 1) << 3 ||
        absolute_value((cast(s32) bestmv.as_mv.row) - cast(s32) ref_mv.as_mv.row) > ((cast(s32) 1) << 8 - 1) << 3 {
        return 2147483647;
    }

    return cast,no_check(s32) besterr;
}

vp8_find_best_sub_pixel_step :: (
    x: *MACROBLOCK_in_block,
    b: *BLOCK,
    d: *BLOCKD,
    bestmv: *Int_Mv_in_mv,
    ref_mv: *Int_Mv_in_mv,
    error_per_bit: s32,
    vfp: *Vp8_Variance_Fn_Ptr_T,
    mvcost: **s32,
    distortion: *s32,
    sse1: *u32
) -> s32 {
    bestmse: s32 = 2147483647;
    startmv: Int_Mv_in_mv = ---;
    this_mv: Int_Mv_in_mv = ---;
    z := b.base_src.* + b.src;

    sse: u32 = ---;

    pre_stride := x.e_mbd.pre.y_stride;
    base_pre: *u8 = x.e_mbd.pre.y_buffer;

    y := base_pre + d.offset + (cast(s32) bestmv.as_mv.row) * pre_stride + cast,no_check(s32) bestmv.as_mv.col;
    y_stride := pre_stride;

    bestmv.as_mv.row =
        cast,no_check(s16) clamp_in_mcomp(
            (cast(s32) bestmv.as_mv.row) * 8,
            cast,no_check(s32) (-32767 - 1),
            32767
        );
    bestmv.as_mv.col =
        cast,no_check(s16) clamp_in_mcomp(
            (cast(s32) bestmv.as_mv.col) * 8,
            cast,no_check(s32) (-32767 - 1),
            32767
        );
    startmv = bestmv.*;

    bestmse = cast,no_check(s32) vfp.vf(y, y_stride, z, b.src_stride, sse1);
    distortion.* = bestmse;
    bestmse += mv_err_cost(bestmv, ref_mv, mvcost, error_per_bit);

    this_mv.as_mv.row = startmv.as_mv.row;
    this_mv.as_mv.col = cast,no_check(s16) (((cast(s32) startmv.as_mv.col) - 8) | 4);

    thismse := cast,no_check(s32) vfp.svf(y - 1, y_stride, 4, 0, z, b.src_stride, *sse);
    left := thismse + mv_err_cost(*this_mv, ref_mv, mvcost, error_per_bit);

    if left < bestmse {
        bestmv.* = this_mv;
        bestmse = left;
        distortion.* = thismse;
        sse1.* = sse;
    }

    this_mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.col) + 8);

    thismse = cast,no_check(s32) vfp.svf(y, y_stride, 4, 0, z, b.src_stride, *sse);
    right := thismse + mv_err_cost(*this_mv, ref_mv, mvcost, error_per_bit);

    if right < bestmse {
        bestmv.* = this_mv;
        bestmse = right;
        distortion.* = thismse;
        sse1.* = sse;
    }

    this_mv.as_mv.col = startmv.as_mv.col;
    this_mv.as_mv.row = cast,no_check(s16) (((cast(s32) startmv.as_mv.row) - 8) | 4);

    thismse = cast,no_check(s32) vfp.svf(y - y_stride, y_stride, 0, 4, z, b.src_stride, *sse);
    up := thismse + mv_err_cost(*this_mv, ref_mv, mvcost, error_per_bit);

    if up < bestmse {
        bestmv.* = this_mv;
        bestmse = up;
        distortion.* = thismse;
        sse1.* = sse;
    }

    this_mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.row) + 8);

    thismse = cast,no_check(s32) vfp.svf(y, y_stride, 0, 4, z, b.src_stride, *sse);
    down := thismse + mv_err_cost(*this_mv, ref_mv, mvcost, error_per_bit);

    if down < bestmse {
        bestmv.* = this_mv;
        bestmse = down;
        distortion.* = thismse;
        sse1.* = sse;
    }

    whichdir := (ifx left < right then cast(s32) 0 else 1) + (ifx up < down then cast(s32) 0 else 2);
    this_mv = startmv;

    if whichdir == {
        case 0;
            this_mv.as_mv.col = cast,no_check(s16) (((cast(s32) this_mv.as_mv.col) - 8) | 4);
            this_mv.as_mv.row = cast,no_check(s16) (((cast(s32) this_mv.as_mv.row) - 8) | 4);
            thismse = cast,no_check(s32) vfp.svf(y - 1 - y_stride, y_stride, 4, 4, z, b.src_stride, *sse);
        case 1;
            this_mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.col) + 4);
            this_mv.as_mv.row = cast,no_check(s16) (((cast(s32) this_mv.as_mv.row) - 8) | 4);
            thismse = cast,no_check(s32) vfp.svf(y - y_stride, y_stride, 4, 4, z, b.src_stride, *sse);
        case 2;
            this_mv.as_mv.col = cast,no_check(s16) (((cast(s32) this_mv.as_mv.col) - 8) | 4);
            this_mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.row) + 4);
            thismse = cast,no_check(s32) vfp.svf(y - 1, y_stride, 4, 4, z, b.src_stride, *sse);
        case 3; #through;
        case;
            this_mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.col) + 4);
            this_mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.row) + 4);
            thismse = cast,no_check(s32) vfp.svf(y, y_stride, 4, 4, z, b.src_stride, *sse);
    }

    diag := thismse + mv_err_cost(*this_mv, ref_mv, mvcost, error_per_bit);

    if diag < bestmse {
        bestmv.* = this_mv;
        bestmse = diag;
        distortion.* = thismse;
        sse1.* = sse;
    }

    if bestmv.as_mv.row < startmv.as_mv.row {
        y -= y_stride;
    }

    if bestmv.as_mv.col < startmv.as_mv.col {
        y -= 1;
    }

    startmv = bestmv.*;

    this_mv.as_mv.row = startmv.as_mv.row;

    if startmv.as_mv.col & 7 != 0 {
        this_mv.as_mv.col = cast,no_check(s16) ((cast(s32) startmv.as_mv.col) - 2);
        thismse =
            cast,no_check(s32) vfp.svf(
                y,
                y_stride,
                (cast(s32) this_mv.as_mv.col) & 7,
                (cast(s32) this_mv.as_mv.row) & 7,
                z,
                b.src_stride,
                *sse
            );
    } else {
        this_mv.as_mv.col = cast,no_check(s16) (((cast(s32) startmv.as_mv.col) - 8) | 6);
        thismse =
            cast,no_check(s32) vfp.svf(
                y - 1,
                y_stride,
                6,
                (cast(s32) this_mv.as_mv.row) & 7,
                z,
                b.src_stride,
                *sse
            );
    }

    left = thismse + mv_err_cost(*this_mv, ref_mv, mvcost, error_per_bit);

    if left < bestmse {
        bestmv.* = this_mv;
        bestmse = left;
        distortion.* = thismse;
        sse1.* = sse;
    }

    this_mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.col) + 4);
    thismse =
        cast,no_check(s32) vfp.svf(
            y,
            y_stride,
            (cast(s32) this_mv.as_mv.col) & 7,
            (cast(s32) this_mv.as_mv.row) & 7,
            z,
            b.src_stride,
            *sse
        );
    right = thismse + mv_err_cost(*this_mv, ref_mv, mvcost, error_per_bit);

    if right < bestmse {
        bestmv.* = this_mv;
        bestmse = right;
        distortion.* = thismse;
        sse1.* = sse;
    }

    this_mv.as_mv.col = startmv.as_mv.col;

    if startmv.as_mv.row & 7 != 0 {
        this_mv.as_mv.row = cast,no_check(s16) ((cast(s32) startmv.as_mv.row) - 2);
        thismse =
            cast,no_check(s32) vfp.svf(
                y,
                y_stride,
                (cast(s32) this_mv.as_mv.col) & 7,
                (cast(s32) this_mv.as_mv.row) & 7,
                z,
                b.src_stride,
                *sse
            );
    } else {
        this_mv.as_mv.row = cast,no_check(s16) (((cast(s32) startmv.as_mv.row) - 8) | 6);
        thismse =
            cast,no_check(s32) vfp.svf(
                y - y_stride,
                y_stride,
                (cast(s32) this_mv.as_mv.col) & 7,
                6,
                z,
                b.src_stride,
                *sse
            );
    }

    up = thismse + mv_err_cost(*this_mv, ref_mv, mvcost, error_per_bit);

    if up < bestmse {
        bestmv.* = this_mv;
        bestmse = up;
        distortion.* = thismse;
        sse1.* = sse;
    }

    this_mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.row) + 4);
    thismse =
        cast,no_check(s32) vfp.svf(
            y,
            y_stride,
            (cast(s32) this_mv.as_mv.col) & 7,
            (cast(s32) this_mv.as_mv.row) & 7,
            z,
            b.src_stride,
            *sse
        );
    down = thismse + mv_err_cost(*this_mv, ref_mv, mvcost, error_per_bit);

    if down < bestmse {
        bestmv.* = this_mv;
        bestmse = down;
        distortion.* = thismse;
        sse1.* = sse;
    }

    whichdir = (ifx left < right then cast(s32) 0 else 1) + (ifx up < down then cast(s32) 0 else 2);

    this_mv = startmv;

    if whichdir == {
        case 0;
            if startmv.as_mv.row & 7 != 0 {
                this_mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.row) - 2);

                if startmv.as_mv.col & 7 != 0 {
                    this_mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.col) - 2);
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            y,
                            y_stride,
                            (cast(s32) this_mv.as_mv.col) & 7,
                            (cast(s32) this_mv.as_mv.row) & 7,
                            z,
                            b.src_stride,
                            *sse
                        );
                } else {
                    this_mv.as_mv.col = cast,no_check(s16) (((cast(s32) startmv.as_mv.col) - 8) | 6);
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            y - 1,
                            y_stride,
                            6,
                            (cast(s32) this_mv.as_mv.row) & 7,
                            z,
                            b.src_stride,
                            *sse
                        );
                }
            } else {
                this_mv.as_mv.row = cast,no_check(s16) (((cast(s32) startmv.as_mv.row) - 8) | 6);

                if startmv.as_mv.col & 7 != 0 {
                    this_mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.col) - 2);
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            y - y_stride,
                            y_stride,
                            (cast(s32) this_mv.as_mv.col) & 7,
                            6,
                            z,
                            b.src_stride,
                            *sse
                        );
                } else {
                    this_mv.as_mv.col = cast,no_check(s16) (((cast(s32) startmv.as_mv.col) - 8) | 6);
                    thismse = cast,no_check(s32) vfp.svf(y - y_stride - 1, y_stride, 6, 6, z, b.src_stride, *sse);
                }
            }
        case 1;
            this_mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.col) + 2);
            if startmv.as_mv.row & 7 != 0 {
                this_mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.row) - 2);
                thismse =
                    cast,no_check(s32) vfp.svf(
                        y,
                        y_stride,
                        (cast(s32) this_mv.as_mv.col) & 7,
                        (cast(s32) this_mv.as_mv.row) & 7,
                        z,
                        b.src_stride,
                        *sse
                    );
            } else {
                this_mv.as_mv.row = cast,no_check(s16) (((cast(s32) startmv.as_mv.row) - 8) | 6);
                thismse =
                    cast,no_check(s32) vfp.svf(
                        y - y_stride,
                        y_stride,
                        (cast(s32) this_mv.as_mv.col) & 7,
                        6,
                        z,
                        b.src_stride,
                        *sse
                    );
            }
        case 2;
            this_mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.row) + 2);
            if startmv.as_mv.col & 7 != 0 {
                this_mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.col) - 2);
                thismse =
                    cast,no_check(s32) vfp.svf(
                        y,
                        y_stride,
                        (cast(s32) this_mv.as_mv.col) & 7,
                        (cast(s32) this_mv.as_mv.row) & 7,
                        z,
                        b.src_stride,
                        *sse
                    );
            } else {
                this_mv.as_mv.col = cast,no_check(s16) (((cast(s32) startmv.as_mv.col) - 8) | 6);
                thismse =
                    cast,no_check(s32) vfp.svf(
                        y - 1,
                        y_stride,
                        6,
                        (cast(s32) this_mv.as_mv.row) & 7,
                        z,
                        b.src_stride,
                        *sse
                    );
            }
        case 3;
            this_mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.col) + 2);
            this_mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.row) + 2);
            thismse =
                cast,no_check(s32) vfp.svf(
                    y,
                    y_stride,
                    (cast(s32) this_mv.as_mv.col) & 7,
                    (cast(s32) this_mv.as_mv.row) & 7,
                    z,
                    b.src_stride,
                    *sse
                );
    }

    diag = thismse + mv_err_cost(*this_mv, ref_mv, mvcost, error_per_bit);

    if diag < bestmse {
        bestmv.* = this_mv;
        bestmse = diag;
        distortion.* = thismse;
        sse1.* = sse;
    }

    return bestmse;
}

vp8_find_best_half_pixel_step :: (
    x: *MACROBLOCK_in_block,
    b: *BLOCK,
    d: *BLOCKD,
    bestmv: *Int_Mv_in_mv,
    ref_mv: *Int_Mv_in_mv,
    error_per_bit: s32,
    vfp: *Vp8_Variance_Fn_Ptr_T,
    mvcost: **s32,
    distortion: *s32,
    sse1: *u32
) -> s32 {
    bestmse: s32 = 2147483647;
    startmv: Int_Mv_in_mv = ---;
    this_mv: Int_Mv_in_mv = ---;
    z := b.base_src.* + b.src;

    sse: u32 = ---;

    pre_stride := x.e_mbd.pre.y_stride;
    base_pre: *u8 = x.e_mbd.pre.y_buffer;

    y := base_pre + d.offset + (cast(s32) bestmv.as_mv.row) * pre_stride + cast,no_check(s32) bestmv.as_mv.col;
    y_stride := pre_stride;

    bestmv.as_mv.row =
        cast,no_check(s16) clamp_in_mcomp(
            (cast(s32) bestmv.as_mv.row) * 8,
            cast,no_check(s32) (-32767 - 1),
            32767
        );
    bestmv.as_mv.col =
        cast,no_check(s16) clamp_in_mcomp(
            (cast(s32) bestmv.as_mv.col) * 8,
            cast,no_check(s32) (-32767 - 1),
            32767
        );
    startmv = bestmv.*;

    bestmse = cast,no_check(s32) vfp.vf(y, y_stride, z, b.src_stride, sse1);
    distortion.* = bestmse;
    bestmse += mv_err_cost(bestmv, ref_mv, mvcost, error_per_bit);

    this_mv.as_mv.row = startmv.as_mv.row;
    this_mv.as_mv.col = cast,no_check(s16) (((cast(s32) startmv.as_mv.col) - 8) | 4);

    thismse := cast,no_check(s32) vfp.svf(y - 1, y_stride, 4, 0, z, b.src_stride, *sse);
    left := thismse + mv_err_cost(*this_mv, ref_mv, mvcost, error_per_bit);

    if left < bestmse {
        bestmv.* = this_mv;
        bestmse = left;
        distortion.* = thismse;
        sse1.* = sse;
    }

    this_mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.col) + 8);

    thismse = cast,no_check(s32) vfp.svf(y, y_stride, 4, 0, z, b.src_stride, *sse);
    right := thismse + mv_err_cost(*this_mv, ref_mv, mvcost, error_per_bit);

    if right < bestmse {
        bestmv.* = this_mv;
        bestmse = right;
        distortion.* = thismse;
        sse1.* = sse;
    }

    this_mv.as_mv.col = startmv.as_mv.col;
    this_mv.as_mv.row = cast,no_check(s16) (((cast(s32) startmv.as_mv.row) - 8) | 4);

    thismse = cast,no_check(s32) vfp.svf(y - y_stride, y_stride, 0, 4, z, b.src_stride, *sse);
    up := thismse + mv_err_cost(*this_mv, ref_mv, mvcost, error_per_bit);

    if up < bestmse {
        bestmv.* = this_mv;
        bestmse = up;
        distortion.* = thismse;
        sse1.* = sse;
    }

    this_mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.row) + 8);

    thismse = cast,no_check(s32) vfp.svf(y, y_stride, 0, 4, z, b.src_stride, *sse);
    down := thismse + mv_err_cost(*this_mv, ref_mv, mvcost, error_per_bit);

    if down < bestmse {
        bestmv.* = this_mv;
        bestmse = down;
        distortion.* = thismse;
        sse1.* = sse;
    }

    whichdir := (ifx left < right then cast(s32) 0 else 1) + (ifx up < down then cast(s32) 0 else 2);
    this_mv = startmv;

    if whichdir == {
        case 0;
            this_mv.as_mv.col = cast,no_check(s16) (((cast(s32) this_mv.as_mv.col) - 8) | 4);
            this_mv.as_mv.row = cast,no_check(s16) (((cast(s32) this_mv.as_mv.row) - 8) | 4);
            thismse = cast,no_check(s32) vfp.svf(y - 1 - y_stride, y_stride, 4, 4, z, b.src_stride, *sse);
        case 1;
            this_mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.col) + 4);
            this_mv.as_mv.row = cast,no_check(s16) (((cast(s32) this_mv.as_mv.row) - 8) | 4);
            thismse = cast,no_check(s32) vfp.svf(y - y_stride, y_stride, 4, 4, z, b.src_stride, *sse);
        case 2;
            this_mv.as_mv.col = cast,no_check(s16) (((cast(s32) this_mv.as_mv.col) - 8) | 4);
            this_mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.row) + 4);
            thismse = cast,no_check(s32) vfp.svf(y - 1, y_stride, 4, 4, z, b.src_stride, *sse);
        case 3; #through;
        case;
            this_mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.col) + 4);
            this_mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) this_mv.as_mv.row) + 4);
            thismse = cast,no_check(s32) vfp.svf(y, y_stride, 4, 4, z, b.src_stride, *sse);
    }

    diag := thismse + mv_err_cost(*this_mv, ref_mv, mvcost, error_per_bit);

    if diag < bestmse {
        bestmv.* = this_mv;
        bestmse = diag;
        distortion.* = thismse;
        sse1.* = sse;
    }

    return bestmse;
}

vp8_full_search_sad :: (
    x: *MACROBLOCK_in_block,
    b: *BLOCK,
    d: *BLOCKD,
    ref_mv: *Int_Mv_in_mv,
    sad_per_bit: s32,
    distance: s32,
    fn_ptr: *Vp8_Variance_Fn_Ptr_T,
    mvcost: **s32,
    center_mv: *Int_Mv_in_mv
) -> s32 {
    what := b.base_src.* + b.src;
    what_stride := b.src_stride;

    pre_stride := x.e_mbd.pre.y_stride;
    base_pre: *u8 = x.e_mbd.pre.y_buffer;
    in_what_stride := pre_stride;
    mv_stride := pre_stride;

    best_mv := *d.bmi.mv;
    this_mv: Int_Mv_in_mv = ---;

    thissad: u32 = ---;
    c: s32 = ---;

    ref_row := cast,no_check(s32) ref_mv.as_mv.row;
    ref_col := cast,no_check(s32) ref_mv.as_mv.col;

    row_min := ref_row - distance;
    row_max := ref_row + distance;
    col_min := ref_col - distance;
    col_max := ref_col + distance;

    mvsadcost: [2] *s32 = ---;
    fcenter_mv: Int_Mv_in_mv = ---;

    mvsadcost[0] = x.mvsadcost[0];
    mvsadcost[1] = x.mvsadcost[1];
    fcenter_mv.as_mv.row = cast,no_check(s16) ((cast(s32) center_mv.as_mv.row) >> 3);
    fcenter_mv.as_mv.col = cast,no_check(s16) ((cast(s32) center_mv.as_mv.col) >> 3);

    in_what := base_pre + d.offset;
    bestaddress := in_what + ref_row * pre_stride + ref_col;

    best_mv.as_mv.row = cast,no_check(s16) ref_row;
    best_mv.as_mv.col = cast,no_check(s16) ref_col;

    bestsad :=
        fn_ptr.sdf(what, what_stride, bestaddress, in_what_stride) +
            cast,no_check(u32) mvsad_err_cost(best_mv, *fcenter_mv, mvsadcost.data, sad_per_bit);

    if col_min < x.mv_col_min {
        col_min = x.mv_col_min;
    }

    if col_max > x.mv_col_max {
        col_max = x.mv_col_max;
    }

    if row_min < x.mv_row_min {
        row_min = x.mv_row_min;
    }

    if row_max > x.mv_row_max {
        row_max = x.mv_row_max;
    }

    r := row_min;
    while r < row_max {
        this_mv.as_mv.row = cast,no_check(s16) r;
        check_here := r * mv_stride + in_what + col_min;

        c = col_min;
        while c < col_max {
            thissad = fn_ptr.sdf(what, what_stride, check_here, in_what_stride);

            if thissad < bestsad {
                this_mv.as_mv.col = cast,no_check(s16) c;
                thissad += cast,no_check(u32) mvsad_err_cost(*this_mv, *fcenter_mv, mvsadcost.data, sad_per_bit);

                if thissad < bestsad {
                    bestsad = thissad;
                    best_mv.as_mv.row = cast,no_check(s16) r;
                    best_mv.as_mv.col = cast,no_check(s16) c;
                    bestaddress = check_here;
                }
            }

            check_here += 1;
            c += 1;
        }
        r += 1;
    }

    this_mv.as_mv.row =
        cast,no_check(s16) clamp_in_mcomp(
            (cast(s32) best_mv.as_mv.row) * 8,
            cast,no_check(s32) (-32767 - 1),
            32767
        );
    this_mv.as_mv.col =
        cast,no_check(s16) clamp_in_mcomp(
            (cast(s32) best_mv.as_mv.col) * 8,
            cast,no_check(s32) (-32767 - 1),
            32767
        );

    return cast,no_check(s32) (fn_ptr.vf(what, what_stride, bestaddress, in_what_stride, *thissad) + cast,no_check(u32) mv_err_cost(*this_mv, center_mv, mvcost, x.errorperbit));
}

mv_bias_in_mcomp :: (refmb_ref_frame_sign_bias: s32, refframe: s32, mvp: *Int_Mv_in_mv, ref_frame_sign_bias: *s32) {
    if refmb_ref_frame_sign_bias != ref_frame_sign_bias[refframe] {
        mvp.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.row) * -1);
        mvp.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.col) * -1);
    }
}

vp8_clamp_mv2_in_mcomp :: (mv: *Int_Mv_in_mv, xd: *MACROBLOCKD_in_blockd) {
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

vp8_check_mv_bounds_in_mcomp :: (
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

left_block_mv_in_mcomp :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> u32 {
    if b & 3 == 0 {
        cur_mb -= 1;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 4;
    }

    return (((cur_mb.bmi.data + b - 1)).mv).as_int;
}

above_block_mv_in_mcomp :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> u32 {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 16;
    }

    return (((cur_mb.bmi.data + (b - 4))).mv).as_int;
}

left_block_mode_in_mcomp :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> B_PREDICTION_MODE {
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

above_block_mode_in_mcomp :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> B_PREDICTION_MODE {
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

globals_initialization_state_for_mcomp: u32;
initialize_globals_for_mcomp :: () {
    {
        state := atomic_load(*globals_initialization_state_for_mcomp);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_mcomp, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_mcomp) != 2 {}
            return;
        }
    }
    NEXT_CHKPTS =
        [3] MV_in_alloccommon.[
            MV_in_alloccommon.[ MV_in_alloccommon.{row = -2, col = 0}, MV_in_alloccommon.{row = -1, col = -2}, MV_in_alloccommon.{row = 1, col = -2} ],
            MV_in_alloccommon.[ MV_in_alloccommon.{row = -1, col = -2}, MV_in_alloccommon.{row = 1, col = -2}, MV_in_alloccommon.{row = 2, col = 0} ],
            MV_in_alloccommon.[ MV_in_alloccommon.{row = 1, col = -2}, MV_in_alloccommon.{row = 2, col = 0}, MV_in_alloccommon.{row = 1, col = 2} ],
            MV_in_alloccommon.[ MV_in_alloccommon.{row = 2, col = 0}, MV_in_alloccommon.{row = 1, col = 2}, MV_in_alloccommon.{row = -1, col = 2} ],
            MV_in_alloccommon.[ MV_in_alloccommon.{row = 1, col = 2}, MV_in_alloccommon.{row = -1, col = 2}, MV_in_alloccommon.{row = -2, col = 0} ],
            MV_in_alloccommon.[ MV_in_alloccommon.{row = -1, col = 2}, MV_in_alloccommon.{row = -2, col = 0}, MV_in_alloccommon.{row = -1, col = -2} ]
        ];
    atomic_store(*globals_initialization_state_for_mcomp, 2);
}

