package artifact_schemas

// Architecture Decision Record — registro formal de decisões
// que alteram artefatos arquiteturais ou de governança.
//
// Cada ADR captura o contexto, a decisão, suas consequências,
// e metadata de risco que permite governança proporcional.
//
// O tipo #ADR é uma união discriminada por status:
//   - status != "superseded" → supersededBy proibido
//   - status == "superseded" → supersededBy obrigatório
// Invariants relacionais (existência do ADR referenciado,
// simetria supersedes↔supersededBy, acyclicity) são
// responsabilidade do CI (phase adr-consistency).

#ADR: #ADRBase & ({
	status:        #NonSupersededStatus
	supersededBy?: _|_
} | {
	status:       "superseded"
	supersededBy: string & =~"^adr-[0-9]{3}$"
})

#NonSupersededStatus: "proposed" | "accepted" | "rejected" | "withdrawn"
// proposed:   decisão ainda não aprovada pelo decider
// accepted:   decisão aprovada e vigente
// rejected:   decisão avaliada e recusada (mantida para histórico)
// withdrawn:  decisão retirada antes de aprovação (diferente de rejected: nunca chegou a ser avaliada formalmente)

#ADRBase: {
	id:    string & =~"^adr-[0-9]{3}$"
	title: string & !=""
	date:  string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}$"

	// Classificação da decisão — governa peso de revisão e rastreabilidade.
	decisionClass: #DecisionClass

	// Quem decidiu. Para mesh-spec atual: "founder".
	// Futuramente: agente + aprovador humano.
	decider: string & !=""

	// Contexto que motivou a decisão. O "porquê agora".
	context: string & !=""

	// A decisão tomada. Deve ser afirmativa e específica.
	decision: string & !=""

	// Consequências conhecidas — positivas e negativas.
	consequences: string & !=""

	// Status da decisão — discriminante da união em #ADR.
	status: #NonSupersededStatus | "superseded"

	// ADR que substitui este (preenchido apenas quando status == "superseded").
	// Constraint de presença/ausência é imposto pela união discriminada em #ADR.
	supersededBy?: string & =~"^adr-[0-9]{3}$"

	// ── Metadata de risco ──

	reversibility: #Reversibility
	blastRadius:   #BlastRadius

	// ── Rastreabilidade ──

	// Artefatos normativos existentes alterados por esta decisão.
	// Per adr-059: paths novos criados pela decisão devem ir em
	// plannedOutputs (não aqui). ADRs anteriores a adr-059 grandfathered:
	// podem conter mix de existing-altered + new-created neste field.
	// Relaxado para optional non-empty list (era required ≥1) per adr-059
	// follow-up: ADRs cuja única atividade é criar paths novos têm
	// affectedArtifacts vazio + plannedOutputs preenchido. At-least-one
	// across {affectedArtifacts, plannedOutputs, derivedArtifacts} é
	// discipline narrative em PG-ADR (não enforced por schema dado limites
	// de disjunção CUE sobre fields opcionais; runner futuro pode validar).
	affectedArtifacts: [...string & !=""]

	// Artefatos novos criados pela decisão como output direto.
	// Per adr-059: optional, separação explícita de affectedArtifacts
	// para discipline 3-way (existing-altered / new-created / derived-
	// regenerated). ADRs pré-adr-059 grandfathered sem este field.
	plannedOutputs?: [...string & !=""]

	// Artefatos regenerados ou ajustados como consequência (não como decisão direta).
	derivedArtifacts?: [...string & !=""]

	// Deferimentos conscientes governados criados por esta decisão (per adr-062).
	// Cada id em defersTo deve resolver para architecture/deferred-decisions/def-XXX-*.cue
	// existente. Forward-looking: ADRs pré-adr-062 não usam (gaps prose grandfathered);
	// ADRs pós-adr-062 SHOULD usar defersTo em vez de prose 'Known gaps declarados'
	// quando deferimento tem trigger codificável.
	defersTo?: [...string & =~"^def-[0-9]{3}$"]

	// Princípios de design (design-principles.cue) aplicados na decisão.
	principlesApplied: [string & !="", ...string & !=""]

	// ── Cadeia de decisão ──

	// ADRs que esta decisão substitui (total ou parcialmente).
	// Invariant relacional (enforcement via CI phase adr-consistency):
	//   para cada id em supersedes, o ADR correspondente deve existir,
	//   ter status == "superseded", e supersededBy apontando para este ADR.
	supersedes?: [...string & =~"^adr-[0-9]{3}$"]

	rationale: string & !=""

	// Metadata do schema — não exportado para instâncias.
	_schema: {
		location: {
			canonicalPathRegex: "^architecture/adrs/adr-[0-9]{3}-[a-z0-9-]+\\.cue$"
			fileNameRegex:      "^adr-[0-9]{3}-[a-z0-9-]+\\.cue$"
			description:        "Architecture Decision Records: registro formal de decisões arquiteturais e de governança."
			rationale:          "ADRs vivem em diretório próprio dentro de architecture/ porque governam decisões cross-cutting, não pertencem a um BC específico."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-adr-01"
			description: "Alternativas consideradas com justificativa de rejeição"
			test:        "O campo context ou decision menciona pelo menos uma alternativa considerada e explica por que foi rejeitada. Se não havia alternativa real, o rationale explica por quê (e.g., bootstrapping, única opção viável)."
			severity:    "fail"
			rationale:   "ADR sem alternativas é declaração, não decisão. O valor do ADR está em registrar o espaço de decisão explorado."
		}, {
			id:          "tq-adr-02"
			description: "Metadata de risco reflete a decisão real"
			test:        "reversibility e blastRadius são consistentes com o conteúdo de decision e consequences. Não são defaults genéricos — se a decisão afeta múltiplos schemas, blastRadius não é 'local'; se altera contratos persistidos, reversibility não é 'high'."
			severity:    "fail"
			rationale:   "Metadata de risco genérica derrota o propósito de governança proporcional — decisões de alto risco recebem mesmo escrutínio que triviais."
		}, {
			id:          "tq-adr-03"
			description: "Paths em affectedArtifacts são reais"
			test:        "Cada path em affectedArtifacts existe no repositório ou será criado como output direto da decisão registrada. Paths que não existem e não serão criados são referências quebradas."
			severity:    "fail"
			rationale:   "affectedArtifacts é entrada para análise de blast radius e CI. Paths fictícios tornam a rastreabilidade ilusória."
		}]
		rationale: "ADRs são o registro de decisão do sistema. Critérios garantem que cada ADR captura o espaço de decisão, não apenas o resultado."
	}
}

#DecisionClass: "foundational" | "structural" | "local" | "experimental"
// foundational: decisão que define base do sistema (governança, schema base, SoTs)
// structural:   decisão que altera estrutura entre artefatos (novas relações, novos tipos)
// local:        decisão contida em um artefato ou BC específico
// experimental: decisão explicitamente temporária, com critério de revisão

#Reversibility: "high" | "medium" | "low"
// high:   pode ser revertida sem impacto em dados persistidos ou contratos públicos
// medium: reversível com esforço moderado (migração de dados, ajuste de consumidores)
// low:    irreversível ou com custo de reversão desproporcional

#BlastRadius: "local" | "cross-artifact" | "cross-cutting" | "repo-wide"
// local:          afeta 1 artefato ou 1 schema
// cross-artifact: afeta múltiplos artefatos dentro do mesmo domínio/contexto
// cross-cutting:  afeta artefatos em múltiplos domínios ou contextos
// repo-wide:      afeta governança, CI, ou estrutura do repositório inteiro
