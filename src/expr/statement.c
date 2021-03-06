/*
** EPITECH PROJECT, 2019
** PSU_42sh_2019
** File description:
** expr_statement
*/

#include <stdlib.h>
#include <string.h>

#include "proto/grammar.h"
#include "proto/expr.h"

/*
** @DESCRIPTION
**   Rule for statement expression.
*/
static struct expr_statement_s *expr_statement(struct grammar_s *this)
{
    struct expr_statement_s *exp = malloc(sizeof(struct expr_statement_s));
    unsigned int save_index = this->index;

    if (!exp)
        exit(84);
    memset(exp, 0, sizeof(struct expr_statement_s));
    exp->compound = expr_compound_w(this);
    if (!exp->compound)
        this->index = save_index;
    else
        return exp;
    exp->control = expr_control_w(this);
    if (!exp->control) {
        this->index = save_index;
        free(exp);
        return NULL;
    }
    return exp;
}

struct expr_statement_s *expr_statement_w(struct grammar_s *this)
{
    struct expr_statement_s *exp;

    expr_print(this, "Statement");
    exp = expr_statement(this);
    expr_print_debug(this, exp);
    return exp;
}
