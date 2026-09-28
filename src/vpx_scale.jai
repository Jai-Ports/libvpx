Scale1_D :: #type (_: *u8, _: s32, _: u32, _: u32, _: *u8, _: s32, _: u32, _: u32);

SCALE_VARS :: struct {
    expanded_frame_width: s32;
    expanded_frame_height: s32;
    h_scale: s32;
    h_ratio: s32;
    v_scale: s32;
    v_ratio: s32;
    src_yuv_config: *YV12_BUFFER_CONFIG;
    dst_yuv_config: *YV12_BUFFER_CONFIG;
}

scale_frame :: (
    src: *YV12_BUFFER_CONFIG,
    dst: *YV12_BUFFER_CONFIG,
    temp_area: *u8,
    temp_height: u8,
    hscale: u32,
    hratio: u32,
    vscale: u32,
    vratio: u32,
    interlaced: u32
) {
    i: s32 = ---;
    dw := cast,no_check(s32) (((hscale - 1) + (cast,no_check(u32) src.y_width) * hratio) / hscale);
    dh := cast,no_check(s32) (((vscale - 1) + (cast,no_check(u32) src.y_height) * vratio) / vscale);

    scale2_d(
        src.y_buffer,
        src.y_stride,
        cast,no_check(u32) src.y_width,
        cast,no_check(u32) src.y_height,
        dst.y_buffer,
        dst.y_stride,
        cast,no_check(u32) dw,
        cast,no_check(u32) dh,
        temp_area,
        temp_height,
        hscale,
        hratio,
        vscale,
        vratio,
        interlaced
    );

    if dw < dst.y_width {
        i = 0;
        while i < dh {
            fill_memory(
                dst.y_buffer + i * dst.y_stride + dw - 1,
                cast,no_check(s32) dst.y_buffer[i * dst.y_stride + dw - 2],
                cast,no_check(u64) (dst.y_width - dw + 1)
            );
            i += 1;
        }
    }

    if dh < dst.y_height {
        i = dh - 1;
        while i < dst.y_height {
            copy_memory(
                dst.y_buffer + i * dst.y_stride,
                dst.y_buffer + (dh - 2) * dst.y_stride,
                cast,no_check(u64) (dst.y_width + 1)
            );
            i += 1;
        }
    }

    scale2_d(
        src.u_buffer,
        src.uv_stride,
        cast,no_check(u32) src.uv_width,
        cast,no_check(u32) src.uv_height,
        dst.u_buffer,
        dst.uv_stride,
        cast,no_check(u32) (dw / 2),
        cast,no_check(u32) (dh / 2),
        temp_area,
        temp_height,
        hscale,
        hratio,
        vscale,
        vratio,
        interlaced
    );

    if dw / 2 < dst.uv_width {
        i = 0;
        while i < dst.uv_height {
            fill_memory(
                dst.u_buffer + i * dst.uv_stride + dw / 2 - 1,
                cast,no_check(s32) dst.u_buffer[i * dst.uv_stride + dw / 2 - 2],
                cast,no_check(u64) (dst.uv_width - dw / 2 + 1)
            );
            i += 1;
        }
    }

    if dh / 2 < dst.uv_height {
        i = dh / 2 - 1;
        while i < dst.y_height / 2 {
            copy_memory(
                dst.u_buffer + i * dst.uv_stride,
                dst.u_buffer + (dh / 2 - 2) * dst.uv_stride,
                cast,no_check(u64) dst.uv_width
            );
            i += 1;
        }
    }

    scale2_d(
        src.v_buffer,
        src.uv_stride,
        cast,no_check(u32) src.uv_width,
        cast,no_check(u32) src.uv_height,
        dst.v_buffer,
        dst.uv_stride,
        cast,no_check(u32) (dw / 2),
        cast,no_check(u32) (dh / 2),
        temp_area,
        temp_height,
        hscale,
        hratio,
        vscale,
        vratio,
        interlaced
    );

    if dw / 2 < dst.uv_width {
        i = 0;
        while i < dst.uv_height {
            fill_memory(
                dst.v_buffer + i * dst.uv_stride + dw / 2 - 1,
                cast,no_check(s32) dst.v_buffer[i * dst.uv_stride + dw / 2 - 2],
                cast,no_check(u64) (dst.uv_width - dw / 2 + 1)
            );
            i += 1;
        }
    }

    if dh / 2 < dst.uv_height {
        i = dh / 2 - 1;
        while i < dst.y_height / 2 {
            copy_memory(
                dst.v_buffer + i * dst.uv_stride,
                dst.v_buffer + (dh / 2 - 2) * dst.uv_stride,
                cast,no_check(u64) dst.uv_width
            );
            i += 1;
        }
    }
}

