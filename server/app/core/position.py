import math
import models

# Posições fixas dos gateways
gateways = [
    {"x": 0, "y": 0},
    {"x": 5, "y": 0},
    {"x": 2.5, "y": 4}
]

def RSSIToDistance(RSSI, txPower=-59, n=2.0):
    # txPower = RSSI a 1 metro
    # n = Fator de perda de caminho
    return 10 ** ((txPower - RSSI) / (10 * n))

def discoverXY(gateways, distancia1, distancia2, distancia3):
    x1, y1 = gateways[0]["x"], gateways[0]["y"]
    x2, y2 = gateways[1]["x"], gateways[1]["y"]
    x3, y3 = gateways[2]["x"], gateways[2]["y"]

    dx1, dy1 = x2 - x1, y2 - y1
    dx2, dy2 = x3 - x2, y3 - y2

    A = 2 * dx1
    B = 2 * dy1
    C = distancia1*distancia1 - distancia2*distancia2 - x1*x1 + x2*x2 - y1*y1 + y2*y2

    D = 2 * dx2
    E = 2 * dy2
    F = distancia2*distancia2 - distancia3*distancia3 - x2*x2 + x3*x3 - y2*y2 + y3*y3

    denominator = A * E - B * D
    if denominator == 0:
        raise ValueError("Trilateration failed: denominator is 0")

    inv_den = 1 / denominator
    x = (C * E - F * B) * inv_den
    y = (A * F - D * C) * inv_den

    return x, y

def calculateBeaconsPositions(gateways):
    gatewayDB = tuple(getRSSI())
    
    for i in range(len(gatewayDB)):
        distancia1 = RSSIToDistance(gatewayDB[i]["rssi1"])  
        distancia2 = RSSIToDistance(gatewayDB[i]["rssi2"])
        distancia3 = RSSIToDistance(gatewayDB[i]["rssi3"])

        x,y = discoverXY(gateways, distancia1, distancia2, distancia3)
        
        print(gatewayDB[i]["beacon"], x, y)

        # TODO: Corrigir essa parte do código para atualziar apenas a posição dos beacons a partir de uma nova funcao chamada updateBeaconPosition
        '''
        getBeaconsData()
        if gatewayDB[i]["beacon"] not in getBeaconsData():
            createBeacon(gatewayDB[i]["beacon"], gatewayDB[i]["tipo"], gatewayDB[i]["status"], x, y)
        else:
            updateBeacon(gatewayDB[i]["beacon"], gatewayDB[i]["tipo"], gatewayDB[i]["status"], x, y)
        '''
        
calculateBeaconsPositions(gateways)