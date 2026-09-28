clip_pixel_in_loopfilter :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_loopfilter :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_loopfilter :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_loopfilter :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_loopfilter :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_loopfilter(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_loopfilter(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_loopfilter(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_loopfilter :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_loopfilter :: (FILTER: *s16) -> s32 {
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

lpf_horizontal_16_c :: (s: *u8, pitch: s32, blimit: *u8, limit: *u8, thresh: *u8) {
    mb_lpf_horizontal_edge_w(s, pitch, blimit, limit, thresh, 1);
}

mb_lpf_horizontal_edge_w :: (s: *u8, pitch: s32, blimit: *u8, limit: *u8, thresh: *u8, count: s32) {
    i: s32 = 0;
    while i < 8 * count {
        P3 := s[-4 * pitch];
        P2 := s[-3 * pitch];
        P1 := s[-2 * pitch];
        P0 := s[-pitch];
        Q0 := s[0 * pitch];
        Q1 := s[1 * pitch];
        Q2 := s[2 * pitch];
        Q3 := s[3 * pitch];
        MASK := filter_mask(limit.*, blimit.*, P3, P2, P1, P0, Q0, Q1, Q2, Q3);
        FLAT := flat_mask4(1, P3, P2, P1, P0, Q0, Q1, Q2, Q3);
        FLAT2 :=
            flat_mask5(
                1,
                s[-8 * pitch],
                s[-7 * pitch],
                s[-6 * pitch],
                s[-5 * pitch],
                P0,
                Q0,
                s[4 * pitch],
                s[5 * pitch],
                s[6 * pitch],
                s[7 * pitch]
            );

        filter16(
            MASK,
            thresh.*,
            FLAT,
            FLAT2,
            s - 8 * pitch,
            s - 7 * pitch,
            s - 6 * pitch,
            s - 5 * pitch,
            s - 4 * pitch,
            s - 3 * pitch,
            s - 2 * pitch,
            s - 1 * pitch,
            s,
            s + 1 * pitch,
            s + 2 * pitch,
            s + 3 * pitch,
            s + 4 * pitch,
            s + 5 * pitch,
            s + 6 * pitch,
            s + 7 * pitch
        );
        s += 1;
        i += 1;
    }
}

flat_mask5 :: (thresh: u8, p4: u8, p3: u8, p2: u8, p1: u8, p0: u8, q0: u8, q1: u8, q2: u8, q3: u8, q4: u8) -> s8 {
    mask := cast,no_check(s8) (~(cast,no_check(s32) flat_mask4(thresh, p3, p2, p1, p0, q0, q1, q2, q3)));
    c_transpiler_compound_or(*(mask), (((cast(s32) (absolute_value((cast(s32) p4) - cast(s32) p0) > cast,no_check(s32) thresh)) * -1)), s32, s32);
    c_transpiler_compound_or(*(mask), (((cast(s32) (absolute_value((cast(s32) q4) - cast(s32) q0) > cast,no_check(s32) thresh)) * -1)), s32, s32);
    return cast,no_check(s8) (~(cast,no_check(s32) mask));
}

flat_mask4 :: (thresh: u8, p3: u8, p2: u8, p1: u8, p0: u8, q0: u8, q1: u8, q2: u8, q3: u8) -> s8 {
    mask: s8 = 0;
    c_transpiler_compound_or(*(mask), (((cast(s32) (absolute_value((cast(s32) p1) - cast(s32) p0) > cast,no_check(s32) thresh)) * -1)), s32, s32);
    c_transpiler_compound_or(*(mask), (((cast(s32) (absolute_value((cast(s32) q1) - cast(s32) q0) > cast,no_check(s32) thresh)) * -1)), s32, s32);
    c_transpiler_compound_or(*(mask), (((cast(s32) (absolute_value((cast(s32) p2) - cast(s32) p0) > cast,no_check(s32) thresh)) * -1)), s32, s32);
    c_transpiler_compound_or(*(mask), (((cast(s32) (absolute_value((cast(s32) q2) - cast(s32) q0) > cast,no_check(s32) thresh)) * -1)), s32, s32);
    c_transpiler_compound_or(*(mask), (((cast(s32) (absolute_value((cast(s32) p3) - cast(s32) p0) > cast,no_check(s32) thresh)) * -1)), s32, s32);
    c_transpiler_compound_or(*(mask), (((cast(s32) (absolute_value((cast(s32) q3) - cast(s32) q0) > cast,no_check(s32) thresh)) * -1)), s32, s32);
    return cast,no_check(s8) (~(cast,no_check(s32) mask));
}

filter_mask :: (limit: u8, blimit: u8, p3: u8, p2: u8, p1: u8, p0: u8, q0: u8, q1: u8, q2: u8, q3: u8) -> s8 {
    mask: s8 = 0;
    c_transpiler_compound_or(*(mask), (((cast(s32) (absolute_value((cast(s32) p3) - cast(s32) p2) > cast,no_check(s32) limit)) * -1)), s32, s32);
    c_transpiler_compound_or(*(mask), (((cast(s32) (absolute_value((cast(s32) p2) - cast(s32) p1) > cast,no_check(s32) limit)) * -1)), s32, s32);
    c_transpiler_compound_or(*(mask), (((cast(s32) (absolute_value((cast(s32) p1) - cast(s32) p0) > cast,no_check(s32) limit)) * -1)), s32, s32);
    c_transpiler_compound_or(*(mask), (((cast(s32) (absolute_value((cast(s32) q1) - cast(s32) q0) > cast,no_check(s32) limit)) * -1)), s32, s32);
    c_transpiler_compound_or(*(mask), (((cast(s32) (absolute_value((cast(s32) q2) - cast(s32) q1) > cast,no_check(s32) limit)) * -1)), s32, s32);
    c_transpiler_compound_or(*(mask), (((cast(s32) (absolute_value((cast(s32) q3) - cast(s32) q2) > cast,no_check(s32) limit)) * -1)), s32, s32);
    c_transpiler_compound_or(*(mask), (((cast(s32) (((absolute_value((cast(s32) p0) - cast(s32) q0) * 2) + absolute_value((cast(s32) p1) - cast(s32) q1) / 2) > cast,no_check(s32) blimit)) * -1)), s32, s32);
    return cast,no_check(s8) (~(cast,no_check(s32) mask));
}

filter16 :: (
    mask: s8,
    thresh: u8,
    flat: s8,
    flat2: s8,
    op7: *u8,
    op6: *u8,
    op5: *u8,
    op4: *u8,
    op3: *u8,
    op2: *u8,
    op1: *u8,
    op0: *u8,
    oq0: *u8,
    oq1: *u8,
    oq2: *u8,
    oq3: *u8,
    oq4: *u8,
    oq5: *u8,
    oq6: *u8,
    oq7: *u8
) {
    if flat2 != 0 && flat != 0 && mask != 0 {
        P7 := op7.*;
        P6 := op6.*;
        P5 := op5.*;
        P4 := op4.*;
        P3 := op3.*;
        P2 := op2.*;
        P1 := op1.*;
        P0 := op0.*;

        Q0 := oq0.*;
        Q1 := oq1.*;
        Q2 := oq2.*;
        Q3 := oq3.*;
        Q4 := oq4.*;
        Q5 := oq5.*;
        Q6 := oq6.*;
        Q7 := oq7.*;

        op6.* =
            cast,no_check(u8) ((((((((((cast(s32) P7) * 7 + (cast(s32) P6) * 2 + cast(s32) P5) + cast(s32) P4) + cast(s32) P3) + cast(s32) P2) + cast(s32) P1) + cast(s32) P0) + cast(s32) Q0) +
                (cast(s32) 1) << (((4 - 1)) & 31)) >> 4);
        op5.* =
            cast,no_check(u8) ((((((((((((cast(s32) P7) * 6 + cast(s32) P6) + (cast(s32) P5) * 2) + cast(s32) P4) + cast(s32) P3) + cast(s32) P2) + cast(s32) P1) + cast(s32) P0) + cast(s32) Q0) + cast(s32) Q1) +
                (cast(s32) 1) << (((4 - 1)) & 31)) >> 4);
        op4.* =
            cast,no_check(u8) (((((((((((((cast(s32) P7) * 5 + cast(s32) P6) + cast(s32) P5) + (cast(s32) P4) * 2) + cast(s32) P3) + cast(s32) P2) + cast(s32) P1) + cast(s32) P0) + cast(s32) Q0) + cast(s32) Q1) + cast(s32) Q2) +
                (cast(s32) 1) << (((4 - 1)) & 31)) >> 4);
        op3.* =
            cast,no_check(u8) ((((((((((((((cast(s32) P7) * 4 + cast(s32) P6) + cast(s32) P5) + cast(s32) P4) + (cast(s32) P3) * 2) + cast(s32) P2) + cast(s32) P1) + cast(s32) P0) + cast(s32) Q0) + cast(s32) Q1) + cast(s32) Q2) + cast(s32) Q3) +
                (cast(s32) 1) << (((4 - 1)) & 31)) >> 4);
        op2.* =
            cast,no_check(u8) (((((((((((((((cast(s32) P7) * 3 + cast(s32) P6) + cast(s32) P5) + cast(s32) P4) + cast(s32) P3) + (cast(s32) P2) * 2) + cast(s32) P1) + cast(s32) P0) + cast(s32) Q0) + cast(s32) Q1) + cast(s32) Q2) + cast(s32) Q3) + cast(s32) Q4) +
                (cast(s32) 1) << (((4 - 1)) & 31)) >> 4);
        op1.* =
            cast,no_check(u8) ((((((((((((((((cast(s32) P7) * 2 + cast(s32) P6) + cast(s32) P5) + cast(s32) P4) + cast(s32) P3) + cast(s32) P2) + (cast(s32) P1) * 2) + cast(s32) P0) + cast(s32) Q0) + cast(s32) Q1) + cast(s32) Q2) + cast(s32) Q3) + cast(s32) Q4) + cast(s32) Q5) +
                (cast(s32) 1) << (((4 - 1)) & 31)) >> 4);
        op0.* =
            cast,no_check(u8) (((((((((((((((((cast(s32) P7) + cast(s32) P6) + cast(s32) P5) + cast(s32) P4) + cast(s32) P3) + cast(s32) P2) + cast(s32) P1) + (cast(s32) P0) * 2) + cast(s32) Q0) + cast(s32) Q1) + cast(s32) Q2) + cast(s32) Q3) + cast(s32) Q4) + cast(s32) Q5) + cast(s32) Q6) +
                (cast(s32) 1) << (((4 - 1)) & 31)) >> 4);
        oq0.* =
            cast,no_check(u8) (((((((((((((((((cast(s32) P6) + cast(s32) P5) + cast(s32) P4) + cast(s32) P3) + cast(s32) P2) + cast(s32) P1) + cast(s32) P0) + (cast(s32) Q0) * 2) + cast(s32) Q1) + cast(s32) Q2) + cast(s32) Q3) + cast(s32) Q4) + cast(s32) Q5) + cast(s32) Q6) + cast(s32) Q7) +
                (cast(s32) 1) << (((4 - 1)) & 31)) >> 4);
        oq1.* =
            cast,no_check(u8) ((((((((((((((((cast(s32) P5) + cast(s32) P4) + cast(s32) P3) + cast(s32) P2) + cast(s32) P1) + cast(s32) P0) + cast(s32) Q0) + (cast(s32) Q1) * 2) + cast(s32) Q2) + cast(s32) Q3) + cast(s32) Q4) + cast(s32) Q5) + cast(s32) Q6) + (cast(s32) Q7) * 2) +
                (cast(s32) 1) << (((4 - 1)) & 31)) >> 4);
        oq2.* =
            cast,no_check(u8) (((((((((((((((cast(s32) P4) + cast(s32) P3) + cast(s32) P2) + cast(s32) P1) + cast(s32) P0) + cast(s32) Q0) + cast(s32) Q1) + (cast(s32) Q2) * 2) + cast(s32) Q3) + cast(s32) Q4) + cast(s32) Q5) + cast(s32) Q6) + (cast(s32) Q7) * 3) +
                (cast(s32) 1) << (((4 - 1)) & 31)) >> 4);
        oq3.* =
            cast,no_check(u8) ((((((((((((((cast(s32) P3) + cast(s32) P2) + cast(s32) P1) + cast(s32) P0) + cast(s32) Q0) + cast(s32) Q1) + cast(s32) Q2) + (cast(s32) Q3) * 2) + cast(s32) Q4) + cast(s32) Q5) + cast(s32) Q6) + (cast(s32) Q7) * 4) +
                (cast(s32) 1) << (((4 - 1)) & 31)) >> 4);
        oq4.* =
            cast,no_check(u8) (((((((((((((cast(s32) P2) + cast(s32) P1) + cast(s32) P0) + cast(s32) Q0) + cast(s32) Q1) + cast(s32) Q2) + cast(s32) Q3) + (cast(s32) Q4) * 2) + cast(s32) Q5) + cast(s32) Q6) + (cast(s32) Q7) * 5) +
                (cast(s32) 1) << (((4 - 1)) & 31)) >> 4);
        oq5.* =
            cast,no_check(u8) ((((((((((((cast(s32) P1) + cast(s32) P0) + cast(s32) Q0) + cast(s32) Q1) + cast(s32) Q2) + cast(s32) Q3) + cast(s32) Q4) + (cast(s32) Q5) * 2) + cast(s32) Q6) + (cast(s32) Q7) * 6) +
                (cast(s32) 1) << (((4 - 1)) & 31)) >> 4);
        oq6.* =
            cast,no_check(u8) (((((((((((cast(s32) P0) + cast(s32) Q0) + cast(s32) Q1) + cast(s32) Q2) + cast(s32) Q3) + cast(s32) Q4) + cast(s32) Q5) + (cast(s32) Q6) * 2) + (cast(s32) Q7) * 7) +
                (cast(s32) 1) << (((4 - 1)) & 31)) >> 4);
    } else {
        filter8(mask, thresh, flat, op3, op2, op1, op0, oq0, oq1, oq2, oq3);
    }
}

filter8 :: (
    mask: s8,
    thresh: u8,
    flat: s8,
    op3: *u8,
    op2: *u8,
    op1: *u8,
    op0: *u8,
    oq0: *u8,
    oq1: *u8,
    oq2: *u8,
    oq3: *u8
) {
    if flat != 0 && mask != 0 {
        P3 := op3.*;
        P2 := op2.*;
        P1 := op1.*;
        P0 := op0.*;
        Q0 := oq0.*;
        Q1 := oq1.*;
        Q2 := oq2.*;
        Q3 := oq3.*;

        op2.* =
            cast,no_check(u8) (((((((((cast(s32) P3) + cast(s32) P3) + cast(s32) P3) + 2 * cast(s32) P2) + cast(s32) P1) + cast(s32) P0) + cast(s32) Q0) +
                (cast(s32) 1) << (((3 - 1)) & 31)) >> 3);
        op1.* =
            cast,no_check(u8) (((((((((cast(s32) P3) + cast(s32) P3) + cast(s32) P2) + 2 * cast(s32) P1) + cast(s32) P0) + cast(s32) Q0) + cast(s32) Q1) +
                (cast(s32) 1) << (((3 - 1)) & 31)) >> 3);
        op0.* =
            cast,no_check(u8) (((((((((cast(s32) P3) + cast(s32) P2) + cast(s32) P1) + 2 * cast(s32) P0) + cast(s32) Q0) + cast(s32) Q1) + cast(s32) Q2) +
                (cast(s32) 1) << (((3 - 1)) & 31)) >> 3);
        oq0.* =
            cast,no_check(u8) (((((((((cast(s32) P2) + cast(s32) P1) + cast(s32) P0) + 2 * cast(s32) Q0) + cast(s32) Q1) + cast(s32) Q2) + cast(s32) Q3) +
                (cast(s32) 1) << (((3 - 1)) & 31)) >> 3);
        oq1.* =
            cast,no_check(u8) (((((((((cast(s32) P1) + cast(s32) P0) + cast(s32) Q0) + 2 * cast(s32) Q1) + cast(s32) Q2) + cast(s32) Q3) + cast(s32) Q3) +
                (cast(s32) 1) << (((3 - 1)) & 31)) >> 3);
        oq2.* =
            cast,no_check(u8) (((((((((cast(s32) P0) + cast(s32) Q0) + cast(s32) Q1) + 2 * cast(s32) Q2) + cast(s32) Q3) + cast(s32) Q3) + cast(s32) Q3) +
                (cast(s32) 1) << (((3 - 1)) & 31)) >> 3);
    } else {
        filter4(mask, thresh, op1, op0, oq0, oq1);
    }
}

filter4 :: (mask: s8, thresh: u8, op1: *u8, op0: *u8, oq0: *u8, oq1: *u8) {
    PS1 := cast,no_check(s8) ((cast(s32) op1.*) ^ 0x80);
    PS0 := cast,no_check(s8) ((cast(s32) op0.*) ^ 0x80);
    QS0 := cast,no_check(s8) ((cast(s32) oq0.*) ^ 0x80);
    QS1 := cast,no_check(s8) ((cast(s32) oq1.*) ^ 0x80);
    HEV := hev_mask(thresh, op1.*, op0.*, oq0.*, oq1.*);

    filter := cast,no_check(s8) ((cast(s32) signed_char_clamp((cast(s32) PS1) - cast(s32) QS1)) & cast(s32) HEV);

    filter =
        cast,no_check(s8) ((cast(s32) signed_char_clamp((cast(s32) filter) +
            3 * ((cast(s32) QS0) - cast(s32) PS0))) & cast(s32) mask);

    filter1 := cast,no_check(s8) ((cast(s32) signed_char_clamp((cast(s32) filter) + 4)) >> 3);
    filter2 := cast,no_check(s8) ((cast(s32) signed_char_clamp((cast(s32) filter) + 3)) >> 3);

    oq0.* = cast,no_check(u8) ((cast(s32) signed_char_clamp((cast(s32) QS0) - cast(s32) filter1)) ^ 0x80);
    op0.* = cast,no_check(u8) ((cast(s32) signed_char_clamp((cast(s32) PS0) + cast(s32) filter2)) ^ 0x80);

    filter =
        cast,no_check(s8) (((cast(s32) filter1) +
            (cast(s32) 1) << (((1 - 1)) & 31)) >> 1 & ~(cast,no_check(s32) HEV));

    oq1.* = cast,no_check(u8) ((cast(s32) signed_char_clamp((cast(s32) QS1) - cast(s32) filter)) ^ 0x80);
    op1.* = cast,no_check(u8) ((cast(s32) signed_char_clamp((cast(s32) PS1) + cast(s32) filter)) ^ 0x80);
}

hev_mask :: (thresh: u8, p1: u8, p0: u8, q0: u8, q1: u8) -> s8 {
    hev: s8 = 0;
    c_transpiler_compound_or(*(hev), (((cast(s32) (absolute_value((cast(s32) p1) - cast(s32) p0) > cast,no_check(s32) thresh)) * -1)), s32, s32);
    c_transpiler_compound_or(*(hev), (((cast(s32) (absolute_value((cast(s32) q1) - cast(s32) q0) > cast,no_check(s32) thresh)) * -1)), s32, s32);
    return hev;
}

signed_char_clamp :: (t: s32) -> s8 {
    return cast,no_check(s8) clamp_in_loopfilter(t, -128, 127);
}

lpf_horizontal_16_dual_c :: (s: *u8, pitch: s32, blimit: *u8, limit: *u8, thresh: *u8) {
    mb_lpf_horizontal_edge_w(s, pitch, blimit, limit, thresh, 2);
}

lpf_horizontal_4_c :: (s: *u8, pitch: s32, blimit: *u8, limit: *u8, thresh: *u8) {
    for i: 0..cast(s32) 8 - 1 {
        P3 := s[-4 * pitch];
        P2 := s[-3 * pitch];
        P1 := s[-2 * pitch];
        P0 := s[-pitch];
        Q0 := s[0 * pitch];
        Q1 := s[1 * pitch];
        Q2 := s[2 * pitch];
        Q3 := s[3 * pitch];
        MASK := filter_mask(limit.*, blimit.*, P3, P2, P1, P0, Q0, Q1, Q2, Q3);
        filter4(MASK, thresh.*, s - 2 * pitch, s - 1 * pitch, s, s + 1 * pitch);
        s += 1;
    }
}

lpf_horizontal_4_dual_c :: (
    s: *u8,
    pitch: s32,
    blimit0: *u8,
    limit0: *u8,
    thresh0: *u8,
    blimit1: *u8,
    limit1: *u8,
    thresh1: *u8
) {
    lpf_horizontal_4_c(s, pitch, blimit0, limit0, thresh0);
    lpf_horizontal_4_c(s + 8, pitch, blimit1, limit1, thresh1);
}

lpf_horizontal_8_c :: (s: *u8, pitch: s32, blimit: *u8, limit: *u8, thresh: *u8) {
    for i: 0..cast(s32) 8 - 1 {
        P3 := s[-4 * pitch];
        P2 := s[-3 * pitch];
        P1 := s[-2 * pitch];
        P0 := s[-pitch];
        Q0 := s[0 * pitch];
        Q1 := s[1 * pitch];
        Q2 := s[2 * pitch];
        Q3 := s[3 * pitch];

        MASK := filter_mask(limit.*, blimit.*, P3, P2, P1, P0, Q0, Q1, Q2, Q3);
        FLAT := flat_mask4(1, P3, P2, P1, P0, Q0, Q1, Q2, Q3);
        filter8(
            MASK,
            thresh.*,
            FLAT,
            s - 4 * pitch,
            s - 3 * pitch,
            s - 2 * pitch,
            s - 1 * pitch,
            s,
            s + 1 * pitch,
            s + 2 * pitch,
            s + 3 * pitch
        );
        s += 1;
    }
}

lpf_horizontal_8_dual_c :: (
    s: *u8,
    pitch: s32,
    blimit0: *u8,
    limit0: *u8,
    thresh0: *u8,
    blimit1: *u8,
    limit1: *u8,
    thresh1: *u8
) {
    lpf_horizontal_8_c(s, pitch, blimit0, limit0, thresh0);
    lpf_horizontal_8_c(s + 8, pitch, blimit1, limit1, thresh1);
}

lpf_vertical_16_c :: (s: *u8, pitch: s32, blimit: *u8, limit: *u8, thresh: *u8) {
    mb_lpf_vertical_edge_w(s, pitch, blimit, limit, thresh, 8);
}

mb_lpf_vertical_edge_w :: (s: *u8, pitch: s32, blimit: *u8, limit: *u8, thresh: *u8, count: s32) {
    if 0 < count {
        for i: 0..count - 1 {
            P3 := s[-4];
            P2 := s[-3];
            P1 := s[-2];
            P0 := s[-1];
            Q0 := s[0];
            Q1 := s[1];
            Q2 := s[2];
            Q3 := s[3];
            MASK := filter_mask(limit.*, blimit.*, P3, P2, P1, P0, Q0, Q1, Q2, Q3);
            FLAT := flat_mask4(1, P3, P2, P1, P0, Q0, Q1, Q2, Q3);
            FLAT2 := flat_mask5(1, s[-8], s[-7], s[-6], s[-5], P0, Q0, s[4], s[5], s[6], s[7]);

            filter16(
                MASK,
                thresh.*,
                FLAT,
                FLAT2,
                s - 8,
                s - 7,
                s - 6,
                s - 5,
                s - 4,
                s - 3,
                s - 2,
                s - 1,
                s,
                s + 1,
                s + 2,
                s + 3,
                s + 4,
                s + 5,
                s + 6,
                s + 7
            );
            s += pitch;
        }
    }
}

lpf_vertical_16_dual_c :: (s: *u8, pitch: s32, blimit: *u8, limit: *u8, thresh: *u8) {
    mb_lpf_vertical_edge_w(s, pitch, blimit, limit, thresh, 16);
}

lpf_vertical_4_c :: (s: *u8, pitch: s32, blimit: *u8, limit: *u8, thresh: *u8) {
    for i: 0..cast(s32) 8 - 1 {
        P3 := s[-4];
        P2 := s[-3];
        P1 := s[-2];
        P0 := s[-1];
        Q0 := s[0];
        Q1 := s[1];
        Q2 := s[2];
        Q3 := s[3];
        MASK := filter_mask(limit.*, blimit.*, P3, P2, P1, P0, Q0, Q1, Q2, Q3);
        filter4(MASK, thresh.*, s - 2, s - 1, s, s + 1);
        s += pitch;
    }
}

lpf_vertical_4_dual_c :: (
    s: *u8,
    pitch: s32,
    blimit0: *u8,
    limit0: *u8,
    thresh0: *u8,
    blimit1: *u8,
    limit1: *u8,
    thresh1: *u8
) {
    lpf_vertical_4_c(s, pitch, blimit0, limit0, thresh0);
    lpf_vertical_4_c(s + 8 * pitch, pitch, blimit1, limit1, thresh1);
}

lpf_vertical_8_c :: (s: *u8, pitch: s32, blimit: *u8, limit: *u8, thresh: *u8) {
    for i: 0..cast(s32) 8 - 1 {
        P3 := s[-4];
        P2 := s[-3];
        P1 := s[-2];
        P0 := s[-1];
        Q0 := s[0];
        Q1 := s[1];
        Q2 := s[2];
        Q3 := s[3];
        MASK := filter_mask(limit.*, blimit.*, P3, P2, P1, P0, Q0, Q1, Q2, Q3);
        FLAT := flat_mask4(1, P3, P2, P1, P0, Q0, Q1, Q2, Q3);
        filter8(MASK, thresh.*, FLAT, s - 4, s - 3, s - 2, s - 1, s, s + 1, s + 2, s + 3);
        s += pitch;
    }
}

lpf_vertical_8_dual_c :: (
    s: *u8,
    pitch: s32,
    blimit0: *u8,
    limit0: *u8,
    thresh0: *u8,
    blimit1: *u8,
    limit1: *u8,
    thresh1: *u8
) {
    lpf_vertical_8_c(s, pitch, blimit0, limit0, thresh0);
    lpf_vertical_8_c(s + 8 * pitch, pitch, blimit1, limit1, thresh1);
}

