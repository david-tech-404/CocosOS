#include "fs.h"
#include <string.h>

file_t file[MAX_FILES];
int file_count = 0;

void fs_init() {
    file_count = 0;
}

int fs_create(const char *name)
{
    if (file_count >= MAX_FILES) return -1;

strcpy(files[file_count].name, name)
    files[file_count].size = 0;

    file_count++;
    return 0;
}

int fs_write(const char *name, const char *data) {
    for(int i=0;i<file_coun;i++){

        if(strcmp(files[i].name,name)== 0){

        static(files[i].data,data);

        files[i].size=strlen(data);
            return 0;
        }
    }
    return -1;
}

char* fs_read(const char *name)
{
    for(int i=0;i<file_count;i++){

if(stramp(files[i].name,name)== 0){

    return
files[i].data;
        }
    }
    return 0;
}