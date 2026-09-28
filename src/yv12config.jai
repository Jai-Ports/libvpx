// Generated directly from C by cpp_transpiler.
vp8_yv12_alloc_frame_buffer :: (ybf: *YV12_BUFFER_CONFIG, width: s32, height: s32, border: s32) -> s32 {
    if ybf != null {
        vp8_yv12_de_alloc_frame_buffer(ybf);
        return vp8_yv12_realloc_frame_buffer(ybf, width, height, border);
    }
    return -2;
}

vp8_yv12_realloc_frame_buffer :: (ybf: *YV12_BUFFER_CONFIG, width: s32, height: s32, border: s32) -> s32 {
    if ybf != null {
        aligned_width := (width + 15) & ~(cast(s32) 15);
        aligned_height := (height + 15) & ~(cast(s32) 15);
        y_stride := (aligned_width + 2 * border + 31) & ~(cast(s32) 31);
        yplane_size := (aligned_height + 2 * border) * y_stride;
        uv_width := aligned_width >> 1;
        uv_height := aligned_height >> 1;

        uv_stride := y_stride >> 1;
        uvplane_size := (uv_height + border) * uv_stride;
        FRAME_SIZE := cast,no_check(u64) (yplane_size + 2 * uvplane_size);

        if ybf.buffer_alloc == null {
            ybf.buffer_alloc = cast(*u8) memalign(32, FRAME_SIZE);
            if ybf.buffer_alloc == null {
                ybf.buffer_alloc_sz = 0;
                return -1;
            }

            ybf.buffer_alloc_sz = FRAME_SIZE;
        }

        if ybf.buffer_alloc_sz < FRAME_SIZE {
            return -1;
        }

        if border & 0x1f != 0 {
            return -3;
        }

        ybf.y_crop_width = width;
        ybf.y_crop_height = height;
        ybf.y_width = aligned_width;
        ybf.y_height = aligned_height;
        ybf.y_stride = y_stride;

        ybf.uv_crop_width = (width + 1) / 2;
        ybf.uv_crop_height = (height + 1) / 2;
        ybf.uv_width = uv_width;
        ybf.uv_height = uv_height;
        ybf.uv_stride = uv_stride;

        ybf.alpha_width = 0;
        ybf.alpha_height = 0;
        ybf.alpha_stride = 0;

        ybf.border = border;
        ybf.frame_size = FRAME_SIZE;

        ybf.y_buffer = ybf.buffer_alloc + border * y_stride + border;
        ybf.u_buffer = ybf.buffer_alloc + yplane_size + border / 2 * uv_stride + border / 2;
        ybf.v_buffer = ybf.buffer_alloc + yplane_size + uvplane_size + border / 2 * uv_stride + border / 2;
        ybf.alpha_buffer = null;

        ybf.corrupted = 0;
        return 0;
    }
    return -2;
}

vp8_yv12_de_alloc_frame_buffer :: (ybf: *YV12_BUFFER_CONFIG) -> s32 {
    if ybf != null {
        if ybf.buffer_alloc_sz > 0 {
            deallocate_memory(cast(*void) ybf.buffer_alloc);
        }

        fill_memory(ybf, 0, size_of(YV12_BUFFER_CONFIG));
    } else {
        return -1;
    }

    return 0;
}

alloc_frame_buffer :: (
    ybf: *YV12_BUFFER_CONFIG,
    width: s32,
    height: s32,
    ss_x: s32,
    ss_y: s32,
    border: s32,
    byte_alignment: s32
) -> s32 {
    if ybf != null {
        free_frame_buffer(ybf);
        return realloc_frame_buffer(ybf, width, height, ss_x, ss_y, border, byte_alignment, null, null, null);
    }
    return -2;
}

