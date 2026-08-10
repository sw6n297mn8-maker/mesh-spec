package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr190VerifierIdentityResolution: build_time.#SelfReviewReport & {
	reportId:           "srr-adr-190"
	artifactPath:       "architecture/adrs/adr-190-verifier-identity-resolution-for-completion-v2.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"
	executionMode:      "isolated-subagent"
	generatedAt:        "2026-08-10"
	roundsExecuted:     4
	maxRounds:          4
	status:             "stable"
	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: "Review isolado da primeira versão integrada. 1 fail (uq-04): o conjunto compatible-grant da tri-conjunção já é entailed pelo invariante C do #VerifierRegistry adotado (_capabilityCovered) — verificado por teste: verifier active sem grant, ou com grant de outro assertion schema, não passa cue vet. O ADR apresentava ganho incremental inflado (P1 listava 'sem grant compatível' como recusa independente) e silenciava sobre as linhas 183-187 do schema na leitura da superfície pública."
	}, {
		round:     2
		failCount: 2
		warnCount: 1
		infoCount: 1
		summary: "Corrigido o uq-04 (redundância declarada; motivo da explicitude reescrito pelo founder como semântica normativa da resolução, NÃO defesa contra chamador frouxo; item novo exigindo Registry TIPADO como #VerifierRegistry). 2 fails novos: ponteiro interno obsoleto após renumeração ((dec 9) apontava para unicidade fail-closed, que virou item 10); e o trigger de def-085 media ARQUIVOS quando a limitação declarada supunha OCORRÊNCIAS, escondendo falso-negativo no cenário mais provável. 1 warn: plannedOutputs omitia def-085 (precedente unânime 5/5 lista o def)."
	}, {
		round:     3
		failCount: 1
		warnCount: 1
		infoCount: 1
		summary: "Ponteiros, plannedOutputs e par de triggers corrigidos. 1 fail: o item que institui a declaração de consumerhood era norma nova SEM enforcement determinístico, sem P12 em principlesApplied e sem tensão documentada — dois modos de falha (consumidor que omite o marcador cega o sensor; forma não fixada permite disparo falso). Founder decidiu Opção 1 + forma canônica + ten-018: gate determinístico com contrato estreito, forma CUE fechada, e a diferença norma-universal × cobertura-idiom-bound registrada como tensão."
	}, {
		round:     4
		failCount: 0
		warnCount: 2
		infoCount: 2
		summary: "Estabilizou nos fails (0). 2 warns materiais dispostos pelo founder SEM quinto round (maxRounds atingido; exitOnMaxRounds manda propor com disclaimer): (a) a declaração canônica no TOP-LEVEL colidiria em cue vet entre dois consumidores do mesmo package — o segundo consumidor quebraria o build em vez de disparar o sensor; corrigido pinando placement ANINHADO na definição do consumidor, com prova empírica das três propriedades (1 consumidor; 2 no mesmo arquivo; 2 em arquivos distintos — todos cue vet verde com a contagem esperada) e fixture da suite reescrita; (b) o gate compelia declaração de não-consumidores, alimentando o próprio sensor — reduzido ignorando linhas comentadas (idioma e declaração) e registrado como limitação (vi) em def-085. Infos: 'evita' → 'reduz' contagem incidental; teste de fronteira de escopo acrescentado. Disposição verificada deterministicamente, sem novo review isolado, por decisão explícita do founder."
	}]
	findings: {}
	summary: "adr-190 (resolução de identidade de verifier para completion V2 — exact-ref ∧ active ∧ compatible-grant sobre contrato re-derivado do stream público) estabilizou em 4 rounds de review isolado, com os findings do round final dispostos explicitamente pelo founder e verificados por prova determinística em vez de um quinto round. Correções substantivas ao longo dos rounds: redundância do conjunto compatible-grant declarada em vez de alegada como ganho; Registry consumido tipado como #VerifierRegistry (fronteira tipada não flexibilizada para teste nem consumidor futuro); declaração canônica de consumerhood com placement aninhado obrigatório, enforcement determinístico de contrato estreito, e o resíduo não-universal registrado em ten-018."
	singleRoundRationale: "N/A — 4 rounds executados."
}
