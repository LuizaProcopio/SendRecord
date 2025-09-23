# Projeto de Extensão - APP Gerenciamento de Vendas

## 📌 Descrição
Aplicação desktop feita com **Electron** e **Node.js**, conectada a banco de dados MySQL.  
Entrega inicial com login, dashboard e navegação básica.

## 📂 Estrutura de Pastas
- **renderer/views** → telas (login, homeGerente, dashboard, etc.)  
- **renderer/public/css** → arquivos de estilo (login, dashboard, etc.)  
- **renderer/public/img** → imagens (logo da empresa, ícones, etc.)  
- **server/routers** → rotas (auth, homeGerente, dashboard)  
- **db.js** → conexão com banco de dados  
- **main.js** → inicialização do Electron  
- **preload.js** → comunicação segura entre Electron e front-end  

## ⚙️ Instalação das dependências
```bash
# Inicializar o projeto e criar package.json
npm init -y

# Dependências do backend e front-end
npm i ejs --save
npm i express --save
npm i mysql2 --save
npm i express-session --save

# Dependências de desenvolvimento (Electron)
npm i electron --save-dev
npm i electron-builder --save

# Gerenciamento de variáveis de ambiente
npm install dotenv