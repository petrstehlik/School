#ifndef PIDLIST_H
#define PIDLIST_H

typedef struct {
	int pid;
	piditem_t *next;
} piditem_t;

typedef struct {
	piditem_t *head;
	int size;
} pidlist_t;

void pidlist_init(pidlist_t *p);
void pidlist_insert(pidlist_t *p, int pid);
int pidlist_remove(pidlist_t *p, int pid);
int pidlist_find(pidlist_t *p, int pid);
void pidlist_free(pidlist_t *p);

#endif
