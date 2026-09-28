Predict_Recon_Func :: #type (_: *Tile_Worker_Data, _: *MODE_INFO, _: s32, _: s32, _: s32, _: TX_SIZE) -> s32;

Intra_Recon_Func :: #type (_: *Tile_Worker_Data, _: *MODE_INFO, _: s32, _: s32, _: s32, _: TX_SIZE);

SUB_PEL_FILTERS_12_in_vp9_decodeframe: [16] Interp_Kernel12 #align 256;

COUNT_TO_UPDATE_FACTOR_in_vp9_decodeframe: [21] s32;

COSPI_1_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_2_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_3_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_4_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_5_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_6_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_7_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_8_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_9_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_10_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_11_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_12_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_13_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_14_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_15_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_16_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_17_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_18_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_19_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_20_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_21_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_22_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_23_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_24_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_25_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_26_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_27_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_28_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_29_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_30_64_in_vp9_decodeframe: Tran_Coef_T;

COSPI_31_64_in_vp9_decodeframe: Tran_Coef_T;

SINPI_1_9_in_vp9_decodeframe: Tran_Coef_T;

SINPI_2_9_in_vp9_decodeframe: Tran_Coef_T;

SINPI_3_9_in_vp9_decodeframe: Tran_Coef_T;

SINPI_4_9_in_vp9_decodeframe: Tran_Coef_T;

clip_pixel_in_vp9_decodeframe :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_decodeframe :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_decodeframe :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_decodeframe :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_decodeframe :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_decodeframe(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_decodeframe(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_decodeframe(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_decodeframe :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_lsb_in_vp9_decodeframe :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_decodeframe :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_decodeframe :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_decodeframe(num_values) + 1 else 0;
}

get_filter_taps_in_vp9_decodeframe :: (FILTER: *s16) -> s32 {
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

codec_control_vp8_set_reference_in_vp9_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Ref_Frame_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_copy_reference_in_vp9_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Ref_Frame_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_set_postproc_in_vp9_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Vp8_Postproc_Cfg_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_get_reference_in_vp9_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Vp9_Ref_Frame_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_last_ref_updates_in_vp9_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_frame_corrupted_in_vp9_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_last_ref_used_in_vp9_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vpxd_set_decryptor_in_vp9_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Decrypt_Init
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_set_decryptor_in_vp9_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Decrypt_Init
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_frame_size_in_vp9_decodeframe :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_display_size_in_vp9_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_bit_depth_in_vp9_decodeframe :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *u32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_set_byte_alignment_in_vp9_decodeframe :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_invert_tile_decode_order_in_vp9_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_set_skip_loop_filter_in_vp9_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_decode_svc_spatial_layer_in_vp9_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vpxd_get_last_quantizer_in_vp9_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_set_row_mt_in_vp9_decodeframe :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_set_loop_filter_opt_in_vp9_decodeframe :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

get_prob_in_vp9_decodeframe :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_decodeframe :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_decodeframe(n0, DEN);
}

weighted_prob_in_vp9_decodeframe :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_decodeframe :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_decodeframe(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_decodeframe(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_decodeframe :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_decodeframe[COUNT];
        PROB := get_prob_in_vp9_decodeframe(ct[0], DEN);
        return weighted_prob_in_vp9_decodeframe(
            cast,no_check(s32) pre_prob,
            cast,no_check(s32) PROB,
            cast,no_check(s32) FACTOR
        );
    }
}

reader_has_error_in_vp9_decodeframe :: (r: *Reader) -> s32 {
    if r.count > (cast,no_check(s32) (cast(u64) size_of(BD_VALUE))) * 8 && r.count < 0x40000000 {
        return 1;
    }
    return 0;
}

read_in_vp9_decodeframe :: (r: *Reader, prob: s32) -> s32 {
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

read_bit_in_vp9_decodeframe :: (r: *Reader) -> s32 {
    return read_in_vp9_decodeframe(r, 128);
}

read_literal_in_vp9_decodeframe :: (r: *Reader, bits: s32) -> s32 {
    literal: s32 = 0;

    bit := bits - 1;
    while bit >= 0 {
        literal |= read_bit_in_vp9_decodeframe(r) << ((bit) & 31);
        bit -= 1;
    }

    return literal;
}

read_tree_in_vp9_decodeframe :: (r: *Reader, tree: *Tree_Index, probs: *Prob) -> s32 {
    i: Tree_Index = 0;

    while (ifx true { assignment_1: Tree_Index = cast,no_check(Tree_Index) (tree[(cast(s32) i) + read_in_vp9_decodeframe(r, cast,no_check(s32) probs[(cast(s32) i) >> 1])]); (i) = assignment_1; assignment_1; }) > 0 {
        continue;
    }

    return -(cast,no_check(s32) i);
}

mem_get_be16_aligned_as_int_in_vp9_decodeframe :: (vmem: *void) -> u32 {
    mem := cast(*u16) vmem;

    val: u32 = ---;
    raw := cast,no_check(u32) mem.*;

    val = cast,no_check(u32) (cast,no_check(u16) ((raw >> 8 & 0xff) | (raw << 8 & 0xff00)));

    return val;
}

mem_get_be32_aligned_as_int_in_vp9_decodeframe :: (vmem: *void) -> u32 {
    mem := cast(*u32) vmem;

    val: u32 = ---;
    raw: u32 = mem.*;

    val = (((raw >> 24 & 0xff) | (raw >> 8 & 0xff00)) | (raw << 8 & 0xff0000)) | (raw << 24 & 0xff000000);

    return val;
}

mem_get_le16_aligned_as_int_in_vp9_decodeframe :: (vmem: *void) -> u32 {
    mem := cast(*u16) vmem;

    return cast,no_check(u32) mem.*;
}

mem_get_le32_aligned_as_int_in_vp9_decodeframe :: (vmem: *void) -> u32 {
    mem := cast(*u32) vmem;

    return mem.*;
}

mem_get_sbe16_aligned_as_int_in_vp9_decodeframe :: (vmem: *void) -> s32 {
    mem := cast(*s16) vmem;

    val: u32 = ---;
    raw := cast,no_check(u32) mem.*;

    val = cast,no_check(u32) (cast,no_check(u16) ((raw >> 8 & 0xff) | (raw << 8 & 0xff00)));

    val = val << 16 >> 16;

    return cast,no_check(s32) val;
}

mem_get_sbe32_aligned_as_int_in_vp9_decodeframe :: (vmem: *void) -> s32 {
    mem := cast(*s32) vmem;

    val: u32 = ---;
    raw := cast,no_check(u32) mem.*;

    val = (((raw >> 24 & 0xff) | (raw >> 8 & 0xff00)) | (raw << 8 & 0xff0000)) | (raw << 24 & 0xff000000);

    return cast,no_check(s32) val;
}

mem_get_sle16_aligned_as_int_in_vp9_decodeframe :: (vmem: *void) -> s32 {
    mem := cast(*s16) vmem;

    return cast,no_check(s32) mem.*;
}

mem_get_sle32_aligned_as_int_in_vp9_decodeframe :: (vmem: *void) -> s32 {
    mem := cast(*s32) vmem;

    return mem.*;
}

mem_put_be16_aligned_as_int_in_vp9_decodeframe :: (vmem: *void, val: s32) {
    mem := cast(*u16) vmem;
    raw: u16 = ---;

    raw = cast,no_check(u16) (val >> 8 & 0xff | (val << 8 & 0xff00));

    mem.* = raw;
}

mem_put_be32_aligned_as_int_in_vp9_decodeframe :: (vmem: *void, val: s32) {
    mem := cast(*u32) vmem;
    raw: u32 = ---;

    raw =
        (cast,no_check(u32) (val >> 24 & 0xff | (val >> 8 & 0xff00) | (val << 8 & 0xff0000))) | ((cast,no_check(u32) (val << 24)) & 0xff000000);

    mem.* = raw;
}

mem_put_le16_aligned_as_int_in_vp9_decodeframe :: (vmem: *void, val: s32) {
    mem := cast(*u16) vmem;

    mem.* = cast,no_check(u16) val;
}

mem_put_le32_aligned_as_int_in_vp9_decodeframe :: (vmem: *void, val: s32) {
    mem := cast(*u32) vmem;

    mem.* = cast,no_check(u32) val;
}

mem_get_be16_as_int_in_vp9_decodeframe :: (vmem: *void) -> u32 {
    mem := cast(*u8) vmem;

    val := cast,no_check(u32) ((cast(s32) mem[0]) << 8);
    val |= cast,no_check(u32) mem[1];
    return val;
}

mem_get_be24_as_int_in_vp9_decodeframe :: (vmem: *void) -> u32 {
    mem := cast(*u8) vmem;

    val := cast,no_check(u32) ((cast(s32) mem[0]) << 16);
    val |= cast,no_check(u32) ((cast(s32) mem[1]) << 8);
    val |= cast,no_check(u32) mem[2];
    return val;
}

mem_get_be32_as_int_in_vp9_decodeframe :: (vmem: *void) -> u32 {
    mem := cast(*u8) vmem;

    val := (cast,no_check(u32) mem[0]) << 24;
    val |= cast,no_check(u32) ((cast(s32) mem[1]) << 16);
    val |= cast,no_check(u32) ((cast(s32) mem[2]) << 8);
    val |= cast,no_check(u32) mem[3];
    return val;
}

mem_get_le16_as_int_in_vp9_decodeframe :: (vmem: *void) -> u32 {
    mem := cast(*u8) vmem;

    val := cast,no_check(u32) ((cast(s32) mem[1]) << 8);
    val |= cast,no_check(u32) mem[0];
    return val;
}

mem_get_le24_as_int_in_vp9_decodeframe :: (vmem: *void) -> u32 {
    mem := cast(*u8) vmem;

    val := cast,no_check(u32) ((cast(s32) mem[2]) << 16);
    val |= cast,no_check(u32) ((cast(s32) mem[1]) << 8);
    val |= cast,no_check(u32) mem[0];
    return val;
}

mem_get_le32_as_int_in_vp9_decodeframe :: (vmem: *void) -> u32 {
    mem := cast(*u8) vmem;

    val := (cast,no_check(u32) mem[3]) << 24;
    val |= cast,no_check(u32) ((cast(s32) mem[2]) << 16);
    val |= cast,no_check(u32) ((cast(s32) mem[1]) << 8);
    val |= cast,no_check(u32) mem[0];
    return val;
}

mem_get_sbe16_as_int_in_vp9_decodeframe :: (vmem: *void) -> s32 {
    mem := cast(*u8) vmem;

    val := cast,no_check(s32) mem_get_be16_as_int_in_vp9_decodeframe(cast(*void) mem);

    return (val << ((((cast(u64) size_of(s32)) << 3 - 16)) & 31)) >> ((((cast(u64) size_of(s32)) << 3 - 16)) & 31);
}

mem_get_sbe24_as_int_in_vp9_decodeframe :: (vmem: *void) -> s32 {
    mem := cast(*u8) vmem;

    val := cast,no_check(s32) mem_get_be24_as_int_in_vp9_decodeframe(cast(*void) mem);

    return (val << ((((cast(u64) size_of(s32)) << 3 - 24)) & 31)) >> ((((cast(u64) size_of(s32)) << 3 - 24)) & 31);
}

mem_get_sbe32_as_int_in_vp9_decodeframe :: (vmem: *void) -> s32 {
    mem := cast(*u8) vmem;

    val := cast,no_check(s32) mem_get_be32_as_int_in_vp9_decodeframe(cast(*void) mem);

    return (val << ((((cast(u64) size_of(s32)) << 3 - 32)) & 31)) >> ((((cast(u64) size_of(s32)) << 3 - 32)) & 31);
}

mem_get_sle16_as_int_in_vp9_decodeframe :: (vmem: *void) -> s32 {
    mem := cast(*u8) vmem;

    val := cast,no_check(s32) mem_get_le16_as_int_in_vp9_decodeframe(cast(*void) mem);

    return (val << ((((cast(u64) size_of(s32)) << 3 - 16)) & 31)) >> ((((cast(u64) size_of(s32)) << 3 - 16)) & 31);
}

mem_get_sle24_as_int_in_vp9_decodeframe :: (vmem: *void) -> s32 {
    mem := cast(*u8) vmem;

    val := cast,no_check(s32) mem_get_le24_as_int_in_vp9_decodeframe(cast(*void) mem);

    return (val << ((((cast(u64) size_of(s32)) << 3 - 24)) & 31)) >> ((((cast(u64) size_of(s32)) << 3 - 24)) & 31);
}

mem_get_sle32_as_int_in_vp9_decodeframe :: (vmem: *void) -> s32 {
    mem := cast(*u8) vmem;

    val := cast,no_check(s32) mem_get_le32_as_int_in_vp9_decodeframe(cast(*void) mem);

    return (val << ((((cast(u64) size_of(s32)) << 3 - 32)) & 31)) >> ((((cast(u64) size_of(s32)) << 3 - 32)) & 31);
}

mem_put_be16_as_int_in_vp9_decodeframe :: (vmem: *void, val: s32) {
    mem := cast(*u8) vmem;

    mem[0] = cast,no_check(u8) (val >> 8 & 0xff);
    mem[1] = cast,no_check(u8) (val & 0xff);
}

mem_put_be24_as_int_in_vp9_decodeframe :: (vmem: *void, val: s32) {
    mem := cast(*u8) vmem;

    mem[0] = cast,no_check(u8) (val >> 16 & 0xff);
    mem[1] = cast,no_check(u8) (val >> 8 & 0xff);
    mem[2] = cast,no_check(u8) (val & 0xff);
}

mem_put_be32_as_int_in_vp9_decodeframe :: (vmem: *void, val: s32) {
    mem := cast(*u8) vmem;

    mem[0] = cast,no_check(u8) (val >> 24 & 0xff);
    mem[1] = cast,no_check(u8) (val >> 16 & 0xff);
    mem[2] = cast,no_check(u8) (val >> 8 & 0xff);
    mem[3] = cast,no_check(u8) (val & 0xff);
}

mem_put_le16_as_int_in_vp9_decodeframe :: (vmem: *void, val: s32) {
    mem := cast(*u8) vmem;

    mem[0] = cast,no_check(u8) (val & 0xff);
    mem[1] = cast,no_check(u8) (val >> 8 & 0xff);
}

mem_put_le24_as_int_in_vp9_decodeframe :: (vmem: *void, val: s32) {
    mem := cast(*u8) vmem;

    mem[0] = cast,no_check(u8) (val & 0xff);
    mem[1] = cast,no_check(u8) (val >> 8 & 0xff);
    mem[2] = cast,no_check(u8) (val >> 16 & 0xff);
}

mem_put_le32_as_int_in_vp9_decodeframe :: (vmem: *void, val: s32) {
    mem := cast(*u8) vmem;

    mem[0] = cast,no_check(u8) (val & 0xff);
    mem[1] = cast,no_check(u8) (val >> 8 & 0xff);
    mem[2] = cast,no_check(u8) (val >> 16 & 0xff);
    mem[3] = cast,no_check(u8) (val >> 24 & 0xff);
}

get_band_translate_in_vp9_decodeframe :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_decodeframe :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_decodeframe :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
    above_ec: ENTROPY_CONTEXT = 0;
    left_ec: ENTROPY_CONTEXT = 0;

    if cast,no_check(s32) tx_size == {
        case cast,no_check(s32) cast(TX_SIZE) 0;
            above_ec = cast(ENTROPY_CONTEXT) (a[0] != 0);
            left_ec = cast(ENTROPY_CONTEXT) (l[0] != 0);
        case cast,no_check(s32) cast(TX_SIZE) 1;
            above_ec = cast(ENTROPY_CONTEXT) (((cast(*u16) a).*) != 0);
            left_ec = cast(ENTROPY_CONTEXT) (((cast(*u16) l).*) != 0);
        case cast,no_check(s32) cast(TX_SIZE) 2;
            above_ec = cast(ENTROPY_CONTEXT) (((cast(*u32) a).*) != 0);
            left_ec = cast(ENTROPY_CONTEXT) (((cast(*u32) l).*) != 0);
        case cast,no_check(s32) cast(TX_SIZE) 3;
            above_ec = cast(ENTROPY_CONTEXT) (((cast(*u64) a).*) != 0);
            left_ec = cast(ENTROPY_CONTEXT) (((cast(*u64) l).*) != 0);
        case;
    }

    return combine_entropy_contexts_in_vp9_decodeframe(above_ec, left_ec);
}

is_zero_mv_in_vp9_decodeframe :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_decodeframe :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_decodeframe :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_decodeframe(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_decodeframe(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_decodeframe :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_decodeframe :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_decodeframe :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_decodeframe :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

check_range_in_vp9_decodeframe :: (input: Tran_High_T) -> Tran_High_T {
    return input;
}

dct_const_round_shift_in_vp9_decodeframe :: (input: Tran_High_T) -> Tran_High_T {
    rv := (input + cast,no_check(Tran_High_T) (((cast(s32) 1) << (((14 - 1)) & 31)))) >> 14;
    return rv;
}

clip_pixel_add_in_vp9_decodeframe :: (dest: u8, trans: Tran_High_T) -> u8 {
    trans = check_range_in_vp9_decodeframe(trans);
    return clip_pixel_in_vp9_decodeframe((cast(s32) dest) + trans);
}

vp9_is_valid_scale_in_vp9_decodeframe :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_decodeframe :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_decodeframe(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_decodeframe :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_decodeframe :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_decodeframe :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_decodeframe :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_decodeframe :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_decodeframe :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_decodeframe :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_decodeframe :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_decodeframe :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_decodeframe :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_decodeframe :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_decodeframe(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_decodeframe :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_decodeframe(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_decodeframe(MI, ib)];
}

get_uv_tx_size_in_vp9_decodeframe :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_decodeframe :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_decodeframe :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_decodeframe(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_decodeframe :: (
    mi: *MODE_INFO,
    above_mi: *MODE_INFO,
    left_mi: *MODE_INFO,
    block: s32
) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_decodeframe :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_decodeframe :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_decodeframe :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_decodeframe :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
    frame_info.frame_width = cm.width;
    frame_info.frame_height = cm.height;
    frame_info.render_frame_width = cm.render_width;
    frame_info.render_frame_height = cm.render_height;
    frame_info.mi_cols = cm.mi_cols;
    frame_info.mi_rows = cm.mi_rows;
    frame_info.mb_cols = cm.mb_cols;
    frame_info.mb_rows = cm.mb_rows;
    frame_info.num_mbs = cm.m_bs;
    frame_info.bit_depth = cm.bit_depth;
}

get_buf_frame_in_vp9_decodeframe :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_decodeframe :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_decodeframe :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_decodeframe :: (cm: *VP9_COMMON) -> s32 {
    FRAME_BUFS := cm.buffer_pool.frame_bufs.data;

    i: s32 = 0;
    while i < (cast(s32) 1) << 3 + 1 + 3 {
        if FRAME_BUFS[i].ref_count == 0 {
            break;
        }
        i += 1;
    }

    if i != (cast(s32) 1) << 3 + 1 + 3 {
        FRAME_BUFS[i].ref_count = 1;
    } else {
        i = -1;
    }

    return i;
}

ref_cnt_fb_in_vp9_decodeframe :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_decodeframe :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_decodeframe :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_decodeframe :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_decodeframe(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_decodeframe :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_decodeframe(cm.mi_cols);

        if get_plane_type_in_vp9_decodeframe(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_decodeframe(cm, xd);
}

get_partition_probs_in_vp9_decodeframe :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_decodeframe :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_decodeframe :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_decodeframe :: (
    xd: *MACROBLOCKD,
    TILE: *Tile_Info,
    mi_row: s32,
    bh: s32,
    mi_col: s32,
    bw: s32,
    mi_rows: s32,
    mi_cols: s32
) {
    xd.mb_to_top_edge = -(mi_row * (cast(s32) 1) << 3 * 8);
    xd.mb_to_bottom_edge = (mi_rows - bh - mi_row) * (cast(s32) 1) << 3 * 8;
    xd.mb_to_left_edge = -(mi_col * (cast(s32) 1) << 3 * 8);
    xd.mb_to_right_edge = (mi_cols - bw - mi_col) * (cast(s32) 1) << 3 * 8;

    xd.above_mi = ifx mi_row != 0 then xd.mi[-xd.mi_stride] else null;
    xd.left_mi = ifx mi_col > TILE.mi_col_start then xd.mi[-1] else null;
}

update_partition_context_in_vp9_decodeframe :: (
    xd: *MACROBLOCKD,
    mi_row: s32,
    mi_col: s32,
    subsize: BLOCK_SIZE,
    bsize: BLOCK_SIZE
) {
    ABOVE_CTX := xd.above_seg_context + mi_col;
    LEFT_CTX := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);

    BS := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize];

    fill_memory(ABOVE_CTX, cast,no_check(s32) PARTITION_CONTEXT_LOOKUP[subsize].above, cast,no_check(u64) BS);
    fill_memory(LEFT_CTX, cast,no_check(s32) PARTITION_CONTEXT_LOOKUP[subsize].left, cast,no_check(u64) BS);
}

partition_plane_context_in_vp9_decodeframe :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

get_segment_id_in_vp9_decodeframe :: (
    cm: *VP9_COMMON,
    segment_ids: *u8,
    bsize: BLOCK_SIZE,
    mi_row: s32,
    mi_col: s32
) -> s32 {
    MI_OFFSET := mi_row * cm.mi_cols + mi_col;
    BW := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[bsize];
    BH := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[bsize];
    XMIS := (ifx cm.mi_cols - mi_col < BW then cm.mi_cols - mi_col else BW);
    YMIS := (ifx cm.mi_rows - mi_row < BH then cm.mi_rows - mi_row else BH);
    x: s32 = ---;
    segment_id: s32 = 8;

    if 0 < YMIS {
        for y: 0..YMIS - 1 {
            x = 0;
            while x < XMIS {
                segment_id =
                    ifx segment_id < cast,no_check(s32) segment_ids[MI_OFFSET + y * cm.mi_cols +
                        x] then segment_id else cast,no_check(s32) segment_ids[MI_OFFSET + y * cm.mi_cols + x];
                x += 1;
            }
        }
    }

    return segment_id;
}

vp9_get_pred_context_seg_id_in_vp9_decodeframe :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    ABOVE_SIP := (ifx ABOVE_MI != null then cast,no_check(s32) ABOVE_MI.seg_id_predicted else 0);
    LEFT_SIP := (ifx LEFT_MI != null then cast,no_check(s32) LEFT_MI.seg_id_predicted else 0);

    return ABOVE_SIP + LEFT_SIP;
}

vp9_get_pred_prob_seg_id_in_vp9_decodeframe :: (seg: *Segmentation, xd: *MACROBLOCKD) -> Prob {
    return seg.pred_probs[vp9_get_pred_context_seg_id_in_vp9_decodeframe(xd)];
}

vp9_get_skip_context_in_vp9_decodeframe :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    ABOVE_SKIP := (ifx ABOVE_MI != null then cast,no_check(s32) ABOVE_MI.skip else 0);
    LEFT_SKIP := (ifx LEFT_MI != null then cast,no_check(s32) LEFT_MI.skip else 0);
    return ABOVE_SKIP + LEFT_SKIP;
}

vp9_get_skip_prob_in_vp9_decodeframe :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.skip_probs[vp9_get_skip_context_in_vp9_decodeframe(xd)];
}

get_pred_context_switchable_interp_in_vp9_decodeframe :: (xd: *MACROBLOCKD) -> s32 {
    LEFT_MI := xd.left_mi;
    LEFT_TYPE := (ifx LEFT_MI != null then cast,no_check(s32) LEFT_MI.interp_filter else 3);
    ABOVE_MI := xd.above_mi;
    ABOVE_TYPE := (ifx ABOVE_MI != null then cast,no_check(s32) ABOVE_MI.interp_filter else 3);

    if LEFT_TYPE == ABOVE_TYPE {
        return LEFT_TYPE;
    } else if LEFT_TYPE == 3 {
        return ABOVE_TYPE;
    } else if ABOVE_TYPE == 3 {
        return LEFT_TYPE;
    } else {
        return 3;
    }
}

get_intra_inter_context_in_vp9_decodeframe :: (xd: *MACROBLOCKD) -> s32 {
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    HAS_ABOVE := cast(s32) (ABOVE_MI != null);
    HAS_LEFT := cast(s32) (LEFT_MI != null);

    if HAS_ABOVE != 0 && HAS_LEFT != 0 {
        ABOVE_INTRA := cast(s32) (is_inter_block_in_vp9_decodeframe(ABOVE_MI) == 0);
        LEFT_INTRA := cast(s32) (is_inter_block_in_vp9_decodeframe(LEFT_MI) == 0);
        return ifx LEFT_INTRA != 0 && ABOVE_INTRA != 0 then 3 else cast(s32) (LEFT_INTRA != 0 || ABOVE_INTRA != 0);
    } else if HAS_ABOVE != 0 || HAS_LEFT != 0 {
        return 2 * cast(s32) (is_inter_block_in_vp9_decodeframe((ifx HAS_ABOVE != 0 then ABOVE_MI else LEFT_MI)) == 0);
    }
    return 0;
}

vp9_get_intra_inter_prob_in_vp9_decodeframe :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.intra_inter_prob[get_intra_inter_context_in_vp9_decodeframe(xd)];
}

