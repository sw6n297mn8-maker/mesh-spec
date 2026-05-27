package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr108: artifact_schemas.#ADR & {
	id:    "adr-108"
	title: "Normalizar os 22 event-names à convenção canônica + promover sc-ev-01 a reject"
	date:  "2026-05-26"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		adr-107 declarou a convenção de event-name (PascalCase, sem espaços) via
		sc-ev-01 born-warn, que surfaceou 22 de 83 names não-normalizados (dlv/inv
		com espaços, rew com parentéticos descritivos). Para travar a regressão de
		fato (reject), os 22 precisavam virar a forma canônica — base limpa antes da
		promoção (catraca adr-097: promove quando verde).

		Verificado antes: os 22 não são referenciados no context-map (rename seguro,
		não toca sc-cm-06); todos têm description (o detalhe dos parentéticos não se
		perde); refs internas usam code (evt-*), não name (rename é display-only); zero
		colisões. A maioria é mecânica; 3 com conectores/fraseado verboso exigiram
		decisão de nome do founder.

		Alternativa REJEITADA: promover a reject sem normalizar (impossível — 22
		violações bloqueariam o CI) ou manter warn indefinidamente (não trava a
		regressão). Normalizar → promover é o fecho da catraca.
		"""

	decision: """
		(1) Normalizar os 22 domain-model.events[].name à convenção PascalCase
		(parentético descritivo dropado do name; detalhe permanece no description).
		Decisões de nome do founder nos 3 verbosos:
		    - "Signal Received from Upstream BC (via ACL)" → SignalReceivedFromUpstreamBC
		    - "Signal Rejected at ACL boundary (validation failed)" → SignalRejectedAtACLBoundary
		    - "Emit Superseded by Newer Evaluation (NÃO failure …)" → RiskEvaluationEmitSuperseded
		      (alinhado à família RiskEvaluationEmit*, não ao fraseado original)
		Os outros 19 (dlv ×5, inv ×3, rew ×11) são normalização mecânica aprovada.

		(2) Promover sc-ev-01 (event-name convention) de enforcement "warn" para
		"reject". Com os 22 normalizados, sc-ev-01 reporta zero violações → nasce
		verde como gate. Um event name não-canônico novo passa a falhar o CI
		(verificado por teste adversarial: "Delivery Borked" → sc-ev-01 reject, exit 1).

		FORA DE ESCOPO: normalização de convenção de OUTROS campos de name
		(commands/aggregates/etc. — não governados por sc-ev-01); demais checks do
		regex kind (sc-srr-02/sc-ts-02).
		"""

	consequences: """
		Positivas: (1) o vocabulário de event-name fica 100% canônico (PascalCase) e
		TRAVADO por reject — regressão de convenção agora falha o CI por construção;
		(2) fecha a catraca iniciada em adr-104/107 (canonizou → declarou → normalizou
		→ promoveu); (3) renames display-only, sem efeito em refs internas (code) nem
		no context-map (sc-cm-06 intacto).

		Negativas: (1) os parentéticos descritivos saíram do name — dependem do
		description para o detalhe (verificado: todos têm description); (2) só
		events[].name é coberto/travado — outros campos de name seguem livres (fora
		de escopo); (3) reject é um gate a mais que pode bloquear um PR futuro com name
		não-canônico — que é exatamente a intenção.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"contexts/dlv/domain-model.cue",
		"contexts/inv/domain-model.cue",
		"contexts/rew/domain-model.cue",
		"architecture/structural-checks/domain-model-event-convention.cue",
	]

	principlesApplied: [
		"P10 — gate determinístico: convenção de event-name agora bloqueia (reject)",
		"P0 — vocabulário canônico único: name PascalCase travado; detalhe no description",
		"adr-104/107 — fecha a catraca: canonizou (104), declarou+kind (107), normalizou+promoveu (108)",
		"adr-097 — born-warn → reject quando verde: promoção após zero violações",
		"dp-07 — sem big-bang: normalização precedeu a promoção",
	]

	defersTo: []

	rationale: """
		decisionClass structural: normaliza 22 names em 3 domain-models e promove um
		gate a reject — efeito repo-wide, aplica P0/P10/adr-104/adr-097 sem redefinir
		princípios. reversibility medium (renames + enforcement reversíveis, mas toca
		4 artefatos); blastRadius repo-wide (gate de convenção sobre todos os
		domain-models).

		Verificado antes da proposta: os 22 nomes canônicos decididos pelo founder;
		renames display-only (não no context-map, refs internas por code, grep
		confirmou); cue vet ./... EXIT 0; runner --self-test PASS; sc-ev-01 → zero
		violações; runner default → 0 bloqueantes, exit 0; teste adversarial → name
		não-canônico bloqueia (exit 1). domain-model não exige SRR (não consta em
		artifact_type_for_path); este ADR + o SRR do check cobrem a mudança.
		"""
}
