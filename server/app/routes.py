from fastapi import APIRouter, HTTPException
from .schemas import beaconsData, usersData, ResponseSchema

router = APIRouter()

@router.get("/beacons", response_model=ResponseSchema)
async def getBeacons():
    if not beaconsData:
        raise HTTPException(status_code=404, detail="No beacons found")
    return {"Beacons": beaconsData}

@router.get("/user/{username}", response_model=ResponseSchema)
async def getUsernames(username: str):
    user = usersData.get(username)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return {"User": user}