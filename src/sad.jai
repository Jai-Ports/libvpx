// Generated directly from C by cpp_transpiler.
clip_pixel_in_sad :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_sad :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_sad :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_sad :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_sad :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_sad(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_sad(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_sad(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_sad :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_sad :: (FILTER: *s16) -> s32 {
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

sad16x16_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return sad(src_ptr, src_stride, ref_ptr, ref_stride, 16, 16);
}

sad :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, width: s32, height: s32) -> u32 {
    x: s32 = ---;
    sad: u32 = 0;

    if 0 < height {
        for y: 0..height - 1 {
            x = 0;
            while x < width {
                sad += cast,no_check(u32) absolute_value((cast(s32) src_ptr[x]) - cast(s32) ref_ptr[x]);
                x += 1;
            }

            src_ptr += src_stride;
            ref_ptr += ref_stride;
        }
    }
    return sad;
}

sad16x16_avg_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, second_pred: *u8) -> u32 {
    comp_pred: [256] u8 = --- #align 32;

    comp_avg_pred_c(comp_pred.data, second_pred, 16, 16, ref_ptr, ref_stride);

    return sad(src_ptr, src_stride, comp_pred.data, 16, 16, 16);
}

sad16x16x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = sad16x16_c(src_ptr, src_stride, ref_array[i], ref_stride);
    }
}

sad16x32_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return sad(src_ptr, src_stride, ref_ptr, ref_stride, 16, 32);
}

sad16x32_avg_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, second_pred: *u8) -> u32 {
    comp_pred: [512] u8 = --- #align 32;

    comp_avg_pred_c(comp_pred.data, second_pred, 16, 32, ref_ptr, ref_stride);

    return sad(src_ptr, src_stride, comp_pred.data, 16, 16, 32);
}

sad16x32x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = sad16x32_c(src_ptr, src_stride, ref_array[i], ref_stride);
    }
}

sad16x8_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return sad(src_ptr, src_stride, ref_ptr, ref_stride, 16, 8);
}

sad16x8_avg_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, second_pred: *u8) -> u32 {
    comp_pred: [128] u8 = --- #align 32;

    comp_avg_pred_c(comp_pred.data, second_pred, 16, 8, ref_ptr, ref_stride);

    return sad(src_ptr, src_stride, comp_pred.data, 16, 16, 8);
}

sad16x8x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = sad16x8_c(src_ptr, src_stride, ref_array[i], ref_stride);
    }
}

sad32x16_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return sad(src_ptr, src_stride, ref_ptr, ref_stride, 32, 16);
}

sad32x16_avg_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, second_pred: *u8) -> u32 {
    comp_pred: [512] u8 = --- #align 32;

    comp_avg_pred_c(comp_pred.data, second_pred, 32, 16, ref_ptr, ref_stride);

    return sad(src_ptr, src_stride, comp_pred.data, 32, 32, 16);
}

sad32x16x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = sad32x16_c(src_ptr, src_stride, ref_array[i], ref_stride);
    }
}

sad32x32_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return sad(src_ptr, src_stride, ref_ptr, ref_stride, 32, 32);
}

sad32x32_avg_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, second_pred: *u8) -> u32 {
    comp_pred: [1024] u8 = --- #align 32;

    comp_avg_pred_c(comp_pred.data, second_pred, 32, 32, ref_ptr, ref_stride);

    return sad(src_ptr, src_stride, comp_pred.data, 32, 32, 32);
}

sad32x32x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = sad32x32_c(src_ptr, src_stride, ref_array[i], ref_stride);
    }
}

sad32x64_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return sad(src_ptr, src_stride, ref_ptr, ref_stride, 32, 64);
}

sad32x64_avg_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, second_pred: *u8) -> u32 {
    comp_pred: [2048] u8 = --- #align 32;

    comp_avg_pred_c(comp_pred.data, second_pred, 32, 64, ref_ptr, ref_stride);

    return sad(src_ptr, src_stride, comp_pred.data, 32, 32, 64);
}

sad32x64x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = sad32x64_c(src_ptr, src_stride, ref_array[i], ref_stride);
    }
}

sad4x4_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return sad(src_ptr, src_stride, ref_ptr, ref_stride, 4, 4);
}

sad4x4_avg_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, second_pred: *u8) -> u32 {
    comp_pred: [16] u8 = --- #align 32;

    comp_avg_pred_c(comp_pred.data, second_pred, 4, 4, ref_ptr, ref_stride);

    return sad(src_ptr, src_stride, comp_pred.data, 4, 4, 4);
}

