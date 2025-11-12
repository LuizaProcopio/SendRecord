// server/security/auth.js
const bcrypt = require('bcrypt');
const crypto = require('crypto');
const conexao = require('../db.js'); // Importa sua conexão existente
const Logger = require('../config/logger.js');

class AuthenticationSystem {
  constructor() {
    this.SALT_ROUNDS = 10;
    this.SESSION_TIMEOUT = 30 * 60 * 1000; // 30 minutos
    this.activeSessions = new Map();
  }

  // Hash de senha seguro
  async hashPassword(plainPassword) {
    try {
      const salt = await bcrypt.genSalt(this.SALT_ROUNDS);
      const hash = await bcrypt.hash(plainPassword, salt);
      return hash;
    } catch (error) {
      throw new Error('Erro ao criar hash da senha: ' + error.message);
    }
  }

  // Verificar senha
  async verifyPassword(plainPassword, hashedPassword) {
    try {
      return await bcrypt.compare(plainPassword, hashedPassword);
    } catch (error) {
      throw new Error('Erro ao verificar senha: ' + error.message);
    }
  }

  // Gerar token de sessão seguro
  generateSessionToken() {
    return crypto.randomBytes(32).toString('hex');
  }

  // Registrar tentativa de login
  async registerLoginAttempt(email, success, ipAddress) {
    const query = `
      INSERT INTO logs_sistema 
      (usuario_mysql, usuario_app_nome, acao, ip_address, sucesso, data_hora)
      VALUES (?, ?, 'LOGIN', ?, ?, NOW())
    `;
    
    return new Promise((resolve, reject) => {
      conexao.query(query, [
        'system',
        email,
        ipAddress,
        success ? 1 : 0
      ], (error, results) => {
        if (error) {
          Logger.erro('Erro ao registrar tentativa de login', error);
          return reject(error);
        }
        resolve(results);
      });
    });
  }

  // Verificar bloqueio de conta
async isAccountLocked(email) {
  const query = `
    SELECT COUNT(*) as failed_attempts
    FROM logs_sistema
    WHERE usuario_app_nome = ?
    AND acao = 'LOGIN'
    AND sucesso = 0
    AND data_hora > DATE_SUB(NOW(), INTERVAL 15 MINUTE)
  `;
  
  return new Promise((resolve, reject) => {
    conexao.query(query, [email], (error, rows) => {
      if (error) {
        Logger.erro('Erro ao verificar bloqueio', error);
        return resolve(false);
      }
      resolve(rows[0].failed_attempts >= this.MAX_LOGIN_ATTEMPTS);
    });
  });
}

  // Login do usuário
async login(email, password, ipAddress) {
  try {
      const query = `
        SELECT id, nome, email, senha, tipo_acesso, ativo
        FROM usuarios
        WHERE email = ? AND ativo = 1
      `;
      
      const users = await new Promise((resolve, reject) => {
        conexao.query(query, [email], (error, results) => {
          if (error) return reject(error);
          resolve(results);
        });
      });
      
      if (users.length === 0) {
        await this.registerLoginAttempt(email, false, ipAddress);
        throw new Error('Credenciais inválidas');
      }

      const user = users[0];

      // Verificar senha
      const isValidPassword = await this.verifyPassword(password, user.senha);
      
      if (!isValidPassword) {
        await this.registerLoginAttempt(email, false, ipAddress);
        throw new Error('Credenciais inválidas');
      }

      // Login bem-sucedido - SALVAR LOGS
      await this.registerLoginAttempt(email, true, ipAddress);

      // Criar sessão
      const sessionToken = this.generateSessionToken();
      const sessionData = {
        userId: user.id,
        nome: user.nome,
        email: user.email,
        tipoAcesso: user.tipo_acesso,
        loginTime: Date.now(),
        lastActivity: Date.now(),
        ipAddress: ipAddress
      };

      this.activeSessions.set(sessionToken, sessionData);

      // Atualizar último acesso
      await new Promise((resolve, reject) => {
        conexao.query(
          'UPDATE usuarios SET ultimo_acesso = NOW() WHERE id = ?',
          [user.id],
          (error, results) => {
            if (error) return reject(error);
            resolve(results);
          }
        );
      });

      // SALVAR LOG E AUDITORIA (MÉTODO SIMPLES)
      Logger.login(user.id, user.nome, ipAddress);

      console.log('⚠️  Login bem-sucedido:', user.nome);

      return {
        success: true,
        sessionToken,
        user: {
          id: user.id,
          nome: user.nome,
          email: user.email,
          tipoAcesso: user.tipo_acesso
        }
      };

    } catch (error) {
      Logger.error('Erro no login', error);
      throw error;
    }
  }

