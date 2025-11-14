# SendRecord - Sistema de Gestão de Pedidos Mount Vernon

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

### 4. Crie o banco de dados
```create database banco_pi
```

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

## 🛠️ Ferramentas e Tecnologias
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![Express](https://img.shields.io/badge/Express-000000?style=for-the-badge&logo=express&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Electron](https://img.shields.io/badge/Electron-47848F?style=for-the-badge&logo=electron&logoColor=white)
![EJS](https://img.shields.io/badge/EJS-B4CA65?style=for-the-badge&logo=ejs&logoColor=black)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)
![bcrypt](https://img.shields.io/badge/bcrypt-338?style=for-the-badge)
![JWT](https://img.shields.io/badge/JWT-000000?style=for-the-badge&logo=jsonwebtokens&logoColor=white)

## 👨‍💻 Desenvolvido por

Este projeto foi desenvolvido como parte do módulo de **Desenvolvimento de Software Corporativo** e **Segurança e Auditoria de Sistemas de Informação** do curso de Análise e Desenvolvimento de Sistemas da UNIFEOB.

### Equipe de Desenvolvimento

- Danilo Deademe Azevedo
- Luis Miguel Vitor
- Maria Luiza Tavares Procopio
---

Desenvolvido com foco em **segurança**, **rastreabilidade** e **controle de acesso** no ambiente corporativo.
