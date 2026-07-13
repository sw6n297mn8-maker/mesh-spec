package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

rewAgentSpecWi155Coevolution: build_time.#SelfReviewReport & {
	reportId: "srr-rew-agent-spec-wi-155-coevolution"

	artifactPath:       "contexts/rew/agents/rew-primary-agent.cue"
	artifactSchemaPath: "architecture/artifact-schemas/agent-spec.cue"
	artifactType:       "agent-spec"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-13"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — coevolução WI-155 (higiene B, adr-175) do agent-spec do
			rew, a fatia de JULGAMENTO — estreia da exclusão-por-classe
			pesada do repo. PARTIÇÃO (tq-agg-11): 4 cobertura + 31 exclusão
			(35 itens, inventário COMPLETO no Tempo 1 com a frase-marca de
			enforcement verificada em CADA membro — o anti-carimbo).

			COBERTURA (4, zero action nova): evt-signal-received (o agente
			REAGE a signals — ref em act-mark-evaluation-stale, cuja prosa
			já cita o trigger por signal); evt-signal-corruption-detected
			(alert crítico signal-corruption — ref em act-raise-risk-alert,
			prosa já citava); evt-signal-rejected (scope-only — superfície
			de escalação, 'NUNCA drop silent'); inv-rew-alert-dedupe (ref em
			act-raise-risk-alert, cuja precondition JÁ citava a dedupe em
			prosa — estrutura alinhada à prosa correta). O rew NÃO tem prosa
			falsa classe-2: a prosa estava À FRENTE da estrutura (inverso do
			bdg na higiene A).

			EXCLUSÃO (31 = 3 classes + 1 por-id, decisões do founder
			cravadas: classe A ÚNICA, 2 ex-ambíguos → A):
			- engine-enforced-mechanics (24): critério = enforcement
			  declarado PELA MÁQUINA no próprio invariant — frases-marca
			  literais por membro: 'PROIBIDA por construção', 'DAG...
			  PROIBIDOS por construção', 'runtime garante OR emit OR fail',
			  'enforced runtime' (acl-cost-bounded), 'atomic check no
			  aggregate'/CAS, 'deduped no COMMAND level', 'precedência
			  DETERMINÍSTICA', 'DESCARTADO automaticamente', janelas/
			  timeouts policy-defined, automação pol-mark-stale. Inclui os
			  2 fronteiriços com o raciocínio registrado no rationale da
			  classe (staleness-tracking: obrigação da policy, a action
			  modela a transição; supersede-requires-current-active: corrida
			  é CAS do aggregate — as leis de supersede que o agente respeita
			  estão COBERTAS: explicit-supersede-only, supersede-after-emit-
			  only).
			- behavioral-design-time (4): marca LITERAL 'BEHAVIORAL — não
			  estruturalmente enforceable' em cada rationale (model-policy-
			  independence, payload-opacity, no-staleness-feedback-loop,
			  alert-no-feedback-to-evaluation) — enforcement por review/ADR.
			- consumer-side-contract (2): marca literal 'Enforcement
			  consumer-side via consumerProtocol' (successor-chain-bounded,
			  decision-binding-to-evaluation-version) — obrigação dos
			  consumers CMT/FCE/SCF.
			- por-id (1): inv-rew-undetectable-pattern-risk-declared —
			  'HONESTY invariant... força VISIBILIDADE, NÃO COMPORTAMENTO'
			  (marca literal); obrigação sobre o artefato, sc-verificada.

			VERIFICAÇÃO ANTI-DANGLING (o risco da fatia pelo volume): os 31
			refs de exclusão + 4 de cobertura foram conferidos contra o
			catálogo do domain-model ANTES da escrita (zero dangling, zero
			duplicata, match exato com a lista do runner) E o sc-ag-01
			(que valida exclusões dangling desde o adr-175/F4) fechou com
			ZERO violações pós-escrita. [uq-08]: cue vet EXIT=0. [tq-ag-02]:
			refs novos ⊆ scope. [uq-09/tq-agg-11]: runner confirmou sc-ag-02
			do rew = ZERO → BASELINE GLOBAL ZERO (TOTAL do runner 68→31,
			só pré-existentes) — pré-condição da catraca warn→reject
			satisfeita. Comentário do scope atualizado: a doutrina 'operador
			não enforcer' que vivia em comentário virou estrutura declarada
			(scopeExclusions).
			"""
	}]

	findings: {}

	summary: """
		Coevolução do agent-spec do rew — a estreia da exclusão-por-classe
		pesada: 4 coberturas em actions existentes (zero action nova; prosa
		já estava à frente da estrutura) + 31 exclusões conscientes em 3
		classes com frase-marca literal verificada por membro
		(engine-enforced-mechanics 24, behavioral-design-time 4,
		consumer-side-contract 2) + 1 por-id (honesty invariant). Zero
		dangling nos 31 refs (conferidos pré-escrita + sc-ag-01 zero).
		sc-ag-02 do rew a ZERO → baseline GLOBAL ZERO — a catraca
		warn→reject está armável. VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: a revisão substantiva foi o Tempo 1
		(inventário completo dos 35 com frase-marca por item, classificação
		item-a-item, ambíguos apresentados ao founder — não forçados) e as
		decisões vieram cravadas (classe A única, 2 ambíguos → exclusão);
		este round materializou e confirmou com evidência determinística
		(dangling pré-check + runner zero global + vet).
		"""
}
