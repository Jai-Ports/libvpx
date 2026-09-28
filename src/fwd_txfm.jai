COSPI_30_64: Tran_Coef_T;

COSPI_2_64: Tran_Coef_T;

COSPI_14_64: Tran_Coef_T;

COSPI_18_64: Tran_Coef_T;

COSPI_22_64: Tran_Coef_T;

COSPI_10_64: Tran_Coef_T;

COSPI_6_64: Tran_Coef_T;

COSPI_26_64: Tran_Coef_T;

COSPI_8_64: Tran_Coef_T;

COSPI_24_64: Tran_Coef_T;

COSPI_16_64: Tran_Coef_T;

COSPI_4_64: Tran_Coef_T;

COSPI_28_64: Tran_Coef_T;

COSPI_20_64: Tran_Coef_T;

COSPI_12_64: Tran_Coef_T;

COSPI_1_64: Tran_Coef_T;

COSPI_31_64: Tran_Coef_T;

COSPI_17_64: Tran_Coef_T;

COSPI_15_64: Tran_Coef_T;

COSPI_9_64: Tran_Coef_T;

COSPI_23_64: Tran_Coef_T;

COSPI_25_64: Tran_Coef_T;

COSPI_7_64: Tran_Coef_T;

COSPI_5_64: Tran_Coef_T;

COSPI_27_64: Tran_Coef_T;

COSPI_21_64: Tran_Coef_T;

COSPI_11_64: Tran_Coef_T;

COSPI_13_64: Tran_Coef_T;

COSPI_19_64: Tran_Coef_T;

COSPI_29_64: Tran_Coef_T;

COSPI_3_64: Tran_Coef_T;

SINPI_1_9: Tran_Coef_T;

SINPI_2_9: Tran_Coef_T;

SINPI_3_9: Tran_Coef_T;

SINPI_4_9: Tran_Coef_T;

