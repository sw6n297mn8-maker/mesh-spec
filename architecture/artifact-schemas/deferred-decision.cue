package artifact_schemas

// deferred-decision.cue — Schema para deferimentos conscientes governados.
//
// Per adr-062: deferimento consciente governado é decisão explícita de NÃO
// resolver agora, com triggers codificados que avaliam condições de revisita
// automaticamente via runner determinístico (scripts/ci/evaluate-deferred-
// triggers.sh, criado em commit 2 do bootstrap).
//
// Distinto de:
// - tension-entry: registra trade-off de design entre forças concorrentes,
//   não trabalho a fazer (vc-te-01 captura: bug/gap travestido NÃO é tensão)
// - WI/task-spec: registra trabalho a executar sem condicional codificada
//   de revisita
// - prose 'Known gaps declarados' em ADRs: pré-adr-062 grandfathered;
//   pós-adr-062 SHOULD usar defersTo + def-XXX quando deferimento tem
//   trigger codificável
//
// Lifecycle: open → triggered (auto via runner) → resolved | withdrawn.
// Runner emite annotations (PR comments, workflow output); NÃO muta
// instâncias — status é mudado por edit humano após revisão.
//
// Discriminação por status segue pattern de #ADR (status ↔ supersededBy):
// cada status exige shape específico de campos auxiliares.

import (
	"strings"
)

#DeferredDecision: _#DeferredDecisionBase & ({
	status:               "open"
	triggeredAt?:         _|_
	triggeredCondition?:  _|_
	resolvedBy?:          _|_
	withdrawalRationale?: _|_
} | {
	status:               "triggered"
	triggeredAt:          string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}$"
	triggeredCondition:   string & !=""
	resolvedBy?:          _|_
	withdrawalRationale?: _|_
} | {
	status:               "resolved"
	resolvedBy:           #OriginRef
	triggeredAt?:         string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}$"
	triggeredCondition?:  string & !=""
	withdrawalRationale?: _|_
} | {
	status:               "withdrawn"
	withdrawalRationale:  string & strings.MinRunes(50)
	triggeredAt?:         string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}$"
	triggeredCondition?:  string & !=""
	resolvedBy?:          _|_
})

_#DeferredDecisionBase: {
	id:    string & =~"^def-[0-9]{3}$"
	title: string & !=""
	date:  string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}$"

	// O que está sendo deferido — afirmativo e específico.
	description: string & strings.MinRunes(50)

	// Por que deferir AGORA — articulação de trade-off concreto vs aspiracional.
	// Frase 'fazer depois quando der tempo' falha tq-def-01.
	deferralRationale: string & strings.MinRunes(100)

	// Por que estes triggers/thresholds específicos — calibration rationale.
	triggerCalibrationRationale: string & strings.MinRunes(50)

	// Onde nasceu o deferimento — múltiplas origens permitidas.
	// Aceita path .cue (artefato formal) ou session:<slug> (decisão de chat).
	originatingArtifacts: [#OriginRef, ...#OriginRef]

	// Custo de continuar deferindo. severity e blastRadius devem ser
	// coerentes com description (tq-def-04 advisory).
	costOfDeferral: #DeferralCost

	// Triggers codificados — pelo menos 1. Cada trigger é machine-evaluable
	// pelo runner determinístico exceto manual-review (skip explícito).
	// At-least-1 non-manual-review é advisory (tq-def-03 warn).
	triggers: [#Trigger, ...#Trigger]

	// Status — discriminante da união em #DeferredDecision.
	status: "open" | "triggered" | "resolved" | "withdrawn"

	// Campos auxiliares — presença/ausência imposta pela união discriminada.
	triggeredAt?:         string
	triggeredCondition?:  string
	resolvedBy?:          #OriginRef
	withdrawalRationale?: string

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/deferred-decisions/def-[0-9]{3}-[a-z0-9-]+\\.cue$"
			fileNameRegex:      "^def-[0-9]{3}-[a-z0-9-]+\\.cue$"
			description:        "Deferimentos conscientes governados: decisões explícitas de não resolver agora com triggers codificados de revisita automática."
			rationale:          "Vivem em diretório próprio porque governam meta-state cross-cutting (qualquer ADR/WI pode originar deferimento) e são consumidos por runner determinístico — separado de tension-log (forças de design) e ADRs (decisões tomadas)."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-def-01"
			description: "deferralRationale articula trade-off concreto, não 'fazer depois'"
			test:        "deferralRationale especifica POR QUE deferir agora vs resolver: custo evitado articulado, maturidade insuficiente identificada, ou caso concreto ainda não materializado. Frase 'fazer depois quando der tempo' ou equivalente falha. MinRunes(100) garante extensão; substantividade é interpretativa."
			severity:    "fail"
			rationale:   "Deferimento sem trade-off articulado é procrastinação travestida — vira backlog não-acionável. Failure mode primário do sistema: instâncias proliferam sem rastreabilidade do raciocínio."
		}, {
			id:          "tq-def-02"
			description: "triggers são codificados, não prose"
			test:        "Cada trigger conforma com #Trigger discriminated union (kind + params machine-evaluable). Enforced por shape via cue vet — este critério é a versão interpretativa para casos onde author tenta contornar (e.g., manual-review com reason vago)."
			severity:    "fail"
			rationale:   "Triggers prose não podem ser avaliados pelo runner — defeats o propósito de máquina automática de cobrança."
		}, {
			id:          "tq-def-03"
			description: "Pelo menos 1 trigger non-manual-review"
			test:        "triggers contém ao menos um item com kind != 'manual-review', OU deferralRationale articula explicitamente por que manual-only é apropriado neste caso (e.g., decisão estratégica que só founder pode revisitar). Advisory: requer julgamento sobre legitimidade do manual-only."
			severity:    "warn"
			rationale:   "Manual-only deferral depende de revisão periódica do founder — sem trigger automático, vira esquecimento. Warn (não fail) porque há casos legítimos."
		}, {
			id:          "tq-def-04"
			description: "costOfDeferral coerente com escopo"
			test:        "severity (low/medium/high) e blastRadius (local/cross-artifact/cross-cutting/repo-wide) são consistentes com description. Combinações suspeitas: low+repo-wide (escopo amplo com custo baixo é improvável), high+local (custo alto em escopo restrito é improvável). Advisory: há exceções."
			severity:    "warn"
			rationale:   "Severity desalinhada com blast radius indica avaliação de custo superficial — degrada utilidade do field para priorização futura."
		}]
		rationale: "Critérios cobrem 4 aspectos do contrato deferred-decision v1: trade-off articulado (tq-def-01 fail), triggers machine-evaluable (tq-def-02 fail), automação preferida sobre manual-review (tq-def-03 warn), e coerência custo-escopo (tq-def-04 warn). 2 fail + 2 warn — mesma proporção dos schemas de adr/canvas."
	}
}

