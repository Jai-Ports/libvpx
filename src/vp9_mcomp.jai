SUB_PEL_FILTERS_12_in_vp9_mcomp: [16] Interp_Kernel12 #align 256;

COUNT_TO_UPDATE_FACTOR_in_vp9_mcomp: [21] s32;

MODE_2_COUNTER_in_vp9_mcomp: [14] s32;

COUNTER_TO_CONTEXT_in_vp9_mcomp: [19] s32;

MV_REF_BLOCKS_in_vp9_mcomp: [13] [8] POSITION;

IDX_N_COLUMN_TO_SUBBLOCK_in_vp9_mcomp: [4] [2] s32;

FRAME_SCALE_FACTOR_in_vp9_mcomp: [2] s32;

RATE_THRESH_MULT_in_vp9_mcomp: [2] float64;

RCF_MULT_in_vp9_mcomp: [2] float64;

SEARCH_POS: [4] MV;

SEARCH_STEP_TABLE: [12] MV;

NEIGHBORS: [4] MV;

BIGDIA_CANDIDATES: [11] [8] MV;

BIGDIA_NUM_CANDIDATES: [11] s32;

NEIGHBORS_storage: [4] MV;

SEARCH_PARAM_TO_STEPS: [11] s32;

SQUARE_CANDIDATES: [11] [8] MV;

SQUARE_NUM_CANDIDATES: [11] s32;

SEARCH_PARAM_TO_STEPS_storage: [11] s32;

HEX_CANDIDATES: [11] [8] MV;

HEX_NUM_CANDIDATES: [11] s32;

K_VP9_REF_FLAG_LIST_in_vp9_mcomp: [4] s32;

clip_pixel_in_vp9_mcomp :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_mcomp :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_mcomp :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_mcomp :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_mcomp :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_mcomp(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_mcomp(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_mcomp(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_mcomp :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_vp9_mcomp :: (FILTER: *s16) -> s32 {
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

get_lsb_in_vp9_mcomp :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_mcomp :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_mcomp :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_mcomp(num_values) + 1 else 0;
}

vp9_diamond_search_sad_c :: (
    x: *MACROBLOCK,
    cfg: *Search_Site_Config_in_vp9_mcomp,
    ref_mv: *MV,
    start_mv_sad: u32,
    best_mv: *MV,
    search_param: s32,
    sad_per_bit: s32,
    num00: *s32,
    sad_fn_ptr: *Vp9_Sad_Fn_Ptr_T,
    center_mv: *MV
) -> s32 {
    j: s32 = ---;

    XD := *x.e_mbd;
    what := x.plane[0].src.buf;
    WHAT_STRIDE := x.plane[0].src.stride;

    IN_WHAT_STRIDE := XD.plane[0].pre[0].stride;

    bestsad: u32 = start_mv_sad;
    best_site: s32 = -1;
    last_site: s32 = -1;

    ss_mv := cfg.ss_mv.data + search_param * cfg.searches_per_step;
    ss_os := cfg.ss_os.data + search_param * cfg.searches_per_step;
    TOT_STEPS := cfg.total_steps - search_param;

    FCENTER_MV :=
        MV.{row = cast,no_check(s16) ((cast(s32) center_mv.row) >> 3), col = cast,no_check(s16) ((cast(s32) center_mv.col) >> 3)};
    ref_row := cast,no_check(s32) ref_mv.row;
    ref_col := cast,no_check(s32) ref_mv.col;
    num00.* = 0;
    best_mv.row = cast,no_check(s16) ref_row;
    best_mv.col = cast,no_check(s16) ref_col;

    in_what := XD.plane[0].pre[0].buf + ref_row * IN_WHAT_STRIDE + ref_col;
    best_address := in_what;

    i: s32 = 0;

    if 0 < TOT_STEPS {
        for step: 0..TOT_STEPS - 1 {
            all_in: s32 = 1;
            t: s32 = ---;

            all_in &= cast(s32) (((cast(s32) best_mv.row) + cast(s32) ss_mv[i].row) > x.mv_limits.row_min);
            all_in &= cast(s32) (((cast(s32) best_mv.row) + cast(s32) ss_mv[i + 1].row) < x.mv_limits.row_max);
            all_in &= cast(s32) (((cast(s32) best_mv.col) + cast(s32) ss_mv[i + 2].col) > x.mv_limits.col_min);
            all_in &= cast(s32) (((cast(s32) best_mv.col) + cast(s32) ss_mv[i + 3].col) < x.mv_limits.col_max);

            if all_in != 0 {
                sad_array: [4] u32 = ---;

                j = 0;
                while j < cfg.searches_per_step {
                    block_offset: [4] *u8 = ---;

                    t = 0;
                    while t < 4 {
                        block_offset[t] = ss_os[i + t] + best_address;
                        t += 1;
                    }

                    sad_fn_ptr.sdx4df(what, WHAT_STRIDE, block_offset.data, IN_WHAT_STRIDE, sad_array.data);

                    t = 0;
                    while t < 4 {
                        if sad_array[t] < bestsad {
                            THIS_MV :=
                                MV.{row = cast,no_check(s16) ((cast(s32) best_mv.row) +
                                    cast(s32) ss_mv[i].row), col = cast,no_check(s16) ((cast(s32) best_mv.col) + cast(s32) ss_mv[i].col)};
                            sad_array[t] +=
                                cast,no_check(u32) mvsad_err_cost_in_vp9_mcomp(
                                    x,
                                    *THIS_MV,
                                    *FCENTER_MV,
                                    sad_per_bit
                                );
                            if sad_array[t] < bestsad {
                                bestsad = sad_array[t];
                                best_site = i;
                            }
                        }
                        t += 1;
                        i += 1;
                    }
                    j += 4;
                }
            } else {
                j = 0;
                while j < cfg.searches_per_step {
                    THIS_MV :=
                        MV.{row = cast,no_check(s16) ((cast(s32) best_mv.row) +
                            cast(s32) ss_mv[i].row), col = cast,no_check(s16) ((cast(s32) best_mv.col) + cast(s32) ss_mv[i].col)};

                    if is_mv_in(*x.mv_limits, *THIS_MV) != 0 {
                        CHECK_HERE := ss_os[i] + best_address;
                        thissad := sad_fn_ptr.sdf(what, WHAT_STRIDE, CHECK_HERE, IN_WHAT_STRIDE);

                        if thissad < bestsad {
                            thissad +=
                                cast,no_check(u32) mvsad_err_cost_in_vp9_mcomp(
                                    x,
                                    *THIS_MV,
                                    *FCENTER_MV,
                                    sad_per_bit
                                );
                            if thissad < bestsad {
                                bestsad = thissad;
                                best_site = i;
                            }
                        }
                    }
                    i += 1;
                    j += 1;
                }
            }
            if best_site != last_site {
                best_mv.row = cast,no_check(s16) ((cast,no_check(s32) best_mv.row) + cast,no_check(s32) ss_mv[best_site].row);
                best_mv.col = cast,no_check(s16) ((cast,no_check(s32) best_mv.col) + cast,no_check(s32) ss_mv[best_site].col);
                best_address += ss_os[best_site];
                last_site = best_site;
            } else if best_address == in_what {
                num00.* += 1;
            }
        }
    }
    return cast,no_check(s32) bestsad;
}

mvsad_err_cost_in_vp9_mcomp :: (x: *MACROBLOCK, mv: *MV, ref: *MV, sad_per_bit: s32) -> s32 {
    diff: MV = ---;
    diff.row = cast,no_check(s16) ((cast(s32) mv.row) - cast(s32) ref.row);
    diff.col = cast,no_check(s16) ((cast(s32) mv.col) - cast(s32) ref.col);
    return cast,no_check(s32) ((((cast,no_check(u32) mv_cost_in_vp9_mcomp(*diff, x.nmvjointsadcost.data, x.nmvsadcost.data)) * cast,no_check(u32) sad_per_bit) + cast,no_check(u32) ((cast(s32) 1) << (((9 - 1)) & 31))) >> 9);
}

mv_cost_in_vp9_mcomp :: (mv: *MV, joint_cost: *s32, comp_cost: **s32) -> s32 {
    return joint_cost[vp9_get_mv_joint_in_vp9_mcomp(mv)] + comp_cost[0][mv.row] + comp_cost[1][mv.col];
}

vp9_get_mv_joint_in_vp9_mcomp :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

is_mv_in :: (mv_limits: *Mv_Limits, mv: *MV) -> s32 {
    if cast,no_check(s32) mv.col >= mv_limits.col_min &&
        cast,no_check(s32) mv.col <= mv_limits.col_max &&
        cast,no_check(s32) mv.row >= mv_limits.row_min &&
        cast,no_check(s32) mv.row <= mv_limits.row_max {
        return 1;
    }
    return 0;
}

get_prob_in_vp9_mcomp :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_mcomp :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_mcomp(n0, DEN);
}

weighted_prob_in_vp9_mcomp :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_mcomp :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_mcomp(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_mcomp(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_mcomp :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_mcomp[COUNT];
        PROB := get_prob_in_vp9_mcomp(ct[0], DEN);
        return weighted_prob_in_vp9_mcomp(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_band_translate_in_vp9_mcomp :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_mcomp :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_mcomp :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_mcomp(above_ec, left_ec);
}

is_zero_mv_in_vp9_mcomp :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_mcomp :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_mcomp :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_mcomp(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_mcomp(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_mcomp :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_mcomp :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_mcomp :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_is_valid_scale_in_vp9_mcomp :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_mcomp :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_mcomp(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_mcomp :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_mcomp :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_mcomp :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_mcomp :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_mcomp :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_mcomp :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_mcomp :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_mcomp :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_mcomp :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_mcomp :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_mcomp :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_mcomp(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_mcomp :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_mcomp(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_mcomp(MI, ib)];
}

get_uv_tx_size_in_vp9_mcomp :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_mcomp :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_mcomp :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_mcomp(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_mcomp :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_mcomp :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_mcomp :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_mcomp :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_mcomp :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_mcomp :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_mcomp :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_mcomp :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_mcomp :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_mcomp :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_mcomp :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_mcomp :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_mcomp :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_mcomp(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_mcomp :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_mcomp(cm.mi_cols);

        if get_plane_type_in_vp9_mcomp(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_mcomp(cm, xd);
}

get_partition_probs_in_vp9_mcomp :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_mcomp :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_mcomp :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_mcomp :: (
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

update_partition_context_in_vp9_mcomp :: (
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

partition_plane_context_in_vp9_mcomp :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

clamp_mv_ref_in_vp9_mcomp :: (mv: *MV, xd: *MACROBLOCKD) {
    clamp_mv_in_vp9_mcomp(
        mv,
        xd.mb_to_left_edge - (cast(s32) 16) << 3,
        xd.mb_to_right_edge + (cast(s32) 16) << 3,
        xd.mb_to_top_edge - (cast(s32) 16) << 3,
        xd.mb_to_bottom_edge + (cast(s32) 16) << 3
    );
}

get_sub_block_mv_in_vp9_mcomp :: (candidate: *MODE_INFO, which_mv: s32, search_col: s32, block_idx: s32) -> Int_Mv {
    return ifx block_idx >= 0 && candidate.sb_type < 3 then candidate.bmi[IDX_N_COLUMN_TO_SUBBLOCK_in_vp9_mcomp[block_idx][cast(s32) (search_col == 0)]].as_mv[which_mv] else candidate.mv[which_mv];
}

scale_mv_in_vp9_mcomp :: (mi: *MODE_INFO, ref: s32, THIS_REF_FRAME: MV_REFERENCE_FRAME, ref_sign_bias: *s32) -> Int_Mv {
    mv := mi.mv[ref];
    if ref_sign_bias[mi.ref_frame[ref]] != ref_sign_bias[THIS_REF_FRAME] {
        mv.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mv.as_mv.row) * -1);
        mv.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mv.as_mv.col) * -1);
    }
    return mv;
}

is_inside_in_vp9_mcomp :: (TILE: *Tile_Info, mi_col: s32, mi_row: s32, mi_rows: s32, mi_pos: *POSITION) -> s32 {
    if !(mi_row + mi_pos.row < 0 || mi_col + mi_pos.col < TILE.mi_col_start || mi_row + mi_pos.row >= mi_rows || mi_col + mi_pos.col >= TILE.mi_col_end) {
        return 1;
    }
    return 0;
}

clamp_mv2_in_vp9_mcomp :: (mv: *MV, xd: *MACROBLOCKD) {
    clamp_mv_in_vp9_mcomp(
        mv,
        xd.mb_to_left_edge - (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_right_edge + (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_top_edge - (cast,no_check(s32) ((160 - 4))) << 3,
        xd.mb_to_bottom_edge + (cast,no_check(s32) ((160 - 4))) << 3
    );
}

lower_mv_precision_in_vp9_mcomp :: (mv: *MV, allow_hp: s32) {
    USE_HP := cast(s32) (allow_hp != 0 && use_mv_hp_in_vp9_mcomp(mv) != 0);
    if USE_HP == 0 {
        if mv.row & 1 != 0 {
            c_transpiler_compound_add(*(mv.row), ((ifx mv.row > 0 then cast(s32) -1 else 1)), s32, s32);
        }
        if mv.col & 1 != 0 {
            c_transpiler_compound_add(*(mv.col), ((ifx mv.col > 0 then cast(s32) -1 else 1)), s32, s32);
        }
    }
}

inter_predictor_in_vp9_mcomp :: (
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

scaled_buffer_offset_in_vp9_mcomp :: (x_offset: s32, y_offset: s32, stride: s32, sf: *Scale_Factors) -> s64 {
    X := (ifx sf != null then sf.scale_value_x(x_offset, sf) else x_offset);
    Y := (ifx sf != null then sf.scale_value_y(y_offset, sf) else y_offset);
    return ((cast,no_check(s64) Y) * cast(s64) stride) + cast(s64) X;
}

setup_pred_plane_in_vp9_mcomp :: (
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
    dst.buf = src + scaled_buffer_offset_in_vp9_mcomp(X, Y, stride, scale);
    dst.stride = stride;
}

vp8_set_reference_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_copy_reference_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Ref_Frame_T);
}

vp8_set_postproc_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *Vp8_Postproc_Cfg_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp8_Postproc_Cfg_T);
}

vp9_get_reference_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *Vp9_Ref_Frame_T {
    return c_transpiler_va_arg(cast(*void) (args), *Vp9_Ref_Frame_T);
}

vp8_e_set_roi_map_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp8_e_set_activemap_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp8_e_set_scalemode_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *Scaling_Mode_T {
    return c_transpiler_va_arg(cast(*void) (args), *Scaling_Mode_T);
}

vp8_e_set_cpuused_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_enableautoaltref_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_noise_sensitivity_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_sharpness_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_static_threshold_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_token_partitions_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_get_last_quantizer_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_get_last_quantizer_64_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_arnr_maxframes_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_strength_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_arnr_type_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_tuning_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_cq_level_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_max_intra_bitrate_pct_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_frame_flags_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_max_inter_bitrate_pct_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_gf_cbr_boost_pct_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp8_e_set_temporal_layer_id_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_screen_content_mode_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_lossless_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_tile_columns_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_tile_rows_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_frame_parallel_decoding_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_aq_mode_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_frame_periodic_boost_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_noise_sensitivity_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_roi_map_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *Roi_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Roi_Map_T);
}

vp9_e_set_svc_parameters_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_svc_layer_id_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_set_tune_content_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_svc_layer_id_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *Svc_Layer_Id_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Layer_Id_T);
}

vp9_e_register_cx_callback_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *void {
    return c_transpiler_va_arg(cast(*void) (args), *void);
}

vp9_e_set_color_space_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_min_gf_interval_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_max_gf_interval_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_activemap_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *Active_Map_T {
    return c_transpiler_va_arg(cast(*void) (args), *Active_Map_T);
}

vp9_e_set_color_range_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_svc_ref_frame_config_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_render_size_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_target_level_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_row_mt_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_get_level_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_set_alt_ref_aq_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp8_e_set_gf_cbr_boost_pct_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_enable_motion_vector_unit_test_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_inter_layer_pred_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_frame_drop_layer_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *Svc_Frame_Drop_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Frame_Drop_T);
}

vp9_e_get_svc_ref_frame_config_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *Svc_Ref_Frame_Config_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Ref_Frame_Config_T);
}

vp9_e_set_svc_gf_temporal_ref_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_svc_spatial_layer_sync_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *Svc_Spatial_Layer_Sync_T {
    return c_transpiler_va_arg(cast(*void) (args), *Svc_Spatial_Layer_Sync_T);
}

vp9_e_set_tpl_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_postencode_drop_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> u32 {
    return c_transpiler_va_arg(cast(*void) (args), u32);
}

vp9_e_set_delta_q_uv_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_overshoot_maxq_cbr_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_disable_loopfilter_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_external_rate_control_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *Rc_Funcs_T {
    return c_transpiler_va_arg(cast(*void) (args), *Rc_Funcs_T);
}

vp9_e_set_rtc_external_ratectrl_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_get_loopfilter_level_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp9_e_get_last_quantizer_svc_layers_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> *s32 {
    return c_transpiler_va_arg(cast(*void) (args), *s32);
}

vp8_e_set_rtc_external_ratectrl_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_quantizer_one_pass_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_key_frame_filtering_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

vp9_e_set_validate_hbd_input_value_in_vp9_mcomp :: (args: *Va_List_Tag) -> s32 {
    return c_transpiler_va_arg(cast(*void) (args), s32);
}

gcd_in_vp9_mcomp :: (a: s64, b: s32) -> s32 {
    while b != 0 {
        r := cast,no_check(s32) (a % cast(s64) b);
        a = cast,no_check(s64) b;
        b = r;
    }

    return cast,no_check(s32) a;
}

reduce_ratio_in_vp9_mcomp :: (ratio: *Rational64_T) {
    DENOM := gcd_in_vp9_mcomp(ratio.num, ratio.den);
    ratio.num /= cast,no_check(s64) DENOM;
    ratio.den /= DENOM;
}

cyclic_refresh_segment_id_boosted_in_vp9_mcomp :: (segment_id: s32) -> s32 {
    if segment_id == 1 || segment_id == 2 {
        return 1;
    }
    return 0;
}

cyclic_refresh_segment_id_in_vp9_mcomp :: (segment_id: s32) -> s32 {
    if segment_id == 1 {
        return 1;
    } else if segment_id == 2 {
        return 2;
    } else {
        return 0;
    }
}

fps_init_first_pass_info_in_vp9_mcomp :: (
    first_pass_info: *FIRST_PASS_INFO,
    stats: *FIRSTPASS_STATS_in_vp9_cx_iface,
    num_frames: s32
) {
    first_pass_info.stats = stats;
    first_pass_info.num_frames = num_frames;
}

fps_get_num_frames_in_vp9_mcomp :: (first_pass_info: *FIRST_PASS_INFO) -> s32 {
    return first_pass_info.num_frames;
}

fps_get_frame_stats_in_vp9_mcomp :: (
    first_pass_info: *FIRST_PASS_INFO,
    show_idx: s32
) -> *FIRSTPASS_STATS_in_vp9_cx_iface {
    if show_idx < 0 || show_idx >= first_pass_info.num_frames {
        return null;
    }
    return *(cast(*FIRSTPASS_STATS_in_vp9_cx_iface) (first_pass_info.stats))[show_idx];
}

get_buf_from_mv_in_vp9_mcomp :: (buf: *Buf_2d, mv: *MV) -> *u8 {
    return *buf.buf[(cast(s32) mv.row) * buf.stride + cast(s32) mv.col];
}

vp9_init_dsmotion_compensation :: (cfg: *Search_Site_Config_in_vp9_mcomp, stride: s32) {
    ss_count: s32 = 0;

    len: s32 = (cast(s32) 1) << (((11 - 1)) & 31);
    while len > 0 {
        SS_MVS :=
            MV.[
                MV.{row = cast,no_check(s16) (-len), col = 0},
                MV.{row = cast,no_check(s16) len, col = 0},
                MV.{row = 0, col = cast,no_check(s16) (-len)},
                MV.{row = 0, col = cast,no_check(s16) len}
            ];

        i: s32 = 0;
        while i < 4 {
            cfg.ss_mv[ss_count] = SS_MVS[i];
            cfg.ss_os[ss_count] = cast,no_check(s64) ((cast(s32) SS_MVS[i].row) * stride + cast(s32) SS_MVS[i].col);
            i += 1;
            ss_count += 1;
        }
        len /= 2;
    }

    cfg.searches_per_step = 4;
    cfg.total_steps = ss_count / cfg.searches_per_step;
}

vp9_init3smotion_compensation :: (cfg: *Search_Site_Config_in_vp9_mcomp, stride: s32) {
    ss_count: s32 = 0;

    len: s32 = (cast(s32) 1) << (((11 - 1)) & 31);
    while len > 0 {
        SS_MVS :=
            MV.[
                MV.{row = cast,no_check(s16) (-len), col = 0},
                MV.{row = cast,no_check(s16) len, col = 0},
                MV.{row = 0, col = cast,no_check(s16) (-len)},
                MV.{row = 0, col = cast,no_check(s16) len},
                MV.{row = cast,no_check(s16) (-len), col = cast,no_check(s16) (-len)},
                MV.{row = cast,no_check(s16) (-len), col = cast,no_check(s16) len},
                MV.{row = cast,no_check(s16) len, col = cast,no_check(s16) (-len)},
                MV.{row = cast,no_check(s16) len, col = cast,no_check(s16) len}
            ];

        i: s32 = 0;
        while i < 8 {
            cfg.ss_mv[ss_count] = SS_MVS[i];
            cfg.ss_os[ss_count] = cast,no_check(s64) ((cast(s32) SS_MVS[i].row) * stride + cast(s32) SS_MVS[i].col);
            i += 1;
            ss_count += 1;
        }
        len /= 2;
    }

    cfg.searches_per_step = 8;
    cfg.total_steps = ss_count / cfg.searches_per_step;
}

vp9_set_mv_search_range :: (mv_limits: *Mv_Limits, mv: *MV) {
    col_min := (cast(s32) mv.col) >> 3 - ((cast(s32) 1) << (((11 - 1)) & 31) - 1) + cast(s32) (mv.col & 7 != 0);
    row_min := (cast(s32) mv.row) >> 3 - ((cast(s32) 1) << (((11 - 1)) & 31) - 1) + cast(s32) (mv.row & 7 != 0);
    col_max := (cast(s32) mv.col) >> 3 + ((cast(s32) 1) << (((11 - 1)) & 31) - 1);
    row_max := (cast(s32) mv.row) >> 3 + ((cast(s32) 1) << (((11 - 1)) & 31) - 1);

    col_min = ifx col_min > -((cast(s32) 1) << 14) >> 3 + 1 then col_min else -((cast(s32) 1) << 14) >> 3 + 1;
    row_min = ifx row_min > -((cast(s32) 1) << 14) >> 3 + 1 then row_min else -((cast(s32) 1) << 14) >> 3 + 1;
    col_max = ifx col_max < ((cast(s32) 1) << 14 - 1) >> 3 - 1 then col_max else ((cast(s32) 1) << 14 - 1) >> 3 - 1;
    row_max = ifx row_max < ((cast(s32) 1) << 14 - 1) >> 3 - 1 then row_max else ((cast(s32) 1) << 14 - 1) >> 3 - 1;

    if mv_limits.col_min < col_min {
        mv_limits.col_min = col_min;
    }
    if mv_limits.col_max > col_max {
        mv_limits.col_max = col_max;
    }
    if mv_limits.row_min < row_min {
        mv_limits.row_min = row_min;
    }
    if mv_limits.row_max > row_max {
        mv_limits.row_max = row_max;
    }
}

vp9_mv_bit_cost :: (mv: *MV, ref: *MV, mvjcost: *s32, mvcost: **s32, weight: s32) -> s32 {
    DIFF :=
        MV.{row = cast,no_check(s16) ((cast(s32) mv.row) -
            cast(s32) ref.row), col = cast,no_check(s16) ((cast(s32) mv.col) - cast(s32) ref.col)};
    return (mv_cost_in_vp9_mcomp(*DIFF, mvjcost, mvcost) * weight + (cast(s32) 1) << (((7 - 1)) & 31)) >> 7;
}

vp9_get_mvpred_var :: (
    x: *MACROBLOCK,
    best_mv: *MV,
    center_mv: *MV,
    vfp: *Vp9_Variance_Fn_Ptr_T,
    use_mvcost: s32
) -> s32 {
    XD := *x.e_mbd;
    WHAT := *x.plane[0].src;
    IN_WHAT := XD.plane[0].pre.data + 0;
    MV_ :=
        MV.{row = cast,no_check(s16) ((cast(s32) best_mv.row) *
            8), col = cast,no_check(s16) ((cast(s32) best_mv.col) * 8)};
    unused: u32 = ---;

    return cast,no_check(s32) (vfp.vf(WHAT.buf, WHAT.stride, get_buf_from_mv_in_vp9_mcomp(IN_WHAT, best_mv), IN_WHAT.stride, *unused) + cast,no_check(u32) ((ifx use_mvcost != 0 then mv_err_cost_in_vp9_mcomp(*MV_, center_mv, x.nmvjointcost.data, x.mvcost, x.errorperbit) else 0)));
}

mv_err_cost_in_vp9_mcomp :: (mv: *MV, ref: *MV, mvjcost: *s32, mvcost: **s32, error_per_bit: s32) -> s32 {
    if mvcost != null {
        DIFF :=
            MV.{row = cast,no_check(s16) ((cast(s32) mv.row) -
                cast(s32) ref.row), col = cast,no_check(s16) ((cast(s32) mv.col) - cast(s32) ref.col)};
        return cast,no_check(s32) (((cast,no_check(u64) ((cast,no_check(s64) mv_cost_in_vp9_mcomp(*DIFF, mvjcost, mvcost)) * cast(s64) error_per_bit)) + (cast(u64) 1) << ((((cast,no_check(s32) ((7 + 9))) - 6 + 4 - 1)) & 63)) >> ((((cast,no_check(s32) ((7 + 9))) - 6 + 4)) & 63));
    }
    return 0;
}

vp9_get_mvpred_av_var :: (
    x: *MACROBLOCK,
    best_mv: *MV,
    center_mv: *MV,
    second_pred: *u8,
    vfp: *Vp9_Variance_Fn_Ptr_T,
    use_mvcost: s32
) -> s32 {
    XD := *x.e_mbd;
    WHAT := *x.plane[0].src;
    IN_WHAT := XD.plane[0].pre.data + 0;
    MV_ :=
        MV.{row = cast,no_check(s16) ((cast(s32) best_mv.row) *
            8), col = cast,no_check(s16) ((cast(s32) best_mv.col) * 8)};
    unused: u32 = ---;

    return cast,no_check(s32) (vfp.svaf(
        get_buf_from_mv_in_vp9_mcomp(IN_WHAT, best_mv),
        IN_WHAT.stride,
        0,
        0,
        WHAT.buf,
        WHAT.stride,
        *unused,
        second_pred
    ) + cast,no_check(u32) ((ifx use_mvcost != 0 then mv_err_cost_in_vp9_mcomp(*MV_, center_mv, x.nmvjointcost.data, x.mvcost, x.errorperbit) else 0)));
}

vp9_init_search_range :: (size: s32) -> s32 {
    sr: s32 = 0;

    size = ifx 16 > size then 16 else size;

    while size << ((sr) & 31) < (cast(s32) 1) << (((11 - 1)) & 31) - 1 {
        sr += 1;
    }

    sr = ifx sr < 11 - 2 then sr else cast,no_check(s32) ((11 - 2));
    return sr;
}

vp9_refining_search_sad :: (
    x: *MACROBLOCK,
    ref_mv: *MV,
    error_per_bit: s32,
    search_range: s32,
    sad_fn_ptr: *Vp9_Sad_Fn_Ptr_T,
    center_mv: *MV
) -> s32 {
    XD := *x.e_mbd;
    NEIGHBORS :=
        MV.[
            MV.{row = -1, col = 0},
            MV.{row = 0, col = -1},
            MV.{row = 0, col = 1},
            MV.{row = 1, col = 0}
        ];
    WHAT := *x.plane[0].src;
    IN_WHAT := XD.plane[0].pre.data + 0;
    FCENTER_MV :=
        MV.{row = cast,no_check(s16) ((cast(s32) center_mv.row) >> 3), col = cast,no_check(s16) ((cast(s32) center_mv.col) >> 3)};
    best_address := get_buf_from_mv_in_vp9_mcomp(IN_WHAT, ref_mv);
    best_sad :=
        sad_fn_ptr.sdf(WHAT.buf, WHAT.stride, best_address, IN_WHAT.stride) +
            cast,no_check(u32) mvsad_err_cost_in_vp9_mcomp(x, ref_mv, *FCENTER_MV, error_per_bit);
    j: s32 = ---;

    if 0 < search_range {
        for i: 0..search_range - 1 {
            best_site: s32 = -1;
            ALL_IN :=
                (((cast(s32) ((cast(s32) ref_mv.row) - 1 > x.mv_limits.row_min)) & cast(s32) ((cast(s32) ref_mv.row) + 1 < x.mv_limits.row_max)) & cast(s32) ((cast(s32) ref_mv.col) - 1 > x.mv_limits.col_min)) & cast(s32) ((cast(s32) ref_mv.col) +
                    1 < x.mv_limits.col_max);

            if ALL_IN != 0 {
                sads: [4] u32 = ---;
                POSITIONS :=
                    *u8.[ best_address - IN_WHAT.stride, best_address -
                        1, best_address + 1, best_address + IN_WHAT.stride ];

                sad_fn_ptr.sdx4df(WHAT.buf, WHAT.stride, POSITIONS.data, IN_WHAT.stride, sads.data);

                j = 0;
                while j < 4 {
                    if sads[j] < best_sad {
                        MV_ :=
                            MV.{row = cast,no_check(s16) ((cast(s32) ref_mv.row) +
                                cast(s32) NEIGHBORS[j].row), col = cast,no_check(s16) ((cast(s32) ref_mv.col) + cast(s32) NEIGHBORS[j].col)};
                        sads[j] +=
                            cast,no_check(u32) mvsad_err_cost_in_vp9_mcomp(
                                x,
                                *MV_,
                                *FCENTER_MV,
                                error_per_bit
                            );
                        if sads[j] < best_sad {
                            best_sad = sads[j];
                            best_site = j;
                        }
                    }
                    j += 1;
                }
            } else {
                j = 0;
                while j < 4 {
                    MV_ :=
                        MV.{row = cast,no_check(s16) ((cast(s32) ref_mv.row) +
                            cast(s32) NEIGHBORS[j].row), col = cast,no_check(s16) ((cast(s32) ref_mv.col) + cast(s32) NEIGHBORS[j].col)};

                    if is_mv_in(*x.mv_limits, *MV_) != 0 {
                        sad :=
                            sad_fn_ptr.sdf(
                                WHAT.buf,
                                WHAT.stride,
                                get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *MV_),
                                IN_WHAT.stride
                            );
                        if sad < best_sad {
                            sad +=
                                cast,no_check(u32) mvsad_err_cost_in_vp9_mcomp(
                                    x,
                                    *MV_,
                                    *FCENTER_MV,
                                    error_per_bit
                                );
                            if sad < best_sad {
                                best_sad = sad;
                                best_site = j;
                            }
                        }
                    }
                    j += 1;
                }
            }

            if best_site == -1 {
                break;
            } else {
                ref_mv.row = cast,no_check(s16) ((cast,no_check(s32) ref_mv.row) + cast,no_check(s32) NEIGHBORS[best_site].row);
                ref_mv.col = cast,no_check(s16) ((cast,no_check(s32) ref_mv.col) + cast,no_check(s32) NEIGHBORS[best_site].col);
                best_address = get_buf_from_mv_in_vp9_mcomp(IN_WHAT, ref_mv);
            }
        }
    }

    return cast,no_check(s32) best_sad;
}

