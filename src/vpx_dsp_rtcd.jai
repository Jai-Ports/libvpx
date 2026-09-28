lock_storage: Pthread_Once_T;

clip_pixel_in_vpx_dsp_rtcd :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vpx_dsp_rtcd :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vpx_dsp_rtcd :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vpx_dsp_rtcd :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vpx_dsp_rtcd :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vpx_dsp_rtcd(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vpx_dsp_rtcd(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vpx_dsp_rtcd(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vpx_dsp_rtcd :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_vpx_dsp_rtcd :: (FILTER: *s16) -> s32 {
    if (cast(s32) FILTER[0]) | cast(s32) FILTER[7] != 0 {
        return 8;
    }
    if (cast(s32) FILTER[1]) | cast(s32) FILTER[6] != 0 {
        return 6;
    }
    if (cast(s32) FILTER[2]) | cast(s32) FILTER[5] != 0 {
        return 4;
    }
    return 2;
}

dsp_rtcd :: () {
    once_in_vpx_dsp_rtcd(cast,no_check(#type () #c_call) setup_rtcd_internal_in_vpx_dsp_rtcd);
}

setup_rtcd_internal_in_vpx_dsp_rtcd :: () #c_call {
}

once_in_vpx_dsp_rtcd :: (func: Once_In_Vpx_Dsp_Rtcd_Parameter_0_Type) {
    pthread_once(*lock_storage, cast,no_check(#type () #c_call) (func));
}

globals_initialization_state_for_vpx_dsp_rtcd: u32;
initialize_globals_for_vpx_dsp_rtcd :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vpx_dsp_rtcd);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vpx_dsp_rtcd, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vpx_dsp_rtcd) != 2 {}
            return;
        }
    }
    lock_storage = 0;
    atomic_store(*globals_initialization_state_for_vpx_dsp_rtcd, 2);
}


Once_In_Vpx_Dsp_Rtcd_Parameter_0_Type :: #type () #c_call;
