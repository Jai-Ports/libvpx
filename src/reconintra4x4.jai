Intra_Pred_Fn_in_reconintra4x4 :: #type (_: *u8, _: s64, _: *u8, _: *u8);

pred_storage: [10] Intra_Pred_Fn_in_reconintra4x4;

clip_pixel_in_reconintra4x4 :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_reconintra4x4 :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_reconintra4x4 :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_reconintra4x4 :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_reconintra4x4 :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_reconintra4x4(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_reconintra4x4(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_reconintra4x4(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_reconintra4x4 :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_reconintra4x4 :: (FILTER: *s16) -> s32 {
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

intra_prediction_down_copy_in_reconintra4x4 :: (xd: *MACROBLOCKD_in_blockd, above_right_src: *u8) {
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

vp8_intra4x4_predict :: (
    above: *u8,
    yleft: *u8,
    left_stride: s32,
    b_mode: B_PREDICTION_MODE,
    dst: *u8,
    dst_stride: s32,
    top_left: u8
) {
    aboveb: [12] u8 = ---;

    above_value := aboveb.data + 4;

    left: [4] u8 = ---;

    left[0] = yleft[0];
    left[1] = yleft[left_stride];
    left[2] = yleft[2 * left_stride];
    left[3] = yleft[3 * left_stride];
    copy_memory(above_value, above, 8);
    above_value[-1] = top_left;

    pred_storage[b_mode](dst, cast,no_check(s64) dst_stride, above_value, left.data);
}

vp8_init_intra4x4_predictors_internal :: () {
    pred_storage[B_DC_PRED] = cast,no_check(Intra_Pred_Fn_in_reconintra4x4) dc_predictor_4x4_c;
    pred_storage[B_TM_PRED] = cast,no_check(Intra_Pred_Fn_in_reconintra4x4) tm_predictor_4x4_c;
    pred_storage[B_VE_PRED] = cast,no_check(Intra_Pred_Fn_in_reconintra4x4) ve_predictor_4x4_c;
    pred_storage[B_HE_PRED] = cast,no_check(Intra_Pred_Fn_in_reconintra4x4) he_predictor_4x4_c;
    pred_storage[B_LD_PRED] = cast,no_check(Intra_Pred_Fn_in_reconintra4x4) d45e_predictor_4x4_c;
    pred_storage[B_RD_PRED] = cast,no_check(Intra_Pred_Fn_in_reconintra4x4) d135_predictor_4x4_c;
    pred_storage[B_VR_PRED] = cast,no_check(Intra_Pred_Fn_in_reconintra4x4) d117_predictor_4x4_c;
    pred_storage[B_VL_PRED] = cast,no_check(Intra_Pred_Fn_in_reconintra4x4) d63e_predictor_4x4_c;
    pred_storage[B_HD_PRED] = cast,no_check(Intra_Pred_Fn_in_reconintra4x4) d153_predictor_4x4_c;
    pred_storage[B_HU_PRED] = cast,no_check(Intra_Pred_Fn_in_reconintra4x4) d207_predictor_4x4_c;
}

