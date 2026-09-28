// Generated directly from C by cpp_transpiler.
clip_pixel_in_vp9_scale :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_scale :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_scale :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_scale :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_scale :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_scale(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_scale(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_scale(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_scale :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_vp9_scale :: (FILTER: *s16) -> s32 {
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

get_lsb_in_vp9_scale :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_scale :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_scale :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_scale(num_values) + 1 else 0;
}

is_zero_mv_in_vp9_scale :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_scale :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_scale :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_scale(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_scale(cast,no_check(s32) mv.row, min_row, max_row);
}

vp9_scale_mv :: (mv: *MV, x: s32, y: s32, sf: *Scale_Factors) -> MV32 {
    X_OFF_Q4 := scaled_x(x << 4, sf) & ((cast(s32) 1) << 4 - 1);
    Y_OFF_Q4 := scaled_y(y << 4, sf) & ((cast(s32) 1) << 4 - 1);
    RES :=
        MV32.{row = scaled_y(cast,no_check(s32) mv.row, sf) +
            Y_OFF_Q4, col = scaled_x(cast,no_check(s32) mv.col, sf) + X_OFF_Q4};
    return RES;
}

scaled_x :: (val: s32, sf: *Scale_Factors) -> s32 {
    return cast,no_check(s32) (((cast,no_check(s64) val) * cast(s64) sf.x_scale_fp) >> 14);
}

scaled_y :: (val: s32, sf: *Scale_Factors) -> s32 {
    return cast,no_check(s32) (((cast,no_check(s64) val) * cast(s64) sf.y_scale_fp) >> 14);
}

vp9_setup_scale_factors_for_frame :: (sf: *Scale_Factors, other_w: s32, other_h: s32, this_w: s32, this_h: s32) {
    if valid_ref_frame_size_in_vp9_scale(other_w, other_h, this_w, this_h) == 0 {
        sf.x_scale_fp = -1;
        sf.y_scale_fp = -1;
        return;
    }

    sf.x_scale_fp = get_fixed_point_scale_factor(other_w, this_w);
    sf.y_scale_fp = get_fixed_point_scale_factor(other_h, this_h);
    sf.x_step_q4 = scaled_x(16, sf);
    sf.y_step_q4 = scaled_y(16, sf);

    if vp9_is_scaled_in_vp9_scale(sf) != 0 {
        sf.scale_value_x = scaled_x;
        sf.scale_value_y = scaled_y;
    } else {
        sf.scale_value_x = unscaled_value;
        sf.scale_value_y = unscaled_value;
    }

    if sf.x_step_q4 == 16 {
        if sf.y_step_q4 == 16 {
            sf.predict[0][0][0] = cast,no_check(Convolve_Fn_T) convolve_copy_c;
            sf.predict[0][0][1] = cast,no_check(Convolve_Fn_T) convolve_avg_c;
            sf.predict[0][1][0] = cast,no_check(Convolve_Fn_T) convolve8_vert_c;
            sf.predict[0][1][1] = cast,no_check(Convolve_Fn_T) convolve8_avg_vert_c;
            sf.predict[1][0][0] = cast,no_check(Convolve_Fn_T) convolve8_horiz_c;
            sf.predict[1][0][1] = cast,no_check(Convolve_Fn_T) convolve8_avg_horiz_c;
        } else {
            sf.predict[0][0][0] = cast,no_check(Convolve_Fn_T) scaled_vert_c;
            sf.predict[0][0][1] = cast,no_check(Convolve_Fn_T) scaled_avg_vert_c;
            sf.predict[0][1][0] = cast,no_check(Convolve_Fn_T) scaled_vert_c;
            sf.predict[0][1][1] = cast,no_check(Convolve_Fn_T) scaled_avg_vert_c;
            sf.predict[1][0][0] = cast,no_check(Convolve_Fn_T) scaled_2d_c;
            sf.predict[1][0][1] = cast,no_check(Convolve_Fn_T) scaled_avg_2d_c;
        }
    } else if sf.y_step_q4 == 16 {
        sf.predict[0][0][0] = cast,no_check(Convolve_Fn_T) scaled_horiz_c;
        sf.predict[0][0][1] = cast,no_check(Convolve_Fn_T) scaled_avg_horiz_c;
        sf.predict[0][1][0] = cast,no_check(Convolve_Fn_T) scaled_2d_c;
        sf.predict[0][1][1] = cast,no_check(Convolve_Fn_T) scaled_avg_2d_c;
        sf.predict[1][0][0] = cast,no_check(Convolve_Fn_T) scaled_horiz_c;
        sf.predict[1][0][1] = cast,no_check(Convolve_Fn_T) scaled_avg_horiz_c;
    } else {
        sf.predict[0][0][0] = cast,no_check(Convolve_Fn_T) scaled_2d_c;
        sf.predict[0][0][1] = cast,no_check(Convolve_Fn_T) scaled_avg_2d_c;
        sf.predict[0][1][0] = cast,no_check(Convolve_Fn_T) scaled_2d_c;
        sf.predict[0][1][1] = cast,no_check(Convolve_Fn_T) scaled_avg_2d_c;
        sf.predict[1][0][0] = cast,no_check(Convolve_Fn_T) scaled_2d_c;
        sf.predict[1][0][1] = cast,no_check(Convolve_Fn_T) scaled_avg_2d_c;
    }

    if sf.x_step_q4 != 16 || sf.y_step_q4 != 16 {
        sf.predict[1][1][0] = cast,no_check(Convolve_Fn_T) scaled_2d_c;
        sf.predict[1][1][1] = cast,no_check(Convolve_Fn_T) scaled_avg_2d_c;
    } else {
        sf.predict[1][1][0] = cast,no_check(Convolve_Fn_T) convolve8_c;
        sf.predict[1][1][1] = cast,no_check(Convolve_Fn_T) convolve8_avg_c;
    }
}

unscaled_value :: (val: s32, sf: *Scale_Factors) -> s32 {
    return val;
}

vp9_is_scaled_in_vp9_scale :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_scale(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

vp9_is_valid_scale_in_vp9_scale :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

get_fixed_point_scale_factor :: (other_size: s32, this_size: s32) -> s32 {
    return other_size << 14 / this_size;
}

valid_ref_frame_size_in_vp9_scale :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

MV32 :: Mv32;

Mv32 :: struct {
    row: s32;
    col: s32;
}

