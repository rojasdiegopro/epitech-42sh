/*
** EPITECH PROJECT, 2019
** PSU_42sh_2019
** File description:
** expr_subshell
*/

#include <stdlib.h>
#include <string.h>

#include "proto/grammar.h"
#include "proto/expr.h"

/*
** @DESCRIPTION
**   Rule for subshell expression.
*/
struct expr_subshell_s *expr_subshell(struct grammar_s *this)
{
    struct expr_subshell_s *exp = malloc(
        sizeof(struct expr_subshell_s));
    unsigned int save_index = this->index;

    if (!exp)
        exit(84);
    memset(exp, 0, sizeof(struct expr_subshell_s));

    return exp;
}
