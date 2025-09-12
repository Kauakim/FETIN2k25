import uvicorn
import os
import dotenv
from app.main import app

dotenv.load_dotenv()

if __name__ == "__main__":
    uvicorn.run(app, host=os.getenv("SERVER_HOST", "127.0.0.1"), port=int(os.getenv("SERVER_PORT", 5501)))