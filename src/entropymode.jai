// Generated directly from C by cpp_transpiler.
VP8_MBSPLITS: [4] Vp8_Mbsplit;

VP8_MBSPLIT_COUNT: [4] s32;

VP8_MBSPLIT_PROBS: [3] Vp8_Prob;

VP8_SUB_MV_REF_PROB2: [5] [3] Vp8_Prob;

VP8_BMODE_TREE: [18] Vp8_Tree_Index;

VP8_YMODE_TREE: [8] Vp8_Tree_Index;

VP8_KF_YMODE_TREE: [8] Vp8_Tree_Index;

VP8_UV_MODE_TREE: [6] Vp8_Tree_Index;

VP8_MBSPLIT_TREE: [6] Vp8_Tree_Index;

VP8_MV_REF_TREE: [8] Vp8_Tree_Index;

VP8_SUB_MV_REF_TREE: [6] Vp8_Tree_Index;

VP8_BMODE_ENCODINGS: [10] Vp8_Token_Struct;

VP8_YMODE_ENCODINGS: [5] Vp8_Token_Struct;

VP8_KF_YMODE_ENCODINGS: [5] Vp8_Token_Struct;

VP8_UV_MODE_ENCODINGS: [4] Vp8_Token_Struct;

VP8_MBSPLIT_ENCODINGS: [4] Vp8_Token_Struct;

VP8_MV_REF_ENCODING_ARRAY: [5] Vp8_Token_Struct;

VP8_SUB_MV_REF_ENCODING_ARRAY: [4] Vp8_Token_Struct;

VP8_SMALL_MVTREE: [14] Vp8_Tree_Index;

VP8_SMALL_MVENCODINGS: [8] Vp8_Token_Struct;

VP8_KF_BMODE_PROB: [10] [10] [9] Vp8_Prob;

VP8_KF_UV_MODE_PROB: [3] Vp8_Prob;

VP8_KF_YMODE_PROB: [4] Vp8_Prob;

SUB_MV_REF_PROB: [3] Vp8_Prob;

VP8_UV_MODE_PROB: [3] Vp8_Prob;

VP8_YMODE_PROB: [4] Vp8_Prob;

VP8_BMODE_PROB: [9] Vp8_Prob;

vp8_mv_cont :: (l: *Int_Mv_in_mv, a: *Int_Mv_in_mv) -> s32 {
    lez := cast(s32) (l.as_int == 0);
    aez := cast(s32) (a.as_int == 0);
    lea := cast(s32) (l.as_int == a.as_int);

    if lea != 0 && lez != 0 {
        return SUBMVREF_LEFT_ABOVE_ZED;
    }

    if lea != 0 {
        return SUBMVREF_LEFT_ABOVE_SAME;
    }

    if aez != 0 {
        return SUBMVREF_ABOVE_ZED;
    }

    if lez != 0 {
        return SUBMVREF_LEFT_ZED;
    }

    return SUBMVREF_NORMAL;
}

vp8_init_mbmode_probs :: (x: *VP8_COMMON) {
    copy_memory(x.fc.ymode_prob.data, VP8_YMODE_PROB.data, VP8_YMODE_PROB.count);
    copy_memory(x.fc.uv_mode_prob.data, VP8_UV_MODE_PROB.data, VP8_UV_MODE_PROB.count);
    copy_memory(x.fc.sub_mv_ref_prob.data, SUB_MV_REF_PROB.data, SUB_MV_REF_PROB.count);
}

vp8_default_bmode_probs :: (dest: *Vp8_Prob) {
    copy_memory(dest, VP8_BMODE_PROB.data, VP8_BMODE_PROB.count);
}

