# SendRecord - Sistema de Gestão de Pedidos Mount Vernon
Sistema desktop de gestão de pedidos e empacotamento com módulo completo de Segurança e Auditoria

## 📘 Sobre o Projeto
O **SendRecord** é uma aplicação desktop desenvolvida com **Electron** e **Node.js** para gerenciar pedidos e controlar o empacotamento de camisas da Mount Vernon. O sistema integra funcionalidades de vendas, estoque, clientes e um **módulo robusto de Segurança e Auditoria** que garante rastreabilidade total de todas as ações realizadas.

O projeto contempla controle hierárquico de acesso (RBAC) com 4 níveis de usuário, autenticação segura com bcrypt e registro automático de logs em banco de dados.

## 🎯 Objetivos
* Automatizar o controle de pedidos e empacotamento
* Garantir segurança através de autenticação robusta (bcrypt)
* Implementar auditoria completa com rastreabilidade de ações
* Controlar acesso hierárquico por níveis de permissão (RBAC)
* Registrar automaticamente todas as operações no banco de dados
* Proteger contra ataques comuns (SQL Injection, XSS)

## 👥 Níveis de Acesso e Funcionalidades

### 👨‍💼 Admin
* Acesso total ao sistema
* Gerenciar usuários (criar, editar, deletar)
* Configurar APIs e credenciais
* Visualizar logs e auditoria completa
* Exportar relatórios

### 👔 Gerente
* Criar e gerenciar produtos
* Gerenciar usuários (criar, editar)
* Criar pedidos e gerenciar clientes
* Visualizar relatórios e estatísticas
* Acesso aos logs de auditoria

### 👷 Supervisor
* Criar e editar pedidos
* Gerenciar empacotamento
* Visualizar relatórios
* Consultar histórico de ações

### 🧑‍🔧 Operador
* Consultar produtos e pedidos
* Realizar empacotamento
* Escanear códigos de barras
* Visualizar próprias atividades

## 🔐 Módulo de Segurança e Auditoria

### Autenticação Segura
* **Hash de senhas** com bcrypt (10 rounds)
* **Sessões** com timeout de 30 minutos
* **Registro automático** de login/logout

### Sistema RBAC (Role-Based Access Control)
* 4 níveis hierárquicos de permissão
* Controle granular por funcionalidade
* Middlewares para proteção de rotas

### Auditoria Completa
* **Registro automático** de todas as ações
* **Rastreamento**: quem, o quê, quando, de onde (IP)
* **Duas tabelas de log**:
  - `logs_sistema` → Todas as requisições
  - `auditoria_sistema` → Mudanças críticas com antes/depois

### Proteção Contra Ataques
* Validação e sanitização de inputs
* Proteção contra SQL Injection
* Proteção contra XSS (Cross-Site Scripting)
* Headers HTTP seguros configurados

## 🖥️ Como Executar o Projeto Localmente

### 1. Clone o repositório
```bash
git clone https://github.com/LuizaProcopio/SendRecord.git
cd SendRecord
```

### 2. Instale as dependências
```bash
npm install express mysql2 ejs express-session dotenv multer bcrypt cors
npm install electron --save-dev
npm install electron-builder --save
```

### 3. Configure o `.env`
Crie um arquivo `.env` na raiz do projeto:

```env
# Banco de Dados
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=sua_senha
DB_NAME=banco_pi
DB_PORT=3306

# Servidor
PORT=4040
NODE_ENV=development
```

### 4. Importe o banco de dados
Execute o arquivo SQL fornecido no MySQL:
```bash
mysql -u root -p < banco_pi.sql
```

Ou via MySQL Workbench:
- File → Run SQL Script → Selecione `banco_pi.sql`

### 5. Inicie a aplicação
```bash
npm start
```

A aplicação Electron será iniciada automaticamente e o servidor estará rodando em `http://localhost:4040`

## 📊 Estrutura de Pastas
```
SendRecord/
├── renderer/
│   ├── views/              → Telas EJS (login, home, vendas, config)
│   └── public/
│       ├── css/            → Estilos
│       └── img/            → Imagens e ícones
├── server/
│   ├── routers/            → Rotas da aplicação
│   ├── security/           → ⭐ Módulo de Segurança
│   │   ├── authI.js        → Autenticação com bcrypt
│   │   ├── rbac.js         → Controle de acesso (RBAC)
│   │   ├── audit.js        → Sistema de auditoria
│   │   └── validation.js   → Validação e sanitização
│   ├── config/
│   │   └── logger.js       → ⭐ Sistema de logs automático
│   ├── db.js               → Conexão MySQL
│   └── app.js              → Servidor Express
├── main.js                 → Inicialização Electron
├── preload.js              → Comunicação segura
├── .env                    → Variáveis de ambiente
└── package.json
```

## 🔑 Usuários Padrão

