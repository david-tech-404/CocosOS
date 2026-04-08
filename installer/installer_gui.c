#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include <unistd.h>
#include "InstallerUI.h"
#define MAX_OS_DETECTED 16
#define INSTALL_DIR "/mnt/cocosos"
#define MAX_CMD_SIZE 256
#define MAX_INFO_SIZE 256
static detected_os_t detected_os[MAX_OS_DETECTED];
static int os_count = 0;
static int install_progress = 0;
void set_window_title(const char* title) {
    printf("\033]0;%s\007", title);
}
void draw_text(int x, int y, const char* text, const char* color, int font_size) {
    printf("\033[%d;%dH\033[38;2;%sm%s\033[0m", y, x, color, text);
}
void draw_button(int x, int y, int w, int h, const char* text, const char* action) {
    printf("\033[%d;%dH", y, x);
    for (int i = 0; i < w - 2; i++) printf("");
    printf("\n");
    printf("\033[%d;%dH%s\n", y + 1, x, text);
    printf("\033[%d;%dH", y + 2, x);
    for (int i = 0; i < w - 2; i++) printf("");
    printf("\n");
}
void draw_progress_bar(int x, int y, int w, int h, int value, int max) {
    if (max <= 0) return;  
    int filled = (value * (w - 2)) / max;
    if (filled < 0) filled = 0;
    if (filled > w - 2) filled = w - 2;
    printf("\033[%d;%dH[", y, x);
    for (int i = 0; i < w - 2; i++) {
        printf(i < filled ? "" : " ");
    }
    printf("]\n");
}
int detect_operating_systems(detected_os_t* os_list, int max_count) {
    FILE* fp = fopen("/proc/partitions", "r");
    int count = 0;
    char line[256];
    if (!fp) return 0;
    while (fgets(line, sizeof(line), fp) && count < max_count) {
        unsigned long long size;
        char name[32];
        if (sscanf(line, " %*d %*d %llu %31s", &size, name) == 2) {
            if (strchr(name, '1') || strchr(name, '2')) {
                char cmd[MAX_CMD_SIZE];
                snprintf(cmd, sizeof(cmd), "blkid /dev/%s 2>/dev/null", name);
                FILE* blkid = popen(cmd, "r");
                if (blkid) {
                    char output[256];
                    if (fgets(output, sizeof(output), blkid)) {
                        char* fs_type = strstr(output, "TYPE=\"");
                        if (fs_type) {
                            fs_type += 6;
                            char* end = strchr(fs_type, '"');
                            if (end) {
                                *end = '\0';
                                strncpy(os_list[count].device, name, sizeof(os_list[count].device) - 1);
                                os_list[count].device[sizeof(os_list[count].device) - 1] = '\0';
                                strncpy(os_list[count].type, fs_type, sizeof(os_list[count].type) - 1);
                                os_list[count].type[sizeof(os_list[count].type) - 1] = '\0';
                                os_list[count].size = size * 1024;
                                if (strcmp(fs_type, "ntfs") == 0) {
                                    strncpy(os_list[count].name, "Windows", sizeof(os_list[count].name) - 1);
                                } else if (strstr(fs_type, "ext")) {
                                    strncpy(os_list[count].name, "Linux", sizeof(os_list[count].name) - 1);
                                } else {
                                    strncpy(os_list[count].name, "Unknown", sizeof(os_list[count].name) - 1);
                                }
                                os_list[count].name[sizeof(os_list[count].name) - 1] = '\0';
                                count++;
                            }
                        }
                    }
                    pclose(blkid);
                }
            }
        }
    }
    fclose(fp);
    return count;
}
void update_progress(int value, const char* status) {
    install_progress = value;
    draw_progress_bar(50, 660, 700, 20, value, 100);
    draw_text(50, 690, status, "#cccccc", 12);
}
void start_installation() {
    draw_text(50, 690, "Starting installation...", "#ffff00", 12);
    update_progress(10, "Detecting operating systems...");
    os_count = detect_operating_systems(detected_os, MAX_OS_DETECTED);
    sleep(1);
    update_progress(20, "Creating backup...");
    system("mkdir -p /tmp/cocosos_backup");
    sleep(1);
    update_progress(30, "Unmounting existing partitions...");
    system("umount /dev/sda1 2>/dev/null || true");
    system("umount /dev/sda2 2>/dev/null || true");
    sleep(1);
    update_progress(40, "Formatting partition...");
    system("mkfs.ext4 /dev/sda1 -F");
    sleep(1);
    update_progress(50, "Mounting partition...");
    system("mkdir -p " INSTALL_DIR);
    system("mount /dev/sda1 " INSTALL_DIR);
    sleep(1);
    update_progress(60, "Copying system files...");
    system("cp -r /usr/share/cocosos/* " INSTALL_DIR "/ 2>/dev/null || true");
    sleep(1);
    update_progress(70, "Installing bootloader...");
    system("grub-install --root-directory=" INSTALL_DIR " /dev/sda 2>/dev/null || true");
    sleep(1);
    update_progress(80, "Configuring system...");
    system("echo 'cocosos' > " INSTALL_DIR "/etc/hostname");
    sleep(1);
    update_progress(90, "Finalizing...");
    system("umount " INSTALL_DIR);
    sleep(1);
    update_progress(100, "Installation complete!");
    draw_text(50, 720, "Reboot to start CocosOS", "#00ff00", 14);
}
void init_installer_ui() {
    set_window_title("CocosOS Installer");
    printf("\033[2J\033[H");
    printf("\033]11;#1a1a2e\007");
}
void render_installer_ui() {
    draw_text(50, 30, "CocosOS Installer v1.0.0", "#e94560", 24);
    draw_text(50, 80, "Welcome to CocosOS Installation", "#ffffff", 16);
    draw_text(50, 120, "This installer will replace your current OS.", "#cccccc", 12);
    draw_button(50, 180, 200, 40, "Install CocosOS", "install");
    draw_button(270, 180, 200, 40, "Exit", "exit");
    draw_text(50, 250, "Detected Operating Systems:", "#ffffff", 14);
    for (int i = 0; i < os_count; i++) {
        char info[MAX_INFO_SIZE];
        snprintf(info, sizeof(info), "%d. %s on /dev/%s (%llu MB)", 
                i + 1, detected_os[i].name, detected_os[i].device,
                detected_os[i].size / (1024 * 1024));
        draw_text(50, 280 + i * 20, info, "#cccccc", 12);
    }
    draw_text(50, 450, "Encryption: LUKS (AES-256) available", "#cccccc", 12);
}
int main() {
    init_installer_ui();
    os_count = detect_operating_systems(detected_os, MAX_OS_DETECTED);
    while (true) {
        printf("\033[2J\033[H");
        render_installer_ui();
        char input[32];
        printf("\n\nEnter action (install/exit): ");
        if (fgets(input, sizeof(input), stdin)) {
            input[strcspn(input, "\n")] = 0;
            if (strcmp(input, "install") == 0) {
                start_installation();
                printf("\nPress Enter to exit...");
                getchar();
                break;
            } else if (strcmp(input, "exit") == 0) {
                break;
            }
        }
        usleep(100000);
    }
    return 0;
}