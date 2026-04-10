package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

scfSubdomain: build_time.#SelfReviewReport & {
	reportId: "srr-subdomain-scf"

	artifactPath:       "strategic/subdomains/scf.cue"
	artifactSchemaPath: "architecture/artifact-schemas/subdomain.cue"
	artifactType:       "subdomain"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-04-07"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		Backfill batch isolado da Fase 1 de adr-043: única mudança é
		adição do campo verticalApplicability ao subdomain SCF
		(estável historicamente). Nenhuma alteração em definition,
		purpose, negativeBoundaries ou rationale. Round único é
		suficiente porque o escopo da revisão é apenas o novo campo
		e sua coerência com o conteúdo pré-existente do artefato.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 (adr-043 Fase 1 backfill — descida ao plano operacional):
			adicionado campo verticalApplicability ao subdomain SCF.
			Classificação: vertical-agnostic (sem primaryVertical).

			Análise estrutural: SCF estrutura produtos financeiros
			padronizados do mercado global (antecipação de recebíveis,
			reverse factoring, dynamic discounting, capital de giro,
			securitização). Nenhum desses produtos carrega vocabulário,
			mecanismo ou premissa construção-específica — são padrões
			exógenos da disciplina de Supply Chain Finance, aplicáveis
			a qualquer cadeia produtiva B2B com recebíveis rastreáveis.

			Smoking gun: o próprio rationale pré-existente do subdomain
			autoatesta universalidade ao declarar que produtos de SCF
			"são padrões exógenos do mercado financeiro — não
			proprietários à Mesh" e que "o diferencial proprietário é
			o lastro em evidência verificável (mech-evidence via DLV)
			e o pricing baseado em dados observados (mech-network via
			REW)". O binding construção-específico, se existir no plano
			financeiro da Mesh, vive upstream em DLV, INV e REW — não
			em SCF. SCF é orquestrador.

			Menções regulatórias (FIDC, CVM, performance bonds) foram
			analisadas separadamente: são âncoras jurisdicionais
			(Brasil), não setoriais. FIDC pode securitizar recebíveis
			de qualquer vertical. Esta observação tangencial sobre
			eixo jurisdicional vs vertical foi notada mas não registrada
			como tensão — ainda sem massa empírica suficiente.

			Calibração da heurística de ten-007: hipótese a priori era
			vertical-adaptable/construction (~50-60% confiança); análise
			revelou vertical-agnostic com alta confiança (~90%). Erro
			de calibração no sentido conservador — observado e
			registrado para uso futuro.

			Cross-plane test: SCF não possui canvas no repositório
			(apenas cmt, ctr, idc e npm têm canvas). Cross-plane test
			fica como observação futura para quando o canvas de SCF
			for autorado.

			tq-sd-08 (novo critério em subdomain.cue) pass: campo
			presente, mode coerente com evidência estrutural, rationale
			explícito sobre por que SCF é universal (núcleo é padrão
			exógeno do mercado financeiro, não construção-específico).
			cue vet pass.
			"""
	}]

	findings: {}

	summary: """
		SCF estável em round único. Adição do campo verticalApplicability
		(mode: vertical-agnostic) como parte do backfill Fase 1 de
		adr-043. Primeira descida ao plano operacional (subdomain) no
		piloto. Nenhuma alteração em outros campos do subdomain.
		"""
}
