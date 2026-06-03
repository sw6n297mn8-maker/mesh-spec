package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def037: artifact_schemas.#DeferredDecision & {
	id:     "def-037"
	title:  "Stack de operability runtime (backend de observabilidade + CI/CD + IaC) deferida até o kernel/golden-example"
	date:   "2026-06-03"
	status: "open"

	description: """
		A W005 original tinha um ADR de operability (WI-107: observability stack — backend
		OTel/Grafana/Datadog/Honeycomb; CI/CD platform; IaC). Per adr-139 (filtro spec×runtime),
		essa dimensão não é decisão de spec: é seleção de vendor/runtime atrás dos Ports (P2).
		Fica deferida a escolha do backend de telemetria, da plataforma de CI/CD e da ferramenta
		de IaC — instrumentação permanece convenção vendor-neutra (OTel) sem fixar backend.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: operability é runtime/ops, não spec. A spec valida P1 (codegen)
		e fixa os contratos de Port (P7, adr-141); observar/operar o runtime é decisão atrás do
		Port (P2) e do tipo buy/generic (theory-of-firm, adr-138) — escolher backend de
		telemetria, CI/CD e IaC agora fixaria vendor antes de existir runtime que os exercite,
		exatamente o lock-in prematuro que real-options (adr-138) manda evitar. Custo evitado:
		especular um stack de telemetria/CI/IaC antes de haver runtime a observar. Custo de
		continuar deferindo: a spec não declara backend de observabilidade — mitigado porque o
		mesh-runtime (repo subordinado) é quem opera, e OTel como convenção vendor-neutra basta
		até o backend ser escolhido.
		"""

	triggerCalibrationRationale: """
		Trigger adjacent-need file-exists em adr-141 (kernel/Port contracts): quando o kernel e
		os 5 Ports estão definidos, a observabilidade DESSE runtime (telemetria em torno dos
		Ports) vira decisão viva — checkpoint natural de revisita. Path conhecido (assinado por
		adr-139 a WI-103), logo machine-evaluable — melhor calibrado que manual-review (diferente
		de def-023, onde o id do ADR futuro era imprevisível). Não é fire forte (kernel existir ≠
		observability obrigatória), mas é o gatilho determinístico mais fiel ao momento em que a
		decisão deixa de ser prematura.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-139-stack-reconciliation-keystone-first.cue",
		"governance/wave-plan.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-cutting"
		description: """
			A spec fica sem ADR de operability até o kernel/golden-example. low porque
			observability é runtime puro — não bloqueia codegen (P1) nem os contratos de Port (P7),
			e OTel vendor-neutro instrumenta sem fixar backend; cross-cutting porque, quando
			materializada, a escolha toca a operação de todos os BCs no runtime. Reversível: trocar
			backend/CI/IaC é decisão de runtime atrás de convenção, não muda spec.
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
