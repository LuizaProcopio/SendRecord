const IQueue = require('./IQueue');
const Nodes = require('./Nodes');

class Queue extends IQueue {
    constructor() {
        super();
        this.head = null;
        this.tail = null;
        this.length = 0;
    }

    isEmpty() {
        return this.length === 0;
    }

    size() {
        return this.length;
    }

    peek() {
        return this.head?.value;
    }

    peekLast() {
        return this.tail?.value;
    }

    clear() {
        this.head = null;
        this.tail = null;
        this.length = 0;
    }

    enqueue(value) {
        const node = new Nodes(value);
        if (this.isEmpty()) {
            this.head = this.tail = node;
        } else {
            this.tail.next = node;
            this.tail = node;
        }
        this.length++;
    }

    dequeue() {
        if (this.isEmpty()) return undefined;
        const value = this.head.value;
        this.head = this.head.next;
        if (!this.head) this.tail = null;
        this.length--;
        return value;
    }

    toArray() {
        const result = [];
        let current = this.head;
        while (current) {
            result.push(current.value);
            current = current.next;
        }
        return result;
    }

    toString() {
        if (this.isEmpty()) return "Queue: []";
        return `Queue: [${this.toArray().map(t => t.descricao || t).join(' <- ')}]`;
    }

    [Symbol.iterator]() {
        let current = this.head;
        return {
            next: () => {
                if (current) {
                    const value = current.value;
                    current = current.next;
                    return { value, done: false };
                }
                return { value: undefined, done: true };
            }
        };
    }
}

module.exports = Queue;
