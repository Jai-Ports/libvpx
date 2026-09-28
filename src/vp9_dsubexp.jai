// Generated directly from C by cpp_transpiler.
COUNT_TO_UPDATE_FACTOR_in_vp9_dsubexp: [21] s32;

inv_map_table: [255] u8;

clip_pixel_in_vp9_dsubexp :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_dsubexp :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_dsubexp :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_dsubexp :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_dsubexp :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_dsubexp(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_dsubexp(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_dsubexp(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_dsubexp :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_prob_in_vp9_dsubexp :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_dsubexp :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_dsubexp(n0, DEN);
}

weighted_prob_in_vp9_dsubexp :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_dsubexp :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_dsubexp(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_dsubexp(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_dsubexp :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_dsubexp[COUNT];
        PROB := get_prob_in_vp9_dsubexp(ct[0], DEN);
        return weighted_prob_in_vp9_dsubexp(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_lsb_in_vp9_dsubexp :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_dsubexp :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_dsubexp :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_dsubexp(num_values) + 1 else 0;
}

get_band_translate_in_vp9_dsubexp :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_dsubexp :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_dsubexp :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_dsubexp(above_ec, left_ec);
}

codec_control_vp8_set_reference_in_vp9_dsubexp :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *Ref_Frame_T) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_copy_reference_in_vp9_dsubexp :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Ref_Frame_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_set_postproc_in_vp9_dsubexp :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Vp8_Postproc_Cfg_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_get_reference_in_vp9_dsubexp :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Vp9_Ref_Frame_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_last_ref_updates_in_vp9_dsubexp :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_frame_corrupted_in_vp9_dsubexp :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_last_ref_used_in_vp9_dsubexp :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vpxd_set_decryptor_in_vp9_dsubexp :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Decrypt_Init
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_set_decryptor_in_vp9_dsubexp :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Decrypt_Init
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_frame_size_in_vp9_dsubexp :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_display_size_in_vp9_dsubexp :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_bit_depth_in_vp9_dsubexp :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *u32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_set_byte_alignment_in_vp9_dsubexp :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_invert_tile_decode_order_in_vp9_dsubexp :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_set_skip_loop_filter_in_vp9_dsubexp :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_decode_svc_spatial_layer_in_vp9_dsubexp :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vpxd_get_last_quantizer_in_vp9_dsubexp :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_set_row_mt_in_vp9_dsubexp :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_set_loop_filter_opt_in_vp9_dsubexp :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

reader_has_error_in_vp9_dsubexp :: (r: *Reader) -> s32 {
    if r.count > (cast,no_check(s32) (cast(u64) size_of(BD_VALUE))) * 8 && r.count < 0x40000000 {
        return 1;
    }
    return 0;
}

read_in_vp9_dsubexp :: (r: *Reader, prob: s32) -> s32 {
    bit: u32 = 0;

    split := ((r.range * cast,no_check(u32) prob) + cast,no_check(u32) (256 - prob)) >> 8;

    if r.count < 0 {
        reader_fill(r);
    }

    value := r.value;
    count := r.count;

    bigsplit :=
        (cast,no_check(BD_VALUE) split) << ((((cast,no_check(s32) (cast(u64) size_of(BD_VALUE))) * 8 -
            8)) & 63);

    range := split;

    if value >= bigsplit {
        range = r.range - split;
        value = value - bigsplit;
        bit = 1;
    }

    {
        SHIFT: u8 = NORM[cast,no_check(u8) range];
        c_transpiler_compound_shl(*(range), (((cast,no_check(u32) (cast,no_check(s32) SHIFT)) & 31)), u32, u32);
        c_transpiler_compound_shl(*(value), (((cast,no_check(BD_VALUE) (cast,no_check(s32) SHIFT)) & 63)), BD_VALUE, BD_VALUE);
        count -= cast,no_check(s32) SHIFT;
    }
    r.value = value;
    r.count = count;
    r.range = range;

    return cast,no_check(s32) bit;
}

read_bit_in_vp9_dsubexp :: (r: *Reader) -> s32 {
    return read_in_vp9_dsubexp(r, 128);
}

read_literal_in_vp9_dsubexp :: (r: *Reader, bits: s32) -> s32 {
    literal: s32 = 0;

    bit := bits - 1;
    while bit >= 0 {
        literal |= read_bit_in_vp9_dsubexp(r) << ((bit) & 31);
        bit -= 1;
    }

    return literal;
}

read_tree_in_vp9_dsubexp :: (r: *Reader, tree: *Tree_Index, probs: *Prob) -> s32 {
    i: Tree_Index = 0;

    while (ifx true { assignment_1: Tree_Index = cast,no_check(Tree_Index) (tree[(cast(s32) i) + read_in_vp9_dsubexp(r, cast,no_check(s32) probs[(cast(s32) i) >> 1])]); (i) = assignment_1; assignment_1; }) > 0 {
        continue;
    }

    return -(cast,no_check(s32) i);
}

vp9_diff_update_prob :: (r: *Reader, p: *Prob) {
    if read_in_vp9_dsubexp(r, 252) != 0 {
        DELP := decode_term_subexp(r);
        p.* = cast,no_check(Prob) inv_remap_prob(DELP, cast,no_check(s32) p.*);
    }
}

decode_term_subexp :: (r: *Reader) -> s32 {
    if read_bit_in_vp9_dsubexp(r) == 0 {
        return read_literal_in_vp9_dsubexp(r, 4);
    }
    if read_bit_in_vp9_dsubexp(r) == 0 {
        return read_literal_in_vp9_dsubexp(r, 4) + 16;
    }
    if read_bit_in_vp9_dsubexp(r) == 0 {
        return read_literal_in_vp9_dsubexp(r, 5) + 32;
    }
    return decode_uniform(r) + 64;
}

decode_uniform :: (r: *Reader) -> s32 {
    L: s32 = 8;
    M := (cast(s32) 1) << ((L) & 31) - 191;
    V := read_literal_in_vp9_dsubexp(r, L - 1);
    return ifx V < M then V else V << 1 - M + read_bit_in_vp9_dsubexp(r);
}

inv_remap_prob :: (v: s32, m: s32) -> s32 {

    v = cast,no_check(s32) inv_map_table[v];
    m -= 1;
    if m << 1 <= 255 {
        return 1 + inv_recenter_nonneg(v, m);
    } else {
        return 255 - inv_recenter_nonneg(v, (cast,no_check(s32) ((255 - 1))) - m);
    }
}

inv_recenter_nonneg :: (v: s32, m: s32) -> s32 {
    if v > 2 * m {
        return v;
    }

    return ifx v & 1 != 0 then m - (v + 1) >> 1 else m + v >> 1;
}

globals_initialization_state_for_vp9_dsubexp: u32;
initialize_globals_for_vp9_dsubexp :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_dsubexp);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_dsubexp, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_dsubexp) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_vp9_dsubexp =
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
    inv_map_table =
        u8.[
            7,
            20,
            33,
            46,
            59,
            72,
            85,
            98,
            111,
            124,
            137,
            150,
            163,
            176,
            189,
            202,
            215,
            228,
            241,
            254,
            1,
            2,
            3,
            4,
            5,
            6,
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
            110,
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
            122,
            123,
            125,
            126,
            127,
            128,
            129,
            130,
            131,
            132,
            133,
            134,
            135,
            136,
            138,
            139,
            140,
            141,
            142,
            143,
            144,
            145,
            146,
            147,
            148,
            149,
            151,
            152,
            153,
            154,
            155,
            156,
            157,
            158,
            159,
            160,
            161,
            162,
            164,
            165,
            166,
            167,
            168,
            169,
            170,
            171,
            172,
            173,
            174,
            175,
            177,
            178,
            179,
            180,
            181,
            182,
            183,
            184,
            185,
            186,
            187,
            188,
            190,
            191,
            192,
            193,
            194,
            195,
            196,
            197,
            198,
            199,
            200,
            201,
            203,
            204,
            205,
            206,
            207,
            208,
            209,
            210,
            211,
            212,
            213,
            214,
            216,
            217,
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
            229,
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
            253
        ];
    atomic_store(*globals_initialization_state_for_vp9_dsubexp, 2);
}

