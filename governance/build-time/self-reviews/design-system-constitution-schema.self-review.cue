package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

designSystemConstitutionSchema: build_time.#SelfReviewReport & {
	reportId: "srr-design-system-constitution-schema"

	artifactPath:       "architecture/artifact-schemas/design-system-constitution.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-08-14"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 1
		infoCount: 0
		summary: """
			Nota de modo: rollout artifact-schema → isolated-subagent;
			dispatch indisponível no ambiente da missão M7.5 (disp-011) —
			self-reported honesto, com verificação mecânica dos contratos de
			tooling na fonte. 1 fail (uq-04/consistência com tooling
			declarado): o draft declarava cardinality "singleton" per decisão
			A da missão, mas a verificação do gerador
			(generate-structure-index.py build_index: singleton → literal_path
			→ present) prova que singleton com canonicalPathRegex de diretório
			(não-literal) entra PERMANENTEMENTE em missingSingletons como
			falso-ausente — sinal falso em artefato derivado de governança.
			Corrigido: cardinality "collection" registrando a forma física
			multi-arquivo, com a unicidade lógica declarada como invariante no
			comment + _schema.location.rationale e guardada por sc-dsc-01/02;
			desvio da decisão A documentado no adr-194 dec 1 e no receipt da
			missão. 1 warn (uq-05): instância multi-arquivo fica fora do
			alcance dos evaluators por-arquivo do runner V1 — limitação
			declarada no comment do schema e no structural-check (mitigada por
			enum fechado #DerivationSource via cue vet, P14).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Re-avaliação pós-correção: cardinality "collection" consistente
			com o contrato do tooling (structure-index lista os 3 arquivos da
			collection; zero entries falsas em missingSingletons — verificado
			na regeneração). tq-as-01 ✓ (_schema.location completo); tq-as-02
			✓ (tq-dsc-01..05 com test acionável cada — leitura dirigida contra
			seções nomeadas, enum checks, classificação por texto); tq-as-03 ✓
			(rationale do conjunto presente); uq-01 ✓ (rationales registram
			porquê — ex.: 'preferência não legisla' ancora tq-dsc-01); uq-08 ✓
			(cue vet + export da instância composta resolve concreto: 30
			tokens, 8 casos, 5 pendências). Enums fechados conferidos: verbos
			canônicos, #DerivationSource, changeRegime, classification,
			axis/statute — P14 aplicado onde o invariante é expressável em
			tipo. Zero findings novos — estável.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "uq-05"
			severity:    "warn"
			message:     "Limitação declarada e aceita: o conteúdo da instância multi-arquivo não é alcançável pelos evaluators por-arquivo do runner V1 (arquivo parcial não exporta — check de conteúdo seria vacuamente verde); cobertura determinística real = cue vet (enums/shape fechados) + sc-dsc-01/02 (co-presença). Evolução package-aware do runner é possibilidade futura, deliberadamente NÃO criada nesta missão (proibição de enforcement genérico novo)."
			rationale:   "Registrada como warn residual consciente (não resolvível sem criar maquinaria nova proibida pela missão); visível ao founder no PR."
		}]
	}

	summary: """
		Schema #DesignSystemConstitution (tipo novo, adr-194): molde
		_schema.location + _qualityCriteria seguido de adr.cue/
		deferred-decision.cue; prosa normativa em blocos multiline (precedente
		lens/ADR) com estrutura tipada só onde há uso mecânico. Round 1 achou
		1 fail real de contrato de tooling (cardinality singleton × regex
		não-literal → falso-ausente permanente) — corrigido para collection
		com unicidade lógica documentada; round 2 estável. Warn residual
		uq-05 declarado (alcance do runner V1 sobre instância composta).
		Modo self-reported por indisponibilidade de dispatch (disp-011).
		"""
}
