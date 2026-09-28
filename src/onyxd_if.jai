// Generated directly from C by cpp_transpiler.
init_done: s32;

lock_in_onyxd_if: Pthread_Once_T;

vp8_set_reference_value_in_onyxd_if :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_onyxd_if :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_onyxd_if :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_onyxd_if :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8dx_receive_compressed_data :: (pbi: *VP8_D_COMP) -> s32 {
    cm := *pbi.common;
    retcode: s32 = -1;
    pbi.common.error.error_code = cast,no_check(Codec_Err_T) CODEC_OK;
    retcode = check_fragments_for_errors(pbi);
    if retcode <= 0 {
        return retcode;
    }
    cm.new_fb_idx = get_free_fb(cm);
    pbi.dec_fb_ref[INTRA_FRAME] = cm.yv12_fb.data + cm.new_fb_idx;
    pbi.dec_fb_ref[LAST_FRAME] = cm.yv12_fb.data + cm.lst_fb_idx;
    pbi.dec_fb_ref[GOLDEN_FRAME] = cm.yv12_fb.data + cm.gld_fb_idx;
    pbi.dec_fb_ref[ALTREF_FRAME] = cm.yv12_fb.data + cm.alt_fb_idx;
    retcode = vp8_decode_frame(pbi);
    while decode_exit := true { // Forward-goto shim; executes at most once.
        if retcode < 0 {
            if cm.fb_idx_ref_cnt[cm.new_fb_idx] > 0 {
                cm.fb_idx_ref_cnt[cm.new_fb_idx] -= 1;
            }

            pbi.common.error.error_code = cast,no_check(Codec_Err_T) CODEC_ERROR;

            if pbi.mb.error_info.error_code != 0 {
                pbi.common.error.error_code = pbi.mb.error_info.error_code;
                copy_memory(pbi.common.error.detail.data, pbi.mb.error_info.detail.data, pbi.mb.error_info.detail.count);
            }
            break decode_exit;
        }
        if swap_frame_buffers(cm) != 0 {
            pbi.common.error.error_code = cast,no_check(Codec_Err_T) CODEC_ERROR;
            break decode_exit;
        }
        if cm.show_frame != 0 {
            cm.current_video_frame += 1;
            cm.show_frame_mi = cm.mi;
        }
        pbi.ready_for_new_data = 0;
        break decode_exit;
    }
    return retcode;
}

swap_frame_buffers :: (cm: *VP8_COMMON) -> s32 {
    err: s32 = 0;

    if cm.copy_buffer_to_arf != 0 {
        new_fb: s32 = 0;

        if cm.copy_buffer_to_arf == 1 {
            new_fb = cm.lst_fb_idx;
        } else if cm.copy_buffer_to_arf == 2 {
            new_fb = cm.gld_fb_idx;
        } else {
            err = -1;
        }

        ref_cnt_fb(cm.fb_idx_ref_cnt.data, *cm.alt_fb_idx, new_fb);
    }

    if cm.copy_buffer_to_gf != 0 {
        new_fb: s32 = 0;

        if cm.copy_buffer_to_gf == 1 {
            new_fb = cm.lst_fb_idx;
        } else if cm.copy_buffer_to_gf == 2 {
            new_fb = cm.alt_fb_idx;
        } else {
            err = -1;
        }

        ref_cnt_fb(cm.fb_idx_ref_cnt.data, *cm.gld_fb_idx, new_fb);
    }

    if cm.refresh_golden_frame != 0 {
        ref_cnt_fb(cm.fb_idx_ref_cnt.data, *cm.gld_fb_idx, cm.new_fb_idx);
    }

    if cm.refresh_alt_ref_frame != 0 {
        ref_cnt_fb(cm.fb_idx_ref_cnt.data, *cm.alt_fb_idx, cm.new_fb_idx);
    }

    if cm.refresh_last_frame != 0 {
        ref_cnt_fb(cm.fb_idx_ref_cnt.data, *cm.lst_fb_idx, cm.new_fb_idx);

        cm.frame_to_show = cm.yv12_fb.data + cm.lst_fb_idx;
    } else {
        cm.frame_to_show = cm.yv12_fb.data + cm.new_fb_idx;
    }

    cm.fb_idx_ref_cnt[cm.new_fb_idx] -= 1;

    return err;
}

ref_cnt_fb :: (buf: *s32, idx: *s32, new_idx: s32) {
    if buf[idx.*] > 0 {
        buf[idx.*] -= 1;
    }

    idx.* = new_idx;

    buf[new_idx] += 1;
}

