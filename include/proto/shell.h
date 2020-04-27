/*
** EPITECH PROJECT, 2019
** PSU_42sh_2019
** File description:
** shell header file.
*/

#ifndef SH_PROTO_SHELL_H_
#define SH_PROTO_SHELL_H_

/**/
/* Includes */
/**/

#include "types/shell.h"

/**/
/* Constants */
/**/

/**/
/* Structures / Typedef / Enums declarations */
/**/

/**/
/* Function prototypes */
/**/

struct sh shell_struct_initialise(int ac, char *const *av, char *const *ep);
void shell_start(struct sh *shell);

#endif
