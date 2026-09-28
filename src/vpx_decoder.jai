#load "cpp_transpiler_runtime.jai";

codec_dec_init_ver :: (
    ctx: *Codec_Ctx_T,
    iface: *Codec_Iface_T,
    cfg: *Codec_Dec_Cfg_T,
    flags: Codec_Flags_T,
    ver: s32
) -> Codec_Err_T {
    res: Codec_Err_T = ---;

    if ver != 3 + cast,no_check(s32) ((4 + 5)) {
        res = cast,no_check(Codec_Err_T) CODEC_ABI_MISMATCH;
    } else if ctx == null || iface == null {
        res = cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    } else if iface.abi_version != 5 {
        res = cast,no_check(Codec_Err_T) CODEC_ABI_MISMATCH;
    } else if flags & 0x10000 != 0 && iface.caps & 0x40000 == 0 {
        res = cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
    } else if flags & 0x20000 != 0 && iface.caps & 0x80000 == 0 {
        res = cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
    } else if flags & 0x40000 != 0 && iface.caps & 0x100000 == 0 {
        res = cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
    } else if iface.caps & 0x1 == 0 {
        res = cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
    } else {
        fill_memory(ctx, 0, size_of(Codec_Ctx_T));
        ctx.iface = iface;
        ctx.name = iface.name;
        ctx.priv = null;
        ctx.init_flags = flags;
        ctx.config.dec = cfg;

        res = ctx.iface.init(ctx, null);
        if res != 0 {
            ctx.err_detail = ifx ctx.priv != null then ctx.priv.err_detail else null;
            (cast,no_check(#type (_: *Codec_Ctx_T) -> Codec_Err_T) (cast(*void) codec_destroy))(ctx);
        }
    }

    return ifx ctx != null then (ifx true { assignment_0: Codec_Err_T = cast,no_check(Codec_Err_T) (res); (ctx.err) = assignment_0; assignment_0; }) else res;
}

codec_peek_stream_info :: (iface: *Codec_Iface_T, data: *u8, data_sz: u32, si: *Codec_Stream_Info_T) -> Codec_Err_T {
    res: Codec_Err_T = ---;

    if iface == null || data == null || data_sz == 0 || si == null || cast,no_check(u64) si.sz < size_of(Codec_Stream_Info_T) {
        res = cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    } else {
        si.w = 0;
        si.h = 0;

        res = iface.dec.peek_si(data, data_sz, si);
    }

    return res;
}

codec_get_stream_info :: (ctx: *Codec_Ctx_T, si: *Codec_Stream_Info_T) -> Codec_Err_T {
    res: Codec_Err_T = ---;

    if ctx == null || si == null || cast,no_check(u64) si.sz < size_of(Codec_Stream_Info_T) {
        res = cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    } else if ctx.iface == null || ctx.priv == null {
        res = cast,no_check(Codec_Err_T) CODEC_ERROR;
    } else {
        si.w = 0;
        si.h = 0;

        res = ctx.iface.dec.get_si(get_alg_priv(ctx), si);
    }

    return ifx ctx != null then (ifx true { assignment_1: Codec_Err_T = cast,no_check(Codec_Err_T) (res); (ctx.err) = assignment_1; assignment_1; }) else res;
}

get_alg_priv :: (ctx: *Codec_Ctx_T) -> *Codec_Alg_Priv_T {
    return cast(*Codec_Alg_Priv_T) ctx.priv;
}

codec_decode :: (ctx: *Codec_Ctx_T, data: *u8, data_sz: u32, user_priv: *void, deadline: s64) -> Codec_Err_T {
    res: Codec_Err_T = ifx ctx == null || data == null && data_sz != 0 || data != null && data_sz == 0
        then cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM
        else ifx ctx.iface == null || ctx.priv == null
            then cast,no_check(Codec_Err_T) CODEC_ERROR
            else ctx.iface.dec.decode(get_alg_priv(ctx), data, data_sz, user_priv);

    return ifx ctx != null then (ifx true { assignment_2: Codec_Err_T = cast,no_check(Codec_Err_T) (res); (ctx.err) = assignment_2; assignment_2; }) else res;
}

codec_get_frame :: (ctx: *Codec_Ctx_T, iter: *Codec_Iter_T) -> *Image_T {
    img: *Image_T = ifx ctx == null || iter == null || ctx.iface == null || ctx.priv == null
        then cast(*Image_T) null
        else ctx.iface.dec.get_frame(get_alg_priv(ctx), iter);

    return img;
}

codec_register_put_frame_cb :: (ctx: *Codec_Ctx_T, cb: Codec_Put_Frame_Cb_Fn_T, user_priv: *void) -> Codec_Err_T {
    res: Codec_Err_T = ---;

    if ctx == null || cb == null {
        res = cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    } else if ctx.iface == null || ctx.priv == null {
        res = cast,no_check(Codec_Err_T) CODEC_ERROR;
    } else if ctx.iface.caps & 0x20000 == 0 {
        res = cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
    } else {
        ctx.priv.dec.put_frame_cb.u.put_frame = cb;
        ctx.priv.dec.put_frame_cb.user_priv = user_priv;
        res = cast,no_check(Codec_Err_T) CODEC_OK;
    }

    return ifx ctx != null then (ifx true { assignment_3: Codec_Err_T = cast,no_check(Codec_Err_T) (res); (ctx.err) = assignment_3; assignment_3; }) else res;
}

codec_register_put_slice_cb :: (ctx: *Codec_Ctx_T, cb: Codec_Put_Slice_Cb_Fn_T, user_priv: *void) -> Codec_Err_T {
    res: Codec_Err_T = ---;

    if ctx == null || cb == null {
        res = cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    } else if ctx.iface == null || ctx.priv == null {
        res = cast,no_check(Codec_Err_T) CODEC_ERROR;
    } else if ctx.iface.caps & 0x10000 == 0 {
        res = cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
    } else {
        ctx.priv.dec.put_slice_cb.u.put_slice = cb;
        ctx.priv.dec.put_slice_cb.user_priv = user_priv;
        res = cast,no_check(Codec_Err_T) CODEC_OK;
    }

    return ifx ctx != null then (ifx true { assignment_4: Codec_Err_T = cast,no_check(Codec_Err_T) (res); (ctx.err) = assignment_4; assignment_4; }) else res;
}

codec_set_frame_buffer_functions :: (
    ctx: *Codec_Ctx_T,
    cb_get: Get_Frame_Buffer_Cb_Fn_T,
    cb_release: Release_Frame_Buffer_Cb_Fn_T,
    cb_priv: *void
) -> Codec_Err_T {
    res: Codec_Err_T = ifx ctx == null || cb_get == null || cb_release == null
        then cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM
        else ifx ctx.iface == null || ctx.priv == null
            then cast,no_check(Codec_Err_T) CODEC_ERROR
            else ifx ctx.iface.caps & 0x400000 == 0
                then cast,no_check(Codec_Err_T) CODEC_INCAPABLE
                else ctx.iface.dec.set_fb_fn(
                    get_alg_priv(ctx),
                    cast,no_check(Get_Frame_Buffer_Cb_Fn_T) (cb_get),
                    cast,no_check(Release_Frame_Buffer_Cb_Fn_T) (cb_release),
                    cb_priv
                );

    return ifx ctx != null then (ifx true { assignment_5: Codec_Err_T = cast,no_check(Codec_Err_T) (res); (ctx.err) = assignment_5; assignment_5; }) else res;
}

Codec_Ctx_T :: Codec_Ctx;

Codec_Iface_T :: Codec_Iface;

Codec_Dec_Cfg_T :: Codec_Dec_Cfg;

Codec_Flags_T :: s64;

Codec_Err_T :: u32;
CODEC_OK : s32 : 0;
CODEC_ERROR : s32 : 1;
CODEC_MEM_ERROR : s32 : 2;
CODEC_ABI_MISMATCH : s32 : 3;
CODEC_INCAPABLE : s32 : 4;
CODEC_UNSUP_BITSTREAM : s32 : 5;
CODEC_UNSUP_FEATURE : s32 : 6;
CODEC_CORRUPT_FRAME : s32 : 7;
CODEC_INVALID_PARAM : s32 : 8;
CODEC_LIST_END : s32 : 9;

Codec_Caps_T :: s64;

Codec_Priv_T :: Codec_Priv;

Codec_Dec_Cfg :: struct {
    threads: u32;
    w: u32;
    h: u32;
}

Codec_Init_Fn_T :: #type (_: *Codec_Ctx_T, _: *Codec_Priv_Enc_Mr_Cfg_T) -> Codec_Err_T;

Codec_Priv_Enc_Mr_Cfg_T :: Codec_Priv_Enc_Mr_Cfg;

Codec_Stream_Info_T :: Codec_Stream_Info;

Codec_Peek_Si_Fn_T :: #type (_: *u8, _: u32, _: *Codec_Stream_Info_T) -> Codec_Err_T;

Codec_Get_Si_Fn_T :: #type (_: *Codec_Alg_Priv_T, _: *Codec_Stream_Info_T) -> Codec_Err_T;

Codec_Alg_Priv_T :: Codec_Alg_Priv;

Codec_Decode_Fn_T :: #type (_: *Codec_Alg_Priv_T, _: *u8, _: u32, _: *void) -> Codec_Err_T;

Codec_Iter_T :: *void;

Image_T :: Image;

Codec_Get_Frame_Fn_T :: #type (_: *Codec_Alg_Priv_T, _: *Codec_Iter_T) -> *Image_T;

Codec_Put_Frame_Cb_Fn_T :: #type (_: *void, _: *Image_T);

Codec_Put_Slice_Cb_Fn_T :: #type (_: *void, _: *Image_T, _: *Image_Rect_T, _: *Image_Rect_T);

Get_Frame_Buffer_Cb_Fn_T :: #type (_: *void, _: u64, _: *Codec_Frame_Buffer_T) -> s32;

Release_Frame_Buffer_Cb_Fn_T :: #type (_: *void, _: *Codec_Frame_Buffer_T) -> s32;

Codec_Set_Fb_Fn_T :: #type (
    _: *Codec_Alg_Priv_T,
    _: Get_Frame_Buffer_Cb_Fn_T,
    _: Release_Frame_Buffer_Cb_Fn_T,
    _: *void
) -> Codec_Err_T;

Codec_Ctx :: struct {
    name: *s8 #align 8;
    iface: *Codec_Iface_T #align 1;
    err: Codec_Err_T #align 1;
    layout_padding_0: [4] u8 #align 1;
    err_detail: *s8 #align 1;
    init_flags: Codec_Flags_T #align 1;
    config: Codec_Ctx_Config #align 1;
    priv: *Codec_Priv_T #align 1;
} #no_padding;

Codec_Iface :: struct {
    name: *s8;
    abi_version: s32;
    caps: Codec_Caps_T;
    init: Codec_Init_Fn_T;
    destroy: Codec_Destroy_Fn_T;
    ctrl_maps: *Codec_Ctrl_Fn_Map_T;
    dec: Codec_Dec_Iface;
    enc: Codec_Enc_Iface;
}

Codec_Priv :: struct {
    err_detail: *s8 #align 8;
    init_flags: Codec_Flags_T #align 1;
    dec: Codec_Priv_Dec #align 1;
    enc: Codec_Priv_Enc #align 1;
} #no_padding;

Codec_Priv_Enc_Mr_Cfg :: struct {
    mr_total_resolutions: u32;
    mr_encoder_id: u32;
    mr_down_sampling_factor: Rational;
    mr_low_res_mode_info: *void;
}

Codec_Stream_Info :: struct {
    sz: u32;
    w: u32;
    h: u32;
    is_kf: u32;
}

Image :: struct {
    fmt: Img_Fmt_T;
    cs: Color_Space_T;
    range: Color_Range_T;
    w: u32;
    h: u32;
    bit_depth: u32;
    d_w: u32;
    d_h: u32;
    r_w: u32;
    r_h: u32;
    x_chroma_shift: u32;
    y_chroma_shift: u32;
    planes: [4] *u8;
    stride: [4] s32;
    bps: s32;
    user_priv: *void;
    img_data: *u8;
    img_data_owner: s32;
    self_allocd: s32;
    fb_priv: *void;
}

Image_Rect_T :: Image_Rect;

Codec_Frame_Buffer_T :: Codec_Frame_Buffer;

Codec_Ctx_Config :: union {
    dec: *Codec_Dec_Cfg;
    enc: *Codec_Enc_Cfg;
    raw: *void;
}

Codec_Destroy_Fn_T :: #type (_: *Codec_Alg_Priv_T) -> Codec_Err_T;

Codec_Ctrl_Fn_Map_T :: Codec_Ctrl_Fn_Map;

Codec_Dec_Iface :: struct {
    peek_si: Codec_Peek_Si_Fn_T;
    get_si: Codec_Get_Si_Fn_T;
    decode: Codec_Decode_Fn_T;
    get_frame: Codec_Get_Frame_Fn_T;
    set_fb_fn: Codec_Set_Fb_Fn_T;
}

Codec_Enc_Iface :: struct {
    cfg_map_count: s32;
    cfg_maps: *Codec_Enc_Cfg_Map_T;
    encode: Codec_Encode_Fn_T;
    get_cx_data: Codec_Get_Cx_Data_Fn_T;
    cfg_set: Codec_Enc_Config_Set_Fn_T;
    get_glob_hdrs: Codec_Get_Global_Headers_Fn_T;
    get_preview: Codec_Get_Preview_Frame_Fn_T;
    mr_get_mem_loc: Codec_Enc_Mr_Get_Mem_Loc_Fn_T;
    mr_free_mem_loc: Codec_Enc_Mr_Free_Mem_Loc_Fn_T;
}

Codec_Priv_Dec :: struct {
    put_frame_cb: Codec_Priv_Cb_Pair_T #align 8;
    put_slice_cb: Codec_Priv_Cb_Pair_T #align 1;
} #no_padding;

Codec_Priv_Enc :: struct {
    cx_data_dst_buf: Fixed_Buf_T #align 8;
    cx_data_pad_before: u32 #align 1;
    cx_data_pad_after: u32 #align 1;
    cx_data_pkt: Codec_Cx_Pkt_T #align 1;
    total_encoders: u32 #align 1;
    layout_padding_0: [4] u8 #align 1;
} #no_padding;

Rational :: struct {
    num: s32;
    den: s32;
}

Img_Fmt_T :: Img_Fmt;

Color_Space_T :: Color_Space;

Color_Range_T :: Color_Range;

Image_Rect :: struct {
    x: u32;
    y: u32;
    w: u32;
    h: u32;
}

Codec_Frame_Buffer :: struct {
    data: *u8;
    size: u64;
    priv: *void;
}

Codec_Enc_Cfg :: struct {
    g_usage: u32;
    g_threads: u32;
    g_profile: u32;
    g_w: u32;
    g_h: u32;
    g_bit_depth: Bit_Depth_T;
    g_input_bit_depth: u32;
    g_timebase: Rational;
    g_error_resilient: Codec_Er_Flags_T;
    g_pass: Enc_Pass;
    g_lag_in_frames: u32;
    rc_dropframe_thresh: u32;
    rc_resize_allowed: u32;
    rc_scaled_width: u32;
    rc_scaled_height: u32;
    rc_resize_up_thresh: u32;
    rc_resize_down_thresh: u32;
    rc_end_usage: Rc_Mode;
    rc_twopass_stats_in: Fixed_Buf_T;
    rc_firstpass_mb_stats_in: Fixed_Buf_T;
    rc_target_bitrate: u32;
    rc_min_quantizer: u32;
    rc_max_quantizer: u32;
    rc_undershoot_pct: u32;
    rc_overshoot_pct: u32;
    rc_buf_sz: u32;
    rc_buf_initial_sz: u32;
    rc_buf_optimal_sz: u32;
    rc_2pass_vbr_bias_pct: u32;
    rc_2pass_vbr_minsection_pct: u32;
    rc_2pass_vbr_maxsection_pct: u32;
    rc_2pass_vbr_corpus_complexity: u32;
    kf_mode: Kf_Mode;
    kf_min_dist: u32;
    kf_max_dist: u32;
    ss_number_layers: u32;
    ss_enable_auto_alt_ref: [5] s32;
    ss_target_bitrate: [5] u32;
    ts_number_layers: u32;
    ts_target_bitrate: [5] u32;
    ts_rate_decimator: [5] u32;
    ts_periodicity: u32;
    ts_layer_id: [16] u32;
    layer_target_bitrate: [12] u32;
    temporal_layering_mode: s32;
    use_vizier_rc_params: s32;
    active_wq_factor: Rational_T;
    err_per_mb_factor: Rational_T;
    sr_default_decay_limit: Rational_T;
    sr_diff_factor: Rational_T;
    kf_err_per_mb_factor: Rational_T;
    kf_frame_min_boost_factor: Rational_T;
    kf_frame_max_boost_first_factor: Rational_T;
    kf_frame_max_boost_subs_factor: Rational_T;
    kf_max_total_boost_factor: Rational_T;
    gf_max_total_boost_factor: Rational_T;
    gf_frame_max_boost_factor: Rational_T;
    zm_factor: Rational_T;
    rd_mult_inter_qp_fac: Rational_T;
    rd_mult_arf_qp_fac: Rational_T;
    rd_mult_key_qp_fac: Rational_T;
}

Codec_Ctrl_Fn_Map :: struct {
    ctrl_id: s32;
    fn: Codec_Control_Fn_T;
}

Codec_Enc_Cfg_Map_T :: Codec_Enc_Cfg_Map;

Codec_Pts_T :: s64;

Enc_Frame_Flags_T :: s64;

Enc_Deadline_T :: u64;

Codec_Encode_Fn_T :: #type (
    _: *Codec_Alg_Priv_T,
    _: *Image_T,
    _: Codec_Pts_T,
    _: u64,
    _: Enc_Frame_Flags_T,
    _: Enc_Deadline_T
) -> Codec_Err_T;

