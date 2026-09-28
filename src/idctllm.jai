SINPI8SQRT2: s32;

COSPI8SQRT2MINUS1: s32;

vp8_dc_only_idct_add_c :: (input_dc: s16, pred_ptr: *u8, pred_stride: s32, dst_ptr: *u8, dst_stride: s32) {
    a1 := ((cast(s32) input_dc) + 4) >> 3;
    c: s32 = ---;

    for r: 0..cast(s32) 4 - 1 {
        c = 0;
        while c < 4 {
            a := a1 + cast(s32) pred_ptr[c];

            if a < 0 {
                a = 0;
            }

            if a > 255 {
                a = 255;
            }

            dst_ptr[c] = cast,no_check(u8) a;
            c += 1;
        }

        dst_ptr += dst_stride;
        pred_ptr += pred_stride;
    }
}

vp8_short_idct4x4llm_c :: (input: *s16, pred_ptr: *u8, pred_stride: s32, dst_ptr: *u8, dst_stride: s32) {
    c: s32 = ---;
    a1, b1, c1, d1: s32 = ---;
    output: [16] s16 = ---;
    ip := input;
    op := output.data;
    temp1, temp2: s32 = ---;
    shortpitch: s32 = 4;

    for i: 0..cast(s32) 4 - 1 {
        a1 = (cast(s32) ip[0]) + cast(s32) ip[8];
        b1 = (cast(s32) ip[0]) - cast(s32) ip[8];

        temp1 = ((cast(s32) ip[4]) * SINPI8SQRT2) >> 16;
        temp2 = (cast(s32) ip[12]) + ((cast(s32) ip[12]) * COSPI8SQRT2MINUS1) >> 16;
        c1 = temp1 - temp2;

        temp1 = (cast(s32) ip[4]) + ((cast(s32) ip[4]) * COSPI8SQRT2MINUS1) >> 16;
        temp2 = ((cast(s32) ip[12]) * SINPI8SQRT2) >> 16;
        d1 = temp1 + temp2;

        op[shortpitch * 0] = cast,no_check(s16) (a1 + d1);
        op[shortpitch * 3] = cast,no_check(s16) (a1 - d1);

        op[shortpitch * 1] = cast,no_check(s16) (b1 + c1);
        op[shortpitch * 2] = cast,no_check(s16) (b1 - c1);

        ip += 1;
        op += 1;
    }

    ip = output.data;
    op = output.data;

    for i: 0..cast(s32) 4 - 1 {
        a1 = (cast(s32) ip[0]) + cast(s32) ip[2];
        b1 = (cast(s32) ip[0]) - cast(s32) ip[2];

        temp1 = ((cast(s32) ip[1]) * SINPI8SQRT2) >> 16;
        temp2 = (cast(s32) ip[3]) + ((cast(s32) ip[3]) * COSPI8SQRT2MINUS1) >> 16;
        c1 = temp1 - temp2;

        temp1 = (cast(s32) ip[1]) + ((cast(s32) ip[1]) * COSPI8SQRT2MINUS1) >> 16;
        temp2 = ((cast(s32) ip[3]) * SINPI8SQRT2) >> 16;
        d1 = temp1 + temp2;

        op[0] = cast,no_check(s16) ((a1 + d1 + 4) >> 3);
        op[3] = cast,no_check(s16) ((a1 - d1 + 4) >> 3);

        op[1] = cast,no_check(s16) ((b1 + c1 + 4) >> 3);
        op[2] = cast,no_check(s16) ((b1 - c1 + 4) >> 3);

        ip += shortpitch;
        op += shortpitch;
    }

    ip = output.data;
    for r: 0..cast(s32) 4 - 1 {
        c = 0;
        while c < 4 {
            a := (cast(s32) ip[c]) + cast(s32) pred_ptr[c];

            if a < 0 {
                a = 0;
            }

            if a > 255 {
                a = 255;
            }

            dst_ptr[c] = cast,no_check(u8) a;
            c += 1;
        }
        ip += 4;
        dst_ptr += dst_stride;
        pred_ptr += pred_stride;
    }
}

vp8_short_inv_walsh4x4_c :: (input: *s16, mb_dqcoeff: *s16) {
    output: [16] s16 = ---;

    a1, b1, c1, d1: s32 = ---;

    ip := input;
    op := output.data;

    for i: 0..cast(s32) 4 - 1 {
        a1 = (cast(s32) ip[0]) + cast(s32) ip[12];
        b1 = (cast(s32) ip[4]) + cast(s32) ip[8];
        c1 = (cast(s32) ip[4]) - cast(s32) ip[8];
        d1 = (cast(s32) ip[0]) - cast(s32) ip[12];

        op[0] = cast,no_check(s16) (a1 + b1);
        op[4] = cast,no_check(s16) (c1 + d1);
        op[8] = cast,no_check(s16) (a1 - b1);
        op[12] = cast,no_check(s16) (d1 - c1);
        ip += 1;
        op += 1;
    }

    ip = output.data;
    op = output.data;

    for i: 0..cast(s32) 4 - 1 {
        a1 = (cast(s32) ip[0]) + cast(s32) ip[3];
        b1 = (cast(s32) ip[1]) + cast(s32) ip[2];
        c1 = (cast(s32) ip[1]) - cast(s32) ip[2];
        d1 = (cast(s32) ip[0]) - cast(s32) ip[3];

        a2 := a1 + b1;
        b2 := c1 + d1;
        c2 := a1 - b1;
        d2 := d1 - c1;

        op[0] = cast,no_check(s16) ((a2 + 3) >> 3);
        op[1] = cast,no_check(s16) ((b2 + 3) >> 3);
        op[2] = cast,no_check(s16) ((c2 + 3) >> 3);
        op[3] = cast,no_check(s16) ((d2 + 3) >> 3);

        ip += 4;
        op += 4;
    }

    for i: 0..cast(s32) 16 - 1 {
        mb_dqcoeff[i * 16] = output[i];
    }
}

vp8_short_inv_walsh4x4_1_c :: (input: *s16, mb_dqcoeff: *s16) {
    a1 := ((cast(s32) input[0]) + 3) >> 3;
    for i: 0..cast(s32) 16 - 1 {
        mb_dqcoeff[i * 16] = cast,no_check(s16) a1;
    }
}

globals_initialization_state_for_idctllm: u32;
initialize_globals_for_idctllm :: () {
    {
        state := atomic_load(*globals_initialization_state_for_idctllm);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_idctllm, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_idctllm) != 2 {}
            return;
        }
    }
    COSPI8SQRT2MINUS1 = 20091;
    SINPI8SQRT2 = 35468;
    atomic_store(*globals_initialization_state_for_idctllm, 2);
}

