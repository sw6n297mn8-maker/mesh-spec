package artifact_schemas

import "list"

// aggregate-manifest.cue — Schema para AggregateManifest (governanca de
// manifests, adr-144).
//
// AggregateManifest e a SoT spec-side de um aggregate: commands que aceita,
// events que emite, invariants relevantes, Ports que requer, e os artefatos
// gerados esperados (adr-141 item 5). Per-aggregate (true-coverage, deferida a def-051).
//
// Conformance (adr-141 item 5): portsRequired subconjunto dos 5 Ports
// (constraint NATIVA via #PortRef); commands/events sao ids bem-formados
// (shape via #CommandRef/#EventRef, agora). Duas verificacoes adicionais,
// ambas FORA do schema e distintas entre si: (a) existencia dos ids no
// domain-model do BC -- spec-side, CUE-referenciavel, sc-check buildavel
// DEFERIDO a def-052 (decisao plain-vs-instance-scoped pendente); (b) subset
// do canon runtime (canon/command, canon/event) -- cross-repo, NAO
// CUE-referenciavel global (adr-144 C1), concept distinto de (a), deferido
// separadamente. Aqui (schema) sao apenas ids bem-formados.
//
// #PortRef e definido em port-manifest.cue (localizacao canonica unica, P0).

#AggregateManifest: {
	// Identificador do manifest: am-<slug> (tipicamente o code do aggregate).
	id: string & =~"^am-[a-z0-9-]+$"

	// Nome legivel do aggregate (item 5: "aggregate name/id").
	name: string & !=""

	// Elo ao aggregate no domain-model do BC (agg-*). Required: manifest-ref-integrity
	// (C5) verifica via cross-file-id-exists que o aggregate declarado EXISTE; sem ele
	// a verificacao seria vacuamente verde.
	aggregateRef: #AggregateRef

	// "commands aceitos" (item 5) -- ids cmd-*. Existencia no domain-model do BC
	// e sc-check buildavel DEFERIDO a def-052 (nao unificacao CUE).
	commandsAccepted: [...#CommandRef]

	// "events emitidos" (item 5) -- ids evt-*. Idem (def-052).
	eventsEmitted: [...#EventRef]

	// "invariants/assertions relevantes" (item 5) -- ids inv-*.
	invariants: [...#InvariantRef]

	// "Ports requeridos" (item 5) -- subconjunto dos 5 Ports. Constraint NATIVA
	// (#PortRef + UniqueItems). Pode ser vazio (aggregate sem dependencia de Port).
	portsRequired: [...#PortRef] & list.UniqueItems

	// "generated artifacts esperados" (item 5) -- o que o codegen produz a partir
	// deste manifest (ex.: aggregate base). "o aggregate base gerado deriva do
	// AggregateManifest" (item 5 conformance).
	generatedArtifacts: [...#GeneratedArtifact]

	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^contexts/[a-z][a-z0-9-]*/aggregate-manifests/am-[a-z0-9-]+\\.cue$"
			fileNameRegex:      "^am-[a-z0-9-]+\\.cue$"
			description:        "AggregateManifest: SoT spec-side de um aggregate (commands/events/invariants/Ports/generated artifacts), per-aggregate."
			rationale:          "Vive em contexts/{bc}/aggregate-manifests/ porque e per-aggregate (multiplos por BC); a true-coverage (aggregate->manifest pela path) e deferida a def-051."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-am-01"
			description: "Manifest declara ao menos um command ou event"
			test:        "commandsAccepted ou eventsEmitted contem ao menos um id. Aggregate que nao aceita command nem emite event nao tem superficie -- manifest vazio e equivalente a ausencia."
			severity:    "fail"
			rationale:   "Well-formedness spec-side (adr-144 c-puro): um AggregateManifest sem command nem event nao governa nada."
		}, {
			id:          "tq-am-02"
			description: "Ids de command/event/invariant sao bem-formados; existencia (cross-file) deferida a def-052"
			test:        "commandsAccepted (cmd-*), eventsEmitted (evt-*), invariants (inv-*) conformam aos regexes (enforced por #CommandRef/#EventRef/#InvariantRef). A existencia de cada id no domain-model do BC NAO e verificada aqui -- e cross-file, sc-check buildavel DEFERIDO a def-052 (decisao plain-vs-instance-scoped pendente). Distinto do subset-do-canon runtime (canon/command, canon/event), que e cross-repo e NAO CUE-referenciavel global (adr-144 C1)."
			severity:    "fail"
			rationale:   "Separacao explicita: shape (regex) e gate de schema agora; existencia no domain-model (cross-file, buildavel) e gate deferido a def-052; subset-do-canon runtime e concept cross-repo distinto -- coerente com adr-144 c-puro e def-002 (cross-file fora do schema)."
		}]
		rationale: "Criterios cobrem well-formedness spec-side do AggregateManifest (adr-144 c-puro): nao-vacuidade de superficie e shape de ids. Existencia dos ids no domain-model e portsRequired<->5 (subset) sao, respectivamente, gate deferido a def-052 (cross-file buildavel) e constraint nativa (#PortRef)."
	}
}

// Artefato gerado esperado a partir do AggregateManifest (ex.: aggregate base,
// skeleton). Descricao spec-side do output do codegen; a geracao em si vive
// downstream (pipeline de codegen, adr-140 / mesh-runtime).
#GeneratedArtifact: {
	kind:        string & !=""
	description: string & !=""
	rationale:   string & !=""
}
