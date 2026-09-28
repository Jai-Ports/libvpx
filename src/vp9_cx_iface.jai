// Generated directly from C by cpp_transpiler.
Codec_Alg_Priv_in_vp9_cx_iface :: struct {
    base: Codec_Priv_T #align 8;
    cfg: Codec_Enc_Cfg_T #align 1;
    extra_cfg: Vp9_Extracfg #align 1;
    pts_offset: Codec_Pts_T #align 1;
    pts_offset_initialized: u8 #align 1;
    layout_padding_0: [7] u8 #align 1;
    oxcf: VP9_Encoder_Config #align 1;
    cpi: *VP9_COMP_in_vp9_encoder #align 1;
    cx_data: *u8 #align 1;
    cx_data_sz: u64 #align 1;
    pending_cx_data: *u8 #align 1;
    pending_cx_data_sz: u64 #align 1;
    pending_frame_count: s32 #align 1;
    layout_padding_1: [4] u8 #align 1;
    pending_frame_sizes: [8] u64 #align 1;
    pending_frame_magnitude: u64 #align 1;
    preview_img: Image_T #align 1;
    next_frame_flags: Enc_Frame_Flags_T #align 1;
    preview_ppcfg: Vp8_Postproc_Cfg_T #align 1;
    layout_padding_2: [4] u8 #align 1;
    pkt_list: Codec_Alg_Priv_Pkt_List_in_vp9_cx_iface #align 1;
    fixed_kf_cntr: u32 #align 1;
    layout_padding_3: [4] u8 #align 1;
    output_cx_pkt_cb: Codec_Priv_Output_Cx_Pkt_Cb_Pair_T #align 1;
    buffer_pool: *Buffer_Pool #align 1;
    global_headers: Fixed_Buf_T #align 1;
    global_header_subsampling: s32 #align 1;
    layout_padding_4: [4] u8 #align 1;
} #no_padding;

Codec_Alg_Priv_Pkt_List_in_vp9_cx_iface :: union {
    head: Codec_Pkt_List;
    alloc_: Unnamed_3404;
}

Unnamed_3404 :: struct {
    head: Codec_Pkt_List #align 8;
    pkts: [256] Codec_Cx_Pkt #align 1;
} #no_padding;

Vp9_Extracfg :: struct {
    cpu_used: s32;
    enable_auto_alt_ref: u32;
    noise_sensitivity: u32;
    sharpness: u32;
    static_thresh: u32;
    tile_columns: u32;
    tile_rows: u32;
    enable_tpl_model: u32;
    enable_keyframe_filtering: u32;
    arnr_max_frames: u32;
    arnr_strength: u32;
    min_gf_interval: u32;
    max_gf_interval: u32;
    tuning: Vp8e_Tuning;
    cq_level: u32;
    rc_max_intra_bitrate_pct: u32;
    rc_max_inter_bitrate_pct: u32;
    gf_cbr_boost_pct: u32;
    lossless: u32;
    target_level: u32;
    frame_parallel_decoding_mode: u32;
    aq_mode: AQ_MODE;
    alt_ref_aq: s32;
    frame_periodic_boost: u32;
    bit_depth: Bit_Depth_T;
    content: Vp9e_Tune_Content;
    color_space: Color_Space_T;
    color_range: Color_Range_T;
    render_width: s32;
    render_height: s32;
    row_mt: u32;
    motion_vector_unit_test: u32;
    delta_q_uv: s32;
    validate_hbd_input: u32;
}

Pick_Quickcompress_Mode_Static_Assert_Entry_in_vp9_cx_iface :: struct {
    bitfield_storage_0: [1] u8 #align 1;
    layout_padding_1: [3] u8 #align 1;
    alignment_marker_2: [0] u8 #align 4;
} #no_padding;

CODEC_VP9_CX_ALGO: Codec_Iface_T;

K_MIN_COMPRESSED_SIZE: u64;

ENCODER_USAGE_CFG_MAP: [1] Codec_Enc_Cfg_Map_T;

ENCODER_CTRL_MAPS: [64] Codec_Ctrl_Fn_Map_T;

default_extra_cfg: Vp9_Extracfg;

COUNT_TO_UPDATE_FACTOR_in_vp9_cx_iface: [21] s32;

SUB_PEL_FILTERS_12_in_vp9_cx_iface: [16] Interp_Kernel12 #align 256;

FRAME_SCALE_FACTOR: [2] s32;

RATE_THRESH_MULT: [2] float64;

RCF_MULT: [2] float64;

K_VP9_REF_FLAG_LIST: [4] s32;

