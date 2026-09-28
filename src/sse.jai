clip_pixel_in_sse :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_sse :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_sse :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_sse :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_sse :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_sse(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_sse(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_sse(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_sse :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_sse :: (FILTER: *s16) -> s32 {
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

sse_c :: (a: *u8, a_stride: s32, b: *u8, b_stride: s32, width: s32, height: s32) -> s64 {
    x: s32 = ---;
    sse: s64 = 0;

    if 0 < height {
        for y: 0..height - 1 {
            x = 0;
            while x < width {
                DIFF: s32 = absolute_value((cast(s32) a[x]) - cast(s32) b[x]);
                sse += cast,no_check(s64) (DIFF * DIFF);
                x += 1;
            }

            a += a_stride;
            b += b_stride;
        }
    }
    return sse;
}

