#ifndef LOG_H
#define LOG_H

extern char log_buffer[4096];
extern int log_index;

void  log_init();
void log_write(const char* msg);

void log_info(const char* msg);
void log_warn(const char* msg);
void log_error(const char* msg);

#endif