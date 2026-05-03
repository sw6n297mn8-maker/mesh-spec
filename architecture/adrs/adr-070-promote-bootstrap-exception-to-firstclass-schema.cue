package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr070: artifact_schemas.#ADR & {
	id:    "adr-070"
	title: "Promote #BootstrapException to first-class schema with category + lifecycle + exitCondition"
	date:  "2026-05-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		State-of-affairs precedente:
		- adr-067 introduziu 3ª categoria de bootstrap exception
		  (pre-mapping-transient) com 4 entries em batch único.
		- def-011 difere promoção a schema first-class (campos
		  category, lifecycle, exitCondition + structural-check de
		  stale detection) per pattern ten-009 expand-when-needed:
		  volume insuficiente em n=1.
		- adr-068 adicionou 1 entry transient (canvas.cue, total=5);
		  trigger fire #1 (count 3→4 em adr-068).
		- adr-069 adicionou 9 entries transient (9 VPs, total=14);
		  trigger fire #2 (count 4→5 em adr-069). Founder articulou
		  em adr-069 Known gaps: 'After this commit, def-011 should
		  be actively reconsidered before the next path-mapping ADR.'

		Active reconsideration de def-011 (2026-05-03 pré-canvas
		path-mapping):
		- Volume cumulativo da categoria pre-mapping-transient = 14
		  entries (4 PGs + 1 SC + 9 VPs).
		- 2 refires consecutivos validam pattern de geração
		  recorrente de transient exceptions por path-mapping ADRs.
		- Esperado: canvas/glossary/domain-model + work-governance
		  geram mais entries — categoria pode crescer rapidamente.
		- Prose-only category/lifecycle dificulta query mecânica;
		  futuro structural-check de stale detection precisa de
		  classificação estruturada.

		Schema atual #BootstrapException (apenas artifactPath +
		rationale) força categoria + lifecycle a viver em prose.
		Custos:
		(c1) Sem type discipline: typo em "pre-mapping-transient"
		passa silente; CUE não pega.
		(c2) Sem query mecânica: cue export não diferencia
		transient de permanent; grep precisa de regex em prose.
		(c3) Stale detection mecânica impossível: estrutural-check
		que verifica 'transient exception ainda válida' precisa
		distinguir transient de permanent — distinção que vive
		em prose.

		Schema first-class resolve (c1)-(c3) com expand-when-needed
		validado: 14 entries pre-mapping-transient + n>=1 categorias
		permanent confirmam que distinção é real e estável.

		Alternativas avaliadas:
		(a) Manter schema atual + acknowledge formal — rejeitada:
		2 refires consecutivos + 14 entries cumulativos + Known gap
		explícito em adr-069 declaram que volume justifica generalização.
		Acknowledge sem ação defeats o propósito de revisita ativa.
		(b) Hybrid (só category, sem lifecycle/exitCondition) —
		rejeitada: lifecycle é distinção operacional (transient vs
		permanent governa cleanup); exitCondition habilita criterion
		mecânico para futuro stale detection. Hybrid perde valor
		sem custo significativamente menor.
		(c) Full schema first-class com conditional CUE constraints
		(if category == X then lifecycle Y) — rejeitada para esta
		ADR: hardcoding 1:1 mapping entre categoria e lifecycle hoje
		calcificaria relação que pode evoluir (futura categoria
		poderia ter entries de ambos lifecycles). Lifecycle declarado
		explicitamente per entry; enum + rationale prose são guard
		rails suficientes; constraint pode ser adicionado em futuro
		ADR se mapping permanecer estritamente 1:1 over time.
		(d) exitCondition como string obrigatório vs opcional —
		opcional escolhido: permanent entries não têm exit (campo
		ausente é semanticamente correto); transient entries
		preenchem com texto descritivo. Format estruturado deferido
		até multiple transient categories emerjam (segunda categoria
		transient revelaria padrões repetidos vs únicos).
		"""

	decision: """
		(1) ESTENDER schema #BootstrapException em
		governance/build-time/self-review-bootstrap-policy.cue:
		    #BootstrapExceptionCategory:
		        "inaugural-circularity" |
		        "predecessor-supersession-only" |
		        "pre-mapping-transient"
		    #BootstrapExceptionLifecycle: "permanent" | "transient"
		    #BootstrapException: {
		        artifactPath:   string & !=""
		        rationale:      string & !=""
		        category:       #BootstrapExceptionCategory
		        lifecycle:      #BootstrapExceptionLifecycle
		        exitCondition?: string & !=""
		    }
		Sem CUE conditional constraints (category→lifecycle); lifecycle
		declarado explicitamente per entry. exitCondition opcional;
		transient entries preenchem; permanent entries omitem.

		(2) MIGRAÇÃO declarativa de 20 entries existentes na policy:
		- 4 inaugural-circularity (permanent): quality-criteria.cue +
		  adr-013/014/015
		- 2 predecessor-supersession-only (permanent): adr-016/017
		- 14 pre-mapping-transient (transient): 4 PGs (via adr-067) +
		  1 SC (via adr-068) + 9 VPs (via adr-069)
		Para todas 14 transient entries, exitCondition é uniforme:
		"Remove exception when artifact receives a matching SRR after
		next modification."

		(3) RESOLVER def-011: status open → resolved + resolvedBy
		"architecture/adrs/adr-070-promote-bootstrap-exception-to-
		firstclass-schema.cue" + triggeredCondition articulando 2
		refires consecutivos + Known gap de adr-069. def-011 SRR
		amendada para refletir resolution.

		(4) DEFERIR stale detection structural-check via def-012:
		runner mecânico de detecção de transient exceptions stale
		(SRR matching path passou a existir mas exception ainda no
		policy) requer trigger kind novo para signaling — escopo
		separado per adr-071. def-012 calibra trigger
		file-content-occurrence-count threshold=20 (count atual=14).

		(5) ESCOPO EXCLUÍDO: este ADR NÃO inclui structural-check
		para stale detection nem novo trigger kind. Trigger kind é
		decisão acoplada mas com justificativa própria — adr-071
		cobre. Stale detection sc é deferida per def-012 até primeira
		stale exception observed empiricamente.

		(6) MATERIALIZAÇÃO: single commit consolidado com adr-070 +
		adr-071 (acoplado mas separado por concern) + schema bump +
		migration de 20 entries + def-011 update + def-011 SRR
		amendment + deferred-decision-schema SRR amendment + adr-070
		SRR + adr-071 SRR + def-012 + def-012 SRR. ~12 arquivos.
		"""

	consequences: """
		Positivas:

		(P1) Type discipline: CUE valida category enum + lifecycle
		enum em cada entry. Typo passa a ser erro de cue vet.

		(P2) Query mecânica: cue export emit category + lifecycle
		structured; grep estruturado para qualquer categoria. Habilita
		automação futura (stale detection sc) sem schema bump
		adicional.

		(P3) Documentação self-evident: reading policy file revela
		categoria sem precisar parse de prose. Onboarding de novo
		agente/founder mais barato.

		(P4) exitCondition explícito (transient entries) captura
		criterion de cleanup em campo dedicado — futuro structural-
		check pode parsear OR usar como hint para founder review.

		(P5) Lifecycle declarado per entry preserva opção: futura
		categoria com entries de ambos lifecycles entra sem
		alteração de schema.

		Negativas:

		(N1) Migration overhead one-time (20 entries reclassificadas
		com category + lifecycle + exitCondition para transient).
		Realizada em mesmo commit que schema bump — janela de
		inconsistência inexistente.

		(N2) Stale detection ainda manual até def-012 resolver.
		Mitigação: def-012 articula trigger automático conservador
		(file-content-occurrence-count threshold=20) + manual-review
		fallback; founder revisita quando volume crescer.

		(N3) category enum fechado (3 valores) pode precisar
		expansion no futuro. Mitigação: amendment ao enum é trivial
		(adicionar valor + classification de eventual nova categoria);
		pattern adr-061/062/064 (extending #ArtifactType) provê
		precedente.

		(N4) Sem CUE conditional category→lifecycle: agente que
		preencher category="pre-mapping-transient" mas lifecycle=
		"permanent" passa cue vet (relação não enforced em schema).
		Mitigação: rationale prose + structural-check futuro podem
		validar coherence; typo discipline ainda melhor que prose
		atual.

		Known gaps declarados:
		- Stale detection structural-check (sc-be-01) deferido per
		  def-012. Trigger automático conservador + manual-review
		  fallback.
		- CUE conditional constraint category→lifecycle não
		  adicionado nesta ADR; futuro ADR pode adicionar se mapping
		  1:1 permanecer estável over time.
		- Format estruturado de exitCondition deferido até segunda
		  transient category emergir (pattern repetível vs único).

		Fronteira regulatória: nenhuma. Decisão é meta-estrutural
		sobre governance schema.
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"governance/build-time/self-review-bootstrap-policy.cue",
		"architecture/deferred-decisions/def-011-bootstrap-exception-schema-firstclass.cue",
	]

	plannedOutputs: [
		"architecture/deferred-decisions/def-012-bootstrap-exception-stale-detection-sc.cue",
		"governance/build-time/self-reviews/def-012-bootstrap-exception-stale-detection-sc.self-review.cue",
	]

	defersTo: ["def-012"]

	principlesApplied: [
		"P0",
		"P10",
		"P12",
	]

	supersedes: []

	rationale: """
		Princípios aplicados:

		P0 (zero duplicação): categoria + lifecycle + exitCondition
		ganham localização canônica única (campo do schema).
		Eliminação de prose redundante onde categoria atual era
		repetida em rationale de cada entry.

		P12 (governança como código): schema bump é veículo
		declarativo para classification. Promoção a first-class
		aumenta rigor declarativo sem sacrificar legibilidade.

		P10 (gates determinísticos validam): CUE type system valida
		category + lifecycle enum determinísticamente. Substitui
		discipline voluntária (manter prose consistente) por gate
		automático.

		Sem axiomas tensionados.

		Lenses consultadas:

		lens-real-options: schema bump é generalização — pattern
		ten-009 expand-when-needed validado por 14 entries + 2
		refires consecutivos. Custo de não bumpar (continuar
		prose-only) cresce linearmente com next path-mapping ADRs;
		bumpar agora paga o custo único.

		Relação com outras ADRs:

		- DESCENDS adr-067 (introduziu categoria pre-mapping-
		  transient + def-011).
		- COMPLEMENTA adr-068, adr-069 (gerou refires consecutivos
		  validando volume).
		- DEFERS TO def-012 (stale detection structural-check).
		- COUPLED COM adr-071 (mesmo commit; adr-071 adiciona
		  trigger kind necessário para def-012 ter trigger
		  automático adequado).
		- RESOLVES def-011 (resolvedBy populated em def-011 update).
		- SEM supersession.

		Justificativa de risk metadata:

		reversibility 'high': schema bump é adicionar campos
		opcionais (category + lifecycle + exitCondition?). Reversão
		é remover fields + reverter migration; mecânica.

		blastRadius 'cross-cutting': afeta TODOS bootstrap exceptions
		(20 atuais + futures). Não atravessa fundamental governance
		infrastructure (não é repo-wide); afeta single governance file
		mas single file central ao enforcement de self-review.
		"""
}
