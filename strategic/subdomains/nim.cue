package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

nim: artifact_schemas.#Subdomain & {
	code:   "nim"
	name:   "Network Intelligence & Mechanism Design"
	type: "core-subdomain"

	definition: """
		Inteligência de rede que transforma dados observados no ciclo em
		reputação, confiança, decisões informadas e orquestração de
		demanda. Produz mecanismos algorítmicos (scoring, matching,
		ranking, incentivos, penalidades, recomendações) que governam
		comportamento na rede. Incorpora sinais exógenos relevantes ao
		compromisso sem operar monitoramento ambiental como atividade fim.
		Não origina compromissos econômicos (CMT), não qualifica
		participantes (NPM), não precifica risco financeiro (REW) nem
		executa pagamentos (FCE).
		"""

	purpose: """
		Democratizar capacidades de category management e strategic
		sourcing — hoje restritas a grandes empresas com equipes dedicadas
		— para toda a rede, usando dados gerados pelo próprio ciclo.
		Reputação e confiança como produto emergente fazem o fornecedor
		eficiente ganhar visibilidade e mais contratos. Sem NIM, a
		inteligência da rede não existe como ativo cumulativo — cada
		decisão é pontual e sem memória.
		"""

	mechanismRefs: [
		"mech-network",
		"mech-agent-gate",
	]

	costRefs: [
		"ce-04", // avaliação de risco com dados incompletos
	]

	capabilityRefs: [
		"cc-02", // scoring baseado em dados operacionais verificados
	]

	negativeBoundaries: [{
		responsibility: "Qualificação e homologação de participantes — verificação documental, IQF, status transitions."
		delegatedTo: {
			type: "subdomain"
			ref:  "npm"
		}
		rationale: "NIM computa reputação; NPM decide elegibilidade. Fusão misturaria inteligência computacional com processo de compliance documental — cadências de evolução distintas."
	}, {
		responsibility: "Precificação de risco financeiro — políticas de crédito, limites, condições."
		delegatedTo: {
			type: "subdomain"
			ref:  "rew"
		}
		rationale: "NIM produz sinais; REW consome para produzir decisões de risco. Separação garante que reputação e pricing evoluam independentemente — NIM otimiza para informação, REW otimiza para decisão financeira."
	}, {
		responsibility: "Monitoramento ambiental como atividade fim — sensoriamento, IoT, câmeras."
		delegatedTo: {
			type: "external-system"
			ref:  "ext-monitoring-systems"
		}
		rationale: "NIM incorpora sinais exógenos mas não opera infraestrutura de monitoramento. Internalizar monitoramento acoplaria evolução da inteligência de rede à gestão de hardware e sensores — domínios com complexidade e cadência de evolução radicalmente diferentes."
	}, {
		responsibility: "Seleção estratégica de fornecedores — avaliação, negociação, decisão de sourcing."
		delegatedTo: {
			type: "subdomain"
			ref:  "ssc"
		}
		rationale: "NIM produz scoring, matching e ranking como inputs para decisões de sourcing; SSC consome esses inputs e toma a decisão de seleção. Matching algorítmico não é decisão de sourcing — é insumo."
	}]

	strategicProfile: {
		complexity: "high"
		volatility: "high"
		rationale: """
			Complexidade alta porque ParticipantSignalStore append-only com
			7 invariantes, múltiplos modelos de scoring (IQF, TCO), matching
			algorithms e mechanism design — camada com dependência
			bidirecional por design (única no sistema). Volatilidade alta
			porque cada novo tipo de sinal, modelo de scoring ou algoritmo
			de matching expande a superfície; é o flywheel, portanto evolui
			com o crescimento da rede.
			"""
	}

	rationale: """
		NIM é o flywheel da Mesh — consome sinais de todos os subdomínios
		e retroalimenta qualificação e risco. Core porque o corpus
		proprietário de dados operacionais não é replicável por
		concorrentes sem o mesmo volume de transações. Contribui para o
		moat de IA.
		"""
}
