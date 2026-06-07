package tension_log

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ten015: artifact_schemas.#TensionEntry & {
	id:    "ten-015"
	date:  "2026-06-04"
	title: "Interface Kotlin de Port e hand-authored (projecao verificavel) vs P1 (codigo gerado)"

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
		VERIFICACAO da interface). A interface Kotlin e projecao hand-authored. A
		VERIFICACAO da conformancia manifest<->interface NAO e gate spec-side -- e deferida a def-050
		(mesh-runtime). O structural-check spec-side (manifest-conformance) cobre well-formedness do
		manifest (operations[].port subset de portsConsumed etc.), NAO a conformancia da interface
		Kotlin. Se divergirem, o manifest vence (precedencia); a deteccao automatica da divergencia
		so existe quando def-050 resolver a conformancia interface<->manifest (gerando a interface OU materializando gate em mesh-runtime).

		Alternativa rejeitada: gerar as 5 interfaces Kotlin de CUE agora. Rejeitada porque as 5
		interfaces sao ADR-gated e de churn ~zero -- a geracao seria custo prematuro (emissor canonico
		+ artefato gerado vivo a manter) sem ganho proporcional. A garantia de P1 (a interface nao
		pode divergir do manifest canonico) e mantida por review humano no interino e torna-se
		deterministica quando def-050 resolver a conformancia interface<->manifest (gerando a interface OU materializando gate em mesh-runtime) -- nao por check
		spec-side, que so cobre well-formedness.
		"""

	status: "accepted"

	structuralResolutionPath: """
		Resolucao estrutural plena: gerar as 5 interfaces Kotlin do PortManifest CUE, eliminando o
		hand-authoring -- deferida enquanto a superficie de Port for ADR-gated e de churn ~zero. Ate la,
		duas garantias distintas: (a) well-formedness do manifest e verificavel por maquina spec-side
		agora (manifest-conformance, materializado no arco adr-144); (b) a conformancia interface-Kotlin
		<-> manifest e REVIEW-TRUSTED ate def-050 resolve-la (gerando a interface OU materializando gate em mesh-runtime) -- nao e
		machine-verified em mesh-spec. O estreitamento de P1 fica verificavel por maquina so no eixo
		well-formedness; no eixo interface-conformance, confiado-em-review ate def-050.
		"""

	relatedADR: "adr-141"

	rationale: """
		status=accepted (nao resolved): o estreitamento e convivencia consciente, nao eliminacao da
		tensao -- P1 continua "blanket" na leitura ingenua, e este registro torna o carve-out explicito
		para leitores futuros. O structuralResolutionPath natural (gerar as interfaces de CUE, eliminando
		o hand-authoring) fica deferido enquanto a superficie de Port for ADR-gated e de churn ~zero. A
		mitigacao que mantem o estreitamento seguro tem tres camadas: (a) well-formedness do manifest
		verificada spec-side agora (manifest-conformance, arco adr-144); (b) conformancia interface-Kotlin
		<-> manifest deferida a def-050 (mesh-runtime); (c) review humano no interino. NAO se afirma
		machine-verification da conformancia de interface em mesh-spec -- so o eixo well-formedness e
		deterministico aqui.
		"""
}
