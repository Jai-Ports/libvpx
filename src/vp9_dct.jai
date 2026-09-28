SUB_PEL_FILTERS_12_in_vp9_dct: [16] Interp_Kernel12 #align 256;

FHT_16: [4] Transform_2d;

COSPI_16_64_in_vp9_dct: Tran_Coef_T;

COSPI_24_64_in_vp9_dct: Tran_Coef_T;

COSPI_8_64_in_vp9_dct: Tran_Coef_T;

COSPI_12_64_in_vp9_dct: Tran_Coef_T;

COSPI_20_64_in_vp9_dct: Tran_Coef_T;

COSPI_28_64_in_vp9_dct: Tran_Coef_T;

COSPI_4_64_in_vp9_dct: Tran_Coef_T;

COSPI_29_64_in_vp9_dct: Tran_Coef_T;

COSPI_3_64_in_vp9_dct: Tran_Coef_T;

COSPI_25_64_in_vp9_dct: Tran_Coef_T;

COSPI_7_64_in_vp9_dct: Tran_Coef_T;

COSPI_21_64_in_vp9_dct: Tran_Coef_T;

COSPI_11_64_in_vp9_dct: Tran_Coef_T;

COSPI_17_64_in_vp9_dct: Tran_Coef_T;

COSPI_15_64_in_vp9_dct: Tran_Coef_T;

COSPI_13_64_in_vp9_dct: Tran_Coef_T;

COSPI_19_64_in_vp9_dct: Tran_Coef_T;

COSPI_9_64_in_vp9_dct: Tran_Coef_T;

COSPI_23_64_in_vp9_dct: Tran_Coef_T;

COSPI_5_64_in_vp9_dct: Tran_Coef_T;

COSPI_27_64_in_vp9_dct: Tran_Coef_T;

COSPI_1_64_in_vp9_dct: Tran_Coef_T;

COSPI_31_64_in_vp9_dct: Tran_Coef_T;

COSPI_30_64_in_vp9_dct: Tran_Coef_T;

COSPI_2_64_in_vp9_dct: Tran_Coef_T;

COSPI_14_64_in_vp9_dct: Tran_Coef_T;

COSPI_18_64_in_vp9_dct: Tran_Coef_T;

COSPI_22_64_in_vp9_dct: Tran_Coef_T;

COSPI_10_64_in_vp9_dct: Tran_Coef_T;

COSPI_6_64_in_vp9_dct: Tran_Coef_T;

COSPI_26_64_in_vp9_dct: Tran_Coef_T;

FHT_4: [4] Transform_2d;

SINPI_3_9_in_vp9_dct: Tran_Coef_T;

SINPI_2_9_in_vp9_dct: Tran_Coef_T;

SINPI_4_9_in_vp9_dct: Tran_Coef_T;

SINPI_1_9_in_vp9_dct: Tran_Coef_T;

FHT_8: [4] Transform_2d;

COUNT_TO_UPDATE_FACTOR_in_vp9_dct: [21] s32;

