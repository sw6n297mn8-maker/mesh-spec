package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr080: artifact_schemas.#ADR & {
	id:    "adr-080"
	title: "Extend #StructuralCheck with domain-invariant kind for unified enforcement (filesystem + semantic + runtime-gap declaration)"
	date:  "2026-05-07"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		O artifact #StructuralCheck foi originalmente desenhado (adr-040
		+ adr-041) para validar estrutura estática do repositório:
		presença/ausência de arquivos, referências cross-artifact,
		integridade de paths, pareamento de diretórios. 8 kinds atuais
		(required-block, reference-exists, same-artifact-consistency,
		conditional-file-presence, production-guide-coverage,
		filesystem-path-exists, directory-pair-coverage,
		at-least-one-block-present) cobrem dimensão filesystem-level.

		Com a evolução do INV (Phase 3 — domain-model materializado em
		commits 4e95f15..df99588), emergiu a necessidade de declarar
		invariantes de domínio como garantias explícitas e verificáveis.
		8 invariants do INV (atomic-dual-emission, idempotent-issuance,
		regime-immutability, lifecycle-states, cancellation-boundary,
		fiscal-doc-ref-integrity, cancellation-event-required,
		receivable-referential-integrity) representam contracts
		semânticos do domínio que NÃO cabem nos 8 kinds existentes:
		- invariantes formais (∀, ∧, ⇒) não são cross-artifact refs
		- distinção build-time vs runtime enforcement não existe
		- declaração explícita de limites (runtime gaps) não existe
		- anti-patterns proibidos não cabem em existing rule shapes

		Tensão estrutural identificada (Phase 3.5 design session):
		- Criar novo artifact (#DomainEnforcementSpec) fragmenta
		  enforcement em múltiplos lugares
		- Reutilizar existing kinds adaptados perde os invariantes
		  mais críticos (atomicidade, idempotência, boundary temporal)
		- Phase 3.5 sem fundação cria risco silencioso: agent-spec
		  Phase 4 vai interpretar invariants como guidelines, aplicar
		  guards como heurística, inventar exceções "plausíveis" — e
		  tudo passa no cue vet

		Decisão necessária: unificar enforcement estrutural (filesystem)
		e semântico (domínio) no mesmo mecanismo, mantendo backward
		compatibility com 8 kinds existentes.
		"""

	decision: """
		ADOPT 3 mudanças coordenadas em
		architecture/artifact-schemas/structural-check.cue:

		(D1) Add new kind 'domain-invariant' a #StructuralCheckKind
		     enum (de 8 para 9 kinds).

		(D2) Add #DomainInvariantRule a #StructuralCheckRule
		     disjunction + branch correspondente em #StructuralCheck
		     discriminated union.

		(D3) Define #DomainInvariantRule com fields:
		     - invariantId: regex paralelo #InvariantRef do
		       domain-model schema (^inv-[a-z][a-z0-9-]+$)
		     - assertion?: optional formal logic string (espelha
		       domain-model rule field)
		     - coverage: struct {buildTime, validationTime,
		       runtimeRequired} declarando cobertura explícita por
		       dimensão
		     - runtimeGap?: optional struct {description, enforcedBy}
		       declarando limite explícito quando runtimeRequired=true
		     - forbidden?: optional list anti-patterns proibidos por
		       construção semântica

		RESTRIÇÕES (manter compatibility):
		- Nenhuma alteração nos 8 kinds existentes
		- Nenhum campo novo fora de rule (top-level fields de
		  #StructuralCheck inalterados — id, title, artifactType,
		  description, kind, rule, errorMessage, rationale)
		- Compatibilidade total com tooling atual: instances dos 8
		  kinds anteriores continuam válidas sem mudança
		- Novo kind semanticamente isolado em sua rule shape — não
		  compartilha estrutura com outros rule types

		**Conceito central introduzido**: 'declaração de garantia +
		declaração explícita de limite'. StructuralCheck deixa de ser
		apenas validação de arquivos e passa a ser sistema unificado
		de:
		(1) Garantias estruturais (filesystem-level — 8 kinds
		    existentes)
		(2) Garantias semânticas (domain-invariant — novo kind)
		(3) Declaração explícita de limites (runtime gaps via
		    runtimeGap field — novo)

		Runtime gaps NÃO são falhas — são limites conhecidos e
		documentados do sistema. Forma canônica de 'honesty
		arquitetural': sistema declara o que É garantido + o que NÃO
		É garantido + onde está enforcement do gap.
		"""

	consequences: """
		(a) Invariantes de domínio passam a ser first-class citizens
		    no sistema de governança — declaráveis canonicamente em
		    architecture/structural-checks/, validáveis via cue vet
		    contra schema, auditáveis cross-artifact.

		(b) Enforcement deixa de ser implícito (depende de disciplina
		    do agente) → torna-se explícito (declarado per
		    invariant) e auditável (runtime gaps documentados).

		(c) Tooling atual permanece funcional (backward compatible) —
		    8 kinds existentes inalterados; instâncias atuais (sc-cv-*,
		    sc-pg-*, sc-adr-*) continuam válidas sem mudança.

		(d) Domain-model passa a ter rastreabilidade direta para
		    checks via invariantId reference — runner Phase 1+ valida
		    que cada invariantId em structural-check existe em
		    referenced domain-model.

		(e) Cria fundação para Phase 3.5 (structural enforcement)
		    aplicada primeiro a INV (8 invariants → 8 checks) +
		    backfill futuro para outros BCs com domain-model.

		(f) Introduz disciplina canônica: toda garantia deve declarar
		    também seu limite. runtimeGap obrigatório quando
		    coverage.runtimeRequired=true previne 'silent-failure-by-
		    construction' (gap não documentado = surpresa em
		    produção).

		(g) Evita fragmentação de enforcement em múltiplos artifacts
		    — preserva structural-check como lugar único de verdade
		    para enforcement (filesystem + semântico + gaps).

		(h) Validation-prompts (advisory layer per adr-040) ganham
		    estrutura para avaliar consistência semântica entre
		    invariant + assertion + forbidden patterns —
		    complementa o gate determinístico estrutural com review
		    interpretativo.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/artifact-schemas/structural-check.cue",
	]

	plannedOutputs: [
		"#DomainInvariantRule type (architecture/artifact-schemas/structural-check.cue)",
		"domain-invariant kind extension to #StructuralCheckKind enum",
		"new branch in #StructuralCheck discriminated union",
	]

	derivedArtifacts: [
		"architecture/structural-checks/inv-domain-model.cue (Phase 3.5 INV instance — primeira aplicação)",
	]

	principlesApplied: [
		"P10-deterministic-gates-vs-stochastic-recommendations",
		"adr-040-structural-vs-semantic-validation-separation",
		"adr-077-canvas-metric-onbreach-field",
		"adr-079-direct-action-vs-escalation",
	]

	rationale: """
		Reversibility medium: schema addition é optional/non-breaking
		(novo kind isolado), mas remoção pós-adoção exigiria
		backward-incompat ADR + migration de instances. BlastRadius
		cross-cutting: afeta sistema de enforcement transversal +
		potencial backfill para múltiplos BCs com domain-model.

		Decisão prioriza UNIFICAÇÃO sobre PUREZA TEÓRICA. Alternativas
		consideradas:
		(A1) Novo artifact type #DomainEnforcementSpec — REJEITADA
		     (fragmenta enforcement em múltiplos lugares; quebra
		     'lugar único de verdade')
		(B) Adaptar a kinds existentes — REJEITADA (perde
		     atomicidade + idempotência + boundary temporal — exatamente
		     os invariantes mais críticos)
		(A2) Extend #StructuralCheck com novo kind isolado —
		     ADOPTED (esta decisão; preserva existing kinds intactos +
		     unifica filesystem + semântico)

		Conceito central 'garantia + limite explícito' transforma
		sistema de governança de:
		'validação do que existe' → 'declaração do que é garantido
		e até onde'.

		Sem este shift, agent-spec Phase 4 + governance envelope
		Phase 5 vão depender de disciplina do agente para respeitar
		invariants do domain-model. Com este shift, system declara
		canonicamente o escopo real de enforcement — agentes operam
		dentro de boundaries explicitamente documentados, não
		convencionais.

		Pattern paralelo a adr-077 (#VerificationMetric.onBreach
		schema add) + adr-078/079 (PG canvas hardening) — sequência
		de schema/PG hardening emergente de WI-053 INV bootstrap
		demonstra metodologia 'evolução governada via descoberta
		empírica' (Mesh-level moat).
		"""
}
