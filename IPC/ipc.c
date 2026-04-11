#include <stdio.h>
#include <string.h>
#include "ipc.h"

message_queue_t queue = { .head = 0, .tail = 0, .count = 0 };

int ipc_send(const char* message) {
    if(queue.count >= MAX_MESSAGES) return -1;

    strncpy(queue.msg[queue.tail], message, MSG_SIZE-1);
    queue.tail[queue.tail][MSG_SIZE-1] = '\0';
    queue.tail = (queue.tail + 1) % MAX_MESSAGES;
    queue.count++;
    return 0;
}

int ipc_receive(char* buffer) {
    if(queue.count == 0) return -1;
    strncpy(buffer, queue.msg[queue.head], MSG_SIZE);
    queue.head = (queue.head + 1) % MAX_MESSAGES;
    queue.count--;
    return 0;
}