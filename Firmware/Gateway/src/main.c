/**
 * @file main.c
 * @brief Firmware principal para o Gateway (ESP32-S3) com NimBLE.
 * @note Versão corrigida com inicialização de NVS e ordem de boot otimizada.
 * @author João Pedro 
 * @date 20 de Agosto de 2025
 */

#include <stdio.h>
#include <string.h>
#include <time.h>

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"
#include "esp_log.h"
#include "nvs_flash.h" 

#include "wifi_manager.h"
#include "gateway.h" 
#include "http_client_manager.h"
#include "cJSON.h"

#include "esp_nimble_hci.h"
#include "nimble/nimble_port.h"
#include "nimble/nimble_port_freertos.h"
#include "host/ble_hs.h"
#include "host/util/util.h"

#include "esp_bt.h"
#include "services/gap/ble_svc_gap.h"
#include "services/gatt/ble_svc_gatt.h"

#include "ble_scanner.h"
#include "esp_bt.h"

// @brief ID deste gateway para o backend
#define GATEWAY_ID 2
// @brief Endpoint para envio do JSON com os dados
#define HTTP_POST_ENDPOINT "http://192.168.0.150:5501/rssi"
// @brief Tempo de envio para cada JSON
#define REQ_POST_TIME 7500
// @brief Tamanho máximo da Fila
#define BLE_QUEUE_LENGTH 50

static const char *TAG = "GATEWAY_APP_2";

QueueHandle_t beacon_data_queue;




// Função para traduzir o status do beacon
const char* get_status_string(uint8_t status_code) {
    if (status_code == 0) return "disponivel";
    if (status_code == 1) return "em uso";
    if (status_code == 2) return "carregando";
    // Adicione outros status se necessário
    return "desconhecido";
}

const char* get_id_string(uint8_t status_code) {
    if (status_code == 1) return "Multimetro";
    if (status_code == 2) return "Kit de reparos";
    if (status_code == 3) return "Estanho";
    if (status_code == 4) return "Filamento";
    if (status_code == 5) return "Chapa de material";
    // Adicione outros status se necessário
    return "desconhecido";
}

// Função para traduzir o tipo do beacon
const char* get_type_string(char type_char) {
    if (type_char == 'E') return "ferramenta";
    if (type_char == 'R') return "material";
    if (type_char == 'P') return "pessoa";
    return "desconhecido";
}

/**
 * @brief Tarefa FreeRTOS que coleta dados da fila, monta um JSON e envia via HTTP POST.
 *  Esta tarefa roda em um loop infinito, aguardando dados de beacons na
 * `beacon_data_queue`. A cada 3 segundos, ela agrupa todos os dados
 * pendentes em um único payload JSON e o envia para o servidor.
 *  @param pvParameters Parâmetro padrão para tarefas FreeRTOS, não utilizado aqui.
 */
void httpClientTask(void *pvParameters) {
    ESP_LOGI(TAG, "HTTP Client Task rodando no Core %d", xPortGetCoreID());
    scanned_beacon_data_t received_data;

    // Estrutura auxiliar para acumular RSSI
    typedef struct {
        uint32_t beacon_id;
        char beacon_type;
        uint8_t beacon_status;
        int rssi_sum;
        int rssi_count;
    } aggregated_beacon_t;

    aggregated_beacon_t latest_beacons[50];
    size_t beacon_count = 0;

    while (true) {
        vTaskDelay(pdMS_TO_TICKS(REQ_POST_TIME));
        beacon_count = 0;

        // Zera os acumuladores
        memset(latest_beacons, 0, sizeof(latest_beacons));

        // Coleta todos os dados da fila durante o período
        while (xQueueReceive(beacon_data_queue, &received_data, 0) == pdPASS) {
            bool updated = false;

            for (size_t i = 0; i < beacon_count; i++) {
                if (latest_beacons[i].beacon_id == received_data.beacon_id) {
                    latest_beacons[i].rssi_sum += received_data.rssi;
                    latest_beacons[i].rssi_count++;
                    updated = true;
                    break;
                }
            }

            if (!updated && beacon_count < (sizeof(latest_beacons) / sizeof(latest_beacons[0]))) {
                latest_beacons[beacon_count].beacon_id = received_data.beacon_id;
                latest_beacons[beacon_count].beacon_type = received_data.beacon_type;
                latest_beacons[beacon_count].beacon_status = received_data.beacon_status;
                latest_beacons[beacon_count].rssi_sum = received_data.rssi;
                latest_beacons[beacon_count].rssi_count = 1;
                beacon_count++;
            }
        }

        // Monta o JSON
        cJSON *root = cJSON_CreateObject();
        cJSON *gateways_obj = cJSON_CreateObject();
        cJSON_AddItemToObject(root, "Gateways", gateways_obj);

        for (size_t i = 0; i < beacon_count; i++) {
            cJSON *beacon_data = cJSON_CreateObject();

            char beacon_str[20];
            
            cJSON_AddStringToObject(beacon_data, "beacon", get_id_string(latest_beacons[i].beacon_id));

            cJSON_AddStringToObject(beacon_data, "status", get_status_string(latest_beacons[i].beacon_status));
            
            cJSON_AddStringToObject(beacon_data, "tipo", get_type_string(latest_beacons[i].beacon_type));
            cJSON_AddNumberToObject(beacon_data, "gateway", GATEWAY_ID);

            // Agora enviamos a MÉDIA do RSSI
            int avg_rssi = latest_beacons[i].rssi_sum / latest_beacons[i].rssi_count;
            cJSON_AddNumberToObject(beacon_data, "rssi", avg_rssi);

            cJSON_AddNumberToObject(beacon_data, "utc", (double)time(NULL));

            char key_str[10];
            sprintf(key_str, "%zu", i + 1);
            cJSON_AddItemToObject(gateways_obj, key_str, beacon_data);
        }

        if (beacon_count > 0) {
            char *json_string = cJSON_PrintUnformatted(root);
            ESP_LOGI(TAG, "Enviando JSON: %s", json_string);

            esp_err_t err = http_post_json(HTTP_POST_ENDPOINT, json_string);
            if (err != ESP_OK) {
                ESP_LOGE(TAG, "Falha ao enviar requisição HTTP POST");
            }
            free(json_string);
        } else {
            ESP_LOGI(TAG, "Nenhum beacon na fila para enviar.");
        }

        cJSON_Delete(root);
    }
}


/**
 * @brief Ponto de entrada principal da aplicação.
 * Esta função é chamada após o boot do ESP32. Ela realiza a sequência de
 * inicialização crítica do sistema:
 * 1. Inicializa o armazenamento NVS.
 * 2. Inicia a conexão Wi-Fi.
 * 3. Cria a fila de comunicação inter-tarefas.
 * 4. Inicializa o scanner NimBLE.
 * 5. Cria a tarefa httpClientTask para processar e enviar os dados.
 */
void app_main(void) {

    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        ESP_ERROR_CHECK(nvs_flash_erase());
        ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);

    wifi_init_sta();

    beacon_data_queue = xQueueCreate(BLE_QUEUE_LENGTH, sizeof(scanned_beacon_data_t));
    if (beacon_data_queue == NULL) {
        ESP_LOGE(TAG, "Falha ao criar a fila de dados.");
        return;
    }

    ble_scanner_init();

    xTaskCreatePinnedToCore(httpClientTask, "httpClientTask", 4096, NULL, 5, NULL, 1);

    ESP_LOGI(TAG, "Inicialização completa. Gateway operacional.");
}

 