img_alloc :: (img: *Image_T, fmt: Img_Fmt_T, d_w: u32, d_h: u32, align: u32) -> *Image_T {
    return img_alloc_helper(img, fmt, d_w, d_h, align, align, null);
}

img_alloc_helper :: (
    img: *Image_T,
    fmt: Img_Fmt_T,
    d_w: u32,
    d_h: u32,
    buf_align: u32,
    stride_align: u32,
    img_data: *u8
) -> *Image_T {
    h: u32 = ---;
    w: u32 = ---;
    xcs: u32 = ---;
    ycs: u32 = ---;
    bps: u32 = ---;
    s: u64 = ---;
    stride_in_bytes: s32 = ---;
    align: u32 = ---;
    uv_s: u64 = ---;
    UV_STRIDE_IN_BYTES: s32 = ---;
    alloc_size: u64 = ---;
    ret: s32 = ---;
    code_block_to_execute: s64 = 123;
    // The transpiler had to use this control-flow loop because the source code used a goto, which Jai does not support.
    while c_transpiler_dispatch := true {
        if code_block_to_execute < 0 break;
        if code_block_to_execute == {
            case 27; {
                img_free(img);
                return null;
            }
            case 33; {
                if fmt == cast,no_check(u32) IMG_FMT_NV12 {
                    img.stride[2] = stride_in_bytes;
                    img.stride[1] = img.stride[2];
                    ret = img_set_rect(img, 0, 0, d_w, d_h);
                    return img;
                } else {
                    ret = img_set_rect(img, 0, 0, d_w, d_h);
                    return img;
                }
            }
            case 46; {
                if img.img_data == null {
                    code_block_to_execute = 27;
                    continue c_transpiler_dispatch;
                } else {
                    img.fmt = fmt;
                    img.bit_depth = ifx fmt & 0x800 != 0 then cast(u32) 16 else 8;
                    img.w = w;
                    img.h = h;
                    img.x_chroma_shift = xcs;
                    img.y_chroma_shift = ycs;
                    img.bps = cast,no_check(s32) bps;
                    img.stride[3] = stride_in_bytes;
                    img.stride[0] = img.stride[3];
                    img.stride[2] = UV_STRIDE_IN_BYTES;
                    img.stride[1] = img.stride[2];
                    if fmt == cast,no_check(u32) IMG_FMT_NV12 {
                        img.stride[2] = stride_in_bytes;
                        img.stride[1] = img.stride[2];
                        code_block_to_execute = 33;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 33;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 55; {
                img.img_data = img_data;
                if img_data == null {
                    s = ifx fmt & 0x800 != 0 then s / 2 else s;
                    alloc_size =
                        ifx fmt & 0x100 != 0 then ((cast,no_check(u64) h) * s * cast(u64) bps) /
                            8 else (cast,no_check(u64) h) * s;
                    if alloc_size != alloc_size {
                        code_block_to_execute = 27;
                        continue c_transpiler_dispatch;
                    } else {
                        img.img_data = cast(*u8) memalign(cast,no_check(u64) buf_align, alloc_size);
                        img.img_data_owner = 1;
                        code_block_to_execute = 46;
                        continue c_transpiler_dispatch;
                    }
                } else {
                    code_block_to_execute = 46;
                    continue c_transpiler_dispatch;
                }
            }
            case 71; {
                s = ifx fmt & 0x100 != 0 then cast,no_check(u64) w else ((cast,no_check(u64) bps) * cast(u64) w) / 8;
                s = ifx fmt & 0x800 != 0 then s * 2 else s;
                s = ((s + cast(u64) stride_align) - 1) & ~((cast,no_check(u64) stride_align) - 1);
                if s > 2147483647 {
                    code_block_to_execute = 27;
                    continue c_transpiler_dispatch;
                } else {
                    stride_in_bytes = cast,no_check(s32) s;
                    uv_s = s;
                    uv_s = ifx fmt & 0x800 != 0 then uv_s / 2 else uv_s;
                    uv_s = (uv_s + cast(u64) xcs) >> ((xcs) & 63);
                    uv_s = ifx fmt & 0x800 != 0 then uv_s * 2 else uv_s;
                    UV_STRIDE_IN_BYTES = cast,no_check(s32) uv_s;
                    if img == null {
                        img = cast(*Image_T) c_transpiler_allocate_zeroed_memory(1, size_of(Image_T));
                        if img == null {
                            code_block_to_execute = 27;
                            continue c_transpiler_dispatch;
                        } else {
                            img.self_allocd = 1;
                            code_block_to_execute = 55;
                            continue c_transpiler_dispatch;
                        }
                    } else {
                        code_block_to_execute = 55;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 80; {
                if img_data != null {
                    w = d_w;
                    h = d_h;
                    code_block_to_execute = 71;
                    continue c_transpiler_dispatch;
                } else {
                    align = cast,no_check(u32) ((cast(s32) 1) << ((xcs) & 31) - 1);
                    w = (d_w + align) & ~(align);
                    align = cast,no_check(u32) ((cast(s32) 1) << ((ycs) & 31) - 1);
                    h = (d_h + align) & ~(align);
                    code_block_to_execute = 71;
                    continue c_transpiler_dispatch;
                }
            }
            case 82; {
                ycs = 0;
                code_block_to_execute = 80;
                continue c_transpiler_dispatch;
            }
            case 84; {
                ycs = 1;
                code_block_to_execute = 80;
                continue c_transpiler_dispatch;
            }
            case 85; {
                c_transpiler_switch_value_85 := fmt;
                if c_transpiler_switch_value_85 == {
                    case cast,no_check(u32) IMG_FMT_I420; {
                        code_block_to_execute = 84;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) IMG_FMT_NV12; {
                        code_block_to_execute = 84;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) IMG_FMT_I440; {
                        code_block_to_execute = 84;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) IMG_FMT_YV12; {
                        code_block_to_execute = 84;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) IMG_FMT_I42016; {
                        code_block_to_execute = 84;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) IMG_FMT_I44016; {
                        code_block_to_execute = 84;
                        continue c_transpiler_dispatch;
                    }
                    case; {
                        code_block_to_execute = 82;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 87; {
                xcs = 0;
                code_block_to_execute = 85;
                continue c_transpiler_dispatch;
            }
            case 89; {
                xcs = 1;
                code_block_to_execute = 85;
                continue c_transpiler_dispatch;
            }
            case 90; {
                c_transpiler_switch_value_90 := fmt;
                if c_transpiler_switch_value_90 == {
                    case cast,no_check(u32) IMG_FMT_I420; {
                        code_block_to_execute = 89;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) IMG_FMT_YV12; {
                        code_block_to_execute = 89;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) IMG_FMT_NV12; {
                        code_block_to_execute = 89;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) IMG_FMT_I422; {
                        code_block_to_execute = 89;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) IMG_FMT_I42016; {
                        code_block_to_execute = 89;
                        continue c_transpiler_dispatch;
                    }
                    case cast,no_check(u32) IMG_FMT_I42216; {
                        code_block_to_execute = 89;
                        continue c_transpiler_dispatch;
                    }
                    case; {
                        code_block_to_execute = 87;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 92; {
                bps = 16;
                code_block_to_execute = 90;
                continue c_transpiler_dispatch;
            }
            case 96; {
                bps = 32;
                code_block_to_execute = 90;
                continue c_transpiler_dispatch;
            }
            case 102; {
                bps = 16;
                code_block_to_execute = 90;
                continue c_transpiler_dispatch;
            }
            case 104; {
                bps = 12;
                code_block_to_execute = 90;
                continue c_transpiler_dispatch;
            }
            case 107; {
                if stride_align & (stride_align - 1) != 0 {
                    code_block_to_execute = 27;
                    continue c_transpiler_dispatch;
                } else {
                    c_transpiler_switch_value_105 := fmt;
                    if c_transpiler_switch_value_105 == {
                        case cast,no_check(u32) IMG_FMT_I420; {
                            code_block_to_execute = 104;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) IMG_FMT_YV12; {
                            code_block_to_execute = 104;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) IMG_FMT_NV12; {
                            code_block_to_execute = 104;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) IMG_FMT_I422; {
                            code_block_to_execute = 102;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) IMG_FMT_I440; {
                            code_block_to_execute = 102;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) IMG_FMT_I444; {
                            bps = 24;
                            code_block_to_execute = 90;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) IMG_FMT_I42016; {
                            bps = 24;
                            code_block_to_execute = 90;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) IMG_FMT_I42216; {
                            code_block_to_execute = 96;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) IMG_FMT_I44016; {
                            code_block_to_execute = 96;
                            continue c_transpiler_dispatch;
                        }
                        case cast,no_check(u32) IMG_FMT_I44416; {
                            bps = 48;
                            code_block_to_execute = 90;
                            continue c_transpiler_dispatch;
                        }
                        case; {
                            code_block_to_execute = 92;
                            continue c_transpiler_dispatch;
                        }
                    }
                }
            }
            case 111; {
                if buf_align & (buf_align - 1) != 0 {
                    code_block_to_execute = 27;
                    continue c_transpiler_dispatch;
                } else {
                    if stride_align == 0 {
                        stride_align = 1;
                        code_block_to_execute = 107;
                        continue c_transpiler_dispatch;
                    } else {
                        code_block_to_execute = 107;
                        continue c_transpiler_dispatch;
                    }
                }
            }
            case 117; {
                if is_valid_img_fmt(fmt) == 0 {
                    code_block_to_execute = 27;
                    continue c_transpiler_dispatch;
                } else {
                    if d_w > 0x8000000 || d_h > 0x8000000 || buf_align > 65536 || stride_align > 65536 {
                        code_block_to_execute = 27;
                        continue c_transpiler_dispatch;
                    } else {
                        if buf_align == 0 {
                            buf_align = 1;
                            code_block_to_execute = 111;
                            continue c_transpiler_dispatch;
                        } else {
                            code_block_to_execute = 111;
                            continue c_transpiler_dispatch;
                        }
                    }
                }
            }
            case 123; {
                if img != null {
                    fill_memory(img, 0, size_of(Image_T));
                    code_block_to_execute = 117;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 117;
                    continue c_transpiler_dispatch;
                }
            }
        }
        assert(false, tprint("invalid code block to execute %", code_block_to_execute));
        break;
    }
    return unreachable_value(*Image_T);
}

img_free :: (img: *Image_T) {
    if img != null {
        if img.img_data != null && img.img_data_owner != 0 {
            deallocate_memory(cast(*void) img.img_data);
        }

        if img.self_allocd != 0 {
            c_transpiler_deallocate_memory(img);
        }
    }
}

img_set_rect :: (img: *Image_T, x: u32, y: u32, w: u32, h: u32) -> s32 {
    if img.stride[0] < 0 {
        return -1;
    }

    if x <= U32_MAX - w && x + w <= img.w && y <= U32_MAX - h && y + h <= img.h {
        img.d_w = w;
        img.d_h = h;

        if img.fmt & 0x100 == 0 {
            img.planes[0] =
                (img.img_data + (x * cast,no_check(u32) img.bps) / 8) +
                    y * cast,no_check(u32) img.stride[0];
        } else {
            BYTES_PER_SAMPLE := (ifx img.fmt & 0x800 != 0 then cast(s32) 2 else 1);
            data := img.img_data;

            if img.fmt & 0x400 != 0 {
                img.planes[3] = (data + x * cast,no_check(u32) BYTES_PER_SAMPLE) + y * cast,no_check(u32) img.stride[3];
                data += (cast,no_check(u64) img.h) * cast,no_check(u64) img.stride[3];
            }

            img.planes[0] = (data + x * cast,no_check(u32) BYTES_PER_SAMPLE) + y * cast,no_check(u32) img.stride[0];
            data += (cast,no_check(u64) img.h) * cast,no_check(u64) img.stride[0];

            uv_x := x >> ((img.x_chroma_shift) & 31);
            uv_y := y >> ((img.y_chroma_shift) & 31);
            UV_HEIGHT := (img.h + img.y_chroma_shift) >> ((img.y_chroma_shift) & 31);
            if img.fmt == cast,no_check(u32) IMG_FMT_NV12 {
                img.planes[1] =
                    (data + (uv_x * cast,no_check(u32) BYTES_PER_SAMPLE) * 2) +
                        uv_y * cast,no_check(u32) img.stride[1];
                img.planes[2] = img.planes[1] + BYTES_PER_SAMPLE;
            } else if img.fmt & 0x200 == 0 {
                img.planes[1] =
                    (data + uv_x * cast,no_check(u32) BYTES_PER_SAMPLE) +
                        uv_y * cast,no_check(u32) img.stride[1];
                data += (cast,no_check(u64) UV_HEIGHT) * cast,no_check(u64) img.stride[1];
                img.planes[2] =
                    (data + uv_x * cast,no_check(u32) BYTES_PER_SAMPLE) +
                        uv_y * cast,no_check(u32) img.stride[2];
            } else {
                img.planes[2] =
                    (data + uv_x * cast,no_check(u32) BYTES_PER_SAMPLE) +
                        uv_y * cast,no_check(u32) img.stride[2];
                data += (cast,no_check(u64) UV_HEIGHT) * cast,no_check(u64) img.stride[2];
                img.planes[1] =
                    (data + uv_x * cast,no_check(u32) BYTES_PER_SAMPLE) +
                        uv_y * cast,no_check(u32) img.stride[1];
            }
        }
        return 0;
    }
    return -1;
}

is_valid_img_fmt :: (fmt: Img_Fmt_T) -> s32 {
    if fmt == {
        case cast,no_check(u32) IMG_FMT_YV12; #through;
        case cast,no_check(u32) IMG_FMT_I420; #through;
        case cast,no_check(u32) IMG_FMT_I422; #through;
        case cast,no_check(u32) IMG_FMT_I444; #through;
        case cast,no_check(u32) IMG_FMT_I440; #through;
        case cast,no_check(u32) IMG_FMT_NV12; #through;
        case cast,no_check(u32) IMG_FMT_I42016; #through;
        case cast,no_check(u32) IMG_FMT_I42216; #through;
        case cast,no_check(u32) IMG_FMT_I44416; #through;
        case cast,no_check(u32) IMG_FMT_I44016;
            return 1;
        case;
            return 0;
    }
    return unreachable_value(s32);
}

img_wrap :: (img: *Image_T, fmt: Img_Fmt_T, d_w: u32, d_h: u32, stride_align: u32, img_data: *u8) -> *Image_T {
    return img_alloc_helper(img, fmt, d_w, d_h, 1, stride_align, img_data);
}

img_flip :: (img: *Image_T) {
    CHROMA_HEIGHT := (img.d_h + img.y_chroma_shift) >> ((img.y_chroma_shift) & 31);

    img.planes[0] += (cast,no_check(s64) (img.d_h - 1)) * cast(s64) img.stride[0];
    img.stride[0] = -img.stride[0];

    img.planes[1] += (cast,no_check(s64) (CHROMA_HEIGHT - 1)) * cast(s64) img.stride[1];
    img.stride[1] = -img.stride[1];

    img.planes[2] += (cast,no_check(s64) (CHROMA_HEIGHT - 1)) * cast(s64) img.stride[2];
    img.stride[2] = -img.stride[2];

    if img.fmt & 0x400 != 0 {
        img.planes[3] += (cast,no_check(s64) (img.d_h - 1)) * cast(s64) img.stride[3];
        img.stride[3] = -img.stride[3];
    }
}

