from pydantic import BaseModel

beaconsData = []
usersData = {}

class ResponseSchema(BaseModel):
    message: str