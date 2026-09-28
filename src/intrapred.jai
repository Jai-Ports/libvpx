// Generated directly from C by cpp_transpiler.
clip_pixel_in_intrapred :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_intrapred :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_intrapred :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_intrapred :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_intrapred :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_intrapred(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_intrapred(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_intrapred(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_intrapred :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_intrapred :: (FILTER: *s16) -> s32 {
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

d117_predictor_16x16_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    d117_predictor(dst, stride, 16, above, left);
}

d117_predictor :: (dst: *u8, stride: s64, bs: s32, above: *u8, left: *u8) {
    c: s32 = 0;
    while c < bs {
        dst[c] = cast,no_check(u8) ((((cast(s32) above[c - 1]) + cast(s32) above[c]) + 1) >> 1);
        c += 1;
    }
    dst += stride;

    dst[0] = cast,no_check(u8) (((((cast(s32) left[0]) + 2 * cast(s32) above[-1]) + cast(s32) above[0]) + 2) >> 2);
    c = 1;
    while c < bs {
        dst[c] =
            cast,no_check(u8) (((((cast(s32) above[c - 2]) + 2 * cast(s32) above[c - 1]) + cast(s32) above[c]) +
                2) >> 2);
        c += 1;
    }
    dst += stride;

    dst[0] = cast,no_check(u8) (((((cast(s32) above[-1]) + 2 * cast(s32) left[0]) + cast(s32) left[1]) + 2) >> 2);
    if 3 < bs {
        for r: 3..bs - 1 {
            dst[(cast(s64) (r - 2)) * stride] =
                cast,no_check(u8) (((((cast(s32) left[r - 3]) + 2 * cast(s32) left[r - 2]) + cast(s32) left[r - 1]) +
                    2) >> 2);
        }
    }

    if 2 < bs {
        for r: 2..bs - 1 {
            c = 1;
            while c < bs {
                dst[c] = dst[(-2 * stride + cast(s64) c) - 1];
                c += 1;
            }
            dst += stride;
        }
    }
}

d117_predictor_32x32_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    d117_predictor(dst, stride, 32, above, left);
}

d117_predictor_4x4_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    I := cast,no_check(s32) left[0];
    J := cast,no_check(s32) left[1];
    K := cast,no_check(s32) left[2];
    X := cast,no_check(s32) above[-1];
    A := cast,no_check(s32) above[0];
    B := cast,no_check(s32) above[1];
    C := cast,no_check(s32) above[2];
    D := cast,no_check(s32) above[3];
    dst[1 + 2 * stride] = cast,no_check(u8) ((X + A + 1) >> 1);
    dst[0 + 0 * stride] = dst[1 + 2 * stride];
    dst[2 + 2 * stride] = cast,no_check(u8) ((A + B + 1) >> 1);
    dst[1 + 0 * stride] = dst[2 + 2 * stride];
    dst[3 + 2 * stride] = cast,no_check(u8) ((B + C + 1) >> 1);
    dst[2 + 0 * stride] = dst[3 + 2 * stride];
    dst[3 + 0 * stride] = cast,no_check(u8) ((C + D + 1) >> 1);

    dst[0 + 3 * stride] = cast,no_check(u8) ((K + 2 * J + I + 2) >> 2);
    dst[0 + 2 * stride] = cast,no_check(u8) ((J + 2 * I + X + 2) >> 2);
    dst[1 + 3 * stride] = cast,no_check(u8) ((I + 2 * X + A + 2) >> 2);
    dst[0 + 1 * stride] = dst[1 + 3 * stride];
    dst[2 + 3 * stride] = cast,no_check(u8) ((X + 2 * A + B + 2) >> 2);
    dst[1 + 1 * stride] = dst[2 + 3 * stride];
    dst[3 + 3 * stride] = cast,no_check(u8) ((A + 2 * B + C + 2) >> 2);
    dst[2 + 1 * stride] = dst[3 + 3 * stride];
    dst[3 + 1 * stride] = cast,no_check(u8) ((B + 2 * C + D + 2) >> 2);
}

d117_predictor_8x8_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    d117_predictor(dst, stride, 8, above, left);
}

