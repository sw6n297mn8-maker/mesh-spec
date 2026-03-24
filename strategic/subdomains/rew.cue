package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

rew: artifact_schemas.#Subdomain & {
	code:   "rew"
	name:   "Risk Engine & Risk Observability"
	type: "core-subdomain"

	definition: """
		Modelagem, versionamento e execução de políticas de risco,
		elegibilidade financeira, pricing e monitoramento do risco ao
		longo do ciclo. Consome evidências internas (eventos operacionais,
		comportamento transacional, qualificação) e sinais exógenos
		(câmbio, macro, sanções, risco soberano). Produz decisões de
		crédito, limites, condições e alertas auditáveis. Motor de
		decisão que transforma dados observados em políticas executáveis,
		sem originar produtos financeiros diretamente.
		"""

	purpose: """
		Centralizar avaliação de risco e elegibilidade em motor
		independente dos produtos que o consomem, garantindo que decisões
		de crédito, limites e pricing sejam consistentes, auditáveis e
		baseadas em risco observado diretamente. Separa lógica de risco
		da lógica de produto para evolução independente. Sem REW, cada
		subdomínio consumidor (SCF, FCE, NPM) implementaria risco
		internamente — criando inconsistência e duplicação.
		"""

	mechanismRefs: [
		"mech-network",
		"mech-agent-gate",
		"mech-evidence",
	]

	costRefs: [
		"ce-04", // avaliação de risco com dados incompletos
		"ce-07", // due diligence sobre lastro
	]

	capabilityRefs: [
		"cc-02", // scoring operacional
		"cc-05", // acesso programático a portfólios
	]

	negativeBoundaries: [{
		responsibility: "Originação de produtos financeiros — antecipação, reverse factoring, crédito."
		delegatedTo: {
			type: "subdomain"
			ref:  "scf"
		}
		rationale: "REW precifica; SCF origina. Fusão acoplaria evolução de modelos de risco à evolução de produtos financeiros — regulação, stakeholders e cadências distintas."
	}, {
		responsibility: "Execução de pagamentos — liquidação, settlement."
		delegatedTo: {
			type: "subdomain"
			ref:  "fce"
		}
		rationale: "REW define limites; FCE executa dentro deles. Separação permite que limites mudem sem alterar o fluxo de pagamento — risco é input, não executor."
	}, {
		responsibility: "Qualificação de participantes — verificação documental, IQF."
		delegatedTo: {
			type: "subdomain"
			ref:  "npm"
		}
		rationale: "REW consome elegibilidade de NPM como input, não a produz. Qualificação é processo de compliance documental, não modelagem de risco — internalizar misturaria dois corpos de conhecimento."
	}, {
		responsibility: "Computação de reputação e inteligência de rede — scoring comportamental, matching."
		delegatedTo: {
			type: "subdomain"
			ref:  "nim"
		}
		rationale: "Reputação (comportamento observado cumulativo) e pricing (decisão financeira derivada) têm modelos, cadências e stakeholders diferentes — fusão forçaria um único time a dominar dois corpos de conhecimento distintos."
	}]

	strategicProfile: {
		complexity: "high"
		volatility: "high"
		rationale: """
			Complexidade alta porque consome sinais internos e exógenos
			(câmbio, macro, sanções), opera políticas versionadas e modelos
			de scoring acumulativos, sob regulação de crédito específica por
			produto. Volatilidade alta porque regras de risco mudam com
			mercado, regulação e volume — cada expansão de produto (SCF) ou
			vertical (construção→logística) exige recalibração.
			"""
	}

	rationale: """
		REW é o pricing moat — risco observado é mais preciso que risco
		inferido, e cada ciclo melhora a precisão. Core porque a lógica de
		precificação baseada em dados operacionais verificados é
		proprietária e não replicável sem o volume da rede. Separação de
		NIM é deliberada: NIM computa reputação (comportamento observado),
		REW transforma reputação em decisão financeira (pricing, limites).
		"""
}
