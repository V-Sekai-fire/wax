#ifndef WAX_TO_EX_H
#define WAX_TO_EX_H

#include "common.h"
#include "parser.h"

str_t tree_to_ex(str_t modname, expr_t* tree, map_t* functable, map_t* stttable, map_t* included);

#endif
