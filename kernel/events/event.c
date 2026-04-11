#include "event.h"

#define EVENT_QUEUE_SIZE 64

static evet_t queue[EVENT_QUEUE_SIZE];

static int head = 0;
static int tail = 0;

void event_init() {
    head = 0;
    tail = 0;
}

void event_pust(event_t event) {

    queue[tail] = event;

    tail = (tail + 1) % EVENT_QUEUE_SIZE;
}

int event_poll(event_t *event) {

    if (head == tail) {
        return 0;
    }

    *event = queue[head];

    head = (head + 1) % EVENT_QUEUE_SIZE;

    return 1;
}