from .core import models
from datetime import datetime, timezone

print("Deseja criar os usuarios base? (S/N)")
if input() == "S":
    models.createUser("João Pedro", "joao1234", "joao.pedro@fabrica.com", "worker")
    models.createUser("Kaua Ribeiro", "kaua1234", "kaua.ribeiro@fabrica.com", "worker")
    models.createUser("Giovana Vono", "giovana1234", "giovana.vono@fabrica.com", "manager")
    models.createUser("Nubia Rezende", "nubia1234", "nubia.rezende@fabrica.com", "manager")

print("Deseja criar os beacons base? (S/N)")
if input() == "S":
    models.createBeacon(datetime.now(timezone.utc), "Multimetro", "ferramenta", "disponivel", "", "", "", 15, 15)
    models.createBeacon(datetime.now(timezone.utc), "Kit de reparos", "ferramenta", "descarregado", "", "", "", 10, 10)
    models.createBeacon(datetime.now(timezone.utc), "Chapa de material", "material", "em uso", "", "", "", 20, 10)
    models.createBeacon(datetime.now(timezone.utc), "Estanho", "material", "disponivel", "", "", "", 20, 10)
    models.createBeacon(datetime.now(timezone.utc), "Componentes", "material", "disponivel", "", "", "", 20, 10)
    models.createBeacon(datetime.now(timezone.utc), "Filamento", "material", "disponivel", "", "", "", 20, 10)

print("Deseja criar as tasks base? (S/N)")
if input() == "S":
    models.createTask()

print("Deseja criar os relatorios base? (S/N)")
if input() == "S":
    models.createInfo("Impressora 3D", 0, 0, 0, datetime.now().strftime("%Y-%m-%d"))
    models.createInfo("Impressora", 0, 0, 0, datetime.now().strftime("%Y-%m-%d"))
    models.createInfo("Maquina de corrosao", 0, 0, 0, datetime.now().strftime("%Y-%m-%d"))
    models.createInfo("Estacao de solda", 0, 0, 0, datetime.now().strftime("%Y-%m-%d"))
    models.createInfo("CNC", 0, 0, 0, datetime.now().strftime("%Y-%m-%d"))
    models.createInfo("Maquina de corte", 0, 0, 0, datetime.now().strftime("%Y-%m-%d"))
