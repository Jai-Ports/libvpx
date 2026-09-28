// Generated directly from C by cpp_transpiler.
COUNT_TO_UPDATE_FACTOR_in_vp9_thread_common: [21] s32;

SUB_PEL_FILTERS_12_in_vp9_thread_common: [16] Interp_Kernel12 #align 256;

clip_pixel_in_vp9_thread_common :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_thread_common :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_thread_common :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_thread_common :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_thread_common :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_thread_common(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_thread_common(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_thread_common(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_thread_common :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_prob_in_vp9_thread_common :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_thread_common :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_thread_common(n0, DEN);
}

weighted_prob_in_vp9_thread_common :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_thread_common :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_thread_common(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_thread_common(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_thread_common :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_thread_common[COUNT];
        PROB := get_prob_in_vp9_thread_common(ct[0], DEN);
        return weighted_prob_in_vp9_thread_common(
            cast,no_check(s32) pre_prob,
            cast,no_check(s32) PROB,
            cast,no_check(s32) FACTOR
        );
    }
}

get_lsb_in_vp9_thread_common :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_thread_common :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_thread_common :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_thread_common(num_values) + 1 else 0;
}

get_band_translate_in_vp9_thread_common :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_thread_common :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_thread_common :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_thread_common(above_ec, left_ec);
}

