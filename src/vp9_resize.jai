Interp_Kernel_in_vp9_resize :: [8] s16;

FILTEREDINTERP_FILTERS500: [32] Interp_Kernel_in_vp9_resize;

FILTEREDINTERP_FILTERS625: [32] Interp_Kernel_in_vp9_resize;

FILTEREDINTERP_FILTERS750: [32] Interp_Kernel_in_vp9_resize;

FILTEREDINTERP_FILTERS875: [32] Interp_Kernel_in_vp9_resize;

FILTEREDINTERP_FILTERS1000: [32] Interp_Kernel_in_vp9_resize;

VP9_DOWN2_SYMEVEN_HALF_FILTER: [4] s16;

VP9_DOWN2_SYMODD_HALF_FILTER: [4] s16;

clip_pixel_in_vp9_resize :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_resize :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_resize :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_resize :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_resize :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_resize(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_resize(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_resize(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_resize :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_lsb_in_vp9_resize :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_resize :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_resize :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_resize(num_values) + 1 else 0;
}

vp9_resize_plane :: (
    INPUT: *u8,
    height: s32,
    width: s32,
    in_stride: s32,
    output: *u8,
    height2: s32,
    width2: s32,
    out_stride: s32
) {
    i: s32 = ---;
    intbuf :=
        cast(*u8) c_transpiler_allocate_zeroed_memory(
            cast,no_check(u64) (width2 * height),
            size_of(u8)
        );
    tmpbuf :=
        cast(*u8) c_transpiler_allocate_zeroed_memory(
            cast,no_check(u64) ((ifx width < height then height else width)),
            size_of(u8)
        );
    arrbuf := cast(*u8) c_transpiler_allocate_zeroed_memory(cast,no_check(u64) height, size_of(u8));
    arrbuf2 := cast(*u8) c_transpiler_allocate_zeroed_memory(cast,no_check(u64) height2, size_of(u8));
    while error := true { // Forward-goto shim; executes at most once.
        if intbuf == null || tmpbuf == null || arrbuf == null || arrbuf2 == null {
            break error;
        }
        i = 0;
        while i < height {
            resize_multistep(INPUT + in_stride * i, width, intbuf + width2 * i, width2, tmpbuf);
            i += 1;
        }
        i = 0;
        while i < width2 {
            fill_col_to_arr(intbuf + i, width2, height, arrbuf);
            resize_multistep(arrbuf, height, arrbuf2, height2, tmpbuf);
            fill_arr_to_col(output + i, out_stride, height2, arrbuf2);
            i += 1;
        }
        break error;
    }
    c_transpiler_deallocate_memory(intbuf);
    c_transpiler_deallocate_memory(tmpbuf);
    c_transpiler_deallocate_memory(arrbuf);
    c_transpiler_deallocate_memory(arrbuf2);
}

fill_arr_to_col :: (img: *u8, stride: s32, len: s32, arr: *u8) {
    iptr := img;
    aptr := arr;
    i: s32 = 0;
    while i < len {
        iptr.* = (c_transpiler_post_increment(*(aptr))).*;
        i += 1;
        iptr += stride;
    }
}

resize_multistep :: (INPUT: *u8, length: s32, output: *u8, olength: s32, otmp: *u8) {
    if length == olength {
        copy_memory(output, INPUT, cast,no_check(u64) length);
        return;
    }
    steps := get_down2_steps(length, olength);

    if steps > 0 {
        out: *u8 = null;

        filteredlength := length;

        otmp2 := otmp + get_down2_length(length, 1);
        if 0 < steps {
            for s: 0..steps - 1 {
                PROJ_FILTEREDLENGTH := get_down2_length(filteredlength, 1);
                IN := (ifx s == 0 then INPUT else out);
                if s == steps - 1 && PROJ_FILTEREDLENGTH == olength {
                    out = output;
                } else {
                    out = ifx s & 1 != 0 then otmp2 else otmp;
                }
                if filteredlength & 1 != 0 {
                    down2_symodd(IN, filteredlength, out);
                } else {
                    down2_symeven(IN, filteredlength, out);
                }
                filteredlength = PROJ_FILTEREDLENGTH;
            }
        }
        if filteredlength != olength {
            interpolate(out, filteredlength, output, olength);
        }
    } else {
        interpolate(INPUT, length, output, olength);
    }
}

interpolate :: (INPUT: *u8, inlength: s32, output: *u8, outlength: s32) {
    DELTA :=
        cast,no_check(s64) (((cast,no_check(u64) inlength) << 32 + cast,no_check(u64) (outlength / 2)) /
            cast,no_check(u64) outlength);
    OFFSET :=
        (ifx inlength > outlength then ((cast,no_check(s64) (inlength - outlength)) << 31 + cast(s64) (outlength / 2)) /
            cast(s64) outlength else -((cast,no_check(s64) (outlength - inlength)) << 31 + cast(s64) (outlength / 2)) / cast(s64) outlength);
    optr := output;
    sum: s32 = ---;
    k: s32 = ---;
    int_pel: s32 = ---;
    sub_pel: s32 = ---;

    interp_filters := choose_interp_filter(inlength, outlength);

    x: s32 = 0;
    y := OFFSET;
    while y >> 32 < cast,no_check(s64) ((cast,no_check(s32) ((8 / 2))) - 1) {
        x += 1;
        y += DELTA;
    }
    x1 := x;
    x = outlength - 1;
    y = (DELTA * cast(s64) x) + OFFSET;
    while (y >> 32 + cast,no_check(s64) (8 / 2)) >= cast,no_check(s64) inlength {
        x -= 1;
        y -= DELTA;
    }
    x2 := x;
    if x1 > x2 {
        x = 0;
        y = OFFSET;
        while x < outlength {
            int_pel = cast,no_check(s32) (y >> 32);
            sub_pel = cast,no_check(s32) (y >> (((32 - 5)) & 63) & cast,no_check(s64) ((cast(s32) 1) << 5 - 1));
            filter := interp_filters[sub_pel].data;
            sum = 0;
            k = 0;
            while k < 8 {
                PK := ((int_pel - cast,no_check(s32) ((8 / 2))) + 1) + k;
                sum +=
                    (cast(s32) filter[k]) *
                        cast(s32) (INPUT[(ifx PK < 0 then 0 else (ifx PK >= inlength then inlength - 1 else PK))]);
                k += 1;
            }
            assignment_0: u8 = clip_pixel_in_vp9_resize((sum + (cast(s32) 1) << (((7 - 1)) & 31)) >> 7);
            ((c_transpiler_post_increment(*(optr))).*) = assignment_0;
            x += 1;
            y += DELTA;
        }
    } else {
        x = 0;
        y = OFFSET;
        while x < x1 {
            int_pel = cast,no_check(s32) (y >> 32);
            sub_pel = cast,no_check(s32) (y >> (((32 - 5)) & 63) & cast,no_check(s64) ((cast(s32) 1) << 5 - 1));
            filter := interp_filters[sub_pel].data;
            sum = 0;
            k = 0;
            while k < 8 {
                sum +=
                    (cast(s32) filter[k]) *
                        cast(s32) (INPUT[(ifx (((int_pel - cast,no_check(s32) ((8 / 2))) + 1) + k) < 0 then 0 else ((int_pel - cast,no_check(s32) ((8 / 2))) + 1) + k)]);
                k += 1;
            }
            assignment_1: u8 = clip_pixel_in_vp9_resize((sum + (cast(s32) 1) << (((7 - 1)) & 31)) >> 7);
            ((c_transpiler_post_increment(*(optr))).*) = assignment_1;
            x += 1;
            y += DELTA;
        }

        while x <= x2 {
            int_pel = cast,no_check(s32) (y >> 32);
            sub_pel = cast,no_check(s32) (y >> (((32 - 5)) & 63) & cast,no_check(s64) ((cast(s32) 1) << 5 - 1));
            filter := interp_filters[sub_pel].data;
            sum = 0;
            k = 0;
            while k < 8 {
                sum += (cast(s32) filter[k]) * cast(s32) INPUT[((int_pel - cast,no_check(s32) ((8 / 2))) + 1) + k];
                k += 1;
            }
            assignment_2: u8 = clip_pixel_in_vp9_resize((sum + (cast(s32) 1) << (((7 - 1)) & 31)) >> 7);
            ((c_transpiler_post_increment(*(optr))).*) = assignment_2;
            x += 1;
            y += DELTA;
        }

        while x < outlength {
            int_pel = cast,no_check(s32) (y >> 32);
            sub_pel = cast,no_check(s32) (y >> (((32 - 5)) & 63) & cast,no_check(s64) ((cast(s32) 1) << 5 - 1));
            filter := interp_filters[sub_pel].data;
            sum = 0;
            k = 0;
            while k < 8 {
                sum +=
                    (cast(s32) filter[k]) *
                        cast(s32) (INPUT[(ifx (((int_pel - cast,no_check(s32) ((8 / 2))) + 1) + k) >= inlength then inlength - 1 else ((int_pel - cast,no_check(s32) ((8 / 2))) + 1) + k)]);
                k += 1;
            }
            assignment_3: u8 = clip_pixel_in_vp9_resize((sum + (cast(s32) 1) << (((7 - 1)) & 31)) >> 7);
            ((c_transpiler_post_increment(*(optr))).*) = assignment_3;
            x += 1;
            y += DELTA;
        }
    }
}

choose_interp_filter :: (inlength: s32, outlength: s32) -> *Interp_Kernel_in_vp9_resize {
    outlength16 := outlength * 16;
    if outlength16 >= inlength * 16 {
        return FILTEREDINTERP_FILTERS1000.data;
    } else if outlength16 >= inlength * 13 {
        return FILTEREDINTERP_FILTERS875.data;
    } else if outlength16 >= inlength * 11 {
        return FILTEREDINTERP_FILTERS750.data;
    } else if outlength16 >= inlength * 9 {
        return FILTEREDINTERP_FILTERS625.data;
    } else {
        return FILTEREDINTERP_FILTERS500.data;
    }
}

get_down2_length :: (length: s32, steps: s32) -> s32 {
    if 0 < steps {
        for s: 0..steps - 1 {
            length = (length + 1) >> 1;
        }
    }
    return length;
}

down2_symeven :: (INPUT: *u8, length: s32, output: *u8) {
    filter := VP9_DOWN2_SYMEVEN_HALF_FILTER.data;
    FILTER_LEN_HALF: s32 =
        cast,no_check(s32) ((cast,no_check(u64) (VP9_DOWN2_SYMEVEN_HALF_FILTER.count * size_of(s16))) /
            2);
    i, j: s32 = ---;
    optr := output;
    l1 := FILTER_LEN_HALF;
    l2 := length - FILTER_LEN_HALF;
    l1 += l1 & 1;
    l2 += l2 & 1;
    if l1 > l2 {
        i = 0;
        while i < length {
            sum: s32 = (cast(s32) 1) << (((7 - 1)) & 31);
            j = 0;
            while j < FILTER_LEN_HALF {
                sum +=
                    ((cast(s32) (INPUT[(ifx i - j < 0 then 0 else i - j)])) + cast(s32) (INPUT[(ifx i + 1 + j >= length then length - 1 else i + 1 + j)])) *
                        cast(s32) filter[j];
                j += 1;
            }
            c_transpiler_compound_shr(*(sum), (cast(s32) 7), s32, s32);
            assignment_4: u8 = clip_pixel_in_vp9_resize(sum);
            ((c_transpiler_post_increment(*(optr))).*) = assignment_4;
            i += 2;
        }
    } else {
        i = 0;
        while i < l1 {
            sum: s32 = (cast(s32) 1) << (((7 - 1)) & 31);
            j = 0;
            while j < FILTER_LEN_HALF {
                sum +=
                    ((cast(s32) (INPUT[(ifx i - j < 0 then 0 else i - j)])) + cast(s32) INPUT[i + 1 + j]) *
                        cast(s32) filter[j];
                j += 1;
            }
            c_transpiler_compound_shr(*(sum), (cast(s32) 7), s32, s32);
            assignment_5: u8 = clip_pixel_in_vp9_resize(sum);
            ((c_transpiler_post_increment(*(optr))).*) = assignment_5;
            i += 2;
        }

        while i < l2 {
            sum: s32 = (cast(s32) 1) << (((7 - 1)) & 31);
            j = 0;
            while j < FILTER_LEN_HALF {
                sum += ((cast(s32) INPUT[i - j]) + cast(s32) INPUT[i + 1 + j]) * cast(s32) filter[j];
                j += 1;
            }
            c_transpiler_compound_shr(*(sum), (cast(s32) 7), s32, s32);
            assignment_6: u8 = clip_pixel_in_vp9_resize(sum);
            ((c_transpiler_post_increment(*(optr))).*) = assignment_6;
            i += 2;
        }

        while i < length {
            sum: s32 = (cast(s32) 1) << (((7 - 1)) & 31);
            j = 0;
            while j < FILTER_LEN_HALF {
                sum +=
                    ((cast(s32) INPUT[i - j]) + cast(s32) (INPUT[(ifx i + 1 + j >= length then length - 1 else i + 1 + j)])) *
                        cast(s32) filter[j];
                j += 1;
            }
            c_transpiler_compound_shr(*(sum), (cast(s32) 7), s32, s32);
            assignment_7: u8 = clip_pixel_in_vp9_resize(sum);
            ((c_transpiler_post_increment(*(optr))).*) = assignment_7;
            i += 2;
        }
    }
}

down2_symodd :: (INPUT: *u8, length: s32, output: *u8) {
    filter := VP9_DOWN2_SYMODD_HALF_FILTER.data;
    FILTER_LEN_HALF: s32 =
        cast,no_check(s32) ((cast,no_check(u64) (VP9_DOWN2_SYMODD_HALF_FILTER.count * size_of(s16))) /
            2);
    i, j: s32 = ---;
    optr := output;
    l1 := FILTER_LEN_HALF - 1;
    l2 := length - FILTER_LEN_HALF + 1;
    l1 += l1 & 1;
    l2 += l2 & 1;
    if l1 > l2 {
        i = 0;
        while i < length {
            sum := (cast(s32) 1) << (((7 - 1)) & 31) + (cast(s32) INPUT[i]) * cast(s32) filter[0];
            j = 1;
            while j < FILTER_LEN_HALF {
                sum +=
                    ((cast(s32) (INPUT[(ifx i - j < 0 then 0 else i - j)])) + cast(s32) (INPUT[(ifx i + j >= length then length - 1 else i + j)])) *
                        cast(s32) filter[j];
                j += 1;
            }
            c_transpiler_compound_shr(*(sum), (cast(s32) 7), s32, s32);
            assignment_8: u8 = clip_pixel_in_vp9_resize(sum);
            ((c_transpiler_post_increment(*(optr))).*) = assignment_8;
            i += 2;
        }
    } else {
        i = 0;
        while i < l1 {
            sum := (cast(s32) 1) << (((7 - 1)) & 31) + (cast(s32) INPUT[i]) * cast(s32) filter[0];
            j = 1;
            while j < FILTER_LEN_HALF {
                sum +=
                    ((cast(s32) (INPUT[(ifx i - j < 0 then 0 else i - j)])) + cast(s32) INPUT[i + j]) *
                        cast(s32) filter[j];
                j += 1;
            }
            c_transpiler_compound_shr(*(sum), (cast(s32) 7), s32, s32);
            assignment_9: u8 = clip_pixel_in_vp9_resize(sum);
            ((c_transpiler_post_increment(*(optr))).*) = assignment_9;
            i += 2;
        }

        while i < l2 {
            sum := (cast(s32) 1) << (((7 - 1)) & 31) + (cast(s32) INPUT[i]) * cast(s32) filter[0];
            j = 1;
            while j < FILTER_LEN_HALF {
                sum += ((cast(s32) INPUT[i - j]) + cast(s32) INPUT[i + j]) * cast(s32) filter[j];
                j += 1;
            }
            c_transpiler_compound_shr(*(sum), (cast(s32) 7), s32, s32);
            assignment_10: u8 = clip_pixel_in_vp9_resize(sum);
            ((c_transpiler_post_increment(*(optr))).*) = assignment_10;
            i += 2;
        }

        while i < length {
            sum := (cast(s32) 1) << (((7 - 1)) & 31) + (cast(s32) INPUT[i]) * cast(s32) filter[0];
            j = 1;
            while j < FILTER_LEN_HALF {
                sum +=
                    ((cast(s32) INPUT[i - j]) + cast(s32) (INPUT[(ifx i + j >= length then length - 1 else i + j)])) *
                        cast(s32) filter[j];
                j += 1;
            }
            c_transpiler_compound_shr(*(sum), (cast(s32) 7), s32, s32);
            assignment_11: u8 = clip_pixel_in_vp9_resize(sum);
            ((c_transpiler_post_increment(*(optr))).*) = assignment_11;
            i += 2;
        }
    }
}

get_down2_steps :: (in_length: s32, out_length: s32) -> s32 {
    steps: s32 = 0;
    proj_in_length: s32 = ---;
    while (ifx true { assignment_12: s32 = cast,no_check(s32) (get_down2_length(in_length, 1)); (proj_in_length) = assignment_12; assignment_12; }) >= out_length {
        steps += 1;
        in_length = proj_in_length;
        if in_length == 1 {
            break;
        }
    }
    return steps;
}

fill_col_to_arr :: (img: *u8, stride: s32, len: s32, arr: *u8) {
    iptr := img;
    aptr := arr;
    i: s32 = 0;
    while i < len {
        aptr.* = iptr.*;
        aptr += 1;
        i += 1;
        iptr += stride;
    }
}

globals_initialization_state_for_vp9_resize: u32;
initialize_globals_for_vp9_resize :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_resize);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_resize, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_resize) != 2 {}
            return;
        }
    }
    FILTEREDINTERP_FILTERS500 =
        Interp_Kernel_in_vp9_resize.[
            s16.[ -3, 0, 35, 64, 35, 0, -3, 0 ],
            s16.[ -3, -1, 34, 64, 36, 1, -3, 0 ],
            s16.[ -3, -1, 32, 64, 38, 1, -3, 0 ],
            s16.[ -2, -2, 31, 63, 39, 2, -3, 0 ],
            s16.[ -2, -2, 29, 63, 41, 2, -3, 0 ],
            s16.[ -2, -2, 28, 63, 42, 3, -4, 0 ],
            s16.[ -2, -3, 27, 63, 43, 4, -4, 0 ],
            s16.[ -2, -3, 25, 62, 45, 5, -4, 0 ],
            s16.[ -2, -3, 24, 62, 46, 5, -4, 0 ],
            s16.[ -2, -3, 23, 61, 47, 6, -4, 0 ],
            s16.[ -2, -3, 21, 60, 49, 7, -4, 0 ],
            s16.[ -1, -4, 20, 60, 50, 8, -4, -1 ],
            s16.[ -1, -4, 19, 59, 51, 9, -4, -1 ],
            s16.[ -1, -4, 17, 58, 52, 10, -4, 0 ],
            s16.[ -1, -4, 16, 57, 53, 12, -4, -1 ],
            s16.[ -1, -4, 15, 56, 54, 13, -4, -1 ],
            s16.[ -1, -4, 14, 55, 55, 14, -4, -1 ],
            s16.[ -1, -4, 13, 54, 56, 15, -4, -1 ],
            s16.[ -1, -4, 12, 53, 57, 16, -4, -1 ],
            s16.[ 0, -4, 10, 52, 58, 17, -4, -1 ],
            s16.[ -1, -4, 9, 51, 59, 19, -4, -1 ],
            s16.[ -1, -4, 8, 50, 60, 20, -4, -1 ],
            s16.[ 0, -4, 7, 49, 60, 21, -3, -2 ],
            s16.[ 0, -4, 6, 47, 61, 23, -3, -2 ],
            s16.[ 0, -4, 5, 46, 62, 24, -3, -2 ],
            s16.[ 0, -4, 5, 45, 62, 25, -3, -2 ],
            s16.[ 0, -4, 4, 43, 63, 27, -3, -2 ],
            s16.[ 0, -4, 3, 42, 63, 28, -2, -2 ],
            s16.[ 0, -3, 2, 41, 63, 29, -2, -2 ],
            s16.[ 0, -3, 2, 39, 63, 31, -2, -2 ],
            s16.[ 0, -3, 1, 38, 64, 32, -1, -3 ],
            s16.[ 0, -3, 1, 36, 64, 34, -1, -3 ]
        ];
    FILTEREDINTERP_FILTERS625 =
        Interp_Kernel_in_vp9_resize.[
            s16.[ -1, -8, 33, 80, 33, -8, -1, 0 ],
            s16.[ -1, -8, 30, 80, 35, -8, -1, 1 ],
            s16.[ -1, -8, 28, 80, 37, -7, -2, 1 ],
            s16.[ 0, -8, 26, 79, 39, -7, -2, 1 ],
            s16.[ 0, -8, 24, 79, 41, -7, -2, 1 ],
            s16.[ 0, -8, 22, 78, 43, -6, -2, 1 ],
            s16.[ 0, -8, 20, 78, 45, -5, -3, 1 ],
            s16.[ 0, -8, 18, 77, 48, -5, -3, 1 ],
            s16.[ 0, -8, 16, 76, 50, -4, -3, 1 ],
            s16.[ 0, -8, 15, 75, 52, -3, -4, 1 ],
            s16.[ 0, -7, 13, 74, 54, -3, -4, 1 ],
            s16.[ 0, -7, 11, 73, 56, -2, -4, 1 ],
            s16.[ 0, -7, 10, 71, 58, -1, -4, 1 ],
            s16.[ 1, -7, 8, 70, 60, 0, -5, 1 ],
            s16.[ 1, -6, 6, 68, 62, 1, -5, 1 ],
            s16.[ 1, -6, 5, 67, 63, 2, -5, 1 ],
            s16.[ 1, -6, 4, 65, 65, 4, -6, 1 ],
            s16.[ 1, -5, 2, 63, 67, 5, -6, 1 ],
            s16.[ 1, -5, 1, 62, 68, 6, -6, 1 ],
            s16.[ 1, -5, 0, 60, 70, 8, -7, 1 ],
            s16.[ 1, -4, -1, 58, 71, 10, -7, 0 ],
            s16.[ 1, -4, -2, 56, 73, 11, -7, 0 ],
            s16.[ 1, -4, -3, 54, 74, 13, -7, 0 ],
            s16.[ 1, -4, -3, 52, 75, 15, -8, 0 ],
            s16.[ 1, -3, -4, 50, 76, 16, -8, 0 ],
            s16.[ 1, -3, -5, 48, 77, 18, -8, 0 ],
            s16.[ 1, -3, -5, 45, 78, 20, -8, 0 ],
            s16.[ 1, -2, -6, 43, 78, 22, -8, 0 ],
            s16.[ 1, -2, -7, 41, 79, 24, -8, 0 ],
            s16.[ 1, -2, -7, 39, 79, 26, -8, 0 ],
            s16.[ 1, -2, -7, 37, 80, 28, -8, -1 ],
            s16.[ 1, -1, -8, 35, 80, 30, -8, -1 ]
        ];
    FILTEREDINTERP_FILTERS750 =
        Interp_Kernel_in_vp9_resize.[
            s16.[ 2, -11, 25, 96, 25, -11, 2, 0 ],
            s16.[ 2, -11, 22, 96, 28, -11, 2, 0 ],
            s16.[ 2, -10, 19, 95, 31, -11, 2, 0 ],
            s16.[ 2, -10, 17, 95, 34, -12, 2, 0 ],
            s16.[ 2, -9, 14, 94, 37, -12, 2, 0 ],
            s16.[ 2, -8, 12, 93, 40, -12, 1, 0 ],
            s16.[ 2, -8, 9, 92, 43, -12, 1, 1 ],
            s16.[ 2, -7, 7, 91, 46, -12, 1, 0 ],
            s16.[ 2, -7, 5, 90, 49, -12, 1, 0 ],
            s16.[ 2, -6, 3, 88, 52, -12, 0, 1 ],
            s16.[ 2, -5, 1, 86, 55, -12, 0, 1 ],
            s16.[ 2, -5, -1, 84, 58, -11, 0, 1 ],
            s16.[ 2, -4, -2, 82, 61, -11, -1, 1 ],
            s16.[ 2, -4, -4, 80, 64, -10, -1, 1 ],
            s16.[ 1, -3, -5, 77, 67, -9, -1, 1 ],
            s16.[ 1, -3, -6, 75, 70, -8, -2, 1 ],
            s16.[ 1, -2, -7, 72, 72, -7, -2, 1 ],
            s16.[ 1, -2, -8, 70, 75, -6, -3, 1 ],
            s16.[ 1, -1, -9, 67, 77, -5, -3, 1 ],
            s16.[ 1, -1, -10, 64, 80, -4, -4, 2 ],
            s16.[ 1, -1, -11, 61, 82, -2, -4, 2 ],
            s16.[ 1, 0, -11, 58, 84, -1, -5, 2 ],
            s16.[ 1, 0, -12, 55, 86, 1, -5, 2 ],
            s16.[ 1, 0, -12, 52, 88, 3, -6, 2 ],
            s16.[ 0, 1, -12, 49, 90, 5, -7, 2 ],
            s16.[ 0, 1, -12, 46, 91, 7, -7, 2 ],
            s16.[ 1, 1, -12, 43, 92, 9, -8, 2 ],
            s16.[ 0, 1, -12, 40, 93, 12, -8, 2 ],
            s16.[ 0, 2, -12, 37, 94, 14, -9, 2 ],
            s16.[ 0, 2, -12, 34, 95, 17, -10, 2 ],
            s16.[ 0, 2, -11, 31, 95, 19, -10, 2 ],
            s16.[ 0, 2, -11, 28, 96, 22, -11, 2 ]
        ];
    FILTEREDINTERP_FILTERS875 =
        Interp_Kernel_in_vp9_resize.[
            s16.[ 3, -8, 13, 112, 13, -8, 3, 0 ],
            s16.[ 3, -7, 10, 112, 17, -9, 3, -1 ],
            s16.[ 2, -6, 7, 111, 21, -9, 3, -1 ],
            s16.[ 2, -5, 4, 111, 24, -10, 3, -1 ],
            s16.[ 2, -4, 1, 110, 28, -11, 3, -1 ],
            s16.[ 1, -3, -1, 108, 32, -12, 4, -1 ],
            s16.[ 1, -2, -3, 106, 36, -13, 4, -1 ],
            s16.[ 1, -1, -6, 105, 40, -14, 4, -1 ],
            s16.[ 1, -1, -7, 102, 44, -14, 4, -1 ],
            s16.[ 1, 0, -9, 100, 48, -15, 4, -1 ],
            s16.[ 1, 1, -11, 97, 53, -16, 4, -1 ],
            s16.[ 0, 1, -12, 95, 57, -16, 4, -1 ],
            s16.[ 0, 2, -13, 91, 61, -16, 4, -1 ],
            s16.[ 0, 2, -14, 88, 65, -16, 4, -1 ],
            s16.[ 0, 3, -15, 84, 69, -17, 4, 0 ],
            s16.[ 0, 3, -16, 81, 73, -16, 3, 0 ],
            s16.[ 0, 3, -16, 77, 77, -16, 3, 0 ],
            s16.[ 0, 3, -16, 73, 81, -16, 3, 0 ],
            s16.[ 0, 4, -17, 69, 84, -15, 3, 0 ],
            s16.[ -1, 4, -16, 65, 88, -14, 2, 0 ],
            s16.[ -1, 4, -16, 61, 91, -13, 2, 0 ],
            s16.[ -1, 4, -16, 57, 95, -12, 1, 0 ],
            s16.[ -1, 4, -16, 53, 97, -11, 1, 1 ],
            s16.[ -1, 4, -15, 48, 100, -9, 0, 1 ],
            s16.[ -1, 4, -14, 44, 102, -7, -1, 1 ],
            s16.[ -1, 4, -14, 40, 105, -6, -1, 1 ],
            s16.[ -1, 4, -13, 36, 106, -3, -2, 1 ],
            s16.[ -1, 4, -12, 32, 108, -1, -3, 1 ],
            s16.[ -1, 3, -11, 28, 110, 1, -4, 2 ],
            s16.[ -1, 3, -10, 24, 111, 4, -5, 2 ],
            s16.[ -1, 3, -9, 21, 111, 7, -6, 2 ],
            s16.[ -1, 3, -9, 17, 112, 10, -7, 3 ]
        ];
    FILTEREDINTERP_FILTERS1000 =
        Interp_Kernel_in_vp9_resize.[
            s16.[ 0, 0, 0, 128, 0, 0, 0, 0 ],
            s16.[ 0, 1, -3, 128, 3, -1, 0, 0 ],
            s16.[ -1, 2, -6, 127, 7, -2, 1, 0 ],
            s16.[ -1, 3, -9, 126, 12, -4, 1, 0 ],
            s16.[ -1, 4, -12, 125, 16, -5, 1, 0 ],
            s16.[ -1, 4, -14, 123, 20, -6, 2, 0 ],
            s16.[ -1, 5, -15, 120, 25, -8, 2, 0 ],
            s16.[ -1, 5, -17, 118, 30, -9, 3, -1 ],
            s16.[ -1, 6, -18, 114, 35, -10, 3, -1 ],
            s16.[ -1, 6, -19, 111, 41, -12, 3, -1 ],
            s16.[ -1, 6, -20, 107, 46, -13, 4, -1 ],
            s16.[ -1, 6, -21, 103, 52, -14, 4, -1 ],
            s16.[ -1, 6, -21, 99, 57, -16, 5, -1 ],
            s16.[ -1, 6, -21, 94, 63, -17, 5, -1 ],
            s16.[ -1, 6, -20, 89, 68, -18, 5, -1 ],
            s16.[ -1, 6, -20, 84, 73, -19, 6, -1 ],
            s16.[ -1, 6, -20, 79, 79, -20, 6, -1 ],
            s16.[ -1, 6, -19, 73, 84, -20, 6, -1 ],
            s16.[ -1, 5, -18, 68, 89, -20, 6, -1 ],
            s16.[ -1, 5, -17, 63, 94, -21, 6, -1 ],
            s16.[ -1, 5, -16, 57, 99, -21, 6, -1 ],
            s16.[ -1, 4, -14, 52, 103, -21, 6, -1 ],
            s16.[ -1, 4, -13, 46, 107, -20, 6, -1 ],
            s16.[ -1, 3, -12, 41, 111, -19, 6, -1 ],
            s16.[ -1, 3, -10, 35, 114, -18, 6, -1 ],
            s16.[ -1, 3, -9, 30, 118, -17, 5, -1 ],
            s16.[ 0, 2, -8, 25, 120, -15, 5, -1 ],
            s16.[ 0, 2, -6, 20, 123, -14, 4, -1 ],
            s16.[ 0, 1, -5, 16, 125, -12, 4, -1 ],
            s16.[ 0, 1, -4, 12, 126, -9, 3, -1 ],
            s16.[ 0, 1, -2, 7, 127, -6, 2, -1 ],
            s16.[ 0, 0, -1, 3, 128, -3, 1, 0 ]
        ];
    VP9_DOWN2_SYMEVEN_HALF_FILTER = s16.[ 56, 12, -3, -1 ];
    VP9_DOWN2_SYMODD_HALF_FILTER = s16.[ 64, 35, 0, -3 ];
    atomic_store(*globals_initialization_state_for_vp9_resize, 2);
}

