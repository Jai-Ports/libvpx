Codec_Alg_Priv_in_vp8_dx_iface :: struct {
    base: Codec_Priv_T #align 8;
    cfg: Codec_Dec_Cfg_T #align 1;
    si: Vp8_Stream_Info_T #align 1;
    decoder_init: s32 #align 1;
    restart_threads: s32 #align 1;
    postproc_cfg_set: s32 #align 1;
    postproc_cfg: Vp8_Postproc_Cfg_T #align 1;
    layout_padding_0: [4] u8 #align 1;
    decrypt_cb: Decrypt_Cb #align 1;
    decrypt_state: *void #align 1;
    img: Image_T #align 1;
    img_setup: s32 #align 1;
    layout_padding_1: [4] u8 #align 1;
    yv12_frame_buffers: Frame_Buffers #align 1;
    user_priv: *void #align 1;
    fragments: FRAGMENT_DATA #align 1;
} #no_padding;

Vp8_Stream_Info_T :: Codec_Stream_Info_T;

Mem_Seg_Id_T :: u32;
VP8_SEG_ALG_PRIV : s32 : 256;
VP8_SEG_MAX : s32 : 257;

CODEC_VP8_DX_ALGO: Codec_Iface_T;

VP8_CTF_MAPS: [9] Codec_Ctrl_Fn_Map_T;