sad4x4x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = sad4x4_c(src_ptr, src_stride, ref_array[i], ref_stride);
    }
}

sad4x8_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return sad(src_ptr, src_stride, ref_ptr, ref_stride, 4, 8);
}

sad4x8_avg_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, second_pred: *u8) -> u32 {
    comp_pred: [32] u8 = --- #align 32;

    comp_avg_pred_c(comp_pred.data, second_pred, 4, 8, ref_ptr, ref_stride);

    return sad(src_ptr, src_stride, comp_pred.data, 4, 4, 8);
}

sad4x8x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = sad4x8_c(src_ptr, src_stride, ref_array[i], ref_stride);
    }
}

sad64x32_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return sad(src_ptr, src_stride, ref_ptr, ref_stride, 64, 32);
}

sad64x32_avg_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, second_pred: *u8) -> u32 {
    comp_pred: [2048] u8 = --- #align 32;

    comp_avg_pred_c(comp_pred.data, second_pred, 64, 32, ref_ptr, ref_stride);

    return sad(src_ptr, src_stride, comp_pred.data, 64, 64, 32);
}

sad64x32x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = sad64x32_c(src_ptr, src_stride, ref_array[i], ref_stride);
    }
}

sad64x64_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return sad(src_ptr, src_stride, ref_ptr, ref_stride, 64, 64);
}

sad64x64_avg_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, second_pred: *u8) -> u32 {
    comp_pred: [4096] u8 = --- #align 32;

    comp_avg_pred_c(comp_pred.data, second_pred, 64, 64, ref_ptr, ref_stride);

    return sad(src_ptr, src_stride, comp_pred.data, 64, 64, 64);
}

sad64x64x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = sad64x64_c(src_ptr, src_stride, ref_array[i], ref_stride);
    }
}

sad8x16_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return sad(src_ptr, src_stride, ref_ptr, ref_stride, 8, 16);
}

sad8x16_avg_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, second_pred: *u8) -> u32 {
    comp_pred: [128] u8 = --- #align 32;

    comp_avg_pred_c(comp_pred.data, second_pred, 8, 16, ref_ptr, ref_stride);

    return sad(src_ptr, src_stride, comp_pred.data, 8, 8, 16);
}

sad8x16x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = sad8x16_c(src_ptr, src_stride, ref_array[i], ref_stride);
    }
}

sad8x4_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return sad(src_ptr, src_stride, ref_ptr, ref_stride, 8, 4);
}

sad8x4_avg_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, second_pred: *u8) -> u32 {
    comp_pred: [32] u8 = --- #align 32;

    comp_avg_pred_c(comp_pred.data, second_pred, 8, 4, ref_ptr, ref_stride);

    return sad(src_ptr, src_stride, comp_pred.data, 8, 8, 4);
}

sad8x4x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = sad8x4_c(src_ptr, src_stride, ref_array[i], ref_stride);
    }
}

sad8x8_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return sad(src_ptr, src_stride, ref_ptr, ref_stride, 8, 8);
}

sad8x8_avg_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32, second_pred: *u8) -> u32 {
    comp_pred: [64] u8 = --- #align 32;

    comp_avg_pred_c(comp_pred.data, second_pred, 8, 8, ref_ptr, ref_stride);

    return sad(src_ptr, src_stride, comp_pred.data, 8, 8, 8);
}

sad8x8x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = sad8x8_c(src_ptr, src_stride, ref_array[i], ref_stride);
    }
}

sad_skip_16x16_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return 2 * sad(src_ptr, 2 * src_stride, ref_ptr, 2 * ref_stride, 16, cast,no_check(s32) (16 / 2));
}

sad_skip_16x16x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = 2 * sad(src_ptr, 2 * src_stride, ref_array[i], 2 * ref_stride, 16, cast,no_check(s32) (16 / 2));
    }
}

sad_skip_16x32_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return 2 * sad(src_ptr, 2 * src_stride, ref_ptr, 2 * ref_stride, 16, cast,no_check(s32) (32 / 2));
}

sad_skip_16x32x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = 2 * sad(src_ptr, 2 * src_stride, ref_array[i], 2 * ref_stride, 16, cast,no_check(s32) (32 / 2));
    }
}

