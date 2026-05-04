package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr067: artifact_schemas.#ADR & {
	id:    "adr-067"
	title: "Extend artifact_type_for_path to cover production-guide instances"
	date:  "2026-05-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		State-of-affairs precedente:
		- adr-060 estabeleceu pattern progressivo para
		  artifact_type_for_path em scripts/ci/check-self-review.sh.
		- adr-066 (commit 9ce54d7) adicionou deferred-decision como
		  primeiro caso post-adr-060 com zero retroativos (discipline
		  preventiva durante a sessão removeu backlog).
		- Production-guides são artefatos governance-critical: cada
		  PG codifica protocolo de autoria de 1 schema instanciável.
		  Modificações sem self-review = drift no protocolo de
		  autoria que governa todos os outros artefatos do tipo.

		Trigger desta ADR: per adr-066 known gaps declarados,
		'production-guide path mapping NÃO incluído (9 instances + 4
		modified this session = forte candidato seguinte; per adr-060
		progressive pattern, separate ADR)'. Esta ADR materializa esse
		next step.

		Análise per adr-060 critérios:
		- Criticality: HIGH. PGs codificam authoring discipline + são
		  consumed por meta-PG cascade ordering (adr-053 + adr-054
		  dec 13) + structural-check sc-pg-01 (adr-056). Modificação
		  errônea afeta autoria futura de todas as instances do
		  tipo coberto.
		- Volume: 9 instances (architecture/production-guides/):
		  adr.cue, agent-governance.cue, agent-spec.cue, deferred-
		  decision.cue, domain-model.cue, glossary.cue, production-
		  guide.cue (meta-PG), structural-check.cue, tension-entry.cue.
		- Maturidade: schema #ProductionGuide estável desde adr-053;
		  meta-PG estabelecido; pattern de cascade-ordering validated.
		  Pattern empírico established.

		Verificação rigorosa branch (claude/resume-mesh-work-jv2MC)
		via git diff origin/main...HEAD: apenas 2 PG files modificadas
		nesta branch:
		- deferred-decision.cue: criada em adr-062 (commit 4f6abfc),
		  modificada em commit 7ebcf02 (WI-069 retrospective gaps).
		- tension-entry.cue: criada em WI-069 (commit 239972c) via
		  authoring subagent dispatch.

		Outras PGs (adr.cue, agent-governance.cue, agent-spec.cue,
		structural-check.cue) modificadas em sessões prévias já
		mergeadas em main — fora do escopo de retroativos desta
		branch (retros = in-flight modifications per pattern adr-060).
		Coverage para PGs em main sem SRR matching path é WI separado
		futuro, não cabe em adr-067.

		Em contraste com adr-066: das 2 PGs modificadas, NENHUMA tinha
		SRR matching path antes deste commit. Resulta em 2 retroativos
		necessários (vs zero de adr-066 onde discipline preventiva
		cobriu todos os def-XXX).

		Alternativas avaliadas:
		(a) Status quo (PGs não enforced) — rejeitada: forte
		criticality + volume justificam coverage; manter sem
		enforcement perpetua gap.
		(b) Adicionar com pattern broad ('architecture/production-
		guides/*.cue') — recomendado: 9 instances são todas valid
		PGs; pattern atual narrow-by-path-pattern (vs def-*.cue
		prefix de adr-066) reflete que TODOS os arquivos em
		production-guides/ são PG instances. Sem prefixo distintivo
		que justifique narrowing.
		(c) Batch com structural-check + validation-prompt — rejeitada
		per adr-060 progressive pattern: 1 ADR por type exceto
		'natural pair'. Production-guide é standalone.
		(d) Skip retroativos (assume future enforcement only) —
		rejeitada: pattern adr-060 retroativos era exatamente para
		in-flight modifications; mesma situação aqui.
		"""

	decision: """
		(1) ADICIONAR pattern para production-guide ao
		artifact_type_for_path em scripts/ci/check-self-review.sh:
		    architecture/production-guides/*.cue) echo "production-guide" ;;
		Pattern broad ('*.cue' não prefixo) reflete que todos os
		arquivos em architecture/production-guides/ são PG instances
		— diferente de deferred-decisions/ onde 'def-*.cue' filtra
		futuros prefixos não-PG.

		(2) ESCOPO: instances. Schema #ProductionGuide
		(architecture/artifact-schemas/production-guide.cue) já
		coberto por pattern artifact-schema. Validation-prompt
		correspondente (validate-production-guide.cue) coberto
		por separate type quando ADR específico justificar.

		(3) RETROATIVOS: 2 retroativos para PGs modificadas nesta
		branch (verified via git diff origin/main...HEAD) sem SRR
		matching path:
		- deferred-decision.cue (created em adr-062 commit 4f6abfc;
		  modified em commit 7ebcf02 WI-069 retrospective gaps)
		- tension-entry.cue (created em WI-069 commit 239972c via
		  authoring subagent dispatch)
		Para cada um, retroativo cobre 'touch' das modificações
		desta branch (status stable, single round, executionMode
		self-reported).

		(4) REGULARIZAÇÃO TRANSITÓRIA DE PGs EM MAIN SEM SRR: PGs
		adr.cue, agent-governance.cue, agent-spec.cue, structural-
		check.cue não modificadas nesta branch (verified via git diff
		origin/main...HEAD) mas existem em main pre-path-mapping.
		Regularizadas neste mesmo commit via 4 entries em
		self-review-bootstrap-policy.cue (categoria pre-mapping-
		transient). Cada exception sai quando próxima modificação
		criar SRR matching path. Schema first-class para transient
		lifecycle (category/lifecycle/exitCondition fields +
		structural-check de stale detection) deferido per def-011 —
		volume insuficiente agora para generalização (pattern ten-009
		expand-when-needed).

		(5) MATERIALIZAÇÃO: single commit consolidado com este ADR +
		script edit + 2 retroativos + ADR-067 self-review + 4
		bootstrap-policy exceptions + def-011 (deferimento de schema
		first-class).

		(6) FUTURE EXTENSION (continua pattern): outros types
		remain candidates per adr-060 + adr-066 framing. Próximos
		fortes candidates após este ADR:
		- structural-check (6 instances, 5 modified this session)
		- validation-prompt (14 instances, 2+ modified)
		- canvas (4 instances, BC contracts)
		- tension-entry (11 instances, stable)
		- work-governance (1 singleton)
		- adopted-artifacts + readme-config (singletons)
		"""

	consequences: """
		Positivas:

		(P1) production-guide instances enforced por CI — modificações
		futuras a qualquer PG requerem self-review report explícito.
		Authoring discipline core do mesh fica protegida contra
		drift silencioso.

		(P2) Continuidade do pattern adr-060 + adr-066: ADR + script
		edit + retroativos por path modificado in flight (2 retros
		neste caso, vs zero de adr-066 por discipline preventiva,
		vs 5 de adr-060).

		(P3) Pattern broad ('*.cue' não prefix) é apropriado para
		production-guides/ porque TODOS os arquivos no diretório são
		PG instances — diferente de deferred-decisions/ onde def-*.cue
		filtra futuros prefixos. Convenção match estrutura real.

		(P4) Coverage agora cobre 12 types via mapping (11 prior +
		production-guide).

		Negativas:

		(N1) 2 retroativos overhead — relatórios criados post-fact
		para cobrir CI requirement. Mitigação: pattern existente
		(paralelo a adr-060 5 retros); reports brief cobrem
		touches específicas.

		(N2) Surface area de consistency entre mapping, #ArtifactType,
		structural-check.artifactType, e PG cascade-ordering coveredSchemas
		cresce. Manter sync entre os 4 é responsabilidade editorial
		até structural-check eventual capturar pair-coverage entre
		mapping e schemas.

		(N3) Outros types unmapped permanecem não-enforced — gap
		reconhecido, deferido per adr-060 progressive adoption.

		Known gaps declarados:
		- 4 PGs em main sem SRR matching path (adr.cue, agent-
		  governance.cue, agent-spec.cue, structural-check.cue):
		  modificadas em sessões prévias antes de path-mapping
		  existir. Regularização neste commit via bootstrap-exception
		  pattern (categoria pre-mapping-transient em self-review-
		  bootstrap-policy.cue). Schema first-class para transient
		  lifecycle deferido per def-011. Cada exception sai quando
		  próxima modificação criar SRR matching path.
		- structural-check path mapping é forte candidato seguinte
		  (6 instances, 5 modified this session). Separate ADR per
		  progressive pattern.
		- validation-prompt path (14 instances): forte volume,
		  separate ADR.
		- canvas/glossary/domain-model paths (BC artifacts):
		  separate ADRs per type.

		Fronteira regulatória: nenhuma. Decisão é meta-estrutural
		sobre CI enforcement scope.
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"scripts/ci/check-self-review.sh",
		"governance/build-time/self-review-bootstrap-policy.cue",
	]

	plannedOutputs: [
		"governance/build-time/self-reviews/deferred-decision-pg-touch.self-review.cue",
		"governance/build-time/self-reviews/tension-entry-pg-touch.self-review.cue",
		"architecture/deferred-decisions/def-011-bootstrap-exception-schema-firstclass.cue",
	]

	defersTo: ["def-011"]

	principlesApplied: [
		"P10",
		"P12",
	]

	supersedes: []

	rationale: """
		Princípios aplicados:

		P12 (governança como código): script edit é veículo
		declarativo para governance scope. Authoring discipline
		(PGs) é central ao governance system; coverage incompleta
		seria violação do princípio aplicado às próprias regras
		de autoria.

		P10 (gates determinísticos validam): CI self-review-check
		torna-se efetivo para PGs — gate determinístico ao invés
		de discipline voluntária.

		Sem axiomas tensionados.

		Lenses consultadas:

		lens-real-options: pattern broad ('*.cue') é apropriado
		porque production-guides/ é diretório dedicado a 1 tipo;
		futuros arquivos não-PG no diretório seriam erro de
		categorização. Pattern narrow ('pg-*.cue') seria
		artificial.

		Relação com outras ADRs:

		- DESCENDS adr-060 (pattern de extensão progressiva).
		- DESCENDS adr-066 (continuação direta — production-guide
		  era explicit known gap).
		- COMPLEMENTA adr-053 (universal coverage de PGs) +
		  adr-056 (sc-pg-01 cascade ordering): authoring layer
		  agora também enforced por CI self-review além de
		  cascade ordering.
		- PRECEDE potential ADRs para structural-check + validation-
		  prompt + canvas + outros types.
		- SEM supersession.

		Justificativa de risk metadata:

		reversibility 'high': script edit é puramente aditivo;
		reversão é remover 1 linha. Mesmo pattern de adr-060/066.

		blastRadius 'cross-cutting': afeta todos PG instances
		(9 atuais + futures). Authoring discipline cross-cutting
		por construção (PGs cobrem TODOS os schemas instanciáveis).
		Não atravessa fundamental governance infrastructure
		(não é repo-wide); afeta authoring de múltiplos types.
		"""
}
