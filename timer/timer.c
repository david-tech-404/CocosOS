#include "timer.h"
#include "event.h"
static unsigned int ticks = 0;
void timer_tick(void) {
    ticks++;
    event_t e;
    e.type = EVENT_TIMER;
    e.data1 = ticks;
    event_push(e);
}
void timer_init(void) {
    ticks = 0;
}