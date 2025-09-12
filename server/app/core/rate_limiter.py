from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded
from fastapi import Request, HTTPException
from fastapi.responses import JSONResponse
import time

limiter = Limiter(key_func=get_remote_address)

async def rate_limit_handler(request: Request, exc: RateLimitExceeded):
    response = JSONResponse(
        status_code=429,
        content={
            "error": "Rate limit exceeded",
            "message": f"Muitas tentativas. Tente novamente em {exc.retry_after} segundos.",
            "retry_after": exc.retry_after
        }
    )
    response.headers["Retry-After"] = str(exc.retry_after)
    return response

# Rate limits específicos para diferentes tipos de endpoint
RATE_LIMITS = {
    "login": "5/minute",
    "general": "60/minute",
}

def get_rate_limit(operation_type: str) -> str:
    return RATE_LIMITS.get(operation_type, RATE_LIMITS["general"])

# Decorator para aplicar rate limiting personalizado
def apply_rate_limit(operation_type: str):
    def decorator(func):
        rate_limit = get_rate_limit(operation_type)
        return limiter.limit(rate_limit)(func)
    return decorator