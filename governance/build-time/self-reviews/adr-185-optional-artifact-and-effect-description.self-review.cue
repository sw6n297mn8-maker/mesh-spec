package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// SRR do adr-185 (emenda ao adr-184: artifact opcional no ramo remoto do
// #TaskOutput + effectDescription com piso). Seis rounds — dois acima do
// maxRounds canônico, autorizados pelo founder com condição de saída
// emendada: fechar quando um round voltar sem fail de SUBSTÂNCIA (fails de
// contagem, citação de linha e resíduo de edição entram declarados e não
// impedem submissão). Os rounds 1-5 foram de revisor isolado; o round 6 é o
// FECHAMENTO, do AUTOR — divergência do executionMode do report, declarada
// no próprio round para que o zero-fail dele não seja lido como veredito de
// revisor isolado. O status é stable porque o protocolo CONCLUIU: todos os
// fails de todos os rounds foram corrigidos e verificados na fonte, nenhum
// residual de severidade fail ficou, e o último round (o fechamento) tem
// zero fail — o que satisfaz tq-srr-02 pelo fato, não pela contorção.

adr185: build_time.#SelfReviewReport & {
	reportId: "srr-adr-185-optional-artifact-and-effect-description"

	artifactPath:       "architecture/adrs/adr-185-optional-artifact-and-effect-description.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-08-06"

	roundsExecuted: 6
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 5
		warnCount: 8
		infoCount: 0
		summary: """
			Round 1 — self-review pré-proposta sobre o draft shape-only. Cinco fails que
			quebravam gate, todos verificados na fonte antes de aceitar: F1 (57 vs 58
			_meta.cue — número herdado de reporte anterior sem contagem própria); F2
			(derivedArtifacts vazio era falso — o próprio arquivo do ADR suja o
			structure-index, regenerate-derived --check exit 1); F3 (alargar o regex de
			commandId NÃO torna o gate dos work-events ligável — medido, 9 dos 14 streams
			também carecem de completionValidation); F4 ("três das quatro" task-specs
			falharam — são QUATRO, o caso do avanço dos pins tem segundo output sem path);
			F5 ("o shape nasce sem fiscal" era meia-verdade — a superfície #WaveTask
			ENFORÇA: descrição de 5 runes injetada em governance/wave-plan.cue dá cue vet
			exit 1; consequência de decisão: P12, excluído com base na frase falsa, foi
			restaurado em forma partida). Mais oito correções de texto.
			"""
	}, {
		round:     2
		failCount: 6
		warnCount: 5
		infoCount: 6
		summary: """
			Round 2 — primeiro round por sub-agente isolado sobre o texto corrigido. Seis
			fails: F1 (correção do 57→58 aplicada numa linha e esquecida na seguinte, na
			MESMA consequência); F2 (três contagens incompatíveis dos itens do adr-184:
			"dois itens" / "OITO itens" / "seis dos oito" — o certo é oito, conferido item
			a item); F3 (citação wi-024.cue:29-34 apontava o cabeçalho do evento; os dados
			flat estão em 35-37); F4 (o "ponteiro escrito dentro do adr-184" não existia e
			nenhum decision item mandava escrevê-lo — virou exigência do dec 3); F5 (o
			"segundo locus numa frase de context do adr-184" não foi encontrado pela
			busca); F6 (a pergunta 5 do reasoningProtocol da lens é drift detection, não
			lifecycle). Warns que mudaram conteúdo: W2 (path de 39 runes atravessa o piso
			— o degenerado que reabre a alternativa (c) por outra porta não estava
			nomeado), W4 (avaliação da lens rodou 6 das 11 perguntas), W5 (P10 invocado
			além do escopo — a rota canônica é validation-prompt advisory per adr-040).

			HARNESS DOS QUATRO CASOS, preservado aqui porque número de casos sem harness é
			afirmação não-reproduzível (origem do F4 do round 1). Os quatro trabalhos da
			sequência aprovada, instanciados como task-specs reais em cópia do repositório
			com o constraint das task-specs ATIVADO (arquivo _constraints.cue renomeado
			sem o prefixo "_"):
			  WI-901 "Pin do spec no mesh-runtime" — outputs: [{type: "create",
			    effectExpectedIn: "mesh-runtime"}] — sem path porque a forma do arquivo
			    pertence ao alvo (não há governance/ lá; a governança é docs/decisions.md).
			  WI-902 "Avanço dos dois pins com regeneração" — outputs: [{type: "update",
			    effectExpectedIn: "mesh-runtime"} (sem path: quem cria o arquivo é a
			    tarefa anterior, ainda não executada), {type: "update", effectExpectedIn:
			    "mesh-frontend-runtime", artifact: "governance/spec-pin.cue"} (com path:
			    ele já existe e é descritivo)].
			  WI-903 "Motor da cotação no mesh-runtime" — outputs: [{type: "create",
			    effectExpectedIn: "mesh-runtime"}].
			  WI-904 "Tela da cotação no mesh-frontend-runtime" — outputs: [{type:
			    "create", effectExpectedIn: "mesh-frontend-runtime"}].
			RESULTADO no shape do adr-184 (artifact obrigatório no ramo remoto): cue vet
			exit 1 e cue vet -c exit 1 nos QUATRO, com erro outputs.N.artifact: incomplete
			value !="" (o texto do erro sai com -c; sem a flag, apenas "some instances are
			incomplete"). RESULTADO no shape do adr-185 (cada output remoto ganhando
			effectDescription ≥30 runes): cue vet 0 e cue vet -c 0, repositório inteiro.
			BATERIA DE DISCRIMINAÇÃO (13 sondas, cada uma como task-spec real contra o
			constraint ativo): local puro → 0; remoto com path → 0; remoto sem
			effectDescription → 1; repo fora da enumeração → 1; campo estranho → 1;
			effectDescription sem repo → 1; type inválido → 1; artifact vazio → 1;
			descrição "x" → 1; "TODO" → 1; path de 23 runes (governance/spec-pin.cue) →
			1; path de 39 runes (scripts/ci/materialization-freshness.sh) → 0 (degenerado
			DECLARADO em N5 e vigiado no falsificationCondition); 30 espaços em branco →
			0 (declarado em N5). Reproduzido pelos revisores dos rounds 3, 4 e 5 a partir
			de cópia limpa, com os mesmos exits.
			"""
	}, {
		round:     3
		failCount: 2
		warnCount: 5
		infoCount: 5
		summary: """
			Round 3 — verificou as onze correções do round 2 (nenhuma introduziu erro
			novo) e achou dois fails novos: R3-F1 SUBSTÂNCIA (o dec 4 classificava a fatia
			do sexto template como "instanciação, não mudança de schema" — falso:
			#TaskTemplate.kind é enum FECHADO de cinco valores, task-template.cue:21, e os
			precedentes adr-042/adr-046 estenderam o enum por ADR decisionClass
			structural; como está, o dec 4 autorizava a próxima fatia a nascer sem ADR);
			R3-F2 TEXTO ("15 validation-prompts" — são 14; o 15º arquivo é o _meta.cue,
			mesma conflação que a correção F1 tinha eliminado de P5 duas seções acima).
			Warns: obrigação do dec 4 sem gate (circularidade declarada), appliesWhen das
			perguntas 9 e 10 da lens ignorado (desqualifica ambas — a conclusão passou a
			repousar só na pergunta 6), "as duas que restam" contra três pernas (a)(b)(c),
			"nem enforcement mudado" colidindo com P1/P12 do próprio ADR, e colisão de
			vocabulário ("discriminador" é termo que o adr-184 cunhou para
			effectExpectedIn — type não discrimina ramo).
			"""
	}, {
		round:     4
		failCount: 1
		warnCount: 5
		infoCount: 4
		summary: """
			Round 4 — primeiro sob a condição de saída emendada (classificação
			SUBSTÂNCIA/TEXTO obrigatória por fail). Um fail, SUBSTÂNCIA: o dec 3 afirmava
			que a obrigatoriedade de artifact vivia "EXCLUSIVAMENTE" no shape — falso.
			architecture/production-guides/task-spec.cue a carregava em múltiplos pontos,
			um deles o critério tq-tsg-03 com severity "fail" exigindo "cada outputs[] tem
			artifact (path canônico não-vazio)" — e o PG é lido section by section por
			quem autora task-spec (defaultMode manual na authoring-policy), que é
			exatamente o autor das quatro. Erro de ESCOPO de medição: busca no context do
			adr-184, conclusão sobre o repositório. Consequências que mudaram além do
			texto: affectedArtifacts incompleto, "sobram dois artefatos" falso, aplicação
			de P0 em principlesApplied falsa sem a correção do PG. Founder decidiu:
			corrigir o PG nesta fatia. Warns de texto: "os cinco overrides" vs vocabulário
			do task-governance.cue; alternativa (e) afirmava DE MENOS (o round 4 do
			adr-184 INSTANCIOU o ramo remoto sinteticamente, sempre com artifact
			preenchido — a regra 2 virou "instanciar sinteticamente não é usar"); ponte
			"sexto template exige kind novo" sem estatuto de julgamento declarado.
			"""
	}, {
		round:     5
		failCount: 3
		warnCount: 4
		infoCount: 0
		summary: """
			Round 5 — dois artefatos sob revisão (ADR + PG corrigido). Dois fails de
			SUBSTÂNCIA: R5-F1 (TERCEIRO locus da obrigatoriedade — o critério tq-wp-02 do
			architecture/artifact-schemas/wave-plan.cue, severity "fail", vivo em 6 SRRs,
			exigindo que "cada output.artifact usa um path que conforma com
			governance/repo-structure.cue" — colisão DURA: o path remoto que o dec 1
			declara legítimo, governance/spec-pin.cue do frontend, pertence a outro
			repositório e não conforma à estrutura deste por construção; escrever o caso
			BOM acionava um critério fail); R5-F2 (a correção do PG ficou incompleta em
			três pontos — collectFromFounder, que roda ANTES do workOrder e mandava
			coletar "lista de artifacts"; gapPolicy; ifGap da section 1, que mandava
			escalar ao founder exatamente o caso que a decisão normaliza). Um fail de
			TEXTO: "os cinco templates apontam preReads para outputs[0].artifact" — são
			quatro de cinco (tmpl-create-schema nem referencia outputs). Warns de texto:
			onze entradas scope "task" (não doze), "quatro pontos" do PG (a correção tocou
			oito e sobravam três), N5/lens no tempo verbal antigo, fatia seguinte com três
			arquivos (são quatro — o PG enumera "5 templates canônicos" em oito pontos).
			O revisor re-executou a bateria completa (16 sondas), os 131 streams e todas
			as contagens da fila — tudo bateu.
			"""
	}, {
		round:     6
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 6 — FECHAMENTO, e a divergência vem antes do resultado: este round foi
			executado pelo AUTOR, não por revisor isolado — diverge do executionMode
			deste report, e a declaração é o que torna o zero-fail dele honesto. Sem ela,
			seria lido como veredito de revisor. Conteúdo: as correções do round 5
			aplicadas e VERIFICADAS NA FONTE POR EXECUÇÃO — o tq-wp-02 do wave-plan.cue
			escopado por ramo (lido de volta no arquivo); os três pontos do PG
			(collectFromFounder, gapPolicy, ifGap) corrigidos por ramo e conferidos por
			grep; a varredura dos 1.563 arquivos versionados sem quarto locus da
			obrigatoriedade de artifact (o completion-gates.cue declarado como residual
			consciente, ver findings); e os gates re-rodados no repositório vivo: cue vet
			./... 0, check-self-review PASSED, --check structure-index 0, --check tree 0,
			structural-checks 32/0 bloqueantes, materialization-freshness ok. Nenhum fail
			novo, nenhum warn novo. Encerramento por decisão do founder sob o critério
			emendado, com a leitura integral do ADR pelo founder como revisão final.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "uq-05"
			severity:    "warn"
			message: """
				As correções do round 5 (tq-wp-02 escopado por ramo; collectFromFounder,
				gapPolicy e ifGap do PG; sete ajustes de texto no ADR) foram verificadas
				na fonte por execução no round 6 — mas pelo AUTOR, não por revisor
				isolado (divergência declarada no próprio round). Nesta linhagem,
				resíduo introduzido por correção foi classe real de defeito (o round 5
				achou tempo verbal antigo que a correção do round 4 não alcançou), e a
				verificação do autor não tem a independência que pegou esses casos. O
				founder assumiu a leitura integral do ADR como revisão final.
				"""
		}, {
			criterionId: "uq-05"
			severity:    "warn"
			message: """
				Locus residual da premissa "todo output tem path", declarado e
				deliberadamente NÃO corrigido: governance/build-time/completion-gates.cue
				(linhas 6, 107, 114) escopa a obrigação de ADR por "output path" em prosa
				de rationale, sem severity. Deixado de fora porque mexer nele arrasta a
				decisão de regime sobre obrigação de ADR, assunto de outra fatia. A fila
				do rationale do ADR ((i)-(iv) + fatia do sexto template) segue sem
				portador em disco — portador provisório é tarefa externa do founder, o
				que a N3 do ADR reconhece como ponteiro não-verificado.
				"""
		}]
		info: [{
			criterionId: "uq-03"
			severity:    "info"
			message: """
				Os três loci da obrigatoriedade de artifact apareceram UM POR ROUND (shape
				conhecido; PG no round 4; tq-wp-02 no round 5), cada um expandindo o
				pacote. A varredura que os encontraria de uma vez — dado o campo, listar
				todo criterio de qualidade cujo test o menciona, com severity — é mecânica
				e está registrada no rationale do ADR como candidata a tooling. Executada
				retroativamente pelo autor sobre os 1563 arquivos versionados: nenhum
				quarto locus com severity além dos três corrigidos e do completion-gates
				declarado acima.
				"""
		}]
	}

	summary: """
		Emenda ao adr-184 fechada em seis rounds — cinco de revisor isolado, um de
		fechamento pelo autor — sob condição de saída emendada pelo founder (fecha
		sem fail de SUBSTÂNCIA pendente; fails de texto entram declarados). Curva de
		fails dos rounds isolados: 5 → 6 → 2 → 1 → 3, com substantivos 2 → 2 → 1 →
		1 → 2 — o rendimento não caiu porque cada round encontrou defeito
		PRÉ-EXISTENTE do mecanismo do adr-184, não ruído do texto: o constraint das
		task-specs inerte (prefixo "_"), as três causas mascaradas em cascata nos
		work-events, a contradição shape-vs-alternativa-(c), e os três loci da
		obrigatoriedade de artifact (shape, PG task-spec com tq-tsg-03 fail, wave-plan
		com tq-wp-02 fail). Todos os fails de todos os rounds foram corrigidos e
		verificados na fonte; o round 6 registra essa verificação com a divergência
		declarada (autor, não isolado), e os residuais acima são warns de processo. O
		status stable descreve conclusão porque houve conclusão: último round com zero
		fail e zero fail finding — tq-srr-02 satisfeito pelo fato. O harness dos
		quatro casos reais vive no round 2 deste report e foi reproduzido pelos
		rounds 3-5 a partir de cópia limpa.
		"""
}
