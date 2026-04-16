package readme

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// config.cue — Instância de #ReadmeConfig para mesh-spec.
//
// Scaffold inicial do adr-050 stage 3. Stages subsequentes expandem
// tree.entries para ~50 diretórios governados e sections para ~15
// narrativas extraídas do README.md atual (834 linhas).
//
// Conteúdo placeholder neste commit satisfaz shape mínimo de
// #ReadmeConfig (tree.entries MinItems(1), sections MinItems(1))
// apenas para permitir cue vet durante transição.

config: artifact_schemas.#ReadmeConfig & {
	repo:    "mesh-spec"
	heading: "Estrutura Canônica do Repositório de Especificação"
	description: #"""
		mesh-spec é o repositório de especificação do sistema Mesh. Todo artefato que descreve o que o sistema é e como se comporta vive aqui. Este documento (landing page derivada) é a única exceção ao formato CUE; todo conteúdo estrutural é governado via governance/readme/config.cue e regenerado por cue export.
		"""#
	tree: {
		rootPath: "mesh-spec"
		entries: [{
			path:    "architecture/"
			purpose: "Artefatos arquiteturais cross-context (ADRs, artifact schemas, design principles, lenses, conventions)."
			conventions: [
				"Schemas em architecture/artifact-schemas/.",
				"Decisões em architecture/adrs/.",
			]
			rationale: "Scaffold — expandir em stage 4 com cobertura completa dos diretórios."
		}]
		rationale: "Scaffold mínimo. Tree completa materializada em stage 4 de adr-050."
	}
	sections: [{
		title: "Status"
		content: #"""
			Este README está em transição de formato manual para governado via #ReadmeConfig (per adr-050).
			Scaffold inicial — conteúdo narrativo será expandido nos stages subsequentes.
			"""#
		rationale: "Marcar publicamente que o documento está em migração para evitar leitura enganosa."
	}]
}
