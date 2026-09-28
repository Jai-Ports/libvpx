// Generated directly from C by cpp_transpiler.
COSPI_16_64_storage: Tran_Coef_T;

COSPI_24_64_storage: Tran_Coef_T;

COSPI_8_64_storage: Tran_Coef_T;

COSPI_12_64_storage: Tran_Coef_T;

COSPI_20_64_storage: Tran_Coef_T;

COSPI_28_64_storage: Tran_Coef_T;

COSPI_4_64_storage: Tran_Coef_T;

COSPI_6_64_storage: Tran_Coef_T;

COSPI_26_64_storage: Tran_Coef_T;

COSPI_22_64_storage: Tran_Coef_T;

COSPI_10_64_storage: Tran_Coef_T;

COSPI_14_64_storage: Tran_Coef_T;

COSPI_18_64_storage: Tran_Coef_T;

COSPI_30_64_storage: Tran_Coef_T;

COSPI_2_64_storage: Tran_Coef_T;

COSPI_3_64_storage: Tran_Coef_T;

COSPI_29_64_storage: Tran_Coef_T;

COSPI_19_64_storage: Tran_Coef_T;

COSPI_13_64_storage: Tran_Coef_T;

COSPI_11_64_storage: Tran_Coef_T;

COSPI_21_64_storage: Tran_Coef_T;

COSPI_27_64_storage: Tran_Coef_T;

COSPI_5_64_storage: Tran_Coef_T;

COSPI_7_64_storage: Tran_Coef_T;

COSPI_25_64_storage: Tran_Coef_T;

COSPI_23_64_storage: Tran_Coef_T;

COSPI_9_64_storage: Tran_Coef_T;

COSPI_15_64_storage: Tran_Coef_T;

COSPI_17_64_storage: Tran_Coef_T;

COSPI_31_64_storage: Tran_Coef_T;

COSPI_1_64_storage: Tran_Coef_T;

SINPI_1_9_storage: Tran_Coef_T;

SINPI_2_9_storage: Tran_Coef_T;

SINPI_3_9_storage: Tran_Coef_T;

SINPI_4_9_storage: Tran_Coef_T;

clip_pixel_in_inv_txfm :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_inv_txfm :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_inv_txfm :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_inv_txfm :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_inv_txfm :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_inv_txfm(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_inv_txfm(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_inv_txfm(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_inv_txfm :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_inv_txfm :: (FILTER: *s16) -> s32 {
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

idct16x16_10_add_c :: (input: *Tran_Low_T, dest: *u8, stride: s32) {
    j: s32 = ---;
    out: [256] Tran_Low_T;
    outptr := out.data;
    temp_in, temp_out: [16] Tran_Low_T = ---;

    for i: 0..cast(s32) 4 - 1 {
        idct16_c(input, outptr);
        input += 16;
        outptr += 16;
    }

    for i: 0..cast(s32) 16 - 1 {
        j = 0;
        while j < 16 {
            temp_in[j] = out[j * 16 + i];
            j += 1;
        }
        idct16_c(temp_in.data, temp_out.data);
        j = 0;
        while j < 16 {
            dest[j * stride + i] =
                clip_pixel_add(
                    dest[j * stride + i],
                    ((cast(s32) temp_out[j]) + (cast(s32) 1) << (((6 - 1)) & 31)) >> 6
                );
            j += 1;
        }
    }
}

clip_pixel_add :: (dest: u8, trans: Tran_High_T) -> u8 {
    trans = check_range(trans);
    return clip_pixel_in_inv_txfm((cast(s32) dest) + trans);
}

check_range :: (input: Tran_High_T) -> Tran_High_T {
    return input;
}

idct16_c :: (input: *Tran_Low_T, output: *Tran_Low_T) {
    step1, step2: [16] s16 = ---;

    step1[0] = input[0 / 2];
    step1[1] = input[16 / 2];
    step1[2] = input[8 / 2];
    step1[3] = input[24 / 2];
    step1[4] = input[4 / 2];
    step1[5] = input[20 / 2];
    step1[6] = input[12 / 2];
    step1[7] = input[28 / 2];
    step1[8] = input[2 / 2];
    step1[9] = input[18 / 2];
    step1[10] = input[10 / 2];
    step1[11] = input[26 / 2];
    step1[12] = input[6 / 2];
    step1[13] = input[22 / 2];
    step1[14] = input[14 / 2];
    step1[15] = input[30 / 2];

    step2[0] = step1[0];
    step2[1] = step1[1];
    step2[2] = step1[2];
    step2[3] = step1[3];
    step2[4] = step1[4];
    step2[5] = step1[5];
    step2[6] = step1[6];
    step2[7] = step1[7];

    temp1 :=
        ((cast(s32) step1[8]) * cast(s32) COSPI_30_64_storage) -
            (cast(s32) step1[15]) * cast(s32) COSPI_2_64_storage;
    temp2 :=
        ((cast(s32) step1[8]) * cast(s32) COSPI_2_64_storage) +
            (cast(s32) step1[15]) * cast(s32) COSPI_30_64_storage;
    step2[8] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[15] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));

    temp1 =
        ((cast(s32) step1[9]) * cast(s32) COSPI_14_64_storage) -
            (cast(s32) step1[14]) * cast(s32) COSPI_18_64_storage;
    temp2 =
        ((cast(s32) step1[9]) * cast(s32) COSPI_18_64_storage) +
            (cast(s32) step1[14]) * cast(s32) COSPI_14_64_storage;
    step2[9] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[14] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));

    temp1 =
        ((cast(s32) step1[10]) * cast(s32) COSPI_22_64_storage) -
            (cast(s32) step1[13]) * cast(s32) COSPI_10_64_storage;
    temp2 =
        ((cast(s32) step1[10]) * cast(s32) COSPI_10_64_storage) +
            (cast(s32) step1[13]) * cast(s32) COSPI_22_64_storage;
    step2[10] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[13] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));

    temp1 =
        ((cast(s32) step1[11]) * cast(s32) COSPI_6_64_storage) -
            (cast(s32) step1[12]) * cast(s32) COSPI_26_64_storage;
    temp2 =
        ((cast(s32) step1[11]) * cast(s32) COSPI_26_64_storage) +
            (cast(s32) step1[12]) * cast(s32) COSPI_6_64_storage;
    step2[11] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[12] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));

    step1[0] = step2[0];
    step1[1] = step2[1];
    step1[2] = step2[2];
    step1[3] = step2[3];

    temp1 =
        ((cast(s32) step2[4]) * cast(s32) COSPI_28_64_storage) -
            (cast(s32) step2[7]) * cast(s32) COSPI_4_64_storage;
    temp2 =
        ((cast(s32) step2[4]) * cast(s32) COSPI_4_64_storage) +
            (cast(s32) step2[7]) * cast(s32) COSPI_28_64_storage;
    step1[4] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[7] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    temp1 =
        ((cast(s32) step2[5]) * cast(s32) COSPI_12_64_storage) -
            (cast(s32) step2[6]) * cast(s32) COSPI_20_64_storage;
    temp2 =
        ((cast(s32) step2[5]) * cast(s32) COSPI_20_64_storage) +
            (cast(s32) step2[6]) * cast(s32) COSPI_12_64_storage;
    step1[5] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[6] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));

    step1[8] = cast,no_check(s16) check_range((cast(s32) step2[8]) + cast(s32) step2[9]);
    step1[9] = cast,no_check(s16) check_range((cast(s32) step2[8]) - cast(s32) step2[9]);
    step1[10] = cast,no_check(s16) check_range(-(cast,no_check(s32) step2[10]) + cast(s32) step2[11]);
    step1[11] = cast,no_check(s16) check_range((cast(s32) step2[10]) + cast(s32) step2[11]);
    step1[12] = cast,no_check(s16) check_range((cast(s32) step2[12]) + cast(s32) step2[13]);
    step1[13] = cast,no_check(s16) check_range((cast(s32) step2[12]) - cast(s32) step2[13]);
    step1[14] = cast,no_check(s16) check_range(-(cast,no_check(s32) step2[14]) + cast(s32) step2[15]);
    step1[15] = cast,no_check(s16) check_range((cast(s32) step2[14]) + cast(s32) step2[15]);

    temp1 = ((cast(s32) step1[0]) + cast(s32) step1[1]) * cast(s32) COSPI_16_64_storage;
    temp2 = ((cast(s32) step1[0]) - cast(s32) step1[1]) * cast(s32) COSPI_16_64_storage;
    step2[0] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[1] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    temp1 =
        ((cast(s32) step1[2]) * cast(s32) COSPI_24_64_storage) -
            (cast(s32) step1[3]) * cast(s32) COSPI_8_64_storage;
    temp2 =
        ((cast(s32) step1[2]) * cast(s32) COSPI_8_64_storage) +
            (cast(s32) step1[3]) * cast(s32) COSPI_24_64_storage;
    step2[2] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[3] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    step2[4] = cast,no_check(s16) check_range((cast(s32) step1[4]) + cast(s32) step1[5]);
    step2[5] = cast,no_check(s16) check_range((cast(s32) step1[4]) - cast(s32) step1[5]);
    step2[6] = cast,no_check(s16) check_range(-(cast,no_check(s32) step1[6]) + cast(s32) step1[7]);
    step2[7] = cast,no_check(s16) check_range((cast(s32) step1[6]) + cast(s32) step1[7]);

    step2[8] = step1[8];
    step2[15] = step1[15];
    temp1 =
        (-(cast,no_check(s32) step1[9]) * cast(s32) COSPI_8_64_storage) +
            (cast(s32) step1[14]) * cast(s32) COSPI_24_64_storage;
    temp2 =
        ((cast(s32) step1[9]) * cast(s32) COSPI_24_64_storage) +
            (cast(s32) step1[14]) * cast(s32) COSPI_8_64_storage;
    step2[9] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[14] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    temp1 =
        (-(cast,no_check(s32) step1[10]) * cast(s32) COSPI_24_64_storage) -
            (cast(s32) step1[13]) * cast(s32) COSPI_8_64_storage;
    temp2 =
        (-(cast,no_check(s32) step1[10]) * cast(s32) COSPI_8_64_storage) +
            (cast(s32) step1[13]) * cast(s32) COSPI_24_64_storage;
    step2[10] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[13] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    step2[11] = step1[11];
    step2[12] = step1[12];

    step1[0] = cast,no_check(s16) check_range((cast(s32) step2[0]) + cast(s32) step2[3]);
    step1[1] = cast,no_check(s16) check_range((cast(s32) step2[1]) + cast(s32) step2[2]);
    step1[2] = cast,no_check(s16) check_range((cast(s32) step2[1]) - cast(s32) step2[2]);
    step1[3] = cast,no_check(s16) check_range((cast(s32) step2[0]) - cast(s32) step2[3]);
    step1[4] = step2[4];
    temp1 = ((cast(s32) step2[6]) - cast(s32) step2[5]) * cast(s32) COSPI_16_64_storage;
    temp2 = ((cast(s32) step2[5]) + cast(s32) step2[6]) * cast(s32) COSPI_16_64_storage;
    step1[5] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[6] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    step1[7] = step2[7];

    step1[8] = cast,no_check(s16) check_range((cast(s32) step2[8]) + cast(s32) step2[11]);
    step1[9] = cast,no_check(s16) check_range((cast(s32) step2[9]) + cast(s32) step2[10]);
    step1[10] = cast,no_check(s16) check_range((cast(s32) step2[9]) - cast(s32) step2[10]);
    step1[11] = cast,no_check(s16) check_range((cast(s32) step2[8]) - cast(s32) step2[11]);
    step1[12] = cast,no_check(s16) check_range(-(cast,no_check(s32) step2[12]) + cast(s32) step2[15]);
    step1[13] = cast,no_check(s16) check_range(-(cast,no_check(s32) step2[13]) + cast(s32) step2[14]);
    step1[14] = cast,no_check(s16) check_range((cast(s32) step2[13]) + cast(s32) step2[14]);
    step1[15] = cast,no_check(s16) check_range((cast(s32) step2[12]) + cast(s32) step2[15]);

    step2[0] = cast,no_check(s16) check_range((cast(s32) step1[0]) + cast(s32) step1[7]);
    step2[1] = cast,no_check(s16) check_range((cast(s32) step1[1]) + cast(s32) step1[6]);
    step2[2] = cast,no_check(s16) check_range((cast(s32) step1[2]) + cast(s32) step1[5]);
    step2[3] = cast,no_check(s16) check_range((cast(s32) step1[3]) + cast(s32) step1[4]);
    step2[4] = cast,no_check(s16) check_range((cast(s32) step1[3]) - cast(s32) step1[4]);
    step2[5] = cast,no_check(s16) check_range((cast(s32) step1[2]) - cast(s32) step1[5]);
    step2[6] = cast,no_check(s16) check_range((cast(s32) step1[1]) - cast(s32) step1[6]);
    step2[7] = cast,no_check(s16) check_range((cast(s32) step1[0]) - cast(s32) step1[7]);
    step2[8] = step1[8];
    step2[9] = step1[9];
    temp1 = (-(cast,no_check(s32) step1[10]) + cast(s32) step1[13]) * cast(s32) COSPI_16_64_storage;
    temp2 = ((cast(s32) step1[10]) + cast(s32) step1[13]) * cast(s32) COSPI_16_64_storage;
    step2[10] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[13] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    temp1 = (-(cast,no_check(s32) step1[11]) + cast(s32) step1[12]) * cast(s32) COSPI_16_64_storage;
    temp2 = ((cast(s32) step1[11]) + cast(s32) step1[12]) * cast(s32) COSPI_16_64_storage;
    step2[11] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[12] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    step2[14] = step1[14];
    step2[15] = step1[15];

    output[0] = cast,no_check(Tran_Low_T) check_range((cast(s32) step2[0]) + cast(s32) step2[15]);
    output[1] = cast,no_check(Tran_Low_T) check_range((cast(s32) step2[1]) + cast(s32) step2[14]);
    output[2] = cast,no_check(Tran_Low_T) check_range((cast(s32) step2[2]) + cast(s32) step2[13]);
    output[3] = cast,no_check(Tran_Low_T) check_range((cast(s32) step2[3]) + cast(s32) step2[12]);
    output[4] = cast,no_check(Tran_Low_T) check_range((cast(s32) step2[4]) + cast(s32) step2[11]);
    output[5] = cast,no_check(Tran_Low_T) check_range((cast(s32) step2[5]) + cast(s32) step2[10]);
    output[6] = cast,no_check(Tran_Low_T) check_range((cast(s32) step2[6]) + cast(s32) step2[9]);
    output[7] = cast,no_check(Tran_Low_T) check_range((cast(s32) step2[7]) + cast(s32) step2[8]);
    output[8] = cast,no_check(Tran_Low_T) check_range((cast(s32) step2[7]) - cast(s32) step2[8]);
    output[9] = cast,no_check(Tran_Low_T) check_range((cast(s32) step2[6]) - cast(s32) step2[9]);
    output[10] = cast,no_check(Tran_Low_T) check_range((cast(s32) step2[5]) - cast(s32) step2[10]);
    output[11] = cast,no_check(Tran_Low_T) check_range((cast(s32) step2[4]) - cast(s32) step2[11]);
    output[12] = cast,no_check(Tran_Low_T) check_range((cast(s32) step2[3]) - cast(s32) step2[12]);
    output[13] = cast,no_check(Tran_Low_T) check_range((cast(s32) step2[2]) - cast(s32) step2[13]);
    output[14] = cast,no_check(Tran_Low_T) check_range((cast(s32) step2[1]) - cast(s32) step2[14]);
    output[15] = cast,no_check(Tran_Low_T) check_range((cast(s32) step2[0]) - cast(s32) step2[15]);
}

