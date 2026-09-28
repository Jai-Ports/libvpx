// Generated directly from C by cpp_transpiler.
SKIN_THRESHOLD: [6] s32;

SKIN_MEAN: [5] [2] s32;

SKIN_INV_COV: [4] s32;

Y_HIGH: s32;

Y_LOW: s32;

skin_pixel :: (Y: s32, CB: s32, CR: s32, motion: s32) -> s32 {
    if Y < Y_LOW || Y > Y_HIGH {
        return 0;
    } else if 1 == 0 {
        if evaluate_skin_color_difference(CB, CR, 0) < SKIN_THRESHOLD[0] {
            return 1;
        }
        return 0;
    } else {
        i: s32 = 0;

        if CB == 128 && CR == 128 {
            return 0;
        }

        if CB > 150 && CR < 110 {
            return 0;
        }
        while i < 5 {
            skin_color_diff := evaluate_skin_color_difference(CB, CR, i);
            if skin_color_diff < SKIN_THRESHOLD[i + 1] {
                if Y < 60 && skin_color_diff > 3 * SKIN_THRESHOLD[i + 1] >> 2 {
                    return 0;
                } else if motion == 0 && skin_color_diff > SKIN_THRESHOLD[i + 1] >> 1 {
                    return 0;
                } else {
                    return 1;
                }
            }

            if skin_color_diff > SKIN_THRESHOLD[i + 1] << 3 {
                return 0;
            }
            i += 1;
        }
        return 0;
    }
}

evaluate_skin_color_difference :: (CB: s32, CR: s32, IDX: s32) -> s32 {
    CB_Q6 := CB << 6;
    CR_Q6 := CR << 6;
    CB_DIFF_Q12 := (CB_Q6 - SKIN_MEAN[IDX][0]) * (CB_Q6 - SKIN_MEAN[IDX][0]);
    CBCR_DIFF_Q12 := (CB_Q6 - SKIN_MEAN[IDX][0]) * (CR_Q6 - SKIN_MEAN[IDX][1]);
    CR_DIFF_Q12 := (CR_Q6 - SKIN_MEAN[IDX][1]) * (CR_Q6 - SKIN_MEAN[IDX][1]);
    CB_DIFF_Q2 := (CB_DIFF_Q12 + (cast(s32) 1) << 9) >> 10;
    CBCR_DIFF_Q2 := (CBCR_DIFF_Q12 + (cast(s32) 1) << 9) >> 10;
    CR_DIFF_Q2 := (CR_DIFF_Q12 + (cast(s32) 1) << 9) >> 10;
    SKIN_DIFF :=
        SKIN_INV_COV[0] * CB_DIFF_Q2 + SKIN_INV_COV[1] * CBCR_DIFF_Q2 +
            SKIN_INV_COV[2] * CBCR_DIFF_Q2 + SKIN_INV_COV[3] * CR_DIFF_Q2;
    return SKIN_DIFF;
}

globals_initialization_state_for_skin_detection: u32;
initialize_globals_for_skin_detection :: () {
    {
        state := atomic_load(*globals_initialization_state_for_skin_detection);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_skin_detection, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_skin_detection) != 2 {}
            return;
        }
    }
    SKIN_MEAN =
        [2] s32.[
            s32.[ 7463, 9614 ],
            s32.[ 6400, 10240 ],
            s32.[ 7040, 10240 ],
            s32.[ 8320, 9280 ],
            s32.[ 6800, 9614 ]
        ];
    SKIN_INV_COV = s32.[ 4107, 1663, 1663, 2157 ];
    SKIN_THRESHOLD =
        s32.[
            1570636,
            1400000,
            800000,
            800000,
            800000,
            800000
        ];
    Y_LOW = 40;
    Y_HIGH = 220;
    atomic_store(*globals_initialization_state_for_skin_detection, 2);
}

