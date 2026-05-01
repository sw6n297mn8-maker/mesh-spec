package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-055 — Cross-aggregate state dependency como first-class field
// em #Invariant.
//
// Materializado em commit único (ADR + schema delta + PG amendment).
// Empirical justification derivada de levantamento dos 4 BCs
// existentes (CMT, CTR, IDC, NPM): 4 invariants cross-aggregate de
// 27 totais (~15%), distribuídas como 1 por BC + 1 caso intra-BC
// adicional em IDC. Padrão observado durante autoria de IDC
// (commit 14063de) cujo rationale carregava disclaimer "schema não
// modela cross-aggregate state-dependency como first-class".

adr055: artifact_schemas.#ADR & {
	id:    "adr-055"
	title: "Model cross-aggregate state dependency as first-class field on #Invariant"
	date:  "2026-05-01"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		Domain models autorados em mesh-spec até esta sessão (CMT, CTR,
		IDC, NPM — 27 invariants total, 5 aggregates) revelaram padrão
		recorrente: algumas invariants protegidas por aggregate X
		dependem de state de aggregate Y para enforcement. A dependência
		hoje vive apenas em prosa nos rationales e regras das invariants
		— não é first-class no schema #DomainModel.

		Levantamento empírico (sessão 2026-05-01):
		- CMT inv-terms-reference-valid → CTR/agg-contract-terms via
		  QueryContractTerms (sync-query, cross-BC).
		- CTR inv-valid-participant-qualification → NPM/agg-participant
		  via QueryParticipantStatus (sync-query, cross-BC).
		- IDC inv-signature-requires-active-identity →
		  IDC/agg-organizational-identity via prj-identity-verification-
		  status (projection nomeada, intra-BC).
		- NPM inv-approval-requires-identity-verification →
		  IDC/agg-organizational-identity via QueryIdentityVerificationStatus
		  (sync-query, cross-BC).

		Frequência: 4 de 27 invariants (~14.8%); todas usam read-only
		access (consistente com CQRS); 3 de 4 cross-BC via canvas
		sync-query, 1 intra-BC via projection nomeada. Per-aggregate
		ratio máximo 25% (IDC agg-evidence-cryptography 1/4); minimum
		12.5% (CMT agg-commitment 1/8). Em nenhum aggregate todas
		invariants são cross-aggregate.

		Gap estrutural: schema não modela a dependência. Consequências
		observadas durante autoria de IDC:
		(a) Rationale de inv-signature-requires-active-identity carrega
		    disclaimer "schema não modela cross-aggregate state-
		    dependency como first-class — relação vive aqui no
		    rationale e na heuristic de protected-invariant" — meta-
		    linguagem indica ausência estrutural.
		(b) Structural-checks futuros (post-WI-068) não podem validar
		    coerência: invariant declara dependência só em texto livre;
		    runner não tem campo para parsear.
		(c) Análise de blast-radius por refactor é manual — ferramentas
		    não conseguem derivar grafo de dependências cross-aggregate
		    a partir do schema.
		(d) Refactor de aggregate-Y silenciosamente quebra invariants
		    de aggregate-X que dependem dele — sem tipo, sem ref check,
		    sem warning estrutural.

		Alternativas avaliadas:
		(a) Status quo (rationale prose) — rejeitada: gaps acima
		    persistem; empirical N=4 distribuído por 4 BCs já justifica
		    formalização (não é design para N=1).
		(b) Aggregate-level field readsProjections em #Aggregate —
		    rejeitada: 85% das invariants em aggregates afetados são
		    self-contained; declarar no aggregate super-estima
		    dependência. Aggregate-level perde precisão sobre QUAL
		    invariant carrega QUAL dependência (1 de 4 vs todas as 4).
		(c) Per-invariant field dependsOnAggregateState — adopted.
		    Granularidade casa com a evidência empírica (cada invariant
		    carrega sua própria dependência); permite estrutura para
		    access mechanism (projection vs sync-query); 23 das 27
		    invariants ficam imutadas (campo opcional).
		(d) Domain service como mediator — rejeitada: domain services
		    modelam coordenação ATIVA de múltiplos aggregates; aqui é
		    dependência PASSIVA (read-only) de invariant em state
		    externo. Reusar #DomainService distorce semântica de
		    coordenação ativa para read-only data dependency.
		"""

	decision: """
		(1) ADICIONAR campo opcional dependsOnAggregateState em
		#Invariant. Quando presente, declara que esta invariant depende
		de state de outro aggregate para enforcement. Ausência (default)
		indica invariant self-contained no aggregate protetor.

		(2) DEFINIR sub-tipo #CrossAggregateStateDependency com:
		- boundedContextRef (optional): omitido = mesma BC do parent
		  #DomainModel; presente = dependência cross-BC.
		- aggregateRef: ref agg-X. Validado por tq-dm-17 apenas quando
		  boundedContextRef ausente (intra-BC); cross-BC fica como
		  string semântica (runner cross-file futuro valida).
		- accessVia: discriminated union #AccessVia.
		- rationale: por que esta dependência não é modelável como
		  invariant local do aggregate dependido.

		(3) DEFINIR #AccessVia como discriminated union de 2 kinds
		(read-only por construção, alinhado com CQRS):
		- {kind: "projection", projectionRef: #ProjectionRef} — read
		  via projection nomeada no mesmo domain-model (intra-BC).
		- {kind: "sync-query", canvasQuerySurface: PascalCaseString}
		  — read via canvas query-surface declarada no canvas do BC
		  alvo. PascalCase string corresponde a query-surface name.

		(4) ADICIONAR critério tq-dm-17 (severity fail) ao schema:
		para cada invariant com dependsOnAggregateState onde
		boundedContextRef ausente, aggregateRef existe em
		aggregates[].code do mesmo domain-model. Para accessVia
		kind="projection", projectionRef existe em projections[].code.
		Cross-BC refs (boundedContextRef presente) ficam fora deste
		check; runner cross-file futuro valida.

		(5) ATUALIZAR PG architecture/production-guides/domain-model.cue:
		- Heuristic na section context-and-behavior-first-catalog:
		  para cada invariant, perguntar "depende de state de
		  aggregate além do protetor?". Se sim, declarar campo em vez
		  de só prose. Granularidade per-invariant; não declarar no
		  aggregate.
		- Critério tq-dmg-09 (severity warn) cobrindo o protocolo de
		  identificação durante authoring.
		- finalValidation step: verificar refs do campo (intra-BC) e
		  cross-canvas alignment (cross-BC).

		(6) MIGRAR as 4 invariants existentes (CMT, CTR, IDC, NPM) em
		commit subsequente (instantiation, não estrutural — ADR já
		registrou a decisão de design). Rationales simplificam:
		removem disclaimer "schema não modela" e descrição detalhada
		do mecanismo cross-aggregate; campo carrega informação.

		(7) NÃO TOCAR as 23 invariants self-contained. Campo é
		opcional; ausência é o caso default.

		(8) RUNNER cross-file para validar refs cross-BC fica fora do
		escopo desta ADR — depende de WI-068 (structural-checks runner).
		Em Phase 0, tq-dm-17 valida intra-BC apenas; cross-BC é
		inspeção visual + canvas alignment manual.
		"""

	consequences: """
		Positivas:

		(P1) Cross-aggregate dependency vira machine-readable. Future
		structural-checks (post-WI-068) validam refs intra-BC
		automaticamente; runner cross-file (futuro) valida cross-BC.

		(P2) Análise de blast-radius por refactor de aggregate-Y vira
		derivável: grep por aggregateRef apontando para Y produz o
		impact set sem retro-parsing de prose.

		(P3) Rationales simplificam — quem lê não precisa decifrar
		prose para extrair a dependência. Campo carrega informação
		estruturada; rationale carrega só a justificativa do design.

		(P4) Future ferramentas (visualização de grafo de dependências,
		ADR auto-impact, refactor warnings) ficam viáveis sem retro-
		parsing.

		(P5) Alinha com P0 (zero duplicação): cross-aggregate
		dependency tem localização canônica única — o campo, não
		múltiplas frases distribuídas em rationale + rule + heuristic.

		(P6) Phase 0 caveat de IDC ("schema não modela como first-
		class") sai do rationale — campo passa a modelar.

		Negativas / custos:

		(N1) Schema delta exige migração das 4 invariants existentes.
		Risco de drift se algum BC esquecer de migrar quando refatorar
		invariant nova com dependência cross-aggregate.

		(N2) Aprendizado para autores: PG precisa ensinar quando
		declarar. Risco de over-declaration (declarar dependência
		quando invariant é genuinamente self-contained mas autor
		interpreta erroneamente).

		(N3) Cross-BC validation depende de runner cross-file que ainda
		não existe; Phase 0 valida por inspeção. Schema regista a
		dependência mas não enforça refs cross-file.

		(N4) Discriminated union #AccessVia adiciona complexidade —
		autor precisa escolher kind correto. Mitigação: PG heuristic
		+ 4 exemplos pós-migração canônicos.

		Reversibilidade:
		- Campo é opcional; remoção exige migrar 4 invariants de volta
		  para rationale-only. Custo reverso: medium (escrita de prose
		  + perda de structural validation).
		- Schema delta é puramente aditivo (não remove nem altera
		  campos existentes). Rollback é deletion + re-prose nas 4
		  instâncias.

		Phase-0 caveats:
		- Cross-BC ref validation depende de runner cross-file; Phase 0
		  inspeção visual + canvas alignment manual.
		- Structural-check tq-dm-17 cobre intra-BC apenas; cross-BC
		  validation será task separada (WI-XXX após structural-checks
		  runner).
		- 23 invariants self-contained ficam intocadas; ausência do
		  campo é default semantic.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/artifact-schemas/domain-model.cue",
		"architecture/production-guides/domain-model.cue",
		"contexts/cmt/domain-model.cue",
		"contexts/ctr/domain-model.cue",
		"contexts/idc/domain-model.cue",
		"contexts/npm/domain-model.cue",
	]

	principlesApplied: [
		"P0 — Zero duplicação: cross-aggregate dependency tem localização canônica única (campo dependsOnAggregateState), não distribuída em rationale + rule + heuristic.",
		"P1 — CUE como SoT: type-safety por construção via discriminated union #AccessVia + ref validation tq-dm-17 (intra-BC).",
		"P10 — Gates determinísticos: structural-check tq-dm-17 vira deterministic gate em vez de inspeção visual sobre prose.",
	]

	rationale: "Padrão observado empiricamente em 4 BCs (~15% das invariants). Per-invariant granularidade derivada da distribuição (cada invariant carrega sua própria dependência; aggregate-level superestima — máximo 25% cross-agg em qualquer aggregate). Discriminated union #AccessVia captura distinção projection (intra-BC, 1 caso) vs sync-query (cross-BC, 3 casos) observada nos 4 instances. Schema delta puramente aditivo (campo opcional) permite migração gradual sem breaking change para invariants self-contained (23 das 27)."
}
