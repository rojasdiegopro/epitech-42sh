/*
** EPITECH PROJECT, 2019
** PSU_42sh_2019
** File description:
** shell header file.
*/

#ifndef SH_TYPES_SHELL_H_
#define SH_TYPES_SHELL_H_

/**/
/* Includes */
/**/

#include <stdbool.h>

#include "mynode.h"

/**/
/* Constants */
/**/

/**/
/* Structures / Typedef / Enums declarations */
/**/
/*
** @DESCRIPTION
**   Main shell structure.
** @MEMBERS
**   - active: the shell will run while active is true.
**   - rawinput: the input from the user fetched with getline.
**   - tokens: a linked list containing the parsed tokens for the rawinput.
**   - envp: the environement as an array of strings.
*/
typedef struct sh {
    bool         active;
    char         *rawinput;
    node_t       *tokens;
    char * const *envp;
} sh_t;

/**/
/* Function prototypes */
/**/

#endif
