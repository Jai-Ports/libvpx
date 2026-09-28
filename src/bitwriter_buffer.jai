// Generated directly from C by cpp_transpiler.
wb_init :: (wb: *Write_Bit_Buffer, bit_buffer: *u8, size: u64) {
    wb.error = 0;
    wb.bit_offset = 0;
    wb.size = size;
    wb.bit_buffer = bit_buffer;
}

wb_has_error :: (wb: *Write_Bit_Buffer) -> s32 {
    return wb.error;
}

wb_bytes_written :: (wb: *Write_Bit_Buffer) -> u64 {
    return (wb.bit_offset / 8) + cast(u64) ((wb.bit_offset % 8) > 0);
}

wb_write_bit :: (wb: *Write_Bit_Buffer, bit: s32) {
    if wb.error != 0 {
        return;
    }
    OFF := cast,no_check(s32) wb.bit_offset;
    P := OFF / 8;
    Q := (cast,no_check(s32) ((8 - 1))) - OFF % 8;
    if cast,no_check(u64) P >= wb.size {
        wb.error = 1;
        return;
    }
    if Q == 8 - 1 {
        wb.bit_buffer[P] = cast,no_check(u8) (bit << ((Q) & 31));
    } else {
        wb.bit_buffer[P] = cast,no_check(u8) ((cast,no_check(s32) wb.bit_buffer[P]) | (bit << ((Q) & 31)));
    }
    wb.bit_offset = cast,no_check(u64) (OFF + 1);
}

wb_write_literal :: (wb: *Write_Bit_Buffer, data: s32, bits: s32) {
    bit := bits - 1;
    while bit >= 0 {
        wb_write_bit(wb, data >> ((bit) & 31) & 1);
        bit -= 1;
    }
}

wb_write_inv_signed_literal :: (wb: *Write_Bit_Buffer, data: s32, bits: s32) {
    wb_write_literal(wb, absolute_value(data), bits);
    wb_write_bit(wb, cast(s32) (data < 0));
}

Write_Bit_Buffer :: struct {
    error: s32;
    bit_offset: u64;
    size: u64;
    bit_buffer: *u8;
}

