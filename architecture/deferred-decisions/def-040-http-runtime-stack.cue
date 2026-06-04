package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def040: artifact_schemas.#DeferredDecision & {
	id:     "def-040"
	title:  "Stack de runtime HTTP (framework, IdP, ingress) deferida até o kernel (adr-141)"
	date:   "2026-06-04"
	status: "open"

	description: """
		adr-140 fixa o slice de contrato HTTP durável (Money como string decimal; payload via
		$ref a JSON Schema gerado de CUE), mas NÃO o runtime que serve esse contrato. Fica
		deferida a seleção do framework HTTP (servidor REST/HATEOAS, gRPC onde aplicável), do
		Identity Provider (IdP/OIDC) e do ingress/gateway — todos tooling de runtime atrás dos
		Ports (P2), não contrato de domínio.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: o runtime HTTP é seleção de vendor/runtime, não decisão de spec.
		adr-140 fixa o ESTÁVEL (o contrato: Money-string, payload-via-schema, P1); QUAL servidor,
		IdP e ingress servem esse contrato é decisão atrás do Port (P2) e do tipo buy/generic
		(adr-138), exercida pelo mesh-runtime. Fixar framework/IdP/ingress agora comprometeria
		vendor antes de existir runtime que os exercite — o lock-in prematuro que real-options
		(adr-138) manda evitar. Custo evitado: especular um stack HTTP (servidor + auth + ingress)
		antes de haver runtime a expor. Custo de continuar deferindo: a spec não declara runtime
		HTTP — mitigado porque o golden-example é spec→contratos→aggregate→testes, sem superfície
		HTTP (def-039), e o contrato (adr-140) já basta como âncora até o runtime materializar.
		"""

	triggerCalibrationRationale: """
		Trigger adjacent-need file-exists em adr-141 (kernel/Port contracts): quando o kernel e os
		5 Ports estão definidos, o runtime que os EXPÕE sobre HTTP vira decisão viva — mesmo
		checkpoint que def-037 usa para observability, pelo mesmo motivo (a camada que serve os
		Ports só faz sentido depois que os Ports existem). Path conhecido (assinado por adr-139 a
		WI-103), logo machine-evaluable — melhor calibrado que manual-review e que um anchor em
		artefato de mesh-runtime (não visível ao runner de mesh-spec). Não é fire forte (kernel
		existir ≠ runtime HTTP obrigatório), mas é o gatilho determinístico mais fiel ao momento
		em que a decisão deixa de ser prematura.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-140-codegen-contracts.cue",
		"governance/wave-plan.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-cutting"
		description: """
			A spec fica sem ADR de runtime HTTP até o kernel/runtime materializar. low porque o
			runtime HTTP é runtime puro — não bloqueia codegen (P1) nem os contratos de Port (P7),
			e o golden-example não expõe HTTP (def-039); cross-cutting porque, quando materializada,
			a camada de servidor/IdP/ingress é o ponto de entrada de TODOS os BCs sobre HTTP.
			Reversível: trocar framework/IdP/ingress é decisão de runtime atrás de Port, não muda spec.
			"""
	}

	triggers: [{
		kind: "adjacent-need"
		condition: {
			kind: "file-exists"
			path: "architecture/adrs/adr-141-runtime-kernel-port-contracts.cue"
		}
	}]
}
