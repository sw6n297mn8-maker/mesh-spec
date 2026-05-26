package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr095RemovePhantomDomainArtifacts: build_time.#SelfReviewReport & {
	reportId: "srr-adr-095-remove-phantom-domain-artifacts"

	artifactPath:       "architecture/adrs/adr-095-remove-phantom-domain-artifacts.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-25"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			ADR-095 materializa o passo (ii) / D2/D3 do cutover adr-090: remover os
			phantoms universal-glossary.cue e business-model.cue do config autoral +
			regenerar o README derivado.

			Schema satisfaction (#ADR):
			- id "adr-095" (proximo livre real; adr-093/094 ja usados no branch;
			  adr-091/092 reservados por branches em flight).
			- decisionClass structural; decider founder; status accepted.
			- tq-adr-01 (alternativas): PASS — o context remete a alternativa
			  rejeitada no proprio adr-090 (gate config-path-existence permanente) e
			  documenta o default dead-by-default; a verificacao factual (ausencia +
			  zero WI no wave-plan) fundamenta a escolha.
			- tq-adr-02 (risco): PASS — reversibility high (edicoes de texto) +
			  blastRadius local (config + README derivado), coerentes.
			- tq-adr-03/04 (rastreabilidade): PASS — affectedArtifacts
			  [governance/readme/config.cue, README.md], ambos reais e alterados.
			- principlesApplied [P0, P12].

			Verificacao da execucao (local, cue v0.16.0): 6 edicoes cirurgicas no
			config (cada uma 1 ocorrencia); business-model/universal-glossary -> 0;
			ubiquitous-language preservado (3, drift de naming fora do escopo D2/D3).
			cue vet do config editado OK. README regenerado pelo gerador real
			(output.cue + #ReadmeConfig); diff GEN_ORIG vs GEN_NEW estritamente
			cirurgico (so as 6 remocoes), provando que o derivado nao ganha mudanca
			colateral.

			Nota: config.cue e README.md NAO sao tipos governados
			(artifact_type_for_path) — nao exigem SRR; este SRR cobre apenas o ADR.
			readme-coevolution nao e gate wired, entao a sincronizacao README↔config
			e feita por disciplina (regenerada no mesmo commit).
			"""
	}]

	findings: {}

	summary: """
		ADR-095 (structural) registra a remocao dos phantoms universal-glossary +
		business-model do config autoral (D2/D3 do adr-090, passo ii) e a
		regeneracao do README derivado. Default dead-by-default confirmado
		factualmente (ausentes + zero WI no wave-plan). 4 criterios tq-adr PASS;
		affectedArtifacts [config.cue, README.md]; principlesApplied [P0, P12].
		Escopo estrito aos 2 phantoms nomeados; ubiquitous-language preservado para
		decisao separada.
		"""

	singleRoundRationale: "Decisao de escopo contido (remocao de 2 phantoms confirmados mortos + regen do derivado), default ja decidido em adr-090; este ADR a executa. Verificacao factual (ausencia + wave-plan) e diff cirurgico do README validados localmente; rounds adicionais nao detectariam new findings."
}
