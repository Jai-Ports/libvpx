// Generated directly from C by cpp_transpiler.
vp8_copy_mem16x16_c :: (src: *u8, src_stride: s32, dst: *u8, dst_stride: s32) {
    for r: 0..cast(s32) 16 - 1 {
        copy_memory(dst, src, 16);

        src += src_stride;
        dst += dst_stride;
    }
}

vp8_copy_mem8x4_c :: (src: *u8, src_stride: s32, dst: *u8, dst_stride: s32) {
    for r: 0..cast(s32) 4 - 1 {
        copy_memory(dst, src, 8);

        src += src_stride;
        dst += dst_stride;
    }
}

vp8_copy_mem8x8_c :: (src: *u8, src_stride: s32, dst: *u8, dst_stride: s32) {
    for r: 0..cast(s32) 8 - 1 {
        copy_memory(dst, src, 8);

        src += src_stride;
        dst += dst_stride;
    }
}

vp8_build_inter_predictors_mb :: (xd: *MACROBLOCKD_in_blockd) {
    if xd.mode_info_context.mbmi.mode != cast,no_check(u8) SPLITMV {
        vp8_build_inter16x16_predictors_mb(
            xd,
            xd.dst.y_buffer,
            xd.dst.u_buffer,
            xd.dst.v_buffer,
            xd.dst.y_stride,
            xd.dst.uv_stride
        );
    } else {
        build_4x4uvmvs(xd);
        build_inter4x4_predictors_mb(xd);
    }
}

build_inter4x4_predictors_mb :: (x: *MACROBLOCKD_in_blockd) {
    i: s32 = ---;
    base_dst: *u8 = x.dst.y_buffer;
    base_pre: *u8 = x.pre.y_buffer;

    if x.mode_info_context.mbmi.partitioning < 3 {
        dst_stride := x.dst.y_stride;

        x.block[0].bmi = x.mode_info_context.bmi[0];
        x.block[2].bmi = x.mode_info_context.bmi[2];
        x.block[8].bmi = x.mode_info_context.bmi[8];
        x.block[10].bmi = x.mode_info_context.bmi[10];
        if x.mode_info_context.mbmi.need_to_clamp_mvs != 0 {
            clamp_mv_to_umv_border(*x.block[0].bmi.mv.as_mv, x);
            clamp_mv_to_umv_border(*x.block[2].bmi.mv.as_mv, x);
            clamp_mv_to_umv_border(*x.block[8].bmi.mv.as_mv, x);
            clamp_mv_to_umv_border(*x.block[10].bmi.mv.as_mv, x);
        }

        b := x.block.data + 0;
        build_inter_predictors4b(x, b, base_dst + b.offset, dst_stride, base_pre, dst_stride);
        b = x.block.data + 2;
        build_inter_predictors4b(x, b, base_dst + b.offset, dst_stride, base_pre, dst_stride);
        b = x.block.data + 8;
        build_inter_predictors4b(x, b, base_dst + b.offset, dst_stride, base_pre, dst_stride);
        b = x.block.data + 10;
        build_inter_predictors4b(x, b, base_dst + b.offset, dst_stride, base_pre, dst_stride);
    } else {
        i = 0;
        while i < 16 {
            d0 := x.block.data + i;
            d1 := x.block.data + i + 1;
            dst_stride := x.dst.y_stride;

            x.block[i + 0].bmi = x.mode_info_context.bmi[i + 0];
            x.block[i + 1].bmi = x.mode_info_context.bmi[i + 1];
            if x.mode_info_context.mbmi.need_to_clamp_mvs != 0 {
                clamp_mv_to_umv_border(*x.block[i + 0].bmi.mv.as_mv, x);
                clamp_mv_to_umv_border(*x.block[i + 1].bmi.mv.as_mv, x);
            }

            if d0.bmi.mv.as_int == d1.bmi.mv.as_int {
                build_inter_predictors2b(x, d0, base_dst + d0.offset, dst_stride, base_pre, dst_stride);
            } else {
                build_inter_predictors_b(
                    d0,
                    base_dst + d0.offset,
                    dst_stride,
                    base_pre,
                    dst_stride,
                    cast,no_check(Vp8_Subpix_Fn_T) (x.subpixel_predict)
                );
                build_inter_predictors_b(
                    d1,
                    base_dst + d1.offset,
                    dst_stride,
                    base_pre,
                    dst_stride,
                    cast,no_check(Vp8_Subpix_Fn_T) (x.subpixel_predict)
                );
            }
            i += 2;
        }
    }
    base_dst = x.dst.u_buffer;
    base_pre = x.pre.u_buffer;
    i = 16;
    while i < 20 {
        d0 := x.block.data + i;
        d1 := x.block.data + i + 1;
        dst_stride := x.dst.uv_stride;

        if d0.bmi.mv.as_int == d1.bmi.mv.as_int {
            build_inter_predictors2b(x, d0, base_dst + d0.offset, dst_stride, base_pre, dst_stride);
        } else {
            build_inter_predictors_b(
                d0,
                base_dst + d0.offset,
                dst_stride,
                base_pre,
                dst_stride,
                cast,no_check(Vp8_Subpix_Fn_T) (x.subpixel_predict)
            );
            build_inter_predictors_b(
                d1,
                base_dst + d1.offset,
                dst_stride,
                base_pre,
                dst_stride,
                cast,no_check(Vp8_Subpix_Fn_T) (x.subpixel_predict)
            );
        }
        i += 2;
    }

    base_dst = x.dst.v_buffer;
    base_pre = x.pre.v_buffer;
    i = 20;
    while i < 24 {
        d0 := x.block.data + i;
        d1 := x.block.data + i + 1;
        dst_stride := x.dst.uv_stride;

        if d0.bmi.mv.as_int == d1.bmi.mv.as_int {
            build_inter_predictors2b(x, d0, base_dst + d0.offset, dst_stride, base_pre, dst_stride);
        } else {
            build_inter_predictors_b(
                d0,
                base_dst + d0.offset,
                dst_stride,
                base_pre,
                dst_stride,
                cast,no_check(Vp8_Subpix_Fn_T) (x.subpixel_predict)
            );
            build_inter_predictors_b(
                d1,
                base_dst + d1.offset,
                dst_stride,
                base_pre,
                dst_stride,
                cast,no_check(Vp8_Subpix_Fn_T) (x.subpixel_predict)
            );
        }
        i += 2;
    }
}