vp9_int_pro_motion_estimation :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    x: *MACROBLOCK,
    bsize: BLOCK_SIZE,
    mi_row: s32,
    mi_col: s32,
    ref_mv: *MV
) -> u32 {
    xd := *x.e_mbd;
    mi := xd.mi[0];
    backup_yv12: [3] Buf_2d;
    hbuf: [128] s16 = --- #align 16;
    vbuf: [128] s16 = --- #align 16;
    src_hbuf: [64] s16 = --- #align 16;
    src_vbuf: [64] s16 = --- #align 16;

    BW := (cast(s32) 4) << ((B_WIDTH_LOG2_LOOKUP[bsize]) & 31);
    BH := (cast(s32) 4) << ((B_HEIGHT_LOG2_LOOKUP[bsize]) & 31);
    SEARCH_WIDTH := BW << 1;
    SEARCH_HEIGHT := BH << 1;
    SRC_STRIDE := x.plane[0].src.stride;
    src_buf: *u8 = ---;
    tmp_mv := *xd.mi[0].mv[0].as_mv;
    this_sad: [4] u32 = ---;
    this_mv: MV = ---;
    NORM_FACTOR := 3 + BW >> 5;
    scaled_ref_frame := vp9_get_scaled_ref_frame(cpi, cast,no_check(s32) mi.ref_frame[0]);
    subpel_mv_limits: Mv_Limits = ---;

    if scaled_ref_frame != null {
        for i: 0..cast(s32) 3 - 1 {
            backup_yv12[i] = xd.plane[i].pre[0];
        }
        vp9_setup_pre_planes(xd, 0, scaled_ref_frame, mi_row, mi_col, null);
    }
    REF_STRIDE := xd.plane[0].pre[0].stride;

    ref_buf := xd.plane[0].pre[0].buf - BW >> 1;
    idx: s32 = 0;
    while idx < SEARCH_WIDTH {
        int_pro_row_c(hbuf.data + idx, ref_buf, REF_STRIDE, BH);
        ref_buf += 16;
        idx += 16;
    }

    ref_buf = xd.plane[0].pre[0].buf - BH >> 1 * REF_STRIDE;
    idx = 0;
    while idx < SEARCH_HEIGHT {
        vbuf[idx] = cast,no_check(s16) ((cast(s32) int_pro_col_c(ref_buf, BW)) >> ((NORM_FACTOR) & 31));
        ref_buf += REF_STRIDE;
        idx += 1;
    }

    idx = 0;
    while idx < BW {
        src_buf = x.plane[0].src.buf + idx;
        int_pro_row_c(src_hbuf.data + idx, src_buf, SRC_STRIDE, BH);
        idx += 16;
    }

    src_buf = x.plane[0].src.buf;
    idx = 0;
    while idx < BH {
        src_vbuf[idx] = cast,no_check(s16) ((cast(s32) int_pro_col_c(src_buf, BW)) >> ((NORM_FACTOR) & 31));
        src_buf += SRC_STRIDE;
        idx += 1;
    }

    tmp_mv.col =
        cast,no_check(s16) vector_match(
            hbuf.data,
            src_hbuf.data,
            cast,no_check(s32) B_WIDTH_LOG2_LOOKUP[bsize]
        );
    tmp_mv.row =
        cast,no_check(s16) vector_match(
            vbuf.data,
            src_vbuf.data,
            cast,no_check(s32) B_HEIGHT_LOG2_LOOKUP[bsize]
        );

    this_mv = tmp_mv.*;
    src_buf = x.plane[0].src.buf;
    ref_buf = xd.plane[0].pre[0].buf + (cast(s32) this_mv.row) * REF_STRIDE + cast,no_check(s32) this_mv.col;
    best_sad := cpi.fn_ptr[bsize].sdf(src_buf, SRC_STRIDE, ref_buf, REF_STRIDE);

    {
        POS_ := *u8.[ ref_buf - REF_STRIDE, ref_buf - 1, ref_buf + 1, ref_buf + REF_STRIDE ];

        cpi.fn_ptr[bsize].sdx4df(src_buf, SRC_STRIDE, POS_.data, REF_STRIDE, this_sad.data);
    }

    idx = 0;
    while idx < 4 {
        if this_sad[idx] < best_sad {
            best_sad = this_sad[idx];
            tmp_mv.row = cast,no_check(s16) ((cast(s32) SEARCH_POS[idx].row) + cast(s32) this_mv.row);
            tmp_mv.col = cast,no_check(s16) ((cast(s32) SEARCH_POS[idx].col) + cast(s32) this_mv.col);
        }
        idx += 1;
    }

    if this_sad[0] < this_sad[3] {
        this_mv.row = cast,no_check(s16) ((cast,no_check(s32) this_mv.row) - 1);
    } else {
        this_mv.row = cast,no_check(s16) ((cast,no_check(s32) this_mv.row) + 1);
    }

    if this_sad[1] < this_sad[2] {
        this_mv.col = cast,no_check(s16) ((cast,no_check(s32) this_mv.col) - 1);
    } else {
        this_mv.col = cast,no_check(s16) ((cast,no_check(s32) this_mv.col) + 1);
    }

    ref_buf = xd.plane[0].pre[0].buf + (cast(s32) this_mv.row) * REF_STRIDE + cast,no_check(s32) this_mv.col;

    tmp_sad := cpi.fn_ptr[bsize].sdf(src_buf, SRC_STRIDE, ref_buf, REF_STRIDE);
    if best_sad > tmp_sad {
        tmp_mv.* = this_mv;
        best_sad = tmp_sad;
    }

    tmp_mv.row = cast,no_check(s16) ((cast,no_check(s32) tmp_mv.row) * 8);
    tmp_mv.col = cast,no_check(s16) ((cast,no_check(s32) tmp_mv.col) * 8);

    vp9_set_subpel_mv_search_range(*subpel_mv_limits, *x.mv_limits, ref_mv);
    clamp_mv_in_vp9_mcomp(
        tmp_mv,
        subpel_mv_limits.col_min,
        subpel_mv_limits.col_max,
        subpel_mv_limits.row_min,
        subpel_mv_limits.row_max
    );

    if scaled_ref_frame != null {
        for i: 0..cast(s32) 3 - 1 {
            xd.plane[i].pre[0] = backup_yv12[i];
        }
    }

    return best_sad;
}

vp9_set_subpel_mv_search_range :: (subpel_mv_limits: *Mv_Limits, umv_window_limits: *Mv_Limits, ref_mv: *MV) {
    subpel_mv_limits.col_min =
        ifx umv_window_limits.col_min * 8 > (cast(s32) ref_mv.col) -
            ((cast(s32) 1) << (((11 - 1)) & 31) - 1) * 8 then umv_window_limits.col_min * 8 else (cast(s32) ref_mv.col) - ((cast(s32) 1) << (((11 - 1)) & 31) - 1) * 8;
    subpel_mv_limits.col_max =
        ifx umv_window_limits.col_max * 8 < (cast(s32) ref_mv.col) +
            ((cast(s32) 1) << (((11 - 1)) & 31) - 1) * 8 then umv_window_limits.col_max * 8 else (cast(s32) ref_mv.col) + ((cast(s32) 1) << (((11 - 1)) & 31) - 1) * 8;
    subpel_mv_limits.row_min =
        ifx umv_window_limits.row_min * 8 > (cast(s32) ref_mv.row) -
            ((cast(s32) 1) << (((11 - 1)) & 31) - 1) * 8 then umv_window_limits.row_min * 8 else (cast(s32) ref_mv.row) - ((cast(s32) 1) << (((11 - 1)) & 31) - 1) * 8;
    subpel_mv_limits.row_max =
        ifx umv_window_limits.row_max * 8 < (cast(s32) ref_mv.row) +
            ((cast(s32) 1) << (((11 - 1)) & 31) - 1) * 8 then umv_window_limits.row_max * 8 else (cast(s32) ref_mv.row) + ((cast(s32) 1) << (((11 - 1)) & 31) - 1) * 8;

    subpel_mv_limits.col_min =
        ifx -((cast(s32) 1) << 14) + 1 > subpel_mv_limits.col_min then -((cast(s32) 1) << 14) +
            1 else subpel_mv_limits.col_min;
    subpel_mv_limits.col_max =
        ifx (cast(s32) 1) << 14 - 1 - 1 < subpel_mv_limits.col_max then (cast(s32) 1) << 14 -
            1 - 1 else subpel_mv_limits.col_max;
    subpel_mv_limits.row_min =
        ifx -((cast(s32) 1) << 14) + 1 > subpel_mv_limits.row_min then -((cast(s32) 1) << 14) +
            1 else subpel_mv_limits.row_min;
    subpel_mv_limits.row_max =
        ifx (cast(s32) 1) << 14 - 1 - 1 < subpel_mv_limits.row_max then (cast(s32) 1) << 14 -
            1 - 1 else subpel_mv_limits.row_max;
}

vector_match :: (ref: *s16, src: *s16, bwl: s32) -> s32 {
    best_sad: s32 = 2147483647;
    this_sad: s32 = ---;
    offset: s32 = 0;
    bw := (cast(s32) 4) << ((bwl) & 31);
    d: s32 = 0;
    while d <= bw {
        this_sad = vector_var_c(*ref[d], src, bwl);
        if this_sad < best_sad {
            best_sad = this_sad;
            offset = d;
        }
        d += 16;
    }
    center := offset;

    d = -8;
    while d <= 8 {
        this_pos := offset + d;

        if this_pos < 0 || this_pos > bw {
            d += 16;
            continue;
        }
        this_sad = vector_var_c(*ref[this_pos], src, bwl);
        if this_sad < best_sad {
            best_sad = this_sad;
            center = this_pos;
        }
        d += 16;
    }
    offset = center;

    d = -4;
    while d <= 4 {
        this_pos := offset + d;

        if this_pos < 0 || this_pos > bw {
            d += 8;
            continue;
        }
        this_sad = vector_var_c(*ref[this_pos], src, bwl);
        if this_sad < best_sad {
            best_sad = this_sad;
            center = this_pos;
        }
        d += 8;
    }
    offset = center;

    d = -2;
    while d <= 2 {
        this_pos := offset + d;

        if this_pos < 0 || this_pos > bw {
            d += 4;
            continue;
        }
        this_sad = vector_var_c(*ref[this_pos], src, bwl);
        if this_sad < best_sad {
            best_sad = this_sad;
            center = this_pos;
        }
        d += 4;
    }
    offset = center;

    d = -1;
    while d <= 1 {
        this_pos := offset + d;

        if this_pos < 0 || this_pos > bw {
            d += 2;
            continue;
        }
        this_sad = vector_var_c(*ref[this_pos], src, bwl);
        if this_sad < best_sad {
            best_sad = this_sad;
            center = this_pos;
        }
        d += 2;
    }

    return center - bw >> 1;
}

vp9_find_best_sub_pixel_tree :: (
    x: *MACROBLOCK,
    bestmv: *MV,
    ref_mv: *MV,
    allow_hp: s32,
    error_per_bit: s32,
    vfp: *Vp9_Variance_Fn_Ptr_T,
    forced_stop: s32,
    iters_per_step: s32,
    cost_list: *s32,
    mvjcost: *s32,
    mvcost: **s32,
    distortion: *u32,
    sse1: *u32,
    second_pred: *u8,
    w: s32,
    h: s32,
    use_accurate_subpel_search: s32
) -> u32 {
    Z := x.plane[0].src.buf;
    SRC_ADDRESS := Z;
    SRC_STRIDE := x.plane[0].src.stride;
    xd := *x.e_mbd;
    besterr: u32 = U32_MAX;
    sse: u32 = ---;
    thismse: s32 = ---;
    Y_STRIDE := xd.plane[0].pre[0].stride;
    OFFSET := (cast(s32) bestmv.row) * Y_STRIDE + cast(s32) bestmv.col;
    Y := xd.plane[0].pre[0].buf;

    rr := cast,no_check(s32) ref_mv.row;
    rc := cast,no_check(s32) ref_mv.col;
    br := (cast(s32) bestmv.row) * 8;
    bc := (cast(s32) bestmv.col) * 8;
    hstep: s32 = 4;
    round := 3 - forced_stop;

    tr := br;
    tc := bc;
    search_step := SEARCH_STEP_TABLE.data;
    idx: s32 = ---;
    best_idx: s32 = -1;
    cost_array: [5] u32 = ---;

    subpel_mv_limits: Mv_Limits = ---;

    kernel :=
        (ifx use_accurate_subpel_search > 0 then (ifx use_accurate_subpel_search == USE_4_TAPS then vp9_filter_kernels[4] else (ifx use_accurate_subpel_search == USE_8_TAPS then vp9_filter_kernels[0] else vp9_filter_kernels[2])) else vp9_filter_kernels[3]);

    vp9_set_subpel_mv_search_range(*subpel_mv_limits, *x.mv_limits, ref_mv);
    minc := subpel_mv_limits.col_min;
    maxc := subpel_mv_limits.col_max;
    minr := subpel_mv_limits.row_min;
    maxr := subpel_mv_limits.row_max;

    if !(allow_hp != 0 && use_mv_hp_in_vp9_mcomp(ref_mv) != 0) {
        if round == 3 {
            round = 2;
        }
    }

    bestmv.row = cast,no_check(s16) ((cast,no_check(s32) bestmv.row) * 8);
    bestmv.col = cast,no_check(s16) ((cast,no_check(s32) bestmv.col) * 8);

    besterr =
        setup_center_error(
            xd,
            bestmv,
            ref_mv,
            error_per_bit,
            vfp,
            Z,
            SRC_STRIDE,
            Y,
            Y_STRIDE,
            second_pred,
            w,
            h,
            OFFSET,
            mvjcost,
            mvcost,
            sse1,
            distortion
        );

    if 0 < round {
        for iter: 0..round - 1 {
            idx = 0;
            while idx < 4 {
                tr = br + cast(s32) search_step[idx].row;
                tc = bc + cast(s32) search_step[idx].col;
                if tc >= minc && tc <= maxc && tr >= minr && tr <= maxr {
                    this_mv: MV = ---;
                    this_mv.row = cast,no_check(s16) tr;
                    this_mv.col = cast,no_check(s16) tc;

                    if use_accurate_subpel_search != 0 {
                        thismse =
                            accurate_sub_pel_search(
                                xd,
                                *this_mv,
                                x.me_sf,
                                kernel,
                                vfp,
                                SRC_ADDRESS,
                                SRC_STRIDE,
                                Y,
                                Y_STRIDE,
                                second_pred,
                                w,
                                h,
                                *sse
                            );
                    } else {
                        PRE_ADDRESS := Y + tr >> 3 * Y_STRIDE + tc >> 3;
                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    PRE_ADDRESS,
                                    Y_STRIDE,
                                    sp(tc),
                                    sp(tr),
                                    SRC_ADDRESS,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    PRE_ADDRESS,
                                    Y_STRIDE,
                                    sp(tc),
                                    sp(tr),
                                    SRC_ADDRESS,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }
                    }

                    cost_array[idx] =
                        cast,no_check(u32) (thismse + mv_err_cost_in_vp9_mcomp(
                            *this_mv,
                            ref_mv,
                            mvjcost,
                            mvcost,
                            error_per_bit
                        ));

                    if cost_array[idx] < besterr {
                        best_idx = idx;
                        besterr = cost_array[idx];
                        distortion.* = cast,no_check(u32) thismse;
                        sse1.* = sse;
                    }
                } else {
                    cost_array[idx] = U32_MAX;
                }
                idx += 1;
            }

            kc := (ifx cost_array[0] <= cost_array[1] then -hstep else hstep);
            kr := (ifx cost_array[2] <= cost_array[3] then -hstep else hstep);

            tc = bc + kc;
            tr = br + kr;
            if tc >= minc && tc <= maxc && tr >= minr && tr <= maxr {
                this_mv := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) tc};
                if use_accurate_subpel_search != 0 {
                    thismse =
                        accurate_sub_pel_search(
                            xd,
                            *this_mv,
                            x.me_sf,
                            kernel,
                            vfp,
                            SRC_ADDRESS,
                            SRC_STRIDE,
                            Y,
                            Y_STRIDE,
                            second_pred,
                            w,
                            h,
                            *sse
                        );
                } else {
                    PRE_ADDRESS := Y + tr >> 3 * Y_STRIDE + tc >> 3;
                    if second_pred == null {
                        thismse =
                            cast,no_check(s32) vfp.svf(
                                PRE_ADDRESS,
                                Y_STRIDE,
                                sp(tc),
                                sp(tr),
                                SRC_ADDRESS,
                                SRC_STRIDE,
                                *sse
                            );
                    } else {
                        thismse =
                            cast,no_check(s32) vfp.svaf(
                                PRE_ADDRESS,
                                Y_STRIDE,
                                sp(tc),
                                sp(tr),
                                SRC_ADDRESS,
                                SRC_STRIDE,
                                *sse,
                                second_pred
                            );
                    }
                }

                cost_array[4] =
                    cast,no_check(u32) (thismse + mv_err_cost_in_vp9_mcomp(
                        *this_mv,
                        ref_mv,
                        mvjcost,
                        mvcost,
                        error_per_bit
                    ));

                if cost_array[4] < besterr {
                    best_idx = 4;
                    besterr = cost_array[4];
                    distortion.* = cast,no_check(u32) thismse;
                    sse1.* = sse;
                }
            } else {
                cost_array[idx] = U32_MAX;
            }

            if best_idx < 4 && best_idx >= 0 {
                br += cast,no_check(s32) search_step[best_idx].row;
                bc += cast,no_check(s32) search_step[best_idx].col;
            } else if best_idx == 4 {
                br = tr;
                bc = tc;
            }

            if iters_per_step > 0 && best_idx != -1 {
                second: u32 = ---;
                BR0 := br;
                BC0 := bc;

                if tr == br && tc != bc {
                    kc = bc - tc;
                    if iters_per_step == 1 {
                        if use_accurate_subpel_search != 0 {
                            if BC0 + kc >= minc && BC0 + kc <= maxc && BR0 >= minr && BR0 <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) BR0, col = cast,no_check(s16) (BC0 + kc)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                thismse =
                                    accurate_sub_pel_search(
                                        xd,
                                        *CB_MV,
                                        x.me_sf,
                                        kernel,
                                        vfp,
                                        Z,
                                        SRC_STRIDE,
                                        Y,
                                        Y_STRIDE,
                                        second_pred,
                                        w,
                                        h,
                                        *sse
                                    );

                                if (ifx true { assignment_0: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_0; assignment_0; }) < besterr {
                                    besterr = second;

                                    br = BR0;

                                    bc = BC0 + kc;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        } else {
                            if BC0 + kc >= minc && BC0 + kc <= maxc && BR0 >= minr && BR0 <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) BR0, col = cast,no_check(s16) (BC0 + kc)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, BR0, BC0 + kc),
                                            Y_STRIDE,
                                            sp(BC0 + kc),
                                            sp(BR0),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, BR0, BC0 + kc),
                                            Y_STRIDE,
                                            sp(BC0 + kc),
                                            sp(BR0),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_1: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_1; assignment_1; }) < besterr {
                                    besterr = second;

                                    br = BR0;

                                    bc = BC0 + kc;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        }
                    }
                } else if tr != br && tc == bc {
                    kr = br - tr;
                    if iters_per_step == 1 {
                        if use_accurate_subpel_search != 0 {
                            if BC0 >= minc && BC0 <= maxc && BR0 + kr >= minr && BR0 + kr <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (BR0 + kr), col = cast,no_check(s16) BC0};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                thismse =
                                    accurate_sub_pel_search(
                                        xd,
                                        *CB_MV,
                                        x.me_sf,
                                        kernel,
                                        vfp,
                                        Z,
                                        SRC_STRIDE,
                                        Y,
                                        Y_STRIDE,
                                        second_pred,
                                        w,
                                        h,
                                        *sse
                                    );

                                if (ifx true { assignment_2: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_2; assignment_2; }) < besterr {
                                    besterr = second;

                                    br = BR0 + kr;

                                    bc = BC0;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        } else {
                            if BC0 >= minc && BC0 <= maxc && BR0 + kr >= minr && BR0 + kr <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (BR0 + kr), col = cast,no_check(s16) BC0};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, BR0 + kr, BC0),
                                            Y_STRIDE,
                                            sp(BC0),
                                            sp(BR0 + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, BR0 + kr, BC0),
                                            Y_STRIDE,
                                            sp(BC0),
                                            sp(BR0 + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_3: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_3; assignment_3; }) < besterr {
                                    besterr = second;

                                    br = BR0 + kr;

                                    bc = BC0;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        }
                    }
                }

                if iters_per_step > 1 {
                    if use_accurate_subpel_search != 0 {
                        if BC0 >= minc && BC0 <= maxc && BR0 + kr >= minr && BR0 + kr <= maxr {
                            CB_MV := MV.{row = cast,no_check(s16) (BR0 + kr), col = cast,no_check(s16) BC0};

                            CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                            thismse =
                                accurate_sub_pel_search(
                                    xd,
                                    *CB_MV,
                                    x.me_sf,
                                    kernel,
                                    vfp,
                                    Z,
                                    SRC_STRIDE,
                                    Y,
                                    Y_STRIDE,
                                    second_pred,
                                    w,
                                    h,
                                    *sse
                                );

                            if (ifx true { assignment_4: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_4; assignment_4; }) < besterr {
                                besterr = second;

                                br = BR0 + kr;

                                bc = BC0;

                                distortion.* = cast,no_check(u32) thismse;

                                sse1.* = sse;
                            }
                        } else {
                            second = 2147483647;
                        }
                        if BC0 + kc >= minc && BC0 + kc <= maxc && BR0 >= minr && BR0 <= maxr {
                            CB_MV := MV.{row = cast,no_check(s16) BR0, col = cast,no_check(s16) (BC0 + kc)};

                            CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                            thismse =
                                accurate_sub_pel_search(
                                    xd,
                                    *CB_MV,
                                    x.me_sf,
                                    kernel,
                                    vfp,
                                    Z,
                                    SRC_STRIDE,
                                    Y,
                                    Y_STRIDE,
                                    second_pred,
                                    w,
                                    h,
                                    *sse
                                );

                            if (ifx true { assignment_5: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_5; assignment_5; }) < besterr {
                                besterr = second;

                                br = BR0;

                                bc = BC0 + kc;

                                distortion.* = cast,no_check(u32) thismse;

                                sse1.* = sse;
                            }
                        } else {
                            second = 2147483647;
                        }
                        if BR0 != br || BC0 != bc {
                            if BC0 + kc >= minc && BC0 + kc <= maxc && BR0 + kr >= minr && BR0 + kr <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (BR0 + kr), col = cast,no_check(s16) (BC0 + kc)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                thismse =
                                    accurate_sub_pel_search(
                                        xd,
                                        *CB_MV,
                                        x.me_sf,
                                        kernel,
                                        vfp,
                                        Z,
                                        SRC_STRIDE,
                                        Y,
                                        Y_STRIDE,
                                        second_pred,
                                        w,
                                        h,
                                        *sse
                                    );

                                if (ifx true { assignment_6: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_6; assignment_6; }) < besterr {
                                    besterr = second;

                                    br = BR0 + kr;

                                    bc = BC0 + kc;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        }
                    } else {
                        if BC0 >= minc && BC0 <= maxc && BR0 + kr >= minr && BR0 + kr <= maxr {
                            CB_MV := MV.{row = cast,no_check(s16) (BR0 + kr), col = cast,no_check(s16) BC0};

                            CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                            if second_pred == null {
                                thismse =
                                    cast,no_check(s32) vfp.svf(
                                        pre(Y, Y_STRIDE, BR0 + kr, BC0),
                                        Y_STRIDE,
                                        sp(BC0),
                                        sp(BR0 + kr),
                                        Z,
                                        SRC_STRIDE,
                                        *sse
                                    );
                            } else {
                                thismse =
                                    cast,no_check(s32) vfp.svaf(
                                        pre(Y, Y_STRIDE, BR0 + kr, BC0),
                                        Y_STRIDE,
                                        sp(BC0),
                                        sp(BR0 + kr),
                                        Z,
                                        SRC_STRIDE,
                                        *sse,
                                        second_pred
                                    );
                            }

                            if (ifx true { assignment_7: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_7; assignment_7; }) < besterr {
                                besterr = second;

                                br = BR0 + kr;

                                bc = BC0;

                                distortion.* = cast,no_check(u32) thismse;

                                sse1.* = sse;
                            }
                        } else {
                            second = 2147483647;
                        }
                        if BC0 + kc >= minc && BC0 + kc <= maxc && BR0 >= minr && BR0 <= maxr {
                            CB_MV := MV.{row = cast,no_check(s16) BR0, col = cast,no_check(s16) (BC0 + kc)};

                            CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                            if second_pred == null {
                                thismse =
                                    cast,no_check(s32) vfp.svf(
                                        pre(Y, Y_STRIDE, BR0, BC0 + kc),
                                        Y_STRIDE,
                                        sp(BC0 + kc),
                                        sp(BR0),
                                        Z,
                                        SRC_STRIDE,
                                        *sse
                                    );
                            } else {
                                thismse =
                                    cast,no_check(s32) vfp.svaf(
                                        pre(Y, Y_STRIDE, BR0, BC0 + kc),
                                        Y_STRIDE,
                                        sp(BC0 + kc),
                                        sp(BR0),
                                        Z,
                                        SRC_STRIDE,
                                        *sse,
                                        second_pred
                                    );
                            }

                            if (ifx true { assignment_8: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_8; assignment_8; }) < besterr {
                                besterr = second;

                                br = BR0;

                                bc = BC0 + kc;

                                distortion.* = cast,no_check(u32) thismse;

                                sse1.* = sse;
                            }
                        } else {
                            second = 2147483647;
                        }
                        if BR0 != br || BC0 != bc {
                            if BC0 + kc >= minc && BC0 + kc <= maxc && BR0 + kr >= minr && BR0 + kr <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (BR0 + kr), col = cast,no_check(s16) (BC0 + kc)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, BR0 + kr, BC0 + kc),
                                            Y_STRIDE,
                                            sp(BC0 + kc),
                                            sp(BR0 + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, BR0 + kr, BC0 + kc),
                                            Y_STRIDE,
                                            sp(BC0 + kc),
                                            sp(BR0 + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_9: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_9; assignment_9; }) < besterr {
                                    besterr = second;

                                    br = BR0 + kr;

                                    bc = BC0 + kc;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        }
                    }
                }
            }

            search_step += 4;
            c_transpiler_compound_shr(*(hstep), (cast(s32) 1), s32, s32);
            best_idx = -1;
        }
    }

    bestmv.row = cast,no_check(s16) br;
    bestmv.col = cast,no_check(s16) bc;

    return besterr;
}

sp :: (x: s32) -> s32 {
    return x & 7;
}

pre :: (buf: *u8, stride: s32, r: s32, c: s32) -> *u8 {
    return *buf[r >> 3 * stride + c >> 3];
}

accurate_sub_pel_search :: (
    xd: *MACROBLOCKD,
    this_mv: *MV,
    sf: *Scale_Factors,
    kernel: *Interp_Kernel,
    vfp: *Vp9_Variance_Fn_Ptr_T,
    SRC_ADDRESS: *u8,
    SRC_STRIDE: s32,
    PRE_ADDRESS: *u8,
    y_stride: s32,
    second_pred: *u8,
    w: s32,
    h: s32,
    sse: *u32
) -> s32 {
    besterr: s32 = ---;
    pred: [4096] u8 = --- #align 16;

    vp9_build_inter_predictor(
        PRE_ADDRESS,
        y_stride,
        pred.data,
        w,
        this_mv,
        sf,
        w,
        h,
        0,
        kernel,
        cast,no_check(Mv_Precision) MV_PRECISION_Q3,
        0,
        0
    );
    if second_pred != null {
        comp_pred: [4096] u8 = --- #align 32;
        comp_avg_pred_c(comp_pred.data, second_pred, w, h, pred.data, w);
        besterr = cast,no_check(s32) vfp.vf(comp_pred.data, w, SRC_ADDRESS, SRC_STRIDE, sse);
    } else {
        besterr = cast,no_check(s32) vfp.vf(pred.data, w, SRC_ADDRESS, SRC_STRIDE, sse);
    }
    return besterr;
}

setup_center_error :: (
    xd: *MACROBLOCKD,
    bestmv: *MV,
    ref_mv: *MV,
    error_per_bit: s32,
    vfp: *Vp9_Variance_Fn_Ptr_T,
    SRC: *u8,
    SRC_STRIDE: s32,
    Y: *u8,
    y_stride: s32,
    second_pred: *u8,
    w: s32,
    h: s32,
    offset: s32,
    mvjcost: *s32,
    mvcost: **s32,
    sse1: *u32,
    distortion: *u32
) -> u32 {
    besterr: u32 = ---;

    if second_pred != null {
        comp_pred: [4096] u8 = --- #align 32;
        comp_avg_pred_c(comp_pred.data, second_pred, w, h, Y + offset, y_stride);
        besterr = vfp.vf(comp_pred.data, w, SRC, SRC_STRIDE, sse1);
    } else {
        besterr = vfp.vf(Y + offset, y_stride, SRC, SRC_STRIDE, sse1);
    }
    distortion.* = besterr;
    besterr += cast,no_check(u32) mv_err_cost_in_vp9_mcomp(bestmv, ref_mv, mvjcost, mvcost, error_per_bit);
    return besterr;
}

