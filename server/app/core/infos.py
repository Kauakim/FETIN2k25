from . import models
from datetime import datetime

# TODO: DEFINIR A POSIÇÃO DAS MÁQUINAS A SEGUIR
# Posição e linha das máquinas da fábrica
maquinas = [
    {"maquina": "Estacao de carga", "linha": "Carregamento", "x": 10, "y": 30},
    {"maquina": "Impressora 3D", "linha": "Maker","x": 10, "y": 30},
    {"maquina": "Impressora", "linha": "Maker", "x": 10, "y": 30},
    {"maquina": "Maquina de corrosao", "linha": "PCB", "x": 10, "y": 20},
    {"maquina": "Estacao de solda", "linha": "PCB", "x": 0, "y": 0},
    {"maquina": "CNC", "linha": "Corte", "x": 10, "y": 10},
    {"maquina": "Maquina de corte", "linha": "Corte", "x": 10, "y": 30},
    {"maquina": "Bancada de reparos e carga", "linha": "Manutencao", "x": 10, "y": 30},
]

def calcularDistancia(x1, y1, x2, y2):
    return ((x2 - x1) ** 2 + (y2 - y1) ** 2) ** 0.5

def calculateBeaconsStatus(maquinas):
    lastBeacons = models.getLastBeaconsData(15)
    allBeacons = models.getLastBeaconsData(900)
    
    for beacon in lastBeacons:
        status = beacon["status"]
        x = beacon["x"]
        y = beacon["y"]

        if x is None or y is None:
            continue

        if status == "processado" or status == "disponivel" or status == "em uso":
            continue

        # Ferramenta ou produto precisando de reparos, carga ou outro tipo de atenção
        if calcularDistancia(x, y, maquinas[7]["x"], maquinas[7]["y"]) < 2:
            status == "indisponivel"
        
        # Beacon em processo de carga
        if status == "descarregado":
            if calcularDistancia(x, y, maquinas[0]["x"], maquinas[0]["y"]) < 2:
                status = "carregando"

        # Beacon carregado ainda na estação de carga
        if status == "carregando":
            beacon_history = [b for b in allBeacons if b["beacon"] == beacon["beacon"]]
            if beacon_history and all(b["status"] == "carregando" for b in beacon_history):
                status = "carregado"
        
        # Beacon carregado fora da estação de carga
        if status == "carregado":
            if calcularDistancia(x, y, maquinas[1]["x"], maquinas[1]["y"]) > 2:
                status = "disponivel"

        # Lote sendo processado em alguma maquina
        if beacon["tipo"] == "material":
            for maquina in maquinas:
                if calcularDistancia(beacon[x], beacon[y], maquina["x"], maquinas["y"]) < 2:
                    status = "processando"
                    savedMaquina = maquina
    
        # Lote processado e alteração das informações
        if status == "processando":
            beacon_history = [b for b in allBeacons if b["beacon"] == beacon["beacon"]]
            if beacon_history and all(b["status"] == "processando" for b in beacon_history):
                status = "processado"
                
                infos = models.getInfoData()
                for info in infos:
                    if info["maquina"] == savedMaquina and info["data"] == datetime.now().strftime("%Y-%m-%d"):
                        models.updateInfo(info["maquina"], info["tasksConcluidas"] + 1, info["tasksCanceladas"], info["horasTrabalhadas"] + 0.25, info["data"])
                        updated = True
                        break
                if not updated:
                    models.createInfo(maquina, 1, 0, 0.25, datetime.now().strftime("%Y-%m-%d"))
                
        models.updateBeaconStatus(beacon["utc"], beacon["beacon"], status)
        
