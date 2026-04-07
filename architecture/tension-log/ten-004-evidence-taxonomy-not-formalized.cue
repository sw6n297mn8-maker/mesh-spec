package tension_log

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ten004: artifact_schemas.#TensionEntry & {
	id:    "ten-004"
	date:  "2026-04-07"
	title: "Taxonomia canônica de evidência não formalizada bloqueia invariante de schema em sign-evidence"

	kind:          "cross-artifact-friction"
	tensionTarget: "P10"
	manifestsIn:   "contexts/idc/canvas.cue"

	description: """
		O canvas IDC declara invariante (3) do gate determinístico
		de sign-evidence: "evidência conforma com schema da
		taxonomia registrada para a classe declarada". Para que
		essa invariante seja verificável determinística é
		necessário um registro canônico de classes de evidência
		e seus schemas associados. Hoje esse registro não existe.
		As classes de evidência são provavelmente responsabilidade
		de LOG (BC que captura evidência), mas LOG não foi
		bootstrapado e não há decisão sobre se a taxonomia vive
		em LOG, em IDC ou em artefato compartilhado em domain/.
		Sem registro, a invariante (3) depende de configuração
		operacional não-auditável.
		"""

	resolution: """
		Manter a invariante (3) declarada no gate com tensão
		explícita sobre a dependência. Alternativa rejeitada:
		remover a invariante até taxonomia existir — rejeitada
		porque o gate ficaria manifestamente incompleto e a
		ausência de validação de schema permitiria assinaturas
		sobre evidência malformada. Trade-off aceito:
		conformidade da invariante depende de configuração
		operacional verificável pelo founder (lista de classes
		aceitas + schemas associados, mantida fora do canvas)
		até a taxonomia ser formalizada como artefato canônico.
		"""

	status: "accepted"

	structuralResolutionPath: """
		Decisão sobre ownership da taxonomia de evidência (LOG
		como owner natural, IDC como owner por proximidade
		criptográfica, ou artefato compartilhado em domain/) e
		criação do artefato canônico (e.g.,
		domain/evidence-taxonomy.cue ou contexts/log/taxonomy.cue).
		Decisão deve considerar se taxonomia é parte do
		ubiquitous language do domínio ou parte do contrato
		técnico de LOG/IDC.
		"""

	rationale: """
		Tensão registrada porque a invariante (3) referencia
		artefato que não existe. O risco de não registrar é
		que a invariante soe mais forte do que é, criando
		falsa confiança no gate. Registro torna a dependência
		explícita e direciona a ordem de bootstrapping dos
		próximos BCs.
		"""
}
