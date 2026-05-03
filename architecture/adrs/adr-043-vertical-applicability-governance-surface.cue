package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr043: artifact_schemas.#ADR & {
	id:            "adr-043"
	title:         "Superfície de governança para aplicabilidade de artefatos por vertical de cadeia produtiva"
	date:          "2026-04-07"
	status:        "accepted"
	decisionClass: "structural"
	decider:       "founder"

	context: """
		A tese Mesh declara-se agnóstica a cadeia produtiva:
		domain/domain-definition.cue afirma que o padrão é transversal
		a qualquer cadeia B2B onde execução física gera evidência
		verificável. Na prática, porém, artefatos individuais foram
		modelados a partir da experiência inicial em construção civil
		brasileira, e embutem premissas setoriais em graus variados —
		alguns genuinamente universais, outros aparentemente universais
		mas tacitamente construção-específicos, outros ainda com núcleo
		reutilizável e pontos de variação por vertical.

		Hoje essa distinção vive exclusivamente em prosa, dentro de
		comentários ou rationales livres. Não existe campo estrutural
		em nenhum schema que declare para quais verticais um artefato
		é semanticamente válido. Consequências diretas:

		- A universalidade da tese é afirmada mas não verificável
		  mecanicamente contra os artefatos.
		- Ao considerar expansão para nova vertical (logística,
		  energia, aeroespacial), não há consulta mecânica que
		  responda "quais artefatos precisam ser revisitados e
		  quais podem ser reusados tal como estão".
		- Drift entre afirmação de generalidade e realidade
		  setorial é descoberto por leitura humana caso a caso.
		- Decisões de modelagem futuras carecem de superfície
		  explícita para registrar "esta escolha embute premissa
		  de construção civil e precisará ser generalizada quando
		  X ocorrer".

		Alternativas consideradas e rejeitadas:

		- Campo livre tipo string (e.g. applicableTo: "any" ou
		  lista livre). Rejeitado: perde governabilidade. Valores
		  divergentes ("construction" vs "civil-construction" vs
		  "building") criam drift semântico; consulta mecânica
		  exige normalização posterior; expansão não passa por
		  decisão explícita.

		- Booleano único isVerticalAgnostic. Rejeitado: colapsa
		  três estados distintos (agnóstico, específico, adaptável)
		  em dois. Perde especialmente o caso mais comum esperado
		  na prática: artefato com núcleo reutilizável e pontos
		  de variação explícitos por vertical.

		- Enum incluindo "general-b2b-physical-execution" como
		  valor. Rejeitado: universalidade não é uma vertical
		  entre outras — é ausência de acoplamento vertical.
		  Modelar como valor disfarçado introduz ambiguidade por
		  construção entre "é agnóstico" e "pertence à vertical
		  genérica". A separação vira mode == "vertical-agnostic",
		  não valor do enum.

		- Incluir "industrial" no enum. Rejeitado: sobrepõe com
		  construction, logistics e energy simultaneamente.
		  Manufatura discreta é representada por "manufacturing";
		  processos contínuos caem em energy ou em manufacturing
		  conforme o caso. Ambiguidade de enum é bug de
		  vocabulário.

		- Manter em prosa (status quo). Rejeitado: é justamente
		  o estado que produz o problema. Prosa não é consultável
		  mecanicamente nem auditável por gate estrutural.

		- Fazer o campo obrigatório imediatamente em todos os
		  schemas-alvo. Rejeitado: todos os artefatos existentes
		  passariam a estar estruturalmente inválidos no mesmo
		  commit que introduz o conceito. O silêncio atual é
		  legítimo — o campo não existia. Rollout em duas fases
		  permite introduzir a superfície sem quebrar a base
		  instalada e dá janela explícita para backfill informado.

		- Tratar intenção de extensão e evidência de validação
		  no mesmo campo (e.g. supportedVerticals genérico).
		  Rejeitado: junta afirmação ("queremos suportar") com
		  evidência ("foi validado"). O valor governável está
		  na distinção entre as duas. Esta ADR comita apenas a
		  superfície de evidência; intenção de extensão futura,
		  se necessária, virá em campo separado via ADR
		  posterior.
		"""

	decision: """
		Três decisões acopladas.

		(1) Introduzir dois tipos reutilizáveis em
		architecture/shared-types/vertical-applicability.cue:

		#VerticalClass: enum canônico fechado com seis valores
		iniciais em kebab-case — construction, logistics, energy,
		agriculture, manufacturing, aerospace. Expansão do enum
		exige ADR. Adição via PR direto é violação da disciplina
		de vocabulário que torna o campo útil para governança.

		#VerticalApplicability: união discriminada por campo
		mode, três branches:

		  vertical-agnostic: artefato válido para qualquer cadeia
		  B2B com execução física verificável dentro do recorte
		  Mesh. Proíbe primaryVertical e validatedVerticals por
		  construção (_|_ nos branches da união).

		  vertical-specific: artefato que embute premissas de
		  UMA vertical. Exige primaryVertical. Proíbe
		  validatedVerticals — se aplicasse a mais de uma seria
		  adaptable.

		  vertical-adaptable: núcleo reutilizável com pontos de
		  variação explícitos. Exige primaryVertical. Aceita
		  validatedVerticals como lista não vazia, enforçando
		  por schema: (a) elementos distintos de primaryVertical
		  via constraint (#VerticalClass & !=primaryVertical),
		  (b) unicidade via list.UniqueItems. validatedVerticals
		  representa evidência de validação, não intenção — uma
		  vertical só entra na lista após validação explícita do
		  artefato contra as premissas daquela vertical, sem
		  redefinição material do núcleo do artefato.

		rationale é obrigatório em todos os modos. Classificar
		como agnostic, specific ou adaptable é uma micro-decisão
		de design que merece registro explícito — inclusive
		(especialmente) em vertical-agnostic, onde afirmar
		universalidade é a afirmação que mais carrega risco de
		falsa generalização.

		(2) Escopo de adoção nos schemas:

		Sob o regime de aplicabilidade desta ADR (opcional no
		schema na Fase 1, obrigatório no schema na Fase 2 — ver
		item 3):
		  - #Subdomain (architecture/artifact-schemas/subdomain.cue)
		  - #BoundedContextCanvas (architecture/artifact-schemas/canvas.cue)
		  - #AnalyticalLens (architecture/artifact-schemas/lens.cue)

		Opcional em todas as fases:
		  - #DomainModel
		  - #AgentSpec

		Fora de escopo:
		  - #ADR, #TaskTemplate, #StructuralCheck, schemas meta
		    de governança e demais artefatos cuja função não
		    modela recorte produtivo.

		Rationale do recorte: os três schemas obrigatórios são
		justamente aqueles onde a decisão de modelagem pode
		embutir premissas de cadeia produtiva sem sinalização
		explícita (definição de core domain, desenho de BC,
		framework analítico). Os dois opcionais podem carregar
		a informação quando útil mas sua função não exige
		declaração universal. O restante trata de governança do
		próprio sistema ou de artefatos meta que não modelam
		realidade produtiva da rede; neles, o campo seria ritual
		sem poder descritivo.

		(3) Rollout em duas fases:

		Fase 1 (esta ADR): o campo verticalApplicability? passa
		a ser suportado nos três schemas-alvo, acompanhado de
		quality criterion advisory com severity warn no
		_qualityCriteria de cada schema. A ausência do campo
		gera warning, sem bloquear. Novos artefatos desses tipos
		devem declarar o campo já na criação; artefatos
		existentes continuam válidos e entram em backfill
		progressivo guiado pelo warning.

		Fase 2 (ADR posterior, condicionada a backfill completo):
		remoção do "?" tornando o campo estruturalmente
		obrigatório e elevação do quality criterion a severity
		"fail". A transição só ocorre após verificação explícita
		de que todos os artefatos vigentes nos schemas-alvo
		declaram verticalApplicability. A ADR da Fase 2 deve
		referenciar explicitamente a adr-043 em context e
		decision, preservando a decisão conceitual desta ADR e
		alterando apenas o regime de enforcement.

		Distribuição do conhecimento:
		  - Schema canônico do tipo vive em
		    architecture/shared-types/vertical-applicability.cue
		    (P0: localização canônica única).
		  - Schemas consumidores importam shared_types e
		    referenciam shared_types.#VerticalApplicability.
		    Não há cópia da definição nos schemas-alvo.
		  - Esta ADR é a fonte normativa primária da decisão.
		    Rationales nos schemas-alvo apontam para adr-043;
		    não replicam a justificativa.
		"""

	consequences: """
		Positivas: afirmação de universalidade da tese Mesh
		passa a ser verificável mecanicamente contra os
		artefatos, não apenas declarada em prosa; consulta
		mecânica responde "quais artefatos precisam ser
		revisitados ao expandir para nova vertical" por query
		sobre campo estruturado; drift entre generalidade
		afirmada e realidade setorial vira finding estrutural
		em vez de descoberta por leitura; vocabulário fechado
		evita divergência semântica por construção; distinção
		evidência vs intenção preserva governabilidade do
		campo; rollout em duas fases permite introduzir a
		superfície sem invalidar a base instalada e dá janela
		explícita e governada para backfill.

		Negativas: cada novo artefato em Subdomain, Canvas e
		Lens passa a carregar uma micro-decisão adicional
		(classificar como agnostic, specific ou adaptable),
		ampliando a carga cognitiva de authoring — mitigada
		pelo rationale obrigatório que força a decisão ser
		explícita em vez de tácita; expansão do enum depende
		de ADR, introduzindo fricção deliberada que pode
		atrasar incorporação de nova vertical — trade-off
		consciente, é o mecanismo que torna o vocabulário
		governável; rollout em duas fases introduz janela de
		heterogeneidade temporária (alguns artefatos declaram,
		outros não) — mitigada pelo quality criterion warn que
		torna a lacuna visível; Fase 2 exige commit de backfill
		completo antes da elevação a fail, adicionando work
		item explícito no horizonte. A classificação entre
		vertical-agnostic, vertical-specific e vertical-adaptable
		continua sendo julgamento semântico; o ganho desta ADR
		é de explicitude, comparabilidade e auditabilidade, não
		de objetividade absoluta.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/artifact-schemas/subdomain.cue",
		"architecture/artifact-schemas/canvas.cue",
		"architecture/artifact-schemas/lens.cue",
	]

	plannedOutputs: [
		"architecture/shared-types/vertical-applicability.cue",
	]

	principlesApplied: [
		"P0: zero duplicação — definição do tipo #VerticalApplicability vive em um único arquivo em shared_types; schemas consumidores importam, não copiam; justificativa da decisão vive nesta ADR, rationales dos schemas apontam para adr-043",
		"P1: schema-first — tipo canônico precede qualquer instância que o consuma; não há artefato declarando verticalApplicability antes do schema existir",
		"P10: agentes estocásticos recomendam, gates determinísticos validam — quality criterion com severity warn produz recomendação advisory na Fase 1; promoção a fail na Fase 2 ocorre apenas quando a invariante pode ser verificada deterministicamente sem falso-positivo por backfill pendente",
	]

	supersedes: []

	rationale: "Agnosticismo a cadeia produtiva é afirmação central da tese Mesh mas vive apenas em prosa. Introduzir superfície tipada para declarar aplicabilidade por vertical torna a afirmação verificável mecanicamente, distingue artefatos genuinamente universais dos que embutem premissas setoriais, e prepara o sistema para expansão explícita e governada para novas verticais. Rollout em duas fases preserva a base instalada."
}
