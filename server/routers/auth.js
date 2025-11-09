const express = require('express');
const router = express.Router();
const db = require('../db');

// GET / - Mostra a página de login
router.get('/', (req, res) => {
    res.render('login', { erro: null });
});

// POST /login - Processa o login
router.post('/login', (req, res) => {
    const { nome, senha } = req.body;

    // Validação básica
    if (!nome || !senha) {
        return res.render('login', { 
            erro: 'Preencha todos os campos!' 
        });
    }

    db.query(
        'SELECT * FROM usuarios WHERE nome = ? AND senha = ?',
        [nome, senha],
        (err, results) => {
            if (err) {
                console.error('Erro no banco:', err);
                return res.render('login', { 
                    erro: 'Erro no servidor. Tente novamente.' 
                });
            }

            if (results.length > 0) {
                const usuario = results[0];

                // ALTERAÇÃO: Criar objeto de usuário com ID
                req.session.usuario = {
                    id: usuario.id,              // adicione para log no banco de dados
                    nome: usuario.nome,
                    tipo_acesso: usuario.tipo_acesso
                };
                
                // Manter compatibilidade com código antigo
                req.session.nome = usuario.nome;
                req.session.tipo_acesso = usuario.tipo_acesso;

                console.log('Usuário logado:', {
                    nome: usuario.nome,
                    tipo_acesso: usuario.tipo_acesso
                });

                res.redirect('/home');
            } else {
                res.render('login', { 
                    erro: 'Usuário ou Senha inválidos' 
                });
            }
        }
    );
});

// GET /logout - Faz logout
router.get('/logout', (req, res) => {
    req.session.destroy((err) => {
        if (err) {
            console.error('Erro ao fazer logout:', err);
        }
        res.redirect('/');
    });
});

module.exports = router;