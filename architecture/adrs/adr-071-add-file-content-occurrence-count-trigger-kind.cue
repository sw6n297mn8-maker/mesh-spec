package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr071: artifact_schemas.#ADR & {
	id:    "adr-071"
	title: "Add file-content-occurrence-count trigger kind to #DeferredDecision (singleton-file-only)"
	date:  "2026-05-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		State-of-affairs precedente:
		- adr-070 promove #BootstrapException a schema first-class +
		  cria def-012 (stale detection structural-check deferimento).
		- def-012 precisa trigger automático para signaling de
		  crescimento da categoria pre-mapping-transient.
		- Trigger ideal: conta occurrences de 'lifecycle: "transient"'
		  dentro de self-review-bootstrap-policy.cue (singleton).
		  Threshold conservador (e.g., 20) fires quando categoria
		  cresce além de baseline atual (14).

		Limitação descoberta no runner existente:
		- scope=file-content (kind=recurrence) usa
		  'git grep -l -E pattern' que conta ARQUIVOS contendo o
		  pattern, não OCCURRENCES dentro de arquivos. Para singleton
		  governance file (apenas 1 arquivo contém o pattern), count
		  é sempre 0 ou 1 — threshold > 1 nunca dispara.
		- Outros kinds existentes (recurrence scope=filename, adjacent-
		  need, volume-threshold, temporal, manual-review) não cobrem
		  semantica 'count occurrences within single file'.

		Use case originador (n=1):
		- def-012 monitora crescimento de transient bootstrap
		  exceptions. Pattern: 'lifecycle:\\s+"transient"' dentro de
		  self-review-bootstrap-policy.cue. Threshold=20 fires +6
		  acima de baseline atual.

		Pattern ten-009 expand-when-needed normalmente sugere aguardar
		n=2 antes de generalizar trigger kind. Aqui expandimos em n=1
		porque alternative (drop automation, manual-review only)
		perderia signal valioso, e use case (counting occurrences in
		singleton governance files) é genérico o suficiente para
		reasonably emerge novamente em outros casos (e.g., counting
		policies em singleton policy file, counting rollout entries
		em singleton authoring-policy.cue, etc.).

		Alternativas avaliadas:
		(a) Drop automation; def-012 com manual-review only —
		rejeitada: founder articulou em adr-070 active reconsideration
		culture; manual-review only para problema mecanicamente
		monitorável é regression vs design intent.
		(b) Workaround creative com kind existente — rejeitada:
		nenhum kind existente captura 'occurrences in single file'
		corretamente. Tentativas de proxy (e.g., file-contains
		boolean) perdem count semantics.
		(c) Adicionar nova RecurrenceScope (e.g., 'occurrences-in-
		file') ao kind existente recurrence — rejeitada: scope
		atual define ONDE buscar (filename/file-content/commit-
		message); 'occurrences-in-file' seria mistura semantic
		conflicting (precisaria também especificar path como param,
		que outros scopes não usam). Discriminated union por kind é
		mais limpa.
		(d) Schema first-class para kind único + restriction
		documentada (escolhido) — preserva separação de concerns +
		permite restriction explícita em uso.
		"""

	decision: """
		(1) ESTENDER schema #Trigger em
		architecture/artifact-schemas/deferred-decision.cue
		adicionando 6º kind:
		    {kind: "file-content-occurrence-count",
		     path: string & =~"^.+/.+$",
		     pattern: string & !="",
		     threshold: int & >=1}

		(2) DOCUMENTAR USO RESTRITO em comment do schema:
		file-content-occurrence-count É TRIGGER DE SINGLETON
		GOVERNANCE FILE, NÃO MECANISMO GERAL DE BUSCA NO REPO.
		Aplicar apenas quando:
		- há um arquivo canônico único
		- o sinal é quantidade de ocorrências dentro desse arquivo
		- recurrence scope=file-content não serve porque conta
		  arquivos não occurrences
		Este wording é literal no comment do schema (governance/
		build-time prose) — evita abuso futuro do kind por agentes
		ou founder esquecidos do contexto de origem.

		(3) ESTENDER runner em scripts/ci/evaluate-deferred-
		triggers.sh com handler:
		    elif kind == "file-content-occurrence-count":
		        path = trigger["path"]; pattern = trigger["pattern"];
		        threshold = trigger["threshold"]
		        text = open(path).read()
		        count = len(re.findall(pattern, text))
		        if count >= threshold: fire
		Path: arquivo único (não glob); FileNotFoundError → count=0
		(transient case durante migration). Usa re.findall (não
		re.match) para contar todas occurrences.

		(4) APLICAR a def-012: trigger automático conservador
		threshold=20 (baseline=14, +6 para fire) + manual-review
		fallback.

		(5) ESCOPO EXCLUÍDO: este ADR NÃO inclui sc-be-01 (stale
		detection); deferido per def-012. NÃO inclui generalização
		para multi-file ou glob path; deferido até 2nd use case
		emergir.

		(6) CONDIÇÕES PARA REVISITA FUTURA:
		(a) Vindication: se 2+ casos adicionais surgirem dentro de
		    N meses (e.g., outras singleton governance files com
		    occurrence-count signal — task-governance.cue counters,
		    authoring-policy.cue rollout entries), expansion era
		    justificada. Pattern repetido valida generalização at
		    n=1.
		(b) Over-built revisit: se nenhum 2nd case emergir após 3+
		    next path-mapping ADRs (adr-072 onward) OR se def-012
		    for resolved sem que kind seja reutilizado, considerar
		    whether kind era especulação. Possíveis ações:
		    deprecate kind; absorver em manual-review com runner
		    workaround; reduzir flexibility (e.g., remover do schema
		    + revert runner).
		(c) Scope expansion adicional: se path glob (path: string
		    padrão único arquivo) ficar restritivo, considerar
		    suportar glob (path-pattern). Adiar enquanto 1 path
		    único cobre todos casos.
		(d) Calibração threshold de def-012: se em prática threshold
		    é atingido rapidamente (e.g., 1-2 path-mapping ADRs),
		    threshold pode ser elevado em revisita; se nunca
		    atingido, threshold pode ser reduzido OR def-012
		    withdrawn (problema dissolvido).
		"""

	consequences: """
		Positivas:

		(P1) def-012 ganha trigger automático genuíno (não fake
		manual-review com reason de longo). Volume da categoria
		pre-mapping-transient passa a ser monitorada continuamente
		em CI sem custo cognitivo de founder.

		(P2) Schema #Trigger expande com kind genérico o suficiente
		para outros casos similares (singleton governance files com
		occurrence-count signal). Reusable.

		(P3) Documentação restritiva no comment + adr-071 rationale
		evitam abuso futuro do kind para casos que recurrence
		scope=file-content cobriria adequadamente.

		(P4) Conditions-for-revisit explícitas (decisão item 6)
		permitem assessment futuro de se a generalização at n=1 foi
		justificada — accountability without paralysis.

		Negativas:

		(N1) Generalização at n=1 viola pattern ten-009 expand-when-
		needed strictly. Mitigação: rationale articula trade-off
		(perder signal vs especulação); revisit conditions explícitas
		permitem retroactive assessment.

		(N2) Schema area cresce: 6º kind no #Trigger union. Mitigação:
		discriminated union scales — adding kind n+1 não impacta
		existing kinds (CUE check é local por kind).

		(N3) Runner code path adicional: maintenance overhead.
		Mitigação: ~12 linhas Python; testável isoladamente; align
		com pattern existente de outros kinds.

		Known gaps declarados:
		- Generalização at n=1: revisita conditions explícitas em
		  decision item 6.
		- Path glob support: deferido até 2nd use case com path
		  padrão emergir.
		- Multi-file occurrence-count: deferido até use case
		  emergir.

		Fronteira regulatória: nenhuma. Decisão é meta-estrutural
		sobre trigger kind do deferimento.
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/artifact-schemas/deferred-decision.cue",
		"scripts/ci/evaluate-deferred-triggers.sh",
	]

	plannedOutputs: []

	principlesApplied: [
		"P10",
		"P12",
	]

	supersedes: []

	rationale: """
		Princípios aplicados:

		P12 (governança como código): schema bump + runner extension
		são veículos declarativos para nova capability de trigger
		evaluation. Restriction documentada em comment é code-as-
		documentation.

		P10 (gates determinísticos validam): runner determinístico
		passa a cobrir caso 'occurrence count in singleton file'.
		Gate determinístico ao invés de discipline manual.

		Sem axiomas tensionados.

		Lenses consultadas:

		lens-real-options: generalização at n=1 é trade-off
		consciente — preserva opção (kind reusable) com custo
		controlado (12 linhas runner + comment docs + revisita
		conditions). Custo de NÃO generalizar (drop automation OR
		creative workaround) é perda de signal valioso documentado
		em adr-070.

		Relação com outras ADRs:

		- COUPLED COM adr-070 (mesmo commit; adr-070 cria def-012
		  que usa este kind).
		- DESCENDS adr-062 (schema #DeferredDecision +
		  #Trigger union).
		- PRECEDE potential ADR para sc-be-01 (stale detection
		  structural-check) quando def-012 trigger fire.
		- SEM supersession.

		Justificativa de risk metadata:

		reversibility 'high': adicionar kind ao discriminated union
		é puramente aditivo; reversão é remover kind + revert runner
		handler. Nenhuma instância existente afetada (def-012 é
		criada nesta ADR).

		blastRadius 'cross-cutting': afeta todos #DeferredDecision
		instances (10 atuais + future). Cross-cutting via
		availability do kind, não via mandatory adoption.
		"""
}
