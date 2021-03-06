/*
** EPITECH PROJECT, 2020
** parser_toolbox
** File description:
** ptb_characters
*/

#include <stdlib.h>
#include <string.h>

#include "parser_toolbox/sort_string.h"

static int sort_string_cmp(const void *a, const void *b)
{
    return (strcmp(*((char * const *) a), *((char * const *) b)));
}

void ptb_sort_string(char * const *strings, size_t length)
{
    qsort((void *) strings, length, sizeof(char *), sort_string_cmp);
}
