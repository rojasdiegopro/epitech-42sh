/*
** EPITECH PROJECT, 2020
** PSU_42sh_2019
** File description:
** job
*/

#include "sys/wait.h"

#include "proto/job/utils.h"
#include "proto/job/wait_for.h"
#include "proto/job/process/update_status.h"

void job_wait_for(struct sh *shell, struct job_s *first_job, struct job_s *job)
{
    int status;
    pid_t pid;

    do {
        pid = waitpid(WAIT_ANY, &status, WUNTRACED);
    } while (
        !job_process_update_status(shell, first_job, pid, status)
        && !job_is_stopped(job)
        && !job_is_completed(job)
    );
}
