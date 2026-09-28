// Generated directly from C by cpp_transpiler.
COUNT_TO_UPDATE_FACTOR_storage: [21] s32;

clip_pixel_in_bitwriter :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_bitwriter :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_bitwriter :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_bitwriter :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_bitwriter :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_bitwriter(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_bitwriter(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_bitwriter(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_bitwriter :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_prob_in_bitwriter :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_bitwriter :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_bitwriter(n0, DEN);
}

weighted_prob_in_bitwriter :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_bitwriter :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_bitwriter(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_bitwriter(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_bitwriter :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_storage[COUNT];
        PROB := get_prob_in_bitwriter(ct[0], DEN);
        return weighted_prob_in_bitwriter(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

start_encode :: (br: *Writer, source: *u8, size: u64) {
    br.lowvalue = 0;
    br.range = 255;
    br.count = -24;
    br.error = 0;
    br.pos = 0;

    if size > 2147483647 {
        size = 2147483647;
    }
    br.size = cast,no_check(u32) size;
    br.buffer = source;
    write_bit(br, 0);
}

write_bit :: (w: *Writer, bit: s32) {
    write(w, bit, 128);
}

write :: (br: *Writer, bit: s32, probability: s32) {
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

stop_encode :: (br: *Writer) -> s32 {
    for i: 0..cast(s32) 32 - 1 {
        write_bit(br, 0);
    }

    if br.error == 0 && (cast(s32) br.buffer[br.pos - 1]) & 0xe0 == 0xc0 {
        if br.pos < br.size {
            br.buffer[br.pos] = 0;
            br.pos += 1;
        } else {
            br.error = 1;
        }
    }

    if br.error != 0 {
        return -1;
    }
    return 0;
}

write_literal :: (w: *Writer, data: s32, bits: s32) {
    bit := bits - 1;
    while bit >= 0 {
        write_bit(w, 1 & (data >> ((bit) & 31)));
        bit -= 1;
    }
}

globals_initialization_state_for_bitwriter: u32;
initialize_globals_for_bitwriter :: () {
    {
        state := atomic_load(*globals_initialization_state_for_bitwriter);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_bitwriter, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_bitwriter) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_storage =
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
    atomic_store(*globals_initialization_state_for_bitwriter, 2);
}

Writer :: struct {
    lowvalue: u32;
    range: u32;
    count: s32;
    error: s32;
    pos: u32;
    size: u32;
    buffer: *u8;
}

