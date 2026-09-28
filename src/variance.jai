BILINEAR_FILTERS: [8] [2] u8;

clip_pixel_in_variance :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_variance :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_variance :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_variance :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_variance :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_variance(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_variance(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_variance(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_variance :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_variance :: (FILTER: *s16) -> s32 {
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

comp_avg_pred_c :: (comp_pred: *u8, pred: *u8, width: s32, height: s32, ref: *u8, ref_stride: s32) {
    j: s32 = ---;

    if 0 < height {
        for i: 0..height - 1 {
            j = 0;
            while j < width {
                TMP := (cast(s32) pred[j]) + cast(s32) ref[j];
                comp_pred[j] = cast,no_check(u8) ((TMP + (cast(s32) 1) << (((1 - 1)) & 31)) >> 1);
                j += 1;
            }
            comp_pred += width;
            pred += width;
            ref += ref_stride;
        }
    }
}

get16x16var_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, sse: *u32, sum: *s32) {
    variance(src_ptr, src_stride, ref_ptr, ref_stride, 16, 16, sse, sum);
}

variance :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, w: s32, h: s32, sse: *u32, sum: *s32) {
    j: s32 = ---;

    sum.* = 0;
    sse.* = 0;

    if 0 < h {
        for i: 0..h - 1 {
            j = 0;
            while j < w {
                DIFF := (cast(s32) src_ptr[j]) - cast(s32) ref_ptr[j];
                sum.* += DIFF;
                sse.* += cast,no_check(u32) (DIFF * DIFF);
                j += 1;
            }

            src_ptr += src_stride;
            ref_ptr += ref_stride;
        }
    }
}

get4x4sse_cs_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    distortion: s32 = 0;
    c: s32 = ---;

    for r: 0..cast(s32) 4 - 1 {
        c = 0;
        while c < 4 {
            diff := (cast(s32) src_ptr[c]) - cast(s32) ref_ptr[c];
            distortion += diff * diff;
            c += 1;
        }

        src_ptr += src_stride;
        ref_ptr += ref_stride;
    }

    return cast,no_check(u32) distortion;
}

get8x8var_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, sse: *u32, sum: *s32) {
    variance(src_ptr, src_stride, ref_ptr, ref_stride, 8, 8, sse, sum);
}

get_mb_ss_c :: (src_ptr: *s16) -> u32 {
    sum: u32 = 0;

    for i: 0..cast(u32) 256 - 1 {
        sum += cast,no_check(u32) ((cast(s32) src_ptr[i]) * cast(s32) src_ptr[i]);
    }

    return sum;
}

mse16x16_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, sse: *u32) -> u32 {
    sum: s32 = ---;

    variance(src_ptr, src_stride, ref_ptr, ref_stride, 16, 16, sse, *sum);

    return sse.*;
}

mse16x8_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, sse: *u32) -> u32 {
    sum: s32 = ---;

    variance(src_ptr, src_stride, ref_ptr, ref_stride, 16, 8, sse, *sum);

    return sse.*;
}

mse8x16_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, sse: *u32) -> u32 {
    sum: s32 = ---;

    variance(src_ptr, src_stride, ref_ptr, ref_stride, 8, 16, sse, *sum);

    return sse.*;
}

mse8x8_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, sse: *u32) -> u32 {
    sum: s32 = ---;

    variance(src_ptr, src_stride, ref_ptr, ref_stride, 8, 8, sse, *sum);

    return sse.*;
}

sub_pixel_avg_variance16x16_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32,
    second_pred: *u8
) -> u32 {
    fdata3: [272] u16 = ---;

    temp2: [256] u8 = ---;

    temp3: [256] u8 = --- #align 32;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        16 + 1,
        16,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 16, 16, 16, 16, BILINEAR_FILTERS[y_offset].data);

    comp_avg_pred_c(temp3.data, second_pred, 16, 16, temp2.data, 16);

    return variance16x16_c(temp3.data, 16, ref_ptr, ref_stride, sse);
}

variance16x16_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, sse: *u32) -> u32 {
    sum: s32 = ---;

    variance(src_ptr, src_stride, ref_ptr, ref_stride, 16, 16, sse, *sum);

    return sse.* - cast,no_check(u32) (((cast,no_check(s64) sum) * cast(s64) sum) / (16 * 16));
}

