const express = require('express')
const router = express.Router()
const db = require('../db')
const util = require('util')
const bcrypt = require('bcrypt')

// Promisifica o método query do seu db.js
const query = util.promisify(db.query).bind(db)

// Número de rounds para o bcrypt (10 é um bom padrão)
const SALT_ROUNDS = 10

// Middleware para verificar se o usuário tem permissão de administrador ou gerente
function verificarPermissaoAdmin(req, res, next) {
    if (!req.session || !req.session.tipo_acesso) {
        return res.redirect('/login?erro=Sessão expirada')
    }

    if (req.session.tipo_acesso !== 'admin' && req.session.tipo_acesso !== 'gerente') {
        return res.status(403).render('config', {
            usuario: req.session.usuario,
            nome: req.session.nome,
            tipo_acesso: req.session.tipo_acesso,
            currentPage: 'config',
            usuarios: [],
            session_user_id: req.session.usuario,
            mensagem: '',
            erro: 'Você não tem permissão para realizar esta ação. Apenas Administradores e Gerentes podem gerenciar usuários.'
        })
    }

    next()
}

// Função auxiliar para obter ID do usuário logado - COM DEBUG
async function obterUsuarioLogadoId(session) {
    // DEBUG: Ver o que está chegando na sessão
    console.log('DEBUG obterUsuarioLogadoId - session completa:', JSON.stringify(session, null, 2))
    
    // Se já temos o ID na sessão, retornar direto
    if (session.usuario_id) {
        console.log('DEBUG: Usando session.usuario_id:', session.usuario_id)
        return session.usuario_id
    }

    // Tentar obter do email (mais confiável)
    if (session.email && typeof session.email === 'string') {
        console.log('DEBUG: Tentando buscar por email:', session.email)
        try {
            const result = await query('SELECT id FROM usuarios WHERE email = ? LIMIT 1', [session.email])
            console.log('DEBUG: Resultado busca por email:', result)
            return result.length > 0 ? result[0].id : null
        } catch (error) {
            console.error('Erro ao buscar usuário por email:', error)
        }
    }

    // Tentar obter pelo nome (se for string)
    if (session.nome && typeof session.nome === 'string') {
        console.log('DEBUG: Tentando buscar por nome:', session.nome)
        try {
            const result = await query('SELECT id FROM usuarios WHERE nome = ? LIMIT 1', [session.nome])
            console.log('DEBUG: Resultado busca por nome:', result)
            return result.length > 0 ? result[0].id : null
        } catch (error) {
            console.error('Erro ao buscar usuário por nome:', error)
        }
    }

    // Último recurso: tentar pelo campo usuario (se for string)
    if (session.usuario && typeof session.usuario === 'string') {
        console.log('DEBUG: Tentando buscar por usuario:', session.usuario)
        try {
            const result = await query('SELECT id FROM usuarios WHERE email = ? OR nome = ? LIMIT 1', 
                [session.usuario, session.usuario])
            console.log('DEBUG: Resultado busca por usuario:', result)
            return result.length > 0 ? result[0].id : null
        } catch (error) {
            console.error('Erro ao buscar usuário:', error)
        }
    }

    console.log('DEBUG: Nenhum ID encontrado, retornando null')
    return null
}

// Listar todos os usuários (todos podem ver)
router.get('/', async (req, res) => {
    try {
        const usuarios = await query(`
            SELECT 
                id, 
                nome, 
                email, 
                tipo_acesso, 
                ativo,
                data_criacao 
            FROM usuarios 
            ORDER BY nome ASC
        `)

        console.log('Usuários encontrados:', usuarios.length)

        res.render('config', {
            usuario: req.session.usuario,
            nome: req.session.nome,
            tipo_acesso: req.session.tipo_acesso,
            currentPage: 'config',
            usuarios,
            session_user_id: req.session.usuario,
            mensagem: req.query.mensagem || '',
            erro: req.query.erro || ''
        })
    } catch (error) {
        console.error('Erro ao buscar usuários:', error)
        res.render('config', {
            usuario: req.session.usuario,
            nome: req.session.nome,
            tipo_acesso: req.session.tipo_acesso,
            currentPage: 'config',
            usuarios: [],
            session_user_id: req.session.usuario,
            mensagem: '',
            erro: 'Erro ao carregar usuários: ' + error.message
        })
    }
})

