#include "wifi.h"
#include <string.h>
#include <stdio.h>

static wifi_device_t* devices = 0;
static wifi_device_t* default_dev = 0;
static wifi_state_t global_state = WIFI_STATE_DISABLED;

void wifi_init(void) {
    global_state = WIFI_STATE_INITIALIZING;
    devices = 0;
    default_dev = 0;
    global_state = WIFI_STATE_DISCONNECTED;
}

int wifi_register(wifi_device_t* dev) {
    if (!dev) return -1;
    
    dev->next = devices;
    devices = dev;
    
    if (!default_dev) {
        default_dev = dev;
    }
    
    return 0;
}

wifi_device_t* wifi_get_default(void) {
    return default_dev;
}

int wifi_scan(wifi_network_t* results, int max_results) {
    if (!default_dev) return -1;
    if (!default_dev->scan) return -1;
    if (global_state != WIFI_STATE_DISCONNECTED) return -1;
    
    global_state = WIFI_STATE_SCANNING;
    int count = default_dev->scan(default_dev, results, max_results);
    global_state = WIFI_STATE_DISCONNECTED;
    
    return count;
}

int wifi_connect(const char* ssid, const char* password) {
    if (!default_dev) return -1;
    if (!default_dev->connect) return -1;
    if (!ssid) return -1;
    
    global_state = WIFI_STATE_CONNECTING;
    int res = default_dev->connect(default_dev, ssid, password);
    
    if (res == 0) {
        global_state = WIFI_STATE_CONNECTED;
    } else {
        global_state = WIFI_STATE_DISCONNECTED;
    }
    
    return res;
}

void wifi_disconnect(void) {
    if (!default_dev) return;
    if (!default_dev->disconnect) return;
    
    default_dev->disconnect(default_dev);
    global_state = WIFI_STATE_DISCONNECTED;
}

wifi_state_t wifi_get_state(void) {
    return global_state;
}