dct_const_round_shift :: (input: Tran_High_T) -> Tran_High_T {
    rv := (input + cast,no_check(Tran_High_T) (((cast(s32) 1) << (((14 - 1)) & 31)))) >> 14;
    return rv;
}

idct16x16_1_add_c :: (input: *Tran_Low_T, dest: *u8, stride: s32) {
    i: s32 = ---;

    out :=
        cast,no_check(Tran_Low_T) check_range(
            dct_const_round_shift(
            (cast(s32) input[0]) * cast(s32) COSPI_16_64_storage
        )
        );

    out =
        cast,no_check(Tran_Low_T) check_range(
            dct_const_round_shift((cast(s32) out) * cast(s32) COSPI_16_64_storage)
        );
    a1 := ((cast(s32) out) + (cast(s32) 1) << (((6 - 1)) & 31)) >> 6;
    for j: 0..cast(s32) 16 - 1 {
        i = 0;
        while i < 16 {
            dest[i] = clip_pixel_add(dest[i], a1);
            i += 1;
        }
        dest += stride;
    }
}

idct16x16_256_add_c :: (input: *Tran_Low_T, dest: *u8, stride: s32) {
    j: s32 = ---;
    out: [256] Tran_Low_T = ---;
    outptr := out.data;
    temp_in, temp_out: [16] Tran_Low_T = ---;

    for i: 0..cast(s32) 16 - 1 {
        idct16_c(input, outptr);
        input += 16;
        outptr += 16;
    }

    for i: 0..cast(s32) 16 - 1 {
        j = 0;
        while j < 16 {
            temp_in[j] = out[j * 16 + i];
            j += 1;
        }
        idct16_c(temp_in.data, temp_out.data);
        j = 0;
        while j < 16 {
            dest[j * stride + i] =
                clip_pixel_add(
                    dest[j * stride + i],
                    ((cast(s32) temp_out[j]) + (cast(s32) 1) << (((6 - 1)) & 31)) >> 6
                );
            j += 1;
        }
    }
}

idct16x16_38_add_c :: (input: *Tran_Low_T, dest: *u8, stride: s32) {
    j: s32 = ---;
    out: [256] Tran_Low_T;
    outptr := out.data;
    temp_in, temp_out: [16] Tran_Low_T = ---;

    for i: 0..cast(s32) 8 - 1 {
        idct16_c(input, outptr);
        input += 16;
        outptr += 16;
    }

    for i: 0..cast(s32) 16 - 1 {
        j = 0;
        while j < 16 {
            temp_in[j] = out[j * 16 + i];
            j += 1;
        }
        idct16_c(temp_in.data, temp_out.data);
        j = 0;
        while j < 16 {
            dest[j * stride + i] =
                clip_pixel_add(
                    dest[j * stride + i],
                    ((cast(s32) temp_out[j]) + (cast(s32) 1) << (((6 - 1)) & 31)) >> 6
                );
            j += 1;
        }
    }
}

idct32x32_1024_add_c :: (input: *Tran_Low_T, dest: *u8, stride: s32) {
    j: s32 = ---;
    out: [1024] Tran_Low_T = ---;
    outptr := out.data;
    temp_in, temp_out: [32] Tran_Low_T = ---;

    for i: 0..cast(s32) 32 - 1 {
        zero_coeff: s16 = 0;
        j = 0;
        while j < 32 {
            zero_coeff = cast,no_check(s16) ((cast,no_check(s32) zero_coeff) | cast,no_check(s32) input[j]);
            j += 1;
        }

        if zero_coeff != 0 {
            idct32_c(input, outptr);
        } else {
            fill_memory(outptr, 0, size_of(Tran_Low_T) * cast(u64) 32);
        }
        input += 32;
        outptr += 32;
    }

    for i: 0..cast(s32) 32 - 1 {
        j = 0;
        while j < 32 {
            temp_in[j] = out[j * 32 + i];
            j += 1;
        }
        idct32_c(temp_in.data, temp_out.data);
        j = 0;
        while j < 32 {
            dest[j * stride + i] =
                clip_pixel_add(
                    dest[j * stride + i],
                    ((cast(s32) temp_out[j]) + (cast(s32) 1) << (((6 - 1)) & 31)) >> 6
                );
            j += 1;
        }
    }
}

