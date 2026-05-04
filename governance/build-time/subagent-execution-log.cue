package build_time

// subagent-execution-log.cue — Log de dispatches de authoring/review
// subagents per adr-054 (Phase 1 ativada via WI-069).
//
// V1: simples lista de entries sem schema first-class. Decisão founder
// 2026-05-03 sessão claude/resume-mesh-work-jv2MC: formalizar como
// artifact type só quando volume de dispatches justifique recorrência.
// Pattern paralelo ao defer-de-formalização per adr-049/056 (kinds
// expand-when-needed).
//
// Métrica observable: failure rate per CLAUDE.md "Authoring Declarativo"
// transparency requirement. Calcular: count(result=failure) / count(*).
//
// Append-only por convenção. Cada nova dispatch adiciona entry; não
// editar entries existentes (audit trail). Updates de status (e.g.,
// founder-approved post-hoc) ficam em commit message ou novo entry
// referenciando o anterior.

subagentExecutionLog: {
	version: "v1"

	// Lista append-only de dispatches realizados.
	entries: [{
		dispatchId:   "disp-001"
		workItem:     "WI-069"
		date:         "2026-05-03"
		target:       "architecture/production-guides/tension-entry.cue"
		artifactType: "production-guide"

		authoringSubagent: {
			dispatched:        true
			subagentType:      "general-purpose"
			result:            "success"
			cueVetAttempts:    1
			cueVetExitCode:    0
			abbreviationChosen: "teg"
			notes: """
				First real dispatch (Phase 1 activation via WI-069).
				Cue vet passed first attempt; zero corrections needed.
				Reasoning report: 5 asked-founder priority items;
				inferences: 3-section partitioning per PG-ADR pattern;
				4 hardening criteria (3 fail + 1 warn anti-catch-all).
				"""
		}

		reviewSubagent: {
			dispatched: true
			subagentType: "general-purpose"
			result: "success"
			findings: {
				fail: 0
				warn: 6
			}
			recommendation: "approve-with-editorial-adjustments"
			notes: """
				6 warns — 3 editorial (uq-06 WI/task terminology,
				tq-pg-06 'Classificar kind' abstractness, cross-cutting
				tq-teg-01 mapping ambiguity); 3 informational (uq-03
				tq-as-05 not formally defined repo-wide; uq-05 minor
				validatorNote framing; tq-pg-03 some interpretive
				doneCriteria). Isolation preserved: review surfaced
				inconsistencies authoring did not see (anti-auto-
				ratification confirmed).
				"""
		}

		founderDecision: {
			outcome: "approved-with-3-adjustments"
			notes: """
				Opção 1 selecionada: aprovar + aplicar 3 ajustes
				editoriais (uq-06 padronização WI; tq-pg-06 expansão
				'Classificar kind contra os 3 enum values'; tq-teg-01
				clarificar mapping a tq-te-01 + tq-te-03). Asked-founder
				priority list (5 items) inferences aceitas — diferir
				revisão pós-uso real do PG.
				"""
		}

		fallbackPathsTested: {
			cueVetFailureRetry:   false
			selfReviewFailRetry:  false
			ambiguityEscalation:  false
			manualTakeoverPath:   false
			notes: """
				Fallback paths (cueVetFailure, selfReviewFail, ambiguity,
				manual-takeover) NÃO foram testados nesta dispatch
				porque pipeline succeeded organically em todos os
				steps. Gap honesto registrado em commit message como
				known-gap. Pode virar def-XXX se pattern recorrer
				(múltiplas dispatches successful sem exercitar fallback)
				— founder decide se forçar teste artificial vale o cost.
				"""
		}

		// Side-effect calibration findings (deferred-decision system
		// surfaced own weaknesses durante WI-069 testing — founder
		// asked "aproveite e teste a estrutura").
		calibrationFindings: [
			"def-004 created: tq-as-05 dívida real (surfaced by review subagent uq-03 finding); 30+ refs cross-repo without formal definition. Trade-off articulado, triggers codificados (volume-threshold + manual-review).",
			"def-002 + def-003 round 3 amendments — 2 layers de self-reference fix: (Layer 1) pattern '.{0,30}' substituído por '[a-z ]{0,30}' para evitar match em string literais regex (que contêm ')' '.' '{' '}' chars). (Layer 2) iteração subsequente revelou que prose examples de demanda dentro da própria documentação ('needs cross-file-id check') também self-match. Fix final: substituir example phrases por placeholder literal '<kind-name>' que contém '<' não-letra (não casa com [a-z ]+). Resultado: 0 matches em todo repo; threshold=2 captura 2+ demand externo genuíno.",
			"Generalization: recurrence trigger pattern stored como string em CUE pode self-match em (a) regex literal characters e (b) prose examples na própria documentação. Mitigações: (a) char classes restritivos no in-between, (b) placeholder literals em exemplos. Não documentado como def-XXX separado — pattern é guidance para futuras calibrations, não dívida acionável (calibração caso-a-caso).",
		]

		pipelineOutcome: "success"

		executionTimings: {
			authoringMs: 395090
			reviewMs:    292607
			totalMs:     687697
		}
	}, {
		dispatchId:   "disp-002"
		workItem:     "WI-048"
		date:         "2026-05-04"
		target:       "contexts/bdg/canvas.cue"
		artifactType: "canvas"

		authoringSubagent: {
			dispatched:     true
			subagentType:   "general-purpose"
			result:         "success-with-cascade-ordering-violation"
			cueVetAttempts: 1
			cueVetExitCode: 0
			notes: """
				Primeira dispatch de canvas instance via subagent-drafted
				(rollout extension per adr-074). Subagent honestamente
				identificou em reasoning report que PG canvas (architecture/
				production-guides/canvas.cue) NÃO existia em main —
				cascade ordering violation per CLAUDE.md "Pré-condição de
				instância". Produziu schema-conformant draft mesmo assim
				seguindo explicit user instruction, mas marcou como priority
				item #1 para founder review. Reasoning report expôs 7
				priority items + 6 honest inferences + cross-reference com
				patterns observados em CMT/IDC/NPM canvases. Cue vet PASSED
				em temp file; draft descartado per fallback path.
				"""
		}

		reviewSubagent: {
			dispatched: false
			notes: """
				Review skipped — main agent detectou cascade ordering
				violation em subagent reasoning report e escalou ao
				founder antes do review dispatch. Per fallbackPolicy
				spirit, escalação imediata foi correta (review de draft
				que viola cascade ordering seria dispatching despesa
				adicional sem ganho).
				"""
		}

		founderDecision: {
			outcome: "discard-draft-pivot-to-pg-canvas-first"
			notes: """
				Founder aprovou Path A: pausar canvas instance, autorar
				PG canvas primeiro per CLAUDE.md cascade ordering. Draft
				de canvas instance descartado. Surfaced factual error em
				adr-074 ('5 PGs existem em main' incorreto — apenas 4
				existiam; canvas PG faltando). Editorial amendment
				aplicado em commit 0066d70.
				"""
		}

		fallbackPathsTested: {
			cueVetFailureRetry:        false
			selfReviewFailRetry:       false
			ambiguityEscalation:       false
			manualTakeoverPath:        false
			cascadeOrderingEscalation: true
			notes: """
				Novo path de fallback exercitado: cascade ordering violation
				detection via subagent honest reporting. Não codificado em
				fallbackPolicy original (adr-054 mencionou apenas cueVet,
				selfReview, ambiguity). Pattern observado: subagent honestidade
				é defesa valiosa contra silent acceptance de drafts derivados
				sem PG. Candidate para incorporação em fallbackPolicy futuro.
				"""
		}

		calibrationFindings: [
			"Cascade ordering verification em adr-074 foi prose-only (claim de '5 PGs existem'); não houve check filesystem-actual pre-commit. Pattern: ADRs que mencionam pré-condições estruturais devem incluir filesystem verification step OR delegar a structural-check (def-012 cobre stale detection mas não pre-condition coverage).",
			"Subagent honest reporting é mecanismo de defesa que excedeu expectativa — reasoning report priority items contornaram cascade ordering violation que main agent não detectou. Confirma valor de isolation per adr-054 dec 10.",
			"Schema-derived bootstrap draft (sem PG canvas) era tecnicamente conformant a #Canvas mas violava cascade ordering rule. Distinção: 'schema conformance' ≠ 'cascade ordering compliance'. Ambos necessários.",
		]

		pipelineOutcome: "failure-cascade-ordering"

		executionTimings: {
			authoringMs: 851625
			reviewMs:    0
			totalMs:     851625
		}
	}, {
		dispatchId:   "disp-003"
		workItem:     "WI-048"
		date:         "2026-05-04"
		target:       "architecture/production-guides/canvas.cue"
		artifactType: "production-guide"

		authoringSubagent: {
			dispatched:     true
			subagentType:   "general-purpose"
			result:         "failure-api-timeout"
			cueVetAttempts: 0
			cueVetExitCode: -1
			notes: """
				API stream idle timeout após 473s + 32 tool uses.
				Partial response received mas não parseable; conteúdo
				não recuperável. Subagent estava trabalhando intensamente
				(32 tool uses sugere reading múltiplos files + drafting
				sections substantivas). Infrastructure failure, não
				content failure — categoria distinta de cueVetFailure /
				selfReviewFail / ambiguity em fallbackPolicy.
				"""
		}

		reviewSubagent: {
			dispatched: false
			notes:      "No draft to review (subagent timed out before producing parseable output)."
		}

		founderDecision: {
			outcome: "manual-takeover"
			notes: """
				Founder escolheu manual takeover por main agent (em vez de
				retry com scope reduzido). Manual authoring aplicou META-PG
				protocol section-by-section. PG canvas produzido em commit
				ef5195f (architecture/production-guides/canvas.cue) com 3
				ajustes founder substantivos pre-commit: (1) wording 'Phase
				2' → 'cascade-ordering requirement'; (2) ownership.doneCriteria
				relaxed ≥3/≥3/≥3 → ≥1/≥1/≥3; (3) communication.doneCriteria
				adicionou cláusula event/query-only interface.
				"""
		}

		fallbackPathsTested: {
			cueVetFailureRetry:  false
			selfReviewFailRetry: false
			ambiguityEscalation: false
			manualTakeoverPath:  true
			apiTimeoutTakeover:  true
			notes: """
				Primeiro exercício de manual takeover path per fallbackPolicy.
				Trigger foi infrastructure (API timeout), não logical falha
				do subagent — categoria não prevista explicitamente em
				fallbackPolicy original (adr-054). Pattern observado:
				timeout em workloads densos (PG canvas é estruturalmente
				grande). Mitigação experimentada (retry com scope reduzido)
				foi propôsta mas founder escolheu manual takeover diretamente
				por timing.
				"""
		}

		calibrationFindings: [
			"Workloads densos (PG canvas: ~280 linhas, 8 sections, 4 quality criteria, ~25 schema fields para guide) podem exceder API timeout. Schema-rich types (canvas com 167 sub-fields) são candidates óbvios. Mitigação 1 (retry com scope reduzido) não testada — founder pivotou para manual; pode ser explorada em próximas dispatches.",
			"fallbackPolicy original (adr-054) categoriza failures por content (cueVet, selfReview, ambiguity) mas não por infrastructure (timeout, network, rate limit). Gap: API timeout não tem categoria explícita. Candidate para amendment futura se pattern recorrer.",
			"Manual takeover is functioning fallback — produziu PG canvas conformante em commit ef5195f. Pattern: manual takeover incurs cognitive load mas garante completude quando dispatch falha. Trade-off aceitável para occasional failures.",
		]

		pipelineOutcome: "failure-recovered-via-manual-takeover"

		executionTimings: {
			authoringMs: 473121
			reviewMs:    0
			totalMs:     473121
		}
	}, {
		dispatchId:   "disp-004"
		workItem:     "WI-048"
		date:         "2026-05-04"
		target:       "contexts/bdg/canvas.cue"
		artifactType: "canvas"

		authoringSubagent: {
			dispatched:     true
			subagentType:   "general-purpose"
			result:         "failure-api-timeout"
			cueVetAttempts: 0
			cueVetExitCode: -1
			notes: """
				Redispatch de canvas instance para BC bdg após disp-002
				(cascade ordering escalation) e disp-003 (PG canvas
				authoring que também timed out). Cascade ordering agora
				satisfeito (canvas PG materializado em commit ef5195f).
				inputContract incluía linha explícita 'PG canvas existe
				e é autoridade do protocolo; o draft anterior foi
				descartado e não deve ser usado como fonte' para evitar
				contaminação do dispatch novo.

				API stream idle timeout após 509s + 59 tool uses.
				Pattern consistente com disp-003 (canvas-class workload).
				Subagent estava trabalhando intensamente (59 tool uses
				sugere reading PG canvas + schema + 3 golden examples
				+ bdg subdomain + context-map + glossary refs + lens +
				drafting 8 sections substantivas com cross-checks).
				Partial response received mas não parseable.
				"""
		}

		reviewSubagent: {
			dispatched: false
			notes:      "No draft to review (subagent timed out before producing parseable output)."
		}

		founderDecision: {
			outcome: "manual-takeover-with-structural-revisit-trigger"
			notes: """
				2 timeouts consecutivos (disp-003 PG canvas + disp-004
				canvas instance) confirmam pattern: canvas-class workloads
				excedem API timeout window por densidade estrutural
				inerente. Founder articulou explicitamente: 'isso não é
				só um fallback tático; é uma decisão estrutural sobre o
				limite do mecanismo'. Path A executado: (A1) manual
				takeover do canvas BDG (commit 818c079); (A2) amendment
				adr-074 removendo canvas do rollout per revisit condition
				(b) triggered (commit 5eab93d); (A3) pattern emergente
				registrado como Known gap em adr-074 (artifacts lineares
				com cross-checks limitados são viáveis; artifacts com
				múltiplas seções interdependentes + cross-checks
				intensivos não são).
				"""
		}

		fallbackPathsTested: {
			cueVetFailureRetry:        false
			selfReviewFailRetry:       false
			ambiguityEscalation:       false
			manualTakeoverPath:        true
			apiTimeoutTakeover:        true
			revisitConditionTriggered: true
			notes: """
				Segundo exercício de manual takeover path per fallbackPolicy
				(paralelo a disp-003). Trigger foi infrastructure (API
				timeout). N=2 timeouts consecutivos canvas-class confirmou
				revisit condition (b) de adr-074 — canvas REMOVIDO do
				rollout permanentemente até mecanismo evoluir. Decisão
				estrutural materializada em commit 5eab93d (não tactical
				fallback). Mitigação retry com scope reduzido NÃO testada
				— founder pivotou diretamente para manual takeover +
				structural revisit por timing e por evidence acumulada.
				"""
		}

		calibrationFindings: [
			"N=2 timeouts canvas-class confirmou pattern: workloads densos (canvas é caso paradigmático com ~25 top-level fields + 167 sub-fields + 8 sections + cross-checks) consistentemente excedem API timeout window. Não deve ser tratado como resolvível por prompt tuning ou retry no mecanismo atual. Solidifica diagnóstico levantado em disp-003 calibrationFindings.",
			"Pattern emergente codificado em adr-074 Known gap: subagent-drafted viável para artefatos com (a) baixa-média densidade estrutural e (b) cross-checks semânticos limitados; falha consistentemente para artefatos com (a) múltiplas seções interdependentes e (b) cross-checks intensivos cross-file. Vive como guideline empírico até segundo caso paradigmático recorrer (paralelo a ten-009 expand-when-needed para generalização).",
			"Decisão estrutural sobre limite do mecanismo (vs tactical fallback) é importante governance step: codifica o limite no sistema em vez de redescobri-lo a cada novo type complexo. Materializa princípio mesh 'sistema robusto contra erro da própria IA' — falha do dispatch foi detection point, não failure mode.",
			"Anti-contaminação (linha explícita 'draft anterior foi descartado') foi aplicada mas não exercitada — subagent não chegou a produzir output parseable. Eficácia da mitigação não pode ser avaliada nesta dispatch.",
		]

		pipelineOutcome: "failure-recovered-via-manual-takeover-with-structural-revisit"

		executionTimings: {
			authoringMs: 509803
			reviewMs:    0
			totalMs:     509803
		}
	}, {
		dispatchId:   "disp-005"
		workItem:     "WI-048"
		date:         "2026-05-04"
		target:       "contexts/bdg/glossary.cue"
		artifactType: "glossary"

		authoringSubagent: {
			dispatched:     true
			subagentType:   "general-purpose"
			result:         "success"
			cueVetAttempts: 2
			cueVetExitCode: 0
			notes: """
				Primeiro non-PG dispatch successful — validação operacional
				do rollout extension de adr-074. PG glossary aplicado
				section-by-section (3 sections per workOrder). 14 terms
				propostos no draft inicial; subagent honestamente flagged
				7 priority items para founder review. Auto-fix exercitado:
				attempt 1 detectou tq-gl-06 violation (antiTerm 'Limite
				de Centro de Custo' em term-alcada repetia term name);
				attempt 2 corrigiu para 'Teto Total de Centro de Custo'
				(não-canônico) preservando disambiguation content. Post-fix:
				programmatic validation suite com TODOS tq-gl-* + tq-gg-*
				PASSED (15/15/15 unicidade após founder add +1 term;
				47 relatedTerms refs resolved; antiTerms clean; anchors
				≥1 per term).

				Pattern observado: glossary é estruturalmente menos denso
				que canvas (3 sections de PG vs 8; menos cross-checks
				cross-file) — viável within API timeout window per pattern
				de adr-074 Known gap. Confirma diagnóstico estrutural:
				subagent-drafted é viável para artefatos com baixa-média
				densidade estrutural + cross-checks limitados.
				"""
		}

		reviewSubagent: {
			dispatched: false
			notes: """
				Review subagent NÃO dispatched — founder optou por review
				direto + 3-cycle red team próprio + ajustes substantivos.
				Valid bypass per CLAUDE.md "Authoring Declarativo" P10
				framing: founder approval gate final em todos os casos.
				Review subagent dispatch é optional secondary defense
				quando founder review direta é viável e quando founder
				tem tempo/contexto para fazê-la pessoalmente — caso desta
				dispatch dado o investment substantial em red team manual.
				"""
		}

		founderDecision: {
			outcome: "approved-with-substantial-revision-in-3-layers"
			notes: """
				Founder aplicou 3 layers de ajuste pre-commit:

				Layer 1 — Decisões nos 7 priority items do subagent
				reasoning report:
				- Fracionamento: keep como rule term (vs demote/defer)
				- Centro de Custo: keep como entity (vs value)
				- Alçada termEn: loanword 'Alçada' (vs Approval Authority)
				- Liberação termEn: 'Budget Commitment Release' verboso
				  (vs ambiguous 'Commitment Release')
				- +1 term BudgetCommitmentReleased event (canonical trio
				  completion)
				- Queries não modeladas (consistente com 3 exemplos)
				- Identificação de Centro de Custo embutida em definition
				  (parsimony)

				Layer 2 — 3 ciclos de red team com correções substantivas:
				- Centro de Custo scope clarification (cost-center strict
				  vs centro de resultado)
				- Alçada definition: 'agente'→'ator' (mais neutro BR)
				- Encargo antiTerm clarification (em contabilidade
				  gerencial accrual; não coloquial)
				- Teto Orçamentário rejection: tightened reasoning
				  (multilevel ambiguity)
				- Reserva Orçamentária rejection: enriched (reserva
				  técnica seguros)
				- Add example a term-cobertura-orcamentaria
				- Add example a term-budget-rejected
				- Refactor term-cobertura definition para (a)/(b) explicit

				Layer 3 — Adequação BR validated: vocabulário canônico
				brasileiro de controladoria respeitado; anti-terms cobrem
				confusões típicas BR; loanwords mantidos com critério.

				Mechanical fix pre-commit: termEn 'Alçada' → 'Alcada'
				(ASCII variant per schema #Glossary regex constraint).
				Founder explicitamente articulou nota no rationale do
				term-alcada: 'termEn usa Alcada sem acento por constraint
				ASCII do schema #Glossary; a UL em português permanece
				Alçada'.

				Resultado: glossary com 15 terms, 47 relatedTerms refs,
				cue vet PASSED, materializado em commit c37a8b4.
				"""
		}

		fallbackPathsTested: {
			cueVetFailureRetry:            true
			selfReviewFailRetry:           false
			ambiguityEscalation:           false
			manualTakeoverPath:            false
			apiTimeoutTakeover:            false
			reviewSubagentBypass:          true
			schemaConstraintMechanicalFix: true
			notes: """
				Múltiplos paths exercitados nesta dispatch:
				- cueVetFailureRetry (genuine fallback — recovery
				  from failure): subagent self-corrected tq-gl-06
				  violation em retry (attempt 1→2)
				- reviewSubagentBypass (NÃO é fallback — não é
				  recovery from failure; é design choice): founder
				  optou por review direto + 3-cycle red team manual
				  per P10 framing — founder approval permanece gate
				  final
				- schemaConstraintMechanicalFix (NÃO é fallback —
				  é mecânica): termEn ASCII regex constraint surfaced
				  post-write; founder approved minimal mechanical
				  fix (Alçada→Alcada) preservando loanword spirit +
				  nota explícita no rationale
				"""
		}

		calibrationFindings: [
			"Glossary é caso paradigmático de baixa-média densidade estrutural — confirma adr-074 Known gap pattern. PG tem 3 sections (vs canvas 8); cross-checks limitados a unicidade interna + relatedTerms refs (vs canvas cross-file context-map + subdomain registry). API timeout não foi atingido apesar de 14 terms substantivos.",
			"Subagent honest reporting de 7 priority items foi extremamente valioso — todos os items eram genuine design decisions que founder review confirmou. Pattern: subagent serve como first-pass design + escalation surface; founder review é decision authority. Validates adr-054 dec 10 (isolation + escalation > auto-ratification).",
			"tq-gl-06 self-fix em attempt 2 é exemplo positivo de cueVetFailureRetry pattern funcionando — subagent diagnosed (antiTerm name colliding com term name), proposed fix (rename to non-canonical alternative), preserved content (disambiguation intact). Padrão reusable.",
			"Founder review direta + 3-cycle red team manual produziu mais ajustes (8 substantivos) que review subagent provavelmente teria gerado. Trade-off: bypass de review subagent vs depth de manual review. Para glossaries densos com nuances domain-specific (controladoria BR), manual review é provavelmente superior. Para artefatos mais mecânicos, review subagent pode ser viável.",
			"Schema constraint discovery (termEn ASCII regex) post-write é categoria de feedback que beneficiaria de structural-check antecipatório — vc-gl-XX poderia validar termEn regex pre-commit. Não codificado como def-XXX porque é caso único + structural-check trivial; pode virar guideline para futuras glossary authoring.",
		]

		pipelineOutcome: "successful-authoring-without-full-pipeline"

		executionTimings: {
			authoringMs: 589089
			reviewMs:    0
			totalMs:     589089
		}
	}, {
		dispatchId:   "disp-006"
		workItem:     "WI-048"
		date:         "2026-05-04"
		target:       "contexts/bdg/domain-model.cue"
		artifactType: "domain-model"

		authoringSubagent: {
			dispatched:     true
			subagentType:   "general-purpose"
			result:         "success"
			cueVetAttempts: 2
			cueVetExitCode: 0
			notes: """
				Segundo non-PG dispatch successful — confirma adr-074
				Known gap pattern. PG domain-model aplicado section-by-
				section. Auto-fix exercitado em retry: attempt 1 detectou
				2 queryCapabilities missing required `rationale` field
				(prj-budget-approval-status + prj-cost-center-availability);
				attempt 2 corrigiu adicionando rationales substantivas.
				Pre-existing schema collision baseline (artifact_schemas.#Policy
				entre policy.cue PLR registry e domain-model.cue policy)
				corretamente identified como aceito state — confirmed via
				verifying que cmt/idc/npm golden examples têm idêntico
				residual error (cue vet -c flag).

				Pattern observado: domain-model é estruturalmente
				intermediário (mais complexo que glossary, menos que
				canvas) — viável within API timeout window. PG tem 3
				sections (vs canvas 8); cross-checks múltiplos com canvas
				(capabilities/businessDecisions) + glossary (UL terms ↔
				entities) mas dentro de fronteira viável. Confirms adr-074
				Known gap subagent-drafted boundary calibration.

				Subagent honestly flagged 6 priority items para founder
				review (policy outcome split convention, vo-money currency
				assumption, idempotency scope, release trigger ACL,
				fragmentation deferral, domain service consideration).
				"""
		}

		reviewSubagent: {
			dispatched: false
			notes: """
				Review subagent NÃO dispatched — founder optou por review
				direto + 3-cycle red team próprio (paralelo a disp-005
				glossary BDG). Valid bypass per CLAUDE.md "Authoring
				Declarativo" P10 framing: founder approval gate final em
				todos os casos. Pattern emergent: para artefatos com
				nuances domain-specific densos (controladoria BR + DDD
				tactical patterns), founder review direta + manual red
				team produz mais ajustes substantivos que review subagent
				isolado provavelmente geraria.
				"""
		}

		founderDecision: {
			outcome: "approved-with-3-cycle-red-team-and-1-correction"
			notes: """
				Founder aplicou review pre-commit em camadas:

				Layer 1 — Verificação estrutural cross-BC (founder-led):
				Comparação dos counts contra cmt/idc/npm golden examples
				confirmou BDG dentro de ranges observados (events/commands
				no lower end por gate determinístico; invariants/VOs
				upper-medium). 1 divergência estrutural única identificada:
				entities nested (BDG=1, outros=0). Investigação confirmou
				divergência GENUINELY justificada por design — Centro de
				Custo é registry/container que requer atomicidade no
				cálculo de Saldo Disponível; modelar Comprometimento como
				aggregate root separado violaria consistency boundary;
				embutir como value object perderia identidade persistente
				necessária para BudgetCommitmentId em events. Não é
				over-modeling — é DDD canônico para semântica de registry
				com items.

				Layer 2 — 3 ciclos de red team:
				- Ciclo 1 (adequação BR + terminologia financeira):
				  10 pontos analisados. Vocabulário brasileiro respeitado;
				  loanwords ASCII consistent com glossary. Nenhuma correção.
				- Ciclo 2 (coerência canvas + glossary): 14/15 terms
				  mapeados; 4/4 businessDecisions cobertos por invariants;
				  escalation criteria + autonomous/supervised decisions
				  alinhados. 1 issue identificado: Alçada não tem value
				  object próprio.
				- Ciclo 3 (schema compliance + edge cases): 12 pontos
				  analisados; convenções consistent; cross-references
				  corretas. Nenhuma correção.

				Layer 3 — 1 correção substantiva aplicada:
				inv-alcada-respected.rationale enriquecido com nota
				explícita: 'tabela de Alçadas vive como configuração
				externa fora do BDG BC; este invariant captura a regra
				mas não modela o data — value object próprio para faixa
				de Alçada não é necessário porque limites são consultados
				em runtime via API/configuration externa, não persistidos
				como state interno do agg-cost-center'.

				Layer 4 — 6 priority items addressed in rationale (não
				como correções obrigatórias, mas decisions documentadas):
				policy outcome split (single policy + internal routing
				keep), vo-money multi-moeda preserva vertical-agnostic,
				idempotency scope clarified, release trigger ACL deferred
				per oq-bdg-2, fragmentation deferred per oq-bdg-1, no
				domain service for cost-center identification (ACL
				adapter responsibility).

				Resultado: domain-model com 1 aggregate + 1 entity nested
				+ 7 invariants + 7 VOs + 4 events + 3 commands + 1 policy
				+ 2 projections, materializado em commit a1bba3d.
				"""
		}

		fallbackPathsTested: {
			cueVetFailureRetry:   true
			selfReviewFailRetry:  false
			ambiguityEscalation:  false
			manualTakeoverPath:   false
			apiTimeoutTakeover:   false
			reviewSubagentBypass: true
			notes: """
				Paths exercitados:
				- cueVetFailureRetry (genuine fallback — recovery from
				  failure): subagent self-corrected 2 queryCapabilities
				  missing rationale em attempt 1→2 (paralelo a disp-005
				  tq-gl-06 self-fix). Reusable pattern confirmed.
				- reviewSubagentBypass (NÃO é fallback — design choice):
				  founder optou por review direto + 3-cycle red team
				  manual. Pattern emergent: para artefatos com domain
				  nuances densas, manual review é provavelmente superior
				  a review subagent.

				Pre-existing schema collision (artifact_schemas.#Policy)
				NÃO é fallback — é accepted baseline state per cmt/idc/npm.
				"""
		}

		calibrationFindings: [
			"Domain-model é estruturalmente intermediário entre glossary e canvas — confirms adr-074 Known gap pattern (subagent-drafted viable for low-medium structural density). PG 3 sections; cross-checks moderados; API timeout não atingido apesar de 1 aggregate + 1 entity + 7 invariants + 7 VOs + 4 events + 3 commands + 1 policy + 2 projections.",
			"cueVetFailureRetry pattern reusável: tq-gl-06 fix em disp-005 + queryCapabilities rationale fix em disp-006 = 2 successful self-corrections em retry. Subagent diagnose + propose fix + preserve content semantics. Padrão funcionando consistente.",
			"Pre-existing schema collision (#Policy) baseline aceito — subagent honestly identified e cross-verified com golden examples. Reasoning report transparency é mecanismo de defesa que escalou para founder confirmation rather than silent acceptance.",
			"Founder structural cross-BC verification (counts comparison) é mecanismo emergent valuable — detectou 1 divergência estrutural (entities nested) que investigação confirmou justificada por design. Pattern: founder cross-BC analysis + design rationale review é complemento poderoso ao subagent reasoning report. Reusable em futuras dispatches non-PG.",
			"6 priority items honestly flagged pelo subagent + founder cross-BC analysis = comprehensive review surface. Para artefatos com DDD tactical patterns + domain nuances densos, este combo manual produz quality > review subagent isolado provavelmente geraria.",
		]

		pipelineOutcome: "successful-authoring-without-full-pipeline"

		executionTimings: {
			authoringMs: 765577
			reviewMs:    0
			totalMs:     765577
		}
	}]

	// Métrica observable derivada (calculada por leitura do log;
	// runner futuro pode automatizar quando volume justificar).
	currentMetrics: {
		totalDispatches:    6
		successfulPipeline: 1
		failureRate:        0.5
		fallbacksExercised: 5 // disp-002 cascade + disp-003 manual + disp-004 manual + disp-005 cueVetRetry + disp-006 cueVetRetry
		failureBreakdown: {
			cascadeOrdering: 1 // disp-002
			apiTimeout:      2 // disp-003 + disp-004
		}
		notes: """
			Failure rate: amostra (n=6) com 3 failures + 1 pipeline
			successful (WI-069 PG-tension-entry) + 2 successful authoring
			sem full pipeline (disp-005 glossary BDG + disp-006 domain-model
			BDG — review subagent intencionalmente bypassado por escolha
			founder de manual review + 3-cycle red team direto).
			Honest distinction: successfulPipeline conta apenas authoring →
			review → founder approval completo; disp-005 e disp-006 são
			successfulAuthoring mas não successfulPipeline pelo bypass
			deliberado de review subagent. fallbacksExercised conta apenas
			recovery from failure (cascade escalation, manual takeover,
			cueVetRetry); reviewBypass é design choice, não recovery.

			disp-005 (glossary BDG) + disp-006 (domain-model BDG) confirmam
			adr-074 Known gap pattern: subagent-drafted viável para
			artefatos com baixa-média densidade estrutural + cross-checks
			limitados. cueVetFailureRetry pattern exercitado consistente
			(tq-gl-06 em disp-005 + queryCapabilities rationale em
			disp-006) — subagent self-fix em retry é mecanismo robusto.

			Próximas dispatches WI-048 fase 4-5 (agent-spec, agent-governance)
			calibram melhor — agent-spec é candidate para revisit condition (c)
			de adr-074 (context-heavy deps; depende de canvas + domain-model
			+ glossary completos).
			"""
	}
}