d135_predictor_16x16_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    d135_predictor(dst, stride, 16, above, left);
}

d135_predictor :: (dst: *u8, stride: s64, bs: s32, above: *u8, left: *u8) {
    border: [63] u8 = ---;

    i: s32 = 0;
    while i < bs - 2 {
        border[i] =
            cast,no_check(u8) (((((cast(s32) left[bs - 3 - i]) + 2 * cast(s32) left[bs - 2 - i]) + cast(s32) left[bs - 1 - i]) +
                2) >> 2);
        i += 1;
    }
    border[bs - 2] =
        cast,no_check(u8) (((((cast(s32) above[-1]) + 2 * cast(s32) left[0]) + cast(s32) left[1]) +
            2) >> 2);
    border[bs - 1] =
        cast,no_check(u8) (((((cast(s32) left[0]) + 2 * cast(s32) above[-1]) + cast(s32) above[0]) +
            2) >> 2);
    border[bs - 0] =
        cast,no_check(u8) (((((cast(s32) above[-1]) + 2 * cast(s32) above[0]) + cast(s32) above[1]) +
            2) >> 2);

    i = 0;
    while i < bs - 2 {
        border[bs + 1 + i] =
            cast,no_check(u8) (((((cast(s32) above[i]) + 2 * cast(s32) above[i + 1]) + cast(s32) above[i + 2]) +
                2) >> 2);
        i += 1;
    }

    i = 0;
    while i < bs {
        copy_memory(dst + (cast(s64) i) * stride, border.data + bs - 1 - i, cast,no_check(u64) bs);
        i += 1;
    }
}

d135_predictor_32x32_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    d135_predictor(dst, stride, 32, above, left);
}

d135_predictor_4x4_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    I := cast,no_check(s32) left[0];
    J := cast,no_check(s32) left[1];
    K := cast,no_check(s32) left[2];
    L := cast,no_check(s32) left[3];
    X := cast,no_check(s32) above[-1];
    A := cast,no_check(s32) above[0];
    B := cast,no_check(s32) above[1];
    C := cast,no_check(s32) above[2];
    D := cast,no_check(s32) above[3];

    dst[0 + 3 * stride] = cast,no_check(u8) ((J + 2 * K + L + 2) >> 2);
    dst[0 + 2 * stride] = cast,no_check(u8) ((I + 2 * J + K + 2) >> 2);
    dst[1 + 3 * stride] = dst[0 + 2 * stride];
    dst[0 + 1 * stride] = cast,no_check(u8) ((X + 2 * I + J + 2) >> 2);
    dst[1 + 2 * stride] = dst[0 + 1 * stride];
    dst[2 + 3 * stride] = dst[1 + 2 * stride];
    dst[0 + 0 * stride] = cast,no_check(u8) ((A + 2 * X + I + 2) >> 2);
    dst[1 + 1 * stride] = dst[0 + 0 * stride];
    dst[2 + 2 * stride] = dst[1 + 1 * stride];
    dst[3 + 3 * stride] = dst[2 + 2 * stride];
    dst[1 + 0 * stride] = cast,no_check(u8) ((B + 2 * A + X + 2) >> 2);
    dst[2 + 1 * stride] = dst[1 + 0 * stride];
    dst[3 + 2 * stride] = dst[2 + 1 * stride];
    dst[2 + 0 * stride] = cast,no_check(u8) ((C + 2 * B + A + 2) >> 2);
    dst[3 + 1 * stride] = dst[2 + 0 * stride];
    dst[3 + 0 * stride] = cast,no_check(u8) ((D + 2 * C + B + 2) >> 2);
}

d135_predictor_8x8_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    d135_predictor(dst, stride, 8, above, left);
}

d153_predictor_16x16_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    d153_predictor(dst, stride, 16, above, left);
}

