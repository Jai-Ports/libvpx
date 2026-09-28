// Generated directly from C by cpp_transpiler.
vp8_build_block_doffsets :: (x: *MACROBLOCKD_in_blockd) {
    for block: 0..cast(s32) 16 - 1 {
        x.block[block].offset = block >> 2 * 4 * x.dst.y_stride + block & 3 * 4;
    }

    if 16 < 20 {
        for block: 16..cast(s32) 20 - 1 {
            x.block[block].offset = ((block - 16) >> 1 * 4 * x.dst.uv_stride + block & 1 * 4);
            x.block[block + 4].offset = x.block[block].offset;
        }
    }
}

vp8_setup_block_dptrs :: (x: *MACROBLOCKD_in_blockd) {
    c: s32 = ---;

    for r: 0..cast(s32) 4 - 1 {
        c = 0;
        while c < 4 {
            x.block[r * 4 + c].predictor = x.predictor.data + r * 4 * 16 + c * 4;
            c += 1;
        }
    }

    for r: 0..cast(s32) 2 - 1 {
        c = 0;
        while c < 2 {
            x.block[16 + r * 2 + c].predictor = x.predictor.data + 256 + r * 4 * 8 + c * 4;
            c += 1;
        }
    }

    for r: 0..cast(s32) 2 - 1 {
        c = 0;
        while c < 2 {
            x.block[20 + r * 2 + c].predictor = x.predictor.data + 320 + r * 4 * 8 + c * 4;
            c += 1;
        }
    }

    for r: 0..cast(s32) 25 - 1 {
        x.block[r].qcoeff = x.qcoeff.data + r * 16;
        x.block[r].dqcoeff = x.dqcoeff.data + r * 16;
        x.block[r].eob = x.eobs.data + r;
    }
}

