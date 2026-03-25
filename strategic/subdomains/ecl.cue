package subdomains

// ecl.cue — Economic Commitment Lifecycle.
// Instância de #Subdomain (architecture/artifact-schemas/subdomain.cue).
//
// Validação:
//   cue vet ./strategic/subdomains/ecl.cue ./architecture/artifact-schemas/subdomain.cue

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ecl: artifact_schemas.#Subdomain & {
	code:   "ecl"
	name:   "Economic Commitment Lifecycle"
	type: "core-subdomain"

	definition: """
		Ciclo de vida completo do compromisso econômico entre organizações em
		redes produtivas — da formalização à liquidação. Cobre a progressão do
		compromisso econômico por fases (execução, medição, aceite), as
		invariantes que vinculam operação a finanças, e as pré-condições que
		determinam quando o compromisso econômico pode avançar entre fases.
		"""

	purpose: """
		Garantir que todo compromisso econômico na rede tenha um estado canônico
		único, governado por invariantes explícitas e rastreável desde a
		formalização até a liquidação. Sem ECL como unidade separada, o estado
		do compromisso econômico fica distribuído entre execução financeira,
		logística e contratos sem owner — e a invariante central da tese
		(nenhum fluxo financeiro existe sem evento operacional verificado)
		degrada de regra enforçada a acordo informal.
		"""

	mechanismRefs: [
		"mech-evidence",
		"mech-agent-gate",
		"mech-three-sots",
		"mech-network",
	]

	costRefs: [
		"ce-01", // Custo de verificação de execução para liberação financeira
		"ce-03", // Custo de reconciliação financeira multi-sistema
		"ce-04", // Custo de avaliação de risco com dados incompletos
	]

	capabilityRefs: [
		"cc-01", // Liberação financeira vinculada a evidência de execução
		"cc-02", // Scoring de risco baseado em dados operacionais verificados
		"cc-04", // Auditoria contínua e automatizada
	]

	negativeBoundaries: [{
		responsibility: "Formalização contratual — contratos, pedidos de compra, ordens de serviço, cláusulas de retenção e requisitos de garantias."
		delegatedTo: {
			type: "subdomain"
			ref:  "ctr"
		}
		rationale: "Formalização contratual e lifecycle do compromisso econômico têm cadências de evolução e donos distintos. Fusão forçaria o lifecycle a absorver a complexidade de cláusulas, SLAs e compliance contratual — domínio com regras e vocabulário próprios."
	}, {
		responsibility: "Execução financeira — orquestração de quando e por que dinheiro se move, incluindo budget, pagamento e liquidação."
		delegatedTo: {
			type: "subdomain"
			ref:  "fce"
		}
		rationale: "ECL decide quando transições do compromisso econômico são válidas; FCE decide quando dinheiro se move. A invariante de fusão é compartilhada, mas o enforcement é separado: ECL governa estado, FCE governa fluxo de caixa."
	}, {
		responsibility: "Precificação de risco — modelagem, políticas de elegibilidade financeira, pricing e monitoramento de risco ao longo do ciclo."
		delegatedTo: {
			type: "subdomain"
			ref:  "rew"
		}
		rationale: "ECL produz os eventos que REW consome como sinais de risco, mas não modela nem executa políticas de risco. Internalizar risco no lifecycle acoplaria evolução de produtos financeiros à evolução do compromisso econômico."
	}, {
		responsibility: "Evidência operacional física — rastreamento de carga, entrega, inspeção de qualidade e eventos logísticos."
		delegatedTo: {
			type: "subdomain"
			ref:  "log"
		}
		rationale: "Fusão forçaria ECL a governar tanto a progressão do compromisso econômico quanto a cadeia de custódia de evidência física — dois domínios com complexidade, vocabulário e cadência de evolução distintos. ECL consome evidência como pré-condição de progresso; LOG a produz e garante integridade."
	}, {
		responsibility: "Orquestração de reversões — disputas, contestações, não conformidades, penalidades e estornos."
		delegatedTo: {
			type: "subdomain"
			ref:  "drc"
		}
		rationale: "Disputas afetam o compromisso econômico mas têm lifecycle próprio (alegação, evidência, resolução, impacto econômico). Internalizar reversões inflaria o escopo e misturaria fluxo normal com fluxo de exceção."
	}, {
		responsibility: "Originação de produtos financeiros — antecipação de recebíveis, reverse factoring, dynamic discounting e capital de giro."
		delegatedTo: {
			type: "subdomain"
			ref:  "scf"
		}
		rationale: "ECL produz o recebível operacional como instrumento derivado do ciclo; SCF origina produtos financeiros sobre esse instrumento. Separação permite novos produtos financeiros sem modificar o lifecycle do compromisso econômico."
	}, {
		responsibility: "Computação de reputação e inteligência de rede — scoring, matching, ranking, incentivos e recomendações."
		delegatedTo: {
			type: "subdomain"
			ref:  "nim"
		}
		rationale: "Reputação é produto emergente do histórico de compromissos econômicos, não fase do lifecycle. Fusão acoplaria a cadência de evolução do scoring (novos sinais, novos modelos) à cadência do lifecycle (novas fases, novos industry packs) — dois eixos de mudança independentes."
	}]

	strategicProfile: {
		complexity: "high"
		volatility: "high"
		rationale: """
			Complexidade alta: o compromisso econômico atravessa múltiplas fases
			(formalização, execução, medição, aceite, liquidação), cada uma com
			invariantes próprias; a invariante de fusão operação-finanças
			condiciona todos os subdomínios downstream; e execução, medição e
			aceite são fases internas do lifecycle — não domínios separados —
			porque fragmentá-las gera overlap de responsabilidade e ausência
			de owner canônico do estado. Volatilidade alta: evolui com cada
			industry pack (construção civil → logística → energia), com
			expansão de fases (aceite parcial, medição por milestone) e com
			novos padrões de compromisso econômico que o mercado exigir.
			"""
	}

	rationale: """
		ECL é o hub central do grafo de dependência da Mesh — CommitmentId
		permeia todos os subdomínios ativos. Separação como core subdomain
		justificada por: (1) governa a invariante de fusão que é a tese central
		da Mesh — dinheiro só se move quando operação comprova (mech-evidence /
		P11), com gates determinísticos garantindo que agentes não ultrapassem
		essa fronteira (mech-agent-gate / P10); (2) não é terceirizável nem
		padronizável porque o lifecycle é proprietário e evolui com o negócio;
		(3) execução, medição e aceite como fases internas eliminam overlap e
		estabelecem ownership canônico do estado do compromisso econômico.
		Contribui para o moat de dados (cada transação gera evidência
		operacional proprietária) e para dois resultados de negócio: crédito
		mais barato (recebíveis lastreados em eventos verificados) e governança
		automática (compliance por construção).
		"""
}