d153_predictor :: (dst: *u8, stride: s64, bs: s32, above: *u8, left: *u8) {
    dst[0] = cast,no_check(u8) ((((cast(s32) above[-1]) + cast(s32) left[0]) + 1) >> 1);
    if 1 < bs {
        for r: 1..bs - 1 {
            dst[(cast(s64) r) * stride] = cast,no_check(u8) ((((cast(s32) left[r - 1]) + cast(s32) left[r]) + 1) >> 1);
        }
    }
    dst += 1;

    dst[0] = cast,no_check(u8) (((((cast(s32) left[0]) + 2 * cast(s32) above[-1]) + cast(s32) above[0]) + 2) >> 2);
    dst[stride] = cast,no_check(u8) (((((cast(s32) above[-1]) + 2 * cast(s32) left[0]) + cast(s32) left[1]) + 2) >> 2);
    if 2 < bs {
        for r: 2..bs - 1 {
            dst[(cast(s64) r) * stride] =
                cast,no_check(u8) (((((cast(s32) left[r - 2]) + 2 * cast(s32) left[r - 1]) + cast(s32) left[r]) +
                    2) >> 2);
        }
    }
    dst += 1;

    c: s32 = 0;
    while c < bs - 2 {
        dst[c] =
            cast,no_check(u8) (((((cast(s32) above[c - 1]) + 2 * cast(s32) above[c]) + cast(s32) above[c + 1]) +
                2) >> 2);
        c += 1;
    }
    dst += stride;

    if 1 < bs {
        for r: 1..bs - 1 {
            c = 0;
            while c < bs - 2 {
                dst[c] = dst[(-stride + cast(s64) c) - 2];
                c += 1;
            }
            dst += stride;
        }
    }
}

d153_predictor_32x32_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    d153_predictor(dst, stride, 32, above, left);
}

d153_predictor_4x4_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    I := cast,no_check(s32) left[0];
    J := cast,no_check(s32) left[1];
    K := cast,no_check(s32) left[2];
    L := cast,no_check(s32) left[3];
    X := cast,no_check(s32) above[-1];
    A := cast,no_check(s32) above[0];
    B := cast,no_check(s32) above[1];
    C := cast,no_check(s32) above[2];

    dst[2 + 1 * stride] = cast,no_check(u8) ((I + X + 1) >> 1);
    dst[0 + 0 * stride] = dst[2 + 1 * stride];
    dst[2 + 2 * stride] = cast,no_check(u8) ((J + I + 1) >> 1);
    dst[0 + 1 * stride] = dst[2 + 2 * stride];
    dst[2 + 3 * stride] = cast,no_check(u8) ((K + J + 1) >> 1);
    dst[0 + 2 * stride] = dst[2 + 3 * stride];
    dst[0 + 3 * stride] = cast,no_check(u8) ((L + K + 1) >> 1);

    dst[3 + 0 * stride] = cast,no_check(u8) ((A + 2 * B + C + 2) >> 2);
    dst[2 + 0 * stride] = cast,no_check(u8) ((X + 2 * A + B + 2) >> 2);
    dst[3 + 1 * stride] = cast,no_check(u8) ((I + 2 * X + A + 2) >> 2);
    dst[1 + 0 * stride] = dst[3 + 1 * stride];
    dst[3 + 2 * stride] = cast,no_check(u8) ((J + 2 * I + X + 2) >> 2);
    dst[1 + 1 * stride] = dst[3 + 2 * stride];
    dst[3 + 3 * stride] = cast,no_check(u8) ((K + 2 * J + I + 2) >> 2);
    dst[1 + 2 * stride] = dst[3 + 3 * stride];
    dst[1 + 3 * stride] = cast,no_check(u8) ((L + 2 * K + J + 2) >> 2);
}

d153_predictor_8x8_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    d153_predictor(dst, stride, 8, above, left);
}

d207_predictor_16x16_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    d207_predictor(dst, stride, 16, above, left);
}

