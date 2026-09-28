vp8_loop_filter_init :: (cm: *VP8_COMMON) {
    lfi := *cm.lf_info;

    vp8_loop_filter_update_sharpness(lfi, cm.sharpness_level);
    cm.last_sharpness_level = cm.sharpness_level;

    lf_init_lut(lfi);

    for i: 0..cast(s32) 4 - 1 {
        fill_memory(lfi.hev_thr[i].data, i, 16);
    }
}

lf_init_lut :: (lfi: *Loop_Filter_Info_N) {
    for filt_lvl: 0..cast(s32) 63 {
        if filt_lvl >= 40 {
            lfi.hev_thr_lut[KEY_FRAME_in_alloccommon][filt_lvl] = 2;
            lfi.hev_thr_lut[INTER_FRAME_in_alloccommon][filt_lvl] = 3;
        } else if filt_lvl >= 20 {
            lfi.hev_thr_lut[KEY_FRAME_in_alloccommon][filt_lvl] = 1;
            lfi.hev_thr_lut[INTER_FRAME_in_alloccommon][filt_lvl] = 2;
        } else if filt_lvl >= 15 {
            lfi.hev_thr_lut[KEY_FRAME_in_alloccommon][filt_lvl] = 1;
            lfi.hev_thr_lut[INTER_FRAME_in_alloccommon][filt_lvl] = 1;
        } else {
            lfi.hev_thr_lut[KEY_FRAME_in_alloccommon][filt_lvl] = 0;
            lfi.hev_thr_lut[INTER_FRAME_in_alloccommon][filt_lvl] = 0;
        }
    }

    lfi.mode_lf_lut[DC_PRED] = 1;
    lfi.mode_lf_lut[V_PRED] = 1;
    lfi.mode_lf_lut[H_PRED] = 1;
    lfi.mode_lf_lut[TM_PRED] = 1;
    lfi.mode_lf_lut[B_PRED] = 0;

    lfi.mode_lf_lut[ZEROMV] = 1;
    lfi.mode_lf_lut[NEARESTMV] = 2;
    lfi.mode_lf_lut[NEARMV] = 2;
    lfi.mode_lf_lut[NEWMV] = 2;
    lfi.mode_lf_lut[SPLITMV] = 3;
}

vp8_loop_filter_update_sharpness :: (lfi: *Loop_Filter_Info_N, sharpness_lvl: s32) {
    for i: 0..cast(s32) 63 {
        filt_lvl := i;
        block_inside_limit: s32 = 0;

        block_inside_limit = filt_lvl >> ((cast(s32) (sharpness_lvl > 0)) & 31);
        block_inside_limit = block_inside_limit >> ((cast(s32) (sharpness_lvl > 4)) & 31);

        if sharpness_lvl > 0 {
            if block_inside_limit > 9 - sharpness_lvl {
                block_inside_limit = 9 - sharpness_lvl;
            }
        }

        if block_inside_limit < 1 {
            block_inside_limit = 1;
        }

        fill_memory(lfi.lim[i].data, block_inside_limit, 16);
        fill_memory(lfi.blim[i].data, 2 * filt_lvl + block_inside_limit, 16);
        fill_memory(lfi.mblim[i].data, 2 * (filt_lvl + 2) + block_inside_limit, 16);
    }
}

vp8_loop_filter_frame_init :: (cm: *VP8_COMMON, mbd: *MACROBLOCKD_in_blockd, default_filt_lvl: s32) {
    lfi := *cm.lf_info;

    if cm.last_sharpness_level != cm.sharpness_level {
        vp8_loop_filter_update_sharpness(lfi, cm.sharpness_level);
        cm.last_sharpness_level = cm.sharpness_level;
    }

    for seg: 0..cast(s32) 4 - 1 {
        lvl_seg := default_filt_lvl;

        if mbd.segmentation_enabled != 0 {
            if mbd.mb_segment_abs_delta == 1 {
                lvl_seg = cast,no_check(s32) mbd.segment_feature_data[MB_LVL_ALT_LF][seg];
            } else {
                lvl_seg += cast,no_check(s32) mbd.segment_feature_data[MB_LVL_ALT_LF][seg];
            }
            lvl_seg = ifx lvl_seg > 0 then (ifx lvl_seg > 63 then 63 else lvl_seg) else 0;
        }

        if mbd.mode_ref_lf_delta_enabled == 0 {
            fill_memory(lfi.lvl[seg][0].data, lvl_seg, cast,no_check(u64) (4 * 4));
            continue;
        }

        ref := cast,no_check(s32) (INTRA_FRAME);

        lvl_ref := lvl_seg + cast(s32) mbd.ref_lf_deltas[ref];

        mode: s32 = 0;

        lvl_mode := lvl_ref + cast(s32) mbd.mode_lf_deltas[mode];

        lvl_mode = ifx lvl_mode > 0 then (ifx lvl_mode > 63 then 63 else lvl_mode) else 0;

        lfi.lvl[seg][ref][mode] = cast,no_check(u8) lvl_mode;

        mode = 1;

        lvl_mode = ifx lvl_ref > 0 then (ifx lvl_ref > 63 then 63 else lvl_ref) else 0;
        lfi.lvl[seg][ref][mode] = cast,no_check(u8) lvl_mode;

        ref = 1;
        while ref < MAX_REF_FRAMES {
            lvl_ref = lvl_seg + cast(s32) mbd.ref_lf_deltas[ref];

            mode = 1;
            while mode < 4 {
                lvl_mode = lvl_ref + cast(s32) mbd.mode_lf_deltas[mode];

                lvl_mode = ifx lvl_mode > 0 then (ifx lvl_mode > 63 then 63 else lvl_mode) else 0;

                lfi.lvl[seg][ref][mode] = cast,no_check(u8) lvl_mode;
                mode += 1;
            }
            ref += 1;
        }
    }
}