build_inter_predictors_b :: (
    d: *BLOCKD,
    dst: *u8,
    dst_stride: s32,
    base_pre: *u8,
    pre_stride: s32,
    sppf: Vp8_Subpix_Fn_T
) {
    ptr := base_pre + d.offset + (cast(s32) d.bmi.mv.as_mv.row) >> 3 * pre_stride + (cast(s32) d.bmi.mv.as_mv.col) >> 3;

    if d.bmi.mv.as_mv.row & 7 != 0 || d.bmi.mv.as_mv.col & 7 != 0 {
        sppf(ptr, pre_stride, (cast(s32) d.bmi.mv.as_mv.col) & 7, (cast(s32) d.bmi.mv.as_mv.row) & 7, dst, dst_stride);
    } else {
        for r: 0..cast(s32) 4 - 1 {
            dst[0] = ptr[0];
            dst[1] = ptr[1];
            dst[2] = ptr[2];
            dst[3] = ptr[3];
            dst += dst_stride;
            ptr += pre_stride;
        }
    }
}

build_inter_predictors2b :: (
    x: *MACROBLOCKD_in_blockd,
    d: *BLOCKD,
    dst: *u8,
    dst_stride: s32,
    base_pre: *u8,
    pre_stride: s32
) {
    ptr := base_pre + d.offset + (cast(s32) d.bmi.mv.as_mv.row) >> 3 * pre_stride + (cast(s32) d.bmi.mv.as_mv.col) >> 3;

    if d.bmi.mv.as_mv.row & 7 != 0 || d.bmi.mv.as_mv.col & 7 != 0 {
        x.subpixel_predict8x4(
            ptr,
            pre_stride,
            (cast(s32) d.bmi.mv.as_mv.col) & 7,
            (cast(s32) d.bmi.mv.as_mv.row) & 7,
            dst,
            dst_stride
        );
    } else {
        vp8_copy_mem8x4_c(ptr, pre_stride, dst, dst_stride);
    }
}