clip_pixel_in_vp8_dx_iface :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp8_dx_iface :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp8_dx_iface :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp8_dx_iface :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp8_dx_iface :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp8_dx_iface(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp8_dx_iface(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp8_dx_iface(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp8_dx_iface :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_vp8_dx_iface :: (FILTER: *s16) -> s32 {
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

codec_control_vp8_set_reference_in_vp8_dx_iface :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Ref_Frame_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_copy_reference_in_vp8_dx_iface :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Ref_Frame_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_set_postproc_in_vp8_dx_iface :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Vp8_Postproc_Cfg_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_get_reference_in_vp8_dx_iface :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Vp9_Ref_Frame_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

vp8_get_frame :: (ctx: *Codec_Alg_Priv_in_vp8_dx_iface, iter: *Codec_Iter_T) -> *Image_T {
    img: *Image_T = null;

    if iter.* == null && ctx.yv12_frame_buffers.pbi[0] != null {
        sd: YV12_BUFFER_CONFIG = ---;
        flags: Vp8_Ppflags_T = ---;
        fill_memory(*flags, 0, size_of(Vp8_Ppflags_T));

        if ctx.base.init_flags & 0x10000 != 0 {
            flags.post_proc_flag = ctx.postproc_cfg.post_proc_flag;
            flags.deblocking_level = ctx.postproc_cfg.deblocking_level;
            flags.noise_level = ctx.postproc_cfg.noise_level;
        }

        if 0 == (cast,no_check(#type (_: *VP8_D_COMP, _: *YV12_BUFFER_CONFIG, _: *Vp8_Ppflags_T) -> s32) (cast(*void) vp8dx_get_raw_frame))(
            ctx.yv12_frame_buffers.pbi[0],
            *sd,
            *flags
        ) {
            yuvconfig2image(*ctx.img, *sd, ctx.user_priv);

            img = *ctx.img;
            iter.* = cast(Codec_Iter_T) img;
        }
    }

    return img;
}

yuvconfig2image :: (img: *Image_T, yv12: *YV12_BUFFER_CONFIG, user_priv: *void) {
    img.fmt = cast,no_check(Img_Fmt_T) IMG_FMT_I420;
    img.w = cast,no_check(u32) yv12.y_stride;
    img.h = cast,no_check(u32) (((yv12.y_height + cast,no_check(s32) ((2 * 32))) + 15) & ~(cast(s32) 15));
    img.r_w = cast,no_check(u32) yv12.y_width;
    img.d_w = img.r_w;
    img.r_h = cast,no_check(u32) yv12.y_height;
    img.d_h = img.r_h;
    img.x_chroma_shift = 1;
    img.y_chroma_shift = 1;
    img.planes[0] = yv12.y_buffer;
    img.planes[1] = yv12.u_buffer;
    img.planes[2] = yv12.v_buffer;
    img.planes[3] = null;
    img.stride[0] = yv12.y_stride;
    img.stride[1] = yv12.uv_stride;
    img.stride[2] = yv12.uv_stride;
    img.stride[3] = yv12.y_stride;
    img.bit_depth = 8;
    img.bps = 12;
    img.user_priv = user_priv;
    img.img_data = yv12.buffer_alloc;
    img.img_data_owner = 0;
    img.self_allocd = 0;
}

yuvconfig2image :: (img: *Image_T, yv12: *YV12_BUFFER_CONFIG, user_priv: *$Value) {
    yuvconfig2image(img, yv12, cast(*void) user_priv);
}

vp8_decode :: (ctx: *Codec_Alg_Priv_in_vp8_dx_iface, data: *u8, data_sz: u32, user_priv: *void) -> Codec_Err_T {
    res: Codec_Err_T = ---;
    resolution_change: u32 = 0;
    w, h: u32 = ---;

    if ctx.fragments.enabled == 0 && data == null && data_sz == 0 {
        return cast,no_check(Codec_Err_T) (cast(s32) 0);
    }

    if update_fragments(ctx, data, data_sz, *res) <= 0 {
        return res;
    }

    w = ctx.si.w;
    h = ctx.si.h;

    res =
        vp8_peek_si_internal(
            ctx.fragments.ptrs[0],
            ctx.fragments.sizes[0],
            *ctx.si,
            cast,no_check(Decrypt_Cb) (ctx.decrypt_cb),
            ctx.decrypt_state
        );

    if res == cast,no_check(u32) CODEC_UNSUP_BITSTREAM && ctx.si.is_kf == 0 {
        res = cast,no_check(Codec_Err_T) CODEC_OK;
    }

    if ctx.decoder_init == 0 && ctx.si.is_kf == 0 {
        res = cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM;
    }
    if !(res != 0) && ctx.decoder_init != 0 && w == 0 && h == 0 && ctx.si.h == 0 && ctx.si.w == 0 {
        pbi: *VP8_D_COMP = ctx.yv12_frame_buffers.pbi[0];

        res = cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME;
        internal_error(*pbi.common.error, res, c_string("Keyframe / intra-only frame required to reset decoder state"));
    }

    if ctx.si.h != h || ctx.si.w != w {
        resolution_change = 1;
    }

    if !(res != 0) && ctx.restart_threads != 0 {
        pbi: *VP8_D_COMP = ctx.yv12_frame_buffers.pbi[0];
        PC := *pbi.common;
        if setjmp_2(pbi.common.error.jmp.data) != 0 {
            pbi.common.error.setjmp = 0;
            vp8_decoder_remove_threads(pbi);

            ctx.fragments.count = 0;
            return cast,no_check(Codec_Err_T) CODEC_ERROR;
        }
        pbi.common.error.setjmp = 1;
        pbi.max_threads = cast,no_check(s32) ctx.cfg.threads;
        vp8_decoder_create_threads(pbi);
        if atomic_load_acquire_in_vp8_dx_iface(*pbi.b_multithreaded_rd) != 0 {
            vp8mt_alloc_temp_buffers(pbi, PC.width, PC.mb_rows);
        }
        ctx.restart_threads = 0;
        pbi.common.error.setjmp = 0;
    }

    if !(res != 0) && ctx.decoder_init == 0 {
        oxcf: VP8_D_CONFIG = ---;

        oxcf.width = cast,no_check(s32) ctx.si.w;
        oxcf.height = cast,no_check(s32) ctx.si.h;
        oxcf.version = 9;
        oxcf.postprocess = 0;
        oxcf.max_threads = cast,no_check(s32) ctx.cfg.threads;
        oxcf.error_concealment = cast,no_check(s32) (ctx.base.init_flags & 0x20000);

        if ctx.postproc_cfg_set == 0 && ctx.base.init_flags & 0x10000 != 0 {
            ctx.postproc_cfg.post_proc_flag =
                ((cast,no_check(s32) (VP8_DEBLOCK)) | cast,no_check(s32) (VP8_DEMACROBLOCK)) | cast,no_check(s32) (VP8_MFQE);
            ctx.postproc_cfg.deblocking_level = 4;
            ctx.postproc_cfg.noise_level = 0;
        }

        res =
            cast,no_check(Codec_Err_T) (cast,no_check(#type (_: *Frame_Buffers, _: *VP8_D_CONFIG) -> s32) (cast(*void) vp8_create_decoder_instances))(
                *ctx.yv12_frame_buffers,
                *oxcf
            );
        if res == cast,no_check(u32) CODEC_OK {
            ctx.decoder_init = 1;
        } else {
            ctx.si.w = 0;
            ctx.si.h = 0;
        }
    }

    if ctx.decoder_init != 0 {
        ctx.yv12_frame_buffers.pbi[0].decrypt_cb = ctx.decrypt_cb;
        ctx.yv12_frame_buffers.pbi[0].decrypt_state = ctx.decrypt_state;
    }

    if !(res != 0) {
        pbi: *VP8_D_COMP = ctx.yv12_frame_buffers.pbi[0];
        PC := *pbi.common;
        if resolution_change != 0 {
            XD := *pbi.mb;

            i: s32 = ---;

            PC.width = cast,no_check(s32) ctx.si.w;
            PC.height = cast,no_check(s32) ctx.si.h;
            if setjmp_2(pbi.common.error.jmp.data) != 0 {
                pbi.common.error.setjmp = 0;

                ctx.si.w = 0;
                ctx.si.h = 0;

                ctx.fragments.count = 0;
                return cast,no_check(Codec_Err_T) (-cast(s32) 1);
            }

            pbi.common.error.setjmp = 1;

            if PC.width <= 0 {
                PC.width = cast,no_check(s32) w;
                internal_error(
                    *PC.error,
                    cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                    c_string("Invalid frame width")
                );
            }

            if PC.height <= 0 {
                PC.height = cast,no_check(s32) h;
                internal_error(
                    *PC.error,
                    cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
                    c_string("Invalid frame height")
                );
            }

            if atomic_load_acquire_in_vp8_dx_iface(*pbi.b_multithreaded_rd) != 0 {
                vp8mt_de_alloc_temp_buffers(pbi, PC.mb_rows);
            }

            pbi.decoded_key_frame = 0;
            if vp8_alloc_frame_buffers(PC, PC.width, PC.height) != 0 {
                internal_error(
                    *PC.error,
                    cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                    c_string("Failed to allocate frame buffers")
                );
            }

            XD.pre = PC.yv12_fb[PC.lst_fb_idx];
            XD.dst = PC.yv12_fb[PC.new_fb_idx];

            i = 0;
            while i < pbi.allocated_decoding_thread_count {
                pbi.mb_row_di[i].mbd.dst = PC.yv12_fb[PC.new_fb_idx];
                vp8_build_block_doffsets(*pbi.mb_row_di[i].mbd);
                i += 1;
            }

            vp8_build_block_doffsets(*pbi.mb);

            if atomic_load_acquire_in_vp8_dx_iface(*pbi.b_multithreaded_rd) != 0 {
                vp8mt_alloc_temp_buffers(pbi, PC.width, 0);
            }

            pbi.common.error.setjmp = 0;

            pbi.common.fb_idx_ref_cnt[0] = 0;
        }

        if setjmp_2(pbi.common.error.jmp.data) != 0 {
            PC.yv12_fb[PC.lst_fb_idx].corrupted = 1;

            if PC.fb_idx_ref_cnt[PC.new_fb_idx] > 0 {
                PC.fb_idx_ref_cnt[PC.new_fb_idx] -= 1;
            }
            pbi.common.error.setjmp = 0;

            if pbi.restart_threads != 0 {
                ctx.si.w = 0;
                ctx.si.h = 0;
                ctx.restart_threads = 1;
            }

            res = update_error_state_in_vp8_dx_iface(ctx, *pbi.common.error);
            ctx.fragments.count = 0;
            return res;
        }

        pbi.common.error.setjmp = 1;

        pbi.fragments = ctx.fragments;

        pbi.restart_threads = 0;

        ctx.user_priv = user_priv;
        if vp8dx_receive_compressed_data(pbi) != 0 {
            res = update_error_state_in_vp8_dx_iface(ctx, *pbi.common.error);
        }

        pbi.common.error.setjmp = 0;
    }

    ctx.fragments.count = 0;
    return res;
}

update_error_state_in_vp8_dx_iface :: (
    ctx: *Codec_Alg_Priv_in_vp8_dx_iface,
    error: *Internal_Error_Info
) -> Codec_Err_T {
    res: Codec_Err_T = ---;

    if (((ifx true { assignment_0: Codec_Err_T = cast,no_check(Codec_Err_T) (error.error_code); (res) = assignment_0; assignment_0; })) != 0) {
        ctx.base.err_detail = ifx error.has_detail != 0 then error.detail.data else null;
    }

    return res;
}

atomic_load_acquire_in_vp8_dx_iface :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_peek_si_internal :: (
    data: *u8,
    data_sz: u32,
    si: *Codec_Stream_Info_T,
    decrypt_cb: Decrypt_Cb,
    decrypt_state: *void
) -> Codec_Err_T {
    res := cast,no_check(Codec_Err_T) CODEC_OK;

    if data == null {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if data + data_sz <= data {
        res = cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    } else {
        clear_buffer: [10] u8 = ---;
        clear := data;
        if decrypt_cb != null {
            n :=
                cast,no_check(s32) ((ifx clear_buffer.count < cast,no_check(u64) data_sz then clear_buffer.count else cast,no_check(u64) data_sz));
            decrypt_cb(decrypt_state, data, clear_buffer.data, n);
            clear = clear_buffer.data;
        }
        si.is_kf = 0;

        if data_sz >= 10 && (cast(s32) clear[0]) & 0x1 == 0 {
            si.is_kf = 1;

            if clear[3] != 0x9d || clear[4] != 0x1 || clear[5] != 0x2a {
                return cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM;
            }

            si.w = cast,no_check(u32) ((cast(s32) clear[6]) | ((cast(s32) clear[7]) << 8) & 0x3fff);
            si.h = cast,no_check(u32) ((cast(s32) clear[8]) | ((cast(s32) clear[9]) << 8) & 0x3fff);

            if !(si.h != 0 && si.w != 0) {
                si.h = 0;
                si.w = si.h;
                res = cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME;
            }
        } else {
            res = cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM;
        }
    }

    return res;
}

vp8_peek_si_internal :: (
    data: *u8,
    data_sz: u32,
    si: *Codec_Stream_Info_T,
    decrypt_cb: Decrypt_Cb,
    decrypt_state: *$Value
) -> Codec_Err_T {
    return vp8_peek_si_internal(data, data_sz, si, decrypt_cb, cast(*void) decrypt_state);
}

update_fragments :: (ctx: *Codec_Alg_Priv_in_vp8_dx_iface, data: *u8, data_sz: u32, res: *Codec_Err_T) -> s32 {
    res.* = cast,no_check(Codec_Err_T) CODEC_OK;

    if ctx.fragments.count == 0 {
        fill_memory(ctx.fragments.ptrs.data, 0, ctx.fragments.ptrs.count * size_of(*u8));
        fill_memory(ctx.fragments.sizes.data, 0, ctx.fragments.sizes.count * size_of(u32));
    }

    if ctx.fragments.enabled != 0 && data == null && data_sz == 0 && ctx.fragments.count == 0 {
        return 0;
    }

    if ctx.fragments.enabled != 0 && !(data == null && data_sz == 0) {
        if ctx.fragments.count >= 9 {
            ctx.fragments.count = 0;
            res.* = cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
            return -1;
        }
        ctx.fragments.ptrs[ctx.fragments.count] = data;
        ctx.fragments.sizes[ctx.fragments.count] = data_sz;
        ctx.fragments.count += 1;
        return 0;
    }

    if ctx.fragments.enabled == 0 && data == null && data_sz == 0 {
        return 0;
    }

    if ctx.fragments.enabled == 0 {
        ctx.fragments.ptrs[0] = data;
        ctx.fragments.sizes[0] = data_sz;
        ctx.fragments.count = 1;
    }

    return 1;
}

vp8_get_si :: (ctx: *Codec_Alg_Priv_in_vp8_dx_iface, si: *Codec_Stream_Info_T) -> Codec_Err_T {
    sz: u32 = ifx cast,no_check(u64) si.sz >= size_of(Vp8_Stream_Info_T)
        then cast,no_check(u32) (cast(u64) size_of(Vp8_Stream_Info_T))
        else cast,no_check(u32) (cast(u64) size_of(Codec_Stream_Info_T));

    copy_memory(si, *ctx.si, cast,no_check(u64) sz);
    si.sz = sz;

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

vp8_peek_si :: (data: *u8, data_sz: u32, si: *Codec_Stream_Info_T) -> Codec_Err_T {
    return vp8_peek_si_internal(data, data_sz, si, null, null);
}

vp8_set_decryptor :: (ctx: *Codec_Alg_Priv_in_vp8_dx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    init := c_transpiler_va_arg(cast(*void) (args), *Decrypt_Init);

    if init != null {
        ctx.decrypt_cb = init.decrypt_cb;
        ctx.decrypt_state = init.decrypt_state;
    } else {
        ctx.decrypt_cb = null;
        ctx.decrypt_state = null;
    }
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

vp8_get_quantizer_in_vp8_dx_iface :: (ctx: *Codec_Alg_Priv_in_vp8_dx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    ARG := c_transpiler_va_arg(cast(*void) (args), *s32);
    pbi: *VP8_D_COMP = ctx.yv12_frame_buffers.pbi[0];
    if ARG == null {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if pbi == null {
        return cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME;
    }
    ARG.* = vp8dx_get_quantizer(pbi);
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

vp8_get_last_ref_frame :: (ctx: *Codec_Alg_Priv_in_vp8_dx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    ref_info := c_transpiler_va_arg(cast(*void) (args), *s32);

    if ref_info != null {
        pbi := ctx.yv12_frame_buffers.pbi[0];
        if pbi != null {
            oci := *pbi.common;
            ref_info.* =
                ((ifx vp8dx_references_buffer(oci, cast,no_check(s32) (ALTREF_FRAME)) != 0 then cast,no_check(s32) (VP8_ALTR_FRAME) else 0) | (ifx vp8dx_references_buffer(oci, cast,no_check(s32) (GOLDEN_FRAME)) != 0 then cast,no_check(s32) (VP8_GOLD_FRAME) else 0)) | (ifx vp8dx_references_buffer(oci, cast,no_check(s32) (LAST_FRAME)) != 0 then cast,no_check(s32) (VP8_LAST_FRAME) else 0);
            return cast,no_check(Codec_Err_T) CODEC_OK;
        } else {
            return cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME;
        }
    } else {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
}

vp8_get_frame_corrupted :: (ctx: *Codec_Alg_Priv_in_vp8_dx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    corrupted := c_transpiler_va_arg(cast(*void) (args), *s32);
    pbi := ctx.yv12_frame_buffers.pbi[0];

    if corrupted != null && pbi != null {
        FRAME := pbi.common.frame_to_show;
        if FRAME == null {
            return cast,no_check(Codec_Err_T) CODEC_ERROR;
        }
        corrupted.* = FRAME.corrupted;
        return cast,no_check(Codec_Err_T) CODEC_OK;
    } else {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
}

vp8_get_last_ref_updates :: (ctx: *Codec_Alg_Priv_in_vp8_dx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    update_info := c_transpiler_va_arg(cast(*void) (args), *s32);

    if update_info != null {
        pbi := ctx.yv12_frame_buffers.pbi[0];
        if pbi == null {
            return cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME;
        }

        update_info.* =
            ((pbi.common.refresh_alt_ref_frame * cast,no_check(s32) (VP8_ALTR_FRAME)) + pbi.common.refresh_golden_frame * cast,no_check(s32) (VP8_GOLD_FRAME)) +
                pbi.common.refresh_last_frame * cast,no_check(s32) (VP8_LAST_FRAME);

        return cast,no_check(Codec_Err_T) CODEC_OK;
    } else {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
}

vp8_set_postproc :: (ctx: *Codec_Alg_Priv_in_vp8_dx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    return cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
}

vp8_get_reference_in_vp8_dx_iface :: (ctx: *Codec_Alg_Priv_in_vp8_dx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    data := c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);

    if data != null {
        frame := data;
        sd: YV12_BUFFER_CONFIG = ---;

        image2yuvconfig_in_vp8_dx_iface(*frame.img, *sd);

        if ctx.yv12_frame_buffers.pbi[0] == null {
            return cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME;
        }

        return (cast,no_check(#type (_: *VP8_D_COMP, _: Ref_Frame_Type, _: *YV12_BUFFER_CONFIG) -> Codec_Err_T) (cast(*void) vp8dx_get_reference))(
            ctx.yv12_frame_buffers.pbi[0],
            frame.frame_type,
            *sd
        );
    } else {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
}

image2yuvconfig_in_vp8_dx_iface :: (img: *Image_T, yv12: *YV12_BUFFER_CONFIG) -> Codec_Err_T {
    Y_W := cast,no_check(s32) img.d_w;
    Y_H := cast,no_check(s32) img.d_h;
    UV_W := cast,no_check(s32) ((img.d_w + 1) / 2);
    UV_H := cast,no_check(s32) ((img.d_h + 1) / 2);
    res := cast,no_check(Codec_Err_T) CODEC_OK;
    yv12.y_buffer = img.planes[0];
    yv12.u_buffer = img.planes[1];
    yv12.v_buffer = img.planes[2];

    yv12.y_crop_width = Y_W;
    yv12.y_crop_height = Y_H;
    yv12.y_width = Y_W;
    yv12.y_height = Y_H;
    yv12.uv_crop_width = UV_W;
    yv12.uv_crop_height = UV_H;
    yv12.uv_width = UV_W;
    yv12.uv_height = UV_H;

    yv12.y_stride = img.stride[0];
    yv12.uv_stride = img.stride[1];

    yv12.border = cast,no_check(s32) (((cast,no_check(u32) img.stride[0]) - img.d_w) / 2);
    return res;
}

vp8_set_reference_in_vp8_dx_iface :: (ctx: *Codec_Alg_Priv_in_vp8_dx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    data := c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);

    if data != null {
        frame := data;
        sd: YV12_BUFFER_CONFIG = ---;

        image2yuvconfig_in_vp8_dx_iface(*frame.img, *sd);

        if ctx.yv12_frame_buffers.pbi[0] == null {
            return cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME;
        }

        return (cast,no_check(#type (_: *VP8_D_COMP, _: Ref_Frame_Type, _: *YV12_BUFFER_CONFIG) -> Codec_Err_T) (cast(*void) vp8dx_set_reference))(
            ctx.yv12_frame_buffers.pbi[0],
            frame.frame_type,
            *sd
        );
    } else {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
}

vp8_destroy :: (ctx: *Codec_Alg_Priv_in_vp8_dx_iface) -> Codec_Err_T {
    vp8_remove_decoder_instances(*ctx.yv12_frame_buffers);

    deallocate_memory(cast(*void) ctx);

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

vp8_init :: (ctx: *Codec_Ctx_T, data: *Codec_Priv_Enc_Mr_Cfg_T) -> Codec_Err_T {
    res := cast,no_check(Codec_Err_T) CODEC_OK;

    vp8_rtcd();
    dsp_rtcd();
    scale_rtcd();

    if ctx.priv == null {
        if vp8_init_ctx(ctx) != 0 {
            return cast,no_check(Codec_Err_T) CODEC_MEM_ERROR;
        }

        priv := cast(*Codec_Alg_Priv_in_vp8_dx_iface) ctx.priv;

        priv.fragments.count = 0;

        priv.fragments.enabled = cast,no_check(s32) (priv.base.init_flags & 0x40000);
    }

    return res;
}

vp8_init_ctx :: (ctx: *Codec_Ctx_T) -> s32 {
    priv :=
        cast(*Codec_Alg_Priv_in_vp8_dx_iface) calloc_2(
            1,
            size_of(Codec_Alg_Priv_in_vp8_dx_iface)
        );
    if priv == null {
        return 1;
    }

    ctx.priv = cast(*Codec_Priv_T) priv;
    ctx.priv.init_flags = ctx.init_flags;

    priv.si.sz = cast,no_check(u32) (cast(u64) size_of(Vp8_Stream_Info_T));
    priv.decrypt_cb = null;
    priv.decrypt_state = null;

    if ctx.config.dec != null {
        priv.cfg = ctx.config.dec.*;
        ctx.config.dec = *priv.cfg;
    }

    return 0;
}

codec_vp8_dx :: () -> *Codec_Iface_T {
    return *CODEC_VP8_DX_ALGO;
}

codec_control_vp8_d_get_last_ref_updates_in_vp8_dx_iface :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_frame_corrupted_in_vp8_dx_iface :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_get_last_ref_used_in_vp8_dx_iface :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vpxd_set_decryptor_in_vp8_dx_iface :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Decrypt_Init
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_d_set_decryptor_in_vp8_dx_iface :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Decrypt_Init
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_frame_size_in_vp8_dx_iface :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_display_size_in_vp8_dx_iface :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_get_bit_depth_in_vp8_dx_iface :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *u32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_set_byte_alignment_in_vp8_dx_iface :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_invert_tile_decode_order_in_vp8_dx_iface :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_set_skip_loop_filter_in_vp8_dx_iface :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_decode_svc_spatial_layer_in_vp8_dx_iface :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: s32
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vpxd_get_last_quantizer_in_vp8_dx_iface :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: *s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_set_row_mt_in_vp8_dx_iface :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_d_set_loop_filter_opt_in_vp8_dx_iface :: (ctx: *Codec_Ctx_T, ctrl_id: s32, data: s32) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

vp8dx_decode_bool :: (br: *BOOL_DECODER, probability: s32) -> s32 {
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

vp8_decode_value :: (br: *BOOL_DECODER, bits: s32) -> s32 {
    z: s32 = 0;

    bit := bits - 1;
    while bit >= 0 {
        z |= vp8dx_decode_bool(br, 0x80) << ((bit) & 31);
        bit -= 1;
    }

    return z;
}

vp8dx_bool_error :: (br: *BOOL_DECODER) -> s32 {
    if br.count > (cast,no_check(s32) (cast(u64) size_of(VP8_BD_VALUE))) * 8 && br.count < 0x40000000 {
        return 1;
    }

    return 0;
}

vp8_treed_read :: (R: *Vp8_Reader_in_treereader, t: *Vp8_Tree_Index, P: *Vp8_Prob) -> s32 {
    i: Vp8_Tree_Index = 0;

    while (ifx true { assignment_2: Vp8_Tree_Index = cast,no_check(Vp8_Tree_Index) (t[(cast(s32) i) + vp8dx_decode_bool(R, cast,no_check(s32) P[(cast(s32) i) >> 1])]); (i) = assignment_2; assignment_2; }) > 0 {
    }

    return -(cast,no_check(s32) i);
}

vp8_sem_wait_in_vp8_dx_iface :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_3: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_3; assignment_3; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init_in_vp8_dx_iface :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release_in_vp8_dx_iface :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

vp8_atomic_spin_wait_in_vp8_dx_iface :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire_in_vp8_dx_iface(last_row_current_mb_col) - NSYNC {
    }
}

globals_initialization_state_for_vp8_dx_iface: u32;
initialize_globals_for_vp8_dx_iface :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp8_dx_iface);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp8_dx_iface, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp8_dx_iface) != 2 {}
            return;
        }
    }
    VP8_CTF_MAPS =
        Codec_Ctrl_Fn_Map_T.[
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8_SET_REFERENCE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) vp8_set_reference_in_vp8_dx_iface},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8_COPY_REFERENCE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) vp8_get_reference_in_vp8_dx_iface},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8_SET_POSTPROC), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) vp8_set_postproc},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8D_GET_LAST_REF_UPDATES), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) vp8_get_last_ref_updates},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8D_GET_FRAME_CORRUPTED), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) vp8_get_frame_corrupted},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8D_GET_LAST_REF_USED), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) vp8_get_last_ref_frame},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (D_GET_LAST_QUANTIZER), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) vp8_get_quantizer_in_vp8_dx_iface},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (D_SET_DECRYPTOR), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) vp8_set_decryptor},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = -1, fn = null}
        ];
    CODEC_VP8_DX_ALGO =
        Codec_Iface_T.{
            name = c_string("WebM Project VP8 Decoder v1.17.0"),
            abi_version = 5,
            caps =
                cast,no_check(Codec_Caps_T) (((0x1 | (ifx ((cast(s32) 0) != 0) then cast(s32) 0x40000 else 0)) | (ifx ((cast(s32) 0) != 0) then cast(s32) 0x80000 else 0)) | 0x100000),
            init = vp8_init,
            destroy = cast,no_check(#type (_: *Codec_Alg_Priv_T) -> Codec_Err_T) vp8_destroy,
            ctrl_maps = VP8_CTF_MAPS.data,
            dec =
                Codec_Dec_Iface.{peek_si = vp8_peek_si, get_si = cast,no_check(#type (
                    _: *Codec_Alg_Priv_T,
                    _: *Codec_Stream_Info_T
                ) -> Codec_Err_T) vp8_get_si, decode = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *u8, _: u32, _: *void) -> Codec_Err_T) vp8_decode, get_frame = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Codec_Iter_T) -> *Image_T) vp8_get_frame, set_fb_fn = null},
            enc =
                Codec_Enc_Iface.{cfg_map_count = 0, cfg_maps = null, encode = null, get_cx_data = null, cfg_set = null, get_glob_hdrs = null, get_preview = null, mr_get_mem_loc = null, mr_free_mem_loc = null}
        };
    atomic_store(*globals_initialization_state_for_vp8_dx_iface, 2);
}

