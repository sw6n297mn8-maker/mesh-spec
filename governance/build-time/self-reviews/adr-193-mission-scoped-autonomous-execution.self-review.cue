package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr193MissionScopedAutonomousExecution: build_time.#SelfReviewReport & {
	reportId: "srr-adr-193-mission-scoped-autonomous-execution"

	artifactPath:       "architecture/adrs/adr-193-mission-scoped-autonomous-execution.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-08-13"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			Autoria em sequência das 3 sections do PG-ADR sob exceção pontual de section
			gate autorizada pelo founder (autonomia de autoria; substância pré-aprovada).
			tq-adr-01 ok: 5 alternativas (a-e) com motivo de rejeição declarado, nenhuma
			decorativa — (d) e (e) endereçam aparato já existente no repo. tq-adr-03 ok:
			governance/claude/config.cue e CLAUDE.md verificados no filesystem. tq-adr-04
			ok: affectedArtifacts e derivedArtifacts non-empty. uq-02 ok: context ancora em
			ds-buyer-procurement-journey, adr-174/WI-151, WI-152, WI-161, adr-177, adr-182,
			adr-148, adr-157, tq-gv-14 — não substituível por 'qualquer fintech'.
			FAIL (coerência integrada, detectada só na leitura das 3 sections juntas):
			status 'proposed' torna a decisão não-vigente por definição do schema
			('accepted: decisão aprovada e vigente'), enquanto a seção de ponteiro em
			governance/claude/config.cue passa a apontá-la como norma operante do modo —
			ADR mergeado como 'proposed' produziria ponteiro para norma inerte e o modo
			não entraria em vigor, anulando a finalidade da decisão.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Correção aplicada: status 'proposed' → 'accepted'. Não altera a substância
			aprovada — reflete aprovação explícita do founder à substância registrada
			ANTES da autoria, caminho que o PG-ADR admite ('accepted válido no commit
			inicial APENAS se founder aprovou explicitamente a decisão antes do commit'),
			e é o que torna o ponteiro coerente com a norma que ele referencia. Item
			sinalizado ao founder na proposta final como calibração a confirmar na revisão
			semântica única, junto de decisionClass/reversibility/blastRadius. Re-checagem
			pós-correção: tq-adr-02 mantém coerência (reversibility high justificado em P5
			e no bloco Metadata; blastRadius repo-wide justificado pelo alcance sobre o
			contrato comportamental de escrita dos três repos); demais critérios
			inalterados. cue vet ./... exit 0.
			"""
	}]

	findings: {}

	summary: "adr-193 estável em 2 rounds: 1 fail de coerência integrada (status inerte vs ponteiro operante) corrigido; alternativas, paths, rastreabilidade, risk metadata e specificity verificados."
}