clamp_mv_to_umv_border :: (mv: *MV_in_alloccommon, xd: *MACROBLOCKD_in_blockd) {
    if cast,no_check(s32) mv.col < xd.mb_to_left_edge - (cast(s32) 19) << 3 {
        mv.col = cast,no_check(s16) (xd.mb_to_left_edge - (cast(s32) 16) << 3);
    } else if cast,no_check(s32) mv.col > xd.mb_to_right_edge + (cast(s32) 18) << 3 {
        mv.col = cast,no_check(s16) (xd.mb_to_right_edge + (cast(s32) 16) << 3);
    }

    if cast,no_check(s32) mv.row < xd.mb_to_top_edge - (cast(s32) 19) << 3 {
        mv.row = cast,no_check(s16) (xd.mb_to_top_edge - (cast(s32) 16) << 3);
    } else if cast,no_check(s32) mv.row > xd.mb_to_bottom_edge + (cast(s32) 18) << 3 {
        mv.row = cast,no_check(s16) (xd.mb_to_bottom_edge + (cast(s32) 16) << 3);
    }
}

build_inter_predictors4b :: (
    x: *MACROBLOCKD_in_blockd,
    d: *BLOCKD,
    dst: *u8,
    dst_stride: s32,
    base_pre: *u8,
    pre_stride: s32
) {
    ptr := base_pre + d.offset + (cast(s32) d.bmi.mv.as_mv.row) >> 3 * pre_stride + (cast(s32) d.bmi.mv.as_mv.col) >> 3;

    if d.bmi.mv.as_mv.row & 7 != 0 || d.bmi.mv.as_mv.col & 7 != 0 {
        x.subpixel_predict8x8(
            ptr,
            pre_stride,
            (cast(s32) d.bmi.mv.as_mv.col) & 7,
            (cast(s32) d.bmi.mv.as_mv.row) & 7,
            dst,
            dst_stride
        );
    } else {
        vp8_copy_mem8x8_c(ptr, pre_stride, dst, dst_stride);
    }
}

build_4x4uvmvs :: (x: *MACROBLOCKD_in_blockd) {
    j: s32 = ---;

    for i: 0..cast(s32) 2 - 1 {
        j = 0;
        while j < 2 {
            yoffset := i * 8 + j * 2;
            uoffset := 16 + i * 2 + j;
            voffset := 20 + i * 2 + j;

            temp :=
                (((cast(s32) x.mode_info_context.bmi[yoffset + 0].mv.as_mv.row) + cast(s32) x.mode_info_context.bmi[yoffset + 1].mv.as_mv.row) + cast(s32) x.mode_info_context.bmi[yoffset + 4].mv.as_mv.row) +
                    cast(s32) x.mode_info_context.bmi[yoffset + 5].mv.as_mv.row;

            temp += 4 + (temp >> (((((cast,no_check(u64) (size_of(s32))) * 8) - 1)) & 31)) * 8;

            x.block[uoffset].bmi.mv.as_mv.row = cast,no_check(s16) ((temp / 8) & x.fullpixel_mask);

            temp =
                (((cast(s32) x.mode_info_context.bmi[yoffset + 0].mv.as_mv.col) + cast(s32) x.mode_info_context.bmi[yoffset + 1].mv.as_mv.col) + cast(s32) x.mode_info_context.bmi[yoffset + 4].mv.as_mv.col) +
                    cast(s32) x.mode_info_context.bmi[yoffset + 5].mv.as_mv.col;

            temp += 4 + (temp >> (((((cast,no_check(u64) (size_of(s32))) * 8) - 1)) & 31)) * 8;

            x.block[uoffset].bmi.mv.as_mv.col = cast,no_check(s16) ((temp / 8) & x.fullpixel_mask);

            if x.mode_info_context.mbmi.need_to_clamp_mvs != 0 {
                clamp_uvmv_to_umv_border(*x.block[uoffset].bmi.mv.as_mv, x);
            }

            x.block[voffset].bmi.mv.as_int = x.block[uoffset].bmi.mv.as_int;
            j += 1;
        }
    }
}

