import type { IQueue } from "./IQueue.js";
import { Nodes } from "./Nodes.js";

export class Queue<T> implements IQueue<T>, 
    Iterable<T>{

    private head: Nodes<T> | null = null;
    private tail: Nodes<T> | null = null;
    private length = 0;

    enqueue(value: T): void {
        const node = new Nodes(value);

        if(!this.head){
            this.head = this.tail = node;
        } else {
            this.tail!.next = node;
            this.tail = node;
        }

        this.length++;
    }

    dequeue(): T | undefined {
        if(!this.head) return undefined;
        
        const {value} = this.head;

        this.head = this.head.next;
        this.length--;

        if(!this.head) 
            this.tail = null;

        return value;
    }

    peek(): T | undefined {
        return this.head?.value;
    }

    isEmpty(): boolean {
        return this.length === 0;
    }

    size(): number {
        return this.length;
    }

    clear(): void {
        this.head = null;
        this.tail = null;
        this.length =0;
    }

    [Symbol.iterator](): Iterator<T> {
        let curr = this.head;
        return {
            next : () : IteratorResult<T> => {
                if(curr){
                    const value = curr.value;
                    curr = curr.next;
                    return {value, done: false}
                }
                return {value: undefined as any, done: true}
            }
        }
    }

}