clip_pixel_in_vp9_cx_iface :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_cx_iface :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_cx_iface :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_cx_iface :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_cx_iface :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_cx_iface(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_cx_iface(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_cx_iface(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_cx_iface :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

gcd_in_vp9_cx_iface :: (a: s64, b: s32) -> s32 {
    while b != 0 {
        r := cast,no_check(s32) (a % cast(s64) b);
        a = cast,no_check(s64) b;
        b = r;
    }

    return cast,no_check(s32) a;
}

reduce_ratio_in_vp9_cx_iface :: (ratio: *Rational64_T) {
    DENOM := gcd_in_vp9_cx_iface(ratio.num, ratio.den);
    ratio.num /= cast,no_check(s64) DENOM;
    ratio.den /= DENOM;
}

get_filter_taps_in_vp9_cx_iface :: (FILTER: *s16) -> s32 {
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

vp8_set_reference_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

encoder_get_preview :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface) -> *Image_T {
    sd: YV12_BUFFER_CONFIG = ---;
    flags: Vp9_Ppflags_T = ---;
    fill_memory(*flags, 0, size_of(Vp9_Ppflags_T));

    if ctx.preview_ppcfg.post_proc_flag != 0 {
        flags.post_proc_flag = ctx.preview_ppcfg.post_proc_flag;
        flags.deblocking_level = ctx.preview_ppcfg.deblocking_level;
        flags.noise_level = ctx.preview_ppcfg.noise_level;
    }

    if (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *YV12_BUFFER_CONFIG, _: *Vp9_Ppflags_T) -> s32) (cast(*void) vp9_get_preview_raw_frame))(
        ctx.cpi,
        *sd,
        *flags
    ) == 0 {
        yuvconfig2image_2(*ctx.preview_img, *sd, null);
        return *ctx.preview_img;
    }
    return null;
}

encoder_get_global_headers :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface) -> *Fixed_Buf_T {
    if ctx.cpi == null {
        return null;
    }

    PROFILE := ctx.cfg.g_profile;
    LEVEL :=
        (cast,no_check(#type (_: *Vp9_Level_Spec) -> VP9_LEVEL) (cast(*void) vp9_get_level))(
            *ctx.cpi.level_info.level_spec
        );
    BIT_DEPTH := ctx.cfg.g_bit_depth;
    SUBSAMPLING := ctx.global_header_subsampling;
    BUF :=
        u8.[
            1,
            1,
            cast,no_check(u8) PROFILE,
            2,
            1,
            cast,no_check(u8) LEVEL,
            3,
            1,
            cast,no_check(u8) BIT_DEPTH,
            4,
            1,
            cast,no_check(u8) SUBSAMPLING
        ];

    if ctx.global_headers.buf != null {
        c_transpiler_deallocate_memory(ctx.global_headers.buf);
    }
    ctx.global_headers.buf = c_transpiler_allocate_memory(BUF.count);
    if ctx.global_headers.buf == null {
        return null;
    }

    ctx.global_headers.sz = BUF.count;

    if ctx.global_header_subsampling == -1 {
        ctx.global_headers.sz -= 3;
    }
    copy_memory(ctx.global_headers.buf, BUF.data, ctx.global_headers.sz);

    return *ctx.global_headers;
}

encoder_set_config :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, cfg: *Codec_Enc_Cfg_T) -> Codec_Err_T {
    force_key: s32 = 0;

    if cfg.g_w != ctx.cfg.g_w || cfg.g_h != ctx.cfg.g_h {
        if cfg.g_lag_in_frames > 1 || cfg.g_pass != cast,no_check(u32) RC_ONE_PASS {
            ctx.base.err_detail = c_string("Cannot change width or height after initialization");

            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }

        if ctx.cpi.last_coded_width != 0 &&
            ctx.cpi.last_coded_height != 0 &&
            valid_ref_frame_size_in_vp9_cx_iface(
                ctx.cpi.last_coded_width,
                ctx.cpi.last_coded_height,
                cast,no_check(s32) cfg.g_w,
                cast,no_check(s32) cfg.g_h
            ) == 0 &&
            ctx.cpi.svc.number_spatial_layers == 1 ||
            ctx.cpi.initial_width != 0 && cast,no_check(s32) cfg.g_w > ctx.cpi.initial_width ||
            ctx.cpi.initial_height != 0 && cast,no_check(s32) cfg.g_h > ctx.cpi.initial_height {
            force_key = 1;
        }
    }

    if cfg.g_lag_in_frames > ctx.cfg.g_lag_in_frames {
        ctx.base.err_detail = c_string("Cannot increase lag_in_frames");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    res := validate_config_in_vp9_cx_iface(ctx, cfg, *ctx.extra_cfg);
    if res != cast,no_check(u32) CODEC_OK {
        return res;
    }

    if setjmp_2(ctx.cpi.common.error.jmp.data) != 0 {
        CODEC_ERR := update_error_state_in_vp9_cx_iface(ctx, *ctx.cpi.common.error);
        ctx.cpi.common.error.setjmp = 0;

        return CODEC_ERR;
    }
    ctx.cpi.common.error.setjmp = 1;

    assignment_0: Codec_Enc_Cfg_T = cfg.*;
    ((*ctx.cfg).*) = assignment_0;
    set_encoder_config(*ctx.oxcf, *ctx.cfg, *ctx.extra_cfg);
    set_twopass_params_from_config(*ctx.cfg, ctx.cpi);

    force_key |= cast(s32) (ctx.cpi.common.profile != ctx.oxcf.profile);
    vp9_change_config(ctx.cpi, *ctx.oxcf);

    if force_key != 0 {
        ctx.next_frame_flags |= cast,no_check(Enc_Frame_Flags_T) (1);
    }

    ctx.cpi.common.error.setjmp = 0;
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

set_twopass_params_from_config :: (CFG: *Codec_Enc_Cfg_T, cpi: *VP9_COMP_in_vp9_encoder) -> Codec_Err_T {
    if CFG.use_vizier_rc_params == 0 {
        return cast,no_check(Codec_Err_T) CODEC_OK;
    }
    if cpi == null {
        return cast,no_check(Codec_Err_T) CODEC_ERROR;
    }

    cpi.twopass.use_vizier_rc_params = CFG.use_vizier_rc_params;

    cpi.twopass.active_wq_factor =
        (cast,no_check(float64) CFG.active_wq_factor.num) /
            cast,no_check(float64) CFG.active_wq_factor.den;
    if c_transpiler_float_less(cpi.twopass.active_wq_factor, 0.25) {
        cpi.twopass.active_wq_factor = 0.25;
    } else if c_transpiler_float_greater(cpi.twopass.active_wq_factor, 16.0) {
        cpi.twopass.active_wq_factor = 16.0;
    }

    cpi.twopass.err_per_mb =
        (cast,no_check(float64) CFG.err_per_mb_factor.num) /
            cast,no_check(float64) CFG.err_per_mb_factor.den;
    if c_transpiler_float_less(cpi.twopass.err_per_mb, 0.25) {
        cpi.twopass.err_per_mb = 0.25;
    } else if c_transpiler_float_greater(cpi.twopass.err_per_mb, 4.0) {
        cpi.twopass.err_per_mb = 4.0;
    }

    cpi.twopass.sr_default_decay_limit =
        (cast,no_check(float64) CFG.sr_default_decay_limit.num) /
            cast,no_check(float64) CFG.sr_default_decay_limit.den;
    if c_transpiler_float_less(cpi.twopass.sr_default_decay_limit, 0.25) {
        cpi.twopass.sr_default_decay_limit = 0.25;
    } else if c_transpiler_float_greater(cpi.twopass.sr_default_decay_limit, 1.33) {
        cpi.twopass.sr_default_decay_limit = 1.33;
    }

    cpi.twopass.sr_diff_factor =
        (cast,no_check(float64) CFG.sr_diff_factor.num) /
            cast,no_check(float64) CFG.sr_diff_factor.den;
    if c_transpiler_float_less(cpi.twopass.sr_diff_factor, 0.25) {
        cpi.twopass.sr_diff_factor = 0.25;
    } else if c_transpiler_float_greater(cpi.twopass.sr_diff_factor, 4.0) {
        cpi.twopass.sr_diff_factor = 4.0;
    }

    cpi.twopass.kf_err_per_mb =
        (cast,no_check(float64) CFG.kf_err_per_mb_factor.num) /
            cast,no_check(float64) CFG.kf_err_per_mb_factor.den;
    if c_transpiler_float_less(cpi.twopass.kf_err_per_mb, 0.25) {
        cpi.twopass.kf_err_per_mb = 0.25;
    } else if c_transpiler_float_greater(cpi.twopass.kf_err_per_mb, 4.0) {
        cpi.twopass.kf_err_per_mb = 4.0;
    }

    cpi.twopass.kf_frame_min_boost =
        (cast,no_check(float64) CFG.kf_frame_min_boost_factor.num) /
            cast,no_check(float64) CFG.kf_frame_min_boost_factor.den;
    if c_transpiler_float_less(cpi.twopass.kf_frame_min_boost, 0.25) {
        cpi.twopass.kf_frame_min_boost = 0.25;
    } else if c_transpiler_float_greater(cpi.twopass.kf_frame_min_boost, 4.0) {
        cpi.twopass.kf_frame_min_boost = 4.0;
    }

    cpi.twopass.kf_frame_max_boost_first =
        (cast,no_check(float64) CFG.kf_frame_max_boost_first_factor.num) /
            cast,no_check(float64) CFG.kf_frame_max_boost_first_factor.den;
    if c_transpiler_float_less(cpi.twopass.kf_frame_max_boost_first, 0.25) {
        cpi.twopass.kf_frame_max_boost_first = 0.25;
    } else if c_transpiler_float_greater(cpi.twopass.kf_frame_max_boost_first, 4.0) {
        cpi.twopass.kf_frame_max_boost_first = 4.0;
    }

    cpi.twopass.kf_frame_max_boost_subs =
        (cast,no_check(float64) CFG.kf_frame_max_boost_subs_factor.num) /
            cast,no_check(float64) CFG.kf_frame_max_boost_subs_factor.den;
    if c_transpiler_float_less(cpi.twopass.kf_frame_max_boost_subs, 0.25) {
        cpi.twopass.kf_frame_max_boost_subs = 0.25;
    } else if c_transpiler_float_greater(cpi.twopass.kf_frame_max_boost_subs, 4.0) {
        cpi.twopass.kf_frame_max_boost_subs = 4.0;
    }

    cpi.twopass.kf_max_total_boost =
        (cast,no_check(float64) CFG.kf_max_total_boost_factor.num) /
            cast,no_check(float64) CFG.kf_max_total_boost_factor.den;
    if c_transpiler_float_less(cpi.twopass.kf_max_total_boost, 0.25) {
        cpi.twopass.kf_max_total_boost = 0.25;
    } else if c_transpiler_float_greater(cpi.twopass.kf_max_total_boost, 4.0) {
        cpi.twopass.kf_max_total_boost = 4.0;
    }

    cpi.twopass.gf_max_total_boost =
        (cast,no_check(float64) CFG.gf_max_total_boost_factor.num) /
            cast,no_check(float64) CFG.gf_max_total_boost_factor.den;
    if c_transpiler_float_less(cpi.twopass.gf_max_total_boost, 0.25) {
        cpi.twopass.gf_max_total_boost = 0.25;
    } else if c_transpiler_float_greater(cpi.twopass.gf_max_total_boost, 4.0) {
        cpi.twopass.gf_max_total_boost = 4.0;
    }

    cpi.twopass.gf_frame_max_boost =
        (cast,no_check(float64) CFG.gf_frame_max_boost_factor.num) /
            cast,no_check(float64) CFG.gf_frame_max_boost_factor.den;
    if c_transpiler_float_less(cpi.twopass.gf_frame_max_boost, 0.25) {
        cpi.twopass.gf_frame_max_boost = 0.25;
    } else if c_transpiler_float_greater(cpi.twopass.gf_frame_max_boost, 4.0) {
        cpi.twopass.gf_frame_max_boost = 4.0;
    }

    cpi.twopass.zm_factor = (cast,no_check(float64) CFG.zm_factor.num) / cast,no_check(float64) CFG.zm_factor.den;
    if c_transpiler_float_less(cpi.twopass.zm_factor, 0.25) {
        cpi.twopass.zm_factor = 0.25;
    } else if c_transpiler_float_greater(cpi.twopass.zm_factor, 2.0) {
        cpi.twopass.zm_factor = 2.0;
    }

    cpi.rd_ctrl.rd_mult_inter_qp_fac =
        (cast,no_check(float64) CFG.rd_mult_inter_qp_fac.num) /
            cast,no_check(float64) CFG.rd_mult_inter_qp_fac.den;
    if c_transpiler_float_less(cpi.rd_ctrl.rd_mult_inter_qp_fac, 0.25) {
        cpi.rd_ctrl.rd_mult_inter_qp_fac = 0.25;
    } else if c_transpiler_float_greater(cpi.rd_ctrl.rd_mult_inter_qp_fac, 4.0) {
        cpi.rd_ctrl.rd_mult_inter_qp_fac = 4.0;
    }

    cpi.rd_ctrl.rd_mult_arf_qp_fac =
        (cast,no_check(float64) CFG.rd_mult_arf_qp_fac.num) /
            cast,no_check(float64) CFG.rd_mult_arf_qp_fac.den;
    if c_transpiler_float_less(cpi.rd_ctrl.rd_mult_arf_qp_fac, 0.25) {
        cpi.rd_ctrl.rd_mult_arf_qp_fac = 0.25;
    } else if c_transpiler_float_greater(cpi.rd_ctrl.rd_mult_arf_qp_fac, 4.0) {
        cpi.rd_ctrl.rd_mult_arf_qp_fac = 4.0;
    }

    cpi.rd_ctrl.rd_mult_key_qp_fac =
        (cast,no_check(float64) CFG.rd_mult_key_qp_fac.num) /
            cast,no_check(float64) CFG.rd_mult_key_qp_fac.den;
    if c_transpiler_float_less(cpi.rd_ctrl.rd_mult_key_qp_fac, 0.25) {
        cpi.rd_ctrl.rd_mult_key_qp_fac = 0.25;
    } else if c_transpiler_float_greater(cpi.rd_ctrl.rd_mult_key_qp_fac, 4.0) {
        cpi.rd_ctrl.rd_mult_key_qp_fac = 4.0;
    }

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

set_encoder_config :: (oxcf: *VP9_Encoder_Config, cfg: *Codec_Enc_Cfg_T, extra_cfg: *Vp9_Extracfg) -> Codec_Err_T {
    tl: s32 = ---;

    oxcf.profile = cfg.g_profile;
    oxcf.max_threads = cast,no_check(s32) cfg.g_threads;
    oxcf.width = cast,no_check(s32) cfg.g_w;
    oxcf.height = cast,no_check(s32) cfg.g_h;
    oxcf.bit_depth = cfg.g_bit_depth;
    oxcf.input_bit_depth = cfg.g_input_bit_depth;

    oxcf.init_framerate = (cast,no_check(float64) cfg.g_timebase.den) / cfg.g_timebase.num;
    if c_transpiler_float_greater(oxcf.init_framerate, 180.0) {
        oxcf.init_framerate = 30.0;
    }
    oxcf.g_timebase = cfg.g_timebase;
    oxcf.g_timebase_in_ts = get_g_timebase_in_ts(oxcf.g_timebase);

    oxcf.mode = cast,no_check(MODE_in_vp9_cx_iface) GOOD;

    if cfg.g_pass == {
        case cast,no_check(u32) RC_ONE_PASS;
            oxcf.pass = 0;
        case cast,no_check(u32) RC_FIRST_PASS;
            oxcf.pass = 1;
        case cast,no_check(u32) RC_LAST_PASS;
            oxcf.pass = 2;
    }

    oxcf.lag_in_frames =
        cast,no_check(s32) ((ifx cfg.g_pass == cast,no_check(u32) RC_FIRST_PASS then 0 else cfg.g_lag_in_frames));
    oxcf.rc_mode = cfg.rc_end_usage;

    raw_target_rate :=
        cast,no_check(u32) ((((((cast,no_check(s64) oxcf.width) * cast(s64) oxcf.height) * cast,no_check(s64) oxcf.bit_depth) * 3) * oxcf.init_framerate) /
            1000.0);

    cfg.rc_target_bitrate =
        ifx (ifx raw_target_rate < cfg.rc_target_bitrate then raw_target_rate else cfg.rc_target_bitrate) < 1000000 then (ifx raw_target_rate < cfg.rc_target_bitrate then raw_target_rate else cfg.rc_target_bitrate) else 1000000;

    oxcf.target_bandwidth = 1000 * cast,no_check(s64) cfg.rc_target_bitrate;
    oxcf.rc_max_intra_bitrate_pct = extra_cfg.rc_max_intra_bitrate_pct;
    oxcf.rc_max_inter_bitrate_pct = extra_cfg.rc_max_inter_bitrate_pct;
    oxcf.gf_cbr_boost_pct = extra_cfg.gf_cbr_boost_pct;

    oxcf.best_allowed_q =
        ifx extra_cfg.lossless != 0 then 0 else vp9_quantizer_to_qindex(cast,no_check(s32) cfg.rc_min_quantizer);
    oxcf.worst_allowed_q =
        ifx extra_cfg.lossless != 0 then 0 else vp9_quantizer_to_qindex(cast,no_check(s32) cfg.rc_max_quantizer);
    oxcf.cq_level = vp9_quantizer_to_qindex(cast,no_check(s32) extra_cfg.cq_level);
    oxcf.fixed_q = -1;

    oxcf.under_shoot_pct = cast,no_check(s32) cfg.rc_undershoot_pct;
    oxcf.over_shoot_pct = cast,no_check(s32) cfg.rc_overshoot_pct;

    oxcf.scaled_frame_width = cast,no_check(s32) cfg.rc_scaled_width;
    oxcf.scaled_frame_height = cast,no_check(s32) cfg.rc_scaled_height;
    if cfg.rc_resize_allowed == 1 {
        oxcf.resize_mode =
            cast,no_check(RESIZE_TYPE) ((ifx oxcf.scaled_frame_width == 0 ||
                oxcf.scaled_frame_height == 0 then cast,no_check(s32) (RESIZE_DYNAMIC) else cast,no_check(s32) (RESIZE_FIXED)));
    } else {
        oxcf.resize_mode = cast,no_check(RESIZE_TYPE) RESIZE_NONE;
    }

    oxcf.maximum_buffer_size_ms = cast,no_check(s64) cfg.rc_buf_sz;
    oxcf.starting_buffer_level_ms = cast,no_check(s64) cfg.rc_buf_initial_sz;
    oxcf.optimal_buffer_level_ms = cast,no_check(s64) cfg.rc_buf_optimal_sz;

    oxcf.drop_frames_water_mark = cast,no_check(s32) cfg.rc_dropframe_thresh;

    oxcf.two_pass_vbrbias = cast,no_check(s32) cfg.rc_2pass_vbr_bias_pct;
    oxcf.two_pass_vbrmin_section = cast,no_check(s32) cfg.rc_2pass_vbr_minsection_pct;
    oxcf.two_pass_vbrmax_section = cast,no_check(s32) cfg.rc_2pass_vbr_maxsection_pct;
    oxcf.vbr_corpus_complexity = cast,no_check(s32) cfg.rc_2pass_vbr_corpus_complexity;

    oxcf.auto_key = cast(s32) (cfg.kf_mode == cast,no_check(u32) KF_AUTO && cfg.kf_min_dist != cfg.kf_max_dist);

    oxcf.key_freq = cast,no_check(s32) cfg.kf_max_dist;

    oxcf.speed = absolute_value(extra_cfg.cpu_used);
    oxcf.encode_breakout = cast,no_check(s32) extra_cfg.static_thresh;
    oxcf.enable_auto_arf = cast,no_check(s32) extra_cfg.enable_auto_alt_ref;
    if oxcf.bit_depth == cast,no_check(u32) BITS_8 {
        oxcf.noise_sensitivity = cast,no_check(s32) extra_cfg.noise_sensitivity;
    } else {
        oxcf.noise_sensitivity = 0;
    }
    oxcf.sharpness = cast,no_check(s32) extra_cfg.sharpness;

    vp9_set_first_pass_stats(oxcf, *cfg.rc_twopass_stats_in);

    oxcf.color_space = extra_cfg.color_space;
    oxcf.color_range = extra_cfg.color_range;
    oxcf.render_width = extra_cfg.render_width;
    oxcf.render_height = extra_cfg.render_height;
    oxcf.arnr_max_frames = cast,no_check(s32) extra_cfg.arnr_max_frames;
    oxcf.arnr_strength = cast,no_check(s32) extra_cfg.arnr_strength;
    oxcf.min_gf_interval = cast,no_check(s32) extra_cfg.min_gf_interval;
    oxcf.max_gf_interval = cast,no_check(s32) extra_cfg.max_gf_interval;

    oxcf.tuning = extra_cfg.tuning;
    oxcf.content = extra_cfg.content;

    oxcf.tile_columns = cast,no_check(s32) extra_cfg.tile_columns;

    oxcf.enable_tpl_model = cast,no_check(s32) extra_cfg.enable_tpl_model;

    oxcf.enable_keyframe_filtering = cast,no_check(s32) extra_cfg.enable_keyframe_filtering;

    if oxcf.max_threads > 1 && oxcf.tile_columns > 0 {
        oxcf.tile_rows = 0;
    } else {
        oxcf.tile_rows = cast,no_check(s32) extra_cfg.tile_rows;
    }

    oxcf.error_resilient_mode = cfg.g_error_resilient & 0x1;
    oxcf.frame_parallel_decoding_mode = extra_cfg.frame_parallel_decoding_mode;

    oxcf.aq_mode = extra_cfg.aq_mode;
    oxcf.alt_ref_aq = extra_cfg.alt_ref_aq;

    oxcf.frame_periodic_boost = cast,no_check(s32) extra_cfg.frame_periodic_boost;

    oxcf.ss_number_layers = cast,no_check(s32) cfg.ss_number_layers;
    oxcf.ts_number_layers = cast,no_check(s32) cfg.ts_number_layers;
    oxcf.temporal_layering_mode = cast,no_check(Vp9e_Temporal_Layering_Mode) cfg.temporal_layering_mode;
    if oxcf.temporal_layering_mode == cast,no_check(u32) VP9E_TEMPORAL_LAYERING_MODE_NOLAYERING {
        if oxcf.ts_number_layers == 2 {
            oxcf.temporal_layering_mode = cast,no_check(VP9_E_TEMPORAL_LAYERING_MODE) VP9E_TEMPORAL_LAYERING_MODE_0101;
        } else if oxcf.ts_number_layers == 3 {
            oxcf.temporal_layering_mode = cast,no_check(VP9_E_TEMPORAL_LAYERING_MODE) VP9E_TEMPORAL_LAYERING_MODE_0212;
        }
    }

    oxcf.target_level = extra_cfg.target_level;

    oxcf.row_mt = cast,no_check(s32) extra_cfg.row_mt;
    oxcf.motion_vector_unit_test = extra_cfg.motion_vector_unit_test;

    oxcf.delta_q_uv = extra_cfg.delta_q_uv;

    sl: s32 = 0;
    while sl < oxcf.ss_number_layers {
        tl = 0;
        while tl < oxcf.ts_number_layers {
            LAYER := sl * oxcf.ts_number_layers + tl;
            if cfg.layer_target_bitrate[LAYER] > cast,no_check(u32) (2147483647 / 1000) {
                oxcf.layer_target_bitrate[LAYER] = 2147483647;
            } else {
                oxcf.layer_target_bitrate[LAYER] = cast,no_check(s32) (1000 * cfg.layer_target_bitrate[LAYER]);
            }
            tl += 1;
        }
        sl += 1;
    }
    if oxcf.ss_number_layers == 1 && oxcf.pass != 0 {
        oxcf.ss_target_bitrate[0] = cast,no_check(s32) oxcf.target_bandwidth;
    }
    if oxcf.ts_number_layers > 1 {
        tl = 0;
        while tl < 5 {
            oxcf.ts_rate_decimator[tl] =
                cast,no_check(s32) ((ifx cfg.ts_rate_decimator[tl] != 0 then cfg.ts_rate_decimator[tl] else 1));
            tl += 1;
        }
    } else if oxcf.ts_number_layers == 1 {
        oxcf.ts_rate_decimator[0] = 1;
    }

    if get_level_index(oxcf.target_level) >= 0 {
        config_target_level(oxcf);
    }

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

config_target_level :: (oxcf: *VP9_Encoder_Config) {
    max_over_shoot_pct: s32 = ---;
    TARGET_LEVEL_INDEX := get_level_index(oxcf.target_level);

    max_average_bitrate := VP9_LEVEL_DEFS[TARGET_LEVEL_INDEX].average_bitrate * 800.0;
    if c_transpiler_float_greater(cast,no_check(float64) oxcf.target_bandwidth, max_average_bitrate) {
        oxcf.target_bandwidth = cast,no_check(s64) max_average_bitrate;
    }
    if oxcf.ss_number_layers == 1 && oxcf.pass != 0 {
        oxcf.ss_target_bitrate[0] = cast,no_check(s32) oxcf.target_bandwidth;
    }

    if oxcf.target_bandwidth > 0 {
        max_over_shoot_pct =
            cast,no_check(s32) (((max_average_bitrate * 1.1 - cast,no_check(float64) oxcf.target_bandwidth) * 100.0) /
                cast,no_check(float64) oxcf.target_bandwidth);
        if oxcf.over_shoot_pct > max_over_shoot_pct {
            oxcf.over_shoot_pct = max_over_shoot_pct;
        }
    }

    oxcf.worst_allowed_q = vp9_quantizer_to_qindex(63);

    if oxcf.min_gf_interval <= cast,no_check(s32) VP9_LEVEL_DEFS[TARGET_LEVEL_INDEX].min_altref_distance {
        oxcf.min_gf_interval = (cast,no_check(s32) VP9_LEVEL_DEFS[TARGET_LEVEL_INDEX].min_altref_distance) + 1;

        if oxcf.max_gf_interval != 0 {
            oxcf.max_gf_interval =
                ifx oxcf.max_gf_interval > oxcf.min_gf_interval then oxcf.max_gf_interval else oxcf.min_gf_interval;
        }
    }

    if cast,no_check(s32) VP9_LEVEL_DEFS[TARGET_LEVEL_INDEX].max_col_tiles < (cast(s32) 1) << ((oxcf.tile_columns) & 31) {
        while oxcf.tile_columns > 0 && cast,no_check(s32) VP9_LEVEL_DEFS[TARGET_LEVEL_INDEX].max_col_tiles < (cast(s32) 1) << ((oxcf.tile_columns) & 31) {
            oxcf.tile_columns -= 1;
        }
    }
}

get_level_index :: (level: VP9_LEVEL) -> s32 {
    for i: 0..cast(s32) 14 - 1 {
        if level == VP9_LEVEL_DEFS[i].level {
            return i;
        }
    }
    return -1;
}

vp9_set_first_pass_stats :: (oxcf: *VP9_Encoder_Config, stats: *Fixed_Buf_T) {
    oxcf.two_pass_stats_in = stats.*;
}

get_g_timebase_in_ts :: (g_timebase: Rational_T) -> Rational64_T {
    g_timebase_in_ts: Rational64_T = ---;
    g_timebase_in_ts.den = g_timebase.den;
    g_timebase_in_ts.num = cast,no_check(s64) g_timebase.num;
    g_timebase_in_ts.num *= 10000000;
    reduce_ratio_in_vp9_cx_iface(*g_timebase_in_ts);
    return g_timebase_in_ts;
}

update_error_state_in_vp9_cx_iface :: (
    ctx: *Codec_Alg_Priv_in_vp9_cx_iface,
    error: *Internal_Error_Info
) -> Codec_Err_T {
    RES := error.error_code;

    if RES != cast,no_check(u32) CODEC_OK {
        ctx.base.err_detail = ifx error.has_detail != 0 then error.detail.data else null;
    }

    return RES;
}

validate_config_in_vp9_cx_iface :: (
    ctx: *Codec_Alg_Priv_in_vp9_cx_iface,
    cfg: *Codec_Enc_Cfg_T,
    extra_cfg: *Vp9_Extracfg
) -> Codec_Err_T {
    if !((cfg.g_w == 1 || cfg.g_w > 1) && cfg.g_w <= 65536) {
        ctx.base.err_detail = c_string("g_w out of range [1..65536]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.g_h == 1 || cfg.g_h > 1) && cfg.g_h <= 65536) {
        ctx.base.err_detail = c_string("g_h out of range [1..65536]");

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
    if cast(u32) (extra_cfg.lossless != 0) != extra_cfg.lossless {
        ctx.base.err_detail = c_string("lossless expected boolean");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if cast(u32) (extra_cfg.frame_parallel_decoding_mode != 0) != extra_cfg.frame_parallel_decoding_mode {
        ctx.base.err_detail = c_string("frame_parallel_decoding_mode expected boolean");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((extra_cfg.aq_mode == 0 || extra_cfg.aq_mode > 0) && extra_cfg.aq_mode <= cast,no_check(u32) ((cast,no_check(s32) (AQ_MODE_COUNT)) - 2)) {
        ctx.base.err_detail = c_string("aq_mode out of range [0..AQ_MODE_COUNT - 2]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((extra_cfg.alt_ref_aq == 0 || extra_cfg.alt_ref_aq > 0) && extra_cfg.alt_ref_aq <= 1) {
        ctx.base.err_detail = c_string("alt_ref_aq out of range [0..1]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((extra_cfg.frame_periodic_boost == 0 || extra_cfg.frame_periodic_boost > 0) && extra_cfg.frame_periodic_boost <= 1) {
        ctx.base.err_detail = c_string("frame_periodic_boost out of range [0..1]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !(cfg.g_threads <= 64) {
        ctx.base.err_detail = c_string("g_threads out of range [..MAX_NUM_THREADS]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !(cfg.g_lag_in_frames <= 25) {
        ctx.base.err_detail = c_string("g_lag_in_frames out of range [..MAX_LAG_BUFFERS]");

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
    if !((cfg.rc_2pass_vbr_corpus_complexity == 0 || cfg.rc_2pass_vbr_corpus_complexity > 0) && cfg.rc_2pass_vbr_corpus_complexity <= 10000) {
        ctx.base.err_detail = c_string("rc_2pass_vbr_corpus_complexity out of range [0..10000]");

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

    if !((extra_cfg.min_gf_interval == 0 || extra_cfg.min_gf_interval > 0) && extra_cfg.min_gf_interval <= cast,no_check(u32) (25 - 1)) {
        ctx.base.err_detail = c_string("min_gf_interval out of range [0..(MAX_LAG_BUFFERS - 1)]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((extra_cfg.max_gf_interval == 0 || extra_cfg.max_gf_interval > 0) && extra_cfg.max_gf_interval <= cast,no_check(u32) (25 - 1)) {
        ctx.base.err_detail = c_string("max_gf_interval out of range [0..(MAX_LAG_BUFFERS - 1)]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if extra_cfg.max_gf_interval > 0 {
        if !((extra_cfg.max_gf_interval == 2 || extra_cfg.max_gf_interval > 2) && extra_cfg.max_gf_interval <= cast,no_check(u32) (25 - 1)) {
            ctx.base.err_detail = c_string("max_gf_interval out of range [2..(MAX_LAG_BUFFERS - 1)]");

            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }
    }
    if extra_cfg.min_gf_interval > 0 && extra_cfg.max_gf_interval > 0 {
        if !((extra_cfg.max_gf_interval == extra_cfg.min_gf_interval || extra_cfg.max_gf_interval > extra_cfg.min_gf_interval) && extra_cfg.max_gf_interval <= cast,no_check(u32) (25 - 1)) {
            ctx.base.err_detail =
                c_string("max_gf_interval out of range [extra_cfg->min_gf_interval..(MAX_LAG_BUFFERS - 1)]");

            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }
    }

    if cfg.g_lag_in_frames > 0 && extra_cfg.max_gf_interval > 0 && cfg.g_lag_in_frames < extra_cfg.max_gf_interval + 2 {
        ctx.base.err_detail = c_string("Set lag in frames to 0 (low delay) or >= (max-gf-interval + 2)");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if cfg.rc_resize_allowed == 1 {
        if !((cfg.rc_scaled_width == 0 || cfg.rc_scaled_width > 0) && cfg.rc_scaled_width <= cfg.g_w) {
            ctx.base.err_detail = c_string("rc_scaled_width out of range [0..cfg->g_w]");

            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }
        if !((cfg.rc_scaled_height == 0 || cfg.rc_scaled_height > 0) && cfg.rc_scaled_height <= cfg.g_h) {
            ctx.base.err_detail = c_string("rc_scaled_height out of range [0..cfg->g_h]");

            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }
    }

    if !((cfg.ss_number_layers == 1 || cfg.ss_number_layers > 1) && cfg.ss_number_layers <= 5) {
        ctx.base.err_detail = c_string("ss_number_layers out of range [1..VPX_SS_MAX_LAYERS]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.ts_number_layers == 1 || cfg.ts_number_layers > 1) && cfg.ts_number_layers <= 5) {
        ctx.base.err_detail = c_string("ts_number_layers out of range [1..VPX_TS_MAX_LAYERS]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    {
        level := extra_cfg.target_level;
        if level != cast,no_check(u32) LEVEL_1 &&
            level != cast,no_check(u32) LEVEL_1_1 &&
            level != cast,no_check(u32) LEVEL_2 &&
            level != cast,no_check(u32) LEVEL_2_1 &&
            level != cast,no_check(u32) LEVEL_3 &&
            level != cast,no_check(u32) LEVEL_3_1 &&
            level != cast,no_check(u32) LEVEL_4 &&
            level != cast,no_check(u32) LEVEL_4_1 &&
            level != cast,no_check(u32) LEVEL_5 &&
            level != cast,no_check(u32) LEVEL_5_1 &&
            level != cast,no_check(u32) LEVEL_5_2 &&
            level != cast,no_check(u32) LEVEL_6 &&
            level != cast,no_check(u32) LEVEL_6_1 &&
            level != cast,no_check(u32) LEVEL_6_2 &&
            level != cast,no_check(u32) LEVEL_UNKNOWN &&
            level != cast,no_check(u32) LEVEL_AUTO &&
            level != cast,no_check(u32) LEVEL_MAX {
            ctx.base.err_detail = c_string("target_level is invalid");

            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }
    }

    if cfg.ss_number_layers * cfg.ts_number_layers > 12 {
        ctx.base.err_detail = c_string("ss_number_layers * ts_number_layers is out of range");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if cfg.ts_number_layers > 1 {
        tl: u32 = ---;
        sl: u32 = 1;
        while sl < cfg.ss_number_layers {
            tl = 1;
            while tl < cfg.ts_number_layers {
                LAYER := cast,no_check(s32) (sl * cfg.ts_number_layers + tl);
                if cfg.layer_target_bitrate[LAYER] < cfg.layer_target_bitrate[LAYER - 1] {
                    ctx.base.err_detail = c_string("ts_target_bitrate entries are not increasing");

                    return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
                }
                tl += 1;
            }
            sl += 1;
        }

        if !((cfg.ts_rate_decimator[cfg.ts_number_layers - 1] == 1 || cfg.ts_rate_decimator[cfg.ts_number_layers - 1] > 1) && cfg.ts_rate_decimator[cfg.ts_number_layers - 1] <= 1) {
            ctx.base.err_detail = c_string("ts_rate_decimator[cfg->ts_number_layers - 1] out of range [1..1]");

            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }
        tl = cfg.ts_number_layers - 2;
        while tl > 0 {
            if cfg.ts_rate_decimator[tl - 1] != 2 * cfg.ts_rate_decimator[tl] {
                ctx.base.err_detail = c_string("ts_rate_decimator factors are not powers of 2");

                return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
            }
            tl -= 1;
        }
    }

    if cfg.kf_mode != cast,no_check(u32) KF_DISABLED && cfg.kf_min_dist != cfg.kf_max_dist && cfg.kf_min_dist > 0 {
        ctx.base.err_detail = c_string("kf_min_dist not supported in auto mode, use 0 or kf_max_dist instead.");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if !((extra_cfg.row_mt == 0 || extra_cfg.row_mt > 0) && extra_cfg.row_mt <= 1) {
        ctx.base.err_detail = c_string("row_mt out of range [0..1]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((extra_cfg.motion_vector_unit_test == 0 || extra_cfg.motion_vector_unit_test > 0) && extra_cfg.motion_vector_unit_test <= 2) {
        ctx.base.err_detail = c_string("motion_vector_unit_test out of range [0..2]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((extra_cfg.enable_auto_alt_ref == 0 || extra_cfg.enable_auto_alt_ref > 0) && extra_cfg.enable_auto_alt_ref <= 6) {
        ctx.base.err_detail = c_string("enable_auto_alt_ref out of range [0..MAX_ARF_LAYERS]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((extra_cfg.cpu_used == -9 || extra_cfg.cpu_used > -9) && extra_cfg.cpu_used <= 9) {
        ctx.base.err_detail = c_string("cpu_used out of range [-9..9]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !(extra_cfg.noise_sensitivity <= 6) {
        ctx.base.err_detail = c_string("noise_sensitivity out of range [..6]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((extra_cfg.tile_columns == 0 || extra_cfg.tile_columns > 0) && extra_cfg.tile_columns <= 6) {
        ctx.base.err_detail = c_string("tile_columns out of range [0..6]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((extra_cfg.tile_rows == 0 || extra_cfg.tile_rows > 0) && extra_cfg.tile_rows <= 2) {
        ctx.base.err_detail = c_string("tile_rows out of range [0..2]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !(extra_cfg.sharpness <= 7) {
        ctx.base.err_detail = c_string("sharpness out of range [..7]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((extra_cfg.arnr_max_frames == 0 || extra_cfg.arnr_max_frames > 0) && extra_cfg.arnr_max_frames <= 15) {
        ctx.base.err_detail = c_string("arnr_max_frames out of range [0..15]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !(extra_cfg.arnr_strength <= 6) {
        ctx.base.err_detail = c_string("arnr_strength out of range [..6]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((extra_cfg.cq_level == 0 || extra_cfg.cq_level > 0) && extra_cfg.cq_level <= 63) {
        ctx.base.err_detail = c_string("cq_level out of range [0..63]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.g_bit_depth == cast,no_check(u32) BITS_8 || cfg.g_bit_depth > cast,no_check(u32) BITS_8) && cfg.g_bit_depth <= cast,no_check(u32) BITS_12) {
        ctx.base.err_detail = c_string("g_bit_depth out of range [VPX_BITS_8..VPX_BITS_12]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((cfg.g_input_bit_depth == 8 || cfg.g_input_bit_depth > 8) && cfg.g_input_bit_depth <= 12) {
        ctx.base.err_detail = c_string("g_input_bit_depth out of range [8..12]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if cfg.g_input_bit_depth > cfg.g_bit_depth {
        ctx.base.err_detail = c_string("Input bit-depth must not exceed codec bit-depth");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((extra_cfg.content == cast,no_check(u32) VP9E_CONTENT_DEFAULT || extra_cfg.content > cast,no_check(u32) VP9E_CONTENT_DEFAULT) && extra_cfg.content <= cast,no_check(u32) ((cast,no_check(s32) (VP9E_CONTENT_INVALID)) - 1)) {
        ctx.base.err_detail = c_string("content out of range [VP9E_CONTENT_DEFAULT..VP9E_CONTENT_INVALID - 1]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if cfg.g_pass == cast,no_check(u32) RC_LAST_PASS {
        PACKET_SZ: u64 = cast(u64) size_of(FIRSTPASS_STATS_in_vp9_cx_iface);
        N_PACKETS := cast,no_check(s32) (cfg.rc_twopass_stats_in.sz / PACKET_SZ);
        stats: *FIRSTPASS_STATS_in_vp9_cx_iface = ---;

        if cfg.rc_twopass_stats_in.buf == null {
            ctx.base.err_detail = c_string("rc_twopass_stats_in.buf not set.");

            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }

        if (((cfg.rc_twopass_stats_in.sz % PACKET_SZ)) != 0) {
            ctx.base.err_detail = c_string("rc_twopass_stats_in.sz indicates truncated packet.");

            return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
        }

        if cfg.ss_number_layers > 1 || cfg.ts_number_layers > 1 {
            n_packets_per_layer: [5] s32;

            stats = cast(*FIRSTPASS_STATS_in_vp9_cx_iface) cfg.rc_twopass_stats_in.buf;
            i: s32 = 0;
            while i < N_PACKETS {
                LAYER_ID := cast,no_check(s32) stats[i].spatial_layer_id;
                if LAYER_ID >= 0 && LAYER_ID < cast,no_check(s32) cfg.ss_number_layers {
                    n_packets_per_layer[LAYER_ID] += 1;
                }
                i += 1;
            }

            i = 0;
            while i < cast,no_check(s32) cfg.ss_number_layers {
                if n_packets_per_layer[i] < 2 {
                    ctx.base.err_detail = c_string("rc_twopass_stats_in requires at least two packets for each layer.");

                    return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
                }

                stats =
                    (cast(*FIRSTPASS_STATS_in_vp9_cx_iface) cfg.rc_twopass_stats_in.buf) +
                        N_PACKETS - cfg.ss_number_layers + i;
                layer_id := cast,no_check(u32) (cast,no_check(s32) stats.spatial_layer_id);

                COUNT_ROUNDED := stats.count + 0.5;
                if layer_id >= cfg.ss_number_layers ||
                    is_finite_number(cast,no_check(float32) stats.count) == 0 ||
                    c_transpiler_float_less(stats.count, 0.0) ||
                    c_transpiler_float_greater(COUNT_ROUNDED, 2147483647.0) ||
                    cast,no_check(s32) COUNT_ROUNDED != n_packets_per_layer[layer_id] - 1 {
                    ctx.base.err_detail = c_string("rc_twopass_stats_in missing EOS stats packet");

                    return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
                }
                i += 1;
            }
        } else {
            if cfg.rc_twopass_stats_in.sz < 2 * PACKET_SZ {
                ctx.base.err_detail = c_string("rc_twopass_stats_in requires at least two packets.");

                return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
            }

            stats = (cast(*FIRSTPASS_STATS_in_vp9_cx_iface) cfg.rc_twopass_stats_in.buf) + N_PACKETS - 1;

            COUNT_ROUNDED := stats.count + 0.5;
            if is_finite_number(cast,no_check(float32) stats.count) == 0 ||
                c_transpiler_float_less(stats.count, 0.0) ||
                c_transpiler_float_greater(COUNT_ROUNDED, 2147483647.0) ||
                cast,no_check(s32) COUNT_ROUNDED != N_PACKETS - 1 {
                ctx.base.err_detail = c_string("rc_twopass_stats_in missing EOS stats packet");

                return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
            }
        }
    }

    if cfg.g_profile > cast,no_check(u32) PROFILE_1 {
        ctx.base.err_detail = c_string("Profile > 1 not supported in this build configuration");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if cfg.g_profile <= cast,no_check(u32) PROFILE_1 && cfg.g_bit_depth > cast,no_check(u32) BITS_8 {
        ctx.base.err_detail = c_string("Codec high bit-depth not supported in profile < 2");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if cfg.g_profile > cast,no_check(u32) PROFILE_1 && cfg.g_bit_depth == cast,no_check(u32) BITS_8 {
        ctx.base.err_detail = c_string("Codec bit-depth 8 not supported in profile > 1");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((extra_cfg.color_space == cast,no_check(u32) CS_UNKNOWN || extra_cfg.color_space > cast,no_check(u32) CS_UNKNOWN) && extra_cfg.color_space <= cast,no_check(u32) CS_SRGB) {
        ctx.base.err_detail = c_string("color_space out of range [VPX_CS_UNKNOWN..VPX_CS_SRGB]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if !((extra_cfg.color_range == cast,no_check(u32) CR_STUDIO_RANGE || extra_cfg.color_range > cast,no_check(u32) CR_STUDIO_RANGE) && extra_cfg.color_range <= cast,no_check(u32) CR_FULL_RANGE) {
        ctx.base.err_detail = c_string("color_range out of range [VPX_CR_STUDIO_RANGE..VPX_CR_FULL_RANGE]");

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
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

valid_ref_frame_size_in_vp9_cx_iface :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

encoder_get_cxdata :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, iter: *Codec_Iter_T) -> *Codec_Cx_Pkt_T {
    return codec_pkt_list_get(*ctx.pkt_list.head, iter);
}

encoder_encode :: (
    ctx: *Codec_Alg_Priv_in_vp9_cx_iface,
    img: *Image_T,
    pts_val: Codec_Pts_T,
    duration: u64,
    enc_flags: Enc_Frame_Flags_T,
    deadline: Enc_Deadline_T
) -> Codec_Err_T {
    res: Codec_Err_T = ---;
    flags := enc_flags;
    pts := pts_val;
    CPI := ctx.cpi;
    TIMEBASE_IN_TS := *ctx.oxcf.g_timebase_in_ts;
    data_sz: u64 = ---;
    pkt: Codec_Cx_Pkt_T = ---;
    fill_memory(*pkt, 0, size_of(Codec_Cx_Pkt_T));

    if CPI == null {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    CPI.last_coded_width = ctx.oxcf.width;
    CPI.last_coded_height = ctx.oxcf.height;

    if img != null {
        res = validate_img_in_vp9_cx_iface(ctx, img);
        if res != cast,no_check(u32) CODEC_OK {
            return res;
        }

        data_sz =
            cast,no_check(u64) (((ctx.cfg.g_w * ctx.cfg.g_h * cast,no_check(u32) get_image_bps(img)) / 8) *
                (ifx CPI.multi_layer_arf != 0 then cast(u32) 8 else 2));
        if data_sz < K_MIN_COMPRESSED_SIZE {
            data_sz = K_MIN_COMPRESSED_SIZE;
        }
        if ctx.cx_data == null || ctx.cx_data_sz < data_sz {
            ctx.cx_data_sz = data_sz;
            c_transpiler_deallocate_memory(ctx.cx_data);
            ctx.cx_data = cast(*u8) c_transpiler_allocate_memory(ctx.cx_data_sz);
            if ctx.cx_data == null {
                return cast,no_check(Codec_Err_T) CODEC_MEM_ERROR;
            }
        }

        chroma_subsampling: s32 = -1;
        if (img.fmt & cast,no_check(u32) IMG_FMT_I420) == cast,no_check(u32) IMG_FMT_I420 ||
            (img.fmt & cast,no_check(u32) IMG_FMT_NV12) == cast,no_check(u32) IMG_FMT_NV12 ||
            (img.fmt & cast,no_check(u32) IMG_FMT_YV12) == cast,no_check(u32) IMG_FMT_YV12 {
            chroma_subsampling = 1;
        } else if (img.fmt & cast,no_check(u32) IMG_FMT_I422) == cast,no_check(u32) IMG_FMT_I422 {
            chroma_subsampling = 2;
        } else if (img.fmt & cast,no_check(u32) IMG_FMT_I444) == cast,no_check(u32) IMG_FMT_I444 {
            chroma_subsampling = 3;
        }
        if chroma_subsampling > ctx.global_header_subsampling {
            ctx.global_header_subsampling = chroma_subsampling;
        }
    }

    res = pick_quickcompress_mode_in_vp9_cx_iface(ctx, duration, deadline);
    if res != cast,no_check(u32) CODEC_OK {
        return res;
    }
    ctx.pkt_list.alloc_.head.cnt = 0;
    assignment_1: u32 = cast,no_check(u32) ((256 * cast(u64) size_of(Codec_Cx_Pkt)) / size_of(Codec_Cx_Pkt));
    (ctx.pkt_list.alloc_.head.max) = assignment_1;

    if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 22) != 0 &&
        flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 19) != 0 ||
        flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 23) != 0 &&
            flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 24) != 0 {
        ctx.base.err_detail = c_string("Conflicting flags.");
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    if setjmp_2(CPI.common.error.jmp.data) != 0 {
        CPI.common.error.setjmp = 0;
        res = update_error_state_in_vp9_cx_iface(ctx, *CPI.common.error);

        return res;
    }
    CPI.common.error.setjmp = 1;

    vp9_apply_encoding_flags(CPI, flags);

    if ctx.cfg.kf_mode == cast,no_check(u32) KF_AUTO && ctx.cfg.kf_min_dist == ctx.cfg.kf_max_dist {
        if c_transpiler_pre_increment(*(ctx.fixed_kf_cntr)) > ctx.cfg.kf_min_dist {
            flags |= cast,no_check(Enc_Frame_Flags_T) (1);
            ctx.fixed_kf_cntr = 1;
        }
    }

    lib_flags: u32 = 0;
    size: u64 = ---;

    if flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 1) != 0 && ctx.cfg.g_lag_in_frames != 0 {
        internal_error(
            *ctx.cpi.common.error,
            cast,no_check(Codec_Err_T) CODEC_INCAPABLE,
            c_string("Cannot calculate per-frame PSNR when g_lag_in_frames is nonzero")
        );
    }

    CPI.b_calculate_psnr =
        cast(s32) (ctx.base.init_flags & 0x10000 != 0 ||
            flags & cast,no_check(Enc_Frame_Flags_T) ((cast(s32) 1) << 1) != 0);

    if img != null {
        sd: YV12_BUFFER_CONFIG = ---;

        if ctx.pts_offset_initialized == 0 {
            ctx.pts_offset = pts;
            ctx.pts_offset_initialized = 1;
        }
        if pts < ctx.pts_offset {
            internal_error(
                *CPI.common.error,
                cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM,
                c_string("pts is smaller than initial pts")
            );
        }
        pts -= ctx.pts_offset;
        if pts > 9223372036854775807 / TIMEBASE_IN_TS.num {
            internal_error(
                *CPI.common.error,
                cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM,
                c_string("conversion of relative pts to ticks would overflow")
            );
        }
        DST_TIME_STAMP := timebase_units_to_ticks(TIMEBASE_IN_TS, pts);

        CPI.svc.timebase_fac = timebase_units_to_ticks(TIMEBASE_IN_TS, 1);
        CPI.svc.time_stamp_superframe = DST_TIME_STAMP;

        if duration > 9223372036854775807 {
            internal_error(
                *CPI.common.error,
                cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM,
                c_string("duration is too big")
            );
        }

        if pts > 9223372036854775807 - cast,no_check(s64) duration {
            internal_error(
                *CPI.common.error,
                cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM,
                c_string("relative pts + duration is too big")
            );
        }
        pts_end := pts + cast,no_check(s64) duration;
        if pts_end > 9223372036854775807 / TIMEBASE_IN_TS.num {
            internal_error(
                *CPI.common.error,
                cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM,
                c_string("conversion of relative pts + duration to ticks would overflow")
            );
        }
        DST_END_TIME_STAMP := timebase_units_to_ticks(TIMEBASE_IN_TS, pts_end);
        res = image2yuvconfig_2(img, *sd);

        if vp9_receive_raw_frame(CPI, flags | ctx.next_frame_flags, *sd, DST_TIME_STAMP, DST_END_TIME_STAMP) != 0 {
            res = update_error_state_in_vp9_cx_iface(ctx, *CPI.common.error);
        }
        ctx.next_frame_flags = 0;
    }

    cx_data := ctx.cx_data;
    cx_data_sz := ctx.cx_data_sz;

    if ctx.pending_cx_data != null {
        move_memory(cx_data, ctx.pending_cx_data, ctx.pending_cx_data_sz);
        ctx.pending_cx_data = cx_data;
        cx_data += ctx.pending_cx_data_sz;
        cx_data_sz -= ctx.pending_cx_data_sz;

        if cx_data_sz < ctx.cx_data_sz / 2 {
            internal_error(
                *CPI.common.error,
                cast,no_check(Codec_Err_T) CODEC_ERROR,
                c_string("Compressed data buffer too small")
            );
        }
    }

    if CPI.oxcf.pass == 1 && CPI.use_svc == 0 {
        if img != null {
            dst_time_stamp: s64 = ---;
            dst_end_time_stamp: s64 = ---;
            fps_pkt: Codec_Cx_Pkt_T = ---;
            encode_frame_result: ENCODE_FRAME_RESULT = ---;
            vp9_init_encode_frame_result(*encode_frame_result);

            ret :=
                vp9_get_compressed_data(
                    CPI,
                    *lib_flags,
                    *size,
                    cx_data,
                    cx_data_sz,
                    *dst_time_stamp,
                    *dst_end_time_stamp,
                    cast(s32) (img == null),
                    *encode_frame_result
                );

            get_first_pass_stats_pkt(*fps_pkt, *CPI.twopass.this_frame_stats);
            codec_pkt_list_add(*ctx.pkt_list.head, *fps_pkt);
        } else if CPI.twopass.first_pass_done == 0 {
            fps_pkt: Codec_Cx_Pkt_T = ---;
            vp9_end_first_pass(CPI);
            get_first_pass_stats_pkt(*fps_pkt, *CPI.twopass.total_stats);
            codec_pkt_list_add(*ctx.pkt_list.head, *fps_pkt);
        }
    } else {
        encode_frame_result: ENCODE_FRAME_RESULT = ---;
        dst_time_stamp: s64 = ---;
        dst_end_time_stamp: s64 = ---;
        vp9_init_encode_frame_result(*encode_frame_result);
        while cx_data_sz >= ctx.cx_data_sz / 2 && -1 != vp9_get_compressed_data(
            CPI,
            *lib_flags,
            *size,
            cx_data,
            cx_data_sz,
            *dst_time_stamp,
            *dst_end_time_stamp,
            cast(s32) (img == null),
            *encode_frame_result
        ) {
            if size > 0 {
                psnr: PSNR_STATS = ---;
                if vp9_get_psnr(CPI, *psnr) != 0 {
                    psnr_pkt: Codec_Cx_Pkt_T = ---;
                    get_psnr_pkt(*psnr_pkt, *psnr);
                    codec_pkt_list_add(*ctx.pkt_list.head, *psnr_pkt);
                }
            }

            if size != 0 || CPI.use_svc != 0 && CPI.svc.skip_enhancement_layer != 0 {
                if CPI.common.show_frame == 0 || CPI.use_svc != 0 && CPI.svc.spatial_layer_id < CPI.svc.number_spatial_layers - 1 {
                    if ctx.pending_cx_data == null {
                        ctx.pending_cx_data = cx_data;
                    }
                    ctx.pending_cx_data_sz += size;
                    if size != 0 {
                        ctx.pending_frame_sizes[ctx.pending_frame_count] = size;
                        ctx.pending_frame_count += 1;
                    }
                    ctx.pending_frame_magnitude |= size;
                    cx_data += size;
                    cx_data_sz -= size;
                    pkt.data.frame.width[CPI.svc.spatial_layer_id] = cast,no_check(u32) CPI.common.width;
                    pkt.data.frame.height[CPI.svc.spatial_layer_id] = cast,no_check(u32) CPI.common.height;
                    pkt.data.frame.spatial_layer_encoded[CPI.svc.spatial_layer_id] =
                        cast,no_check(u8) (1 -
                            CPI.svc.drop_spatial_layer[CPI.svc.spatial_layer_id]);

                    if ctx.output_cx_pkt_cb.output_cx_pkt != null {
                        pkt.kind = cast,no_check(Codec_Cx_Pkt_Kind) CODEC_CX_FRAME_PKT;
                        pkt.data.frame.pts = ticks_to_timebase_units(TIMEBASE_IN_TS, dst_time_stamp) + ctx.pts_offset;
                        pkt.data.frame.duration =
                            cast,no_check(u64) ticks_to_timebase_units(
                                TIMEBASE_IN_TS,
                                dst_end_time_stamp - dst_time_stamp
                            );
                        pkt.data.frame.flags = get_frame_pkt_flags(CPI, lib_flags);
                        pkt.data.frame.buf = cast(*void) ctx.pending_cx_data;
                        pkt.data.frame.sz = size;
                        ctx.pending_cx_data = null;
                        ctx.pending_cx_data_sz = 0;
                        ctx.pending_frame_count = 0;
                        ctx.pending_frame_magnitude = 0;
                        ctx.output_cx_pkt_cb.output_cx_pkt(*pkt, ctx.output_cx_pkt_cb.user_priv);
                    }
                    continue;
                }

                pkt.kind = cast,no_check(Codec_Cx_Pkt_Kind) CODEC_CX_FRAME_PKT;
                pkt.data.frame.pts = ticks_to_timebase_units(TIMEBASE_IN_TS, dst_time_stamp) + ctx.pts_offset;
                pkt.data.frame.duration =
                    cast,no_check(u64) ticks_to_timebase_units(
                        TIMEBASE_IN_TS,
                        dst_end_time_stamp - dst_time_stamp
                    );
                pkt.data.frame.flags = get_frame_pkt_flags(CPI, lib_flags);
                pkt.data.frame.width[CPI.svc.spatial_layer_id] = cast,no_check(u32) CPI.common.width;
                pkt.data.frame.height[CPI.svc.spatial_layer_id] = cast,no_check(u32) CPI.common.height;
                pkt.data.frame.spatial_layer_encoded[CPI.svc.spatial_layer_id] =
                    cast,no_check(u8) (1 -
                        CPI.svc.drop_spatial_layer[CPI.svc.spatial_layer_id]);

                if ctx.pending_cx_data != null {
                    if size != 0 {
                        ctx.pending_frame_sizes[ctx.pending_frame_count] = size;
                        ctx.pending_frame_count += 1;
                    }
                    ctx.pending_frame_magnitude |= size;
                    ctx.pending_cx_data_sz += size;

                    if ctx.output_cx_pkt_cb.output_cx_pkt == null && ctx.pending_frame_count > 0 {
                        size += cast,no_check(u64) write_superframe_index(ctx);
                    }
                    pkt.data.frame.buf = cast(*void) ctx.pending_cx_data;
                    pkt.data.frame.sz = ctx.pending_cx_data_sz;
                    ctx.pending_cx_data = null;
                    ctx.pending_cx_data_sz = 0;
                    ctx.pending_frame_count = 0;
                    ctx.pending_frame_magnitude = 0;
                } else {
                    pkt.data.frame.buf = cast(*void) cx_data;
                    pkt.data.frame.sz = size;
                }
                pkt.data.frame.partition_id = -1;

                if ctx.output_cx_pkt_cb.output_cx_pkt != null {
                    ctx.output_cx_pkt_cb.output_cx_pkt(*pkt, ctx.output_cx_pkt_cb.user_priv);
                } else {
                    codec_pkt_list_add(*ctx.pkt_list.head, *pkt);
                }

                cx_data += size;
                cx_data_sz -= size;
                if is_one_pass_svc(CPI) != 0 && CPI.svc.spatial_layer_id == CPI.svc.number_spatial_layers - 1 {
                    break;
                }
            }
        }
    }

    CPI.common.error.setjmp = 0;
    return res;
}

is_one_pass_svc :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if CPI.use_svc != 0 && CPI.oxcf.pass == 0 {
        return 1;
    }
    return 0;
}

write_superframe_index :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface) -> s32 {
    marker: u8 = 0xc0;
    mask: u32 = ---;
    mag: s32 = ---;

    marker = cast,no_check(u8) ((cast,no_check(s32) marker) | (ctx.pending_frame_count - 1));

    mag = 0;
    mask = 0xff;
    while mag < 4 {
        if ctx.pending_frame_magnitude < cast,no_check(u64) mask {
            break;
        }
        c_transpiler_compound_shl(*(mask), (cast(s32) 8), u32, u32);
        mask |= 0xff;
        mag += 1;
    }
    marker = cast,no_check(u8) ((cast,no_check(s32) marker) | (mag << 3));

    index_sz := 2 + (mag + 1) * ctx.pending_frame_count;
    cx_data_end := ctx.cx_data + ctx.cx_data_sz;
    pending_cx_data_end := ctx.pending_cx_data + ctx.pending_cx_data_sz;
    space_remaining := cx_data_end - pending_cx_data_end;
    if cast,no_check(s64) index_sz <= space_remaining {
        x: *u8 = pending_cx_data_end;
        j: s32 = ---;

        x.* = marker;
        x += 1;
        i: s32 = 0;
        while i < ctx.pending_frame_count {
            this_sz := cast,no_check(u32) ctx.pending_frame_sizes[i];

            j = 0;
            while j <= mag {
                x.* = cast,no_check(u8) (this_sz & 0xff);
                x += 1;
                c_transpiler_compound_shr(*(this_sz), (cast(s32) 8), u32, u32);
                j += 1;
            }
            i += 1;
        }
        x.* = marker;
        x += 1;
        ctx.pending_cx_data_sz += cast,no_check(u64) index_sz;
    } else {
        index_sz = 0;
    }
    return index_sz;
}

get_frame_pkt_flags :: (cpi: *VP9_COMP_in_vp9_encoder, lib_flags: u32) -> Codec_Frame_Flags_T {
    flags: Codec_Frame_Flags_T = lib_flags << 16;

    if lib_flags & cast,no_check(u32) FRAMEFLAGS_KEY_in_vp9_cx_iface != 0 ||
        cpi.use_svc != 0 &&
            cpi.svc.layer_context[cpi.svc.spatial_layer_id * cpi.svc.number_temporal_layers + cpi.svc.temporal_layer_id].is_key_frame != 0 {
        flags = cast,no_check(Codec_Frame_Flags_T) (flags | 0x1);
    }

    if cpi.common.show_frame == 0 {
        flags = cast,no_check(Codec_Frame_Flags_T) (flags | 0x4);
    }

    if cpi.droppable != 0 {
        flags = cast,no_check(Codec_Frame_Flags_T) (flags | 0x2);
    }

    return flags;
}

ticks_to_timebase_units :: (timestamp_ratio: *Rational64_T, n: s64) -> s64 {
    round := timestamp_ratio.num / 2;
    if round > 0 {
        round -= 1;
    }
    return ((n * cast(s64) timestamp_ratio.den) + round) / timestamp_ratio.num;
}

get_psnr_pkt :: (result: *Codec_Cx_Pkt_T, psnr: *PSNR_STATS) {
    pkt: Codec_Cx_Pkt_T = ---;
    pkt.kind = cast,no_check(Codec_Cx_Pkt_Kind) CODEC_PSNR_PKT;
    assignment_2: Psnr_Pkt = psnr.*;
    ((*pkt.data.psnr).*) = assignment_2;
    result.* = pkt;
}

get_first_pass_stats_pkt :: (result: *Codec_Cx_Pkt_T, stats: *FIRSTPASS_STATS_in_vp9_cx_iface) {
    pkt: Codec_Cx_Pkt_T = ---;
    pkt.kind = cast,no_check(Codec_Cx_Pkt_Kind) CODEC_STATS_PKT;
    pkt.data.twopass_stats.buf = cast(*void) stats;
    pkt.data.twopass_stats.sz = cast(u64) size_of(FIRSTPASS_STATS_in_vp9_cx_iface);
    result.* = pkt;
}

timebase_units_to_ticks :: (timestamp_ratio: *Rational64_T, n: s64) -> s64 {
    return n * timestamp_ratio.num / cast(s64) timestamp_ratio.den;
}

pick_quickcompress_mode_in_vp9_cx_iface :: (
    ctx: *Codec_Alg_Priv_in_vp9_cx_iface,
    duration: u64,
    deadline: Enc_Deadline_T
) -> Codec_Err_T {
    new_mode := cast,no_check(MODE_in_vp9_cx_iface) BEST;

    if ctx.cfg.g_pass == {
        case cast,no_check(u32) RC_ONE_PASS;
            if deadline > 0 {
                {
                    static_assert: Pick_Quickcompress_Mode_Static_Assert_Entry_in_vp9_cx_iface = ---;
                }

                if duration > (cast(u64) 18446744073709551615) / cast,no_check(u64) ctx.oxcf.g_timebase_in_ts.num {
                    ctx.base.err_detail = c_string("duration is too big");

                    return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
                }
                duration_us :=
                    (duration * cast,no_check(u64) ctx.oxcf.g_timebase_in_ts.num) /
                        ((cast,no_check(u64) ctx.oxcf.g_timebase_in_ts.den) * (10000000 / 1000000));

                new_mode =
                    cast,no_check(MODE_in_vp9_cx_iface) ((ifx deadline > duration_us then cast,no_check(s32) (GOOD) else cast,no_check(s32) (REALTIME)));
            } else {
                new_mode = cast,no_check(MODE_in_vp9_cx_iface) BEST;
            }
        case cast,no_check(u32) RC_FIRST_PASS;
        case cast,no_check(u32) RC_LAST_PASS;
            new_mode =
                cast,no_check(MODE_in_vp9_cx_iface) ((ifx deadline > 0 then cast,no_check(s32) (GOOD) else cast,no_check(s32) (BEST)));
    }

    if deadline == 1 {
        ctx.oxcf.pass = 0;
        new_mode = cast,no_check(MODE_in_vp9_cx_iface) REALTIME;
        ctx.oxcf.speed = ifx ctx.oxcf.speed > 5 then ctx.oxcf.speed else 5;
    }

    if ctx.oxcf.mode != new_mode {
        ctx.oxcf.mode = new_mode;
        vp9_change_config(ctx.cpi, *ctx.oxcf);
    }
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

get_image_bps :: (img: *Image_T) -> s32 {
    if img.fmt == {
        case cast,no_check(u32) IMG_FMT_YV12; #through;
        case cast,no_check(u32) IMG_FMT_NV12; #through;
        case cast,no_check(u32) IMG_FMT_I420;
            return 12;
        case cast,no_check(u32) IMG_FMT_I422;
            return 16;
        case cast,no_check(u32) IMG_FMT_I444;
            return 24;
        case cast,no_check(u32) IMG_FMT_I440;
            return 16;
        case cast,no_check(u32) IMG_FMT_I42016;
            return 24;
        case cast,no_check(u32) IMG_FMT_I42216;
            return 32;
        case cast,no_check(u32) IMG_FMT_I44416;
            return 48;
        case cast,no_check(u32) IMG_FMT_I44016;
            return 32;
        case;
    }
    return 0;
}

validate_img_in_vp9_cx_iface :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, img: *Image_T) -> Codec_Err_T {
    if img.fmt == {
        case cast,no_check(u32) IMG_FMT_YV12; #through;
        case cast,no_check(u32) IMG_FMT_I420; #through;
        case cast,no_check(u32) IMG_FMT_I42016; #through;
        case cast,no_check(u32) IMG_FMT_NV12;
        case cast,no_check(u32) IMG_FMT_I422; #through;
        case cast,no_check(u32) IMG_FMT_I444; #through;
        case cast,no_check(u32) IMG_FMT_I440;
            if ctx.cfg.g_profile != cast,no_check(u32) PROFILE_1 {
                ctx.base.err_detail =
                    c_string("Invalid image format. I422, I444, I440 images are not supported in profile.");

                return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
            }
        case cast,no_check(u32) IMG_FMT_I42216; #through;
        case cast,no_check(u32) IMG_FMT_I44416; #through;
        case cast,no_check(u32) IMG_FMT_I44016;
            if ctx.cfg.g_profile != cast,no_check(u32) PROFILE_1 && ctx.cfg.g_profile != cast,no_check(u32) PROFILE_3 {
                ctx.base.err_detail =
                    c_string("Invalid image format. 16-bit I422, I444, I440 images are not supported in profile.");

                return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
            }
        case;
            ctx.base.err_detail =
                c_string("Invalid image format. Only YV12, I420, I422, I444, I440, NV12 images are supported.");

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

ctrl_get_svc_ref_frame_config :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    CPI := ctx.cpi;
    data := c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);

    sl: s32 = 0;
    while sl <= CPI.svc.spatial_layer_id {
        data.update_buffer_slot[sl] = CPI.svc.update_buffer_slot[sl];
        data.reference_last[sl] = cast,no_check(s32) CPI.svc.reference_last[sl];
        data.reference_golden[sl] = cast,no_check(s32) CPI.svc.reference_golden[sl];
        data.reference_alt_ref[sl] = cast,no_check(s32) CPI.svc.reference_altref[sl];
        data.lst_fb_idx[sl] = CPI.svc.lst_fb_idx[sl];
        data.gld_fb_idx[sl] = CPI.svc.gld_fb_idx[sl];
        data.alt_fb_idx[sl] = CPI.svc.alt_fb_idx[sl];

        data.update_last[sl] = cast,no_check(s32) CPI.svc.update_last[sl];
        data.update_golden[sl] = cast,no_check(s32) CPI.svc.update_golden[sl];
        data.update_alt_ref[sl] = cast,no_check(s32) CPI.svc.update_altref[sl];
        sl += 1;
    }
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_get_level :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    ARG := c_transpiler_va_arg(cast(*void) (args), *s32);
    if ARG == null {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    ARG.* =
        cast,no_check(s32) (cast,no_check(#type (_: *Vp9_Level_Spec) -> VP9_LEVEL) (cast(*void) vp9_get_level))(
            *ctx.cpi.level_info.level_spec
        );
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_get_active_map :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    MAP := c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);

    if MAP != null {
        if vp9_get_active_map(ctx.cpi, MAP.active_map, cast,no_check(s32) MAP.rows, cast,no_check(s32) MAP.cols) == 0 {
            return cast,no_check(Codec_Err_T) CODEC_OK;
        }

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
}

ctrl_get_svc_layer_id :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    data := c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
    CPI := ctx.cpi;
    SVC_ := *CPI.svc;

    data.spatial_layer_id = SVC_.spatial_layer_id;
    data.temporal_layer_id = SVC_.temporal_layer_id;

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_get_reference :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    FRAME := c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);

    if FRAME != null {
        FB_IDX := ctx.cpi.common.cur_show_frame_fb_idx;
        fb := get_buf_frame_in_vp9_cx_iface(*ctx.cpi.common, FB_IDX);
        if fb == null {
            return cast,no_check(Codec_Err_T) CODEC_ERROR;
        }
        yuvconfig2image_2(*FRAME.img, fb, null);
        return cast,no_check(Codec_Err_T) CODEC_OK;
    }
    return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
}

get_buf_frame_in_vp9_cx_iface :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

ctrl_get_loopfilter_level :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    ARG := c_transpiler_va_arg(cast(*void) (args), *s32);
    if ARG == null {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    ARG.* = ctx.cpi.common.lf.filter_level;
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_get_quantizer_svc_layers :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    ARG := c_transpiler_va_arg(cast(*void) (args), *s32);

    if ARG == null {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    for i: 0..cast(s32) 5 - 1 {
        ARG[i] = ctx.cpi.svc.base_qindex[i];
    }
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_get_quantizer64 :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    ARG := c_transpiler_va_arg(cast(*void) (args), *s32);
    if ARG == null {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    ARG.* = vp9_qindex_to_quantizer(vp9_get_quantizer(ctx.cpi));
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_get_quantizer :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    ARG := c_transpiler_va_arg(cast(*void) (args), *s32);
    if ARG == null {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    ARG.* = vp9_get_quantizer(ctx.cpi);
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_set_quantizer_one_pass :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    CPI := ctx.cpi;
    QP := c_transpiler_va_arg(cast(*void) (args), s32);
    cfg := *ctx.cfg;
    extra_cfg := ctx.extra_cfg;

    if cfg.g_pass != cast,no_check(u32) RC_ONE_PASS {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    if QP < 0 || QP > 63 {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    cfg.rc_max_quantizer = cast,no_check(u32) QP;
    cfg.rc_min_quantizer = cfg.rc_max_quantizer;
    extra_cfg.aq_mode = cast,no_check(AQ_MODE) (cast(s32) 0);
    CPI.fixed_qp_onepass = 1;

    res := update_extra_cfg(ctx, *extra_cfg);
    return res;
}

update_extra_cfg :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, extra_cfg: *Vp9_Extracfg) -> Codec_Err_T {
    RES := validate_config_in_vp9_cx_iface(ctx, *ctx.cfg, extra_cfg);
    if RES == cast,no_check(u32) CODEC_OK {
        assignment_3: Vp9_Extracfg = extra_cfg.*;
        ((*ctx.extra_cfg).*) = assignment_3;
        set_encoder_config(*ctx.oxcf, *ctx.cfg, *ctx.extra_cfg);
        set_twopass_params_from_config(*ctx.cfg, ctx.cpi);
        vp9_change_config(ctx.cpi, *ctx.oxcf);
    }
    return RES;
}

ctrl_set_external_rate_control :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    funcs := (vp9_e_set_external_rate_control_value_in_vp9_cx_iface(args)).*;
    cpi := ctx.cpi;
    ext_ratectrl := *cpi.ext_ratectrl;
    oxcf := *cpi.oxcf;
    if oxcf.pass == 2 {
        frame_info := *cpi.frame_info;
        ratectrl_config: Rc_Config_T = ---;

        fill_memory(*ratectrl_config, 0, size_of(Rc_Config_T));

        ratectrl_config.frame_width = frame_info.frame_width;
        ratectrl_config.frame_height = frame_info.frame_height;
        ratectrl_config.show_frame_count = cpi.twopass.first_pass_info.num_frames;
        ratectrl_config.max_gf_interval = oxcf.max_gf_interval;
        ratectrl_config.min_gf_interval = oxcf.min_gf_interval;

        ratectrl_config.target_bitrate_kbps = cast,no_check(s32) (oxcf.target_bandwidth / 1000);
        ratectrl_config.frame_rate_num = oxcf.g_timebase.den;
        ratectrl_config.frame_rate_den = oxcf.g_timebase.num;
        ratectrl_config.overshoot_percent = oxcf.over_shoot_pct;
        ratectrl_config.undershoot_percent = oxcf.under_shoot_pct;
        ratectrl_config.min_base_q_index = oxcf.best_allowed_q;
        ratectrl_config.max_base_q_index = oxcf.worst_allowed_q;
        ratectrl_config.base_qp = oxcf.cq_level;

        if oxcf.rc_mode == cast,no_check(u32) VBR {
            ratectrl_config.rc_mode = cast,no_check(Ext_Rc_Mode_T) RC_VBR;
        } else if oxcf.rc_mode == cast,no_check(u32) Q {
            ratectrl_config.rc_mode = cast,no_check(Ext_Rc_Mode_T) RC_QMODE;
        } else if oxcf.rc_mode == cast,no_check(u32) CQ {
            ratectrl_config.rc_mode = cast,no_check(Ext_Rc_Mode_T) RC_CQ;
        }

        codec_status :=
            (cast,no_check(#type (_: Rc_Funcs_T, _: Rc_Config_T, _: *EXT_RATECTRL) -> Codec_Err_T) (cast(*void) vp9_extrc_create))(
                funcs,
                ratectrl_config,
                ext_ratectrl
            );
        if codec_status != cast,no_check(u32) CODEC_OK {
            return codec_status;
        }
    }
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

vp9_e_set_external_rate_control_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

ctrl_set_rtc_external_ratectrl_in_vp9_cx_iface :: (
    ctx: *Codec_Alg_Priv_in_vp9_cx_iface,
    args: *Va_List_Tag
) -> Codec_Err_T {
    CPI := ctx.cpi;
    DATA := c_transpiler_va_arg(cast(*void) (args), u32);
    if DATA != 0 {
        CPI.compute_frame_low_motion_onepass = 0;
        CPI.rc.constrain_gf_key_freq_onepass_vbr = 0;
        CPI.cyclic_refresh.content_mode = 0;
        CPI.disable_scene_detection_rtc_ratectrl = 1;
    }
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_set_disable_loopfilter :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    CPI := ctx.cpi;
    DATA := c_transpiler_va_arg(cast(*void) (args), u32);
    CPI.loopfilter_ctrl = DATA;
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_set_delta_q_uv :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    data := c_transpiler_va_arg(cast(*void) (args), s32);
    data = clamp_in_vp9_cx_iface(data, -15, 15);
    extra_cfg.delta_q_uv = data;
    return update_extra_cfg(ctx, *extra_cfg);
}

ctrl_set_svc_spatial_layer_sync :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    CPI := ctx.cpi;
    data := c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);

    sl: s32 = 0;
    while sl < CPI.svc.number_spatial_layers {
        CPI.svc.spatial_layer_sync[sl] = data.spatial_layer_sync[sl];
        sl += 1;
    }
    CPI.svc.set_intra_only_frame = cast,no_check(u8) data.base_layer_intra_only;
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_set_svc_gf_temporal_ref :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    CPI := ctx.cpi;
    DATA := c_transpiler_va_arg(cast(*void) (args), u32);
    CPI.svc.use_gf_temporal_ref = cast,no_check(s32) DATA;
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_set_svc_frame_drop_layer :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    CPI := ctx.cpi;
    data := c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);

    CPI.svc.framedrop_mode = data.framedrop_mode;
    sl: s32 = 0;
    while sl < CPI.svc.number_spatial_layers {
        CPI.svc.framedrop_thresh[sl] = data.framedrop_thresh[sl];
        sl += 1;
    }

    CPI.svc.max_consec_drop = ifx 1 > data.max_consec_drop then 1 else data.max_consec_drop;
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_set_svc_inter_layer_pred :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    DATA := c_transpiler_va_arg(cast(*void) (args), s32);
    CPI := ctx.cpi;
    CPI.svc.disable_inter_layer_pred = cast,no_check(INTER_LAYER_PRED) DATA;
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_enable_motion_vector_unit_test :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.motion_vector_unit_test = vp9_e_enable_motion_vector_unit_test_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_enable_motion_vector_unit_test_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

ctrl_set_disable_overshoot_maxq_cbr :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    CPI := ctx.cpi;
    DATA := c_transpiler_va_arg(cast(*void) (args), u32);
    CPI.rc.disable_overshoot_maxq_cbr = cast,no_check(s32) DATA;
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_set_postencode_drop :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    CPI := ctx.cpi;
    DATA := c_transpiler_va_arg(cast(*void) (args), u32);
    CPI.rc.ext_use_post_encode_drop = cast,no_check(s32) DATA;
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_set_row_mt :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.row_mt = vp9_e_set_row_mt_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_set_row_mt_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

ctrl_set_target_level :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.target_level = vp9_e_set_target_level_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_set_target_level_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

ctrl_set_render_size :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    RENDER_SIZE := c_transpiler_va_arg(cast(*void) (args), *s32);
    extra_cfg.render_width = RENDER_SIZE[0];
    extra_cfg.render_height = RENDER_SIZE[1];
    return update_extra_cfg(ctx, *extra_cfg);
}

ctrl_set_svc_ref_frame_config :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    CPI := ctx.cpi;
    data := c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);

    CPI.svc.use_set_ref_frame_config = 1;
    sl: s32 = 0;
    while sl < CPI.svc.number_spatial_layers {
        CPI.svc.update_buffer_slot[sl] = data.update_buffer_slot[sl];
        CPI.svc.reference_last[sl] = cast,no_check(u8) data.reference_last[sl];
        CPI.svc.reference_golden[sl] = cast,no_check(u8) data.reference_golden[sl];
        CPI.svc.reference_altref[sl] = cast,no_check(u8) data.reference_alt_ref[sl];
        CPI.svc.lst_fb_idx[sl] = data.lst_fb_idx[sl];
        CPI.svc.gld_fb_idx[sl] = data.gld_fb_idx[sl];
        CPI.svc.alt_fb_idx[sl] = data.alt_fb_idx[sl];
        CPI.svc.duration[sl] = data.duration[sl];
        sl += 1;
    }
    CPI.svc.temporal_layering_mode = cast,no_check(VP9_E_TEMPORAL_LAYERING_MODE) VP9E_TEMPORAL_LAYERING_MODE_BYPASS;
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_set_max_gf_interval :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.max_gf_interval = vp9_e_set_max_gf_interval_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_set_max_gf_interval_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

ctrl_set_min_gf_interval :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.min_gf_interval = vp9_e_set_min_gf_interval_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_set_min_gf_interval_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

ctrl_set_noise_sensitivity :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.noise_sensitivity = vp9_e_set_noise_sensitivity_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_set_noise_sensitivity_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

ctrl_set_color_range :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.color_range = cast,no_check(Color_Range_T) vp9_e_set_color_range_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_set_color_range_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

ctrl_set_color_space :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.color_space = cast,no_check(Color_Space_T) vp9_e_set_color_space_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_set_color_space_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

ctrl_set_tune_content :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.content = cast,no_check(Vp9e_Tune_Content) vp9_e_set_tune_content_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_set_tune_content_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

ctrl_set_svc_layer_id :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    DATA := c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
    CPI := ctx.cpi;
    SVC_ := *CPI.svc;

    if DATA.spatial_layer_id < 0 || DATA.spatial_layer_id >= cast,no_check(s32) ctx.cfg.ss_number_layers {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    SVC_.spatial_layer_to_encode = DATA.spatial_layer_id;
    SVC_.first_spatial_layer_to_encode = DATA.spatial_layer_id;

    SVC_.temporal_layer_id = DATA.temporal_layer_id;

    sl: s32 = 0;
    while sl < CPI.svc.number_spatial_layers {
        SVC_.temporal_layer_id_per_spatial[sl] = DATA.temporal_layer_id_per_spatial[sl];
        sl += 1;
    }

    if SVC_.temporal_layer_id < 0 || SVC_.temporal_layer_id >= cast,no_check(s32) ctx.cfg.ts_number_layers {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_register_cx_callback :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    cbp := cast(*Codec_Priv_Output_Cx_Pkt_Cb_Pair_T) (c_transpiler_va_arg(cast(*void) (args), *void));
    ctx.output_cx_pkt_cb.output_cx_pkt = cbp.output_cx_pkt;
    ctx.output_cx_pkt_cb.user_priv = cbp.user_priv;

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_set_svc_parameters :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    CPI := ctx.cpi;
    PARAMS := c_transpiler_va_arg(cast(*void) (args), *Svc_Extra_Cfg_T);
    tl: s32 = ---;

    sl: s32 = 0;
    while sl < CPI.svc.number_spatial_layers {
        tl = 0;
        while tl < CPI.svc.number_temporal_layers {
            LAYER := sl * CPI.svc.number_temporal_layers + tl;
            lc := CPI.svc.layer_context.data + LAYER;
            if PARAMS.max_quantizers[LAYER] < 0 ||
                PARAMS.max_quantizers[LAYER] > 63 ||
                PARAMS.min_quantizers[LAYER] < 0 ||
                PARAMS.min_quantizers[LAYER] > PARAMS.max_quantizers[LAYER] {
                return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
            }
            lc.max_q = PARAMS.max_quantizers[LAYER];
            lc.min_q = PARAMS.min_quantizers[LAYER];

            if PARAMS.scaling_factor_num[sl] < 1 ||
                PARAMS.scaling_factor_den[sl] < 1 ||
                PARAMS.scaling_factor_num[sl] > PARAMS.scaling_factor_den[sl] {
                return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
            }
            lc.scaling_factor_num = PARAMS.scaling_factor_num[sl];
            lc.scaling_factor_den = PARAMS.scaling_factor_den[sl];
            lc.speed = cast,no_check(u8) PARAMS.speed_per_layer[sl];
            lc.loopfilter_ctrl = PARAMS.loopfilter_ctrl[sl];
            tl += 1;
        }
        sl += 1;
    }

    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_set_svc :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    data := c_transpiler_va_arg(cast(*void) (args), s32);
    cfg := *ctx.cfg;

    if data == 1 && (cfg.g_pass == cast,no_check(u32) RC_FIRST_PASS || cfg.g_pass == cast,no_check(u32) RC_LAST_PASS) {
        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    vp9_set_svc(ctx.cpi, data);
    vp9_set_row_mt(ctx.cpi);
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_set_frame_periodic_boost :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.frame_periodic_boost = vp9_e_set_frame_periodic_boost_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_set_frame_periodic_boost_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

ctrl_set_alt_ref_aq :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.alt_ref_aq = vp9_e_set_alt_ref_aq_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_set_alt_ref_aq_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

ctrl_set_aq_mode :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.aq_mode = vp9_e_set_aq_mode_value_in_vp9_cx_iface(args);
    if ctx.cpi.fixed_qp_onepass != 0 {
        extra_cfg.aq_mode = cast,no_check(AQ_MODE) (cast(s32) 0);
    }
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_set_aq_mode_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

ctrl_set_frame_parallel_decoding_mode :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.frame_parallel_decoding_mode = vp9_e_set_frame_parallel_decoding_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_set_frame_parallel_decoding_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

ctrl_set_lossless :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.lossless = vp9_e_set_lossless_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_set_lossless_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

ctrl_set_rc_gf_cbr_boost_pct_in_vp9_cx_iface :: (
    ctx: *Codec_Alg_Priv_in_vp9_cx_iface,
    args: *Va_List_Tag
) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.gf_cbr_boost_pct = vp9_e_set_gf_cbr_boost_pct_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_set_gf_cbr_boost_pct_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

ctrl_set_rc_max_inter_bitrate_pct :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.rc_max_inter_bitrate_pct = vp9_e_set_max_inter_bitrate_pct_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_set_max_inter_bitrate_pct_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

ctrl_set_rc_max_intra_bitrate_pct :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.rc_max_intra_bitrate_pct = vp8_e_set_max_intra_bitrate_pct_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp8_e_set_max_intra_bitrate_pct_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

ctrl_set_cq_level :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.cq_level = vp8_e_set_cq_level_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp8_e_set_cq_level_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

ctrl_set_tuning :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.tuning = cast,no_check(Vp8e_Tuning) vp8_e_set_tuning_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp8_e_set_tuning_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

ctrl_set_arnr_type :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ctrl_set_arnr_strength :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.arnr_strength = vp8_e_set_arnr_strength_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp8_e_set_arnr_strength_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

ctrl_set_arnr_max_frames :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.arnr_max_frames = vp8_e_set_arnr_maxframes_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp8_e_set_arnr_maxframes_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

ctrl_set_validate_hbd_input :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.validate_hbd_input = cast,no_check(u32) vp9_e_set_validate_hbd_input_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_set_validate_hbd_input_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

ctrl_set_keyframe_filtering :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.enable_keyframe_filtering =
        cast,no_check(u32) vp9_e_set_key_frame_filtering_value_in_vp9_cx_iface(
            args
        );
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_set_key_frame_filtering_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

ctrl_set_tpl_model :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.enable_tpl_model = cast,no_check(u32) vp9_e_set_tpl_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_set_tpl_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

ctrl_set_tile_rows :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.tile_rows = cast,no_check(u32) vp9_e_set_tile_rows_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_set_tile_rows_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

ctrl_set_tile_columns :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.tile_columns = cast,no_check(u32) vp9_e_set_tile_columns_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp9_e_set_tile_columns_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

ctrl_set_static_thresh :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.static_thresh = vp8_e_set_static_threshold_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp8_e_set_static_threshold_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

ctrl_set_sharpness :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.sharpness = vp8_e_set_sharpness_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp8_e_set_sharpness_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

ctrl_set_enable_auto_alt_ref :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;
    extra_cfg.enable_auto_alt_ref = vp8_e_set_enableautoaltref_value_in_vp9_cx_iface(args);
    return update_extra_cfg(ctx, *extra_cfg);
}

vp8_e_set_enableautoaltref_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

ctrl_set_cpuused :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    extra_cfg := ctx.extra_cfg;

    extra_cfg.cpu_used = vp8_e_set_cpuused_value_in_vp9_cx_iface(args);
    extra_cfg.cpu_used = clamp_in_vp9_cx_iface(extra_cfg.cpu_used, -9, 9);

    return update_extra_cfg(ctx, *extra_cfg);
}

vp8_e_set_cpuused_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

ctrl_set_scale_mode :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    MODE_ := c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);

    if MODE_ != null {
        RES := vp9_set_internal_size(ctx.cpi, MODE_.h_scaling_mode, MODE_.v_scaling_mode);
        return cast,no_check(Codec_Err_T) ((ifx RES == 0 then cast,no_check(s32) (CODEC_OK) else cast,no_check(s32) (CODEC_INVALID_PARAM)));
    }
    return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
}

ctrl_set_active_map :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    MAP := c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);

    if MAP != null {
        if vp9_set_active_map(ctx.cpi, MAP.active_map, cast,no_check(s32) MAP.rows, cast,no_check(s32) MAP.cols) == 0 {
            return cast,no_check(Codec_Err_T) CODEC_OK;
        }

        return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    }
    return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
}

ctrl_set_roi_map :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    data := c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);

    if data != null {
        roi := data;
        return (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: *u8, _: u32, _: u32, _: *s32, _: *s32, _: *s32, _: *s32) -> Codec_Err_T) (cast(*void) vp9_set_roi_map))(
            ctx.cpi,
            roi.roi_map,
            roi.rows,
            roi.cols,
            roi.delta_q.data,
            roi.delta_lf.data,
            roi.skip.data,
            roi.ref_frame.data
        );
    }
    return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
}

ctrl_set_previewpp :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    return cast,no_check(Codec_Err_T) CODEC_INCAPABLE;
}

ctrl_set_reference :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    FRAME := c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);

    if FRAME != null {
        sd: YV12_BUFFER_CONFIG = ---;

        image2yuvconfig_2(*FRAME.img, *sd);
        (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: VP9_REFFRAME, _: *YV12_BUFFER_CONFIG) -> s32) (cast(*void) vp9_set_reference_enc))(
            ctx.cpi,
            ref_frame_to_vp9_reframe_in_vp9_cx_iface(FRAME.frame_type),
            *sd
        );
        return cast,no_check(Codec_Err_T) CODEC_OK;
    }
    return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
}

ref_frame_to_vp9_reframe_in_vp9_cx_iface :: (frame: Ref_Frame_Type_T) -> VP9_REFFRAME {
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

ctrl_copy_reference :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface, args: *Va_List_Tag) -> Codec_Err_T {
    FRAME := c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);

    if FRAME != null {
        sd: YV12_BUFFER_CONFIG = ---;

        image2yuvconfig_2(*FRAME.img, *sd);
        (cast,no_check(#type (_: *VP9_COMP_in_vp9_encoder, _: VP9_REFFRAME, _: *YV12_BUFFER_CONFIG) -> s32) (cast(*void) vp9_copy_reference_enc))(
            ctx.cpi,
            ref_frame_to_vp9_reframe_in_vp9_cx_iface(FRAME.frame_type),
            *sd
        );
        return cast,no_check(Codec_Err_T) CODEC_OK;
    }
    return cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
}

encoder_destroy :: (ctx: *Codec_Alg_Priv_in_vp9_cx_iface) -> Codec_Err_T {
    c_transpiler_deallocate_memory(ctx.cx_data);
    c_transpiler_deallocate_memory(ctx.global_headers.buf);
    vp9_remove_compressor(ctx.cpi);
    deallocate_memory(cast(*void) ctx.buffer_pool);
    deallocate_memory(cast(*void) ctx);
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

encoder_init :: (ctx: *Codec_Ctx_T, data: *Codec_Priv_Enc_Mr_Cfg_T) -> Codec_Err_T {
    res := cast,no_check(Codec_Err_T) CODEC_OK;

    if ctx.priv == null {
        PRIV :=
            cast(*Codec_Alg_Priv_in_vp9_cx_iface) calloc_2(
                1,
                size_of(Codec_Alg_Priv_in_vp9_cx_iface)
            );
        if PRIV == null {
            return cast,no_check(Codec_Err_T) CODEC_MEM_ERROR;
        }

        ctx.priv = cast(*Codec_Priv_T) PRIV;
        ctx.priv.init_flags = ctx.init_flags;
        ctx.priv.enc.total_encoders = 1;
        PRIV.buffer_pool = cast(*Buffer_Pool) calloc_2(1, size_of(Buffer_Pool));
        if PRIV.buffer_pool == null {
            return cast,no_check(Codec_Err_T) CODEC_MEM_ERROR;
        }

        if ctx.config.enc != null {
            assignment_4: Codec_Enc_Cfg_T = ctx.config.enc.*;
            ((*PRIV.cfg).*) = assignment_4;
            ctx.config.enc = *PRIV.cfg;
        }

        assignment_5: Vp9_Extracfg = default_extra_cfg;
        ((*PRIV.extra_cfg).*) = assignment_5;
        vp9_initialize_enc();

        res = validate_config_in_vp9_cx_iface(PRIV, *PRIV.cfg, *PRIV.extra_cfg);

        if res == cast,no_check(u32) CODEC_OK {
            PRIV.pts_offset_initialized = 0;
            PRIV.global_header_subsampling = -1;
            set_encoder_config(*PRIV.oxcf, *PRIV.cfg, *PRIV.extra_cfg);

            PRIV.cpi = vp9_create_compressor(*PRIV.oxcf, PRIV.buffer_pool);
            if PRIV.cpi == null {
                res = cast,no_check(Codec_Err_T) CODEC_MEM_ERROR;
            }
            set_twopass_params_from_config(*PRIV.cfg, PRIV.cpi);
        }
    }

    return res;
}

codec_vp9_cx :: () -> *Codec_Iface_T {
    return *CODEC_VP9_CX_ALGO;
}

vp8_e_set_roi_map_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_noise_sensitivity_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_type_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_temporal_layer_id_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_get_svc_layer_id_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_get_activemap_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_svc_ref_frame_config_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_level_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_postencode_drop_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_rtc_external_ratectrl_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_vp9_cx_iface :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

get_prob_in_vp9_cx_iface :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_cx_iface :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_cx_iface(n0, DEN);
}

weighted_prob_in_vp9_cx_iface :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_cx_iface :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_cx_iface(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_cx_iface(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_cx_iface :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_cx_iface[COUNT];
        PROB := get_prob_in_vp9_cx_iface(ct[0], DEN);
        return weighted_prob_in_vp9_cx_iface(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_lsb_in_vp9_cx_iface :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_cx_iface :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_cx_iface :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_cx_iface(num_values) + 1 else 0;
}

get_band_translate_in_vp9_cx_iface :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_cx_iface :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_cx_iface :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_cx_iface(above_ec, left_ec);
}

is_zero_mv_in_vp9_cx_iface :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_cx_iface :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_cx_iface :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_cx_iface(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_cx_iface(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_cx_iface :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_cx_iface :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_cx_iface :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_cx_iface :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

vp9_is_valid_scale_in_vp9_cx_iface :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_cx_iface :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_cx_iface(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_cx_iface :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_cx_iface :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_cx_iface :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_cx_iface :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_cx_iface :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_cx_iface :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_cx_iface :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_cx_iface :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_cx_iface :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_cx_iface :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_cx_iface(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_cx_iface :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_cx_iface(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_cx_iface(MI, ib)];
}

get_uv_tx_size_in_vp9_cx_iface :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_cx_iface :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_cx_iface :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_cx_iface(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_cx_iface :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_cx_iface :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_cx_iface :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_cx_iface :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_cx_iface :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_ref_frame_in_vp9_cx_iface :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_cx_iface :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_cx_iface :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_cx_iface :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_cx_iface :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_cx_iface :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_cx_iface :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_cx_iface(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_cx_iface :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_cx_iface(cm.mi_cols);

        if get_plane_type_in_vp9_cx_iface(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_cx_iface(cm, xd);
}

get_partition_probs_in_vp9_cx_iface :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_cx_iface :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_cx_iface :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_cx_iface :: (
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

update_partition_context_in_vp9_cx_iface :: (
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

partition_plane_context_in_vp9_cx_iface :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

cyclic_refresh_segment_id_boosted :: (segment_id: s32) -> s32 {
    if segment_id == 1 || segment_id == 2 {
        return 1;
    }
    return 0;
}

cyclic_refresh_segment_id :: (segment_id: s32) -> s32 {
    if segment_id == 1 {
        return 1;
    } else if segment_id == 2 {
        return 2;
    } else {
        return 0;
    }
}

fps_init_first_pass_info :: (
    first_pass_info: *FIRST_PASS_INFO,
    stats: *FIRSTPASS_STATS_in_vp9_cx_iface,
    num_frames: s32
) {
    first_pass_info.stats = stats;
    first_pass_info.num_frames = num_frames;
}

fps_get_num_frames :: (first_pass_info: *FIRST_PASS_INFO) -> s32 {
    return first_pass_info.num_frames;
}

fps_get_frame_stats :: (first_pass_info: *FIRST_PASS_INFO, show_idx: s32) -> *FIRSTPASS_STATS_in_vp9_cx_iface {
    if show_idx < 0 || show_idx >= first_pass_info.num_frames {
        return null;
    }
    return *(cast(*FIRSTPASS_STATS_in_vp9_cx_iface) (first_pass_info.stats))[show_idx];
}

get_buf_from_mv :: (buf: *Buf_2d, mv: *MV) -> *u8 {
    return *buf.buf[(cast(s32) mv.row) * buf.stride + cast(s32) mv.col];
}

cost_branch256 :: (ct: *u32, p: Prob) -> u64 {
    return ((cast,no_check(u64) ct[0]) * cast(u64) VP9_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP9_PROB_COST[256 - cast(s32) p];
}

treed_cost :: (tree: *Tree_Index, probs: *Prob, bits: s32, len: s32) -> s32 {
    cost: s32 = 0;
    i: Tree_Index = 0;

    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            cost +=
                cast,no_check(s32) (VP9_PROB_COST[(ifx BIT != 0 then 256 -
                    cast(s32) probs[(cast(s32) i) >> 1] else cast,no_check(s32) probs[(cast(s32) i) >> 1])]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }

    return cost;
}

rd_less_than_thresh :: (best_rd: s64, thresh: s32, THRESH_FACT: *s32) -> s32 {
    if best_rd < ((cast,no_check(s64) thresh) * cast(s64) THRESH_FACT.*) >> 5 || thresh == 2147483647 {
        return 1;
    }
    return 0;
}

set_error_per_bit :: (x: *MACROBLOCK, rdmult: s32) {
    x.errorperbit = rdmult >> 6;
    x.errorperbit += cast(s32) (x.errorperbit == 0);
}

write_in_vp9_cx_iface :: (br: *Writer, bit: s32, probability: s32) {
    count := br.count;
    range := br.range;
    lowvalue := br.lowvalue;

    split := 1 + ((range - 1) * cast,no_check(u32) probability) >> 8;

    range = split;

    if bit != 0 {
        lowvalue += split;
        range = br.range - split;
    }

    shift := cast,no_check(s32) NORM[range];

    c_transpiler_compound_shl(*(range), (((cast,no_check(u32) shift) & 31)), u32, u32);
    count += shift;

    if count >= 0 {
        offset := shift - count;

        if br.error == 0 {
            if lowvalue << (((offset - 1)) & 31) & 0x80000000 != 0 {
                x := (cast,no_check(s32) br.pos) - 1;

                while x >= 0 && br.buffer[x] == 0xff {
                    br.buffer[x] = 0;
                    x -= 1;
                }

                br.buffer[x] = cast,no_check(u8) ((cast,no_check(s32) br.buffer[x]) + 1);
            }

            if br.pos < br.size {
                br.buffer[br.pos] = cast,no_check(u8) (lowvalue >> (((24 - offset)) & 31) & 0xff);
                br.pos += 1;
            } else {
                br.error = 1;
            }
        }
        c_transpiler_compound_shl(*(lowvalue), (((cast,no_check(u32) offset) & 31)), u32, u32);
        shift = count;
        lowvalue &= 0xffffff;
        count -= 8;
    }

    c_transpiler_compound_shl(*(lowvalue), (((cast,no_check(u32) shift) & 31)), u32, u32);
    br.count = count;
    br.lowvalue = lowvalue;
    br.range = range;
}

write_bit_in_vp9_cx_iface :: (w: *Writer, bit: s32) {
    write_in_vp9_cx_iface(w, bit, 128);
}

write_literal_in_vp9_cx_iface :: (w: *Writer, data: s32, bits: s32) {
    bit := bits - 1;
    while bit >= 0 {
        write_bit_in_vp9_cx_iface(w, 1 & (data >> ((bit) & 31)));
        bit -= 1;
    }
}

vp9_write_tree :: (w: *Writer, tree: *Tree_Index, probs: *Prob, bits: s32, len: s32, i: Tree_Index) {
    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            write_in_vp9_cx_iface(w, BIT, cast,no_check(s32) probs[(cast(s32) i) >> 1]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }
}

vp9_write_token :: (w: *Writer, tree: *Tree_Index, probs: *Prob, token: *Vp9_Token) {
    vp9_write_tree(w, tree, probs, token.value, token.len, 0);
}

vp9_get_high_cost_table :: (bit_depth: s32) -> *u16 {
    return VP9_CAT6_HIGH_COST.data;
}

vp9_get_token_extra :: (v: s32, token: *s16, extra: *EXTRABIT) {
    if v >= 67 || v <= -67 {
        token.* = 10;
        if v >= 67 {
            extra.* = cast,no_check(EXTRABIT) (2 * v - cast,no_check(s32) ((2 * 67)));
        } else {
            extra.* = cast,no_check(EXTRABIT) ((-2 * v - cast,no_check(s32) ((2 * 67))) + 1);
        }
        return;
    }
    token.* = vp9_dct_cat_lt_10_value_tokens[v].token;
    extra.* = vp9_dct_cat_lt_10_value_tokens[v].extra;
}

vp9_get_token :: (v: s32) -> s16 {
    if v >= 67 || v <= -67 {
        return 10;
    }
    return vp9_dct_cat_lt_10_value_tokens[v].token;
}

vp9_get_token_cost :: (v: s32, token: *s16, cat6_high_table: *u16) -> s32 {
    if v >= 67 || v <= -67 {
        token.* = 10;
        extrabits := cast,no_check(EXTRABIT) (absolute_value(v) - 67);
        return (cast(s32) VP9_CAT6_LOW_COST[extrabits & 0xff]) + cast(s32) cat6_high_table[(cast(s32) extrabits) >> 8];
    }
    token.* = vp9_dct_cat_lt_10_value_tokens[v].token;
    return vp9_dct_cat_lt_10_value_cost[v];
}

is_lossless_requested :: (cfg: *VP9_Encoder_Config) -> s32 {
    if cfg.best_allowed_q == 0 && cfg.worst_allowed_q == 0 {
        return 1;
    }
    return 0;
}

stack_pop :: (stack: *s32, stack_size: s32) -> s32 {
    R := stack[0];
    if 1 < stack_size {
        for idx: 1..stack_size - 1 {
            stack[idx - 1] = stack[idx];
        }
    }

    return R;
}

stack_top :: (stack: *s32) -> s32 {
    return stack[0];
}

stack_push :: (stack: *s32, new_item: s32, stack_size: s32) {
    idx := stack_size;
    while idx > 0 {
        stack[idx] = stack[idx - 1];
        idx -= 1;
    }
    stack[0] = new_item;
}

stack_init :: (stack: *s32, length: s32) {
    if 0 < length {
        for idx: 0..length - 1 {
            stack[idx] = -1;
        }
    }
}

frame_is_kf_gf_arf :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if frame_is_intra_only_in_vp9_cx_iface(*cpi.common) != 0 ||
        cpi.refresh_alt_ref_frame != 0 ||
        cpi.refresh_golden_frame != 0 && cpi.rc.is_src_frame_alt_ref == 0 {
        return 1;
    }
    return 0;
}

ref_frame_to_flag :: (ref_frame: s8) -> s32 {

    return K_VP9_REF_FLAG_LIST[ref_frame];
}

get_ref_frame_map_idx :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame: MV_REFERENCE_FRAME) -> s32 {
    if ref_frame == 1 {
        return cpi.lst_fb_idx;
    } else if ref_frame == 2 {
        return cpi.gld_fb_idx;
    } else {
        return cpi.alt_fb_idx;
    }
}

get_ref_frame_buf_idx :: (CPI: *VP9_COMP_in_vp9_encoder, ref_frame: s32) -> s32 {
    CM := *CPI.common;
    MAP_IDX := get_ref_frame_map_idx(CPI, cast,no_check(MV_REFERENCE_FRAME) ref_frame);
    return ifx MAP_IDX != -1 then CM.ref_frame_map[MAP_IDX] else -1;
}

get_ref_cnt_buffer :: (cm: *VP9_COMMON, fb_idx: s32) -> *Ref_Cnt_Buffer {
    return ifx fb_idx != -1 then cm.buffer_pool.frame_bufs.data + fb_idx else null;
}

get_ref_frame_bufs :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame_bufs: **Ref_Cnt_Buffer) {
    CM := *cpi.common;

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame < 4 {
        ref_frame_buf_idx := get_ref_frame_buf_idx(cpi, cast,no_check(s32) ref_frame);
        inter_ref_idx := mv_ref_frame_to_inter_ref_idx_in_vp9_cx_iface(ref_frame);
        ref_frame_bufs[inter_ref_idx] = get_ref_cnt_buffer(CM, ref_frame_buf_idx);
        ref_frame += 1;
    }
}

get_ref_frame_buffer :: (CPI: *VP9_COMP_in_vp9_encoder, ref_frame: MV_REFERENCE_FRAME) -> *YV12_BUFFER_CONFIG {
    CM := *CPI.common;
    BUF_IDX := get_ref_frame_buf_idx(CPI, cast,no_check(s32) ref_frame);
    return ifx BUF_IDX != -1 then *CM.buffer_pool.frame_bufs[BUF_IDX].buf else null;
}

get_token_alloc :: (mb_rows: s32, mb_cols: s32) -> s64 {
    ALIGNED_MB_ROWS :=
        (mb_rows +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    ALIGNED_MB_COLS :=
        (mb_cols +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    return ((cast,no_check(s64) ALIGNED_MB_ROWS) * cast(s64) ALIGNED_MB_COLS) * cast,no_check(s64) ((cast,no_check(s32) ((16 * 16))) * 3 + 4);
}

allocated_tokens :: (tile: Tile_Info) -> s64 {
    tile_mb_rows := (tile.mi_row_end - tile.mi_row_start + 1) >> 1;
    tile_mb_cols := (tile.mi_col_end - tile.mi_col_start + 1) >> 1;

    return get_token_alloc(tile_mb_rows, tile_mb_cols);
}

get_start_tok :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    tile_row: s32,
    tile_col: s32,
    mi_row: s32,
    tok: **TOKENEXTRA_in_vp9_cx_iface
) {
    CM := *cpi.common;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    this_tile := *cpi.tile_data[tile_row * TILE_COLS + tile_col];
    TILE_INFO := *this_tile.tile_info;

    tile_mb_cols := (TILE_INFO.mi_col_end - TILE_INFO.mi_col_start + 1) >> 1;
    MB_ROW := (mi_row - TILE_INFO.mi_row_start) >> 1;

    tok.* = cpi.tile_tok[tile_row][tile_col] + get_token_alloc(MB_ROW, tile_mb_cols);
}

is_altref_enabled :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if !(CPI.oxcf.mode == cast,no_check(u32) REALTIME && CPI.oxcf.rc_mode == cast,no_check(u32) CBR) &&
        CPI.oxcf.lag_in_frames >= 4 &&
        CPI.oxcf.enable_auto_arf != 0 {
        return 1;
    }
    return 0;
}

set_ref_ptrs :: (CM: *VP9_COMMON, xd: *MACROBLOCKD, ref0: MV_REFERENCE_FRAME, ref1: MV_REFERENCE_FRAME) {
    xd.block_refs[0] = CM.frame_refs.data + (ifx ref0 >= 1 then (cast(s32) ref0) - 1 else 0);
    xd.block_refs[1] = CM.frame_refs.data + (ifx ref1 >= 1 then (cast(s32) ref1) - 1 else 0);
}

get_chessboard_index :: (FRAME_INDEX: s32) -> s32 {
    return FRAME_INDEX & 0x1;
}

cond_cost_list :: (cpi: *VP9_COMP_in_vp9_encoder, cost_list: *s32) -> *s32 {
    return ifx cpi.sf.mv.subpel_search_method != cast,no_check(u32) SUBPEL_TREE then cost_list else null;
}

get_num_vert_units :: (tile: Tile_Info, shift: s32) -> s32 {
    num_vert_units := (tile.mi_row_end - tile.mi_row_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_vert_units;
}

get_num_cols :: (tile: Tile_Info, shift: s32) -> s32 {
    num_cols := (tile.mi_col_end - tile.mi_col_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_cols;
}

log_tile_cols_from_picsize_level :: (width: u32, height: u32) -> s32 {
    PIC_SIZE := width * height;
    PIC_BREADTH := max(width, height);
    for i: 0..cast(s32) 14 - 1 {
        if VP9_LEVEL_DEFS[i].max_luma_picture_size >= PIC_SIZE && VP9_LEVEL_DEFS[i].max_luma_picture_breadth >= PIC_BREADTH {
            return get_msb_in_vp9_cx_iface(cast,no_check(u32) VP9_LEVEL_DEFS[i].max_col_tiles);
        }
    }
    return 2147483647;
}

alloc_frame_mvs :: (CM: *VP9_COMMON, buffer_idx: s32) {
    NEW_FB_PTR := CM.buffer_pool.frame_bufs.data + buffer_idx;
    if NEW_FB_PTR.mvs == null || NEW_FB_PTR.mi_rows < CM.mi_rows || NEW_FB_PTR.mi_cols < CM.mi_cols {
        deallocate_memory(cast(*void) NEW_FB_PTR.mvs);
        NEW_FB_PTR.mvs =
            cast(*MV_REF) calloc_2(
                cast,no_check(u64) (CM.mi_rows * CM.mi_cols),
                size_of(MV_REF)
            );

        if NEW_FB_PTR.mvs == null {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate new_fb_ptr->mvs")
            );
        }
        NEW_FB_PTR.mi_rows = CM.mi_rows;
        NEW_FB_PTR.mi_cols = CM.mi_cols;
    }
}

mv_cost :: (mv: *MV, joint_cost: *s32, comp_cost: **s32) -> s32 {
    return joint_cost[vp9_get_mv_joint_in_vp9_cx_iface(mv)] + comp_cost[0][mv.row] + comp_cost[1][mv.col];
}

mvsad_err_cost_in_vp9_cx_iface :: (x: *MACROBLOCK, mv: *MV, ref: *MV, sad_per_bit: s32) -> s32 {
    diff: MV = ---;
    diff.row = cast,no_check(s16) ((cast(s32) mv.row) - cast(s32) ref.row);
    diff.col = cast,no_check(s16) ((cast(s32) mv.col) - cast(s32) ref.col);
    return cast,no_check(s32) ((((cast,no_check(u32) mv_cost(*diff, x.nmvjointsadcost.data, x.nmvsadcost.data)) * cast,no_check(u32) sad_per_bit) + cast,no_check(u32) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9);
}

get_start_mv_sad :: (x: *MACROBLOCK, mvp_full: *MV, ref_mv_full: *MV, sad_fn_ptr: Sad_Fn_T, sadpb: s32) -> u32 {
    SRC_BUF_STRIDE := x.plane[0].src.stride;
    SRC_BUF := x.plane[0].src.buf;
    XD := *x.e_mbd;
    PRED_BUF_STRIDE := XD.plane[0].pre[0].stride;
    PRED_BUF := XD.plane[0].pre[0].buf + (cast(s32) mvp_full.row) * PRED_BUF_STRIDE + cast,no_check(s32) mvp_full.col;
    start_mv_sad: u32 = sad_fn_ptr(SRC_BUF, SRC_BUF_STRIDE, PRED_BUF, PRED_BUF_STRIDE);
    start_mv_sad += cast,no_check(u32) mvsad_err_cost_in_vp9_cx_iface(x, mvp_full, ref_mv_full, sadpb);

    return start_mv_sad;
}

num_4x4_to_edge :: (plane_4x4_dim: s32, mb_to_edge_dim: s32, subsampling_dim: s32, blk_dim: s32) -> s32 {
    return plane_4x4_dim + mb_to_edge_dim >> (((5 + subsampling_dim)) & 31) - blk_dim;
}

sum_squares_visible :: (
    xd: *MACROBLOCKD,
    PD: *Macroblockd_Plane,
    diff: *s16,
    DIFF_STRIDE: s32,
    blk_row: s32,
    blk_col: s32,
    PLANE_BSIZE: BLOCK_SIZE,
    TX_BSIZE: BLOCK_SIZE,
    visible_width: *s32,
    visible_height: *s32
) -> s64 {
    sse: s64 = ---;
    PLANE_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE];
    PLANE_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE];
    TX_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[TX_BSIZE];
    TX_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[TX_BSIZE];
    B4X4S_TO_RIGHT_EDGE := num_4x4_to_edge(PLANE_4X4_W, xd.mb_to_right_edge, PD.subsampling_x, blk_col);
    B4X4S_TO_BOTTOM_EDGE := num_4x4_to_edge(PLANE_4X4_H, xd.mb_to_bottom_edge, PD.subsampling_y, blk_row);
    if TX_BSIZE == 0 || B4X4S_TO_RIGHT_EDGE >= TX_4X4_W && B4X4S_TO_BOTTOM_EDGE >= TX_4X4_H {
        sse = cast,no_check(s64) sum_squares_2d_i16_c(diff, DIFF_STRIDE, TX_4X4_W << 2);
        visible_width.* = TX_4X4_W << 2;
        visible_height.* = TX_4X4_H << 2;
    } else {
        c: s32 = ---;
        MAX_R := min(B4X4S_TO_BOTTOM_EDGE, TX_4X4_H);
        MAX_C := min(B4X4S_TO_RIGHT_EDGE, TX_4X4_W);
        sse = 0;

        if 0 < MAX_R {
            for r: 0..MAX_R - 1 {
                c = 0;
                while c < MAX_C {
                    sse +=
                        cast,no_check(s64) sum_squares_2d_i16_c(
                            diff + r * DIFF_STRIDE * 4 + c * 4,
                            DIFF_STRIDE,
                            4
                        );
                    c += 1;
                }
            }
        }
        visible_width.* = MAX_C << 2;
        visible_height.* = MAX_R << 2;
    }
    return sse;
}

do_trellis_opt :: (
    pd: *Macroblockd_Plane,
    src_diff: *s16,
    diff_stride: s32,
    blk_row: s32,
    blk_col: s32,
    plane_bsize: BLOCK_SIZE,
    tx_size: TX_SIZE,
    arg: *void
) -> s32 {
    ARGS := cast(*Encode_B_Args) arg;
    X := ARGS.x;

    if ARGS.enable_trellis_opt == {
        case DISABLE_TRELLIS_OPT;
            return 0;
        case ENABLE_TRELLIS_OPT;
            return 1;
        case ENABLE_TRELLIS_OPT_TX_RD_SRC_VAR;
            {
                return ifx c_transpiler_float_greater(ARGS.trellis_opt_thresh, 0.0) then cast(s32) (c_transpiler_float_less_equal(X.log_block_src_var, ARGS.trellis_opt_thresh)) else 1;
            }
        case ENABLE_TRELLIS_OPT_TX_RD_RESIDUAL_MSE;
            {
                XD := *X.e_mbd;
                TX_BSIZE := TXSIZE_TO_BSIZE[tx_size];

                DEQUANT_SHIFT: s32 = 3;

                QSTEP := (cast(s32) pd.dequant[1]) >> ((DEQUANT_SHIFT) & 31);
                sse_calc_done := ARGS.sse_calc_done;
                sse := ARGS.sse;
                visible_width: s32 = 0;
                visible_height: s32 = 0;

                if XD.cur_buf.flags & 8 != 0 || sse == null || sse_calc_done == null {
                    return 1;
                }

                sse.* =
                    sum_squares_visible(
                        XD,
                        pd,
                        src_diff,
                        diff_stride,
                        blk_row,
                        blk_col,
                        plane_bsize,
                        TX_BSIZE,
                        *visible_width,
                        *visible_height
                    );
                sse_calc_done.* = 1;

                if c_transpiler_float_less_equal(cast,no_check(float64) sse.*, (((((cast,no_check(s64) visible_width) * cast(s64) visible_height) * cast(s64) QSTEP) * cast(s64) QSTEP) * ARGS.trellis_opt_thresh)) {
                    return 1;
                }
                return 0;
            }
        case;
            return 1;
    }
    return unreachable_value(s32);
}

vp9_get_encoder_config :: (
    result: *VP9_Encoder_Config,
    frame_width: s32,
    frame_height: s32,
    frame_rate: Rational_T,
    target_bitrate: s32,
    encode_speed: s32,
    target_level: s32,
    enc_pass: Enc_Pass
) {
    oxcf: VP9_Encoder_Config = ---;
    extra_cfg: Vp9_Extracfg = ---;
    get_extra_cfg(*extra_cfg);
    enc_cfg: Codec_Enc_Cfg_T = ---;
    get_enc_cfg(*enc_cfg, frame_width, frame_height, frame_rate, target_bitrate, enc_pass);
    set_encoder_config(*oxcf, *enc_cfg, *extra_cfg);

    oxcf.key_freq = 150;
    oxcf.under_shoot_pct = 100;
    oxcf.over_shoot_pct = 100;
    oxcf.max_threads = 0;
    oxcf.tile_columns = 0;
    oxcf.frame_parallel_decoding_mode = 0;
    oxcf.two_pass_vbrmax_section = 150;
    oxcf.speed = absolute_value(encode_speed);
    oxcf.target_level = cast,no_check(u32) target_level;
    result.* = oxcf;
}

get_extra_cfg :: (result: *Vp9_Extracfg) {
    extra_cfg: Vp9_Extracfg = default_extra_cfg;
    result.* = extra_cfg;
}

get_enc_cfg :: (
    result: *Codec_Enc_Cfg_T,
    frame_width: s32,
    frame_height: s32,
    frame_rate: Rational_T,
    target_bitrate: s32,
    enc_pass: Enc_Pass
) {
    enc_cfg := ENCODER_USAGE_CFG_MAP[0].cfg;
    enc_cfg.g_w = cast,no_check(u32) frame_width;
    enc_cfg.g_h = cast,no_check(u32) frame_height;
    enc_cfg.rc_target_bitrate = cast,no_check(u32) target_bitrate;
    enc_cfg.g_pass = enc_pass;

    enc_cfg.g_timebase.num = frame_rate.den;
    enc_cfg.g_timebase.den = frame_rate.num;
    result.* = enc_cfg;
}

vp9_dump_encoder_config :: (oxcf: *VP9_Encoder_Config, fp: *FILE_in_file) {
    fprintf(fp, c_string("profile %ld\n"), cast,no_check(s64) oxcf.profile);
    fprintf(fp, c_string("bit_depth %ld\n"), cast,no_check(s64) oxcf.bit_depth);
    fprintf(fp, c_string("width %ld\n"), cast,no_check(s64) oxcf.width);
    fprintf(fp, c_string("height %ld\n"), cast,no_check(s64) oxcf.height);
    fprintf(fp, c_string("input_bit_depth %ld\n"), cast,no_check(s64) oxcf.input_bit_depth);
    fprintf(fp, c_string("init_framerate %ld\n"), cast,no_check(s64) oxcf.init_framerate);

    fprintf(fp, c_string("target_bandwidth %ld\n"), oxcf.target_bandwidth);

    fprintf(fp, c_string("noise_sensitivity %ld\n"), cast,no_check(s64) oxcf.noise_sensitivity);
    fprintf(fp, c_string("sharpness %ld\n"), cast,no_check(s64) oxcf.sharpness);
    fprintf(fp, c_string("speed %ld\n"), cast,no_check(s64) oxcf.speed);
    fprintf(fp, c_string("rc_max_intra_bitrate_pct %ld\n"), cast,no_check(s64) oxcf.rc_max_intra_bitrate_pct);
    fprintf(fp, c_string("rc_max_inter_bitrate_pct %ld\n"), cast,no_check(s64) oxcf.rc_max_inter_bitrate_pct);
    fprintf(fp, c_string("gf_cbr_boost_pct %ld\n"), cast,no_check(s64) oxcf.gf_cbr_boost_pct);

    fprintf(fp, c_string("mode %ld\n"), cast,no_check(s64) oxcf.mode);
    fprintf(fp, c_string("pass %ld\n"), cast,no_check(s64) oxcf.pass);

    fprintf(fp, c_string("auto_key %ld\n"), cast,no_check(s64) oxcf.auto_key);
    fprintf(fp, c_string("key_freq %ld\n"), cast,no_check(s64) oxcf.key_freq);

    fprintf(fp, c_string("lag_in_frames %ld\n"), cast,no_check(s64) oxcf.lag_in_frames);

    fprintf(fp, c_string("rc_mode %ld\n"), cast,no_check(s64) oxcf.rc_mode);

    fprintf(fp, c_string("under_shoot_pct %ld\n"), cast,no_check(s64) oxcf.under_shoot_pct);
    fprintf(fp, c_string("over_shoot_pct %ld\n"), cast,no_check(s64) oxcf.over_shoot_pct);

    fprintf(fp, c_string("drop_frames_water_mark %ld\n"), cast,no_check(s64) oxcf.drop_frames_water_mark);

    fprintf(fp, c_string("fixed_q %ld\n"), cast,no_check(s64) oxcf.fixed_q);
    fprintf(fp, c_string("worst_allowed_q %ld\n"), cast,no_check(s64) oxcf.worst_allowed_q);
    fprintf(fp, c_string("best_allowed_q %ld\n"), cast,no_check(s64) oxcf.best_allowed_q);
    fprintf(fp, c_string("cq_level %ld\n"), cast,no_check(s64) oxcf.cq_level);
    fprintf(fp, c_string("aq_mode %ld\n"), cast,no_check(s64) oxcf.aq_mode);

    fprintf(fp, c_string("alt_ref_aq %ld\n"), cast,no_check(s64) oxcf.alt_ref_aq);

    fprintf(fp, c_string("resize_mode %ld\n"), cast,no_check(s64) oxcf.resize_mode);
    fprintf(fp, c_string("scaled_frame_width %ld\n"), cast,no_check(s64) oxcf.scaled_frame_width);
    fprintf(fp, c_string("scaled_frame_height %ld\n"), cast,no_check(s64) oxcf.scaled_frame_height);

    fprintf(fp, c_string("frame_periodic_boost %ld\n"), cast,no_check(s64) oxcf.frame_periodic_boost);

    fprintf(fp, c_string("two_pass_vbrbias %ld\n"), cast,no_check(s64) oxcf.two_pass_vbrbias);
    fprintf(fp, c_string("two_pass_vbrmin_section %ld\n"), cast,no_check(s64) oxcf.two_pass_vbrmin_section);
    fprintf(fp, c_string("two_pass_vbrmax_section %ld\n"), cast,no_check(s64) oxcf.two_pass_vbrmax_section);
    fprintf(fp, c_string("vbr_corpus_complexity %ld\n"), cast,no_check(s64) oxcf.vbr_corpus_complexity);

    fprintf(fp, c_string("ss_number_layers %ld\n"), cast,no_check(s64) oxcf.ss_number_layers);
    fprintf(fp, c_string("ts_number_layers %ld\n"), cast,no_check(s64) oxcf.ts_number_layers);

    fprintf(fp, c_string("enable_auto_arf %ld\n"), cast,no_check(s64) oxcf.enable_auto_arf);
    fprintf(fp, c_string("encode_breakout %ld\n"), cast,no_check(s64) oxcf.encode_breakout);
    fprintf(fp, c_string("error_resilient_mode %ld\n"), cast,no_check(s64) oxcf.error_resilient_mode);
    fprintf(fp, c_string("frame_parallel_decoding_mode %ld\n"), cast,no_check(s64) oxcf.frame_parallel_decoding_mode);

    fprintf(fp, c_string("arnr_max_frames %ld\n"), cast,no_check(s64) oxcf.arnr_max_frames);
    fprintf(fp, c_string("arnr_strength %ld\n"), cast,no_check(s64) oxcf.arnr_strength);

    fprintf(fp, c_string("min_gf_interval %ld\n"), cast,no_check(s64) oxcf.min_gf_interval);
    fprintf(fp, c_string("max_gf_interval %ld\n"), cast,no_check(s64) oxcf.max_gf_interval);

    fprintf(fp, c_string("tile_columns %ld\n"), cast,no_check(s64) oxcf.tile_columns);
    fprintf(fp, c_string("tile_rows %ld\n"), cast,no_check(s64) oxcf.tile_rows);

    fprintf(fp, c_string("enable_tpl_model %ld\n"), cast,no_check(s64) oxcf.enable_tpl_model);

    fprintf(fp, c_string("enable_keyframe_filtering %ld\n"), cast,no_check(s64) oxcf.enable_keyframe_filtering);

    fprintf(fp, c_string("max_threads %ld\n"), cast,no_check(s64) oxcf.max_threads);

    fprintf(fp, c_string("target_level %ld\n"), cast,no_check(s64) oxcf.target_level);

    fprintf(fp, c_string("tuning %ld\n"), cast,no_check(s64) oxcf.tuning);
    fprintf(fp, c_string("content %ld\n"), cast,no_check(s64) oxcf.content);

    fprintf(fp, c_string("color_space %ld\n"), cast,no_check(s64) oxcf.color_space);
    fprintf(fp, c_string("color_range %ld\n"), cast,no_check(s64) oxcf.color_range);
    fprintf(fp, c_string("render_width %ld\n"), cast,no_check(s64) oxcf.render_width);
    fprintf(fp, c_string("render_height %ld\n"), cast,no_check(s64) oxcf.render_height);
    fprintf(fp, c_string("temporal_layering_mode %ld\n"), cast,no_check(s64) oxcf.temporal_layering_mode);

    fprintf(fp, c_string("row_mt %ld\n"), cast,no_check(s64) oxcf.row_mt);
    fprintf(fp, c_string("motion_vector_unit_test %ld\n"), cast,no_check(s64) oxcf.motion_vector_unit_test);
    fprintf(fp, c_string("delta_q_uv %ld\n"), cast,no_check(s64) oxcf.delta_q_uv);
}

vp9_get_frame_info :: (result: *FRAME_INFO, oxcf: *VP9_Encoder_Config) {
    frame_info: FRAME_INFO = ---;
    dummy: s32 = ---;
    frame_info.frame_width = oxcf.width;
    frame_info.frame_height = oxcf.height;
    frame_info.render_frame_width = oxcf.width;
    frame_info.render_frame_height = oxcf.height;
    frame_info.bit_depth = oxcf.bit_depth;
    vp9_set_mi_size(*frame_info.mi_rows, *frame_info.mi_cols, *dummy, frame_info.frame_width, frame_info.frame_height);
    vp9_set_mb_size(
        *frame_info.mb_rows,
        *frame_info.mb_cols,
        *frame_info.num_mbs,
        frame_info.mi_rows,
        frame_info.mi_cols
    );

    result.* = frame_info;
}

globals_initialization_state_for_vp9_cx_iface: u32;
initialize_globals_for_vp9_cx_iface :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_cx_iface);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_cx_iface, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_cx_iface) != 2 {}
            return;
        }
    }
    default_extra_cfg =
        Vp9_Extracfg.{
            cpu_used = 0,
            enable_auto_alt_ref = 1,
            noise_sensitivity = 0,
            sharpness = 0,
            static_thresh = 0,
            tile_columns = 6,
            tile_rows = 0,
            enable_tpl_model = 1,
            enable_keyframe_filtering = 0,
            arnr_max_frames = 7,
            arnr_strength = 5,
            min_gf_interval = 0,
            max_gf_interval = 0,
            tuning = cast,no_check(Vp8e_Tuning) VP8_TUNE_PSNR,
            cq_level = 10,
            rc_max_intra_bitrate_pct = 0,
            rc_max_inter_bitrate_pct = 0,
            gf_cbr_boost_pct = 0,
            lossless = 0,
            target_level = 255,
            frame_parallel_decoding_mode = 1,
            aq_mode = cast,no_check(AQ_MODE) NO_AQ,
            alt_ref_aq = 0,
            frame_periodic_boost = 0,
            bit_depth = cast,no_check(Bit_Depth_T) BITS_8,
            content = cast,no_check(Vp9e_Tune_Content) VP9E_CONTENT_DEFAULT,
            color_space = cast,no_check(Color_Space_T) CS_UNKNOWN,
            color_range = cast,no_check(Color_Range_T) (cast(s32) 0),
            render_width = 0,
            render_height = 0,
            row_mt = 0,
            motion_vector_unit_test = 0,
            delta_q_uv = 0,
            validate_hbd_input = 1
        };
    K_MIN_COMPRESSED_SIZE = 8192;
    ENCODER_CTRL_MAPS =
        Codec_Ctrl_Fn_Map_T.[
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8_COPY_REFERENCE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_copy_reference},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8_SET_REFERENCE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_reference},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8_SET_POSTPROC), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_previewpp},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_ROI_MAP), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_roi_map},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_ACTIVEMAP), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_active_map},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_SCALEMODE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_scale_mode},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_CPUUSED), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_cpuused},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_ENABLEAUTOALTREF), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_enable_auto_alt_ref},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_SHARPNESS), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_sharpness},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_STATIC_THRESHOLD), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_static_thresh},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_TILE_COLUMNS), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_tile_columns},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_TILE_ROWS), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_tile_rows},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_TPL), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_tpl_model},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_KEY_FRAME_FILTERING), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_keyframe_filtering},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_VALIDATE_HBD_INPUT), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_validate_hbd_input},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_ARNR_MAXFRAMES), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_arnr_max_frames},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_ARNR_STRENGTH), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_arnr_strength},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_ARNR_TYPE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_arnr_type},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_TUNING), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_tuning},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_CQ_LEVEL), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_cq_level},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_SET_MAX_INTRA_BITRATE_PCT), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_rc_max_intra_bitrate_pct},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_MAX_INTER_BITRATE_PCT), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_rc_max_inter_bitrate_pct},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_GF_CBR_BOOST_PCT), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_rc_gf_cbr_boost_pct_in_vp9_cx_iface},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_LOSSLESS), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_lossless},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_FRAME_PARALLEL_DECODING), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_frame_parallel_decoding_mode},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_AQ_MODE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_aq_mode},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_ALT_REF_AQ), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_alt_ref_aq},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_FRAME_PERIODIC_BOOST), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_frame_periodic_boost},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_SVC), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_svc},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_SVC_PARAMETERS), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_svc_parameters},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_REGISTER_CX_CALLBACK), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_register_cx_callback},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_SVC_LAYER_ID), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_svc_layer_id},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_TUNE_CONTENT), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_tune_content},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_COLOR_SPACE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_color_space},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_COLOR_RANGE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_color_range},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_NOISE_SENSITIVITY), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_noise_sensitivity},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_MIN_GF_INTERVAL), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_min_gf_interval},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_MAX_GF_INTERVAL), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_max_gf_interval},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_SVC_REF_FRAME_CONFIG), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_svc_ref_frame_config},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_RENDER_SIZE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_render_size},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_TARGET_LEVEL), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_target_level},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_ROW_MT), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_row_mt},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_POSTENCODE_DROP), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_postencode_drop},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_DISABLE_OVERSHOOT_MAXQ_CBR), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_disable_overshoot_maxq_cbr},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_ENABLE_MOTION_VECTOR_UNIT_TEST), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_enable_motion_vector_unit_test},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_SVC_INTER_LAYER_PRED), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_svc_inter_layer_pred},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_SVC_FRAME_DROP_LAYER), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_svc_frame_drop_layer},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_SVC_GF_TEMPORAL_REF), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_svc_gf_temporal_ref},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_SVC_SPATIAL_LAYER_SYNC), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_svc_spatial_layer_sync},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_DELTA_Q_UV), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_delta_q_uv},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_DISABLE_LOOPFILTER), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_disable_loopfilter},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_RTC_EXTERNAL_RATECTRL), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_rtc_external_ratectrl_in_vp9_cx_iface},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_EXTERNAL_RATE_CONTROL), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_external_rate_control},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_SET_QUANTIZER_ONE_PASS), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_set_quantizer_one_pass},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_GET_LAST_QUANTIZER), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_get_quantizer},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP8E_GET_LAST_QUANTIZER_64), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_get_quantizer64},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_GET_LAST_QUANTIZER_SVC_LAYERS), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_get_quantizer_svc_layers},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_GET_LOOPFILTER_LEVEL), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_get_loopfilter_level},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9_GET_REFERENCE), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_get_reference},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_GET_SVC_LAYER_ID), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_get_svc_layer_id},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_GET_ACTIVEMAP), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_get_active_map},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_GET_LEVEL), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_get_level},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = cast,no_check(s32) (VP9E_GET_SVC_REF_FRAME_CONFIG), fn = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Va_List_Tag) -> Codec_Err_T) ctrl_get_svc_ref_frame_config},
            Codec_Ctrl_Fn_Map_T.{ctrl_id = -1, fn = null}
        ];
    ENCODER_USAGE_CFG_MAP =
        Codec_Enc_Cfg_Map_T.[
            Codec_Enc_Cfg_Map_T.{usage = 0, cfg = Codec_Enc_Cfg_T.{g_usage = 0, g_threads = 8, g_profile = 0, g_w = 320, g_h = 240, g_bit_depth = cast,no_check(Bit_Depth_T) BITS_8, g_input_bit_depth = 8, g_timebase = Rational.{num = 1, den = 30}, g_error_resilient = 0, g_pass = cast,no_check(Enc_Pass) RC_ONE_PASS, g_lag_in_frames = 25, rc_dropframe_thresh = 0, rc_resize_allowed = 0, rc_scaled_width = 0, rc_scaled_height = 0, rc_resize_up_thresh = 60, rc_resize_down_thresh = 30, rc_end_usage = cast,no_check(Rc_Mode) VBR, rc_twopass_stats_in = Fixed_Buf_T.{buf = null, sz = 0}, rc_firstpass_mb_stats_in = Fixed_Buf_T.{buf = null, sz = 0}, rc_target_bitrate = 256, rc_min_quantizer = 0, rc_max_quantizer = 63, rc_undershoot_pct = 25, rc_overshoot_pct = 25, rc_buf_sz = 6000, rc_buf_initial_sz = 4000, rc_buf_optimal_sz = 5000, rc_2pass_vbr_bias_pct = 50, rc_2pass_vbr_minsection_pct = 0, rc_2pass_vbr_maxsection_pct = 2000, rc_2pass_vbr_corpus_complexity = 0, kf_mode = cast,no_check(Kf_Mode) KF_AUTO, kf_min_dist = 0, kf_max_dist = 128, ss_number_layers = 1, ss_enable_auto_alt_ref = s32.[ 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0, cast,no_check(s32) 0 ], ss_target_bitrate = u32.[ 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0 ], ts_number_layers = 1, ts_target_bitrate = u32.[ 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0 ], ts_rate_decimator = u32.[ 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0 ], ts_periodicity = 0, ts_layer_id = u32.[ 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0 ], layer_target_bitrate = u32.[ 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0, cast,no_check(u32) 0 ], temporal_layering_mode = 0, use_vizier_rc_params = 0, active_wq_factor = Rational_T.{num = 1, den = 1}, err_per_mb_factor = Rational_T.{num = 1, den = 1}, sr_default_decay_limit = Rational_T.{num = 1, den = 1}, sr_diff_factor = Rational_T.{num = 1, den = 1}, kf_err_per_mb_factor = Rational_T.{num = 1, den = 1}, kf_frame_min_boost_factor = Rational_T.{num = 1, den = 1}, kf_frame_max_boost_first_factor = Rational_T.{num = 1, den = 1}, kf_frame_max_boost_subs_factor = Rational_T.{num = 1, den = 1}, kf_max_total_boost_factor = Rational_T.{num = 1, den = 1}, gf_max_total_boost_factor = Rational_T.{num = 1, den = 1}, gf_frame_max_boost_factor = Rational_T.{num = 1, den = 1}, zm_factor = Rational_T.{num = 1, den = 1}, rd_mult_inter_qp_fac = Rational_T.{num = 1, den = 1}, rd_mult_arf_qp_fac = Rational_T.{num = 1, den = 1}, rd_mult_key_qp_fac = Rational_T.{num = 1, den = 1}}}
        ];
    CODEC_VP9_CX_ALGO =
        Codec_Iface_T.{
            name = c_string("WebM Project VP9 Encoder v1.17.0"),
            abi_version = 5,
            caps = 0x2 | 0x10000,
            init = encoder_init,
            destroy = cast,no_check(#type (_: *Codec_Alg_Priv_T) -> Codec_Err_T) encoder_destroy,
            ctrl_maps = ENCODER_CTRL_MAPS.data,
            dec = Codec_Dec_Iface.{peek_si = null, get_si = null, decode = null, get_frame = null, set_fb_fn = null},
            enc =
                Codec_Enc_Iface.{cfg_map_count = 1, cfg_maps = ENCODER_USAGE_CFG_MAP.data, encode = cast,no_check(#type (
                    _: *Codec_Alg_Priv_T,
                    _: *Image_T,
                    _: Codec_Pts_T,
                    _: u64,
                    _: Enc_Frame_Flags_T,
                    _: Enc_Deadline_T
                ) -> Codec_Err_T) encoder_encode, get_cx_data = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Codec_Iter_T) -> *Codec_Cx_Pkt_T) encoder_get_cxdata, cfg_set = cast,no_check(#type (_: *Codec_Alg_Priv_T, _: *Codec_Enc_Cfg_T) -> Codec_Err_T) encoder_set_config, get_glob_hdrs = cast,no_check(#type (_: *Codec_Alg_Priv_T) -> *Fixed_Buf_T) encoder_get_global_headers, get_preview = cast,no_check(#type (_: *Codec_Alg_Priv_T) -> *Image_T) encoder_get_preview, mr_get_mem_loc = null, mr_free_mem_loc = null}
        };
    COUNT_TO_UPDATE_FACTOR_in_vp9_cx_iface =
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
    K_VP9_REF_FLAG_LIST =
        s32.[ 0, cast,no_check(s32) (VP9_LAST_FLAG), cast,no_check(s32) (VP9_GOLD_FLAG), cast,no_check(s32) (VP9_ALT_FLAG) ];
    SUB_PEL_FILTERS_12_in_vp9_cx_iface =
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
    FRAME_SCALE_FACTOR = s32.[ 16, 24 ];
    RATE_THRESH_MULT = float64.[ 1.0, 2.0 ];
    RCF_MULT = float64.[ 1.0, 2.0 ];
    atomic_store(*globals_initialization_state_for_vp9_cx_iface, 2);
}

