package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr069: artifact_schemas.#ADR & {
	id:    "adr-069"
	title: "Extend artifact_type_for_path to cover validation-prompt instances"
	date:  "2026-05-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		State-of-affairs precedente:
		- adr-060 estabeleceu pattern progressivo para
		  artifact_type_for_path em scripts/ci/check-self-review.sh.
		- adr-066 (commit 9ce54d7) adicionou deferred-decision com
		  pattern narrow def-*.
		- adr-067 (commits ebf4cba + 57d8d5f) adicionou
		  production-guide com pattern broad + categoria
		  pre-mapping-transient (4 entries) + def-011 (deferimento
		  schema first-class).
		- adr-068 (commit 5a8785b) adicionou structural-check com
		  pattern broad + 1 entry adicional na categoria pre-mapping-
		  transient (canvas.cue, total=5) + def-011 trigger fired
		  pela 1ª vez (count 3→4).
		- Validation-prompts são layer advisory (per adr-040): produzem
		  recomendações por agente em sessão isolada para revisão de
		  design pelo founder. Modificações sem self-review = drift
		  no protocolo de revisão semântica que governa qualidade
		  interpretativa cross-artifactType.

		Trigger desta ADR: per adr-068 known gaps declarados,
		'validation-prompt path mapping é forte candidato seguinte
		(14 instances, 2+ modified)'. Esta ADR materializa esse
		next step.

		Análise per adr-060 critérios:
		- Criticality: HIGH. VPs codificam protocolo advisory de
		  design review per artifactType (per adr-040 categorical
		  separation). Drift silencioso = degradação do mecanismo
		  que captura dimensões interpretativas (genuinidade,
		  qualidade adversarial, coerência semântica) que gates
		  determinísticos não alcançam.
		- Volume: 14 instances (architecture/validation-prompts/),
		  todas com prefixo 'validate-'. Maior volume entre os
		  candidates restantes.
		- Maturidade: schema #ValidationPrompt estável; 4 VPs criados
		  em WI-067 commit 06236f6 + 1 modified em adr-062 4f6abfc;
		  pattern de matchPatterns + checks + relatedSchemas
		  validated empiricamente.

		Branch (claude/resume-mesh-work-jv2MC) modificou 5 VP files:
		- validate-adopted-artifacts.cue (created em WI-067 commit
		  06236f6 batch validate-* per adr-061)
		- validate-deferred-decision.cue (created em adr-062 commit
		  4f6abfc bundle deferred-decision artifact type)
		- validate-production-guide.cue (created em WI-067 commit
		  06236f6 batch)
		- validate-readme-config.cue (created em WI-067 commit
		  06236f6 batch)
		- validate-tension-entry.cue (created em WI-067 commit
		  06236f6 batch)

		Todos sem SRR matching path antes deste commit → 5 retroativos
		necessários. 9 VPs não modificados nesta branch — existem em
		main pre-path-mapping → 9 transient bootstrap exceptions
		(categoria pre-mapping-transient já estabelecida em adr-067 +
		def-011).

		Alternativas avaliadas:
		(a) Status quo (VPs não enforced) — rejeitada: criticality
		HIGH; layer advisory de design review é mecanismo central
		(per adr-040) e drift compromete qualidade interpretativa.
		(b) Pattern broad ('architecture/validation-prompts/*.cue')
		— rejeitada: 14 instances todas com prefixo 'validate-';
		pattern narrow 'validate-*.cue' preserva opção de futuros
		arquivos não-validate sem amendment (paralelo a adr-066
		def-* reasoning). Custo zero hoje vs flexibilidade futura.
		(c) Batch com canvas/glossary/domain-model — rejeitada per
		adr-060 progressive pattern: 1 ADR por type exceto 'natural
		pair'. VPs e BC artifacts são concerns disjuntos.
		(d) Resolver def-011 antes (promover #BootstrapException a
		schema first-class) — rejeitada: refire do trigger é
		evidence, não failure (per founder articulation). Volume
		da categoria pre-mapping-transient cresce de 5 (pós-adr-068)
		para 14 (pós-adr-069), aumentando empirical basis para
		decisão futura. Refiring não bloqueia adr-069.
		"""

	decision: """
		(0) PREREQUISITE MECÂNICO: estender #ArtifactType enum em
		architecture/artifact-schemas/quality-criteria.cue
		adicionando "validation-prompt" como 29º valor. Necessário
		para SRRs poderem declarar artifactType: "validation-prompt"
		conformante. Pattern paralelo a adr-061 (estendeu para
		adopted-artifacts + readme-config), adr-062 (deferred-
		decision), adr-064 (work-governance). adr-066/067/068 não
		precisaram porque tipos já estavam no enum.

		(1) ADICIONAR pattern para validation-prompt ao
		artifact_type_for_path em scripts/ci/check-self-review.sh:
		    architecture/validation-prompts/validate-*.cue) echo "validation-prompt" ;;
		Pattern narrow ('validate-*.cue') paralelo a adr-066 (def-*).
		Convenção de prefixo estabelecida em todos os 14 VPs;
		preserva opção de futuros arquivos não-validate (e.g.,
		shared types, README local) sem amendment.

		(2) ESCOPO: instances. Schema #ValidationPrompt
		(architecture/artifact-schemas/validation-prompt.cue) já
		coberto por pattern artifact-schema. Structural-check
		correspondente coberto por adr-068.

		(3) RETROATIVOS IN-FLIGHT: 5 retroativos para VPs modificadas
		nesta branch (verified via git diff origin/main...HEAD) sem
		SRR matching path:
		- validate-adopted-artifacts.cue (created em WI-067 commit
		  06236f6 batch validate-* per adr-061)
		- validate-deferred-decision.cue (created em adr-062 commit
		  4f6abfc bundle deferred-decision artifact type)
		- validate-production-guide.cue (created em WI-067 commit
		  06236f6 batch)
		- validate-readme-config.cue (created em WI-067 commit
		  06236f6 batch)
		- validate-tension-entry.cue (created em WI-067 commit
		  06236f6 batch)
		Para cada um, retroativo cobre 'touch' das modificações
		desta branch (status stable, single round, executionMode
		self-reported).

		(4) REGULARIZAÇÃO TRANSITÓRIA DE VPs EM MAIN SEM SRR: 9 VPs
		não modificadas nesta branch (verified via git diff
		origin/main...HEAD) mas existem em main pre-path-mapping:
		validate-adr.cue, validate-agent-governance.cue,
		validate-agent-spec.cue, validate-artifact-schema.cue,
		validate-canvas.cue, validate-domain-definition.cue,
		validate-domain-model.cue, validate-glossary.cue,
		validate-self-review-report.cue. Regularizadas neste mesmo
		commit via 9 entries em self-review-bootstrap-policy.cue
		(categoria pre-mapping-transient extendida de adr-067/068).
		Cada exception sai quando próxima modificação criar SRR
		matching path. Total da categoria pós-adr-069: 14 entries
		(4 PGs + 1 SC + 9 VPs).

		(5) MATERIALIZAÇÃO: single commit consolidado com este ADR +
		script edit + 5 retroativos + 9 bootstrap exceptions
		transientes + ADR-069 self-review. 17 arquivos.

		(6) FUTURE EXTENSION (continua pattern): outros types remain
		candidates per adr-060/066/067/068 framing. Próximos:
		- canvas (4 instances, BC contracts) — separate ADR per type
		- glossary, domain-model (BC artifacts)
		- work-governance singleton
		- adopted-artifacts + readme-config já cobertos por adr-061
		"""

	consequences: """
		Positivas:

		(P1) validation-prompt instances enforced por CI — modificações
		futuras a qualquer VP requerem self-review report explícito.
		Layer advisory de design review fica protegida contra drift
		silencioso.

		(P2) Continuidade direta do pattern adr-060/066/067/068:
		ADR + script edit + retroativos in-flight + bootstrap
		exceptions transientes para state pre-mapping + defersTo
		def-011.

		(P3) Pattern narrow ('validate-*.cue') preserva opção de
		expansion incremental — paralelo exato a adr-066 def-*
		reasoning. Futuros arquivos não-validate (shared types,
		README local) entram via amendment explícito.

		(P4) Coverage agora cobre 14 types via mapping (13 prior +
		validation-prompt).

		(P5) adr-069 intentionally increases the empirical basis for
		def-011; the repeated trigger is evidence, not failure.
		Volume da categoria pre-mapping-transient salta de 5 para
		14 entries — base empírica para decisão de promoção a
		schema first-class cresce significativamente.

		Negativas:

		(N1) 5 retroativos overhead — relatórios criados post-fact
		para cobrir CI requirement. Mitigação: pattern existente
		(paralelo exato a adr-060/068 com 5 retros); reports brief
		cobrem touches específicas.

		(N2) 9 bootstrap exceptions adicionadas — policy file cresce
		significativamente (de 11 entries pós-adr-068 para 20 entries
		pós-adr-069). Surface area de governance cresce; mitigação
		= categoria explícita na prose rationale + def-011 documenta
		deferimento de generalização.

		(N3) Surface area de consistency entre mapping, #ArtifactType,
		structural-check.artifactType, e PG cascade-ordering coveredSchemas
		cresce. Manter sync entre os 4 é responsabilidade editorial
		até structural-check eventual capturar pair-coverage entre
		mapping e schemas.

		Known gaps declarados:
		- 9 VPs em main sem SRR matching path: regularizadas via
		  bootstrap exception transient (categoria pre-mapping-
		  transient). Saem quando próxima modificação criar SRR
		  matching path.
		- def-011 trigger fires again (count 4→5). After this commit,
		  def-011 should be actively reconsidered before the next
		  path-mapping ADR. Volume cumulativo da categoria
		  pre-mapping-transient (14 entries) + 2 refires consecutivos
		  (adr-068, adr-069) acumulam empirical basis para decisão
		  de promoção a schema first-class.
		- canvas/glossary/domain-model paths (BC artifacts):
		  separate ADRs per type.
		- work-governance singleton: separate ADR.

		Fronteira regulatória: nenhuma. Decisão é meta-estrutural
		sobre CI enforcement scope.
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"scripts/ci/check-self-review.sh",
		"governance/build-time/self-review-bootstrap-policy.cue",
		"architecture/artifact-schemas/quality-criteria.cue",
	]

	plannedOutputs: [
		"governance/build-time/self-reviews/validate-adopted-artifacts-vp-touch.self-review.cue",
		"governance/build-time/self-reviews/validate-deferred-decision-vp-touch.self-review.cue",
		"governance/build-time/self-reviews/validate-production-guide-vp-touch.self-review.cue",
		"governance/build-time/self-reviews/validate-readme-config-vp-touch.self-review.cue",
		"governance/build-time/self-reviews/validate-tension-entry-vp-touch.self-review.cue",
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
		declarativo para governance scope. Validation-prompts são
		layer advisory central ao governance system (per adr-040);
		coverage incompleta seria violação do princípio aplicado às
		próprias regras de revisão semântica.

		P10 (gates determinísticos validam): CI self-review-check é
		gate determinístico aplicado sobre VPs (que são layer
		advisory). Meta-aplicação: o gate determinístico protege a
		layer advisory contra drift, preservando a separação
		categórica do adr-040.

		Sem axiomas tensionados.

		Lenses consultadas:

		lens-real-options: pattern narrow ('validate-*.cue') preserva
		opção de expansion incremental. Futuros prefixos diferentes
		(e.g., 'shared-' para shared types, 'README' local) entram
		via amendment explícito, não inferência tácita. Pattern broad
		seria irreversível sem ADR. Mesmo reasoning de adr-066.

		Relação com outras ADRs:

		- DESCENDS adr-060 (pattern de extensão progressiva).
		- DESCENDS adr-066 + adr-067 + adr-068 (continuação direta —
		  validation-prompt era explicit known gap em adr-067 + adr-068).
		- COMPLEMENTA adr-040 (separação categórica entre gates
		  determinísticos e validação semântica advisory): VPs
		  agora também cobertos por self-review enforcement.
		- DEFERS TO def-011 (schema first-class para transient
		  bootstrap exception lifecycle): adr-069 estende categoria
		  pre-mapping-transient com 9 entries adicionais (total=14)
		  e fires trigger pela 2ª vez consecutiva. Volume cumulativo
		  é evidence calibrating decision.
		- PRECEDE potential ADRs para canvas/glossary/domain-model
		  + work-governance singleton.
		- SEM supersession.

		Justificativa de risk metadata:

		reversibility 'high': script edit é puramente aditivo;
		reversão é remover 1 linha. Mesmo pattern de adr-060/066/067/068.

		blastRadius 'cross-cutting': afeta todos VP instances
		(14 atuais + futures). VPs cobrem múltiplos artifactTypes
		via matchPatterns próprios; cross-cutting por construção.
		Não atravessa fundamental governance infrastructure.
		"""
}
