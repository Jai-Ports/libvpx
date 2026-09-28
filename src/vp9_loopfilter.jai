// Generated directly from C by cpp_transpiler.
COUNT_TO_UPDATE_FACTOR_in_vp9_loopfilter: [21] s32;

SIZE_MASK: [13] u64;

LEFT_64X64_TXFORM_MASK: [4] u64;

ABOVE_64X64_TXFORM_MASK: [4] u64;

LEFT_PREDICTION_MASK: [13] u64;

ABOVE_PREDICTION_MASK: [13] u64;

MODE_LF_LUT: [14] s32;

SIZE_MASK_UV: [13] u16;

LEFT_64X64_TXFORM_MASK_UV: [4] u16;

ABOVE_64X64_TXFORM_MASK_UV: [4] u16;

LEFT_PREDICTION_MASK_UV: [13] u16;

ABOVE_PREDICTION_MASK_UV: [13] u16;

ABOVE_BORDER_UV: u16;

LEFT_BORDER_UV: u16;

ABOVE_BORDER: u64;

LEFT_BORDER: u64;

FIRST_BLOCK_IN_16X16: [8] [8] u8;

SUB_PEL_FILTERS_12_in_vp9_loopfilter: [16] Interp_Kernel12 #align 256;

clip_pixel_in_vp9_loopfilter :: (val: s32) -> u8 {
    return cast,no_check(u8) ((ifx val > 255 then 255 else (ifx val < 0 then 0 else val)));
}

clamp_in_vp9_loopfilter :: (value: s32, low: s32, high: s32) -> s32 {
    return ifx value < low then low else (ifx value > high then high else value);
}

fclamp_in_vp9_loopfilter :: (value: float64, low: float64, high: float64) -> float64 {
    return ifx c_transpiler_float_less(value, low) then low else (ifx c_transpiler_float_greater(value, high) then high else value);
}

lclamp_in_vp9_loopfilter :: (value: s64, low: s64, high: s64) -> s64 {
    return ifx value < low then low else (ifx value > high then high else value);
}

clip_pixel_highbd_in_vp9_loopfilter :: (val: s32, bd: s32) -> u16 {
    if bd == {
        case 8; #through;
        case;
            return cast,no_check(u16) clamp_in_vp9_loopfilter(val, 0, 255);
        case 10;
            return cast,no_check(u16) clamp_in_vp9_loopfilter(val, 0, 1023);
        case 12;
            return cast,no_check(u16) clamp_in_vp9_loopfilter(val, 0, 4095);
    }
    return unreachable_value(u16);
}

saturate_cast_double_to_int_in_vp9_loopfilter :: (d: float64) -> s32 {
    if c_transpiler_float_greater(d, 2147483647.0) {
        return 2147483647;
    }
    return cast,no_check(s32) d;
}

get_filter_taps_in_vp9_loopfilter :: (FILTER: *s16) -> s32 {
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

get_prob_in_vp9_loopfilter :: (num: u32, den: u32) -> Prob {
    {
        P := cast,no_check(s32) ((((cast,no_check(u64) num) * 256) + cast(u64) (den >> 1)) / cast(u64) den);

        CLIPPED_PROB := P | ((255 - P) >> 23) | cast(s32) (P == 0);
        return cast,no_check(Prob) CLIPPED_PROB;
    }
}

get_binary_prob_in_vp9_loopfilter :: (n0: u32, n1: u32) -> Prob {
    DEN := n0 + n1;
    if DEN == 0 {
        return 128;
    }
    return get_prob_in_vp9_loopfilter(n0, DEN);
}

weighted_prob_in_vp9_loopfilter :: (prob1: s32, prob2: s32, factor: s32) -> Prob {
    return cast,no_check(Prob) ((prob1 * (256 - factor) + prob2 * factor + (cast(s32) 1) << (((8 - 1)) & 31)) >> 8);
}

merge_probs_in_vp9_loopfilter :: (pre_prob: Prob, ct: *u32, count_sat: u32, max_update_factor: u32) -> Prob {
    PROB := get_binary_prob_in_vp9_loopfilter(ct[0], ct[1]);
    COUNT := (ifx ct[0] + ct[1] < count_sat then ct[0] + ct[1] else count_sat);
    FACTOR := max_update_factor * COUNT / count_sat;
    return weighted_prob_in_vp9_loopfilter(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
}

mode_mv_merge_probs_in_vp9_loopfilter :: (pre_prob: Prob, ct: *u32) -> Prob {
    DEN := ct[0] + ct[1];
    if DEN == 0 {
        return pre_prob;
    } else {
        COUNT := (ifx DEN < 20 then DEN else 20);
        FACTOR := cast,no_check(u32) COUNT_TO_UPDATE_FACTOR_in_vp9_loopfilter[COUNT];
        PROB := get_prob_in_vp9_loopfilter(ct[0], DEN);
        return weighted_prob_in_vp9_loopfilter(cast,no_check(s32) pre_prob, cast,no_check(s32) PROB, cast,no_check(s32) FACTOR);
    }
}

get_lsb_in_vp9_loopfilter :: (n: u32) -> s32 {
    return c_transpiler_ctz32(n);
}

get_msb_in_vp9_loopfilter :: (n: u32) -> s32 {
    return 31 ^ c_transpiler_clz32(n);
}

get_unsigned_bits_in_vp9_loopfilter :: (num_values: u32) -> s32 {
    return ifx num_values > 0 then get_msb_in_vp9_loopfilter(num_values) + 1 else 0;
}

get_band_translate_in_vp9_loopfilter :: (tx_size: TX_SIZE) -> *u8 {
    return ifx tx_size == cast(TX_SIZE) 0 then VP9_COEFBAND_TRANS_4X4.data else VP9_COEFBAND_TRANS_8X8PLUS.data;
}

combine_entropy_contexts_in_vp9_loopfilter :: (a: ENTROPY_CONTEXT, b: ENTROPY_CONTEXT) -> s32 {
    return (cast(s32) (a != 0)) + cast(s32) (b != 0);
}

get_entropy_context_in_vp9_loopfilter :: (tx_size: TX_SIZE, a: *ENTROPY_CONTEXT, l: *ENTROPY_CONTEXT) -> s32 {
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

    return combine_entropy_contexts_in_vp9_loopfilter(above_ec, left_ec);
}

is_zero_mv_in_vp9_loopfilter :: (mv: *MV) -> s32 {
    if (cast(*u32) mv).* == 0 {
        return 1;
    }
    return 0;
}

is_equal_mv_in_vp9_loopfilter :: (a: *MV, b: *MV) -> s32 {
    if (cast(*u32) a).* == (cast(*u32) b).* {
        return 1;
    }
    return 0;
}

clamp_mv_in_vp9_loopfilter :: (mv: *MV, min_col: s32, max_col: s32, min_row: s32, max_row: s32) {
    mv.col = cast,no_check(s16) clamp_in_vp9_loopfilter(cast,no_check(s32) mv.col, min_col, max_col);
    mv.row = cast,no_check(s16) clamp_in_vp9_loopfilter(cast,no_check(s32) mv.row, min_row, max_row);
}

use_mv_hp_in_vp9_loopfilter :: (ref: *MV) -> s32 {
    K_MV_REF_THRESH: s32 = 64;
    if absolute_value(cast,no_check(s32) ref.row) < K_MV_REF_THRESH &&
        absolute_value(cast,no_check(s32) ref.col) < K_MV_REF_THRESH {
        return 1;
    }
    return 0;
}

mv_joint_vertical_in_vp9_loopfilter :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HZVNZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

mv_joint_horizontal_in_vp9_loopfilter :: (type: MV_JOINT_TYPE) -> s32 {
    if type == cast,no_check(u32) MV_JOINT_HNZVZ || type == cast,no_check(u32) MV_JOINT_HNZVNZ {
        return 1;
    }
    return 0;
}

vp9_get_mv_joint_in_vp9_loopfilter :: (mv: *MV) -> MV_JOINT_TYPE {
    if mv.row == 0 {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_ZERO) else cast,no_check(s32) (MV_JOINT_HNZVZ)));
    } else {
        return cast,no_check(MV_JOINT_TYPE) ((ifx mv.col == 0 then cast,no_check(s32) (MV_JOINT_HZVNZ) else cast,no_check(s32) (MV_JOINT_HNZVNZ)));
    }
}

vp9_is_valid_scale_in_vp9_loopfilter :: (sf: *Scale_Factors) -> s32 {
    if sf.x_scale_fp != -1 && sf.y_scale_fp != -1 {
        return 1;
    }
    return 0;
}

vp9_is_scaled_in_vp9_loopfilter :: (sf: *Scale_Factors) -> s32 {
    if vp9_is_valid_scale_in_vp9_loopfilter(sf) != 0 &&
        (sf.x_scale_fp != (cast(s32) 1) << 14 || sf.y_scale_fp != (cast(s32) 1) << 14) {
        return 1;
    }
    return 0;
}

valid_ref_frame_size_in_vp9_loopfilter :: (ref_width: s32, ref_height: s32, this_width: s32, this_height: s32) -> s32 {
    if 2 * this_width >= ref_width &&
        2 * this_height >= ref_height &&
        this_width <= 16 * ref_width &&
        this_height <= 16 * ref_height {
        return 1;
    }
    return 0;
}

segfeature_active_in_vp9_loopfilter :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    if seg.enabled != 0 && seg.feature_mask[segment_id] & cast,no_check(u32) ((cast(s32) 1) << ((feature_id) & 31)) != 0 {
        return 1;
    }
    return 0;
}

get_segdata_in_vp9_loopfilter :: (seg: *Segmentation, segment_id: s32, feature_id: SEG_LVL_FEATURES) -> s32 {
    return cast,no_check(s32) seg.feature_data[segment_id][feature_id];
}

is_inter_mode_in_vp9_loopfilter :: (mode: PREDICTION_MODE) -> s32 {
    if mode >= 10 && mode <= 13 {
        return 1;
    }
    return 0;
}

mv_ref_frame_to_inter_ref_idx_in_vp9_loopfilter :: (mv_ref_frame: MV_REFERENCE_FRAME) -> s32 {
    return (cast(s32) mv_ref_frame) - 1;
}

get_y_mode_in_vp9_loopfilter :: (mi: *MODE_INFO, block: s32) -> PREDICTION_MODE {
    return cast,no_check(PREDICTION_MODE) ((ifx mi.sb_type < 3 then cast,no_check(s32) mi.bmi[block].as_mode else cast,no_check(s32) mi.mode));
}

is_inter_block_in_vp9_loopfilter :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[0] > 0 {
        return 1;
    }
    return 0;
}

has_second_ref_in_vp9_loopfilter :: (mi: *MODE_INFO) -> s32 {
    if mi.ref_frame[1] > 0 {
        return 1;
    }
    return 0;
}

get_plane_type_in_vp9_loopfilter :: (plane: s32) -> PLANE_TYPE {
    return cast,no_check(PLANE_TYPE) (plane > 0);
}

