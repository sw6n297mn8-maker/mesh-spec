package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// SRR do PRÓPRIO adr-184 (a decisão), não da materialização. Quatro rounds de
// review por sub-agente isolado, conforme executionPolicy do quality-gate para
// artifactType "adr". Saída por exitOnMaxRounds com dois residuais aceitos com
// ressalva pelo founder — declarados aqui e no texto do ADR, não escondidos.
// A marca desta revisão: TRÊS erros de autoria foram achados e todos eram
// afirmações sobre o disco nunca executadas. A regra que o ADR registra no
// rationale é o produto deste SRR, não um enfeite dele.

adr184: build_time.#SelfReviewReport & {
	reportId: "srr-adr-184-cross-repo-effect-as-completion-condition"

	artifactPath:       "architecture/adrs/adr-184-cross-repo-effect-as-completion-condition.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-08-03"

	roundsExecuted: 4
	maxRounds:      4
	status:         "max-rounds-reached"

	roundDetails: [{
		round:     1
		failCount: 5
		warnCount: 1
		infoCount: 3
		summary: """
			Round 1 — sub-agente isolado, cold-read, com instrução de conferir NA FONTE cada uma de
			nove citações do ADR. Cinco fails, dois deles falsificações factuais.
			F1: o ADR afirmava que #TaskOutput era COMPARTILHADO por #TaskSpec e #WaveTask. Falso —
			duas definições independentes, work-governance.cue (package build_time) e
			artifact-schemas/wave-plan.cue (package artifact_schemas), sem import entre elas. O
			autor repetiu um comentário do próprio repo que era ele mesmo falso, sem conferir.
			affectedArtifacts estava incompleto em consequência.
			F2: contradição dec1×dec4 — o rascunho punha o sha do repo-alvo (fato pós-execução)
			dentro do output da task-spec (definição normativa pré-execução, identidade
			(id, version), outputs 'devem existir ao final'). Ou emenda de artefato normativo depois
			do trabalho, ou campo nunca preenchido.
			F3: a rejeição da alternativa (d) apoiava-se em restrição INEXISTENTE — 'um hash por
			evento'. gatesPassed é LISTA (work-governance.cue) e prova cross-repo já aterrissa nela
			(work-events/wi-159.cue traz 'codegen-pipeline').
			F4: alternativa ausente — .github/workflows/codegen-validation.yml já faz checkout do
			mesh-runtime a partir do spec e roda validate-codegen.sh. O ADR concluía 'prova não
			verificada' sem examinar o mecanismo de verificação que o próprio repo opera.
			F5: P0 auto-contraditório — codegen-validation-evidence.cue já é morada de prova
			cross-repo (gates, specCommit, runtimeCommit), e o rascunho instalava segunda morada
			enquanto invocava P0 para rejeitar a alternativa (a).
			CONSEQUÊNCIA DE PROCESSO: o F3 derrubou o argumento que sustentava uma decisão de
			desenho já tomada pelo founder (prova por output). O founder a REVERTEU com o disco na
			mesa. Todos os cinco verificados na fonte pelo autor antes de aplicar.
			"""
	}, {
		round:     2
		failCount: 6
		warnCount: 4
		infoCount: 0
		summary: """
			Round 2 — revisão do texto revisado, com os cinco fails do round 1 nomeados para
			conferência de fechamento na fonte (não pelo relato do autor).
			NF-1, decisivo: a justificativa do dec 3 para DUPLICAR a união era 'a direção de import
			declarada (governança→schemas) impede unificar'. Falso — quality-gate.cue importa
			artifact_schemas NO MESMO package build_time, oito arquivos sob governance/ fazem o
			mesmo, e não há aresta reversa. A direção HABILITA a unificação. Cadeia: a duplicação
			era eletiva, a negativa 'duplicação agravada' era auto-infligida, e def-085 deferiria um
			problema que a própria decisão criava e podia eliminar no mesmo commit — categoria que o
			critério anti-catch-all do CLAUDE.md exclui de #DeferredDecision. def-085 foi RETIRADO
			antes de nascer, e o founder registrou que o havia aprovado sobre premissa falsa.
			NF-2: o discriminante da 'união discriminada por shape' nunca foi declarado.
			NF-3: cardinalidade de effectProofs não declarada — forma estrita quebraria 60+ streams
			no primeiro passo bloqueante do CI.
			NF-4: segunda fronteira P0 — completion-gates.cue é catálogo canônico de nomes de gate e
			o dec 6 torna 'gate nomeado' load-bearing sem declarar a relação.
			NF-5: o TÍTULO ainda dizia 'provado por output' depois da migração para o evento; e a
			justificativa de reversibility ('resíduo em task-specs editáveis, não em log
			append-only') foi FALSIFICADA pelo próprio dec 4.
			NF-8: o dec 6 nomeava FF-CG-03 como o gate — e FF-CG-03 é cego a hand-authored, que é
			exatamente a natureza do motor e da tela da cotação, os dois trabalhos que motivam o ADR.
			PADRÃO NOMEADO neste round: segunda vez que a opção barata foi rejeitada por restrição
			inexistente. O autor estava verificando o que o ADR AFIRMA e não o que o ADR REJEITA.
			"""
	}, {
		round:     3
		failCount: 5
		warnCount: 7
		infoCount: 1
		summary: """
			Round 3 — com instrução de EXECUTAR o que fosse executável, não julgar por leitura.
			F1, o achado que justifica o round: a união escrita como o dec 3 a especificava — ramo
			local BYTE-IDÊNTICO, discriminação por presença pura — foi executada numa cópia do repo e
			QUEBROU. cue vet ./... exit 1 com 243 valores incompletos; cue export do wave-plan exit 1;
			e a cascata até o phantom-gate (gate REJECT): o gerador engole a falha do export em
			silêncio, devolve create_map vazio e fabrica 4 phantoms, com drift no structure-index.
			Motivo de CUE: ramo sem campo obrigatório fica INCOMPLETO, não errado, e a disjunção não
			resolve sem marcador de default. O conserto (`*` no ramo local) foi testado verde nos
			quatro gates — e contradiz 'byte-idêntico', que era decisão do founder, então voltou a ele.
			O autor REPRODUZIU o resultado independentemente antes de aceitar.
			F2: morada de #SubordinateRepo não declarada, num ADR cujo dec 3 é sobre localização
			canônica — auto-refutação.
			F3: architecture/shared-schemas/ nunca considerado como morada.
			F4: principlesApplied declarava P12 enquanto a decisão instala três regras sem fiscal.
			F5: work-governance.cue taskCompletion.requires enumera em prosa os campos do
			#CompletionValidation, e o dec 4 a torna incompleta — MESMA CLASSE dos itens (vi)/(xiv)/
			(xv) do N4 do adr-183, instalada no mesmo arquivo cujos comentários o dec 3 se orgulhava
			de corrigir.
			TERCEIRA OCORRÊNCIA da família, agora do lado da ACEITAÇÃO e não da rejeição. Foi este
			round que produziu a forma final da regra registrada no rationale do ADR.
			"""
	}, {
		round:     4
		failCount: 2
		warnCount: 5
		infoCount: 1
		summary: """
			Round 4 — último de maxRounds, com execução obrigatória do desenho completo.
			EXECUÇÕES VERDES, registradas: dec 2+3 (unificação + marcador de default +
			#SubordinateRepo) → cue vet exit 0, cue export do wave-plan exit 0, structure-index
			byte-idêntico, três drift gates 0/0/0, phantomCandidates vazio. Discriminação PROVADA:
			valor fora da enumeração → cue vet exit 1; campo estranho → exit 1 (closedness
			preservada). dec 4 (#EffectProof + effectProofs lista aberta) contra os 133 streams reais
			→ cue vet exit 0, export dos work-events exit 0, rebuild-projections exit 0,
			structural-check-runner 32 violações / 0 bloqueantes, igual ao baseline.
			FAIL-1 (residual aceito): o piso de adequação do gate — 'o declarante nomeia gate que
			FALHARIA se o efeito fosse revertido' — foi REFUTADO POR EXECUÇÃO nos dois runtimes: o
			revisor removeu efeitos hand-authored reais (a divulgação de POSTURA def-024 no frontend,
			o bloco de postura CORS no mesh-runtime) e os gates continuaram TODOS verdes. Pior, o
			piso pediria ao declarante uma afirmação sobre o disco que nada executa — a quarta
			ocorrência da família que este mesmo ADR proíbe. Rebaixado a LIMITAÇÃO DECLARADA (N8) por
			decisão do founder.
			FAIL-2 (fechado no mesmo round): architecture/shared-types/ existe e seu _meta diz 'tipos
			de baixo nível usados por múltiplos schemas' — descrição exata de #TaskOutput. Nunca fora
			apresentado ao founder, que decidira a morada sobre espaço de opções incompleto pela
			terceira vez nesta fatia. A alternativa foi executada (verde em tudo) e ADOTADA.
			WARN-1 (fechado): check-self-review.sh exige SRR de artifact-schema porque o dec 3 edita
			wave-plan.cue — verificado por execução (exit 1 sem o report). Virou o SEXTO ponto do N4.
			WARN-2 (residual aceito): o item (iv) do N4 é GUARDA, não necessidade — o uso vivo
			atravessa o pipeline sem tocar o script. Declarado como guarda no texto.
			WARN-3: a afirmação do autor de que DOIS comentários eram 'hoje falsos' era imprecisa —
			as structs eram byte-idênticas, então um deles era verdadeiro; o argumento correto era
			prospectivo. Corrigido.
			WARN-4: a aritmética que justificara remover P12 estava errada — o disco dá três pontos
			COM fiscal (enumeração, shape, closedness), e o precedente invocado (adr-183) MANTEVE
			P12 e o PARTIU. P12 restaurado na forma partida.
			WARN-5: '140 task-specs' repetido pelo autor várias vezes; são 138 wi-* (os outros dois
			são _constraints e _meta) — contagem de disco afirmada sem contar, no ADR que registra a
			regra contra isso. Corrigido.
			"""
	}]

	findings: {
		fail: [{
			criterionId: "uq-05"
			severity:    "fail"
			message: """
				FAIL-1 -- o gate nomeado pode nao cobrir o efeito, e nada verifica que cobre. Um gate
				incondicional verde prova AUSENCIA DE REGRESSAO no alvo, nao PRESENCA do efeito: um commit
				vazio passa build-test. Refutado por execucao nos dois runtimes (efeitos hand-authored reais
				removidos, gates verdes). NAO e coberto pela negativa de prova-nao-verificada: aquela e
				"ninguem verifica a prova", esta e "mesmo verificada, a prova nao implica o efeito". ACEITO
				COM RESSALVA pelo founder e declarado como N8 no ADR: o piso que o resolveria exigiria do
				declarante afirmacao sobre o disco que nada executa -- a quarta ocorrencia da familia que o
				rationale do ADR proibe. Sem ritual substituto: a limitacao fica declarada, nao mitigada.
				"""
		}]
		warn: [{
			criterionId: "uq-05"
			severity:    "warn"
			message: """
				WARN-2 -- o item (iv) do N4 (a guarda no generate-structure-index.py) nao se reproduz como
				NECESSIDADE: o uso vivo de effectExpectedIn atravessa o pipeline inteiro verde sem tocar o
				script. E defensavel como GUARDA -- a corrida da uniao ingenua provou que create_map controla
				o mascaramento de phantom, e o namespace de paths colide entre os tres repositorios. ACEITO
				COM RESSALVA e declarado como guarda no texto do N4, em vez de apresentado como necessidade.
				"""
		}]
	}

	summary: """
		Quatro rounds, saída por exitOnMaxRounds com dois residuais aceitos com ressalva. O valor
		desta revisão não está na contagem de findings e sim na natureza deles: TRÊS erros de
		autoria — 'um hash por evento', 'a direção de import impede unificar', 'ramo local
		byte-idêntico' — eram todos afirmações sobre o disco que nunca haviam sido executadas, e
		todos custaram decisões do founder tomadas sobre premissa falsa. Dois eram rejeições e um
		era aceitação, o que corrigiu a formulação da regra: o eixo não é aceitar-versus-rejeitar, é
		EXECUTAR-VERSUS-SUPOR. A regra ficou registrada no rationale do próprio ADR, com as três
		ocorrências nomeadas, porque um método que só existe no chat da sessão que o produziu não
		sobrevive à sessão seguinte. Os rounds 3 e 4 executaram o desenho em cópias do repositório
		em vez de julgá-lo por leitura, e foi essa mudança de método que pegou o defeito que teria
		deixado o main vermelho.
		"""
}
