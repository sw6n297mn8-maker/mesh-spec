package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

taskSpecPg: build_time.#SelfReviewReport & {
	reportId: "srr-task-spec-pg"

	artifactPath:       "architecture/production-guides/task-spec.cue"
	artifactSchemaPath: "architecture/artifact-schemas/production-guide.cue"
	artifactType:       "production-guide"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-05"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Production guide para #TaskSpec (architecture/production-guides/task-spec.cue) materializado via authoring manual section-by-section per manualAuthoringProtocol (adr-057). Cascade ordering per adr-053/adr-054 dec 13: schema #TaskSpec existe (architecture/artifact-schemas/task-spec.cue); PG criado em sessão WI-057 P2P bootstrap pre-Phase 1 por necessidade de bootstrap de WI-057 task-claim work-event (founder request explícito como pré-condição para Phase 1 P2P canvas). Primeiro PG cobrindo schema fora de artifact-schemas/ (TaskSpec vive em ai-orchestration/agent-instructions/task-templates.cue + governance/build-time/work-events/, mas o tipo é governado per artifact-schemas/task-spec.cue) — extensão interpretativa de adr-053 universal coverage sem decisão arquitetural nova. Estrutura: 3 sections (skeleton-and-identity / semantic-content-and-rationale / work-events-and-validation), 8 quality criteria tq-tsg-XX (cobertura disciplines tq-mg + task-spec-specific: id uniqueness; templateRef validity; outputs concretos; semanticPrerequisites verifiable; affects no duplication; rationale substantive; work-events pareado; founder approval bloqueante), 19 referências a tq-tsg (8 ids + reuso em testes), 247 linhas totais. Adicionado também: abreviação `tsg` em legend de quality-criteria (architecture/artifact-schemas/quality-criteria.cue) per convenção tq-{abbr}-XX. Disciplinas tq-mg-XX aplicadas: tq-mg-02 (verbos imperativos em todos process actions: Estabelecer/Popular/Criar/Verificar/Submeter) ✓; tq-mg-04 (gapPolicy anti-invenção HARD com cláusulas explícitas: NÃO criar task-approved no mesmo commit do propor — task-approved event registrado APÓS approval explícita; NÃO copiar IDs de tasks existentes; NÃO inventar templateRefs; NÃO duplicar affects) ✓; tq-mg-08 (default+override em status draft + applicabilityCondition) ✓; tq-mg-10 (canonical removal test embedded em finalValidation: SE remover task-spec, ready-queue rebuild não tem âncora — PG sustenta integridade do work-event stream) ✓. Não aplicáveis: tq-mg-05 (task-spec não tem rule/constraint/check first-class — descritiva de work scope); tq-mg-07 (task-spec não tem elementos operacionais beyond outputs); tq-mg-09 (task-spec é uma unit of work, não tem sub-units). Schema satisfação tq-pg-XX/tq-mg-XX: tq-pg-01/tq-mg-01 (workOrder == keys(sections), 3 entradas: skeleton-and-identity, semantic-content-and-rationale, work-events-and-validation — set equality verificada) ✓; tq-pg-02 (cada section.target = '#TaskSpec', tipo válido em schema adotado) ✓; tq-pg-03 (cada section tem objective + process + doneCriteria + ifGap substantivos) ✓; tq-pg-04/tq-mg-04 (gapPolicy ≥50 runes com cláusulas anti-invenção explícitas para work-events serialization rule) ✓; tq-pg-05/tq-mg-03 (finalValidation.steps[-1] = 'Submeter ao founder para aprovação explícita antes de commit; task-approved event NUNCA no mesmo commit do propor — registrado APÓS approval em commit separado per work-event stream serialization rule') ✓; tq-pg-06/tq-mg-02 (todas process actions iniciam com verbo imperativo canônico) ✓. 8 critérios tq-tsg-XX cobrem: 01 id único cross-tasks; 02 templateRef existe em task-templates.cue; 03 outputs concretos não-placeholder; 04 semanticPrerequisites verificáveis (não aspiracional); 05 affects sem duplicação cross-tasks; 06 rationale substantivo capturando contexto estratégico; 07 work-events stream pareado (task-claimed pré-escrita; task-approved pós-approval); 08 founder approval bloqueante registrado em audit trail antes de commit. 3 microajustes founder pre-write aplicados em batch: (1) abreviação 'tsg' adicionada em legend de quality-criteria.cue como prerequisito da convenção tq-{abbr}-XX; (2) section 3 doneCriteria reforçada com 'task-approved NUNCA no mesmo commit do propor' (per workflow founder canonical para serialization de work-events); (3) gapPolicy expandida com cláusula anti-fabricação de templateRefs (referências precisam apontar para task-templates.cue existentes, não inventar templates). cue vet ./architecture/production-guides/ ./architecture/artifact-schemas/ EXIT=0; cue vet ./... EXIT=0 (CI canonical gate)."
	}]

	findings: {}

	summary: "PG task-spec via authoring manual section-by-section. 3 sections (skeleton-and-identity / semantic-content-and-rationale / work-events-and-validation) + 8 quality criteria tq-tsg-XX + abreviação `tsg` adicionada em legend quality-criteria.cue. Primeiro PG cobrindo schema fora de artifact-schemas/ (extensão interpretativa de adr-053 sem decisão arquitetural nova). 3 microajustes founder pre-write batch (tsg legend, task-approved serialization rule, gapPolicy anti-fabricação templateRefs). Disciplinas tq-mg-02/04/08/10 aplicadas; tq-mg-05/07/09 não aplicáveis (task-spec é unit of work descritiva)."

	singleRoundRationale: "Authoring manual aplicado per manualAuthoringProtocol (adr-057) section-by-section com founder confirmation explícita por section. 3 microajustes founder pre-write batch incorporados em commit único per founder workflow (PG + abreviação tsg em commit único aprovado explicitamente). Auto-checks PASSED: cue vet ./... EXIT=0; coberta universalmente por workflow founder + tq-pg-XX/tq-mg-XX por inspeção. Round único suficiente — artefato passou por founder review iterativo durante composição (não review pós-hoc de draft completo). PG criado como pré-condição cascade ordering para WI-057 task-claim work-event (Phase 0 P2P bootstrap)."
}
