#include "parser.h"

#include <stdlib.h>

void parse(cmd_t *cmd, char* buf, int size) {
    cmd_init(cmd);

    int i;
    int args = 0;
    int start;

    for (i = 0; i < size; i++) {
        /** Ignore whitespaces */
        while(buf[i] == ' ' || buf[i] == '\t')
            i++;

        if (buf[i] == '<') {
            printf("found <\n");
            //strncpy(cmd->args[args-1], &buf[i], 1);
            //args++;
            i++;

            while(buf[i] == ' ' || buf[i] == '\t')
                i++;

            start = i;

            /** Advance to the end of argument */
            while(!is_cchar(buf[++i]));

            strncpy(cmd->input, &buf[start], i - start);
            //strncpy(cmd->args[args-1], &buf[start], i - start);
            //args++;
            cmd->input_flag = 1;
        } else if (buf[i] == '>') {
            printf("found >\n");
            //strncpy(cmd->args[args-1], &buf[i], 1);
            //args++;
            i++;

            while(buf[i] == ' ' || buf[i] == '\t')
                i++;

            start = i;

            /** Advance to the end of argument */
            while(!is_cchar(buf[++i]));

            strncpy(cmd->output, &buf[start], i - start);
            //strncpy(cmd->args[args-1], &buf[start], i - start);
            //args++;
            cmd->output_flag = 1;
        } else if (buf[i] == '&') {
            cmd->bg = 1;
            printf("found &\n");
            continue;
        } else {
            start = i;

            i++;
            while(!is_cchar(buf[++i]));

            if (args == 0) {
                strncpy(cmd->cmd, &buf[start], i - start);
            } else {
                strncpy(cmd->args[args-1], &buf[start], i - start);
            }
            args++;

        }
    }

    cmd->args_count = args - 1;

    if (cmd->bg)
        cmd->args_count--;

    /*if (cmd->input_flag)
        cmd->args_count--;

    if (cmd->output_flag)
        cmd->args_count--;
*/

    //cmd->args[cmd->args_count] = NULL;

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
    memset(cmd->input, 0, sizeof(cmd->output));

    cmd->bg = 0;
    cmd->input_flag = 0;
    cmd->output_flag = 0;
}
