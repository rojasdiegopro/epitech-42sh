/*
** EPITECH PROJECT, 2019
** PSU_42sh_2019
** File description:
** expr_else_control
*/

/* free */
#include <stdlib.h>

#include "proto/expr_destroy.h"

/*
** @DESCRIPTION
**   Rule for else_control expression.
*/
void expr_else_control_destroy(struct expr_else_control_s *this)
{
    if (!this) {
        return;
    }
    expr_block_destroy(this->block);
    free(this);
}
