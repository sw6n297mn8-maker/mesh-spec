package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

plr: artifact_schemas.#Subdomain & {
	code: "plr"
	name: "Policy Registry"
	type: "supporting-subdomain"

	definition: """
		Registro canônico de identidade de policies operadas dentro
		da Mesh — regulatory (L1 invioláveis Bacen/LGPD/KYC/AML),
		cross-BC (políticas que cruzam fronteira de bounded context),
		e bc-local (espelhadas por mecanismos legacy #Policy do
		domain-model). Per adr-065: registry-only — NÃO engine,
		NÃO executor, NÃO orchestrator. Schema enforce essa fronteira
		via enforcement: 'external' literal-locked. Enforcement
		permanece distribuído nos BCs, flows, agents que já existem.
		"""

	purpose: """
		Eliminar drift de identidade entre as 4 camadas atualmente
		desconectadas de policies (#Policy domain-model, #AgentGovernance
		Envelope, policyRefs flows, quality-gates). Policies regulatórias
		L1 deixam de ser prose dispersa, ganham identidade auditável
		com owner + version + scope + class + rationale. Versionamento
		mínimo (version: int) elimina drift invisível; lifecycle
		sofisticado (rollout, compatibility, deprecation, upgrade)
		deferido via def-009. Sanity test invariante crítico: se PLR
		for removido, BCs continuam funcionando — schema preserve
		via enforcement: 'external' literal-locked.
		"""

	negativeBoundaries: [{
		responsibility: "Execução e avaliação de policies — runtime evaluation, dispatch, decisão de allow/deny."
		delegatedTo: {
			type: "subdomain"
			ref:  "cmt"
		}
		rationale: "PLR é registry-only per adr-065. Execution distribuída entre BCs que executam operations sob policy; cmt (Commitment) é central executor proxy porque commitment lifecycle é onde policies operam mais frequentemente. Outros BCs executam policies bc-local diretamente via #Policy do domain-model. PLR fornece IDENTIDADE; BCs executam SEMÂNTICA."
	}, {
		responsibility: "Orchestration e saga de policies cross-BC — coordenação entre múltiplos BCs em decisões compostas."
		delegatedTo: {
			type: "external-system"
			ref:  "ext-cross-context-orchestration"
		}
		rationale: "Workaround de schema: #DelegationTarget não modela internal-governance-mechanism; usado external-system apenas para expressar delegado não-subdomain. Não implica sistema externo real. Cross-context orchestration é mecanismo interno (cross-context-flow.cue + flows + saga patterns dentro de BCs); não é subdomain (é cross-cutting). Quando engine cross-BC for materializado (def-005), orchestration semantics será definida lá."
	}, {
		responsibility: "Execução de policies financeiras — decisões sobre commitment lifecycle, settlement, exposure limits."
		delegatedTo: {
			type: "subdomain"
			ref:  "fce"
		}
		rationale: "FCE (Financial Commitment Execution) é primary executor para policies financeiras — onde regulatory L1 (Bacen) tipicamente materializa em decisões operacionais. PLR registra identidade da policy; FCE executa quando aplicável."
	}, {
		responsibility: "Agent autonomy boundaries — limites de ação, escalação, lease durations."
		delegatedTo: {
			type: "external-system"
			ref:  "ext-agent-governance"
		}
		rationale: "Workaround de schema: #DelegationTarget não modela internal-governance-mechanism; usado external-system apenas para expressar delegado não-subdomain. Não implica sistema externo real. Agent governance é mecanismo interno (#AgentGovernanceEnvelope schema + agent-governance.cue files); não é subdomain (é meta-infraestrutura por agente). PLR não governa agentes; agent-governance envelopes governam — mecanismos disjuntos por construção."
	}, {
		responsibility: "Build-time validation de artefatos — quality criteria, structural checks, self-review enforcement."
		delegatedTo: {
			type: "external-system"
			ref:  "ext-quality-gate"
		}
		rationale: "Workaround de schema: #DelegationTarget não modela internal-governance-mechanism; usado external-system apenas para expressar delegado não-subdomain. Não implica sistema externo real. Quality-gate é mecanismo interno (governance/build-time/quality-gate.cue + structural-checks); não é subdomain (é meta-infraestrutura). PLR registra runtime policies; quality-gate valida build-time artifact authoring — fronteiras temporais disjuntas (runtime vs build-time per adr-040)."
	}]

	rationale: """
		Per adr-065: PLR existe para resolver UM gap concreto (regulatory
		L1 invioláveis sem identidade canônica) e PREPARAR base para 4
		gaps antecipatórios (cross-BC execution, sync, data consistency,
		distributed evaluation) — sem comprometer escolhas de
		implementação.

		Founder reframe explícito (sessão 2026-05-03): PLR como
		infraestrutura mínima que captura realidade, NÃO solução
		completa. Sanity test invariante: removível amanhã sem quebrar
		BCs. Schema enforcement: 'external' literal-locked materializa
		esse invariante via cue vet shape gate.

		Classification 'supporting-subdomain' reflete que PLR não é core
		operation; é meta-infraestrutura para coerência de policies.
		Não compete com BCs operacionais (cmt, fce, ctr, idc); complementa
		via identidade canônica.

		5 deferrals codificados como def-005..009 (per adr-062 deferred-
		decision system) capturam evolution paths futuros com triggers
		machine-evaluable + manual-review fallback.

		3 negativeBoundaries (2/4/5) usam external-system ref como
		workaround para mecanismos internos não-subdomain. Schema gap
		registrado em adr-065 known gaps; aguarda 2º caso similar para
		justify schema extension via novo ADR (per pattern adr-049/056/
		063/064 — kinds expand-when-needed).

		Lens consultada: lens-real-options. PLR registry-only preserva
		opções reais (engine, sync, evaluation, lifecycle) sem
		committment imediato. Cada deferral é strike condition explícita
		para exercise quando concrete demand materializar.
		"""
}
