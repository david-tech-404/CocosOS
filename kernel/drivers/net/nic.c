#include "nic.h"
#include "../../kernel.h"
#include "../../log.h"
#include "../Io/io.h"

static nic_device_t* nic_list = NULL;
static nic_device_t* default_nic = NULL;

void net_init(void)
{
    log_info("Inicializando stack de red...");
    nic_list = NULL;
    default_nic = NULL;
    
    log_info("Stack de red listo");
}

int nic_register(nic_device_t* dev)
{
    if (!dev) return -1;
    
    dev->next = nic_list;
    nic_list = dev;
    
    if (dev->init) {
        int res = dev->init(dev);
        if (res != 0) {
            log_error("Fallo al inicializar NIC %s", dev->name);
            return res;
        }
    }
    
    log_info("NIC registrado: %s", dev->name);
    
    if (!default_nic) {
        default_nic = dev;
        log_info("Establecido como NIC predeterminado");
    }
    
    return 0;
}

nic_device_t* nic_get_default(void)
{
    return default_nic;
}

int net_send_frame(uint8_t* dest_mac, uint16_t ethertype, uint8_t* payload, uint32_t len)
{
    if (!default_nic || !default_nic->send) return -1;
    if (len > ETH_FRAME_MAX - 14) return -2;
    
    uint8_t frame[ETH_FRAME_MAX];
    
    for (int i = 0; i < 6; i++) frame[i] = dest_mac[i];
    for (int i = 0; i < 6; i++) frame[6+i] = default_nic->mac.bytes[i];
    frame[12] = (ethertype >> 8) & 0xFF;
    frame[13] = ethertype & 0xFF;
    
    for (uint32_t i = 0; i < len; i++) {
        frame[14 + i] = payload[i];
    }
    
    return default_nic->send(default_nic, frame, 14 + len);
}

void net_poll(void)
{
    nic_device_t* current = nic_list;
    while (current) {
        if (current->recv) {
            uint8_t buffer[ETH_FRAME_MAX];
            int received = current->recv(current, buffer, ETH_FRAME_MAX);
            if (received > 0) {
                log_info("Recibido paquete de %d bytes", received);
            }
        }
        current = current->next;
    }
}
