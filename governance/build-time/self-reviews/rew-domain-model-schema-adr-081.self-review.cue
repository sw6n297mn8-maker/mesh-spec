package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

domainModelSchemaAdr081: build_time.#SelfReviewReport & {
	reportId: "srr-domain-model-schema-adr-081"

	artifactPath:       "architecture/artifact-schemas/domain-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-09"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 1
		summary: """
			Schema #DomainModel + #Aggregate estendidos com interpretation
			contracts layer per adr-081. 7 mudanças coordenadas:

			(D1) #InterpretationContractMarker definition — embedded
			     marker pattern para single source of truth de _meta
			     value; previne drift cross-type via convenção CUE
			     (hidden field `_*` semantics).

			(D2) #ConsistencyBoundary type — closed struct embedding
			     marker:
			     - guarantees: non-empty list (cardinality ≥1) of
			       non-empty strings
			     - explicitlyDoesNotGuarantee: non-empty list
			     - failureModes: non-empty list
			     - rationale: non-empty string

			(D3) #SystemConsistencyModel type — closed struct embedding
			     marker:
			     - type enum (eventual|strong|causal)
			     - 3 listas non-empty (intra/cross-aggregate guarantees
			       + explicitlyDoesNotGuarantee)
			     - conflictResolution nested struct (strategy enum
			       last-write-wins|explicit-command|causal-ordering +
			       rationale)
			     - rationale

			(D4) #DecisionAuthorityModel — discriminated union sobre
			     type field (paralelo a #DomainEvent pattern):
			     #AuthoritativeAuthority | #AdvisoryAuthority |
			     #HybridAuthority. Cada branch obriga scope field
			     correspondente E PROÍBE scopes não-aplicáveis via
			     `_|_` (bottom — torna estado misto irrepresentável).

			(D5) consistencyBoundary?: #ConsistencyBoundary adicionado
			     a #Aggregate como optional field (após lifecycle?:,
			     antes de rationale).

			(D6) systemConsistencyModel?: #SystemConsistencyModel +
			     decisionAuthorityModel?: #DecisionAuthorityModel
			     adicionados a #DomainModel como optional fields
			     (após projections?:, antes de rationale).

			(D7) Nenhum tq-dm-XX criterion novo neste ADR — contratos
			     são DECLARATIVOS (informational); future ADR pode
			     adicionar criteria como 'consistencyBoundary
			     guarantees overlap-free cross-aggregates' quando
			     evidência empírica justifique.

			**3 GUARDRAILS APLICADOS via founder pre-write tightening**:

			(G1) Listas non-empty: [string & !='', ...string & !='']
			     em todas guarantees/doesNotGuarantee/failureModes/
			     intraAggregate/crossAggregate. Insight: 'contrato
			     vazio é pior que ausência de contrato'. Ausência de
			     campo = contrato não declarado (default eventual);
			     campo com lista vazia = declaração explícita de
			     null contract = anti-pattern.

			(G2) Marker via embedding (#InterpretationContractMarker)
			     em vez de inline `_meta: "interpretation-contract"`
			     literal em cada type. Single source of truth do
			     _meta value cross-types; previne drift; aproveita
			     CUE hidden field semantics (`_*` não exportado em
			     cue export).

			(G3) Discriminated union exclusiva via `_|_` em
			     #DecisionAuthorityModel branches. Estado inválido
			     (advisory com authoritativeScope; authoritative com
			     advisoryScope) é IRREPRESENTÁVEL por construção —
			     'se o estado inválido for representável, ele vai
			     aparecer'. cue vet rejeita instâncias mistas.

			**Backward compatibility validada**:
			- Todos novos fields são OPTIONAL (consistencyBoundary?,
			  systemConsistencyModel?, decisionAuthorityModel?)
			- Domain-model instances existentes (INV, DLV, SSC, P2P,
			  REW Part 1) NÃO incluem novos fields — cue vet OK sem
			  migration
			- Nenhum field existente foi modificado, removido, ou teve
			  semântica alterada
			- Pattern paralelo a adr-080 (#StructuralCheck domain-
			  invariant kind extension) + adr-076 (#ADR schema
			  hardening) — schema evolution emergente de WI
			  bootstraps preserva compatibility por design

			**Discriminated union pattern alignment**:
			#DecisionAuthorityModel segue pattern existente de
			#DomainEvent (= #InternalDomainEvent | #PublishedDomainEvent).
			Cada branch obriga fields correspondentes via type
			discriminator + proíbe fields não-aplicáveis via _|_.
			Pattern paralelo de discriminação por type field;
			NÃO usa CUE conditional (`if type=='X' then field`)
			que não é o pattern do schema atual.

			**Schema satisfação**:
			- 8 critérios universais de artifact-schema (presence de
			  description, naming convention, pattern consistency,
			  closed-struct semantics, etc.) — preservados
			- Existing 17 tq-dm-XX criteria — inalterados
			- _schema location field preservado — canonical path
			  regex inalterado

			**VALIDATIONS POST-CHANGE**:
			- cue vet ./... EXIT=0 (PASSED — preserva compatibility
			  com TODOS domain-model instances existentes:
			  contexts/inv/domain-model.cue, contexts/dlv/, contexts/
			  ssc/, contexts/p2p/, contexts/rew/ Part 1)
			- Marker enforcement: tentar instância de
			  #InterpretationContractMarker SEM _meta="..." OR com
			  value diferente de "interpretation-contract" falha cue
			  vet (closed struct + fixed value)
			- Listas non-empty enforcement: tentar
			  consistencyBoundary com guarantees=[] falha cue vet
			  (cardinality ≥1 obrigatória)
			- Union exclusivity enforcement: tentar
			  #AuthoritativeAuthority com advisoryScope=string falha
			  cue vet (advisoryScope?: _|_ rejeita qualquer valor)
			- Optional fields ausentes em instances existentes: cue
			  vet OK (per CUE optional semantics)

			[INFO infoCount=1] CONTRATOS DECLARATIVOS — TOOLING GAP
			RECONHECIDO: contracts declarados em domain-model são
			INFORMATIONAL até tooling consumir. Founder explicit
			acknowledgment durante S5 dialog: 'se isso não for
			usado até Phase 4, vira decoração'. Mitigation
			documentada em adr-081 consequence (i): REW Phase 3
			Part 2 será PRIMEIRA aplicação; Phase 4 agent-spec
			terá referência direta aos contracts via outbound
			integration contracts; Phase 5 envelope governance
			referenciará authority model. Future runner pode
			validar consistencyBoundary overlap-free cross-
			aggregates + alignment systemConsistencyModel.type
			vs lifecycle modeling. Risk acceptable porque mitigation
			está cascade-tracked.

			Round único suficiente — schema additions são incrementais
			isoladas; não há cross-field interactions complexas a
			validar pos-hoc; founder Phase 3 directive ratificada
			com 8 decisões explícitas pre-write durante S5 dialog +
			3 guardrails micro-ajustes pre-write final.
			"""
	}]

	findings: {}

	summary: """
		Schema #DomainModel + #Aggregate estendidos com interpretation
		contracts layer per adr-081. 7 mudanças coordenadas: 1 marker
		(#InterpretationContractMarker embedding pattern) + 3 novos
		types (#ConsistencyBoundary closed; #SystemConsistencyModel
		closed; #DecisionAuthorityModel discriminated union de 3
		branches com exclusividade via _|_) + 3 optional fields
		(consistencyBoundary em #Aggregate; systemConsistencyModel +
		decisionAuthorityModel em #DomainModel). 3 guardrails finais
		founder pre-write: (G1) listas non-empty (contrato vazio é
		pior que ausência); (G2) marker via embedding (single source
		_meta); (G3) discriminated union exclusiva via _|_ (estado
		inválido irrepresentável). Backward compat: optional fields
		= INV/DLV/SSC/P2P/REW Part 1 instances cue vet OK sem
		migration. cue vet ./... EXIT=0. Pattern paralelo a adr-080
		+ adr-076 — schema evolution emergente de WI bootstrap (REW
		Phase 3 Part 2 será primeira instância). Tooling gap
		reconhecido (infoCount=1) com mitigation cascade-tracked.
		Round único; founder dialectic 8-decision + 3-guardrail
		pre-write substituiu rounds pos-hoc.
		"""

	singleRoundRationale: """
		Schema extension co-commit com adr-081 (single ADR cobrindo
		3 extensions per founder ratification — 'isso NÃO são 3
		mudanças independentes; isso é UM novo conceito:
		interpretation contract layer'). 8 decisões explícitas
		absorvidas pre-write durante S5 founder dialog (Opção A
		confirmada com marker + types separados; cmd-publish removido
		per Opção 1; requestedPolicyVersion junto com model;
		failureModes em #ConsistencyBoundary; conflictResolution em
		#SystemConsistencyModel; retry strategy via inv-rew-computed-
		idempotent-retry; lineage TREE single-successor;
		decisionAuthorityModel authoritative+risk-assessment) + 3
		guardrails finais founder pre-write tightening absorvidos
		(G1 listas non-empty; G2 marker via embedding;
		G3 discriminated union exclusiva via _|_). Schema additions
		incrementais isoladas — não há cross-field interactions
		complexas que requeiram rounds pos-hoc. Pattern paralelo a
		adr-080 (structural-check domain-invariant kind) + adr-076
		(#ADR schema hardening) — sequência de schema evolution
		emergente de WI bootstraps preserva compatibility por design.
		"""
}