vp9_get_reference_mode_prob_in_vp9_decodeframe :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return cm.fc.comp_inter_prob[vp9_get_reference_mode_context(cm, xd)];
}

vp9_get_pred_prob_comp_ref_p_in_vp9_decodeframe :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    PRED_CONTEXT := vp9_get_pred_context_comp_ref_p(cm, xd);
    return cm.fc.comp_ref_prob[PRED_CONTEXT];
}

vp9_get_pred_prob_single_ref_p1_in_vp9_decodeframe :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return ((cm.fc.single_ref_prob[vp9_get_pred_context_single_ref_p1(xd)]).data)[0];
}

vp9_get_pred_prob_single_ref_p2_in_vp9_decodeframe :: (cm: *VP9_COMMON, xd: *MACROBLOCKD) -> Prob {
    return ((cm.fc.single_ref_prob[vp9_get_pred_context_single_ref_p2(xd)]).data)[1];
}

get_tx_size_context_in_vp9_decodeframe :: (xd: *MACROBLOCKD) -> s32 {
    MAX_TX_SIZE := cast,no_check(s32) MAX_TXSIZE_LOOKUP[xd.mi[0].sb_type];
    ABOVE_MI := xd.above_mi;
    LEFT_MI := xd.left_mi;
    HAS_ABOVE := cast(s32) (ABOVE_MI != null);
    HAS_LEFT := cast(s32) (LEFT_MI != null);
    above_ctx := (ifx HAS_ABOVE != 0 && ABOVE_MI.skip == 0 then cast,no_check(s32) ABOVE_MI.tx_size else MAX_TX_SIZE);
    left_ctx := (ifx HAS_LEFT != 0 && LEFT_MI.skip == 0 then cast,no_check(s32) LEFT_MI.tx_size else MAX_TX_SIZE);
    if HAS_LEFT == 0 {
        left_ctx = above_ctx;
    }

    if HAS_ABOVE == 0 {
        above_ctx = left_ctx;
    }

    if above_ctx + left_ctx > MAX_TX_SIZE {
        return 1;
    }
    return 0;
}

get_tx_probs_in_vp9_decodeframe :: (max_tx_size: TX_SIZE, ctx: s32, tx_probs: *Tx_Probs) -> *Prob {
    if cast,no_check(s32) max_tx_size == {
        case cast,no_check(s32) cast(TX_SIZE) 1;
            return tx_probs.p8x8[ctx].data;
        case cast,no_check(s32) cast(TX_SIZE) 2;
            return tx_probs.p16x16[ctx].data;
        case cast,no_check(s32) cast(TX_SIZE) 3;
            return tx_probs.p32x32[ctx].data;
        case;
            return null;
    }
    return unreachable_value(*Prob);
}

get_tx_counts_in_vp9_decodeframe :: (max_tx_size: TX_SIZE, ctx: s32, tx_counts: *Tx_Counts) -> *u32 {
    if cast,no_check(s32) max_tx_size == {
        case cast,no_check(s32) cast(TX_SIZE) 1;
            return tx_counts.p8x8[ctx].data;
        case cast,no_check(s32) cast(TX_SIZE) 2;
            return tx_counts.p16x16[ctx].data;
        case cast,no_check(s32) cast(TX_SIZE) 3;
            return tx_counts.p32x32[ctx].data;
        case;
            return null;
    }
    return unreachable_value(*u32);
}

inter_predictor_in_vp9_decodeframe :: (
    src: *u8,
    src_stride: s32,
    dst: *u8,
    dst_stride: s32,
    SUBPEL_X: s32,
    SUBPEL_Y: s32,
    sf: *Scale_Factors,
    w: s32,
    h: s32,
    ref: s32,
    kernel: *Interp_Kernel,
    xs: s32,
    ys: s32
) {
    (cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s64, _: *Interp_Kernel, _: s32, _: s32, _: s32, _: s32, _: s32, _: s32)) (cast(*void) sf.predict[cast(s32) (SUBPEL_X != 0)][cast(s32) (SUBPEL_Y != 0)][ref]))(
        src,
        cast,no_check(s64) src_stride,
        dst,
        cast,no_check(s64) dst_stride,
        kernel,
        SUBPEL_X,
        xs,
        SUBPEL_Y,
        ys,
        w,
        h
    );
}

scaled_buffer_offset_in_vp9_decodeframe :: (x_offset: s32, y_offset: s32, stride: s32, sf: *Scale_Factors) -> s64 {
    X := (ifx sf != null then sf.scale_value_x(x_offset, sf) else x_offset);
    Y := (ifx sf != null then sf.scale_value_y(y_offset, sf) else y_offset);
    return ((cast,no_check(s64) Y) * cast(s64) stride) + cast(s64) X;
}

setup_pred_plane_in_vp9_decodeframe :: (
    dst: *Buf_2d,
    src: *u8,
    stride: s32,
    mi_row: s32,
    mi_col: s32,
    scale: *Scale_Factors,
    subsampling_x: s32,
    subsampling_y: s32
) {
    X := ((cast(s32) 1) << 3 * mi_col) >> ((subsampling_x) & 31);
    Y := ((cast(s32) 1) << 3 * mi_row) >> ((subsampling_y) & 31);
    dst.buf = src + scaled_buffer_offset_in_vp9_decodeframe(X, Y, stride, scale);
    dst.stride = stride;
}

vp9_read_sync_code :: (RB: *Read_Bit_Buffer) -> s32 {
    if rb_read_literal(RB, 8) == 0x49 && rb_read_literal(RB, 8) == 0x83 && rb_read_literal(RB, 8) == 0x42 {
        return 1;
    }
    return 0;
}

vp9_read_frame_size :: (rb: *Read_Bit_Buffer, width: *s32, height: *s32) {
    width.* = rb_read_literal(rb, 16) + 1;
    height.* = rb_read_literal(rb, 16) + 1;
}

vp9_read_profile :: (rb: *Read_Bit_Buffer) -> BITSTREAM_PROFILE {
    profile := rb_read_bit(rb);
    profile |= rb_read_bit(rb) << 1;
    if profile > 2 {
        profile += rb_read_bit(rb);
    }
    return cast,no_check(BITSTREAM_PROFILE) profile;
}

vp9_decode_frame :: (pbi: *VP9_Decoder, data: *u8, data_end: *u8, p_data_end: **u8) {
    CM := *pbi.common;
    XD := *pbi.mb;
    rb: Read_Bit_Buffer = ---;
    context_updated: s32 = 0;
    clear_data: [80] u8 = ---;
    FIRST_PARTITION_SIZE :=
        read_uncompressed_header(
            pbi,
            init_read_bit_buffer(pbi, *rb, data, data_end, clear_data.data)
        );
    TILE_ROWS := (cast(s32) 1) << ((CM.log2_tile_rows) & 31);
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    NEW_FB := get_frame_new_buffer_in_vp9_decodeframe(CM);

    XD.cur_buf = NEW_FB;

    if FIRST_PARTITION_SIZE == 0 {
        p_data_end.* = data + (ifx CM.profile <= cast,no_check(u32) PROFILE_2 then cast(s32) 1 else 2);
        return;
    }

    data += rb_bytes_read(*rb);
    if read_is_valid_in_vp9_decodeframe(data, FIRST_PARTITION_SIZE, data_end) == 0 {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
            c_string("Truncated packet or corrupt header length")
        );
    }

    CM.use_prev_frame_mvs =
        cast(s32) (CM.error_resilient_mode == 0 && CM.width == CM.last_width && CM.height == CM.last_height &&
            CM.last_intra_only == 0 && CM.last_show_frame != 0 && CM.last_frame_type != cast,no_check(u32) KEY_FRAME);

    vp9_setup_block_planes(XD, CM.subsampling_x, CM.subsampling_y);

    CM.fc.* = (cast(*Frame_Contexts) (CM.frame_contexts))[CM.frame_context_idx];
    if CM.fc.initialized == 0 {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
            c_string("Uninitialized entropy context.")
        );
    }

    XD.corrupted = 0;
    NEW_FB.corrupted = read_compressed_header(pbi, data, FIRST_PARTITION_SIZE);
    if NEW_FB.corrupted != 0 {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
            c_string("Decode failed. Frame data header is corrupted.")
        );
    }

    if CM.lf.filter_level != 0 && CM.skip_loop_filter == 0 {
        vp9_loop_filter_frame_init(CM, CM.lf.filter_level);
    }

    if pbi.tile_worker_data == null || TILE_COLS * TILE_ROWS != pbi.total_tiles {
        NUM_TILE_WORKERS := TILE_COLS * TILE_ROWS + (ifx pbi.max_threads > 1 then pbi.max_threads else 0);
        TWD_SIZE: u64 = (cast,no_check(u64) NUM_TILE_WORKERS) * size_of(Tile_Worker_Data);

        #assert ((cast,no_check(u64) (size_of(Tile_Worker_Data))) % 16) == 0;
        deallocate_memory(cast(*void) pbi.tile_worker_data);
        pbi.tile_worker_data = cast(*Tile_Worker_Data) memalign(32, TWD_SIZE);

        if pbi.tile_worker_data == null {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate pbi->tile_worker_data")
            );
        }
        pbi.total_tiles = TILE_ROWS * TILE_COLS;
    }

    if pbi.max_threads > 1 && TILE_ROWS == 1 && (TILE_COLS > 1 || pbi.row_mt == 1) {
        if pbi.row_mt == 1 {
            p_data_end.* = decode_tiles_row_wise_mt(pbi, data + FIRST_PARTITION_SIZE, data_end);
        } else {
            p_data_end.* = decode_tiles_mt(pbi, data + FIRST_PARTITION_SIZE, data_end);
            if pbi.lpf_mt_opt == 0 {
                if XD.corrupted == 0 {
                    if CM.skip_loop_filter == 0 {
                        vp9_loop_filter_frame_mt(
                            NEW_FB,
                            CM,
                            pbi.mb.plane.data,
                            CM.lf.filter_level,
                            0,
                            0,
                            pbi.tile_workers,
                            pbi.num_tile_workers,
                            *pbi.lf_row_sync
                        );
                    }
                } else {
                    internal_error(
                        *CM.error,
                        cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                        c_string("Decode failed. Frame data is corrupted.")
                    );
                }
            }
        }
    } else {
        p_data_end.* = decode_tiles(pbi, data + FIRST_PARTITION_SIZE, data_end);
    }

    if XD.corrupted == 0 {
        if CM.error_resilient_mode == 0 && CM.frame_parallel_decoding_mode == 0 {
            vp9_adapt_coef_probs(CM);

            if frame_is_intra_only_in_vp9_decodeframe(CM) == 0 {
                vp9_adapt_mode_probs(CM);
                vp9_adapt_mv_probs(CM, CM.allow_high_precision_mv);
            }
        }
    } else {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
            c_string("Decode failed. Frame data is corrupted.")
        );
    }

    if CM.refresh_frame_context != 0 && context_updated == 0 {
        (cast(*Frame_Contexts) (CM.frame_contexts))[CM.frame_context_idx] = CM.fc.*;
    }
}

init_read_bit_buffer :: (
    pbi: *VP9_Decoder,
    rb: *Read_Bit_Buffer,
    data: *u8,
    data_end: *u8,
    clear_data: *u8
) -> *Read_Bit_Buffer {
    rb.bit_offset = 0;
    rb.error_handler = error_handler;
    rb.error_handler_data = cast(*void) *pbi.common;
    if pbi.decrypt_cb != null {
        N := cast,no_check(s32) ((ifx 80 < data_end - data then 80 else data_end - data));
        pbi.decrypt_cb(pbi.decrypt_state, data, clear_data, N);
        rb.bit_buffer = clear_data;
        rb.bit_buffer_end = clear_data + N;
    } else {
        rb.bit_buffer = data;
        rb.bit_buffer_end = data_end;
    }
    return rb;
}

error_handler :: (data: *void) {
    CM := cast(*VP9_COMMON) data;
    internal_error(*CM.error, cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME, c_string("Truncated packet"));
}

read_uncompressed_header :: (pbi: *VP9_Decoder, rb: *Read_Bit_Buffer) -> u64 {
    CM := *pbi.common;
    POOL := CM.buffer_pool;
    FRAME_BUFS := POOL.frame_bufs.data;
    ref_index: s32 = 0;

    CM.last_frame_type = CM.frame_type;
    CM.last_intra_only = CM.intra_only;

    if rb_read_literal(rb, 2) != 0x2 {
        internal_error(*CM.error, cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM, c_string("Invalid frame marker"));
    }

    CM.profile = vp9_read_profile(rb);

    if CM.profile >= cast,no_check(u32) PROFILE_2 {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM,
            c_string("Unsupported bitstream profile")
        );
    }

    CM.show_existing_frame = rb_read_bit(rb);
    if CM.show_existing_frame != 0 {
        FRAME_TO_SHOW := CM.ref_frame_map[rb_read_literal(rb, 3)];
        if FRAME_TO_SHOW < 0 || FRAME_BUFS[FRAME_TO_SHOW].ref_count < 1 {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM,
                c_string("Buffer %d does not contain a decoded frame"),
                FRAME_TO_SHOW
            );
        }

        ref_cnt_fb_in_vp9_decodeframe(FRAME_BUFS, *CM.new_fb_idx, FRAME_TO_SHOW);
        pbi.refresh_frame_flags = 0;
        CM.lf.filter_level = 0;
        CM.show_frame = 1;

        return 0;
    }

    CM.frame_type = cast,no_check(FRAME_TYPE) rb_read_bit(rb);
    CM.show_frame = rb_read_bit(rb);
    CM.error_resilient_mode = rb_read_bit(rb);

    if CM.frame_type == cast,no_check(u32) KEY_FRAME {
        if vp9_read_sync_code(rb) == 0 {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM,
                c_string("Invalid frame sync code")
            );
        }

        read_bitdepth_colorspace_sampling(CM, rb);
        pbi.refresh_frame_flags = (cast(s32) 1) << ((((cast(s32) 1) << 3)) & 31) - 1;

        for i: 0..cast(s32) 3 - 1 {
            CM.frame_refs[i].idx = -1;
            CM.frame_refs[i].buf = null;
        }

        setup_frame_size(CM, rb);
        if pbi.need_resync != 0 {
            fill_memory(*CM.ref_frame_map, -1, CM.ref_frame_map.count * size_of(s32));
            flush_all_fb_on_key(CM);
            pbi.need_resync = 0;
        }
    } else {
        CM.intra_only = cast,no_check(u8) ((ifx CM.show_frame != 0 then 0 else rb_read_bit(rb)));

        CM.reset_frame_context = ifx CM.error_resilient_mode != 0 then 0 else rb_read_literal(rb, 2);

        if CM.intra_only != 0 {
            if vp9_read_sync_code(rb) == 0 {
                internal_error(
                    *CM.error,
                    cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM,
                    c_string("Invalid frame sync code")
                );
            }
            if CM.profile > cast,no_check(u32) PROFILE_0 {
                read_bitdepth_colorspace_sampling(CM, rb);
            } else {
                CM.color_space = cast,no_check(Color_Space_T) CS_BT_601;
                CM.color_range = cast,no_check(Color_Range_T) CR_STUDIO_RANGE;
                CM.subsampling_x = 1;
                CM.subsampling_y = CM.subsampling_x;
                CM.bit_depth = cast,no_check(Bit_Depth_T) BITS_8;
            }

            pbi.refresh_frame_flags = rb_read_literal(rb, (cast(s32) 1) << 3);
            setup_frame_size(CM, rb);
            if pbi.need_resync != 0 {
                fill_memory(*CM.ref_frame_map, -1, CM.ref_frame_map.count * size_of(s32));
                pbi.need_resync = 0;
            }
        } else if pbi.need_resync != 1 {
            pbi.refresh_frame_flags = rb_read_literal(rb, (cast(s32) 1) << 3);
            for i: 0..cast(s32) 3 - 1 {
                REF := rb_read_literal(rb, 3);
                IDX := CM.ref_frame_map[REF];
                if IDX == -1 {
                    internal_error(
                        *CM.error,
                        cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                        c_string("Invalid reference frame index")
                    );
                }

                REF_FRAME := CM.frame_refs.data + i;
                REF_FRAME.idx = IDX;
                REF_FRAME.buf = *FRAME_BUFS[IDX].buf;
                CM.ref_frame_sign_bias[1 + i] = rb_read_bit(rb);
            }

            setup_frame_size_with_refs(CM, rb);

            CM.allow_high_precision_mv = rb_read_bit(rb);
            CM.interp_filter = read_interp_filter(rb);

            for i: 0..cast(s32) 3 - 1 {
                REF_BUF := CM.frame_refs.data + i;

                vp9_setup_scale_factors_for_frame(
                    *REF_BUF.sf,
                    REF_BUF.buf.y_crop_width,
                    REF_BUF.buf.y_crop_height,
                    CM.width,
                    CM.height
                );
            }
        }
    }

    assignment_2: Color_Space_T = CM.color_space;
    ((get_frame_new_buffer_in_vp9_decodeframe(CM)).color_space) = assignment_2;
    assignment_3: Color_Range_T = CM.color_range;
    ((get_frame_new_buffer_in_vp9_decodeframe(CM)).color_range) = assignment_3;
    assignment_4: s32 = CM.render_width;
    ((get_frame_new_buffer_in_vp9_decodeframe(CM)).render_width) = assignment_4;
    assignment_5: s32 = CM.render_height;
    ((get_frame_new_buffer_in_vp9_decodeframe(CM)).render_height) = assignment_5;

    if pbi.need_resync != 0 {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
            c_string("Keyframe / intra-only frame required to reset decoder state")
        );
    }

    if CM.error_resilient_mode == 0 {
        CM.refresh_frame_context = rb_read_bit(rb);
        CM.frame_parallel_decoding_mode = rb_read_bit(rb);
        if CM.frame_parallel_decoding_mode == 0 {
            fill_memory(*CM.counts, 0, size_of(FRAME_COUNTS));
        }
    } else {
        CM.refresh_frame_context = 0;
        CM.frame_parallel_decoding_mode = 1;
    }

    CM.frame_context_idx = cast,no_check(u32) rb_read_literal(rb, 2);

    mask := pbi.refresh_frame_flags;
    while mask != 0 {
        if mask & 1 != 0 {
            CM.next_ref_frame_map[ref_index] = CM.new_fb_idx;
            FRAME_BUFS[CM.new_fb_idx].ref_count += 1;
        } else {
            CM.next_ref_frame_map[ref_index] = CM.ref_frame_map[ref_index];
        }

        if CM.ref_frame_map[ref_index] >= 0 {
            FRAME_BUFS[CM.ref_frame_map[ref_index]].ref_count += 1;
        }
        ref_index += 1;
        c_transpiler_compound_shr(*(mask), (cast(s32) 1), s32, s32);
    }

    while ref_index < (cast(s32) 1) << 3 {
        CM.next_ref_frame_map[ref_index] = CM.ref_frame_map[ref_index];

        if CM.ref_frame_map[ref_index] >= 0 {
            FRAME_BUFS[CM.ref_frame_map[ref_index]].ref_count += 1;
        }
        ref_index += 1;
    }
    pbi.hold_ref_buf = 1;

    if frame_is_intra_only_in_vp9_decodeframe(CM) != 0 || CM.error_resilient_mode != 0 {
        vp9_setup_past_independence(CM);
    }

    setup_loopfilter(*CM.lf, rb);
    setup_quantization(CM, *pbi.mb, rb);
    setup_segmentation(*CM.seg, rb);
    setup_segmentation_dequant(CM);

    setup_tile_info(CM, rb);
    if pbi.row_mt == 1 {
        num_sbs: s32 = 1;
        ALIGNED_ROWS := mi_cols_aligned_to_sb_in_vp9_decodeframe(CM.mi_rows);
        SB_ROWS := ALIGNED_ROWS >> (((6 - 3)) & 31);
        NUM_JOBS := SB_ROWS << ((CM.log2_tile_cols) & 31);

        if pbi.row_mt_worker_data == null {
            pbi.row_mt_worker_data = cast(*Row_MT_Worker_Data) calloc_2(1, size_of(Row_MT_Worker_Data));

            if pbi.row_mt_worker_data == null {
                internal_error(
                    *CM.error,
                    cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                    c_string("Failed to allocate pbi->row_mt_worker_data")
                );
            }

            pthread_mutex_init(*pbi.row_mt_worker_data.recon_done_mutex, null);
        }

        if pbi.max_threads > 1 {
            ALIGNED_COLS := mi_cols_aligned_to_sb_in_vp9_decodeframe(CM.mi_cols);
            SB_COLS := ALIGNED_COLS >> (((6 - 3)) & 31);

            num_sbs = SB_COLS * SB_ROWS;
        }

        if num_sbs > pbi.row_mt_worker_data.num_sbs || NUM_JOBS > pbi.row_mt_worker_data.num_jobs {
            vp9_dec_free_row_mt_mem(pbi.row_mt_worker_data);
            vp9_dec_alloc_row_mt_mem(pbi.row_mt_worker_data, CM, num_sbs, pbi.max_threads, NUM_JOBS);
        }
        vp9_jobq_alloc(pbi);
    }
    sz := cast,no_check(u64) rb_read_literal(rb, 16);

    if sz == 0 {
        internal_error(*CM.error, cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME, c_string("Invalid header size"));
    }

    return sz;
}

