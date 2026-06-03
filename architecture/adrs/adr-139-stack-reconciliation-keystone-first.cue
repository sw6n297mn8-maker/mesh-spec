package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr139: artifact_schemas.#ADR & {
	id:    "adr-139"
	title: "Reconciliação do wave-plan de stack (W005): filtro spec×runtime + keystone-first (adr-140 codegen, adr-141 kernel/Ports)"

	date: "2026-06-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		adr-138 (N2) registrou que a decisão de stack mínima de W005 ainda não existe e que
		os ids de ADR planejados no wave-plan (099–105 para WI-102..108) já foram consumidos
		por ADRs de governança — apontando a reconciliação do wave-plan como trabalho
		SEPARADO. Este ADR é essa reconciliação.

		Dois problemas, não um. (a) COLISÃO de ids: WI-102..108 planejavam criar adr-099..105,
		ids já ocupados — o wave-plan está incoerente (planeja "create" em ids existentes).
		(b) DECOMPOSIÇÃO errada: a W005 original quebrava stack em 7 ADRs dimensão-a-dimensão
		(codegen, compute, persistence, eventing, boundaries, operability, frontend),
		front-loading escolhas de VENDOR/runtime que a spec não precisa fazer agora para
		validar P1 (codegen) nem definir os contratos de Port (P7).

		Escopo: este ADR é stack-PURO. A colisão de WI-085/adr-097 (estratégia de geração de
		C4) e o cleanup estrutural de C4 (output id adr-098 de WI-087, prose stale de WI-089)
		são reconciliação de W004/C4 SEPARADA, fora deste ADR.

		Alternativas rejeitadas: (a) só reassinar os ids (099–105 → livres) mantendo a
		decomposição de 7 dimensões — corrige a colisão mas preserva o front-loading de vendor
		que real-options (adr-138) manda evitar; (b) um único ADR de stack monolítico — vira
		god-ADR, acopla decisões independentes, contradiz P0/blast-radius; (c) decidir vendors
		agora (Kafka/k8s/etc.) — nega real-options e a fronteira P2 (vendor atrás de adapter),
		fixando lock-in antes do golden-example provar o pipeline.
		"""

	decision: """
		(1) FILTRO spec×runtime. A spec decide só o ESTÁVEL e ESTRUTURAL — o codegen path (P1)
		    e os contratos de Port (P7) — e DEFERE a seleção de vendor/runtime a
		    deferred-decisions governados (adr-062), materializados JIT quando o golden-example
		    (adr-138 W006.2) os exigir. Vendor não é decisão de spec; é decisão atrás de Port (P2).

		(2) KEYSTONE-FIRST. As 7 ADRs dimensão-a-dimensão são substituídas por 2 ADRs no
		    caminho crítico até o golden-example:
		    - adr-140 (WI-102) — codegen/contracts: CUE como SoT gera tipos/validadores/stubs
		      (P1), incluindo o slice de contrato HTTP (Money-string, payload via schema). O
		      runtime HTTP (framework, IdP, ingress) defere a def-040.
		    - adr-141 (WI-103) — runtime kernel / Port contracts: P7 concreto (5 Ports,
		      PortResult<T>, value classes na fronteira, module boundary) + topologia LÓGICA de
		      containers (BC→módulo), absorvendo o escopo lógico de WI-087. A seleção de vendor
		      por Port defere a def-041..045.

		(3) RECONCILIAÇÃO de ids no wave-plan + work-graph. Abandonar os ids planejados
		    adr-099..105 (colididos). Preservar só as âncoras WI-102 (→adr-140) e WI-103
		    (→adr-141). Remover WI-104..108 da W005 (dimensões absorvidas/deferidas:
		    persistence/eventing → per-Port def-041..045; boundaries → adr-140 + def-040;
		    operability → def-037; frontend → def-039). Estreitar WI-109 (coherence) para o
		    conjunto in-scope, dependendo só de WI-102/WI-103.

		(4) WI-087. A topologia LÓGICA de containers é absorvida por adr-141; a topologia
		    FÍSICA/de deploy defere a def-038. O cleanup estrutural de WI-087 (output id
		    adr-098, título) e a prose stale de WI-089 ficam para a reconciliação W004/C4
		    separada — não tratados aqui.

		(5) DEFERRALS criados agora (este commit): def-037 (operability runtime), def-038
		    (compute platform + topologia física de deploy), def-039 (frontend/clients). Os
		    deferrals def-040 (HTTP runtime) e def-041..045 (vendor por Port) são criados JIT
		    junto de adr-140/adr-141, não aqui.

		(6) adr-139 NÃO é WI. Reconcilia o plano (precedente adr-138, que também não virou WI);
		    entra como semanticPrerequisite de WI-102/WI-103 no wave-plan.
		"""

	consequences: """
		Positivas:
		(P1c) Desbloqueia o caminho crítico de adr-138 (W006.2): adr-140 (codegen) + adr-141
		      (Port contracts) são exatamente o que o golden-example CMT consome (WI-134), sem
		      esperar 7 ADRs de stack.
		(P2c) real-options preservado: nenhum vendor é fixado antes do golden-example provar o
		      pipeline; cada seleção de vendor vira deferred-decision com trigger de revisita
		      (def-037..045), atrás de Port (P2/P7).
		(P3c) wave-plan e work-graph voltam a ser coerentes (cue vet verde): zero ids
		      colididos, zero dependsOn órfã.

		Negativas / limitações:
		(N1) WI-089 (C4 L2) contém prosa stale derivada da decomposição anterior de W005. Ela
		     permanece intocada neste pacote porque a limpeza C4/W004 está fora do escopo do
		     adr-139 e exige reconciliação separada.
		(N2) A colisão de WI-085/adr-097 (estratégia de geração de C4) NÃO é resolvida aqui — é
		     reconciliação W004 separada.
		(N3) Os deferrals def-037/038/039 assumem que operability/compute-físico/frontend são
		     genuinamente deferíveis sem bloquear o golden-example; se o golden-example exigir
		     uma dessas decisões antes do previsto, o trigger correspondente dispara e o deferral
		     é revisitado (não silenciosamente ignorado).
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	falsificationCondition: {
		condition: """
			Esta reconciliação estará errada SE a decomposição keystone-first (adr-140 codegen +
			adr-141 kernel/Ports) for insuficiente para o golden-example — i.e., o golden-example
			CMT travar por falta de uma decisão de stack que NÃO cabe em adr-140 nem adr-141 e
			que NÃO é deferível como vendor atrás de Port — OU se um dos deferrals def-037/038/039
			disparar ANTES do golden-example completar (sinal de deferimento prematuro).
			"""
		observableSignal: """
			(1) Golden-example (W006.2) bloqueado por decisão de stack ausente fora de
			adr-140/adr-141 e não-deferível — registrada como pivot nos gates de adr-138.
			(2) Status de def-037, def-038 ou def-039 transiciona open→triggered antes de o
			golden-example CMT passar os gates de adr-138.
			"""
	}

	affectedArtifacts: [
		"governance/wave-plan.cue",
		"governance/build-time/work-graph.cue",
	]

	defersTo: ["def-037", "def-038", "def-039"]

	principlesApplied: ["P1", "P7", "P2", "P0"]

	supersedes: []

	rationale: """
		P1 (código gerado): adr-140 é o keystone de codegen — a spec decide o path
		CUE→tipos/validadores/stubs porque é isso que valida a hipótese central (adr-138); o
		resto de "stack" que não toca o codegen path não precisa ser decidido pela spec agora.

		P7 (5 Ports) + P2 (vendor atrás de adapter): a fronteira Port é o que a spec fixa
		(adr-141); QUAL vendor implementa cada Port é decisão de runtime, deferida atrás do Port
		(def-041..045). Por isso "filtro spec×runtime" não é conveniência — é P2/P7 aplicado ao
		plano: a spec não decide o que vive atrás do adapter.

		P0 (localização canônica única): a colisão adr-099..105 era duplicação de id por
		construção (dois artefatos disputando um id). Abandonar os ids planejados e reassinar
		adr-140/141 restaura unicidade.

		adr-062 (deferimento consciente): operability/compute-físico/frontend não são
		esquecimento — são deferrals com trade-off articulado e trigger de revisita
		(def-037/038/039), não prose 'known gaps'.

		Precedente adr-138: este ADR materializa o N2 de adr-138 (reconciliação do wave-plan
		flagada como trabalho separado) e herda seu enquadramento real-options (stack como
		hipótese falsificável; vendor decidido o mais tarde responsável).

		Escopo stack-puro: a separação C4/W004 (WI-085/adr-097, cleanup de WI-087/WI-089) é
		deliberada — manter adr-139 stack-puro evita reabrir a superfície C4 pela lateral.

		Tensão com axiomas: nenhuma.
		"""
}
