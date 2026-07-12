package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr174ApprovalAsGateBeforeOrder: build_time.#SelfReviewReport & {
	reportId: "srr-adr-174-approval-as-gate-before-order"

	artifactPath:       "architecture/adrs/adr-174-approval-as-gate-before-order.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-12"

	roundsExecuted: 3
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 4
		infoCount: 3
		summary: """
			Round 1 — review por sub-agente ISOLADO sobre o working tree da
			fatia. TODAS as 7 verificações factuais CONFIRMADAS contra o disco:
			cmd-approve-budget é o Gate de Cobertura sync como citado (verbatim
			'Saldo Disponível suficiente + Alçada satisfeita' + 'downstream
			precisa de decisão determinística'); cmd-release-budget-commitment
			devolve o reservado; pol-commitment-accepted-triggers-approval é o
			papel velho literal; shape adr-055 idêntico ao npm↔idc no
			domain-model; PROVENIÊNCIA CONFIRMADA VERBATIM (Mesh-Old
			adr-c4-stack linha 1886: '§2.0.8 — Padrão Multi-Aggregate:
			Reservation/Confirmation via WorkflowPort'); def-078 resolved
			conforme; divergência de ordem registrada na story. Materialização
			5/5 affectedArtifacts + plannedOutput: wiring tq-dm-01..17 fecha
			por inspeção completa; selectors shape fce per adr-160;
			QueryBudgetApprovalStatus existe no canvas bdg (janela da chave
			declarada); carve-out do cmd-convert-requisition correto; glossário
			16/16; anti-retrofit confirmado (6 codes da story existem no
			domain-model); cue vet EXIT=0; tq-adr-01..04 satisfeitos.

			FINDINGS: [uq-05 warn #1, o mais material] o portão não modela o
			VALOR no fluxo de aprovação — cmd-approve-purchase/agg/evt-approved
			não carregam amount, e o cmd-approve-budget do bdg exige amount
			para avaliar saldo+alçada; origem do valor não declarada em
			rationale. [adr-055 dec 5 warn #2] acoplamento sync p2p→bdg sem
			espelho estrutural (query-dependency no canvas p2p + relação
			p2p-to-bdg no context-map) e a janela WI-153 não nomeava esses 2
			artefatos. [same-artifact warn #3] prosa stale no rationale raiz
			do p2p ('8 VOs'; lens eda '4 projections... sem policies').
			[warn #4] story atualizada seletivamente — rationales dos passos
			2-3 afirmam a lacuna no presente ('requisi' zero ocorrências) e o
			passo do gestor segue 'alçada pré-pedido não existe em nenhum BC'.
			[info] adr-055 ainda status proposed; janela invisível NO bdg
			(sem ponteiro local a adr-174/WI-153); elo requisição↔cotação não
			formalizado (aprovar triada sem cotação é possível — fecho da
			ordem só na emissão).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 2
		infoCount: 3
		summary: """
			Round 2 — triagem por classe, sem correção às cegas de decisão
			semântica: [#3 CORRIGIDO] prosa stale do rationale raiz reescrita
			(9 VOs; lens eda 5 projections + 1 policy; parágrafo behavior-first
			datado como derivação original + delta WI-151); cue vet EXIT=0.
			[#2 TRATADO PELA VIA DA JANELA] affects do WI-153 ampliado com
			contexts/p2p/canvas.cue + strategic/context-map.cue e o rationale
			nomeia o espelho estrutural pendente — declarar query-dependency
			agora cristalizaria contrato sobre surface keyed por CommitmentId
			(a chave errada que o próprio WI-153 corrige). [#1 e #4 NÃO
			corrigidos pelo agente — decisão do founder] #1 é decisão de
			MODELO (de onde vem o amount da aprovação; recomendação registrada
			abaixo); #4 colide com instrução explícita do arquiteto no Tempo 2
			(preencher SOMENTE refs dos passos 2-3; NÃO tocar o passo do
			gestor) — a tensão instrução×finding é reportada no checkpoint,
			não resolvida unilateralmente. Infos mantidos como higiene futura.
			"""
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 3
		summary: """
			Round 3 — os 2 residuais RESOLVIDOS POR DECISÃO DO FOUNDER e
			materializados no mesmo working tree: [#1 amount] entra COMO CAMPO
			(vo-money) em cmd-approve-purchase e evt-purchase-approved, com o
			rationale declarando a procedência (valor da cotação vencedora do
			sourcing, ssc) e a dívida do elo — a formalização quoteRef
			cross-BC + reconciliação approve-amount vs quote-amount é a fatia
			p2p↔ssc registrada em def-079 (novo, open, manual-review, warn
			tq-def-03 aceito e declarado; G2 re-derivado: def-079
			próximo-livre). [#4 story] rationales datados por decisão 'a story
			é teste de cobertura VIVO': passos 2-3 registram lacuna
			identificada no exame e FECHADA pelo WI-151/adr-174; o passo do
			gestor NÃO marcado como resolvido — o portão mecânico existe, a
			atribuição a papel-gestor intra-org pende de def-076. Infos (3)
			permanecem como higiene futura: adr-055 status proposed; janela
			sem ponteiro local no bdg; elo requisição↔cotação não formalizado
			— este último agora GOVERNADO por def-079 (deixou de ser gap
			silencioso).
			"""
	}]

	findings: {}

	summary: """
		adr-174 (aprovação é PORTÃO pré-pedido; two-phase Reservation/
		Confirmation): review ISOLADO confirmou TODAS as verificações factuais
		— incluindo proveniência verbatim do §2.0.8 no corpus Mesh-Old — e a
		materialização integral (wiring tq-dm fecha; selectors adr-160; janela
		da chave declarada; anti-retrofit da story confirmado). 0 fail. 4 warns
		no round 1: 1 corrigido (prosa stale), 1 tratado pela via da janela
		(espelho canvas/context-map → WI-153), 2 DECLARADOS ao founder e
		RESOLVIDOS por decisão dele no round 3: amount como campo (vo-money)
		com procedência e dívida declaradas + def-079 (elo requisição↔cotação
		e reconciliação, fatia p2p↔ssc futura); story datada como teste vivo
		(gestor não-resolvido, pende def-076). VEREDITO: stable, 0 fail,
		zero residual silenciado.
		"""
}
