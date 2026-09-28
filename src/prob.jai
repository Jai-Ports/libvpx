// Generated directly from C by cpp_transpiler.
COUNT_TO_UPDATE_FACTOR: [21] s32;

NORM: [256] u8 #align 16;

clip_pixel :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_prob :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob(n0, DEN);
}

weighted_prob :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR[COUNT];
        PROB := get_prob(ct[0], DEN);
        return weighted_prob(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

tree_merge_probs :: (tree: *Tree_Index, pre_probs: *Prob, counts: *u32, probs: *Prob) {
    tree_merge_probs_impl(0, tree, pre_probs, counts, probs);
}

tree_merge_probs_impl :: (i: u32, tree: *Tree_Index, pre_probs: *Prob, counts: *u32, probs: *Prob) -> u32 {
    L := cast,no_check(s32) tree[i];
    LEFT_COUNT :=
        (ifx L <= 0 then counts[-L] else tree_merge_probs_impl(cast,no_check(u32) L, tree, pre_probs, counts, probs));
    R := cast,no_check(s32) tree[i + 1];
    RIGHT_COUNT :=
        (ifx R <= 0 then counts[-R] else tree_merge_probs_impl(cast,no_check(u32) R, tree, pre_probs, counts, probs));
    CT := u32.[ LEFT_COUNT, RIGHT_COUNT ];
    probs[i >> 1] = mode_mv_merge_probs(pre_probs[i >> 1], CT.data);
    return LEFT_COUNT + RIGHT_COUNT;
}

globals_initialization_state_for_prob: u32;
initialize_globals_for_prob :: () {
    {
        state := atomic_load(*globals_initialization_state_for_prob);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_prob, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_prob) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR =
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
    NORM =
        u8.[
            0,
            7,
            6,
            6,
            5,
            5,
            5,
            5,
            4,
            4,
            4,
            4,
            4,
            4,
            4,
            4,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            3,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            2,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0
        ];
    atomic_store(*globals_initialization_state_for_prob, 2);
}

Prob :: u8;

Tree_Index :: s8;

