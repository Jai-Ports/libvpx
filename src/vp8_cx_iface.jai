// Generated directly from C by cpp_transpiler.
Codec_Alg_Priv_in_vp8_cx_iface :: struct {
    base: Codec_Priv_T #align 8;
    cfg: Codec_Enc_Cfg_T #align 1;
    vp8_cfg: Vp8_Extracfg #align 1;
    timestamp_ratio: Rational64_T #align 1;
    pts_offset: Codec_Pts_T #align 1;
    pts_offset_initialized: u8 #align 1;
    layout_padding_0: [7] u8 #align 1;
    oxcf: VP8_CONFIG #align 1;
    cpi: *VP8_COMP #align 1;
    cx_data: *u8 #align 1;
    cx_data_sz: u32 #align 1;
    layout_padding_1: [4] u8 #align 1;
    preview_img: Image_T #align 1;
    next_frame_flag: u32 #align 1;
    preview_ppcfg: Vp8_Postproc_Cfg_T #align 1;
    pkt_list: Codec_Alg_Priv_Pkt_List #align 1;
    fixed_kf_cntr: u32 #align 1;
    layout_padding_2: [4] u8 #align 1;
    control_frame_flags: Enc_Frame_Flags_T #align 1;
} #no_padding;

Codec_Alg_Priv_Pkt_List :: union {
    head: Codec_Pkt_List;
    alloc_: Unnamed_4457;
}

Unnamed_4457 :: struct {
    head: Codec_Pkt_List #align 8;
    pkts: [64] Codec_Cx_Pkt #align 1;
} #no_padding;

Vp8_Extracfg :: struct {
    pkt_list: *Codec_Pkt_List;
    cpu_used: s32;
    enable_auto_alt_ref: u32;
    noise_sensitivity: u32;
    sharpness: u32;
    static_thresh: u32;
    token_partitions: u32;
    arnr_max_frames: u32;
    arnr_strength: u32;
    arnr_type: u32;
    tuning: Vp8e_Tuning;
    cq_level: u32;
    rc_max_intra_bitrate_pct: u32;
    gf_cbr_boost_pct: u32;
    screen_content_mode: u32;
}

Pick_Quickcompress_Mode_Static_Assert_Entry :: struct {
    bitfield_storage_0: [1] u8 #align 1;
    layout_padding_1: [3] u8 #align 1;
    alignment_marker_2: [0] u8 #align 4;
} #no_padding;

CODEC_VP8_CX_ALGO: Codec_Iface_T;

VP8E_USAGE_CFG_MAP: [1] Codec_Enc_Cfg_Map_T;

VP8E_CTF_MAPS: [26] Codec_Ctrl_Fn_Map_T;

default_extracfg: Vp8_Extracfg;

