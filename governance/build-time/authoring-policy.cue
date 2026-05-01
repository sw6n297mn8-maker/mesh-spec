package build_time

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// authoring-policy.cue — Política declarativa para authoring de artefatos
// via subagent-drafted dispatch.
//
// Peer (não filho) de quality-gate.cue: separation of concerns —
// quality-gate trata REVIEW de artefatos existentes; authoring-policy
// trata CRIAÇÃO de novos.
//
// Per adr-054. Implementa Level 3 da automação debatida em sessão
// pós-adr-053: codifica meta-guide application como dispatch declarativo
// substituindo aplicação manual ad-hoc.
//
// Fluxo conceitual:
//   1. Main agent identifica necessidade de novo artefato governado
//      (ex.: novo schema sem PG correspondente; adr-053 Phase ativa)
//   2. Main agent consulta authoringPolicy.rollout para artifactType
//   3. Se mode == "subagent-drafted": dispatch authoring subagent
//      com inputContract preenchido + promptTemplate
//   4. Subagent retorna draft (per outputContract) + reasoning report
//   5. Main agent roda cue vet + dispatch review subagent (per quality-
//      gate.cue rollout) → consolida findings → submete a founder
//   6. Founder approval é gate final irreversível (P10)
//
// Direção de dependência: governance/build-time → artifact_schemas.
// Nunca o contrário.

#AuthoringMode: "manual" | "subagent-drafted"

#AuthoringRolloutEntry: {
	artifactType:     artifact_schemas.#ArtifactType
	mode:             #AuthoringMode
	triggerCondition: #AuthoringTrigger
	rationale:        string & !=""
}

#AuthoringTrigger: "manual-invocation" | "file-pair-coverage" | "schema-creation-hook"
// manual-invocation:    Phase 0; agent invoca quando contexto exige
// file-pair-coverage:   Future; structural-check detecta schema sem PG
// schema-creation-hook: Future; pre-commit hook quando novo schema é committed

#FallbackPolicy: {
	onCueVetFailure:  string & !=""
	onSelfReviewFail: string & !=""
	onAmbiguity:      string & !=""
	rationale:        string & !=""
}

#AuthoringPolicySchema: {
	type:     "authoring-policy"
	location: "governance/build-time/authoring-policy.cue"
}

#AuthoringPolicy: {
	_schema:        #AuthoringPolicySchema
	defaultMode:    #AuthoringMode
	rollout:        [...#AuthoringRolloutEntry]
	inputContract:  string & !=""
	outputContract: string & !=""
	promptTemplate: string & !=""
	fallbackPolicy: #FallbackPolicy
	rationale:      string & !=""
}