get_subsize_in_vp9_loopfilter :: (bsize: BLOCK_SIZE, partition: PARTITION_TYPE) -> BLOCK_SIZE {
    return SUBSIZE_LOOKUP[partition][bsize];
}

get_tx_type_in_vp9_loopfilter :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_loopfilter(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[MI.mode];
}

get_tx_type_4x4_in_vp9_loopfilter :: (plane_type: PLANE_TYPE, xd: *MACROBLOCKD, ib: s32) -> TX_TYPE {
    MI := xd.mi[0];

    if plane_type != cast,no_check(u32) PLANE_TYPE_Y || xd.lossless != 0 || is_inter_block_in_vp9_loopfilter(MI) != 0 {
        return cast,no_check(TX_TYPE) DCT_DCT;
    }

    return INTRA_MODE_TO_TX_TYPE_LOOKUP[get_y_mode_in_vp9_loopfilter(MI, ib)];
}

get_uv_tx_size_in_vp9_loopfilter :: (mi: *MODE_INFO, pd: *Macroblockd_Plane) -> TX_SIZE {
    return UV_TXSIZE_LOOKUP[mi.sb_type][mi.tx_size][pd.subsampling_x][pd.subsampling_y];
}

get_plane_block_size_in_vp9_loopfilter :: (bsize: BLOCK_SIZE, pd: *Macroblockd_Plane) -> BLOCK_SIZE {
    return SS_SIZE_LOOKUP[bsize][pd.subsampling_x][pd.subsampling_y];
}

reset_skip_context_in_vp9_loopfilter :: (xd: *MACROBLOCKD, bsize: BLOCK_SIZE) {
    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PLANE_BSIZE := get_plane_block_size_in_vp9_loopfilter(bsize, PD);
        fill_memory(PD.above_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_WIDE_LOOKUP[PLANE_BSIZE]);
        fill_memory(PD.left_context, 0, cast,no_check(u64) NUM_4X4_BLOCKS_HIGH_LOOKUP[PLANE_BSIZE]);
    }
}

get_y_mode_probs_in_vp9_loopfilter :: (mi: *MODE_INFO, above_mi: *MODE_INFO, left_mi: *MODE_INFO, block: s32) -> *Prob {
    ABOVE := vp9_above_block_mode(mi, above_mi, block);
    LEFT := vp9_left_block_mode(mi, left_mi, block);
    return VP9_KF_Y_MODE_PROB[ABOVE][LEFT].data;
}

vp9_setup_mask :: (
    CM: *VP9_COMMON,
    MI_ROW: s32,
    MI_COL: s32,
    mi8x8: **MODE_INFO,
    MODE_INFO_STRIDE: s32,
    lfm: *LOOP_FILTER_MASK
) {
    idx_32: s32 = ---;
    idx_16: s32 = ---;
    idx_8: s32 = ---;
    LFI_N: *Loop_Filter_Info_N_in_vp9_alloccommon = ---;
    mip: **MODE_INFO = ---;
    mip2: **MODE_INFO = ---;
    OFFSET_32: [4] s32 = ---;
    OFFSET_16: [4] s32 = ---;
    OFFSET: [4] s32 = ---;
    SHIFT_32_Y: [4] s32 = ---;
    SHIFT_16_Y: [4] s32 = ---;
    SHIFT_8_Y: [4] s32 = ---;
    SHIFT_32_UV: [4] s32 = ---;
    SHIFT_16_UV: [4] s32 = ---;
    MAX_ROWS: s32 = ---;
    MAX_COLS: s32 = ---;
    SHIFT_Y_32: s32 = ---;
    SHIFT_UV_32: s32 = ---;
    MI_32_COL_OFFSET: s32 = ---;
    MI_32_ROW_OFFSET: s32 = ---;
    SHIFT_Y_16: s32 = ---;
    SHIFT_UV_16: s32 = ---;
    MI_16_COL_OFFSET: s32 = ---;
    MI_16_ROW_OFFSET: s32 = ---;
    SHIFT_Y_8_0: s32 = ---;
    SHIFT_Y_8: s32 = ---;
    MI_8_COL_OFFSET: s32 = ---;
    MI_8_ROW_OFFSET: s32 = ---;
    code_block_to_execute: s64 = 105;
    while c_transpiler_dispatch := true {
        if code_block_to_execute < 0 break;
        if code_block_to_execute == {
            case 13; {
                if idx_32 < 4 {
                    code_block_to_execute = 73;
                    continue c_transpiler_dispatch;
                } else {
                    break c_transpiler_dispatch;
                }
            }
            case 14; {
                mip += OFFSET_32[idx_32];
                idx_32 += 1;
                code_block_to_execute = 13;
                continue c_transpiler_dispatch;
            }
            case 16; {
                if idx_16 < 4 {
                    code_block_to_execute = 51;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 14;
                    continue c_transpiler_dispatch;
                }
            }
            case 17; {
                mip += OFFSET_16[idx_16];
                idx_16 += 1;
                code_block_to_execute = 16;
                continue c_transpiler_dispatch;
            }
            case 19; {
                if idx_8 < 4 {
                    code_block_to_execute = 26;
                    continue c_transpiler_dispatch;
                } else {
                    code_block_to_execute = 17;
                    continue c_transpiler_dispatch;
                }
            }
            case 20; {
                mip += OFFSET[idx_8];
                idx_8 += 1;
                code_block_to_execute = 19;
                continue c_transpiler_dispatch;
            }
            case 26; {
                SHIFT_Y_8 = SHIFT_Y_16 + SHIFT_8_Y[idx_8];
                MI_8_COL_OFFSET = MI_16_COL_OFFSET + idx_8 & 1;
                MI_8_ROW_OFFSET = MI_16_ROW_OFFSET + idx_8 >> 1;
                if MI_8_COL_OFFSET >= MAX_COLS || MI_8_ROW_OFFSET >= MAX_ROWS {
                    code_block_to_execute = 20;
                    continue c_transpiler_dispatch;
                } else {
                    build_y_mask(LFI_N, mip[0], SHIFT_Y_8, lfm);
                    code_block_to_execute = 20;
                    continue c_transpiler_dispatch;
                }
            }
            case 30; {
                SHIFT_Y_8_0 = SHIFT_Y_16 + SHIFT_8_Y[0];
                build_masks(LFI_N, mip[0], SHIFT_Y_8_0, SHIFT_UV_16, lfm);
                mip += OFFSET[0];
                idx_8 = 1;
                code_block_to_execute = 19;
                continue c_transpiler_dispatch;
            }
            case 51; {
                SHIFT_Y_16 = SHIFT_Y_32 + SHIFT_16_Y[idx_16];
                SHIFT_UV_16 = SHIFT_UV_32 + SHIFT_16_UV[idx_16];
                MI_16_COL_OFFSET = MI_32_COL_OFFSET + idx_16 & 1 << 1;
                MI_16_ROW_OFFSET = MI_32_ROW_OFFSET + idx_16 >> 1 << 1;
                if MI_16_COL_OFFSET >= MAX_COLS || MI_16_ROW_OFFSET >= MAX_ROWS {
                    code_block_to_execute = 17;
                    continue c_transpiler_dispatch;
                } else {
                    c_transpiler_switch_value_45 := cast,no_check(s32) mip[0].sb_type;
                    if c_transpiler_switch_value_45 == {
                        case cast(s32) 6; {
                            build_masks(LFI_N, mip[0], SHIFT_Y_16, SHIFT_UV_16, lfm);
                            code_block_to_execute = 17;
                            continue c_transpiler_dispatch;
                        }
                        case cast(s32) 5; {
                            build_masks(LFI_N, mip[0], SHIFT_Y_16, SHIFT_UV_16, lfm);
                            if MI_16_ROW_OFFSET + 1 >= MAX_ROWS {
                                code_block_to_execute = 17;
                                continue c_transpiler_dispatch;
                            } else {
                                mip2 = mip + MODE_INFO_STRIDE;
                                build_y_mask(LFI_N, mip2[0], SHIFT_Y_16 + 8, lfm);
                                code_block_to_execute = 17;
                                continue c_transpiler_dispatch;
                            }
                        }
                        case cast(s32) 4; {
                            build_masks(LFI_N, mip[0], SHIFT_Y_16, SHIFT_UV_16, lfm);
                            if MI_16_COL_OFFSET + 1 >= MAX_COLS {
                                code_block_to_execute = 17;
                                continue c_transpiler_dispatch;
                            } else {
                                mip2 = mip + 1;
                                build_y_mask(LFI_N, mip2[0], SHIFT_Y_16 + 1, lfm);
                                code_block_to_execute = 17;
                                continue c_transpiler_dispatch;
                            }
                        }
                        case; {
                            code_block_to_execute = 30;
                            continue c_transpiler_dispatch;
                        }
                    }
                }
            }
            case 52; {
                idx_16 = 0;
                code_block_to_execute = 16;
                continue c_transpiler_dispatch;
            }
            case 73; {
                SHIFT_Y_32 = SHIFT_32_Y[idx_32];
                SHIFT_UV_32 = SHIFT_32_UV[idx_32];
                MI_32_COL_OFFSET = idx_32 & 1 << 2;
                MI_32_ROW_OFFSET = idx_32 >> 1 << 2;
                if MI_32_COL_OFFSET >= MAX_COLS || MI_32_ROW_OFFSET >= MAX_ROWS {
                    code_block_to_execute = 14;
                    continue c_transpiler_dispatch;
                } else {
                    c_transpiler_switch_value_67 := cast,no_check(s32) mip[0].sb_type;
                    if c_transpiler_switch_value_67 == {
                        case cast(s32) 9; {
                            build_masks(LFI_N, mip[0], SHIFT_Y_32, SHIFT_UV_32, lfm);
                            code_block_to_execute = 14;
                            continue c_transpiler_dispatch;
                        }
                        case cast(s32) 8; {
                            build_masks(LFI_N, mip[0], SHIFT_Y_32, SHIFT_UV_32, lfm);
                            if MI_32_ROW_OFFSET + 2 >= MAX_ROWS {
                                code_block_to_execute = 14;
                                continue c_transpiler_dispatch;
                            } else {
                                mip2 = mip + MODE_INFO_STRIDE * 2;
                                build_masks(LFI_N, mip2[0], SHIFT_Y_32 + 16, SHIFT_UV_32 + 4, lfm);
                                code_block_to_execute = 14;
                                continue c_transpiler_dispatch;
                            }
                        }
                        case cast(s32) 7; {
                            build_masks(LFI_N, mip[0], SHIFT_Y_32, SHIFT_UV_32, lfm);
                            if MI_32_COL_OFFSET + 2 >= MAX_COLS {
                                code_block_to_execute = 14;
                                continue c_transpiler_dispatch;
                            } else {
                                mip2 = mip + 2;
                                build_masks(LFI_N, mip2[0], SHIFT_Y_32 + 2, SHIFT_UV_32 + 1, lfm);
                                code_block_to_execute = 14;
                                continue c_transpiler_dispatch;
                            }
                        }
                        case; {
                            code_block_to_execute = 52;
                            continue c_transpiler_dispatch;
                        }
                    }
                }
            }
            case 74; {
                idx_32 = 0;
                code_block_to_execute = 13;
                continue c_transpiler_dispatch;
            }
            case 105; {
                LFI_N = *CM.lf_info;
                mip = mi8x8;
                mip2 = mi8x8;
                OFFSET_32 = s32.[ 4, MODE_INFO_STRIDE << 2 - 4, 4, -(MODE_INFO_STRIDE << 2) - 4 ];
                OFFSET_16 = s32.[ 2, MODE_INFO_STRIDE << 1 - 2, 2, -(MODE_INFO_STRIDE << 1) - 2 ];
                OFFSET = s32.[ 1, MODE_INFO_STRIDE - 1, 1, -MODE_INFO_STRIDE - 1 ];
                SHIFT_32_Y = s32.[ 0, 4, 32, 36 ];
                SHIFT_16_Y = s32.[ 0, 2, 16, 18 ];
                SHIFT_8_Y = s32.[ 0, 1, 8, 9 ];
                SHIFT_32_UV = s32.[ 0, 2, 8, 10 ];
                SHIFT_16_UV = s32.[ 0, 1, 4, 5 ];
                MAX_ROWS = (ifx MI_ROW + (cast(s32) 1) << (((6 - 3)) & 31) > CM.mi_rows then CM.mi_rows - MI_ROW else (cast(s32) 1) << (((6 - 3)) & 31));
                MAX_COLS = (ifx MI_COL + (cast(s32) 1) << (((6 - 3)) & 31) > CM.mi_cols then CM.mi_cols - MI_COL else (cast(s32) 1) << (((6 - 3)) & 31));
                fill_memory(lfm, 0, size_of(LOOP_FILTER_MASK));
                c_transpiler_switch_value_105 := cast,no_check(s32) mip[0].sb_type;
                if c_transpiler_switch_value_105 == {
                    case cast(s32) 12; {
                        build_masks(LFI_N, mip[0], 0, 0, lfm);
                        break c_transpiler_dispatch;
                    }
                    case cast(s32) 11; {
                        build_masks(LFI_N, mip[0], 0, 0, lfm);
                        mip2 = mip + MODE_INFO_STRIDE * 4;
                        if 4 >= MAX_ROWS {
                            break c_transpiler_dispatch;
                        } else {
                            build_masks(LFI_N, mip2[0], 32, 8, lfm);
                            break c_transpiler_dispatch;
                        }
                    }
                    case cast(s32) 10; {
                        build_masks(LFI_N, mip[0], 0, 0, lfm);
                        mip2 = mip + 4;
                        if 4 >= MAX_COLS {
                            break c_transpiler_dispatch;
                        } else {
                            build_masks(LFI_N, mip2[0], 4, 2, lfm);
                            break c_transpiler_dispatch;
                        }
                    }
                    case; {
                        code_block_to_execute = 74;
                        continue c_transpiler_dispatch;
                    }
                }
            }
        }
        assert(false, tprint("invalid code block to execute %", code_block_to_execute));
        break;
    }
}

