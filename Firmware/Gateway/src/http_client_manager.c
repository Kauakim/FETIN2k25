/**
 * @file http_client_manager.c
 * @brief Implementação do gerenciador de cliente HTTP para o Gateway.
 * 
 * @author João Pedro
 * @date 15 de julho de 2025
 */

#include "http_client_manager.h"
#include "esp_log.h"
#include "esp_http_client.h"

static const char *TAG = "HTTP_CLIENT";

/**
 * @brief Manipulador de eventos HTTP.
 * 
 * @param evt Ponteiro para a estrutura de evento HTTP.
 * @return esp_err_t ESP_OK em caso de sucesso.
 */
esp_err_t _http_event_handler(esp_http_client_event_t *evt)
{
    switch(evt->event_id) {
        case HTTP_EVENT_ERROR:
            ESP_LOGE(TAG, "HTTP_EVENT_ERROR");
            break;
        case HTTP_EVENT_ON_CONNECTED:
            ESP_LOGD(TAG, "HTTP_EVENT_ON_CONNECTED");
            break;
        case HTTP_EVENT_HEADER_SENT:
            ESP_LOGD(TAG, "HTTP_EVENT_HEADER_SENT");
            break;
        case HTTP_EVENT_ON_HEADER:
            ESP_LOGD(TAG, "HTTP_EVENT_ON_HEADER, key=%s, value=%s", evt->header_key, evt->header_value);
            break;
        case HTTP_EVENT_ON_DATA:
            ESP_LOGD(TAG, "HTTP_EVENT_ON_DATA, len=%d", evt->data_len);
            if (!esp_http_client_is_chunked_response(evt->client)) {
                // Processar os dados recebidos
            }
            break;
        case HTTP_EVENT_ON_FINISH:
            ESP_LOGD(TAG, "HTTP_EVENT_ON_FINISH");
            break;
        case HTTP_EVENT_DISCONNECTED:
            ESP_LOGD(TAG, "HTTP_EVENT_DISCONNECTED");
            break;
        case HTTP_EVENT_REDIRECT:
            ESP_LOGD(TAG, "HTTP_EVENT_REDIRECT");
            break;
        default:
            ESP_LOGW(TAG, "Unhandled HTTP event id: %d", evt->event_id);
            break;
    }
    return ESP_OK;
}


/**
 * @brief Envia uma requisição HTTP POST com um corpo JSON.
 * 
 * @param url URL do endpoint.
 * @param json_data String JSON a ser enviada no corpo da requisição.
 * @return esp_err_t ESP_OK em caso de sucesso, ou um código de erro em caso de falha.
 */
esp_err_t http_post_json(const char *url, const char *json_data)
{
    esp_http_client_config_t config = {
        .url = url,
        .event_handler = _http_event_handler,
        .method = HTTP_METHOD_POST,
        .timeout_ms = 5000,
    };
    esp_http_client_handle_t client = esp_http_client_init(&config);
    if (client == NULL) {
        ESP_LOGE(TAG, "Failed to initialize HTTP client");
        return ESP_FAIL;
    }

    esp_http_client_set_header(client, "Content-Type", "application/json");
    esp_http_client_set_post_field(client, json_data, strlen(json_data));

    esp_err_t err = esp_http_client_perform(client);
    if (err == ESP_OK) {
        ESP_LOGI(TAG, "HTTP POST Status = %d, content_length = %lld",
                 esp_http_client_get_status_code(client),
                 esp_http_client_get_content_length(client));
    } else {
        ESP_LOGE(TAG, "HTTP POST request failed: %s", esp_err_to_name(err));
    }

    esp_http_client_cleanup(client);
    return err;
}


