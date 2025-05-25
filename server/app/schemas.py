from pydantic import BaseModel

class ResponseSchema(BaseModel):
    message: str