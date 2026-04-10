package subdomains

// cmt.cue — Commitment Management.
// Instância de #Subdomain (architecture/artifact-schemas/subdomain.cue).
//
// Emerge da decomposição de ECL (ADR-032): formalização e aceite mútuo
// de compromissos econômicos é área de conhecimento com linguagem,
// regras e razão de existir próprias — passa no teste DDD.

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

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
	}, {
		responsibility: "Ciclo de demanda e procurement — requisição interna, aprovação, emissão de pedido de compra."
		delegatedTo: {
			type: "subdomain"
			ref:  "p2p"
		}
		rationale: "CMT formaliza compromissos econômicos bilaterais; P2P governa o ciclo de demanda que origina pedidos de compra. Pedido de compra é sinal de demanda unilateral; compromisso exige aceite mútuo."
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

	verticalApplicability: shared_types.#VerticalApplicability & {
		mode: "vertical-agnostic"
		rationale: """
			A definição estratégica do CMT — formalização, aceite
			mútuo e gestão de estado de compromissos econômicos entre
			organizações em redes produtivas — é vocabulário universal
			de teoria dos contratos B2B. Purpose, negativeBoundaries
			(8 delegações para subdomains pares: CTR, DLV, INV, FCE,
			BDG, REW, DRC, P2P), mechanismRefs (mech-agent-gate,
			mech-evidence), costRefs (ce-02) e capabilityRefs (cc-04)
			são todos definidos em termos canônicos do
			domain-definition, sem invocar vocabulário ou premissa
			setorial.

			A única menção a vertical específica vive em
			strategicProfile.rationale e é descritiva, não anchoring:
			"regras de formalização que variam por vertical (construção
			vs logística vs energia)" reconhece o landscape
			cross-vertical sem eleger primário, e "medição por
			milestone, aceite parcial, entregas programadas" enumera
			tipos de compromisso que industry packs absorvem — frame
			explícito de extensão externa, não de embedding interno.

			A frase decisiva é "cada industry pack expande tipos de
			compromisso e padrões de formalização": o subdomain
			declara sua estratégia de variação como extensão via
			industry packs, deliberadamente preservando o núcleo
			universal. Isso é consistente com classificação como
			vertical-agnostic: núcleo estável no subdomain, com
			variação tratada como extensão externa via industry packs.

			Observação cross-plane: cmt-canvas (commit 717644f) foi
			classificado como vertical-adaptable / construction porque
			instancia premissas operacionais que carregam a vertical
			de origem (as-cmt-1 escopa sincronia do aceite à
			construção, as-cmt-3 embute "medição" como vocabulário
			de obra na premissa de hierarquia, oq-cmt-2 admite que a
			invariante pode não generalizar, e sh-01 é "Construtora").
			A divergência entre os dois planos é uma observação
			estruturalmente significativa neste primeiro par analisado:
			a variação por vertical aparece no plano operacional
			(canvas), não no plano de fronteira estratégica (subdomain).
			O subdomain define a fronteira universal; o canvas
			materializa a primeira instanciação ancorada em uma
			vertical concreta. Hipótese de pesquisa para pares
			subsequentes (ctr, idc, npm, p2p), ainda sem massa
			empírica suficiente para registro como tensão.
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
