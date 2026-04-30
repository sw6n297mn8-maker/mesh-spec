package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-054 — Declarative authoring policy para subagent-drafted artifacts.
//
// PARTIAL — commit 1 da sequência (scaffold).
// Metadata estrutural completa (id, title, date, decisionClass, decider,
// status, reversibility, blastRadius, affectedArtifacts, derivedArtifacts,
// principlesApplied). context, decision, consequences e rationale com
// placeholders TBD a serem substituídos em commits 2 e 3.

adr054: artifact_schemas.#ADR & {
	id:    "adr-054"
	title: "Establish declarative authoring policy for subagent-drafted artifacts"
	date:  "2026-04-30"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		ADR-053 estabeleceu cobertura universal de production-guides
		(~24 schemas em Phases 1-4). 2 PGs materializados nesta sessão
		(meta-guide, glossary); ~22 restantes para Phases 1-4.

		Authoring atualmente é manual: agent lê meta-guide
		(architecture/production-guides/production-guide.cue), aplica
		protocol Section 1→2→3, founder revisa cada PG individualmente
		em sessão dedicada. Custo observado: 30-90 min de revisão founder
		por PG × ~22 PGs = 11-33h founder time projetadas.

		Variance entre sessões: agentes diferentes (ou mesmo agente em
		sessões diferentes) produzem PGs com estrutura/profundidade
		inconsistente apesar do meta-guide canônico. Causa: aplicação
		do protocol depende de memória contextual e atenção do agente
		— não de mecanismo declarativo enforced.

		Precedente existente: governance/build-time/quality-gate.cue
		executionPolicy.rollout declara automação de REVIEW para tipos
		artifact-schema e adr (mode isolated-subagent). Modelo e tipos
		(#ExecutionPolicy, #SubagentRolloutEntry, inputContract,
		outputContract, promptTemplate) estão validados em produção.

		Gap: nenhum mecanismo análogo formaliza AUTHORING. Authoring
		(criação) e review (avaliação) são concerns distintos —
		quality-gate.cue é sobre validação de artefatos existentes;
		authoring é sobre criar artefatos novos.

		Alternativas avaliadas:
		(a) Manual forever — rejeitada: variance + custo crescem
		linearmente com #PGs criados; não escala para Phase 4.
		(b) Apenas task template (Level 1 da automação) — rejeitada:
		codifica workflow mas não dispara nem padroniza dispatch.
		(c) Validation-prompt-driven post-hoc — rejeitada: validation-
		prompt só roda em arquivo existente; não pode "fix" arquivo
		ausente. Resolve qualidade, não criação.
		(d) Full automation sem founder gate — rejeitada: viola P10
		(founder é gate final para artefatos governados).
		"""
	decision: """
		(1) ESTABELECER authoringPolicy como nova categoria de governança
		em mesh-spec, peer (não filho) de executionPolicy. Authoring
		(criação) e review (avaliação) são concerns distintos com
		artefatos canônicos separados.

		(2) LOCALIZAÇÃO: novo arquivo
		governance/build-time/authoring-policy.cue. Separation of
		concerns: quality-gate.cue trata validação de artefatos
		existentes; authoring-policy.cue trata criação de novos.
		Reusa tipos (#ExecutionMode, #SubagentRolloutEntry pattern)
		mas em estrutura própria (#AuthoringPolicy, #AuthoringRolloutEntry).

		(3) SCHEMA #AuthoringPolicy declara: defaultMode, rollout
		(lista por artifactType), inputContract, outputContract,
		promptTemplate, fallbackPolicy, rationale. Modes inicial:
		"manual" | "subagent-drafted". Defaults para "manual" — nenhum
		artifactType vira subagent-drafted sem entry explícita no
		rollout.

		(4) PRIMEIRO ENTRY: production-guide com mode subagent-drafted.
		Trigger inicial: invocação manual pelo agent quando contexto
		exige novo PG (ex.: adr-053 Phase ativa, founder request).
		Trigger automatizado (file-pair-coverage check) é dívida
		separada — depende de WI-068 (criar structural-checks de
		production-guide) e ADR posterior análogo a adr-049 (file-pair
		kind).

		(5) PHASING: Phase 0 (esta ADR) materializa schema + policy +
		entry; primeira execução real (criar PG via subagent) ocorre
		em Phase 1 após WI-069 verificar infraestrutura de subagent
		dispatch para authoring (vs review já validado em
		executionPolicy.rollout).

		(6) inputContract para production-guide: (a) meta-guide
		(architecture/production-guides/production-guide.cue);
		(b) schema target (architecture/artifact-schemas/{type}.cue);
		(c) 1-3 instâncias de PGs existentes como referência estrutural;
		(d) glossary do BC alvo (se aplicável); (e) lens domain-specific
		quando existir (ex.: lens-domain-language para glossary,
		lens-domain-model-design para domain-model). Subagent NÃO recebe
		histórico da conversa que motivou o PG (isolation per P10).

		(7) outputContract para production-guide: (a) draft #ProductionGuide
		conformante a schema, com header "// PARTIAL — subagent-drafted,
		founder review pending"; (b) reasoning report listando pontos onde
		subagent inferiu (e razão) vs pontos onde teria pedido founder
		(priority list para founder review); (c) tentativas de cue vet
		intermediárias logged para debugging.

		(8) promptTemplate é wrapper curto que (a) referencia meta-guide
		path, (b) referencia schema path, (c) referencia instâncias
		existentes, (d) instrui aplicar protocol Section 1→2→3
		explicitamente. NÃO duplica conteúdo do meta-guide (P0 — meta-
		guide é localização canônica única do protocol).

		(9) ORCHESTRATION (main agent): (a) dispatch authoring subagent
		com inputContract; (b) recebe draft + reasoning report;
		(c) cue vet local; (d) dispatch review subagent (isolated,
		separado do authoring agent) per quality-gate.cue rollout para
		production-guide; (e) consolida findings; (f) submete a founder
		com transparency completa (draft + reasoning report + review
		findings). Founder approval é gate final irreversível.

		(10) ATUALIZAR quality-gate.cue executionPolicy.rollout para
		adicionar production-guide com mode isolated-subagent. Garante
		que review post-authoring usa subagent separado (isolation:
		authoring agent ≠ review agent), reduzindo viés de auto-
		ratificação.

		(11) FALLBACK: se subagent draft falha cue vet OU review subagent
		retorna findings com severity fail não-resolvíveis (ex.:
		ambiguidade que requer founder decision), main agent retry UMA
		vez com correções. Falha persiste após retry → fallback manual
		com commit message documentando "subagent dispatch failed:
		{motivo}; manual takeover". Failure rate é métrica observable
		para calibração de promptTemplate.

		(12) ESCALATION: subagent NÃO pode tomar decision-class
		"foundational" ou "structural" sem founder. Authoring é
		operacional (instanciar #ProductionGuide); decisões de design
		(escolher abreviação, hardening de severities, organização de
		sections) são judgment do main agent + founder, não do
		subagent. Subagent applies protocol; main agent + founder
		define escopo.
		"""
	consequences: "TBD — consequences substantivo em commit 3 da sequência."

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"governance/build-time/authoring-policy.cue",
		"governance/build-time/quality-gate.cue",
		"governance/readme/config.cue",
	]

	derivedArtifacts: [
		"README.md",
	]

	principlesApplied: [
		"P0",
		"P10",
		"P12",
	]

	rationale: "TBD — rationale substantivo em commit 3 da sequência."
}
