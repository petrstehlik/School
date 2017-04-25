#include "pidlist.h"

void pidlist_init(pidlist_t *p) {
	p->head = NULL;
	p->size = 0;
}

void pidlist_insert(pidlist_t *p, int pid) {
	piditem_t *i;
	i = malloc(i, sizeof(piditem_t));
	i->pid = pid;
	i->next = NULL;

	if (p->size == 0) {
		p->head = i;
	} else {
		piditem_t *n;
		n = malloc(sizeof(piditem_t));
		n->next = p->head;

		while(n->next != NULL)
			n->next = n->next->next;

		n->next = i;
	}

	p->size++;
}

int pidlist_find(pidlist_t *p, int pid) {
	piditem_t *i;
	i = malloc(sizeof(piditem_t));

	i = p->head;

	while(i != NULL) {
		if (i->pid == pid)
			return 1;
	}

	return 0;
}

int pidlist_remove(pidlist_t *p, int pid) {
	piditem_t *i;
	i = malloc(sizeof(piditem_t));

	i = p->head;

	if (i->pid == pid) {
		p->head = i->next;
		free(i);
		return 1;
	}

	while(i != NULL) {
		if (i->next != NULL)
		if (i->pid == pid) {

			return 1;
		}
	}

	return 0;

}
