
const express = require('express');
const router = express.Router();
const conexao = require('../db');

module.exports = (auth, rbac, audit, validator) => {

  const requireAuth = (req, res, next) => {
    const token = req.headers['authorization']?.replace('Bearer ', '');
    
    if (!token) {
      return res.status(401).json({
        success: false,
        message: 'Token não fornecido'
      });
    }

    const validation = auth.validateSession(token);
    
    if (!validation.valid) {
      return res.status(401).json({
        success: false,
        message: validation.reason
      });
    }

    req.session = validation.session;
    next();
  };

  router.get('/', requireAuth, rbac.requirePermission('users.read'), async (req, res) => {
    try {
      const [users] = await conexao.query(
        'SELECT id, nome, email, tipo_acesso, ativo, data_criacao, ultimo_acesso FROM usuarios ORDER BY nome'
      );

      await audit.logAction({
        usuarioId: req.session.userId,
        acao: 'SELECT',
        descricao: 'Listagem de usuários',
        tabelaAfetada: 'usuarios',
        ipAddress: req.ip
      });

      res.json({
        success: true,
        data: users
      });

    } catch (error) {
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  });

  router.get('/:id', requireAuth, rbac.requirePermission('users.read'), async (req, res) => {
    try {
      const [users] = await conexao.query(
        'SELECT id, nome, email, tipo_acesso, ativo, data_criacao, ultimo_acesso FROM usuarios WHERE id = ?',
        [req.params.id]
      );

      if (users.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'Usuário não encontrado'
        });
      }

      res.json({
        success: true,
        data: users[0]
      });

    } catch (error) {
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  });

  router.post('/', requireAuth, rbac.requirePermission('users.create'), async (req, res) => {
    try {
      const { nome, email, senha, tipo_acesso } = req.body;

      const emailValidation = validator.validateEmail(email);
      if (!emailValidation.valid) {
        return res.status(400).json({
          success: false,
          message: emailValidation.error
        });
      }

      const senhaValidation = validator.validatePassword(senha, { minLength: 8 });
      if (!senhaValidation.valid) {
        return res.status(400).json({
          success: false,
          message: senhaValidation.error
        });
      }

      const tiposPermitidos = ['admin', 'gerente', 'supervisor', 'operador'];
      if (!tiposPermitidos.includes(tipo_acesso)) {
        return res.status(400).json({
          success: false,
          message: 'Tipo de acesso inválido'
        });
      }

      const [existing] = await conexao.query(
        'SELECT id FROM usuarios WHERE email = ?',
        [emailValidation.value]
      );

      if (existing.length > 0) {
        return res.status(400).json({
          success: false,
          message: 'Email já cadastrado'
        });
      }

      const hashedPassword = await auth.hashPassword(senha);

      const [result] = await conexao.query(
        'INSERT INTO usuarios (nome, email, senha, tipo_acesso) VALUES (?, ?, ?, ?)',
        [nome, emailValidation.value, hashedPassword, tipo_acesso]
      );

      await audit.logAction({
        usuarioId: req.session.userId,
        acao: 'INSERT',
        descricao: `Novo usuário criado: ${nome}`,
        tabelaAfetada: 'usuarios',
        registroId: result.insertId,
        ipAddress: req.ip,
        dadosNovos: { nome, email: emailValidation.value, tipo_acesso }
      });

      res.status(201).json({
        success: true,
        message: 'Usuário criado com sucesso',
        id: result.insertId
      });

    } catch (error) {
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  });

  router.put('/:id', requireAuth, rbac.requirePermission('users.update'), async (req, res) => {
    try {
      const userId = req.params.id;
      const { nome, email, tipo_acesso, ativo } = req.body;

      const [oldData] = await conexao.query(
        'SELECT nome, email, tipo_acesso, ativo FROM usuarios WHERE id = ?',
        [userId]
      );

      if (oldData.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'Usuário não encontrado'
        });
      }

      if (email) {
        const emailValidation = validator.validateEmail(email);
        if (!emailValidation.valid) {
          return res.status(400).json({
            success: false,
            message: emailValidation.error
          });
        }
      }

      const updates = [];
      const values = [];

      if (nome) {
        updates.push('nome = ?');
        values.push(nome);
      }
      if (email) {
        updates.push('email = ?');
        values.push(email);
      }
      if (tipo_acesso) {
        updates.push('tipo_acesso = ?');
        values.push(tipo_acesso);
      }
      if (ativo !== undefined) {
        updates.push('ativo = ?');
        values.push(ativo ? 1 : 0);
      }

      if (updates.length === 0) {
        return res.status(400).json({
          success: false,
          message: 'Nenhum campo para atualizar'
        });
      }

      values.push(userId);

      await conexao.query(
        `UPDATE usuarios SET ${updates.join(', ')} WHERE id = ?`,
        values
      );

      await audit.logAction({
        usuarioId: req.session.userId,
        acao: 'UPDATE',
        descricao: `Usuário atualizado: ${oldData[0].nome}`,
        tabelaAfetada: 'usuarios',
        registroId: userId,
        ipAddress: req.ip,
        dadosAnteriores: oldData[0],
        dadosNovos: { nome, email, tipo_acesso, ativo }
      });

      res.json({
        success: true,
        message: 'Usuário atualizado com sucesso'
      });

    } catch (error) {
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  });

  router.delete('/:id', requireAuth, rbac.requirePermission('users.delete'), async (req, res) => {
    try {
      const userId = req.params.id;

      const [userData] = await conexao.query(
        'SELECT nome, email, tipo_acesso FROM usuarios WHERE id = ?',
        [userId]
      );

      if (userData.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'Usuário não encontrado'
        });
      }

      if (parseInt(userId) === req.session.userId) {
        return res.status(400).json({
          success: false,
          message: 'Você não pode deletar sua própria conta'
        });
      }

      await conexao.query(
        'UPDATE usuarios SET ativo = 0 WHERE id = ?',
        [userId]
      );

      await audit.logAction({
        usuarioId: req.session.userId,
        acao: 'DELETE',
        descricao: `Usuário desativado: ${userData[0].nome}`,
        tabelaAfetada: 'usuarios',
        registroId: userId,
        ipAddress: req.ip,
        dadosAnteriores: userData[0]
      });

      res.json({
        success: true,
        message: 'Usuário desativado com sucesso'
      });

    } catch (error) {
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  });

  return router;
};