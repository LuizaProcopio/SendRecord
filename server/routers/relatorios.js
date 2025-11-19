const express = require('express');
const router = express.Router();
const db = require('../db');

// Middleware de autenticação
function verificarAutenticacao(req, res, next) {
    console.log('Verificando autenticação...');
    console.log('Sessão:', req.session);
    
    if (req.session && req.session.usuario) {
        console.log('Usuário autenticado!');
        next();
    } else {
        console.log('Usuário NÃO autenticado! Redirecionando...');
        res.redirect('/login');
    }
}

// Rota para renderizar a página de relatórios
router.get('/', verificarAutenticacao, (req, res) => {
    console.log('ENTROU NA ROTA /relatorios');
    console.log('Usuário:', req.session.usuario);
    console.log('Nome:', req.session.usuario?.nome);
    console.log('Tipo Acesso:', req.session.usuario?.tipo_acesso);
    
    try {
        const dados = {
            nome: req.session.usuario.nome || req.session.nome,
            tipo_acesso: req.session.usuario.tipo_acesso || req.session.tipo_acesso,
            currentPage: 'relatorios',
            title: 'Relatórios e Gráficos'
        };
        
        console.log('Dados para renderizar:', dados);
        
        res.render('relatorios', dados);
        
        console.log('Página renderizada com sucesso!');
    } catch (error) {
        console.error('ERRO AO RENDERIZAR:', error);
        console.error('Stack:', error.stack);
        res.status(500).send('Erro ao carregar página de relatórios: ' + error.message);
    }
});

// Rota para buscar dados dos PEDIDOS
// Rota para buscar dados dos PEDIDOS
router.get('/dados', verificarAutenticacao, (req, res) => {
    try {
        const query = `
            SELECT 
                p.id,
                p.order_id as descricao,
                p.status,
                p.created_at,
                p.packed_at as data_processamento,
                p.source as tipo,
                JSON_OBJECT(
                    'cliente', p.customer_name,
                    'valor_total', p.valor_total,
                    'item_count', p.item_count
                ) as dados,
                DATEDIFF(NOW(), p.created_at) as dias_pendente
            FROM pedidos p
            ORDER BY p.created_at DESC
            LIMIT 1000
        `;
        
        db.query(query, (error, rows) => {
            if (error) {
                console.error('Erro ao buscar dados:', error);
                return res.status(500).json({
                    success: false,
                    message: 'Erro ao buscar dados do relatório',
                    error: error.message
                });
            }
            
            // Mapear status e calcular prioridade por tempo
            const dadosFormatados = rows.map(row => {
                // Calcular prioridade baseada nos dias pendentes
                let prioridade = 'baixa';
                if (row.dias_pendente >= 3) {
                    prioridade = 'alta';
                } else if (row.dias_pendente >= 1) {
                    prioridade = 'media';
                }
                
                return {
                    ...row,
                    status: row.status === 'Pendente' ? 'pendente' : 
                            row.status === 'Empacotado' ? 'processada' : 
                            row.status === 'Em_Separacao' ? 'pendente' : 'pendente',
                    prioridade: prioridade
                };
            });
            
            res.json({
                success: true,
                data: dadosFormatados
            });
        });
    } catch (error) {
        console.error('Erro ao buscar dados:', error);
        res.status(500).json({
            success: false,
            message: 'Erro ao buscar dados do relatório',
            error: error.message
        });
    }
});