d207_predictor :: (dst: *u8, stride: s64, bs: s32, above: *u8, left: *u8) {
    r: s32 = 0;
    while r < bs - 1 {
        dst[(cast(s64) r) * stride] = cast,no_check(u8) ((((cast(s32) left[r]) + cast(s32) left[r + 1]) + 1) >> 1);
        r += 1;
    }
    dst[(cast(s64) (bs - 1)) * stride] = left[bs - 1];
    dst += 1;

    r = 0;
    while r < bs - 2 {
        dst[(cast(s64) r) * stride] =
            cast,no_check(u8) (((((cast(s32) left[r]) + 2 * cast(s32) left[r + 1]) + cast(s32) left[r + 2]) +
                2) >> 2);
        r += 1;
    }
    dst[(cast(s64) (bs - 2)) * stride] =
        cast,no_check(u8) (((((cast(s32) left[bs - 2]) + 2 * cast(s32) left[bs - 1]) + cast(s32) left[bs - 1]) +
            2) >> 2);
    dst[(cast(s64) (bs - 1)) * stride] = left[bs - 1];
    dst += 1;

    c: s32 = 0;
    while c < bs - 2 {
        dst[(cast(s64) (bs - 1)) * stride + cast(s64) c] = left[bs - 1];
        c += 1;
    }

    r = bs - 2;
    while r >= 0 {
        c = 0;
        while c < bs - 2 {
            dst[(cast(s64) r) * stride + cast(s64) c] = dst[((cast(s64) (r + 1)) * stride + cast(s64) c) - 2];
            c += 1;
        }
        r -= 1;
    }
}

d207_predictor_32x32_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    d207_predictor(dst, stride, 32, above, left);
}

d207_predictor_4x4_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    I := cast,no_check(s32) left[0];
    J := cast,no_check(s32) left[1];
    K := cast,no_check(s32) left[2];
    L := cast,no_check(s32) left[3];

    dst[0 + 0 * stride] = cast,no_check(u8) ((I + J + 1) >> 1);
    dst[0 + 1 * stride] = cast,no_check(u8) ((J + K + 1) >> 1);
    dst[2 + 0 * stride] = dst[0 + 1 * stride];
    dst[0 + 2 * stride] = cast,no_check(u8) ((K + L + 1) >> 1);
    dst[2 + 1 * stride] = dst[0 + 2 * stride];
    dst[1 + 0 * stride] = cast,no_check(u8) ((I + 2 * J + K + 2) >> 2);
    dst[1 + 1 * stride] = cast,no_check(u8) ((J + 2 * K + L + 2) >> 2);
    dst[3 + 0 * stride] = dst[1 + 1 * stride];
    dst[1 + 2 * stride] = cast,no_check(u8) ((K + 2 * L + L + 2) >> 2);
    dst[3 + 1 * stride] = dst[1 + 2 * stride];
    dst[3 + 3 * stride] = cast,no_check(u8) L;
    dst[2 + 3 * stride] = dst[3 + 3 * stride];
    dst[1 + 3 * stride] = dst[2 + 3 * stride];
    dst[0 + 3 * stride] = dst[1 + 3 * stride];
    dst[2 + 2 * stride] = dst[0 + 3 * stride];
    dst[3 + 2 * stride] = dst[2 + 2 * stride];
}

d207_predictor_8x8_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    d207_predictor(dst, stride, 8, above, left);
}

d45_predictor_16x16_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    d45_predictor(dst, stride, 16, above, left);
}

d45_predictor :: (dst: *u8, stride: s64, bs: s32, above: *u8, left: *u8) {
    ABOVE_RIGHT := above[bs - 1];
    DST_ROW0 := dst;
    size: s32 = ---;

    x: s32 = 0;
    while x < bs - 1 {
        dst[x] =
            cast,no_check(u8) (((((cast(s32) above[x]) + 2 * cast(s32) above[x + 1]) + cast(s32) above[x + 2]) +
                2) >> 2);
        x += 1;
    }
    dst[bs - 1] = ABOVE_RIGHT;
    dst += stride;
    x = 1;
    size = bs - 2;
    while x < bs {
        copy_memory(dst, DST_ROW0 + x, cast,no_check(u64) size);
        fill_memory(dst + size, cast,no_check(s32) ABOVE_RIGHT, cast,no_check(u64) (x + 1));
        dst += stride;
        x += 1;
        size -= 1;
    }
}

d45_predictor_32x32_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    d45_predictor(dst, stride, 32, above, left);
}

