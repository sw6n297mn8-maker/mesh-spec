package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

deferredDecisions: "def-015-task-output-temporality-metadata": artifact_schemas.#DeferredDecision & {
	id:    "def-015"
	title: "Promote task output status + origin metadata to schema fields when emergent work pattern recurs"
	date:  "2026-05-08"

	description: """
		Necessidade emergente de distinguir outputs DELIVERED vs PENDING e
		capturar ORIGIN (emergent-from) de tasks. Observado em WI-070
		(primeiro caso real — emergent from WI-053 R3 cross-BC review;
		Layer -1 + Layer 1 já entregues; Layer 2 pendente).

		Founder canonical insight unificador: status + origin são o mesmo
		fenômeno — 'temporalidade do trabalho' (status = estado no tempo;
		origin = causalidade no tempo). Por isso este deferimento agrupa
		os dois, não dois separados.

		Sem suporte estrutural, sistema não consegue diferenciar trabalho
		feito vs trabalho faltante via parsing automático nem mapear WIs
		que geram outras WIs (emergent work tracking).
		"""

	deferralRationale: """
		Founder canonical R5+ estabelecido nesta sessão (2026-05-08):
		'1 ocorrência ≠ nova estrutura; repetição gera estrutura'.
		Schema mod prematura violaria a própria meta-rule: WI-070 é o
		PRIMEIRO uso real de status + origin estruturados — extender
		#TaskOutput / #TaskSpec agora cristaliza padrão sem pressão
		empírica suficiente.

		Trade-off explícito: PRESERVAR disciplina (deferir schema change)
		vs PERDER rastreabilidade automática (sem field, parsing depende
		de convenção textual em rationale). Resolução: capturar
		structurally em rationale (formato parseável 'DELIVERED:/PENDING:/
		ORIGIN:' bullets) + tracking automático via este deferimento;
		quando 2º WI emergent aparecer (totalizing 2 usos da convenção),
		trigger fires → ADR + schema change.

		Custo de continuar deferindo: medium-cumulative — cada nova WI
		emergent sem suporte estrutural acumula dívida; runner não detecta
		patterns automaticamente; founder precisa lembrar manualmente que
		convenção existe. Mas custo de cristalização prematura é maior
		(precedência perigosa: 'qualquer melhoria vira schema').
		"""

	triggerCalibrationRationale: """
		Pattern usa character class [(] / [)] em vez de parens literais (que
		git grep -E interpreta como group syntax). Verificado em teste pós-
		commit (2026-05-08): regex 'OUTPUTS STATUS (structured):' com parens
		literais NÃO matches texto contendo '(structured)' porque ERE trata
		() como grouping. Character class [(] força match literal de '('.

		Threshold 5 (NÃO 2 da intenção founder original 'quando ≥ 2 novas
		WIs'): ajustado para absorver 3 self-references estruturais
		inevitáveis no repo — def-015.cue (campo pattern), srr-def-015
		(prose referenciando trigger), wi-070.cue (header de uso real).
		#Trigger schema não suporta path-filter para scope file-content
		(git grep busca em todo repo). Resolução: 3 self-matches +
		2 NOVAS WIs emergent = threshold 5 honra intent founder.
		Verificado pre-fix: git grep -l -E retorna exatamente 3 arquivos.

		Pattern ainda distintivo: 'OUTPUTS STATUS [(]structured[)]:' como
		header line é uso convencional — pouco propenso a aparecer
		acidentalmente em outros artifacts além dos 3 self-references
		conhecidos.
		"""

	originatingArtifacts: [
		"governance/build-time/task-specs/wi-070.cue",
		"session:wi-070-emergent-from-wi-053-2026-05-08",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-artifact"
		description: """
			Sem schema field structurally, runner não consegue:
			(1) calcular % progresso real de WIs com outputs parciais;
			(2) detectar emergence patterns (qual WI gerou qual);
			(3) gerar projections automáticas de DELIVERED vs PENDING.
			Workaround atual via convenção textual em rationale é frágil —
			quebra silently se autor de futuro WI esquecer da convenção.
			Risco cumulativo medium ao longo de N WIs emergent; cross-
			artifact porque afeta task-specs + work-graph + projections.
			"""
	}

	triggers: [{
		kind:      "recurrence"
		pattern:   "OUTPUTS STATUS [(]structured[)]:"
		scope:     "file-content"
		threshold: 5
	}]

	status: "open"
}
