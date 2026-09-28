// Generated directly from C by cpp_transpiler.
vp8_setup_intra_recon :: (ybf: *YV12_BUFFER_CONFIG) {
    fill_memory(ybf.y_buffer - 1 - ybf.y_stride, 127, cast,no_check(u64) (ybf.y_width + 5));
    i: s32 = 0;
    while i < ybf.y_height {
        ybf.y_buffer[ybf.y_stride * i - 1] = 129;
        i += 1;
    }

    fill_memory(ybf.u_buffer - 1 - ybf.uv_stride, 127, cast,no_check(u64) (ybf.uv_width + 5));
    i = 0;
    while i < ybf.uv_height {
        ybf.u_buffer[ybf.uv_stride * i - 1] = 129;
        i += 1;
    }

    fill_memory(ybf.v_buffer - 1 - ybf.uv_stride, 127, cast,no_check(u64) (ybf.uv_width + 5));
    i = 0;
    while i < ybf.uv_height {
        ybf.v_buffer[ybf.uv_stride * i - 1] = 129;
        i += 1;
    }
}

vp8_setup_intra_recon_top_line :: (ybf: *YV12_BUFFER_CONFIG) {
    fill_memory(ybf.y_buffer - 1 - ybf.y_stride, 127, cast,no_check(u64) (ybf.y_width + 5));
    fill_memory(ybf.u_buffer - 1 - ybf.uv_stride, 127, cast,no_check(u64) (ybf.uv_width + 5));
    fill_memory(ybf.v_buffer - 1 - ybf.uv_stride, 127, cast,no_check(u64) (ybf.uv_width + 5));
}

setup_intra_recon_left :: (y_buffer: *u8, u_buffer: *u8, v_buffer: *u8, y_stride: s32, uv_stride: s32) {
    for i: 0..cast(s32) 16 - 1 {
        y_buffer[y_stride * i] = 129;
    }

    for i: 0..cast(s32) 8 - 1 {
        u_buffer[uv_stride * i] = 129;
    }

    for i: 0..cast(s32) 8 - 1 {
        v_buffer[uv_stride * i] = 129;
    }
}

