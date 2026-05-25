package artifact_schemas

// design-principles.cue — Schema do documento singleton de princípios de design.
//
// Per adr-090 follow-on (passo i do cutover): schematiza o fundacional
// architecture/design-principles.cue, que vivia sem _schema.location (zona
// órfã, fora do índice derivado). Escopo deliberadamente mínimo: declara o
// shape que o documento JÁ segue + location singleton + critérios estruturais.
// NÃO redesenha nem avalia o conteúdo dos princípios (decisão do founder).

#PrincipleGroup: "Foundation" | "StructuralInvariants" | "DesignPhilosophy" | "SystemNature" | "Governance"

#DesignPrinciple: {
	id:        string & !=""
	group:     #PrincipleGroup
	statement: string & !=""
	rationale: string & !=""
}

#DesignPrinciples: {
	// Mapa indexado por id; a chave é injetada como id (chave == id).
	principles: [ID=string]: #DesignPrinciple & {id: ID}

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/design-principles\\.cue$"
			fileNameRegex:      "^design-principles\\.cue$"
			description:        "Princípios de design do sistema Mesh (singleton)."
			rationale:          "Artefato fundacional singleton: os princípios que governam o design do sistema. Nome fixo porque é único. Referenciado por domain-definition.designPrinciplesRef."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-dp-01"
			description: "Cada princípio é estruturalmente completo"
			test:        "Cada principles[] tem id (== chave), group ∈ #PrincipleGroup, statement não-vazio e rationale não-vazio. Enforcement primário via schema CUE; este critério é a versão de protocolo."
			severity:    "fail"
			rationale:   "Princípio sem statement ou rationale não orienta design — vira rótulo vazio."
		}, {
			id:          "tq-dp-02"
			description: "id segue a chave e é referenciável"
			test:        "principles[ID].id == ID (injetado pelo pattern). Garante referência estável por id em consumidores (e.g., adr.principlesApplied que cita P0, P12)."
			severity:    "fail"
			rationale:   "Consumidores referenciam princípios por id como string; id instável quebra rastreabilidade cross-artefato."
		}]
		rationale: "Critérios garantem que o documento é uma coleção válida e referenciável de princípios. NÃO avaliam o mérito do conteúdo de cada princípio — isso é decisão do founder, fora do escopo da schematização (adr-090 follow-on)."
	}
}
