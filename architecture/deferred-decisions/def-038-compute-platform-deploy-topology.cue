package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def038: artifact_schemas.#DeferredDecision & {
	id:     "def-038"
	title:  "Compute platform + topologia FÍSICA de deploy (k8s/serverless/VMs; mapeamento módulo→runtime físico) deferida até o kernel"
	date:   "2026-06-03"
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
		Trigger adjacent-need file-exists em adr-141: a topologia física só faz sentido depois da
		lógica existir — quando adr-141 (kernel + topologia lógica módulo) é autorado, o mapeamento
		físico vira a próxima pergunta. Path conhecido (WI-103), machine-evaluable. medium (não low
		como def-037) porque deferir compute/deploy indefinidamente eventualmente bloqueia o deploy
		real do runtime — há custo cumulativo quando o golden-example sair do local para execução
		real, então o checkpoint no kernel é deliberado, não cosmético.
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
		kind: "adjacent-need"
		condition: {
			kind: "file-exists"
			path: "architecture/adrs/adr-141-runtime-kernel-port-contracts.cue"
		}
	}]
}
