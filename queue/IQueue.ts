export interface IQueue<T>{
    enqueue(value: T): void;
    dequeue(): T | undefined;
    peek(): T | undefined;
    isEmpty(): boolean;
    size(): number;
    clear(): void;

    [Symbol.iterator]():Iterator<T>;
}