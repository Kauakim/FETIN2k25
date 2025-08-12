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
            detail="User not found"
        )
    if user["password"] != request.password:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid password"
        )
    
    return {"message": "Login successful", "status_code": status.HTTP_200_OK}

@router.post("/users/signin/")
async def signin(request: schemas.SigninResponseSchema):
    if request.username in models.getUsersData():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Username already exists"
        )
    
    models.createUser(request.username, request.password, request.email, request.role)
    return {"message": "User created successfully", "status_code": status.HTTP_201_CREATED}

@router.post("/users/update/")
async def updateUser(request: schemas.UpdateUserSchema):
    usersData = models.getUsersData()
    if not request.oldUsername or not request.newUsername or not request.password or not request.email or not request.role:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Missing required fields"
        )
    if request.oldUsername not in usersData:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    if request.newUsername in usersData and request.newUsername != request.oldUsername:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="New username already exists"
        )
    
    models.updateUser(request.newUsername, request.password, request.email, request.role)
    return {"message": "User updated successfully", "status_code": status.HTTP_201_CREATED}

@router.post("/users/delete/")
async def deleteUser(request: schemas.DeleteUserSchema):
    usersData = models.getUsersData()
    if not request.username:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Missing required fields"
        )
    if request.username not in usersData:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    models.deleteUser(request.username)
    return {"message": "User deleted successfully", "status_code": status.HTTP_201_CREATED}

#---------------------------------------------------------------------------------------------------------------------------

@router.get("/beacons/all", response_model=schemas.BeaconsResponseSchema)
async def getAllBeacons():
    beaconsData = models.getAllBeaconsData()
    if not beaconsData:
        raise HTTPException(status_code=404, detail="No beacons found")
    return {"Beacons": beaconsData}

@router.get("/beacons/{seconds}", response_model=schemas.BeaconsResponseSchema)
async def getLastBeacons(seconds: int):
    beaconsData = models.getLastBeaconsData(seconds)
    if not beaconsData:
        raise HTTPException(status_code=404, detail="No beacons found")
    return {"Beacons": beaconsData}

@router.post("/beacons/delete/")
async def deleteBeacon(request: schemas.BeaconDeleteRequest):
    if not request.beacon:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Missing required fields"
        )
        
    beacon = models.deleteBeacon(request.beacon)
    if not beacon:
        raise HTTPException(status_code=404, detail="Beacon not found")
    return {"message": "Beacon deleted successfully", "status_code": status.HTTP_200_OK}

@router.post("/rssi/")
async def RSSIRequest(request: schemas.GatewayRequest):
    beaconsData = models.getLastBeaconsData(10)
    
    for item in request.Gateways.items():
        beacon = item.get("beacon")
        status = item.get("status")
        tipo = item.get("tipo")
        gateway = item.get("gateway")
        rssi = item.get("rssi")
        utc = item.get("utc")

        if beacon not in beaconsData:
            models.createBeacon(utc, beacon, tipo, status, None, None, None, None, None, None)

        if rssi < 0 or rssi > 10000:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid RSSI value"
            )
        if gateway < 1 or gateway > 3:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid gateway value"
            )
        
        if (gateway == 1):
            models.updateBeaconRssi(beacon, rssi, None, None)
        elif (gateway == 2):
            models.updateBeaconRssi(beacon, None, rssi, None)
        elif (gateway == 3):
            models.updateBeaconRssi(beacon, None, None, rssi)

    return {"message": "RSSI updated successfully", "status_code": status.HTTP_200_OK}

#---------------------------------------------------------------------------------------------------------------------------

@router.get("/tasks/read/all", response_model=schemas.TaskResponseSchema)
async def getTasks():
    tasksData = models.getTasksData()
    if not tasksData:
        raise HTTPException(status_code=404, detail="No tasks found")
    return {"Tasks": tasksData}

@router.get("/tasks/read/{user}", response_model=schemas.TaskResponseSchema)
async def getUserTasks(user: str):
    tasksData = models.getTaskByUser(user)
    if not tasksData:
        raise HTTPException(status_code=404, detail="No tasks found for this user")
    return {"Tasks": tasksData}

