package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr103: artifact_schemas.#ADR & {
	id:    "adr-103"
	title: "Kind filesystem-declared-coverage + check disco→context-map (sc-cm-05); defer events↔BC (def-019)"
	date:  "2026-05-26"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		O "mapas discordam com o disco" do audit, na dimensão cross-file, foi
		investigado a fundo para gatear o que faltava. O resultado reenquadrou o
		problema:

		(1) context↔disco NÃO é drift no sentido esperado. O context-map declara a
		topologia-ALVO (25 BCs); 11 estão materializados, 14 são roadmap (ato, drc,
		fce, ...). O mapa estar à frente do disco é por design. A única direção com
		sentido de drift — disco→map (todo BC no disco está declarado) — está
		born-green (0 dir não-declarado).

		(2) events↔BC é prematuro. Nenhum BC materializou events como artefato
		estruturado (sem events/commands/schemas; só canvas/domain-model/glossary).
		Os 44 events referenciados são forward-declarations; não há fonte canônica de
		ids para checar. Gatear agora seria quase todo falso-positivo.

		Ou seja: a "montanha de drift cross-file" que parecia existir é, hoje,
		majoritariamente roadmap + spec incompleta. O único drift real e gateável é
		"BC no disco sem declaração no mapa", e ele exige um mecanismo que os kinds
		existentes não têm: enumerar o filesystem e exigir declaração no artefato
		(inverso do cross-file-id-exists, que lê refs DE um artefato).

		Alternativa REJEITADA: gatear context-map→disco (todo context declarado tem
		dir) com allowance plannedIn. Reprovada — os 14 sem dir são roadmap
		intencional; não há drift a pegar nessa direção, só ruído. Allowance
		complexa sem ganho.
		"""

	decision: """
		(1) Kind novo filesystem-declared-coverage (#FilesystemDeclaredCoverageRule
		{pathGlob, targetGlob, targetIdPath}): ENUMERA paths do filesystem (pathGlob;
		segmento "*" captura o id via glob_capture) e exige que cada id esteja
		DECLARADO no namespace de um artefato (targetGlob + targetIdPath). Inverso do
		cross-file-id-exists. Direção segura: NÃO exige o inverso, então entidades
		declaradas-mas-não-materializadas (roadmap) não geram falso-positivo.

		(2) Check sc-cm-05 (context-map.cue), born-warn: todo contexts/*/ está em
		context-map.contexts[].context. Verificado born-green (0 não-declarado).
		Fecha o "mapas discordam com o disco" do audit na direção real e segura.

		(3) def-019 (open): defere o check events↔BC (cross-file-id-exists) até os
		events materializarem como artefato estruturado com fonte canônica de id.
		Trigger manual-review (sem path único machine-evaluable hoje). Honesto: o gap
		fica visível e registrado, não fingido como coberto.

		FORA DE ESCOPO: events↔BC agora (def-019); context-map→disco (não é drift);
		promoção de sc-cm-05 a reject.
		"""

	consequences: """
		Positivas: (1) o drift real "BC no disco sem declaração no mapa" passa a ter
		gate determinístico born-green; (2) o kind é reutilizável para qualquer
		"entidade no filesystem deve ser declarada num registro autoral"; (3) a
		direção segura evita o falso-positivo de roadmap por construção; (4) o gap
		events↔BC fica governado (def-019) em vez de esquecido.

		Negativas: (1) sc-cm-05 cobre só a direção disco→map — a completude do mapa
		vs a arquitetura-alvo (os 14 planejados) não é gateável (nem deveria); (2)
		events↔BC continua sem gate até materialização (def-019) — declarado
		explicitamente; (3) mais um kind no #StructuralCheck (ontologia cresce), mas
		é capacidade genuinamente nova (filesystem→artefato), não redundante.
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
		"P10 — gate determinístico: 'BC no disco declarado no mapa' é decidível e vira trava",
		"P0 — localização canônica: kind no schema + evaluator no runner; check declarativo",
		"adr-102 — inverso do cross-file-id-exists; reusa glob_capture + _resolve_multi + load_artifact",
		"adr-062 — deferimento consciente: events↔BC vira def-019 com trade-off e trigger, não gap esquecido",
		"dp-07 — sem big-bang: gateia a direção born-green agora; events quando materializar",
	]

	defersTo: ["def-019"]

	rationale: """
		decisionClass structural: novo kind + rule shape no #StructuralCheck, novo
		evaluator no runner, 1 instância, 1 deferred-decision — aplica P0/P10/adr-102
		sem redefinir princípios. reversibility medium (aditivo, born-warn);
		blastRadius repo-wide. defersTo def-019 (events↔BC).

		Verificado antes da proposta: investigação sobre dados reais (disco→map
		born-green; 14 contexts planejados; events não materializados); cue vet
		./... EXIT 0; runner --self-test PASS; runner default → sc-cm-05 verde, 0
		bloqueantes, exit 0.
		"""
}
