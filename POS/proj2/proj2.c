#include "proj2.h"
#include "parser.h"

int main(void) {
	arg[0] = "ls";
	arg[1] = "-l";
	arg[2] = NULL;

	exit_g = 0;

	if (signal(SIGINT, signal_handler) == SIG_ERR)
    {
        perror("Can't catch SIGNINT signal");
        return EXIT_FAILURE;
    }

    if (signal(SIGCHLD, signal_handler) == SIG_ERR)
    {
        perror("Can't catch SIGNCHLD signal");
        return EXIT_FAILURE;
    }

    /**
      * Initialize mutexes and conditions
      */
    if (pthread_mutex_init(&main_mutex, NULL) ||
        pthread_cond_init(&main_cond, NULL))
    {
        perror("Failed to initialize mutexes and conditions");
        return EXIT_FAILURE;
    }
    /** create two threads
      * - one for reading
      * - one for execution
      */
    if (pthread_create(&thr_exec, NULL, exec_func, NULL))
    {
        perror("Failed to create threads");
        cleanup();
        return EXIT_FAILURE;
    }

    read_chars = BUFFER_SIZE;

    pthread_mutex_lock(&main_mutex);
    while (!exit_g) {
        prompt();
        memset(buffer, 0, sizeof(buffer));
		read_chars = read(0, buffer, BUFFER_SIZE);

		if (read_chars == 0 || strncmp(buffer, "exit", 4) == 0) {
			printf("i am done\n");
			exit_g = 1;
		}

		if (read_chars >= BUFFER_SIZE && buffer[BUFFER_SIZE-1] != '\n') {
		    printf("read chars: %d\n", read_chars);
		    fprintf(stderr, "Input too long");
		    consume_input();
		    exit_g = 1;
        }

		buffer[BUFFER_SIZE-1] = '\0';

        pthread_cond_signal(&main_cond);

        if (!exit_g)
            pthread_cond_wait(&main_cond, &main_mutex);
	}
    pthread_mutex_unlock(&main_mutex);

	// wait for exec thread
    pthread_join(thr_exec, NULL);

	cleanup();

	return exit_g;
}

void * exec_func(void)
{
    char **cmd_args = NULL;
    pthread_cond_wait(&main_cond, &main_mutex);
    int res;
    while(!exit_g)
    {
        /** Enter -> skip all processing */
        if (buffer[0] != '\n') {
            cmd_t cmd;

            parse(&cmd, buffer, read_chars);

            if (cmd.bg)
                printf("should run in bg\n");

            cmd_args = (char **) malloc((cmd.args_count + 1) * sizeof(char *));
            cmd_args[0] = cmd.cmd;

            for (int i = 0; i < cmd.args_count; i++) {
                cmd_args[i+1] = cmd.args[i];
            }

            cmd_args[cmd.args_count+1] = (char *) 0;

            int vf = vfork();

            if (vf == 0) {
                if (cmd.input_flag) {
                    printf("should have input: %s\n", cmd.input);

                    int fd;
                    fd = open(cmd.input, O_RDONLY);

                    if (fd < 0) {
                        perror("error opening file");
                        exit(EXIT_FAILURE);
                    }

                    if (dup2(fd, STDIN_FILENO) < 0) {
                        perror("dup2 failed for input file");
                        exit(EXIT_FAILURE);
                    }

                    close(fd);
                }

                if (cmd.output_flag) {
                    printf("should have output: %s\n", cmd.output);

                    int fd;
                    fd = open(cmd.output, O_WRONLY | O_CREAT | O_TRUNC, 0666);

                    if (fd < 0) {
                        perror("error opening file");
                        exit(EXIT_FAILURE);
                    }

                    if (dup2(fd, STDOUT_FILENO) < 0) {
                        perror("dup2 failed for output file");
                        exit(EXIT_FAILURE);
                    }

                    close(fd);
                }

				/** Execute the command */
                res = execvp(cmd_args[0], cmd_args);

                if (res < 0) {
                    perror("error occured");
                    exit_g = 1;
                    exit(EXIT_FAILURE);
                }
            } else if (vf < 0) { /** fork failed */
            	perror("vfork");
            } else if (!cmd.bg){ /** parent should wait if not background task */
                waitpid(res, NULL, 0);
            }

            free(cmd_args);

        } /** if '\n' */

        pthread_cond_signal(&main_cond);

        if (!exit_g)
            pthread_cond_wait(&main_cond, &main_mutex);

    } /** while */
    pthread_mutex_unlock(&main_mutex);

    pthread_exit(NULL);
}

void signal_handler(int signum)
{

    pid_t child_pid = waitpid(-1, NULL, WNOHANG);

    printf("Caught signal %d from %d\n", signum, child_pid);
    //cleanup();
}

/**
  * HELPER functions
  */
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
