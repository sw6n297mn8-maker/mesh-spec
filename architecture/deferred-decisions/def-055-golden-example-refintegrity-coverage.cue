package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def055: artifact_schemas.#DeferredDecision & {
	id:     "def-055"
	title:  "Cobertura de ref-integrity do #GoldenExample: harness de codegen-validation (preferido) vs structural-check estatico"
	date:   "2026-06-08"
	status: "resolved"

	// Resolucao (2026-06-11, founder): o exit preferido realizou-se. O trigger
	// adjacent-need (file-exists em scripts/ci/validate-codegen.sh) disparou na
	// materializacao do harness (WI-137, commit 6caa446) e o run-001 do
	// golden-example (toolchain mesh-runtime; evidencia atualizada em #126,
	// commit ba26b0e) EXERCITOU os refs do specSlice/assertionRefs ao
	// gerar+compilar+testar (gate CONTINUAR, 17/17) — a cobertura de
	// ref-integrity prevista pelo deferimento foi realizada pela mecanica mais
	// forte, tornando o check estatico redundante como antecipado.
	triggeredAt: "2026-06-09"
	triggeredCondition: """
		scripts/ci/validate-codegen.sh criado por WI-137 (commit 6caa446) — condicao
		machine-evaluable do trigger adjacent-need (file-exists).
		"""
	resolvedBy: "governance/build-time/codegen-validation-evidence.cue"

	description: """
		adr-145 governa #GoldenExample como ArtifactType (declaracao-pura). Fica deferida a cobertura de
		ref-integrity do specSlice/assertionRefs das instancias de golden-example -- isenta em sc-meta-02
		exemptTypes (categoria harness). Hoje golden-example e tipo-governado SEM structural-check de
		ref-integrity e SEM o harness que deveria cobri-la (scripts/ci/validate-codegen.sh, output de WI-137,
		ainda nao materializado).
		"""

	deferralRationale: """
		MOTIVO de deferir agora: a cobertura prevista e o harness de codegen-validation (WI-137), que EXERCITA
		os refs do specSlice/assertionRefs ao tentar gerar codigo -- validacao mais forte que um ref-exists
		estatico. Um structural-check estatico seria REDUNDANTE com esse harness. NAO e inexpressibilidade
		(distinto de def-051/052, que aguardavam um kind inexistente): o check e expressavel, mas duplicaria uma
		mecanica mais forte. POReM o harness e CONTINGENTE: adr-138 admite que WI-137 PIVOTE ou ABANDONE (gates
		item 7). Custo evitado: construir um check estatico que o harness tornaria redundante. Custo de continuar
		deferindo: se WI-137 abandonar, golden-example fica tipo-governado sem cobertura de ref-integrity --
		mitigado no interino por review (P10) e pelo numero baixo de instancias (<=1, a do CMT).
		"""

	triggerCalibrationRationale: """
		Dois triggers para os dois desfechos de WI-137. (1) adjacent-need file-exists em
		scripts/ci/validate-codegen.sh: dispara quando o harness materializa -> revisitar para confirmar que ele
		exercita a ref-integrity e resolver def-055 (cobertura realizada). (2) manual-review: o desfecho ABANDONAR
		de WI-137 e a ausencia persistente do harness nao sao um file-exists positivo -- exigem julgamento do
		founder sobre o experimento (criar check estatico OU remover golden-example do enum). A combinacao cobre
		entrega (maquina) e abandono (humano).
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-145-golden-example-artifact-governance.cue",
		"architecture/artifact-schemas/golden-example.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			low porque a ref-integrity fica review-trusted (P10) no interino, ha <=1 instancia (a do CMT em
			WI-137), e o harness deve materializar cobrindo-a. cross-artifact porque o specSlice/assertionRefs de
			um golden-example aponta para invariants/commands/events/aggregates/assertions de outros artefatos --
			ref pendurada cruzaria fronteira de artefato sem gate. Exit preferido: o harness de WI-137 realiza a cobertura.
			"""
	}

	triggers: [{
		kind: "adjacent-need"
		condition: {kind: "file-exists", path: "scripts/ci/validate-codegen.sh"}
	}, {
		kind:   "manual-review"
		reason: "Desfecho ABANDONAR/PIVOTAR de WI-137 (adr-138 item 7) deixa golden-example tipo-governado sem cobertura de ref-integrity e sem harness -- reavaliar (criar check estatico OU remover golden-example do enum) exige julgamento do founder sobre o experimento; a ausencia persistente do harness nao e um file-exists positivo, dai manual."
	}]
}
