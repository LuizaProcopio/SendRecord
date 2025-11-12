// server/security/auth.js
const bcrypt = require('bcrypt');
const crypto = require('crypto');
const conexao = require('../db.js');
const Logger = require('../config/logger.js');

class AuthenticationSystem {
  constructor() {
    this.SALT_ROUNDS = 10;
    this.SESSION_TIMEOUT = 30 * 60 * 1000;
    this.activeSessions = new Map();
  }

  async hashPassword(plainPassword) {
    const salt = await bcrypt.genSalt(this.SALT_ROUNDS);
    return await bcrypt.hash(plainPassword, salt);
  }

  async verifyPassword(plainPassword, hashedPassword) {
    return await bcrypt.compare(plainPassword, hashedPassword);
  }

  generateSessionToken() {
    return crypto.randomBytes(32).toString('hex');
  }

  async registerLoginAttempt(email, success, ipAddress) {
    const query = `
      INSERT INTO logs_sistema 
      (usuario_mysql, usuario_app_nome, acao, ip_address, sucesso, data_hora)
      VALUES (?, ?, 'LOGIN', ?, ?, NOW())
    `;
    return new Promise((resolve, reject) => {
      conexao.query(query, ['system', email, ipAddress, success ? 1 : 0], (error, results) => {
        if (error) {
          Logger.erro('Erro ao registrar tentativa de login', error);
          return reject(error);
        }
        resolve(results);
      });
    });
  }

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
      const isValidPassword = await this.verifyPassword(password, user.senha);

      if (!isValidPassword) {
        await this.registerLoginAttempt(email, false, ipAddress);
        throw new Error('Credenciais inválidas');
      }

      await this.registerLoginAttempt(email, true, ipAddress);

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

      await new Promise((resolve, reject) => {
        conexao.query('UPDATE usuarios SET ultimo_acesso = NOW() WHERE id = ?', [user.id], (error, results) => {
          if (error) return reject(error);
          resolve(results);
        });
      });

      Logger.login(user.id, user.nome, ipAddress);

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

  validateSession(sessionToken) {
    const session = this.activeSessions.get(sessionToken);
    if (!session) return { valid: false, reason: 'Sessão não encontrada' };

    const now = Date.now();
    if (now - session.lastActivity > this.SESSION_TIMEOUT) {
      this.activeSessions.delete(sessionToken);
      return { valid: false, reason: 'Sessão expirada' };
    }

    session.lastActivity = now;
    this.activeSessions.set(sessionToken, session);
    return { valid: true, session };
  }

  async logout(sessionToken) {
    const session = this.activeSessions.get(sessionToken);
    if (session) {
      Logger.logout(session.userId, session.nome, session.ipAddress);
      this.activeSessions.delete(sessionToken);
    }
    return { success: true };
  }

  async changePassword(userId, oldPassword, newPassword) {
    try {
      const users = await new Promise((resolve, reject) => {
        conexao.query('SELECT senha FROM usuarios WHERE id = ?', [userId], (error, results) => {
          if (error) return reject(error);
          resolve(results);
        });
      });

      if (users.length === 0) throw new Error('Usuário não encontrado');

      const isValid = await this.verifyPassword(oldPassword, users[0].senha);
      if (!isValid) throw new Error('Senha atual incorreta');

      if (newPassword.length < 8) throw new Error('Nova senha deve ter no mínimo 8 caracteres');

      const newHash = await this.hashPassword(newPassword);

      await new Promise((resolve, reject) => {
        conexao.query('UPDATE usuarios SET senha = ? WHERE id = ?', [newHash, userId], (error, results) => {
          if (error) return reject(error);
          resolve(results);
        });
      });

      await this.logAuditoria(userId, 'UPDATE', 'Senha alterada pelo usuário', 'usuarios', userId, null);
      return { success: true, message: 'Senha alterada com sucesso' };
    } catch (error) {
      Logger.error('Erro ao alterar senha', error);
      throw error;
    }
  }

  async logAuditoria(usuarioId, acao, descricao, tabela, registroId, ipAddress) {
    const query = `
      INSERT INTO auditoria_sistema 
      (usuario_id, acao, descricao, tabela_afetada, registro_id, ip_address)
      VALUES (?, ?, ?, ?, ?, ?)
    `;
    return new Promise((resolve, reject) => {
      conexao.query(query, [usuarioId, acao, descricao, tabela, registroId, ipAddress], (error, results) => {
        if (error) {
          Logger.error('Erro ao registrar auditoria', error);
          return reject(error);
        }
        Logger.audit('Registro de auditoria salvo', { acao, descricao });
        resolve(results);
      });
    });
  }

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
