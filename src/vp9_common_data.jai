Partition_Context_Lookup_Entry_in_vp9_common_data :: struct {
    above: PARTITION_CONTEXT;
    left: PARTITION_CONTEXT;
}

B_WIDTH_LOG2_LOOKUP: [13] u8;

B_HEIGHT_LOG2_LOOKUP: [13] u8;

MI_WIDTH_LOG2_LOOKUP: [13] u8;

NUM_8X8_BLOCKS_WIDE_LOOKUP: [13] u8;

NUM_8X8_BLOCKS_HIGH_LOOKUP: [13] u8;

NUM_4X4_BLOCKS_HIGH_LOOKUP: [13] u8;

NUM_4X4_BLOCKS_WIDE_LOOKUP: [13] u8;

SIZE_GROUP_LOOKUP: [13] u8;

NUM_PELS_LOG2_LOOKUP: [13] u8;

PARTITION_LOOKUP: [5] [13] PARTITION_TYPE;

SUBSIZE_LOOKUP: [4] [13] BLOCK_SIZE;

MAX_TXSIZE_LOOKUP: [13] TX_SIZE;

TXSIZE_TO_BSIZE: [4] BLOCK_SIZE;

TX_MODE_TO_BIGGEST_TX_SIZE: [5] TX_SIZE;

SS_SIZE_LOOKUP: [13] [2] [2] BLOCK_SIZE;

UV_TXSIZE_LOOKUP: [13] [4] [2] [2] TX_SIZE;

PARTITION_CONTEXT_LOOKUP: [13] Partition_Context_Lookup_Entry_in_vp9_common_data;

