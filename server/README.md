# SIMTER API

API REST desenvolvida em FastAPI para gerenciamento de sistema de localização em tempo real (RTLS).

## Dependências

A aplicação utiliza as seguintes dependências Python:

- **FastAPI**
- **Uvicorn**
- **Pydantic**

Para instalar as dependências necessárias, execute:

```bash
pip install fastapi uvicorn pydantic
```

## Como Executar

1. Navegue até a pasta do servidor:
```bash
cd server
```

2. Execute a aplicação:
```bash
python run.py
```

A API estará disponível em: `http://127.0.0.1:5501`

## Documentação da API

### Rotas de Usuários (USERS)

#### POST `/users/login/`
Autentica um usuário existente.

**Body:**
```json
{
  "username": "joao1234",
  "password": "senha123"
}
```

#### POST `/users/signin/`
Cria um novo usuário.

**Body:**
```json
{
  "username": "novo_user",
  "password": "senha123",
  "email": "user@email.com",
  "role": "worker"
}
```

#### POST `/users/update/`
Atualiza informações de um usuário existente.

**Body:**
```json
{
  "oldUsername": "joao1234",
  "newUsername": "joao_pedro",
  "password": "nova_senha",
  "email": "joao@email.com",
  "role": "manager"
}
```

#### POST `/users/delete/`
Remove um usuário do sistema.

**Body:**
```json
{
  "username": "joao_pedro"
}
```

### Rotas de Beacons (BEACONS)

#### GET `/beacons/get/all/`
Retorna todos os beacons cadastrados no sistema.

**Resposta:** Lista de todos os beacons

#### GET `/beacons/get/{seconds}/`
Retorna beacons dos últimos X segundos.

**Exemplo:** `/beacons/get/30` - Retorna beacons dos últimos 30 segundos

#### POST `/beacons/create/`
Cria um novo beacon no sistema.

**Body:**
```json
{
  "utc": 1703123456,
  "beacon": "beacon_001",
  "tipo": "ferramenta",
  "status": "disponivel",
  "rssi1": -45.5,
  "rssi2": -50.2,
  "rssi3": -48.7,
  "x": 15.5,
  "y": 20.3
}
```

#### POST `/beacons/update/tipo/`
Atualiza o tipo de um beacon.

**Body:**
```json
{
  "utc": 1703123456,
  "beacon": "beacon_001",
  "tipo": "material"
}
```

#### POST `/beacons/update/status/`
Atualiza o status de um beacon.

**Body:**
```json
{
  "utc": 1703123456,
  "beacon": "beacon_001",
  "status": "em uso"
}
```

#### POST `/beacons/delete/`
Remove um beacon do sistema.

**Body:**
```json
{
  "beacon": "beacon_001"
}
```

#### POST `/rssi/`
Atualiza dados RSSI dos beacons através dos gateways.

**Body:**
```json
{
  "Gateways": {
    "1": {
      "beacon": "beacon_001",
      "status": "disponivel",
      "tipo": "ferramenta",
      "gateway": 1,
      "rssi": -42.3,
      "utc": 1703123456
    },
    "2": {
      "beacon": "beacon_001",
      "status": "disponivel",
      "tipo": "ferramenta",
      "gateway": 2,
      "rssi": -48.1,
      "utc": 1703123456
    }
  }
}
```

### Rotas de Tarefas (TASKS)

#### GET `/tasks/read/all/`
Retorna todas as tarefas do sistema.

#### GET `/tasks/read/{user}/`
Retorna todas as tarefas de um usuário específico.

**Exemplo:** `/tasks/read/joao1234`

#### POST `/tasks/create/`
Cria uma nova tarefa.

**Body:**
```json
{
  "mensagem": "Mover material para estação 2",
  "destino": "estacao_2",
  "tipoDestino": "local",
  "beacons": ["beacon_001", "beacon_002"],
  "dependencias": ["task_001"],
  "tipo": "movimentacao",
  "status": "pendente"
}
```

#### POST `/tasks/update/`
Atualiza uma tarefa existente.

**Body:**
```json
{
  "id": 1,
  "user": "joao1234",
  "mensagem": "Mover material para estação 3",
  "destino": "estacao_3",
  "tipoDestino": "local",
  "beacons": ["beacon_001"],
  "dependencias": [],
  "tipo": "movimentacao",
  "status": "em_andamento"
}
```

#### POST `/tasks/status/`
Atualiza apenas o status de uma tarefa.

**Body:**
```json
{
  "id": 1,
  "status": "concluida"
}
```

#### POST `/tasks/cancel/`
Cancela uma tarefa.

**Body:**
```json
{
  "id": 1,
  "status": "cancelada",
  "cancelamento": "Material não disponível"
}
```

#### POST `/tasks/delete/`
Remove uma tarefa do sistema.

**Body:**
```json
{
  "id": 1
}
```

### Rotas de Informações (INFO)

#### GET `/info`
Retorna todas as informações das máquinas do sistema.

#### POST `/info/create/`
Cria um novo registro de informações de máquina.

**Body:**
```json
{
  "maquina": "Impressora 3D",
  "tasksConcluidas": 5,
  "tasksCanceladas": 1,
  "horasTrabalhadas": 8.5,
  "data": "2024-01-15"
}
```

#### POST `/info/update/`
Atualiza informações de uma máquina.

**Body:**
```json
{
  "maquina": "Impressora 3D",
  "tasksConcluidas": 10,
  "tasksCanceladas": 2,
  "horasTrabalhadas": 12.0,
  "data": "2024-01-15"
}
```

#### POST `/info/delete/`
Remove informações de uma máquina.

**Body:**
```json
{
  "maquina": "Impressora 3D",
  "data": "2024-01-15"
}
```