clip_pixel_in_vp8_cx_iface :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp8_cx_iface :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp8_cx_iface :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp8_cx_iface :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp8_cx_iface :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp8_cx_iface(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp8_cx_iface(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp8_cx_iface(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp8_cx_iface :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_vp8_cx_iface :: (FILTER: *s16) -> s32 {
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

gcd :: (a: s64, b: s32) -> s32 {
    while b != 0 {
        r := cast,no_check(s32) (a % cast(s64) b);
        a = cast,no_check(s64) b;
        b = r;
    }

    return cast,no_check(s32) a;
}

reduce_ratio :: (ratio: *Rational64_T) {
    DENOM := gcd(ratio.num, ratio.den);
    ratio.num /= cast,no_check(s64) DENOM;
    ratio.den /= DENOM;
}

vp8_set_reference_value :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8e_mr_free_mem :: (mem_loc: *void) {
}

vp8e_mr_alloc_mem :: (cfg: *Codec_Enc_Cfg_T, mem_loc: **void) -> Codec_Err_T {
    res := cast,no_check(Codec_Err_T) CODEC_OK;

    mem_loc.* = null;

    return res;
}

vp8e_get_preview :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface) -> *Image_T {
    sd: YV12_BUFFER_CONFIG = ---;
    flags: Vp8_Ppflags_T = ---;
    fill_memory(*flags, 0, size_of(Vp8_Ppflags_T));

    if ctx.preview_ppcfg.post_proc_flag != 0 {
        flags.post_proc_flag = ctx.preview_ppcfg.post_proc_flag;
        flags.deblocking_level = ctx.preview_ppcfg.deblocking_level;
        flags.noise_level = ctx.preview_ppcfg.noise_level;
    }

    if 0 == (cast,no_check(#type (_: *VP8_COMP, _: *YV12_BUFFER_CONFIG, _: *Vp8_Ppflags_T) -> s32) (cast(*void) vp8_get_preview_raw_frame))(
        ctx.cpi,
        *sd,
        *flags
    ) {
        ctx.preview_img.bps = 12;
        ctx.preview_img.planes[0] = sd.y_buffer;
        ctx.preview_img.planes[1] = sd.u_buffer;
        ctx.preview_img.planes[2] = sd.v_buffer;

        ctx.preview_img.fmt = cast,no_check(Img_Fmt_T) IMG_FMT_I420;
        ctx.preview_img.x_chroma_shift = 1;
        ctx.preview_img.y_chroma_shift = 1;

        ctx.preview_img.d_w = cast,no_check(u32) sd.y_width;
        ctx.preview_img.d_h = cast,no_check(u32) sd.y_height;
        ctx.preview_img.stride[0] = sd.y_stride;
        ctx.preview_img.stride[1] = sd.uv_stride;
        ctx.preview_img.stride[2] = sd.uv_stride;
        ctx.preview_img.w = cast,no_check(u32) sd.y_width;
        ctx.preview_img.h = cast,no_check(u32) sd.y_height;

        return *ctx.preview_img;
    } else {
        return null;
    }
}

vp8e_set_config :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, cfg: *Codec_Enc_Cfg_T) -> Codec_Err_T {
    if cfg.g_w != ctx.cfg.g_w || cfg.g_h != ctx.cfg.g_h {
        if cfg.g_lag_in_frames > 1 || cfg.g_pass != cast,no_check(u32) RC_ONE_PASS {
            ctx.base.err_detail = c_string("Cannot change width or height after initialization");

            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }
        if ctx.cpi.initial_width != 0 && cast,no_check(s32) cfg.g_w > ctx.cpi.initial_width ||
            ctx.cpi.initial_height != 0 && cast,no_check(s32) cfg.g_h > ctx.cpi.initial_height {
            ctx.base.err_detail = c_string("Cannot increase width or height larger than their initial values");

            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }
    }

    if cfg.g_lag_in_frames > ctx.cfg.g_lag_in_frames {
        ctx.base.err_detail = c_string("Cannot increase lag_in_frames");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    res := validate_config(ctx, cfg, *ctx.vp8_cfg, 0);
    if res != cast,no_check(u32) CODEC_OK {
        return res;
    }

    if setjmp_2(ctx.cpi.common.error.jmp.data) != 0 {
        CODEC_ERR := update_error_state(ctx, *ctx.cpi.common.error);
        ctx.cpi.common.error.setjmp = 0;

        return CODEC_ERR;
    }

    ctx.cpi.common.error.setjmp = 1;
    ctx.cfg = cfg.*;
    set_vp8e_config(*ctx.oxcf, ctx.cfg, ctx.vp8_cfg, null);
    (cast,no_check(#type (_: *VP8_COMP, _: *VP8_CONFIG)) (cast(*void) vp8_change_config))(ctx.cpi, *ctx.oxcf);

    if vp8cx_create_encoder_threads(ctx.cpi) != 0 {
        ctx.cpi.common.error.setjmp = 0;
        return cast,no_check(Codec_Err_T) CODEC_ERROR;
    }

    ctx.cpi.common.error.setjmp = 0;
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

set_vp8e_config :: (
    oxcf: *VP8_CONFIG,
    cfg: Codec_Enc_Cfg_T,
    vp8_cfg: Vp8_Extracfg,
    mr_cfg: *Codec_Priv_Enc_Mr_Cfg_T
) -> Codec_Err_T {
    oxcf.multi_threaded = cast,no_check(s32) cfg.g_threads;
    oxcf.version = cast,no_check(s32) cfg.g_profile;

    oxcf.width = cast,no_check(s32) cfg.g_w;
    oxcf.height = cast,no_check(s32) cfg.g_h;
    oxcf.timebase = cfg.g_timebase;

    oxcf.error_resilient_mode =
        cfg.g_error_resilient & cast,no_check(Codec_Er_Flags_T) (((cast,no_check(u32) (0x1)) | 0x2));

    if cfg.g_pass == {
        case cast,no_check(u32) RC_ONE_PASS;
            oxcf.mode = cast,no_check(s32) (MODE_BESTQUALITY);
        case cast,no_check(u32) RC_FIRST_PASS;
            oxcf.mode = cast,no_check(s32) (MODE_FIRSTPASS);
        case cast,no_check(u32) RC_LAST_PASS;
            oxcf.mode = cast,no_check(s32) (MODE_SECONDPASS_BEST);
    }

    if cfg.g_pass == cast,no_check(u32) RC_FIRST_PASS || cfg.g_pass == cast,no_check(u32) RC_ONE_PASS {
        oxcf.allow_lag = 0;
        oxcf.lag_in_frames = 0;
    } else {
        oxcf.allow_lag = cast(s32) (cfg.g_lag_in_frames > 0);
        oxcf.lag_in_frames = cast,no_check(s32) cfg.g_lag_in_frames;
    }

    oxcf.allow_df = cast(s32) (cfg.rc_dropframe_thresh > 0);
    oxcf.drop_frames_water_mark = cast,no_check(s32) cfg.rc_dropframe_thresh;

    oxcf.allow_spatial_resampling = cast,no_check(s32) cfg.rc_resize_allowed;
    oxcf.resample_up_water_mark = cast,no_check(s32) cfg.rc_resize_up_thresh;
    oxcf.resample_down_water_mark = cast,no_check(s32) cfg.rc_resize_down_thresh;

    if cfg.rc_end_usage == cast,no_check(u32) VBR {
        oxcf.end_usage = cast,no_check(s32) (USAGE_LOCAL_FILE_PLAYBACK);
    } else if cfg.rc_end_usage == cast,no_check(u32) CBR {
        oxcf.end_usage = cast,no_check(s32) (USAGE_STREAM_FROM_SERVER);
    } else if cfg.rc_end_usage == cast,no_check(u32) CQ {
        oxcf.end_usage = cast,no_check(s32) (USAGE_CONSTRAINED_QUALITY);
    } else if cfg.rc_end_usage == cast,no_check(u32) Q {
        oxcf.end_usage = cast,no_check(s32) (USAGE_CONSTANT_QUALITY);
    }

    oxcf.target_bandwidth = ifx cfg.rc_target_bitrate < 1000000 then cfg.rc_target_bitrate else 1000000;
    oxcf.rc_max_intra_bitrate_pct = vp8_cfg.rc_max_intra_bitrate_pct;
    oxcf.gf_cbr_boost_pct = vp8_cfg.gf_cbr_boost_pct;

    oxcf.best_allowed_q = cast,no_check(s32) cfg.rc_min_quantizer;
    oxcf.worst_allowed_q = cast,no_check(s32) cfg.rc_max_quantizer;
    oxcf.cq_level = cast,no_check(s32) vp8_cfg.cq_level;
    oxcf.fixed_q = -1;

    oxcf.under_shoot_pct = cast,no_check(s32) cfg.rc_undershoot_pct;
    oxcf.over_shoot_pct = cast,no_check(s32) cfg.rc_overshoot_pct;

    oxcf.maximum_buffer_size_in_ms = cast,no_check(s64) cfg.rc_buf_sz;
    oxcf.starting_buffer_level_in_ms = cast,no_check(s64) cfg.rc_buf_initial_sz;
    oxcf.optimal_buffer_level_in_ms = cast,no_check(s64) cfg.rc_buf_optimal_sz;

    oxcf.maximum_buffer_size = cast,no_check(s64) cfg.rc_buf_sz;
    oxcf.starting_buffer_level = cast,no_check(s64) cfg.rc_buf_initial_sz;
    oxcf.optimal_buffer_level = cast,no_check(s64) cfg.rc_buf_optimal_sz;

    oxcf.two_pass_vbrbias = cast,no_check(s32) cfg.rc_2pass_vbr_bias_pct;
    oxcf.two_pass_vbrmin_section = cast,no_check(s32) cfg.rc_2pass_vbr_minsection_pct;
    oxcf.two_pass_vbrmax_section = cast,no_check(s32) cfg.rc_2pass_vbr_maxsection_pct;

    oxcf.auto_key = cast(s32) (cfg.kf_mode == cast,no_check(u32) KF_AUTO && cfg.kf_min_dist != cfg.kf_max_dist);
    oxcf.key_freq = cast,no_check(s32) cfg.kf_max_dist;

    oxcf.number_of_layers = cfg.ts_number_layers;
    oxcf.periodicity = cfg.ts_periodicity;

    if oxcf.number_of_layers > 1 {
        copy_memory(oxcf.target_bitrate.data, cfg.ts_target_bitrate.data, cfg.ts_target_bitrate.count * size_of(u32));
        copy_memory(oxcf.rate_decimator.data, cfg.ts_rate_decimator.data, cfg.ts_rate_decimator.count * size_of(u32));
        copy_memory(oxcf.layer_id.data, cfg.ts_layer_id.data, cfg.ts_layer_id.count * size_of(u32));
    }

    oxcf.cpu_used = vp8_cfg.cpu_used;
    if cfg.g_pass == cast,no_check(u32) RC_FIRST_PASS {
        oxcf.cpu_used = ifx 4 > oxcf.cpu_used then 4 else oxcf.cpu_used;
    }
    oxcf.encode_breakout = cast,no_check(s32) vp8_cfg.static_thresh;
    oxcf.play_alternate = cast,no_check(s32) vp8_cfg.enable_auto_alt_ref;
    oxcf.noise_sensitivity = cast,no_check(s32) vp8_cfg.noise_sensitivity;
    oxcf.sharpness = cast,no_check(s32) vp8_cfg.sharpness;
    oxcf.token_partitions = cast,no_check(s32) vp8_cfg.token_partitions;

    oxcf.two_pass_stats_in = cfg.rc_twopass_stats_in;
    oxcf.output_pkt_list = vp8_cfg.pkt_list;

    oxcf.arnr_max_frames = cast,no_check(s32) vp8_cfg.arnr_max_frames;
    oxcf.arnr_strength = cast,no_check(s32) vp8_cfg.arnr_strength;
    oxcf.arnr_type = cast,no_check(s32) vp8_cfg.arnr_type;

    oxcf.tuning = vp8_cfg.tuning;

    oxcf.screen_content_mode = vp8_cfg.screen_content_mode;

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

update_error_state :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, error: *Internal_Error_Info) -> Codec_Err_T {
    RES := error.error_code;

    if RES != cast,no_check(u32) CODEC_OK {
        ctx.base.err_detail = ifx error.has_detail != 0 then error.detail.data else null;
    }

    return RES;
}

validate_config :: (
    ctx: *Codec_Alg_Priv_in_vp8_cx_iface,
    cfg: *Codec_Enc_Cfg_T,
    vp8_cfg: *Vp8_Extracfg,
    finalize: s32
) -> Codec_Err_T {
    if !((cfg.g_w == 1 || cfg.g_w > 1) && cfg.g_w <= 16383) {
        ctx.base.err_detail = c_string("g_w out of range [1..16383]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.g_h == 1 || cfg.g_h > 1) && cfg.g_h <= 16383) {
        ctx.base.err_detail = c_string("g_h out of range [1..16383]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.g_timebase.den == 1 || cfg.g_timebase.den > 1) && cfg.g_timebase.den <= 1000000000) {
        ctx.base.err_detail = c_string("g_timebase.den out of range [1..1000000000]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.g_timebase.num == 1 || cfg.g_timebase.num > 1) && cfg.g_timebase.num <= 1000000000) {
        ctx.base.err_detail = c_string("g_timebase.num out of range [1..1000000000]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !(cfg.g_profile <= 3) {
        ctx.base.err_detail = c_string("g_profile out of range [..3]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !(cfg.rc_max_quantizer <= 63) {
        ctx.base.err_detail = c_string("rc_max_quantizer out of range [..63]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !(cfg.rc_min_quantizer <= cfg.rc_max_quantizer) {
        ctx.base.err_detail = c_string("rc_min_quantizer out of range [..cfg->rc_max_quantizer]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !(cfg.g_threads <= 64) {
        ctx.base.err_detail = c_string("g_threads out of range [..64]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if !(cfg.g_lag_in_frames <= 25) {
        ctx.base.err_detail = c_string("g_lag_in_frames out of range [..25]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if !((cfg.rc_end_usage == cast,no_check(u32) VBR || cfg.rc_end_usage > cast,no_check(u32) VBR) && cfg.rc_end_usage <= cast,no_check(u32) Q) {
        ctx.base.err_detail = c_string("rc_end_usage out of range [VPX_VBR..VPX_Q]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !(cfg.rc_undershoot_pct <= 100) {
        ctx.base.err_detail = c_string("rc_undershoot_pct out of range [..100]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !(cfg.rc_overshoot_pct <= 100) {
        ctx.base.err_detail = c_string("rc_overshoot_pct out of range [..100]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !(cfg.rc_2pass_vbr_bias_pct <= 100) {
        ctx.base.err_detail = c_string("rc_2pass_vbr_bias_pct out of range [..100]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.kf_mode == cast,no_check(u32) KF_DISABLED || cfg.kf_mode > cast,no_check(u32) KF_DISABLED) && cfg.kf_mode <= cast,no_check(u32) KF_AUTO) {
        ctx.base.err_detail = c_string("kf_mode out of range [VPX_KF_DISABLED..VPX_KF_AUTO]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if cast(u32) (cfg.rc_resize_allowed != 0) != cfg.rc_resize_allowed {
        ctx.base.err_detail = c_string("rc_resize_allowed expected boolean");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if !(cfg.rc_dropframe_thresh <= 100) {
        ctx.base.err_detail = c_string("rc_dropframe_thresh out of range [..100]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !(cfg.rc_resize_up_thresh <= 100) {
        ctx.base.err_detail = c_string("rc_resize_up_thresh out of range [..100]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !(cfg.rc_resize_down_thresh <= 100) {
        ctx.base.err_detail = c_string("rc_resize_down_thresh out of range [..100]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if !((cfg.g_pass == cast,no_check(u32) RC_ONE_PASS || cfg.g_pass > cast,no_check(u32) RC_ONE_PASS) && cfg.g_pass <= cast,no_check(u32) RC_LAST_PASS) {
        ctx.base.err_detail = c_string("g_pass out of range [VPX_RC_ONE_PASS..VPX_RC_LAST_PASS]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if cfg.kf_mode != cast,no_check(u32) KF_DISABLED && cfg.kf_min_dist != cfg.kf_max_dist && cfg.kf_min_dist > 0 {
        ctx.base.err_detail = c_string("kf_min_dist not supported in auto mode, use 0 or kf_max_dist instead.");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if cast(u32) (vp8_cfg.enable_auto_alt_ref != 0) != vp8_cfg.enable_auto_alt_ref {
        ctx.base.err_detail = c_string("enable_auto_alt_ref expected boolean");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((vp8_cfg.cpu_used == -16 || vp8_cfg.cpu_used > -16) && vp8_cfg.cpu_used <= 16) {
        ctx.base.err_detail = c_string("cpu_used out of range [-16..16]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if !(vp8_cfg.static_thresh <= cast,no_check(u32) ((cast(s32) 1024) << 7 - 1)) {
        ctx.base.err_detail = c_string("static_thresh out of range [..(MAX_ERROR_BINS << 7) - 1]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if !(vp8_cfg.noise_sensitivity <= 6) {
        ctx.base.err_detail = c_string("noise_sensitivity out of range [..6]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if !((vp8_cfg.token_partitions == cast,no_check(u32) VP8_ONE_TOKENPARTITION || vp8_cfg.token_partitions > cast,no_check(u32) VP8_ONE_TOKENPARTITION) && vp8_cfg.token_partitions <= cast,no_check(u32) VP8_EIGHT_TOKENPARTITION) {
        ctx.base.err_detail =
            c_string("token_partitions out of range [VP8_ONE_TOKENPARTITION..VP8_EIGHT_TOKENPARTITION]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !(vp8_cfg.sharpness <= 7) {
        ctx.base.err_detail = c_string("Sharpness out of range [..7]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((vp8_cfg.arnr_max_frames == 0 || vp8_cfg.arnr_max_frames > 0) && vp8_cfg.arnr_max_frames <= 15) {
        ctx.base.err_detail = c_string("arnr_max_frames out of range [0..15]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !(vp8_cfg.arnr_strength <= 6) {
        ctx.base.err_detail = c_string("arnr_strength out of range [..6]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((vp8_cfg.arnr_type == 1 || vp8_cfg.arnr_type > 1) && vp8_cfg.arnr_type <= 3) {
        ctx.base.err_detail = c_string("arnr_type out of range [1..3]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((vp8_cfg.cq_level == 0 || vp8_cfg.cq_level > 0) && vp8_cfg.cq_level <= 63) {
        ctx.base.err_detail = c_string("cq_level out of range [0..63]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !(vp8_cfg.screen_content_mode <= 2) {
        ctx.base.err_detail = c_string("screen_content_mode out of range [..2]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if finalize != 0 && (cfg.rc_end_usage == cast,no_check(u32) CQ || cfg.rc_end_usage == cast,no_check(u32) Q) {
        if !((vp8_cfg.cq_level == cfg.rc_min_quantizer || vp8_cfg.cq_level > cfg.rc_min_quantizer) && vp8_cfg.cq_level <= cfg.rc_max_quantizer) {
            ctx.base.err_detail = c_string("cq_level out of range [cfg->rc_min_quantizer..cfg->rc_max_quantizer]");

            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }
    }

    if cfg.g_pass == cast,no_check(u32) RC_LAST_PASS {
        packet_sz: u64 = cast(u64) size_of(FIRSTPASS_STATS);
        n_packets := cast,no_check(s32) (cfg.rc_twopass_stats_in.sz / packet_sz);

        if cfg.rc_twopass_stats_in.buf == null {
            ctx.base.err_detail = c_string("rc_twopass_stats_in.buf not set.");

            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }

        if (((cfg.rc_twopass_stats_in.sz % packet_sz)) != 0) {
            ctx.base.err_detail = c_string("rc_twopass_stats_in.sz indicates truncated packet.");

            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }

        if cfg.rc_twopass_stats_in.sz < 2 * packet_sz {
            ctx.base.err_detail = c_string("rc_twopass_stats_in requires at least two packets.");

            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }

        stats :=
            cast(*FIRSTPASS_STATS) (cast(*void) ((cast(*s8) cfg.rc_twopass_stats_in.buf) +
                (cast,no_check(u64) (n_packets - 1)) * packet_sz));

        if cast,no_check(s32) (stats.count + 0.5) != n_packets - 1 {
            ctx.base.err_detail = c_string("rc_twopass_stats_in missing EOS stats packet");

            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }
    }

    if !((cfg.ts_number_layers == 1 || cfg.ts_number_layers > 1) && cfg.ts_number_layers <= 5) {
        ctx.base.err_detail = c_string("ts_number_layers out of range [1..5]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if cfg.ts_number_layers > 1 {
        if !((cfg.ts_periodicity == 1 || cfg.ts_periodicity > 1) && cfg.ts_periodicity <= 16) {
            ctx.base.err_detail = c_string("ts_periodicity out of range [1..16]");

            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }

        i: u32 = 1;
        while i < cfg.ts_number_layers {
            if cfg.ts_target_bitrate[i] <= cfg.ts_target_bitrate[i - 1] && cfg.rc_target_bitrate > 0 {
                ctx.base.err_detail = c_string("ts_target_bitrate entries are not strictly increasing");

                return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
            }
            i += 1;
        }

        if !((cfg.ts_rate_decimator[cfg.ts_number_layers - 1] == 1 || cfg.ts_rate_decimator[cfg.ts_number_layers - 1] > 1) && cfg.ts_rate_decimator[cfg.ts_number_layers - 1] <= 1) {
            ctx.base.err_detail = c_string("ts_rate_decimator[cfg->ts_number_layers - 1] out of range [1..1]");

            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }
        i = cfg.ts_number_layers - 2;
        while i > 0 {
            if cfg.ts_rate_decimator[i - 1] != 2 * cfg.ts_rate_decimator[i] {
                ctx.base.err_detail = c_string("ts_rate_decimator factors are not powers of 2");

                return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
            }
            i -= 1;
        }

        i = 0;
        while i < cfg.ts_periodicity {
            if !(cfg.ts_layer_id[i] <= cfg.ts_number_layers - 1) {
                ctx.base.err_detail = c_string("ts_layer_id[i] out of range [..cfg->ts_number_layers - 1]");

                return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
            }
            i += 1;
        }
    }

    if !((cfg.use_vizier_rc_params == 0 || cfg.use_vizier_rc_params > 0) && cfg.use_vizier_rc_params <= 1) {
        ctx.base.err_detail = c_string("use_vizier_rc_params out of range [0..1]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.active_wq_factor.den == 1 || cfg.active_wq_factor.den > 1) && cfg.active_wq_factor.den <= 1000) {
        ctx.base.err_detail = c_string("active_wq_factor.den out of range [1..1000]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.err_per_mb_factor.den == 1 || cfg.err_per_mb_factor.den > 1) && cfg.err_per_mb_factor.den <= 1000) {
        ctx.base.err_detail = c_string("err_per_mb_factor.den out of range [1..1000]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.sr_default_decay_limit.den == 1 || cfg.sr_default_decay_limit.den > 1) && cfg.sr_default_decay_limit.den <= 1000) {
        ctx.base.err_detail = c_string("sr_default_decay_limit.den out of range [1..1000]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.sr_diff_factor.den == 1 || cfg.sr_diff_factor.den > 1) && cfg.sr_diff_factor.den <= 1000) {
        ctx.base.err_detail = c_string("sr_diff_factor.den out of range [1..1000]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.kf_err_per_mb_factor.den == 1 || cfg.kf_err_per_mb_factor.den > 1) && cfg.kf_err_per_mb_factor.den <= 1000) {
        ctx.base.err_detail = c_string("kf_err_per_mb_factor.den out of range [1..1000]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.kf_frame_min_boost_factor.den == 1 || cfg.kf_frame_min_boost_factor.den > 1) && cfg.kf_frame_min_boost_factor.den <= 1000) {
        ctx.base.err_detail = c_string("kf_frame_min_boost_factor.den out of range [1..1000]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.kf_frame_max_boost_subs_factor.den == 1 || cfg.kf_frame_max_boost_subs_factor.den > 1) && cfg.kf_frame_max_boost_subs_factor.den <= 1000) {
        ctx.base.err_detail = c_string("kf_frame_max_boost_subs_factor.den out of range [1..1000]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.kf_max_total_boost_factor.den == 1 || cfg.kf_max_total_boost_factor.den > 1) && cfg.kf_max_total_boost_factor.den <= 1000) {
        ctx.base.err_detail = c_string("kf_max_total_boost_factor.den out of range [1..1000]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.gf_max_total_boost_factor.den == 1 || cfg.gf_max_total_boost_factor.den > 1) && cfg.gf_max_total_boost_factor.den <= 1000) {
        ctx.base.err_detail = c_string("gf_max_total_boost_factor.den out of range [1..1000]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.gf_frame_max_boost_factor.den == 1 || cfg.gf_frame_max_boost_factor.den > 1) && cfg.gf_frame_max_boost_factor.den <= 1000) {
        ctx.base.err_detail = c_string("gf_frame_max_boost_factor.den out of range [1..1000]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.zm_factor.den == 1 || cfg.zm_factor.den > 1) && cfg.zm_factor.den <= 1000) {
        ctx.base.err_detail = c_string("zm_factor.den out of range [1..1000]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.rd_mult_inter_qp_fac.den == 1 || cfg.rd_mult_inter_qp_fac.den > 1) && cfg.rd_mult_inter_qp_fac.den <= 1000) {
        ctx.base.err_detail = c_string("rd_mult_inter_qp_fac.den out of range [1..1000]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.rd_mult_arf_qp_fac.den == 1 || cfg.rd_mult_arf_qp_fac.den > 1) && cfg.rd_mult_arf_qp_fac.den <= 1000) {
        ctx.base.err_detail = c_string("rd_mult_arf_qp_fac.den out of range [1..1000]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.rd_mult_key_qp_fac.den == 1 || cfg.rd_mult_key_qp_fac.den > 1) && cfg.rd_mult_key_qp_fac.den <= 1000) {
        ctx.base.err_detail = c_string("rd_mult_key_qp_fac.den out of range [1..1000]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

vp8e_get_cxdata :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, iter: *Codec_Iter_T) -> *Codec_Cx_Pkt_T {
    return codec_pkt_list_get(*ctx.pkt_list.head, iter);
}

vp8e_encode :: (
    ctx: *Codec_Alg_Priv_in_vp8_cx_iface,
    img: *Image_T,
    pts: Codec_Pts_T,
    duration: u64,
    enc_flags: Enc_Frame_Flags_T,
    deadline: Enc_Deadline_T
) -> Codec_Err_T {
    res := cast,no_check(Codec_Err_T) CODEC_OK;

    flags := enc_flags;
    pts_val := pts;

    if ctx.cfg.rc_target_bitrate == 0 {
        return res;
    }

    if img != null {
        res = validate_img(ctx, img);
    }

    if !(res != 0) {
        res = validate_config(ctx, *ctx.cfg, *ctx.vp8_cfg, 1);
    }

    if !(res != 0) {
        res = pick_quickcompress_mode(ctx, duration, deadline);
    }
    ctx.pkt_list.alloc_.head.cnt = 0;
    assignment_0: u32 = cast,no_check(u32) ((64 * cast(u64) size_of(Codec_Cx_Pkt)) / size_of(Codec_Cx_Pkt));
    (ctx.pkt_list.alloc_.head.max) = assignment_0;

    if flags == 0 {
        flags = ctx.control_frame_flags;
    }
    ctx.control_frame_flags = 0;

    if !(res != 0) {
        res = set_reference_and_update(ctx, flags);
    }

    if ctx.cfg.kf_mode == cast,no_check(u32) KF_AUTO && ctx.cfg.kf_min_dist == ctx.cfg.kf_max_dist {
        if c_transpiler_pre_increment(*(ctx.fixed_kf_cntr)) > ctx.cfg.kf_min_dist {
            flags |= cast,no_check(Enc_Frame_Flags_T) (1);
            ctx.fixed_kf_cntr = 1;
        }
    }

    if !(res != 0) && ctx.cpi != null {
        dst_time_stamp, dst_end_time_stamp: s64 = ---;
        size: u64 = ---;

        comp_data_state: s32 = 0;

        if setjmp_2(ctx.cpi.common.error.jmp.data) != 0 {
            ctx.cpi.common.error.setjmp = 0;
            res = update_error_state(ctx, *ctx.cpi.common.error);

            return res;
        }
        ctx.cpi.common.error.setjmp = 1;

        if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 1) != 0 && ctx.cfg.g_lag_in_frames != 0 {
            internal_error(
                *ctx.cpi.common.error,
                cast,no_check(Codec_Err_T) CODEC_INCAPABLE,
                c_string("Cannot calculate per-frame PSNR when g_lag_in_frames is nonzero")
            );
        }

        ctx.cpi.b_calculate_psnr =
            cast(s32) (ctx.base.init_flags & 0x10000 != 0 ||
                flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 1) != 0);

        if ctx.base.init_flags & 0x20000 != 0 {
            ctx.cpi.output_partition = 1;
        }

        lib_flags := cast,no_check(u32) ((ifx flags & 1 != 0 then cast,no_check(s32) (FRAMEFLAGS_KEY) else 0));

        if img != null {
            sd: YV12_BUFFER_CONFIG = ---;

            if ctx.pts_offset_initialized == 0 {
                ctx.pts_offset = pts_val;
                ctx.pts_offset_initialized = 1;
            }
            if pts_val < ctx.pts_offset {
                internal_error(
                    *ctx.cpi.common.error,
                    cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM,
                    c_string("pts is smaller than initial pts")
                );
            }
            pts_val -= ctx.pts_offset;
            if pts_val > 9223372036854775807 / ctx.timestamp_ratio.num {
                internal_error(
                    *ctx.cpi.common.error,
                    cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM,
                    c_string("conversion of relative pts to ticks would overflow")
                );
            }
            dst_time_stamp = pts_val * ctx.timestamp_ratio.num / cast(Codec_Pts_T) ctx.timestamp_ratio.den;

            if duration > 9223372036854775807 {
                internal_error(
                    *ctx.cpi.common.error,
                    cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM,
                    c_string("duration is too big")
                );
            }

            if pts_val > 9223372036854775807 - cast,no_check(s64) duration {
                internal_error(
                    *ctx.cpi.common.error,
                    cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM,
                    c_string("relative pts + duration is too big")
                );
            }
            pts_end := pts_val + cast,no_check(s64) duration;
            if pts_end > 9223372036854775807 / ctx.timestamp_ratio.num {
                internal_error(
                    *ctx.cpi.common.error,
                    cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM,
                    c_string("conversion of relative pts + duration to ticks would overflow")
                );
            }
            dst_end_time_stamp = pts_end * ctx.timestamp_ratio.num / cast(Codec_Pts_T) ctx.timestamp_ratio.den;

            res = image2yuvconfig(img, *sd);

            if vp8_receive_raw_frame(ctx.cpi, ctx.next_frame_flag | lib_flags, *sd, dst_time_stamp, dst_end_time_stamp) != 0 {
                cpi := ctx.cpi;
                res = update_error_state(ctx, *cpi.common.error);
            }

            ctx.next_frame_flag = 0;
        }

        cx_data := ctx.cx_data;
        cx_data_sz := cast,no_check(u64) ctx.cx_data_sz;
        cx_data_end := ctx.cx_data + cx_data_sz;
        lib_flags = 0;

        while cx_data_sz >= cast,no_check(u64) (ctx.cx_data_sz / 2) {
            comp_data_state =
                vp8_get_compressed_data(
                    ctx.cpi,
                    *lib_flags,
                    *size,
                    cx_data,
                    cx_data_end,
                    *dst_time_stamp,
                    *dst_end_time_stamp,
                    cast(s32) (img == null)
                );

            if comp_data_state == CODEC_CORRUPT_FRAME {
                ctx.cpi.common.error.setjmp = 0;
                return cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME;
            } else if comp_data_state == -1 {
                break;
            }

            if size != 0 {
                pkt: Codec_Cx_Pkt_T = ---;
                cpi := ctx.cpi;

                round := ctx.timestamp_ratio.num / 2;
                if round > 0 {
                    round -= 1;
                }
                delta := dst_end_time_stamp - dst_time_stamp;
                pkt.kind = cast,no_check(Codec_Cx_Pkt_Kind) CODEC_CX_FRAME_PKT;
                pkt.data.frame.pts =
                    (((dst_time_stamp * cast(s64) ctx.timestamp_ratio.den) + round) / ctx.timestamp_ratio.num) +
                        ctx.pts_offset;
                pkt.data.frame.duration =
                    cast,no_check(u64) (((delta * cast(Codec_Pts_T) ctx.timestamp_ratio.den) + round) /
                        ctx.timestamp_ratio.num);
                pkt.data.frame.flags = lib_flags << 16;
                pkt.data.frame.width[0] = cast,no_check(u32) cpi.common.width;
                pkt.data.frame.height[0] = cast,no_check(u32) cpi.common.height;
                pkt.data.frame.spatial_layer_encoded[0] = 1;

                if lib_flags & cast,no_check(u32) FRAMEFLAGS_KEY != 0 {
                    pkt.data.frame.flags = cast,no_check(Codec_Frame_Flags_T) (pkt.data.frame.flags | 0x1);
                }

                if cpi.common.show_frame == 0 {
                    pkt.data.frame.flags = cast,no_check(Codec_Frame_Flags_T) (pkt.data.frame.flags | 0x4);

                    pkt.data.frame.pts =
                        ((((cpi.last_time_stamp_seen * cast(s64) ctx.timestamp_ratio.den) + round) / ctx.timestamp_ratio.num) + ctx.pts_offset) +
                            1;
                    pkt.data.frame.duration = 0;
                }

                if cpi.droppable != 0 {
                    pkt.data.frame.flags = cast,no_check(Codec_Frame_Flags_T) (pkt.data.frame.flags | 0x2);
                }

                if cpi.output_partition != 0 {
                    NUM_PARTITIONS := ((cast(s32) 1) << ((cpi.common.multi_token_partition) & 31)) + 1;

                    pkt.data.frame.flags = cast,no_check(Codec_Frame_Flags_T) (pkt.data.frame.flags | 0x8);

                    if 0 < NUM_PARTITIONS {
                        for i: 0..NUM_PARTITIONS - 1 {
                            pkt.data.frame.buf = cast(*void) cx_data;
                            cx_data += cpi.partition_sz[i];
                            cx_data_sz -= cast,no_check(u64) cpi.partition_sz[i];

                            pkt.data.frame.sz = cast,no_check(u64) cpi.partition_sz[i];
                            pkt.data.frame.partition_id = i;

                            if i == NUM_PARTITIONS - 1 {
                                pkt.data.frame.flags = cast,no_check(Codec_Frame_Flags_T) (pkt.data.frame.flags & ~(cast(u32) 0x8));
                            }
                            codec_pkt_list_add(*ctx.pkt_list.head, *pkt);
                        }
                    }
                } else {
                    pkt.data.frame.buf = cast(*void) cx_data;
                    pkt.data.frame.sz = size;
                    pkt.data.frame.partition_id = -1;
                    codec_pkt_list_add(*ctx.pkt_list.head, *pkt);
                    cx_data += size;
                    cx_data_sz -= size;
                }
            }
        }
        ctx.cpi.common.error.setjmp = 0;
    }

    return res;
}

image2yuvconfig :: (img: *Image_T, yv12: *YV12_BUFFER_CONFIG) -> Codec_Err_T {
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

    yv12.border = cast,no_check(s32) (((cast,no_check(u32) img.stride[0]) - img.w) / 2);
    return res;
}

set_reference_and_update :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, flags: Enc_Frame_Flags_T) -> Codec_Err_T {
    if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 22) != 0 &&
        flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 19) != 0 ||
        flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 23) != 0 &&
            flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 24) != 0 {
        ctx.base.err_detail = c_string("Conflicting flags.");
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 16 | ((cast(s32) 1) << 17) | ((cast(s32) 1) << 21)) != 0 {
        ref: s32 = 7;

        if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 16) != 0 {
            ref ^= cast,no_check(s32) (VP8_LAST_FRAME);
        }

        if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 17) != 0 {
            ref ^= cast,no_check(s32) (VP8_GOLD_FRAME);
        }

        if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 21) != 0 {
            ref ^= cast,no_check(s32) (VP8_ALTR_FRAME);
        }

        vp8_use_as_reference(ctx.cpi, ref);
    }

    if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 18 | ((cast(s32) 1) << 22) | ((cast(s32) 1) << 23) | ((cast(s32) 1) << 19) | ((cast(s32) 1) << 24)) != 0 {
        upd: s32 = 7;

        if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 18) != 0 {
            upd ^= cast,no_check(s32) (VP8_LAST_FRAME);
        }

        if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 22) != 0 {
            upd ^= cast,no_check(s32) (VP8_GOLD_FRAME);
        }

        if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 23) != 0 {
            upd ^= cast,no_check(s32) (VP8_ALTR_FRAME);
        }

        vp8_update_reference(ctx.cpi, upd);
    }

    if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 20) != 0 {
        vp8_update_entropy(ctx.cpi, 0);
    }

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

pick_quickcompress_mode :: (
    ctx: *Codec_Alg_Priv_in_vp8_cx_iface,
    duration: u64,
    deadline: Enc_Deadline_T
) -> Codec_Err_T {
    new_qc := cast,no_check(s32) (MODE_BESTQUALITY);

    if deadline != 0 {
        {
            static_assert: Pick_Quickcompress_Mode_Static_Assert_Entry = ---;
        }

        if duration > (cast(u64) 18446744073709551615) / cast,no_check(u64) ctx.timestamp_ratio.num {
            ctx.base.err_detail = c_string("duration is too big");

            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }
        duration_us :=
            (duration * cast,no_check(u64) ctx.timestamp_ratio.num) /
                ((cast,no_check(u64) ctx.timestamp_ratio.den) * (10000000 / 1000000));

        new_qc =
            ifx deadline > duration_us then cast,no_check(s32) (MODE_GOODQUALITY) else cast,no_check(s32) (MODE_REALTIME);
    }

    if deadline == 1 {
        new_qc = cast,no_check(s32) (MODE_REALTIME);
    } else if ctx.cfg.g_pass == cast,no_check(u32) RC_FIRST_PASS {
        new_qc = cast,no_check(s32) (MODE_FIRSTPASS);
    } else if ctx.cfg.g_pass == cast,no_check(u32) RC_LAST_PASS {
        new_qc =
            ifx new_qc == MODE_BESTQUALITY then cast,no_check(s32) (MODE_SECONDPASS_BEST) else cast,no_check(s32) (MODE_SECONDPASS);
    }

    if ctx.oxcf.mode != new_qc {
        ctx.oxcf.mode = new_qc;
        (cast,no_check(#type (_: *VP8_COMP, _: *VP8_CONFIG)) (cast(*void) vp8_change_config))(ctx.cpi, *ctx.oxcf);
    }
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

validate_img :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, img: *Image_T) -> Codec_Err_T {
    if img.fmt == {
        case cast,no_check(u32) IMG_FMT_YV12; #through;
        case cast,no_check(u32) IMG_FMT_I420; #through;
        case cast,no_check(u32) IMG_FMT_NV12;
        case;
            ctx.base.err_detail = c_string("Invalid image format. Only YV12, I420 and NV12 images are supported");

            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if img.d_w != ctx.cfg.g_w || img.d_h != ctx.cfg.g_h {
        ctx.base.err_detail = c_string("Image size must match encoder init configuration size");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if img.stride[1] != img.stride[2] {
        ctx.base.err_detail = c_string("Image U/V strides must match");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_set_rtc_external_ratectrl :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    cpi: *VP8_COMP = ctx.cpi;
    DATA := cast,no_check(u32) vp8_e_set_rtc_external_ratectrl_value(args);
    if DATA != 0 {
        cpi.cyclic_refresh_mode_enabled = 0;
        cpi.rt_always_update_correction_factor = 1;
        cpi.rt_drop_recode_on_overshoot = 0;
    }
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

vp8_e_set_rtc_external_ratectrl_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

ctrl_set_rc_gf_cbr_boost_pct :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.vp8_cfg;
    extra_cfg.gf_cbr_boost_pct = vp8_e_set_gf_cbr_boost_pct_value(args);
    return update_extracfg(ctx, *extra_cfg);
}

update_extracfg :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, extra_cfg: *Vp8_Extracfg) -> Codec_Err_T {
    RES := validate_config(ctx, *ctx.cfg, extra_cfg, 0);
    if RES != cast,no_check(u32) CODEC_OK {
        return RES;
    }

    if setjmp_2(ctx.cpi.common.error.jmp.data) != 0 {
        CODEC_ERR := update_error_state(ctx, *ctx.cpi.common.error);
        ctx.cpi.common.error.setjmp = 0;

        return CODEC_ERR;
    }
    ctx.cpi.common.error.setjmp = 1;
    ctx.vp8_cfg = extra_cfg.*;
    set_vp8e_config(*ctx.oxcf, ctx.cfg, ctx.vp8_cfg, null);
    (cast,no_check(#type (_: *VP8_COMP, _: *VP8_CONFIG)) (cast(*void) vp8_change_config))(ctx.cpi, *ctx.oxcf);
    ctx.cpi.common.error.setjmp = 0;
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

vp8_e_set_gf_cbr_boost_pct_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

set_screen_content_mode :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.vp8_cfg;
    extra_cfg.screen_content_mode = vp8_e_set_screen_content_mode_value(args);
    return update_extracfg(ctx, *extra_cfg);
}

vp8_e_set_screen_content_mode_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

set_rc_max_intra_bitrate_pct :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.vp8_cfg;
    extra_cfg.rc_max_intra_bitrate_pct = vp8_e_set_max_intra_bitrate_pct_value(args);
    return update_extracfg(ctx, *extra_cfg);
}

vp8_e_set_max_intra_bitrate_pct_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

set_cq_level :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.vp8_cfg;
    extra_cfg.cq_level = vp8_e_set_cq_level_value(args);
    return update_extracfg(ctx, *extra_cfg);
}

vp8_e_set_cq_level_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

set_tuning :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.vp8_cfg;
    extra_cfg.tuning = cast,no_check(Vp8e_Tuning) vp8_e_set_tuning_value(args);
    return update_extracfg(ctx, *extra_cfg);
}

vp8_e_set_tuning_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

set_arnr_type :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.vp8_cfg;
    extra_cfg.arnr_type = vp8_e_set_arnr_type_value(args);
    return update_extracfg(ctx, *extra_cfg);
}

vp8_e_set_arnr_type_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

set_arnr_strength :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.vp8_cfg;
    extra_cfg.arnr_strength = vp8_e_set_arnr_strength_value(args);
    return update_extracfg(ctx, *extra_cfg);
}

vp8_e_set_arnr_strength_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

set_arnr_max_frames :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.vp8_cfg;
    extra_cfg.arnr_max_frames = vp8_e_set_arnr_maxframes_value(args);
    return update_extracfg(ctx, *extra_cfg);
}

vp8_e_set_arnr_maxframes_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

get_quantizer64 :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    ARG := c_transpiler_va_arg(cast(*void) (args), *s32);
    if ARG == null {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    ARG.* = vp8_reverse_trans(vp8_get_quantizer(ctx.cpi));
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

get_quantizer :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    ARG := c_transpiler_va_arg(cast(*void) (args), *s32);
    if ARG == null {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    ARG.* = vp8_get_quantizer(ctx.cpi);
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

set_token_partitions :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.vp8_cfg;
    extra_cfg.token_partitions = cast,no_check(u32) vp8_e_set_token_partitions_value(args);
    return update_extracfg(ctx, *extra_cfg);
}

vp8_e_set_token_partitions_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

set_static_thresh :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.vp8_cfg;
    extra_cfg.static_thresh = vp8_e_set_static_threshold_value(args);
    return update_extracfg(ctx, *extra_cfg);
}

vp8_e_set_static_threshold_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

set_sharpness :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.vp8_cfg;
    extra_cfg.sharpness = vp8_e_set_sharpness_value(args);
    return update_extracfg(ctx, *extra_cfg);
}

vp8_e_set_sharpness_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

set_enable_auto_alt_ref :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.vp8_cfg;
    extra_cfg.enable_auto_alt_ref = vp8_e_set_enableautoaltref_value(args);
    return update_extracfg(ctx, *extra_cfg);
}

vp8_e_set_enableautoaltref_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

set_noise_sensitivity :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.vp8_cfg;
    extra_cfg.noise_sensitivity = vp8_e_set_noise_sensitivity_value(args);
    return update_extracfg(ctx, *extra_cfg);
}

vp8_e_set_noise_sensitivity_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

set_cpu_used :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.vp8_cfg;
    extra_cfg.cpu_used = vp8_e_set_cpuused_value(args);

    extra_cfg.cpu_used = ifx 16 < extra_cfg.cpu_used then 16 else extra_cfg.cpu_used;
    extra_cfg.cpu_used = ifx -16 > extra_cfg.cpu_used then -16 else extra_cfg.cpu_used;
    return update_extracfg(ctx, *extra_cfg);
}

vp8_e_set_cpuused_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8e_set_scalemode :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    data := c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);

    if data != null {
        scalemode := data.*;
        res := vp8_set_internal_size(ctx.cpi, scalemode.h_scaling_mode, scalemode.v_scaling_mode);

        if res == 0 {
            ctx.next_frame_flag |= cast,no_check(u32) FRAMEFLAGS_KEY;
            return cast,no_check(Codec_Err_T) CODEC_OK;
        } else {
            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }
    } else {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
}

vp8e_set_activemap :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    data := c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);

    if data != null {
        map := data;

        if vp8_set_active_map(ctx.cpi, map.active_map, map.rows, map.cols) == 0 {
            return cast,no_check(Codec_Err_T) CODEC_OK;
        } else {
            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }
    } else {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
}

vp8e_set_roi_map :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    data := c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);

    if data != null {
        roi := data;

        if vp8_set_roimap(
            ctx.cpi,
            roi.roi_map,
            roi.rows,
            roi.cols,
            roi.delta_q.data,
            roi.delta_lf.data,
            roi.static_threshold.data
        ) == 0 {
            return cast,no_check(Codec_Err_T) CODEC_OK;
        } else {
            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }
    } else {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
}

vp8e_set_temporal_layer_id :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    layer_id := c_transpiler_va_arg(cast(*void) (args), s32);
    if layer_id < 0 || layer_id >= cast,no_check(s32) ctx.cfg.ts_number_layers {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    ctx.cpi.temporal_layer_id = layer_id;
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

vp8e_set_frame_flags :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    frame_flags := c_transpiler_va_arg(cast(*void) (args), s32);
    ctx.control_frame_flags = cast,no_check(Enc_Frame_Flags_T) frame_flags;
    return set_reference_and_update(ctx, cast,no_check(Enc_Frame_Flags_T) frame_flags);
}

vp8e_set_previewpp :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    return cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
}

vp8e_get_reference :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    data := c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);

    if data != null {
        frame := data;
        sd: YV12_BUFFER_CONFIG = ---;

        image2yuvconfig(*frame.img, *sd);
        if vp8_get_reference(ctx.cpi, frame.frame_type, *sd) != 0 {
            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }
        return cast,no_check(Codec_Err_T) CODEC_OK;
    } else {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
}

vp8e_set_reference :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    data := c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);

    if data != null {
        frame := data;
        sd: YV12_BUFFER_CONFIG = ---;

        image2yuvconfig(*frame.img, *sd);
        if vp8_set_reference(ctx.cpi, frame.frame_type, *sd) != 0 {
            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }
        return cast,no_check(Codec_Err_T) CODEC_OK;
    } else {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
}

vp8e_destroy :: (ctx: *Codec_Alg_Priv_in_vp8_cx_iface) -> Codec_Err_T {
    c_transpiler_deallocate_memory(ctx.cx_data);
    vp8_remove_compressor(*ctx.cpi);
    deallocate_memory(cast(*void) ctx);
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

vp8e_init :: (ctx: *Codec_Ctx_T, mr_cfg: *Codec_Priv_Enc_Mr_Cfg_T) -> Codec_Err_T {
    res := cast,no_check(Codec_Err_T) CODEC_OK;

    vp8_rtcd();
    dsp_rtcd();
    scale_rtcd();

    if ctx.priv == null {
        priv :=
            cast(*Codec_Alg_Priv_in_vp8_cx_iface) calloc_2(
                1,
                size_of(Codec_Alg_Priv_in_vp8_cx_iface)
            );

        if priv == null {
            return cast,no_check(Codec_Err_T) CODEC_MEM_ERROR;
        }

        ctx.priv = cast(*Codec_Priv_T) priv;
        ctx.priv.init_flags = ctx.init_flags;

        if ctx.config.enc != null {
            priv.cfg = ctx.config.enc.*;
            ctx.config.enc = *priv.cfg;
        }

        priv.vp8_cfg = default_extracfg;
        priv.vp8_cfg.pkt_list = *priv.pkt_list.head;

        priv.cx_data_sz = ((priv.cfg.g_w * priv.cfg.g_h * 3) / 2) * 2;

        if priv.cx_data_sz < 32768 {
            priv.cx_data_sz = 32768;
        }

        priv.cx_data = cast(*u8) c_transpiler_allocate_memory(cast,no_check(u64) priv.cx_data_sz);

        if priv.cx_data == null {
            priv.cx_data_sz = 0;
            return cast,no_check(Codec_Err_T) CODEC_MEM_ERROR;
        }

        if mr_cfg != null {
            ctx.priv.enc.total_encoders = mr_cfg.mr_total_resolutions;
        } else {
            ctx.priv.enc.total_encoders = 1;
        }

        vp8_initialize_enc();

        res = validate_config(priv, *priv.cfg, *priv.vp8_cfg, 0);

        if !(res != 0) {
            priv.pts_offset_initialized = 0;
            priv.timestamp_ratio.den = priv.cfg.g_timebase.den;
            priv.timestamp_ratio.num = cast,no_check(s64) priv.cfg.g_timebase.num;
            priv.timestamp_ratio.num *= 10000000;
            reduce_ratio(*priv.timestamp_ratio);

            set_vp8e_config(*priv.oxcf, priv.cfg, priv.vp8_cfg, mr_cfg);
            priv.cpi =
                (cast,no_check(#type (_: *VP8_CONFIG) -> *VP8_COMP) (cast(*void) vp8_create_compressor))(
                    *priv.oxcf
                );
            if priv.cpi == null {
                res = cast,no_check(Codec_Err_T) CODEC_MEM_ERROR;
            }
        }
    }

    return res;
}

codec_vp8_cx :: () -> *Codec_Iface_T {
    return *CODEC_VP8_CX_ALGO;
}

vp8_e_set_roi_map_value :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_get_last_quantizer_value :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_frame_flags_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_lossless_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_enable_motion_vector_unit_test_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_quantizer_one_pass_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

scale2_ratio :: (mode: s32, hr: *s32, hs: *s32) {
    if mode == {
        case VP8E_NORMAL;
            hr.* = 1;
            hs.* = 1;
        case VP8E_FOURFIVE;
            hr.* = 4;
            hs.* = 5;
        case VP8E_THREEFIVE;
            hr.* = 3;
            hs.* = 5;
        case VP8E_ONETWO;
            hr.* = 1;
            hs.* = 2;
        case;
            hr.* = 1;
            hs.* = 1;
    }
}

validate_buffer :: (start: *u8, len: u64, end: *u8, error: *Internal_Error_Info) -> s32 {
    if start + len > start && start + len < end {
        return 1;
    } else {
        internal_error(
            error,
            cast,no_check(Codec_Err_T) CODEC_CORRUPT_FRAME,
            c_string("Truncated packet or corrupt partition ")
        );
    }

    return 0;
}

vp8_encode_bool :: (bc: *BOOL_CODER, bit: s32, probability: s32) {
    count := bc.count;
    range := bc.range;
    lowvalue := bc.lowvalue;

    split := 1 + ((range - 1) * cast,no_check(u32) probability) >> 8;

    range = split;

    if bit != 0 {
        lowvalue += split;
        range = bc.range - split;
    }

    shift := cast,no_check(s32) VP8_NORM[range];

    c_transpiler_compound_shl(*(range), (((cast,no_check(u32) shift) & 31)), u32, u32);
    count += shift;

    if count >= 0 {
        offset := shift - count;

        if lowvalue << (((offset - 1)) & 31) & 0x80000000 != 0 {
            x := cast,no_check(s32) (bc.pos - 1);

            while x >= 0 && bc.buffer[x] == 0xff {
                bc.buffer[x] = 0;
                x -= 1;
            }

            bc.buffer[x] = cast,no_check(u8) ((cast,no_check(s32) bc.buffer[x]) + 1);
        }

        validate_buffer(bc.buffer + bc.pos, 1, bc.buffer_end, bc.error);
        bc.buffer[bc.pos] = cast,no_check(u8) (lowvalue >> (((24 - offset)) & 31) & 0xff);
        bc.pos += 1;

        shift = count;
        lowvalue =
            cast,no_check(u32) (cast,no_check(s32) ((cast,no_check(u64) lowvalue) << ((offset) & 63) & 0xffffff));
        count -= 8;
    }

    c_transpiler_compound_shl(*(lowvalue), (((cast,no_check(u32) shift) & 31)), u32, u32);
    bc.count = count;
    bc.lowvalue = lowvalue;
    bc.range = range;
}

vp8_cost_branch :: (ct: *u32, p: Vp8_Prob) -> u32 {
    return cast,no_check(u32) ((((cast,no_check(u64) ct[0]) * cast(u64) VP8_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP8_PROB_COST[255 - cast(s32) p]) >> 8);
}

vp8_treed_write :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) {
    i: Vp8_Tree_Index = 0;

    while true {
        {
            B := v >> ((c_transpiler_pre_decrement(*(n))) & 31) & 1;
            vp8_encode_bool(W, B, cast,no_check(s32) P[(cast(s32) i) >> 1]);
            i = t[(cast(s32) i) + B];
        }
        if n == 0 break;
    }
}

vp8_write_token :: (W: *Vp8_Writer_in_treewriter, t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) {
    vp8_treed_write(W, t, P, X.value, X.len);
}

vp8_treed_cost :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, v: s32, n: s32) -> s32 {
    c: s32 = 0;
    i: Vp8_Tree_Index = 0;

    while true {
        {
            B := v >> ((c_transpiler_pre_decrement(*(n))) & 31) & 1;
            c_transpiler_compound_add(*(c), (VP8_PROB_COST[(ifx B != 0 then 255 - cast(s32) P[(cast(s32) i) >> 1] else cast,no_check(s32) P[(cast(s32) i) >> 1])]), u32, u32);
            i = t[(cast(s32) i) + B];
        }
        if n == 0 break;
    }

    return c;
}

vp8_cost_token :: (t: *Vp8_Tree_Index, P: *Vp8_Prob, X: *Vp8_Token) -> s32 {
    return vp8_treed_cost(t, P, X.value, X.len);
}

vp8_sem_wait :: (sem: *Sem_T) -> s32 {
    ret: s32 = ---;
    while ((ifx true { assignment_1: s32 = cast,no_check(s32) (sem_wait(sem)); (ret) = assignment_1; assignment_1; }) == -1) && system_error_code().* == 4 {
    }
    return ret;
}

atomic_init :: (atomic: *Atomic_Int, value: s32) {
    atomic.value = value;
}

atomic_store_release :: (atomic: *Atomic_Int, value: s32) {
    c_transpiler_atomic_store(*atomic.value, value);
}

atomic_load_acquire :: (atomic: *Atomic_Int) -> s32 {
    return atomic_load(*atomic.value);
}

vp8_atomic_spin_wait :: (mb_col: s32, last_row_current_mb_col: *Atomic_Int, NSYNC: s32) {
    while mb_col > atomic_load_acquire(last_row_current_mb_col) - NSYNC {
    }
}

mv_bias_in_vp8_cx_iface :: (
    refmb_ref_frame_sign_bias: s32,
    refframe: s32,
    mvp: *Int_Mv_in_mv,
    ref_frame_sign_bias: *s32
) {
    if refmb_ref_frame_sign_bias != ref_frame_sign_bias[refframe] {
        mvp.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.row) * -1);
        mvp.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.col) * -1);
    }
}

vp8_clamp_mv2_in_vp8_cx_iface :: (mv: *Int_Mv_in_mv, xd: *MACROBLOCKD_in_blockd) {
    if cast,no_check(s32) mv.as_mv.col < xd.mb_to_left_edge - (cast(s32) 16) << 3 {
        mv.as_mv.col = cast,no_check(s16) (xd.mb_to_left_edge - (cast(s32) 16) << 3);
    } else if cast,no_check(s32) mv.as_mv.col > xd.mb_to_right_edge + (cast(s32) 16) << 3 {
        mv.as_mv.col = cast,no_check(s16) (xd.mb_to_right_edge + (cast(s32) 16) << 3);
    }

    if cast,no_check(s32) mv.as_mv.row < xd.mb_to_top_edge - (cast(s32) 16) << 3 {
        mv.as_mv.row = cast,no_check(s16) (xd.mb_to_top_edge - (cast(s32) 16) << 3);
    } else if cast,no_check(s32) mv.as_mv.row > xd.mb_to_bottom_edge + (cast(s32) 16) << 3 {
        mv.as_mv.row = cast,no_check(s16) (xd.mb_to_bottom_edge + (cast(s32) 16) << 3);
    }
}

vp8_clamp_mv_in_vp8_cx_iface :: (
    mv: *Int_Mv_in_mv,
    mb_to_left_edge: s32,
    mb_to_right_edge: s32,
    mb_to_top_edge: s32,
    mb_to_bottom_edge: s32
) {
    mv.as_mv.col =
        cast,no_check(s16) ((ifx cast,no_check(s32) mv.as_mv.col < mb_to_left_edge then mb_to_left_edge else cast,no_check(s32) mv.as_mv.col));
    mv.as_mv.col =
        cast,no_check(s16) ((ifx cast,no_check(s32) mv.as_mv.col > mb_to_right_edge then mb_to_right_edge else cast,no_check(s32) mv.as_mv.col));
    mv.as_mv.row =
        cast,no_check(s16) ((ifx cast,no_check(s32) mv.as_mv.row < mb_to_top_edge then mb_to_top_edge else cast,no_check(s32) mv.as_mv.row));
    mv.as_mv.row =
        cast,no_check(s16) ((ifx cast,no_check(s32) mv.as_mv.row > mb_to_bottom_edge then mb_to_bottom_edge else cast,no_check(s32) mv.as_mv.row));
}

vp8_check_mv_bounds_in_vp8_cx_iface :: (
    mv: *Int_Mv_in_mv,
    mb_to_left_edge: s32,
    mb_to_right_edge: s32,
    mb_to_top_edge: s32,
    mb_to_bottom_edge: s32
) -> u32 {
    need_to_clamp := cast(u32) (cast,no_check(s32) mv.as_mv.col < mb_to_left_edge);
    need_to_clamp |= cast(u32) (cast,no_check(s32) mv.as_mv.col > mb_to_right_edge);
    need_to_clamp |= cast(u32) (cast,no_check(s32) mv.as_mv.row < mb_to_top_edge);
    need_to_clamp |= cast(u32) (cast,no_check(s32) mv.as_mv.row > mb_to_bottom_edge);
    return need_to_clamp;
}

left_block_mv_in_vp8_cx_iface :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> u32 {
    if b & 3 == 0 {
        cur_mb -= 1;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 4;
    }

    return (((cur_mb.bmi.data + b - 1)).mv).as_int;
}

above_block_mv_in_vp8_cx_iface :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> u32 {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 16;
    }

    return (((cur_mb.bmi.data + (b - 4))).mv).as_int;
}

left_block_mode_in_vp8_cx_iface :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> B_PREDICTION_MODE {
    if b & 3 == 0 {
        cur_mb -= 1;
        if cast,no_check(s32) cur_mb.mbmi.mode == {
            case B_PRED;
                return ((cur_mb.bmi.data + b + 3)).as_mode;
            case DC_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_DC_PRED;
            case V_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_VE_PRED;
            case H_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_HE_PRED;
            case TM_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_TM_PRED;
            case;
                return cast,no_check(B_PREDICTION_MODE) B_DC_PRED;
        }
    }

    return ((cur_mb.bmi.data + b - 1)).as_mode;
}

above_block_mode_in_vp8_cx_iface :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> B_PREDICTION_MODE {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cast,no_check(s32) cur_mb.mbmi.mode == {
            case B_PRED;
                return ((cur_mb.bmi.data + b + 12)).as_mode;
            case DC_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_DC_PRED;
            case V_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_VE_PRED;
            case H_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_HE_PRED;
            case TM_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_TM_PRED;
            case;
                return cast,no_check(B_PREDICTION_MODE) B_DC_PRED;
        }
    }

    return ((cur_mb.bmi.data + b - 4)).as_mode;
}

globals_initialization_state_for_vp8_cx_iface: u32;
initialize_globals_for_vp8_cx_iface :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp8_cx_iface);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp8_cx_iface, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp8_cx_iface) != 2 {}
            return;
        }
    }
    default_extracfg =
        Vp8_Extracfg.{
            pkt_list = null,
            cpu_used = 0,
            enable_auto_alt_ref = 0,
            noise_sensitivity = 0,
            sharpness = 0,
            static_thresh = 0,
            token_partitions = cast,no_check(u32) VP8_ONE_TOKENPARTITION,
            arnr_max_frames = 0,
            arnr_strength = 3,
            arnr_type = 3,
            tuning = cast,no_check(Vp8e_Tuning) (cast(s32) 0),
            cq_level = 10,
            rc_max_intra_bitrate_pct = 0,
            gf_cbr_boost_pct = 0,
            screen_content_mode = 0
        };
    VP8E_CTF_MAPS =
        Codec_Ctrl_Fn_Map_T.[
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8_SET_REFERENCE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) vp8e_set_reference},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8_COPY_REFERENCE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) vp8e_get_reference},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8_SET_POSTPROC), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) vp8e_set_previewpp},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_FRAME_FLAGS), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) vp8e_set_frame_flags},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_TEMPORAL_LAYER_ID), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) vp8e_set_temporal_layer_id},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_ROI_MAP), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) vp8e_set_roi_map},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_ACTIVEMAP), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) vp8e_set_activemap},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_SCALEMODE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) vp8e_set_scalemode},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_CPUUSED), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) set_cpu_used},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_NOISE_SENSITIVITY), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) set_noise_sensitivity},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_ENABLEAUTOALTREF), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) set_enable_auto_alt_ref},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_SHARPNESS), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) set_sharpness},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_STATIC_THRESHOLD), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) set_static_thresh},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_TOKEN_PARTITIONS), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) set_token_partitions},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_GET_LAST_QUANTIZER), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) get_quantizer},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_GET_LAST_QUANTIZER_64), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) get_quantizer64},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_ARNR_MAXFRAMES), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) set_arnr_max_frames},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_ARNR_STRENGTH), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) set_arnr_strength},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_ARNR_TYPE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) set_arnr_type},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_TUNING), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) set_tuning},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_CQ_LEVEL), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) set_cq_level},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_MAX_INTRA_BITRATE_PCT), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) set_rc_max_intra_bitrate_pct},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_SCREEN_CONTENT_MODE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) set_screen_content_mode},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_GF_CBR_BOOST_PCT), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_rc_gf_cbr_boost_pct},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_RTC_EXTERNAL_RATECTRL), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_rtc_external_ratectrl},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = -1, fn = null}
        ];
    VP8E_USAGE_CFG_MAP =
        Codec_Enc_Cfg_Map_T.[
            Codec_Enc_Cfg_Map_T.{usage = 0, cfg = Codec_Enc_Cfg_T.{g_usage = 0, g_threads = 0, g_profile = 0, g_w = 320, g_h = 240, g_bit_depth = cast,no_check(Bit_Depth_T) BITS_8, g_input_bit_depth = 8, g_timebase = Rational.{num = 1, den = 30}, g_error_resilient = 0, g_pass = cast,no_check(Enc_Pass) RC_ONE_PASS, g_lag_in_frames = 0, rc_dropframe_thresh = 0, rc_resize_allowed = 0, rc_scaled_width = 1, rc_scaled_height = 1, rc_resize_up_thresh = 60, rc_resize_down_thresh = 30, rc_end_usage = cast,no_check(Rc_Mode) VBR, rc_twopass_stats_in = Fixed_Buf_T.{buf = null, sz = 0}, rc_firstpass_mb_stats_in = Fixed_Buf_T.{buf = null, sz = 0}, rc_target_bitrate = 256, rc_min_quantizer = 4, rc_max_quantizer = 63, rc_undershoot_pct = 100, rc_overshoot_pct = 100, rc_buf_sz = 6000, rc_buf_initial_sz = 4000, rc_buf_optimal_sz = 5000, rc_2pass_vbr_bias_pct = 50, rc_2pass_vbr_minsection_pct = 0, rc_2pass_vbr_maxsection_pct = 400, rc_2pass_vbr_corpus_complexity = 0, kf_mode = cast,no_check(Kf_Mode) KF_AUTO, kf_min_dist = 0, kf_max_dist = 128, ss_number_layers = 1, ss_enable_auto_alt_ref = s32.[ 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0 ], ss_target_bitrate = u32.[ 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0 ], ts_number_layers = 1, ts_target_bitrate = u32.[ 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0 ], ts_rate_decimator = u32.[ 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0 ], ts_periodicity = 0, ts_layer_id = u32.[ 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0 ], layer_target_bitrate = u32.[ 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0 ], temporal_layering_mode = 0, use_vizier_rc_params = 0, active_wq_factor = Rational_T.{num = 1, den = 1}, err_per_mb_factor = Rational_T.{num = 1, den = 1}, sr_default_decay_limit = Rational_T.{num = 1, den = 1}, sr_diff_factor = Rational_T.{num = 1, den = 1}, kf_err_per_mb_factor = Rational_T.{num = 1, den = 1}, kf_frame_min_boost_factor = Rational_T.{num = 1, den = 1}, kf_frame_max_boost_first_factor = Rational_T.{num = 1, den = 1}, kf_frame_max_boost_subs_factor = Rational_T.{num = 1, den = 1}, kf_max_total_boost_factor = Rational_T.{num = 1, den = 1}, gf_max_total_boost_factor = Rational_T.{num = 1, den = 1}, gf_frame_max_boost_factor = Rational_T.{num = 1, den = 1}, zm_factor = Rational_T.{num = 1, den = 1}, rd_mult_inter_qp_fac = Rational_T.{num = 1, den = 1}, rd_mult_arf_qp_fac = Rational_T.{num = 1, den = 1}, rd_mult_key_qp_fac = Rational_T.{num = 1, den = 1}}}
        ];
    CODEC_VP8_CX_ALGO =
        Codec_Iface_T.{
            name = c_string("WebM Project VP8 Encoder v1.17.0"),
            abi_version = 5,
            caps = cast,no_check(Codec_Caps_T) ((cast,no_check(s32) ((0x2 | 0x10000))) | 0x20000),
            init = vp8e_init,
            destroy = cast,no_check(#type (_: *Codec_Alg_Priv_T) -> Codec_Err_T) vp8e_destroy,
            ctrl_maps = VP8E_CTF_MAPS.data,
            dec = Codec_Dec_Iface.{peek_si = null, get_si = null, decode = null, get_frame = null, set_fb_fn = null},
            enc =
                Codec_Enc_Iface.{cfg_map_count = 1, cfg_maps = VP8E_USAGE_CFG_MAP.data, encode = cast,no_check(#type (
                    _: *Codec_Alg_Priv_T,
                    _: *Image_T,
                    _: Codec_Pts_T,
                    _: u64,
                    _: Enc_Frame_Flags_T,
                    _: Enc_Deadline_T
                ) -> Codec_Err_T) vp8e_encode, get_cx_data = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Codec_Iter_T) -> *Codec_Cx_Pkt_T) vp8e_get_cxdata, cfg_set = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Codec_Enc_Cfg_T) -> Codec_Err_T) vp8e_set_config, get_glob_hdrs = null, get_preview = cast,no_check(#type (_: *Codec_Alg_Priv_T) -> *Image_T) vp8e_get_preview, mr_get_mem_loc = vp8e_mr_alloc_mem, mr_free_mem_loc = vp8e_mr_free_mem}
        };
    atomic_store(*globals_initialization_state_for_vp8_cx_iface, 2);
}

