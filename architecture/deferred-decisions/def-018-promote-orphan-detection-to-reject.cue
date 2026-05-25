package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def018: artifact_schemas.#DeferredDecision & {
	id:    "def-018"
	title: "Promover detecção de órfãos de warn para reject"
	date:  "2026-05-24"

	description: """
		A classificação fileClassification (ativada por adr-090) detecta arquivos
		.cue em scope validado que não casam com nenhum schema (órfãos). Defere-se
		manter órfão na severidade atual (warn/info) em vez de promover para reject.
		A promoção fica condicionada à dupla condição: schemas fundacionais
		existentes E zero órfãos remanescentes.
		"""

	deferralRationale: """
		Promover órfão→reject agora bloquearia arquivos legítimos sem schema dentro
		do scope validado — design-principles.cue, shared-types/*, conventions/* —
		que ainda não têm artifact-schema correspondente. O custo evitado é falha de
		CI sobre arquivos corretos; o custo de continuar deferindo é que órfãos
		genuínos (e.g., conventions/api-spec-convention.cue) ficam apenas visíveis em
		warn, não bloqueados, até os fundacionais ganharem schema via ADRs follow-on
		separados (per adr-090). Promover antes seria um gate punindo a própria
		incompletude que adr-090 sequencia explicitamente para depois.
		"""

	triggerCalibrationRationale: """
		Os triggers file-exists sobre os schemas fundacionais são o sinal
		machine-evaluable de que a primeira condição foi satisfeita; na revisita o
		founder confirma a segunda (zero órfãos), porque nenhum kind de trigger
		disponível expressa 'fase reporta zero findings'. Os paths são PROVISÓRIOS —
		reconciliar com os nomes reais definidos nos ADRs follow-on que schematizam
		os fundacionais.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-090-derived-structure.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-cutting"
		description: """
			Órfãos permanecem visíveis em warn, não bloqueados. Custo baixo enquanto o
			conjunto de órfãos legítimos for conhecido e pequeno; não é cumulativo.
			"""
	}

	triggers: [
		{kind: "adjacent-need", condition: {kind: "file-exists", path: "architecture/artifact-schemas/design-principles.cue"}},
		{kind: "adjacent-need", condition: {kind: "file-exists", path: "architecture/artifact-schemas/shared-types.cue"}},
	]

	status: "open"
}
