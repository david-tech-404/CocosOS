#include "timer.h"
#include "event.h"

    event_t e;

    e.type = EVENT_TIMER;
    e.data1 = tick;

event_push(e)

static unsigned int ticks = 0;

void timer_tick(void) {
    ticks++;
}

void timer_init(void) {
    ticks = 0;
}