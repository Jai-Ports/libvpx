CODEC_VP9_DX_ALGO: Codec_Iface_T;

DECODER_CTRL_MAPS: [18] Codec_Ctrl_Fn_Map_T;

COUNT_TO_UPDATE_FACTOR_in_vp9_dx_iface: [21] s32;

SUB_PEL_FILTERS_12_in_vp9_dx_iface: [16] Interp_Kernel12 #align 256;

vp8_set_reference_value_in_vp9_dx_iface :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_vp9_dx_iface :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_vp9_dx_iface :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_vp9_dx_iface :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

decoder_set_fb_fn :: (
    ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4,
    cb_get: Get_Frame_Buffer_Cb_Fn_T,
    cb_release: Release_Frame_Buffer_Cb_Fn_T,
    cb_priv: *void
) -> Codec_Err_T {
    if cb_get == null || cb_release == null {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    } else if ctx.pbi == null {
        ctx.get_ext_fb_cb = cb_get;
        ctx.release_ext_fb_cb = cb_release;
        ctx.ext_priv = cb_priv;
        return cast,no_check(Codec_Err_T) CODEC_OK;
    }

    return cast,no_check(Codec_Err_T) CODEC_ERROR;
}

decoder_get_frame :: (ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4, iter: *Codec_Iter_T) -> *Image_T {
    img: *Image_T = null;

    if ctx.pbi != null {
        sd: YV12_BUFFER_CONFIG = ---;
        flags: Vp9_Ppflags_T;
        if ctx.base.init_flags & 0x10000 != 0 {
            set_ppflags(ctx, *flags);
        }
        if (cast,no_check(#type (_: *VP9_Decoder, _: *YV12_BUFFER_CONFIG, _: *Vp9_Ppflags_T) -> s32) (cast(*void) vp9_get_raw_frame))(
            ctx.pbi,
            *sd,
            *flags
        ) == 0 {
            CM := *ctx.pbi.common;
            FRAME_BUFS := CM.buffer_pool.frame_bufs.data;
            ctx.last_show_frame = ctx.pbi.common.new_fb_idx;
            if ctx.need_resync != 0 {
                return null;
            }
            yuvconfig2image_2(*ctx.img, *sd, ctx.user_priv);
            ctx.img.fb_priv = FRAME_BUFS[CM.new_fb_idx].raw_frame_buffer.priv;
            img = *ctx.img;
            return img;
        }
    }
    return null;
}

set_ppflags :: (ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4, flags: *Vp9_Ppflags_T) {
    flags.post_proc_flag = ctx.postproc_cfg.post_proc_flag;

    flags.deblocking_level = ctx.postproc_cfg.deblocking_level;
    flags.noise_level = ctx.postproc_cfg.noise_level;
}

decoder_decode :: (
    ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4,
    data: *u8,
    data_sz: u32,
    user_priv: *void
) -> Codec_Err_T {
    data_start := data;
    res: Codec_Err_T = ---;
    frame_sizes: [8] u32 = ---;
    frame_count: s32 = ---;

    if data == null && data_sz == 0 {
        ctx.flushed = 1;
        return cast,no_check(Codec_Err_T) CODEC_OK;
    }

    ctx.flushed = 0;

    if ctx.pbi == null {
        res = init_decoder(ctx);
        if res != cast,no_check(u32) CODEC_OK {
            return res;
        }
    }

    res =
        (cast,no_check(#type (_: *u8, _: u64, _: *u32, _: *s32, _: Decrypt_Cb, _: *void) -> Codec_Err_T) (cast(*void) vp9_parse_superframe_index))(
            data,
            cast,no_check(u64) data_sz,
            frame_sizes.data,
            *frame_count,
            ctx.decrypt_cb,
            ctx.decrypt_state
        );
    if res != cast,no_check(u32) CODEC_OK {
        return res;
    }

    if ctx.svc_decoding != 0 && ctx.svc_spatial_layer < frame_count - 1 {
        frame_count = ctx.svc_spatial_layer + 1;
    }

    if frame_count > 0 {
        DATA_END := data + data_sz;

        if 0 < frame_count {
            for i: 0..frame_count - 1 {
                data_start_copy := data_start;
                FRAME_SIZE := frame_sizes[i];
                if data_start < data || FRAME_SIZE > cast,no_check(u32) (DATA_END - data_start) {
                    set_error_detail(ctx, c_string("Invalid frame size in index"));
                    return cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME;
                }

                res = decode_one(ctx, *data_start_copy, FRAME_SIZE, user_priv);
                if res != cast,no_check(u32) CODEC_OK {
                    return res;
                }

                data_start += FRAME_SIZE;
            }
        }
    } else {
        DATA_END := data + data_sz;
        while data_start < DATA_END {
            FRAME_SIZE := cast,no_check(u32) (DATA_END - data_start);
            res = decode_one(ctx, *data_start, FRAME_SIZE, user_priv);
            if res != cast,no_check(u32) CODEC_OK {
                return res;
            }

            while data_start < DATA_END {
                MARKER := read_marker(cast,no_check(Decrypt_Cb) (ctx.decrypt_cb), ctx.decrypt_state, data_start);
                if MARKER != 0 {
                    break;
                }
                data_start += 1;
            }
        }
    }

    return res;
}

read_marker :: (decrypt_cb: Decrypt_Cb, decrypt_state: *void, data: *u8) -> u8 {
    if decrypt_cb != null {
        marker: u8 = ---;
        decrypt_cb(decrypt_state, data, *marker, 1);
        return marker;
    }
    return data.*;
}

decode_one :: (
    ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4,
    data: **u8,
    data_sz: u32,
    user_priv: *void
) -> Codec_Err_T {
    if ctx.si.h == 0 {
        is_intra_only: s32 = 0;
        RES :=
            decoder_peek_si_internal(
                data.*,
                data_sz,
                *ctx.si,
                *is_intra_only,
                cast,no_check(Decrypt_Cb) (ctx.decrypt_cb),
                ctx.decrypt_state
            );
        if RES != cast,no_check(u32) CODEC_OK {
            return RES;
        }

        if ctx.si.is_kf == 0 && is_intra_only == 0 {
            return cast,no_check(Codec_Err_T) CODEC_ERROR;
        }
    }

    ctx.user_priv = user_priv;

    ctx.pbi.decrypt_cb = ctx.decrypt_cb;
    ctx.pbi.decrypt_state = ctx.decrypt_state;

    if vp9_receive_compressed_data(ctx.pbi, cast,no_check(u64) data_sz, data) != 0 {
        ctx.pbi.cur_buf.buf.corrupted = 1;
        ctx.pbi.need_resync = 1;
        ctx.need_resync = 1;
        return update_error_state_in_vp9_dx_iface(ctx, *ctx.pbi.common.error);
    }

    check_resync(ctx, ctx.pbi);

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

decode_one :: (
    ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4,
    data: **u8,
    data_sz: u32,
    user_priv: *$Value
) -> Codec_Err_T {
    return decode_one(ctx, data, data_sz, cast(*void) user_priv);
}

check_resync :: (CTX: *Codec_Alg_Priv_T_in_vpx_codec_internal_4, PBI: *VP9_Decoder) {
    if CTX.need_resync == 1 &&
        PBI.need_resync == 0 &&
        (PBI.common.intra_only != 0 || PBI.common.frame_type == cast,no_check(u32) KEY_FRAME) {
        CTX.need_resync = 0;
    }
}

update_error_state_in_vp9_dx_iface :: (
    ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4,
    error: *Internal_Error_Info
) -> Codec_Err_T {
    if error.error_code != 0 {
        set_error_detail(ctx, (ifx error.has_detail != 0 then error.detail.data else null));
    }

    return error.error_code;
}

set_error_detail :: (ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4, ERROR: *s8) {
    ctx.base.err_detail = ERROR;
}

decoder_peek_si_internal :: (
    data: *u8,
    data_sz: u32,
    si: *Codec_Stream_Info_T,
    is_intra_only: *s32,
    decrypt_cb: Decrypt_Cb,
    decrypt_state: *void
) -> Codec_Err_T {
    intra_only_flag: s32 = 0;
    clear_buffer: [11] u8 = ---;

    if data + data_sz <= data {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    si.is_kf = 0;
    si.h = 0;
    si.w = si.h;

    if decrypt_cb != null {
        data_sz =
            cast,no_check(u32) ((ifx clear_buffer.count < cast,no_check(u64) data_sz then clear_buffer.count else cast,no_check(u64) data_sz));
        decrypt_cb(decrypt_state, data, clear_buffer.data, cast,no_check(s32) data_sz);
        data = clear_buffer.data;
    }

    if data_sz < 1 {
        return cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM;
    }

    {
        rb :=
            Read_Bit_Buffer.{
                bit_buffer = data,
                bit_buffer_end = data + data_sz,
                bit_offset = 0,
                error_handler_data = null,
                error_handler = null
            };
        FRAME_MARKER := rb_read_literal(*rb, 2);
        PROFILE := vp9_read_profile(*rb);

        if FRAME_MARKER != 0x2 {
            return cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM;
        }

        if PROFILE >= cast,no_check(u32) MAX_PROFILES {
            return cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM;
        }

        if rb_read_bit(*rb) != 0 {
            if PROFILE > 2 && data_sz < 2 {
                return cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM;
            }
            rb_read_literal(*rb, 3);
            return cast,no_check(Codec_Err_T) CODEC_OK;
        }

        if data_sz < 10 {
            return cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM;
        }

        si.is_kf = cast(u32) (rb_read_bit(*rb) == 0);
        show_frame := rb_read_bit(*rb);
        error_resilient := rb_read_bit(*rb);

        if si.is_kf != 0 {
            if vp9_read_sync_code(*rb) == 0 {
                return cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM;
            }

            if parse_bitdepth_colorspace_sampling(PROFILE, *rb) == 0 {
                return cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM;
            }
            vp9_read_frame_size(*rb, cast(*s32) *si.w, cast(*s32) *si.h);
        } else {
            intra_only_flag = ifx show_frame != 0 then 0 else rb_read_bit(*rb);

            rb.bit_offset += (ifx error_resilient != 0 then cast(u64) 0 else 2);

            if intra_only_flag != 0 {
                if vp9_read_sync_code(*rb) == 0 {
                    return cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM;
                }
                if PROFILE > cast,no_check(u32) PROFILE_0 {
                    if parse_bitdepth_colorspace_sampling(PROFILE, *rb) == 0 {
                        return cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM;
                    }

                    if data_sz < 11 {
                        return cast,no_check(Codec_Err_T) CODEC_UNSUP_BITSTREAM;
                    }
                }
                rb.bit_offset += cast,no_check(u64) ((cast(s32) 1) << 3);
                vp9_read_frame_size(*rb, cast(*s32) *si.w, cast(*s32) *si.h);
            }
        }
    }
    if is_intra_only != null {
        is_intra_only.* = intra_only_flag;
    }
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

decoder_peek_si_internal :: (
    data: *u8,
    data_sz: u32,
    si: *Codec_Stream_Info_T,
    is_intra_only: *s32,
    decrypt_cb: Decrypt_Cb,
    decrypt_state: *$Value
) -> Codec_Err_T {
    return decoder_peek_si_internal(data, data_sz, si, is_intra_only, decrypt_cb, cast(*void) decrypt_state);
}

parse_bitdepth_colorspace_sampling :: (profile: BITSTREAM_PROFILE, rb: *Read_Bit_Buffer) -> s32 {
    if profile >= cast,no_check(u32) PROFILE_2 {
        rb.bit_offset += 1;
    }
    color_space := cast,no_check(Color_Space_T) rb_read_literal(rb, 3);
    if color_space != cast,no_check(u32) CS_SRGB {
        rb.bit_offset += 1;
        if profile == cast,no_check(u32) PROFILE_1 || profile == cast,no_check(u32) PROFILE_3 {
            rb.bit_offset += 2;
            rb.bit_offset += 1;
        }
    } else if profile == cast,no_check(u32) PROFILE_1 || profile == cast,no_check(u32) PROFILE_3 {
        rb.bit_offset += 1;
    } else {
        return 0;
    }
    return 1;
}

init_decoder :: (ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4) -> Codec_Err_T {
    ctx.last_show_frame = -1;
    ctx.need_resync = 1;
    ctx.flushed = 0;

    ctx.buffer_pool = cast(*Buffer_Pool) calloc_2(1, size_of(Buffer_Pool));
    if ctx.buffer_pool == null {
        return cast,no_check(Codec_Err_T) CODEC_MEM_ERROR;
    }

    ctx.pbi = vp9_decoder_create(ctx.buffer_pool);
    if ctx.pbi == null {
        deallocate_memory(cast(*void) ctx.buffer_pool);
        ctx.buffer_pool = null;
        set_error_detail(ctx, c_string("Failed to allocate decoder"));
        return cast,no_check(Codec_Err_T) CODEC_MEM_ERROR;
    }
    ctx.pbi.max_threads = cast,no_check(s32) ctx.cfg.threads;
    ctx.pbi.inv_tile_order = ctx.invert_tile_order;

    if !((ctx.row_mt == 0 || ctx.row_mt > 0) && ctx.row_mt <= 1) {
        ctx.base.err_detail = c_string("row_mt out of range [0..1]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    ctx.pbi.row_mt = ctx.row_mt;

    if !((ctx.lpf_opt == 0 || ctx.lpf_opt > 0) && ctx.lpf_opt <= 1) {
        ctx.base.err_detail = c_string("lpf_opt out of range [0..1]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    ctx.pbi.lpf_mt_opt = ctx.lpf_opt;

    if ctx.postproc_cfg_set == 0 && ctx.base.init_flags & 0x10000 != 0 {
        set_default_ppflags(*ctx.postproc_cfg);
    }

    res := init_buffer_callbacks(ctx);
    if res != cast,no_check(u32) CODEC_OK {
        deallocate_memory(cast(*void) ctx.buffer_pool);
        ctx.buffer_pool = null;
        vp9_decoder_remove(ctx.pbi);
        ctx.pbi = null;
    }
    return res;
}

init_buffer_callbacks :: (ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4) -> Codec_Err_T {
    CM := *ctx.pbi.common;
    POOL := CM.buffer_pool;

    CM.new_fb_idx = -1;
    CM.byte_alignment = ctx.byte_alignment;
    CM.skip_loop_filter = ctx.skip_loop_filter;

    if ctx.get_ext_fb_cb != null && ctx.release_ext_fb_cb != null {
        POOL.get_fb_cb = ctx.get_ext_fb_cb;
        POOL.release_fb_cb = ctx.release_ext_fb_cb;
        POOL.cb_priv = ctx.ext_priv;
    } else {
        POOL.get_fb_cb = vp9_get_frame_buffer;
        POOL.release_fb_cb = vp9_release_frame_buffer;

        if vp9_alloc_internal_frame_buffers(*POOL.int_frame_buffers) != 0 {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to initialize internal frame buffers")
            );
            return cast,no_check(Codec_Err_T) CODEC_MEM_ERROR;
        }

        POOL.cb_priv = cast(*void) *POOL.int_frame_buffers;
    }

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

set_default_ppflags :: (cfg: *Vp8_Postproc_Cfg_T) {
    cfg.post_proc_flag = (cast,no_check(s32) (VP8_DEBLOCK)) | cast,no_check(s32) (VP8_DEMACROBLOCK);
    cfg.deblocking_level = 4;
    cfg.noise_level = 0;
}

decoder_get_si :: (ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4, si: *Codec_Stream_Info_T) -> Codec_Err_T {
    SZ: u64 =
        (ifx cast,no_check(u64) si.sz >= size_of(Vp9_Stream_Info_T) then cast(u64) size_of(Vp9_Stream_Info_T) else cast(u64) size_of(Codec_Stream_Info_T));
    copy_memory(si, *ctx.si, SZ);
    si.sz = cast,no_check(u32) SZ;

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

decoder_peek_si :: (data: *u8, data_sz: u32, si: *Codec_Stream_Info_T) -> Codec_Err_T {
    return decoder_peek_si_internal(data, data_sz, si, null, null, null);
}

ctrl_get_frame_size :: (ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4, args: *Va_List_Tag) -> Codec_Err_T {
    FRAME_SIZE := c_transpiler_va_arg(cast(*void) (args), *s32);

    if FRAME_SIZE != null {
        if ctx.pbi != null {
            CM := *ctx.pbi.common;
            FRAME_SIZE[0] = CM.width;
            FRAME_SIZE[1] = CM.height;
            return cast,no_check(Codec_Err_T) CODEC_OK;
        } else {
            return cast,no_check(Codec_Err_T) CODEC_ERROR;
        }
    }

    return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
}

ctrl_get_bit_depth :: (ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4, args: *Va_List_Tag) -> Codec_Err_T {
    BIT_DEPTH := c_transpiler_va_arg(cast(*void) (args), *u32);

    if BIT_DEPTH != null {
        if ctx.pbi != null {
            CM := *ctx.pbi.common;
            BIT_DEPTH.* = CM.bit_depth;
            return cast,no_check(Codec_Err_T) CODEC_OK;
        } else {
            return cast,no_check(Codec_Err_T) CODEC_ERROR;
        }
    }

    return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
}

ctrl_get_render_size :: (ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4, args: *Va_List_Tag) -> Codec_Err_T {
    RENDER_SIZE := c_transpiler_va_arg(cast(*void) (args), *s32);

    if RENDER_SIZE != null {
        if ctx.pbi != null {
            CM := *ctx.pbi.common;
            RENDER_SIZE[0] = CM.render_width;
            RENDER_SIZE[1] = CM.render_height;
            return cast,no_check(Codec_Err_T) CODEC_OK;
        } else {
            return cast,no_check(Codec_Err_T) CODEC_ERROR;
        }
    }

    return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
}

ctrl_get_reference_in_vp9_dx_iface :: (
    ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4,
    args: *Va_List_Tag
) -> Codec_Err_T {
    data := c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);

    if data != null {
        if ctx.pbi != null {
            FB_IDX := ctx.pbi.common.cur_show_frame_fb_idx;
            fb := get_buf_frame_in_vp9_dx_iface(*ctx.pbi.common, FB_IDX);
            if fb == null {
                return cast,no_check(Codec_Err_T) CODEC_ERROR;
            }
            yuvconfig2image_2(*data.img, fb, null);
            return cast,no_check(Codec_Err_T) CODEC_OK;
        } else {
            return cast,no_check(Codec_Err_T) CODEC_ERROR;
        }
    } else {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
}

get_buf_frame_in_vp9_dx_iface :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

ctrl_get_frame_corrupted :: (ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4, args: *Va_List_Tag) -> Codec_Err_T {
    corrupted := c_transpiler_va_arg(cast(*void) (args), *s32);

    if corrupted != null {
        if ctx.pbi != null {
            FRAME_BUFS := ctx.pbi.common.buffer_pool.frame_bufs.data;
            if ctx.pbi.common.frame_to_show == null {
                return cast,no_check(Codec_Err_T) CODEC_ERROR;
            }
            if ctx.last_show_frame >= 0 {
                corrupted.* = FRAME_BUFS[ctx.last_show_frame].buf.corrupted;
            }
            return cast,no_check(Codec_Err_T) CODEC_OK;
        } else {
            return cast,no_check(Codec_Err_T) CODEC_ERROR;
        }
    }

    return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
}

ctrl_get_last_ref_updates :: (ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4, args: *Va_List_Tag) -> Codec_Err_T {
    UPDATE_INFO := c_transpiler_va_arg(cast(*void) (args), *s32);

    if UPDATE_INFO != null {
        if ctx.pbi != null {
            UPDATE_INFO.* = ctx.pbi.refresh_frame_flags;
            return cast,no_check(Codec_Err_T) CODEC_OK;
        } else {
            return cast,no_check(Codec_Err_T) CODEC_ERROR;
        }
    }

    return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
}

ctrl_get_quantizer_in_vp9_dx_iface :: (
    ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4,
    args: *Va_List_Tag
) -> Codec_Err_T {
    ARG := c_transpiler_va_arg(cast(*void) (args), *s32);
    if ARG == null || ctx.pbi == null {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    ARG.* = ctx.pbi.common.base_qindex;
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_enable_lpf_opt :: (ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4, args: *Va_List_Tag) -> Codec_Err_T {
    ctx.lpf_opt = c_transpiler_va_arg(cast(*void) (args), s32);

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_set_row_mt_in_vp9_dx_iface :: (ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4, args: *Va_List_Tag) -> Codec_Err_T {
    ctx.row_mt = c_transpiler_va_arg(cast(*void) (args), s32);

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_set_spatial_layer_svc :: (ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4, args: *Va_List_Tag) -> Codec_Err_T {
    ctx.svc_decoding = 1;
    ctx.svc_spatial_layer = c_transpiler_va_arg(cast(*void) (args), s32);
    if ctx.svc_spatial_layer < 0 {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    } else {
        return cast,no_check(Codec_Err_T) CODEC_OK;
    }
}

ctrl_set_skip_loop_filter :: (ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4, args: *Va_List_Tag) -> Codec_Err_T {
    ctx.skip_loop_filter = c_transpiler_va_arg(cast(*void) (args), s32);

    if ctx.pbi != null {
        ctx.pbi.common.skip_loop_filter = ctx.skip_loop_filter;
    }

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_set_byte_alignment :: (ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4, args: *Va_List_Tag) -> Codec_Err_T {
    LEGACY_BYTE_ALIGNMENT: s32 = 0;
    MIN_BYTE_ALIGNMENT: s32 = 32;
    MAX_BYTE_ALIGNMENT: s32 = 1024;
    BYTE_ALIGNMENT := c_transpiler_va_arg(cast(*void) (args), s32);

    if BYTE_ALIGNMENT != LEGACY_BYTE_ALIGNMENT &&
        (BYTE_ALIGNMENT < MIN_BYTE_ALIGNMENT || BYTE_ALIGNMENT > MAX_BYTE_ALIGNMENT || BYTE_ALIGNMENT & (BYTE_ALIGNMENT - 1) != 0) {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    ctx.byte_alignment = BYTE_ALIGNMENT;
    if ctx.pbi != null {
        ctx.pbi.common.byte_alignment = BYTE_ALIGNMENT;
    }
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_set_decryptor :: (ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4, args: *Va_List_Tag) -> Codec_Err_T {
    init := c_transpiler_va_arg(cast(*void) (args), *Decrypt_Init);
    ctx.decrypt_cb = ifx init != null then init.decrypt_cb else null;
    ctx.decrypt_state = ifx init != null then init.decrypt_state else null;
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_set_invert_tile_order :: (ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4, args: *Va_List_Tag) -> Codec_Err_T {
    ctx.invert_tile_order = c_transpiler_va_arg(cast(*void) (args), s32);
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_set_postproc :: (ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4, args: *Va_List_Tag) -> Codec_Err_T {
    return cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
}

ctrl_set_reference_in_vp9_dx_iface :: (
    ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4,
    args: *Va_List_Tag
) -> Codec_Err_T {
    DATA := c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);

    if DATA != null {
        FRAME := DATA;
        sd: YV12_BUFFER_CONFIG = ---;
        image2yuvconfig_2(*FRAME.img, *sd);
        if ctx.pbi == null {
            return cast,no_check(Codec_Err_T) CODEC_ERROR;
        }
        return (cast,no_check(#type (_: *VP9_COMMON, _: VP9_REFFRAME, _: *YV12_BUFFER_CONFIG) -> Codec_Err_T) (cast(*void) vp9_set_reference_dec))(
            *ctx.pbi.common,
            ref_frame_to_vp9_reframe_in_vp9_dx_iface(FRAME.frame_type),
            *sd
        );
    } else {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
}

ref_frame_to_vp9_reframe_in_vp9_dx_iface :: (frame: Ref_Frame_Type_T) -> VP9_REFFRAME {
    if frame == {
        case cast,no_check(u32) VP8_LAST_FRAME;
            return cast,no_check(VP9_REFFRAME) VP9_LAST_FLAG;
        case cast,no_check(u32) VP8_GOLD_FRAME;
            return cast,no_check(VP9_REFFRAME) VP9_GOLD_FLAG;
        case cast,no_check(u32) VP8_ALTR_FRAME;
            return cast,no_check(VP9_REFFRAME) VP9_ALT_FLAG;
    }

    return cast,no_check(VP9_REFFRAME) VP9_LAST_FLAG;
}

ctrl_copy_reference_in_vp9_dx_iface :: (
    ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4,
    args: *Va_List_Tag
) -> Codec_Err_T {
    data := c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);

    if data != null {
        frame := data;
        sd: YV12_BUFFER_CONFIG = ---;
        image2yuvconfig_2(*frame.img, *sd);
        if ctx.pbi == null {
            return cast,no_check(Codec_Err_T) CODEC_ERROR;
        }
        return (cast,no_check(#type (_: *VP9_Decoder, _: VP9_REFFRAME, _: *YV12_BUFFER_CONFIG) -> Codec_Err_T) (cast(*void) vp9_copy_reference_dec))(
            ctx.pbi,
            frame.frame_type,
            *sd
        );
    } else {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
}

decoder_destroy :: (ctx: *Codec_Alg_Priv_T_in_vpx_codec_internal_4) -> Codec_Err_T {
    if ctx.pbi != null {
        vp9_decoder_remove(ctx.pbi);
    }

    if ctx.buffer_pool != null {
        vp9_free_ref_frame_buffers(ctx.buffer_pool);
        vp9_free_internal_frame_buffers(*ctx.buffer_pool.int_frame_buffers);
    }

    deallocate_memory(cast(*void) ctx.buffer_pool);
    deallocate_memory(cast(*void) ctx);
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

decoder_init :: (ctx: *Codec_Ctx_T, data: *Codec_Priv_Enc_Mr_Cfg_T) -> Codec_Err_T {
    if ctx.priv == null {
        PRIV :=
            cast(*Codec_Alg_Priv_T_in_vpx_codec_internal_4) calloc_2(
                1,
                size_of(Codec_Alg_Priv_T_in_vpx_codec_internal_4)
            );
        if PRIV == null {
            return cast,no_check(Codec_Err_T) CODEC_MEM_ERROR;
        }

        ctx.priv = cast(*Codec_Priv_T) PRIV;
        ctx.priv.init_flags = ctx.init_flags;
        PRIV.si.sz = cast,no_check(u32) (cast(u64) size_of(Vp9_Stream_Info_T));
        PRIV.flushed = 0;
        if ctx.config.dec != null {
            PRIV.cfg = ctx.config.dec.*;
            ctx.config.dec = *PRIV.cfg;
        }
    }

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

codec_vp9_dx :: () -> *Codec_Iface_T {
    return *CODEC_VP9_DX_ALGO;
}

vp8_d_get_last_ref_updates_value_in_vp9_dx_iface :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_d_get_frame_corrupted_value_in_vp9_dx_iface :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_d_get_last_ref_used_value_in_vp9_dx_iface :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

d_set_decryptor_value_in_vp9_dx_iface :: (args: *Va_List_Tag) -> *Decrypt_Init {
    return c_transpiler_va_arg(cast(*void) (args), *Decrypt_Init);
}

vp8_d_set_decryptor_value_in_vp9_dx_iface :: (args: *Va_List_Tag) -> *Decrypt_Init {
    return c_transpiler_va_arg(cast(*void) (args), *Decrypt_Init);
}

vp9_d_get_frame_size_value_in_vp9_dx_iface :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_d_get_display_size_value_in_vp9_dx_iface :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_d_get_bit_depth_value_in_vp9_dx_iface :: (args: *Va_List_Tag) -> *u32 {
    return c_transpiler_va_arg(cast(*void) (args), *u32);
}

vp9_set_byte_alignment_value_in_vp9_dx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_invert_tile_decode_order_value_in_vp9_dx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_set_skip_loop_filter_value_in_vp9_dx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_decode_svc_spatial_layer_value_in_vp9_dx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

d_get_last_quantizer_value_in_vp9_dx_iface :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_d_set_row_mt_value_in_vp9_dx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_d_set_loop_filter_opt_value_in_vp9_dx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

clip_pixel_in_vp9_dx_iface :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_dx_iface :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_dx_iface :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_dx_iface :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_dx_iface :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_dx_iface(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_dx_iface(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_dx_iface(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_dx_iface :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_prob_in_vp9_dx_iface :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_dx_iface :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_dx_iface(n0, DEN);
}

weighted_prob_in_vp9_dx_iface :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_dx_iface :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_dx_iface(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_dx_iface(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_dx_iface :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_dx_iface[COUNT];
        PROB := get_prob_in_vp9_dx_iface(ct[0], DEN);
        return weighted_prob_in_vp9_dx_iface(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

reader_has_error_in_vp9_dx_iface :: (r: *Reader) -> s32 {
    if r.count > (cast,no_check(s32) (cast(u64) size_of(BD_VALUE))) * 8 && r.count < 0x40000000 {
        return 1;
    }
    return 0;
}

read_in_vp9_dx_iface :: (r: *Reader, prob: s32) -> s32 {
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

read_bit_in_vp9_dx_iface :: (r: *Reader) -> s32 {
    return read_in_vp9_dx_iface(r, 128);
}

read_literal_in_vp9_dx_iface :: (r: *Reader, bits: s32) -> s32 {
    literal: s32 = 0;

    bit := bits - 1;
    while bit >= 0 {
        literal |= read_bit_in_vp9_dx_iface(r) << ((bit) & 31);
        bit -= 1;
    }

    return literal;
}

read_tree_in_vp9_dx_iface :: (r: *Reader, tree: *Tree_Index, probs: *Prob) -> s32 {
    i: Tree_Index = 0;

    while (ifx true { assignment_1: Tree_Index = cast,no_check(Tree_Index) (tree[(cast(s32) i) + read_in_vp9_dx_iface(r, cast,no_check(s32) probs[(cast(s32) i) >> 1])]); (i) = assignment_1; assignment_1; }) > 0 {
        continue;
    }

    return -(cast,no_check(s32) i);
}

get_lsb_in_vp9_dx_iface :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_dx_iface :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_dx_iface :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_dx_iface(num_values) + 1 else 0;
}

get_band_translate_in_vp9_dx_iface :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_dx_iface :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_dx_iface :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_dx_iface(above_ec, left_ec);
}

is_zero_mv_in_vp9_dx_iface :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_dx_iface :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_dx_iface :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_dx_iface(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_dx_iface(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_dx_iface :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_dx_iface :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_dx_iface :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_dx_iface :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

get_filter_taps_in_vp9_dx_iface :: (FILTER: *s16) -> s32 {
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

vp9_is_valid_scale_in_vp9_dx_iface :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_dx_iface :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_dx_iface(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_dx_iface :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_dx_iface :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_dx_iface :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_dx_iface :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_dx_iface :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_dx_iface :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_dx_iface :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_dx_iface :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_dx_iface :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_dx_iface :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_dx_iface :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_dx_iface(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_dx_iface :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_dx_iface(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_dx_iface(MI, ib)];
}

get_uv_tx_size_in_vp9_dx_iface :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_dx_iface :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_dx_iface :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_dx_iface(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_dx_iface :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_dx_iface :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_dx_iface :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_dx_iface :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_dx_iface :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_ref_frame_in_vp9_dx_iface :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_dx_iface :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_dx_iface :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_dx_iface :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_dx_iface :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_dx_iface :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_dx_iface :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_dx_iface(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_dx_iface :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_dx_iface(cm.mi_cols);

        if get_plane_type_in_vp9_dx_iface(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_dx_iface(cm, xd);
}

get_partition_probs_in_vp9_dx_iface :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_dx_iface :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_dx_iface :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_dx_iface :: (
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

update_partition_context_in_vp9_dx_iface :: (
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

partition_plane_context_in_vp9_dx_iface :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

decrease_ref_count :: (idx: s32, FRAME_BUFS: *Ref_Cnt_Buffer, POOL: *Buffer_Pool) {
    if idx >= 0 && FRAME_BUFS[idx].ref_count > 0 {
        FRAME_BUFS[idx].ref_count -= 1;

        if FRAME_BUFS[idx].released == 0 && FRAME_BUFS[idx].ref_count == 0 && FRAME_BUFS[idx].raw_frame_buffer.priv != null {
            POOL.release_fb_cb(POOL.cb_priv, *FRAME_BUFS[idx].raw_frame_buffer);
            FRAME_BUFS[idx].released = 1;
        }
    }
}

globals_initialization_state_for_vp9_dx_iface: u32;
initialize_globals_for_vp9_dx_iface :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_dx_iface);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_dx_iface, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_dx_iface) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_vp9_dx_iface =
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
    SUB_PEL_FILTERS_12_in_vp9_dx_iface =
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
    DECODER_CTRL_MAPS =
        Codec_Ctrl_Fn_Map_T.[
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8_COPY_REFERENCE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_copy_reference_in_vp9_dx_iface},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8_SET_REFERENCE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_reference_in_vp9_dx_iface},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8_SET_POSTPROC), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_postproc},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9_INVERT_TILE_DECODE_ORDER), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_invert_tile_order},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (D_SET_DECRYPTOR), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_decryptor},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9_SET_BYTE_ALIGNMENT), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_byte_alignment},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9_SET_SKIP_LOOP_FILTER), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_skip_loop_filter},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9_DECODE_SVC_SPATIAL_LAYER), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_spatial_layer_svc},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9D_SET_ROW_MT), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_row_mt_in_vp9_dx_iface},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9D_SET_LOOP_FILTER_OPT), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_enable_lpf_opt},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (D_GET_LAST_QUANTIZER), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_get_quantizer_in_vp9_dx_iface},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8D_GET_LAST_REF_UPDATES), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_get_last_ref_updates},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8D_GET_FRAME_CORRUPTED), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_get_frame_corrupted},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9_GET_REFERENCE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_get_reference_in_vp9_dx_iface},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9D_GET_DISPLAY_SIZE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_get_render_size},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9D_GET_BIT_DEPTH), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_get_bit_depth},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9D_GET_FRAME_SIZE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_get_frame_size},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = -1, fn = null}
        ];
    CODEC_VP9_DX_ALGO =
        Codec_Iface_T.{
            name = c_string("WebM Project VP9 Decoder v1.17.0"),
            abi_version = 5,
            caps =
                cast,no_check(Codec_Caps_T) ((0x1 | (ifx ((cast(s32) 0) != 0) then cast(s32) 0x40000 else 0)) | 0x400000),
            init = decoder_init,
            destroy = cast,no_check(#type (_: *Codec_Alg_Priv_T) -> Codec_Err_T) decoder_destroy,
            ctrl_maps = DECODER_CTRL_MAPS.data,
            dec =
                Codec_Dec_Iface.{peek_si = decoder_peek_si, get_si = cast,no_check(#type (
                    _: *Codec_Alg_Priv_T,
                    _: *Codec_Stream_Info_T
                ) -> Codec_Err_T) decoder_get_si, decode = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *u8, _: u32, _: *void) -> Codec_Err_T) decoder_decode, get_frame = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Codec_Iter_T) -> *Image_T) decoder_get_frame, set_fb_fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: Get_Frame_Buffer_Cb_Fn_T, _: Release_Frame_Buffer_Cb_Fn_T, _: *void) -> Codec_Err_T) decoder_set_fb_fn},
            enc =
                Codec_Enc_Iface.{cfg_map_count = 0, cfg_maps = null, encode = null, get_cx_data = null, cfg_set = null, get_glob_hdrs = null, get_preview = null, mr_get_mem_loc = null, mr_free_mem_loc = null}
        };
    atomic_store(*globals_initialization_state_for_vp9_dx_iface, 2);
}

