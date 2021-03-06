/*
** EPITECH PROJECT, 2020
** find_binary
** File description:
** find_binary_in_path_env
*/

#include <stddef.h>

#include "path_iteration.h"
#include "find_file_in_path.h"

/* */
#include "find_binary_in_path_env.h"

char *find_binary_in_path_env(const char *path_env, const char *bin)
{
    char *full_path = NULL;
    const char *path = path_iteration(path_env);

    for (; path && !full_path; path = path_iteration(path_env)) {
        full_path = find_file_in_path(path, bin);
    }
    for (; path; path = path_iteration(path_env));
    return (full_path);
}
