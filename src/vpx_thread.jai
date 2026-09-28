Worker_Impl :: struct {
    mutex: Pthread_Mutex_T #align 8;
    condition: Pthread_Cond_T #align 1;
    thread: Pthread_T #align 1;
} #no_padding;

g_worker_interface: Worker_Interface;

set_worker_interface :: (WINTERFACE: *Worker_Interface) -> s32 {
    if WINTERFACE == null ||
        WINTERFACE.init == null ||
        WINTERFACE.reset == null ||
        WINTERFACE.sync == null ||
        WINTERFACE.launch == null ||
        WINTERFACE.execute == null ||
        WINTERFACE.end == null {
        return 0;
    }
    g_worker_interface = WINTERFACE.*;
    return 1;
}

end :: (WORKER: *Worker) {
    if WORKER.impl != null {
        change_state(WORKER, cast,no_check(Worker_Status) WORKER_STATUS_NOT_OK);
        pthread_join(WORKER.impl.thread, null);
        pthread_mutex_destroy(*WORKER.impl.mutex);
        pthread_cond_destroy(*WORKER.impl.condition);
        deallocate_memory(cast(*void) WORKER.impl);
        WORKER.impl = null;
    }
}

change_state :: (WORKER: *Worker, new_status: Worker_Status) {
    if WORKER.impl == null {
        return;
    }

    pthread_mutex_lock(*WORKER.impl.mutex);
    if WORKER.status >= cast,no_check(u32) WORKER_STATUS_OK {
        while WORKER.status != cast,no_check(u32) WORKER_STATUS_OK {
            pthread_cond_wait(*WORKER.impl.condition, *WORKER.impl.mutex);
        }

        if new_status != cast,no_check(u32) WORKER_STATUS_OK {
            WORKER.status = new_status;
            pthread_cond_signal(*WORKER.impl.condition);
        }
    }
    pthread_mutex_unlock(*WORKER.impl.mutex);
}

execute :: (WORKER: *Worker) {
    if WORKER.hook != null {
        WORKER.had_error |= cast(s32) (WORKER.hook(WORKER.data1, WORKER.data2) == 0);
    }
}

launch :: (WORKER: *Worker) {
    change_state(WORKER, cast,no_check(Worker_Status) WORKER_STATUS_WORKING);
}

sync :: (WORKER: *Worker) -> s32 {
    change_state(WORKER, cast,no_check(Worker_Status) WORKER_STATUS_OK);

    if WORKER.had_error == 0 {
        return 1;
    }
    return 0;
}

