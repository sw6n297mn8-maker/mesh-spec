package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def031: artifact_schemas.#DeferredDecision & {
	id:     "def-031"
	title:  "Oráculo de fluxo de evento ponta-a-ponta — cross-context-flow-closure como gate (Ciclo 3 de feedback de build-time)"
	date:   "2026-05-30"
	status: "open"

	description: """
		Estender o schema #CrossContextFlow (adr-032) para exigir a cadeia de
		eventos COMPLETA de um flow declarado — cada evento produzido por uma
		phase tem consumidor dentro do flow, e cada evento consumido tem
		produtor — e criar um structural-check cross-context-flow-closure que
		FALHA quando um flow declarado contém evento órfão (publicado sem
		consumidor, ou consumido sem produtor). É o event-storming-reverso como
		gate determinístico: a especificação de um BC é incompleta se não
		consegue expressar o fluxo de domínio ponta-a-ponta (e.g., recebível
		nasce em INV → é antecipado em SCF → é liquidado em FCE → repercute em
		ATO) sem furo, independentemente de cue vet e dos structural-checks de
		shape estarem verdes. Hoje o único flow declarado (commitment-lifecycle)
		é referenciado por flowRefs em ~9 arestas mas nenhum check valida sua
		closure; cross-context-flow.cue valida apenas shape (sc-ccf-01/02:
		ownerContext/ownerSubdomain existem).
		"""

	deferralRationale: """
		HORIZONTE DE RESOLUÇÃO: próximo (PR-#2 da sequência de feedback-cycles,
		logo após o PR-#1 de falsificationCondition/def-032). NÃO é diferido
		indefinidamente — é o segundo item da sequência já acordada com o
		founder na auditoria de ciclos de feedback.

		MOTIVO de deferir agora (não materializar neste PR de registro): (1) é o
		gap de maior esforço dos quatro — exige evolução do schema
		#CrossContextFlow (campo de cadeia de eventos), um structural-check novo
		de kind potencialmente inédito (graph-closure, não cobertto pelos kinds
		atuais cross-file-id-exists/conditional-file-presence), e ADR de
		evolução; misturar com o PR de registro inflaria escopo e classe
		(registro é leve; isto é semântico pesado); (2) precede-o def-032
		(falsificationCondition) por ser mais barato e destravar o painel
		(def-034) junto; (3) o custo de esperar um PR é baixo — o flow
		commitment-lifecycle atual é estável e o gap só morde quando novos BCs
		adicionam eventos ao flow sem fechar a cadeia. Custo evitado agora:
		evolução de schema + kind de check novo no PR errado. Custo de
		continuar além do PR-#2: derivações de BC passam sem o oráculo que pega
		erro de modelagem que só aparece tarde (o feedback estrategicamente
		mais importante do build-time).
		"""

	triggerCalibrationRationale: """
		Trigger primário adjacent-need file-contains (2º flow declarado): quando
		o context-map declarar um flow além de commitment-lifecycle, a topologia
		de flows passa a ter múltiplas cadeias cujas closures não são
		verificadas — sinal concreto de que o gate vale o custo. O pattern busca
		uma 2ª entrada em declaredFlows. Backstop recurrence filename threshold
		16 (≈⅔ dos 25 BCs scaffolded): mesmo sem 2º flow, com a maioria dos BCs
		materializados o commitment-lifecycle terá acumulado arestas suficientes
		para furos de closure não-triviais. Refina def-021 (que checa
		integrationEvents contra domain-model — dimensão events), NÃO duplica:
		def-021 verifica que os eventos existem; def-031 verifica que o GRAFO do
		flow fecha (closure topológica). São camadas complementares do Ciclo 3.
		"""

	originatingArtifacts: [
		"session:feedback-cycles-audit",
		"architecture/structural-checks/cross-context-flow.cue",
	]

	costOfDeferral: {
		severity:    "high"
		blastRadius: "cross-cutting"
		description: """
			Sem o oráculo de closure, cada BC derivado pode declarar consumo/
			produção de eventos que não fecham num fluxo real — o erro de
			modelagem mais caro (revela-se meses depois, quando o agente
			constrói em cima). Afeta canvas + context-map + cross-context-flow de
			todos os BCs no flow. high porque é o feedback estrategicamente
			central de build-time; cross-cutting porque um flow atravessa
			múltiplos BCs.
			"""
	}

	triggers: [{
		kind:      "adjacent-need"
		condition: {
			kind:    "file-contains"
			path:    "strategic/context-map.cue"
			pattern: "declaredFlows:[^]]*,[^]]*\""
		}
	}, {
		kind:      "recurrence"
		pattern:   "contexts/[a-z0-9-]+/canvas\\.cue$"
		scope:     "filename"
		threshold: 16
	}]
}
