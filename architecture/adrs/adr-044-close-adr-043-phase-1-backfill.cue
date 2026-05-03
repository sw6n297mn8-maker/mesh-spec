package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr044: artifact_schemas.#ADR & {
	id:            "adr-044"
	title:         "Encerrar Fase 1 do adr-043 — declarar piloto suficiente e migrar para política on-touch"
	date:          "2026-04-07"
	status:        "superseded"
	supersededBy:  "adr-045"
	decisionClass: "foundational"
	decider:       "founder"

	context: """
		adr-043 introduziu o tipo #VerticalApplicability como
		superfície de governança opcional em lenses, subdomains e
		canvases. A Fase 1 foi planejada como backfill assistido
		por agente para classificar artefatos existentes e calibrar
		a heurística de classificação na prática.

		Após 9 artefatos classificados (6 lenses, 2 subdomains,
		1 canvas) e 2 entradas no tension log (ten-007 sobre o
		critério adaptable vs not-yet-validated, ten-008 sobre
		nível de abstração de authoring de lens-platform-dynamics),
		o piloto produziu três outputs concretos:

		1. Calibração estabilizada da heurística — "adaptable
		   exige identificar pontos de variação concretos no
		   artefato; ausência de pontos de variação concretos com
		   núcleo universal indica agnostic". Aplicada com sucesso
		   em 9 casos com 1 erro conservador a priori (scf
		   classificado como adaptable na hipótese, revelado como
		   agnostic na análise) e 8 acertos.

		2. Amostra estratificada cobrindo os três modos do tipo:
		   - vertical-agnostic: lens-temporal-modeling-for-financial-systems,
		     lens-distributed-systems-design, scf, cmt-subdomain
		     (4 casos)
		   - vertical-adaptable / construction:
		     lens-information-economics, lens-credit-risk,
		     cmt-canvas (3 casos)
		   - vertical-specific / construction:
		     lens-domain-language-and-terminology-design,
		     lens-platform-dynamics (2 casos)

		3. Primeira observação cross-plane (n=1): no par CMT
		   subdomain/canvas, a variação por vertical aparece no
		   plano operacional (canvas, adaptable/construction)
		   mas não no plano de fronteira estratégica (subdomain,
		   agnostic). Hipótese de pesquisa falsificável registrada
		   nos rationales dos próprios artefatos, sem promoção a
		   tensão estrutural por massa empírica insuficiente.

		O escopo total de artefatos elegíveis no repositório é 83
		(54 lenses, 25 subdomains, 4 canvases). Cobertura atual
		do piloto: ~11% (9 de 83). Manter o ritmo de
		proposta-aprovação-commit individual exigiria dezenas de
		rodadas adicionais, com retorno marginal decrescente —
		os próximos artefatos tendem a confirmar padrões já
		identificados mais do que produzir novos aprendizados.
		"""

	decision: """
		Declarar a Fase 1 do adr-043 encerrada. Cobertura de ~11%
		(9 de 83 artefatos) é considerada suficiente para validar
		o tipo, calibrar a heurística e instalar a categoria como
		vocabulário ativo do sistema.

		Este ADR encerra a Fase 1 do adr-043, não o adr-043 em si.
		O tipo #VerticalApplicability permanece vigente, opcional
		no schema, e ativo como vocabulário de governança.

		A política de cobertura para os 74 artefatos restantes
		passa a ser incremental on-touch: cada artefato existente
		ganha o campo verticalApplicability quando for tocado por
		outro motivo (evolução semântica, correção, refatoração).
		Não há sweep dedicado adicional.

		Para artefatos novos (criados após esta data) dos tipos
		cobertos por adr-043, o campo continua sendo opcional no
		schema, mas a expectativa de authoring é que seja
		preenchido no commit de criação. Isso é convenção de
		processo explícita, não enforcement estrutural — manter
		o campo opcional preserva a possibilidade de bootstrap
		progressivo de novos tipos sem bloqueio.

		Alternativas consideradas:

		(a) Continuar o sweep até cobertura completa. Rejeitada
		    porque o retorno marginal é decrescente após
		    calibração: os 74 artefatos restantes provavelmente
		    confirmariam padrões já identificados com baixa
		    probabilidade de revelar novas tensões. Custo de
		    dezenas de rodadas adicionais não se justifica.

		(b) Modo batch agressivo (5-10 artefatos por rodada com
		    rationale curto). Rejeitada porque sacrifica a
		    profundidade que torna o tipo útil — rationales
		    curtos viram rótulos e perdem o caráter de
		    micro-decisão de design exigido pelo schema e pelo
		    princípio P0 (conhecimento canônico, não cópia).

		(c) Modo automático com checkpoint pós-fato. Rejeitada
		    porque viola "proposta antes de implementar" do
		    CLAUDE.md sem justificativa estrutural — é ganho de
		    velocidade que custa governança. P10 exige que
		    agentes recomendem e gates determinísticos validem;
		    sweep automático trataria o agente como gate.

		A opção escolhida (encerrar e migrar para on-touch) é a
		única que respeita o princípio de retorno marginal e
		preserva o modelo de operação proposta-aprovação-commit.
		A cobertura completa é trabalho mecânico — não exige
		modo piloto. Pode acontecer organicamente.
		"""

	consequences: """
		Imediatas:
		- 74 artefatos permanecem sem verticalApplicability
		  declarada. Sua ausência é estado válido (campo é
		  opcional no schema).
		- A hipótese de pesquisa cross-plane (variação vive no
		  plano operacional, não no estratégico) permanece com
		  n=1 e fica registrada como observação aberta. Será
		  revalidada organicamente conforme outros pares forem
		  classificados via on-touch.
		- ten-007 e ten-008 permanecem com status open. Suas
		  condições de reabertura continuam válidas
		  independentemente do encerramento da Fase 1.
		- ten-009 (ver entrada relacionada) registra o gap do
		  enum #DecisionClass exposto por este próprio ADR.

		Operacionais:
		- Quando um agente ou founder editar qualquer artefato
		  dos tipos cobertos por adr-043 sem verticalApplicability
		  declarada, o agente deve propor a classificação como
		  parte da edição, seguindo a heurística calibrada. Isso
		  é convenção de processo explícita, não enforcement
		  estrutural.
		- A heurística calibrada (registrada nos rationales dos
		  9 artefatos do piloto e nas duas entradas do tension
		  log ten-007/ten-008) é o estado-da-arte operacional do
		  tipo. Reabrir a discussão sobre o critério exige nova
		  entrada no tension log.

		Riscos aceitos:
		- Falsa generalização não detectada: artefatos não
		  classificados podem embutir premissas de construção
		  sem que isso seja explicitado. Risco mitigado
		  parcialmente pelo fato de que toda edição futura
		  desencadeia classificação on-touch.
		- Inconsistência cross-plane não detectada: pares
		  subdomain/canvas com classificações divergentes não
		  são ativamente buscados. Risco aceito porque a
		  hipótese de pesquisa subjacente ainda é especulativa
		  (n=1).
		- Anti-degeneração: este ADR existe explicitamente para
		  impedir que o backfill seja retomado como ritual
		  burocrático no futuro. Reabertura de Fase 1 exige novo
		  ADR que justifique por que a política on-touch é
		  insuficiente.
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/adrs/adr-043-vertical-applicability-governance-surface.cue",
		"architecture/shared-types/vertical-applicability.cue",
		"architecture/lenses/lens-temporal-modeling-for-financial-systems.cue",
		"architecture/lenses/lens-distributed-systems-design.cue",
		"architecture/lenses/lens-information-economics.cue",
		"architecture/lenses/lens-credit-risk.cue",
		"architecture/lenses/lens-domain-language-and-terminology-design.cue",
		"architecture/lenses/lens-platform-dynamics.cue",
		"strategic/subdomains/scf.cue",
		"strategic/subdomains/cmt.cue",
		"contexts/cmt/canvas.cue",
		"architecture/tension-log/ten-007-vertical-adaptable-vs-not-yet-validated.cue",
		"architecture/tension-log/ten-008-platform-dynamics-lens-authoring-abstraction-level.cue",
	]

	plannedOutputs: [
		"architecture/tension-log/ten-009-decision-class-enum-lacks-governance-value.cue",
	]

	principlesApplied: [
		"P0",
		"P10",
	]

	rationale: """
		Encerrar o piloto reconhece explicitamente que o objetivo
		da Fase 1 era validar e calibrar, não atingir cobertura
		completa. A cobertura completa é trabalho mecânico que
		não exige modo piloto — pode acontecer organicamente.
		Continuar o sweep no formato atual gastaria recursos de
		governança em confirmação de padrões já identificados,
		em detrimento de outras decisões de design pendentes.
		Migrar para on-touch alinha o esforço de classificação
		ao esforço de evolução real dos artefatos: cada
		classificação acontece exatamente quando o artefato está
		sendo pensado por outro motivo.

		Aplicação de P0 (zero duplicação): a política on-touch
		é única para todos os tipos cobertos por adr-043 — não
		há regra ad-hoc por tipo. Aplicação de P10 (gates
		determinísticos validam, agentes estocásticos
		recomendam): encerrar o sweep impede que o agente
		assistente seja tratado como gate de cobertura por
		default; cobertura passa a ser efeito colateral
		determinístico de edições reais, não output estocástico
		de um sweep.

		Nota sobre decisionClass: o valor "foundational" foi
		escolhido como melhor aproximação dentro do enum
		#DecisionClass atual ("foundational | structural | local
		| experimental"), aplicado no sentido amplo do comentário
		do schema que inclui "governança". O enum não tem valor
		dedicado para decisões puramente de política operacional
		— este gap está registrado como ten-009 (relatedADR
		adr-044), aberto para resolução estrutural posterior
		via expansão de enum em ADR futuro. A escolha de
		"foundational" não é leitura literal da definição
		("base do sistema") mas leitura por exclusão: structural
		exige novas relações ou tipos (não há), local exige
		escopo contido (não é o caso, é cross-cutting),
		experimental exige natureza temporária (é o oposto:
		encerra um experimento). Foundational é o resíduo.
		"""
}
