package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr172: artifact_schemas.#ADR & {
	id:    "adr-172"
	title: "Papéis de participante são POSIÇÕES na relação (originadora/fornecedor por relação), nunca atributo do cadastro"
	date:  "2026-07-12"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	context: """
		A fatia pós-1ª-domain-story ('colocar uma empresa na Mesh para originar
		requisição') levantou a pergunta: o registro do participante (npm) deve
		carregar um TIPO — comprador vs fornecedor? A investigação read-only
		(2026-07-12) mostrou que o disco já responde tacitamente: o npm registra a
		ORGANIZAÇÃO (CNPJ, KYC, lifecycle de 4 estados) sem papel algum; o p2p
		carrega os lados como POSIÇÕES da relação (campo requestedBy — 'Originadora
		— área/função que solicitou demanda' — na emissão de PO; SupplierRefList
		nas decisões); a ACL npm→ssc traduz mudança de
		status para ELEGIBILIDADE de posição ('eligible-for-sourcing'); e o
		participantType do canvas do npm vive apenas em incentiveAnalysis —
		análise de incentivos por posição, não spec operacional. A decisão nunca
		havia sido REGISTRADA — o desenho posicional existia por omissão, e a
		pergunta do founder provou o risco: sem registro, a próxima fatia teria
		materializado um enum de tipo no cadastro, contradizendo o desenho tácito.

		O founder decidiu com caso âncora: uma metalúrgica é COMPRADORA de
		máquinas e FORNECEDORA de metais — o papel depende da posição que a
		empresa ocupa em cada nó da rede, não de quem ela é.
		"""

	decision: """
		(1) Papéis comprador/fornecedor são POSIÇÕES NA RELAÇÃO, nunca atributo
		do participante: a mesma organização é 'originadora' quando demanda
		(p2p) e entra em SupplierRefList quando fornece (ssc). Nenhum gate de
		capacidade por 'tipo' existe ou deve existir — o gate é o lifecycle do
		npm (qualified) mais a elegibilidade contextual da posição (ex.: fitness
		de categoria no ssc).

		(2) npm permanece SoT da ORGANIZAÇÃO (identidade, qualificação KYC/AML,
		lifecycle) e NÃO carrega campo de papel. Qualquer campo futuro
		'participantType'/'roles' no cadastro contradiz esta decisão e exige
		superseder este ADR explicitamente.

		(3) A ACL npm→ssc (evt-network-participant-status-changed-received com
		newEligibility 'eligible-for-sourcing') é PROJEÇÃO DE ELEGIBILIDADE DE
		POSIÇÃO — todo participante qualified é elegível a ocupar a posição de
		fornecedor — e não classificação do participante. Leitura análoga vale
		para projeções futuras de outras posições.

		(4) O participantType em contexts/npm/canvas.cue vive em
		incentiveAnalysis: é análise adversarial POR POSIÇÃO (como cada lado
		trapacearia), não spec de campo. Esta leitura fica canonizada.

		(5) Papéis INTRA-organização permanecem Phase 0 absorbed em sh-01:
		requisitante/comprador per glossário do p2p; gestor-aprovador aparece na
		story (ds-buyer-procurement-journey, passo 9) sem termo de glossário —
		alçada é lacuna conhecida (story ds-buyer-procurement-journey, passo 9;
		def-076 re-autoria do stakeholder-map) e é fatia futura própria, fora
		desta decisão.
		"""

	falsificationCondition: {
		condition:        "Esta decisão estará errada SE um caso real exigir RECUSAR uma ação (originar requisição, entrar em RFQ) com base em 'tipo' cadastral que as posições + lifecycle + elegibilidade contextual não consigam expressar — sinal de que papel-como-atributo carrega informação que posição-na-relação não carrega."
		observableSignal: "Observável na primeira fatia que tentar implementar gate de recusa por papel: se a regra não for expressável como (lifecycle npm) + (elegibilidade da posição no BC da relação), o autor da fatia deve parar e propor supersessão deste ADR com o caso concreto."
	}

	consequences: """
		Positivas: a metalúrgica (e toda empresa de cadeia produtiva) opera nos
		dois lados com UM cadastro — sem dupla entrada, sem enum a migrar; o
		desenho tácito do disco vira lei explícita, bloqueando o drift
		'type-enum no cadastro' que quase nasceu nesta própria fatia; a ACL
		npm→ssc ganha leitura canônica.

		Negativas/custos: gates por papel, se um dia necessários, exigirão
		expressão via posição+elegibilidade (mais desenho que um enum); a
		decisão adiciona um ponto de supersessão obrigatória para quem quiser
		papel-como-atributo — atrito deliberado.
		"""

	affectedArtifacts: [
		"contexts/npm/domain-model.cue",
		"contexts/npm/canvas.cue",
		"contexts/ssc/domain-model.cue",
		"contexts/p2p/domain-model.cue",
	]

	principlesApplied: [
		"P0 — papel-como-atributo duplicaria a verdade posicional (que vive nas relações do p2p/ssc) como campo estático no cadastro: drift por construção; a decisão mantém uma localização canônica por informação.",
		"P10 — o gate de quem-pode-agir permanece determinístico (lifecycle npm + elegibilidade da posição), sem classificação estática paralela.",
		"dp-08/incentiveAnalysis — a análise adversarial por posição do canvas permanece o instrumento correto: incentivos são da posição, não da pessoa jurídica.",
	]

	supersedes: []

	rationale: """
		Registrada porque a ausência de registro quase produziu o artefato
		errado: a fatia 'tipo de participante no npm' foi desenhada, e só a
		pergunta do founder ('já não está definido?') expôs que o disco era
		posicional por omissão. Decisão de leitura barata hoje, cara de
		reverter depois que um enum nascesse e consumidores o referenciassem.
		O caso âncora (metalúrgica compradora de máquinas / fornecedora de
		metais) é a realidade de qualquer cadeia produtiva — o modelo segue a
		rede, não o crachá.
		"""
}