clamp_uvmv_to_umv_border :: (mv: *MV_in_alloccommon, xd: *MACROBLOCKD_in_blockd) {
    mv.col =
        cast,no_check(s16) ((ifx (2 * cast(s32) mv.col) < xd.mb_to_left_edge -
            (cast(s32) 19) << 3 then (xd.mb_to_left_edge - (cast(s32) 16) << 3) >> 1 else cast,no_check(s32) mv.col));
    mv.col =
        cast,no_check(s16) ((ifx (2 * cast(s32) mv.col) > xd.mb_to_right_edge +
            (cast(s32) 18) << 3 then (xd.mb_to_right_edge + (cast(s32) 16) << 3) >> 1 else cast,no_check(s32) mv.col));

    mv.row =
        cast,no_check(s16) ((ifx (2 * cast(s32) mv.row) < xd.mb_to_top_edge -
            (cast(s32) 19) << 3 then (xd.mb_to_top_edge - (cast(s32) 16) << 3) >> 1 else cast,no_check(s32) mv.row));
    mv.row =
        cast,no_check(s16) ((ifx (2 * cast(s32) mv.row) > xd.mb_to_bottom_edge +
            (cast(s32) 18) << 3 then (xd.mb_to_bottom_edge + (cast(s32) 16) << 3) >> 1 else cast,no_check(s32) mv.row));
}

vp8_build_inter16x16_predictors_mb :: (
    x: *MACROBLOCKD_in_blockd,
    dst_y: *u8,
    dst_u: *u8,
    dst_v: *u8,
    dst_ystride: s32,
    dst_uvstride: s32
) {
    _16x16mv: Int_Mv_in_mv = ---;

    ptr_base: *u8 = x.pre.y_buffer;
    pre_stride := x.pre.y_stride;

    _16x16mv.as_int = x.mode_info_context.mbmi.mv.as_int;

    if x.mode_info_context.mbmi.need_to_clamp_mvs != 0 {
        clamp_mv_to_umv_border(*_16x16mv.as_mv, x);
    }

    ptr := ptr_base + (cast(s32) _16x16mv.as_mv.row) >> 3 * pre_stride + (cast(s32) _16x16mv.as_mv.col) >> 3;

    if _16x16mv.as_int & 0x70007 != 0 {
        x.subpixel_predict16x16(
            ptr,
            pre_stride,
            (cast(s32) _16x16mv.as_mv.col) & 7,
            (cast(s32) _16x16mv.as_mv.row) & 7,
            dst_y,
            dst_ystride
        );
    } else {
        vp8_copy_mem16x16_c(ptr, pre_stride, dst_y, dst_ystride);
    }

    _16x16mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) _16x16mv.as_mv.row) + (1 | ((cast(s32) _16x16mv.as_mv.row) >> (((((cast,no_check(u64) (size_of(s32))) * 8) - 1)) & 31))));
    _16x16mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) _16x16mv.as_mv.col) + (1 | ((cast(s32) _16x16mv.as_mv.col) >> (((((cast,no_check(u64) (size_of(s32))) * 8) - 1)) & 31))));
    _16x16mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) _16x16mv.as_mv.row) / 2);
    _16x16mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) _16x16mv.as_mv.col) / 2);
    _16x16mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) _16x16mv.as_mv.row) & x.fullpixel_mask);
    _16x16mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) _16x16mv.as_mv.col) & x.fullpixel_mask);

    clamp_uvmv_to_umv_border(*_16x16mv.as_mv, x);

    c_transpiler_compound_shr(*(pre_stride), (cast(s32) 1), s32, s32);
    offset := (cast(s32) _16x16mv.as_mv.row) >> 3 * pre_stride + (cast(s32) _16x16mv.as_mv.col) >> 3;
    uptr := x.pre.u_buffer + offset;
    vptr := x.pre.v_buffer + offset;

    if _16x16mv.as_int & 0x70007 != 0 {
        x.subpixel_predict8x8(
            uptr,
            pre_stride,
            (cast(s32) _16x16mv.as_mv.col) & 7,
            (cast(s32) _16x16mv.as_mv.row) & 7,
            dst_u,
            dst_uvstride
        );
        x.subpixel_predict8x8(
            vptr,
            pre_stride,
            (cast(s32) _16x16mv.as_mv.col) & 7,
            (cast(s32) _16x16mv.as_mv.row) & 7,
            dst_v,
            dst_uvstride
        );
    } else {
        vp8_copy_mem8x8_c(uptr, pre_stride, dst_u, dst_uvstride);
        vp8_copy_mem8x8_c(vptr, pre_stride, dst_v, dst_uvstride);
    }
}

