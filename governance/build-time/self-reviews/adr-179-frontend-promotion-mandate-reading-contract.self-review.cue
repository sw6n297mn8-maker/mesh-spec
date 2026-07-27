package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr179FrontendPromotionMandateReadingContract: build_time.#SelfReviewReport & {
	reportId: "srr-adr-179-frontend-promotion-mandate-reading-contract"

	artifactPath:       "architecture/adrs/adr-179-frontend-promotion-mandate-reading-contract.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-27"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			Sub-agente isolado (rollout adr → isolated-subagent) avaliou o draft
			contra uq-01..09 + tq-adr-01..04 com verificação de fidelidade das
			referências cruzadas contra os arquivos reais. 1 fail: uq-03 — seis
			posições citavam "adr-178 D4", atribuindo à decisão (4) do adr-178
			(não-padrão de origem net-new) o conteúdo da decisão (3) (promoção a
			schema ESPERADA e NOMEADA para a 3ª família). Main agent verificou
			contra o adr-178 (decision, linhas 121/126) e CONFIRMOU o finding;
			origem do erro: propagação do comentário de header do
			frontend-codegen-contract.cue linha 7, que carrega o mesmo
			"(adr-178 D4)" pré-existente — sinalizado ao founder para correção
			editorial no mesmo commit da emenda (dec 4 do ADR). Correção
			aplicada: 6× "adr-178 D4" → "adr-178 D3". Demais critérios sem
			finding no round (uq-01/02/04/05/06/07/08, tq-adr-01..04); uq-09
			não-avaliável pelo sub-agente — evidência de section gates vive
			neste report (ver summary). cue vet OK (deterministicGate).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Mesmo sub-agente isolado re-avaliou o artefato corrigido recebendo o
			finding do round 1. uq-03 RESOLVIDO: as 6 posições agora fiéis a
			"adr-178 D3"; zero resíduo "D4"; o slot (c) segue citando "critério
			do adr-178" sem número para o net-new (decisão (4)) — correto sem
			mudança. Regressão checada critério a critério: nenhuma (uq-06:
			convenções "DN"/"dec N"/"dec 2a-2c" com alvos explícitos, sem
			mistura; tq-adr-01/02: a lógica de rejeição da alternativa (b) e a
			metadata de risco nunca dependeram do número, apenas da localização
			correta do gatilho). cue vet OK. Condição de estabilidade
			satisfeita: zero fail pendente, zero finding novo.
			"""
	}]

	findings: {}

	summary: """
		adr-179 autorado via manualAuthoringProtocol (PG-ADR, workOrder de 3
		sections) com section gates bloqueantes cumpridos na sessão 2026-07-27:
		Section 1 (scaffold-and-classification) proposta com auto-check e
		confirmada pelo founder com calibração explícita de risk metadata
		(structural/high/cross-cutting); amendment de title/slug ("reading
		contract" — termo não-consolidado, verificado por grep) aprovado em
		gate próprio; Section 2 (context-decision-and-alternatives) proposta
		com auto-check e aprovada, depois amendada em gate próprio
		(reformulação do gap para a causa fundamental; non-trigger jurídico;
		aplicabilidade tipada do action-surface eliminando ambiguidade
		normativa entre famílias action-bearing e read-only) com aprovação
		explícita; Section 3 (consequences-rationale-and-traceability)
		proposta com auto-check, bloqueada pelo founder, corrigida
		(P2c/N2/falsificationCondition re-alinhados à aplicabilidade; papéis
		def-060 mecanismo runtime-local vs def-065 harness de evidência;
		adr-178 dono do gatilho vs adr-158 dono da relação de geração) e
		aprovada; principlesApplied (P0/P1/P10/P12) confirmados pelo founder.
		Cada section confirmada explicitamente ANTES da progressão — evidência
		do gate pattern registrada aqui e nos roundDetails (uq-09, Camada 3).
		Self-review integrado em modo isolated-subagent per
		executionPolicy.rollout: round 1 → 1 fail (uq-03, citação adr-178
		D4→D3, verificada contra a fonte e corrigida), round 2 → zero
		findings. Estável em 2/4 rounds; artefato apto à proposta final.
		"""
}
