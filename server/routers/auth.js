const express = require('express');
const router = express.Router();
const db = require('../db');
const bcrypt = require('bcryptjs');

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
        'SELECT * FROM usuarios WHERE nome = ?',
        [nome],
        async (err, results) => {
            if (err) {
                console.error('Erro no banco:', err);
                return res.render('login', { 
                    erro: 'Erro no servidor. Tente novamente.' 
                });
            }

            if (results.length > 0) {
                const usuario = results[0];

                // COMPARAR SENHA COM BCRYPT
                try {
                    const senhaValida = await bcrypt.compare(senha, usuario.senha);

                    if (senhaValida) {
                        // ALTERAÇÃO: Criar objeto de usuário com ID
                        req.session.usuario = {
                            id: usuario.id,              // adicione para log no banco de dados
                            nome: usuario.nome,
                            tipo_acesso: usuario.tipo_acesso
                        };
                        
                        // Manter compatibilidade com código antigo e RBAC
                        req.session.nome = usuario.nome;
                        req.session.tipo_acesso = usuario.tipo_acesso;
                        req.session.tipoAcesso = usuario.tipo_acesso;  // Para o RBAC
                        req.session.usuario_id = usuario.id;
                        req.session.email = usuario.email;

                        console.log('Usuário logado:', {
                            id: usuario.id,
                            nome: usuario.nome,
                            email: usuario.email,
                            tipo_acesso: usuario.tipo_acesso
                        });

                        res.redirect('/home');
                    } else {
                        res.render('login', { 
                            erro: 'Usuário ou Senha inválidos' 
                        });
                    }
                } catch (bcryptError) {
                    console.error('Erro ao comparar senha:', bcryptError);
                    return res.render('login', { 
                        erro: 'Erro no servidor. Tente novamente.' 
                    });
                }
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
