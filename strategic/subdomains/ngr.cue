package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ngr: artifact_schemas.#Subdomain & {
	code:   "ngr"
	name:   "Network Growth & Reach"
	status: "active"
	type:   "core-subdomain"

	definition: """
		Crescimento autônomo da rede por topologia econômica. Governa o
		ciclo de vida de contrapartes externas — detecção em compromissos
		e execuções de participantes ativos, ativação como novos
		participantes e exposição de suas próprias contrapartes. Convites
		são atos formais ligados a fatos econômicos verificáveis,
		entregues por canais transacionais. Proposta de valor é cálculo
		baseado em dados observados. Não qualifica participantes (NPM),
		não computa reputação (NIM), não origina compromissos econômicos
		(ECL) nem executa pagamentos (FCE).
		"""

	purpose: """
		Tornar o crescimento da rede um produto emergente da operação.
		Cada compromisso com contraparte externa cria trilha transacional
		de conversão, e cada participante ativado repete o ciclo com suas
		próprias contrapartes. Sem NGR, a Mesh cresce por aquisição ativa
		com CAC proporcional. Com NGR, crescimento é proporcional ao
		volume de transações — CAC marginal ≈ custo de compute.
		"""

	mechanismRefs: [
		"mech-network",
		"mech-agent-gate",
	]

	costRefs: [
		"ce-04", // avaliação de risco com dados incompletos — rede maior = mais dados = menor custo
	]

	capabilityRefs: [
		"cc-02", // scoring operacional — efeito de rede informacional depende de crescimento
	]

	negativeBoundaries: [{
		responsibility: "Qualificação de participantes — verificação documental, compliance, IQF."
		delegatedTo: {
			type: "subdomain"
			ref:  "npm"
		}
		rationale: "NGR detecta e convida; NPM qualifica. Fusão misturaria growth (otimizar conversão) com compliance (otimizar segurança) — incentivos opostos."
	}, {
		responsibility: "Computação de reputação — scoring, matching, ranking."
		delegatedTo: {
			type: "subdomain"
			ref:  "nim"
		}
		rationale: "NGR consome sinais de NIM para proposta de valor; NIM computa. Separação permite que inteligência de rede evolua sem acoplar ao funil de conversão."
	}, {
		responsibility: "Originação de compromissos econômicos — state machine do lifecycle."
		delegatedTo: {
			type: "subdomain"
			ref:  "ecl"
		}
		rationale: "NGR ativa participantes; ECL governa compromissos econômicos. Crescimento da rede é pré-condição para compromissos econômicos, não fase do lifecycle — fusão forçaria o lifecycle a absorver lógica de conversão de contrapartes externas."
	}, {
		responsibility: "Execução de pagamentos — liquidação financeira."
		delegatedTo: {
			type: "subdomain"
			ref:  "fce"
		}
		rationale: "NGR consome eventos de pagamento como sinais de detecção de contrapartes, não os processa. Separação mantém growth desacoplado de execução financeira — cadências e incentivos distintos."
	}]

	strategicProfile: {
		complexity: "high"
		volatility: "moderate"
		rationale: """
			Complexidade alta porque coordena 6 agentes operando funil de 7
			estágios (Exposed→Activated→Multiplied) com 7 guardrails e trust
			boundary constraint — decisões multi-agente que afetam
			crescimento da rede. Volatilidade moderada porque o funil é
			estruturalmente estável (etapas não mudam com frequência), mas
			estratégias de conversão e proposta de valor evoluem com dados
			acumulados.
			"""
	}

	rationale: """
		NGR transforma crescimento de custo variável (CAC) em custo
		marginal próximo a zero. Core porque o mecanismo de crescimento
		viral por topologia econômica é proprietário — depende de dados
		transacionais que só existem dentro da Mesh. Home layer L1 mas
		cross-cutting: consome sinais de L2 (compromissos, entregas) e L3
		(pagamentos) para detectar contrapartes.
		"""
}
