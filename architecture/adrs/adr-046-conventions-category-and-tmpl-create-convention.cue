package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr046: artifact_schemas.#ADR & {
	id:            "adr-046"
	title:         "Categoria architecture/conventions/ e template tmpl-create-convention"
	date:          "2026-04-08"
	status:        "accepted"
	decisionClass: "structural"
	decider:       "founder"

	context: """
		WI-027 é a primeira convenção concreta prevista no
		repositório — pede criar um artefato que declare
		protocolo de co-evolução entre tipos já existentes. A
		categoria e o template adequados ainda não existem. O
		templateRef declarado na WI era tmpl-create-schema@v1,
		o que força um cast incorreto: convenção não é schema —
		não define um #Type contra o qual instâncias unificam.
		É protocolo de derivação cross-artefato entre tipos já
		existentes, com especificidade (quais tipos, quais
		campos, política de materialização) que só a convenção
		concreta fixará, fora do escopo desta ADR.

		Esta ADR resolve os gaps meta-estruturais. A primeira
		convenção concreta fica para commit subsequente (Parte B),
		usando o mecanismo aqui criado.

		Três gaps estruturais emergem da análise:

		1. Categoria inexistente. architecture/ tem hoje duas
		   categorias normativas: schemas (artifact-schemas/,
		   define o que é cada tipo) e princípios
		   (design-principles.cue, afirmação normativa universal
		   do sistema). Nenhuma cobre "como dois tipos de
		   artefato co-evoluem por protocolo de derivação
		   específico".

		2. Template inexistente. Os quatro kinds atuais
		   (create-schema, validate-artifact, create-instance,
		   create-script) não cobrem criação de convenção.
		   Reutilizar tmpl-create-schema força quality gates
		   inaplicáveis (_schema.location com canonicalPathRegex
		   — convenção não é schema); tmpl-create-instance força
		   precondição de schema existente; tmpl-create-script
		   força gates de idempotência e reprodutibilidade que
		   só fazem sentido para executáveis.

		3. WI mal classificada por omissão. WI-027 carrega
		   templateRef inválido — referência quebrada porque a
		   categoria certa não existia. Reclassificar a WI exige
		   primeiro criar o template válido.

		Enquadramento em três camadas complementares (com tipos
		lógicos distintos, não ortogonais — schemas podem embutir
		invariantes, princípios podem se instanciar em schemas,
		há sobreposição funcional):

		- schema: define o que é cada tipo (ontologia). Vive em
		  architecture/artifact-schemas/. Restringe instâncias
		  futuras do tipo via cue vet.
		- princípio: declara invariante do sistema que vale
		  sempre, independente de quais tipos concretos existam
		  (axioma). Vive em architecture/design-principles.cue
		  ou governance/repo-principles.cue. Aplica-se
		  universalmente.
		- convenção: declara protocolo de relação entre dois ou
		  mais tipos específicos (protocolo). Vive em
		  architecture/conventions/. Aplica-se quando o par de
		  tipos existe, não universalmente.

		As três camadas são complementares e parcialmente
		co-necessárias: um sistema pode ter schemas sem
		convenções (tipos isolados), mas uma convenção sem
		schemas não tem sobre o que operar, e um princípio sem
		schemas é asserção vazia. A categoria
		architecture/conventions/ preenche a camada de protocolo,
		hoje ausente.

		Nota sobre timing (n=1): esta decisão é tomada antes de
		qualquer convenção concreta existir no repositório —
		WI-027 antecipa a primeira instância, mas nenhuma
		materialização foi ainda produzida. Pattern ten-009
		recomenda esperar n=2 antes de fixar enum de
		classificação, mas aquela decisão era sobre enum fechado
		em schema com custo de migração alto. Aqui o custo
		inverso prevalece: criar categoria em n=1 tem custo de
		reversão baixo (mover arquivos se necessário), enquanto
		adiar para n=2 forçaria reabrir decisão de categoria no
		meio de WI subsequente. Trade-off explicitamente aceito.

		Alternativas consideradas e rejeitadas:

		- (a) Forçar convenção como schema em artifact-schemas/.
		  Rejeitado por dois níveis. Mecânico: não define #Type
		  contra o qual instâncias unificam. Ontológico: schemas
		  em artifact-schemas/ descrevem estrutura interna de um
		  tipo; convenção descreve relação entre tipos já
		  definidos. Corrigir o path para caber no template
		  seria deixar o template mandar na ontologia do
		  artefato — inversão da relação correta.

		- (b) Declarar como princípio em design-principles.cue.
		  Rejeitado: princípios são invariantes do sistema
		  (aplicam a tudo sempre, independente de quais tipos
		  existam). Convenção é protocolo específico a par de
		  tipos concretos — natureza lógica distinta.

		- (c) Embutir o protocolo dentro do schema do tipo fonte
		  (estender o schema do tipo que dirige a derivação com
		  descrição dos outputs que ele governa). Rejeitado:
		  schemas descrevem estrutura interna do próprio tipo.
		  Descrever estrutura de outro tipo dentro dele viola P0
		  (duas localizações canônicas do mesmo conhecimento) e
		  P1 (schema de um tipo não define campos de outro tipo).

		- (d) Aceitar warn no CI e registrar convenções ad-hoc
		  sem categoria. Rejeitado: convenções cross-artefato
		  são padrão latente no repo (glossary↔domain-model,
		  event payload↔domain events, schema↔outputs derivados).
		  Ad-hoc é drift por construção quando o padrão recorre.
		"""

	decision: """
		Três decisões acopladas, rotuladas para referência
		atômica. Escopo estritamente meta-estrutural: categoria
		+ template + governance + reclassificação de WI-027.
		Nenhuma convenção concreta é criada nesta ADR.

		(1) [categoria] Criar architecture/conventions/ como
		categoria para artefatos que declaram protocolo de
		derivação, co-evolução ou relação formal entre dois ou
		mais tipos de artefato já existentes. Cada convenção é
		singleton com tipos locais inline — pattern estabelecido
		por governance/repo-structure.cue e
		governance/bounded-context-completeness.cue (n=2).
		Nenhum #Convention schema central em artifact-schemas/
		por ora: validar a generalidade de qualquer shape
		proposto exige segundo caso concreto. Decisão sobre
		schema central fica deferida conscientemente até n=2,
		seguindo pattern ten-009 para generalização prematura.

		Consequência de classificação: arquivos em
		architecture/conventions/ caem em
		unmatched-governed-with-schemas (warn) no file
		classification do CI, mesmo tratamento dos singletons
		análogos em governance/. Aceitável nesta fase; resolvido
		junto com a decisão sobre schema central.

		(2) [kind-extension] Estender #TaskTemplate.kind em
		architecture/artifact-schemas/task-template.cue para
		aceitar create-convention como quinto valor do enum
		fechado. Adicionar tmpl-create-convention@v1 em
		ai-orchestration/agent-instructions/task-templates.cue
		com preReads, steps e qualityGates específicos: leitura
		dos schemas dos tipos governados, identificação de
		capability flags e campos upstream que dirigem derivação,
		declaração explícita da relação canônica com SoTs
		upstream, classificação da política de materialização
		(pure-derived/pure-authored/hybrid) e separação
		determinístico/advisory da validação per adr-040.

		O vocabulário de materialização da convenção
		(blockMarkers para delimitar zonas derivadas dentro de
		arquivos híbridos) herda o nome blockId de
		repo-structure.cue.derivedArtifacts para continuidade
		lexical com o mecanismo existente. A sintaxe concreta
		do marker é responsabilidade de cada convenção (depende
		do formato alvo) e será fixada pela instância concreta,
		não por esta ADR meta-estrutural.

		(3) [governance] Registrar override de governance em
		governance/build-time/task-governance.cue: criticality
		medium, lease 8h, approvalRequired true, eligibleRoles
		[spec-writer]. Alinhado com tmpl-create-instance e
		tmpl-create-script: convenção governa derivação entre
		tipos já existentes — blast radius é o par de tipos
		afetados, não o sistema inteiro (schema, high) nem
		isolado (validação, low).

		Reclassificação de WI-027: version bump v1→v2 e
		templateRef passa de tmpl-create-schema@v1 para
		tmpl-create-convention@v1. Não é retratação — é correção
		de classificação prévia que não tinha categoria
		disponível. Após este commit, WI-027 passa a ter
		categoria e template adequados para execução em commit
		subsequente.
		"""

	consequences: """
		Positivas: convenções cross-artefato ganham localização
		canônica e protocolo de criação explícito; padrão
		acomoda convenções futuras sem reabrir a decisão;
		mantém P0 ao fixar uma única fonte de protocolo por par
		de tipos; aplica P1 corretamente — schema define o que
		é, convenção define como o tipo deriva/co-evolui. WI-027
		passa a ser executável sob template válido.

		Negativas: quinto valor no enum #TaskTemplate.kind
		amplia superfície de manutenção; ausência de #Convention
		central deixa arquivos em architecture/conventions/ em
		warn no file classification (consistente com
		repo-structure, bounded-context-completeness, mas não
		validate-conformance); fronteira convenção↔princípio
		mantém componente interpretativo — o limiar onde
		convenção recorrente promove-se a princípio não é
		mecânico. Mitigação: teste operacional (convenção
		governa 2+ tipos específicos; princípio governa o
		sistema inteiro) e promoção por WI explícito quando
		surgir primeiro caso concreto.

		Known gaps declarados (não omitidos):

		- #Convention schema central deferido até n=2
		  convenções concretas (pattern ten-009). Warn
		  transitório no file classification é aceito
		  conscientemente.

		- Enquadramento das 3 camadas (schema/princípio/
		  convenção) é local a esta ADR. design-principles.cue
		  não ganha referência cruzada agora. Se o enquadramento
		  se consolidar em n=2+, considerar atualização para
		  registrar a taxonomia como meta-estrutura formal.

		- Follow-ups específicos de cada convenção concreta
		  (registros em outros SoTs, mecanismos de enforcement,
		  validações adicionais) pertencem ao ADR da convenção
		  correspondente, não a esta ADR meta-estrutural.

		Fronteira de escopo e regulatória: esta ADR regula
		apenas a existência da categoria, o template de criação,
		a governança do processo e a reclassificação de WI-027.
		Não regula conteúdo de qualquer convenção concreta.
		Constraints regulatórias (dp-10, LGPD, KYC) aplicam-se
		sobre conteúdo autoral de convenções concretas — serão
		avaliadas no ADR da convenção correspondente, não aqui.
		BCs regulados (FCE, SCF, BKR, REW, IDC, ATO, INS, ITC)
		cujos artefatos vierem a ser governados por alguma
		convenção concreta devem tratar o contrato regulatório
		no ADR da convenção correspondente, não aqui.
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/artifact-schemas/task-template.cue",
		"ai-orchestration/agent-instructions/task-templates.cue",
		"governance/build-time/task-governance.cue",
		"governance/build-time/task-specs/wi-027.cue",
	]

	principlesApplied: ["P0", "P1", "P12"]

	supersedes: []

	rationale: "Convenções cross-artefato não têm categoria nem template adequados. Resolver os três gaps (categoria, template, reclassificação da WI bloqueada por omissão) em decisão acoplada entrega a primitiva reutilizável como Parte A de um split consciente — Parte B (a primeira convenção concreta) é decisão separada em commit subsequente. O split isola meta-estrutura (esta ADR) de instância (convenção concreta), evitando contaminar o escopo da decisão meta com choices da primeira materialização. reversibility=high refere-se estritamente a esta decisão meta-estrutural: reverter significaria fundir conteúdo de conventions/ em outra home e remover o kind do enum, operações mecânicas sem perda de dados. Convenções concretas futuras que materializem contratos públicos terão reversibility própria governada pelo blast radius dos contratos que normalizam, não por esta decisão."
}
