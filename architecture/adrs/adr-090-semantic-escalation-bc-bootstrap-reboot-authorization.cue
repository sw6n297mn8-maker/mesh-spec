package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr090: artifact_schemas.#ADR & {
	id:    "adr-090"
	title: "Escalada semântica durante bootstrap de bounded contexts — autorização de reboot e hardening de governance"
	date:  "2026-05-17"

	decisionClass: "foundational"
	decider:       "founder"
	status:        "accepted"

	reversibility: "low"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"governance/build-time/quality-gate.cue",
		"architecture/design-principles.cue",
		"strategic/subdomains/",
		"contexts/fce/",
		"contexts/ntf/",
		"contexts/nim/",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/strategic-alignment-guardrail.cue",
		"architecture/artifact-schemas/bc-identity-capsule.cue",
		"architecture/artifact-schemas/complexity-budget.cue",
	]

	context: """
		Decisão original de 2026-03-24 (commit 086b2ea) autorizou NIM
		como subdomínio de inteligência de rede com framing "flywheel
		produtor de inputs" para outros BCs. FCE foi autorizado como
		"orquestrador de execução financeira". NTF foi autorizado dentro
		de boundaries de transporte de garantias entre BCs.

		Entre 2026-05-13 e 2026-05-15, três BCs (FCE, NTF, NIM) sofreram
		elevação progressiva de framing durante bootstrap. FCE Phase 1.3
		retro-patch (commit 7019095) substituiu "orquestrador" por
		"máquina canônica de cristalização de autoridade econômica
		executável condicionada". NTF canvas (commit 07aae1c) introduziu
		"Family Mesh pattern" como categoria nova vinculando FCE e NTF.
		NIM canvas (commit 0bafc82) extendeu para "META-constitutional",
		elevando NIM a "primeiro guardian constitucional sobre mecanismos
		produtores de governance".

		Nenhuma das três elevações foi autorizada por decisão estratégica
		registrada em strategic/subdomains/. Resultado observável: NIM
		domain-model com 36 invariants (vs ~5-10 referência empírica em
		CMT, NPM, CTR), 53% cross-aggregate state dependency (vs ~15%
		referência empírica), MechanismArtifact consumido por seis BCs
		como shared kernel com 5-tupla discipline obrigatória nos
		consumidores.

		Outros 11 BCs bootstrapped antes da escalada (CMT, CTR, IDC, NPM,
		BDG, SSC, P2P, DLV, INV, REW, BKR) permanecem em framing original
		sem escalada semântica.
		"""

	decision: """
		D0 — CANONICALIZAÇÃO DO FAILURE MODE: reconhecer formalmente
		"escalada semântica através de refinamentos cumulativamente
		defensáveis" como categoria de falha de governance. Sem
		canonicalização, observação permanece anedótica e não previne
		repetição em bootstraps futuros.

		D1 — INVALIDAÇÃO DE PRECEDENT: marcar FCE v1, NTF v1 e NIM v1
		bootstrap artifacts como "non-canonical precedent". Artifacts
		permanecem em git para auditabilidade mas perdem autoridade
		como exemplar canonical para bootstraps subsequentes.

		D2 — AUTORIZAÇÃO DE REBOOT: autorizar reconstrução dos três BCs
		na ordem FCE → NTF → NIM. Ordem reflete princípio "abstração
		emerge de operacionalidade estabilizada, não o contrário".
		Começar pelo BC mais abstrato corre risco de reconstruir
		meta-constitucionalidade cedo demais mesmo com guardrails novos.

		D3 — CATEGORIA NOVA "STRATEGIC ALIGNMENT GUARDRAIL": introduzir
		categoria de governance paralela a structural-check, quality-gate
		e policy. Valida coerência evolutiva entre strategic intent
		registrado e materialização arquitetural nos artifacts do BC.
		Schema materializado em ADR subsequente.

		D4 — IDENTIDADE BC ANCORADA via "BC IDENTITY CAPSULE": introduzir
		anchor mecânico de identidade do BC com campos
		intendedSystemRole, allowedSemanticCenter, forbiddenSemanticCenter,
		semanticCenterGravity, allowedAbstractionTier,
		forbiddenAbstractionTiers, forbiddenCapabilityClasses. Capsule
		vive em strategic/subdomains/ e participa do enforcement chain
		mecanicamente, não apenas como contexto humano.

		D5 — SEPARAÇÃO HARD vs SOFT: guardrails determinísticos fail
		hard (strategic identity mismatch, unauthorized capability
		expansion, forbidden abstraction tier breach). Budgets
		heurísticos warn + escalation threshold (rationale depth,
		abstraction ratio, ontology sprawl, unique canonical concepts).
		Misturar os dois geraria falsos positivos e pressão para
		simplificação artificial.

		D6 — EXTENSÃO P10: extender architecture/design-principles.cue
		P10 com clause normativa: "Critical guardrails MUST be executable
		and positioned in the operational path. They MUST NOT depend on
		operator memory, discipline, or voluntary protocol consultation."

		ADRs subsequentes anticipated: schema Strategic Alignment
		Guardrail (D3); schema BC Identity Capsule (D4); schema Complexity
		Budget (D5); amendment manualAuthoringProtocol integrando
		guardrails como pré-condição executável de cada sub-phase.
		"""

	consequences: """
		Positive:
		- Strategic intent vira input automático do enforcement chain,
		  não apenas contexto humano inicial.
		- 11 BCs futuros pendentes (NGR, ATO, DRC, INS, ITC, LOG, OBS,
		  PLT, SCF, TCM, STR) herdam guardrails antes de bootstrap.
		- Failure mode "escalada semântica cumulativa" registrado e
		  prevenido por construção, não por disciplina do operador.
		- Auditabilidade preservada: artifacts v1 permanecem em git;
		  apenas autoridade como precedent é removida.

		Negative:
		- Bootstrap velocity decreases temporarily durante materialização
		  dos guardrails (ADRs subsequentes + schemas + amendment).
		- ~30-40% do tempo total do reboot vai para infraestrutura
		  semântica antes de tocar nos BCs propriamente ditos.
		- 11 BCs anteriores (não escalados) não recebem benefício
		  imediato dos guardrails; revalidação futura necessária se
		  padrão de drift reaparecer retroativamente.
		- Custo de manutenção adicional: cada novo BC requer BC Identity
		  Capsule antes de canvas, e validação contra guardrails em cada
		  sub-phase.
		"""

	principlesApplied: [
		"P10-stochastic-vs-deterministic (extended by this ADR)",
		"adr-040-structural-vs-semantic-validation-separation",
		"adr-088-formalize-mcm-execution-class (precedent: schema delta via ADR)",
		"adr-089-add-observation-action-category (precedent: additive constitutional extension)",
	]

	rationale: """
		Failure mode root cause: strategic intent existia em
		strategic/subdomains/ apenas como contexto humano inicial, sem
		participação mecânica no enforcement chain downstream (canvas →
		glossary → domain-model → agent-spec → governance). Resultado:
		agentes consumiam production guides por memória, ajustes locais
		do founder eram integrados literally e acumulavam, drift
		semântico emergia cumulativamente sem trava de coerência contra
		decisão estratégica original.

		Decisão de reversão é correção de divergência entre strategic
		intent autorizado e materialização agentiva, não regressão
		arbitrária. Sem ADR registrando autorização explicita, reboot
		futuro pode parecer arbitrariedade retroativa para agentes ou
		humanos olhando o histórico, com risco de tentativa de
		"recuperar" abstrações removidas e drift reaparecer.

		Reversibility "low" reflete custo institucional, não técnico.
		ADR é tecnicamente reversível (artifacts em git, decisões em
		CUE), mas cria precedente forte de invalidação de precedent
		inheritance. Reverter significaria restabelecer autoridade
		canonical de artifacts já invalidados, custoso institucionalmente
		e potencialmente reintroduzindo o failure mode.

		Strategic governance moves from advisory protocol consumption
		to executable operational constraints (extensão P10).

		Non-goals explícitos:
		- Não proíbe sofisticação conceitual quando autorizada
		  por strategic intent.
		- Não proíbe abstração quando autorizada explicitamente.
		- Não sugere simplificação artificial de artifacts ou redução
		  de densidade semântica necessária.
		- Não trata abstração como suspeita por si.

		Problema endereçado é abstração desacoplada da função operacional
		declarada, não abstração em si.

		Precedente ADR-088 aplicável: additive schema extension via ADR
		canonical para constitutional design intent precisando schema
		anchor (autonomyLevel "mechanically-compelled" + 5 predicates).
		ADR-089 precedent similar mais recente (observation category +
		trigger independence + non-examples canonical).

		Cascade ordering preserved: este ADR autoriza reboot mas não
		executa. Schemas dos guardrails materializados em ADRs subsequentes;
		BC Identity Capsule de cada BC materializado antes de cada reboot
		específico. Reboot dos BCs só começa após infraestrutura semântica
		estabelecida.
		"""
}
