/**
 * @file ble_scanner.c
 * @brief Implementação do gerenciador de escaneamento BLE para o Gateway.
 *
 * @author João Pedro
 * @date 23 de julho de 2025
 */

#include "ble_scanner.h"
#include "gateway.h"
#include "esp_log.h"
#include "esp_nimble_hci.h"
#include "nimble/nimble_port.h"
#include "nimble/nimble_port_freertos.h"
#include "host/ble_hs.h"
#include "host/util/util.h"

static const char *TAG = "BLE_SCANNER";

// Fila definida em outro ponto do sistema (main.c)
extern QueueHandle_t beacon_data_queue;

// Protótipos
static void ble_start_scan(void);
static void ble_on_sync(void);
static void host_task(void *param);

/**
 * @brief Callback para eventos de escaneamento BLE.
 *
 * Processa eventos de descoberta, extrai campos do payload e envia dados válidos para a fila.
 *
 * @param event Evento recebido da pilha BLE.
 * @param arg Argumento genérico (não utilizado).
 * @return Sempre 0 (evento processado).
 */
int ble_scan_cb(struct ble_gap_event *event, void *arg) {
    
    switch (event->type) {

        case BLE_GAP_EVENT_DISC: {
            struct ble_hs_adv_fields fields;
            int rc = ble_hs_adv_parse_fields(&fields, event->disc.data, event->disc.length_data);
            if (rc != 0) {
                ESP_LOGW(TAG, "Erro ao fazer parse do advertising BLE: rc=%d", rc);
                return 0;
            }

            // Log do payload bruto para debug
            if (fields.mfg_data && fields.mfg_data_len > 0) {
                
                
                // Primeiro verifica se tem o ID do fabricante correto
                if (fields.mfg_data_len >= 2) {
                    uint16_t *id_fabricante = (uint16_t *)fields.mfg_data;
                    if (*id_fabricante == BEACON_MANUFACTURER_ID) {
                       // ESP_LOGI(TAG, "Beacon FETIN detectado! ID Fabricante: 0x%04X", *id_fabricante);
                        
                        // Verifica se o tamanho do payload está correto
                        if (fields.mfg_data_len == sizeof(beacon_payload_t)) {
                            beacon_payload_t *payload = (beacon_payload_t *)fields.mfg_data;
                            
                            scanned_beacon_data_t data = {
                                .beacon_id = payload->beacon_id,
                                .beacon_type = payload->beacon_type,
                                .beacon_status = payload->beacon_status,
                                .rssi = event->disc.rssi
                            };

                            ESP_LOGI(TAG, "Beacon válido: ID=%lu, Tipo='%c', Status=%u, RSSI=%d",
                                     (unsigned long)data.beacon_id, data.beacon_type, data.beacon_status, data.rssi);

                            if (xQueueSend(beacon_data_queue, &data, 0) != pdPASS) {
                                ESP_LOGW(TAG, "Fila cheia - beacon descartado");
                            }
                        } else {
                            ESP_LOGW(TAG, "Tamanho do payload incorreto: %d bytes (esperado: %d)", 
                                     fields.mfg_data_len, sizeof(beacon_payload_t));
                        }
                    }
                }
            }

            
            break;
        }

        case BLE_GAP_EVENT_DISC_COMPLETE:
            ESP_LOGW(TAG, "Scan BLE encerrado. Reiniciando...");
            ble_start_scan();  // Reinicia automaticamente
            break;

        default:
            break;
    }

    return 0;
}

/**
 * @brief Inicia o escaneamento BLE contínuo (modo passivo).
 */
static void ble_start_scan(void)
{
    ESP_LOGI(TAG, "Iniciando scan BLE...");

    struct ble_gap_disc_params scan_params = {
        .itvl = 0x0010,     // Intervalo de scan (0x0010 = 10ms)
        .window = 0x0010,   // Janela de scan (tempo ativo dentro do intervalo)
        .filter_policy = 0, // Aceita todos os anúncios
        .limited = 0,       // Scaneamento geral, não limitado
        .passive = 1        // Scan passivo (não envia requests)
    };

    int rc = ble_gap_disc(BLE_OWN_ADDR_PUBLIC, BLE_HS_FOREVER, &scan_params, ble_scan_cb, NULL);

    if (rc != 0) {
        ESP_LOGE(TAG, "Falha ao iniciar scan BLE: código %d (%s)", rc, esp_err_to_name(rc));
    } else {
        ESP_LOGI(TAG, "Scan BLE iniciado com sucesso.");
    }
}

/**
 * @brief Callback chamado quando o host BLE sincroniza com o controlador.
 */
static void ble_on_sync(void) {
    ESP_LOGI(TAG, "Host BLE sincronizado.");
    ble_start_scan();
}

/**
 * @brief Tarefa principal da pilha NimBLE. Executa o loop do host BLE.
 *
 * @param param Argumento não utilizado.
 */
static void host_task(void *param) {
    ESP_LOGI(TAG, "Tarefa BLE Host iniciada.");
    nimble_port_run();
    nimble_port_freertos_deinit();
}

/**
 * @brief Inicializa o gerenciador de escaneamento BLE e a pilha NimBLE.
 */
void ble_scanner_init(void) {
    nimble_port_init();
    esp_err_t ret = esp_nimble_hci_init();
    if (ret != ESP_OK) {
        ESP_LOGE(TAG, "Erro ao inicializar HCI: %s", esp_err_to_name(ret));
        return;
    }

    ble_hs_cfg.sync_cb = ble_on_sync;
    nimble_port_freertos_init(host_task);
}

