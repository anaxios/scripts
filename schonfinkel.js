const Idiot = a => a; // identity function
const Mockingbird = f => f(f); // omega combinator; duplicates things
const Kestrel = a => b => a; // gives first; True; const 
const KIte = Kestrel(Idiot); // gives second; false 
const Cardinal = f => a => b => f(b)(a); // flips inputs 
const isTrue = Kestrel;
const isFalse = KIte;
const Not = Cardinal;
const And = p => q => p(q)(p);
const Or = p => q => p(p)(q);
const Beq = p => q => p(q)(Not(q));
const Y = g => g(()=> Y(g));
const Z = g => (x => g(v => x(x)(v)))(x => g(v => x(x)(v)))

console.log("Idiot ", Idiot(1));
console.log("Mockingbird ", Mockingbird(Idiot));
console.log("Kestrel ", Kestrel(1)(2));
console.log("KIte ", KIte(1)(2));
console.log("Cardinal", Cardinal(KIte)(1)(2));
console.log("isTrue", isTrue("true")("false"));
console.log("isFalse", isFalse("true")("false"));
console.log("Not ", Not(Kestrel)(1)(2));
console.log("And ", And(isTrue)(isTrue));
console.log("Or ", Or(isFalse)(isFalse));
console.log("Beq ", Beq(isTrue)(isFalse));


const fact = Z(g =>  x => (x === 0) ? 1 : x * g()(x - 1));

console.log(fact(10));
