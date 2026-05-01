package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

contextMapFlowPayloadFix: build_time.#SelfReviewReport & {
	reportId: "srr-context-map-flowpayload-fix"

	artifactPath:       "architecture/artifact-schemas/context-map.cue"
	artifactSchemaPath: "architecture/artifact-schemas/quality-criteria.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-01"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Fix mecânico em #FlowPayload (commit 6182566): substituiu disjunção 7-way sobre open structs por single struct com fields opcionais (events?/commands?/queries?, todos não-vazio quando presentes) + ... para embedding. Comentário acima de #FlowPayload reescrito documentando: (a) at-least-one constraint nunca foi funcional (CUE não colapsa disjunções abertas — produzia 'incomplete value' para TODAS instâncias indistintamente, bloqueando CI cue-validate consistentemente), (b) constraint movida para structural-check candidate sc-cm-XX (communication declarado ⇒ ≥1 flow não-vazio) — alinha com adr-040 (cross-field assertions = domínio determinístico, não shape-level), (c) asymmetry sem→sem permanece via #BaseRelationshipWithoutCommunication (events?/commands?/queries? = _|_). Comentário acima de #BaseRelationshipWithCommunication também atualizado refletindo o defer. Frame: 'Mecânica' per CLAUDE.md L131 (corrige sintaxe CUE de constraint broken-by-construction); sem ADR (constraint que nunca discriminou — agora deferida explicitamente). 12 instâncias de relationship em strategic/context-map.cue permanecem válidas sem alteração — verificado via cue vet ./... EXIT=0 (anteriormente EXIT=1 com 'incomplete value' spam)."
	}]

	findings: {}

	summary: """
		Fix mecânico de #FlowPayload em architecture/artifact-schemas/
		context-map.cue (commit 6182566): disjunção 7-way over open
		structs nunca foi funcional (CUE incomplete-value para todas
		instâncias indistintamente — CI cue-validate vermelho persistente).
		Substituída por single struct com fields opcionais; at-least-one
		constraint deferida a structural-check candidate sc-cm-XX por
		adr-040 separation. Single round porque o fix é estritamente
		mecânico, sem mudança semântica funcional (constraint inviável
		removida, não enforcement removido). cue vet ./... antes EXIT=1
		(spam de incomplete); depois EXIT=0 limpo.
		"""

	singleRoundRationale: """
		Fix é mecânico per CLAUDE.md L131 — não introduz semantic change
		porque a constraint at-least-one que parecia ser removida nunca
		foi enforced de fato (CUE limitation). Repros mínimos durante
		investigação confirmaram que disjunção 7-way over open structs é
		inviável independente de close()/_|_/discriminator (testado em
		/tmp/test*.cue durante diagnóstico). Round 1 verifica: (a) cue
		vet ./... agora passa EXIT=0 (anteriormente bloqueado por
		incomplete-value spam), (b) 12 instâncias de relationship em
		strategic/context-map.cue permanecem válidas, (c) #BaseRelation-
		shipWithoutCommunication continua bloqueando flows quando
		communication ausente (asymmetry preservada). Multiple rounds
		seriam fabricação — fix mecânico de 23-insert/31-delete em 1
		arquivo não justifica iteração de critérios; review founder do
		path (a) vs (ii) vs (iii) ocorreu durante diagnóstico (founder
		escolheu opção 'Mecânica' antes do write).
		"""
}
