// Generated directly from C by cpp_transpiler.
codec_control_vp8_set_reference_in_dboolhuff :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *Ref_Frame_T) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_copy_reference_in_dboolhuff :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *Ref_Frame_T) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_set_postproc_in_dboolhuff :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Vp8_Postproc_Cfg_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_get_reference_in_dboolhuff :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Vp9_Ref_Frame_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_last_ref_updates_in_dboolhuff :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_frame_corrupted_in_dboolhuff :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_last_ref_used_in_dboolhuff :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vpxd_set_decryptor_in_dboolhuff :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *Decrypt_Init) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_set_decryptor_in_dboolhuff :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Decrypt_Init
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_frame_size_in_dboolhuff :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_display_size_in_dboolhuff :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_bit_depth_in_dboolhuff :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *u32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_set_byte_alignment_in_dboolhuff :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_invert_tile_decode_order_in_dboolhuff :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_set_skip_loop_filter_in_dboolhuff :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_decode_svc_spatial_layer_in_dboolhuff :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vpxd_get_last_quantizer_in_dboolhuff :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_set_row_mt_in_dboolhuff :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_set_loop_filter_opt_in_dboolhuff :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

vp8dx_start_decode :: (
    br: *Vp8_Reader,
    source: *u8,
    source_sz: u32,
    decrypt_cb: Decrypt_Cb,
    decrypt_state: *void
) -> s32 {
    if source_sz != 0 && source == null {
        return 1;
    }

    br.user_buffer_end = ifx source != null then source + source_sz else source;
    br.user_buffer = source;
    br.value = 0;
    br.count = -8;
    br.range = 255;
    br.decrypt_cb = decrypt_cb;
    br.decrypt_state = decrypt_state;

    vp8dx_bool_decoder_fill(br);

    return 0;
}

vp8dx_bool_decoder_fill :: (br: *Vp8_Reader) {
    bufptr := br.user_buffer;
    value := br.value;
    count := br.count;
    shift := (cast,no_check(s32) (cast(u64) size_of(VP8_BD_VALUE))) * 8 - 8 - (count + 8);
    bytes_left := cast,no_check(u64) (br.user_buffer_end - bufptr);
    bits_left := bytes_left * 8;
    x := shift + 8 - cast,no_check(s32) bits_left;
    loop_end: s32 = 0;
    decrypted: [9] u8 = ---;

    if br.decrypt_cb != null {
        n := (ifx decrypted.count < bytes_left then decrypted.count else bytes_left);
        br.decrypt_cb(br.decrypt_state, bufptr, decrypted.data, cast,no_check(s32) n);
        bufptr = decrypted.data;
    }

    if x >= 0 {
        count += 0x40000000;
        loop_end = x;
    }

    if x < 0 || bits_left != 0 {
        while shift >= loop_end {
            count += 8;
            value |= (cast,no_check(VP8_BD_VALUE) bufptr.*) << ((shift) & 63);
            bufptr += 1;
            br.user_buffer += 1;
            shift -= 8;
        }
    }

    br.value = value;
    br.count = count;
}

vp8dx_decode_bool_in_dboolhuff :: (br: *Vp8_Reader, probability: s32) -> s32 {
    bit: u32 = 0;

    split := 1 + ((br.range - 1) * cast,no_check(u32) probability) >> 8;

    if br.count < 0 {
        vp8dx_bool_decoder_fill(br);
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

vp8_decode_value_in_dboolhuff :: (br: *Vp8_Reader, bits: s32) -> s32 {
    z: s32 = 0;

    bit := bits - 1;
    while bit >= 0 {
        z |= vp8dx_decode_bool_in_dboolhuff(br, 0x80) << ((bit) & 31);
        bit -= 1;
    }

    return z;
}

vp8dx_bool_error_in_dboolhuff :: (br: *Vp8_Reader) -> s32 {
    if br.count > (cast,no_check(s32) (cast(u64) size_of(VP8_BD_VALUE))) * 8 && br.count < 0x40000000 {
        return 1;
    }

    return 0;
}

clip_pixel_in_dboolhuff :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_dboolhuff :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_dboolhuff :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_dboolhuff :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_dboolhuff :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_dboolhuff(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_dboolhuff(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_dboolhuff(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_dboolhuff :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

