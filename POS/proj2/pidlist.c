/**
 * POS project #2: Simple shell implementation in POSIX C using two threads
 *
 * Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
 * Date: 2017/04/26
 *
 * File: pidlist.c
 */

#define _XOPEN_SOURCE 501
#include <stdio.h>
#include <sys/types.h>
#include <signal.h>
#include <unistd.h>
#include <sys/wait.h>

#include <stdlib.h>

#include "pidlist.h"

void pidlist_init(pidlist_t *p) {
	p->head = NULL;
	p->size = 0;
}

void pidlist_insert(pidlist_t *p, int pid) {
	piditem_t *i = NULL;
	i = malloc(sizeof(piditem_t));

	if (i == NULL) {
	    perror("failed to allocate");
	    exit(EXIT_FAILURE);
	}
	i->pid = pid;
	i->next = NULL;

    /**
      * First insert into list
      */
	if (p->size == 0) {
		p->head = i;
	} else {
		piditem_t *n;
		n = malloc(sizeof(piditem_t));
		n = p->head;

		while(n->next != NULL)
			n = n->next;

		n->next = i;
	}

	p->size++;
}

int pidlist_find(pidlist_t *p, int pid) {
	piditem_t *i;
	i = p->head;

	while(i != NULL) {
		if (i->pid == pid) {
			i = NULL;
			return 1;
		}

		i = i->next;
	}

	i = NULL;
	free(i);

	return 0;
}

int pidlist_remove(pidlist_t *p, int pid) {
	piditem_t *i;
	piditem_t *prev;

	i = p->head;
	prev = NULL;

	while (i != NULL) {
		if (i->pid == pid) {
			/** first item */
			if (prev == NULL)
				p->head = i->next;
			else
				prev->next = i->next;

            free(i);
            prev = NULL;
            p->size--;
			return 1;
		}
		prev = i;
		i = i->next;
	}

	i = NULL;
	prev = NULL;

	return 0;
}

void pidlist_print(pidlist_t *p) {
    piditem_t *i;

    i = p->head;
    printf("Total size: %d\n", p->size);
    while(i != NULL) {
        printf("PID: %d\n", i->pid);
        i = i->next;
    }

    i = NULL;
}

void pidlist_killall(pidlist_t *p) {
	piditem_t *i;
	i = p->head;

	while (i != NULL) {
		kill(i->pid, SIGTERM);
		i = i->next;
		/** Without this sleep somehow the SIGCHLD is not caught during ending procedure
		 *
		 * I know it is nasty and shouldn't be there but you know...
		 */
		sleep(1);
		fflush(stderr);
	}
	waitpid(-1, NULL, 0);
}
