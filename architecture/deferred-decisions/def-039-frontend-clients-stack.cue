package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def039: artifact_schemas.#DeferredDecision & {
	id:     "def-039"
	title:  "Stack de frontend/clients (web/mobile/design system) deferida até existir contrato HTTP/API"
	date:   "2026-06-03"
	status: "open"

	description: """
		A W005 original tinha um ADR de frontend/clients (WI-108: web SPA/SSR/MPA; mobile
		native/cross-platform; múltiplos frontends; design system). Per adr-139, frontend é
		runtime de cliente, não decisão de spec — e só é construível contra um contrato de API/HTTP
		que ainda não existe. Fica deferida a escolha de framework de frontend, estratégia mobile e
		design system.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: frontend consome contrato HTTP/API; o slice de contrato HTTP é
		justamente o que adr-140 (keystone codegen) produz — sem ele, escolher framework de frontend
		é decidir o cliente antes de o contrato existir. Frontend é, ademais, buy/generic em larga
		medida (theory-of-firm) e não toca P1 (codegen do core) nem os contratos de Port (P7). Custo
		evitado: escolher stack de UI + mobile + design system antes de haver superfície de API
		contra a qual construir, arriscando retrabalho quando o contrato HTTP materializar. Custo de
		continuar: a spec não declara cliente — mitigado porque nenhum cliente é construído antes do
		golden-example, e o contrato HTTP (adr-140) é o pré-requisito real, não a escolha de framework.
		"""

	triggerCalibrationRationale: """
		Trigger adjacent-need file-exists em adr-140 (codegen/contracts, que inclui o slice de
		contrato HTTP): quando o contrato HTTP existe, o frontend tem contra o que ser construído —
		checkpoint exato em que a decisão deixa de ser prematura. Path conhecido (assinado por adr-139
		a WI-102), machine-evaluable. low porque frontend não está no caminho crítico do golden-example
		(que é spec→contratos→aggregate→testes, sem UI).
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-139-stack-reconciliation-keystone-first.cue",
		"governance/wave-plan.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			A spec fica sem ADR de frontend até o contrato HTTP (adr-140) existir. low porque frontend
			é runtime de cliente fora do caminho crítico do golden-example; cross-artifact (não
			cross-cutting como def-037/038) porque o impacto se concentra na camada de
			cliente/apresentação e seu contrato com a API, não no runtime inteiro nem em todos os BCs.
			Reversível: escolha de framework/design system não muda spec nem contratos.
			"""
	}

	triggers: [{
		kind: "adjacent-need"
		condition: {
			kind: "file-exists"
			path: "architecture/adrs/adr-140-codegen-contracts.cue"
		}
	}]
}
