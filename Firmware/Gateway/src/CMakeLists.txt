idf_component_register(SRCS "main.c" "ble_scanner.c" "wifi_manager.c" "http_client_manager.c"
                       INCLUDE_DIRS "../include"
                       REQUIRES "esp_wifi" "esp_http_client" "nvs_flash" "json")

# Adicionar dependências específicas para NimBLE
# Nota: Para usar NimBLE com ESP-IDF, você pode precisar adicionar o componente NimBLE
# como uma dependência externa ou como um submodule do projeto.
# target_link_libraries(${COMPONENT_LIB} INTERFACE nimble)

