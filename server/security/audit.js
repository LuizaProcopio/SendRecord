const conexao = require('../db.js');
const Logger = require('../config/logger');

class AuditSystem {
  constructor() {
    this.criticalTables = ['usuarios', 'produtos', 'pedidos', 'api_credentials'];
    this.sensitiveFields = ['senha', 'encrypted_key', 'encrypted_secret'];
  }

  maskSensitiveData(data) {
    if (!data) return null;
    const masked = { ...data };
    this.sensitiveFields.forEach(field => {
      if (masked[field]) masked[field] = '***MASKED***';
    });
    return masked;
  }

  async logAction(params) {
    const {
      usuarioId,
      acao,
      descricao,
      tabelaAfetada = null,
      registroId = null,
      ipAddress = null,
      dadosAnteriores = null,
      dadosNovos = null
    } = params;

    return new Promise((resolve, reject) => {
      try {
        const dadosAnterioresMasked = this.maskSensitiveData(dadosAnteriores);
        const dadosNovosMasked = this.maskSensitiveData(dadosNovos);
        const query = `
          INSERT INTO auditoria_sistema 
          (usuario_id, acao, descricao, tabela_afetada, registro_id, 
           ip_address, dados_anteriores, dados_novos, data_hora)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())
        `;
        conexao.query(
          query,
          [
            usuarioId,
            acao,
            descricao || 'Ação do sistema',
            tabelaAfetada,
            registroId,
            ipAddress || '127.0.0.1',
            dadosAnterioresMasked ? JSON.stringify(dadosAnterioresMasked) : null,
            dadosNovosMasked ? JSON.stringify(dadosNovosMasked) : null
          ],
          (error, results) => {
            if (error) {
              Logger.error('Erro ao registrar auditoria', error);
              return reject(error);
            }
            Logger.audit('Auditoria registrada', {
              acao,
              descricao,
              tabela: tabelaAfetada,
              registroId,
              usuario: usuarioId
            });
            resolve({ success: true, insertId: results.insertId });
          }
        );
      } catch (error) {
        Logger.error('Erro ao processar auditoria', error);
        reject(error);
      }
    });
  }

  async getAuditLogs(filters = {}) {
    return new Promise((resolve, reject) => {
      const {
        usuarioId,
        acao,
        tabelaAfetada,
        dataInicio,
        dataFim,
        limit = 100,
        offset = 0
      } = filters;

      let query = `
        SELECT 
          a.id, a.usuario_id,
          u.nome as usuario_nome,
          u.tipo_acesso as usuario_role,
          a.acao, a.descricao,
          a.tabela_afetada, a.registro_id,
          a.ip_address, a.dados_anteriores, a.dados_novos,
          a.data_hora
        FROM auditoria_sistema a
        LEFT JOIN usuarios u ON a.usuario_id = u.id
        WHERE 1=1
      `;

      const params = [];
      if (usuarioId) {
        query += ' AND a.usuario_id = ?';
        params.push(usuarioId);
      }
      if (acao) {
        query += ' AND a.acao = ?';
        params.push(acao);
      }
      if (tabelaAfetada) {
        query += ' AND a.tabela_afetada = ?';
        params.push(tabelaAfetada);
      }
      if (dataInicio) {
        query += ' AND a.data_hora >= ?';
        params.push(dataInicio);
      }
      if (dataFim) {
        query += ' AND a.data_hora <= ?';
        params.push(dataFim);
      }

      query += ' ORDER BY a.data_hora DESC LIMIT ? OFFSET ?';
      params.push(limit, offset);

      conexao.query(query, params, (error, rows) => {
        if (error) {
          Logger.error('Erro ao buscar logs', error);
          return reject(error);
        }
        const processedRows = rows.map(row => ({
          ...row,
          dados_anteriores: row.dados_anteriores ? JSON.parse(row.dados_anteriores) : null,
          dados_novos: row.dados_novos ? JSON.parse(row.dados_novos) : null
        }));
        Logger.audit(`${processedRows.length} logs encontrados`);
        resolve(processedRows);
      });
    });
  }

  async detectSuspiciousActivity() {
    const suspicious = [];
    try {
      const failedLogins = await new Promise((resolve, reject) => {
        const query = `
          SELECT usuario_app_nome, ip_address, COUNT(*) as tentativas,
                 MAX(data_hora) as ultima_tentativa
          FROM logs_sistema
          WHERE acao = 'LOGIN' AND sucesso = 0
            AND data_hora >= DATE_SUB(NOW(), INTERVAL 1 HOUR)
          GROUP BY usuario_app_nome, ip_address
          HAVING tentativas >= 3
        `;
        conexao.query(query, (error, rows) => {
          if (error) return reject(error);
          resolve(rows);
        });
      });

      if (failedLogins.length > 0) {
        suspicious.push({
          type: 'failed_logins',
          severity: 'high',
          data: failedLogins
        });
      }

      const massUpdates = await new Promise((resolve, reject) => {
        const query = `
          SELECT a.usuario_id, u.nome as usuario_nome, a.tabela_afetada,
                 COUNT(*) as total_updates, MIN(a.data_hora) as inicio, MAX(a.data_hora) as fim
          FROM auditoria_sistema a
          LEFT JOIN usuarios u ON a.usuario_id = u.id
          WHERE a.acao = 'UPDATE'
            AND a.data_hora >= DATE_SUB(NOW(), INTERVAL 10 MINUTE)
          GROUP BY a.usuario_id, a.tabela_afetada
          HAVING total_updates >= 20
        `;
        conexao.query(query, (error, rows) => {
          if (error) return reject(error);
          resolve(rows);
        });
      });

      if (massUpdates.length > 0) {
        suspicious.push({
          type: 'mass_updates',
          severity: 'medium',
          data: massUpdates
        });
      }

      return suspicious;
    } catch (error) {
      Logger.error('Erro ao detectar atividades suspeitas', error);
      return suspicious;
    }
  }
}

module.exports = AuditSystem;
