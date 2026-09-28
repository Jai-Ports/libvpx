vp9_alloc_internal_frame_buffers :: (list: *Internal_Frame_Buffer_List) -> s32 {
    NUM_BUFFERS: s32 = cast,no_check(s32) ((8 + 8));

    vp9_free_internal_frame_buffers(list);

    list.int_fb =
        cast(*Internal_Frame_Buffer) calloc_2(
            cast,no_check(u64) NUM_BUFFERS,
            size_of(Internal_Frame_Buffer)
        );
    if list.int_fb != null {
        list.num_internal_frame_buffers = NUM_BUFFERS;
        return 0;
    }
    return -1;
}

vp9_free_internal_frame_buffers :: (list: *Internal_Frame_Buffer_List) {
    i: s32 = 0;
    while i < list.num_internal_frame_buffers {
        deallocate_memory(cast(*void) list.int_fb[i].data);
        list.int_fb[i].data = null;
        i += 1;
    }
    deallocate_memory(cast(*void) list.int_fb);
    list.int_fb = null;
    list.num_internal_frame_buffers = 0;
}

vp9_get_frame_buffer :: (cb_priv: *void, min_size: u64, fb: *Codec_Frame_Buffer_T) -> s32 {
    INT_FB_LIST := cast(*Internal_Frame_Buffer_List) cb_priv;
    if INT_FB_LIST == null {
        return -1;
    }

    i: s32 = 0;
    while i < INT_FB_LIST.num_internal_frame_buffers {
        if INT_FB_LIST.int_fb[i].in_use == 0 {
            break;
        }
        i += 1;
    }

    if i == INT_FB_LIST.num_internal_frame_buffers {
        return -1;
    }

    if INT_FB_LIST.int_fb[i].size < min_size {
        deallocate_memory(cast(*void) INT_FB_LIST.int_fb[i].data);

        INT_FB_LIST.int_fb[i].data = cast(*u8) calloc_2(1, min_size);
        if INT_FB_LIST.int_fb[i].data == null {
            return -1;
        }
        INT_FB_LIST.int_fb[i].size = min_size;
    }

    fb.data = INT_FB_LIST.int_fb[i].data;
    fb.size = INT_FB_LIST.int_fb[i].size;
    INT_FB_LIST.int_fb[i].in_use = 1;

    fb.priv = cast(*void) (*INT_FB_LIST.int_fb[i]);
    return 0;
}

vp9_release_frame_buffer :: (cb_priv: *void, fb: *Codec_Frame_Buffer_T) -> s32 {
    INT_FB := cast(*Internal_Frame_Buffer) fb.priv;

    if INT_FB != null {
        INT_FB.in_use = 0;
    }
    return 0;
}