// Rota para reprocessar um pedido com erro
router.post('/reprocessar/:id', verificarAutenticacao, (req, res) => {
    try {
        const { id } = req.params;
        
        const checkQuery = `
            SELECT status 
            FROM pedidos 
            WHERE id = ?
        `;
        
        db.query(checkQuery, [id], (error, checkRows) => {
            if (error) {
                console.error('Erro ao verificar pedido:', error);
                return res.status(500).json({
                    success: false,
                    message: 'Erro ao verificar pedido',
                    error: error.message
                });
            }
            
            if (checkRows.length === 0) {
                return res.status(404).json({
                    success: false,
                    message: 'Pedido não encontrado'
                });
            }
            
            if (checkRows[0].status !== 'Erro') {
                return res.status(400).json({
                    success: false,
                    message: 'Apenas pedidos com erro podem ser reprocessados'
                });
            }
            
            const updateQuery = `
                UPDATE pedidos 
                SET status = 'Pendente',
                    packed_at = NULL
                WHERE id = ?
            `;
            
            db.query(updateQuery, [id], (updateError) => {
                if (updateError) {
                    console.error('Erro ao reprocessar:', updateError);
                    return res.status(500).json({
                        success: false,
                        message: 'Erro ao reprocessar pedido',
                        error: updateError.message
                    });
                }
                
                res.json({
                    success: true,
                    message: 'Pedido marcado para reprocessamento'
                });
            });
        });
    } catch (error) {
        console.error('Erro ao reprocessar:', error);
        res.status(500).json({
            success: false,
            message: 'Erro ao reprocessar pedido',
            error: error.message
        });
    }
});

// Rota para dados estatísticos por período
router.get('/estatisticas', verificarAutenticacao, (req, res) => {
    try {
        const { inicio, fim } = req.query;
        
        let whereClause = 'WHERE 1=1';
        const params = [];
        
        if (inicio && fim) {
            whereClause += ' AND created_at BETWEEN ? AND ?';
            params.push(inicio, fim);
        }
        
        const query = `
            SELECT 
                DATE(created_at) as data,
                status,
                COUNT(*) as total,
                AVG(TIMESTAMPDIFF(SECOND, created_at, packed_at)) as tempo_medio
            FROM pedidos
            ${whereClause}
            GROUP BY DATE(created_at), status
            ORDER BY data DESC
        `;
        
        db.query(query, params, (error, rows) => {
            if (error) {
                console.error('Erro ao buscar estatísticas:', error);
                return res.status(500).json({
                    success: false,
                    message: 'Erro ao buscar estatísticas',
                    error: error.message
                });
            }
            
            res.json({
                success: true,
                data: rows
            });
        });
    } catch (error) {
        console.error('Erro ao buscar estatísticas:', error);
        res.status(500).json({
            success: false,
            message: 'Erro ao buscar estatísticas',
            error: error.message
        });
    }
});

// Rota para exportar PDF
router.post('/exportar/pdf', verificarAutenticacao, (req, res) => {
    res.status(501).json({
        success: false,
        message: 'Exportação PDF em desenvolvimento. Instale a biblioteca pdfkit para implementar.'
    });
});

// Rota para exportar Excel
router.post('/exportar/excel', verificarAutenticacao, (req, res) => {
    res.status(501).json({
        success: false,
        message: 'Exportação Excel em desenvolvimento. Instale a biblioteca xlsx para implementar.'
    });
});

// Rota para análise de performance
router.get('/performance', verificarAutenticacao, (req, res) => {
    try {
        const query = `
            SELECT 
                DATE(created_at) as data,
                COUNT(*) as total_tarefas,
                COUNT(CASE WHEN status = 'Empacotado' THEN 1 END) as processadas,
                COUNT(CASE WHEN status = 'Erro' THEN 1 END) as erros,
                AVG(CASE 
                    WHEN status = 'Empacotado' 
                    THEN TIMESTAMPDIFF(SECOND, created_at, packed_at) 
                END) as tempo_medio_processamento
            FROM pedidos
            WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
            GROUP BY DATE(created_at)
            ORDER BY data DESC
        `;
        
        db.query(query, (error, rows) => {
            if (error) {
                console.error('Erro ao buscar performance:', error);
                return res.status(500).json({
                    success: false,
                    message: 'Erro ao buscar dados de performance',
                    error: error.message
                });
            }
            
            res.json({
                success: true,
                data: rows
            });
        });
    } catch (error) {
        console.error('Erro ao buscar performance:', error);
        res.status(500).json({
            success: false,
            message: 'Erro ao buscar dados de performance',
            error: error.message
        });
    }
});

module.exports = router;