package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

contextMapSchema: build_time.#SelfReviewReport & {
	reportId: "srr-context-map-schema"

	artifactPath:       "architecture/artifact-schemas/context-map.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-31T00:00:00Z"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		Schema fornecido pelo founder após design com 3 lenses analíticas
		(DSD, EDA, Domain Language) e 4 rounds de red team na sessão
		anterior. Versão final incorpora refinamentos estruturais do
		founder: union de patterns para tq-cm-04/tq-cm-07,
		subdomainOwnership explícito para tq-cm-06, hooks de unificação
		para tq-cm-09/tq-cm-11. Todos os critérios universais e
		type-specific passam na primeira avaliação sem findings.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 avaliou schema #ContextMap contra critérios universais
			(uq-01 a uq-08) e type-specific (tq-as-01 a tq-as-03).
			(uq-01) rationales explicam WHY em todos os 11 quality criteria,
			nos tipos #SubdomainOwnership, #BaseRelationship e nas 8
			variantes de relação. (uq-02) schema referencia conceitos
			Mesh-specific: wave plan, cross-context flows, subdomínios com
			ownership por BC. (uq-03) reusa #BoundedContextRef (definido em
			cross-context-flow.cue) e #SubdomainRef (definido em
			subdomain.cue) — redefinições idênticas no mesmo package,
			CUE unifica sem conflito; #CrossContextFlowRef definido pela
			primeira vez neste arquivo. (uq-04) subdomainOwnership reforça
			P0 (single source of truth); union de patterns alinha com
			dp-01 (evidência verificável — combinações inválidas não
			compilam). (uq-05) header documenta que tq-cm-09 e tq-cm-11
			dependem de unificação cross-artifact; tq-cm-06 declara
			dependência de runner para cobertura total. (uq-06) terminologia
			consistente: bounded context, subdomain, upstream/downstream
			pattern, ownership. (uq-07) zero placeholders. (uq-08)
			_schema.location completo com todos os campos obrigatórios,
			_qualityCriteria presente com 11 critérios. (tq-as-01)
			_schema.location tem canonicalPathRegex, fileNameRegex,
			description, rationale, cardinality, allowNested. (tq-as-02)
			todos os 11 critérios têm tests concretos e acionáveis — tq-cm-04
			verifica instanciação do union, tq-cm-06 verifica ownership
			explícito com nota sobre cobertura por unificação, tq-cm-09 e
			tq-cm-11 verificam hooks de unificação quando preenchidos.
			(tq-as-03) rationale do conjunto cobre 4 eixos: integridade
			estrutural, ownership explícito, compatibilidade de patterns,
			hooks para unificação cross-artifact. Zero findings.
			"""
	}]

	findings: {}

	summary: """
		Schema #ContextMap estável no round 1. Design orientado pelo
		founder com 3 lenses e 4 rounds de red team prévios. Inovação
		principal: compatibilidade de patterns (tq-cm-04) e simetria
		(tq-cm-07) viram regra de tipo via union estrutural de 8
		variantes (#OHSACLRelationship, #OHSConformistRelationship,
		#OHSPLACLRelationship, #OHSPLConformistRelationship,
		#PublishedLanguageACLRelationship,
		#PublishedLanguageConformistRelationship,
		#PartnershipRelationship, #SharedKernelRelationship).
		subdomainOwnership torna single-ownership explícito e tipável.
		expectedContexts e knownFlows são hooks para unificação
		cross-artifact com wave plan e catálogo de flows. 11 critérios
		de qualidade (9 fail, 2 warn) cobrem integridade referencial,
		ownership, patterns, identidade de relações e rastreabilidade
		a flows. Separação honesta entre o que é tipo (patterns,
		simetria), unificação (ownership total, cobertura wave plan,
		validade de flowRefs) e runner (unicidade de codes, BCs
		isolados).
		"""
}
