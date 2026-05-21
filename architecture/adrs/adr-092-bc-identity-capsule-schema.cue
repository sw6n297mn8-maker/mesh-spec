package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr092: artifact_schemas.#ADR & {
	id:    "adr-092"
	title: "BC Identity Capsule schema — strategic enforcement anchor"
	date:  "2026-05-21"

	decisionClass: "foundational"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/artifact-schemas/bc-identity-capsule.cue",
	]

	plannedOutputs: [
		"strategic/identity-capsules/",
	]

	context: """
		ADR-090 D4 anticipated BC Identity Capsule como anchor mecânico
		de identidade do BC. ADR-091 materializou schema do Strategic
		Alignment Guardrail referenciando identityCapsuleRef path
		canonical "strategic/identity-capsules/{bc}.cue" mas Capsule
		schema ainda não existia.

		ADR-091 D5 estabeleceu transição Phase 1 → Phase 2:
		- Phase 1 (ADR-091 only, sem Capsule schema): missing Capsule =
		  non-blocking warning informativo
		- Phase 2 (este ADR-092 commit canoniza Capsule schema): missing
		  Capsule para BC alvo de bootstrap = hard-fail

		Este ADR materializa schema canonical com 10 campos. Cascade
		ordering: ADR-090 autoriza → ADR-091 materializa Guardrail
		schema → ADR-092 (este) materializa Capsule schema → ADR-093
		materializa Complexity Budget → amendment manualAuthoringProtocol
		integra guardrails como pré-condição executável → instâncias
		por BC durante reboot FCE/NTF/NIM.

		Capsule é qualitativamente distinto de strategic/subdomains/
		{bc}.cue:
		- subdomain.cue: strategic declaration (intent original, lifecycle
		  estratégico)
		- identity-capsule.cue: enforcement anchor (envelope operacional,
		  lifecycle de governance executável)

		Coupling circular evitado via subdomainRef interface explícita:
		Capsule referencia subdomain como contexto, NÃO duplica fields,
		NÃO embeds.
		"""

	decision: """
		D1 — LOCALIZAÇÃO CANONICAL:
		- Schema: architecture/artifact-schemas/bc-identity-capsule.cue
		- Instâncias: strategic/identity-capsules/{bc}.cue
		Lifecycle separation entre strategic declaration (subdomain) e
		enforcement anchor (capsule) preservado.

		D2 — SCHEMA #BcIdentityCapsule com 10 campos canonical:
		1. boundedContextRef (BC code)
		2. subdomainRef (path canonical strategic/subdomains/{bc}.cue)
		3. intendedSystemRole (declarative role statement)
		4. allowedSemanticCenter (≥1 obrigatório)
		5. forbiddenSemanticCenter (pode vazio mas required)
		6. semanticCenterGravity (required, non-enforced Phase 1)
		7. authorizedCapabilityRefs (pode vazio mas required)
		8. forbiddenCapabilityClasses (pode vazio mas required)
		9. allowedAbstractionTier (single value)
		10. forbiddenAbstractionTiers (pode vazio mas required)
		Plus rationale obrigatório.

		D3 — 4-TIER ABSTRACTION ENUM CANONICAL:
		- operational: execution-level, day-to-day business operations
		- structural: defines architectural patterns, schemas, contracts
		- constitutional: governance over operations
		- meta-constitutional: governance over governance
		Reflete classificação implícita observada na análise do drift
		NIM. Extensão futura via schema delta + ADR.

		D4 — TODOS CAMPOS REQUIRED MESMO VAZIOS:
		Princípio "explicit > implicit". Founder declarando lista vazia
		é sinal canonical "considerei e nada é forbidden"; campo
		omitido é sinal canonical "não pensei sobre". Distinção
		importante para auditabilidade.
		Excessão: semanticCenterGravity required mas Phase 1 non-enforced
		— campo serve como declarative anchor para futura heuristic
		guardrails (ADR-094+) sem comprometer determinismo Phase 1.

		D5 — CAMPO authorizedCapabilityRefs CANONICAL:
		Lado direito explícito do Guardrail constraintKind=unauthorized-
		capability-expansion. Sem este campo, guardrail ficaria sem
		referência canônica para comparar canvas/domain-model
		capabilityRefs. Required, pode ser vazio (BC sem capabilities
		autorizadas é caso válido durante bootstrap inicial).

		D6 — CAMPO semanticCenterGravity NON-ENFORCED Phase 1:
		Required no schema desde início per founder direction (remover
		agora forçaria reabertura da ontologia do Capsule em ADR-094).
		Armazenado como âncora declarativa para leitura humana/agente.
		Phase 2+ (ADR-094+ anticipated): heuristic guardrails poderão
		consumir como input para detection de gradual displacement
		quando métricas robustas existirem.

		D7 — PHASE 1 → PHASE 2 TRANSITION ATIVADA:
		Materialização deste schema (commit deste ADR) ativa
		automaticamente transição declarada em ADR-091 D5. Strategic
		Alignment Guardrail passa de modo warning informativo para
		hard-fail quando BC alvo de bootstrap não tiver Capsule
		instanciado.

		D8 — ESCOPO NON-INCLUDED EXPLICITO (deferred):
		- Instâncias específicas por BC: materialized durante reboot
		  FCE/NTF/NIM ou bootstrap de novos BCs
		- Heuristic enforcement de semanticCenterGravity: ADR-094+
		- Complexity Budget schema: ADR-093 (próximo cascade step)
		- Amendment manualAuthoringProtocol: ADR separado pós-093
		"""

	consequences: """
		Positive:
		- ADR-091 Phase 2 ativada automaticamente: missing Capsule para
		  BC alvo de bootstrap se torna hard-fail
		- Strategic intent ganha enforcement anchor mecânico
		- 4-tier abstraction enum previne escalada implícita (e.g.,
		  BC operational virando meta-constitutional sem ADR
		  autorizando)
		- subdomainRef interface explícita previne coupling circular
		  entre strategic declaration e enforcement envelope
		- authorizedCapabilityRefs dá lado direito explícito ao
		  Guardrail de capability expansion
		- semanticCenterGravity preserved como declarative anchor
		  evita cascade reverso em ADR-094

		Negative:
		- Schema novo a manter
		- Diretório novo strategic/identity-capsules/ (vazio até
		  instâncias por BC)
		- Cada BC ganha mais um arquivo a manter
		- Phase 2 ativada significa novos bootstraps EXIGEM Capsule
		  antes de canvas
		- BCs existentes (14 total) ficam temporariamente sem Capsule;
		  hard-fail só se aplicam a bootstraps NOVOS post-este-commit
		"""

	principlesApplied: [
		"P10-stochastic-vs-deterministic — 9 deterministic fields + 1 declarative-only (semanticCenterGravity Phase 1)",
		"adr-040-structural-vs-semantic-validation-separation — schema é deterministic gate input",
		"adr-088-formalize-mcm-execution-class — precedent: schema delta canonical via ADR",
		"adr-089-add-observation-action-category — precedent: additive constitutional extension",
		"adr-090-semantic-escalation-bc-bootstrap-reboot-authorization — D4 autoriza criação deste Capsule",
		"adr-091-strategic-alignment-guardrail-schema — Capsule serve como input ao Guardrail; D5 transição Phase 1 → Phase 2 ativada por este commit",
	]

	rationale: """
		Schema completa cascade arquitetural autorizado em ADR-090 D4:
		Strategic Intent (subdomain) → Enforcement Anchor (Capsule) →
		Enforcement Validator (Guardrail). Sem Capsule, Guardrail não
		tinha referência canônica para validar; sem schema canonical,
		Capsule por BC ficaria heterogêneo entre bootstraps.

		Capsule consome subdomain via subdomainRef, NÃO duplica nem
		embeds. Lifecycle separation:
		- subdomain.cue: strategic intent autoritativo, evolui em
		  cadência estratégica
		- identity-capsule.cue: enforcement envelope, evolui em cadência
		  de governance executável
		Cadências podem divergir (e.g., refinar enforcement sem mudar
		intent estratégico) sem gerar coupling circular.

		10 campos canonical Phase 1:
		- 9 deterministic enforcement fields (boundedContextRef,
		  subdomainRef, intendedSystemRole, allowedSemanticCenter,
		  forbiddenSemanticCenter, authorizedCapabilityRefs,
		  forbiddenCapabilityClasses, allowedAbstractionTier,
		  forbiddenAbstractionTiers)
		- 1 declarative-only field (semanticCenterGravity)
		Distinção alinhada com ADR-091 escopo deterministic-first.

		semanticCenterGravity required-but-non-enforced (per founder
		ajuste Q1 final): remover agora forçaria reabertura da
		ontologia do Capsule em ADR-094 quando heuristic guardrails
		emergirem. Mantido como declarative anchor desde Phase 1
		previne cascade reverso. Campo serve como input para humans
		e agentes interpretarem deslocamento semântico antes de
		métrica determinística existir.

		authorizedCapabilityRefs (per founder ajuste adicional): dá
		lado direito explícito ao Guardrail constraintKind=
		unauthorized-capability-expansion. Sem este campo, Guardrail
		ficaria órfão de referência canônica. Required pode-ser-vazio:
		BC bootstrap inicial sem capabilities autorizadas é caso
		válido.

		4-tier abstraction enum fechado:
		- operational: execução, day-to-day business
		- structural: arquitetura, schemas, contratos
		- constitutional: governance over operations
		- meta-constitutional: governance over governance
		Reflete análise do drift NIM (operational original → meta-
		constitutional sem ADR autorizando). Enum fechado previne
		introdução implícita de tiers via prose; extensão futura
		exige ADR explícito (precedent ADR-088 + ADR-089).

		Todos campos required mesmo vazios (D4): princípio "explicit >
		implicit". Lista vazia declarada é sinal canonical "considerei
		e nada é forbidden"; campo omitido é "não pensei sobre".
		Distinção importante para auditabilidade.

		Reversibility medium: schema é additive (não-breaking para
		artifacts existentes que não consomem Capsule ainda). Revert
		exige remoção do schema + instâncias materializadas em commits
		subsequentes. ADR-091 referencia identityCapsuleRef regex; se
		Capsule schema removido, ADR-091 precisaria amendment.

		BlastRadius cross-cutting: schema novo afeta categoria de
		governance (cross-artifact entre todos BCs futuros). Não
		repo-wide porque tooling não requer changes neste commit
		(instâncias virão depois).

		Phase 1 → Phase 2 transition (D7): este commit ativa
		automaticamente transição declarada em ADR-091 D5. Strategic
		Alignment Guardrail passa de warning informativo para hard-fail
		quando faltar Capsule para BC alvo de bootstrap. Mecanismo
		previne "no-op buraco permanente" identificado em founder
		ajuste de ADR-091.

		Cascade ordering preservado: este ADR materializa schema mas
		NÃO instâncias. Próximo passo cascade: ADR-093 Complexity
		Budget schema, depois amendment manualAuthoringProtocol,
		depois instâncias específicas por BC durante reboot.
		"""
}
