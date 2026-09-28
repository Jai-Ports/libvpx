// Generated directly from C by cpp_transpiler.
VP8_MV_UPDATE_PROBS: [2] MV_CONTEXT;

VP8_DEFAULT_MV_CONTEXT: [2] MV_CONTEXT;

globals_initialization_state_for_entropymv: u32;
initialize_globals_for_entropymv :: () {
    {
        state := atomic_load(*globals_initialization_state_for_entropymv);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_entropymv, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_entropymv) != 2 {}
            return;
        }
    }
    VP8_MV_UPDATE_PROBS =
        MV_CONTEXT.[
            MV_CONTEXT.{prob = Vp8_Prob.[ 237, 246, 253, 253, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 250, 250, 252, 254, 254 ]},
            MV_CONTEXT.{prob = Vp8_Prob.[ 231, 243, 245, 253, 254, 254, 254, 254, 254, 254, 254, 254, 254, 254, 251, 251, 254, 254, 254 ]}
        ];
    VP8_DEFAULT_MV_CONTEXT =
        MV_CONTEXT.[
            MV_CONTEXT.{prob = Vp8_Prob.[ 162, 128, 225, 146, 172, 147, 214, 39, 156, 128, 129, 132, 75, 145, 178, 206, 239, 254, 254 ]},
            MV_CONTEXT.{prob = Vp8_Prob.[ 164, 128, 204, 170, 119, 235, 140, 230, 228, 128, 130, 130, 74, 148, 180, 203, 236, 254, 254 ]}
        ];
    atomic_store(*globals_initialization_state_for_entropymv, 2);
}

