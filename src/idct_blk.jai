vp8_dequant_idct_add_uv_block_c :: (q: *s16, dq: *s16, dst_u: *u8, dst_v: *u8, stride: s32, eobs: *s8) {
    j: s32 = ---;

    for i: 0..cast(s32) 2 - 1 {
        j = 0;
        while j < 2 {
            if (c_transpiler_post_increment(*(eobs))).* > 1 {
                vp8_dequant_idct_add_c(q, dq, dst_u, stride);
            } else {
                vp8_dc_only_idct_add_c(
                    cast,no_check(s16) ((cast(s32) q[0]) * cast(s32) dq[0]),
                    dst_u,
                    stride,
                    dst_u,
                    stride
                );
                fill_memory(q, 0, cast(u64) 2 * size_of(s16));
            }

            q += 16;
            dst_u += 4;
            j += 1;
        }

        dst_u += 4 * stride - 8;
    }

    for i: 0..cast(s32) 2 - 1 {
        j = 0;
        while j < 2 {
            if (c_transpiler_post_increment(*(eobs))).* > 1 {
                vp8_dequant_idct_add_c(q, dq, dst_v, stride);
            } else {
                vp8_dc_only_idct_add_c(
                    cast,no_check(s16) ((cast(s32) q[0]) * cast(s32) dq[0]),
                    dst_v,
                    stride,
                    dst_v,
                    stride
                );
                fill_memory(q, 0, cast(u64) 2 * size_of(s16));
            }

            q += 16;
            dst_v += 4;
            j += 1;
        }

        dst_v += 4 * stride - 8;
    }
}

vp8_dequant_idct_add_y_block_c :: (q: *s16, dq: *s16, dst: *u8, stride: s32, eobs: *s8) {
    j: s32 = ---;

    for i: 0..cast(s32) 4 - 1 {
        j = 0;
        while j < 4 {
            if (c_transpiler_post_increment(*(eobs))).* > 1 {
                vp8_dequant_idct_add_c(q, dq, dst, stride);
            } else {
                vp8_dc_only_idct_add_c(
                    cast,no_check(s16) ((cast(s32) q[0]) * cast(s32) dq[0]),
                    dst,
                    stride,
                    dst,
                    stride
                );
                fill_memory(q, 0, cast(u64) 2 * size_of(s16));
            }

            q += 16;
            dst += 4;
            j += 1;
        }

        dst += 4 * stride - 16;
    }
}

