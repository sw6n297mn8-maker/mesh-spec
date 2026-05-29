package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr125: artifact_schemas.#ADR & {
	id:    "adr-125"
	title: "Princípio de derivação de bounded contexts (P13) + section de derivação no canvas PG"
	date:  "2026-05-29"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		O repositório declara 25 bounded contexts (strategic/context-map.cue),
		dos quais 11 materializados (canvas) e 14 ainda não-scaffolded. O
		critério de fronteira usado até aqui é tácito: o rationale repetido nos
		25 BCs ("subdomínio com linguagem, invariantes e governança próprias —
		BC dedicado por separação deliberada") + decisões pontuais em adr-002
		(canvas como rootArtifact que define existência), adr-065 (PLR como
		registry-não-engine + teste de remoção: "se PLR for removido amanhã,
		BCs devem continuar funcionando") e adr-085 (decisionAuthorityModel —
		fronteira definida por onde mora a autoridade de decisão/verdade,
		replicável a CMT/FCE/SCF/NIM). Não havia princípio explícito governando
		a ATIVIDADE de derivar fronteira e classificar relação cross-BC.

		O arco cycle-resolution (PR #84/#85/#86; adr-117..124) tornou o gap
		concreto. Quatro aprendizados mudam como relações cross-BC devem ser
		modeladas:
		(1) Relação cross-BC tem kind, não só direction — um ciclo aparente
		    pode ser estrutura legítima (bidirectional-orchestration,
		    policy-reaction, policy-execution-feedback) ou defeito.
		(2) A taxonomia de coupling é necessariamente aberta:
		    policy-execution-feedback emergiu empiricamente (adr-124) de um
		    ciclo que uma taxonomia fechada teria mis-classificado.
		(3) O discriminante entre kinds é agência + signal-vs-state, ancorado em
		    invariante (generaliza o decisionAuthorityModel de adr-085).
		(4) Kinds emergem da tentativa de fechar ciclos reais, não da inspeção
		    isolada de canvases — o princípio precisa de protocolo de
		    descoberta, não só taxonomia.

		Este ADR formaliza P13 (architecture/design-principles.cue, group
		DesignPhilosophy) cobrindo: testes de existência (linguagem ubíqua +
		invariante + ownership + teste de remoção), ordem de preferência de
		classificação de relação, split/merge pelos mesmos testes, ônus
		invertido sobre ciclos, e protocolo de descoberta de kind. O protocolo
		operacional (procedimento) vai como section "boundary-derivation" no PG
		de canvas (production-guides/canvas.cue) — onde a derivação já culmina
		(purpose = "justificativa do contorno"). dp-06 (foundingPrinciples:
		"novos produtos são novos BCs") é COMPLEMENTAR, não conflitante: dp-06 é
		estratégia de crescimento; P13 é o método/invariante de derivar a
		fronteira correta. P13 operacionaliza dp-06.

		Alternativas consideradas e rejeitadas:

		(a) Production-guide standalone de derivação de BC. REJEITADA: o schema
		#ProductionGuide é estritamente por-artifactType (cada sections[].target
		é um #TypeName de UM schema; tq-pg-02). Um guia de derivação é
		cross-artifact (canvas + context-map + ADR) e não cabe sem violar a
		forma do schema. A metodologia vira section no PG de canvas, que já é o
		guia de autoria do BC.

		(b) Criar production-guides/design-principle.cue (type-PG) ANTES de
		autorar P13 (Path A do pre-flight). REJEITADA agora: design-principle
		NÃO está na whitelist coveredSchemas do sc-pg-01 (cobertura é opt-in
		deliberado, não auto-discovery); P0–P12 foram todos autorados sem
		type-PG; canvas também está fora da whitelist. Autorar P13 direto é
		consistente com o status quo. A decisão de perseguir cobertura universal
		fica deferida em def-030.

		(c) Structural-check correlato novo (e.g., "BC sem kind em relação
		cíclica = reject"). REJEITADA: essa regra JÁ é o sc-cm-07 (reject
		pós-#86). Os testes de separação + descoberta de kind são
		interpretativos (P10 advisory), não gate-able deterministicamente. A
		revisão advisory fica deferida em def-029 (validation-prompt).

		(d) Alocar P13 em group StructuralInvariants. REJEITADA: StructuralInvariants
		(P3–P6) são mecanismos concretos sempre-verdadeiros do sistema construído
		(event log, ledger). P13 é filosofia de derivação — guia COMO decompomos,
		não um mecanismo de runtime. group DesignPhilosophy (P7–P9) é o lar
		correto.

		(e) Adicionar campo derivationRationale ao context-map/canvas. REJEITADA:
		rationale já é obrigatório em #_RelationshipCore e o canvas já carrega
		purpose; campo novo duplicaria (viola P0).
		"""

	decision: """
		(1) Adicionar P13 "Derivação de Bounded Context" a
		architecture/design-principles.cue (group DesignPhilosophy). Statement
		cobre: três testes de separação (linguagem ubíqua distinta + invariante
		própria + ownership canônico) + teste de remoção como discriminante
		final; ordem de preferência de classificação de relação (1
		upstream-downstream com pattern; 2 mutual-dependency simétrica; 3 ciclo
		com kind tipado); split/merge pelos mesmos testes; ônus invertido (ciclo
		é defeito por default, legitimidade exige kind nomeado + ADR); taxonomia
		aberta com protocolo de descoberta via discriminantes
		agência/signal-vs-state/invariante; e exigência de ADR para toda decisão
		de fronteira não-trivial.

		(2) Adicionar section "boundary-derivation" a
		architecture/production-guides/canvas.cue (primeira no workOrder),
		materializando o protocolo operacional de P13 (process + heuristics +
		doneCriteria + ifGap), com ponteiro para o validation-prompt advisory
		deferido em def-029.

		(3) Adicionar linha à tabela "Referências por Tipo de Operação" em
		governance/claude/config.cue (regenera CLAUDE.md, derivado per adr-004).

		(4) Criar def-029 (validation-prompt advisory para revisão de derivação)
		e def-030 (avaliar cobertura de PG para design-principle). Ambos open;
		defersTo aponta para eles.

		Este ADR NÃO cria structural-check novo (sc-cm-07 já cobre o invariante
		de acyclicity) e NÃO cria production-guides/design-principle.cue (Path B;
		def-030).
		"""

	consequences: """
		Positivas:
		(P1) A derivação de BC deixa de ser tácita e vira decisão auditável e
		parcialmente gate-enforceável (acyclicity via sc-cm-07; parte
		interpretativa via validation-prompt advisory def-029).
		(P2) Os 4 aprendizados do arco cycle-resolution ficam codificados como
		princípio reusável para os 14 BCs não-scaffolded, em vez de conhecimento
		perdido em ADRs pontuais.
		(P3) A taxonomia aberta + protocolo de descoberta previne o failure mode
		observado (taxonomia fechada mis-classifica coupling legítimo emergente
		como defeito — caso policy-execution-feedback).
		(P4) Custo marginal baixo: 1 princípio + 1 section em PG existente + 1
		linha de tabela; nenhum tipo novo, nenhum schema novo, nenhum
		structural-check novo.

		Negativas:
		(N1) P13 é prescritivo a partir do merge para os 14 não-scaffolded; os
		11 materializados NÃO são re-derivados em massa (revisita lazy: só
		quando o BC ganha nova relação, entra em ciclo via sc-cm-07, ou surge
		tensão). Risco residual: um dos 11 pode ter fronteira que P13 julgaria
		diferente; mitigação: o grafo cross-BC dos 11 já é P13-conforme no nível
		de relação (sc-cm-07 reject-green pós-#86).
		(N2) A parte interpretativa de P13 (testes de separação, descoberta de
		kind) não tem gate determinístico — depende de revisão advisory ainda
		não materializada (def-029). Mitigação: sc-cm-07 cobre o invariante duro
		(acyclicity); o resto é P10 advisory por design.
		(N3) Cobertura universal de PG (adr-053) permanece com gap para
		design-principle. Deferido conscientemente em def-030.

		Deferimentos: def-029 (validation-prompt advisory) e def-030 (PG coverage
		para design-principle) — ver defersTo.

		Fronteira regulatória: nenhuma. Decisão de método de design/governança.
		Sem efeito em Bacen/SCD/LGPD/KYC/AML.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/design-principles.cue",
		"governance/claude/config.cue",
		"architecture/production-guides/canvas.cue",
	]

	plannedOutputs: [
		"architecture/deferred-decisions/def-029-validation-prompt-bc-derivation.cue",
		"architecture/deferred-decisions/def-030-pg-coverage-design-principle.cue",
	]

	derivedArtifacts: [
		"CLAUDE.md",
		"governance/build-time/self-reviews/canvas-pg.self-review.cue",
	]

	defersTo: ["def-029", "def-030"]

	principlesApplied: ["P0", "P12"]

	supersedes: []

	rationale: """
		Princípios aplicados:

		P0 (uma localização canônica): P13 (o invariante + a regra) vive só em
		design-principles.cue; o protocolo (procedimento) vive só na section
		boundary-derivation do PG de canvas; os vocabulários de kind/pattern
		vivem só no schema do context-map. Nenhuma cópia — a tabela do CLAUDE.md
		e a section do PG são ponteiros. Por isso a metodologia NÃO virou PG
		standalone (duplicaria o guia de canvas) nem campo novo (rationale e
		purpose já existem).

		P12 (governança como código): a parte dura de P13 (ciclo = defeito por
		default) é enforced por sc-cm-07 (reject), não por convenção lexical. A
		parte interpretativa é explicitamente advisory (def-029), respeitando a
		separação determinístico-vs-advisory de adr-040 e P10 (agentes
		recomendam, gates validam).

		Complementaridade com dp-06: dp-06 (foundingPrinciples, estratégia de
		crescimento) diz "novos produtos são novos BCs"; P13 diz COMO decidir que
		uma fronteira é correta e como classificar suas relações. P13
		operacionaliza dp-06 estruturalmente; não o tensiona.

		Ancoragem do critério tácito: P13 generaliza adr-002 (canvas define
		existência), adr-065 (teste de remoção; registry-não-engine) e adr-085
		(decisionAuthorityModel como discriminante de fronteira) — eleva o
		critério implícito desses ADRs a princípio explícito.

		Evidência empírica: a taxonomia aberta e o protocolo de descoberta vêm do
		arco cycle-resolution, onde policy-execution-feedback (adr-124) emergiu de
		um ciclo real (fce↔rew) que a taxonomia fechada teria forçado a um kind
		errado.

		defersTo usado (def-029, def-030): diferente de adr-124, este ADR é a
		ORIGEM dos dois deferimentos (criados no mesmo commit), então defersTo é o
		campo correto (adr-062); a resolução, quando ocorrer, irá em resolvedBy
		das DDs.

		Tensão com axiomas: nenhuma. ax-03 (pagar custo de complexidade cedo)
		confirmado: formalizar a derivação agora, antes de scaffold dos 14 BCs
		restantes, é mais barato que descobrir fronteiras erradas depois (refazer
		fronteira é redesign, não refactor — dp-06).

		Lenses consultadas: lens-domain-language-and-terminology-design
		(linguagem ubíqua distinta como teste de fronteira) e
		lens-distributed-systems-design (acyclicity de dependências como
		propriedade estrutural; ciclo como defeito por default).
		"""
}