vp9_find_best_sub_pixel_tree_pruned :: (
    x: *MACROBLOCK,
    bestmv: *MV,
    ref_mv: *MV,
    allow_hp: s32,
    error_per_bit: s32,
    vfp: *Vp9_Variance_Fn_Ptr_T,
    forced_stop: s32,
    iters_per_step: s32,
    cost_list: *s32,
    mvjcost: *s32,
    mvcost: **s32,
    distortion: *u32,
    sse1: *u32,
    second_pred: *u8,
    w: s32,
    h: s32,
    use_accurate_subpel_search: s32
) -> u32 {
    Z := x.plane[0].src.buf;

    SRC_STRIDE := x.plane[0].src.stride;

    xd := *x.e_mbd;

    besterr: u32 = (cast,no_check(u32) (2147483647)) * 2 + 1;

    sse: u32 = ---;

    whichdir: u32 = ---;

    thismse: s32 = ---;

    HALFITERS := cast,no_check(u32) iters_per_step;

    QUARTERITERS := cast,no_check(u32) iters_per_step;

    EIGHTHITERS := cast,no_check(u32) iters_per_step;

    Y_STRIDE := xd.plane[0].pre[0].stride;

    OFFSET := (cast(s32) bestmv.row) * Y_STRIDE + cast(s32) bestmv.col;

    Y := xd.plane[0].pre[0].buf;

    rr := cast,no_check(s32) ref_mv.row;

    rc := cast,no_check(s32) ref_mv.col;

    br := (cast(s32) bestmv.row) * 8;

    bc := (cast(s32) bestmv.col) * 8;

    hstep: s32 = 4;

    tr := br;

    tc := bc;

    subpel_mv_limits: Mv_Limits = ---;

    vp9_set_subpel_mv_search_range(*subpel_mv_limits, *x.mv_limits, ref_mv);

    minc := subpel_mv_limits.col_min;

    maxc := subpel_mv_limits.col_max;

    minr := subpel_mv_limits.row_min;

    maxr := subpel_mv_limits.row_max;

    bestmv.row = cast,no_check(s16) ((cast,no_check(s32) bestmv.row) * 8);

    bestmv.col = cast,no_check(s16) ((cast,no_check(s32) bestmv.col) * 8);

    besterr =
        setup_center_error(
            xd,
            bestmv,
            ref_mv,
            error_per_bit,
            vfp,
            Z,
            SRC_STRIDE,
            Y,
            Y_STRIDE,
            second_pred,
            w,
            h,
            OFFSET,
            mvjcost,
            mvcost,
            sse1,
            distortion
        );
    if cost_list != null &&
        cost_list[0] != 2147483647 &&
        cost_list[1] != 2147483647 &&
        cost_list[2] != 2147483647 &&
        cost_list[3] != 2147483647 &&
        cost_list[4] != 2147483647 {
        left, right, up, down, diag: u32 = ---;
        whichdir =
            cast,no_check(u32) ((ifx cost_list[1] < cost_list[3] then cast(s32) 0 else 1) +
                (ifx cost_list[2] < cost_list[4] then cast(s32) 0 else 2));
        if whichdir == {
            case 0;
                if tc - hstep >= minc && tc - hstep <= maxc && tr >= minr && tr <= maxr {
                    CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc - hstep)};

                    CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                    if second_pred == null {
                        thismse =
                            cast,no_check(s32) vfp.svf(
                                pre(Y, Y_STRIDE, tr, tc - hstep),
                                Y_STRIDE,
                                sp(tc - hstep),
                                sp(tr),
                                Z,
                                SRC_STRIDE,
                                *sse
                            );
                    } else {
                        thismse =
                            cast,no_check(s32) vfp.svaf(
                                pre(Y, Y_STRIDE, tr, tc - hstep),
                                Y_STRIDE,
                                sp(tc - hstep),
                                sp(tr),
                                Z,
                                SRC_STRIDE,
                                *sse,
                                second_pred
                            );
                    }

                    if (ifx true { assignment_10: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (left) = assignment_10; assignment_10; }) < besterr {
                        besterr = left;

                        br = tr;

                        bc = tc - hstep;

                        distortion.* = cast,no_check(u32) thismse;

                        sse1.* = sse;
                    }
                } else {
                    left = 2147483647;
                }
                if tc >= minc && tc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                    CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) tc};

                    CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                    if second_pred == null {
                        thismse =
                            cast,no_check(s32) vfp.svf(
                                pre(Y, Y_STRIDE, tr + hstep, tc),
                                Y_STRIDE,
                                sp(tc),
                                sp(tr + hstep),
                                Z,
                                SRC_STRIDE,
                                *sse
                            );
                    } else {
                        thismse =
                            cast,no_check(s32) vfp.svaf(
                                pre(Y, Y_STRIDE, tr + hstep, tc),
                                Y_STRIDE,
                                sp(tc),
                                sp(tr + hstep),
                                Z,
                                SRC_STRIDE,
                                *sse,
                                second_pred
                            );
                    }

                    if (ifx true { assignment_11: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (down) = assignment_11; assignment_11; }) < besterr {
                        besterr = down;

                        br = tr + hstep;

                        bc = tc;

                        distortion.* = cast,no_check(u32) thismse;

                        sse1.* = sse;
                    }
                } else {
                    down = 2147483647;
                }
                if tc - hstep >= minc && tc - hstep <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                    CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc - hstep)};

                    CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                    if second_pred == null {
                        thismse =
                            cast,no_check(s32) vfp.svf(
                                pre(Y, Y_STRIDE, tr + hstep, tc - hstep),
                                Y_STRIDE,
                                sp(tc - hstep),
                                sp(tr + hstep),
                                Z,
                                SRC_STRIDE,
                                *sse
                            );
                    } else {
                        thismse =
                            cast,no_check(s32) vfp.svaf(
                                pre(Y, Y_STRIDE, tr + hstep, tc - hstep),
                                Y_STRIDE,
                                sp(tc - hstep),
                                sp(tr + hstep),
                                Z,
                                SRC_STRIDE,
                                *sse,
                                second_pred
                            );
                    }

                    if (ifx true { assignment_12: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_12; assignment_12; }) < besterr {
                        besterr = diag;

                        br = tr + hstep;

                        bc = tc - hstep;

                        distortion.* = cast,no_check(u32) thismse;

                        sse1.* = sse;
                    }
                } else {
                    diag = 2147483647;
                }
            case 1;
                if tc + hstep >= minc && tc + hstep <= maxc && tr >= minr && tr <= maxr {
                    CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc + hstep)};

                    CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                    if second_pred == null {
                        thismse =
                            cast,no_check(s32) vfp.svf(
                                pre(Y, Y_STRIDE, tr, tc + hstep),
                                Y_STRIDE,
                                sp(tc + hstep),
                                sp(tr),
                                Z,
                                SRC_STRIDE,
                                *sse
                            );
                    } else {
                        thismse =
                            cast,no_check(s32) vfp.svaf(
                                pre(Y, Y_STRIDE, tr, tc + hstep),
                                Y_STRIDE,
                                sp(tc + hstep),
                                sp(tr),
                                Z,
                                SRC_STRIDE,
                                *sse,
                                second_pred
                            );
                    }

                    if (ifx true { assignment_13: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (right) = assignment_13; assignment_13; }) < besterr {
                        besterr = right;

                        br = tr;

                        bc = tc + hstep;

                        distortion.* = cast,no_check(u32) thismse;

                        sse1.* = sse;
                    }
                } else {
                    right = 2147483647;
                }
                if tc >= minc && tc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                    CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) tc};

                    CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                    if second_pred == null {
                        thismse =
                            cast,no_check(s32) vfp.svf(
                                pre(Y, Y_STRIDE, tr + hstep, tc),
                                Y_STRIDE,
                                sp(tc),
                                sp(tr + hstep),
                                Z,
                                SRC_STRIDE,
                                *sse
                            );
                    } else {
                        thismse =
                            cast,no_check(s32) vfp.svaf(
                                pre(Y, Y_STRIDE, tr + hstep, tc),
                                Y_STRIDE,
                                sp(tc),
                                sp(tr + hstep),
                                Z,
                                SRC_STRIDE,
                                *sse,
                                second_pred
                            );
                    }

                    if (ifx true { assignment_14: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (down) = assignment_14; assignment_14; }) < besterr {
                        besterr = down;

                        br = tr + hstep;

                        bc = tc;

                        distortion.* = cast,no_check(u32) thismse;

                        sse1.* = sse;
                    }
                } else {
                    down = 2147483647;
                }
                if tc + hstep >= minc && tc + hstep <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                    CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + hstep)};

                    CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                    if second_pred == null {
                        thismse =
                            cast,no_check(s32) vfp.svf(
                                pre(Y, Y_STRIDE, tr + hstep, tc + hstep),
                                Y_STRIDE,
                                sp(tc + hstep),
                                sp(tr + hstep),
                                Z,
                                SRC_STRIDE,
                                *sse
                            );
                    } else {
                        thismse =
                            cast,no_check(s32) vfp.svaf(
                                pre(Y, Y_STRIDE, tr + hstep, tc + hstep),
                                Y_STRIDE,
                                sp(tc + hstep),
                                sp(tr + hstep),
                                Z,
                                SRC_STRIDE,
                                *sse,
                                second_pred
                            );
                    }

                    if (ifx true { assignment_15: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_15; assignment_15; }) < besterr {
                        besterr = diag;

                        br = tr + hstep;

                        bc = tc + hstep;

                        distortion.* = cast,no_check(u32) thismse;

                        sse1.* = sse;
                    }
                } else {
                    diag = 2147483647;
                }
            case 2;
                if tc - hstep >= minc && tc - hstep <= maxc && tr >= minr && tr <= maxr {
                    CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc - hstep)};

                    CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                    if second_pred == null {
                        thismse =
                            cast,no_check(s32) vfp.svf(
                                pre(Y, Y_STRIDE, tr, tc - hstep),
                                Y_STRIDE,
                                sp(tc - hstep),
                                sp(tr),
                                Z,
                                SRC_STRIDE,
                                *sse
                            );
                    } else {
                        thismse =
                            cast,no_check(s32) vfp.svaf(
                                pre(Y, Y_STRIDE, tr, tc - hstep),
                                Y_STRIDE,
                                sp(tc - hstep),
                                sp(tr),
                                Z,
                                SRC_STRIDE,
                                *sse,
                                second_pred
                            );
                    }

                    if (ifx true { assignment_16: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (left) = assignment_16; assignment_16; }) < besterr {
                        besterr = left;

                        br = tr;

                        bc = tc - hstep;

                        distortion.* = cast,no_check(u32) thismse;

                        sse1.* = sse;
                    }
                } else {
                    left = 2147483647;
                }
                if tc >= minc && tc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                    CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) tc};

                    CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                    if second_pred == null {
                        thismse =
                            cast,no_check(s32) vfp.svf(
                                pre(Y, Y_STRIDE, tr - hstep, tc),
                                Y_STRIDE,
                                sp(tc),
                                sp(tr - hstep),
                                Z,
                                SRC_STRIDE,
                                *sse
                            );
                    } else {
                        thismse =
                            cast,no_check(s32) vfp.svaf(
                                pre(Y, Y_STRIDE, tr - hstep, tc),
                                Y_STRIDE,
                                sp(tc),
                                sp(tr - hstep),
                                Z,
                                SRC_STRIDE,
                                *sse,
                                second_pred
                            );
                    }

                    if (ifx true { assignment_17: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (up) = assignment_17; assignment_17; }) < besterr {
                        besterr = up;

                        br = tr - hstep;

                        bc = tc;

                        distortion.* = cast,no_check(u32) thismse;

                        sse1.* = sse;
                    }
                } else {
                    up = 2147483647;
                }
                if tc - hstep >= minc && tc - hstep <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                    CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc - hstep)};

                    CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                    if second_pred == null {
                        thismse =
                            cast,no_check(s32) vfp.svf(
                                pre(Y, Y_STRIDE, tr - hstep, tc - hstep),
                                Y_STRIDE,
                                sp(tc - hstep),
                                sp(tr - hstep),
                                Z,
                                SRC_STRIDE,
                                *sse
                            );
                    } else {
                        thismse =
                            cast,no_check(s32) vfp.svaf(
                                pre(Y, Y_STRIDE, tr - hstep, tc - hstep),
                                Y_STRIDE,
                                sp(tc - hstep),
                                sp(tr - hstep),
                                Z,
                                SRC_STRIDE,
                                *sse,
                                second_pred
                            );
                    }

                    if (ifx true { assignment_18: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_18; assignment_18; }) < besterr {
                        besterr = diag;

                        br = tr - hstep;

                        bc = tc - hstep;

                        distortion.* = cast,no_check(u32) thismse;

                        sse1.* = sse;
                    }
                } else {
                    diag = 2147483647;
                }
            case 3;
                if tc + hstep >= minc && tc + hstep <= maxc && tr >= minr && tr <= maxr {
                    CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc + hstep)};

                    CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                    if second_pred == null {
                        thismse =
                            cast,no_check(s32) vfp.svf(
                                pre(Y, Y_STRIDE, tr, tc + hstep),
                                Y_STRIDE,
                                sp(tc + hstep),
                                sp(tr),
                                Z,
                                SRC_STRIDE,
                                *sse
                            );
                    } else {
                        thismse =
                            cast,no_check(s32) vfp.svaf(
                                pre(Y, Y_STRIDE, tr, tc + hstep),
                                Y_STRIDE,
                                sp(tc + hstep),
                                sp(tr),
                                Z,
                                SRC_STRIDE,
                                *sse,
                                second_pred
                            );
                    }

                    if (ifx true { assignment_19: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (right) = assignment_19; assignment_19; }) < besterr {
                        besterr = right;

                        br = tr;

                        bc = tc + hstep;

                        distortion.* = cast,no_check(u32) thismse;

                        sse1.* = sse;
                    }
                } else {
                    right = 2147483647;
                }
                if tc >= minc && tc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                    CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) tc};

                    CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                    if second_pred == null {
                        thismse =
                            cast,no_check(s32) vfp.svf(
                                pre(Y, Y_STRIDE, tr - hstep, tc),
                                Y_STRIDE,
                                sp(tc),
                                sp(tr - hstep),
                                Z,
                                SRC_STRIDE,
                                *sse
                            );
                    } else {
                        thismse =
                            cast,no_check(s32) vfp.svaf(
                                pre(Y, Y_STRIDE, tr - hstep, tc),
                                Y_STRIDE,
                                sp(tc),
                                sp(tr - hstep),
                                Z,
                                SRC_STRIDE,
                                *sse,
                                second_pred
                            );
                    }

                    if (ifx true { assignment_20: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (up) = assignment_20; assignment_20; }) < besterr {
                        besterr = up;

                        br = tr - hstep;

                        bc = tc;

                        distortion.* = cast,no_check(u32) thismse;

                        sse1.* = sse;
                    }
                } else {
                    up = 2147483647;
                }
                if tc + hstep >= minc && tc + hstep <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                    CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + hstep)};

                    CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                    if second_pred == null {
                        thismse =
                            cast,no_check(s32) vfp.svf(
                                pre(Y, Y_STRIDE, tr - hstep, tc + hstep),
                                Y_STRIDE,
                                sp(tc + hstep),
                                sp(tr - hstep),
                                Z,
                                SRC_STRIDE,
                                *sse
                            );
                    } else {
                        thismse =
                            cast,no_check(s32) vfp.svaf(
                                pre(Y, Y_STRIDE, tr - hstep, tc + hstep),
                                Y_STRIDE,
                                sp(tc + hstep),
                                sp(tr - hstep),
                                Z,
                                SRC_STRIDE,
                                *sse,
                                second_pred
                            );
                    }

                    if (ifx true { assignment_21: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_21; assignment_21; }) < besterr {
                        besterr = diag;

                        br = tr - hstep;

                        bc = tc + hstep;

                        distortion.* = cast,no_check(u32) thismse;

                        sse1.* = sse;
                    }
                } else {
                    diag = 2147483647;
                }
        }
    } else {
        {
            left, right, up, down, diag: u32 = ---;

            if tc - hstep >= minc && tc - hstep <= maxc && tr >= minr && tr <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc - hstep)};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr, tc - hstep),
                            Y_STRIDE,
                            sp(tc - hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr, tc - hstep),
                            Y_STRIDE,
                            sp(tc - hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_22: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (left) = assignment_22; assignment_22; }) < besterr {
                    besterr = left;

                    br = tr;

                    bc = tc - hstep;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                left = 2147483647;
            }

            if tc + hstep >= minc && tc + hstep <= maxc && tr >= minr && tr <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc + hstep)};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr, tc + hstep),
                            Y_STRIDE,
                            sp(tc + hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr, tc + hstep),
                            Y_STRIDE,
                            sp(tc + hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_23: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (right) = assignment_23; assignment_23; }) < besterr {
                    besterr = right;

                    br = tr;

                    bc = tc + hstep;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                right = 2147483647;
            }

            if tc >= minc && tc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) tc};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr - hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr - hstep),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr - hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr - hstep),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_24: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (up) = assignment_24; assignment_24; }) < besterr {
                    besterr = up;

                    br = tr - hstep;

                    bc = tc;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                up = 2147483647;
            }

            if tc >= minc && tc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) tc};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr + hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr + hstep),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr + hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr + hstep),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_25: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (down) = assignment_25; assignment_25; }) < besterr {
                    besterr = down;

                    br = tr + hstep;

                    bc = tc;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                down = 2147483647;
            }

            whichdir =
                cast,no_check(u32) ((ifx left < right then cast(s32) 0 else 1) +
                    (ifx up < down then cast(s32) 0 else 2));

            if whichdir == {
                case 0;
                    if tc - hstep >= minc && tc - hstep <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_26: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_26; assignment_26; }) < besterr {
                            besterr = diag;

                            br = tr - hstep;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 1;
                    if tc + hstep >= minc && tc + hstep <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_27: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_27; assignment_27; }) < besterr {
                            besterr = diag;

                            br = tr - hstep;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 2;
                    if tc - hstep >= minc && tc - hstep <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_28: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_28; assignment_28; }) < besterr {
                            besterr = diag;

                            br = tr + hstep;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 3;
                    if tc + hstep >= minc && tc + hstep <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_29: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_29; assignment_29; }) < besterr {
                            besterr = diag;

                            br = tr + hstep;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
            }
        }
        if HALFITERS > 1 {
            {
                kr, kc: s32 = ---;

                second: u32 = ---;

                if tr != br && tc != bc {
                    kr = br - tr;

                    kc = bc - tc;

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr + kr >= minr && tr + kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + kr, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + kr, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_30: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_30; assignment_30; }) < besterr {
                            besterr = second;

                            br = tr + kr;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc + kc >= minc && tc + kc <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc + kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + kc),
                                    Y_STRIDE,
                                    sp(tc + kc),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + kc),
                                    Y_STRIDE,
                                    sp(tc + kc),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_31: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_31; assignment_31; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc + kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }
                } else if tr == br && tc != bc {
                    kc = bc - tc;

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_32: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_32; assignment_32; }) < besterr {
                            besterr = second;

                            br = tr + hstep;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_33: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_33; assignment_33; }) < besterr {
                            besterr = second;

                            br = tr - hstep;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if whichdir == {
                        case 0; #through;
                        case 1;
                            if tc + kc >= minc && tc + kc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + kc)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr + hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr + hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_34: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_34; assignment_34; }) < besterr {
                                    besterr = second;

                                    br = tr + hstep;

                                    bc = tc + kc;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        case 2; #through;
                        case 3;
                            if tc + kc >= minc && tc + kc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + kc)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr - hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr - hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr - hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr - hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_35: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_35; assignment_35; }) < besterr {
                                    besterr = second;

                                    br = tr - hstep;

                                    bc = tc + kc;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                    }
                } else if tr != br && tc == bc {
                    kr = br - tr;

                    if tc + hstep >= minc && tc + hstep <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_36: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_36; assignment_36; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc - hstep >= minc && tc - hstep <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_37: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_37; assignment_37; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if whichdir == {
                        case 0; #through;
                        case 2;
                            if tc + hstep >= minc && tc + hstep <= maxc && tr + kr >= minr && tr + kr <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc + hstep)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + kr, tc + hstep),
                                            Y_STRIDE,
                                            sp(tc + hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + kr, tc + hstep),
                                            Y_STRIDE,
                                            sp(tc + hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_38: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_38; assignment_38; }) < besterr {
                                    besterr = second;

                                    br = tr + kr;

                                    bc = tc + hstep;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        case 1; #through;
                        case 3;
                            if tc - hstep >= minc && tc - hstep <= maxc && tr + kr >= minr && tr + kr <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc - hstep)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + kr, tc - hstep),
                                            Y_STRIDE,
                                            sp(tc - hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + kr, tc - hstep),
                                            Y_STRIDE,
                                            sp(tc - hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_39: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_39; assignment_39; }) < besterr {
                                    besterr = second;

                                    br = tr + kr;

                                    bc = tc - hstep;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                    }
                }
            }
        }
    }

    tr = br;
    tc = bc;

    if forced_stop != 2 {
        c_transpiler_compound_shr(*(hstep), (cast(s32) 1), s32, s32);
        {
            left, right, up, down, diag: u32 = ---;

            if tc - hstep >= minc && tc - hstep <= maxc && tr >= minr && tr <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc - hstep)};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr, tc - hstep),
                            Y_STRIDE,
                            sp(tc - hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr, tc - hstep),
                            Y_STRIDE,
                            sp(tc - hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_40: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (left) = assignment_40; assignment_40; }) < besterr {
                    besterr = left;

                    br = tr;

                    bc = tc - hstep;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                left = 2147483647;
            }

            if tc + hstep >= minc && tc + hstep <= maxc && tr >= minr && tr <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc + hstep)};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr, tc + hstep),
                            Y_STRIDE,
                            sp(tc + hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr, tc + hstep),
                            Y_STRIDE,
                            sp(tc + hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_41: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (right) = assignment_41; assignment_41; }) < besterr {
                    besterr = right;

                    br = tr;

                    bc = tc + hstep;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                right = 2147483647;
            }

            if tc >= minc && tc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) tc};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr - hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr - hstep),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr - hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr - hstep),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_42: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (up) = assignment_42; assignment_42; }) < besterr {
                    besterr = up;

                    br = tr - hstep;

                    bc = tc;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                up = 2147483647;
            }

            if tc >= minc && tc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) tc};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr + hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr + hstep),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr + hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr + hstep),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_43: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (down) = assignment_43; assignment_43; }) < besterr {
                    besterr = down;

                    br = tr + hstep;

                    bc = tc;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                down = 2147483647;
            }

            whichdir =
                cast,no_check(u32) ((ifx left < right then cast(s32) 0 else 1) +
                    (ifx up < down then cast(s32) 0 else 2));

            if whichdir == {
                case 0;
                    if tc - hstep >= minc && tc - hstep <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_44: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_44; assignment_44; }) < besterr {
                            besterr = diag;

                            br = tr - hstep;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 1;
                    if tc + hstep >= minc && tc + hstep <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_45: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_45; assignment_45; }) < besterr {
                            besterr = diag;

                            br = tr - hstep;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 2;
                    if tc - hstep >= minc && tc - hstep <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_46: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_46; assignment_46; }) < besterr {
                            besterr = diag;

                            br = tr + hstep;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 3;
                    if tc + hstep >= minc && tc + hstep <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_47: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_47; assignment_47; }) < besterr {
                            besterr = diag;

                            br = tr + hstep;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
            }
        }
        if QUARTERITERS > 1 {
            {
                kr, kc: s32 = ---;

                second: u32 = ---;

                if tr != br && tc != bc {
                    kr = br - tr;

                    kc = bc - tc;

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr + kr >= minr && tr + kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + kr, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + kr, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_48: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_48; assignment_48; }) < besterr {
                            besterr = second;

                            br = tr + kr;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc + kc >= minc && tc + kc <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc + kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + kc),
                                    Y_STRIDE,
                                    sp(tc + kc),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + kc),
                                    Y_STRIDE,
                                    sp(tc + kc),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_49: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_49; assignment_49; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc + kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }
                } else if tr == br && tc != bc {
                    kc = bc - tc;

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_50: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_50; assignment_50; }) < besterr {
                            besterr = second;

                            br = tr + hstep;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_51: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_51; assignment_51; }) < besterr {
                            besterr = second;

                            br = tr - hstep;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if whichdir == {
                        case 0; #through;
                        case 1;
                            if tc + kc >= minc && tc + kc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + kc)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr + hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr + hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_52: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_52; assignment_52; }) < besterr {
                                    besterr = second;

                                    br = tr + hstep;

                                    bc = tc + kc;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        case 2; #through;
                        case 3;
                            if tc + kc >= minc && tc + kc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + kc)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr - hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr - hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr - hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr - hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_53: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_53; assignment_53; }) < besterr {
                                    besterr = second;

                                    br = tr - hstep;

                                    bc = tc + kc;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                    }
                } else if tr != br && tc == bc {
                    kr = br - tr;

                    if tc + hstep >= minc && tc + hstep <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_54: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_54; assignment_54; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc - hstep >= minc && tc - hstep <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_55: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_55; assignment_55; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if whichdir == {
                        case 0; #through;
                        case 2;
                            if tc + hstep >= minc && tc + hstep <= maxc && tr + kr >= minr && tr + kr <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc + hstep)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + kr, tc + hstep),
                                            Y_STRIDE,
                                            sp(tc + hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + kr, tc + hstep),
                                            Y_STRIDE,
                                            sp(tc + hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_56: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_56; assignment_56; }) < besterr {
                                    besterr = second;

                                    br = tr + kr;

                                    bc = tc + hstep;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        case 1; #through;
                        case 3;
                            if tc - hstep >= minc && tc - hstep <= maxc && tr + kr >= minr && tr + kr <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc - hstep)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + kr, tc - hstep),
                                            Y_STRIDE,
                                            sp(tc - hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + kr, tc - hstep),
                                            Y_STRIDE,
                                            sp(tc - hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_57: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_57; assignment_57; }) < besterr {
                                    besterr = second;

                                    br = tr + kr;

                                    bc = tc - hstep;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                    }
                }
            }
        }
        tr = br;
        tc = bc;
    }

    if allow_hp != 0 && use_mv_hp_in_vp9_mcomp(ref_mv) != 0 && forced_stop == 0 {
        c_transpiler_compound_shr(*(hstep), (cast(s32) 1), s32, s32);
        {
            left, right, up, down, diag: u32 = ---;

            if tc - hstep >= minc && tc - hstep <= maxc && tr >= minr && tr <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc - hstep)};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr, tc - hstep),
                            Y_STRIDE,
                            sp(tc - hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr, tc - hstep),
                            Y_STRIDE,
                            sp(tc - hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_58: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (left) = assignment_58; assignment_58; }) < besterr {
                    besterr = left;

                    br = tr;

                    bc = tc - hstep;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                left = 2147483647;
            }

            if tc + hstep >= minc && tc + hstep <= maxc && tr >= minr && tr <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc + hstep)};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr, tc + hstep),
                            Y_STRIDE,
                            sp(tc + hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr, tc + hstep),
                            Y_STRIDE,
                            sp(tc + hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_59: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (right) = assignment_59; assignment_59; }) < besterr {
                    besterr = right;

                    br = tr;

                    bc = tc + hstep;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                right = 2147483647;
            }

            if tc >= minc && tc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) tc};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr - hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr - hstep),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr - hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr - hstep),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_60: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (up) = assignment_60; assignment_60; }) < besterr {
                    besterr = up;

                    br = tr - hstep;

                    bc = tc;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                up = 2147483647;
            }

            if tc >= minc && tc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) tc};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr + hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr + hstep),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr + hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr + hstep),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_61: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (down) = assignment_61; assignment_61; }) < besterr {
                    besterr = down;

                    br = tr + hstep;

                    bc = tc;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                down = 2147483647;
            }

            whichdir =
                cast,no_check(u32) ((ifx left < right then cast(s32) 0 else 1) +
                    (ifx up < down then cast(s32) 0 else 2));

            if whichdir == {
                case 0;
                    if tc - hstep >= minc && tc - hstep <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_62: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_62; assignment_62; }) < besterr {
                            besterr = diag;

                            br = tr - hstep;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 1;
                    if tc + hstep >= minc && tc + hstep <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_63: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_63; assignment_63; }) < besterr {
                            besterr = diag;

                            br = tr - hstep;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 2;
                    if tc - hstep >= minc && tc - hstep <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_64: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_64; assignment_64; }) < besterr {
                            besterr = diag;

                            br = tr + hstep;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 3;
                    if tc + hstep >= minc && tc + hstep <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_65: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_65; assignment_65; }) < besterr {
                            besterr = diag;

                            br = tr + hstep;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
            }
        }
        if EIGHTHITERS > 1 {
            {
                kr, kc: s32 = ---;

                second: u32 = ---;

                if tr != br && tc != bc {
                    kr = br - tr;

                    kc = bc - tc;

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr + kr >= minr && tr + kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + kr, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + kr, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_66: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_66; assignment_66; }) < besterr {
                            besterr = second;

                            br = tr + kr;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc + kc >= minc && tc + kc <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc + kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + kc),
                                    Y_STRIDE,
                                    sp(tc + kc),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + kc),
                                    Y_STRIDE,
                                    sp(tc + kc),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_67: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_67; assignment_67; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc + kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }
                } else if tr == br && tc != bc {
                    kc = bc - tc;

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_68: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_68; assignment_68; }) < besterr {
                            besterr = second;

                            br = tr + hstep;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_69: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_69; assignment_69; }) < besterr {
                            besterr = second;

                            br = tr - hstep;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if whichdir == {
                        case 0; #through;
                        case 1;
                            if tc + kc >= minc && tc + kc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + kc)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr + hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr + hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_70: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_70; assignment_70; }) < besterr {
                                    besterr = second;

                                    br = tr + hstep;

                                    bc = tc + kc;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        case 2; #through;
                        case 3;
                            if tc + kc >= minc && tc + kc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + kc)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr - hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr - hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr - hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr - hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_71: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_71; assignment_71; }) < besterr {
                                    besterr = second;

                                    br = tr - hstep;

                                    bc = tc + kc;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                    }
                } else if tr != br && tc == bc {
                    kr = br - tr;

                    if tc + hstep >= minc && tc + hstep <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_72: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_72; assignment_72; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc - hstep >= minc && tc - hstep <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_73: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_73; assignment_73; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if whichdir == {
                        case 0; #through;
                        case 2;
                            if tc + hstep >= minc && tc + hstep <= maxc && tr + kr >= minr && tr + kr <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc + hstep)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + kr, tc + hstep),
                                            Y_STRIDE,
                                            sp(tc + hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + kr, tc + hstep),
                                            Y_STRIDE,
                                            sp(tc + hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_74: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_74; assignment_74; }) < besterr {
                                    besterr = second;

                                    br = tr + kr;

                                    bc = tc + hstep;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        case 1; #through;
                        case 3;
                            if tc - hstep >= minc && tc - hstep <= maxc && tr + kr >= minr && tr + kr <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc - hstep)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + kr, tc - hstep),
                                            Y_STRIDE,
                                            sp(tc - hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + kr, tc - hstep),
                                            Y_STRIDE,
                                            sp(tc - hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_75: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_75; assignment_75; }) < besterr {
                                    besterr = second;

                                    br = tr + kr;

                                    bc = tc - hstep;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                    }
                }
            }
        }
        tr = br;
        tc = bc;
    }

    bestmv.row = cast,no_check(s16) br;
    bestmv.col = cast,no_check(s16) bc;

    return besterr;
}

