// Generated directly from C by cpp_transpiler.
COUNT_TO_UPDATE_FACTOR_in_vp9_subexp: [21] s32;

MAP_TABLE: [254] u8;

UPDATE_BITS: [255] u8;

clip_pixel_in_vp9_subexp :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_subexp :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_subexp :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_subexp :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_subexp :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_subexp(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_subexp(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_subexp(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_subexp :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_prob_in_vp9_subexp :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_subexp :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_subexp(n0, DEN);
}

weighted_prob_in_vp9_subexp :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_subexp :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_subexp(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_subexp(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_subexp :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_subexp[COUNT];
        PROB := get_prob_in_vp9_subexp(ct[0], DEN);
        return weighted_prob_in_vp9_subexp(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

write_in_vp9_subexp :: (br: *Writer, bit: s32, probability: s32) {
    count := br.count;
    range := br.range;
    lowvalue := br.lowvalue;

    split := 1 + ((range - 1) * cast,no_check(u32) probability) >> 8;

    range = split;

    if bit != 0 {
        lowvalue += split;
        range = br.range - split;
    }

    shift := cast,no_check(s32) NORM[range];

    c_transpiler_compound_shl(*(range), (((cast,no_check(u32) shift) & 31)), u32, u32);
    count += shift;

    if count >= 0 {
        offset := shift - count;

        if br.error == 0 {
            if lowvalue << (((offset - 1)) & 31) & 0x80000000 != 0 {
                x := (cast,no_check(s32) br.pos) - 1;

                while x >= 0 && br.buffer[x] == 0xff {
                    br.buffer[x] = 0;
                    x -= 1;
                }

                br.buffer[x] = cast,no_check(u8) ((cast,no_check(s32) br.buffer[x]) + 1);
            }

            if br.pos < br.size {
                br.buffer[br.pos] = cast,no_check(u8) (lowvalue >> (((24 - offset)) & 31) & 0xff);
                br.pos += 1;
            } else {
                br.error = 1;
            }
        }
        c_transpiler_compound_shl(*(lowvalue), (((cast,no_check(u32) offset) & 31)), u32, u32);
        shift = count;
        lowvalue &= 0xffffff;
        count -= 8;
    }

    c_transpiler_compound_shl(*(lowvalue), (((cast,no_check(u32) shift) & 31)), u32, u32);
    br.count = count;
    br.lowvalue = lowvalue;
    br.range = range;
}

write_bit_in_vp9_subexp :: (w: *Writer, bit: s32) {
    write_in_vp9_subexp(w, bit, 128);
}

write_literal_in_vp9_subexp :: (w: *Writer, data: s32, bits: s32) {
    bit := bits - 1;
    while bit >= 0 {
        write_bit_in_vp9_subexp(w, 1 & (data >> ((bit) & 31)));
        bit -= 1;
    }
}

get_lsb_in_vp9_subexp :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_subexp :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_subexp :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_subexp(num_values) + 1 else 0;
}

get_band_translate_in_vp9_subexp :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_subexp :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_subexp :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_subexp(above_ec, left_ec);
}

cost_branch256_in_vp9_subexp :: (ct: *u32, p: Prob) -> u64 {
    return ((cast,no_check(u64) ct[0]) * cast(u64) VP9_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP9_PROB_COST[256 - cast(s32) p];
}

treed_cost_in_vp9_subexp :: (tree: *Tree_Index, probs: *Prob, bits: s32, len: s32) -> s32 {
    cost: s32 = 0;
    i: Tree_Index = 0;

    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            cost +=
                cast,no_check(s32) (VP9_PROB_COST[(ifx BIT != 0 then 256 -
                    cast(s32) probs[(cast(s32) i) >> 1] else cast,no_check(s32) probs[(cast(s32) i) >> 1])]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }

    return cost;
}

vp9_write_prob_diff_update :: (w: *Writer, newp: Prob, oldp: Prob) {
    DELP := remap_prob(cast,no_check(s32) newp, cast,no_check(s32) oldp);
    encode_term_subexp(w, DELP);
}

remap_prob :: (v: s32, m: s32) -> s32 {
    v -= 1;
    m -= 1;

    i: s32 = ifx m << 1 <= 255
        then recenter_nonneg(v, m) - 1
        else recenter_nonneg((cast,no_check(s32) ((255 - 1))) - v, (cast,no_check(s32) ((255 - 1))) - m) - 1;

    i = cast,no_check(s32) MAP_TABLE[i];
    return i;
}

recenter_nonneg :: (v: s32, m: s32) -> s32 {
    if v > m << 1 {
        return v;
    } else if v >= m {
        return (v - m) << 1;
    } else {
        return (m - v) << 1 - 1;
    }
}

encode_term_subexp :: (w: *Writer, word: s32) {
    if write_bit_gte(w, word, 16) == 0 {
        write_literal_in_vp9_subexp(w, word, 4);
    } else if write_bit_gte(w, word, 32) == 0 {
        write_literal_in_vp9_subexp(w, word - 16, 4);
    } else if write_bit_gte(w, word, 64) == 0 {
        write_literal_in_vp9_subexp(w, word - 32, 5);
    } else {
        encode_uniform(w, word - 64);
    }
}

encode_uniform :: (w: *Writer, v: s32) {
    L: s32 = 8;
    M := (cast(s32) 1) << ((L) & 31) - 191;
    if v < M {
        write_literal_in_vp9_subexp(w, v, L - 1);
    } else {
        write_literal_in_vp9_subexp(w, M + (v - M) >> 1, L - 1);
        write_literal_in_vp9_subexp(w, (v - M) & 1, 1);
    }
}

write_bit_gte :: (w: *Writer, word: s32, test: s32) -> s32 {
    write_literal_in_vp9_subexp(w, cast(s32) (word >= test), 1);
    if word >= test {
        return 1;
    }
    return 0;
}

vp9_cond_prob_diff_update :: (w: *Writer, oldp: *Prob, ct: *u32) {
    UPD: Prob = 252;
    newp := get_binary_prob_in_vp9_subexp(ct[0], ct[1]);
    SAVINGS := vp9_prob_diff_update_savings_search(ct, oldp.*, *newp, UPD);

    if SAVINGS > 0 {
        write_in_vp9_subexp(w, 1, cast,no_check(s32) UPD);
        vp9_write_prob_diff_update(w, newp, oldp.*);
        oldp.* = newp;
    } else {
        write_in_vp9_subexp(w, 0, cast,no_check(s32) UPD);
    }
}

vp9_prob_diff_update_savings_search :: (ct: *u32, oldp: Prob, bestp: *Prob, upd: Prob) -> s64 {
    OLD_B := cast,no_check(s64) cost_branch256_in_vp9_subexp(ct, oldp);
    bestsavings: s64 = 0;
    newp: Prob = ---;
    bestnewp := oldp;
    STEP := (ifx bestp.* > oldp then cast(s32) -1 else 1);
    UPD_COST := (cast(s32) VP9_PROB_COST[256 - cast(s32) upd]) - cast(s32) VP9_PROB_COST[upd];

    if OLD_B > cast,no_check(s64) (UPD_COST + (cast(s32) 5) << 9) {
        newp = bestp.*;
        while newp != oldp {
            NEW_B := cast,no_check(s64) cost_branch256_in_vp9_subexp(ct, newp);
            UPDATE_B := cast,no_check(s64) (prob_diff_update_cost(newp, oldp) + UPD_COST);
            SAVINGS := OLD_B - NEW_B - UPDATE_B;
            if SAVINGS > bestsavings {
                bestsavings = SAVINGS;
                bestnewp = newp;
            }
            newp = cast,no_check(Prob) ((cast,no_check(s32) newp) + STEP);
        }
    }
    bestp.* = bestnewp;
    return bestsavings;
}

prob_diff_update_cost :: (newp: Prob, oldp: Prob) -> s32 {
    delp := remap_prob(cast,no_check(s32) newp, cast,no_check(s32) oldp);
    return (cast(s32) UPDATE_BITS[delp]) << 9;
}

vp9_prob_diff_update_savings_search_model :: (ct: *u32, OLDP: Prob, bestp: *Prob, upd: Prob, stepsize: s32) -> s64 {
    new_b: s64 = ---;
    update_b: s64 = ---;
    savings: s64 = ---;
    newp: s64 = ---;
    STEP_SIGN := (ifx bestp.* > OLDP then cast(s64) -1 else 1);
    STEP := (cast(s64) stepsize) * STEP_SIGN;
    UPD_COST := cast,no_check(s64) ((cast(s32) VP9_PROB_COST[256 - cast(s32) upd]) - cast(s32) VP9_PROB_COST[upd]);
    newplist: *Prob = ---;

    oldplist := VP9_PARETO8_FULL[(cast(s32) OLDP) - 1].data;
    old_b := cast,no_check(s64) cost_branch256_in_vp9_subexp(ct + 2 * 2, OLDP);
    i: s64 = 3;
    while i < 11 {
        c_transpiler_compound_add(*(old_b), (cost_branch256_in_vp9_subexp(ct + 2 * i, oldplist[i - 3])), u64, u64);
        i += 1;
    }

    bestsavings: s64 = 0;
    bestnewp := OLDP;

    if old_b > UPD_COST + cast,no_check(s64) ((cast(s32) 5) << 9) {
        newp = cast,no_check(s64) bestp.*;
        while ((newp - cast(s64) OLDP) * STEP_SIGN) < 0 {
            if newp < 1 || newp > 255 {
                newp += STEP;
                continue;
            }
            newplist = VP9_PARETO8_FULL[newp - 1].data;
            new_b = cast,no_check(s64) cost_branch256_in_vp9_subexp(ct + 2 * 2, cast,no_check(Prob) newp);
            i = 3;
            while i < 11 {
                c_transpiler_compound_add(*(new_b), (cost_branch256_in_vp9_subexp(ct + 2 * i, newplist[i - 3])), u64, u64);
                i += 1;
            }
            update_b = (cast(s64) prob_diff_update_cost(cast,no_check(Prob) newp, OLDP)) + UPD_COST;
            savings = old_b - new_b - update_b;
            if savings > bestsavings {
                bestsavings = savings;
                bestnewp = cast,no_check(Prob) newp;
            }
            newp += STEP;
        }
    }

    bestp.* = bestnewp;
    return bestsavings;
}

globals_initialization_state_for_vp9_subexp: u32;
initialize_globals_for_vp9_subexp :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_subexp);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_subexp, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_subexp) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_vp9_subexp =
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
    UPDATE_BITS =
        u8.[
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            10,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            11,
            0
        ];
    MAP_TABLE =
        u8.[
            20,
            21,
            22,
            23,
            24,
            25,
            0,
            26,
            27,
            28,
            29,
            30,
            31,
            32,
            33,
            34,
            35,
            36,
            37,
            1,
            38,
            39,
            40,
            41,
            42,
            43,
            44,
            45,
            46,
            47,
            48,
            49,
            2,
            50,
            51,
            52,
            53,
            54,
            55,
            56,
            57,
            58,
            59,
            60,
            61,
            3,
            62,
            63,
            64,
            65,
            66,
            67,
            68,
            69,
            70,
            71,
            72,
            73,
            4,
            74,
            75,
            76,
            77,
            78,
            79,
            80,
            81,
            82,
            83,
            84,
            85,
            5,
            86,
            87,
            88,
            89,
            90,
            91,
            92,
            93,
            94,
            95,
            96,
            97,
            6,
            98,
            99,
            100,
            101,
            102,
            103,
            104,
            105,
            106,
            107,
            108,
            109,
            7,
            110,
            111,
            112,
            113,
            114,
            115,
            116,
            117,
            118,
            119,
            120,
            121,
            8,
            122,
            123,
            124,
            125,
            126,
            127,
            128,
            129,
            130,
            131,
            132,
            133,
            9,
            134,
            135,
            136,
            137,
            138,
            139,
            140,
            141,
            142,
            143,
            144,
            145,
            10,
            146,
            147,
            148,
            149,
            150,
            151,
            152,
            153,
            154,
            155,
            156,
            157,
            11,
            158,
            159,
            160,
            161,
            162,
            163,
            164,
            165,
            166,
            167,
            168,
            169,
            12,
            170,
            171,
            172,
            173,
            174,
            175,
            176,
            177,
            178,
            179,
            180,
            181,
            13,
            182,
            183,
            184,
            185,
            186,
            187,
            188,
            189,
            190,
            191,
            192,
            193,
            14,
            194,
            195,
            196,
            197,
            198,
            199,
            200,
            201,
            202,
            203,
            204,
            205,
            15,
            206,
            207,
            208,
            209,
            210,
            211,
            212,
            213,
            214,
            215,
            216,
            217,
            16,
            218,
            219,
            220,
            221,
            222,
            223,
            224,
            225,
            226,
            227,
            228,
            229,
            17,
            230,
            231,
            232,
            233,
            234,
            235,
            236,
            237,
            238,
            239,
            240,
            241,
            18,
            242,
            243,
            244,
            245,
            246,
            247,
            248,
            249,
            250,
            251,
            252,
            253,
            19
        ];
    atomic_store(*globals_initialization_state_for_vp9_subexp, 2);
}

