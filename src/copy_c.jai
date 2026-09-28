// Generated directly from C by cpp_transpiler.
vp8_copy32xn_c :: (src_ptr: *u8, src_stride: s32, dst_ptr: *u8, dst_stride: s32, height: s32) {
    if 0 < height {
        for r: 0..height - 1 {
            copy_memory(dst_ptr, src_ptr, 32);

            src_ptr += src_stride;
            dst_ptr += dst_stride;
        }
    }
}

