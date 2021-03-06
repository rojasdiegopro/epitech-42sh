/*
** EPITECH PROJECT, 2020
** builtins
** File description:
** builtin_exit
*/

#include <stdio.h>
/* exit && atoi */
#include <stdlib.h>

#include "parser_toolbox/whitelist.h"

/* */
#include "builtin/exit.h"

/* last status */

void builtin_exit(const char * const *argv)
{
    if (argv[0] == NULL) {
        exit(0);
    }
    if (argv[1] != NULL || !ptb_whitelist_digit(argv[0])) {
        dprintf(2, "exit: Expression Syntax.\n");
        return;
    }
    exit((int) strtol(argv[0], (char **) NULL, 10));
}
