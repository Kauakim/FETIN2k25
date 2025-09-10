from fastapi import APIRouter, HTTPException, status
from . import schemas
from .core import models

router = APIRouter()

@router.post("/users/login/")
async def login(request: schemas.LoginRequest):
    usersData = models.getUsersData()
    user = usersData.get(request.username)
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuário não encontrado"
        )
    if user["password"] != request.password:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Senha inválida"
        )
    
    return {"message": "Login realizado com sucesso", "status_code": status.HTTP_200_OK}

@router.post("/users/signin/")
async def signin(request: schemas.SigninResponseSchema):
    if request.username in models.getUsersData():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Nome de usuário já existe"
        )
    
    models.createUser(request.username, request.password, request.email, request.role)
    return {"message": "Usuário criado com sucesso", "status_code": status.HTTP_201_CREATED}

@router.post("/users/update/")
async def updateUser(request: schemas.UpdateUserSchema):
    usersData = models.getUsersData()
    
    # Check required fields - password can be empty (means keep current)
    if not request.oldUsername or not request.newUsername or not request.email or not request.role:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )
    if request.oldUsername not in usersData:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuário não encontrado"
        )
    if request.newUsername in usersData and request.newUsername != request.oldUsername:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Novo nome de usuário já existe"
        )
    
    # If password is empty, keep the current password
    finalPassword = request.password
    if not request.password:
        currentUser = usersData[request.oldUsername]
        finalPassword = currentUser.get('password', '')
        print(f"Senha mantida para o usuário {request.oldUsername}")
    else:
        print(f"Atualizando senha para o usuário {request.oldUsername}")

    models.updateUser(request.oldUsername, request.newUsername, finalPassword, request.email, request.role)
    return {"message": "Usuário atualizado com sucesso", "status_code": status.HTTP_201_CREATED}

@router.post("/users/delete/")
async def deleteUser(request: schemas.DeleteUserSchema):
    usersData = models.getUsersData()
    if not request.username:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )
    if request.username not in usersData:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuário não encontrado"
        )
    
    models.deleteUser(request.username)
    return {"message": "Usuário deletado com sucesso", "status_code": status.HTTP_201_CREATED}

@router.get("/users/get/all/")
async def getAllUsers():
    usersData = models.getUsersData()
    if not usersData:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Nenhum usuário encontrado"
        )
    
    users_list = []
    for username, user_info in usersData.items():
        user_safe = {
            "username": username,
            "email": user_info.get("email", ""),
            "role": user_info.get("role", "")
        }
        users_list.append(user_safe)
    
    return {"users": users_list, "status_code": status.HTTP_200_OK}

#---------------------------------------------------------------------------------------------------------------------------

@router.get("/beacons/get/all/", response_model=schemas.BeaconsResponseSchema)
async def getAllBeacons():
    beaconsData = models.getAllBeaconsData()
    if not beaconsData:
        raise HTTPException(status_code=404, detail="Nenhum beacon encontrado")
    return {"Beacons": beaconsData}

@router.get("/beacons/get/{seconds}/", response_model=schemas.BeaconsResponseSchema)
async def getLastBeacons(seconds: int):
    beaconsData = models.getLastBeaconsData(seconds)
    if not beaconsData:
        raise HTTPException(status_code=404, detail="Nenhum beacon encontrado")
    return {"Beacons": beaconsData}

@router.post("/beacons/create/")
async def createBeacon(request: schemas.BeaconCreateRequest):
    if not request.beacon or not request.tipo or not request.status or not request.rssi1 or not request.rssi2 or not request.rssi3 or not request.x or not request.y or not request.utc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )

    models.createBeacon(request.utc, request.beacon, request.tipo, request.status, request.rssi1, request.rssi2, request.rssi3, request.x, request.y)
    return {"message": "Beacon criado com sucesso", "status_code": status.HTTP_200_OK}

@router.post("/beacons/delete/")
async def deleteBeacon(request: schemas.BeaconDeleteRequest):
    if not request.beacon:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )
        
    models.deleteBeacon(request.beacon)
    return {"message": "Beacon deletado com sucesso", "status_code": status.HTTP_200_OK}

@router.post("/beacons/update/tipo/")
async def updateBeaconRssi(request: schemas.BeaconUpdateTypeRequest):
    if not request.beacon or not request.tipo or not request.utc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )

    models.updateBeaconType(request.utc, request.beacon, request.tipo)
    return {"message": "Tipo do beacon atualizado com sucesso", "status_code": status.HTTP_200_OK}

@router.post("/beacons/update/status/")
async def updateBeaconStatus(request: schemas.BeaconUpdateStatusRequest):
    if not request.beacon or not request.status or not request.utc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )

    models.updateBeaconStatus(request.utc, request.beacon, request.status)
    return {"message": "Status do beacon atualizado com sucesso", "status_code": status.HTTP_200_OK}

