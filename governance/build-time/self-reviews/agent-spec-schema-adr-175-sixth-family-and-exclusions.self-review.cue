package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

agentSpecSchemaAdr175SixthFamilyAndExclusions: build_time.#SelfReviewReport & {
	reportId: "srr-agent-spec-schema-adr-175-sixth-family-and-exclusions"

	artifactPath:       "architecture/artifact-schemas/agent-spec.cue"
	artifactSchemaPath: "architecture/artifact-schemas/agent-spec.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-13"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — self-review da extensão do #AgentSpec (adr-175): (a) 6ª
			família domainServices?: [...#DomainServiceRef] no #OperationalScope
			(opcional, mesmo padrão das 4 famílias opcionais existentes;
			#DomainServiceRef novo na seção REFS com o regex canônico svc-);
			(b) scopeExclusions?: [...#ScopeExclusion] no #AgentSpec, união
			discriminada por campo (#ScopeExclusionById {ref, rationale} |
			#ScopeExclusionByClass {class, rationale, refs}) — a forma por-id e
			a forma por-classe são disjuntas por construção (defs fechadas: a
			presença de 'class'/'refs' vs 'ref' decide o branch sem ambiguidade).

			[uq-08]: cue vet EXIT=0 no package; ambos os campos novos opcionais
			— NENHUMA instância existente quebra (mudança aditiva; os 12
			agent-specs do repo permanecem válidos sem edição). [uq-05]:
			premissa declarada nos comentários — exclusão é decisão com
			rationale, nunca omissão; critério de legitimidade apontado ao
			adr-175 (ponteiro, não cópia — P0/uq-04). [uq-07]: zero
			placeholder. [uq-03]: refs internas resolvem (#DomainModelRef,
			#NonEmptyString existentes; #DomainServiceRef criado junto).
			Doutrina de fora-do-escopo (vo-/ent-/qry- via parent, mod-
			organizacional, pol- runtime) vive no adr-175 e no comentário da 6ª
			família — não duplicada em campo.

			Observação registrada (não-finding): tq-ag-01 do _qualityCriteria
			deste schema segue citando '(aggregates, commands, events,
			invariants)' — prosa pré-existente que já omitia projections antes
			desta fatia; correção pertence à higiene de agent-specs (WI-154/155
			tocam instâncias; o texto do critério é candidato a ajuste editorial
			futuro), não a esta mudança aditiva.
			"""
	}]

	findings: {}

	summary: """
		Extensão aditiva do #AgentSpec per adr-175: 6ª família domainServices
		no #OperationalScope + scopeExclusions com duas formas (por id e por
		classe, discriminadas por campo). Nenhuma instância existente quebra
		(campos opcionais); cue vet EXIT=0. VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: mudança aditiva de schema com desenho
		pré-cravado pelo founder (6 famílias, duas formas de exclusão) e
		revisão de arquiteto prévia sobre as peças de maior blast; este round
		confirmou conformância, disjunção sem ambiguidade e retrocompatibilidade
		das 12 instâncias.
		"""
}