vp9_jobq_alloc :: (pbi: *VP9_Decoder) {
    CM := *pbi.common;
    ROW_MT_WORKER_DATA := pbi.row_mt_worker_data;
    ALIGNED_ROWS := mi_cols_aligned_to_sb_in_vp9_decodeframe(CM.mi_rows);
    SB_ROWS := ALIGNED_ROWS >> (((6 - 3)) & 31);
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    JOBQ_SIZE: u64 = (cast,no_check(u64) (TILE_COLS * SB_ROWS * 2 + SB_ROWS)) * size_of(Job);

    if JOBQ_SIZE > ROW_MT_WORKER_DATA.jobq_size {
        deallocate_memory(cast(*void) ROW_MT_WORKER_DATA.jobq_buf);
        ROW_MT_WORKER_DATA.jobq_buf = cast(*u8) calloc_2(1, JOBQ_SIZE);

        if ROW_MT_WORKER_DATA.jobq_buf == null {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate row_mt_worker_data->jobq_buf")
            );
        }
        (cast,no_check(#type (_: *Job_Queue_Row_Mt, _: *u8, _: u64)) (cast(*void) vp9_jobq_init))(
            *ROW_MT_WORKER_DATA.jobq,
            ROW_MT_WORKER_DATA.jobq_buf,
            JOBQ_SIZE
        );
        ROW_MT_WORKER_DATA.jobq_size = JOBQ_SIZE;
    }
}

setup_tile_info :: (cm: *VP9_COMMON, rb: *Read_Bit_Buffer) {
    min_log2_tile_cols: s32 = ---;
    max_log2_tile_cols: s32 = ---;
    vp9_get_tile_n_bits(cm.mi_cols, *min_log2_tile_cols, *max_log2_tile_cols);

    max_ones := max_log2_tile_cols - min_log2_tile_cols;
    cm.log2_tile_cols = min_log2_tile_cols;
    while ((c_transpiler_post_decrement(*(max_ones))) != 0) && rb_read_bit(rb) != 0 {
        cm.log2_tile_cols += 1;
    }

    if cm.log2_tile_cols > 6 {
        internal_error(
            *cm.error,
            cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
            c_string("Invalid number of tile columns")
        );
    }

    cm.log2_tile_rows = rb_read_bit(rb);
    if cm.log2_tile_rows != 0 {
        cm.log2_tile_rows += rb_read_bit(rb);
    }
}

setup_segmentation_dequant :: (CM: *VP9_COMMON) {
    if CM.seg.enabled != 0 {
        for i: 0..cast(s32) 8 - 1 {
            QINDEX := vp9_get_qindex(*CM.seg, i, CM.base_qindex);
            CM.y_dequant[i][0] = vp9_dc_quant(QINDEX, CM.y_dc_delta_q, CM.bit_depth);
            CM.y_dequant[i][1] = vp9_ac_quant(QINDEX, 0, CM.bit_depth);
            CM.uv_dequant[i][0] = vp9_dc_quant(QINDEX, CM.uv_dc_delta_q, CM.bit_depth);
            CM.uv_dequant[i][1] = vp9_ac_quant(QINDEX, CM.uv_ac_delta_q, CM.bit_depth);
        }
    } else {
        QINDEX := CM.base_qindex;

        CM.y_dequant[0][0] = vp9_dc_quant(QINDEX, CM.y_dc_delta_q, CM.bit_depth);
        CM.y_dequant[0][1] = vp9_ac_quant(QINDEX, 0, CM.bit_depth);
        CM.uv_dequant[0][0] = vp9_dc_quant(QINDEX, CM.uv_dc_delta_q, CM.bit_depth);
        CM.uv_dequant[0][1] = vp9_ac_quant(QINDEX, CM.uv_ac_delta_q, CM.bit_depth);
    }
}

setup_segmentation :: (seg: *Segmentation, rb: *Read_Bit_Buffer) {
    j: s32 = ---;

    seg.update_map = 0;
    seg.update_data = 0;

    seg.enabled = cast,no_check(u8) rb_read_bit(rb);
    if seg.enabled == 0 {
        return;
    }

    seg.update_map = cast,no_check(u8) rb_read_bit(rb);
    if seg.update_map != 0 {
        for i: 0..cast(s32) (8 - 1) - 1 {
            seg.tree_probs[i] = cast,no_check(Prob) ((ifx rb_read_bit(rb) != 0 then rb_read_literal(rb, 8) else 255));
        }

        seg.temporal_update = cast,no_check(u8) rb_read_bit(rb);
        if seg.temporal_update != 0 {
            for i: 0..cast(s32) 3 - 1 {
                seg.pred_probs[i] =
                    cast,no_check(Prob) ((ifx rb_read_bit(rb) != 0 then rb_read_literal(rb, 8) else 255));
            }
        } else {
            for i: 0..cast(s32) 3 - 1 {
                seg.pred_probs[i] = 255;
            }
        }
    }

    seg.update_data = cast,no_check(u8) rb_read_bit(rb);
    if seg.update_data != 0 {
        seg.abs_delta = cast,no_check(u8) rb_read_bit(rb);

        vp9_clearall_segfeatures(seg);

        for i: 0..cast(s32) 8 - 1 {
            j = 0;
            while j < SEG_LVL_MAX {
                data: s32 = 0;
                FEATURE_ENABLED := rb_read_bit(rb);
                if FEATURE_ENABLED != 0 {
                    vp9_enable_segfeature(seg, i, cast,no_check(SEG_LVL_FEATURES) j);
                    data = decode_unsigned_max(rb, vp9_seg_feature_data_max(cast,no_check(SEG_LVL_FEATURES) j));
                    if vp9_is_segfeature_signed(cast,no_check(SEG_LVL_FEATURES) j) != 0 {
                        data = ifx rb_read_bit(rb) != 0 then -data else data;
                    }
                }
                vp9_set_segdata(seg, i, cast,no_check(SEG_LVL_FEATURES) j, data);
                j += 1;
            }
        }
    }
}

decode_unsigned_max :: (rb: *Read_Bit_Buffer, max: s32) -> s32 {
    DATA := rb_read_literal(rb, get_unsigned_bits_in_vp9_decodeframe(cast,no_check(u32) max));
    return ifx DATA > max then max else DATA;
}

setup_quantization :: (CM: *VP9_COMMON, XD: *MACROBLOCKD, rb: *Read_Bit_Buffer) {
    CM.base_qindex = rb_read_literal(rb, 8);
    CM.y_dc_delta_q = read_delta_q(rb);
    CM.uv_dc_delta_q = read_delta_q(rb);
    CM.uv_ac_delta_q = read_delta_q(rb);
    CM.dequant_bit_depth = CM.bit_depth;
    XD.lossless =
        cast(s32) (CM.base_qindex == 0 && CM.y_dc_delta_q == 0 &&
            CM.uv_dc_delta_q == 0 && CM.uv_ac_delta_q == 0);
}

read_delta_q :: (rb: *Read_Bit_Buffer) -> s32 {
    return ifx rb_read_bit(rb) != 0 then rb_read_signed_literal(rb, 4) else 0;
}

setup_loopfilter :: (lf: *Loopfilter, rb: *Read_Bit_Buffer) {
    lf.filter_level = rb_read_literal(rb, 6);
    lf.sharpness_level = rb_read_literal(rb, 3);

    lf.mode_ref_delta_update = 0;

    lf.mode_ref_delta_enabled = cast,no_check(u8) rb_read_bit(rb);
    if lf.mode_ref_delta_enabled != 0 {
        lf.mode_ref_delta_update = cast,no_check(u8) rb_read_bit(rb);
        if lf.mode_ref_delta_update != 0 {
            for i: 0..cast(s32) 4 - 1 {
                if rb_read_bit(rb) != 0 {
                    lf.ref_deltas[i] = cast,no_check(s8) rb_read_signed_literal(rb, 6);
                }
            }

            for i: 0..cast(s32) 2 - 1 {
                if rb_read_bit(rb) != 0 {
                    lf.mode_deltas[i] = cast,no_check(s8) rb_read_signed_literal(rb, 6);
                }
            }
        }
    }
}

read_interp_filter :: (rb: *Read_Bit_Buffer) -> INTERP_FILTER {
    LITERAL_TO_FILTER := INTERP_FILTER.[ 1, 0, 2, 3 ];
    return cast,no_check(INTERP_FILTER) ((ifx rb_read_bit(rb) != 0 then 4 else cast,no_check(s32) (LITERAL_TO_FILTER[rb_read_literal(rb, 2)])));
}

setup_frame_size_with_refs :: (cm: *VP9_COMMON, rb: *Read_Bit_Buffer) {
    width, height: s32 = ---;
    found: s32 = 0;
    has_valid_ref_frame: s32 = 0;
    POOL := cm.buffer_pool;
    for i: 0..cast(s32) 3 - 1 {
        if rb_read_bit(rb) != 0 {
            BUF := cm.frame_refs[i].buf;
            width = BUF.y_crop_width;
            height = BUF.y_crop_height;
            found = 1;
            break;
        }
    }

    if found == 0 {
        vp9_read_frame_size(rb, *width, *height);
    }

    if width <= 0 || height <= 0 {
        internal_error(*cm.error, cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME, c_string("Invalid frame size"));
    }

    for i: 0..cast(s32) 3 - 1 {
        REF_FRAME := cm.frame_refs.data + i;

        has_valid_ref_frame |=
            valid_ref_frame_size_in_vp9_decodeframe(
                REF_FRAME.buf.y_crop_width,
                REF_FRAME.buf.y_crop_height,
                width,
                height
            );
    }
    if has_valid_ref_frame == 0 {
        internal_error(
            *cm.error,
            cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
            c_string("Referenced frame has invalid size")
        );
    }
    for i: 0..cast(s32) 3 - 1 {
        REF_FRAME := cm.frame_refs.data + i;

        if valid_ref_frame_img_fmt(
            REF_FRAME.buf.bit_depth,
            REF_FRAME.buf.subsampling_x,
            REF_FRAME.buf.subsampling_y,
            cm.bit_depth,
            cm.subsampling_x,
            cm.subsampling_y
        ) == 0 {
            internal_error(
                *cm.error,
                cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                c_string("Referenced frame has incompatible color format")
            );
        }
    }

    resize_context_buffers(cm, width, height);
    setup_render_size(cm, rb);

    if realloc_frame_buffer(
        get_frame_new_buffer_in_vp9_decodeframe(cm),
        cm.width,
        cm.height,
        cm.subsampling_x,
        cm.subsampling_y,
        32,
        cm.byte_alignment,
        *POOL.frame_bufs[cm.new_fb_idx].raw_frame_buffer,
        cast,no_check(Get_Frame_Buffer_Cb_Fn_T) (POOL.get_fb_cb),
        POOL.cb_priv
    ) != 0 {
        internal_error(
            *cm.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate frame buffer")
        );
    }

    POOL.frame_bufs[cm.new_fb_idx].released = 0;
    POOL.frame_bufs[cm.new_fb_idx].buf.subsampling_x = cm.subsampling_x;
    POOL.frame_bufs[cm.new_fb_idx].buf.subsampling_y = cm.subsampling_y;
    POOL.frame_bufs[cm.new_fb_idx].buf.bit_depth = cm.bit_depth;
    POOL.frame_bufs[cm.new_fb_idx].buf.color_space = cm.color_space;
    POOL.frame_bufs[cm.new_fb_idx].buf.color_range = cm.color_range;
    POOL.frame_bufs[cm.new_fb_idx].buf.render_width = cm.render_width;
    POOL.frame_bufs[cm.new_fb_idx].buf.render_height = cm.render_height;
}

setup_render_size :: (cm: *VP9_COMMON, rb: *Read_Bit_Buffer) {
    cm.render_width = cm.width;
    cm.render_height = cm.height;
    if rb_read_bit(rb) != 0 {
        vp9_read_frame_size(rb, *cm.render_width, *cm.render_height);
    }
}

resize_context_buffers :: (cm: *VP9_COMMON, width: s32, height: s32) {
    if cm.width != width || cm.height != height {
        NEW_MI_ROWS := (height + ((cast(s32) 1) << 3 - 1)) & ~((cast(s32) 1) << 3 - 1) >> 3;
        NEW_MI_COLS := (width + ((cast(s32) 1) << 3 - 1)) & ~((cast(s32) 1) << 3 - 1) >> 3;

        if NEW_MI_COLS > cm.mi_cols || NEW_MI_ROWS > cm.mi_rows {
            if vp9_alloc_context_buffers(cm, width, height) != 0 {
                cm.width = 0;
                cm.height = 0;
                internal_error(
                    *cm.error,
                    cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                    c_string("Failed to allocate context buffers")
                );
            }
        } else {
            vp9_set_mb_mi(cm, width, height);
        }
        vp9_init_context_buffers(cm);
        cm.width = width;
        cm.height = height;
    }
    if cm.cur_frame.mvs == null || cm.mi_rows > cm.cur_frame.mi_rows || cm.mi_cols > cm.cur_frame.mi_cols {
        resize_mv_buffer(cm);
    }
}

resize_mv_buffer :: (cm: *VP9_COMMON) {
    deallocate_memory(cast(*void) cm.cur_frame.mvs);
    cm.cur_frame.mi_rows = cm.mi_rows;
    cm.cur_frame.mi_cols = cm.mi_cols;
    cm.cur_frame.mvs =
        cast(*MV_REF) calloc_2(
            cast,no_check(u64) (cm.mi_rows * cm.mi_cols),
            size_of(MV_REF)
        );

    if cm.cur_frame.mvs == null {
        internal_error(
            *cm.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate cm->cur_frame->mvs")
        );
    }
}

valid_ref_frame_img_fmt :: (
    ref_bit_depth: Bit_Depth_T,
    ref_xss: s32,
    ref_yss: s32,
    this_bit_depth: Bit_Depth_T,
    this_xss: s32,
    this_yss: s32
) -> s32 {
    if ref_bit_depth == this_bit_depth && ref_xss == this_xss && ref_yss == this_yss {
        return 1;
    }
    return 0;
}

setup_frame_size :: (cm: *VP9_COMMON, rb: *Read_Bit_Buffer) {
    width, height: s32 = ---;
    POOL := cm.buffer_pool;
    vp9_read_frame_size(rb, *width, *height);
    resize_context_buffers(cm, width, height);
    setup_render_size(cm, rb);

    if realloc_frame_buffer(
        get_frame_new_buffer_in_vp9_decodeframe(cm),
        cm.width,
        cm.height,
        cm.subsampling_x,
        cm.subsampling_y,
        32,
        cm.byte_alignment,
        *POOL.frame_bufs[cm.new_fb_idx].raw_frame_buffer,
        cast,no_check(Get_Frame_Buffer_Cb_Fn_T) (POOL.get_fb_cb),
        POOL.cb_priv
    ) != 0 {
        internal_error(
            *cm.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate frame buffer")
        );
    }

    POOL.frame_bufs[cm.new_fb_idx].released = 0;
    POOL.frame_bufs[cm.new_fb_idx].buf.subsampling_x = cm.subsampling_x;
    POOL.frame_bufs[cm.new_fb_idx].buf.subsampling_y = cm.subsampling_y;
    POOL.frame_bufs[cm.new_fb_idx].buf.bit_depth = cm.bit_depth;
    POOL.frame_bufs[cm.new_fb_idx].buf.color_space = cm.color_space;
    POOL.frame_bufs[cm.new_fb_idx].buf.color_range = cm.color_range;
    POOL.frame_bufs[cm.new_fb_idx].buf.render_width = cm.render_width;
    POOL.frame_bufs[cm.new_fb_idx].buf.render_height = cm.render_height;
}

read_bitdepth_colorspace_sampling :: (cm: *VP9_COMMON, rb: *Read_Bit_Buffer) {
    if cm.profile >= cast,no_check(u32) PROFILE_2 {
        cm.bit_depth =
            cast,no_check(Bit_Depth_T) ((ifx rb_read_bit(rb) != 0 then cast,no_check(s32) (BITS_12) else cast,no_check(s32) (BITS_10)));
    } else {
        cm.bit_depth = cast,no_check(Bit_Depth_T) BITS_8;
    }
    cm.color_space = cast,no_check(Color_Space_T) rb_read_literal(rb, 3);
    if cm.color_space != cast,no_check(u32) CS_SRGB {
        cm.color_range = cast,no_check(Color_Range_T) rb_read_bit(rb);
        if cm.profile == cast,no_check(u32) PROFILE_1 || cm.profile == cast,no_check(u32) PROFILE_3 {
            cm.subsampling_x = rb_read_bit(rb);
            cm.subsampling_y = rb_read_bit(rb);
            if cm.subsampling_x == 1 && cm.subsampling_y == 1 {
                internal_error(
                    *cm.error,
                    cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM,
                    c_string("4:2:0 color not supported in profile 1 or 3")
                );
            }
            if rb_read_bit(rb) != 0 {
                internal_error(
                    *cm.error,
                    cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM,
                    c_string("Reserved bit set")
                );
            }
        } else {
            cm.subsampling_x = 1;
            cm.subsampling_y = cm.subsampling_x;
        }
    } else {
        cm.color_range = cast,no_check(Color_Range_T) CR_FULL_RANGE;
        if cm.profile == cast,no_check(u32) PROFILE_1 || cm.profile == cast,no_check(u32) PROFILE_3 {
            cm.subsampling_x = 0;
            cm.subsampling_y = cm.subsampling_x;
            if rb_read_bit(rb) != 0 {
                internal_error(
                    *cm.error,
                    cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM,
                    c_string("Reserved bit set")
                );
            }
        } else {
            internal_error(
                *cm.error,
                cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM,
                c_string("4:4:4 color not supported in profile 0 or 2")
            );
        }
    }
}

flush_all_fb_on_key :: (cm: *VP9_COMMON) {
    if cm.frame_type == cast,no_check(u32) KEY_FRAME && cm.current_video_frame > 0 {
        FRAME_BUFS := cm.buffer_pool.frame_bufs.data;
        POOL := cm.buffer_pool;

        for i: 0..cast(s32) ((cast(s32) 1) << 3 + 1 + 3) - 1 {
            if i == cm.new_fb_idx {
                continue;
            }
            FRAME_BUFS[i].ref_count = 0;
            if FRAME_BUFS[i].released == 0 {
                POOL.release_fb_cb(POOL.cb_priv, *FRAME_BUFS[i].raw_frame_buffer);
                FRAME_BUFS[i].released = 1;
            }
        }
    }
}

