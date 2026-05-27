package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr113: artifact_schemas.#ADR & {
	id:    "adr-113"
	title: "Kind instance-scoped-cross-file-id-exists + check agent-spec→domain-model; zera bucket cross-file do M2"
	date:  "2026-05-27"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		agent-spec era a última isenção cross-file do M2 (def-002), marcada
		"autorar após canonizar commands/capabilities" sob a hipótese de que teria o
		mesmo risco de vocabulário/materialização dos events (def-019). A
		investigação refutou a premissa: cada agent opera sobre o domain-model do SEU
		PRÓPRIO BC (boundedContextRef), e as refs (operationalScope.{aggregates,
		commands,events,invariants,projections} e actions[].domainModelRefs) são
		codes INTERNOS (agg-/cmd-/evt-/inv-/prj-/vo-/ent-/svc-/mod-/pol-/qry-) no
		domain-model próprio e completo do BC — não nomes canônicos cross-BC. Protótipo:
		309 refs nos 12 agentes, 0 não-resolvidas (born-green).

		O check fiel exige escopo PER-INSTÂNCIA (a ref resolve no domain-model do BC
		do agente, não na união global de domain-models — isso é o least-privilege
		tq-ag-01/tq-ag-02) sobre MÚLTIPLOS paths de code no alvo. Nenhum kind
		existente fazia as duas coisas: cross-file-id-exists usa união global e um
		único targetIdPath; scoped-cross-file-id-exists guarda por presença, não
		deriva o alvo de um campo da instância.
		"""

	decision: """
		(1) Adicionar o kind instance-scoped-cross-file-id-exists ao #StructuralCheck
		(união discriminada + #StructuralCheckKind + #StructuralCheckRule) e a rule
		shape #InstanceScopedCrossFileIdExistsRule {referencePaths[], scopeField,
		targetGlobTemplate (com {scope}), targetIdPaths[]}. Evaluator
		ev_instance_scoped_cross_file_id_exists: para cada instância, o namespace de
		ids vem do arquivo DERIVADO substituindo scopeField em targetGlobTemplate;
		toda ref em referencePaths deve existir nesse namespace per-instância (união
		de targetIdPaths). Alvo de escopo ausente no disco = violação (escopo
		fantasma), distinto do allowance do scoped-cross-file-id-exists.

		(2) Autorar sc-ag-01 (architecture/structural-checks/agent-spec.cue),
		born-warn: operationalScope + actions[].domainModelRefs → codes do
		contexts/{boundedContextRef}/domain-model.cue. Verificado born-green.

		(3) Remover agent-spec do sc-meta-02.exemptTypes. Bucket cross-file do M2:
		1 → 0 (zerado).

		FORA DE ESCOPO: promoção a reject (born-warn por ora); cobertura de
		governanceRef/boundedContextRef (outras dimensões cross-file do agent-spec —
		follow-on); direção reversa (todo building block é referenciado por algum
		agent).
		"""

	consequences: """
		Positivas: (1) refs de domain model do agent não podem mais apontar para
		building block fantasma nem vazar para outro BC — trava least-privilege
		(tq-ag-01/02) por construção; (2) o novo kind é reusável para qualquer
		"resolve no alvo derivado do meu próprio escopo" (least-privilege cross-file);
		(3) zera o bucket cross-file do M2 — toda isenção restante é (P) por-design
		ou (follow-on)/(sem instâncias), não mais "cross-file por investigar".

		Negativas: (1) born-warn — não bloqueia até promoção; (2) +1 kind na ontologia
		(custo mitigado: generaliza um padrão real, com self-test born-green/born-red);
		(3) cobre só a dimensão domain-model refs do agent-spec — governanceRef e
		boundedContextRef→canvas ficam para follow-on.
		"""

	reversibility: "high"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"architecture/artifact-schemas/structural-check.cue",
		"scripts/ci/structural-check-runner.py",
		"architecture/structural-checks/agent-spec.cue",
		"architecture/structural-checks/meta-coverage.cue",
	]

	principlesApplied: [
		"P10 — gate determinístico: existência cross-file per-BC dos refs de domain model é decidível e vira trava",
		"P0 — localização canônica: building blocks vivem no domain-model do BC; o agent referencia, não duplica",
		"adr-102/adr-105 — família cross-file-id-exists; este kind adiciona o escopo derivado-por-instância (least-privilege) que faltava",
		"adr-099 — M2: zera o bucket cross-file derivado, com cobertura comportamental real (não exemption)",
		"dp-07 — sem big-bang: born-warn, born-green; investiga a premissa do def-002 antes de autorar",
	]

	defersTo: []

	rationale: """
		decisionClass structural: +1 kind (schema+runner+self-test) + 1 instância de
		check + remoção da última isenção cross-file do M2 — refuta a premissa do
		def-002 e fecha o bucket. reversibility high (aditivo, born-warn); blastRadius
		repo-wide.

		Verificado antes da proposta: protótipo → 309 refs (operationalScope +
		domainModelRefs) dos 12 agentes resolvem no domain-model do próprio BC, 0
		não-resolvidas; cue vet ./... EXIT 0; runner --self-test PASS (caso
		born-green x resolve + born-red y flag); runner default → sc-ag-01 verde
		(born-green), sc-meta-01/02 verdes (kind tem evaluator; agent-spec coberto),
		M2 descobertos = 0, bucket cross-file 1→0, 0 bloqueantes, exit 0.
		"""
}
