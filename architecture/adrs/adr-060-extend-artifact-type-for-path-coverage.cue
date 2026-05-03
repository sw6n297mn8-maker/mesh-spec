package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-060 — Extend artifact_type_for_path to cover agent-spec and
// agent-governance instances.
//
// Sessão 2026-05-01 identificou gap: scripts/ci/check-self-review.sh
// artifact_type_for_path mapping cobria apenas adr/artifact-schema/lens/
// domain-definition/stakeholder-map/task-template/wave-plan; não cobria
// agent-spec nor agent-governance instances. Discovery durante autoria
// de idc-primary-agent.governance.cue (commit b62f6c2): governance
// envelope crítico não enforced por CI self-review-check.

adr060: artifact_schemas.#ADR & {
	id:    "adr-060"
	title: "Extend artifact_type_for_path to cover agent-spec and agent-governance instances"
	date:  "2026-05-01"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		State-of-affairs precedente:
		- scripts/ci/check-self-review.sh implementa enforcement do
		  self-review report requirement para changed files. artifact_
		  type_for_path função mapeia path patterns para artifactType.
		- Patterns cobertos antes deste ADR: architecture/adrs/*.cue,
		  architecture/artifact-schemas/*.cue, architecture/lenses/*.cue,
		  domain/domain-definition.cue, domain/stakeholder-map.cue,
		  ai-orchestration/agent-instructions/task-templates.cue,
		  governance/wave-plan.cue.
		- Patterns NÃO cobertos antes deste ADR (críticos para governance):
		  contexts/*/agents/*-primary-agent.cue (agent-spec instances) e
		  contexts/*/agents/*.governance.cue (agent-governance envelopes).

		Trigger: durante autoria de idc-primary-agent.governance.cue
		(commit b62f6c2) e amendments F1/F2/F3 de idc-primary-agent.cue
		(commits 8822fb5 e 8bef2e3), nenhum self-review report foi
		exigido pelo CI porque os patterns não estavam mapeados. Self-
		reviews foram criados manualmente onde aplicáveis (e.g., adr-058
		cobre changes nas instances via path em affectedArtifacts), mas
		gap explícito de enforcement permaneceu.

		Governance envelopes são runtime-critical (definem behavioral
		boundaries do agente em produção); modificações sem self-review
		são gap de governance proporcional ao risco.

		Alternativas avaliadas:
		(a) Status quo (governance envelopes não enforced) — rejeitada:
		gap identificado durante esta sessão; manter manual self-review
		depende de autor lembrar; não é discipline declarativa.
		(b) Adicionar apenas agent-governance — rejeitada: agent-spec é
		par natural (ambos governam comportamento de agente); coverage
		assimétrico cria classe de exceção arbitrária.
		(c) Adicionar agent-spec + agent-governance (este ADR) —
		recomendado: par natural; coverage simétrico; governance
		proporcional preservado.
		(d) Adicionar TODOS instance types (canvas, glossary, domain-
		model, etc.) — rejeitada: scope creep; cada type merece
		justificativa específica via ADR próprio quando volume +
		criticality + maturidade do pattern justificarem.
		"""

	decision: """
		(1) ADICIONAR pattern para agent-spec ao artifact_type_for_path
		em scripts/ci/check-self-review.sh:
		    contexts/*/agents/*-primary-agent.cue) echo "agent-spec" ;;
		Pattern matches arquivos com basename '*-primary-agent.cue'
		(e.g., 'idc-primary-agent.cue'). NÃO matches '*.governance.cue'
		files (suffix distinto).

		(2) ADICIONAR pattern para agent-governance:
		    contexts/*/agents/*.governance.cue) echo "agent-governance" ;;
		Pattern matches arquivos com extensão '.governance.cue' em
		contexts/*/agents/. NÃO matches agent-spec files.

		(3) ESCOPO: apenas role 'primary' coberto por pattern (1) —
		roles futuros (specialist, validator) ficam fora do mapping
		até pattern ser estendido por ADR posterior. Convenção:
		'*-primary-agent.cue' é narrow conscientemente; expansion
		via amendment quando specialist/validator agents emergirem.

		(4) RETROATIVOS: 5 arquivos modificados nesta branch tornam-se
		objeto de enforcement pós-merge:
		- contexts/cmt/agents/cmt-primary-agent.governance.cue (modified
		  por adr-058)
		- contexts/ctr/agents/ctr-primary-agent.governance.cue (modified
		  por adr-058)
		- contexts/npm/agents/npm-primary-agent.governance.cue (modified
		  por adr-058)
		- contexts/idc/agents/idc-primary-agent.governance.cue (created
		  + modified)
		- contexts/idc/agents/idc-primary-agent.cue (modified por F1/F2/F3
		  amendments)
		Para cada um, criar self-review report retroativo cobrindo a
		touch (status stable, single round, executionMode self-reported).

		(5) MATERIALIZAÇÃO: single commit contendo este ADR + script edit
		+ ADR-060 self-review + 5 retroativos. Decisão estrutural única;
		commits separados criariam janela onde script enforce mas
		retroativos não existem ainda.

		(6) FUTURE EXTENSION: outros instance types (canvas, glossary,
		domain-model, structural-checks, validation-prompts, production-
		guides, etc.) podem entrar no mapping via ADRs subsequent quando
		criticality + volume + maturidade justificarem. Adoção
		progressiva > big-bang scope creep.
		"""

	consequences: """
		Positivas:

		(P1) agent-spec + agent-governance instances enforced por CI —
		modificações futuras requerem self-review report explícito;
		gap de governance proporcional fechado.

		(P2) Pattern reusable estabelecido para future extensions:
		adicionar instance type ao mapping é ADR + script edit +
		retroativos por path modificado in flight.

		(P3) 5 retroativos documentam in-flight modifications; CI passa
		post-merge sem retro-block.

		(P4) Pattern '*-primary-agent.cue' narrow conscientemente:
		roles futuros (specialist, validator) entram via expansion
		explícita, não inferência tácita.

		Negativas:

		(N1) Coverage limitado a role 'primary' até pattern expandir;
		future specialist/validator agents passam não-enforced até
		ADR amendment. Mitigação: phase 0 não tem specialist/validator;
		adoção progressiva com cada role validar pattern.

		(N2) 5 retroativos overhead — relatórios criados post-fact para
		cobrir CI requirement. Mitigação: pattern existente (paralelo
		a context-map-flowpayload-fix); reports brief cobrem touch
		específica.

		(N3) Script edit é semantic change (governance enforcement
		scope). Mitigação: ADR-060 documenta; reversibility 'high'
		permite remoção via script edit reverso.

		(N4) Outros instance types (canvas, glossary, domain-model)
		permanecem não-enforced pós-this-ADR — gap reconhecido mas
		deferido para ADRs específicos. Mitigação: cada type merece
		justificativa contextualizada.
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"scripts/ci/check-self-review.sh",
	]

	plannedOutputs: [
		"governance/build-time/self-reviews/adr-060.self-review.cue",
		"governance/build-time/self-reviews/cmt-primary-agent-governance-pre-d-expansion.self-review.cue",
		"governance/build-time/self-reviews/ctr-primary-agent-governance-pre-d-expansion.self-review.cue",
		"governance/build-time/self-reviews/npm-primary-agent-governance-pre-d-expansion.self-review.cue",
		"governance/build-time/self-reviews/idc-primary-agent-governance-pre-d-expansion.self-review.cue",
		"governance/build-time/self-reviews/idc-primary-agent-spec-pre-d-expansion.self-review.cue",
	]

	principlesApplied: [
		"P10",
		"P12",
	]

	rationale: """
		Princípios aplicados:

		P12 (governança como código): script edit é o veículo declarativo
		para governance scope. artifact_type_for_path é a tabela canônica
		que define o que CI enforce; expansão via ADR + script edit é
		discipline declarativa. Manter coverage incompleta seria violação
		de 'regra que importa é imposta automaticamente'.

		P10 (gates determinísticos validam): CI self-review-check é gate
		determinístico. Adicionar agent-spec/agent-governance ao mapping
		torna o gate efetivo para instances críticas; without it, gate
		falha silenciosamente para those types.

		Sem axiomas tensionados.

		Lenses consultadas:

		lens-real-options: pattern narrow ('*-primary-agent.cue') preserva
		opção de expansion incremental quando specialist/validator agents
		emergirem. Pattern broad ('*-agent.cue') seria irreversível sem
		ADR.

		Relação com outras ADRs:

		- COMPLEMENTA adr-013/014/015 (self-review system): expande
		  enforcement scope mantendo bootstrap exceptions intactas para
		  circular cases originais.
		- PRECEDE potential ADRs para outros instance types (canvas,
		  glossary, domain-model, structural-checks, validation-prompts,
		  production-guides) quando justificarem.
		- SEM supersession.

		Justificativa de risk metadata:

		reversibility 'high': script edit é puramente aditivo; reversão
		é remover 2 linhas. Nenhum dado persistido afetado; nenhum
		contrato público alterado.

		blastRadius 'cross-cutting': afeta todos agent-spec + agent-
		governance instances (current 4 BCs com primary agents + envelopes;
		future BCs same). Não atravessa fundamental governance
		infrastructure (não é repo-wide); afeta múltiplos domínios via
		behavioral shift sistêmico (cada BC com agente).
		"""
}
