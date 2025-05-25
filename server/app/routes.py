from fastapi import APIRouter
from .schemas import ResponseSchema

router = APIRouter()

@router.get("/json", response_model=ResponseSchema)
async def get_json():
    return {"message": "Hello, World!"}