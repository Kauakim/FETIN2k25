from pydantic import BaseModel, EmailStr, validator, Field
from typing import Dict, Optional, List
import re

class LoginRequest(BaseModel):
    username: str = Field(..., min_length=3, max_length=50, description="Nome de usuário")
    password: str = Field(..., min_length=1, description="Senha do usuário")
    
    @validator('username')
    def username_alphanumeric(cls, v):
        if not re.match(r'^[a-zA-Z0-9 ]+$', v):
            raise ValueError('Username deve conter apenas letras, números ou espaços')
        return v

class SigninResponseSchema(BaseModel):
    username: str = Field(..., min_length=3, max_length=50)
    password: str = Field(..., min_length=8, max_length=64)
    email: EmailStr = Field(..., description="Email válido")
    role: str = Field(..., min_length=6, max_length=10)
    
    @validator('username')
    def username_alphanumeric(cls, v):
        if not re.match(r'^[a-zA-Z0-9 ]+$', v):
            raise ValueError('Username deve conter apenas letras, números ou espaços')
        return v
    
    @validator('password')
    def validate_password_strength(cls, v):
        if len(v) < 8:
            raise ValueError('Senha deve ter pelo menos 8 caracteres')
        if not re.search(r'[A-Z]', v):
            raise ValueError('Senha deve conter pelo menos uma letra maiúscula')
        if not re.search(r'[a-z]', v):
            raise ValueError('Senha deve conter pelo menos uma letra minúscula')
        if not re.search(r'\d', v):
            raise ValueError('Senha deve conter pelo menos um número')
        if not re.search(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]', v):
            raise ValueError('Senha deve conter pelo menos um caractere especial')
        return v
    
    @validator('role')
    def validate_role(cls, v):
        allowed_roles = ['admin', 'manager', 'user']
        if v.lower() not in allowed_roles:
            raise ValueError(f'Role deve ser um dos seguintes: {", ".join(allowed_roles)}')
        return v.lower()

class UpdateUserSchema(BaseModel):
    oldUsername: str = Field(..., min_length=3, max_length=50)
    newUsername: str = Field(..., min_length=3, max_length=50)
    password: str = Field(..., min_length=8, max_length=64)
    email: EmailStr = Field(..., description="Email válido")
    role: str = Field(..., min_length=6, max_length=10)
    
    @validator('oldUsername', 'newUsername')
    def username_alphanumeric(cls, v):
        if not re.match(r'^[a-zA-Z0-9 ]+$', v):
            raise ValueError('Username deve conter apenas letras, números ou espaços')
        return v
    
    @validator('password')
    def validate_password_strength(cls, v):
        if v is None or v == "":
            return v  # Senha opcional na atualização
        if len(v) < 8:
            raise ValueError('Senha deve ter pelo menos 8 caracteres')
        if not re.search(r'[A-Z]', v):
            raise ValueError('Senha deve conter pelo menos uma letra maiúscula')
        if not re.search(r'[a-z]', v):
            raise ValueError('Senha deve conter pelo menos uma letra minúscula')
        if not re.search(r'\d', v):
            raise ValueError('Senha deve conter pelo menos um número')
        if not re.search(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]', v):
            raise ValueError('Senha deve conter pelo menos um caractere especial')
        return v
    
    @validator('role')
    def validate_role(cls, v):
        allowed_roles = ['admin', 'manager', 'user']
        if v.lower() not in allowed_roles:
            raise ValueError(f'Role deve ser um dos seguintes: {", ".join(allowed_roles)}')
        return v.lower()

class DeleteUserSchema(BaseModel):
    username: str = Field(..., min_length=3, max_length=50)
    
    @validator('username')
    def username_alphanumeric(cls, v):
        if not re.match(r'^[a-zA-Z0-9 ]+$', v):
            raise ValueError('Username deve conter apenas letras, números ou espaços')
        return v

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    expires_in: int
    user: dict

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
    beacon: str = Field(..., min_length=1, max_length=50, description="ID do beacon")
    status: str = Field(..., min_length=1, max_length=20)
    tipo: str = Field(..., min_length=1, max_length=20)
    rssi1: Optional[float] = Field(None, ge=-100, le=0, description="RSSI Gateway 1")
    rssi2: Optional[float] = Field(None, ge=-100, le=0, description="RSSI Gateway 2") 
    rssi3: Optional[float] = Field(None, ge=-100, le=0, description="RSSI Gateway 3")
    x: Optional[float] = Field(None, description="Coordenada X")
    y: Optional[float] = Field(None, description="Coordenada Y")
    utc: int = Field(..., gt=0, description="Timestamp UTC")
    
    @validator('beacon')
    def validate_beacon_id(cls, v):
        if not re.match(r'^[a-zA-Z0-9_ -]+$', v):
            raise ValueError('ID do beacon deve conter apenas letras, números, _, - ou espaços')
        return v
    
    @validator('tipo')
    def validate_tipo(cls, v):
        allowed_types = ['funcionario', 'maquina', 'ferramenta', 'material']
        if v.lower() not in allowed_types:
            raise ValueError(f'Tipo deve ser um dos seguintes: {", ".join(allowed_types)}')
        return v.lower()

