from fastapi import FastAPI
from .routes import router
from .core.process_manager import process_manager

app = FastAPI()
app.include_router(router)

@app.on_event("startup")
async def startup():
    process_manager.start()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=5501)