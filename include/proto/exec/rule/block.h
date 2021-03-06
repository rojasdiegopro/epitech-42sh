/*
** EPITECH PROJECT, 2020
** PSU_42sh_2019
** File description:
** shell exec rule block
*/

#ifndef SH_SHELL_EXEC_RULE_BLOCK_H_
#define SH_SHELL_EXEC_RULE_BLOCK_H_

#include "types/shell.h"
#include "types/expr.h"

int exec_rule_block(
    struct sh *shell,
    struct expr_block_s *rule
);

#endif /* !SH_SHELL_EXEC_RULE_BLOCK_H_ */