decode_tiles :: (pbi: *VP9_Decoder, data: *u8, data_end: *u8) -> *u8 {
    CM := *pbi.common;
    WINTERFACE := get_worker_interface();
    ALIGNED_COLS := mi_cols_aligned_to_sb_in_vp9_decodeframe(CM.mi_cols);
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    TILE_ROWS := (cast(s32) 1) << ((CM.log2_tile_rows) & 31);
    tile_buffers: [4] [64] Tile_Buffer = ---;
    tile_col: s32 = ---;
    mi_row, mi_col: s32 = ---;
    tile_data: *Tile_Worker_Data = null;

    if CM.lf.filter_level != 0 && CM.skip_loop_filter == 0 && pbi.lf_worker.data1 == null {
        pbi.lf_worker.data1 = memalign(32, size_of(LF_Worker_Data));

        if pbi.lf_worker.data1 == null {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate pbi->lf_worker.data1")
            );
        }
        pbi.lf_worker.hook = vp9_loop_filter_worker;
        if pbi.max_threads > 1 && WINTERFACE.reset(*pbi.lf_worker) == 0 {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_ERROR,
                c_string("Loop filter thread creation failed")
            );
        }
    }

    if CM.lf.filter_level != 0 && CM.skip_loop_filter == 0 {
        LF_DATA := cast(*LF_Worker_Data) pbi.lf_worker.data1;

        WINTERFACE.sync(*pbi.lf_worker);
        vp9_loop_filter_data_reset(LF_DATA, get_frame_new_buffer_in_vp9_decodeframe(CM), CM, pbi.mb.plane.data);
    }

    fill_memory(
        CM.above_context,
        0,
        (((cast,no_check(u64) (size_of(ENTROPY_CONTEXT))) * 3) * 2) * cast,no_check(u64) ALIGNED_COLS
    );

    fill_memory(CM.above_seg_context, 0, cast,no_check(u64) ALIGNED_COLS);

    vp9_reset_lfm(CM);

    get_tile_buffers(pbi, data, data_end, TILE_COLS, TILE_ROWS, tile_buffers.data);

    if 0 < TILE_ROWS {
        for tile_row: 0..TILE_ROWS - 1 {
            tile_col = 0;
            while tile_col < TILE_COLS {
                BUF := tile_buffers[tile_row].data + tile_col;
                tile_data = pbi.tile_worker_data + TILE_COLS * tile_row + tile_col;
                tile_data.xd = pbi.mb;
                tile_data.xd.corrupted = 0;
                tile_data.xd.counts = ifx CM.frame_parallel_decoding_mode != 0 then null else *CM.counts;
                fill_memory(*tile_data.dqcoeff, 0, tile_data.dqcoeff.count * size_of(Tran_Low_T));
                vp9_tile_init(*tile_data.xd.tile, CM, tile_row, tile_col);
                setup_token_decoder_in_vp9_decodeframe(
                    BUF.data,
                    data_end,
                    BUF.size,
                    *CM.error,
                    *tile_data.bit_reader,
                    cast,no_check(Decrypt_Cb) (pbi.decrypt_cb),
                    pbi.decrypt_state
                );
                vp9_init_macroblockd_in_vp9_decodeframe(CM, *tile_data.xd, tile_data.dqcoeff.data);
                tile_col += 1;
            }
        }
    }

    if 0 < TILE_ROWS {
        for tile_row: 0..TILE_ROWS - 1 {
            tile: Tile_Info = ---;
            vp9_tile_set_row(*tile, CM, tile_row);
            mi_row = tile.mi_row_start;
            while mi_row < tile.mi_row_end {
                tile_col = 0;
                while tile_col < TILE_COLS {
                    COL := (ifx pbi.inv_tile_order != 0 then TILE_COLS - tile_col - 1 else tile_col);
                    tile_data = pbi.tile_worker_data + TILE_COLS * tile_row + COL;
                    vp9_tile_set_col(*tile, CM, COL);
                    fill_memory(
                        *tile_data.xd.left_context,
                        0,
                        tile_data.xd.left_context.count * size_of([16] ENTROPY_CONTEXT)
                    );
                    fill_memory(*tile_data.xd.left_seg_context, 0, tile_data.xd.left_seg_context.count);
                    mi_col = tile.mi_col_start;
                    while mi_col < tile.mi_col_end {
                        if pbi.row_mt == 1 {
                            ROW_MT_WORKER_DATA := pbi.row_mt_worker_data;
                            for plane: 0..cast(s32) 3 - 1 {
                                tile_data.xd.plane[plane].eob = ROW_MT_WORKER_DATA.eob[plane];
                                tile_data.xd.plane[plane].dqcoeff = ROW_MT_WORKER_DATA.dqcoeff[plane];
                            }
                            tile_data.xd.partition = ROW_MT_WORKER_DATA.partition;
                            process_partition(
                                tile_data,
                                pbi,
                                mi_row,
                                mi_col,
                                12,
                                4,
                                cast,no_check(s32) (PARSE),
                                cast,no_check(Process_Block_Fn_T) parse_block
                            );

                            for plane: 0..cast(s32) 3 - 1 {
                                tile_data.xd.plane[plane].eob = ROW_MT_WORKER_DATA.eob[plane];
                                tile_data.xd.plane[plane].dqcoeff = ROW_MT_WORKER_DATA.dqcoeff[plane];
                            }
                            tile_data.xd.partition = ROW_MT_WORKER_DATA.partition;
                            process_partition(
                                tile_data,
                                pbi,
                                mi_row,
                                mi_col,
                                12,
                                4,
                                cast,no_check(s32) (RECON),
                                cast,no_check(Process_Block_Fn_T) recon_block
                            );
                        } else {
                            decode_partition(tile_data, pbi, mi_row, mi_col, 12, 4);
                        }
                        mi_col += (cast(s32) 1) << (((6 - 3)) & 31);
                    }
                    pbi.mb.corrupted |= tile_data.xd.corrupted;
                    if pbi.mb.corrupted != 0 {
                        internal_error(
                            *CM.error,
                            cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                            c_string("Failed to decode tile data")
                        );
                    }
                    tile_col += 1;
                }

                if CM.lf.filter_level != 0 && CM.skip_loop_filter == 0 {
                    LF_START := mi_row - (cast(s32) 1) << (((6 - 3)) & 31);
                    LF_DATA := cast(*LF_Worker_Data) pbi.lf_worker.data1;

                    if LF_START < 0 {
                        mi_row += (cast(s32) 1) << (((6 - 3)) & 31);
                        continue;
                    }

                    if mi_row + (cast(s32) 1) << (((6 - 3)) & 31) >= CM.mi_rows {
                        mi_row += (cast(s32) 1) << (((6 - 3)) & 31);
                        continue;
                    }

                    WINTERFACE.sync(*pbi.lf_worker);
                    LF_DATA.start = LF_START;
                    LF_DATA.stop = mi_row;
                    if pbi.max_threads > 1 {
                        WINTERFACE.launch(*pbi.lf_worker);
                    } else {
                        WINTERFACE.execute(*pbi.lf_worker);
                    }
                }
                mi_row += (cast(s32) 1) << (((6 - 3)) & 31);
            }
        }
    }

    if CM.lf.filter_level != 0 && CM.skip_loop_filter == 0 {
        LF_DATA := cast(*LF_Worker_Data) pbi.lf_worker.data1;
        WINTERFACE.sync(*pbi.lf_worker);
        LF_DATA.start = LF_DATA.stop;
        LF_DATA.stop = CM.mi_rows;
        WINTERFACE.execute(*pbi.lf_worker);
    }

    tile_data = pbi.tile_worker_data + TILE_COLS * TILE_ROWS - 1;

    return reader_find_end(*tile_data.bit_reader);
}

decode_partition :: (
    twd: *Tile_Worker_Data,
    PBI: *VP9_Decoder,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE,
    n4x4_l2: s32
) {
    CM := *PBI.common;
    N8X8_L2 := n4x4_l2 - 1;
    NUM_8X8_WH := (cast(s32) 1) << ((N8X8_L2) & 31);
    HBS := NUM_8X8_WH >> 1;

    HAS_ROWS := cast(s32) (mi_row + HBS < CM.mi_rows);
    HAS_COLS := cast(s32) (mi_col + HBS < CM.mi_cols);
    XD := *twd.xd;

    if mi_row >= CM.mi_rows || mi_col >= CM.mi_cols {
        return;
    }

    partition := read_partition(twd, mi_row, mi_col, HAS_ROWS, HAS_COLS, N8X8_L2);
    subsize := SUBSIZE_LOOKUP[partition][bsize];
    if HBS == 0 {
        XD.bmode_blocks_wl =
            cast,no_check(u8) ((cast(s32) 1) >> ((cast(s32) (partition & cast,no_check(u32) PARTITION_VERT != 0)) & 31));
        XD.bmode_blocks_hl =
            cast,no_check(u8) ((cast(s32) 1) >> ((cast(s32) (partition & cast,no_check(u32) PARTITION_HORZ != 0)) & 31));
        decode_block(twd, PBI, mi_row, mi_col, subsize, 1, 1);
    } else {
        if partition == {
            case cast,no_check(u32) PARTITION_NONE;
                decode_block(twd, PBI, mi_row, mi_col, subsize, n4x4_l2, n4x4_l2);
            case cast,no_check(u32) PARTITION_HORZ;
                decode_block(twd, PBI, mi_row, mi_col, subsize, n4x4_l2, N8X8_L2);
                if HAS_ROWS != 0 {
                    decode_block(twd, PBI, mi_row + HBS, mi_col, subsize, n4x4_l2, N8X8_L2);
                }
            case cast,no_check(u32) PARTITION_VERT;
                decode_block(twd, PBI, mi_row, mi_col, subsize, N8X8_L2, n4x4_l2);
                if HAS_COLS != 0 {
                    decode_block(twd, PBI, mi_row, mi_col + HBS, subsize, N8X8_L2, n4x4_l2);
                }
            case cast,no_check(u32) PARTITION_SPLIT;
                decode_partition(twd, PBI, mi_row, mi_col, subsize, N8X8_L2);
                decode_partition(twd, PBI, mi_row, mi_col + HBS, subsize, N8X8_L2);
                decode_partition(twd, PBI, mi_row + HBS, mi_col, subsize, N8X8_L2);
                decode_partition(twd, PBI, mi_row + HBS, mi_col + HBS, subsize, N8X8_L2);
            case;
        }
    }

    if bsize >= 3 && (bsize == 3 || partition != cast,no_check(u32) PARTITION_SPLIT) {
        dec_update_partition_context(twd, mi_row, mi_col, subsize, NUM_8X8_WH);
    }
}

dec_update_partition_context :: (twd: *Tile_Worker_Data, mi_row: s32, mi_col: s32, subsize: BLOCK_SIZE, bw: s32) {
    ABOVE_CTX := twd.xd.above_seg_context + mi_col;
    LEFT_CTX := twd.xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);

    fill_memory(ABOVE_CTX, cast,no_check(s32) PARTITION_CONTEXT_LOOKUP[subsize].above, cast,no_check(u64) bw);
    fill_memory(LEFT_CTX, cast,no_check(s32) PARTITION_CONTEXT_LOOKUP[subsize].left, cast,no_check(u64) bw);
}

decode_block :: (
    twd: *Tile_Worker_Data,
    PBI: *VP9_Decoder,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE,
    bwl: s32,
    bhl: s32
) {
    CM := *PBI.common;
    LESS8X8 := cast(s32) (bsize < 3);
    BW := (cast(s32) 1) << (((bwl - 1)) & 31);
    BH := (cast(s32) 1) << (((bhl - 1)) & 31);
    X_MIS := (ifx BW < CM.mi_cols - mi_col then BW else CM.mi_cols - mi_col);
    Y_MIS := (ifx BH < CM.mi_rows - mi_row then BH else CM.mi_rows - mi_row);
    r := *twd.bit_reader;
    XD := *twd.xd;

    mi := set_offsets_in_vp9_decodeframe(CM, XD, bsize, mi_row, mi_col, BW, BH, X_MIS, Y_MIS, bwl, bhl);

    if bsize >= 3 && (CM.subsampling_x != 0 || CM.subsampling_y != 0) {
        UV_SUBSIZE := SS_SIZE_LOOKUP[bsize][CM.subsampling_x][CM.subsampling_y];
        if UV_SUBSIZE == 13 {
            internal_error(
                XD.error_info,
                cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                c_string("Invalid block size.")
            );
        }
    }

    vp9_read_mode_info(twd, PBI, mi_row, mi_col, X_MIS, Y_MIS);

    if mi.skip != 0 {
        dec_reset_skip_context(XD);
    }

    if is_inter_block_in_vp9_decodeframe(mi) == 0 {
        for plane: 0..cast(s32) 3 - 1 {
            PD := XD.plane.data + plane;
            TX_SIZE_ :=
                cast,no_check(TX_SIZE) ((ifx plane != 0 then cast,no_check(s32) get_uv_tx_size_in_vp9_decodeframe(mi, PD) else cast,no_check(s32) mi.tx_size));
            NUM_4X4_W := cast,no_check(s32) PD.n4_w;
            NUM_4X4_H := cast,no_check(s32) PD.n4_h;
            STEP := (cast(s32) 1) << ((TX_SIZE_) & 31);
            col: s32 = ---;
            MAX_BLOCKS_WIDE :=
                NUM_4X4_W +
                    (ifx XD.mb_to_right_edge >= 0 then 0 else XD.mb_to_right_edge >> (((5 + PD.subsampling_x)) & 31));
            MAX_BLOCKS_HIGH :=
                NUM_4X4_H +
                    (ifx XD.mb_to_bottom_edge >= 0 then 0 else XD.mb_to_bottom_edge >> (((5 + PD.subsampling_y)) & 31));

            XD.max_blocks_wide = cast,no_check(u32) ((ifx XD.mb_to_right_edge >= 0 then 0 else MAX_BLOCKS_WIDE));
            XD.max_blocks_high = cast,no_check(u32) ((ifx XD.mb_to_bottom_edge >= 0 then 0 else MAX_BLOCKS_HIGH));

            row: s32 = 0;
            while row < MAX_BLOCKS_HIGH {
                col = 0;
                while col < MAX_BLOCKS_WIDE {
                    predict_and_reconstruct_intra_block(twd, mi, plane, row, col, TX_SIZE_);
                    col += STEP;
                }
                row += STEP;
            }
        }
    } else {
        dec_build_inter_predictors_sb(twd, PBI, XD, mi_row, mi_col);

        if mi.skip == 0 {
            eobtotal: s32 = 0;

            for plane: 0..cast(s32) 3 - 1 {
                PD := XD.plane.data + plane;
                TX_SIZE_ :=
                    cast,no_check(TX_SIZE) ((ifx plane != 0 then cast,no_check(s32) get_uv_tx_size_in_vp9_decodeframe(mi, PD) else cast,no_check(s32) mi.tx_size));
                NUM_4X4_W := cast,no_check(s32) PD.n4_w;
                NUM_4X4_H := cast,no_check(s32) PD.n4_h;
                STEP := (cast(s32) 1) << ((TX_SIZE_) & 31);
                col: s32 = ---;
                MAX_BLOCKS_WIDE :=
                    NUM_4X4_W +
                        (ifx XD.mb_to_right_edge >= 0 then 0 else XD.mb_to_right_edge >> (((5 + PD.subsampling_x)) & 31));
                MAX_BLOCKS_HIGH :=
                    NUM_4X4_H +
                        (ifx XD.mb_to_bottom_edge >= 0 then 0 else XD.mb_to_bottom_edge >> (((5 + PD.subsampling_y)) & 31));

                XD.max_blocks_wide = cast,no_check(u32) ((ifx XD.mb_to_right_edge >= 0 then 0 else MAX_BLOCKS_WIDE));
                XD.max_blocks_high = cast,no_check(u32) ((ifx XD.mb_to_bottom_edge >= 0 then 0 else MAX_BLOCKS_HIGH));

                row: s32 = 0;
                while row < MAX_BLOCKS_HIGH {
                    col = 0;
                    while col < MAX_BLOCKS_WIDE {
                        eobtotal += reconstruct_inter_block(twd, mi, plane, row, col, TX_SIZE_, mi_row, mi_col);
                        col += STEP;
                    }
                    row += STEP;
                }
            }

            if LESS8X8 == 0 && eobtotal == 0 {
                mi.skip = 1;
            }
        }
    }

    XD.corrupted |= reader_has_error_in_vp9_decodeframe(r);

    if CM.lf.filter_level != 0 {
        vp9_build_mask(CM, mi, mi_row, mi_col, BW, BH);
    }
}

set_offsets_in_vp9_decodeframe :: (
    CM: *VP9_COMMON,
    XD: *MACROBLOCKD,
    bsize: BLOCK_SIZE,
    mi_row: s32,
    mi_col: s32,
    bw: s32,
    bh: s32,
    x_mis: s32,
    y_mis: s32,
    bwl: s32,
    bhl: s32
) -> *MODE_INFO {
    OFFSET := mi_row * CM.mi_stride + mi_col;
    x: s32 = ---;
    TILE := *XD.tile;

    XD.mi = CM.mi_grid_visible + OFFSET;
    XD.mi[0] = *(cast(*MODE_INFO) (CM.mi))[OFFSET];

    XD.mi[0].sb_type = bsize;
    if 0 < y_mis {
        for y: 0..y_mis - 1 {
            x = cast(s32) (y == 0);
            while x < x_mis {
                XD.mi[y * CM.mi_stride + x] = XD.mi[0];
                x += 1;
            }
        }
    }

    set_plane_n4(XD, bw, bh, bwl, bhl);

    set_skip_context_in_vp9_decodeframe(XD, mi_row, mi_col);

    set_mi_row_col_in_vp9_decodeframe(XD, TILE, mi_row, bh, mi_col, bw, CM.mi_rows, CM.mi_cols);

    vp9_setup_dst_planes(XD.plane.data, get_frame_new_buffer_in_vp9_decodeframe(CM), mi_row, mi_col);
    return XD.mi[0];
}

set_plane_n4 :: (XD: *MACROBLOCKD, bw: s32, bh: s32, bwl: s32, bhl: s32) {
    for i: 0..cast(s32) 3 - 1 {
        XD.plane[i].n4_w = cast,no_check(u16) (bw << 1 >> ((XD.plane[i].subsampling_x) & 31));
        XD.plane[i].n4_h = cast,no_check(u16) (bh << 1 >> ((XD.plane[i].subsampling_y) & 31));
        XD.plane[i].n4_wl = cast,no_check(u8) (bwl - XD.plane[i].subsampling_x);
        XD.plane[i].n4_hl = cast,no_check(u8) (bhl - XD.plane[i].subsampling_y);
    }
}

reconstruct_inter_block :: (
    twd: *Tile_Worker_Data,
    MI: *MODE_INFO,
    plane: s32,
    row: s32,
    col: s32,
    tx_size: TX_SIZE,
    mi_row: s32,
    mi_col: s32
) -> s32 {
    XD := *twd.xd;
    PD := XD.plane.data + plane;
    sc := VP9_DEFAULT_SCAN_ORDERS.data + tx_size;
    EOB := vp9_decode_block_tokens(twd, plane, sc, col, row, tx_size, cast,no_check(s32) MI.segment_id);
    dst := *PD.dst.buf[4 * row * PD.dst.stride + 4 * col];

    if EOB > 0 {
        inverse_transform_block_inter(XD, plane, tx_size, dst, PD.dst.stride, EOB);
    }

    return EOB;
}

inverse_transform_block_inter :: (xd: *MACROBLOCKD, plane: s32, TX_SIZE_: TX_SIZE, dst: *u8, stride: s32, eob: s32) {
    PD := xd.plane.data + plane;
    DQCOEFF := PD.dqcoeff;

    if xd.lossless != 0 {
        vp9_iwht4x4_add(DQCOEFF, dst, stride, eob);
    } else {
        if cast,no_check(s32) TX_SIZE_ == {
            case cast,no_check(s32) cast(TX_SIZE) 0;
                vp9_idct4x4_add(DQCOEFF, dst, stride, eob);
            case cast,no_check(s32) cast(TX_SIZE) 1;
                vp9_idct8x8_add(DQCOEFF, dst, stride, eob);
            case cast,no_check(s32) cast(TX_SIZE) 2;
                vp9_idct16x16_add(DQCOEFF, dst, stride, eob);
            case cast,no_check(s32) cast(TX_SIZE) 3;
                vp9_idct32x32_add(DQCOEFF, dst, stride, eob);
            case;
                return;
        }
    }

    if eob == 1 {
        DQCOEFF[0] = 0;
    } else if TX_SIZE_ <= cast(TX_SIZE) 2 && eob <= 10 {
        fill_memory(DQCOEFF, 0, cast,no_check(u64) (4 * (cast(s32) 4) << ((TX_SIZE_) & 31)) * size_of(Tran_Low_T));
    } else if TX_SIZE_ == cast(TX_SIZE) 3 && eob <= 34 {
        fill_memory(DQCOEFF, 0, cast(u64) 256 * size_of(Tran_Low_T));
    } else {
        fill_memory(
            DQCOEFF,
            0,
            cast,no_check(u64) ((cast(s32) 16) << ((((cast(s32) TX_SIZE_) << 1)) & 31)) * size_of(Tran_Low_T)
        );
    }
}

