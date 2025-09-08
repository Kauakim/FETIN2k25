from .core import models
from datetime import datetime
import time

print("Deseja criar os usuarios base? (S/N)")
if input().upper() == "S":
    models.createUser("João Pedro", "joao1234", "joao.pedro@fabrica.com", "worker")
    models.createUser("Kaua Ribeiro", "kaua1234", "kaua.ribeiro@fabrica.com", "worker")
    models.createUser("Giovana Vono", "giovana1234", "giovana.vono@fabrica.com", "manager")
    models.createUser("Nubia Rezende", "nubia1234", "nubia.rezende@fabrica.com", "manager")

print("Deseja criar os beacons base? (S/N)")
if input().upper() == "S":    
    current_timestamp = int(time.time())
    models.createBeacon(current_timestamp, "Multimetro", "ferramenta", "disponivel", None, None, None, 15, 15)
    models.createBeacon(current_timestamp, "Kit de reparos", "ferramenta", "descarregado", None, None, None, 10, 10)
    models.createBeacon(current_timestamp, "Chapa de material", "material", "em uso", None, None, None, 20.2, 10)
    models.createBeacon(current_timestamp, "Estanho", "material", "disponivel", None, None, None, 20, 15.5)
    models.createBeacon(current_timestamp, "Componentes", "material", "disponivel", None, None, None, 20, 15)
    models.createBeacon(current_timestamp, "Filamento", "material", "disponivel", None, None, None, 20, 12)
    models.createBeacon(current_timestamp, "Estacao de carga", "maquina", "disponivel", None, None, None, 10, 30)
    models.createBeacon(current_timestamp, "Impressora 3D", "maquina", "disponivel", None, None, None, 10, 30)
    models.createBeacon(current_timestamp, "Impressora", "maquina", "disponivel", None, None, None, 10, 30)
    models.createBeacon(current_timestamp, "Maquina de corrosao", "maquina", "disponivel", None, None, None, 10, 20)
    models.createBeacon(current_timestamp, "Estacao de solda", "maquina", "disponivel", None, None, None, 0, 0)
    models.createBeacon(current_timestamp, "CNC", "maquina", "disponivel", None, None, None, 10, 10)
    models.createBeacon(current_timestamp, "Maquina de corte", "maquina", "disponivel", None, None, None, 10, 30)
    models.createBeacon(current_timestamp, "Bancada de reparos e carga", "maquina", "disponivel", None, None, None, 10, 30)

print("Deseja criar as tasks base? (S/N)")
if input().upper() == "S":
    print("Criacao do database de teste da tabela de tasks ainda não implementada")

print("Deseja criar os relatorios base? (S/N)")
if input().upper() == "S":
    models.createInfo("Impressora 3D", 0, 0, 0, datetime.now().strftime("%Y-%m-%d"))
    models.createInfo("Impressora", 0, 0, 0, datetime.now().strftime("%Y-%m-%d"))
    models.createInfo("Maquina de corrosao", 0, 0, 0, datetime.now().strftime("%Y-%m-%d"))
    models.createInfo("Estacao de solda", 0, 0, 0, datetime.now().strftime("%Y-%m-%d"))
    models.createInfo("CNC", 0, 0, 0, datetime.now().strftime("%Y-%m-%d"))
    models.createInfo("Maquina de corte", 0, 0, 0, datetime.now().strftime("%Y-%m-%d"))