setjmp_2 :: (env: *Jmp_Buf_Tag) -> s32 #foreign System_Library_libc_so_6 "_setjmp";

sem_wait :: (sem: *Sem_T) -> s32 #foreign System_Library_libc_so_6;

Rational64_T :: Rational64;

VP8_COMP :: struct {
    y1quant: [128] [16] s16 #align 16;
    y1quant_shift: [128] [16] s16 #align 1;
    y1zbin: [128] [16] s16 #align 1;
    y1round: [128] [16] s16 #align 1;
    y2quant: [128] [16] s16 #align 1;
    y2quant_shift: [128] [16] s16 #align 1;
    y2zbin: [128] [16] s16 #align 1;
    y2round: [128] [16] s16 #align 1;
    u_vquant: [128] [16] s16 #align 1;
    u_vquant_shift: [128] [16] s16 #align 1;
    u_vzbin: [128] [16] s16 #align 1;
    u_vround: [128] [16] s16 #align 1;
    zrun_zbin_boost_y1: [128] [16] s16 #align 1;
    zrun_zbin_boost_y2: [128] [16] s16 #align 1;
    zrun_zbin_boost_uv: [128] [16] s16 #align 1;
    y1quant_fast: [128] [16] s16 #align 1;
    y2quant_fast: [128] [16] s16 #align 1;
    u_vquant_fast: [128] [16] s16 #align 1;
    mb: MACROBLOCK_in_block #align 1;
    common: VP8_COMMON #align 1;
    bc: [9] Vp8_Writer_in_treewriter #align 1;
    oxcf: VP8_CONFIG #align 1;
    lookahead: *Lookahead_Ctx #align 1;
    source_2: *Lookahead_Entry #align 1;
    alt_ref_source: *Lookahead_Entry #align 1;
    last_source: *Lookahead_Entry #align 1;
    source: *YV12_BUFFER_CONFIG #align 1;
    un_scaled_source: *YV12_BUFFER_CONFIG #align 1;
    scaled_source: YV12_BUFFER_CONFIG #align 1;
    last_frame_unscaled_source: *YV12_BUFFER_CONFIG #align 1;
    frames_till_alt_ref_frame: u32 #align 1;
    source_alt_ref_pending: s32 #align 1;
    source_alt_ref_active: s32 #align 1;
    is_src_frame_alt_ref: s32 #align 1;
    gold_is_last: s32 #align 1;
    alt_is_last: s32 #align 1;
    gold_is_alt: s32 #align 1;
    layout_padding_0: [4] u8 #align 1;
    pick_lf_lvl_frame: YV12_BUFFER_CONFIG #align 1;
    tok: *TOKENEXTRA #align 1;
    tok_count: u32 #align 1;
    frames_since_key: u32 #align 1;
    key_frame_frequency: u32 #align 1;
    this_key_frame_forced: u32 #align 1;
    next_key_frame_forced: u32 #align 1;
    ambient_err: s32 #align 1;
    mode_check_freq: [20] u32 #align 1;
    rd_baseline_thresh: [20] s32 #align 1;
    rdmult: s32 #align 1;
    rddiv: s32 #align 1;
    coding_context: CODING_CONTEXT #align 1;
    last_prediction_error: s64 #align 1;
    last_intra_error: s64 #align 1;
    this_frame_target: s32 #align 1;
    projected_frame_size: s32 #align 1;
    last_q: [2] s32 #align 1;
    rate_correction_factor: float64 #align 1;
    key_frame_rate_correction_factor: float64 #align 1;
    gf_rate_correction_factor: float64 #align 1;
    frames_since_golden: s32 #align 1;
    frames_till_gf_update_due: s32 #align 1;
    current_gf_interval: s32 #align 1;
    gf_overspend_bits: s32 #align 1;
    non_gf_bitrate_adjustment: s32 #align 1;
    kf_overspend_bits: s32 #align 1;
    kf_bitrate_adjustment: s32 #align 1;
    max_gf_interval: s32 #align 1;
    baseline_gf_interval: s32 #align 1;
    active_arnr_frames: s32 #align 1;
    key_frame_count: s64 #align 1;
    prior_key_frame_distance: [5] s32 #align 1;
    per_frame_bandwidth: s32 #align 1;
    av_per_frame_bandwidth: s32 #align 1;
    min_frame_bandwidth: s32 #align 1;
    inter_frame_target: s32 #align 1;
    layout_padding_1: [4] u8 #align 1;
    output_framerate: float64 #align 1;
    last_time_stamp_seen: s64 #align 1;
    last_end_time_stamp_seen: s64 #align 1;
    first_time_stamp_ever: s64 #align 1;
    ni_av_qi: s32 #align 1;
    ni_tot_qi: s32 #align 1;
    ni_frames: s32 #align 1;
    avg_frame_qindex: s32 #align 1;
    total_byte_count: s64 #align 1;
    buffered_mode: s32 #align 1;
    layout_padding_2: [4] u8 #align 1;
    framerate: float64 #align 1;
    ref_framerate: float64 #align 1;
    buffer_level: s64 #align 1;
    bits_off_target: s64 #align 1;
    rolling_target_bits: s32 #align 1;
    rolling_actual_bits: s32 #align 1;
    long_rolling_target_bits: s32 #align 1;
    long_rolling_actual_bits: s32 #align 1;
    total_actual_bits: s64 #align 1;
    total_target_vs_actual: s64 #align 1;
    worst_quality: s32 #align 1;
    active_worst_quality: s32 #align 1;
    best_quality: s32 #align 1;
    active_best_quality: s32 #align 1;
    cq_target_quality: s32 #align 1;
    drop_frames_allowed: s32 #align 1;
    drop_frame: s32 #align 1;
    frame_coef_probs: [4] [8] [3] [11] Vp8_Prob #align 1;
    update_probs: [4] [8] [3] [11] s8 #align 1;
    frame_branch_ct: [4] [8] [3] [11] [2] u32 #align 1;
    gfu_boost: s32 #align 1;
    kf_boost: s32 #align 1;
    last_boost: s32 #align 1;
    target_bandwidth: s32 #align 1;
    layout_padding_3: [4] u8 #align 1;
    output_pkt_list: *Codec_Pkt_List #align 1;
    decimation_factor: s32 #align 1;
    decimation_count: s32 #align 1;
    avg_encode_time: s32 #align 1;
    avg_pick_mode_time: s32 #align 1;
    speed: s32 #align 1;
    compressor_speed: s32 #align 1;
    auto_gold: s32 #align 1;
    auto_adjust_gold_quantizer: s32 #align 1;
    auto_worst_q: s32 #align 1;
    cpu_used: s32 #align 1;
    pass: s32 #align 1;
    prob_intra_coded: s32 #align 1;
    prob_last_coded: s32 #align 1;
    prob_gf_coded: s32 #align 1;
    prob_skip_false: s32 #align 1;
    last_skip_false_probs: [3] s32 #align 1;
    last_skip_probs_q: [3] s32 #align 1;
    recent_ref_frame_usage: [4] s32 #align 1;
    this_frame_percent_intra: s32 #align 1;
    last_frame_percent_intra: s32 #align 1;
    ref_frame_flags: s32 #align 1;
    sf: SPEED_FEATURES #align 1;
    zeromv_count: s32 #align 1;
    lf_zeromv_pct: s32 #align 1;
    layout_padding_4: [4] u8 #align 1;
    skin_map: *u8 #align 1;
    segmentation_map: *u8 #align 1;
    segment_feature_data: [2] [4] s8 #align 1;
    segment_encode_breakout: [4] u32 #align 1;
    active_map: *u8 #align 1;
    active_map_enabled: u32 #align 1;
    cyclic_refresh_mode_enabled: s32 #align 1;
    cyclic_refresh_mode_max_mbs_perframe: s32 #align 1;
    cyclic_refresh_mode_index: s32 #align 1;
    cyclic_refresh_q: s32 #align 1;
    layout_padding_5: [4] u8 #align 1;
    cyclic_refresh_map: *s8 #align 1;
    consec_zero_last: *u8 #align 1;
    consec_zero_last_mvbias: *u8 #align 1;
    temporal_pattern_counter: u32 #align 1;
    temporal_layer_id: s32 #align 1;
    mse_source_denoised: s32 #align 1;
    force_maxqp: s32 #align 1;
    frames_since_last_drop_overshoot: s32 #align 1;
    last_pred_err_mb: s32 #align 1;
    gf_update_onepass_cbr: s32 #align 1;
    gf_interval_onepass_cbr: s32 #align 1;
    gf_noboost_onepass_cbr: s32 #align 1;
    layout_padding_6: [4] u8 #align 1;
    mt_current_mb_col: *Atomic_Int #align 1;
    mt_current_mb_col_size: s32 #align 1;
    mt_sync_range: s32 #align 1;
    b_multi_threaded: Atomic_Int #align 1;
    encoding_thread_count: s32 #align 1;
    b_lpf_running: s32 #align 1;
    layout_padding_7: [4] u8 #align 1;
    h_encoding_thread: *Pthread_T #align 1;
    h_filter_thread: Pthread_T #align 1;
    mb_row_ei: *MB_ROW_COMP #align 1;
    en_thread_data: *ENCODETHREAD_DATA #align 1;
    lpf_thread_data: LPFTHREAD_DATA #align 1;
    h_event_start_encoding: *Sem_T #align 1;
    h_event_end_encoding: *Sem_T #align 1;
    h_event_start_lpf: Sem_T #align 1;
    h_event_end_lpf: Sem_T #align 1;
    tplist: *TOKENLIST #align 1;
    partition_sz: [9] u32 #align 1;
    layout_padding_8: [4] u8 #align 1;
    partition_d: [9] *u8 #align 1;
    partition_d_end: [9] *u8 #align 1;
    find_fractional_mv_step: Fractional_Mv_Step_Fp #align 1;
    refining_search_sad: Vp8_Refining_Search_Fn_T #align 1;
    diamond_search_sad: Vp8_Diamond_Search_Fn_T #align 1;
    fn_ptr: [5] Vp8_Variance_Fn_Ptr_T #align 1;
    base_skip_false_prob: [128] s32 #align 1;
    lfc_n: FRAME_CONTEXT_in_onyxc_int #align 1;
    lfc_a: FRAME_CONTEXT_in_onyxc_int #align 1;
    lfc_g: FRAME_CONTEXT_in_onyxc_int #align 1;
    layout_padding_9: [5] u8 #align 1;
    twopass: Twopass_Rc #align 1;
    alt_ref_buffer: YV12_BUFFER_CONFIG #align 1;
    frames: [25] *YV12_BUFFER_CONFIG #align 1;
    fixed_divide: [512] s32 #align 1;
    b_calculate_psnr: s32 #align 1;
    activity_avg: u32 #align 1;
    mb_activity_map: *u32 #align 1;
    gf_active_flags: *u8 #align 1;
    gf_active_count: s32 #align 1;
    output_partition: s32 #align 1;
    lfmv: *Int_Mv_in_mv #align 1;
    lf_ref_frame_sign_bias: *s32 #align 1;
    lf_ref_frame: *s32 #align 1;
    force_next_frame_intra: s32 #align 1;
    droppable: s32 #align 1;
    initial_width: s32 #align 1;
    initial_height: s32 #align 1;
    denoiser: VP8_DENOISER #align 1;
    current_layer: u32 #align 1;
    layout_padding_10: [4] u8 #align 1;
    layer_context: [5] LAYER_CONTEXT #align 1;
    frames_in_layer: [5] s64 #align 1;
    bytes_in_layer: [5] s64 #align 1;
    sum_psnr: [5] float64 #align 1;
    sum_psnr_p: [5] float64 #align 1;
    total_error2: [5] float64 #align 1;
    total_error2_p: [5] float64 #align 1;
    sum_ssim: [5] float64 #align 1;
    sum_weights: [5] float64 #align 1;
    total_ssimg_y_in_layer: [5] float64 #align 1;
    total_ssimg_u_in_layer: [5] float64 #align 1;
    total_ssimg_v_in_layer: [5] float64 #align 1;
    total_ssimg_all_in_layer: [5] float64 #align 1;
    current_ref_frames: [4] u32 #align 1;
    closest_reference_frame: MV_REFERENCE_FRAME_in_alloccommon #align 1;
    rd_costs: Rd_Costs_Struct #align 1;
    use_roi_static_threshold: s32 #align 1;
    ext_refresh_frame_flags_pending: s32 #align 1;
    rt_always_update_correction_factor: s32 #align 1;
    rt_drop_recode_on_overshoot: s32 #align 1;
    layout_padding_11: [12] u8 #align 1;
} #no_padding;

