package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def022: artifact_schemas.#DeferredDecision & {
	id:     "def-022"
	title:  "Consolidar envelope + Money inline em architecture/shared-schemas/ quando 2º BC do slice precisar"
	date:   "2026-05-28"
	status: "open"

	description: """
		WI-129 autora contexts/cmt/schemas/events.cue com envelope (CloudEvents-like
		subset: id, source, type, specversion, time, dataschema) e tipo Money (amount,
		currency) inline e locais ao CMT. Quando o 2º BC do slice (DLV, via WI-130)
		autorar contexts/dlv/schemas/events.cue, é esperada a mesma estrutura — sinal
		real de repetição. A consolidação em architecture/shared-schemas/envelope.cue
		+ money.cue elimina a duplicação e cumpre P0/Zero Duplicação. Adiar até o 2º
		consumidor evita generalização prematura sem validação por uso real.
		"""

	deferralRationale: """
		MOTIVO: o 1º BC sozinho não justifica abstrair envelope/Money em shared-schemas
		— risco de abstração prematura sem validação. O 2º BC do slice é o sinal real
		de repetição. Adiar até DLV permite que o shape seja validado por DOIS usos
		concretos antes da generalização — reduz o risco de exigir refactor cross-BC.
		RISCO de gatear agora: shape generalizado prematuramente pode não servir DLV
		(campos faltantes ou superdimensionados). Custo de deferir: 1 duplicação local
		em CMT, reversível mecanicamente (extrair os structs pra shared-schemas + trocar
		definições inline por imports). O envelope é declarado como subset CloudEvents-
		inspired, não como conformidade ao CloudEvents 1.0 — adoção formal CloudEvents
		é decisão separada, fora do escopo deste deferimento.
		"""

	triggerCalibrationRationale: """
		Trigger adjacent-need com file-exists em contexts/dlv/schemas/events.cue: a
		precondição é a materialização do 2º consumidor (DLV). Quando o arquivo for
		criado (output da WI-130), o runner determinístico (evaluate-deferred-triggers.sh)
		dispara annotation no PR pro founder comparar o envelope/Money em DLV com o do
		CMT e decidir consolidar. Não é manual-review porque a condição é machine-
		evaluable (presença de path no filesystem).
		"""

	originatingArtifacts: [
		"governance/build-time/task-specs/wi-129.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "local"
		description: """
			Envelope (~10 linhas) e Money (~5 linhas) duplicados em até 1 BC (CMT)
			enquanto não há 2º consumidor. Reversível mecanicamente: extrair pra
			shared-schemas/ + trocar inline por imports. Não-cumulativo enquanto for
			1 BC só; cumulatividade só começa quando DLV materializar (e é exatamente
			esse o trigger de revisita).
			"""
	}

	triggers: [{
		kind: "adjacent-need"
		condition: {
			kind: "file-exists"
			path: "contexts/dlv/schemas/events.cue"
		}
	}]
}
