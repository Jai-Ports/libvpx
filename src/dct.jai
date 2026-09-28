// Generated directly from C by cpp_transpiler.
vp8_short_fdct4x4_c :: (input: *s16, output: *s16, pitch: s32) {
    a1, b1, c1, d1: s32 = ---;
    ip := input;
    op := output;

    for i: 0..cast(s32) 4 - 1 {
        a1 = ((cast(s32) ip[0]) + cast(s32) ip[3]) * 8;
        b1 = ((cast(s32) ip[1]) + cast(s32) ip[2]) * 8;
        c1 = ((cast(s32) ip[1]) - cast(s32) ip[2]) * 8;
        d1 = ((cast(s32) ip[0]) - cast(s32) ip[3]) * 8;

        op[0] = cast,no_check(s16) (a1 + b1);
        op[2] = cast,no_check(s16) (a1 - b1);

        op[1] = cast,no_check(s16) ((c1 * 2217 + d1 * 5352 + 14500) >> 12);
        op[3] = cast,no_check(s16) ((d1 * 2217 - c1 * 5352 + 7500) >> 12);

        ip += pitch / 2;
        op += 4;
    }
    ip = output;
    op = output;
    for i: 0..cast(s32) 4 - 1 {
        a1 = (cast(s32) ip[0]) + cast(s32) ip[12];
        b1 = (cast(s32) ip[4]) + cast(s32) ip[8];
        c1 = (cast(s32) ip[4]) - cast(s32) ip[8];
        d1 = (cast(s32) ip[0]) - cast(s32) ip[12];

        op[0] = cast,no_check(s16) ((a1 + b1 + 7) >> 4);
        op[8] = cast,no_check(s16) ((a1 - b1 + 7) >> 4);

        op[4] = cast,no_check(s16) ((c1 * 2217 + d1 * 5352 + 12000) >> 16 + cast(s32) (d1 != 0));
        op[12] = cast,no_check(s16) ((d1 * 2217 - c1 * 5352 + 51000) >> 16);

        ip += 1;
        op += 1;
    }
}

vp8_short_fdct8x4_c :: (input: *s16, output: *s16, pitch: s32) {
    vp8_short_fdct4x4_c(input, output, pitch);
    vp8_short_fdct4x4_c(input + 4, output + 16, pitch);
}

vp8_short_walsh4x4_c :: (input: *s16, output: *s16, pitch: s32) {
    a1, b1, c1, d1: s32 = ---;

    ip := input;
    op := output;

    for i: 0..cast(s32) 4 - 1 {
        a1 = ((cast(s32) ip[0]) + cast(s32) ip[2]) * 4;
        d1 = ((cast(s32) ip[1]) + cast(s32) ip[3]) * 4;
        c1 = ((cast(s32) ip[1]) - cast(s32) ip[3]) * 4;
        b1 = ((cast(s32) ip[0]) - cast(s32) ip[2]) * 4;

        op[0] = cast,no_check(s16) (a1 + d1 + cast(s32) (a1 != 0));
        op[1] = cast,no_check(s16) (b1 + c1);
        op[2] = cast,no_check(s16) (b1 - c1);
        op[3] = cast,no_check(s16) (a1 - d1);
        ip += pitch / 2;
        op += 4;
    }

    ip = output;
    op = output;

    for i: 0..cast(s32) 4 - 1 {
        a1 = (cast(s32) ip[0]) + cast(s32) ip[8];
        d1 = (cast(s32) ip[4]) + cast(s32) ip[12];
        c1 = (cast(s32) ip[4]) - cast(s32) ip[12];
        b1 = (cast(s32) ip[0]) - cast(s32) ip[8];

        a2 := a1 + d1;
        b2 := b1 + c1;
        c2 := b1 - c1;
        d2 := a1 - d1;

        a2 += cast(s32) (a2 < 0);
        b2 += cast(s32) (b2 < 0);
        c2 += cast(s32) (c2 < 0);
        d2 += cast(s32) (d2 < 0);

        op[0] = cast,no_check(s16) ((a2 + 3) >> 3);
        op[4] = cast,no_check(s16) ((b2 + 3) >> 3);
        op[8] = cast,no_check(s16) ((c2 + 3) >> 3);
        op[12] = cast,no_check(s16) ((d2 + 3) >> 3);

        ip += 1;
        op += 1;
    }
}