get_free_fb :: (cm: *VP8_COMMON) -> s32 {
    i: s32 = 0;
    while i < 4 {
        if cm.fb_idx_ref_cnt[i] == 0 {
            break;
        }
        i += 1;
    }

    cm.fb_idx_ref_cnt[i] = 1;
    return i;
}

check_fragments_for_errors :: (pbi: *VP8_D_COMP) -> s32 {
    if pbi.ec_active == 0 && pbi.fragments.count <= 1 && pbi.fragments.sizes[0] == 0 {
        cm := *pbi.common;

        if cm.fb_idx_ref_cnt[cm.lst_fb_idx] > 1 {
            PREV_IDX := cm.lst_fb_idx;
            cm.fb_idx_ref_cnt[PREV_IDX] -= 1;
            cm.lst_fb_idx = get_free_fb(cm);
            vp8_yv12_copy_frame_c(cm.yv12_fb.data + PREV_IDX, cm.yv12_fb.data + cm.lst_fb_idx);
        }

        cm.yv12_fb[cm.lst_fb_idx].corrupted = 1;

        cm.show_frame = 0;

        return 0;
    }

    return 1;
}

vp8dx_get_raw_frame :: (pbi: *VP8_D_COMP, sd: *YV12_BUFFER_CONFIG, flags: *Vp8_Ppflags_T) -> s32 {
    ret: s32 = -1;

    if pbi.ready_for_new_data == 1 {
        return ret;
    }

    if pbi.common.show_frame == 0 {
        return ret;
    }

    pbi.ready_for_new_data = 1;

    if pbi.common.frame_to_show != null {
        sd.* = pbi.common.frame_to_show.*;
        sd.y_width = pbi.common.width;
        sd.y_height = pbi.common.height;
        sd.uv_height = pbi.common.height / 2;
        ret = 0;
    } else {
        ret = -1;
    }

    return ret;
}

vp8dx_references_buffer :: (oci: *VP8_COMMON, ref_frame: s32) -> s32 {
    mi := oci.mi;
    mb_col: s32 = ---;

    mb_row: s32 = 0;
    while mb_row < oci.mb_rows {
        mb_col = 0;
        while mb_col < oci.mb_cols {
            if cast,no_check(s32) mi.mbmi.ref_frame == ref_frame {
                return 1;
            }
            mb_col += 1;
            mi += 1;
        }
        mi += 1;
        mb_row += 1;
    }
    return 0;
}

vp8dx_get_reference :: (pbi: *VP8_D_COMP, ref_frame_flag: Ref_Frame_Type, sd: *YV12_BUFFER_CONFIG) -> Codec_Err_T {
    cm := *pbi.common;
    ref_fb_idx: s32 = ---;

    if ref_frame_flag == cast,no_check(u32) VP8_LAST_FRAME {
        ref_fb_idx = cm.lst_fb_idx;
    } else if ref_frame_flag == cast,no_check(u32) VP8_GOLD_FRAME {
        ref_fb_idx = cm.gld_fb_idx;
    } else if ref_frame_flag == cast,no_check(u32) VP8_ALTR_FRAME {
        ref_fb_idx = cm.alt_fb_idx;
    } else {
        internal_error(*pbi.common.error, cast,no_check(Codec_Err_T) CODEC_ERROR, c_string("Invalid reference frame"));
        return pbi.common.error.error_code;
    }

    if cm.yv12_fb[ref_fb_idx].y_height != sd.y_height ||
        cm.yv12_fb[ref_fb_idx].y_width != sd.y_width ||
        cm.yv12_fb[ref_fb_idx].uv_height != sd.uv_height ||
        cm.yv12_fb[ref_fb_idx].uv_width != sd.uv_width {
        internal_error(
            *pbi.common.error,
            cast,no_check(Codec_Err_T) CODEC_ERROR,
            c_string("Incorrect buffer dimensions")
        );
    } else {
        vp8_yv12_copy_frame_c(cm.yv12_fb.data + ref_fb_idx, sd);
    }

    return pbi.common.error.error_code;
}