reset :: (WORKER: *Worker) -> s32 {
    ok: s32 = ---;
    code_block_to_execute: s64 = 26;
    // The transpiler had to use this control-flow loop because the source code used a goto, which Jai does not support.
    while c_transpiler_dispatch := true {
        if code_block_to_execute < 0 break;
        if code_block_to_execute == {
            case 11; {
                pthread_mutex_unlock(*WORKER.impl.mutex);
                if ok == 0 {
                    pthread_mutex_destroy(*WORKER.impl.mutex);
                    pthread_cond_destroy(*WORKER.impl.condition);
                    deallocate_memory(cast(*void) WORKER.impl);
                    WORKER.impl = null;
                    return 0;
                } else {
                    return ok;
                }
            }
            case 26; {
                ok = 1;
                WORKER.had_error = 0;
                if WORKER.status < cast,no_check(u32) WORKER_STATUS_OK {
                    WORKER.impl = cast(*Worker_Impl) calloc_2(1, size_of(Worker_Impl));
                    if WORKER.impl == null {
                        return 0;
                    } else {
                        if pthread_mutex_init(*WORKER.impl.mutex, null) != 0 {
                            deallocate_memory(cast(*void) WORKER.impl);
                            WORKER.impl = null;
                            return 0;
                        } else {
                            if pthread_cond_init(*WORKER.impl.condition, null) != 0 {
                                pthread_mutex_destroy(*WORKER.impl.mutex);
                                deallocate_memory(cast(*void) WORKER.impl);
                                WORKER.impl = null;
                                return 0;
                            } else {
                                pthread_mutex_lock(*WORKER.impl.mutex);
                                ok =
                                    cast(s32) (c_transpiler_pthread_create(
                                        *WORKER.impl.thread,
                                        null,
                                        cast,no_check(#type (_: *void) -> *void) thread_loop,
                                        cast(*void) WORKER
                                    ) == 0);
                                if ok != 0 {
                                    WORKER.status = cast,no_check(Worker_Status) WORKER_STATUS_OK;
                                    code_block_to_execute = 11;
                                    continue c_transpiler_dispatch;
                                } else {
                                    code_block_to_execute = 11;
                                    continue c_transpiler_dispatch;
                                }
                            }
                        }
                    }
                } else {
                    if WORKER.status > cast,no_check(u32) WORKER_STATUS_OK {
                        ok = sync(WORKER);
                        return ok;
                    } else {
                        return ok;
                    }
                }
            }
        }
        assert(false, tprint("invalid code block to execute %", code_block_to_execute));
        break;
    }
    return unreachable_value(s32);
}

thread_loop :: (ptr: *void) -> *void {
    WORKER := cast(*Worker) ptr;

    if WORKER.thread_name != null {
        thread_name: [16] s8 = ---;
        copy_cstring_up_to(thread_name.data, WORKER.thread_name, thread_name.count - 1);
        thread_name[(cast,no_check(u64) (thread_name.count)) - 1] = 0;
        pthread_setname_np(pthread_self(), thread_name.data);
    }

    pthread_mutex_lock(*WORKER.impl.mutex);
    while true {
        while WORKER.status == cast,no_check(u32) WORKER_STATUS_OK {
            pthread_cond_wait(*WORKER.impl.condition, *WORKER.impl.mutex);
        }
        if WORKER.status == cast,no_check(u32) WORKER_STATUS_WORKING {
            pthread_mutex_unlock(*WORKER.impl.mutex);
            execute(WORKER);
            pthread_mutex_lock(*WORKER.impl.mutex);

            WORKER.status = cast,no_check(Worker_Status) WORKER_STATUS_OK;

            pthread_cond_signal(*WORKER.impl.condition);
        } else {
            break;
        }
    }
    pthread_mutex_unlock(*WORKER.impl.mutex);
    return null;
}

init :: (WORKER: *Worker) {
    fill_memory(WORKER, 0, size_of(Worker));
    WORKER.status = cast,no_check(Worker_Status) WORKER_STATUS_NOT_OK;
}

get_worker_interface :: () -> *Worker_Interface {
    return *g_worker_interface;
}

globals_initialization_state_for_vpx_thread: u32;
initialize_globals_for_vpx_thread :: () {
    {
        state := atomic_load(*globals_initialization_state_for_vpx_thread);
        if state == 2 return;
        won, _ := compare_and_swap(*globals_initialization_state_for_vpx_thread, 0, 1);
        if !won {
            while atomic_load(*globals_initialization_state_for_vpx_thread) != 2 {}
            return;
        }
    }
    g_worker_interface =
        Worker_Interface.{
            init = init,
            reset = reset,
            sync = sync,
            launch = launch,
            execute = execute,
            end = end
        };
    atomic_store(*globals_initialization_state_for_vpx_thread, 2);
}

pthread_join :: (th: Pthread_T, thread_return: **void) -> s32 #foreign System_Library_libc_so_6;

pthread_mutex_destroy :: (mutex: *Pthread_Mutex_T) -> s32 #foreign System_Library_libc_so_6;

pthread_cond_destroy :: (cond: *Pthread_Cond_T) -> s32 #foreign System_Library_libc_so_6;

pthread_mutex_lock :: (mutex: *Pthread_Mutex_T) -> s32 #foreign System_Library_libc_so_6;

pthread_cond_wait :: (cond: *Pthread_Cond_T, mutex: *Pthread_Mutex_T) -> s32 #foreign System_Library_libc_so_6;

pthread_cond_signal :: (cond: *Pthread_Cond_T) -> s32 #foreign System_Library_libc_so_6;

pthread_mutex_unlock :: (mutex: *Pthread_Mutex_T) -> s32 #foreign System_Library_libc_so_6;

pthread_mutex_init :: (
    mutex: *Pthread_Mutex_T,
    mutexattr: *Pthread_Mutexattr_T
) -> s32 #foreign System_Library_libc_so_6;

pthread_cond_init :: (cond: *Pthread_Cond_T, cond_attr: *Pthread_Condattr_T) -> s32 #foreign System_Library_libc_so_6;

pthread_setname_np :: (target_thread: Pthread_T, name: *s8) -> s32 #foreign System_Library_libc_so_6;

pthread_self :: () -> Pthread_T #foreign System_Library_libc_so_6;

Pthread_T :: u64;

Worker_Status :: u32;
WORKER_STATUS_NOT_OK : s32 : 0;
WORKER_STATUS_OK : s32 : 1;
WORKER_STATUS_WORKING : s32 : 2;

Worker_Hook :: #type (_: *void, _: *void) -> s32;

Pthread_Mutex_T :: union {
    data: Pthread_Mutex_S;
    size: [40] s8;
    align: s64;
}

Pthread_Cond_T :: union {
    data: Pthread_Cond_S;
    size: [48] s8;
    align: s64;
}

Worker_Interface :: struct {
    init: #type (_: *Worker);
    reset: #type (_: *Worker) -> s32;
    sync: #type (_: *Worker) -> s32;
    launch: #type (_: *Worker);
    execute: #type (_: *Worker);
    end: #type (_: *Worker);
}

Worker :: struct {
    impl: *Worker_Impl;
    status: Worker_Status;
    thread_name: *s8;
    hook: Worker_Hook;
    data1: *void;
    data2: *void;
    had_error: s32;
}

Pthread_Mutexattr_T :: union {
    size: [4] s8;
    align: s32;
}

Pthread_Condattr_T :: union {
    size: [4] s8;
    align: s32;
}

Pthread_Attr_T :: union {
    size: [56] s8;
    align: s64;
}

Pthread_Mutex_S :: struct {
    lock: s32;
    count: u32;
    owner: s32;
    nusers: u32;
    kind: s32;
    spins: s16;
    glibc_reserved: s16;
    list: Pthread_List_T;
}

Pthread_Cond_S :: struct {
    wseq: Atomic_Wide_Counter #align 8;
    g1_start: Atomic_Wide_Counter #align 1;
    g_size: [2] u32 #align 1;
    g1_orig_size: u32 #align 1;
    wrefs: u32 #align 1;
    g_signals: [2] u32 #align 1;
    unused_initialized_1: u32 #align 1;
    unused_initialized_2: u32 #align 1;
} #no_padding;

Pthread_List_T :: Pthread_Internal_List;

Pthread_Internal_List :: struct {
    prev: *Pthread_Internal_List;
    next: *Pthread_Internal_List;
}

Atomic_Wide_Counter :: union {
    value64: u64;
    value32: Unnamed_1453;
}

Unnamed_1453 :: struct {
    low: u32;
    high: u32;
}

