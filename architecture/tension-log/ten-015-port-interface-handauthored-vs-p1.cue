package tension_log

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ten015: artifact_schemas.#TensionEntry & {
	id:    "ten-015"
	date:  "2026-06-04"
	title: "Interface Kotlin de Port e hand-authored (projecao verificada) vs P1 (codigo gerado)"

	kind:          "axiom-tension"
	tensionTarget: "P1"
	manifestsIn:   "architecture/adrs/adr-141-runtime-kernel-port-contracts.cue"

	description: """
		P1 declara "Codigo e gerado, nunca escrito manualmente, para tipos, validadores, stubs e
		projetores". adr-141 (decision item 4, L3) mantem a interface Kotlin de cada Port como
		artefato HAND-AUTHORED -- nao gerada de CUE -- contrariando a leitura literal de P1 para a
		superficie de interface do Port.
		"""

	resolution: """
		Estreitamento consciente de P1 (adr-141, L3): o PortManifest CUE e a localizacao canonica
		unica (P0) e a fonte de derivacao P1-conformante (tipos, validadores, stubs, tests, e a
		VERIFICACAO da interface). A interface Kotlin e projecao hand-authored, autorizada SOMENTE
		enquanto o structural-check sc-port-manifest-conformance provar conformidade
		manifest<->interface; se divergirem, o manifest vence.

		Alternativa rejeitada: gerar as 5 interfaces Kotlin de CUE agora. Rejeitada porque as 5
		interfaces sao ADR-gated e de churn ~zero -- a geracao seria custo prematuro (emissor canonico
		+ artefato gerado vivo a manter) sem ganho proporcional. O gate de conformidade preserva a
		garantia de P1 (a interface nao pode divergir do manifest canonico) sem pagar esse custo.
		"""

	status: "accepted"

	structuralResolutionPath: """
		Resolucao estrutural plena: gerar as 5 interfaces Kotlin do PortManifest CUE, eliminando o
		hand-authoring -- deferida enquanto a superficie de Port for ADR-gated e de churn ~zero. Ate la,
		o structural-check sc-port-manifest-conformance (materializado no arco adr-144) e o gate que
		prova conformidade manifest <-> interface a cada commit, tornando o estreitamento de P1
		verificavel por maquina, nao apenas confiado.
		"""

	relatedADR: "adr-141"

	rationale: """
		status=accepted (nao resolved): o estreitamento e convivencia consciente, nao eliminacao da
		tensao -- P1 continua "blanket" na leitura ingenua, e este registro torna o carve-out explicito
		para leitores futuros. O structuralResolutionPath natural (gerar as interfaces de CUE, eliminando
		o hand-authoring) fica deferido enquanto a superficie de Port for ADR-gated e de churn ~zero; o
		gate sc-port-manifest-conformance (a materializar no arco adr-144) e a mitigacao que mantem o
		estreitamento seguro ate la.
		"""
}
