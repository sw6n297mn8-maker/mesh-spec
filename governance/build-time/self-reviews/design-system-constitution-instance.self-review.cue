package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

designSystemConstitutionInstance: build_time.#SelfReviewReport & {
	reportId: "srr-design-system-constitution-instance"

	// A instância é COMPOSTA por 3 arquivos (merge de structs CUE);
	// artifactPath ancora no arquivo principal — o review cobre os três:
	// constitution.cue + canonical-cases.cue + token-contract.cue
	// (+ _meta.cue, metadata de diretório fora do tipo).
	artifactPath:       "architecture/design-system/constitution.cue"
	artifactSchemaPath: "architecture/artifact-schemas/design-system-constitution.cue"
	artifactType:       "design-system-constitution"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-08-14"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 2
		summary: """
			Round de PRESERVAÇÃO (a lei da missão M7.5): caminhada seção a
			seção da fonte (constitution-source.md, fornecida pelo founder)
			contra os 3 arquivos da instância — Preâmbulo, I, II (6
			invariantes + nota de fecho), III (3 blocos), IV (5 traços +
			estatutos incluindo a linha 'Derivada da arquitetura, não
			inventada' + fluxo causal), V.1, V.2 (enunciado + 4 naturezas
			tipadas + princípio absoluto + 4 perguntas), VI intro, VI.1-VI.6
			campo a campo (formas distintas preservadas: cor com 8 blocos;
			movimento com lei/teste de admissão/jurisprudência/dois mundos/
			anexo; linguagem com regras; procedência com mapeamento + 8
			regras), VII (intro em tokenRegime; TODOS os valores promulgados
			nos 30 tokens + interação na promulgationNote), VIII (8 casos
			verbatim), IX (3 parágrafos), 5 pendências com texto original
			preservado no content. Sonda mecânica: 38 frases distintivas da
			fonte grepadas nos arquivos — 38/38 presentes (2 falsos-ausentes
			iniciais eram quebra de linha, verificados presentes).
			2 infos de transcrição estrutural (não-semânticos): (i) marcação
			markdown (negritos, tabelas) convertida para prosa/lista tipada —
			as tabelas de IV e V.2 viraram traits/natures tipados sem perda
			de célula; (ii) cabeçalhos de seção ('Superfície (norma).',
			'Trade-offs nomeados.', 'Ícones.', 'Mapeamento das quatro
			naturezas.') mantidos DENTRO dos blocos de prosa onde a fonte os
			tinha como âncora do texto.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round de CONFORMIDADE e classificação: cue vet ✓; cue export da
			instância composta resolve CONCRETO (18 campos top-level, 30
			tokens, 8 casos, 5 pendências) — completude que o vet sozinho não
			prova. tq-dsc-01 ✓ (decisões-raiz/leis ancoram em I-V: cor na
			Lei da Atenção + tese; tipografia na Lei da Atenção; movimento na
			não-persuasão; forma na personalidade/precisão; linguagem na
			personalidade; procedência no Regime V.2). tq-dsc-02 ✓
			(trade-offs de cor/tipografia/forma preservados; movimento/
			linguagem/procedência sem seção de trade-off NA FONTE — nada
			fabricado). tq-dsc-03 ✓ (4 verbos como enum + uso consistente em
			VI.5/VI.6). tq-dsc-04 ✓ (5 classificações derivadas do texto per
			adr-194 dec 10; pend-05 com pointer de alçada). tq-dsc-05 ✓
			(30/30 tokens com derivesFrom por enum e regime decidido por
			texto citado em constraints: 13 constitution-bound / 17
			calibratable, contagem verificada por export+script). Zero
			findings — estável.
			"""
	}]

	findings: {}

	summary: """
		Instância canônica da Constituição do Design System (v1.0,
		promulgação julho/2026; canonizada por adr-194 na missão M7.5).
		Tipo novo FORA do rollout de execução isolada → modo self-reported
		por regra (defaultMode), não por fallback. Round 1 = preservação
		integral verificada (caminhada seção a seção + sonda mecânica de 38
		frases distintivas, 38/38); round 2 = conformidade de shape,
		completude do merge composto via export e classificação de tokens
		(13 bound / 17 calibratable) e pendências (1 empirical-calibration,
		2 deferred-decision in-artifact, 1 reserve-condition, 1
		out-of-scope-governance) derivadas do texto. Estável em 2/4 rounds;
		zero conteúdo 'melhorado' — mudanças são exclusivamente de forma
		(markdown → CUE tipado/prosa multiline).
		"""
}

