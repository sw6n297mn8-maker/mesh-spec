package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr155: build_time.#SelfReviewReport & {
	reportId: "srr-adr-155-human-override-prepayment-guard-fce"

	artifactPath:       "architecture/adrs/adr-155-human-override-prepayment-guard-fce.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-18"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 -- review por SUB-AGENTE ISOLADO (rollout adr -> isolated-subagent), cold-read sem o
			historico de autoria, sobre adr-155 completo (override humano do PrePaymentGuard no FCE,
			fronteira regulatoria nivel-1 SCD/Bacen). AUDITORIA DE SEGURANCA, nao revisao de estilo. O
			ataque central e o PISO INOVERRIDAVEL. Vereditos com citacao de disco; cue vet ./... EXIT=0.

			[CRITICO -- PISO INOVERRIDAVEL]: PASS. Tentei construir um caminho onde evidencia AUSENTE ou
			com integridade criptografica FALHA (adulterada) alcanca escalated -> authorized (dinheiro
			move sem prova genuina) em vez de freeze. NAO consegui sem violar a propria regra de
			roteamento do design. Mecanismo: a separacao e por CLASSE DE CONDICAO, nao por prosa. A
			transicao guarded->escalated (adr-155:64-68) dispara so para condicao "stale / incompleta /
			ambigua" -- verbatim da supervisedDecision override-prepayment-guard (canvas.cue:721). O caso
			breach (ausente/adulterada) e roteado a OUTRO mecanismo: o escalationCriterion
			p11-invariant-breach-detected (canvas.cue:737-740, freeze fail-safe "containment precede
			diagnosis", ADR-079), JAMAIS a escalated->authorized (adr-155:99-104, decision item 4). O
			DISCRIMINADOR e deterministico e ancorado em adr-128: o mecanismo cripto (assinatura + hash
			chain + notarizacao, adr-128:51-61) da veredito DURO -- cadeia adulterada FALHA a verificacao
			(NAO um pass-nao-limpo, e breach DETECTADO); ausencia = nenhum objeto de evidencia. Staleness/
			ambiguidade sao sobre evidencia PRESENTE-E-VERIFICAVEL cujo frescor/interpretacao esta em
			questao -- o humano julga que "a prova subjacente EXISTE" (adr-155:96-98). Crypto-fail e
			presenca sao mecanicamente distinguiveis de staleness; nao ha corrida -- sao desfechos
			mutuamente exclusivos do MESMO guard deterministico (inv-guard-deterministic, domain-model
			.cue:342-349). overriddenConditions exclui o breach POR CONSTRUCAO no nivel do desenho: e
			campo do override command, e o override command so e alcancavel a partir de escalated; breach
			nunca chega a escalated (vai a freeze) -> o command que carrega overriddenConditions e
			inalcancavel para input de breach. ZONA CINZA N3 (adr-155:152-156) e admitida com honestidade
			("stale-mas-presente vs ausente") E fixa o lado seguro DOMINANTE: "na duvida entre stale e
			breach, roteia a freeze, nao a override". Mesmo o residual tem disposicao-segura definida. O
			unico caminho para dinheiro mover sobre prova forjada e MIS-IMPLEMENTAR o roteamento breach->
			freeze -- exatamente o que o verificationMetric p11-breach-rate (canvas.cue:840-847, target 0)
			e o sinal de falsificacao (adr-155:177-179) existem para capturar. Residual = limite de
			calibracao honestamente nomeado (N3), nao vazamento de piso. O PISO SEGURA.

			[GARANTIA ESTRUTURAL P10 -- honestidade]: PASS. A ADR alega que o override command torna
			supervisorId "IMPOSSIVEL de omitir por construcao" (adr-155:80-82, "P10 enforcado pela forma,
			nao pela disciplina"). N2 (adr-155:148-151) e HONESTO que essa garantia so e REAL pos-
			materializacao: "O ADR DECIDE; a garantia so e REAL quando o domain-model/codegen a enforcam
			-- ate la e compromisso, nao enforcement." Aplica o mesmo escopo ao enforcement do piso: o
			roteamento breach->freeze e decisao de desenho da state machine cuja blindagem estrutural
			(schema tornando impossivel) tambem so materializa adiante -- e a ADR NAO finge garantia ja-
			entregue: status proposed (adr-155:20) + "Ordem: o ADR decide; o domain-model materializa e
			torna vigente" (adr-155:55-56). Nao ha overclaim; o gap proposed->accepted e o veiculo
			explicito que fecha (adr-155:150-151).

			[TESE AFIRMATIVA "override CUMPRE P10/P11" -- fecha?]: PASS. P10 statement (design-principles
			.cue:166-175) declara verbatim "Todo command com impacto financeiro passa por gate que impoe
			invariantes, thresholds e APROVACOES HUMANAS". inv-guard-deterministic (domain-model.cue:347-
			348) declara verbatim "O agente nunca despacha diretamente; override do guard e sempre
			supervisedDecision". A ponte do geral (clausula "aprovacoes humanas" de P10) ao especifico
			(este override command) e SOLIDA, nao salto: P10 autoriza a CATEGORIA (aprovacao humana como
			componente do gate); inv-guard-deterministic JA MANDA que o override do guard SEJA
			supervisedDecision. Logo a ADR nao institui excecao a P11 -- materializa duas clausulas pre-
			existentes que ja mandam exatamente esta forma (adr-155:31-38). inv-money-moves-only-on-proof
			(domain-model.cue:334) proibe override AUTONOMO ("sem override autonomo"), nao humano -- a
			invariante ja previa o override humano. A tese fecha contra o disco.

			[7 PONTOS PADRAO]:
			(1) FECHO DE INFERENCIA: PASS. Cadeia sem elo pulado: gap T2 (domain-model.cue:21-23 verbatim
			"bloqueio do guard NAO e estado de falha -- o Payment permanece em guarded") -> override existe
			so como prosa de governanca (canvas.cue:719-722) -> P10 + inv-guard-deterministic ja mandam a
			forma -> esta ADR materializa. Cada passo presente.
			(2) NECESSIDADE+DISTINCAO: PASS. 3 transicoes (guarded->escalated automatica; escalated->
			authorized humana; escalated->recusa humana) + piso + terminal-de-recusa-estado-proprio, cada
			um load-bearing: estado escalated = evidencia auditavel do wait (rejeita alt-a apaga isso,
			adr-155:117-121); piso separa stale de breach (sem ele override e porta para mover dinheiro sem
			prova, rationale adr-155:230-234); terminal-proprio mantem a fatia coesa (rejeita alt-b); over-
			ride-command-proprio preserva fronteira P10 (rejeita alt-c). Nenhum decorativo.
			(3) ALTERNATIVAS HONESTAS: PASS. (a) maquina-direta guarded->authorized sem escalated; (b)
			recusa acoplada a confirm-payment-obligation-default #4; (c) override como flag em cmd-
			authorize-payment. As 3 sao reais, nao strawmen -- (c) e especialmente concreta porque cmd-
			authorize-payment EXISTE (domain-model.cue:255). Cada rejeicao com razao substantiva.
			(4) CONSEQUENCIAS NAO SUAVIZADAS: PASS. N1 (expansao da state machine -- custo admitido); N2
			(garantia P10 so real pos-materializacao -- "compromisso, nao enforcement"); N3 (zona cinza
			stale-vs-ausente NOMEADA mas nao eliminada, com default lado-seguro). N2/N3 sao exatamente os
			dois limites honestos que um revisor exigiria. Nao disfarcadas.
			(5) FALSIFICACAO BILATERAL OBSERVAVEL: PASS. falso-permissivo = PaymentGuardOverridden cujo
			overriddenConditions inclui integridade-criptografica-falha (sinal de evento concreto); falso-
			restritivo = p11-invariant-breach-detected disparando sobre evidencia presente-mas-velha,
			visivel na correlacao freeze-rate vs override-negado-por-staleness (adr-155:176-183). Ambos os
			lados com sinal de disco/evento concreto.
			(6) PRINCIPIOS COM MECANISMO: PASS. P10 (mostra COMO: command E a aprovacao humana que P10
			manda, supervisorId nao-omitivel) verificado vs design-principles.cue:166-175; P11 (COMO:
			piso fixa ausente/forjada->freeze, nunca override) vs design-principles.cue:182-195; P0 (COMO:
			desenho no ADR, materializacao no domain-model sem duplicacao; espelha [P11,P10,P0] de adr-128
			-- adr-128.cue:101 confirma principlesApplied ["P11","P10","P0"]); adr-128 (COMO: 128 estabelece
			o gate, 155 modela a excecao sancionada, nao altera 128) vs adr-128.cue conteudo. Cada relacao
			declarada e VERDADEIRA contra os artefatos.
			(7) ALUSAO A PROCESSO (cold-read): PASS. grep por red-team/v1-2-3/forma original/WIP/Secao N/
			this session/rodada em adr-155 retornou ZERO matches. "ALTERNATIVAS CONSIDERADAS" e secao
			auditavel do proprio ADR, nao narracao de processo.

			[CONFORMIDADE ESTRUTURAL / RASTREABILIDADE]: tq-adr-01 (alternativas a/b/c com rejeicao) OK;
			tq-adr-02 (reversibility low + blastRadius cross-cutting coerentes -- override sancionado do
			gate de dinheiro e load-bearing para integridade legal, rationale adr-155:224-228) OK; tq-adr-03
			(os 4 affectedArtifacts existem no disco: contexts/fce/domain-model.cue, canvas.cue,
			aggregate-manifests/am-payment.cue, schemas/events.cue -- todos verificados) OK; tq-adr-04 (>=1
			bloco de rastreabilidade: affectedArtifacts non-empty com 4 paths) OK. Nenhum finding fail/warn/
			info. cue vet ./... EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		adr-155 (proposed, structural, reversibility low, blastRadius cross-cutting) modela o override
		humano SANCIONADO do PrePaymentGuard do FCE -- irmao de excecao do adr-128: 128 estabeleceu o
		gate money-on-proof (P11), 155 decide o desenho do que acontece quando o gate nao passa
		autonomamente. Adiciona estado escalated explicito (guarded -> escalated automatico quando o
		guard falha NAO-limpo por condicao stale/incompleta/ambigua -> authorized via override command
		com supervisorId/reason/overriddenConditions, OU -> terminal de recusa proprio) e um PISO
		INOVERRIDAVEL: evidencia ausente ou com integridade criptografica FALHA NAO e condicao stale/
		ambigua -- e breach de P11, roteado ao escalationCriterion p11-invariant-breach-detected (freeze
		fail-safe), JAMAIS a escalated->authorized. Review por SUB-AGENTE ISOLADO (rollout adr ->
		isolated-subagent), AUDITORIA DE SEGURANCA numa fronteira nivel-1 SCD/Bacen, 1 round.

		VEREDITO DO PISO (critico, primeiro): PASS. Nao consegui construir caminho onde evidencia
		ausente/adulterada alcanca escalated->authorized sem violar a propria regra de roteamento do
		design. A separacao e por CLASSE DE CONDICAO (a transicao escalated dispara so para stale/
		incompleta/ambigua, canvas.cue:721; o breach vai a OUTRO mecanismo, o escalationCriterion freeze,
		canvas.cue:737-740), e o discriminador (crypto-integrity pass/fail + presenca) e DETERMINISTICO e
		ancorado em adr-128 (cadeia adulterada FALHA verificacao = breach detectado, NAO pass-nao-limpo;
		adr-128:51-61). overriddenConditions exclui breach por construcao no desenho -- e campo do
		override command, alcancavel so de escalated, e breach nunca chega a escalated. A zona cinza N3 e
		honestamente nomeada COM default lado-seguro dominante (duvida entre stale e breach -> freeze,
		adr-155:152-156). O unico caminho para prova forjada mover dinheiro e mis-implementar breach->
		freeze -- capturado por p11-breach-rate (target 0) e pelo sinal de falsificacao bilateral.
		Residual = limite de calibracao (N3), nao vazamento de piso.

		Demais vereditos: GARANTIA P10 estrutural -- PASS (N2 honesto que supervisorId-nao-omitivel so e
		REAL pos-materializacao, "compromisso, nao enforcement"; mesmo escopo aplicado ao enforcement do
		piso; status proposed e o gap explicito). TESE "override CUMPRE P10/P11" -- PASS (ponte solida: P10
		statement nomeia "aprovacoes humanas" como parte do gate, design-principles.cue:166-175, e inv-
		guard-deterministic JA manda override-do-guard = supervisedDecision, domain-model.cue:347-348;
		logo operacionaliza clausulas pre-existentes, nao institui excecao a P11). 7 pontos padrao: TODOS
		PASS -- fecho de inferencia (gap T2 -> prosa do canvas -> P10/invariante mandam a forma -> ADR
		materializa); necessidade/distincao (3 transicoes + piso + terminal-proprio, cada load-bearing);
		alternativas honestas (a/b/c reais, (c) concreta pois cmd-authorize-payment existe); consequencias
		nao suavizadas (N1/N2/N3, N2/N3 sao os limites honestos exigiveis); falsificacao bilateral
		observavel (overriddenConditions-com-crypto-falha vs freeze-sobre-stale); principios-com-mecanismo
		(P10/P11/P0/adr-128 cada um mostra COMO, relacoes verdadeiras vs os artefatos -- adr-128.cue:101
		confirma [P11,P10,P0]); zero alusao a processo (grep limpo). Conformidade: os 4 affectedArtifacts
		existem no disco (tq-adr-03 OK); metadata de risco coerente (tq-adr-02 OK); alternativas presentes
		(tq-adr-01 OK); rastreabilidade non-empty (tq-adr-04 OK). VEREDITO GERAL: 0 fail / 0 warn / 0 info.
		cue vet ./... EXIT=0. Estavel em 1 round.
		"""

	singleRoundRationale: """
		Estabilizou em 1 round porque o ataque adversarial central -- o piso inoverridavel numa fronteira
		regulatoria nivel-1 -- foi exercitado a fundo (tentativa explicita de construir caminho de prova
		ausente/forjada para escalated->authorized) e o design o fecha por mecanismo deterministico, nao
		por prosa: separacao por classe de condicao (escalated so para stale/ambiguo, canvas.cue:721;
		breach a freeze via p11-invariant-breach-detected, canvas.cue:737-740) com discriminador crypto-
		integrity ancorado em adr-128 e default lado-seguro na duvida (N3, adr-155:152-156). Os 7 pontos
		padrao e os dois vereditos secundarios (garantia P10 estrutural honestamente escopada a
		materializacao em N2; tese "override cumpre P10/P11" verificada contra P10 statement + inv-guard-
		deterministic verbatim no disco) tambem deram PASS na primeira passada, com cada afirmacao factual
		verificada via Read direto (os 4 affectedArtifacts existem; adr-128.cue:101 confirma [P11,P10,P0];
		cmd-authorize-payment existe em domain-model.cue:255 tornando a alternativa (c) genuina). cue vet
		./... EXIT=0. Nenhum finding fail/warn/info exigia correcao e re-rodada; nao havia delta a verificar
		num segundo round. Estabilizacao em 1 round e evidencia de revisao real -- ataque de seguranca
		conduzido contra o disco, nao bypass de formato.
		"""
}