idct32_c :: (input: *Tran_Low_T, output: *Tran_Low_T) {
    step1, step2: [32] s16 = ---;

    step1[0] = input[0];
    step1[1] = input[16];
    step1[2] = input[8];
    step1[3] = input[24];
    step1[4] = input[4];
    step1[5] = input[20];
    step1[6] = input[12];
    step1[7] = input[28];
    step1[8] = input[2];
    step1[9] = input[18];
    step1[10] = input[10];
    step1[11] = input[26];
    step1[12] = input[6];
    step1[13] = input[22];
    step1[14] = input[14];
    step1[15] = input[30];

    temp1 :=
        ((cast(s32) input[1]) * cast(s32) COSPI_31_64_storage) -
            (cast(s32) input[31]) * cast(s32) COSPI_1_64_storage;
    temp2 :=
        ((cast(s32) input[1]) * cast(s32) COSPI_1_64_storage) +
            (cast(s32) input[31]) * cast(s32) COSPI_31_64_storage;
    step1[16] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[31] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));

    temp1 =
        ((cast(s32) input[17]) * cast(s32) COSPI_15_64_storage) -
            (cast(s32) input[15]) * cast(s32) COSPI_17_64_storage;
    temp2 =
        ((cast(s32) input[17]) * cast(s32) COSPI_17_64_storage) +
            (cast(s32) input[15]) * cast(s32) COSPI_15_64_storage;
    step1[17] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[30] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));

    temp1 =
        ((cast(s32) input[9]) * cast(s32) COSPI_23_64_storage) -
            (cast(s32) input[23]) * cast(s32) COSPI_9_64_storage;
    temp2 =
        ((cast(s32) input[9]) * cast(s32) COSPI_9_64_storage) +
            (cast(s32) input[23]) * cast(s32) COSPI_23_64_storage;
    step1[18] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[29] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));

    temp1 =
        ((cast(s32) input[25]) * cast(s32) COSPI_7_64_storage) -
            (cast(s32) input[7]) * cast(s32) COSPI_25_64_storage;
    temp2 =
        ((cast(s32) input[25]) * cast(s32) COSPI_25_64_storage) +
            (cast(s32) input[7]) * cast(s32) COSPI_7_64_storage;
    step1[19] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[28] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));

    temp1 =
        ((cast(s32) input[5]) * cast(s32) COSPI_27_64_storage) -
            (cast(s32) input[27]) * cast(s32) COSPI_5_64_storage;
    temp2 =
        ((cast(s32) input[5]) * cast(s32) COSPI_5_64_storage) +
            (cast(s32) input[27]) * cast(s32) COSPI_27_64_storage;
    step1[20] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[27] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));

    temp1 =
        ((cast(s32) input[21]) * cast(s32) COSPI_11_64_storage) -
            (cast(s32) input[11]) * cast(s32) COSPI_21_64_storage;
    temp2 =
        ((cast(s32) input[21]) * cast(s32) COSPI_21_64_storage) +
            (cast(s32) input[11]) * cast(s32) COSPI_11_64_storage;
    step1[21] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[26] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));

    temp1 =
        ((cast(s32) input[13]) * cast(s32) COSPI_19_64_storage) -
            (cast(s32) input[19]) * cast(s32) COSPI_13_64_storage;
    temp2 =
        ((cast(s32) input[13]) * cast(s32) COSPI_13_64_storage) +
            (cast(s32) input[19]) * cast(s32) COSPI_19_64_storage;
    step1[22] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[25] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));

    temp1 =
        ((cast(s32) input[29]) * cast(s32) COSPI_3_64_storage) -
            (cast(s32) input[3]) * cast(s32) COSPI_29_64_storage;
    temp2 =
        ((cast(s32) input[29]) * cast(s32) COSPI_29_64_storage) +
            (cast(s32) input[3]) * cast(s32) COSPI_3_64_storage;
    step1[23] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[24] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));

    step2[0] = step1[0];
    step2[1] = step1[1];
    step2[2] = step1[2];
    step2[3] = step1[3];
    step2[4] = step1[4];
    step2[5] = step1[5];
    step2[6] = step1[6];
    step2[7] = step1[7];

    temp1 =
        ((cast(s32) step1[8]) * cast(s32) COSPI_30_64_storage) -
            (cast(s32) step1[15]) * cast(s32) COSPI_2_64_storage;
    temp2 =
        ((cast(s32) step1[8]) * cast(s32) COSPI_2_64_storage) +
            (cast(s32) step1[15]) * cast(s32) COSPI_30_64_storage;
    step2[8] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[15] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));

    temp1 =
        ((cast(s32) step1[9]) * cast(s32) COSPI_14_64_storage) -
            (cast(s32) step1[14]) * cast(s32) COSPI_18_64_storage;
    temp2 =
        ((cast(s32) step1[9]) * cast(s32) COSPI_18_64_storage) +
            (cast(s32) step1[14]) * cast(s32) COSPI_14_64_storage;
    step2[9] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[14] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));

    temp1 =
        ((cast(s32) step1[10]) * cast(s32) COSPI_22_64_storage) -
            (cast(s32) step1[13]) * cast(s32) COSPI_10_64_storage;
    temp2 =
        ((cast(s32) step1[10]) * cast(s32) COSPI_10_64_storage) +
            (cast(s32) step1[13]) * cast(s32) COSPI_22_64_storage;
    step2[10] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[13] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));

    temp1 =
        ((cast(s32) step1[11]) * cast(s32) COSPI_6_64_storage) -
            (cast(s32) step1[12]) * cast(s32) COSPI_26_64_storage;
    temp2 =
        ((cast(s32) step1[11]) * cast(s32) COSPI_26_64_storage) +
            (cast(s32) step1[12]) * cast(s32) COSPI_6_64_storage;
    step2[11] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[12] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));

    step2[16] = cast,no_check(s16) check_range((cast(s32) step1[16]) + cast(s32) step1[17]);
    step2[17] = cast,no_check(s16) check_range((cast(s32) step1[16]) - cast(s32) step1[17]);
    step2[18] = cast,no_check(s16) check_range(-(cast,no_check(s32) step1[18]) + cast(s32) step1[19]);
    step2[19] = cast,no_check(s16) check_range((cast(s32) step1[18]) + cast(s32) step1[19]);
    step2[20] = cast,no_check(s16) check_range((cast(s32) step1[20]) + cast(s32) step1[21]);
    step2[21] = cast,no_check(s16) check_range((cast(s32) step1[20]) - cast(s32) step1[21]);
    step2[22] = cast,no_check(s16) check_range(-(cast,no_check(s32) step1[22]) + cast(s32) step1[23]);
    step2[23] = cast,no_check(s16) check_range((cast(s32) step1[22]) + cast(s32) step1[23]);
    step2[24] = cast,no_check(s16) check_range((cast(s32) step1[24]) + cast(s32) step1[25]);
    step2[25] = cast,no_check(s16) check_range((cast(s32) step1[24]) - cast(s32) step1[25]);
    step2[26] = cast,no_check(s16) check_range(-(cast,no_check(s32) step1[26]) + cast(s32) step1[27]);
    step2[27] = cast,no_check(s16) check_range((cast(s32) step1[26]) + cast(s32) step1[27]);
    step2[28] = cast,no_check(s16) check_range((cast(s32) step1[28]) + cast(s32) step1[29]);
    step2[29] = cast,no_check(s16) check_range((cast(s32) step1[28]) - cast(s32) step1[29]);
    step2[30] = cast,no_check(s16) check_range(-(cast,no_check(s32) step1[30]) + cast(s32) step1[31]);
    step2[31] = cast,no_check(s16) check_range((cast(s32) step1[30]) + cast(s32) step1[31]);

    step1[0] = step2[0];
    step1[1] = step2[1];
    step1[2] = step2[2];
    step1[3] = step2[3];

    temp1 =
        ((cast(s32) step2[4]) * cast(s32) COSPI_28_64_storage) -
            (cast(s32) step2[7]) * cast(s32) COSPI_4_64_storage;
    temp2 =
        ((cast(s32) step2[4]) * cast(s32) COSPI_4_64_storage) +
            (cast(s32) step2[7]) * cast(s32) COSPI_28_64_storage;
    step1[4] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[7] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    temp1 =
        ((cast(s32) step2[5]) * cast(s32) COSPI_12_64_storage) -
            (cast(s32) step2[6]) * cast(s32) COSPI_20_64_storage;
    temp2 =
        ((cast(s32) step2[5]) * cast(s32) COSPI_20_64_storage) +
            (cast(s32) step2[6]) * cast(s32) COSPI_12_64_storage;
    step1[5] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[6] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));

    step1[8] = cast,no_check(s16) check_range((cast(s32) step2[8]) + cast(s32) step2[9]);
    step1[9] = cast,no_check(s16) check_range((cast(s32) step2[8]) - cast(s32) step2[9]);
    step1[10] = cast,no_check(s16) check_range(-(cast,no_check(s32) step2[10]) + cast(s32) step2[11]);
    step1[11] = cast,no_check(s16) check_range((cast(s32) step2[10]) + cast(s32) step2[11]);
    step1[12] = cast,no_check(s16) check_range((cast(s32) step2[12]) + cast(s32) step2[13]);
    step1[13] = cast,no_check(s16) check_range((cast(s32) step2[12]) - cast(s32) step2[13]);
    step1[14] = cast,no_check(s16) check_range(-(cast,no_check(s32) step2[14]) + cast(s32) step2[15]);
    step1[15] = cast,no_check(s16) check_range((cast(s32) step2[14]) + cast(s32) step2[15]);

    step1[16] = step2[16];
    step1[31] = step2[31];
    temp1 =
        (-(cast,no_check(s32) step2[17]) * cast(s32) COSPI_4_64_storage) +
            (cast(s32) step2[30]) * cast(s32) COSPI_28_64_storage;
    temp2 =
        ((cast(s32) step2[17]) * cast(s32) COSPI_28_64_storage) +
            (cast(s32) step2[30]) * cast(s32) COSPI_4_64_storage;
    step1[17] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[30] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    temp1 =
        (-(cast,no_check(s32) step2[18]) * cast(s32) COSPI_28_64_storage) -
            (cast(s32) step2[29]) * cast(s32) COSPI_4_64_storage;
    temp2 =
        (-(cast,no_check(s32) step2[18]) * cast(s32) COSPI_4_64_storage) +
            (cast(s32) step2[29]) * cast(s32) COSPI_28_64_storage;
    step1[18] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[29] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    step1[19] = step2[19];
    step1[20] = step2[20];
    temp1 =
        (-(cast,no_check(s32) step2[21]) * cast(s32) COSPI_20_64_storage) +
            (cast(s32) step2[26]) * cast(s32) COSPI_12_64_storage;
    temp2 =
        ((cast(s32) step2[21]) * cast(s32) COSPI_12_64_storage) +
            (cast(s32) step2[26]) * cast(s32) COSPI_20_64_storage;
    step1[21] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[26] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    temp1 =
        (-(cast,no_check(s32) step2[22]) * cast(s32) COSPI_12_64_storage) -
            (cast(s32) step2[25]) * cast(s32) COSPI_20_64_storage;
    temp2 =
        (-(cast,no_check(s32) step2[22]) * cast(s32) COSPI_20_64_storage) +
            (cast(s32) step2[25]) * cast(s32) COSPI_12_64_storage;
    step1[22] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[25] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    step1[23] = step2[23];
    step1[24] = step2[24];
    step1[27] = step2[27];
    step1[28] = step2[28];

    temp1 = ((cast(s32) step1[0]) + cast(s32) step1[1]) * cast(s32) COSPI_16_64_storage;
    temp2 = ((cast(s32) step1[0]) - cast(s32) step1[1]) * cast(s32) COSPI_16_64_storage;
    step2[0] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[1] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    temp1 =
        ((cast(s32) step1[2]) * cast(s32) COSPI_24_64_storage) -
            (cast(s32) step1[3]) * cast(s32) COSPI_8_64_storage;
    temp2 =
        ((cast(s32) step1[2]) * cast(s32) COSPI_8_64_storage) +
            (cast(s32) step1[3]) * cast(s32) COSPI_24_64_storage;
    step2[2] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[3] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    step2[4] = cast,no_check(s16) check_range((cast(s32) step1[4]) + cast(s32) step1[5]);
    step2[5] = cast,no_check(s16) check_range((cast(s32) step1[4]) - cast(s32) step1[5]);
    step2[6] = cast,no_check(s16) check_range(-(cast,no_check(s32) step1[6]) + cast(s32) step1[7]);
    step2[7] = cast,no_check(s16) check_range((cast(s32) step1[6]) + cast(s32) step1[7]);

    step2[8] = step1[8];
    step2[15] = step1[15];
    temp1 =
        (-(cast,no_check(s32) step1[9]) * cast(s32) COSPI_8_64_storage) +
            (cast(s32) step1[14]) * cast(s32) COSPI_24_64_storage;
    temp2 =
        ((cast(s32) step1[9]) * cast(s32) COSPI_24_64_storage) +
            (cast(s32) step1[14]) * cast(s32) COSPI_8_64_storage;
    step2[9] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[14] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    temp1 =
        (-(cast,no_check(s32) step1[10]) * cast(s32) COSPI_24_64_storage) -
            (cast(s32) step1[13]) * cast(s32) COSPI_8_64_storage;
    temp2 =
        (-(cast,no_check(s32) step1[10]) * cast(s32) COSPI_8_64_storage) +
            (cast(s32) step1[13]) * cast(s32) COSPI_24_64_storage;
    step2[10] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[13] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    step2[11] = step1[11];
    step2[12] = step1[12];

    step2[16] = cast,no_check(s16) check_range((cast(s32) step1[16]) + cast(s32) step1[19]);
    step2[17] = cast,no_check(s16) check_range((cast(s32) step1[17]) + cast(s32) step1[18]);
    step2[18] = cast,no_check(s16) check_range((cast(s32) step1[17]) - cast(s32) step1[18]);
    step2[19] = cast,no_check(s16) check_range((cast(s32) step1[16]) - cast(s32) step1[19]);
    step2[20] = cast,no_check(s16) check_range(-(cast,no_check(s32) step1[20]) + cast(s32) step1[23]);
    step2[21] = cast,no_check(s16) check_range(-(cast,no_check(s32) step1[21]) + cast(s32) step1[22]);
    step2[22] = cast,no_check(s16) check_range((cast(s32) step1[21]) + cast(s32) step1[22]);
    step2[23] = cast,no_check(s16) check_range((cast(s32) step1[20]) + cast(s32) step1[23]);

    step2[24] = cast,no_check(s16) check_range((cast(s32) step1[24]) + cast(s32) step1[27]);
    step2[25] = cast,no_check(s16) check_range((cast(s32) step1[25]) + cast(s32) step1[26]);
    step2[26] = cast,no_check(s16) check_range((cast(s32) step1[25]) - cast(s32) step1[26]);
    step2[27] = cast,no_check(s16) check_range((cast(s32) step1[24]) - cast(s32) step1[27]);
    step2[28] = cast,no_check(s16) check_range(-(cast,no_check(s32) step1[28]) + cast(s32) step1[31]);
    step2[29] = cast,no_check(s16) check_range(-(cast,no_check(s32) step1[29]) + cast(s32) step1[30]);
    step2[30] = cast,no_check(s16) check_range((cast(s32) step1[29]) + cast(s32) step1[30]);
    step2[31] = cast,no_check(s16) check_range((cast(s32) step1[28]) + cast(s32) step1[31]);

    step1[0] = cast,no_check(s16) check_range((cast(s32) step2[0]) + cast(s32) step2[3]);
    step1[1] = cast,no_check(s16) check_range((cast(s32) step2[1]) + cast(s32) step2[2]);
    step1[2] = cast,no_check(s16) check_range((cast(s32) step2[1]) - cast(s32) step2[2]);
    step1[3] = cast,no_check(s16) check_range((cast(s32) step2[0]) - cast(s32) step2[3]);
    step1[4] = step2[4];
    temp1 = ((cast(s32) step2[6]) - cast(s32) step2[5]) * cast(s32) COSPI_16_64_storage;
    temp2 = ((cast(s32) step2[5]) + cast(s32) step2[6]) * cast(s32) COSPI_16_64_storage;
    step1[5] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[6] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    step1[7] = step2[7];

    step1[8] = cast,no_check(s16) check_range((cast(s32) step2[8]) + cast(s32) step2[11]);
    step1[9] = cast,no_check(s16) check_range((cast(s32) step2[9]) + cast(s32) step2[10]);
    step1[10] = cast,no_check(s16) check_range((cast(s32) step2[9]) - cast(s32) step2[10]);
    step1[11] = cast,no_check(s16) check_range((cast(s32) step2[8]) - cast(s32) step2[11]);
    step1[12] = cast,no_check(s16) check_range(-(cast,no_check(s32) step2[12]) + cast(s32) step2[15]);
    step1[13] = cast,no_check(s16) check_range(-(cast,no_check(s32) step2[13]) + cast(s32) step2[14]);
    step1[14] = cast,no_check(s16) check_range((cast(s32) step2[13]) + cast(s32) step2[14]);
    step1[15] = cast,no_check(s16) check_range((cast(s32) step2[12]) + cast(s32) step2[15]);

    step1[16] = step2[16];
    step1[17] = step2[17];
    temp1 =
        (-(cast,no_check(s32) step2[18]) * cast(s32) COSPI_8_64_storage) +
            (cast(s32) step2[29]) * cast(s32) COSPI_24_64_storage;
    temp2 =
        ((cast(s32) step2[18]) * cast(s32) COSPI_24_64_storage) +
            (cast(s32) step2[29]) * cast(s32) COSPI_8_64_storage;
    step1[18] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[29] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    temp1 =
        (-(cast,no_check(s32) step2[19]) * cast(s32) COSPI_8_64_storage) +
            (cast(s32) step2[28]) * cast(s32) COSPI_24_64_storage;
    temp2 =
        ((cast(s32) step2[19]) * cast(s32) COSPI_24_64_storage) +
            (cast(s32) step2[28]) * cast(s32) COSPI_8_64_storage;
    step1[19] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[28] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    temp1 =
        (-(cast,no_check(s32) step2[20]) * cast(s32) COSPI_24_64_storage) -
            (cast(s32) step2[27]) * cast(s32) COSPI_8_64_storage;
    temp2 =
        (-(cast,no_check(s32) step2[20]) * cast(s32) COSPI_8_64_storage) +
            (cast(s32) step2[27]) * cast(s32) COSPI_24_64_storage;
    step1[20] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[27] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    temp1 =
        (-(cast,no_check(s32) step2[21]) * cast(s32) COSPI_24_64_storage) -
            (cast(s32) step2[26]) * cast(s32) COSPI_8_64_storage;
    temp2 =
        (-(cast,no_check(s32) step2[21]) * cast(s32) COSPI_8_64_storage) +
            (cast(s32) step2[26]) * cast(s32) COSPI_24_64_storage;
    step1[21] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[26] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    step1[22] = step2[22];
    step1[23] = step2[23];
    step1[24] = step2[24];
    step1[25] = step2[25];
    step1[30] = step2[30];
    step1[31] = step2[31];

    step2[0] = cast,no_check(s16) check_range((cast(s32) step1[0]) + cast(s32) step1[7]);
    step2[1] = cast,no_check(s16) check_range((cast(s32) step1[1]) + cast(s32) step1[6]);
    step2[2] = cast,no_check(s16) check_range((cast(s32) step1[2]) + cast(s32) step1[5]);
    step2[3] = cast,no_check(s16) check_range((cast(s32) step1[3]) + cast(s32) step1[4]);
    step2[4] = cast,no_check(s16) check_range((cast(s32) step1[3]) - cast(s32) step1[4]);
    step2[5] = cast,no_check(s16) check_range((cast(s32) step1[2]) - cast(s32) step1[5]);
    step2[6] = cast,no_check(s16) check_range((cast(s32) step1[1]) - cast(s32) step1[6]);
    step2[7] = cast,no_check(s16) check_range((cast(s32) step1[0]) - cast(s32) step1[7]);
    step2[8] = step1[8];
    step2[9] = step1[9];
    temp1 = (-(cast,no_check(s32) step1[10]) + cast(s32) step1[13]) * cast(s32) COSPI_16_64_storage;
    temp2 = ((cast(s32) step1[10]) + cast(s32) step1[13]) * cast(s32) COSPI_16_64_storage;
    step2[10] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[13] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    temp1 = (-(cast,no_check(s32) step1[11]) + cast(s32) step1[12]) * cast(s32) COSPI_16_64_storage;
    temp2 = ((cast(s32) step1[11]) + cast(s32) step1[12]) * cast(s32) COSPI_16_64_storage;
    step2[11] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[12] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    step2[14] = step1[14];
    step2[15] = step1[15];

    step2[16] = cast,no_check(s16) check_range((cast(s32) step1[16]) + cast(s32) step1[23]);
    step2[17] = cast,no_check(s16) check_range((cast(s32) step1[17]) + cast(s32) step1[22]);
    step2[18] = cast,no_check(s16) check_range((cast(s32) step1[18]) + cast(s32) step1[21]);
    step2[19] = cast,no_check(s16) check_range((cast(s32) step1[19]) + cast(s32) step1[20]);
    step2[20] = cast,no_check(s16) check_range((cast(s32) step1[19]) - cast(s32) step1[20]);
    step2[21] = cast,no_check(s16) check_range((cast(s32) step1[18]) - cast(s32) step1[21]);
    step2[22] = cast,no_check(s16) check_range((cast(s32) step1[17]) - cast(s32) step1[22]);
    step2[23] = cast,no_check(s16) check_range((cast(s32) step1[16]) - cast(s32) step1[23]);

    step2[24] = cast,no_check(s16) check_range(-(cast,no_check(s32) step1[24]) + cast(s32) step1[31]);
    step2[25] = cast,no_check(s16) check_range(-(cast,no_check(s32) step1[25]) + cast(s32) step1[30]);
    step2[26] = cast,no_check(s16) check_range(-(cast,no_check(s32) step1[26]) + cast(s32) step1[29]);
    step2[27] = cast,no_check(s16) check_range(-(cast,no_check(s32) step1[27]) + cast(s32) step1[28]);
    step2[28] = cast,no_check(s16) check_range((cast(s32) step1[27]) + cast(s32) step1[28]);
    step2[29] = cast,no_check(s16) check_range((cast(s32) step1[26]) + cast(s32) step1[29]);
    step2[30] = cast,no_check(s16) check_range((cast(s32) step1[25]) + cast(s32) step1[30]);
    step2[31] = cast,no_check(s16) check_range((cast(s32) step1[24]) + cast(s32) step1[31]);

    step1[0] = cast,no_check(s16) check_range((cast(s32) step2[0]) + cast(s32) step2[15]);
    step1[1] = cast,no_check(s16) check_range((cast(s32) step2[1]) + cast(s32) step2[14]);
    step1[2] = cast,no_check(s16) check_range((cast(s32) step2[2]) + cast(s32) step2[13]);
    step1[3] = cast,no_check(s16) check_range((cast(s32) step2[3]) + cast(s32) step2[12]);
    step1[4] = cast,no_check(s16) check_range((cast(s32) step2[4]) + cast(s32) step2[11]);
    step1[5] = cast,no_check(s16) check_range((cast(s32) step2[5]) + cast(s32) step2[10]);
    step1[6] = cast,no_check(s16) check_range((cast(s32) step2[6]) + cast(s32) step2[9]);
    step1[7] = cast,no_check(s16) check_range((cast(s32) step2[7]) + cast(s32) step2[8]);
    step1[8] = cast,no_check(s16) check_range((cast(s32) step2[7]) - cast(s32) step2[8]);
    step1[9] = cast,no_check(s16) check_range((cast(s32) step2[6]) - cast(s32) step2[9]);
    step1[10] = cast,no_check(s16) check_range((cast(s32) step2[5]) - cast(s32) step2[10]);
    step1[11] = cast,no_check(s16) check_range((cast(s32) step2[4]) - cast(s32) step2[11]);
    step1[12] = cast,no_check(s16) check_range((cast(s32) step2[3]) - cast(s32) step2[12]);
    step1[13] = cast,no_check(s16) check_range((cast(s32) step2[2]) - cast(s32) step2[13]);
    step1[14] = cast,no_check(s16) check_range((cast(s32) step2[1]) - cast(s32) step2[14]);
    step1[15] = cast,no_check(s16) check_range((cast(s32) step2[0]) - cast(s32) step2[15]);

    step1[16] = step2[16];
    step1[17] = step2[17];
    step1[18] = step2[18];
    step1[19] = step2[19];
    temp1 = (-(cast,no_check(s32) step2[20]) + cast(s32) step2[27]) * cast(s32) COSPI_16_64_storage;
    temp2 = ((cast(s32) step2[20]) + cast(s32) step2[27]) * cast(s32) COSPI_16_64_storage;
    step1[20] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[27] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    temp1 = (-(cast,no_check(s32) step2[21]) + cast(s32) step2[26]) * cast(s32) COSPI_16_64_storage;
    temp2 = ((cast(s32) step2[21]) + cast(s32) step2[26]) * cast(s32) COSPI_16_64_storage;
    step1[21] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[26] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    temp1 = (-(cast,no_check(s32) step2[22]) + cast(s32) step2[25]) * cast(s32) COSPI_16_64_storage;
    temp2 = ((cast(s32) step2[22]) + cast(s32) step2[25]) * cast(s32) COSPI_16_64_storage;
    step1[22] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[25] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    temp1 = (-(cast,no_check(s32) step2[23]) + cast(s32) step2[24]) * cast(s32) COSPI_16_64_storage;
    temp2 = ((cast(s32) step2[23]) + cast(s32) step2[24]) * cast(s32) COSPI_16_64_storage;
    step1[23] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[24] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    step1[28] = step2[28];
    step1[29] = step2[29];
    step1[30] = step2[30];
    step1[31] = step2[31];

    output[0] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[0]) + cast(s32) step1[31]);
    output[1] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[1]) + cast(s32) step1[30]);
    output[2] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[2]) + cast(s32) step1[29]);
    output[3] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[3]) + cast(s32) step1[28]);
    output[4] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[4]) + cast(s32) step1[27]);
    output[5] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[5]) + cast(s32) step1[26]);
    output[6] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[6]) + cast(s32) step1[25]);
    output[7] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[7]) + cast(s32) step1[24]);
    output[8] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[8]) + cast(s32) step1[23]);
    output[9] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[9]) + cast(s32) step1[22]);
    output[10] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[10]) + cast(s32) step1[21]);
    output[11] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[11]) + cast(s32) step1[20]);
    output[12] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[12]) + cast(s32) step1[19]);
    output[13] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[13]) + cast(s32) step1[18]);
    output[14] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[14]) + cast(s32) step1[17]);
    output[15] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[15]) + cast(s32) step1[16]);
    output[16] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[15]) - cast(s32) step1[16]);
    output[17] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[14]) - cast(s32) step1[17]);
    output[18] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[13]) - cast(s32) step1[18]);
    output[19] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[12]) - cast(s32) step1[19]);
    output[20] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[11]) - cast(s32) step1[20]);
    output[21] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[10]) - cast(s32) step1[21]);
    output[22] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[9]) - cast(s32) step1[22]);
    output[23] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[8]) - cast(s32) step1[23]);
    output[24] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[7]) - cast(s32) step1[24]);
    output[25] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[6]) - cast(s32) step1[25]);
    output[26] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[5]) - cast(s32) step1[26]);
    output[27] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[4]) - cast(s32) step1[27]);
    output[28] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[3]) - cast(s32) step1[28]);
    output[29] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[2]) - cast(s32) step1[29]);
    output[30] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[1]) - cast(s32) step1[30]);
    output[31] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[0]) - cast(s32) step1[31]);
}

