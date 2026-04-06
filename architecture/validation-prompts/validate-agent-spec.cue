package validation_prompts

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

validationPrompts: "vp-agent-spec": artifact_schemas.#ValidationPrompt & {
	id:    "vp-agent-spec"
	title: "Validação semântica de Agent Spec"

	matchPatterns: ["^contexts/[a-z][a-z0-9-]*/agents/[a-z][a-z0-9-]*\\.cue$"]

	appliesTo: ["agent-spec"]

	references: [
		"architecture/artifact-schemas/agent-spec.cue",
		"architecture/artifact-schemas/agent-governance.cue",
		"architecture/design-principles.cue",
		"domain/domain-definition.cue",
	]

	checks: [{
		id:       "vc-ag-01"
		question: "Os autonomyLevels são proporcionais ao risco e reversibilidade de cada ação, ou há ações de alto risco com autonomia excessiva?"
		lookFor:  "Ações com category mutation e autonomyLevel execute-and-log que afetam estado cross-context (outros BCs consomem o resultado). Ações que envolvem dados regulados (KYC, PII, financeiros) sem propose-and-wait. Inversamente: ações puramente determinísticas (validação de formato, consulta de projeção) com propose-and-wait — over-governance que reduz throughput sem ganho de safety. Teste: se esta ação executasse com resultado errado, qual o blast radius? Se afeta apenas estado local reversível, execute-and-log é proporcional. Se afeta BCs downstream ou é irreversível, propose-and-wait é mínimo."
		outputMode: "finding-only"
		severity:   "fail"
		rationale:  "tq-ag-12 verifica compatibilidade semântica autonomyLevel↔constraints. Este check avalia proporcionalidade autonomia↔risco da ação no contexto da Mesh — P10 (agentes recomendam, gates validam) como lente para cada ação individual."
	}, {
		id:       "vc-ag-02"
		question: "As escalation conditions cobrem os cenários de incerteza mais perigosos para este BC específico, ou são genéricas?"
		lookFor:  "Escalation conditions que poderiam aplicar-se a qualquer agente sem modificação — falta de ancoragem no domínio específico do BC. Cenários de incerteza óbvios dados o canvas e domain model que não aparecem como escalation condition — e.g., BC que lida com compliance sem condição para mudança regulatória, BC com integração externa sem condição para sinais contraditórios. Teste de substituição: trocar o nome do BC na condição — se continua válida, está genérica."
		outputMode: "finding-only"
		severity:   "warn"
		rationale:  "tq-ag-10 verifica coerência escalation↔role/escopo e presença de categorias mínimas. Este check avalia se as condições capturam cenários reais e perigosos para este BC, não apenas satisfazem cobertura de categorias."
	}, {
		id:       "vc-ag-03"
		question: "As preconditions e postconditions das ações formam um fluxo operacional coerente — a postcondition de uma ação habilita a precondition de outra — ou há gaps no workflow?"
		lookFor:  "Preconditions que nenhuma postcondition de outra ação satisfaz — como o agente chega a esse estado? Postconditions que nenhuma precondition consome — efeito sem consequência operacional. Ações com preconditions que assumem estado que só existe após sequência implícita não declarada. Ciclos de dependência: ação A precondição de B que é precondição de A."
		outputMode: "narrative"
		severity:   "warn"
		rationale:  "Quality criteria validam refs e unicidade. Este check avalia coerência operacional do fluxo — o conjunto de ações, com suas pre/postconditions, forma um workflow executável ou tem gaps que o agente não conseguiria navegar?"
	}, {
		id:       "vc-ag-04"
		question: "Os constraints cobrem os modos de falha mais perigosos para este domínio, ou protegem contra cenários de baixo risco enquanto deixam cenários críticos descobertos?"
		lookFor:  "Invariants do domain model sem constraint correspondente no agent-spec — invariant desprotegida no nível do agente. Constraints que protegem contra cenários improváveis enquanto cenários de falha óbvios (dados o canvas e domain model) não têm constraint. Constraints com verification que descreve o que verificar mas não como — aspiracional em vez de verificável. Teste: quais são os 3 piores cenários de falha deste agente? Há constraint para cada?"
		outputMode: "finding-only"
		severity:   "fail"
		rationale:  "tq-ag-04 verifica que constraints são verificáveis. tq-ag-08 garante unicidade de codes. Este check avalia cobertura de risco — as constraints protegem contra os modos de falha mais perigosos? Constraint que protege contra cenário improvável enquanto cenário crítico está descoberto é governança desproporcional."
	}, {
		id:       "vc-ag-05"
		question: "O audit trail é suficiente para reconstruir qualquer decisão do agente meses depois, ou há campos que seriam necessários para explicar uma decisão a um auditor regulatório?"
		lookFor:  "Campos que registram o que o agente fez mas não o que o agente viu no momento da decisão — impossibilita reconstituição. Campos ausentes que o domínio específico exigiria (e.g., agente de compliance sem campo de regulação aplicada, agente de liquidação sem campo de valor processado). Teste: dado apenas o audit trail, um auditor externo conseguiria entender por que cada decisão foi tomada, quais dados estavam disponíveis, e quem autorizou?"
		outputMode: "narrative"
		severity:   "warn"
		rationale:  "tq-ag-13 verifica presença dos 7 campos mínimos (_minimumAuditFields). Este check avalia suficiência de reconstituição para o domínio específico — os campos mínimos são necessários mas podem não ser suficientes para intermediário financeiro regulado (SCD/Bacen)."
	}]

	rationale: "Agent spec define o comportamento operacional do agente — ações, autonomia, constraints, escalation. Validação semântica complementa integridade referencial com avaliação de proporcionalidade: autonomia vs risco por ação, cobertura de escalation para cenários reais, coerência do fluxo operacional, proteção contra modos de falha críticos, e suficiência de audit trail para reconstituição regulatória."
}
