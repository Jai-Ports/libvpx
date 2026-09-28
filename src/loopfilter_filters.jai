// Generated directly from C by cpp_transpiler.
Uc :: u8;

vp8_loop_filter_bh_c :: (y_ptr: *u8, u_ptr: *u8, v_ptr: *u8, y_stride: s32, uv_stride: s32, lfi: *Loop_Filter_Info) {
    loop_filter_horizontal_edge_c(y_ptr + 4 * y_stride, y_stride, lfi.blim, lfi.lim, lfi.hev_thr, 2);
    loop_filter_horizontal_edge_c(y_ptr + 8 * y_stride, y_stride, lfi.blim, lfi.lim, lfi.hev_thr, 2);
    loop_filter_horizontal_edge_c(y_ptr + 12 * y_stride, y_stride, lfi.blim, lfi.lim, lfi.hev_thr, 2);

    if u_ptr != null {
        loop_filter_horizontal_edge_c(u_ptr + 4 * uv_stride, uv_stride, lfi.blim, lfi.lim, lfi.hev_thr, 1);
    }

    if v_ptr != null {
        loop_filter_horizontal_edge_c(v_ptr + 4 * uv_stride, uv_stride, lfi.blim, lfi.lim, lfi.hev_thr, 1);
    }
}

loop_filter_horizontal_edge_c :: (s: *u8, p: s32, blimit: *u8, limit: *u8, thresh: *u8, count: s32) {
    hev: s32 = 0;
    mask: s8 = 0;
    i: s32 = 0;

    while true {
        mask =
            vp8_filter_mask(
                limit[0],
                blimit[0],
                s[-4 * p],
                s[-3 * p],
                s[-2 * p],
                s[-1 * p],
                s[0 * p],
                s[1 * p],
                s[2 * p],
                s[3 * p]
            );

        hev = cast,no_check(s32) vp8_hevmask(thresh[0], s[-2 * p], s[-1 * p], s[0 * p], s[1 * p]);

        vp8_filter(mask, cast,no_check(Uc) hev, s - 2 * p, s - 1 * p, s, s + 1 * p);

        s += 1;
        if !(c_transpiler_pre_increment(*(i)) < count * 8) break;
    }
}

vp8_filter :: (mask: s8, hev: Uc, op1: *Uc, op0: *Uc, oq0: *Uc, oq1: *Uc) {
    ps1 := cast,no_check(s8) ((cast(s32) (cast,no_check(s8) op1.*)) ^ 0x80);
    ps0 := cast,no_check(s8) ((cast(s32) (cast,no_check(s8) op0.*)) ^ 0x80);
    qs0 := cast,no_check(s8) ((cast(s32) (cast,no_check(s8) oq0.*)) ^ 0x80);
    qs1 := cast,no_check(s8) ((cast(s32) (cast,no_check(s8) oq1.*)) ^ 0x80);

    filter_value := vp8_signed_char_clamp((cast(s32) ps1) - cast(s32) qs1);
    filter_value = cast,no_check(s8) ((cast,no_check(s32) filter_value) & cast,no_check(s32) hev);

    filter_value = vp8_signed_char_clamp((cast(s32) filter_value) + 3 * ((cast(s32) qs0) - cast(s32) ps0));
    filter_value = cast,no_check(s8) ((cast,no_check(s32) filter_value) & cast,no_check(s32) mask);

    filter1 := vp8_signed_char_clamp((cast(s32) filter_value) + 4);
    filter2 := vp8_signed_char_clamp((cast(s32) filter_value) + 3);
    c_transpiler_compound_shr(*(filter1), (cast(s32) 3), s32, s32);
    c_transpiler_compound_shr(*(filter2), (cast(s32) 3), s32, s32);
    u := vp8_signed_char_clamp((cast(s32) qs0) - cast(s32) filter1);
    oq0.* = cast,no_check(Uc) ((cast(s32) u) ^ 0x80);
    u = vp8_signed_char_clamp((cast(s32) ps0) + cast(s32) filter2);
    op0.* = cast,no_check(Uc) ((cast(s32) u) ^ 0x80);
    filter_value = filter1;

    filter_value = cast,no_check(s8) ((cast,no_check(s32) filter_value) + 1);
    c_transpiler_compound_shr(*(filter_value), (cast(s32) 1), s32, s32);
    filter_value = cast,no_check(s8) ((cast,no_check(s32) filter_value) & ~(cast,no_check(s32) hev));

    u = vp8_signed_char_clamp((cast(s32) qs1) - cast(s32) filter_value);
    oq1.* = cast,no_check(Uc) ((cast(s32) u) ^ 0x80);
    u = vp8_signed_char_clamp((cast(s32) ps1) + cast(s32) filter_value);
    op1.* = cast,no_check(Uc) ((cast(s32) u) ^ 0x80);
}