vp9_find_best_sub_pixel_tree_pruned_more :: (
    x: *MACROBLOCK,
    bestmv: *MV,
    ref_mv: *MV,
    allow_hp: s32,
    error_per_bit: s32,
    vfp: *Vp9_Variance_Fn_Ptr_T,
    forced_stop: s32,
    iters_per_step: s32,
    cost_list: *s32,
    mvjcost: *s32,
    mvcost: **s32,
    distortion: *u32,
    sse1: *u32,
    second_pred: *u8,
    w: s32,
    h: s32,
    use_accurate_subpel_search: s32
) -> u32 {
    Z := x.plane[0].src.buf;

    SRC_STRIDE := x.plane[0].src.stride;

    xd := *x.e_mbd;

    besterr: u32 = (cast,no_check(u32) (2147483647)) * 2 + 1;

    sse: u32 = ---;

    whichdir: u32 = ---;

    thismse: s32 = ---;

    HALFITERS := cast,no_check(u32) iters_per_step;

    QUARTERITERS := cast,no_check(u32) iters_per_step;

    EIGHTHITERS := cast,no_check(u32) iters_per_step;

    Y_STRIDE := xd.plane[0].pre[0].stride;

    OFFSET := (cast(s32) bestmv.row) * Y_STRIDE + cast(s32) bestmv.col;

    Y := xd.plane[0].pre[0].buf;

    rr := cast,no_check(s32) ref_mv.row;

    rc := cast,no_check(s32) ref_mv.col;

    br := (cast(s32) bestmv.row) * 8;

    bc := (cast(s32) bestmv.col) * 8;

    hstep: s32 = 4;

    tr := br;

    tc := bc;

    subpel_mv_limits: Mv_Limits = ---;

    vp9_set_subpel_mv_search_range(*subpel_mv_limits, *x.mv_limits, ref_mv);

    minc := subpel_mv_limits.col_min;

    maxc := subpel_mv_limits.col_max;

    minr := subpel_mv_limits.row_min;

    maxr := subpel_mv_limits.row_max;

    bestmv.row = cast,no_check(s16) ((cast,no_check(s32) bestmv.row) * 8);

    bestmv.col = cast,no_check(s16) ((cast,no_check(s32) bestmv.col) * 8);

    besterr =
        setup_center_error(
            xd,
            bestmv,
            ref_mv,
            error_per_bit,
            vfp,
            Z,
            SRC_STRIDE,
            Y,
            Y_STRIDE,
            second_pred,
            w,
            h,
            OFFSET,
            mvjcost,
            mvcost,
            sse1,
            distortion
        );
    if cost_list != null &&
        cost_list[0] != 2147483647 &&
        cost_list[1] != 2147483647 &&
        cost_list[2] != 2147483647 &&
        cost_list[3] != 2147483647 &&
        cost_list[4] != 2147483647 &&
        is_cost_list_wellbehaved(cost_list) != 0 {
        minpt: u32 = ---;
        ir, ic: s32 = ---;
        get_cost_surf_min(cost_list, *ir, *ic, 1);
        if ir != 0 || ic != 0 {
            if tc + ic * hstep >= minc && tc + ic * hstep <= maxc && tr + ir * hstep >= minr && tr + ir * hstep <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) (tr + ir * hstep), col = cast,no_check(s16) (tc + ic * hstep)};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr + ir * hstep, tc + ic * hstep),
                            Y_STRIDE,
                            sp(tc + ic * hstep),
                            sp(tr + ir * hstep),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr + ir * hstep, tc + ic * hstep),
                            Y_STRIDE,
                            sp(tc + ic * hstep),
                            sp(tr + ir * hstep),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_76: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (minpt) = assignment_76; assignment_76; }) < besterr {
                    besterr = minpt;

                    br = tr + ir * hstep;

                    bc = tc + ic * hstep;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                minpt = 2147483647;
            }
        }
    } else {
        {
            left, right, up, down, diag: u32 = ---;

            if tc - hstep >= minc && tc - hstep <= maxc && tr >= minr && tr <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc - hstep)};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr, tc - hstep),
                            Y_STRIDE,
                            sp(tc - hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr, tc - hstep),
                            Y_STRIDE,
                            sp(tc - hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_77: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (left) = assignment_77; assignment_77; }) < besterr {
                    besterr = left;

                    br = tr;

                    bc = tc - hstep;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                left = 2147483647;
            }

            if tc + hstep >= minc && tc + hstep <= maxc && tr >= minr && tr <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc + hstep)};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr, tc + hstep),
                            Y_STRIDE,
                            sp(tc + hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr, tc + hstep),
                            Y_STRIDE,
                            sp(tc + hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_78: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (right) = assignment_78; assignment_78; }) < besterr {
                    besterr = right;

                    br = tr;

                    bc = tc + hstep;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                right = 2147483647;
            }

            if tc >= minc && tc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) tc};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr - hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr - hstep),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr - hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr - hstep),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_79: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (up) = assignment_79; assignment_79; }) < besterr {
                    besterr = up;

                    br = tr - hstep;

                    bc = tc;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                up = 2147483647;
            }

            if tc >= minc && tc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) tc};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr + hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr + hstep),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr + hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr + hstep),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_80: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (down) = assignment_80; assignment_80; }) < besterr {
                    besterr = down;

                    br = tr + hstep;

                    bc = tc;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                down = 2147483647;
            }

            whichdir =
                cast,no_check(u32) ((ifx left < right then cast(s32) 0 else 1) +
                    (ifx up < down then cast(s32) 0 else 2));

            if whichdir == {
                case 0;
                    if tc - hstep >= minc && tc - hstep <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_81: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_81; assignment_81; }) < besterr {
                            besterr = diag;

                            br = tr - hstep;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 1;
                    if tc + hstep >= minc && tc + hstep <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_82: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_82; assignment_82; }) < besterr {
                            besterr = diag;

                            br = tr - hstep;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 2;
                    if tc - hstep >= minc && tc - hstep <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_83: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_83; assignment_83; }) < besterr {
                            besterr = diag;

                            br = tr + hstep;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 3;
                    if tc + hstep >= minc && tc + hstep <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_84: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_84; assignment_84; }) < besterr {
                            besterr = diag;

                            br = tr + hstep;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
            }
        }
        if HALFITERS > 1 {
            {
                kr, kc: s32 = ---;

                second: u32 = ---;

                if tr != br && tc != bc {
                    kr = br - tr;

                    kc = bc - tc;

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr + kr >= minr && tr + kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + kr, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + kr, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_85: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_85; assignment_85; }) < besterr {
                            besterr = second;

                            br = tr + kr;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc + kc >= minc && tc + kc <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc + kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + kc),
                                    Y_STRIDE,
                                    sp(tc + kc),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + kc),
                                    Y_STRIDE,
                                    sp(tc + kc),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_86: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_86; assignment_86; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc + kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }
                } else if tr == br && tc != bc {
                    kc = bc - tc;

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_87: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_87; assignment_87; }) < besterr {
                            besterr = second;

                            br = tr + hstep;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_88: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_88; assignment_88; }) < besterr {
                            besterr = second;

                            br = tr - hstep;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if whichdir == {
                        case 0; #through;
                        case 1;
                            if tc + kc >= minc && tc + kc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + kc)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr + hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr + hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_89: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_89; assignment_89; }) < besterr {
                                    besterr = second;

                                    br = tr + hstep;

                                    bc = tc + kc;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        case 2; #through;
                        case 3;
                            if tc + kc >= minc && tc + kc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + kc)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr - hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr - hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr - hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr - hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_90: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_90; assignment_90; }) < besterr {
                                    besterr = second;

                                    br = tr - hstep;

                                    bc = tc + kc;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                    }
                } else if tr != br && tc == bc {
                    kr = br - tr;

                    if tc + hstep >= minc && tc + hstep <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_91: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_91; assignment_91; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc - hstep >= minc && tc - hstep <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_92: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_92; assignment_92; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if whichdir == {
                        case 0; #through;
                        case 2;
                            if tc + hstep >= minc && tc + hstep <= maxc && tr + kr >= minr && tr + kr <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc + hstep)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + kr, tc + hstep),
                                            Y_STRIDE,
                                            sp(tc + hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + kr, tc + hstep),
                                            Y_STRIDE,
                                            sp(tc + hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_93: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_93; assignment_93; }) < besterr {
                                    besterr = second;

                                    br = tr + kr;

                                    bc = tc + hstep;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        case 1; #through;
                        case 3;
                            if tc - hstep >= minc && tc - hstep <= maxc && tr + kr >= minr && tr + kr <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc - hstep)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + kr, tc - hstep),
                                            Y_STRIDE,
                                            sp(tc - hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + kr, tc - hstep),
                                            Y_STRIDE,
                                            sp(tc - hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_94: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_94; assignment_94; }) < besterr {
                                    besterr = second;

                                    br = tr + kr;

                                    bc = tc - hstep;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                    }
                }
            }
        }
    }

    if forced_stop != 2 {
        tr = br;
        tc = bc;
        c_transpiler_compound_shr(*(hstep), (cast(s32) 1), s32, s32);
        {
            left, right, up, down, diag: u32 = ---;

            if tc - hstep >= minc && tc - hstep <= maxc && tr >= minr && tr <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc - hstep)};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr, tc - hstep),
                            Y_STRIDE,
                            sp(tc - hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr, tc - hstep),
                            Y_STRIDE,
                            sp(tc - hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_95: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (left) = assignment_95; assignment_95; }) < besterr {
                    besterr = left;

                    br = tr;

                    bc = tc - hstep;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                left = 2147483647;
            }

            if tc + hstep >= minc && tc + hstep <= maxc && tr >= minr && tr <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc + hstep)};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr, tc + hstep),
                            Y_STRIDE,
                            sp(tc + hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr, tc + hstep),
                            Y_STRIDE,
                            sp(tc + hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_96: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (right) = assignment_96; assignment_96; }) < besterr {
                    besterr = right;

                    br = tr;

                    bc = tc + hstep;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                right = 2147483647;
            }

            if tc >= minc && tc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) tc};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr - hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr - hstep),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr - hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr - hstep),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_97: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (up) = assignment_97; assignment_97; }) < besterr {
                    besterr = up;

                    br = tr - hstep;

                    bc = tc;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                up = 2147483647;
            }

            if tc >= minc && tc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) tc};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr + hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr + hstep),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr + hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr + hstep),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_98: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (down) = assignment_98; assignment_98; }) < besterr {
                    besterr = down;

                    br = tr + hstep;

                    bc = tc;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                down = 2147483647;
            }

            whichdir =
                cast,no_check(u32) ((ifx left < right then cast(s32) 0 else 1) +
                    (ifx up < down then cast(s32) 0 else 2));

            if whichdir == {
                case 0;
                    if tc - hstep >= minc && tc - hstep <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_99: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_99; assignment_99; }) < besterr {
                            besterr = diag;

                            br = tr - hstep;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 1;
                    if tc + hstep >= minc && tc + hstep <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_100: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_100; assignment_100; }) < besterr {
                            besterr = diag;

                            br = tr - hstep;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 2;
                    if tc - hstep >= minc && tc - hstep <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_101: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_101; assignment_101; }) < besterr {
                            besterr = diag;

                            br = tr + hstep;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 3;
                    if tc + hstep >= minc && tc + hstep <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_102: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_102; assignment_102; }) < besterr {
                            besterr = diag;

                            br = tr + hstep;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
            }
        }
        if QUARTERITERS > 1 {
            {
                kr, kc: s32 = ---;

                second: u32 = ---;

                if tr != br && tc != bc {
                    kr = br - tr;

                    kc = bc - tc;

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr + kr >= minr && tr + kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + kr, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + kr, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_103: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_103; assignment_103; }) < besterr {
                            besterr = second;

                            br = tr + kr;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc + kc >= minc && tc + kc <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc + kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + kc),
                                    Y_STRIDE,
                                    sp(tc + kc),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + kc),
                                    Y_STRIDE,
                                    sp(tc + kc),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_104: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_104; assignment_104; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc + kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }
                } else if tr == br && tc != bc {
                    kc = bc - tc;

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_105: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_105; assignment_105; }) < besterr {
                            besterr = second;

                            br = tr + hstep;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_106: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_106; assignment_106; }) < besterr {
                            besterr = second;

                            br = tr - hstep;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if whichdir == {
                        case 0; #through;
                        case 1;
                            if tc + kc >= minc && tc + kc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + kc)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr + hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr + hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_107: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_107; assignment_107; }) < besterr {
                                    besterr = second;

                                    br = tr + hstep;

                                    bc = tc + kc;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        case 2; #through;
                        case 3;
                            if tc + kc >= minc && tc + kc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + kc)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr - hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr - hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr - hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr - hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_108: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_108; assignment_108; }) < besterr {
                                    besterr = second;

                                    br = tr - hstep;

                                    bc = tc + kc;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                    }
                } else if tr != br && tc == bc {
                    kr = br - tr;

                    if tc + hstep >= minc && tc + hstep <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_109: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_109; assignment_109; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc - hstep >= minc && tc - hstep <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_110: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_110; assignment_110; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if whichdir == {
                        case 0; #through;
                        case 2;
                            if tc + hstep >= minc && tc + hstep <= maxc && tr + kr >= minr && tr + kr <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc + hstep)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + kr, tc + hstep),
                                            Y_STRIDE,
                                            sp(tc + hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + kr, tc + hstep),
                                            Y_STRIDE,
                                            sp(tc + hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_111: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_111; assignment_111; }) < besterr {
                                    besterr = second;

                                    br = tr + kr;

                                    bc = tc + hstep;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        case 1; #through;
                        case 3;
                            if tc - hstep >= minc && tc - hstep <= maxc && tr + kr >= minr && tr + kr <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc - hstep)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + kr, tc - hstep),
                                            Y_STRIDE,
                                            sp(tc - hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + kr, tc - hstep),
                                            Y_STRIDE,
                                            sp(tc - hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_112: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_112; assignment_112; }) < besterr {
                                    besterr = second;

                                    br = tr + kr;

                                    bc = tc - hstep;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                    }
                }
            }
        }
    }

    if allow_hp != 0 && use_mv_hp_in_vp9_mcomp(ref_mv) != 0 && forced_stop == 0 {
        tr = br;
        tc = bc;
        c_transpiler_compound_shr(*(hstep), (cast(s32) 1), s32, s32);
        {
            left, right, up, down, diag: u32 = ---;

            if tc - hstep >= minc && tc - hstep <= maxc && tr >= minr && tr <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc - hstep)};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr, tc - hstep),
                            Y_STRIDE,
                            sp(tc - hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr, tc - hstep),
                            Y_STRIDE,
                            sp(tc - hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_113: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (left) = assignment_113; assignment_113; }) < besterr {
                    besterr = left;

                    br = tr;

                    bc = tc - hstep;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                left = 2147483647;
            }

            if tc + hstep >= minc && tc + hstep <= maxc && tr >= minr && tr <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc + hstep)};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr, tc + hstep),
                            Y_STRIDE,
                            sp(tc + hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr, tc + hstep),
                            Y_STRIDE,
                            sp(tc + hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_114: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (right) = assignment_114; assignment_114; }) < besterr {
                    besterr = right;

                    br = tr;

                    bc = tc + hstep;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                right = 2147483647;
            }

            if tc >= minc && tc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) tc};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr - hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr - hstep),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr - hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr - hstep),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_115: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (up) = assignment_115; assignment_115; }) < besterr {
                    besterr = up;

                    br = tr - hstep;

                    bc = tc;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                up = 2147483647;
            }

            if tc >= minc && tc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) tc};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr + hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr + hstep),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr + hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr + hstep),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_116: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (down) = assignment_116; assignment_116; }) < besterr {
                    besterr = down;

                    br = tr + hstep;

                    bc = tc;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                down = 2147483647;
            }

            whichdir =
                cast,no_check(u32) ((ifx left < right then cast(s32) 0 else 1) +
                    (ifx up < down then cast(s32) 0 else 2));

            if whichdir == {
                case 0;
                    if tc - hstep >= minc && tc - hstep <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_117: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_117; assignment_117; }) < besterr {
                            besterr = diag;

                            br = tr - hstep;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 1;
                    if tc + hstep >= minc && tc + hstep <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_118: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_118; assignment_118; }) < besterr {
                            besterr = diag;

                            br = tr - hstep;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 2;
                    if tc - hstep >= minc && tc - hstep <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_119: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_119; assignment_119; }) < besterr {
                            besterr = diag;

                            br = tr + hstep;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 3;
                    if tc + hstep >= minc && tc + hstep <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_120: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_120; assignment_120; }) < besterr {
                            besterr = diag;

                            br = tr + hstep;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
            }
        }
        if EIGHTHITERS > 1 {
            {
                kr, kc: s32 = ---;

                second: u32 = ---;

                if tr != br && tc != bc {
                    kr = br - tr;

                    kc = bc - tc;

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr + kr >= minr && tr + kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + kr, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + kr, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_121: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_121; assignment_121; }) < besterr {
                            besterr = second;

                            br = tr + kr;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc + kc >= minc && tc + kc <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc + kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + kc),
                                    Y_STRIDE,
                                    sp(tc + kc),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + kc),
                                    Y_STRIDE,
                                    sp(tc + kc),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_122: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_122; assignment_122; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc + kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }
                } else if tr == br && tc != bc {
                    kc = bc - tc;

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_123: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_123; assignment_123; }) < besterr {
                            besterr = second;

                            br = tr + hstep;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_124: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_124; assignment_124; }) < besterr {
                            besterr = second;

                            br = tr - hstep;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if whichdir == {
                        case 0; #through;
                        case 1;
                            if tc + kc >= minc && tc + kc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + kc)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr + hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr + hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_125: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_125; assignment_125; }) < besterr {
                                    besterr = second;

                                    br = tr + hstep;

                                    bc = tc + kc;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        case 2; #through;
                        case 3;
                            if tc + kc >= minc && tc + kc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + kc)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr - hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr - hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr - hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr - hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_126: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_126; assignment_126; }) < besterr {
                                    besterr = second;

                                    br = tr - hstep;

                                    bc = tc + kc;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                    }
                } else if tr != br && tc == bc {
                    kr = br - tr;

                    if tc + hstep >= minc && tc + hstep <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_127: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_127; assignment_127; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc - hstep >= minc && tc - hstep <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_128: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_128; assignment_128; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if whichdir == {
                        case 0; #through;
                        case 2;
                            if tc + hstep >= minc && tc + hstep <= maxc && tr + kr >= minr && tr + kr <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc + hstep)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + kr, tc + hstep),
                                            Y_STRIDE,
                                            sp(tc + hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + kr, tc + hstep),
                                            Y_STRIDE,
                                            sp(tc + hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_129: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_129; assignment_129; }) < besterr {
                                    besterr = second;

                                    br = tr + kr;

                                    bc = tc + hstep;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        case 1; #through;
                        case 3;
                            if tc - hstep >= minc && tc - hstep <= maxc && tr + kr >= minr && tr + kr <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc - hstep)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + kr, tc - hstep),
                                            Y_STRIDE,
                                            sp(tc - hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + kr, tc - hstep),
                                            Y_STRIDE,
                                            sp(tc - hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_130: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_130; assignment_130; }) < besterr {
                                    besterr = second;

                                    br = tr + kr;

                                    bc = tc - hstep;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                    }
                }
            }
        }
    }

    bestmv.row = cast,no_check(s16) br;
    bestmv.col = cast,no_check(s16) bc;

    return besterr;
}

get_cost_surf_min :: (cost_list: *s32, ir: *s32, ic: *s32, bits: s32) {
    X0 := (cast,no_check(s64) cost_list[1]) - cast(s64) cost_list[3];
    Y0 := ((cast(s64) cost_list[1]) - 2 * cast,no_check(s64) cost_list[0]) + cast(s64) cost_list[3];
    X1 := (cast,no_check(s64) cost_list[4]) - cast(s64) cost_list[2];
    Y1 := ((cast(s64) cost_list[4]) - 2 * cast,no_check(s64) cost_list[0]) + cast(s64) cost_list[2];
    B := (cast(s32) 1) << (((bits - 1)) & 31);
    ic.* = cast,no_check(s32) divide_and_round(X0 * cast(s64) B, Y0);
    ir.* = cast,no_check(s32) divide_and_round(X1 * cast(s64) B, Y1);
}

divide_and_round :: (N: s64, D: s64) -> s64 {
    return ifx (cast(s32) (N < 0)) ^ cast(s32) (D < 0) != 0 then (N - D / 2) / D else (N + D / 2) / D;
}

is_cost_list_wellbehaved :: (cost_list: *s32) -> s32 {
    if cost_list[0] < cost_list[1] && cost_list[0] < cost_list[2] && cost_list[0] < cost_list[3] && cost_list[0] < cost_list[4] {
        return 1;
    }
    return 0;
}

