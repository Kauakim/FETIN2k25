/*
 * =================================================================================================
 * FIRMWARE DO BEACON PARA PROJETO FETIN - VERSÃO FUNCIONAL AUTOCONTIDA
 * =================================================================================================
 * Placa Alvo: ESP32-C3
 * Framework: ESP-IDF
 * Pilha BLE: NimBLE
 *
 * Funcionalidades:
 * 1. Anuncia pacotes BLE de forma não conectável.
 * 2. Usa um payload customizado para ser reconhecido pelo Gateway.
 * 3. Opera em modo Deep Sleep para economizar energia.
 * 4. Fornece feedback visual com o LED embutido.
 * 5. Possui um modo contínuo para facilitar testes.
 * =================================================================================================
 */

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_system.h"
#include "esp_log.h"
#include "nvs_flash.h"
#include "esp_sleep.h"
#include <inttypes.h>
#include "driver/gpio.h" // Para controlar o LED

// Includes da pilha NimBLE
#include "nimble/nimble_port.h"
#include "nimble/nimble_port_freertos.h"
#include "host/ble_hs.h"
#include "host/util/util.h"
#include "services/gap/ble_svc_gap.h"



// Tag para os logs
static const char *TAG = "FETIN_BEACON";

// Variável para guardar nosso tipo de endereço BLE
static uint8_t own_addr_type;

// =================================================================================================
// CONFIGURAÇÕES DO BEACON - MODIFIQUE AQUI
// =================================================================================================

#define BLINK_GPIO 8

#define MODO_CONTINUO 0

#define DEEP_SLEEP_SEGUNDOS 2

// --- Definições do Payload Customizado ---
#define ID_FABRICANTE           0xFEFE
#define ID_BEACON_ATUAL         5   // Mude este valor para cada beacon (1, 2, 3...)
#define TIPO_BEACON             'R'    // 'P' - Pessoa, 'E' - Equipamento, 'R' - Produto
#define STATUS_ATUAL            0    // 0: Livre, 1: Em Uso, 2: Carregando
#define NOME_DISPOSITIVO_BLE    "material-5-D"

// =================================================================================================
// ESTRUTURA DO PACOTE DE DADOS (PAYLOAD)
// =================================================================================================
typedef struct __attribute__((packed)) {
    uint16_t id_fabricante;
    uint32_t beacon_id;
    char     beacon_type;
    uint8_t  beacon_status;
} beacon_payload_t;

static beacon_payload_t dados_beacon;

// Protótipos de função
static void ble_app_advertise(void);
static void configure_led(void);
static void blink_led(void);

// Função para piscar o LED por 1 segundo
static void blink_led(void) {
    gpio_set_level(BLINK_GPIO, 1);
    vTaskDelay(1000 / portTICK_PERIOD_MS);
    gpio_set_level(BLINK_GPIO, 0);
}

// Função para configurar o pino do LED como saída
static void configure_led(void) {
    gpio_reset_pin(BLINK_GPIO);
    gpio_set_direction(BLINK_GPIO, GPIO_MODE_OUTPUT);
}

// Função chamada quando a sincronização da pilha BLE está completa
static void ble_app_on_sync(void) {
    int rc;
    ESP_LOGI(TAG, ">>> Sincronização da pilha BLE completa.");
    rc = ble_hs_id_infer_auto(0, &own_addr_type);
    if (rc != 0) {
        ESP_LOGE(TAG, "Erro ao inferir endereço local; rc=%d", rc);
        return;
    }
    ble_app_advertise();
}

// Função principal para configurar e iniciar o advertising BLE
static void ble_app_advertise(void) {
    struct ble_gap_adv_params adv_params;
    struct ble_hs_adv_fields fields;
    int rc;

    ESP_LOGI(TAG, ">>> Configurando o pacote de Advertisement...");

    dados_beacon.id_fabricante = ID_FABRICANTE;
    dados_beacon.beacon_id     = ID_BEACON_ATUAL;
    dados_beacon.beacon_type   = TIPO_BEACON;
    dados_beacon.beacon_status = STATUS_ATUAL;

    memset(&fields, 0, sizeof(fields));
    fields.flags = BLE_HS_ADV_F_DISC_GEN | BLE_HS_ADV_F_BREDR_UNSUP;
    fields.name = (uint8_t *)NOME_DISPOSITIVO_BLE;
    fields.name_len = strlen(NOME_DISPOSITIVO_BLE);
    fields.name_is_complete = 1;
    fields.mfg_data = (uint8_t *)&dados_beacon;
    fields.mfg_data_len = sizeof(dados_beacon);

    ESP_LOGI(TAG, "----------------------------------------------------");
    ESP_LOGI(TAG, "Payload a ser enviado: ID=%lu, Tipo='%c', Status=%u",
             (unsigned long)dados_beacon.beacon_id, dados_beacon.beacon_type, dados_beacon.beacon_status);
    ESP_LOGI(TAG, "----------------------------------------------------");

    rc = ble_gap_adv_set_fields(&fields);
    if (rc != 0) {
        ESP_LOGE(TAG, "Erro ao configurar os campos do advertisement; rc=%d", rc);
        return;
    }

    memset(&adv_params, 0, sizeof(adv_params));
    adv_params.conn_mode = BLE_GAP_CONN_MODE_NON;
    adv_params.disc_mode = BLE_GAP_DISC_MODE_GEN;

    rc = ble_gap_adv_start(own_addr_type, NULL, BLE_HS_FOREVER, &adv_params, NULL, NULL);
    if (rc != 0) {
        ESP_LOGE(TAG, "Erro ao iniciar o advertisement; rc=%d", rc);
        return;
    }
    ESP_LOGI(TAG, "====================================================");
    ESP_LOGI(TAG, "|| SUCESSO! Beacon está anunciando ativamente.  ||");
    ESP_LOGI(TAG, "====================================================");
    blink_led();
}

// Tarefa principal do Host NimBLE
void ble_host_task(void *param) {
    nimble_port_run();
}

// Função de entrada do programa
void app_main(void) {
    configure_led();
    ESP_LOGI(TAG, "--- Beacon FETIN Iniciando Ciclo ---");
    blink_led();

    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        ESP_ERROR_CHECK(nvs_flash_erase());
        ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);

    nimble_port_init();
    ble_svc_gap_device_name_set(NOME_DISPOSITIVO_BLE);
    ble_hs_cfg.sync_cb = ble_app_on_sync;
    nimble_port_freertos_init(ble_host_task);

    #if MODO_CONTINUO == 0
        // Aguarda um tempo para garantir que o anúncio foi enviado
        vTaskDelay(pdMS_TO_TICKS(500));
        ESP_LOGW(TAG, "O beacon irá dormir. Piscando para avisar...");
        blink_led();
        
        // Entra em Deep Sleep
        esp_sleep_enable_timer_wakeup(DEEP_SLEEP_SEGUNDOS * 1000000);
        esp_deep_sleep_start();
    #endif
}