authoringPolicy: #AuthoringPolicy & {
	_schema: {
		type:     "authoring-policy"
		location: "governance/build-time/authoring-policy.cue"
	}

	defaultMode: "manual"

	rollout: [{
		artifactType:     "production-guide"
		mode:             "subagent-drafted"
		triggerCondition: "manual-invocation"
		rationale: """
			Production-guides têm meta-guide canônico (architecture/
			production-guides/production-guide.cue) que codifica o
			protocol de authoring. Aplicação manual produz variance
			entre sessões; subagent dispatch enforça aplicação
			consistente do protocol. Phase 0 trigger é manual-invocation
			(file-pair-coverage check é dívida planejada per adr-053
			decision item 7 e WI-068).
			"""
	}]

	inputContract: """
		Subagent recebe como contexto:
		1. Path do meta-guide canônico
		   (architecture/production-guides/production-guide.cue).
		2. Path e conteúdo do artifact schema target em
		   architecture/artifact-schemas/{type}.cue.
		3. Paths de 1-3 instâncias de production-guides existentes
		   como referência estrutural (ex.: para domain-model PG,
		   referenciar production-guide.cue do meta-guide e
		   glossary.cue como exemplos de structure variance).
		4. Path do glossary do BC alvo quando aplicável
		   (contexts/{bc}/glossary.cue).
		5. Path da lens domain-specific quando existir
		   (ex.: lens-domain-language para glossary PG;
		   lens-domain-model-design para domain-model PG se a lens
		   existir).
		Subagent NÃO recebe: histórico da conversa que motivou o PG,
		contexto de decisões anteriores no main agent, instruções do
		founder. Isolation per P10 e per quality-gate.cue
		executionPolicy.inputContract pattern.
		"""

	outputContract: """
		Subagent retorna:
		1. Draft #ProductionGuide conformante a schema, com header
		   "// PARTIAL — subagent-drafted, founder review pending".
		   Conteúdo deve passar cue vet local antes do retorno
		   (subagent roda cue vet internamente).
		2. Reasoning report estruturado listando:
		   - Pontos onde subagent inferiu (e razão da inferência)
		   - Pontos onde subagent teria pedido founder (priority list
		     para founder review)
		   - Heurísticas aplicadas que não vieram explicitamente do
		     meta-guide
		3. Log de tentativas de cue vet intermediárias para debugging.
		Formato: lista estruturada em texto + draft CUE separado.
		"""

	promptTemplate: """
		Você é um sub-agente de authoring para production-guide. Sua
		tarefa é produzir um draft de production-guide para um artifact
		schema específico, aplicando o meta-guide canônico do mesh-spec.

		Você NÃO tem acesso ao histórico da conversa que motivou esta
		criação. Aplique exclusivamente o meta-guide protocol e o
		conteúdo dos artefatos fornecidos.

		## Meta-guide (canônico, autoridade do protocol)
		Path: {metaGuidePath}
		Leia o arquivo. Aplique Section 1 (target-and-prerequisites),
		Section 2 (sections-and-workorder), Section 3 (validation-and-meta)
		em ordem. Não desvie do protocol — variance é exatamente o que
		este dispatch corrige.

		## Schema target
		Path: {schemaTargetPath}
		Leia o arquivo. Identifique tipo CUE principal, sub-tipos,
		quality criteria existentes, _schema.location, comments.

		## Instâncias de referência
		Paths: {existingInstancesPaths}
		Leia para padrão estrutural (sections, heuristics, doneCriteria
		patterns). NÃO copie conteúdo verbatim — referência para forma,
		não substância.

		## Glossary do BC alvo (se aplicável)
		Path: {glossaryPath}
		Leia se schema depende de UL específica do BC.

		## Lens domain-specific (se existir)
		Path: {lensPath}
		Aplique se relevante ao domínio do schema.

		## Instruções

		1. Aplique meta-guide Section 1: identificar target type,
		   compor prerequisites (description, collectFromFounder,
		   gapPolicy com cláusula anti-invenção, validatorNote,
		   outputNote).
		2. Aplique meta-guide Section 2: definir sections por atividade
		   autoral lógica (não por campo do schema), workOrder como
		   permutação exata de keys(sections), cada section com target/
		   objective/process/heuristics/doneCriteria/ifGap.
		3. Aplique meta-guide Section 3: compor finalValidation com
		   founder no último step, _schema.location, _qualityCriteria
		   com tq-Xg-NN onde X é abreviação de 2-3 chars do schema.
		4. Rode cue vet localmente; se falhar, corrija; logue tentativas.
		5. Produza reasoning report destacando inferências e priority
		   list para founder review.

		NÃO sugira corrections ao meta-guide. NÃO assuma decisões de
		design (abreviações canônicas, hardening de severities, organização
		de sections além do que protocol prescreve). Em ambiguidade,
		registrar no reasoning report como "would have asked founder".
		"""

	fallbackPolicy: {
		onCueVetFailure: """
			Subagent retry uma vez com correção sintática. Falha persiste
			→ retornar draft com cue vet errors logged + reasoning report
			indicando "cue vet failure"; main agent decide manual takeover
			ou nova dispatch.
			"""
		onSelfReviewFail: """
			Review subagent (per quality-gate.cue rollout) retorna findings
			fail não-resolvíveis → main agent retry uma vez com correções
			no inputContract. Falha persiste → fallback manual com commit
			message documentando "subagent dispatch failed: {motivo}".
			"""
		onAmbiguity: """
			Subagent encontra ambiguidade que requer founder decision
			(ex.: escolha de abreviação canônica, severity hardening que
			diverge da heurística geral) → registrar no reasoning report
			como priority item. Subagent NÃO toma decisão de design;
			retorna draft com placeholder + nota explicando alternativas.
			"""
		rationale: """
			Fallback policy explícita protege contra falhas silenciosas
			ou auto-ratificação de drafts ruins. Failure rate observable
			calibra promptTemplate ao longo do tempo (Q1 da WI-069).
			"""
	}

	rationale: """
		Authoring-policy é peer (não filho) de quality-gate per adr-054
		decision item 1: separation of concerns entre review (quality-gate)
		e creation (authoring-policy). Reusar quality-gate.cue para
		authoring criaria sobrecarga de concerns e coupling indevido.

		defaultMode "manual" garante que nenhum artifactType vira
		subagent-drafted sem entry explícita no rollout — princípio de
		menor surpresa e reversibility por construção.

		Rollout inicial com production-guide reflete adr-053 Phase 2
		scaling (~22 PGs restantes); outros types podem entrar no
		rollout via ADR específico quando padrão validar (ex.: glossary
		instances, validation-prompts, structural-checks).

		promptTemplate referencia meta-guide path em vez de duplicar
		conteúdo (P0). Subagent lê meta-guide diretamente como SoT do
		protocol. Mudanças no meta-guide propagam automaticamente para
		futuros subagent dispatches sem update na promptTemplate.

		fallbackPolicy explícita evita modo silencioso de falha — main
		agent sabe quando re-tentar, quando escalar, quando fazer
		manual takeover. Failure rate é métrica observable para
		calibração contínua.

		Phase 0 design: schema + policy materializados nesta sessão;
		primeira execução real de subagent-drafted authoring ocorre em
		Phase 1 após WI-069 verificar infraestrutura de dispatch.
		Trigger automatizado (file-pair-coverage) é dívida planejada
		dependente de WI-068 + ADR posterior análogo a adr-049.
		"""
}