var_filter_block2d_bil_second_pass :: (
    src_ptr: *u16,
    ref_ptr: *u8,
    src_pixels_per_line: u32,
    pixel_step: u32,
    output_height: u32,
    output_width: u32,
    filter: *u8
) {
    j: u32 = ---;

    if 0 < output_height {
        for i: 0..output_height - 1 {
            j = 0;
            while j < output_width {
                ref_ptr[j] =
                    cast,no_check(u8) (((((cast,no_check(s32) src_ptr[0]) * cast(s32) filter[0]) + (cast,no_check(s32) src_ptr[pixel_step]) * cast(s32) filter[1]) +
                        (cast(s32) 1) << (((7 - 1)) & 31)) >> 7);
                src_ptr += 1;
                j += 1;
            }

            src_ptr += src_pixels_per_line - output_width;
            ref_ptr += output_width;
        }
    }
}

var_filter_block2d_bil_first_pass :: (
    src_ptr: *u8,
    ref_ptr: *u16,
    src_pixels_per_line: u32,
    pixel_step: s32,
    output_height: u32,
    output_width: u32,
    filter: *u8
) {
    j: u32 = ---;

    if 0 < output_height {
        for i: 0..output_height - 1 {
            j = 0;
            while j < output_width {
                ref_ptr[j] =
                    cast,no_check(u16) (((((cast,no_check(s32) src_ptr[0]) * cast(s32) filter[0]) + (cast,no_check(s32) src_ptr[pixel_step]) * cast(s32) filter[1]) +
                        (cast(s32) 1) << (((7 - 1)) & 31)) >> 7);

                src_ptr += 1;
                j += 1;
            }

            src_ptr += src_pixels_per_line - output_width;
            ref_ptr += output_width;
        }
    }
}

sub_pixel_avg_variance16x32_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32,
    second_pred: *u8
) -> u32 {
    fdata3: [528] u16 = ---;

    temp2: [512] u8 = ---;

    temp3: [512] u8 = --- #align 32;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        32 + 1,
        16,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 16, 16, 32, 16, BILINEAR_FILTERS[y_offset].data);

    comp_avg_pred_c(temp3.data, second_pred, 16, 32, temp2.data, 16);

    return variance16x32_c(temp3.data, 16, ref_ptr, ref_stride, sse);
}

variance16x32_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, sse: *u32) -> u32 {
    sum: s32 = ---;

    variance(src_ptr, src_stride, ref_ptr, ref_stride, 16, 32, sse, *sum);

    return sse.* - cast,no_check(u32) (((cast,no_check(s64) sum) * cast(s64) sum) / (16 * 32));
}

sub_pixel_avg_variance16x8_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32,
    second_pred: *u8
) -> u32 {
    fdata3: [144] u16 = ---;

    temp2: [128] u8 = ---;

    temp3: [128] u8 = --- #align 32;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        8 + 1,
        16,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 16, 16, 8, 16, BILINEAR_FILTERS[y_offset].data);

    comp_avg_pred_c(temp3.data, second_pred, 16, 8, temp2.data, 16);

    return variance16x8_c(temp3.data, 16, ref_ptr, ref_stride, sse);
}

variance16x8_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, sse: *u32) -> u32 {
    sum: s32 = ---;

    variance(src_ptr, src_stride, ref_ptr, ref_stride, 16, 8, sse, *sum);

    return sse.* - cast,no_check(u32) (((cast,no_check(s64) sum) * cast(s64) sum) / (16 * 8));
}

sub_pixel_avg_variance32x16_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32,
    second_pred: *u8
) -> u32 {
    fdata3: [544] u16 = ---;

    temp2: [512] u8 = ---;

    temp3: [512] u8 = --- #align 32;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        16 + 1,
        32,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 32, 32, 16, 32, BILINEAR_FILTERS[y_offset].data);

    comp_avg_pred_c(temp3.data, second_pred, 32, 16, temp2.data, 32);

    return variance32x16_c(temp3.data, 32, ref_ptr, ref_stride, sse);
}

variance32x16_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, sse: *u32) -> u32 {
    sum: s32 = ---;

    variance(src_ptr, src_stride, ref_ptr, ref_stride, 32, 16, sse, *sum);

    return sse.* - cast,no_check(u32) (((cast,no_check(s64) sum) * cast(s64) sum) / (32 * 16));
}

