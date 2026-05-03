package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr045: artifact_schemas.#ADR & {
	id:            "adr-045"
	title:         "Reverter encerramento da Fase 1 do adr-043 — cobertura completa permanece meta, pausa é deferimento pragmático"
	date:          "2026-04-07"
	status:        "accepted"
	decisionClass: "foundational"
	decider:       "founder"

	supersedes: ["adr-044"]

	context: """
		adr-044, aceito horas antes neste mesmo dia, declarou a
		Fase 1 do adr-043 encerrada após 9 artefatos classificados
		(~11% de cobertura, 9 de 83). Justificou o encerramento
		em três premissas:

		(a) cobertura de 11% é suficiente para validar o tipo e
		    calibrar a heurística;
		(b) o retorno marginal é decrescente — os 74 artefatos
		    restantes confirmariam padrões já identificados sem
		    revelar novos;
		(c) a política on-touch é mecanismo adequado para a
		    cobertura remanescente.

		As premissas (a) e (b) representam erro de framing
		identificado em revisão posterior do próprio founder. A
		pausa em 9 artefatos não foi suficiência principial — foi
		deferimento pragmático motivado por restrição de tempo de
		sessão. A intenção original era classificar todos os 83
		artefatos elegíveis. Ao iniciar o trabalho, o esforço
		revelou-se substancialmente maior do que previsto, e o
		founder optou por interromper para retomar em sessão
		dedicada futura. adr-044 transformou esta interrupção
		operacional em "amostra suficiente" — leitura que não
		corresponde à decisão real.

		A premissa (c) permanece parcialmente válida: on-touch é
		mecanismo bom por mérito próprio (captura classificações
		quando o artefato está sendo pensado por outro motivo),
		mas não substitui backfill organizado — apenas o
		complementa.
		"""

	decision: """
		Substituir adr-044. As três asserções abaixo são a posição
		corrente do sistema sobre a cobertura de adr-043:

		1. Cobertura completa dos 83 artefatos elegíveis é a meta.
		   Os 74 artefatos restantes ainda devem receber
		   verticalApplicability via backfill organizado, não
		   apenas on-touch.

		2. A pausa após 9 artefatos é deferimento pragmático
		   explícito. Não há reivindicação de que 11% seja
		   "amostra suficiente" nem de que o retorno marginal
		   tenha decaído. A heurística está calibrada o bastante
		   para ser aplicada em sessões futuras, mas calibração
		   não substitui cobertura.

		3. A política on-touch declarada por adr-044 permanece
		   vigente como mecanismo complementar. Cada edição
		   futura de artefato sem verticalApplicability dispara
		   proposta de classificação como parte da edição. Mas
		   on-touch sozinho deixaria artefatos pouco editados
		   indefinidamente sem classificação — por isso o
		   backfill organizado permanece como obrigação aberta,
		   rastreada em wi-066.

		Alternativas consideradas:

		(a) Editar adr-044 in-place corrigindo o framing.
		    Rejeitada porque ADR é evento, não estado mutável: o
		    histórico precisa preservar tanto a decisão original
		    quanto a correção. A única forma estruturalmente
		    correta de inverter posição é via supersession (regra
		    codificada em adr-003 e em CLAUDE.md seção Commits).

		(b) Manter adr-044 vigente e abrir wi-066 sem ADR
		    correspondente. Rejeitada porque a WI de backfill
		    contradiz textualmente a decisão de adr-044
		    ("declarar a Fase 1 encerrada"). Coexistir uma
		    decisão "encerrada" com uma WI "continuar backfill"
		    é drift entre governança e operação — exatamente o
		    tipo de estado que o sistema de ADRs existe para
		    evitar.

		(c) Marcar adr-044 como "withdrawn" em vez de
		    "superseded". Rejeitada porque withdrawn é para
		    decisões nunca aprovadas formalmente (per comentário
		    inline de #NonSupersededStatus). adr-044 foi aceito
		    pelo decider, vigorou por horas, e produziu efeitos
		    rastreáveis (ten-009 referencia adr-044 em
		    relatedADR). Superseded é o status correto.
		"""

	consequences: """
		Imediatas:
		- adr-044 é marcado como superseded com supersededBy=adr-045
		  no mesmo commit (per CLAUDE.md, supersession exige
		  atualização atômica dos dois ADRs).
		- ten-009 é atualizado para registrar adr-045 como
		  segunda ocorrência confirmada do workaround
		  "foundational por exclusão". O gatilho de reabertura
		  estrutural do enum #DecisionClass — n=2 — passa a
		  estar satisfeito por critério.
		- wi-066 é criada para rastrear o backfill dos 74
		  artefatos restantes como trabalho aberto, com
		  prerequisite explícito de aplicar a heurística
		  calibrada registrada em ten-007 e nos rationales dos
		  9 artefatos do piloto.

		Operacionais:
		- A heurística calibrada permanece estado-da-arte. Não
		  há re-discussão dos critérios. As 9 classificações já
		  realizadas permanecem válidas e não são revisitadas
		  por este ADR.
		- wi-066 não tem prazo. É trabalho de fundo a ser
		  retomado em sessões dedicadas. O agente não deve
		  iniciar wi-066 sem aprovação explícita por sessão —
		  esta é convenção de processo, não enforcement
		  estrutural.
		- on-touch continua vigente como complemento. Cada
		  edição futura de artefato sem verticalApplicability
		  dispara proposta de classificação como parte da
		  edição.

		Riscos aceitos:
		- O par adr-044/adr-045 introduz overhead histórico:
		  leitores futuros precisarão entender por que duas
		  decisões contraditórias coexistem no mesmo dia. O
		  custo é aceitável porque a sequência registra
		  honestamente como o framing foi corrigido — esconder
		  a inversão por edição in-place produziria perda
		  epistêmica maior.
		- wi-066 sem prazo pode degenerar em backlog dormente.
		  Mitigação parcial: on-touch garante progresso
		  incidental contínuo independentemente de wi-066.
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/adrs/adr-044-close-adr-043-phase-1-backfill.cue",
		"architecture/tension-log/ten-009-decision-class-enum-lacks-governance-value.cue",
	]

	plannedOutputs: [
		"governance/build-time/task-specs/wi-066.cue",
	]

	principlesApplied: [
		"P0",
	]

	rationale: """
		Aplicação de P0 (zero duplicação): a posição canônica
		corrente sobre cobertura de adr-043 deve viver em um
		único lugar. adr-044 vigente diz "encerrada"; este ADR
		diz "meta de cobertura completa". Manter os dois sem
		discriminação seria duplicação contraditória. Supersession
		marca um como autoridade vigente e o outro como histórico
		— P0 satisfeito.

		Sobre o intervalo curto entre adr-044 e adr-045 (mesmo
		dia, poucas horas): é incomum, mas não anômalo. ADRs
		são eventos discretos — o intervalo entre proposição e
		supersession não é métrica de qualidade. O fato de a
		inversão acontecer rapidamente é virtude do sistema, não
		defeito: captura em tempo real o ciclo
		identificar-erro/corrigir, em vez de deixar a decisão
		errada calcificar. ADRs não são commitment pessoal do
		decider — são registros de posição. Posições mudam
		quando informação melhor aparece.

		Sobre por que ADR e não apenas WI: a inversão de adr-044
		é decisão semântica — altera política de cobertura
		(governança), não apenas próximos passos operacionais.
		WI sozinha registraria o "o quê" sem o "porquê" e sem
		marcar o status histórico de adr-044. ADR é o nível
		correto de registro per CLAUDE.md "antes de criar ou
		alterar artefato estrutural em governance/, criar ADR".

		Nota sobre decisionClass: pelo mesmo gap registrado em
		ten-009, "foundational" é escolhido por exclusão como
		melhor aproximação dentro do enum vigente. structural
		não cabe (não cria novas relações nem tipos), local não
		cabe (escopo cross-cutting), experimental não cabe (não
		é decisão temporária, é correção de framing). Esta é a
		segunda ocorrência confirmada do workaround — n=2 é o
		gatilho de reabertura registrado em ten-009 e passa a
		estar satisfeito a partir deste ADR.
		"""
}
