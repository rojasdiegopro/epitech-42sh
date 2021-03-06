/*
** EPITECH PROJECT, 2019
** PSU_42sh_2019
** File description:
** input_parse
*/

/* Needed for calloc, NULL */
#include <stdlib.h>

#include "mynode.h"
#include "parser_toolbox.h"

#include "constants/validators.h"
#include "constants/tokens.h"
/* Following headers contain implicit includes for types */
#include "proto/input/parser.h"
#include "proto/constants.h"

/*
** @DESCRIPTION
**   For TOKEN_COUNT, this function sends the token's validator to the
**   token_validate function using VALIDATORS[i].
**   The token for which the function returned the highest value becomes the
**   new token.
**
**   Validators are defined in constants/validators.h
**   Tokens are defined in types/input/token.h
**
*/
static struct token_s *input_scan(char const *string, unsigned int *index)
{
    struct token_s *this = calloc(1, sizeof(struct token_s));
    unsigned int record = 0;
    unsigned int current;
    unsigned int i;

    if (!this)
        return (0);
    (*this).start = *index;
    for (i = 0; i < TOK_COUNT; i++) {
        current = TOK_VALIDATORS[i](string + *index, TOKENS[i]);
        if (current >= record) {
            record = current;
            (*this).type = i;
        }
    }
    (*this).end = *index + record;
    *index += (record) ? record - 1 : 1;
    return (this);
}

/*
** @DESCRIPTION
**   This function translates the shell.rawinput variable into a token's list.
*/
void input_parse_tokens(struct sh *shell)
{
    struct node_s *tokens = NULL;
    struct token_s *new;

    for (unsigned int i = 0; (*shell).rawinput[i]; i++) {
        if (ptb_includes((*shell).rawinput[i], WHITESPACE))
            continue;
        new = input_scan((*shell).rawinput, &i);
        node_insert(&tokens, new);
        if (!(*shell).rawinput[i])
            i--;
    }
    node_insert(&tokens, token_new(TOK_EOF));
    node_reverse(&tokens);
    (*shell).tokens = tokens;
    if (shell->debug_mode)
        token_print_debug(tokens, shell->rawinput);
}