vp8_build_inter16x16_predictors_mby :: (x: *MACROBLOCKD_in_blockd, dst_y: *u8, dst_ystride: s32) {
    mv_row := cast,no_check(s32) x.mode_info_context.mbmi.mv.as_mv.row;
    mv_col := cast,no_check(s32) x.mode_info_context.mbmi.mv.as_mv.col;
    pre_stride := x.pre.y_stride;

    ptr_base := x.pre.y_buffer;
    ptr := ptr_base + mv_row >> 3 * pre_stride + mv_col >> 3;

    if mv_row | mv_col & 7 != 0 {
        x.subpixel_predict16x16(ptr, pre_stride, mv_col & 7, mv_row & 7, dst_y, dst_ystride);
    } else {
        vp8_copy_mem16x16_c(ptr, pre_stride, dst_y, dst_ystride);
    }
}

vp8_build_inter_predictors_b :: (d: *BLOCKD, pitch: s32, base_pre: *u8, pre_stride: s32, sppf: Vp8_Subpix_Fn_T) {
    pred_ptr := d.predictor;
    ptr := base_pre + d.offset + (cast(s32) d.bmi.mv.as_mv.row) >> 3 * pre_stride + (cast(s32) d.bmi.mv.as_mv.col) >> 3;

    if d.bmi.mv.as_mv.row & 7 != 0 || d.bmi.mv.as_mv.col & 7 != 0 {
        sppf(ptr, pre_stride, (cast(s32) d.bmi.mv.as_mv.col) & 7, (cast(s32) d.bmi.mv.as_mv.row) & 7, pred_ptr, pitch);
    } else {
        for r: 0..cast(s32) 4 - 1 {
            pred_ptr[0] = ptr[0];
            pred_ptr[1] = ptr[1];
            pred_ptr[2] = ptr[2];
            pred_ptr[3] = ptr[3];
            pred_ptr += pitch;
            ptr += pre_stride;
        }
    }
}

vp8_build_inter16x16_predictors_mbuv :: (x: *MACROBLOCKD_in_blockd) {
    upred_ptr := x.predictor.data + 256;
    vpred_ptr := x.predictor.data + 320;

    mv_row := cast,no_check(s32) x.mode_info_context.mbmi.mv.as_mv.row;
    mv_col := cast,no_check(s32) x.mode_info_context.mbmi.mv.as_mv.col;

    pre_stride := x.pre.uv_stride;

    mv_row += 1 | (mv_row >> (((((cast,no_check(u64) (size_of(s32))) * 8) - 1)) & 31));
    mv_col += 1 | (mv_col >> (((((cast,no_check(u64) (size_of(s32))) * 8) - 1)) & 31));
    mv_row /= 2;
    mv_col /= 2;
    mv_row &= x.fullpixel_mask;
    mv_col &= x.fullpixel_mask;

    offset := mv_row >> 3 * pre_stride + mv_col >> 3;
    uptr := x.pre.u_buffer + offset;
    vptr := x.pre.v_buffer + offset;

    if mv_row | mv_col & 7 != 0 {
        x.subpixel_predict8x8(uptr, pre_stride, mv_col & 7, mv_row & 7, upred_ptr, 8);
        x.subpixel_predict8x8(vptr, pre_stride, mv_col & 7, mv_row & 7, vpred_ptr, 8);
    } else {
        vp8_copy_mem8x8_c(uptr, pre_stride, upred_ptr, 8);
        vp8_copy_mem8x8_c(vptr, pre_stride, vpred_ptr, 8);
    }
}

