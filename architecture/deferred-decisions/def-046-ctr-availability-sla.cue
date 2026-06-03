package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def046: artifact_schemas.#DeferredDecision & {
	id:     "def-046"
	title:  "Definir SLA numérico de indisponibilidade do CTR para o fail-closed do CMT"
	date:   "2026-06-03"
	status: "open"

	description: """
		Fixar o SLA numérico de indisponibilidade do CTR — o limite de tempo de resposta de
		QueryContractTerms no ProposeCommitment acima do qual o CTR é considerado indisponível e o
		ProposeCommitment é rejeitado (fail-closed, per adr-142 decisão 5). O fail-mode já está
		decidido; só o valor numérico do threshold é deferido.
		"""

	deferralRationale: """
		O fail-mode fail-closed é decisão segura já tomada (adr-142): sem lastro contratual
		verificável, nenhum compromisso é criado. O que falta — o threshold numérico — não pode ser
		calibrado responsavelmente agora porque exige a distribuição real de latência do
		QueryContractTerms em produção, inexistente na Phase 0 (sem runtime). Fixar um número
		arbitrário criaria um falso gate: rejeita demais (fricção quando o CTR só está lento) ou tarde
		demais (timeout longo que não protege). O custo evitado por deferir é não comprometer a spec a
		um número que a primeira calibração de produção contradiria; no lugar, o runtime usa um default
		conservador de implementação até haver telemetria. Continuar deferindo só custa enquanto o
		golden-example não exercita o caminho CTR real — e o golden-example usa adapter-stub, logo não
		pressiona este número.
		"""

	triggerCalibrationRationale: """
		manual-review é o único trigger viável porque a condição de revisita ("existe telemetria de
		latência do CTR em produção") não é machine-evaluable a partir de mesh-spec: nenhum artefato da
		spec muda quando dados de produção passam a existir (o runtime vive em mesh-runtime, fora de
		escopo). recurrence/volume-threshold/temporal não se aplicam — não há pattern recorrente,
		contagem de tipo, nem calendário que sinalize maturidade de telemetria. Por isso a calibração
		do SLA permanece decisão do founder ao ler a telemetria, não automação.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-142-cmt-bilateral-acceptance-contract.cue",
		"session:fix-cmt-bd-mutual-acceptance",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "local"
		description: """
			Enquanto o threshold não é fixado, o CMT opera fail-closed sob um default de implementação
			conservador; o custo é apenas a ausência de um número calibrado na spec — não bloqueia o
			golden-example (que usa adapter-stub do CTR) nem outros BCs. Escopo restrito ao gate de
			ProposeCommitment do CMT.
			"""
	}

	triggers: [{
		kind: "manual-review"
		reason: """
			A revisita exige a distribuição real de latência de QueryContractTerms em produção; na
			Phase 0 não há runtime nem telemetria, e nenhum artefato de mesh-spec sinaliza
			machine-evaluable a existência desses dados (mesh-runtime é repo subordinado, fora de
			escopo). Founder revisita quando houver telemetria de latência do CTR.
			"""
	}]
}