vp8_loop_filter_frame :: (cm: *VP8_COMMON, mbd: *MACROBLOCKD_in_blockd, frame_type: s32) {
    post := cm.frame_to_show;
    lfi_n := *cm.lf_info;
    lfi: Loop_Filter_Info = ---;

    mb_col: s32 = ---;
    mb_rows := cm.mb_rows;
    mb_cols := cm.mb_cols;

    filter_level: s32 = ---;

    mode_info_context := cm.mi;
    post_y_stride := post.y_stride;
    post_uv_stride := post.uv_stride;

    vp8_loop_filter_frame_init(cm, mbd, cm.filter_level);

    y_ptr := post.y_buffer;
    u_ptr := post.u_buffer;
    v_ptr := post.v_buffer;

    if cm.filter_type == cast,no_check(u32) NORMAL_LOOPFILTER {
        if 0 < mb_rows {
            for mb_row: 0..mb_rows - 1 {
                mb_col = 0;
                while mb_col < mb_cols {
                    skip_lf :=
                        cast(s32) (mode_info_context.mbmi.mode != cast,no_check(u8) B_PRED &&
                            mode_info_context.mbmi.mode != cast,no_check(u8) SPLITMV && mode_info_context.mbmi.mb_skip_coeff != 0);

                    MODE_INDEX := cast,no_check(s32) lfi_n.mode_lf_lut[mode_info_context.mbmi.mode];
                    SEG := cast,no_check(s32) mode_info_context.mbmi.segment_id;
                    REF_FRAME := cast,no_check(s32) mode_info_context.mbmi.ref_frame;

                    filter_level = cast,no_check(s32) lfi_n.lvl[SEG][REF_FRAME][MODE_INDEX];

                    if filter_level != 0 {
                        HEV_INDEX := cast,no_check(s32) lfi_n.hev_thr_lut[frame_type][filter_level];
                        lfi.mblim = lfi_n.mblim[filter_level].data;
                        lfi.blim = lfi_n.blim[filter_level].data;
                        lfi.lim = lfi_n.lim[filter_level].data;
                        lfi.hev_thr = lfi_n.hev_thr[HEV_INDEX].data;

                        if mb_col > 0 {
                            vp8_loop_filter_mbv_c(y_ptr, u_ptr, v_ptr, post_y_stride, post_uv_stride, *lfi);
                        }

                        if skip_lf == 0 {
                            vp8_loop_filter_bv_c(y_ptr, u_ptr, v_ptr, post_y_stride, post_uv_stride, *lfi);
                        }

                        if mb_row > 0 {
                            vp8_loop_filter_mbh_c(y_ptr, u_ptr, v_ptr, post_y_stride, post_uv_stride, *lfi);
                        }

                        if skip_lf == 0 {
                            vp8_loop_filter_bh_c(y_ptr, u_ptr, v_ptr, post_y_stride, post_uv_stride, *lfi);
                        }
                    }

                    y_ptr += 16;
                    u_ptr += 8;
                    v_ptr += 8;

                    mode_info_context += 1;
                    mb_col += 1;
                }
                y_ptr += post_y_stride * 16 - post.y_width;
                u_ptr += post_uv_stride * 8 - post.uv_width;
                v_ptr += post_uv_stride * 8 - post.uv_width;

                mode_info_context += 1;
            }
        }
    } else {
        if 0 < mb_rows {
            for mb_row: 0..mb_rows - 1 {
                mb_col = 0;
                while mb_col < mb_cols {
                    skip_lf :=
                        cast(s32) (mode_info_context.mbmi.mode != cast,no_check(u8) B_PRED &&
                            mode_info_context.mbmi.mode != cast,no_check(u8) SPLITMV && mode_info_context.mbmi.mb_skip_coeff != 0);

                    MODE_INDEX := cast,no_check(s32) lfi_n.mode_lf_lut[mode_info_context.mbmi.mode];
                    SEG := cast,no_check(s32) mode_info_context.mbmi.segment_id;
                    REF_FRAME := cast,no_check(s32) mode_info_context.mbmi.ref_frame;

                    filter_level = cast,no_check(s32) lfi_n.lvl[SEG][REF_FRAME][MODE_INDEX];
                    if filter_level != 0 {
                        mblim := lfi_n.mblim[filter_level].data;
                        blim := lfi_n.blim[filter_level].data;

                        if mb_col > 0 {
                            vp8_loop_filter_simple_vertical_edge_c(y_ptr, post_y_stride, mblim);
                        }

                        if skip_lf == 0 {
                            vp8_loop_filter_bvs_c(y_ptr, post_y_stride, blim);
                        }

                        if mb_row > 0 {
                            vp8_loop_filter_simple_horizontal_edge_c(y_ptr, post_y_stride, mblim);
                        }

                        if skip_lf == 0 {
                            vp8_loop_filter_bhs_c(y_ptr, post_y_stride, blim);
                        }
                    }

                    y_ptr += 16;
                    u_ptr += 8;
                    v_ptr += 8;

                    mode_info_context += 1;
                    mb_col += 1;
                }
                y_ptr += post_y_stride * 16 - post.y_width;
                u_ptr += post_uv_stride * 8 - post.uv_width;
                v_ptr += post_uv_stride * 8 - post.uv_width;

                mode_info_context += 1;
            }
        }
    }
}

