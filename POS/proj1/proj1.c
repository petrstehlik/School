#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <time.h>
#include <sys/time.h>
#include <pthread.h>

typedef struct {
	int thr_id;
	int time_seed;
} params_t;

int getticket(void);
void await(int aenter);
void advance(void);
void printHelp(void);
void* thr(void *p);
void sleepTime(unsigned int seed);

_Thread_local unsigned int seed;
struct timeval tval;
int N, M;

int ticketGlob = 0;
int currentTicket = 0;
pthread_mutex_t secMutex;
pthread_mutex_t nTicketMutex;
pthread_cond_t secCond;

int main(int argc, char **argv)
{
	if (argc != 3) {
		printHelp();
		return EXIT_FAILURE;
	}

	N = atoi(argv[1]);
	M = atoi(argv[2]);

	int res;

	if ((res = pthread_mutex_init(&secMutex, NULL)) != 0) {
		perror("Failed to initialize section mutex");
		return EXIT_FAILURE;
	}

	if ((res = pthread_mutex_init(&nTicketMutex, NULL)) != 0) {
		perror("Failed to initialize next ticket mutex");
		return EXIT_FAILURE;
	}

	if ((res = pthread_cond_init(&secCond, NULL)) != 0) {
		perror("Failed to initialize section condition");
		return EXIT_FAILURE;
	}

	pthread_t *threads = malloc(sizeof(pthread_t) * N);
	params_t *params = malloc(sizeof(params_t) * N);

	printf("N number: %d\n",N);
	printf("M number: %d\n\n",M);

	printf("Ticket\tThread ID\n");

	for (int i = 0; i < N; i++) {
		gettimeofday(&tval, NULL);
		params[i].thr_id = i + 1;
		params[i].time_seed = (long int)tval.tv_sec*1000000L + (long int)tval.tv_usec;
		pthread_create(&threads[i], NULL, thr, &params[i]);
	}

	for (int i = 0; i < N; i++) {
		pthread_join(threads[i], NULL);
	}

	pthread_mutex_destroy(&secMutex);
	pthread_mutex_destroy(&nTicketMutex);
	pthread_cond_destroy(&secCond);
	free(threads);
	free(params);

	return EXIT_SUCCESS;
}

void printHelp()
{
	char *helpText = "Hilfe I need help!\n"
					  "./proj1 [N] [M]\n"
					  "N - number of threads to create\n"
					  "M - number of tickets available\n";
	printf("%s\n", helpText);
}

int getticket(void)
{
	int ticket;
	pthread_mutex_lock(&nTicketMutex);
	ticket = ticketGlob++;
	pthread_mutex_unlock(&nTicketMutex);

	return ticket;
}

void await(int aenter)
{
	pthread_mutex_lock(&secMutex);

	while(aenter != currentTicket) {
		pthread_cond_wait(&secCond, &secMutex);
	}
	pthread_mutex_unlock(&secMutex);

}

void advance(void)
{
	pthread_mutex_lock(&nTicketMutex);
	currentTicket++;
	pthread_cond_broadcast(&secCond);
	pthread_mutex_unlock(&nTicketMutex);
}

void sleepTime(unsigned int seed)
{
	struct timespec t;
	seed += (unsigned int)pthread_self();
	t.tv_sec = 0;
	t.tv_nsec = (rand_r(&seed) % 500000000) + 1;
	nanosleep(&t, NULL);
}

void* thr(void *p)
{
	params_t *params = (params_t*)p;
	// Calculate sleep time
	int ticket;

	while ((ticket = getticket()) < M) { /* Přidělení lístku */
		/* Náhodné čekání v intervalu <0,0 s, 0,5 s> */
		sleepTime(params->time_seed);

		await(ticket);              /* Vstup do KS */
		printf("%d\t(%d)\n", ticket, params->thr_id); /* fflush(stdout); */
		fflush(stdout);
		advance();              /* Výstup z KS */

		/* Náhodné čekání v intervalu <0,0 s, 0,5 s> */
		sleepTime(params->time_seed);
	}

	return NULL;
}