clip_pixel_in_fwd_txfm :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_fwd_txfm :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_fwd_txfm :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_fwd_txfm :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_fwd_txfm :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_fwd_txfm(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_fwd_txfm(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_fwd_txfm(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_fwd_txfm :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_fwd_txfm :: (FILTER: *s16) -> s32 {
    if (cast(s32) FILTER[0]) | cast(s32) FILTER[7] != 0 {
        return 8;
    }
    if (cast(s32) FILTER[1]) | cast(s32) FILTER[6] != 0 {
        return 6;
    }
    if (cast(s32) FILTER[2]) | cast(s32) FILTER[5] != 0 {
        return 4;
    }
    return 2;
}

fdct16x16_c :: (input: *s16, output: *Tran_Low_T, stride: s32) {
    intermediate: [256] Tran_Low_T = ---;
    in_low: *Tran_Low_T = null;
    out := intermediate.data;

    for pass: 0..cast(s32) 2 - 1 {
        step1: [8] Tran_High_T = ---;
        step2: [8] Tran_High_T = ---;
        step3: [8] Tran_High_T = ---;
        in_high: [8] Tran_High_T = ---;

        for i: 0..cast(s32) 16 - 1 {
            if 0 == pass {
                in_high[0] = ((cast(s32) input[0 * stride]) + cast(s32) input[15 * stride]) * 4;
                in_high[1] = ((cast(s32) input[1 * stride]) + cast(s32) input[14 * stride]) * 4;
                in_high[2] = ((cast(s32) input[2 * stride]) + cast(s32) input[13 * stride]) * 4;
                in_high[3] = ((cast(s32) input[3 * stride]) + cast(s32) input[12 * stride]) * 4;
                in_high[4] = ((cast(s32) input[4 * stride]) + cast(s32) input[11 * stride]) * 4;
                in_high[5] = ((cast(s32) input[5 * stride]) + cast(s32) input[10 * stride]) * 4;
                in_high[6] = ((cast(s32) input[6 * stride]) + cast(s32) input[9 * stride]) * 4;
                in_high[7] = ((cast(s32) input[7 * stride]) + cast(s32) input[8 * stride]) * 4;

                step1[0] = ((cast(s32) input[7 * stride]) - cast(s32) input[8 * stride]) * 4;
                step1[1] = ((cast(s32) input[6 * stride]) - cast(s32) input[9 * stride]) * 4;
                step1[2] = ((cast(s32) input[5 * stride]) - cast(s32) input[10 * stride]) * 4;
                step1[3] = ((cast(s32) input[4 * stride]) - cast(s32) input[11 * stride]) * 4;
                step1[4] = ((cast(s32) input[3 * stride]) - cast(s32) input[12 * stride]) * 4;
                step1[5] = ((cast(s32) input[2 * stride]) - cast(s32) input[13 * stride]) * 4;
                step1[6] = ((cast(s32) input[1 * stride]) - cast(s32) input[14 * stride]) * 4;
                step1[7] = ((cast(s32) input[0 * stride]) - cast(s32) input[15 * stride]) * 4;
            } else {
                in_high[0] = ((cast(s32) in_low[0 * 16]) + 1) >> 2 + ((cast(s32) in_low[15 * 16]) + 1) >> 2;
                in_high[1] = ((cast(s32) in_low[1 * 16]) + 1) >> 2 + ((cast(s32) in_low[14 * 16]) + 1) >> 2;
                in_high[2] = ((cast(s32) in_low[2 * 16]) + 1) >> 2 + ((cast(s32) in_low[13 * 16]) + 1) >> 2;
                in_high[3] = ((cast(s32) in_low[3 * 16]) + 1) >> 2 + ((cast(s32) in_low[12 * 16]) + 1) >> 2;
                in_high[4] = ((cast(s32) in_low[4 * 16]) + 1) >> 2 + ((cast(s32) in_low[11 * 16]) + 1) >> 2;
                in_high[5] = ((cast(s32) in_low[5 * 16]) + 1) >> 2 + ((cast(s32) in_low[10 * 16]) + 1) >> 2;
                in_high[6] = ((cast(s32) in_low[6 * 16]) + 1) >> 2 + ((cast(s32) in_low[9 * 16]) + 1) >> 2;
                in_high[7] = ((cast(s32) in_low[7 * 16]) + 1) >> 2 + ((cast(s32) in_low[8 * 16]) + 1) >> 2;

                step1[0] = ((cast(s32) in_low[7 * 16]) + 1) >> 2 - ((cast(s32) in_low[8 * 16]) + 1) >> 2;
                step1[1] = ((cast(s32) in_low[6 * 16]) + 1) >> 2 - ((cast(s32) in_low[9 * 16]) + 1) >> 2;
                step1[2] = ((cast(s32) in_low[5 * 16]) + 1) >> 2 - ((cast(s32) in_low[10 * 16]) + 1) >> 2;
                step1[3] = ((cast(s32) in_low[4 * 16]) + 1) >> 2 - ((cast(s32) in_low[11 * 16]) + 1) >> 2;
                step1[4] = ((cast(s32) in_low[3 * 16]) + 1) >> 2 - ((cast(s32) in_low[12 * 16]) + 1) >> 2;
                step1[5] = ((cast(s32) in_low[2 * 16]) + 1) >> 2 - ((cast(s32) in_low[13 * 16]) + 1) >> 2;
                step1[6] = ((cast(s32) in_low[1 * 16]) + 1) >> 2 - ((cast(s32) in_low[14 * 16]) + 1) >> 2;
                step1[7] = ((cast(s32) in_low[0 * 16]) + 1) >> 2 - ((cast(s32) in_low[15 * 16]) + 1) >> 2;
                in_low += 1;
            }

            {
                s0 := in_high[0] + in_high[7];
                s1 := in_high[1] + in_high[6];
                s2 := in_high[2] + in_high[5];
                s3 := in_high[3] + in_high[4];
                s4 := in_high[3] - in_high[4];
                s5 := in_high[2] - in_high[5];
                s6 := in_high[1] - in_high[6];
                s7 := in_high[0] - in_high[7];

                x0 := s0 + s3;
                x1 := s1 + s2;
                x2 := s1 - s2;
                x3 := s0 - s3;
                t0 := (x0 + x1) * cast(Tran_High_T) COSPI_16_64;
                t1 := (x0 - x1) * cast(Tran_High_T) COSPI_16_64;
                t2 := (x3 * cast(Tran_High_T) COSPI_8_64) + x2 * cast(Tran_High_T) COSPI_24_64;
                t3 := (x3 * cast(Tran_High_T) COSPI_24_64) - x2 * cast(Tran_High_T) COSPI_8_64;
                out[0] = cast,no_check(Tran_Low_T) fdct_round_shift(t0);
                out[4] = cast,no_check(Tran_Low_T) fdct_round_shift(t2);
                out[8] = cast,no_check(Tran_Low_T) fdct_round_shift(t1);
                out[12] = cast,no_check(Tran_Low_T) fdct_round_shift(t3);

                t0 = (s6 - s5) * cast(Tran_High_T) COSPI_16_64;
                t1 = (s6 + s5) * cast(Tran_High_T) COSPI_16_64;
                t2 = fdct_round_shift(t0);
                t3 = fdct_round_shift(t1);

                x0 = s4 + t2;
                x1 = s4 - t2;
                x2 = s7 - t3;
                x3 = s7 + t3;

                t0 = (x0 * cast(Tran_High_T) COSPI_28_64) + x3 * cast(Tran_High_T) COSPI_4_64;
                t1 = (x1 * cast(Tran_High_T) COSPI_12_64) + x2 * cast(Tran_High_T) COSPI_20_64;
                t2 = (x2 * cast(Tran_High_T) COSPI_12_64) + x1 * -(cast,no_check(s32) COSPI_20_64);
                t3 = (x3 * cast(Tran_High_T) COSPI_28_64) + x0 * -(cast,no_check(s32) COSPI_4_64);
                out[2] = cast,no_check(Tran_Low_T) fdct_round_shift(t0);
                out[6] = cast,no_check(Tran_Low_T) fdct_round_shift(t2);
                out[10] = cast,no_check(Tran_Low_T) fdct_round_shift(t1);
                out[14] = cast,no_check(Tran_Low_T) fdct_round_shift(t3);
            }

            temp1 := (step1[5] - step1[2]) * cast(Tran_High_T) COSPI_16_64;
            temp2 := (step1[4] - step1[3]) * cast(Tran_High_T) COSPI_16_64;
            step2[2] = fdct_round_shift(temp1);
            step2[3] = fdct_round_shift(temp2);
            temp1 = (step1[4] + step1[3]) * cast(Tran_High_T) COSPI_16_64;
            temp2 = (step1[5] + step1[2]) * cast(Tran_High_T) COSPI_16_64;
            step2[4] = fdct_round_shift(temp1);
            step2[5] = fdct_round_shift(temp2);

            step3[0] = step1[0] + step2[3];
            step3[1] = step1[1] + step2[2];
            step3[2] = step1[1] - step2[2];
            step3[3] = step1[0] - step2[3];
            step3[4] = step1[7] - step2[4];
            step3[5] = step1[6] - step2[5];
            step3[6] = step1[6] + step2[5];
            step3[7] = step1[7] + step2[4];

            temp1 = step3[1] * -(cast,no_check(s32) COSPI_8_64) + step3[6] * cast(Tran_High_T) COSPI_24_64;
            temp2 = (step3[2] * cast(Tran_High_T) COSPI_24_64) + step3[5] * cast(Tran_High_T) COSPI_8_64;
            step2[1] = fdct_round_shift(temp1);
            step2[2] = fdct_round_shift(temp2);
            temp1 = (step3[2] * cast(Tran_High_T) COSPI_8_64) - step3[5] * cast(Tran_High_T) COSPI_24_64;
            temp2 = (step3[1] * cast(Tran_High_T) COSPI_24_64) + step3[6] * cast(Tran_High_T) COSPI_8_64;
            step2[5] = fdct_round_shift(temp1);
            step2[6] = fdct_round_shift(temp2);

            step1[0] = step3[0] + step2[1];
            step1[1] = step3[0] - step2[1];
            step1[2] = step3[3] + step2[2];
            step1[3] = step3[3] - step2[2];
            step1[4] = step3[4] - step2[5];
            step1[5] = step3[4] + step2[5];
            step1[6] = step3[7] - step2[6];
            step1[7] = step3[7] + step2[6];

            temp1 = (step1[0] * cast(Tran_High_T) COSPI_30_64) + step1[7] * cast(Tran_High_T) COSPI_2_64;
            temp2 = (step1[1] * cast(Tran_High_T) COSPI_14_64) + step1[6] * cast(Tran_High_T) COSPI_18_64;
            out[1] = cast,no_check(Tran_Low_T) fdct_round_shift(temp1);
            out[9] = cast,no_check(Tran_Low_T) fdct_round_shift(temp2);
            temp1 = (step1[2] * cast(Tran_High_T) COSPI_22_64) + step1[5] * cast(Tran_High_T) COSPI_10_64;
            temp2 = (step1[3] * cast(Tran_High_T) COSPI_6_64) + step1[4] * cast(Tran_High_T) COSPI_26_64;
            out[5] = cast,no_check(Tran_Low_T) fdct_round_shift(temp1);
            out[13] = cast,no_check(Tran_Low_T) fdct_round_shift(temp2);
            temp1 = step1[3] * -(cast,no_check(s32) COSPI_26_64) + step1[4] * cast(Tran_High_T) COSPI_6_64;
            temp2 = step1[2] * -(cast,no_check(s32) COSPI_10_64) + step1[5] * cast(Tran_High_T) COSPI_22_64;
            out[3] = cast,no_check(Tran_Low_T) fdct_round_shift(temp1);
            out[11] = cast,no_check(Tran_Low_T) fdct_round_shift(temp2);
            temp1 = step1[1] * -(cast,no_check(s32) COSPI_18_64) + step1[6] * cast(Tran_High_T) COSPI_14_64;
            temp2 = step1[0] * -(cast,no_check(s32) COSPI_2_64) + step1[7] * cast(Tran_High_T) COSPI_30_64;
            out[7] = cast,no_check(Tran_Low_T) fdct_round_shift(temp1);
            out[15] = cast,no_check(Tran_Low_T) fdct_round_shift(temp2);

            input += 1;
            out += 16;
        }

        in_low = intermediate.data;
        out = output;
    }
}

fdct_round_shift :: (input: Tran_High_T) -> Tran_High_T {
    rv := (input + cast,no_check(Tran_High_T) (((cast(s32) 1) << (((14 - 1)) & 31)))) >> 14;

    return rv;
}

fdct16x16_1_c :: (input: *s16, output: *Tran_Low_T, stride: s32) {
    c: s32 = ---;
    sum: s32 = 0;
    for r: 0..cast(s32) 16 - 1 {
        c = 0;
        while c < 16 {
            sum += cast,no_check(s32) input[r * stride + c];
            c += 1;
        }
    }

    output[0] = cast,no_check(Tran_Low_T) (sum >> 1);
}

fdct32x32_c :: (input: *s16, output: *Tran_Low_T, stride: s32) {
    j: s32 = ---;
    out: [1024] Tran_High_T = ---;

    for i: 0..cast(s32) 32 - 1 {
        temp_in, temp_out: [32] Tran_High_T = ---;
        j = 0;
        while j < 32 {
            temp_in[j] = (cast(s32) input[j * stride + i]) * 4;
            j += 1;
        }
        fdct32(temp_in.data, temp_out.data, 0);
        j = 0;
        while j < 32 {
            out[j * 32 + i] = (temp_out[j] + 1 + cast(Tran_High_T) (temp_out[j] > 0)) >> 2;
            j += 1;
        }
    }

    for i: 0..cast(s32) 32 - 1 {
        temp_in, temp_out: [32] Tran_High_T = ---;
        j = 0;
        while j < 32 {
            temp_in[j] = out[j + i * 32];
            j += 1;
        }
        fdct32(temp_in.data, temp_out.data, 0);
        j = 0;
        while j < 32 {
            output[j + i * 32] =
                cast,no_check(Tran_Low_T) ((temp_out[j] + 1 +
                    cast(Tran_High_T) (temp_out[j] < 0)) >> 2);
            j += 1;
        }
    }
}

fdct32 :: (input: *Tran_High_T, output: *Tran_High_T, round: s32) {
    step: [32] Tran_High_T = ---;

    step[0] = input[0] + input[32 - 1];
    step[1] = input[1] + input[32 - 2];
    step[2] = input[2] + input[32 - 3];
    step[3] = input[3] + input[32 - 4];
    step[4] = input[4] + input[32 - 5];
    step[5] = input[5] + input[32 - 6];
    step[6] = input[6] + input[32 - 7];
    step[7] = input[7] + input[32 - 8];
    step[8] = input[8] + input[32 - 9];
    step[9] = input[9] + input[32 - 10];
    step[10] = input[10] + input[32 - 11];
    step[11] = input[11] + input[32 - 12];
    step[12] = input[12] + input[32 - 13];
    step[13] = input[13] + input[32 - 14];
    step[14] = input[14] + input[32 - 15];
    step[15] = input[15] + input[32 - 16];
    step[16] = -input[16] + input[32 - 17];
    step[17] = -input[17] + input[32 - 18];
    step[18] = -input[18] + input[32 - 19];
    step[19] = -input[19] + input[32 - 20];
    step[20] = -input[20] + input[32 - 21];
    step[21] = -input[21] + input[32 - 22];
    step[22] = -input[22] + input[32 - 23];
    step[23] = -input[23] + input[32 - 24];
    step[24] = -input[24] + input[32 - 25];
    step[25] = -input[25] + input[32 - 26];
    step[26] = -input[26] + input[32 - 27];
    step[27] = -input[27] + input[32 - 28];
    step[28] = -input[28] + input[32 - 29];
    step[29] = -input[29] + input[32 - 30];
    step[30] = -input[30] + input[32 - 31];
    step[31] = -input[31] + input[32 - 32];

    output[0] = step[0] + step[16 - 1];
    output[1] = step[1] + step[16 - 2];
    output[2] = step[2] + step[16 - 3];
    output[3] = step[3] + step[16 - 4];
    output[4] = step[4] + step[16 - 5];
    output[5] = step[5] + step[16 - 6];
    output[6] = step[6] + step[16 - 7];
    output[7] = step[7] + step[16 - 8];
    output[8] = -step[8] + step[16 - 9];
    output[9] = -step[9] + step[16 - 10];
    output[10] = -step[10] + step[16 - 11];
    output[11] = -step[11] + step[16 - 12];
    output[12] = -step[12] + step[16 - 13];
    output[13] = -step[13] + step[16 - 14];
    output[14] = -step[14] + step[16 - 15];
    output[15] = -step[15] + step[16 - 16];

    output[16] = step[16];
    output[17] = step[17];
    output[18] = step[18];
    output[19] = step[19];

    output[20] = dct_32_round((-step[20] + step[27]) * cast(Tran_High_T) COSPI_16_64);
    output[21] = dct_32_round((-step[21] + step[26]) * cast(Tran_High_T) COSPI_16_64);
    output[22] = dct_32_round((-step[22] + step[25]) * cast(Tran_High_T) COSPI_16_64);
    output[23] = dct_32_round((-step[23] + step[24]) * cast(Tran_High_T) COSPI_16_64);

    output[24] = dct_32_round((step[24] + step[23]) * cast(Tran_High_T) COSPI_16_64);
    output[25] = dct_32_round((step[25] + step[22]) * cast(Tran_High_T) COSPI_16_64);
    output[26] = dct_32_round((step[26] + step[21]) * cast(Tran_High_T) COSPI_16_64);
    output[27] = dct_32_round((step[27] + step[20]) * cast(Tran_High_T) COSPI_16_64);

    output[28] = step[28];
    output[29] = step[29];
    output[30] = step[30];
    output[31] = step[31];

    if round != 0 {
        output[0] = half_round_shift(output[0]);
        output[1] = half_round_shift(output[1]);
        output[2] = half_round_shift(output[2]);
        output[3] = half_round_shift(output[3]);
        output[4] = half_round_shift(output[4]);
        output[5] = half_round_shift(output[5]);
        output[6] = half_round_shift(output[6]);
        output[7] = half_round_shift(output[7]);
        output[8] = half_round_shift(output[8]);
        output[9] = half_round_shift(output[9]);
        output[10] = half_round_shift(output[10]);
        output[11] = half_round_shift(output[11]);
        output[12] = half_round_shift(output[12]);
        output[13] = half_round_shift(output[13]);
        output[14] = half_round_shift(output[14]);
        output[15] = half_round_shift(output[15]);

        output[16] = half_round_shift(output[16]);
        output[17] = half_round_shift(output[17]);
        output[18] = half_round_shift(output[18]);
        output[19] = half_round_shift(output[19]);
        output[20] = half_round_shift(output[20]);
        output[21] = half_round_shift(output[21]);
        output[22] = half_round_shift(output[22]);
        output[23] = half_round_shift(output[23]);
        output[24] = half_round_shift(output[24]);
        output[25] = half_round_shift(output[25]);
        output[26] = half_round_shift(output[26]);
        output[27] = half_round_shift(output[27]);
        output[28] = half_round_shift(output[28]);
        output[29] = half_round_shift(output[29]);
        output[30] = half_round_shift(output[30]);
        output[31] = half_round_shift(output[31]);
    }

    step[0] = output[0] + output[8 - 1];
    step[1] = output[1] + output[8 - 2];
    step[2] = output[2] + output[8 - 3];
    step[3] = output[3] + output[8 - 4];
    step[4] = -output[4] + output[8 - 5];
    step[5] = -output[5] + output[8 - 6];
    step[6] = -output[6] + output[8 - 7];
    step[7] = -output[7] + output[8 - 8];
    step[8] = output[8];
    step[9] = output[9];
    step[10] = dct_32_round((-output[10] + output[13]) * cast(Tran_High_T) COSPI_16_64);
    step[11] = dct_32_round((-output[11] + output[12]) * cast(Tran_High_T) COSPI_16_64);
    step[12] = dct_32_round((output[12] + output[11]) * cast(Tran_High_T) COSPI_16_64);
    step[13] = dct_32_round((output[13] + output[10]) * cast(Tran_High_T) COSPI_16_64);
    step[14] = output[14];
    step[15] = output[15];

    step[16] = output[16] + output[23];
    step[17] = output[17] + output[22];
    step[18] = output[18] + output[21];
    step[19] = output[19] + output[20];
    step[20] = -output[20] + output[19];
    step[21] = -output[21] + output[18];
    step[22] = -output[22] + output[17];
    step[23] = -output[23] + output[16];
    step[24] = -output[24] + output[31];
    step[25] = -output[25] + output[30];
    step[26] = -output[26] + output[29];
    step[27] = -output[27] + output[28];
    step[28] = output[28] + output[27];
    step[29] = output[29] + output[26];
    step[30] = output[30] + output[25];
    step[31] = output[31] + output[24];

    output[0] = step[0] + step[3];
    output[1] = step[1] + step[2];
    output[2] = -step[2] + step[1];
    output[3] = -step[3] + step[0];
    output[4] = step[4];
    output[5] = dct_32_round((-step[5] + step[6]) * cast(Tran_High_T) COSPI_16_64);
    output[6] = dct_32_round((step[6] + step[5]) * cast(Tran_High_T) COSPI_16_64);
    output[7] = step[7];
    output[8] = step[8] + step[11];
    output[9] = step[9] + step[10];
    output[10] = -step[10] + step[9];
    output[11] = -step[11] + step[8];
    output[12] = -step[12] + step[15];
    output[13] = -step[13] + step[14];
    output[14] = step[14] + step[13];
    output[15] = step[15] + step[12];

    output[16] = step[16];
    output[17] = step[17];
    output[18] = dct_32_round(step[18] * -(cast,no_check(s32) COSPI_8_64) + step[29] * cast(Tran_High_T) COSPI_24_64);
    output[19] = dct_32_round(step[19] * -(cast,no_check(s32) COSPI_8_64) + step[28] * cast(Tran_High_T) COSPI_24_64);
    output[20] =
        dct_32_round(
            step[20] * -(cast,no_check(s32) COSPI_24_64) + step[27] * -(cast,no_check(s32) COSPI_8_64)
        );
    output[21] =
        dct_32_round(
            step[21] * -(cast,no_check(s32) COSPI_24_64) + step[26] * -(cast,no_check(s32) COSPI_8_64)
        );
    output[22] = step[22];
    output[23] = step[23];
    output[24] = step[24];
    output[25] = step[25];
    output[26] = dct_32_round((step[26] * cast(Tran_High_T) COSPI_24_64) + step[21] * -(cast,no_check(s32) COSPI_8_64));
    output[27] = dct_32_round((step[27] * cast(Tran_High_T) COSPI_24_64) + step[20] * -(cast,no_check(s32) COSPI_8_64));
    output[28] = dct_32_round((step[28] * cast(Tran_High_T) COSPI_8_64) + step[19] * cast(Tran_High_T) COSPI_24_64);
    output[29] = dct_32_round((step[29] * cast(Tran_High_T) COSPI_8_64) + step[18] * cast(Tran_High_T) COSPI_24_64);
    output[30] = step[30];
    output[31] = step[31];

    step[0] = dct_32_round((output[0] + output[1]) * cast(Tran_High_T) COSPI_16_64);
    step[1] = dct_32_round((-output[1] + output[0]) * cast(Tran_High_T) COSPI_16_64);
    step[2] = dct_32_round((output[2] * cast(Tran_High_T) COSPI_24_64) + output[3] * cast(Tran_High_T) COSPI_8_64);
    step[3] = dct_32_round((output[3] * cast(Tran_High_T) COSPI_24_64) - output[2] * cast(Tran_High_T) COSPI_8_64);
    step[4] = output[4] + output[5];
    step[5] = -output[5] + output[4];
    step[6] = -output[6] + output[7];
    step[7] = output[7] + output[6];
    step[8] = output[8];
    step[9] = dct_32_round(output[9] * -(cast,no_check(s32) COSPI_8_64) + output[14] * cast(Tran_High_T) COSPI_24_64);
    step[10] =
        dct_32_round(
            output[10] * -(cast,no_check(s32) COSPI_24_64) + output[13] * -(cast,no_check(s32) COSPI_8_64)
        );
    step[11] = output[11];
    step[12] = output[12];
    step[13] =
        dct_32_round(
            (output[13] * cast(Tran_High_T) COSPI_24_64) + output[10] * -(cast,no_check(s32) COSPI_8_64)
        );
    step[14] = dct_32_round((output[14] * cast(Tran_High_T) COSPI_8_64) + output[9] * cast(Tran_High_T) COSPI_24_64);
    step[15] = output[15];

    step[16] = output[16] + output[19];
    step[17] = output[17] + output[18];
    step[18] = -output[18] + output[17];
    step[19] = -output[19] + output[16];
    step[20] = -output[20] + output[23];
    step[21] = -output[21] + output[22];
    step[22] = output[22] + output[21];
    step[23] = output[23] + output[20];
    step[24] = output[24] + output[27];
    step[25] = output[25] + output[26];
    step[26] = -output[26] + output[25];
    step[27] = -output[27] + output[24];
    step[28] = -output[28] + output[31];
    step[29] = -output[29] + output[30];
    step[30] = output[30] + output[29];
    step[31] = output[31] + output[28];

    output[0] = step[0];
    output[1] = step[1];
    output[2] = step[2];
    output[3] = step[3];
    output[4] = dct_32_round((step[4] * cast(Tran_High_T) COSPI_28_64) + step[7] * cast(Tran_High_T) COSPI_4_64);
    output[5] = dct_32_round((step[5] * cast(Tran_High_T) COSPI_12_64) + step[6] * cast(Tran_High_T) COSPI_20_64);
    output[6] = dct_32_round((step[6] * cast(Tran_High_T) COSPI_12_64) + step[5] * -(cast,no_check(s32) COSPI_20_64));
    output[7] = dct_32_round((step[7] * cast(Tran_High_T) COSPI_28_64) + step[4] * -(cast,no_check(s32) COSPI_4_64));
    output[8] = step[8] + step[9];
    output[9] = -step[9] + step[8];
    output[10] = -step[10] + step[11];
    output[11] = step[11] + step[10];
    output[12] = step[12] + step[13];
    output[13] = -step[13] + step[12];
    output[14] = -step[14] + step[15];
    output[15] = step[15] + step[14];

    output[16] = step[16];
    output[17] = dct_32_round(step[17] * -(cast,no_check(s32) COSPI_4_64) + step[30] * cast(Tran_High_T) COSPI_28_64);
    output[18] =
        dct_32_round(
            step[18] * -(cast,no_check(s32) COSPI_28_64) + step[29] * -(cast,no_check(s32) COSPI_4_64)
        );
    output[19] = step[19];
    output[20] = step[20];
    output[21] = dct_32_round(step[21] * -(cast,no_check(s32) COSPI_20_64) + step[26] * cast(Tran_High_T) COSPI_12_64);
    output[22] =
        dct_32_round(
            step[22] * -(cast,no_check(s32) COSPI_12_64) + step[25] * -(cast,no_check(s32) COSPI_20_64)
        );
    output[23] = step[23];
    output[24] = step[24];
    output[25] =
        dct_32_round((step[25] * cast(Tran_High_T) COSPI_12_64) +
            step[22] * -(cast,no_check(s32) COSPI_20_64));
    output[26] = dct_32_round((step[26] * cast(Tran_High_T) COSPI_20_64) + step[21] * cast(Tran_High_T) COSPI_12_64);
    output[27] = step[27];
    output[28] = step[28];
    output[29] = dct_32_round((step[29] * cast(Tran_High_T) COSPI_28_64) + step[18] * -(cast,no_check(s32) COSPI_4_64));
    output[30] = dct_32_round((step[30] * cast(Tran_High_T) COSPI_4_64) + step[17] * cast(Tran_High_T) COSPI_28_64);
    output[31] = step[31];

    step[0] = output[0];
    step[1] = output[1];
    step[2] = output[2];
    step[3] = output[3];
    step[4] = output[4];
    step[5] = output[5];
    step[6] = output[6];
    step[7] = output[7];
    step[8] = dct_32_round((output[8] * cast(Tran_High_T) COSPI_30_64) + output[15] * cast(Tran_High_T) COSPI_2_64);
    step[9] = dct_32_round((output[9] * cast(Tran_High_T) COSPI_14_64) + output[14] * cast(Tran_High_T) COSPI_18_64);
    step[10] = dct_32_round((output[10] * cast(Tran_High_T) COSPI_22_64) + output[13] * cast(Tran_High_T) COSPI_10_64);
    step[11] = dct_32_round((output[11] * cast(Tran_High_T) COSPI_6_64) + output[12] * cast(Tran_High_T) COSPI_26_64);
    step[12] =
        dct_32_round(
            (output[12] * cast(Tran_High_T) COSPI_6_64) + output[11] * -(cast,no_check(s32) COSPI_26_64)
        );
    step[13] =
        dct_32_round(
            (output[13] * cast(Tran_High_T) COSPI_22_64) + output[10] * -(cast,no_check(s32) COSPI_10_64)
        );
    step[14] =
        dct_32_round(
            (output[14] * cast(Tran_High_T) COSPI_14_64) + output[9] * -(cast,no_check(s32) COSPI_18_64)
        );
    step[15] =
        dct_32_round((output[15] * cast(Tran_High_T) COSPI_30_64) +
            output[8] * -(cast,no_check(s32) COSPI_2_64));

    step[16] = output[16] + output[17];
    step[17] = -output[17] + output[16];
    step[18] = -output[18] + output[19];
    step[19] = output[19] + output[18];
    step[20] = output[20] + output[21];
    step[21] = -output[21] + output[20];
    step[22] = -output[22] + output[23];
    step[23] = output[23] + output[22];
    step[24] = output[24] + output[25];
    step[25] = -output[25] + output[24];
    step[26] = -output[26] + output[27];
    step[27] = output[27] + output[26];
    step[28] = output[28] + output[29];
    step[29] = -output[29] + output[28];
    step[30] = -output[30] + output[31];
    step[31] = output[31] + output[30];

    output[0] = step[0];
    output[16] = step[1];
    output[8] = step[2];
    output[24] = step[3];
    output[4] = step[4];
    output[20] = step[5];
    output[12] = step[6];
    output[28] = step[7];
    output[2] = step[8];
    output[18] = step[9];
    output[10] = step[10];
    output[26] = step[11];
    output[6] = step[12];
    output[22] = step[13];
    output[14] = step[14];
    output[30] = step[15];

    output[1] = dct_32_round((step[16] * cast(Tran_High_T) COSPI_31_64) + step[31] * cast(Tran_High_T) COSPI_1_64);
    output[17] = dct_32_round((step[17] * cast(Tran_High_T) COSPI_15_64) + step[30] * cast(Tran_High_T) COSPI_17_64);
    output[9] = dct_32_round((step[18] * cast(Tran_High_T) COSPI_23_64) + step[29] * cast(Tran_High_T) COSPI_9_64);
    output[25] = dct_32_round((step[19] * cast(Tran_High_T) COSPI_7_64) + step[28] * cast(Tran_High_T) COSPI_25_64);
    output[5] = dct_32_round((step[20] * cast(Tran_High_T) COSPI_27_64) + step[27] * cast(Tran_High_T) COSPI_5_64);
    output[21] = dct_32_round((step[21] * cast(Tran_High_T) COSPI_11_64) + step[26] * cast(Tran_High_T) COSPI_21_64);
    output[13] = dct_32_round((step[22] * cast(Tran_High_T) COSPI_19_64) + step[25] * cast(Tran_High_T) COSPI_13_64);
    output[29] = dct_32_round((step[23] * cast(Tran_High_T) COSPI_3_64) + step[24] * cast(Tran_High_T) COSPI_29_64);
    output[3] = dct_32_round((step[24] * cast(Tran_High_T) COSPI_3_64) + step[23] * -(cast,no_check(s32) COSPI_29_64));
    output[19] =
        dct_32_round((step[25] * cast(Tran_High_T) COSPI_19_64) +
            step[22] * -(cast,no_check(s32) COSPI_13_64));
    output[11] =
        dct_32_round((step[26] * cast(Tran_High_T) COSPI_11_64) +
            step[21] * -(cast,no_check(s32) COSPI_21_64));
    output[27] = dct_32_round((step[27] * cast(Tran_High_T) COSPI_27_64) + step[20] * -(cast,no_check(s32) COSPI_5_64));
    output[7] = dct_32_round((step[28] * cast(Tran_High_T) COSPI_7_64) + step[19] * -(cast,no_check(s32) COSPI_25_64));
    output[23] = dct_32_round((step[29] * cast(Tran_High_T) COSPI_23_64) + step[18] * -(cast,no_check(s32) COSPI_9_64));
    output[15] =
        dct_32_round((step[30] * cast(Tran_High_T) COSPI_15_64) +
            step[17] * -(cast,no_check(s32) COSPI_17_64));
    output[31] = dct_32_round((step[31] * cast(Tran_High_T) COSPI_31_64) + step[16] * -(cast,no_check(s32) COSPI_1_64));
}

dct_32_round :: (input: Tran_High_T) -> Tran_High_T {
    rv := (input + cast,no_check(Tran_High_T) (((cast(s32) 1) << (((14 - 1)) & 31)))) >> 14;

    return rv;
}

half_round_shift :: (input: Tran_High_T) -> Tran_High_T {
    rv := (input + 1 + cast(Tran_High_T) (input < 0)) >> 2;
    return rv;
}

fdct32x32_1_c :: (input: *s16, output: *Tran_Low_T, stride: s32) {
    c: s32 = ---;
    sum: s32 = 0;
    for r: 0..cast(s32) 32 - 1 {
        c = 0;
        while c < 32 {
            sum += cast,no_check(s32) input[r * stride + c];
            c += 1;
        }
    }

    output[0] = cast,no_check(Tran_Low_T) (sum >> 3);
}

fdct32x32_rd_c :: (input: *s16, output: *Tran_Low_T, stride: s32) {
    j: s32 = ---;
    out: [1024] Tran_High_T = ---;

    for i: 0..cast(s32) 32 - 1 {
        temp_in, temp_out: [32] Tran_High_T = ---;
        j = 0;
        while j < 32 {
            temp_in[j] = (cast(s32) input[j * stride + i]) * 4;
            j += 1;
        }
        fdct32(temp_in.data, temp_out.data, 0);
        j = 0;
        while j < 32 {
            out[j * 32 + i] = (temp_out[j] + 1 + cast(Tran_High_T) (temp_out[j] > 0)) >> 2;
            j += 1;
        }
    }

    for i: 0..cast(s32) 32 - 1 {
        temp_in, temp_out: [32] Tran_High_T = ---;
        j = 0;
        while j < 32 {
            temp_in[j] = out[j + i * 32];
            j += 1;
        }
        fdct32(temp_in.data, temp_out.data, 1);
        j = 0;
        while j < 32 {
            output[j + i * 32] = cast,no_check(Tran_Low_T) temp_out[j];
            j += 1;
        }
    }
}

fdct4x4_c :: (input: *s16, output: *Tran_Low_T, stride: s32) {
    intermediate: [16] Tran_Low_T = ---;
    in_low: *Tran_Low_T = null;
    out := intermediate.data;

    for pass: 0..cast(s32) 2 - 1 {
        in_high: [4] Tran_High_T = ---;
        step: [4] Tran_High_T = ---;

        for i: 0..cast(s32) 4 - 1 {
            if pass == 0 {
                in_high[0] = (cast(s32) input[0 * stride]) * 16;
                in_high[1] = (cast(s32) input[1 * stride]) * 16;
                in_high[2] = (cast(s32) input[2 * stride]) * 16;
                in_high[3] = (cast(s32) input[3 * stride]) * 16;
                if i == 0 && in_high[0] != 0 {
                    in_high[0] += 1;
                }
            } else {
                in_high[0] = cast,no_check(Tran_High_T) in_low[0 * 4];
                in_high[1] = cast,no_check(Tran_High_T) in_low[1 * 4];
                in_high[2] = cast,no_check(Tran_High_T) in_low[2 * 4];
                in_high[3] = cast,no_check(Tran_High_T) in_low[3 * 4];
                in_low += 1;
            }

            step[0] = in_high[0] + in_high[3];
            step[1] = in_high[1] + in_high[2];
            step[2] = in_high[1] - in_high[2];
            step[3] = in_high[0] - in_high[3];
            temp1 := (step[0] + step[1]) * cast(Tran_High_T) COSPI_16_64;
            temp2 := (step[0] - step[1]) * cast(Tran_High_T) COSPI_16_64;
            out[0] = cast,no_check(Tran_Low_T) fdct_round_shift(temp1);
            out[2] = cast,no_check(Tran_Low_T) fdct_round_shift(temp2);
            temp1 = (step[2] * cast(Tran_High_T) COSPI_24_64) + step[3] * cast(Tran_High_T) COSPI_8_64;
            temp2 = (-step[2] * cast(Tran_High_T) COSPI_8_64) + step[3] * cast(Tran_High_T) COSPI_24_64;
            out[1] = cast,no_check(Tran_Low_T) fdct_round_shift(temp1);
            out[3] = cast,no_check(Tran_Low_T) fdct_round_shift(temp2);

            input += 1;
            out += 4;
        }

        in_low = intermediate.data;
        out = output;
    }

    {
        j: s32 = ---;
        for i: 0..cast(s32) 4 - 1 {
            j = 0;
            while j < 4 {
                output[j + i * 4] = cast,no_check(Tran_Low_T) (((cast(s32) output[j + i * 4]) + 1) >> 2);
                j += 1;
            }
        }
    }
}

fdct4x4_1_c :: (input: *s16, output: *Tran_Low_T, stride: s32) {
    c: s32 = ---;
    sum: Tran_Low_T = 0;
    for r: 0..cast(s32) 4 - 1 {
        c = 0;
        while c < 4 {
            sum = cast,no_check(Tran_Low_T) ((cast,no_check(s32) sum) + cast,no_check(s32) input[r * stride + c]);
            c += 1;
        }
    }

    output[0] = cast,no_check(Tran_Low_T) ((cast(s32) sum) * 2);
}

fdct8x8_c :: (input: *s16, output: *Tran_Low_T, stride: s32) {
    i, j: s32 = ---;
    intermediate: [64] Tran_Low_T = ---;

    out := intermediate.data;
    in: *Tran_Low_T = null;

    for pass: 0..cast(s32) 2 - 1 {
        s0, s1, s2, s3, s4, s5, s6, s7: Tran_High_T = ---;

        i = 0;
        while i < 8 {
            if pass == 0 {
                s0 = ((cast(s32) input[0 * stride]) + cast(s32) input[7 * stride]) * 4;
                s1 = ((cast(s32) input[1 * stride]) + cast(s32) input[6 * stride]) * 4;
                s2 = ((cast(s32) input[2 * stride]) + cast(s32) input[5 * stride]) * 4;
                s3 = ((cast(s32) input[3 * stride]) + cast(s32) input[4 * stride]) * 4;
                s4 = ((cast(s32) input[3 * stride]) - cast(s32) input[4 * stride]) * 4;
                s5 = ((cast(s32) input[2 * stride]) - cast(s32) input[5 * stride]) * 4;
                s6 = ((cast(s32) input[1 * stride]) - cast(s32) input[6 * stride]) * 4;
                s7 = ((cast(s32) input[0 * stride]) - cast(s32) input[7 * stride]) * 4;
                input += 1;
            } else {
                s0 = (cast(s32) in[0 * 8]) + cast(s32) in[7 * 8];
                s1 = (cast(s32) in[1 * 8]) + cast(s32) in[6 * 8];
                s2 = (cast(s32) in[2 * 8]) + cast(s32) in[5 * 8];
                s3 = (cast(s32) in[3 * 8]) + cast(s32) in[4 * 8];
                s4 = (cast(s32) in[3 * 8]) - cast(s32) in[4 * 8];
                s5 = (cast(s32) in[2 * 8]) - cast(s32) in[5 * 8];
                s6 = (cast(s32) in[1 * 8]) - cast(s32) in[6 * 8];
                s7 = (cast(s32) in[0 * 8]) - cast(s32) in[7 * 8];
                in += 1;
            }

            x0 := s0 + s3;
            x1 := s1 + s2;
            x2 := s1 - s2;
            x3 := s0 - s3;
            t0 := (x0 + x1) * cast(Tran_High_T) COSPI_16_64;
            t1 := (x0 - x1) * cast(Tran_High_T) COSPI_16_64;
            t2 := (x2 * cast(Tran_High_T) COSPI_24_64) + x3 * cast(Tran_High_T) COSPI_8_64;
            t3 := (-x2 * cast(Tran_High_T) COSPI_8_64) + x3 * cast(Tran_High_T) COSPI_24_64;
            out[0] = cast,no_check(Tran_Low_T) fdct_round_shift(t0);
            out[2] = cast,no_check(Tran_Low_T) fdct_round_shift(t2);
            out[4] = cast,no_check(Tran_Low_T) fdct_round_shift(t1);
            out[6] = cast,no_check(Tran_Low_T) fdct_round_shift(t3);

            t0 = (s6 - s5) * cast(Tran_High_T) COSPI_16_64;
            t1 = (s6 + s5) * cast(Tran_High_T) COSPI_16_64;
            t2 = fdct_round_shift(t0);
            t3 = fdct_round_shift(t1);

            x0 = s4 + t2;
            x1 = s4 - t2;
            x2 = s7 - t3;
            x3 = s7 + t3;

            t0 = (x0 * cast(Tran_High_T) COSPI_28_64) + x3 * cast(Tran_High_T) COSPI_4_64;
            t1 = (x1 * cast(Tran_High_T) COSPI_12_64) + x2 * cast(Tran_High_T) COSPI_20_64;
            t2 = (x2 * cast(Tran_High_T) COSPI_12_64) + x1 * -(cast,no_check(s32) COSPI_20_64);
            t3 = (x3 * cast(Tran_High_T) COSPI_28_64) + x0 * -(cast,no_check(s32) COSPI_4_64);
            out[1] = cast,no_check(Tran_Low_T) fdct_round_shift(t0);
            out[3] = cast,no_check(Tran_Low_T) fdct_round_shift(t2);
            out[5] = cast,no_check(Tran_Low_T) fdct_round_shift(t1);
            out[7] = cast,no_check(Tran_Low_T) fdct_round_shift(t3);
            out += 8;
            i += 1;
        }
        in = intermediate.data;
        out = output;
    }

    i = 0;
    while i < 8 {
        j = 0;
        while j < 8 {
            output[j + i * 8] = cast,no_check(Tran_Low_T) ((cast,no_check(s32) output[j + i * 8]) / 2);
            j += 1;
        }
        i += 1;
    }
}

fdct8x8_1_c :: (input: *s16, output: *Tran_Low_T, stride: s32) {
    c: s32 = ---;
    sum: Tran_Low_T = 0;
    for r: 0..cast(s32) 8 - 1 {
        c = 0;
        while c < 8 {
            sum = cast,no_check(Tran_Low_T) ((cast,no_check(s32) sum) + cast,no_check(s32) input[r * stride + c]);
            c += 1;
        }
    }

    output[0] = sum;
}

globals_initialization_state_for_fwd_txfm: u32;
initialize_globals_for_fwd_txfm :: () {
    {
        state := atomic_load(*globals_initialization_state_for_fwd_txfm);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_fwd_txfm, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_fwd_txfm) != 2 {}
            return;
        }
    }
    COSPI_1_64 = 16364;
    COSPI_2_64 = 16305;
    COSPI_3_64 = 16207;
    COSPI_4_64 = 16069;
    COSPI_5_64 = 15893;
    COSPI_6_64 = 15679;
    COSPI_7_64 = 15426;
    COSPI_8_64 = 15137;
    COSPI_9_64 = 14811;
    COSPI_10_64 = 14449;
    COSPI_11_64 = 14053;
    COSPI_12_64 = 13623;
    COSPI_13_64 = 13160;
    COSPI_14_64 = 12665;
    COSPI_15_64 = 12140;
    COSPI_16_64 = 11585;
    COSPI_17_64 = 11003;
    COSPI_18_64 = 10394;
    COSPI_19_64 = 9760;
    COSPI_20_64 = 9102;
    COSPI_21_64 = 8423;
    COSPI_22_64 = 7723;
    COSPI_23_64 = 7005;
    COSPI_24_64 = 6270;
    COSPI_25_64 = 5520;
    COSPI_26_64 = 4756;
    COSPI_27_64 = 3981;
    COSPI_28_64 = 3196;
    COSPI_29_64 = 2404;
    COSPI_30_64 = 1606;
    COSPI_31_64 = 804;
    SINPI_1_9 = 5283;
    SINPI_2_9 = 9929;
    SINPI_3_9 = 13377;
    SINPI_4_9 = 15212;
    atomic_store(*globals_initialization_state_for_fwd_txfm, 2);
}

Tran_Coef_T :: s16;

Tran_Low_T :: s16;

Tran_High_T :: s32;

