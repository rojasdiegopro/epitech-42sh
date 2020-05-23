/*
** EPITECH PROJECT, 2020
** PSU_42sh_2019
** File description:
** start
*/

#include "proto/shell.h"
#include "proto/prompt.h"

/*
** @DESCRIPTION
**   Starts the 42sh.
**   Initialises all the 'dependencies' such as aliases etc...
*/
int shell_start(struct sh *shell)
{
    prompter(shell);
    return (0);
}