vp8dx_set_reference :: (pbi: *VP8_D_COMP, ref_frame_flag: Ref_Frame_Type, sd: *YV12_BUFFER_CONFIG) -> Codec_Err_T {
    cm := *pbi.common;
    ref_fb_ptr: *s32 = null;
    free_fb: s32 = ---;

    if ref_frame_flag == cast,no_check(u32) VP8_LAST_FRAME {
        ref_fb_ptr = *cm.lst_fb_idx;
    } else if ref_frame_flag == cast,no_check(u32) VP8_GOLD_FRAME {
        ref_fb_ptr = *cm.gld_fb_idx;
    } else if ref_frame_flag == cast,no_check(u32) VP8_ALTR_FRAME {
        ref_fb_ptr = *cm.alt_fb_idx;
    } else {
        internal_error(*pbi.common.error, cast,no_check(Codec_Err_T) CODEC_ERROR, c_string("Invalid reference frame"));
        return pbi.common.error.error_code;
    }

    if cm.yv12_fb[ref_fb_ptr.*].y_height != sd.y_height ||
        cm.yv12_fb[ref_fb_ptr.*].y_width != sd.y_width ||
        cm.yv12_fb[ref_fb_ptr.*].uv_height != sd.uv_height ||
        cm.yv12_fb[ref_fb_ptr.*].uv_width != sd.uv_width {
        internal_error(
            *pbi.common.error,
            cast,no_check(Codec_Err_T) CODEC_ERROR,
            c_string("Incorrect buffer dimensions")
        );
    } else {
        free_fb = get_free_fb(cm);

        cm.fb_idx_ref_cnt[free_fb] -= 1;

        ref_cnt_fb(cm.fb_idx_ref_cnt.data, ref_fb_ptr, free_fb);
        vp8_yv12_copy_frame_c(sd, cm.yv12_fb.data + ref_fb_ptr.*);
    }

    return pbi.common.error.error_code;
}

vp8dx_get_quantizer :: (pbi: *VP8_D_COMP) -> s32 {
    return pbi.common.base_qindex;
}

vp8_d_get_last_ref_updates_value_in_onyxd_if :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_d_get_frame_corrupted_value_in_onyxd_if :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_d_get_last_ref_used_value_in_onyxd_if :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

d_set_decryptor_value_in_onyxd_if :: (args: *Va_List_Tag) -> *Decrypt_Init {
    return c_transpiler_va_arg(cast(*void) (args), *Decrypt_Init);
}

vp8_d_set_decryptor_value_in_onyxd_if :: (args: *Va_List_Tag) -> *Decrypt_Init {
    return c_transpiler_va_arg(cast(*void) (args), *Decrypt_Init);
}

vp9_d_get_frame_size_value_in_onyxd_if :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_d_get_display_size_value_in_onyxd_if :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_d_get_bit_depth_value_in_onyxd_if :: (args: *Va_List_Tag) -> *u32 {
    return c_transpiler_va_arg(cast(*void) (args), *u32);
}

vp9_set_byte_alignment_value_in_onyxd_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_invert_tile_decode_order_value_in_onyxd_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_set_skip_loop_filter_value_in_onyxd_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_decode_svc_spatial_layer_value_in_onyxd_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

d_get_last_quantizer_value_in_onyxd_if :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_d_set_row_mt_value_in_onyxd_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_d_set_loop_filter_opt_value_in_onyxd_if :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8dx_decode_bool_in_onyxd_if :: (br: *BOOL_DECODER, probability: s32) -> s32 {
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

vp8_decode_value_in_onyxd_if :: (br: *BOOL_DECODER, bits: s32) -> s32 {
    z: s32 = 0;

    bit := bits - 1;
    while bit >= 0 {
        z |= vp8dx_decode_bool_in_onyxd_if(br, 0x80) << ((bit) & 31);
        bit -= 1;
    }

    return z;
}

vp8dx_bool_error_in_onyxd_if :: (br: *BOOL_DECODER) -> s32 {
    if br.count > (cast,no_check(s32) (cast(u64) size_of(VP8_BD_VALUE))) * 8 && br.count < 0x40000000 {
        return 1;
    }

    return 0;
}

vp8_treed_read_in_onyxd_if :: (R: *Vp8_Reader_in_treereader, t: *Vp8_Tree_Index, P: *Vp8_Prob) -> s32 {
    i: Vp8_Tree_Index = 0;

    while (ifx true { assignment_1: Vp8_Tree_Index = cast,no_check(Vp8_Tree_Index) (t[(cast(s32) i) + vp8dx_decode_bool_in_onyxd_if(R, cast,no_check(s32) P[(cast(s32) i) >> 1])]); (i) = assignment_1; assignment_1; }) > 0 {
    }

    return -(cast,no_check(s32) i);
}

vp8_sem_wait_in_onyxd_if :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_2: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_2; assignment_2; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init_in_onyxd_if :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release_in_onyxd_if :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

atomic_load_acquire_in_onyxd_if :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_atomic_spin_wait_in_onyxd_if :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire_in_onyxd_if(last_row_current_mb_col) - NSYNC {
    }
}