fprintf :: (stream: *FILE_in_file, format: *s8, variadic_arguments: ..Any) -> s32 #foreign System_Library_libc_so_6;

Codec_Priv_Output_Cx_Pkt_Cb_Pair_T :: Codec_Enc_Output_Cx_Cb_Pair;

VP9_COMP_in_vp9_encoder :: struct {
    frame_info: FRAME_INFO #align 16;
    layout_padding_0: [8] u8 #align 1;
    quants: QUANTS #align 1;
    td: Thread_Data_in_vp9_encoder #align 1;
    mbmi_ext_base: *MB_MODE_INFO_EXT #align 1;
    layout_padding_1: [8] u8 #align 1;
    y_dequant: [256] [8] s16 #align 1;
    uv_dequant: [256] [8] s16 #align 1;
    common: VP9_COMMON #align 1;
    oxcf: VP9_Encoder_Config #align 1;
    lookahead: *Lookahead_Ctx_in_vp9_lookahead #align 1;
    alt_ref_source: *Lookahead_Entry_in_vp9_lookahead #align 1;
    source: *YV12_BUFFER_CONFIG #align 1;
    last_source: *YV12_BUFFER_CONFIG #align 1;
    un_scaled_source: *YV12_BUFFER_CONFIG #align 1;
    scaled_source: YV12_BUFFER_CONFIG #align 1;
    unscaled_last_source: *YV12_BUFFER_CONFIG #align 1;
    scaled_last_source: YV12_BUFFER_CONFIG #align 1;
    raw_source_frame: *YV12_BUFFER_CONFIG #align 1;
    tpl_bsize: BLOCK_SIZE #align 1;
    layout_padding_2: [7] u8 #align 1;
    tpl_stats: [50] Tpl_Dep_Frame #align 1;
    tpl_gop_stats: Tpl_Gop_Stats #align 1;
    tpl_recon_frames: [8] *YV12_BUFFER_CONFIG #align 1;
    enc_frame_buf: [8] Enc_Frame_Buf #align 1;
    kmeans_mutex: Pthread_Mutex_T #align 1;
    kmeans_data_arr_alloc: s32 #align 1;
    layout_padding_3: [4] u8 #align 1;
    kmeans_data_arr: *KMEANS_DATA #align 1;
    kmeans_data_size: s32 #align 1;
    kmeans_data_stride: s32 #align 1;
    kmeans_ctr_ls: [8] float64 #align 1;
    kmeans_boundary_ls: [8] float64 #align 1;
    kmeans_count_ls: [8] s32 #align 1;
    kmeans_ctr_num: s32 #align 1;
    layout_padding_4: [4] u8 #align 1;
    tile_data: *Tile_Data_Enc #align 1;
    allocated_tiles: s32 #align 1;
    scaled_ref_idx: [3] s32 #align 1;
    lst_fb_idx: s32 #align 1;
    gld_fb_idx: s32 #align 1;
    alt_fb_idx: s32 #align 1;
    ref_fb_idx: [8] s32 #align 1;
    refresh_last_frame: s32 #align 1;
    refresh_golden_frame: s32 #align 1;
    refresh_alt_ref_frame: s32 #align 1;
    ext_refresh_frame_flags_pending: s32 #align 1;
    ext_refresh_last_frame: s32 #align 1;
    ext_refresh_golden_frame: s32 #align 1;
    ext_refresh_alt_ref_frame: s32 #align 1;
    ext_refresh_frame_context_pending: s32 #align 1;
    ext_refresh_frame_context: s32 #align 1;
    norm_wiener_variance: s64 #align 1;
    mb_wiener_variance: *s64 #align 1;
    mb_wiener_var_rows: s32 #align 1;
    mb_wiener_var_cols: s32 #align 1;
    mi_ssim_rdmult_scaling_factors: *float64 #align 1;
    mi_ssim_rdmult_scaling_factors_rows: s32 #align 1;
    mi_ssim_rdmult_scaling_factors_cols: s32 #align 1;
    sb_mul_scale: *s64 #align 1;
    last_frame_uf: YV12_BUFFER_CONFIG #align 1;
    tile_tok: [4] [64] *TOKENEXTRA_in_vp9_cx_iface #align 1;
    tplist: [4] [64] *TOKENLIST_in_vp9_cx_iface #align 1;
    ambient_err: s64 #align 1;
    rd_ctrl: RD_CONTROL #align 1;
    rd: RD_OPT #align 1;
    coding_context: CODING_CONTEXT_in_vp9_cx_iface #align 1;
    nmvcosts: [2] *s32 #align 1;
    nmvcosts_hp: [2] *s32 #align 1;
    nmvsadcosts: [2] *s32 #align 1;
    nmvsadcosts_hp: [2] *s32 #align 1;
    last_time_stamp_seen: s64 #align 1;
    last_end_time_stamp_seen: s64 #align 1;
    first_time_stamp_ever: s64 #align 1;
    rc: RATE_CONTROL #align 1;
    framerate: float64 #align 1;
    interp_filter_selected: [8] [4] s32 #align 1;
    output_pkt_list: *Codec_Pkt_List #align 1;
    mbgraph_stats: [25] MBGRAPH_FRAME_STATS #align 1;
    mbgraph_n_frames: s32 #align 1;
    static_mb_pct: s32 #align 1;
    ref_frame_flags: s32 #align 1;
    layout_padding_5: [4] u8 #align 1;
    sf: SPEED_FEATURES_in_vp9_speed_features #align 1;
    max_mv_magnitude: u32 #align 1;
    mv_step_param: s32 #align 1;
    allow_comp_inter_inter: s32 #align 1;
    allow_encode_breakout: ENCODE_BREAKOUT_TYPE #align 1;
    encode_breakout: s32 #align 1;
    layout_padding_6: [4] u8 #align 1;
    segmentation_map: *u8 #align 1;
    skin_map: *u8 #align 1;
    segment_encode_breakout: [8] s32 #align 1;
    cyclic_refresh: *CYCLIC_REFRESH #align 1;
    active_map: Active_Map_in_vp9_encoder #align 1;
    find_fractional_mv_step: Fractional_Mv_Step_Fp_in_vp9_mcomp #align 1;
    me_sf: Scale_Factors #align 1;
    diamond_search_sad: Vp9_Diamond_Search_Fn_T #align 1;
    fn_ptr: [13] Vp9_Variance_Fn_Ptr_T #align 1;
    twopass: TWO_PASS #align 1;
    force_update_segmentation: u8 #align 1;
    layout_padding_7: [7] u8 #align 1;
    tf_buffer: YV12_BUFFER_CONFIG #align 1;
    alt_ref_aq: *ALT_REF_AQ #align 1;
    b_calculate_psnr: s32 #align 1;
    droppable: s32 #align 1;
    initial_width: s32 #align 1;
    initial_height: s32 #align 1;
    initial_mbs: s32 #align 1;
    last_coded_width: s32 #align 1;
    last_coded_height: s32 #align 1;
    use_svc: s32 #align 1;
    svc: SVC #align 1;
    frame_flags: s32 #align 1;
    layout_padding_8: [4] u8 #align 1;
    ss_cfg: Search_Site_Config_in_vp9_mcomp #align 1;
    mbmode_cost: [10] s32 #align 1;
    inter_mode_cost: [7] [4] u32 #align 1;
    intra_uv_mode_cost: [2] [10] [10] s32 #align 1;
    y_mode_costs: [10] [10] [10] s32 #align 1;
    switchable_interp_costs: [4] [3] s32 #align 1;
    partition_cost: [16] [4] s32 #align 1;
    tx_size_cost: [3] [2] [4] s32 #align 1;
    resize_pending: s32 #align 1;
    resize_state: RESIZE_STATE #align 1;
    external_resize: s32 #align 1;
    resize_scale_num: s32 #align 1;
    resize_scale_den: s32 #align 1;
    resize_avg_qp: s32 #align 1;
    resize_buffer_underflow: s32 #align 1;
    resize_count: s32 #align 1;
    use_skin_detection: s32 #align 1;
    target_level: s32 #align 1;
    noise_estimate: NOISE_ESTIMATE #align 1;
    layout_padding_9: [4] u8 #align 1;
    consec_zero_mv: *u8 #align 1;
    vbp_thresholds: [4] s64 #align 1;
    vbp_threshold_minmax: s64 #align 1;
    vbp_threshold_sad: s64 #align 1;
    vbp_threshold_copy: s64 #align 1;
    vbp_bsize_min: BLOCK_SIZE #align 1;
    layout_padding_10: [3] u8 #align 1;
    num_workers: s32 #align 1;
    workers: *Worker #align 1;
    tile_thr_data: *Enc_Worker_Data #align 1;
    lf_row_sync: VP9_Lf_Sync #align 1;
    vp9_bitstream_worker_data: *VP9_Bitstream_Worker_Data #align 1;
    keep_level_stats: s32 #align 1;
    layout_padding_11: [4] u8 #align 1;
    level_info: Vp9_Level_Info #align 1;
    multi_thread_ctxt: Multi_Thread_Handle #align 1;
    row_mt_sync_read_ptr: #type (_: *VP9_Row_MT_Sync, _: s32, _: s32);
    row_mt_sync_write_ptr: #type (_: *VP9_Row_MT_Sync, _: s32, _: s32, _: s32);
    arnr_filter_data: ARNR_Filter_Data #align 1;
    row_mt: s32 #align 1;
    row_mt_bit_exact: u32 #align 1;
    prev_partition: *BLOCK_SIZE #align 1;
    prev_segment_id: *s8 #align 1;
    prev_variance_low: *u8 #align 1;
    copied_frame_cnt: *u8 #align 1;
    max_copied_frame: u8 #align 1;
    last_frame_dropped: u8 #align 1;
    layout_padding_12: [6] u8 #align 1;
    content_state_sb_fd: *u8 #align 1;
    compute_source_sad_onepass: s32 #align 1;
    compute_frame_low_motion_onepass: s32 #align 1;
    level_constraint: Level_Constraint #align 1;
    count_arf_frame_usage: *u8 #align 1;
    count_lastgolden_frame_usage: *u8 #align 1;
    multi_layer_arf: s32 #align 1;
    layout_padding_13: [4] u8 #align 1;
    roi: Roi_Map_T #align 1;
    loopfilter_ctrl: LOOPFILTER_CONTROL #align 1;
    layout_padding_14: [4] u8 #align 1;
    ext_ratectrl: EXT_RATECTRL #align 1;
    fixed_qp_onepass: s32 #align 1;
    deadline_mode_previous_frame: MODE_in_vp9_cx_iface #align 1;
    disable_scene_detection_rtc_ratectrl: s32 #align 1;
    layout_padding_15: [4] u8 #align 1;
} #no_padding;

