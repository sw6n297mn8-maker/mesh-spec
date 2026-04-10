package tension_log

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ten009: artifact_schemas.#TensionEntry & {
	id:    "ten-009"
	date:  "2026-04-07"
	title: "#DecisionClass enum não tem valor dedicado para decisões de política operacional / governança"

	kind:          "schema-limitation"
	tensionTarget: "architecture/artifact-schemas/adr.cue"
	manifestsIn:   "architecture/adrs/adr-044-close-adr-043-phase-1-backfill.cue"

	description: """
		Durante a redação do adr-044 (encerramento da Fase 1 do
		adr-043), foi necessário escolher um valor para o campo
		decisionClass. O enum #DecisionClass em
		architecture/artifact-schemas/adr.cue tem 4 valores:

		- foundational: "decisão que define base do sistema
		  (governança, schema base, SoTs)"
		- structural:   "decisão que altera estrutura entre
		  artefatos (novas relações, novos tipos)"
		- local:        "decisão contida em um artefato ou BC
		  específico"
		- experimental: "decisão explicitamente temporária, com
		  critério de revisão"

		Nenhum dos quatro valores é uma representação direta para
		uma decisão como adr-044, cuja natureza é puramente de
		política operacional / processo de governança:

		- Não define base do sistema (foundational no sentido
		  literal não cabe; o termo "governança" no comentário do
		  enum cobre o caso por sentido amplo, mas não por
		  semântica direta).
		- Não cria novas relações entre artefatos nem novos tipos
		  (structural não cabe).
		- Não está contida em um artefato ou BC (local não cabe;
		  o blastRadius é cross-cutting).
		- Não é temporária — é o encerramento de uma fase de
		  experimento, não um experimento em si (experimental
		  não cabe e seria contraditório).

		Por exclusão, "foundational" foi a escolha menos pior,
		justificada no rationale do próprio adr-044 pelo sentido
		amplo do comentário do schema. Mas o conflito entre o
		intent original (decisionClass: "governance") e o enum
		fechado expõe um gap real: o sistema de classificação de
		ADRs não distingue decisões de política operacional /
		governança de processo das outras categorias.

		Esta limitação tende a aparecer novamente. Decisões
		futuras sobre política de evolução, modelo de operação,
		convenções de processo, encerramento ou pivô de fases
		— todas decisões legítimas que merecem ADR formal — não
		têm representação canônica e serão forçadas a usar
		"foundational" por exclusão, diluindo o sentido literal
		desse valor.

		Confirmação empírica em horas: adr-045, criado no mesmo
		dia que adr-044 para revertê-lo, repetiu literalmente o
		mesmo workaround. Pelos mesmos critérios de exclusão
		(não cria novas relações, não é local, não é
		experimental), "foundational" foi novamente a única
		escolha disponível — desta vez para uma decisão de
		correção de framing de governança, ainda mais distante
		do sentido literal "decisão que define base do sistema".
		n=2 passa a ser fato registrado, não previsão.
		"""

	resolution: """
		Aceita como tensão aberta sem ação imediata. adr-044
		usa "foundational" como melhor aproximação disponível,
		com nota explícita no rationale documentando a escolha
		por exclusão.

		Resolução estrutural conhecida: expandir o enum
		#DecisionClass para incluir um valor adicional (candidato
		preferido: "governance") via ADR formal que altere
		architecture/artifact-schemas/adr.cue. Esta evolução
		exige:

		(a) decisão explícita do founder sobre o nome do novo
		    valor e sua semântica precisa, evitando overlap com
		    foundational;
		(b) revisão dos ADRs existentes que usaram "foundational"
		    por exclusão para verificar se devem ser
		    re-classificados (o adr-044 seria o primeiro candidato);
		(c) atualização do comentário inline do enum para
		    distinguir os valores com clareza.

		Ganho de não agir agora: evita inflar o caminho de
		encerramento da Fase 1 do adr-043 com uma evolução de
		schema adicional que adicionaria pelo menos uma rodada
		de proposta-aprovação-commit. O encerramento é a decisão
		urgente; a refinação de vocabulário pode esperar.

		Perda aceita: adr-044 carrega no rationale uma justificativa
		por exclusão que polui o texto do ADR. Decisões futuras
		de mesma natureza terão o mesmo problema até a resolução
		estrutural. A poluição é localizada e textualmente
		recuperável (o rationale documenta o porquê), não estrutural.

		Gatilho de reabertura para resolução: (a) decisão do
		founder de priorizar a evolução do enum, OU (b)
		identificação concreta de n=2 ADRs que precisaram do
		mesmo workaround. Critério (b) está satisfeito a partir
		de 2026-04-07: adr-044 e adr-045 são os dois casos
		confirmados, ambos do mesmo dia. Esta tensão passa de
		"registro especulativo de gap" para "gap com evidência
		empírica suficiente para priorização". O status permanece
		"open" porque a resolução estrutural ainda exige decisão
		do founder e ADR formal de evolução do enum — o gatilho
		reduz a barreira de priorização, não cria a resolução
		automaticamente.
		"""

	status: "open"

	structuralResolutionPath: "architecture/artifact-schemas/adr.cue"

	relatedADR: "adr-044"

	rationale: """
		Registro feito imediatamente na mesma rodada do adr-044
		que expôs o gap, antes que a observação se perca. A
		separação entre adr-044 (decisão de encerramento) e
		ten-009 (limitação de schema exposta pela decisão) é
		deliberada: o ADR governa a política, a tensão registra
		o defeito do vocabulário de classificação. Misturar as
		duas no mesmo artefato confundiria leitores futuros
		sobre se o problema era a decisão ou o enum.

		Esta é a segunda tensão da família "schema não tem
		valor adequado para o que precisamos expressar"
		(ten-001 foi a primeira, sobre optionality de campos
		em domain-definition). O padrão sugere que evoluções
		de enums e cardinalidades de schema devem ser
		periodicamente revisitadas conforme uso real produz
		casos novos. Mas isso é observação, não regra — não
		justifica meta-tensão neste momento.
		"""
}
