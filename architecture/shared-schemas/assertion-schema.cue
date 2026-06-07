package shared_schemas

// assertion-schema.cue -- Gramatica formal #Assertion (shared-schema).
//
// O QUE E: forma estruturada de um invariant/regra de dominio. E a fonte
// canonica que o gerador de testes (CI do mesh-runtime) consome via codegen
// para produzir property-based tests -- padrao CUE->.proto: CUE define a
// estrutura, o codegen produz o executavel. CUE e o CONTAINER das assertions,
// nao a engine de avaliacao. Estabelecida como artifact-class de primeira
// ordem em adr-140 item 6.
//
// LENTE (lens-testing-and-validation-for-financial-systems): invariants
// financeiros (conservation, double-entry, bilateral consent) viram
// property-based tests; a gramatica precisa ser ESTRUTURADA -- nao texto
// livre -- para o codegen conseguir gerar a propriedade.
//
// ESCOPO c-puro -- o que CUE governa vs o que e deferido:
//   GOVERNADO por cue vet (shape + arity):
//     - relation->right: union discriminada (binaria EXIGE right; unaria
//       PROIBE via right?: _|_). Modelo: #DeferredDecision status<->aux.
//     - op->operands: tupla de tamanho fixo por discriminante (not=1,
//       implies=2, and|or>=2).
//     - source: enum fechado (V1 minimal; expansao via ADR).
//   DEFERIDO (registrar como def proprio; NAO neste arquivo):
//     - def-053 (enforcement): resolucao #VarRef.var -> #Variable.name no
//       mesmo #Assertion. Os VarRef vivem em arvore recursiva de predicados;
//       local-field-reference-integrity (adr-100) percorre 1 nivel, nao
//       recursao -- mesma inexpressibilidade do adr-144 C5. Review-trusted
//       ate existir kind recursivo.
//     - def-054: #ArithExpr (aritmetica multi-termo) e
//       quantificacao (forall). #Term hoje = #VarRef | #Literal; a extensao
//       e aditiva (nao-breaking).
//     - def-049: mecanismo concreto assertion-to-test.
//
// SEM _schema.location: shared-schema e tipo reutilizavel importado por
// outros schemas (como money.cue/envelope.cue), nao governa instancias
// proprias -- logo sc-pg-01 nao aplica.
//
// DISCIPLINA DE FRONTEIRA (anti-stealth-extension): expandir #Term
// (aritmetica), o enum source, ou o vocabulario de relation/op exige
// decisao explicita (ADR/def) -- nunca edicao local por conveniencia.
// Mesmo regime de money.cue/envelope.cue.

#Assertion: {
	id:      =~"^asrt-[a-z][a-z0-9-]+$"
	subject: string & !=""
	variables: [...#Variable]
	predicate: #Predicate
	rationale: string & !=""
}

#Variable: {
	name: =~"^[a-zA-Z][a-zA-Z0-9_]*$"
	// A4: enum fechado -- o codegen roteia por source, entao P1 exige
	// exaustividade. V1 minimal; expansao via ADR (precedente #AdjacentCondition).
	source:  "event-log" | "command" | "aggregate-state" | "projection" | "contract"
	filter?: string & !=""
}

// #Term: valor que o predicado opera. #ArithExpr DEFERIDO (def-054).
#Term: #VarRef | #Literal

// #VarRef.var resolve a um #Variable.name do MESMO #Assertion -- enforcement
// deferido (def-053): nao gate-able pelo kind recursivo atual.
#VarRef: {var: =~"^[a-zA-Z][a-zA-Z0-9_]*$"}
#Literal: {const: string & !=""}

// A1: arity relation->right via union discriminada.
// Binaria EXIGE right; unaria (exists/not-exists) PROIBE right (right?: _|_).
#PredicateLeaf: {
	relation: "eq" | "neq" | "lt" | "lte" | "gt" | "gte" | "in" | "subset-of"
	left:     #Term
	right:    #Term
} | {
	relation: "exists" | "not-exists"
	left:     #Term
	right?:   _|_
}

// A2: arity op->operands via tupla de tamanho fixo por discriminante.
#PredicateComposite: {
	op: "not"
	operands: [#Predicate]
} | {
	op: "implies"
	operands: [#Predicate, #Predicate]
} | {
	op: "and" | "or"
	operands: [#Predicate, #Predicate, ...#Predicate]
}

#Predicate: #PredicateLeaf | #PredicateComposite
