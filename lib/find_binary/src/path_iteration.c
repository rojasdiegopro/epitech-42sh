/*
** EPITECH PROJECT, 2020
** find_binary
** File description:
** path_iteration
*/

#include <stdlib.h>
#include <string.h>

#include "double_array_size.h"

/* */
#include "path_iteration.h"

static const size_t PATH_IT_PATH_LEN = 128;
static const char PATH_IT_DELIMITER = ':';

static int path_iteration_check_path_env(
    const char *path_env,
    char **path,
    size_t *old_pos
)
{
    if (path_env == NULL) {
        if (*path != NULL) {
            free(*path);
            *path = NULL;
        }
        return (1);
    }
    if (*path == NULL) {
        *path = malloc(sizeof(char) * PATH_IT_PATH_LEN);
        if (path == NULL) {
            return (1);
        }
    }
    if (path_env[*old_pos] == '\0') {
        *old_pos = 0;
        return (1);
    }
    return (0);
}

static void path_iteration_reset_env(
    const char ***env_point,
    const char **path_env,
    size_t *old_pos,
    size_t *pos
)
{
    *env_point = path_env;
    *old_pos = 0;
    *pos = 0;
}

const char *path_iteration(const char *path_env)
{
    static const char **env_point = NULL;
    static char *path = NULL;
    static size_t old_pos = 0;
    static size_t size = PATH_IT_PATH_LEN;
    size_t pos = old_pos;

    if (path_iteration_check_path_env(path_env, &path, &old_pos))
        return (NULL);
    if (env_point == NULL || *env_point != path_env)
        path_iteration_reset_env(&env_point, &path_env, &old_pos, &pos);
    if (path_env[old_pos] == '\0')
        return (NULL);
    for (; path_env[pos] && path_env[pos] != PATH_IT_DELIMITER; ++pos);
    while (pos - old_pos >= size)
        if (double_array_size((void **) &path, &size))
            return (NULL);
    strncpy(path, path_env + old_pos, pos - old_pos);
    path[pos - old_pos] = '\0';
    old_pos = path_env[pos] ? pos + 1 : pos;
    return (path);
}

void path_iteration_atexit(void)
{
    path_iteration(NULL);
}
