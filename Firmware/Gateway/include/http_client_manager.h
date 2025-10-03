
/**
 * @file http_client_manager.h
 * @brief Gerenciador de cliente HTTP para o Gateway.
 * 
 * @author Manus
 * @date 15 de julho de 2025
 */

#ifndef HTTP_CLIENT_MANAGER_H_
#define HTTP_CLIENT_MANAGER_H_

#include <esp_http_client.h>

/**
 * @brief Envia uma requisição HTTP POST com um corpo JSON.
 * 
 * @param url URL do endpoint.
 * @param json_data String JSON a ser enviada no corpo da requisição.
 * @return esp_err_t ESP_OK em caso de sucesso, ou um código de erro em caso de falha.
 */
esp_err_t http_post_json(const char *url, const char *json_data);

#endif /* HTTP_CLIENT_MANAGER_H_ */