Codec_Alg_Priv_T_in_vpx_codec_internal_4 :: Codec_Alg_Priv_in_vp9_dx_iface;

VP9_Decoder :: struct {
    mb: MACROBLOCKD #align 16;
    layout_padding_0: [8] u8 #align 1;
    common: VP9_COMMON #align 1;
    ready_for_new_data: s32 #align 1;
    refresh_frame_flags: s32 #align 1;
    cur_buf: *Ref_Cnt_Buffer #align 1;
    lf_worker: Worker #align 1;
    tile_workers: *Worker #align 1;
    tile_worker_data: *Tile_Worker_Data #align 1;
    tile_buffers: [64] Tile_Buffer #align 1;
    num_tile_workers: s32 #align 1;
    total_tiles: s32 #align 1;
    lf_row_sync: VP9_Lf_Sync #align 1;
    decrypt_cb: Decrypt_Cb #align 1;
    decrypt_state: *void #align 1;
    max_threads: s32 #align 1;
    inv_tile_order: s32 #align 1;
    need_resync: s32 #align 1;
    hold_ref_buf: s32 #align 1;
    row_mt: s32 #align 1;
    lpf_mt_opt: s32 #align 1;
    row_mt_worker_data: *Row_MT_Worker_Data #align 1;
    layout_padding_1: [8] u8 #align 1;
} #no_padding;

