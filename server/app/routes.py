from fastapi import APIRouter, HTTPException, status, Request
from . import schemas
from .core import models
from .core.rate_limiter import limiter
from .core.auth import verify_password, validate_password_strength

router = APIRouter()

@router.post("/users/login/")
@limiter.limit("10/minute")
async def login(request: Request, login_data: schemas.LoginRequest):
    user = models.authenticateUser(login_data.username, login_data.password)
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Credenciais inválidas"
        )
    return {"message": "Login realizado com sucesso", "status_code": status.HTTP_200_OK}

@router.post("/users/signin/")
@limiter.limit("10/minute")
async def signin(request: Request, signin_data: schemas.SigninResponseSchema):
    if signin_data.username in models.getUsersData():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Nome de usuário já existe"
        )
    
    is_valid, message = validate_password_strength(signin_data.password)
    if not is_valid:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=message
        )
    models.createUser(signin_data.username, signin_data.password, signin_data.email, signin_data.role)
    return {"message": "Usuário criado com sucesso", "status_code": status.HTTP_201_CREATED}

@router.get("/users/")
@limiter.limit("60/minute")
async def get_users(request: Request):
    users_data = models.getUsersData()
    safe_users = {}
    for username, user_info in users_data.items():
        safe_users[username] = {
            "username": user_info["username"],
            "email": user_info["email"],
            "role": user_info["role"]
        }
    return {"users": safe_users}

@router.post("/users/update/")
@limiter.limit("20/minute")
async def updateUser(request: Request, update_data: schemas.UpdateUserSchema):
    usersData = models.getUsersData()
    
    # Check required fields - password can be empty (means keep current)
    if not update_data.oldUsername or not update_data.newUsername or not update_data.email or not update_data.role:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )
    if update_data.oldUsername not in usersData:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuário não encontrado"
        )
    if update_data.newUsername in usersData and update_data.newUsername != update_data.oldUsername:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Novo nome de usuário já existe"
        )
    
    # If password is provided, validate strength
    finalPassword = update_data.password
    if update_data.password:
        is_valid, message = validate_password_strength(update_data.password)
        if not is_valid:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=message
            )
    else:
        # Keep current password
        currentUser = usersData[update_data.oldUsername]
        finalPassword = currentUser.get('password', '')

    models.updateUser(update_data.oldUsername, update_data.newUsername, finalPassword, update_data.email, update_data.role)
    return {"message": "Usuário atualizado com sucesso", "status_code": status.HTTP_200_OK}

@router.post("/users/delete/")
@limiter.limit("20/minute")
async def deleteUser(request: Request, delete_data: schemas.DeleteUserSchema):
    usersData = models.getUsersData()
    if not delete_data.username:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Username é obrigatório"
        )
    if delete_data.username not in usersData:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuário não encontrado"
        )
    
    models.deleteUser(delete_data.username)
    return {"message": "Usuário deletado com sucesso", "status_code": status.HTTP_200_OK}

@router.get("/users/get/all/")
@limiter.limit("60/minute")
async def getAllUsers(request: Request):
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
@limiter.limit("60/minute")
async def getAllBeacons(request: Request):
    beaconsData = models.getAllBeaconsData()
    if not beaconsData:
        raise HTTPException(status_code=404, detail="Nenhum beacon encontrado")
    return {"Beacons": beaconsData}

@router.get("/beacons/get/{seconds}/", response_model=schemas.BeaconsResponseSchema)
@limiter.limit("60/minute")
async def getLastBeacons(request: Request, seconds: int):
    beaconsData = models.getLastBeaconsData(seconds)
    if not beaconsData:
        raise HTTPException(status_code=404, detail="Nenhum beacon encontrado")
    return {"Beacons": beaconsData}

@router.post("/beacons/create/")
@limiter.limit("30/minute")
async def createBeacon(request: Request, beacon_data: schemas.BeaconCreateRequest):
    if not beacon_data.beacon or not beacon_data.tipo or not beacon_data.status or not beacon_data.rssi1 or not beacon_data.rssi2 or not beacon_data.rssi3 or not beacon_data.x or not beacon_data.y or not beacon_data.utc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )

    models.createBeacon(beacon_data.utc, beacon_data.beacon, beacon_data.tipo, beacon_data.status, beacon_data.rssi1, beacon_data.rssi2, beacon_data.rssi3, beacon_data.x, beacon_data.y)
    return {"message": "Beacon criado com sucesso", "status_code": status.HTTP_200_OK}

