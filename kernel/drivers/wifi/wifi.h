#ifndef WIFI_H
#define WIFI_H

#include <stdint.h>
#include <stdbool.h>
#include "../net/nic.h"

#define WIFI_SSID_MAX_LEN 32
#define WIFI_KEY_MAX_LEN  64

typedef enum {
    WIFI_STATE_DISABLED,
    WIFI_STATE_INITIALIZING,
    WIFI_STATE_DISCONNECTED,
    WIFI_STATE_SCANNING,
    WIFI_STATE_CONNECTING,
    WIFI_STATE_CONNECTED,
    WIFI_STATE_ERROR
} wifi_state_t;

typedef struct {
    char ssid[WIFI_SSID_MAX_LEN + 1];
    uint8_t bssid[6];
    int channel;
    int signal_strength;
    bool encrypted;
} wifi_network_t;

typedef struct wifi_device {
    char* name;
    wifi_state_t state;
    nic_device_t nic;
    
    int  (*scan)(struct wifi_device* dev, wifi_network_t* results, int max_results);
    int  (*connect)(struct wifi_device* dev, const char* ssid, const char* password);
    void (*disconnect)(struct wifi_device* dev);
    int  (*get_rssi)(struct wifi_device* dev);
    
    struct wifi_device* next;
} wifi_device_t;

void wifi_init(void);
int  wifi_register(wifi_device_t* dev);
wifi_device_t* wifi_get_default(void);
int  wifi_scan(wifi_network_t* results, int max_results);
int  wifi_connect(const char* ssid, const char* password);
void wifi_disconnect(void);
wifi_state_t wifi_get_state(void);

#endif
