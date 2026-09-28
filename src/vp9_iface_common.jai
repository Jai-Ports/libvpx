codec_control_vp8_set_reference_in_vp9_iface_common :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Ref_Frame_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_copy_reference_in_vp9_iface_common :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Ref_Frame_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp8_set_postproc_in_vp9_iface_common :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Vp8_Postproc_Cfg_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

codec_control_vp9_get_reference_in_vp9_iface_common :: (
    ctx: *Codec_Ctx_T,
    ctrl_id: s32,
    data: *Vp9_Ref_Frame_T
) -> Codec_Err_T {
    return codec_control(ctx, ctrl_id, data);
}

yuvconfig2image_2 :: (img: *Image_T, yv12: *YV12_BUFFER_CONFIG, user_priv: *void) {
    bps: s32 = ---;
    if yv12.subsampling_y == 0 {
        if yv12.subsampling_x == 0 {
            img.fmt = cast,no_check(Img_Fmt_T) IMG_FMT_I444;
            bps = 24;
        } else {
            img.fmt = cast,no_check(Img_Fmt_T) IMG_FMT_I422;
            bps = 16;
        }
    } else if yv12.subsampling_x == 0 {
        img.fmt = cast,no_check(Img_Fmt_T) IMG_FMT_I440;
        bps = 16;
    } else {
        img.fmt = cast,no_check(Img_Fmt_T) IMG_FMT_I420;
        bps = 12;
    }
    img.cs = yv12.color_space;
    img.range = yv12.color_range;
    img.bit_depth = 8;
    img.w = cast,no_check(u32) yv12.y_width;
    img.h = cast,no_check(u32) yv12.y_height;
    img.d_w = cast,no_check(u32) yv12.y_crop_width;
    img.d_h = cast,no_check(u32) yv12.y_crop_height;
    img.r_w = cast,no_check(u32) yv12.render_width;
    img.r_h = cast,no_check(u32) yv12.render_height;
    img.x_chroma_shift = cast,no_check(u32) yv12.subsampling_x;
    img.y_chroma_shift = cast,no_check(u32) yv12.subsampling_y;
    img.planes[0] = yv12.y_buffer;
    img.planes[1] = yv12.u_buffer;
    img.planes[2] = yv12.v_buffer;
    img.planes[3] = null;
    img.stride[0] = yv12.y_stride;
    img.stride[1] = yv12.uv_stride;
    img.stride[2] = yv12.uv_stride;
    img.stride[3] = yv12.y_stride;

    img.bps = bps;
    img.user_priv = user_priv;
    img.img_data = yv12.buffer_alloc;
    img.img_data_owner = 0;
    img.self_allocd = 0;
}

image2yuvconfig_2 :: (img: *Image_T, yv12: *YV12_BUFFER_CONFIG) -> Codec_Err_T {
    yv12.y_buffer = img.planes[0];
    yv12.u_buffer = img.planes[1];
    yv12.v_buffer = img.planes[2];

    yv12.y_crop_width = cast,no_check(s32) img.d_w;
    yv12.y_crop_height = cast,no_check(s32) img.d_h;
    yv12.render_width = cast,no_check(s32) img.r_w;
    yv12.render_height = cast,no_check(s32) img.r_h;
    yv12.y_width = cast,no_check(s32) img.w;
    yv12.y_height = cast,no_check(s32) img.h;

    yv12.uv_width =
        cast,no_check(s32) (((cast,no_check(u32) yv12.y_width) +
            img.x_chroma_shift) >> ((img.x_chroma_shift) & 31));
    yv12.uv_height =
        cast,no_check(s32) (((cast,no_check(u32) yv12.y_height) +
            img.y_chroma_shift) >> ((img.y_chroma_shift) & 31));
    yv12.uv_crop_width =
        cast,no_check(s32) (((cast,no_check(u32) yv12.y_crop_width) +
            img.x_chroma_shift) >> ((img.x_chroma_shift) & 31));
    yv12.uv_crop_height =
        cast,no_check(s32) (((cast,no_check(u32) yv12.y_crop_height) +
            img.y_chroma_shift) >> ((img.y_chroma_shift) & 31));

    yv12.y_stride = img.stride[0];

    yv12.uv_stride = img.stride[1];
    yv12.color_space = img.cs;
    yv12.color_range = img.range;

    yv12.border = cast,no_check(s32) (((cast,no_check(u32) img.stride[0]) - img.w) / 2);

    yv12.subsampling_x = cast,no_check(s32) img.x_chroma_shift;
    yv12.subsampling_y = cast,no_check(s32) img.y_chroma_shift;
    return cast,no_check(Codec_Err_T) CODEC_OK;
}

ref_frame_to_vp9_reframe :: (frame: Ref_Frame_Type_T) -> VP9_REFFRAME {
    if frame == {
        case cast,no_check(u32) VP8_LAST_FRAME;
            return cast,no_check(VP9_REFFRAME) VP9_LAST_FLAG;
        case cast,no_check(u32) VP8_GOLD_FRAME;
            return cast,no_check(VP9_REFFRAME) VP9_GOLD_FLAG;
        case cast,no_check(u32) VP8_ALTR_FRAME;
            return cast,no_check(VP9_REFFRAME) VP9_ALT_FLAG;
    }

    return cast,no_check(VP9_REFFRAME) VP9_LAST_FLAG;
}

VP9_REFFRAME :: u32;
VP9_LAST_FLAG : s32 : 1;
VP9_GOLD_FLAG : s32 : 2;
VP9_ALT_FLAG : s32 : 4;

