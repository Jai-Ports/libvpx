VP8_BILINEAR_FILTERS: [8] [2] s16 #align 16;

VP8_SUB_PEL_FILTERS: [8] [6] s16 #align 16;

vp8_bilinear_predict16x16_c :: (
    src_ptr: *u8,
    src_pixels_per_line: s32,
    xoffset: s32,
    yoffset: s32,
    dst_ptr: *u8,
    dst_pitch: s32
) {
    h_filter := VP8_BILINEAR_FILTERS[xoffset].data;
    v_filter := VP8_BILINEAR_FILTERS[yoffset].data;

    filter_block2d_bil(
        src_ptr,
        dst_ptr,
        cast,no_check(u32) src_pixels_per_line,
        cast,no_check(u32) dst_pitch,
        h_filter,
        v_filter,
        16,
        16
    );
}

filter_block2d_bil :: (
    src_ptr: *u8,
    dst_ptr: *u8,
    src_pitch: u32,
    dst_pitch: u32,
    h_filter: *s16,
    v_filter: *s16,
    width: s32,
    height: s32
) {
    f_data: [272] u16 = ---;

    filter_block2d_bil_first_pass(
        src_ptr,
        f_data.data,
        src_pitch,
        cast,no_check(u32) (height + 1),
        cast,no_check(u32) width,
        h_filter
    );

    filter_block2d_bil_second_pass(
        f_data.data,
        dst_ptr,
        cast,no_check(s32) dst_pitch,
        cast,no_check(u32) height,
        cast,no_check(u32) width,
        v_filter
    );
}

filter_block2d_bil_second_pass :: (
    src_ptr: *u16,
    dst_ptr: *u8,
    dst_pitch: s32,
    height: u32,
    width: u32,
    vp8_filter: *s16
) {
    j: u32 = ---;
    temp: s32 = ---;

    if 0 < height {
        for i: 0..height - 1 {
            j = 0;
            while j < width {
                temp =
                    (((cast,no_check(s32) src_ptr[0]) * cast(s32) vp8_filter[0]) + (cast,no_check(s32) src_ptr[width]) * cast(s32) vp8_filter[1]) +
                        cast,no_check(s32) ((128 / 2));
                dst_ptr[j] = cast,no_check(u8) (cast,no_check(u32) (temp >> 7));
                src_ptr += 1;
                j += 1;
            }

            dst_ptr += dst_pitch;
        }
    }
}

filter_block2d_bil_first_pass :: (
    src_ptr: *u8,
    dst_ptr: *u16,
    src_stride: u32,
    height: u32,
    width: u32,
    vp8_filter: *s16
) {
    j: u32 = ---;

    if 0 < height {
        for i: 0..height - 1 {
            j = 0;
            while j < width {
                dst_ptr[j] =
                    cast,no_check(u16) (((((cast,no_check(s32) src_ptr[0]) * cast(s32) vp8_filter[0]) + (cast,no_check(s32) src_ptr[1]) * cast(s32) vp8_filter[1]) +
                        cast,no_check(s32) ((128 / 2))) >> 7);
                src_ptr += 1;
                j += 1;
            }

            src_ptr += src_stride - width;
            dst_ptr += width;
        }
    }
}

vp8_bilinear_predict4x4_c :: (
    src_ptr: *u8,
    src_pixels_per_line: s32,
    xoffset: s32,
    yoffset: s32,
    dst_ptr: *u8,
    dst_pitch: s32
) {
    h_filter := VP8_BILINEAR_FILTERS[xoffset].data;
    v_filter := VP8_BILINEAR_FILTERS[yoffset].data;
    filter_block2d_bil(
        src_ptr,
        dst_ptr,
        cast,no_check(u32) src_pixels_per_line,
        cast,no_check(u32) dst_pitch,
        h_filter,
        v_filter,
        4,
        4
    );
}

vp8_bilinear_predict8x4_c :: (
    src_ptr: *u8,
    src_pixels_per_line: s32,
    xoffset: s32,
    yoffset: s32,
    dst_ptr: *u8,
    dst_pitch: s32
) {
    h_filter := VP8_BILINEAR_FILTERS[xoffset].data;
    v_filter := VP8_BILINEAR_FILTERS[yoffset].data;

    filter_block2d_bil(
        src_ptr,
        dst_ptr,
        cast,no_check(u32) src_pixels_per_line,
        cast,no_check(u32) dst_pitch,
        h_filter,
        v_filter,
        8,
        4
    );
}

