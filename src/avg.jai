clip_pixel_in_avg :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_avg :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_avg :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_avg :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_avg :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_avg(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_avg(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_avg(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_avg :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_avg :: (FILTER: *s16) -> s32 {
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

avg_4x4_c :: (s: *u8, p: s32) -> u32 {
    j: s32 = ---;
    sum: s32 = 0;
    i: s32 = 0;
    while i < 4 {
        j = 0;
        while j < 4 {
            sum += cast,no_check(s32) s[j];
            j += 1;
        }
        i += 1;
        s += p;
    }

    return cast,no_check(u32) ((sum + 8) >> 4);
}

avg_8x8_c :: (s: *u8, p: s32) -> u32 {
    j: s32 = ---;
    sum: s32 = 0;
    i: s32 = 0;
    while i < 8 {
        j = 0;
        while j < 8 {
            sum += cast,no_check(s32) s[j];
            j += 1;
        }
        i += 1;
        s += p;
    }

    return cast,no_check(u32) ((sum + 32) >> 6);
}

hadamard_16x16_c :: (src_diff: *s16, src_stride: s64, coeff: *Tran_Low_T) {
    for idx: 0..cast(s32) 4 - 1 {
        src_ptr := src_diff + (cast(s64) (idx >> 1 * 8)) * src_stride + idx & 0x1 * 8;
        hadamard_8x8_c(src_ptr, src_stride, coeff + idx * 64);
    }

    for idx: 0..cast(s32) 64 - 1 {
        a0 := coeff[0];
        a1 := coeff[64];
        a2 := coeff[128];
        a3 := coeff[192];

        b0 := cast,no_check(Tran_Low_T) (((cast(s32) a0) + cast(s32) a1) >> 1);
        b1 := cast,no_check(Tran_Low_T) (((cast(s32) a0) - cast(s32) a1) >> 1);
        b2 := cast,no_check(Tran_Low_T) (((cast(s32) a2) + cast(s32) a3) >> 1);
        b3 := cast,no_check(Tran_Low_T) (((cast(s32) a2) - cast(s32) a3) >> 1);

        coeff[0] = cast,no_check(Tran_Low_T) ((cast(s32) b0) + cast(s32) b2);
        coeff[64] = cast,no_check(Tran_Low_T) ((cast(s32) b1) + cast(s32) b3);
        coeff[128] = cast,no_check(Tran_Low_T) ((cast(s32) b0) - cast(s32) b2);
        coeff[192] = cast,no_check(Tran_Low_T) ((cast(s32) b1) - cast(s32) b3);

        coeff += 1;
    }
}

hadamard_8x8_c :: (src_diff: *s16, src_stride: s64, coeff: *Tran_Low_T) {
    buffer: [64] s16 = ---;
    buffer2: [64] s16 = ---;
    tmp_buf := buffer.data + 0;
    for idx: 0..cast(s32) 8 - 1 {
        hadamard_col8(src_diff, src_stride, tmp_buf);

        tmp_buf += 8;
        src_diff += 1;
    }

    tmp_buf = buffer.data + 0;
    for idx: 0..cast(s32) 8 - 1 {
        hadamard_col8(tmp_buf, 8, buffer2.data + 8 * idx);

        tmp_buf += 1;
    }

    for idx: 0..cast(s32) 64 - 1 {
        coeff[idx] = buffer2[idx];
    }
}

hadamard_col8 :: (src_diff: *s16, src_stride: s64, coeff: *s16) {
    b0 := cast,no_check(s16) ((cast(s32) src_diff[0 * src_stride]) + cast(s32) src_diff[1 * src_stride]);
    b1 := cast,no_check(s16) ((cast(s32) src_diff[0 * src_stride]) - cast(s32) src_diff[1 * src_stride]);
    b2 := cast,no_check(s16) ((cast(s32) src_diff[2 * src_stride]) + cast(s32) src_diff[3 * src_stride]);
    b3 := cast,no_check(s16) ((cast(s32) src_diff[2 * src_stride]) - cast(s32) src_diff[3 * src_stride]);
    b4 := cast,no_check(s16) ((cast(s32) src_diff[4 * src_stride]) + cast(s32) src_diff[5 * src_stride]);
    b5 := cast,no_check(s16) ((cast(s32) src_diff[4 * src_stride]) - cast(s32) src_diff[5 * src_stride]);
    b6 := cast,no_check(s16) ((cast(s32) src_diff[6 * src_stride]) + cast(s32) src_diff[7 * src_stride]);
    b7 := cast,no_check(s16) ((cast(s32) src_diff[6 * src_stride]) - cast(s32) src_diff[7 * src_stride]);

    c0 := cast,no_check(s16) ((cast(s32) b0) + cast(s32) b2);
    c1 := cast,no_check(s16) ((cast(s32) b1) + cast(s32) b3);
    c2 := cast,no_check(s16) ((cast(s32) b0) - cast(s32) b2);
    c3 := cast,no_check(s16) ((cast(s32) b1) - cast(s32) b3);
    c4 := cast,no_check(s16) ((cast(s32) b4) + cast(s32) b6);
    c5 := cast,no_check(s16) ((cast(s32) b5) + cast(s32) b7);
    c6 := cast,no_check(s16) ((cast(s32) b4) - cast(s32) b6);
    c7 := cast,no_check(s16) ((cast(s32) b5) - cast(s32) b7);

    coeff[0] = cast,no_check(s16) ((cast(s32) c0) + cast(s32) c4);
    coeff[7] = cast,no_check(s16) ((cast(s32) c1) + cast(s32) c5);
    coeff[3] = cast,no_check(s16) ((cast(s32) c2) + cast(s32) c6);
    coeff[4] = cast,no_check(s16) ((cast(s32) c3) + cast(s32) c7);
    coeff[2] = cast,no_check(s16) ((cast(s32) c0) - cast(s32) c4);
    coeff[6] = cast,no_check(s16) ((cast(s32) c1) - cast(s32) c5);
    coeff[1] = cast,no_check(s16) ((cast(s32) c2) - cast(s32) c6);
    coeff[5] = cast,no_check(s16) ((cast(s32) c3) - cast(s32) c7);
}

hadamard_32x32_c :: (src_diff: *s16, src_stride: s64, coeff: *Tran_Low_T) {
    for idx: 0..cast(s32) 4 - 1 {
        src_ptr := src_diff + (cast(s64) (idx >> 1 * 16)) * src_stride + idx & 0x1 * 16;
        hadamard_16x16_c(src_ptr, src_stride, coeff + idx * 256);
    }

    for idx: 0..cast(s32) 256 - 1 {
        a0 := coeff[0];
        a1 := coeff[256];
        a2 := coeff[512];
        a3 := coeff[768];

        b0 := cast,no_check(Tran_Low_T) (((cast(s32) a0) + cast(s32) a1) >> 2);
        b1 := cast,no_check(Tran_Low_T) (((cast(s32) a0) - cast(s32) a1) >> 2);
        b2 := cast,no_check(Tran_Low_T) (((cast(s32) a2) + cast(s32) a3) >> 2);
        b3 := cast,no_check(Tran_Low_T) (((cast(s32) a2) - cast(s32) a3) >> 2);

        coeff[0] = cast,no_check(Tran_Low_T) ((cast(s32) b0) + cast(s32) b2);
        coeff[256] = cast,no_check(Tran_Low_T) ((cast(s32) b1) + cast(s32) b3);
        coeff[512] = cast,no_check(Tran_Low_T) ((cast(s32) b0) - cast(s32) b2);
        coeff[768] = cast,no_check(Tran_Low_T) ((cast(s32) b1) - cast(s32) b3);

        coeff += 1;
    }
}

int_pro_col_c :: (ref: *u8, WIDTH: s32) -> s16 {
    sum: s16 = 0;

    if 0 < WIDTH {
        for idx: 0..WIDTH - 1 {
            sum = cast,no_check(s16) ((cast,no_check(s32) sum) + cast,no_check(s32) ref[idx]);
        }
    }
    return sum;
}

int_pro_row_c :: (hbuf: *s16, ref: *u8, REF_STRIDE: s32, HEIGHT: s32) {
    NORM_FACTOR := HEIGHT >> 1;

    for idx: 0..cast(s32) 16 - 1 {
        hbuf[idx] = 0;

        if 0 < HEIGHT {
            for i: 0..HEIGHT - 1 {
                hbuf[idx] = cast,no_check(s16) ((cast,no_check(s32) hbuf[idx]) + cast,no_check(s32) ref[i * REF_STRIDE]);
            }
        }

        hbuf[idx] = cast,no_check(s16) ((cast,no_check(s32) hbuf[idx]) / NORM_FACTOR);
        ref += 1;
    }
}

minmax_8x8_c :: (s: *u8, p: s32, d: *u8, dp: s32, min: *s32, max: *s32) {
    j: s32 = ---;
    min.* = 255;
    max.* = 0;
    i: s32 = 0;
    while i < 8 {
        j = 0;
        while j < 8 {
            diff := absolute_value((cast(s32) s[j]) - cast(s32) d[j]);
            min.* = ifx diff < min.* then diff else min.*;
            max.* = ifx diff > max.* then diff else max.*;
            j += 1;
        }
        i += 1;
        s += p;
        d += dp;
    }
}

satd_c :: (coeff: *Tran_Low_T, length: s32) -> s32 {
    satd: s32 = 0;
    if 0 < length {
        for i: 0..length - 1 {
            satd += absolute_value(cast,no_check(s32) coeff[i]);
        }
    }

    return satd;
}

vector_var_c :: (ref: *s16, src: *s16, BWL: s32) -> s32 {
    width := (cast(s32) 4) << ((BWL) & 31);
    sse: s32 = 0;
    mean: s32 = 0;

    if 0 < width {
        for i: 0..width - 1 {
            diff := (cast(s32) ref[i]) - cast(s32) src[i];
            mean += diff;
            sse += diff * diff;
        }
    }

    var := sse - (mean * mean) >> (((BWL + 2)) & 31);
    return var;
}

