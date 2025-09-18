from .core import models
from datetime import datetime
import time

print("Deseja criar os usuarios base? (S/N)")
if input().upper() == "S":
    models.createUser("João Pedro", "Joao1234*", "joao.pedro@fabrica.com", "worker")
    models.createUser("Kaua Ribeiro", "Kaua1234*", "kaua.ribeiro@fabrica.com", "worker")
    models.createUser("Giovana Vono", "Giovana1234*", "giovana.vono@fabrica.com", "manager")
    models.createUser("Nubia Rezende", "Nubia1234*", "nubia.rezende@fabrica.com", "manager")

print("Deseja criar os beacons base? (S/N)")
if input().upper() == "S":    
    current_timestamp = int(time.time())
    models.createBeacon(current_timestamp, "Multimetro", "ferramenta", "disponivel", None, None, None, 10.5, 5.25)
    models.createBeacon(current_timestamp, "Kit de reparos", "ferramenta", "descarregado", None, None, None, 11.5, 5.25)

    models.createBeacon(current_timestamp, "Chapa de material", "material", "em uso", None, None, None, 2, 1)
    models.createBeacon(current_timestamp, "Estanho", "material", "disponivel", None, None, None, 4, 1)
    models.createBeacon(current_timestamp, "Componentes", "material", "disponivel", None, None, None, 6, 1)
    models.createBeacon(current_timestamp, "Filamento", "material", "disponivel", None, None, None, 10, 1)
    
    models.createBeacon(current_timestamp, "Estacao de carga", "maquina", "disponivel", None, None, None, 11, 5.25)
    models.createBeacon(current_timestamp, "Impressora 3D", "maquina", "disponivel", None, None, None, 6.75, 4.5)
    models.createBeacon(current_timestamp, "Impressora", "maquina", "disponivel", None, None, None, 8.2, 2)
    models.createBeacon(current_timestamp, "Maquina de corrosao", "maquina", "disponivel", None, None, None, 0.6, 2)
    models.createBeacon(current_timestamp, "Estacao de solda", "maquina", "disponivel", None, None, None, 3, 2)
    models.createBeacon(current_timestamp, "CNC", "maquina", "disponivel", None, None, None, 3, 4.5)
    models.createBeacon(current_timestamp, "Maquina de corte", "maquina", "disponivel", None, None, None, 5.6, 2)
    models.createBeacon(current_timestamp, "Bancada de reparos e carga", "maquina", "disponivel", None, None, None, 11.3, 0.75)

print("Deseja criar as tasks base? (S/N)")
if input().upper() == "S":
    models.createTask(
        "Verificar e calibrar o multimetro digital para garantir precisão nas medições",
        "Bancada de reparos e carga",
        "maquina",
        ["Multimetro"],
        "Manutencao",
        "Pendente"
    )
    
    models.createTask(
        "Produzir componentes eletrônicos utilizando estanho e kit de reparos",
        "Estacao de solda",
        "maquina",
        ["Estanho", "Kit de reparos"],
        "Fabricacao",
        "Em Andamento"
    )
    
    models.createTask(
        "Transportar materiais da impressora 3D para a estação de montagem",
        "4,6",
        "coordenada",
        ["Filamento", "Componentes", "Chapa de material"],
        "Transporte",
        "Pendente"
    )
    
    models.createTask(
        "Fabricação de protótipo completo utilizando todas as máquinas disponíveis",
        "Impressora",
        "maquina",
        ["Impressora 3D", "CNC", "Maquina de corte", "Estacao de solda", "Maquina de corrosao", "Bancada de reparos e carga"],
        "Fabricacao",
        "Concluída"
    )
    
print("Deseja criar os relatorios base? (S/N)")
if input().upper() == "S":
    models.createInfo("Impressora 3D", 0, 0, 0, datetime.now().strftime("%Y-%m-%d"))
    models.createInfo("Impressora", 0, 0, 0, datetime.now().strftime("%Y-%m-%d"))
    models.createInfo("Maquina de corrosao", 0, 0, 0, datetime.now().strftime("%Y-%m-%d"))
    models.createInfo("Estacao de solda", 0, 0, 0, datetime.now().strftime("%Y-%m-%d"))
    models.createInfo("CNC", 0, 0, 0, datetime.now().strftime("%Y-%m-%d"))
    models.createInfo("Maquina de corte", 0, 0, 0, datetime.now().strftime("%Y-%m-%d"))
