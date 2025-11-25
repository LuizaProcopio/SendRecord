const express = require('express');
const router = express.Router();
const queueService = require('../../queue/services/queueService');

function isAuthenticated(req, res, next) {
    if (req.session && req.session.userId) {
        return next();
    }
    return res.status(401).json({ 
        success: false, 
        message: 'Não autenticado' 
    });
}

function isManager(req, res, next) {
    if (req.session && req.session.userRole === 'gerente') {
        return next();
    }
    return res.status(403).json({ 
        success: false, 
        message: 'Acesso negado. Apenas gerentes.' 
    });
}

router.post('/api/add', isAuthenticated, (req, res) => {
    const { tipo, descricao, dados, prioridade } = req.body;

    if (!tipo || !descricao) {
        return res.status(400).json({
            success: false,
            message: 'Tipo e descrição são obrigatórios'
        });
    }

    queueService.addTask({
        tipo,
        descricao,
        dados: dados || {},
        prioridade: prioridade || 'media',
        usuario_id: req.session.userId
    }, (error, result) => {
        if (error) {
            console.error('Erro ao adicionar tarefa:', error);
            return res.status(500).json({
                success: false,
                message: error.message || 'Erro ao adicionar tarefa'
            });
        }
        res.json(result);
    });
});

router.get('/api/info', isAuthenticated, (req, res) => {
    try {
        const info = queueService.getQueueInfo();
        res.json({
            success: true,
            data: info
        });
    } catch (error) {
        console.error('Erro ao buscar info da fila:', error);
        res.status(500).json({
            success: false,
            message: 'Erro ao buscar informações'
        });
    }
});

router.get('/api/statistics', isAuthenticated, (req, res) => {
    queueService.getStatistics((error, stats) => {
        if (error) {
            console.error('Erro ao buscar estatísticas:', error);
            return res.status(500).json({
                success: false,
                message: 'Erro ao buscar estatísticas'
            });
        }
        res.json({
            success: true,
            data: stats
        });
    });
});

router.get('/api/history', isAuthenticated, (req, res) => {
    const { tipo, data_inicio, data_fim } = req.query;
    
    const filters = {};
    if (tipo) filters.tipo = tipo;
    if (data_inicio) filters.data_inicio = data_inicio;
    if (data_fim) filters.data_fim = data_fim;

    queueService.getHistory(filters, (error, history) => {
        if (error) {
            console.error('Erro ao buscar histórico:', error);
            return res.status(500).json({
                success: false,
                message: 'Erro ao buscar histórico'
            });
        }
        res.json({
            success: true,
            data: history
        });
    });
});

router.post('/api/process', isAuthenticated, isManager, (req, res) => {
    queueService.processNext((error, result) => {
        if (error) {
            console.error('Erro ao processar tarefa:', error);
            return res.status(500).json({
                success: false,
                message: error.message || 'Erro ao processar tarefa'
            });
        }
        res.json(result);
    });
});

router.post('/api/process-all', isAuthenticated, isManager, (req, res) => {
    queueService.processAll((error, result) => {
        if (error) {
            console.error('Erro ao processar todas:', error);
            return res.status(500).json({
                success: false,
                message: 'Erro ao processar tarefas'
            });
        }
        res.json({
            success: true,
            data: result
        });
    });
});

router.delete('/api/remove/:id', isAuthenticated, isManager, (req, res) => {
    const taskId = parseInt(req.params.id);
    
    if (isNaN(taskId)) {
        return res.status(400).json({
            success: false,
            message: 'ID inválido'
        });
    }

    queueService.removeTask(taskId, (error, result) => {
        if (error) {
            console.error('Erro ao remover tarefa:', error);
            return res.status(500).json({
                success: false,
                message: error.message || 'Erro ao remover tarefa'
            });
        }
        res.json(result);
    });
});

router.post('/api/test-add-multiple', isAuthenticated, (req, res) => {
    const tarefasTeste = [
        {
            tipo: 'documento',
            descricao: 'Validar documento fiscal',
            dados: { nomeArquivo: 'nota_fiscal_001.pdf', tamanho: '245KB' },
            prioridade: 'alta',
            usuario_id: req.session.userId
        },
        {
            tipo: 'tarefa',
            descricao: 'Gerar relatório mensal',
            dados: { mes: 'novembro', ano: 2025 },
            prioridade: 'media',
            usuario_id: req.session.userId
        },
        {
            tipo: 'auditoria',
            descricao: 'Registro de acesso ao sistema',
            dados: { acao: 'login', ip: '192.168.1.100' },
            prioridade: 'baixa',
            usuario_id: req.session.userId
        }
    ];

    let completed = 0;
    const results = [];

    tarefasTeste.forEach(tarefa => {
        queueService.addTask(tarefa, (error, result) => {
            completed++;
            if (!error) results.push(result);

            if (completed === tarefasTeste.length) {
                res.json({
                    success: true,
                    message: `${results.length} tarefas de teste adicionadas`,
                    tasks: results
                });
            }
        });
    });
});

module.exports = router;
