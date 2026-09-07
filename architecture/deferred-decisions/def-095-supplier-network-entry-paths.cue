package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def095: artifact_schemas.#DeferredDecision & {
	id:     "def-095"
	title:  "Caminhos de entrada do fornecedor na rede — a story descreve um, o sistema sustenta outro, e a qualificação por categoria não existe"
	date:   "2026-09-07"
	status: "open"

	description: """
		A ENTRADA do fornecedor na rede tem vários caminhos legítimos, e a
		ds-buyer-procurement-journey descreve UM deles como se fosse o
		único. O passo 4 narra o comprador que 'verifica quais fornecedores
		homologados atendem a categoria; não havendo homologado, busca
		novos parceiros no mercado e aciona sua qualificação' — a
		compradora puxando. O sistema executa o oposto: o auto-registro do
		fornecedor. Fica deferida a ESCOLHA de quais caminhos o produto
		tem; não a modelagem de nenhum deles.

		OS CAMINHOS NOMEADOS, com o que o modelo sustenta de cada um
		(medido no CUE em 2026-09-07; lista é ponto de partida do founder,
		não fechada):
		(1) O FORNECEDOR CHEGA SOZINHO — cadastra-se e submete documentos.
		SUSTENTADO: cmd-register-participant é autônomo ('validação de
		completude cadastral é determinística') e cmd-submit-qualification-
		documents tem binding org == participantId. É o único caminho que
		o sistema executa hoje, e é o que a story NÃO descreve.
		(2) A COMPRADORA PUXA — a compradora indica a empresa e o sistema
		vai atrás. NÃO SUSTENTADO: nenhum comando registra participante em
		nome de terceiro; cmd-register-participant não tem campo de quem
		registra. É o que a story descreve.
		(3) O CONVITE ARRASTA — convidar para uma cotação alguém ainda não
		qualificado, e o convite vira o gatilho da entrada. CONTRA-
		INVARIANTE: inv-qualification-as-absolute-precondition diz 'nenhum
		fornecedor entra em RFQ sem status eligible-for-sourcing em NPM', e
		o glossário do ssc reforça 'cadastrados não-qualificados não entram
		em RFQ'. Este caminho não é lacuna — é proibição vigente; abri-lo
		muda contrato.
		(4) A REDE PROPÕE — o sistema sugere quem deveria estar na
		categoria, por histórico ou adjacência. AUSENTE: nenhum comando,
		evento ou projection de sugestão de participante.
		(5) ALGUÉM DE DENTRO TRAZ — indicação de fornecedor já qualificado
		como sinal. AUSENTE: não há referral, indicação ou sponsor no npm.

		A PERGUNTA QUE ATRAVESSA TODOS — entrar na rede e estar qualificado
		numa categoria são o mesmo estado? A medição responde em dois
		eixos, e eles não têm o mesmo estado de maturidade:
		- CADASTRO ↔ QUALIFICAÇÃO: JÁ DISTINGUIDOS. O npm tem lifecycle de
		4 estados (pending, qualified, suspended, terminated) e o glossário
		do ssc nomeia a distinção: 'Cadastro é registro inicial em NPM
		(status pending). Qualificado é status pós-aprovação KYC/AML'.
		- QUALIFICAÇÃO ↔ CATEGORIA: NÃO EXISTE. categoryRef não aparece uma
		única vez em contexts/npm/domain-model.cue; o 'qualified' é global.
		A lacuna já está registrada no ponto de uso (domain-model do ssc:
		'NPM qualification por categoria + restrictions + expirationDate,
		shape em oq-ssc-6') e observada em execução (o dev serve do
		mesh-runtime anuncia o pool como 'category-agnostic Phase 0').
		É o segundo eixo que abre o caminho a mais que o founder
		antecipou — entrar rápido, qualificar depois, com o portão duro
		onde precisa ser.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: o que falta não é modelagem, é ESCOLHA de
		produto. Modelar cinco entradas antes de saber quais o negócio quer
		construiria quatro fluxos mortos; e o caminho (3) exige mudança de
		invariante vigente, que é decisão de contrato, não de tela. Custo
		evitado: cinco desenhos sobre uma pergunta de estratégia ainda não
		respondida.

		CUSTO DE CONTINUAR DEFERINDO — cada caminho é uma tela ou fluxo
		DIFERENTE, e o primeiro construído fecha a porta dos outros. Uma
		tela de auto-registro e uma tela de indicação pela compradora não
		são a mesma tela com um campo a mais: mudam quem age, o que se
		pede, e onde o portão de KYC/AML incide. Nomear os caminhos agora
		não escolhe nenhum — impede que a escolha aconteça por acidente, na
		primeira tela que alguém desenhar.

		POR QUE high, e não medium: numa rede B2B a entrada é o gargalo do
		crescimento — a Mesh precisa de fornecedores DENTRO antes de
		qualquer compra acontecer. O contra-argumento honesto ('nada quebra
		enquanto se adia') é incompleto na leitura do founder: nada quebra
		porque nada está entrando; a ausência de fornecedores não é dívida
		acumulando, é o produto não funcionando. A medição reforça — o
		único caminho sustentado é o que ninguém desenhou, e a única
		narrativa que existe descreve um caminho que o sistema não executa.

		PRECEDENTE DE FORMA, citado: o rationale do passo 7 da
		ds-buyer-procurement-journey registra que a lacuna do agente foi
		descoberta 'por divergência entre dois artefatos de protótipo, cada
		um fiel a um lado — a story era a fonte de ambos e não decidia
		entre eles'. Aqui é a mesma forma com o instrumento trocado: a
		divergência não é entre dois protótipos, é entre a STORY e o
		SISTEMA EM EXECUÇÃO, e quem a expôs foi a travessia pela borda do
		dev serve, não um artefato de design. O que a story descreve e o
		que o serve executa discordam, e nenhum dos dois é errado — são
		dois caminhos legítimos, e falta a decisão de quais existem.

		O QUE ESTE DEF NÃO FAZ: não escolhe caminho, não modela entrada,
		não emenda o passo 4 da story. A emenda espera a decisão do
		founder sobre quais caminhos o produto tem — a story não pode ser
		corrigida para 'o caminho certo' enquanto houver mais de um.
		"""

	triggerCalibrationRationale: """
		Dois triggers de naturezas complementares. O manual-review carrega
		o sinal REAL — a escolha das portas é decisão de produto do
		founder, não fato de disco; nenhum predicado a antecipa. O
		adjacent-need sobre categoryRef no domain-model do npm é
		machine-evaluable e cobre o eixo que MUDA O TERRITÓRIO: se a
		qualificação por categoria nascer (oq-ssc-6 resolvida), o caminho
		'entra rápido, qualifica depois' deixa de ser hipótese e o def
		precisa ser revisitado com o mapa novo. Não é o gatilho da decisão
		— é o gatilho da reavaliação do que está em jogo.
		"""

	originatingArtifacts: [
		"strategic/domain-stories/buyer-procurement-journey.cue",
		"contexts/npm/domain-model.cue",
		"session:reconhecimento-travessia-borda",
	]

	costOfDeferral: {
		severity:    "high"
		blastRadius: "cross-cutting"
		description: """
			high por calibração do founder: a entrada é o gargalo do
			crescimento da rede, e adiar não acumula dívida — mantém o
			produto sem povoar. Numa rede B2B, sem fornecedores dentro
			nenhuma compra acontece; o custo do adiamento é a cunha não
			entrando no mercado, não retrabalho futuro. cross-cutting
			porque toca npm (os estados e quem age), ssc (o pool e a
			invariante que barra o caminho 3), a ds-buyer-procurement-
			journey (o passo 4, que descreve um caminho como único) e a
			ds-supplier-network-journey (cujo primeiro passo muda de ator
			conforme a escolha). Exit: a decisão do founder sobre quais
			caminhos o produto tem, seguida da emenda do passo 4 e da
			modelagem de cada caminho escolhido.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "O sinal real é a decisão de produto do founder sobre quais portas de entrada existem — escolha estratégica sobre gargalo de crescimento, não fato observável em disco; nenhum predicado antecipa qual caminho o negócio quer."
	}, {
		kind: "adjacent-need"
		condition: {
			kind:    "file-contains"
			path:    "contexts/npm/domain-model.cue"
			pattern: "categoryRef"
		}
	}]
}
