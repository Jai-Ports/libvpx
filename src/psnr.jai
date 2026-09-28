// Generated directly from C by cpp_transpiler.
PEAK: float64;

clip_pixel_in_psnr :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_psnr :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_psnr :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_psnr :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_psnr :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_psnr(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_psnr(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_psnr(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_psnr :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps :: (FILTER: *s16) -> s32 {
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

sse_to_psnr :: (samples: float64, peak: float64, sse: float64) -> float64 {
    if c_transpiler_float_greater(sse, 0.0) {
        PSNR := 10.0 * c_transpiler_math_log10(samples * peak * peak / sse);
        return ifx c_transpiler_float_greater(PSNR, 100.0) then 100.0 else PSNR;
    } else {
        return 100.0;
    }
}

get_y_sse :: (a: *YV12_BUFFER_CONFIG, b: *YV12_BUFFER_CONFIG) -> s64 {
    return get_sse(a.y_buffer, a.y_stride, b.y_buffer, b.y_stride, a.y_crop_width, a.y_crop_height);
}

get_sse :: (a: *u8, a_stride: s32, b: *u8, b_stride: s32, width: s32, height: s32) -> s64 {
    DW := width % 16;
    DH := height % 16;
    total_sse: s64 = 0;
    x: s32 = ---;

    if DW > 0 {
        total_sse += encoder_sse(*a[width - DW], a_stride, *b[width - DW], b_stride, DW, height);
    }

    if DH > 0 {
        total_sse +=
            encoder_sse(
                *a[(height - DH) * a_stride],
                a_stride,
                *b[(height - DH) * b_stride],
                b_stride,
                width - DW,
                DH
            );
    }

    y: s32 = 0;
    while y < height / 16 {
        pa := a;
        pb := b;
        x = 0;
        while x < width / 16 {
            total_sse += sse_c(pa, a_stride, pb, b_stride, 16, 16);

            pa += 16;
            pb += 16;
            x += 1;
        }

        a += 16 * a_stride;
        b += 16 * b_stride;
        y += 1;
    }

    return total_sse;
}

encoder_sse :: (a: *u8, a_stride: s32, b: *u8, b_stride: s32, w: s32, h: s32) -> s64 {
    j: s32 = ---;
    sse: s64 = 0;

    if 0 < h {
        for i: 0..h - 1 {
            j = 0;
            while j < w {
                DIFF := (cast(s32) a[j]) - cast(s32) b[j];
                sse += cast,no_check(s64) (DIFF * DIFF);
                j += 1;
            }

            a += a_stride;
            b += b_stride;
        }
    }

    return sse;
}

calc_psnr :: (a: *YV12_BUFFER_CONFIG, b: *YV12_BUFFER_CONFIG, psnr: *PSNR_STATS, spatial_layer_id: s32) {
    WIDTHS := s32.[ a.y_crop_width, a.uv_crop_width, a.uv_crop_width ];
    HEIGHTS := s32.[ a.y_crop_height, a.uv_crop_height, a.uv_crop_height ];
    a_planes := *u8.[ a.y_buffer, a.u_buffer, a.v_buffer ];
    A_STRIDES := s32.[ a.y_stride, a.uv_stride, a.uv_stride ];
    b_planes := *u8.[ b.y_buffer, b.u_buffer, b.v_buffer ];
    B_STRIDES := s32.[ b.y_stride, b.uv_stride, b.uv_stride ];

    total_sse: u64 = 0;
    total_samples: u32 = 0;

    for i: 0..cast(s32) 3 - 1 {
        W := WIDTHS[i];
        H := HEIGHTS[i];
        SAMPLES := cast,no_check(u32) (W * H);
        SSE_ := cast,no_check(u64) get_sse(a_planes[i], A_STRIDES[i], b_planes[i], B_STRIDES[i], W, H);
        psnr.sse[1 + i] = SSE_;
        psnr.samples[1 + i] = SAMPLES;
        psnr.psnr[1 + i] = sse_to_psnr(cast,no_check(float64) SAMPLES, 255.0, cast,no_check(float64) SSE_);

        total_sse += SSE_;
        total_samples += SAMPLES;
    }

    psnr.sse[0] = total_sse;
    psnr.samples[0] = total_samples;
    psnr.psnr[0] = sse_to_psnr(cast,no_check(float64) total_samples, 255.0, cast,no_check(float64) total_sse);
    psnr.spatial_layer_id = spatial_layer_id;
}

globals_initialization_state_for_psnr: u32;
initialize_globals_for_psnr :: () {
    {
        state := atomic_load(*globals_initialization_state_for_psnr);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_psnr, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_psnr) != 2 {}
            return;
        }
    }
    PEAK = 255.0;
    atomic_store(*globals_initialization_state_for_psnr, 2);
}

PSNR_STATS :: Psnr_Pkt;

