package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr078: artifact_schemas.#ADR & {
	id:    "adr-078"
	title: "PG canvas Section 8 hardening — operationalize metric classification (control vs observability-only) per ADR-077"
	date:  "2026-05-06"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		ADR-077 (commit 8d964fd) adicionou #VerificationMetric.onBreach
		field + tq-cv-14 quality criterion estabelecendo regra
		'ausência de onBreach NÃO é oversight = observability-only
		design choice'. PG canvas Section 8 (epistemic-and-validation)
		NÃO foi atualizado — process action 'Declarar verificationMetrics
		com targets' permanece sem guidance sobre quando usar onBreach.

		Risco identificado pos-ADR-077: agentes seguindo PG section-by-
		section vão classificar metrics inconsistentemente, criando
		fabricação simétrica:
		(a) forçar onBreach em todas metrics 'para completar canvas'
		    (anti-pattern de fabricação direta)
		(b) omitir onBreach indiscriminadamente sem articular design
		    choice (anti-pattern de fabricação reversa via silêncio)
		(c) criar escalationCriteria sintéticas só para satisfazer
		    metrics que 'precisariam' de onBreach (anti-pattern de
		    fabricação reversa via inflation de escalations)

		WI-053 INV Phase 1.8 + 1.9 estabeleceu pattern empírico
		funcional (3 control + 3 observability-only com rationale
		explícito) MAS sem PG operacionalização, agentes futuros
		bootstrapping outros BCs vão recriar a decisão ad-hoc com
		consistência variável cross-BC.
		"""

	decision: """
		ADOPT 7 mudanças coordenadas em PG canvas Section 8:

		(D1) Objective expandido — diferenciar 'control metrics' (com
		     ação automática via escalation) vs 'observation metrics'
		     (sem ação automática, dependentes de análise humana).
		     Frame mental do agente reorientado.

		(D2) Process expandido em fluxo de decisão 5-step para CADA
		     verificationMetric: identificar tipo (violação direta vs
		     degradação indireta) → verificar escalationCriterion
		     canônico se control → declarar onBreach.escalationRef OR
		     classificar observability-only → default observability-only
		     em caso de dúvida → garantir consistency. Sub-regra crítica:
		     escalationCriterion canônico ausente NÃO autoriza criação
		     prematura — criar APENAS se ação corretiva for determinística
		     e bem definida; caso contrário, classificar metric como
		     observability-only (anti-pattern: criar escalation
		     prematuramente para 'completar' classification flow).

		(D3) Heurísticas com 3 blocos: use onBreach quando + NÃO usar
		     onBreach quando + 4 anti-patterns. Wording 'NÃO usar
		     onBreach' refinado: 'métrica sem threshold crítico claro'
		     (NÃO 'métrica agregada' — pushback empírico vm-inv-2 INV
		     é agregada com threshold determinístico legítimo).

		(D4) Princípio many-to-one explícito (per ADR-077 link
		     unidirecional metric → escalation): múltiplas metrics
		     apontando para mesma escalation quando indicam mesmo
		     failure mode é DESEJÁVEL. Criar escalation dedicada por
		     metric é anti-pattern estrutural, MESMO quando metrics
		     parecem distintas — se convergem em mesmo failure mode,
		     convergem para mesma escalation. Previne proliferação
		     escalations sintéticas + drift semântico.

		(D5) Promotion path EXPLÍCITO para observability-only candidatas
		     a control Phase 1+: rationale DEVE indicar explicitamente
		     possibilidade quando aplicável. NÃO promover para control
		     sem evidência empírica de causalidade estável e
		     reproduzível — bloqueia 'acho que dá pra automatizar' +
		     promoção prematura.

		(D6) Heuristic 'no dead paths' para escalationCriteria: toda
		     escalationCriterion deve ter pelo menos um caminho de
		     ativação EXPLÍCITO E VERIFICÁVEL — evento/invariante
		     direto OU metric com onBreach. Escalation sem trigger
		     observável é inválida (não conceitual; verificável).

		(D7) doneCriteria + finalValidation strengthened: cada
		     verificationMetric explicitamente classificada (control
		     com onBreach OR observability-only com rationale); toda
		     metric com onBreach referencia escalationCriterion válido;
		     nenhuma metric com ligação ambígua; finalValidation step
		     verifica consistency metric→escalation + nenhuma
		     observability-only com ação implícita + nenhuma
		     duplicação desnecessária + no dead paths.

		3-layer governance pattern (BDs invariantes + escalations
		actions + metrics sensors) IDENTIFICADO como insight maior mas
		DEFERRED — não expande scope ADR-078; registrado como input
		para WI canvas-schema-hardening + lens-governance-loop futura.
		"""

	consequences: """
		(a) Agentes futuros bootstrapping BCs decidem classificação
		    metric (control vs observability-only) via algoritmo
		    determinístico, NÃO heurística ad-hoc. Consistency
		    cross-BC garantida por construção.

		(b) Anti-padrão fabricação simétrica bloqueado em 4 vetores:
		    (b1) forçar onBreach 'para completar' → bloqueado por
		         heurística 'default = observability-only em dúvida'
		    (b2) omitir onBreach indiscriminadamente → bloqueado por
		         doneCriteria 'rationale explícito por que não há
		         ação automática'
		    (b3) criar escalations sintéticas → bloqueado por
		         many-to-one + 'no dead paths' + sub-regra D2 'criar
		         escalationCriterion APENAS se causalidade
		         determinística'
		    (b4) promoção prematura observability-only → control →
		         bloqueada por 'evidência empírica de causalidade
		         estável e reproduzível' (D5)

		(c) Backfill 8 canvases existentes (WI separado canvas-schema-
		    hardening) ganha algoritmo claro — agente reviewing CMT,
		    BDG, DLV, IDC, NPM, P2P, SSC, CTR aplicará 5-step process
		    + heuristics consistentemente.

		(d) Phase 2 promoção potencial (metric.type enum, escalation.
		    triggeredBy formalizado, haltConditions schema field,
		    lens-governance-loop) tem terreno preparado: 2 categorias
		    operacionais + many-to-one princípio + no-dead-paths
		    heuristic são parsing-friendly para schema fields.

		(e) PG mod é guidance (não schema constraint); reversibility
		    high — refinements futuros via ADRs incrementais sem
		    breaking. Não há migration cost para canvases existentes
		    (PG governa authoring future, não retrofits estado atual).

		(f) 3-layer governance pattern (BDs invariantes + escalations
		    actions + metrics sensors) identificado como insight
		    arquitetural maior — candidato a lens-governance-loop
		    Phase 1+ aplicável além de canvas (envelope, agent-spec,
		    structural-check). Out of scope ADR-078; registrado como
		    input para WI futuro.
		"""

	reversibility: "high"
	blastRadius:   "local"

	affectedArtifacts: [
		"architecture/production-guides/canvas.cue",
	]

	plannedOutputs: []

	derivedArtifacts: []

	principlesApplied: [
		"P1-canonical-cue-source",
		"P10-deterministic-gates-vs-stochastic-recommendations",
		"adr-040-structural-vs-semantic-validation-separation",
		"adr-057-manualAuthoringProtocol-section-gates",
		"adr-077-canvas-metric-onbreach-field",
	]

	rationale: """
		Reversibility high: PG mod é guidance authoring — refinements
		futuros via ADRs incrementais sem breaking estrutural;
		canvases existentes não exigem migration. BlastRadius local:
		PG canvas único guide; não afeta outros artifact types nem
		schemas. Mod é instanciação process-level de decisão estrutural
		ADR-077 — fecha gap operacional sem inflar scope. Pushback
		empírico em wording original (métrica agregada → métrica sem
		threshold crítico) preserva poder expressivo (vm-inv-2 INV é
		agregada com threshold determinístico, deve ter onBreach).
		Manter 2 categorias formais (control + observability-only)
		com promotion path em rationale evita inflar taxonomia sem
		perder semântica de evolução. Many-to-one + no-dead-paths +
		sub-regra D2 'criar escalation APENAS se causalidade
		determinística' fecham 4 vetores fabricação simétrica.
		3-layer governance insight DEFERRED preserva disciplina de
		escopo — implementar agora seria erro de escopo via lens
		não-validada empiricamente.
		"""
}
