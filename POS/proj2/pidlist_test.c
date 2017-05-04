#include "pidlist.h"

int main(void) {
    pidlist_t p;
    pidlist_init(&p);

    pidlist_print(&p);

    pidlist_insert(&p, 125);
    pidlist_insert(&p, 124);
    pidlist_insert(&p, 122);
    pidlist_insert(&p, 121);
    pidlist_print(&p);
    printf("124 is present: %d\n", pidlist_find(&p, 121));

    pidlist_remove(&p, 124);
    printf("124 is present: %d\n", pidlist_find(&p, 124));

    pidlist_print(&p);

    return 0;
}