vp8_loop_filter_partial_frame :: (cm: *VP8_COMMON, mbd: *MACROBLOCKD_in_blockd, default_filt_lvl: s32) {
    post := cm.frame_to_show;

    mb_col: s32 = ---;
    mb_cols := post.y_width >> 4;
    mb_rows := post.y_height >> 4;

    lfi_n := *cm.lf_info;
    lfi: Loop_Filter_Info = ---;

    filter_level: s32 = ---;
    frame_type := cm.frame_type;

    vp8_loop_filter_frame_init(cm, mbd, default_filt_lvl);

    linestocopy := mb_rows / 8;
    linestocopy = ifx linestocopy != 0 then linestocopy << 4 else 16;

    y_ptr := post.y_buffer + post.y_height >> 5 * 16 * post.y_stride;
    mode_info_context := cm.mi + post.y_height >> 5 * (mb_cols + 1);

    mb_row: s32 = 0;
    while mb_row < linestocopy >> 4 {
        mb_col = 0;
        while mb_col < mb_cols {
            skip_lf :=
                cast(s32) (mode_info_context.mbmi.mode != cast,no_check(u8) B_PRED &&
                    mode_info_context.mbmi.mode != cast,no_check(u8) SPLITMV && mode_info_context.mbmi.mb_skip_coeff != 0);

            MODE_INDEX := cast,no_check(s32) lfi_n.mode_lf_lut[mode_info_context.mbmi.mode];
            SEG := cast,no_check(s32) mode_info_context.mbmi.segment_id;
            REF_FRAME := cast,no_check(s32) mode_info_context.mbmi.ref_frame;

            filter_level = cast,no_check(s32) lfi_n.lvl[SEG][REF_FRAME][MODE_INDEX];

            if filter_level != 0 {
                if cm.filter_type == cast,no_check(u32) NORMAL_LOOPFILTER {
                    HEV_INDEX := cast,no_check(s32) lfi_n.hev_thr_lut[frame_type][filter_level];
                    lfi.mblim = lfi_n.mblim[filter_level].data;
                    lfi.blim = lfi_n.blim[filter_level].data;
                    lfi.lim = lfi_n.lim[filter_level].data;
                    lfi.hev_thr = lfi_n.hev_thr[HEV_INDEX].data;

                    if mb_col > 0 {
                        vp8_loop_filter_mbv_c(y_ptr, null, null, post.y_stride, 0, *lfi);
                    }

                    if skip_lf == 0 {
                        vp8_loop_filter_bv_c(y_ptr, null, null, post.y_stride, 0, *lfi);
                    }

                    vp8_loop_filter_mbh_c(y_ptr, null, null, post.y_stride, 0, *lfi);

                    if skip_lf == 0 {
                        vp8_loop_filter_bh_c(y_ptr, null, null, post.y_stride, 0, *lfi);
                    }
                } else {
                    if mb_col > 0 {
                        vp8_loop_filter_simple_vertical_edge_c(y_ptr, post.y_stride, lfi_n.mblim[filter_level].data);
                    }

                    if skip_lf == 0 {
                        vp8_loop_filter_bvs_c(y_ptr, post.y_stride, lfi_n.blim[filter_level].data);
                    }

                    vp8_loop_filter_simple_horizontal_edge_c(y_ptr, post.y_stride, lfi_n.mblim[filter_level].data);

                    if skip_lf == 0 {
                        vp8_loop_filter_bhs_c(y_ptr, post.y_stride, lfi_n.blim[filter_level].data);
                    }
                }
            }

            y_ptr += 16;
            mode_info_context += 1;
            mb_col += 1;
        }

        y_ptr += post.y_stride * 16 - post.y_width;
        mode_info_context += 1;
        mb_row += 1;
    }
}

