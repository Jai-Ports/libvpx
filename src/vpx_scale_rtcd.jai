// Generated directly from C by cpp_transpiler.
lock: Pthread_Once_T;

scale_rtcd :: () {
    once(cast,no_check(#type () #c_call) setup_rtcd_internal);
}

setup_rtcd_internal :: () #c_call {
}

once :: (func: Once_Parameter_0_Type) {
    pthread_once(*lock, cast,no_check(#type () #c_call) (func));
}

globals_initialization_state_for_vpx_scale_rtcd: u32;
initialize_globals_for_vpx_scale_rtcd :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vpx_scale_rtcd);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vpx_scale_rtcd, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vpx_scale_rtcd) != 2 {}
            return;
        }
    }
    lock = 0;
    atomic_store(*globals_initialization_state_for_vpx_scale_rtcd, 2);
}

pthread_once :: (
    once_control: *Pthread_Once_T,
    init_routine: Once_Parameter_0_Type
) -> s32 #foreign System_Library_libc_so_6;

Pthread_Once_T :: s32;


Once_Parameter_0_Type :: #type () #c_call;
