package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// def-086 — Sucessor estreitado do def-068 (forma adr-159, executada
// pelo adr-194): a IDENTIDADE (tokens, tipografia, marca) foi DECIDIDA
// pela Constituição do Design System; fica deferido SOMENTE o lado
// tecnologia — vendor, component library, styling/tooling e a mecânica
// de promulgação dos valores no frontend-runtime.

def086: artifact_schemas.#DeferredDecision & {
	id:     "def-086"
	title:  "Vendor, component library e styling tooling do design system deferidos ao frontend-runtime"
	date:   "2026-08-14"
	status: "open"

	description: """
		Fica deferida a seleção de vendor de design system do frontend — component
		library, styling tooling e a MECÂNICA de promulgação (como os valores do
		token-contract viram tema, lint e build no mesh-frontend-runtime). A
		IDENTIDADE não está mais aqui: tokens, tipografia, marca e regime de mudança
		são LEI decidida na Constituição do Design System (architecture/design-system/,
		adr-194) — qualquer vendor escolhido OBEDECE ao token-contract; vendor que
		exigir mudar camada ou token constitution-bound é sinal de falsificação (a)
		do adr-194, não candidato.

		Input de partida (herdado do def-068; auditoria Mesh-Old 2026-07-03, sem
		decidir nada): shadcn/ui + Radix + Tailwind 4 red-teamed no Mesh-Old §2.9.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: a escolha de component library/styling tooling é
		TECNOLOGIA atrás da fronteira P2 (adr-157 dec 5 refinada pelo adr-194 dec 2) —
		decisão JIT do frontend-runtime quando a fatia de tela que a exercita chegar,
		agora com a lei que qualquer candidato deve obedecer (o token-contract) já
		promulgada. Cravar vendor no spec inverteria QUE/COMO (adr-158) e reabriria a
		classe de drift vendor-como-lei que o adr-150 eliminou. Custo de continuar
		deferindo: baixo e MENOR que no def-068 — as telas vivas (override FCE,
		jornada P2P) já renderizam sem design system formal, e a identidade que antes
		bloqueava ("antes de a marca estar definida") está decidida; só o vestido
		tecnológico espera.
		"""

	triggerCalibrationRationale: """
		Manual-review-only, herdado da lição def-060/def-068: a condição real de
		revisita — a fatia de tela do frontend-runtime adotar component library/
		styling tooling sob o token-contract — acontece em repo externo, invisível ao
		grep/runner do mesh-spec; não há sinal spec-local codificável.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-194-establish-design-system-constitution.cue",
		"architecture/deferred-decisions/def-068-frontend-design-system-vendor.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			low porque a lei da expressão (Constituição + token-contract) já governa
			qualquer tela construída à mão enquanto o vendor espera — o custo é
			retrabalho de estilização manual, não drift de identidade; cross-artifact
			porque o impacto se concentra na camada de apresentação do frontend
			(componentes a vestir nas telas existentes e futuras), não no runtime
			inteiro.
			"""
	}

	triggers: [{
		kind: "manual-review"
		reason: """
			A condição real de revisita — a fatia de tela escolher component library/
			styling tooling JIT no mesh-frontend-runtime, sob o token-contract da
			Constituição — não é machine-evaluable pelo runner do mesh-spec (repo
			externo, invisível ao grep; mesma lição de def-060/def-068).
			"""
	}]
}
