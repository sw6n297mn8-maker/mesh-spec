package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ins: artifact_schemas.#Subdomain & {
	code: "ins"
	name: "Insurance & Risk Transfer"
	type: "supporting-subdomain"

	definition: """
		Proteção e transferência de risco associadas a
		compromissos econômicos inter-organizacionais mediante
		instrumentos emitidos por seguradoras e garantidoras
		externas: seguro garantia, seguro de carga, performance
		bonds e demais instrumentos de transferência de risco.
		Gerencia a vinculação entre instrumentos de proteção e
		os compromissos que protegem. Produz dados de cobertura
		e exposição consumíveis por REW e SCF. A existência
		de instrumento de proteção não elimina o risco
		subjacente nem garante indenização automática. A
		vinculação de instrumentos de proteção não condiciona
		a existência ou execução do compromisso. Não precifica
		risco (REW), não origina crédito (SCF), não formaliza
		compromissos (CMT), não formaliza contratos (CTR).
		"""

	purpose: """
		Separar instrumentos de proteção de risco da
		precificação de risco e da originação de crédito.
		INS tem linguagem própria (apólice, sinistro,
		prêmio, franquia, endosso, cobertura), profissionais
		próprios (corretores, subscritores, peritos) e regime
		regulatório independente (SUSEP, IRB). Sem INS como
		unidade separada, seguros ficariam diluídos entre
		REW e CTR — sem owner canônico da cobertura e
		deixando o modelo de risco incompleto.
		"""

	negativeBoundaries: [{
		responsibility: "Precificação de risco — políticas de crédito, limites, condições financeiras, elegibilidade."
		delegatedTo: {
			type: "subdomain"
			ref:  "rew"
		}
		rationale: "INS fornece dados de cobertura como input de risco; REW consome para ajustar pricing. INS diz o que está protegido; REW decide quanto isso vale em termos de risco residual."
	}, {
		responsibility: "Originação de produtos financeiros — antecipação, reverse factoring, capital de giro."
		delegatedTo: {
			type: "subdomain"
			ref:  "scf"
		}
		rationale: "INS afeta elegibilidade e condições de crédito via cobertura; SCF origina o produto. Seguro melhora o perfil do ativo; SCF monetiza o ativo."
	}, {
		responsibility: "Formalização de compromissos econômicos — proposta, aceite mútuo, estado do compromisso."
		delegatedTo: {
			type: "subdomain"
			ref:  "cmt"
		}
		rationale: "INS protege compromissos já formalizados ou em formalização; CMT formaliza. Proteção é camada sobre o compromisso, não parte da formalização."
	}, {
		responsibility: "Formalização contratual — contratos, cláusulas, SLAs, termos jurídicos."
		delegatedTo: {
			type: "subdomain"
			ref:  "ctr"
		}
		rationale: "INS gerencia instrumentos de proteção (apólices, bonds); CTR gerencia contratos comerciais. Apólice não é cláusula contratual — é instrumento jurídico independente emitido por seguradora."
	}, {
		responsibility: "Emissão, subscrição e intermediação de seguros — underwriting, precificação de prêmio, corretagem, regulação de sinistro."
		delegatedTo: {
			type: "external-system"
			ref:  "ext-insurers"
		}
		rationale: "INS gerencia dados de cobertura e vinculação a compromissos; seguradoras e corretoras emitem, subscrevem e intermediam. A Mesh não é seguradora nem corretora de seguros — não tem licença SUSEP, não assume risco atuarial nem intermedia comercialmente produtos de seguro."
	}]

	rationale: """
		INS é supporting porque seguros e instrumentos de
		proteção seguem padrões regulatórios externos (SUSEP,
		IRB, mercado segurador) — não proprietário. Não é
		generic porque instrumentos de proteção na Mesh afetam
		diretamente pricing de crédito em REW, elegibilidade
		em SCF e exposição em TCM — excluí-los deixa o modelo
		de risco incompleto e o pricing de crédito impreciso.
		"""
}