vp8_signed_char_clamp :: (t: s32) -> s8 {
    t = ifx t < -128 then -128 else t;
    t = ifx t > 127 then 127 else t;
    return cast,no_check(s8) t;
}

vp8_hevmask :: (thresh: Uc, p1: Uc, p0: Uc, q0: Uc, q1: Uc) -> s8 {
    hev: s8 = 0;
    c_transpiler_compound_or(*(hev), (((cast(s32) (absolute_value((cast(s32) p1) - cast(s32) p0) > cast,no_check(s32) thresh)) * -1)), s32, s32);
    c_transpiler_compound_or(*(hev), (((cast(s32) (absolute_value((cast(s32) q1) - cast(s32) q0) > cast,no_check(s32) thresh)) * -1)), s32, s32);
    return hev;
}

vp8_filter_mask :: (limit: Uc, blimit: Uc, p3: Uc, p2: Uc, p1: Uc, p0: Uc, q0: Uc, q1: Uc, q2: Uc, q3: Uc) -> s8 {
    mask: s8 = 0;
    c_transpiler_compound_or(*(mask), ((absolute_value((cast(s32) p3) - cast(s32) p2) > cast,no_check(s32) limit)), s32, s32);
    c_transpiler_compound_or(*(mask), ((absolute_value((cast(s32) p2) - cast(s32) p1) > cast,no_check(s32) limit)), s32, s32);
    c_transpiler_compound_or(*(mask), ((absolute_value((cast(s32) p1) - cast(s32) p0) > cast,no_check(s32) limit)), s32, s32);
    c_transpiler_compound_or(*(mask), ((absolute_value((cast(s32) q1) - cast(s32) q0) > cast,no_check(s32) limit)), s32, s32);
    c_transpiler_compound_or(*(mask), ((absolute_value((cast(s32) q2) - cast(s32) q1) > cast,no_check(s32) limit)), s32, s32);
    c_transpiler_compound_or(*(mask), ((absolute_value((cast(s32) q3) - cast(s32) q2) > cast,no_check(s32) limit)), s32, s32);
    c_transpiler_compound_or(*(mask), ((((absolute_value((cast(s32) p0) - cast(s32) q0) * 2) + absolute_value((cast(s32) p1) - cast(s32) q1) / 2) > cast,no_check(s32) blimit)), s32, s32);
    return cast,no_check(s8) ((cast(s32) mask) - 1);
}

vp8_loop_filter_bv_c :: (y_ptr: *u8, u_ptr: *u8, v_ptr: *u8, y_stride: s32, uv_stride: s32, lfi: *Loop_Filter_Info) {
    loop_filter_vertical_edge_c(y_ptr + 4, y_stride, lfi.blim, lfi.lim, lfi.hev_thr, 2);
    loop_filter_vertical_edge_c(y_ptr + 8, y_stride, lfi.blim, lfi.lim, lfi.hev_thr, 2);
    loop_filter_vertical_edge_c(y_ptr + 12, y_stride, lfi.blim, lfi.lim, lfi.hev_thr, 2);

    if u_ptr != null {
        loop_filter_vertical_edge_c(u_ptr + 4, uv_stride, lfi.blim, lfi.lim, lfi.hev_thr, 1);
    }

    if v_ptr != null {
        loop_filter_vertical_edge_c(v_ptr + 4, uv_stride, lfi.blim, lfi.lim, lfi.hev_thr, 1);
    }
}

