/*
** EPITECH PROJECT, 2020
** PSU_42sh_2019
** File description:
** sh prompt term_set_raw_mode
*/

#ifndef SH_PROTO_PROMPT_SET_RAW_H_
#define SH_PROTO_PROMPT_SET_RAW_H_

#include <termios.h>

void term_set_raw_mode(const struct termios *orig_term);

#endif /* !SH_PROTO_PROMPT_SET_RAW_H_ */
