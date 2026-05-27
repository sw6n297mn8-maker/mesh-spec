package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr112: artifact_schemas.#ADR & {
	id:    "adr-112"
	title: "Check cross-file cross-context-flow → context-map/subdomains (ownerContext/ownerSubdomain); reduz bucket M2 para 1"
	date:  "2026-05-26"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		O cross-context-flow (singleton de workflows cross-context) declara em cada
		phase um ownerContext (BC dono) e um ownerSubdomain (subdomínio dono) que
		devem existir nos registros canônicos: strategic/context-map.cue
		contexts[].context e strategic/subdomains/*.cue code. Era uma das 2 isenções
		cross-file restantes do M2 (adr-106/adr-111). A investigação mostrou que as
		duas âncoras estruturais (ownerContext/ownerSubdomain) são ref id-direta,
		born-green, autoráveis com o cross-file-id-exists (adr-102).

		cue vet valida o formato dos ids, não a existência cross-file do BC/subdomínio
		referenciado no mapa/registro global.
		"""

	decision: """
		(1) Autorar 2 checks (architecture/structural-checks/cross-context-flow.cue),
		born-warn, kind cross-file-id-exists:
		    - sc-ccf-01: phases[].ownerContext → context-map contexts[].context.
		    - sc-ccf-02: phases[].ownerSubdomain → subdomains/*.cue code.
		    Ambos verificados born-green (ownerContext bdg/cmt/dlv/fce/inv ∈ 25
		    contexts; ownerSubdomain ∈ 26 subdomain codes; todas resolvem).

		(2) Remover cross-context-flow do sc-meta-02.exemptTypes (agora coberto).
		Bucket cross-file do M2: 2 → 1 (resta apenas agent-spec).

		Escopo: guarda as âncoras ESTRUTURAIS do flow (phase→BC, phase→subdomínio).
		A dimensão integrationEvents (eventos trocados) NÃO é coberta — 3 dos 9 refs
		não resolvem hoje (built-BC incompleto: BudgetCommitted/CommitmentClosed; BC
		planejado: PaymentSettled→fce). Gatear cru afogaria sinal real em ruído de
		roadmap; deferida em def-021 (mesma natureza do def-019).

		FORA DE ESCOPO: promoção a reject (born-warn por ora); a dimensão
		integrationEvents (def-021); a isenção agent-spec restante.
		"""

	consequences: """
		Positivas: (1) phase.ownerContext/ownerSubdomain não podem mais apontar para
		BC/subdomínio fantasma — trava drift referencial das âncoras do flow; (2)
		reusa kind existente (sem inflar ontologia); (3) reduz o bucket cross-file do
		M2 de 2 para 1 (resta agent-spec), com cobertura real das duas âncoras
		estruturais.

		Negativas: (1) born-warn — não bloqueia até promoção; (2) a dimensão
		integrationEvents fica sem gate até os 3 events materializarem (def-021 —
		custo baixo: flow é singleton revisado; events são roadmap); (3) não cobre a
		direção reversa (todo BC/subdomínio aparece em algum flow).
		"""

	reversibility: "high"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"architecture/structural-checks/cross-context-flow.cue",
		"architecture/structural-checks/meta-coverage.cue",
		"architecture/deferred-decisions/def-021-cross-context-flow-integration-events.cue",
	]

	principlesApplied: [
		"P10 — gate determinístico: existência cross-file de ownerContext/ownerSubdomain é decidível e vira trava",
		"P0 — localização canônica: contexts vivem no context-map, subdomínios em subdomains/*.cue; o flow referencia, não duplica",
		"adr-102 — instância do cross-file-id-exists; adr-106/adr-111 — reduz o bucket de isenções do M2 com cobertura real",
		"adr-062 — a dimensão integrationEvents não-born-green é deferida conscientemente (def-021), não silenciada",
		"dp-07 — sem big-bang: born-warn, born-green; corta o flow na dimensão que resolve, defere a que não resolve",
	]

	defersTo: [
		"def-021",
	]

	rationale: """
		decisionClass structural: 2 instâncias de check + remoção de 1 isenção do M2
		+ 1 deferral governado — aplica P0/P10/adr-102/adr-106/adr-062 sem redefinir
		princípios. reversibility high (aditivo, born-warn); blastRadius repo-wide.

		Verificado antes da proposta: protótipo → ownerContext (bdg/cmt/dlv/fce/inv)
		todos ∈ 25 contexts; ownerSubdomain todos ∈ 26 subdomain codes; cue vet
		./... EXIT 0; runner --self-test PASS; runner default → sc-ccf-01/02 verdes
		(born-green), M2 descobertos = 0, bucket cross-file 2→1, 0 bloqueantes,
		exit 0. A dimensão integrationEvents (3 refs não resolvem) é explicitamente
		deferida (def-021), não gateada — evita born-red.
		"""
}
