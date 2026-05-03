package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr072: artifact_schemas.#ADR & {
	id:    "adr-072"
	title: "Extend artifact_type_for_path to cover canvas instances"
	date:  "2026-05-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		State-of-affairs precedente:
		- adr-060 estabeleceu pattern progressivo para
		  artifact_type_for_path em scripts/ci/check-self-review.sh.
		- adr-066/067/068/069 cobriram deferred-decision +
		  production-guide + structural-check + validation-prompt.
		- adr-070 promoveu #BootstrapException a schema first-class
		  (category + lifecycle + exitCondition?); adr-071 adicionou
		  trigger kind file-content-occurrence-count usado por
		  def-012.
		- def-011 RESOLVED por adr-070 (SKIPPED pelo runner; sem
		  refire). def-012 monitora crescimento de transient bootstrap
		  exceptions (threshold=20, baseline=14).
		- Canvas é o BC contract central (per adr-028 canvas artifact
		  schema): expressa subdomain affinities, capabilities,
		  invariants, ubiquitous language. Cada BC tem exatamente 1
		  canvas em path canônico contexts/<bc>/canvas.cue.

		Trigger desta ADR: per adr-069 known gaps declarados,
		'canvas/glossary/domain-model paths (BC artifacts): separate
		ADRs per type'. Esta ADR materializa primeiro de 3 BC
		artifact path-mappings.

		Análise per adr-060 critérios:
		- Criticality: HIGH. Canvas é contrato público de cada BC —
		  drift silencioso quebra ubiquitous language e affinity
		  assignments que outros artefatos referenciam.
		- Volume: 4 instances (1 por BC: cmt, ctr, idc, npm). Volume
		  estável (cresce com novos BCs); maturidade alta (schema
		  desde adr-028).
		- Maturidade: schema #Canvas estável (adr-028); 4 instances
		  conformantes; estrutural-check architecture/structural-
		  checks/canvas.cue cobre validação determinística (per
		  adr-068 path-mapping).

		Branch (claude/resume-mesh-work-jv2MC) NÃO modificou nenhum
		canvas. ZERO instances com modificação in-flight → zero
		retroativos necessários.

		4 canvas em main sem SRR matching path (cmt, ctr, idc, npm)
		— todas pre-path-mapping → 4 transient bootstrap exceptions
		(categoria pre-mapping-transient com schema first-class per
		adr-070).

		Alternativas avaliadas:
		(a) Status quo (canvas não enforced) — rejeitada: criticality
		HIGH; canvas é BC contract público; drift compromete
		ubiquitous language e affinity assignments.
		(b) Pattern narrow ('contexts/<bc>/canvas-*.cue' ou
		'contexts/*/canvas.v*.cue') — rejeitada: convenção atual é
		1 canvas singleton per BC sem prefixo/versionamento. Pattern
		broad 'contexts/*/canvas.cue' reflete estrutura real.
		Futuros canvas variants entrariam via amendment explícito,
		não inferência tácita; mas custo de manter narrow agora sem
		evidence de variants é zero benefit.
		(c) Batch com glossary/domain-model — rejeitada per adr-060
		progressive pattern: 1 ADR por type exceto 'natural pair'.
		Canvas, glossary, domain-model são concerns disjuntos
		(canvas=BC contract; glossary=ubiquitous language; domain-
		model=structural model). Cada merece justificativa
		contextualizada.
		(d) Wait until 1+ canvas modified before path-mapping —
		rejeitada: zero retros é validação operacional do schema
		first-class de bootstrap exception (adr-070); pattern de
		regularização transitória já está estabelecido + testado
		em adr-067/068/069.
		"""

	decision: """
		(1) ADICIONAR pattern para canvas ao artifact_type_for_path
		em scripts/ci/check-self-review.sh:
		    contexts/*/canvas.cue) echo "canvas" ;;
		Pattern broad ('contexts/*/canvas.cue') reflete convenção
		estrutural: cada BC tem exatamente 1 canvas em path canônico.
		Não colide com canvas schema (architecture/artifact-schemas/
		canvas.cue), canvas SC (architecture/structural-checks/
		canvas.cue), ou canvas VP (architecture/validation-prompts/
		validate-canvas.cue) — todos em diretórios distintos já
		cobertos por outros patterns.

		(2) ESCOPO: instances. Schema #Canvas + SC + VP correspondentes
		já cobertos por patterns existentes.

		(3) ZERO RETROATIVOS IN-FLIGHT: nenhum canvas modificado
		nesta branch (verified via git diff origin/main...HEAD).
		Primeiro path-mapping ADR da sessão sem retros — paralelo
		conceitualmente a adr-066 (zero retros via discipline
		preventiva), embora razão aqui seja diferente (nenhuma
		modificação in-flight vs voluntary SRRs ad-hoc).

		(4) REGULARIZAÇÃO TRANSITÓRIA DE 4 CANVAS EM MAIN: cmt, ctr,
		idc, npm — todas pre-path-mapping. Regularizadas neste mesmo
		commit via 4 entries em self-review-bootstrap-policy.cue
		(categoria pre-mapping-transient com schema first-class per
		adr-070: category + lifecycle + exitCondition uniforme
		'Remove exception when artifact receives a matching SRR
		after next modification.'). Total cumulativo da categoria
		pós-adr-072: 18 entries (4 PGs + 1 SC + 9 VPs + 4 canvas).
		Validação operacional do schema bumpado em adr-070.

		(5) MATERIALIZAÇÃO: single commit consolidado com este ADR +
		script edit + 4 bootstrap exceptions transientes + ADR-072
		self-review. 5 arquivos. Menor commit da sequência (vs 17
		em adr-069) — refletindo maturidade do pattern e zero
		retros.

		(6) FUTURE EXTENSION (continua pattern): outros BC artifact
		types remain candidates per adr-060/066/067/068/069 framing.
		Próximos:
		- glossary (paths em contexts/<bc>/ + universal-glossary.cue)
		- domain-model (contexts/<bc>/domain-model.cue)
		- work-governance singleton
		- subdomain (strategic/subdomains/*.cue)
		"""

	consequences: """
		Positivas:

		(P1) canvas instances enforced por CI — BC contracts
		protegidos contra drift silencioso. Modificações futuras a
		qualquer canvas requerem self-review report explícito.

		(P2) Continuidade direta do pattern adr-060/066/067/068/069
		+ uso operacional do schema first-class de bootstrap
		exception (adr-070): primeiro path-mapping ADR pós-adr-070.

		(P3) Pattern broad ('contexts/*/canvas.cue') é apropriado
		porque convenção estrutural fixa (cada BC, 1 canvas em path
		canônico). Não colide com outros tipos canvas.

		(P4) Coverage agora cobre 15 types via mapping (14 prior +
		canvas).

		(P5) Volume baixo (5 arquivos) reflete maturidade do pattern
		e zero retros — pattern de extensão progressiva escala
		previsivelmente.

		Negativas:

		(N1) 4 transient bootstrap exceptions adicionadas — volume
		cumulativo da categoria pre-mapping-transient cresce de 14
		para 18 entries. Ainda abaixo do threshold de def-012 (20);
		def-012 não fires neste commit.

		(N2) Surface area de consistency entre mapping, #ArtifactType,
		structural-check.artifactType, e PG cascade-ordering
		coveredSchemas continua crescendo. Manter sync entre os 4 é
		responsabilidade editorial até structural-check eventual
		capturar pair-coverage.

		(N3) Outros BC artifact types (glossary, domain-model)
		permanecem unmapped — gap reconhecido, deferido per adr-060
		progressive adoption.

		Known gaps declarados:
		- 4 canvas em main sem SRR matching path: regularizadas via
		  bootstrap exception transient (categoria pre-mapping-
		  transient com schema first-class per adr-070). Cada
		  exception sai quando próxima modificação criar SRR
		  matching path.
		- glossary path mapping é forte candidato seguinte — separate
		  ADR per progressive pattern.
		- domain-model path mapping (BC artifact): separate ADR.
		- work-governance singleton: separate ADR.
		- def-012 trigger não fires neste commit (count 18 < 20);
		  fires no próximo path-mapping ADR que adicionar 2+
		  transient entries.

		Fronteira regulatória: nenhuma. Decisão é meta-estrutural
		sobre CI enforcement scope. BC canvas instances que
		referenciam constraints regulatórias (FCE, SCF, BKR, REW,
		IDC, ATO, INS, ITC) mantêm contratos regulatórios próprios
		— enforcement de self-review NÃO altera semantics
		regulatórias dos canvas.
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"scripts/ci/check-self-review.sh",
		"governance/build-time/self-review-bootstrap-policy.cue",
	]

	plannedOutputs: []

	defersTo: []

	principlesApplied: [
		"P10",
		"P12",
	]

	supersedes: []

	rationale: """
		Princípios aplicados:

		P12 (governança como código): script edit é veículo
		declarativo para governance scope. Canvas é BC contract
		público; coverage incompleta seria violação do princípio
		aplicado a contracts cross-BC.

		P10 (gates determinísticos validam): CI self-review-check
		torna-se efetivo para canvas — gate determinístico ao invés
		de discipline voluntária para artefatos críticos de BC.

		Sem axiomas tensionados.

		Lenses consultadas:

		lens-real-options: pattern broad ('contexts/*/canvas.cue')
		é apropriado porque convenção estrutural fixa cobre todos
		os casos atuais e previsíveis. Pattern narrow seria
		especulativo sem evidence de canvas variants.

		Relação com outras ADRs:

		- DESCENDS adr-060 (pattern de extensão progressiva).
		- DESCENDS adr-066/067/068/069 (continuação direta —
		  canvas era explicit known gap em adr-069).
		- COMPLEMENTA adr-028 (canvas artifact schema): canvas
		  instances agora também enforced por CI self-review além
		  de cobertura por structural-check + validation-prompt.
		- USA schema first-class de adr-070 para 4 transient
		  bootstrap exceptions (validação operacional).
		- PRECEDE potential ADRs para glossary/domain-model + outros
		  BC types.
		- SEM supersession.

		Justificativa de risk metadata:

		reversibility 'high': script edit é puramente aditivo;
		reversão é remover 1 linha. Mesmo pattern de adr-060/066/
		067/068/069.

		blastRadius 'cross-cutting': afeta todos canvas instances
		(4 atuais + futures conforme novos BCs forem criados). BC
		contracts são cross-BC por construção; modificações afetam
		ubiquitous language compartilhada.
		"""
}
