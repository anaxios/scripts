
//import { walk, walkSync } from "https://deno.land/std/fs/mod.ts";
//'use strict';


let f = ([x, ...xs]:number[], result:number = 0):number => 
            x == undefined ? result
            : f(xs, result + 1)

let myArray:number[] = [1,2,3,4,5]

let sum = ( i:()=>number, accum:()=>number):()=>number => 
                        {return () => i() + accum()} ;

console.log("Lazy sum", sum(()=> 1000000000000 - 1, ()=> 1)() );


//console.log(f(myArray));

type L<T> = () => T
type LList<T> = L<{
    head: L<T>,
    tail: LList<T>
} | null>

function toList<T>(xs: T[]): LList<T> { 
    return () => {
        if (xs.length === 0) {
            return null;
        } else {
            return {
                head: () => xs[0],
                tail: toList(xs.slice(1))
            };
        }
    };
}


console.log( toList([1,2,3])().head() );

console.log( toList([1,2,3])().tail() );
  
console.log("\n=======================\n")
function range(begin :L<number>): LList<number> {
    return () => {
        let x = begin()
        return {
            head: () => x,
            tail: range(() => x + 1)
        }
    }
}

console.log(range(() => 5)());


console.log("\n=======================\n")

function printList<T>(xs: LList<T>) {
    let pair = xs()
    while(pair !== null) {
        console.log(pair.head());
        pair = pair.tail()
    }

}

printList(toList([1,2,3,4,5]));

console.log("\n=======================\n")

//printList(range(() => 5));

function take(n:L<number>, xs: LList<number>): LList<number> {
    return () => {
        let m = n();
        let pair = xs();
        if( m > 0 ) {
            return {
                head: pair.head,
                tail: take(() => m - 1, pair.tail)
            }
        } else {
            return null;
        }
    };
}

console.log("\n=======================\n")

printList(take(() => 10, range(() => 3)));


function filter<T>(f: (T) => Boolean, xs: LList<T>): LList<T> {
    return () => {
        let pair = xs();
        if(pair === null) {
            return null;
        } else {
            let x = pair.head();
            if(f(x)) {
                return {
                    head: () => x,
                    tail: filter(f, pair.tail)
                };
            } else {
                return filter(f, pair.tail)();
            }
        }
    
    };
}

//printList(filter((x) => x % 2 === 0, range(() => 1)));

function sieve(xs: LList<number>): LList<number> {
    return () => {
        let pair = xs();
        if(pair === null) {
            return null;
        } else {
            let y = pair.head();
            return {
                head: () => y,
                tail: sieve(filter((x) => x % y !== 0, pair.tail))
            };
        }
    };
}
console.log("\n=======================\n")
let prime = sieve(range(() => 2));

//printList( prime );

function sieveO(n: number, xs: LList<number> = range(() => 0)): LList<number> {
    return () => {
        let pair = xs();
        let y = pair.head();
        let z = pair.tail().head();
        return n <= 0 
            ? null  
            : {
                head: () => y + y,
                tail: sieveO(n - 1, pair.tail)
            };
    };
}

function map<T>(f: (T) => number,xs: LList<number>): LList<number> {
    return () => {
        let pair = xs();
        
        if (pair === null) {
           return null 
        } else {
            let y = pair.head();
            { 
            return {
                head: () => f(y),
                tail: map(f, pair.tail)
            };
            }
        }
    };
}
console.log("\n=======================\n")

printList(map((a) => a * 10, take(() => 100, range(() => 1))))

console.log("\n=======================\n")
let primeO = sieveO(10);

printList(primeO);

function fib(c: number): LList<number> {
    let initFib = take(() => c, range(() => 0));

    function fib_itr(fst: number, snd: number, xs: LList<number> ): LList<number> {
         let pair = xs();
         
        return () => (pair === null)
                        ? null
                        : {
                            head: () => fst + snd,
                            tail: fib_itr(snd, fst + snd, pair.tail)
                        };
    }
   
    return () => (c === null)
                        ? null
                        : {
                            head: () => 1,
                            tail: fib_itr(0, 1, initFib)
                        };
}

console.log("\n=======================\n")


printList(fib(100));
