#ifndef PROJ2_H
#define PROJ2_H

#define _POSIX_C_SOURCE 200809L
#define _XOPEN_SOURCE
#define _XOPEN_SOURCE_EXTENDED 1

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <pthread.h>

#include <sys/types.h>
#include <time.h>
#include <errno.h>
#include <signal.h>

#define BUFFER_SIZE 513
#define PROMPT "$ "

char buffer[BUFFER_SIZE];
char* arg[99];
int exit_g;
int read_chars;

void prompt();
void cleanup();
void consume_input();

void * exec_func();
void * reading_func();

void signal_handler(int signum);

pthread_mutex_t main_mutex;
pthread_cond_t main_cond;

pthread_t thr_reading;
pthread_t thr_exec;

#endif

