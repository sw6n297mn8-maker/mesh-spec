package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

tcm: artifact_schemas.#Subdomain & {
	code: "tcm"
	name: "Treasury & Cash Management"
	type: "supporting-subdomain"

	definition: """
		Tesouraria corporativa informada pelos compromissos
		econômicos sob governança da rede: posição de caixa,
		projeção de fluxo, estratégia de liquidez e exposição
		cambial. Consolida, para cada organização participante,
		a visão de suas obrigações e direitos financeiros
		decorrentes de compromissos sob governança. Produz
		dados de posição e projeção de liquidez consumíveis
		por FCE e REW. A projeção de fluxo reflete compromissos
		sob governança e não constitui garantia de realização
		financeira. A posição de caixa e projeções dependem de
		eventos de execução e podem divergir do realizado. Não
		executa pagamentos (FCE), não origina crédito (SCF),
		não precifica risco (REW), não formaliza compromissos
		(CMT).
		"""

	purpose: """
		Separar visão de tesouraria da execução financeira e
		da originação de crédito. TCM tem linguagem própria
		(posição de caixa, cash forecast, liquidez, hedge),
		profissionais próprios (tesoureiros, controllers) e
		cadência de evolução independente (ciclos de projeção
		diários/semanais vs execução transacional). Sem TCM
		como unidade separada, cada liquidação em FCE seria
		evento isolado sem visão de posição corporativa.
		"""

	negativeBoundaries: [{
		responsibility: "Execução financeira — pagamentos, settlement, liberação de retenções."
		delegatedTo: {
			type: "subdomain"
			ref:  "fce"
		}
		rationale: "TCM projeta e planeja; FCE executa. Projeção de fluxo é prospectiva; pagamento é efetivo. Fusão misturaria planejamento com execução — cadências e responsabilidades distintas."
	}, {
		responsibility: "Originação de produtos financeiros — antecipação, reverse factoring, capital de giro."
		delegatedTo: {
			type: "subdomain"
			ref:  "scf"
		}
		rationale: "TCM informa posição de liquidez; SCF origina produtos. TCM diz quanto há disponível; SCF decide o que fazer com o disponível."
	}, {
		responsibility: "Precificação de risco — políticas de crédito, limites, condições financeiras."
		delegatedTo: {
			type: "subdomain"
			ref:  "rew"
		}
		rationale: "TCM fornece dados de exposição e liquidez como input de risco; REW modela e precifica. TCM é dado observado; REW é modelo aplicado."
	}, {
		responsibility: "Formalização de compromissos econômicos — proposta, aceite mútuo, estado do compromisso."
		delegatedTo: {
			type: "subdomain"
			ref:  "cmt"
		}
		rationale: "TCM consome compromissos formalizados como input de projeção; CMT formaliza. TCM não cria obrigações — observa e projeta as existentes."
	}, {
		responsibility: "Controle orçamentário — comprometimento por centro de custo, alçadas de aprovação, cobertura orçamentária."
		delegatedTo: {
			type: "subdomain"
			ref:  "bdg"
		}
		rationale: "TCM observa posição de caixa e projeta fluxo; BDG controla comprometimento orçamentário e aprova alocações. Caixa e orçamento são visões complementares — uma empresa pode ter orçamento sem caixa ou caixa sem orçamento."
	}]

	rationale: """
		TCM é supporting porque tesouraria corporativa é domínio
		com padrões estabelecidos (cash management, forecasting,
		hedge) — não proprietário. O valor proprietário da Mesh
		está nos compromissos sob governança que alimentam TCM
		com dados de qualidade superior a ERPs isolados. Não é
		generic porque a projeção na Mesh consome dados de
		compromissos verificados e evidência operacional — não
		estimativas manuais — e retroalimenta decisões de
		liquidez em FCE e risco em REW.
		"""
}
