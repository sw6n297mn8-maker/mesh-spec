package validation_prompts

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

validationPrompts: "vp-agent-governance": artifact_schemas.#ValidationPrompt & {
	id:    "vp-agent-governance"
	title: "Validação semântica de Agent Governance Envelope"

	matchPatterns: ["^contexts/[a-z][a-z0-9-]*/agents/[a-z][a-z0-9-]*\\.governance\\.cue$"]

	appliesTo: ["agent-governance"]

	reviewContract: "advisory-only"

	references: [
		"architecture/artifact-schemas/agent-governance.cue",
		"architecture/artifact-schemas/agent-spec.cue",
		"architecture/design-principles.cue",
		"domain/domain-definition.cue",
	]

	checks: [{
		id:       "vc-gv-01"
		question: "Os SLAs de escalation são proporcionais à urgência e blast radius de cada categoria, ou usam valores uniformes que ignoram diferenças de risco?"
		lookFor:  "Todas as rotas com mesmo SLA independente da urgência — falta de calibração. SLA curto (sync) para categorias que não bloqueiam operações em andamento. SLA longo (async 24h) para categorias que bloqueiam operações ou propagam incerteza para BCs downstream. Canal async para categorias que envolvem risco jurídico ou financeiro imediato. Teste: se este SLA expirar, qual o impacto? Se o impacto é baixo, o canal pode ser menos urgente. Se o impacto é alto, SLA deve ser curto."
		outputMode: "finding-only"
		severity:   "warn"
		rationale:  "tq-gv-07 verifica cobertura de categorias. Este check avalia proporcionalidade — o envelope calibra urgência de resposta ao risco real de cada categoria para este BC específico?"
	}, {
		id:       "vc-gv-02"
		question: "Os blast radius caps são dimensionados para o perfil de risco deste BC específico, ou são valores arbitrários copiados de outro envelope?"
		lookFor:  "Caps idênticos aos de outro BC sem justificativa no rationale. maxConcurrentMutations sem relação com o número de ações de mutation do agent-spec. maxDailyActions sem relação com o volume operacional esperado declarado no canvas ou inferível do domínio. Rationale que justifica valores por analogia genérica ('conservador para onboarding') sem ancorar no risco específico deste BC. Teste: se este agente processasse maxConcurrentMutations simultaneamente com resultado errado, qual o blast radius cross-context?"
		outputMode: "narrative"
		severity:   "warn"
		rationale:  "tq-gv-09 verifica que caps não excedem política global. tq-gv-04 verifica proporcionalidade a nível global. Este check avalia se os caps do envelope refletem o perfil de risco específico do BC — não apenas satisfazem limites globais."
	}, {
		id:       "vc-gv-03"
		question: "Os critérios de promoção são genuinamente mensuráveis e os thresholds são calibrados para o contexto deste BC, ou são aspiracionais com números arbitrários?"
		lookFor:  "Critérios com métricas que o runner não conseguiria calcular com dados disponíveis no sistema. Thresholds sem justificativa no domínio (por que 10 e não 20? por que 95% e não 90%?). Promoção que depende de julgamento qualitativo ('quando o agente demonstrar maturidade'). Critérios que copiam valores de outro envelope sem recalibrar para volume e risco deste BC. Teste: dado o volume esperado deste BC em onboarding, o minimumObservationPeriod é suficiente para acumular a amostra declarada na métrica?"
		outputMode: "finding-only"
		severity:   "warn"
		rationale:  "tq-gv-10 verifica que critérios são mensuráveis e time-bounded. Este check avalia calibração — os números fazem sentido para este BC específico? 20 compromissos pode ser threshold adequado para CMT mas irrelevante para um BC com volume diferente."
	}, {
		id:       "vc-gv-04"
		question: "As drift metrics detectam os sinais mais importantes de desalinhamento para este BC, ou são métricas genéricas de operação?"
		lookFor:  "Métricas que medem atividade genérica (volume, latência) sem ancorar no que seria drift neste domínio específico. Ausência de métrica para o principal indicador de saúde do domínio deste BC (e.g., BC de qualificação sem métrica de taxa de qualificação, BC de compromissos sem métrica de progressão de compromissos). Baselines e thresholds sem relação com a operação real esperada. Teste de substituição: se estas métricas fossem aplicadas a outro BC, detectariam drift igualmente? Se sim, falta ancoragem no domínio."
		outputMode: "finding-only"
		severity:   "warn"
		rationale:  "tq-gv-03 (global) verifica que há ao menos uma métrica mensurável. Este check avalia relevância — as métricas detectam drift real para este BC ou são genéricas que passariam em qualquer envelope?"
	}, {
		id:       "vc-gv-05"
		question: "Os regression triggers cobrem os modos de falha de governança mais perigosos, e as immediateActions são proporcionais à severidade?"
		lookFor:  "Regression triggers ausentes para modos de falha óbvios: violação de autonomy boundary sem suspend-and-escalate, breach de blast radius sem ação imediata. immediateAction desproporcional: reduce-autonomy para violação de autonomy boundary (deveria ser suspend-and-escalate), suspend-and-escalate para drift pontual (reação excessiva). Triggers com threshold que permite múltiplas ocorrências de falha grave antes de reagir. Teste: se este trigger disparasse, a immediateAction conteria o dano antes de mais ocorrências?"
		outputMode: "finding-only"
		severity:   "fail"
		rationale:  "tq-gv-10 valida mensurabilidade. Este check avalia completude e proporcionalidade — os triggers cobrem os modos de falha de governança mais perigosos e reagem com ação proporcional? Violação de autonomy boundary com reduce-autonomy em vez de suspend-and-escalate é sub-reação que permite dano continuado."
	}]

	rationale: "Governance envelope define COMO o agente é supervisionado — escalation routing, blast radius, drift detection, calibração. Validação semântica complementa integridade referencial com avaliação de proporcionalidade e calibração: SLAs proporcionais à urgência, blast radius caps ancorados no risco do BC, critérios de promoção genuinamente mensuráveis e calibrados, drift metrics relevantes para o domínio, e regression triggers cobrindo modos de falha críticos com ações proporcionais."
}
