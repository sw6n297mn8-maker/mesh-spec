package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr022: artifact_schemas.#ADR & {
	id:    "adr-022"
	title: "Sub-agent review model: architecture decision, deferred enforcement"
	date:  "2026-03-20"

	decisionClass: "structural"
	decider:       "founder"
	reversibility: "high"
	blastRadius:   "cross-cutting"

	context: """
		O self-review atual é self-reported: o mesmo agente que produz o
		artefato avalia sua qualidade. Isto cria viés de confirmação
		estrutural — findings são declarações, não evidência de execução
		independente. O modelo ideal é execução de cada round por um
		sub-agente isolado (sem acesso ao contexto de produção), onde
		rounds deixam de ser declarados e passam a ser inferidos da
		execução real. Porém, tornar isto obrigatório imediatamente
		congelaria um contrato ainda não calibrado, um custo operacional
		não validado, e uma semântica de evidência não testada.
		Alternativas consideradas: (a) implementar como policy universal
		agora — rejeitada: risco de retrabalho estrutural por congelamento
		prematuro de contrato não calibrado; (b) ignorar e manter
		self-reported indefinidamente — rejeitada: viés de confirmação é
		limitação conhecida do modelo atual; (c) congelar arquitetura,
		diferir enforcement, calibrar progressivamente — aceita: captura
		o design correto sem congelar execução prematuramente.
		"""

	decision: """
		Definir o modelo de sub-agente por round como arquitetura-alvo
		do sistema de self-review, sem torná-lo obrigatório nesta fase.
		O modelo define: (1) cada round é executado por sub-agente
		isolado sem acesso ao contexto de produção; (2) input do
		sub-agente: artefato, schema, critérios aplicáveis, artefatos
		de referência; (3) output: findings estruturados conforme
		#QualityCriterionFinding; (4) rounds são encadeados —
		sub-agente N recebe findings do round N-1 + artefato corrigido;
		(5) roundsExecuted é inferido do número de execuções reais,
		não declarado; (6) o report inclui evidence trail: hash ou
		referência de cada execução; (7) o self-review report incluirá
		campo executionMode: "self-reported" | "isolated-subagent" para
		distinguir origem dos findings e permitir auditoria comparativa
		entre modos. Coexistência de modos: "self-reported" (atual,
		default) e "isolated-subagent" (alvo). Promoção para obrigatório
		ocorrerá após calibração controlada — ADR futuro documentará
		critérios de promoção e resultados da calibração.
		"""

	consequences: """
		Positivas: modelo-alvo documentado permite evolução incremental
		sem redesign; contrato de input/output do sub-agente congelado
		permite tooling paralelo; coexistência de modos permite
		calibração sem breaking change; campo executionMode no report
		prepara comparabilidade e auditoria entre modos desde o início;
		papel do founder evolui de auditor de artefatos para auditor do
		sistema de auditoria. Negativas: modelo não é obrigatório — viés
		de confirmação persiste no modo self-reported (mitigado por
		ADR-021 que endurece evidência); dois modos coexistentes adicionam
		complexidade conceitual ao sistema de self-review; calibração
		exige investimento operacional futuro em execuções controladas.
		"""

	status: "accepted"

	affectedArtifacts: [
		"governance/build-time/quality-gate.cue",
		"governance/build-time/self-review-report.cue",
	]

	principlesApplied: ["P0", "P10", "P12"]

	rationale: """
		P0 (single source of truth): o modelo-alvo deve ter localização
		canônica antes que tooling ou policy o referencie — este ADR é
		essa localização. P10 (agentes recomendam, gates validam): o
		modelo de sub-agente é a forma estrutural de separar produção
		de validação, alinhando self-review com o princípio de que
		quem produz não valida autonomamente. P12 (governança como
		código): o modelo será implementável como código quando
		calibrado, não como instrução processual. A separação entre
		decisão arquitetural e policy operacional maximiza confiança
		futura e minimiza retrabalho por unidade de complexidade agora.
		"""
}
