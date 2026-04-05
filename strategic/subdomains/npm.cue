package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

npm: artifact_schemas.#Subdomain & {
	code: "npm"
	name: "Network Participant Management"
	type: "supporting-subdomain"

	definition: """
		Qualificação, homologação e gestão do ciclo de vida de
		participantes na rede. Governa verificação documental,
		elegibilidade (IQF), status transitions e compliance de
		onboarding. Produz o estado canônico de elegibilidade que
		outros subdomínios consomem como pré-condição. Não computa
		reputação (NIM), não precifica risco (REW), não detecta
		contrapartes externas (NGR).
		"""

	purpose: """
		Separar compliance de qualificação de participantes das
		decisões que consomem essa qualificação. Sem NPM como
		unidade separada, cada subdomínio consumidor (REW, NIM,
		NGR) implementaria verificação documental internamente —
		duplicação com cadências de evolução distintas (compliance
		muda por regulação, não por produto).
		"""

	negativeBoundaries: [{
		responsibility: "Computação de reputação — scoring comportamental, matching, ranking."
		delegatedTo: {
			type: "subdomain"
			ref:  "nim"
		}
		rationale: "NPM qualifica; NIM computa reputação. Qualificação é binária (elegível/inelegível) baseada em documentação; reputação é contínua baseada em comportamento observado — modelos e cadências distintos."
	}, {
		responsibility: "Precificação de risco — políticas de crédito, limites, condições financeiras."
		delegatedTo: {
			type: "subdomain"
			ref:  "rew"
		}
		rationale: "NPM produz elegibilidade como input de risco, não a decisão de risco. Fusão misturaria compliance documental com modelagem financeira — stakeholders e regulação diferentes."
	}, {
		responsibility: "Detecção e ativação de contrapartes externas — funil de conversão."
		delegatedTo: {
			type: "subdomain"
			ref:  "ngr"
		}
		rationale: "NPM qualifica quem já pediu entrada; NGR detecta e convida quem ainda não pediu. Fusão misturaria compliance (otimizar segurança) com growth (otimizar conversão) — incentivos opostos."
	}, {
		responsibility: "Ciclo de demanda-a-pedido — requisição, aprovação por alçada, composição de demanda, emissão de pedido de compra."
		delegatedTo: {
			type: "subdomain"
			ref:  "p2p"
		}
		rationale: "NPM qualifica participantes para a rede; P2P governa o ciclo de procurement. Qualificação é pré-condição para participar; procurement é o que o participante faz uma vez qualificado."
	}, {
		responsibility: "Seleção estratégica de fornecedores — avaliação comparativa, negociação de termos indicativos, decisão de sourcing."
		delegatedTo: {
			type: "subdomain"
			ref:  "ssc"
		}
		rationale: "NPM qualifica binariamente (elegível/inelegível); SSC seleciona estrategicamente entre qualificados. Qualificação e seleção têm critérios, profissionais e cadências distintos."
	}]

	rationale: """
		NPM é o gatekeeper da rede — nenhum participante opera sem
		qualificação completa. Supporting porque o processo de
		qualificação é compliance-driven e regulatoriamente
		determinado, não proprietário. Contribui para a tese ao
		garantir que apenas participantes verificados geram dados
		que alimentam o flywheel informacional.
		"""
}
