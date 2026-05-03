package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-058 — Add failureHandling first-class field to #AgentGovernanceEnvelope.
//
// Promove tq-gvg-08 (failure handling como tech debt declarada em
// narrative) para campo schema enforced. IDC governance (commit
// b62f6c2) declarou explicitamente como tech debt em comment block
// + driftDetection.rationale — momento natural de promoção dada a
// 4ª instance recém-criada.

adr058: artifact_schemas.#ADR & {
	id:    "adr-058"
	title: "Add failureHandling first-class field to #AgentGovernanceEnvelope"
	date:  "2026-05-01"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		State-of-affairs precedente:
		- PG-B (architecture/production-guides/agent-governance.cue,
		  commit f38ef27) declara tq-gvg-08 (warn): envelope deve
		  documentar failureHandling cobrindo onAgentError, onTimeout,
		  onRepeatedFailure como tech debt narrative até schema
		  absorver como first-class field.
		- 4 envelopes existentes: cmt/ctr/npm-primary-agent.governance.
		  cue (pre-session) — sem failureHandling declarado (tq-gvg-08
		  ainda não existia quando autorados); idc-primary-agent.
		  governance.cue (commit b62f6c2) — declarou explicitamente
		  como tech debt em comment block + driftDetection.rationale,
		  alinhado com tq-gvg-08.

		Trigger: criação do envelope IDC formalizou o pattern como
		tech debt explícita. PG-B já documentava obrigação; o gap
		é apenas de ENFORCEMENT — schema não modela como first-class,
		então tech debt vive em narrative onde nem tooling nem
		runner futuro consegue validar coverage. Promoção a first-
		class é o passo que move de 'discipline narrativa' para
		'discipline declarativa enforced'.

		P10 + P12 demandam governance como código com gates
		determinísticos. failureHandling em narrative é falha de
		P12 — regra que importa é imposta automaticamente, prosa
		em rationale não é imposição.

		Alternativas avaliadas:
		(a) Manter failureHandling como tech debt narrative
		permanente — rejeitada: non-auditable; runner futuro não
		consegue validar coverage; depende de autor lembrar de
		incluir o block.
		(b) Schema field first-class (este ADR) — recomendado:
		enforce coverage por construção; runner futuro valida
		completude; instâncias existentes migram explicitamente.
		(c) Separate file/artifact-type para failure policies
		cross-agent — rejeitada: over-engineering para 3 enums +
		thresholds simples; failure handling é per-agent (cada
		envelope calibra próprio).
		(d) Modelar apenas em driftDetection.rationale (idc pattern)
		— rejeitada: mistura concerns (drift detection é sobre
		métricas observáveis; failure handling é sobre erro do
		próprio agente). Separação evita drift de semântica.
		"""

	decision: """
		(1) ADICIONAR novo sub-tipo #FailureHandling ao schema em
		architecture/artifact-schemas/agent-governance.cue:
		    onAgentError: {action: #RegressionAction, description: !=""}
		    onTimeout: {action: #RegressionAction, retryPolicy?: !="", description: !=""}
		    onRepeatedFailure: {action: #RegressionAction, threshold: !="", timeWindow: !="", description: !=""}
		    rationale: !=""

		(2) ADICIONAR campo failureHandling: #FailureHandling como
		REQUIRED ao #AgentGovernanceEnvelope (entre calibration e
		rationale). Required (não opcional) — first-class significa
		enforced.

		(3) REUTILIZAR #RegressionAction enum existente (reduce-
		autonomy / revert-to-previous-stage / suspend-and-escalate)
		sem expansion. retry-then-escalate semantics expressa via
		retryPolicy field + action='suspend-and-escalate' quando
		retry exausto. Pause-and-review semantics expressa via
		action='suspend-and-escalate' + description articulando
		modo 'halt and review'.

		(4) UPDATE tq-gvg-08 em PG-B: description ajustada de 'tech
		debt declarada' para 'campo schema first-class enforced';
		test atualizado para verificar block presence e shape, não
		narrative coverage.

		(5) UPDATE PG-B heuristics em drift-and-calibration: remover
		wording de 'tech debt declarada'; referenciar campo
		declarativo. UPDATE finalValidation step correspondente.

		(6) MIGRATION das 4 instâncias no MESMO commit:
		- cmt/ctr/npm: adicionar block failureHandling com defaults
		  conservadores (suspend-and-escalate em todos 3 events;
		  retryPolicy 'max 1 retry exponential backoff' em onTimeout;
		  threshold '3 failures' / timeWindow '24h' em onRepeatedFailure).
		- idc: promover failureHandling de narrative em comment block
		  + driftDetection.rationale para field first-class; remover
		  narrative duplicada (P0).

		(7) MATERIALIZAÇÃO: single commit contendo ADR + schema delta
		+ PG-B update + 4 instance migrations + 2 self-review reports
		(adr-058 + agent-governance schema). Decisão estrutural única
		— multi-commit fragmenta atomic rationale e cria janela onde
		schema enforce field que instâncias ainda não declaram.
		"""

	consequences: """
		Positivas:

		(P1) failureHandling vira enforced por construção — runner
		futuro pode validar coverage automaticamente; novos envelopes
		não podem omitir o concern silenciosamente.

		(P2) IDC envelope simplifica: narrative em comment block +
		driftDetection.rationale move para field declarativo
		single-source per P0.

		(P3) 4 envelopes existentes ganham coverage explícita;
		CMT/CTR/NPM (que não tinham failureHandling) passam a
		documentar concern como first-class.

		(P4) Pattern reusable estabelecido — futuras schema extensions
		para concerns observados como tech debt em narrative seguem
		o mesmo lift (PG documenta → schema absorve quando volume
		justifica).

		(P5) tq-gvg-08 evolui de discipline narrativa para verification
		declarativa; PG-B alinha com schema reality.

		Negativas:

		(N1) 4 instâncias precisam migrar no mesmo commit — coordination
		overhead. Mitigação: defaults conservadores aceitáveis Phase 0;
		rationale BC-specific opcional.

		(N2) #RegressionAction enum reusado mas semântica overload:
		suspend-and-escalate cobre 3 modos diferentes (halt-review,
		retry-exhausted-escalate, repeated-failure-suspend). Mitigação:
		description field carrega semantic distinguish; future extension
		de #RegressionAction enum se distinções operacionais justificarem.

		(N3) failureHandling required (não opcional) — instâncias
		futuras devem sempre declarar; cap mínimo de overhead por
		envelope. Mitigação: defaults conservadores razoáveis tornam
		declaração rápida.

		(N4) Reversibilidade media — remover field exige migração
		retroativa. Mitigação: reversibility 'medium' calibrada;
		remoção exige ADR superseder + coordination.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/artifact-schemas/agent-governance.cue",
		"architecture/production-guides/agent-governance.cue",
		"contexts/cmt/agents/cmt-primary-agent.governance.cue",
		"contexts/ctr/agents/ctr-primary-agent.governance.cue",
		"contexts/npm/agents/npm-primary-agent.governance.cue",
		"contexts/idc/agents/idc-primary-agent.governance.cue",
		"governance/build-time/self-reviews/adr-058.self-review.cue",
		"governance/build-time/self-reviews/agent-governance-schema-failurehandling.self-review.cue",
	]

	principlesApplied: [
		"P0",
		"P10",
		"P12",
	]

	rationale: """
		Princípios aplicados:

		P12 (governança como código) é o driver primário: failure
		handling em narrative viola 'regra que importa é imposta
		automaticamente'. Schema first-class field move concern de
		discipline narrativa para discipline declarativa enforced.

		P10 (gates determinísticos validam, agentes recomendam)
		sustenta o requirement: failure handling é o que acontece
		quando agente próprio falha — sem field declarativo, falha
		do agente vira buraco silencioso na governance.

		P0 (localização canônica única): failureHandling vive em
		UM lugar (envelope.failureHandling field). IDC envelope
		atual viola P0 — narrative em comment block + driftDetection
		.rationale duplicam o concern. Migração consolida em single
		source.

		Failure mode evitado: envelope sem failure handling declarado
		quando agente próprio falha — falha sem path de recovery
		declarado. tq-gvg-08 originalmente cobriu via narrative;
		promotion fecha gap de enforcement.

		Sem axiomas tensionados.

		Lenses consultadas:

		lens-ai-agent-governance (aag-autonomy-boundary, aag-drift-
		detection): failure handling é dimensão complementar a
		autonomy boundary e drift detection — agente pode falhar
		SEM violar boundary nem drift threshold (timeout, erro
		sistemático). Field separado captura essa dimensão.

		lens-real-options: schema field first-class preserva opção
		de evoluir #FailureHandling shape via ADR posterior + diff.
		Tech debt narrative comprometia evolução (alterar requeria
		touch em N envelopes sem trace auditável).

		Relação com outras ADRs:

		- PROMOTE tq-gvg-08 da PG-B (introduzido em commit 8ba35b6
		  + amendment ff9d139) de tech debt narrative para schema
		  first-class enforced.
		- SEM supersession (ADRs precedentes não cobriam failure
		  handling explicitamente).

		Justificativa de risk metadata:

		reversibility 'medium': field required exige migração das 4
		envelopes; remoção retroativa exigiria mesma coordination +
		ADR superseder. Não é 'low' (não envolve dados persistidos /
		contratos públicos / concession-like regulatory) nem 'high'
		(instâncias dependem do field; remoção quebra vet em todas
		envelopes).

		blastRadius 'cross-cutting': afeta governance schema + PG-B
		+ 4 envelopes existentes + todos envelopes futuros. Não
		atravessa CI/governança fundamental (não é repo-wide); afeta
		múltiplos domínios via behavioral shift sistêmico.
		"""
}
