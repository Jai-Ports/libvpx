vp8_create_common :: (oci: *VP8_COMMON) {
    vp8_machine_specific_config(oci);

    vp8_init_mbmode_probs(oci);
    vp8_default_bmode_probs(oci.fc.bmode_prob.data);

    oci.mb_no_coeff_skip = 1;
    oci.no_lpf = 0;
    oci.filter_type = cast,no_check(LOOPFILTERTYPE) NORMAL_LOOPFILTER;
    oci.use_bilinear_mc_filter = 0;
    oci.full_pixel = 0;
    oci.multi_token_partition = cast,no_check(TOKEN_PARTITION) ONE_PARTITION;
    oci.clamp_type = cast,no_check(CLAMP_TYPE) RECON_CLAMP_REQUIRED;

    fill_memory(oci.ref_frame_sign_bias.data, 0, oci.ref_frame_sign_bias.count * size_of(s32));

    oci.copy_buffer_to_gf = 0;
    oci.copy_buffer_to_arf = 0;
}

vp8_remove_common :: (oci: *VP8_COMMON) {
    vp8_de_alloc_frame_buffers(oci);
}

vp8_de_alloc_frame_buffers :: (oci: *VP8_COMMON) {
    for i: 0..cast(s32) 4 - 1 {
        vp8_yv12_de_alloc_frame_buffer(oci.yv12_fb.data + i);
        oci.fb_idx_ref_cnt[i] = 0;
    }

    vp8_yv12_de_alloc_frame_buffer(*oci.temp_scale_frame);

    deallocate_memory(cast(*void) oci.above_context);
    deallocate_memory(cast(*void) oci.mip);

    oci.above_context = null;
    oci.mip = null;
    oci.mi = null;
    oci.show_frame_mi = null;
    oci.frame_to_show = null;
}

vp8_alloc_frame_buffers :: (oci: *VP8_COMMON, width: s32, height: s32) -> s32 {
    i: s32 = ---;
    vp8_de_alloc_frame_buffers(oci);
    if width & 0xf != 0 {
        width += 16 - width & 0xf;
    }
    if height & 0xf != 0 {
        height += 16 - height & 0xf;
    }
    while allocation_fail := true { // Forward-goto shim; executes at most once.
        i = 0;
        while i < 4 {
            if vp8_yv12_alloc_frame_buffer(oci.yv12_fb.data + i, width, height, 32) < 0 {
                break allocation_fail;
            }
            i += 1;
        }
        oci.new_fb_idx = 0;
        oci.lst_fb_idx = 1;
        oci.gld_fb_idx = 2;
        oci.alt_fb_idx = 3;
        oci.fb_idx_ref_cnt[0] = 1;
        oci.fb_idx_ref_cnt[1] = 1;
        oci.fb_idx_ref_cnt[2] = 1;
        oci.fb_idx_ref_cnt[3] = 1;
        if vp8_yv12_alloc_frame_buffer(*oci.temp_scale_frame, width, 16, 32) < 0 {
            break allocation_fail;
        }
        oci.mb_rows = height >> 4;
        oci.mb_cols = width >> 4;
        oci.m_bs = oci.mb_rows * oci.mb_cols;
        oci.mode_info_stride = oci.mb_cols + 1;
        oci.mip =
            cast(*MODE_INFO_in_blockd) calloc_2(
                cast,no_check(u64) ((oci.mb_cols + 1) * (oci.mb_rows + 1)),
                size_of(MODE_INFO_in_blockd)
            );
        if oci.mip == null {
            break allocation_fail;
        }
        oci.mi = oci.mip + oci.mode_info_stride + 1;
        oci.above_context =
            cast(*ENTROPY_CONTEXT_PLANES) calloc_2(
                size_of(ENTROPY_CONTEXT_PLANES) * cast,no_check(u64) oci.mb_cols,
                1
            );
        if oci.above_context == null {
            break allocation_fail;
        }
        return 0;
    }
    vp8_de_alloc_frame_buffers(oci);
    return 1;
}

