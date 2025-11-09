const express = require('express');
const router = express.Router();
const conexao = require('../db');

module.exports = (auth, rbac, audit) => {

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

  router.get('/logs', requireAuth, rbac.requirePermission('audit.view'), async (req, res) => {
    try {
      const filters = {
        usuarioId: req.query.userId,
        acao: req.query.action,
        tabelaAfetada: req.query.table,
        dataInicio: req.query.startDate,
        dataFim: req.query.endDate,
        limit: parseInt(req.query.limit) || 100,
        offset: parseInt(req.query.offset) || 0
      };

      const logs = await audit.getAuditLogs(filters);

      res.json({
        success: true,
        data: logs,
        filters: filters
      });

    } catch (error) {
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  });

  router.get('/suspicious', requireAuth, rbac.requireMinRole('gerente'), async (req, res) => {
    try {
      const suspicious = await audit.detectSuspiciousActivity();

      res.json({
        success: true,
        data: suspicious,
        total: suspicious.length
      });

    } catch (error) {
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  });

  router.get('/user/:userId', requireAuth, rbac.requirePermission('audit.view'), async (req, res) => {
    try {
      const userId = req.params.userId;
      const days = parseInt(req.query.days) || 30;

      const query = `
        SELECT 
          a.acao,
          a.tabela_afetada,
          COUNT(*) as total,
          MIN(a.data_hora) as primeira_acao,
          MAX(a.data_hora) as ultima_acao
        FROM auditoria_sistema a
        WHERE a.usuario_id = ?
          AND a.data_hora >= DATE_SUB(NOW(), INTERVAL ? DAY)
        GROUP BY a.acao, a.tabela_afetada
        ORDER BY total DESC
      `;

      const [rows] = await conexao.query(query, [userId, days]);

      res.json({
        success: true,
        data: rows,
        userId: userId,
        period: `${days} dias`
      });

    } catch (error) {
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  });

  router.get('/dashboard', requireAuth, rbac.requireMinRole('gerente'), async (req, res) => {
    try {
      const [failedLogins] = await conexao.query(`
        SELECT COUNT(*) as total
        FROM logs_sistema
        WHERE acao = 'LOGIN' 
        AND sucesso = 0 
        AND data_hora >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
      `);

      const [activeUsers] = await conexao.query(`
        SELECT COUNT(DISTINCT usuario_id) as total
        FROM auditoria_sistema
        WHERE data_hora >= DATE_SUB(NOW(), INTERVAL 30 MINUTE)
      `);

      const [recentActions] = await conexao.query(`
        SELECT 
          acao,
          COUNT(*) as total
        FROM auditoria_sistema
        WHERE data_hora >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
        GROUP BY acao
        ORDER BY total DESC
      `);

      const [topTables] = await conexao.query(`
        SELECT 
          tabela_afetada,
          COUNT(*) as total
        FROM auditoria_sistema
        WHERE tabela_afetada IS NOT NULL
          AND data_hora >= DATE_SUB(NOW(), INTERVAL 7 DAY)
        GROUP BY tabela_afetada
        ORDER BY total DESC
        LIMIT 5
      `);

      const suspicious = await audit.detectSuspiciousActivity();

      res.json({
        success: true,
        data: {
          failedLogins24h: failedLogins[0].total,
          activeUsers30min: activeUsers[0].total,
          activeSessions: auth.activeSessions.size,
          recentActions: recentActions,
          topModifiedTables: topTables,
          suspiciousActivities: suspicious.length,
          suspiciousDetails: suspicious
        }
      });

    } catch (error) {
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  });

  router.get('/stats', requireAuth, rbac.requirePermission('audit.view'), async (req, res) => {
    try {
      const days = parseInt(req.query.days) || 30;

      const [actionsByDay] = await conexao.query(`
        SELECT 
          DATE(data_hora) as data,
          COUNT(*) as total
        FROM auditoria_sistema
        WHERE data_hora >= DATE_SUB(NOW(), INTERVAL ? DAY)
        GROUP BY DATE(data_hora)
        ORDER BY data DESC
      `, [days]);

      const [actionsByUser] = await conexao.query(`
        SELECT 
          u.nome as usuario,
          u.tipo_acesso as role,
          COUNT(*) as total
        FROM auditoria_sistema a
        LEFT JOIN usuarios u ON a.usuario_id = u.id
        WHERE a.data_hora >= DATE_SUB(NOW(), INTERVAL ? DAY)
        GROUP BY a.usuario_id, u.nome, u.tipo_acesso
        ORDER BY total DESC
        LIMIT 10
      `, [days]);

      const [actionsByType] = await conexao.query(`
        SELECT 
          acao,
          COUNT(*) as total
        FROM auditoria_sistema
        WHERE data_hora >= DATE_SUB(NOW(), INTERVAL ? DAY)
        GROUP BY acao
        ORDER BY total DESC
      `, [days]);

      res.json({
        success: true,
        period: `${days} dias`,
        data: {
          actionsByDay,
          actionsByUser,
          actionsByType
        }
      });

    } catch (error) {
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  });

  router.get('/export', requireAuth, rbac.requirePermission('audit.export'), async (req, res) => {
    try {
      const filters = {
        dataInicio: req.query.startDate,
        dataFim: req.query.endDate
      };

      const logs = await audit.getAuditLogs({ ...filters, limit: 10000 });

      const report = {
        generated_at: new Date().toISOString(),
        generated_by: req.session.nome,
        filters: filters,
        total_records: logs.length,
        logs: logs
      };

      await audit.logAction({
        usuarioId: req.session.userId,
        acao: 'EXPORT',
        descricao: 'Exportação de relatório de auditoria',
        tabelaAfetada: 'auditoria_sistema',
        ipAddress: req.ip
      });

      res.json({
        success: true,
        data: report
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