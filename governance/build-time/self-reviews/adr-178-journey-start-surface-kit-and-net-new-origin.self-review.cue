package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr178JourneyStartSurfaceKitAndNetNewOrigin: build_time.#SelfReviewReport & {
	reportId: "srr-adr-178-journey-start-surface-kit-and-net-new-origin"

	artifactPath:       "architecture/adrs/adr-178-journey-start-surface-kit-and-net-new-origin.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-14"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 4
		infoCount: 4
		summary: """
			Round 1 — review por SUB-AGENTE ISOLADO (rollout adr →
			isolated-subagent), sem o histórico da sessão de autoria, sobre o
			adr-178 + o kit p2p + contrato v2 + def-081; verificação
			normativa CARÁTER-POR-CARÁTER contra a adr-150 e runner
			DIFERENCIAL (HEAD pré-fatia via git archive vs working tree).

			CONTEXTO PRÉ-AUTORIA registrado (transparência da D5): a ordem
			original da fatia mandava o adr-178 CITAR um 'braço net-new' e um
			'humanExceptionPrinciple' da adr-150 — diligência anti-dangling
			ANTES da escrita provou que essas cláusulas NÃO existem (nem na
			adr-150, ecoada verbatim integral; nem no frontend-runtime; nem
			no arco antigo Mesh-Old, cuja Generative Form é 'formulários
			iniciam pré-preenchidos pelo agente... Humano revisa e ajusta',
			sem braço de exceção). DOIS STOPs consecutivos; o founder
			RECRAVOU a D5: o adr-178 INSTITUI o não-padrão (voz própria),
			citando APENAS o verbatim real ('por padrao'; 'locus primario').
			A escrita seguiu a versão corrigida.

			NÚCLEO NORMATIVO PASSA (a verificação nº 1 do reviewer): toda
			aspas atribuída à adr-150 é VERBATIM caráter-por-caráter
			(checagem mecânica whitespace-normalizada); verbo INSTITUIR em
			todas as posições normativas; a única ocorrência de 'contém' é
			negada ('A lei NÃO contém cláusula de exceção'); zero aspas
			fabricada em adr-178/def-081/contrato v2/api.yaml.

			NÚCLEO FACTUAL PASSA: 2 paths exatos; POST devolve o evento; sem
			409/422 com justificativa fiel ao domain-model (completude na
			triagem, returned não transiciona); zero-drift do manifest
			(5/6/3, inclusive ordem); 6 eventos campo-a-campo fiéis (incl.
			sourcingDecisionRef+quantity do adr-177); #PurchaseRequisitionState
			= lifecycle.states na ordem; reasonCode fechado = constraint;
			outcome aberto confere (domínio não fecha); sc-pmc/sc-mri sem
			findings; refs todos existem; catraca intocada (domain-model p2p
			git diff vazio); sc-cv-02 quitado; alternativas genuínas;
			falsificação observável.

			1 FAIL: F1 — a fatia introduz 12 violações BLOQUEANTES do
			sc-fct-01 (first-class-traceability, reject) e o ADR estava
			SILENTE sobre a obrigação adr-151/adr-153 (uq-05): entrar no
			aggregate-manifest torna os 12 conceitos do recorte
			cruza-contrato, e o p2p nunca passou pela campanha de backfill
			(não tinha manifest); diferencial provado: HEAD 31/0 → working
			tree 42/12. A remediação (Forma A no domain-model vs worklist)
			é decisão do founder — fora do escopo cravado. 4 WARNS: W1 aspas
			inexata do contrato v1 (faltava 'de frontend'); W2 rótulo
			'verbatim' sobre paráfrase re-sujeitada ('locus primario' com
			sujeito trocado e 'humana' dropada); W3 disciplina adr-059
			(arquivos novos em affectedArtifacts em vez de plannedOutputs);
			W4 SRRs ausentes no working tree (este SRR pendente por desenho
			— aguardava o review). 4 INFOS: I1 derivedArtifacts como no-op;
			I2 articulação do tq-def-03 no campo vizinho; I3 policiamento do
			net-new por review humano (dependência dupla do founder,
			declarada); I4 endurecimento non-empty nos espelhos.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 2
		summary: """
			Round 2 — correções aplicadas + DECISÃO DO FOUNDER no F1 (opção
			b, worklist): F1 RESOLVIDO — as 12 entries do p2p entraram na
			first-class-backfill-worklist no SHAPE EXATO do seed da campanha
			({conceptCode, bc, reason, status:'pending'}, confirmado contra o
			git history do arquivo; drenagem registrada como as 4 ondas
			anteriores fizeram: a própria worklist + a onda nomeada, SEM
			mecanismo novo); o adr-178 ganhou a declaração uq-05 na decisão
			(2) (consequência do manifest + worklist re-populada
			conscientemente + onda p2p como 5ª onda da campanha), o item (7)
			corrigido (runner 30/0 com os 12 reconhecidos, não silenciados),
			a consequência (N4) (vigilância: a onda p2p deve preceder ou
			acompanhar a fatia da tela 2) e a worklist em affectedArtifacts.
			W1 RESOLVIDO — aspas do contrato completada verbatim ('...família
			de frontend o exigir'). W2 RESOLVIDO — o período re-citado com o
			sujeito real da lei (a interface 'nao e o locus primario de
			operacao humana') e a leitura movida para a voz do ADR. W3
			RESOLVIDO — os 5 arquivos novos movidos para plannedOutputs;
			affectedArtifacts só com os editados. W4 RESOLVIDO — este SRR +
			o do def-081 materializados. I1 NÃO-ACATADO com registro: o
			structure-index FOI regenerado nesta fatia e tem diff real vs
			HEAD (+adr-178/am/pm/def-081); o --check do reviewer rodou APÓS a
			regeneração — 'em sync' é o estado pós-regeneração, não no-op; a
			entry derivedArtifacts está correta. I2/I4 aceitos como infos;
			I3 é propriedade declarada do desenho (N3 do ADR). cue vet
			EXIT=0 pós-correções; runner re-executado no fecho do batch —
			expectativa 30 warns / 0 bloqueantes (12 do sc-fct-01 mortos
			pela worklist; sc-cv-02 quitado; catraca intocada).
			"""
	}]

	findings: {}

	summary: """
		adr-178 (accepted) abre o arco de telas pelo início da jornada: kit
		de superfície do p2p (api.yaml GET fila + POST submit; schemas;
		manifest zero-drift; pm-p2p), contrato de codegen v2 (+p2pSurface;
		promoção a schema nomeada para a 3ª família) e a decisão normativa —
		o não-padrão de origem net-new INSTITUÍDO sobre o 'por padrao' real
		da adr-150 (citação só verbatim, provada caráter-por-caráter pelo
		reviewer isolado; a formulação anterior, que atribuía cláusulas
		inexistentes à lei, foi bloqueada em 2 STOPs e recravada pelo
		founder ANTES da escrita). F1 do reviewer (12 bloqueantes sc-fct-01
		do manifest novo) resolvido por decisão do founder via o mecanismo
		desenhado (worklist de backfill re-populada conscientemente +
		declaração uq-05 no ADR + onda p2p como 5ª onda da campanha).
		def-081 registra ESTREITO a migração de regime da origem. VEREDITO:
		stable, 0 fail residual, 0 warn residual.
		"""
}
