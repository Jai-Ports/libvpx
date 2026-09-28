COUNT_TO_UPDATE_FACTOR_in_vp9_entropy: [21] s32;

VP9_PT_ENERGY_CLASS: [12] u8 #align 16;

VP9_CAT1_PROB: [1] u8 #align 16;

VP9_CAT2_PROB: [2] u8 #align 16;

VP9_CAT3_PROB: [3] u8 #align 16;

VP9_CAT4_PROB: [4] u8 #align 16;

VP9_CAT5_PROB: [5] u8 #align 16;

VP9_CAT6_PROB: [14] u8 #align 16;

DEFAULT_COEF_PROBS_32X32: [2] Vp9_Coeff_Probs_Model;

DEFAULT_COEF_PROBS_16X16: [2] Vp9_Coeff_Probs_Model;

DEFAULT_COEF_PROBS_8X8: [2] Vp9_Coeff_Probs_Model;

DEFAULT_COEF_PROBS_4X4: [2] Vp9_Coeff_Probs_Model;

VP9_COEFBAND_TRANS_8X8PLUS: [1024] u8 #align 16;

VP9_COEFBAND_TRANS_4X4: [16] u8 #align 16;

VP9_COEF_CON_TREE: [22] Tree_Index;

VP9_PARETO8_FULL: [255] [8] Prob;

SUB_PEL_FILTERS_12_storage: [16] Interp_Kernel12 #align 256;