vp8_loop_filter_frame_yonly :: (cm: *VP8_COMMON, mbd: *MACROBLOCKD_in_blockd, default_filt_lvl: s32) {
    post := cm.frame_to_show;

    mb_col: s32 = ---;

    lfi_n := *cm.lf_info;
    lfi: Loop_Filter_Info = ---;

    filter_level: s32 = ---;
    frame_type := cm.frame_type;

    mode_info_context := cm.mi;

    vp8_loop_filter_frame_init(cm, mbd, default_filt_lvl);

    y_ptr := post.y_buffer;

    mb_row: s32 = 0;
    while mb_row < cm.mb_rows {
        mb_col = 0;
        while mb_col < cm.mb_cols {
            skip_lf :=
                cast(s32) (mode_info_context.mbmi.mode != cast,no_check(u8) B_PRED &&
                    mode_info_context.mbmi.mode != cast,no_check(u8) SPLITMV && mode_info_context.mbmi.mb_skip_coeff != 0);

            MODE_INDEX := cast,no_check(s32) lfi_n.mode_lf_lut[mode_info_context.mbmi.mode];
            SEG := cast,no_check(s32) mode_info_context.mbmi.segment_id;
            REF_FRAME := cast,no_check(s32) mode_info_context.mbmi.ref_frame;

            filter_level = cast,no_check(s32) lfi_n.lvl[SEG][REF_FRAME][MODE_INDEX];

            if filter_level != 0 {
                if cm.filter_type == cast,no_check(u32) NORMAL_LOOPFILTER {
                    HEV_INDEX := cast,no_check(s32) lfi_n.hev_thr_lut[frame_type][filter_level];
                    lfi.mblim = lfi_n.mblim[filter_level].data;
                    lfi.blim = lfi_n.blim[filter_level].data;
                    lfi.lim = lfi_n.lim[filter_level].data;
                    lfi.hev_thr = lfi_n.hev_thr[HEV_INDEX].data;

                    if mb_col > 0 {
                        vp8_loop_filter_mbv_c(y_ptr, null, null, post.y_stride, 0, *lfi);
                    }

                    if skip_lf == 0 {
                        vp8_loop_filter_bv_c(y_ptr, null, null, post.y_stride, 0, *lfi);
                    }

                    if mb_row > 0 {
                        vp8_loop_filter_mbh_c(y_ptr, null, null, post.y_stride, 0, *lfi);
                    }

                    if skip_lf == 0 {
                        vp8_loop_filter_bh_c(y_ptr, null, null, post.y_stride, 0, *lfi);
                    }
                } else {
                    if mb_col > 0 {
                        vp8_loop_filter_simple_vertical_edge_c(y_ptr, post.y_stride, lfi_n.mblim[filter_level].data);
                    }

                    if skip_lf == 0 {
                        vp8_loop_filter_bvs_c(y_ptr, post.y_stride, lfi_n.blim[filter_level].data);
                    }

                    if mb_row > 0 {
                        vp8_loop_filter_simple_horizontal_edge_c(y_ptr, post.y_stride, lfi_n.mblim[filter_level].data);
                    }

                    if skip_lf == 0 {
                        vp8_loop_filter_bhs_c(y_ptr, post.y_stride, lfi_n.blim[filter_level].data);
                    }
                }
            }

            y_ptr += 16;
            mode_info_context += 1;
            mb_col += 1;
        }

        y_ptr += post.y_stride * 16 - post.y_width;
        mode_info_context += 1;
        mb_row += 1;
    }
}

