#ifndef PARSER_H
#define PARSER_H

#include <unistd.h>
#include <stdio.h>
#include <string.h>

typedef struct {
    char cmd[512];     /** command to execute */
    char args[99][512];   /** array of arguments */
    int args_count;
    char input[512];    /** input specification */
    char output[512];   /** output specification */
    char bg;
    char input_flag;
    char output_flag;
} cmd_t;

void parse(cmd_t *cmd, char* buf, int size);

void cmd_init(cmd_t *cmd);

char is_cchar(char c);

#endif
