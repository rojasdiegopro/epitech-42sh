/*
** EPITECH PROJECT, 2020
** input_postprocessing
** File description:
** env_var_replace
*/

#include "gnu_source.h"

/* setenv */
#include <stdlib.h>
/* asprintf && dprintf */
#include <stdio.h>
/* size_t */
#include <stddef.h>

#include "parser_toolbox/includes.h"
#include "builtin/get_user_home.h"
#include "parser_toolbox/blacklist.h"
#include "proto/exec/magic/parse.h"
#include "types/shell.h"

static const char ENV_VAR_SEP[] = " \t\n\r\f\v";

static char *env_var_getenv(struct sh *shell, char *str)
{
    char *var = NULL;
    //char *hasher_get_data(shell->local_var, str)
    //asprintf(&var, "%d", data->nb);
    if (*str == '{') {

    }
    if (!ptb_blacklist(str, "\\/=&\"'()[]|{}")) {
        return ((char *) -1);
    }
    return (getenv(str));
}

static size_t env_var_special_variable(
    struct sh *shell,
    char **env_var,
    char *str
)
{
    size_t length = 0;

    *env_var = NULL;
    if (*str == '?') {
        asprintf(env_var, "%d", shell->last_status);
        for (; str[length] && !ptb_includes(str[length], ENV_VAR_SEP);
            ++length);
        return (length);
    }
    return (0);
}

static size_t env_var_replace_find_env(
    struct sh *shell,
    char **env_var,
    char *str
)
{
    size_t length = env_var_special_variable(shell, env_var, str);
    char save = '\0';

    str[-1] = '\0';
    if (length)
        return (length);
    for (; str[length] && !ptb_includes(str[length], ENV_VAR_SEP); ++length);
    save = str[length];
    str[length] = '\0';
    *env_var = env_var_getenv(shell, str);
    if (*env_var == (char *) -1) {
        dprintf(2, "Illegal variable name.\n");
        return (0);
    }
    if (*env_var == NULL) {
        dprintf(2, "%s: Undefined variable.\n", str);
        return (0);
    }
    str[length] = save;
    return (length);
}

static int env_var_replace_put_home(char **str)
{
    const char *home = NULL;
    char *save = *str;

    if (save[0] != '~') {
        return (0);
    }
    home = builtin_get_user_home();
    if (home == NULL) {
        return (0);
    }
    if (asprintf(str, "%s%s", home, save + 1) < 0) {
        return (1);
    }
    free(save);
    return (0);
}

int magic_env_var_replace(struct sh *shell, char **str)
{
    int ret = env_var_replace_put_home(str);
    char *save = *str;
    char *env_var = NULL;
    size_t var_name_length = 0;

    for (size_t i = 0; !ret && save[i] != '\0'; ++i) {
        if (save[i] != '$' || (i != 0 && save[i - 1] == '\\'))
            continue;
        var_name_length = env_var_replace_find_env(shell, &env_var, save + ++i);
        if (env_var == NULL || env_var == (char *) -1)
            return (1);
        i += var_name_length;
        if (asprintf(str, "%s%s%s", save, env_var, save + i) < 0)
            return (1);
        free(save);
        save = *str;
    }
    return (ret);
}