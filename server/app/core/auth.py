from passlib.context import CryptContext
import re
from typing import Tuple
import os
from dotenv import load_dotenv

load_dotenv()

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(password: str) -> str:
    """Hash da senha usando bcrypt"""
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verifica se a senha plain text corresponde ao hash"""
    return pwd_context.verify(plain_password, hashed_password)

def get_password_requirements() -> dict:
    """Retorna os requisitos mínimos de senha"""
    return {
        "min_length": 8,
        "require_uppercase": True,
        "require_lowercase": True,
        "require_digit": True,
        "require_special": True
    }

def validate_password_strength(password: str) -> Tuple[bool, str]:
    """Valida a força da senha"""
    requirements = get_password_requirements()
    
    if len(password) < requirements["min_length"]:
        return False, f"Senha deve ter pelo menos {requirements['min_length']} caracteres"
    
    if requirements["require_uppercase"] and not any(c.isupper() for c in password):
        return False, "Senha deve conter pelo menos uma letra maiúscula"
    
    if requirements["require_lowercase"] and not any(c.islower() for c in password):
        return False, "Senha deve conter pelo menos uma letra minúscula"
    
    if requirements["require_digit"] and not any(c.isdigit() for c in password):
        return False, "Senha deve conter pelo menos um número"
    
    if requirements["require_special"] and not re.search(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]', password):
        return False, "Senha deve conter pelo menos um caractere especial"
    
    return True, "Senha válida"