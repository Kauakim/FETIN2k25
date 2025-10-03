/**
 * @file gateway.h
 * @brief Definições e estruturas de dados para o Gateway.
 * 
 * @author João Pedro Maciel Freitas
 * @date 15 de julho de 2025
 */

#ifndef GATEWAY_H_
#define GATEWAY_H_

#include <stdint.h>

/**
 * @brief Estrutura do payload do beacon.
 */
typedef struct __attribute__((packed)) {
    uint16_t id_fabricante;   /**< ID do fabricante (0xFEFE). */
    uint32_t beacon_id;       /**< ID único do beacon. */
    char     beacon_type;     /**< Tipo de beacon ("P", "E", "R"). */
    uint8_t  beacon_status;   /**< Status do beacon (0: Livre, 1: Uso, 2: Carregando). */
} beacon_payload_t;

/**
 * @brief Estrutura para os dados do beacon a serem enviados para a fila.
 */
typedef struct {
    uint32_t beacon_id;
    char     beacon_type;
    uint8_t  beacon_status;
    int8_t   rssi;
} scanned_beacon_data_t;

#define BEACON_MANUFACTURER_ID 0xFEFE

#endif /* GATEWAY_H_ */


