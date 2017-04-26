/**
 * POS project #2: Simple shell implementation in POSIX C using two threads
 *
 * \note: Command line parser which reacts to &,<,>
 *
 * Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
 * Date: 2017/04/26
 *
 * File: parser.h
 */
#ifndef PARSER_H
#define PARSER_H

/**
 * \brief Structure to hold all info about command line contents
 */
typedef struct {
    char cmd[512];		/** command to execute */
    char args[99][512];	/** array of arguments */
    int args_count;		/** total argument count */
    char input[512];	/** input specification */
    char output[512];	/** output specification */
    char bg;			/** background flag */
    char input_flag;	/** input flag */
    char output_flag;	/** output flag */
} cmd_t;

/**
 * \brief Parse a string retrieved from stdin
 */
void parse(cmd_t *cmd, char* buf, int size);

/**
 * \brief Initiliaze the cmd_t structure
 */
void cmd_init(cmd_t *cmd);

/**
 * Checks if given character is a control character
 */
char is_cchar(char c);

#endif
