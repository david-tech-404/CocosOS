#ifndef FS_H
#define FS_H
#define MAX_FILES 32
#define MAX_FILENAME 32
#define MAX_FILE_SIZE 1024
typedef struct {
    char name[MAX_FILENAME];
    char data[MAX_FILE_SIZE];
    int size;
} file_t;
void fs_init();
int fs_create(const char *name);
int fs_write(const char *name, const char *data);
char* fs_read(const char *name);
#endif