idct32x32_135_add_c :: (input: *Tran_Low_T, dest: *u8, stride: s32) {
    j: s32 = ---;
    out: [1024] Tran_Low_T;
    outptr := out.data;
    temp_in, temp_out: [32] Tran_Low_T = ---;

    for i: 0..cast(s32) 16 - 1 {
        idct32_c(input, outptr);
        input += 32;
        outptr += 32;
    }

    for i: 0..cast(s32) 32 - 1 {
        j = 0;
        while j < 32 {
            temp_in[j] = out[j * 32 + i];
            j += 1;
        }
        idct32_c(temp_in.data, temp_out.data);
        j = 0;
        while j < 32 {
            dest[j * stride + i] =
                clip_pixel_add(
                    dest[j * stride + i],
                    ((cast(s32) temp_out[j]) + (cast(s32) 1) << (((6 - 1)) & 31)) >> 6
                );
            j += 1;
        }
    }
}

idct32x32_1_add_c :: (input: *Tran_Low_T, dest: *u8, stride: s32) {
    i: s32 = ---;

    out :=
        cast,no_check(Tran_Low_T) check_range(
            dct_const_round_shift(
            (cast(s32) input[0]) * cast(s32) COSPI_16_64_storage
        )
        );

    out =
        cast,no_check(Tran_Low_T) check_range(
            dct_const_round_shift((cast(s32) out) * cast(s32) COSPI_16_64_storage)
        );
    a1 := ((cast(s32) out) + (cast(s32) 1) << (((6 - 1)) & 31)) >> 6;

    for j: 0..cast(s32) 32 - 1 {
        i = 0;
        while i < 32 {
            dest[i] = clip_pixel_add(dest[i], a1);
            i += 1;
        }
        dest += stride;
    }
}