MODE :: u32;
MODE_REALTIME : s32 : 0;
MODE_GOODQUALITY : s32 : 1;
MODE_BESTQUALITY : s32 : 2;
MODE_FIRSTPASS : s32 : 3;
MODE_SECONDPASS : s32 : 4;
MODE_SECONDPASS_BEST : s32 : 5;

END_USAGE :: u32;
USAGE_LOCAL_FILE_PLAYBACK : s32 : 0;
USAGE_STREAM_FROM_SERVER : s32 : 1;
USAGE_CONSTRAINED_QUALITY : s32 : 2;
USAGE_CONSTANT_QUALITY : s32 : 3;

Vp8e_Token_Partitions :: u32;
VP8_ONE_TOKENPARTITION : s32 : 0;
VP8_TWO_TOKENPARTITION : s32 : 1;
VP8_FOUR_TOKENPARTITION : s32 : 2;
VP8_EIGHT_TOKENPARTITION : s32 : 3;

FRAMETYPE_FLAGS :: u32;
FRAMEFLAGS_KEY : s32 : 1;
FRAMEFLAGS_GOLDEN : s32 : 2;
FRAMEFLAGS_ALTREF : s32 : 4;

Scaling_Mode_T :: Scaling_Mode;

SCALING_MODE :: Scaling_Mode_1d;

