package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr172ParticipantRolesArePositional: build_time.#SelfReviewReport & {
	reportId: "srr-adr-172-participant-roles-are-positional"

	artifactPath:       "architecture/adrs/adr-172-participant-roles-are-positional.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-12"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — review por sub-agente ISOLADO (sem histórico; inputContract
			do quality-gate). ZERO findings em uq-01..08 + tq-adr-01..04.
			Verificações de disco do sub-agente: npm registra a organização SEM
			campo de papel (fields do agg-participant conferidos um a um); a ACL
			npm→ssc traduz para newEligibility com o enum exato
			'eligible-for-sourcing | provisionally-qualified | suspended |
			revoked'; participantType no canvas do npm ocorre APENAS dentro de
			incentiveAnalysis.participants (5 ocorrências); SupplierRefList
			presente em ssc e p2p; P0/P10/dp-08/def-076 resolvem; a story
			ds-buyer-procurement-journey existe e o passo do gestor/alçada é
			exatamente o passo 9 (contado). TRÊS observações não-finding:
			(a) context citava "campo 'originadora'" — o campo real é
			requestedBy (a description dele é 'Originadora — área/função que
			solicitou demanda'); (b) 'gestor' atribuído ao glossário p2p — o
			glossário absorve requisitante/comprador; gestor aparece na story;
			(c) affectedArtifacts de canonização listam arquivos não-editados —
			defensável (a decisão amarra normativamente cada um), divergência da
			letra do schema anotada.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 2 — precisões (a) e (b) aplicadas no texto do ADR: anchor
			corrigido para 'campo requestedBy' com a description literal; item 5
			reescrito distinguindo requisitante/comprador (glossário p2p) de
			gestor-aprovador (story, passo 9, sem termo de glossário).
			Observação (c) mantida como está com a justificativa do próprio
			review (ADR de canonização amarra normativamente os arquivos
			listados; nenhum foi editado por ESTA decisão — as edições da fatia
			pertencem ao adr-173). cue vet EXIT=0 pós-edições.
			"""
	}]

	findings: {}

	summary: """
		adr-172 (papéis posicionais): review ISOLADO com zero findings — todas
		as alegações reproduzidas no disco (npm sem papel; ACL como projeção de
		elegibilidade; participantType só em incentiveAnalysis). Duas precisões
		editoriais do round 2 (anchor requestedBy; atribuição de gestor à
		story). VEREDITO: stable.
		"""
}