realloc_frame_buffer :: (
    ybf: *YV12_BUFFER_CONFIG,
    width: s32,
    height: s32,
    ss_x: s32,
    ss_y: s32,
    border: s32,
    byte_alignment: s32,
    fb: *Codec_Frame_Buffer_T,
    cb: Get_Frame_Buffer_Cb_Fn_T,
    cb_priv: *void
) -> s32 {
    if border & 0x1f != 0 {
        return -3;
    }

    if ybf != null {
        VP9_BYTE_ALIGN := (ifx byte_alignment == 0 then 1 else byte_alignment);
        ALIGNED_WIDTH := (width + 7) & ~(cast(s32) 7);
        ALIGNED_HEIGHT := (height + 7) & ~(cast(s32) 7);
        Y_STRIDE := (ALIGNED_WIDTH + 2 * border + 31) & ~(cast(s32) 31);
        YPLANE_SIZE :=
            ((cast,no_check(u64) (ALIGNED_HEIGHT + 2 * border)) * cast,no_check(u64) Y_STRIDE) +
                cast,no_check(u64) byte_alignment;
        UV_WIDTH := ALIGNED_WIDTH >> ((ss_x) & 31);
        UV_HEIGHT := ALIGNED_HEIGHT >> ((ss_y) & 31);
        UV_STRIDE := Y_STRIDE >> ((ss_x) & 31);
        UV_BORDER_W := border >> ((ss_x) & 31);
        UV_BORDER_H := border >> ((ss_y) & 31);
        UVPLANE_SIZE :=
            ((cast,no_check(u64) (UV_HEIGHT + 2 * UV_BORDER_H)) * cast,no_check(u64) UV_STRIDE) +
                cast,no_check(u64) byte_alignment;

        FRAME_SIZE := YPLANE_SIZE + 2 * UVPLANE_SIZE;

        buf: *u8 = null;

        if cb != null {
            ALIGN_ADDR_EXTRA_SIZE: s32 = 31;
            EXTERNAL_FRAME_SIZE := FRAME_SIZE + cast,no_check(u64) ALIGN_ADDR_EXTRA_SIZE;

            if EXTERNAL_FRAME_SIZE != EXTERNAL_FRAME_SIZE {
                return -1;
            }

            if cb(cb_priv, EXTERNAL_FRAME_SIZE, fb) < 0 {
                return -1;
            }

            if fb.data == null || fb.size < EXTERNAL_FRAME_SIZE {
                return -1;
            }

            ybf.buffer_alloc =
                cast(*u8) (cast,no_check(*void) (((cast,no_check(u64) fb.data) +
                    cast,no_check(u64) (32 - 1)) & cast(u64) 18446744073709551584));
        } else if FRAME_SIZE > ybf.buffer_alloc_sz {
            deallocate_memory(cast(*void) ybf.buffer_alloc);
            ybf.buffer_alloc = null;
            ybf.buffer_alloc_sz = 0;

            ybf.buffer_alloc = cast(*u8) memalign(32, FRAME_SIZE);
            if ybf.buffer_alloc == null {
                return -1;
            }

            ybf.buffer_alloc_sz = FRAME_SIZE;

            fill_memory(ybf.buffer_alloc, 0, ybf.buffer_alloc_sz);
        }

        ybf.y_crop_width = width;
        ybf.y_crop_height = height;
        ybf.y_width = ALIGNED_WIDTH;
        ybf.y_height = ALIGNED_HEIGHT;
        ybf.y_stride = Y_STRIDE;

        ybf.uv_crop_width = (width + ss_x) >> ((ss_x) & 31);
        ybf.uv_crop_height = (height + ss_y) >> ((ss_y) & 31);
        ybf.uv_width = UV_WIDTH;
        ybf.uv_height = UV_HEIGHT;
        ybf.uv_stride = UV_STRIDE;

        ybf.border = border;
        ybf.frame_size = FRAME_SIZE;
        ybf.subsampling_x = ss_x;
        ybf.subsampling_y = ss_y;

        buf = ybf.buffer_alloc;

        ybf.y_buffer =
            cast(*u8) (cast,no_check(*void) (((cast,no_check(u64) (buf + border * Y_STRIDE + border)) +
                cast,no_check(u64) (VP9_BYTE_ALIGN - 1)) & cast,no_check(u64) (-VP9_BYTE_ALIGN)));
        ybf.u_buffer =
            cast(*u8) (cast,no_check(*void) (((cast,no_check(u64) (buf + YPLANE_SIZE + UV_BORDER_H * UV_STRIDE + UV_BORDER_W)) +
                cast,no_check(u64) (VP9_BYTE_ALIGN - 1)) & cast,no_check(u64) (-VP9_BYTE_ALIGN)));
        ybf.v_buffer =
            cast(*u8) (cast,no_check(*void) (((cast,no_check(u64) (buf + YPLANE_SIZE + UVPLANE_SIZE + UV_BORDER_H * UV_STRIDE + UV_BORDER_W)) +
                cast,no_check(u64) (VP9_BYTE_ALIGN - 1)) & cast,no_check(u64) (-VP9_BYTE_ALIGN)));

        ybf.corrupted = 0;
        return 0;
    }
    return -2;
}

free_frame_buffer :: (ybf: *YV12_BUFFER_CONFIG) -> s32 {
    if ybf != null {
        if ybf.buffer_alloc_sz > 0 {
            deallocate_memory(cast(*void) ybf.buffer_alloc);
        }

        fill_memory(ybf, 0, size_of(YV12_BUFFER_CONFIG));
    } else {
        return -1;
    }

    return 0;
}

