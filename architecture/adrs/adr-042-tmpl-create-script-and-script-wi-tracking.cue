package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr042: artifact_schemas.#ADR & {
	id:            "adr-042"
	title:         "Template tmpl-create-script e rastreamento de scripts de governança como WI"
	date:          "2026-04-07"
	status:        "accepted"
	decisionClass: "structural"
	decider:       "founder"

	context: """
		CLAUDE.md é artefato derivado de governance/claude/config.cue +
		governance/claude/output.cue (README.md seção 'Mapeamento'),
		mas não existe script, Taskfile ou Makefile que automatize a
		regeneração. O processo atual é manual: editar config.cue,
		exportar via cue, sobrescrever CLAUDE.md. Drift entre source
		e derivado é risco operacional direto — o agente opera a
		partir do CLAUDE.md renderizado, não do CUE fonte.

		Criar um script de build levanta duas questões estruturais:

		1. Templates de tarefa atuais (ADR-007) são todos para
		   artefatos CUE: tmpl-create-schema, tmpl-validate-artifact,
		   tmpl-create-instance. Shell script não é instância de
		   schema — reutilizar tmpl-create-instance com override
		   degrada a semântica do template justamente no ponto em
		   que o sistema de templates ganha tração.

		2. Scripts existentes em scripts/ci/ e scripts/hooks/
		   (check-readme-coevolution.sh, check-self-review.sh, hooks)
		   foram criados sem WI correspondente. Não há política
		   sobre quais scripts entram no work-graph. Ausência de
		   política é drift por construção — scripts com função de
		   governança ficam invisíveis ao sistema de rastreamento.

		Alternativas consideradas e rejeitadas:

		- Reutilizar tmpl-create-instance@v1 com override de
		  governança para este WI específico. Rejeitado: os
		  preReads, steps e qualityGates do template-alvo são
		  específicos para instâncias de schema (cue vet contra
		  schema, validation prompts por tipo). Forçar o protocolo
		  em shell script contamina o template e gera ritual sem
		  substância (tq-tt-01).

		- Introduzir Taskfile.yml como camada de orquestração de
		  build. Rejeitado nesta fase: um único target não justifica
		  nova dependência de tooling nem nova superfície de
		  governança. Reavaliar quando o número de targets de build
		  for maior ou igual a 3.

		- Manter scripts fora do sistema de WI (seguir precedente
		  histórico). Rejeitado: CLAUDE.md tem blast radius real —
		  agente opera a partir dele. Scripts que governam derivação
		  de artefatos normativos precisam de visibilidade no
		  work-graph equivalente aos próprios artefatos.
		"""

	decision: """
		Duas decisões acopladas.

		(1) Extender #TaskTemplate.kind em
		architecture/artifact-schemas/task-template.cue para aceitar
		"create-script" como quarto valor do enum fechado. Adicionar
		template tmpl-create-script@v1 em
		ai-orchestration/agent-instructions/task-templates.cue com
		preReads, steps e qualityGates específicos para criação de
		script de build/governança (idempotência, reprodutibilidade,
		atomicidade script↔derivado). Registrar override de governance
		para tmpl-create-script@v1 em
		governance/build-time/task-governance.cue com criticality
		"medium", lease 8h, approvalRequired true, eligibleRoles
		[spec-writer]. Criticality medium alinhada com
		tmpl-create-instance: blast radius limitado ao artefato
		derivado ou ao check implementado, não propaga para
		instâncias futuras como schema (high) nem fica isolado
		como validação (low).

		(2) Formalizar política de rastreamento de scripts como WI.
		Esta ADR é a fonte normativa primária da política; o
		rationale do template tmpl-create-script@v1 carrega apenas
		um resumo operacional apontando para cá. Regra:

		  Um script deve ser rastreado como WI quando altera,
		  deriva ou valida artefato versionado com papel normativo
		  no sistema.

		Três verbos operacionais (altera, deriva, valida) reduzem
		subjetividade a teste concreto sobre o artefato tocado, não
		sobre intenção do autor. Papel normativo significa: o
		artefato condiciona decisão, execução ou validação formal
		em outro lugar do sistema — não é instrumento descartável
		de descoberta local.

		Scripts experimentais, one-off de investigação, protótipos
		locais ou instrumentos de análise descartáveis permanecem
		fora do sistema até promoção explícita. Na dúvida, rastrear.

		Scripts existentes em scripts/ci/ e scripts/hooks/ NÃO são
		retroativamente convertidos em WI — backfill retroativo
		tem custo superior ao valor (análogo ao tratamento em
		work-events/_constraints.cue). A política aplica-se a
		partir desta ADR. Scripts existentes são candidatos
		explícitos a promoção quando tocados por WI subsequente
		que os modifique materialmente.
		"""

	consequences: """
		Positivas: CLAUDE.md passa a ter pipeline determinístico
		de regeneração, eliminando drift manual; categoria explícita
		de template para scripts de governança previne contaminação
		dos templates de artefato CUE; política de fronteira torna
		explícito quais scripts entram no work-graph, evitando o
		vácuo atual; habilita WIs subsequentes de hook integration
		e drift detection sem reabrir a decisão de template;
		mantém P0 ao fixar localização canônica única da política
		(campo decision desta ADR), com resumo replicado no
		template servindo como ponteiro.

		Negativas: mais um valor no enum #TaskTemplate.kind amplia
		a superfície de manutenção do schema e força decisão
		explícita a cada template futuro sobre qual categoria
		aplicar; política de fronteira mantém componente
		interpretativo residual — mesmo com três verbos operacionais,
		a classificação "papel normativo" exige julgamento que não
		é puramente mecânico. Mitigação: regra de dúvida ("na
		dúvida, rastrear") evita paralisia; backfill explicitamente
		rejeitado delimita janela de inconsistência conhecida
		(scripts pré-ADR fora do sistema).
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/artifact-schemas/task-template.cue",
		"ai-orchestration/agent-instructions/task-templates.cue",
		"governance/build-time/task-governance.cue",
	]
	derivedArtifacts: [
		"CLAUDE.md",
	]

	principlesApplied: [
		"P0: zero duplicação — política vive em lugar único (decision desta ADR), resumo no template é ponteiro, não cópia; CLAUDE.md deriva do CUE fonte, não existe em duas versões",
		"P1: schema-first — extensão do schema #TaskTemplate precede instância do template tmpl-create-script@v1 no mesmo commit",
		"P12: governance as code — scripts de governança passam a ser artefatos versionados com protocolo de execução formal em vez de convenção tácita",
	]

	supersedes: []

	rationale: "CLAUDE.md é artefato derivado sem pipeline de geração e scripts de governança vivem hoje fora do work-graph. Estender o sistema de templates e formalizar política de rastreamento resolve os dois gaps estruturais em uma decisão acoplada, em vez de introduzir workaround ad-hoc por instância."
}