Frame_Buffers :: struct {
    pbi: [32] *VP8_D_COMP;
}

VP8_D_COMP :: struct {
    mb: MACROBLOCKD_in_blockd #align 16;
    dec_fb_ref: [4] *YV12_BUFFER_CONFIG #align 1;
    common: VP8_COMMON #align 1;
    mbc: [9] Vp8_Reader_in_treereader #align 1;
    oxcf: VP8_D_CONFIG #align 1;
    fragments: FRAGMENT_DATA #align 1;
    b_multithreaded_rd: Atomic_Int #align 1;
    max_threads: s32 #align 1;
    current_mb_col_main: s32 #align 1;
    decoding_thread_count: u32 #align 1;
    allocated_decoding_thread_count: s32 #align 1;
    mt_baseline_filter_level: [4] s32 #align 1;
    sync_range: s32 #align 1;
    mt_current_mb_col: *Atomic_Int #align 1;
    mt_yabove_row: **u8 #align 1;
    mt_uabove_row: **u8 #align 1;
    mt_vabove_row: **u8 #align 1;
    mt_yleft_col: **u8 #align 1;
    mt_uleft_col: **u8 #align 1;
    mt_vleft_col: **u8 #align 1;
    mb_row_di: *MB_ROW_DEC #align 1;
    de_thread_data: *DECODETHREAD_DATA #align 1;
    h_decoding_thread: *Pthread_T #align 1;
    h_event_start_decoding: *Sem_T #align 1;
    h_event_end_decoding: Sem_T #align 1;
    ready_for_new_data: s32 #align 1;
    prob_intra: Vp8_Prob #align 1;
    prob_last: Vp8_Prob #align 1;
    prob_gf: Vp8_Prob #align 1;
    prob_skip_false: Vp8_Prob #align 1;
    ec_enabled: s32 #align 1;
    ec_active: s32 #align 1;
    decoded_key_frame: s32 #align 1;
    independent_partitions: s32 #align 1;
    frame_corrupt_residual: s32 #align 1;
    layout_padding_0: [4] u8 #align 1;
    decrypt_cb: Decrypt_Cb #align 1;
    decrypt_state: *void #align 1;
    restart_threads: s32 #align 1;
    layout_padding_1: [12] u8 #align 1;
} #no_padding;

