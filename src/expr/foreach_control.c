/*
** EPITECH PROJECT, 2019
** PSU_42sh_2019
** File description:
** expr_foreach_control
*/

#include <stdlib.h>
#include <string.h>

#include "proto/grammar.h"
#include "proto/expr.h"

static struct expr_foreach_control_s *expr_foreach_control_n(
    struct grammar_s *this,
    struct expr_foreach_control_s *exp,
    unsigned int save_index
)
{
    if (!grammar_match(this, 1, TOK_NEWLINE))
        return (expr_free(exp));
    exp->newline = grammar_get_previous(this);
    save_index = this->index;
    exp->block = expr_block_w(this);
    if (!exp->block)
        this->index = save_index;
    if (!grammar_match(this, 1, TOK_END))
        return (expr_free(exp));
    exp->end = grammar_get_previous(this);
    if (this->tokens[this->index]->type == TOK_EOF)
        return exp;
    if (!grammar_match(this, 1, TOK_NEWLINE))
        return (expr_free(exp));
    exp->newline = grammar_get_previous(this);
    return exp;
}

/*
** @DESCRIPTION
**   Rule for foreach_control expression.
*/
static struct expr_foreach_control_s *expr_foreach_control(
    struct grammar_s *this
)
{
    struct expr_foreach_control_s *exp = calloc(1, sizeof(*exp));
    unsigned int save_index = this->index;

    if (!exp)
        exit(84);
    if (!grammar_match(this, 1, TOK_FOREACH))
        return (expr_free(exp));
    exp->foreach = grammar_get_previous(this);
    if (!grammar_match(this, 1, TOK_WORD))
        return (expr_free(exp));
    exp->word = grammar_get_previous(this);
    exp->wordlist_expression = expr_wordlist_expression_w(this);
    if (!exp->wordlist_expression)
        return (expr_free(exp));
    return expr_foreach_control_n(this, exp, save_index);
}

struct expr_foreach_control_s *expr_foreach_control_w(struct grammar_s *this)
{
    struct expr_foreach_control_s *exp;

    expr_print(this, "Foreach Control");
    exp = expr_foreach_control(this);
    expr_print_debug(this, exp);
    return exp;
}
