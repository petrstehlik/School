#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>

#define BUFFER_SIZE 513
#define PROMPT "$ "

void prompt() {
	write(1, "$ ", 2);
	//fflush(stdout);
}

int main(void) {
	char buffer[BUFFER_SIZE];
	char* arg[99];
	memset(&arg, 0, sizeof(arg));
	arg[0] = "ls";
	//arg[1] = "-l";
	while (1) {
		prompt();
		//bzero(&buffer, sizeof(buffer));
		int read_chars = read(0, buffer, BUFFER_SIZE - 1);

		if (read_chars == 0 || strncmp(buffer, "exit", 4) == 0) {
			printf("i am done\n");
			break;
		}

		printf("buffer: %s\n", buffer);
		//int fd = open("t.txt", O_CREAT | O_TRUNC | O_RDWR, 0644);
		//dup2(fd, STDOUT_FILENO);
		int vf = vfork();

		if (vf == 0) {
			int res = execvp(arg[0],arg);
			//close(fd);
		} else if (vf < 0) {
			perror("vfork");
		}
	}
	fflush(stdout);

	return 0;
}