d45_predictor_4x4_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    A := cast,no_check(s32) above[0];
    B := cast,no_check(s32) above[1];
    C := cast,no_check(s32) above[2];
    D := cast,no_check(s32) above[3];
    E := cast,no_check(s32) above[4];
    F := cast,no_check(s32) above[5];
    G := cast,no_check(s32) above[6];
    H := cast,no_check(s32) above[7];

    dst[0 + 0 * stride] = cast,no_check(u8) ((A + 2 * B + C + 2) >> 2);
    dst[0 + 1 * stride] = cast,no_check(u8) ((B + 2 * C + D + 2) >> 2);
    dst[1 + 0 * stride] = dst[0 + 1 * stride];
    dst[0 + 2 * stride] = cast,no_check(u8) ((C + 2 * D + E + 2) >> 2);
    dst[1 + 1 * stride] = dst[0 + 2 * stride];
    dst[2 + 0 * stride] = dst[1 + 1 * stride];
    dst[0 + 3 * stride] = cast,no_check(u8) ((D + 2 * E + F + 2) >> 2);
    dst[1 + 2 * stride] = dst[0 + 3 * stride];
    dst[2 + 1 * stride] = dst[1 + 2 * stride];
    dst[3 + 0 * stride] = dst[2 + 1 * stride];
    dst[1 + 3 * stride] = cast,no_check(u8) ((E + 2 * F + G + 2) >> 2);
    dst[2 + 2 * stride] = dst[1 + 3 * stride];
    dst[3 + 1 * stride] = dst[2 + 2 * stride];
    dst[2 + 3 * stride] = cast,no_check(u8) ((F + 2 * G + H + 2) >> 2);
    dst[3 + 2 * stride] = dst[2 + 3 * stride];
    dst[3 + 3 * stride] = cast,no_check(u8) H;
}

d45_predictor_8x8_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    d45_predictor(dst, stride, 8, above, left);
}

d45e_predictor_4x4_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    A := cast,no_check(s32) above[0];
    B := cast,no_check(s32) above[1];
    C := cast,no_check(s32) above[2];
    D := cast,no_check(s32) above[3];
    E := cast,no_check(s32) above[4];
    F := cast,no_check(s32) above[5];
    G := cast,no_check(s32) above[6];
    H := cast,no_check(s32) above[7];

    dst[0 + 0 * stride] = cast,no_check(u8) ((A + 2 * B + C + 2) >> 2);
    dst[0 + 1 * stride] = cast,no_check(u8) ((B + 2 * C + D + 2) >> 2);
    dst[1 + 0 * stride] = dst[0 + 1 * stride];
    dst[0 + 2 * stride] = cast,no_check(u8) ((C + 2 * D + E + 2) >> 2);
    dst[1 + 1 * stride] = dst[0 + 2 * stride];
    dst[2 + 0 * stride] = dst[1 + 1 * stride];
    dst[0 + 3 * stride] = cast,no_check(u8) ((D + 2 * E + F + 2) >> 2);
    dst[1 + 2 * stride] = dst[0 + 3 * stride];
    dst[2 + 1 * stride] = dst[1 + 2 * stride];
    dst[3 + 0 * stride] = dst[2 + 1 * stride];
    dst[1 + 3 * stride] = cast,no_check(u8) ((E + 2 * F + G + 2) >> 2);
    dst[2 + 2 * stride] = dst[1 + 3 * stride];
    dst[3 + 1 * stride] = dst[2 + 2 * stride];
    dst[2 + 3 * stride] = cast,no_check(u8) ((F + 2 * G + H + 2) >> 2);
    dst[3 + 2 * stride] = dst[2 + 3 * stride];
    dst[3 + 3 * stride] = cast,no_check(u8) ((G + 2 * H + H + 2) >> 2);
}

d63_predictor_16x16_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    d63_predictor(dst, stride, 16, above, left);
}