vp8_create_decoder_instances :: (fb: *Frame_Buffers, oxcf: *VP8_D_CONFIG) -> s32 {
    fb.pbi[0] = create_decompressor(oxcf);
    if fb.pbi[0] == null {
        return CODEC_ERROR;
    }

    if setjmp_2(fb.pbi[0].common.error.jmp.data) != 0 {
        fb.pbi[0].common.error.setjmp = 0;
        vp8_remove_decoder_instances(fb);
        fill_memory(*fb.pbi, 0, fb.pbi.count * size_of(*VP8_D_COMP));

        return CODEC_ERROR;
    }

    fb.pbi[0].common.error.setjmp = 1;
    fb.pbi[0].max_threads = oxcf.max_threads;
    vp8_decoder_create_threads(fb.pbi[0]);
    fb.pbi[0].common.error.setjmp = 0;

    return CODEC_OK;
}

vp8_remove_decoder_instances :: (fb: *Frame_Buffers) -> s32 {
    pbi: *VP8_D_COMP = fb.pbi[0];

    if pbi == null {
        return CODEC_ERROR;
    }

    vp8_decoder_remove_threads(pbi);

    remove_decompressor(pbi);
    fb.pbi[0] = null;
    return CODEC_OK;
}

remove_decompressor :: (pbi: *VP8_D_COMP) {
    vp8_remove_common(*pbi.common);
    deallocate_memory(cast(*void) pbi);
}

create_decompressor :: (oxcf: *VP8_D_CONFIG) -> *VP8_D_COMP {
    pbi := cast(*VP8_D_COMP) memalign(32, size_of(VP8_D_COMP));

    if pbi == null {
        return null;
    }

    fill_memory(pbi, 0, size_of(VP8_D_COMP));

    if setjmp_2(pbi.common.error.jmp.data) != 0 {
        pbi.common.error.setjmp = 0;
        remove_decompressor(pbi);
        return null;
    }

    pbi.common.error.setjmp = 1;

    vp8_create_common(*pbi.common);

    pbi.common.current_video_frame = 0;
    pbi.ready_for_new_data = 1;

    vp8cx_init_de_quantizer(pbi);

    vp8_loop_filter_init(*pbi.common);

    pbi.common.error.setjmp = 0;

    pbi.ec_enabled = 0;

    pbi.ec_active = 0;

    pbi.decoded_key_frame = 0;

    pbi.independent_partitions = 0;

    vp8_setup_block_dptrs(*pbi.mb);

    once_in_onyxd_if(cast,no_check(#type () #c_call) initialize_dec);

    return pbi;
}

initialize_dec :: () #c_call {
    push_context {

        if init_done == 0 {
            dsp_rtcd();
            vp8_init_intra_predictors();
            init_done = 1;
        }
    }
}

once_in_onyxd_if :: (func: Once_In_Onyxd_If_Parameter_0_Type) {
    pthread_once(*lock_in_onyxd_if, cast,no_check(#type () #c_call) (func));
}

clip_pixel_in_onyxd_if :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_onyxd_if :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_onyxd_if :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_onyxd_if :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_onyxd_if :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_onyxd_if(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_onyxd_if(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_onyxd_if(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_onyxd_if :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_onyxd_if :: (FILTER: *s16) -> s32 {
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

usec_timer_start_in_onyxd_if :: (t: *Usec_Timer) {
    clock_gettime(4, *t.begin);
}

usec_timer_mark_in_onyxd_if :: (t: *Usec_Timer) {
    clock_gettime(4, *t.end);
}

usec_timer_elapsed_in_onyxd_if :: (t: *Usec_Timer) -> s64 {
    diff: C_Transpiler_POSIX.timespec = ---;

    assignment_3: Time_T = (t.end.tv_sec - t.begin.tv_sec);
    (diff.tv_sec) = assignment_3;

    assignment_4: Syscall_Slong_T = (t.end.tv_nsec - t.begin.tv_nsec);
    (diff.tv_nsec) = assignment_4;

    if diff.tv_nsec < 0 {
        diff.tv_sec -= 1;

        c_transpiler_compound_add(*(diff.tv_nsec), (cast(Syscall_Slong_T) 1000000000), Syscall_Slong_T, Syscall_Slong_T);
    }
    return (diff.tv_sec * 1000000) + diff.tv_nsec / 1000;
}

globals_initialization_state_for_onyxd_if: u32;
initialize_globals_for_onyxd_if :: () {
    {
        state := atomic_load(*globals_initialization_state_for_onyxd_if);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_onyxd_if, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_onyxd_if) != 2 {}
            return;
        }
    }
    lock_in_onyxd_if = 0;
    init_done = 0;
    atomic_store(*globals_initialization_state_for_onyxd_if, 2);
}


Once_In_Onyxd_If_Parameter_0_Type :: #type () #c_call;
