# SIMTER 

### Principais Telas
- 🏠 **Login**: Interface de autenticação com logo SIMTER
- 🗺️ **Mapa**: Visualização interativa dos beacons em tempo real
- 📊 **Tabela**: Lista detalhada com filtros avançados
- ✅ **Tarefas**: Gerenciamento diferenciado por tipo de usuário
- 📈 **Relatórios**: Dashboard analítico (apenas Managers)
- 👤 **Perfil**: Configurações e informações do usuário

## Requisitos Técnicos

### 📱 Flutter Framework
- **Flutter SDK**: >= 3.0.0
- **Dart**: >= 3.0.0 < 4.0.0

### 📦 Principais Dependências
```yaml
dependencies:
  flutter: sdk: flutter
  flutter_localizations: sdk: flutter
  auto_size_text: 3.0.0
  badges: 2.0.2
  cached_network_image: 3.4.1
  easy_debounce: 2.0.1
  flutter_animate: 4.5.0
  font_awesome_flutter: 10.7.0
  from_css_color: 2.0.0
  go_router: 14.6.2
  google_fonts: 6.2.1
  http: 1.2.2
  intl: 0.19.0
  json_path: 0.7.4
  provider: 6.1.2
  shared_preferences: 2.3.2
  timeago: 3.7.0
  url_launcher: 6.3.1
```

## Instalação e Configuração

### 1. Pré-requisitos
```bash
# Instalar Flutter
flutter --version

# Verificar dependências
flutter doctor
```

### 2. Instalação
```bash
# Navegar para o diretório do app
cd app

# Instalar dependências
flutter pub get

# Executar o aplicativo
flutter run
```

### 3. Configuração da API

O aplicativo se conecta à API SIMTER. Configure a URL base da API em:
```dart
// lib/backend/api_requests/api_calls.dart
static String baseUrl = 'http://127.0.0.1:5501';
```

### Endpoints Utilizados
O app consome os seguintes endpoints da API SIMTER:

**Autenticação:**
- `POST /users/login/` - Login de usuários
- `GET /users/` - Informações dos usuários

**Beacons:**
- `GET /beacons/get/all/` - Listar todos os beacons
- `GET /beacons/get/{seconds}/` - Beacons dos últimos X segundos
- `POST /beacons/create/` - Criar novo beacon (Manager)
- `POST /beacons/update/status/` - Atualizar status
- `POST /beacons/delete/` - Deletar beacon (Manager)

**Tarefas:**
- `GET /tasks/read/all/` - Todas as tarefas (Manager)
- `GET /tasks/read/{user}/` - Tarefas do usuário (Worker)
- `POST /tasks/create/` - Criar tarefa (Manager)
- `POST /tasks/update/` - Atualizar tarefa (Manager)
- `POST /tasks/status/` - Atualizar status da tarefa
- `POST /tasks/delete/` - Deletar tarefa (Manager)

**Informações:**
- `GET /info/` - Dados para relatórios (Manager)
- `POST /info/create/` - Criar relatório (Manager)
- `POST /info/update/` - Atualizar relatório (Manager)

### 4. Build para Produção

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

**Windows:**
```bash
flutter build windows --release
```
### 5. Solução de Problemas

```bash
# Limpar cache e rebuildar
flutter clean
flutter pub get
flutter run
```
