from pydantic import BaseModel
from typing import Dict

class LoginRequest(BaseModel):
    username: str
    password: str

class SigninResponseSchema(BaseModel):
    username: str
    password: str
    email: str
    role: str

class UpdateUserSchema(BaseModel):
    oldUsername: str
    newUsername: str
    password: str
    email: str
    role: str

class DeleteUserSchema(BaseModel):
    username: str

#---------------------------------------------------------------------------------------------------------------------------

class BeaconModel(BaseModel):
    id: int
    utc: int
    beacon: str
    tipo: str
    status: str
    x: float
    y: float

class BeaconsResponseSchema(BaseModel):
    Beacons: Dict[int, BeaconModel]

class RssiModel(BaseModel):
    beacon: str
    status: str
    tipo: str
    gateway: int
    rssi: float
    utc: int

class GatewayRequest(BaseModel):
    Gateways: Dict[int, RssiModel]

class BeaconCreateRequest(BaseModel):
    beacon: str
    status: str
    tipo: str
    rssi1: float
    rssi2: float
    rssi3: float
    x: float
    y: float
    utc: int

class BeaconUpdateTypeRequest(BaseModel):
    beacon: str
    tipo: str
    utc: int

class BeaconUpdateStatusRequest(BaseModel):
    beacon: str
    status: str
    utc: int

class BeaconDeleteRequest(BaseModel):
    beacon: str

#---------------------------------------------------------------------------------------------------------------------------

class taskModel(BaseModel):
    id: int
    user: str
    mensagem: str
    destino: str
    tipoDestino: str
    beacons: list
    dependencias: list
    tipo: str
    status: str

class TaskResponseSchema(BaseModel):
    Tasks: Dict[int, taskModel]

class TaskCreateRequest(BaseModel):
    mensagem: str
    destino: str
    tipoDestino: str
    beacons: list
    dependencias: list
    tipo: str
    status: str

class TaskUpdateRequest(BaseModel):
    id: int
    user: str
    mensagem: str
    destino: str
    tipoDestino: str
    beacons: list
    dependencias: list
    tipo: str
    status: str

class TaskUpdateStatusRequest(BaseModel):
    id: int
    status: str

class TaskCancelRequest(BaseModel):
    id: int
    status: str
    cancelamento: str

class TaskDeleteRequest(BaseModel):
    id: int

#---------------------------------------------------------------------------------------------------------------------------

class InfoModel(BaseModel):
    id: int
    maquina: str
    tasksConcluidas: int
    tasksCanceladas: int
    horasTrabalhadas: float
    data: str
    
class InfoResponseSchema(BaseModel):
    Info: Dict[int, InfoModel]

class InfoRequest(BaseModel):
    maquina: str
    tasksConcluidas: int
    tasksCanceladas: int
    horasTrabalhadas: float
    data: str

class InfoDeleteRequest(BaseModel):
    maquina: str
    data: str