loop_filter_vertical_edge_c :: (s: *u8, p: s32, blimit: *u8, limit: *u8, thresh: *u8, count: s32) {
    hev: s32 = 0;
    mask: s8 = 0;
    i: s32 = 0;

    while true {
        mask = vp8_filter_mask(limit[0], blimit[0], s[-4], s[-3], s[-2], s[-1], s[0], s[1], s[2], s[3]);

        hev = cast,no_check(s32) vp8_hevmask(thresh[0], s[-2], s[-1], s[0], s[1]);

        vp8_filter(mask, cast,no_check(Uc) hev, s - 2, s - 1, s, s + 1);

        s += p;
        if !(c_transpiler_pre_increment(*(i)) < count * 8) break;
    }
}

vp8_loop_filter_mbh_c :: (y_ptr: *u8, u_ptr: *u8, v_ptr: *u8, y_stride: s32, uv_stride: s32, lfi: *Loop_Filter_Info) {
    mbloop_filter_horizontal_edge_c(y_ptr, y_stride, lfi.mblim, lfi.lim, lfi.hev_thr, 2);

    if u_ptr != null {
        mbloop_filter_horizontal_edge_c(u_ptr, uv_stride, lfi.mblim, lfi.lim, lfi.hev_thr, 1);
    }

    if v_ptr != null {
        mbloop_filter_horizontal_edge_c(v_ptr, uv_stride, lfi.mblim, lfi.lim, lfi.hev_thr, 1);
    }
}

mbloop_filter_horizontal_edge_c :: (s: *u8, p: s32, blimit: *u8, limit: *u8, thresh: *u8, count: s32) {
    hev: s8 = 0;
    mask: s8 = 0;
    i: s32 = 0;

    while true {
        mask =
            vp8_filter_mask(
                limit[0],
                blimit[0],
                s[-4 * p],
                s[-3 * p],
                s[-2 * p],
                s[-1 * p],
                s[0 * p],
                s[1 * p],
                s[2 * p],
                s[3 * p]
            );

        hev = vp8_hevmask(thresh[0], s[-2 * p], s[-1 * p], s[0 * p], s[1 * p]);

        vp8_mbfilter(mask, cast,no_check(Uc) hev, s - 3 * p, s - 2 * p, s - 1 * p, s, s + 1 * p, s + 2 * p);

        s += 1;
        if !(c_transpiler_pre_increment(*(i)) < count * 8) break;
    }
}

