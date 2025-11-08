const conexao = require('../db');

class AuditSystem {
  constructor() {
    this.criticalTables = ['usuarios', 'produtos', 'pedidos', 'api_credentials'];
    this.sensitiveFields = ['senha', 'encrypted_key', 'encrypted_secret'];
  }

  maskSensitiveData(data) {
    if (!data) return null;
    
    const masked = { ...data };
    this.sensitiveFields.forEach(field => {
      if (masked[field]) {
        masked[field] = '***MASKED***';
      }
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

    try {
      const dadosAnterioresMasked = this.maskSensitiveData(dadosAnteriores);
      const dadosNovosMasked = this.maskSensitiveData(dadosNovos);

      const query = `
        INSERT INTO auditoria_sistema 
        (usuario_id, acao, descricao, tabela_afetada, registro_id, 
         ip_address, dados_anteriores, dados_novos)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      `;

      await conexao.query(query, [
        usuarioId,
        acao,
        descricao,
        tabelaAfetada,
        registroId,
        ipAddress,
        dadosAnterioresMasked ? JSON.stringify(dadosAnterioresMasked) : null,
        dadosNovosMasked ? JSON.stringify(dadosNovosMasked) : null
      ]);

      return { success: true };
    } catch (error) {
      console.error('Erro ao registrar auditoria:', error);
      throw error;
    }
  }

  async getAuditLogs(filters = {}) {
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

    const [rows] = await conexao.query(query, params);
    
    return rows.map(row => ({
      ...row,
      dados_anteriores: row.dados_anteriores ? JSON.parse(row.dados_anteriores) : null,
      dados_novos: row.dados_novos ? JSON.parse(row.dados_novos) : null
    }));
  }

  async detectSuspiciousActivity() {
    const suspicious = [];

    const query1 = `
      SELECT usuario_app_nome, ip_address, COUNT(*) as tentativas,
             MAX(data_hora) as ultima_tentativa
      FROM logs_sistema
      WHERE acao = 'LOGIN' AND sucesso = 0
        AND data_hora >= DATE_SUB(NOW(), INTERVAL 1 HOUR)
      GROUP BY usuario_app_nome, ip_address
      HAVING tentativas >= 3
    `;
    const [failedLogins] = await conexao.query(query1);
    if (failedLogins.length > 0) {
      suspicious.push({
        type: 'failed_logins',
        severity: 'high',
        data: failedLogins
      });
    }

    const query2 = `
      SELECT a.usuario_id, u.nome as usuario_nome, a.tabela_afetada,
             COUNT(*) as total_updates, MIN(a.data_hora) as inicio, MAX(a.data_hora) as fim
      FROM auditoria_sistema a
      LEFT JOIN usuarios u ON a.usuario_id = u.id
      WHERE a.acao = 'UPDATE'
        AND a.data_hora >= DATE_SUB(NOW(), INTERVAL 10 MINUTE)
      GROUP BY a.usuario_id, a.tabela_afetada
      HAVING total_updates >= 20
    `;
    const [massUpdates] = await conexao.query(query2);
    if (massUpdates.length > 0) {
      suspicious.push({
        type: 'mass_updates',
        severity: 'medium',
        data: massUpdates
      });
    }

    return suspicious;
  }
}

module.exports = AuditSystem;