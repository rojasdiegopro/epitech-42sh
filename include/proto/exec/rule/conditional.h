/*
** EPITECH PROJECT, 2020
** PSU_42sh_2019
** File description:
** shell exec rule conditional
*/

#ifndef SH_SHELL_EXEC_RULE_CONDITIONAL_H_
#define SH_SHELL_EXEC_RULE_CONDITIONAL_H_

#include "types/shell.h"
#include "types/expr.h"

int exec_rule_conditional(
    struct sh *shell,
    struct expr_conditional_s *rule
);

#endif /* !SH_SHELL_EXEC_RULE_CONDITIONAL_H_ */
