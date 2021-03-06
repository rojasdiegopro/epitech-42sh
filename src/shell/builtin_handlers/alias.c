/*
** EPITECH PROJECT, 2020
** PSU_42sh_2019
** File description:
** builtins
*/

#include "gnu_source.h"

#include <stdlib.h>
#include <string.h>

#include "parser_toolbox/argv_length.h"

#include "hasher/pop.h"
#include "hasher/create.h"
#include "hasher/destroy.h"
#include "hasher/insert.h"
#include "hasher/override.h"

#include "builtins.h"
#include "types/shell.h"
#include "proto/shell/builtin_handlers.h"


#include "parser_toolbox/str_join.h"

static int insert_alias(struct sh *shell, const char * const *argv)
{
    char *data = NULL;
    struct hasher_s *new = NULL;
    struct hasher_s *overrided = NULL;

    data = ptb_str_join(argv + 2, " ");
    if (data == NULL) {
        return (1);
    }
    new = hasher_create(strdup(argv[1]), data);
    if (new == NULL) {
        return (1);
    }
    overrided = hasher_override(&shell->alias, new);
    if (!overrided) {
        hasher_insert_ordered(&shell->alias, new);
    }
    return (0);
}

int builtin_alias_handler(
    struct sh *shell,
    const char * const *argv
)
{
    if (!argv[1]) {
        for (struct hasher_s *alias = shell->alias; alias != NULL;
        alias = alias->next) {
            dprintf(1, "%s\t%s\n", alias->key, (char *) alias->data);
        }
        return (0);
    }
    return (!argv[2] || insert_alias(shell, argv));
}

int builtin_unalias_handler(
    struct sh *shell,
    const char * const *argv
)
{
    struct hasher_s *poped = NULL;

    if (builtins_utils_too_few_arguments(argv, 1)) {
        return (1);
    }
    if (!shell->alias) {
        return (0);
    }
    for (size_t i = 1; argv[i]; ++i) {
        poped = hasher_pop(&shell->alias, argv[i]);
        if (poped) {
            hasher_destroy(poped, false, false);
        }
    }
    return (0);
}
