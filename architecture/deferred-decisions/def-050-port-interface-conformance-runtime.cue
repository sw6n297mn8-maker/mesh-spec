package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def050: artifact_schemas.#DeferredDecision & {
	id:     "def-050"
	title:  "Conformancia interface-Kotlin <-> PortManifest: gerar a interface (preferido) vs gate de conformidade em runtime"
	date:   "2026-06-05"
	status: "open"

	description: """
		adr-144 governa o PortManifest como SoT spec-side da superficie de Port. Fica deferida a
		verificacao de que a interface Kotlin de cada Port (hand-authored em mesh-runtime, adr-141
		item 4/L3) conforma ao PortManifest. E cross-repo: o manifest vive em mesh-spec, a interface
		em mesh-runtime -- nenhum structural-check spec-side alcanca essa conformidade (c-puro,
		adr-144 N4).
		"""

	deferralRationale: """
		MOTIVO de deferir agora: a conformidade interface<->manifest nao e verificavel em mesh-spec
		(a interface Kotlin nao existe aqui). Ate este deferimento resolver, o carve-out de P1 fica
		review-trusted (ten-015): review humano + churn ~zero dos 5 Ports seguram a fidelidade.
		PREFERENCIA EXPLICITA (a substancia mora aqui, nao no adr-144): a resolucao preferida e GERAR
		a interface Kotlin a partir do PortManifest via codegen -- isso elimina a divergencia por
		construcao (P1 ao pe da letra), dissolve esta tensao e o carve-out de ten-015, e torna
		desnecessario qualquer gate de conformidade. Alternativa (se gerar nao se pagar): conviver
		com a interface hand-authored + um gate de conformidade materializado em mesh-runtime. Os
		dois desfechos ficam registrados; o preferido e gerar. Custo evitado: construir um emissor
		CUE->interface-Kotlin (ou um gate cross-repo) antes de haver evidencia de que se paga. Custo
		de continuar deferindo: a fidelidade interface<->manifest fica confiada a review, nao a
		maquina -- aceitavel enquanto o churn dos Ports for ~zero.
		"""

	triggerCalibrationRationale: """
		manual-review (nao machine-evaluable): a decisao depende de DOIS julgamentos qualitativos do
		founder, nenhum reduzivel a file-exists isolado. (i) Se/quando o pipeline CUE->Kotlin de
		contratos (ADR-C4-2.1c) amadurecer a ponto de absorver interfaces COMPORTAMENTAIS de Port a
		baixo custo -> executar a geracao (desfecho preferido). (ii) Se o churn dos 5 Ports subir --
		a aposta churn-~zero do adr-141 falsificada -> a conta vira a favor de gerar mesmo sem (i).
		Anchor cross-repo (interface em mesh-runtime) seria invisivel ao runner de mesh-spec,
		reforcando manual-review.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-144-manifest-artifact-governance.cue",
		"architecture/tension-log/ten-015-port-interface-handauthored-vs-p1.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-cutting"
		description: """
			low porque o churn ~zero dos 5 Ports + review humano (ten-015) seguram a fidelidade no
			interino, e o PortManifest ja e a SoT canonica (P0). cross-cutting porque os 5 Ports sao
			consumidos por todos os BCs quando o runtime materializar. Exit preferido: gerar a
			interface do manifest, eliminando a divergencia por construcao.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "Revisitar quando o pipeline CUE->Kotlin (ADR-C4-2.1c) absorver interfaces de Port a baixo custo (-> gerar, desfecho preferido), OU quando o churn dos 5 Ports subir (aposta churn-zero do adr-141 falsificada). Ate la, review-trusted (ten-015)."
	}]
}
