package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr074: artifact_schemas.#ADR & {
	id:    "adr-074"
	title: "Extend authoring-policy rollout for WI-048 BC bootstrap types (canvas, glossary, domain-model, agent-spec, agent-governance)"
	date:  "2026-05-04"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		State-of-affairs precedente:
		- adr-054 estabeleceu authoring-policy + subagent-drafted
		  dispatch como pattern declarativo para authoring.
		- adr-057 estabeleceu manualAuthoringProtocol Camada 2 (section
		  gates) para tipos não-em-rollout.
		- Phase 0 (schema #AuthoringPolicy + instância materializadas)
		  concluída; Phase 1 first dispatch executado em WI-069
		  (commit 239972c — PG-tension-entry via subagent), mas rollout
		  atual cobre APENAS production-guide type.
		- WI-048 está approved + ready-queue: 5 outputs para bootstrap
		  do BC bdg (Budget & Approval): canvas, glossary, domain-model,
		  agent-spec, agent-governance.

		  AMENDMENT (post-commit ef5195f): claim original 'Cada tipo
		  tem PG correspondente em main (cascade ordering pre-validated)'
		  era factualmente incorreto pre-commit. Inventário pre-adr-074:
		  4 PGs existiam (glossary, domain-model, agent-spec,
		  agent-governance); canvas PG NÃO existia. Gap detectado
		  durante primeiro canvas instance dispatch (subagent
		  honestamente flagged). Resolução: canvas PG materializado
		  via authoring manual em commit ef5195f (cascade-ordering
		  requirement adr-053/adr-054). Pós-ef5195f, todos 5 PGs
		  existem em main; cascade ordering agora genuinamente
		  pre-validated.

		  AMENDMENT 2 (post-commit 818c079): canvas removed from
		  subagent-drafted rollout. Revisit condition (b) de adr-074
		  triggered after 2 consecutive timeouts:
		  - disp-003 (PG canvas authoring): API stream idle timeout
		    após 473s + 32 tool uses (commit aa6274a documenta).
		  - disp-004 (canvas instance authoring, contexts/bdg/canvas.cue):
		    API stream idle timeout após 509s + 59 tool uses.

		  Diagnóstico: canvas-class workloads consistentemente excedem
		  API timeout window por densidade estrutural inerente —
		  schema #Canvas tem ~25 top-level fields + 167 sub-fields +
		  8 sections de PG + cross-checks múltiplos com
		  strategic/subdomains/ + strategic/context-map.cue. Não deve
		  ser tratado como resolvível por prompt tuning ou retry no
		  mecanismo atual — é fronteira estrutural do mecanismo.

		  Canvas removed from subagent-drafted rollout due to
		  consistent infrastructure-bound failure under schema
		  complexity; manual authoring is canonical path until
		  mechanism evolves.

		  Esta decisão NÃO é fallback tático — é decisão estrutural
		  sobre o limite operacional de subagent-drafted no modelo
		  atual. Materializa o aprendizado: subagent-drafted não é
		  universal. Existe uma fronteira de complexidade onde ele
		  deixa de ser viável. Codificar essa fronteira evita
		  redescobrir o limite a cada novo type complexo.

		  Canvas BDG materializado via manual authoring em commit
		  818c079 — exercise concreta do canonical path. PG canvas
		  materializado em ef5195f.

		Trigger desta ADR: founder explicit guidance — preferência por
		subagent-drafted dispatch para WI-048 outputs antes de iniciar
		execução. Consideração: defaultMode 'manual' aplicaria a todos
		os 5 tipos, exigindo section-by-section founder confirmation
		por section per manualAuthoringProtocol — high cognitive load
		distribuído ao longo de 5 artefatos.

		Análise per ten-009 expand-when-needed:
		- Phase 1 dispatch executado n=1 (PG-tension-entry); evidence
		  empírica é de production-guide type apenas.
		- Estender rollout para 5 tipos non-PG simultaneamente é
		  generalização at n=0 evidence per non-PG type.
		- Mitigação: fallback per-dispatch isola risco. Falha em canvas
		  dispatch não bloqueia glossary; cada dispatch é
		  independentemente fallback-able a manual.
		- WI-048 cohesion: 5 outputs da MESMA WI; fragmentar em 5 ADRs
		  sequenciais seria ceremonial overhead sem ganho real (risco
		  é mitigado per-dispatch fallback, não por ADR fragmentation).

		Limitação atual do promptTemplate em authoring-policy.cue:
		- Hardcoded "Você é um sub-agente de authoring para
		  production-guide" — referência específica a tipo.
		- "Aplique meta-guide Section 1 (target-and-prerequisites)..."
		  — referencia sections específicas do META-PG (production-
		  guide.cue), que NÃO se aplicam quando authoring canvas/
		  glossary/domain-model/agent-spec/agent-governance instance
		  (que têm PGs próprios com sections diferentes).

		Para extender rollout, é necessário generalizar promptTemplate:
		- Remover hardcode "production-guide"
		- Remover referências a section names específicos
		- Referência genérica a "sections per workOrder do PG alvo"

		Alternativas avaliadas:
		(a) Status quo (mantém apenas PG no rollout, WI-048 via manual)
		— rejeitada: high cognitive load distribuído ao longo de 5
		artefatos via section gates per manualAuthoringProtocol.
		(b) Estender rollout APENAS canvas (n=1 cautious) — rejeitada
		per founder guidance: WI-048 é unidade coesa; separar em 5
		ADRs seria ceremônia sem ganho real, porque o risco é
		mitigado por fallback per-dispatch, não por fragmentação de
		decisão.
		(c) Estender rollout para todos 5 tipos de WI-048 (escolhida)
		— B1 founder-approved.
		(d) Estender rollout para TODOS tipos com PG em main (over-
		expansion) — rejeitada: tipos não diretamente solicitados
		ficam sem evidence empírica; ten-009 strict requer trigger
		concreto.
		"""

	decision: """
		(1) AUTORIZAÇÃO, NÃO GARANTIA. Esta extensão do rollout NÃO
		garante sucesso dos 5 tipos; ela só AUTORIZA tentativa via
		subagent-drafted. Cada dispatch passa por:
		(a) cue vet local pelo subagent
		(b) reasoning report + priority list para founder review
		(c) review subagent per quality-gate.cue executionPolicy
		(d) founder approval gate final (P10 + adr-054)
		Falha em qualquer step → fallbackPolicy aciona; eventual
		manual takeover é resultado válido (não é "falha do dispatch
		mechanism" e sim "type-specific complexity excedeu
		dispatchability"). Documentar fallback no commit message
		e em subagent-execution-log.cue.

		(2) ADICIONAR 5 rollout entries em
		governance/build-time/authoring-policy.cue:
		- canvas: mode=subagent-drafted, trigger=manual-invocation
		- glossary: mode=subagent-drafted, trigger=manual-invocation
		- domain-model: mode=subagent-drafted, trigger=manual-invocation
		- agent-spec: mode=subagent-drafted, trigger=manual-invocation
		- agent-governance: mode=subagent-drafted, trigger=manual-invocation
		Cada entry com rationale articulando: PG existe em main (cascade
		ordering pré-validated), volume justificado por WI-048
		cohesion + future BCs (bdg+next), e fallback to manual
		preserved.

		(3) GENERALIZAR promptTemplate em authoring-policy.cue:
		- Substituir hardcoded "production-guide" por placeholder
		  {artifactType} (replace 1: role description; replace 2:
		  context phrasing).
		- Substituir referências a "Section 1/2/3 (target-and-
		  prerequisites)..." por reference genérica a "workOrder do
		  meta-guide" + "sections na ordem declarada".
		- Subagent lê o meta-guide path → identifica workOrder →
		  aplica sections na ordem.

		(4) AJUSTES MÍNIMOS a outputContract:
		- "Draft #ProductionGuide conformante a schema" → "Draft de
		  instância conformante ao schema target".
		Header "// PARTIAL — subagent-drafted, founder review pending"
		preservado.

		(5) ORDEM DE EXECUÇÃO de WI-048 dispatches:
		canvas → glossary → domain-model → agent-spec → agent-governance
		Por dependency semântica: canvas define what BC IS, demais
		artefatos derivam. Glossary uses UL declared in canvas;
		domain-model elabora entities; agent-spec implements behaviors;
		agent-governance configures envelope.

		(6) MATERIALIZAÇÃO: single commit consolidado com este ADR +
		edit em authoring-policy.cue (5 rollout entries + generalized
		promptTemplate + outputContract tweak) + ADR-074 self-review.
		~3-4 arquivos.

		(7) REVISIT CONDITIONS:
		(a) Se 2+ dispatches dos 5 caírem em fallback manual → revisar
		    rollout. Possíveis ações: remover tipos problemáticos do
		    rollout; refinar promptTemplate; estender inputContract
		    com mais references.
		(b) Se canvas falhar por complexidade estrutural (ex.: subdomain
		    affinities + capabilities + invariants + UL excedem
		    contexto contínuo do subagent) → considerar canvas fora
		    do rollout permanentemente.
		(c) Se agent-spec/agent-governance falharem por dependência
		    contextual (e.g., dependem de canvas + domain-model
		    completos antes de poderem ser draftedos coerentemente)
		    → restringir rollout a artifact types menos context-heavy.
		(d) Se TODOS 5 dispatches succederem em primeira tentativa →
		    expand rollout para próximos types (per ten-009
		    expand-when-needed validado pela evidence).
		"""

	consequences: """
		Positivas:

		(P1) WI-048 pode ser executada via subagent-drafted dispatch
		— authoring de 5 BC bootstrap artifacts ganha consistency
		mechanism (subagent isolation + dispatch logging) + reduz
		cognitive load de section gates manuais.

		(P2) promptTemplate generalizado torna-se reusable para
		futuros types (não exige re-edit do template a cada novo
		rollout entry).

		(P3) Rollout cresce de 1 (PG only) para 6 types — primeira
		validação de pattern subagent-drafted em context heterogêneo.

		(P4) Cascade ordering pre-validated post-commit ef5195f
		(canvas PG materializado em commit ef5195f corrige gap factual
		deste ADR original; 4 outros PGs existiam pre-adr-074).
		Pós-correção, todos 5 PGs existem em main, eliminando risco
		de cascade violation per dispatch.

		(P5) Authorization-not-guarantee framing protege founder
		expectations: extensão do rollout é tentativa autorizada,
		fallback to manual é resultado válido.

		(P6) Mecanismo de defense em profundidade validado
		(post-amendment 2): governance funcionou — IA não escalou
		para canvas-class workloads, sistema corretamente degradou
		para human authoring. Pattern observado materializa
		princípio do mesh: 'sistema robusto contra erro da própria
		IA'. Falha é detection point, não failure mode.

		Negativas:

		(N1) Generalização at n=0 evidence per non-PG type — risco
		de design speculativo. Mitigação: revisit conditions
		explícitas (decision item 7) permitem retroactive assessment.

		(N2) promptTemplate generalization perde specificity de
		Section names da META-PG. Trade-off: type-specificity vs
		reusability. Resolved favoring reusability per founder
		guidance.

		(N3) 5 dispatches em sequência (canvas → ... → agent-
		governance) podem cascatear falhas: dependência semântica
		entre artefatos (e.g., glossary depende de canvas UL)
		significa que falha em canvas can poison glossary dispatch.
		Mitigação: founder review entre dispatches; manual takeover
		permite continuar com dispatch posterior pulando falha
		anterior.

		(N4) Risco de over-rotation em automation prematura. Mitigação:
		conditions for revisit explícitas + per-dispatch fallback +
		founder approval gate final preservado.

		Known gaps declarados:
		- triggerCondition continua "manual-invocation" para todos —
		  file-pair-coverage e schema-creation-hook são future per
		  authoring-policy.cue rationale.
		- Rollout não cobre tipos fora de WI-048 (e.g., subdomain,
		  tension-entry instances, etc.) — extensão futura caso
		  por caso.
		- inputContract permanece global; per-type variations (e.g.,
		  glossary-specific lens) entrariam via amendment se needed.
		- Pattern emergente (post-amendment 2): subagent-drafted é
		  viável para artefatos com (a) baixa-média densidade
		  estrutural e (b) cross-checks semânticos limitados. Falha
		  consistentemente para artefatos com (a) múltiplas seções
		  interdependentes e (b) cross-checks intensivos cross-file
		  (canvas é o caso paradigmático). Esta observação ainda não
		  é codificada como structural-check ou policy formal — vive
		  como guideline empírico até segundo caso recorrer
		  (paralelo a ten-009 expand-when-needed para generalização).

		Fronteira regulatória: nenhuma. Decisão é meta-estrutural
		sobre authoring infrastructure scope. Cada artefato BC
		eventualmente authorado mantém sua fronteira regulatória
		própria (e.g., bdg lida com gates orçamentários internos,
		sem boundary regulatório direto).
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"governance/build-time/authoring-policy.cue",
	]

	plannedOutputs: []

	defersTo: []

	principlesApplied: [
		"P10",
		"P12",
	]

	supersedes: []

	rationale: """
		Princípios aplicados:

		P12 (governança como código): rollout extension + promptTemplate
		generalization são veículos declarativos para authoring scope.

		P10 (gates determinísticos validam): founder approval gate final
		preservado em todos os dispatches; subagent draft é proposta,
		não decisão. Per adr-054 dec 10, review subagent isolated
		from authoring subagent reduz auto-ratification.

		Sem axiomas tensionados.

		Lenses consultadas:

		lens-real-options: extensão do rollout preserva opção (rollback
		via amendment do policy). Custo de NÃO estender (manual
		section gates × 5 artefatos) é high cognitive load distribuído.
		Per founder guidance, B1 (todos 5) > B0 (canvas only) porque
		fragmentação em 5 ADRs seria ceremônia sem ganho real.

		Relação com outras ADRs:

		- DESCENDS adr-054 (authoring-policy + subagent-drafted dispatch
		  pattern).
		- COMPLEMENTA adr-057 (manualAuthoringProtocol — agora aplicável
		  apenas a tipos NÃO em rollout subagent-drafted).
		- COMPLEMENTA WI-069 (Phase 1 first dispatch validou
		  infrastructure; este ADR escala para non-PG types).
		- PRECEDE WI-048 execution (5 dispatches subsequent, em
		  sequence per dependency).
		- SEM supersession.

		Justificativa de risk metadata:

		reversibility 'high': rollout extension é amendable (remover
		entry); promptTemplate generalization é reverter para version
		hardcoded. Schema #AuthoringRolloutEntry inalterado.

		blastRadius 'cross-cutting': afeta authoring path para 5
		artifact types. Cross-cutting via authoring infrastructure
		shared, não via mandatory adoption (manual takeover sempre
		possível via fallbackPolicy).
		"""
}
