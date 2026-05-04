package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr068: artifact_schemas.#ADR & {
	id:    "adr-068"
	title: "Extend artifact_type_for_path to cover structural-check instances"
	date:  "2026-05-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		State-of-affairs precedente:
		- adr-060 estabeleceu pattern progressivo para
		  artifact_type_for_path em scripts/ci/check-self-review.sh.
		- adr-066 (commit 9ce54d7) adicionou deferred-decision com
		  zero retroativos (discipline preventiva).
		- adr-067 (commits ebf4cba + 57d8d5f) adicionou
		  production-guide com 2 retroativos in-flight + 4
		  bootstrap exceptions transientes para PGs main pre-mapping
		  + def-011 (deferimento de schema first-class para transient
		  lifecycle).
		- Structural-checks são gates determinísticos que validam
		  conformidade pós-commit (per adr-040). Modificações sem
		  self-review = drift no próprio mecanismo de gate.

		Trigger desta ADR: per adr-067 known gaps declarados,
		'structural-check path mapping é forte candidato seguinte
		(6 instances, 5 modified this session)'. Esta ADR materializa
		esse next step.

		Análise per adr-060 critérios:
		- Criticality: HIGH. SCs são únicos mecanismos de validação
		  pós-commit que podem bloquear o fluxo (per adr-040). Drift
		  silencioso em SC = degradação do gate determinístico que
		  protege todos os outros artefatos.
		- Volume: 6 instances (architecture/structural-checks/):
		  canvas.cue, deferred-decision.cue, production-guide.cue,
		  self-review-report.cue, tension-entry.cue, work-governance.cue.
		- Maturidade: schema #StructuralCheck estável; multiple kinds
		  estabelecidos (required-block, reference-exists, same-artifact-
		  consistency, conditional-file-presence, production-guide-
		  coverage, filesystem-path-exists, directory-pair-coverage);
		  6 instances criadas/expandidas nesta sessão validam pattern.

		Branch (claude/resume-mesh-work-jv2MC) modificou 5 SC files:
		- deferred-decision.cue (adr-062 commit 0e9618e bootstrap
		  operational)
		- production-guide.cue (adr-053 origem; modificado em adr-062
		  4f6abfc + adr-063 4cd3e2e + WI-069 239972c)
		- self-review-report.cue (adr-063 commit 4cd3e2e
		  filesystem-path-exists kind addition)
		- tension-entry.cue (adr-063 commit 4cd3e2e mesma adição)
		- work-governance.cue (adr-064 commit 4f25682 sc-wg-01 +
		  directory-pair-coverage kind)

		Todos sem SRR matching path antes deste commit → 5 retroativos
		necessários. canvas.cue não modificado nesta branch — existe
		em main pre-path-mapping → 1 transient bootstrap exception
		(categoria pre-mapping-transient já estabelecida em adr-067 +
		def-011).

		Alternativas avaliadas:
		(a) Status quo (SCs não enforced) — rejeitada: criticality HIGH
		(SCs são gates determinísticos pós-commit); drift silencioso
		degrada o mecanismo de gate.
		(b) Adicionar com pattern broad ('architecture/structural-
		checks/*.cue') — recomendado: 6 instances são todas valid SCs;
		todos arquivos no diretório são SC instances. Sem prefixo
		distintivo que justifique narrowing.
		(c) Batch com validation-prompt — rejeitada per adr-060
		progressive pattern: 1 ADR por type exceto 'natural pair'.
		Structural-check + validation-prompt são counterparts (per
		adr-040 categorical separation) mas decisão de path-mapping é
		ortogonal — não justifica batching.
		(d) Resolver def-011 antes (promover #BootstrapException a
		schema first-class antes de adr-068) — rejeitada: volume
		insuficiente (1 categoria pre-mapping-transient com 5 entries
		seria n=5 num único batch — não diferencia de n=4); migration
		retroativa de 6 entries sem evidence empírica calcificaria
		enum prematuro. Deferimento per def-011 mantém-se válido;
		trigger fired neste commit é signal de revisita, não ação
		obrigatória.
		"""

	decision: """
		(1) ADICIONAR pattern para structural-check ao
		artifact_type_for_path em scripts/ci/check-self-review.sh:
		    architecture/structural-checks/*.cue) echo "structural-check" ;;
		Pattern broad ('*.cue' não prefixo) reflete que todos os
		arquivos em architecture/structural-checks/ são SC instances —
		paralelo a production-guides/ em adr-067.

		(2) ESCOPO: instances. Schema #StructuralCheck
		(architecture/artifact-schemas/structural-check.cue) já
		coberto por pattern artifact-schema. Validation-prompt
		correspondente (validate-structural-check.cue) coberto
		por separate type quando ADR específico justificar.

		(3) RETROATIVOS IN-FLIGHT: 5 retroativos para SCs modificadas
		nesta branch (verified via git diff origin/main...HEAD) sem
		SRR matching path:
		- deferred-decision.cue (modified em adr-062 commit 0e9618e
		  bootstrap operational)
		- production-guide.cue (origem adr-053; modified em adr-062
		  4f6abfc + adr-063 4cd3e2e + WI-069 239972c)
		- self-review-report.cue (modified em adr-063 commit 4cd3e2e
		  filesystem-path-exists kind addition)
		- tension-entry.cue (modified em adr-063 commit 4cd3e2e mesma
		  adição)
		- work-governance.cue (created em adr-064 commit 4f25682
		  sc-wg-01 + directory-pair-coverage kind)
		Para cada um, retroativo cobre 'touch' das modificações
		desta branch (status stable, single round, executionMode
		self-reported).

		(4) REGULARIZAÇÃO TRANSITÓRIA DE SC EM MAIN SEM SRR: SC
		canvas.cue não modificada nesta branch (verified via git diff
		origin/main...HEAD) mas existe em main pre-path-mapping.
		Regularizada neste mesmo commit via 1 entry em
		self-review-bootstrap-policy.cue (categoria pre-mapping-
		transient, mesma de adr-067). Sai quando próxima modificação
		criar SRR matching path. Schema first-class para transient
		lifecycle deferido per def-011 — count agora=4 (adr-061,
		adr-066, adr-067, adr-068) atinge threshold; trigger fires
		no próximo CI run (signal de revisita per design adr-062).

		(5) MATERIALIZAÇÃO: single commit consolidado com este ADR +
		script edit + 5 retroativos + 1 bootstrap exception
		transient + ADR-068 self-review. 8 arquivos.

		(6) FUTURE EXTENSION (continua pattern): outros types remain
		candidates per adr-060/066/067 framing. Próximos:
		- validation-prompt (14 instances, 2+ modified) — strong
		  next candidate por volume
		- canvas (4 instances, BC contracts)
		- glossary, domain-model (BC artifacts)
		- adopted-artifacts + readme-config já cobertos por adr-061
		"""

	consequences: """
		Positivas:

		(P1) structural-check instances enforced por CI — modificações
		futuras a qualquer SC requerem self-review report explícito.
		Mecanismo de gate determinístico fica protegido contra drift
		silencioso.

		(P2) Continuidade direta do pattern adr-060 + adr-066 + adr-067:
		ADR + script edit + retroativos in-flight + bootstrap exception
		transient para state pre-mapping + defersTo def-011.

		(P3) Pattern broad ('*.cue' não prefix) é apropriado para
		structural-checks/ porque TODOS os arquivos no diretório são
		SC instances — convenção match estrutura real.

		(P4) Coverage agora cobre 13 types via mapping (12 prior +
		structural-check).

		Negativas:

		(N1) 5 retroativos overhead — relatórios criados post-fact
		para cobrir CI requirement. Mitigação: pattern existente
		(paralelo exato a adr-060 com 5 retros); reports brief cobrem
		touches específicas.

		(N2) Surface area de consistency entre mapping, #ArtifactType,
		structural-check.artifactType, e PG cascade-ordering coveredSchemas
		cresce. Manter sync entre os 4 é responsabilidade editorial
		até structural-check eventual capturar pair-coverage entre
		mapping e schemas.

		(N3) def-011 trigger is expected to fire; this commit
		intentionally creates the revisitation signal. Conta de
		path-mapping ADRs vai 3→4, atingindo threshold definido em
		def-011 (per founder articulation: 'dispara quando houver o
		próximo, isto é, a 4ª ocorrência'). Annotation no próximo CI
		run é signal designed; founder revisita def-011 ao ver
		annotation e decide se age agora (promove #BootstrapException
		a schema first-class) ou registra acknowledgment mantendo
		open. Não é falha do mecanismo.

		Known gaps declarados:
		- 1 SC em main sem SRR matching path (canvas.cue): não
		  modificada nesta branch, regularizada via bootstrap exception
		  transient (categoria pre-mapping-transient). Sai quando
		  próxima modificação criar SRR matching path.
		- def-011 trigger fires neste commit (count 3→4). Por design
		  adr-062: trigger fired ≠ ação obrigatória; é signal de
		  revisita.
		- validation-prompt path mapping é forte candidato seguinte
		  (14 instances, 2+ modified). Separate ADR per progressive
		  pattern.
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
		"governance/build-time/self-reviews/deferred-decision-sc-touch.self-review.cue",
		"governance/build-time/self-reviews/production-guide-sc-touch.self-review.cue",
		"governance/build-time/self-reviews/self-review-report-sc-touch.self-review.cue",
		"governance/build-time/self-reviews/tension-entry-sc-touch.self-review.cue",
		"governance/build-time/self-reviews/work-governance-sc-touch.self-review.cue",
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
		declarativo para governance scope. Structural-checks são
		gates determinísticos centrais ao governance system (per
		adr-040); coverage incompleta seria violação do princípio
		aplicado às próprias regras de validação estrutural.

		P10 (gates determinísticos validam): CI self-review-check
		torna-se efetivo para SCs — gate determinístico ao invés
		de discipline voluntária. Meta-aplicação: o gate que
		valida outros gates fica ele próprio coberto por gate.

		Sem axiomas tensionados.

		Lenses consultadas:

		lens-real-options: pattern broad ('*.cue') é apropriado
		porque structural-checks/ é diretório dedicado a 1 tipo;
		futuros arquivos não-SC no diretório seriam erro de
		categorização.

		Relação com outras ADRs:

		- DESCENDS adr-060 (pattern de extensão progressiva).
		- DESCENDS adr-066 + adr-067 (continuação direta — structural-
		  check era explicit known gap em ambos).
		- COMPLEMENTA adr-040 (separação categórica entre gates
		  determinísticos e validação semântica advisory): gates
		  determinísticos agora também cobertos por self-review
		  enforcement.
		- DEFERS TO def-011 (schema first-class para transient
		  bootstrap exception lifecycle): adr-068 estende categoria
		  pre-mapping-transient com 5ª entry (canvas.cue) e fires
		  trigger threshold=4; deferimento mantém-se válido.
		- PRECEDE potential ADR para validation-prompt + outros
		  types.
		- SEM supersession.

		Justificativa de risk metadata:

		reversibility 'high': script edit é puramente aditivo;
		reversão é remover 1 linha. Mesmo pattern de adr-060/066/067.

		blastRadius 'cross-cutting': afeta todos SC instances
		(6 atuais + futures). SCs cobrem múltiplos artifactTypes
		via canonicalPathRegex próprios; cross-cutting por
		construção. Não atravessa fundamental governance
		infrastructure (não é repo-wide).
		"""
}