vp8_build_inter4x4_predictors_mbuv :: (x: *MACROBLOCKD_in_blockd) {
    j: s32 = ---;
    pre_stride := x.pre.uv_stride;

    i: s32 = 0;
    while i < 2 {
        j = 0;
        while j < 2 {
            yoffset := i * 8 + j * 2;
            uoffset := 16 + i * 2 + j;
            voffset := 20 + i * 2 + j;

            temp :=
                (((cast(s32) x.block[yoffset].bmi.mv.as_mv.row) + cast(s32) x.block[yoffset + 1].bmi.mv.as_mv.row) + cast(s32) x.block[yoffset + 4].bmi.mv.as_mv.row) +
                    cast(s32) x.block[yoffset + 5].bmi.mv.as_mv.row;

            temp += 4 + (temp >> (((((cast,no_check(u64) (size_of(s32))) * 8) - 1)) & 31)) * 8;

            x.block[uoffset].bmi.mv.as_mv.row = cast,no_check(s16) ((temp / 8) & x.fullpixel_mask);

            temp =
                (((cast(s32) x.block[yoffset].bmi.mv.as_mv.col) + cast(s32) x.block[yoffset + 1].bmi.mv.as_mv.col) + cast(s32) x.block[yoffset + 4].bmi.mv.as_mv.col) +
                    cast(s32) x.block[yoffset + 5].bmi.mv.as_mv.col;

            temp += 4 + (temp >> (((((cast,no_check(u64) (size_of(s32))) * 8) - 1)) & 31)) * 8;

            x.block[uoffset].bmi.mv.as_mv.col = cast,no_check(s16) ((temp / 8) & x.fullpixel_mask);

            x.block[voffset].bmi.mv.as_int = x.block[uoffset].bmi.mv.as_int;
            j += 1;
        }
        i += 1;
    }

    base_pre := x.pre.u_buffer;
    i = 16;
    while i < 20 {
        d0 := x.block.data + i;
        d1 := x.block.data + i + 1;

        if d0.bmi.mv.as_int == d1.bmi.mv.as_int {
            build_inter_predictors2b(x, d0, d0.predictor, 8, base_pre, pre_stride);
        } else {
            vp8_build_inter_predictors_b(
                d0,
                8,
                base_pre,
                pre_stride,
                cast,no_check(Vp8_Subpix_Fn_T) (x.subpixel_predict)
            );
            vp8_build_inter_predictors_b(
                d1,
                8,
                base_pre,
                pre_stride,
                cast,no_check(Vp8_Subpix_Fn_T) (x.subpixel_predict)
            );
        }
        i += 2;
    }

    base_pre = x.pre.v_buffer;
    i = 20;
    while i < 24 {
        d0 := x.block.data + i;
        d1 := x.block.data + i + 1;

        if d0.bmi.mv.as_int == d1.bmi.mv.as_int {
            build_inter_predictors2b(x, d0, d0.predictor, 8, base_pre, pre_stride);
        } else {
            vp8_build_inter_predictors_b(
                d0,
                8,
                base_pre,
                pre_stride,
                cast,no_check(Vp8_Subpix_Fn_T) (x.subpixel_predict)
            );
            vp8_build_inter_predictors_b(
                d1,
                8,
                base_pre,
                pre_stride,
                cast,no_check(Vp8_Subpix_Fn_T) (x.subpixel_predict)
            );
        }
        i += 2;
    }
}

