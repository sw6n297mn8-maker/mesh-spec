package tension_log

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ten012: artifact_schemas.#TensionEntry & {
	id:    "ten-012"
	date:  "2026-05-11"
	title: "Schema #EscalationChannel e campo slaDescription vazam semântica runtime/transport em governance envelope"

	kind:          "schema-limitation"
	tensionTarget: "architecture/artifact-schemas/agent-governance.cue"
	manifestsIn:   "contexts/rew/agents/rew-primary-agent.governance.cue"

	description: """
		Durante founder review da Phase 5 REW envelope (Section 1
		routing-and-blast-radius), founder identificou 3 vazamentos
		conceituais build-time/runtime no envelope. Análise revelou
		que 2 dos 3 vazamentos residem no schema #AgentGovernanceEnvelope,
		NÃO no envelope instance.

		Vazamentos schema-level identificados:

		(1) Campo `slaDescription: #NonEmptyString` em #EscalationRoute.
		    Nome 'SLA' puxa semântica operacional/SRE/runtime ('Service
		    Level Agreement' — métrica de execução). Mas o campo declara
		    governance response expectation — janela em que founder/
		    governance-authority deve responder à escalation, não SLA
		    operacional de delivery infrastructure. Nome ideal:
		    `requiredResponseWindow` OU `governanceResponseExpectation`.

		(2) Enum `#EscalationChannel` com valores 'sync-human-review',
		    'async-queue', 'alert-and-block', 'alert-and-continue'.
		    Valores 'async-queue' e 'alert-and-block' carregam semântica
		    de transport runtime concreto (queue mechanism, alerting
		    system). Mas o campo declara governance review mode — modo
		    de revisão exigido pelo governance contract, não mecanismo
		    de delivery. Nome ideal: `#ReviewMode` OU `#GovernanceReviewMode`
		    com valores como 'synchronous-human-review' /
		    'deferred-review' / 'blocking-alert' / 'non-blocking-alert'.

		Manifestação: ao redigir REW envelope Phase 5 Section 1, prose
		inicial usou 'SLA 2h' e 'channel: alert-and-block' herdados de
		pattern INV — founder review identificou que esses termos
		fazem o envelope parecer 'pseudo-runtime implementation' em
		vez de 'runtime governance semantics'.

		Distinção arquitetural que motiva a tensão:
		- agent-spec      = capability + authority + operational contract
		- governance env. = runtime governance semantics (review modes,
		                    response expectations, recovery protocols)
		- runtime code    = execution mechanics (queues, brokers, alerting)

		Schema atual colapsa parcialmente env ↔ runtime code via naming
		que sugere transport. Nome correto separaria normative governance
		mode (envelope) de transport implementation (runtime code).

		Impacto cross-BC: 9 envelopes existentes (CMT/CTR/NPM/INV/DLV/
		IDC/BDG/SSC/P2P) usam o schema atual; rename estrutural exige
		migration coordenada + ADR + structural-check + PG update.
		"""

	resolution: """
		Aceita como tensão com trade-off articulado (Opção B aprovada
		pelo founder durante Phase 5 REW envelope authoring):

		ESCOLHIDO: Manter schema atual + aplicar correções editoriais
		no envelope REW (ajuste prose-level):

		(a) slaDescription field permanece (schema-required);
		    CONTEÚDO reframado em linguagem de governança —
		    'Governance response window: 2h' em vez de 'SLA 2h'.

		(b) channel field permanece (schema-required enum);
		    semântica do envelope declara explicitamente que estes
		    valores representam review modes governance, NÃO transport
		    runtime concreto. Documentação no rationale outer do
		    envelope esclarece a interpretação.

		(c) Runtime transport terminology (broker, acked, dispatched,
		    queue como verbo) PURGADA do prose de descriptions e
		    rationales no envelope REW — substituída por 'runtime
		    emission acknowledgment observed', 'runtime delivery
		    initiated', 'deferred review', 'runtime-observed' etc.

		REJEITADO: Schema rename agora (Opção A descartada por founder).

		Ganho de não agir agora: REW envelope Phase 5 entrega sem
		acoplamento a migration cross-BC; rename arquitetural ganha
		ADR dedicado + migration plan + PG update + structural-check
		update; preserva 9 envelopes existentes funcionando sem patch
		oportunista em schema compartilhado.

		Perda aceita: envelope REW carrega schema field names com
		nomenclatura SRE/transport (channel, slaDescription, enum
		values 'async-queue'/'alert-and-block'), exigindo leitor
		futuro interpretar via contexto + rationale outer em vez de
		via nomes auto-explicativos. Risco residual: novo leitor pode
		assumir que envelope absorve responsabilidade runtime se ler
		schema names isoladamente sem contexto. Mitigação parcial via
		rationale outer + tension-entry visível.

		Gatilho de reabertura para resolução estrutural:
		(a) Decisão founder de priorizar rename + alocação de WI
		    dedicado cobrindo schema patch + 9 envelopes migration +
		    structural-check + PG update; OR
		(b) Identificação concreta de n=3 envelopes futuros (post-REW)
		    onde a confusão build-time/runtime se manifesta novamente
		    em founder review.
		"""

	status: "accepted"

	structuralResolutionPath: "architecture/artifact-schemas/agent-governance.cue"

	rationale: """
		Tensão registrada imediatamente após founder review identificar
		vazamento durante Phase 5 REW envelope authoring (sessão
		2026-05-11). Captura distinção arquitetural emergente: build-time
		governance contract ≠ runtime execution mechanics, com schema
		atual colapsando parcialmente os dois via naming.

		Pattern paralelo a ten-009 (#DecisionClass enum lacks governance
		value) e ten-001 (domain-field optionality) — terceira tensão da
		família 'schema não tem nome adequado para o que precisamos
		expressar'. Diferença: ten-009/001 são gaps de vocabulário
		(enum value missing); ten-012 é gap de naming (nome existente
		semanticamente errado). Sugere que evoluções de enums E
		nomenclatura devem ser revisitadas conforme uso produz
		framings novos.

		Aceito como tensão (não open) porque trade-off foi articulado
		explicitamente pelo founder + correção prose-level aplicada
		imediatamente preserva grande parte do separation conceptual
		mesmo com schema field names inalterados. Open seria
		apropriado se nenhuma mitigação tivesse sido feita.
		"""
}
