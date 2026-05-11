package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr087: artifact_schemas.#ADR & {
	id:    "adr-087"
	title: "Rename BDG inv-commitment-id-uniqueness-per-cost-center to global-uniqueness-active (semantic correction)"
	date:  "2026-05-12"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Durante WI-084 BDG structural-check authoring (sc-bdg-07
		idempotência rule), founder identified semantic mismatch entre
		o nome canônico do invariant
		('inv-commitment-id-uniqueness-per-cost-center') e o rule body
		do domain-model + a assertion do structural-check.

		Mismatch concreto:
		- Rule body domain-model (contexts/bdg/domain-model.cue linha
		  309) já diz "Cada CommitmentId tem no máximo um Comprometimento
		  Orçamentário ativo (não liberado) registrado **em BDG**"
		  (global across all CostCenters, NOT per-cost-center).
		- Assertion structural-check sc-bdg-07 expressa GLOBAL uniqueness
		  across entire BDG state (≤ 1 active globally).
		- CommitmentId é CMT-issued canonical id — representa unicidade
		  econômica transversal: um compromisso bilateral só pode ter
		  UMA reserva orçamentária ativa simultaneamente em toda a rede
		  BDG (não per-cost-center).
		- Suffixo 'per-cost-center' carried grandfathered from initial
		  domain-model authoring (artefato predating WI-084
		  structural-check review).

		WI-084 founder ajuste Section 2 #5 Opção C: domain-model rename
		como WI separado (cleanup name canonical antes de IDC/NPM
		authoring; evita cementar mismatch com mais references
		downstream).

		Esta ADR documenta a **semantic correction** (NOT cosmetic
		refactor) consolidando o canonical name com a semantic real
		que o rule body já implementava — eliminando drift entre
		canonical name + rule body + structural-check assertion.

		Affected references count: 11 occurrences across 4 files:
		- contexts/bdg/domain-model.cue (4 occurrences: code + 3
		  references in rationale/description/protectsInvariants)
		- contexts/bdg/agents/bdg-primary-agent.cue (5 occurrences:
		  invariantsProtected + preconditions narrative + onViolation
		  rationale + closing summary)
		- contexts/bdg/agents/bdg-primary-agent.governance.cue (1
		  occurrence: promotionCriteria metric)
		- architecture/structural-checks/bdg-domain-model.cue (1
		  occurrence: rule.invariantId)
		"""

	decision: """
		ADOPT 2 decisões coordenadas:

		(D1) **SEMANTIC CORRECTION** (NOT cosmetic refactor):
		RENAME inv-commitment-id-uniqueness-per-cost-center →
		inv-commitment-id-global-uniqueness-active

		Naming rationale per token:
		- 'global' (substitutes 'per-cost-center') — semantic accurate:
		  uniqueness é sobre CommitmentId/CMT economic identity, NOT
		  scoped per costCenter. CommitmentId é CMT-issued canonical
		  id que atravessa BDG inteiro.
		- 'active' (substitutes 'uniqueness' isolated) — explicit:
		  uniqueness applies to status='active' only; histórico de
		  released BudgetCommitments com mesmo CommitmentId é
		  preservado para auditabilidade. Naming makes scope explicit.
		- 'commitment-id' preserved — discriminates from BudgetCommitmentId
		  uniqueness (which is local per CostCenter via entity identity).

		Característica explícita: **SEMANTIC CORRECTION**, NOT cosmetic
		refactor. Distinção:
		- Cosmetic refactor: name change preserving same imprecise
		  semantic mapping.
		- Semantic correction (esta ADR): name change CORRIGE mapeamento
		  que estava ambíguo — alinha canonical name com semantic real
		  que rule body já implementava ("em BDG" = global).

		Behavior change: ZERO. Rule body domain-model + aggregate guard
		runtime + assertion structural-check NÃO mudam — todos já
		operavam globalmente. Mudança é nomenclatura canônica
		exclusivamente.

		(D2) ATOMIC update across 4 files (mesmo commit; sem dual
		canonical):

		Rationale para atomicidade:
		- Rename canonical preserva linguagem consistente atravessada
		  por 4 artefatos.
		- Partial update criaria broken references temporariamente
		  (structural-check.invariantId apontando para code inexistente
		  em domain-model).
		- **Não manter dois nomes canônicos**: o nome antigo é
		  preservado APENAS em rationale/migration note (ADR context,
		  SRRs históricas WI-084) — NÃO como alias canônico paralelo.
		  Single canonical name post-rename é
		  inv-commitment-id-global-uniqueness-active.

		Alias histórico preservation:
		- ADR-087 context section documenta nome antigo (migration audit
		  trail).
		- SRRs WI-084 (bdg-structural-check.self-review.cue) referenciam
		  nome antigo (historical record — SRRs são append-only audit
		  trail per CLAUDE.md; não editados).
		- NÃO há alias dual canonical em código active — single source
		  of truth post-rename.

		Cleanup side-effect: sc-bdg-07 rationale (architecture/
		structural-checks/bdg-domain-model.cue) "Note grandfathered
		name" paragraph substituído por referência a esta ADR-087.
		"""

	consequences: """
		(a) Canonical name aligns com rule body semantic — **zero
		    drift entre artifacts**; mismatch identificado em WI-084
		    eliminado.

		(b) Pattern reusable: futuro BC com global uniqueness pattern
		    pode usar naming convention 'inv-<entity>-global-uniqueness-
		    active' (vs local 'inv-<entity>-uniqueness-per-<scope>').

		(c) Cleanup antes de IDC/NPM authoring (Tier 3) — evita cementar
		    mismatch com novos references downstream que pudessem surgir
		    durante D-expansion + structural-check authoring desses BCs.

		(d) WI-084 sc-bdg-07 rationale "grandfathered name" note
		    superseded por esta ADR; structural-check rationale cleaned
		    up referenciando ADR-087 ao invés de explicar grandfathered.

		(e) Behavior change ZERO — rule body + aggregate guard + assertion
		    NÃO mudam; rename é alignment exclusivamente. Riscos:
		    nenhum material — string rename atomicamente reversível.

		(f) Single canonical name post-rename: NÃO há dual canonical
		    em código active. Alias histórico apenas em ADR context +
		    SRRs históricas (audit trail — não canonical references).

		(g) Audit trail preservation: SRRs WI-084 retêm nome antigo
		    como historical record per CLAUDE.md (SRRs are append-only;
		    not editable). WI-085 SRR + new ADR-087 carry o nome novo
		    forward.
		"""

	reversibility: "high"
	blastRadius:   "local"

	affectedArtifacts: [
		"contexts/bdg/domain-model.cue",
		"contexts/bdg/agents/bdg-primary-agent.cue",
		"contexts/bdg/agents/bdg-primary-agent.governance.cue",
		"architecture/structural-checks/bdg-domain-model.cue",
	]

	plannedOutputs: [
		"Rename atomic do invariant code em domain-model BDG (4 occurrences: code field + 3 references)",
		"Rename atomic em agent-spec BDG (5 occurrences: invariantsProtected + preconditions narrative + rationale + summary)",
		"Rename atomic em governance envelope BDG (1 occurrence: promotionCriteria metric)",
		"Rename atomic em structural-check sc-bdg-07.rule.invariantId (1 occurrence) + cleanup rationale removing grandfathered note + referencing ADR-087",
	]

	principlesApplied: [
		"P0-zero-duplication",
		"adr-040-structural-vs-semantic-validation-separation",
		"adr-086-domain-invariant-authoring-protocol",
	]

	rationale: """
		Reversibility high: string rename atomicamente reversível;
		nenhuma alteração de behavior, schema, ou contract público.
		Reversão = inverter rename (sem cascading side effects).

		BlastRadius local: 4 files BDG context exclusivamente; nenhum
		BC externo referencia este invariant code (CommitmentId é
		cross-BC mas o invariant code é intra-BDG canonical name).
		Verificação grep pre-rename confirmou: nenhuma referência fora
		dos 4 files listados.

		Decisão prioriza **SEMANTIC CORRECTION DISCIPLINE OVER
		PRESERVATION OF GRANDFATHERED IMPRECISION**:
		- Canonical name DEVE refletir semantic real (P0 zero
		  duplication: name + semantic = single canonical knowledge
		  unit; mismatch = drift por construção)
		- Cleanup antes de cementar mais references downstream
		  (IDC/NPM Tier 3 authoring iminente)
		- Single canonical name post-rename: NÃO manter dual canonical
		  paralelo (founder ajuste #2 explícito)

		**Pattern paralelo ADR-086 closing loop**:
		ADR-086 canonizou Domain-Invariant Structural Check Authoring
		Protocol. WI-084 BDG structural-check authoring (forward
		application do protocol) identificou o mismatch via founder
		dialectic Section 2 #5. ADR-087 closes the loop corrigindo
		nome canônico identificado durante DISCAP forward authoring.

		**Distinção semantic correction vs cosmetic refactor**:
		- Cosmetic refactor: renomeia preservando ambiguity (e.g.,
		  renomear 'foo' para 'foo2' sem alterar mapping semantic).
		- Semantic correction (esta ADR): renomeia CORRIGINDO mapping
		  — nome anterior era impreciso (sugeria 'per-cost-center'
		  scope) enquanto rule body operava global. Novo nome alinha
		  com semantic real.

		Esta distinção é registrada explicitamente per founder ajuste
		#1 (semantic correction, NOT refactor cosmético) — preserva
		audit trail que documente POR QUE o rename foi necessário,
		não apenas QUE rename ocorreu.

		**Alias histórico preservation discipline** (founder ajuste #2):
		- Alias histórico (nome antigo) preserved APENAS em rationale/
		  migration note do ADR + SRRs históricas WI-084 (audit trail
		  append-only).
		- NÃO há dual canonical em código active: post-rename, single
		  canonical é inv-commitment-id-global-uniqueness-active.
		- Future references must use novo nome exclusivamente.

		**Verificação pos-rename**:
		grep -rn "inv-commitment-id-uniqueness-per-cost-center" --include="*.cue"
		deve retornar APENAS:
		- governance/build-time/self-reviews/bdg-structural-check.
		  self-review.cue (WI-084 SRR historical record — append-only)
		- architecture/adrs/adr-087-*.cue (este ADR context section
		  documentando nome antigo)
		- governance/build-time/self-reviews/adr-087-*.self-review.cue
		  (WI-085 SRR documenting o rename)
		Zero occurrences em código active (domain-model, agent-spec,
		governance, structural-check).
		"""
}