// ── Emenda 1.1 (adr-195) ── segundo report sobre a MESMA instância
// composta: a emenda do critério de vínculo (VII), da via de reabertura
// por evidência (IX), do domínio do quantificador da geometria (VI.4) e
// a reclassificação de tokens no token-contract. Report separado, não
// edição do anterior: o de cima é o snapshot da canonização v1.0.
designSystemConstitutionAmendment11: build_time.#SelfReviewReport & {
	reportId: "srr-design-system-constitution-amendment-1-1"

	artifactPath:       "architecture/design-system/constitution.cue"
	artifactSchemaPath: "architecture/artifact-schemas/design-system-constitution.cue"
	artifactType:       "design-system-constitution"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-08-15"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 1
		summary: """
			Round de PRESERVAÇÃO (a lei que governa qualquer edição desta
			instância). Verificação por diff, não por leitura de memória:
			os três campos emendados — tokenRegime, protectionClause.
			reopeningComplement e layers.form.rootDecision — mantêm o texto
			promulgado v1.0 byte a byte, e cada emenda entra APENSADA
			abaixo dele com o prefixo 'Emenda 1.1 —' que a torna
			distinguível do promulgado. Nenhum outro campo normativo foi
			tocado: architectureInvariants (6), personality (5 traços +
			estatutos + fluxo causal), transversalLaws (Atenção + Regime de
			Procedência com as 4 naturezas), as demais cinco camadas,
			canonicalCases (8) e pendencias (5) saem idênticos ao diff.
			tq-dsc-02: nenhum trade-off pré-existente removido ou diluído —
			os de cor, tipografia e forma seguem íntegros; tq-dsc-03: os
			quatro verbos canônicos intactos em V.2, VI.5 e VI.6.
			1 info: a emenda de VI.4 é o bloco mais longo dos três porque
			enumera nominalmente o que a classe NÃO é — verbosidade
			deliberada, é ela que impede o vazamento do arredondamento.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round de COERÊNCIA da emenda com o contrato de tokens.
			cue vet ./architecture/design-system/ verde; export concreto
			com version 1.1 e 31 tokens. tq-dsc-05 sob o critério NOVO:
			os 5 que permanecem constitution-bound foram reconferidos um a
			um contra a pergunta causal e nenhum tem valor livre
			(pressionado é referência a tinta; links são duas atribuições
			semânticas; movimento-easing nomeia caráter e deixa a curva no
			runtime; movimento-acao-do-usuario não tem valor; raio carrega
			o significado semiótico de VI.4). Os 8 reclassificados
			declaram, cada um, a moldura em constraints com o trecho da
			camada que a fixa — piso, teto, relação, emprego ou condição —
			e preservam o valor promulgado marcado como 'Vigente:'.
			Coerência cruzada verificada: o raio narrow-scoped aponta o
			token novo, e o token novo aponta de volta a moldura da emenda
			de VI.4 sem repetir seu texto (P0). Nenhum valor escolhido,
			trocado ou recalibrado — conferido campo a campo no diff.
			tq-dsc-04: pendências não tocadas; pend-01 (teste ao sol) segue
			classificada como empirical-calibration e agora tem caminho
			operável para foco e tinta, que a emenda liberou da via de ADR.
			uq-09: a instância cai em defaultMode manual com PG existente —
			os section gates do manualAuthoringProtocol foram cumpridos, na
			forma que o próprio PG declara para missão adr-193 (a
			autorização explícita da missão cumpre o gate; o receipt final
			presta contas), com as autorizações D1-D4 no lugar da
			confirmação por section. Zero findings.
			"""
	}]

	findings: {}

	summary: """
		Segundo review da instância composta: a emenda 1.1 (adr-195), não a
		canonização. O risco governante aqui não é qualidade de redação — é
		PRESERVAÇÃO: emenda que 'melhora' o promulgado é a falha canônica
		deste artefato. Round 1 verificou por diff que os três campos
		emendados mantêm o texto v1.0 íntegro acima da emenda e que nenhum
		outro campo normativo se moveu; round 2 verificou a coerência com o
		token-contract sob o critério novo (5 bound reconferidos pela
		pergunta causal, 8 reclassificados com moldura escrita em
		constraints, 1 token novo sem valor). Estável em 2/4 rounds, zero
		findings. Limitação declarada: a distinção 'resta valor livre?'
		permanece interpretativa e fora do alcance dos gates determinísticos
		— sc-dsc-01/02 continuam cobrindo apenas co-presença dos arquivos.
		"""
}
