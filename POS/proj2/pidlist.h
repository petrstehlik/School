/**
 * POS project #2: Simple shell implementation in POSIX C using two threads
 *
 * \note: Simple linked list implementation
 *
 * Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
 * Date: 2017/04/26
 *
 * File: pidlist.h
 */

#ifndef PIDLIST_H
#define PIDLIST_H

/**
 * \brief PID item structure with pointer to next item
 */
typedef struct piditem {
	int pid;
	struct piditem *next;
} piditem_t;

/**
 * \brief Holds the linked list and info about its size
 */
typedef struct pidlist {
	piditem_t *head;
	int size;
} pidlist_t;

/**
 * \brief Initialize the pidlist_t structure
 */
void pidlist_init(pidlist_t *p);

/**
 * \brief Insert an item to the end of the list
 *
 * \note doesn't check for duplicates
 */
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

/**
 * \brief print the list
 */
void pidlist_print(pidlist_t *p);

/**
 * \brief Send SIGTERM to all PIDs present in the list
 */
void pidlist_killall(pidlist_t *p);
#endif