vp8_mbfilter :: (mask: s8, hev: Uc, op2: *Uc, op1: *Uc, op0: *Uc, oq0: *Uc, oq1: *Uc, oq2: *Uc) {
    ps2 := cast,no_check(s8) ((cast(s32) (cast,no_check(s8) op2.*)) ^ 0x80);
    ps1 := cast,no_check(s8) ((cast(s32) (cast,no_check(s8) op1.*)) ^ 0x80);
    ps0 := cast,no_check(s8) ((cast(s32) (cast,no_check(s8) op0.*)) ^ 0x80);
    qs0 := cast,no_check(s8) ((cast(s32) (cast,no_check(s8) oq0.*)) ^ 0x80);
    qs1 := cast,no_check(s8) ((cast(s32) (cast,no_check(s8) oq1.*)) ^ 0x80);
    qs2 := cast,no_check(s8) ((cast(s32) (cast,no_check(s8) oq2.*)) ^ 0x80);

    filter_value := vp8_signed_char_clamp((cast(s32) ps1) - cast(s32) qs1);
    filter_value = vp8_signed_char_clamp((cast(s32) filter_value) + 3 * ((cast(s32) qs0) - cast(s32) ps0));
    filter_value = cast,no_check(s8) ((cast,no_check(s32) filter_value) & cast,no_check(s32) mask);

    filter2 := filter_value;
    filter2 = cast,no_check(s8) ((cast,no_check(s32) filter2) & cast,no_check(s32) hev);

    filter1 := vp8_signed_char_clamp((cast(s32) filter2) + 4);
    filter2 = vp8_signed_char_clamp((cast(s32) filter2) + 3);
    c_transpiler_compound_shr(*(filter1), (cast(s32) 3), s32, s32);
    c_transpiler_compound_shr(*(filter2), (cast(s32) 3), s32, s32);
    qs0 = vp8_signed_char_clamp((cast(s32) qs0) - cast(s32) filter1);
    ps0 = vp8_signed_char_clamp((cast(s32) ps0) + cast(s32) filter2);

    filter_value = cast,no_check(s8) ((cast,no_check(s32) filter_value) & ~(cast,no_check(s32) hev));
    filter2 = filter_value;

    u := vp8_signed_char_clamp((63 + (cast(s32) filter2) * 27) >> 7);
    s := vp8_signed_char_clamp((cast(s32) qs0) - cast(s32) u);
    oq0.* = cast,no_check(Uc) ((cast(s32) s) ^ 0x80);
    s = vp8_signed_char_clamp((cast(s32) ps0) + cast(s32) u);
    op0.* = cast,no_check(Uc) ((cast(s32) s) ^ 0x80);

    u = vp8_signed_char_clamp((63 + (cast(s32) filter2) * 18) >> 7);
    s = vp8_signed_char_clamp((cast(s32) qs1) - cast(s32) u);
    oq1.* = cast,no_check(Uc) ((cast(s32) s) ^ 0x80);
    s = vp8_signed_char_clamp((cast(s32) ps1) + cast(s32) u);
    op1.* = cast,no_check(Uc) ((cast(s32) s) ^ 0x80);

    u = vp8_signed_char_clamp((63 + (cast(s32) filter2) * 9) >> 7);
    s = vp8_signed_char_clamp((cast(s32) qs2) - cast(s32) u);
    oq2.* = cast,no_check(Uc) ((cast(s32) s) ^ 0x80);
    s = vp8_signed_char_clamp((cast(s32) ps2) + cast(s32) u);
    op2.* = cast,no_check(Uc) ((cast(s32) s) ^ 0x80);
}

vp8_loop_filter_mbv_c :: (y_ptr: *u8, u_ptr: *u8, v_ptr: *u8, y_stride: s32, uv_stride: s32, lfi: *Loop_Filter_Info) {
    mbloop_filter_vertical_edge_c(y_ptr, y_stride, lfi.mblim, lfi.lim, lfi.hev_thr, 2);

    if u_ptr != null {
        mbloop_filter_vertical_edge_c(u_ptr, uv_stride, lfi.mblim, lfi.lim, lfi.hev_thr, 1);
    }

    if v_ptr != null {
        mbloop_filter_vertical_edge_c(v_ptr, uv_stride, lfi.mblim, lfi.lim, lfi.hev_thr, 1);
    }
}

mbloop_filter_vertical_edge_c :: (s: *u8, p: s32, blimit: *u8, limit: *u8, thresh: *u8, count: s32) {
    hev: s8 = 0;
    mask: s8 = 0;
    i: s32 = 0;

    while true {
        mask = vp8_filter_mask(limit[0], blimit[0], s[-4], s[-3], s[-2], s[-1], s[0], s[1], s[2], s[3]);

        hev = vp8_hevmask(thresh[0], s[-2], s[-1], s[0], s[1]);

        vp8_mbfilter(mask, cast,no_check(Uc) hev, s - 3, s - 2, s - 1, s, s + 1, s + 2);

        s += p;
        if !(c_transpiler_pre_increment(*(i)) < count * 8) break;
    }
}

vp8_loop_filter_bhs_c :: (y_ptr: *u8, y_stride: s32, blimit: *u8) {
    vp8_loop_filter_simple_horizontal_edge_c(y_ptr + 4 * y_stride, y_stride, blimit);
    vp8_loop_filter_simple_horizontal_edge_c(y_ptr + 8 * y_stride, y_stride, blimit);
    vp8_loop_filter_simple_horizontal_edge_c(y_ptr + 12 * y_stride, y_stride, blimit);
}