Codec_Cx_Pkt_T :: Codec_Cx_Pkt;

Codec_Get_Cx_Data_Fn_T :: #type (_: *Codec_Alg_Priv_T, _: *Codec_Iter_T) -> *Codec_Cx_Pkt_T;

Codec_Enc_Cfg_T :: Codec_Enc_Cfg;

Codec_Enc_Config_Set_Fn_T :: #type (_: *Codec_Alg_Priv_T, _: *Codec_Enc_Cfg_T) -> Codec_Err_T;

Fixed_Buf_T :: Fixed_Buf;

Codec_Get_Global_Headers_Fn_T :: #type (_: *Codec_Alg_Priv_T) -> *Fixed_Buf_T;

Codec_Get_Preview_Frame_Fn_T :: #type (_: *Codec_Alg_Priv_T) -> *Image_T;

Codec_Enc_Mr_Get_Mem_Loc_Fn_T :: #type (_: *Codec_Enc_Cfg_T, _: **void) -> Codec_Err_T;

Codec_Enc_Mr_Free_Mem_Loc_Fn_T :: #type (_: *void);

Codec_Priv_Cb_Pair_T :: Codec_Priv_Cb_Pair;

Img_Fmt :: u32;
IMG_FMT_NONE : s32 : 0;
IMG_FMT_YV12 : s32 : 769;
IMG_FMT_I420 : s32 : 258;
IMG_FMT_I422 : s32 : 261;
IMG_FMT_I444 : s32 : 262;
IMG_FMT_I440 : s32 : 263;
IMG_FMT_NV12 : s32 : 265;
IMG_FMT_I42016 : s32 : 2306;
IMG_FMT_I42216 : s32 : 2309;
IMG_FMT_I44416 : s32 : 2310;
IMG_FMT_I44016 : s32 : 2311;

