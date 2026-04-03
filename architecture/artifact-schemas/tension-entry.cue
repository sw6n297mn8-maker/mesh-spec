package artifact_schemas

// tension-entry.cue — Schema para entradas no tension log.
//
// Registra tensões entre decisões concretas e axiomas/princípios
// operacionais, ou entre artefatos e limitações de schema.
// Tensões não são erros — são trade-offs documentados com
// justificativa explícita e resolução declarada.
//
// Na Mesh, axiomas (domain-definition.cue) são hipóteses estratégicas
// tensionáveis, não verdades absolutas. Este schema formaliza o
// mecanismo de tensão referenciado em CLAUDE.md seção 2: quando uma
// decisão concreta diverge de um axioma, o registro é obrigatório.
// Agentes stateless dependem deste artefato para recuperar contexto
// de trade-offs aceitos em sessões anteriores.
//
// Lense aplicada: lens-knowledge-management
//   Tensão como unidade de conhecimento organizacional externalizável.
//   Sem artefato dedicado, tensões vivem dispersas em rationales
//   individuais — inacessíveis para agentes cross-context.
//
// Limitação conhecida: tensionTarget é singular. Tensão que afeta
// múltiplos targets requer uma entry por target, ou target composto
// descrito textualmente. Decisão deliberada por simplicidade —
// reavaliável se padrão de multi-target for recorrente.

#TensionEntry: {
	// Identificador incremental: ten-001, ten-002, ...
	id: string & =~"^ten-[0-9]{3}$"

	// Data de registro.
	date: string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}$"

	// Título curto descritivo da tensão.
	title: string & !=""

	// Classificação da tensão.
	kind: #TensionKind

	// O que foi tensionado: id do axioma (ax-XX), princípio (dp-XX, PX),
	// ou path do schema cuja limitação gerou a tensão.
	tensionTarget: string & =~"^(ax-[0-9]{2}|dp-[0-9]{2}|P[0-9]+|.+/.+)$"

	// Artefato onde a tensão se manifesta.
	manifestsIn: string & =~"^.+/.+\\.(cue|md)$"

	// Descrição da tensão: o que a decisão concreta precisava,
	// e por que o target não suporta diretamente.
	description: string & !=""

	// Trade-off aceito: qual alternativa foi escolhida e por quê.
	resolution: string & !=""

	// Status da tensão.
	status: #TensionStatus

	// Referência ao artefato ou mecanismo que resolveria a tensão
	// definitivamente (e.g., evolução de schema, novo tipo).
	// Opcional — ausente quando não há resolução estrutural conhecida.
	structuralResolutionPath?: string & !=""

	// ADR relacionado — quando a tensão é resolvida ou criada por decisão formal.
	relatedADR?: string & =~"^adr-[0-9]{3}$"

	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/tension-log/ten-[0-9]{3}-[a-z0-9-]+\\.cue$"
			fileNameRegex:      "^ten-[0-9]{3}-[a-z0-9-]+\\.cue$"
			description:        "Tension log: registro de tensões entre decisões e axiomas/princípios ou limitações de schema."
			rationale:          "Tensões vivem em diretório próprio porque são cross-cutting — podem afetar qualquer BC ou artefato."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-te-01"
			description: "Target é identificável"
			test:        "tensionTarget referencia um id de axioma/princípio válido (ax-XX, dp-XX, PX) ou um path de schema existente no repositório."
			severity:    "fail"
			rationale:   "Tensão sem target identificável é opinião, não registro."
		}, {
			id:          "tq-te-02"
			description: "Resolution descreve trade-off concreto"
			test:        "resolution descreve a alternativa escolhida e a alternativa rejeitada, com justificativa. Não é genérico ('aceito como trade-off') — especifica o que foi ganho e o que foi perdido."
			severity:    "fail"
			rationale:   "Resolution genérica não permite reavaliação futura — quando o contexto mudar, não há informação para decidir se o trade-off ainda é válido."
		}, {
			id:          "tq-te-03"
			description: "Manifestação é rastreável"
			test:        "manifestsIn aponta para um path de artefato existente no repositório onde a tensão é observável."
			severity:    "fail"
			rationale:   "Tensão sem manifestação concreta é especulativa — não há onde verificar nem onde resolver."
		}, {
			id:          "tq-te-04"
			description: "Resolved exige evidência de resolução"
			test:        "Se status é 'resolved', pelo menos um de structuralResolutionPath ou relatedADR deve estar preenchido. Resolução sem evidência rastreável é declaração, não conclusão."
			severity:    "fail"
			rationale:   "Tensão marcada como resolved sem referência ao que a resolveu perde rastreabilidade — não é possível verificar se a resolução é real nem reverter se for incorreta."
		}]
		rationale: "Critérios garantem que cada tensão é rastreável (target + manifestação), acionável (resolution concreta) e reavaliável (informação suficiente para revisão futura). tq-te-04 fecha o ciclo: resolved sem evidência é declaração unilateral."
	}
}

#TensionKind: "axiom-tension" | "schema-limitation" | "cross-artifact-friction"
// axiom-tension:           decisão concreta diverge de axioma ou princípio operacional
// schema-limitation:       schema não suporta o que a modelagem precisa expressar
// cross-artifact-friction: dois artefatos corretos individualmente entram em atrito
//                          entre si. Não usar como catch-all — preferir axiom-tension
//                          ou schema-limitation quando o problema tem target específico.

#TensionStatus: "open" | "accepted" | "resolved"
// open:     tensão identificada, ainda não decidida
// accepted: trade-off aceito explicitamente — convive-se com a tensão
// resolved: tensão eliminada por evolução de schema, refatoração ou nova decisão