scale2_d :: (
    source: *u8,
    source_pitch: s32,
    source_width: u32,
    source_height: u32,
    dest: *u8,
    dest_pitch: s32,
    dest_width: u32,
    dest_height: u32,
    temp_area: *u8,
    temp_area_height: u8,
    hscale: u32,
    hratio: u32,
    vscale: u32,
    vratio: u32,
    interlaced: u32
) {
    i, j, k: s32 = ---;

    dest_band_height: s32 = ---;
    source_band_height: s32 = ---;


    scale1_dv: Scale1_D = cast,no_check(Scale1_D) scale1d_c;
    scale1_dh: Scale1_D = cast,no_check(Scale1_D) scale1d_c;

    horiz_line_scale: #type (_: *u8, _: u32, _: *u8, _: u32) = null;
    vert_band_scale: #type (_: *u8, _: u32, _: *u8, _: u32, _: u32) = null;

    ratio_scalable: s32 = 1;
    interpolation: s32 = 0;

    line_src: *u8 = ---;

    source_base := source;

    if source_pitch < 0 {
        offset := cast,no_check(s32) (source_height - 1);
        offset *= source_pitch;

        source_base += offset;
    }

    if ((hratio * 10) / hscale) == {
        case 8;
            horiz_line_scale = cast,no_check(#type (_: *u8, _: u32, _: *u8, _: u32)) vp8_horizontal_line_5_4_scale_c;
        case 6;
            horiz_line_scale = cast,no_check(#type (_: *u8, _: u32, _: *u8, _: u32)) vp8_horizontal_line_5_3_scale_c;
        case 5;
            horiz_line_scale = cast,no_check(#type (_: *u8, _: u32, _: *u8, _: u32)) vp8_horizontal_line_2_1_scale_c;
        case;
            ratio_scalable = 0;
    }

    if ((vratio * 10) / vscale) == {
        case 8;
            vert_band_scale =
                cast,no_check(#type (_: *u8, _: u32, _: *u8, _: u32, _: u32)) vp8_vertical_band_5_4_scale_c;
            source_band_height = 5;
            dest_band_height = 4;
        case 6;
            vert_band_scale =
                cast,no_check(#type (_: *u8, _: u32, _: *u8, _: u32, _: u32)) vp8_vertical_band_5_3_scale_c;
            source_band_height = 5;
            dest_band_height = 3;
        case 5;
            if interlaced != 0 {
                vert_band_scale =
                    cast,no_check(#type (_: *u8, _: u32, _: *u8, _: u32, _: u32)) vp8_vertical_band_2_1_scale_c;
            } else {
                interpolation = 1;

                vert_band_scale =
                    cast,no_check(#type (_: *u8, _: u32, _: *u8, _: u32, _: u32)) vp8_vertical_band_2_1_scale_i_c;
            }
            source_band_height = 2;
            dest_band_height = 1;
        case;
            ratio_scalable = 0;
    }

    if ratio_scalable != 0 {
        if source_height == dest_height {
            k = 0;
            while k < cast,no_check(s32) dest_height {
                horiz_line_scale(source, source_width, dest, dest_width);
                source += source_pitch;
                dest += dest_pitch;
                k += 1;
            }

            return;
        }

        if interpolation != 0 {
            if source < source_base {
                source = source_base;
            }

            horiz_line_scale(source, source_width, temp_area, dest_width);
        }

        k = 0;
        while k < (cast,no_check(s32) ((dest_height + cast,no_check(u32) dest_band_height) - 1)) / dest_band_height {
            i = 0;
            while i < source_band_height {
                line_src = source + i * source_pitch;

                if line_src < source_base {
                    line_src = source_base;
                }

                horiz_line_scale(line_src, source_width, temp_area + (i + 1) * dest_pitch, dest_width);
                i += 1;
            }

            vert_band_scale(
                temp_area + dest_pitch,
                cast,no_check(u32) dest_pitch,
                dest,
                cast,no_check(u32) dest_pitch,
                dest_width
            );

            if interpolation != 0 {
                copy_memory(temp_area, temp_area + source_band_height * dest_pitch, cast,no_check(u64) dest_width);
            }

            source += (cast,no_check(u64) source_band_height) * cast,no_check(u64) source_pitch;
            dest += (cast,no_check(u64) dest_band_height) * cast,no_check(u64) dest_pitch;
            k += 1;
        }

        return;
    }

    if hscale == 2 && hratio == 1 {
        scale1_dh = cast,no_check(Scale1_D) scale1d_2t1_ps;
    }

    if vscale == 2 && vratio == 1 {
        if interlaced != 0 {
            scale1_dv = cast,no_check(Scale1_D) scale1d_2t1_ps;
        } else {
            scale1_dv = cast,no_check(Scale1_D) scale1d_2t1_i;
        }
    }

    if source_height == dest_height {
        k = 0;
        while k < cast,no_check(s32) dest_height {
            scale1_dh(source, 1, hscale, source_width + 1, dest, 1, hratio, dest_width);
            source += source_pitch;
            dest += dest_pitch;
            k += 1;
        }

        return;
    }

    if dest_height > source_height {
        dest_band_height = (cast(s32) temp_area_height) - 1;
        source_band_height = cast,no_check(s32) ((cast,no_check(u32) dest_band_height) * source_height / dest_height);
    } else {
        source_band_height = (cast(s32) temp_area_height) - 1;
        dest_band_height = cast,no_check(s32) ((cast,no_check(u32) source_band_height) * vratio / vscale);
    }

    scale1_dh(source, 1, hscale, source_width + 1, temp_area, 1, hratio, dest_width);

    bands :=
        cast,no_check(s32) (((dest_height + cast,no_check(u32) dest_band_height) - 1) /
            cast,no_check(u32) dest_band_height);

    k = 0;
    while k < bands {
        i = 1;
        while i < source_band_height + 1 {
            if k * source_band_height + i < cast,no_check(s32) source_height {
                scale1_dh(
                    source + i * source_pitch,
                    1,
                    hscale,
                    source_width + 1,
                    temp_area + i * dest_pitch,
                    1,
                    hratio,
                    dest_width
                );
            } else {
                copy_memory(temp_area + i * dest_pitch, temp_area + (i - 1) * dest_pitch, cast,no_check(u64) dest_pitch);
            }
            i += 1;
        }

        j = 0;
        while j < cast,no_check(s32) dest_width {
            scale1_dv(
                *temp_area[j],
                dest_pitch,
                vscale,
                cast,no_check(u32) (source_band_height + 1),
                *dest[j],
                dest_pitch,
                vratio,
                cast,no_check(u32) dest_band_height
            );
            j += 1;
        }

        copy_memory(temp_area, temp_area + source_band_height * dest_pitch, cast,no_check(u64) dest_pitch);

        source += source_band_height * source_pitch;
        dest += dest_band_height * dest_pitch;
        k += 1;
    }
}

scale1d_c :: (
    source: *u8,
    source_step: s32,
    source_scale: u32,
    source_length: u32,
    dest: *u8,
    dest_step: s32,
    dest_scale: u32,
    dest_length: u32
) {
    round_value := dest_scale / 2;
    left_modifier := dest_scale;
    right_modifier: u32 = 0;
    left_pixel := source.*;
    right_pixel := (source + source_step).*;

    i: u32 = 0;
    while i < dest_length * cast,no_check(u32) dest_step {
        dest[i] =
            cast,no_check(u8) (cast,no_check(s8) ((((left_modifier * cast(u32) left_pixel) + right_modifier * cast(u32) right_pixel) + round_value) /
                dest_scale));

        right_modifier += source_scale;

        while right_modifier > dest_scale {
            right_modifier -= dest_scale;
            source += source_step;
            left_pixel = source.*;
            right_pixel = (source + source_step).*;
        }

        left_modifier = dest_scale - right_modifier;
        i += cast,no_check(u32) dest_step;
    }
}

scale1d_2t1_i :: (
    source: *u8,
    source_step: s32,
    source_scale: u32,
    source_length: u32,
    dest: *u8,
    dest_step: s32,
    dest_scale: u32,
    dest_length: u32
) {
    i, j: u32 = ---;

    source_pitch := source_step;

    source_step *= 2;
    dest[0] = source[0];

    i = cast,no_check(u32) dest_step;
    j = cast,no_check(u32) source_step;
    while i < dest_length * cast,no_check(u32) dest_step {
        temp: u32 = 8;
        temp += cast,no_check(u32) (3 * cast(s32) source[j - cast,no_check(u32) source_pitch]);
        temp += cast,no_check(u32) (10 * cast(s32) source[j]);
        temp += cast,no_check(u32) (3 * cast(s32) source[j + cast,no_check(u32) source_pitch]);
        c_transpiler_compound_shr(*(temp), (cast(s32) 4), u32, u32);
        dest[i] = cast,no_check(u8) (cast,no_check(s8) temp);
        i += cast,no_check(u32) dest_step;
        j += cast,no_check(u32) source_step;
    }
}

scale1d_2t1_ps :: (
    source: *u8,
    source_step: s32,
    source_scale: u32,
    source_length: u32,
    dest: *u8,
    dest_step: s32,
    dest_scale: u32,
    dest_length: u32
) {
    source_step *= 2;
    j: u32 = 0;

    i: u32 = 0;
    while i < dest_length * cast,no_check(u32) dest_step {
        dest[i] = source[j];
        i += cast,no_check(u32) dest_step;
        j += cast,no_check(u32) source_step;
    }
}

YV12_BUFFER_CONFIG :: Yv12_Buffer_Config;

Yv12_Buffer_Config :: struct {
    y_width: s32;
    y_height: s32;
    y_crop_width: s32;
    y_crop_height: s32;
    y_stride: s32;
    uv_width: s32;
    uv_height: s32;
    uv_crop_width: s32;
    uv_crop_height: s32;
    uv_stride: s32;
    alpha_width: s32;
    alpha_height: s32;
    alpha_stride: s32;
    y_buffer: *u8;
    u_buffer: *u8;
    v_buffer: *u8;
    alpha_buffer: *u8;
    buffer_alloc: *u8;
    buffer_alloc_sz: u64;
    border: s32;
    frame_size: u64;
    subsampling_x: s32;
    subsampling_y: s32;
    bit_depth: u32;
    color_space: Color_Space_T;
    color_range: Color_Range_T;
    render_width: s32;
    render_height: s32;
    corrupted: s32;
    flags: s32;
}