Vp9_Stream_Info_T :: Codec_Stream_Info_T;

Codec_Alg_Priv_in_vp9_dx_iface :: struct {
    base: Codec_Priv_T #align 8;
    cfg: Codec_Dec_Cfg_T #align 1;
    si: Vp9_Stream_Info_T #align 1;
    layout_padding_0: [4] u8 #align 1;
    pbi: *VP9_Decoder #align 1;
    user_priv: *void #align 1;
    postproc_cfg_set: s32 #align 1;
    postproc_cfg: Vp8_Postproc_Cfg_T #align 1;
    decrypt_cb: Decrypt_Cb #align 1;
    decrypt_state: *void #align 1;
    img: Image_T #align 1;
    img_avail: s32 #align 1;
    flushed: s32 #align 1;
    invert_tile_order: s32 #align 1;
    last_show_frame: s32 #align 1;
    byte_alignment: s32 #align 1;
    skip_loop_filter: s32 #align 1;
    need_resync: s32 #align 1;
    layout_padding_1: [4] u8 #align 1;
    buffer_pool: *Buffer_Pool #align 1;
    ext_priv: *void #align 1;
    get_ext_fb_cb: Get_Frame_Buffer_Cb_Fn_T #align 1;
    release_ext_fb_cb: Release_Frame_Buffer_Cb_Fn_T #align 1;
    svc_decoding: s32 #align 1;
    svc_spatial_layer: s32 #align 1;
    row_mt: s32 #align 1;
    lpf_opt: s32 #align 1;
} #no_padding;

