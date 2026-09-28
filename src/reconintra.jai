Intra_Pred_Fn :: #type (_: *u8, _: s64, _: *u8, _: *u8);

Unnamed_7295 :: u32;
SIZE_16 : s32 : 0;
SIZE_8 : s32 : 1;
NUM_SIZES : s32 : 2;

lock_in_reconintra: Pthread_Once_T;

pred: [4] [2] Intra_Pred_Fn;

dc_pred: [2] [2] [2] Intra_Pred_Fn;

clip_pixel_in_reconintra :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_reconintra :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_reconintra :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_reconintra :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_reconintra :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_reconintra(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_reconintra(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_reconintra(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_reconintra :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_reconintra :: (FILTER: *s16) -> s32 {
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

once_in_reconintra :: (func: Once_In_Reconintra_Parameter_0_Type) {
    pthread_once(*lock_in_reconintra, cast,no_check(#type () #c_call) (func));
}

vp8_build_intra_predictors_mby_s :: (
    x: *MACROBLOCKD_in_blockd,
    yabove_row: *u8,
    yleft: *u8,
    left_stride: s32,
    ypred_ptr: *u8,
    y_stride: s32
) {
    mode := cast,no_check(MB_PREDICTION_MODE) x.mode_info_context.mbmi.mode;
    yleft_col: [16] u8 = --- #align 16;

    for i: 0..cast(s32) 16 - 1 {
        yleft_col[i] = yleft[i * left_stride];
    }

    fn: Intra_Pred_Fn = ifx mode == cast,no_check(u32) DC_PRED
        then dc_pred[x.left_available][x.up_available][SIZE_16]
        else pred[mode][SIZE_16];

    fn(ypred_ptr, cast,no_check(s64) y_stride, yabove_row, yleft_col.data);
}

vp8_build_intra_predictors_mbuv_s :: (
    x: *MACROBLOCKD_in_blockd,
    uabove_row: *u8,
    vabove_row: *u8,
    uleft: *u8,
    vleft: *u8,
    left_stride: s32,
    upred_ptr: *u8,
    vpred_ptr: *u8,
    pred_stride: s32
) {
    uvmode := cast,no_check(MB_PREDICTION_MODE) x.mode_info_context.mbmi.uv_mode;

    uleft_col: [8] u8 = ---;
    vleft_col: [8] u8 = ---;

    for i: 0..cast(s32) 8 - 1 {
        uleft_col[i] = uleft[i * left_stride];
        vleft_col[i] = vleft[i * left_stride];
    }

    fn: Intra_Pred_Fn = ifx uvmode == cast,no_check(u32) DC_PRED
        then dc_pred[x.left_available][x.up_available][SIZE_8]
        else pred[uvmode][SIZE_8];

    fn(upred_ptr, cast,no_check(s64) pred_stride, uabove_row, uleft_col.data);
    fn(vpred_ptr, cast,no_check(s64) pred_stride, vabove_row, vleft_col.data);
}

vp8_init_intra_predictors :: () {
    once_in_reconintra(cast,no_check(#type () #c_call) vp8_init_intra_predictors_internal);
}

vp8_init_intra_predictors_internal :: () #c_call {
    push_context {
        pred[V_PRED][SIZE_16] = cast,no_check(Intra_Pred_Fn) v_predictor_16x16_c;

        pred[H_PRED][SIZE_16] = cast,no_check(Intra_Pred_Fn) h_predictor_16x16_c;

        pred[TM_PRED][SIZE_16] = cast,no_check(Intra_Pred_Fn) tm_predictor_16x16_c;

        dc_pred[0][0][SIZE_16] = cast,no_check(Intra_Pred_Fn) dc_128_predictor_16x16_c;

        dc_pred[0][1][SIZE_16] = cast,no_check(Intra_Pred_Fn) dc_top_predictor_16x16_c;

        dc_pred[1][0][SIZE_16] = cast,no_check(Intra_Pred_Fn) dc_left_predictor_16x16_c;

        dc_pred[1][1][SIZE_16] = cast,no_check(Intra_Pred_Fn) dc_predictor_16x16_c;
        pred[V_PRED][SIZE_8] = cast,no_check(Intra_Pred_Fn) v_predictor_8x8_c;

        pred[H_PRED][SIZE_8] = cast,no_check(Intra_Pred_Fn) h_predictor_8x8_c;

        pred[TM_PRED][SIZE_8] = cast,no_check(Intra_Pred_Fn) tm_predictor_8x8_c;

        dc_pred[0][0][SIZE_8] = cast,no_check(Intra_Pred_Fn) dc_128_predictor_8x8_c;

        dc_pred[0][1][SIZE_8] = cast,no_check(Intra_Pred_Fn) dc_top_predictor_8x8_c;

        dc_pred[1][0][SIZE_8] = cast,no_check(Intra_Pred_Fn) dc_left_predictor_8x8_c;

        dc_pred[1][1][SIZE_8] = cast,no_check(Intra_Pred_Fn) dc_predictor_8x8_c;
        vp8_init_intra4x4_predictors_internal();
    }
}

intra_prediction_down_copy :: (xd: *MACROBLOCKD_in_blockd, above_right_src: *u8) {
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

globals_initialization_state_for_reconintra: u32;
initialize_globals_for_reconintra :: () {
    {
        state := atomic_load(*globals_initialization_state_for_reconintra);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_reconintra, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_reconintra) != 2 {}
            return;
        }
    }
    lock_in_reconintra = 0;
    atomic_store(*globals_initialization_state_for_reconintra, 2);
}


Once_In_Reconintra_Parameter_0_Type :: #type () #c_call;
