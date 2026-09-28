// Generated directly from C by cpp_transpiler.
VP8_MODE_CONTEXTS: [6] [4] s32;

globals_initialization_state_for_modecont: u32;
initialize_globals_for_modecont :: () {
    {
        state := atomic_load(*globals_initialization_state_for_modecont);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_modecont, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_modecont) != 2 {}
            return;
        }
    }
    VP8_MODE_CONTEXTS =
        [4] s32.[
            s32.[ 7, 1, 1, 143 ],
            s32.[ 14, 18, 14, 107 ],
            s32.[ 135, 64, 57, 68 ],
            s32.[ 60, 56, 128, 65 ],
            s32.[ 159, 134, 128, 34 ],
            s32.[ 234, 188, 128, 28 ]
        ];
    atomic_store(*globals_initialization_state_for_modecont, 2);
}

