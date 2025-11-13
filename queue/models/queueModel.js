const db = require('../../server/db');

class QueueModel {
    static create(task, callback) {
        const { tipo, descricao, dados, prioridade, usuario_id } = task;
        const query = `
            INSERT INTO queue_tasks 
            (tipo, descricao, dados, prioridade, usuario_id, status)
            VALUES (?, ?, ?, ?, ?, 'pendente')
        `;
        db.query(
            query,
            [
                tipo,
                descricao,
                JSON.stringify(dados || {}),
                prioridade || 'media',
                usuario_id || null
            ],
            (error, result) => {
                if (error) return callback(error);
                callback(null, {
                    id: result.insertId,
                    tipo,
                    descricao,
                    dados,
                    prioridade: prioridade || 'media',
                    status: 'pendente',
                    usuario_id,
                    criado_em: new Date()
                });
            }
        );
    }

    static getAllPending(callback) {
        const query = `
            SELECT * FROM queue_tasks 
            WHERE status = 'pendente'
            ORDER BY FIELD(prioridade, 'alta', 'media', 'baixa'), criado_em ASC
        `;
        db.query(query, (error, rows) => {
            if (error) return callback(error);
            const tasks = rows.map(row => ({
                ...row,
                dados: JSON.parse(row.dados || '{}')
            }));
            callback(null, tasks);
        });
    }

    static getById(id, callback) {
        const query = 'SELECT * FROM queue_tasks WHERE id = ?';
        db.query(query, [id], (error, rows) => {
            if (error) return callback(error);
            if (rows.length === 0) return callback(null, null);
            callback(null, {
                ...rows[0],
                dados: JSON.parse(rows[0].dados || '{}')
            });
        });
    }

    static updateStatus(id, status, erro, callback) {
        const query = `
            UPDATE queue_tasks 
            SET status = ?,
                processado_em = ${status === 'concluida' || status === 'erro' ? 'NOW()' : 'NULL'},
                erro_mensagem = ?
            WHERE id = ?
        `;
        db.query(query, [status, erro, id], (error, result) => {
            if (error) return callback(error);
            callback(null, result.affectedRows > 0);
        });
    }

    static delete(id, callback) {
        const query = 'DELETE FROM queue_tasks WHERE id = ?';
        db.query(query, [id], (error, result) => {
            if (error) return callback(error);
            callback(null, result.affectedRows > 0);
        });
    }

    static moveToHistory(id, callback) {
        db.query('SELECT * FROM queue_tasks WHERE id = ?', [id], (error, tasks) => {
            if (error) return callback(error);
            if (tasks.length === 0) return callback(new Error('Tarefa não encontrada'));

            const task = tasks[0];
            const tempoProcessamento =
                task.processado_em && task.criado_em
                    ? Math.floor((new Date(task.processado_em) - new Date(task.criado_em)) / 1000)
                    : null;

            db.query(
                `INSERT INTO queue_history 
                (task_id, tipo, descricao, dados, usuario_id, tempo_processamento)
                VALUES (?, ?, ?, ?, ?, ?)`,
                [task.id, task.tipo, task.descricao, task.dados, task.usuario_id, tempoProcessamento],
                error => {
                    if (error) return callback(error);
                    db.query('DELETE FROM queue_tasks WHERE id = ?', [id], error => {
                        if (error) return callback(error);
                        callback(null, true);
                    });
                }
            );
        });
    }

    static getStats(callback) {
        const query = `
            SELECT 
                COUNT(*) as total,
                SUM(CASE WHEN status = 'pendente' THEN 1 ELSE 0 END) as pendentes,
                SUM(CASE WHEN status = 'processando' THEN 1 ELSE 0 END) as processando,
                SUM(CASE WHEN status = 'concluida' THEN 1 ELSE 0 END) as concluidas,
                SUM(CASE WHEN status = 'erro' THEN 1 ELSE 0 END) as erros
            FROM queue_tasks
        `;
        db.query(query, (error, rows) => {
            if (error) return callback(error);
            callback(null, rows[0]);
        });
    }

    static getHistory(filters, callback) {
        let query = 'SELECT * FROM queue_history WHERE 1=1';
        const params = [];

        if (filters.tipo) {
            query += ' AND tipo = ?';
            params.push(filters.tipo);
        }

        query += ' ORDER BY concluido_em DESC LIMIT 100';

        db.query(query, params, (error, rows) => {
            if (error) return callback(error);
            const history = rows.map(row => ({
                ...row,
                dados: JSON.parse(row.dados || '{}')
            }));
            callback(null, history);
        });
    }
}

module.exports = QueueModel;
