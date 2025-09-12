from fastapi import FastAPI
import os
from dotenv import load_dotenv
from .routes import router
from .core.process_manager import process_manager
from .core.rate_limiter import limiter, rate_limit_handler
from slowapi.errors import RateLimitExceeded

load_dotenv()

app = FastAPI(
    title="FETIN 2k25 API",
    description="Sistema de gerenciamento de tasks e beacons com segurança aprimorada",
    version="1.0.0"
)

# Configurar rate limiting
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, rate_limit_handler)

# Incluir rotas
app.include_router(router)

@app.on_event("startup")
async def startup():
    process_manager.start()

if __name__ == "__main__":
    import uvicorn
    host = os.getenv("SERVER_HOST", "127.0.0.1")
    port = int(os.getenv("SERVER_PORT", 5501))
    uvicorn.run(app, host=host, port=port)