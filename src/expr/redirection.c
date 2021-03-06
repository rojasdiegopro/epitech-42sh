/*
** EPITECH PROJECT, 2019
** PSU_42sh_2019
** File description:
** expr_redirection
*/

#include <stdlib.h>
#include <string.h>

#include "proto/constants.h"
#include "proto/grammar.h"
#include "proto/expr.h"

/*
** @DESCRIPTION
**   Rule for redirection expression.
*/
static struct expr_redirection_s *expr_redirection(struct grammar_s *this)
{
    struct expr_redirection_s *exp = malloc(
        sizeof(struct expr_redirection_s));
    unsigned int save_index __attribute__((unused)) = this->index;

    if (!exp)
        exit(84);
    memset(exp, 0, sizeof(struct expr_redirection_s));
    if (grammar_match(this, 1, TOK_IONUMBER))
        exp->io_number = grammar_get_previous(this);
    if (!grammar_match(this, 4, TOK_GREAT, TOK_DGREAT, TOK_LESS, TOK_DLESS))
        return (expr_free(exp));
    exp->redirection = grammar_get_previous(this);
    if (!grammar_match(this, 1, TOK_WORD)) {
        grammar_set_error(this, AST_MISSING_REDIRECT_NAME);
        return (expr_free(exp));
    }
    exp->word = grammar_get_previous(this);
    return exp;
}

struct expr_redirection_s *expr_redirection_w(struct grammar_s *this)
{
    struct expr_redirection_s *exp;

    expr_print(this, "Redirection");
    exp = expr_redirection(this);
    expr_print_debug(this, exp);
    return exp;
}
