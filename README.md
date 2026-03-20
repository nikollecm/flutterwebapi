# Flutter Web API - Diary App

Um aplicativo de diário simples construído com Flutter para demonstrar integração com APIs REST.

## Por que construí isso

Este projeto foi criado como uma forma prática de aprender e implementar integração de Web APIs em Flutter. A ideia era construir algo funcional e útil enquanto explorava conceitos fundamentais como:

- Requisições HTTP (GET, POST, PUT, DELETE)
- Gerenciamento de estado
- Navegação entre telas
- Persistência de dados via API REST
- Arquitetura de serviços

Escolhi um app de diário porque é simples o suficiente para focar no aprendizado da API, mas completo o suficiente para cobrir todas as operações CRUD.

## Funcionalidades

- Criar novas entradas de diário
- Listar todas as entradas
- Editar entradas existentes
- Excluir entradas (com confirmação)
- Interface limpa e intuitiva

## Tecnologias

- **Flutter** - Framework UI
- **Dio** - Cliente HTTP para requisições à API
- **UUID** - Geração de IDs únicos
- **Logger** - Logging de requisições e respostas
- **JSON Server** - API REST mock para desenvolvimento

## Estrutura do Projeto

```
lib/
├── models/
│   └── entry.dart          # Modelo de dados da entrada
├── screens/
│   ├── home_screen.dart    # Tela principal com lista de entradas
│   └── add_entry_screen.dart # Tela de criar/editar entrada
├── services/
│   └── entry_service.dart  # Serviço de comunicação com a API
└── main.dart               # Ponto de entrada do app
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

## Estrutura do db.json

```json
{
  "entries": [
    {
      "id": "uuid-aqui",
      "title": "Minha primeira entrada",
      "desc": "Conteúdo da entrada...",
      "date": "2026-03-20T10:30:00.000"
    }
  ]
}
```

## Aprendizados

Durante o desenvolvimento deste projeto, aprendi:

1. Como estruturar serviços de API em Flutter
2. Gerenciamento de estado com StatefulWidget
3. Navegação e passagem de dados entre telas
4. Tratamento de operações assíncronas
5. Boas práticas de arquitetura (separação de concerns)
6. Uso de interceptors para logging de requisições

## Próximos passos

- [ ] Implementar busca e filtros
- [ ] Adicionar suporte offline com cache local
- [ ] Melhorar UI/UX com animações

## Licença

Este projeto é de código aberto e está disponível para fins educacionais.
