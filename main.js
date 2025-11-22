const { app, BrowserWindow } = require('electron');
const path = require('path');

// Carrega o .env antes de tudo
if (app.isPackaged) {
    // Em produção: busca o .env na pasta resources
    require('dotenv').config({
        path: path.join(process.resourcesPath, '.env')
    });
} else {
    // Em desenvolvimento: busca o .env na raiz do projeto
    require('dotenv').config();
}

function createWindow() {
    const win = new BrowserWindow({
        width: 1300,
        height: 1100
    });
    win.loadURL('http://localhost:4040');
}

app.whenReady().then(() => {
    require('./server/app');
    createWindow();
});