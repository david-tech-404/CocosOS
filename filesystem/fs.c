#include "fs.h"
#include <string.h>

file_t files[MAX_FILES];
int file_count = 0;

void fs_init() {
    file_count = 0;
}

int fs_create(const char *name)
{
    if (!name) return -1;
    if (strlen(name) >= MAX_FILENAME) return -1;
    if (file_count >= MAX_FILES) return -1;

    strcpy(files[file_count].name, name);
    files[file_count].size = 0;

    file_count++;
    return 0;
}

int fs_write(const char *name, const char *data) {
    if (!name || !data) return -1;
    if (strlen(data) >= MAX_FILE_SIZE) return -1;
    
    for(int i = 0; i < file_count; i++) {
        if(strcmp(files[i].name, name) == 0) {
            strcpy(files[i].data, data);
            files[i].size = strlen(data);
            return 0;
        }
    }
    return -1;
}

char* fs_read(const char *name)
{
    if (!name) return NULL;
    
    for(int i = 0; i < file_count; i++) {
        if(strcmp(files[i].name, name) == 0) {
            return files[i].data;
        }
    }
    return 0;
}
