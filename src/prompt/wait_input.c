/*
** EPITECH PROJECT, 2019
** PSU_42sh_2019
** File description:
** get_input
*/

/* poll */
#include <poll.h>

#include "proto/prompt/wait_input.h"

void wait_input(void)
{
    struct pollfd events = (struct pollfd) {
        .fd = 0,
        .events = POLLIN,
        .revents = 0,
    };

    poll(&events, 1, -1);
}