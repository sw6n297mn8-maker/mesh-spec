package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

stakeholderMapWi157Reauthoring: build_time.#SelfReviewReport & {
	reportId: "srr-stakeholder-map-wi-157-reauthoring"

	artifactPath:       "domain/stakeholder-map.cue"
	artifactSchemaPath: "architecture/artifact-schemas/stakeholder-map.cue"
	artifactType:       "stakeholder-map"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-29"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		Round único (tipo fora do rollout isolated; modo self-reported):
		o conteúdo interpretativo foi decidido pelo FOUNDER em dois gates
		explícitos (direção D1-D4 com a tabela de derivação por
		stakeholder; consolidada com os textos sensíveis verbatim,
		incluindo a sanção explícita da entrada invertida do sh-06 como
		repurpose deliberado e declarado), e o verificável mecanicamente
		foi provado por script na fatia: 13 costRefs/0 dangling contra os
		ce-01..07 reais; categorias todas no enum de 7; TODAS as
		categorias obrigadas do tq-sm-04 (incl. adversarial-actor-class)
		com ≥1 vetor; unicidade de codes global e de int-*/pp-*/mv-*/
		platformRelationships por stakeholder (tq-sm-01/06/07 — as
		lacunas de runner cobertas por script nesta fatia); ids sh-01..06
		preservados na ordem (115 refs estruturais de canvas intactas);
		cue vet -c concreto. A dimensão restante é o founder review final.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Re-autoria completa na shape v1 (resolve def-076): 9 archetypes.
			Migração v0→v1 com os 4 campos sem destino caindo pela
			justificativa do próprio schema (registrada no header do
			arquivo); 18 concerns v0 redistribuídos em interests/painPoints
			com costRef — bearers explícitos dos ce mapeados diretamente
			(sh-01 ce-05/ce-02; sh-02 ce-06 blocking; sh-03 ce-07/ce-04/
			ce-01; sh-05 ce-03); CALIBRAÇÕES D4 do founder aplicadas como
			confirmadas: sh-03 com vetor derivado de domínio financeiro
			(rationale declara a derivação e a migração futura para análise
			por posição), sh-04 com ce-02 como espelho honesto na description
			(sem dor inventada; severity annoying), personas sh-07/08/09 com
			costRefs derivados da story e LACUNA NOMEADA nos 4 rationales
			onde o fit é imperfeito (sem ce novo); sh-06 com a entrada
			INVERTIDA do painPoint (custo que o design impõe ao ataque) —
			sancionada explicitamente pelo founder no OK da escrita como
			repurpose deliberado e declarado, coerente com a N3 do adr-181.
			Vetores com fonte por item: sh-01/02/05 verbatim dos canvases
			(p2p/ssc/bdg); sh-06 com os 5 R4+++ e attackSurface verificado
			nos canvases que os citam (drc/rew/bkr/fce/scf); personas com a
			forma-persona dos vetores org-level (fabricated-urgency;
			fragmentation-execution; supplier-favoritism; rubber-stamping —
			risco residual verbatim do canvas p2p). Personas como posições
			intra-org (adr-172 intocado — npm sem papel algum); story
			re-aponta os 10 actorRefs no mesmo commit (sc-ds-01 verde).
			"""
	}]

	findings: {}

	summary: """
		O artefato-núcleo do WI-157: a instância volta a unificar com o
		schema (fim do drift de 3 camadas do def-076) SEM fabricação — todo
		conteúdo interpretativo ou veio de fonte citada (canvases,
		domain-definition, story, instância v0) ou foi calibrado
		explicitamente pelo founder (D4 + sanção do repurpose do sh-06).
		Warns esperados e declarados: sc-sm-02 acusa sh-07/08/09 até a
		operacionalização das personas (WI-158+) — sinal honesto, não
		dívida escondida.
		"""
}