// Página para criar novo usuário (SOMENTE ADMIN E GERENTE)
router.get('/novo', verificarPermissaoAdmin, (req, res) => {
    res.render('config-form', {
        usuario: req.session.usuario,
        nome: req.session.nome,
        tipo_acesso: req.session.tipo_acesso,
        currentPage: 'config',
        acao: 'criar',
        usuarioEdit: null,
        erro: req.query.erro || ''
    })
})

// Página para editar usuário (SOMENTE ADMIN E GERENTE)
router.get('/editar/:id', verificarPermissaoAdmin, async (req, res) => {
    try {
        const usuarios = await query('SELECT * FROM usuarios WHERE id = ?', [req.params.id])

        if (usuarios.length === 0) {
            return res.redirect('/config?erro=Usuário não encontrado')
        }

        res.render('config-form', {
            usuario: req.session.usuario,
            nome: req.session.nome,
            tipo_acesso: req.session.tipo_acesso,
            currentPage: 'config',
            acao: 'editar',
            usuarioEdit: usuarios[0],
            erro: req.query.erro || ''
        })
    } catch (error) {
        console.error('Erro ao buscar usuário:', error)
        res.redirect('/config?erro=Erro ao carregar usuário')
    }
})

// Criar novo usuário (SOMENTE ADMIN E GERENTE)
router.post('/criar', verificarPermissaoAdmin, async (req, res) => {
    const { nome, email, senha, tipo_acesso, ativo } = req.body

    try {
        if (!nome || !email || !senha || !tipo_acesso) {
            return res.redirect('/config/novo?erro=Todos os campos são obrigatórios')
        }

        const existente = await query('SELECT id FROM usuarios WHERE email = ?', [email])
        if (existente.length > 0) {
            return res.redirect('/config/novo?erro=Email já cadastrado')
        }

        const usuarioAtivo = ativo ? 1 : 0

        // CRIPTOGRAFAR A SENHA com bcrypt
        const senhaHash = await bcrypt.hash(senha, SALT_ROUNDS)
        console.log('DEBUG: Senha criptografada com sucesso')

        await query(
            'INSERT INTO usuarios (nome, email, senha, tipo_acesso, ativo) VALUES (?, ?, ?, ?, ?)',
            [nome, email, senhaHash, tipo_acesso, usuarioAtivo]
        )

        // Buscar ID do usuário logado usando função auxiliar
        const usuarioLogadoId = await obterUsuarioLogadoId(req.session)

        // Log da ação (se a tabela auditoria_sistema existir e tivermos o ID)
        if (usuarioLogadoId) {
            try {
                await query(
                    'INSERT INTO auditoria_sistema (usuario_id, acao, descricao) VALUES (?, ?, ?)',
                    [usuarioLogadoId, 'CRIAR_USUARIO', `Usuário ${nome} criado com tipo ${tipo_acesso}`]
                )
            } catch (auditError) {
                console.log('Aviso: Não foi possível registrar auditoria:', auditError.message)
            }
        }

        res.redirect('/config?mensagem=Usuário criado com sucesso')
    } catch (error) {
        console.error('Erro ao criar usuário:', error)
        res.redirect('/config/novo?erro=Erro ao criar usuário: ' + error.message)
    }
})

