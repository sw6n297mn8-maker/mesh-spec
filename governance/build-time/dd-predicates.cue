package build_time

// dd-predicates.cue — Registry de predicados estruturais para triggers de
// deferred-decisions (kind structural-predicate, per adr-166).
//
// Cada predicado é nomeado (ddp-NNN), versionado em git, e avaliado pelo
// runner determinístico (scripts/ci/evaluate_deferred_triggers.py) via:
//     cue export <package> -e <expr> --out json
// O sinal é lido da ESTRUTURA de artefatos tipados — não de regex sobre o
// texto deles. Limites conhecidos (adr-166): campos ocultos (_*) não saem
// no export; uma avaliação não cruza packages. Alvos fora desses limites
// permanecem em triggers textuais escopados (recurrence + pathScope).
//
// Contrato de falha (adr-166 decisão item 2): predicado referenciado por
// trigger e ausente aqui, ou package/expr que não avalia, é MALFORMAÇÃO —
// o runner falha ALTO (::error + exit 1). Nunca degrada para count 0.
//
// Localização canônica única (P0): triggers referenciam ddp-NNN por id;
// a expressão vive apenas aqui. Registry é singleton em schemaExemptZone
// (governance/build-time/, adr-098) — engine/config, não artifact type.
//
// ddp-001 APOSENTADO per adr-167 (2026-07-03): def-012 resolveu — o
// enforcement das Regras A+B no check-self-review substitui o sensor
// (gate > sinal); predicado sem consumidor seria declared-but-unused
// (anti-pattern do def-014). A série histórica vive no git.

#DDPredicate: {
	id: string & =~"^ddp-[0-9]{3}$"

	// Package CUE alvo do cue export, relativo à raiz do repo.
	package: string & =~"^\\./.+/$"

	// Expressão avaliada no contexto do package. Deve produzir número
	// (comparator ">=") ou booleano (comparator "==true").
	expr: string & !=""

	// ">="   → dispara quando valor numérico >= threshold.
	// "==true" → dispara quando valor booleano é true (threshold ausente).
	comparator: ">=" | "==true"
	threshold?: int & >=1
	if comparator == ">=" {
		threshold: int & >=1
	}

	rationale: string & !=""
}

ddPredicates: [ID=string]: #DDPredicate & {id: ID}

ddPredicates: {
	"ddp-002": {
		package:    "./strategic/"
		expr:       "len(meshContextMap.declaredFlows)"
		comparator: ">="
		threshold:  2
		rationale:  "def-031: segundo declaredFlow no context-map lido do campo tipado (substitui regex frágil 'declaredFlows:[^]]*,[^]]*\"' sobre o texto). Baseline na migração: 1."
	}
	"ddp-003": {
		package:    "./governance/build-time/"
		expr:       "frontendCodegenContract.status == \"accepted\""
		comparator: "==true"
		rationale:  "def-064: aceitação do frontend-codegen-contract lida do campo status tipado (substitui file-contains 'status: \"accepted\"' vulnerável a reformatação). Baseline na migração: proposed (false)."
	}
	"ddp-004": {
		package:    "./architecture/structural-checks/"
		expr:       "len([for s in structuralChecks[\"sc-pg-01\"].rule.coveredSchemas if s == \"design-principle\" {s}])"
		comparator: ">="
		threshold:  1
		rationale:  "def-030: entrada de design-principle na whitelist coveredSchemas do sc-pg-01 lida da lista tipada (substitui file-contains 'design-principle' que casaria qualquer menção em prosa do arquivo). Baseline na migração: ausente (0)."
	}
}
