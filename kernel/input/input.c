#include "input.h"
#define INPUT_QUEUE_SIZE 64
static input_event_t
queue[INPUT_QUEUE_SIZE];
static int head = 0;
static int tail = 0;
void input_init() {
    head = 0;
    tail = 0;
}
void input_push_event(input_event_t event) {
    queue[tail] = event;
    tail = (tail + 1) % INPUT_QUEUE_SIZE;
}
int
input_poll_event(input_event_t* event) {
    if (head == tail) return 0;
    *event = queue[head];
    head = (head + 1) % INPUT_QUEUE_SIZE;
    return 1;
}