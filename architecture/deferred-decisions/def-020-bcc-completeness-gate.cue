package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def020: artifact_schemas.#DeferredDecision & {
	id:    "def-020"
	title: "Gate de completude bcc↔wave-plan/disco (BC completo per bounded-context-completeness)"
	date:  "2026-05-26"

	description: """
		Autorar um gate determinístico que reconcilie governance/bounded-context-
		completeness.cue (artefatos requeridos por BC) com o disco e/ou o wave-plan:
		para cada BC, os artefatos com presencePolicy=required (sob a condição
		aplicável do canvas) devem existir. Hoje a bcc exige ~7 tipos por BC
		(glossary, invariants, commands, events, state-model, agents, api/async-api
		conforme surfaces).
		"""

	deferralRationale: """
		MOTIVO: completude total dos BCs ainda é ROADMAP, não invariável atual. Os
		BCs materializaram apenas canvas/domain-model/glossary/agents; os demais
		artefatos exigidos pela bcc são planejados, não ausências em drift.
		RISCO de gatear cru agora: o gate viraria ALL-RED (todo BC reprovando por
		incompletude planejada), afogando o sinal real de drift no ruído de roadmap —
		o oposto do propósito de um gate. Mesmo padrão do events↔BC (def-019) e do
		bcc-completeness: gatear incompletude intencional pune a própria sequência que
		o spec declara explicitamente para depois.
		Custo de continuar deferindo: um BC que regrida (remover um artefato que
		DEVERIA existir) não é pego por este gate específico — mitigado porque os
		checks já existentes cobrem canvas/domain-model/glossary/agents quando
		requeridos, e o gate de órfão (adr-098) impede .cue ungoverned.
		"""

	triggerCalibrationRationale: """
		Trigger manual-review porque o gatilho é uma DECISÃO DE FASE, não uma
		condição machine-evaluable de arquivo: o gate passa a fazer sentido quando (a)
		houver decisão explícita de que BC completo (todos os artefatos bcc) é
		obrigatório, OU (b) o wave-plan declarar a materialização sistemática dos
		artefatos exigidos (e.g., uma wave que cria invariants/commands/events/
		state-model para os BCs). Nenhum kind de trigger expressa "fase X atingida";
		o founder revisita ao tomar essa decisão de fase. Não é preguiça — é que a
		precondição é estratégica, não um arquivo aparecendo.
		"""

	originatingArtifacts: [
		"governance/bounded-context-completeness.cue",
		"architecture/adrs/adr-090-derived-structure.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-cutting"
		description: """
			O gate de completude total de BC não existe enquanto a completude for
			roadmap. Custo baixo: a incompletude é intencional e sequenciada; os
			artefatos hoje presentes (canvas/domain-model/glossary/agents) já têm seus
			próprios checks quando requeridos, e o gate de órfão impede .cue ungoverned.
			Não-cumulativo no curto prazo.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "Gatilho é decisão de fase (BC completo passa a ser obrigatório) OU wave-plan declarar materialização sistemática dos artefatos bcc-exigidos — não machine-evaluable. Founder revisita nessa decisão e então autora o gate de completude (não-cru, com a base já materializada)."
	}]

	status: "open"
}
