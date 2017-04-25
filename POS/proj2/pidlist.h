#ifndef PIDLIST_H
#define PIDLIST_H

#include <stdlib.h>
#include <stdio.h>

typedef struct piditem {
	int pid;
	struct piditem *next;
} piditem_t;

typedef struct pidlist {
	piditem_t *head;
	int size;
} pidlist_t;

void pidlist_init(pidlist_t *p);
void pidlist_insert(pidlist_t *p, int pid);

/**
  * Find a given PID in the list
  *
  * \return number of records found (0 or 1)
  */
int pidlist_find(pidlist_t *p, int pid);

/**
  * Remove a given PID from the list
  *
  * \return number of records deleted (0 or 1)
  */
int pidlist_remove(pidlist_t *p, int pid);
/**void pidlist_free(pidlist_t *p);*/

void pidlist_print(pidlist_t *p);

#endif