sad_skip_16x8_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return 2 * sad(src_ptr, 2 * src_stride, ref_ptr, 2 * ref_stride, 16, cast,no_check(s32) (8 / 2));
}

sad_skip_16x8x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = 2 * sad(src_ptr, 2 * src_stride, ref_array[i], 2 * ref_stride, 16, cast,no_check(s32) (8 / 2));
    }
}

sad_skip_32x16_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return 2 * sad(src_ptr, 2 * src_stride, ref_ptr, 2 * ref_stride, 32, cast,no_check(s32) (16 / 2));
}

sad_skip_32x16x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = 2 * sad(src_ptr, 2 * src_stride, ref_array[i], 2 * ref_stride, 32, cast,no_check(s32) (16 / 2));
    }
}

sad_skip_32x32_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return 2 * sad(src_ptr, 2 * src_stride, ref_ptr, 2 * ref_stride, 32, cast,no_check(s32) (32 / 2));
}

sad_skip_32x32x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = 2 * sad(src_ptr, 2 * src_stride, ref_array[i], 2 * ref_stride, 32, cast,no_check(s32) (32 / 2));
    }
}

sad_skip_32x64_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return 2 * sad(src_ptr, 2 * src_stride, ref_ptr, 2 * ref_stride, 32, cast,no_check(s32) (64 / 2));
}

sad_skip_32x64x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = 2 * sad(src_ptr, 2 * src_stride, ref_array[i], 2 * ref_stride, 32, cast,no_check(s32) (64 / 2));
    }
}

sad_skip_4x4_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return 2 * sad(src_ptr, 2 * src_stride, ref_ptr, 2 * ref_stride, 4, cast,no_check(s32) (4 / 2));
}

sad_skip_4x4x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = 2 * sad(src_ptr, 2 * src_stride, ref_array[i], 2 * ref_stride, 4, cast,no_check(s32) (4 / 2));
    }
}

sad_skip_4x8_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return 2 * sad(src_ptr, 2 * src_stride, ref_ptr, 2 * ref_stride, 4, cast,no_check(s32) (8 / 2));
}

sad_skip_4x8x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = 2 * sad(src_ptr, 2 * src_stride, ref_array[i], 2 * ref_stride, 4, cast,no_check(s32) (8 / 2));
    }
}

sad_skip_64x32_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return 2 * sad(src_ptr, 2 * src_stride, ref_ptr, 2 * ref_stride, 64, cast,no_check(s32) (32 / 2));
}

sad_skip_64x32x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = 2 * sad(src_ptr, 2 * src_stride, ref_array[i], 2 * ref_stride, 64, cast,no_check(s32) (32 / 2));
    }
}

sad_skip_64x64_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return 2 * sad(src_ptr, 2 * src_stride, ref_ptr, 2 * ref_stride, 64, cast,no_check(s32) (64 / 2));
}

sad_skip_64x64x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = 2 * sad(src_ptr, 2 * src_stride, ref_array[i], 2 * ref_stride, 64, cast,no_check(s32) (64 / 2));
    }
}

sad_skip_8x16_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return 2 * sad(src_ptr, 2 * src_stride, ref_ptr, 2 * ref_stride, 8, cast,no_check(s32) (16 / 2));
}

sad_skip_8x16x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = 2 * sad(src_ptr, 2 * src_stride, ref_array[i], 2 * ref_stride, 8, cast,no_check(s32) (16 / 2));
    }
}

sad_skip_8x4_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return 2 * sad(src_ptr, 2 * src_stride, ref_ptr, 2 * ref_stride, 8, cast,no_check(s32) (4 / 2));
}

sad_skip_8x4x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = 2 * sad(src_ptr, 2 * src_stride, ref_array[i], 2 * ref_stride, 8, cast,no_check(s32) (4 / 2));
    }
}

sad_skip_8x8_c :: (src_ptr: *u8, src_stride: s32, ref_ptr: *u8, ref_stride: s32) -> u32 {
    return 2 * sad(src_ptr, 2 * src_stride, ref_ptr, 2 * ref_stride, 8, cast,no_check(s32) (8 / 2));
}

sad_skip_8x8x4d_c :: (src_ptr: *u8, src_stride: s32, ref_array: **u8, ref_stride: s32, sad_array: *u32) {
    for i: 0..cast(s32) 4 - 1 {
        sad_array[i] = 2 * sad(src_ptr, 2 * src_stride, ref_array[i], 2 * ref_stride, 8, cast,no_check(s32) (8 / 2));
    }
}

