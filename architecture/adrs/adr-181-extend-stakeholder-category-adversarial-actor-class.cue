package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-181 -- Estende o enum #StakeholderCategory com adversarial-actor-class
// e inclui a classe na lista de categorias obrigadas a manipulationVectors
// (tq-sm-04). Decisão de categorização que o def-076 deferiu ao founder;
// executada no WI-157 (re-autoria do stakeholder-map).

adr181: artifact_schemas.#ADR & {
	id:    "adr-181"
	title: "Estender #StakeholderCategory com a categoria adversarial-actor-class"

	date: "2026-07-29"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-artifact"

	context: """
		O #StakeholderMap v1 classifica stakeholders por PAPEL ECONÔMICO no
		ecossistema — a evolução v0→v1 (registrada no header do próprio
		schema) substituiu a taxonomia por natureza jurídica
		(person/organization/system/agent/regulator) por 6 categorias:
		network-participant, financial-institution, government-authority,
		platform-operator, industry-association, technology-provider. O
		tq-sm-04 (dp-08) obriga manipulationVectors para as categorias
		economicamente ativas (network-participant, financial-institution,
		platform-operator); as demais são isentas.

		O sh-06 (Adversário econômico) existe na instância ATUAL sob a
		shape antiga como type "actor-class" — introduzido na Phase 1 do
		canvas REW (WI-046) como identidade adversarial canônica reusável
		cross-BC (vetores R4+++: delay attack, value concentration, probing
		distribuído, cancel-then-reissue laundering, coordenação
		cross-actor). SEIS canvases o consomem por id estável (bkr:
		side-channel inferral; drc: delay attack em disputa; fce:
		cancel-then-reissue no settlement; idc: resolução estrutural; rew:
		origem R5++++; scf: fraude de lastro) — verificado por leitura
		nesta fatia: todas as referências são stakeholderRef "sh-06" ou
		prosa pelo id; ZERO referências à categoria. O def-076 (Tempo 1,
		2026-07-05) verificou: sh-06 NÃO cabe em nenhuma das 6 categorias
		do enum novo — e deixou a categorização como decisão do founder,
		possivelmente via extensão de enum.

		Trigger concreto: o WI-157 do arco jornada→produção executa AGORA a
		re-autoria do stakeholder-map na forma nova (resolve def-076;
		direção do founder em 2026-07-29). Sem categoria para sh-06, a
		instância re-autorada não unifica com o schema — exatamente o drift
		que o def-076 registrou. E a categoria importa além do slot: a
		lista de obrigados do tq-sm-04 é por-categoria, e o adversário é o
		único stakeholder cuja ESSÊNCIA são os vetores de manipulação — uma
		categoria que o isentasse seria semanticamente invertida.

		Alternativas avaliadas:
		(a) Forçar sh-06 em categoria existente (network-participant, a
		    mais próxima — "opera dentro da rede"). REJEITADA: fabrica
		    semântica — as 6 categorias classificam papel econômico
		    LEGÍTIMO; o adversário não transaciona como negócio, explora; o
		    def-076 verificou a não-caber; e a diluição contaminaria a
		    análise de incentivos (desiredOutcomes de participante legítimo
		    ≠ extração adversarial).
		(b) Remover sh-06 do mapa (adversário viveria só nos canvases).
		    REJEITADA: quebra os 6 canvases que o referenciam
		    estruturalmente; o mapa é a fonte de verdade dos sh-* refs
		    (_schema.location); e perderia a função canônica do WI-046 —
		    identidade adversarial PRIMÁRIA, não derivada de stakeholders
		    legítimos.
		(c) Tornar category opcional (escape hatch para o caso especial).
		    REJEITADA: furo permanente no shape — toda instância futura
		    poderia omitir categoria; o valor do enum é a exaustividade; um
		    caso especial não justifica enfraquecer o contrato de todos.
		(d) ESCOLHIDA: estender o enum com adversarial-actor-class +
		    obrigação de vetores para a classe.
		"""

	decision: """
		(1) ADICIONAR "adversarial-actor-class" ao enum #StakeholderCategory
		em architecture/artifact-schemas/stakeholder-map.cue. O comentário
		do valor no schema DEFINE a classe e CITA este ADR como origem —
		classe de ator cuja função é extração adversarial de valor do
		sistema; identidade adversarial primária, não derivada de
		stakeholders legítimos (precedente REW WI-046/R4+++) — SEM enumerar
		membership (a enumeração 'membro atual único: sh-06' vive AQUI, no
		texto datado do ADR; o comentário do schema envelhece — ajuste do
		founder no Gate 2).

		(2) INCLUIR adversarial-actor-class na lista de categorias OBRIGADAS
		a manipulationVectors do tq-sm-04 (texto do critério atualizado;
		isentas permanecem government-authority, industry-association,
		technology-provider): vetores são a essência da classe — isentá-la
		seria inversão semântica do dp-08. O structural-check da fatia
		(sc-sm, decisão D3 do WI-157) nasce coerente com a lista atualizada.

		(3) NÃO ALTERAR nenhuma outra categoria, platformRelationship ou
		critério; canvases intocados — verificado por leitura: os 6
		canvases consumidores (e os arquivos satélites dos mesmos BCs que
		mencionam sh-06) referenciam por id estável; zero refs à categoria
		em contexts/. A extensão é ADITIVA: instâncias e consumidores
		existentes seguem válidos sem migração.

		(4) VEÍCULO: WI-157 — o schema estendido e a instância re-autorada
		que o consome aterrissam no MESMO commit (sem janela em que sh-06
		exista sem categoria válida; molde change-on-touch das fatias do
		arco).
		"""

	consequences: """
		Positivas:
		(P1) A instância re-autorada do WI-157 unifica com o schema com
		sh-06 numa categoria semanticamente VERDADEIRA — as 3 camadas de
		silêncio do def-076 fecham sem fabricação (a alternativa (a) teria
		fechado o vet fabricando semântica).
		(P2) A obrigação acompanha a essência: tq-sm-04 atualizado + sc-sm
		da fatia coerente — o adversário canônico não pode existir no mapa
		sem seus vetores declarados; dp-08 mecanizado para a classe.
		(P3) Extensão aditiva com custo ZERO de migração: os 6 canvases
		consumidores intocados (verificado por leitura — refs por id
		estável; zero refs à categoria); nenhuma instância existente quebra.
		(P4) O enum permanece exaustivo — sem escape hatch; o contrato de
		categoria segue fechado para TODAS as instâncias futuras (a
		alternativa (c) o teria enfraquecido para sempre).

		Negativas:
		(N1) O enum ganha uma categoria de cardinalidade esperada 1
		(classes adversariais canônicas tendem a ser únicas) — risco do
		precedente "categoria de um membro" virar caminho fácil para
		categorias ad-hoc. Mitigação: a falsificação (c) vigia; toda
		extensão futura do enum segue exigindo ADR próprio.
		(N2) A lista de categorias obrigadas do tq-sm-04 passa a viver em 2
		lugares (texto do critério no schema + regra do sc-sm) — drift
		possível entre eles. Mitigação: nascem no MESMO commit e a regra do
		sc referencia o critério; divergência é acusável em review.
		(N3) Assimetria semântica do dec 2 (adição do founder no Gate 3):
		adversarial-actor-class é a única categoria obrigada a
		manipulationVectors cujos membros NÃO têm desiredOutcomes legítimos
		— "obrigada a vetores" deixa de ser proxy de "participante
		econômico legítimo". Mitigação: a definição da classe no comentário
		do schema carrega a distinção (a obrigação existe por essência
		adversarial, não por atividade econômica legítima).
		"""

	falsificationCondition: {
		condition:        "Esta extensão estará ERRADA SE (a) um segundo ator adversarial legítimo surgir com semântica que NÃO caiba na definição da classe (sinal de que ela foi desenhada sh-06-shaped, não como classe); OU (b) a categoria começar a receber stakeholders LEGÍTIMOS de comportamento ruim (diluição — comportamento adversarial de participante legítimo é vetor DELE via tq-sm-04, nunca mudança de categoria); OU (c) o precedente gerar pressão recorrente por categorias de um membro (dumping ground de enum)."
		observableSignal: "(a) proposta de stakeholder adversarial novo que exija reescrever a definição da classe no schema; (b) diff re-categorizando sh legítimo para adversarial-actor-class em PR; (c) ≥2 propostas de extensão single-member do enum pós-adr-181 — todos visíveis em review de PR."
	}

	affectedArtifacts: [
		"architecture/artifact-schemas/stakeholder-map.cue",
		"domain/stakeholder-map.cue",
		"architecture/deferred-decisions/def-076-stakeholder-map-schema-drift.cue",
	]

	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	principlesApplied: [
		"P0 — a taxonomia tem UMA casa (o enum); a definição da classe vive no comentário do schema citando este ADR, sem membership (o schema envelhece, o ADR data — ajuste do Gate 2).",
		"dp-08 — a classe existe PARA carregar vetores; a obrigação no tq-sm-04 alinha contrato e essência.",
		"P12 — governança executável: a obrigação por categoria é critério que o runner fiscaliza (e o sc-sm materializa), não prosa.",
	]

	supersedes: []

	rationale: """
		Por que (d) entre (a)-(d): forçar categoria fabricaria semântica que
		o def-076 verificou não existir; remover quebraria 6 consumidores e
		a função canônica do WI-046; escape hatch enfraqueceria o contrato
		de todos por causa de um caso. A extensão é o único caminho que
		mantém o enum exaustivo E verdadeiro. Trade-off aceito: categoria de
		cardinalidade 1 (N1) e a assimetria semântica da obrigação (N3) com
		a falsificação vigiando o precedente — preferível a qualquer uma das
		três degradações.

		Relações: RESOLVE a metade de categorização do def-076 (a re-autoria
		completa é o WI-157; resolvedBy do def aponta este ADR); PRESERVA
		adr-172 intocado (adversarial-actor-class é classe de ATOR do
		ecossistema, não papel de participante — papéis seguem posicionais);
		origem do sh-06 canônico: REW WI-046 (R4+++) — registrada AQUI,
		no texto datado; o comentário do schema define a classe e cita
		este ADR, sem precedente nem membership (ajuste do Gate 2).

		Tensão com axiomas: nenhuma. Lenses: nenhuma com match — resolvido
		por princípios (P0/dp-08/P12) + precedente interno (adr-049, exemplo
		schema-extension do próprio PG-ADR).
		"""
}
