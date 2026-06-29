package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def040: artifact_schemas.#DeferredDecision & {
	id:     "def-040"
	title:  "Stack de runtime HTTP (framework, IdP, ingress) deferida até o kernel (adr-141)"
	date:   "2026-06-28"
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
		Re-deferimento pós-triagem do backlog de defs disparados (adr-162, Camada 3). O trigger
		original (adjacent-need file-exists em architecture/adrs/adr-141-runtime-kernel-port-
		contracts.cue) ERA proxy-prematuro: disparou quando o kernel/Port contracts (adr-141)
		materializou, mas a decisão real — 1ª superfície que precisa expor ou consumir rede
		(framework HTTP/IdP/ingress) — só fica devida em evento de runtime que vive no mesh-runtime
		e NÃO tem sensor honesto no runner repo-local de mesh-spec. Substituído por manual-review
		(o evento real, founder revisita) + temporal 180d (backstop gateável; único kind além de
		file-exists que o gate V1 de adr-162 enforça; impede limbo, mesmo desenho do def-070). Data
		refrescada para 2026-06-28 para o backstop contar a partir de agora (idade 0, não re-dispara
		na hora); deferido ORIGINALMENTE em 2026-06-04 — proveniência preservada aqui porque
		#DeferredDecision tem campo `date` único, sem slot estruturado para "última revisão"
		(triggeredAt é proibido em status open).
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
		kind:   "manual-review"
		reason: "1ª superfície que precisa expor ou consumir rede (framework HTTP/IdP/ingress). Evento de runtime no mesh-runtime, invisível ao runner de mesh-spec — nenhum file-exists honesto neste repo o sinaliza."
	}, {
		kind:       "temporal"
		maxAgeDays: 180
	}]
}
