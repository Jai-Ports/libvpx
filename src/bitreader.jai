COUNT_TO_UPDATE_FACTOR_in_bitreader: [21] s32;

codec_control_vp8_set_reference :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *Ref_Frame_T) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_copy_reference :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *Ref_Frame_T) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_set_postproc :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *Vp8_Postproc_Cfg_T) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_get_reference :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *Vp9_Ref_Frame_T) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_last_ref_updates :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_frame_corrupted :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_last_ref_used :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vpxd_set_decryptor :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *Decrypt_Init) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_set_decryptor :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *Decrypt_Init) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_frame_size :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_display_size :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_bit_depth :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *u32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_set_byte_alignment :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_invert_tile_decode_order :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_set_skip_loop_filter :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_decode_svc_spatial_layer :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vpxd_get_last_quantizer :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_set_row_mt :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_set_loop_filter_opt :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

clip_pixel_in_bitreader :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_bitreader :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_bitreader :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_bitreader :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_bitreader :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_bitreader(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_bitreader(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_bitreader(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_bitreader :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_prob_in_bitreader :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_bitreader :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_bitreader(n0, DEN);
}

weighted_prob_in_bitreader :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_bitreader :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_bitreader(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_bitreader(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_bitreader :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_bitreader[COUNT];
        PROB := get_prob_in_bitreader(ct[0], DEN);
        return weighted_prob_in_bitreader(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

reader_init :: (r: *Reader, buffer: *u8, size: u64, decrypt_cb: Decrypt_Cb, decrypt_state: *void) -> s32 {
    if size != 0 && buffer == null {
        return 1;
    } else {
        r.buffer_end = buffer + size;
        r.buffer = buffer;
        r.value = 0;
        r.count = -8;
        r.range = 255;
        r.decrypt_cb = decrypt_cb;
        r.decrypt_state = decrypt_state;
        reader_fill(r);
        if read_bit(r) != 0 {
            return 1;
        }
        return 0;
    }
}

read_bit :: (r: *Reader) -> s32 {
    return read(r, 128);
}

read :: (r: *Reader, prob: s32) -> s32 {
    bit: u32 = 0;

    split := ((r.range * cast,no_check(u32) prob) + cast,no_check(u32) (256 - prob)) >> 8;

    if r.count < 0 {
        reader_fill(r);
    }

    value := r.value;
    count := r.count;

    bigsplit :=
        (cast,no_check(BD_VALUE) split) << ((((cast,no_check(s32) (cast(u64) size_of(BD_VALUE))) * 8 -
            8)) & 63);

    range := split;

    if value >= bigsplit {
        range = r.range - split;
        value = value - bigsplit;
        bit = 1;
    }

    {
        SHIFT: u8 = NORM[cast,no_check(u8) range];
        c_transpiler_compound_shl(*(range), (((cast,no_check(u32) (cast,no_check(s32) SHIFT)) & 31)), u32, u32);
        c_transpiler_compound_shl(*(value), (((cast,no_check(BD_VALUE) (cast,no_check(s32) SHIFT)) & 63)), BD_VALUE, BD_VALUE);
        count -= cast,no_check(s32) SHIFT;
    }
    r.value = value;
    r.count = count;
    r.range = range;

    return cast,no_check(s32) bit;
}

reader_fill :: (r: *Reader) {
    BUFFER_END := r.buffer_end;
    buffer := r.buffer;
    buffer_start := buffer;
    value := r.value;
    count := r.count;
    BYTES_LEFT := cast,no_check(u64) (BUFFER_END - buffer);
    BITS_LEFT := BYTES_LEFT * 8;
    shift := (cast,no_check(s32) (cast(u64) size_of(BD_VALUE))) * 8 - 8 - (count + 8);

    if r.decrypt_cb != null {
        n := (ifx r.clear_buffer.count < BYTES_LEFT then r.clear_buffer.count else BYTES_LEFT);
        r.decrypt_cb(r.decrypt_state, buffer, r.clear_buffer.data, cast,no_check(s32) n);
        buffer = r.clear_buffer.data;
        buffer_start = r.clear_buffer.data;
    }
    if BITS_LEFT > cast,no_check(u64) ((cast,no_check(s32) (cast(u64) size_of(BD_VALUE))) * 8) {
        BITS := cast,no_check(s32) ((cast,no_check(u32) shift) & 0xfffffff8 + 8);

        big_endian_values: BD_VALUE = ---;
        copy_memory(*big_endian_values, buffer, size_of(BD_VALUE));

        big_endian_values = b_swap64(big_endian_values);

        nv := big_endian_values >> ((((cast,no_check(s32) (cast(u64) size_of(BD_VALUE))) * 8 - BITS)) & 63);
        count += BITS;
        buffer += BITS >> 3;
        value = r.value | (nv << (((shift & 0x7)) & 63));
    } else {
        BITS_OVER := shift + 8 - cast,no_check(s32) BITS_LEFT;
        loop_end: s32 = 0;
        if BITS_OVER >= 0 {
            count += 0x40000000;
            loop_end = BITS_OVER;
        }

        if BITS_OVER < 0 || BITS_LEFT != 0 {
            while shift >= loop_end {
                count += 8;
                value |= (cast,no_check(BD_VALUE) ((c_transpiler_post_increment(*(buffer))).*)) << ((shift) & 63);
                shift -= 8;
            }
        }
    }

    r.buffer += buffer - buffer_start;
    r.value = value;
    r.count = count;
}

b_swap64 :: (x: u64) -> u64 {
    return (ifx true { c_transpiler_bswap_0: u64 = cast,no_check(u64) (x); ((c_transpiler_bswap_0 & 0x00000000000000ff) << 56) | ((c_transpiler_bswap_0 & 0x000000000000ff00) << 40) | ((c_transpiler_bswap_0 & 0x0000000000ff0000) << 24) | ((c_transpiler_bswap_0 & 0x00000000ff000000) << 8) | ((c_transpiler_bswap_0 & 0x000000ff00000000) >> 8) | ((c_transpiler_bswap_0 & 0x0000ff0000000000) >> 24) | ((c_transpiler_bswap_0 & 0x00ff000000000000) >> 40) | ((c_transpiler_bswap_0 & 0xff00000000000000) >> 56); });
}

reader_find_end :: (r: *Reader) -> *u8 {
    while r.count > 8 && r.count < (cast,no_check(s32) (cast(u64) size_of(BD_VALUE))) * 8 {
        r.count -= 8;
        r.buffer -= 1;
    }
    return r.buffer;
}

reader_has_error :: (r: *Reader) -> s32 {
    if r.count > (cast,no_check(s32) (cast(u64) size_of(BD_VALUE))) * 8 && r.count < 0x40000000 {
        return 1;
    }
    return 0;
}

read_literal :: (r: *Reader, bits: s32) -> s32 {
    literal: s32 = 0;

    bit := bits - 1;
    while bit >= 0 {
        literal |= read_bit(r) << ((bit) & 31);
        bit -= 1;
    }

    return literal;
}

read_tree :: (r: *Reader, tree: *Tree_Index, probs: *Prob) -> s32 {
    i: Tree_Index = 0;

    while (ifx true { assignment_2: Tree_Index = cast,no_check(Tree_Index) (tree[(cast(s32) i) + read(r, cast,no_check(s32) probs[(cast(s32) i) >> 1])]); (i) = assignment_2; assignment_2; }) > 0 {
        continue;
    }

    return -(cast,no_check(s32) i);
}

b_swap16 :: (x: u16) -> u16 {
    return (ifx true { c_transpiler_bswap_3: u16 = cast,no_check(u16) (x); (c_transpiler_bswap_3 << 8) | (c_transpiler_bswap_3 >> 8); });
}

b_swap32 :: (x: u32) -> u32 {
    return (ifx true { c_transpiler_bswap_4: u32 = cast,no_check(u32) (x); ((c_transpiler_bswap_4 & 0x000000ff) << 24) | ((c_transpiler_bswap_4 & 0x0000ff00) << 8) | ((c_transpiler_bswap_4 & 0x00ff0000) >> 8) | ((c_transpiler_bswap_4 & 0xff000000) >> 24); });
}

globals_initialization_state_for_bitreader: u32;
initialize_globals_for_bitreader :: () {
    {
        state := atomic_load(*globals_initialization_state_for_bitreader);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_bitreader, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_bitreader) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_bitreader =
        s32.[
            0,
            6,
            12,
            19,
            25,
            32,
            38,
            44,
            51,
            57,
            64,
            70,
            76,
            83,
            89,
            96,
            102,
            108,
            115,
            121,
            128
        ];
    atomic_store(*globals_initialization_state_for_bitreader, 2);
}

Ref_Frame_T :: Ref_Frame;

Vp8_Postproc_Cfg_T :: Vp8_Postproc_Cfg;

Vp9_Ref_Frame_T :: Vp9_Ref_Frame;

Decrypt_Cb :: #type (_: *void, _: *u8, _: *u8, _: s32);

BD_VALUE :: u64;

Ref_Frame :: struct {
    frame_type: Ref_Frame_Type_T;
    img: Image_T;
}

Vp8_Postproc_Cfg :: struct {
    post_proc_flag: s32;
    deblocking_level: s32;
    noise_level: s32;
}

Vp9_Ref_Frame :: struct {
    idx: s32;
    img: Image_T;
}

Decrypt_Init :: struct {
    decrypt_cb: Decrypt_Cb;
    decrypt_state: *void;
}

Reader :: struct {
    value: BD_VALUE;
    range: u32;
    count: s32;
    buffer_end: *u8;
    buffer: *u8;
    decrypt_cb: Decrypt_Cb;
    decrypt_state: *void;
    clear_buffer: [9] u8;
}

Ref_Frame_Type_T :: Ref_Frame_Type;

Ref_Frame_Type :: u32;
VP8_LAST_FRAME : s32 : 1;
VP8_GOLD_FRAME : s32 : 2;
VP8_ALTR_FRAME : s32 : 4;

