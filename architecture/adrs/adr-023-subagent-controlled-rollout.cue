package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr023: artifact_schemas.#ADR & {
	id:    "adr-023"
	title: "Controlled rollout of sub-agent review for artifact-schema and adr"
	date:  "2026-03-20"

	decisionClass: "structural"
	decider:       "founder"
	reversibility: "high"
	blastRadius:   "cross-cutting"

	context: """
		ADR-022 define o modelo de sub-agente como arquitetura-alvo do
		self-review, sem torná-lo obrigatório. Para avançar de arquitetura
		documentada para execução real, é necessário: (a) escolher tipos
		iniciais para calibração, (b) definir o contrato de execução
		(input/output/avaliação de findings), (c) instrumentar o
		self-review report para distinguir modos, (d) decidir se o
		rollout usa shadow mode (dupla execução comparativa) ou
		replacement direto. Alternativas consideradas para rollout:
		(a) shadow mode para todos os tipos — rejeitada: dobra custo de
		token sem volume suficiente para análise estatística, e o custo
		cognitivo de analisar divergências supera o benefício com poucos
		artefatos; (b) replacement direto para todos os tipos — rejeitada:
		congela modo obrigatório sem calibração prévia; (c) replacement
		direto para dois tipos com critérios mais objetivos — aceita:
		calibra com tipos onde o sub-agente tem alta probabilidade de
		avaliação precisa, mantém self-reported como fallback.
		"""

	decision: """
		Operacionalizar o modelo de sub-agente (ADR-022) em rollout
		controlado. O rollout inicial usa replacement direto, não
		shadow mode, para os tipos artifact-schema e adr. Mudanças
		concretas: (1) campo executionMode ("self-reported" |
		"isolated-subagent") obrigatório em #SelfReviewReport — todo
		report declara sua proveniência; (2) executionPolicy em
		quality-gate.cue com defaultMode "self-reported" e rollout
		entry para artifact-schema e adr em modo "isolated-subagent";
		(3) input contract (artefato, schema, critérios, referências,
		findings anteriores), output contract (lista de findings
		estruturados) e finding evaluation (agente principal verifica
		antes de corrigir, registra falso-positivos como dados de
		calibração); (4) prompt template embedado no executionPolicy
		(não arquivo separado — não existe artifact schema para
		review-prompt); (5) evidence trail via roundDetails existente
		(sem hash de execução — tooling atual não suporta);
		(6) CI enforcement de executionMode (ci-sr-08) diferido para
		pós-calibração; (7) migração dos 3 reports existentes com
		executionMode: "self-reported".
		"""

	consequences: """
		Positivas: modelo de sub-agente sai de decisão documentada para
		execução real; dados de calibração (taxa de falso-positivo,
		valor por round, custo por artefato) começam a ser coletados
		nos dois tipos com maior blast radius de governança; findings
		rejeitados como dado de calibração permitem medir precisão do
		sub-agente; rollback para self-reported é trivial (alterar
		rollout entry); report com executionMode permite auditoria
		comparativa futura entre modos. Negativas: artifact-schema e
		adr passam a exigir dispatch de sub-agente, aumentando latência
		e custo de token por self-review; prompt template como string
		em quality-gate.cue pode ser difícil de manter se crescer
		(mitigado pelo escopo controlado — apenas 2 tipos); CI não
		valida executionMode nesta fase (mitigado por protocolo —
		quality-gate.cue instrui o modo, agente segue).
		"""

	status: "accepted"

	affectedArtifacts: [
		"governance/build-time/quality-gate.cue",
		"governance/build-time/self-review-report.cue",
		"governance/build-time/self-reviews/artifact-schema.self-review.cue",
		"governance/build-time/self-reviews/quality-criteria.self-review.cue",
		"governance/build-time/self-reviews/adr-018.self-review.cue",
	]

	principlesApplied: ["P0", "P10", "P12"]

	rationale: """
		P0 (single source of truth): executionPolicy vive em
		quality-gate.cue, não duplicado em CLAUDE.md — a instrução
		existente ("resolver exclusivamente a partir do artefato
		canônico") já cobre dispatch. #ExecutionMode definido uma
		vez em self-review-report.cue, reutilizado por quality-gate.cue
		via mesmo package. P10 (agentes recomendam, gates validam):
		o sub-agente isolado materializa a separação entre produção e
		validação — quem produz não valida sem escrutínio independente.
		P12 (governança como código): o executionPolicy é código
		versionado e auditável que governa quando e como sub-agentes
		são despachados, não instrução processual em documento.
		"""
}