dec_build_inter_predictors_sb :: (
    twd: *Tile_Worker_Data,
    PBI: *VP9_Decoder,
    xd: *MACROBLOCKD,
    mi_row: s32,
    mi_col: s32
) {
    plane: s32 = ---;
    MI_X := mi_col * (cast(s32) 1) << 3;
    MI_Y := mi_row * (cast(s32) 1) << 3;
    mi := xd.mi[0];
    kernel := vp9_filter_kernels[mi.interp_filter];
    SB_TYPE := mi.sb_type;
    IS_COMPOUND := has_second_ref_in_vp9_decodeframe(mi);

    ref: s32 = 0;
    while ref < 1 + IS_COMPOUND {
        FRAME := mi.ref_frame[ref];
        ref_buf := PBI.common.frame_refs.data + (cast(s32) FRAME) - 1;
        SF := *ref_buf.sf;
        IDX := ref_buf.idx;
        POOL := PBI.common.buffer_pool;
        REF_FRAME_BUF := POOL.frame_bufs.data + IDX;

        if vp9_is_valid_scale_in_vp9_decodeframe(SF) == 0 {
            internal_error(
                xd.error_info,
                cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM,
                c_string("Reference frame has invalid dimensions")
            );
        }

        is_scaled := vp9_is_scaled_in_vp9_decodeframe(SF);
        vp9_setup_pre_planes(xd, ref, ref_buf.buf, mi_row, mi_col, (ifx is_scaled != 0 then SF else null));
        xd.block_refs[ref] = ref_buf;

        if SB_TYPE < 3 {
            plane = 0;
            while plane < 3 {
                PD := xd.plane.data + plane;
                DST_BUF := *PD.dst;
                NUM_4X4_W := cast,no_check(s32) PD.n4_w;
                NUM_4X4_H := cast,no_check(s32) PD.n4_h;
                N4W_X4 := 4 * NUM_4X4_W;
                N4H_X4 := 4 * NUM_4X4_H;
                PRE_BUF := PD.pre.data + ref;
                i: s32 = 0;
                x: s32 = ---;
                if 0 < NUM_4X4_H {
                    for y: 0..NUM_4X4_H - 1 {
                        x = 0;
                        while x < NUM_4X4_W {
                            MV_ := average_split_mvs(PD, mi, ref, c_transpiler_post_increment(*(i)));
                            dec_build_inter_predictors(
                                twd,
                                xd,
                                plane,
                                N4W_X4,
                                N4H_X4,
                                4 * x,
                                4 * y,
                                4,
                                4,
                                MI_X,
                                MI_Y,
                                kernel,
                                SF,
                                PRE_BUF,
                                DST_BUF,
                                *MV_,
                                REF_FRAME_BUF,
                                is_scaled,
                                ref
                            );
                            x += 1;
                        }
                    }
                }
                plane += 1;
            }
        } else {
            MV_ := mi.mv[ref].as_mv;
            plane = 0;
            while plane < 3 {
                PD := xd.plane.data + plane;
                DST_BUF := *PD.dst;
                NUM_4X4_W := cast,no_check(s32) PD.n4_w;
                NUM_4X4_H := cast,no_check(s32) PD.n4_h;
                N4W_X4 := 4 * NUM_4X4_W;
                N4H_X4 := 4 * NUM_4X4_H;
                PRE_BUF := PD.pre.data + ref;
                dec_build_inter_predictors(
                    twd,
                    xd,
                    plane,
                    N4W_X4,
                    N4H_X4,
                    0,
                    0,
                    N4W_X4,
                    N4H_X4,
                    MI_X,
                    MI_Y,
                    kernel,
                    SF,
                    PRE_BUF,
                    DST_BUF,
                    *MV_,
                    REF_FRAME_BUF,
                    is_scaled,
                    ref
                );
                plane += 1;
            }
        }
        ref += 1;
    }
}

dec_build_inter_predictors :: (
    twd: *Tile_Worker_Data,
    xd: *MACROBLOCKD,
    plane: s32,
    bw: s32,
    bh: s32,
    x: s32,
    y: s32,
    w: s32,
    h: s32,
    mi_x: s32,
    mi_y: s32,
    kernel: *Interp_Kernel,
    sf: *Scale_Factors,
    pre_buf: *Buf_2d,
    dst_buf: *Buf_2d,
    mv: *MV,
    ref_frame_buf: *Ref_Cnt_Buffer,
    is_scaled: s32,
    ref: s32
) {
    PD := xd.plane.data + plane;
    DST := dst_buf.buf + dst_buf.stride * y + x;
    scaled_mv: MV32 = ---;
    xs: s32 = ---;
    ys: s32 = ---;
    x0: s32 = ---;
    y0: s32 = ---;
    x0_16: s32 = ---;
    y0_16: s32 = ---;
    frame_width: s32 = ---;
    frame_height: s32 = ---;
    ref_frame: *u8 = ---;

    if plane == 0 {
        frame_width = ref_frame_buf.buf.y_crop_width;
        frame_height = ref_frame_buf.buf.y_crop_height;
        ref_frame = ref_frame_buf.buf.y_buffer;
    } else {
        frame_width = ref_frame_buf.buf.uv_crop_width;
        frame_height = ref_frame_buf.buf.uv_crop_height;
        ref_frame = ifx plane == 1 then ref_frame_buf.buf.u_buffer else ref_frame_buf.buf.v_buffer;
    }

    if is_scaled != 0 {
        MV_Q4 := clamp_mv_to_umv_border_sb(xd, mv, bw, bh, PD.subsampling_x, PD.subsampling_y);

        x_start := -xd.mb_to_left_edge >> (((3 + PD.subsampling_x)) & 31);
        y_start := -xd.mb_to_top_edge >> (((3 + PD.subsampling_y)) & 31);

        x0_16 = (x_start + x) << 4;
        y0_16 = (y_start + y) << 4;

        x0_16 = sf.scale_value_x(x0_16, sf);
        y0_16 = sf.scale_value_y(y0_16, sf);

        x0 = sf.scale_value_x(x_start + x, sf);
        y0 = sf.scale_value_y(y_start + y, sf);

        scaled_mv = vp9_scale_mv(*MV_Q4, mi_x + x, mi_y + y, sf);
        xs = sf.x_step_q4;
        ys = sf.y_step_q4;
    } else {
        x0 = -xd.mb_to_left_edge >> (((3 + PD.subsampling_x)) & 31) + x;
        y0 = -xd.mb_to_top_edge >> (((3 + PD.subsampling_y)) & 31) + y;

        x0_16 = x0 << 4;
        y0_16 = y0 << 4;

        scaled_mv.row = (cast(s32) mv.row) * (cast(s32) 1) << (((1 - PD.subsampling_y)) & 31);
        scaled_mv.col = (cast(s32) mv.col) * (cast(s32) 1) << (((1 - PD.subsampling_x)) & 31);
        ys = 16;
        xs = ys;
    }
    subpel_x := scaled_mv.col & ((cast(s32) 1) << 4 - 1);
    subpel_y := scaled_mv.row & ((cast(s32) 1) << 4 - 1);

    x0 = cast,no_check(s32) (x0 + (scaled_mv.col >> 4));
    y0 = cast,no_check(s32) (y0 + (scaled_mv.row >> 4));
    x0_16 = cast,no_check(s32) (x0_16 + scaled_mv.col);
    y0_16 = cast,no_check(s32) (y0_16 + scaled_mv.row);

    buf_ptr := ref_frame + y0 * pre_buf.stride + x0;
    buf_stride := pre_buf.stride;

    if is_scaled != 0 || scaled_mv.col != 0 || scaled_mv.row != 0 || frame_width & 0x7 != 0 || frame_height & 0x7 != 0 {
        y1 := (y0_16 + (h - 1) * ys) >> 4 + 1;

        x1 := (x0_16 + (w - 1) * xs) >> 4 + 1;
        x_pad: s32 = 0;
        y_pad: s32 = 0;

        if subpel_x != 0 || sf.x_step_q4 != (cast(s32) 1) << 4 {
            x0 -= cast,no_check(s32) ((4 - 1));
            x1 += 4;
            x_pad = 1;
        }

        if subpel_y != 0 || sf.y_step_q4 != (cast(s32) 1) << 4 {
            y0 -= cast,no_check(s32) ((4 - 1));
            y1 += 4;
            y_pad = 1;
        }

        if x0 < 0 ||
            x0 > frame_width - 1 ||
            x1 < 0 ||
            x1 > frame_width - 1 ||
            y0 < 0 ||
            y0 > frame_height - 1 ||
            y1 < 0 ||
            y1 > frame_height - 1 {
            BUF_PTR1 := ref_frame + y0 * buf_stride + x0;
            B_W := x1 - x0 + 1;
            B_H := y1 - y0 + 1;
            BORDER_OFFSET := y_pad * 3 * B_W + x_pad * 3;

            extend_and_predict(
                twd,
                BUF_PTR1,
                buf_stride,
                x0,
                y0,
                B_W,
                B_H,
                frame_width,
                frame_height,
                BORDER_OFFSET,
                DST,
                dst_buf.stride,
                subpel_x,
                subpel_y,
                kernel,
                sf,
                w,
                h,
                ref,
                xs,
                ys
            );
            return;
        }
    }

    inter_predictor_in_vp9_decodeframe(
        buf_ptr,
        buf_stride,
        DST,
        dst_buf.stride,
        subpel_x,
        subpel_y,
        sf,
        w,
        h,
        ref,
        kernel,
        xs,
        ys
    );
}

extend_and_predict :: (
    twd: *Tile_Worker_Data,
    buf_ptr1: *u8,
    pre_buf_stride: s32,
    x0: s32,
    y0: s32,
    b_w: s32,
    b_h: s32,
    frame_width: s32,
    frame_height: s32,
    border_offset: s32,
    DST: *u8,
    dst_buf_stride: s32,
    subpel_x: s32,
    subpel_y: s32,
    kernel: *Interp_Kernel,
    sf: *Scale_Factors,
    w: s32,
    h: s32,
    ref: s32,
    xs: s32,
    ys: s32
) {
    mc_buf := cast(*u8) twd.extend_and_predict_buf.data;

    build_mc_border(buf_ptr1, pre_buf_stride, mc_buf, b_w, x0, y0, b_w, b_h, frame_width, frame_height);
    buf_ptr := mc_buf + border_offset;

    inter_predictor_in_vp9_decodeframe(
        buf_ptr,
        b_w,
        DST,
        dst_buf_stride,
        subpel_x,
        subpel_y,
        sf,
        w,
        h,
        ref,
        kernel,
        xs,
        ys
    );
}

build_mc_border :: (
    src: *u8,
    src_stride: s32,
    dst: *u8,
    dst_stride: s32,
    x: s32,
    y: s32,
    b_w: s32,
    b_h: s32,
    w: s32,
    h: s32
) {
    ref_row := src - x - y * src_stride;

    if y >= h {
        ref_row += (h - 1) * src_stride;
    } else if y > 0 {
        ref_row += y * src_stride;
    }

    while true {
        {
            right: s32 = 0;
            left := (ifx x < 0 then -x else 0);

            if left > b_w {
                left = b_w;
            }

            if x + b_w > w {
                right = x + b_w - w;
            }

            if right > b_w {
                right = b_w;
            }

            copy := b_w - left - right;

            if left != 0 {
                fill_memory(dst, cast,no_check(s32) ref_row[0], cast,no_check(u64) left);
            }

            if copy != 0 {
                copy_memory(dst + left, ref_row + x + left, cast,no_check(u64) copy);
            }

            if right != 0 {
                fill_memory(dst + left + copy, cast,no_check(s32) ref_row[w - 1], cast,no_check(u64) right);
            }

            dst += dst_stride;
            y += 1;

            if y > 0 && y < h {
                ref_row += src_stride;
            }
        }
        if c_transpiler_pre_decrement(*(b_h)) == 0 break;
    }
}

predict_and_reconstruct_intra_block :: (
    twd: *Tile_Worker_Data,
    MI: *MODE_INFO,
    plane: s32,
    row: s32,
    col: s32,
    tx_size: TX_SIZE
) {
    XD := *twd.xd;
    PD := XD.plane.data + plane;
    mode :=
        cast,no_check(PREDICTION_MODE) ((ifx plane == 0 then cast,no_check(s32) MI.mode else cast,no_check(s32) MI.uv_mode));
    dst := *PD.dst.buf[4 * row * PD.dst.stride + 4 * col];

    if MI.sb_type < 3 {
        if plane == 0 {
            mode = XD.mi[0].bmi[row << 1 + col].as_mode;
        }
    }

    vp9_predict_intra_block(
        XD,
        cast,no_check(s32) PD.n4_wl,
        tx_size,
        mode,
        dst,
        PD.dst.stride,
        dst,
        PD.dst.stride,
        col,
        row,
        plane
    );

    if MI.skip == 0 {
        TX_TYPE_ :=
            (ifx plane != 0 ||
                XD.lossless != 0 then cast,no_check(u32) DCT_DCT else INTRA_MODE_TO_TX_TYPE_LOOKUP[mode]);
        sc :=
            (ifx plane != 0 ||
                XD.lossless != 0 then VP9_DEFAULT_SCAN_ORDERS.data + tx_size else VP9_SCAN_ORDERS[tx_size].data + TX_TYPE_);
        EOB := vp9_decode_block_tokens(twd, plane, sc, col, row, tx_size, cast,no_check(s32) MI.segment_id);
        if EOB > 0 {
            inverse_transform_block_intra(XD, plane, TX_TYPE_, tx_size, dst, PD.dst.stride, EOB);
        }
    }
}

inverse_transform_block_intra :: (
    xd: *MACROBLOCKD,
    plane: s32,
    TX_TYPE_: TX_TYPE,
    TX_SIZE_: TX_SIZE,
    dst: *u8,
    stride: s32,
    eob: s32
) {
    PD := xd.plane.data + plane;
    DQCOEFF := PD.dqcoeff;

    if xd.lossless != 0 {
        vp9_iwht4x4_add(DQCOEFF, dst, stride, eob);
    } else {
        if cast,no_check(s32) TX_SIZE_ == {
            case cast,no_check(s32) cast(TX_SIZE) 0;
                vp9_iht4x4_add(TX_TYPE_, DQCOEFF, dst, stride, eob);
            case cast,no_check(s32) cast(TX_SIZE) 1;
                vp9_iht8x8_add(TX_TYPE_, DQCOEFF, dst, stride, eob);
            case cast,no_check(s32) cast(TX_SIZE) 2;
                vp9_iht16x16_add(TX_TYPE_, DQCOEFF, dst, stride, eob);
            case cast,no_check(s32) cast(TX_SIZE) 3;
                vp9_idct32x32_add(DQCOEFF, dst, stride, eob);
            case;
                return;
        }
    }

    if eob == 1 {
        DQCOEFF[0] = 0;
    } else if TX_TYPE_ == cast,no_check(u32) DCT_DCT && TX_SIZE_ <= cast(TX_SIZE) 2 && eob <= 10 {
        fill_memory(DQCOEFF, 0, cast,no_check(u64) (4 * (cast(s32) 4) << ((TX_SIZE_) & 31)) * size_of(Tran_Low_T));
    } else if TX_SIZE_ == cast(TX_SIZE) 3 && eob <= 34 {
        fill_memory(DQCOEFF, 0, cast(u64) 256 * size_of(Tran_Low_T));
    } else {
        fill_memory(
            DQCOEFF,
            0,
            cast,no_check(u64) ((cast(s32) 16) << ((((cast(s32) TX_SIZE_) << 1)) & 31)) * size_of(Tran_Low_T)
        );
    }
}

dec_reset_skip_context :: (xd: *MACROBLOCKD) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        fill_memory(PD.above_context, 0, cast,no_check(u64) PD.n4_w);
        fill_memory(PD.left_context, 0, cast,no_check(u64) PD.n4_h);
    }
}

read_partition :: (
    twd: *Tile_Worker_Data,
    mi_row: s32,
    mi_col: s32,
    has_rows: s32,
    has_cols: s32,
    bsl: s32
) -> PARTITION_TYPE {
    CTX := dec_partition_plane_context(twd, mi_row, mi_col, bsl);
    PROBS := twd.xd.partition_probs[CTX].data;
    counts := twd.xd.counts;

    r := *twd.bit_reader;

    p: PARTITION_TYPE = ifx has_rows != 0 && has_cols != 0
        then cast,no_check(PARTITION_TYPE) read_tree_in_vp9_decodeframe(r, VP9_PARTITION_TREE.data, PROBS)
        else ifx has_rows == 0 && has_cols != 0
            then cast,no_check(PARTITION_TYPE) ((ifx read_in_vp9_decodeframe(r, cast,no_check(s32) PROBS[1]) != 0 then cast,no_check(s32) (PARTITION_SPLIT) else cast,no_check(s32) (PARTITION_HORZ)))
            else ifx has_rows != 0 && has_cols == 0
                then cast,no_check(PARTITION_TYPE) ((ifx read_in_vp9_decodeframe(r, cast,no_check(s32) PROBS[2]) != 0 then cast,no_check(s32) (PARTITION_SPLIT) else cast,no_check(s32) (PARTITION_VERT)))
                else cast,no_check(PARTITION_TYPE) PARTITION_SPLIT;

    if counts != null {
        counts.partition[CTX][p] += 1;
    }

    return p;
}

dec_partition_plane_context :: (twd: *Tile_Worker_Data, mi_row: s32, mi_col: s32, bsl: s32) -> s32 {
    above_ctx := twd.xd.above_seg_context + mi_col;
    left_ctx := twd.xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    above := (cast(s32) above_ctx.*) >> ((bsl) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((bsl) & 31) & 1;

    return left * 2 + above + bsl * 4;
}

recon_block :: (
    twd: *Tile_Worker_Data,
    PBI: *VP9_Decoder,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE,
    bwl: s32,
    bhl: s32
) {
    CM := *PBI.common;
    BW := (cast(s32) 1) << (((bwl - 1)) & 31);
    BH := (cast(s32) 1) << (((bhl - 1)) & 31);
    XD := *twd.xd;

    mi := set_offsets_recon(CM, XD, mi_row, mi_col, BW, BH, bwl, bhl);

    if bsize >= 3 && (CM.subsampling_x != 0 || CM.subsampling_y != 0) {
        UV_SUBSIZE := SS_SIZE_LOOKUP[bsize][CM.subsampling_x][CM.subsampling_y];
        if UV_SUBSIZE == 13 {
            internal_error(
                XD.error_info,
                cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                c_string("Invalid block size.")
            );
        }
    }

    if is_inter_block_in_vp9_decodeframe(mi) == 0 {
        predict_recon_intra(XD, mi, twd, cast,no_check(Intra_Recon_Func) predict_and_reconstruct_intra_block_row_mt);
    } else {
        dec_build_inter_predictors_sb(twd, PBI, XD, mi_row, mi_col);

        if mi.skip == 0 {
            predict_recon_inter(XD, mi, twd, cast,no_check(Predict_Recon_Func) reconstruct_inter_block_row_mt);
        }
    }

    vp9_build_mask(CM, mi, mi_row, mi_col, BW, BH);
}

set_offsets_recon :: (
    CM: *VP9_COMMON,
    XD: *MACROBLOCKD,
    mi_row: s32,
    mi_col: s32,
    bw: s32,
    bh: s32,
    bwl: s32,
    bhl: s32
) -> *MODE_INFO {
    OFFSET := mi_row * CM.mi_stride + mi_col;
    TILE := *XD.tile;
    XD.mi = CM.mi_grid_visible + OFFSET;

    set_plane_n4(XD, bw, bh, bwl, bhl);

    set_skip_context_in_vp9_decodeframe(XD, mi_row, mi_col);

    set_mi_row_col_in_vp9_decodeframe(XD, TILE, mi_row, bh, mi_col, bw, CM.mi_rows, CM.mi_cols);

    vp9_setup_dst_planes(XD.plane.data, get_frame_new_buffer_in_vp9_decodeframe(CM), mi_row, mi_col);
    return XD.mi[0];
}

reconstruct_inter_block_row_mt :: (
    twd: *Tile_Worker_Data,
    MI: *MODE_INFO,
    plane: s32,
    row: s32,
    col: s32,
    tx_size: TX_SIZE
) -> s32 {
    XD := *twd.xd;
    PD := XD.plane.data + plane;
    EOB := PD.eob.*;

    if EOB > 0 {
        inverse_transform_block_inter(
            XD,
            plane,
            tx_size,
            *PD.dst.buf[4 * row * PD.dst.stride + 4 * col],
            PD.dst.stride,
            EOB
        );
    }
    PD.dqcoeff += (cast(s32) 16) << ((((cast(s32) tx_size) << 1)) & 31);
    PD.eob += 1;

    return EOB;
}

predict_recon_inter :: (xd: *MACROBLOCKD, mi: *MODE_INFO, twd: *Tile_Worker_Data, func: Predict_Recon_Func) -> s32 {
    eobtotal: s32 = 0;

    for plane: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + plane;
        TX_SIZE_ :=
            cast,no_check(TX_SIZE) ((ifx plane != 0 then cast,no_check(s32) get_uv_tx_size_in_vp9_decodeframe(mi, PD) else cast,no_check(s32) mi.tx_size));
        NUM_4X4_W := cast,no_check(s32) PD.n4_w;
        NUM_4X4_H := cast,no_check(s32) PD.n4_h;
        STEP := (cast(s32) 1) << ((TX_SIZE_) & 31);
        col: s32 = ---;
        MAX_BLOCKS_WIDE :=
            NUM_4X4_W +
                (ifx xd.mb_to_right_edge >= 0 then 0 else xd.mb_to_right_edge >> (((5 + PD.subsampling_x)) & 31));
        MAX_BLOCKS_HIGH :=
            NUM_4X4_H +
                (ifx xd.mb_to_bottom_edge >= 0 then 0 else xd.mb_to_bottom_edge >> (((5 + PD.subsampling_y)) & 31));

        xd.max_blocks_wide = cast,no_check(u32) ((ifx xd.mb_to_right_edge >= 0 then 0 else MAX_BLOCKS_WIDE));
        xd.max_blocks_high = cast,no_check(u32) ((ifx xd.mb_to_bottom_edge >= 0 then 0 else MAX_BLOCKS_HIGH));

        row: s32 = 0;
        while row < MAX_BLOCKS_HIGH {
            col = 0;
            while col < MAX_BLOCKS_WIDE {
                eobtotal += func(twd, mi, plane, row, col, TX_SIZE_);
                col += STEP;
            }
            row += STEP;
        }
    }
    return eobtotal;
}

