package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr063: artifact_schemas.#ADR & {
	id:    "adr-063"
	title: "Adicionar kind filesystem-path-exists ao framework structural-check"
	date:  "2026-05-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		WI-068 (criar 5 structural-checks ausentes para tipos governados)
		expôs gap mecânico análogo ao detectado em adr-049 + adr-056:
		o framework structural-check em V1 (adr-041) deliberadamente
		minimal cobre apenas regras within-artifact ou conditional-file-
		presence. Casos concretos do WI-068 exigem verificação de
		existência de path no filesystem como referência semântica de
		artefato — fora do escopo dos 5 kinds existentes:

		- self-review-report.artifactPath: path para artefato sob review;
		  se não existe, report é órfão (review de algo que não existe).
		- tension-entry.manifestsIn: path para artefato onde tensão é
		  observável; se não existe, manifestation é especulativa
		  (tq-te-03 captura semantically; structural-check captura
		  determinístico).
		- adopted-artifacts.artifacts[*].artifact: path local do artefato
		  adotado; se não existe, manifest declara adoção de algo
		  ausente.

		Sessão 2026-05-03 (claude/resume-mesh-work-jv2MC) também
		discutiu Opção B do WI-068: 1 novo kind filesystem-path-exists +
		2 deferimentos formais (cross-file-id-exists, regex-pattern-
		match) registrados no novo sistema deferred-decision (per
		adr-062). Decisão de adicionar exatamente este kind foi
		founder-approved após 3 rounds de red-team da arquitetura
		deferred-decision como pré-requisito.

		Alternativas consideradas e rejeitadas:

		(a) Estender conditional-file-presence (adr-049) para suportar
		o caso 'path do artifact field deve existir'. Rejeitada:
		conditional-file-presence é para presença CONDICIONAL baseada
		em campo booleano (e.g., hasSyncSurface → api.yaml deve
		existir). Caso aqui é INCONDICIONAL (artifactPath SEMPRE deve
		existir). Forçar via condition=true sempre é hack; semântica
		do kind se dilui.

		(b) Aceitar como advisory check apenas (validation-prompt) e
		não criar kind structural. Rejeitada: validation-prompts são
		advisory (per adr-040). Existência de path é dimensão
		determinística — pertence ao gate structural per adr-040
		split. self-review-report sem artifactPath real é problema
		que cue vet pode catch via filesystem inspection; advisory
		só é apropriado quando dimensão é interpretativa.

		(c) Não criar kind, deixar gap aberto. Rejeitada: WI-068
		identificou múltiplos casos concretos onde o check é necessário.
		Continuar sem kind perpetua o gap. adr-040 split deteriora
		quando casos legitimamente structural são tratados como
		advisory por falta de mecanismo.

		(d) Criar kind genérico cross-file-reference que cobriria
		filesystem-path-exists + cross-file-id-exists + outros casos.
		Rejeitada: per adr-041 minimalismo deliberado, kinds devem
		ser narrow e específicos. Generic kind dilui semantics; cada
		caso futuro adiciona complexity à rule shape única. Pattern
		estabelecido (adr-049, adr-056) é kind-by-kind narrow.

		Casos NÃO cobertos por filesystem-path-exists (registrados
		formalmente como deferimentos via novo sistema deferred-
		decision per adr-062):

		- cross-file-id-exists: lookup de id em outro arquivo (e.g.,
		  principlesApplied de ADR refers IDs em design-principles.cue).
		  Registrado em def-002.
		- regex-pattern-match: validar que valor de campo conforma a
		  regex (e.g., self-review-report.artifactSchemaPath match
		  canonicalPathRegex do tipo). Registrado em def-003.
		"""

	decision: """
		Estender #StructuralCheck adicionando 1 novo kind:

		(1) [kind-extension] Adicionar 'filesystem-path-exists' ao
		discriminator #StructuralCheckKind e à união discriminada de
		#StructuralCheck. Pattern paralelo a adr-049 + adr-056.

		(2) [rule-shape] Definir #FilesystemPathExistsRule com 2 fields:
		  - sourcePath: dot-path do campo no artefato sob validação
		    contendo o path a verificar (string ou lista de strings).
		  - isList: bool default false; true quando sourcePath aponta
		    para list of strings (runner itera).

		Runner futuro (não escopo deste ADR; per adr-040 + adr-041
		gating é forward-looking) lê sourcePath via parsing CUE,
		extrai value(s), verifica os.path.exists para cada.

		Aplicação imediata desta extensão (instâncias criadas no MESMO
		commit que esta ADR per pattern adr-056):
		- sc-srr-01 (self-review-report.artifactPath): single string,
		  isList=false.
		- sc-te-01 (tension-entry.manifestsIn): single string,
		  isList=false.

		Aplicação adicional NO MESMO commit usando kinds atuais (não
		nova extensão; same-artifact-consistency já existe per adr-041):
		- sc-pg-02 (production-guide.workOrder elements ∈ sections keys)
		- sc-pg-03 (production-guide.sections keys ∈ workOrder elements)
		Ambos same-artifact-consistency direção unidirecional;
		bidirecional via 2 checks porque relation é one-way.

		Esta decisão NÃO cobre casos com nested iteration ou cross-file
		semantics — registrados como deferimentos:
		- def-002 (cross-file-id-exists kind futuro)
		- def-003 (regex-pattern-match kind futuro)

		ADR usa novo field defersTo: [def-002, def-003] (per adr-062
		extension). Primeira ADR pós-adr-062 a aplicar o pattern de
		defersTo em vez de prose.
		"""

	consequences: """
		Positivas:
		(P1) WI-068 cobertura parcial materializada em commit único.
		4 structural-checks novos (sc-srr-01, sc-te-01, sc-pg-02,
		sc-pg-03). Tipos cobertos: self-review-report, tension-entry,
		production-guide.

		(P2) Pattern reusable: filesystem-path-exists serve futuras
		instâncias além das 2 iniciais (e.g., adopted-artifacts
		quando nested iteration kind for adicionado).

		(P3) Maintain framework minimalism per adr-041: kinds narrow
		específicos. Não criar generic catch-all.

		(P4) Primeira aplicação real do sistema deferred-decision
		(adr-062): def-002 + def-003 registram formalmente o que NÃO
		está sendo coberto AGORA, com triggers codificados de revisita.
		Substitui prose 'Known gaps declarados' por instâncias
		queryable.

		(P5) Primeira ADR pós-adr-062 a usar field defersTo em vez de
		prose. Estabelece convention forward-looking.

		Negativas:
		(N1) Schema #StructuralCheck cresce 5 → 6 kinds. Pattern
		estabelecido em adr-049 + adr-056 prevê expansão orgânica;
		custo é proporcional ao caso concreto que justifica.

		(N2) Runner não foi atualizado para suportar novo kind
		(framework é forward-looking per adr-040/041). Estado esperado:
		instâncias declaradas latentes até runner futuro consumir.

		(N3) Nested iteration sobre lists of structs (e.g., adopted-
		artifacts.artifacts[*].artifact) NÃO suportado em V1 do kind.
		Workaround necessário em casos como adopted-artifacts.

		Known gaps declarados (não omitidos):
		- sc-adr-affectedArtifacts: paths em ADR.affectedArtifacts
		  podem ser future-created via plannedOutputs no MESMO commit.
		  Pure file-exists insuficiente — semântica é 'exists OR is
		  in plannedOutputs/derivedArtifacts of this same ADR'.
		  Nenhum kind atual captura. Aguarda kind ainda mais nuanced
		  ou refinement de filesystem-path-exists com 'OR-in-list'
		  semantics. NÃO formalizado como def-XXX porque critério
		  de revisita não está claro o suficiente; pode virar def
		  futuro se padrão recorre em N+ ADRs.
		- sc-aa-artifact (adopted-artifacts.artifacts[*].artifact):
		  nested iteration sobre list of structs. filesystem-path-
		  exists v1 NÃO suporta sourcePath com glob/wildcard.
		  Aguarda extension do kind ou novo kind list-iteration.
		  NÃO formalizado como def-XXX por mesma razão (critério
		  ainda fuzzy).
		- sc-te-tensionTarget (path-or-axiom): tension-entry.
		  tensionTarget regex aceita ax-XX/dp-XX/PX (axiom IDs)
		  OU paths .cue. file-exists só faz sentido para path
		  values; precisa skip-if-axiom-pattern. NÃO formalizado
		  como def-XXX por mesma razão (critério ainda fuzzy).

		Estes 3 known gaps NÃO viram def-XXX agora porque founder
		decidiu (sessão 2026-05-03) que critério de revisita ainda
		não está calibrado o suficiente para trigger codificado.
		Podem virar def-XXX se padrão recorrer em N+ casos. Documentação
		em prose 'Known gaps declarados' é grandfathering pattern
		até critério materializar.

		Fronteira regulatória: nenhuma. Decisão é meta-estrutural
		sobre framework de validação interno.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/structural-check.cue",
		"architecture/structural-checks/production-guide.cue",
	]

	plannedOutputs: [
		"architecture/structural-checks/self-review-report.cue",
		"architecture/structural-checks/tension-entry.cue",
		"architecture/deferred-decisions/def-002-add-cross-file-id-exists-kind.cue",
		"architecture/deferred-decisions/def-003-add-regex-pattern-match-kind.cue",
	]

	defersTo: [
		"def-002",
		"def-003",
	]

	principlesApplied: [
		"P0",
		"P1",
		"P10",
		"P12",
	]

	supersedes: []

	rationale: """
		Princípios aplicados:

		P10 (gates determinísticos validam, agentes recomendam) é o
		driver primário: existência de path é dimensão determinística
		por construção (filesystem state). Pertence ao gate structural
		per adr-040 split, não advisory. Tratar como advisory seria
		categórico erro do split.

		P12 (governança como código): kind filesystem-path-exists
		formaliza disciplina que antes era prose ('artifactPath
		deve existir'). Schema enforce shape; runner futuro enforce
		semantics.

		P0 (uma localização canônica): filesystem-path-exists é a
		localização canônica para esse tipo de check. Não dispersa
		semantics em múltiplos kinds.

		P1 (CUE como SoT): kind + rule shape declarativos em CUE
		schema; runner consome shape.

		Failure mode evitado: gap entre intent ('artifactPath deve
		existir') e enforcement (nenhum mecanismo) — produz drift
		silencioso (artifactPath especulativo passa cue vet, falha
		downstream quando consumidor tenta abrir o arquivo).

		Tensão com axiomas: nenhuma tensão substantiva.

		Lenses consultadas:

		lens-real-options: postergar adição de cross-file-id-exists
		e regex-pattern-match (def-002, def-003) é exercício de real
		option. Casos atuais não justificam todos os 3 kinds; adicionar
		cada quando concrete need materializar respeita custo-de-
		complexity.

		Relação com outras ADRs:

		- DESCENDS adr-041 (V1 minimal framework). Primeiro extension
		  pattern foi adr-049 (conditional-file-presence); segundo
		  adr-056 (production-guide-coverage); terceiro este (filesystem-
		  path-exists). Pattern estabelecido para expansion incremental.
		- DESCENDS adr-040 (validação split). filesystem-path-exists é
		  determinístico — encaixa em structural side per split.
		- USA adr-062 defersTo field. Primeira ADR pós-adr-062 a
		  aplicar pattern (vs prose 'Known gaps').
		- ENABLES def-002, def-003 (deferimentos formalmente
		  registrados via sistema novo).
		- SEM supersession.

		Justificativa de risk metadata:

		decisionClass='structural': adiciona kind ao framework cross-
		cutting; afeta todos os structural-checks futuros que possam
		querer file-exists semantics.

		reversibility='high': remoção do kind é trivial enquanto
		instâncias forem poucas (2 iniciais + qualquer uso futuro).
		Diferente de adr-040 ou adr-053 que são foundational.

		blastRadius='cross-artifact': toca artifact-schema (kind +
		rule), structural-checks (instâncias), e indiretamente os 3
		tipos cobertos (self-review-report, tension-entry, production-
		guide). Não atinge BCs nem domain.
		"""
}