vp8_setup_version :: (cm: *VP8_COMMON) {
    if cm.version == {
        case 0;
            cm.no_lpf = 0;
            cm.filter_type = cast,no_check(LOOPFILTERTYPE) NORMAL_LOOPFILTER;
            cm.use_bilinear_mc_filter = 0;
            cm.full_pixel = 0;
        case 1;
            cm.no_lpf = 0;
            cm.filter_type = cast,no_check(LOOPFILTERTYPE) SIMPLE_LOOPFILTER;
            cm.use_bilinear_mc_filter = 1;
            cm.full_pixel = 0;
        case 2;
            cm.no_lpf = 1;
            cm.filter_type = cast,no_check(LOOPFILTERTYPE) NORMAL_LOOPFILTER;
            cm.use_bilinear_mc_filter = 1;
            cm.full_pixel = 0;
        case 3;
            cm.no_lpf = 1;
            cm.filter_type = cast,no_check(LOOPFILTERTYPE) SIMPLE_LOOPFILTER;
            cm.use_bilinear_mc_filter = 1;
            cm.full_pixel = 1;
        case;
            cm.no_lpf = 0;
            cm.filter_type = cast,no_check(LOOPFILTERTYPE) NORMAL_LOOPFILTER;
            cm.use_bilinear_mc_filter = 0;
            cm.full_pixel = 0;
    }
}

mv_bias :: (refmb_ref_frame_sign_bias: s32, refframe: s32, mvp: *Int_Mv_in_mv, ref_frame_sign_bias: *s32) {
    if refmb_ref_frame_sign_bias != ref_frame_sign_bias[refframe] {
        mvp.as_mv.row = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.row) * -1);
        mvp.as_mv.col = cast,no_check(s16) ((cast,no_check(s32) mvp.as_mv.col) * -1);
    }
}

vp8_clamp_mv2 :: (mv: *Int_Mv_in_mv, xd: *MACROBLOCKD_in_blockd) {
    if cast,no_check(s32) mv.as_mv.col < xd.mb_to_left_edge - (cast(s32) 16) << 3 {
        mv.as_mv.col = cast,no_check(s16) (xd.mb_to_left_edge - (cast(s32) 16) << 3);
    } else if cast,no_check(s32) mv.as_mv.col > xd.mb_to_right_edge + (cast(s32) 16) << 3 {
        mv.as_mv.col = cast,no_check(s16) (xd.mb_to_right_edge + (cast(s32) 16) << 3);
    }

    if cast,no_check(s32) mv.as_mv.row < xd.mb_to_top_edge - (cast(s32) 16) << 3 {
        mv.as_mv.row = cast,no_check(s16) (xd.mb_to_top_edge - (cast(s32) 16) << 3);
    } else if cast,no_check(s32) mv.as_mv.row > xd.mb_to_bottom_edge + (cast(s32) 16) << 3 {
        mv.as_mv.row = cast,no_check(s16) (xd.mb_to_bottom_edge + (cast(s32) 16) << 3);
    }
}

vp8_clamp_mv :: (
    mv: *Int_Mv_in_mv,
    mb_to_left_edge: s32,
    mb_to_right_edge: s32,
    mb_to_top_edge: s32,
    mb_to_bottom_edge: s32
) {
    mv.as_mv.col =
        cast,no_check(s16) ((ifx cast,no_check(s32) mv.as_mv.col < mb_to_left_edge then mb_to_left_edge else cast,no_check(s32) mv.as_mv.col));
    mv.as_mv.col =
        cast,no_check(s16) ((ifx cast,no_check(s32) mv.as_mv.col > mb_to_right_edge then mb_to_right_edge else cast,no_check(s32) mv.as_mv.col));
    mv.as_mv.row =
        cast,no_check(s16) ((ifx cast,no_check(s32) mv.as_mv.row < mb_to_top_edge then mb_to_top_edge else cast,no_check(s32) mv.as_mv.row));
    mv.as_mv.row =
        cast,no_check(s16) ((ifx cast,no_check(s32) mv.as_mv.row > mb_to_bottom_edge then mb_to_bottom_edge else cast,no_check(s32) mv.as_mv.row));
}

vp8_check_mv_bounds :: (
    mv: *Int_Mv_in_mv,
    mb_to_left_edge: s32,
    mb_to_right_edge: s32,
    mb_to_top_edge: s32,
    mb_to_bottom_edge: s32
) -> u32 {
    need_to_clamp := cast(u32) (cast,no_check(s32) mv.as_mv.col < mb_to_left_edge);
    need_to_clamp |= cast(u32) (cast,no_check(s32) mv.as_mv.col > mb_to_right_edge);
    need_to_clamp |= cast(u32) (cast,no_check(s32) mv.as_mv.row < mb_to_top_edge);
    need_to_clamp |= cast(u32) (cast,no_check(s32) mv.as_mv.row > mb_to_bottom_edge);
    return need_to_clamp;
}