vp8_loop_filter_simple_horizontal_edge_c :: (y_ptr: *u8, y_stride: s32, blimit: *u8) {
    mask: s8 = 0;
    i: s32 = 0;

    while true {
        mask =
            vp8_simple_filter_mask(
                blimit[0],
                y_ptr[-2 * y_stride],
                y_ptr[-1 * y_stride],
                y_ptr[0 * y_stride],
                y_ptr[1 * y_stride]
            );
        vp8_simple_filter(mask, y_ptr - 2 * y_stride, y_ptr - 1 * y_stride, y_ptr, y_ptr + 1 * y_stride);
        y_ptr += 1;
        if !(c_transpiler_pre_increment(*(i)) < 16) break;
    }
}

vp8_simple_filter :: (mask: s8, op1: *Uc, op0: *Uc, oq0: *Uc, oq1: *Uc) {
    p1 := cast,no_check(s8) ((cast(s32) (cast,no_check(s8) op1.*)) ^ 0x80);
    p0 := cast,no_check(s8) ((cast(s32) (cast,no_check(s8) op0.*)) ^ 0x80);
    q0 := cast,no_check(s8) ((cast(s32) (cast,no_check(s8) oq0.*)) ^ 0x80);
    q1 := cast,no_check(s8) ((cast(s32) (cast,no_check(s8) oq1.*)) ^ 0x80);

    filter_value := vp8_signed_char_clamp((cast(s32) p1) - cast(s32) q1);
    filter_value = vp8_signed_char_clamp((cast(s32) filter_value) + 3 * ((cast(s32) q0) - cast(s32) p0));
    filter_value = cast,no_check(s8) ((cast,no_check(s32) filter_value) & cast,no_check(s32) mask);

    filter1 := vp8_signed_char_clamp((cast(s32) filter_value) + 4);
    c_transpiler_compound_shr(*(filter1), (cast(s32) 3), s32, s32);
    u := vp8_signed_char_clamp((cast(s32) q0) - cast(s32) filter1);
    oq0.* = cast,no_check(Uc) ((cast(s32) u) ^ 0x80);

    filter2 := vp8_signed_char_clamp((cast(s32) filter_value) + 3);
    c_transpiler_compound_shr(*(filter2), (cast(s32) 3), s32, s32);
    u = vp8_signed_char_clamp((cast(s32) p0) + cast(s32) filter2);
    op0.* = cast,no_check(Uc) ((cast(s32) u) ^ 0x80);
}

vp8_simple_filter_mask :: (blimit: Uc, p1: Uc, p0: Uc, q0: Uc, q1: Uc) -> s8 {
    mask :=
        cast,no_check(s8) ((cast(s32) (((absolute_value((cast(s32) p0) - cast(s32) q0) * 2) + absolute_value((cast(s32) p1) - cast(s32) q1) / 2) <= cast,no_check(s32) blimit)) *
            -1);
    return mask;
}

vp8_loop_filter_bvs_c :: (y_ptr: *u8, y_stride: s32, blimit: *u8) {
    vp8_loop_filter_simple_vertical_edge_c(y_ptr + 4, y_stride, blimit);
    vp8_loop_filter_simple_vertical_edge_c(y_ptr + 8, y_stride, blimit);
    vp8_loop_filter_simple_vertical_edge_c(y_ptr + 12, y_stride, blimit);
}

vp8_loop_filter_simple_vertical_edge_c :: (y_ptr: *u8, y_stride: s32, blimit: *u8) {
    mask: s8 = 0;
    i: s32 = 0;

    while true {
        mask = vp8_simple_filter_mask(blimit[0], y_ptr[-2], y_ptr[-1], y_ptr[0], y_ptr[1]);
        vp8_simple_filter(mask, y_ptr - 2, y_ptr - 1, y_ptr, y_ptr + 1);
        y_ptr += y_stride;
        if !(c_transpiler_pre_increment(*(i)) < 16) break;
    }
}