@router.post("/tasks/create/")
async def createTask(request: schemas.TaskCreateRequest):
    if not request.mensagem or not request.destino or not request.tipoDestino or not request.beacons or not request.dependencias or not request.tipo or not request.status:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Missing required fields"
        )
    
    task = models.createTask(request.mensagem, request.destino, request.tipoDestino, request.beacons, request.dependencias, request.tipo, request.status)
    return {"message": "Task created successfully", "task_id": request.id, "status_code": status.HTTP_201_CREATED}

@router.post("/tasks/update/")
async def updateTask(request: schemas.TaskUpdateRequest):
    if not request.user or not request.mensagem or not request.destino or not request.tipoDestino or not request.beacons or not request.dependencias or not request.tipo or not request.status:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Missing required fields"
        )
    
    task = models.updateTask(request.id, request.user, request.mensagem, request.destino, request.tipoDestino, request.beacons, request.dependencias, request.tipo, request.status)
    return {"message": "Task updated successfully", "task_id": request.id, "status_code": status.HTTP_201_CREATED}

@router.post("/tasks/status/")
async def updateTaskStatus(request: schemas.TaskUpdateStatusRequest):
    if not request.id or not request.status:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Missing required fields"
        )
    
    task = models.updateTaskStatus(request.id, request.status)
    return {"message": "Task status updated successfully", "task_id": request.id, "status_code": status.HTTP_200_OK}

@router.post("/tasks/cancel/")
async def cancelTask(request: schemas.TaskCancelRequest):
    if not request.id or not request.status or not request.cancelamento:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Missing required fields"
        )
    
    task = models.cancelTask(request.id, request.status, request.cancelamento)
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    
    return {"message": "Task cancelled successfully", "task_id": request.id, "status_code": status.HTTP_200_OK}

@router.post("/tasks/delete/")
async def deleteTask(request: schemas.TaskDeleteRequest):
    if not request.id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Missing required fields"
        )
    
    task = models.deleteTask(request.id)
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    
    return {"message": "Task deleted successfully", "task_id": request.id, "status_code": status.HTTP_200_OK}

#---------------------------------------------------------------------------------------------------------------------------

@router.get("/info", response_model=schemas.InfoResponseSchema)
async def getInfo():
    infoData = models.getInfoData()
    if not infoData:
        raise HTTPException(status_code=404, detail="No info found")
    return {"Info": infoData}

@router.post("/info/create/")
async def createInfo(request: schemas.InfoRequest):
    if not request.maquina or not request.tasksConcluidas or not request.tasksCanceladas or not request.horasTrabalhadas or not request.data:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Missing required fields"
        )
    if request.tasksConcluidas < 0 or request.tasksCanceladas < 0 or request.horasTrabalhadas < 0:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid info request value"
        )
    
    models.createInfo(request.linha, request.maquina, request.numeroProdutos, request.horasTrabalhadas, request.falhas)
    return {"message": "Info created successfully", "status_code": status.HTTP_200_OK}

@router.post("/info/update/")
async def updateInfo(request: schemas.InfoRequest):
    if not request.maquina or not request.tasksConcluidas or not request.tasksCanceladas or not request.horasTrabalhadas or not request.data:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Missing required fields"
        )
    if request.tasksConcluidas < 0 or request.tasksCanceladas < 0 or request.horasTrabalhadas < 0:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid info request value"
        )
    
    info = models.updateInfo(request.maquina, request.tasksConcluidas, request.tasksCanceladas,request.horasTrabalhadas, request.data)
    if not info:
        raise HTTPException(status_code=404, detail="Info not found")
    return {"message": "Info updated successfully", "info_id": info.id, "status_code": status.HTTP_200_OK}

@router.post("/info/delete/")
async def deleteInfo(request: schemas.InfoDeleteRequest):
    if not request.maquina or not request.data:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Missing required fields"
        )
    
    info = models.deleteInfo(request.maquina, request.data)
    if not info:
        raise HTTPException(status_code=404, detail="Info not found")
    return {"message": "Info deleted successfully", "status_code": status.HTTP_200_OK}