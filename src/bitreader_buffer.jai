rb_bytes_read :: (rb: *Read_Bit_Buffer) -> u64 {
    return (rb.bit_offset + 7) >> 3;
}

rb_read_bit :: (rb: *Read_Bit_Buffer) -> s32 {
    OFF := rb.bit_offset;
    P := OFF >> 3;
    Q := 7 - cast,no_check(s32) (OFF & 0x7);
    if rb.bit_buffer + P < rb.bit_buffer_end {
        BIT := (cast(s32) rb.bit_buffer[P]) >> ((Q) & 31) & 1;
        rb.bit_offset = OFF + 1;
        return BIT;
    } else {
        if rb.error_handler != null {
            rb.error_handler(rb.error_handler_data);
        }
        return 0;
    }
}

rb_read_literal :: (rb: *Read_Bit_Buffer, bits: s32) -> s32 {
    value: s32 = 0;
    bit := bits - 1;
    while bit >= 0 {
        value |= rb_read_bit(rb) << ((bit) & 31);
        bit -= 1;
    }
    return value;
}

rb_read_signed_literal :: (rb: *Read_Bit_Buffer, bits: s32) -> s32 {
    VALUE := rb_read_literal(rb, bits);
    return ifx rb_read_bit(rb) != 0 then -VALUE else VALUE;
}

rb_read_inv_signed_literal :: (rb: *Read_Bit_Buffer, bits: s32) -> s32 {
    return rb_read_signed_literal(rb, bits);
}

Read_Bit_Buffer :: struct {
    bit_buffer: *u8;
    bit_buffer_end: *u8;
    bit_offset: u64;
    error_handler_data: *void;
    error_handler: Rb_Error_Handler;
}

Rb_Error_Handler :: #type (_: *void);

