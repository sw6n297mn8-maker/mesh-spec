package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr100: artifact_schemas.#ADR & {
	id:    "adr-100"
	title: "Kind local-field-reference-integrity + checks de integridade intra-arquivo do context-map"
	date:  "2026-05-26"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		adr-099 (M2) expôs ~30 tipos governados sem structural-check comportamental.
		A triagem para fechar essa lacuna revelou que os checks mais valiosos são de
		integridade referencial, e que NENHUM era expressável com os kinds existentes:
		reference-exists exige namespace = dict (o context-map usa listas);
		same-artifact-consistency via _idset só extrai id/code/name/key (os refs reais
		— relationships[].source.context, reverseRelationshipId, subdomainOwnership
		ownerContext — vivem em campos aninhados que _idset não alcança);
		filesystem-path-exists não itera listas-de-structs nem discrimina session:;
		refs cross-BC exigem o cross-file-id-exists ainda deferido (def-002). O
		gargalo é expressividade do kind, não esforço — verificado tentando autorar
		wave-plan, deferred-decision, adopted-artifacts e context-map.

		O context-map foi o tipo do drift ORIGINAL do audit (mapas que discordavam
		entre si e com o disco), então fechar sua integridade referencial tem alto
		valor. Suas referências internas mais importantes são INTRA-arquivo
		(endpoints de relationship → contexts declarados; reverseRelationshipId →
		codes de relationship; ownerContext → contexts), logo verificáveis sem
		resolução cross-file.

		Alternativa REJEITADA: estender o _idset para extrair campos arbitrários.
		Reprovada — _idset é usado por same-artifact-consistency com semântica
		'conjunto de ids de um bloco'; sobrecarregá-lo com extração de campo
		configurável misturaria dois conceitos. Um kind dedicado é mais honesto e
		segue o padrão de extensão por kind (adr-049/063/064/080/090).
		"""

	decision: """
		(1) Kind novo local-field-reference-integrity (#LocalFieldReferenceIntegrityRule
		{referencePath, namespacePath}): integridade referencial INTRA-arquivo — todo
		valor em referencePath existe no conjunto de valores em namespacePath, no
		MESMO artefato. O prefixo "local-" é deliberado: distingue do futuro
		cross-file-id-exists (def-002) e impede competição conceitual.

		(2) Resolução de path multi-valor (_resolve_multi no runner): segmento "x[]"
		itera elementos de lista OU valores de dict; "x" acessa campo aninhado.
		Generaliza reference-exists/same-artifact-consistency para refs em posições
		que o _idset rígido não alcança (e.g., relationships[].source.context).

		(3) Instâncias (architecture/structural-checks/context-map.cue), born-warn:
		    - sc-cm-01: relationships[].source.context ∈ contexts[].context
		    - sc-cm-02: relationships[].target.context ∈ contexts[].context
		    - sc-cm-03: relationships[].reverseRelationshipId ∈ relationships[].code
		    - sc-cm-04: subdomainOwnership[].ownerContext ∈ contexts[].context
		Verificadas verdes hoje (0 drift) — guardas de regressão, não débito retroativo.

		(4) Efeito na meta-cobertura (adr-099): context-map sai da lista de tipos
		descobertos do M2; M1 (evaluator-coverage) permanece verde (o kind novo nasce
		com evaluator registrado em EVAL, no mesmo commit).

		FORA DE ESCOPO: promoção de M1/M2 a reject (próximo pass, após isentar os ~29
		tipos restantes); integridade CROSS-FILE (context↔diretório de BC no disco,
		events↔BC) — requer cross-file-id-exists (def-002); aplicar o kind a outros
		tipos com refs intra-arquivo (cross-context-flow, etc.) — incremental.
		"""

	consequences: """
		Positivas: (1) o tipo do drift original ganha trava determinística de
		integridade referencial interna; (2) o kind é reutilizável para qualquer ref
		intra-arquivo em posição aninhada (destrava uma classe, não só context-map);
		(3) "local-" no nome previne colisão conceitual com def-002; (4) M1 continua
		verde por construção (kind + evaluator no mesmo commit — a própria
		meta-cobertura guarda isso).

		Negativas: (1) cobre só refs INTRA-arquivo — a integridade context↔disco
		(25 contexts declarados vs 11 BCs no disco) permanece descoberta até def-002;
		declarado explicitamente para não dar falsa sensação de cobertura total; (2)
		_resolve_multi é travessia best-effort (campo ausente => simplesmente não
		contribui valor) — não distingue 'ausente' de 'presente e inválido' além do
		conjunto namespace; suficiente para integridade de referência.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"architecture/artifact-schemas/structural-check.cue",
		"scripts/ci/structural-check-runner.py",
		"architecture/structural-checks/context-map.cue",
	]

	principlesApplied: [
		"P10 — gate determinístico: integridade referencial intra-arquivo é decidível e vira trava, não recomendação",
		"P0 — localização canônica: o kind vive no schema + evaluator no runner; instâncias declarativas, sem hardcode",
		"adr-099 — preenche a meta-cobertura: move context-map de descoberto para coberto, mantendo M1 verde",
		"adr-097 — born-warn: os 4 checks nascem não-bloqueantes; promoção por evidência",
		"adr-090/audit — fecha o drift do tipo que originou o audit (context-map), na dimensão intra-arquivo",
	]

	defersTo: ["def-002"]

	rationale: """
		decisionClass structural: novo kind + rule shape no #StructuralCheck, novo
		evaluator + resolver no runner, 4 instâncias — aplica P0/P10/adr-099/adr-097
		sem redefinir princípios. reversibility medium (aditivo, born-warn, mas desfazer
		envolve schema + runner + instâncias); blastRadius repo-wide (kind disponível a
		todo o repo). defersTo def-002: a integridade CROSS-file fica explicitamente
		para o cross-file-id-exists.

		Verificado antes da proposta: cue vet ./... EXIT 0; runner --self-test PASS;
		protótipo sobre os dados reais → 0 drift em endpoints/reverseRelationshipId/
		ownerContext (checks nascem verdes); runner default → sc-cm-01..04 verdes,
		sc-meta-01 verde, context-map fora da lista do M2 (51→50 findings em warn),
		0 bloqueantes, exit 0.
		"""
}