left_block_mv :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> u32 {
    if b & 3 == 0 {
        cur_mb -= 1;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 4;
    }

    return (((cur_mb.bmi.data + b - 1)).mv).as_int;
}

above_block_mv :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> u32 {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cur_mb.mbmi.mode != cast,no_check(u8) SPLITMV {
            return cur_mb.mbmi.mv.as_int;
        }
        b += 16;
    }

    return (((cur_mb.bmi.data + (b - 4))).mv).as_int;
}

left_block_mode :: (cur_mb: *MODE_INFO_in_blockd, b: s32) -> B_PREDICTION_MODE {
    if b & 3 == 0 {
        cur_mb -= 1;
        if cast,no_check(s32) cur_mb.mbmi.mode == {
            case B_PRED;
                return ((cur_mb.bmi.data + b + 3)).as_mode;
            case DC_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_DC_PRED;
            case V_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_VE_PRED;
            case H_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_HE_PRED;
            case TM_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_TM_PRED;
            case;
                return cast,no_check(B_PREDICTION_MODE) B_DC_PRED;
        }
    }

    return ((cur_mb.bmi.data + b - 1)).as_mode;
}

above_block_mode :: (cur_mb: *MODE_INFO_in_blockd, b: s32, mi_stride: s32) -> B_PREDICTION_MODE {
    if b >> 2 == 0 {
        cur_mb -= mi_stride;

        if cast,no_check(s32) cur_mb.mbmi.mode == {
            case B_PRED;
                return ((cur_mb.bmi.data + b + 12)).as_mode;
            case DC_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_DC_PRED;
            case V_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_VE_PRED;
            case H_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_HE_PRED;
            case TM_PRED;
                return cast,no_check(B_PREDICTION_MODE) B_TM_PRED;
            case;
                return cast,no_check(B_PREDICTION_MODE) B_DC_PRED;
        }
    }

    return ((cur_mb.bmi.data + b - 4)).as_mode;
}

VP8_COMMON :: VP8_Common;

VP8_Common :: struct {
    error: Internal_Error_Info #align 16;
    layout_padding_0: [8] u8 #align 1;
    y1dequant: [128] [2] s16 #align 1;
    y2dequant: [128] [2] s16 #align 1;
    u_vdequant: [128] [2] s16 #align 1;
    width: s32 #align 1;
    height: s32 #align 1;
    horiz_scale: s32 #align 1;
    vert_scale: s32 #align 1;
    clamp_type: CLAMP_TYPE #align 1;
    layout_padding_1: [4] u8 #align 1;
    frame_to_show: *YV12_BUFFER_CONFIG #align 1;
    yv12_fb: [4] YV12_BUFFER_CONFIG #align 1;
    fb_idx_ref_cnt: [4] s32 #align 1;
    new_fb_idx: s32 #align 1;
    lst_fb_idx: s32 #align 1;
    gld_fb_idx: s32 #align 1;
    alt_fb_idx: s32 #align 1;
    temp_scale_frame: YV12_BUFFER_CONFIG #align 1;
    last_frame_type: FRAME_TYPE_in_alloccommon #align 1;
    frame_type: FRAME_TYPE_in_alloccommon #align 1;
    show_frame: s32 #align 1;
    frame_flags: s32 #align 1;
    m_bs: s32 #align 1;
    mb_rows: s32 #align 1;
    mb_cols: s32 #align 1;
    mode_info_stride: s32 #align 1;
    mb_no_coeff_skip: s32 #align 1;
    no_lpf: s32 #align 1;
    use_bilinear_mc_filter: s32 #align 1;
    full_pixel: s32 #align 1;
    base_qindex: s32 #align 1;
    y1dc_delta_q: s32 #align 1;
    y2dc_delta_q: s32 #align 1;
    y2ac_delta_q: s32 #align 1;
    uvdc_delta_q: s32 #align 1;
    uvac_delta_q: s32 #align 1;
    mip: *MODE_INFO_in_blockd #align 1;
    mi: *MODE_INFO_in_blockd #align 1;
    show_frame_mi: *MODE_INFO_in_blockd #align 1;
    filter_type: LOOPFILTERTYPE #align 1;
    layout_padding_2: [12] u8 #align 1;
    lf_info: Loop_Filter_Info_N #align 1;
    filter_level: s32 #align 1;
    last_sharpness_level: s32 #align 1;
    sharpness_level: s32 #align 1;
    refresh_last_frame: s32 #align 1;
    refresh_golden_frame: s32 #align 1;
    refresh_alt_ref_frame: s32 #align 1;
    copy_buffer_to_gf: s32 #align 1;
    copy_buffer_to_arf: s32 #align 1;
    refresh_entropy_probs: s32 #align 1;
    ref_frame_sign_bias: [4] s32 #align 1;
    layout_padding_3: [4] u8 #align 1;
    above_context: *ENTROPY_CONTEXT_PLANES #align 1;
    left_context: ENTROPY_CONTEXT_PLANES #align 1;
    lfc: FRAME_CONTEXT_in_onyxc_int #align 1;
    fc: FRAME_CONTEXT_in_onyxc_int #align 1;
    layout_padding_4: [1] u8 #align 1;
    current_video_frame: u32 #align 1;
    version: s32 #align 1;
    multi_token_partition: TOKEN_PARTITION #align 1;
    processor_core_count: s32 #align 1;
    layout_padding_5: [4] u8 #align 1;
} #no_padding;

