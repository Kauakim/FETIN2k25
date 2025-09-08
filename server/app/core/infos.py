from . import models
from datetime import datetime

def getMaquinasFromDatabase():
    all_beacons = models.getAllBeaconsData()
    maquinas = []
    
    for beacon_id, beacon_data in all_beacons.items():
        if beacon_data["tipo"] == "maquina":
            maquina = {
                "beacon": beacon_data["beacon"],
                "status": beacon_data["status"],
                "x": beacon_data["x"],
                "y": beacon_data["y"]
            }
            maquinas.append(maquina)
    
    return maquinas

def calcularDistancia(x1, y1, x2, y2):
    return ((x2 - x1) ** 2 + (y2 - y1) ** 2) ** 0.5

def calculateBeaconsStatus():
    maquinas = getMaquinasFromDatabase()
    lastBeacons = models.getLastBeaconsData(15)
    allBeacons = models.getLastBeaconsData(900)

    estacao_carga = next((m for m in maquinas if m["beacon"] == "Estacao de carga"), None)
    bancada_reparos = next((m for m in maquinas if m["beacon"] == "Bancada de reparos e carga"), None)
    
    for beacon_id, beacon in lastBeacons.items():
        if beacon["tipo"] == "maquina":
            continue
            
        status = beacon["status"]
        x = beacon["x"]
        y = beacon["y"]

        if x is None or y is None:
            continue

        if status == "processado" or status == "disponivel" or status == "em uso":
            continue

        # Ferramenta ou produto precisando de reparos, carga ou outro tipo de atenção
        if bancada_reparos and calcularDistancia(x, y, bancada_reparos["x"], bancada_reparos["y"]) < 2:
            status = "indisponivel"
        
        # Beacon em processo de carga
        if status == "descarregado":
            if estacao_carga and calcularDistancia(x, y, estacao_carga["x"], estacao_carga["y"]) < 2:
                status = "carregando"

        # Beacon carregado ainda na estação de carga
        if status == "carregando":
            beacon_history = [b for beacon, b in allBeacons.items() if b["beacon"] == beacon["beacon"]]
            if beacon_history and all(b["status"] == "carregando" for b in beacon_history):
                status = "carregado"
        
        # Beacon carregado fora da estação de carga
        if status == "carregado":
            if estacao_carga and calcularDistancia(x, y, estacao_carga["x"], estacao_carga["y"]) > 2:
                status = "disponivel"

        # Lote sendo processado em alguma maquina
        if beacon["tipo"] == "material":
            for maquina in maquinas:
                if calcularDistancia(x, y, maquina["x"], maquina["y"]) < 2:
                    status = "processando"
                    savedMaquina = maquina["beacon"]
                    break
    
        # Lote processado e alteração das informações
        if status == "processando":
            beacon_history = [b for beacon, b in allBeacons.items() if b["beacon"] == beacon["beacon"]]
            if beacon_history and all(b["status"] == "processando" for b in beacon_history):
                status = "processado"
                
                infos = models.getInfoData()
                updated = False
                for info in infos:
                    if info["maquina"] == savedMaquina and info["data"] == datetime.now().strftime("%Y-%m-%d"):
                        models.updateInfo(info["maquina"], info["tasksConcluidas"] + 1, info["tasksCanceladas"], info["horasTrabalhadas"] + 0.25, info["data"])
                        updated = True
                        break
                if not updated:
                    models.createInfo(savedMaquina, 1, 0, 0.25, datetime.now().strftime("%Y-%m-%d"))
                
        models.updateBeaconStatus(beacon["utc"], beacon["beacon"], status)
        