vp8_loop_filter_row_normal :: (
    cm: *VP8_COMMON,
    mode_info_context: *MODE_INFO_in_blockd,
    mb_row: s32,
    post_ystride: s32,
    post_uvstride: s32,
    y_ptr: *u8,
    u_ptr: *u8,
    v_ptr: *u8
) {
    lfi_n := *cm.lf_info;
    lfi: Loop_Filter_Info = ---;
    frame_type := cm.frame_type;

    mb_col: s32 = 0;
    while mb_col < cm.mb_cols {
        skip_lf :=
            cast(s32) (mode_info_context.mbmi.mode != cast,no_check(u8) B_PRED &&
                mode_info_context.mbmi.mode != cast,no_check(u8) SPLITMV && mode_info_context.mbmi.mb_skip_coeff != 0);

        MODE_INDEX := cast,no_check(s32) lfi_n.mode_lf_lut[mode_info_context.mbmi.mode];
        SEG := cast,no_check(s32) mode_info_context.mbmi.segment_id;
        REF_FRAME := cast,no_check(s32) mode_info_context.mbmi.ref_frame;

        filter_level := cast,no_check(s32) lfi_n.lvl[SEG][REF_FRAME][MODE_INDEX];

        if filter_level != 0 {
            HEV_INDEX := cast,no_check(s32) lfi_n.hev_thr_lut[frame_type][filter_level];
            lfi.mblim = lfi_n.mblim[filter_level].data;
            lfi.blim = lfi_n.blim[filter_level].data;
            lfi.lim = lfi_n.lim[filter_level].data;
            lfi.hev_thr = lfi_n.hev_thr[HEV_INDEX].data;

            if mb_col > 0 {
                vp8_loop_filter_mbv_c(y_ptr, u_ptr, v_ptr, post_ystride, post_uvstride, *lfi);
            }

            if skip_lf == 0 {
                vp8_loop_filter_bv_c(y_ptr, u_ptr, v_ptr, post_ystride, post_uvstride, *lfi);
            }

            if mb_row > 0 {
                vp8_loop_filter_mbh_c(y_ptr, u_ptr, v_ptr, post_ystride, post_uvstride, *lfi);
            }

            if skip_lf == 0 {
                vp8_loop_filter_bh_c(y_ptr, u_ptr, v_ptr, post_ystride, post_uvstride, *lfi);
            }
        }

        y_ptr += 16;
        u_ptr += 8;
        v_ptr += 8;

        mode_info_context += 1;
        mb_col += 1;
    }
}

vp8_loop_filter_row_simple :: (
    cm: *VP8_COMMON,
    mode_info_context: *MODE_INFO_in_blockd,
    mb_row: s32,
    post_ystride: s32,
    y_ptr: *u8
) {
    lfi_n := *cm.lf_info;

    mb_col: s32 = 0;
    while mb_col < cm.mb_cols {
        skip_lf :=
            cast(s32) (mode_info_context.mbmi.mode != cast,no_check(u8) B_PRED &&
                mode_info_context.mbmi.mode != cast,no_check(u8) SPLITMV && mode_info_context.mbmi.mb_skip_coeff != 0);

        MODE_INDEX := cast,no_check(s32) lfi_n.mode_lf_lut[mode_info_context.mbmi.mode];
        SEG := cast,no_check(s32) mode_info_context.mbmi.segment_id;
        REF_FRAME := cast,no_check(s32) mode_info_context.mbmi.ref_frame;

        filter_level := cast,no_check(s32) lfi_n.lvl[SEG][REF_FRAME][MODE_INDEX];

        if filter_level != 0 {
            if mb_col > 0 {
                vp8_loop_filter_simple_vertical_edge_c(y_ptr, post_ystride, lfi_n.mblim[filter_level].data);
            }

            if skip_lf == 0 {
                vp8_loop_filter_bvs_c(y_ptr, post_ystride, lfi_n.blim[filter_level].data);
            }

            if mb_row > 0 {
                vp8_loop_filter_simple_horizontal_edge_c(y_ptr, post_ystride, lfi_n.mblim[filter_level].data);
            }

            if skip_lf == 0 {
                vp8_loop_filter_bhs_c(y_ptr, post_ystride, lfi_n.blim[filter_level].data);
            }
        }

        y_ptr += 16;

        mode_info_context += 1;
        mb_col += 1;
    }
}

MB_LVL_FEATURES :: u32;
MB_LVL_ALT_Q : s32 : 0;
MB_LVL_ALT_LF : s32 : 1;
MB_LVL_MAX : s32 : 2;

Loop_Filter_Info :: struct {
    mblim: *u8;
    blim: *u8;
    lim: *u8;
    hev_thr: *u8;
}

