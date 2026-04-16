package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr016: artifact_schemas.#ADR & {
	id:    "adr-016"
	title: "README machine-readable blocks como derived artifacts"
	date:  "2026-03-19"

	decisionClass: "structural"
	decider:       "founder"

	context: """
		O README.md contém 3 blocos machine-readable (repo-structure-paths,
		repo-artifact-schemas, repo-governance-protocols) que listam itens
		existentes no filesystem. Esses blocos são, por definição,
		materializações do estado do filesystem — mesma natureza de CLAUDE.md
		derivado de config.cue (ADR-004). A versão anterior deste ADR
		propunha phase CI separada (readme-coevolution) para detectar drift.
		Isso ignora a infraestrutura de derived artifacts já existente:
		#DerivedArtifact em repo-structure.cue e phase derived-artifact-sync
		(ADR-004). Alternativas consideradas:
		(a) manter phase separada readme-coevolution — rejeitada: duplica
		mecanismo que derivedArtifacts já resolve, violando P0;
		(b) tratar README inteiro como derivado — rejeitada: README tem
		conteúdo autoral humano (árvore visual, princípios, convenções);
		(c) estender #DerivedArtifact com blockId para suportar derivação
		parcial dentro de arquivo — escolhida: reutiliza infraestrutura
		existente com extensão mínima.
		"""

	decision: """
		Estender #DerivedArtifact com campo opcional blockId. Quando
		presente, o generator produz conteúdo do bloco para stdout e
		derived-artifact-sync compara contra o conteúdo entre marcadores
		<!-- BEGIN:{blockId} --> e <!-- END:{blockId} --> no arquivo path.
		Registrar 3 derived artifacts em derivedArtifacts.artifacts de
		repo-structure.cue:
		(a) repo-structure-paths — gerado a partir de diretórios depth ≤ 2
		    no filesystem (excl. .git/, .github/, cue.mod/);
		(b) repo-artifact-schemas — gerado a partir de *.cue em
		    architecture/artifact-schemas/;
		(c) repo-governance-protocols — gerado a partir de arquivos em
		    governance/*.cue, governance/build-time/*.cue,
		    governance/claude/*.cue (excl. self-reviews/, task-specs/,
		    projections/) e scripts/ci/, scripts/hooks/.
		Script existente check-readme-coevolution.sh recebe modo --block
		<id> para output individual de cada bloco. Modo --fix regenera
		todos os blocos in-place. Pre-commit hook (já existente) executa
		--fix e auto-stage README.md. Phase readme-coevolution eliminada
		de repo-structure.cue — sync é responsabilidade de
		derived-artifact-sync. Textual presence check (basename grep no
		corpo do README) permanece como complemento no script —
		derivedArtifacts não cobre árvore visual autoral.
		"""

	consequences: """
		Positivas: mecanismo único (derived-artifact-sync) para todos os
		artefatos derivados — CLAUDE.md e README blocks usam a mesma infra;
		pre-commit hook com --fix garante automatismo — blocos nunca ficam
		desatualizados se hook está instalado; extensão blockId é genérica
		para futuros artefatos derivados parciais; script e hook já existem
		e funcionam — custo de implementação é marginal (adicionar --block).
		Negativas: boundary semântico (mudança de papel de zona sem mudança
		de arquivo) não coberto por CI — mantido como disciplina de agente;
		derived-artifact-sync ganha complexidade marginal para resolver
		blockId (extrair e comparar bloco em vez de arquivo inteiro);
		textual presence check fica no script mas fora do contrato de
		derived-artifact-sync (heurística complementar, não derivação).
		"""

	status:        "superseded"
	supersededBy:  "adr-051"

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"governance/repo-structure.cue",
		"scripts/ci/check-readme-coevolution.sh",
	]

	derivedArtifacts: [
		"README.md",
	]

	principlesApplied: [
		"P0",
		"P12",
	]

	rationale: """
		P0 exige single source of truth — blocos machine-readable do README
		são materialized views do filesystem, reconhecê-los como derived
		artifacts é consequência direta. A infraestrutura de derivedArtifacts
		(ADR-004) já resolve sync de CLAUDE.md. Criar mecanismo paralelo
		(phase readme-coevolution separada) para o mesmo padrão viola P0
		(dois mecanismos de sync) e ignora investimento existente. Estender
		#DerivedArtifact com blockId é a menor mudança que unifica os dois
		mecanismos sob um único contrato de governança.
		"""
}