Vp8_Postproc_Level :: u32;
VP8_NOFILTERING : s32 : 0;
VP8_DEBLOCK : s32 : 1;
VP8_DEMACROBLOCK : s32 : 2;
VP8_ADDNOISE : s32 : 4;
VP8_MFQE : s32 : 8;

BOOL_DECODER :: Vp8_Reader;

VP8_BD_VALUE :: u64;

Vp8_Reader_in_treereader :: BOOL_DECODER;

Vp8_Dec_Control_Id :: u32;
VP8D_GET_LAST_REF_UPDATES : s32 : 256;
VP8D_GET_FRAME_CORRUPTED : s32 : 257;
VP8D_GET_LAST_REF_USED : s32 : 258;
D_SET_DECRYPTOR : s32 : 259;
VP8D_SET_DECRYPTOR : s32 : 259;
VP9D_GET_FRAME_SIZE : s32 : 260;
VP9D_GET_DISPLAY_SIZE : s32 : 261;
VP9D_GET_BIT_DEPTH : s32 : 262;
VP9_SET_BYTE_ALIGNMENT : s32 : 263;
VP9_INVERT_TILE_DECODE_ORDER : s32 : 264;
VP9_SET_SKIP_LOOP_FILTER : s32 : 265;
VP9_DECODE_SVC_SPATIAL_LAYER : s32 : 266;
D_GET_LAST_QUANTIZER : s32 : 267;
VP9D_SET_ROW_MT : s32 : 268;
VP9D_SET_LOOP_FILTER_OPT : s32 : 269;
VP8_DECODER_CTRL_ID_MAX : s32 : 270;

FRAGMENT_DATA :: struct {
    enabled: s32;
    count: u32;
    ptrs: [9] *u8;
    sizes: [9] u32;
}

VP8_D_CONFIG :: struct {
    width: s32;
    height: s32;
    version: s32;
    postprocess: s32;
    max_threads: s32;
    error_concealment: s32;
}

MB_ROW_DEC :: struct {
    mbd: MACROBLOCKD_in_blockd #align 16;
} #no_padding;

Vp8_Reader :: struct {
    user_buffer_end: *u8;
    user_buffer: *u8;
    value: VP8_BD_VALUE;
    count: s32;
    range: u32;
    decrypt_cb: Decrypt_Cb;
    decrypt_state: *void;
}

DECODETHREAD_DATA :: struct {
    ithread: s32;
    ptr1: *void;
    ptr2: *void;
}

