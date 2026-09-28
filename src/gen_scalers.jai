// Generated directly from C by cpp_transpiler.
vp8_horizontal_line_2_1_scale_c :: (source: *u8, source_width: u32, dest: *u8, dest_width: u32) {
    des := dest;
    src := source;

    i: u32 = 0;
    while i < source_width {
        a := cast,no_check(u32) src[0];
        des[0] = cast,no_check(u8) a;
        src += 2;
        des += 1;
        i += 2;
    }
}

vp8_horizontal_line_5_3_scale_c :: (source: *u8, source_width: u32, dest: *u8, dest_width: u32) {
    des := dest;
    src := source;

    i: u32 = 0;
    while i < source_width {
        a := cast,no_check(u32) src[0];
        b := cast,no_check(u32) src[1];
        c := cast,no_check(u32) src[2];
        d := cast,no_check(u32) src[3];
        e := cast,no_check(u32) src[4];

        des[0] = cast,no_check(u8) a;
        des[1] = cast,no_check(u8) ((((b * 85) + c * 171) + 128) >> 8);
        des[2] = cast,no_check(u8) ((((d * 171) + e * 85) + 128) >> 8);

        src += 5;
        des += 3;
        i += 5;
    }
}

vp8_horizontal_line_5_4_scale_c :: (source: *u8, source_width: u32, dest: *u8, dest_width: u32) {
    des := dest;
    src := source;

    i: u32 = 0;
    while i < source_width {
        a := cast,no_check(u32) src[0];
        b := cast,no_check(u32) src[1];
        c := cast,no_check(u32) src[2];
        d := cast,no_check(u32) src[3];
        e := cast,no_check(u32) src[4];

        des[0] = cast,no_check(u8) a;
        des[1] = cast,no_check(u8) ((((b * 192) + c * 64) + 128) >> 8);
        des[2] = cast,no_check(u8) ((((c * 128) + d * 128) + 128) >> 8);
        des[3] = cast,no_check(u8) ((((d * 64) + e * 192) + 128) >> 8);

        src += 5;
        des += 4;
        i += 5;
    }
}

vp8_vertical_band_2_1_scale_c :: (source: *u8, src_pitch: u32, dest: *u8, dest_pitch: u32, dest_width: u32) {
    copy_memory(dest, source, cast,no_check(u64) dest_width);
}

vp8_vertical_band_2_1_scale_i_c :: (source: *u8, src_pitch: u32, dest: *u8, dest_pitch: u32, dest_width: u32) {
    width := cast,no_check(s32) dest_width;

    if 0 < width {
        for i: 0..width - 1 {
            temp: s32 = 8;
            temp += (cast(s32) source[i - cast,no_check(s32) src_pitch]) * 3;
            temp += (cast(s32) source[i]) * 10;
            temp += (cast(s32) source[(cast,no_check(u32) i) + src_pitch]) * 3;
            c_transpiler_compound_shr(*(temp), (cast(s32) 4), s32, s32);
            dest[i] = cast,no_check(u8) temp;
        }
    }
}

vp8_vertical_band_5_3_scale_c :: (source: *u8, src_pitch: u32, dest: *u8, dest_pitch: u32, dest_width: u32) {
    des := dest;
    src := source;

    if 0 < dest_width {
        for i: 0..dest_width - 1 {
            a := cast,no_check(u32) src[0 * src_pitch];
            b := cast,no_check(u32) src[1 * src_pitch];
            c := cast,no_check(u32) src[2 * src_pitch];
            d := cast,no_check(u32) src[3 * src_pitch];
            e := cast,no_check(u32) src[4 * src_pitch];

            des[0 * dest_pitch] = cast,no_check(u8) a;
            des[1 * dest_pitch] = cast,no_check(u8) ((((b * 85) + c * 171) + 128) >> 8);
            des[2 * dest_pitch] = cast,no_check(u8) ((((d * 171) + e * 85) + 128) >> 8);

            src += 1;
            des += 1;
        }
    }
}

vp8_vertical_band_5_4_scale_c :: (source: *u8, src_pitch: u32, dest: *u8, dest_pitch: u32, dest_width: u32) {
    des := dest;
    src := source;

    if 0 < dest_width {
        for i: 0..dest_width - 1 {
            a := cast,no_check(u32) src[0 * src_pitch];
            b := cast,no_check(u32) src[1 * src_pitch];
            c := cast,no_check(u32) src[2 * src_pitch];
            d := cast,no_check(u32) src[3 * src_pitch];
            e := cast,no_check(u32) src[4 * src_pitch];

            des[0 * dest_pitch] = cast,no_check(u8) a;
            des[1 * dest_pitch] = cast,no_check(u8) ((((b * 192) + c * 64) + 128) >> 8);
            des[2 * dest_pitch] = cast,no_check(u8) ((((c * 128) + d * 128) + 128) >> 8);
            des[3 * dest_pitch] = cast,no_check(u8) ((((d * 64) + e * 192) + 128) >> 8);

            src += 1;
            des += 1;
        }
    }
}