// OriginRef — referência à origem do deferimento.
// Aceita path .cue (artefato formal) ou session:<slug> (chat).
// Session prefix deliberadamente explícito — runner ignora session: refs;
// path .cue é resolvível por filesystem.
#OriginRef:
	(string & =~"^.+/.+\\.cue$") |
	(string & =~"^session:[a-z0-9-]+$")

// DeferralCost — articulação semi-estruturada do custo de continuar deferindo.
#DeferralCost: {
	// Severidade do custo de protelar.
	//   low:    pode deferir indefinidamente sem dano — convenção voluntária supre
	//   medium: pode deferir por tempo limitado (semanas-meses) sem dano cumulativo
	//   high:   deferir cria custo cumulativo ou bloqueia caminho crítico
	severity: "low" | "medium" | "high"

	// Escopo do impacto se o deferimento se prolonga.
	blastRadius: "local" | "cross-artifact" | "cross-cutting" | "repo-wide"

	// Articulação do custo concreto. MinRunes(50) força não-trivialidade;
	// tq-def-04 verifica coerência com severity/blastRadius.
	description: string & strings.MinRunes(50)
}

// Trigger — condição codificada de revisita.
// União discriminada por kind. Cada kind exige shape específico:
//   recurrence:       padrão observado N+ vezes no repo (conta arquivos
//                     com matches do pattern; scope filename/file-content/
//                     commit-message)
//   adjacent-need:    artefato/estado adjacente atinge condição machine-evaluable
//   volume-threshold: contagem de tipo cruza limiar
//   temporal:         tempo decorrido (último recurso — exige justificativa forte
//                     em triggerCalibrationRationale)
//   manual-review:    bypass automático — runner não dispara; founder revisa
//                     periodicamente. reason MinRunes(40) força articulação
//                     de por que manual-only é apropriado.
//   file-content-occurrence-count:
//                     conta occurrences do pattern (regex) DENTRO de UM
//                     arquivo singleton (path único). Distinto de
//                     recurrence scope=file-content que conta ARQUIVOS
//                     com matches across repo. USO RESTRITO: trigger de
//                     singleton governance file (e.g., self-review-bootstrap-
//                     policy.cue contagem de lifecycle:transient entries).
//                     NÃO É mecanismo geral de busca no repo. Aplicar
//                     apenas quando: (a) há um arquivo canônico único;
//                     (b) o sinal é quantidade de occurrences dentro
//                     desse arquivo; (c) recurrence scope=file-content
//                     não serve porque conta arquivos não occurrences.
#Trigger:
	{kind: "recurrence", pattern: string & !="", scope:          #RecurrenceScope, threshold: int & >=2} |
	{kind: "adjacent-need", condition:    #AdjacentCondition} |
	{kind: "volume-threshold", artifactType: string & !="", threshold:    int & >=1} |
	{kind: "temporal", maxAgeDays: int & >=1} |
	{kind: "manual-review", reason:       string & strings.MinRunes(40)} |
	{kind: "file-content-occurrence-count", path: string & =~"^.+/.+$", pattern: string & !="", threshold: int & >=1}

// RecurrenceScope — onde o pattern é buscado pelo runner.
//   filename:       grep nos paths de arquivo
//   file-content:   grep dentro de arquivos .cue
//   commit-message: grep em mensagens de commit (git log)
#RecurrenceScope: "filename" | "file-content" | "commit-message"

// AdjacentCondition — condição machine-evaluable sobre estado adjacente.
// V1 minimal: 2 kinds. Expansão futura via ADR (precedente adr-049/056) quando
// caso concreto justificar (e.g., task-spec-state, schema-has-field).
//   file-exists:   path existe no filesystem (ls -e)
//   file-contains: regex pattern aparece dentro de arquivo no path
#AdjacentCondition:
	{kind: "file-exists", path:    string & =~"^.+/.+$"} |
	{kind: "file-contains", path: string & =~"^.+/.+$", pattern: string & !=""}