d63_predictor :: (dst: *u8, stride: s64, bs: s32, above: *u8, left: *u8) {
    r: s32 = ---;
    size: s32 = ---;

    if 0 < bs {
        for c: 0..bs - 1 {
            dst[c] = cast,no_check(u8) ((((cast(s32) above[c]) + cast(s32) above[c + 1]) + 1) >> 1);
            dst[stride + cast(s64) c] =
                cast,no_check(u8) (((((cast(s32) above[c]) + 2 * cast(s32) above[c + 1]) + cast(s32) above[c + 2]) +
                    2) >> 2);
        }
    }
    r = 2;
    size = bs - 2;
    while r < bs {
        copy_memory(dst + (cast(s64) (r + 0)) * stride, dst + r >> 1, cast,no_check(u64) size);
        fill_memory(
            dst + (cast(s64) (r + 0)) * stride + size,
            cast,no_check(s32) above[bs - 1],
            cast,no_check(u64) (bs - size)
        );
        copy_memory(dst + (cast(s64) (r + 1)) * stride, dst + stride + r >> 1, cast,no_check(u64) size);
        fill_memory(
            dst + (cast(s64) (r + 1)) * stride + size,
            cast,no_check(s32) above[bs - 1],
            cast,no_check(u64) (bs - size)
        );
        r += 2;
        size -= 1;
    }
}

d63_predictor_32x32_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    d63_predictor(dst, stride, 32, above, left);
}

d63_predictor_4x4_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    A := cast,no_check(s32) above[0];
    B := cast,no_check(s32) above[1];
    C := cast,no_check(s32) above[2];
    D := cast,no_check(s32) above[3];
    E := cast,no_check(s32) above[4];
    F := cast,no_check(s32) above[5];
    G := cast,no_check(s32) above[6];

    dst[0 + 0 * stride] = cast,no_check(u8) ((A + B + 1) >> 1);
    dst[0 + 2 * stride] = cast,no_check(u8) ((B + C + 1) >> 1);
    dst[1 + 0 * stride] = dst[0 + 2 * stride];
    dst[1 + 2 * stride] = cast,no_check(u8) ((C + D + 1) >> 1);
    dst[2 + 0 * stride] = dst[1 + 2 * stride];
    dst[2 + 2 * stride] = cast,no_check(u8) ((D + E + 1) >> 1);
    dst[3 + 0 * stride] = dst[2 + 2 * stride];
    dst[3 + 2 * stride] = cast,no_check(u8) ((E + F + 1) >> 1);

    dst[0 + 1 * stride] = cast,no_check(u8) ((A + 2 * B + C + 2) >> 2);
    dst[0 + 3 * stride] = cast,no_check(u8) ((B + 2 * C + D + 2) >> 2);
    dst[1 + 1 * stride] = dst[0 + 3 * stride];
    dst[1 + 3 * stride] = cast,no_check(u8) ((C + 2 * D + E + 2) >> 2);
    dst[2 + 1 * stride] = dst[1 + 3 * stride];
    dst[2 + 3 * stride] = cast,no_check(u8) ((D + 2 * E + F + 2) >> 2);
    dst[3 + 1 * stride] = dst[2 + 3 * stride];
    dst[3 + 3 * stride] = cast,no_check(u8) ((E + 2 * F + G + 2) >> 2);
}

d63_predictor_8x8_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    d63_predictor(dst, stride, 8, above, left);
}

