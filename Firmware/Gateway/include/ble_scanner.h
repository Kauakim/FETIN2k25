/**
 * @file ble_scanner.h
 * @brief Gerenciador de escaneamento BLE para o Gateway.
 *
 * @author Manus
 * @date 23 de julho de 2025
 */

#ifndef BLE_SCANNER_H_
#define BLE_SCANNER_H_

#include "freertos/FreeRTOS.h"
#include "freertos/queue.h"
#include "host/ble_hs.h"

// Definição da fila de dados do beacon, extern para ser acessível em main.c
extern QueueHandle_t beacon_data_queue;

/**
 * @brief Inicializa a pilha NimBLE e as tarefas de escaneamento BLE.
 *
 * Esta função deve ser chamada para configurar e iniciar o escaneamento BLE.
 * Ela cria a tarefa do host BLE e inicia o processo de escaneamento.
 */
void ble_scanner_init(void);

/**
 * @brief Callback para eventos de escaneamento BLE.
 *
 * Esta função é chamada pela pilha NimBLE sempre que um evento de escaneamento ocorre.
 * Ela filtra os anúncios, faz o parsing do payload e envia os dados para a fila.
 *
 * @param event Ponteiro para a estrutura do evento BLE GAP.
 * @param arg Argumento genérico (não utilizado).
 * @return 0 se o evento foi processado com sucesso.
 */
int ble_scan_cb(struct ble_gap_event *event, void *arg);

#endif /* BLE_SCANNER_H_ */