is_zero_mv_in_vp9_thread_common :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_thread_common :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_thread_common :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_thread_common(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_thread_common(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_thread_common :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_thread_common :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_thread_common :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_thread_common :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

get_filter_taps_in_vp9_thread_common :: (FILTER: *s16) -> s32 {
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

vp9_is_valid_scale_in_vp9_thread_common :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_thread_common :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_thread_common(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_thread_common :: (
    ref_width: s32,
    ref_height: s32,
    this_width: s32,
    this_height: s32
) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_thread_common :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_thread_common :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_thread_common :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_thread_common :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_thread_common :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_thread_common :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_thread_common :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_thread_common :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_thread_common :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_thread_common :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_thread_common(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_thread_common :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_thread_common(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_thread_common(MI, ib)];
}

get_uv_tx_size_in_vp9_thread_common :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_thread_common :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_thread_common :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_thread_common(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_thread_common :: (
    mi: *MODE_INFO,
    above_mi: *MODE_INFO,
    left_mi: *MODE_INFO,
    block: s32
) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_thread_common :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

vp9_loop_filter_alloc :: (lf_sync: *VP9_Lf_Sync, cm: *VP9_COMMON, rows: s32, width: s32, num_workers: s32) {
    lf_sync.rows = rows;

    {
        lf_sync.mutex =
            cast(*Pthread_Mutex_T) allocate_memory(
                size_of(Pthread_Mutex_T) * cast,no_check(u64) rows
            );

        if lf_sync.mutex == null {
            internal_error(
                *cm.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate lf_sync->mutex")
            );
        }
        if lf_sync.mutex != null {
            if 0 < rows {
                for i: 0..rows - 1 {
                    pthread_mutex_init(*(cast(*Pthread_Mutex_T) (lf_sync.mutex))[i], null);
                }
            }
        }

        lf_sync.cond =
            cast(*Pthread_Cond_T) allocate_memory(
                size_of(Pthread_Cond_T) * cast,no_check(u64) rows
            );

        if lf_sync.cond == null {
            internal_error(
                *cm.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate lf_sync->cond")
            );
        }
        if lf_sync.cond != null {
            if 0 < rows {
                for i: 0..rows - 1 {
                    pthread_cond_init(*(cast(*Pthread_Cond_T) (lf_sync.cond))[i], null);
                }
            }
        }

        lf_sync.lf_mutex = cast(*Pthread_Mutex_T) allocate_memory(size_of(Pthread_Mutex_T));

        if lf_sync.lf_mutex == null {
            internal_error(
                *cm.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate lf_sync->lf_mutex")
            );
        }
        pthread_mutex_init(lf_sync.lf_mutex, null);

        lf_sync.recon_done_mutex =
            cast(*Pthread_Mutex_T) allocate_memory(
                size_of(Pthread_Mutex_T) * cast,no_check(u64) rows
            );

        if lf_sync.recon_done_mutex == null {
            internal_error(
                *cm.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate lf_sync->recon_done_mutex")
            );
        }
        if lf_sync.recon_done_mutex != null {
            if 0 < rows {
                for i: 0..rows - 1 {
                    pthread_mutex_init(*(cast(*Pthread_Mutex_T) (lf_sync.recon_done_mutex))[i], null);
                }
            }
        }

        lf_sync.recon_done_cond =
            cast(*Pthread_Cond_T) allocate_memory(
                size_of(Pthread_Cond_T) * cast,no_check(u64) rows
            );

        if lf_sync.recon_done_cond == null {
            internal_error(
                *cm.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate lf_sync->recon_done_cond")
            );
        }
        if lf_sync.recon_done_cond != null {
            if 0 < rows {
                for i: 0..rows - 1 {
                    pthread_cond_init(*(cast(*Pthread_Cond_T) (lf_sync.recon_done_cond))[i], null);
                }
            }
        }
    }

    lf_sync.lfdata =
        cast(*LF_Worker_Data) allocate_memory(
            (cast,no_check(u64) num_workers) * size_of(LF_Worker_Data)
        );

    if lf_sync.lfdata == null {
        internal_error(
            *cm.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate lf_sync->lfdata")
        );
    }
    lf_sync.num_workers = num_workers;
    lf_sync.num_active_workers = lf_sync.num_workers;

    lf_sync.cur_sb_col = cast(*s32) allocate_memory(size_of(s32) * cast,no_check(u64) rows);

    if lf_sync.cur_sb_col == null {
        internal_error(
            *cm.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate lf_sync->cur_sb_col")
        );
    }

    lf_sync.num_tiles_done =
        cast(*s32) allocate_memory(
            (size_of(s32) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_thread_common(cm.mi_rows)) >> (((6 - 3)) & 63)
        );

    if lf_sync.num_tiles_done == null {
        internal_error(
            *cm.error,
            cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
            c_string("Failed to allocate lf_sync->num_tiles_done")
        );
    }

    lf_sync.sync_range = get_sync_range(width);
}

get_sync_range :: (width: s32) -> s32 {
    if width < 640 {
        return 1;
    } else if width <= 1280 {
        return 2;
    } else if width <= 4096 {
        return 4;
    } else {
        return 8;
    }
}

mi_cols_aligned_to_sb_in_vp9_thread_common :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

vp9_loop_filter_dealloc :: (lf_sync: *VP9_Lf_Sync) {
    if lf_sync.mutex != null {
        i: s32 = 0;
        while i < lf_sync.rows {
            pthread_mutex_destroy(*(cast(*Pthread_Mutex_T) (lf_sync.mutex))[i]);
            i += 1;
        }
        deallocate_memory(cast(*void) lf_sync.mutex);
    }
    if lf_sync.cond != null {
        i: s32 = 0;
        while i < lf_sync.rows {
            pthread_cond_destroy(*(cast(*Pthread_Cond_T) (lf_sync.cond))[i]);
            i += 1;
        }
        deallocate_memory(cast(*void) lf_sync.cond);
    }
    if lf_sync.recon_done_mutex != null {
        i: s32 = 0;
        while i < lf_sync.rows {
            pthread_mutex_destroy(*(cast(*Pthread_Mutex_T) (lf_sync.recon_done_mutex))[i]);
            i += 1;
        }
        deallocate_memory(cast(*void) lf_sync.recon_done_mutex);
    }

    if lf_sync.lf_mutex != null {
        pthread_mutex_destroy(lf_sync.lf_mutex);
        deallocate_memory(cast(*void) lf_sync.lf_mutex);
    }
    if lf_sync.recon_done_cond != null {
        i: s32 = 0;
        while i < lf_sync.rows {
            pthread_cond_destroy(*(cast(*Pthread_Cond_T) (lf_sync.recon_done_cond))[i]);
            i += 1;
        }
        deallocate_memory(cast(*void) lf_sync.recon_done_cond);
    }

    deallocate_memory(cast(*void) lf_sync.lfdata);
    deallocate_memory(cast(*void) lf_sync.cur_sb_col);
    deallocate_memory(cast(*void) lf_sync.num_tiles_done);

    fill_memory(lf_sync, 0, size_of(VP9_Lf_Sync));
}

vp9_loop_filter_frame_mt :: (
    frame: *YV12_BUFFER_CONFIG,
    cm: *VP9_COMMON,
    planes: *Macroblockd_Plane,
    frame_filter_level: s32,
    y_only: s32,
    partial_frame: s32,
    workers: *Worker,
    num_workers: s32,
    lf_sync: *VP9_Lf_Sync
) {
    if frame_filter_level == 0 {
        return;
    }

    start_mi_row: s32 = 0;
    mi_rows_to_filter := cm.mi_rows;
    if partial_frame != 0 && cm.mi_rows > 8 {
        start_mi_row = cm.mi_rows >> 1;
        start_mi_row = cast,no_check(s32) ((cast,no_check(u32) start_mi_row) & 0xfffffff8);
        mi_rows_to_filter = ifx cm.mi_rows / 8 > 8 then cm.mi_rows / 8 else 8;
    }
    end_mi_row := start_mi_row + mi_rows_to_filter;
    vp9_loop_filter_frame_init(cm, frame_filter_level);

    loop_filter_rows_mt(frame, cm, planes, start_mi_row, end_mi_row, y_only, workers, num_workers, lf_sync);
}

loop_filter_rows_mt :: (
    frame: *YV12_BUFFER_CONFIG,
    cm: *VP9_COMMON,
    planes: *Macroblockd_Plane,
    start: s32,
    stop: s32,
    y_only: s32,
    workers: *Worker,
    nworkers: s32,
    lf_sync: *VP9_Lf_Sync
) {
    WINTERFACE := get_worker_interface();

    SB_ROWS := mi_cols_aligned_to_sb_in_vp9_thread_common(cm.mi_rows) >> (((6 - 3)) & 31);
    NUM_TILE_COLS := (cast(s32) 1) << ((cm.log2_tile_cols) & 31);

    NUM_WORKERS := (ifx nworkers < min(NUM_TILE_COLS, SB_ROWS) then nworkers else min(NUM_TILE_COLS, SB_ROWS));

    if lf_sync.sync_range == 0 || SB_ROWS != lf_sync.rows || NUM_WORKERS > lf_sync.num_workers {
        vp9_loop_filter_dealloc(lf_sync);
        vp9_loop_filter_alloc(lf_sync, cm, SB_ROWS, cm.width, NUM_WORKERS);
    }
    lf_sync.num_active_workers = NUM_WORKERS;

    fill_memory(lf_sync.cur_sb_col, -1, size_of(s32) * cast,no_check(u64) SB_ROWS);

    if 0 < NUM_WORKERS {
        for i: 0..NUM_WORKERS - 1 {
            WORKER := *workers[i];
            LF_DATA := *(cast(*Loop_Filter_Worker_Data) (lf_sync.lfdata))[i];

            WORKER.hook = loop_filter_row_worker;
            WORKER.data1 = cast(*void) lf_sync;
            WORKER.data2 = cast(*void) LF_DATA;

            vp9_loop_filter_data_reset(LF_DATA, frame, cm, planes);
            LF_DATA.start = start + i * (cast(s32) 1) << (((6 - 3)) & 31);
            LF_DATA.stop = stop;
            LF_DATA.y_only = y_only;

            if i == NUM_WORKERS - 1 {
                WINTERFACE.execute(WORKER);
            } else {
                WINTERFACE.launch(WORKER);
            }
        }
    }

    if 0 < NUM_WORKERS {
        for i: 0..NUM_WORKERS - 1 {
            WINTERFACE.sync(*workers[i]);
        }
    }
}

loop_filter_row_worker :: (arg1: *void, arg2: *void) -> s32 {
    LF_SYNC := cast(*VP9_Lf_Sync) arg1;
    LF_DATA := cast(*LF_Worker_Data) arg2;
    thread_loop_filter_rows(
        LF_DATA.frame_buffer,
        LF_DATA.cm,
        LF_DATA.planes.data,
        LF_DATA.start,
        LF_DATA.stop,
        LF_DATA.y_only,
        LF_SYNC
    );
    return 1;
}

thread_loop_filter_rows :: (
    FRAME_BUFFER: *YV12_BUFFER_CONFIG,
    CM: *VP9_COMMON,
    planes: *Macroblockd_Plane,
    start: s32,
    stop: s32,
    y_only: s32,
    LF_SYNC: *VP9_Lf_Sync
) {
    NUM_PLANES := (ifx y_only != 0 then cast(s32) 1 else 3);
    SB_COLS := mi_cols_aligned_to_sb_in_vp9_thread_common(CM.mi_cols) >> (((6 - 3)) & 31);
    NUM_ACTIVE_WORKERS := LF_SYNC.num_active_workers;
    mi_col: s32 = ---;

    path: Lf_Path = ifx y_only != 0
        then cast,no_check(Lf_Path) LF_PATH_444
        else ifx planes[1].subsampling_y == 1 && planes[1].subsampling_x == 1
            then cast,no_check(Lf_Path) LF_PATH_420
            else ifx planes[1].subsampling_y == 0 && planes[1].subsampling_x == 0
                then cast,no_check(Lf_Path) LF_PATH_444
                else cast,no_check(Lf_Path) LF_PATH_SLOW;

    mi_row := start;
    while mi_row < stop {
        MI := CM.mi_grid_visible + mi_row * CM.mi_stride;
        lfm := get_lfm_in_vp9_thread_common(*CM.lf, mi_row, 0);

        mi_col = 0;
        while mi_col < CM.mi_cols {
            R := mi_row >> (((6 - 3)) & 31);
            C := mi_col >> (((6 - 3)) & 31);

            sync_read(LF_SYNC, R, C);

            vp9_setup_dst_planes(planes, FRAME_BUFFER, mi_row, mi_col);

            vp9_adjust_mask(CM, mi_row, mi_col, lfm);

            vp9_filter_block_plane_ss00(CM, *planes[0], mi_row, lfm);
            if 1 < NUM_PLANES {
                for plane: 1..NUM_PLANES - 1 {
                    if path == {
                        case cast,no_check(u32) LF_PATH_420;
                            vp9_filter_block_plane_ss11(CM, *planes[plane], mi_row, lfm);
                        case cast,no_check(u32) LF_PATH_444;
                            vp9_filter_block_plane_ss00(CM, *planes[plane], mi_row, lfm);
                        case cast,no_check(u32) LF_PATH_SLOW;
                            vp9_filter_block_plane_non420(CM, *planes[plane], MI + mi_col, mi_row, mi_col);
                    }
                }
            }

            sync_write(LF_SYNC, R, C, SB_COLS);
            mi_col += (cast(s32) 1) << (((6 - 3)) & 31);
            lfm += 1;
        }
        mi_row += NUM_ACTIVE_WORKERS * (cast(s32) 1) << (((6 - 3)) & 31);
    }
}

sync_write :: (LF_SYNC: *VP9_Lf_Sync, r: s32, c: s32, SB_COLS: s32) {
    NSYNC := LF_SYNC.sync_range;
    cur: s32 = ---;

    sig: s32 = 1;

    if c < SB_COLS - 1 {
        cur = c;
        if (((c % NSYNC)) != 0) {
            sig = 0;
        }
    } else {
        cur = SB_COLS + NSYNC;
    }

    if sig != 0 {
        mutex_lock(*(cast(*Pthread_Mutex_T) (LF_SYNC.mutex))[r]);

        LF_SYNC.cur_sb_col[r] = cur;

        pthread_cond_signal(*(cast(*Pthread_Cond_T) (LF_SYNC.cond))[r]);
        pthread_mutex_unlock(*(cast(*Pthread_Mutex_T) (LF_SYNC.mutex))[r]);
    }
}

mutex_lock :: (MUTEX: *Pthread_Mutex_T) {
    K_MAX_TRY_LOCKS: s32 = 4000;
    locked: s32 = 0;

    if 0 < K_MAX_TRY_LOCKS {
        for i: 0..K_MAX_TRY_LOCKS - 1 {
            if pthread_mutex_trylock(MUTEX) == 0 {
                locked = 1;
                break;
            }
        }
    }

    if locked == 0 {
        pthread_mutex_lock(MUTEX);
    }
}

sync_read :: (LF_SYNC: *VP9_Lf_Sync, r: s32, c: s32) {
    NSYNC := LF_SYNC.sync_range;

    if r != 0 && c & (NSYNC - 1) == 0 {
        MUTEX := *(cast(*Pthread_Mutex_T) (LF_SYNC.mutex))[r - 1];
        mutex_lock(MUTEX);

        while c > LF_SYNC.cur_sb_col[r - 1] - NSYNC {
            pthread_cond_wait(*(cast(*Pthread_Cond_T) (LF_SYNC.cond))[r - 1], MUTEX);
        }
        pthread_mutex_unlock(MUTEX);
    }
}

vp9_lpf_mt_init :: (lf_sync: *VP9_Lf_Sync, cm: *VP9_COMMON, frame_filter_level: s32, num_workers: s32) {
    SB_ROWS := mi_cols_aligned_to_sb_in_vp9_thread_common(cm.mi_rows) >> (((6 - 3)) & 31);

    if frame_filter_level == 0 {
        return;
    }

    if lf_sync.sync_range == 0 || SB_ROWS != lf_sync.rows || num_workers > lf_sync.num_workers {
        vp9_loop_filter_dealloc(lf_sync);
        vp9_loop_filter_alloc(lf_sync, cm, SB_ROWS, cm.width, num_workers);
    }

    fill_memory(lf_sync.cur_sb_col, -1, size_of(s32) * cast,no_check(u64) SB_ROWS);

    lf_sync.corrupted = 0;

    fill_memory(lf_sync.num_tiles_done, 0, size_of(s32) * cast,no_check(u64) SB_ROWS);
    cm.lf_row = 0;
}

vp9_loopfilter_rows :: (lf_data: *LF_Worker_Data, lf_sync: *VP9_Lf_Sync) {
    mi_row: s32 = ---;
    cm: *VP9_COMMON = lf_data.cm;

    while ((ifx true { assignment_0: s32 = cast,no_check(s32) (get_next_row(cm, lf_sync)); (mi_row) = assignment_0; assignment_0; }) != -1) && mi_row < cm.mi_rows {
        lf_data.start = mi_row;
        lf_data.stop = mi_row + (cast(s32) 1) << (((6 - 3)) & 31);

        thread_loop_filter_rows(
            lf_data.frame_buffer,
            lf_data.cm,
            lf_data.planes.data,
            lf_data.start,
            lf_data.stop,
            lf_data.y_only,
            lf_sync
        );
    }
}

get_next_row :: (cm: *VP9_COMMON, lf_sync: *VP9_Lf_Sync) -> s32 {
    return_val: s32 = -1;
    MAX_ROWS := cm.mi_rows;

    cur_row: s32 = ---;
    TILE_COLS := (cast(s32) 1) << ((cm.log2_tile_cols) & 31);

    pthread_mutex_lock(lf_sync.lf_mutex);
    if cm.lf_row < MAX_ROWS {
        cur_row = cm.lf_row >> (((6 - 3)) & 31);
        return_val = cm.lf_row;
        cm.lf_row += (cast(s32) 1) << (((6 - 3)) & 31);
        if cm.lf_row < MAX_ROWS {
            cur_row += 1;
        }
    }
    pthread_mutex_unlock(lf_sync.lf_mutex);

    if return_val == -1 {
        return return_val;
    }

    pthread_mutex_lock(*(cast(*Pthread_Mutex_T) (lf_sync.recon_done_mutex))[cur_row]);
    if lf_sync.num_tiles_done[cur_row] < TILE_COLS {
        pthread_cond_wait(
            *(cast(*Pthread_Cond_T) (lf_sync.recon_done_cond))[cur_row],
            *(cast(*Pthread_Mutex_T) (lf_sync.recon_done_mutex))[cur_row]
        );
    }
    pthread_mutex_unlock(*(cast(*Pthread_Mutex_T) (lf_sync.recon_done_mutex))[cur_row]);
    pthread_mutex_lock(lf_sync.lf_mutex);
    if lf_sync.corrupted != 0 {
        row := return_val >> (((6 - 3)) & 31);
        pthread_mutex_lock(*(cast(*Pthread_Mutex_T) (lf_sync.mutex))[row]);
        lf_sync.cur_sb_col[row] = 2147483647;
        pthread_cond_signal(*(cast(*Pthread_Cond_T) (lf_sync.cond))[row]);
        pthread_mutex_unlock(*(cast(*Pthread_Mutex_T) (lf_sync.mutex))[row]);
        return_val = -1;
    }
    pthread_mutex_unlock(lf_sync.lf_mutex);

    return return_val;
}

vp9_set_row :: (lf_sync: *VP9_Lf_Sync, num_tiles: s32, row: s32, is_last_row: s32, corrupted: s32) {
    pthread_mutex_lock(lf_sync.lf_mutex);
    lf_sync.corrupted |= corrupted;
    pthread_mutex_unlock(lf_sync.lf_mutex);
    pthread_mutex_lock(*(cast(*Pthread_Mutex_T) (lf_sync.recon_done_mutex))[row]);
    lf_sync.num_tiles_done[row] += 1;
    if num_tiles == lf_sync.num_tiles_done[row] {
        if is_last_row != 0 {
            pthread_cond_broadcast(*(cast(*Pthread_Cond_T) (lf_sync.recon_done_cond))[row]);
        } else {
            pthread_cond_signal(*(cast(*Pthread_Cond_T) (lf_sync.recon_done_cond))[row]);
        }
    }
    pthread_mutex_unlock(*(cast(*Pthread_Mutex_T) (lf_sync.recon_done_mutex))[row]);
}

vp9_loopfilter_job :: (lf_data: *LF_Worker_Data, lf_sync: *VP9_Lf_Sync) {
    thread_loop_filter_rows(
        lf_data.frame_buffer,
        lf_data.cm,
        lf_data.planes.data,
        lf_data.start,
        lf_data.stop,
        lf_data.y_only,
        lf_sync
    );
}

vp9_accumulate_frame_counts :: (accum: *FRAME_COUNTS, counts: *FRAME_COUNTS, is_dec: s32) {
    j: s32 = ---;
    k: s32 = ---;
    l: s32 = ---;
    m: s32 = ---;

    i: s32 = 0;
    while i < 4 {
        j = 0;
        while j < 9 + 1 {
            accum.y_mode[i][j] += counts.y_mode[i][j];
            j += 1;
        }
        i += 1;
    }

    i = 0;
    while i < 9 + 1 {
        j = 0;
        while j < 9 + 1 {
            accum.uv_mode[i][j] += counts.uv_mode[i][j];
            j += 1;
        }
        i += 1;
    }

    i = 0;
    while i < 4 * 4 {
        j = 0;
        while j < PARTITION_TYPES {
            accum.partition[i][j] += counts.partition[i][j];
            j += 1;
        }
        i += 1;
    }

    if is_dec != 0 {
        n: s32 = ---;
        i = 0;
        while i < cast,no_check(s32) (cast(TX_SIZE) 4) {
            j = 0;
            while j < PLANE_TYPES {
                k = 0;
                while k < 2 {
                    l = 0;
                    while l < 6 {
                        m = 0;
                        while m < 6 {
                            accum.eob_branch[i][j][k][l][m] += counts.eob_branch[i][j][k][l][m];
                            n = 0;
                            while n < 3 + 1 {
                                accum.coef[i][j][k][l][m][n] += counts.coef[i][j][k][l][m][n];
                                n += 1;
                            }
                            m += 1;
                        }
                        l += 1;
                    }
                    k += 1;
                }
                j += 1;
            }
            i += 1;
        }
    } else {
        i = 0;
        while i < cast,no_check(s32) (cast(TX_SIZE) 4) {
            j = 0;
            while j < PLANE_TYPES {
                k = 0;
                while k < 2 {
                    l = 0;
                    while l < 6 {
                        m = 0;
                        while m < 6 {
                            accum.eob_branch[i][j][k][l][m] += counts.eob_branch[i][j][k][l][m];
                            m += 1;
                        }
                        l += 1;
                    }
                    k += 1;
                }
                j += 1;
            }
            i += 1;
        }
    }

    i = 0;
    while i < 3 + 1 {
        j = 0;
        while j < 3 {
            accum.switchable_interp[i][j] += counts.switchable_interp[i][j];
            j += 1;
        }
        i += 1;
    }

    i = 0;
    while i < 7 {
        j = 0;
        while j < (cast,no_check(s32) ((1 + 13))) - 10 {
            accum.inter_mode[i][j] += counts.inter_mode[i][j];
            j += 1;
        }
        i += 1;
    }

    i = 0;
    while i < 4 {
        j = 0;
        while j < 2 {
            accum.intra_inter[i][j] += counts.intra_inter[i][j];
            j += 1;
        }
        i += 1;
    }

    i = 0;
    while i < 5 {
        j = 0;
        while j < 2 {
            accum.comp_inter[i][j] += counts.comp_inter[i][j];
            j += 1;
        }
        i += 1;
    }

    i = 0;
    while i < 5 {
        j = 0;
        while j < 2 {
            k = 0;
            while k < 2 {
                accum.single_ref[i][j][k] += counts.single_ref[i][j][k];
                k += 1;
            }
            j += 1;
        }
        i += 1;
    }

    i = 0;
    while i < 5 {
        j = 0;
        while j < 2 {
            accum.comp_ref[i][j] += counts.comp_ref[i][j];
            j += 1;
        }
        i += 1;
    }

    i = 0;
    while i < 2 {
        j = 0;
        while j < cast,no_check(s32) (cast(TX_SIZE) 4) {
            accum.tx.p32x32[i][j] += counts.tx.p32x32[i][j];
            j += 1;
        }

        j = 0;
        while j < (cast,no_check(s32) (cast(TX_SIZE) 4)) - 1 {
            accum.tx.p16x16[i][j] += counts.tx.p16x16[i][j];
            j += 1;
        }

        j = 0;
        while j < (cast,no_check(s32) (cast(TX_SIZE) 4)) - 2 {
            accum.tx.p8x8[i][j] += counts.tx.p8x8[i][j];
            j += 1;
        }
        i += 1;
    }

    i = 0;
    while i < cast,no_check(s32) (cast(TX_SIZE) 4) {
        accum.tx.tx_totals[i] += counts.tx.tx_totals[i];
        i += 1;
    }

    i = 0;
    while i < 3 {
        j = 0;
        while j < 2 {
            accum.skip[i][j] += counts.skip[i][j];
            j += 1;
        }
        i += 1;
    }

    i = 0;
    while i < 4 {
        accum.mv.joints[i] += counts.mv.joints[i];
        i += 1;
    }

    k = 0;
    while k < 2 {
        COMPS := accum.mv.comps.data + k;
        COMPS_T := counts.mv.comps.data + k;

        i = 0;
        while i < 2 {
            COMPS.sign[i] += COMPS_T.sign[i];
            COMPS.class0_hp[i] += COMPS_T.class0_hp[i];
            COMPS.hp[i] += COMPS_T.hp[i];
            i += 1;
        }

        i = 0;
        while i < 11 {
            COMPS.classes[i] += COMPS_T.classes[i];
            i += 1;
        }

        i = 0;
        while i < (cast(s32) 1) << 1 {
            COMPS.class0[i] += COMPS_T.class0[i];
            j = 0;
            while j < 4 {
                COMPS.class0_fp[i][j] += COMPS_T.class0_fp[i][j];
                j += 1;
            }
            i += 1;
        }

        i = 0;
        while i < (cast,no_check(s32) ((11 + 1))) - 2 {
            j = 0;
            while j < 2 {
                COMPS.bits[i][j] += COMPS_T.bits[i][j];
                j += 1;
            }
            i += 1;
        }

        i = 0;
        while i < 4 {
            COMPS.fp[i] += COMPS_T.fp[i];
            i += 1;
        }
        k += 1;
    }
}

init_frame_indexes_in_vp9_thread_common :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_thread_common :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_thread_common :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_thread_common :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_thread_common :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_thread_common :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_thread_common :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_thread_common :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

frame_is_intra_only_in_vp9_thread_common :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_thread_common :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_thread_common(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_thread_common :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_thread_common(cm.mi_cols);

        if get_plane_type_in_vp9_thread_common(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_thread_common(cm, xd);
}

get_partition_probs_in_vp9_thread_common :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_thread_common :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_thread_common :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_thread_common :: (
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

update_partition_context_in_vp9_thread_common :: (
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

partition_plane_context_in_vp9_thread_common :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

inter_predictor_in_vp9_thread_common :: (
    src: *u8,
    src_stride: s32,
    dst: *u8,
    dst_stride: s32,
    SUBPEL_X: s32,
    SUBPEL_Y: s32,
    sf: *Scale_Factors,
    w: s32,
    h: s32,
    ref: s32,
    kernel: *Interp_Kernel,
    xs: s32,
    ys: s32
) {
    (cast,no_check(#type (_: *u8, _: s64, _: *u8, _: s64, _: *Interp_Kernel, _: s32, _: s32, _: s32, _: s32, _: s32, _: s32)) (cast(*void) sf.predict[cast(s32) (SUBPEL_X != 0)][cast(s32) (SUBPEL_Y != 0)][ref]))(
        src,
        cast,no_check(s64) src_stride,
        dst,
        cast,no_check(s64) dst_stride,
        kernel,
        SUBPEL_X,
        xs,
        SUBPEL_Y,
        ys,
        w,
        h
    );
}

scaled_buffer_offset_in_vp9_thread_common :: (x_offset: s32, y_offset: s32, stride: s32, sf: *Scale_Factors) -> s64 {
    X := (ifx sf != null then sf.scale_value_x(x_offset, sf) else x_offset);
    Y := (ifx sf != null then sf.scale_value_y(y_offset, sf) else y_offset);
    return ((cast,no_check(s64) Y) * cast(s64) stride) + cast(s64) X;
}

setup_pred_plane_in_vp9_thread_common :: (
    dst: *Buf_2d,
    src: *u8,
    stride: s32,
    mi_row: s32,
    mi_col: s32,
    scale: *Scale_Factors,
    subsampling_x: s32,
    subsampling_y: s32
) {
    X := ((cast(s32) 1) << 3 * mi_col) >> ((subsampling_x) & 31);
    Y := ((cast(s32) 1) << 3 * mi_row) >> ((subsampling_y) & 31);
    dst.buf = src + scaled_buffer_offset_in_vp9_thread_common(X, Y, stride, scale);
    dst.stride = stride;
}

globals_initialization_state_for_vp9_thread_common: u32;
initialize_globals_for_vp9_thread_common :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_thread_common);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_thread_common, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_thread_common) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_vp9_thread_common =
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
    SUB_PEL_FILTERS_12_in_vp9_thread_common =
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
    atomic_store(*globals_initialization_state_for_vp9_thread_common, 2);
}

pthread_mutex_trylock :: (mutex: *Pthread_Mutex_T) -> s32 #foreign System_Library_libc_so_6;

pthread_cond_broadcast :: (cond: *Pthread_Cond_T) -> s32 #foreign System_Library_libc_so_6;

VP9_Lf_Sync :: VP9_Lf_Sync_Data_in_vp9_thread_common;

VP9_Lf_Sync_Data_in_vp9_thread_common :: struct {
    mutex: *Pthread_Mutex_T;
    cond: *Pthread_Cond_T;
    cur_sb_col: *s32;
    sync_range: s32;
    rows: s32;
    lfdata: *LF_Worker_Data;
    num_workers: s32;
    num_active_workers: s32;
    lf_mutex: *Pthread_Mutex_T;
    recon_done_mutex: *Pthread_Mutex_T;
    recon_done_cond: *Pthread_Cond_T;
    num_tiles_done: *s32;
    corrupted: s32;
}