clip_pixel_in_vp9_common_data :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_common_data :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_common_data :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_common_data :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_common_data :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_common_data(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_common_data(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_common_data(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_common_data :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

globals_initialization_state_for_vp9_common_data: u32;
initialize_globals_for_vp9_common_data :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_common_data);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_common_data, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_common_data) != 2 {}
            return;
        }
    }
    B_WIDTH_LOG2_LOOKUP =
        u8.[
            0,
            0,
            1,
            1,
            1,
            2,
            2,
            2,
            3,
            3,
            3,
            4,
            4
        ];
    B_HEIGHT_LOG2_LOOKUP =
        u8.[
            0,
            1,
            0,
            1,
            2,
            1,
            2,
            3,
            2,
            3,
            4,
            3,
            4
        ];
    NUM_4X4_BLOCKS_WIDE_LOOKUP =
        u8.[
            1,
            1,
            2,
            2,
            2,
            4,
            4,
            4,
            8,
            8,
            8,
            16,
            16
        ];
    NUM_4X4_BLOCKS_HIGH_LOOKUP =
        u8.[
            1,
            2,
            1,
            2,
            4,
            2,
            4,
            8,
            4,
            8,
            16,
            8,
            16
        ];
    MI_WIDTH_LOG2_LOOKUP =
        u8.[
            0,
            0,
            0,
            0,
            0,
            1,
            1,
            1,
            2,
            2,
            2,
            3,
            3
        ];
    NUM_8X8_BLOCKS_WIDE_LOOKUP =
        u8.[
            1,
            1,
            1,
            1,
            1,
            2,
            2,
            2,
            4,
            4,
            4,
            8,
            8
        ];
    NUM_8X8_BLOCKS_HIGH_LOOKUP =
        u8.[
            1,
            1,
            1,
            1,
            2,
            1,
            2,
            4,
            2,
            4,
            8,
            4,
            8
        ];
    SIZE_GROUP_LOOKUP =
        u8.[
            0,
            0,
            0,
            1,
            1,
            1,
            2,
            2,
            2,
            3,
            3,
            3,
            3
        ];
    NUM_PELS_LOG2_LOOKUP =
        u8.[
            4,
            5,
            5,
            6,
            7,
            7,
            8,
            9,
            9,
            10,
            11,
            11,
            12
        ];
    PARTITION_LOOKUP =
        [13] PARTITION_TYPE.[
            PARTITION_TYPE.[ cast,no_check(PARTITION_TYPE) PARTITION_NONE, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID ],
            PARTITION_TYPE.[ cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_VERT, cast,no_check(PARTITION_TYPE) PARTITION_HORZ, cast,no_check(PARTITION_TYPE) PARTITION_NONE, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID ],
            PARTITION_TYPE.[ cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_VERT, cast,no_check(PARTITION_TYPE) PARTITION_HORZ, cast,no_check(PARTITION_TYPE) PARTITION_NONE, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID ],
            PARTITION_TYPE.[ cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_VERT, cast,no_check(PARTITION_TYPE) PARTITION_HORZ, cast,no_check(PARTITION_TYPE) PARTITION_NONE, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID, cast,no_check(PARTITION_TYPE) PARTITION_INVALID ],
            PARTITION_TYPE.[ cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_SPLIT, cast,no_check(PARTITION_TYPE) PARTITION_VERT, cast,no_check(PARTITION_TYPE) PARTITION_HORZ, cast,no_check(PARTITION_TYPE) PARTITION_NONE ]
        ];
    SUBSIZE_LOOKUP =
        [13] BLOCK_SIZE.[
            BLOCK_SIZE.[ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ],
            BLOCK_SIZE.[ 13, 13, 13, 2, 13, 13, 5, 13, 13, 8, 13, 13, 11 ],
            BLOCK_SIZE.[ 13, 13, 13, 1, 13, 13, 4, 13, 13, 7, 13, 13, 10 ],
            BLOCK_SIZE.[ 13, 13, 13, 0, 13, 13, 3, 13, 13, 6, 13, 13, 9 ]
        ];
    MAX_TXSIZE_LOOKUP =
        TX_SIZE.[
            0,
            0,
            0,
            1,
            1,
            1,
            2,
            2,
            2,
            3,
            3,
            3,
            3
        ];
    TXSIZE_TO_BSIZE = BLOCK_SIZE.[ 0, 3, 6, 9 ];
    TX_MODE_TO_BIGGEST_TX_SIZE =
        TX_SIZE.[
            0,
            1,
            2,
            3,
            3
        ];
    SS_SIZE_LOOKUP =
        [2] [2] BLOCK_SIZE.[
            [2] BLOCK_SIZE.[ BLOCK_SIZE.[ 0, 13 ], BLOCK_SIZE.[ 13, 13 ] ],
            [2] BLOCK_SIZE.[ BLOCK_SIZE.[ 1, 0 ], BLOCK_SIZE.[ 13, 13 ] ],
            [2] BLOCK_SIZE.[ BLOCK_SIZE.[ 2, 13 ], BLOCK_SIZE.[ 0, 13 ] ],
            [2] BLOCK_SIZE.[ BLOCK_SIZE.[ 3, 2 ], BLOCK_SIZE.[ 1, 0 ] ],
            [2] BLOCK_SIZE.[ BLOCK_SIZE.[ 4, 3 ], BLOCK_SIZE.[ 13, 1 ] ],
            [2] BLOCK_SIZE.[ BLOCK_SIZE.[ 5, 13 ], BLOCK_SIZE.[ 3, 2 ] ],
            [2] BLOCK_SIZE.[ BLOCK_SIZE.[ 6, 5 ], BLOCK_SIZE.[ 4, 3 ] ],
            [2] BLOCK_SIZE.[ BLOCK_SIZE.[ 7, 6 ], BLOCK_SIZE.[ 13, 4 ] ],
            [2] BLOCK_SIZE.[ BLOCK_SIZE.[ 8, 13 ], BLOCK_SIZE.[ 6, 5 ] ],
            [2] BLOCK_SIZE.[ BLOCK_SIZE.[ 9, 8 ], BLOCK_SIZE.[ 7, 6 ] ],
            [2] BLOCK_SIZE.[ BLOCK_SIZE.[ 10, 9 ], BLOCK_SIZE.[ 13, 7 ] ],
            [2] BLOCK_SIZE.[ BLOCK_SIZE.[ 11, 13 ], BLOCK_SIZE.[ 9, 8 ] ],
            [2] BLOCK_SIZE.[ BLOCK_SIZE.[ 12, 11 ], BLOCK_SIZE.[ 10, 9 ] ]
        ];
    UV_TXSIZE_LOOKUP =
        [4] [2] [2] TX_SIZE.[
            [2] [2] TX_SIZE.[ [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ] ],
            [2] [2] TX_SIZE.[ [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ] ],
            [2] [2] TX_SIZE.[ [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ] ],
            [2] [2] TX_SIZE.[ [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 1, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 1, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 1, 0 ], TX_SIZE.[ 0, 0 ] ] ],
            [2] [2] TX_SIZE.[ [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 1, 1 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 1, 1 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 1, 1 ], TX_SIZE.[ 0, 0 ] ] ],
            [2] [2] TX_SIZE.[ [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 1, 0 ], TX_SIZE.[ 1, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 1, 0 ], TX_SIZE.[ 1, 1 ] ], [2] TX_SIZE.[ TX_SIZE.[ 1, 0 ], TX_SIZE.[ 1, 1 ] ] ],
            [2] [2] TX_SIZE.[ [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 1, 1 ], TX_SIZE.[ 1, 1 ] ], [2] TX_SIZE.[ TX_SIZE.[ 2, 1 ], TX_SIZE.[ 1, 1 ] ], [2] TX_SIZE.[ TX_SIZE.[ 2, 1 ], TX_SIZE.[ 1, 1 ] ] ],
            [2] [2] TX_SIZE.[ [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 1, 1 ], TX_SIZE.[ 1, 1 ] ], [2] TX_SIZE.[ TX_SIZE.[ 2, 2 ], TX_SIZE.[ 1, 1 ] ], [2] TX_SIZE.[ TX_SIZE.[ 2, 2 ], TX_SIZE.[ 1, 1 ] ] ],
            [2] [2] TX_SIZE.[ [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 1, 1 ], TX_SIZE.[ 1, 1 ] ], [2] TX_SIZE.[ TX_SIZE.[ 2, 1 ], TX_SIZE.[ 2, 1 ] ], [2] TX_SIZE.[ TX_SIZE.[ 2, 1 ], TX_SIZE.[ 2, 1 ] ] ],
            [2] [2] TX_SIZE.[ [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 1, 1 ], TX_SIZE.[ 1, 1 ] ], [2] TX_SIZE.[ TX_SIZE.[ 2, 2 ], TX_SIZE.[ 2, 2 ] ], [2] TX_SIZE.[ TX_SIZE.[ 3, 2 ], TX_SIZE.[ 2, 2 ] ] ],
            [2] [2] TX_SIZE.[ [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 1, 1 ], TX_SIZE.[ 1, 1 ] ], [2] TX_SIZE.[ TX_SIZE.[ 2, 2 ], TX_SIZE.[ 2, 2 ] ], [2] TX_SIZE.[ TX_SIZE.[ 3, 3 ], TX_SIZE.[ 2, 2 ] ] ],
            [2] [2] TX_SIZE.[ [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 1, 1 ], TX_SIZE.[ 1, 1 ] ], [2] TX_SIZE.[ TX_SIZE.[ 2, 2 ], TX_SIZE.[ 2, 2 ] ], [2] TX_SIZE.[ TX_SIZE.[ 3, 2 ], TX_SIZE.[ 3, 2 ] ] ],
            [2] [2] TX_SIZE.[ [2] TX_SIZE.[ TX_SIZE.[ 0, 0 ], TX_SIZE.[ 0, 0 ] ], [2] TX_SIZE.[ TX_SIZE.[ 1, 1 ], TX_SIZE.[ 1, 1 ] ], [2] TX_SIZE.[ TX_SIZE.[ 2, 2 ], TX_SIZE.[ 2, 2 ] ], [2] TX_SIZE.[ TX_SIZE.[ 3, 3 ], TX_SIZE.[ 3, 3 ] ] ]
        ];
    PARTITION_CONTEXT_LOOKUP =
        Partition_Context_Lookup_Entry_in_vp9_common_data.[
            Partition_Context_Lookup_Entry_in_vp9_common_data.{above = 15, left = 15},
            Partition_Context_Lookup_Entry_in_vp9_common_data.{above = 15, left = 14},
            Partition_Context_Lookup_Entry_in_vp9_common_data.{above = 14, left = 15},
            Partition_Context_Lookup_Entry_in_vp9_common_data.{above = 14, left = 14},
            Partition_Context_Lookup_Entry_in_vp9_common_data.{above = 14, left = 12},
            Partition_Context_Lookup_Entry_in_vp9_common_data.{above = 12, left = 14},
            Partition_Context_Lookup_Entry_in_vp9_common_data.{above = 12, left = 12},
            Partition_Context_Lookup_Entry_in_vp9_common_data.{above = 12, left = 8},
            Partition_Context_Lookup_Entry_in_vp9_common_data.{above = 8, left = 12},
            Partition_Context_Lookup_Entry_in_vp9_common_data.{above = 8, left = 8},
            Partition_Context_Lookup_Entry_in_vp9_common_data.{above = 8, left = 0},
            Partition_Context_Lookup_Entry_in_vp9_common_data.{above = 0, left = 8},
            Partition_Context_Lookup_Entry_in_vp9_common_data.{above = 0, left = 0}
        ];
    atomic_store(*globals_initialization_state_for_vp9_common_data, 2);
}