idct32x32_34_add_c :: (input: *Tran_Low_T, dest: *u8, stride: s32) {
    j: s32 = ---;
    out: [1024] Tran_Low_T;
    outptr := out.data;
    temp_in, temp_out: [32] Tran_Low_T = ---;

    for i: 0..cast(s32) 8 - 1 {
        idct32_c(input, outptr);
        input += 32;
        outptr += 32;
    }

    for i: 0..cast(s32) 32 - 1 {
        j = 0;
        while j < 32 {
            temp_in[j] = out[j * 32 + i];
            j += 1;
        }
        idct32_c(temp_in.data, temp_out.data);
        j = 0;
        while j < 32 {
            dest[j * stride + i] =
                clip_pixel_add(
                    dest[j * stride + i],
                    ((cast(s32) temp_out[j]) + (cast(s32) 1) << (((6 - 1)) & 31)) >> 6
                );
            j += 1;
        }
    }
}

idct4x4_16_add_c :: (input: *Tran_Low_T, dest: *u8, stride: s32) {
    j: s32 = ---;
    out: [16] Tran_Low_T = ---;
    outptr := out.data;
    temp_in, temp_out: [4] Tran_Low_T = ---;

    for i: 0..cast(s32) 4 - 1 {
        idct4_c(input, outptr);
        input += 4;
        outptr += 4;
    }

    for i: 0..cast(s32) 4 - 1 {
        j = 0;
        while j < 4 {
            temp_in[j] = out[j * 4 + i];
            j += 1;
        }
        idct4_c(temp_in.data, temp_out.data);
        j = 0;
        while j < 4 {
            dest[j * stride + i] =
                clip_pixel_add(
                    dest[j * stride + i],
                    ((cast(s32) temp_out[j]) + (cast(s32) 1) << (((4 - 1)) & 31)) >> 4
                );
            j += 1;
        }
    }
}

