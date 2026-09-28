vp8_extend_mb_row :: (ybf: *YV12_BUFFER_CONFIG, y_ptr: *u8, u_ptr: *u8, v_ptr: *u8) {
    y_ptr += ybf.y_stride * 14;
    u_ptr += ybf.uv_stride * 6;
    v_ptr += ybf.uv_stride * 6;

    for i: 0..cast(s32) 4 - 1 {
        y_ptr[i] = y_ptr[-1];
        u_ptr[i] = u_ptr[-1];
        v_ptr[i] = v_ptr[-1];
    }

    y_ptr += ybf.y_stride;
    u_ptr += ybf.uv_stride;
    v_ptr += ybf.uv_stride;

    for i: 0..cast(s32) 4 - 1 {
        y_ptr[i] = y_ptr[-1];
        u_ptr[i] = u_ptr[-1];
        v_ptr[i] = v_ptr[-1];
    }
}

vp8_copy_and_extend_frame :: (src: *YV12_BUFFER_CONFIG, dst: *YV12_BUFFER_CONFIG) {
    et := dst.border;
    el := dst.border;
    eb := dst.border + dst.y_height - src.y_height;
    er := dst.border + dst.y_width - src.y_width;

    chroma_step := (ifx src.v_buffer - src.u_buffer == 1 then cast(s32) 2 else 1);

    copy_and_extend_plane(
        src.y_buffer,
        src.y_stride,
        dst.y_buffer,
        dst.y_stride,
        src.y_height,
        src.y_width,
        et,
        el,
        eb,
        er,
        1
    );

    et = dst.border >> 1;
    el = dst.border >> 1;
    eb = dst.border >> 1 + dst.uv_height - src.uv_height;
    er = dst.border >> 1 + dst.uv_width - src.uv_width;

    copy_and_extend_plane(
        src.u_buffer,
        src.uv_stride,
        dst.u_buffer,
        dst.uv_stride,
        src.uv_height,
        src.uv_width,
        et,
        el,
        eb,
        er,
        chroma_step
    );

    copy_and_extend_plane(
        src.v_buffer,
        src.uv_stride,
        dst.v_buffer,
        dst.uv_stride,
        src.uv_height,
        src.uv_width,
        et,
        el,
        eb,
        er,
        chroma_step
    );
}

copy_and_extend_plane :: (
    s: *u8,
    sp: s32,
    d: *u8,
    dp: s32,
    h: s32,
    w: s32,
    et: s32,
    el: s32,
    eb: s32,
    er: s32,
    interleave_step: s32
) {
    j: s32 = ---;

    if interleave_step < 1 {
        interleave_step = 1;
    }

    src_ptr1 := s;
    src_ptr2 := s + (w - 1) * interleave_step;
    dest_ptr1 := d - el;
    dest_ptr2 := d + w;

    if 0 < h {
        for i: 0..h - 1 {
            fill_memory(dest_ptr1, cast,no_check(s32) src_ptr1[0], cast,no_check(u64) el);
            if interleave_step == 1 {
                copy_memory(dest_ptr1 + el, src_ptr1, cast,no_check(u64) w);
            } else {
                j = 0;
                while j < w {
                    dest_ptr1[el + j] = src_ptr1[interleave_step * j];
                    j += 1;
                }
            }
            fill_memory(dest_ptr2, cast,no_check(s32) src_ptr2[0], cast,no_check(u64) er);
            src_ptr1 += sp;
            src_ptr2 += sp;
            dest_ptr1 += dp;
            dest_ptr2 += dp;
        }
    }

    src_ptr1 = d - el;
    src_ptr2 = d + dp * (h - 1) - el;
    dest_ptr1 = d + dp * -et - el;
    dest_ptr2 = d + dp * h - el;
    linesize := el + er + w;

    if 0 < et {
        for i: 0..et - 1 {
            copy_memory(dest_ptr1, src_ptr1, cast,no_check(u64) linesize);
            dest_ptr1 += dp;
        }
    }

    if 0 < eb {
        for i: 0..eb - 1 {
            copy_memory(dest_ptr2, src_ptr2, cast,no_check(u64) linesize);
            dest_ptr2 += dp;
        }
    }
}

vp8_copy_and_extend_frame_with_rect :: (
    src: *YV12_BUFFER_CONFIG,
    dst: *YV12_BUFFER_CONFIG,
    srcy: s32,
    srcx: s32,
    srch: s32,
    srcw: s32
) {
    et := dst.border;
    el := dst.border;
    eb := dst.border + dst.y_height - src.y_height;
    er := dst.border + dst.y_width - src.y_width;
    src_y_offset := srcy * src.y_stride + srcx;
    dst_y_offset := srcy * dst.y_stride + srcx;
    src_uv_offset := (srcy * src.uv_stride) >> 1 + srcx >> 1;
    dst_uv_offset := (srcy * dst.uv_stride) >> 1 + srcx >> 1;

    chroma_step := (ifx src.v_buffer - src.u_buffer == 1 then cast(s32) 2 else 1);

    if srcy != 0 {
        et = 0;
    }
    if srcx != 0 {
        el = 0;
    }
    if srcy + srch != src.y_height {
        eb = 0;
    }
    if srcx + srcw != src.y_width {
        er = 0;
    }

    copy_and_extend_plane(
        src.y_buffer + src_y_offset,
        src.y_stride,
        dst.y_buffer + dst_y_offset,
        dst.y_stride,
        srch,
        srcw,
        et,
        el,
        eb,
        er,
        1
    );

    et = (et + 1) >> 1;
    el = (el + 1) >> 1;
    eb = (eb + 1) >> 1;
    er = (er + 1) >> 1;
    srch = (srch + 1) >> 1;
    srcw = (srcw + 1) >> 1;

    copy_and_extend_plane(
        src.u_buffer + src_uv_offset,
        src.uv_stride,
        dst.u_buffer + dst_uv_offset,
        dst.uv_stride,
        srch,
        srcw,
        et,
        el,
        eb,
        er,
        chroma_step
    );

    copy_and_extend_plane(
        src.v_buffer + src_uv_offset,
        src.uv_stride,
        dst.v_buffer + dst_uv_offset,
        dst.uv_stride,
        srch,
        srcw,
        et,
        el,
        eb,
        er,
        chroma_step
    );
}