MODE_in_vp9_cx_iface :: u32;
GOOD : s32 : 0;
BEST : s32 : 1;
REALTIME : s32 : 2;

RESIZE_TYPE :: u32;
RESIZE_NONE : s32 : 0;
RESIZE_FIXED : s32 : 1;
RESIZE_DYNAMIC : s32 : 2;

Vp9e_Temporal_Layering_Mode :: u32;
VP9E_TEMPORAL_LAYERING_MODE_NOLAYERING : s32 : 0;
VP9E_TEMPORAL_LAYERING_MODE_BYPASS : s32 : 1;
VP9E_TEMPORAL_LAYERING_MODE_0101 : s32 : 2;
VP9E_TEMPORAL_LAYERING_MODE_0212 : s32 : 3;

VP9_E_TEMPORAL_LAYERING_MODE :: Vp9e_Temporal_Layering_Mode;

AQ_MODE :: u32;
NO_AQ : s32 : 0;
VARIANCE_AQ : s32 : 1;
COMPLEXITY_AQ : s32 : 2;
CYCLIC_REFRESH_AQ : s32 : 3;
EQUATOR360_AQ : s32 : 4;
PERCEPTUAL_AQ : s32 : 5;
PSNR_AQ : s32 : 6;
LOOKAHEAD_AQ : s32 : 7;
AQ_MODE_COUNT : s32 : 8;

