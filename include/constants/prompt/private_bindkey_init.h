/*
** EPITECH PROJECT, 2020
** PSU_42sh_2019
** File description:
** Constants private_bindkey_init
*/

#ifndef SH_CONSTANTS_PROMPT_PRIVATE_BINDKEY_INIT_H_
#define SH_CONSTANTS_PROMPT_PRIVATE_BINDKEY_INIT_H_

#include "proto/prompt/action.h"

static const int BINDKEY_COUNT = 19;

static const struct {
    const char *key;
    struct bindkey_s data;
} BINDKEY_DICT[] = {
    {"kdch1",   {&prompt_action_delete,      ""}},
    {"khome",   {&prompt_action_home,        ""}},
    {"kend",    {&prompt_action_end,         ""}},
    {"\x1b[D",  {&prompt_action_left,        ""}},
    {"\x1b[C",  {&prompt_action_right,       ""}},
    {"\x1b[A",  {&prompt_action_up,          "up-history"}},
    {"\x1b[B",  {&prompt_action_down,        "down-history"}},
    {"\x1b[H",  {&prompt_action_home,        ""}},
    {"\x1b[F",  {&prompt_action_end,         ""}},
    {"\x7f",    {&prompt_action_backspace,   ""}},
    {"\t",      {&prompt_action_tab,         ""}},
    {"\x0C",    {&prompt_action_clear_term,  "clear-screen"}},
    {"\x03",    {&prompt_action_interrupt,   ""}},
    {"\x01",    {&prompt_action_home,        ""}},
    {"\x06",    {&prompt_action_right,       ""}},
    {"\x02",    {&prompt_action_left,        ""}},
    {"\x17",    {&prompt_action_cut_line,    ""}},
    {"\x15",    {&prompt_action_clear_line,  ""}},
    {"\x04",    {&prompt_action_end_of_file, ""}},
    {"\x1b[5~", {NULL,                       ""}}
};

#endif /* !SH_CONSTANTS_PROMPT_PRIVATE_BINDKEY_INIT_H_ */