vp8_bilinear_predict8x8_c :: (
    src_ptr: *u8,
    src_pixels_per_line: s32,
    xoffset: s32,
    yoffset: s32,
    dst_ptr: *u8,
    dst_pitch: s32
) {
    h_filter := VP8_BILINEAR_FILTERS[xoffset].data;
    v_filter := VP8_BILINEAR_FILTERS[yoffset].data;

    filter_block2d_bil(
        src_ptr,
        dst_ptr,
        cast,no_check(u32) src_pixels_per_line,
        cast,no_check(u32) dst_pitch,
        h_filter,
        v_filter,
        8,
        8
    );
}

vp8_sixtap_predict16x16_c :: (
    src_ptr: *u8,
    src_pixels_per_line: s32,
    xoffset: s32,
    yoffset: s32,
    dst_ptr: *u8,
    dst_pitch: s32
) {
    f_data: [504] s32 = ---;

    h_filter := VP8_SUB_PEL_FILTERS[xoffset].data;
    v_filter := VP8_SUB_PEL_FILTERS[yoffset].data;

    filter_block2d_first_pass(
        src_ptr - 2 * src_pixels_per_line,
        f_data.data,
        cast,no_check(u32) src_pixels_per_line,
        1,
        21,
        16,
        h_filter
    );

    filter_block2d_second_pass(f_data.data + 32, dst_ptr, dst_pitch, 16, 16, 16, 16, v_filter);
}

filter_block2d_second_pass :: (
    src_ptr: *s32,
    output_ptr: *u8,
    output_pitch: s32,
    src_pixels_per_line: u32,
    pixel_step: u32,
    output_height: u32,
    output_width: u32,
    vp8_filter: *s16
) {
    j: u32 = ---;
    temp: s32 = ---;

    if 0 < output_height {
        for i: 0..output_height - 1 {
            j = 0;
            while j < output_width {
                temp =
                    ((((((src_ptr[-2 * cast,no_check(s32) pixel_step] * cast(s32) vp8_filter[0]) + src_ptr[-1 * cast,no_check(s32) pixel_step] * cast(s32) vp8_filter[1]) + src_ptr[0] * cast(s32) vp8_filter[2]) + src_ptr[pixel_step] * cast(s32) vp8_filter[3]) + src_ptr[2 * pixel_step] * cast(s32) vp8_filter[4]) + src_ptr[3 * pixel_step] * cast(s32) vp8_filter[5]) +
                        (cast(s32) 128) >> 1;

                temp = temp >> 7;

                if temp < 0 {
                    temp = 0;
                } else if temp > 255 {
                    temp = 255;
                }

                output_ptr[j] = cast,no_check(u8) temp;
                src_ptr += 1;
                j += 1;
            }

            src_ptr += src_pixels_per_line - output_width;
            output_ptr += output_pitch;
        }
    }
}

filter_block2d_first_pass :: (
    src_ptr: *u8,
    output_ptr: *s32,
    src_pixels_per_line: u32,
    pixel_step: u32,
    output_height: u32,
    output_width: u32,
    vp8_filter: *s16
) {
    j: u32 = ---;
    temp: s32 = ---;

    if 0 < output_height {
        for i: 0..output_height - 1 {
            j = 0;
            while j < output_width {
                temp =
                    (((((((cast,no_check(s32) src_ptr[-2 * cast,no_check(s32) pixel_step]) * cast(s32) vp8_filter[0]) + (cast,no_check(s32) src_ptr[-1 * cast,no_check(s32) pixel_step]) * cast(s32) vp8_filter[1]) + (cast,no_check(s32) src_ptr[0]) * cast(s32) vp8_filter[2]) + (cast,no_check(s32) src_ptr[pixel_step]) * cast(s32) vp8_filter[3]) + (cast,no_check(s32) src_ptr[2 * pixel_step]) * cast(s32) vp8_filter[4]) + (cast,no_check(s32) src_ptr[3 * pixel_step]) * cast(s32) vp8_filter[5]) +
                        (cast(s32) 128) >> 1;

                temp = temp >> 7;

                if temp < 0 {
                    temp = 0;
                } else if temp > 255 {
                    temp = 255;
                }

                output_ptr[j] = temp;
                src_ptr += 1;
                j += 1;
            }

            src_ptr += src_pixels_per_line - output_width;
            output_ptr += output_width;
        }
    }
}

