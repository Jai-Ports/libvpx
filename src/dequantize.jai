// Generated directly from C by cpp_transpiler.
vp8_dequant_idct_add_c :: (input: *s16, dq: *s16, dest: *u8, stride: s32) {
    for i: 0..cast(s32) 16 - 1 {
        input[i] = cast,no_check(s16) ((cast(s32) dq[i]) * cast(s32) input[i]);
    }

    vp8_short_idct4x4llm_c(input, dest, stride, dest, stride);

    fill_memory(input, 0, 32);
}

vp8_dequantize_b_c :: (d: *BLOCKD, dqc: *s16) {
    dq := d.dqcoeff;
    q := d.qcoeff;

    for i: 0..cast(s32) 16 - 1 {
        dq[i] = cast,no_check(s16) ((cast(s32) q[i]) * cast(s32) dqc[i]);
    }
}

