// Generated directly from C by cpp_transpiler.
COUNT_TO_UPDATE_FACTOR_in_vp9_quant_common: [21] s32;

DC_QLOOKUP_storage: [256] s16;

AC_QLOOKUP_storage: [256] s16;

clip_pixel_in_vp9_quant_common :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_quant_common :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_quant_common :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_quant_common :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_quant_common :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_quant_common(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_quant_common(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_quant_common(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_quant_common :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_lsb_in_vp9_quant_common :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_quant_common :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_quant_common :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_quant_common(num_values) + 1 else 0;
}

get_prob_in_vp9_quant_common :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_quant_common :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_quant_common(n0, DEN);
}

weighted_prob_in_vp9_quant_common :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_quant_common :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_quant_common(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_quant_common(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_quant_common :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_quant_common[COUNT];
        PROB := get_prob_in_vp9_quant_common(ct[0], DEN);
        return weighted_prob_in_vp9_quant_common(
            cast,no_check(s32) pre_prob,
            cast,no_check(s32) PROB,
            cast,no_check(s32) FACTOR
        );
    }
}

segfeature_active_in_vp9_quant_common :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_quant_common :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

vp9_dc_quant :: (qindex: s32, delta: s32, bit_depth: Bit_Depth_T) -> s16 {
    return DC_QLOOKUP_storage[clamp_in_vp9_quant_common(qindex + delta, 0, 255)];
}

vp9_ac_quant :: (qindex: s32, delta: s32, bit_depth: Bit_Depth_T) -> s16 {
    return AC_QLOOKUP_storage[clamp_in_vp9_quant_common(qindex + delta, 0, 255)];
}

vp9_get_qindex :: (seg: *Segmentation, segment_id: s32, base_qindex: s32) -> s32 {
    if segfeature_active_in_vp9_quant_common(seg, segment_id, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_Q) != 0 {
        DATA := get_segdata_in_vp9_quant_common(seg, segment_id, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_Q);
        SEG_QINDEX := (ifx seg.abs_delta == 1 then DATA else base_qindex + DATA);
        return clamp_in_vp9_quant_common(SEG_QINDEX, 0, 255);
    } else {
        return base_qindex;
    }
}

globals_initialization_state_for_vp9_quant_common: u32;
initialize_globals_for_vp9_quant_common :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_quant_common);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_quant_common, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_quant_common) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_vp9_quant_common =
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
    DC_QLOOKUP_storage =
        s16.[
            4,
            8,
            8,
            9,
            10,
            11,
            12,
            12,
            13,
            14,
            15,
            16,
            17,
            18,
            19,
            19,
            20,
            21,
            22,
            23,
            24,
            25,
            26,
            26,
            27,
            28,
            29,
            30,
            31,
            32,
            32,
            33,
            34,
            35,
            36,
            37,
            38,
            38,
            39,
            40,
            41,
            42,
            43,
            43,
            44,
            45,
            46,
            47,
            48,
            48,
            49,
            50,
            51,
            52,
            53,
            53,
            54,
            55,
            56,
            57,
            57,
            58,
            59,
            60,
            61,
            62,
            62,
            63,
            64,
            65,
            66,
            66,
            67,
            68,
            69,
            70,
            70,
            71,
            72,
            73,
            74,
            74,
            75,
            76,
            77,
            78,
            78,
            79,
            80,
            81,
            81,
            82,
            83,
            84,
            85,
            85,
            87,
            88,
            90,
            92,
            93,
            95,
            96,
            98,
            99,
            101,
            102,
            104,
            105,
            107,
            108,
            110,
            111,
            113,
            114,
            116,
            117,
            118,
            120,
            121,
            123,
            125,
            127,
            129,
            131,
            134,
            136,
            138,
            140,
            142,
            144,
            146,
            148,
            150,
            152,
            154,
            156,
            158,
            161,
            164,
            166,
            169,
            172,
            174,
            177,
            180,
            182,
            185,
            187,
            190,
            192,
            195,
            199,
            202,
            205,
            208,
            211,
            214,
            217,
            220,
            223,
            226,
            230,
            233,
            237,
            240,
            243,
            247,
            250,
            253,
            257,
            261,
            265,
            269,
            272,
            276,
            280,
            284,
            288,
            292,
            296,
            300,
            304,
            309,
            313,
            317,
            322,
            326,
            330,
            335,
            340,
            344,
            349,
            354,
            359,
            364,
            369,
            374,
            379,
            384,
            389,
            395,
            400,
            406,
            411,
            417,
            423,
            429,
            435,
            441,
            447,
            454,
            461,
            467,
            475,
            482,
            489,
            497,
            505,
            513,
            522,
            530,
            539,
            549,
            559,
            569,
            579,
            590,
            602,
            614,
            626,
            640,
            654,
            668,
            684,
            700,
            717,
            736,
            755,
            775,
            796,
            819,
            843,
            869,
            896,
            925,
            955,
            988,
            1022,
            1058,
            1098,
            1139,
            1184,
            1232,
            1282,
            1336
        ];
    AC_QLOOKUP_storage =
        s16.[
            4,
            8,
            9,
            10,
            11,
            12,
            13,
            14,
            15,
            16,
            17,
            18,
            19,
            20,
            21,
            22,
            23,
            24,
            25,
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
            98,
            99,
            100,
            101,
            102,
            104,
            106,
            108,
            110,
            112,
            114,
            116,
            118,
            120,
            122,
            124,
            126,
            128,
            130,
            132,
            134,
            136,
            138,
            140,
            142,
            144,
            146,
            148,
            150,
            152,
            155,
            158,
            161,
            164,
            167,
            170,
            173,
            176,
            179,
            182,
            185,
            188,
            191,
            194,
            197,
            200,
            203,
            207,
            211,
            215,
            219,
            223,
            227,
            231,
            235,
            239,
            243,
            247,
            251,
            255,
            260,
            265,
            270,
            275,
            280,
            285,
            290,
            295,
            300,
            305,
            311,
            317,
            323,
            329,
            335,
            341,
            347,
            353,
            359,
            366,
            373,
            380,
            387,
            394,
            401,
            408,
            416,
            424,
            432,
            440,
            448,
            456,
            465,
            474,
            483,
            492,
            501,
            510,
            520,
            530,
            540,
            550,
            560,
            571,
            582,
            593,
            604,
            615,
            627,
            639,
            651,
            663,
            676,
            689,
            702,
            715,
            729,
            743,
            757,
            771,
            786,
            801,
            816,
            832,
            848,
            864,
            881,
            898,
            915,
            933,
            951,
            969,
            988,
            1007,
            1026,
            1046,
            1066,
            1087,
            1108,
            1129,
            1151,
            1173,
            1196,
            1219,
            1243,
            1267,
            1292,
            1317,
            1343,
            1369,
            1396,
            1423,
            1451,
            1479,
            1508,
            1537,
            1567,
            1597,
            1628,
            1660,
            1692,
            1725,
            1759,
            1793,
            1828
        ];
    atomic_store(*globals_initialization_state_for_vp9_quant_common, 2);
}