VP9_LEVEL :: u32;
LEVEL_UNKNOWN : s32 : 0;
LEVEL_AUTO : s32 : 1;
LEVEL_1 : s32 : 10;
LEVEL_1_1 : s32 : 11;
LEVEL_2 : s32 : 20;
LEVEL_2_1 : s32 : 21;
LEVEL_3 : s32 : 30;
LEVEL_3_1 : s32 : 31;
LEVEL_4 : s32 : 40;
LEVEL_4_1 : s32 : 41;
LEVEL_5 : s32 : 50;
LEVEL_5_1 : s32 : 51;
LEVEL_5_2 : s32 : 52;
LEVEL_6 : s32 : 60;
LEVEL_6_1 : s32 : 61;
LEVEL_6_2 : s32 : 62;
LEVEL_MAX : s32 : 255;

Vp9e_Tune_Content :: u32;
VP9E_CONTENT_DEFAULT : s32 : 0;
VP9E_CONTENT_SCREEN : s32 : 1;
VP9E_CONTENT_FILM : s32 : 2;
VP9E_CONTENT_INVALID : s32 : 3;

Codec_Enc_Output_Cx_Pkt_Cb_Fn_T :: #type (_: *Codec_Cx_Pkt_T, _: *void);

FRAMETYPE_FLAGS_in_vp9_cx_iface :: u32;
FRAMEFLAGS_KEY_in_vp9_cx_iface : s32 : 1;
FRAMEFLAGS_GOLDEN_in_vp9_cx_iface : s32 : 2;
FRAMEFLAGS_ALTREF_in_vp9_cx_iface : s32 : 4;

