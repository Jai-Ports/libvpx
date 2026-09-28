// Generated directly from C by cpp_transpiler.
vp8_yv12_copy_frame_c :: (src_ybc: *YV12_BUFFER_CONFIG, dst_ybc: *YV12_BUFFER_CONFIG) {
    src := src_ybc.y_buffer;
    dst := dst_ybc.y_buffer;

    row: s32 = 0;
    while row < src_ybc.y_height {
        copy_memory(dst, src, cast,no_check(u64) src_ybc.y_width);
        src += src_ybc.y_stride;
        dst += dst_ybc.y_stride;
        row += 1;
    }

    src = src_ybc.u_buffer;
    dst = dst_ybc.u_buffer;

    row = 0;
    while row < src_ybc.uv_height {
        copy_memory(dst, src, cast,no_check(u64) src_ybc.uv_width);
        src += src_ybc.uv_stride;
        dst += dst_ybc.uv_stride;
        row += 1;
    }

    src = src_ybc.v_buffer;
    dst = dst_ybc.v_buffer;

    row = 0;
    while row < src_ybc.uv_height {
        copy_memory(dst, src, cast,no_check(u64) src_ybc.uv_width);
        src += src_ybc.uv_stride;
        dst += dst_ybc.uv_stride;
        row += 1;
    }

    vp8_yv12_extend_frame_borders_c(dst_ybc);
}

vp8_yv12_extend_frame_borders_c :: (ybf: *YV12_BUFFER_CONFIG) {
    UV_BORDER := ybf.border / 2;

    extend_plane(
        ybf.y_buffer,
        ybf.y_stride,
        ybf.y_crop_width,
        ybf.y_crop_height,
        ybf.border,
        ybf.border,
        ybf.border + ybf.y_height - ybf.y_crop_height,
        ybf.border + ybf.y_width - ybf.y_crop_width
    );

    extend_plane(
        ybf.u_buffer,
        ybf.uv_stride,
        ybf.uv_crop_width,
        ybf.uv_crop_height,
        UV_BORDER,
        UV_BORDER,
        UV_BORDER + ybf.uv_height - ybf.uv_crop_height,
        UV_BORDER + ybf.uv_width - ybf.uv_crop_width
    );

    extend_plane(
        ybf.v_buffer,
        ybf.uv_stride,
        ybf.uv_crop_width,
        ybf.uv_crop_height,
        UV_BORDER,
        UV_BORDER,
        UV_BORDER + ybf.uv_height - ybf.uv_crop_height,
        UV_BORDER + ybf.uv_width - ybf.uv_crop_width
    );
}

extend_plane :: (
    SRC: *u8,
    src_stride: s32,
    width: s32,
    height: s32,
    extend_top: s32,
    extend_left: s32,
    extend_bottom: s32,
    extend_right: s32
) {
    LINESIZE := extend_left + extend_right + width;

    src_ptr1 := SRC;
    src_ptr2 := SRC + width - 1;
    dst_ptr1 := SRC - extend_left;
    dst_ptr2 := SRC + width;

    if 0 < height {
        for i: 0..height - 1 {
            fill_memory(dst_ptr1, cast,no_check(s32) src_ptr1[0], cast,no_check(u64) extend_left);
            fill_memory(dst_ptr2, cast,no_check(s32) src_ptr2[0], cast,no_check(u64) extend_right);
            src_ptr1 += src_stride;
            src_ptr2 += src_stride;
            dst_ptr1 += src_stride;
            dst_ptr2 += src_stride;
        }
    }

    src_ptr1 = SRC - extend_left;
    src_ptr2 = SRC + src_stride * (height - 1) - extend_left;
    dst_ptr1 = SRC + src_stride * -extend_top - extend_left;
    dst_ptr2 = SRC + src_stride * height - extend_left;

    if 0 < extend_top {
        for i: 0..extend_top - 1 {
            copy_memory(dst_ptr1, src_ptr1, cast,no_check(u64) LINESIZE);
            dst_ptr1 += src_stride;
        }
    }

    if 0 < extend_bottom {
        for i: 0..extend_bottom - 1 {
            copy_memory(dst_ptr2, src_ptr2, cast,no_check(u64) LINESIZE);
            dst_ptr2 += src_stride;
        }
    }
}

extend_frame_borders_c :: (ybf: *YV12_BUFFER_CONFIG) {
    extend_frame(ybf, ybf.border);
}

extend_frame :: (YBF: *YV12_BUFFER_CONFIG, ext_size: s32) {
    C_W := YBF.uv_crop_width;
    C_H := YBF.uv_crop_height;
    SS_X := cast(s32) (YBF.uv_width < YBF.y_width);
    SS_Y := cast(s32) (YBF.uv_height < YBF.y_height);
    C_ET := ext_size >> ((SS_Y) & 31);
    C_EL := ext_size >> ((SS_X) & 31);
    C_EB := C_ET + YBF.uv_height - YBF.uv_crop_height;
    C_ER := C_EL + YBF.uv_width - YBF.uv_crop_width;

    extend_plane(
        YBF.y_buffer,
        YBF.y_stride,
        YBF.y_crop_width,
        YBF.y_crop_height,
        ext_size,
        ext_size,
        ext_size + YBF.y_height - YBF.y_crop_height,
        ext_size + YBF.y_width - YBF.y_crop_width
    );

    extend_plane(YBF.u_buffer, YBF.uv_stride, C_W, C_H, C_ET, C_EL, C_EB, C_ER);

    extend_plane(YBF.v_buffer, YBF.uv_stride, C_W, C_H, C_ET, C_EL, C_EB, C_ER);
}

extend_frame_inner_borders_c :: (ybf: *YV12_BUFFER_CONFIG) {
    INNER_BW := (ifx ybf.border > 96 then 96 else ybf.border);
    extend_frame(ybf, INNER_BW);
}

yv12_copy_frame_c :: (src_ybc: *YV12_BUFFER_CONFIG, dst_ybc: *YV12_BUFFER_CONFIG) {
    src := src_ybc.y_buffer;
    dst := dst_ybc.y_buffer;

    row: s32 = 0;
    while row < src_ybc.y_height {
        copy_memory(dst, src, cast,no_check(u64) src_ybc.y_width);
        src += src_ybc.y_stride;
        dst += dst_ybc.y_stride;
        row += 1;
    }

    src = src_ybc.u_buffer;
    dst = dst_ybc.u_buffer;

    row = 0;
    while row < src_ybc.uv_height {
        copy_memory(dst, src, cast,no_check(u64) src_ybc.uv_width);
        src += src_ybc.uv_stride;
        dst += dst_ybc.uv_stride;
        row += 1;
    }

    src = src_ybc.v_buffer;
    dst = dst_ybc.v_buffer;

    row = 0;
    while row < src_ybc.uv_height {
        copy_memory(dst, src, cast,no_check(u64) src_ybc.uv_width);
        src += src_ybc.uv_stride;
        dst += dst_ybc.uv_stride;
        row += 1;
    }

    extend_frame_borders_c(dst_ybc);
}

yv12_copy_y_c :: (src_ybc: *YV12_BUFFER_CONFIG, dst_ybc: *YV12_BUFFER_CONFIG) {
    src := src_ybc.y_buffer;
    dst := dst_ybc.y_buffer;

    row: s32 = 0;
    while row < src_ybc.y_height {
        copy_memory(dst, src, cast,no_check(u64) src_ybc.y_width);
        src += src_ybc.y_stride;
        dst += dst_ybc.y_stride;
        row += 1;
    }
}

