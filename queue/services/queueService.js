const Queue = require('../structures/Queue');
const QueueModel = require('../models/queueModel');

class QueueService {
    constructor() {
        this.queue = new Queue();
        this.isProcessing = false;
    }

    loadQueueFromDatabase() {
        QueueModel.getAllPending((error, pendingTasks) => {
            if (error) {
                console.error('Erro ao carregar fila:', error);
                return;
            }

            pendingTasks.forEach(task => {
                this.queue.enqueue(task);
            });

            console.log(`${pendingTasks.length} tarefas carregadas na fila`);
        });
    }

    addTask(taskData, callback) {
        if (!taskData.tipo || !taskData.descricao) {
            const error = new Error('Tipo e descrição são obrigatórios');
            if (callback) return callback(error);
            console.error(error.message);
            return;
        }

        const tiposValidos = ['documento', 'tarefa', 'auditoria', 'embalagem'];
        if (!tiposValidos.includes(taskData.tipo)) {
            const error = new Error('Tipo inválido');
            if (callback) return callback(error);
            console.error(error.message);
            return;
        }

        QueueModel.create(taskData, (error, task) => {
            if (error) {
                console.error('Erro ao adicionar tarefa:', error);
                if (callback) return callback(error);
                return;
            }

            this.queue.enqueue(task);
            console.log(`Tarefa adicionada: ${task.tipo} - ${task.descricao}`);

            const result = {
                success: true,
                task,
                queueSize: this.queue.size()
            };

            if (callback) callback(null, result);
        });
    }

    getQueueInfo() {
        return {
            size: this.queue.size(),
            isEmpty: this.queue.isEmpty(),
            firstTask: this.queue.peek(),
            lastTask: this.queue.peekLast(),
            allTasks: this.queue.toArray(),
            isProcessing: this.isProcessing
        };
    }

    demonstrarFila() {
        console.log('='.repeat(70));
        console.log('ESTRUTURA DE DADOS - FILA (QUEUE)');
        console.log('='.repeat(70));
        
        const info = this.getQueueInfo();
        
        console.log('INFORMAÇÕES DA FILA:');
        console.log(`Tamanho: ${info.size} tarefas`);
        console.log(`Vazia: ${info.isEmpty ? 'Sim' : 'Não'}`);
        console.log(`Primeira tarefa: ${info.firstTask?.descricao || 'N/A'}`);
        
        console.log('TAREFAS NA FILA (ordem FIFO):');
        if (info.allTasks.length === 0) {
            console.log('(vazia)');
        } else {
            info.allTasks.forEach((task, index) => {
                console.log(`${index + 1}. [${task.tipo}] ${task.descricao}`);
            });
        }
        
        console.log('Complexidade: enqueue O(1), dequeue O(1)');
        console.log('='.repeat(70));
    }
}

const queueServiceInstance = new QueueService();

module.exports = queueServiceInstance;
