import uvicorn
from app.main import app

if __name__ == "__main__":
    uvicorn.run(app, host="192.168.0.111", port=5501)