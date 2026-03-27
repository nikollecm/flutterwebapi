# Flutter Web API - Diary App

Um aplicativo de diário simples construído com Flutter para demonstrar integração com APIs REST.

## Demonstração

<div align="center">
  <img src="assets/demo.gif" alt="Demonstração do App" width="300"/>
  <p><i>Demonstração das principais funcionalidades do app</i></p>
</div>

## Por que fiz esse projeto

Este projeto foi criado como uma forma prática de aprender e implementar integração de Web APIs em Flutter. A ideia era construir algo funcional e útil enquanto explorava conceitos fundamentais como:

- Requisições HTTP (GET, POST, PUT, DELETE)
- Gerenciamento de estado
- Navegação entre telas
- Persistência de dados via API REST
- Arquitetura de serviços

## Funcionalidades

- **Bottom Navigation Bar** com 3 abas:
  - Home: Lista de todas as entradas
  - Adicionar: Criar nova entrada
  - Tema: Alternar entre modo claro e escuro (padrão: claro)
- **Suporte Offline com Cache Local**:
  - Todas as operações funcionam offline
  - Dados salvos localmente com SharedPreferences
  - Sincronização automática quando online
  - Indicador visual de status de conexão
  - Pull-to-refresh para sincronizar manualmente
- Criar novas entradas de diário
- Listar todas as entradas
- Editar entradas existentes
- Excluir entradas
- Tema claro/escuro com gerenciamento de estado
- Interface limpa e intuitiva

## Tecnologias

- **Flutter** - Framework UI
- **Dio** - Cliente HTTP para requisições à API
- **Provider** - Gerenciamento de estado para temas
- **SharedPreferences** - Cache local para suporte offline
- **UUID** - Geração de IDs únicos
- **Logger** - Logging de requisições e respostas
- **JSON Server** - API REST mock para desenvolvimento

## Estrutura do Projeto

```
lib/
├── models/
│   └── entry.dart              # Modelo de dados da entrada
├── providers/
│   └── theme_provider.dart     # Provider para gerenciamento de tema
├── screens/
│   ├── main_screen.dart        # Tela principal com bottom navigation
│   ├── home_screen.dart        # Tela com lista de entradas
│   └── add_entry_screen.dart   # Tela de criar/editar entrada
├── services/
│   ├── entry_service.dart      # Serviço de comunicação com a API
│   └── local_storage_service.dart # Serviço de cache local
└── main.dart                   # Ponto de entrada do app
```

## Como executar

### Pré-requisitos

- Flutter SDK (3.10.7 ou superior)
- Node.js (para o JSON Server)
- Um emulador Android/iOS ou dispositivo físico

### Passo 1: Instalar dependências do Flutter

```bash
flutter pub get
```

### Passo 2: Iniciar o servidor JSON

O projeto usa JSON Server como backend mock. Instale e execute:

```bash
npm install -g json-server
json-server --watch db.json --port 3000
```

### Passo 3: Executar o app

```bash
flutter run
```

**Nota:** O app está configurado para usar `http://10.0.2.2:3000` (endereço localhost do emulador Android). Se estiver usando iOS ou dispositivo físico, ajuste o `baseUrl` em `lib/services/entry_service.dart`.

## API Endpoints

O app consome os seguintes endpoints:

- `GET /entries` - Lista todas as entradas
- `POST /entries` - Cria uma nova entrada
- `PUT /entries/:id` - Atualiza uma entrada existente
- `DELETE /entries/:id` - Exclui uma entrada

## Licença

- Este projeto é de código aberto e está disponível para fins educacionais.
- Icons from Pixel Icon Library by HackerNoon
