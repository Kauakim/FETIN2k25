from fastapi import FastAPI
from .routes import router
from .schemas import beaconsData, usersData
from .models import getBeaconsData, getUsersData

app = FastAPI()

app.include_router(router)

@app.on_event("startup")
async def startup_event():
    global beaconsData, usersData
    beaconsData = getBeaconsData()
    usersData = getUsersData()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=5501)