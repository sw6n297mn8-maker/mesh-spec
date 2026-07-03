package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// SRR do adr-168 — Gate de frescura de materialização (G1 tip + G2 renumeração
// + G3 eco; o disco decide no ato da escrita). executionMode isolated-subagent
// per executionPolicy (artifactType adr): review por subagente SEM histórico da
// conversa, com verificação factual integral via disco/git. 1 round, stable,
// 0 fail / 0 warn / 3 info.

adr168: build_time.#SelfReviewReport & {
	reportId: "srr-adr-168-materialization-freshness-gate"

	artifactPath:       "architecture/adrs/adr-168-materialization-freshness-gate.cue"
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
		warnCount: 0
		infoCount: 3
		summary: """
			Review em SUBAGENTE ISOLADO (sem histórico da conversa) contra uq-01..09 +
			tq-adr-01..04 com verificação factual integral via disco/git. Todas as afirmações
			verificáveis do ADR batem com o disco: (a) o script materialization-freshness.sh
			implementa G1 (check_tip, HEAD..origin/main, nomeia commits, exit 1), G2
			(check_assert, deriva próximo-livre de _next_num sobre git ls-tree origin/main = tree
			REMOTO, não working tree; STOP sem renumerar) e G3 (echo_state), com modos --echo/--ci
			e fetch_base → exit 2 em falha de rede; (b) 7 fixtures cobrindo os 4 asserts do
			incidente real (G1 nomeia 'other session: wi-148'; G2 --assert WI=147 → 'STOP
			renumeração' + '149'; exit 0 pós-rebase com WI=149; --ci → 'colisão add/add') + 3
			extras (ci_clean, echo, gate_ok_fresh); (c) refs cruzadas resolvem (adr-166, adr-167,
			config.cue, validate.yml — que de fato roda a suite E o --ci); P0/P10 fiéis a
			design-principles.cue; (d) reversibility medium + blastRadius cross-cutting justificados
			em bloco dedicado (padrão adr-167); (e) falsificationCondition com sinal observável
			genuíno (fixtures determinísticas + prova viva orgânica); (f) alternativas (a)-(d) são
			forks reais com rejeição substantiva. Fatos do context confirmados: PRs #196–#199 =
			adr-166(WI-147)/adr-167(WI-148); renumeração 147→149 (commit 31f3b76); config.cue E
			CLAUDE.md em sync (1× cada). Split adr-059 (affected/planned/derived) impecável.
			FINDINGS: (i-1, tq-adr-02) blastRadius no limite cross-cutting↔repo-wide (adiciona step
			CI + toca governança) — mantido cross-cutting por consistência com o molde adr-167
			(mudança estruturalmente idêntica, accepted); reclassificação é opção do founder, não
			defeito. (i-2, escopo) afirmação cross-repo 'rtd vive no mesh-runtime' não checável
			nesta sessão — corretamente marcada NON-GOAL/DIREÇÃO FUTURA não executada. (i-3, uq-08)
			cue vet não rodado no modo read-only da review; shape validado manualmente (todos os
			obrigatórios presentes; união accepted sem supersededBy; regexes ok; falsificationCondition
			com ambos campos non-empty) — cue vet ./... executado pelo principal após materializar.
			"""
	}]

	findings: {}

	summary: """
		adr-168 — Gate de frescura de materialização: o disco decide no ato da escrita. G1 (branch
		parte do tip de origin/main; git fetch + rev-list, atrás → PÁRA nomeando commits), G2
		(números WI/adr/def/ten re-derivados do REMOTO via --assert; divergência → STOP + confirmação
		do arquiteto; não renumera sozinho), G3 (todo reporte de proposta abre com eco de estado no
		contrato do agente). Enforcement no ponto de uso (padrão adr-167), zero memória humana — a
		frescura deixa de ser acidente do container efêmero decaindo pela vida da sessão. Motivado
		pelo incidente WI-147-stale desta sessão; a regra de sincronização NÃO existia escrita, esta
		fatia a escreve já como gate. Isolated-subagent review: 0 fail / 0 warn / 3 info; stable em 1
		round; conformance #ADR total.
		"""

	singleRoundRationale: """
		1 round: o conteúdo decisório atravessou o ciclo gated completo ANTES da materialização —
		pre-flight curto da fatia (achado: a regra não existia escrita; frescura como acidente do
		container), proposta D aprovada pelo arquiteto com forma corrigida (branch nova + PR separado
		após o merge do #200; commit único; número re-derivado pelo próprio gate), e implementação com
		o script testado 7/7 + suite completa 27/27 verdes ANTES desta review. A review isolada
		confirmou o registro contra o disco sem fail nem warn; os 3 info são não-acionáveis (i-1
		consistência de metadata com adr-167; i-2 escopo cross-repo já marcado non-goal; i-3 cue vet
		delegado ao principal pós-materialização, executado). A fatia nasce conforme a regra que
		institui — branch do tip (G1), WI-150 re-derivado pelo gate (G2) — o que é ele próprio
		evidência viva da falsificationCondition. Sem delta a re-rodar.
		"""
}
