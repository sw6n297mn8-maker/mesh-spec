package artifact_schemas

// BC Identity Capsule
// Per ADR-092 (this schema) consumed by ADR-091 Strategic Alignment
// Guardrail as enforcement input.
//
// Strategic enforcement anchor declarando envelope ontológico de um
// bounded context. Distintinto de strategic/subdomains/{bc}.cue:
// - subdomain.cue: strategic declaration (intent original, lifecycle
//   estratégico)
// - identity-capsule.cue: enforcement anchor (envelope operacional,
//   lifecycle de governance executável)
//
// Capsule consome subdomain via subdomainRef (interface explícita),
// NÃO duplica fields, NÃO embeds. Lifecycle separation previne
// coupling circular entre intent estratégico e enforcement envelope.
//
// Phase 1 (ADR-092 only): schema canonical + diretório
// strategic/identity-capsules/ criado. Instâncias específicas por BC
// vêm em commits subsequentes (durante reboot FCE/NTF/NIM ou bootstrap
// de novos BCs).
//
// Phase 1 → Phase 2 transition (per ADR-091 D5): materialização deste
// schema ativa transição automática do Strategic Alignment Guardrail.
// Após este commit, missing Capsule para BC alvo de bootstrap se torna
// hard-fail.

// 4 tiers canonical de abstração. Reflete classificação implícita
// observada na análise do drift NIM (operational → meta-constitutional
// sem ADR autorizando escalada).
//
// Definições canonical:
// - operational: execution-level, day-to-day business operations
// - structural: defines architectural patterns, schemas, contracts
// - constitutional: governance over operations
// - meta-constitutional: governance over governance
//
// Extensão futura via schema delta + ADR (precedent ADR-088 + ADR-089).
#AbstractionTier:
	"operational" |
	"structural" |
	"constitutional" |
	"meta-constitutional"

#BcIdentityCapsule: {
	// BC alvo do Capsule. Identifica o bounded context cujo envelope
	// é declarado.
	boundedContextRef: string & =~"^[a-z][a-z0-9-]*$"

	// Referência canonical para strategic intent do BC. Capsule consome
	// subdomain como contexto + adiciona enforcement envelope.
	// Subdomain mantém strategic declaration autoritativa; Capsule
	// transforma intent em envelope operacional.
	subdomainRef: string & =~"^strategic/subdomains/[a-z][a-z0-9-]*\\.cue$"

	// Declaração canonical do papel sistêmico do BC. Frase declarativa
	// não-ambígua, reforça boundary causal. Usado por Strategic
	// Alignment Guardrail constraintClass=identity para detectar
	// mismatch contra materializações nos artifacts do BC.
	intendedSystemRole: string & !=""

	// Lista de centros semânticos admissíveis. ≥1 obrigatório.
	// Linguagem que pode ser usada como núcleo conceitual em artifacts
	// do BC. Usado por Guardrail constraintKind=mismatch.
	// Phase 1 enforcement: deterministic check contra artifacts.
	allowedSemanticCenter: [string & !="", ...string & !=""]

	// Lista de centros semânticos explicitamente proibidos. Required
	// mas pode ser vazio (declaração explícita "considerei e nada
	// é forbidden" vs omissão silenciosa). Usado por Guardrail
	// constraintKind=mismatch como negative list.
	forbiddenSemanticCenter: [...string & !=""]

	// Declarative anchor para gravidade semântica do BC. Required mas
	// non-enforced em Phase 1.
	//
	// Phase 1: armazenado como âncora declarativa para leitura por
	// humanos e agentes. NÃO há check determinístico Phase 1.
	//
	// Phase 2+ (ADR-094+ anticipated): heuristic guardrails poderão
	// consumir este campo como input para detection de gradual
	// displacement de centro semântico. Materialização da heurística
	// será determinada em ADR-094+ quando métricas robustas existirem.
	//
	// Mantido no schema desde Phase 1 (apesar de non-enforced) per
	// founder direction: remover agora forçaria reabertura da
	// ontologia do Capsule em ADR-094, gerando cascade reverso.
	semanticCenterGravity: [...string & !=""]

	// Lista canonical de capabilityRefs autorizadas pelo strategic
	// intent. Required mas pode ser vazio. Lado direito explícito
	// para Guardrail constraintKind=unauthorized-capability-expansion:
	// canvas/domain-model declaram capabilityRefs; Guardrail compara
	// contra esta lista; refs não presentes triggerar hard-fail.
	//
	// Sem este campo, guardrail de capability expansion ficaria sem
	// referência canônica para comparar.
	authorizedCapabilityRefs: [...string & =~"^[a-z][a-z0-9-]*-[0-9]+$"]

	// Classes inteiras de capabilities bloqueadas (vs capabilities
	// específicas em authorizedCapabilityRefs). Required mas pode ser
	// vazio. Permite proibir famílias de capability sem enumerar
	// individualmente.
	//
	// Exemplo canonical: forbiddenCapabilityClasses: ["meta-governance",
	// "global constitutional orchestration"] previne capabilities de
	// classe meta-governance mesmo que ainda não criadas explicitamente.
	forbiddenCapabilityClasses: [...string & !=""]

	// Tier de abstração canonical permitido para o BC. Determinístico.
	// Usado por Guardrail constraintKind=forbidden-tier-breach.
	allowedAbstractionTier: #AbstractionTier

	// Tiers explicitamente proibidos. Required mas pode ser vazio.
	// Declaração explícita "considerei e nenhum tier é forbidden"
	// (vazio) vs omissão silenciosa.
	//
	// Exemplo canonical: BC operational declara allowedAbstractionTier:
	// "operational" + forbiddenAbstractionTiers: ["constitutional",
	// "meta-constitutional"] para previnir escalada implícita.
	forbiddenAbstractionTiers: [...#AbstractionTier]

	// Rationale obrigatório per princípio canonical CLAUDE.md.
	rationale: string & !=""
}
