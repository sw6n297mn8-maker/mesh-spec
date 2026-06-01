package artifact_schemas

// agent-probe-protocol.cue — Schema para o protocolo agent-probe (Ciclo 4).
// Instância singleton: architecture/agent-probes/protocol.cue.
//
// Per adr-134: o protocolo é validação semântica advisory (camada P10, adr-040).
// Self-contained (estilo validation-prompt): isolamento + taxonomia + prompt
// versionado vivem no próprio artefato, sem ref cross-file — por isso é exempt
// de structural-check próprio (sc-meta-02 exemptTypes). findingTaxonomy reusa
// #ProbeFindingCategory (definido em agent-probe-record.cue, mesmo package).

#AgentProbeProtocol: {
	id:      "agent-probe-protocol"
	version: string & !=""
	purpose: string & !=""

	// Contrato de isolamento: o agente probador recebe SÓ o canvas, em sessão
	// limpa, com prompt que não revela as respostas esperadas. Inversão
	// deliberada do modelo de references do validation-prompt — aqui se NEGA
	// contexto para que alucinação/ambiguidade revelem buraco na spec.
	isolation: {
		cleanSession:       bool | *true
		allowedInputs:      [string & !="", ...string & !=""]
		excludedInputs:     [string & !="", ...string & !=""]
		promptNonRevealing: bool | *true
		rationale:          string & !=""
	}

	// O que se pede ao agente limpo (ex.: "gere os testes de aceitação a partir
	// deste canvas").
	probeTask: string & !=""

	// Prompt versionado (não .md externo — tudo é CUE, P0/zero-dup).
	promptTemplate: {
		version:  string & !=""
		template: string & !=""
	}

	// Taxonomia de classificação de findings (reusa o tipo do record).
	findingTaxonomy: [#ProbeFindingCategory, ...#ProbeFindingCategory]

	// Definition-of-done de fechamento (prosa): quando um probe está completo e
	// o que o protocolo NÃO faz (não corrige a spec — só registra buracos).
	closingDoD: string & !=""

	rationale: string & !=""

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-app-01"
			description: "Isolamento exclui fontes que revelariam o design"
			test:        "isolation.excludedInputs contém ao menos domain-model e ADRs; isolation.allowedInputs é o canvas. Probe que recebe o domain-model não testa a spec — confirma o design existente."
			severity:    "fail"
			rationale:   "O valor do probe vem de negar contexto: se o agente vê a fonte do design, ele ratifica em vez de falsificar (viés de confirmação)."
		}, {
			id:          "tq-app-02"
			description: "findingTaxonomy separa gap real de não-defeito de ruído"
			test:        "findingTaxonomy inclui as categorias de #ProbeFindingCategory — gaps reais (3 de defeito deste canvas + cross-bc-gap), não-defeitos (deferred-by-design, already-specified) E probe-noise. Sem separar não-defeito de probe-noise, não-buracos legítimos (deferidos/já-respondidos) seriam contados como alucinação, distorcendo o ratio."
			severity:    "fail"
			rationale:   "Reservar probe-noise a alucinação genuína (distinta dos não-defeitos) é o que torna o ratio spec-finding/probe-noise honesto (falsificationCondition do adr-134); rotular não-defeito como noise faria o record reportar alucinação que não houve."
		}]
		rationale: "Critérios cobrem as duas dimensões que definem o protocolo: isolamento genuíno (tq-app-01 — sem o qual o probe ratifica) e taxonomia que separa sinal de ruído (tq-app-02 — sem a qual a métrica de qualidade da spec é poluída)."
	}

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/agent-probes/protocol\\.cue$"
			fileNameRegex:      "^protocol\\.cue$"
			description:        "Protocolo singleton do agent-probe (Ciclo 4): contrato de isolamento + taxonomia + prompt versionado."
			rationale:          "Protocolo é singleton (um mecanismo de probe para o repo); self-contained (sem ref cross-file) → exempt de structural-check próprio per sc-meta-02. Co-localizado com os records em architecture/agent-probes/."
			cardinality:        "singleton"
			allowNested:        false
		}
	}
}
