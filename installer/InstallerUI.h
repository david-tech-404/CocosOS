#ifndef INSTALLER_UI_H
#define INSTALLER_UI_H

#include <stdint.h>
#include <stdbool.h>

extern const char* INSTALLER_TITLE;
extern const char* INSTALLER_BG;
extern const char* INSTALLER_ACCENT;
extern const char* INSTALLER_TEXT;
extern const char* INSTALLER_BUTTON;
extern const char* INSTALLER_BUTTON_HOVER;

extern const int INSTALLER_PANEL_W;
extern const int INSTALLER_PANEL_H;

void init_installer_ui();
void render_installer_ui();
void handle_installer_action(const char* action);

void set_window_title(const char* title);
void set_window_size(int width, int height);
void set_background_color(const char* color);
void draw_text(int x, int y, const char* text, const char* color, int font_size);
void draw_button(int x, int y, int w, int h, const char* text, const char* action);
void draw_listbox(int x, int y, int w, int h, const char* id);
void draw_radio_group(int x, int y, const char* id);
void draw_checkbox(int x, int y, const char* text, bool checked);
void draw_progress_bar(int x, int y, int w, int h, int value, int max);

void start_installation();
void show_advanced_options();
void exit_installer();
void go_back();
void go_next();
void update_progress(int value, const char* status);

typedef struct {
    char name[64];
    char device[32];
    char type[16];
    uint64_t size;
    bool mounted;
} detected_os_t;

int detect_operating_systems(detected_os_t* os_list, int max_count);
void display_detected_os(detected_os_t* os, int count);


typedef struct {
    char device[32];
    char fs_type[16];
    uint64_t size;
    uint64_t used;
    uint64_t free;
    char mount_point[64];
} partition_info_t;

int get_partition_info(partition_info_t* partitions, int max_count);
bool format_partition(const char* device, const char* fs_type);
bool mount_partition(const char* device, const char* mount_point);
bool unmount_partition(const char* mount_point);

bool setup_luks(const char* device, const char* password);
bool open_luks(const char* device, const char* name, const char* password);
bool close_luks(const char* name);

#endif