@router.post("/beacons/delete/")
@limiter.limit("20/minute")
async def deleteBeacon(request: Request, delete_data: schemas.BeaconDeleteRequest):
    if not delete_data.beacon:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )
        
    models.deleteBeacon(delete_data.beacon)
    return {"message": "Beacon deletado com sucesso", "status_code": status.HTTP_200_OK}

@router.post("/beacons/update/tipo/")
@limiter.limit("30/minute")
async def updateBeaconRssi(request: Request, update_data: schemas.BeaconUpdateTypeRequest):
    if not update_data.beacon or not update_data.tipo or not update_data.utc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )

    models.updateBeaconType(update_data.utc, update_data.beacon, update_data.tipo)
    return {"message": "Tipo do beacon atualizado com sucesso", "status_code": status.HTTP_200_OK}

@router.post("/beacons/update/status/")
@limiter.limit("30/minute")
async def updateBeaconStatus(request: Request, update_data: schemas.BeaconUpdateStatusRequest):
    if not update_data.beacon or not update_data.status or not update_data.utc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )

    models.updateBeaconStatus(update_data.utc, update_data.beacon, update_data.status)
    return {"message": "Status do beacon atualizado com sucesso", "status_code": status.HTTP_200_OK}

@router.post("/rssi/")
@limiter.limit("120/minute")
async def RSSIRequest(request: Request, rssi_data: schemas.GatewayRequest):
    beaconsData = models.getLastBeaconsData(10)
    
    for item in rssi_data.Gateways.values():
        beacon = item.beacon
        beaconStatus = item.status
        tipo = item.tipo
        gateway = item.gateway
        rssi = item.rssi
        utc = item.utc

        if beacon not in beaconsData:
            models.createBeacon(utc, beacon, tipo, beaconStatus, None, None, None, None, None)

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

    print(f"Beacon {beacon}, Rssi: {rssi}, gateway {gateway}, utc {utc}")

    return {"message": "RSSI atualizado com sucesso", "status_code": status.HTTP_200_OK}

#---------------------------------------------------------------------------------------------------------------------------

@router.get("/tasks/read/all/", response_model=schemas.TaskResponseSchema)
@limiter.limit("60/minute")
async def getTasks(request: Request):
    tasksData = models.getTasksData()
    if not tasksData:
        raise HTTPException(status_code=404, detail="Nenhuma tarefa encontrada")
    return {"Tasks": tasksData}

@router.get("/tasks/read/{user}/", response_model=schemas.TaskResponseSchema)
@limiter.limit("60/minute")
async def getUserTasks(request: Request, user: str):
    tasksData = models.getTaskByUser(user)
    if not tasksData:
        raise HTTPException(status_code=404, detail="Nenhuma tarefa encontrada para este usuário")
    return {"Tasks": tasksData}

@router.post("/tasks/create/")
@limiter.limit("30/minute")
async def createTask(request: Request, task_data: schemas.TaskCreateRequest):
    if not task_data.mensagem or not task_data.destino or not task_data.tipoDestino or task_data.beacons is None or not task_data.tipo or not task_data.status:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )
    
    task = models.createTask(task_data.mensagem, task_data.destino, task_data.tipoDestino, task_data.beacons, task_data.tipo, task_data.status)
    return {"message": "Tarefa criada com sucesso", "status_code": status.HTTP_201_CREATED}

@router.post("/tasks/update/")
@limiter.limit("30/minute")
async def updateTask(request: Request, update_data: schemas.TaskUpdateRequest):
    if not update_data.user or not update_data.mensagem or not update_data.destino or not update_data.tipoDestino or update_data.beacons is None or not update_data.tipo or not update_data.status:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )
    
    task = models.updateTask(update_data.id, update_data.user, update_data.mensagem, update_data.destino, update_data.tipoDestino, update_data.beacons, update_data.tipo, update_data.status)
    return {"message": "Tarefa atualizada com sucesso", "task_id": update_data.id, "status_code": status.HTTP_201_CREATED}

@router.post("/tasks/status/")
@limiter.limit("60/minute")
async def updateTaskStatus(request: Request, status_data: schemas.TaskUpdateStatusRequest):
    if not status_data.id or not status_data.status:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )
    
    task = models.updateTaskStatus(status_data.id, status_data.status)
    return {"message": "Status da tarefa atualizado com sucesso", "task_id": status_data.id, "status_code": status.HTTP_200_OK}

@router.post("/tasks/delete/")
@limiter.limit("20/minute")
async def deleteTask(request: Request, delete_data: schemas.TaskDeleteRequest):
    if not delete_data.id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Campos obrigatórios ausentes"
        )
    
    models.deleteTask(delete_data.id)
    
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