package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr042: build_time.#SelfReviewReport & {
	reportId: "srr-adr-042"

	artifactPath:       "architecture/adrs/adr-042-tmpl-create-script-and-script-wi-tracking.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-04-07"

	roundsExecuted: 2
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 1
		infoCount: 0
		summary: """
			Primeira passada contra 8 universais + 3 type-specific
			(tq-adr-01/02/03). Draft inicial propunha que a política
			de fronteira entre scripts rastreados vs não-rastreados
			vivesse em governance/repo-principles.cue OU no rationale
			do template como fallback.

			Finding fail em tq-adr-01 (alternativas com rejeição
			justificada): o campo context listava três alternativas
			(reutilizar tmpl-create-instance, introduzir Taskfile,
			manter scripts fora do WI), cada uma com justificativa
			de rejeição específica. Pass na estrutura, mas a decisão
			deixava ambígua a localização canônica da própria política
			— "repo-principles.cue (ou ... no rationale do template)"
			— gerando drift por construção entre duas possíveis fontes
			normativas. Correção na rodada 2: política passa a viver
			como conteúdo normativo primário dentro do campo decision
			da própria ADR, com resumo replicado no rationale do
			template tmpl-create-script@v1 para visibilidade
			operacional. Fonte única, resumo pointer.

			Finding warn em uq-05 (limitações declaradas): política
			de fronteira original "se o script materializa decisão
			de governança" tinha componente subjetivo — "materializa
			decisão" carrega ambiguidade interpretativa. Correção
			na rodada 2: frase refinada para "se o script altera,
			deriva ou valida artefato versionado com papel normativo
			no sistema". Três verbos operacionais (altera, deriva,
			valida) reduzem subjetividade a teste concreto sobre o
			artefato tocado, não sobre intenção do autor.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Segunda passada após correções. Política de fronteira
			reescrita dentro do campo decision como fonte normativa
			primária. Frase operacional refinada para "altera, deriva
			ou valida artefato versionado com papel normativo no
			sistema". Regra de dúvida preservada ("na dúvida,
			rastrear"). Backfill retroativo de scripts existentes
			explicitamente rejeitado, com analogia ao tratamento em
			work-events/_constraints.cue.

			uq-01 (rationale=WHY): rationale do ADR justifica
			decisionClass=structural (cria categoria nova de template
			e política nova de rastreamento), reversibility=high
			(enum é extensível, política é documental — reverter é
			remover valor e política sem custo de dados), blastRadius=
			cross-cutting (afeta sistema de templates, governance de
			tasks e política de rastreamento de scripts futuros),
			[P0, P1, P12]. Pass.

			uq-02 (Mesh-specific): substitution test "scripts de build
			em qualquer fintech" falha — o argumento central é a
			aplicação de governance-as-code ao próprio sistema de
			templates da Mesh, ancorada em CLAUDE.md como artefato
			derivado específico do agente Mesh, em scripts/ci/
			existentes como caso concreto de precedente, e em ADR-007
			como base que esta ADR estende. Pass.

			uq-03 (refs cruzadas existem): adr-007 committed (visto
			em architecture/adrs/); adr-024 committed (referenciada
			em work-events/_constraints.cue);
			architecture/artifact-schemas/task-template.cue existe e
			é alterado como output direto;
			ai-orchestration/agent-instructions/task-templates.cue
			existe e recebe nova entrada no mapa;
			governance/build-time/task-governance.cue existe e recebe
			nova regra; governance/claude/config.cue e output.cue
			existem. Pass.

			uq-04 (consistência com princípios): P0 (zero duplicação)
			— política vive em lugar único (decision da ADR), resumo
			no template é ponteiro, não cópia. P1 (schema-first) —
			extensão do schema task-template.cue precede a instância
			do template no mesmo commit. P12 (governance as code) —
			política materializada como ADR versionada, template
			versionado, governance rule versionada; nenhuma regra
			solta em documentação informal. Sem contradição. Pass.

			uq-05 (limitações declaradas): consequences lista duas
			negativas concretas — ampliação de superfície do enum
			exige manutenção futura; componente subjetivo residual
			na fronteira operacional vs experimental. Mitigação
			declarada: regra de dúvida explícita e backfill
			rejeitado. Pass (warn da rodada 1 resolvido).

			uq-06 (ubiquitous language): termos consistentes —
			"script de build", "artefato derivado", "governance",
			"work-graph", "template", "rastreamento". Sem mistura
			de sinônimos. Pass.

			uq-07 (zero placeholder): nenhum TODO/TBD. Pass.

			uq-08 (conforma com #ADR): id matches ^adr-[0-9]{3}$;
			status=accepted (NonSupersededStatus, supersededBy
			ausente); date format válido; decisionClass=structural,
			reversibility=high, blastRadius=cross-cutting (enums
			válidos); affectedArtifacts com 3 paths reais;
			derivedArtifacts com 1 path (CLAUDE.md);
			principlesApplied com 3 entries; supersedes vazio;
			rationale presente. Pass.

			tq-adr-01 (alternativas com rejeição): três alternativas
			rejeitadas com justificativa específica — reutilizar
			tmpl-create-instance (contamina template-alvo, fere
			tq-tt-01), introduzir Taskfile (prematuro para um único
			target), manter fora do WI (CLAUDE.md tem blast radius
			real). Pass.

			tq-adr-02 (metadata de risco reflete decisão): reversibility
			high é defensável — enum é extensível no próprio CUE,
			política é texto normativo sem dados persistidos, nenhum
			commitment a contrato externo. blastRadius cross-cutting
			porque afeta simultaneamente task-template schema,
			task-templates instances, task-governance rules, e
			política de scripts futuros — não é local (toca 3
			artefatos distintos), não é repo-wide (não toca CI
			pipeline nem estrutura). Pass.

			tq-adr-03 (paths em affectedArtifacts são reais):
			architecture/artifact-schemas/task-template.cue existe
			(editado no commit); ai-orchestration/agent-instructions/
			task-templates.cue existe (recebe entrada); governance/
			build-time/task-governance.cue existe (recebe entrada).
			CLAUDE.md em derivedArtifacts existe. Pass.
			"""
	}]

	findings: {}

	summary: """
		ADR-042 decide duas coisas acopladas: (1) estender
		#TaskTemplate.kind com "create-script" e criar template
		tmpl-create-script@v1; (2) formalizar política de
		rastreamento como WI para scripts que alteram, derivam ou
		validam artefato versionado com papel normativo, com
		política vivendo no próprio campo decision da ADR como
		fonte normativa primária. Estável em 2 rounds: rodada 1
		identificou ambiguidade de localização da política (fail
		em tq-adr-01 por drift) e subjetividade da fronteira
		(warn em uq-05); rodada 2 consolidou política dentro da
		ADR e refinou frase operacional. Zero findings residuais.
		"""
}
