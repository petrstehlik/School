#ifndef PROJ2_H
#define PROJ2_H

#include "pidlist.h"

#define BUFFER_SIZE 513
#define PROMPT "$ "

char buffer[BUFFER_SIZE];
int exit_g;
int read_chars;

pidlist_t *pidlist;

void prompt();
void cleanup();
void consume_input();
void block_sigint();
void unblock_sigint();

pthread_t thr_exec;
void * exec_func();

void signal_handler(int signum);

pthread_mutex_t main_mutex;
pthread_cond_t main_cond;

pthread_mutex_t read_mutex;
pthread_cond_t read_cond;

#endif