class BeaconUpdateTypeRequest(BaseModel):
    beacon: str = Field(..., min_length=1, max_length=50)
    tipo: str = Field(..., min_length=1, max_length=20)
    utc: int = Field(..., gt=0)
    
    @validator('beacon')
    def validate_beacon_id(cls, v):
        if not re.match(r'^[a-zA-Z0-9_ -]+$', v):
            raise ValueError('ID do beacon deve conter apenas letras, números, _, - ou espaços')
        return v
    
    @validator('tipo')
    def validate_tipo(cls, v):
        allowed_types = ['funcionario', 'maquina', 'ferramenta', 'material']
        if v.lower() not in allowed_types:
            raise ValueError(f'Tipo deve ser um dos seguintes: {", ".join(allowed_types)}')
        return v.lower()

class BeaconUpdateStatusRequest(BaseModel):
    beacon: str = Field(..., min_length=1, max_length=50)
    status: str = Field(..., min_length=1, max_length=20)
    utc: int = Field(..., gt=0)
    
    @validator('beacon')
    def validate_beacon_id(cls, v):
        if not re.match(r'^[a-zA-Z0-9_ -]+$', v):
            raise ValueError('ID do beacon deve conter apenas letras, números, _, - ou espaços')
        return v

class BeaconDeleteRequest(BaseModel):
    beacon: str = Field(..., min_length=1, max_length=50)
    
    @validator('beacon')
    def validate_beacon_id(cls, v):
        if not re.match(r'^[a-zA-Z0-9_ -]+$', v):
            raise ValueError('ID do beacon deve conter apenas letras, números, _, - ou espaços')
        return v

#---------------------------------------------------------------------------------------------------------------------------

class taskModel(BaseModel):
    id: int
    user: Optional[str] = None
    mensagem: str
    destino: str
    tipoDestino: str
    beacons: list
    tipo: str
    status: str

class TaskResponseSchema(BaseModel):
    Tasks: Dict[int, taskModel]

class TaskCreateRequest(BaseModel):
    mensagem: str = Field(..., min_length=5, max_length=500, description="Descrição da tarefa")
    destino: str = Field(..., min_length=1, max_length=200, description="Destino da tarefa")
    tipoDestino: str = Field(..., min_length=1, max_length=50)
    beacons: List[str] = Field(..., min_items=1, description="Lista de beacons necessários")
    tipo: str = Field(..., min_length=1, max_length=50)
    status: str = Field(..., min_length=1, max_length=50)
    
    @validator('tipoDestino')
    def validate_tipo_destino(cls, v):
        allowed_types = ['maquina', 'pessoa', 'coordenada']
        if v.lower() not in allowed_types:
            raise ValueError(f'Tipo de destino deve ser um dos seguintes: {", ".join(allowed_types)}')
        return v.lower()
        
class TaskUpdateRequest(BaseModel):
    id: int = Field(..., gt=0, description="ID da tarefa")
    user: Optional[str] = Field(None, max_length=50, description="Usuário responsável")
    mensagem: str = Field(..., min_length=5, max_length=500)
    destino: str = Field(..., min_length=1, max_length=200)
    tipoDestino: str = Field(..., min_length=1, max_length=50)
    beacons: List[str] = Field(..., min_items=1)
    tipo: str = Field(..., min_length=1, max_length=50)
    status: str = Field(..., min_length=1, max_length=50)
    
    @validator('user')
    def validate_user(cls, v):
        if v and not re.match(r'^[a-zA-Z0-9 ]+$', v):
            raise ValueError('Username deve conter apenas letras, números ou espaços')
        return v
    
    @validator('tipoDestino')
    def validate_tipo_destino(cls, v):
        allowed_types = ['maquina', 'pessoa', 'coordenada']
        if v.lower() not in allowed_types:
            raise ValueError(f'Tipo de destino deve ser um dos seguintes: {", ".join(allowed_types)}')
        return v.lower()

class TaskUpdateStatusRequest(BaseModel):
    id: int = Field(..., gt=0)
    status: str = Field(..., min_length=1, max_length=50)

class TaskDeleteRequest(BaseModel):
    id: int = Field(..., gt=0, description="ID da tarefa")

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