Active_Map_T :: Active_Map;

Roi_Map_T :: Roi_Map;

Svc_Layer_Id_T :: Svc_Layer_Id;

Svc_Ref_Frame_Config_T :: Svc_Ref_Frame_Config;

Svc_Frame_Drop_T :: Svc_Frame_Drop;

Svc_Spatial_Layer_Sync_T :: Svc_Spatial_Layer_Sync;

Rc_Funcs_T :: Rc_Funcs;

Scaling_Mode_1d :: u32;
VP8E_NORMAL : s32 : 0;
VP8E_FOURFIVE : s32 : 1;
VP8E_THREEFIVE : s32 : 2;
VP8E_ONETWO : s32 : 3;

BOOL_CODER :: Vp8_Writer;

Vp8_Writer_in_treewriter :: BOOL_CODER;

Vp8_Com_Control_Id :: u32;
VP8_SET_REFERENCE : s32 : 1;
VP8_COPY_REFERENCE : s32 : 2;
VP8_SET_POSTPROC : s32 : 3;
VP9_GET_REFERENCE : s32 : 128;
VP8_COMMON_CTRL_ID_MAX : s32 : 129;
VP8_DECODER_CTRL_ID_START : s32 : 256;

Vp8e_Enc_Control_Id :: u32;
VP8E_SET_ROI_MAP : s32 : 8;
VP8E_SET_ACTIVEMAP : s32 : 9;
VP8E_SET_SCALEMODE : s32 : 11;
VP8E_SET_CPUUSED : s32 : 13;
VP8E_SET_ENABLEAUTOALTREF : s32 : 14;
VP8E_SET_NOISE_SENSITIVITY : s32 : 15;
VP8E_SET_SHARPNESS : s32 : 16;
VP8E_SET_STATIC_THRESHOLD : s32 : 17;
VP8E_SET_TOKEN_PARTITIONS : s32 : 18;
VP8E_GET_LAST_QUANTIZER : s32 : 19;
VP8E_GET_LAST_QUANTIZER_64 : s32 : 20;
VP8E_SET_ARNR_MAXFRAMES : s32 : 21;
VP8E_SET_ARNR_STRENGTH : s32 : 22;
VP8E_SET_ARNR_TYPE : s32 : 23;
VP8E_SET_TUNING : s32 : 24;
VP8E_SET_CQ_LEVEL : s32 : 25;
VP8E_SET_MAX_INTRA_BITRATE_PCT : s32 : 26;
VP8E_SET_FRAME_FLAGS : s32 : 27;
VP9E_SET_MAX_INTER_BITRATE_PCT : s32 : 28;
VP9E_SET_GF_CBR_BOOST_PCT : s32 : 29;
VP8E_SET_TEMPORAL_LAYER_ID : s32 : 30;
VP8E_SET_SCREEN_CONTENT_MODE : s32 : 31;
VP9E_SET_LOSSLESS : s32 : 32;
VP9E_SET_TILE_COLUMNS : s32 : 33;
VP9E_SET_TILE_ROWS : s32 : 34;
VP9E_SET_FRAME_PARALLEL_DECODING : s32 : 35;
VP9E_SET_AQ_MODE : s32 : 36;
VP9E_SET_FRAME_PERIODIC_BOOST : s32 : 37;
VP9E_SET_NOISE_SENSITIVITY : s32 : 38;
VP9E_SET_SVC : s32 : 39;
VP9E_SET_ROI_MAP : s32 : 40;
VP9E_SET_SVC_PARAMETERS : s32 : 41;
VP9E_SET_SVC_LAYER_ID : s32 : 42;
VP9E_SET_TUNE_CONTENT : s32 : 43;
VP9E_GET_SVC_LAYER_ID : s32 : 44;
VP9E_REGISTER_CX_CALLBACK : s32 : 45;
VP9E_SET_COLOR_SPACE : s32 : 46;
VP9E_SET_MIN_GF_INTERVAL : s32 : 48;
VP9E_SET_MAX_GF_INTERVAL : s32 : 49;
VP9E_GET_ACTIVEMAP : s32 : 50;
VP9E_SET_COLOR_RANGE : s32 : 51;
VP9E_SET_SVC_REF_FRAME_CONFIG : s32 : 52;
VP9E_SET_RENDER_SIZE : s32 : 53;
VP9E_SET_TARGET_LEVEL : s32 : 54;
VP9E_SET_ROW_MT : s32 : 55;
VP9E_GET_LEVEL : s32 : 56;
VP9E_SET_ALT_REF_AQ : s32 : 57;
VP8E_SET_GF_CBR_BOOST_PCT : s32 : 58;
VP9E_ENABLE_MOTION_VECTOR_UNIT_TEST : s32 : 59;
VP9E_SET_SVC_INTER_LAYER_PRED : s32 : 60;
VP9E_SET_SVC_FRAME_DROP_LAYER : s32 : 61;
VP9E_GET_SVC_REF_FRAME_CONFIG : s32 : 62;
VP9E_SET_SVC_GF_TEMPORAL_REF : s32 : 63;
VP9E_SET_SVC_SPATIAL_LAYER_SYNC : s32 : 64;
VP9E_SET_TPL : s32 : 65;
VP9E_SET_POSTENCODE_DROP : s32 : 66;
VP9E_SET_DELTA_Q_UV : s32 : 67;
VP9E_SET_DISABLE_OVERSHOOT_MAXQ_CBR : s32 : 68;
VP9E_SET_DISABLE_LOOPFILTER : s32 : 69;
VP9E_SET_EXTERNAL_RATE_CONTROL : s32 : 70;
VP9E_SET_RTC_EXTERNAL_RATECTRL : s32 : 71;
VP9E_GET_LOOPFILTER_LEVEL : s32 : 72;
VP9E_GET_LAST_QUANTIZER_SVC_LAYERS : s32 : 73;
VP8E_SET_RTC_EXTERNAL_RATECTRL : s32 : 74;
VP9E_SET_QUANTIZER_ONE_PASS : s32 : 75;
VP9E_SET_KEY_FRAME_FILTERING : s32 : 76;
VP9E_SET_VALIDATE_HBD_INPUT : s32 : 77;