predict_and_reconstruct_intra_block_row_mt :: (
    twd: *Tile_Worker_Data,
    MI: *MODE_INFO,
    plane: s32,
    row: s32,
    col: s32,
    tx_size: TX_SIZE
) {
    XD := *twd.xd;
    PD := XD.plane.data + plane;
    mode :=
        cast,no_check(PREDICTION_MODE) ((ifx plane == 0 then cast,no_check(s32) MI.mode else cast,no_check(s32) MI.uv_mode));
    dst := *PD.dst.buf[4 * row * PD.dst.stride + 4 * col];

    if MI.sb_type < 3 {
        if plane == 0 {
            mode = XD.mi[0].bmi[row << 1 + col].as_mode;
        }
    }

    vp9_predict_intra_block(
        XD,
        cast,no_check(s32) PD.n4_wl,
        tx_size,
        mode,
        dst,
        PD.dst.stride,
        dst,
        PD.dst.stride,
        col,
        row,
        plane
    );

    if MI.skip == 0 {
        TX_TYPE_ :=
            (ifx plane != 0 ||
                XD.lossless != 0 then cast,no_check(u32) DCT_DCT else INTRA_MODE_TO_TX_TYPE_LOOKUP[mode]);
        if PD.eob.* > 0 {
            inverse_transform_block_intra(XD, plane, TX_TYPE_, tx_size, dst, PD.dst.stride, PD.eob.*);
        }

        PD.dqcoeff += (cast(s32) 16) << ((((cast(s32) tx_size) << 1)) & 31);
        PD.eob += 1;
    }
}

predict_recon_intra :: (xd: *MACROBLOCKD, mi: *MODE_INFO, twd: *Tile_Worker_Data, func: Intra_Recon_Func) {
    for plane: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + plane;
        TX_SIZE_ :=
            cast,no_check(TX_SIZE) ((ifx plane != 0 then cast,no_check(s32) get_uv_tx_size_in_vp9_decodeframe(mi, PD) else cast,no_check(s32) mi.tx_size));
        NUM_4X4_W := cast,no_check(s32) PD.n4_w;
        NUM_4X4_H := cast,no_check(s32) PD.n4_h;
        STEP := (cast(s32) 1) << ((TX_SIZE_) & 31);
        col: s32 = ---;
        MAX_BLOCKS_WIDE :=
            NUM_4X4_W +
                (ifx xd.mb_to_right_edge >= 0 then 0 else xd.mb_to_right_edge >> (((5 + PD.subsampling_x)) & 31));
        MAX_BLOCKS_HIGH :=
            NUM_4X4_H +
                (ifx xd.mb_to_bottom_edge >= 0 then 0 else xd.mb_to_bottom_edge >> (((5 + PD.subsampling_y)) & 31));

        xd.max_blocks_wide = cast,no_check(u32) ((ifx xd.mb_to_right_edge >= 0 then 0 else MAX_BLOCKS_WIDE));
        xd.max_blocks_high = cast,no_check(u32) ((ifx xd.mb_to_bottom_edge >= 0 then 0 else MAX_BLOCKS_HIGH));

        row: s32 = 0;
        while row < MAX_BLOCKS_HIGH {
            col = 0;
            while col < MAX_BLOCKS_WIDE {
                func(twd, mi, plane, row, col, TX_SIZE_);
                col += STEP;
            }
            row += STEP;
        }
    }
}

process_partition :: (
    twd: *Tile_Worker_Data,
    PBI: *VP9_Decoder,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE,
    n4x4_l2: s32,
    parse_recon_flag: s32,
    process_block: Process_Block_Fn_T
) {
    CM := *PBI.common;
    N8X8_L2 := n4x4_l2 - 1;
    NUM_8X8_WH := (cast(s32) 1) << ((N8X8_L2) & 31);
    HBS := NUM_8X8_WH >> 1;

    HAS_ROWS := cast(s32) (mi_row + HBS < CM.mi_rows);
    HAS_COLS := cast(s32) (mi_col + HBS < CM.mi_cols);
    XD := *twd.xd;

    if mi_row >= CM.mi_rows || mi_col >= CM.mi_cols {
        return;
    }

    if parse_recon_flag & cast,no_check(s32) (PARSE) != 0 {
        XD.partition.* = read_partition(twd, mi_row, mi_col, HAS_ROWS, HAS_COLS, N8X8_L2);
    }

    partition := XD.partition.*;
    XD.partition += 1;

    subsize := get_subsize_in_vp9_decodeframe(bsize, partition);
    if HBS == 0 {
        XD.bmode_blocks_wl =
            cast,no_check(u8) ((cast(s32) 1) >> ((cast(s32) (partition & cast,no_check(u32) PARTITION_VERT != 0)) & 31));
        XD.bmode_blocks_hl =
            cast,no_check(u8) ((cast(s32) 1) >> ((cast(s32) (partition & cast,no_check(u32) PARTITION_HORZ != 0)) & 31));
        process_block(twd, PBI, mi_row, mi_col, subsize, 1, 1);
    } else {
        if partition == {
            case cast,no_check(u32) PARTITION_NONE;
                process_block(twd, PBI, mi_row, mi_col, subsize, n4x4_l2, n4x4_l2);
            case cast,no_check(u32) PARTITION_HORZ;
                process_block(twd, PBI, mi_row, mi_col, subsize, n4x4_l2, N8X8_L2);
                if HAS_ROWS != 0 {
                    process_block(twd, PBI, mi_row + HBS, mi_col, subsize, n4x4_l2, N8X8_L2);
                }
            case cast,no_check(u32) PARTITION_VERT;
                process_block(twd, PBI, mi_row, mi_col, subsize, N8X8_L2, n4x4_l2);
                if HAS_COLS != 0 {
                    process_block(twd, PBI, mi_row, mi_col + HBS, subsize, N8X8_L2, n4x4_l2);
                }
            case cast,no_check(u32) PARTITION_SPLIT;
                process_partition(
                    twd,
                    PBI,
                    mi_row,
                    mi_col,
                    subsize,
                    N8X8_L2,
                    parse_recon_flag,
                    cast,no_check(Process_Block_Fn_T) (process_block)
                );
                process_partition(
                    twd,
                    PBI,
                    mi_row,
                    mi_col + HBS,
                    subsize,
                    N8X8_L2,
                    parse_recon_flag,
                    cast,no_check(Process_Block_Fn_T) (process_block)
                );
                process_partition(
                    twd,
                    PBI,
                    mi_row + HBS,
                    mi_col,
                    subsize,
                    N8X8_L2,
                    parse_recon_flag,
                    cast,no_check(Process_Block_Fn_T) (process_block)
                );
                process_partition(
                    twd,
                    PBI,
                    mi_row + HBS,
                    mi_col + HBS,
                    subsize,
                    N8X8_L2,
                    parse_recon_flag,
                    cast,no_check(Process_Block_Fn_T) (process_block)
                );
            case;
        }
    }

    if parse_recon_flag & cast,no_check(s32) (PARSE) != 0 {
        if (bsize == 3 || partition != cast,no_check(u32) PARTITION_SPLIT) && bsize >= 3 {
            dec_update_partition_context(twd, mi_row, mi_col, subsize, NUM_8X8_WH);
        }
    }
}

parse_block :: (
    twd: *Tile_Worker_Data,
    PBI: *VP9_Decoder,
    mi_row: s32,
    mi_col: s32,
    bsize: BLOCK_SIZE,
    bwl: s32,
    bhl: s32
) {
    CM := *PBI.common;
    BW := (cast(s32) 1) << (((bwl - 1)) & 31);
    BH := (cast(s32) 1) << (((bhl - 1)) & 31);
    X_MIS := (ifx BW < CM.mi_cols - mi_col then BW else CM.mi_cols - mi_col);
    Y_MIS := (ifx BH < CM.mi_rows - mi_row then BH else CM.mi_rows - mi_row);
    r := *twd.bit_reader;
    XD := *twd.xd;

    mi := set_offsets_in_vp9_decodeframe(CM, XD, bsize, mi_row, mi_col, BW, BH, X_MIS, Y_MIS, bwl, bhl);

    if bsize >= 3 && (CM.subsampling_x != 0 || CM.subsampling_y != 0) {
        UV_SUBSIZE := SS_SIZE_LOOKUP[bsize][CM.subsampling_x][CM.subsampling_y];
        if UV_SUBSIZE == 13 {
            internal_error(
                XD.error_info,
                cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                c_string("Invalid block size.")
            );
        }
    }

    vp9_read_mode_info(twd, PBI, mi_row, mi_col, X_MIS, Y_MIS);

    if mi.skip != 0 {
        dec_reset_skip_context(XD);
    }

    if is_inter_block_in_vp9_decodeframe(mi) == 0 {
        predict_recon_intra(XD, mi, twd, cast,no_check(Intra_Recon_Func) parse_intra_block_row_mt);
    } else if mi.skip == 0 {
        dqcoeff: [3] *Tran_Low_T = ---;
        eob: [3] *s32 = ---;

        for plane: 0..cast(s32) 3 - 1 {
            PD := XD.plane.data + plane;
            dqcoeff[plane] = PD.dqcoeff;
            eob[plane] = PD.eob;
        }
        eobtotal := predict_recon_inter(XD, mi, twd, cast,no_check(Predict_Recon_Func) parse_inter_block_row_mt);

        if bsize >= 3 && eobtotal == 0 {
            mi.skip = 1;
            for plane: 0..cast(s32) 3 - 1 {
                pd := XD.plane.data + plane;
                pd.dqcoeff = dqcoeff[plane];
                pd.eob = eob[plane];
            }
        }
    }

    XD.corrupted |= reader_has_error_in_vp9_decodeframe(r);
}

parse_inter_block_row_mt :: (
    twd: *Tile_Worker_Data,
    MI: *MODE_INFO,
    plane: s32,
    row: s32,
    col: s32,
    tx_size: TX_SIZE
) -> s32 {
    XD := *twd.xd;
    PD := XD.plane.data + plane;
    sc := VP9_DEFAULT_SCAN_ORDERS.data + tx_size;
    EOB := vp9_decode_block_tokens(twd, plane, sc, col, row, tx_size, cast,no_check(s32) MI.segment_id);

    PD.eob.* = EOB;
    PD.dqcoeff += (cast(s32) 16) << ((((cast(s32) tx_size) << 1)) & 31);
    PD.eob += 1;

    return EOB;
}

parse_intra_block_row_mt :: (twd: *Tile_Worker_Data, MI: *MODE_INFO, plane: s32, row: s32, col: s32, tx_size: TX_SIZE) {
    XD := *twd.xd;
    mode :=
        cast,no_check(PREDICTION_MODE) ((ifx plane == 0 then cast,no_check(s32) MI.mode else cast,no_check(s32) MI.uv_mode));

    if MI.sb_type < 3 {
        if plane == 0 {
            mode = XD.mi[0].bmi[row << 1 + col].as_mode;
        }
    }

    if MI.skip == 0 {
        PD := XD.plane.data + plane;
        TX_TYPE_ :=
            (ifx plane != 0 ||
                XD.lossless != 0 then cast,no_check(u32) DCT_DCT else INTRA_MODE_TO_TX_TYPE_LOOKUP[mode]);
        sc :=
            (ifx plane != 0 ||
                XD.lossless != 0 then VP9_DEFAULT_SCAN_ORDERS.data + tx_size else VP9_SCAN_ORDERS[tx_size].data + TX_TYPE_);
        PD.eob.* = vp9_decode_block_tokens(twd, plane, sc, col, row, tx_size, cast,no_check(s32) MI.segment_id);

        PD.dqcoeff += (cast(s32) 16) << ((((cast(s32) tx_size) << 1)) & 31);
        PD.eob += 1;
    }
}

setup_token_decoder_in_vp9_decodeframe :: (
    data: *u8,
    data_end: *u8,
    read_size: u64,
    error_info: *Internal_Error_Info,
    r: *Reader,
    decrypt_cb: Decrypt_Cb,
    decrypt_state: *void
) {
    if read_is_valid_in_vp9_decodeframe(data, read_size, data_end) == 0 {
        internal_error(
            error_info,
            cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
            c_string("Truncated packet or corrupt tile length")
        );
    }

    if reader_init(r, data, read_size, cast,no_check(Decrypt_Cb) (decrypt_cb), decrypt_state) != 0 {
        internal_error(
            error_info,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate bool decoder %d"),
            cast(s32) 1
        );
    }
}

setup_token_decoder_in_vp9_decodeframe :: (
    data: *u8,
    data_end: *u8,
    read_size: u64,
    error_info: *Internal_Error_Info,
    r: *Reader,
    decrypt_cb: Decrypt_Cb,
    decrypt_state: *$Value
) {
    setup_token_decoder_in_vp9_decodeframe(data, data_end, read_size, error_info, r, decrypt_cb, cast(*void) decrypt_state);
}

read_is_valid_in_vp9_decodeframe :: (start: *u8, len: u64, end: *u8) -> s32 {
    if len != 0 && len <= cast,no_check(u64) (end - start) {
        return 1;
    }
    return 0;
}

get_tile_buffers :: (
    pbi: *VP9_Decoder,
    data: *u8,
    data_end: *u8,
    tile_cols: s32,
    tile_rows: s32,
    tile_buffers: *[64] Tile_Buffer
) {
    c: s32 = ---;

    if 0 < tile_rows {
        for r: 0..tile_rows - 1 {
            c = 0;
            while c < tile_cols {
                IS_LAST := cast(s32) (r == tile_rows - 1 && c == tile_cols - 1);
                BUF := tile_buffers[r].data + c;
                BUF.col = c;
                get_tile_buffer(
                    data_end,
                    IS_LAST,
                    *pbi.common.error,
                    *data,
                    cast,no_check(Decrypt_Cb) (pbi.decrypt_cb),
                    pbi.decrypt_state,
                    BUF
                );
                c += 1;
            }
        }
    }
}

get_tile_buffer :: (
    DATA_END: *u8,
    is_last: s32,
    error_info: *Internal_Error_Info,
    data: **u8,
    decrypt_cb: Decrypt_Cb,
    decrypt_state: *void,
    buf: *Tile_Buffer
) {
    size: u64 = ---;

    if is_last == 0 {
        if read_is_valid_in_vp9_decodeframe(data.*, 4, DATA_END) == 0 {
            internal_error(
                error_info,
                cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                c_string("Truncated packet or corrupt tile length")
            );
        }

        if decrypt_cb != null {
            be_data: [4] u8 = ---;
            decrypt_cb(decrypt_state, data.*, be_data.data, 4);
            size = cast,no_check(u64) mem_get_be32_as_int_in_vp9_decodeframe(cast(*void) be_data.data);
        } else {
            size = cast,no_check(u64) mem_get_be32_as_int_in_vp9_decodeframe(cast(*void) data.*);
        }
        data.* += 4;

        if size > cast,no_check(u64) (DATA_END - data.*) {
            internal_error(
                error_info,
                cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                c_string("Truncated packet or corrupt tile size")
            );
        }
    } else {
        size = cast,no_check(u64) (DATA_END - data.*);
    }

    buf.data = data.*;
    buf.size = size;

    data.* += size;
}

get_tile_buffer :: (
    DATA_END: *u8,
    is_last: s32,
    error_info: *Internal_Error_Info,
    data: **u8,
    decrypt_cb: Decrypt_Cb,
    decrypt_state: *$Value,
    buf: *Tile_Buffer
) {
    get_tile_buffer(DATA_END, is_last, error_info, data, decrypt_cb, cast(*void) decrypt_state, buf);
}

decode_tiles_mt :: (pbi: *VP9_Decoder, data: *u8, data_end: *u8) -> *u8 {
    CM := *pbi.common;
    WINTERFACE := get_worker_interface();
    bit_reader_end: *u8 = null;
    lf_row_sync := *pbi.lf_row_sync;
    NEW_FB := get_frame_new_buffer_in_vp9_decodeframe(CM);
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    TILE_ROWS := (cast(s32) 1) << ((CM.log2_tile_rows) & 31);
    NUM_WORKERS := (ifx pbi.max_threads < TILE_COLS then pbi.max_threads else TILE_COLS);

    init_mt(pbi);

    n: s32 = 0;
    while n < NUM_WORKERS {
        WORKER := *(cast(*Worker) (pbi.tile_workers))[n];
        TILE_DATA := *pbi.tile_worker_data[n + pbi.total_tiles];
        WINTERFACE.sync(WORKER);

        if pbi.lpf_mt_opt != 0 && CM.lf.filter_level != 0 && CM.skip_loop_filter == 0 {
            TILE_DATA.lf_sync = lf_row_sync;
            TILE_DATA.lf_data = *(cast(*Loop_Filter_Worker_Data) (TILE_DATA.lf_sync.lfdata))[n];
            vp9_loop_filter_data_reset(TILE_DATA.lf_data, NEW_FB, CM, pbi.mb.plane.data);
            TILE_DATA.lf_data.y_only = 0;
        }

        TILE_DATA.xd = pbi.mb;
        TILE_DATA.xd.counts = ifx CM.frame_parallel_decoding_mode != 0 then null else *TILE_DATA.counts;
        WORKER.hook = tile_worker_hook;
        WORKER.data1 = cast(*void) TILE_DATA;
        WORKER.data2 = cast(*void) pbi;
        n += 1;
    }

    get_tile_buffers(pbi, data, data_end, TILE_COLS, TILE_ROWS, *pbi.tile_buffers);

    c_transpiler_qsort(
        cast(*void) pbi.tile_buffers.data,
        cast,no_check(u64) TILE_COLS,
        size_of(Tile_Buffer),
        cast,no_check(Compar_Fn_T) compare_tile_buffers
    );

    if NUM_WORKERS == TILE_COLS {
        LARGEST := pbi.tile_buffers[0];
        move_memory(
            pbi.tile_buffers.data,
            pbi.tile_buffers.data + 1,
            cast,no_check(u64) (TILE_COLS - 1) * size_of(Tile_Buffer)
        );
        pbi.tile_buffers[TILE_COLS - 1] = LARGEST;
    } else {
        start: s32 = 0;
        end := TILE_COLS - 2;
        tmp: Tile_Buffer = ---;

        while start < end {
            tmp = pbi.tile_buffers[start];
            pbi.tile_buffers[start] = pbi.tile_buffers[end];
            pbi.tile_buffers[end] = tmp;
            start += 2;
            end -= 2;
        }
    }

    if CM.frame_parallel_decoding_mode == 0 {
        n = 0;
        while n < NUM_WORKERS {
            TILE_DATA := cast(*Tile_Worker_Data) (cast(*Worker) (pbi.tile_workers))[n].data1;
            fill_memory(*TILE_DATA.counts, 0, size_of(FRAME_COUNTS));
            n += 1;
        }
    }

    {
        BASE := TILE_COLS / NUM_WORKERS;
        REMAIN := TILE_COLS % NUM_WORKERS;
        buf_start: s32 = 0;

        n = 0;
        while n < NUM_WORKERS {
            COUNT := BASE + (REMAIN + n) / NUM_WORKERS;
            WORKER := *(cast(*Worker) (pbi.tile_workers))[n];
            TILE_DATA := cast(*Tile_Worker_Data) WORKER.data1;

            TILE_DATA.buf_start = buf_start;
            TILE_DATA.buf_end = buf_start + COUNT - 1;
            TILE_DATA.data_end = data_end;
            buf_start += COUNT;

            WORKER.had_error = 0;
            if n == NUM_WORKERS - 1 {
                WINTERFACE.execute(WORKER);
            } else {
                WINTERFACE.launch(WORKER);
            }
            n += 1;
        }

        while n > 0 {
            WORKER := *(cast(*Worker) (pbi.tile_workers))[n - 1];
            TILE_DATA := cast(*Tile_Worker_Data) WORKER.data1;

            pbi.mb.corrupted |= cast(s32) (WINTERFACE.sync(WORKER) == 0);
            if bit_reader_end == null {
                bit_reader_end = TILE_DATA.data_end;
            }
            n -= 1;
        }
    }

    if CM.frame_parallel_decoding_mode == 0 {
        n = 0;
        while n < NUM_WORKERS {
            TILE_DATA := cast(*Tile_Worker_Data) (cast(*Worker) (pbi.tile_workers))[n].data1;
            vp9_accumulate_frame_counts(*CM.counts, *TILE_DATA.counts, 1);
            n += 1;
        }
    }

    return bit_reader_end;
}

compare_tile_buffers :: (a: *void, b: *void) -> s32 {
    BUF_A := cast(*Tile_Buffer) a;
    BUF_B := cast(*Tile_Buffer) b;
    return (cast(s32) (BUF_A.size < BUF_B.size)) - cast(s32) (BUF_A.size > BUF_B.size);
}

