Proba_Array :: *[3] [11] u8;

K_ZIGZAG: [16] u8;

K_BANDS: [17] u8;

K_CAT3456: [4] *u8;

K_CAT6: [12] u8;

K_CAT5: [6] u8;

K_CAT4: [5] u8;

K_CAT3: [4] u8;

vp8_set_reference_value_in_detokenize :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_detokenize :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_detokenize :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_detokenize :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_d_get_last_ref_updates_value :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_d_get_frame_corrupted_value :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_d_get_last_ref_used_value :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

d_set_decryptor_value :: (args: *Va_List_Tag) -> *Decrypt_Init {
    return c_transpiler_va_arg(cast(*void) (args), *Decrypt_Init);
}

vp8_d_set_decryptor_value :: (args: *Va_List_Tag) -> *Decrypt_Init {
    return c_transpiler_va_arg(cast(*void) (args), *Decrypt_Init);
}

vp9_d_get_frame_size_value :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_d_get_display_size_value :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_d_get_bit_depth_value :: (args: *Va_List_Tag) -> *u32 {
    return c_transpiler_va_arg(cast(*void) (args), *u32);
}

vp9_set_byte_alignment_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_invert_tile_decode_order_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_set_skip_loop_filter_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_decode_svc_spatial_layer_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

d_get_last_quantizer_value :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_d_set_row_mt_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_d_set_loop_filter_opt_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8dx_decode_bool_in_detokenize :: (br: *BOOL_DECODER, probability: s32) -> s32 {
    bit: u32 = 0;

    split := 1 + ((br.range - 1) * cast,no_check(u32) probability) >> 8;

    if br.count < 0 {
        (cast,no_check(#type (_: *BOOL_DECODER)) (cast(*void) vp8dx_bool_decoder_fill))(br);
    }

    value := br.value;
    count := br.count;

    bigsplit :=
        (cast,no_check(VP8_BD_VALUE) split) << ((((cast,no_check(s32) (cast(u64) size_of(VP8_BD_VALUE))) * 8 -
            8)) & 63);

    range := split;

    if value >= bigsplit {
        range = br.range - split;
        value = value - bigsplit;
        bit = 1;
    }

    {
        SHIFT := VP8_NORM[cast,no_check(u8) range];
        c_transpiler_compound_shl(*(range), (((cast,no_check(u32) (cast,no_check(s32) SHIFT)) & 31)), u32, u32);
        c_transpiler_compound_shl(*(value), (((cast,no_check(VP8_BD_VALUE) (cast,no_check(s32) SHIFT)) & 63)), VP8_BD_VALUE, VP8_BD_VALUE);
        count -= cast,no_check(s32) SHIFT;
    }
    br.value = value;
    br.count = count;
    br.range = range;

    return cast,no_check(s32) bit;
}

vp8_decode_value_in_detokenize :: (br: *BOOL_DECODER, bits: s32) -> s32 {
    z: s32 = 0;

    bit := bits - 1;
    while bit >= 0 {
        z |= vp8dx_decode_bool_in_detokenize(br, 0x80) << ((bit) & 31);
        bit -= 1;
    }

    return z;
}

vp8dx_bool_error_in_detokenize :: (br: *BOOL_DECODER) -> s32 {
    if br.count > (cast,no_check(s32) (cast(u64) size_of(VP8_BD_VALUE))) * 8 && br.count < 0x40000000 {
        return 1;
    }

    return 0;
}

vp8_treed_read_in_detokenize :: (R: *Vp8_Reader_in_treereader, t: *Vp8_Tree_Index, P: *Vp8_Prob) -> s32 {
    i: Vp8_Tree_Index = 0;

    while (ifx true { assignment_1: Vp8_Tree_Index = cast,no_check(Vp8_Tree_Index) (t[(cast(s32) i) + vp8dx_decode_bool_in_detokenize(R, cast,no_check(s32) P[(cast(s32) i) >> 1])]); (i) = assignment_1; assignment_1; }) > 0 {
    }

    return -(cast,no_check(s32) i);
}

vp8_sem_wait_in_detokenize :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_2: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_2; assignment_2; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init_in_detokenize :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release_in_detokenize :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

atomic_load_acquire_in_detokenize :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_atomic_spin_wait_in_detokenize :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire_in_detokenize(last_row_current_mb_col) - NSYNC {
    }
}

vp8_reset_mb_tokens_context :: (x: *MACROBLOCKD_in_blockd) {
    a_ctx := cast(*ENTROPY_CONTEXT) x.above_context;
    l_ctx := cast(*ENTROPY_CONTEXT) x.left_context;

    fill_memory(a_ctx, 0, size_of(ENTROPY_CONTEXT_PLANES) - 1);
    fill_memory(l_ctx, 0, size_of(ENTROPY_CONTEXT_PLANES) - 1);

    if x.mode_info_context.mbmi.is_4x4 == 0 {
        l_ctx[8] = 0;
        a_ctx[8] = l_ctx[8];
    }
}

vp8_decode_mb_tokens :: (dx: *VP8_D_COMP, x: *MACROBLOCKD_in_blockd) -> s32 {
    bc := cast(*BOOL_DECODER) x.current_bc;
    FC := *dx.common.fc;
    eobs := x.eobs.data;

    nonzeros: s32 = ---;
    eobtotal: s32 = 0;

    coef_probs: Proba_Array = ---;
    a_ctx := cast(*ENTROPY_CONTEXT) x.above_context;
    l_ctx := cast(*ENTROPY_CONTEXT) x.left_context;
    a: *ENTROPY_CONTEXT = ---;
    l: *ENTROPY_CONTEXT = ---;
    skip_dc: s32 = 0;

    qcoeff_ptr := x.qcoeff.data + 0;

    if x.mode_info_context.mbmi.is_4x4 == 0 {
        a = a_ctx + 8;
        l = l_ctx + 8;

        coef_probs = FC.coef_probs[1].data;

        nonzeros = get_coeffs(bc, coef_probs, (cast(s32) a.*) + cast(s32) l.*, 0, qcoeff_ptr + 24 * 16);
        l.* = cast(ENTROPY_CONTEXT) (nonzeros > 0);
        a.* = l.*;

        eobs[24] = cast,no_check(s8) nonzeros;
        eobtotal += nonzeros - 16;

        coef_probs = FC.coef_probs[0].data;
        skip_dc = 1;
    } else {
        coef_probs = FC.coef_probs[3].data;
        skip_dc = 0;
    }

    for i: 0..cast(s32) 16 - 1 {
        a = a_ctx + i & 3;
        l = l_ctx + i & 0xc >> 2;

        nonzeros = get_coeffs(bc, coef_probs, (cast(s32) a.*) + cast(s32) l.*, skip_dc, qcoeff_ptr);
        l.* = cast(ENTROPY_CONTEXT) (nonzeros > 0);
        a.* = l.*;

        nonzeros += skip_dc;
        eobs[i] = cast,no_check(s8) nonzeros;
        eobtotal += nonzeros;
        qcoeff_ptr += 16;
    }

    coef_probs = FC.coef_probs[2].data;

    a_ctx += 4;
    l_ctx += 4;
    if 16 < 24 {
        for i: 16..cast(s32) 24 - 1 {
            a = a_ctx + (cast(s32) (i > 19)) << 1 + i & 1;
            l = l_ctx + (cast(s32) (i > 19)) << 1 + cast(s32) ((i & 3 > 1));

            nonzeros = get_coeffs(bc, coef_probs, (cast(s32) a.*) + cast(s32) l.*, 0, qcoeff_ptr);
            l.* = cast(ENTROPY_CONTEXT) (nonzeros > 0);
            a.* = l.*;

            eobs[i] = cast,no_check(s8) nonzeros;
            eobtotal += nonzeros;
            qcoeff_ptr += 16;
        }
    }

    return eobtotal;
}

get_coeffs :: (br: *BOOL_DECODER, prob: Proba_Array, ctx: s32, n: s32, out: *s16) -> s32 {
    p := prob[n][ctx].data;
    if vp8dx_decode_bool_in_detokenize(br, cast,no_check(s32) p[0]) == 0 {
        return 0;
    }
    while ((cast(s32) 1) != 0) {
        n += 1;
        if vp8dx_decode_bool_in_detokenize(br, cast,no_check(s32) p[1]) == 0 {
            p = prob[K_BANDS[n]][0].data;
        } else {
            v: s32 = ---;
            if vp8dx_decode_bool_in_detokenize(br, cast,no_check(s32) p[2]) == 0 {
                p = prob[K_BANDS[n]][1].data;
                v = 1;
            } else {
                if vp8dx_decode_bool_in_detokenize(br, cast,no_check(s32) p[3]) == 0 {
                    if vp8dx_decode_bool_in_detokenize(br, cast,no_check(s32) p[4]) == 0 {
                        v = 2;
                    } else {
                        v = 3 + vp8dx_decode_bool_in_detokenize(br, cast,no_check(s32) p[5]);
                    }
                } else if vp8dx_decode_bool_in_detokenize(br, cast,no_check(s32) p[6]) == 0 {
                    if vp8dx_decode_bool_in_detokenize(br, cast,no_check(s32) p[7]) == 0 {
                        v = 5 + vp8dx_decode_bool_in_detokenize(br, 159);
                    } else {
                        v = 7 + 2 * vp8dx_decode_bool_in_detokenize(br, 165);
                        v += vp8dx_decode_bool_in_detokenize(br, 145);
                    }
                } else {
                    BIT1 := vp8dx_decode_bool_in_detokenize(br, cast,no_check(s32) p[8]);
                    BIT0 := vp8dx_decode_bool_in_detokenize(br, cast,no_check(s32) p[9 + BIT1]);
                    CAT := 2 * BIT1 + BIT0;
                    v = 0;
                    tab := K_CAT3456[CAT];
                    while tab.* != 0 {
                        v += v + vp8dx_decode_bool_in_detokenize(br, cast,no_check(s32) tab.*);
                        tab += 1;
                    }
                    v += 3 + (cast(s32) 8) << ((CAT) & 31);
                }
                p = prob[K_BANDS[n]][2].data;
            }
            j := cast,no_check(s32) K_ZIGZAG[n - 1];

            out[j] = cast,no_check(s16) get_signed(br, v);

            if n == 16 || vp8dx_decode_bool_in_detokenize(br, cast,no_check(s32) p[0]) == 0 {
                return n;
            }
        }
        if n == 16 {
            return 16;
        }
    }
    return unreachable_value(s32);
}

get_signed :: (br: *BOOL_DECODER, value_to_sign: s32) -> s32 {
    split := cast,no_check(s32) ((br.range + 1) >> 1);
    bigsplit :=
        (cast,no_check(VP8_BD_VALUE) split) << ((((cast,no_check(s32) (cast(u64) size_of(VP8_BD_VALUE))) * 8 -
            8)) & 63);
    v: s32 = ---;

    if br.count < 0 {
        (cast,no_check(#type (_: *BOOL_DECODER)) (cast(*void) vp8dx_bool_decoder_fill))(br);
    }

    if br.value < bigsplit {
        br.range = cast,no_check(u32) split;
        v = value_to_sign;
    } else {
        br.range = br.range - cast,no_check(u32) split;
        br.value = br.value - bigsplit;
        v = -value_to_sign;
    }
    br.range += br.range;
    br.value += br.value;
    br.count -= 1;

    return v;
}

globals_initialization_state_for_detokenize: u32;
initialize_globals_for_detokenize :: () {
    {
        state := atomic_load(*globals_initialization_state_for_detokenize);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_detokenize, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_detokenize) != 2 {}
            return;
        }
    }
    K_BANDS =
        u8.[
            0,
            1,
            2,
            3,
            6,
            4,
            5,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            7,
            0
        ];
    K_CAT3 = u8.[ 173, 148, 140, 0 ];
    K_CAT4 =
        u8.[
            176,
            155,
            140,
            135,
            0
        ];
    K_CAT5 =
        u8.[
            180,
            157,
            141,
            134,
            130,
            0
        ];
    K_CAT6 =
        u8.[
            254,
            254,
            243,
            230,
            196,
            177,
            153,
            140,
            133,
            130,
            129,
            0
        ];
    K_CAT3456 = *u8.[ K_CAT3.data, K_CAT4.data, K_CAT5.data, K_CAT6.data ];
    K_ZIGZAG =
        u8.[
            0,
            1,
            4,
            8,
            5,
            2,
            3,
            6,
            9,
            12,
            13,
            10,
            7,
            11,
            14,
            15
        ];
    atomic_store(*globals_initialization_state_for_detokenize, 2);
}

