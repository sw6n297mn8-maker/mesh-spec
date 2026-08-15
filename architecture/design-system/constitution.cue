package design_system

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// constitution.cue — Constituição do Design System Mesh (adr-194).
//
// Fonte: Constituição fornecida pelo founder na autorização da missão
// M7.5 (sessão 2026-08-14). Versão 1.0 · julho/2026 · documento
// canônico. Status: camadas I–VI congeladas · pendências registradas
// ao final. PRESERVAÇÃO É LEI: o texto promulgado está transcrito
// integralmente; a estruturação em campos é forma, nunca reescrita.
//
// Este arquivo carrega: preâmbulo, seções I-V, camadas VI.1-VI.6,
// regime de tokens (VII), cláusula de proteção (IX) e pendências.
// A jurisprudência (VIII) vive em canonical-cases.cue; o contrato de
// tokens (valores promulgados de VII) em token-contract.cue. Os três
// arquivos compõem UMA instância por merge de structs CUE.
//
// VERSÃO 1.1 (adr-195): três emendas mínimas, cada uma marcada no
// texto pelo prefixo "Emenda 1.1 —" e apensada ao campo que já é o
// lar canônico da regra corrigida — o texto promulgado v1.0 permanece
// byte a byte acima de cada emenda (PRESERVAÇÃO É LEI). São elas: o
// critério de vínculo dos tokens (tokenRegime, VII), a segunda via de
// reabertura por evidência (protectionClause, IX) e o domínio do
// quantificador da geometria (layers.form, VI.4). Nenhuma outra
// camada, trade-off, caso limite ou pendência foi tocada.

