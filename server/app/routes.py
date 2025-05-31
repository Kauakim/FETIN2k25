from fastapi import APIRouter, HTTPException, status
from .schemas import BeaconsResponseSchema, InfoResponseSchema, LoginRequest, GatewayRequest, InfoRequest
from .models import updateRSSI, updateInfo
from .models import getBeaconsData, getUsersData, getInfoData

router = APIRouter()

@router.get("/beacons", response_model=BeaconsResponseSchema)
async def getBeacons():
    beaconsData = getBeaconsData()
    if not beaconsData:
        raise HTTPException(status_code=404, detail="No beacons found")
    return {"Beacons": beaconsData}

@router.get("/info", response_model=InfoResponseSchema)
async def getBeacons():
    infoData = getInfoData()
    if not infoData:
        raise HTTPException(status_code=404, detail="No info found")
    return {"Info": infoData}

@router.post("/login/")
async def loginRequest(request: LoginRequest):
    usersData = getUsersData()
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

@router.post("/rssi/")
async def RSSIRequest(request: GatewayRequest):
    beaconsData = getBeaconsData()
    beacon = beaconsData.get(request.beacon)
    if beacon not in beaconsData:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Beacon not found"
        )
    if request.rssi < 0 or request.rssi > 10000:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid RSSI value"
        )
    if request.gateway < 1 or request.gateway > 3:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid gateway value"
        )
    
    updateRSSI(beacon, request.rssi, request.gateway)
    return {"message": "RSSI updated successfully", "status_code": status.HTTP_200_OK}

@router.post("/info/")
async def infoRequest(request: InfoRequest):
    if(request.linha < 0):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid linha value"
        )
    if(request.maquina < 0):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid maquina value"
        )
    
    updateInfo(request.linha, request.maquina, request.numeroProdutos, request.horasTrabalhadas, request.rendimento, request.falhas)
    return {"message": "Info updated successfully", "status_code": status.HTTP_200_OK}