globals_initialization_state_for_entropymode: u32;
initialize_globals_for_entropymode :: () {
    {
        state := atomic_load(*globals_initialization_state_for_entropymode);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_entropymode, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_entropymode) != 2 {}
            return;
        }
    }
    VP8_BMODE_ENCODINGS =
        Vp8_Token_Struct.[
            Vp8_Token_Struct.{value = 0, len = 1},
            Vp8_Token_Struct.{value = 2, len = 2},
            Vp8_Token_Struct.{value = 6, len = 3},
            Vp8_Token_Struct.{value = 28, len = 5},
            Vp8_Token_Struct.{value = 30, len = 5},
            Vp8_Token_Struct.{value = 58, len = 6},
            Vp8_Token_Struct.{value = 59, len = 6},
            Vp8_Token_Struct.{value = 62, len = 6},
            Vp8_Token_Struct.{value = 126, len = 7},
            Vp8_Token_Struct.{value = 127, len = 7}
        ];
    VP8_YMODE_ENCODINGS =
        Vp8_Token_Struct.[
            Vp8_Token_Struct.{value = 0, len = 1},
            Vp8_Token_Struct.{value = 4, len = 3},
            Vp8_Token_Struct.{value = 5, len = 3},
            Vp8_Token_Struct.{value = 6, len = 3},
            Vp8_Token_Struct.{value = 7, len = 3}
        ];
    VP8_KF_YMODE_ENCODINGS =
        Vp8_Token_Struct.[
            Vp8_Token_Struct.{value = 4, len = 3},
            Vp8_Token_Struct.{value = 5, len = 3},
            Vp8_Token_Struct.{value = 6, len = 3},
            Vp8_Token_Struct.{value = 7, len = 3},
            Vp8_Token_Struct.{value = 0, len = 1}
        ];
    VP8_UV_MODE_ENCODINGS =
        Vp8_Token_Struct.[
            Vp8_Token_Struct.{value = 0, len = 1},
            Vp8_Token_Struct.{value = 2, len = 2},
            Vp8_Token_Struct.{value = 6, len = 3},
            Vp8_Token_Struct.{value = 7, len = 3}
        ];
    VP8_MBSPLIT_ENCODINGS =
        Vp8_Token_Struct.[
            Vp8_Token_Struct.{value = 6, len = 3},
            Vp8_Token_Struct.{value = 7, len = 3},
            Vp8_Token_Struct.{value = 2, len = 2},
            Vp8_Token_Struct.{value = 0, len = 1}
        ];
    VP8_MV_REF_ENCODING_ARRAY =
        Vp8_Token_Struct.[
            Vp8_Token_Struct.{value = 2, len = 2},
            Vp8_Token_Struct.{value = 6, len = 3},
            Vp8_Token_Struct.{value = 0, len = 1},
            Vp8_Token_Struct.{value = 14, len = 4},
            Vp8_Token_Struct.{value = 15, len = 4}
        ];
    VP8_SUB_MV_REF_ENCODING_ARRAY =
        Vp8_Token_Struct.[
            Vp8_Token_Struct.{value = 0, len = 1},
            Vp8_Token_Struct.{value = 2, len = 2},
            Vp8_Token_Struct.{value = 6, len = 3},
            Vp8_Token_Struct.{value = 7, len = 3}
        ];
    VP8_SMALL_MVENCODINGS =
        Vp8_Token_Struct.[
            Vp8_Token_Struct.{value = 0, len = 3},
            Vp8_Token_Struct.{value = 1, len = 3},
            Vp8_Token_Struct.{value = 2, len = 3},
            Vp8_Token_Struct.{value = 3, len = 3},
            Vp8_Token_Struct.{value = 4, len = 3},
            Vp8_Token_Struct.{value = 5, len = 3},
            Vp8_Token_Struct.{value = 6, len = 3},
            Vp8_Token_Struct.{value = 7, len = 3}
        ];
    VP8_YMODE_PROB = Vp8_Prob.[ 112, 86, 140, 37 ];
    VP8_KF_YMODE_PROB = Vp8_Prob.[ 145, 156, 163, 128 ];
    VP8_UV_MODE_PROB = Vp8_Prob.[ 162, 101, 204 ];
    VP8_KF_UV_MODE_PROB = Vp8_Prob.[ 142, 114, 183 ];
    VP8_BMODE_PROB =
        Vp8_Prob.[
            120,
            90,
            79,
            133,
            87,
            85,
            80,
            111,
            151
        ];
    VP8_KF_BMODE_PROB =
        [10] [9] Vp8_Prob.[
            [9] Vp8_Prob.[ Vp8_Prob.[ 231, 120, 48, 89, 115, 113, 120, 152, 112 ], Vp8_Prob.[ 152, 179, 64, 126, 170, 118, 46, 70, 95 ], Vp8_Prob.[ 175, 69, 143, 80, 85, 82, 72, 155, 103 ], Vp8_Prob.[ 56, 58, 10, 171, 218, 189, 17, 13, 152 ], Vp8_Prob.[ 144, 71, 10, 38, 171, 213, 144, 34, 26 ], Vp8_Prob.[ 114, 26, 17, 163, 44, 195, 21, 10, 173 ], Vp8_Prob.[ 121, 24, 80, 195, 26, 62, 44, 64, 85 ], Vp8_Prob.[ 170, 46, 55, 19, 136, 160, 33, 206, 71 ], Vp8_Prob.[ 63, 20, 8, 114, 114, 208, 12, 9, 226 ], Vp8_Prob.[ 81, 40, 11, 96, 182, 84, 29, 16, 36 ] ],
            [9] Vp8_Prob.[ Vp8_Prob.[ 134, 183, 89, 137, 98, 101, 106, 165, 148 ], Vp8_Prob.[ 72, 187, 100, 130, 157, 111, 32, 75, 80 ], Vp8_Prob.[ 66, 102, 167, 99, 74, 62, 40, 234, 128 ], Vp8_Prob.[ 41, 53, 9, 178, 241, 141, 26, 8, 107 ], Vp8_Prob.[ 104, 79, 12, 27, 217, 255, 87, 17, 7 ], Vp8_Prob.[ 74, 43, 26, 146, 73, 166, 49, 23, 157 ], Vp8_Prob.[ 65, 38, 105, 160, 51, 52, 31, 115, 128 ], Vp8_Prob.[ 87, 68, 71, 44, 114, 51, 15, 186, 23 ], Vp8_Prob.[ 47, 41, 14, 110, 182, 183, 21, 17, 194 ], Vp8_Prob.[ 66, 45, 25, 102, 197, 189, 23, 18, 22 ] ],
            [9] Vp8_Prob.[ Vp8_Prob.[ 88, 88, 147, 150, 42, 46, 45, 196, 205 ], Vp8_Prob.[ 43, 97, 183, 117, 85, 38, 35, 179, 61 ], Vp8_Prob.[ 39, 53, 200, 87, 26, 21, 43, 232, 171 ], Vp8_Prob.[ 56, 34, 51, 104, 114, 102, 29, 93, 77 ], Vp8_Prob.[ 107, 54, 32, 26, 51, 1, 81, 43, 31 ], Vp8_Prob.[ 39, 28, 85, 171, 58, 165, 90, 98, 64 ], Vp8_Prob.[ 34, 22, 116, 206, 23, 34, 43, 166, 73 ], Vp8_Prob.[ 68, 25, 106, 22, 64, 171, 36, 225, 114 ], Vp8_Prob.[ 34, 19, 21, 102, 132, 188, 16, 76, 124 ], Vp8_Prob.[ 62, 18, 78, 95, 85, 57, 50, 48, 51 ] ],
            [9] Vp8_Prob.[ Vp8_Prob.[ 193, 101, 35, 159, 215, 111, 89, 46, 111 ], Vp8_Prob.[ 60, 148, 31, 172, 219, 228, 21, 18, 111 ], Vp8_Prob.[ 112, 113, 77, 85, 179, 255, 38, 120, 114 ], Vp8_Prob.[ 40, 42, 1, 196, 245, 209, 10, 25, 109 ], Vp8_Prob.[ 100, 80, 8, 43, 154, 1, 51, 26, 71 ], Vp8_Prob.[ 88, 43, 29, 140, 166, 213, 37, 43, 154 ], Vp8_Prob.[ 61, 63, 30, 155, 67, 45, 68, 1, 209 ], Vp8_Prob.[ 142, 78, 78, 16, 255, 128, 34, 197, 171 ], Vp8_Prob.[ 41, 40, 5, 102, 211, 183, 4, 1, 221 ], Vp8_Prob.[ 51, 50, 17, 168, 209, 192, 23, 25, 82 ] ],
            [9] Vp8_Prob.[ Vp8_Prob.[ 125, 98, 42, 88, 104, 85, 117, 175, 82 ], Vp8_Prob.[ 95, 84, 53, 89, 128, 100, 113, 101, 45 ], Vp8_Prob.[ 75, 79, 123, 47, 51, 128, 81, 171, 1 ], Vp8_Prob.[ 57, 17, 5, 71, 102, 57, 53, 41, 49 ], Vp8_Prob.[ 115, 21, 2, 10, 102, 255, 166, 23, 6 ], Vp8_Prob.[ 38, 33, 13, 121, 57, 73, 26, 1, 85 ], Vp8_Prob.[ 41, 10, 67, 138, 77, 110, 90, 47, 114 ], Vp8_Prob.[ 101, 29, 16, 10, 85, 128, 101, 196, 26 ], Vp8_Prob.[ 57, 18, 10, 102, 102, 213, 34, 20, 43 ], Vp8_Prob.[ 117, 20, 15, 36, 163, 128, 68, 1, 26 ] ],
            [9] Vp8_Prob.[ Vp8_Prob.[ 138, 31, 36, 171, 27, 166, 38, 44, 229 ], Vp8_Prob.[ 67, 87, 58, 169, 82, 115, 26, 59, 179 ], Vp8_Prob.[ 63, 59, 90, 180, 59, 166, 93, 73, 154 ], Vp8_Prob.[ 40, 40, 21, 116, 143, 209, 34, 39, 175 ], Vp8_Prob.[ 57, 46, 22, 24, 128, 1, 54, 17, 37 ], Vp8_Prob.[ 47, 15, 16, 183, 34, 223, 49, 45, 183 ], Vp8_Prob.[ 46, 17, 33, 183, 6, 98, 15, 32, 183 ], Vp8_Prob.[ 65, 32, 73, 115, 28, 128, 23, 128, 205 ], Vp8_Prob.[ 40, 3, 9, 115, 51, 192, 18, 6, 223 ], Vp8_Prob.[ 87, 37, 9, 115, 59, 77, 64, 21, 47 ] ],
            [9] Vp8_Prob.[ Vp8_Prob.[ 104, 55, 44, 218, 9, 54, 53, 130, 226 ], Vp8_Prob.[ 64, 90, 70, 205, 40, 41, 23, 26, 57 ], Vp8_Prob.[ 54, 57, 112, 184, 5, 41, 38, 166, 213 ], Vp8_Prob.[ 30, 34, 26, 133, 152, 116, 10, 32, 134 ], Vp8_Prob.[ 75, 32, 12, 51, 192, 255, 160, 43, 51 ], Vp8_Prob.[ 39, 19, 53, 221, 26, 114, 32, 73, 255 ], Vp8_Prob.[ 31, 9, 65, 234, 2, 15, 1, 118, 73 ], Vp8_Prob.[ 88, 31, 35, 67, 102, 85, 55, 186, 85 ], Vp8_Prob.[ 56, 21, 23, 111, 59, 205, 45, 37, 192 ], Vp8_Prob.[ 55, 38, 70, 124, 73, 102, 1, 34, 98 ] ],
            [9] Vp8_Prob.[ Vp8_Prob.[ 102, 61, 71, 37, 34, 53, 31, 243, 192 ], Vp8_Prob.[ 69, 60, 71, 38, 73, 119, 28, 222, 37 ], Vp8_Prob.[ 68, 45, 128, 34, 1, 47, 11, 245, 171 ], Vp8_Prob.[ 62, 17, 19, 70, 146, 85, 55, 62, 70 ], Vp8_Prob.[ 75, 15, 9, 9, 64, 255, 184, 119, 16 ], Vp8_Prob.[ 37, 43, 37, 154, 100, 163, 85, 160, 1 ], Vp8_Prob.[ 63, 9, 92, 136, 28, 64, 32, 201, 85 ], Vp8_Prob.[ 86, 6, 28, 5, 64, 255, 25, 248, 1 ], Vp8_Prob.[ 56, 8, 17, 132, 137, 255, 55, 116, 128 ], Vp8_Prob.[ 58, 15, 20, 82, 135, 57, 26, 121, 40 ] ],
            [9] Vp8_Prob.[ Vp8_Prob.[ 164, 50, 31, 137, 154, 133, 25, 35, 218 ], Vp8_Prob.[ 51, 103, 44, 131, 131, 123, 31, 6, 158 ], Vp8_Prob.[ 86, 40, 64, 135, 148, 224, 45, 183, 128 ], Vp8_Prob.[ 22, 26, 17, 131, 240, 154, 14, 1, 209 ], Vp8_Prob.[ 83, 12, 13, 54, 192, 255, 68, 47, 28 ], Vp8_Prob.[ 45, 16, 21, 91, 64, 222, 7, 1, 197 ], Vp8_Prob.[ 56, 21, 39, 155, 60, 138, 23, 102, 213 ], Vp8_Prob.[ 85, 26, 85, 85, 128, 128, 32, 146, 171 ], Vp8_Prob.[ 18, 11, 7, 63, 144, 171, 4, 4, 246 ], Vp8_Prob.[ 35, 27, 10, 146, 174, 171, 12, 26, 128 ] ],
            [9] Vp8_Prob.[ Vp8_Prob.[ 190, 80, 35, 99, 180, 80, 126, 54, 45 ], Vp8_Prob.[ 85, 126, 47, 87, 176, 51, 41, 20, 32 ], Vp8_Prob.[ 101, 75, 128, 139, 118, 146, 116, 128, 85 ], Vp8_Prob.[ 56, 41, 15, 176, 236, 85, 37, 9, 62 ], Vp8_Prob.[ 146, 36, 19, 30, 171, 255, 97, 27, 20 ], Vp8_Prob.[ 71, 30, 17, 119, 118, 255, 17, 18, 138 ], Vp8_Prob.[ 101, 38, 60, 138, 55, 70, 43, 26, 142 ], Vp8_Prob.[ 138, 45, 61, 62, 219, 1, 81, 188, 64 ], Vp8_Prob.[ 32, 41, 20, 117, 151, 142, 20, 21, 163 ], Vp8_Prob.[ 112, 19, 12, 61, 195, 128, 48, 4, 24 ] ]
        ];
    SUB_MV_REF_PROB = Vp8_Prob.[ 180, 162, 25 ];
    VP8_SUB_MV_REF_PROB2 =
        [3] Vp8_Prob.[
            Vp8_Prob.[ 147, 136, 18 ],
            Vp8_Prob.[ 106, 145, 1 ],
            Vp8_Prob.[ 179, 121, 1 ],
            Vp8_Prob.[ 223, 1, 34 ],
            Vp8_Prob.[ 208, 1, 1 ]
        ];
    VP8_MBSPLITS =
        Vp8_Mbsplit.[
            s32.[ 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1 ],
            s32.[ 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1 ],
            s32.[ 0, 0, 1, 1, 0, 0, 1, 1, 2, 2, 3, 3, 2, 2, 3, 3 ],
            s32.[ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]
        ];
    VP8_MBSPLIT_COUNT = s32.[ 2, 2, 4, 16 ];
    VP8_MBSPLIT_PROBS = Vp8_Prob.[ 110, 111, 150 ];
    VP8_BMODE_TREE =
        Vp8_Tree_Index.[
            cast,no_check(Vp8_Tree_Index) (-B_DC_PRED),
            2,
            cast,no_check(Vp8_Tree_Index) (-B_TM_PRED),
            4,
            cast,no_check(Vp8_Tree_Index) (-B_VE_PRED),
            6,
            8,
            12,
            cast,no_check(Vp8_Tree_Index) (-B_HE_PRED),
            10,
            cast,no_check(Vp8_Tree_Index) (-B_RD_PRED),
            cast,no_check(Vp8_Tree_Index) (-B_VR_PRED),
            cast,no_check(Vp8_Tree_Index) (-B_LD_PRED),
            14,
            cast,no_check(Vp8_Tree_Index) (-B_VL_PRED),
            16,
            cast,no_check(Vp8_Tree_Index) (-B_HD_PRED),
            cast,no_check(Vp8_Tree_Index) (-B_HU_PRED)
        ];
    VP8_YMODE_TREE =
        Vp8_Tree_Index.[
            cast,no_check(Vp8_Tree_Index) (-DC_PRED),
            2,
            4,
            6,
            cast,no_check(Vp8_Tree_Index) (-V_PRED),
            cast,no_check(Vp8_Tree_Index) (-H_PRED),
            cast,no_check(Vp8_Tree_Index) (-TM_PRED),
            cast,no_check(Vp8_Tree_Index) (-B_PRED)
        ];
    VP8_KF_YMODE_TREE =
        Vp8_Tree_Index.[
            cast,no_check(Vp8_Tree_Index) (-B_PRED),
            2,
            4,
            6,
            cast,no_check(Vp8_Tree_Index) (-DC_PRED),
            cast,no_check(Vp8_Tree_Index) (-V_PRED),
            cast,no_check(Vp8_Tree_Index) (-H_PRED),
            cast,no_check(Vp8_Tree_Index) (-TM_PRED)
        ];
    VP8_UV_MODE_TREE =
        Vp8_Tree_Index.[
            cast,no_check(Vp8_Tree_Index) (-DC_PRED),
            2,
            cast,no_check(Vp8_Tree_Index) (-V_PRED),
            4,
            cast,no_check(Vp8_Tree_Index) (-H_PRED),
            cast,no_check(Vp8_Tree_Index) (-TM_PRED)
        ];
    VP8_MBSPLIT_TREE =
        Vp8_Tree_Index.[
            -3,
            2,
            -2,
            4,
            -0,
            -1
        ];
    VP8_MV_REF_TREE =
        Vp8_Tree_Index.[
            cast,no_check(Vp8_Tree_Index) (-ZEROMV),
            2,
            cast,no_check(Vp8_Tree_Index) (-NEARESTMV),
            4,
            cast,no_check(Vp8_Tree_Index) (-NEARMV),
            6,
            cast,no_check(Vp8_Tree_Index) (-NEWMV),
            cast,no_check(Vp8_Tree_Index) (-SPLITMV)
        ];
    VP8_SUB_MV_REF_TREE =
        Vp8_Tree_Index.[
            cast,no_check(Vp8_Tree_Index) (-LEFT4X4),
            2,
            cast,no_check(Vp8_Tree_Index) (-ABOVE4X4),
            4,
            cast,no_check(Vp8_Tree_Index) (-ZERO4X4),
            cast,no_check(Vp8_Tree_Index) (-NEW4X4)
        ];
    VP8_SMALL_MVTREE =
        Vp8_Tree_Index.[
            2,
            8,
            4,
            6,
            -0,
            -1,
            -2,
            -3,
            10,
            12,
            -4,
            -5,
            -6,
            -7
        ];
    atomic_store(*globals_initialization_state_for_entropymode, 2);
}

Vp8_Mbsplit :: [16] s32;

Sumvfref_T :: u32;
SUBMVREF_NORMAL : s32 : 0;
SUBMVREF_LEFT_ZED : s32 : 1;
SUBMVREF_ABOVE_ZED : s32 : 2;
SUBMVREF_LEFT_ABOVE_SAME : s32 : 3;
SUBMVREF_LEFT_ABOVE_ZED : s32 : 4;