Rational64 :: struct {
    num: s64;
    den: s32;
}

VP8_CONFIG :: struct {
    version: s32;
    width: s32;
    height: s32;
    timebase: Rational;
    target_bandwidth: u32;
    noise_sensitivity: s32;
    sharpness: s32;
    cpu_used: s32;
    rc_max_intra_bitrate_pct: u32;
    gf_cbr_boost_pct: u32;
    screen_content_mode: u32;
    mode: s32;
    auto_key: s32;
    key_freq: s32;
    allow_lag: s32;
    lag_in_frames: s32;
    end_usage: s32;
    under_shoot_pct: s32;
    over_shoot_pct: s32;
    starting_buffer_level: s64;
    optimal_buffer_level: s64;
    maximum_buffer_size: s64;
    starting_buffer_level_in_ms: s64;
    optimal_buffer_level_in_ms: s64;
    maximum_buffer_size_in_ms: s64;
    fixed_q: s32;
    worst_allowed_q: s32;
    best_allowed_q: s32;
    cq_level: s32;
    allow_spatial_resampling: s32;
    resample_down_water_mark: s32;
    resample_up_water_mark: s32;
    allow_df: s32;
    drop_frames_water_mark: s32;
    two_pass_vbrbias: s32;
    two_pass_vbrmin_section: s32;
    two_pass_vbrmax_section: s32;
    play_alternate: s32;
    alt_freq: s32;
    alt_q: s32;
    key_q: s32;
    gold_q: s32;
    multi_threaded: s32;
    token_partitions: s32;
    encode_breakout: s32;
    error_resilient_mode: u32;
    arnr_max_frames: s32;
    arnr_strength: s32;
    arnr_type: s32;
    two_pass_stats_in: Fixed_Buf_T;
    output_pkt_list: *Codec_Pkt_List;
    tuning: Vp8e_Tuning;
    number_of_layers: u32;
    target_bitrate: [16] u32;
    rate_decimator: [16] u32;
    periodicity: u32;
    layer_id: [16] u32;
}