idct4_c :: (input: *Tran_Low_T, output: *Tran_Low_T) {
    step: [4] s16 = ---;
    temp1: Tran_High_T = ---;

    temp1 = ((cast(s32) input[0]) + cast(s32) input[2]) * cast(s32) COSPI_16_64_storage;
    temp2 := ((cast(s32) input[0]) - cast(s32) input[2]) * cast(s32) COSPI_16_64_storage;
    step[0] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step[1] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    temp1 =
        ((cast(s32) input[1]) * cast(s32) COSPI_24_64_storage) -
            (cast(s32) input[3]) * cast(s32) COSPI_8_64_storage;
    temp2 =
        ((cast(s32) input[1]) * cast(s32) COSPI_8_64_storage) +
            (cast(s32) input[3]) * cast(s32) COSPI_24_64_storage;
    step[2] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step[3] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));

    output[0] = cast,no_check(Tran_Low_T) check_range((cast(s32) step[0]) + cast(s32) step[3]);
    output[1] = cast,no_check(Tran_Low_T) check_range((cast(s32) step[1]) + cast(s32) step[2]);
    output[2] = cast,no_check(Tran_Low_T) check_range((cast(s32) step[1]) - cast(s32) step[2]);
    output[3] = cast,no_check(Tran_Low_T) check_range((cast(s32) step[0]) - cast(s32) step[3]);
}

idct4x4_1_add_c :: (input: *Tran_Low_T, dest: *u8, stride: s32) {
    out :=
        cast,no_check(Tran_Low_T) check_range(
            dct_const_round_shift(
            (cast(s32) input[0]) * cast(s32) COSPI_16_64_storage
        )
        );

    out =
        cast,no_check(Tran_Low_T) check_range(
            dct_const_round_shift((cast(s32) out) * cast(s32) COSPI_16_64_storage)
        );
    a1 := ((cast(s32) out) + (cast(s32) 1) << (((4 - 1)) & 31)) >> 4;

    for i: 0..cast(s32) 4 - 1 {
        dest[0] = clip_pixel_add(dest[0], a1);
        dest[1] = clip_pixel_add(dest[1], a1);
        dest[2] = clip_pixel_add(dest[2], a1);
        dest[3] = clip_pixel_add(dest[3], a1);
        dest += stride;
    }
}

idct8x8_12_add_c :: (input: *Tran_Low_T, dest: *u8, stride: s32) {
    j: s32 = ---;
    out: [64] Tran_Low_T;
    outptr := out.data;
    temp_in, temp_out: [8] Tran_Low_T = ---;

    for i: 0..cast(s32) 4 - 1 {
        idct8_c(input, outptr);
        input += 8;
        outptr += 8;
    }

    for i: 0..cast(s32) 8 - 1 {
        j = 0;
        while j < 8 {
            temp_in[j] = out[j * 8 + i];
            j += 1;
        }
        idct8_c(temp_in.data, temp_out.data);
        j = 0;
        while j < 8 {
            dest[j * stride + i] =
                clip_pixel_add(
                    dest[j * stride + i],
                    ((cast(s32) temp_out[j]) + (cast(s32) 1) << (((5 - 1)) & 31)) >> 5
                );
            j += 1;
        }
    }
}

idct8_c :: (input: *Tran_Low_T, output: *Tran_Low_T) {
    step1, step2: [8] s16 = ---;

    step1[0] = input[0];
    step1[2] = input[4];
    step1[1] = input[2];
    step1[3] = input[6];
    temp1 :=
        ((cast(s32) input[1]) * cast(s32) COSPI_28_64_storage) -
            (cast(s32) input[7]) * cast(s32) COSPI_4_64_storage;
    temp2 :=
        ((cast(s32) input[1]) * cast(s32) COSPI_4_64_storage) +
            (cast(s32) input[7]) * cast(s32) COSPI_28_64_storage;
    step1[4] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[7] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    temp1 =
        ((cast(s32) input[5]) * cast(s32) COSPI_12_64_storage) -
            (cast(s32) input[3]) * cast(s32) COSPI_20_64_storage;
    temp2 =
        ((cast(s32) input[5]) * cast(s32) COSPI_20_64_storage) +
            (cast(s32) input[3]) * cast(s32) COSPI_12_64_storage;
    step1[5] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[6] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));

    temp1 = ((cast(s32) step1[0]) + cast(s32) step1[2]) * cast(s32) COSPI_16_64_storage;
    temp2 = ((cast(s32) step1[0]) - cast(s32) step1[2]) * cast(s32) COSPI_16_64_storage;
    step2[0] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[1] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    temp1 =
        ((cast(s32) step1[1]) * cast(s32) COSPI_24_64_storage) -
            (cast(s32) step1[3]) * cast(s32) COSPI_8_64_storage;
    temp2 =
        ((cast(s32) step1[1]) * cast(s32) COSPI_8_64_storage) +
            (cast(s32) step1[3]) * cast(s32) COSPI_24_64_storage;
    step2[2] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step2[3] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    step2[4] = cast,no_check(s16) check_range((cast(s32) step1[4]) + cast(s32) step1[5]);
    step2[5] = cast,no_check(s16) check_range((cast(s32) step1[4]) - cast(s32) step1[5]);
    step2[6] = cast,no_check(s16) check_range(-(cast,no_check(s32) step1[6]) + cast(s32) step1[7]);
    step2[7] = cast,no_check(s16) check_range((cast(s32) step1[6]) + cast(s32) step1[7]);

    step1[0] = cast,no_check(s16) check_range((cast(s32) step2[0]) + cast(s32) step2[3]);
    step1[1] = cast,no_check(s16) check_range((cast(s32) step2[1]) + cast(s32) step2[2]);
    step1[2] = cast,no_check(s16) check_range((cast(s32) step2[1]) - cast(s32) step2[2]);
    step1[3] = cast,no_check(s16) check_range((cast(s32) step2[0]) - cast(s32) step2[3]);
    step1[4] = step2[4];
    temp1 = ((cast(s32) step2[6]) - cast(s32) step2[5]) * cast(s32) COSPI_16_64_storage;
    temp2 = ((cast(s32) step2[5]) + cast(s32) step2[6]) * cast(s32) COSPI_16_64_storage;
    step1[5] = cast,no_check(s16) check_range(dct_const_round_shift(temp1));
    step1[6] = cast,no_check(s16) check_range(dct_const_round_shift(temp2));
    step1[7] = step2[7];

    output[0] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[0]) + cast(s32) step1[7]);
    output[1] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[1]) + cast(s32) step1[6]);
    output[2] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[2]) + cast(s32) step1[5]);
    output[3] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[3]) + cast(s32) step1[4]);
    output[4] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[3]) - cast(s32) step1[4]);
    output[5] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[2]) - cast(s32) step1[5]);
    output[6] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[1]) - cast(s32) step1[6]);
    output[7] = cast,no_check(Tran_Low_T) check_range((cast(s32) step1[0]) - cast(s32) step1[7]);
}

idct8x8_1_add_c :: (input: *Tran_Low_T, dest: *u8, stride: s32) {
    i: s32 = ---;

    out :=
        cast,no_check(Tran_Low_T) check_range(
            dct_const_round_shift(
            (cast(s32) input[0]) * cast(s32) COSPI_16_64_storage
        )
        );

    out =
        cast,no_check(Tran_Low_T) check_range(
            dct_const_round_shift((cast(s32) out) * cast(s32) COSPI_16_64_storage)
        );
    a1 := ((cast(s32) out) + (cast(s32) 1) << (((5 - 1)) & 31)) >> 5;
    for j: 0..cast(s32) 8 - 1 {
        i = 0;
        while i < 8 {
            dest[i] = clip_pixel_add(dest[i], a1);
            i += 1;
        }
        dest += stride;
    }
}

idct8x8_64_add_c :: (input: *Tran_Low_T, dest: *u8, stride: s32) {
    j: s32 = ---;
    out: [64] Tran_Low_T = ---;
    outptr := out.data;
    temp_in, temp_out: [8] Tran_Low_T = ---;

    for i: 0..cast(s32) 8 - 1 {
        idct8_c(input, outptr);
        input += 8;
        outptr += 8;
    }

    for i: 0..cast(s32) 8 - 1 {
        j = 0;
        while j < 8 {
            temp_in[j] = out[j * 8 + i];
            j += 1;
        }
        idct8_c(temp_in.data, temp_out.data);
        j = 0;
        while j < 8 {
            dest[j * stride + i] =
                clip_pixel_add(
                    dest[j * stride + i],
                    ((cast(s32) temp_out[j]) + (cast(s32) 1) << (((5 - 1)) & 31)) >> 5
                );
            j += 1;
        }
    }
}

iwht4x4_16_add_c :: (input: *Tran_Low_T, dest: *u8, stride: s32) {
    output: [16] Tran_Low_T = ---;
    a1, b1, c1, d1, e1: Tran_High_T = ---;
    ip := input;
    op := output.data;

    for i: 0..cast(s32) 4 - 1 {
        a1 = (cast(s32) ip[0]) >> 2;
        c1 = (cast(s32) ip[1]) >> 2;
        d1 = (cast(s32) ip[2]) >> 2;
        b1 = (cast(s32) ip[3]) >> 2;
        a1 += c1;
        d1 -= b1;
        e1 = (a1 - d1) >> 1;
        b1 = e1 - b1;
        c1 = e1 - c1;
        a1 -= b1;
        d1 += c1;
        op[0] = cast,no_check(Tran_Low_T) check_range(a1);
        op[1] = cast,no_check(Tran_Low_T) check_range(b1);
        op[2] = cast,no_check(Tran_Low_T) check_range(c1);
        op[3] = cast,no_check(Tran_Low_T) check_range(d1);
        ip += 4;
        op += 4;
    }

    ip = output.data;
    for i: 0..cast(s32) 4 - 1 {
        a1 = cast,no_check(Tran_High_T) ip[4 * 0];
        c1 = cast,no_check(Tran_High_T) ip[4 * 1];
        d1 = cast,no_check(Tran_High_T) ip[4 * 2];
        b1 = cast,no_check(Tran_High_T) ip[4 * 3];
        a1 += c1;
        d1 -= b1;
        e1 = (a1 - d1) >> 1;
        b1 = e1 - b1;
        c1 = e1 - c1;
        a1 -= b1;
        d1 += c1;
        dest[stride * 0] = clip_pixel_add(dest[stride * 0], check_range(a1));
        dest[stride * 1] = clip_pixel_add(dest[stride * 1], check_range(b1));
        dest[stride * 2] = clip_pixel_add(dest[stride * 2], check_range(c1));
        dest[stride * 3] = clip_pixel_add(dest[stride * 3], check_range(d1));

        ip += 1;
        dest += 1;
    }
}