build_y_mask :: (LFI_N: *Loop_Filter_Info_N_in_vp9_alloccommon, mi: *MODE_INFO, SHIFT_Y: s32, lfm: *LOOP_FILTER_MASK) {
    BLOCK_SIZE_ := mi.sb_type;
    TX_SIZE_Y := mi.tx_size;
    FILTER_LEVEL := cast,no_check(s32) get_filter_level(LFI_N, mi);
    LEFT_Y := lfm.left_y.data + TX_SIZE_Y;
    ABOVE_Y := lfm.above_y.data + TX_SIZE_Y;
    INT_4X4_Y := *lfm.int_4x4_y;

    if FILTER_LEVEL == 0 {
        return;
    } else {
        W := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[BLOCK_SIZE_];
        H := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[BLOCK_SIZE_];
        index := SHIFT_Y;
        if 0 < H {
            for i: 0..H - 1 {
                fill_memory(lfm.lfl_y.data + index, FILTER_LEVEL, cast,no_check(u64) W);
                index += 8;
            }
        }
    }

    ABOVE_Y.* |= ABOVE_PREDICTION_MASK[BLOCK_SIZE_] << ((SHIFT_Y) & 63);
    LEFT_Y.* |= LEFT_PREDICTION_MASK[BLOCK_SIZE_] << ((SHIFT_Y) & 63);

    if mi.skip != 0 && is_inter_block_in_vp9_loopfilter(mi) != 0 {
        return;
    }

    ABOVE_Y.* |= SIZE_MASK[BLOCK_SIZE_] & ABOVE_64X64_TXFORM_MASK[TX_SIZE_Y] << ((SHIFT_Y) & 63);

    LEFT_Y.* |= SIZE_MASK[BLOCK_SIZE_] & LEFT_64X64_TXFORM_MASK[TX_SIZE_Y] << ((SHIFT_Y) & 63);

    if TX_SIZE_Y == cast(TX_SIZE) 0 {
        INT_4X4_Y.* |= SIZE_MASK[BLOCK_SIZE_] << ((SHIFT_Y) & 63);
    }
}

get_filter_level :: (lfi_n: *Loop_Filter_Info_N_in_vp9_alloccommon, mi: *MODE_INFO) -> u8 {
    return lfi_n.lvl[mi.segment_id][mi.ref_frame[0]][MODE_LF_LUT[mi.mode]];
}

