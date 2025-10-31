export class Nodes<T>{

    constructor(
        public value: T,
        public next: Nodes<T> | null = null
    ){}

}