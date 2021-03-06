/*
** EPITECH PROJECT, 2019
** PSU_42sh_2019
** File description:
** expr_pipeline
*/

#include <stdlib.h>
#include <string.h>

#include "proto/constants.h"
#include "proto/grammar.h"
#include "proto/expr.h"

static int expr_pipeline_sub_test(
    struct grammar_s *this,
    struct expr_pipeline_s *exp,
    unsigned int save_index
)
{
    this->index = save_index;
    exp->command = expr_command_w(this);
    if (!exp->command)
        return (1);
    return (0);
}

/*
** @DESCRIPTION
**   Rule for pipeline expression.
*/
static struct expr_pipeline_s *expr_pipeline(struct grammar_s *this)
{
    struct expr_pipeline_s *exp = malloc(
        sizeof(struct expr_pipeline_s));
    unsigned int save_index __attribute__((unused)) = this->index;

    if (!exp)
        exit(84);
    memset(exp, 0, sizeof(struct expr_pipeline_s));
    exp->subshell = expr_subshell_w(this);
    if (!exp->subshell && expr_pipeline_sub_test(this, exp, save_index))
        return (expr_free(exp));
    if (!grammar_match(this, 1, TOK_PIPE))
        return exp;
    exp->pipe = grammar_get_previous(this);
    exp->pipeline = expr_pipeline(this);
    if (!exp->pipeline) {
        grammar_set_error(this, AST_NULL_COMMAND);
        return (expr_free(exp));
    }
    return exp;
}

struct expr_pipeline_s *expr_pipeline_w(struct grammar_s *this)
{
    struct expr_pipeline_s *exp;

    expr_print(this, "Pipeline");
    exp = expr_pipeline(this);
    expr_print_debug(this, exp);
    return exp;
}
