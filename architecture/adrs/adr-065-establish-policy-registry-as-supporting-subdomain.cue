package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr065: artifact_schemas.#ADR & {
	id:    "adr-065"
	title: "Establish Policy Registry (PLR) as supporting subdomain — registry canônico de identidade, NÃO engine"
	date:  "2026-05-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		WI-040 (proposed 2026-04-05, awaiting approval por ~1 mês)
		identificou 4 gaps na arquitetura distribuída atual de policies:
		cross-BC evaluation, enforcement regulatório (Bacen/LGPD/KYC/AML
		L1 invioláveis), versionamento, consistência de dados sobre
		eventually-consistent projections.

		Sessão 2026-05-03 (claude/resume-mesh-work-jv2MC) discutiu o
		trade-off central: centralização (PLR) melhora governance/
		auditability/consistency mas introduz acoplamento sistêmico;
		distribuição (status quo) preserva autonomia BCs mas aumenta
		risco de drift e enforcement desigual.

		Founder reframe crítico durante discussão: escolher PLR como
		decisão NÃO significa fazer 'PLR completo' agora (engine +
		versioning sofisticado + cross-BC evaluation + regulatory
		enforcement) — isso seria solution-in-search-of-problem prematuro,
		contradiz pattern de minimalism + expand-when-needed estabelecido
		em adr-041 + def-002/003 desta sessão.

		Apenas o gap regulatório (Bacen/LGPD/KYC/AML L1) é concreto e
		não-opcional. Os outros 3 são antecipatórios. Mesh atual: 4 BCs
		com canvas (cmt, ctr, idc, npm); demais não materializados.
		Volume baixo de #Policy instances no repo; drift ainda não
		observado.

		Decisão correta: criar PLR como REGISTRO canônico de identidade
		de policies — nada mais. Enforcement permanece distribuído.
		Versionamento sofisticado, sync, cross-BC evaluation, data
		consistency, lifecycle semantics deferidos formalmente como
		def-005..009 dentro do próprio PLR.

		Sanity test invariante crítico: se PLR for removido amanhã, BCs
		devem continuar funcionando. PLR implementação que falha esse
		teste = implementação errada. Schema enforce isso via
		enforcement: 'external' literal-locked — qualquer tentativa
		futura de PLR virar engine quebra cue vet.

		Alternativas consideradas e rejeitadas:

		(a) Aceitar status quo (Opção C original do WI-040): preserva
		    autonomia mas deixa gap regulatório como prose sem
		    enforcement. Founder explicit: regulatório é não-opcional.

		(b) Extensions to existing mechanisms (Opção B original): 4
		    mecanismos remanescem; coordenação via convenção, não
		    enforcement. Não fecha o gap de identidade canônica para
		    policies regulatórias.

		(c) PLR full-engine (Opção A original sem reframe): centralização
		    completa com engine + sync + evaluation. Rejeitada (founder
		    reframe sessão 2026-05-03): solution-in-search-of-problem
		    prematuro, contradiz minimalism, low reversibility por
		    construção. Cada policy concreta tem requisitos diferentes;
		    engine antes de cliente real é over-engineering.

		(d) artifactType existente sem novo subdomain: schema #Policy em
		    domain/ ou architecture/ sem reconhecimento estratégico.
		    Rejeitada: identidade de policies cross-cutting JUSTIFICA
		    subdomain entry — é dimensão estratégica, não apenas
		    artefato técnico.

		AMENDMENT 1 (post-commit, sessão 2026-05-06): schema renomeado
		de #Policy → #PolicyRegistryEntry para resolver colisão homônima
		no package artifact_schemas com #Policy de domain-model.cue
		(event → command automation pré-existente). Unificação implícita
		das duas definições homônimas no mesmo package exigia campos de
		AMBAS em todas as instâncias domainModel.policies, quebrando
		cue vet --concrete em todos os domain-models pré-existentes
		(SSC/CMT/BDG). Detectado durante CI cue-validate failure no
		PR #39 (WI-057 P2P bootstrap) — pre-existing condition em main
		exposta por mudança de comportamento default em cue v0.16.0
		(--concrete agora default). Rationale do rename: PLR é
		registry-only per decision item 2; "#PolicyRegistryEntry"
		reforça o intent (entry no registry, não engine de policy) e
		separa do conceito legacy domain-model que precede esta ADR.
		Sem instâncias existentes em domain/policies/ — rename mecânico
		sem impacto downstream. Schema fields/constraints/_schema.location
		idênticos pré-rename — apenas o identifier muda. Prose references
		a "#Policy" em outros artefatos (plr.cue, def-009, self-reviews,
		subagent-execution-log) permanecem grandfathered como historical
		record da nomenclatura original; usage textual não causa colisão
		CUE.
		"""

	decision: """
		ESTABLISH Policy Registry (PLR) como supporting subdomain com 7
		decision items numerados:

		(1) Criar strategic/subdomains/plr.cue como #Subdomain do tipo
		    supporting-subdomain, com 5 negativeBoundaries explícitas
		    declarando o que PLR NÃO faz (execution/evaluation,
		    orchestration/saga, financial policy execution, agent
		    autonomy policy, build-time validation).

		(2) Criar architecture/artifact-schemas/policy.cue com
		    #PolicyRegistryEntry schema MINIMAL (renomeado de #Policy
		    per AMENDMENT 1 abaixo): id + scope (bc-local|cross-bc) +
		    class (regulatory|business|operational) + enforcement
		    ('external' literal-locked) + appliesTo + definition +
		    owner + version + rationale. Sem engine. Sem execution.
		    Sem orchestration. Schema enforce 'enforcement: external'
		    como gate determinístico contra drift futuro de PLR
		    virar engine.

		(3) Estender #ArtifactType com 'policy' + abreviação 'pol' em
		    quality-criteria.cue. Pattern paralelo adr-047/061/062/064
		    extensions.

		(4) Enforcement permanece distribuído: BCs continuam executando
		    #Policy local; flows continuam referenciando policyRefs;
		    agents continuam com #AgentGovernanceEnvelope; quality-gate
		    continua validando build-time. NENHUM mecanismo existente
		    é alterado por esta decisão.

		(5) Migração de #Policy/policyRefs/AgentGovernanceEnvelope NÃO
		    executada agora — deliberadamente fora de scope. Quando
		    policy concreta for criada, decidir caso-a-caso se publica
		    em PLR (registry de identidade) mantendo enforcement no
		    mecanismo original.

		(6) 5 deferrals codificados como def-XXX (defersTo: [def-005,
		    def-006, def-007, def-008, def-009]) com triggers
		    automáticos calibrados + manual-review fallback:
		      - def-005: cross-BC execution mechanism
		      - def-006: cross-BC sync/consistency
		      - def-007: data consistency over EC projections
		      - def-008: distributed evaluation
		      - def-009: lifecycle/versioning semantics (rollout,
		        compatibility, deprecation, upgrade)

		(7) Sanity test estabelecido como invariante: se PLR for
		    removido amanhã, BCs devem continuar funcionando. Schema
		    enforcement: 'external' literal-locked materializa esse
		    invariante via cue vet — implementação que viole o invariante
		    falha shape validation.

		OUT of scope explícito (NÃO faz parte desta decisão):
		- PG-policy (cascade ordering NÃO triggered: 'policy' NÃO entra
		  em sc-pg-01.coveredSchemas até primeira instância concreta
		  exigir)
		- Validation-prompt vp-policy (advisory layer; aguarda concrete
		  need)
		- Structural-checks específicos para policy
		- Migrações dos 4 mecanismos existentes
		- Engine de execução, sync, evaluation (deferidos via def-XXX)
		"""

	consequences: """
		Positivas:
		(P1) Identidade canônica: futuras policies têm UM lugar onde
		     vivem com identidade estável (id + version + owner + scope).
		(P2) Gap regulatório endereçado parcialmente: policies L1
		     invioláveis deixam de ser prose dispersa, passam a ser
		     artefatos auditáveis com identidade.
		(P3) Versionamento mínimo (version: int) elimina drift
		     invisível futuro; lifecycle sofisticado deferido via
		     def-009 quando concrete migration cases materializarem.
		(P4) Base preparada para evolução cross-BC sem comprometer
		     escolhas de implementação (engine, sync, evaluation
		     ficam abertas — registry não impõe).
		(P5) Reversibility preservada: PLR sem clientes ativos é
		     trivialmente removível; reversibility cresce com adoption,
		     não com decisão.
		(P6) Pattern de minimalism preservado (per adr-041 narrative
		     + sessão 2026-05-03 direção founder consistente).
		(P7) 5 deferrals tornam-se queryable via sistema deferred-
		     decision (per adr-062), com triggers codificados de
		     revisita.
		(P8) Schema enforcement: 'external' literal-locked previne drift
		     futuro de PLR virar engine via ambiguidade. Schema vira
		     gate determinístico contra solution-in-search-of-problem.

		Negativas:
		(N1) Adiciona novo subdomain ao catalog (PLR), aumentando
		     surface area do mesh. Aceitável: subdomain é dimensão
		     estratégica.
		(N2) Schema #Policy adiciona 1 tipo ao #ArtifactType (26 → 27),
		     1 abreviação canônica (pol). Pattern paralelo adr-061/062/
		     064.
		(N3) Enforcement permanece desigual entre BCs (gap antecipatório
		     #1 não resolvido). Aceito explicitamente como risk
		     gerenciável + def-005 captura revisita.
		(N4) PLR sem clientes ativos é 'infrastructure ahead of
		     demand' — risco de over-engineering. Mitigação: schema
		     minimal + 5 deferrals limitam expansão sem causa concreta.
		(N5) NegativeBoundaries 2/4/5 usam external-system ref como
		     workaround — mecanismos internos (cross-context-
		     orchestration, agent-governance, quality-gate) não são
		     truly external. Workaround documentado em rationale de
		     cada boundary; gap registrado abaixo.

		Known gaps declarados (não omitidos):
		- def-005: cross-BC execution mechanism (deferred-decision)
		- def-006: cross-BC sync (deferred-decision)
		- def-007: data consistency over EC projections (deferred-
		  decision)
		- def-008: distributed evaluation (deferred-decision)
		- def-009: lifecycle/versioning semantics (deferred-decision)
		- #DelegationTarget schema gap: schema atual em subdomain.cue
		  modela apenas 'subdomain' e 'external-system' (ext- prefix);
		  não modela 'internal-governance-mechanism' para mecanismos
		  internos como agent-governance ou quality-gate. NegativeBoundaries
		  2/4/5 deste subdomain usam external-system com prefix ext-
		  como workaround. Não formalizado como def-XXX agora —
		  schema extension futura via ADR quando 2º caso similar
		  materializar (per pattern adr-049/056/063/064 — kinds
		  expand-when-needed). Acceptable stretch para volume atual.

		Fronteira regulatória: PLR PREPARA infraestrutura para
		regulatory enforcement quando concreto for materializado.
		Decisão atual NÃO substitui processo regulatório; é
		infraestrutura cuja ausência tornaria enforcement futuro mais
		custoso. Schema enforcement: 'external' previne PLR drift —
		regulatório vai precisar engine externo (ext-bacen-reporting,
		ext-lgpd-compliance, etc.) quando SCD operations ativarem.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/artifact-schemas/quality-criteria.cue",
	]

	plannedOutputs: [
		"strategic/subdomains/plr.cue",
		"architecture/artifact-schemas/policy.cue",
		"architecture/deferred-decisions/def-005-policy-cross-bc-execution.cue",
		"architecture/deferred-decisions/def-006-policy-cross-bc-sync.cue",
		"architecture/deferred-decisions/def-007-policy-data-consistency.cue",
		"architecture/deferred-decisions/def-008-policy-distributed-evaluation.cue",
		"architecture/deferred-decisions/def-009-policy-lifecycle-versioning.cue",
	]

	defersTo: [
		"def-005",
		"def-006",
		"def-007",
		"def-008",
		"def-009",
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

		P0 (uma localização canônica): PLR materializa P0 para policies
		— elimina drift por construção quando policy ganha home única
		em domain/policies/.

		P1 (CUE como SoT): #Policy schema declarativo em CUE; instâncias
		são artefatos governados, não prose. enforcement: 'external'
		literal-locked é exemplo de schema-as-gate via P1.

		P10 (gates determinísticos): registry separa identidade
		(determinístico) de enforcement (potencialmente complex).
		Decisão preserva P10 ao não acoplar registry com engine.
		enforcement: 'external' é gate determinístico contra drift.

		P12 (governance as code): 5 deferrals codificados via def-XXX
		em vez de prose 'Known gaps declarados' (per adr-062 forward
		pattern). Cada deferral tem triggers machine-evaluable.

		Failure mode evitado: PLR overscoped → solution-in-search-of-
		problem → premature commitment → low reversibility. Founder
		reframe explícito (sessão 2026-05-03) impede esse failure mode.
		Schema enforcement-locked previne drift FUTURO mesmo se founder
		intent for esquecido.

		Lenses consultadas:

		lens-real-options: 5 deferrals são opções reais — postergar
		decisão (e.g., engine architecture) até informação melhor
		materializar (concrete cross-BC policy demand). Custo de
		manter opção aberta = baixo (registry não impõe nada);
		benefício de exercitar prematuramente = duvidoso.

		Tensão com axiomas: nenhuma tensão substantiva. ax-04
		(decidir hoje o que gostaríamos de ter decidido em 5-10 anos)
		é honrado parcialmente — gap regulatório real é antecipado;
		outros 4 gaps deferidos com trigger explícito de revisita.

		Relação com outras ADRs:
		- DESCENDS adr-062 (sistema deferred-decision) — usa o
		  pattern para registrar 5 deferrals.
		- COMPLEMENTS adr-029 (subdomain schema), adr-030 (strategic
		  classification), adr-031 (subdomain deprecation removal)
		  — consume infraestrutura existente.
		- DESCENDS WI-040 (task-spec) — fecha a decisão pendente
		  com reframe substantivo.
		- SEM supersession.

		Justificativa de risk metadata:

		decisionClass='structural': cria novo subdomain + novo schema
		+ altera #ArtifactType. Não é foundational (não muda governance
		base ou SoTs); não é local (cross-cutting impact).

		reversibility='medium': PLR sem clientes ativos hoje é
		trivialmente removível. Cresce com adoption (clientes futuros).
		Diferente de decisões high (single-file) ou low (irreversíveis).
		Schema enforcement: 'external' adiciona barreira semântica
		que aumenta reversibility (drift futuro bloqueado por shape).

		blastRadius='cross-cutting': novo subdomain (strategic),
		novo schema (architecture), nova abbreviation (governance),
		5 def-XXX (deferred-decisions). Não atinge BCs operacionalmente
		AGORA (mandate explícito), mas afeta múltiplos domínios e
		governance.
		"""
}