Vp8_Prob :: u8;

LOOPFILTERTYPE :: u32;
NORMAL_LOOPFILTER : s32 : 0;
SIMPLE_LOOPFILTER : s32 : 1;

TOKEN_PARTITION :: u32;
ONE_PARTITION : s32 : 0;
TWO_PARTITION : s32 : 1;
FOUR_PARTITION : s32 : 2;
EIGHT_PARTITION : s32 : 3;

CLAMP_TYPE :: u32;
RECON_CLAMP_REQUIRED : s32 : 0;
RECON_CLAMP_NOTREQUIRED : s32 : 1;

MODE_INFO_in_blockd :: Modeinfo;

MACROBLOCKD_in_blockd :: Macroblockd_in_blockd;

MB_PREDICTION_MODE :: u32;
DC_PRED : s32 : 0;
V_PRED : s32 : 1;
H_PRED : s32 : 2;
TM_PRED : s32 : 3;
B_PRED : s32 : 4;
NEARESTMV : s32 : 5;
NEARMV : s32 : 6;
ZEROMV : s32 : 7;
NEWMV : s32 : 8;
SPLITMV : s32 : 9;
MB_MODE_COUNT : s32 : 10;

B_PREDICTION_MODE :: u32;
B_DC_PRED : s32 : 0;
B_TM_PRED : s32 : 1;
B_VE_PRED : s32 : 2;
B_HE_PRED : s32 : 3;
B_LD_PRED : s32 : 4;
B_RD_PRED : s32 : 5;
B_VR_PRED : s32 : 6;
B_VL_PRED : s32 : 7;
B_HD_PRED : s32 : 8;
B_HU_PRED : s32 : 9;
LEFT4X4 : s32 : 10;
ABOVE4X4 : s32 : 11;
ZERO4X4 : s32 : 12;
NEW4X4 : s32 : 13;
B_MODE_COUNT : s32 : 14;

FRAME_CONTEXT_in_onyxc_int :: Frame_Contexts_in_onyxc_int;

ENTROPY_CONTEXT_PLANES :: struct {
    y1: [4] ENTROPY_CONTEXT;
    u: [2] ENTROPY_CONTEXT;
    v: [2] ENTROPY_CONTEXT;
    y2: ENTROPY_CONTEXT;
}

Modeinfo :: struct {
    mbmi: MB_MODE_INFO #align 4;
    bmi: [16] B_Mode_Info_in_blockd #align 1;
} #no_padding;

Int_Mv_in_mv :: union {
    as_int: u32;
    as_mv: MV_in_alloccommon;
}