iwht4x4_1_add_c :: (input: *Tran_Low_T, dest: *u8, stride: s32) {
    tmp: [4] Tran_Low_T = ---;
    ip := input;
    op := tmp.data;

    a1 := (cast(s32) ip[0]) >> 2;
    e1 := a1 >> 1;
    a1 -= e1;
    op[0] = cast,no_check(Tran_Low_T) check_range(a1);
    op[3] = cast,no_check(Tran_Low_T) check_range(e1);
    op[2] = op[3];
    op[1] = op[2];

    ip = tmp.data;
    for i: 0..cast(s32) 4 - 1 {
        e1 = (cast(s32) ip[0]) >> 1;
        a1 = (cast(Tran_High_T) ip[0]) - e1;
        dest[stride * 0] = clip_pixel_add(dest[stride * 0], a1);
        dest[stride * 1] = clip_pixel_add(dest[stride * 1], e1);
        dest[stride * 2] = clip_pixel_add(dest[stride * 2], e1);
        dest[stride * 3] = clip_pixel_add(dest[stride * 3], e1);
        ip += 1;
        dest += 1;
    }
}

iadst4_c :: (input: *Tran_Low_T, output: *Tran_Low_T) {
    x0 := input[0];
    x1 := input[1];
    x2 := input[2];
    x3 := input[3];

    if (((cast(s32) x0) | cast(s32) x1) | cast(s32) x2) | cast(s32) x3 == 0 {
        fill_memory(output, 0, cast(u64) 4 * size_of(Tran_Low_T));
        return;
    }

    s0 := (cast(s32) SINPI_1_9_storage) * cast(s32) x0;
    s1 := (cast(s32) SINPI_2_9_storage) * cast(s32) x0;
    s2 := (cast(s32) SINPI_3_9_storage) * cast(s32) x1;
    s3 := (cast(s32) SINPI_4_9_storage) * cast(s32) x2;
    s4 := (cast(s32) SINPI_1_9_storage) * cast(s32) x2;
    s5 := (cast(s32) SINPI_2_9_storage) * cast(s32) x3;
    s6 := (cast(s32) SINPI_4_9_storage) * cast(s32) x3;
    s7 := check_range(((cast(s32) x0) - cast(s32) x2) + cast(s32) x3);

    s0 = s0 + s3 + s5;
    s1 = s1 - s4 - s6;
    s3 = s2;
    s2 = (cast(Tran_High_T) SINPI_3_9_storage) * s7;

    output[0] = cast,no_check(Tran_Low_T) check_range(dct_const_round_shift(s0 + s3));
    output[1] = cast,no_check(Tran_Low_T) check_range(dct_const_round_shift(s1 + s3));
    output[2] = cast,no_check(Tran_Low_T) check_range(dct_const_round_shift(s2));
    output[3] = cast,no_check(Tran_Low_T) check_range(dct_const_round_shift(s0 + s1 - s3));
}

iadst8_c :: (input: *Tran_Low_T, output: *Tran_Low_T) {
    x0 := cast,no_check(Tran_High_T) input[7];
    x1 := cast,no_check(Tran_High_T) input[0];
    x2 := cast,no_check(Tran_High_T) input[5];
    x3 := cast,no_check(Tran_High_T) input[2];
    x4 := cast,no_check(Tran_High_T) input[3];
    x5 := cast,no_check(Tran_High_T) input[4];
    x6 := cast,no_check(Tran_High_T) input[1];
    x7 := cast,no_check(Tran_High_T) input[6];

    if x0 | x1 | x2 | x3 | x4 | x5 | x6 | x7 == 0 {
        fill_memory(output, 0, cast(u64) 8 * size_of(Tran_Low_T));
        return;
    }

    s0 := (cast(Tran_High_T) COSPI_2_64_storage) * x0 + (cast(Tran_High_T) COSPI_30_64_storage) * x1;
    s1 := (cast(Tran_High_T) COSPI_30_64_storage) * x0 - (cast(Tran_High_T) COSPI_2_64_storage) * x1;
    s2 := (cast(Tran_High_T) COSPI_10_64_storage) * x2 + (cast(Tran_High_T) COSPI_22_64_storage) * x3;
    s3 := (cast(Tran_High_T) COSPI_22_64_storage) * x2 - (cast(Tran_High_T) COSPI_10_64_storage) * x3;
    s4 := (cast(Tran_High_T) COSPI_18_64_storage) * x4 + (cast(Tran_High_T) COSPI_14_64_storage) * x5;
    s5 := (cast(Tran_High_T) COSPI_14_64_storage) * x4 - (cast(Tran_High_T) COSPI_18_64_storage) * x5;
    s6 := (cast(Tran_High_T) COSPI_26_64_storage) * x6 + (cast(Tran_High_T) COSPI_6_64_storage) * x7;
    s7 := (cast(Tran_High_T) COSPI_6_64_storage) * x6 - (cast(Tran_High_T) COSPI_26_64_storage) * x7;

    x0 = check_range(dct_const_round_shift(s0 + s4));
    x1 = check_range(dct_const_round_shift(s1 + s5));
    x2 = check_range(dct_const_round_shift(s2 + s6));
    x3 = check_range(dct_const_round_shift(s3 + s7));
    x4 = check_range(dct_const_round_shift(s0 - s4));
    x5 = check_range(dct_const_round_shift(s1 - s5));
    x6 = check_range(dct_const_round_shift(s2 - s6));
    x7 = check_range(dct_const_round_shift(s3 - s7));

    s0 = x0;
    s1 = x1;
    s2 = x2;
    s3 = x3;
    s4 = (cast(Tran_High_T) COSPI_8_64_storage) * x4 + (cast(Tran_High_T) COSPI_24_64_storage) * x5;
    s5 = (cast(Tran_High_T) COSPI_24_64_storage) * x4 - (cast(Tran_High_T) COSPI_8_64_storage) * x5;
    s6 = -(cast,no_check(s32) COSPI_24_64_storage) * x6 + (cast(Tran_High_T) COSPI_8_64_storage) * x7;
    s7 = (cast(Tran_High_T) COSPI_8_64_storage) * x6 + (cast(Tran_High_T) COSPI_24_64_storage) * x7;

    x0 = check_range(s0 + s2);
    x1 = check_range(s1 + s3);
    x2 = check_range(s0 - s2);
    x3 = check_range(s1 - s3);
    x4 = check_range(dct_const_round_shift(s4 + s6));
    x5 = check_range(dct_const_round_shift(s5 + s7));
    x6 = check_range(dct_const_round_shift(s4 - s6));
    x7 = check_range(dct_const_round_shift(s5 - s7));

    s2 = (cast(Tran_High_T) COSPI_16_64_storage) * (x2 + x3);
    s3 = (cast(Tran_High_T) COSPI_16_64_storage) * (x2 - x3);
    s6 = (cast(Tran_High_T) COSPI_16_64_storage) * (x6 + x7);
    s7 = (cast(Tran_High_T) COSPI_16_64_storage) * (x6 - x7);

    x2 = check_range(dct_const_round_shift(s2));
    x3 = check_range(dct_const_round_shift(s3));
    x6 = check_range(dct_const_round_shift(s6));
    x7 = check_range(dct_const_round_shift(s7));

    output[0] = cast,no_check(Tran_Low_T) check_range(x0);
    output[1] = cast,no_check(Tran_Low_T) check_range(-x4);
    output[2] = cast,no_check(Tran_Low_T) check_range(x6);
    output[3] = cast,no_check(Tran_Low_T) check_range(-x2);
    output[4] = cast,no_check(Tran_Low_T) check_range(x3);
    output[5] = cast,no_check(Tran_Low_T) check_range(-x7);
    output[6] = cast,no_check(Tran_Low_T) check_range(x5);
    output[7] = cast,no_check(Tran_Low_T) check_range(-x1);
}

