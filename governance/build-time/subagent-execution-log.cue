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
	}, {
		dispatchId:   "disp-007"
		workItem:     "WI-048"
		date:         "2026-05-04"
		target:       "contexts/bdg/agents/bdg-primary-agent.governance.cue"
		artifactType: "agent-governance"

		authoringSubagent: {
			dispatched:     true
			subagentType:   "general-purpose"
			result:         "success"
			cueVetAttempts: 1
			cueVetExitCode: 0
			notes: """
				Terceiro non-PG dispatch successful — confirma adr-074
				Known gap pattern e amplia evidência empírica para
				governance-type. Path C founder-approved (1 tentativa
				apenas; fallback manual no primeiro timeout). Subagent
				produziu draft single-attempt; sem retry (cueVet passou
				first try). PG agent-governance aplicado section-by-
				section (3 sections: routing-and-blast-radius, drift-
				and-calibration, bidirectional-validation). 1 self-check
				pass conforme single-attempt rule.

				Subagent honestly flagged 3 judgment calls em reasoning
				report:
				- 6 regression triggers (vs idc 4, cmt/npm 3) — trade-off
				  documented entre granularidade e poluição
				- caps 3/50 vs canonical onboarding band 1-2/20-50 (PG
				  tq-gvg-07 warn) — escolheu ctr/npm precedent
				- suspicious-input → alert-and-block (vs cmt/npm sync)
				  para Fracionamento por argumento de blast radius
				  cross-compromisso

				Pattern observado: agent-governance é estruturalmente
				intermediário (similar a domain-model em densidade — 5
				top-level sections + cross-checks com agent-spec). Viável
				within API timeout window per pattern. Confirma adr-074
				Known gap subagent-drafted boundary: agent-governance
				está dentro da fronteira viável (vs canvas que está fora).

				Issue de transporte (não-semântico): subagent retornou
				HTML entities (&amp;/&lt;/&gt;) em string output do code
				block. Conversão para caracteres reais aplicada pre-write
				pelo main agent — não-semântico (caracteres em strings
				CUE; &amp; em type unification seria syntax error mas
				teria sido detectado por cue vet). Categoria de feedback
				possivelmente endereçável por output-format directive
				em promptTemplate futuro.
				"""
		}

		reviewSubagent: {
			dispatched: false
			notes: """
				Review subagent NÃO dispatched — Path C founder-approved
				explicit single-attempt + founder review rigoroso direto
				(continuidade do pattern emergent em disp-005/disp-006).
				Para artefatos com nuances domain-specific densos
				(governance é control plane com routing/caps/calibration
				inter-relacionados), founder review direta + judgment
				call evaluation produz mais ajustes substantivos que
				review subagent isolado provavelmente geraria. Valid
				bypass per CLAUDE.md "Authoring Declarativo" P10 framing.
				"""
		}

		founderDecision: {
			outcome: "approved-with-1-mandatory-adjustment"
			notes: """
				Founder review rigoroso aplicou 5 itens de revisão
				explícitos (caps 3/50 vs 2/50; suspicious-input channel;
				6 regression triggers; promotion thresholds 25/60d e
				80/90d; onTimeout retry policy) e 1 ajuste obrigatório
				pre-write:

				Ajuste obrigatório: blastRadiusCaps.maxConcurrentMutations
				3→2. Justificativa founder: 'BDG é gateway financeiro;
				onboarding deve ser mais conservador que CTR/NPM'. Cap
				2/50 entra na canonical onboarding band 1-2/20-50 sem
				upper-end (vs ctr/npm 3/50 que estavam em upper-end).
				Promoção para 3+ é decisão futura via calibration
				crossing thresholds.

				Demais decisões discricionárias aprovadas:
				- 6 regression triggers ok (granularidade adequada para
				  gate financeiro com 2 verificationMetrics canvas
				  vinculadas + Fracionamento sem defesa estrutural primária)
				- 25/60d e 80/90d promotion thresholds ok (conservador
				  para gateway de spine commitment-lifecycle)
				- onTimeout retry só para projeções ok (gate determinístico
				  não retenta — timeout aqui é bug determinístico)
				- suspicious-input alert-and-block mantido (Fracionamento
				  é padrão coordenado; pausar autonomia per proponente
				  contém propagação cross-compromisso)
				- unclassifiable-anomaly SLA 4h ok (BDG é camada
				  orçamentária prospectiva, não criptográfica imediata)

				Resultado: agent-governance materializado em commit
				9305a53 com cap 2/50, 6 escalation routes, 5 drift
				metrics, 6 regression triggers, failureHandling per
				adr-058. WI-048 BDG BC bootstrap closed.
				"""
		}

		fallbackPathsTested: {
			cueVetFailureRetry:   false
			selfReviewFailRetry:  false
			ambiguityEscalation:  false
			manualTakeoverPath:   false
			apiTimeoutTakeover:   false
			reviewSubagentBypass: true
			notes: """
				Path C single-attempt successful sem fallbacks
				exercitados. cueVet PASSED first try (sem retry);
				API timeout não atingido (tempo total dentro de
				window típica para non-canvas workloads); review
				subagent intencionalmente bypassed per Path C +
				founder review rigoroso direto.

				reviewSubagentBypass NÃO é fallback — design choice
				per Path C definition (founder pediu single attempt
				+ review rigoroso direto). Pattern consistente com
				disp-005/disp-006 reviewBypass classification.
				"""
		}

		calibrationFindings: [
			"Path C (single attempt + founder review rigoroso direto + fallback manual no primeiro timeout) é third successful non-PG pattern (após disp-005 glossary single-shot + disp-006 domain-model self-fix em retry). Confirma viability de subagent-drafted para artefatos governance-type com densidade intermediária + cross-checks moderados (3 sections + bidirectional ref ao agent-spec).",
			"Subagent honest reporting de 3 judgment calls foi valuable — todos os items eram genuine design decisions que founder review confirmou ou ajustou. Pattern: subagent serve como first-pass design + judgment call surfacing; founder review é decision authority com domain context. Validates adr-054 dec 10 (isolation + escalation > auto-ratification) consistente em 4 non-PG dispatches successful (disp-001 PG-tension + disp-005 glossary + disp-006 domain-model + disp-007 agent-governance).",
			"HTML entity transport issue (subagent output via tool call return) é categoria distinta de cueVet failures — não-semântico, mas requer conversion pre-write. Candidate para output-format directive em promptTemplate futuro ('do not HTML-escape characters in CUE code blocks'). Não codificado como def-XXX porque é caso único + mitigation trivial; pode virar guideline para futuras dispatches.",
			"Failure rate atualizado: n=7 com 3 failures (disp-002/003/004) + 4 successful authoring (disp-001 + disp-005/006/007). disp-007 é third successful authoring sem full pipeline (review subagent bypass per Path C). Pattern emergent: para artefatos com domain-specific nuances, manual founder review é complemento robusto a subagent dispatch.",
			"WI-048 BDG BC bootstrap closed: 5 phases × 5 artefatos materializados (canvas manual + glossary disp-005 + domain-model disp-006 + agent-spec manual preventive + agent-governance disp-007). Calibração subagent-drafted final WI-048: 3 successful dispatches non-PG (60% of non-canvas non-agent-spec types) + 2 manual (canvas permanently removed per adr-074 amendment 2; agent-spec preventive given PG-A iteração rica). adr-074 rollout viability: 3/5 types successful, canvas permanently excluded, agent-spec evidence pending para futuras iterations.",
		]

		pipelineOutcome: "successful-authoring-without-full-pipeline"

		executionTimings: {
			authoringMs: 395215
			reviewMs:    0
			totalMs:     395215
		}
	}, {
		dispatchId:   "disp-008"
		workItem:     "WI-060"
		date:         "2026-05-04"
		target:       "contexts/ssc/glossary.cue"
		artifactType: "glossary"

		authoringSubagent: {
			dispatched:     true
			subagentType:   "general-purpose"
			result:         "success"
			cueVetAttempts: 1
			cueVetExitCode: 0
			notes: """
				Quarto non-PG dispatch successful — primeiro non-PG em
				WI-060 SSC bootstrap (Phase 2). Glossary é segundo
				dispatch successful do tipo (após disp-005 BDG glossary)
				— confirma adr-074 Known gap pattern: glossary é
				estruturalmente baixa-média densidade, viável within API
				timeout window. PG glossary aplicado section-by-section
				(3 sections per workOrder). 19 terms propostos no draft
				inicial cobrindo: 4 entities (Decisão de Sourcing + 3
				subtipos), 2 processes (RFQ + Equalização TCO), 3
				classifications (Categoria de Compra + Fornecedor
				Qualificado + Fracionamento), 1 role (Category Manager),
				2 values (FitnessSignals + DecisionRationale), 1 rule
				(Fitness Rules), 6 events (3 decisão + 3 RFQ lifecycle).

				Subagent honestly flagged em reasoning report: 19 terms
				é alto vs cmt 14, bdg 15 — justificável dado que 3
				subtipos de Decisão de Sourcing requerem terms separados
				per bd-decision-type-is-declared-upfront (binding
				regimes distintos em P2P). Anti-mini-NIM rigorously
				enforced: ReputationScore + RiskRating excluídos como
				antiTerms em FitnessSignals; Scoring Algorithm +
				Heurística como antiTerms em FitnessRules. Loanword
				preservation following bdg/idc precedent (RFQ, Strategic
				Award, Category Manager, FitnessSignals, FitnessRules,
				TCO, Fragmentation). Cross-BC vocabulary consistency:
				term-fracionamento mirrors bdg para vetor adversarial
				análogo.

				Issue de transporte (não-semântico): subagent retornou
				HTML entities (&amp;/&lt;/&gt;) em string output — pattern
				idêntico a disp-007. Conversão para caracteres reais
				aplicada pre-write pelo main agent. Categoria de feedback
				possivelmente endereçável por output-format directive em
				promptTemplate futuro. Recurrence em disp-007 + disp-008
				sugere que advisory directive seria útil; não codificar
				ainda como def-XXX (sample N=2 insuficiente para
				justificar mecanismo formal).
				"""
		}

		reviewSubagent: {
			dispatched: false
			notes: """
				Review subagent NÃO dispatched — founder optou por review
				direto + 9 ajustes substantivos pre-write em batch. Valid
				bypass per CLAUDE.md "Authoring Declarativo" P10 framing:
				founder approval gate final em todos os casos. Pattern
				consistente com disp-005/006/007: para artefatos com
				domain-specific nuances densas (UL é especialmente
				sensível a subtle policy/protocol creep), founder review
				direta é complemento robusto a subagent dispatch.
				"""
		}

		founderDecision: {
			outcome: "approved-with-9-adjustments-batch"
			notes: """
				Founder review pre-write aplicou 9 ajustes substantivos
				em batch (não rounds iterativos) para separar UL de
				protocol/integration policy:

				1. term-strategic-award: definition simplificada
				   (protocolo de janela [StrategicAward, ContractActivation]
				   move para domain-model + integration policy)
				2. term-category-manager: definição genérica resiliente
				   a evoluções operacionais; Phase 0 caveats movem para
				   rationale como nota operacional
				3. term-fornecedor-qualificado: category role →
				   classification (gate de elegibilidade aplicado a role,
				   não role em si)
				4. term-fracionamento: category rule → classification
				   (workaround para schema #TermCategory que não inclui
				   'anti-pattern' enum; dívida explícita registrada)
				5-9. Refs a oq-ssc removidas de definitions onde não-
				     essenciais — mantidas em rationale onde context
				     Phase 0 é necessário (term-fitness-signals
				     mantém oq refs em definition pois essenciais para
				     entender camada optionalPhase0)

				Materializado em 2 commits incrementais per founder
				request 'dívida em 2 partes': part 1 (8 terms — anchor +
				process + roles, commit 9fcc407) + part 2 (11 terms —
				machinery + events + adversarial, commit c5bdc83).
				cue vet ./... EXIT=0 em ambos commits intermediários.
				"""
		}

		fallbackPathsTested: {
			cueVetFailureRetry:   false
			selfReviewFailRetry:  false
			ambiguityEscalation:  false
			manualTakeoverPath:   false
			apiTimeoutTakeover:   false
			reviewSubagentBypass: true
			notes: """
				Single-attempt successful sem fallbacks de recovery
				exercitados. cueVet PASSED first try (sem retry); API
				timeout não atingido (glossary é estruturalmente baixa-
				média densidade); review subagent intencionalmente
				bypassed per founder choice + review direto + 9 ajustes
				batch.

				reviewSubagentBypass NÃO é fallback — design choice.
				Pattern consistente com disp-005/006/007 reviewBypass
				classification.
				"""
		}

		calibrationFindings: [
			"Quinto dispatch successful overall (disp-001 + disp-005/006/007/008); quarto non-PG successful authoring. Glossary é segundo do tipo (após disp-005 BDG glossary) — confirma reusabilidade do pattern: glossary é candidato consistente para subagent-drafted dada densidade estrutural baixa-média + cross-checks limitados (3 sections + intra-glossary refs).",
			"HTML entity transport issue agora N=2 (disp-007 + disp-008). Sample ainda insuficiente para codificar como def-XXX, mas pattern recorrente sugere que advisory directive em promptTemplate seria útil ('do not HTML-escape characters in CUE code blocks'). Reavaliar pós-disp-009 ou disp-010.",
			"Founder review batch (9 ajustes em uma rodada vs rounds iterativos) é pattern emergente útil para artefatos onde founder tem clareza completa do escopo a priori (post-Q1-Q10 para SSC). Distinto de pattern bdg-glossary onde founder optou por 3-cycle red team em rounds iterativos. Trade-off: batch é eficiente quando issues são identificáveis no draft; iterativo é mais robusto quando issues emergem da própria revisão.",
			"Schema #TermCategory limitação reconhecida em term-fracionamento (workaround classification para conceito que seria mais bem modelado como anti-pattern). Dívida explícita registrada em rationale do termo + rationale outer. Não codificado como tension entry (would be over-modeling para schema gap singular); reavaliar se múltiplos BCs subsequentes encontrarem o mesmo gap.",
			"Materialização em 2 commits incrementais per founder request: part 1 (anchor+process+roles) + part 2 (machinery+events+adversarial). Pattern útil para review granular — cada parte estabelece subset coerente de UL com cue vet válido. Reusável para futuros glossaries grandes (>15 terms).",
		]

		pipelineOutcome: "successful-authoring-without-full-pipeline"

		executionTimings: {
			authoringMs: 357092
			reviewMs:    0
			totalMs:     357092
		}
	}]

	// Métrica observable derivada (calculada por leitura do log;
	// runner futuro pode automatizar quando volume justificar).
	currentMetrics: {
		totalDispatches:    8
		successfulPipeline: 1
		failureRate:        0.375 // 3/8 failures (disp-002 + disp-003 + disp-004)
		fallbacksExercised: 5 // disp-002 cascade + disp-003 manual + disp-004 manual + disp-005 cueVetRetry + disp-006 cueVetRetry
		failureBreakdown: {
			cascadeOrdering: 1 // disp-002
			apiTimeout:      2 // disp-003 + disp-004
		}
		notes: """
			Failure rate: amostra (n=8) com 3 failures + 1 pipeline
			successful (WI-069 PG-tension-entry) + 4 successful authoring
			sem full pipeline (disp-005 glossary BDG + disp-006 domain-model
			BDG + disp-007 agent-governance BDG + disp-008 glossary SSC —
			review subagent intencionalmente bypassado por escolha founder
			de manual review + judgment call evaluation direta).
			Honest distinction: successfulPipeline conta apenas authoring →
			review → founder approval completo; disp-005/006/007/008 são
			successfulAuthoring mas não successfulPipeline pelo bypass
			deliberado de review subagent. fallbacksExercised conta apenas
			recovery from failure (cascade escalation, manual takeover,
			cueVetRetry); reviewBypass é design choice, não recovery.

			disp-005/006/007/008 confirmam adr-074 Known gap pattern:
			subagent-drafted viável para artefatos com baixa-média
			densidade estrutural + cross-checks limitados (glossary 3
			sections + domain-model 3 sections + agent-governance 3
			sections; canvas 8 sections falha consistentemente).
			cueVetFailureRetry pattern exercitado em disp-005 + disp-006
			(2/4 successful non-PG); disp-007/008 single-attempt sem
			retry (cueVet PASSED first try).

			Glossary é segundo tipo successful em multiple BCs (BDG +
			SSC) — pattern reusável confirmado: 3 sections + intra-
			glossary refs + cross-BC vocabulary consistency.

			HTML entity transport issue recorrente N=2 (disp-007 +
			disp-008) — calibration finding sugere advisory directive
			em promptTemplate; reavaliar pós N=3+.

			WI-048 BDG BC bootstrap CLOSED com disp-007. WI-060 SSC
			bootstrap em progresso: Phase 1 canvas (manual, 4 commits)
			+ Phase 2 glossary (disp-008, 2 commits) DONE; Phases 3-5
			(domain-model, agent-spec, agent-governance) pending.
			"""
	}
}