sub_pixel_avg_variance32x32_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32,
    second_pred: *u8
) -> u32 {
    fdata3: [1056] u16 = ---;

    temp2: [1024] u8 = ---;

    temp3: [1024] u8 = --- #align 32;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        32 + 1,
        32,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 32, 32, 32, 32, BILINEAR_FILTERS[y_offset].data);

    comp_avg_pred_c(temp3.data, second_pred, 32, 32, temp2.data, 32);

    return variance32x32_c(temp3.data, 32, ref_ptr, ref_stride, sse);
}

variance32x32_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, sse: *u32) -> u32 {
    sum: s32 = ---;

    variance(src_ptr, src_stride, ref_ptr, ref_stride, 32, 32, sse, *sum);

    return sse.* - cast,no_check(u32) (((cast,no_check(s64) sum) * cast(s64) sum) / (32 * 32));
}

sub_pixel_avg_variance32x64_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32,
    second_pred: *u8
) -> u32 {
    fdata3: [2080] u16 = ---;

    temp2: [2048] u8 = ---;

    temp3: [2048] u8 = --- #align 32;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        64 + 1,
        32,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 32, 32, 64, 32, BILINEAR_FILTERS[y_offset].data);

    comp_avg_pred_c(temp3.data, second_pred, 32, 64, temp2.data, 32);

    return variance32x64_c(temp3.data, 32, ref_ptr, ref_stride, sse);
}

variance32x64_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, sse: *u32) -> u32 {
    sum: s32 = ---;

    variance(src_ptr, src_stride, ref_ptr, ref_stride, 32, 64, sse, *sum);

    return sse.* - cast,no_check(u32) (((cast,no_check(s64) sum) * cast(s64) sum) / (32 * 64));
}

sub_pixel_avg_variance4x4_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32,
    second_pred: *u8
) -> u32 {
    fdata3: [20] u16 = ---;

    temp2: [16] u8 = ---;

    temp3: [16] u8 = --- #align 32;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        4 + 1,
        4,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 4, 4, 4, 4, BILINEAR_FILTERS[y_offset].data);

    comp_avg_pred_c(temp3.data, second_pred, 4, 4, temp2.data, 4);

    return variance4x4_c(temp3.data, 4, ref_ptr, ref_stride, sse);
}

variance4x4_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, sse: *u32) -> u32 {
    sum: s32 = ---;

    variance(src_ptr, src_stride, ref_ptr, ref_stride, 4, 4, sse, *sum);

    return sse.* - cast,no_check(u32) (((cast,no_check(s64) sum) * cast(s64) sum) / (4 * 4));
}

sub_pixel_avg_variance4x8_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32,
    second_pred: *u8
) -> u32 {
    fdata3: [36] u16 = ---;

    temp2: [32] u8 = ---;

    temp3: [32] u8 = --- #align 32;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        8 + 1,
        4,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 4, 4, 8, 4, BILINEAR_FILTERS[y_offset].data);

    comp_avg_pred_c(temp3.data, second_pred, 4, 8, temp2.data, 4);

    return variance4x8_c(temp3.data, 4, ref_ptr, ref_stride, sse);
}

variance4x8_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, sse: *u32) -> u32 {
    sum: s32 = ---;

    variance(src_ptr, src_stride, ref_ptr, ref_stride, 4, 8, sse, *sum);

    return sse.* - cast,no_check(u32) (((cast,no_check(s64) sum) * cast(s64) sum) / (4 * 8));
}

sub_pixel_avg_variance64x32_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32,
    second_pred: *u8
) -> u32 {
    fdata3: [2112] u16 = ---;

    temp2: [2048] u8 = ---;

    temp3: [2048] u8 = --- #align 32;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        32 + 1,
        64,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 64, 64, 32, 64, BILINEAR_FILTERS[y_offset].data);

    comp_avg_pred_c(temp3.data, second_pred, 64, 32, temp2.data, 64);

    return variance64x32_c(temp3.data, 64, ref_ptr, ref_stride, sse);
}

variance64x32_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, sse: *u32) -> u32 {
    sum: s32 = ---;

    variance(src_ptr, src_stride, ref_ptr, ref_stride, 64, 32, sse, *sum);

    return sse.* - cast,no_check(u32) (((cast,no_check(s64) sum) * cast(s64) sum) / (64 * 32));
}

sub_pixel_avg_variance64x64_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32,
    second_pred: *u8
) -> u32 {
    fdata3: [4160] u16 = ---;

    temp2: [4096] u8 = ---;

    temp3: [4096] u8 = --- #align 32;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        64 + 1,
        64,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 64, 64, 64, 64, BILINEAR_FILTERS[y_offset].data);

    comp_avg_pred_c(temp3.data, second_pred, 64, 64, temp2.data, 64);

    return variance64x64_c(temp3.data, 64, ref_ptr, ref_stride, sse);
}

