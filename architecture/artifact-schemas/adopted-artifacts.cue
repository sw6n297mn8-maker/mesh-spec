package artifact_schemas

// adopted-artifacts.cue — Schema para manifest de artefatos adotados.
//
// Cada repo que consome artefatos de tekton-spec mantém um manifest
// declarando quais artefatos adotou, de qual versão, com qual modo
// de adoção e hash de rastreabilidade.
//
// Instância singleton em governance/adopted-artifacts.cue de cada repo.
// Alinhado com FP-03 (compartilhamento opt-in), FP-07 (versionamento
// explícito) e FP-09 (localização canônica — L5 compromisso de cópia).
//
// Limitações conhecidas:
//   L1 — migration-pending exige hashes: interpretado como "arquivo
//         local já existe em transição". Se adoção futura sem cópia
//         local, usar sourceCommitHash do fonte e localContentHash
//         placeholder "sha256:0{64}" com overrideReason documentando.
//   L2 — Unicidade lógica (um artifact, um sourcePath por manifest)
//         não enforçada por shape. Enforçar por CI ou review.

import (
	"list"
	"strings"
)

#AdoptedArtifactsManifest: {
	repoId:      string & !=""
	lastUpdated: string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}$"
	artifacts:   [...#AdoptedArtifact] & list.MinItems(1)

	_schema: {
		location: {
			canonicalPathRegex: "^governance/adopted-artifacts\\.cue$"
			fileNameRegex:      "^adopted-artifacts\\.cue$"
			description:        "Manifest de artefatos adotados de tekton-spec."
			rationale:          "Singleton em governance/ de cada repo. Rastreabilidade de adoção per FP-03 e FP-07."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-aa-01"
			description: "Todo artefato verbatim tem hash verificável"
			test:        "Artefatos com adoptionMode verbatim têm sourceCommitHash e localContentHash preenchidos. Enforçado por shape."
			severity:    "fail"
			rationale:   "Verbatim sem hash é declaração de fidelidade sem prova."
		}, {
			id:          "tq-aa-02"
			description: "Não-verbatim tem overrideReason"
			test:        "Artefatos com adoptionMode != verbatim têm overrideReason preenchido. Enforçado por shape (validação condicional)."
			severity:    "fail"
			rationale:   "Divergência sem justificativa é drift não governado."
		}, {
			id:          "tq-aa-03"
			description: "Forked tem compatibilityStatement"
			test:        "Artefatos com adoptionMode forked têm compatibilityStatement preenchido. Enforçado por shape."
			severity:    "fail"
			rationale:   "Fork sem declaração de compatibilidade é risco de incompatibilidade silenciosa."
		}, {
			id:          "tq-aa-04"
			description: "Migration-pending tem plano e prazo"
			test:        "Artefatos com adoptionMode migration-pending têm migrationPlan e migrationDeadline preenchidos. Enforçado por shape."
			severity:    "fail"
			rationale:   "Migração sem plano e prazo é migração que nunca acontece."
		}, {
			id:          "tq-aa-05"
			description: "Hashes são consistentes com arquivos locais"
			test:        "localContentHash corresponde ao hash real do arquivo local. Advisory: CUE não computa hashes. Enforçado por CI ou tooling."
			severity:    "warn"
			rationale:   "Hash declarado diferente do real é drift não detectado."
		}, {
			id:          "tq-aa-06"
			description: "sourceVersion referencia versão existente"
			test:        "sourceVersion corresponde a tag ou commit existente no repo fonte. Advisory: cross-repo, enforçado por CI."
			severity:    "warn"
			rationale:   "Versão inexistente significa artefato não rastreável à fonte."
		}, {
			id:          "tq-aa-07"
			description: "Sem duplicatas lógicas no manifest"
			test:        "Cada artifact aparece no máximo uma vez. Cada combinação sourceRepo+sourcePath aparece no máximo uma vez. Advisory: CI ou review."
			severity:    "warn"
			rationale:   "Duplicata gera ambiguidade sobre qual entrada é autoritativa."
		}]
		rationale: "Critérios garantem rastreabilidade (hashes, versões), justificativa de divergência, plano de migração, e unicidade. 4 fail shape-enforced + 3 warn CI-enforced."
	}
}

// ── Adoption modes ──

#AdoptionMode:
	"verbatim" |          // cópia exata, hash deve bater
	"extended" |          // núcleo preservado + extensões locais
	"forked" |            // divergência intencional, compatibilidade declarada
	"migration-pending"   // arquivo local em transição, plano e prazo obrigatórios (L1)

// ── Artefato adotado ──

#AdoptedArtifact: {
	// Path do artefato no repo local.
	artifact: string & !=""

	// Repo fonte.
	sourceRepo: string & =~"^[^/]+/[^/]+$"

	// Path do artefato no repo fonte.
	sourcePath: string & !=""

	// Versão do repo fonte no momento da adoção.
	// Semver enforçado — decisão forte per FP-07.
	sourceVersion: string & =~"^[0-9]+\\.[0-9]+\\.[0-9]+$"

	// Hash do commit do repo fonte.
	sourceCommitHash: string & =~"^[0-9a-f]{40}$"

	// Hash SHA-256 do conteúdo local para detecção de drift.
	localContentHash: string & =~"^sha256:[0-9a-f]{64}$"

	// Modo de adoção.
	adoptionMode: #AdoptionMode

	// Data de adoção ou última atualização deste item.
	adoptedAt: string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}$"

	// ── Campos condicionais por modo ──

	overrideReason?: string & strings.MinRunes(10)
	if adoptionMode != "verbatim" {
		overrideReason: string & strings.MinRunes(10)
	}

	compatibilityStatement?: string & strings.MinRunes(20)
	if adoptionMode == "forked" {
		compatibilityStatement: string & strings.MinRunes(20)
	}

	migrationPlan?:     string & strings.MinRunes(20)
	migrationDeadline?: string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}$"
	if adoptionMode == "migration-pending" {
		migrationPlan:     string & strings.MinRunes(20)
		migrationDeadline: string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}$"
	}
}
