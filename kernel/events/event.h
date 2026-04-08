#ifndef EVENT_H
#define EVENT_T
#include <stdint.h>
#define EVENT_KEY 1
#define EVENT_MOUSE 2
#define EVENT_TIMER 3
typedef struct {
    uint32_t type;
    uint32_t data1;
    uint32_t data2;
} event_t;
void event_init();
void event_push(event_t event);
int event_poll(event_t *event);
#endif