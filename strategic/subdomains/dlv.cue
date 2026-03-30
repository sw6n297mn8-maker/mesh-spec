package subdomains

// dlv.cue — Delivery & Verification.
// Instância de #Subdomain (architecture/artifact-schemas/subdomain.cue).
//
// Emerge da decomposição de ECL (ADR-032): verificação de execução
// operacional é área de conhecimento com linguagem, profissionais e
// razão de existir próprias — e o diferencial central da tese Mesh.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

dlv: artifact_schemas.#Subdomain & {
	code: "dlv"
	name: "Delivery & Verification"
	type: "core-subdomain"

	definition: """
		Verificação de execução operacional e decisão sobre suficiência
		de evidência para progressão do compromisso econômico. Governa
		medição, inspeção, aceite técnico e a invariante de que nenhum
		compromisso progride para faturamento sem evidência verificada.
		Consome evidência física produzida por LOG e decide se atende
		aos critérios do compromisso formalizado em CMT. Não captura
		evidência física (LOG), não formaliza compromissos (CMT), não
		fatura (INV), não executa pagamentos (FCE), não modela risco
		(REW).
		"""

	purpose: """
		Separar a decisão sobre suficiência de evidência da captura
		de evidência física e da formalização do compromisso. DLV é
		o juiz; LOG é a câmera; CMT é o contrato. Sem DLV como
		unidade separada, a decisão de 'evidência suficiente para
		pagar' ficaria distribuída entre LOG (que captura mas não
		julga) e FCE (que paga mas não verifica) — e a invariante
		central da tese degrada de gate verificável a acordo informal.
		"""

	mechanismRefs: [
		"mech-evidence",
		"mech-agent-gate",
		"mech-three-sots",
	]

	costRefs: [
		"ce-01",
		"ce-04",
	]

	capabilityRefs: [
		"cc-01",
		"cc-04",
	]

	negativeBoundaries: [{
		responsibility: "Captura de evidência operacional física — rastreamento, inspeção, medição de campo, eventos logísticos."
		delegatedTo: {
			type: "subdomain"
			ref:  "log"
		}
		rationale: "DLV decide sobre evidência; LOG a produz. Fusão acoplaria critérios de decisão (que variam por vertical e tipo de compromisso) à infraestrutura de captura (que varia por tecnologia e localização) — dois eixos de evolução independentes."
	}, {
		responsibility: "Formalização de compromissos econômicos — proposta, aceite mútuo."
		delegatedTo: {
			type: "subdomain"
			ref:  "cmt"
		}
		rationale: "DLV verifica contra critérios que CMT formalizou. Separação mantém verificação desacoplada de formalização — o que foi acordado pode mudar sem alterar como se verifica, e vice-versa."
	}, {
		responsibility: "Faturamento — emissão de NF-e, materialização do direito creditório."
		delegatedTo: {
			type: "subdomain"
			ref:  "inv"
		}
		rationale: "Verificação aprovada é pré-condição para faturamento, mas faturamento tem regulação fiscal própria. DLV produz o sinal; INV materializa o direito."
	}, {
		responsibility: "Execução financeira — pagamentos, settlement."
		delegatedTo: {
			type: "subdomain"
			ref:  "fce"
		}
		rationale: "DLV comprova que operação aconteceu e foi aceita; FCE move dinheiro. Separação é a invariante central da tese: dinheiro só move quando operação comprova."
	}, {
		responsibility: "Precificação de risco — políticas de crédito, elegibilidade."
		delegatedTo: {
			type: "subdomain"
			ref:  "rew"
		}
		rationale: "DLV produz sinais de qualidade de execução que REW consome para scoring, mas não modela nem executa políticas de risco."
	}, {
		responsibility: "Contestação de verificação — disputas sobre medição, inspeção ou aceite técnico."
		delegatedTo: {
			type: "subdomain"
			ref:  "drc"
		}
		rationale: "Contestação de verificação (ex: fornecedor disputa medição) tem lifecycle de exceção com prazos, evidência adicional e resolução. Fusão misturaria fluxo normal de verificação com fluxo de exceção."
	}]

	strategicProfile: {
		complexity: "high"
		volatility: "high"
		rationale: """
			Complexidade alta: critérios de verificação variam
			radicalmente por vertical (medição de obra em construção
			civil ≠ confirmação de entrega em logística ≠ inspeção
			de equipamento em energia), cada um com regras, tolerâncias
			e profissionais especializados. Volatilidade alta: cada
			industry pack expande tipos de verificação, e avanços
			tecnológicos (IoT, visão computacional, sensores) alteram
			a fronteira do que é verificável automaticamente.
			"""
	}

	rationale: """
		DLV é core porque a decisão de suficiência de evidência é o
		diferencial central da tese — é o que torna recebíveis da Mesh
		mais confiáveis que recebíveis tradicionais. Não é terceirizável
		porque os critérios de verificação são proprietários e evoluem
		com dados acumulados pela rede. Contribui diretamente para
		mech-evidence (cada verificação é fato registrado com integridade
		criptográfica), mech-agent-gate (gates de aceite técnico são
		determinísticos) e mech-three-sots (verificações são registradas
		no Event Log). Elimina ce-01 (verificação presencial repetitiva
		substituída por evidência criptograficamente verificável). Contribui
		para eliminação de ce-04 (custo de risco com dados incompletos —
		DLV produz dados completos de execução verificada que REW consome
		para scoring mais preciso). Habilita cc-01 (liberação financeira
		vinculada a evidência em tempo real) e cc-04 (auditoria contínua
		da cadeia de evidência).
		"""
}