variance64x64_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, sse: *u32) -> u32 {
    sum: s32 = ---;

    variance(src_ptr, src_stride, ref_ptr, ref_stride, 64, 64, sse, *sum);

    return sse.* - cast,no_check(u32) (((cast,no_check(s64) sum) * cast(s64) sum) / (64 * 64));
}

sub_pixel_avg_variance8x16_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32,
    second_pred: *u8
) -> u32 {
    fdata3: [136] u16 = ---;

    temp2: [128] u8 = ---;

    temp3: [128] u8 = --- #align 32;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        16 + 1,
        8,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 8, 8, 16, 8, BILINEAR_FILTERS[y_offset].data);

    comp_avg_pred_c(temp3.data, second_pred, 8, 16, temp2.data, 8);

    return variance8x16_c(temp3.data, 8, ref_ptr, ref_stride, sse);
}

variance8x16_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, sse: *u32) -> u32 {
    sum: s32 = ---;

    variance(src_ptr, src_stride, ref_ptr, ref_stride, 8, 16, sse, *sum);

    return sse.* - cast,no_check(u32) (((cast,no_check(s64) sum) * cast(s64) sum) / (8 * 16));
}

sub_pixel_avg_variance8x4_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32,
    second_pred: *u8
) -> u32 {
    fdata3: [40] u16 = ---;

    temp2: [32] u8 = ---;

    temp3: [32] u8 = --- #align 32;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        4 + 1,
        8,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 8, 8, 4, 8, BILINEAR_FILTERS[y_offset].data);

    comp_avg_pred_c(temp3.data, second_pred, 8, 4, temp2.data, 8);

    return variance8x4_c(temp3.data, 8, ref_ptr, ref_stride, sse);
}

variance8x4_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, sse: *u32) -> u32 {
    sum: s32 = ---;

    variance(src_ptr, src_stride, ref_ptr, ref_stride, 8, 4, sse, *sum);

    return sse.* - cast,no_check(u32) (((cast,no_check(s64) sum) * cast(s64) sum) / (8 * 4));
}

sub_pixel_avg_variance8x8_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32,
    second_pred: *u8
) -> u32 {
    fdata3: [72] u16 = ---;

    temp2: [64] u8 = ---;

    temp3: [64] u8 = --- #align 32;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        8 + 1,
        8,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 8, 8, 8, 8, BILINEAR_FILTERS[y_offset].data);

    comp_avg_pred_c(temp3.data, second_pred, 8, 8, temp2.data, 8);

    return variance8x8_c(temp3.data, 8, ref_ptr, ref_stride, sse);
}

variance8x8_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, sse: *u32) -> u32 {
    sum: s32 = ---;

    variance(src_ptr, src_stride, ref_ptr, ref_stride, 8, 8, sse, *sum);

    return sse.* - cast,no_check(u32) (((cast,no_check(s64) sum) * cast(s64) sum) / (8 * 8));
}

sub_pixel_variance16x16_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32
) -> u32 {
    fdata3: [272] u16 = ---;

    temp2: [256] u8 = ---;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        16 + 1,
        16,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 16, 16, 16, 16, BILINEAR_FILTERS[y_offset].data);

    return variance16x16_c(temp2.data, 16, ref_ptr, ref_stride, sse);
}

sub_pixel_variance16x32_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32
) -> u32 {
    fdata3: [528] u16 = ---;

    temp2: [512] u8 = ---;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        32 + 1,
        16,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 16, 16, 32, 16, BILINEAR_FILTERS[y_offset].data);

    return variance16x32_c(temp2.data, 16, ref_ptr, ref_stride, sse);
}

sub_pixel_variance16x8_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32
) -> u32 {
    fdata3: [144] u16 = ---;

    temp2: [128] u8 = ---;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        8 + 1,
        16,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 16, 16, 8, 16, BILINEAR_FILTERS[y_offset].data);

    return variance16x8_c(temp2.data, 16, ref_ptr, ref_stride, sse);
}

sub_pixel_variance32x16_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32
) -> u32 {
    fdata3: [544] u16 = ---;

    temp2: [512] u8 = ---;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        16 + 1,
        32,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 32, 32, 16, 32, BILINEAR_FILTERS[y_offset].data);

    return variance32x16_c(temp2.data, 32, ref_ptr, ref_stride, sse);
}

