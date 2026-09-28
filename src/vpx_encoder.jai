codec_enc_init_ver :: (
    ctx: *Codec_Ctx_T,
    iface: *Codec_Iface_T,
    cfg: *Codec_Enc_Cfg_T,
    flags: Codec_Flags_T,
    ver: s32
) -> Codec_Err_T {
    res: Codec_Err_T = ---;

    if ver != (18 + cast,no_check(s32) ((4 + 5))) + cast,no_check(s32) ((7 + 5)) {
        res = cast,no_check(Codec_Err_T) CODEC_ABI_MISMATCH;
    } else if ctx == null || iface == null || cfg == null {
        res = cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    } else if iface.abi_version != 5 {
        res = cast,no_check(Codec_Err_T) CODEC_ABI_MISMATCH;
    } else if iface.caps & 0x2 == 0 {
        res = cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
    } else if flags & 0x10000 != 0 && iface.caps & 0x10000 == 0 {
        res = cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
    } else if flags & 0x20000 != 0 && iface.caps & 0x20000 == 0 {
        res = cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
    } else {
        ctx.iface = iface;
        ctx.name = iface.name;
        ctx.priv = null;
        ctx.init_flags = flags;
        ctx.config.enc = cfg;
        res = ctx.iface.init(ctx, null);

        if res != 0 {
            ctx.err_detail = ifx ctx.priv != null then ctx.priv.err_detail else null;
            (cast,no_check(#type (_: *Codec_Ctx_T) -> Codec_Err_T) (cast(*void) codec_destroy))(ctx);
        }
    }

    return ifx ctx != null then (ifx true { assignment_0: Codec_Err_T = cast,no_check(Codec_Err_T) (res); (ctx.err) = assignment_0; assignment_0; }) else res;
}

codec_enc_init_multi_ver :: (
    ctx: *Codec_Ctx_T,
    iface: *Codec_Iface_T,
    cfg: *Codec_Enc_Cfg_T,
    num_enc: s32,
    flags: Codec_Flags_T,
    dsf: *Rational_T,
    ver: s32
) -> Codec_Err_T {
    res := cast,no_check(Codec_Err_T) CODEC_OK;

    if ver != (18 + cast,no_check(s32) ((4 + 5))) + cast,no_check(s32) ((7 + 5)) {
        res = cast,no_check(Codec_Err_T) CODEC_ABI_MISMATCH;
    } else if ctx == null || iface == null || cfg == null || num_enc > 16 || num_enc < 1 || dsf == null {
        res = cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    } else if iface.abi_version != 5 {
        res = cast,no_check(Codec_Err_T) CODEC_ABI_MISMATCH;
    } else if iface.caps & 0x2 == 0 {
        res = cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
    } else if flags & 0x10000 != 0 && iface.caps & 0x10000 == 0 {
        res = cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
    } else if flags & 0x20000 != 0 && iface.caps & 0x20000 == 0 {
        res = cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
    } else {
        i: s32 = ---;

        mem_loc: *void = ---;

        if iface.enc.mr_get_mem_loc == null {
            return cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
        }

        if !((((ifx true { assignment_1: Codec_Err_T = cast,no_check(Codec_Err_T) (iface.enc.mr_get_mem_loc(cfg, *mem_loc)); (res) = assignment_1; assignment_1; })) != 0)) {
            i = 0;
            while i < num_enc {
                mr_cfg: Codec_Priv_Enc_Mr_Cfg_T = ---;

                if dsf.num < 1 || dsf.num > 4096 || dsf.den < 1 || dsf.den > dsf.num {
                    res = cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
                } else {
                    mr_cfg.mr_low_res_mode_info = mem_loc;
                    mr_cfg.mr_total_resolutions = cast,no_check(u32) num_enc;
                    mr_cfg.mr_encoder_id = cast,no_check(u32) (num_enc - 1 - i);
                    mr_cfg.mr_down_sampling_factor = dsf.*;

                    ctx.iface = iface;
                    ctx.name = iface.name;
                    ctx.priv = null;
                    ctx.init_flags = flags;
                    ctx.config.enc = cfg;

                    res = ctx.iface.init(ctx, *mr_cfg);
                }

                if res != 0 {
                    error_detail: *s8 = (ifx ctx.priv != null then ctx.priv.err_detail else null);

                    ctx.err_detail = error_detail;
                    (cast,no_check(#type (_: *Codec_Ctx_T) -> Codec_Err_T) (cast(*void) codec_destroy))(ctx);

                    while i != 0 {
                        ctx -= 1;
                        ctx.err_detail = error_detail;
                        (cast,no_check(#type (_: *Codec_Ctx_T) -> Codec_Err_T) (cast(*void) codec_destroy))(ctx);
                        i -= 1;
                    }

                    return ifx ctx != null then (ifx true { assignment_2: Codec_Err_T = cast,no_check(Codec_Err_T) (res); (ctx.err) = assignment_2; assignment_2; }) else res;
                }

                ctx += 1;
                cfg += 1;
                dsf += 1;
                i += 1;
            }
            ctx -= 1;
        }
    }

    return ifx ctx != null then (ifx true { assignment_3: Codec_Err_T = cast,no_check(Codec_Err_T) (res); (ctx.err) = assignment_3; assignment_3; }) else res;
}

codec_enc_config_default :: (iface: *Codec_Iface_T, cfg: *Codec_Enc_Cfg_T, usage: u32) -> Codec_Err_T {
    res: Codec_Err_T = ---;

    if iface == null || cfg == null || usage != 0 {
        res = cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    } else if iface.caps & 0x2 == 0 {
        res = cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
    } else {
        cfg.* = iface.enc.cfg_maps.cfg;
        res = cast,no_check(Codec_Err_T) CODEC_OK;
    }

    return res;
}

codec_enc_config_set :: (ctx: *Codec_Ctx_T, cfg: *Codec_Enc_Cfg_T) -> Codec_Err_T {
    res: Codec_Err_T = ifx ctx == null || ctx.iface == null || ctx.priv == null || cfg == null
        then cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM
        else ifx ctx.iface.caps & 0x2 == 0
            then cast,no_check(Codec_Err_T) CODEC_INCAPABLE
            else ctx.iface.enc.cfg_set(get_alg_priv_in_vpx_encoder(ctx), cfg);

    return ifx ctx != null then (ifx true { assignment_4: Codec_Err_T = cast,no_check(Codec_Err_T) (res); (ctx.err) = assignment_4; assignment_4; }) else res;
}

get_alg_priv_in_vpx_encoder :: (ctx: *Codec_Ctx_T) -> *Codec_Alg_Priv_T {
    return cast(*Codec_Alg_Priv_T) ctx.priv;
}

codec_get_global_headers :: (ctx: *Codec_Ctx_T) -> *Fixed_Buf_T {
    buf: *Fixed_Buf_T = null;

    if ctx != null {
        if ctx.iface == null || ctx.priv == null {
            ctx.err = cast,no_check(Codec_Err_T) CODEC_ERROR;
        } else if ctx.iface.caps & 0x2 == 0 {
            ctx.err = cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
        } else if ctx.iface.enc.get_glob_hdrs == null {
            ctx.err = cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
        } else {
            buf = ctx.iface.enc.get_glob_hdrs(get_alg_priv_in_vpx_encoder(ctx));
        }
    }

    return buf;
}

codec_encode :: (
    ctx: *Codec_Ctx_T,
    img: *Image_T,
    pts: Codec_Pts_T,
    duration: u64,
    flags: Enc_Frame_Flags_T,
    deadline: Enc_Deadline_T
) -> Codec_Err_T {
    res := cast,no_check(Codec_Err_T) CODEC_OK;

    if ctx == null || img != null && duration == 0 {
        res = cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    } else if ctx.iface == null || ctx.priv == null {
        res = cast,no_check(Codec_Err_T) CODEC_ERROR;
    } else if ctx.iface.caps & 0x2 == 0 {
        res = cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
    } else if duration > 4294967295 || deadline > 4294967295 {
        res = cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    } else {
        num_enc := ctx.priv.enc.total_encoders;

        floating_point_init();

        if num_enc == 1 {
            res = ctx.iface.enc.encode(get_alg_priv_in_vpx_encoder(ctx), img, pts, duration, flags, deadline);
        } else {
            ctx += num_enc - 1;
            if img != null {
                img += num_enc - 1;
            }

            i := cast,no_check(s32) (num_enc - 1);
            while i >= 0 {
                if (((ifx true { assignment_5: Codec_Err_T = cast,no_check(Codec_Err_T) (ctx.iface.enc.encode(get_alg_priv_in_vpx_encoder(ctx), img, pts, duration, flags, deadline)); (res) = assignment_5; assignment_5; })) != 0) {
                    break;
                }

                ctx -= 1;
                if img != null {
                    img -= 1;
                }
                i -= 1;
            }

            if i < 0 {
                ctx += 1;
            }
        }

        floating_point_restore();
    }

    return ifx ctx != null then (ifx true { assignment_6: Codec_Err_T = cast,no_check(Codec_Err_T) (res); (ctx.err) = assignment_6; assignment_6; }) else res;
}

floating_point_restore :: () {
}

floating_point_init :: () {
}

codec_set_cx_data_buf :: (ctx: *Codec_Ctx_T, buf: *Fixed_Buf_T, pad_before: u32, pad_after: u32) -> Codec_Err_T {
    if ctx == null || ctx.priv == null {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if buf != null {
        ctx.priv.enc.cx_data_dst_buf = buf.*;
        ctx.priv.enc.cx_data_pad_before = pad_before;
        ctx.priv.enc.cx_data_pad_after = pad_after;
    } else {
        ctx.priv.enc.cx_data_dst_buf.buf = null;
        ctx.priv.enc.cx_data_dst_buf.sz = 0;
        ctx.priv.enc.cx_data_pad_before = 0;
        ctx.priv.enc.cx_data_pad_after = 0;
    }

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

codec_get_cx_data :: (ctx: *Codec_Ctx_T, iter: *Codec_Iter_T) -> *Codec_Cx_Pkt_T {
    pkt: *Codec_Cx_Pkt_T = null;

    if ctx != null {
        if iter == null {
            ctx.err = cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        } else if ctx.iface == null || ctx.priv == null {
            ctx.err = cast,no_check(Codec_Err_T) CODEC_ERROR;
        } else if ctx.iface.caps & 0x2 == 0 {
            ctx.err = cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
        } else {
            pkt = ctx.iface.enc.get_cx_data(get_alg_priv_in_vpx_encoder(ctx), iter);
        }
    }

    if pkt != null && pkt.kind == cast,no_check(u32) CODEC_CX_FRAME_PKT {
        PRIV := ctx.priv;
        DST_BUF := cast(*s8) PRIV.enc.cx_data_dst_buf.buf;

        if DST_BUF != null &&
            pkt.data.raw.buf != cast(*void) DST_BUF &&
            ((pkt.data.raw.sz + cast(u64) PRIV.enc.cx_data_pad_before) + cast(u64) PRIV.enc.cx_data_pad_after) <= PRIV.enc.cx_data_dst_buf.sz {
            modified_pkt := *PRIV.enc.cx_data_pkt;

            copy_memory(DST_BUF + PRIV.enc.cx_data_pad_before, pkt.data.raw.buf, pkt.data.raw.sz);
            modified_pkt.* = pkt.*;
            modified_pkt.data.raw.buf = cast(*void) DST_BUF;
            modified_pkt.data.raw.sz += cast,no_check(u64) (PRIV.enc.cx_data_pad_before + PRIV.enc.cx_data_pad_after);
            pkt = modified_pkt;
        }

        if DST_BUF == cast(*s8) pkt.data.raw.buf {
            PRIV.enc.cx_data_dst_buf.buf = cast(*void) (DST_BUF + pkt.data.raw.sz);
            PRIV.enc.cx_data_dst_buf.sz -= pkt.data.raw.sz;
        }
    }

    return pkt;
}

codec_get_preview_frame :: (ctx: *Codec_Ctx_T) -> *Image_T {
    img: *Image_T = null;

    if ctx != null {
        if ctx.iface == null || ctx.priv == null {
            ctx.err = cast,no_check(Codec_Err_T) CODEC_ERROR;
        } else if ctx.iface.caps & 0x2 == 0 {
            ctx.err = cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
        } else if ctx.iface.enc.get_preview == null {
            ctx.err = cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
        } else {
            img = ctx.iface.enc.get_preview(get_alg_priv_in_vpx_encoder(ctx));
        }
    }

    return img;
}

codec_pkt_list_add :: (list: *Codec_Pkt_List, pkt: *Codec_Cx_Pkt) -> s32 {
    if list.cnt < list.max {
        assignment_7: Codec_Cx_Pkt = pkt.*;
        ((list.pkts.data)[c_transpiler_post_increment(*(list.cnt))]) = assignment_7;
        return 0;
    }

    return 1;
}

codec_pkt_list_get :: (list: *Codec_Pkt_List, iter: *Codec_Iter_T) -> *Codec_Cx_Pkt_T {
    if iter.* == null {
        iter.* = cast(Codec_Iter_T) list.pkts.data;
    }

    pkt := cast(*Codec_Cx_Pkt_T) iter.*;

    if cast,no_check(u64) (pkt - list.pkts.data) < cast,no_check(u64) list.cnt {
        iter.* = cast(Codec_Iter_T) (pkt + 1);
    } else {
        pkt = null;
    }

    return pkt;
}

Codec_Pkt_List :: struct {
    cnt: u32 #align 8;
    max: u32 #align 1;
    pkts: [1] Codec_Cx_Pkt #align 1;
} #no_padding;

