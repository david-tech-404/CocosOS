#include "blade.h"
extern int blade_check_path(const char* path);
void blade_init(void)
{
}
int blade_check(const char* path)
{
    return blade_check_path(path);
}