MACROBLOCK_in_block :: Macroblock_in_block;

Lookahead_Entry :: struct {
    img: YV12_BUFFER_CONFIG;
    ts_start: s64;
    ts_end: s64;
    flags: u32;
}

BLOCK :: Block_in_block;

Vp8_Variance_Fn_Ptr_T :: Variance_Vtable;

Fractional_Mv_Step_Fp :: #type (
    _: *MACROBLOCK_in_block,
    _: *BLOCK,
    _: *BLOCKD,
    _: *Int_Mv_in_mv,
    _: *Int_Mv_in_mv,
    _: s32,
    _: *Vp8_Variance_Fn_Ptr_T,
    _: **s32,
    _: *s32,
    _: *u32
) -> s32;

Vp8_Refining_Search_Fn_T :: #type (
    _: *MACROBLOCK_in_block,
    _: *BLOCK,
    _: *BLOCKD,
    _: *Int_Mv_in_mv,
    _: s32,
    _: s32,
    _: *Vp8_Variance_Fn_Ptr_T,
    _: **s32,
    _: *Int_Mv_in_mv
) -> s32;

Vp8_Diamond_Search_Fn_T :: #type (
    _: *MACROBLOCK_in_block,
    _: *BLOCK,
    _: *BLOCKD,
    _: *Int_Mv_in_mv,
    _: *Int_Mv_in_mv,
    _: s32,
    _: s32,
    _: *s32,
    _: *Vp8_Variance_Fn_Ptr_T,
    _: **s32,
    _: *Int_Mv_in_mv
) -> s32;

Twopass_Rc :: struct {
    section_intra_rating: u32;
    section_max_qfactor: float64;
    next_iiratio: u32;
    this_iiratio: u32;
    total_stats: FIRSTPASS_STATS;
    this_frame_stats: FIRSTPASS_STATS;
    stats_in: *FIRSTPASS_STATS;
    stats_in_end: *FIRSTPASS_STATS;
    stats_in_start: *FIRSTPASS_STATS;
    total_left_stats: FIRSTPASS_STATS;
    first_pass_done: s32;
    bits_left: s64;
    clip_bits_total: s64;
    avg_iiratio: float64;
    modified_error_total: float64;
    modified_error_used: float64;
    modified_error_left: float64;
    kf_intra_err_min: float64;
    gf_intra_err_min: float64;
    frames_to_key: s32;
    maxq_max_limit: s32;
    maxq_min_limit: s32;
    gf_decay_rate: s32;
    static_scene_max_gf_interval: s32;
    kf_bits: s32;
    gf_group_error_left: s32;
    kf_group_bits: s64;
    kf_group_error_left: s64;
    gf_group_bits: s64;
    gf_bits: s32;
    alt_extra_bits: s32;
    est_max_qcorrection_factor: float64;
}

VP8_DENOISER :: Vp8_Denoiser;

Rd_Costs_Struct :: struct {
    mvcosts: [2] [2048] s32;
    mvsadcosts: [2] [512] s32;
    mbmode_cost: [2] [10] s32;
    intra_uv_mode_cost: [2] [10] s32;
    bmode_costs: [10] [10] [10] s32;
    inter_bmode_costs: [14] s32;
    token_costs: [4] [8] [3] [12] s32;
}

Vp8e_Tuning :: u32;
VP8_TUNE_PSNR : s32 : 0;
VP8_TUNE_SSIM : s32 : 1;

Vp8_Ppflags_T :: struct {
    post_proc_flag: s32;
    deblocking_level: s32;
    noise_level: s32;
    display_ref_frame_flag: s32;
    display_mb_modes_flag: s32;
    display_b_modes_flag: s32;
    display_mv_flag: s32;
}

FIRSTPASS_STATS :: struct {
    frame: float64;
    intra_error: float64;
    coded_error: float64;
    ssim_weighted_pred_err: float64;
    pcnt_inter: float64;
    pcnt_motion: float64;
    pcnt_second_ref: float64;
    pcnt_neutral: float64;
    m_vr: float64;
    mvr_abs: float64;
    m_vc: float64;
    mvc_abs: float64;
    m_vrv: float64;
    m_vcv: float64;
    mv_in_out_count: float64;
    new_mv_count: float64;
    duration: float64;
    count: float64;
}

Scaling_Mode :: struct {
    h_scaling_mode: SCALING_MODE;
    v_scaling_mode: SCALING_MODE;
}

Active_Map :: struct {
    active_map: *u8;
    rows: u32;
    cols: u32;
}

Roi_Map :: struct {
    enabled: u8;
    roi_map: *u8;
    rows: u32;
    cols: u32;
    delta_q: [8] s32;
    delta_lf: [8] s32;
    skip: [8] s32;
    ref_frame: [8] s32;
    static_threshold: [4] u32;
}

Svc_Layer_Id :: struct {
    spatial_layer_id: s32;
    temporal_layer_id: s32;
    temporal_layer_id_per_spatial: [5] s32;
}

Svc_Ref_Frame_Config :: struct {
    lst_fb_idx: [5] s32;
    gld_fb_idx: [5] s32;
    alt_fb_idx: [5] s32;
    update_buffer_slot: [5] s32;
    update_last: [5] s32;
    update_golden: [5] s32;
    update_alt_ref: [5] s32;
    reference_last: [5] s32;
    reference_golden: [5] s32;
    reference_alt_ref: [5] s32;
    duration: [5] s64;
}

Svc_Frame_Drop :: struct {
    framedrop_thresh: [5] s32;
    framedrop_mode: SVC_LAYER_DROP_MODE;
    max_consec_drop: s32;
}

Svc_Spatial_Layer_Sync :: struct {
    spatial_layer_sync: [5] s32;
    base_layer_intra_only: s32;
}

Rc_Funcs :: struct {
    rc_type: Rc_Type_T;
    create_model: Rc_Create_Model_Cb_Fn_T;
    send_firstpass_stats: Rc_Send_Firstpass_Stats_Cb_Fn_T;
    send_tpl_gop_stats: Rc_Send_Tpl_Gop_Stats_Cb_Fn_T;
    get_encodeframe_decision: Rc_Get_Encodeframe_Decision_Cb_Fn_T;
    update_encodeframe_result: Rc_Update_Encodeframe_Result_Cb_Fn_T;
    get_key_frame_decision: Rc_Get_Key_Frame_Decision_Cb_Fn_T;
    get_gop_decision: Rc_Get_Gop_Decision_Cb_Fn_T;
    get_frame_rdmult: Rc_Get_Frame_Rdmult_Cb_Fn_T;
    delete_model: Rc_Delete_Model_Cb_Fn_T;
    rate_ctrl_log_path: *s8;
    priv: *void;
}

Vp8_Writer :: struct {
    lowvalue: u32;
    range: u32;
    count: s32;
    pos: u32;
    buffer: *u8;
    buffer_end: *u8;
    error: *Internal_Error_Info;
}

Sem_T :: union {
    size: [32] s8;
    align: s64;
}

Atomic_Int :: struct {
    value: s32;
}

Macroblock_in_block :: struct {
    src_diff: [400] s16 #align 16;
    coeff: [400] s16 #align 1;
    thismb: [256] u8 #align 1;
    thismb_ptr: *u8 #align 1;
    block: [25] BLOCK #align 1;
    src: YV12_BUFFER_CONFIG #align 1;
    e_mbd: MACROBLOCKD_in_blockd #align 1;
    partition_info: *PARTITION_INFO #align 1;
    pi: *PARTITION_INFO #align 1;
    pip: *PARTITION_INFO #align 1;
    ref_frame_cost: [4] s32 #align 1;
    ss: *Search_Site #align 1;
    ss_count: s32 #align 1;
    searches_per_step: s32 #align 1;
    errorperbit: s32 #align 1;
    sadperbit16: s32 #align 1;
    sadperbit4: s32 #align 1;
    rddiv: s32 #align 1;
    rdmult: s32 #align 1;
    layout_padding_0: [4] u8 #align 1;
    mb_activity_ptr: *u32 #align 1;
    mb_norm_activity_ptr: *s32 #align 1;
    act_zbin_adj: s32 #align 1;
    last_act_zbin_adj: s32 #align 1;
    mvcost: [2] *s32 #align 1;
    mvsadcost: [2] *s32 #align 1;
    mbmode_cost: *[10] s32 #align 1;
    intra_uv_mode_cost: *[10] s32 #align 1;
    bmode_costs: *[10] [10] s32 #align 1;
    inter_bmode_costs: *s32 #align 1;
    token_costs: *[8] [3] [12] s32 #align 1;
    mv_col_min: s32 #align 1;
    mv_col_max: s32 #align 1;
    mv_row_min: s32 #align 1;
    mv_row_max: s32 #align 1;
    skip: s32 #align 1;
    encode_breakout: u32 #align 1;
    gf_active_ptr: *s8 #align 1;
    active_ptr: *u8 #align 1;
    mvc: *MV_CONTEXT #align 1;
    optimize: s32 #align 1;
    q_index: s32 #align 1;
    is_skin: s32 #align 1;
    denoise_zeromv: s32 #align 1;
    increase_denoising: s32 #align 1;
    best_sse_inter_mode: MB_PREDICTION_MODE #align 1;
    best_sse_mv: Int_Mv_in_mv #align 1;
    best_reference_frame: MV_REFERENCE_FRAME_in_alloccommon #align 1;
    best_zeromv_reference_frame: MV_REFERENCE_FRAME_in_alloccommon #align 1;
    need_to_clamp_best_mvs: u8 #align 1;
    layout_padding_1: [3] u8 #align 1;
    skip_true_count: s32 #align 1;
    coef_counts: [4] [8] [3] [12] u32 #align 1;
    m_vcount: [2] [2047] u32 #align 1;
    ymode_count: [5] s32 #align 1;
    uv_mode_count: [4] s32 #align 1;
    prediction_error: s64 #align 1;
    intra_error: s64 #align 1;
    count_mb_ref_frame_usage: [4] s32 #align 1;
    rd_thresh_mult: [20] s32 #align 1;
    rd_threshes: [20] s32 #align 1;
    mbs_tested_so_far: u32 #align 1;
    mode_test_hit_counts: [20] u32 #align 1;
    zbin_mode_boost_enabled: s32 #align 1;
    zbin_mode_boost: s32 #align 1;
    last_zbin_mode_boost: s32 #align 1;
    last_zbin_over_quant: s32 #align 1;
    zbin_over_quant: s32 #align 1;
    error_bins: [1024] s32 #align 1;
    short_fdct4x4: #type (_: *s16, _: *s16, _: s32);
    short_fdct8x4: #type (_: *s16, _: *s16, _: s32);
    short_walsh4x4: #type (_: *s16, _: *s16, _: s32);
    quantize_b: #type (_: *BLOCK, _: *BLOCKD);
    mbs_zero_last_dot_suppress: u32 #align 1;
    zero_last_dot_suppress: s32 #align 1;
    layout_padding_2: [8] u8 #align 1;
} #no_padding;

