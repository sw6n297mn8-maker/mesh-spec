package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-054 — Declarative authoring policy para subagent-drafted artifacts.
//
// Materializado em 3 commits sequenciais (scaffold → context+decision →
// consequences+rationale). Versão produzida via 3 ciclos de red team em
// sessão 2026-04-30 (separation of concerns authoring vs review, trigger
// phasing Phase 0 manual vs future file-pair-coverage, fallback policy
// explícita, P0 enforcement no promptTemplate).

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

		(13) CASCADE ORDERING — production-guide para schema X é
		pré-condição para authoring de qualquer instância de X. Antes
		de criar instância de artifactType com schema em
		architecture/artifact-schemas/, o agente verifica se
		architecture/production-guides/{type}.cue existe. Se ausente:
		Phase 0 — agente cria PG manualmente aplicando meta-guide
		ANTES de criar a instância; founder review do PG é gate antes
		de proceder à instância.
		Phase 1+ (após WI-069) — se artifactType registrado em
		authoring-policy.cue rollout com mode subagent-drafted, agente
		dispatcha authoring subagent para o PG primeiro; aguarda PG ser
		aprovado pelo founder; depois cria a instância (que pode ela
		mesma ser dispatched se também registrada). Recursão aplica.
		Regra deriva de adr-053 universal coverage rule (todo schema
		instanciável tem PG) + adr-054 dispatch declarativo (PG é tipo
		registrado em authoring-policy.cue). Cascade torna a
		derivação explícita e operacionalmente enforced.
		"""
	consequences: """
		Positivas:

		(P1) Variance reduction: aplicação do meta-guide protocol fica
		enforced via dispatch, não dependente de memória do agente.

		(P2) Custo reduction: ~22 PGs restantes via subagent custam
		dispatch (tokens) vs sessão dedicada (founder time). Economia
		potencial de 11-33h founder time.

		(P3) Codifica meta-guide application como repetível e auditável.
		Logs de dispatch + draft + review trail são evidência reusable.

		(P4) Cria pattern reusable para future "X-via-subagent"
		automations (ex.: glossary instances, validation-prompts,
		structural-checks).

		(P5) Founder gate preservado (P10) — subagent draft é proposta,
		não decisão. Founder retém autoridade exclusiva.

		(P6) Self-review preservado — review subagent (separado do
		authoring) reduz viés de auto-ratificação per CLAUDE.md
		"Autovalidação Pré-Proposta".

		(P7) Cross-repo padrão potencial: tekton/portfolio pode adotar
		authoring-policy análoga via promoção FP-XX se padrão validar.

		(P8) Métrica observable: failure rate de subagent dispatches
		permite calibração de promptTemplate ao longo do tempo (Q1 da
		WI-069).

		Negativas:

		(N1) Adiciona arquivo novo (authoring-policy.cue) e schema novo
		(#AuthoringPolicy + sub-types). Manutenção crescente.

		(N2) Custo operacional de subagent dispatch por PG criado
		(~5-15k tokens por execução). Bounded pelo número total de PGs
		mas não-trivial em soma.

		(N3) Couples authoring quality a meta-guide quality. Mudança ao
		meta-guide afeta todos PGs futuros via dispatch. Risk mitigado
		pelo founder review residual.

		(N4) Trigger automatizado depende de WI-068 + ADR posterior;
		Phase 0 trigger manual é menos rigoroso que future. Aceito como
		bridging temporário.

		(N5) Fallback policy adiciona complexidade — main agent precisa
		distinguir "subagent failure" de "founder não-aprovou" e
		escolher caminho. Documentado mas não trivial.
		"""

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

	rationale: """
		P0 (localização canônica única) sustenta a separação
		authoring-policy.cue vs quality-gate.cue: cada arquivo tem
		responsabilidade canônica única (creation vs review). Reusar
		quality-gate.cue para authoring criaria sobrecarga de concerns.

		P10 (agentes recomendam, gates determinísticos validam) é
		preservado: subagent draft é proposta, founder review é gate.
		Adicionalmente, separação authoring-subagent vs review-subagent
		(decisão item 10) reduz viés de auto-ratificação.

		P12 (governança como código) sustenta a forma da policy:
		authoring-policy.cue é instância de schema CUE conformante,
		não markdown narrativo. Verificável estruturalmente, evolui
		via diff, auditável.

		ADR-054 NÃO cria política nova de authoring — codifica e
		operacionaliza o que o meta-guide (architecture/production-
		guides/production-guide.cue) já estabelece como protocol.
		Transição é de "aplicação manual ad-hoc" para "aplicação
		declarativa via dispatch". Meta-guide permanece SoT do protocol;
		ADR-054 + authoring-policy.cue são layer de execução.

		Reversibility "medium": rollout vazio = high (apenas remover
		entry); rollout com N entries usados = decresce com N (PGs
		criados via subagent existem; reverter exige re-criação manual
		caso authoring-policy seja descontinuada). Lens-real-options:
		ativação do rollout compra opção sobre automação; preservar
		rollout vazio mantém opção sem comprometer.

		BlastRadius "cross-cutting": afeta governance + futura criação
		de PGs + comportamento agente. Não repo-wide porque não muda
		convenções de todo artifact (apenas authoring de tipos
		registrados em rollout).

		Lenses consultadas: lens-real-options (rollout é opção que pode
		ser revertida — low cost se vazia; ativação progressiva por
		artifactType preserva phasing); lens-organizational-resource-
		allocation (priorização entre automação inicial — custo ADR +
		schema + WI — vs trabalho manual repetido em ~22 PGs × 30-90 min;
		ROI esperado positivo após ~5-8 PGs via subagent).

		Precedente: adr-040 estabeleceu separação categórica entre
		structural (deterministic gate) e semântica (advisory).
		ADR-054 estende a discriminação para authoring vs review como
		dois concerns separados de governança agente.

		Trade-off com axiomas (ax-XX): nenhuma tensão registrada.
		Foundational principle de delegação a subagentes preserva
		autonomia do founder via gate final.

		Relação com adr-053: adr-053 estabelece a regra (todo schema
		instanciável tem PG); adr-054 estabelece o método de criar os
		PGs em escala. adr-053 cria a obrigação; adr-054 viabiliza o
		cumprimento. Decision item 13 (cascade ordering) torna a
		derivação operacional explícita: PG antes de instância,
		recursivamente.
		"""
}
