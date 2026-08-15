package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr195ConstitutionTokenBindingAndEvidenceReopening: build_time.#SelfReviewReport & {
	reportId: "srr-adr-195-constitution-token-binding-and-evidence-reopening"

	artifactPath:       "architecture/adrs/adr-195-constitution-token-binding-and-evidence-reopening.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"

	// Rollout de quality-gate coloca 'adr' em isolated-subagent. O ambiente
	// desta missão (adr-193, sessão remota) não dispõe de dispatch de
	// subagente — mesma causa já registrada em disp-011 do
	// subagent-execution-log para a missão M7.5. Fallback: self-reported
	// com o motivo declarado, per CLAUDE.md/authoring-policy fallbackPolicy.
	// Nenhuma entry nova no log de dispatch: 'adr' NÃO está no rollout de
	// AUTHORING (authoring-policy) — nenhum dispatch de autoria era devido.
	executionMode: "self-reported"
	generatedAt:   "2026-08-15"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 1
		summary: """
			Round de FUNDAMENTAÇÃO — o risco próprio deste ADR é ser
			preferência estética com aparência de método. Verificações:
			(a) tq-adr-01: cinco alternativas com rejeição nomeada, sendo
			(b) e (c) as duas que doem — reclassificar sem tocar no
			critério (trata sintoma, a fábrica do erro continua) e liberar
			raio globalmente (destrói a lei semiótica de VI.4). (b) A
			cadeia de cada emenda foi verificada contra o texto vigente
			lido no disco, não de memória: o critério antigo está
			literalmente no cabeçalho de token-contract.cue ('o valor/range
			é fixado pela própria camada') e em tq-dsc-05; a via única de
			reabertura está em protectionClause.reopeningComplement; o
			quantificador está em layers.form.rootDecision. (c) As três
			evidências internas citadas no context foram conferidas nos
			arquivos: grid declarando-se convenção adotada (VI.4), familia
			calibratable com reservas (token familia) contra pesos bound, e
			os três tokens de movimento cujo constraints já dizia 'o RANGE
			é bound — o valor exato dentro dele é calibrável'. (d)
			tq-adr-03: os 4 paths de affectedArtifacts existem e foram de
			fato editados; derivedArtifacts confere com o diff real
			(structure-index regenerado; tree-generated e README não
			mudaram — verificado por git status após regenerate-derived).
			1 info: o ADR é longo para uma emenda de três parágrafos —
			mantido porque o context precisa carregar a evidência
			falsificadora e a rejeição de (c), que é o ponto onde uma
			leitura apressada erraria.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round de CONFORMIDADE e de não-regressão constitucional.
			cue vet ./... verde; cue export da instância composta resolve
			concreto com version 1.1, 31 tokens (30 + raio-expressao-humana),
			5 constitution-bound (pressionado, links, raio, movimento-easing,
			movimento-acao-do-usuario) e 26 calibratable — contagem conferida
			por export + script, batendo exatamente com a dec 4/5 do ADR.
			uq-03: adr-178, adr-193, adr-194 e pend-01 existem no disco; P0,
			P10, P12 e P14 existem em design-principles.cue. uq-04: nenhuma
			contradição com P10 — a emenda não cria linter constitucional
			nem transforma julgamento em gate; tq-dsc-05 permanece warn.
			uq-07: zero placeholder; nenhum valor de token foi escolhido —
			raio-expressao-humana nasce declaradamente SEM valor, o que o
			round conferiu no contrato. Não-regressão verificada por diff:
			os quatro verbos canônicos, as quatro naturezas, os cinco traços
			de personalidade, os 8 casos canônicos e as 5 pendências estão
			byte a byte intactos; o texto promulgado v1.0 dos três campos
			emendados permanece acima de cada 'Emenda 1.1 —'. tq-adr-02:
			reversibility medium justificada pelo custo assimétrico (barato
			no spec, caro se o runtime já calibrou sob a moldura nova), não
			por default. Zero findings — estável.
			"""
	}]

	findings: {}

	summary: """
		ADR de emenda (1.1) à Constituição do Design System: torna causal o
		critério de vínculo de token (VII), abre a reabertura por evidência
		para regra derivada (IX) e corrige o domínio do quantificador da
		geometria (VI.4), reclassificando 8 tokens e criando 1 escopado
		(raio-expressao-humana). Autorado em missão adr-193 sob autorizações
		D1-D4 do founder — a decisão semântica é do founder; este ADR a
		materializa. Round 1 cobriu a fundamentação (o risco é preferência
		disfarçada de método: alternativas, cadeia lida no disco, evidências
		internas conferidas); round 2 cobriu conformidade e NÃO-REGRESSÃO
		constitucional (contagem de tokens por export, verbos/naturezas/
		traços/casos/pendências intactos, texto v1.0 preservado acima de cada
		emenda). Estável em 2/4 rounds, zero findings fail ou warn. Limitação
		declarada e assumida no próprio ADR (N1): 'resta valor livre?' e a
		declaração da classe de superfície são interpretativos e ficam fora do
		alcance de gate determinístico — review, não CI.
		"""
}
