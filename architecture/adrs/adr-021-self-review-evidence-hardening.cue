package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr021: artifact_schemas.#ADR & {
	id:    "adr-021"
	title: "Self-review evidence hardening: single-round constraint and anti-generic criterion"
	date:  "2026-03-20"

	decisionClass: "structural"
	decider:       "founder"
	reversibility: "high"
	blastRadius:   "cross-cutting"

	context: """
		O self-review report permite que um agente declare status "stable"
		com roundsExecuted == 1 sem evidência estrutural de que houve
		revisão real. Adicionalmente, round summaries e finding rationales
		podem ser preenchidos com texto genérico que satisfaz formato sem
		demonstrar revisão substantiva. Essas duas lacunas compõem:
		single-round bypass (estabilização imediata sem justificativa) e
		compliance theater (texto genérico que passa critérios formais).
		Alternativas consideradas: (a) proibir roundsExecuted == 1
		universalmente — rejeitada: artefatos triviais legitimamente
		estabilizam em 1 round, proibir geraria rounds artificiais;
		(b) apenas critério procedural sem constraint estrutural —
		rejeitada: critério sozinho é dribável pelo mesmo mecanismo que
		pretende prevenir; (c) constraint estrutural + critério + CI —
		aceita: três camadas complementares com enforcement progressivo.
		"""

	decision: """
		Três mudanças coordenadas: (1) adicionar singleRoundRationale
		como campo em _#SelfReviewReportBase, obrigatório via união
		discriminada quando roundsExecuted == 1 e status == "stable" —
		constraint CUE compilável, não contornável por protocolo;
		(2) criar tq-srr-05 como critério type-specific que detecta
		round summaries e finding rationales genéricos via teste de
		substituição com ancoragem mínima a elemento concreto do artefato;
		(3) criar ci-sr-07 como check de CI que valida substantividade
		dos textos de evidência como segunda camada de enforcement.
		"""

	consequences: """
		Positivas: single-round stable passa a exigir evidência
		estrutural de revisão real; textos genéricos em evidence fields
		tornam-se detectáveis em duas camadas (protocolo + CI); custo
		de bypass sobe significativamente sem adicionar rounds
		artificiais. Negativas: agente gasta mais tokens justificando
		single-round stability (custo marginal aceitável vs. risco de
		bypass); ci-sr-07 exige implementação de heurística de
		genericidade no CI futuro.
		"""

	status: "accepted"

	affectedArtifacts: [
		"governance/build-time/self-review-report.cue",
		"governance/build-time/self-review-ci-policy.cue",
	]

	principlesApplied: ["P0", "P12"]

	rationale: """
		P0 exige que evidência de revisão tenha localização canônica e
		semântica real — singleRoundRationale é a forma estrutural.
		P12 exige enforcement progressivo — constraint CUE (compilação),
		tq-srr-05 (protocolo), ci-sr-07 (CI) são três camadas que se
		complementam. A decisão endurece o sistema existente sem alterar
		o motor de revisão, preparando o terreno para o modelo de
		sub-agente por round como evolução futura (ADR-022).
		"""
}
