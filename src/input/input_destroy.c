/*
** EPITECH PROJECT, 2019
** PSU_42sh_2019
** File description:
** input_destroy
*/

#include <stdlib.h>

#include "types/shell.h"

/*
** @DESCRIPTION
**   This function is called at the end of the command's execution in order to
**   free all of the malloc'ed variables.
*/
void input_destroy(struct sh *shell)
{
    free(shell->rawinput);
}