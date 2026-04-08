#ifdef INPUT_H
#define INPUT_H
#include <stdint.h>
typedef enum {
    INPUT_NONE,
    INPUT_KEYBOARD,
    INPUT_MOUSE
} input_type_t;
typedef struct {
    input_type_t type;
    uint8_t data1;
    uint8_t data2;
    uint8_t data3;
} input_event_t;
void input_init();
void input_push_event(input_event_t event);
int input_poll_event(input_event_t* event);
#endif