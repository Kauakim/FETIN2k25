from pydantic import BaseModel
from typing import Dict

class BeaconModel(BaseModel):
    id: int
    beacon: str
    tipo: str
    status: str
    x: float
    y: float

class BeaconsResponseSchema(BaseModel):
    Beacons: Dict[int, BeaconModel]

class InfoModel(BaseModel):
    id: int
    linha: int
    maquina: int
    numeroProdutos: int
    horasTrabalhadas: int
    rendimento: float
    falhas: int

class InfoResponseSchema(BaseModel):
    Info: Dict[int, InfoModel]

class GatewayModel(BaseModel):
    id: int
    beacon: str
    rss1: float
    rss2: float
    rss3: float
    status: str

class GatewayResponseSchema(BaseModel):
    Gateway: Dict[int, GatewayModel]

class LoginRequest(BaseModel):
    username: str
    password: str

class GatewayRequest(BaseModel):
    beacon: str
    rssi: float
    gateway: int

class InfoRequest(BaseModel):
    linha: int
    maquina: int
    numeroProdutos: int
    horasTrabalhadas: int 
    rendimento: float
    falhas: int