vp9_find_best_sub_pixel_tree_pruned_evenmore :: (
    x: *MACROBLOCK,
    bestmv: *MV,
    ref_mv: *MV,
    allow_hp: s32,
    error_per_bit: s32,
    vfp: *Vp9_Variance_Fn_Ptr_T,
    forced_stop: s32,
    iters_per_step: s32,
    cost_list: *s32,
    mvjcost: *s32,
    mvcost: **s32,
    distortion: *u32,
    sse1: *u32,
    second_pred: *u8,
    w: s32,
    h: s32,
    use_accurate_subpel_search: s32
) -> u32 {
    Z := x.plane[0].src.buf;

    SRC_STRIDE := x.plane[0].src.stride;

    xd := *x.e_mbd;

    besterr: u32 = (cast,no_check(u32) (2147483647)) * 2 + 1;

    sse: u32 = ---;

    whichdir: u32 = ---;

    thismse: s32 = ---;

    HALFITERS := cast,no_check(u32) iters_per_step;

    QUARTERITERS := cast,no_check(u32) iters_per_step;

    EIGHTHITERS := cast,no_check(u32) iters_per_step;

    Y_STRIDE := xd.plane[0].pre[0].stride;

    OFFSET := (cast(s32) bestmv.row) * Y_STRIDE + cast(s32) bestmv.col;

    Y := xd.plane[0].pre[0].buf;

    rr := cast,no_check(s32) ref_mv.row;

    rc := cast,no_check(s32) ref_mv.col;

    br := (cast(s32) bestmv.row) * 8;

    bc := (cast(s32) bestmv.col) * 8;

    hstep: s32 = 4;

    tr := br;

    tc := bc;

    subpel_mv_limits: Mv_Limits = ---;

    vp9_set_subpel_mv_search_range(*subpel_mv_limits, *x.mv_limits, ref_mv);

    minc := subpel_mv_limits.col_min;

    maxc := subpel_mv_limits.col_max;

    minr := subpel_mv_limits.row_min;

    maxr := subpel_mv_limits.row_max;

    bestmv.row = cast,no_check(s16) ((cast,no_check(s32) bestmv.row) * 8);

    bestmv.col = cast,no_check(s16) ((cast,no_check(s32) bestmv.col) * 8);
    besterr =
        setup_center_error(
            xd,
            bestmv,
            ref_mv,
            error_per_bit,
            vfp,
            Z,
            SRC_STRIDE,
            Y,
            Y_STRIDE,
            second_pred,
            w,
            h,
            OFFSET,
            mvjcost,
            mvcost,
            sse1,
            distortion
        );

    if cost_list != null &&
        cost_list[0] != 2147483647 &&
        cost_list[1] != 2147483647 &&
        cost_list[2] != 2147483647 &&
        cost_list[3] != 2147483647 &&
        cost_list[4] != 2147483647 &&
        is_cost_list_wellbehaved(cost_list) != 0 {
        ir, ic: s32 = ---;
        minpt: u32 = 2147483647;
        get_cost_surf_min(cost_list, *ir, *ic, 2);
        if ir != 0 || ic != 0 {
            if tc + 2 * ic >= minc && tc + 2 * ic <= maxc && tr + 2 * ir >= minr && tr + 2 * ir <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * ir), col = cast,no_check(s16) (tc + 2 * ic)};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr + 2 * ir, tc + 2 * ic),
                            Y_STRIDE,
                            sp(tc + 2 * ic),
                            sp(tr + 2 * ir),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr + 2 * ir, tc + 2 * ic),
                            Y_STRIDE,
                            sp(tc + 2 * ic),
                            sp(tr + 2 * ir),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_131: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (minpt) = assignment_131; assignment_131; }) < besterr {
                    besterr = minpt;

                    br = tr + 2 * ir;

                    bc = tc + 2 * ic;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                minpt = 2147483647;
            }
        }
    } else {
        {
            left, right, up, down, diag: u32 = ---;

            if tc - hstep >= minc && tc - hstep <= maxc && tr >= minr && tr <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc - hstep)};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr, tc - hstep),
                            Y_STRIDE,
                            sp(tc - hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr, tc - hstep),
                            Y_STRIDE,
                            sp(tc - hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_132: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (left) = assignment_132; assignment_132; }) < besterr {
                    besterr = left;

                    br = tr;

                    bc = tc - hstep;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                left = 2147483647;
            }

            if tc + hstep >= minc && tc + hstep <= maxc && tr >= minr && tr <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc + hstep)};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr, tc + hstep),
                            Y_STRIDE,
                            sp(tc + hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr, tc + hstep),
                            Y_STRIDE,
                            sp(tc + hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_133: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (right) = assignment_133; assignment_133; }) < besterr {
                    besterr = right;

                    br = tr;

                    bc = tc + hstep;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                right = 2147483647;
            }

            if tc >= minc && tc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) tc};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr - hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr - hstep),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr - hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr - hstep),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_134: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (up) = assignment_134; assignment_134; }) < besterr {
                    besterr = up;

                    br = tr - hstep;

                    bc = tc;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                up = 2147483647;
            }

            if tc >= minc && tc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) tc};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr + hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr + hstep),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr + hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr + hstep),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_135: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (down) = assignment_135; assignment_135; }) < besterr {
                    besterr = down;

                    br = tr + hstep;

                    bc = tc;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                down = 2147483647;
            }

            whichdir =
                cast,no_check(u32) ((ifx left < right then cast(s32) 0 else 1) +
                    (ifx up < down then cast(s32) 0 else 2));

            if whichdir == {
                case 0;
                    if tc - hstep >= minc && tc - hstep <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_136: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_136; assignment_136; }) < besterr {
                            besterr = diag;

                            br = tr - hstep;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 1;
                    if tc + hstep >= minc && tc + hstep <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_137: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_137; assignment_137; }) < besterr {
                            besterr = diag;

                            br = tr - hstep;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 2;
                    if tc - hstep >= minc && tc - hstep <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_138: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_138; assignment_138; }) < besterr {
                            besterr = diag;

                            br = tr + hstep;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 3;
                    if tc + hstep >= minc && tc + hstep <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_139: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_139; assignment_139; }) < besterr {
                            besterr = diag;

                            br = tr + hstep;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
            }
        }
        if HALFITERS > 1 {
            {
                kr, kc: s32 = ---;

                second: u32 = ---;

                if tr != br && tc != bc {
                    kr = br - tr;

                    kc = bc - tc;

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr + kr >= minr && tr + kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + kr, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + kr, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_140: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_140; assignment_140; }) < besterr {
                            besterr = second;

                            br = tr + kr;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc + kc >= minc && tc + kc <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc + kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + kc),
                                    Y_STRIDE,
                                    sp(tc + kc),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + kc),
                                    Y_STRIDE,
                                    sp(tc + kc),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_141: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_141; assignment_141; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc + kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }
                } else if tr == br && tc != bc {
                    kc = bc - tc;

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_142: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_142; assignment_142; }) < besterr {
                            besterr = second;

                            br = tr + hstep;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_143: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_143; assignment_143; }) < besterr {
                            besterr = second;

                            br = tr - hstep;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if whichdir == {
                        case 0; #through;
                        case 1;
                            if tc + kc >= minc && tc + kc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + kc)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr + hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr + hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_144: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_144; assignment_144; }) < besterr {
                                    besterr = second;

                                    br = tr + hstep;

                                    bc = tc + kc;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        case 2; #through;
                        case 3;
                            if tc + kc >= minc && tc + kc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + kc)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr - hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr - hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr - hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr - hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_145: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_145; assignment_145; }) < besterr {
                                    besterr = second;

                                    br = tr - hstep;

                                    bc = tc + kc;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                    }
                } else if tr != br && tc == bc {
                    kr = br - tr;

                    if tc + hstep >= minc && tc + hstep <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_146: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_146; assignment_146; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc - hstep >= minc && tc - hstep <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_147: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_147; assignment_147; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if whichdir == {
                        case 0; #through;
                        case 2;
                            if tc + hstep >= minc && tc + hstep <= maxc && tr + kr >= minr && tr + kr <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc + hstep)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + kr, tc + hstep),
                                            Y_STRIDE,
                                            sp(tc + hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + kr, tc + hstep),
                                            Y_STRIDE,
                                            sp(tc + hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_148: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_148; assignment_148; }) < besterr {
                                    besterr = second;

                                    br = tr + kr;

                                    bc = tc + hstep;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        case 1; #through;
                        case 3;
                            if tc - hstep >= minc && tc - hstep <= maxc && tr + kr >= minr && tr + kr <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc - hstep)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + kr, tc - hstep),
                                            Y_STRIDE,
                                            sp(tc - hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + kr, tc - hstep),
                                            Y_STRIDE,
                                            sp(tc - hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_149: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_149; assignment_149; }) < besterr {
                                    besterr = second;

                                    br = tr + kr;

                                    bc = tc - hstep;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                    }
                }
            }
        }

        tr = br;
        tc = bc;

        if forced_stop != 2 {
            c_transpiler_compound_shr(*(hstep), (cast(s32) 1), s32, s32);
            {
                left, right, up, down, diag: u32 = ---;

                if tc - hstep >= minc && tc - hstep <= maxc && tr >= minr && tr <= maxr {
                    CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc - hstep)};

                    CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                    if second_pred == null {
                        thismse =
                            cast,no_check(s32) vfp.svf(
                                pre(Y, Y_STRIDE, tr, tc - hstep),
                                Y_STRIDE,
                                sp(tc - hstep),
                                sp(tr),
                                Z,
                                SRC_STRIDE,
                                *sse
                            );
                    } else {
                        thismse =
                            cast,no_check(s32) vfp.svaf(
                                pre(Y, Y_STRIDE, tr, tc - hstep),
                                Y_STRIDE,
                                sp(tc - hstep),
                                sp(tr),
                                Z,
                                SRC_STRIDE,
                                *sse,
                                second_pred
                            );
                    }

                    if (ifx true { assignment_150: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (left) = assignment_150; assignment_150; }) < besterr {
                        besterr = left;

                        br = tr;

                        bc = tc - hstep;

                        distortion.* = cast,no_check(u32) thismse;

                        sse1.* = sse;
                    }
                } else {
                    left = 2147483647;
                }

                if tc + hstep >= minc && tc + hstep <= maxc && tr >= minr && tr <= maxr {
                    CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc + hstep)};

                    CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                    if second_pred == null {
                        thismse =
                            cast,no_check(s32) vfp.svf(
                                pre(Y, Y_STRIDE, tr, tc + hstep),
                                Y_STRIDE,
                                sp(tc + hstep),
                                sp(tr),
                                Z,
                                SRC_STRIDE,
                                *sse
                            );
                    } else {
                        thismse =
                            cast,no_check(s32) vfp.svaf(
                                pre(Y, Y_STRIDE, tr, tc + hstep),
                                Y_STRIDE,
                                sp(tc + hstep),
                                sp(tr),
                                Z,
                                SRC_STRIDE,
                                *sse,
                                second_pred
                            );
                    }

                    if (ifx true { assignment_151: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (right) = assignment_151; assignment_151; }) < besterr {
                        besterr = right;

                        br = tr;

                        bc = tc + hstep;

                        distortion.* = cast,no_check(u32) thismse;

                        sse1.* = sse;
                    }
                } else {
                    right = 2147483647;
                }

                if tc >= minc && tc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                    CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) tc};

                    CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                    if second_pred == null {
                        thismse =
                            cast,no_check(s32) vfp.svf(
                                pre(Y, Y_STRIDE, tr - hstep, tc),
                                Y_STRIDE,
                                sp(tc),
                                sp(tr - hstep),
                                Z,
                                SRC_STRIDE,
                                *sse
                            );
                    } else {
                        thismse =
                            cast,no_check(s32) vfp.svaf(
                                pre(Y, Y_STRIDE, tr - hstep, tc),
                                Y_STRIDE,
                                sp(tc),
                                sp(tr - hstep),
                                Z,
                                SRC_STRIDE,
                                *sse,
                                second_pred
                            );
                    }

                    if (ifx true { assignment_152: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (up) = assignment_152; assignment_152; }) < besterr {
                        besterr = up;

                        br = tr - hstep;

                        bc = tc;

                        distortion.* = cast,no_check(u32) thismse;

                        sse1.* = sse;
                    }
                } else {
                    up = 2147483647;
                }

                if tc >= minc && tc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                    CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) tc};

                    CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                    if second_pred == null {
                        thismse =
                            cast,no_check(s32) vfp.svf(
                                pre(Y, Y_STRIDE, tr + hstep, tc),
                                Y_STRIDE,
                                sp(tc),
                                sp(tr + hstep),
                                Z,
                                SRC_STRIDE,
                                *sse
                            );
                    } else {
                        thismse =
                            cast,no_check(s32) vfp.svaf(
                                pre(Y, Y_STRIDE, tr + hstep, tc),
                                Y_STRIDE,
                                sp(tc),
                                sp(tr + hstep),
                                Z,
                                SRC_STRIDE,
                                *sse,
                                second_pred
                            );
                    }

                    if (ifx true { assignment_153: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (down) = assignment_153; assignment_153; }) < besterr {
                        besterr = down;

                        br = tr + hstep;

                        bc = tc;

                        distortion.* = cast,no_check(u32) thismse;

                        sse1.* = sse;
                    }
                } else {
                    down = 2147483647;
                }

                whichdir =
                    cast,no_check(u32) ((ifx left < right then cast(s32) 0 else 1) +
                        (ifx up < down then cast(s32) 0 else 2));

                if whichdir == {
                    case 0;
                        if tc - hstep >= minc && tc - hstep <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                            CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc - hstep)};

                            CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                            if second_pred == null {
                                thismse =
                                    cast,no_check(s32) vfp.svf(
                                        pre(Y, Y_STRIDE, tr - hstep, tc - hstep),
                                        Y_STRIDE,
                                        sp(tc - hstep),
                                        sp(tr - hstep),
                                        Z,
                                        SRC_STRIDE,
                                        *sse
                                    );
                            } else {
                                thismse =
                                    cast,no_check(s32) vfp.svaf(
                                        pre(Y, Y_STRIDE, tr - hstep, tc - hstep),
                                        Y_STRIDE,
                                        sp(tc - hstep),
                                        sp(tr - hstep),
                                        Z,
                                        SRC_STRIDE,
                                        *sse,
                                        second_pred
                                    );
                            }

                            if (ifx true { assignment_154: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_154; assignment_154; }) < besterr {
                                besterr = diag;

                                br = tr - hstep;

                                bc = tc - hstep;

                                distortion.* = cast,no_check(u32) thismse;

                                sse1.* = sse;
                            }
                        } else {
                            diag = 2147483647;
                        }
                    case 1;
                        if tc + hstep >= minc && tc + hstep <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                            CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + hstep)};

                            CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                            if second_pred == null {
                                thismse =
                                    cast,no_check(s32) vfp.svf(
                                        pre(Y, Y_STRIDE, tr - hstep, tc + hstep),
                                        Y_STRIDE,
                                        sp(tc + hstep),
                                        sp(tr - hstep),
                                        Z,
                                        SRC_STRIDE,
                                        *sse
                                    );
                            } else {
                                thismse =
                                    cast,no_check(s32) vfp.svaf(
                                        pre(Y, Y_STRIDE, tr - hstep, tc + hstep),
                                        Y_STRIDE,
                                        sp(tc + hstep),
                                        sp(tr - hstep),
                                        Z,
                                        SRC_STRIDE,
                                        *sse,
                                        second_pred
                                    );
                            }

                            if (ifx true { assignment_155: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_155; assignment_155; }) < besterr {
                                besterr = diag;

                                br = tr - hstep;

                                bc = tc + hstep;

                                distortion.* = cast,no_check(u32) thismse;

                                sse1.* = sse;
                            }
                        } else {
                            diag = 2147483647;
                        }
                    case 2;
                        if tc - hstep >= minc && tc - hstep <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                            CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc - hstep)};

                            CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                            if second_pred == null {
                                thismse =
                                    cast,no_check(s32) vfp.svf(
                                        pre(Y, Y_STRIDE, tr + hstep, tc - hstep),
                                        Y_STRIDE,
                                        sp(tc - hstep),
                                        sp(tr + hstep),
                                        Z,
                                        SRC_STRIDE,
                                        *sse
                                    );
                            } else {
                                thismse =
                                    cast,no_check(s32) vfp.svaf(
                                        pre(Y, Y_STRIDE, tr + hstep, tc - hstep),
                                        Y_STRIDE,
                                        sp(tc - hstep),
                                        sp(tr + hstep),
                                        Z,
                                        SRC_STRIDE,
                                        *sse,
                                        second_pred
                                    );
                            }

                            if (ifx true { assignment_156: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_156; assignment_156; }) < besterr {
                                besterr = diag;

                                br = tr + hstep;

                                bc = tc - hstep;

                                distortion.* = cast,no_check(u32) thismse;

                                sse1.* = sse;
                            }
                        } else {
                            diag = 2147483647;
                        }
                    case 3;
                        if tc + hstep >= minc && tc + hstep <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                            CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + hstep)};

                            CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                            if second_pred == null {
                                thismse =
                                    cast,no_check(s32) vfp.svf(
                                        pre(Y, Y_STRIDE, tr + hstep, tc + hstep),
                                        Y_STRIDE,
                                        sp(tc + hstep),
                                        sp(tr + hstep),
                                        Z,
                                        SRC_STRIDE,
                                        *sse
                                    );
                            } else {
                                thismse =
                                    cast,no_check(s32) vfp.svaf(
                                        pre(Y, Y_STRIDE, tr + hstep, tc + hstep),
                                        Y_STRIDE,
                                        sp(tc + hstep),
                                        sp(tr + hstep),
                                        Z,
                                        SRC_STRIDE,
                                        *sse,
                                        second_pred
                                    );
                            }

                            if (ifx true { assignment_157: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_157; assignment_157; }) < besterr {
                                besterr = diag;

                                br = tr + hstep;

                                bc = tc + hstep;

                                distortion.* = cast,no_check(u32) thismse;

                                sse1.* = sse;
                            }
                        } else {
                            diag = 2147483647;
                        }
                }
            }
            if QUARTERITERS > 1 {
                {
                    kr, kc: s32 = ---;

                    second: u32 = ---;

                    if tr != br && tc != bc {
                        kr = br - tr;

                        kc = bc - tc;

                        if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr + kr >= minr && tr + kr <= maxr {
                            CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc + 2 * kc)};

                            CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                            if second_pred == null {
                                thismse =
                                    cast,no_check(s32) vfp.svf(
                                        pre(Y, Y_STRIDE, tr + kr, tc + 2 * kc),
                                        Y_STRIDE,
                                        sp(tc + 2 * kc),
                                        sp(tr + kr),
                                        Z,
                                        SRC_STRIDE,
                                        *sse
                                    );
                            } else {
                                thismse =
                                    cast,no_check(s32) vfp.svaf(
                                        pre(Y, Y_STRIDE, tr + kr, tc + 2 * kc),
                                        Y_STRIDE,
                                        sp(tc + 2 * kc),
                                        sp(tr + kr),
                                        Z,
                                        SRC_STRIDE,
                                        *sse,
                                        second_pred
                                    );
                            }

                            if (ifx true { assignment_158: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_158; assignment_158; }) < besterr {
                                besterr = second;

                                br = tr + kr;

                                bc = tc + 2 * kc;

                                distortion.* = cast,no_check(u32) thismse;

                                sse1.* = sse;
                            }
                        } else {
                            second = 2147483647;
                        }

                        if tc + kc >= minc && tc + kc <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                            CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc + kc)};

                            CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                            if second_pred == null {
                                thismse =
                                    cast,no_check(s32) vfp.svf(
                                        pre(Y, Y_STRIDE, tr + 2 * kr, tc + kc),
                                        Y_STRIDE,
                                        sp(tc + kc),
                                        sp(tr + 2 * kr),
                                        Z,
                                        SRC_STRIDE,
                                        *sse
                                    );
                            } else {
                                thismse =
                                    cast,no_check(s32) vfp.svaf(
                                        pre(Y, Y_STRIDE, tr + 2 * kr, tc + kc),
                                        Y_STRIDE,
                                        sp(tc + kc),
                                        sp(tr + 2 * kr),
                                        Z,
                                        SRC_STRIDE,
                                        *sse,
                                        second_pred
                                    );
                            }

                            if (ifx true { assignment_159: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_159; assignment_159; }) < besterr {
                                besterr = second;

                                br = tr + 2 * kr;

                                bc = tc + kc;

                                distortion.* = cast,no_check(u32) thismse;

                                sse1.* = sse;
                            }
                        } else {
                            second = 2147483647;
                        }
                    } else if tr == br && tc != bc {
                        kc = bc - tc;

                        if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                            CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + 2 * kc)};

                            CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                            if second_pred == null {
                                thismse =
                                    cast,no_check(s32) vfp.svf(
                                        pre(Y, Y_STRIDE, tr + hstep, tc + 2 * kc),
                                        Y_STRIDE,
                                        sp(tc + 2 * kc),
                                        sp(tr + hstep),
                                        Z,
                                        SRC_STRIDE,
                                        *sse
                                    );
                            } else {
                                thismse =
                                    cast,no_check(s32) vfp.svaf(
                                        pre(Y, Y_STRIDE, tr + hstep, tc + 2 * kc),
                                        Y_STRIDE,
                                        sp(tc + 2 * kc),
                                        sp(tr + hstep),
                                        Z,
                                        SRC_STRIDE,
                                        *sse,
                                        second_pred
                                    );
                            }

                            if (ifx true { assignment_160: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_160; assignment_160; }) < besterr {
                                besterr = second;

                                br = tr + hstep;

                                bc = tc + 2 * kc;

                                distortion.* = cast,no_check(u32) thismse;

                                sse1.* = sse;
                            }
                        } else {
                            second = 2147483647;
                        }

                        if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                            CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + 2 * kc)};

                            CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                            if second_pred == null {
                                thismse =
                                    cast,no_check(s32) vfp.svf(
                                        pre(Y, Y_STRIDE, tr - hstep, tc + 2 * kc),
                                        Y_STRIDE,
                                        sp(tc + 2 * kc),
                                        sp(tr - hstep),
                                        Z,
                                        SRC_STRIDE,
                                        *sse
                                    );
                            } else {
                                thismse =
                                    cast,no_check(s32) vfp.svaf(
                                        pre(Y, Y_STRIDE, tr - hstep, tc + 2 * kc),
                                        Y_STRIDE,
                                        sp(tc + 2 * kc),
                                        sp(tr - hstep),
                                        Z,
                                        SRC_STRIDE,
                                        *sse,
                                        second_pred
                                    );
                            }

                            if (ifx true { assignment_161: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_161; assignment_161; }) < besterr {
                                besterr = second;

                                br = tr - hstep;

                                bc = tc + 2 * kc;

                                distortion.* = cast,no_check(u32) thismse;

                                sse1.* = sse;
                            }
                        } else {
                            second = 2147483647;
                        }

                        if whichdir == {
                            case 0; #through;
                            case 1;
                                if tc + kc >= minc && tc + kc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                                    CB_MV :=
                                        MV.{row = cast,no_check(s16) (tr +
                                            hstep), col = cast,no_check(s16) (tc + kc)};

                                    CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                    if second_pred == null {
                                        thismse =
                                            cast,no_check(s32) vfp.svf(
                                                pre(Y, Y_STRIDE, tr + hstep, tc + kc),
                                                Y_STRIDE,
                                                sp(tc + kc),
                                                sp(tr + hstep),
                                                Z,
                                                SRC_STRIDE,
                                                *sse
                                            );
                                    } else {
                                        thismse =
                                            cast,no_check(s32) vfp.svaf(
                                                pre(Y, Y_STRIDE, tr + hstep, tc + kc),
                                                Y_STRIDE,
                                                sp(tc + kc),
                                                sp(tr + hstep),
                                                Z,
                                                SRC_STRIDE,
                                                *sse,
                                                second_pred
                                            );
                                    }

                                    if (ifx true { assignment_162: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_162; assignment_162; }) < besterr {
                                        besterr = second;

                                        br = tr + hstep;

                                        bc = tc + kc;

                                        distortion.* = cast,no_check(u32) thismse;

                                        sse1.* = sse;
                                    }
                                } else {
                                    second = 2147483647;
                                }
                            case 2; #through;
                            case 3;
                                if tc + kc >= minc && tc + kc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                                    CB_MV :=
                                        MV.{row = cast,no_check(s16) (tr -
                                            hstep), col = cast,no_check(s16) (tc + kc)};

                                    CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                    if second_pred == null {
                                        thismse =
                                            cast,no_check(s32) vfp.svf(
                                                pre(Y, Y_STRIDE, tr - hstep, tc + kc),
                                                Y_STRIDE,
                                                sp(tc + kc),
                                                sp(tr - hstep),
                                                Z,
                                                SRC_STRIDE,
                                                *sse
                                            );
                                    } else {
                                        thismse =
                                            cast,no_check(s32) vfp.svaf(
                                                pre(Y, Y_STRIDE, tr - hstep, tc + kc),
                                                Y_STRIDE,
                                                sp(tc + kc),
                                                sp(tr - hstep),
                                                Z,
                                                SRC_STRIDE,
                                                *sse,
                                                second_pred
                                            );
                                    }

                                    if (ifx true { assignment_163: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_163; assignment_163; }) < besterr {
                                        besterr = second;

                                        br = tr - hstep;

                                        bc = tc + kc;

                                        distortion.* = cast,no_check(u32) thismse;

                                        sse1.* = sse;
                                    }
                                } else {
                                    second = 2147483647;
                                }
                        }
                    } else if tr != br && tc == bc {
                        kr = br - tr;

                        if tc + hstep >= minc && tc + hstep <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                            CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc + hstep)};

                            CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                            if second_pred == null {
                                thismse =
                                    cast,no_check(s32) vfp.svf(
                                        pre(Y, Y_STRIDE, tr + 2 * kr, tc + hstep),
                                        Y_STRIDE,
                                        sp(tc + hstep),
                                        sp(tr + 2 * kr),
                                        Z,
                                        SRC_STRIDE,
                                        *sse
                                    );
                            } else {
                                thismse =
                                    cast,no_check(s32) vfp.svaf(
                                        pre(Y, Y_STRIDE, tr + 2 * kr, tc + hstep),
                                        Y_STRIDE,
                                        sp(tc + hstep),
                                        sp(tr + 2 * kr),
                                        Z,
                                        SRC_STRIDE,
                                        *sse,
                                        second_pred
                                    );
                            }

                            if (ifx true { assignment_164: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_164; assignment_164; }) < besterr {
                                besterr = second;

                                br = tr + 2 * kr;

                                bc = tc + hstep;

                                distortion.* = cast,no_check(u32) thismse;

                                sse1.* = sse;
                            }
                        } else {
                            second = 2147483647;
                        }

                        if tc - hstep >= minc && tc - hstep <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                            CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc - hstep)};

                            CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                            if second_pred == null {
                                thismse =
                                    cast,no_check(s32) vfp.svf(
                                        pre(Y, Y_STRIDE, tr + 2 * kr, tc - hstep),
                                        Y_STRIDE,
                                        sp(tc - hstep),
                                        sp(tr + 2 * kr),
                                        Z,
                                        SRC_STRIDE,
                                        *sse
                                    );
                            } else {
                                thismse =
                                    cast,no_check(s32) vfp.svaf(
                                        pre(Y, Y_STRIDE, tr + 2 * kr, tc - hstep),
                                        Y_STRIDE,
                                        sp(tc - hstep),
                                        sp(tr + 2 * kr),
                                        Z,
                                        SRC_STRIDE,
                                        *sse,
                                        second_pred
                                    );
                            }

                            if (ifx true { assignment_165: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_165; assignment_165; }) < besterr {
                                besterr = second;

                                br = tr + 2 * kr;

                                bc = tc - hstep;

                                distortion.* = cast,no_check(u32) thismse;

                                sse1.* = sse;
                            }
                        } else {
                            second = 2147483647;
                        }

                        if whichdir == {
                            case 0; #through;
                            case 2;
                                if tc + hstep >= minc && tc + hstep <= maxc && tr + kr >= minr && tr + kr <= maxr {
                                    CB_MV :=
                                        MV.{row = cast,no_check(s16) (tr +
                                            kr), col = cast,no_check(s16) (tc + hstep)};

                                    CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                    if second_pred == null {
                                        thismse =
                                            cast,no_check(s32) vfp.svf(
                                                pre(Y, Y_STRIDE, tr + kr, tc + hstep),
                                                Y_STRIDE,
                                                sp(tc + hstep),
                                                sp(tr + kr),
                                                Z,
                                                SRC_STRIDE,
                                                *sse
                                            );
                                    } else {
                                        thismse =
                                            cast,no_check(s32) vfp.svaf(
                                                pre(Y, Y_STRIDE, tr + kr, tc + hstep),
                                                Y_STRIDE,
                                                sp(tc + hstep),
                                                sp(tr + kr),
                                                Z,
                                                SRC_STRIDE,
                                                *sse,
                                                second_pred
                                            );
                                    }

                                    if (ifx true { assignment_166: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_166; assignment_166; }) < besterr {
                                        besterr = second;

                                        br = tr + kr;

                                        bc = tc + hstep;

                                        distortion.* = cast,no_check(u32) thismse;

                                        sse1.* = sse;
                                    }
                                } else {
                                    second = 2147483647;
                                }
                            case 1; #through;
                            case 3;
                                if tc - hstep >= minc && tc - hstep <= maxc && tr + kr >= minr && tr + kr <= maxr {
                                    CB_MV :=
                                        MV.{row = cast,no_check(s16) (tr +
                                            kr), col = cast,no_check(s16) (tc - hstep)};

                                    CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                    if second_pred == null {
                                        thismse =
                                            cast,no_check(s32) vfp.svf(
                                                pre(Y, Y_STRIDE, tr + kr, tc - hstep),
                                                Y_STRIDE,
                                                sp(tc - hstep),
                                                sp(tr + kr),
                                                Z,
                                                SRC_STRIDE,
                                                *sse
                                            );
                                    } else {
                                        thismse =
                                            cast,no_check(s32) vfp.svaf(
                                                pre(Y, Y_STRIDE, tr + kr, tc - hstep),
                                                Y_STRIDE,
                                                sp(tc - hstep),
                                                sp(tr + kr),
                                                Z,
                                                SRC_STRIDE,
                                                *sse,
                                                second_pred
                                            );
                                    }

                                    if (ifx true { assignment_167: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_167; assignment_167; }) < besterr {
                                        besterr = second;

                                        br = tr + kr;

                                        bc = tc - hstep;

                                        distortion.* = cast,no_check(u32) thismse;

                                        sse1.* = sse;
                                    }
                                } else {
                                    second = 2147483647;
                                }
                        }
                    }
                }
            }
        }
    }

    tr = br;
    tc = bc;

    if allow_hp != 0 && use_mv_hp_in_vp9_mcomp(ref_mv) != 0 && forced_stop == 0 {
        c_transpiler_compound_shr(*(hstep), (cast(s32) 1), s32, s32);
        {
            left, right, up, down, diag: u32 = ---;

            if tc - hstep >= minc && tc - hstep <= maxc && tr >= minr && tr <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc - hstep)};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr, tc - hstep),
                            Y_STRIDE,
                            sp(tc - hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr, tc - hstep),
                            Y_STRIDE,
                            sp(tc - hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_168: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (left) = assignment_168; assignment_168; }) < besterr {
                    besterr = left;

                    br = tr;

                    bc = tc - hstep;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                left = 2147483647;
            }

            if tc + hstep >= minc && tc + hstep <= maxc && tr >= minr && tr <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) tr, col = cast,no_check(s16) (tc + hstep)};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr, tc + hstep),
                            Y_STRIDE,
                            sp(tc + hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr, tc + hstep),
                            Y_STRIDE,
                            sp(tc + hstep),
                            sp(tr),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_169: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (right) = assignment_169; assignment_169; }) < besterr {
                    besterr = right;

                    br = tr;

                    bc = tc + hstep;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                right = 2147483647;
            }

            if tc >= minc && tc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) tc};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr - hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr - hstep),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr - hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr - hstep),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_170: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (up) = assignment_170; assignment_170; }) < besterr {
                    besterr = up;

                    br = tr - hstep;

                    bc = tc;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                up = 2147483647;
            }

            if tc >= minc && tc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) tc};

                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                if second_pred == null {
                    thismse =
                        cast,no_check(s32) vfp.svf(
                            pre(Y, Y_STRIDE, tr + hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr + hstep),
                            Z,
                            SRC_STRIDE,
                            *sse
                        );
                } else {
                    thismse =
                        cast,no_check(s32) vfp.svaf(
                            pre(Y, Y_STRIDE, tr + hstep, tc),
                            Y_STRIDE,
                            sp(tc),
                            sp(tr + hstep),
                            Z,
                            SRC_STRIDE,
                            *sse,
                            second_pred
                        );
                }

                if (ifx true { assignment_171: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (down) = assignment_171; assignment_171; }) < besterr {
                    besterr = down;

                    br = tr + hstep;

                    bc = tc;

                    distortion.* = cast,no_check(u32) thismse;

                    sse1.* = sse;
                }
            } else {
                down = 2147483647;
            }

            whichdir =
                cast,no_check(u32) ((ifx left < right then cast(s32) 0 else 1) +
                    (ifx up < down then cast(s32) 0 else 2));

            if whichdir == {
                case 0;
                    if tc - hstep >= minc && tc - hstep <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_172: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_172; assignment_172; }) < besterr {
                            besterr = diag;

                            br = tr - hstep;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 1;
                    if tc + hstep >= minc && tc + hstep <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_173: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_173; assignment_173; }) < besterr {
                            besterr = diag;

                            br = tr - hstep;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 2;
                    if tc - hstep >= minc && tc - hstep <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_174: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_174; assignment_174; }) < besterr {
                            besterr = diag;

                            br = tr + hstep;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
                case 3;
                    if tc + hstep >= minc && tc + hstep <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_175: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (diag) = assignment_175; assignment_175; }) < besterr {
                            besterr = diag;

                            br = tr + hstep;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        diag = 2147483647;
                    }
            }
        }
        if EIGHTHITERS > 1 {
            {
                kr, kc: s32 = ---;

                second: u32 = ---;

                if tr != br && tc != bc {
                    kr = br - tr;

                    kc = bc - tc;

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr + kr >= minr && tr + kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + kr, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + kr, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_176: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_176; assignment_176; }) < besterr {
                            besterr = second;

                            br = tr + kr;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc + kc >= minc && tc + kc <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc + kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + kc),
                                    Y_STRIDE,
                                    sp(tc + kc),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + kc),
                                    Y_STRIDE,
                                    sp(tc + kc),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_177: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_177; assignment_177; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc + kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }
                } else if tr == br && tc != bc {
                    kc = bc - tc;

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr + hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_178: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_178; assignment_178; }) < besterr {
                            besterr = second;

                            br = tr + hstep;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc + 2 * kc >= minc && tc + 2 * kc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + 2 * kc)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr - hstep, tc + 2 * kc),
                                    Y_STRIDE,
                                    sp(tc + 2 * kc),
                                    sp(tr - hstep),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_179: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_179; assignment_179; }) < besterr {
                            besterr = second;

                            br = tr - hstep;

                            bc = tc + 2 * kc;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if whichdir == {
                        case 0; #through;
                        case 1;
                            if tc + kc >= minc && tc + kc <= maxc && tr + hstep >= minr && tr + hstep <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + hstep), col = cast,no_check(s16) (tc + kc)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr + hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr + hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_180: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_180; assignment_180; }) < besterr {
                                    besterr = second;

                                    br = tr + hstep;

                                    bc = tc + kc;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        case 2; #through;
                        case 3;
                            if tc + kc >= minc && tc + kc <= maxc && tr - hstep >= minr && tr - hstep <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr - hstep), col = cast,no_check(s16) (tc + kc)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr - hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr - hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr - hstep, tc + kc),
                                            Y_STRIDE,
                                            sp(tc + kc),
                                            sp(tr - hstep),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_181: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_181; assignment_181; }) < besterr {
                                    besterr = second;

                                    br = tr - hstep;

                                    bc = tc + kc;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                    }
                } else if tr != br && tc == bc {
                    kr = br - tr;

                    if tc + hstep >= minc && tc + hstep <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc + hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc + hstep),
                                    Y_STRIDE,
                                    sp(tc + hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_182: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_182; assignment_182; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc + hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if tc - hstep >= minc && tc - hstep <= maxc && tr + 2 * kr >= minr && tr + 2 * kr <= maxr {
                        CB_MV := MV.{row = cast,no_check(s16) (tr + 2 * kr), col = cast,no_check(s16) (tc - hstep)};

                        CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                        if second_pred == null {
                            thismse =
                                cast,no_check(s32) vfp.svf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse
                                );
                        } else {
                            thismse =
                                cast,no_check(s32) vfp.svaf(
                                    pre(Y, Y_STRIDE, tr + 2 * kr, tc - hstep),
                                    Y_STRIDE,
                                    sp(tc - hstep),
                                    sp(tr + 2 * kr),
                                    Z,
                                    SRC_STRIDE,
                                    *sse,
                                    second_pred
                                );
                        }

                        if (ifx true { assignment_183: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_183; assignment_183; }) < besterr {
                            besterr = second;

                            br = tr + 2 * kr;

                            bc = tc - hstep;

                            distortion.* = cast,no_check(u32) thismse;

                            sse1.* = sse;
                        }
                    } else {
                        second = 2147483647;
                    }

                    if whichdir == {
                        case 0; #through;
                        case 2;
                            if tc + hstep >= minc && tc + hstep <= maxc && tr + kr >= minr && tr + kr <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc + hstep)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + kr, tc + hstep),
                                            Y_STRIDE,
                                            sp(tc + hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + kr, tc + hstep),
                                            Y_STRIDE,
                                            sp(tc + hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_184: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_184; assignment_184; }) < besterr {
                                    besterr = second;

                                    br = tr + kr;

                                    bc = tc + hstep;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                        case 1; #through;
                        case 3;
                            if tc - hstep >= minc && tc - hstep <= maxc && tr + kr >= minr && tr + kr <= maxr {
                                CB_MV := MV.{row = cast,no_check(s16) (tr + kr), col = cast,no_check(s16) (tc - hstep)};

                                CB_REF_MV := MV.{row = cast,no_check(s16) rr, col = cast,no_check(s16) rc};

                                if second_pred == null {
                                    thismse =
                                        cast,no_check(s32) vfp.svf(
                                            pre(Y, Y_STRIDE, tr + kr, tc - hstep),
                                            Y_STRIDE,
                                            sp(tc - hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse
                                        );
                                } else {
                                    thismse =
                                        cast,no_check(s32) vfp.svaf(
                                            pre(Y, Y_STRIDE, tr + kr, tc - hstep),
                                            Y_STRIDE,
                                            sp(tc - hstep),
                                            sp(tr + kr),
                                            Z,
                                            SRC_STRIDE,
                                            *sse,
                                            second_pred
                                        );
                                }

                                if (ifx true { assignment_185: u32 = cast,no_check(u32) (cast,no_check(u32) (mv_err_cost_in_vp9_mcomp(*CB_MV, *CB_REF_MV, mvjcost, mvcost, error_per_bit) + thismse)); (second) = assignment_185; assignment_185; }) < besterr {
                                    besterr = second;

                                    br = tr + kr;

                                    bc = tc - hstep;

                                    distortion.* = cast,no_check(u32) thismse;

                                    sse1.* = sse;
                                }
                            } else {
                                second = 2147483647;
                            }
                    }
                }
            }
        }
    }

    bestmv.row = cast,no_check(s16) br;
    bestmv.col = cast,no_check(s16) bc;

    return besterr;
}

vp9_skip_sub_pixel_tree :: (
    x: *MACROBLOCK,
    bestmv: *MV,
    ref_mv: *MV,
    allow_hp: s32,
    error_per_bit: s32,
    vfp: *Vp9_Variance_Fn_Ptr_T,
    forced_stop: s32,
    iters_per_step: s32,
    cost_list: *s32,
    mvjcost: *s32,
    mvcost: **s32,
    distortion: *u32,
    sse1: *u32,
    second_pred: *u8,
    w: s32,
    h: s32,
    use_accurate_subpel_search: s32
) -> u32 {
    Z := x.plane[0].src.buf;

    SRC_STRIDE := x.plane[0].src.stride;

    xd := *x.e_mbd;

    besterr: u32 = (cast,no_check(u32) (2147483647)) * 2 + 1;

    sse: u32 = ---;

    whichdir: u32 = ---;

    thismse: s32 = ---;

    HALFITERS := cast,no_check(u32) iters_per_step;

    QUARTERITERS := cast,no_check(u32) iters_per_step;

    EIGHTHITERS := cast,no_check(u32) iters_per_step;

    Y_STRIDE := xd.plane[0].pre[0].stride;

    OFFSET := (cast(s32) bestmv.row) * Y_STRIDE + cast(s32) bestmv.col;

    Y := xd.plane[0].pre[0].buf;

    rr := cast,no_check(s32) ref_mv.row;

    rc := cast,no_check(s32) ref_mv.col;

    br := (cast(s32) bestmv.row) * 8;

    bc := (cast(s32) bestmv.col) * 8;

    hstep: s32 = 4;

    tr := br;

    tc := bc;

    subpel_mv_limits: Mv_Limits = ---;

    vp9_set_subpel_mv_search_range(*subpel_mv_limits, *x.mv_limits, ref_mv);

    minc := subpel_mv_limits.col_min;

    maxc := subpel_mv_limits.col_max;

    minr := subpel_mv_limits.row_min;

    maxr := subpel_mv_limits.row_max;

    bestmv.row = cast,no_check(s16) ((cast,no_check(s32) bestmv.row) * 8);

    bestmv.col = cast,no_check(s16) ((cast,no_check(s32) bestmv.col) * 8);
    besterr =
        setup_center_error(
            xd,
            bestmv,
            ref_mv,
            error_per_bit,
            vfp,
            Z,
            SRC_STRIDE,
            Y,
            Y_STRIDE,
            second_pred,
            w,
            h,
            OFFSET,
            mvjcost,
            mvcost,
            sse1,
            distortion
        );

    return besterr;
}

vp9_return_max_sub_pixel_mv :: (
    x: *MACROBLOCK,
    bestmv: *MV,
    ref_mv: *MV,
    allow_hp: s32,
    error_per_bit: s32,
    vfp: *Vp9_Variance_Fn_Ptr_T,
    forced_stop: s32,
    iters_per_step: s32,
    cost_list: *s32,
    mvjcost: *s32,
    mvcost: **s32,
    distortion: *u32,
    sse1: *u32,
    second_pred: *u8,
    w: s32,
    h: s32,
    use_accurate_subpel_search: s32
) -> u32 {
    Z := x.plane[0].src.buf;

    SRC_STRIDE := x.plane[0].src.stride;

    xd := *x.e_mbd;

    besterr: u32 = (cast,no_check(u32) (2147483647)) * 2 + 1;

    sse: u32 = ---;

    whichdir: u32 = ---;

    thismse: s32 = ---;

    HALFITERS := cast,no_check(u32) iters_per_step;

    QUARTERITERS := cast,no_check(u32) iters_per_step;

    EIGHTHITERS := cast,no_check(u32) iters_per_step;

    Y_STRIDE := xd.plane[0].pre[0].stride;

    OFFSET := (cast(s32) bestmv.row) * Y_STRIDE + cast(s32) bestmv.col;

    Y := xd.plane[0].pre[0].buf;

    rr := cast,no_check(s32) ref_mv.row;

    rc := cast,no_check(s32) ref_mv.col;

    br := (cast(s32) bestmv.row) * 8;

    bc := (cast(s32) bestmv.col) * 8;

    hstep: s32 = 4;

    tr := br;

    tc := bc;

    subpel_mv_limits: Mv_Limits = ---;

    vp9_set_subpel_mv_search_range(*subpel_mv_limits, *x.mv_limits, ref_mv);

    minc := subpel_mv_limits.col_min;

    maxc := subpel_mv_limits.col_max;

    minr := subpel_mv_limits.row_min;

    maxr := subpel_mv_limits.row_max;

    bestmv.row = cast,no_check(s16) ((cast,no_check(s32) bestmv.row) * 8);

    bestmv.col = cast,no_check(s16) ((cast,no_check(s32) bestmv.col) * 8);

    bestmv.row = cast,no_check(s16) maxr;
    bestmv.col = cast,no_check(s16) maxc;
    besterr = 0;

    lower_mv_precision_in_vp9_mcomp(bestmv, cast(s32) (allow_hp != 0 && use_mv_hp_in_vp9_mcomp(ref_mv) != 0));

    return besterr;
}