Macroblockd_in_blockd :: struct {
    predictor: [384] u8 #align 16;
    qcoeff: [400] s16 #align 1;
    dqcoeff: [400] s16 #align 1;
    eobs: [25] s8 #align 1;
    layout_padding_0: [7] u8 #align 1;
    dequant_y1: [16] s16 #align 1;
    dequant_y1_dc: [16] s16 #align 1;
    dequant_y2: [16] s16 #align 1;
    dequant_uv: [16] s16 #align 1;
    block: [25] BLOCKD #align 1;
    fullpixel_mask: s32 #align 1;
    layout_padding_1: [4] u8 #align 1;
    pre: YV12_BUFFER_CONFIG #align 1;
    dst: YV12_BUFFER_CONFIG #align 1;
    mode_info_context: *MODE_INFO_in_blockd #align 1;
    mode_info_stride: s32 #align 1;
    frame_type: FRAME_TYPE_in_alloccommon #align 1;
    up_available: s32 #align 1;
    left_available: s32 #align 1;
    recon_above: [3] *u8 #align 1;
    recon_left: [3] *u8 #align 1;
    recon_left_stride: [2] s32 #align 1;
    above_context: *ENTROPY_CONTEXT_PLANES #align 1;
    left_context: *ENTROPY_CONTEXT_PLANES #align 1;
    segmentation_enabled: u8 #align 1;
    update_mb_segmentation_map: u8 #align 1;
    update_mb_segmentation_data: u8 #align 1;
    mb_segment_abs_delta: u8 #align 1;
    mb_segment_tree_probs: [3] Vp8_Prob #align 1;
    segment_feature_data: [2] [4] s8 #align 1;
    mode_ref_lf_delta_enabled: u8 #align 1;
    mode_ref_lf_delta_update: u8 #align 1;
    last_ref_lf_deltas: [4] s8 #align 1;
    ref_lf_deltas: [4] s8 #align 1;
    last_mode_lf_deltas: [4] s8 #align 1;
    mode_lf_deltas: [4] s8 #align 1;
    layout_padding_2: [3] u8 #align 1;
    mb_to_left_edge: s32 #align 1;
    mb_to_right_edge: s32 #align 1;
    mb_to_top_edge: s32 #align 1;
    mb_to_bottom_edge: s32 #align 1;
    layout_padding_3: [4] u8 #align 1;
    subpixel_predict: Vp8_Subpix_Fn_T #align 1;
    subpixel_predict8x4: Vp8_Subpix_Fn_T #align 1;
    subpixel_predict8x8: Vp8_Subpix_Fn_T #align 1;
    subpixel_predict16x16: Vp8_Subpix_Fn_T #align 1;
    current_bc: *void #align 1;
    corrupted: s32 #align 1;
    layout_padding_4: [4] u8 #align 1;
    error_info: Internal_Error_Info #align 1;
} #no_padding;

FRAME_TYPE_in_alloccommon :: u32;
KEY_FRAME_in_alloccommon : s32 : 0;
INTER_FRAME_in_alloccommon : s32 : 1;

Loop_Filter_Info_N :: struct {
    mblim: [64] [16] u8 #align 16;
    blim: [64] [16] u8 #align 1;
    lim: [64] [16] u8 #align 1;
    hev_thr: [4] [16] u8 #align 1;
    lvl: [4] [4] [4] u8 #align 1;
    hev_thr_lut: [2] [64] u8 #align 1;
    mode_lf_lut: [10] u8 #align 1;
    layout_padding_0: [6] u8 #align 1;
} #no_padding;

Frame_Contexts_in_onyxc_int :: struct {
    bmode_prob: [9] Vp8_Prob;
    ymode_prob: [4] Vp8_Prob;
    uv_mode_prob: [3] Vp8_Prob;
    sub_mv_ref_prob: [3] Vp8_Prob;
    coef_probs: [4] [8] [3] [11] Vp8_Prob;
    mvc: [2] MV_CONTEXT;
}

B_Mode_Info_in_blockd :: union {
    as_mode: B_PREDICTION_MODE;
    mv: Int_Mv_in_mv;
}

BLOCKD :: Blockd;

Vp8_Subpix_Fn_T :: #type (_: *u8, _: s32, _: s32, _: s32, _: *u8, _: s32);

MV_CONTEXT :: Mv_Context;

MB_MODE_INFO :: struct {
    mode: u8 #align 4;
    uv_mode: u8 #align 1;
    ref_frame: u8 #align 1;
    is_4x4: u8 #align 1;
    mv: Int_Mv_in_mv #align 1;
    partitioning: u8 #align 1;
    mb_skip_coeff: u8 #align 1;
    need_to_clamp_mvs: u8 #align 1;
    segment_id: u8 #align 1;
} #no_padding;

MV_in_alloccommon :: struct {
    row: s16;
    col: s16;
}

Blockd :: struct {
    qcoeff: *s16 #align 8;
    dqcoeff: *s16 #align 1;
    predictor: *u8 #align 1;
    dequant: *s16 #align 1;
    offset: s32 #align 1;
    layout_padding_0: [4] u8 #align 1;
    eob: *s8 #align 1;
    bmi: B_Mode_Info_in_blockd #align 1;
    layout_padding_1: [4] u8 #align 1;
} #no_padding;

Mv_Context :: struct {
    prob: [19] Vp8_Prob;
}

