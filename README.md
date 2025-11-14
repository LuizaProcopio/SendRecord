# SendRecord - Sistema de Gestão de Pedidos Mount Vernon
Sistema desktop de gestão de pedidos e empacotamento com módulos completos de Segurança, Auditoria e Estrutura de Dados

## 📘 Sobre o Projeto
O **SendRecord** é uma aplicação desktop desenvolvida com **Electron** e **Node.js** para gerenciar pedidos e controlar o empacotamento de camisas da Mount Vernon. O sistema integra funcionalidades de vendas, estoque, clientes, um **módulo robusto de Segurança e Auditoria** que garante rastreabilidade total de todas as ações realizadas e implementação de **Estruturas de Dados** para otimização de processos críticos.

O projeto contempla controle hierárquico de acesso (RBAC) com 4 níveis de usuário, autenticação segura com bcrypt, registro automático de logs em banco de dados e fila de processamento implementada com lista encadeada para gerenciamento eficiente de tarefas de embalagem.

## 🎯 Objetivos
* Automatizar o controle de pedidos e empacotamento
* Garantir segurança através de autenticação robusta (bcrypt)
* Implementar auditoria completa com rastreabilidade de ações
* Controlar acesso hierárquico por níveis de permissão (RBAC)
* Registrar automaticamente todas as operações no banco de dados
* Proteger contra ataques comuns (SQL Injection, XSS)
* Implementar estruturas de dados eficientes (Fila com Lista Encadeada)
* Garantir operações em tempo constante O(1) para processos críticos
* Gerar relatórios e visualizações gráficas para análise de dados

## 👥 Níveis de Acesso e Funcionalidades

### 👨‍💼 Admin
* Acesso total ao sistema
* Gerenciar usuários (criar, editar, deletar)
* Configurar APIs e credenciais
* Visualizar relatórios completos com gráficos interativos
* Visualizar logs e auditoria completa
* Gerenciar fila de processamento de tarefas
* Exportar relatórios em PDF e Excel

### 👔 Gerente
* Criar e gerenciar produtos
* Gerenciar usuários (criar, editar)
* Criar pedidos e gerenciar clientes
* Acessar dashboards e relatórios analíticos
* Visualizar relatórios e estatísticas
* Processar tarefas da fila de embalagem
* Acesso aos logs de auditoria

### 👷 Supervisor
* Criar e editar pedidos
* Gerenciar empacotamento
* Visualizar relatórios
* Visualizar fila de tarefas
* Consultar histórico de ações

### 🧑‍🔧 Operador
* Consultar produtos e pedidos
* Realizar empacotamento
* Escanear códigos de barras
* Visualizar próprias atividades
* Consultar fila de embalagem

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
```bash
create database banco_pi
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
![Chart.js](https://img.shields.io/badge/Chart.js-FF6384?style=for-the-badge&logo=chartdotjs&logoColor=white)
![bcrypt](https://img.shields.io/badge/bcrypt-338?style=for-the-badge)
![JWT](https://img.shields.io/badge/JWT-000000?style=for-the-badge&logo=jsonwebtokens&logoColor=white)

## 👨‍💻 Desenvolvido por

Este projeto foi desenvolvido como parte dos módulos de **Desenvolvimento de Software Corporativo**, **Segurança e Auditoria de Sistemas de Informação** e **Estrutura de Dados** do curso de Análise e Desenvolvimento de Sistemas da UNIFEOB.

### Equipe de Desenvolvimento

- Danilo Deademe Azevedo
- Luis Miguel Vitor
- Maria Luiza Tavares Procopio

---

Desenvolvido com foco em **segurança**, **rastreabilidade**, **controle de acesso**, **eficiência algorítmica** e **análise de dados** no ambiente corporativo.
