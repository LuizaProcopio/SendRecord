const express = require('express');
const router = express.Router();
const db = require('../db');
const util = require('util');

const query = util.promisify(db.query).bind(db);

function verificarAutenticacao(req, res, next) {
    if (!req.session.usuario) {
        return res.redirect('/login');
    }
    next();
}

function verificarAdmin(req, res, next) {
    if (req.session.tipo_acesso !== 'admin') {
        return res.status(403).send('Acesso negado. Apenas administradores podem acessar esta página.');
    }
    next();
}

// Rota principal de auditoria
router.get('/', verificarAutenticacao, verificarAdmin, async (req, res) => {
    try {
        const { busca, acao, tabela, dataInicio, dataFim } = req.query;

        let sqlQuery = `
            SELECT 
                a.id,
                a.usuario_id,
                COALESCE(a.usuario_nome, u.nome, 'Sistema') as usuario_nome,
                u.tipo_acesso,
                a.acao,
                a.descricao,
                a.tabela_afetada,
                a.registro_id,
                a.ip_address,
                a.dados_anteriores,
                a.dados_novos,
                a.data_hora,
                DATE_FORMAT(a.data_hora, '%d/%m/%Y %H:%i:%s') as data_formatada
            FROM auditoria_sistema a
            LEFT JOIN usuarios u ON a.usuario_id = u.id
            WHERE 1=1
        `;

        const params = [];

        if (busca && busca.trim() !== '') {
            sqlQuery += ` AND (
                a.usuario_nome LIKE ? OR 
                u.nome LIKE ? OR
                a.descricao LIKE ? OR
                a.tabela_afetada LIKE ?
            )`;
            const searchTerm = `%${busca.trim()}%`;
            params.push(searchTerm, searchTerm, searchTerm, searchTerm);
        }

        if (acao && acao !== '') {
            sqlQuery += ` AND a.acao = ?`;
            params.push(acao);
        }

        if (tabela && tabela !== '') {
            sqlQuery += ` AND a.tabela_afetada = ?`;
            params.push(tabela);
        }

        if (dataInicio && dataInicio !== '') {
            sqlQuery += ` AND DATE(a.data_hora) >= ?`;
            params.push(dataInicio);
        }

        if (dataFim && dataFim !== '') {
            sqlQuery += ` AND DATE(a.data_hora) <= ?`;
            params.push(dataFim);
        }

        sqlQuery += ` ORDER BY a.data_hora DESC LIMIT 200`;

        const auditorias = await query(sqlQuery, params);

        // Buscar ações distintas para o filtro
        const acoes = await query('SELECT DISTINCT acao FROM auditoria_sistema ORDER BY acao');
        
        // Buscar tabelas distintas para o filtro
        const tabelas = await query('SELECT DISTINCT tabela_afetada FROM auditoria_sistema WHERE tabela_afetada IS NOT NULL ORDER BY tabela_afetada');

        res.render('auditoria', {
            nome: req.session.nome || req.session.usuario || 'Usuario',
            tipo_acesso: req.session.tipo_acesso || 'operador',
            currentPage: 'auditoria',
            auditorias: auditorias,
            acoes: acoes,
            tabelas: tabelas,
            filtros: {
                busca: busca || '',
                acao: acao || '',
                tabela: tabela || '',
                dataInicio: dataInicio || '',
                dataFim: dataFim || ''
            }
        });

    } catch (error) {
        console.error('Erro ao carregar auditoria:', error);
        res.render('auditoria', {
            nome: req.session.nome || req.session.usuario || 'Usuario',
            tipo_acesso: req.session.tipo_acesso || 'operador',
            currentPage: 'auditoria',
            auditorias: [],
            acoes: [],
            tabelas: [],
            erro: 'Erro ao carregar auditoria: ' + error.message,
            filtros: {
                busca: '',
                acao: '',
                tabela: '',
                dataInicio: '',
                dataFim: ''
            }
        });
    }
});

module.exports = router;
