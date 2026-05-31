package artifact_schemas

// agent-probe-record.cue — Schema para o registro de probe agent-against-spec (Ciclo 4).
// Instâncias: architecture/agent-probes/records/<bc>.cue (1 por canvas probado).
//
// Per adr-134: o agent-probe é validação semântica advisory (camada P10, adr-040)
// — dá um canvas fechado a um agente limpo, pede testes de aceitação, e trata
// cada ambiguidade/alucinação como buraco na spec. O record é o audit-trail
// append-only desse processo. Integridade referencial (targetCanvas aponta a
// canvas existente) é gateada por sc-apr-01 (filesystem-path-exists), fora do
// schema. A completude interna (finding tem categoria + disposition se real) é
// gateada por cue vet via a união discriminada abaixo — neutraliza Goodhart.

#ProbeFindingCategory: "spec-incompleteness" | "spec-ambiguity" | "spec-miscommunication" | "probe-noise"

// Disposição de um finding real: aponta a um tracker canônico (WI/DD/ADR/oq) OU
// é aceito como residual com rationale. União por presença de campo.
#ProbeDisposition: {linkedTo: string & !=""} | {acceptedAsResidual: string & !=""}

// #ProbeFinding: união discriminada por category. probe-noise (alucinação ou
// over-assunção — a spec estava ok) NÃO exige disposition. As 3 categorias de
// defeito real exigem disposition; sem ela, cue vet falha (DoD-completeness).
#ProbeFinding: {
	id:            string & =~"^pf-[a-z0-9-]+$"
	description:   string & !=""
	specLocation?: string & !=""
	severity:      "high" | "medium" | "low"
	rationale:     string & !=""
} & ({
	category: "probe-noise"
} | {
	category:    "spec-incompleteness" | "spec-ambiguity" | "spec-miscommunication"
	disposition: #ProbeDisposition
})

// #ProbeRun: uma execução do probe sobre o canvas. runs[] é append-only — cada
// probe adiciona 1 entry; entries anteriores não são editadas (audit trail).
#ProbeRun: {
	probedAt:  string & !=""
	model?:    string & !=""
	findings:  [#ProbeFinding, ...#ProbeFinding]
	rationale: string & !=""
}

#AgentProbeRecord: {
	// Path do canvas probado (cross-ref; sc-apr-01 valida existência).
	targetCanvas: string & =~"^contexts/[a-z0-9-]+/canvas\\.cue$"
	// Versão do promptTemplate do protocolo usada (reprodutibilidade).
	protocolVersion: string & !=""
	// true quando o founder triou os findings deste record.
	triaged: bool | *false
	runs: [#ProbeRun, ...#ProbeRun]
	summary:   string & !=""
	rationale: string & !=""

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-apr-01"
			description: "Todo run tem ao menos um finding"
			test:        "Cada entry em runs[] tem findings com len>=1. Um probe que não produz finding algum (nem real nem noise) não exercitou a spec — entry vazia é evidência de probe não-executado."
			severity:    "fail"
			rationale:   "Run sem finding é record-stub: satisfaz a cobertura por filename sem evidência de probe real (Goodhart). MinItems(1) força conteúdo."
		}, {
			id:          "tq-apr-02"
			description: "Finding real declara disposition"
			test:        "Todo #ProbeFinding com category != probe-noise carrega disposition (linkedTo OU acceptedAsResidual). Enforçado pela união discriminada; este critério é a versão de protocolo."
			severity:    "fail"
			rationale:   "Finding real sem disposition é buraco não-rastreado — o DoD exige que cada defeito surfado tenha destino (tracker ou residual aceito)."
		}, {
			id:          "tq-apr-03"
			description: "targetCanvas aponta a canvas de BC"
			test:        "targetCanvas casa ^contexts/[a-z0-9-]+/canvas\\.cue$. Existência do arquivo é checada por sc-apr-01 (filesystem-path-exists), fora do schema."
			severity:    "warn"
			rationale:   "Record órfão (aponta a canvas inexistente) é probe de algo que não existe; o shape garante a forma, sc-apr-01 garante a existência."
		}]
		rationale: "Critérios cobrem integridade do audit-trail (tq-apr-01 run não-vazio; tq-apr-03 alvo bem-formado) + DoD-completeness contra Goodhart (tq-apr-02 disposition obrigatório no defeito real)."
	}

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/agent-probes/records/[a-z0-9-]+\\.cue$"
			fileNameRegex:      "^[a-z0-9-]+\\.cue$"
			description:        "Registro append-only de execuções do agent-probe sobre um canvas (Ciclo 4)."
			rationale:          "Records vivem co-localizados em architecture/agent-probes/records/ — 1 por canvas probado; consumidos pelo gate de cobertura (directory-pair-coverage) e pelo referencial (sc-apr-01)."
			cardinality:        "collection"
			allowNested:        false
		}
	}
}
