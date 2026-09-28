// Generated directly from C by cpp_transpiler.
vp9_jobq_init :: (jobq: *Job_Queue_Row_Mt, buf: *u8, buf_size: u64) {
    pthread_mutex_init(*jobq.mutex, null);
    pthread_cond_init(*jobq.cond, null);

    jobq.buf_base = buf;
    jobq.buf_wr = buf;
    jobq.buf_rd = buf;
    jobq.buf_end = buf + buf_size;
    jobq.terminate = 0;
}

vp9_jobq_reset :: (jobq: *Job_Queue_Row_Mt) {
    pthread_mutex_lock(*jobq.mutex);

    jobq.buf_wr = jobq.buf_base;
    jobq.buf_rd = jobq.buf_base;
    jobq.terminate = 0;

    pthread_mutex_unlock(*jobq.mutex);
}

vp9_jobq_deinit :: (jobq: *Job_Queue_Row_Mt) {
    vp9_jobq_reset(jobq);

    pthread_mutex_destroy(*jobq.mutex);
    pthread_cond_destroy(*jobq.cond);
}

vp9_jobq_terminate :: (jobq: *Job_Queue_Row_Mt) {
    pthread_mutex_lock(*jobq.mutex);

    jobq.terminate = 1;

    pthread_cond_broadcast(*jobq.cond);
    pthread_mutex_unlock(*jobq.mutex);
}

vp9_jobq_queue :: (jobq: *Job_Queue_Row_Mt, job: *void, job_size: u64) -> s32 {
    ret: s32 = 0;

    pthread_mutex_lock(*jobq.mutex);

    if jobq.buf_end >= jobq.buf_wr + job_size {
        copy_memory(jobq.buf_wr, job, job_size);
        jobq.buf_wr = jobq.buf_wr + job_size;

        pthread_cond_signal(*jobq.cond);

        ret = 0;
    } else {
        ret = 1;
    }

    pthread_mutex_unlock(*jobq.mutex);

    return ret;
}

vp9_jobq_dequeue :: (jobq: *Job_Queue_Row_Mt, job: *void, job_size: u64, blocking: s32) -> s32 {
    ret: s32 = 0;

    pthread_mutex_lock(*jobq.mutex);

    if jobq.buf_end >= jobq.buf_rd + job_size {
        while ((cast(s32) 1) != 0) {
            if jobq.buf_wr >= jobq.buf_rd + job_size {
                copy_memory(job, jobq.buf_rd, job_size);
                jobq.buf_rd = jobq.buf_rd + job_size;
                ret = 0;
                break;
            } else {
                if jobq.terminate == 1 {
                    ret = 1;
                    break;
                }
                if blocking == 1 {
                    pthread_cond_wait(*jobq.cond, *jobq.mutex);
                } else {
                    ret = 1;
                    break;
                }
            }
        }
    } else {
        ret = 1;
    }

    pthread_mutex_unlock(*jobq.mutex);

    return ret;
}

