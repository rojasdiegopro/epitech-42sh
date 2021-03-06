/*
** EPITECH PROJECT, 2020
** builtins
** File description:
** builtin_change_directory
*/

/* perror */
#include <stdio.h>
/* chdir */
#include <unistd.h>
/* strdup */
#include <string.h>
/* getenv */
#include <stdlib.h>
/* errno */
#include <errno.h>

#include "builtin/get_user_home.h"

/* */
#include "builtin/change_directory.h"

static const char CHANGE_DIRECTORY_GOTO_LAST_DIR[] = "-";

static enum change_directory_e builtin_change_directory_set_env(const char *env)
{
    char *pwd = getcwd(NULL, 0);

    if (pwd == NULL) {
        return (CD_ALLOCATION_FAIL);
    }
    if (setenv(env, pwd, 1)) {
        return (CD_ALLOCATION_FAIL);
    }
    return (CD_SUCCESS);
}

static enum change_directory_e builtin_change_directory_to_home(void)
{
    const char *home = builtin_get_user_home();

    builtin_change_directory_set_env("OLDPWD");
    if (home == NULL) {
        perror("getpwuid");
        return (CD_GETPWUID_FAIL);
    }
    if (chdir(home) == -1) {
        dprintf(2, "%s: Not a directory.\n", home);
        return (CD_CHDIR_FAIL);
    }
    return (builtin_change_directory_set_env("PWD"));
}

static enum change_directory_e builtin_change_directory_to_last_dir(void)
{
    const char *old_pwd = getenv("OLDPWD");
    const char *pwd = getenv("PWD");
    char *pwd_save = NULL;

    if (old_pwd == NULL) {
        return (builtin_change_directory_to_home());
    }
    if (chdir(old_pwd) == -1) {
        return (CD_CHDIR_FAIL);
    }
    pwd_save = (pwd != NULL) ? strdup(pwd) : getcwd(NULL, 0);
    if (pwd_save == NULL) {
        return (CD_ALLOCATION_FAIL);
    }
    setenv("PWD", old_pwd, 1);
    setenv("OLDPWD", pwd_save, 1);
    free(pwd_save);
    return (CD_SUCCESS);
}

enum change_directory_e builtin_change_directory(const char *path)
{
    if (path == NULL) {
        return (builtin_change_directory_to_home());
    }
    if (!strcmp(path, CHANGE_DIRECTORY_GOTO_LAST_DIR)) {
        return (builtin_change_directory_to_last_dir());
    }
    builtin_change_directory_set_env("OLDPWD");
    if (chdir(path) == -1) {
        dprintf(2, "%s: %s.\n", path, strerror(errno));
        return (CD_CHDIR_FAIL);
    }
    builtin_change_directory_set_env("PWD");
    return (CD_SUCCESS);
}
