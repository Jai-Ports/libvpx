// Generated directly from C by cpp_transpiler.
Lookahead_Ctx_in_lookahead :: struct {
    max_sz: u32;
    sz: u32;
    read_idx: u32;
    write_idx: u32;
    buf: *Lookahead_Entry;
}

vp8_lookahead_init :: (width: u32, height: u32, depth: u32) -> *Lookahead_Ctx_in_lookahead {
    ctx: *Lookahead_Ctx_in_lookahead = null;
    i: u32 = ---;
    if depth < 1 {
        depth = 1;
    } else if depth > cast,no_check(u32) (25) {
        depth = ifx ((cast(s32) 0) != 0) then cast(u32) 1 else 25;
    }
    depth += 1;
    width = (width + 15) & ~(cast(u32) 15);
    height = (height + 15) & ~(cast(u32) 15);
    ctx =
        cast(*Lookahead_Ctx_in_lookahead) c_transpiler_allocate_zeroed_memory(
            1,
            size_of(Lookahead_Ctx_in_lookahead)
        );
    while bail := true { // Forward-goto shim; executes at most once.
        if ctx != null {
            ctx.max_sz = depth;
            ctx.buf =
                cast(*Lookahead_Entry) c_transpiler_allocate_zeroed_memory(
                    cast,no_check(u64) depth,
                    size_of(Lookahead_Entry)
                );
            if ctx.buf == null {
                break bail;
            }
            i = 0;
            while i < depth {
                if vp8_yv12_alloc_frame_buffer(*ctx.buf[i].img, cast,no_check(s32) width, cast,no_check(s32) height, 32) != 0 {
                    break bail;
                }
                i += 1;
            }
        }
        return ctx;
    }
    vp8_lookahead_destroy(ctx);
    return null;
}

vp8_lookahead_destroy :: (ctx: *Lookahead_Ctx_in_lookahead) {
    if ctx != null {
        if ctx.buf != null {
            i: u32 = 0;
            while i < ctx.max_sz {
                vp8_yv12_de_alloc_frame_buffer(*ctx.buf[i].img);
                i += 1;
            }
            c_transpiler_deallocate_memory(ctx.buf);
        }
        c_transpiler_deallocate_memory(ctx);
    }
}

vp8_lookahead_push :: (
    ctx: *Lookahead_Ctx_in_lookahead,
    src: *YV12_BUFFER_CONFIG,
    ts_start: s64,
    ts_end: s64,
    flags: u32,
    active_map: *u8
) -> s32 {
    col: s32 = ---;
    active_end: s32 = ---;
    mb_rows := (src.y_height + 15) >> 4;
    mb_cols := (src.y_width + 15) >> 4;

    if (ctx.sz + 2) > ctx.max_sz {
        return 1;
    }
    ctx.sz += 1;
    buf := pop(ctx, *ctx.write_idx);

    if ctx.max_sz == 1 && active_map != null && flags == 0 {
        if 0 < mb_rows {
            for row: 0..mb_rows - 1 {
                col = 0;

                while ((cast(s32) 1) != 0) {
                    while col < mb_cols {
                        if active_map[col] != 0 {
                            break;
                        }
                        col += 1;
                    }

                    if col == mb_cols {
                        break;
                    }

                    active_end = col;

                    while active_end < mb_cols {
                        if active_map[active_end] == 0 {
                            break;
                        }
                        active_end += 1;
                    }

                    vp8_copy_and_extend_frame_with_rect(src, *buf.img, row << 4, col << 4, 16, (active_end - col) << 4);

                    col = active_end;
                }

                active_map += mb_cols;
            }
        }
    } else {
        vp8_copy_and_extend_frame(src, *buf.img);
    }
    buf.ts_start = ts_start;
    buf.ts_end = ts_end;
    buf.flags = flags;
    return 0;
}

pop :: (ctx: *Lookahead_Ctx_in_lookahead, idx: *u32) -> *Lookahead_Entry {
    index := idx.*;
    buf := ctx.buf + index;

    if c_transpiler_pre_increment(*(index)) >= ctx.max_sz {
        index -= ctx.max_sz;
    }
    idx.* = index;
    return buf;
}

vp8_lookahead_pop :: (ctx: *Lookahead_Ctx_in_lookahead, drain: s32) -> *Lookahead_Entry {
    buf: *Lookahead_Entry = null;

    if ctx.sz != 0 && (drain != 0 || ctx.sz == ctx.max_sz - 1) {
        buf = pop(ctx, *ctx.read_idx);
        ctx.sz -= 1;
    }
    return buf;
}

vp8_lookahead_peek :: (ctx: *Lookahead_Ctx_in_lookahead, index: u32, direction: s32) -> *Lookahead_Entry {
    buf: *Lookahead_Entry = null;

    if direction == 1 {
        if index < ctx.sz {
            index += ctx.read_idx;
            if index >= ctx.max_sz {
                index -= ctx.max_sz;
            }
            buf = ctx.buf + index;
        }
    } else if direction == -1 {
        if ctx.read_idx == 0 {
            index = ctx.max_sz - 1;
        } else {
            index = ctx.read_idx - index;
        }
        buf = ctx.buf + index;
    }

    return buf;
}

vp8_lookahead_depth :: (ctx: *Lookahead_Ctx_in_lookahead) -> u32 {
    return ctx.sz;
}