d63e_predictor_4x4_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    A := cast,no_check(s32) above[0];
    B := cast,no_check(s32) above[1];
    C := cast,no_check(s32) above[2];
    D := cast,no_check(s32) above[3];
    E := cast,no_check(s32) above[4];
    F := cast,no_check(s32) above[5];
    G := cast,no_check(s32) above[6];
    H := cast,no_check(s32) above[7];

    dst[0 + 0 * stride] = cast,no_check(u8) ((A + B + 1) >> 1);
    dst[0 + 2 * stride] = cast,no_check(u8) ((B + C + 1) >> 1);
    dst[1 + 0 * stride] = dst[0 + 2 * stride];
    dst[1 + 2 * stride] = cast,no_check(u8) ((C + D + 1) >> 1);
    dst[2 + 0 * stride] = dst[1 + 2 * stride];
    dst[2 + 2 * stride] = cast,no_check(u8) ((D + E + 1) >> 1);
    dst[3 + 0 * stride] = dst[2 + 2 * stride];
    dst[3 + 2 * stride] = cast,no_check(u8) ((E + 2 * F + G + 2) >> 2);

    dst[0 + 1 * stride] = cast,no_check(u8) ((A + 2 * B + C + 2) >> 2);
    dst[0 + 3 * stride] = cast,no_check(u8) ((B + 2 * C + D + 2) >> 2);
    dst[1 + 1 * stride] = dst[0 + 3 * stride];
    dst[1 + 3 * stride] = cast,no_check(u8) ((C + 2 * D + E + 2) >> 2);
    dst[2 + 1 * stride] = dst[1 + 3 * stride];
    dst[2 + 3 * stride] = cast,no_check(u8) ((D + 2 * E + F + 2) >> 2);
    dst[3 + 1 * stride] = dst[2 + 3 * stride];
    dst[3 + 3 * stride] = cast,no_check(u8) ((F + 2 * G + H + 2) >> 2);
}

dc_128_predictor_16x16_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    dc_128_predictor(dst, stride, 16, above, left);
}

dc_128_predictor :: (dst: *u8, stride: s64, bs: s32, above: *u8, left: *u8) {
    if 0 < bs {
        for r: 0..bs - 1 {
            fill_memory(dst, 128, cast,no_check(u64) bs);
            dst += stride;
        }
    }
}

dc_128_predictor_32x32_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    dc_128_predictor(dst, stride, 32, above, left);
}

dc_128_predictor_4x4_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    dc_128_predictor(dst, stride, 4, above, left);
}

dc_128_predictor_8x8_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    dc_128_predictor(dst, stride, 8, above, left);
}

dc_left_predictor_16x16_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    dc_left_predictor(dst, stride, 16, above, left);
}

dc_left_predictor :: (dst: *u8, stride: s64, bs: s32, above: *u8, left: *u8) {
    sum: s32 = 0;

    if 0 < bs {
        for i: 0..bs - 1 {
            sum += cast,no_check(s32) left[i];
        }
    }
    expected_dc := (sum + bs >> 1) / bs;

    if 0 < bs {
        for r: 0..bs - 1 {
            fill_memory(dst, expected_dc, cast,no_check(u64) bs);
            dst += stride;
        }
    }
}

dc_left_predictor_32x32_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    dc_left_predictor(dst, stride, 32, above, left);
}

dc_left_predictor_4x4_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    dc_left_predictor(dst, stride, 4, above, left);
}

dc_left_predictor_8x8_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    dc_left_predictor(dst, stride, 8, above, left);
}

dc_predictor_16x16_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    dc_predictor(dst, stride, 16, above, left);
}

dc_predictor :: (dst: *u8, stride: s64, bs: s32, above: *u8, left: *u8) {
    sum: s32 = 0;
    COUNT := 2 * bs;

    if 0 < bs {
        for i: 0..bs - 1 {
            sum += cast,no_check(s32) above[i];
            sum += cast,no_check(s32) left[i];
        }
    }

    expected_dc := (sum + COUNT >> 1) / COUNT;

    if 0 < bs {
        for r: 0..bs - 1 {
            fill_memory(dst, expected_dc, cast,no_check(u64) bs);
            dst += stride;
        }
    }
}

dc_predictor_32x32_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    dc_predictor(dst, stride, 32, above, left);
}

dc_predictor_4x4_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    dc_predictor(dst, stride, 4, above, left);
}

dc_predictor_8x8_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    dc_predictor(dst, stride, 8, above, left);
}

dc_top_predictor_16x16_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    dc_top_predictor(dst, stride, 16, above, left);
}

dc_top_predictor :: (dst: *u8, stride: s64, bs: s32, above: *u8, left: *u8) {
    sum: s32 = 0;

    if 0 < bs {
        for i: 0..bs - 1 {
            sum += cast,no_check(s32) above[i];
        }
    }
    expected_dc := (sum + bs >> 1) / bs;

    if 0 < bs {
        for r: 0..bs - 1 {
            fill_memory(dst, expected_dc, cast,no_check(u64) bs);
            dst += stride;
        }
    }
}

