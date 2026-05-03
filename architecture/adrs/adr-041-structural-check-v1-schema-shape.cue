package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr041: artifact_schemas.#ADR & {
	id:    "adr-041"
	title: "Structural-check v1 schema shape: minimal declarative kinds"
	date:  "2026-04-07"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		adr-040 estabeleceu a categoria de structural verification
		(verificação determinística sobre fatos decidíveis,
		separada do design review interpretativo) e nomeou o
		schema dedicado architecture/artifact-schemas/structural-check.cue
		como artefato derivado a ser criado em commit subsequente.
		Não cristalizou, deliberadamente, o shape concreto desse
		schema — qual conjunto de campos, qual modelo de
		expressividade da regra, quais tipos de check suportar
		na primeira versão. Essa decisão é o objeto desta ADR.

		O risco a evitar nesta decisão é dual. De um lado,
		subdimensionar — schema tão pobre que não cobre o caso
		concreto que motivou adr-040 (vc-cv-03 falso positivo
		sobre presença de bloco communication no canvas IDC).
		De outro, sobredimensionar — schema tão expressivo que
		reintroduz a confusão de categoria por trás de
		"declarativo": uma mini-linguagem cuja interpretação
		volta a depender de runner sofisticado e de disciplina
		semântica não verificável.

		Alternativa considerada e rejeitada: rule como snippet
		CUE arbitrário embutido na entrada de structural-check.
		Mais expressiva, mas rejeitada porque transforma o
		schema em mini-DSL cuja semântica de execução não é
		decidível por inspection direta — runner futuro
		precisaria de motor de avaliação CUE genérico, e a
		fronteira entre "determinístico" e "interpretativo"
		passaria a depender de quem escreve cada snippet. Isso
		reintroduz, em forma mais sutil, exatamente o problema
		que adr-040 corrige.
		"""

	decision: """
		Schema structural-check v1 é deliberadamente mínimo,
		estritamente declarativo, e estritamente decidível.

		Campos da v1 (8 campos):

		(1) id — identificador único da regra.
		(2) title — título curto humano.
		(3) artifactType — qual tipo de artefato a regra valida
		    (referencia #ArtifactType existente).
		(4) description — descrição da regra em prosa.
		(5) kind — discriminador que determina o shape de rule.
		(6) rule — dado estruturado cujo shape é determinado
		    por kind. Não é snippet CUE arbitrário. Não carrega
		    lógica embutida.
		(7) errorMessage — mensagem específica emitida quando
		    a regra falha; deve conter informação suficiente
		    para o autor entender o que precisa corrigir.
		(8) rationale — por que esta regra existe.

		Conjunto de kinds da v1 (3 kinds):

		(1) required-block — verifica presença de um bloco
		    nomeado no artefato. rule especifica blockName.
		    Cobre diretamente o caso vc-cv-03.

		(2) reference-exists — verifica que toda referência
		    em um campo aponta para um identificador que
		    existe no mesmo artefato. rule especifica
		    sourcePath (campo do artefato sob validação) e
		    refNamespace (bloco do mesmo artefato onde os
		    ids válidos vivem). Cross-artifact reference
		    checking — verificar referências contra um
		    artefato distinto — fica explicitamente fora da
		    v1 e será endereçada quando aparecer caso real
		    que justifique o custo do runner adicional.

		(3) same-artifact-consistency — verifica relação
		    explícita entre dois blocos do mesmo artefato.
		    rule especifica os dois blocos e a natureza da
		    relação (e.g., todo id referenciado em A deve
		    existir como entry em B).

		Sem campo severity. Estrutural é gate, gate é binário,
		e a v1 trata toda violação como fail. Adicionar warn
		no estrutural seria reintroduzir ambiguidade pela
		porta dos fundos. Se um caso concreto futuro exigir
		warn estrutural, isso será decisão explícita registrada
		em ADR derivado, não default herdado.

		O conjunto de kinds é deliberadamente conservador.
		Cardinalidade genérica, regex matching, verificações
		cross-artifact (entre dois artefatos distintos) e
		quaisquer outros tipos de check não estão na v1.
		Serão adicionados organicamente quando casos concretos
		aparecerem — cada novo kind exige decisão explícita
		sobre seu shape declarativo, não evolução implícita
		de uma mini-linguagem.

		Runner futuro: o schema é runner-friendly por
		construção (campos suficientemente explícitos para
		despachar por kind), mas o runner concreto não é parte
		desta decisão. Esta ADR define o contrato; o runner
		é commit separado com seu próprio ciclo de design.
		"""

	consequences: """
		Positivas:

		(1) Cobre o caso real imediato. required-block resolve
		o vc-cv-03 falso positivo (validador acusou ausência
		de bloco communication que existia) por construção,
		não por disciplina de prompt.

		(2) Disciplina anti-mini-DSL. Forçar rule a ser dado
		estruturado por kind impede que o schema vire uma
		linguagem própria cuja interpretação volta a depender
		de motor genérico. Cada kind tem semântica fixa e
		documentada.

		(3) Runner-friendly sem prematuro. O runner futuro
		despacha por kind: cada kind tem 1 implementação
		específica. Simples de escrever, simples de testar,
		simples de auditar.

		(4) Crescimento orgânico. Novos kinds são adicionados
		quando casos reais aparecem — não antes. Evita
		especulação sobre quais checks serão necessários.

		(5) Coerência com adr-040. Schema mínimo declarativo
		mantém a separação categórica que adr-040 estabeleceu:
		rule estruturada não pode acidentalmente exigir
		julgamento interpretativo.

		Negativas:

		(1) Limitação expressiva temporária. Alguns checks
		desejáveis para canvas podem não caber nos 3 kinds
		atuais e ficar fora da v1. Mitigação: identificar
		quais ficam de fora ao escrever architecture/structural-checks/canvas.cue
		e registrar como dependência futura, não como bug.

		(2) Custo de adição de cada novo kind. Cada novo kind
		exige decisão explícita (potencialmente ADR), não
		simplesmente um snippet adicional. Custo aceito como
		preço da disciplina anti-mini-DSL.

		(3) Sem cardinalidade genérica na v1. Checks como
		"capability tem pelo menos 1 invariant referenciada"
		precisam ser modelados como same-artifact-consistency
		ou aguardar kind futuro. Aceitável porque o caso
		concreto motivador (vc-cv-03) não exige cardinalidade
		genérica.

		(4) Sem cross-artifact-check na v1. Checks que exigem
		ler dois artefatos distintos (e.g., "todo sh-NN
		referenciado neste canvas existe em domain/stakeholder-map.cue")
		ficam fora da v1. Esses são casos reais que aparecerão
		ao escrever structural-checks/canvas.cue. Mitigação:
		registrar como dependência futura para v2; reference-exists
		na v1 cobre apenas referências internas ao próprio
		artefato.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: []

	plannedOutputs: [
		"architecture/artifact-schemas/structural-check.cue",
	]

	derivedArtifacts: [
		"architecture/structural-checks/canvas.cue",
	]

	principlesApplied: [
		"P10",
		"P12",
	]

	rationale: """
		ADR derivada de adr-040. adr-040 decidiu a categoria
		(estrutural vs interpretativo); esta ADR decide o
		shape do schema que materializa a categoria estrutural.
		Separar as duas decisões em ADRs distintos preserva
		rastreabilidade: futuras evoluções do shape (novos
		kinds, novos campos) referenciam adr-041 sem tocar
		adr-040; reversões da categoria, se ocorrerem,
		afetam adr-040 sem confundir o histórico de shape.

		decisionClass structural porque cria tipo novo
		(#StructuralCheck) e estabelece contrato que
		structural-checks/<artifact>.cue subsequentes
		consomem. Não é foundational (não muda P0-P12);
		é structural (cria relação nova entre artefatos).

		reversibility medium: schema é reversível sem custo
		de dados (nenhuma instância existe ainda além das
		que serão criadas neste ciclo). Mas commit a um
		contrato que primeiras instâncias vão consumir —
		mudar o shape após instâncias existirem exige
		coordenação. Não é high porque há propagação
		coordenada se shape mudar; não é low porque nada
		persistido em SoT entra em jogo.

		blastRadius cross-cutting porque a v1 do schema
		condiciona como todos os tipos de artefato serão
		estruturalmente validados no futuro. Não é local
		(define padrão para todo artifact-schemas/);
		não é repo-wide (não toca CI pipeline ainda).

		Princípios aplicados: P10 e P12. P10 porque a
		decisão de manter rule como dado estruturado (não
		snippet executável) preserva a fronteira entre
		determinístico e interpretativo dentro do próprio
		mecanismo de gate — coerência interna com o
		princípio. P12 porque o schema declarativo é
		governança como código no sentido mais literal:
		regras vivem em CUE, são versionadas, e são
		executáveis-em-princípio por runner determinístico.

		Esta ADR é o segundo passo da sequência de migração
		definida em adr-040. O próximo passo é a criação
		concreta do schema architecture/artifact-schemas/structural-check.cue
		conforme este shape, em commit imediato após esta ADR.
		"""
}
