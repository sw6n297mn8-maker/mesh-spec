package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr097: artifact_schemas.#ADR & {
	id:    "adr-097"
	title: "Enforcement por-check no structural-check orchestrator + promoção de sc-wg-01 a reject"
	date:  "2026-05-25"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		adr-096 ativou o Build-Time Structural Check Orchestrator, mas com
		severidade GLOBAL (--mode warn|reject): ou todos os checks bloqueiam ou
		nenhum. Isso impede a "catraca" — promover checks individuais a gate
		bloqueante conforme ficam verdes e comprovam valor, sem bloquear o repo
		inteiro de uma vez (dp-07: nada de big-bang). O inventário em warn já
		mostra 21 findings (sc-cv-02/03: api-specs ainda não autoradas) que NÃO
		devem bloquear; mas sc-wg-01 (directory-pair-coverage work-events↔
		task-specs) está verde pós-backfill do D7 e guarda exatamente a classe
		de drift que motivou o gate (bug WI-033/D7).

		Alternativa considerada e REJEITADA: allowlist de IDs bloqueantes no CI
		(YAML/workflow). Reprovada — recria a duplicação declaração↔config que o
		adr-090 elimina: "qual check bloqueia" é propriedade DO check e viveria
		fora dele, gerando novo drift-surface justamente no mecanismo anti-drift.
		"""

	decision: """
		(1) Schema: adicionar campo enforcement: *"warn" | "reject" a
		_#StructuralCheckBase (#StructuralCheck). Aditivo e default "warn":
		zero impacto nos checks existentes; promoção é decisão por-check,
		born-warn.

		(2) Runner: exit 1 sse blocking_total > 0, onde blocking_total soma os
		findings de checks com enforcement efetivo "reject". --mode passa a ser
		override global de três vias: default (sem flag) respeita
		check.enforcement; --mode warn força tudo report-only; --mode reject
		força tudo blocking — preserva discovery runs e testes locais.

		(3) CI (validate.yml): runner roda em modo default (honra por-check),
		com o exit code preservado através do tee via PIPESTATUS (senão o pipe
		mascararia a falha e o gate não bloquearia). O inventário continua sendo
		postado no step summary.

		(4) Instância: sc-wg-01.enforcement = "reject" — primeiro check da
		catraca. sc-cv-02/03 e todos os demais permanecem warn (default),
		intocados.

		FORA DE ESCOPO: promoção de sc-cv-02/03 (depende de decisão de
		produto sobre api-specs); promoção do fileClassification "ambíguo→reject"
		do adr-090 a blocking-por-default (built-in, não check com enforcement —
		hoje bloqueia só sob --mode reject; 0 ambíguos no momento).
		"""

	consequences: """
		Positivas: (1) habilita promoção incremental por evidência (a catraca)
		sem big-bang; (2) enforcement vive no próprio check (P0), não em config
		de CI; (3) sc-wg-01 passa a IMPEDIR por construção um novo D7
		(work-event sem task-spec); (4) discovery runs preservados via --mode.

		Negativas: (1) mudança no contrato de exit do runner (agora por-check) —
		mitigada por self-test + verificação de que default dá 0 bloqueantes
		hoje; (2) o pipe no CI exigiu PIPESTATUS para não mascarar o exit; (3)
		fileClassification ambíguo ainda não bloqueia por default (deferido).
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"architecture/artifact-schemas/structural-check.cue",
		"scripts/ci/structural-check-runner.py",
		".github/workflows/validate.yml",
		"architecture/structural-checks/work-governance.cue",
	]

	principlesApplied: [
		"P10 — agentes recomendam, gates determinísticos validam: promove um check determinístico a gate real",
		"P0 — localização canônica única: enforcement é propriedade do check, não de config de CI (rejeita a allowlist)",
		"adr-096 — estende o orchestrator com granularidade de enforcement",
		"dp-07 — evolução sem big-bang: promoção incremental por check (catraca)",
	]

	rationale: """
		decisionClass structural: altera o schema #StructuralCheck (novo campo),
		o contrato de exit do runner e o gate no CI — sem redefinir princípios
		base (P0–P12 intactos; isto os APLICA). reversibility medium: aditivo e
		default-warn (baixo impacto), mas desfazer envolve schema + runner +
		instância + CI; blastRadius repo-wide (gate de CI sobre o repo inteiro).

		Verificado antes da proposta: cue vet ./... EXIT 0; runner --self-test
		PASS; runner default → 21 findings, 0 bloqueantes, exit 0 (sc-wg-01
		verde; os 21 são sc-cv-02/03 em warn). Logo a promoção NÃO quebra o CI.

		Próximo passo (fora desta decisão): decidir sc-cv-02/03 (autorar
		api-specs ou deferred-decision) antes de qualquer promoção delas; e
		avaliar promover o fileClassification ambíguo a blocking-por-default.
		"""
}
