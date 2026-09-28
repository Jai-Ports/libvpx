VP8_BLOCK2LEFT: [25] u8;

VP8_BLOCK2ABOVE: [25] u8;

globals_initialization_state_for_blockd: u32;
initialize_globals_for_blockd :: () {
    {
        state := atomic_load(*globals_initialization_state_for_blockd);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_blockd, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_blockd) != 2 {}
            return;
        }
    }
    VP8_BLOCK2LEFT =
        u8.[
            0,
            0,
            0,
            0,
            1,
            1,
            1,
            1,
            2,
            2,
            2,
            2,
            3,
            3,
            3,
            3,
            4,
            4,
            5,
            5,
            6,
            6,
            7,
            7,
            8
        ];
    VP8_BLOCK2ABOVE =
        u8.[
            0,
            1,
            2,
            3,
            0,
            1,
            2,
            3,
            0,
            1,
            2,
            3,
            0,
            1,
            2,
            3,
            4,
            5,
            4,
            5,
            6,
            7,
            6,
            7,
            8
        ];
    atomic_store(*globals_initialization_state_for_blockd, 2);
}