sub_pixel_variance32x32_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32
) -> u32 {
    fdata3: [1056] u16 = ---;

    temp2: [1024] u8 = ---;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        32 + 1,
        32,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 32, 32, 32, 32, BILINEAR_FILTERS[y_offset].data);

    return variance32x32_c(temp2.data, 32, ref_ptr, ref_stride, sse);
}

sub_pixel_variance32x64_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32
) -> u32 {
    fdata3: [2080] u16 = ---;

    temp2: [2048] u8 = ---;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        64 + 1,
        32,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 32, 32, 64, 32, BILINEAR_FILTERS[y_offset].data);

    return variance32x64_c(temp2.data, 32, ref_ptr, ref_stride, sse);
}

sub_pixel_variance4x4_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32
) -> u32 {
    fdata3: [20] u16 = ---;

    temp2: [16] u8 = ---;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        4 + 1,
        4,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 4, 4, 4, 4, BILINEAR_FILTERS[y_offset].data);

    return variance4x4_c(temp2.data, 4, ref_ptr, ref_stride, sse);
}

sub_pixel_variance4x8_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32
) -> u32 {
    fdata3: [36] u16 = ---;

    temp2: [32] u8 = ---;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        8 + 1,
        4,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 4, 4, 8, 4, BILINEAR_FILTERS[y_offset].data);

    return variance4x8_c(temp2.data, 4, ref_ptr, ref_stride, sse);
}

sub_pixel_variance64x32_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32
) -> u32 {
    fdata3: [2112] u16 = ---;

    temp2: [2048] u8 = ---;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        32 + 1,
        64,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 64, 64, 32, 64, BILINEAR_FILTERS[y_offset].data);

    return variance64x32_c(temp2.data, 64, ref_ptr, ref_stride, sse);
}

sub_pixel_variance64x64_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32
) -> u32 {
    fdata3: [4160] u16 = ---;

    temp2: [4096] u8 = ---;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        64 + 1,
        64,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 64, 64, 64, 64, BILINEAR_FILTERS[y_offset].data);

    return variance64x64_c(temp2.data, 64, ref_ptr, ref_stride, sse);
}

sub_pixel_variance8x16_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32
) -> u32 {
    fdata3: [136] u16 = ---;

    temp2: [128] u8 = ---;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        16 + 1,
        8,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 8, 8, 16, 8, BILINEAR_FILTERS[y_offset].data);

    return variance8x16_c(temp2.data, 8, ref_ptr, ref_stride, sse);
}

sub_pixel_variance8x4_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32
) -> u32 {
    fdata3: [40] u16 = ---;

    temp2: [32] u8 = ---;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        4 + 1,
        8,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 8, 8, 4, 8, BILINEAR_FILTERS[y_offset].data);

    return variance8x4_c(temp2.data, 8, ref_ptr, ref_stride, sse);
}

sub_pixel_variance8x8_c :: (
    src_ptr: *u8,
    src_stride: s32,
    x_offset: s32,
    y_offset: s32,
    ref_ptr: *u8,
    ref_stride: s32,
    sse: *u32
) -> u32 {
    fdata3: [72] u16 = ---;

    temp2: [64] u8 = ---;

    var_filter_block2d_bil_first_pass(
        src_ptr,
        fdata3.data,
        cast,no_check(u32) src_stride,
        1,
        8 + 1,
        8,
        BILINEAR_FILTERS[x_offset].data
    );

    var_filter_block2d_bil_second_pass(fdata3.data, temp2.data, 8, 8, 8, 8, BILINEAR_FILTERS[y_offset].data);

    return variance8x8_c(temp2.data, 8, ref_ptr, ref_stride, sse);
}

globals_initialization_state_for_variance: u32;
initialize_globals_for_variance :: () {
    {
        state := atomic_load(*globals_initialization_state_for_variance);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_variance, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_variance) != 2 {}
            return;
        }
    }
    BILINEAR_FILTERS =
        [2] u8.[
            u8.[ 128, 0 ],
            u8.[ 112, 16 ],
            u8.[ 96, 32 ],
            u8.[ 80, 48 ],
            u8.[ 64, 64 ],
            u8.[ 48, 80 ],
            u8.[ 32, 96 ],
            u8.[ 16, 112 ]
        ];
    atomic_store(*globals_initialization_state_for_variance, 2);
}