Svc_Extra_Cfg_T :: Svc_Parameters;

MACROBLOCK :: Macroblock;

Vp9_Token :: struct {
    value: s32;
    len: s32;
}

EXTRABIT :: s16;

SUBPEL_SEARCH_METHODS :: u32;
SUBPEL_TREE : s32 : 0;
SUBPEL_TREE_PRUNED : s32 : 1;
SUBPEL_TREE_PRUNED_MORE : s32 : 2;
SUBPEL_TREE_PRUNED_EVENMORE : s32 : 3;

Encode_B_Args :: struct {
    x: *MACROBLOCK;
    enable_trellis_opt: s32;
    trellis_opt_thresh: float64;
    sse_calc_done: *s32;
    sse: *s64;
    ta: *ENTROPY_CONTEXT;
    tl: *ENTROPY_CONTEXT;
    skip: *s8;
}

ENABLE_TRELLIS_OPT_METHOD :: u32;
DISABLE_TRELLIS_OPT : s32 : 0;
ENABLE_TRELLIS_OPT : s32 : 1;
ENABLE_TRELLIS_OPT_TX_RD_SRC_VAR : s32 : 2;
ENABLE_TRELLIS_OPT_TX_RD_RESIDUAL_MSE : s32 : 3;

VP9_Encoder_Config :: struct {
    profile: BITSTREAM_PROFILE;
    bit_depth: Bit_Depth_T;
    width: s32;
    height: s32;
    input_bit_depth: u32;
    init_framerate: float64;
    g_timebase: Rational_T;
    g_timebase_in_ts: Rational64_T;
    target_bandwidth: s64;
    noise_sensitivity: s32;
    sharpness: s32;
    speed: s32;
    rc_max_intra_bitrate_pct: u32;
    rc_max_inter_bitrate_pct: u32;
    gf_cbr_boost_pct: u32;
    mode: MODE_in_vp9_cx_iface;
    pass: s32;
    auto_key: s32;
    key_freq: s32;
    lag_in_frames: s32;
    rc_mode: Rc_Mode;
    under_shoot_pct: s32;
    over_shoot_pct: s32;
    starting_buffer_level_ms: s64;
    optimal_buffer_level_ms: s64;
    maximum_buffer_size_ms: s64;
    drop_frames_water_mark: s32;
    fixed_q: s32;
    worst_allowed_q: s32;
    best_allowed_q: s32;
    cq_level: s32;
    aq_mode: AQ_MODE;
    alt_ref_aq: s32;
    resize_mode: RESIZE_TYPE;
    scaled_frame_width: s32;
    scaled_frame_height: s32;
    frame_periodic_boost: s32;
    two_pass_vbrbias: s32;
    two_pass_vbrmin_section: s32;
    two_pass_vbrmax_section: s32;
    vbr_corpus_complexity: s32;
    ss_number_layers: s32;
    ts_number_layers: s32;
    layer_target_bitrate: [12] s32;
    ss_target_bitrate: [5] s32;
    ss_enable_auto_arf: [5] s32;
    ts_rate_decimator: [5] s32;
    enable_auto_arf: s32;
    encode_breakout: s32;
    error_resilient_mode: u32;
    frame_parallel_decoding_mode: u32;
    arnr_max_frames: s32;
    arnr_strength: s32;
    min_gf_interval: s32;
    max_gf_interval: s32;
    tile_columns: s32;
    tile_rows: s32;
    enable_tpl_model: s32;
    enable_keyframe_filtering: s32;
    max_threads: s32;
    target_level: u32;
    two_pass_stats_in: Fixed_Buf_T;
    tuning: Vp8e_Tuning;
    content: Vp9e_Tune_Content;
    color_space: Color_Space_T;
    color_range: Color_Range_T;
    render_width: s32;
    render_height: s32;
    temporal_layering_mode: VP9_E_TEMPORAL_LAYERING_MODE;
    row_mt: s32;
    motion_vector_unit_test: u32;
    delta_q_uv: s32;
}

