package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr076: artifact_schemas.#ADR & {
	id:    "adr-076"
	title: "Harden #ADR schema (decider/date/principlesApplied/tq-adr-04) + extend #StructuralCheck with at-least-one-block-present kind + sc-adr-01"
	date:  "2026-05-06"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Audit do schema #ADR e workflow de governança de ADRs revelou
		5 fragilidades estruturais que permitem ADRs problemáticos passar
		validation determinística:

		(1) decider frouxo: tipado como string non-empty permite qualquer
		    valor — quebra governança ('founder' canônico hoje, 'agt-*'
		    forward-compatible para agente futuro).

		(2) date valida apenas formato ISO YYYY-MM-DD via regex
		    [0-9]{4}-[0-9]{2}-[0-9]{2} — não valida boundaries
		    de mês/dia (e.g., '2026-99-99' passa).

		(3) principlesApplied é lista de strings non-empty sem padrão
		    enforced — referências livres podem ser inconsistentes.

		(4) ADR pode existir sem impacto rastreável: se affectedArtifacts
		    está vazio E plannedOutputs ausente E derivedArtifacts
		    ausente, ADR é decoração sem rastreabilidade. Comentário
		    histórico no schema (line ~71-74) admite explicitamente:
		    'discipline narrative em PG-ADR (não enforced por schema
		    dado limites de disjunção CUE sobre fields opcionais)'.

		(5) Schema #StructuralCheck atual (7 kinds) não suporta
		    constraint 'at-least-one-of-N' declarativamente — required-
		    block expressa apenas single-block; 3 sc separadas com
		    required-block forçariam AND (todos presentes), não OR
		    (at least one). Gap impede materializar enforcement
		    determinístico de tq-adr-04 via structural-check.

		Founder review propôs 5 mudanças cirúrgicas (sessão 2026-05-06)
		alinhadas ao princípio: 'quando CUE não consegue expressar a
		regra, o enforcement deve subir para CI — não virar convenção.'
		"""

	decision: """
		ADOPT 6 mudanças coordenadas (5 founder approved + 1 derivada
		empiricamente):

		(D1) #Decider typed alias em #ADRBase. Definição:
		     #Decider: \"founder\" | (string & =~\"^agt-[a-z][a-z0-9-]*$\")
		     decider campo: decider: #Decider
		     Forward-compatible com agente decider; restritivo o
		     suficiente para enforcement.

		(D2) Date regex stricter em #ADRBase. Boundaries de mês/dia
		     enforced via:
		     date: string & =~\"^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$\"
		     Comentário explicita limitação remanescente: NÃO valida
		     calendário real (Feb 30 ainda passa); validação completa
		     de calendário é responsabilidade do CI.

		(D3) principlesApplied regex enforcing identifier prefix em
		     #ADRBase:
		     principlesApplied: [
		         string & =~\"^[A-Za-z][A-Za-z0-9-]+\",
		         ...string & =~\"^[A-Za-z][A-Za-z0-9-]+\",
		     ]
		     Permissivo o suficiente para retrocompatibilidade com 75
		     ADRs existentes (estilos 'P1', 'P10', 'dp-04', 'ten-009',
		     mix de uppercase/lowercase identifiers seguidos por
		     separator opcional + prose). Identifier prefix mínimo
		     2 chars; enforce ZERO-prose, identifier-first discipline.

		(D4) tq-adr-04 quality criterion adicionado em
		     #ADRBase._qualityCriteria.criteria:
		     id: 'tq-adr-04', severity: 'fail', description e test
		     articulam: ≥1 dos 3 blocos affectedArtifacts/
		     plannedOutputs/derivedArtifacts presente non-empty.
		     Constraint at-least-one NÃO enforce-ável em CUE schema
		     (closed-struct semantics + limites de disjunção sobre
		     optional fields); enforcement determinístico via
		     sc-adr-01 (kind at-least-one-block-present, decision D5).

		(D5) Extend #StructuralCheck schema com novo kind
		     at-least-one-block-present + #AtLeastOneBlockPresentRule
		     em architecture/artifact-schemas/structural-check.cue.
		     Rule shape: blockNames: [string, string, ...string]
		     (min 2 nomes; degenerate single-name = required-block
		     existente). Layered enforcement explicitada: schema
		     valida CONTEÚDO de elementos (string non-empty
		     constraints); structural-check valida EXISTÊNCIA do
		     bloco como lista non-empty.

		(D6) Create sc-adr-01 instance em architecture/structural-checks/
		     adr.cue usando kind at-least-one-block-present sobre
		     blockNames: [affectedArtifacts, plannedOutputs,
		     derivedArtifacts]. Materializa enforcement determinístico
		     de tq-adr-04 via gate CI bloqueante.

		REJEITADA por descoberta empírica:
		Item original founder #1 (remover supersededBy? duplicado de
		#ADRBase). Tentativa empírica quebrou 4 ADRs com
		status=superseded (adr-016/017/029/044). Diagnóstico:
		CUE closed-struct semantics impede unions de adicionar
		fields novos a definitions — apenas refinamento (narrowing)
		permitido. Padrão correto: declarar supersededBy? em
		#ADRBase (open slot) + narrowing em #ADR union (forbidden
		via _|_ em branches non-superseded; required em branch
		superseded). Comentário canônico founder adicionado:
		\"NOTE: supersededBy MUST be declared in #ADRBase because
		CUE unions cannot introduce new fields into closed
		structs.\" Falsa-duplicação revelou-se structural requirement
		do type system; manter como está.

		ALTERNATIVES REJEITADAS:

		(A) Manter schema atual + 5 def-XXX entries para 5
		    fragilidades. Rejeitada: governance frágil; schema
		    permanece flexível demais; pre-PMF é momento de fechar
		    classes de erro, não documentar como debt.

		(B) Script CI ad-hoc (scripts/ci/check-adr-impact.sh) em
		    vez de extending #StructuralCheck schema com new kind.
		    Rejeitada: extending schema com kind reusable é cleaner
		    long-term; new kind 'at-least-one-block-present' é
		    primitive útil cross-artifact (BC schemas, AgentSpec
		    schemas, etc futuros — pattern emerge).

		(C) Defer sc-adr-01 enforcement via def-014 (apenas
		    tq-adr-04 quality criterion + manual review). Rejeitada:
		    quality criterion sem CI structural-check enforcement
		    é heuristic; founder explicit principle 'enforcement
		    deve subir para CI — não virar convenção'.

		(D) Open #ADRBase via _#ADRBase hack para honrar intent
		    original do item rejeitado. Rejeitada: quebra
		    encapsulamento; cria comportamento implícito; dificulta
		    leitura/manutenção; não resolve problema, só contorna.
		"""

	consequences: """
		Schema modifications (zero breaking change empiricamente
		verificado contra 75 ADRs existentes):
		- adr.cue: #Decider typed + date stricter + principlesApplied
		  regex + tq-adr-04 + supersededBy NOTE canônico
		- structural-check.cue: novo kind at-least-one-block-present
		  + #AtLeastOneBlockPresentRule shape

		Novos artefatos:
		- architecture/structural-checks/adr.cue (sc-adr-01)
		- adr-076 + SRR

		Validation retroativa:
		- 75 ADRs passam novas regex (decider 'founder', date 2026-XX-XX,
		  principlesApplied identifier prefix)
		- 75 ADRs passam sc-adr-01 (cada um tem ≥1 dos 3 blocos)

		Layered enforcement materializado:
		- Schema #ADR enforça shape + content (cada element string
		  non-empty)
		- structural-check sc-adr-01 enforça existência (≥1 bloco
		  presente non-empty)
		- CI runner integrate sc-adr-01 como gate bloqueante

		Princípio canônico estabelecido (founder Phase 5):
		'Quando CUE não consegue expressar a regra, o enforcement
		deve subir para CI structural-check — não virar convenção.'
		Reusable pattern para constraints at-least-one-of-N futuros.

		Forward-looking: novo kind 'at-least-one-block-present' pode
		ser reaproveitado para outras schemas com constraints
		similares (BC canvas, AgentSpec, etc.) sem schema extension
		adicional.

		Reversibilidade da decisão:
		- Schema additions optional sem breaking change (regex
		  changes retroativamente compatíveis verificados)
		- sc-adr-01 pode ser removido sem impactar schema
		- Pode ser superseded por adr futura se padrão evoluir
		"""

	affectedArtifacts: [
		"architecture/artifact-schemas/adr.cue",
		"architecture/artifact-schemas/structural-check.cue",
	]

	plannedOutputs: [
		"architecture/structural-checks/adr.cue",
	]

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	rationale: """
		Reversibilidade medium: schema additions são optional/non-
		breaking (regex changes verificadas retrocompatíveis com 75
		ADRs); reverter exigiria remoção de tq-adr-04 + sc-adr-01 +
		new kind sem migration de instâncias (zero impact). NÃO é
		high (zero migration; mas escopo cross-cutting) nem low
		(no data persistido, no contracts públicos).

		BlastRadius cross-cutting: 2 schemas afetados (adr.cue +
		structural-check.cue) governando 75 ADRs existentes + todos
		ADRs futuros + structural-check kinds disponíveis para
		outros artifact types. Não é local (single artifact) nem
		repo-wide (não toca core principles/lenses); cross-cutting
		reflete escopo schema evolution multi-artifact.

		Princípios aplicados:
		- P1 (CUE como SoT): schema declara contracts auditáveis
		  (typed enums, regex constraints, discriminated unions);
		  cue vet + structural-check enforça antes de runner.
		- P10 (gates determinísticos validam, agentes recomendam):
		  schema é gate (declaração); structural-check é gate
		  (enforcement determinístico); CI runner executa.
		- ten-009 (expand-when-needed): novo kind
		  at-least-one-block-present introduzido sob necessidade
		  empírica (sc-adr-01 + identifier que pattern reusable
		  pode emergir cross-artifact).
		"""

	principlesApplied: [
		"P1 (CUE como SoT — schema declara contracts auditáveis)",
		"P10 (gates determinísticos validam, agentes recomendam — schema + structural-check são gates)",
		"ten-009 (expand-when-needed — novo kind sob necessidade empírica)",
	]
}
