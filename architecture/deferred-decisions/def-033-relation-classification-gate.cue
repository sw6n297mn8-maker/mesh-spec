package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def033: artifact_schemas.#DeferredDecision & {
	id:     "def-033"
	title:  "Classificação de relação cross-BC gate-enforçada — structural-check de pattern/kind obrigatório (Ciclo 2 de feedback)"
	date:   "2026-05-30"
	status: "open"

	description: """
		Criar structural-check que FALHA quando uma aresta nova no context-map
		não tem upstreamPattern + downstreamPattern classificados (ou kind
		tipado, no caso de ciclo). Hoje a acyclicity é gate (sc-cm-07, reject),
		mas a CLASSIFICAÇÃO de cada relação exigida por P13 (cada aresta tem
		pattern/kind, não só direção) é apenas advisory — verificada no
		founder-gate do boundary-derivation. Uma aresta acíclica mal-classificada
		(sem pattern declarado) passa silenciosa pelo CI. Este check torna a
		parte determinística da classificação um gate, fechando o Ciclo 2 de
		consistência de fronteira (a parte gate-able que def-029 deixou para o
		advisory).
		"""

	deferralRationale: """
		HORIZONTE DE RESOLUÇÃO: diferido — junto da resolução de def-029
		(validation-prompt de derivação, hoje triggered, revisita em N≥4-5 OU
		2026-09-30). NÃO é iminente nem próximo: faz sentido materializar a
		parte gate (def-033) e a parte advisory (def-029) no mesmo movimento,
		porque são as duas metades do enforcement de derivação per adr-040
		(determinístico valida + advisory recomenda) e dividi-las em PRs
		separados fragmentaria a decisão.

		MOTIVO de deferir: (1) baixo custo cumulativo — as arestas existentes JÁ
		estão classificadas (os scaffolds fce/drc/scf preencheram pattern/kind
		em todas; sc-cm-07 garante a parte mais perigosa, ciclos); o gap só
		morde se uma aresta futura for adicionada SEM classificação, o que o
		founder-gate atual ainda pega; (2) acoplamento com def-029 — materializar
		junto evita dois PRs tocando o mesmo protocolo de derivação. Custo
		evitado: PR fragmentado de enforcement de derivação. Custo de continuar:
		a classificação depende de vigilância humana (founder-gate) em vez de
		gate determinístico — risco de aresta mal-classificada escapar quando o
		volume de scaffolds aumentar.
		"""

	triggerCalibrationRationale: """
		Trigger primário adjacent-need file-exists: dispara quando o
		validation-prompt de derivação de def-029 for materializado
		(architecture/validation-prompts/validate-bc-derivation.cue) — sinal de
		que o protocolo de derivação está sendo formalizado e a parte gate deve
		acompanhar. Refina def-029 (advisory) com a contraparte determinística:
		def-029 cobre a dimensão interpretativa (genuinidade de contorno,
		legitimidade de kind); def-033 cobre a dimensão mecânica (pattern/kind
		preenchido). adr-040 separa as duas camadas; resolvê-las juntas mantém a
		coerência. Sem trigger temporal porque o acoplamento é a def-029, não o
		calendário.
		"""

	originatingArtifacts: [
		"session:feedback-cycles-audit",
		"architecture/structural-checks/context-map.cue",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-artifact"
		description: """
			Sem o gate, a classificação de relação cross-BC depende do
			founder-gate manual no boundary-derivation; uma aresta acíclica sem
			pattern/kind classificado passa pelo CI silenciosamente. medium
			porque a acyclicity (o risco maior) já é gate e as arestas atuais
			estão classificadas; cross-artifact porque afeta context-map +
			canvas das pontas da aresta.
			"""
	}

	triggers: [{
		kind:      "adjacent-need"
		condition: {
			kind: "file-exists"
			path: "architecture/validation-prompts/validate-bc-derivation.cue"
		}
	}]
}
