# SIMTER API

API REST desenvolvida em FastAPI para gerenciamento de sistema de localização em tempo real (RTLS).

## Dependências

A aplicação utiliza as seguintes dependências Python:

- **FastAPI**
- **Uvicorn**
- **Pydantic**
- **slowapi**
- **python-dotenv**

Para instalar as dependências necessárias, execute:

```bash
pip install fastapi uvicorn pydantic slowapi python-dotenv
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

## Recursos de Segurança

A API implementa várias medidas de segurança:

### Rate Limiting
- **Login:** 10 requisições por minuto
- **Cadastro:** 10 requisições por minuto
- **Operações gerais:** 60 requisições por minuto
- **Criação de dados:** 30 requisições por minuto
- **Deleção:** 20 requisições por minuto
- **RSSI updates:** 120 requisições por minuto

### Validação de Senhas
- Mínimo de 8 caracteres
- Pelo menos 1 letra maiúscula
- Pelo menos 1 letra minúscula
- Pelo menos 1 número
- Pelo menos 1 caractere especial

### Validação de Dados
- Validação rigorosa de entrada usando Pydantic
- Sanitização de usernames e IDs de beacons
- Validação de tipos e status permitidos

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
  "password": "Senha123!",
  "email": "user@email.com",
  "role": "worker"
}
```

**Observações:**
- A senha deve ter pelo menos 8 caracteres
- Deve conter ao menos: 1 maiúscula, 1 minúscula, 1 número e 1 caractere especial
- Roles disponíveis: `admin`, `manager`, `worker`

#### GET `/users/`
Retorna todos os usuários (sem senhas).

#### GET `/users/get/all/`
Retorna lista de todos os usuários com informações básicas.

#### POST `/users/update/`
Atualiza informações de um usuário existente.

**Body:**
```json
{
  "oldUsername": "joao1234",
  "newUsername": "joao_pedro",
  "password": "NovaSenha123!",
  "email": "joao@email.com",
  "role": "manager"
}
```

**Observação:** O campo `password` é opcional. Se não fornecido, mantém a senha atual.

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

**Observações:**
- Tipos disponíveis: `funcionario`, `maquina`, `ferramenta`, `material`
- RSSI valores devem estar entre -100 e 0
- Campos `rssi1`, `rssi2`, `rssi3`, `x` e `y` são opcionais

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
  "tipoDestino": "maquina",
  "beacons": ["beacon_001", "beacon_002"],
  "tipo": "movimentacao",
  "status": "pendente"
}
```

**Observações:**
- `tipoDestino` pode ser: `maquina`, `pessoa`, `coordenada`
- `beacons` deve conter pelo menos 1 item
- Campo `dependencias` foi removido da implementação atual

#### POST `/tasks/update/`
Atualiza uma tarefa existente.

**Body:**
```json
{
  "id": 1,
  "user": "joao1234",
  "mensagem": "Mover material para estação 3",
  "destino": "estacao_3",
  "tipoDestino": "maquina",
  "beacons": ["beacon_001"],
  "tipo": "movimentacao",
  "status": "em_andamento"
}
```

**Observação:** Campo `user` é opcional.

#### POST `/tasks/status/`
Atualiza apenas o status de uma tarefa.

**Body:**
```json
{
  "id": 1,
  "status": "concluida"
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

#### GET `/info/`
Retorna todas as informações das máquinas do sistema.

#### POST `/info/create/`
Cria um novo registro de informações de máquina.

**Body:**
```json
{
  "maquina": "Impressora_3D",
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
  "maquina": "Impressora_3D",
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
  "maquina": "Impressora_3D",
  "data": "2024-01-15"
}
```
