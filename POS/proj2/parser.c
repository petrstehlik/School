/**
 * POS project #2: Simple shell implementation in POSIX C using two threads
 *
 * \note: Command line parser which reacts to &,<,>
 *
 * Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
 * Date: 2017/04/26
 *
 * File: parser.c
 */
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "parser.h"

void parse(cmd_t *cmd, char* buf, int size) {
    int i;
    int args = 0;
    int start;

    cmd_init(cmd);

    for (i = 0; i < size; i++) {
        /** Ignore whitespaces */
        while(buf[i] == ' ' || buf[i] == '\t')
            i++;

        if (buf[i] == '<') {
            i++;

            while(buf[i] == ' ' || buf[i] == '\t')
                i++;

            start = i++;

            /** Advance to the end of argument */
            while(!is_cchar(buf[i]))
			{
				if (i < size)
					i++;
			}

            strncpy(cmd->input, &buf[start], i - start);
            cmd->input_flag = 1;
        } else if (buf[i] == '>') {
            i++;

            while(buf[i] == ' ' || buf[i] == '\t')
                i++;

            start = i++;

            /** Advance to the end of argument */
			while(!is_cchar(buf[i]))
			{
				if (i < size)
					i++;
			}
            strncpy(cmd->output, &buf[start], i - start);
            cmd->output_flag = 1;
        } else if (buf[i] == '&') {
            cmd->bg = 1;
            i++;
        } else {
            start = i++;

			while(!is_cchar(buf[i]))
			{
				if (i < size)
					i++;
			}

            if (args == 0) {
                strncpy(cmd->cmd, &buf[start], i - start);
            } else {
                strncpy(cmd->args[args-1], &buf[start], i - start);
            }
            args++;

        }
    }

    cmd->args_count = args-1;
}

/**
  * Checks if given character is a control character
  * ' ', '\t', '&', '>', '<'
  */
char is_cchar(char c) {
    if (c == ' '  ||
        c == '\t' ||
        c == '&'  ||
        c == '>'  ||
        c == '\n' ||
        c == '<')
        return 1;

    return 0;
}

void cmd_init(cmd_t *cmd) {

    int i;

    for (i = 0; i < 99; i++)
        memset(cmd->args[i], 0, sizeof(cmd->args[i]));

    memset(cmd->cmd, 0, sizeof(cmd->cmd));
    memset(cmd->input, 0, sizeof(cmd->input));
    memset(cmd->output, 0, sizeof(cmd->output));

    cmd->bg = 0;
    cmd->input_flag = 0;
    cmd->output_flag = 0;
}