vp9_return_min_sub_pixel_mv :: (
    x: *MACROBLOCK,
    bestmv: *MV,
    ref_mv: *MV,
    allow_hp: s32,
    error_per_bit: s32,
    vfp: *Vp9_Variance_Fn_Ptr_T,
    forced_stop: s32,
    iters_per_step: s32,
    cost_list: *s32,
    mvjcost: *s32,
    mvcost: **s32,
    distortion: *u32,
    sse1: *u32,
    second_pred: *u8,
    w: s32,
    h: s32,
    use_accurate_subpel_search: s32
) -> u32 {
    Z := x.plane[0].src.buf;

    SRC_STRIDE := x.plane[0].src.stride;

    xd := *x.e_mbd;

    besterr: u32 = (cast,no_check(u32) (2147483647)) * 2 + 1;

    sse: u32 = ---;

    whichdir: u32 = ---;

    thismse: s32 = ---;

    HALFITERS := cast,no_check(u32) iters_per_step;

    QUARTERITERS := cast,no_check(u32) iters_per_step;

    EIGHTHITERS := cast,no_check(u32) iters_per_step;

    Y_STRIDE := xd.plane[0].pre[0].stride;

    OFFSET := (cast(s32) bestmv.row) * Y_STRIDE + cast(s32) bestmv.col;

    Y := xd.plane[0].pre[0].buf;

    rr := cast,no_check(s32) ref_mv.row;

    rc := cast,no_check(s32) ref_mv.col;

    br := (cast(s32) bestmv.row) * 8;

    bc := (cast(s32) bestmv.col) * 8;

    hstep: s32 = 4;

    tr := br;

    tc := bc;

    subpel_mv_limits: Mv_Limits = ---;

    vp9_set_subpel_mv_search_range(*subpel_mv_limits, *x.mv_limits, ref_mv);

    minc := subpel_mv_limits.col_min;

    maxc := subpel_mv_limits.col_max;

    minr := subpel_mv_limits.row_min;

    maxr := subpel_mv_limits.row_max;

    bestmv.row = cast,no_check(s16) ((cast,no_check(s32) bestmv.row) * 8);

    bestmv.col = cast,no_check(s16) ((cast,no_check(s32) bestmv.col) * 8);

    bestmv.row = cast,no_check(s16) minr;
    bestmv.col = cast,no_check(s16) minc;
    besterr = 0;

    lower_mv_precision_in_vp9_mcomp(bestmv, cast(s32) (allow_hp != 0 && use_mv_hp_in_vp9_mcomp(ref_mv) != 0));

    return besterr;
}

vp9_refining_search_8p_c :: (
    x: *MACROBLOCK,
    ref_mv: *MV,
    error_per_bit: s32,
    search_range: s32,
    fn_ptr: *Vp9_Variance_Fn_Ptr_T,
    center_mv: *MV,
    second_pred: *u8
) -> s32 {
    NEIGHBORS :=
        MV.[
            MV.{row = -1, col = 0},
            MV.{row = 0, col = -1},
            MV.{row = 0, col = 1},
            MV.{row = 1, col = 0},
            MV.{row = -1, col = -1},
            MV.{row = 1, col = -1},
            MV.{row = -1, col = 1},
            MV.{row = 1, col = 1}
        ];
    XD := *x.e_mbd;
    WHAT := *x.plane[0].src;
    IN_WHAT := XD.plane[0].pre.data + 0;
    FCENTER_MV :=
        MV.{row = cast,no_check(s16) ((cast(s32) center_mv.row) >> 3), col = cast,no_check(s16) ((cast(s32) center_mv.col) >> 3)};
    best_sad: u32 = 2147483647;
    j: s32 = ---;
    clamp_mv_in_vp9_mcomp(ref_mv, x.mv_limits.col_min, x.mv_limits.col_max, x.mv_limits.row_min, x.mv_limits.row_max);
    best_sad =
        fn_ptr.sdaf(
            WHAT.buf,
            WHAT.stride,
            get_buf_from_mv_in_vp9_mcomp(IN_WHAT, ref_mv),
            IN_WHAT.stride,
            second_pred
        ) + cast,no_check(u32) mvsad_err_cost_in_vp9_mcomp(x, ref_mv, *FCENTER_MV, error_per_bit);

    if 0 < search_range {
        for i: 0..search_range - 1 {
            best_site: s32 = -1;

            j = 0;
            while j < 8 {
                MV_ :=
                    MV.{row = cast,no_check(s16) ((cast(s32) ref_mv.row) +
                        cast(s32) NEIGHBORS[j].row), col = cast,no_check(s16) ((cast(s32) ref_mv.col) + cast(s32) NEIGHBORS[j].col)};

                if is_mv_in(*x.mv_limits, *MV_) != 0 {
                    sad :=
                        fn_ptr.sdaf(
                            WHAT.buf,
                            WHAT.stride,
                            get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *MV_),
                            IN_WHAT.stride,
                            second_pred
                        );
                    if sad < best_sad {
                        sad += cast,no_check(u32) mvsad_err_cost_in_vp9_mcomp(x, *MV_, *FCENTER_MV, error_per_bit);
                        if sad < best_sad {
                            best_sad = sad;
                            best_site = j;
                        }
                    }
                }
                j += 1;
            }

            if best_site == -1 {
                break;
            } else {
                ref_mv.row = cast,no_check(s16) ((cast,no_check(s32) ref_mv.row) + cast,no_check(s32) NEIGHBORS[best_site].row);
                ref_mv.col = cast,no_check(s16) ((cast,no_check(s32) ref_mv.col) + cast,no_check(s32) NEIGHBORS[best_site].col);
            }
        }
    }
    return cast,no_check(s32) best_sad;
}

vp9_full_pixel_search :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    X: *MACROBLOCK,
    bsize: BLOCK_SIZE,
    mvp_full: *MV,
    step_param: s32,
    search_method: s32,
    error_per_bit: s32,
    cost_list: *s32,
    ref_mv: *MV,
    tmp_mv: *MV,
    var_max: s32,
    rd: s32
) -> s32 {
    SF := *CPI.sf;
    METHOD := cast,no_check(SEARCH_METHODS_in_vp9_cx_iface) search_method;
    fn_ptr := CPI.fn_ptr.data + bsize;
    var: s32 = 0;
    run_exhaustive_search: s32 = 0;

    if cost_list != null {
        cost_list[0] = 2147483647;
        cost_list[1] = 2147483647;
        cost_list[2] = 2147483647;
        cost_list[3] = 2147483647;
        cost_list[4] = 2147483647;
    }

    if METHOD == {
        case cast,no_check(u32) FAST_DIAMOND;
            var = fast_dia_search(X, mvp_full, step_param, error_per_bit, 0, cost_list, fn_ptr, 1, ref_mv, tmp_mv);
        case cast,no_check(u32) FAST_HEX;
            var = fast_hex_search(X, mvp_full, step_param, error_per_bit, 0, cost_list, fn_ptr, 1, ref_mv, tmp_mv);
        case cast,no_check(u32) HEX_in_vp9_cx_iface;
            var = hex_search(X, mvp_full, step_param, error_per_bit, 1, cost_list, fn_ptr, 1, ref_mv, tmp_mv);
        case cast,no_check(u32) SQUARE;
            var = square_search(X, mvp_full, step_param, error_per_bit, 1, cost_list, fn_ptr, 1, ref_mv, tmp_mv);
        case cast,no_check(u32) BIGDIA;
            var = bigdia_search(X, mvp_full, step_param, error_per_bit, 1, cost_list, fn_ptr, 1, ref_mv, tmp_mv);
        case cast,no_check(u32) NSTEP_in_vp9_cx_iface; #through;
        case cast,no_check(u32) MESH;
            var =
                full_pixel_diamond(
                    CPI,
                    X,
                    bsize,
                    mvp_full,
                    step_param,
                    error_per_bit,
                    (cast,no_check(s32) ((11 - 1))) - step_param,
                    1,
                    CPI.sf.mv.use_downsampled_sad,
                    cost_list,
                    fn_ptr,
                    ref_mv,
                    tmp_mv
                );
        case;
    }

    if METHOD == cast,no_check(u32) NSTEP_in_vp9_cx_iface {
        if SF.exhaustive_searches_thresh < 2147483647 && CPI.rc.is_src_frame_alt_ref == 0 {
            EXHAUSTIVE_THR := cast,no_check(s64) get_exhaustive_threshold(SF.exhaustive_searches_thresh, bsize);
            if cast,no_check(s64) var > EXHAUSTIVE_THR {
                run_exhaustive_search = 1;
            }
        }
    } else if METHOD == cast,no_check(u32) MESH {
        run_exhaustive_search = 1;
    }

    if run_exhaustive_search != 0 {
        tmp_mv_ex: MV = ---;
        var_ex := full_pixel_exhaustive(CPI, X, tmp_mv, error_per_bit, cost_list, fn_ptr, ref_mv, *tmp_mv_ex);
        if var_ex < var {
            var = var_ex;
            tmp_mv.* = tmp_mv_ex;
        }
    }

    if METHOD != cast,no_check(u32) NSTEP_in_vp9_cx_iface && METHOD != cast,no_check(u32) MESH && rd != 0 && var < var_max {
        var = vp9_get_mvpred_var(X, tmp_mv, ref_mv, fn_ptr, 1);
    }

    return var;
}

full_pixel_exhaustive :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    X: *MACROBLOCK,
    centre_mv_full: *MV,
    sadpb: s32,
    cost_list: *s32,
    fn_ptr: *Vp9_Variance_Fn_Ptr_T,
    ref_mv: *MV,
    dst_mv: *MV
) -> s32 {
    SF := *CPI.sf;
    temp_mv := MV.{row = centre_mv_full.row, col = centre_mv_full.col};
    f_ref_mv :=
        MV.{row = cast,no_check(s16) ((cast(s32) ref_mv.row) >> 3), col = cast,no_check(s16) ((cast(s32) ref_mv.col) >> 3)};

    interval := SF.mesh_patterns[0].interval;
    range := SF.mesh_patterns[0].range;

    if range < 7 || range > 256 || interval < 1 || interval > range {
        return 2147483647;
    }

    baseline_interval_divisor := range / interval;

    range =
        clamp_in_vp9_mcomp(
            range,
            5 *
            (ifx absolute_value(cast,no_check(s32) temp_mv.row) > absolute_value(cast,no_check(s32) temp_mv.col) then absolute_value(cast,no_check(s32) temp_mv.row) else absolute_value(cast,no_check(s32) temp_mv.col)) / 4,
            256
        );
    interval = ifx interval > range / baseline_interval_divisor then interval else range / baseline_interval_divisor;

    bestsme := exhaustive_mesh_search(X, *f_ref_mv, *temp_mv, range, interval, sadpb, fn_ptr, *temp_mv);

    if interval > 1 && range > 7 {
        if 1 < 4 {
            for i: 1..cast(s32) 4 - 1 {
                bestsme =
                    exhaustive_mesh_search(
                        X,
                        *f_ref_mv,
                        *temp_mv,
                        SF.mesh_patterns[i].range,
                        SF.mesh_patterns[i].interval,
                        sadpb,
                        fn_ptr,
                        *temp_mv
                    );

                if SF.mesh_patterns[i].interval == 1 {
                    break;
                }
            }
        }
    }

    if bestsme < 2147483647 {
        bestsme = vp9_get_mvpred_var(X, *temp_mv, ref_mv, fn_ptr, 1);
    }
    dst_mv.* = temp_mv;

    if cost_list != null {
        calc_int_cost_list(X, ref_mv, sadpb, fn_ptr, dst_mv, cost_list);
    }
    return bestsme;
}

calc_int_cost_list :: (
    x: *MACROBLOCK,
    ref_mv: *MV,
    sadpb: s32,
    fn_ptr: *Vp9_Variance_Fn_Ptr_T,
    best_mv: *MV,
    cost_list: *s32
) {
    WHAT := *x.plane[0].src;
    IN_WHAT := x.e_mbd.plane[0].pre.data + 0;
    FCENTER_MV :=
        MV.{row = cast,no_check(s16) ((cast(s32) ref_mv.row) >> 3), col = cast,no_check(s16) ((cast(s32) ref_mv.col) >> 3)};
    br := cast,no_check(s32) best_mv.row;
    bc := cast,no_check(s32) best_mv.col;
    MV_ := MV.{row = cast,no_check(s16) br, col = cast,no_check(s16) bc};

    sse: u32 = ---;

    cost_list[0] =
        cast,no_check(s32) (fn_ptr.vf(
            WHAT.buf,
            WHAT.stride,
            get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *MV_),
            IN_WHAT.stride,
            *sse
        ) + cast,no_check(u32) mvsad_err_cost_in_vp9_mcomp(x, *MV_, *FCENTER_MV, sadpb));
    if check_bounds(*x.mv_limits, br, bc, 1) != 0 {
        for i: 0..cast(s32) 4 - 1 {
            THIS_MV :=
                MV.{row = cast,no_check(s16) (br +
                    cast(s32) NEIGHBORS[i].row), col = cast,no_check(s16) (bc + cast(s32) NEIGHBORS[i].col)};
            cost_list[i + 1] =
                cast,no_check(s32) (fn_ptr.vf(
                    WHAT.buf,
                    WHAT.stride,
                    get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *THIS_MV),
                    IN_WHAT.stride,
                    *sse
                ) + cast,no_check(u32) mv_err_cost_in_vp9_mcomp(
                    *THIS_MV,
                    *FCENTER_MV,
                    x.nmvjointcost.data,
                    x.mvcost,
                    x.errorperbit
                ));
        }
    } else {
        for i: 0..cast(s32) 4 - 1 {
            THIS_MV :=
                MV.{row = cast,no_check(s16) (br +
                    cast(s32) NEIGHBORS[i].row), col = cast,no_check(s16) (bc + cast(s32) NEIGHBORS[i].col)};
            if is_mv_in(*x.mv_limits, *THIS_MV) == 0 {
                cost_list[i + 1] = 2147483647;
            } else {
                cost_list[i + 1] =
                    cast,no_check(s32) (fn_ptr.vf(
                        WHAT.buf,
                        WHAT.stride,
                        get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *THIS_MV),
                        IN_WHAT.stride,
                        *sse
                    ) + cast,no_check(u32) mv_err_cost_in_vp9_mcomp(
                        *THIS_MV,
                        *FCENTER_MV,
                        x.nmvjointcost.data,
                        x.mvcost,
                        x.errorperbit
                    ));
            }
        }
    }
}

check_bounds :: (mv_limits: *Mv_Limits, row: s32, col: s32, range: s32) -> s32 {
    return (((cast(s32) (row - range >= mv_limits.row_min)) & cast(s32) (row + range <= mv_limits.row_max)) & cast(s32) (col - range >= mv_limits.col_min)) & cast(s32) (col + range <= mv_limits.col_max);
}

exhaustive_mesh_search :: (
    x: *MACROBLOCK,
    ref_mv: *MV,
    best_mv: *MV,
    range: s32,
    step: s32,
    sad_per_bit: s32,
    fn_ptr: *Vp9_Variance_Fn_Ptr_T,
    center_mv: *MV
) -> s32 {
    XD := *x.e_mbd;
    WHAT := *x.plane[0].src;
    IN_WHAT := XD.plane[0].pre.data + 0;
    fcenter_mv := MV.{row = center_mv.row, col = center_mv.col};
    best_sad: u32 = 2147483647;
    c: s32 = ---;
    i: s32 = ---;

    col_step := (ifx step > 1 then step else 4);

    clamp_mv_in_vp9_mcomp(
        *fcenter_mv,
        x.mv_limits.col_min,
        x.mv_limits.col_max,
        x.mv_limits.row_min,
        x.mv_limits.row_max
    );
    best_mv.* = fcenter_mv;
    best_sad =
        fn_ptr.sdf(WHAT.buf, WHAT.stride, get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *fcenter_mv), IN_WHAT.stride) +
            cast,no_check(u32) mvsad_err_cost_in_vp9_mcomp(x, *fcenter_mv, ref_mv, sad_per_bit);
    start_row :=
        (ifx -range > x.mv_limits.row_min -
            cast(s32) fcenter_mv.row then -range else x.mv_limits.row_min - cast(s32) fcenter_mv.row);
    start_col :=
        (ifx -range > x.mv_limits.col_min -
            cast(s32) fcenter_mv.col then -range else x.mv_limits.col_min - cast(s32) fcenter_mv.col);
    end_row :=
        (ifx range < x.mv_limits.row_max -
            cast(s32) fcenter_mv.row then range else x.mv_limits.row_max - cast(s32) fcenter_mv.row);
    end_col :=
        (ifx range < x.mv_limits.col_max -
            cast(s32) fcenter_mv.col then range else x.mv_limits.col_max - cast(s32) fcenter_mv.col);

    r := start_row;
    while r <= end_row {
        c = start_col;
        while c <= end_col {
            if step > 1 {
                MV_ :=
                    MV.{row = cast,no_check(s16) ((cast(s32) fcenter_mv.row) +
                        r), col = cast,no_check(s16) ((cast(s32) fcenter_mv.col) + c)};
                sad :=
                    fn_ptr.sdf(
                        WHAT.buf,
                        WHAT.stride,
                        get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *MV_),
                        IN_WHAT.stride
                    );
                if sad < best_sad {
                    sad += cast,no_check(u32) mvsad_err_cost_in_vp9_mcomp(x, *MV_, ref_mv, sad_per_bit);
                    if sad < best_sad {
                        best_sad = sad;
                        best_mv.* = MV_;
                    }
                }
            } else if c + 3 <= end_col {
                sads: [4] u32 = ---;
                addrs: [4] *u8 = ---;
                i = 0;
                while i < 4 {
                    MV_ :=
                        MV.{row = cast,no_check(s16) ((cast(s32) fcenter_mv.row) +
                            r), col = cast,no_check(s16) ((cast(s32) fcenter_mv.col) + c + i)};
                    addrs[i] = get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *MV_);
                    i += 1;
                }
                fn_ptr.sdx4df(WHAT.buf, WHAT.stride, addrs.data, IN_WHAT.stride, sads.data);

                i = 0;
                while i < 4 {
                    if sads[i] < best_sad {
                        MV_ :=
                            MV.{row = cast,no_check(s16) ((cast(s32) fcenter_mv.row) +
                                r), col = cast,no_check(s16) ((cast(s32) fcenter_mv.col) + c + i)};
                        SAD := sads[i] + cast,no_check(u32) mvsad_err_cost_in_vp9_mcomp(x, *MV_, ref_mv, sad_per_bit);
                        if SAD < best_sad {
                            best_sad = SAD;
                            best_mv.* = MV_;
                        }
                    }
                    i += 1;
                }
            } else {
                i = 0;
                while i < end_col - c {
                    MV_ :=
                        MV.{row = cast,no_check(s16) ((cast(s32) fcenter_mv.row) +
                            r), col = cast,no_check(s16) ((cast(s32) fcenter_mv.col) + c + i)};
                    sad :=
                        fn_ptr.sdf(
                            WHAT.buf,
                            WHAT.stride,
                            get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *MV_),
                            IN_WHAT.stride
                        );
                    if sad < best_sad {
                        sad += cast,no_check(u32) mvsad_err_cost_in_vp9_mcomp(x, *MV_, ref_mv, sad_per_bit);
                        if sad < best_sad {
                            best_sad = sad;
                            best_mv.* = MV_;
                        }
                    }
                    i += 1;
                }
            }
            c += col_step;
        }
        r += step;
    }

    return cast,no_check(s32) best_sad;
}

get_exhaustive_threshold :: (exhaustive_searches_thresh: s32, bsize: BLOCK_SIZE) -> s32 {
    return exhaustive_searches_thresh >> (((8 - ((cast(s32) B_WIDTH_LOG2_LOOKUP[bsize]) + cast(s32) B_HEIGHT_LOG2_LOOKUP[bsize]))) & 31);
}

full_pixel_diamond :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    X: *MACROBLOCK,
    bsize: BLOCK_SIZE,
    mvp_full: *MV,
    step_param: s32,
    sadpb: s32,
    further_steps: s32,
    do_refine: s32,
    use_downsampled_sad: s32,
    cost_list: *s32,
    fn_ptr: *Vp9_Variance_Fn_Ptr_T,
    ref_mv: *MV,
    dst_mv: *MV
) -> s32 {
    temp_mv: MV = ---;
    thissme: s32 = ---;
    n: s32 = ---;
    num00: s32 = 0;

    SRC_BUF_STRIDE := X.plane[0].src.stride;
    SRC_BUF := X.plane[0].src.buf;
    XD := *X.e_mbd;
    PRED_BUF_STRIDE := XD.plane[0].pre[0].stride;

    sad_fn_ptr: Vp9_Sad_Fn_Ptr_T = ---;

    REF_MV_FULL :=
        MV.{row = cast,no_check(s16) ((cast(s32) ref_mv.row) >> 3), col = cast,no_check(s16) ((cast(s32) ref_mv.col) >> 3)};
    clamp_mv_in_vp9_mcomp(mvp_full, X.mv_limits.col_min, X.mv_limits.col_max, X.mv_limits.row_min, X.mv_limits.row_max);

    pred_buf := XD.plane[0].pre[0].buf + (cast(s32) mvp_full.row) * PRED_BUF_STRIDE + cast,no_check(s32) mvp_full.col;
    start_mv_sad_even_rows := fn_ptr.sdsf(SRC_BUF, SRC_BUF_STRIDE, pred_buf, PRED_BUF_STRIDE);
    start_mv_sad_odd_rows :=
        fn_ptr.sdsf(
            SRC_BUF + SRC_BUF_STRIDE,
            SRC_BUF_STRIDE,
            pred_buf + PRED_BUF_STRIDE,
            PRED_BUF_STRIDE
        );
    start_mv_sad := (start_mv_sad_even_rows + start_mv_sad_odd_rows) >> 1;
    start_mv_sad += cast,no_check(u32) mvsad_err_cost_in_vp9_mcomp(X, mvp_full, *REF_MV_FULL, sadpb);

    sad_fn_ptr.sdf = fn_ptr.sdf;
    sad_fn_ptr.sdx4df = fn_ptr.sdx4df;
    if use_downsampled_sad != 0 && NUM_4X4_BLOCKS_HIGH_LOOKUP[bsize] >= 2 {
        ODD_TO_EVEN_DIFF_SAD :=
            absolute_value(
                (cast,no_check(s32) start_mv_sad_even_rows) - cast,no_check(s32) start_mv_sad_odd_rows
            );
        MULT_THRESH: s32 = 10;
        if ODD_TO_EVEN_DIFF_SAD * MULT_THRESH < cast,no_check(s32) start_mv_sad_even_rows {
            sad_fn_ptr.sdf = fn_ptr.sdsf;
            sad_fn_ptr.sdx4df = fn_ptr.sdsx4df;
        }
    }

    bestsme :=
        CPI.diamond_search_sad(
            X,
            *CPI.ss_cfg,
            mvp_full,
            start_mv_sad,
            *temp_mv,
            step_param,
            sadpb,
            *n,
            *sad_fn_ptr,
            ref_mv
        );
    if bestsme < 2147483647 {
        bestsme = vp9_get_mvpred_var(X, *temp_mv, ref_mv, fn_ptr, 1);
    }
    dst_mv.* = temp_mv;

    if n > further_steps {
        do_refine = 0;
    }

    while n < further_steps {
        n += 1;

        if num00 != 0 {
            num00 -= 1;
        } else {
            thissme =
                CPI.diamond_search_sad(
                    X,
                    *CPI.ss_cfg,
                    mvp_full,
                    start_mv_sad,
                    *temp_mv,
                    step_param + n,
                    sadpb,
                    *num00,
                    *sad_fn_ptr,
                    ref_mv
                );
            if thissme < 2147483647 {
                thissme = vp9_get_mvpred_var(X, *temp_mv, ref_mv, fn_ptr, 1);
            }

            if num00 > further_steps - n {
                do_refine = 0;
            }

            if thissme < bestsme {
                bestsme = thissme;
                dst_mv.* = temp_mv;
            }
        }
    }

    if do_refine != 0 {
        SEARCH_RANGE: s32 = 8;
        best_mv := dst_mv.*;
        thissme = vp9_refining_search_sad(X, *best_mv, sadpb, SEARCH_RANGE, *sad_fn_ptr, ref_mv);
        if thissme < 2147483647 {
            thissme = vp9_get_mvpred_var(X, *best_mv, ref_mv, fn_ptr, 1);
        }
        if thissme < bestsme {
            bestsme = thissme;
            dst_mv.* = best_mv;
        }
    }

    if cast(*void) (sad_fn_ptr.sdf) != cast(*void) (fn_ptr.sdf) {
        best_address := get_buf_from_mv_in_vp9_mcomp(XD.plane[0].pre.data + 0, dst_mv);
        SAD := cast,no_check(s32) fn_ptr.sdf(SRC_BUF, SRC_BUF_STRIDE, best_address, PRED_BUF_STRIDE);
        SKIP_SAD := cast,no_check(s32) fn_ptr.sdsf(SRC_BUF, SRC_BUF_STRIDE, best_address, PRED_BUF_STRIDE);

        K_SAD_THRESH :=
            (cast(s32) 1) << ((((cast(s32) B_WIDTH_LOG2_LOOKUP[bsize]) +
                cast(s32) B_HEIGHT_LOG2_LOOKUP[bsize])) & 31);
        if SAD > K_SAD_THRESH && absolute_value(SKIP_SAD - SAD) * 10 >= (ifx SAD > 1 then SAD else 1) * 9 {
            return full_pixel_diamond(
                CPI,
                X,
                bsize,
                mvp_full,
                step_param,
                sadpb,
                further_steps,
                do_refine,
                0,
                cost_list,
                fn_ptr,
                ref_mv,
                dst_mv
            );
        }
    }

    if cost_list != null {
        calc_int_cost_list(X, ref_mv, sadpb, fn_ptr, dst_mv, cost_list);
    }
    return bestsme;
}

bigdia_search :: (
    x: *MACROBLOCK,
    ref_mv: *MV,
    search_param: s32,
    sad_per_bit: s32,
    do_init_search: s32,
    cost_list: *s32,
    vfp: *Vp9_Variance_Fn_Ptr_T,
    use_mvcost: s32,
    center_mv: *MV,
    best_mv: *MV
) -> s32 {


    return vp9_pattern_search_sad(
        x,
        ref_mv,
        search_param,
        sad_per_bit,
        do_init_search,
        cost_list,
        vfp,
        use_mvcost,
        center_mv,
        best_mv,
        BIGDIA_NUM_CANDIDATES.data,
        BIGDIA_CANDIDATES.data
    );
}

