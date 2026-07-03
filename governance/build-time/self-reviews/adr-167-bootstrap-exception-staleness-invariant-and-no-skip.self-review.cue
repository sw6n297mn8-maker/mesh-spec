package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// SRR do adr-167 — Regras A+B no check-self-review (invariante global de
// staleness das bootstrap exceptions + fim do SKIP; resolução do def-012).
// executionMode isolated-subagent per executionPolicy (artifactType adr):
// review por subagente SEM histórico da conversa, com verificação factual
// integral via disco/git. 1 round, stable, 0 fail / 1 warn (CORRIGIDO
// pré-commit) / 3 info.

adr167: build_time.#SelfReviewReport & {
	reportId: "srr-adr-167-bootstrap-exception-staleness-invariant-and-no-skip"

	artifactPath:       "architecture/adrs/adr-167-bootstrap-exception-staleness-invariant-and-no-skip.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-03"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 3
		summary: """
			Review em SUBAGENTE ISOLADO contra uq-01..09 + tq-adr-01..04 com verificação factual
			integral via Read/grep/git. cue vet ./architecture/adrs/ EXIT=0; conformance #ADR total
			(união accepted; regexes de path/filename/principlesApplied; falsificationCondition
			completa com sinal observável). Regras A+B verificadas NO DISCO: check_stale_transient_
			exceptions existe no check (transient-only, roda em todo run, falha nomeando 'exceção
			stale: quitar <path>'); is_bootstrap_exempt AUSENTE (grep exit 1) — o SKIP de isenção
			morreu como decidido. Testes 5/5 mapeando exatamente as 5 situações do decision item 6.
			Policy com 21 transient + 6 permanent (27 entries) conforme alegado; PR #198 verificado
			em origin/main (merge 6047008) — pré-requisito da Regra A nascer verde cumprido.
			tq-adr-03 path-a-path: 5/5 affectedArtifacts e 3/4 plannedOutputs existem (o 4º é ESTE
			SRR, materializado pós-review — pendência esperada do regime). Referências cruzadas 100%
			resolvidas (adr-013/014/015/040/070/071/166; def-012/014; ddp-001..004; P0/P10); def-012
			de fato especula sc-be-01 com as formas (a)/(b)/(c) e o kind fcoc permanece no schema
			como o rationale alega. tq-adr-01 PASS com 6 alternativas genuínas ((d) e (e) são forks
			reais com evidência de custo no disco: ddp-001 vivo; 6/6 permanent com SRR matching).
			tq-adr-02 PASS (medium/cross-cutting justificado em bloco dedicado; precedente adr-166).
			uq-09 N/A no subagente (precedente adr-166: isolado não recebe transcript; evidência de
			gates no singleRoundRationale). FINDINGS: (w-1, uq-05) N2 citava '24×~430 greps' —
			números datados pré-#198 contradizendo os '21 restantes' do próprio ADR; CORRIGIDO
			pré-commit para '21 entries transient × ~480 SRRs' (correção editorial de 1 linha,
			aplicada pelo principal antes do commit c1 — não permanece em aberto). (i-1) este SRR
			era a pendência de materialização — resolvida por este arquivo. (i-2) pendências do
			commit 2 confirmadas ainda-abertas per regime declarado: def-012 open sem resolvedBy,
			ddp-001 vivo no registry, asserts de calibração intactos. (i-3) rationale da policy
			ainda na natureza antiga — o commit 2 DEVE incluir a atualização para a afirmação do
			N3 tornar-se verdadeira (escopo do c2 confirmado).
			"""
	}]

	findings: {}

	summary: """
		adr-167 — Regras A+B no check-self-review: invariante global de staleness (Regra A,
		transient-only, todo run, falha nomeando a quitação pendente) + fim do SKIP de isenção
		(Regra B, todas as entries — isenção perdoa o passado, não o presente). A policy muda de
		natureza declarada: proveniência histórica (permanent) + fila de quitação enforçada
		(transient). Resolve def-012 por substituição honesta das opções (a)/(b)/(c) — enforcement
		no ponto de uso em vez de detecção externa — e aposenta ddp-001 (declared-but-unused; gate
		substitui sinal). Isolated-subagent review: 0 fail / 1 warn corrigido pré-commit / 3 info
		esperados pelo regime de 2 commits; stable em 1 round; cue vet EXIT=0.
		"""

	singleRoundRationale: """
		1 round: o conteúdo decisório atravessou o ciclo gated completo ANTES da materialização —
		pre-flight da fatia def-012 com evidência verificada em disco (3 stales empíricas; SKIP
		infiel ao exitCondition, caso a7126df; 6/6 permanent com SRR matching; associação por
		existência → custo one-time), adendo do arquiteto AMPLIANDO o requisito para as duas
		regras (a formulação anterior foi explicitamente descartada como insuficiente), aprovação
		integral com decisões fechadas (escopo B=todas; A transient-only; ddp-001 aposentado;
		sequenciamento PR-A primeiro — executado como #198), e implementação com testes de fixture
		5/5 verdes ANTES desta review. A review isolada confirmou o registro contra o disco sem
		fail; o único warn (drift numérico pré/pós-#198 no N2) foi corrigido no working tree antes
		do commit c1 e está registrado no roundDetails; os 3 info são pendências ESPERADAS do
		regime de 2 commits declarado no próprio ADR (SRR pós-review; c2 com def-012/ddp-001/
		rationale da policy). Sem delta a re-rodar.
		"""
}
