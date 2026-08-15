package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-195 — Emenda 1.1 da Constituição do Design System: torna CAUSAL o
// critério de vínculo dos tokens (VII), abre a segunda via de reabertura
// por evidência para regra derivada (IX) e corrige o domínio do
// quantificador universal da geometria (VI.4), reconhecendo a superfície
// primária de expressão humana livre. Reclassifica os 8 tokens que o
// red-team demonstrou sobrecongelados e cria 1 token escopado à classe
// nova. Nenhum valor foi escolhido, trocado ou recalibrado.

adr195: artifact_schemas.#ADR & {
	id:    "adr-195"
	title: "Emendar a Constituição do Design System: critério causal de vínculo de token, reabertura por evidência e domínio da geometria"
	date:  "2026-08-15"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	context: """
		O que NÃO está sendo corrigido. O adr-194 canonizou a Constituição v1.0
		com fidelidade — o texto promulgado pelo founder está preservado byte a
		byte, as camadas, trade-offs, casos limite, jurisprudência e pendências
		entraram sem "melhoria", e a classificação de cada token foi derivada do
		texto disponível. A execução daquele ADR não foi errada e não é
		revertida aqui: esta emenda opera EXATAMENTE pelo mecanismo que o
		adr-194 instalou (cláusula IX + regime de tokens VII), sobre o artefato
		que ele criou. O que mudou não foi o julgamento sobre a Constituição —
		foi a evidência disponível sobre onde passa a fronteira entre lei e
		calibração.

		Trigger 1 — prova cega da Superfície de Entrada V2. Um agente sem acesso
		ao protótipo anterior derivou e materializou corretamente anatomia e
		ordem de leitura, quatro estados, três espécies de pendência,
		procedência, estado × limite, autonomia sem CTA, persistência
		condicional e comportamento responsivo. A hipótese falhou como GAP +
		CONFLICT. O CONFLICT material: a Surface Spec previa compositor com raio
		16px e envio circular; a Constituição impõe raio zero em tudo; o token
		raio é constitution-bound; a implementação obedeceu à Constituição e
		passou TODOS os gates. O conflito não é entre lei e gosto — é entre a
		lei e uma classe de superfície que a lei nunca considerou ao escrever
		"em tudo".

		Trigger 2 — red-team somente-leitura dos tokens constitution-bound.
		Auditoria dos 13 tokens bound, testando cada um pela pergunta causal
		("qual lei superior deixaria de valer se este valor mudasse?"), com
		contrafactual por token. Veredito SYSTEMATIC OVERFREEZE: 5 corretos
		(pressionado, links, raio sob a leitura vigente de VI.4,
		movimento-easing, movimento-acao-do-usuario — todos expressam relação,
		caráter ou proibição SEM valor livre), 8 sobrecongelados (tinta, campo,
		foco, pesos, grid, movimento-elementos, movimento-superficie,
		movimento-decaimento-realce — em todos a lei sobrevive intacta ao
		contrafactual e o que estava congelado era craft), 0 sem moldura
		constitucional. O achado central não é a lista: é que o critério em
		vigor era SINTÁTICO — congelava o valor porque ele aparecia literalmente
		numa camada promulgada, em vez de perguntar se ainda restava valor livre
		sem mudança de significado. Por isso a falha é recorrente e previsível,
		não um acidente token a token.

		Três evidências internas confirmam o diagnóstico, todas visíveis no
		próprio contrato antes desta emenda: (i) grid declara a própria
		derivação como convenção adotada por Padrão de Excelência ("não há
		vantagem em reinventá-la"), isto é, melhor craft conhecido — acima de
		8/4 não há elo a apontar; (ii) pesos congelava 400/500/600 enquanto
		familia permanecia calibratable dentro de reservas qualificadas — uma
		troca autorizada como manutenção poderia tornar inimplementável um token
		bound; (iii) três tokens de movimento já PRATICAVAM a distinção
		moldura-vs-valor no texto de constraints ("o RANGE é bound — o valor
		exato dentro dele é calibrável") enquanto o rótulo dizia bound: o
		modelo já tinha o mecanismo certo, faltava-lhe o critério.

		Alternativas avaliadas:
		(a) Não emendar: tratar o CONFLICT como Surface Spec errada e manter
		    raio zero universal. REJEITADA: preserva o overfreeze sistêmico
		    (8 de 13) e condena as próximas propostas legítimas a duas saídas
		    ruins — obedecer contra a evidência, ou forjar um "elo superior
		    mudou" que não mudou (derivação retórica, que o próprio PG proíbe).
		(b) Reclassificar os 8 tokens sem tocar no critério. REJEITADA: trata o
		    sintoma. O critério sintático permanece, e o próximo token nasce com
		    o mesmo defeito — a falha demonstrada é da definição, não da lista.
		(c) Tornar raio calibratable globalmente. REJEITADA: destrói a lei
		    semiótica de VI.4. O red-team classificou raio como corretamente
		    bound justamente porque ali o valor CARREGA o significado; liberar o
		    token abriria arredondamento por estética em card, grid, recibo e
		    contêiner documental — exatamente a consumerização que a camada
		    existe para impedir.
		(d) Criar mecanismo novo — taxonomia de molduras, registry de tokens,
		    tipo ou camada constitucional adicional. REJEITADA: aparato
		    desproporcional. O campo constraints JÁ é o lar da moldura e os
		    tokens calibratable já o usavam assim (piso ≥3:1 em borda-funcional,
		    piso 48px em alvos-de-toque); o modelo suportava a emenda sem
		    superfície nova.
		(e) ESCOLHIDA: três emendas mínimas, cada uma apensada ao campo que já é
		    o lar canônico da regra corrigida, mais a reclassificação dos 8
		    tokens e UM token novo escopado à classe reconhecida.
		"""

	decision: """
		(1) CRITÉRIO DE VÍNCULO — CAUSAL, NÃO TEXTUAL (emenda ao campo
		tokenRegime, seção VII). Um token é constitution-bound SOMENTE quando
		não resta valor livre a calibrar: quando expressa uma relação, um
		caráter ou uma proibição cuja alteração, por si, muda significado,
		identidade, distinção semântica ou personalidade. Quando a camada fixa
		uma moldura e ainda resta valor livre dentro dela, o token é
		calibratable — e então a MOLDURA (piso, teto, relação, emprego,
		condição) é a lei, vive em constraints e é o que a emenda protege; o
		valor vigente vive no mesh-frontend-runtime. Um valor não vira lei por
		ter aparecido literalmente no texto promulgado. Recalibrar dentro da
		moldura segue sendo manutenção; estreitar, alargar ou remover a moldura
		é emenda. O texto promulgado v1.0 de VII permanece integral acima da
		emenda — nada foi removido.

		(2) SEGUNDA VIA DE REABERTURA: EVIDÊNCIA (emenda ao campo
		protectionClause.reopeningComplement, cláusula IX). Elo superior mudado
		continua sendo uma via; evidência nova passa a ser a outra, e SOMENTE
		para regra DERIVADA — invariante de arquitetura, lei transversal e
		personalidade só se reabrem pela primeira via. A segunda via exige
		demonstrar que a regra derivada foi falsificada, que seu domínio é mais
		amplo que o do princípio que pretendia materializar, ou que existe
		classe real que ela nunca considerou. Reabrir por evidência NÃO afirma
		que o princípio superior mudou: afirma que a derivação era mais larga
		que ele. A evidência é proporcional à profundidade da regra e
		verificável por terceiro — gosto, moda e conveniência não são evidência.
		Toda emenda por esta via declara quatro coisas: qual evidência apareceu;
		qual regra derivada foi atingida; qual parte da lei superior permanece
		intacta; e qual é a menor correção que restaura a derivação. A via não
		relaxa o método: é o método aplicado ao caso em que a regra, e não o
		princípio, era o erro.

		(3) DOMÍNIO DO QUANTIFICADOR DA GEOMETRIA (emenda ao campo
		layers.form.rootDecision, VI.4 — a primeira aplicação da via (2)). A lei
		permanece inteira: forma comunica função, nunca afeto; a expressão
		estrutural da Mesh comunica precisão, estabilidade, permanência e
		disciplina; arredondamento não é estilo, identidade nem amabilidade.
		Corrige-se apenas o alcance de "em tudo", reconhecendo UMA classe
		semanticamente distinta: a superfície primária de expressão humana
		livre — o campo onde a pessoa compõe, com suas palavras, aquilo que
		ainda não é dado do sistema. Ela NÃO é registro, evidência, atributo
		estruturado, contêiner documental, grid, recibo, resultado apresentado
		pela Mesh nem decisão estruturada; nessas a retidão continua absoluta.
		Só na classe declarada a geometria pode suavizar-se, e apenas enquanto a
		suavização comunicar a função de RECEBER expressão humana — é a mesma
		lei operando, porque ali a forma passa a ter função a comunicar. A
		classe é declarada pela Surface Spec, e declará-la é afirmação sujeita
		ao método: superfície declarada sem essa função é arredondamento por
		gosto, que segue proibido. Permanecem explicitamente proibidos card,
		grid, registro, recibo, contêiner documental e controle arredondados;
		arredondamento como identidade global; e a generalização "autoria humana
		⇒ arredondamento" para além desta classe. A Constituição NÃO fixa
		medida: fixa a classe e a função.

		(4) RECLASSIFICAÇÃO DOS 8 TOKENS DEMONSTRADOS SOBRECONGELADOS
		(token-contract). Passam a calibratable, com a moldura constitucional
		escrita em constraints e o valor vigente preservado como registro da
		promulgação: tinta (acromia quase-preta, exclusividade de identidade e
		ação, topo da escala de contraste); campo (superfície de escrita única,
		extremo claro, distinta de pagina em qualquer calibração desta — a
		moldura protege a RELAÇÃO, não um lado); foco (visível, inequívoco,
		afastado, nunca abaixo do piso de acessibilidade); pesos (exatamente
		três, empregos nomeados, piso anti-light); grid (um ritmo espacial
		sistemático com subdivisão restrita ao interior de componentes);
		movimento-elementos (mínima para continuidade perceptiva, nunca sentida
		como espera); movimento-superficie (gesto único, não bloqueante, jamais
		somado à espera de dados); movimento-decaimento-realce (estado
		expirando, decai uma vez, sem repetir nem piscar). Permanecem
		constitution-bound, por não restar valor livre: pressionado, links,
		movimento-easing, movimento-acao-do-usuario e raio.

		(5) UM TOKEN NOVO, ESCOPADO (token-contract).
		raio-expressao-humana nasce calibratable, derivando de layers.form, SEM
		valor promulgado — a moldura é a classe da decisão (3) e o valor vivo é
		calibrado no mesh-frontend-runtime. raio permanece constitution-bound e
		passa a declarar explicitamente seu domínio (toda a geometria
		estrutural) e o ponteiro para a exceção. Nenhum framework, registry,
		camada ou taxonomia nova é criado: um token, dentro do contrato que já
		existia.

		(6) ALINHAMENTO DOS DOIS PONTOS QUE CODIFICAVAM O CRITÉRIO ANTIGO,
		e só eles. tq-dsc-05 (schema) e a section token-and-promulgation do
		production-guide enunciavam literalmente o teste sintático — com
		exemplos que esta emenda torna falsos (tinta e ranges de movimento como
		bound). Ambos passam a APONTAR o critério da seção VII em vez de
		reenunciá-lo com outras palavras (P0: o critério vive uma vez). Nenhuma
		mudança estrutural de schema, nenhum enum novo, nenhum check novo: o
		changeRegime continua sendo o mesmo enum fechado de duas opções.

		(7) O QUE NÃO MUDA. Nenhuma cor, família tipográfica, densidade, medida,
		regra de linguagem, caso canônico ou pendência foi tocada. A
		jurisprudência (VIII) permanece verbatim: nenhum dos 8 casos contradiz a
		emenda — case-tabela-fila cita "peso 500" como ILUSTRAÇÃO de emprego, e
		emprego é justamente o que a moldura de pesos protege. adr-194 NÃO é
		editado (molde adr-178: institui-se sobre a regra citando-a, sem
		reescrever o ADR anterior); a dec 5 dele permanece no registro histórico
		e é REFINADA por esta emenda no ponto exato do critério. As três leis
		geradoras — Atenção, Não-Arbitrariedade, Procedência — e os cinco traços
		de personalidade permanecem intocados: a emenda reforça a
		Não-Arbitrariedade ao exigir causa em vez de posição no texto.
		"""

	consequences: """
		Positivas:
		(P1c) O overfreeze deixa de ser reproduzível: o critério passa a
		perguntar pela causa, então craft que aparecer inline numa camada futura
		não vira lei por acidente de redação. A correção é da definição, não da
		lista — é o que impede a falha de renascer no próximo token.
		(P2c) O founder sai do caminho de calibrações legítimas: recalibrar base
		de grid, numerais de peso, espessura de foco, hex da tinta ou duração de
		movimento dentro da moldura vira commit no runtime. Continua sendo a
		única autoridade de emenda — e agora só é chamado quando a MOLDURA está
		em jogo.
		(P3c) A saída do teste ao sol (pend-01) deixa de esbarrar em token
		bound: foco e tinta eram exatamente a classe de valor que a validação
		empírica pode derrubar, e cuja correção teria exigido ADR.
		(P4c) A cláusula IX ganha a via honesta que faltava: regra derivada
		falsificada por evidência reabre declarando o que aconteceu, sem fingir
		que um princípio superior mudou — e sem abrir porta para preferência,
		porque a via é fechada a invariante, lei transversal e personalidade.
		(P5c) A Surface Spec ganha vocabulário para declarar a classe, e o
		runtime, uma moldura dentro da qual calibrar — sem que a geometria
		estrutural perca um grau de rigidez.

		Negativas:
		(N1) A superfície de julgamento cresce: "resta valor livre?" e "esta
		superfície é primária de expressão humana livre?" são perguntas
		interpretativas, e o gate determinístico não as alcança (P10). Mitigação
		declarada: o teste é escrito com a pergunta causal explícita, os
		exemplos de cada lado ficam no PG, e a classificação permanece advisory
		(tq-dsc-05 warn) sob review do founder — jamais veredito de CI.
		(N2) A classe "superfície primária de expressão humana livre" pode ser
		invocada indevidamente por uma Surface Spec futura para arredondar o que
		não é expressão humana. Mitigação: a emenda enumera nominalmente o que a
		classe NÃO é, declara que declará-la é afirmação sujeita ao método e
		proíbe a generalização "autoria humana ⇒ arredondamento" — mas a
		primeira linha de defesa é review, não gate.
		(N3) Os valores vigentes registrados no contrato viram, para 8 tokens,
		registro histórico em vez de lei — quem ler o contrato sem ler VII pode
		confundir "vigente" com "obrigatório". Mitigado pela nota de emenda na
		promulgationNote e pelo prefixo "Vigente:" em cada constraints, não
		eliminado.
		(N4) Cleanup cross-repo pendente e devido FORA deste commit: o
		mesh-frontend-runtime materializa os valores sob o token-contract e
		ainda não conhece nem a classe nova nem a fronteira moldura/valor; a
		migração vive lá, sob o regime daquele repo (mesmo padrão cross-repo do
		adr-194 dec 6/7). Até que ela ocorra, nenhum valor muda — o runtime
		vigente continua conforme.
		"""

	falsificationCondition: {
		condition:        "Esta emenda estará ERRADA SE (a) a fronteira causal provar-se inoperante — tokens continuarem sendo classificados pela posição do valor no texto, ou calibrações dentro de moldura voltarem a escalar ao founder por medo de fronteira ambígua; OU (b) a segunda via de reabertura for usada para o que ela exclui — mudança em invariante, lei transversal ou personalidade, ou emenda cuja 'evidência' é preferência reembalada; OU (c) a classe da superfície de expressão humana livre vazar — arredondamento aparecendo em registro, recibo, grid, contêiner documental ou controle sob declaração de classe que não descreve a função de receber expressão humana."
		observableSignal: "(a) token novo ou reclassificado cujo constraints justifica o regime citando onde o valor está escrito em vez de qual lei cairia se ele mudasse; ou recalibração de token calibratable escalada ao founder, registrada em sessão. (b) ADR de emenda invocando a via de evidência sobre campo de architectureInvariants, transversalLaws ou personality — visível no diff de architecture/design-system/ pareado ao ADR; ou emenda por evidência sem as quatro declarações exigidas. (c) diff no mesh-frontend-runtime aplicando raio-expressao-humana a superfície fora da classe, ou Surface Spec declarando a classe sem nomear a função de recepção de expressão humana."
	}

	affectedArtifacts: [
		"architecture/design-system/constitution.cue",
		"architecture/design-system/token-contract.cue",
		"architecture/artifact-schemas/design-system-constitution.cue",
		"architecture/production-guides/design-system-constitution.cue",
	]

	plannedOutputs: []

	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	defersTo: []

	supersedes: []

	principlesApplied: [
		"P0 — localização canônica única: o critério de vínculo vive UMA vez (tokenRegime, VII); token-contract, schema e production-guide passam a apontá-lo em vez de reenunciá-lo — a duplicação do critério em três redações diferentes foi exatamente o vetor do drift corrigido aqui.",
		"P10 — gates determinísticos validam, julgamento recomenda: a emenda não cria linter constitucional nem transforma 'resta valor livre?' em gate; cue vet segue validando shape e enum, e a classificação permanece advisory (tq-dsc-05 warn) sob review do founder.",
		"P12 — governança é código: a fronteira lei/moldura/valor vira regime declarado por token e verificável no diff, em vez de disciplina lembrada — quem calibra sabe, pelo próprio contrato, se precisa de ADR.",
		"P14 — invariante expressável em tipo é compile-time: changeRegime e derivesFrom continuam enums fechados; o token novo entra pelo mesmo enum, sem mecanismo paralelo.",
	]

	rationale: """
		Por que (e) entre (a)-(e): (a) e (c) erram em direções opostas — uma
		mantém a lei larga demais, a outra a destrói; (b) corrige a lista e
		deixa a fábrica do erro funcionando; (d) constrói aparato para um
		problema que o campo constraints já resolvia nos tokens calibratable. A
		opção escolhida é a única em que a lei semiótica sai intacta, o craft
		sai livre e nenhuma superfície nova nasce.

		Por que a emenda não é preferência estética: nenhum valor foi escolhido,
		trocado ou recalibrado neste commit — nem hex, nem família, nem
		densidade, nem duração, nem o raio da classe nova, que nasce
		deliberadamente SEM valor. O que mudou foi quem decide cada classe de
		mudança daqui para frente. A prova cega e o red-team entram como
		evidência falsificadora de duas regras DERIVADAS (o critério de
		classificação e o quantificador "em tudo"), não como argumento de gosto;
		e a própria emenda (2) fixa que essa é a única forma admissível de
		usá-los.

		Preservação das leis geradoras. Atenção: intacta — nenhum recurso
		perceptivo novo foi liberado; a suavização admitida na classe nova não
		gasta cor, movimento nem contraste. Não-Arbitrariedade: REFORÇADA — o
		critério antigo permitia que a posição de um literal no texto
		substituísse a cadeia de derivação, que é precisamente a arbitrariedade
		que a seção III existe para eliminar; agora cada regime tem de nomear a
		lei que cairia. Procedência: intacta — os quatro verbos canônicos, as
		quatro naturezas e a distinção preparado/verificado/decidido/registrado
		não foram tocados. Personalidade: intacta — literal, franca, preparada,
		disciplinada, serena seguem sem alteração, e a emenda é literal sobre o
		próprio limite (declara o que não sabe fixar: a medida).

		Risco calibrado. reversibility medium: reverter é reescrever oito campos
		changeRegime, remover um token e três parágrafos — barato no spec, MAS o
		runtime pode já ter calibrado valores sob a moldura nova, e desfazer
		exigiria re-fixar valores vivos; não é o custo de um commit isolado.
		blastRadius cross-cutting: alcança a Constituição, o schema, o PG e toda
		superfície futura governada por eles, sem reescrever mecânica de CI nem
		contratos de domínio — o mesmo alcance do adr-194, que instalou o que
		esta emenda corrige.

		Tensão com axiomas: nenhuma. Lenses: as ~12 lenses de design continuam
		advisory e ineditadas (adr-194 dec 8 permanece vigente); nenhuma foi
		usada como fonte desta emenda — a evidência é experimental, não
		bibliográfica. Precedentes aplicados: adr-178/adr-194 (instituir sobre a
		regra citando-a, sem editar o ADR anterior), adr-193 (missão como
		veículo de execução de decisão do founder — as autorizações D1-D4
		constituem a decisão semântica; esta materialização a executa).
		"""
}