iadst16_c :: (input: *Tran_Low_T, output: *Tran_Low_T) {
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

    if x0 | x1 | x2 | x3 | x4 | x5 | x6 | x7 | x8 | x9 | x10 | x11 | x12 | x13 | x14 | x15 == 0 {
        fill_memory(output, 0, cast(u64) 16 * size_of(Tran_Low_T));
        return;
    }

    s0 := (x0 * cast(Tran_High_T) COSPI_1_64_storage) + x1 * cast(Tran_High_T) COSPI_31_64_storage;
    s1 := (x0 * cast(Tran_High_T) COSPI_31_64_storage) - x1 * cast(Tran_High_T) COSPI_1_64_storage;
    s2 := (x2 * cast(Tran_High_T) COSPI_5_64_storage) + x3 * cast(Tran_High_T) COSPI_27_64_storage;
    s3 := (x2 * cast(Tran_High_T) COSPI_27_64_storage) - x3 * cast(Tran_High_T) COSPI_5_64_storage;
    s4 := (x4 * cast(Tran_High_T) COSPI_9_64_storage) + x5 * cast(Tran_High_T) COSPI_23_64_storage;
    s5 := (x4 * cast(Tran_High_T) COSPI_23_64_storage) - x5 * cast(Tran_High_T) COSPI_9_64_storage;
    s6 := (x6 * cast(Tran_High_T) COSPI_13_64_storage) + x7 * cast(Tran_High_T) COSPI_19_64_storage;
    s7 := (x6 * cast(Tran_High_T) COSPI_19_64_storage) - x7 * cast(Tran_High_T) COSPI_13_64_storage;
    s8_ := (x8 * cast(Tran_High_T) COSPI_17_64_storage) + x9 * cast(Tran_High_T) COSPI_15_64_storage;
    s9 := (x8 * cast(Tran_High_T) COSPI_15_64_storage) - x9 * cast(Tran_High_T) COSPI_17_64_storage;
    s10 := (x10 * cast(Tran_High_T) COSPI_21_64_storage) + x11 * cast(Tran_High_T) COSPI_11_64_storage;
    s11 := (x10 * cast(Tran_High_T) COSPI_11_64_storage) - x11 * cast(Tran_High_T) COSPI_21_64_storage;
    s12 := (x12 * cast(Tran_High_T) COSPI_25_64_storage) + x13 * cast(Tran_High_T) COSPI_7_64_storage;
    s13 := (x12 * cast(Tran_High_T) COSPI_7_64_storage) - x13 * cast(Tran_High_T) COSPI_25_64_storage;
    s14 := (x14 * cast(Tran_High_T) COSPI_29_64_storage) + x15 * cast(Tran_High_T) COSPI_3_64_storage;
    s15 := (x14 * cast(Tran_High_T) COSPI_3_64_storage) - x15 * cast(Tran_High_T) COSPI_29_64_storage;

    x0 = check_range(dct_const_round_shift(s0 + s8_));
    x1 = check_range(dct_const_round_shift(s1 + s9));
    x2 = check_range(dct_const_round_shift(s2 + s10));
    x3 = check_range(dct_const_round_shift(s3 + s11));
    x4 = check_range(dct_const_round_shift(s4 + s12));
    x5 = check_range(dct_const_round_shift(s5 + s13));
    x6 = check_range(dct_const_round_shift(s6 + s14));
    x7 = check_range(dct_const_round_shift(s7 + s15));
    x8 = check_range(dct_const_round_shift(s0 - s8_));
    x9 = check_range(dct_const_round_shift(s1 - s9));
    x10 = check_range(dct_const_round_shift(s2 - s10));
    x11 = check_range(dct_const_round_shift(s3 - s11));
    x12 = check_range(dct_const_round_shift(s4 - s12));
    x13 = check_range(dct_const_round_shift(s5 - s13));
    x14 = check_range(dct_const_round_shift(s6 - s14));
    x15 = check_range(dct_const_round_shift(s7 - s15));

    s0 = x0;
    s1 = x1;
    s2 = x2;
    s3 = x3;
    s4 = x4;
    s5 = x5;
    s6 = x6;
    s7 = x7;
    s8_ = (x8 * cast(Tran_High_T) COSPI_4_64_storage) + x9 * cast(Tran_High_T) COSPI_28_64_storage;
    s9 = (x8 * cast(Tran_High_T) COSPI_28_64_storage) - x9 * cast(Tran_High_T) COSPI_4_64_storage;
    s10 = (x10 * cast(Tran_High_T) COSPI_20_64_storage) + x11 * cast(Tran_High_T) COSPI_12_64_storage;
    s11 = (x10 * cast(Tran_High_T) COSPI_12_64_storage) - x11 * cast(Tran_High_T) COSPI_20_64_storage;
    s12 = (-x12 * cast(Tran_High_T) COSPI_28_64_storage) + x13 * cast(Tran_High_T) COSPI_4_64_storage;
    s13 = (x12 * cast(Tran_High_T) COSPI_4_64_storage) + x13 * cast(Tran_High_T) COSPI_28_64_storage;
    s14 = (-x14 * cast(Tran_High_T) COSPI_12_64_storage) + x15 * cast(Tran_High_T) COSPI_20_64_storage;
    s15 = (x14 * cast(Tran_High_T) COSPI_20_64_storage) + x15 * cast(Tran_High_T) COSPI_12_64_storage;

    x0 = check_range(s0 + s4);
    x1 = check_range(s1 + s5);
    x2 = check_range(s2 + s6);
    x3 = check_range(s3 + s7);
    x4 = check_range(s0 - s4);
    x5 = check_range(s1 - s5);
    x6 = check_range(s2 - s6);
    x7 = check_range(s3 - s7);
    x8 = check_range(dct_const_round_shift(s8_ + s12));
    x9 = check_range(dct_const_round_shift(s9 + s13));
    x10 = check_range(dct_const_round_shift(s10 + s14));
    x11 = check_range(dct_const_round_shift(s11 + s15));
    x12 = check_range(dct_const_round_shift(s8_ - s12));
    x13 = check_range(dct_const_round_shift(s9 - s13));
    x14 = check_range(dct_const_round_shift(s10 - s14));
    x15 = check_range(dct_const_round_shift(s11 - s15));

    s0 = x0;
    s1 = x1;
    s2 = x2;
    s3 = x3;
    s4 = (x4 * cast(Tran_High_T) COSPI_8_64_storage) + x5 * cast(Tran_High_T) COSPI_24_64_storage;
    s5 = (x4 * cast(Tran_High_T) COSPI_24_64_storage) - x5 * cast(Tran_High_T) COSPI_8_64_storage;
    s6 = (-x6 * cast(Tran_High_T) COSPI_24_64_storage) + x7 * cast(Tran_High_T) COSPI_8_64_storage;
    s7 = (x6 * cast(Tran_High_T) COSPI_8_64_storage) + x7 * cast(Tran_High_T) COSPI_24_64_storage;
    s8_ = x8;
    s9 = x9;
    s10 = x10;
    s11 = x11;
    s12 = (x12 * cast(Tran_High_T) COSPI_8_64_storage) + x13 * cast(Tran_High_T) COSPI_24_64_storage;
    s13 = (x12 * cast(Tran_High_T) COSPI_24_64_storage) - x13 * cast(Tran_High_T) COSPI_8_64_storage;
    s14 = (-x14 * cast(Tran_High_T) COSPI_24_64_storage) + x15 * cast(Tran_High_T) COSPI_8_64_storage;
    s15 = (x14 * cast(Tran_High_T) COSPI_8_64_storage) + x15 * cast(Tran_High_T) COSPI_24_64_storage;

    x0 = check_range(s0 + s2);
    x1 = check_range(s1 + s3);
    x2 = check_range(s0 - s2);
    x3 = check_range(s1 - s3);
    x4 = check_range(dct_const_round_shift(s4 + s6));
    x5 = check_range(dct_const_round_shift(s5 + s7));
    x6 = check_range(dct_const_round_shift(s4 - s6));
    x7 = check_range(dct_const_round_shift(s5 - s7));
    x8 = check_range(s8_ + s10);
    x9 = check_range(s9 + s11);
    x10 = check_range(s8_ - s10);
    x11 = check_range(s9 - s11);
    x12 = check_range(dct_const_round_shift(s12 + s14));
    x13 = check_range(dct_const_round_shift(s13 + s15));
    x14 = check_range(dct_const_round_shift(s12 - s14));
    x15 = check_range(dct_const_round_shift(s13 - s15));

    s2 = -(cast,no_check(s32) COSPI_16_64_storage) * (x2 + x3);
    s3 = (cast(Tran_High_T) COSPI_16_64_storage) * (x2 - x3);
    s6 = (cast(Tran_High_T) COSPI_16_64_storage) * (x6 + x7);
    s7 = (cast(Tran_High_T) COSPI_16_64_storage) * (-x6 + x7);
    s10 = (cast(Tran_High_T) COSPI_16_64_storage) * (x10 + x11);
    s11 = (cast(Tran_High_T) COSPI_16_64_storage) * (-x10 + x11);
    s14 = -(cast,no_check(s32) COSPI_16_64_storage) * (x14 + x15);
    s15 = (cast(Tran_High_T) COSPI_16_64_storage) * (x14 - x15);

    x2 = check_range(dct_const_round_shift(s2));
    x3 = check_range(dct_const_round_shift(s3));
    x6 = check_range(dct_const_round_shift(s6));
    x7 = check_range(dct_const_round_shift(s7));
    x10 = check_range(dct_const_round_shift(s10));
    x11 = check_range(dct_const_round_shift(s11));
    x14 = check_range(dct_const_round_shift(s14));
    x15 = check_range(dct_const_round_shift(s15));

    output[0] = cast,no_check(Tran_Low_T) check_range(x0);
    output[1] = cast,no_check(Tran_Low_T) check_range(-x8);
    output[2] = cast,no_check(Tran_Low_T) check_range(x12);
    output[3] = cast,no_check(Tran_Low_T) check_range(-x4);
    output[4] = cast,no_check(Tran_Low_T) check_range(x6);
    output[5] = cast,no_check(Tran_Low_T) check_range(x14);
    output[6] = cast,no_check(Tran_Low_T) check_range(x10);
    output[7] = cast,no_check(Tran_Low_T) check_range(x2);
    output[8] = cast,no_check(Tran_Low_T) check_range(x3);
    output[9] = cast,no_check(Tran_Low_T) check_range(x11);
    output[10] = cast,no_check(Tran_Low_T) check_range(x15);
    output[11] = cast,no_check(Tran_Low_T) check_range(x7);
    output[12] = cast,no_check(Tran_Low_T) check_range(x5);
    output[13] = cast,no_check(Tran_Low_T) check_range(-x13);
    output[14] = cast,no_check(Tran_Low_T) check_range(x9);
    output[15] = cast,no_check(Tran_Low_T) check_range(-x1);
}

globals_initialization_state_for_inv_txfm: u32;
initialize_globals_for_inv_txfm :: () {
    {
        state := atomic_load(*globals_initialization_state_for_inv_txfm);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_inv_txfm, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_inv_txfm) != 2 {}
            return;
        }
    }
    COSPI_1_64_storage = 16364;
    COSPI_2_64_storage = 16305;
    COSPI_3_64_storage = 16207;
    COSPI_4_64_storage = 16069;
    COSPI_5_64_storage = 15893;
    COSPI_6_64_storage = 15679;
    COSPI_7_64_storage = 15426;
    COSPI_8_64_storage = 15137;
    COSPI_9_64_storage = 14811;
    COSPI_10_64_storage = 14449;
    COSPI_11_64_storage = 14053;
    COSPI_12_64_storage = 13623;
    COSPI_13_64_storage = 13160;
    COSPI_14_64_storage = 12665;
    COSPI_15_64_storage = 12140;
    COSPI_16_64_storage = 11585;
    COSPI_17_64_storage = 11003;
    COSPI_18_64_storage = 10394;
    COSPI_19_64_storage = 9760;
    COSPI_20_64_storage = 9102;
    COSPI_21_64_storage = 8423;
    COSPI_22_64_storage = 7723;
    COSPI_23_64_storage = 7005;
    COSPI_24_64_storage = 6270;
    COSPI_25_64_storage = 5520;
    COSPI_26_64_storage = 4756;
    COSPI_27_64_storage = 3981;
    COSPI_28_64_storage = 3196;
    COSPI_29_64_storage = 2404;
    COSPI_30_64_storage = 1606;
    COSPI_31_64_storage = 804;
    SINPI_1_9_storage = 5283;
    SINPI_2_9_storage = 9929;
    SINPI_3_9_storage = 13377;
    SINPI_4_9_storage = 15212;
    atomic_store(*globals_initialization_state_for_inv_txfm, 2);
}

