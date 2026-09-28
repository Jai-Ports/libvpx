// Generated directly from C by cpp_transpiler.
vp8_tokens_from_tree :: (p: *Vp8_Token_Struct, t: *Vp8_Tree_Index) {
    tree2tok(p, t, 0, 0, 0);
}

tree2tok :: (P: *Vp8_Token_Struct, t: *Vp8_Tree_Index, i: s32, v: s32, l: s32) {
    v += v;
    l += 1;

    while true {
        {
            J := t[c_transpiler_post_increment(*(i))];

            if J <= 0 {
                P[-(cast,no_check(s32) J)].value = v;
                P[-(cast,no_check(s32) J)].len = l;
            } else {
                tree2tok(P, t, cast,no_check(s32) J, v, l);
            }
        }
        if c_transpiler_pre_increment(*(v)) & 1 == 0 break;
    }
}

vp8_tokens_from_tree_offset :: (p: *Vp8_Token_Struct, t: *Vp8_Tree_Index, offset: s32) {
    tree2tok(p - offset, t, 0, 0, 0);
}

vp8_tree_probs_from_distribution :: (
    n: s32,
    tok: *Vp8_Token,
    tree: *Vp8_Tree_Index,
    probs: *Vp8_Prob,
    branch_ct: *[2] u32,
    num_events: *u32,
    pfactor: u32,
    round: s32
) {
    TREE_LEN := n - 1;
    t: s32 = 0;

    branch_counts(n, tok, tree, branch_ct, num_events);

    while true {
        {
            C := branch_ct[t].data;
            TOT := C[0] + C[1];

            if TOT != 0 {
                P :=
                    (cast,no_check(u32) (((cast,no_check(u64) C[0]) * cast(u64) pfactor) + cast(u64) (ifx round != 0 then TOT >> 1 else 0))) /
                        TOT;
                probs[t] = cast,no_check(Vp8_Prob) ((ifx P < 256 then (ifx P != 0 then P else 1) else 255));
            } else {
                probs[t] = 128;
            }
        }
        if !(c_transpiler_pre_increment(*(t)) < TREE_LEN) break;
    }
}

branch_counts :: (n: s32, tok: *Vp8_Token, tree: *Vp8_Tree_Index, branch_ct: *[2] u32, num_events: *u32) {
    TREE_LEN := n - 1;
    t: s32 = 0;

    while true {
        branch_ct[t][1] = 0;
        branch_ct[t][0] = branch_ct[t][1];
        if !(c_transpiler_pre_increment(*(t)) < TREE_LEN) break;
    }

    t = 0;

    while true {
        {
            l := tok[t].len;
            ENC := tok[t].value;
            CT := num_events[t];

            i: Vp8_Tree_Index = 0;

            while true {
                {
                    B := ENC >> ((c_transpiler_pre_decrement(*(l))) & 31) & 1;
                    J := (cast(s32) i) >> 1;

                    branch_ct[J][B] += CT;
                    i = tree[(cast(s32) i) + B];
                }
                if !(i > 0) break;
            }
        }
        if !(c_transpiler_pre_increment(*(t)) < n) break;
    }
}

