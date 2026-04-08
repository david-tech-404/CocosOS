#ifndef IPC_H
#define IPC_H
#define MAX_MESSAGES 20
#define MSG_SIZE 128
typedef struct {
    char msg[MAX_MESSAGES] [MSG_SIZE];
    int head;
    int tail;
    int count;
} message_queue_t;
int ipc_send(const char* message);
int ipc_receive(char* buffer);
#endif