@router.post("/rssi/")
async def RSSIRequest(request: schemas.GatewayRequest):
    beaconsData = models.getLastBeaconsData(10)
    
    for item in request.Gateways.values():
        beacon = item.beacon
        beaconStatus = item.status
        tipo = item.tipo
        gateway = item.gateway
        rssi = item.rssi
        utc = item.utc

        if beacon not in beaconsData:
            models.createBeacon(utc, beacon, tipo, beaconStatus, None, None, None, None, None)

        if rssi < 0 or rssi > 10000:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Valor RSSI inválido"
            )
        if gateway < 1 or gateway > 3:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Valor de gateway inválido"
            )
        
        if (gateway == 1):
            models.updateBeaconRssi(beacon, rssi, None, None)
        elif (gateway == 2):
            models.updateBeaconRssi(beacon, None, rssi, None)
        elif (gateway == 3):
            models.updateBeaconRssi(beacon, None, None, rssi)

    return {"message": "RSSI atualizado com sucesso", "status_code": status.HTTP_200_OK}

#---------------------------------------------------------------------------------------------------------------------------

@router.get("/tasks/read/all/", response_model=schemas.TaskResponseSchema)
async def getTasks():
    tasksData = models.getTasksData()
    if not tasksData:
        raise HTTPException(status_code=404, detail="Nenhuma tarefa encontrada")
    return {"Tasks": tasksData}

@router.get("/tasks/read/{user}/", response_model=schemas.TaskResponseSchema)
async def getUserTasks(user: str):
    tasksData = models.getTaskByUser(user)
    if not tasksData:
        raise HTTPException(status_code=404, detail="Nenhuma tarefa encontrada para este usuário")
    return {"Tasks": tasksData}

@router.post("/tasks/create/")
async def createTask(request: schemas.TaskCreateRequest):
    if not request.mensagem or not request.destino or not request.tipoDestino or not request.beacons or not request.tipo or not request.status:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )
    
    task = models.createTask(request.mensagem, request.destino, request.tipoDestino, request.beacons, request.tipo, request.status)
    return {"message": "Tarefa criada com sucesso", "task_id": request.id, "status_code": status.HTTP_201_CREATED}

@router.post("/tasks/update/")
async def updateTask(request: schemas.TaskUpdateRequest):
    if not request.user or not request.mensagem or not request.destino or not request.tipoDestino or not request.beacons or not request.tipo or not request.status:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )
    
    task = models.updateTask(request.id, request.user, request.mensagem, request.destino, request.tipoDestino, request.beacons, request.tipo, request.status)
    return {"message": "Tarefa atualizada com sucesso", "task_id": request.id, "status_code": status.HTTP_201_CREATED}

@router.post("/tasks/status/")
async def updateTaskStatus(request: schemas.TaskUpdateStatusRequest):
    if not request.id or not request.status:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )
    
    task = models.updateTaskStatus(request.id, request.status)
    return {"message": "Status da tarefa atualizado com sucesso", "task_id": request.id, "status_code": status.HTTP_200_OK}

@router.post("/tasks/delete/")
async def deleteTask(request: schemas.TaskDeleteRequest):
    if not request.id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )
    
    task = models.deleteTask(request.id)
    if not task:
        raise HTTPException(status_code=404, detail="Tarefa não encontrada")
    
    return {"message": "Tarefa deletada com sucesso", "task_id": request.id, "status_code": status.HTTP_200_OK}

#---------------------------------------------------------------------------------------------------------------------------

@router.get("/info/", response_model=schemas.InfoResponseSchema)
async def getInfo():
    infoData = models.getInfoData()
    if not infoData:
        raise HTTPException(status_code=404, detail="Nenhuma informação encontrada")
    return {"Info": infoData}

@router.post("/info/create/")
async def createInfo(request: schemas.InfoRequest):
    if not request.maquina or not request.tasksConcluidas or not request.tasksCanceladas or not request.horasTrabalhadas or not request.data:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )
    if request.tasksConcluidas < 0 or request.tasksCanceladas < 0 or request.horasTrabalhadas < 0:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Valor de solicitação de informação inválido"
        )
    
    models.createInfo(request.maquina, request.tasksConcluidas, request.tasksCanceladas, request.horasTrabalhadas, request.data)
    return {"message": "Informação criada com sucesso", "status_code": status.HTTP_200_OK}

@router.post("/info/update/")
async def updateInfo(request: schemas.InfoRequest):
    if not request.maquina or not request.tasksConcluidas or not request.tasksCanceladas or not request.horasTrabalhadas or not request.data:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )
    if request.tasksConcluidas < 0 or request.tasksCanceladas < 0 or request.horasTrabalhadas < 0:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Valor de solicitação de informação inválido"
        )
    
    info = models.updateInfo(request.maquina, request.tasksConcluidas, request.tasksCanceladas, request.horasTrabalhadas, request.data)
    if not info:
        raise HTTPException(status_code=404, detail="Informação não encontrada")
    return {"message": "Informação atualizada com sucesso", "status_code": status.HTTP_200_OK}

@router.post("/info/delete/")
async def deleteInfo(request: schemas.InfoDeleteRequest):
    if not request.maquina or not request.data:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )
    
    info = models.deleteInfo(request.maquina, request.data)
    if not info:
        raise HTTPException(status_code=404, detail="Informação não encontrada")
    return {"message": "Informação deletada com sucesso", "status_code": status.HTTP_200_OK}