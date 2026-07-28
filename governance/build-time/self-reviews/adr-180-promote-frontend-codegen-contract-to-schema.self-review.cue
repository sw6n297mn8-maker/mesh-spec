package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr180PromoteFrontendCodegenContractToSchema: build_time.#SelfReviewReport & {
	reportId: "srr-adr-180-promote-frontend-codegen-contract-to-schema"

	artifactPath:       "architecture/adrs/adr-180-promote-frontend-codegen-contract-to-schema.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-28"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 2
		warnCount: 0
		infoCount: 0
		summary: """
			Sub-agente isolado (rollout adr → isolated-subagent) avaliou o
			draft contra uq-01..09 + tq-adr-01..04 com verificação de
			fidelidade das citações cross-file contra os arquivos reais.
			2 fails, ambos uq-03: (a) o context afirmava "SEIS transform
			stages" — o contrato v2.1 no disco tem SETE (WI-156 adicionou
			action-surface-p2p-triage); (b) o pacote do dec 5 omitia a
			expansão change-on-touch do sc-pg-01 (coveredSchemas +=
			"frontend-codegen-contract") que o molde adr-170 dec 6 declara,
			e affectedArtifacts não listava
			architecture/structural-checks/production-guide.cue. Main agent
			VERIFICOU ambos na fonte (contagem dos stages no contrato;
			texto do adr-170 dec 6) e CONFIRMOU; correções aplicadas:
			"SEIS"→"SETE"; dec 5 ganhou a frase do coveredSchemas;
			affectedArtifacts ganhou os 2 paths
			(quality-criteria + production-guide sc). Demais critérios sem
			finding; uq-09 não-avaliável pelo sub-agente — evidência de
			section gates vive neste report. cue vet OK (deterministicGate).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Re-avaliação do artefato corrigido com os findings do round 1.
			Ambos RESOLVIDOS: "SETE stages" fiel ao disco; dec 5 e
			affectedArtifacts completos com o passo change-on-touch do
			sc-pg-01. Regressão checada critério a critério: nenhuma (a
			cadeia adr-178 D3 → adr-179 → adr-180 permanece fiel; o
			precedente dec 6 cita adr-171 + sc-ag-03/adr-176 corretamente).
			Condição de estabilidade satisfeita: zero fail pendente, zero
			finding novo.
			"""
	}]

	findings: {}

	summary: """
		adr-180 autorado via manualAuthoringProtocol (PG-ADR, workOrder de
		3 sections) com section gates bloqueantes cumpridos na sessão
		2026-07-28: Section 1 (scaffold-and-classification) confirmada pelo
		founder com as 5 calibrações explícitas (structural / medium /
		cross-cutting / accepted-sem-commit-inicial com controle = os 3
		gates precedendo o commit, molde adr-178/179 / supersedes vazio);
		Section 2 (context-decision-and-alternatives) confirmada com 2
		ajustes de registro do founder (exclusão mútua POR SHAPE com os 2
		casos adversariais no structural-check; leitura interpretativa da
		prosa da query com alternativa descartada registrada no dec 4);
		Section 3 (consequences-rationale-and-traceability) confirmada sem
		ajustes. AMENDMENTS pós-gate com gate próprio, confirmados pelo
		founder na aprovação da escrita ("Amendments do §1 confirmados"):
		dec 1 realiza structs fechados por EMBEDDING + #ReadSurface como
		união query-backed | canvas-backed (canvas força
		hand-grandfathered); dec 5 ganha o passo coveredSchemas; context
		SEIS→SETE; affectedArtifacts +2 paths — evidência uq-09 (Camada 3)
		registrada aqui e nos roundDetails. Self-review em modo
		isolated-subagent per executionPolicy.rollout: round 1 → 2 fails
		(uq-03, verificados na fonte e corrigidos), round 2 → zero
		findings. Estável em 2/4 rounds. Na escrita, 2 correções de
		fidelidade factual declaradas no checkpoint da fatia: dec 5
		reescrito de "Phase 0 → autoria manual" para o regime real (Phase 1
		ativa; PG via dispatch disp-010, provado pelo
		subagent-execution-log) e "migrationRef e activeBoundaries
		resolvem" (o par sc-fcc-05/06 cobre ambos).
		"""
}
