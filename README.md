# SendRecord - Sistema de Gestão de Pedidos Mount Vernon

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
### 2. Abrir a pasta no VSCode
```bash
SendRecord
```
### 3. Instale as dependências
```bash
npm install express mysql2 ejs express-session dotenv multer bcryptjs cors
npm install electron --save-dev
npm install electron-builder --save-dev
npm install jspdf jspdf-autotable xlsx
```

### 4. Configure o `.env`
Crie um arquivo `.env` na raiz do projeto:
```env
# Banco de Dados
host=host
user=user
password=sua_senha
database=banco_pi
```

### 5. Crie o banco de dados

```bash
create database banco_pi
```
Faça o Dowload do
```bash
banco_pi.sql
```
### Via MySQL Workbench
```bash
Abra o MySQL Workbench
Vá em Server → Data Import
Selecione Import from Self-Contained File
Escolha o arquivo `banco_pi.sql`
Em Default Target Schema, selecione `banco_pi` (ou crie um novo clicando em New...)
Clique em Start Import
```
### 6. Inicie a aplicação no terminal do VSCode
```bash
npm start
```
### 7. Criação do Executável
```bash
npm run dist
```

O instalador será gerado na pasta `dist/`. Basta executar o arquivo `SendRecordSetupexe` para instalar o aplicativo.

A aplicação Electron será iniciada automaticamente e o servidor estará rodando.

## 🔐 Usuários de Acesso (Para Testes)

| Nível | Nome | Senha |
|-------|------|-------|
| 👨‍💼 Admin | Ana Costa | `admin123` |
| 👔 Gerente | Carlos Silva | `gerente123` |
| 👷 Supervisor | Fernando | `supervisor123` |
| 🧑‍🔧 Operador | Juliana Alves | `operador123` |


A aplicação Electron será iniciada automaticamente e o servidor estará rodando.

## 🛠️ Ferramentas
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![Express](https://img.shields.io/badge/Express-000000?style=for-the-badge&logo=express&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Electron](https://img.shields.io/badge/Electron-47848F?style=for-the-badge&logo=electron&logoColor=white)
![EJS](https://img.shields.io/badge/EJS-B4CA65?style=for-the-badge&logo=ejs&logoColor=black)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)
![bcrypt](https://img.shields.io/badge/bcrypt-338?style=for-the-badge)

## 👨‍💻 Desenvolvido por

Este projeto foi desenvolvido como parte dos módulos de **Desenvolvimento de Software Corporativo**, dos cursos de **Análise e Desenvolvimento de Sistemas** e **Ciência da computação** da UNIFEOB.

### Equipe de Desenvolvimento

- Danilo Deademe Azevedo
- Luis Miguel Vitor
- Maria Luiza Tavares Procopio

---
