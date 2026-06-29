package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def038: artifact_schemas.#DeferredDecision & {
	id:     "def-038"
	title:  "Compute platform + topologia FÍSICA de deploy (k8s/serverless/VMs; mapeamento módulo→runtime físico) deferida até o kernel"
	date:   "2026-06-28"
	status: "open"

	description: """
		A W005 original decidiria compute & runtime (WI-103: k8s vs serverless vs VMs vs edge;
		deploy target) e a topologia física de containers (parte de WI-087). Per adr-139, a spec
		fixa a topologia LÓGICA (BC→módulo, em adr-141); fica deferida a topologia FÍSICA — como
		os módulos lógicos mapeiam para unidades de deploy reais, a plataforma de compute e o
		alvo de deploy. É a contraparte física do kernel lógico.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: a topologia lógica (módulos atrás dos Ports) é o que a spec
		precisa para o codegen + o golden-example; COMO esses módulos rodam fisicamente (pods
		k8s, funções serverless, VMs) é decisão de runtime/deploy, que vive no mesh-runtime (repo
		subordinado, fora de escopo — adr-138) e depende de vendor de compute ainda não escolhido.
		Decidir agora fixaria granularidade de deploy (1 pod por BC? por módulo? colocação?) antes
		de o golden-example provar o kernel — especulação de runtime sem o runtime. Custo evitado:
		inventar mapeamento físico + plataforma antes de haver kernel materializado e carga real.
		Custo de continuar: o kernel lógico não tem contraparte física — mitigado porque nenhum
		deploy real ocorre antes do golden-example, e a topologia lógica (adr-141) é suficiente
		para codegen e testes locais.
		"""

	triggerCalibrationRationale: """
		Re-deferimento pós-triagem do backlog de defs disparados (adr-162, Camada 3). O trigger
		original (adjacent-need file-exists em architecture/adrs/adr-141-runtime-kernel-port-
		contracts.cue) ERA proxy-prematuro: disparou quando o kernel lógico (adr-141) materializou,
		mas a decisão real — 1º workload runtime a precisar de deploy persistente fora de in-memory
		(compute + topologia física) — só fica devida em evento de infra/runtime que vive no
		mesh-runtime e NÃO tem sensor honesto no runner repo-local de mesh-spec. Substituído por
		manual-review (o evento real, founder revisita) + temporal 180d (backstop gateável; único
		kind além de file-exists que o gate V1 de adr-162 enforça; impede limbo, mesmo desenho do
		def-070). Data refrescada para 2026-06-28 para o backstop contar a partir de agora (idade 0,
		não re-dispara na hora); deferido ORIGINALMENTE em 2026-06-03 — proveniência preservada aqui
		porque #DeferredDecision tem campo `date` único, sem slot estruturado para "última revisão"
		(triggeredAt é proibido em status open).
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-139-stack-reconciliation-keystone-first.cue",
		"governance/wave-plan.cue",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-cutting"
		description: """
			O kernel lógico (adr-141) fica sem contraparte física até o checkpoint. medium porque,
			embora nenhum deploy real ocorra antes do golden-example, a decisão está no caminho
			crítico do runtime sair do local para execução real — deferir além disso tem custo
			cumulativo; cross-cutting porque plataforma de compute + granularidade de deploy afetam
			todos os módulos/BCs e a topologia inteira do runtime.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "1º workload runtime a precisar de deploy persistente fora de in-memory (compute + topologia física). Evento de infra/runtime no mesh-runtime; não há artefato no mesh-spec cuja existência o marque honestamente."
	}, {
		kind:       "temporal"
		maxAgeDays: 180
	}]
}
