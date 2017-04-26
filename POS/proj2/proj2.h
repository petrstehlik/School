/**
 * POS project #2: Simple shell implementation in POSIX C using two threads
 *
 * Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
 * Date: 2017/04/26
 *
 * File: proj2.h
 */

#ifndef PROJ2_H
#define PROJ2_H

#include "pidlist.h"

#define BUFFER_SIZE 513
#define PROMPT "$ "

/**
 * global buffer for command line input
 */
char buffer[BUFFER_SIZE];

/**
 * number of characters read from input
 */
int read_chars;

/**
 * Variable to check if we should exit
 */
int exit_g;

/**
 * List PIDs of background child processes
 */
pidlist_t *pidlist;

/**
 * output "$ " to stdout
 */
void prompt();

/**
 * Finalization function, frees resources and unblocks SIGINT
 */
void cleanup();

/**
  * Consume all remaining characters on STDIN
  * This is used when a command is longer >512 in order
  * to not print anything after exiting.
  */
void consume_input();

/**
 * Block SIGINT
 */
void block_sigint();

/**
 * Unblock SIGINT in order to cancel a running process
 */
void unblock_sigint();

/**
 * execution thread prototype
 */
pthread_t thr_exec;

/**
 * Execution thread function
 *
 * Handles command line parsing, forking and IO handling
 */
void * exec_func();

/**
 * Handle SIGCHLD
 */
void signal_handler(int signum);

/**
 * Mutex and condition for execution
 */
pthread_mutex_t main_mutex;
pthread_cond_t main_cond;

/**
 * mutex and condition for reading
 */
pthread_mutex_t read_mutex;
pthread_cond_t read_cond;

#endif
