from .models import getRSSI, createRSSI, updateRSSI, getBeaconsData, createBeacon, updateBeacon

def calculateBeaconPosition():
    return

# Recebe o valor de RSSI dos gateways
# Caso ambos os três valores de SSSI sejam diferentes de None, calcula a posição do beacon
# Se o beacon não existir, cria um novo beacon
# Se o beacon existir, atualiza a posição do beacon