package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

itc: artifact_schemas.#Subdomain & {
	code: "itc"
	name: "International Trade & Customs"
	type: "supporting-subdomain"

	definition: """
		Operações de comércio exterior decorrentes de compromissos
		econômicos inter-organizacionais: freight forwarding,
		despacho aduaneiro, documentação de comex e compliance
		aduaneiro. Governa o regime regulatório distinto que
		operações internacionais impõem sobre compromissos,
		logística e repercussão fiscal. Produz dados de comex
		consumíveis por ATO, LOG e FCE. A execução internacional
		depende de condições regulatórias e operacionais e não
		é garantida pela existência do compromisso. Não formaliza
		compromissos (CMT), não executa pagamento (FCE), não
		gerencia logística doméstica (LOG), não apura impostos
		domésticos (ATO).
		"""

	purpose: """
		Separar o regime de comércio exterior do ciclo doméstico.
		ITC tem linguagem própria (BL, AWB, DI, Incoterms,
		NCM, despacho), profissionais próprios (despachantes,
		freight forwarders, agentes de carga) e regime
		regulatório independente (legislação aduaneira, Siscomex,
		câmbio). Sem ITC como unidade separada, regras de comex
		contaminariam ATO e LOG com branching condicional em
		todo fluxo — overload conceitual que degrada ambos os
		domínios.
		"""

	negativeBoundaries: [{
		responsibility: "Formalização de compromissos econômicos — proposta, aceite mútuo, estado do compromisso."
		delegatedTo: {
			type: "subdomain"
			ref:  "cmt"
		}
		rationale: "ITC opera sobre compromissos já formalizados que envolvem componente internacional. CMT formaliza; ITC adiciona a camada de comex."
	}, {
		responsibility: "Execução financeira — pagamentos, settlement, câmbio operacional."
		delegatedTo: {
			type: "subdomain"
			ref:  "fce"
		}
		rationale: "ITC produz dados que afetam o fluxo financeiro (câmbio, impostos de importação); FCE executa. ITC não movimenta dinheiro."
	}, {
		responsibility: "Logística doméstica — rastreamento de carga, entrega, evidência operacional no território nacional."
		delegatedTo: {
			type: "subdomain"
			ref:  "log"
		}
		rationale: "ITC governa o trecho internacional e aduaneiro; LOG governa logística doméstica. O handoff ocorre no desembaraço. Fusão misturaria regimes regulatórios distintos."
	}, {
		responsibility: "Apuração fiscal doméstica — impostos internos, obrigações acessórias, reporting contábil."
		delegatedTo: {
			type: "subdomain"
			ref:  "ato"
		}
		rationale: "ITC produz fatos geradores de comex (II, IPI importação, ICMS-ST importação); ATO apura e contabiliza. ITC é fato gerador; ATO é repercussão fiscal."
	}]

	rationale: """
		ITC é supporting porque comércio exterior segue padrões
		regulatórios externos (Siscomex, Incoterms, legislação
		aduaneira) — não proprietário. Não é generic porque
		operações de comex na Mesh alteram a estrutura do
		compromisso (Incoterms mudam responsabilidades),
		afetam pricing de risco em REW e geram repercussão
		fiscal específica consumida por ATO. Comex não é
		variação do doméstico — é outro sistema.
		"""
}