Codec_Enc_Output_Cx_Cb_Pair :: struct {
    output_cx_pkt: Codec_Enc_Output_Cx_Pkt_Cb_Fn_T;
    user_priv: *void;
}

Vp9_Ppflags_T :: struct {
    post_proc_flag: s32;
    deblocking_level: s32;
    noise_level: s32;
}

Vp9_Level_Spec :: struct {
    level: VP9_LEVEL;
    max_luma_sample_rate: u64;
    max_luma_picture_size: u32;
    max_luma_picture_breadth: u32;
    average_bitrate: float64;
    max_cpb_size: float64;
    compression_ratio: float64;
    max_col_tiles: u8;
    min_altref_distance: u32;
    max_ref_frame_buffers: u8;
}

Lookahead_Ctx_in_vp9_lookahead :: struct {
    max_sz: s32;
    sz: s32;
    read_idx: s32;
    write_idx: s32;
    next_show_idx: s32;
    buf: *Lookahead_Entry_in_vp9_lookahead;
}

Lookahead_Entry_in_vp9_lookahead :: struct {
    img: YV12_BUFFER_CONFIG;
    ts_start: s64;
    ts_end: s64;
    show_idx: s32;
    flags: Enc_Frame_Flags_T;
}

Vp9_Variance_Fn_Ptr_T :: Vp9_Variance_Vtable;

Fractional_Mv_Step_Fp_in_vp9_mcomp :: #type (
    _: *MACROBLOCK,
    _: *MV,
    _: *MV,
    _: s32,
    _: s32,
    _: *Vp9_Variance_Fn_Ptr_T,
    _: s32,
    _: s32,
    _: *s32,
    _: *s32,
    _: **s32,
    _: *u32,
    _: *u32,
    _: *u8,
    _: s32,
    _: s32,
    _: s32
) -> u32;

Vp9_Sad_Fn_Ptr_T :: Vp9_Sad_Table_in_vp9_mcomp;

Vp9_Diamond_Search_Fn_T :: #type (
    _: *MACROBLOCK,
    _: *Search_Site_Config_in_vp9_mcomp,
    _: *MV,
    _: u32,
    _: *MV,
    _: s32,
    _: s32,
    _: *s32,
    _: *Vp9_Sad_Fn_Ptr_T,
    _: *MV
) -> s32;

NOISE_ESTIMATE :: Noise_Estimate;

Enc_Worker_Data :: struct {
    cpi: *VP9_COMP_in_vp9_encoder;
    td: *Thread_Data_in_vp9_encoder;
    start: s32;
    thread_id: s32;
    tile_completion_status: [64] s32;
}

VP9_Row_MT_Sync :: VP9_Row_MT_Sync_Data;

FIRSTPASS_STATS_in_vp9_cx_iface :: struct {
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
    spatial_layer_id: s64;
}

ENCODE_FRAME_RESULT :: struct {
    show_idx: s32;
    update_type: FRAME_UPDATE_TYPE;
    quantize_index: s32;
}

SVC :: struct {
    spatial_layer_id: s32;
    temporal_layer_id: s32;
    number_spatial_layers: s32;
    number_temporal_layers: s32;
    spatial_layer_to_encode: s32;
    encode_empty_frame_state: SVC_Encode_Empty_Frame_State;
    empty_frame: Lookahead_Entry_in_vp9_lookahead;
    encode_intra_empty_frame: s32;
    scaled_frames: [25] YV12_BUFFER_CONFIG;
    scaled_temp: YV12_BUFFER_CONFIG;
    scaled_one_half: s32;
    scaled_temp_is_alloc: s32;
    layer_context: [12] LAYER_CONTEXT_in_vp9_cx_iface;
    temporal_layering_mode: VP9_E_TEMPORAL_LAYERING_MODE;
    ext_frame_flags: [12] s32;
    lst_fb_idx: [12] s32;
    gld_fb_idx: [12] s32;
    alt_fb_idx: [12] s32;
    force_zero_mode_spatial_ref: s32;
    use_gf_temporal_ref: s32;
    use_gf_temporal_ref_current_layer: s32;
    buffer_gf_temporal_ref: [2] BUFFER_LONGTERM_REF;
    current_superframe: s32;
    non_reference_frame: s32;
    use_base_mv: s32;
    use_partition_reuse: s32;
    downsample_filter_type: [5] INTERP_FILTER;
    downsample_filter_phase: [5] s32;
    prev_partition_svc: *BLOCK_SIZE;
    mi_stride: [12] s32;
    mi_rows: [12] s32;
    mi_cols: [12] s32;
    first_layer_denoise: s32;
    skip_enhancement_layer: s32;
    lower_layer_qindex: s32;
    last_layer_dropped: [12] s32;
    drop_spatial_layer: [12] s32;
    framedrop_thresh: [12] s32;
    drop_count: [12] s32;
    force_drop_constrained_from_above: [12] s32;
    max_consec_drop: s32;
    framedrop_mode: SVC_LAYER_DROP_MODE;
    disable_inter_layer_pred: INTER_LAYER_PRED;
    high_source_sad_superframe: s32;
    high_num_blocks_with_motion: s32;
    update_buffer_slot: [5] s32;
    reference_last: [5] u8;
    reference_golden: [5] u8;
    reference_altref: [5] u8;
    update_last: [5] u8;
    update_golden: [5] u8;
    update_altref: [5] u8;
    fb_idx_upd_tl0: [5] s32;
    fb_idx_spatial_layer_id: [8] u8;
    fb_idx_temporal_layer_id: [8] u8;
    spatial_layer_sync: [5] s32;
    base_qindex: [5] s32;
    set_intra_only_frame: u8;
    previous_frame_is_intra_only: u8;
    superframe_has_layer_sync: u8;
    fb_idx_base: [8] u8;
    use_set_ref_frame_config: s32;
    temporal_layer_id_per_spatial: [5] s32;
    first_spatial_layer_to_encode: s32;
    duration: [5] s64;
    timebase_fac: s64;
    time_stamp_superframe: s64;
    time_stamp_prev: [5] s64;
    num_encoded_top_layer: s32;
    simulcast_mode: s32;
    single_layer_svc: s32;
    resize_set: s32;
}

EXT_RATECTRL :: struct {
    ready: s32;
    ext_rdmult: s32;
    model: Rc_Model_T;
    funcs: Rc_Funcs_T;
    ratectrl_config: Rc_Config_T;
    rc_firstpass_stats: Rc_Firstpass_Stats_T;
    log_file: *FILE_in_file;
}

CYCLIC_REFRESH :: struct {
    percent_refresh: s32;
    max_qdelta_perc: s32;
    sb_index: s32;
    time_for_refresh: s32;
    target_num_seg_blocks: s32;
    actual_num_seg1_blocks: s32;
    actual_num_seg2_blocks: s32;
    rdmult: s32;
    map: *s8;
    last_coded_q_map: *u8;
    thresh_rate_sb: s64;
    thresh_dist_sb: s64;
    motion_thresh: s16;
    rate_ratio_qdelta: float64;
    rate_boost_fac: s32;
    low_content_avg: float64;
    qindex_delta: [3] s32;
    reduce_refresh: s32;
    weight_segment: float64;
    apply_cyclic_refresh: s32;
    counter_encode_maxq_scene_change: s32;
    skip_flat_static_blocks: s32;
    content_mode: s32;
}

LOOPFILTER_CONTROL :: u32;
LOOPFILTER_ALL : s32 : 0;
LOOPFILTER_REFERENCE : s32 : 1;
NO_LOOPFILTER : s32 : 2;

INTER_LAYER_PRED :: u32;
INTER_LAYER_PRED_ON : s32 : 0;
INTER_LAYER_PRED_OFF : s32 : 1;
INTER_LAYER_PRED_OFF_NONKEY : s32 : 2;
INTER_LAYER_PRED_ON_CONSTRAINED : s32 : 3;

Svc_Parameters :: struct {
    max_quantizers: [12] s32;
    min_quantizers: [12] s32;
    scaling_factor_num: [12] s32;
    scaling_factor_den: [12] s32;
    speed_per_layer: [12] s32;
    temporal_layering_mode: s32;
    loopfilter_ctrl: [12] s32;
}

LAYER_CONTEXT_in_vp9_cx_iface :: struct {
    rc: RATE_CONTROL;
    target_bandwidth: s32;
    spatial_layer_target_bandwidth: s32;
    framerate: float64;
    avg_frame_size: s32;
    max_q: s32;
    min_q: s32;
    scaling_factor_num: s32;
    scaling_factor_den: s32;
    scaling_factor_num_resize: s32;
    scaling_factor_den_resize: s32;
    twopass: TWO_PASS;
    rc_twopass_stats_in: Fixed_Buf_T;
    current_video_frame_in_layer: u32;
    is_key_frame: s32;
    frames_from_key_frame: s32;
    last_frame_type: FRAME_TYPE;
    alt_ref_source: *Lookahead_Entry_in_vp9_lookahead;
    alt_ref_idx: s32;
    gold_ref_idx: s32;
    has_alt_frame: s32;
    layer_size: u64;
    sb_index: s32;
    map: *s8;
    last_coded_q_map: *u8;
    consec_zero_mv: *u8;
    actual_num_seg1_blocks: s32;
    actual_num_seg2_blocks: s32;
    counter_encode_maxq_scene_change: s32;
    qindex_delta: [3] s32;
    speed: u8;
    loopfilter_ctrl: s32;
    frame_qp: s32;
    m_bs: s32;
}

FIRST_PASS_INFO :: struct {
    stats: *FIRSTPASS_STATS_in_vp9_cx_iface;
    num_frames: s32;
}

Macroblock :: struct {
    plane: [3] Macroblock_Plane_in_vp9_block #align 16;
    e_mbd: MACROBLOCKD #align 1;
    mbmi_ext: *MB_MODE_INFO_EXT #align 1;
    mbmi_ext_base: *MB_MODE_INFO_EXT #align 1;
    skip_block: s32 #align 1;
    select_tx_size: s32 #align 1;
    skip_recode: s32 #align 1;
    skip_optimize: s32 #align 1;
    q_index: s32 #align 1;
    layout_padding_0: [4] u8 #align 1;
    log_block_src_var: float64 #align 1;
    block_tx_domain: s32 #align 1;
    errorperbit: s32 #align 1;
    sadperbit16: s32 #align 1;
    sadperbit4: s32 #align 1;
    rddiv: s32 #align 1;
    rdmult: s32 #align 1;
    cb_rdmult: s32 #align 1;
    segment_id: s32 #align 1;
    mb_energy: s32 #align 1;
    min_partition_size: BLOCK_SIZE #align 1;
    max_partition_size: BLOCK_SIZE #align 1;
    layout_padding_1: [2] u8 #align 1;
    mv_best_ref_index: [4] s32 #align 1;
    max_mv_context: [4] u32 #align 1;
    source_variance: u32 #align 1;
    pred_sse: [4] u32 #align 1;
    pred_mv_sad: [4] s32 #align 1;
    nmvjointcost: [4] s32 #align 1;
    layout_padding_2: [4] u8 #align 1;
    nmvcost: [2] *s32 #align 1;
    nmvcost_hp: [2] *s32 #align 1;
    mvcost: **s32 #align 1;
    nmvjointsadcost: [4] s32 #align 1;
    nmvsadcost: [2] *s32 #align 1;
    nmvsadcost_hp: [2] *s32 #align 1;
    mvsadcost: **s32 #align 1;
    sharpness: s32 #align 1;
    adjust_rdmult_by_segment: s32 #align 1;
    mv_limits: Mv_Limits #align 1;
    zcoeff_blk: [4] [256] u8 #align 1;
    sum_y_eobs: [4] s32 #align 1;
    skip: s32 #align 1;
    encode_breakout: s32 #align 1;
    token_costs: [4] Vp9_Coeff_Cost #align 1;
    optimize: s32 #align 1;
    use_lp32x32fdct: s32 #align 1;
    skip_encode: s32 #align 1;
    fp_src_pred: s32 #align 1;
    quant_fp: s32 #align 1;
    skip_txfm: [12] u8 #align 1;
    bsse: [12] s64 #align 1;
    pred_mv: [4] MV #align 1;
    color_sensitivity: [2] u8 #align 1;
    sb_is_skin: u8 #align 1;
    skip_low_source_sad: u8 #align 1;
    lowvar_highsumdiff: u8 #align 1;
    last_sb_high_content: u8 #align 1;
    layout_padding_3: [2] u8 #align 1;
    sb_use_mv_part: s32 #align 1;
    sb_mvcol_part: s32 #align 1;
    sb_mvrow_part: s32 #align 1;
    sb_pickmode_part: s32 #align 1;
    zero_temp_sad_source: s32 #align 1;
    content_state_sb: u8 #align 1;
    variance_low: [25] u8 #align 1;
    arf_frame_usage: u8 #align 1;
    lastgolden_frame_usage: u8 #align 1;
    fwd_txfm4x4: #type (_: *s16, _: *Tran_Low_T, _: s32);
    inv_txfm_add: #type (_: *Tran_Low_T, _: *u8, _: s32, _: s32);
    est_pred: [4096] u8 #align 1;
    me_sf: *Scale_Factors #align 1;
    layout_padding_4: [8] u8 #align 1;
} #no_padding;

TOKENVALUE_in_vp9_cx_iface :: struct {
    token: s16;
    extra: EXTRABIT;
}

TOKENEXTRA_in_vp9_cx_iface :: struct {
    context_tree: *Prob;
    token: s16;
    extra: EXTRABIT;
}

Tile_Data_Enc :: struct {
    tile_info: Tile_Info;
    thresh_freq_fact: [13] [30] s32;
    thresh_freq_fact_prev: [13] [30] s32;
    mode_map: [13] [30] s8;
    fp_data: FIRSTPASS_DATA;
    row_mt_sync: VP9_Row_MT_Sync;
    row_base_thresh_freq_fact: *s32;
    sb_rows: s32;
    firstpass_top_mv: MV;
}

QUANTS :: struct {
    y_quant: [256] [8] s16 #align 16;
    y_quant_shift: [256] [8] s16 #align 1;
    y_zbin: [256] [8] s16 #align 1;
    y_round: [256] [8] s16 #align 1;
    y_quant_fp: [256] [8] s16 #align 1;
    uv_quant_fp: [256] [8] s16 #align 1;
    y_round_fp: [256] [8] s16 #align 1;
    uv_round_fp: [256] [8] s16 #align 1;
    uv_quant: [256] [8] s16 #align 1;
    uv_quant_shift: [256] [8] s16 #align 1;
    uv_zbin: [256] [8] s16 #align 1;
    uv_round: [256] [8] s16 #align 1;
} #no_padding;

Thread_Data_in_vp9_encoder :: struct {
    mb: MACROBLOCK #align 16;
    rd_counts: RD_COUNTS #align 1;
    counts: *FRAME_COUNTS #align 1;
    leaf_tree: *PICK_MODE_CONTEXT #align 1;
    pc_tree: *PC_TREE #align 1;
    pc_root: *PC_TREE #align 1;
    layout_padding_0: [8] u8 #align 1;
} #no_padding;

MB_MODE_INFO_EXT :: struct {
    ref_mvs: [4] [2] Int_Mv #align 4;
    mode_context: [4] u8 #align 1;
} #no_padding;

Tpl_Dep_Frame :: struct {
    is_valid: u8;
    tpl_stats_ptr: *Tpl_Dep_Stats;
    stride: s32;
    width: s32;
    height: s32;
    mi_rows: s32;
    mi_cols: s32;
    base_qindex: s32;
}

Enc_Frame_Buf :: struct {
    mem_valid: s32;
    released: s32;
    frame: YV12_BUFFER_CONFIG;
}

KMEANS_DATA :: struct {
    value: float64;
    pos: s32;
    group_idx: s32;
}

TOKENLIST_in_vp9_cx_iface :: struct {
    start: *TOKENEXTRA_in_vp9_cx_iface;
    stop: *TOKENEXTRA_in_vp9_cx_iface;
    count: u32;
}

RD_CONTROL :: struct {
    rd_mult_inter_qp_fac: float64;
    rd_mult_arf_qp_fac: float64;
    rd_mult_key_qp_fac: float64;
}

RD_OPT :: struct {
    thresh_mult: [30] s32;
    thresh_mult_sub8x8: [6] s32;
    threshes: [8] [13] [30] s32;
    prediction_type_threshes: [4] [3] s64;
    filter_threshes: [4] [4] s64;
    prediction_type_threshes_prev: [4] [3] s64;
    filter_threshes_prev: [4] [4] s64;
    rdmult: s32;
    rddiv: s32;
    r0: float64;
}

CODING_CONTEXT_in_vp9_cx_iface :: struct {
    nmvjointcost: [4] s32;
    nmvcosts: [2] [32767] s32;
    nmvcosts_hp: [2] [32767] s32;
    segment_pred_probs: [3] Prob;
    last_frame_seg_map_copy: *u8;
    last_ref_lf_deltas: [4] s8;
    last_mode_lf_deltas: [2] s8;
    fc: FRAME_CONTEXT;
}

