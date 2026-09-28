// Generated directly from C by cpp_transpiler.
VP8_PROB_COST: [256] u32;

vp8_start_encode :: (bc: *Vp8_Writer, source: *u8, source_end: *u8) {
    bc.lowvalue = 0;
    bc.range = 255;
    bc.count = -24;
    bc.buffer = source;
    bc.buffer_end = source_end;
    bc.pos = 0;
}

vp8_encode_value :: (bc: *Vp8_Writer, data: s32, bits: s32) {
    bit := bits - 1;
    while bit >= 0 {
        vp8_encode_bool_in_boolhuff(bc, 1 & (data >> ((bit) & 31)), 0x80);
        bit -= 1;
    }
}

vp8_encode_bool_in_boolhuff :: (bc: *Vp8_Writer, bit: s32, probability: s32) {
    count := bc.count;
    range := bc.range;
    lowvalue := bc.lowvalue;

    split := 1 + ((range - 1) * cast,no_check(u32) probability) >> 8;

    range = split;

    if bit != 0 {
        lowvalue += split;
        range = bc.range - split;
    }

    shift := cast,no_check(s32) VP8_NORM[range];

    c_transpiler_compound_shl(*(range), (((cast,no_check(u32) shift) & 31)), u32, u32);
    count += shift;

    if count >= 0 {
        offset := shift - count;

        if lowvalue << (((offset - 1)) & 31) & 0x80000000 != 0 {
            x := cast,no_check(s32) (bc.pos - 1);

            while x >= 0 && bc.buffer[x] == 0xff {
                bc.buffer[x] = 0;
                x -= 1;
            }

            bc.buffer[x] = cast,no_check(u8) ((cast,no_check(s32) bc.buffer[x]) + 1);
        }

        validate_buffer_in_boolhuff(bc.buffer + bc.pos, 1, bc.buffer_end, bc.error);
        bc.buffer[bc.pos] = cast,no_check(u8) (lowvalue >> (((24 - offset)) & 31) & 0xff);
        bc.pos += 1;

        shift = count;
        lowvalue =
            cast,no_check(u32) (cast,no_check(s32) ((cast,no_check(u64) lowvalue) << ((offset) & 63) & 0xffffff));
        count -= 8;
    }

    c_transpiler_compound_shl(*(lowvalue), (((cast,no_check(u32) shift) & 31)), u32, u32);
    bc.count = count;
    bc.lowvalue = lowvalue;
    bc.range = range;
}

validate_buffer_in_boolhuff :: (start: *u8, len: u64, end: *u8, error: *Internal_Error_Info) -> s32 {
    if start + len > start && start + len < end {
        return 1;
    } else {
        internal_error(
            error,
            cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
            c_string("Truncated packet or corrupt partition ")
        );
    }

    return 0;
}

vp8_stop_encode :: (bc: *Vp8_Writer) {
    for i: 0..cast(s32) 32 - 1 {
        vp8_encode_bool_in_boolhuff(bc, 0, 128);
    }
}

globals_initialization_state_for_boolhuff: u32;
initialize_globals_for_boolhuff :: () {
    {
        state := atomic_load(*globals_initialization_state_for_boolhuff);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_boolhuff, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_boolhuff) != 2 {}
            return;
        }
    }
    VP8_PROB_COST =
        u32.[
            2047,
            2047,
            1791,
            1641,
            1535,
            1452,
            1385,
            1328,
            1279,
            1235,
            1196,
            1161,
            1129,
            1099,
            1072,
            1046,
            1023,
            1000,
            979,
            959,
            940,
            922,
            905,
            889,
            873,
            858,
            843,
            829,
            816,
            803,
            790,
            778,
            767,
            755,
            744,
            733,
            723,
            713,
            703,
            693,
            684,
            675,
            666,
            657,
            649,
            641,
            633,
            625,
            617,
            609,
            602,
            594,
            587,
            580,
            573,
            567,
            560,
            553,
            547,
            541,
            534,
            528,
            522,
            516,
            511,
            505,
            499,
            494,
            488,
            483,
            477,
            472,
            467,
            462,
            457,
            452,
            447,
            442,
            437,
            433,
            428,
            424,
            419,
            415,
            410,
            406,
            401,
            397,
            393,
            389,
            385,
            381,
            377,
            373,
            369,
            365,
            361,
            357,
            353,
            349,
            346,
            342,
            338,
            335,
            331,
            328,
            324,
            321,
            317,
            314,
            311,
            307,
            304,
            301,
            297,
            294,
            291,
            288,
            285,
            281,
            278,
            275,
            272,
            269,
            266,
            263,
            260,
            257,
            255,
            252,
            249,
            246,
            243,
            240,
            238,
            235,
            232,
            229,
            227,
            224,
            221,
            219,
            216,
            214,
            211,
            208,
            206,
            203,
            201,
            198,
            196,
            194,
            191,
            189,
            186,
            184,
            181,
            179,
            177,
            174,
            172,
            170,
            168,
            165,
            163,
            161,
            159,
            156,
            154,
            152,
            150,
            148,
            145,
            143,
            141,
            139,
            137,
            135,
            133,
            131,
            129,
            127,
            125,
            123,
            121,
            119,
            117,
            115,
            113,
            111,
            109,
            107,
            105,
            103,
            101,
            99,
            97,
            95,
            93,
            92,
            90,
            88,
            86,
            84,
            82,
            81,
            79,
            77,
            75,
            73,
            72,
            70,
            68,
            66,
            65,
            63,
            61,
            60,
            58,
            56,
            55,
            53,
            51,
            50,
            48,
            46,
            45,
            43,
            41,
            40,
            38,
            37,
            35,
            33,
            32,
            30,
            29,
            27,
            25,
            24,
            22,
            21,
            19,
            18,
            16,
            15,
            13,
            12,
            10,
            9,
            7,
            6,
            4,
            3,
            1,
            1
        ];
    atomic_store(*globals_initialization_state_for_boolhuff, 2);
}

