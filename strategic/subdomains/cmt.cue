package subdomains

// cmt.cue — Commitment Management.
// Instância de #Subdomain (architecture/artifact-schemas/subdomain.cue).
//
// Emerge da decomposição de ECL (ADR-032): formalização e aceite mútuo
// de compromissos econômicos é área de conhecimento com linguagem,
// regras e razão de existir próprias — passa no teste DDD.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

cmt: artifact_schemas.#Subdomain & {
	code: "cmt"
	name: "Commitment Management"
	type: "core-subdomain"

	definition: """
		Formalização, aceite mútuo e gestão do estado de compromissos
		econômicos entre organizações em redes produtivas. Governa a
		criação do compromisso (proposta, negociação, confirmação
		bilateral), as invariantes de aceite mútuo, e o estado canônico
		do compromisso como entidade rastreável. CommitmentId nasce aqui
		e permeia todos os contexts downstream. Não executa pagamentos
		(FCE), não verifica execução operacional (DLV), não fatura (INV),
		não formaliza termos contratuais genéricos (CTR), não aprova
		orçamento (BDG), não avalia risco (REW).
		"""

	purpose: """
		Separar a formalização de compromissos econômicos — área de
		conhecimento com linguagem, regras e razão de existir próprias —
		da verificação de execução, do faturamento e da liquidação
		financeira. Sem CMT como unidade separada, a criação e o aceite
		de compromissos ficam distribuídos entre contratos (CTR) e
		execução financeira (FCE) sem owner canônico do estado do
		compromisso. CMT garante que todo compromisso na rede tenha
		autor, contraparte, termos e confirmação bilateral antes de
		qualquer progressão downstream.
		"""

	mechanismRefs: [
		"mech-agent-gate",
		"mech-evidence",
	]

	costRefs: [
		"ce-02",
	]

	capabilityRefs: [
		"cc-04",
	]

	negativeBoundaries: [{
		responsibility: "Formalização de termos contratuais genéricos — cláusulas, SLA, retenção, garantias."
		delegatedTo: {
			type: "subdomain"
			ref:  "ctr"
		}
		rationale: "CMT instancia compromissos sob termos que CTR define. Fusão acoplaria evolução de cláusulas contratuais à evolução de formalização de compromissos — cadências distintas."
	}, {
		responsibility: "Verificação de execução operacional — medição, inspeção, aceite técnico."
		delegatedTo: {
			type: "subdomain"
			ref:  "dlv"
		}
		rationale: "CMT formaliza o que foi acordado; DLV verifica o que foi executado. Fusão misturaria formalização (pre-execution) com verificação (execution) — profissionais, dados e regras distintos."
	}, {
		responsibility: "Faturamento — emissão de NF-e, materialização do direito creditório."
		delegatedTo: {
			type: "subdomain"
			ref:  "inv"
		}
		rationale: "Compromisso formalizado é pré-condição para faturamento, mas faturamento tem regulação fiscal própria (NF-e, SEFAZ). Cadências de evolução independentes."
	}, {
		responsibility: "Execução financeira — pagamentos, settlement, budget allocation."
		delegatedTo: {
			type: "subdomain"
			ref:  "fce"
		}
		rationale: "CMT formaliza o compromisso; FCE move dinheiro quando as condições são satisfeitas. Fusão acoplaria formalização à execução financeira — dois domínios com regulação e profissionais distintos."
	}, {
		responsibility: "Aprovação orçamentária — comprometimento, centros de custo, limites."
		delegatedTo: {
			type: "subdomain"
			ref:  "bdg"
		}
		rationale: "CMT formaliza o compromisso; BDG verifica se há orçamento para honrá-lo. Separação permite que controle orçamentário evolua independente da formalização."
	}, {
		responsibility: "Precificação de risco e elegibilidade — políticas de crédito, limites, avaliação de contraparte."
		delegatedTo: {
			type: "subdomain"
			ref:  "rew"
		}
		rationale: "CMT registra o compromisso; REW avalia se as partes e condições são elegíveis financeiramente. Risco e formalização evoluem por drivers distintos (mercado/regulação vs produto/vertical)."
	}, {
		responsibility: "Disputas e reversões — contestações sobre aceite, penalidades, estornos."
		delegatedTo: {
			type: "subdomain"
			ref:  "drc"
		}
		rationale: "Disputas sobre formalização (ex: contraparte contesta aceite) têm lifecycle próprio com prazos, evidência e resolução. Fusão misturaria fluxo normal com fluxo de exceção."
	}]

	strategicProfile: {
		complexity: "high"
		volatility: "high"
		rationale: """
			Complexidade alta: aceite mútuo envolve múltiplas partes com
			informação assimétrica, regras de formalização que variam por
			vertical (construção vs logística vs energia), e invariantes
			de integridade que condicionam toda a cadeia downstream.
			Volatilidade alta: cada industry pack expande tipos de
			compromisso (medição por milestone, aceite parcial, entregas
			programadas) e padrões de formalização.
			"""
	}

	rationale: """
		CMT é core porque a formalização de compromissos econômicos com
		aceite mútuo e rastreabilidade é proprietária da Mesh — não
		existe padrão de mercado para compromissos bilaterais vinculados
		a evidência operacional. CommitmentId é o conceito cross-cutting
		mais referenciado do sistema. CMT é o ponto de entrada do
		commitment lifecycle e determina a qualidade de tudo que vem
		depois: compromisso mal formalizado degrada verificação,
		faturamento e liquidação. Contribui para mech-agent-gate (gates
		de aceite são determinísticos) e mech-evidence (aceite bilateral
		é registrado como fato com integridade criptográfica via CAS/DSSE
		— o primeiro elo da cadeia de evidência). Elimina ce-02 (custo de
		compliance documental — agentes processam formalização
		automaticamente com gates determinísticos). Habilita cc-04
		(auditoria contínua — cada compromisso é rastreável desde a
		formalização).
		"""
}
