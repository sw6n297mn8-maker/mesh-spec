package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-053 — Adoção universal de #ProductionGuide com phasing.
//
// Materializado em 3 commits sequenciais (scaffold → context+decision →
// consequences+rationale).

adr053: artifact_schemas.#ADR & {
	id:    "adr-053"
	title: "Adopt #ProductionGuide with universal coverage rule and phased rollout"
	date:  "2026-04-27"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

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
		canonicalPathRegex e quality criteria (renomeados de tq-pgpg-01..04
		para tq-mg-01..04 para conformidade com regex
		^(uq|tq-[a-z]{2,3})-[0-9]{2}$ de #QualityCriterion.id em
		mesh; conteúdo preservado verbatim). Referências
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
	consequences: """
		Positivas:

		(P1) Eliminação por construção do drift implícito com convenção
		tq-as-05 do portfolio upstream — regra universal garante satisfação
		100%.

		(P2) Onboarding de novos autores (humanos ou agentes) reduz de "ler
		múltiplos exemplares para inferir patterns" para "ler 1 guide".

		(P3) Variance de qualidade entre instâncias do mesmo schema é reduzida
		— guide nivela.

		(P4) Decisões de produção (gapPolicy, workOrder, heuristics) viram
		artefato auditável em vez de memória tácita.

		(P5) Cobertura é binária e verificável quando structural-check for
		materializado em ADR posterior; em Fase 0, é verificável por
		founder review.

		(P6) Princípio "regras universais > juízo casuístico" reforçado
		(consistente com filosofia de schemas e lenses em mesh).

		(P7) Forward-compat: schemas futuros nunca quebram a regra; guide é
		parte da definição de "schema completo".

		(P8) Adoção verbatim de schema cross-repo preserva coerência
		portfolio-wide e evita reinvenção local.

		Negativas:

		(N1) Custo de autoria inicial: ~24 guides em fases. Estimativa 80–150
		horas de trabalho autoral total entre triviais e complexos. Mitigação:
		phasing prioriza alto-valor; triviais em batch.

		(N2) Manutenção: schemas evoluem → guides desincronizam. Mitigação:
		convenção de "schema + guide no mesmo PR" + structural-check em fase
		posterior.

		(N3) Curva de aprendizado: autores acostumados a referência por
		exemplar precisam adaptar para guide-driven authoring.

		(N4) Risco de guides "fantasma" sem substância real para schemas
		triviais — guide existe mas não orienta nada além do óbvio. Aceito
		como custo de regra universal; alternativa selective tem custos
		próprios maiores (item (a) em context).

		(N5) Em Fase 0 (sem structural-check), enforcement depende de
		disciplina + founder review. Risco mitigado pelo critério de ativação
		do gate determinístico (decision item 7).
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"governance/adopted-artifacts.cue",
		"governance/readme/config.cue",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/production-guide.cue",
		"architecture/production-guides/production-guide.cue",
	]

	derivedArtifacts: [
		"README.md",
	]

	principlesApplied: [
		"P0",
		"P10",
		"P12",
	]

	rationale: """
		P0 (localização canônica única) é o princípio motivador central.
		Production guide é localização canônica única para "como produzir
		instância de schema X". Ausência cria dispersão (orientação inferida
		de exemplares + memória tácita + leitura cruzada de schema),
		violando P0 por construção. O guide não duplica conteúdo do schema
		(não copia tipos, constraints, _qualityCriteria); adiciona camada
		distinta (process, gapPolicy, heuristics, doneCriteria) que não
		vive em outro lugar.

		P10 (agentes recomendam, gates determinísticos validam) sustenta a
		arquitetura em duas camadas: convenção operacional + founder review
		em Fase 0; structural-check determinístico em fase posterior. P10
		proíbe LLM como gate (per ten-006 e adr-040); o ADR respeita ao
		manter gate humano explícito enquanto o gate determinístico é
		desenhado em ADR próprio.

		P12 (governança como código) sustenta a forma do guide: instância
		CUE conformante a #ProductionGuide, não markdown narrativo.
		Verificável estruturalmente, evolui via diff, auditável.

		Adoção verbatim (decision item 1) segue precedente estabelecido por
		adr-050 (#ReadmeConfig) e adr-052 (#RepoStructure): mesh consome
		schemas de tekton-spec/portfolio com double-anchor version+commit
		hash em adopted-artifacts.cue. Sem reinvenção local.

		Reversibility "medium": ~24 guides materializados ao longo de fases
		criam acoplamento (cada schema vinculado a guide; cada PR de schema
		toca guide). Reverter a regra exige (a) decidir quais guides
		desativar, (b) reintroduzir orientação substituta, (c) atualizar
		convenção e (eventual) structural-check. Custo modesto se feito early
		(antes da Fase 1 produzir muitos guides); cresce com volume.

		BlastRadius "repo-wide": regra governa todo schema futuro de mesh.
		Mudança em um schema requer touch em guide. Onboarding de novo
		autor/agente muda. Toolchain (CI, eventual structural-check) muda.

		Lenses consultadas: lens-real-options (phasing como sequência de
		gates de decisão; cada fase compra opção sobre se a regra continua
		gerando valor), lens-technical-debt-as-strategic-instrument (drift
		entre convenção upstream e prática local é debt deliberada;
		registro do trigger de structural-check converte em
		deliberate-prudent), lens-organizational-resource-allocation
		(priorização das 4 fases por valor autoral por unidade de esforço).

		Trade-off com P0 explicitamente avaliado: o guide é nova camada,
		não cópia de informação existente. Sem tensão registrada com axiomas
		(ax-XX) de domain/domain-definition.cue.
		"""
}