tile_worker_hook :: (arg1: *void, arg2: *void) -> s32 {
    TILE_DATA := cast(*Tile_Worker_Data) arg1;
    PBI := cast(*VP9_Decoder) arg2;

    tile := *TILE_DATA.xd.tile;
    FINAL_COL := (cast(s32) 1) << ((PBI.common.log2_tile_cols) & 31) - 1;
    bit_reader_end: *u8 = null;
    cm := *PBI.common;

    lf_data := TILE_DATA.lf_data;
    lf_sync := TILE_DATA.lf_sync;

    mi_row: s32 = 0;
    n := TILE_DATA.buf_start;
    if setjmp_2(TILE_DATA.error_info.jmp.data) != 0 {
        TILE_DATA.error_info.setjmp = 0;
        TILE_DATA.xd.corrupted = 1;
        TILE_DATA.data_end = null;
        if PBI.lpf_mt_opt != 0 && cm.lf.filter_level != 0 && cm.skip_loop_filter == 0 {
            NUM_TILES_LEFT := TILE_DATA.buf_end - n;
            MI_ROW_START := mi_row;
            set_rows_after_error(
                lf_sync,
                MI_ROW_START,
                cm.mi_rows,
                NUM_TILES_LEFT,
                (cast(s32) 1) << ((cm.log2_tile_cols) & 31)
            );
        }
        return 0;
    }
    TILE_DATA.error_info.setjmp = 1;

    TILE_DATA.xd.corrupted = 0;

    while true {
        {
            mi_col: s32 = ---;
            BUF := PBI.tile_buffers.data + n;

            mi_row = 0;
            fill_memory(*TILE_DATA.dqcoeff, 0, TILE_DATA.dqcoeff.count * size_of(Tran_Low_T));
            vp9_tile_init(tile, *PBI.common, 0, BUF.col);
            setup_token_decoder_in_vp9_decodeframe(
                BUF.data,
                TILE_DATA.data_end,
                BUF.size,
                *TILE_DATA.error_info,
                *TILE_DATA.bit_reader,
                cast,no_check(Decrypt_Cb) (PBI.decrypt_cb),
                PBI.decrypt_state
            );
            vp9_init_macroblockd_in_vp9_decodeframe(*PBI.common, *TILE_DATA.xd, TILE_DATA.dqcoeff.data);

            TILE_DATA.xd.error_info = *TILE_DATA.error_info;

            mi_row = tile.mi_row_start;
            while mi_row < tile.mi_row_end {
                fill_memory(
                    *TILE_DATA.xd.left_context,
                    0,
                    TILE_DATA.xd.left_context.count * size_of([16] ENTROPY_CONTEXT)
                );
                fill_memory(*TILE_DATA.xd.left_seg_context, 0, TILE_DATA.xd.left_seg_context.count);
                mi_col = tile.mi_col_start;
                while mi_col < tile.mi_col_end {
                    decode_partition(TILE_DATA, PBI, mi_row, mi_col, 12, 4);
                    mi_col += (cast(s32) 1) << (((6 - 3)) & 31);
                }
                if PBI.lpf_mt_opt != 0 && cm.lf.filter_level != 0 && cm.skip_loop_filter == 0 {
                    ALIGNED_ROWS := mi_cols_aligned_to_sb_in_vp9_decodeframe(cm.mi_rows);
                    SB_ROWS := ALIGNED_ROWS >> (((6 - 3)) & 31);
                    IS_LAST_ROW := cast(s32) (SB_ROWS - 1 == mi_row >> (((6 - 3)) & 31));
                    vp9_set_row(
                        lf_sync,
                        (cast(s32) 1) << ((cm.log2_tile_cols) & 31),
                        mi_row >> (((6 - 3)) & 31),
                        IS_LAST_ROW,
                        TILE_DATA.xd.corrupted
                    );
                }
                mi_row += (cast(s32) 1) << (((6 - 3)) & 31);
            }

            if BUF.col == FINAL_COL {
                bit_reader_end = reader_find_end(*TILE_DATA.bit_reader);
            }
        }
        if !(TILE_DATA.xd.corrupted == 0 && c_transpiler_pre_increment(*(n)) <= TILE_DATA.buf_end) break;
    }

    if PBI.lpf_mt_opt != 0 && n < TILE_DATA.buf_end && cm.lf.filter_level != 0 && cm.skip_loop_filter == 0 {
        n += 1;
        set_rows_after_error(lf_sync, 0, cm.mi_rows, TILE_DATA.buf_end - n, (cast(s32) 1) << ((cm.log2_tile_cols) & 31));
    }

    if PBI.lpf_mt_opt != 0 && TILE_DATA.xd.corrupted == 0 && cm.lf.filter_level != 0 && cm.skip_loop_filter == 0 {
        vp9_loopfilter_rows(lf_data, lf_sync);
    }

    TILE_DATA.data_end = bit_reader_end;
    if TILE_DATA.xd.corrupted == 0 {
        return 1;
    }
    return 0;
}

set_rows_after_error :: (
    lf_sync: *VP9_Lf_Sync,
    start_row: s32,
    mi_rows: s32,
    num_tiles_left: s32,
    total_num_tiles: s32
) {
    while true {
        {
            ALIGNED_ROWS := mi_cols_aligned_to_sb_in_vp9_decodeframe(mi_rows);
            SB_ROWS := ALIGNED_ROWS >> (((6 - 3)) & 31);
            CORRUPTED: s32 = 1;
            mi_row := start_row;
            while mi_row < mi_rows {
                IS_LAST_ROW := cast(s32) (SB_ROWS - 1 == mi_row >> (((6 - 3)) & 31));
                vp9_set_row(lf_sync, total_num_tiles, mi_row >> (((6 - 3)) & 31), IS_LAST_ROW, CORRUPTED);
                mi_row += (cast(s32) 1) << (((6 - 3)) & 31);
            }

            start_row = 0;
        }
        if c_transpiler_post_decrement(*(num_tiles_left)) == 0 break;
    }
}

init_mt :: (pbi: *VP9_Decoder) {
    CM := *pbi.common;
    lf_row_sync := *pbi.lf_row_sync;
    ALIGNED_MI_COLS := mi_cols_aligned_to_sb_in_vp9_decodeframe(CM.mi_cols);
    WINTERFACE := get_worker_interface();

    if pbi.num_tile_workers == 0 {
        NUM_THREADS := pbi.max_threads;
        pbi.tile_workers =
            cast(*Worker) allocate_memory(
                (cast,no_check(u64) NUM_THREADS) * size_of(Worker)
            );

        if pbi.tile_workers == null {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate pbi->tile_workers")
            );
        }
        if 0 < NUM_THREADS {
            for n: 0..NUM_THREADS - 1 {
                WORKER := *(cast(*Worker) (pbi.tile_workers))[n];
                pbi.num_tile_workers += 1;

                WINTERFACE.init(WORKER);
                WORKER.thread_name = c_string("vpx tile worker");
                if n < NUM_THREADS - 1 && WINTERFACE.reset(WORKER) == 0 {
                    while true {
                        WINTERFACE.end(*(cast(*Worker) (pbi.tile_workers))[pbi.num_tile_workers - 1]);
                        if !(c_transpiler_pre_decrement(*(pbi.num_tile_workers)) != 0) break;
                    }
                    deallocate_memory(cast(*void) pbi.tile_workers);
                    pbi.tile_workers = null;
                    internal_error(
                        *CM.error,
                        cast,no_check(Codec_Err_T) CODEC_ERROR,
                        c_string("Tile decoder thread creation failed")
                    );
                }
            }
        }
    }

    if (pbi.lpf_mt_opt != 0 || pbi.row_mt != 0) && CM.lf.filter_level != 0 && CM.skip_loop_filter == 0 {
        vp9_lpf_mt_init(lf_row_sync, CM, CM.lf.filter_level, pbi.num_tile_workers);
    }

    fill_memory(
        CM.above_context,
        0,
        (((cast,no_check(u64) (size_of(ENTROPY_CONTEXT))) * 3) * 2) * cast,no_check(u64) ALIGNED_MI_COLS
    );

    fill_memory(CM.above_seg_context, 0, cast,no_check(u64) ALIGNED_MI_COLS);

    vp9_reset_lfm(CM);
}

