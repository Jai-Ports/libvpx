COUNT_TO_UPDATE_FACTOR_in_vp9_cost: [21] s32;

VP9_PROB_COST: [256] u16;

clip_pixel_in_vp9_cost :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_cost :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_cost :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_cost :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_cost :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_cost(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_cost(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_cost(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_cost :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_prob_in_vp9_cost :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_cost :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_cost(n0, DEN);
}

weighted_prob_in_vp9_cost :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_cost :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_cost(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_cost(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_cost :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_cost[COUNT];
        PROB := get_prob_in_vp9_cost(ct[0], DEN);
        return weighted_prob_in_vp9_cost(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

cost_branch256_in_vp9_cost :: (ct: *u32, p: Prob) -> u64 {
    return ((cast,no_check(u64) ct[0]) * cast(u64) VP9_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP9_PROB_COST[256 - cast(s32) p];
}

treed_cost_in_vp9_cost :: (tree: *Tree_Index, probs: *Prob, bits: s32, len: s32) -> s32 {
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

vp9_cost_tokens :: (costs: *s32, probs: *Prob, tree: *Tree_Index) {
    cost_in_vp9_cost(costs, tree, probs, 0, 0);
}

cost_in_vp9_cost :: (costs: *s32, tree: *Tree_Index, probs: *Prob, i: s32, c: s32) {
    PROB := probs[i / 2];

    for b: 0..cast(s32) 1 {
        CC := c + cast(s32) (VP9_PROB_COST[(ifx b != 0 then 256 - cast(s32) PROB else cast,no_check(s32) PROB)]);
        II := tree[i + b];

        if II <= 0 {
            costs[-(cast,no_check(s32) II)] = CC;
        } else {
            cost_in_vp9_cost(costs, tree, probs, cast,no_check(s32) II, CC);
        }
    }
}

vp9_cost_tokens_skip :: (costs: *s32, probs: *Prob, tree: *Tree_Index) {
    costs[-(cast,no_check(s32) tree[0])] = cast,no_check(s32) (VP9_PROB_COST[cast,no_check(s32) probs[0]]);
    cost_in_vp9_cost(costs, tree, probs, 2, 0);
}

globals_initialization_state_for_vp9_cost: u32;
initialize_globals_for_vp9_cost :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_cost);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_cost, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_cost) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_vp9_cost =
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
    VP9_PROB_COST =
        u16.[
            4096,
            4096,
            3584,
            3284,
            3072,
            2907,
            2772,
            2659,
            2560,
            2473,
            2395,
            2325,
            2260,
            2201,
            2147,
            2096,
            2048,
            2003,
            1961,
            1921,
            1883,
            1847,
            1813,
            1780,
            1748,
            1718,
            1689,
            1661,
            1635,
            1609,
            1584,
            1559,
            1536,
            1513,
            1491,
            1470,
            1449,
            1429,
            1409,
            1390,
            1371,
            1353,
            1335,
            1318,
            1301,
            1284,
            1268,
            1252,
            1236,
            1221,
            1206,
            1192,
            1177,
            1163,
            1149,
            1136,
            1123,
            1110,
            1097,
            1084,
            1072,
            1059,
            1047,
            1036,
            1024,
            1013,
            1001,
            990,
            979,
            968,
            958,
            947,
            937,
            927,
            917,
            907,
            897,
            887,
            878,
            868,
            859,
            850,
            841,
            832,
            823,
            814,
            806,
            797,
            789,
            780,
            772,
            764,
            756,
            748,
            740,
            732,
            724,
            717,
            709,
            702,
            694,
            687,
            680,
            673,
            665,
            658,
            651,
            644,
            637,
            631,
            624,
            617,
            611,
            604,
            598,
            591,
            585,
            578,
            572,
            566,
            560,
            554,
            547,
            541,
            535,
            530,
            524,
            518,
            512,
            506,
            501,
            495,
            489,
            484,
            478,
            473,
            467,
            462,
            456,
            451,
            446,
            441,
            435,
            430,
            425,
            420,
            415,
            410,
            405,
            400,
            395,
            390,
            385,
            380,
            375,
            371,
            366,
            361,
            356,
            352,
            347,
            343,
            338,
            333,
            329,
            324,
            320,
            316,
            311,
            307,
            302,
            298,
            294,
            289,
            285,
            281,
            277,
            273,
            268,
            264,
            260,
            256,
            252,
            248,
            244,
            240,
            236,
            232,
            228,
            224,
            220,
            216,
            212,
            209,
            205,
            201,
            197,
            194,
            190,
            186,
            182,
            179,
            175,
            171,
            168,
            164,
            161,
            157,
            153,
            150,
            146,
            143,
            139,
            136,
            132,
            129,
            125,
            122,
            119,
            115,
            112,
            109,
            105,
            102,
            99,
            95,
            92,
            89,
            86,
            82,
            79,
            76,
            73,
            70,
            66,
            63,
            60,
            57,
            54,
            51,
            48,
            45,
            42,
            38,
            35,
            32,
            29,
            26,
            23,
            20,
            18,
            15,
            12,
            9,
            6,
            3
        ];
    atomic_store(*globals_initialization_state_for_vp9_cost, 2);
}