clip_pixel_in_vp9_entropy :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_entropy :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_entropy :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_entropy :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_entropy :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_entropy(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_entropy(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_entropy(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_entropy :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_prob_in_vp9_entropy :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_entropy :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_entropy(n0, DEN);
}

weighted_prob_in_vp9_entropy :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_entropy :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_entropy(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_entropy(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_entropy :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_entropy[COUNT];
        PROB := get_prob_in_vp9_entropy(ct[0], DEN);
        return weighted_prob_in_vp9_entropy(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_lsb_in_vp9_entropy :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_entropy :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_entropy :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_entropy(num_values) + 1 else 0;
}

vp9_default_coef_probs :: (cm: *VP9_COMMON) {
    {
        #assert (2 * (2 * (6 * (6 * (3 * cast(u64) size_of(Prob)))))) == DEFAULT_COEF_PROBS_4X4.count * size_of(Vp9_Coeff_Probs_Model);

        copy_memory(
            cm.fc.coef_probs[0].data,
            DEFAULT_COEF_PROBS_4X4.data,
            DEFAULT_COEF_PROBS_4X4.count * size_of(Vp9_Coeff_Probs_Model)
        );
    }
    {
        #assert (2 * (2 * (6 * (6 * (3 * cast(u64) size_of(Prob)))))) == DEFAULT_COEF_PROBS_8X8.count * size_of(Vp9_Coeff_Probs_Model);

        copy_memory(
            cm.fc.coef_probs[1].data,
            DEFAULT_COEF_PROBS_8X8.data,
            DEFAULT_COEF_PROBS_8X8.count * size_of(Vp9_Coeff_Probs_Model)
        );
    }
    {
        #assert (2 * (2 * (6 * (6 * (3 * cast(u64) size_of(Prob)))))) == DEFAULT_COEF_PROBS_16X16.count * size_of(Vp9_Coeff_Probs_Model);

        copy_memory(
            cm.fc.coef_probs[2].data,
            DEFAULT_COEF_PROBS_16X16.data,
            DEFAULT_COEF_PROBS_16X16.count * size_of(Vp9_Coeff_Probs_Model)
        );
    }
    {
        #assert (2 * (2 * (6 * (6 * (3 * cast(u64) size_of(Prob)))))) == DEFAULT_COEF_PROBS_32X32.count * size_of(Vp9_Coeff_Probs_Model);

        copy_memory(
            cm.fc.coef_probs[3].data,
            DEFAULT_COEF_PROBS_32X32.data,
            DEFAULT_COEF_PROBS_32X32.count * size_of(Vp9_Coeff_Probs_Model)
        );
    }
}

vp9_adapt_coef_probs :: (cm: *VP9_COMMON) {
    count_sat, update_factor: u32 = ---;

    if frame_is_intra_only_in_vp9_entropy(cm) != 0 {
        update_factor = 112;
        count_sat = 24;
    } else if cm.last_frame_type == cast,no_check(u32) KEY_FRAME {
        update_factor = 128;
        count_sat = 24;
    } else {
        update_factor = 112;
        count_sat = 24;
    }
    t: TX_SIZE = 0;
    while t <= cast(TX_SIZE) 3 {
        adapt_coef_probs(cm, t, count_sat, update_factor);
        t += 1;
    }
}

adapt_coef_probs :: (cm: *VP9_COMMON, tx_size: TX_SIZE, count_sat: u32, update_factor: u32) {
    pre_fc := *(cast(*Frame_Contexts) (cm.frame_contexts))[cm.frame_context_idx];
    PROBS := cm.fc.coef_probs[tx_size].data;
    PRE_PROBS := pre_fc.coef_probs[tx_size].data;
    counts := cm.counts.coef[tx_size].data;
    eob_counts: *[2] [6] [6] u32 = cm.counts.eob_branch[tx_size].data;
    j: s32 = ---;
    k: s32 = ---;
    l: s32 = ---;
    m: s32 = ---;

    i: s32 = 0;
    while i < PLANE_TYPES {
        j = 0;
        while j < 2 {
            k = 0;
            while k < 6 {
                l = 0;
                while l < (ifx k == 0 then cast(s32) 3 else 6) {
                    N0 := cast,no_check(s32) counts[i][j][k][l][0];
                    N1 := cast,no_check(s32) counts[i][j][k][l][1];
                    N2 := cast,no_check(s32) counts[i][j][k][l][2];
                    NEOB := cast,no_check(s32) counts[i][j][k][l][3];
                    BRANCH_CT :=
                        [2] u32.[
                            u32.[ cast,no_check(u32) NEOB, eob_counts[i][j][k][l] - cast,no_check(u32) NEOB ],
                            u32.[ cast,no_check(u32) N0, cast,no_check(u32) (N1 + N2) ],
                            u32.[ cast,no_check(u32) N1, cast,no_check(u32) N2 ]
                        ];
                    m = 0;
                    while m < 3 {
                        PROBS[i][j][k][l][m] =
                            merge_probs_in_vp9_entropy(
                                PRE_PROBS[i][j][k][l][m],
                                BRANCH_CT[m].data,
                                count_sat,
                                update_factor
                            );
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

frame_is_intra_only_in_vp9_entropy :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

get_band_translate_in_vp9_entropy :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

vp9_model_to_full_probs :: (model: *Prob, full: *Prob) {
    if full != model {
        copy_memory(full, model, 3);
    }
    extend_to_full_distribution(*full[3], model[2]);
}

extend_to_full_distribution :: (probs: *Prob, p: Prob) {
    copy_memory(probs, VP9_PARETO8_FULL[(cast(s32) p) - 1].data, cast,no_check(u64) (11 - 3));
}

combine_entropy_contexts_in_vp9_entropy :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_entropy :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_entropy(above_ec, left_ec);
}

is_zero_mv_in_vp9_entropy :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_entropy :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_entropy :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_entropy(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_entropy(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_entropy :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_entropy :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_entropy :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_entropy :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

get_filter_taps_in_vp9_entropy :: (FILTER: *s16) -> s32 {
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

vp9_is_valid_scale_in_vp9_entropy :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_entropy :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_entropy(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_entropy :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_entropy :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_entropy :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_entropy :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_entropy :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_entropy :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_entropy :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_entropy :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_entropy :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_entropy :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_entropy :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_entropy(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_entropy :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_entropy(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_entropy(MI, ib)];
}

get_uv_tx_size_in_vp9_entropy :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_entropy :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_entropy :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_entropy(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_entropy :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

get_lfm_in_vp9_entropy :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

init_frame_indexes_in_vp9_entropy :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_entropy :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_entropy :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_entropy :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_entropy :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_entropy :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_entropy :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_entropy :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_entropy :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

set_partition_probs_in_vp9_entropy :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_entropy(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_entropy :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_entropy(cm.mi_cols);

        if get_plane_type_in_vp9_entropy(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_entropy(cm, xd);
}

get_partition_probs_in_vp9_entropy :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_entropy :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_entropy :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_entropy :: (
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

update_partition_context_in_vp9_entropy :: (
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

partition_plane_context_in_vp9_entropy :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

globals_initialization_state_for_vp9_entropy: u32;
initialize_globals_for_vp9_entropy :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_entropy);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_entropy, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_entropy) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_vp9_entropy =
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
    SUB_PEL_FILTERS_12_storage =
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
    VP9_COEF_CON_TREE =
        Tree_Index.[
            2,
            6,
            -2,
            4,
            -3,
            -4,
            8,
            10,
            -5,
            -6,
            12,
            14,
            -7,
            -8,
            -9,
            -10,
            cast,no_check(Tree_Index) 0,
            cast,no_check(Tree_Index) 0,
            cast,no_check(Tree_Index) 0,
            cast,no_check(Tree_Index) 0,
            cast,no_check(Tree_Index) 0,
            cast,no_check(Tree_Index) 0
        ];
    VP9_CAT1_PROB = u8.[ 159 ];
    VP9_CAT2_PROB = u8.[ 165, 145 ];
    VP9_CAT3_PROB = u8.[ 173, 148, 140 ];
    VP9_CAT4_PROB = u8.[ 176, 155, 140, 135 ];
    VP9_CAT5_PROB =
        u8.[
            180,
            157,
            141,
            134,
            130
        ];
    VP9_CAT6_PROB =
        u8.[
            254,
            254,
            254,
            252,
            249,
            243,
            230,
            196,
            177,
            153,
            140,
            133,
            130,
            129
        ];
    VP9_COEFBAND_TRANS_8X8PLUS =
        u8.[
            0,
            1,
            1,
            2,
            2,
            2,
            3,
            3,
            3,
            3,
            4,
            4,
            4,
            4,
            4,
            4,
            4,
            4,
            4,
            4,
            4,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5,
            5
        ];
    VP9_COEFBAND_TRANS_4X4 =
        u8.[
            0,
            1,
            1,
            2,
            2,
            2,
            3,
            3,
            3,
            3,
            4,
            4,
            4,
            5,
            5,
            5
        ];
    VP9_PT_ENERGY_CLASS =
        u8.[
            0,
            1,
            2,
            3,
            3,
            4,
            4,
            5,
            5,
            5,
            5,
            5
        ];
    VP9_PARETO8_FULL =
        [8] Prob.[
            Prob.[ 3, 86, 128, 6, 86, 23, 88, 29 ],
            Prob.[ 6, 86, 128, 11, 87, 42, 91, 52 ],
            Prob.[ 9, 86, 129, 17, 88, 61, 94, 76 ],
            Prob.[ 12, 86, 129, 22, 88, 77, 97, 93 ],
            Prob.[ 15, 87, 129, 28, 89, 93, 100, 110 ],
            Prob.[ 17, 87, 129, 33, 90, 105, 103, 123 ],
            Prob.[ 20, 88, 130, 38, 91, 118, 106, 136 ],
            Prob.[ 23, 88, 130, 43, 91, 128, 108, 146 ],
            Prob.[ 26, 89, 131, 48, 92, 139, 111, 156 ],
            Prob.[ 28, 89, 131, 53, 93, 147, 114, 163 ],
            Prob.[ 31, 90, 131, 58, 94, 156, 117, 171 ],
            Prob.[ 34, 90, 131, 62, 94, 163, 119, 177 ],
            Prob.[ 37, 90, 132, 66, 95, 171, 122, 184 ],
            Prob.[ 39, 90, 132, 70, 96, 177, 124, 189 ],
            Prob.[ 42, 91, 132, 75, 97, 183, 127, 194 ],
            Prob.[ 44, 91, 132, 79, 97, 188, 129, 198 ],
            Prob.[ 47, 92, 133, 83, 98, 193, 132, 202 ],
            Prob.[ 49, 92, 133, 86, 99, 197, 134, 205 ],
            Prob.[ 52, 93, 133, 90, 100, 201, 137, 208 ],
            Prob.[ 54, 93, 133, 94, 100, 204, 139, 211 ],
            Prob.[ 57, 94, 134, 98, 101, 208, 142, 214 ],
            Prob.[ 59, 94, 134, 101, 102, 211, 144, 216 ],
            Prob.[ 62, 94, 135, 105, 103, 214, 146, 218 ],
            Prob.[ 64, 94, 135, 108, 103, 216, 148, 220 ],
            Prob.[ 66, 95, 135, 111, 104, 219, 151, 222 ],
            Prob.[ 68, 95, 135, 114, 105, 221, 153, 223 ],
            Prob.[ 71, 96, 136, 117, 106, 224, 155, 225 ],
            Prob.[ 73, 96, 136, 120, 106, 225, 157, 226 ],
            Prob.[ 76, 97, 136, 123, 107, 227, 159, 228 ],
            Prob.[ 78, 97, 136, 126, 108, 229, 160, 229 ],
            Prob.[ 80, 98, 137, 129, 109, 231, 162, 231 ],
            Prob.[ 82, 98, 137, 131, 109, 232, 164, 232 ],
            Prob.[ 84, 98, 138, 134, 110, 234, 166, 233 ],
            Prob.[ 86, 98, 138, 137, 111, 235, 168, 234 ],
            Prob.[ 89, 99, 138, 140, 112, 236, 170, 235 ],
            Prob.[ 91, 99, 138, 142, 112, 237, 171, 235 ],
            Prob.[ 93, 100, 139, 145, 113, 238, 173, 236 ],
            Prob.[ 95, 100, 139, 147, 114, 239, 174, 237 ],
            Prob.[ 97, 101, 140, 149, 115, 240, 176, 238 ],
            Prob.[ 99, 101, 140, 151, 115, 241, 177, 238 ],
            Prob.[ 101, 102, 140, 154, 116, 242, 179, 239 ],
            Prob.[ 103, 102, 140, 156, 117, 242, 180, 239 ],
            Prob.[ 105, 103, 141, 158, 118, 243, 182, 240 ],
            Prob.[ 107, 103, 141, 160, 118, 243, 183, 240 ],
            Prob.[ 109, 104, 141, 162, 119, 244, 185, 241 ],
            Prob.[ 111, 104, 141, 164, 119, 244, 186, 241 ],
            Prob.[ 113, 104, 142, 166, 120, 245, 187, 242 ],
            Prob.[ 114, 104, 142, 168, 121, 245, 188, 242 ],
            Prob.[ 116, 105, 143, 170, 122, 246, 190, 243 ],
            Prob.[ 118, 105, 143, 171, 122, 246, 191, 243 ],
            Prob.[ 120, 106, 143, 173, 123, 247, 192, 244 ],
            Prob.[ 121, 106, 143, 175, 124, 247, 193, 244 ],
            Prob.[ 123, 107, 144, 177, 125, 248, 195, 244 ],
            Prob.[ 125, 107, 144, 178, 125, 248, 196, 244 ],
            Prob.[ 127, 108, 145, 180, 126, 249, 197, 245 ],
            Prob.[ 128, 108, 145, 181, 127, 249, 198, 245 ],
            Prob.[ 130, 109, 145, 183, 128, 249, 199, 245 ],
            Prob.[ 132, 109, 145, 184, 128, 249, 200, 245 ],
            Prob.[ 134, 110, 146, 186, 129, 250, 201, 246 ],
            Prob.[ 135, 110, 146, 187, 130, 250, 202, 246 ],
            Prob.[ 137, 111, 147, 189, 131, 251, 203, 246 ],
            Prob.[ 138, 111, 147, 190, 131, 251, 204, 246 ],
            Prob.[ 140, 112, 147, 192, 132, 251, 205, 247 ],
            Prob.[ 141, 112, 147, 193, 132, 251, 206, 247 ],
            Prob.[ 143, 113, 148, 194, 133, 251, 207, 247 ],
            Prob.[ 144, 113, 148, 195, 134, 251, 207, 247 ],
            Prob.[ 146, 114, 149, 197, 135, 252, 208, 248 ],
            Prob.[ 147, 114, 149, 198, 135, 252, 209, 248 ],
            Prob.[ 149, 115, 149, 199, 136, 252, 210, 248 ],
            Prob.[ 150, 115, 149, 200, 137, 252, 210, 248 ],
            Prob.[ 152, 115, 150, 201, 138, 252, 211, 248 ],
            Prob.[ 153, 115, 150, 202, 138, 252, 212, 248 ],
            Prob.[ 155, 116, 151, 204, 139, 253, 213, 249 ],
            Prob.[ 156, 116, 151, 205, 139, 253, 213, 249 ],
            Prob.[ 158, 117, 151, 206, 140, 253, 214, 249 ],
            Prob.[ 159, 117, 151, 207, 141, 253, 215, 249 ],
            Prob.[ 161, 118, 152, 208, 142, 253, 216, 249 ],
            Prob.[ 162, 118, 152, 209, 142, 253, 216, 249 ],
            Prob.[ 163, 119, 153, 210, 143, 253, 217, 249 ],
            Prob.[ 164, 119, 153, 211, 143, 253, 217, 249 ],
            Prob.[ 166, 120, 153, 212, 144, 254, 218, 250 ],
            Prob.[ 167, 120, 153, 212, 145, 254, 219, 250 ],
            Prob.[ 168, 121, 154, 213, 146, 254, 220, 250 ],
            Prob.[ 169, 121, 154, 214, 146, 254, 220, 250 ],
            Prob.[ 171, 122, 155, 215, 147, 254, 221, 250 ],
            Prob.[ 172, 122, 155, 216, 147, 254, 221, 250 ],
            Prob.[ 173, 123, 155, 217, 148, 254, 222, 250 ],
            Prob.[ 174, 123, 155, 217, 149, 254, 222, 250 ],
            Prob.[ 176, 124, 156, 218, 150, 254, 223, 250 ],
            Prob.[ 177, 124, 156, 219, 150, 254, 223, 250 ],
            Prob.[ 178, 125, 157, 220, 151, 254, 224, 251 ],
            Prob.[ 179, 125, 157, 220, 151, 254, 224, 251 ],
            Prob.[ 180, 126, 157, 221, 152, 254, 225, 251 ],
            Prob.[ 181, 126, 157, 221, 152, 254, 225, 251 ],
            Prob.[ 183, 127, 158, 222, 153, 254, 226, 251 ],
            Prob.[ 184, 127, 158, 223, 154, 254, 226, 251 ],
            Prob.[ 185, 128, 159, 224, 155, 255, 227, 251 ],
            Prob.[ 186, 128, 159, 224, 155, 255, 227, 251 ],
            Prob.[ 187, 129, 160, 225, 156, 255, 228, 251 ],
            Prob.[ 188, 130, 160, 225, 156, 255, 228, 251 ],
            Prob.[ 189, 131, 160, 226, 157, 255, 228, 251 ],
            Prob.[ 190, 131, 160, 226, 158, 255, 228, 251 ],
            Prob.[ 191, 132, 161, 227, 159, 255, 229, 251 ],
            Prob.[ 192, 132, 161, 227, 159, 255, 229, 251 ],
            Prob.[ 193, 133, 162, 228, 160, 255, 230, 252 ],
            Prob.[ 194, 133, 162, 229, 160, 255, 230, 252 ],
            Prob.[ 195, 134, 163, 230, 161, 255, 231, 252 ],
            Prob.[ 196, 134, 163, 230, 161, 255, 231, 252 ],
            Prob.[ 197, 135, 163, 231, 162, 255, 231, 252 ],
            Prob.[ 198, 135, 163, 231, 162, 255, 231, 252 ],
            Prob.[ 199, 136, 164, 232, 163, 255, 232, 252 ],
            Prob.[ 200, 136, 164, 232, 164, 255, 232, 252 ],
            Prob.[ 201, 137, 165, 233, 165, 255, 233, 252 ],
            Prob.[ 201, 137, 165, 233, 165, 255, 233, 252 ],
            Prob.[ 202, 138, 166, 233, 166, 255, 233, 252 ],
            Prob.[ 203, 138, 166, 233, 166, 255, 233, 252 ],
            Prob.[ 204, 139, 166, 234, 167, 255, 234, 252 ],
            Prob.[ 205, 139, 166, 234, 167, 255, 234, 252 ],
            Prob.[ 206, 140, 167, 235, 168, 255, 235, 252 ],
            Prob.[ 206, 140, 167, 235, 168, 255, 235, 252 ],
            Prob.[ 207, 141, 168, 236, 169, 255, 235, 252 ],
            Prob.[ 208, 141, 168, 236, 170, 255, 235, 252 ],
            Prob.[ 209, 142, 169, 237, 171, 255, 236, 252 ],
            Prob.[ 209, 143, 169, 237, 171, 255, 236, 252 ],
            Prob.[ 210, 144, 169, 237, 172, 255, 236, 252 ],
            Prob.[ 211, 144, 169, 237, 172, 255, 236, 252 ],
            Prob.[ 212, 145, 170, 238, 173, 255, 237, 252 ],
            Prob.[ 213, 145, 170, 238, 173, 255, 237, 252 ],
            Prob.[ 214, 146, 171, 239, 174, 255, 237, 253 ],
            Prob.[ 214, 146, 171, 239, 174, 255, 237, 253 ],
            Prob.[ 215, 147, 172, 240, 175, 255, 238, 253 ],
            Prob.[ 215, 147, 172, 240, 175, 255, 238, 253 ],
            Prob.[ 216, 148, 173, 240, 176, 255, 238, 253 ],
            Prob.[ 217, 148, 173, 240, 176, 255, 238, 253 ],
            Prob.[ 218, 149, 173, 241, 177, 255, 239, 253 ],
            Prob.[ 218, 149, 173, 241, 178, 255, 239, 253 ],
            Prob.[ 219, 150, 174, 241, 179, 255, 239, 253 ],
            Prob.[ 219, 151, 174, 241, 179, 255, 239, 253 ],
            Prob.[ 220, 152, 175, 242, 180, 255, 240, 253 ],
            Prob.[ 221, 152, 175, 242, 180, 255, 240, 253 ],
            Prob.[ 222, 153, 176, 242, 181, 255, 240, 253 ],
            Prob.[ 222, 153, 176, 242, 181, 255, 240, 253 ],
            Prob.[ 223, 154, 177, 243, 182, 255, 240, 253 ],
            Prob.[ 223, 154, 177, 243, 182, 255, 240, 253 ],
            Prob.[ 224, 155, 178, 244, 183, 255, 241, 253 ],
            Prob.[ 224, 155, 178, 244, 183, 255, 241, 253 ],
            Prob.[ 225, 156, 178, 244, 184, 255, 241, 253 ],
            Prob.[ 225, 157, 178, 244, 184, 255, 241, 253 ],
            Prob.[ 226, 158, 179, 244, 185, 255, 242, 253 ],
            Prob.[ 227, 158, 179, 244, 185, 255, 242, 253 ],
            Prob.[ 228, 159, 180, 245, 186, 255, 242, 253 ],
            Prob.[ 228, 159, 180, 245, 186, 255, 242, 253 ],
            Prob.[ 229, 160, 181, 245, 187, 255, 242, 253 ],
            Prob.[ 229, 160, 181, 245, 187, 255, 242, 253 ],
            Prob.[ 230, 161, 182, 246, 188, 255, 243, 253 ],
            Prob.[ 230, 162, 182, 246, 188, 255, 243, 253 ],
            Prob.[ 231, 163, 183, 246, 189, 255, 243, 253 ],
            Prob.[ 231, 163, 183, 246, 189, 255, 243, 253 ],
            Prob.[ 232, 164, 184, 247, 190, 255, 243, 253 ],
            Prob.[ 232, 164, 184, 247, 190, 255, 243, 253 ],
            Prob.[ 233, 165, 185, 247, 191, 255, 244, 253 ],
            Prob.[ 233, 165, 185, 247, 191, 255, 244, 253 ],
            Prob.[ 234, 166, 185, 247, 192, 255, 244, 253 ],
            Prob.[ 234, 167, 185, 247, 192, 255, 244, 253 ],
            Prob.[ 235, 168, 186, 248, 193, 255, 244, 253 ],
            Prob.[ 235, 168, 186, 248, 193, 255, 244, 253 ],
            Prob.[ 236, 169, 187, 248, 194, 255, 244, 253 ],
            Prob.[ 236, 169, 187, 248, 194, 255, 244, 253 ],
            Prob.[ 236, 170, 188, 248, 195, 255, 245, 253 ],
            Prob.[ 236, 170, 188, 248, 195, 255, 245, 253 ],
            Prob.[ 237, 171, 189, 249, 196, 255, 245, 254 ],
            Prob.[ 237, 172, 189, 249, 196, 255, 245, 254 ],
            Prob.[ 238, 173, 190, 249, 197, 255, 245, 254 ],
            Prob.[ 238, 173, 190, 249, 197, 255, 245, 254 ],
            Prob.[ 239, 174, 191, 249, 198, 255, 245, 254 ],
            Prob.[ 239, 174, 191, 249, 198, 255, 245, 254 ],
            Prob.[ 240, 175, 192, 249, 199, 255, 246, 254 ],
            Prob.[ 240, 176, 192, 249, 199, 255, 246, 254 ],
            Prob.[ 240, 177, 193, 250, 200, 255, 246, 254 ],
            Prob.[ 240, 177, 193, 250, 200, 255, 246, 254 ],
            Prob.[ 241, 178, 194, 250, 201, 255, 246, 254 ],
            Prob.[ 241, 178, 194, 250, 201, 255, 246, 254 ],
            Prob.[ 242, 179, 195, 250, 202, 255, 246, 254 ],
            Prob.[ 242, 180, 195, 250, 202, 255, 246, 254 ],
            Prob.[ 242, 181, 196, 250, 203, 255, 247, 254 ],
            Prob.[ 242, 181, 196, 250, 203, 255, 247, 254 ],
            Prob.[ 243, 182, 197, 251, 204, 255, 247, 254 ],
            Prob.[ 243, 183, 197, 251, 204, 255, 247, 254 ],
            Prob.[ 244, 184, 198, 251, 205, 255, 247, 254 ],
            Prob.[ 244, 184, 198, 251, 205, 255, 247, 254 ],
            Prob.[ 244, 185, 199, 251, 206, 255, 247, 254 ],
            Prob.[ 244, 185, 199, 251, 206, 255, 247, 254 ],
            Prob.[ 245, 186, 200, 251, 207, 255, 247, 254 ],
            Prob.[ 245, 187, 200, 251, 207, 255, 247, 254 ],
            Prob.[ 246, 188, 201, 252, 207, 255, 248, 254 ],
            Prob.[ 246, 188, 201, 252, 207, 255, 248, 254 ],
            Prob.[ 246, 189, 202, 252, 208, 255, 248, 254 ],
            Prob.[ 246, 190, 202, 252, 208, 255, 248, 254 ],
            Prob.[ 247, 191, 203, 252, 209, 255, 248, 254 ],
            Prob.[ 247, 191, 203, 252, 209, 255, 248, 254 ],
            Prob.[ 247, 192, 204, 252, 210, 255, 248, 254 ],
            Prob.[ 247, 193, 204, 252, 210, 255, 248, 254 ],
            Prob.[ 248, 194, 205, 252, 211, 255, 248, 254 ],
            Prob.[ 248, 194, 205, 252, 211, 255, 248, 254 ],
            Prob.[ 248, 195, 206, 252, 212, 255, 249, 254 ],
            Prob.[ 248, 196, 206, 252, 212, 255, 249, 254 ],
            Prob.[ 249, 197, 207, 253, 213, 255, 249, 254 ],
            Prob.[ 249, 197, 207, 253, 213, 255, 249, 254 ],
            Prob.[ 249, 198, 208, 253, 214, 255, 249, 254 ],
            Prob.[ 249, 199, 209, 253, 214, 255, 249, 254 ],
            Prob.[ 250, 200, 210, 253, 215, 255, 249, 254 ],
            Prob.[ 250, 200, 210, 253, 215, 255, 249, 254 ],
            Prob.[ 250, 201, 211, 253, 215, 255, 249, 254 ],
            Prob.[ 250, 202, 211, 253, 215, 255, 249, 254 ],
            Prob.[ 250, 203, 212, 253, 216, 255, 249, 254 ],
            Prob.[ 250, 203, 212, 253, 216, 255, 249, 254 ],
            Prob.[ 251, 204, 213, 253, 217, 255, 250, 254 ],
            Prob.[ 251, 205, 213, 253, 217, 255, 250, 254 ],
            Prob.[ 251, 206, 214, 254, 218, 255, 250, 254 ],
            Prob.[ 251, 206, 215, 254, 218, 255, 250, 254 ],
            Prob.[ 252, 207, 216, 254, 219, 255, 250, 254 ],
            Prob.[ 252, 208, 216, 254, 219, 255, 250, 254 ],
            Prob.[ 252, 209, 217, 254, 220, 255, 250, 254 ],
            Prob.[ 252, 210, 217, 254, 220, 255, 250, 254 ],
            Prob.[ 252, 211, 218, 254, 221, 255, 250, 254 ],
            Prob.[ 252, 212, 218, 254, 221, 255, 250, 254 ],
            Prob.[ 253, 213, 219, 254, 222, 255, 250, 254 ],
            Prob.[ 253, 213, 220, 254, 222, 255, 250, 254 ],
            Prob.[ 253, 214, 221, 254, 223, 255, 250, 254 ],
            Prob.[ 253, 215, 221, 254, 223, 255, 250, 254 ],
            Prob.[ 253, 216, 222, 254, 224, 255, 251, 254 ],
            Prob.[ 253, 217, 223, 254, 224, 255, 251, 254 ],
            Prob.[ 253, 218, 224, 254, 225, 255, 251, 254 ],
            Prob.[ 253, 219, 224, 254, 225, 255, 251, 254 ],
            Prob.[ 254, 220, 225, 254, 225, 255, 251, 254 ],
            Prob.[ 254, 221, 226, 254, 225, 255, 251, 254 ],
            Prob.[ 254, 222, 227, 255, 226, 255, 251, 254 ],
            Prob.[ 254, 223, 227, 255, 226, 255, 251, 254 ],
            Prob.[ 254, 224, 228, 255, 227, 255, 251, 254 ],
            Prob.[ 254, 225, 229, 255, 227, 255, 251, 254 ],
            Prob.[ 254, 226, 230, 255, 228, 255, 251, 254 ],
            Prob.[ 254, 227, 230, 255, 229, 255, 251, 254 ],
            Prob.[ 255, 228, 231, 255, 230, 255, 251, 254 ],
            Prob.[ 255, 229, 232, 255, 230, 255, 251, 254 ],
            Prob.[ 255, 230, 233, 255, 231, 255, 252, 254 ],
            Prob.[ 255, 231, 234, 255, 231, 255, 252, 254 ],
            Prob.[ 255, 232, 235, 255, 232, 255, 252, 254 ],
            Prob.[ 255, 233, 236, 255, 232, 255, 252, 254 ],
            Prob.[ 255, 235, 237, 255, 233, 255, 252, 254 ],
            Prob.[ 255, 236, 238, 255, 234, 255, 252, 254 ],
            Prob.[ 255, 238, 240, 255, 235, 255, 252, 255 ],
            Prob.[ 255, 239, 241, 255, 235, 255, 252, 254 ],
            Prob.[ 255, 241, 243, 255, 236, 255, 252, 254 ],
            Prob.[ 255, 243, 245, 255, 237, 255, 252, 254 ],
            Prob.[ 255, 246, 247, 255, 239, 255, 253, 255 ]
        ];
    DEFAULT_COEF_PROBS_4X4 =
        Vp9_Coeff_Probs_Model.[
            [6] [6] [3] Prob.[ [6] [3] Prob.[ [3] Prob.[ Prob.[ 195, 29, 183 ], Prob.[ 84, 49, 136 ], Prob.[ 8, 42, 71 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ] ], [3] Prob.[ Prob.[ 31, 107, 169 ], Prob.[ 35, 99, 159 ], Prob.[ 17, 82, 140 ], Prob.[ 8, 66, 114 ], Prob.[ 2, 44, 76 ], Prob.[ 1, 19, 32 ] ], [3] Prob.[ Prob.[ 40, 132, 201 ], Prob.[ 29, 114, 187 ], Prob.[ 13, 91, 157 ], Prob.[ 7, 75, 127 ], Prob.[ 3, 58, 95 ], Prob.[ 1, 28, 47 ] ], [3] Prob.[ Prob.[ 69, 142, 221 ], Prob.[ 42, 122, 201 ], Prob.[ 15, 91, 159 ], Prob.[ 6, 67, 121 ], Prob.[ 1, 42, 77 ], Prob.[ 1, 17, 31 ] ], [3] Prob.[ Prob.[ 102, 148, 228 ], Prob.[ 67, 117, 204 ], Prob.[ 17, 82, 154 ], Prob.[ 6, 59, 114 ], Prob.[ 2, 39, 75 ], Prob.[ 1, 15, 29 ] ], [3] Prob.[ Prob.[ 156, 57, 233 ], Prob.[ 119, 57, 212 ], Prob.[ 58, 48, 163 ], Prob.[ 29, 40, 124 ], Prob.[ 12, 30, 81 ], Prob.[ 3, 12, 31 ] ] ], [6] [3] Prob.[ [3] Prob.[ Prob.[ 191, 107, 226 ], Prob.[ 124, 117, 204 ], Prob.[ 25, 99, 155 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ] ], [3] Prob.[ Prob.[ 29, 148, 210 ], Prob.[ 37, 126, 194 ], Prob.[ 8, 93, 157 ], Prob.[ 2, 68, 118 ], Prob.[ 1, 39, 69 ], Prob.[ 1, 17, 33 ] ], [3] Prob.[ Prob.[ 41, 151, 213 ], Prob.[ 27, 123, 193 ], Prob.[ 3, 82, 144 ], Prob.[ 1, 58, 105 ], Prob.[ 1, 32, 60 ], Prob.[ 1, 13, 26 ] ], [3] Prob.[ Prob.[ 59, 159, 220 ], Prob.[ 23, 126, 198 ], Prob.[ 4, 88, 151 ], Prob.[ 1, 66, 114 ], Prob.[ 1, 38, 71 ], Prob.[ 1, 18, 34 ] ], [3] Prob.[ Prob.[ 114, 136, 232 ], Prob.[ 51, 114, 207 ], Prob.[ 11, 83, 155 ], Prob.[ 3, 56, 105 ], Prob.[ 1, 33, 65 ], Prob.[ 1, 17, 34 ] ], [3] Prob.[ Prob.[ 149, 65, 234 ], Prob.[ 121, 57, 215 ], Prob.[ 61, 49, 166 ], Prob.[ 28, 36, 114 ], Prob.[ 12, 25, 76 ], Prob.[ 3, 16, 42 ] ] ] ],
            [6] [6] [3] Prob.[ [6] [3] Prob.[ [3] Prob.[ Prob.[ 214, 49, 220 ], Prob.[ 132, 63, 188 ], Prob.[ 42, 65, 137 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ] ], [3] Prob.[ Prob.[ 85, 137, 221 ], Prob.[ 104, 131, 216 ], Prob.[ 49, 111, 192 ], Prob.[ 21, 87, 155 ], Prob.[ 2, 49, 87 ], Prob.[ 1, 16, 28 ] ], [3] Prob.[ Prob.[ 89, 163, 230 ], Prob.[ 90, 137, 220 ], Prob.[ 29, 100, 183 ], Prob.[ 10, 70, 135 ], Prob.[ 2, 42, 81 ], Prob.[ 1, 17, 33 ] ], [3] Prob.[ Prob.[ 108, 167, 237 ], Prob.[ 55, 133, 222 ], Prob.[ 15, 97, 179 ], Prob.[ 4, 72, 135 ], Prob.[ 1, 45, 85 ], Prob.[ 1, 19, 38 ] ], [3] Prob.[ Prob.[ 124, 146, 240 ], Prob.[ 66, 124, 224 ], Prob.[ 17, 88, 175 ], Prob.[ 4, 58, 122 ], Prob.[ 1, 36, 75 ], Prob.[ 1, 18, 37 ] ], [3] Prob.[ Prob.[ 141, 79, 241 ], Prob.[ 126, 70, 227 ], Prob.[ 66, 58, 182 ], Prob.[ 30, 44, 136 ], Prob.[ 12, 34, 96 ], Prob.[ 2, 20, 47 ] ] ], [6] [3] Prob.[ [3] Prob.[ Prob.[ 229, 99, 249 ], Prob.[ 143, 111, 235 ], Prob.[ 46, 109, 192 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ] ], [3] Prob.[ Prob.[ 82, 158, 236 ], Prob.[ 94, 146, 224 ], Prob.[ 25, 117, 191 ], Prob.[ 9, 87, 149 ], Prob.[ 3, 56, 99 ], Prob.[ 1, 33, 57 ] ], [3] Prob.[ Prob.[ 83, 167, 237 ], Prob.[ 68, 145, 222 ], Prob.[ 10, 103, 177 ], Prob.[ 2, 72, 131 ], Prob.[ 1, 41, 79 ], Prob.[ 1, 20, 39 ] ], [3] Prob.[ Prob.[ 99, 167, 239 ], Prob.[ 47, 141, 224 ], Prob.[ 10, 104, 178 ], Prob.[ 2, 73, 133 ], Prob.[ 1, 44, 85 ], Prob.[ 1, 22, 47 ] ], [3] Prob.[ Prob.[ 127, 145, 243 ], Prob.[ 71, 129, 228 ], Prob.[ 17, 93, 177 ], Prob.[ 3, 61, 124 ], Prob.[ 1, 41, 84 ], Prob.[ 1, 21, 52 ] ], [3] Prob.[ Prob.[ 157, 78, 244 ], Prob.[ 140, 72, 231 ], Prob.[ 69, 58, 184 ], Prob.[ 31, 44, 137 ], Prob.[ 14, 38, 105 ], Prob.[ 8, 23, 61 ] ] ] ]
        ];
    DEFAULT_COEF_PROBS_8X8 =
        Vp9_Coeff_Probs_Model.[
            [6] [6] [3] Prob.[ [6] [3] Prob.[ [3] Prob.[ Prob.[ 125, 34, 187 ], Prob.[ 52, 41, 133 ], Prob.[ 6, 31, 56 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ] ], [3] Prob.[ Prob.[ 37, 109, 153 ], Prob.[ 51, 102, 147 ], Prob.[ 23, 87, 128 ], Prob.[ 8, 67, 101 ], Prob.[ 1, 41, 63 ], Prob.[ 1, 19, 29 ] ], [3] Prob.[ Prob.[ 31, 154, 185 ], Prob.[ 17, 127, 175 ], Prob.[ 6, 96, 145 ], Prob.[ 2, 73, 114 ], Prob.[ 1, 51, 82 ], Prob.[ 1, 28, 45 ] ], [3] Prob.[ Prob.[ 23, 163, 200 ], Prob.[ 10, 131, 185 ], Prob.[ 2, 93, 148 ], Prob.[ 1, 67, 111 ], Prob.[ 1, 41, 69 ], Prob.[ 1, 14, 24 ] ], [3] Prob.[ Prob.[ 29, 176, 217 ], Prob.[ 12, 145, 201 ], Prob.[ 3, 101, 156 ], Prob.[ 1, 69, 111 ], Prob.[ 1, 39, 63 ], Prob.[ 1, 14, 23 ] ], [3] Prob.[ Prob.[ 57, 192, 233 ], Prob.[ 25, 154, 215 ], Prob.[ 6, 109, 167 ], Prob.[ 3, 78, 118 ], Prob.[ 1, 48, 69 ], Prob.[ 1, 21, 29 ] ] ], [6] [3] Prob.[ [3] Prob.[ Prob.[ 202, 105, 245 ], Prob.[ 108, 106, 216 ], Prob.[ 18, 90, 144 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ] ], [3] Prob.[ Prob.[ 33, 172, 219 ], Prob.[ 64, 149, 206 ], Prob.[ 14, 117, 177 ], Prob.[ 5, 90, 141 ], Prob.[ 2, 61, 95 ], Prob.[ 1, 37, 57 ] ], [3] Prob.[ Prob.[ 33, 179, 220 ], Prob.[ 11, 140, 198 ], Prob.[ 1, 89, 148 ], Prob.[ 1, 60, 104 ], Prob.[ 1, 33, 57 ], Prob.[ 1, 12, 21 ] ], [3] Prob.[ Prob.[ 30, 181, 221 ], Prob.[ 8, 141, 198 ], Prob.[ 1, 87, 145 ], Prob.[ 1, 58, 100 ], Prob.[ 1, 31, 55 ], Prob.[ 1, 12, 20 ] ], [3] Prob.[ Prob.[ 32, 186, 224 ], Prob.[ 7, 142, 198 ], Prob.[ 1, 86, 143 ], Prob.[ 1, 58, 100 ], Prob.[ 1, 31, 55 ], Prob.[ 1, 12, 22 ] ], [3] Prob.[ Prob.[ 57, 192, 227 ], Prob.[ 20, 143, 204 ], Prob.[ 3, 96, 154 ], Prob.[ 1, 68, 112 ], Prob.[ 1, 42, 69 ], Prob.[ 1, 19, 32 ] ] ] ],
            [6] [6] [3] Prob.[ [6] [3] Prob.[ [3] Prob.[ Prob.[ 212, 35, 215 ], Prob.[ 113, 47, 169 ], Prob.[ 29, 48, 105 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ] ], [3] Prob.[ Prob.[ 74, 129, 203 ], Prob.[ 106, 120, 203 ], Prob.[ 49, 107, 178 ], Prob.[ 19, 84, 144 ], Prob.[ 4, 50, 84 ], Prob.[ 1, 15, 25 ] ], [3] Prob.[ Prob.[ 71, 172, 217 ], Prob.[ 44, 141, 209 ], Prob.[ 15, 102, 173 ], Prob.[ 6, 76, 133 ], Prob.[ 2, 51, 89 ], Prob.[ 1, 24, 42 ] ], [3] Prob.[ Prob.[ 64, 185, 231 ], Prob.[ 31, 148, 216 ], Prob.[ 8, 103, 175 ], Prob.[ 3, 74, 131 ], Prob.[ 1, 46, 81 ], Prob.[ 1, 18, 30 ] ], [3] Prob.[ Prob.[ 65, 196, 235 ], Prob.[ 25, 157, 221 ], Prob.[ 5, 105, 174 ], Prob.[ 1, 67, 120 ], Prob.[ 1, 38, 69 ], Prob.[ 1, 15, 30 ] ], [3] Prob.[ Prob.[ 65, 204, 238 ], Prob.[ 30, 156, 224 ], Prob.[ 7, 107, 177 ], Prob.[ 2, 70, 124 ], Prob.[ 1, 42, 73 ], Prob.[ 1, 18, 34 ] ] ], [6] [3] Prob.[ [3] Prob.[ Prob.[ 225, 86, 251 ], Prob.[ 144, 104, 235 ], Prob.[ 42, 99, 181 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ] ], [3] Prob.[ Prob.[ 85, 175, 239 ], Prob.[ 112, 165, 229 ], Prob.[ 29, 136, 200 ], Prob.[ 12, 103, 162 ], Prob.[ 6, 77, 123 ], Prob.[ 2, 53, 84 ] ], [3] Prob.[ Prob.[ 75, 183, 239 ], Prob.[ 30, 155, 221 ], Prob.[ 3, 106, 171 ], Prob.[ 1, 74, 128 ], Prob.[ 1, 44, 76 ], Prob.[ 1, 17, 28 ] ], [3] Prob.[ Prob.[ 73, 185, 240 ], Prob.[ 27, 159, 222 ], Prob.[ 2, 107, 172 ], Prob.[ 1, 75, 127 ], Prob.[ 1, 42, 73 ], Prob.[ 1, 17, 29 ] ], [3] Prob.[ Prob.[ 62, 190, 238 ], Prob.[ 21, 159, 222 ], Prob.[ 2, 107, 172 ], Prob.[ 1, 72, 122 ], Prob.[ 1, 40, 71 ], Prob.[ 1, 18, 32 ] ], [3] Prob.[ Prob.[ 61, 199, 240 ], Prob.[ 27, 161, 226 ], Prob.[ 4, 113, 180 ], Prob.[ 1, 76, 129 ], Prob.[ 1, 46, 80 ], Prob.[ 1, 23, 41 ] ] ] ]
        ];
    DEFAULT_COEF_PROBS_16X16 =
        Vp9_Coeff_Probs_Model.[
            [6] [6] [3] Prob.[ [6] [3] Prob.[ [3] Prob.[ Prob.[ 7, 27, 153 ], Prob.[ 5, 30, 95 ], Prob.[ 1, 16, 30 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ] ], [3] Prob.[ Prob.[ 50, 75, 127 ], Prob.[ 57, 75, 124 ], Prob.[ 27, 67, 108 ], Prob.[ 10, 54, 86 ], Prob.[ 1, 33, 52 ], Prob.[ 1, 12, 18 ] ], [3] Prob.[ Prob.[ 43, 125, 151 ], Prob.[ 26, 108, 148 ], Prob.[ 7, 83, 122 ], Prob.[ 2, 59, 89 ], Prob.[ 1, 38, 60 ], Prob.[ 1, 17, 27 ] ], [3] Prob.[ Prob.[ 23, 144, 163 ], Prob.[ 13, 112, 154 ], Prob.[ 2, 75, 117 ], Prob.[ 1, 50, 81 ], Prob.[ 1, 31, 51 ], Prob.[ 1, 14, 23 ] ], [3] Prob.[ Prob.[ 18, 162, 185 ], Prob.[ 6, 123, 171 ], Prob.[ 1, 78, 125 ], Prob.[ 1, 51, 86 ], Prob.[ 1, 31, 54 ], Prob.[ 1, 14, 23 ] ], [3] Prob.[ Prob.[ 15, 199, 227 ], Prob.[ 3, 150, 204 ], Prob.[ 1, 91, 146 ], Prob.[ 1, 55, 95 ], Prob.[ 1, 30, 53 ], Prob.[ 1, 11, 20 ] ] ], [6] [3] Prob.[ [3] Prob.[ Prob.[ 19, 55, 240 ], Prob.[ 19, 59, 196 ], Prob.[ 3, 52, 105 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ] ], [3] Prob.[ Prob.[ 41, 166, 207 ], Prob.[ 104, 153, 199 ], Prob.[ 31, 123, 181 ], Prob.[ 14, 101, 152 ], Prob.[ 5, 72, 106 ], Prob.[ 1, 36, 52 ] ], [3] Prob.[ Prob.[ 35, 176, 211 ], Prob.[ 12, 131, 190 ], Prob.[ 2, 88, 144 ], Prob.[ 1, 60, 101 ], Prob.[ 1, 36, 60 ], Prob.[ 1, 16, 28 ] ], [3] Prob.[ Prob.[ 28, 183, 213 ], Prob.[ 8, 134, 191 ], Prob.[ 1, 86, 142 ], Prob.[ 1, 56, 96 ], Prob.[ 1, 30, 53 ], Prob.[ 1, 12, 20 ] ], [3] Prob.[ Prob.[ 20, 190, 215 ], Prob.[ 4, 135, 192 ], Prob.[ 1, 84, 139 ], Prob.[ 1, 53, 91 ], Prob.[ 1, 28, 49 ], Prob.[ 1, 11, 20 ] ], [3] Prob.[ Prob.[ 13, 196, 216 ], Prob.[ 2, 137, 192 ], Prob.[ 1, 86, 143 ], Prob.[ 1, 57, 99 ], Prob.[ 1, 32, 56 ], Prob.[ 1, 13, 24 ] ] ] ],
            [6] [6] [3] Prob.[ [6] [3] Prob.[ [3] Prob.[ Prob.[ 211, 29, 217 ], Prob.[ 96, 47, 156 ], Prob.[ 22, 43, 87 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ] ], [3] Prob.[ Prob.[ 78, 120, 193 ], Prob.[ 111, 116, 186 ], Prob.[ 46, 102, 164 ], Prob.[ 15, 80, 128 ], Prob.[ 2, 49, 76 ], Prob.[ 1, 18, 28 ] ], [3] Prob.[ Prob.[ 71, 161, 203 ], Prob.[ 42, 132, 192 ], Prob.[ 10, 98, 150 ], Prob.[ 3, 69, 109 ], Prob.[ 1, 44, 70 ], Prob.[ 1, 18, 29 ] ], [3] Prob.[ Prob.[ 57, 186, 211 ], Prob.[ 30, 140, 196 ], Prob.[ 4, 93, 146 ], Prob.[ 1, 62, 102 ], Prob.[ 1, 38, 65 ], Prob.[ 1, 16, 27 ] ], [3] Prob.[ Prob.[ 47, 199, 217 ], Prob.[ 14, 145, 196 ], Prob.[ 1, 88, 142 ], Prob.[ 1, 57, 98 ], Prob.[ 1, 36, 62 ], Prob.[ 1, 15, 26 ] ], [3] Prob.[ Prob.[ 26, 219, 229 ], Prob.[ 5, 155, 207 ], Prob.[ 1, 94, 151 ], Prob.[ 1, 60, 104 ], Prob.[ 1, 36, 62 ], Prob.[ 1, 16, 28 ] ] ], [6] [3] Prob.[ [3] Prob.[ Prob.[ 233, 29, 248 ], Prob.[ 146, 47, 220 ], Prob.[ 43, 52, 140 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ] ], [3] Prob.[ Prob.[ 100, 163, 232 ], Prob.[ 179, 161, 222 ], Prob.[ 63, 142, 204 ], Prob.[ 37, 113, 174 ], Prob.[ 26, 89, 137 ], Prob.[ 18, 68, 97 ] ], [3] Prob.[ Prob.[ 85, 181, 230 ], Prob.[ 32, 146, 209 ], Prob.[ 7, 100, 164 ], Prob.[ 3, 71, 121 ], Prob.[ 1, 45, 77 ], Prob.[ 1, 18, 30 ] ], [3] Prob.[ Prob.[ 65, 187, 230 ], Prob.[ 20, 148, 207 ], Prob.[ 2, 97, 159 ], Prob.[ 1, 68, 116 ], Prob.[ 1, 40, 70 ], Prob.[ 1, 14, 29 ] ], [3] Prob.[ Prob.[ 40, 194, 227 ], Prob.[ 8, 147, 204 ], Prob.[ 1, 94, 155 ], Prob.[ 1, 65, 112 ], Prob.[ 1, 39, 66 ], Prob.[ 1, 14, 26 ] ], [3] Prob.[ Prob.[ 16, 208, 228 ], Prob.[ 3, 151, 207 ], Prob.[ 1, 98, 160 ], Prob.[ 1, 67, 117 ], Prob.[ 1, 41, 74 ], Prob.[ 1, 17, 31 ] ] ] ]
        ];
    DEFAULT_COEF_PROBS_32X32 =
        Vp9_Coeff_Probs_Model.[
            [6] [6] [3] Prob.[ [6] [3] Prob.[ [3] Prob.[ Prob.[ 17, 38, 140 ], Prob.[ 7, 34, 80 ], Prob.[ 1, 17, 29 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ] ], [3] Prob.[ Prob.[ 37, 75, 128 ], Prob.[ 41, 76, 128 ], Prob.[ 26, 66, 116 ], Prob.[ 12, 52, 94 ], Prob.[ 2, 32, 55 ], Prob.[ 1, 10, 16 ] ], [3] Prob.[ Prob.[ 50, 127, 154 ], Prob.[ 37, 109, 152 ], Prob.[ 16, 82, 121 ], Prob.[ 5, 59, 85 ], Prob.[ 1, 35, 54 ], Prob.[ 1, 13, 20 ] ], [3] Prob.[ Prob.[ 40, 142, 167 ], Prob.[ 17, 110, 157 ], Prob.[ 2, 71, 112 ], Prob.[ 1, 44, 72 ], Prob.[ 1, 27, 45 ], Prob.[ 1, 11, 17 ] ], [3] Prob.[ Prob.[ 30, 175, 188 ], Prob.[ 9, 124, 169 ], Prob.[ 1, 74, 116 ], Prob.[ 1, 48, 78 ], Prob.[ 1, 30, 49 ], Prob.[ 1, 11, 18 ] ], [3] Prob.[ Prob.[ 10, 222, 223 ], Prob.[ 2, 150, 194 ], Prob.[ 1, 83, 128 ], Prob.[ 1, 48, 79 ], Prob.[ 1, 27, 45 ], Prob.[ 1, 11, 17 ] ] ], [6] [3] Prob.[ [3] Prob.[ Prob.[ 36, 41, 235 ], Prob.[ 29, 36, 193 ], Prob.[ 10, 27, 111 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ] ], [3] Prob.[ Prob.[ 85, 165, 222 ], Prob.[ 177, 162, 215 ], Prob.[ 110, 135, 195 ], Prob.[ 57, 113, 168 ], Prob.[ 23, 83, 120 ], Prob.[ 10, 49, 61 ] ], [3] Prob.[ Prob.[ 85, 190, 223 ], Prob.[ 36, 139, 200 ], Prob.[ 5, 90, 146 ], Prob.[ 1, 60, 103 ], Prob.[ 1, 38, 65 ], Prob.[ 1, 18, 30 ] ], [3] Prob.[ Prob.[ 72, 202, 223 ], Prob.[ 23, 141, 199 ], Prob.[ 2, 86, 140 ], Prob.[ 1, 56, 97 ], Prob.[ 1, 36, 61 ], Prob.[ 1, 16, 27 ] ], [3] Prob.[ Prob.[ 55, 218, 225 ], Prob.[ 13, 145, 200 ], Prob.[ 1, 86, 141 ], Prob.[ 1, 57, 99 ], Prob.[ 1, 35, 61 ], Prob.[ 1, 13, 22 ] ], [3] Prob.[ Prob.[ 15, 235, 212 ], Prob.[ 1, 132, 184 ], Prob.[ 1, 84, 139 ], Prob.[ 1, 57, 97 ], Prob.[ 1, 34, 56 ], Prob.[ 1, 14, 23 ] ] ] ],
            [6] [6] [3] Prob.[ [6] [3] Prob.[ [3] Prob.[ Prob.[ 181, 21, 201 ], Prob.[ 61, 37, 123 ], Prob.[ 10, 38, 71 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ] ], [3] Prob.[ Prob.[ 47, 106, 172 ], Prob.[ 95, 104, 173 ], Prob.[ 42, 93, 159 ], Prob.[ 18, 77, 131 ], Prob.[ 4, 50, 81 ], Prob.[ 1, 17, 23 ] ], [3] Prob.[ Prob.[ 62, 147, 199 ], Prob.[ 44, 130, 189 ], Prob.[ 28, 102, 154 ], Prob.[ 18, 75, 115 ], Prob.[ 2, 44, 65 ], Prob.[ 1, 12, 19 ] ], [3] Prob.[ Prob.[ 55, 153, 210 ], Prob.[ 24, 130, 194 ], Prob.[ 3, 93, 146 ], Prob.[ 1, 61, 97 ], Prob.[ 1, 31, 50 ], Prob.[ 1, 10, 16 ] ], [3] Prob.[ Prob.[ 49, 186, 223 ], Prob.[ 17, 148, 204 ], Prob.[ 1, 96, 142 ], Prob.[ 1, 53, 83 ], Prob.[ 1, 26, 44 ], Prob.[ 1, 11, 17 ] ], [3] Prob.[ Prob.[ 13, 217, 212 ], Prob.[ 2, 136, 180 ], Prob.[ 1, 78, 124 ], Prob.[ 1, 50, 83 ], Prob.[ 1, 29, 49 ], Prob.[ 1, 14, 23 ] ] ], [6] [3] Prob.[ [3] Prob.[ Prob.[ 197, 13, 247 ], Prob.[ 82, 17, 222 ], Prob.[ 25, 17, 162 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ], Prob.[ cast,no_check(Prob) 0, cast,no_check(Prob) 0, cast,no_check(Prob) 0 ] ], [3] Prob.[ Prob.[ 126, 186, 247 ], Prob.[ 234, 191, 243 ], Prob.[ 176, 177, 234 ], Prob.[ 104, 158, 220 ], Prob.[ 66, 128, 186 ], Prob.[ 55, 90, 137 ] ], [3] Prob.[ Prob.[ 111, 197, 242 ], Prob.[ 46, 158, 219 ], Prob.[ 9, 104, 171 ], Prob.[ 2, 65, 125 ], Prob.[ 1, 44, 80 ], Prob.[ 1, 17, 91 ] ], [3] Prob.[ Prob.[ 104, 208, 245 ], Prob.[ 39, 168, 224 ], Prob.[ 3, 109, 162 ], Prob.[ 1, 79, 124 ], Prob.[ 1, 50, 102 ], Prob.[ 1, 43, 102 ] ], [3] Prob.[ Prob.[ 84, 220, 246 ], Prob.[ 31, 177, 231 ], Prob.[ 2, 115, 180 ], Prob.[ 1, 79, 134 ], Prob.[ 1, 55, 77 ], Prob.[ 1, 60, 79 ] ], [3] Prob.[ Prob.[ 43, 243, 240 ], Prob.[ 8, 180, 217 ], Prob.[ 1, 115, 166 ], Prob.[ 1, 84, 121 ], Prob.[ 1, 51, 67 ], Prob.[ 1, 16, 6 ] ] ] ]
        ];
    atomic_store(*globals_initialization_state_for_vp9_entropy, 2);
}

