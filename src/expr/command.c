/*
** EPITECH PROJECT, 2019
** PSU_42sh_2019
** File description:
** expr_command
*/

#include <stdlib.h>
#include <string.h>

#include "proto/grammar.h"
#include "proto/expr.h"

/*
** @DESCRIPTION
**   Rule for command expression.
*/
struct expr_command_s *expr_command(struct grammar_s *this)
{
    struct expr_command_s *exp = malloc(
        sizeof(struct expr_command_s));
    unsigned int save_index = this->index;

    printf("- Command.\n");
    if (!exp)
        exit(84);
    memset(exp, 0, sizeof(struct expr_command_s));
    if (!grammar_match(this, 1, TOK_WORD)) {
        free(exp);
        return NULL;
    }
    exp->word = grammar_get_previous(this);
    save_index = this->index;
    exp->redirection = expr_redirection(this);
    if (!exp->redirection)
        this->index = save_index;
    else
        save_index = this->index;
    exp->command = expr_command(this);
    if (!exp->command)
        this->index = save_index;
    return exp;
}