Color_Space :: u32;
CS_UNKNOWN : s32 : 0;
CS_BT_601 : s32 : 1;
CS_BT_709 : s32 : 2;
CS_SMPTE_170 : s32 : 3;
CS_SMPTE_240 : s32 : 4;
CS_BT_2020 : s32 : 5;
CS_RESERVED : s32 : 6;
CS_SRGB : s32 : 7;

Color_Range :: u32;
CR_STUDIO_RANGE : s32 : 0;
CR_FULL_RANGE : s32 : 1;

Bit_Depth_T :: Bit_Depth;

Codec_Er_Flags_T :: u32;

Enc_Pass :: u32;
RC_ONE_PASS : s32 : 0;
RC_FIRST_PASS : s32 : 1;
RC_LAST_PASS : s32 : 2;

Rc_Mode :: u32;
VBR : s32 : 0;
CBR : s32 : 1;
CQ : s32 : 2;
Q : s32 : 3;

Kf_Mode :: u32;
KF_FIXED : s32 : 0;
KF_AUTO : s32 : 1;
KF_DISABLED : s32 : 0;

Rational_T :: Rational;

Va_List_Tag :: struct {
    gp_offset: u32;
    fp_offset: u32;
    overflow_arg_area: *void;
    reg_save_area: *void;
}

