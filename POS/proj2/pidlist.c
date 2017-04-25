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
	i = malloc(sizeof(piditem_t));

	i = p->head;

	while(i != NULL) {
		if (i->pid == pid)
			return 1;

		i = i->next;
	}

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
            p->size--;
			return 1;
		}
		prev = i;
		i = i->next;
	}

	return 0;
}

void pidlist_print(pidlist_t *p) {
    piditem_t *i;
    i = malloc(sizeof(piditem_t));

    i = p->head;
    printf("Total size: %d\n", p->size);
    while(i != NULL) {
        printf("PID: %d\n", i->pid);
        i = i->next;
    }
}
