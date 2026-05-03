package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr064: artifact_schemas.#ADR & {
	id:    "adr-064"
	title: "Adicionar work-governance type + directory-pair-coverage kind ao framework structural-check"
	date:  "2026-05-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Sessão 2026-05-03 (claude/resume-mesh-work-jv2MC) cleanup de
		anomalias estruturais identificou bug raiz: commit c9b584c
		(2026-04-02) criou governance/build-time/work-events/wi-033.cue
		+ entry em wave-plan SEM criar o task-spec correspondente
		(governance/build-time/task-specs/wi-033.cue). Inconsistência
		referencial silenciosa por ~5 semanas.

		Backfill mecânico da task-spec ausente (commit fbfe535) restaura
		integridade no caso WI-033 mas NÃO previne recorrência. Sistema
		governance/build-time permite criar work-event sem garantir
		existência do task-spec correspondente — violação categórica de
		integridade estrutural que escapa de cue vet (não há schema
		constraint cross-file) e de check-self-review (escopo é evidência
		de review, não pareamento de arquivos).

		Real fix preventivo: structural-check sc-wg-01 verificando que
		para todo wi-XXX em work-events/, existe wi-XXX em task-specs/.
		Pattern análogo a sc-pg-01 (production-guide-coverage per
		adr-056) — mas direção/shape diferente: sc-pg-01 usa whitelist
		curada (coveredSchemas), sc-wg-01 usa glob pair (dynamic).

		Análise dos kinds atuais (após adr-063 — 6 kinds):
		- required-block: estrutura within-artifact
		- reference-exists: refs same-artifact only
		- same-artifact-consistency: relação between blocks within
		- conditional-file-presence: presença CONDICIONAL baseada em
		  campo booleano (e.g., hasSyncSurface → api.yaml). NÃO fits:
		  sc-wg-01 é INCONDICIONAL (todo work-event SEMPRE exige
		  task-spec).
		- production-guide-coverage: whitelist explícita curada. NÃO
		  fits: sc-wg-01 source set é dinâmico (cada arquivo wi-XXX em
		  work-events/, não whitelist curada).
		- filesystem-path-exists: path em campo de artefato → existir
		  em filesystem. NÃO fits: sc-wg-01 é sobre pareamento de
		  arquivos em diretórios, não campo dentro de artefato.

		Nenhum kind atual cobre cleanly. Real fix exige:
		1. Novo kind directory-pair-coverage (4ª extension após
		   adr-049/056/063)
		2. Novo artifactType "work-governance" (extension de #ArtifactType
		   per adr-061 pattern) — usar existing "task-template" foi
		   considerado mas REJEITADO porque polui semanticamente o tipo
		   task-template (check é sobre work governance integrity, não
		   propriedade de task-template per se).

		Alternativas consideradas e rejeitadas:

		(a) Generic glob-pair check kind (e.g., 'cross-directory-pairing')
		que cobriria sc-wg-01 + outros pares hipotéticos futuros.
		Rejeitada: viola adr-041 minimalism — kinds devem ser narrow
		específicos. Generic kind dilui semantics; cada caso futuro
		adiciona complexity à rule shape única. Pattern estabelecido
		em adr-049/056/063 é narrow kind-by-kind.

		(b) Estender conditional-file-presence (adr-049) para suportar
		'condition: always-true'. Rejeitada: hack semântico — CFP é
		para presença CONDICIONAL baseada em field; força via
		condition=true sempre é abuso do shape. Semântica do kind se
		dilui; futuros leitores perdem clareza.

		(c) Usar filesystem-path-exists (adr-063) com sourcePath
		referenciando 'each file in work-events/'. Rejeitada: kind opera
		em path dentro de artefato (e.g., self-review-report.artifactPath),
		não em pareamento de diretórios. sourcePath é dot-path no
		artifact, não glob de filesystem.

		(d) artifactType='task-template' para sc-wg-01 (usar existing).
		Rejeitada (founder feedback explícito): polui semanticamente
		task-template — check é sobre work governance integrity, não
		propriedade de task-template instances. Manter task-template
		focado em sua semantic original (template definitions).

		(e) Manter manual review como única defesa. Rejeitada: foi
		exatamente o que falhou no bug WI-033 — manual review missou a
		inconsistência por 5 semanas. P10 + adr-040 split: dimensões
		determinísticas (existência de pair de arquivos) pertencem a
		structural gate, não advisory.

		Discoverabilidade do bug: structural-check para wi-events/
		integrity nunca existiu porque casos concretos não materializaram
		até agora. WI-033 é o primeiro caso observado de violação;
		commit c9b584c data 2026-04-02. Discovery (2026-05-03) ~5 semanas
		depois durante session retrospective. Pattern de 'descobre
		quando bate' validado.
		"""

	decision: """
		Duas mudanças acopladas, single commit:

		(1) [type-extension] Estender #ArtifactType com 'work-governance'
		em architecture/artifact-schemas/quality-criteria.cue. Abreviação
		canônica 'wg' adicionada no comment block. Pattern paralelo a
		adr-047 (api-specs), adr-061 (adopted-artifacts + readme-config).

		(2) [kind-extension] Adicionar 'directory-pair-coverage' ao
		discriminator #StructuralCheckKind e à união discriminada de
		#StructuralCheck em architecture/artifact-schemas/structural-check.cue.
		4th extension após adr-049/056/063. Pattern paralelo.

		(3) [rule-shape] Definir #DirectoryPairCoverageRule com 3 fields:
		  - sourceGlob: glob pattern para arquivos no source dir,
		    com wildcard '*' capturando identidade compartilhada.
		  - targetGlob: glob pattern para target dir, mesmo wildcard
		    '*' nas mesmas posições — runner verifica que cada source
		    file tem target file com mesmo wildcard capture.
		  - bidirectional: bool default false. true = ambas direções
		    enforced (every source ↔ every target). false = apenas
		    source → target.

		Aplicação imediata desta extensão (instância criada no MESMO
		commit, pattern adr-056):
		- sc-wg-01 em architecture/structural-checks/work-governance.cue:
		  artifactType='work-governance', kind='directory-pair-coverage',
		  rule.sourceGlob='governance/build-time/work-events/wi-*.cue',
		  rule.targetGlob='governance/build-time/task-specs/wi-*.cue',
		  rule.bidirectional=false.
		  Direção: source-to-target only (work-event → task-spec
		  required). Reverse direction (task-spec sem work-event) é
		  estado válido admission=defined per work-governance state
		  machine (e.g., WI-066/067/068/069 atualmente).

		Esta decisão NÃO inclui automatização do runner (per adr-040 +
		adr-041 framework é forward-looking; structural-checks declaram
		regras a serem enforced quando runner ativar). sc-wg-01 nasce
		latente — primeiro uso será proteção contra regressão (similar
		filing pattern de adr-056 sc-pg-01).

		Esta decisão NÃO bloqueia eventual extensão futura para outros
		directory pairs (e.g., self-reviews/ ↔ governed artifacts/) —
		kind directory-pair-coverage é reusável para qualquer pair.
		"""

	consequences: """
		Positivas:
		(P1) Bug WI-033-style prevenido por gate determinístico:
		     sistema futuro não permite criar work-event sem task-spec
		     correspondente (quando runner ativar).
		(P2) artifactType 'work-governance' first-class: futuras checks
		     sobre integridade do work governance system têm casa
		     canônica.
		(P3) Kind directory-pair-coverage reusável: qualquer pair de
		     diretórios futuro (e.g., production-guides/ ↔ schemas/)
		     pode usar sem novo kind.
		(P4) Pattern de minimalism preservado: kind narrow específico
		     vs generic catch-all (per adr-041).
		(P5) Direção bidirectional opcional explícita: rule shape
		     admite ambos casos (one-way mandatory + two-way bijective)
		     com mesmo kind.

		Negativas:
		(N1) Schema #ArtifactType cresce 25 → 26 valores. Cada novo
		     valor amplia surface de consistency entre quality-criteria,
		     structural-check, validation-prompt, e CI mapping.
		(N2) Schema #StructuralCheck cresce 6 → 7 kinds. Mesmo trade-off
		     (per adr-049/056/063 pattern).
		(N3) Runner não foi atualizado (forward-looking per adr-040/
		     041). Estado esperado: instâncias declaradas latentes até
		     runner futuro consumir.
		(N4) Outras direções de pair check (e.g., self-reviews/ ↔
		     governed-artifacts/) NÃO cobertas explicitamente — quando
		     casos concretos materializarem, instâncias adicionais
		     usando este mesmo kind.

		Known gaps declarados (não omitidos):
		- Bidirectional check NÃO exercitado em sc-wg-01 (one-way
		  source-to-target). Reverse direction = task-spec sem
		  work-event = estado admission=defined válido per state
		  machine. NÃO formalizado como def-XXX porque é decisão
		  semântica não-revisitável (state machine é canônico).
		- Sequencing NÃO enforced: kind verifica pair-existence,
		  não ordem (pode ter task-spec criado APÓS work-event,
		  desde que ambos coexistam no commit). Aceita; ordem
		  temporal é enforced por commit-time discipline (review),
		  não por structural-check.
		- artifactType='work-governance' NÃO exigirá PG (work-events
		  são append-only events authored mecanicamente, não via
		  PG). NÃO incluído em sc-pg-01.coveredSchemas.

		Fronteira regulatória: nenhuma. Decisão é meta-estrutural
		sobre governance interna do work tracking system.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/quality-criteria.cue",
		"architecture/artifact-schemas/structural-check.cue",
	]

	plannedOutputs: [
		"architecture/structural-checks/work-governance.cue",
	]

	principlesApplied: [
		"P0",
		"P1",
		"P10",
		"P12",
	]

	supersedes: []

	rationale: """
		Princípios aplicados:

		P10 (gates determinísticos validam, agentes recomendam) é o
		driver primário: existência de pair de arquivos é dimensão
		determinística por construção (filesystem state). Pertence ao
		gate structural per adr-040 split, não advisory. Bug WI-033
		demonstrou empiricamente que manual review não é defesa
		suficiente para esse tipo de integridade.

		P12 (governança como código): kind directory-pair-coverage
		formaliza disciplina de pair-existence que antes vivia apenas
		na cabeça do reviewer. Schema enforce shape; runner futuro
		enforce semantics.

		P0 (uma localização canônica): work-governance type ganha lugar
		first-class no enum de artifact types — não fica como caso
		especial sem categorização. Abreviação 'wg' formalizada.

		P1 (CUE como SoT): kind + rule shape declarativos em CUE
		schema; runner consome shape.

		Failure mode evitado: bug WI-033-style — work-event criado
		isoladamente, task-spec esquecido, inconsistência referencial
		latente. Sem structural gate, próximo similar bug pode passar
		semanas/meses não-detectado.

		Tensão com axiomas: nenhuma tensão substantiva.

		Lenses consultadas:

		lens-real-options: postergar adição de kind até bug concreto
		materializar (WI-033) é exercício de real option — adicionar
		preventivo seria over-engineering antes de evidence. Pattern
		de adr-049/056/063 precedente — kinds adicionados quando
		caso concreto justifica.

		Relação com outras ADRs:

		- DESCENDS adr-041 (V1 minimal framework). 4ª extension em
		  série após adr-049 (conditional-file-presence), adr-056
		  (production-guide-coverage), adr-063 (filesystem-path-exists).
		- DESCENDS adr-040 (validação split). directory-pair-coverage é
		  determinístico — encaixa em structural side per split.
		- COMPLEMENTS adr-061 (extensão #ArtifactType para adopted-
		  artifacts + readme-config). Mesmo pattern; mesmo file.
		- ENABLES futuras instâncias usando directory-pair-coverage
		  para outros pairs (não escopo deste ADR).
		- SEM supersession.

		Justificativa de risk metadata:

		decisionClass='structural': adiciona kind + type cross-cutting;
		afeta todos os structural-checks futuros que possam querer
		directory-pair semantics + todos os consumidores de #ArtifactType.

		reversibility='high': remoção é trivial enquanto instâncias
		forem poucas (1 inicial + qualquer uso futuro). Diferente de
		decisões foundational (adr-040, adr-053).

		blastRadius='cross-artifact': toca quality-criteria.cue
		(#ArtifactType + abbrev), structural-check.cue (kind + rule),
		structural-checks/work-governance.cue (instance). Não atinge
		BCs nem domain.
		"""
}
