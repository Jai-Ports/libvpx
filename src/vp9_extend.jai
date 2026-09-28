clip_pixel_in_vp9_extend :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_extend :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_extend :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_extend :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_extend :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_extend(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_extend(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_extend(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_extend :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_lsb_in_vp9_extend :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_extend :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_extend :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_extend(num_values) + 1 else 0;
}

vp9_copy_and_extend_frame :: (src: *YV12_BUFFER_CONFIG, dst: *YV12_BUFFER_CONFIG) {
    ET_Y: s32 = 16;
    EL_Y: s32 = 16;

    ER_Y :=
        (ifx src.y_width + 16 > (src.y_width + ((cast(s32) 1) << 6 - 1)) & ~((cast(s32) 1) << 6 - 1) then src.y_width + 16 else (src.y_width + ((cast(s32) 1) << 6 - 1)) & ~((cast(s32) 1) << 6 - 1)) -
            src.y_crop_width;
    EB_Y :=
        (ifx src.y_height + 16 > (src.y_height + ((cast(s32) 1) << 6 - 1)) & ~((cast(s32) 1) << 6 - 1) then src.y_height + 16 else (src.y_height + ((cast(s32) 1) << 6 - 1)) & ~((cast(s32) 1) << 6 - 1)) -
            src.y_crop_height;
    UV_WIDTH_SUBSAMPLING := cast(s32) (src.uv_width != src.y_width);
    UV_HEIGHT_SUBSAMPLING := cast(s32) (src.uv_height != src.y_height);
    ET_UV := ET_Y >> ((UV_HEIGHT_SUBSAMPLING) & 31);
    EL_UV := EL_Y >> ((UV_WIDTH_SUBSAMPLING) & 31);
    EB_UV := EB_Y >> ((UV_HEIGHT_SUBSAMPLING) & 31);
    ER_UV := ER_Y >> ((UV_WIDTH_SUBSAMPLING) & 31);

    CHROMA_STEP := (ifx src.v_buffer - src.u_buffer == 1 then cast(s32) 2 else 1);

    copy_and_extend_plane_in_vp9_extend(
        src.y_buffer,
        src.y_stride,
        dst.y_buffer,
        dst.y_stride,
        src.y_crop_width,
        src.y_crop_height,
        ET_Y,
        EL_Y,
        EB_Y,
        ER_Y,
        1
    );

    copy_and_extend_plane_in_vp9_extend(
        src.u_buffer,
        src.uv_stride,
        dst.u_buffer,
        dst.uv_stride,
        src.uv_crop_width,
        src.uv_crop_height,
        ET_UV,
        EL_UV,
        EB_UV,
        ER_UV,
        CHROMA_STEP
    );

    copy_and_extend_plane_in_vp9_extend(
        src.v_buffer,
        src.uv_stride,
        dst.v_buffer,
        dst.uv_stride,
        src.uv_crop_width,
        src.uv_crop_height,
        ET_UV,
        EL_UV,
        EB_UV,
        ER_UV,
        CHROMA_STEP
    );
}

copy_and_extend_plane_in_vp9_extend :: (
    src: *u8,
    src_pitch: s32,
    dst: *u8,
    dst_pitch: s32,
    w: s32,
    h: s32,
    extend_top: s32,
    extend_left: s32,
    extend_bottom: s32,
    extend_right: s32,
    interleave_step: s32
) {
    j: s32 = ---;
    STEP := (ifx interleave_step < 1 then 1 else interleave_step);

    src_ptr1 := src;
    src_ptr2 := src + (w - 1) * STEP;
    dst_ptr1 := dst - extend_left;
    dst_ptr2 := dst + w;

    if 0 < h {
        for i: 0..h - 1 {
            fill_memory(dst_ptr1, cast,no_check(s32) src_ptr1[0], cast,no_check(u64) extend_left);
            if STEP == 1 {
                copy_memory(dst_ptr1 + extend_left, src_ptr1, cast,no_check(u64) w);
            } else {
                j = 0;
                while j < w {
                    dst_ptr1[extend_left + j] = src_ptr1[STEP * j];
                    j += 1;
                }
            }
            fill_memory(dst_ptr2, cast,no_check(s32) src_ptr2[0], cast,no_check(u64) extend_right);
            src_ptr1 += src_pitch;
            src_ptr2 += src_pitch;
            dst_ptr1 += dst_pitch;
            dst_ptr2 += dst_pitch;
        }
    }

    src_ptr1 = dst - extend_left;
    src_ptr2 = dst + dst_pitch * (h - 1) - extend_left;
    dst_ptr1 = dst + dst_pitch * -extend_top - extend_left;
    dst_ptr2 = dst + dst_pitch * h - extend_left;
    linesize := extend_left + extend_right + w;

    if 0 < extend_top {
        for i: 0..extend_top - 1 {
            copy_memory(dst_ptr1, src_ptr1, cast,no_check(u64) linesize);
            dst_ptr1 += dst_pitch;
        }
    }

    if 0 < extend_bottom {
        for i: 0..extend_bottom - 1 {
            copy_memory(dst_ptr2, src_ptr2, cast,no_check(u64) linesize);
            dst_ptr2 += dst_pitch;
        }
    }
}

