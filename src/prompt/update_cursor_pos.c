/*
** EPITECH PROJECT, 2020
** PSU_42sh_2019
** File description:
** prompt_update_cursor_pos
*/

/* strlen */
#include <string.h>

/* putp */
#include <curses.h>
#include <term.h>

#include "types/prompt.h"
#include "proto/prompt/update_cursor_pos.h"

void prompt_update_cursor_pos(struct prompt *prompt)
{
    for (size_t size = strlen(prompt->input) - prompt->cursor; size > 0;
    --size) {
        putp(prompt->effect[PROMPT_EFFECT_CURSOR_BACKWARD]);
    }
}