decode_tiles_row_wise_mt :: (pbi: *VP9_Decoder, data: *u8, data_end: *u8) -> *u8 {
    CM := *pbi.common;
    ROW_MT_WORKER_DATA := pbi.row_mt_worker_data;
    WINTERFACE := get_worker_interface();
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    TILE_ROWS := (cast(s32) 1) << ((CM.log2_tile_rows) & 31);
    NUM_WORKERS := pbi.max_threads;

    corrupted: s32 = 0;
    SB_ROWS := mi_cols_aligned_to_sb_in_vp9_decodeframe(CM.mi_rows) >> (((6 - 3)) & 31);
    SB_COLS := mi_cols_aligned_to_sb_in_vp9_decodeframe(CM.mi_cols) >> (((6 - 3)) & 31);
    lf_row_sync := *pbi.lf_row_sync;
    NEW_FB := get_frame_new_buffer_in_vp9_decodeframe(CM);

    fill_memory(ROW_MT_WORKER_DATA.recon_map, 0, cast,no_check(u64) (SB_ROWS * SB_COLS));

    init_mt(pbi);

    n: s32 = 0;
    while n < NUM_WORKERS {
        WORKER := *(cast(*Worker) (pbi.tile_workers))[n];
        THREAD_DATA := *pbi.row_mt_worker_data.thread_data[n];
        WINTERFACE.sync(WORKER);

        if CM.lf.filter_level != 0 && CM.skip_loop_filter == 0 {
            THREAD_DATA.lf_sync = lf_row_sync;
            THREAD_DATA.lf_data = *(cast(*Loop_Filter_Worker_Data) (THREAD_DATA.lf_sync.lfdata))[n];
            vp9_loop_filter_data_reset(THREAD_DATA.lf_data, NEW_FB, CM, pbi.mb.plane.data);
        }

        THREAD_DATA.pbi = pbi;

        WORKER.hook = row_decode_worker_hook;
        WORKER.data1 = cast(*void) THREAD_DATA;
        WORKER.data2 = cast(*void) *ROW_MT_WORKER_DATA.data_end;
        n += 1;
    }

    if 0 < TILE_COLS {
        for col: 0..TILE_COLS - 1 {
            TILE_DATA := *pbi.tile_worker_data[col];
            TILE_DATA.xd = pbi.mb;
            TILE_DATA.xd.counts = ifx CM.frame_parallel_decoding_mode != 0 then null else *TILE_DATA.counts;
        }
    }

    (cast,no_check(#type (_: *Job_Queue_Row_Mt)) (cast(*void) vp9_jobq_reset))(*ROW_MT_WORKER_DATA.jobq);
    ROW_MT_WORKER_DATA.num_tiles_done = 0;
    ROW_MT_WORKER_DATA.data_end = null;

    get_tile_buffers(pbi, data, data_end, TILE_COLS, TILE_ROWS, *pbi.tile_buffers);

    if CM.frame_parallel_decoding_mode == 0 {
        if 0 < TILE_COLS {
            for col: 0..TILE_COLS - 1 {
                TILE_DATA := *pbi.tile_worker_data[col];
                fill_memory(*TILE_DATA.counts, 0, size_of(FRAME_COUNTS));
            }
        }
    }

    if 0 < TILE_COLS {
        for col: 0..TILE_COLS - 1 {
            parse_job: Job = ---;
            parse_job.row_num = 0;
            parse_job.tile_col = col;
            parse_job.job_type = cast,no_check(Job_Type) PARSE_JOB;
            (cast,no_check(#type (_: *Job_Queue_Row_Mt, _: *void, _: u64) -> s32) (cast(*void) vp9_jobq_queue))(
                *ROW_MT_WORKER_DATA.jobq,
                cast(*void) *parse_job,
                size_of(Job)
            );
        }
    }

    if 0 < NUM_WORKERS {
        for i: 0..NUM_WORKERS - 1 {
            WORKER := *(cast(*Worker) (pbi.tile_workers))[i];
            WORKER.had_error = 0;
            if i == NUM_WORKERS - 1 {
                WINTERFACE.execute(WORKER);
            } else {
                WINTERFACE.launch(WORKER);
            }
        }
    }

    while n > 0 {
        WORKER := *(cast(*Worker) (pbi.tile_workers))[n - 1];

        corrupted |= cast(s32) (WINTERFACE.sync(WORKER) == 0);
        n -= 1;
    }

    pbi.mb.corrupted = corrupted;

    {
        TILE_DATA := *pbi.tile_worker_data[TILE_COLS - 1];
        ROW_MT_WORKER_DATA.data_end = reader_find_end(*TILE_DATA.bit_reader);
    }

    if CM.frame_parallel_decoding_mode == 0 {
        if 0 < TILE_COLS {
            for i: 0..TILE_COLS - 1 {
                TILE_DATA := *pbi.tile_worker_data[i];
                vp9_accumulate_frame_counts(*CM.counts, *TILE_DATA.counts, 1);
            }
        }
    }

    return ROW_MT_WORKER_DATA.data_end;
}

row_decode_worker_hook :: (arg1: *void, arg2: *void) -> s32 {
    THREAD_DATA := cast(*Thread_Data_in_vp9_decoder) arg1;
    data_end := cast(**u8) arg2;
    PBI: *VP9_Decoder = THREAD_DATA.pbi;
    CM := *PBI.common;
    ROW_MT_WORKER_DATA := PBI.row_mt_worker_data;
    ALIGNED_COLS := mi_cols_aligned_to_sb_in_vp9_decodeframe(CM.mi_cols);
    ALIGNED_ROWS := mi_cols_aligned_to_sb_in_vp9_decodeframe(CM.mi_rows);
    SB_ROWS := ALIGNED_ROWS >> (((6 - 3)) & 31);
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    job: Job = ---;
    lf_data := THREAD_DATA.lf_data;
    lf_sync := THREAD_DATA.lf_sync;
    corrupted: s32 = 0;
    tile_data_recon: *Tile_Worker_Data = null;

    while (cast,no_check(#type (_: *Job_Queue_Row_Mt, _: *void, _: u64, _: s32) -> s32) (cast(*void) vp9_jobq_dequeue))(
        *ROW_MT_WORKER_DATA.jobq,
        cast(*void) *job,
        size_of(Job),
        1
    ) == 0 {
        mi_col: s32 = ---;
        MI_ROW := job.row_num;

        if job.job_type == cast,no_check(u32) LPF_JOB {
            lf_data.start = MI_ROW;
            lf_data.stop = lf_data.start + (cast(s32) 1) << (((6 - 3)) & 31);

            if CM.lf.filter_level != 0 && CM.skip_loop_filter == 0 && MI_ROW < CM.mi_rows {
                vp9_loopfilter_job(lf_data, lf_sync);
            }
        } else if job.job_type == cast,no_check(u32) RECON_JOB {
            CUR_SB_ROW := MI_ROW >> (((6 - 3)) & 31);
            IS_LAST_ROW := cast(s32) (SB_ROWS - 1 == CUR_SB_ROW);

            if tile_data_recon == null {
                tile_data_recon = cast(*Tile_Worker_Data) memalign(32, size_of(Tile_Worker_Data));

                if tile_data_recon == null {
                    internal_error(
                        *CM.error,
                        cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                        c_string("Failed to allocate tile_data_recon")
                    );
                }
            }

            tile_data_recon.xd = PBI.mb;
            vp9_tile_init(*tile_data_recon.xd.tile, CM, 0, job.tile_col);
            vp9_init_macroblockd_in_vp9_decodeframe(CM, *tile_data_recon.xd, tile_data_recon.dqcoeff.data);
            mi_col_start := tile_data_recon.xd.tile.mi_col_start;
            mi_col_end := tile_data_recon.xd.tile.mi_col_end;

            if setjmp_2(tile_data_recon.error_info.jmp.data) != 0 {
                SB_COLS := ALIGNED_COLS >> (((6 - 3)) & 31);
                tile_data_recon.error_info.setjmp = 0;
                corrupted = 1;
                mi_col = mi_col_start;
                while mi_col < mi_col_end {
                    C := mi_col >> (((6 - 3)) & 31);
                    map_write(ROW_MT_WORKER_DATA, CUR_SB_ROW * SB_COLS + C, CUR_SB_ROW * TILE_COLS + job.tile_col);
                    mi_col += (cast(s32) 1) << (((6 - 3)) & 31);
                }
                if IS_LAST_ROW != 0 {
                    vp9_tile_done(PBI);
                }
                continue;
            }

            tile_data_recon.error_info.setjmp = 1;
            tile_data_recon.xd.error_info = *tile_data_recon.error_info;

            recon_tile_row(tile_data_recon, PBI, MI_ROW, IS_LAST_ROW, lf_sync, job.tile_col);

            if corrupted != 0 {
                internal_error(
                    *tile_data_recon.error_info,
                    cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                    c_string("Failed to decode tile data")
                );
            }

            if IS_LAST_ROW != 0 {
                vp9_tile_done(PBI);
            }
        } else if job.job_type == cast,no_check(u32) PARSE_JOB {
            TILE_DATA := *PBI.tile_worker_data[job.tile_col];

            if setjmp_2(TILE_DATA.error_info.jmp.data) != 0 {
                TILE_DATA.error_info.setjmp = 0;
                corrupted = 1;
                vp9_tile_done(PBI);
                continue;
            }

            TILE_DATA.xd = PBI.mb;
            TILE_DATA.xd.counts = ifx CM.frame_parallel_decoding_mode != 0 then null else *TILE_DATA.counts;

            TILE_DATA.error_info.setjmp = 1;

            parse_tile_row(TILE_DATA, PBI, MI_ROW, job.tile_col, data_end);

            corrupted |= TILE_DATA.xd.corrupted;
            if corrupted != 0 {
                internal_error(
                    *TILE_DATA.error_info,
                    cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                    c_string("Failed to decode tile data")
                );
            }

            {
                recon_job: Job = ---;
                recon_job.row_num = MI_ROW;
                recon_job.tile_col = job.tile_col;
                recon_job.job_type = cast,no_check(Job_Type) RECON_JOB;
                (cast,no_check(#type (_: *Job_Queue_Row_Mt, _: *void, _: u64) -> s32) (cast(*void) vp9_jobq_queue))(
                    *ROW_MT_WORKER_DATA.jobq,
                    cast(*void) *recon_job,
                    size_of(Job)
                );
            }

            if MI_ROW + (cast(s32) 1) << (((6 - 3)) & 31) < CM.mi_rows {
                parse_job: Job = ---;
                parse_job.row_num = MI_ROW + (cast(s32) 1) << (((6 - 3)) & 31);
                parse_job.tile_col = job.tile_col;
                parse_job.job_type = cast,no_check(Job_Type) PARSE_JOB;
                (cast,no_check(#type (_: *Job_Queue_Row_Mt, _: *void, _: u64) -> s32) (cast(*void) vp9_jobq_queue))(
                    *ROW_MT_WORKER_DATA.jobq,
                    cast(*void) *parse_job,
                    size_of(Job)
                );
            }
        }
    }

    deallocate_memory(cast(*void) tile_data_recon);
    if corrupted == 0 {
        return 1;
    }
    return 0;
}

parse_tile_row :: (tile_data: *Tile_Worker_Data, pbi: *VP9_Decoder, mi_row: s32, cur_tile_col: s32, data_end: **u8) {
    CM := *pbi.common;
    ROW_MT_WORKER_DATA := pbi.row_mt_worker_data;
    tile := *tile_data.xd.tile;
    BUF := pbi.tile_buffers.data + cur_tile_col;
    ALIGNED_COLS := mi_cols_aligned_to_sb_in_vp9_decodeframe(CM.mi_cols);

    fill_memory(*tile_data.dqcoeff, 0, tile_data.dqcoeff.count * size_of(Tran_Low_T));
    vp9_tile_init(tile, CM, 0, cur_tile_col);

    if mi_row == 0 {
        setup_token_decoder_in_vp9_decodeframe(
            BUF.data,
            data_end.*,
            BUF.size,
            *tile_data.error_info,
            *tile_data.bit_reader,
            cast,no_check(Decrypt_Cb) (pbi.decrypt_cb),
            pbi.decrypt_state
        );
    }
    vp9_init_macroblockd_in_vp9_decodeframe(CM, *tile_data.xd, tile_data.dqcoeff.data);
    tile_data.xd.error_info = *tile_data.error_info;

    fill_memory(*tile_data.xd.left_context, 0, tile_data.xd.left_context.count * size_of([16] ENTROPY_CONTEXT));
    fill_memory(*tile_data.xd.left_seg_context, 0, tile_data.xd.left_seg_context.count);
    mi_col := tile.mi_col_start;
    while mi_col < tile.mi_col_end {
        R := mi_row >> (((6 - 3)) & 31);
        C := mi_col >> (((6 - 3)) & 31);

        SB_NUM := cast,no_check(u64) (R * ALIGNED_COLS >> (((6 - 3)) & 31) + C);
        for plane: 0..cast(s32) 3 - 1 {
            tile_data.xd.plane[plane].eob = ROW_MT_WORKER_DATA.eob[plane] + SB_NUM << 8;
            tile_data.xd.plane[plane].dqcoeff = ROW_MT_WORKER_DATA.dqcoeff[plane] + SB_NUM << 12;
        }
        tile_data.xd.partition = ROW_MT_WORKER_DATA.partition + SB_NUM * 85;
        process_partition(
            tile_data,
            pbi,
            mi_row,
            mi_col,
            12,
            4,
            cast,no_check(s32) (PARSE),
            cast,no_check(Process_Block_Fn_T) parse_block
        );
        mi_col += (cast(s32) 1) << (((6 - 3)) & 31);
    }
}

vp9_tile_done :: (pbi: *VP9_Decoder) {
    ROW_MT_WORKER_DATA := pbi.row_mt_worker_data;
    ALL_PARSE_DONE := (cast(s32) 1) << ((pbi.common.log2_tile_cols) & 31);
    pthread_mutex_lock(*ROW_MT_WORKER_DATA.recon_done_mutex);
    ROW_MT_WORKER_DATA.num_tiles_done += 1;
    terminate := cast(s32) (ALL_PARSE_DONE == ROW_MT_WORKER_DATA.num_tiles_done);
    pthread_mutex_unlock(*ROW_MT_WORKER_DATA.recon_done_mutex);
    if terminate != 0 {
        (cast,no_check(#type (_: *Job_Queue_Row_Mt)) (cast(*void) vp9_jobq_terminate))(*ROW_MT_WORKER_DATA.jobq);
    }
}

recon_tile_row :: (
    tile_data: *Tile_Worker_Data,
    pbi: *VP9_Decoder,
    mi_row: s32,
    is_last_row: s32,
    lf_sync: *VP9_Lf_Sync,
    cur_tile_col: s32
) {
    CM := *pbi.common;
    ROW_MT_WORKER_DATA := pbi.row_mt_worker_data;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    ALIGNED_COLS := mi_cols_aligned_to_sb_in_vp9_decodeframe(CM.mi_cols);
    SB_COLS := ALIGNED_COLS >> (((6 - 3)) & 31);
    CUR_SB_ROW := mi_row >> (((6 - 3)) & 31);
    mi_col_start := tile_data.xd.tile.mi_col_start;
    mi_col_end := tile_data.xd.tile.mi_col_end;

    fill_memory(*tile_data.xd.left_context, 0, tile_data.xd.left_context.count * size_of([16] ENTROPY_CONTEXT));
    fill_memory(*tile_data.xd.left_seg_context, 0, tile_data.xd.left_seg_context.count);
    mi_col := mi_col_start;
    while mi_col < mi_col_end {
        C := mi_col >> (((6 - 3)) & 31);

        SB_NUM := cast,no_check(u64) (CUR_SB_ROW * ALIGNED_COLS >> (((6 - 3)) & 31) + C);

        if CUR_SB_ROW != 0 {
            map_read(ROW_MT_WORKER_DATA, (CUR_SB_ROW - 1) * SB_COLS + C, (CUR_SB_ROW - 1) * TILE_COLS + cur_tile_col);
        }

        for plane: 0..cast(s32) 3 - 1 {
            tile_data.xd.plane[plane].eob = ROW_MT_WORKER_DATA.eob[plane] + SB_NUM << 8;
            tile_data.xd.plane[plane].dqcoeff = ROW_MT_WORKER_DATA.dqcoeff[plane] + SB_NUM << 12;
        }
        tile_data.xd.partition = ROW_MT_WORKER_DATA.partition + SB_NUM * 85;
        process_partition(
            tile_data,
            pbi,
            mi_row,
            mi_col,
            12,
            4,
            cast,no_check(s32) (RECON),
            cast,no_check(Process_Block_Fn_T) recon_block
        );
        if CM.lf.filter_level != 0 && CM.skip_loop_filter == 0 {
            is_lpf_job_ready: s32 = 0;

            if mi_col + (cast(s32) 1) << (((6 - 3)) & 31) >= mi_col_end {
                is_lpf_job_ready = lpf_map_write_check(lf_sync, CUR_SB_ROW, TILE_COLS);

                if is_lpf_job_ready != 0 {
                    lpf_job: Job = ---;
                    lpf_job.job_type = cast,no_check(Job_Type) LPF_JOB;
                    if CUR_SB_ROW > 0 {
                        lpf_job.row_num = mi_row - (cast(s32) 1) << (((6 - 3)) & 31);
                        (cast,no_check(#type (_: *Job_Queue_Row_Mt, _: *void, _: u64) -> s32) (cast(*void) vp9_jobq_queue))(
                            *ROW_MT_WORKER_DATA.jobq,
                            cast(*void) *lpf_job,
                            size_of(Job)
                        );
                    }
                    if is_last_row != 0 {
                        lpf_job.row_num = mi_row;
                        (cast,no_check(#type (_: *Job_Queue_Row_Mt, _: *void, _: u64) -> s32) (cast(*void) vp9_jobq_queue))(
                            *ROW_MT_WORKER_DATA.jobq,
                            cast(*void) *lpf_job,
                            size_of(Job)
                        );
                    }
                }
            }
        }
        map_write(ROW_MT_WORKER_DATA, CUR_SB_ROW * SB_COLS + C, CUR_SB_ROW * TILE_COLS + cur_tile_col);
        mi_col += (cast(s32) 1) << (((6 - 3)) & 31);
    }
}

map_write :: (ROW_MT_WORKER_DATA: *Row_MT_Worker_Data, map_idx: s32, sync_idx: s32) {
    pthread_mutex_lock(*(cast(*Pthread_Mutex_T) (ROW_MT_WORKER_DATA.recon_sync_mutex))[sync_idx]);
    ROW_MT_WORKER_DATA.recon_map[map_idx] = 1;
    pthread_cond_signal(*(cast(*Pthread_Cond_T) (ROW_MT_WORKER_DATA.recon_sync_cond))[sync_idx]);
    pthread_mutex_unlock(*(cast(*Pthread_Mutex_T) (ROW_MT_WORKER_DATA.recon_sync_mutex))[sync_idx]);
}

lpf_map_write_check :: (lf_sync: *VP9_Lf_Sync, row: s32, num_tile_cols: s32) -> s32 {
    return_val: s32 = 0;

    pthread_mutex_lock(lf_sync.lf_mutex);
    corrupted := lf_sync.corrupted;
    pthread_mutex_unlock(lf_sync.lf_mutex);
    if corrupted == 0 {
        pthread_mutex_lock(*(cast(*Pthread_Mutex_T) (lf_sync.recon_done_mutex))[row]);
        lf_sync.num_tiles_done[row] += 1;
        if num_tile_cols == lf_sync.num_tiles_done[row] {
            return_val = 1;
        }
        pthread_mutex_unlock(*(cast(*Pthread_Mutex_T) (lf_sync.recon_done_mutex))[row]);
    }

    return return_val;
}

map_read :: (ROW_MT_WORKER_DATA: *Row_MT_Worker_Data, map_idx: s32, sync_idx: s32) {
    map := ROW_MT_WORKER_DATA.recon_map + map_idx;
    MUTEX := *(cast(*Pthread_Mutex_T) (ROW_MT_WORKER_DATA.recon_sync_mutex))[sync_idx];
    pthread_mutex_lock(MUTEX);
    while map.* == 0 {
        pthread_cond_wait(*(cast(*Pthread_Cond_T) (ROW_MT_WORKER_DATA.recon_sync_cond))[sync_idx], MUTEX);
    }
    pthread_mutex_unlock(MUTEX);
}

read_compressed_header :: (pbi: *VP9_Decoder, data: *u8, partition_size: u64) -> s32 {
    CM := *pbi.common;
    XD := *pbi.mb;
    FC := CM.fc;
    r: Reader = ---;

    if reader_init(*r, data, partition_size, cast,no_check(Decrypt_Cb) (pbi.decrypt_cb), pbi.decrypt_state) != 0 {
        internal_error(
            *CM.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate bool decoder 0")
        );
    }

    CM.tx_mode = ifx XD.lossless != 0 then cast,no_check(u32) ONLY_4X4 else read_tx_mode(*r);
    if CM.tx_mode == cast,no_check(u32) TX_MODE_SELECT {
        read_tx_mode_probs(*FC.tx_probs, *r);
    }
    read_coef_probs(FC, CM.tx_mode, *r);

    for k: 0..cast(s32) 3 - 1 {
        (cast,no_check(#type (_: *Reader, _: *Prob)) (cast(*void) vp9_diff_update_prob))(*r, FC.skip_probs.data + k);
    }

    if frame_is_intra_only_in_vp9_decodeframe(CM) == 0 {
        NMVC := *FC.nmvc;

        read_inter_mode_probs(FC, *r);

        if CM.interp_filter == 4 {
            read_switchable_interp_probs(FC, *r);
        }

        i: s32 = 0;
        while i < 4 {
            (cast,no_check(#type (_: *Reader, _: *Prob)) (cast(*void) vp9_diff_update_prob))(
                *r,
                FC.intra_inter_prob.data + i
            );
            i += 1;
        }

        CM.reference_mode = read_frame_reference_mode(CM, *r);
        if CM.reference_mode != cast,no_check(u32) SINGLE_REFERENCE {
            vp9_setup_compound_reference_mode(CM);
        }
        read_frame_reference_mode_probs(CM, *r);

        for j: 0..cast(s32) 4 - 1 {
            i = 0;
            while i < (cast,no_check(s32) ((9 + 1))) - 1 {
                (cast,no_check(#type (_: *Reader, _: *Prob)) (cast(*void) vp9_diff_update_prob))(
                    *r,
                    FC.y_mode_prob[j].data + i
                );
                i += 1;
            }
        }

        for j: 0..cast(s32) (4 * 4) - 1 {
            i = 0;
            while i < (cast,no_check(s32) (PARTITION_TYPES)) - 1 {
                (cast,no_check(#type (_: *Reader, _: *Prob)) (cast(*void) vp9_diff_update_prob))(
                    *r,
                    FC.partition_prob[j].data + i
                );
                i += 1;
            }
        }

        read_mv_probs(NMVC, CM.allow_high_precision_mv, *r);
    }

    return reader_has_error_in_vp9_decodeframe(*r);
}

read_mv_probs :: (ctx: *Nmv_Context, allow_hp: s32, r: *Reader) {
    j: s32 = ---;

    update_mv_probs(ctx.joints.data, cast,no_check(s32) (4 - 1), r);

    for i: 0..cast(s32) 2 - 1 {
        COMP_CTX := ctx.comps.data + i;
        update_mv_probs(*COMP_CTX.sign, 1, r);
        update_mv_probs(COMP_CTX.classes.data, cast,no_check(s32) (11 - 1), r);
        update_mv_probs(COMP_CTX.class0.data, (cast(s32) 1) << 1 - 1, r);
        update_mv_probs(COMP_CTX.bits.data, (cast,no_check(s32) ((11 + 1))) - 2, r);
    }

    for i: 0..cast(s32) 2 - 1 {
        COMP_CTX := ctx.comps.data + i;
        j = 0;
        while j < (cast(s32) 1) << 1 {
            update_mv_probs(COMP_CTX.class0_fp[j].data, cast,no_check(s32) (4 - 1), r);
            j += 1;
        }
        update_mv_probs(COMP_CTX.fp.data, 3, r);
    }

    if allow_hp != 0 {
        for i: 0..cast(s32) 2 - 1 {
            COMP_CTX := ctx.comps.data + i;
            update_mv_probs(*COMP_CTX.class0_hp, 1, r);
            update_mv_probs(*COMP_CTX.hp, 1, r);
        }
    }
}

update_mv_probs :: (p: *Prob, n: s32, r: *Reader) {
    if 0 < n {
        for i: 0..n - 1 {
            if read_in_vp9_decodeframe(r, 252) != 0 {
                p[i] = cast,no_check(Prob) (read_literal_in_vp9_decodeframe(r, 7) << 1 | 1);
            }
        }
    }
}

read_frame_reference_mode_probs :: (cm: *VP9_COMMON, r: *Reader) {
    FC := cm.fc;

    if cm.reference_mode == cast,no_check(u32) REFERENCE_MODE_SELECT {
        for i: 0..cast(s32) 5 - 1 {
            (cast,no_check(#type (_: *Reader, _: *Prob)) (cast(*void) vp9_diff_update_prob))(
                r,
                FC.comp_inter_prob.data + i
            );
        }
    }

    if cm.reference_mode != cast,no_check(u32) COMPOUND_REFERENCE {
        for i: 0..cast(s32) 5 - 1 {
            (cast,no_check(#type (_: *Reader, _: *Prob)) (cast(*void) vp9_diff_update_prob))(
                r,
                FC.single_ref_prob[i].data + 0
            );
            (cast,no_check(#type (_: *Reader, _: *Prob)) (cast(*void) vp9_diff_update_prob))(
                r,
                FC.single_ref_prob[i].data + 1
            );
        }
    }

    if cm.reference_mode != cast,no_check(u32) SINGLE_REFERENCE {
        for i: 0..cast(s32) 5 - 1 {
            (cast,no_check(#type (_: *Reader, _: *Prob)) (cast(*void) vp9_diff_update_prob))(
                r,
                FC.comp_ref_prob.data + i
            );
        }
    }
}

read_frame_reference_mode :: (cm: *VP9_COMMON, r: *Reader) -> REFERENCE_MODE {
    if vp9_compound_reference_allowed(cm) != 0 {
        return cast,no_check(REFERENCE_MODE) ((ifx read_bit_in_vp9_decodeframe(r) != 0 then (ifx read_bit_in_vp9_decodeframe(r) != 0 then cast,no_check(s32) (REFERENCE_MODE_SELECT) else cast,no_check(s32) (COMPOUND_REFERENCE)) else cast,no_check(s32) (SINGLE_REFERENCE)));
    } else {
        return cast,no_check(REFERENCE_MODE) SINGLE_REFERENCE;
    }
}

read_switchable_interp_probs :: (fc: *FRAME_CONTEXT, r: *Reader) {
    i: s32 = ---;
    for j: 0..cast(s32) (3 + 1) - 1 {
        i = 0;
        while i < 3 - 1 {
            (cast,no_check(#type (_: *Reader, _: *Prob)) (cast(*void) vp9_diff_update_prob))(
                r,
                fc.switchable_interp_prob[j].data + i
            );
            i += 1;
        }
    }
}

read_inter_mode_probs :: (fc: *FRAME_CONTEXT, r: *Reader) {
    j: s32 = ---;
    for i: 0..cast(s32) 7 - 1 {
        j = 0;
        while j < (cast,no_check(s32) ((1 + 13))) - 10 - 1 {
            (cast,no_check(#type (_: *Reader, _: *Prob)) (cast(*void) vp9_diff_update_prob))(
                r,
                fc.inter_mode_probs[i].data + j
            );
            j += 1;
        }
    }
}

read_coef_probs :: (fc: *FRAME_CONTEXT, tx_mode: TX_MODE, r: *Reader) {
    MAX_TX_SIZE := TX_MODE_TO_BIGGEST_TX_SIZE[tx_mode];

    tx_size: TX_SIZE = 0;
    while tx_size <= MAX_TX_SIZE {
        read_coef_probs_common(fc.coef_probs[tx_size].data, r);
        tx_size += 1;
    }
}

read_coef_probs_common :: (coef_probs: *Vp9_Coeff_Probs_Model, r: *Reader) {
    i, j, k, l, m: s32 = ---;

    if read_bit_in_vp9_decodeframe(r) != 0 {
        i = 0;
        while i < PLANE_TYPES {
            j = 0;
            while j < 2 {
                k = 0;
                while k < 6 {
                    l = 0;
                    while l < (ifx k == 0 then cast(s32) 3 else 6) {
                        m = 0;
                        while m < 3 {
                            (cast,no_check(#type (_: *Reader, _: *Prob)) (cast(*void) vp9_diff_update_prob))(
                                r,
                                coef_probs[i][j][k][l].data + m
                            );
                            m += 1;
                        }
                        l += 1;
                    }
                    k += 1;
                }
                j += 1;
            }
            i += 1;
        }
    }
}

read_tx_mode_probs :: (tx_probs: *Tx_Probs, r: *Reader) {
    j: s32 = ---;

    for i: 0..cast(s32) 2 - 1 {
        j = 0;
        while j < (cast,no_check(s32) (cast(TX_SIZE) 4)) - 3 {
            (cast,no_check(#type (_: *Reader, _: *Prob)) (cast(*void) vp9_diff_update_prob))(
                r,
                tx_probs.p8x8[i].data + j
            );
            j += 1;
        }
    }

    for i: 0..cast(s32) 2 - 1 {
        j = 0;
        while j < (cast,no_check(s32) (cast(TX_SIZE) 4)) - 2 {
            (cast,no_check(#type (_: *Reader, _: *Prob)) (cast(*void) vp9_diff_update_prob))(
                r,
                tx_probs.p16x16[i].data + j
            );
            j += 1;
        }
    }

    for i: 0..cast(s32) 2 - 1 {
        j = 0;
        while j < (cast,no_check(s32) (cast(TX_SIZE) 4)) - 1 {
            (cast,no_check(#type (_: *Reader, _: *Prob)) (cast(*void) vp9_diff_update_prob))(
                r,
                tx_probs.p32x32[i].data + j
            );
            j += 1;
        }
    }
}

read_tx_mode :: (r: *Reader) -> TX_MODE {
    tx_mode := cast,no_check(TX_MODE) read_literal_in_vp9_decodeframe(r, 2);
    if tx_mode == cast,no_check(u32) ALLOW_32X32 {
        c_transpiler_compound_add(*(tx_mode), (cast,no_check(u32) read_bit_in_vp9_decodeframe(r)), u32, u32);
    }

    return tx_mode;
}

read_marker_in_vp9_decodeframe :: (decrypt_cb: Decrypt_Cb, decrypt_state: *void, data: *u8) -> u8 {
    if decrypt_cb != null {
        marker: u8 = ---;
        decrypt_cb(decrypt_state, data, *marker, 1);
        return marker;
    }
    return data.*;
}

decrease_ref_count_in_vp9_decodeframe :: (idx: s32, FRAME_BUFS: *Ref_Cnt_Buffer, POOL: *Buffer_Pool) {
    if idx >= 0 && FRAME_BUFS[idx].ref_count > 0 {
        FRAME_BUFS[idx].ref_count -= 1;

        if FRAME_BUFS[idx].released == 0 && FRAME_BUFS[idx].ref_count == 0 && FRAME_BUFS[idx].raw_frame_buffer.priv != null {
            POOL.release_fb_cb(POOL.cb_priv, *FRAME_BUFS[idx].raw_frame_buffer);
            FRAME_BUFS[idx].released = 1;
        }
    }
}

get_coef_context_in_vp9_decodeframe :: (neighbors: *s16, token_cache: *u8, c: s32) -> s32 {
    return ((1 + cast(s32) token_cache[neighbors[2 * c + 0]]) + cast(s32) token_cache[neighbors[2 * c + 1]]) >> 1;
}

get_scan_in_vp9_decodeframe :: (
    xd: *MACROBLOCKD,
    tx_size: TX_SIZE,
    type: PLANE_TYPE,
    block_idx: s32
) -> *Scan_Order_in_vp9_scan {
    MI := xd.mi[0];

    if is_inter_block_in_vp9_decodeframe(MI) != 0 || type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 {
        return VP9_DEFAULT_SCAN_ORDERS.data + tx_size;
    } else {
        MODE_ := get_y_mode_in_vp9_decodeframe(MI, block_idx);
        return VP9_SCAN_ORDERS[tx_size].data + INTRA_MODE_TO_TX_TYPE_LOOKUP[MODE_];
    }
}

globals_initialization_state_for_vp9_decodeframe: u32;
initialize_globals_for_vp9_decodeframe :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_decodeframe);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_decodeframe, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_decodeframe) != 2 {}
            return;
        }
    }
    SUB_PEL_FILTERS_12_in_vp9_decodeframe =
        Interp_Kernel12.[
            s16.[ 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, 0, 0 ],
            s16.[ 0, 1, -2, 3, -7, 127, 8, -4, 2, -1, 1, 0 ],
            s16.[ -1, 2, -3, 6, -13, 124, 18, -8, 4, -2, 2, -1 ],
            s16.[ -1, 3, -4, 8, -18, 120, 28, -12, 7, -4, 2, -1 ],
            s16.[ -1, 3, -6, 10, -21, 115, 38, -15, 8, -5, 3, -1 ],
            s16.[ -2, 4, -6, 12, -24, 108, 49, -18, 10, -6, 3, -2 ],
            s16.[ -2, 4, -7, 13, -25, 100, 60, -21, 11, -7, 4, -2 ],
            s16.[ -2, 4, -7, 13, -26, 91, 71, -24, 13, -7, 4, -2 ],
            s16.[ -2, 4, -7, 13, -25, 81, 81, -25, 13, -7, 4, -2 ],
            s16.[ -2, 4, -7, 13, -24, 71, 91, -26, 13, -7, 4, -2 ],
            s16.[ -2, 4, -7, 11, -21, 60, 100, -25, 13, -7, 4, -2 ],
            s16.[ -2, 3, -6, 10, -18, 49, 108, -24, 12, -6, 4, -2 ],
            s16.[ -1, 3, -5, 8, -15, 38, 115, -21, 10, -6, 3, -1 ],
            s16.[ -1, 2, -4, 7, -12, 28, 120, -18, 8, -4, 3, -1 ],
            s16.[ -1, 2, -2, 4, -8, 18, 124, -13, 6, -3, 2, -1 ],
            s16.[ 0, 1, -1, 2, -4, 8, 127, -7, 3, -2, 1, 0 ]
        ];
    COUNT_TO_UPDATE_FACTOR_in_vp9_decodeframe =
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
    COSPI_1_64_in_vp9_decodeframe = 16364;
    COSPI_2_64_in_vp9_decodeframe = 16305;
    COSPI_3_64_in_vp9_decodeframe = 16207;
    COSPI_4_64_in_vp9_decodeframe = 16069;
    COSPI_5_64_in_vp9_decodeframe = 15893;
    COSPI_6_64_in_vp9_decodeframe = 15679;
    COSPI_7_64_in_vp9_decodeframe = 15426;
    COSPI_8_64_in_vp9_decodeframe = 15137;
    COSPI_9_64_in_vp9_decodeframe = 14811;
    COSPI_10_64_in_vp9_decodeframe = 14449;
    COSPI_11_64_in_vp9_decodeframe = 14053;
    COSPI_12_64_in_vp9_decodeframe = 13623;
    COSPI_13_64_in_vp9_decodeframe = 13160;
    COSPI_14_64_in_vp9_decodeframe = 12665;
    COSPI_15_64_in_vp9_decodeframe = 12140;
    COSPI_16_64_in_vp9_decodeframe = 11585;
    COSPI_17_64_in_vp9_decodeframe = 11003;
    COSPI_18_64_in_vp9_decodeframe = 10394;
    COSPI_19_64_in_vp9_decodeframe = 9760;
    COSPI_20_64_in_vp9_decodeframe = 9102;
    COSPI_21_64_in_vp9_decodeframe = 8423;
    COSPI_22_64_in_vp9_decodeframe = 7723;
    COSPI_23_64_in_vp9_decodeframe = 7005;
    COSPI_24_64_in_vp9_decodeframe = 6270;
    COSPI_25_64_in_vp9_decodeframe = 5520;
    COSPI_26_64_in_vp9_decodeframe = 4756;
    COSPI_27_64_in_vp9_decodeframe = 3981;
    COSPI_28_64_in_vp9_decodeframe = 3196;
    COSPI_29_64_in_vp9_decodeframe = 2404;
    COSPI_30_64_in_vp9_decodeframe = 1606;
    COSPI_31_64_in_vp9_decodeframe = 804;
    SINPI_1_9_in_vp9_decodeframe = 5283;
    SINPI_2_9_in_vp9_decodeframe = 9929;
    SINPI_3_9_in_vp9_decodeframe = 13377;
    SINPI_4_9_in_vp9_decodeframe = 15212;
    atomic_store(*globals_initialization_state_for_vp9_decodeframe, 2);
}

PARSE_RECON_FLAG :: u32;
PARSE : s32 : 1;
RECON : s32 : 2;

Process_Block_Fn_T :: #type (_: *Tile_Worker_Data, _: *VP9_Decoder, _: s32, _: s32, _: BLOCK_SIZE, _: s32, _: s32);

Job_Type :: u32;
PARSE_JOB : s32 : 0;
RECON_JOB : s32 : 1;
LPF_JOB : s32 : 2;

Job :: struct {
    row_num: s32;
    tile_col: s32;
    job_type: Job_Type;
}