designSystemConstitution: artifact_schemas.#DesignSystemConstitution & {
	id:      "design-system-constitution"
	version: "1.1"
	status:  "layers-i-vi-frozen"

	preamble: """
		Preâmbulo — as três leis geradoras. Quase todas as decisões concretas deste
		sistema podem ser deduzidas de três leis mais a personalidade: a Lei da Atenção
		(o recurso perceptivo escasso é reservado ao que realmente importa), o Princípio
		da Não Arbitrariedade (toda decisão deriva de uma camada superior ou do melhor
		craft conhecido) e o Regime de Procedência (toda informação declara sua natureza
		e sua origem). Este documento não acumula regras; gera regras. Essa propriedade é o
		que ele protege.
		"""

	thesis: """
		Dinheiro e operação são indissociáveis: compromissos econômicos nascem, se provam e
		se liquidam num plano único.

		Corolário de design: a forma como a Mesh fala é consequência da forma como ela
		opera. Nada muda de estado por afirmação — só por prova. Nem na plataforma, nem
		na interface.
		"""

	architectureInvariants: [
		"Evidência criptograficamente verificável: o dinheiro só se move quando o fato operacional está provado.",
		"Agentes de IA operam sob portões determinísticos; regras explícitas valem acima do julgamento da máquina.",
		"Fontes de verdade imutáveis: nada se edita retroativamente; correções são novos eventos; qualquer estado é reconstruível.",
		"Agentes nunca alteram estado; apenas preparam estados candidatos.",
		"Humanos decidem por exceção e alçada, com contexto completo diante de si.",
		"Onde o sistema não verifica algo, declara o limite em vez de fingir garantia.",
	]

	architectureInvariantsNote: """
		Não há cor nem UI neste nível. Só ontologia. É daqui que tudo deriva — e é o teste
		de reabertura de tudo: propor mudança em qualquer camada exige apontar qual
		invariante mudou.
		"""

	excellenceStandard: {
		principle: """
			A Mesh não transmite luxo; transmite maestria: qualidade percebida como
			ausência de arbitrariedade. Nada existe para impressionar, por tradição, por
			preferência pessoal ou por moda. Cada detalhe permanece apenas enquanto for a
			melhor solução conhecida para o problema.
			"""
		operationalTest: """
			Teste operacional (o critério é a cadeia, nunca a sensação). Uma decisão é
			não-arbitrária quando:
			(a) cita o princípio de que deriva;
			(b) mudá-la exigiria mudar algo acima dela;
			(c) o trade-off que paga foi nomeado.

			A sensação "era assim que precisava ser" é o efeito esperado quando os três valem —
			pertence à família de confiança e autoridade: merecida, nunca reivindicada, nunca
			usada como argumento.
			"""
		craftClause: """
			Cláusula de craft: este padrão raciona ênfase, não qualidade. O
			alinhamento exato, a proporção certa, o kern bem feito não gastam atenção de
			ninguém e permanecem ilimitados e obrigatórios. O sistema impede a Mesh de gritar;
			não a autoriza a ser malfeita em silêncio.
			"""
	}

	personality: {
		traits: [{
			axis:    "Como fala"
			trait:   "Literal"
			antonym: "somos literais, não persuasivos"
			statute: "escolhido"
		}, {
			axis:    "Como fala"
			trait:   "Franca"
			antonym: "somos francos, não tranquilizadores — literais também sobre os próprios limites"
			statute: "escolhido"
		}, {
			axis:    "Como opera"
			trait:   "Preparada"
			antonym: "somos preparados, não performáticos"
			statute: "escolhido"
		}, {
			axis:    "Como opera"
			trait:   "Disciplinada"
			antonym: "somos disciplinados, não espertos"
			statute: "escolhido"
		}, {
			axis:    "Como é percebida"
			trait:   "Serena"
			antonym: "somos serenos, não alarmistas — nunca surpreendida pela própria operação"
			statute: "prometido"
		}]
		statutes: """
			Derivada da arquitetura, não inventada.

			Estatutos: os quatro primeiros são escolhidos (derivam um-a-um de invariantes);
			serena é prometida (emergente na origem, vinculante na prática). Efeitos
			esperados, nunca reivindicados nem decididos — apenas merecidos: confiança,
			autoridade, segurança. Sustentação: consequente (propriedade do sistema, não
			personalidade).
			"""
		causalFlow: """
			Fluxo causal: Arquitetura → Personalidade → Percepção → Reputação.
			A personalidade só se reabre se a arquitetura se reabrir.
			"""
	}

	transversalLaws: {
		attention: """
			A atenção do usuário é o recurso mais escasso que a Mesh administra. Os recursos
			perceptivos fortes — cor, movimento, contraste, ênfase — são a moeda com que se
			paga por ela, e só podem ser gastos em duas coisas: o que mudou e o que
			espera decisão humana. Identidade, decoração e dramatização não têm orçamento.
			Um sistema que já trabalhou por você não precisa gritar; precisa apontar.
			"""
		provenance: {
			statement: """
				Toda informação na Mesh tem origem, e a origem determina como ela deve ser
				tratada. A interface não comunica inteligência; comunica procedência.

				Quatro naturezas de informação, quatro verbos canônicos (natures).
				"""
			natures: [{
				nature:   "Decisão humana"
				verb:     "decidido"
				produces: "compromisso"
			}, {
				nature:   "Sistema determinístico"
				verb:     "verificado"
				produces: "estado, a partir de regras e provas"
			}, {
				nature:   "Agente"
				verb:     "preparado"
				produces: "trabalho preparado — nunca estado"
			}, {
				nature:   "Evidência externa"
				verb:     "registrado"
				produces: "fatos (documentos, pagamentos, certidões, APIs oficiais)"
			}]
			absolutePrinciple: """
				Princípio absoluto: nenhum agente altera o estado da plataforma. Agentes
				preparam estados candidatos. Estados só nascem por prova, regra determinística ou
				decisão humana.
				"""
			fourQuestionsTest: """
				Teste das quatro perguntas — qualquer elemento da interface responde sem
				ambiguidade: (1) Quem o produziu? (2) Quem responde por ele neste momento?
				(3) Ele ainda pode ser revisado? (4) Ele altera o estado da plataforma ou apenas
				prepara uma possível alteração?
				"""
		}
	}

	layersIntro: """
		Estrutura uniforme: problema · decisão-raiz · decisões derivadas · trade-offs ·
		teste dos cinco · casos limite. Tokens consolidados na seção VII.
		"""

	layers: {
		// ── VI.1 Cor ──
		color: {
			problem: """
				Num sistema onde cores carregam significado operacional, identidade
				e informação disputariam o mesmo canal.
				"""
			rootDecision: """
				Na Mesh, identidade não pode disputar atenção com significado.
				A cor da marca é preto no branco — #141414 sobre o papel — a tinta de
				registro: em português, "preto no branco" é o nome popular do compromisso provado
				e inegável, que é o que a Mesh produz. A cor da marca não ilustra a tese; ela a
				repete. A tinta é a única cor com direito a identidade e ação; as cores cromáticas
				pertencem aos fatos, não à marca.
				"""
			derivedPrinciples: """
				1. Cor nunca decora; cor sempre significa. Colorir sem afirmar é mentir de leve.
				2. Acende só o que espera decisão humana. A raridade da cor é a fonte da força.
				3. Urgência por hierarquia, nunca por tom — jamais pulsação, saturação extra ou
				   volume emocional.
				"""
			surfaceNorm: """
				Superfície (norma). A superfície da Mesh não representa uma tela. Representa
				um suporte permanente para registros importantes. O off-white existe para retirar
				protagonismo da interface e conferir à informação a dignidade material de um
				documento construído para durar. A superfície deve desaparecer. Nada de textura,
				ruído ou grão — a qualidade do suporte se manifesta por tom, não por efeito.
				O branco puro ganha emprego: superfície de escrita (campos de entrada).
				"""
			derivedDecisions: """
				Vermelho desdobrado: erro do sistema (vivo) ≠ desfecho
				negativo legítimo (quieto) — rejeição é o sistema funcionando, não falhando.
				Borda em dois empregos: funcional (contraste ≥3:1) e estrutural (decorativa).
				Estados do domínio: escalada é o único estado que acende (é o único que significa
				"agora é com você"); aprovada/convertida verdes quietas; rejeitada
				vermelho-quieto; cancelada cinza riscada; submetida/triada neutras. Links: tinta
				sublinhada — sublinhado só existe para isso. Um botão de tinta cheia por contexto
				de decisão. Foco visível: contorno 2px afastado. Proibido: sombra, gradiente,
				elevação, dark mode por iniciativa própria.
				"""
			tradeoffs: """
				Trade-offs nomeados. O marketing não tem "a cor da marca" para outdoor — tem a
				postura, a tinta e a malha (caminho Bloomberg). Telas menos "vivas" em screenshot.
				Off-white paga fração de brilho no pior sol (valor exato ajustável pelo teste de
				campo, sem reabrir a norma).
				"""
			testOfFive: """
				Literal: cor afirma fatos. Franca: limites com tratamento
				próprio (tracejado). Preparada: o que o sistema resolveu descansa. Disciplinada:
				paleta mínima com empregos fixos. Serena: tela quase sem cor não grita.
				"""
			edgeCases: """
				Dataviz (cores de gráfico): adiado até o registro escritório
				ganhar analytics. Palco (site, deck): herda a identidade; pode usar tinta em
				áreas grandes; nunca sequestra cores semânticas para decoração.
				"""
		}

		// ── VI.2 Tipografia ──
		typography: {
			problem: """
				A tinta precisa de uma letra que sirva a três materiais distintos —
				prosa, números financeiros e evidência — sem virar estética.
				"""
			rootDecision: """
				Ênfase tipográfica é gasto sob a Lei da Atenção: peso marca
				o que mudou ou espera decisão; tamanho marca hierarquia de informação;
				nada marca tom emocional. Números são fatos: exatos, alinhados, nunca
				estilizados.
				"""
			voices: """
				Três vozes, uma família.
				- Texto — proporcional: frases, rótulos, decisões.
				- Dados — dígitos tabulares: todo número, em qualquer contexto (números
				  proporcionais fazem a tela dançar ao atualizar — movimento acidental).
				- Evidência — monoespaçada: exclusivamente o que o sistema garante ou identifica
				  (IDs, procedências, hashes, carimbos). Proibida em prosa: se vazar, virou tema
				  de terminal.
				"""
			family: """
				IBM Plex Sans + IBM Plex Mono — titular, validada em teste cego de
				identidade; escolha declarada entre finalistas equivalentes (não inevitável),
				reversível por um token. Reservas qualificadas: Atkinson Hyperlegible Next + Mono
				(assume se o campo derrotar a Plex em legibilidade — venceu o ranking de operação
				crítica no teste cego); Mona Sans (se o caráter pedir revisão; tabulares a
				verificar). Validação final: produto real, ao sol.
				"""
			derivedDecisions: """
				Nenhum número nu, sem exceção: todo valor carrega unidade
				por valor (R$ 45.000,00 com espaço inseparável, 500 sacos, 2 t, 40 m³), símbolo
				na mesma cor e peso do número. Dinheiro nunca abreviado na operação ("45k" só no
				palco), nunca inflado — valor só ganha peso quando é ele que mudou ou decide.
				Colunas numéricas à direita, vírgulas empilhadas. Sentence case em tudo; caixa-alta
				derrubada por completo, inclusive micro-rótulos (alternativa sem exceção existe:
				peso 500, cor meta). Desfechos: peso 600 + primeira posição + prova campo a campo
				— firmeza sem grito. Light banido: morre ao sol.
				"""
			tradeoffs: """
				Plex paga um ponto de legibilidade vs. Inter em tamanho mínimo
				(coberto pelos pisos generosos). Strings longas custam densidade em dashboards.
				Links sublinhados são menos "elegantes" que coloridos — em troca, clicabilidade
				nunca é ambígua.
				"""
			testOfFive: """
				Literal: números exatos, mono só para o garantido. Franca:
				trade-offs declarados, escolha da família assumida como juízo. Preparada: nada
				performa. Disciplinada: três pesos, cinco tamanhos, réguas anti-abuso escritas.
				Serena: sem grito, sem inflação de dinheiro.
				"""
			edgeCases: """
				Tamanhos display e letra do logotipo: palco, outra fase.
				Hierarquia tipográfica de dataviz: junto com as cores de gráfico.
				"""
		}

		// ── VI.3 Movimento ──
		motion: {
			law: """
				A Mesh nunca usa movimento para persuadir. Usa movimento apenas para
				preservar continuidade e tornar mudanças observáveis.
				"""
			admissionTest: """
				O teste de admissão (decide qualquer caso): se o elemento se teletransportasse,
				o usuário perderia o fio — ou nem notaria que o sistema agiu? Se nenhum dos dois,
				não anima.
				"""
			jurisprudence: """
				Algo se move apenas para (a) tornar visível uma ação do
				sistema ou (b) preservar a orientação do usuário quando o layout muda — nunca para
				enfatizar, deleitar ou dramatizar esforço. Tempo mínimo para continuidade
				perceptiva: ease-out, chegada firme, sem bounce, 120–200ms para elementos;
				superfície inteira admite um único gesto de assentamento de até 240ms, não
				bloqueante, jamais somado à espera de dados. Ações do usuário respondem com início
				instantâneo — a transição é consequência, nunca espera.

				Chegada: o estado nasce completo — a realidade já existe quando aparece; a UI a
				revela, não a cria. Informação nunca é revelada em sequência para criar
				expectativa. Progressão admitida apenas como caso de (b), para estruturas grandes,
				sob o mesmo teste. Invariante: o que exige decisão humana é visível desde o
				primeiro frame.

				O que o sistema fez na ausência do usuário se mostra por estado marcado —
				contagem, carimbos, realce de novidade que decai, recibo a um clique — nunca por
				replay. Reproduzir a "mágica" depois do processamento é mentira visual. O
				movimento pode dizer "isto mudou"; nunca pode encenar "veja-me trabalhando".
				Exceção de duração: o decaimento de realce é estado expirando, não transição —
				admite 1–3s, decai uma única vez, sem repetir nem piscar.
				"""
			twoWorlds: """
				Dois mundos, separação arquitetural. O palco (demo, marketing, onboarding,
				primeira execução) admite narrativa e sequência — sob o mesmo tom emocional da
				marca: o palco conta histórias, não solta confete. A operação (trabalho diário,
				auditoria, decisão, aprovação, dinheiro) é território de assentamento, sem exceção.
				"""
			rewardAnnex: """
				Anexo — recompensa. A Mesh nunca fabrica recompensa; revela consequência.
				Zero gamificação, confete, celebração ou estímulo simbólico sobre o ato de usar o
				software. A motivação legítima é fato real apresentado com sobriedade: score,
				reputação, crédito, histórico.
				"""
		}

		// ── VI.4 Forma e Corpo ──
		form: {
			rootDecision: """
				Na Mesh, forma nunca comunica afeto. Cantos arredondados
				comunicam aproximação e consumo; a Mesh comunica precisão, estabilidade e
				permanência. Raio zero em tudo — o documento é consequência, não causa.

				Emenda 1.1 — domínio do quantificador (reaberta por evidência, cláusula IX).
				A lei permanece inteira: forma comunica função, nunca afeto; a expressão
				estrutural da Mesh comunica precisão, estabilidade, permanência e disciplina;
				arredondamento não é estilo, identidade nem amabilidade. O que se corrige é
				o alcance de "em tudo". A evidência: uma prova cega da Superfície de Entrada
				derivou uma classe que a regra nunca considerou — a superfície primária de
				expressão humana livre, o campo onde a pessoa compõe, com suas palavras,
				aquilo que ainda não é dado do sistema. Ela não é registro, evidência,
				atributo estruturado, contêiner documental, grid, recibo, resultado
				apresentado pela Mesh nem decisão estruturada — e nessas a retidão continua
				absoluta, sem exceção. Só na classe declarada a geometria pode suavizar-se, e
				apenas enquanto a suavização comunicar a função de receber expressão humana:
				é a mesma lei operando, porque ali a forma passa a ter função a comunicar.
				A classe é declarada pela Surface Spec, e declará-la é afirmação sujeita ao
				método — superfície declarada sem essa função é arredondamento por gosto, que
				segue proibido. Permanecem proibidos: card, grid, registro, recibo, contêiner
				documental e controle arredondados; arredondamento como identidade global; e
				generalizar "autoria humana ⇒ arredondamento" para além desta classe, que
				exigiria emenda própria. A Constituição fixa a classe e a função; a medida
				concreta é calibrada no runtime dentro desta moldura.
				"""
			compositionUnit: """
				Unidade de composição. A unidade primária da Mesh é a página, não o card.
				Cards existem apenas quando representam uma entidade independente — nunca como
				solução padrão para organizar conteúdo. Seções separam-se por hierarquia
				tipográfica, respiro e filetes. Moldura é afirmação: borda ao redor de algo
				declara "isto é um objeto do sistema" (um compromisso, um recibo, um bloco de
				agente, um aviso de limite). Caixa decorativa de agrupamento é proibida — a
				Gestalt agrupa por proximidade e alinhamento de graça.
				"""
			derivedDecisions: """
				Grid 8pt, meio-passo de 4 só dentro de componentes
				(convenção adotada por Padrão de Excelência: não há vantagem em reinventá-la).
				Cada componente comunica sua função por um único mecanismo visual dominante —
				nunca borda E preenchimento. Quatro empregos de contorno e só quatro: funcional
				(onde se age) · moldura (objeto de primeira classe) · tracejada (limite
				declarado) · filete (separação mínima). Nenhuma decisão antecede sua prova:
				a ação primária vem depois do contexto completo na ordem de leitura; no canteiro
				pode ancorar fixa na base da tela (estrutura previsível) — botão flutuando sobre
				conteúdo segue proibido: flutuar sobre a prova é cobrir a evidência com o pedido
				de assinatura. Densidade em dois tokens nomeados: canteiro (folgado, alvos 48px+)
				e escritório (denso, linhas ~32px). Flat absoluto.
				"""
			icons: """
				Ícones. Sólidos, geométricos, simples, pouquíssimos — e nunca significam
				sozinhos: aceleram localização, reforçam estrutura, diferenciam categorias;
				jamais substituem linguagem. Todo ícone com rótulo no contexto ou governado por
				cabeçalho. Um ícone sem rótulo é um símbolo nu — a versão gráfica do número sem
				unidade. (Base: Yablonski, Tidwell, Rosenfeld, Saffer; a escolha por sólidos é
				cadeia própria: traço fino morre ao sol como a fonte light; carimbo, não desenho.)
				"""
			tradeoffs: """
				Severidade: abre-se mão por completo da amabilidade visual.
				Documento contínuo exige disciplina tipográfica maior — sem caixas, erro de
				espaçamento fica nu. Dois modos de densidade custam manutenção.
				"""
			testOfFive: """
				Literal: nada finge tridimensionalidade. Franca: gramática de
				contorno declarada. Preparada: prova antes da decisão. Disciplinada: grid e
				mecanismo único. Serena: uma tela que pede uma coisa.
				"""
		}

		// ── VI.5 Linguagem ──
		language: {
			rootDecision: """
				A voz escrita obedece à personalidade sem mediação: cada frase
				é literal, franca, preparada, disciplinada e serena — ou é reescrita.
				"""
			rules: """
				- Desfechos afirmativos completos, seguidos da prova campo a campo: "Pedido
				  P-1204 emitido." + recibo. Nunca "sucesso!" genérico.
				- Erros nomeiam o campo exato e o escopo: "CNPJ do fornecedor: dígito verificador
				  inválido. Os demais 11 campos estão corretos."
				- Limites declarados em voz alta: "A Mesh verificou X. Não verificou Y —
				  declarado pelo fornecedor."
				- Verbos de procedência canônicos: decidido, verificado, preparado, registrado.
				- Urgência por conteúdo e prazo, nunca por tom: "Decisão requerida até 28/07
				  18:00" — jamais "URGENTE!".
				- Zero emoji, celebração, jargão de startup, "bem-vindo ao futuro", hedging vazio
				  ou pedido de confiança.
				- Sentence case em tudo; jargão técnico não vaza em rótulos de operação.
				"""
		}

		// ── VI.6 Procedência e Assinatura (gramática visual do Regime V.2) ──
		provenance: {
			naturesMapping: """
				Mapeamento das quatro naturezas.

				Decidido (humano): Tinta plena; desfecho peso 600; assinatura nominal + carimbo
				em mono (J. Costa · 25/07 14:35).
				Verificado (regra): Gates literais: ✓ verde-quieto / ◌ marrom, sempre com a
				regra nomeada e o valor.
				Preparado (agente): Fundo-apoio + rótulo "Preparado pela Mesh • capacidade" +
				porquê a um toque.
				Registrado (evidência): Voz mono + cor de recibo: IDs, NF-e, hashes, carimbos.
				"""
			agentSignatureRules: """
				Regras da assinatura de agente.
				1. Toda preparação declara procedência enquanto pendente. A assinatura identifica
				   a capacidade responsável (Qualificação, Financeiro, Compliance), não o modelo.
				   Quando o humano confirma, a assinatura sai da interface operacional — o dado
				   virou compromisso dele. Na auditoria, a procedência permanece para sempre:
				   a autoria nunca é apagada; a responsabilidade muda.
				2. Escopo mínimo: a assinatura aparece no menor nível que agrega informação nova
				   — uma vez por seção homogênea, nunca por campo repetido.
				3. Toda preparação apresenta sua base — a menor evidência suficiente. Critérios
				   listados sem marca de verificação (✓ é exclusivo de provas e gates); os
				   números carregam a força: "menor custo médio entre 3 cotações · SLA 96,3% vs.
				   91,0%". Árvores de decisão e pesos internos pertencem ao relatório de
				   auditoria.
				4. O agente nunca possui voz: não persuade, não alerta com drama, não pede
				   confiança. A diferença entre verificado, preparado e decidido é
				   epistemológica, nunca emocional.
				5. Sem espetáculo: atividade automática aparece por estado ("14 verificações
				   concluídas"), nunca por replay, animação ou "IA analisando…". O trabalho já
				   chegou pronto.
				6. A decisão humana encerra a preparação. O agente não insiste nem reapresenta.
				   Fatos novos geram nova preparação — nunca reabertura da anterior.
				7. Divergências são eventos do processo, sem drama: "14:32 Mesh preparou
				   fornecedor A · 14:35 Responsável selecionou fornecedor B". Distinção de
				   governança: preparação não adotada ≠ preparação incorreta. O slot de motivo
				   existe no design; sua obrigatoriedade é política de alçada, não interface.
				8. Duas classes de preparação: para decisão (exige confirmação humana) e
				   operacional (OCR, normalização, indexação — executa sob regras determinísticas,
				   invisível na operação, integralmente auditável).
				"""
		}
	}

	tokenRegime: """
		Tokens são as decisões de menor ordem do sistema: os valores exatos que
		implementam as camadas dentro dos limites que elas fixam. Ajustá-los dentro da
		moldura (ex.: calibrar o off-white pelo teste ao sol) é manutenção — commit, não
		emenda. Alterá-los contra uma camada (ex.: um raio diferente de zero) é
		impossível sem emenda à camada, via ADR. Nenhum valor entra sem referência à
		decisão que o autoriza. Esta é também a única forma da lei que o código consegue
		obedecer diretamente: é aqui que a Constituição vira lint, tema e gate.

		Emenda 1.1 — critério de vínculo. O que decide o regime de um token é a causa,
		não o lugar onde o valor foi escrito. Um token é constitution-bound somente
		quando não resta valor livre a calibrar: quando ele expressa uma relação, um
		caráter ou uma proibição cuja alteração, por si, muda significado, identidade,
		distinção semântica ou personalidade. Quando a camada fixa uma moldura e ainda
		resta valor livre dentro dela, o token é calibratable — e então a moldura (o
		piso, o teto, a relação, o emprego, a condição) é a lei, vive no contrato e é
		o que a emenda protege; o valor vigente vive no runtime. Um valor não vira lei
		por ter aparecido literalmente no texto promulgado: a pergunta é qual lei
		superior deixaria de valer se ele mudasse; se nenhuma, o valor é craft, e craft
		calibra. Recalibrar dentro da moldura segue sendo manutenção; estreitar,
		alargar ou remover a moldura é emenda.
		"""

	protectionClause: {
		method: """
			Nenhuma decisão entra no Design System apenas porque funciona ou porque é comum.
			Toda decisão permanente deve declarar explicitamente sua cadeia de derivação, seus
			trade-offs e as condições sob as quais deixaria de ser válida.
			"""
		reopeningComplement: """
			Complemento de reabertura: propor mudança a uma decisão congelada exige apontar
			qual elo superior mudou — invariante de arquitetura, personalidade ou lei
			transversal. Sem elo mudado, não há reabertura; há preferência, e preferência não
			legisla.

			Emenda 1.1 — segunda via: reabertura por evidência. Elo superior mudado é uma
			via; evidência nova é a outra. Uma regra DERIVADA — nunca um invariante de
			arquitetura, uma lei transversal ou a personalidade, que só se reabrem pela
			primeira via — também se reabre quando evidência nova demonstra que ela foi
			falsificada, que seu domínio é mais amplo que o do princípio que ela pretendia
			materializar, ou que existe classe real que ela nunca considerou. Reabrir por
			esta via NÃO afirma que o princípio superior mudou: afirma que a derivação
			era mais larga que ele, e a correção é estreitá-la de volta ao princípio.
			A evidência é proporcional à profundidade da regra e verificável por terceiro
			— gosto, moda e conveniência não são evidência, e esta via não existe para
			eles. A emenda por evidência declara quatro coisas, sob pena de ser
			preferência disfarçada de método: qual evidência apareceu; qual regra derivada
			foi atingida; qual parte da lei superior permanece intacta; e qual é a menor
			correção que restaura a derivação. Esta via não relaxa o método — é o método
			aplicado ao caso em que a regra, e não o princípio, era o erro.
			"""
		warning: """
			Se um dia esta cláusula deixar de ser obedecida, o Design System pode continuar
			parecendo o mesmo por um tempo, mas terá perdido a propriedade que o tornou
			coerente: a capacidade de explicar por que cada pixel existe.
			"""
	}

	pendencias: [{
		id:             "pend-01"
		title:          "Teste ao sol"
		classification: "empirical-calibration"
		content: """
			Off-white #faf8f4 (ajuste de valor, não de norma) e validação de campo da
			IBM Plex; celular, canteiro, meio-dia.

			Classificação: obrigação de validação empírica — a própria norma declara "valor
			exato ajustável pelo teste de campo, sem reabrir a norma" (VI.1 trade-offs) e
			"Validação final: produto real, ao sol" (VI.2 família). A saída do teste ajusta
			VALOR dentro da moldura (manutenção, commit no runtime), nunca norma — não é
			deferimento de decisão, é dívida de calibração.
			"""
	}, {
		id:             "pend-02"
		title:          "Dataviz"
		classification: "deferred-decision"
		content: """
			Cores e tipografia de gráficos, quando o registro escritório ganhar analytics.

			Classificação: decisão futura com trigger real (o registro escritório ganhar
			analytics), governada NO próprio artefato — SEM def formal (adr-194 dec 10).
			Porquê: dataviz é camada futura da PRÓPRIA Constituição, não decisão fora dela —
			quando nascer, nasce como emenda/extensão sob o método (problema · decisão-raiz ·
			trade-offs · teste dos cinco) e sob a cláusula IX, via ADR — exatamente o veículo
			que um def apontaria; o def adicionaria fila, não governança. O gatilho é fato de
			produto fora do disco (invisível ao runner — mesma lição de def-066/067/068).
			"""
	}, {
		id:             "pend-03"
		title:          "Palco"
		classification: "deferred-decision"
		content: """
			Site, deck, letra do logotipo; herda a identidade, decide-se pós-produto.

			Classificação: decisão futura com trigger real (pós-produto), governada NO
			próprio artefato — SEM def formal (adr-194 dec 10). Porquê: o palco herda a
			identidade já decidida (VI.1 casos limite: "herda a identidade; pode usar tinta
			em áreas grandes; nunca sequestra cores semânticas para decoração"; VI.3 dois
			mundos) — o que falta é a APLICAÇÃO da identidade a uma superfície que ainda não
			existe, camada futura da própria Constituição, que nascerá como extensão sob a
			cláusula IX via ADR. O gatilho é fato de produto fora do disco.
			"""
	}, {
		id:             "pend-04"
		title:          "Mona Sans"
		classification: "reserve-condition"
		content: """
			Verificação de dígitos tabulares, apenas se a reserva for convocada.

			Classificação: condição de reserva, não decisão pendente — a titular está
			decidida (IBM Plex, VI.2 família) e Mona Sans é reserva qualificada que só entra
			em avaliação "se o caráter pedir revisão" (condição de convocação declarada na
			própria camada). Nada a decidir enquanto a condição não dispara.
			"""
	}, {
		id:             "pend-05"
		title:          "Obrigatoriedade do motivo em divergências"
		classification: "out-of-scope-governance"
		pointer:        "Governança de alçada por organização (política futura, fora do design; slot de motivo já existe no design — VI.6 regra 7)"
		content: """
			Obrigatoriedade do motivo em divergências — política de alçada por
			organização (governança, não design).

			Classificação: a própria Constituição a classifica como política de alçada, fora
			do design (VI.6 regra 7: "O slot de motivo existe no design; sua obrigatoriedade
			é política de alçada, não interface"). O design entregou o slot; a
			obrigatoriedade pertence à governança de alçada por organização.
			"""
	}]

	rationale: """
		Canonização da Constituição do Design System como artefato de primeira classe
		(adr-194). Fonte: documento fornecido pelo founder na autorização da missão M7.5
		(sessão 2026-08-14) — Versão 1.0, promulgada em julho/2026 como documento canônico,
		com camadas I–VI congeladas e pendências registradas ao final; conteúdo preservado
		integralmente (nenhuma lei, trade-off, caso limite, personalidade, jurisprudência,
		pendência, cláusula de reabertura, significado de token ou distinção
		preparado/verificado/decidido/registrado foi removida ou 'melhorada'). A Constituição
		preenche o escopo declarado-ausente do N1 do adr-150 (design system visual: tokens,
		tipografia, marca): adr-150 legisla o COMPORTAMENTO AI-first; esta Constituição, a
		manifestação visual, linguística e epistemológica dele. A seção II deriva dos
		invariantes do sistema (P3 imutabilidade, P10 gates, P11 evidência) sem duplicá-los.

		v1.1 (adr-195): três emendas mínimas, nenhuma nascida de preferência estética —
		o critério de vínculo dos tokens passa a ser causal em vez de textual (VII), a
		reabertura ganha a via da evidência para regra derivada larga demais (IX) e o
		quantificador universal da geometria cede à única classe que a prova cega revelou
		(VI.4). Cada emenda vive no campo que já era o lar canônico da regra corrigida;
		o texto promulgado v1.0 permanece integral acima dela.
		"""
}
