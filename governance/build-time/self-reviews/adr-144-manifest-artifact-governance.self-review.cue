package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr144: build_time.#SelfReviewReport & {
	reportId: "srr-adr-144-manifest-artifact-governance"

	artifactPath:       "architecture/adrs/adr-144-manifest-artifact-governance.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-05"

	roundsExecuted: 2
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 2
		warnCount: 0
		infoCount: 1
		summary: """
			Round 1 (re-review isolado): pegou overclaim — adr-144 afirmava interface-conformance como
			gate spec-side. Corrigido para c-puro: spec-side cobre well-formedness (manifest-conformance)
			+ ref-integrity (manifest-ref-integrity); a conformancia interface-Kotlin<->manifest e
			cross-repo, deferida a def-050. Reenquadrou item 5 para 5 checks / 2 familias (3x
			local-field-reference-integrity + 2x cross-file-id-exists) e separou true-coverage (def-051) e
			existencia de cmd/evt/inv (def-052). 1 info: colisao de rotulo N3 (janela adr-141 vs negativa
			local).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 2 (re-review isolado conjunto do adr-144 reescrito + ten-015 neutralizado): LIMPO, 0
			fail. 7 verificacoes de coerencia cruzada PASS — def-050 neutro (preferencia por gerar mora no
			def, nao no ADR); framing 5-checks/2-familias sem residuo do antigo; defersTo [def-050/051/052]
			casa plannedOutputs (9); N-series N1-N6 contigua (N3 desambiguada); ten-015 conta a mesma
			historia (well-formedness machine spec-side / interface-conformance review-trusted ate def-050);
			affectedArtifacts (4) existem; item 2 coerente com item 5. OVERCLAIM CHECK robusto: nenhum campo
			afirma interface-conformance como gate spec-side. principlesApplied [P0,P1,P10,P12] ancorados.
			"""
	}]

	findings: {}

	summary: """
		adr-144 (PortManifest/AggregateManifest como ArtifactTypes governados; executa o O1-split do
		adr-141 item 5; fecha PARCIALMENTE a janela N3). Reescrito como texto unico apos o ciclo de
		emendas. 2 rounds de re-review isolado: round 1 pegou o overclaim de interface-conformance
		(corrigido para c-puro) e reenquadrou para 5 checks / 2 familias + 3 defs; round 2 (conjunto com
		ten-015) LIMPO. Gate deterministico spec-side agora; interface-conformance/true-coverage/
		existencia-de-ids deferidas a def-050/051/052.
		"""
}
