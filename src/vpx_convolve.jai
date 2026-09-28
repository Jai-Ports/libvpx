clip_pixel_in_vpx_convolve :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vpx_convolve :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vpx_convolve :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vpx_convolve :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vpx_convolve :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vpx_convolve(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vpx_convolve(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vpx_convolve(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vpx_convolve :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_vpx_convolve :: (FILTER: *s16) -> s32 {
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

convolve8_c :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    filter: *Interp_Kernel,
    x0_q4: s32,
    x_step_q4: s32,
    y0_q4: s32,
    y_step_q4: s32,
    w: s32,
    h: s32
) {
    temp: [8640] u8 = ---;
    INTERMEDIATE_HEIGHT := ((h - 1) * y_step_q4 + y0_q4) >> 4 + 8;

    convolve_horiz(
        src - src_stride * cast,no_check(s64) ((cast,no_check(s32) ((8 / 2))) - 1),
        src_stride,
        temp.data,
        64,
        filter,
        x0_q4,
        x_step_q4,
        w,
        INTERMEDIATE_HEIGHT
    );
    convolve_vert(
        temp.data + 64 * ((cast,no_check(s32) ((8 / 2))) - 1),
        64,
        dst,
        dst_stride,
        filter,
        y0_q4,
        y_step_q4,
        w,
        h
    );
}

convolve_vert :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    y_filters: *Interp_Kernel,
    y0_q4: s32,
    y_step_q4: s32,
    w: s32,
    h: s32
) {
    y: s32 = ---;
    src -= src_stride * cast,no_check(s64) ((cast,no_check(s32) ((8 / 2))) - 1);

    if 0 < w {
        for x: 0..w - 1 {
            y_q4 := y0_q4;
            y = 0;
            while y < h {
                src_y := *src[(cast(s64) (y_q4 >> 4)) * src_stride];
                Y_FILTER := y_filters[y_q4 & ((cast(s32) 1) << 4 - 1)].data;
                sum: s32 = 0;
                for k: 0..cast(s32) 8 - 1 {
                    sum += (cast(s32) src_y[(cast(s64) k) * src_stride]) * cast(s32) Y_FILTER[k];
                }
                dst[(cast(s64) y) * dst_stride] =
                    clip_pixel_in_vpx_convolve(
                        (sum + (cast(s32) 1) << (((7 - 1)) & 31)) >> 7
                    );
                y_q4 += y_step_q4;
                y += 1;
            }
            src += 1;
            dst += 1;
        }
    }
}

convolve_horiz :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    x_filters: *Interp_Kernel,
    x0_q4: s32,
    x_step_q4: s32,
    w: s32,
    h: s32
) {
    x: s32 = ---;
    src -= (cast,no_check(s32) ((8 / 2))) - 1;

    if 0 < h {
        for y: 0..h - 1 {
            x_q4 := x0_q4;
            x = 0;
            while x < w {
                SRC_X := *src[x_q4 >> 4];
                X_FILTER := x_filters[x_q4 & ((cast(s32) 1) << 4 - 1)].data;
                sum: s32 = 0;
                for k: 0..cast(s32) 8 - 1 {
                    sum += (cast(s32) SRC_X[k]) * cast(s32) X_FILTER[k];
                }
                dst[x] = clip_pixel_in_vpx_convolve((sum + (cast(s32) 1) << (((7 - 1)) & 31)) >> 7);
                x_q4 += x_step_q4;
                x += 1;
            }
            src += src_stride;
            dst += dst_stride;
        }
    }
}

convolve8_avg_c :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    filter: *Interp_Kernel,
    x0_q4: s32,
    x_step_q4: s32,
    y0_q4: s32,
    y_step_q4: s32,
    w: s32,
    h: s32
) {
    temp: [4096] u8 = --- #align 16;

    convolve8_c(src, src_stride, temp.data, 64, filter, x0_q4, x_step_q4, y0_q4, y_step_q4, w, h);
    convolve_avg_c(temp.data, 64, dst, dst_stride, null, 0, 0, 0, 0, w, h);
}

convolve_avg_c :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    filter: *Interp_Kernel,
    x0_q4: s32,
    x_step_q4: s32,
    y0_q4: s32,
    y_step_q4: s32,
    w: s32,
    h: s32
) {
    x: s32 = ---;

    if 0 < h {
        for y: 0..h - 1 {
            x = 0;
            while x < w {
                dst[x] =
                    cast,no_check(u8) ((((cast(s32) dst[x]) + cast(s32) src[x]) +
                        (cast(s32) 1) << (((1 - 1)) & 31)) >> 1);
                x += 1;
            }
            src += src_stride;
            dst += dst_stride;
        }
    }
}

convolve8_avg_horiz_c :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    filter: *Interp_Kernel,
    x0_q4: s32,
    x_step_q4: s32,
    y0_q4: s32,
    y_step_q4: s32,
    w: s32,
    h: s32
) {
    convolve_avg_horiz(src, src_stride, dst, dst_stride, filter, x0_q4, x_step_q4, w, h);
}

convolve_avg_horiz :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    x_filters: *Interp_Kernel,
    x0_q4: s32,
    x_step_q4: s32,
    w: s32,
    h: s32
) {
    x: s32 = ---;
    src -= (cast,no_check(s32) ((8 / 2))) - 1;

    if 0 < h {
        for y: 0..h - 1 {
            x_q4 := x0_q4;
            x = 0;
            while x < w {
                SRC_X := *src[x_q4 >> 4];
                X_FILTER := x_filters[x_q4 & ((cast(s32) 1) << 4 - 1)].data;
                sum: s32 = 0;
                for k: 0..cast(s32) 8 - 1 {
                    sum += (cast(s32) SRC_X[k]) * cast(s32) X_FILTER[k];
                }
                dst[x] =
                    cast,no_check(u8) ((((cast(s32) dst[x]) + cast(s32) clip_pixel_in_vpx_convolve(
                        (sum + (cast(s32) 1) << (((7 - 1)) & 31)) >> 7
                    )) + (cast(s32) 1) << (((1 - 1)) & 31)) >> 1);
                x_q4 += x_step_q4;
                x += 1;
            }
            src += src_stride;
            dst += dst_stride;
        }
    }
}

