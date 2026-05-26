package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr105: artifact_schemas.#ADR & {
	id:    "adr-105"
	title: "Kind scoped-cross-file-id-exists + check events↔BC built↔built (sc-cm-06); resolve def-019"
	date:  "2026-05-26"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		adr-104 deixou o vocabulário de events built↔built 100% consistente e
		canonizou a identidade de event (name=chave, producer=SoT). Faltava o gate:
		o check events↔BC do def-019.

		O cross-file-id-exists (adr-102) puro não serve aqui: ele checaria TODOS os
		relationships[].events[] do context-map contra o namespace
		(domain-model.events[].name), e falharia nos ~34 events de BC PLANEJADO
		(forward-declarations da topologia-alvo, sem domain-model ainda). Era preciso
		uma allowance que distinguisse drift real (BC construído trocando event
		indefinido) de roadmap (BC planejado).

		Alternativa REJEITADA: hardcode da lógica built↔built no runner. Reprovada —
		recriaria o débito que o adr-098 removeu (GOVERNED_ELSEWHERE). A allowance
		vive declarativa, na rule do check.
		"""

	decision: """
		(1) Kind novo scoped-cross-file-id-exists (#ScopedCrossFileIdExistsRule
		{itemsPath, guardFields, guardPresenceGlob, refField, targetGlob,
		targetIdPath}): gêmeo GUARDADO do cross-file-id-exists. Itera items de uma
		lista no artefato-fonte e checa as refs SÓ nos items cujos guardFields todos
		resolvem para entidade materializada (guardPresenceGlob com * = valor do
		guard). Items com guard não-materializado = forward-declaration, ficam fora.

		(2) Check sc-cm-06 (context-map.cue), born-warn: para cada relationship cujos
		source.context E target.context têm contexts/<bc>/domain-model.cue (built↔
		built), todo event em events[] existe em contexts/*/domain-model.cue
		events[].name. Verificado born-green (0 missing após a reconciliação do
		adr-104). Relationships tocando BC planejado ficam fora (allowance).

		(3) def-019 → resolved (resolvedBy adr-105). O check events↔BC existe sobre a
		base canônica e consistente.

		FORA DE ESCOPO: promoção de sc-cm-06 a reject; estender a built↔built quando
		BCs planejados materializarem (o check passa a cobri-los automaticamente, sem
		mudança — o guard de presença os inclui assim que o domain-model existir);
		normalização de convenção dos demais event names.
		"""

	consequences: """
		Positivas: (1) events↔BC ganha gate determinístico born-green — a peça final
		do "mapas discordam com o disco" do audit, na dimensão cross-file viável;
		(2) a allowance é DECLARATIVA (guard de presença), não hardcode; (3) o check
		se AUTO-EXPANDE: quando um BC planejado materializar seu domain-model, suas
		relationships entram no escopo sem editar o check; (4) o kind é reutilizável
		para qualquer cross-ref com forward-declarations a entidades não-materializadas.

		Negativas: (1) relationships tocando BC planejado não são checadas — esperado
		(forward-declaration), mas significa que um event fictício entre BCs planejados
		passa até materializarem; (2) o guard assume "ambos endpoints built"; um event
		cujo produtor é built mas referenciado numa relationship com endpoint planejado
		fica fora do escopo dessa relationship (coberto onde aparecer numa relationship
		built↔built); (3) mais um kind no #StructuralCheck — capacidade genuinamente
		nova (cross-ref guardado), não redundante.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"architecture/artifact-schemas/structural-check.cue",
		"scripts/ci/structural-check-runner.py",
		"architecture/structural-checks/context-map.cue",
		"architecture/deferred-decisions/def-019-events-bc-cross-file-check.cue",
	]

	principlesApplied: [
		"P10 — gate determinístico: existência cross-file de event (escopo built↔built) é decidível e vira trava",
		"P0 — localização canônica: allowance declarativa na rule; sem hardcode no runner",
		"adr-102 — gêmeo guardado do cross-file-id-exists; reusa load_artifact + _resolve_multi + dotget",
		"adr-104 — consome a base canônica de events (name) que adr-104 estabeleceu",
		"dp-07 — sem big-bang: built↔built agora; auto-expande quando planejados materializarem",
	]

	defersTo: []

	rationale: """
		decisionClass structural: novo kind + rule shape no #StructuralCheck, novo
		evaluator no runner, 1 instância, resolução de def-019 — aplica P0/P10/
		adr-102/adr-104 sem redefinir princípios. reversibility medium (aditivo,
		born-warn); blastRadius repo-wide (kind disponível ao repo).

		Verificado antes da proposta: cue vet ./... EXIT 0; runner --self-test PASS;
		runner default → sc-cm-06 verde (0 missing built↔built pós adr-104), 0
		bloqueantes, exit 0. Resolve def-019: o check events↔BC existe born-green com
		allowance declarativa para producers planejados.
		"""
}
