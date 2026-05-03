package validation_prompts

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

validationPrompts: "vp-production-guide": artifact_schemas.#ValidationPrompt & {
	id:    "vp-production-guide"
	title: "Validação semântica de Production Guides"

	matchPatterns: ["^architecture/production-guides/[a-z0-9-]+\\.cue$"]

	appliesTo: ["production-guide"]

	reviewContract: "advisory-only"

	references: [
		"architecture/artifact-schemas/production-guide.cue",
		"architecture/production-guides/production-guide.cue",
		"architecture/design-principles.cue",
	]

	checks: [{
		id:         "vc-pg-01"
		question:   "Cada sections[].process[].action descreve operação concreta (fetch, list, compute, perguntar, calcular, registrar) que produz output verificável, ou é instrução vaga (\"considerar\", \"avaliar\", \"analisar\") que não produz artefato verificável como output do step?"
		lookFor:    "Verbos de ação ambíguos sem objeto concreto. action sem detail e sem indicação de que output o step gera. Padrão: 'considerar trade-offs', 'avaliar opções', 'analisar contexto' — duas execuções pelo mesmo agente produziriam outputs divergentes porque o critério de done é interpretativo, não observável. Critério objetivo: se executando a action não há artefato (texto, lista, valor calculado, decisão registrada) verificável por inspeção, action é vaga."
		outputMode: "narrative"
		severity:   "fail"
		rationale:  "Action vaga sem output verificável produz divergência entre execuções e impede self-review (sem evidência de que o step foi feito). tq-pg-06 é warn estrutural; este check é a contraparte semântica que detecta vagueness mascarada por verbos plausíveis. Critério ancora em output observável, não em julgamento interpretativo."
	}, {
		id:         "vc-pg-02"
		question:   "prerequisites.gapPolicy é específica ao tipo alvo (instrui o agente sobre dados ausentes neste schema concreto) ou é boilerplate genérico que poderia colar em qualquer guide?"
		lookFor:    "gapPolicy genérica do tipo 'se faltar dado, perguntar ao founder'. Ausência de instrução concreta sobre quais campos do schema alvo são tipicamente ausentes e como tratá-los. Substituir 'production-guide' do título por outro tipo e o texto continuaria coerente — sinal de boilerplate."
		outputMode: "finding-only"
		severity:   "fail"
		rationale:  "gapPolicy boilerplate falha em sua função operacional: agente sem instrução específica inventa ou trava. Shape (MinRunes 50) garante presença, não substantividade. Failure mode observado em wave de restruturação: PGs com gapPolicy idêntica entre tipos diferentes."
	}, {
		id:         "vc-pg-03"
		question:   "Lendo o conjunto de sources declarados, um agente isolado consegue produzir uma instance válida de target? Há SoTs críticos ausentes que forçariam o agente a inventar conteúdo?"
		lookFor:    "Sources sem o schema target. Sources sem fontes de IDs referenciados pelo schema (e.g., PG-ADR sem design-principles.cue → autor inventa P-XX em principlesApplied). Sources sem instâncias de exemplo mínimas para padrão de autoria. Sources que assumem contexto de sessão não disponível para agente isolado."
		outputMode: "narrative"
		severity:   "fail"
		rationale:  "Sources insuficientes destroem o protocolo de subagent dispatch (adr-054): authoring subagent isolado não tem como recuperar conteúdo via histórico. Failure mode = conteúdo inventado que parece coerente mas viola constraints reais do schema target."
	}, {
		id:         "vc-pg-04"
		question:   "Cada sections[].doneCriteria é avaliável por terceiro lendo o output, e o sections[].process produz evidência que satisfaz aquele doneCriteria?"
		lookFor:    "doneCriteria aspiracional ('está adequado', 'reflete a realidade', 'é correto'). doneCriteria que cita campos não produzidos pelo process da mesma seção (mismatch process→doneCriteria). doneCriteria que requer comparação com state externo não citado em sources."
		outputMode: "finding-only"
		severity:   "warn"
		rationale:  "doneCriteria não-avaliável quebra terminação do agente (não sabe quando parar) e self-review (não há critério para findings). Mismatch process→doneCriteria é falha de design da seção. tq-pg-03 é warn estrutural; este check captura o aspecto de alinhamento process↔done."
	}]

	rationale: "Production guides governam a autoria de instâncias de tipos governados — qualidade do guide determina qualidade do output. Validação semântica complementa o shape (cue vet) verificando dimensões interpretativas: concretude operacional dos process steps com output verificável, especificidade da gapPolicy ao tipo, adequação semântica das sources para autoria isolada, e alinhamento process↔doneCriteria. Estas dimensões não são capturáveis por structural-check porque exigem leitura interpretativa do conteúdo textual."
}