convolve8_avg_vert_c :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    filter: *Interp_Kernel,
    x0_q4: s32,
    x_step_q4: s32,
    y0_q4: s32,
    y_step_q4: s32,
    w: s32,
    h: s32
) {
    convolve_avg_vert(src, src_stride, dst, dst_stride, filter, y0_q4, y_step_q4, w, h);
}

convolve_avg_vert :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    y_filters: *Interp_Kernel,
    y0_q4: s32,
    y_step_q4: s32,
    w: s32,
    h: s32
) {
    y: s32 = ---;
    src -= src_stride * cast,no_check(s64) ((cast,no_check(s32) ((8 / 2))) - 1);

    if 0 < w {
        for x: 0..w - 1 {
            y_q4 := y0_q4;
            y = 0;
            while y < h {
                src_y := *src[(cast(s64) (y_q4 >> 4)) * src_stride];
                Y_FILTER := y_filters[y_q4 & ((cast(s32) 1) << 4 - 1)].data;
                sum: s32 = 0;
                for k: 0..cast(s32) 8 - 1 {
                    sum += (cast(s32) src_y[(cast(s64) k) * src_stride]) * cast(s32) Y_FILTER[k];
                }
                dst[(cast(s64) y) * dst_stride] =
                    cast,no_check(u8) ((((cast(s32) dst[(cast(s64) y) * dst_stride]) + cast(s32) clip_pixel_in_vpx_convolve(
                        (sum + (cast(s32) 1) << (((7 - 1)) & 31)) >> 7
                    )) + (cast(s32) 1) << (((1 - 1)) & 31)) >> 1);
                y_q4 += y_step_q4;
                y += 1;
            }
            src += 1;
            dst += 1;
        }
    }
}

convolve8_horiz_c :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    filter: *Interp_Kernel,
    x0_q4: s32,
    x_step_q4: s32,
    y0_q4: s32,
    y_step_q4: s32,
    w: s32,
    h: s32
) {
    convolve_horiz(src, src_stride, dst, dst_stride, filter, x0_q4, x_step_q4, w, h);
}

convolve8_vert_c :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    filter: *Interp_Kernel,
    x0_q4: s32,
    x_step_q4: s32,
    y0_q4: s32,
    y_step_q4: s32,
    w: s32,
    h: s32
) {
    convolve_vert(src, src_stride, dst, dst_stride, filter, y0_q4, y_step_q4, w, h);
}

convolve_copy_c :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    filter: *Interp_Kernel,
    x0_q4: s32,
    x_step_q4: s32,
    y0_q4: s32,
    y_step_q4: s32,
    w: s32,
    h: s32
) {
    r := h;
    while r > 0 {
        copy_memory(dst, src, cast,no_check(u64) w);
        src += src_stride;
        dst += dst_stride;
        r -= 1;
    }
}

scaled_2d_c :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    filter: *Interp_Kernel,
    x0_q4: s32,
    x_step_q4: s32,
    y0_q4: s32,
    y_step_q4: s32,
    w: s32,
    h: s32
) {
    convolve8_c(src, src_stride, dst, dst_stride, filter, x0_q4, x_step_q4, y0_q4, y_step_q4, w, h);
}

scaled_avg_2d_c :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    filter: *Interp_Kernel,
    x0_q4: s32,
    x_step_q4: s32,
    y0_q4: s32,
    y_step_q4: s32,
    w: s32,
    h: s32
) {
    convolve8_avg_c(src, src_stride, dst, dst_stride, filter, x0_q4, x_step_q4, y0_q4, y_step_q4, w, h);
}

scaled_avg_horiz_c :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    filter: *Interp_Kernel,
    x0_q4: s32,
    x_step_q4: s32,
    y0_q4: s32,
    y_step_q4: s32,
    w: s32,
    h: s32
) {
    convolve8_avg_horiz_c(src, src_stride, dst, dst_stride, filter, x0_q4, x_step_q4, y0_q4, y_step_q4, w, h);
}

scaled_avg_vert_c :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    filter: *Interp_Kernel,
    x0_q4: s32,
    x_step_q4: s32,
    y0_q4: s32,
    y_step_q4: s32,
    w: s32,
    h: s32
) {
    convolve8_avg_vert_c(src, src_stride, dst, dst_stride, filter, x0_q4, x_step_q4, y0_q4, y_step_q4, w, h);
}

scaled_horiz_c :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    filter: *Interp_Kernel,
    x0_q4: s32,
    x_step_q4: s32,
    y0_q4: s32,
    y_step_q4: s32,
    w: s32,
    h: s32
) {
    convolve8_horiz_c(src, src_stride, dst, dst_stride, filter, x0_q4, x_step_q4, y0_q4, y_step_q4, w, h);
}

scaled_vert_c :: (
    src: *u8,
    src_stride: s64,
    dst: *u8,
    dst_stride: s64,
    filter: *Interp_Kernel,
    x0_q4: s32,
    x_step_q4: s32,
    y0_q4: s32,
    y_step_q4: s32,
    w: s32,
    h: s32
) {
    convolve8_vert_c(src, src_stride, dst, dst_stride, filter, x0_q4, x_step_q4, y0_q4, y_step_q4, w, h);
}

Interp_Kernel :: [8] s16;