vp9_pattern_search_sad :: (
    x: *MACROBLOCK,
    ref_mv: *MV,
    search_param: s32,
    sad_per_bit: s32,
    do_init_search: s32,
    cost_list: *s32,
    vfp: *Vp9_Variance_Fn_Ptr_T,
    use_mvcost: s32,
    center_mv: *MV,
    best_mv: *MV,
    num_candidates: *s32,
    candidates: *[8] MV
) -> s32 {
    XD := *x.e_mbd;
    i: s32 = ---;
    s: s32 = ---;
    WHAT := *x.plane[0].src;
    IN_WHAT := XD.plane[0].pre.data + 0;

    bestsad: s32 = 2147483647;
    thissad: s32 = ---;
    k: s32 = -1;
    FCENTER_MV :=
        MV.{row = cast,no_check(s16) ((cast(s32) center_mv.row) >> 3), col = cast,no_check(s16) ((cast(s32) center_mv.col) >> 3)};
    best_init_s := SEARCH_PARAM_TO_STEPS[search_param];

    clamp_mv_in_vp9_mcomp(ref_mv, x.mv_limits.col_min, x.mv_limits.col_max, x.mv_limits.row_min, x.mv_limits.row_max);
    br := cast,no_check(s32) ref_mv.row;
    bc := cast,no_check(s32) ref_mv.col;
    if cost_list != null {
        cost_list[4] = 2147483647;
        cost_list[3] = cost_list[4];
        cost_list[2] = cost_list[3];
        cost_list[1] = cost_list[2];
        cost_list[0] = cost_list[1];
    }

    bestsad =
        cast,no_check(s32) (vfp.sdf(
            WHAT.buf,
            WHAT.stride,
            get_buf_from_mv_in_vp9_mcomp(IN_WHAT, ref_mv),
            IN_WHAT.stride
        ) + cast,no_check(u32) mvsad_err_cost_in_vp9_mcomp(x, ref_mv, *FCENTER_MV, sad_per_bit));

    if do_init_search != 0 {
        s = best_init_s;
        best_init_s = -1;
        if 0 <= s {
            for t: 0..s {
                best_site: s32 = -1;
                if check_bounds(*x.mv_limits, br, bc, (cast(s32) 1) << ((t) & 31)) != 0 {
                    i = 0;
                    while i < num_candidates[t] {
                        THIS_MV :=
                            MV.{row = cast,no_check(s16) (br +
                                cast(s32) candidates[t][i].row), col = cast,no_check(s16) (bc + cast(s32) candidates[t][i].col)};
                        thissad =
                            cast,no_check(s32) vfp.sdf(
                                WHAT.buf,
                                WHAT.stride,
                                get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *THIS_MV),
                                IN_WHAT.stride
                            );
                        if thissad < bestsad {
                            if use_mvcost != 0 {
                                thissad += mvsad_err_cost_in_vp9_mcomp(x, *THIS_MV, *FCENTER_MV, sad_per_bit);
                            }

                            if thissad < bestsad {
                                bestsad = thissad;

                                best_site = i;
                            }
                        }
                        i += 1;
                    }
                } else {
                    i = 0;
                    while i < num_candidates[t] {
                        THIS_MV :=
                            MV.{row = cast,no_check(s16) (br +
                                cast(s32) candidates[t][i].row), col = cast,no_check(s16) (bc + cast(s32) candidates[t][i].col)};
                        if is_mv_in(*x.mv_limits, *THIS_MV) == 0 {
                            i += 1;
                            continue;
                        }
                        thissad =
                            cast,no_check(s32) vfp.sdf(
                                WHAT.buf,
                                WHAT.stride,
                                get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *THIS_MV),
                                IN_WHAT.stride
                            );
                        if thissad < bestsad {
                            if use_mvcost != 0 {
                                thissad += mvsad_err_cost_in_vp9_mcomp(x, *THIS_MV, *FCENTER_MV, sad_per_bit);
                            }

                            if thissad < bestsad {
                                bestsad = thissad;

                                best_site = i;
                            }
                        }
                        i += 1;
                    }
                }
                if best_site == -1 {
                    continue;
                } else {
                    best_init_s = t;
                    k = best_site;
                }
            }
        }
        if best_init_s != -1 {
            br += cast,no_check(s32) candidates[best_init_s][k].row;
            bc += cast,no_check(s32) candidates[best_init_s][k].col;
        }
    }

    if best_init_s != -1 {
        do_sad := cast(s32) (num_candidates[0] == 4 && cost_list != null);
        best_site: s32 = -1;
        s = best_init_s;

        while s >= do_sad {
            if do_init_search == 0 || s != best_init_s {
                if check_bounds(*x.mv_limits, br, bc, (cast(s32) 1) << ((s) & 31)) != 0 {
                    i = 0;
                    while i < num_candidates[s] {
                        THIS_MV :=
                            MV.{row = cast,no_check(s16) (br +
                                cast(s32) candidates[s][i].row), col = cast,no_check(s16) (bc + cast(s32) candidates[s][i].col)};
                        thissad =
                            cast,no_check(s32) vfp.sdf(
                                WHAT.buf,
                                WHAT.stride,
                                get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *THIS_MV),
                                IN_WHAT.stride
                            );
                        if thissad < bestsad {
                            if use_mvcost != 0 {
                                thissad += mvsad_err_cost_in_vp9_mcomp(x, *THIS_MV, *FCENTER_MV, sad_per_bit);
                            }

                            if thissad < bestsad {
                                bestsad = thissad;

                                best_site = i;
                            }
                        }
                        i += 1;
                    }
                } else {
                    i = 0;
                    while i < num_candidates[s] {
                        THIS_MV :=
                            MV.{row = cast,no_check(s16) (br +
                                cast(s32) candidates[s][i].row), col = cast,no_check(s16) (bc + cast(s32) candidates[s][i].col)};
                        if is_mv_in(*x.mv_limits, *THIS_MV) == 0 {
                            i += 1;
                            continue;
                        }
                        thissad =
                            cast,no_check(s32) vfp.sdf(
                                WHAT.buf,
                                WHAT.stride,
                                get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *THIS_MV),
                                IN_WHAT.stride
                            );
                        if thissad < bestsad {
                            if use_mvcost != 0 {
                                thissad += mvsad_err_cost_in_vp9_mcomp(x, *THIS_MV, *FCENTER_MV, sad_per_bit);
                            }

                            if thissad < bestsad {
                                bestsad = thissad;

                                best_site = i;
                            }
                        }
                        i += 1;
                    }
                }

                if best_site == -1 {
                    s -= 1;
                    continue;
                } else {
                    br += cast,no_check(s32) candidates[s][best_site].row;
                    bc += cast,no_check(s32) candidates[s][best_site].col;
                    k = best_site;
                }
            }

            while true {
                {
                    next_chkpts_indices: [3] s32 = ---;
                    best_site = -1;
                    next_chkpts_indices[0] = ifx k == 0 then num_candidates[s] - 1 else k - 1;
                    next_chkpts_indices[1] = k;
                    next_chkpts_indices[2] = ifx k == num_candidates[s] - 1 then 0 else k + 1;

                    if check_bounds(*x.mv_limits, br, bc, (cast(s32) 1) << ((s) & 31)) != 0 {
                        i = 0;
                        while i < 3 {
                            THIS_MV :=
                                MV.{row = cast,no_check(s16) (br + cast(s32) candidates[s][next_chkpts_indices[i]].row), col = cast,no_check(s16) (bc +
                                    cast(s32) candidates[s][next_chkpts_indices[i]].col)};
                            thissad =
                                cast,no_check(s32) vfp.sdf(
                                    WHAT.buf,
                                    WHAT.stride,
                                    get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *THIS_MV),
                                    IN_WHAT.stride
                                );
                            if thissad < bestsad {
                                if use_mvcost != 0 {
                                    thissad += mvsad_err_cost_in_vp9_mcomp(x, *THIS_MV, *FCENTER_MV, sad_per_bit);
                                }

                                if thissad < bestsad {
                                    bestsad = thissad;

                                    best_site = i;
                                }
                            }
                            i += 1;
                        }
                    } else {
                        i = 0;
                        while i < 3 {
                            THIS_MV :=
                                MV.{row = cast,no_check(s16) (br + cast(s32) candidates[s][next_chkpts_indices[i]].row), col = cast,no_check(s16) (bc +
                                    cast(s32) candidates[s][next_chkpts_indices[i]].col)};
                            if is_mv_in(*x.mv_limits, *THIS_MV) == 0 {
                                i += 1;
                                continue;
                            }
                            thissad =
                                cast,no_check(s32) vfp.sdf(
                                    WHAT.buf,
                                    WHAT.stride,
                                    get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *THIS_MV),
                                    IN_WHAT.stride
                                );
                            if thissad < bestsad {
                                if use_mvcost != 0 {
                                    thissad += mvsad_err_cost_in_vp9_mcomp(x, *THIS_MV, *FCENTER_MV, sad_per_bit);
                                }

                                if thissad < bestsad {
                                    bestsad = thissad;

                                    best_site = i;
                                }
                            }
                            i += 1;
                        }
                    }

                    if best_site != -1 {
                        k = next_chkpts_indices[best_site];
                        br += cast,no_check(s32) candidates[s][k].row;
                        bc += cast,no_check(s32) candidates[s][k].col;
                    }
                }
                if !(best_site != -1) break;
            }
            s -= 1;
        }

        if s == 0 {
            cost_list[0] = bestsad;
            if do_init_search == 0 || s != best_init_s {
                if check_bounds(*x.mv_limits, br, bc, (cast(s32) 1) << ((s) & 31)) != 0 {
                    i = 0;
                    while i < num_candidates[s] {
                        THIS_MV :=
                            MV.{row = cast,no_check(s16) (br +
                                cast(s32) candidates[s][i].row), col = cast,no_check(s16) (bc + cast(s32) candidates[s][i].col)};
                        thissad =
                            cast,no_check(s32) vfp.sdf(WHAT.buf, WHAT.stride, get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *THIS_MV), IN_WHAT.stride);
                        cost_list[i + 1] = thissad;
                        if thissad < bestsad {
                            if use_mvcost != 0 {
                                thissad += mvsad_err_cost_in_vp9_mcomp(x, *THIS_MV, *FCENTER_MV, sad_per_bit);
                            }

                            if thissad < bestsad {
                                bestsad = thissad;

                                best_site = i;
                            }
                        }
                        i += 1;
                    }
                } else {
                    i = 0;
                    while i < num_candidates[s] {
                        THIS_MV :=
                            MV.{row = cast,no_check(s16) (br +
                                cast(s32) candidates[s][i].row), col = cast,no_check(s16) (bc + cast(s32) candidates[s][i].col)};
                        if is_mv_in(*x.mv_limits, *THIS_MV) == 0 {
                            i += 1;
                            continue;
                        }
                        thissad =
                            cast,no_check(s32) vfp.sdf(WHAT.buf, WHAT.stride, get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *THIS_MV), IN_WHAT.stride);
                        cost_list[i + 1] = thissad;
                        if thissad < bestsad {
                            if use_mvcost != 0 {
                                thissad += mvsad_err_cost_in_vp9_mcomp(x, *THIS_MV, *FCENTER_MV, sad_per_bit);
                            }

                            if thissad < bestsad {
                                bestsad = thissad;

                                best_site = i;
                            }
                        }
                        i += 1;
                    }
                }

                if best_site != -1 {
                    br += cast,no_check(s32) candidates[s][best_site].row;
                    bc += cast,no_check(s32) candidates[s][best_site].col;
                    k = best_site;
                }
            }
            while best_site != -1 {
                next_chkpts_indices: [3] s32 = ---;
                best_site = -1;
                next_chkpts_indices[0] = ifx k == 0 then num_candidates[s] - 1 else k - 1;
                next_chkpts_indices[1] = k;
                next_chkpts_indices[2] = ifx k == num_candidates[s] - 1 then 0 else k + 1;
                cost_list[4] = 2147483647;
                cost_list[3] = cost_list[4];
                cost_list[2] = cost_list[3];
                cost_list[1] = cost_list[2];
                cost_list[(k + 2) % 4 + 1] = cost_list[0];
                cost_list[0] = bestsad;

                if check_bounds(*x.mv_limits, br, bc, (cast(s32) 1) << ((s) & 31)) != 0 {
                    i = 0;
                    while i < 3 {
                        THIS_MV :=
                            MV.{row = cast,no_check(s16) (br + cast(s32) candidates[s][next_chkpts_indices[i]].row), col = cast,no_check(s16) (bc +
                                cast(s32) candidates[s][next_chkpts_indices[i]].col)};
                        thissad =
                            cast,no_check(s32) vfp.sdf(WHAT.buf, WHAT.stride, get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *THIS_MV), IN_WHAT.stride);
                        cost_list[next_chkpts_indices[i] + 1] = thissad;
                        if thissad < bestsad {
                            if use_mvcost != 0 {
                                thissad += mvsad_err_cost_in_vp9_mcomp(x, *THIS_MV, *FCENTER_MV, sad_per_bit);
                            }

                            if thissad < bestsad {
                                bestsad = thissad;

                                best_site = i;
                            }
                        }
                        i += 1;
                    }
                } else {
                    i = 0;
                    while i < 3 {
                        THIS_MV :=
                            MV.{row = cast,no_check(s16) (br + cast(s32) candidates[s][next_chkpts_indices[i]].row), col = cast,no_check(s16) (bc +
                                cast(s32) candidates[s][next_chkpts_indices[i]].col)};
                        if is_mv_in(*x.mv_limits, *THIS_MV) == 0 {
                            cost_list[next_chkpts_indices[i] + 1] = 2147483647;
                            i += 1;
                            continue;
                        }
                        thissad =
                            cast,no_check(s32) vfp.sdf(WHAT.buf, WHAT.stride, get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *THIS_MV), IN_WHAT.stride);
                        cost_list[next_chkpts_indices[i] + 1] = thissad;
                        if thissad < bestsad {
                            if use_mvcost != 0 {
                                thissad += mvsad_err_cost_in_vp9_mcomp(x, *THIS_MV, *FCENTER_MV, sad_per_bit);
                            }

                            if thissad < bestsad {
                                bestsad = thissad;

                                best_site = i;
                            }
                        }
                        i += 1;
                    }
                }

                if best_site != -1 {
                    k = next_chkpts_indices[best_site];
                    br += cast,no_check(s32) candidates[s][k].row;
                    bc += cast,no_check(s32) candidates[s][k].col;
                }
            }
        }
    }

    if cost_list != null {
        if cost_list[0] == 2147483647 {
            cost_list[0] = bestsad;
            if check_bounds(*x.mv_limits, br, bc, 1) != 0 {
                i = 0;
                while i < 4 {
                    THIS_MV :=
                        MV.{row = cast,no_check(s16) (br + cast(s32) NEIGHBORS_storage[i].row), col = cast,no_check(s16) (bc +
                            cast(s32) NEIGHBORS_storage[i].col)};
                    cost_list[i + 1] =
                        cast,no_check(s32) vfp.sdf(
                            WHAT.buf,
                            WHAT.stride,
                            get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *THIS_MV),
                            IN_WHAT.stride
                        );
                    i += 1;
                }
            } else {
                i = 0;
                while i < 4 {
                    THIS_MV :=
                        MV.{row = cast,no_check(s16) (br + cast(s32) NEIGHBORS_storage[i].row), col = cast,no_check(s16) (bc +
                            cast(s32) NEIGHBORS_storage[i].col)};
                    if is_mv_in(*x.mv_limits, *THIS_MV) == 0 {
                        cost_list[i + 1] = 2147483647;
                    } else {
                        cost_list[i + 1] =
                            cast,no_check(s32) vfp.sdf(
                                WHAT.buf,
                                WHAT.stride,
                                get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *THIS_MV),
                                IN_WHAT.stride
                            );
                    }
                    i += 1;
                }
            }
        } else if use_mvcost != 0 {
            i = 0;
            while i < 4 {
                THIS_MV :=
                    MV.{row = cast,no_check(s16) (br + cast(s32) NEIGHBORS_storage[i].row), col = cast,no_check(s16) (bc +
                        cast(s32) NEIGHBORS_storage[i].col)};
                if cost_list[i + 1] != 2147483647 {
                    cost_list[i + 1] += mvsad_err_cost_in_vp9_mcomp(x, *THIS_MV, *FCENTER_MV, sad_per_bit);
                }
                i += 1;
            }
        }
    }
    best_mv.row = cast,no_check(s16) br;
    best_mv.col = cast,no_check(s16) bc;
    return bestsad;
}

square_search :: (
    x: *MACROBLOCK,
    ref_mv: *MV,
    search_param: s32,
    sad_per_bit: s32,
    do_init_search: s32,
    cost_list: *s32,
    vfp: *Vp9_Variance_Fn_Ptr_T,
    use_mvcost: s32,
    center_mv: *MV,
    best_mv: *MV
) -> s32 {


    return vp9_pattern_search(
        x,
        ref_mv,
        search_param,
        sad_per_bit,
        do_init_search,
        cost_list,
        vfp,
        use_mvcost,
        center_mv,
        best_mv,
        SQUARE_NUM_CANDIDATES.data,
        SQUARE_CANDIDATES.data
    );
}

vp9_pattern_search :: (
    x: *MACROBLOCK,
    ref_mv: *MV,
    search_param: s32,
    sad_per_bit: s32,
    do_init_search: s32,
    cost_list: *s32,
    vfp: *Vp9_Variance_Fn_Ptr_T,
    use_mvcost: s32,
    center_mv: *MV,
    best_mv: *MV,
    num_candidates: *s32,
    candidates: *[8] MV
) -> s32 {
    XD := *x.e_mbd;
    i: s32 = ---;
    s: s32 = ---;
    WHAT := *x.plane[0].src;
    IN_WHAT := XD.plane[0].pre.data + 0;

    bestsad: s32 = 2147483647;
    thissad: s32 = ---;
    k: s32 = -1;
    FCENTER_MV :=
        MV.{row = cast,no_check(s16) ((cast(s32) center_mv.row) >> 3), col = cast,no_check(s16) ((cast(s32) center_mv.col) >> 3)};
    best_init_s := SEARCH_PARAM_TO_STEPS_storage[search_param];

    clamp_mv_in_vp9_mcomp(ref_mv, x.mv_limits.col_min, x.mv_limits.col_max, x.mv_limits.row_min, x.mv_limits.row_max);
    br := cast,no_check(s32) ref_mv.row;
    bc := cast,no_check(s32) ref_mv.col;

    bestsad =
        cast,no_check(s32) (vfp.sdf(
            WHAT.buf,
            WHAT.stride,
            get_buf_from_mv_in_vp9_mcomp(IN_WHAT, ref_mv),
            IN_WHAT.stride
        ) + cast,no_check(u32) mvsad_err_cost_in_vp9_mcomp(x, ref_mv, *FCENTER_MV, sad_per_bit));

    if do_init_search != 0 {
        s = best_init_s;
        best_init_s = -1;
        if 0 <= s {
            for t: 0..s {
                best_site: s32 = -1;
                if check_bounds(*x.mv_limits, br, bc, (cast(s32) 1) << ((t) & 31)) != 0 {
                    i = 0;
                    while i < num_candidates[t] {
                        THIS_MV :=
                            MV.{row = cast,no_check(s16) (br +
                                cast(s32) candidates[t][i].row), col = cast,no_check(s16) (bc + cast(s32) candidates[t][i].col)};
                        thissad =
                            cast,no_check(s32) vfp.sdf(
                                WHAT.buf,
                                WHAT.stride,
                                get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *THIS_MV),
                                IN_WHAT.stride
                            );
                        if thissad < bestsad {
                            if use_mvcost != 0 {
                                thissad += mvsad_err_cost_in_vp9_mcomp(x, *THIS_MV, *FCENTER_MV, sad_per_bit);
                            }

                            if thissad < bestsad {
                                bestsad = thissad;

                                best_site = i;
                            }
                        }
                        i += 1;
                    }
                } else {
                    i = 0;
                    while i < num_candidates[t] {
                        THIS_MV :=
                            MV.{row = cast,no_check(s16) (br +
                                cast(s32) candidates[t][i].row), col = cast,no_check(s16) (bc + cast(s32) candidates[t][i].col)};
                        if is_mv_in(*x.mv_limits, *THIS_MV) == 0 {
                            i += 1;
                            continue;
                        }
                        thissad =
                            cast,no_check(s32) vfp.sdf(
                                WHAT.buf,
                                WHAT.stride,
                                get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *THIS_MV),
                                IN_WHAT.stride
                            );
                        if thissad < bestsad {
                            if use_mvcost != 0 {
                                thissad += mvsad_err_cost_in_vp9_mcomp(x, *THIS_MV, *FCENTER_MV, sad_per_bit);
                            }

                            if thissad < bestsad {
                                bestsad = thissad;

                                best_site = i;
                            }
                        }
                        i += 1;
                    }
                }
                if best_site == -1 {
                    continue;
                } else {
                    best_init_s = t;
                    k = best_site;
                }
            }
        }
        if best_init_s != -1 {
            br += cast,no_check(s32) candidates[best_init_s][k].row;
            bc += cast,no_check(s32) candidates[best_init_s][k].col;
        }
    }

    if best_init_s != -1 {
        best_site: s32 = -1;
        s = best_init_s;

        while loop := true {
            while loop_2 := true {
                if do_init_search == 0 || s != best_init_s {
                    if check_bounds(*x.mv_limits, br, bc, (cast(s32) 1) << ((s) & 31)) != 0 {
                        i = 0;
                        while i < num_candidates[s] {
                            THIS_MV :=
                                MV.{row = cast,no_check(s16) (br +
                                    cast(s32) candidates[s][i].row), col = cast,no_check(s16) (bc + cast(s32) candidates[s][i].col)};
                            thissad =
                                cast,no_check(s32) vfp.sdf(
                                    WHAT.buf,
                                    WHAT.stride,
                                    get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *THIS_MV),
                                    IN_WHAT.stride
                                );
                            if thissad < bestsad {
                                if use_mvcost != 0 {
                                    thissad += mvsad_err_cost_in_vp9_mcomp(x, *THIS_MV, *FCENTER_MV, sad_per_bit);
                                }

                                if thissad < bestsad {
                                    bestsad = thissad;

                                    best_site = i;
                                }
                            }
                            i += 1;
                        }
                    } else {
                        i = 0;
                        while i < num_candidates[s] {
                            THIS_MV :=
                                MV.{row = cast,no_check(s16) (br +
                                    cast(s32) candidates[s][i].row), col = cast,no_check(s16) (bc + cast(s32) candidates[s][i].col)};
                            if is_mv_in(*x.mv_limits, *THIS_MV) == 0 {
                                i += 1;
                                continue;
                            }
                            thissad =
                                cast,no_check(s32) vfp.sdf(
                                    WHAT.buf,
                                    WHAT.stride,
                                    get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *THIS_MV),
                                    IN_WHAT.stride
                                );
                            if thissad < bestsad {
                                if use_mvcost != 0 {
                                    thissad += mvsad_err_cost_in_vp9_mcomp(x, *THIS_MV, *FCENTER_MV, sad_per_bit);
                                }

                                if thissad < bestsad {
                                    bestsad = thissad;

                                    best_site = i;
                                }
                            }
                            i += 1;
                        }
                    }

                    if best_site == -1 {
                        break loop_2;
                    } else {
                        br += cast,no_check(s32) candidates[s][best_site].row;
                        bc += cast,no_check(s32) candidates[s][best_site].col;
                        k = best_site;
                    }
                }

                while true {
                    {
                        next_chkpts_indices: [3] s32 = ---;
                        best_site = -1;
                        next_chkpts_indices[0] = ifx k == 0 then num_candidates[s] - 1 else k - 1;
                        next_chkpts_indices[1] = k;
                        next_chkpts_indices[2] = ifx k == num_candidates[s] - 1 then 0 else k + 1;

                        if check_bounds(*x.mv_limits, br, bc, (cast(s32) 1) << ((s) & 31)) != 0 {
                            i = 0;
                            while i < 3 {
                                THIS_MV :=
                                    MV.{row = cast,no_check(s16) (br + cast(s32) candidates[s][next_chkpts_indices[i]].row), col = cast,no_check(s16) (bc +
                                        cast(s32) candidates[s][next_chkpts_indices[i]].col)};
                                thissad =
                                    cast,no_check(s32) vfp.sdf(
                                        WHAT.buf,
                                        WHAT.stride,
                                        get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *THIS_MV),
                                        IN_WHAT.stride
                                    );
                                if thissad < bestsad {
                                    if use_mvcost != 0 {
                                        thissad += mvsad_err_cost_in_vp9_mcomp(x, *THIS_MV, *FCENTER_MV, sad_per_bit);
                                    }

                                    if thissad < bestsad {
                                        bestsad = thissad;

                                        best_site = i;
                                    }
                                }
                                i += 1;
                            }
                        } else {
                            i = 0;
                            while i < 3 {
                                THIS_MV :=
                                    MV.{row = cast,no_check(s16) (br + cast(s32) candidates[s][next_chkpts_indices[i]].row), col = cast,no_check(s16) (bc +
                                        cast(s32) candidates[s][next_chkpts_indices[i]].col)};
                                if is_mv_in(*x.mv_limits, *THIS_MV) == 0 {
                                    i += 1;
                                    continue;
                                }
                                thissad =
                                    cast,no_check(s32) vfp.sdf(
                                        WHAT.buf,
                                        WHAT.stride,
                                        get_buf_from_mv_in_vp9_mcomp(IN_WHAT, *THIS_MV),
                                        IN_WHAT.stride
                                    );
                                if thissad < bestsad {
                                    if use_mvcost != 0 {
                                        thissad += mvsad_err_cost_in_vp9_mcomp(x, *THIS_MV, *FCENTER_MV, sad_per_bit);
                                    }

                                    if thissad < bestsad {
                                        bestsad = thissad;

                                        best_site = i;
                                    }
                                }
                                i += 1;
                            }
                        }

                        if best_site != -1 {
                            k = next_chkpts_indices[best_site];
                            br += cast,no_check(s32) candidates[s][k].row;
                            bc += cast,no_check(s32) candidates[s][k].col;
                        }
                    }
                    if !(best_site != -1) break;
                }
                break loop_2;
            }
            if c_transpiler_post_decrement(*(s)) == 0 break loop;
        }
    }

    best_mv.row = cast,no_check(s16) br;
    best_mv.col = cast,no_check(s16) bc;

    if cost_list != null {
        calc_int_cost_list(x, *FCENTER_MV, sad_per_bit, vfp, best_mv, cost_list);
    }
    return bestsad;
}

hex_search :: (
    x: *MACROBLOCK,
    ref_mv: *MV,
    search_param: s32,
    sad_per_bit: s32,
    do_init_search: s32,
    cost_list: *s32,
    vfp: *Vp9_Variance_Fn_Ptr_T,
    use_mvcost: s32,
    center_mv: *MV,
    best_mv: *MV
) -> s32 {


    return vp9_pattern_search(
        x,
        ref_mv,
        search_param,
        sad_per_bit,
        do_init_search,
        cost_list,
        vfp,
        use_mvcost,
        center_mv,
        best_mv,
        HEX_NUM_CANDIDATES.data,
        HEX_CANDIDATES.data
    );
}

fast_hex_search :: (
    x: *MACROBLOCK,
    ref_mv: *MV,
    search_param: s32,
    sad_per_bit: s32,
    do_init_search: s32,
    cost_list: *s32,
    vfp: *Vp9_Variance_Fn_Ptr_T,
    use_mvcost: s32,
    center_mv: *MV,
    best_mv: *MV
) -> s32 {
    return hex_search(
        x,
        ref_mv,
        (ifx 11 - 2 > search_param then cast,no_check(s32) ((11 - 2)) else search_param),
        sad_per_bit,
        do_init_search,
        cost_list,
        vfp,
        use_mvcost,
        center_mv,
        best_mv
    );
}

fast_dia_search :: (
    x: *MACROBLOCK,
    ref_mv: *MV,
    search_param: s32,
    sad_per_bit: s32,
    do_init_search: s32,
    cost_list: *s32,
    vfp: *Vp9_Variance_Fn_Ptr_T,
    use_mvcost: s32,
    center_mv: *MV,
    best_mv: *MV
) -> s32 {
    return bigdia_search(
        x,
        ref_mv,
        (ifx 11 - 2 > search_param then cast,no_check(s32) ((11 - 2)) else search_param),
        sad_per_bit,
        do_init_search,
        cost_list,
        vfp,
        use_mvcost,
        center_mv,
        best_mv
    );
}

cost_branch256_in_vp9_mcomp :: (ct: *u32, p: Prob) -> u64 {
    return ((cast,no_check(u64) ct[0]) * cast(u64) VP9_PROB_COST[p]) + (cast,no_check(u64) ct[1]) * cast(u64) VP9_PROB_COST[256 - cast(s32) p];
}

treed_cost_in_vp9_mcomp :: (tree: *Tree_Index, probs: *Prob, bits: s32, len: s32) -> s32 {
    cost: s32 = 0;
    i: Tree_Index = 0;

    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            cost +=
                cast,no_check(s32) (VP9_PROB_COST[(ifx BIT != 0 then 256 -
                    cast(s32) probs[(cast(s32) i) >> 1] else cast,no_check(s32) probs[(cast(s32) i) >> 1])]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }

    return cost;
}

rd_less_than_thresh_in_vp9_mcomp :: (best_rd: s64, thresh: s32, THRESH_FACT: *s32) -> s32 {
    if best_rd < ((cast,no_check(s64) thresh) * cast(s64) THRESH_FACT.*) >> 5 || thresh == 2147483647 {
        return 1;
    }
    return 0;
}

set_error_per_bit_in_vp9_mcomp :: (x: *MACROBLOCK, rdmult: s32) {
    x.errorperbit = rdmult >> 6;
    x.errorperbit += cast(s32) (x.errorperbit == 0);
}

write_in_vp9_mcomp :: (br: *Writer, bit: s32, probability: s32) {
    count := br.count;
    range := br.range;
    lowvalue := br.lowvalue;

    split := 1 + ((range - 1) * cast,no_check(u32) probability) >> 8;

    range = split;

    if bit != 0 {
        lowvalue += split;
        range = br.range - split;
    }

    shift := cast,no_check(s32) NORM[range];

    c_transpiler_compound_shl(*(range), (((cast,no_check(u32) shift) & 31)), u32, u32);
    count += shift;

    if count >= 0 {
        offset := shift - count;

        if br.error == 0 {
            if lowvalue << (((offset - 1)) & 31) & 0x80000000 != 0 {
                x := (cast,no_check(s32) br.pos) - 1;

                while x >= 0 && br.buffer[x] == 0xff {
                    br.buffer[x] = 0;
                    x -= 1;
                }

                br.buffer[x] = cast,no_check(u8) ((cast,no_check(s32) br.buffer[x]) + 1);
            }

            if br.pos < br.size {
                br.buffer[br.pos] = cast,no_check(u8) (lowvalue >> (((24 - offset)) & 31) & 0xff);
                br.pos += 1;
            } else {
                br.error = 1;
            }
        }
        c_transpiler_compound_shl(*(lowvalue), (((cast,no_check(u32) offset) & 31)), u32, u32);
        shift = count;
        lowvalue &= 0xffffff;
        count -= 8;
    }

    c_transpiler_compound_shl(*(lowvalue), (((cast,no_check(u32) shift) & 31)), u32, u32);
    br.count = count;
    br.lowvalue = lowvalue;
    br.range = range;
}

write_bit_in_vp9_mcomp :: (w: *Writer, bit: s32) {
    write_in_vp9_mcomp(w, bit, 128);
}

write_literal_in_vp9_mcomp :: (w: *Writer, data: s32, bits: s32) {
    bit := bits - 1;
    while bit >= 0 {
        write_bit_in_vp9_mcomp(w, 1 & (data >> ((bit) & 31)));
        bit -= 1;
    }
}

vp9_write_tree_in_vp9_mcomp :: (w: *Writer, tree: *Tree_Index, probs: *Prob, bits: s32, len: s32, i: Tree_Index) {
    while true {
        {
            BIT := bits >> ((c_transpiler_pre_decrement(*(len))) & 31) & 1;
            write_in_vp9_mcomp(w, BIT, cast,no_check(s32) probs[(cast(s32) i) >> 1]);
            i = tree[(cast(s32) i) + BIT];
        }
        if len == 0 break;
    }
}

vp9_write_token_in_vp9_mcomp :: (w: *Writer, tree: *Tree_Index, probs: *Prob, token: *Vp9_Token) {
    vp9_write_tree_in_vp9_mcomp(w, tree, probs, token.value, token.len, 0);
}

vp9_get_high_cost_table_in_vp9_mcomp :: (bit_depth: s32) -> *u16 {
    return VP9_CAT6_HIGH_COST.data;
}

vp9_get_token_extra_in_vp9_mcomp :: (v: s32, token: *s16, extra: *EXTRABIT) {
    if v >= 67 || v <= -67 {
        token.* = 10;
        if v >= 67 {
            extra.* = cast,no_check(EXTRABIT) (2 * v - cast,no_check(s32) ((2 * 67)));
        } else {
            extra.* = cast,no_check(EXTRABIT) ((-2 * v - cast,no_check(s32) ((2 * 67))) + 1);
        }
        return;
    }
    token.* = vp9_dct_cat_lt_10_value_tokens[v].token;
    extra.* = vp9_dct_cat_lt_10_value_tokens[v].extra;
}

vp9_get_token_in_vp9_mcomp :: (v: s32) -> s16 {
    if v >= 67 || v <= -67 {
        return 10;
    }
    return vp9_dct_cat_lt_10_value_tokens[v].token;
}

vp9_get_token_cost_in_vp9_mcomp :: (v: s32, token: *s16, cat6_high_table: *u16) -> s32 {
    if v >= 67 || v <= -67 {
        token.* = 10;
        extrabits := cast,no_check(EXTRABIT) (absolute_value(v) - 67);
        return (cast(s32) VP9_CAT6_LOW_COST[extrabits & 0xff]) + cast(s32) cat6_high_table[(cast(s32) extrabits) >> 8];
    }
    token.* = vp9_dct_cat_lt_10_value_tokens[v].token;
    return vp9_dct_cat_lt_10_value_cost[v];
}

is_lossless_requested_in_vp9_mcomp :: (cfg: *VP9_Encoder_Config) -> s32 {
    if cfg.best_allowed_q == 0 && cfg.worst_allowed_q == 0 {
        return 1;
    }
    return 0;
}

stack_pop_in_vp9_mcomp :: (stack: *s32, stack_size: s32) -> s32 {
    R := stack[0];
    if 1 < stack_size {
        for idx: 1..stack_size - 1 {
            stack[idx - 1] = stack[idx];
        }
    }

    return R;
}

stack_top_in_vp9_mcomp :: (stack: *s32) -> s32 {
    return stack[0];
}

stack_push_in_vp9_mcomp :: (stack: *s32, new_item: s32, stack_size: s32) {
    idx := stack_size;
    while idx > 0 {
        stack[idx] = stack[idx - 1];
        idx -= 1;
    }
    stack[0] = new_item;
}

stack_init_in_vp9_mcomp :: (stack: *s32, length: s32) {
    if 0 < length {
        for idx: 0..length - 1 {
            stack[idx] = -1;
        }
    }
}

frame_is_kf_gf_arf_in_vp9_mcomp :: (cpi: *VP9_COMP_in_vp9_encoder) -> s32 {
    if frame_is_intra_only_in_vp9_mcomp(*cpi.common) != 0 ||
        cpi.refresh_alt_ref_frame != 0 ||
        cpi.refresh_golden_frame != 0 && cpi.rc.is_src_frame_alt_ref == 0 {
        return 1;
    }
    return 0;
}

ref_frame_to_flag_in_vp9_mcomp :: (ref_frame: s8) -> s32 {

    return K_VP9_REF_FLAG_LIST_in_vp9_mcomp[ref_frame];
}

get_ref_frame_map_idx_in_vp9_mcomp :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame: MV_REFERENCE_FRAME) -> s32 {
    if ref_frame == 1 {
        return cpi.lst_fb_idx;
    } else if ref_frame == 2 {
        return cpi.gld_fb_idx;
    } else {
        return cpi.alt_fb_idx;
    }
}

get_ref_frame_buf_idx_in_vp9_mcomp :: (CPI: *VP9_COMP_in_vp9_encoder, ref_frame: s32) -> s32 {
    CM := *CPI.common;
    MAP_IDX := get_ref_frame_map_idx_in_vp9_mcomp(CPI, cast,no_check(MV_REFERENCE_FRAME) ref_frame);
    return ifx MAP_IDX != -1 then CM.ref_frame_map[MAP_IDX] else -1;
}

