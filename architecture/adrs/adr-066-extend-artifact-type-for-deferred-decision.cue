package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr066: artifact_schemas.#ADR & {
	id:    "adr-066"
	title: "Extend artifact_type_for_path to cover deferred-decision instances"
	date:  "2026-05-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		State-of-affairs precedente:
		- adr-060 estabeleceu pattern de adoção progressiva para
		  artifact_type_for_path em scripts/ci/check-self-review.sh:
		  cada instance type entra no mapping via ADR específico
		  quando criticality + volume + maturidade justificarem.
		- adr-060 explicitamente diferiu canvas, glossary, domain-model,
		  structural-checks, validation-prompts, production-guides e
		  outros para ADRs subsequent (decision item 6: 'Adoção
		  progressiva > big-bang scope creep').
		- Sessão 2026-05-03 (claude/resume-mesh-work-jv2MC) materializou
		  novo artifact type deferred-decision (per adr-062) com 10
		  instances criadas (def-001..010) durante a sessão. Pattern
		  é central ao governance machinery — sistema designed to
		  track drift deve ele próprio ser tracked.

		Trigger desta ADR: durante autoria de def-001..010, todos os
		10 self-review reports foram criados voluntariamente seguindo
		discipline da sessão (precedent def-001 commit 0e9618e).
		Resultado: zero backlog de retroativos quando CI mapping
		formaliza enforcement. Primeiro caso post-adr-060 onde
		discipline preventiva da sessão removeu necessidade de
		retroativos — pattern reusable para futuros types.

		Análise per adr-060 critérios:
		- Criticality: deferred-decisions são mecanismo de cobrança
		  automática de dívida (per adr-062); modificações sem
		  self-review = drift no sistema designed to detectar drift.
		  HIGH criticality.
		- Volume: 10 instances criadas em uma sessão. Crescente per
		  adoption pattern (cada Opção B-style decision = 2-5 def-XXX).
		- Maturidade: schema #DeferredDecision + PG + runner +
		  CLAUDE.md guidance materializados em adr-062 + commits
		  subsequents. Discipline establecida.

		Alternativas avaliadas:
		(a) Status quo (deferred-decision não enforced) — rejeitada:
		modificações futuras podem driftar sem self-review;
		discipline voluntária da sessão não é declarativa.
		(b) Adicionar com pattern broad (architecture/deferred-
		decisions/*.cue) — rejeitada: pattern narrow ('def-*.cue')
		preserva opção de futuros prefixos diferentes (ex: 'meta-*'
		para meta-deferrals) sem irreversibilidade.
		(c) Batch com work-governance (também unmapped) — rejeitada:
		concerns disjuntos (debt tracking vs execution state).
		Pattern adr-060 é 1 ADR por type exceto 'natural pair' como
		agent-spec/agent-governance.
		(d) Adicionar com retroativos (mesmo voluntary discipline tendo
		coberto) — rejeitada: redundante; voluntary SRRs já satisfazem
		o que retroativos cobririam. Pattern de adr-060 retroativos
		era para in-flight gap; não há gap aqui.
		"""

	decision: """
		(1) ADICIONAR pattern para deferred-decision ao
		artifact_type_for_path em scripts/ci/check-self-review.sh:
		    architecture/deferred-decisions/def-*.cue) echo "deferred-decision" ;;
		Pattern matches arquivos com prefixo 'def-' em
		architecture/deferred-decisions/. Narrow conscientemente —
		futuros prefixos diferentes (e.g., 'meta-deferred-XXX' se
		emergir taxonomia adicional) entram via amendment.

		(2) ESCOPO: apenas instances. Schema #DeferredDecision
		(architecture/artifact-schemas/deferred-decision.cue) e PG
		(architecture/production-guides/deferred-decision.cue) já
		estão cobertos por patterns existentes (artifact-schema
		para schema; production-guide path NÃO está mapeado mas é
		separate concern para outro ADR).

		(3) RETROATIVOS: ZERO. 10 def-XXX existentes (def-001..010)
		já têm self-review reports voluntários criados durante
		sessão claude/resume-mesh-work-jv2MC. Discipline preventiva
		removeu backlog. Primeiro caso post-adr-060 com este
		pattern.

		(4) MATERIALIZAÇÃO: single commit com este ADR + script
		edit + ADR-066 self-review report. Decisão estrutural única;
		commits separados criariam janela onde script enforce mas
		(neste caso) já está coberto por SRRs voluntários.

		(5) FUTURE EXTENSION (continua adr-060 framing): outros
		types remain candidates para ADRs subsequents quando
		criticality + volume + maturidade justificarem:
		- production-guide (9 instances, 4 modified this session)
		- structural-check (6 instances, 5 modified)
		- validation-prompt (14 instances, 2+ modified)
		- canvas (4 instances, BC contracts, stable)
		- tension-entry (11 instances, stable)
		- work-governance (1 singleton, recently added per adr-064)
		- adopted-artifacts (1 singleton)
		- readme-config (1 singleton)
		Cada um requer ADR próprio com retroativos quando aplicável.
		"""

	consequences: """
		Positivas:

		(P1) deferred-decision instances enforced por CI — modificações
		futuras a def-XXX requerem self-review report explícito.
		Sistema designed to track drift (adr-062) agora é ele próprio
		tracked sem drift.

		(P2) Pattern de discipline preventiva validado: voluntary SRRs
		durante criação de instances eliminam backlog de retroativos
		quando CI mapping formaliza enforcement. Primeiro caso
		post-adr-060 com este pattern; reusable para futuros types.

		(P3) Pattern narrow ('def-*.cue') preserva opção de expansion
		incremental. Futuros prefixos (e.g., 'meta-' se taxonomia
		evoluir) entram via amendment explícito, não inferência tácita.

		(P4) Continuidade do pattern adr-060: ADR + script edit +
		(zero) retroativos. Pattern reusable para production-guide,
		structural-check, validation-prompt, canvas, tension-entry,
		work-governance — cada um com ADR próprio.

		Negativas:

		(N1) Coverage agora cobre 11 types via mapping (10 prior +
		deferred-decision). Surface area de consistency entre
		mapping, #ArtifactType, e #StructuralCheck.artifactType
		cresce — manter sync entre os 3 é responsabilidade editorial
		até structural-check eventual capturar pair-coverage.

		(N2) Outros types unmapped (canvas, glossary, domain-model,
		etc.) permanecem não-enforced — gap reconhecido, deferido per
		adr-060 progressive adoption. Mitigação: cada type merece
		justificativa contextualizada via ADR próprio.

		(N3) Pattern '*.cue' OR 'def-*.cue' choice — escolhido narrow
		('def-*.cue'). Tradeoff: mais conservador (qualquer prefixo
		futuro requer expansion explícita) vs perdoa typos (e.g.,
		arquivo 'foo.cue' em deferred-decisions/ não match e não
		gera enforcement). Aceitável: tipos errados em wrong directory
		são detectados por outras gates (cue vet semantic, structural-
		check filesystem-path-exists futuro, etc.).

		Known gaps declarados:
		- production-guide path mapping NÃO incluído neste ADR.
		  Production-guides têm 9 instances + 4 modified this session;
		  forte caso para inclusão mas separate ADR per adr-060
		  progressive pattern. Próximo candidato natural.
		- Outros 8 types unmapped permanecem como candidates por
		  prioridade de criticality + volume.

		Fronteira regulatória: nenhuma. Decisão é meta-estrutural
		sobre CI enforcement scope.
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"scripts/ci/check-self-review.sh",
	]

	plannedOutputs: []

	principlesApplied: [
		"P10",
		"P12",
	]

	supersedes: []

	rationale: """
		Princípios aplicados:

		P12 (governança como código): script edit é veículo declarativo
		para governance scope. artifact_type_for_path é tabela canônica
		que define o que CI enforce; expansão via ADR + script edit é
		discipline declarativa. Continuidade direta do pattern de
		adr-060.

		P10 (gates determinísticos validam): CI self-review-check é
		gate determinístico. Adicionar deferred-decision ao mapping
		torna o gate efetivo para esse tipo crítico — without it,
		gate falha silenciosamente para modificações em def-XXX
		(sistema designed to track drift falhando para si próprio).

		Sem axiomas tensionados.

		Lenses consultadas:

		lens-real-options: pattern narrow ('def-*.cue') preserva
		opção de expansion incremental quando taxonomia de deferred-
		decisions evoluir (e.g., meta-deferrals, calibration-
		deferrals). Pattern broad seria irreversível sem ADR.

		Relação com outras ADRs:

		- DESCENDS adr-060 (pattern de extensão progressiva). Primeiro
		  caso post-adr-060 sem retroativos por discipline preventiva.
		- COMPLEMENTA adr-062 (sistema deferred-decision). adr-062
		  estabeleceu o tipo; adr-066 enforce CI coverage do tipo.
		- PRECEDE potential ADRs para outros types unmapped (per
		  adr-060 progressive pattern; lista em decision item 5).
		- SEM supersession.

		Justificativa de risk metadata:

		reversibility 'high': script edit é puramente aditivo;
		reversão é remover 1 linha. Nenhum dado persistido afetado;
		nenhum contrato público alterado. Mesmo pattern de adr-060.

		blastRadius 'cross-cutting': afeta todos deferred-decision
		instances (10 atuais + futures). Não atravessa fundamental
		governance infrastructure (não é repo-wide); afeta o sistema
		de cobrança de dívida que opera cross-domain via behavioral
		shift sistêmico.
		"""
}
