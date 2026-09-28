CFG: *s8;

codec_build_config :: () -> *s8 {
    return CFG;
}

globals_initialization_state_for_vpx_config: u32;
initialize_globals_for_vpx_config :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vpx_config);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vpx_config, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vpx_config) != 2 {}
            return;
        }
    }
    CFG = c_string("--target=generic-gnu");
    atomic_store(*globals_initialization_state_for_vpx_config, 2);
}

