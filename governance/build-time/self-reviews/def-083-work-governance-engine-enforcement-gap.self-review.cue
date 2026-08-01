package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def083WorkGovernanceEngineEnforcementGap: build_time.#SelfReviewReport & {
	reportId: "srr-def-083-work-governance-engine-enforcement-gap"

	artifactPath:       "architecture/deferred-decisions/def-083-work-governance-engine-enforcement-gap.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-08-01"

	roundsExecuted: 2
	maxRounds:      4

	status: "max-rounds-reached"

	roundDetails: [{
		round:     1
		failCount: 2
		warnCount: 1
		infoCount: 0
		summary: """
			Primeira revisão do def-083, executada em conjunto com o round 6
			do adr-183 (o def nasce da delegação daquele ADR; revisar um sem
			o outro deixaria a fronteira sem verificação). Dois fails.

			(1) TRIGGER DISPARADO NO NASCIMENTO. A versão original usava
			recurrence com scope=filename sobre work-events e threshold 5,
			sob a premissa declarada em triggerCalibrationRationale de que o
			runner contaria volume acumulado DESDE ESTE REGISTRO. Premissa
			falsa: evaluate_recurrence faz git ls-files e conta valor
			ABSOLUTO sobre o estado atual, sem state persistido entre runs.
			O def nascia disparado (131 >= 5) e seria o ÚNICO dos 83 a
			disparar -- poluindo o briefing de vigilância de toda sessão
			futura com sinal permanente e vazio. Corrigido (correção M,
			aprovada pelo founder): trigger primário passa a adjacent-need
			com condition file-contains sobre .github/workflows/validate.yml,
			pattern "scripts/ci/.*(work-events|event-validation)" -- dispara
			quando o fiscal dos ev-* for construído, isto é, quando o motivo
			de deferir deixar de valer. Verificado executando o runner:
			0 of 83 fired (era 1 of 83). O rationale corrigido REGISTRA o
			erro e sua causa em vez de apagá-lo.

			(2) INVENTÁRIO DE ACHADOS SUBCONTADO. A description enumerava
			DEZ achados e omitia que o pipeline efetivo é maior que
			event-validation.cue -- a seção "Composição do pipeline efetivo"
			declara união com claim-expiration-validation.cue (ev-08..ev-10)
			e completion-gates.cue (ev-11). Corrigido para ONZE achados, com
			o inventário correto explícito: 11 regras ev-*, DEZ sem fiscal,
			uma (ev-01) coberta por cue vet. Mesmo modo de falha que já
			havia derrubado o N1 do adr-183 no round 4.

			Warn: o def não tinha self-review report -- gate bloqueante
			(check-self-review.sh) impedindo o commit. Este report é a
			resposta a esse warn.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 1
		infoCount: 3
		summary: """
			Segunda passada isolada, conjunta com o round 7 do adr-183. ZERO
			fail no texto do def: o trigger corrigido (M) foi verificado pelo
			reviewer executando o runner -- 0 of 83 fired, com a saída
			específica do def-083 sem match -- e a aritmética interna do
			achado (7) fecha. Os dois fails do round couberam ao ADR, que
			descrevia este def errado em dois pontos (trigger citado na versão
			morta; delegação de itens ausentes da enumeração).

			WARN, e o reviewer o classificou como a correção de maior valor
			aqui: o sensor cobria UMA rota das três plausíveis para o fiscal.
			O adjacent-need ancorado no validate.yml não lê nem
			structural-check novo (o runner de sc-* já está cabeado, nome não
			casa) nem workflow próprio -- que é o padrão dominante do repo, 3
			dos 6 workflows. A equivalência "isto é, quando o fiscal for
			construído" era premissa não declarada. Corrigido em duas frentes:
			segundo adjacent-need sobre architecture/structural-checks/
			work-governance.cue, e declaração explícita do que fica de fora
			(workflow próprio; prefixo ou arquivo diferente), com o temporal
			nomeado como a rede dessas rotas.

			DEFEITO NA PRÓPRIA CORREÇÃO, pego pelo founder e não pelo review:
			o regex proposto era sc-wg-0[2-9], que só alcança nove checks. O
			repo já tem sc-dlv-14 e sc-rew-15 -- 11 das 126 ids em dois
			dígitos >= 10 -- e o schema exige dois dígitos. Corrigido para
			sc-wg-(0[2-9]|[1-9][0-9]), faixa 02-99, verificado não casando
			contra o arquivo atual (só sc-wg-01 existe).

			Info (3), todas aplicadas: título sem número (a colisão entre "11
			achados" e "11 regras ev-*" já havia enganado rounds anteriores, e
			os achados 10 e 11 não são "enforcement sem executor"), tamanho do
			título dentro do <= 80 do PG (89 -> 75 runes), e reconhecimento da
			divergência consciente da heurística do PG sobre temporal.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "uq-05"
			severity:    "warn"
			message: """
				O sensor deste def cobre DUAS das quatro rotas por onde o
				fiscal pode nascer, e a limitação está declarada no
				triggerCalibrationRationale em vez de suposta -- mas continua
				sendo limitação. Ficam fora: workflow próprio com script fora
				do validate.yml (o padrão dominante do repo) e fiscal com
				prefixo de id ou arquivo diferente. Nessas duas rotas, quem
				devolve o deferimento é o temporal de 90 dias, não o sinal
				específico. Consequência prática a não esquecer: file-contains
				é warn-only no runner V1, então os dois primários NUNCA
				bloqueiam -- sinalizam no briefing.
				"""
			rationale: "Um sensor parcial declarado ainda deixa passar; o que muda é que o leitor sabe disso."
		}, {
			criterionId: "uq-05"
			severity:    "warn"
			message: """
				STATUS max-rounds-reached, e o motivo precisa ser lido
				corretamente: NÃO é que este def sozinho tenha esgotado 4
				rounds. A revisão do def-083 é solidária à linha do adr-183,
				que está no sétimo round contra maxRounds 4, e o founder
				interrompeu a linha explicitamente (2026-08-01: "PARA a linha
				do adr-183 até a próxima sessão, qualquer que seja o
				veredito"). Interrupção por limite e por decisão, não por
				esquecimento -- e "stable" seria falso, porque o único round
				concluído deste def carregou dois fails e a passada que
				confirma as correções não voltou.
				"""
			rationale: "Declarar o vínculo evita que o status seja lido como esgotamento próprio do def, o que superestimaria o quanto ele foi revisado."
		}]
	}

	summary: """
		def-083 carrega o MAPA como conteúdo: os onze achados do levantamento
		de superfície do motor de work-governance (somente leitura, sobre o
		disco, 2026-08-01) -- dez das onze regras ev-* declaradas
		"procedural" sem runner algum, projection-drift.cue sem workflow que
		o execute, rebuild-projections.sh sem modo --check e sem invocação,
		duas projeções factualmente erradas em main (ready-queue lista WI-043
		como ready; in-progress declara zero enquanto wi-140 tem três
		task-claimed consecutivos), e a divergência entre #AdmissionState
		declarado e o compute_state que nunca produz "defined".

		Nasce da decisão do founder de ENCOLHER o adr-183 após cinco rounds:
		cada round empurrava o ADR a absorver mais do motor, porque toda
		promessa de enforcement esbarrava numa camada que não funciona. O def
		é o portador dessa delegação -- sem ele, o defersTo do ADR apontaria
		para nada (foi exatamente o fail do round 4 daquele ADR).

		Anti-catch-all do adr-062 satisfeito de forma verificável: trade-off
		articulado nos dois sentidos (custo evitado = um ADR de eventType que
		carrega a reconstrução do sistema de fiscalização inteiro, escopo que
		nenhum review fecha; custo de continuar = exposição que cresce
		monotonicamente com o volume de streams), e condição de revisita
		codificada em predicado executável, não em intenção.

		costOfDeferral high com fundamento factual, não estimado: o dano é
		observável hoje em main, e a assimetria está nomeada -- o custo não é
		de correção futura, é de confiança presente; quem lê projections/
		hoje lê informação errada sem sinal de que está errada.

		DOIS rounds executados, ambos isolados. O primeiro derrubou o trigger
		(nascia disparado, sob premissa falsa sobre a semântica do runner) e o
		inventário (dez achados quando o pipeline efetivo tem onze). O segundo
		não achou fail no texto do def -- os dois fails daquela passada eram
		do ADR descrevendo este def errado -- e trouxe o warn de cobertura do
		sensor, corrigido em duas frentes. Padrão que os dois rounds partilham
		e vale mais que qualquer deles: as três correções de fundo vieram de
		EXECUTAR o runner ou GREPAR o repo, nunca de raciocinar sobre como
		eles deveriam se comportar.

		Findings residuais: os dois warns acima. Nenhum fail pendente. As três
		observações fora de critério (título com número, tamanho do título,
		divergência da heurística temporal) foram aplicadas por decisão do
		founder.

		DESFECHO. Após leitura integral dos dois artefatos, o founder ordenou
		dois ajustes neste def -- alinhar a contagem citada no
		deferralRationale ao N4 atual (catorze -> quinze) e registrar no bloco
		ITENS DELEGADOS o CUSTO DE RENUMERAR: quatro pontos do adr-183 (dec 7,
		N1, N9, FRONTEIRA) citam este id em prosa, e nenhum gate verifica a
		dependência (defersTo é campo livre; sc-wg-01 é pareamento de
		diretório; citação em prosa não é alcançável por reference-exists).
		Registro que vale além deste artefato: uma dependência assimétrica
		não-verificada é exatamente a classe de problema que este def cataloga
		no motor -- e ela apareceu na relação ADR<->def que o próprio def cria.
		O adr-183 foi para accepted; este def permanece open, que é o estado
		correto: o deferimento segue de pé, e agora tem uma decisão aceita
		apontando para ele.
		"""
}
