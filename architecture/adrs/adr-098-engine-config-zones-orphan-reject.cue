package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr098: artifact_schemas.#ADR & {
	id:    "adr-098"
	title: "Zonas engine/config fora do regime de artifact-schema + promoção de detecção de órfãos a reject"
	date:  "2026-05-26"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		adr-090 ativou o fileClassification: arquivos .cue em scope validado que
		não casam com nenhum _schema.location são "órfãos". def-018 deferiu a
		promoção órfão→reject até dupla condição: (1) schemas fundacionais
		existirem E (2) zero órfãos remanescentes. A condição (1) está satisfeita —
		adr-093 e adr-094 schematizaram design-principles e shared-types, e os
		triggers file-exists do def-018 dispararam. Mas o inventário ainda exibia
		21 órfãos.

		Triagem dos 21: 1 derivado (structure-index.cue); 10 arquivos que DEFINEM
		tipos (top-level #/_#) — incluindo a maquinaria de work-governance,
		quality-gate, authoring-policy, repo-principles e bounded-context-
		completeness; e 10 singletons de config/template da engine de governança
		(build-time, subsistema de render do CLAUDE/README, convenções). Nenhum é
		um tipo de artefato de domínio/arquitetura instanciável.

		Alternativa REJEITADA: schematizar os singletons (criar um artifact-schema
		para cada) só para zerar o gate. Reprovada — cria burocracia artificial
		impondo o regime de artifact-schema-instance sobre maquinaria que não é
		instanciável e que já é validada por cue vet + checks próprios (self-review,
		work-governance); inflaria a ontologia sem ganho de governança. Segunda
		alternativa REJEITADA: hardcode das zonas no runner (era o que o constante
		GOVERNED_ELSEWHERE fazia) — recria a duplicação declaração↔config que o
		adr-090 elimina, gerando novo drift-surface no próprio mecanismo anti-drift.
		"""

	decision: """
		(1) Conceito de ENGINE/CONFIG ZONE: governance/build-time/,
		governance/claude/ e architecture/conventions/ são zonas DENTRO de scope
		validado (cue vet aplica) mas FORA do regime de classificação por
		artifact-schema-instance. São maquinaria/config da engine de governança,
		não tipos instanciáveis. Declaradas em governance/repo-structure.cue
		scope.schemaExemptZones.

		(2) Schema: #Scope (architecture/artifact-schemas/repo-structure.cue) ganha
		schemaExemptZones?: [...string] — opcional, aditivo, default ausente=[].

		(3) Regra formal de TYPE-DEFINITION FILE: um .cue cujo conteúdo declara
		qualquer definição top-level (# ou _#) é arquivo de definição de
		tipo/schema, NÃO uma instância — portanto fora da classificação de
		instância. É decisão de classificação determinística (não heurística
		solta): a presença de def top-level é o discriminante.

		(4) fileClassification (runner E gerador) passa a excluir da classificação
		de instância, por um predicado ÚNICO compartilhado (classification_skip):
		(a) prefixos de schemaExemptZones; (b) artefatos derivados registrados —
		tanto os targets .cue (ex.: structure-index.cue) quanto os arquivos
		deriver/template que produzem cada derivedArtifact (o .cue que define o
		campo exportado pelo generator, ex.: `cue export ./governance/readme -e
		output` → governance/readme/output.cue); (c) type-definition files (regra 3).
		O hardcode GOVERNED_ELSEWHERE é REMOVIDO — vira exempt_zones() lido do
		declarado (governance/build-time/ subsume task-specs/work-events/projections).
		Runner e gerador leem a mesma fonte: os dois mapas não divergem.

		(5) PROMOÇÃO: com órfãos = 0, o built-in de órfão do fileClassification
		passa de INFO/non-counting para enforcement "reject" — conta e bloqueia em
		modo default (e --mode reject); report-only sob --mode warn. Simétrico ao
		enforcement por-check do adr-097, mas órfão é built-in do fileClassification,
		não um #StructuralCheck.

		(6) def-018 → resolved (resolvedBy = este ADR).

		FORA DE ESCOPO: promover o "ambíguo→reject" a blocking-por-default (0
		ambíguos hoje; built-in separado); schematização futura de qualquer zona
		que passe a hospedar tipos instanciáveis (aí sai de schemaExemptZones).
		"""

	consequences: """
		Positivas: (1) o gate de órfãos passa a IMPEDIR por construção a introdução
		de um .cue ungoverned em zona de domínio/arquitetura; (2) zonas engine/config
		reconhecidas pelo que são, sem burocracia de schema; (3) exclusões
		DECLARATIVAS (schemaExemptZones + derivedArtifacts + regra type-definition),
		não allowlist hardcoded (P0); GOVERNED_ELSEWHERE deixa de ser débito; (4)
		runner e gerador consistentes via predicado compartilhado.

		Negativas: (1) arquivos dentro das zonas e os type-definition files deixam
		de exibir o sinal "matched" do fileClassification — inclusive os próprios
		artifact-schemas (que são definições) saem do bucket matched do
		structure-index; mitigado: continuam sob cue vet + checks próprios; (2) a
		regra type-definition é por presença de def top-level — um arquivo que fosse
		simultaneamente instância E definisse um tipo top-level seria pulado (não
		ocorre no repo; documentado); (3) muda o contrato do runner (órfão agora
		bloqueia) — mitigado por self-test + verificação de órfãos=0 antes da promoção.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"architecture/artifact-schemas/repo-structure.cue",
		"governance/repo-structure.cue",
		"scripts/ci/structural-check-runner.py",
		"scripts/ci/generate-structure-index.py",
		"architecture/deferred-decisions/def-018-promote-orphan-detection-to-reject.cue",
	]

	principlesApplied: [
		"P10 — gates determinísticos validam: promove o built-in de órfãos a gate real (reject)",
		"P0 — localização canônica única: exclusões declaradas (schemaExemptZones + derivedArtifacts + regra type-definition), não allowlist; remove o hardcode GOVERNED_ELSEWHERE",
		"adr-090 — completa o componente fileClassification: resolve a categoria órfão sem punir a incompletude que o próprio adr-090 sequenciou",
		"adr-097 — alinha a semântica de enforcement (reject) ao built-in de órfãos",
		"dp-07 — evolução sem big-bang: promoção só após zero órfãos real",
	]

	defersTo: []

	rationale: """
		decisionClass structural: adiciona campo a #Scope, formaliza a regra de
		type-definition file, muda o contrato de classificação/exit do runner+gerador
		e o regime de zonas inteiras do repo — aplica P0/P10/adr-090/adr-097 sem
		redefinir princípios base. reversibility medium (aditivo + default-seguro,
		mas desfazer envolve schema + runner + gerador + instância + def-018);
		blastRadius repo-wide (gate de órfãos sobre o repo).

		Verificado antes da proposta: cue vet ./... EXIT 0; runner --self-test PASS;
		gerador --self-test PASS; após as exclusões, inventário de órfãos = 0 e
		ambíguos = 0; runner em modo default → 0 bloqueantes, exit 0 (os 21 findings
		remanescentes são sc-cv-02/03 em warn, intocados). A promoção NÃO quebra o
		CI. Resolve def-018: condição (1) por adr-093/094, condição (2) por estas
		exclusões.
		"""
}
