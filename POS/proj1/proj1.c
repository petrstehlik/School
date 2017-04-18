#define _POSIX_C_SOURCE 200809L
#define _XOPEN_SOURCE
#define _XOPEN_SOURCE_EXTENDED 1

/*
 * POS Project #1 Ticket Algorithm
 * Author: Petr Stehlik (xstehl14) <xstehl14@stud.fit.vutbr.cz>
 * LS 2017
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <time.h>
#include <pthread.h>
#include <errno.h>
#include <stdint.h>
#include <unistd.h>

#ifndef DEBUG
#define DEBUG 0
#endif

/** Struct for thread parameters */
typedef struct {
	int m;
	int thr_id;
	long int time_seed;
} params_t;

/** Ticket algoritm functions as specified */
int getticket(void);
void await(int aenter);
void advance(void);

/** If arguments are incorrect print help */
void printHelp(void);

/** Thread function */
void* thr(void *);

/** Sleep for a random time <0, 0.5>s */
void sleepTime(uint64_t seed);

/**_Thread_local uint64_t seed; */

/** Global counter for tickets given out */
int ticketGlob = 0;
/** Global counter for currently active ticket */
int currentTicket = 0;

/** Critical section mutex */
pthread_mutex_t secMutex;
/** Next ticket mutex */
pthread_mutex_t nTicketMutex;
/** Critical section condition */
pthread_cond_t secCond;

int main(int argc, char **argv)
{
	int N, M;
	int res, i;
	int threads_created = 0;
	struct timespec tval;
	pthread_t *threads;
	params_t *params;

	if (argc != 3) {
		printHelp();
		return EXIT_FAILURE;
	}

	N = atoi(argv[1]);
	M = atoi(argv[2]);

	if (N < 1 || M < 1) {
		printHelp();
		return EXIT_FAILURE;
	}

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

	threads = malloc(sizeof(pthread_t) * N);
	params = malloc(sizeof(params_t) * N);

	if (DEBUG) {
		printf("N number: %d\n",N);
		printf("M number: %d\n\n",M);

		printf("Ticket\tThread ID\n");
	}

	for (i = 0; i < N; i++) {
		params[i].m = M;
		/** Set thread id */
		params[i].thr_id = i + 1;
		/** Get monotonic time (random point in time)
		  * and use it as a seed for rand_r
		  */
		clock_gettime(CLOCK_MONOTONIC, &tval);
		params[i].time_seed = (long int)tval.tv_sec*1000000000L + tval.tv_nsec + i;
		res = pthread_create(&threads[i], NULL, thr, &params[i]);

		/** Check if the thread if created and note successfull creation
		  * This check is because of the Merlin server where number of processes
		  * is limited to 60
		  */
		if (res != 0) {
			perror("Error creating thread");
			continue;
		} else {
			threads_created++;
		}
	}

	/** Something really bad happened if we can't create even one thread */
	if (threads_created == 0) {
		pthread_mutex_destroy(&secMutex);
		pthread_mutex_destroy(&nTicketMutex);
		pthread_cond_destroy(&secCond);
		free(threads);
		free(params);
		perror("No threads were created");
		return EXIT_FAILURE;
	}

	/** Join only created threads
	  * Without this check it caused segfault on Merlin when N > 60
	  */
	for (i = 0; i < threads_created; i++) {
		if (DEBUG)
			printf("Joining thread %d\n", i);
		pthread_join(threads[i], NULL);
	}

	/** Cleanup */
	pthread_mutex_destroy(&secMutex);
	pthread_mutex_destroy(&nTicketMutex);
	pthread_cond_destroy(&secCond);
	free(threads);
	free(params);

	if (DEBUG)
		printf("Total threads created: %d\n",threads_created);

	/** Bye bye */
	return EXIT_SUCCESS;
}

void printHelp()
{
	char *helpText = "Hilfe I need help!\n"
					"POS Project #1 Ticket Algorithm\n"
					"Author: xstehl14 (Petr Stehlik) 2017\n"
					"./proj1 [N] [M]\n"
					"N - number of threads to create\n"
					"M - number of tickets available\n";
	printf("%s\n", helpText);
}

/** Retrieve a new unique ticket to access critical section */
int getticket(void)
{
	int ticket;
	pthread_mutex_lock(&nTicketMutex);
	ticket = ticketGlob++;
	pthread_mutex_unlock(&nTicketMutex);

	return ticket;
}

/** Entrance to critical section with given ticket */
void await(int aenter)
{
	pthread_mutex_lock(&secMutex);

	while(aenter != currentTicket) {
		/** I don't have the right ticket, signal others to try */
		pthread_cond_signal(&secCond);
		pthread_cond_wait(&secCond, &secMutex);
	}

	pthread_mutex_unlock(&secMutex);
}

/** Critical section and exit from it */
void advance(void)
{
	pthread_mutex_lock(&nTicketMutex);
	currentTicket++;

	/** Signal that another thread can advance */
	pthread_cond_signal(&secCond);
	pthread_mutex_unlock(&nTicketMutex);
}

/** Sleep for a given time between <0, 0.5> s
  * Uses given seed for randomizing times
  */
void sleepTime(uint64_t seed)
{
	struct timespec t;
	unsigned int useed;

	useed = (unsigned int)seed;

	t.tv_sec = 0;
	t.tv_nsec = (rand_r(&useed) % 500000000) + 1;
	if (DEBUG)
		printf("Sleeping for: %f\n", t.tv_nsec / 1000000000.0);
	nanosleep(&t, NULL);
}

/** Main function for thread using ticket algorithm */
void * thr(void *p)
{
	params_t *params = (params_t*)p;
	int ticket;

	/** Get a ticket for critical section */
	while ((ticket = getticket()) < params->m) {
		/** Random waiting in interval <0.0, 0.5> s */
		sleepTime(params->time_seed);

		/** Enter the critical section */
		await(ticket);
		printf("%d\t(%d)\n", ticket, params->thr_id);
		fflush(stdout);
		/** Exit the critical section and signal others */
		advance();

		/** Random waiting in interval <0.0, 0.5> s */
		sleepTime(params->time_seed);
	}

	return NULL;
}
/** And that's all, folks! */