| Nome | Email | Senha | Nível |
|------|-------|-------|-------|
| Administrador Sistema | admin@mountvernon.com.br | admin123 | admin |
| Carlos Silva | carlos.silva@mountvernon.com.br | gerente123 | gerente |
| Maria Santos | maria.santos@mountvernon.com.br | supervisor123 | supervisor |
| João Oliveira | joao.oliveira@mountvernon.com.br | operador123 | operador |

## 📝 Exemplo de Logs Gerados

### Tabela: `logs_sistema`
```sql
SELECT 
  usuario_app_nome,
  acao,
  query_executada,
  ip_address,
  DATE_FORMAT(data_hora, '%d/%m/%Y %H:%i:%s') as momento
FROM logs_sistema
ORDER BY data_hora DESC
LIMIT 10;
```

**Exemplo de resultado:**
| usuario_app_nome | acao | query_executada | ip_address | momento |
|-----------------|------|-----------------|-----------|---------|
| Carlos Silva | LOGIN | Login bem-sucedido | 127.0.0.1 | 14/11/2025 20:30:15 |
| Carlos Silva | SELECT | GET /vendas | 127.0.0.1 | 14/11/2025 20:30:20 |

### Tabela: `auditoria_sistema`
```sql
SELECT 
  u.nome as usuario,
  a.acao,
  a.descricao,
  a.tabela_afetada,
  DATE_FORMAT(a.data_hora, '%d/%m/%Y %H:%i') as momento
FROM auditoria_sistema a
LEFT JOIN usuarios u ON a.usuario_id = u.id
ORDER BY a.data_hora DESC
LIMIT 10;
```

**Exemplo de resultado:**
| usuario | acao | descricao | tabela_afetada | momento |
|---------|------|-----------|----------------|---------|
| Carlos Silva | LOGIN | Usuário autenticado com sucesso | usuarios | 14/11/2025 20:30 |
| Carlos Silva | INSERT | Pedido 123 criado | pedidos | 14/11/2025 20:35 |

## 🛠️ Ferramentas e Tecnologias

### Backend
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![Express](https://img.shields.io/badge/Express-000000?style=for-the-badge&logo=express&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)

### Frontend
![Electron](https://img.shields.io/badge/Electron-47848F?style=for-the-badge&logo=electron&logoColor=white)
![EJS](https://img.shields.io/badge/EJS-B4CA65?style=for-the-badge&logo=ejs&logoColor=black)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)

### Segurança
![bcrypt](https://img.shields.io/badge/bcrypt-338?style=for-the-badge)
![JWT](https://img.shields.io/badge/JWT-000000?style=for-the-badge&logo=jsonwebtokens&logoColor=white)

## 📚 Arquivos Principais do Módulo de Segurança

### `server/config/logger.js`
Sistema centralizado de logs:
```javascript
// Registrar login
Logger.login(userId, userName, ipAddress);

// Registrar logout
Logger.logout(userId, userName, ipAddress);

// Registrar ação na auditoria
Logger.salvarAuditoria({
  usuarioId, acao, descricao, tabela, registroId, ip
});
```

### `server/security/authI.js`
Autenticação com bcrypt:
```javascript
// Login seguro
await auth.login(email, password, ipAddress);

// Validar sessão
auth.validateSession(token);

// Logout
auth.logout(token);
```

### `server/security/rbac.js`
Controle de acesso:
```javascript
// Verificar permissão
rbac.hasPermission(userRole, 'users.create');

// Middleware para rotas
app.use('/api/users', rbac.requirePermission('users.create'));
```

## 🎓 Disciplinas Contempladas

### ✅ Segurança e Auditoria de Sistemas de Informação
- Autenticação segura (bcrypt)
- Controle de acesso (RBAC)
- Registro de auditoria
- Proteção contra ataques

### ✅ Desenvolvimento de Software Corporativo
- Arquitetura modular
- Padrões de projeto
- Boas práticas de código
- Sistema desktop corporativo

### ✅ Estrutura de Dados
- Manipulação eficiente de sessões (Map)
- Estruturas hierárquicas (RBAC)
- Organização de permissões

## 👨‍💻 Desenvolvido por

Este projeto foi desenvolvido como parte do módulo de **Desenvolvimento de Software Corporativo** e **Segurança e Auditoria de Sistemas de Informação** do curso de Análise e Desenvolvimento de Sistemas da UNIFEOB.

### Equipe de Desenvolvimento

**Módulo de Segurança e Auditoria:**
- [Seu Nome] - Implementação completa do sistema de segurança, autenticação, RBAC e auditoria

**Sistema Base:**
- Luiza Procopio - Desenvolvimento da aplicação base
- Repositório: [github.com/LuizaProcopio/SendRecord](https://github.com/LuizaProcopio/SendRecord)

---

Desenvolvido com foco em **segurança**, **rastreabilidade** e **controle de acesso** no ambiente corporativo.
