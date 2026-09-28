// Generated directly from C by cpp_transpiler.
clip_pixel_in_subtract :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_subtract :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_subtract :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_subtract :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_subtract :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_subtract(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_subtract(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_subtract(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_subtract :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_subtract :: (FILTER: *s16) -> s32 {
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

subtract_block_c :: (
    rows: s32,
    cols: s32,
    diff_ptr: *s16,
    diff_stride: s64,
    src_ptr: *u8,
    src_stride: s64,
    pred_ptr: *u8,
    pred_stride: s64
) {
    c: s32 = ---;

    if 0 < rows {
        for r: 0..rows - 1 {
            c = 0;
            while c < cols {
                diff_ptr[c] = cast,no_check(s16) ((cast(s32) src_ptr[c]) - cast(s32) pred_ptr[c]);
                c += 1;
            }

            diff_ptr += diff_stride;
            pred_ptr += pred_stride;
            src_ptr += src_stride;
        }
    }
}