TOKENEXTRA :: struct {
    context_tree: *Vp8_Prob;
    extra: s16;
    token: u8;
    skip_eob_node: u8;
}

CODING_CONTEXT :: struct {
    kf_indicated: s32;
    frames_since_key: u32;
    frames_since_golden: u32;
    filter_level: s32;
    frames_till_gf_update_due: s32;
    recent_ref_frame_usage: [4] s32;
    mvc: [2] MV_CONTEXT;
    mvcosts: [2] [2048] s32;
    ymode_prob: [4] Vp8_Prob;
    uv_mode_prob: [3] Vp8_Prob;
    kf_ymode_prob: [4] Vp8_Prob;
    kf_uv_mode_prob: [3] Vp8_Prob;
    ymode_count: [5] s32;
    uv_mode_count: [4] s32;
    count_mb_ref_frame_usage: [4] s32;
    this_frame_percent_intra: s32;
    last_frame_percent_intra: s32;
}

SPEED_FEATURES :: struct {
    rd: s32;
    search_method: SEARCH_METHODS;
    improved_quant: s32;
    improved_dct: s32;
    auto_filter: s32;
    recode_loop: s32;
    iterative_sub_pixel: s32;
    half_pixel_search: s32;
    quarter_pixel_search: s32;
    thresh_mult: [20] s32;
    max_step_search_steps: s32;
    first_step: s32;
    optimize_coefficients: s32;
    use_fastquant_for_pick: s32;
    no_skip_block4x4_search: s32;
    improved_mv_pred: s32;
}

MB_ROW_COMP :: struct {
    mb: MACROBLOCK_in_block #align 16;
    segment_counts: [4] s32 #align 1;
    totalrate: s32 #align 1;
    layout_padding_0: [12] u8 #align 1;
} #no_padding;

ENCODETHREAD_DATA :: struct {
    ithread: s32;
    ptr1: *void;
    ptr2: *void;
}

LPFTHREAD_DATA :: struct {
    ithread: s32;
    ptr1: *void;
}

TOKENLIST :: struct {
    start: *TOKENEXTRA;
    stop: *TOKENEXTRA;
}

Block_in_block :: struct {
    src_diff: *s16;
    coeff: *s16;
    quant: *s16;
    quant_fast: *s16;
    quant_shift: *s16;
    zbin: *s16;
    zrun_zbin_boost: *s16;
    round: *s16;
    zbin_extra: s16;
    base_src: **u8;
    src: s32;
    src_stride: s32;
}

Variance_Vtable :: struct {
    sdf: Sad_Fn_T;
    vf: Variance_Fn_T;
    svf: Subpixvariance_Fn_T;
    sdx4df: Sad_Multi_D_Fn_T;
}

Vp8_Denoiser :: struct {
    yv12_running_avg: [4] YV12_BUFFER_CONFIG;
    yv12_mc_running_avg: YV12_BUFFER_CONFIG;
    yv12_last_source: YV12_BUFFER_CONFIG;
    denoise_state: *u8;
    num_mb_cols: s32;
    denoiser_mode: s32;
    threshold_aggressive_mode: s32;
    nmse_source_diff: s32;
    nmse_source_diff_count: s32;
    qp_avg: s32;
    qp_threshold_up: s32;
    qp_threshold_down: s32;
    bitrate_threshold: s32;
    denoise_pars: Denoise_Params;
}

LAYER_CONTEXT :: struct {
    framerate: float64;
    target_bandwidth: s32;
    starting_buffer_level: s64;
    optimal_buffer_level: s64;
    maximum_buffer_size: s64;
    starting_buffer_level_in_ms: s64;
    optimal_buffer_level_in_ms: s64;
    maximum_buffer_size_in_ms: s64;
    avg_frame_size_for_layer: s32;
    buffer_level: s64;
    bits_off_target: s64;
    total_actual_bits: s64;
    total_target_vs_actual: s64;
    worst_quality: s32;
    active_worst_quality: s32;
    best_quality: s32;
    active_best_quality: s32;
    ni_av_qi: s32;
    ni_tot_qi: s32;
    ni_frames: s32;
    avg_frame_qindex: s32;
    rate_correction_factor: float64;
    key_frame_rate_correction_factor: float64;
    gf_rate_correction_factor: float64;
    zbin_over_quant: s32;
    inter_frame_target: s32;
    total_byte_count: s64;
    filter_level: s32;
    frames_since_last_drop_overshoot: s32;
    force_maxqp: s32;
    last_frame_percent_intra: s32;
    count_mb_ref_frame_usage: [4] s32;
    last_q: [2] s32;
}

Rc_Type_T :: Rc_Type;

Rc_Config_T :: Rc_Config;

Rc_Model_T :: *void;

Rc_Status_T :: Rc_Status;

Rc_Create_Model_Cb_Fn_T :: #type (_: *void, _: *Rc_Config_T, _: *Rc_Model_T) -> Rc_Status_T;

Rc_Firstpass_Stats_T :: Rc_Firstpass_Stats;

Rc_Send_Firstpass_Stats_Cb_Fn_T :: #type (_: Rc_Model_T, _: *Rc_Firstpass_Stats_T) -> Rc_Status_T;

Rc_Send_Tpl_Gop_Stats_Cb_Fn_T :: #type (_: Rc_Model_T, _: *Tpl_Gop_Stats) -> Rc_Status_T;

Rc_Encodeframe_Decision_T :: Rc_Encodeframe_Decision;

Rc_Get_Encodeframe_Decision_Cb_Fn_T :: #type (_: Rc_Model_T, _: s32, _: *Rc_Encodeframe_Decision_T) -> Rc_Status_T;

Rc_Encodeframe_Result_T :: Rc_Encodeframe_Result;

Rc_Update_Encodeframe_Result_Cb_Fn_T :: #type (_: Rc_Model_T, _: *Rc_Encodeframe_Result_T) -> Rc_Status_T;

Rc_Key_Frame_Decision_T :: Rc_Key_Frame_Decision;

Rc_Get_Key_Frame_Decision_Cb_Fn_T :: #type (_: Rc_Model_T, _: *Rc_Key_Frame_Decision_T) -> Rc_Status_T;

Rc_Gop_Decision_T :: Rc_Gop_Decision;

Rc_Get_Gop_Decision_Cb_Fn_T :: #type (_: Rc_Model_T, _: *Rc_Gop_Decision_T) -> Rc_Status_T;

Rc_Encodeframe_Info_T :: Rc_Encodeframe_Info;

Rc_Get_Frame_Rdmult_Cb_Fn_T :: #type (_: Rc_Model_T, _: *Rc_Encodeframe_Info_T, _: *s32) -> Rc_Status_T;

Rc_Delete_Model_Cb_Fn_T :: #type (_: Rc_Model_T) -> Rc_Status_T;

Sad_Fn_T :: #type (_: *u8, _: s32, _: *u8, _: s32) -> u32;

Variance_Fn_T :: #type (_: *u8, _: s32, _: *u8, _: s32, _: *u32) -> u32;

Subpixvariance_Fn_T :: #type (_: *u8, _: s32, _: s32, _: s32, _: *u8, _: s32, _: *u32) -> u32;

Sad_Multi_D_Fn_T :: #type (_: *u8, _: s32, _: **u8, _: s32, _: *u32);

SVC_LAYER_DROP_MODE :: u32;
CONSTRAINED_LAYER_DROP : s32 : 0;
LAYER_DROP : s32 : 1;
FULL_SUPERFRAME_DROP : s32 : 2;
CONSTRAINED_FROM_ABOVE_DROP : s32 : 3;

Rc_Type :: u32;
RC_NONE : s32 : 0;
RC_QP : s32 : 1;
RC_GOP : s32 : 2;
RC_RDMULT : s32 : 4;
RC_GOP_QP : s32 : 3;
RC_GOP_QP_RDMULT : s32 : 7;

Rc_Config :: struct {
    frame_width: s32;
    frame_height: s32;
    show_frame_count: s32;
    max_gf_interval: s32;
    min_gf_interval: s32;
    target_bitrate_kbps: s32;
    frame_rate_num: s32;
    frame_rate_den: s32;
    rc_mode: Ext_Rc_Mode_T;
    overshoot_percent: s32;
    undershoot_percent: s32;
    min_base_q_index: s32;
    max_base_q_index: s32;
    base_qp: s32;
}

Rc_Status :: u32;
RC_OK : s32 : 0;
RC_ERROR : s32 : 1;

Rc_Firstpass_Stats :: struct {
    frame_stats: *Rc_Frame_Stats_T;
    num_frames: s32;
}

Tpl_Gop_Stats :: struct {
    size: s32;
    frame_stats_list: *Tpl_Frame_Stats;
}

Rc_Encodeframe_Decision :: struct {
    q_index: s32;
    rdmult: s32;
    delta_q_uv: s32;
    sb_params_list: *Sb_Params;
}

Rc_Encodeframe_Result :: struct {
    bit_count: s64;
    actual_encoding_qindex: s32;
}

Rc_Key_Frame_Decision :: struct {
    key_frame_show_index: s32;
    key_frame_group_size: s32;
}

Rc_Gop_Decision :: struct {
    gop_coding_frames: s32;
    use_alt_ref: s32;
    use_key_frame: s32;
    update_type: [252] Rc_Frame_Update_Type_T;
    update_ref_index: [252] s32;
    ref_frame_list: [252] Rc_Ref_Frame_T;
}

Rc_Encodeframe_Info :: struct {
    frame_type: s32;
    show_index: s32;
    coding_index: s32;
    gop_index: s32;
    ref_frame_coding_indexes: [3] s32;
    ref_frame_valid_list: [3] s32;
    gop_size: s32;
    use_alt_ref: s32;
}

PARTITION_INFO :: struct {
    count: s32 #align 4;
    bmi: [16] Unnamed_2028 #align 1;
} #no_padding;

Search_Site :: struct {
    mv: MV_in_alloccommon;
    offset: s32;
}

SEARCH_METHODS :: u32;
DIAMOND : s32 : 0;
NSTEP : s32 : 1;
HEX : s32 : 2;

Denoise_Params :: struct {
    scale_sse_thresh: u32;
    scale_motion_thresh: u32;
    scale_increase_filter: u32;
    denoise_mv_bias: u32;
    pickmode_mv_bias: u32;
    qp_thresh: u32;
    consec_zerolast: u32;
    spatial_blur: u32;
}

Ext_Rc_Mode_T :: Ext_Rc_Mode;

Rc_Frame_Stats_T :: Rc_Frame_Stats;

Sb_Params :: Sb_Parameters;

Rc_Frame_Update_Type_T :: Rc_Frame_Update_Type;

Rc_Ref_Frame_T :: Rc_Ref_Frame;

Unnamed_2028 :: struct {
    mode: B_PREDICTION_MODE #align 4;
    mv: Int_Mv_in_mv #align 1;
} #no_padding;

Ext_Rc_Mode :: u32;
RC_QMODE : s32 : 0;
RC_VBR : s32 : 1;
RC_CQ : s32 : 2;

Rc_Frame_Stats :: struct {
    frame: float64;
    weight: float64;
    intra_error: float64;
    coded_error: float64;
    sr_coded_error: float64;
    frame_noise_energy: float64;
    pcnt_inter: float64;
    pcnt_motion: float64;
    pcnt_second_ref: float64;
    pcnt_neutral: float64;
    pcnt_intra_low: float64;
    pcnt_intra_high: float64;
    intra_skip_pct: float64;
    intra_smooth_pct: float64;
    inactive_zone_rows: float64;
    inactive_zone_cols: float64;
    m_vr: float64;
    mvr_abs: float64;
    m_vc: float64;
    mvc_abs: float64;
    m_vrv: float64;
    m_vcv: float64;
    mv_in_out_count: float64;
    duration: float64;
    count: float64;
    new_mv_count: float64;
}

Tpl_Frame_Stats :: struct {
    frame_width: s32;
    frame_height: s32;
    num_blocks: s32;
    block_stats_list: *Tpl_Block_Stats;
}

Sb_Parameters :: struct {
    q_index: s32;
    rdmult: s32;
}

Rc_Frame_Update_Type :: s32;
RC_INVALID_UPDATE_TYPE : s32 : -1;
RC_KF_UPDATE : s32 : 0;
RC_LF_UPDATE : s32 : 1;
RC_GF_UPDATE : s32 : 2;
RC_ARF_UPDATE : s32 : 3;
RC_OVERLAY_UPDATE : s32 : 4;
RC_MID_OVERLAY_UPDATE : s32 : 5;
RC_USE_BUF_FRAME : s32 : 6;

Rc_Ref_Frame :: struct {
    index: [4] s32;
    name: [4] Rc_Ref_Name_T;
}

Rc_Ref_Name_T :: Rc_Ref_Name;

Tpl_Block_Stats :: struct {
    row: s16;
    col: s16;
    intra_cost: s64;
    inter_cost: s64;
    mv_r: s16;
    mv_c: s16;
    srcrf_rate: s64;
    srcrf_dist: s64;
    pred_error: s64;
    inter_pred_err: s64;
    intra_pred_err: s64;
    ref_frame_index: s32;
}

Rc_Ref_Name :: s32;
RC_INVALID_REF_FRAME : s32 : -1;
RC_INTRA_FRAME : s32 : 0;
RC_LAST_FRAME : s32 : 1;
RC_GOLDEN_FRAME : s32 : 2;
RC_ALTREF_FRAME : s32 : 3;

