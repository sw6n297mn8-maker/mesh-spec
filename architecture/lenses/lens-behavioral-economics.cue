package lenses

import "mesh-spec/architecture/artifact-schemas"

behavioralEconomics: artifact_schemas.#AnalyticalLens & {
	id:      "lens-behavioral-economics"
	name:    "Economia Comportamental"
	purpose: "Modelar como fornecedores, compradores, investidores e humanos no loop processam informação, risco, confiança e outputs de IA de forma não plenamente racional, para que a Mesh desenhe jornadas, comunicações e defaults robustos ao comportamento real."
	status:  "draft"

	trigger: {
		conditions: [
			"a decisão envolve como participantes reais, e não agentes plenamente racionais, tomam decisões de adoção, uso ou abandono",
			"a decisão envolve design de onboarding, first-use experience ou reativação",
			"a decisão envolve por que participantes não adotam apesar de benefício aparente",
			"a decisão envolve como apresentar score, taxa, risco ou incerteza para que participantes processem corretamente",
			"a decisão envolve por que participantes reagem de forma desproporcional a eventos negativos, mudanças de regra ou notícias",
			"a decisão envolve reduzir friction de adoção ou aumentar engajamento recorrente",
			"a decisão envolve como vieses cognitivos afetam decisões financeiras ou operacionais dos participantes",
			"a decisão envolve comunicação de crise, renegociação ou mudança de política para participantes ou investidores",
			"a decisão envolve como humanos processam outputs de agentes de IA, incluindo aceitação cega e rejeição após erro",
			"a decisão envolve percepção de fairness entre participantes que recebem tratamento diferenciado",
		]
		keywords: [
			"viés", "bias", "heurística", "nudge", "boost",
			"adoção", "onboarding", "friction", "abandono",
			"aversão à perda", "loss aversion", "status quo", "inércia",
			"ancoragem", "anchoring", "framing", "enquadramento",
			"overconfidence", "excesso de confiança", "planning fallacy",
			"present bias", "desconto hiperbólico", "imediatismo",
			"social proof", "prova social", "herding",
			"default", "opt-in", "opt-out",
			"confiança", "medo", "pânico", "resistência",
			"simplicidade", "complexidade cognitiva",
			"sunk cost", "escalation", "commitment device",
			"automation bias", "algorithm aversion",
			"fairness", "justiça", "reciprocidade",
			"reference point", "regret", "arrependimento",
		]
		excludeWhen: [
			"a decisão é sobre design de regras e incentivos assumindo racionalidade estável — usar lens-mechanism-design",
			"a decisão é sobre estrutura informacional sem componente de processamento comportamental — usar lens-information-economics",
			"a decisão é sobre risco de crédito, perda esperada ou composição de carteira — usar lens-credit-risk",
			"a decisão é sobre funding, liquidez ou veículo regulatório — usar lens-financial-intermediation",
			"a decisão é sobre topologia de rede sem componente de processamento humano — usar lens-network-theory",
		]
		rationale: "Mechanism-design assume racionalidade suficiente para que participantes respondam a incentivos conforme o modelo. Behavioral-economics entra quando isso falha: participantes são boundedly rational, usam heurísticas, têm aversão a perda, resistem a mudança por inércia, super-reagem a eventos salientes, e interagem com IA com automation bias ou algorithm aversion. Na construção civil brasileira, com fornecedores de baixa sofisticação, compradores institucionais com DMU complexa e redes informais de reputação, esse gap é grande e recorrente."
	}
}