build_masks :: (
    LFI_N: *Loop_Filter_Info_N_in_vp9_alloccommon,
    mi: *MODE_INFO,
    SHIFT_Y: s32,
    SHIFT_UV: s32,
    lfm: *LOOP_FILTER_MASK
) {
    BLOCK_SIZE_ := mi.sb_type;
    TX_SIZE_Y := mi.tx_size;
    TX_SIZE_UV := UV_TXSIZE_LOOKUP[BLOCK_SIZE_][TX_SIZE_Y][1][1];
    FILTER_LEVEL := cast,no_check(s32) get_filter_level(LFI_N, mi);
    LEFT_Y := lfm.left_y.data + TX_SIZE_Y;
    ABOVE_Y := lfm.above_y.data + TX_SIZE_Y;
    INT_4X4_Y := *lfm.int_4x4_y;
    LEFT_UV := lfm.left_uv.data + TX_SIZE_UV;
    ABOVE_UV := lfm.above_uv.data + TX_SIZE_UV;
    INT_4X4_UV := *lfm.int_4x4_uv;

    if FILTER_LEVEL == 0 {
        return;
    } else {
        W := cast,no_check(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[BLOCK_SIZE_];
        H := cast,no_check(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[BLOCK_SIZE_];
        index := SHIFT_Y;
        if 0 < H {
            for i: 0..H - 1 {
                fill_memory(lfm.lfl_y.data + index, FILTER_LEVEL, cast,no_check(u64) W);
                index += 8;
            }
        }
    }

    ABOVE_Y.* |= ABOVE_PREDICTION_MASK[BLOCK_SIZE_] << ((SHIFT_Y) & 63);
    ABOVE_UV.* = cast,no_check(u16) ((cast,no_check(s32) ABOVE_UV.*) | ((cast(s32) ABOVE_PREDICTION_MASK_UV[BLOCK_SIZE_]) << ((SHIFT_UV) & 31)));
    LEFT_Y.* |= LEFT_PREDICTION_MASK[BLOCK_SIZE_] << ((SHIFT_Y) & 63);
    LEFT_UV.* = cast,no_check(u16) ((cast,no_check(s32) LEFT_UV.*) | ((cast(s32) LEFT_PREDICTION_MASK_UV[BLOCK_SIZE_]) << ((SHIFT_UV) & 31)));

    if mi.skip != 0 && is_inter_block_in_vp9_loopfilter(mi) != 0 {
        return;
    }

    ABOVE_Y.* |= SIZE_MASK[BLOCK_SIZE_] & ABOVE_64X64_TXFORM_MASK[TX_SIZE_Y] << ((SHIFT_Y) & 63);
    ABOVE_UV.* = cast,no_check(u16) ((cast,no_check(s32) ABOVE_UV.*) | (((cast(s32) SIZE_MASK_UV[BLOCK_SIZE_]) & cast(s32) ABOVE_64X64_TXFORM_MASK_UV[TX_SIZE_UV]) << ((SHIFT_UV) & 31)));

    LEFT_Y.* |= SIZE_MASK[BLOCK_SIZE_] & LEFT_64X64_TXFORM_MASK[TX_SIZE_Y] << ((SHIFT_Y) & 63);
    LEFT_UV.* = cast,no_check(u16) ((cast,no_check(s32) LEFT_UV.*) | (((cast(s32) SIZE_MASK_UV[BLOCK_SIZE_]) & cast(s32) LEFT_64X64_TXFORM_MASK_UV[TX_SIZE_UV]) << ((SHIFT_UV) & 31)));

    if TX_SIZE_Y == cast(TX_SIZE) 0 {
        INT_4X4_Y.* |= SIZE_MASK[BLOCK_SIZE_] << ((SHIFT_Y) & 63);
    }

    if TX_SIZE_UV == cast(TX_SIZE) 0 {
        INT_4X4_UV.* = cast,no_check(u16) ((cast,no_check(s32) INT_4X4_UV.*) | ((cast(s32) SIZE_MASK_UV[BLOCK_SIZE_]) & 0xffff << ((SHIFT_UV) & 31)));
    }
}

vp9_filter_block_plane_ss00 :: (CM: *VP9_COMMON, PLANE: *Macroblockd_Plane, mi_row: s32, lfm: *LOOP_FILTER_MASK) {
    DST := *PLANE.dst;
    DST0 := DST.buf;

    mask_16x16 := lfm.left_y[2];
    mask_8x8 := lfm.left_y[1];
    mask_4x4 := lfm.left_y[0];
    mask_4x4_int := lfm.int_4x4_y;

    r: s32 = 0;
    while r < (cast(s32) 1) << (((6 - 3)) & 31) && mi_row + r < CM.mi_rows {
        filter_selectively_vert_row2(
            PLANE.subsampling_x,
            DST.buf,
            DST.stride,
            cast,no_check(u32) mask_16x16,
            cast,no_check(u32) mask_8x8,
            cast,no_check(u32) mask_4x4,
            cast,no_check(u32) mask_4x4_int,
            CM.lf_info.lfthr.data,
            lfm.lfl_y.data + r << 3
        );

        DST.buf += 16 * DST.stride;
        c_transpiler_compound_shr(*(mask_16x16), (cast(s32) 16), u64, u64);
        c_transpiler_compound_shr(*(mask_8x8), (cast(s32) 16), u64, u64);
        c_transpiler_compound_shr(*(mask_4x4), (cast(s32) 16), u64, u64);
        c_transpiler_compound_shr(*(mask_4x4_int), (cast(s32) 16), u64, u64);
        r += 2;
    }

    DST.buf = DST0;
    mask_16x16 = lfm.above_y[2];
    mask_8x8 = lfm.above_y[1];
    mask_4x4 = lfm.above_y[0];
    mask_4x4_int = lfm.int_4x4_y;

    r = 0;
    while r < (cast(s32) 1) << (((6 - 3)) & 31) && mi_row + r < CM.mi_rows {
        mask_16x16_r: u32 = ---;
        mask_8x8_r: u32 = ---;
        mask_4x4_r: u32 = ---;

        if mi_row + r == 0 {
            mask_16x16_r = 0;
            mask_8x8_r = 0;
            mask_4x4_r = 0;
        } else {
            mask_16x16_r = cast,no_check(u32) (mask_16x16 & 0xff);
            mask_8x8_r = cast,no_check(u32) (mask_8x8 & 0xff);
            mask_4x4_r = cast,no_check(u32) (mask_4x4 & 0xff);
        }

        filter_selectively_horiz(
            DST.buf,
            DST.stride,
            mask_16x16_r,
            mask_8x8_r,
            mask_4x4_r,
            cast,no_check(u32) (mask_4x4_int & 0xff),
            CM.lf_info.lfthr.data,
            lfm.lfl_y.data + r << 3
        );

        DST.buf += 8 * DST.stride;
        c_transpiler_compound_shr(*(mask_16x16), (cast(s32) 8), u64, u64);
        c_transpiler_compound_shr(*(mask_8x8), (cast(s32) 8), u64, u64);
        c_transpiler_compound_shr(*(mask_4x4), (cast(s32) 8), u64, u64);
        c_transpiler_compound_shr(*(mask_4x4_int), (cast(s32) 8), u64, u64);
        r += 1;
    }
}

filter_selectively_horiz :: (
    s: *u8,
    pitch: s32,
    mask_16x16: u32,
    mask_8x8: u32,
    mask_4x4: u32,
    mask_4x4_int: u32,
    lfthr: *Loop_Filter_Thresh,
    lfl: *u8
) {
    count: s32 = ---;

    mask := mask_16x16 | mask_8x8 | mask_4x4 | mask_4x4_int;
    while mask != 0 {
        count = 1;
        if mask & 1 != 0 {
            lfi := lfthr + cast,no_check(s32) lfl.*;

            if mask_16x16 & 1 != 0 {
                if (mask_16x16 & 3) == 3 {
                    lpf_horizontal_16_dual_c(s, pitch, lfi.mblim.data, lfi.lim.data, lfi.hev_thr.data);
                    count = 2;
                } else {
                    lpf_horizontal_16_c(s, pitch, lfi.mblim.data, lfi.lim.data, lfi.hev_thr.data);
                }
            } else if mask_8x8 & 1 != 0 {
                if (mask_8x8 & 3) == 3 {
                    lfin := lfthr + cast,no_check(s32) ((lfl + 1).*);

                    lpf_horizontal_8_dual_c(
                        s,
                        pitch,
                        lfi.mblim.data,
                        lfi.lim.data,
                        lfi.hev_thr.data,
                        lfin.mblim.data,
                        lfin.lim.data,
                        lfin.hev_thr.data
                    );

                    if (mask_4x4_int & 3) == 3 {
                        lpf_horizontal_4_dual_c(
                            s + 4 * pitch,
                            pitch,
                            lfi.mblim.data,
                            lfi.lim.data,
                            lfi.hev_thr.data,
                            lfin.mblim.data,
                            lfin.lim.data,
                            lfin.hev_thr.data
                        );
                    } else if mask_4x4_int & 1 != 0 {
                        lpf_horizontal_4_c(s + 4 * pitch, pitch, lfi.mblim.data, lfi.lim.data, lfi.hev_thr.data);
                    } else if mask_4x4_int & 2 != 0 {
                        lpf_horizontal_4_c(s + 8 + 4 * pitch, pitch, lfin.mblim.data, lfin.lim.data, lfin.hev_thr.data);
                    }
                    count = 2;
                } else {
                    lpf_horizontal_8_c(s, pitch, lfi.mblim.data, lfi.lim.data, lfi.hev_thr.data);

                    if mask_4x4_int & 1 != 0 {
                        lpf_horizontal_4_c(s + 4 * pitch, pitch, lfi.mblim.data, lfi.lim.data, lfi.hev_thr.data);
                    }
                }
            } else if mask_4x4 & 1 != 0 {
                if (mask_4x4 & 3) == 3 {
                    lfin := lfthr + cast,no_check(s32) ((lfl + 1).*);

                    lpf_horizontal_4_dual_c(
                        s,
                        pitch,
                        lfi.mblim.data,
                        lfi.lim.data,
                        lfi.hev_thr.data,
                        lfin.mblim.data,
                        lfin.lim.data,
                        lfin.hev_thr.data
                    );
                    if (mask_4x4_int & 3) == 3 {
                        lpf_horizontal_4_dual_c(
                            s + 4 * pitch,
                            pitch,
                            lfi.mblim.data,
                            lfi.lim.data,
                            lfi.hev_thr.data,
                            lfin.mblim.data,
                            lfin.lim.data,
                            lfin.hev_thr.data
                        );
                    } else if mask_4x4_int & 1 != 0 {
                        lpf_horizontal_4_c(s + 4 * pitch, pitch, lfi.mblim.data, lfi.lim.data, lfi.hev_thr.data);
                    } else if mask_4x4_int & 2 != 0 {
                        lpf_horizontal_4_c(s + 8 + 4 * pitch, pitch, lfin.mblim.data, lfin.lim.data, lfin.hev_thr.data);
                    }
                    count = 2;
                } else {
                    lpf_horizontal_4_c(s, pitch, lfi.mblim.data, lfi.lim.data, lfi.hev_thr.data);

                    if mask_4x4_int & 1 != 0 {
                        lpf_horizontal_4_c(s + 4 * pitch, pitch, lfi.mblim.data, lfi.lim.data, lfi.hev_thr.data);
                    }
                }
            } else {
                lpf_horizontal_4_c(s + 4 * pitch, pitch, lfi.mblim.data, lfi.lim.data, lfi.hev_thr.data);
            }
        }
        s += 8 * count;
        lfl += count;
        c_transpiler_compound_shr(*(mask_16x16), (((cast,no_check(u32) count) & 31)), u32, u32);
        c_transpiler_compound_shr(*(mask_8x8), (((cast,no_check(u32) count) & 31)), u32, u32);
        c_transpiler_compound_shr(*(mask_4x4), (((cast,no_check(u32) count) & 31)), u32, u32);
        c_transpiler_compound_shr(*(mask_4x4_int), (((cast,no_check(u32) count) & 31)), u32, u32);
        c_transpiler_compound_shr(*(mask), (((cast,no_check(u32) count) & 31)), u32, u32);
    }
}

filter_selectively_vert_row2 :: (
    subsampling_factor: s32,
    s: *u8,
    pitch: s32,
    mask_16x16: u32,
    mask_8x8: u32,
    mask_4x4: u32,
    mask_4x4_int: u32,
    lfthr: *Loop_Filter_Thresh,
    lfl: *u8
) {
    DUAL_MASK_CUTOFF := (ifx subsampling_factor != 0 then cast(s32) 0xff else 0xffff);
    LFL_FORWARD := (ifx subsampling_factor != 0 then cast(s32) 4 else 8);
    DUAL_ONE := cast,no_check(u32) (1 | ((cast(s32) 1) << ((LFL_FORWARD) & 31)));

    ss: [2] *u8 = ---;
    ss[0] = s;

    mask := mask_16x16 | mask_8x8 | mask_4x4 | mask_4x4_int & cast,no_check(u32) DUAL_MASK_CUTOFF;
    while mask != 0 {
        if mask & DUAL_ONE != 0 {
            lfis: [2] *Loop_Filter_Thresh = ---;
            lfis[0] = lfthr + cast,no_check(s32) lfl.*;
            lfis[1] = lfthr + cast,no_check(s32) ((lfl + LFL_FORWARD).*);
            ss[1] = ss[0] + 8 * pitch;

            if mask_16x16 & DUAL_ONE != 0 {
                if mask_16x16 & DUAL_ONE == DUAL_ONE {
                    lpf_vertical_16_dual_c(ss[0], pitch, lfis[0].mblim.data, lfis[0].lim.data, lfis[0].hev_thr.data);
                } else {
                    lfi := lfis[cast(s32) (mask_16x16 & 1 == 0)];
                    lpf_vertical_16_c(
                        ss[cast(s32) (mask_16x16 & 1 == 0)],
                        pitch,
                        lfi.mblim.data,
                        lfi.lim.data,
                        lfi.hev_thr.data
                    );
                }
            }

            if mask_8x8 & DUAL_ONE != 0 {
                if mask_8x8 & DUAL_ONE == DUAL_ONE {
                    lpf_vertical_8_dual_c(
                        ss[0],
                        pitch,
                        lfis[0].mblim.data,
                        lfis[0].lim.data,
                        lfis[0].hev_thr.data,
                        lfis[1].mblim.data,
                        lfis[1].lim.data,
                        lfis[1].hev_thr.data
                    );
                } else {
                    lfi := lfis[cast(s32) (mask_8x8 & 1 == 0)];
                    lpf_vertical_8_c(
                        ss[cast(s32) (mask_8x8 & 1 == 0)],
                        pitch,
                        lfi.mblim.data,
                        lfi.lim.data,
                        lfi.hev_thr.data
                    );
                }
            }

            if mask_4x4 & DUAL_ONE != 0 {
                if mask_4x4 & DUAL_ONE == DUAL_ONE {
                    lpf_vertical_4_dual_c(
                        ss[0],
                        pitch,
                        lfis[0].mblim.data,
                        lfis[0].lim.data,
                        lfis[0].hev_thr.data,
                        lfis[1].mblim.data,
                        lfis[1].lim.data,
                        lfis[1].hev_thr.data
                    );
                } else {
                    lfi := lfis[cast(s32) (mask_4x4 & 1 == 0)];
                    lpf_vertical_4_c(
                        ss[cast(s32) (mask_4x4 & 1 == 0)],
                        pitch,
                        lfi.mblim.data,
                        lfi.lim.data,
                        lfi.hev_thr.data
                    );
                }
            }

            if mask_4x4_int & DUAL_ONE != 0 {
                if mask_4x4_int & DUAL_ONE == DUAL_ONE {
                    lpf_vertical_4_dual_c(
                        ss[0] + 4,
                        pitch,
                        lfis[0].mblim.data,
                        lfis[0].lim.data,
                        lfis[0].hev_thr.data,
                        lfis[1].mblim.data,
                        lfis[1].lim.data,
                        lfis[1].hev_thr.data
                    );
                } else {
                    lfi := lfis[cast(s32) (mask_4x4_int & 1 == 0)];
                    lpf_vertical_4_c(
                        ss[cast(s32) (mask_4x4_int & 1 == 0)] + 4,
                        pitch,
                        lfi.mblim.data,
                        lfi.lim.data,
                        lfi.hev_thr.data
                    );
                }
            }
        }

        ss[0] += 8;
        lfl += 1;
        c_transpiler_compound_shr(*(mask_16x16), (cast(s32) 1), u32, u32);
        c_transpiler_compound_shr(*(mask_8x8), (cast(s32) 1), u32, u32);
        c_transpiler_compound_shr(*(mask_4x4), (cast(s32) 1), u32, u32);
        c_transpiler_compound_shr(*(mask_4x4_int), (cast(s32) 1), u32, u32);
        mask = mask & ~(DUAL_ONE) >> 1;
    }
}

vp9_filter_block_plane_ss11 :: (CM: *VP9_COMMON, PLANE: *Macroblockd_Plane, mi_row: s32, lfm: *LOOP_FILTER_MASK) {
    DST := *PLANE.dst;
    DST0 := DST.buf;
    c: s32 = ---;
    lfl_uv: [16] u8 = ---;

    mask_16x16 := lfm.left_uv[2];
    mask_8x8 := lfm.left_uv[1];
    mask_4x4 := lfm.left_uv[0];
    mask_4x4_int := lfm.int_4x4_uv;

    fill_memory(*lfl_uv, 0, lfl_uv.count);

    r: s32 = 0;
    while r < (cast(s32) 1) << (((6 - 3)) & 31) && mi_row + r < CM.mi_rows {
        c = 0;
        while c < (cast(s32) 1) << (((6 - 3)) & 31) >> 1 {
            lfl_uv[r << 1 + c] = lfm.lfl_y[r << 3 + c << 1];
            lfl_uv[(r + 2) << 1 + c] = lfm.lfl_y[(r + 2) << 3 + c << 1];
            c += 1;
        }

        filter_selectively_vert_row2(
            PLANE.subsampling_x,
            DST.buf,
            DST.stride,
            cast,no_check(u32) mask_16x16,
            cast,no_check(u32) mask_8x8,
            cast,no_check(u32) mask_4x4,
            cast,no_check(u32) mask_4x4_int,
            CM.lf_info.lfthr.data,
            lfl_uv.data + r << 1
        );

        DST.buf += 16 * DST.stride;
        c_transpiler_compound_shr(*(mask_16x16), (cast(s32) 8), s32, s32);
        c_transpiler_compound_shr(*(mask_8x8), (cast(s32) 8), s32, s32);
        c_transpiler_compound_shr(*(mask_4x4), (cast(s32) 8), s32, s32);
        c_transpiler_compound_shr(*(mask_4x4_int), (cast(s32) 8), s32, s32);
        r += 4;
    }

    DST.buf = DST0;
    mask_16x16 = lfm.above_uv[2];
    mask_8x8 = lfm.above_uv[1];
    mask_4x4 = lfm.above_uv[0];
    mask_4x4_int = lfm.int_4x4_uv;

    r = 0;
    while r < (cast(s32) 1) << (((6 - 3)) & 31) && mi_row + r < CM.mi_rows {
        SKIP_BORDER_4X4_R := cast(s32) (mi_row + r == CM.mi_rows - 1);
        MASK_4X4_INT_R := cast,no_check(u32) ((ifx SKIP_BORDER_4X4_R != 0 then 0 else (cast(s32) mask_4x4_int) & 0xf));
        mask_16x16_r: u32 = ---;
        mask_8x8_r: u32 = ---;
        mask_4x4_r: u32 = ---;

        if mi_row + r == 0 {
            mask_16x16_r = 0;
            mask_8x8_r = 0;
            mask_4x4_r = 0;
        } else {
            mask_16x16_r = cast,no_check(u32) ((cast(s32) mask_16x16) & 0xf);
            mask_8x8_r = cast,no_check(u32) ((cast(s32) mask_8x8) & 0xf);
            mask_4x4_r = cast,no_check(u32) ((cast(s32) mask_4x4) & 0xf);
        }

        filter_selectively_horiz(
            DST.buf,
            DST.stride,
            mask_16x16_r,
            mask_8x8_r,
            mask_4x4_r,
            MASK_4X4_INT_R,
            CM.lf_info.lfthr.data,
            lfl_uv.data + r << 1
        );

        DST.buf += 8 * DST.stride;
        c_transpiler_compound_shr(*(mask_16x16), (cast(s32) 4), s32, s32);
        c_transpiler_compound_shr(*(mask_8x8), (cast(s32) 4), s32, s32);
        c_transpiler_compound_shr(*(mask_4x4), (cast(s32) 4), s32, s32);
        c_transpiler_compound_shr(*(mask_4x4_int), (cast(s32) 4), s32, s32);
        r += 2;
    }
}

vp9_filter_block_plane_non420 :: (
    cm: *VP9_COMMON,
    plane: *Macroblockd_Plane,
    mi_8x8: **MODE_INFO,
    mi_row: s32,
    mi_col: s32
) {
    SS_X := plane.subsampling_x;
    SS_Y := plane.subsampling_y;
    ROW_STEP := (cast(s32) 1) << ((SS_Y) & 31);
    COL_STEP := (cast(s32) 1) << ((SS_X) & 31);
    ROW_STEP_STRIDE := cm.mi_stride * ROW_STEP;
    DST := *plane.dst;
    DST0 := DST.buf;
    mask_16x16: [8] u32 = ---;
    mask_8x8: [8] u32 = ---;
    mask_4x4: [8] u32 = ---;
    mask_4x4_int: [8] u32 = ---;
    lfl: [64] u8 = ---;
    c: s32 = ---;

    fill_memory(*mask_16x16, 0, mask_16x16.count * size_of(u32));
    fill_memory(*mask_8x8, 0, mask_8x8.count * size_of(u32));
    fill_memory(*mask_4x4, 0, mask_4x4.count * size_of(u32));
    fill_memory(*mask_4x4_int, 0, mask_4x4_int.count * size_of(u32));
    fill_memory(*lfl, 0, lfl.count);

    r: s32 = 0;
    while r < (cast(s32) 1) << (((6 - 3)) & 31) && mi_row + r < cm.mi_rows {
        mask_16x16_c: u32 = 0;
        mask_8x8_c: u32 = 0;
        mask_4x4_c: u32 = 0;

        c = 0;
        while c < (cast(s32) 1) << (((6 - 3)) & 31) && mi_col + c < cm.mi_cols {
            mi := mi_8x8[c];
            SB_TYPE := mi[0].sb_type;
            SKIP_THIS := cast(s32) (mi[0].skip != 0 && is_inter_block_in_vp9_loopfilter(mi) != 0);

            BLOCK_EDGE_LEFT :=
                (ifx NUM_4X4_BLOCKS_WIDE_LOOKUP[SB_TYPE] > 1 then cast(s32) (c & ((cast(s32) NUM_8X8_BLOCKS_WIDE_LOOKUP[SB_TYPE]) -
                    1) == 0) else 1);
            SKIP_THIS_C := cast(s32) (SKIP_THIS != 0 && BLOCK_EDGE_LEFT == 0);

            BLOCK_EDGE_ABOVE :=
                (ifx NUM_4X4_BLOCKS_HIGH_LOOKUP[SB_TYPE] > 1 then cast(s32) (r & ((cast(s32) NUM_8X8_BLOCKS_HIGH_LOOKUP[SB_TYPE]) -
                    1) == 0) else 1);
            SKIP_THIS_R := cast(s32) (SKIP_THIS != 0 && BLOCK_EDGE_ABOVE == 0);
            TX_SIZE_ := get_uv_tx_size_in_vp9_loopfilter(mi, plane);
            SKIP_BORDER_4X4_C := cast(s32) (SS_X != 0 && mi_col + c == cm.mi_cols - 1);
            SKIP_BORDER_4X4_R := cast(s32) (SS_Y != 0 && mi_row + r == cm.mi_rows - 1);

            if (ifx true { assignment_0: u8 = cast,no_check(u8) (get_filter_level(*cm.lf_info, mi)); (lfl[r << 3 + c >> ((SS_X) & 31)]) = assignment_0; assignment_0; }) == 0 {
                c += COL_STEP;
                continue;
            }

            if TX_SIZE_ == cast(TX_SIZE) 3 {
                if SKIP_THIS_C == 0 && c >> ((SS_X) & 31) & 3 == 0 {
                    if SKIP_BORDER_4X4_C == 0 {
                        mask_16x16_c |= cast,no_check(u32) ((cast(s32) 1) << (((c >> ((SS_X) & 31))) & 31));
                    } else {
                        mask_8x8_c |= cast,no_check(u32) ((cast(s32) 1) << (((c >> ((SS_X) & 31))) & 31));
                    }
                }
                if SKIP_THIS_R == 0 && r >> ((SS_Y) & 31) & 3 == 0 {
                    if SKIP_BORDER_4X4_R == 0 {
                        mask_16x16[r] |= cast,no_check(u32) ((cast(s32) 1) << (((c >> ((SS_X) & 31))) & 31));
                    } else {
                        mask_8x8[r] |= cast,no_check(u32) ((cast(s32) 1) << (((c >> ((SS_X) & 31))) & 31));
                    }
                }
            } else if TX_SIZE_ == cast(TX_SIZE) 2 {
                if SKIP_THIS_C == 0 && c >> ((SS_X) & 31) & 1 == 0 {
                    if SKIP_BORDER_4X4_C == 0 {
                        mask_16x16_c |= cast,no_check(u32) ((cast(s32) 1) << (((c >> ((SS_X) & 31))) & 31));
                    } else {
                        mask_8x8_c |= cast,no_check(u32) ((cast(s32) 1) << (((c >> ((SS_X) & 31))) & 31));
                    }
                }
                if SKIP_THIS_R == 0 && r >> ((SS_Y) & 31) & 1 == 0 {
                    if SKIP_BORDER_4X4_R == 0 {
                        mask_16x16[r] |= cast,no_check(u32) ((cast(s32) 1) << (((c >> ((SS_X) & 31))) & 31));
                    } else {
                        mask_8x8[r] |= cast,no_check(u32) ((cast(s32) 1) << (((c >> ((SS_X) & 31))) & 31));
                    }
                }
            } else {
                if SKIP_THIS_C == 0 {
                    if TX_SIZE_ == cast(TX_SIZE) 1 || c >> ((SS_X) & 31) & 3 == 0 {
                        mask_8x8_c |= cast,no_check(u32) ((cast(s32) 1) << (((c >> ((SS_X) & 31))) & 31));
                    } else {
                        mask_4x4_c |= cast,no_check(u32) ((cast(s32) 1) << (((c >> ((SS_X) & 31))) & 31));
                    }
                }

                if SKIP_THIS_R == 0 {
                    if TX_SIZE_ == cast(TX_SIZE) 1 || r >> ((SS_Y) & 31) & 3 == 0 {
                        mask_8x8[r] |= cast,no_check(u32) ((cast(s32) 1) << (((c >> ((SS_X) & 31))) & 31));
                    } else {
                        mask_4x4[r] |= cast,no_check(u32) ((cast(s32) 1) << (((c >> ((SS_X) & 31))) & 31));
                    }
                }

                if SKIP_THIS == 0 && TX_SIZE_ < cast(TX_SIZE) 1 && SKIP_BORDER_4X4_C == 0 {
                    mask_4x4_int[r] |= cast,no_check(u32) ((cast(s32) 1) << (((c >> ((SS_X) & 31))) & 31));
                }
            }
            c += COL_STEP;
        }

        border_mask := ~((ifx mi_col == 0 then cast(u32) 1 else 0));

        filter_selectively_vert(
            DST.buf,
            DST.stride,
            mask_16x16_c & border_mask,
            mask_8x8_c & border_mask,
            mask_4x4_c & border_mask,
            mask_4x4_int[r],
            cm.lf_info.lfthr.data,
            lfl.data + r << 3
        );

        DST.buf += 8 * DST.stride;
        mi_8x8 += ROW_STEP_STRIDE;
        r += ROW_STEP;
    }

    DST.buf = DST0;
    r = 0;
    while r < (cast(s32) 1) << (((6 - 3)) & 31) && mi_row + r < cm.mi_rows {
        SKIP_BORDER_4X4_R := cast(s32) (SS_Y != 0 && mi_row + r == cm.mi_rows - 1);
        MASK_4X4_INT_R := (ifx SKIP_BORDER_4X4_R != 0 then 0 else mask_4x4_int[r]);

        mask_16x16_r: u32 = ---;
        mask_8x8_r: u32 = ---;
        mask_4x4_r: u32 = ---;

        if mi_row + r == 0 {
            mask_16x16_r = 0;
            mask_8x8_r = 0;
            mask_4x4_r = 0;
        } else {
            mask_16x16_r = mask_16x16[r];
            mask_8x8_r = mask_8x8[r];
            mask_4x4_r = mask_4x4[r];
        }

        filter_selectively_horiz(
            DST.buf,
            DST.stride,
            mask_16x16_r,
            mask_8x8_r,
            mask_4x4_r,
            MASK_4X4_INT_R,
            cm.lf_info.lfthr.data,
            lfl.data + r << 3
        );

        DST.buf += 8 * DST.stride;
        r += ROW_STEP;
    }
}

filter_selectively_vert :: (
    s: *u8,
    pitch: s32,
    mask_16x16: u32,
    mask_8x8: u32,
    mask_4x4: u32,
    mask_4x4_int: u32,
    lfthr: *Loop_Filter_Thresh,
    lfl: *u8
) {
    mask := mask_16x16 | mask_8x8 | mask_4x4 | mask_4x4_int;
    while mask != 0 {
        lfi := lfthr + cast,no_check(s32) lfl.*;

        if mask & 1 != 0 {
            if mask_16x16 & 1 != 0 {
                lpf_vertical_16_c(s, pitch, lfi.mblim.data, lfi.lim.data, lfi.hev_thr.data);
            } else if mask_8x8 & 1 != 0 {
                lpf_vertical_8_c(s, pitch, lfi.mblim.data, lfi.lim.data, lfi.hev_thr.data);
            } else if mask_4x4 & 1 != 0 {
                lpf_vertical_4_c(s, pitch, lfi.mblim.data, lfi.lim.data, lfi.hev_thr.data);
            }
        }
        if mask_4x4_int & 1 != 0 {
            lpf_vertical_4_c(s + 4, pitch, lfi.mblim.data, lfi.lim.data, lfi.hev_thr.data);
        }
        s += 8;
        lfl += 1;
        c_transpiler_compound_shr(*(mask_16x16), (cast(s32) 1), u32, u32);
        c_transpiler_compound_shr(*(mask_8x8), (cast(s32) 1), u32, u32);
        c_transpiler_compound_shr(*(mask_4x4), (cast(s32) 1), u32, u32);
        c_transpiler_compound_shr(*(mask_4x4_int), (cast(s32) 1), u32, u32);
        c_transpiler_compound_shr(*(mask), (cast(s32) 1), u32, u32);
    }
}

vp9_loop_filter_init :: (cm: *VP9_COMMON) {
    lfi := *cm.lf_info;
    lf := *cm.lf;

    update_sharpness(lfi, lf.sharpness_level);
    lf.last_sharpness_level = lf.sharpness_level;

    for lvl: 0..cast(s32) 63 {
        fill_memory(lfi.lfthr[lvl].hev_thr.data, lvl >> 4, 16);
    }
}

update_sharpness :: (lfi: *Loop_Filter_Info_N_in_vp9_alloccommon, sharpness_lvl: s32) {
    for lvl: 0..cast(s32) 63 {
        block_inside_limit := lvl >> ((((cast(s32) (sharpness_lvl > 0)) + cast(s32) (sharpness_lvl > 4))) & 31);

        if sharpness_lvl > 0 {
            if block_inside_limit > 9 - sharpness_lvl {
                block_inside_limit = 9 - sharpness_lvl;
            }
        }

        if block_inside_limit < 1 {
            block_inside_limit = 1;
        }

        fill_memory(lfi.lfthr[lvl].lim.data, block_inside_limit, 16);
        fill_memory(lfi.lfthr[lvl].mblim.data, 2 * (lvl + 2) + block_inside_limit, 16);
    }
}

vp9_loop_filter_frame_init :: (cm: *VP9_COMMON, default_filt_lvl: s32) {
    SCALE := (cast(s32) 1) << (((default_filt_lvl >> 5)) & 31);
    LFI := *cm.lf_info;
    LF := *cm.lf;
    SEG := *cm.seg;

    if LF.last_sharpness_level != LF.sharpness_level {
        update_sharpness(LFI, LF.sharpness_level);
        LF.last_sharpness_level = LF.sharpness_level;
    }

    for seg_id: 0..cast(s32) 8 - 1 {
        lvl_seg := default_filt_lvl;
        if segfeature_active_in_vp9_loopfilter(SEG, seg_id, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_LF) != 0 {
            DATA := get_segdata_in_vp9_loopfilter(SEG, seg_id, cast,no_check(SEG_LVL_FEATURES) SEG_LVL_ALT_LF);
            lvl_seg = clamp_in_vp9_loopfilter((ifx SEG.abs_delta == 1 then DATA else default_filt_lvl + DATA), 0, 63);
        }

        if LF.mode_ref_delta_enabled == 0 {
            fill_memory(LFI.lvl[seg_id].data, lvl_seg, 4 * (2 * cast(u64) size_of(u8)));
        } else {
            mode: s32 = ---;
            INTRA_LVL := lvl_seg + (cast(s32) LF.ref_deltas[0]) * SCALE;
            LFI.lvl[seg_id][0][0] = cast,no_check(u8) clamp_in_vp9_loopfilter(INTRA_LVL, 0, 63);

            if 1 < 4 {
                for ref: 1..cast(s32) 4 - 1 {
                    mode = 0;
                    while mode < 2 {
                        INTER_LVL :=
                            lvl_seg + (cast(s32) LF.ref_deltas[ref]) * SCALE +
                                (cast(s32) LF.mode_deltas[mode]) * SCALE;
                        LFI.lvl[seg_id][ref][mode] = cast,no_check(u8) clamp_in_vp9_loopfilter(INTER_LVL, 0, 63);
                        mode += 1;
                    }
                }
            }
        }
    }
}

vp9_loop_filter_frame :: (
    frame: *YV12_BUFFER_CONFIG,
    cm: *VP9_COMMON,
    xd: *MACROBLOCKD,
    frame_filter_level: s32,
    y_only: s32,
    partial_frame: s32
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
    loop_filter_rows(frame, cm, xd.plane.data, start_mi_row, end_mi_row, y_only);
}

loop_filter_rows :: (
    frame_buffer: *YV12_BUFFER_CONFIG,
    cm: *VP9_COMMON,
    planes: *Macroblockd_Plane,
    start: s32,
    stop: s32,
    y_only: s32
) {
    NUM_PLANES := (ifx y_only != 0 then cast(s32) 1 else 3);
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
        mi := cm.mi_grid_visible + mi_row * cm.mi_stride;
        lfm := get_lfm_in_vp9_loopfilter(*cm.lf, mi_row, 0);

        mi_col = 0;
        while mi_col < cm.mi_cols {
            vp9_setup_dst_planes(planes, frame_buffer, mi_row, mi_col);

            vp9_adjust_mask(cm, mi_row, mi_col, lfm);

            vp9_filter_block_plane_ss00(cm, *planes[0], mi_row, lfm);
            if 1 < NUM_PLANES {
                for plane: 1..NUM_PLANES - 1 {
                    if path == {
                        case cast,no_check(u32) LF_PATH_420;
                            vp9_filter_block_plane_ss11(cm, *planes[plane], mi_row, lfm);
                        case cast,no_check(u32) LF_PATH_444;
                            vp9_filter_block_plane_ss00(cm, *planes[plane], mi_row, lfm);
                        case cast,no_check(u32) LF_PATH_SLOW;
                            vp9_filter_block_plane_non420(cm, *planes[plane], mi + mi_col, mi_row, mi_col);
                    }
                }
            }
            mi_col += (cast(s32) 1) << (((6 - 3)) & 31);
            lfm += 1;
        }
        mi_row += (cast(s32) 1) << (((6 - 3)) & 31);
    }
}

get_lfm_in_vp9_loopfilter :: (lf: *Loopfilter, MI_ROW: s32, MI_COL: s32) -> *LOOP_FILTER_MASK {
    return *lf.lfm[MI_COL >> 3 + MI_ROW >> 3 * lf.lfm_stride];
}

vp9_adjust_mask :: (CM: *VP9_COMMON, MI_ROW: s32, MI_COL: s32, lfm: *LOOP_FILTER_MASK) {
    i: s32 = ---;

    lfm.left_y[2] |= lfm.left_y[3];
    lfm.above_y[2] |= lfm.above_y[3];
    lfm.left_uv[2] = cast,no_check(u16) ((cast,no_check(s32) lfm.left_uv[2]) | cast,no_check(s32) lfm.left_uv[3]);
    lfm.above_uv[2] = cast,no_check(u16) ((cast,no_check(s32) lfm.above_uv[2]) | cast,no_check(s32) lfm.above_uv[3]);

    lfm.left_y[1] |= lfm.left_y[0] & LEFT_BORDER;
    lfm.left_y[0] &= ~(LEFT_BORDER);
    lfm.above_y[1] |= lfm.above_y[0] & ABOVE_BORDER;
    lfm.above_y[0] &= ~(ABOVE_BORDER);
    lfm.left_uv[1] = cast,no_check(u16) ((cast,no_check(s32) lfm.left_uv[1]) | ((cast(s32) lfm.left_uv[0]) & cast(s32) LEFT_BORDER_UV));
    lfm.left_uv[0] = cast,no_check(u16) ((cast,no_check(s32) lfm.left_uv[0]) & ~(cast,no_check(s32) LEFT_BORDER_UV));
    lfm.above_uv[1] = cast,no_check(u16) ((cast,no_check(s32) lfm.above_uv[1]) | ((cast(s32) lfm.above_uv[0]) & cast(s32) ABOVE_BORDER_UV));
    lfm.above_uv[0] = cast,no_check(u16) ((cast,no_check(s32) lfm.above_uv[0]) & ~(cast,no_check(s32) ABOVE_BORDER_UV));

    if MI_ROW + (cast(s32) 1) << (((6 - 3)) & 31) > CM.mi_rows {
        ROWS := cast,no_check(u64) (CM.mi_rows - MI_ROW);

        MASK_Y := (cast(u64) 1) << (((ROWS << 3)) & 63) - 1;
        MASK_UV := cast,no_check(u16) ((cast,no_check(s32) (cast(u16) 1)) << ((((ROWS + 1) >> 1 << 2)) & 31) - 1);

        i = 0;
        while i < cast,no_check(s32) (cast(TX_SIZE) 3) {
            lfm.left_y[i] &= MASK_Y;
            lfm.above_y[i] &= MASK_Y;
            lfm.left_uv[i] = cast,no_check(u16) ((cast,no_check(s32) lfm.left_uv[i]) & cast,no_check(s32) MASK_UV);
            lfm.above_uv[i] = cast,no_check(u16) ((cast,no_check(s32) lfm.above_uv[i]) & cast,no_check(s32) MASK_UV);
            i += 1;
        }
        lfm.int_4x4_y &= MASK_Y;
        lfm.int_4x4_uv = cast,no_check(u16) ((cast,no_check(s32) lfm.int_4x4_uv) & cast,no_check(s32) MASK_UV);

        if ROWS == 1 {
            lfm.above_uv[1] = cast,no_check(u16) ((cast,no_check(s32) lfm.above_uv[1]) | cast,no_check(s32) lfm.above_uv[2]);
            lfm.above_uv[2] = 0;
        }
        if ROWS == 5 {
            lfm.above_uv[1] = cast,no_check(u16) ((cast,no_check(s32) lfm.above_uv[1]) | ((cast(s32) lfm.above_uv[2]) & 0xff00));
            lfm.above_uv[2] = cast,no_check(u16) ((cast,no_check(s32) lfm.above_uv[2]) & ~((cast(s32) lfm.above_uv[2]) & 0xff00));
        }
    }

    if MI_COL + (cast(s32) 1) << (((6 - 3)) & 31) > CM.mi_cols {
        COLUMNS := cast,no_check(u64) (CM.mi_cols - MI_COL);

        MASK_Y := ((cast,no_check(u64) ((cast(s32) 1) << ((COLUMNS) & 31) - 1)) * 0x101010101010101);
        MASK_UV := cast,no_check(u16) (((cast(s32) 1) << ((((COLUMNS + 1) >> 1)) & 31) - 1) * 0x1111);

        MASK_UV_INT := cast,no_check(u16) (((cast(s32) 1) << (((COLUMNS >> 1)) & 31) - 1) * 0x1111);

        i = 0;
        while i < cast,no_check(s32) (cast(TX_SIZE) 3) {
            lfm.left_y[i] &= MASK_Y;
            lfm.above_y[i] &= MASK_Y;
            lfm.left_uv[i] = cast,no_check(u16) ((cast,no_check(s32) lfm.left_uv[i]) & cast,no_check(s32) MASK_UV);
            lfm.above_uv[i] = cast,no_check(u16) ((cast,no_check(s32) lfm.above_uv[i]) & cast,no_check(s32) MASK_UV);
            i += 1;
        }
        lfm.int_4x4_y &= MASK_Y;
        lfm.int_4x4_uv = cast,no_check(u16) ((cast,no_check(s32) lfm.int_4x4_uv) & cast,no_check(s32) MASK_UV_INT);

        if COLUMNS == 1 {
            lfm.left_uv[1] = cast,no_check(u16) ((cast,no_check(s32) lfm.left_uv[1]) | cast,no_check(s32) lfm.left_uv[2]);
            lfm.left_uv[2] = 0;
        }
        if COLUMNS == 5 {
            lfm.left_uv[1] = cast,no_check(u16) ((cast,no_check(s32) lfm.left_uv[1]) | ((cast(s32) lfm.left_uv[2]) & 0xcccc));
            lfm.left_uv[2] = cast,no_check(u16) ((cast,no_check(s32) lfm.left_uv[2]) & ~((cast(s32) lfm.left_uv[2]) & 0xcccc));
        }
    }

    if MI_COL == 0 {
        i = 0;
        while i < cast,no_check(s32) (cast(TX_SIZE) 3) {
            lfm.left_y[i] = cast,no_check(u64) (lfm.left_y[i] & cast(u64) 0xfefefefefefefefe);
            lfm.left_uv[i] = cast,no_check(u16) ((cast,no_check(s32) lfm.left_uv[i]) & 0xeeee);
            i += 1;
        }
    }
}

vp9_build_mask :: (cm: *VP9_COMMON, mi: *MODE_INFO, mi_row: s32, mi_col: s32, bw: s32, bh: s32) {
    BLOCK_SIZE_ := mi.sb_type;
    TX_SIZE_Y := mi.tx_size;
    LFI_N := *cm.lf_info;
    FILTER_LEVEL := cast,no_check(s32) get_filter_level(LFI_N, mi);
    TX_SIZE_UV := UV_TXSIZE_LOOKUP[BLOCK_SIZE_][TX_SIZE_Y][1][1];
    LFM := get_lfm_in_vp9_loopfilter(*cm.lf, mi_row, mi_col);
    LEFT_Y := LFM.left_y.data + TX_SIZE_Y;
    ABOVE_Y := LFM.above_y.data + TX_SIZE_Y;
    INT_4X4_Y := *LFM.int_4x4_y;
    LEFT_UV := LFM.left_uv.data + TX_SIZE_UV;
    ABOVE_UV := LFM.above_uv.data + TX_SIZE_UV;
    INT_4X4_UV := *LFM.int_4x4_uv;
    ROW_IN_SB := mi_row & 7;
    COL_IN_SB := mi_col & 7;
    SHIFT_Y := COL_IN_SB + ROW_IN_SB << 3;
    SHIFT_UV := COL_IN_SB >> 1 + ROW_IN_SB >> 1 << 2;
    BUILD_UV := cast,no_check(s32) FIRST_BLOCK_IN_16X16[ROW_IN_SB][COL_IN_SB];

    if FILTER_LEVEL == 0 {
        return;
    } else {
        index := SHIFT_Y;

        if 0 < bh {
            for i: 0..bh - 1 {
                fill_memory(LFM.lfl_y.data + index, FILTER_LEVEL, cast,no_check(u64) bw);
                index += 8;
            }
        }
    }

    ABOVE_Y.* |= ABOVE_PREDICTION_MASK[BLOCK_SIZE_] << ((SHIFT_Y) & 63);
    LEFT_Y.* |= LEFT_PREDICTION_MASK[BLOCK_SIZE_] << ((SHIFT_Y) & 63);

    if BUILD_UV != 0 {
        ABOVE_UV.* = cast,no_check(u16) ((cast,no_check(s32) ABOVE_UV.*) | ((cast(s32) ABOVE_PREDICTION_MASK_UV[BLOCK_SIZE_]) << ((SHIFT_UV) & 31)));
        LEFT_UV.* = cast,no_check(u16) ((cast,no_check(s32) LEFT_UV.*) | ((cast(s32) LEFT_PREDICTION_MASK_UV[BLOCK_SIZE_]) << ((SHIFT_UV) & 31)));
    }

    if mi.skip != 0 && is_inter_block_in_vp9_loopfilter(mi) != 0 {
        return;
    }

    ABOVE_Y.* |= SIZE_MASK[BLOCK_SIZE_] & ABOVE_64X64_TXFORM_MASK[TX_SIZE_Y] << ((SHIFT_Y) & 63);
    LEFT_Y.* |= SIZE_MASK[BLOCK_SIZE_] & LEFT_64X64_TXFORM_MASK[TX_SIZE_Y] << ((SHIFT_Y) & 63);

    if BUILD_UV != 0 {
        ABOVE_UV.* = cast,no_check(u16) ((cast,no_check(s32) ABOVE_UV.*) | (((cast(s32) SIZE_MASK_UV[BLOCK_SIZE_]) & cast(s32) ABOVE_64X64_TXFORM_MASK_UV[TX_SIZE_UV]) << ((SHIFT_UV) & 31)));

        LEFT_UV.* = cast,no_check(u16) ((cast,no_check(s32) LEFT_UV.*) | (((cast(s32) SIZE_MASK_UV[BLOCK_SIZE_]) & cast(s32) LEFT_64X64_TXFORM_MASK_UV[TX_SIZE_UV]) << ((SHIFT_UV) & 31)));
    }

    if TX_SIZE_Y == cast(TX_SIZE) 0 {
        INT_4X4_Y.* |= SIZE_MASK[BLOCK_SIZE_] << ((SHIFT_Y) & 63);
    }

    if BUILD_UV != 0 && TX_SIZE_UV == cast(TX_SIZE) 0 {
        INT_4X4_UV.* = cast,no_check(u16) ((cast,no_check(s32) INT_4X4_UV.*) | ((cast(s32) SIZE_MASK_UV[BLOCK_SIZE_]) & 0xffff << ((SHIFT_UV) & 31)));
    }
}

vp9_build_mask_frame :: (cm: *VP9_COMMON, frame_filter_level: s32, partial_frame: s32) {
    mi_col: s32 = ---;
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

    mi_row := start_mi_row;
    while mi_row < end_mi_row {
        mi := cm.mi_grid_visible + mi_row * cm.mi_stride;
        mi_col = 0;
        while mi_col < cm.mi_cols {
            vp9_setup_mask(
                cm,
                mi_row,
                mi_col,
                mi + mi_col,
                cm.mi_stride,
                get_lfm_in_vp9_loopfilter(*cm.lf, mi_row, mi_col)
            );
            mi_col += (cast(s32) 1) << (((6 - 3)) & 31);
        }
        mi_row += (cast(s32) 1) << (((6 - 3)) & 31);
    }
}

vp9_reset_lfm :: (CM: *VP9_COMMON) {
    if CM.lf.filter_level != 0 {
        fill_memory(
            CM.lf.lfm,
            0,
            cast,no_check(u64) ((CM.mi_rows + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) >> 3 * CM.lf.lfm_stride) *
            size_of(LOOP_FILTER_MASK)
        );
    }
}

vp9_loop_filter_data_reset :: (
    lf_data: *LF_Worker_Data,
    frame_buffer: *YV12_BUFFER_CONFIG,
    cm: *VP9_Common_in_vp9_onyxc_int,
    planes: *Macroblockd_Plane
) {
    lf_data.frame_buffer = frame_buffer;
    lf_data.cm = cm;
    lf_data.start = 0;
    lf_data.stop = 0;
    lf_data.y_only = 0;
    copy_memory(lf_data.planes.data, planes, lf_data.planes.count * size_of(Macroblockd_Plane));
}

vp9_loop_filter_worker :: (arg1: *void, unused: *void) -> s32 {
    LF_DATA := cast(*LF_Worker_Data) arg1;

    loop_filter_rows(LF_DATA.frame_buffer, LF_DATA.cm, LF_DATA.planes.data, LF_DATA.start, LF_DATA.stop, LF_DATA.y_only);
    return 1;
}

init_frame_indexes_in_vp9_loopfilter :: (cm: *VP9_COMMON) {
    cm.current_video_frame = 0;
    cm.current_frame_coding_index = 0;
}

update_frame_indexes_in_vp9_loopfilter :: (cm: *VP9_COMMON, show_frame: s32) {
    if show_frame != 0 {
        cm.current_video_frame += 1;
    }
    cm.current_frame_coding_index += 1;
}

init_frame_info_in_vp9_loopfilter :: (frame_info: *FRAME_INFO, cm: *VP9_COMMON) {
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

get_buf_frame_in_vp9_loopfilter :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 + 1 + 3 {
        return null;
    }
    if cm.error.error_code != cast,no_check(u32) CODEC_OK {
        return null;
    }
    return *cm.buffer_pool.frame_bufs[index].buf;
}

get_ref_frame_in_vp9_loopfilter :: (cm: *VP9_COMMON, index: s32) -> *YV12_BUFFER_CONFIG {
    if index < 0 || index >= (cast(s32) 1) << 3 {
        return null;
    }
    if cm.ref_frame_map[index] < 0 {
        return null;
    }

    return *cm.buffer_pool.frame_bufs[cm.ref_frame_map[index]].buf;
}

get_frame_new_buffer_in_vp9_loopfilter :: (cm: *VP9_COMMON) -> *YV12_BUFFER_CONFIG {
    return *cm.buffer_pool.frame_bufs[cm.new_fb_idx].buf;
}

get_free_fb_in_vp9_loopfilter :: (cm: *VP9_COMMON) -> s32 {
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

ref_cnt_fb_in_vp9_loopfilter :: (bufs: *Ref_Cnt_Buffer, idx: *s32, new_idx: s32) {
    REF_INDEX := idx.*;

    if REF_INDEX >= 0 && bufs[REF_INDEX].ref_count > 0 {
        bufs[REF_INDEX].ref_count -= 1;
    }

    idx.* = new_idx;

    bufs[new_idx].ref_count += 1;
}

mi_cols_aligned_to_sb_in_vp9_loopfilter :: (n_mis: s32) -> s32 {
    return (n_mis + ((cast(s32) 1) << (((6 - 3)) & 31) - 1)) & ~((cast(s32) 1) << (((6 - 3)) & 31) - 1);
}

frame_is_intra_only_in_vp9_loopfilter :: (CM: *VP9_COMMON) -> s32 {
    if CM.frame_type == cast,no_check(u32) KEY_FRAME || CM.intra_only != 0 {
        return 1;
    }
    return 0;
}

set_partition_probs_in_vp9_loopfilter :: (CM: *VP9_COMMON, XD: *MACROBLOCKD) {
    XD.partition_probs =
        ifx frame_is_intra_only_in_vp9_loopfilter(CM) != 0 then VP9_KF_PARTITION_PROBS.data +
            0 else CM.fc.partition_prob.data;
}

vp9_init_macroblockd_in_vp9_loopfilter :: (cm: *VP9_COMMON, xd: *MACROBLOCKD, dqcoeff: *Tran_Low_T) {
    for i: 0..cast(s32) 3 - 1 {
        xd.plane[i].dqcoeff = dqcoeff;
        xd.above_context[i] =
            cm.above_context +
                ((cast,no_check(u64) i) * size_of(ENTROPY_CONTEXT) * 2) * cast,no_check(u64) mi_cols_aligned_to_sb_in_vp9_loopfilter(cm.mi_cols);

        if get_plane_type_in_vp9_loopfilter(i) == cast,no_check(u32) PLANE_TYPE_Y {
            copy_memory(xd.plane[i].seg_dequant.data, cm.y_dequant.data, cm.y_dequant.count * size_of([2] s16));
        } else {
            copy_memory(xd.plane[i].seg_dequant.data, cm.uv_dequant.data, cm.uv_dequant.count * size_of([2] s16));
        }
        xd.fc = cm.fc;
    }

    xd.above_seg_context = cm.above_seg_context;
    xd.mi_stride = cm.mi_stride;
    xd.error_info = *cm.error;

    set_partition_probs_in_vp9_loopfilter(cm, xd);
}

get_partition_probs_in_vp9_loopfilter :: (xd: *MACROBLOCKD, ctx: s32) -> *Prob {
    return xd.partition_probs[ctx].data;
}

set_skip_context_in_vp9_loopfilter :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32) {
    ABOVE_IDX := mi_col * 2;
    LEFT_IDX := (mi_row * 2) & 15;

    for i: 0..cast(s32) 3 - 1 {
        PD := xd.plane.data + i;
        PD.above_context = *xd.above_context[i][ABOVE_IDX >> ((PD.subsampling_x) & 31)];
        PD.left_context = xd.left_context[i].data + LEFT_IDX >> ((PD.subsampling_y) & 31);
    }
}

calc_mi_size_in_vp9_loopfilter :: (len: s32) -> s32 {
    return len + (cast(s32) 1) << (((6 - 3)) & 31);
}

set_mi_row_col_in_vp9_loopfilter :: (
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

update_partition_context_in_vp9_loopfilter :: (
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

partition_plane_context_in_vp9_loopfilter :: (xd: *MACROBLOCKD, mi_row: s32, mi_col: s32, bsize: BLOCK_SIZE) -> s32 {
    above_ctx := xd.above_seg_context + mi_col;
    left_ctx := xd.left_seg_context.data + mi_row & ((cast(s32) 1) << (((6 - 3)) & 31) - 1);
    BSL := cast,no_check(s32) MI_WIDTH_LOG2_LOOKUP[bsize];
    above := (cast(s32) above_ctx.*) >> ((BSL) & 31) & 1;
    left := (cast(s32) left_ctx.*) >> ((BSL) & 31) & 1;

    return left * 2 + above + BSL * 4;
}

inter_predictor :: (
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

scaled_buffer_offset :: (x_offset: s32, y_offset: s32, stride: s32, sf: *Scale_Factors) -> s64 {
    X := (ifx sf != null then sf.scale_value_x(x_offset, sf) else x_offset);
    Y := (ifx sf != null then sf.scale_value_y(y_offset, sf) else y_offset);
    return ((cast,no_check(s64) Y) * cast(s64) stride) + cast(s64) X;
}

setup_pred_plane :: (
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
    dst.buf = src + scaled_buffer_offset(X, Y, stride, scale);
    dst.stride = stride;
}

globals_initialization_state_for_vp9_loopfilter: u32;
initialize_globals_for_vp9_loopfilter :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vp9_loopfilter);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vp9_loopfilter, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vp9_loopfilter) != 2 {}
            return;
        }
    }
    COUNT_TO_UPDATE_FACTOR_in_vp9_loopfilter =
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
    SUB_PEL_FILTERS_12_in_vp9_loopfilter =
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
    LEFT_64X64_TXFORM_MASK =
        u64.[ cast(u64) 0xffffffffffffffff, cast(u64) 0xffffffffffffffff, 0x5555555555555555, 0x1111111111111111 ];
    ABOVE_64X64_TXFORM_MASK =
        u64.[ cast(u64) 0xffffffffffffffff, cast(u64) 0xffffffffffffffff, 0xff00ff00ff00ff, 0xff000000ff ];
    LEFT_PREDICTION_MASK =
        u64.[
            0x1,
            0x1,
            0x1,
            0x1,
            0x101,
            0x1,
            0x101,
            0x1010101,
            0x101,
            0x1010101,
            0x101010101010101,
            0x1010101,
            0x101010101010101
        ];
    ABOVE_PREDICTION_MASK =
        u64.[
            0x1,
            0x1,
            0x1,
            0x1,
            0x1,
            0x3,
            0x3,
            0x3,
            0xf,
            0xf,
            0xf,
            0xff,
            0xff
        ];
    SIZE_MASK =
        u64.[
            0x1,
            0x1,
            0x1,
            0x1,
            0x101,
            0x3,
            0x303,
            0x3030303,
            0xf0f,
            0xf0f0f0f,
            0xf0f0f0f0f0f0f0f,
            0xffffffff,
            cast(u64) 0xffffffffffffffff
        ];
    LEFT_BORDER = 0x1111111111111111;
    ABOVE_BORDER = 0xff000000ff;
    LEFT_64X64_TXFORM_MASK_UV = u16.[ 0xffff, 0xffff, 0x5555, 0x1111 ];
    ABOVE_64X64_TXFORM_MASK_UV = u16.[ 0xffff, 0xffff, 0xf0f, 0xf ];
    LEFT_PREDICTION_MASK_UV =
        u16.[
            0x1,
            0x1,
            0x1,
            0x1,
            0x1,
            0x1,
            0x1,
            0x11,
            0x1,
            0x11,
            0x1111,
            0x11,
            0x1111
        ];
    ABOVE_PREDICTION_MASK_UV =
        u16.[
            0x1,
            0x1,
            0x1,
            0x1,
            0x1,
            0x1,
            0x1,
            0x1,
            0x3,
            0x3,
            0x3,
            0xf,
            0xf
        ];
    SIZE_MASK_UV =
        u16.[
            0x1,
            0x1,
            0x1,
            0x1,
            0x1,
            0x1,
            0x1,
            0x11,
            0x3,
            0x33,
            0x3333,
            0xff,
            0xffff
        ];
    LEFT_BORDER_UV = 0x1111;
    ABOVE_BORDER_UV = 0xf;
    MODE_LF_LUT =
        s32.[
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            1,
            1,
            0,
            1
        ];
    FIRST_BLOCK_IN_16X16 =
        [8] u8.[
            u8.[ 1, 0, 1, 0, 1, 0, 1, 0 ],
            u8.[ 0, 0, 0, 0, 0, 0, 0, 0 ],
            u8.[ 1, 0, 1, 0, 1, 0, 1, 0 ],
            u8.[ 0, 0, 0, 0, 0, 0, 0, 0 ],
            u8.[ 1, 0, 1, 0, 1, 0, 1, 0 ],
            u8.[ 0, 0, 0, 0, 0, 0, 0, 0 ],
            u8.[ 1, 0, 1, 0, 1, 0, 1, 0 ],
            u8.[ 0, 0, 0, 0, 0, 0, 0, 0 ]
        ];
    atomic_store(*globals_initialization_state_for_vp9_loopfilter, 2);
}

Lf_Path :: u32;
LF_PATH_420 : s32 : 0;
LF_PATH_444 : s32 : 1;
LF_PATH_SLOW : s32 : 2;

LF_Worker_Data :: Loop_Filter_Worker_Data;

Loop_Filter_Worker_Data :: struct {
    frame_buffer: *YV12_BUFFER_CONFIG;
    cm: *VP9_Common_in_vp9_onyxc_int;
    planes: [3] Macroblockd_Plane;
    start: s32;
    stop: s32;
    y_only: s32;
}

