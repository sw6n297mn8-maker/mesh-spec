package tension_log

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ten007: artifact_schemas.#TensionEntry & {
	id:    "ten-007"
	date:  "2026-04-07"
	title: "Schema #VerticalApplicability não distingue dependência estrutural de ausência de validação empírica"

	kind:          "schema-limitation"
	tensionTarget: "architecture/shared-types/vertical-applicability.cue"
	manifestsIn:   "architecture/lenses/lens-temporal-modeling-for-financial-systems.cue"

	description: """
		Durante o backfill piloto da Fase 1 de adr-043, ao
		classificar três lenses analíticas pela primeira vez
		segundo o tipo #VerticalApplicability, emergiu uma
		ambiguidade na fronteira semântica entre dois dos três
		modes do tipo: vertical-adaptable e vertical-agnostic.

		O schema define vertical-adaptable como "artefato com
		núcleo reutilizável cujos pontos de variação por
		vertical estão explicitamente declarados" e
		vertical-agnostic como "artefato cujas premissas são
		válidas para qualquer cadeia B2B com execução física
		verificável". Estas definições são corretas mas não
		discriminam dois fenômenos categoricamente distintos
		que aparecem em campo:

		Fenômeno 1 — dependência estrutural por vertical.
		O artefato tem partes (vocabulário operacional,
		mecanismos, premissas) que mudam quando a vertical
		muda. Transferir o artefato exige redefinir essas
		partes. Exemplo: lens-supply-chain-theory, cujo
		purpose declara explicitamente cadeia produtiva da
		construção civil e cujos conceitos operacionais
		(boletim de medição, retenção, glosa) são vocabulário
		setorial. Aqui adaptable é a classificação correta:
		o artefato genuinamente precisa adaptação.

		Fenômeno 2 — núcleo universal com instanciação
		setorial acidental. O artefato tem núcleo conceitual
		integralmente independente de vertical, mas seus
		exemplos foram bootstrapados na vertical inicial.
		Transferir o artefato não exige adaptação alguma
		do núcleo nem dos conceitos — apenas substituição
		dos exemplos. Exemplo: lens-temporal-modeling-for-financial-systems,
		cujos conceitos (Instant, LocalDate, settlement chains,
		day count, timezone discipline, bitemporal, vintage)
		são puramente universais, mas cujos meshExamples
		estão integralmente em FIDC/NF/antecipação.

		A versão inicial do backfill classificou
		lens-temporal-modeling como vertical-adaptable usando
		o critério implícito "ainda não foi validada fora de
		construção". Esse critério está errado: o schema
		define adaptable por necessidade de adaptação
		estrutural, não por ausência de evidência empírica
		cross-vertical. Aplicar adaptable como proxy para
		"não validada ainda" subestima ativos genuinamente
		universais já presentes no sistema, enfraquece a
		semântica do tipo, e cria pressão futura para
		reclassificações em massa quando a evidência empírica
		acumular sem nenhuma mudança estrutural correspondente.

		A correção foi feita no piloto: lens-temporal-modeling
		foi reclassificada como vertical-agnostic. Mas a
		distinção não está formalizada em nenhum lugar do
		schema, e o próximo agente que enfrentar uma
		classificação ambígua não tem ancoragem mecânica para
		reproduzir o critério correto. A ambiguidade vai
		retornar.

		A ambiguidade não decorre de uso incorreto do tipo,
		mas de uma lacuna real na capacidade do schema de
		distinguir esses dois fenômenos semânticos.
		"""

	resolution: """
		Aceita como tensão aberta de schema sem resolução
		estrutural imediata. A correção tática feita no piloto
		(reclassificar lens-temporal-modeling como agnostic e
		documentar o critério no rationale do campo) é
		suficiente para o estado atual de evidência: três
		lenses classificadas, padrão observado uma vez.

		Ganho da decisão: evita expansão prematura do schema
		antes de existirem casos suficientes para distinguir
		se a fronteira merece (a) clarificação textual no
		schema atual, (b) novo campo discriminador
		(e.g., crossVerticalEvidence), ou (c) refinamento dos
		modes existentes (e.g., dividir adaptable em
		structural-adaptable vs example-bound). Cada uma dessas
		opções tem custo e implica decisões irreversíveis sobre
		o vocabulário do tipo.

		Perda aceita: o critério de classificação depende
		hoje de raciocínio interpretativo do agente apoiado em
		rationale dos artefatos vizinhos, não de constraint
		mecânico do schema. Há risco real de drift entre
		classificações futuras conforme o backfill avança.

		Mitigação durante o backfill: o piloto sugere a
		seguinte heurística operacional — "adaptable exige
		identificar pontos de variação concretos no artefato;
		ausência de pontos de variação concretos com núcleo
		universal tende a indicar agnostic". Esta heurística
		não é ainda formalizada no schema e permanece sujeita
		a revisão conforme novos casos surgem. Após cada batch
		de backfill, esta tensão deve ser revisitada para
		verificar se o padrão pede formalização.

		Gatilho de reabertura: acumular ≥3 casos independentes
		onde a fronteira gera dúvida durante classificação em
		artefatos distintos, OU identificar caso onde a
		heurística operacional acima é insuficiente para
		decidir.
		"""

	status: "accepted"

	structuralResolutionPath: "architecture/shared-types/vertical-applicability.cue"

	relatedADR: "adr-043"

	rationale: """
		Registro feito imediatamente após a primeira
		manifestação concreta da ambiguidade, antes de
		continuar o backfill em outros artefatos. O objetivo
		é congelar o insight enquanto o contexto que o gerou
		ainda é recuperável: o agente atual aprendeu a
		distinção via dialogic review com o founder durante
		a classificação de uma lens específica, e qualquer
		agente futuro sem acesso àquela conversa precisa do
		registro para reproduzir o critério. Sem este
		artefato, o conhecimento vive apenas no rationale de
		um campo de uma lens, e pode ser perdido em
		refatoração. A entry deliberadamente não propõe
		solução de schema — descreve a observação, a
		consequência e o gatilho para reabertura, deixando o
		desenho da resolução para um ADR posterior caso o
		gatilho seja atingido.
		"""
}