dc_top_predictor_32x32_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    dc_top_predictor(dst, stride, 32, above, left);
}

dc_top_predictor_4x4_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    dc_top_predictor(dst, stride, 4, above, left);
}

dc_top_predictor_8x8_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    dc_top_predictor(dst, stride, 8, above, left);
}

h_predictor_16x16_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    h_predictor(dst, stride, 16, above, left);
}

h_predictor :: (dst: *u8, stride: s64, bs: s32, above: *u8, left: *u8) {
    if 0 < bs {
        for r: 0..bs - 1 {
            fill_memory(dst, cast,no_check(s32) left[r], cast,no_check(u64) bs);
            dst += stride;
        }
    }
}

h_predictor_32x32_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    h_predictor(dst, stride, 32, above, left);
}

h_predictor_4x4_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    h_predictor(dst, stride, 4, above, left);
}

h_predictor_8x8_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    h_predictor(dst, stride, 8, above, left);
}

he_predictor_4x4_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    H := cast,no_check(s32) above[-1];
    I := cast,no_check(s32) left[0];
    J := cast,no_check(s32) left[1];
    K := cast,no_check(s32) left[2];
    L := cast,no_check(s32) left[3];

    fill_memory(dst + stride * 0, (H + 2 * I + J + 2) >> 2, 4);
    fill_memory(dst + stride * 1, (I + 2 * J + K + 2) >> 2, 4);
    fill_memory(dst + stride * 2, (J + 2 * K + L + 2) >> 2, 4);
    fill_memory(dst + stride * 3, (K + 2 * L + L + 2) >> 2, 4);
}

tm_predictor_16x16_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    tm_predictor(dst, stride, 16, above, left);
}

tm_predictor :: (dst: *u8, stride: s64, bs: s32, above: *u8, left: *u8) {
    c: s32 = ---;
    ytop_left := cast,no_check(s32) above[-1];

    if 0 < bs {
        for r: 0..bs - 1 {
            c = 0;
            while c < bs {
                dst[c] = clip_pixel_in_intrapred(((cast(s32) left[r]) + cast(s32) above[c]) - ytop_left);
                c += 1;
            }
            dst += stride;
        }
    }
}

tm_predictor_32x32_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    tm_predictor(dst, stride, 32, above, left);
}

tm_predictor_4x4_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    tm_predictor(dst, stride, 4, above, left);
}

tm_predictor_8x8_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    tm_predictor(dst, stride, 8, above, left);
}

v_predictor_16x16_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    v_predictor(dst, stride, 16, above, left);
}

v_predictor :: (dst: *u8, stride: s64, bs: s32, above: *u8, left: *u8) {
    if 0 < bs {
        for r: 0..bs - 1 {
            copy_memory(dst, above, cast,no_check(u64) bs);
            dst += stride;
        }
    }
}

v_predictor_32x32_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    v_predictor(dst, stride, 32, above, left);
}

v_predictor_4x4_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    v_predictor(dst, stride, 4, above, left);
}

v_predictor_8x8_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    v_predictor(dst, stride, 8, above, left);
}

ve_predictor_4x4_c :: (dst: *u8, stride: s64, above: *u8, left: *u8) {
    H := cast,no_check(s32) above[-1];
    I := cast,no_check(s32) above[0];
    J := cast,no_check(s32) above[1];
    K := cast,no_check(s32) above[2];
    L := cast,no_check(s32) above[3];
    M := cast,no_check(s32) above[4];

    dst[0] = cast,no_check(u8) ((H + 2 * I + J + 2) >> 2);
    dst[1] = cast,no_check(u8) ((I + 2 * J + K + 2) >> 2);
    dst[2] = cast,no_check(u8) ((J + 2 * K + L + 2) >> 2);
    dst[3] = cast,no_check(u8) ((K + 2 * L + M + 2) >> 2);
    copy_memory(dst + stride * 1, dst, 4);
    copy_memory(dst + stride * 2, dst, 4);
    copy_memory(dst + stride * 3, dst, 4);
}

