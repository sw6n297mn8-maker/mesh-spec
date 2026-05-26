package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr093: artifact_schemas.#ADR & {
	id:    "adr-093"
	title: "Schematizar design-principles (fundacional) — passo i do cutover adr-090"
	date:  "2026-05-25"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		adr-090 (estrutura derivada) sequenciou como passo (i) do cutover:
		schematizar os fundacionais sem _schema.location (design-principles,
		shared-types) via ADRs follow-on SEPARADOS, ANTES de construir o gerador
		do índice derivado. Motivo: sem schema, esses arquivos aparecem como
		órfãos (unmatched) na classificação type-centric e não podem ser
		representados no índice derivado; promover órfão->reject antes de
		schematizá-los bloquearia arquivos legítimos (governado por def-018).

		architecture/design-principles.cue já é bem-estruturado (define
		#DesignPrinciple/#PrincipleGroup inline + um mapa principles P0-P12), mas
		define seus tipos localmente e NÃO declara _schema.location — por isso
		vive na zona órfã.

		Alternativa considerada e REJEITADA: deixar como órfão e tolerar via
		warn/INFO indefinidamente. Reprovada porque adiar a schematização trava o
		cutover do adr-090 (o índice derivado nasceria incompleto) e mantém um
		fundacional fora do contrato type-centric. A alternativa de derivação-com-
		gate sem schema já foi rejeitada no próprio adr-090.
		"""

	decision: """
		Criar architecture/artifact-schemas/design-principles.cue declarando
		#DesignPrinciples (singleton) com _schema.location
		(^architecture/design-principles\\.cue$, cardinality singleton) +
		_qualityCriteria estruturais mínimos, e mover para lá os tipos de suporte
		#DesignPrinciple/#PrincipleGroup.

		Refactor CONTENT-PRESERVING de architecture/design-principles.cue: passa a
		importar e conformar ao schema; o campo top-level muda de `principles` para
		`designPrinciples` (espelha domain-definition). O conteúdo dos 13
		princípios (statements + rationales) permanece BYTE-A-BYTE inalterado —
		esta decisão NÃO reabre nem reavalia o mérito de nenhum princípio.

		Escopo deliberadamente mínimo: shape + location + critérios estruturais. A
		semântica dos princípios fica fora.
		"""

	consequences: """
		Positivas: (1) design-principles.cue sai da zona órfã (unmatched) e passa a
		ser matched pelo seu próprio schema — desbloqueia sua representação no
		índice derivado do adr-090; (2) arma um dos dois triggers do def-018
		(file-exists architecture/artifact-schemas/design-principles.cue); (3)
		referência estável por id preservada para consumidores (adr.principlesApplied).

		Negativas: (1) renomeia o campo top-level da instância (principles ->
		designPrinciples) — verificado que nenhum consumidor CUE importa o pacote
		design_principles, e os ids P0-P12 são citados como string, não afetados;
		(2) é apenas o primeiro de dois fundacionais — shared-types segue em ADR
		análogo.
		"""

	reversibility: "medium"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/design-principles.cue",
	]
	plannedOutputs: [
		"architecture/artifact-schemas/design-principles.cue",
	]

	defersTo: []
	principlesApplied: ["P0 — localização canônica única por unidade de conhecimento", "P12 — governança como código"]

	rationale: """
		Materializa o passo (i) do cutover sequenciado em adr-090, para o primeiro
		fundacional. P0 é central: schematizar dá ao design-principles uma
		localização canônica governada (em vez de tipos inline sem location),
		alinhando-o ao contrato type-centric. P12: o schema vira gate de CI
		(cue vet + classificação). decisionClass structural (cria tipo + altera
		superfície de validação); reversibility medium (reverter exige desfazer o
		refactor da instância); blastRadius cross-artifact (schema + instância).
		Sem defersTo: o trigger de promoção órfão->reject já é governado por
		def-018, que esta decisão apenas arma parcialmente.
		"""
}
