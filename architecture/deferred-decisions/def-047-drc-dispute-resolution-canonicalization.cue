package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def047: artifact_schemas.#DeferredDecision & {
	id:     "def-047"
	title:  "Canonicalização de DisputeResolution no DRC quando ganhar domain-model"
	date:   "2026-06-03"
	status: "open"

	description: """
		O enum local {cancel | modify_terms | maintain} de #DisputeResolution no CMT é ACL consumer: a
		taxonomia é controlada pelo CMT como tradução do sinal de resolução de disputa do DRC. A
		canonicalização dessa taxonomia vive no DRC quando ele tiver domain-model; nesse momento o CMT
		migra de enum local para referência canônica do DRC (per adr-143, Caminho B).
		"""

	deferralRationale: """
		O DRC é hoje canvas-only (sem domain-model); scaffoldar o DRC junto com a Fatia B inflaria o
		escopo com um BC novo — exatamente o critério que separou a Fatia A da B. Custo evitado por
		deferir: scope creep (introduzir um BC inteiro numa fatia de orquestração intra-CMT). Custo de
		continuar deferindo: dívida pequena enquanto o DRC não amadurece — o enum local fechado cobre o
		caso de uso atual do CMT (cancel/modify_terms/maintain) sem perda de verificabilidade. A migração
		para a referência canônica é mecânica quando o DRC ganhar domain-model.
		"""

	triggerCalibrationRationale: """
		Trigger adjacent-need file-exists em contexts/drc/domain-model.cue: quando o DRC ganhar
		domain-model (sessão própria), a canonicalização de DisputeResolution entra junto — checkpoint
		natural de revisita. O path do DRC é conhecido e a condição é binária, logo machine-evaluable;
		file-exists é check trivial pelo runner. manual-review seria mais frouxo desnecessariamente.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-143-cmt-dispute-orchestration.cue",
		"session:fix-cmt-dispute-orchestration",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "local"
		description: """
			Enquanto o DRC não tem domain-model, o CMT opera com o enum local; o custo é apenas a
			duplicação conceitual da taxonomia (CMT-local vs futura DRC-canônica), localizada e
			mecanicamente reconciliável. Escopo restrito ao ACL do CMT.
			"""
	}

	triggers: [{
		kind: "adjacent-need"
		condition: {
			kind: "file-exists"
			path: "contexts/drc/domain-model.cue"
		}
	}]
}