vp8_sixtap_predict4x4_c :: (
    src_ptr: *u8,
    src_pixels_per_line: s32,
    xoffset: s32,
    yoffset: s32,
    dst_ptr: *u8,
    dst_pitch: s32
) {
    h_filter := VP8_SUB_PEL_FILTERS[xoffset].data;
    v_filter := VP8_SUB_PEL_FILTERS[yoffset].data;

    filter_block2d(src_ptr, dst_ptr, cast,no_check(u32) src_pixels_per_line, dst_pitch, h_filter, v_filter);
}

filter_block2d :: (
    src_ptr: *u8,
    output_ptr: *u8,
    src_pixels_per_line: u32,
    output_pitch: s32,
    h_filter: *s16,
    v_filter: *s16
) {
    f_data: [36] s32 = ---;

    filter_block2d_first_pass(src_ptr - 2 * src_pixels_per_line, f_data.data, src_pixels_per_line, 1, 9, 4, h_filter);

    filter_block2d_second_pass(f_data.data + 8, output_ptr, output_pitch, 4, 4, 4, 4, v_filter);
}

vp8_sixtap_predict8x4_c :: (
    src_ptr: *u8,
    src_pixels_per_line: s32,
    xoffset: s32,
    yoffset: s32,
    dst_ptr: *u8,
    dst_pitch: s32
) {
    f_data: [208] s32 = ---;

    h_filter := VP8_SUB_PEL_FILTERS[xoffset].data;
    v_filter := VP8_SUB_PEL_FILTERS[yoffset].data;

    filter_block2d_first_pass(
        src_ptr - 2 * src_pixels_per_line,
        f_data.data,
        cast,no_check(u32) src_pixels_per_line,
        1,
        9,
        8,
        h_filter
    );

    filter_block2d_second_pass(f_data.data + 16, dst_ptr, dst_pitch, 8, 8, 4, 8, v_filter);
}

vp8_sixtap_predict8x8_c :: (
    src_ptr: *u8,
    src_pixels_per_line: s32,
    xoffset: s32,
    yoffset: s32,
    dst_ptr: *u8,
    dst_pitch: s32
) {
    f_data: [208] s32 = ---;

    h_filter := VP8_SUB_PEL_FILTERS[xoffset].data;
    v_filter := VP8_SUB_PEL_FILTERS[yoffset].data;

    filter_block2d_first_pass(
        src_ptr - 2 * src_pixels_per_line,
        f_data.data,
        cast,no_check(u32) src_pixels_per_line,
        1,
        13,
        8,
        h_filter
    );

    filter_block2d_second_pass(f_data.data + 16, dst_ptr, dst_pitch, 8, 8, 8, 8, v_filter);
}

globals_initialization_state_for_filter: u32;
initialize_globals_for_filter :: () {
    {
        state := atomic_load(*globals_initialization_state_for_filter);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_filter, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_filter) != 2 {}
            return;
        }
    }
    VP8_BILINEAR_FILTERS =
        [2] s16.[
            s16.[ 128, 0 ],
            s16.[ 112, 16 ],
            s16.[ 96, 32 ],
            s16.[ 80, 48 ],
            s16.[ 64, 64 ],
            s16.[ 48, 80 ],
            s16.[ 32, 96 ],
            s16.[ 16, 112 ]
        ];
    VP8_SUB_PEL_FILTERS =
        [6] s16.[
            s16.[ 0, 0, 128, 0, 0, 0 ],
            s16.[ 0, -6, 123, 12, -1, 0 ],
            s16.[ 2, -11, 108, 36, -8, 1 ],
            s16.[ 0, -9, 93, 50, -6, 0 ],
            s16.[ 3, -16, 77, 77, -16, 3 ],
            s16.[ 0, -6, 50, 93, -9, 0 ],
            s16.[ 1, -8, 36, 108, -11, 2 ],
            s16.[ 0, -1, 12, 123, -6, 0 ]
        ];
    atomic_store(*globals_initialization_state_for_filter, 2);
}