// Atualizar usuário (SOMENTE ADMIN E GERENTE)
router.post('/editar/:id', verificarPermissaoAdmin, async (req, res) => {
    const { nome, email, senha, tipo_acesso, ativo } = req.body
    const { id } = req.params

    console.log('DEBUG POST /editar/:id - Iniciando edição do usuário ID:', id)

    try {
        if (!nome || !email || !tipo_acesso) {
            return res.redirect(`/config/editar/${id}?erro=Preencha todos os campos obrigatórios`)
        }

        const existente = await query('SELECT id FROM usuarios WHERE email = ? AND id != ?', [email, id])
        if (existente.length > 0) {
            return res.redirect(`/config/editar/${id}?erro=Email já está sendo usado`)
        }

        const usuarioAtivo = ativo ? 1 : 0

        // Se a senha foi preenchida, criptografar e atualizar
        if (senha && senha.trim() !== '') {
            const senhaHash = await bcrypt.hash(senha, SALT_ROUNDS)
            console.log('DEBUG: Nova senha criptografada com sucesso')
            
            await query(
                'UPDATE usuarios SET nome = ?, email = ?, senha = ?, tipo_acesso = ?, ativo = ? WHERE id = ?',
                [nome, email, senhaHash, tipo_acesso, usuarioAtivo, id]
            )
        } else {
            // Se a senha não foi preenchida, não atualizar o campo senha
            await query(
                'UPDATE usuarios SET nome = ?, email = ?, tipo_acesso = ?, ativo = ? WHERE id = ?',
                [nome, email, tipo_acesso, usuarioAtivo, id]
            )
        }

        console.log('DEBUG: Usuário atualizado com sucesso, buscando ID do usuário logado...')

        // Buscar ID do usuário logado usando função auxiliar
        const usuarioLogadoId = await obterUsuarioLogadoId(req.session)

        console.log('DEBUG: usuarioLogadoId obtido:', usuarioLogadoId)

        // Log da ação (se a tabela auditoria_sistema existir e tivermos o ID)
        if (usuarioLogadoId) {
            try {
                await query(
                    'INSERT INTO auditoria_sistema (usuario_id, acao, descricao) VALUES (?, ?, ?)',
                    [usuarioLogadoId, 'EDITAR_USUARIO', `Usuário ${nome} (ID: ${id}) atualizado`]
                )
            } catch (auditError) {
                console.log('Aviso: Não foi possível registrar auditoria:', auditError.message)
            }
        }

        res.redirect('/config?mensagem=Usuário atualizado com sucesso')
    } catch (error) {
        console.error('Erro ao atualizar usuário:', error)
        res.redirect(`/config/editar/${id}?erro=Erro ao atualizar usuário: ` + error.message)
    }
})

// Rota para deletar usuário (SOMENTE ADMIN)
router.post('/deletar/:id', async (req, res) => {
    // Apenas ADMIN pode deletar
    if (req.session.tipo_acesso !== 'admin') {
        return res.redirect('/config?erro=Apenas administradores podem deletar usuários')
    }

    const { id } = req.params

    try {
        // Buscar ID do usuário logado usando função auxiliar
        const usuarioLogadoId = await obterUsuarioLogadoId(req.session)

        // Não permitir deletar o próprio usuário
        if (parseInt(id) === parseInt(usuarioLogadoId)) {
            return res.redirect('/config?erro=Você não pode deletar seu próprio usuário')
        }

        const usuario = await query('SELECT nome FROM usuarios WHERE id = ?', [id])
        
        if (usuario.length === 0) {
            return res.redirect('/config?erro=Usuário não encontrado')
        }

        await query('DELETE FROM usuarios WHERE id = ?', [id])

        // Log da ação (se tivermos o ID do usuário logado)
        if (usuarioLogadoId) {
            try {
                await query(
                    'INSERT INTO auditoria_sistema (usuario_id, acao, descricao) VALUES (?, ?, ?)',
                    [usuarioLogadoId, 'DELETAR_USUARIO', `Usuário ${usuario[0].nome} (ID: ${id}) deletado`]
                )
            } catch (auditError) {
                console.log('Aviso: Não foi possível registrar auditoria:', auditError.message)
            }
        }

        res.redirect('/config?mensagem=Usuário deletado com sucesso')
    } catch (error) {
        console.error('Erro ao deletar usuário:', error)
        res.redirect('/config?erro=Erro ao deletar usuário: ' + error.message)
    }
})

module.exports = router