from. import models

def calcularDistancia(x1, y1, x2, y2):
    return ((x2 - x1) ** 2 + (y2 - y1) ** 2) ** 0.5

def alterarStatus():
    tasks = models.getTasksData()
    
    for task in tasks:
        id = task["id"]
        user = task["user"]
        mensagem = task["mensagem"]
        beacons = task["beacons"]
        dependencias = task["dependencias"]
        tipo = task["tipo"]
        status = task["status"]
        
        if status == "cancelada":
            continue
        
        if status == "pendente" or status == "reaberta":
            if dependencias:
                for i in range (len(dependencias)):
                    dependencia = models.getTaskById(dependencias[i])
                    if dependencia["status"] != "concluida":
                        status = "pendente"
                        break

        models.updateTaskStatus(id, status)

def atributeBeacons():
    tasks = models.getTasksData()
    
    for task in tasks:
        id = task["id"]
        user = task["user"]
        beacons = task["beacons"]
        userData = models.getBeacon(user)
        
        beaconsIDs = []

        for beacon in beacons:
            beaconData = models.getBeacon(beacon)
            if beaconData:
                menorDistancia = None
                beaconMaisPerto = None
                if beacon["status"] == "em uso":
                    continue
                else:
                    distancia = calcularDistancia(beaconData["x"], beaconData["y"], userData["x"], userData["y"])
                    if menorDistancia is None or distancia < menorDistancia:
                        beaconMaisPerto = beacon
                        menorDistancia = distancia
            
            if beaconMaisPerto:
                beaconsIDs.append(beaconMaisPerto["id"])

def atributeUser():
    tasks = models.getTasksData()
    
    for task in tasks:
        id = task["id"]
        user = task["user"]
        mensagem = task["mensagem"]
        beacons = task["beacons"]
        dependencias = task["dependencias"]
        tipo = task["tipo"]
        status = task["status"]

        if user is None or user == "":
            users = models.getLastBeaconsData()
            for u in users:
                menorDistancia = None
                userMaisPerto = None
                if u["tipo"] == "worker":
                    distancia = calcularDistancia()
                    user = u["user"]
                    break
