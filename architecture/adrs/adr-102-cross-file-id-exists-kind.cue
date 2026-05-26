package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr102: artifact_schemas.#ADR & {
	id:    "adr-102"
	title: "Kind cross-file-id-exists (resolve def-002) + primeiro check sc-te-02 (relatedADR)"
	date:  "2026-05-26"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		def-002 (aberto desde 2026-05-03) registrava a falta do kind
		cross-file-id-exists: referências a ids que vivem em OUTRO arquivo (e.g.,
		tension-entry.relatedADR → id de ADR) não tinham gate determinístico — o
		cue vet valida o formato (regex adr-NNN) mas não a existência semântica
		cross-file, então um id fictício passa. Os kinds existentes cobrem
		intra-arquivo (reference-exists dict-namespace; local-field-reference-
		integrity, adr-100) e path no filesystem (filesystem-path-exists), não
		id-em-outro-artefato.

		adr-099/101 (meta-cobertura) tornaram isso visível: 8 das 29 isenções de
		sc-meta-02 eram do bucket "(def-002)" — tipos com refs cross-file cujo check
		dependia justamente deste kind. Resolver def-002 destrava a autoria
		incremental desses checks.

		Escopo deliberadamente contido (decisão do founder): construir o kind
		GENÉRICO + UM primeiro check born-green pequeno que prova o mecanismo. NÃO
		incluir events↔BC nem context↔disco neste pass — esses misturam drift real
		com BC planejado, aliases e contratos não materializados, e merecem um
		segundo pass com regra plannedIn/allowance explícita.

		Alternativa REJEITADA: estender filesystem-path-exists para aceitar ids.
		Reprovada — confunde "path existe no disco" com "id existe como entry em
		outro artefato"; são conceitos distintos e o segundo precisa montar um
		namespace de ids de um conjunto de arquivos.
		"""

	decision: """
		(1) Kind novo cross-file-id-exists (#CrossFileIdExistsRule {referencePath,
		targetGlob, targetIdPath}): todo valor em referencePath (artefato-fonte)
		deve existir no namespace montado unindo targetIdPath sobre os arquivos do
		targetGlob. Gêmeo cross-file do local-field-reference-integrity (adr-100,
		intra-arquivo). Reusa _resolve_multi + load_artifact no runner.

		(2) Primeiro check sc-te-02 (architecture/structural-checks/tension-entry.cue),
		born-warn: tension-entry.relatedADR → ids de architecture/adrs/*.cue. Caso
		nomeado no def-002, verificado born-green (5 refs, todos existem entre 99
		ADR ids).

		(3) def-002 → resolved (resolvedBy adr-102). IMPORTANTE: o que está resolvido
		é a FALTA DA CAPACIDADE — o kind genérico existe. Isso NÃO significa que
		todas as referências cross-file do repositório estão cobertas; os checks
		específicos (principlesApplied, templateRef, e os 8 tipos do bucket
		cross-file da meta-cobertura) são autorados INCREMENTALMENTE conforme cada
		caso é verificado born-green.

		(4) As 8 isenções "(def-002)" em sc-meta-02 deixam de afirmar "exige
		cross-file-id-exists (deferido)" — o kind existe; a isenção passa a valer
		"até o check específico do tipo ser autorado".

		FORA DE ESCOPO: events↔BC e context↔disco (25 contexts vs 11 dirs) — exigem
		regra plannedIn/allowance (BCs planejados não são drift); os outros checks
		nomeados no def-002 (principlesApplied, templateRef); promoção de sc-te-02 a
		reject.
		"""

	consequences: """
		Positivas: (1) a classe "id fictício cross-file que o regex aceita" passa a
		ter gate determinístico disponível; (2) o kind é reutilizável para qualquer
		ref id-em-outro-arquivo; (3) destrava a redução incremental do bucket
		cross-file da meta-cobertura; (4) sc-te-02 nasce verde como guarda de
		regressão para relatedADR.

		Negativas: (1) só UM check é autorado agora — o valor pleno depende da
		autoria incremental dos demais (honestamente declarado: o kind existir não
		cobre tudo); (2) montar o namespace exporta todos os arquivos do targetGlob a
		cada execução (custo aceitável no tamanho atual); (3) os casos de maior valor
		que motivaram olhar cross-file (events↔BC, context↔disco) ficam para um pass
		dedicado por causa do risco plannedIn — o gap permanece visível e exente
		registrado, não fechado.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"architecture/artifact-schemas/structural-check.cue",
		"scripts/ci/structural-check-runner.py",
		"architecture/structural-checks/tension-entry.cue",
		"architecture/deferred-decisions/def-002-add-cross-file-id-exists-kind.cue",
		"architecture/structural-checks/meta-coverage.cue",
	]

	principlesApplied: [
		"P10 — gate determinístico: existência de id cross-file é decidível e vira trava",
		"P0 — localização canônica: o kind vive no schema + evaluator no runner; checks declarativos",
		"adr-100 — gêmeo cross-file do local-field-reference-integrity; reusa _resolve_multi",
		"adr-099/101 — destrava a redução incremental do bucket cross-file da meta-cobertura",
		"dp-07 — sem big-bang: kind + 1 check born-green agora; demais incrementais",
	]

	supersedes: []

	rationale: """
		decisionClass structural: novo kind + rule shape no #StructuralCheck, novo
		evaluator no runner, 1 instância, resolução de def-002 e ajuste das isenções
		stale — aplica P0/P10/adr-100/adr-099 sem redefinir princípios. reversibility
		medium (aditivo, born-warn); blastRadius repo-wide (kind disponível a todo o
		repo).

		Verificado antes da proposta: cue vet ./... EXIT 0; runner --self-test PASS;
		protótipo sobre dados reais → relatedADR born-green (5/5 existem); runner
		default → sc-te-02 verde, 0 bloqueantes, exit 0. def-002 resolvido no sentido
		de capacidade (kind existe); checks específicos incrementais, NÃO cobertura
		cross-file total.
		"""
}