RATE_CONTROL :: struct {
    base_frame_target: s32;
    this_frame_target: s32;
    projected_frame_size: s32;
    sb64_target_rate: s32;
    last_q: [2] s32;
    last_boosted_qindex: s32;
    last_kf_qindex: s32;
    gfu_boost: s32;
    last_boost: s32;
    kf_boost: s32;
    rate_correction_factors: [5] float64;
    frames_since_golden: s32;
    frames_till_gf_update_due: s32;
    min_gf_interval: s32;
    max_gf_interval: s32;
    static_scene_max_gf_interval: s32;
    baseline_gf_interval: s32;
    constrained_gf_group: s32;
    frames_to_key: s32;
    frames_since_key: s32;
    this_key_frame_forced: s32;
    next_key_frame_forced: s32;
    source_alt_ref_pending: s32;
    source_alt_ref_active: s32;
    is_src_frame_alt_ref: s32;
    avg_frame_bandwidth: s32;
    min_frame_bandwidth: s32;
    max_frame_bandwidth: s32;
    ni_av_qi: s32;
    ni_tot_qi: s32;
    ni_frames: s32;
    avg_frame_qindex: [2] s32;
    tot_q: float64;
    avg_q: float64;
    buffer_level: s64;
    bits_off_target: s64;
    vbr_bits_off_target: s64;
    vbr_bits_off_target_fast: s64;
    decimation_factor: s32;
    decimation_count: s32;
    rolling_target_bits: s32;
    rolling_actual_bits: s32;
    long_rolling_target_bits: s32;
    long_rolling_actual_bits: s32;
    rate_error_estimate: s32;
    total_actual_bits: s64;
    total_target_bits: s64;
    total_target_vs_actual: s64;
    worst_quality: s32;
    best_quality: s32;
    starting_buffer_level: s64;
    optimal_buffer_level: s64;
    maximum_buffer_size: s64;
    rc_1_frame: s32;
    rc_2_frame: s32;
    q_1_frame: s32;
    q_2_frame: s32;
    last_avg_frame_bandwidth: s32;
    frame_size_selector: FRAME_SCALE_LEVEL;
    next_frame_size_selector: FRAME_SCALE_LEVEL;
    frame_width: [2] s32;
    frame_height: [2] s32;
    rf_level_maxq: [5] s32;
    fac_active_worst_inter: s32;
    fac_active_worst_gf: s32;
    avg_source_sad: [25] u64;
    prev_avg_source_sad_lag: u64;
    high_source_sad_lagindex: s32;
    high_num_blocks_with_motion: s32;
    alt_ref_gf_group: s32;
    last_frame_is_src_altref: s32;
    high_source_sad: s32;
    count_last_scene_change: s32;
    hybrid_intra_scene_change: s32;
    re_encode_maxq_scene_change: s32;
    avg_frame_low_motion: s32;
    af_ratio_onepass_vbr: s32;
    force_qpmin: s32;
    reset_high_source_sad: s32;
    perc_arf_usage: float64;
    force_max_q: s32;
    last_post_encode_dropped_scene_change: s32;
    use_post_encode_drop: s32;
    ext_use_post_encode_drop: s32;
    disable_overshoot_maxq_cbr: s32;
    damped_adjustment: [5] s32;
    arf_active_best_quality_adjustment_factor: float64;
    arf_increase_active_best_quality: s32;
    preserve_arf_as_gld: s32;
    preserve_next_arf_as_gld: s32;
    show_arf_as_gld: s32;
    constrain_gf_key_freq_onepass_vbr: s32;
    gop_global_index: s32;
}

MBGRAPH_FRAME_STATS :: struct {
    mb_stats: *MBGRAPH_MB_STATS;
}

SPEED_FEATURES_in_vp9_speed_features :: struct {
    mv: MV_SPEED_FEATURES;
    frame_parameter_update: s32;
    recode_loop: RECODE_LOOP_TYPE;
    optimize_coefficients: s32;
    static_segmentation: s32;
    comp_inter_joint_search_iter_level: s32;
    adaptive_rd_thresh: s32;
    adaptive_rd_thresh_row_mt: s32;
    skip_encode_sb: s32;
    skip_encode_frame: s32;
    allow_skip_recode: s32;
    coeff_prob_appx_step: s32;
    trellis_opt_tx_rd: TRELLIS_OPT_CONTROL;
    allow_acl: s32;
    enable_tpl_model: s32;
    allow_txfm_domain_distortion: s32;
    tx_domain_thresh: float64;
    lf_motion_threshold: MOTION_THRESHOLD;
    tx_size_search_method: TX_SIZE_SEARCH_METHOD;
    tx_size_search_depth: s32;
    use_lp32x32fdct: s32;
    mode_skip_start: s32;
    reference_masking: s32;
    partition_search_type: PARTITION_SEARCH_TYPE;
    always_this_block_size: BLOCK_SIZE;
    less_rectangular_check: s32;
    use_square_partition_only: s32;
    use_square_only_thresh_high: BLOCK_SIZE;
    use_square_only_thresh_low: BLOCK_SIZE;
    prune_ref_frame_for_rect_partitions: s32;
    auto_min_max_partition_size: AUTO_MIN_MAX_MODE;
    rd_auto_partition_min_limit: BLOCK_SIZE;
    default_min_partition_size: BLOCK_SIZE;
    default_max_partition_size: BLOCK_SIZE;
    adjust_partitioning_from_last_frame: s32;
    last_partitioning_redo_frequency: s32;
    disable_split_mask: s32;
    adaptive_motion_search: s32;
    enhanced_full_pixel_motion_search: s32;
    exhaustive_searches_thresh: s32;
    mesh_patterns: [4] MESH_PATTERN;
    schedule_mode_search: s32;
    adaptive_pred_interp_filter: s32;
    adaptive_mode_search: s32;
    prune_single_mode_based_on_mv_diff_mode_rate: s32;
    cb_pred_filter_search: s32;
    early_term_interp_search_plane_rd: s32;
    cb_partition_search: s32;
    motion_field_mode_search: s32;
    alt_ref_search_fp: s32;
    use_quant_fp: s32;
    force_frame_boost: s32;
    max_delta_qindex: s32;
    mode_search_skip_flags: u32;
    disable_filter_search_var_thresh: u32;
    intra_y_mode_mask: [4] s32;
    intra_uv_mode_mask: [4] s32;
    intra_y_mode_bsize_mask: [13] s32;
    use_rd_breakout: s32;
    use_uv_intra_rd_estimate: s32;
    lpf_pick: LPF_PICK_METHOD;
    use_fast_coef_updates: FAST_COEFF_UPDATE;
    use_nonrd_pick_mode: s32;
    inter_mode_mask: [13] s32;
    use_fast_coef_costing: s32;
    recode_tolerance_low: s32;
    recode_tolerance_high: s32;
    max_intra_bsize: BLOCK_SIZE;
    reuse_inter_pred_sby: s32;
    encode_breakout_thresh: s32;
    default_interp_filter: INTERP_FILTER;
    tx_size_search_breakout: s32;
    adaptive_interp_filter_search: s32;
    interp_filter_search_mask: INTERP_FILTER_MASK;
    partition_search_breakout_thr: PARTITION_SEARCH_BREAKOUT_THR;
    rd_ml_partition: SPEED_FEATURES_Rd_Ml_Partition;
    simple_model_rd_from_var: s32;
    short_circuit_flat_blocks: s32;
    short_circuit_low_temp_var: s32;
    limit_newmv_early_exit: s32;
    bias_golden: s32;
    base_mv_aggressive: s32;
    copy_partition_flag: s32;
    use_source_sad: s32;
    use_simple_block_yrd: s32;
    adapt_partition_source_sad: s32;
    adapt_partition_thresh: s32;
    use_altref_onepass: s32;
    use_compound_nonrd_pickmode: s32;
    nonrd_keyframe: s32;
    svc_use_lowres_part: s32;
    overshoot_detection_cbr_rt: OVERSHOOT_DETECTION_CBR_RT;
    disable_16x16part_nonkey: s32;
    disable_golden_ref: s32;
    use_accurate_subpel_search: SUBPEL_SEARCH_TYPE;
    temporal_filter_search_method: SEARCH_METHODS_in_vp9_cx_iface;
    nonrd_use_ml_partition: s32;
    variance_part_thresh_mult: s32;
    force_smooth_interpol: s32;
    rt_intra_dc_only_low_content: s32;
    allow_skip_txfm_ac_dc: s32;
}

ENCODE_BREAKOUT_TYPE :: u32;
ENCODE_BREAKOUT_DISABLED : s32 : 0;
ENCODE_BREAKOUT_ENABLED : s32 : 1;
ENCODE_BREAKOUT_LIMITED : s32 : 2;

Active_Map_in_vp9_encoder :: struct {
    enabled: s32;
    update: s32;
    map: *u8;
}

Vp9_Variance_Vtable :: struct {
    sdf: Sad_Fn_T;
    sdsf: Sad_Fn_T;
    sdaf: Sad_Avg_Fn_T;
    vf: Variance_Fn_T;
    svf: Subpixvariance_Fn_T;
    svaf: Subp_Avg_Variance_Fn_T;
    sdx4df: Sad_Multi_D_Fn_T;
    sdsx4df: Sad_Multi_D_Fn_T;
}

Search_Site_Config_in_vp9_mcomp :: struct {
    ss_mv: [88] MV;
    ss_os: [88] s64;
    searches_per_step: s32;
    total_steps: s32;
}

Vp9_Sad_Table_in_vp9_mcomp :: struct {
    sdf: Sad_Fn_T;
    sdx4df: Sad_Multi_D_Fn_T;
}

TWO_PASS :: struct {
    section_intra_rating: u32;
    key_frame_section_intra_rating: u32;
    total_stats: FIRSTPASS_STATS_in_vp9_cx_iface;
    this_frame_stats: FIRSTPASS_STATS_in_vp9_cx_iface;
    stats_in: *FIRSTPASS_STATS_in_vp9_cx_iface;
    stats_in_start: *FIRSTPASS_STATS_in_vp9_cx_iface;
    stats_in_end: *FIRSTPASS_STATS_in_vp9_cx_iface;
    first_pass_info: FIRST_PASS_INFO;
    total_left_stats: FIRSTPASS_STATS_in_vp9_cx_iface;
    first_pass_done: s32;
    bits_left: s64;
    mean_mod_score: float64;
    normalized_score_left: float64;
    mb_av_energy: float64;
    mb_smooth_pct: float64;
    fp_mb_float_stats: *FP_MB_FLOAT_STATS;
    fr_content_type: FRAME_CONTENT_TYPE;
    kf_group_bits: s64;
    kf_group_error_left: float64;
    bpm_factor: float64;
    rolling_arf_group_target_bits: s32;
    rolling_arf_group_actual_bits: s32;
    sr_update_lag: s32;
    kf_zeromotion_pct: s32;
    last_kfgroup_zeromotion_pct: s32;
    active_worst_quality: s32;
    baseline_active_worst_quality: s32;
    extend_minq: s32;
    extend_maxq: s32;
    extend_minq_fast: s32;
    arnr_strength_adjustment: s32;
    last_qindex_of_arf_layer: [6] s32;
    gf_group: GF_GROUP;
    use_vizier_rc_params: s32;
    active_wq_factor: float64;
    err_per_mb: float64;
    sr_default_decay_limit: float64;
    sr_diff_factor: float64;
    kf_err_per_mb: float64;
    kf_frame_min_boost: float64;
    kf_frame_max_boost_first: float64;
    kf_frame_max_boost_subs: float64;
    kf_max_total_boost: float64;
    gf_max_total_boost: float64;
    gf_frame_max_boost: float64;
    zm_factor: float64;
}

RESIZE_STATE :: u32;
ORIG : s32 : 0;
THREE_QUARTER : s32 : 1;
ONE_HALF : s32 : 2;

Noise_Estimate :: struct {
    enabled: s32;
    level: NOISE_LEVEL;
    value: s32;
    thresh: s32;
    adapt_thresh: s32;
    count: s32;
    last_w: s32;
    last_h: s32;
    num_frames_estimate: s32;
}

Vp9_Level_Info :: struct {
    level_stats: Vp9_Level_Stats;
    level_spec: Vp9_Level_Spec;
}

Multi_Thread_Handle :: struct {
    allocated_tile_rows: s32 #align 8;
    allocated_tile_cols: s32 #align 1;
    allocated_vert_unit_rows: s32 #align 1;
    num_tile_vert_sbs: [4] s32 #align 1;
    layout_padding_0: [4] u8 #align 1;
    job_queue: *Job_Queue #align 1;
    jobs_per_tile_col: s32 #align 1;
    layout_padding_1: [4] u8 #align 1;
    row_mt_info: [64] Row_MT_Info #align 1;
    thread_id_to_tile_id: [64] s32 #align 1;
} #no_padding;

VP9_Row_MT_Sync_Data :: struct {
    mutex: *Pthread_Mutex_T;
    cond: *Pthread_Cond_T;
    cur_col: *s32;
    sync_range: s32;
    rows: s32;
}

ARNR_Filter_Data :: struct {
    frames: [25] *YV12_BUFFER_CONFIG;
    strength: s32;
    frame_count: s32;
    alt_ref_index: s32;
    sf: Scale_Factors;
    dst: *YV12_BUFFER_CONFIG;
}

Level_Constraint :: struct {
    level_index: s8;
    fail_flag: u8;
    max_frame_size: s32;
    max_cpb_size: float64;
}

SVC_Encode_Empty_Frame_State :: u32;
ENCODED : s32 : 0;
ENCODING : s32 : 1;
NEED_TO_ENCODE : s32 : 2;

Vp9_Coeff_Cost :: [2] [2] [6] [2] [6] [12] u32;

SPEED_FEATURES_Rd_Ml_Partition :: struct {
    search_breakout: s32;
    search_breakout_thresh: [3] float32;
    search_early_termination: s32;
    var_pruning: s32;
    prune_rect_thresh: [4] s32;
}

Sad_Avg_Fn_T :: #type (_: *u8, _: s32, _: *u8, _: s32, _: *u8) -> u32;

Subp_Avg_Variance_Fn_T :: #type (_: *u8, _: s32, _: s32, _: s32, _: *u8, _: s32, _: *u32, _: *u8) -> u32;

NOISE_LEVEL :: Noise_Level;

FRAME_UPDATE_TYPE :: u32;
KF_UPDATE : s32 : 0;
LF_UPDATE : s32 : 1;
GF_UPDATE : s32 : 2;
ARF_UPDATE : s32 : 3;
OVERLAY_UPDATE : s32 : 4;
MID_OVERLAY_UPDATE : s32 : 5;
USE_BUF_FRAME : s32 : 6;
FRAME_UPDATE_TYPES : s32 : 7;

BUFFER_LONGTERM_REF :: struct {
    idx: s32;
    is_used: s32;
}

Mv_Limits :: struct {
    col_min: s32;
    col_max: s32;
    row_min: s32;
    row_max: s32;
}

FIRSTPASS_DATA :: struct {
    intra_factor: float64;
    brightness_factor: float64;
    coded_error: s64;
    sr_coded_error: s64;
    frame_noise_energy: s64;
    intra_error: s64;
    intercount: s32;
    second_ref_count: s32;
    neutral_count: float64;
    intra_count_low: float64;
    intra_count_high: float64;
    intra_skip_count: s32;
    image_data_start_row: s32;
    mvcount: s32;
    sum_mvr: s32;
    sum_mvr_abs: s32;
    sum_mvc: s32;
    sum_mvc_abs: s32;
    sum_mvrs: s64;
    sum_mvcs: s64;
    sum_in_vectors: s32;
    intra_smooth_count: s32;
    new_mv_count: s32;
}

RD_COUNTS :: struct {
    coef_counts: [4] [2] Vp9_Coeff_Count;
    comp_pred_diff: [3] s64;
    filter_diff: [4] s64;
}

PICK_MODE_CONTEXT :: struct {
    mic: MODE_INFO #align 8;
    mbmi_ext: MB_MODE_INFO_EXT #align 1;
    zcoeff_blk: *u8 #align 1;
    coeff: [3] [3] *Tran_Low_T #align 1;
    qcoeff: [3] [3] *Tran_Low_T #align 1;
    dqcoeff: [3] [3] *Tran_Low_T #align 1;
    eobs: [3] [3] *u16 #align 1;
    coeff_pbuf: [3] [3] *Tran_Low_T #align 1;
    qcoeff_pbuf: [3] [3] *Tran_Low_T #align 1;
    dqcoeff_pbuf: [3] [3] *Tran_Low_T #align 1;
    eobs_pbuf: [3] [3] *u16 #align 1;
    is_coded: s32 #align 1;
    num_4x4_blk: s32 #align 1;
    skip: s32 #align 1;
    pred_pixel_ready: s32 #align 1;
    skippable: s32 #align 1;
    skip_txfm: [12] u8 #align 1;
    best_mode_index: s32 #align 1;
    hybrid_pred_diff: s32 #align 1;
    comp_pred_diff: s32 #align 1;
    single_pred_diff: s32 #align 1;
    best_filter_diff: [4] s64 #align 1;
    rate: s32 #align 1;
    layout_padding_0: [4] u8 #align 1;
    dist: s64 #align 1;
    rdcost: s64 #align 1;
    pred_mv: [4] MV #align 1;
    pred_interp_filter: INTERP_FILTER #align 1;
    layout_padding_1: [3] u8 #align 1;
    sum_y_eobs: s32 #align 1;
    skip_ref_frame_mask: u8 #align 1;
    layout_padding_2: [7] u8 #align 1;
} #no_padding;

PC_TREE :: struct {
    index: s32 #align 8;
    partitioning: PARTITION_TYPE #align 1;
    block_size: BLOCK_SIZE #align 1;
    layout_padding_0: [7] u8 #align 1;
    none: PICK_MODE_CONTEXT #align 1;
    horizontal: [2] PICK_MODE_CONTEXT #align 1;
    vertical: [2] PICK_MODE_CONTEXT #align 1;
    u: PC_TREE_U #align 1;
    mv: MV #align 1;
    layout_padding_1: [4] u8 #align 1;
} #no_padding;

Tpl_Dep_Stats :: struct {
    intra_cost: s64 #align 8;
    inter_cost: s64 #align 1;
    mc_flow: s64 #align 1;
    mc_dep_cost: s64 #align 1;
    mc_ref_cost: s64 #align 1;
    ref_frame_index: s32 #align 1;
    mv: Int_Mv #align 1;
} #no_padding;

FRAME_SCALE_LEVEL :: u32;
UNSCALED : s32 : 0;
SCALE_STEP1 : s32 : 1;
FRAME_SCALE_STEPS : s32 : 2;

MBGRAPH_MB_STATS :: struct {
    ref: [4] Unnamed_5805 #align 4;
} #no_padding;

MV_SPEED_FEATURES :: struct {
    search_method: SEARCH_METHODS_in_vp9_cx_iface;
    reduce_first_step_size: s32;
    auto_mv_step_size: s32;
    subpel_search_method: SUBPEL_SEARCH_METHODS;
    subpel_search_level: s32;
    subpel_force_stop: SUBPEL_FORCE_STOP;
    enable_adaptive_subpel_force_stop: s32;
    adapt_subpel_force_stop: ADAPT_SUBPEL_FORCE_STOP;
    fullpel_search_step_param: s32;
    use_downsampled_sad: s32;
}

RECODE_LOOP_TYPE :: u32;
DISALLOW_RECODE : s32 : 0;
ALLOW_RECODE_KFMAXBW : s32 : 1;
ALLOW_RECODE_KFARFGF : s32 : 2;
ALLOW_RECODE_FIRST : s32 : 3;
ALLOW_RECODE : s32 : 4;

TRELLIS_OPT_CONTROL :: struct {
    method: ENABLE_TRELLIS_OPT_METHOD;
    thresh: float64;
}

MOTION_THRESHOLD :: u32;
NO_MOTION_THRESHOLD : s32 : 0;
LOW_MOTION_THRESHOLD : s32 : 7;

TX_SIZE_SEARCH_METHOD :: u32;
USE_FULL_RD : s32 : 0;
USE_LARGESTALL : s32 : 1;
USE_TX_8X8 : s32 : 2;

PARTITION_SEARCH_TYPE :: u32;
SEARCH_PARTITION : s32 : 0;
FIXED_PARTITION : s32 : 1;
REFERENCE_PARTITION : s32 : 2;
VAR_BASED_PARTITION : s32 : 3;
ML_BASED_PARTITION : s32 : 4;

AUTO_MIN_MAX_MODE :: u32;
NOT_IN_USE : s32 : 0;
RELAXED_NEIGHBORING_MIN_MAX : s32 : 1;
STRICT_NEIGHBORING_MIN_MAX : s32 : 2;

MESH_PATTERN :: struct {
    range: s32;
    interval: s32;
}

LPF_PICK_METHOD :: u32;
LPF_PICK_FROM_FULL_IMAGE : s32 : 0;
LPF_PICK_FROM_SUBIMAGE : s32 : 1;
LPF_PICK_FROM_Q : s32 : 2;
LPF_PICK_MINIMAL_LPF : s32 : 3;

FAST_COEFF_UPDATE :: u32;
TWO_LOOP : s32 : 0;
ONE_LOOP_REDUCED : s32 : 1;

INTERP_FILTER_MASK :: u32;
FLAG_SKIP_EIGHTTAP : s32 : 1;
FLAG_SKIP_EIGHTTAP_SMOOTH : s32 : 2;
FLAG_SKIP_EIGHTTAP_SHARP : s32 : 4;

PARTITION_SEARCH_BREAKOUT_THR :: struct {
    dist: s64;
    rate: s32;
}

OVERSHOOT_DETECTION_CBR_RT :: u32;
NO_DETECTION : s32 : 0;
FAST_DETECTION_MAXQ : s32 : 1;
RE_ENCODE_MAXQ : s32 : 2;

SUBPEL_SEARCH_TYPE :: u32;
USE_2_TAPS : s32 : 0;
USE_4_TAPS : s32 : 1;
USE_8_TAPS : s32 : 2;
USE_8_TAPS_SHARP : s32 : 3;

SEARCH_METHODS_in_vp9_cx_iface :: u32;
DIAMOND_in_vp9_cx_iface : s32 : 0;
NSTEP_in_vp9_cx_iface : s32 : 1;
HEX_in_vp9_cx_iface : s32 : 2;
BIGDIA : s32 : 3;
SQUARE : s32 : 4;
FAST_HEX : s32 : 5;
FAST_DIAMOND : s32 : 6;
MESH : s32 : 7;

FP_MB_FLOAT_STATS :: struct {
    frame_mb_intra_factor: float64;
    frame_mb_brightness_factor: float64;
    frame_mb_neutral_count: float64;
}

FRAME_CONTENT_TYPE :: u32;
FC_NORMAL : s32 : 0;
FC_GRAPHICS_ANIMATION : s32 : 1;
FRAME_CONTENT_TYPES : s32 : 2;

GF_GROUP :: struct {
    index: u8;
    rf_level: [252] RATE_FACTOR_LEVEL;
    update_type: [252] FRAME_UPDATE_TYPE;
    arf_src_offset: [252] u8;
    layer_depth: [252] u8;
    frame_gop_index: [252] u8;
    bit_allocation: [252] s32;
    gfu_boost: [252] s32;
    update_ref_idx: [252] s32;
    frame_start: s32;
    frame_end: s32;
    arf_index_stack: [50] s32;
    top_arf_idx: s32;
    stack_size: s32;
    gf_group_size: s32;
    max_layer_depth: s32;
    allowed_max_layer_depth: s32;
    group_noise_energy: s32;
    ext_rc_ref: [252] External_Rc_Reference;
    ref_frame_list: [252] [3] s32;
}

Noise_Level :: u32;
K_LOW_LOW : s32 : 0;
K_LOW : s32 : 1;
K_MEDIUM : s32 : 2;
K_HIGH : s32 : 3;

Vp9_Level_Stats :: struct {
    seen_first_altref: u8;
    frames_since_last_altref: u32;
    total_compressed_size: u64;
    total_uncompressed_size: u64;
    time_encoded: float64;
    frame_window_buffer: Frame_Window_Buffer;
    ref_refresh_map: s32;
}

Job_Queue :: struct {
    next: *void;
    job_info: Job_Node;
}

Row_MT_Info :: struct {
    job_queue_hdl: Job_Queue_Handle #align 8;
    job_mutex: Pthread_Mutex_T #align 1;
} #no_padding;

Vp9_Coeff_Count :: [2] [6] [6] [12] u32;

PC_TREE_U :: union {
    split: [4] *PC_TREE;
    leaf_split: [4] *PICK_MODE_CONTEXT;
}

Unnamed_5805 :: struct {
    err: s32 #align 4;
    m: Unnamed_5810 #align 1;
} #no_padding;

Unnamed_5810 :: union {
    mv: Int_Mv;
    mode: PREDICTION_MODE;
}

SUBPEL_FORCE_STOP :: u32;
EIGHTH_PEL : s32 : 0;
QUARTER_PEL : s32 : 1;
HALF_PEL : s32 : 2;
FULL_PEL : s32 : 3;

ADAPT_SUBPEL_FORCE_STOP :: struct {
    mv_thresh: s32;
    force_stop_below: SUBPEL_FORCE_STOP;
    force_stop_above: SUBPEL_FORCE_STOP;
}

RATE_FACTOR_LEVEL :: u32;
INTER_NORMAL : s32 : 0;
INTER_HIGH : s32 : 1;
GF_ARF_LOW : s32 : 2;
GF_ARF_STD : s32 : 3;
KF_STD : s32 : 4;
RATE_FACTOR_LEVELS : s32 : 5;

External_Rc_Reference :: struct {
    last_index: s32;
    golden_index: s32;
    altref_index: s32;
}

Frame_Window_Buffer :: struct {
    buf: [128] Frame_Record;
    start: u8;
    len: u8;
}

Job_Node :: struct {
    vert_unit_row_num: s32;
    tile_col_id: s32;
    tile_row_id: s32;
}

Job_Queue_Handle :: struct {
    next: *void;
    num_jobs_acquired: s32;
}

Frame_Record :: struct {
    ts: s64;
    luma_samples: u32;
    size: u32;
}

