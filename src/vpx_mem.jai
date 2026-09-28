// Generated directly from C by cpp_transpiler.
memalign :: (align: u64, size: u64) -> *void {
    x: *void = null;
    ALIGNED_SIZE := get_aligned_malloc_size(size, align);
    if check_size_argument_overflow(1, ALIGNED_SIZE) == 0 {
        return null;
    }

    addr := c_transpiler_allocate_memory(ALIGNED_SIZE);
    if addr != null {
        x =
            cast,no_check(*void) (((cast,no_check(u64) ((cast(*u8) addr) + cast(u64) size_of(u64))) +
                (align - 1)) & ~(align - 1));
        set_actual_malloc_address(x, addr);
    }
    return x;
}

set_actual_malloc_address :: (MEM: *void, MALLOC_ADDR: *void) {
    MALLOC_ADDR_LOCATION := get_malloc_address_location(MEM);
    MALLOC_ADDR_LOCATION.* = cast,no_check(u64) MALLOC_ADDR;
}

get_malloc_address_location :: (MEM: *void) -> *u64 {
    return (cast(*u64) MEM) - 1;
}

get_malloc_address_location :: (MEM: *$Value) -> *u64 {
    return get_malloc_address_location(cast(*void) MEM);
}

get_aligned_malloc_size :: (size: u64, align: u64) -> u64 {
    return (size + align - 1) + size_of(u64);
}

check_size_argument_overflow :: (nmemb: u64, size: u64) -> s32 {
    TOTAL_SIZE := nmemb * size;
    if nmemb == 0 {
        return 1;
    }
    if size > (cast(u64) 1) << 40 / nmemb {
        return 0;
    }
    if TOTAL_SIZE != TOTAL_SIZE {
        return 0;
    }

    return 1;
}

allocate_memory :: (size: u64) -> *void {
    return memalign((cast,no_check(u64) (2)) * size_of(*void), size);
}

calloc_2 :: (num: u64, size: u64) -> *void {
    if check_size_argument_overflow(num, size) == 0 {
        return null;
    }

    x := allocate_memory(num * size);
    if x != null {
        fill_memory(x, 0, num * size);
    }
    return x;
}

deallocate_memory :: (memblk: *void) {
    if memblk != null {
        addr := get_actual_malloc_address(memblk);
        c_transpiler_deallocate_memory(addr);
    }
}

get_actual_malloc_address :: (MEM: *void) -> *void {
    MALLOC_ADDR_LOCATION := get_malloc_address_location(MEM);
    return cast,no_check(*void) MALLOC_ADDR_LOCATION.*;
}

get_actual_malloc_address :: (MEM: *$Value) -> *void {
    return get_actual_malloc_address(cast(*void) MEM);
}