  // Validar sessão
  validateSession(sessionToken) {
    const session = this.activeSessions.get(sessionToken);
    
    if (!session) {
      return { valid: false, reason: 'Sessão não encontrada' };
    }

    const now = Date.now();
    const sessionAge = now - session.lastActivity;

    if (sessionAge > this.SESSION_TIMEOUT) {
      this.activeSessions.delete(sessionToken);
      return { valid: false, reason: 'Sessão expirada' };
    }

    // Atualizar última atividade
    session.lastActivity = now;
    this.activeSessions.set(sessionToken, session);

    return { valid: true, session };
  }

  // Logout
  async logout(sessionToken) {
    const session = this.activeSessions.get(sessionToken);
    
    if (session) {
      // SALVAR LOG E AUDITORIA
      Logger.logout(session.userId, session.nome, session.ipAddress);
      
      console.log('⚠️  Logout:', session.nome);
      this.activeSessions.delete(sessionToken);
    }

    return { success: true };
  }

  // Alterar senha
  async changePassword(userId, oldPassword, newPassword) {
    try {
      // Buscar senha atual
      const users = await new Promise((resolve, reject) => {
        conexao.query(
          'SELECT senha FROM usuarios WHERE id = ?',
          [userId],
          (error, results) => {
            if (error) return reject(error);
            resolve(results);
          }
        );
      });

      if (users.length === 0) {
        throw new Error('Usuário não encontrado');
      }

      // Verificar senha antiga
      const isValid = await this.verifyPassword(oldPassword, users[0].senha);
      if (!isValid) {
        throw new Error('Senha atual incorreta');
      }

      // Validar nova senha
      if (newPassword.length < 8) {
        throw new Error('Nova senha deve ter no mínimo 8 caracteres');
      }

      // Hash da nova senha
      const newHash = await this.hashPassword(newPassword);

      // Atualizar no banco
      await new Promise((resolve, reject) => {
        conexao.query(
          'UPDATE usuarios SET senha = ? WHERE id = ?',
          [newHash, userId],
          (error, results) => {
            if (error) return reject(error);
            resolve(results);
          }
        );
      });

      // Registrar na auditoria
      await this.logAuditoria(
        userId,
        'UPDATE',
        'Senha alterada pelo usuário',
        'usuarios',
        userId,
        null
      );

      return { success: true, message: 'Senha alterada com sucesso' };

    } catch (error) {
      Logger.error('Erro ao alterar senha', error);
      throw error;
    }
  }

  // Registrar na auditoria
  async logAuditoria(usuarioId, acao, descricao, tabela, registroId, ipAddress) {
    const query = `
      INSERT INTO auditoria_sistema 
      (usuario_id, acao, descricao, tabela_afetada, registro_id, ip_address)
      VALUES (?, ?, ?, ?, ?, ?)
    `;
    
    return new Promise((resolve, reject) => {
      conexao.query(query, [
        usuarioId,
        acao,
        descricao,
        tabela,
        registroId,
        ipAddress
      ], (error, results) => {
        if (error) {
          Logger.error('Erro ao registrar auditoria', error);
          return reject(error);
        }
        Logger.audit('Registro de auditoria salvo', { acao, descricao });
        resolve(results);
      });
    });
  }

  // Limpar sessões expiradas
  cleanupExpiredSessions() {
    const now = Date.now();
    for (const [token, session] of this.activeSessions.entries()) {
      if (now - session.lastActivity > this.SESSION_TIMEOUT) {
        this.activeSessions.delete(token);
      }
    }
  }
}

module.exports = AuthenticationSystem;