Tile_Worker_Data :: struct {
    data_end: *u8 #align 32;
    buf_start: s32 #align 1;
    buf_end: s32 #align 1;
    bit_reader: Reader #align 1;
    counts: FRAME_COUNTS #align 1;
    lf_data: *LF_Worker_Data #align 1;
    lf_sync: *VP9_Lf_Sync #align 1;
    layout_padding_0: [8] u8 #align 1;
    xd: MACROBLOCKD #align 1;
    layout_padding_1: [8] u8 #align 1;
    dqcoeff: [1024] Tran_Low_T #align 1;
    extend_and_predict_buf: [25600] u16 #align 1;
    error_info: Internal_Error_Info #align 1;
    layout_padding_2: [24] u8 #align 1;
} #no_padding;

Tile_Buffer :: struct {
    data: *u8;
    size: u64;
    col: s32;
}

Row_MT_Worker_Data :: struct {
    num_sbs: s32 #align 8;
    layout_padding_0: [4] u8 #align 1;
    eob: [3] *s32 #align 1;
    partition: *PARTITION_TYPE #align 1;
    dqcoeff: [3] *Tran_Low_T #align 1;
    recon_map: *s8 #align 1;
    data_end: *u8 #align 1;
    jobq_buf: *u8 #align 1;
    jobq: Job_Queue_Row_Mt #align 1;
    jobq_size: u64 #align 1;
    num_tiles_done: s32 #align 1;
    num_jobs: s32 #align 1;
    recon_done_mutex: Pthread_Mutex_T #align 1;
    recon_sync_mutex: *Pthread_Mutex_T #align 1;
    recon_sync_cond: *Pthread_Cond_T #align 1;
    thread_data: *Thread_Data_in_vp9_decoder #align 1;
} #no_padding;

Job_Queue_Row_Mt :: struct {
    buf_base: *u8 #align 8;
    buf_wr: *u8 #align 1;
    buf_rd: *u8 #align 1;
    buf_end: *u8 #align 1;
    terminate: s32 #align 1;
    layout_padding_0: [4] u8 #align 1;
    mutex: Pthread_Mutex_T #align 1;
    cond: Pthread_Cond_T #align 1;
} #no_padding;

Thread_Data_in_vp9_decoder :: struct {
    pbi: *VP9_Decoder;
    lf_data: *LF_Worker_Data;
    lf_sync: *VP9_Lf_Sync;
}