clip_pixel_in_vp9_dct :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_dct :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_dct :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_dct :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_dct :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_dct(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_dct(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_dct(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_dct :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_lsb_in_vp9_dct :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_dct :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_dct :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_dct(num_values) + 1 else 0;
}

get_filter_taps_in_vp9_dct :: (FILTER: *s16) -> s32 {
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

vp9_fht16x16_c :: (input: *s16, output: *Tran_Low_T, stride: s32, tx_type: s32) {
    if tx_type == DCT_DCT {
        fdct16x16_c(input, output, stride);
    } else {
        out: [256] Tran_Low_T = ---;
        j: s32 = ---;
        temp_in, temp_out: [16] Tran_Low_T = ---;
        HT := FHT_16[tx_type];

        for i: 0..cast(s32) 16 - 1 {
            j = 0;
            while j < 16 {
                temp_in[j] = cast,no_check(Tran_Low_T) ((cast(s32) input[j * stride + i]) * 4);
                j += 1;
            }
            HT.cols(temp_in.data, temp_out.data);
            j = 0;
            while j < 16 {
                out[j * 16 + i] =
                    cast,no_check(Tran_Low_T) (((cast(s32) temp_out[j]) +
                        1 + cast(s32) (temp_out[j] < 0)) >> 2);
                j += 1;
            }
        }

        for i: 0..cast(s32) 16 - 1 {
            j = 0;
            while j < 16 {
                temp_in[j] = out[j + i * 16];
                j += 1;
            }
            HT.rows(temp_in.data, temp_out.data);
            j = 0;
            while j < 16 {
                output[j + i * 16] = temp_out[j];
                j += 1;
            }
        }
    }
}

fadst16 :: (input: *Tran_Low_T, output: *Tran_Low_T) {
    x0 := cast,no_check(Tran_High_T) input[15];
    x1 := cast,no_check(Tran_High_T) input[0];
    x2 := cast,no_check(Tran_High_T) input[13];
    x3 := cast,no_check(Tran_High_T) input[2];
    x4 := cast,no_check(Tran_High_T) input[11];
    x5 := cast,no_check(Tran_High_T) input[4];
    x6 := cast,no_check(Tran_High_T) input[9];
    x7 := cast,no_check(Tran_High_T) input[6];
    x8 := cast,no_check(Tran_High_T) input[7];
    x9 := cast,no_check(Tran_High_T) input[8];
    x10 := cast,no_check(Tran_High_T) input[5];
    x11 := cast,no_check(Tran_High_T) input[10];
    x12 := cast,no_check(Tran_High_T) input[3];
    x13 := cast,no_check(Tran_High_T) input[12];
    x14 := cast,no_check(Tran_High_T) input[1];
    x15 := cast,no_check(Tran_High_T) input[14];

    s0 := (x0 * cast(Tran_High_T) COSPI_1_64_in_vp9_dct) + x1 * cast(Tran_High_T) COSPI_31_64_in_vp9_dct;
    s1 := (x0 * cast(Tran_High_T) COSPI_31_64_in_vp9_dct) - x1 * cast(Tran_High_T) COSPI_1_64_in_vp9_dct;
    s2 := (x2 * cast(Tran_High_T) COSPI_5_64_in_vp9_dct) + x3 * cast(Tran_High_T) COSPI_27_64_in_vp9_dct;
    s3 := (x2 * cast(Tran_High_T) COSPI_27_64_in_vp9_dct) - x3 * cast(Tran_High_T) COSPI_5_64_in_vp9_dct;
    s4 := (x4 * cast(Tran_High_T) COSPI_9_64_in_vp9_dct) + x5 * cast(Tran_High_T) COSPI_23_64_in_vp9_dct;
    s5 := (x4 * cast(Tran_High_T) COSPI_23_64_in_vp9_dct) - x5 * cast(Tran_High_T) COSPI_9_64_in_vp9_dct;
    s6 := (x6 * cast(Tran_High_T) COSPI_13_64_in_vp9_dct) + x7 * cast(Tran_High_T) COSPI_19_64_in_vp9_dct;
    s7 := (x6 * cast(Tran_High_T) COSPI_19_64_in_vp9_dct) - x7 * cast(Tran_High_T) COSPI_13_64_in_vp9_dct;
    s8_ := (x8 * cast(Tran_High_T) COSPI_17_64_in_vp9_dct) + x9 * cast(Tran_High_T) COSPI_15_64_in_vp9_dct;
    s9 := (x8 * cast(Tran_High_T) COSPI_15_64_in_vp9_dct) - x9 * cast(Tran_High_T) COSPI_17_64_in_vp9_dct;
    s10 := (x10 * cast(Tran_High_T) COSPI_21_64_in_vp9_dct) + x11 * cast(Tran_High_T) COSPI_11_64_in_vp9_dct;
    s11 := (x10 * cast(Tran_High_T) COSPI_11_64_in_vp9_dct) - x11 * cast(Tran_High_T) COSPI_21_64_in_vp9_dct;
    s12 := (x12 * cast(Tran_High_T) COSPI_25_64_in_vp9_dct) + x13 * cast(Tran_High_T) COSPI_7_64_in_vp9_dct;
    s13 := (x12 * cast(Tran_High_T) COSPI_7_64_in_vp9_dct) - x13 * cast(Tran_High_T) COSPI_25_64_in_vp9_dct;
    s14 := (x14 * cast(Tran_High_T) COSPI_29_64_in_vp9_dct) + x15 * cast(Tran_High_T) COSPI_3_64_in_vp9_dct;
    s15 := (x14 * cast(Tran_High_T) COSPI_3_64_in_vp9_dct) - x15 * cast(Tran_High_T) COSPI_29_64_in_vp9_dct;

    x0 = fdct_round_shift_in_vp9_dct(s0 + s8_);
    x1 = fdct_round_shift_in_vp9_dct(s1 + s9);
    x2 = fdct_round_shift_in_vp9_dct(s2 + s10);
    x3 = fdct_round_shift_in_vp9_dct(s3 + s11);
    x4 = fdct_round_shift_in_vp9_dct(s4 + s12);
    x5 = fdct_round_shift_in_vp9_dct(s5 + s13);
    x6 = fdct_round_shift_in_vp9_dct(s6 + s14);
    x7 = fdct_round_shift_in_vp9_dct(s7 + s15);
    x8 = fdct_round_shift_in_vp9_dct(s0 - s8_);
    x9 = fdct_round_shift_in_vp9_dct(s1 - s9);
    x10 = fdct_round_shift_in_vp9_dct(s2 - s10);
    x11 = fdct_round_shift_in_vp9_dct(s3 - s11);
    x12 = fdct_round_shift_in_vp9_dct(s4 - s12);
    x13 = fdct_round_shift_in_vp9_dct(s5 - s13);
    x14 = fdct_round_shift_in_vp9_dct(s6 - s14);
    x15 = fdct_round_shift_in_vp9_dct(s7 - s15);

    s0 = x0;
    s1 = x1;
    s2 = x2;
    s3 = x3;
    s4 = x4;
    s5 = x5;
    s6 = x6;
    s7 = x7;
    s8_ = (x8 * cast(Tran_High_T) COSPI_4_64_in_vp9_dct) + x9 * cast(Tran_High_T) COSPI_28_64_in_vp9_dct;
    s9 = (x8 * cast(Tran_High_T) COSPI_28_64_in_vp9_dct) - x9 * cast(Tran_High_T) COSPI_4_64_in_vp9_dct;
    s10 = (x10 * cast(Tran_High_T) COSPI_20_64_in_vp9_dct) + x11 * cast(Tran_High_T) COSPI_12_64_in_vp9_dct;
    s11 = (x10 * cast(Tran_High_T) COSPI_12_64_in_vp9_dct) - x11 * cast(Tran_High_T) COSPI_20_64_in_vp9_dct;
    s12 = (-x12 * cast(Tran_High_T) COSPI_28_64_in_vp9_dct) + x13 * cast(Tran_High_T) COSPI_4_64_in_vp9_dct;
    s13 = (x12 * cast(Tran_High_T) COSPI_4_64_in_vp9_dct) + x13 * cast(Tran_High_T) COSPI_28_64_in_vp9_dct;
    s14 = (-x14 * cast(Tran_High_T) COSPI_12_64_in_vp9_dct) + x15 * cast(Tran_High_T) COSPI_20_64_in_vp9_dct;
    s15 = (x14 * cast(Tran_High_T) COSPI_20_64_in_vp9_dct) + x15 * cast(Tran_High_T) COSPI_12_64_in_vp9_dct;

    x0 = s0 + s4;
    x1 = s1 + s5;
    x2 = s2 + s6;
    x3 = s3 + s7;
    x4 = s0 - s4;
    x5 = s1 - s5;
    x6 = s2 - s6;
    x7 = s3 - s7;
    x8 = fdct_round_shift_in_vp9_dct(s8_ + s12);
    x9 = fdct_round_shift_in_vp9_dct(s9 + s13);
    x10 = fdct_round_shift_in_vp9_dct(s10 + s14);
    x11 = fdct_round_shift_in_vp9_dct(s11 + s15);
    x12 = fdct_round_shift_in_vp9_dct(s8_ - s12);
    x13 = fdct_round_shift_in_vp9_dct(s9 - s13);
    x14 = fdct_round_shift_in_vp9_dct(s10 - s14);
    x15 = fdct_round_shift_in_vp9_dct(s11 - s15);

    s0 = x0;
    s1 = x1;
    s2 = x2;
    s3 = x3;
    s4 = (x4 * cast(Tran_High_T) COSPI_8_64_in_vp9_dct) + x5 * cast(Tran_High_T) COSPI_24_64_in_vp9_dct;
    s5 = (x4 * cast(Tran_High_T) COSPI_24_64_in_vp9_dct) - x5 * cast(Tran_High_T) COSPI_8_64_in_vp9_dct;
    s6 = (-x6 * cast(Tran_High_T) COSPI_24_64_in_vp9_dct) + x7 * cast(Tran_High_T) COSPI_8_64_in_vp9_dct;
    s7 = (x6 * cast(Tran_High_T) COSPI_8_64_in_vp9_dct) + x7 * cast(Tran_High_T) COSPI_24_64_in_vp9_dct;
    s8_ = x8;
    s9 = x9;
    s10 = x10;
    s11 = x11;
    s12 = (x12 * cast(Tran_High_T) COSPI_8_64_in_vp9_dct) + x13 * cast(Tran_High_T) COSPI_24_64_in_vp9_dct;
    s13 = (x12 * cast(Tran_High_T) COSPI_24_64_in_vp9_dct) - x13 * cast(Tran_High_T) COSPI_8_64_in_vp9_dct;
    s14 = (-x14 * cast(Tran_High_T) COSPI_24_64_in_vp9_dct) + x15 * cast(Tran_High_T) COSPI_8_64_in_vp9_dct;
    s15 = (x14 * cast(Tran_High_T) COSPI_8_64_in_vp9_dct) + x15 * cast(Tran_High_T) COSPI_24_64_in_vp9_dct;

    x0 = s0 + s2;
    x1 = s1 + s3;
    x2 = s0 - s2;
    x3 = s1 - s3;
    x4 = fdct_round_shift_in_vp9_dct(s4 + s6);
    x5 = fdct_round_shift_in_vp9_dct(s5 + s7);
    x6 = fdct_round_shift_in_vp9_dct(s4 - s6);
    x7 = fdct_round_shift_in_vp9_dct(s5 - s7);
    x8 = s8_ + s10;
    x9 = s9 + s11;
    x10 = s8_ - s10;
    x11 = s9 - s11;
    x12 = fdct_round_shift_in_vp9_dct(s12 + s14);
    x13 = fdct_round_shift_in_vp9_dct(s13 + s15);
    x14 = fdct_round_shift_in_vp9_dct(s12 - s14);
    x15 = fdct_round_shift_in_vp9_dct(s13 - s15);

    s2 = -(cast,no_check(s32) COSPI_16_64_in_vp9_dct) * (x2 + x3);
    s3 = (cast(Tran_High_T) COSPI_16_64_in_vp9_dct) * (x2 - x3);
    s6 = (cast(Tran_High_T) COSPI_16_64_in_vp9_dct) * (x6 + x7);
    s7 = (cast(Tran_High_T) COSPI_16_64_in_vp9_dct) * (-x6 + x7);
    s10 = (cast(Tran_High_T) COSPI_16_64_in_vp9_dct) * (x10 + x11);
    s11 = (cast(Tran_High_T) COSPI_16_64_in_vp9_dct) * (-x10 + x11);
    s14 = -(cast,no_check(s32) COSPI_16_64_in_vp9_dct) * (x14 + x15);
    s15 = (cast(Tran_High_T) COSPI_16_64_in_vp9_dct) * (x14 - x15);

    x2 = fdct_round_shift_in_vp9_dct(s2);
    x3 = fdct_round_shift_in_vp9_dct(s3);
    x6 = fdct_round_shift_in_vp9_dct(s6);
    x7 = fdct_round_shift_in_vp9_dct(s7);
    x10 = fdct_round_shift_in_vp9_dct(s10);
    x11 = fdct_round_shift_in_vp9_dct(s11);
    x14 = fdct_round_shift_in_vp9_dct(s14);
    x15 = fdct_round_shift_in_vp9_dct(s15);

    output[0] = cast,no_check(Tran_Low_T) x0;
    output[1] = cast,no_check(Tran_Low_T) (-x8);
    output[2] = cast,no_check(Tran_Low_T) x12;
    output[3] = cast,no_check(Tran_Low_T) (-x4);
    output[4] = cast,no_check(Tran_Low_T) x6;
    output[5] = cast,no_check(Tran_Low_T) x14;
    output[6] = cast,no_check(Tran_Low_T) x10;
    output[7] = cast,no_check(Tran_Low_T) x2;
    output[8] = cast,no_check(Tran_Low_T) x3;
    output[9] = cast,no_check(Tran_Low_T) x11;
    output[10] = cast,no_check(Tran_Low_T) x15;
    output[11] = cast,no_check(Tran_Low_T) x7;
    output[12] = cast,no_check(Tran_Low_T) x5;
    output[13] = cast,no_check(Tran_Low_T) (-x13);
    output[14] = cast,no_check(Tran_Low_T) x9;
    output[15] = cast,no_check(Tran_Low_T) (-x1);
}

fdct_round_shift_in_vp9_dct :: (input: Tran_High_T) -> Tran_High_T {
    rv := (input + cast,no_check(Tran_High_T) (((cast(s32) 1) << (((14 - 1)) & 31)))) >> 14;

    return rv;
}

fdct16 :: (in: *Tran_Low_T, out: *Tran_Low_T) {
    step1: [8] Tran_High_T = ---;
    step2: [8] Tran_High_T = ---;
    step3: [8] Tran_High_T = ---;
    input: [8] Tran_High_T = ---;

    input[0] = (cast(s32) in[0]) + cast(s32) in[15];
    input[1] = (cast(s32) in[1]) + cast(s32) in[14];
    input[2] = (cast(s32) in[2]) + cast(s32) in[13];
    input[3] = (cast(s32) in[3]) + cast(s32) in[12];
    input[4] = (cast(s32) in[4]) + cast(s32) in[11];
    input[5] = (cast(s32) in[5]) + cast(s32) in[10];
    input[6] = (cast(s32) in[6]) + cast(s32) in[9];
    input[7] = (cast(s32) in[7]) + cast(s32) in[8];

    step1[0] = (cast(s32) in[7]) - cast(s32) in[8];
    step1[1] = (cast(s32) in[6]) - cast(s32) in[9];
    step1[2] = (cast(s32) in[5]) - cast(s32) in[10];
    step1[3] = (cast(s32) in[4]) - cast(s32) in[11];
    step1[4] = (cast(s32) in[3]) - cast(s32) in[12];
    step1[5] = (cast(s32) in[2]) - cast(s32) in[13];
    step1[6] = (cast(s32) in[1]) - cast(s32) in[14];
    step1[7] = (cast(s32) in[0]) - cast(s32) in[15];

    {
        s0 := input[0] + input[7];
        s1 := input[1] + input[6];
        s2 := input[2] + input[5];
        s3 := input[3] + input[4];
        s4 := input[3] - input[4];
        s5 := input[2] - input[5];
        s6 := input[1] - input[6];
        s7 := input[0] - input[7];

        x0 := s0 + s3;
        x1 := s1 + s2;
        x2 := s1 - s2;
        x3 := s0 - s3;
        t0 := (x0 + x1) * cast(Tran_High_T) COSPI_16_64_in_vp9_dct;
        t1 := (x0 - x1) * cast(Tran_High_T) COSPI_16_64_in_vp9_dct;
        t2 := (x3 * cast(Tran_High_T) COSPI_8_64_in_vp9_dct) + x2 * cast(Tran_High_T) COSPI_24_64_in_vp9_dct;
        t3 := (x3 * cast(Tran_High_T) COSPI_24_64_in_vp9_dct) - x2 * cast(Tran_High_T) COSPI_8_64_in_vp9_dct;
        out[0] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(t0);
        out[4] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(t2);
        out[8] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(t1);
        out[12] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(t3);

        t0 = (s6 - s5) * cast(Tran_High_T) COSPI_16_64_in_vp9_dct;
        t1 = (s6 + s5) * cast(Tran_High_T) COSPI_16_64_in_vp9_dct;
        t2 = fdct_round_shift_in_vp9_dct(t0);
        t3 = fdct_round_shift_in_vp9_dct(t1);

        x0 = s4 + t2;
        x1 = s4 - t2;
        x2 = s7 - t3;
        x3 = s7 + t3;

        t0 = (x0 * cast(Tran_High_T) COSPI_28_64_in_vp9_dct) + x3 * cast(Tran_High_T) COSPI_4_64_in_vp9_dct;
        t1 = (x1 * cast(Tran_High_T) COSPI_12_64_in_vp9_dct) + x2 * cast(Tran_High_T) COSPI_20_64_in_vp9_dct;
        t2 = (x2 * cast(Tran_High_T) COSPI_12_64_in_vp9_dct) + x1 * -(cast,no_check(s32) COSPI_20_64_in_vp9_dct);
        t3 = (x3 * cast(Tran_High_T) COSPI_28_64_in_vp9_dct) + x0 * -(cast,no_check(s32) COSPI_4_64_in_vp9_dct);
        out[2] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(t0);
        out[6] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(t2);
        out[10] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(t1);
        out[14] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(t3);
    }

    temp1 := (step1[5] - step1[2]) * cast(Tran_High_T) COSPI_16_64_in_vp9_dct;
    temp2 := (step1[4] - step1[3]) * cast(Tran_High_T) COSPI_16_64_in_vp9_dct;
    step2[2] = fdct_round_shift_in_vp9_dct(temp1);
    step2[3] = fdct_round_shift_in_vp9_dct(temp2);
    temp1 = (step1[4] + step1[3]) * cast(Tran_High_T) COSPI_16_64_in_vp9_dct;
    temp2 = (step1[5] + step1[2]) * cast(Tran_High_T) COSPI_16_64_in_vp9_dct;
    step2[4] = fdct_round_shift_in_vp9_dct(temp1);
    step2[5] = fdct_round_shift_in_vp9_dct(temp2);

    step3[0] = step1[0] + step2[3];
    step3[1] = step1[1] + step2[2];
    step3[2] = step1[1] - step2[2];
    step3[3] = step1[0] - step2[3];
    step3[4] = step1[7] - step2[4];
    step3[5] = step1[6] - step2[5];
    step3[6] = step1[6] + step2[5];
    step3[7] = step1[7] + step2[4];

    temp1 =
        step3[1] * -(cast,no_check(s32) COSPI_8_64_in_vp9_dct) +
            step3[6] * cast(Tran_High_T) COSPI_24_64_in_vp9_dct;
    temp2 = (step3[2] * cast(Tran_High_T) COSPI_24_64_in_vp9_dct) + step3[5] * cast(Tran_High_T) COSPI_8_64_in_vp9_dct;
    step2[1] = fdct_round_shift_in_vp9_dct(temp1);
    step2[2] = fdct_round_shift_in_vp9_dct(temp2);
    temp1 = (step3[2] * cast(Tran_High_T) COSPI_8_64_in_vp9_dct) - step3[5] * cast(Tran_High_T) COSPI_24_64_in_vp9_dct;
    temp2 = (step3[1] * cast(Tran_High_T) COSPI_24_64_in_vp9_dct) + step3[6] * cast(Tran_High_T) COSPI_8_64_in_vp9_dct;
    step2[5] = fdct_round_shift_in_vp9_dct(temp1);
    step2[6] = fdct_round_shift_in_vp9_dct(temp2);

    step1[0] = step3[0] + step2[1];
    step1[1] = step3[0] - step2[1];
    step1[2] = step3[3] + step2[2];
    step1[3] = step3[3] - step2[2];
    step1[4] = step3[4] - step2[5];
    step1[5] = step3[4] + step2[5];
    step1[6] = step3[7] - step2[6];
    step1[7] = step3[7] + step2[6];

    temp1 = (step1[0] * cast(Tran_High_T) COSPI_30_64_in_vp9_dct) + step1[7] * cast(Tran_High_T) COSPI_2_64_in_vp9_dct;
    temp2 = (step1[1] * cast(Tran_High_T) COSPI_14_64_in_vp9_dct) + step1[6] * cast(Tran_High_T) COSPI_18_64_in_vp9_dct;
    out[1] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(temp1);
    out[9] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(temp2);

    temp1 = (step1[2] * cast(Tran_High_T) COSPI_22_64_in_vp9_dct) + step1[5] * cast(Tran_High_T) COSPI_10_64_in_vp9_dct;
    temp2 = (step1[3] * cast(Tran_High_T) COSPI_6_64_in_vp9_dct) + step1[4] * cast(Tran_High_T) COSPI_26_64_in_vp9_dct;
    out[5] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(temp1);
    out[13] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(temp2);

    temp1 =
        step1[3] * -(cast,no_check(s32) COSPI_26_64_in_vp9_dct) +
            step1[4] * cast(Tran_High_T) COSPI_6_64_in_vp9_dct;
    temp2 =
        step1[2] * -(cast,no_check(s32) COSPI_10_64_in_vp9_dct) +
            step1[5] * cast(Tran_High_T) COSPI_22_64_in_vp9_dct;
    out[3] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(temp1);
    out[11] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(temp2);

    temp1 =
        step1[1] * -(cast,no_check(s32) COSPI_18_64_in_vp9_dct) +
            step1[6] * cast(Tran_High_T) COSPI_14_64_in_vp9_dct;
    temp2 =
        step1[0] * -(cast,no_check(s32) COSPI_2_64_in_vp9_dct) +
            step1[7] * cast(Tran_High_T) COSPI_30_64_in_vp9_dct;
    out[7] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(temp1);
    out[15] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(temp2);
}

vp9_fht4x4_c :: (input: *s16, output: *Tran_Low_T, stride: s32, tx_type: s32) {
    if tx_type == DCT_DCT {
        fdct4x4_c(input, output, stride);
    } else {
        out: [16] Tran_Low_T = ---;
        j: s32 = ---;
        temp_in, temp_out: [4] Tran_Low_T = ---;
        HT := FHT_4[tx_type];

        for i: 0..cast(s32) 4 - 1 {
            j = 0;
            while j < 4 {
                temp_in[j] = cast,no_check(Tran_Low_T) ((cast(s32) input[j * stride + i]) * 16);
                j += 1;
            }
            if i == 0 && temp_in[0] != 0 {
                temp_in[0] = cast,no_check(Tran_Low_T) ((cast,no_check(s32) temp_in[0]) + 1);
            }
            HT.cols(temp_in.data, temp_out.data);
            j = 0;
            while j < 4 {
                out[j * 4 + i] = temp_out[j];
                j += 1;
            }
        }

        for i: 0..cast(s32) 4 - 1 {
            j = 0;
            while j < 4 {
                temp_in[j] = out[j + i * 4];
                j += 1;
            }
            HT.rows(temp_in.data, temp_out.data);
            j = 0;
            while j < 4 {
                output[j + i * 4] = cast,no_check(Tran_Low_T) (((cast(s32) temp_out[j]) + 1) >> 2);
                j += 1;
            }
        }
    }
}

fadst4 :: (input: *Tran_Low_T, output: *Tran_Low_T) {
    x0 := cast,no_check(Tran_High_T) input[0];
    x1 := cast,no_check(Tran_High_T) input[1];
    x2 := cast,no_check(Tran_High_T) input[2];
    x3 := cast,no_check(Tran_High_T) input[3];

    if x0 | x1 | x2 | x3 == 0 {
        output[3] = 0;
        output[2] = output[3];
        output[1] = output[2];
        output[0] = output[1];
        return;
    }

    s0 := (cast(Tran_High_T) SINPI_1_9_in_vp9_dct) * x0;
    s1 := (cast(Tran_High_T) SINPI_4_9_in_vp9_dct) * x0;
    s2 := (cast(Tran_High_T) SINPI_2_9_in_vp9_dct) * x1;
    s3 := (cast(Tran_High_T) SINPI_1_9_in_vp9_dct) * x1;
    s4 := (cast(Tran_High_T) SINPI_3_9_in_vp9_dct) * x2;
    s5 := (cast(Tran_High_T) SINPI_4_9_in_vp9_dct) * x3;
    s6 := (cast(Tran_High_T) SINPI_2_9_in_vp9_dct) * x3;
    s7 := x0 + x1 - x3;

    x0 = s0 + s2 + s5;
    x1 = (cast(Tran_High_T) SINPI_3_9_in_vp9_dct) * s7;
    x2 = s1 - s3 + s6;
    x3 = s4;

    s0 = x0 + x3;
    s1 = x1;
    s2 = x2 - x3;
    s3 = x2 - x0 + x3;

    output[0] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(s0);
    output[1] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(s1);
    output[2] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(s2);
    output[3] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(s3);
}

fdct4 :: (input: *Tran_Low_T, output: *Tran_Low_T) {
    step: [4] Tran_High_T = ---;

    step[0] = (cast(s32) input[0]) + cast(s32) input[3];
    step[1] = (cast(s32) input[1]) + cast(s32) input[2];
    step[2] = (cast(s32) input[1]) - cast(s32) input[2];
    step[3] = (cast(s32) input[0]) - cast(s32) input[3];

    temp1 := (step[0] + step[1]) * cast(Tran_High_T) COSPI_16_64_in_vp9_dct;
    temp2 := (step[0] - step[1]) * cast(Tran_High_T) COSPI_16_64_in_vp9_dct;
    output[0] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(temp1);
    output[2] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(temp2);
    temp1 = (step[2] * cast(Tran_High_T) COSPI_24_64_in_vp9_dct) + step[3] * cast(Tran_High_T) COSPI_8_64_in_vp9_dct;
    temp2 = (-step[2] * cast(Tran_High_T) COSPI_8_64_in_vp9_dct) + step[3] * cast(Tran_High_T) COSPI_24_64_in_vp9_dct;
    output[1] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(temp1);
    output[3] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(temp2);
}

vp9_fht8x8_c :: (input: *s16, output: *Tran_Low_T, stride: s32, tx_type: s32) {
    if tx_type == DCT_DCT {
        fdct8x8_c(input, output, stride);
    } else {
        out: [64] Tran_Low_T = ---;
        j: s32 = ---;
        temp_in, temp_out: [8] Tran_Low_T = ---;
        HT := FHT_8[tx_type];

        for i: 0..cast(s32) 8 - 1 {
            j = 0;
            while j < 8 {
                temp_in[j] = cast,no_check(Tran_Low_T) ((cast(s32) input[j * stride + i]) * 4);
                j += 1;
            }
            HT.cols(temp_in.data, temp_out.data);
            j = 0;
            while j < 8 {
                out[j * 8 + i] = temp_out[j];
                j += 1;
            }
        }

        for i: 0..cast(s32) 8 - 1 {
            j = 0;
            while j < 8 {
                temp_in[j] = out[j + i * 8];
                j += 1;
            }
            HT.rows(temp_in.data, temp_out.data);
            j = 0;
            while j < 8 {
                output[j + i * 8] =
                    cast,no_check(Tran_Low_T) (((cast(s32) temp_out[j]) +
                        cast(s32) (temp_out[j] < 0)) >> 1);
                j += 1;
            }
        }
    }
}

fadst8 :: (input: *Tran_Low_T, output: *Tran_Low_T) {
    x0 := cast,no_check(Tran_High_T) input[7];
    x1 := cast,no_check(Tran_High_T) input[0];
    x2 := cast,no_check(Tran_High_T) input[5];
    x3 := cast,no_check(Tran_High_T) input[2];
    x4 := cast,no_check(Tran_High_T) input[3];
    x5 := cast,no_check(Tran_High_T) input[4];
    x6 := cast,no_check(Tran_High_T) input[1];
    x7 := cast,no_check(Tran_High_T) input[6];

    s0 := (cast(Tran_High_T) COSPI_2_64_in_vp9_dct) * x0 + (cast(Tran_High_T) COSPI_30_64_in_vp9_dct) * x1;
    s1 := (cast(Tran_High_T) COSPI_30_64_in_vp9_dct) * x0 - (cast(Tran_High_T) COSPI_2_64_in_vp9_dct) * x1;
    s2 := (cast(Tran_High_T) COSPI_10_64_in_vp9_dct) * x2 + (cast(Tran_High_T) COSPI_22_64_in_vp9_dct) * x3;
    s3 := (cast(Tran_High_T) COSPI_22_64_in_vp9_dct) * x2 - (cast(Tran_High_T) COSPI_10_64_in_vp9_dct) * x3;
    s4 := (cast(Tran_High_T) COSPI_18_64_in_vp9_dct) * x4 + (cast(Tran_High_T) COSPI_14_64_in_vp9_dct) * x5;
    s5 := (cast(Tran_High_T) COSPI_14_64_in_vp9_dct) * x4 - (cast(Tran_High_T) COSPI_18_64_in_vp9_dct) * x5;
    s6 := (cast(Tran_High_T) COSPI_26_64_in_vp9_dct) * x6 + (cast(Tran_High_T) COSPI_6_64_in_vp9_dct) * x7;
    s7 := (cast(Tran_High_T) COSPI_6_64_in_vp9_dct) * x6 - (cast(Tran_High_T) COSPI_26_64_in_vp9_dct) * x7;

    x0 = fdct_round_shift_in_vp9_dct(s0 + s4);
    x1 = fdct_round_shift_in_vp9_dct(s1 + s5);
    x2 = fdct_round_shift_in_vp9_dct(s2 + s6);
    x3 = fdct_round_shift_in_vp9_dct(s3 + s7);
    x4 = fdct_round_shift_in_vp9_dct(s0 - s4);
    x5 = fdct_round_shift_in_vp9_dct(s1 - s5);
    x6 = fdct_round_shift_in_vp9_dct(s2 - s6);
    x7 = fdct_round_shift_in_vp9_dct(s3 - s7);

    s0 = x0;
    s1 = x1;
    s2 = x2;
    s3 = x3;
    s4 = (cast(Tran_High_T) COSPI_8_64_in_vp9_dct) * x4 + (cast(Tran_High_T) COSPI_24_64_in_vp9_dct) * x5;
    s5 = (cast(Tran_High_T) COSPI_24_64_in_vp9_dct) * x4 - (cast(Tran_High_T) COSPI_8_64_in_vp9_dct) * x5;
    s6 = -(cast,no_check(s32) COSPI_24_64_in_vp9_dct) * x6 + (cast(Tran_High_T) COSPI_8_64_in_vp9_dct) * x7;
    s7 = (cast(Tran_High_T) COSPI_8_64_in_vp9_dct) * x6 + (cast(Tran_High_T) COSPI_24_64_in_vp9_dct) * x7;

    x0 = s0 + s2;
    x1 = s1 + s3;
    x2 = s0 - s2;
    x3 = s1 - s3;
    x4 = fdct_round_shift_in_vp9_dct(s4 + s6);
    x5 = fdct_round_shift_in_vp9_dct(s5 + s7);
    x6 = fdct_round_shift_in_vp9_dct(s4 - s6);
    x7 = fdct_round_shift_in_vp9_dct(s5 - s7);

    s2 = (cast(Tran_High_T) COSPI_16_64_in_vp9_dct) * (x2 + x3);
    s3 = (cast(Tran_High_T) COSPI_16_64_in_vp9_dct) * (x2 - x3);
    s6 = (cast(Tran_High_T) COSPI_16_64_in_vp9_dct) * (x6 + x7);
    s7 = (cast(Tran_High_T) COSPI_16_64_in_vp9_dct) * (x6 - x7);

    x2 = fdct_round_shift_in_vp9_dct(s2);
    x3 = fdct_round_shift_in_vp9_dct(s3);
    x6 = fdct_round_shift_in_vp9_dct(s6);
    x7 = fdct_round_shift_in_vp9_dct(s7);

    output[0] = cast,no_check(Tran_Low_T) x0;
    output[1] = cast,no_check(Tran_Low_T) (-x4);
    output[2] = cast,no_check(Tran_Low_T) x6;
    output[3] = cast,no_check(Tran_Low_T) (-x2);
    output[4] = cast,no_check(Tran_Low_T) x3;
    output[5] = cast,no_check(Tran_Low_T) (-x7);
    output[6] = cast,no_check(Tran_Low_T) x5;
    output[7] = cast,no_check(Tran_Low_T) (-x1);
}

fdct8 :: (input: *Tran_Low_T, output: *Tran_Low_T) {
    s0 := (cast(s32) input[0]) + cast(s32) input[7];
    s1 := (cast(s32) input[1]) + cast(s32) input[6];
    s2 := (cast(s32) input[2]) + cast(s32) input[5];
    s3 := (cast(s32) input[3]) + cast(s32) input[4];
    s4 := (cast(s32) input[3]) - cast(s32) input[4];
    s5 := (cast(s32) input[2]) - cast(s32) input[5];
    s6 := (cast(s32) input[1]) - cast(s32) input[6];
    s7 := (cast(s32) input[0]) - cast(s32) input[7];

    x0 := s0 + s3;
    x1 := s1 + s2;
    x2 := s1 - s2;
    x3 := s0 - s3;
    t0 := (x0 + x1) * cast(Tran_High_T) COSPI_16_64_in_vp9_dct;
    t1 := (x0 - x1) * cast(Tran_High_T) COSPI_16_64_in_vp9_dct;
    t2 := (x2 * cast(Tran_High_T) COSPI_24_64_in_vp9_dct) + x3 * cast(Tran_High_T) COSPI_8_64_in_vp9_dct;
    t3 := (-x2 * cast(Tran_High_T) COSPI_8_64_in_vp9_dct) + x3 * cast(Tran_High_T) COSPI_24_64_in_vp9_dct;
    output[0] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(t0);
    output[2] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(t2);
    output[4] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(t1);
    output[6] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(t3);

    t0 = (s6 - s5) * cast(Tran_High_T) COSPI_16_64_in_vp9_dct;
    t1 = (s6 + s5) * cast(Tran_High_T) COSPI_16_64_in_vp9_dct;
    t2 = cast,no_check(Tran_High_T) (cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(t0));
    t3 = cast,no_check(Tran_High_T) (cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(t1));

    x0 = s4 + t2;
    x1 = s4 - t2;
    x2 = s7 - t3;
    x3 = s7 + t3;

    t0 = (x0 * cast(Tran_High_T) COSPI_28_64_in_vp9_dct) + x3 * cast(Tran_High_T) COSPI_4_64_in_vp9_dct;
    t1 = (x1 * cast(Tran_High_T) COSPI_12_64_in_vp9_dct) + x2 * cast(Tran_High_T) COSPI_20_64_in_vp9_dct;
    t2 = (x2 * cast(Tran_High_T) COSPI_12_64_in_vp9_dct) + x1 * -(cast,no_check(s32) COSPI_20_64_in_vp9_dct);
    t3 = (x3 * cast(Tran_High_T) COSPI_28_64_in_vp9_dct) + x0 * -(cast,no_check(s32) COSPI_4_64_in_vp9_dct);
    output[1] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(t0);
    output[3] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(t2);
    output[5] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(t1);
    output[7] = cast,no_check(Tran_Low_T) fdct_round_shift_in_vp9_dct(t3);
}

vp9_fwht4x4_c :: (input: *s16, output: *Tran_Low_T, stride: s32) {
    a1, b1, c1, d1, e1: Tran_High_T = ---;
    ip_pass0 := input;
    ip: *Tran_Low_T = null;
    op := output;

    for i: 0..cast(s32) 4 - 1 {
        a1 = cast,no_check(Tran_High_T) ip_pass0[0 * stride];
        b1 = cast,no_check(Tran_High_T) ip_pass0[1 * stride];
        c1 = cast,no_check(Tran_High_T) ip_pass0[2 * stride];
        d1 = cast,no_check(Tran_High_T) ip_pass0[3 * stride];

        a1 += b1;
        d1 = d1 - c1;
        e1 = (a1 - d1) >> 1;
        b1 = e1 - b1;
        c1 = e1 - c1;
        a1 -= c1;
        d1 += b1;
        op[0] = cast,no_check(Tran_Low_T) a1;
        op[4] = cast,no_check(Tran_Low_T) c1;
        op[8] = cast,no_check(Tran_Low_T) d1;
        op[12] = cast,no_check(Tran_Low_T) b1;

        ip_pass0 += 1;
        op += 1;
    }
    ip = output;
    op = output;

    for i: 0..cast(s32) 4 - 1 {
        a1 = cast,no_check(Tran_High_T) ip[0];
        b1 = cast,no_check(Tran_High_T) ip[1];
        c1 = cast,no_check(Tran_High_T) ip[2];
        d1 = cast,no_check(Tran_High_T) ip[3];

        a1 += b1;
        d1 -= c1;
        e1 = (a1 - d1) >> 1;
        b1 = e1 - b1;
        c1 = e1 - c1;
        a1 -= c1;
        d1 += b1;
        op[0] = cast,no_check(Tran_Low_T) (a1 * cast,no_check(Tran_High_T) (((cast(s32) 1) << 2)));
        op[1] = cast,no_check(Tran_Low_T) (c1 * cast,no_check(Tran_High_T) (((cast(s32) 1) << 2)));
        op[2] = cast,no_check(Tran_Low_T) (d1 * cast,no_check(Tran_High_T) (((cast(s32) 1) << 2)));
        op[3] = cast,no_check(Tran_Low_T) (b1 * cast,no_check(Tran_High_T) (((cast(s32) 1) << 2)));

        ip += 4;
        op += 4;
    }
}

get_prob_in_vp9_dct :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_dct :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_dct(n0, DEN);
}

weighted_prob_in_vp9_dct :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_dct :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_dct(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_dct(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_dct :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_dct[COUNT];
        PROB := get_prob_in_vp9_dct(ct[0], DEN);
        return weighted_prob_in_vp9_dct(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_band_translate_in_vp9_dct :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_dct :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_dct :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
    above_ec: ENTROPY_CONTEXT = 0;
    left_ec: ENTROPY_CONTEXT = 0;

    if cast,no_check(s32) tx_size == {
        case cast,no_check(s32) cast(TX_SIZE) 0;
            above_ec = cast(ENTROPY_CONTEXT) (a[0] != 0);
            left_ec = cast(ENTROPY_CONTEXT) (l[0] != 0);
        case cast,no_check(s32) cast(TX_SIZE) 1;
            above_ec = cast(ENTROPY_CONTEXT) (((cast(*u16) a).*) != 0);
            left_ec = cast(ENTROPY_CONTEXT) (((cast(*u16) l).*) != 0);
        case cast,no_check(s32) cast(TX_SIZE) 2;
            above_ec = cast(ENTROPY_CONTEXT) (((cast(*u32) a).*) != 0);
            left_ec = cast(ENTROPY_CONTEXT) (((cast(*u32) l).*) != 0);
        case cast,no_check(s32) cast(TX_SIZE) 3;
            above_ec = cast(ENTROPY_CONTEXT) (((cast(*u64) a).*) != 0);
            left_ec = cast(ENTROPY_CONTEXT) (((cast(*u64) l).*) != 0);
        case;
    }

    return combine_entropy_contexts_in_vp9_dct(above_ec, left_ec);
}

is_zero_mv_in_vp9_dct :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_dct :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_dct :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_dct(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_dct(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_dct :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_dct :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_dct :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_dct :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

vp9_is_valid_scale_in_vp9_dct :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_dct :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_dct(sf) != 0 && (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_dct :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_dct :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_dct :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_dct :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_dct :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_dct :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_dct :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_dct :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_dct :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_dct :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_dct :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_dct(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_dct :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_dct(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_dct(MI, ib)];
}

get_uv_tx_size_in_vp9_dct :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_dct :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_dct :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_dct(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_dct :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

check_range_in_vp9_dct :: (input: Tran_High_T) -> Tran_High_T {
    return input;
}

dct_const_round_shift_in_vp9_dct :: (input: Tran_High_T) -> Tran_High_T {
    rv := (input + cast,no_check(Tran_High_T) (((cast(s32) 1) << (((14 - 1)) & 31)))) >> 14;
    return rv;
}

clip_pixel_add_in_vp9_dct :: (dest: u8, trans: Tran_High_T) -> u8 {
    trans = check_range_in_vp9_dct(trans);
    return clip_pixel_in_vp9_dct((cast(s32) dest) + trans);
}

globals_initialization_state_for_vp9_dct: u32;
initialize_globals_for_vp9_dct :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_dct);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_dct, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_dct) != 2 {}
            return;
        }
    }
    SUB_PEL_FILTERS_12_in_vp9_dct =
        Interp_Kernel12.[
            s16.[ 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, 0, 0 ],
            s16.[ 0, 1, -2, 3, -7, 127, 8, -4, 2, -1, 1, 0 ],
            s16.[ -1, 2, -3, 6, -13, 124, 18, -8, 4, -2, 2, -1 ],
            s16.[ -1, 3, -4, 8, -18, 120, 28, -12, 7, -4, 2, -1 ],
            s16.[ -1, 3, -6, 10, -21, 115, 38, -15, 8, -5, 3, -1 ],
            s16.[ -2, 4, -6, 12, -24, 108, 49, -18, 10, -6, 3, -2 ],
            s16.[ -2, 4, -7, 13, -25, 100, 60, -21, 11, -7, 4, -2 ],
            s16.[ -2, 4, -7, 13, -26, 91, 71, -24, 13, -7, 4, -2 ],
            s16.[ -2, 4, -7, 13, -25, 81, 81, -25, 13, -7, 4, -2 ],
            s16.[ -2, 4, -7, 13, -24, 71, 91, -26, 13, -7, 4, -2 ],
            s16.[ -2, 4, -7, 11, -21, 60, 100, -25, 13, -7, 4, -2 ],
            s16.[ -2, 3, -6, 10, -18, 49, 108, -24, 12, -6, 4, -2 ],
            s16.[ -1, 3, -5, 8, -15, 38, 115, -21, 10, -6, 3, -1 ],
            s16.[ -1, 2, -4, 7, -12, 28, 120, -18, 8, -4, 3, -1 ],
            s16.[ -1, 2, -2, 4, -8, 18, 124, -13, 6, -3, 2, -1 ],
            s16.[ 0, 1, -1, 2, -4, 8, 127, -7, 3, -2, 1, 0 ]
        ];
    FHT_4 =
        Transform_2d.[
            Transform_2d.{cols = fdct4, rows = fdct4},
            Transform_2d.{cols = fadst4, rows = fdct4},
            Transform_2d.{cols = fdct4, rows = fadst4},
            Transform_2d.{cols = fadst4, rows = fadst4}
        ];
    FHT_8 =
        Transform_2d.[
            Transform_2d.{cols = fdct8, rows = fdct8},
            Transform_2d.{cols = fadst8, rows = fdct8},
            Transform_2d.{cols = fdct8, rows = fadst8},
            Transform_2d.{cols = fadst8, rows = fadst8}
        ];
    FHT_16 =
        Transform_2d.[
            Transform_2d.{cols = fdct16, rows = fdct16},
            Transform_2d.{cols = fadst16, rows = fdct16},
            Transform_2d.{cols = fdct16, rows = fadst16},
            Transform_2d.{cols = fadst16, rows = fadst16}
        ];
    COUNT_TO_UPDATE_FACTOR_in_vp9_dct =
        s32.[
            0,
            6,
            12,
            19,
            25,
            32,
            38,
            44,
            51,
            57,
            64,
            70,
            76,
            83,
            89,
            96,
            102,
            108,
            115,
            121,
            128
        ];
    COSPI_1_64_in_vp9_dct = 16364;
    COSPI_2_64_in_vp9_dct = 16305;
    COSPI_3_64_in_vp9_dct = 16207;
    COSPI_4_64_in_vp9_dct = 16069;
    COSPI_5_64_in_vp9_dct = 15893;
    COSPI_6_64_in_vp9_dct = 15679;
    COSPI_7_64_in_vp9_dct = 15426;
    COSPI_8_64_in_vp9_dct = 15137;
    COSPI_9_64_in_vp9_dct = 14811;
    COSPI_10_64_in_vp9_dct = 14449;
    COSPI_11_64_in_vp9_dct = 14053;
    COSPI_12_64_in_vp9_dct = 13623;
    COSPI_13_64_in_vp9_dct = 13160;
    COSPI_14_64_in_vp9_dct = 12665;
    COSPI_15_64_in_vp9_dct = 12140;
    COSPI_16_64_in_vp9_dct = 11585;
    COSPI_17_64_in_vp9_dct = 11003;
    COSPI_18_64_in_vp9_dct = 10394;
    COSPI_19_64_in_vp9_dct = 9760;
    COSPI_20_64_in_vp9_dct = 9102;
    COSPI_21_64_in_vp9_dct = 8423;
    COSPI_22_64_in_vp9_dct = 7723;
    COSPI_23_64_in_vp9_dct = 7005;
    COSPI_24_64_in_vp9_dct = 6270;
    COSPI_25_64_in_vp9_dct = 5520;
    COSPI_26_64_in_vp9_dct = 4756;
    COSPI_27_64_in_vp9_dct = 3981;
    COSPI_28_64_in_vp9_dct = 3196;
    COSPI_29_64_in_vp9_dct = 2404;
    COSPI_30_64_in_vp9_dct = 1606;
    COSPI_31_64_in_vp9_dct = 804;
    SINPI_1_9_in_vp9_dct = 5283;
    SINPI_2_9_in_vp9_dct = 9929;
    SINPI_3_9_in_vp9_dct = 13377;
    SINPI_4_9_in_vp9_dct = 15212;
    atomic_store(*globals_initialization_state_for_vp9_dct, 2);
}

