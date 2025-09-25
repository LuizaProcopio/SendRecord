const express = require('express');
const router = express.Router();
const db = require('../db');

router.get('/', (req, res) => {
    res.render('login');
});

router.post('/login', (req, res) => {
    const { nome, senha } = req.body;

    db.query(
        'SELECT * FROM usuarios WHERE nome = ? AND senha = ?',
        [nome, senha],
        (err, results) => {
            if (err) throw err;

            if (results.length > 0) {
                const usuario = results[0]; // <-- pega o primeiro usuário encontrado

                req.session.nome = usuario.nome;
                req.session.tipoUsuario = usuario.tipo_acesso;

                console.log('Usuário logado:', {
                    nome: usuario.nome,
                    tipo_acesso: usuario.tipo_acesso
                });

                res.redirect('/home');
            } else {
                res.render('login', { erro: 'Usuário ou Senha inválidos' });
            }
        }
    );
});

module.exports = router;
