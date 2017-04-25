#define _XOPEN_SOURCE 501
#include <stdio.h>
#include <sys/types.h>
#include <signal.h>
#include <unistd.h>
#include <sys/wait.h>

#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <fcntl.h>
#include <pthread.h>

#include <errno.h>

#include "proj2.h"
#include "parser.h"


int main(void) {
	struct sigaction new_action;
	exit_g = 0;
	pidlist = malloc(sizeof(pidlist_t));
	pidlist_init(pidlist);

	new_action.sa_handler = signal_handler;
	sigemptyset (&new_action.sa_mask);
	new_action.sa_flags = 0;

	block_sigint();

    if (sigaction (SIGCHLD, &new_action, NULL) < 0)
    {
        perror("[signal] Can't catch SIGNCHLD signal");
        return EXIT_FAILURE;
    }

    /**
      * Initialize mutexes and conditions
      */
    if (pthread_mutex_init(&main_mutex, NULL) ||
        pthread_cond_init(&main_cond, NULL) ||
        pthread_mutex_init(&read_mutex, NULL) ||
        pthread_cond_init(&read_cond, NULL))
    {
        perror("[posix] Failed to initialize mutexes and conditions");
        return EXIT_FAILURE;
    }
    /** create two threads
      * - one for reading
      * - one for execution
      */
    if (pthread_create(&thr_exec, NULL, exec_func, NULL))
    {
        perror("[pthread] Failed to create threads");
        cleanup();
        return EXIT_FAILURE;
    }

    pthread_mutex_lock(&read_mutex);
    while (!exit_g) {
        prompt();
        memset(buffer, 0, sizeof(buffer));
		read_chars = read(0, buffer, BUFFER_SIZE);

		if (read_chars == 0 || strncmp(buffer, "exit", 4) == 0) {
			exit_g = 1;
		}

		if (read_chars >= BUFFER_SIZE && buffer[BUFFER_SIZE-1] != '\n') {
		    fprintf(stderr, "Input too long\n");
		    consume_input();
		    exit_g = 1;
        }

		buffer[BUFFER_SIZE-1] = '\0';

        pthread_cond_signal(&main_cond);

        if (!exit_g)
            pthread_cond_wait(&read_cond, &read_mutex);
	}
    pthread_mutex_unlock(&read_mutex);

    if (pidlist->size) {
        piditem_t *i;
        i = pidlist->head;

        while (i != NULL) {
            kill(i->pid, SIGTERM);
            i = i->next;
        }

        waitpid(-1, NULL, 0);
    }

    /** wait for exec thread */
    pthread_join(thr_exec, NULL);
    unblock_sigint();

	cleanup();

	return exit_g;
}

void * exec_func(void)
{
    char **cmd_args = NULL;
    int res, i, vf;
    pthread_mutex_lock(&main_mutex);
    pthread_cond_wait(&main_cond, &main_mutex);

    while(!exit_g)
    {
        /** Enter -> skip all processing */
        if (buffer[0] != '\n') {
            cmd_t cmd;

            parse(&cmd, buffer, read_chars);

            cmd_args = (char **) malloc((cmd.args_count + 2) * sizeof(char *));
            cmd_args[0] = cmd.cmd;

            for (i = 0; i < cmd.args_count; i++) {
                cmd_args[i+1] = cmd.args[i];
            }

            cmd_args[cmd.args_count+1] = NULL;

            vf = vfork();

            if (vf == 0) {
                if (cmd.input_flag) {
                    int fd;
                    fd = open(cmd.input, O_RDONLY);

                    if (fd < 0) {
                        perror("[open] error opening file");
                        exit(EXIT_FAILURE);
                    }

                    if (dup2(fd, STDIN_FILENO) < 0) {
                        perror("[dup2] failed for input file");
                        exit(EXIT_FAILURE);
                    }

                    close(fd);
                }

                if (cmd.output_flag) {
                    int fd;
                    fd = open(cmd.output, O_WRONLY | O_CREAT | O_TRUNC, 0666);

                    if (fd < 0) {
                        perror("[open] error opening file");
                        exit(EXIT_FAILURE);
                    }

                    if (dup2(fd, STDOUT_FILENO) < 0) {
                        perror("[dup2] failed for output file");
                        exit(EXIT_FAILURE);
                    }

                    close(fd);
                }

                if (cmd.bg) {
                    pidlist_insert(pidlist, getpid());

                   fprintf(stderr, "\r** process %d will be running in background\n", getpid());
                }

                unblock_sigint();

				/** Execute the command */
                res = execvp(cmd_args[0], cmd_args);

                if (res < 0) {
                    perror("[execvp] error");
                    _exit(EXIT_FAILURE);
                }
            } else if (vf < 0) { /** fork failed */
            	perror("vfork");
            } else {
                /** parent should wait if not a background task */
                if (!cmd.bg) {
                    waitpid(vf, NULL, 0);

                    block_sigint();
                }

                free(cmd_args);
            }

        } /** end of if '\n' */

        pthread_cond_signal(&read_cond);

        if (!exit_g)
            pthread_cond_wait(&main_cond, &main_mutex);

    } /** while */
    pthread_mutex_unlock(&main_mutex);

    pthread_exit(NULL);
}

void signal_handler(int signum)
{

    pid_t child_pid = waitpid(-1, NULL, WNOHANG);

    /*fprintf(stderr, "\r\nCaught SIGCHILD (%d)\n", child_pid);*/

    if (child_pid > 0 &&
            signum == SIGCHLD &&
            pidlist_find(pidlist, child_pid))
    {
        fprintf(stderr, "\r** background process (%d) finished **\n", child_pid);
        pidlist_remove(pidlist, child_pid);
        if (!exit_g)
            prompt();
    }
}

/*******************************************************************************
  * HELPER functions
  *****************************************************************************/
/**
  * Consume all remaining characters on STDIN
  * This is used when a command is longer >512 in order
  * to not print anything after exiting.
  */
void consume_input()
{
    char c;
    while((c = getchar()) != '\n');
}

/**
  * Output prompt sign
  */
void prompt() {
	write(1, "$ ", 2);
}

void cleanup() {
    pthread_mutex_destroy(&main_mutex);
    pthread_cond_destroy(&main_cond);
}

void block_sigint() {
	sigset_t s;
	sigemptyset(&s);
	sigaddset(&s, SIGINT);
	sigprocmask(SIG_BLOCK, &s, NULL);
}

void unblock_sigint() {
	sigset_t s;
	sigemptyset(&s);
	sigaddset(&s, SIGINT);
	sigprocmask(SIG_UNBLOCK, &s, NULL);
}