get_ref_cnt_buffer_in_vp9_mcomp :: (cm: *VP9_COMMON, fb_idx: s32) -> *Ref_Cnt_Buffer {
    return ifx fb_idx != -1 then cm.buffer_pool.frame_bufs.data + fb_idx else null;
}

get_ref_frame_bufs_in_vp9_mcomp :: (cpi: *VP9_COMP_in_vp9_encoder, ref_frame_bufs: **Ref_Cnt_Buffer) {
    CM := *cpi.common;

    ref_frame: MV_REFERENCE_FRAME = 1;
    while ref_frame < 4 {
        ref_frame_buf_idx := get_ref_frame_buf_idx_in_vp9_mcomp(cpi, cast,no_check(s32) ref_frame);
        inter_ref_idx := mv_ref_frame_to_inter_ref_idx_in_vp9_mcomp(ref_frame);
        ref_frame_bufs[inter_ref_idx] = get_ref_cnt_buffer_in_vp9_mcomp(CM, ref_frame_buf_idx);
        ref_frame += 1;
    }
}

get_ref_frame_buffer_in_vp9_mcomp :: (
    CPI: *VP9_COMP_in_vp9_encoder,
    ref_frame: MV_REFERENCE_FRAME
) -> *YV12_BUFFER_CONFIG {
    CM := *CPI.common;
    BUF_IDX := get_ref_frame_buf_idx_in_vp9_mcomp(CPI, cast,no_check(s32) ref_frame);
    return ifx BUF_IDX != -1 then *CM.buffer_pool.frame_bufs[BUF_IDX].buf else null;
}

get_token_alloc_in_vp9_mcomp :: (mb_rows: s32, mb_cols: s32) -> s64 {
    ALIGNED_MB_ROWS :=
        (mb_rows +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    ALIGNED_MB_COLS :=
        (mb_cols +
            ((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1)) & ~((cast(s32) 1) << ((((cast,no_check(s32) ((6 - 3))) - 1)) & 31) - 1);
    return ((cast,no_check(s64) ALIGNED_MB_ROWS) * cast(s64) ALIGNED_MB_COLS) * cast,no_check(s64) ((cast,no_check(s32) ((16 * 16))) * 3 + 4);
}

allocated_tokens_in_vp9_mcomp :: (tile: Tile_Info) -> s64 {
    tile_mb_rows := (tile.mi_row_end - tile.mi_row_start + 1) >> 1;
    tile_mb_cols := (tile.mi_col_end - tile.mi_col_start + 1) >> 1;

    return get_token_alloc_in_vp9_mcomp(tile_mb_rows, tile_mb_cols);
}

get_start_tok_in_vp9_mcomp :: (
    cpi: *VP9_COMP_in_vp9_encoder,
    tile_row: s32,
    tile_col: s32,
    mi_row: s32,
    tok: **TOKENEXTRA_in_vp9_cx_iface
) {
    CM := *cpi.common;
    TILE_COLS := (cast(s32) 1) << ((CM.log2_tile_cols) & 31);
    this_tile := *cpi.tile_data[tile_row * TILE_COLS + tile_col];
    TILE_INFO := *this_tile.tile_info;

    tile_mb_cols := (TILE_INFO.mi_col_end - TILE_INFO.mi_col_start + 1) >> 1;
    MB_ROW := (mi_row - TILE_INFO.mi_row_start) >> 1;

    tok.* = cpi.tile_tok[tile_row][tile_col] + get_token_alloc_in_vp9_mcomp(MB_ROW, tile_mb_cols);
}

is_one_pass_svc_in_vp9_mcomp :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if CPI.use_svc != 0 && CPI.oxcf.pass == 0 {
        return 1;
    }
    return 0;
}

is_altref_enabled_in_vp9_mcomp :: (CPI: *VP9_COMP_in_vp9_encoder) -> s32 {
    if !(CPI.oxcf.mode == cast,no_check(u32) REALTIME && CPI.oxcf.rc_mode == cast,no_check(u32) CBR) &&
        CPI.oxcf.lag_in_frames >= 4 &&
        CPI.oxcf.enable_auto_arf != 0 {
        return 1;
    }
    return 0;
}

set_ref_ptrs_in_vp9_mcomp :: (CM: *VP9_COMMON, xd: *MACROBLOCKD, ref0: MV_REFERENCE_FRAME, ref1: MV_REFERENCE_FRAME) {
    xd.block_refs[0] = CM.frame_refs.data + (ifx ref0 >= 1 then (cast(s32) ref0) - 1 else 0);
    xd.block_refs[1] = CM.frame_refs.data + (ifx ref1 >= 1 then (cast(s32) ref1) - 1 else 0);
}

get_chessboard_index_in_vp9_mcomp :: (FRAME_INDEX: s32) -> s32 {
    return FRAME_INDEX & 0x1;
}

cond_cost_list_in_vp9_mcomp :: (cpi: *VP9_COMP_in_vp9_encoder, cost_list: *s32) -> *s32 {
    return ifx cpi.sf.mv.subpel_search_method != cast,no_check(u32) SUBPEL_TREE then cost_list else null;
}

get_num_vert_units_in_vp9_mcomp :: (tile: Tile_Info, shift: s32) -> s32 {
    num_vert_units := (tile.mi_row_end - tile.mi_row_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_vert_units;
}

get_num_cols_in_vp9_mcomp :: (tile: Tile_Info, shift: s32) -> s32 {
    num_cols := (tile.mi_col_end - tile.mi_col_start + (cast(s32) 1) << ((shift) & 31) - 1) >> ((shift) & 31);
    return num_cols;
}

get_level_index_in_vp9_mcomp :: (level: VP9_LEVEL) -> s32 {
    for i: 0..cast(s32) 14 - 1 {
        if level == VP9_LEVEL_DEFS[i].level {
            return i;
        }
    }
    return -1;
}

log_tile_cols_from_picsize_level_in_vp9_mcomp :: (width: u32, height: u32) -> s32 {
    PIC_SIZE := width * height;
    PIC_BREADTH := max(width, height);
    for i: 0..cast(s32) 14 - 1 {
        if VP9_LEVEL_DEFS[i].max_luma_picture_size >= PIC_SIZE && VP9_LEVEL_DEFS[i].max_luma_picture_breadth >= PIC_BREADTH {
            return get_msb_in_vp9_mcomp(cast,no_check(u32) VP9_LEVEL_DEFS[i].max_col_tiles);
        }
    }
    return 2147483647;
}

alloc_frame_mvs_in_vp9_mcomp :: (CM: *VP9_COMMON, buffer_idx: s32) {
    NEW_FB_PTR := CM.buffer_pool.frame_bufs.data + buffer_idx;
    if NEW_FB_PTR.mvs == null || NEW_FB_PTR.mi_rows < CM.mi_rows || NEW_FB_PTR.mi_cols < CM.mi_cols {
        deallocate_memory(cast(*void) NEW_FB_PTR.mvs);
        NEW_FB_PTR.mvs =
            cast(*MV_REF) calloc_2(
                cast,no_check(u64) (CM.mi_rows * CM.mi_cols),
                size_of(MV_REF)
            );

        if NEW_FB_PTR.mvs == null {
            internal_error(
                *CM.error,
                cast,no_check(Codec_Err_T) CODEC_MEM_ERROR,
                c_string("Failed to allocate new_fb_ptr->mvs")
            );
        }
        NEW_FB_PTR.mi_rows = CM.mi_rows;
        NEW_FB_PTR.mi_cols = CM.mi_cols;
    }
}

get_start_mv_sad_in_vp9_mcomp :: (
    x: *MACROBLOCK,
    mvp_full: *MV,
    ref_mv_full: *MV,
    sad_fn_ptr: Sad_Fn_T,
    sadpb: s32
) -> u32 {
    SRC_BUF_STRIDE := x.plane[0].src.stride;
    SRC_BUF := x.plane[0].src.buf;
    XD := *x.e_mbd;
    PRED_BUF_STRIDE := XD.plane[0].pre[0].stride;
    PRED_BUF := XD.plane[0].pre[0].buf + (cast(s32) mvp_full.row) * PRED_BUF_STRIDE + cast,no_check(s32) mvp_full.col;
    start_mv_sad: u32 = sad_fn_ptr(SRC_BUF, SRC_BUF_STRIDE, PRED_BUF, PRED_BUF_STRIDE);
    start_mv_sad += cast,no_check(u32) mvsad_err_cost_in_vp9_mcomp(x, mvp_full, ref_mv_full, sadpb);

    return start_mv_sad;
}

num_4x4_to_edge_in_vp9_mcomp :: (plane_4x4_dim: s32, mb_to_edge_dim: s32, subsampling_dim: s32, blk_dim: s32) -> s32 {
    return plane_4x4_dim + mb_to_edge_dim >> (((5 + subsampling_dim)) & 31) - blk_dim;
}

sum_squares_visible_in_vp9_mcomp :: (
    xd: *MACROBLOCKD,
    PD: *Macroblockd_Plane,
    diff: *s16,
    DIFF_STRIDE: s32,
    blk_row: s32,
    blk_col: s32,
    PLANE_BSIZE: BLOCK_SIZE,
    TX_BSIZE: BLOCK_SIZE,
    visible_width: *s32,
    visible_height: *s32
) -> s64 {
    sse: s64 = ---;
    PLANE_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE];
    PLANE_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE];
    TX_4X4_W := cast,no_check(s32) NUM_4X4_BLOCKS_WIDE_LOOKUP[TX_BSIZE];
    TX_4X4_H := cast,no_check(s32) NUM_4X4_BLOCKS_HIGH_LOOKUP[TX_BSIZE];
    B4X4S_TO_RIGHT_EDGE := num_4x4_to_edge_in_vp9_mcomp(PLANE_4X4_W, xd.mb_to_right_edge, PD.subsampling_x, blk_col);
    B4X4S_TO_BOTTOM_EDGE :=
        num_4x4_to_edge_in_vp9_mcomp(
            PLANE_4X4_H,
            xd.mb_to_bottom_edge,
            PD.subsampling_y,
            blk_row
        );
    if TX_BSIZE == 0 || B4X4S_TO_RIGHT_EDGE >= TX_4X4_W && B4X4S_TO_BOTTOM_EDGE >= TX_4X4_H {
        sse = cast,no_check(s64) sum_squares_2d_i16_c(diff, DIFF_STRIDE, TX_4X4_W << 2);
        visible_width.* = TX_4X4_W << 2;
        visible_height.* = TX_4X4_H << 2;
    } else {
        c: s32 = ---;
        MAX_R := min(B4X4S_TO_BOTTOM_EDGE, TX_4X4_H);
        MAX_C := min(B4X4S_TO_RIGHT_EDGE, TX_4X4_W);
        sse = 0;

        if 0 < MAX_R {
            for r: 0..MAX_R - 1 {
                c = 0;
                while c < MAX_C {
                    sse +=
                        cast,no_check(s64) sum_squares_2d_i16_c(
                            diff + r * DIFF_STRIDE * 4 + c * 4,
                            DIFF_STRIDE,
                            4
                        );
                    c += 1;
                }
            }
        }
        visible_width.* = MAX_C << 2;
        visible_height.* = MAX_R << 2;
    }
    return sse;
}

do_trellis_opt_in_vp9_mcomp :: (
    pd: *Macroblockd_Plane,
    src_diff: *s16,
    diff_stride: s32,
    blk_row: s32,
    blk_col: s32,
    plane_bsize: BLOCK_SIZE,
    tx_size: TX_SIZE,
    arg: *void
) -> s32 {
    ARGS := cast(*Encode_B_Args) arg;
    X := ARGS.x;

    if ARGS.enable_trellis_opt == {
        case DISABLE_TRELLIS_OPT;
            return 0;
        case ENABLE_TRELLIS_OPT;
            return 1;
        case ENABLE_TRELLIS_OPT_TX_RD_SRC_VAR;
            {
                return ifx c_transpiler_float_greater(ARGS.trellis_opt_thresh, 0.0) then cast(s32) (c_transpiler_float_less_equal(X.log_block_src_var, ARGS.trellis_opt_thresh)) else 1;
            }
        case ENABLE_TRELLIS_OPT_TX_RD_RESIDUAL_MSE;
            {
                XD := *X.e_mbd;
                TX_BSIZE := TXSIZE_TO_BSIZE[tx_size];

                DEQUANT_SHIFT: s32 = 3;

                QSTEP := (cast(s32) pd.dequant[1]) >> ((DEQUANT_SHIFT) & 31);
                sse_calc_done := ARGS.sse_calc_done;
                sse := ARGS.sse;
                visible_width: s32 = 0;
                visible_height: s32 = 0;

                if XD.cur_buf.flags & 8 != 0 || sse == null || sse_calc_done == null {
                    return 1;
                }

                sse.* =
                    sum_squares_visible_in_vp9_mcomp(
                        XD,
                        pd,
                        src_diff,
                        diff_stride,
                        blk_row,
                        blk_col,
                        plane_bsize,
                        TX_BSIZE,
                        *visible_width,
                        *visible_height
                    );
                sse_calc_done.* = 1;

                if c_transpiler_float_less_equal(cast,no_check(float64) sse.*, (((((cast,no_check(s64) visible_width) * cast(s64) visible_height) * cast(s64) QSTEP) * cast(s64) QSTEP) * ARGS.trellis_opt_thresh)) {
                    return 1;
                }
                return 0;
            }
        case;
            return 1;
    }
    return unreachable_value(s32);
}

globals_initialization_state_for_vp9_mcomp: u32;
initialize_globals_for_vp9_mcomp :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_mcomp);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_mcomp, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_mcomp) != 2 {}
            return;
        }
    }
    K_VP9_REF_FLAG_LIST_in_vp9_mcomp =
        s32.[ 0, cast,no_check(s32) (VP9_LAST_FLAG), cast,no_check(s32) (VP9_GOLD_FLAG), cast,no_check(s32) (VP9_ALT_FLAG) ];
    SUB_PEL_FILTERS_12_in_vp9_mcomp =
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
    MODE_2_COUNTER_in_vp9_mcomp =
        s32.[
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            9,
            0,
            0,
            3,
            1
        ];
    COUNTER_TO_CONTEXT_in_vp9_mcomp =
        s32.[
            cast,no_check(s32) (BOTH_PREDICTED),
            cast,no_check(s32) (NEW_PLUS_NON_INTRA),
            cast,no_check(s32) (BOTH_NEW),
            cast,no_check(s32) (ZERO_PLUS_PREDICTED),
            cast,no_check(s32) (NEW_PLUS_NON_INTRA),
            cast,no_check(s32) (INVALID_CASE),
            cast,no_check(s32) (BOTH_ZERO),
            cast,no_check(s32) (INVALID_CASE),
            cast,no_check(s32) (INVALID_CASE),
            cast,no_check(s32) (INTRA_PLUS_NON_INTRA),
            cast,no_check(s32) (INTRA_PLUS_NON_INTRA),
            cast,no_check(s32) (INVALID_CASE),
            cast,no_check(s32) (INTRA_PLUS_NON_INTRA),
            cast,no_check(s32) (INVALID_CASE),
            cast,no_check(s32) (INVALID_CASE),
            cast,no_check(s32) (INVALID_CASE),
            cast,no_check(s32) (INVALID_CASE),
            cast,no_check(s32) (INVALID_CASE),
            cast,no_check(s32) (BOTH_INTRA)
        ];
    MV_REF_BLOCKS_in_vp9_mcomp =
        [8] POSITION.[
            POSITION.[ POSITION.{row = -1, col = 0}, POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = -1}, POSITION.{row = -2, col = 0}, POSITION.{row = 0, col = -2}, POSITION.{row = -2, col = -1}, POSITION.{row = -1, col = -2}, POSITION.{row = -2, col = -2} ],
            POSITION.[ POSITION.{row = -1, col = 0}, POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = -1}, POSITION.{row = -2, col = 0}, POSITION.{row = 0, col = -2}, POSITION.{row = -2, col = -1}, POSITION.{row = -1, col = -2}, POSITION.{row = -2, col = -2} ],
            POSITION.[ POSITION.{row = -1, col = 0}, POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = -1}, POSITION.{row = -2, col = 0}, POSITION.{row = 0, col = -2}, POSITION.{row = -2, col = -1}, POSITION.{row = -1, col = -2}, POSITION.{row = -2, col = -2} ],
            POSITION.[ POSITION.{row = -1, col = 0}, POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = -1}, POSITION.{row = -2, col = 0}, POSITION.{row = 0, col = -2}, POSITION.{row = -2, col = -1}, POSITION.{row = -1, col = -2}, POSITION.{row = -2, col = -2} ],
            POSITION.[ POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = 0}, POSITION.{row = 1, col = -1}, POSITION.{row = -1, col = -1}, POSITION.{row = 0, col = -2}, POSITION.{row = -2, col = 0}, POSITION.{row = -2, col = -1}, POSITION.{row = -1, col = -2} ],
            POSITION.[ POSITION.{row = -1, col = 0}, POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = 1}, POSITION.{row = -1, col = -1}, POSITION.{row = -2, col = 0}, POSITION.{row = 0, col = -2}, POSITION.{row = -1, col = -2}, POSITION.{row = -2, col = -1} ],
            POSITION.[ POSITION.{row = -1, col = 0}, POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = 1}, POSITION.{row = 1, col = -1}, POSITION.{row = -1, col = -1}, POSITION.{row = -3, col = 0}, POSITION.{row = 0, col = -3}, POSITION.{row = -3, col = -3} ],
            POSITION.[ POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = 0}, POSITION.{row = 2, col = -1}, POSITION.{row = -1, col = -1}, POSITION.{row = -1, col = 1}, POSITION.{row = 0, col = -3}, POSITION.{row = -3, col = 0}, POSITION.{row = -3, col = -3} ],
            POSITION.[ POSITION.{row = -1, col = 0}, POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = 2}, POSITION.{row = -1, col = -1}, POSITION.{row = 1, col = -1}, POSITION.{row = -3, col = 0}, POSITION.{row = 0, col = -3}, POSITION.{row = -3, col = -3} ],
            POSITION.[ POSITION.{row = -1, col = 1}, POSITION.{row = 1, col = -1}, POSITION.{row = -1, col = 2}, POSITION.{row = 2, col = -1}, POSITION.{row = -1, col = -1}, POSITION.{row = -3, col = 0}, POSITION.{row = 0, col = -3}, POSITION.{row = -3, col = -3} ],
            POSITION.[ POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = 0}, POSITION.{row = 4, col = -1}, POSITION.{row = -1, col = 2}, POSITION.{row = -1, col = -1}, POSITION.{row = 0, col = -3}, POSITION.{row = -3, col = 0}, POSITION.{row = 2, col = -1} ],
            POSITION.[ POSITION.{row = -1, col = 0}, POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = 4}, POSITION.{row = 2, col = -1}, POSITION.{row = -1, col = -1}, POSITION.{row = -3, col = 0}, POSITION.{row = 0, col = -3}, POSITION.{row = -1, col = 2} ],
            POSITION.[ POSITION.{row = -1, col = 3}, POSITION.{row = 3, col = -1}, POSITION.{row = -1, col = 4}, POSITION.{row = 4, col = -1}, POSITION.{row = -1, col = -1}, POSITION.{row = -1, col = 0}, POSITION.{row = 0, col = -1}, POSITION.{row = -1, col = 6} ]
        ];
    IDX_N_COLUMN_TO_SUBBLOCK_in_vp9_mcomp =
        [2] s32.[
            s32.[ 1, 2 ],
            s32.[ 1, 3 ],
            s32.[ 3, 2 ],
            s32.[ 3, 3 ]
        ];
    SEARCH_STEP_TABLE =
        MV.[
            MV.{row = 0, col = -4},
            MV.{row = 0, col = 4},
            MV.{row = -4, col = 0},
            MV.{row = 4, col = 0},
            MV.{row = 0, col = -2},
            MV.{row = 0, col = 2},
            MV.{row = -2, col = 0},
            MV.{row = 2, col = 0},
            MV.{row = 0, col = -1},
            MV.{row = 0, col = 1},
            MV.{row = -1, col = 0},
            MV.{row = 1, col = 0}
        ];
    NEIGHBORS =
        MV.[
            MV.{row = 0, col = -1},
            MV.{row = 1, col = 0},
            MV.{row = 0, col = 1},
            MV.{row = -1, col = 0}
        ];
    SEARCH_PARAM_TO_STEPS_storage =
        s32.[
            10,
            9,
            8,
            7,
            6,
            5,
            4,
            3,
            2,
            1,
            0
        ];
    SEARCH_PARAM_TO_STEPS =
        s32.[
            10,
            9,
            8,
            7,
            6,
            5,
            4,
            3,
            2,
            1,
            0
        ];
    NEIGHBORS_storage =
        MV.[
            MV.{row = 0, col = -1},
            MV.{row = 1, col = 0},
            MV.{row = 0, col = 1},
            MV.{row = -1, col = 0}
        ];
    HEX_NUM_CANDIDATES =
        s32.[
            8,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6,
            6
        ];
    HEX_CANDIDATES =
        [8] MV.[
            MV.[ MV.{row = -1, col = -1}, MV.{row = 0, col = -1}, MV.{row = 1, col = -1}, MV.{row = 1, col = 0}, MV.{row = 1, col = 1}, MV.{row = 0, col = 1}, MV.{row = -1, col = 1}, MV.{row = -1, col = 0} ],
            MV.[ MV.{row = -1, col = -2}, MV.{row = 1, col = -2}, MV.{row = 2, col = 0}, MV.{row = 1, col = 2}, MV.{row = -1, col = 2}, MV.{row = -2, col = 0}, MV.{}, MV.{} ],
            MV.[ MV.{row = -2, col = -4}, MV.{row = 2, col = -4}, MV.{row = 4, col = 0}, MV.{row = 2, col = 4}, MV.{row = -2, col = 4}, MV.{row = -4, col = 0}, MV.{}, MV.{} ],
            MV.[ MV.{row = -4, col = -8}, MV.{row = 4, col = -8}, MV.{row = 8, col = 0}, MV.{row = 4, col = 8}, MV.{row = -4, col = 8}, MV.{row = -8, col = 0}, MV.{}, MV.{} ],
            MV.[ MV.{row = -8, col = -16}, MV.{row = 8, col = -16}, MV.{row = 16, col = 0}, MV.{row = 8, col = 16}, MV.{row = -8, col = 16}, MV.{row = -16, col = 0}, MV.{}, MV.{} ],
            MV.[ MV.{row = -16, col = -32}, MV.{row = 16, col = -32}, MV.{row = 32, col = 0}, MV.{row = 16, col = 32}, MV.{row = -16, col = 32}, MV.{row = -32, col = 0}, MV.{}, MV.{} ],
            MV.[ MV.{row = -32, col = -64}, MV.{row = 32, col = -64}, MV.{row = 64, col = 0}, MV.{row = 32, col = 64}, MV.{row = -32, col = 64}, MV.{row = -64, col = 0}, MV.{}, MV.{} ],
            MV.[ MV.{row = -64, col = -128}, MV.{row = 64, col = -128}, MV.{row = 128, col = 0}, MV.{row = 64, col = 128}, MV.{row = -64, col = 128}, MV.{row = -128, col = 0}, MV.{}, MV.{} ],
            MV.[ MV.{row = -128, col = -256}, MV.{row = 128, col = -256}, MV.{row = 256, col = 0}, MV.{row = 128, col = 256}, MV.{row = -128, col = 256}, MV.{row = -256, col = 0}, MV.{}, MV.{} ],
            MV.[ MV.{row = -256, col = -512}, MV.{row = 256, col = -512}, MV.{row = 512, col = 0}, MV.{row = 256, col = 512}, MV.{row = -256, col = 512}, MV.{row = -512, col = 0}, MV.{}, MV.{} ],
            MV.[ MV.{row = -512, col = -1024}, MV.{row = 512, col = -1024}, MV.{row = 1024, col = 0}, MV.{row = 512, col = 1024}, MV.{row = -512, col = 1024}, MV.{row = -1024, col = 0}, MV.{}, MV.{} ]
        ];
    BIGDIA_NUM_CANDIDATES =
        s32.[
            4,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8
        ];
    BIGDIA_CANDIDATES =
        [8] MV.[
            MV.[ MV.{row = 0, col = -1}, MV.{row = 1, col = 0}, MV.{row = 0, col = 1}, MV.{row = -1, col = 0}, MV.{}, MV.{}, MV.{}, MV.{} ],
            MV.[ MV.{row = -1, col = -1}, MV.{row = 0, col = -2}, MV.{row = 1, col = -1}, MV.{row = 2, col = 0}, MV.{row = 1, col = 1}, MV.{row = 0, col = 2}, MV.{row = -1, col = 1}, MV.{row = -2, col = 0} ],
            MV.[ MV.{row = -2, col = -2}, MV.{row = 0, col = -4}, MV.{row = 2, col = -2}, MV.{row = 4, col = 0}, MV.{row = 2, col = 2}, MV.{row = 0, col = 4}, MV.{row = -2, col = 2}, MV.{row = -4, col = 0} ],
            MV.[ MV.{row = -4, col = -4}, MV.{row = 0, col = -8}, MV.{row = 4, col = -4}, MV.{row = 8, col = 0}, MV.{row = 4, col = 4}, MV.{row = 0, col = 8}, MV.{row = -4, col = 4}, MV.{row = -8, col = 0} ],
            MV.[ MV.{row = -8, col = -8}, MV.{row = 0, col = -16}, MV.{row = 8, col = -8}, MV.{row = 16, col = 0}, MV.{row = 8, col = 8}, MV.{row = 0, col = 16}, MV.{row = -8, col = 8}, MV.{row = -16, col = 0} ],
            MV.[ MV.{row = -16, col = -16}, MV.{row = 0, col = -32}, MV.{row = 16, col = -16}, MV.{row = 32, col = 0}, MV.{row = 16, col = 16}, MV.{row = 0, col = 32}, MV.{row = -16, col = 16}, MV.{row = -32, col = 0} ],
            MV.[ MV.{row = -32, col = -32}, MV.{row = 0, col = -64}, MV.{row = 32, col = -32}, MV.{row = 64, col = 0}, MV.{row = 32, col = 32}, MV.{row = 0, col = 64}, MV.{row = -32, col = 32}, MV.{row = -64, col = 0} ],
            MV.[ MV.{row = -64, col = -64}, MV.{row = 0, col = -128}, MV.{row = 64, col = -64}, MV.{row = 128, col = 0}, MV.{row = 64, col = 64}, MV.{row = 0, col = 128}, MV.{row = -64, col = 64}, MV.{row = -128, col = 0} ],
            MV.[ MV.{row = -128, col = -128}, MV.{row = 0, col = -256}, MV.{row = 128, col = -128}, MV.{row = 256, col = 0}, MV.{row = 128, col = 128}, MV.{row = 0, col = 256}, MV.{row = -128, col = 128}, MV.{row = -256, col = 0} ],
            MV.[ MV.{row = -256, col = -256}, MV.{row = 0, col = -512}, MV.{row = 256, col = -256}, MV.{row = 512, col = 0}, MV.{row = 256, col = 256}, MV.{row = 0, col = 512}, MV.{row = -256, col = 256}, MV.{row = -512, col = 0} ],
            MV.[ MV.{row = -512, col = -512}, MV.{row = 0, col = -1024}, MV.{row = 512, col = -512}, MV.{row = 1024, col = 0}, MV.{row = 512, col = 512}, MV.{row = 0, col = 1024}, MV.{row = -512, col = 512}, MV.{row = -1024, col = 0} ]
        ];
    SQUARE_NUM_CANDIDATES =
        s32.[
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8,
            8
        ];
    SQUARE_CANDIDATES =
        [8] MV.[
            MV.[ MV.{row = -1, col = -1}, MV.{row = 0, col = -1}, MV.{row = 1, col = -1}, MV.{row = 1, col = 0}, MV.{row = 1, col = 1}, MV.{row = 0, col = 1}, MV.{row = -1, col = 1}, MV.{row = -1, col = 0} ],
            MV.[ MV.{row = -2, col = -2}, MV.{row = 0, col = -2}, MV.{row = 2, col = -2}, MV.{row = 2, col = 0}, MV.{row = 2, col = 2}, MV.{row = 0, col = 2}, MV.{row = -2, col = 2}, MV.{row = -2, col = 0} ],
            MV.[ MV.{row = -4, col = -4}, MV.{row = 0, col = -4}, MV.{row = 4, col = -4}, MV.{row = 4, col = 0}, MV.{row = 4, col = 4}, MV.{row = 0, col = 4}, MV.{row = -4, col = 4}, MV.{row = -4, col = 0} ],
            MV.[ MV.{row = -8, col = -8}, MV.{row = 0, col = -8}, MV.{row = 8, col = -8}, MV.{row = 8, col = 0}, MV.{row = 8, col = 8}, MV.{row = 0, col = 8}, MV.{row = -8, col = 8}, MV.{row = -8, col = 0} ],
            MV.[ MV.{row = -16, col = -16}, MV.{row = 0, col = -16}, MV.{row = 16, col = -16}, MV.{row = 16, col = 0}, MV.{row = 16, col = 16}, MV.{row = 0, col = 16}, MV.{row = -16, col = 16}, MV.{row = -16, col = 0} ],
            MV.[ MV.{row = -32, col = -32}, MV.{row = 0, col = -32}, MV.{row = 32, col = -32}, MV.{row = 32, col = 0}, MV.{row = 32, col = 32}, MV.{row = 0, col = 32}, MV.{row = -32, col = 32}, MV.{row = -32, col = 0} ],
            MV.[ MV.{row = -64, col = -64}, MV.{row = 0, col = -64}, MV.{row = 64, col = -64}, MV.{row = 64, col = 0}, MV.{row = 64, col = 64}, MV.{row = 0, col = 64}, MV.{row = -64, col = 64}, MV.{row = -64, col = 0} ],
            MV.[ MV.{row = -128, col = -128}, MV.{row = 0, col = -128}, MV.{row = 128, col = -128}, MV.{row = 128, col = 0}, MV.{row = 128, col = 128}, MV.{row = 0, col = 128}, MV.{row = -128, col = 128}, MV.{row = -128, col = 0} ],
            MV.[ MV.{row = -256, col = -256}, MV.{row = 0, col = -256}, MV.{row = 256, col = -256}, MV.{row = 256, col = 0}, MV.{row = 256, col = 256}, MV.{row = 0, col = 256}, MV.{row = -256, col = 256}, MV.{row = -256, col = 0} ],
            MV.[ MV.{row = -512, col = -512}, MV.{row = 0, col = -512}, MV.{row = 512, col = -512}, MV.{row = 512, col = 0}, MV.{row = 512, col = 512}, MV.{row = 0, col = 512}, MV.{row = -512, col = 512}, MV.{row = -512, col = 0} ],
            MV.[ MV.{row = -1024, col = -1024}, MV.{row = 0, col = -1024}, MV.{row = 1024, col = -1024}, MV.{row = 1024, col = 0}, MV.{row = 1024, col = 1024}, MV.{row = 0, col = 1024}, MV.{row = -1024, col = 1024}, MV.{row = -1024, col = 0} ]
        ];
    SEARCH_POS =
        MV.[
            MV.{row = -1, col = 0},
            MV.{row = 0, col = -1},
            MV.{row = 0, col = 1},
            MV.{row = 1, col = 0}
        ];
    FRAME_SCALE_FACTOR_in_vp9_mcomp = s32.[ 16, 24 ];
    RATE_THRESH_MULT_in_vp9_mcomp = float64.[ 1.0, 2.0 ];
    RCF_MULT_in_vp9_mcomp = float64.[ 1.0, 2.0 ];
    COUNT_TO_UPDATE_FACTOR_in_vp9_mcomp =
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
    atomic_store(*globals_initialization_state_for_vp9_mcomp, 2);
}

