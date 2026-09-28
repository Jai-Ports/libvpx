// Generated directly from C by cpp_transpiler.
codec_version :: () -> s32 {
    return (cast(s32) 1) << 16 | ((cast(s32) 17) << 8) | 0;
}

codec_version_str :: () -> *s8 {
    return c_string("v1.17.0");
}

codec_version_extra_str :: () -> *s8 {
    return c_string("");
}

codec_iface_name :: (iface: *Codec_Iface_T) -> *s8 {
    return ifx iface != null then iface.name else c_string("<invalid interface>");
}

codec_err_to_string :: (err: Codec_Err_T) -> *s8 {
    if err == {
        case cast,no_check(u32) CODEC_OK;
            return c_string("Success");
        case cast,no_check(u32) CODEC_ERROR;
            return c_string("Unspecified internal error");
        case cast,no_check(u32) CODEC_MEM_ERROR;
            return c_string("Memory allocation error");
        case cast,no_check(u32) CODEC_ABI_MISMATCH;
            return c_string("ABI version mismatch");
        case cast,no_check(u32) CODEC_INCAPABLE;
            return c_string("Codec does not implement requested capability");
        case cast,no_check(u32) CODEC_UNSUP_BITSTREAM;
            return c_string("Bitstream not supported by this decoder");
        case cast,no_check(u32) CODEC_UNSUP_FEATURE;
            return c_string("Bitstream required feature not supported by this decoder");
        case cast,no_check(u32) CODEC_CORRUPT_FRAME;
            return c_string("Corrupt frame detected");
        case cast,no_check(u32) CODEC_INVALID_PARAM;
            return c_string("Invalid parameter");
        case cast,no_check(u32) CODEC_LIST_END;
            return c_string("End of iterated list");
    }

    return c_string("Unrecognized error code");
}

codec_error :: (ctx: *Codec_Ctx_T) -> *s8 {
    return ifx ctx != null then codec_err_to_string(ctx.err) else codec_err_to_string(cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM);
}

codec_error_detail :: (ctx: *Codec_Ctx_T) -> *s8 {
    if ctx != null && ((ctx.err) != 0) {
        return ifx ctx.priv != null then ctx.priv.err_detail else ctx.err_detail;
    }

    return null;
}

codec_destroy :: (ctx: *Codec_Ctx_T) -> Codec_Err_T {
    res: Codec_Err_T = ---;

    if ctx == null {
        res = cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    } else if ctx.iface == null || ctx.priv == null {
        res = cast,no_check(Codec_Err_T) CODEC_ERROR;
    } else {
        ctx.iface.destroy(cast(*Codec_Alg_Priv_T) ctx.priv);

        ctx.iface = null;
        ctx.name = null;
        ctx.priv = null;
        res = cast,no_check(Codec_Err_T) CODEC_OK;
    }

    return ifx ctx != null then (ifx true { assignment_0: Codec_Err_T = cast,no_check(Codec_Err_T) (res); (ctx.err) = assignment_0; assignment_0; }) else res;
}

codec_get_caps :: (iface: *Codec_Iface_T) -> Codec_Caps_T {
    return ifx iface != null then iface.caps else 0;
}

codec_control :: (ctx: *Codec_Ctx_T, ctrl_id: s32, variadic_arguments: ..Any) -> Codec_Err_T {
    res: Codec_Err_T = ---;

    if ctx == null || ctrl_id == 0 {
        res = cast,no_check(Codec_Err_T) CODEC_INVALID_PARAM;
    } else if ctx.iface == null || ctx.priv == null || ctx.iface.ctrl_maps == null {
        res = cast,no_check(Codec_Err_T) CODEC_ERROR;
    } else {
        res = cast,no_check(Codec_Err_T) CODEC_INCAPABLE;

        entry := ctx.iface.ctrl_maps;
        while entry.fn != null {
            if entry.ctrl_id == 0 || entry.ctrl_id == ctrl_id {
                ap: Va_List = ---;

                start_variadic_arguments(cast(*void) ap.data, variadic_arguments);
                res = entry.fn(cast(*Codec_Alg_Priv_T) ctx.priv, ap.data);
                break;
            }
            entry += 1;
        }
    }

    return ifx ctx != null then (ifx true { assignment_1: Codec_Err_T = cast,no_check(Codec_Err_T) (res); (ctx.err) = assignment_1; assignment_1; }) else res;
}

internal_error :: (info: *Internal_Error_Info, error: Codec_Err_T, fmt: *s8, variadic_arguments: ..Any) {
    ap: Va_List = ---;

    info.error_code = error;
    info.has_detail = 0;

    if fmt != null {
        sz: u64 = info.detail.count;

        info.has_detail = 1;
        start_variadic_arguments(cast(*void) ap.data, variadic_arguments);
        format_cstring_from_variadic_arguments(info.detail.data, sz - 1, fmt, ap.data);
        info.detail[sz - 1] = 0;
    }

    if info.setjmp != 0 {
        longjmp(info.jmp.data, cast,no_check(s32) info.error_code);
    }
}

System_Library_Compiler :: #import "Compiler";
#run System_Library_Compiler.compiler_add_library_search_directory("/usr/lib");
System_Library_libc_so_6 :: #library,system "libc.so.6";
longjmp :: (env: *Jmp_Buf_Tag, val: s32) #foreign System_Library_libc_so_6;

Va_List :: [1] Va_List_Tag;

Internal_Error_Info :: struct {
    error_code: Codec_Err_T;
    has_detail: s32;
    detail: [80] s8;
    setjmp: s32;
    jmp: Jmp_Buf_in_setjmp;
}

Jmp_Buf_Tag :: struct {
    jmpbuf: Jmp_Buf;
    mask_was_saved: s32;
    saved_mask: Sigset_T;
}

Jmp_Buf_in_setjmp :: [1] Jmp_Buf_Tag;

Jmp_Buf :: [8] s64;

Sigset_T :: struct {
    val: [16] u64;
}