Codec_Control_Fn_T :: #type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T;

Codec_Enc_Cfg_Map :: struct {
    usage: s32;
    cfg: Codec_Enc_Cfg_T;
}

Codec_Cx_Pkt :: struct {
    kind: Codec_Cx_Pkt_Kind #align 8;
    layout_padding_0: [4] u8 #align 1;
    data: Codec_Cx_Pkt_Data #align 1;
} #no_padding;

Fixed_Buf :: struct {
    buf: *void;
    sz: u64;
}

Codec_Priv_Cb_Pair :: struct {
    u: Codec_Priv_Cb_Pair_U #align 8;
    user_priv: *void #align 1;
} #no_padding;

Bit_Depth :: u32;
BITS_8 : s32 : 8;
BITS_10 : s32 : 10;
BITS_12 : s32 : 12;

Codec_Cx_Pkt_Kind :: u32;
CODEC_CX_FRAME_PKT : s32 : 0;
CODEC_STATS_PKT : s32 : 1;
CODEC_FPMB_STATS_PKT : s32 : 2;
CODEC_PSNR_PKT : s32 : 3;
CODEC_CUSTOM_PKT : s32 : 256;

Codec_Cx_Pkt_Data :: union {
    frame: Unnamed_858;
    twopass_stats: Fixed_Buf_T;
    firstpass_mb_stats: Fixed_Buf_T;
    psnr: Psnr_Pkt;
    raw: Fixed_Buf_T;
    pad: [124] s8;
}

Codec_Priv_Cb_Pair_U :: union {
    put_frame: Codec_Put_Frame_Cb_Fn_T;
    put_slice: Codec_Put_Slice_Cb_Fn_T;
}

Unnamed_858 :: struct {
    buf: *void;
    sz: u64;
    pts: Codec_Pts_T;
    duration: u64;
    flags: Codec_Frame_Flags_T;
    partition_id: s32;
    width: [5] u32;
    height: [5] u32;
    spatial_layer_encoded: [5] u8;
}

Psnr_Pkt :: struct {
    samples: [4] u32;
    sse: [4] u64;
    psnr: [4] float64;
    spatial_layer_id: s32;
}

Codec_Frame_Flags_T :: u32;

