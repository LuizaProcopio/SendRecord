class IQueue {
    
    isEmpty() {
        throw new Error("Método isEmpty() deve ser implementado");
    }

    size() {
        throw new Error("Método size() deve ser implementado");
    }

    peek() {
        throw new Error("Método peek() deve ser implementado");
    }

    clear() {
        throw new Error("Método clear() deve ser implementado");
    }

    enqueue(value) {
        throw new Error("Método enqueue() deve ser implementado");
    }

    dequeue() {
        throw new Error("Método dequeue() deve ser implementado");
    }

    [Symbol.iterator]() {
        throw new Error("Método [Symbol.iterator]() deve ser implementado");
    }
}

module.exports = IQueue;