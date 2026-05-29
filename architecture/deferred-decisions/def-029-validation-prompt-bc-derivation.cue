package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def029: artifact_schemas.#DeferredDecision & {
	id:     "def-029"
	title:  "Validation-prompt advisory para revisão de derivação de BC (testes de separação + classificação + descoberta de kind)"
	date:   "2026-05-29"
	status: "open"

	description: """
		P13 (adr-125) introduz testes de separação (linguagem ubíqua +
		invariante + ownership + teste de remoção), ordem de classificação de
		relação cross-BC e protocolo de descoberta de kind. A parte dura (ciclo
		= defeito por default) já é enforced por sc-cm-07 (reject). A parte
		interpretativa — qualidade dos testes de separação, legitimidade de um
		kind novo, agência/signal-vs-state/invariante — NÃO é gate-able
		deterministicamente (P10 + adr-040). Este deferimento cobre a criação de
		um validation-prompt advisory (architecture/validation-prompts/
		validate-bc-derivation.cue ou similar) que produza design review por
		agente em sessão isolada sobre derivações de BC. Gate determinístico só
		se volume justificar.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: (1) o validation-prompt deve ser calibrado
		contra derivações reais — não há scaffold de BC novo em curso (11
		materializados; 14 pendentes sem WI ativo), então construir o prompt
		antes de exercitar P13 em casos concretos arrisca um artefato advisory
		mal-calibrado; (2) a parte dura da derivação (acyclicity) já tem gate
		(sc-cm-07), então o gap atual é advisory-only, de baixo custo cumulativo;
		(3) o conteúdo do prompt (como avaliar genuinidade de contorno e
		legitimidade de kind) é exatamente o tipo de critério interpretativo que
		ganha qualidade com exemplos acumulados. Custo evitado: autoria
		especulativa de prompt. Custo de continuar: derivações dos próximos BCs
		passam sem design review advisory dedicado (mitigado por self-review +
		founder review).
		"""

	triggerCalibrationRationale: """
		Trigger primário manual-review: a decisão de QUANDO o prompt advisory
		vale a pena é interpretativa (depende de ter ao menos uma derivação real
		para calibrar e de o founder julgar o ganho marginal sobre self-review +
		founder review). Não machine-evaluable.

		Trigger secundário recurrence (scope filename, pattern de canvas,
		threshold 13) em vez de adjacent-need: o schema de adjacent-need
		(file-exists/file-contains) não expressa "ao menos N canvases de BC
		scaffolded"; recurrence scope=filename contando contexts/<bc>/canvas.cue
		é o encoding machine-evaluable correto do sinal "futuros scaffolds
		acumulam pressão por design review dedicado". Threshold 13 = 11 canvases
		atuais + 2: não dispara agora (11 < 13) e dispara após 2 novos scaffolds,
		momento em que P13 terá sido exercitado o suficiente para calibrar o
		prompt. Acoplamento trigger↔realidade preservado (evita trigger
		silencioso).
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-125-derivation-of-bounded-contexts.cue",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-artifact"
		description: """
			Sem o validation-prompt, derivações de BC dos próximos scaffolds não
			recebem design review advisory dedicado às dimensões interpretativas
			de P13 (genuinidade de contorno, legitimidade de kind). severity
			medium: o gap é advisory, coberto parcialmente por self-review +
			founder review, mas acumula com cada scaffold sem revisão estruturada.
			blastRadius cross-artifact: afeta canvas + context-map de cada BC
			derivado.
			"""
	}

	triggers: [{
		kind: "manual-review"
		reason: """
			Decisão de criar o validation-prompt depende de ao menos uma
			derivação real para calibrar critérios interpretativos e de
			julgamento do founder sobre ganho marginal vs self-review. Não
			machine-evaluable.
			"""
	}, {
		kind:      "recurrence"
		pattern:   "contexts/[a-z0-9-]+/canvas\\.cue$"
		scope:     "filename"
		threshold: 13
	}]
}
