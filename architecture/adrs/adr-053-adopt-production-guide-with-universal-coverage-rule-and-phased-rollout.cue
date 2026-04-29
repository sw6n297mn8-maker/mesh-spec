package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-053 — Adoção universal de #ProductionGuide com phasing.
//
// PARTIAL — commit 1 da sequência (scaffold).
// Metadata estrutural completa (id, title, date, decisionClass, decider,
// status, reversibility, blastRadius, affectedArtifacts, derivedArtifacts,
// principlesApplied). context, decision, consequences e rationale com
// placeholders TBD a serem substituídos em commits 2 e 3.

adr053: artifact_schemas.#ADR & {
	id:    "adr-053"
	title: "Adopt #ProductionGuide with universal coverage rule and phased rollout"
	date:  "2026-04-27"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		Mesh-spec opera padrão "schema + exemplares" para orientar autoria de
		instâncias: 24 artifact-schemas em architecture/artifact-schemas/ com
		comments e _qualityCriteria; 53 instâncias de lens em
		architecture/lenses/ servindo como referência implícita;
		architecture/design-principles.cue (P0–P12) e domain-definition.cue
		(ax-XX, dp-XX) para princípios cross-cutting; sem
		architecture/production-guides/.

		O padrão funciona enquanto autores núcleo conhecem convenções
		tácitas e o volume de novas instâncias por tipo é baixo. Tensiona
		quando: (a) novos contributors humanos ou agentes chegam sem
		contexto tácito; (b) tekton-spec/portfolio (upstream cross-repo
		registrado em governance/adopted-artifacts.cue) define convenção
		"schema instanciável tem guide" — mesh acumula drift implícito;
		(c) decisões de produção (workOrder, gapPolicy, prerequisites,
		heuristics, doneCriteria) ficam invisíveis fora da memória do
		autor original.

		Schema sozinho não documenta: ordem de preenchimento, política de
		lacunas, pré-requisitos, process steps acionáveis, heurísticas de
		qualidade, doneCriteria. Para schemas com 50+ instâncias autoradas
		(lens), padrões SÃO inferíveis empiricamente — mas a extração ainda
		exige inferência por similaridade, frágil para novo autor ou agente
		sem treino prévio.

		Tekton-spec/portfolio publicou schema #ProductionGuide
		(portfolio/artifact-schemas/production-guide.cue, sourceVersion
		"0.3.0", commit 919f3e886e76ce4b57c951cae2a5a53e5bce7d03). Auster-spec
		adotou verbatim e materializou meta-guide próprio
		(architecture/production-guides/production-guide.cue) após 3 ciclos
		de red team. Mesh adota o mesmo schema verbatim e adapta o meta-guide
		auster mecanicamente — custo de adaptação é baixo, ganho é meta-guide
		validado servindo de base para os ~24 guides subsequentes.

		Alternativas avaliadas:
		(a) Selective adoption — guides apenas para schemas autorais
		complexos, exemption para triviais. Rejeitada: cria categoria
		"schema isento" que precisa governança própria, debate por categoria,
		drift potencial entre critério de exemption e prática autoral.
		(b) Implicit adoption — codificar pattern atual sem
		production-guides/. Rejeitada: não resolve gap de novos
		autores/agentes, perpetua dependência de inferência por similaridade,
		mantém drift estrutural com convenção upstream.
		(c) Adoção lazy — guide quando primeira instância surgir. Rejeitada:
		schemas sem guide já existem; lazy adoption tipicamente vira never
		adoption.
		(d) Apenas lens.cue — guide para o schema com maior volume de
		instâncias. Rejeitada: deixa lacuna em outros schemas autorais
		complexos (domain-model, context-map, agent-governance).

		Founder optou por adoção universal por convenção, com structural-check
		1:1 deferido para ADR posterior por blast radius próprio (desenho de
		novo kind de structural-check, segue padrão adr-041 → adr-049).
		"""
	decision: """
		(1) ADOTAR VERBATIM o schema #ProductionGuide de
		tekton-spec/portfolio em
		architecture/artifact-schemas/production-guide.cue, registrando
		entry concomitante em governance/adopted-artifacts.cue
		(sourceRepo: sw6n297mn8-maker/tekton-spec, sourcePath:
		portfolio/artifact-schemas/production-guide.cue, sourceVersion:
		"0.3.0", sourceCommitHash:
		919f3e886e76ce4b57c951cae2a5a53e5bce7d03, adoptionMode: verbatim).

		(2) ADAPTAR e materializar o meta-guide de auster-spec em
		architecture/production-guides/production-guide.cue (instância de
		#ProductionGuide local). Adaptações são mecânicas: trocar referências
		"auster" por "mesh" no header e no rationale de _schema.location;
		atualizar campo `sources` em sections para apontar para
		tekton-spec/portfolio/production-guides/ (cross-repo discipline,
		evita coupling com auster); preservar package
		(production_guides), variable name (productionGuideGuide),
		canonicalPathRegex e quality criteria (tq-pgpg-01..04). Referências
		upstream preservadas por adoção verbatim.

		(3) REGRA UNIVERSAL POR CONVENÇÃO: todo artifact-schema em
		architecture/artifact-schemas/ que admite instâncias autoradas
		(humano ou agente) tem production guide correspondente em
		architecture/production-guides/ com mesmo basename. Convenção 1:1
		binária. Sem campo `isInstantiable` no #ArtifactSchema (mesh segue
		auster e tekton em não formalizar a categoria); cobertura é avaliada
		por convenção operacional + revisão por founder em Fase 0.

		(4) GUIDES TRIVIAIS SÃO ACEITÁVEIS E ESPERADOS. Para schemas simples
		(3-5 campos), guide pode ser 30-50 linhas com 1 section, 3-5 process
		steps, gapPolicy mínima, finalValidation com submissão ao founder.
		"Existir" ≠ "ser elaborado". Regra é cobertura, não profundidade
		uniforme.

		(5) SEM _exemptions.cue. Decisão derivada da regra universal —
		como não há schemas isentos, não há lista de exceções a manter.

		(6) PHASING POR PRIORIZAÇÃO (ordem, não exclusão):
		Fase 1 — alto volume autoral / cross-eixo: lens, adr,
		agent-governance.
		Fase 2 — domain modeling cluster: domain-model, context-map,
		domain-definition, subdomain, glossary, stakeholder-map.
		Fase 3 — engineering interfaces: service-contract,
		cross-context-flow, agent-spec, api-spec.
		Fase 4 — operacionais e meta (guides minimalistas obrigatórios):
		task-template, wave-plan, tension-entry, structural-check,
		validation-prompt, canvas, quality-criteria, readme-config,
		repo-structure, adopted-artifacts, artifact-schema, demais.
		Fase 4 não é opcional — apenas reflete que o conteúdo dos guides é
		minimalista para schemas triviais.

		(7) STRUCTURAL-CHECK DE COBERTURA 1:1 É DÍVIDA PLANEJADA, NÃO
		ENTREGÁVEL DESTE ADR. Tekton-spec ainda não publicou check
		análogo em portfolio/structural-checks/; design do kind necessário
		(file-pair-coverage entre dois diretórios) tem implicações próprias
		no framework de structural-check (segue padrão adr-041 → adr-049).
		Critério de ativação: após mesh ter ≥3 production guides commitados,
		auditar drift; se >0 incidentes de schema sem guide em N commits
		consecutivos, materializar gate em ADR próprio. Em Fase 0, founder
		review em sessão substitui o gate determinístico.

		(8) SCHEMAS FUTUROS (POST-ADR): regra universal aplica desde criação.
		PR ou commit que introduza novo artifact-schema deve incluir guide
		correspondente no mesmo PR. Em Fase 0, enforcement é por
		founder review; em fase posterior, por structural-check.

		(9) ESTA DECISÃO NÃO SUBSTITUI O ECOSSISTEMA "schema + exemplares" —
		adiciona camada de orientação explícita. Exemplares (53 lenses, etc.)
		continuam servindo como referência por similaridade. Production guides
		explicitam o que era inferível.

		(10) TRIGGERS DE RE-EVALUATION: (R1) custo de manutenção dos ~24
		guides exceder benefício mensurado (drift caught, onboarding time,
		variance de qualidade); (R2) emergência de schema que
		fundamentalmente não admite guide (cenário hoje hipotético).
		"""
	consequences: "TBD — consequences substantivo em commit 3 da sequência."

	reversibility: "medium"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"architecture/artifact-schemas/production-guide.cue",
		"architecture/production-guides/production-guide.cue",
		"governance/adopted-artifacts.cue",
		"governance/readme/config.cue",
	]

	derivedArtifacts: [
		"README.md",
	]

	principlesApplied: [
		"P0",
		"P10",
		"P12",
	]

	rationale: "TBD — rationale substantivo em commit 3 da sequência."
}
