lock_in_rtcd: Pthread_Once_T;

vp8_rtcd :: () {
    once_in_rtcd(cast,no_check(#type () #c_call) setup_rtcd_internal_in_rtcd);
}

setup_rtcd_internal_in_rtcd :: () #c_call {
}

once_in_rtcd :: (func: Once_In_Rtcd_Parameter_0_Type) {
    pthread_once(*lock_in_rtcd, cast,no_check(#type () #c_call) (func));
}

globals_initialization_state_for_rtcd: u32;
initialize_globals_for_rtcd :: () {
    {
        state := atomic_load(*globals_initialization_state_for_rtcd);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_rtcd, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_rtcd) != 2 {}
            return;
        }
    }
    lock_in_rtcd = 0;
    atomic_store(*globals_initialization_state_for_rtcd, 2);
}


Once_In_Rtcd_Parameter_0_Type :: #type () #c_call;
