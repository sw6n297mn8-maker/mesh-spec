package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr131: build_time.#SelfReviewReport & {
	reportId: "srr-adr-131"

	artifactPath:       "architecture/adrs/adr-131-derive-scf-bounded-context.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-30"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			ADR-131 documenta a derivação do BC SCF — terceira aplicação de
			P13/adr-125 (N=3), segunda em section-by-section. Registra os 3 testes
			de separação (linguagem ubíqua: antecipação/reverse factoring/dynamic
			discounting/securitização, disjunta de cmt/fce/rew/inv/ctr/ins;
			invariante própria: composição multi-fonte de elegibilidade +
			estruturação-não-garante-funding; ownership canônico: AdvanceOperation
			+ ReceivableAdvanceOriginated/Settled) todos PASSED, o teste de remoção
			(INV/REW/FCE sobrevivem materializando/precificando/executando — só
			perdem o consumidor que converte recebível verificado em produto
			ativável → perda de função, não acoplamento), e a classificação das 6
			arestas (TODAS Tier 1 unidirecionais acíclicas; 0 ciclos; SCF folha
			downstream — consome inv/rew/fce/ctr/ins, publica para ato). Decisões
			de escopo: businessRole revenue-generator (1º revenue surface, dp-02);
			costsEliminated ce-06/07 encaixe direto (ce-07 bearer=sh-03 literal via
			cc-05); sem ADR de invariante (advance-requires-verified-receivable é
			INSTÂNCIA de P11/mech-evidence já existente, não princípio novo — como
			DRC, ≠ FCE/adr-128); ext-securitization-admin como openQuestion
			(oq-scf-1, fronteira externa declarada no subdomain mas não modelada,
			pattern uniforme via precedente ins-to-ext-insurers). tq-adr-01 PASSED:
			alternativas explicitadas e rejeitadas (merge SCF em CMT/INV/REW/FCE —
			rejeitado por 3/3 testes + 7 negativeBoundaries disjuntos; ADR de
			invariante próprio — rejeitado, P11 instância). tq-adr-02 PASSED:
			reversibility=medium, blastRadius=cross-cutting (SCF toca 6 BCs +
			context-map). tq-adr-03/04 PASSED: plannedOutputs=[canvas].
			principlesApplied=[P13,P11,P10,P0]. cue vet ./contexts/scf/ EXIT=0.
			Naming rew-to-scf reconciliado em adr-130 (mesmo PR). def-029 reavalia
			(14º canvas) mas status triggered founder-owned, N=3 < N>=4-5 do
			revisit — validation-prompt não materializado.
			"""
	}]

	findings: {}

	summary: """
		ADR-131 deriva o BC SCF via P13 (terceira aplicação, N=3): 3 testes de
		separação 3/3 + teste de remoção PASSED + classificação das 6 arestas
		(todas Tier 1 unidirecionais, 0 ciclos). businessRole revenue-generator;
		costsEliminated ce-06/07 encaixe direto; sem 2º ADR (P11 instância como
		DRC); ext-securitization-admin openQuestion. Naming em adr-130. cue vet
		EXIT=0.
		"""

	singleRoundRationale: """
		Conteúdo da derivação (S1 boundary-derivation, section-by-section com
		founder gate) é o registro canônico (Opção i — derivação não vira campo
		do canvas). Alternativas (merge; ADR de invariante) explicitadas e
		rejeitadas. SCF é folha downstream acíclica (0 ciclos), reduzindo a
		superfície de decisão de fronteira nova. Round único suficiente.
		"""
}
