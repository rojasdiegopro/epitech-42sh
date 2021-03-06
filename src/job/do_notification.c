/*
** EPITECH PROJECT, 2020
** PSU_42sh_2019
** File description:
** job
*/

#include <stddef.h>
#include <sys/wait.h>

#include "proto/job/destroy.h"
#include "proto/job/utils.h"
#include "proto/job/format_info.h"
#include "proto/job/process/update_status.h"
#include "proto/job/do_notification.h"

static void job_update_status(struct sh *shell, struct job_s *first_job)
{
    int status;
    pid_t pid;

    do {
        pid = waitpid(WAIT_ANY, &status, WUNTRACED | WNOHANG);
    } while (!job_process_update_status(shell, first_job, pid, status));
}

void job_do_notification(struct sh *shell, struct job_s **first_job)
{
    struct job_s *job_last = NULL;
    struct job_s *job_next;

    job_update_status(shell, *first_job);
    for (struct job_s *job = *first_job; job; job = job_next) {
        job_next = job->next;
        if (job_is_completed(job)) {
            job_format_info(job, "Done", false);
            if (job_last) {
                job_last->next = job_next;
            } else
                *first_job = job_next;
            job_destroy(job);
        } else if (job_is_stopped(job) && !job->notified) {
            job_format_info(job, "Stopped", false);
            job->notified = true;
            job_last = job;
        } else
            job_last = job;
    }
}
