package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr090DerivedStructure: build_time.#SelfReviewReport & {
	reportId: "srr-adr-090-derived-structure"

	artifactPath:       "architecture/adrs/adr-090-derived-structure.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-25"

	roundsExecuted: 3
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 3
		infoCount: 1
		summary: """
			Pass inicial de red-team sobre a decisao de estrutura derivada
			(config.cue deixa de autorar fatos estruturais; estrutura
			DERIVADA de _schema.location + scan do filesystem). Tres riscos
			de desenho levantados em nivel warn (decisao soa, mas a
			materializacao precisava de calibracao):

			(a) config-path-existence proposto como gate PERMANENTE —
			simulado e reprovado: inunda de falso-positivo porque config.cue
			e aspiracional, e nao pega phantoms sem-schema. Recomendado
			rebaixar para ferramenta TRANSITORIA de cutover, descomissionada
			apos a virada.

			(b) titulo embutia o codigo de principio "P0" — vazamento de
			jargao de principio para o titulo do ADR; recomendado titulo
			descritivo ("eliminar duplicacao config-schemas que causa
			map-drift").

			(c) orfao->reject se promovido imediatamente bloquearia arquivos
			legitimos sem schema dentro do scope validado (design-principles,
			shared-types). Recomendado condicionar a promocao e extrair para
			deferred-decision separada.

			Info (1): agent-governance.cue global ausente — surface correto
			da derivacao, mas sequenciado para fora desta decisao.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 3
		infoCount: 0
		summary: """
			Segundo pass apos incorporar os achados do primeiro. Foco na
			coerencia entre adr-090 e os artefatos companheiros:

			(a) def-018: os triggers de revisita precisam ser
			machine-evaluable (file-exists sobre os schemas fundacionais),
			nao "fase reporta zero findings" — nenhum kind de trigger
			disponivel expressa essa condicao; a segunda condicao (zero
			orfaos) fica como confirmacao do founder na revisita.

			(b) D2/D3 (universal-glossary.cue, business-model.cue):
			declarados-e-ausentes; tratamento dead-by-default (removidos do
			config autoral) salvo evidencia explicita no wave-plan.

			(c) verificacao dos campos do #ADR contra adr.cue:
			derivedArtifacts, plannedOutputs, defersTo e o enum de status
			("accepted") conferidos contra o schema; decisionClass
			"structural" (nao foundational) confirmado.
			"""
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Terceiro pass de convergencia. Os 6 ajustes do founder integrados
			no artefato final: (1) titulo sem "P0"; (2) config-path-existence
			apenas transitorio; (3) campos derivedArtifacts/defersTo/status
			verificados contra schema; (4) orfao->reject so apos schematizar
			fundacionais (governado por def-018); (5) D2/D3 dead-by-default;
			(6) schematizacao dos fundacionais e agent-governance global
			sequenciados como ADRs follow-on separados. Sem findings
			remanescentes fail/warn; affectedArtifacts aponta para paths
			reais (repo-structure.cue, readme/config.cue,
			artifact-schemas/structural-check.cue). Decisao estabilizada e
			aprovada pelo founder.
			"""
	}]

	findings: {}

	summary: """
		adr-090 (estrutura derivada) revisado em 3 passes de red-team antes
		da materializacao, per direcao do founder ("rode um ciclo + repita 2
		vezes"). A causa-raiz tratada e a duplicacao config-schemas (P0) que
		gera map-drift: derivar a estrutura de _schema.location + scan a
		remove na origem em vez de detecta-la com gate.

		Convergencia stable na rodada final com os 6 ajustes do founder
		integrados literalmente (titulo sem jargao, config-path transitorio,
		campos verificados contra schema, orfao->reject deferido via def-018,
		D2/D3 dead-by-default, fundacionais como ADRs follow-on). decisionClass
		structural; reversibility medium; blastRadius cross-cutting.
		"""
}
