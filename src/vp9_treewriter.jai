COUNT_TO_UPDATE_FACTOR_in_vp9_treewriter: [21] s32;

clip_pixel_in_vp9_treewriter :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_treewriter :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_treewriter :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_treewriter :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_treewriter :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_treewriter(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_treewriter(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_treewriter(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_treewriter :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_prob_in_vp9_treewriter :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_treewriter :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_treewriter(n0, DEN);
}

weighted_prob_in_vp9_treewriter :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_treewriter :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_treewriter(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_treewriter(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_treewriter :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_treewriter[COUNT];
        PROB := get_prob_in_vp9_treewriter(ct[0], DEN);
        return weighted_prob_in_vp9_treewriter(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

write_in_vp9_treewriter :: (br: *Writer, bit: s32, probability: s32) {
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

write_bit_in_vp9_treewriter :: (w: *Writer, bit: s32) {
    write_in_vp9_treewriter(w, bit, 128);
}

write_literal_in_vp9_treewriter :: (w: *Writer, data: s32, bits: s32) {
    bit := bits - 1;
    while bit >= 0 {
        write_bit_in_vp9_treewriter(w, 1 & (data >> ((bit) & 31)));
        bit -= 1;
    }
}

vp9_tree_probs_from_distribution :: (tree: *Tree_Index, branch_ct: *[2] u32, num_events: *u32) {
    convert_distribution(0, tree, branch_ct, num_events);
}

convert_distribution :: (i: u32, tree: *Tree_Index, branch_ct: *[2] u32, num_events: *u32) -> u32 {
    left: u32 = ifx tree[i] <= 0
        then num_events[-(cast,no_check(s32) tree[i])]
        else convert_distribution(cast,no_check(u32) tree[i], tree, branch_ct, num_events);

    right: u32 = ifx tree[i + 1] <= 0
        then num_events[-(cast,no_check(s32) tree[i + 1])]
        else convert_distribution(cast,no_check(u32) tree[i + 1], tree, branch_ct, num_events);

    branch_ct[i >> 1][0] = left;
    branch_ct[i >> 1][1] = right;
    return left + right;
}

vp9_tokens_from_tree :: (tokens: *Vp9_Token, tree: *Tree_Index) {
    tree2tok_in_vp9_treewriter(tokens, tree, 0, 0, 0);
}

tree2tok_in_vp9_treewriter :: (tokens: *Vp9_Token, tree: *Tree_Index, i: s32, v: s32, l: s32) {
    v += v;
    l += 1;

    while true {
        {
            J := tree[c_transpiler_post_increment(*(i))];
            if J <= 0 {
                tokens[-(cast,no_check(s32) J)].value = v;
                tokens[-(cast,no_check(s32) J)].len = l;
            } else {
                tree2tok_in_vp9_treewriter(tokens, tree, cast,no_check(s32) J, v, l);
            }
        }
        if c_transpiler_pre_increment(*(v)) & 1 == 0 break;
    }
}

vp9_write_tree_in_vp9_treewriter :: (w: *Writer, tree: *Tree_Index, probs: *Prob, bits: s32, len: s32, i: Tree_Index) {
    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            write_in_vp9_treewriter(w, BIT, cast,no_check(s32) probs[(cast(s32) i) >> 1]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }
}

vp9_write_token_in_vp9_treewriter :: (w: *Writer, tree: *Tree_Index, probs: *Prob, token: *Vp9_Token) {
    vp9_write_tree_in_vp9_treewriter(w, tree, probs, token.value, token.len, 0);
}

globals_initialization_state_for_vp9_treewriter: u32;
initialize_globals_for_vp9_treewriter :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_treewriter);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_treewriter, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_treewriter) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_vp9_treewriter =
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
    atomic_store(*globals_initialization_state_for_vp9_treewriter, 2);
}

