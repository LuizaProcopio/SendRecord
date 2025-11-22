SendRecord - Sistema de Gestão de Pedidos Mount Vernon
📘 Sobre o Projeto
O SendRecord é uma aplicação desktop desenvolvida com Electron e Node.js para gerenciar pedidos e controlar o empacotamento de camisas da Mount Vernon. O sistema integra funcionalidades de vendas, estoque, clientes, um módulo robusto de Segurança e Auditoria que garante rastreabilidade total de todas as ações realizadas e implementação de Estruturas de Dados para otimização de processos críticos.
O projeto contempla controle hierárquico de acesso (RBAC) com 4 níveis de usuário, autenticação segura com bcrypt, registro automático de logs em banco de dados e fila de processamento implementada com lista encadeada para gerenciamento eficiente de tarefas de embalagem.
🎯 Objetivos

Automatizar o controle de pedidos e empacotamento
Garantir segurança através de autenticação robusta (bcrypt)
Implementar auditoria completa com rastreabilidade de ações
Controlar acesso hierárquico por níveis de permissão (RBAC)
Registrar automaticamente todas as operações no banco de dados
Proteger contra ataques comuns (SQL Injection, XSS)
Implementar estruturas de dados eficientes (Fila com Lista Encadeada)
Garantir operações em tempo constante O(1) para processos críticos
Gerar relatórios e visualizações gráficas para análise de dados

👥 Níveis de Acesso e Funcionalidades
👨‍💼 Admin

Acesso total ao sistema
Gerenciar usuários (criar, editar, deletar)
Configurar APIs e credenciais
Visualizar relatórios completos com gráficos interativos
Visualizar logs e auditoria completa
Gerenciar fila de processamento de tarefas
Exportar relatórios em PDF e Excel

👔 Gerente

Criar e gerenciar produtos
Gerenciar usuários (criar, editar)
Criar pedidos e gerenciar clientes
Acessar dashboards e relatórios analíticos
Visualizar relatórios e estatísticas
Processar tarefas da fila de embalagem
Acesso aos logs de auditoria

👷 Supervisor

Criar e editar pedidos
Gerenciar empacotamento
Visualizar relatórios
Visualizar fila de tarefas
Consultar histórico de ações

🧑‍🔧 Operador

Consultar produtos e pedidos
Realizar empacotamento
Escanear códigos de barras
Visualizar próprias atividades
Consultar fila de embalagem

🖥️ Como Executar o Projeto Localmente
1. Clone o repositório
bashgit clone https://github.com/LuizaProcopio/SendRecord.git
cd SendRecord
2. Abrir a pasta no VSCode
bashSendRecord
3. Instale as dependências
bashnpm install express mysql2 ejs express-session dotenv multer bcryptjs cors
npm install electron --save-dev
npm i electron-builder --save-dev
npm install jspdf jspdf-autotable xlsx
4. Configure o .env
Crie um arquivo .env na raiz do projeto:
env# Banco de Dados
host=localhost
user=root
password=sua_senha
database=banco_pi
5. Crie o banco de dados
bashcreate database banco_pi
Execute o arquivo SQL fornecido no MySQL:
bashmysql -u root -p < banco_pi.sql
Ou via MySQL Workbench:

File → Run SQL Script → Selecione banco_pi.sql

6. Inicie a aplicação no terminal do VSCode
bashnpm start
7. Criação do Executável
Para gerar o instalador do aplicativo:
bashnpm run dist
O instalador será gerado na pasta dist/. Basta executar o arquivo SendRecordSetup.exe para instalar o aplicativo.
🔐 Usuários de Acesso (Para Testes)
NívelNomeSenha👨‍💼 AdminAna Costaadmin123👔 GerenteCarlos Silvagerente123👷 SupervisorFernandosupervisor123🧑‍🔧 OperadorJuliana Alvesoperador123
🛠️ Ferramentas
Mostrar Imagem
Mostrar Imagem
Mostrar Imagem
Mostrar Imagem
Mostrar Imagem
Mostrar Imagem
Mostrar Imagem
👨‍💻 Desenvolvido por
Este projeto foi desenvolvido como parte dos módulos de Desenvolvimento de Software Corporativo, dos cursos de Análise e Desenvolvimento de Sistemas e Ciência da computação da UNIFEOB.
Equipe de Desenvolvimento

Danilo Deademe Azevedo
Luis Miguel Vitor
Maria Luiza Tavares Procopio
