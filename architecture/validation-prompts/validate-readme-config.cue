package validation_prompts

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

validationPrompts: "vp-readme-config": artifact_schemas.#ValidationPrompt & {
	id:    "vp-readme-config"
	title: "Validação semântica de README config (source CUE)"

	matchPatterns: ["^governance/readme/config\\.cue$"]

	appliesTo: ["readme-config"]

	reviewContract: "advisory-only"

	references: [
		"architecture/artifact-schemas/readme-config.cue",
		"architecture/design-principles.cue",
		"governance/repo-structure.cue",
	]

	checks: [{
		id:         "vc-rc-01"
		question:   "Cada tree.entries[].purpose articula POR QUE o diretório existe (papel conceitual no sistema, camada que ocupa, função que cumpre), ou só descreve O QUE contém — informação redundante com o nome do diretório?"
		lookFor:    "purpose do tipo 'diretório com arquivos X' ou 'contém Y do tipo Z'. Ausência de menção a papel cross-cutting, a camada (foundational/architecture/governance/etc), ou a constraint que justifica diretório próprio. Shape (MinRunes 20) garante extensão, não substantividade conceitual."
		outputMode: "finding-only"
		severity:   "fail"
		rationale:  "Purpose redundante com nome falha em sua função: novo leitor lendo README precisa entender por que o diretório existe (e não outra organização). Failure mode observado em waves de restruturação onde tree foi expandida mecanicamente."
	}, {
		id:         "vc-rc-02"
		question:   "tree.entries[].conventions são específicas ao papel do diretório (regras que aplicam ali e não em outros), ou são copy-paste de regras genéricas (\"seguir convenções de nomenclatura\", \"CUE como SoT\")?"
		lookFor:    "Conventions repetidas verbatim em múltiplas entries. Conventions que poderiam aplicar-se a qualquer diretório do repo. Ausência de regras específicas ao tipo de artefato governado pelo diretório (e.g., para architecture/adrs/: 'um arquivo por ADR, ID incrementa', não 'seguir convenções')."
		outputMode: "finding-only"
		severity:   "warn"
		rationale:  "Conventions genéricas duplicam P2/repo-structure.cue (P0 violado leve) e perdem valor informativo. warn porque algumas conventions cross-cutting realmente repetem-se legitimamente; agente externo julga substantividade."
	}, {
		id:         "vc-rc-03"
		question:   "Algum tree.entries[].purpose/conventions/rationale ou sections[].content duplica conteúdo cuja localização canônica é arquivo .cue OU poderia ser derivado automaticamente dele (e.g., listar princípios inline quando design-principles.cue é fonte; descrever schemas quando artifact-schemas/ existe; enumerar lenses quando architecture/lenses/ existe)?"
		lookFor:    "Listas de IDs (P0..P12, ax-01..ax-07, dp-XX) inline com descrições — duplica design-principles.cue/domain-definition.cue. Descrição de schemas com campos enumerados — duplica artifact-schemas/. Conteúdo que pareceria gerado por tooling se existisse (e.g., lista de subdomínios com descrições — derivável de strategic/subdomains/). README é índice + narrativa, não cópia de conteúdo .cue. Critério-chave: se o conteúdo poderia vir de cue export → text/template, não deve estar duplicado em prosa autoral."
		outputMode: "narrative"
		severity:   "fail"
		rationale:  "P0 (uma localização canônica) violado por construção quando README duplica .cue. Drift inevitável: founder edita .cue, esquece README. Pior: conteúdo derivável que poderia ser cue export → text vira manualmente mantido. Este é o check mais consequente do prompt — inverte a presunção de que prosa do README é autoral, e captura tanto duplicação direta quanto conteúdo que deveria ser gerado automaticamente."
	}, {
		id:         "vc-rc-04"
		question:   "Lendo cada sections[].content, o texto descreve o estado ATUAL do repo (verificável por inspeção do filesystem e dos artefatos), ou é aspiracional/stale (descreve plano não implementado, ou estado anterior a pivot)?"
		lookFor:    "Sections que mencionam diretórios não existentes, schemas não criados, agentes não materializados. Sections que descrevem fluxos descritos como vigentes mas cuja implementação foi superseded por ADR posterior. Sections cuja redação data de fase anterior do repo (revisar git history dos artefatos referenciados ajuda)."
		outputMode: "narrative"
		severity:   "warn"
		rationale:  "Section narrativa stale degrada confiabilidade do README como entry point. Diferente de tree.entries (auditáveis por filesystem), sections são prosa interpretativa — drift acumula em silêncio. warn porque stale-ness pode ser intencional (e.g., descrever roadmap)."
	}]

	rationale: "README.md é entry point do repo; readme-config.cue é fonte canônica per ADR-005. Validação semântica verifica dimensões que shape (MinRunes/MinItems) e CI (filesystem coverage check) não atingem: substantividade conceitual de purposes, especificidade de conventions ao papel do diretório, P0 (não duplicar conteúdo .cue ou derivável), e currency das sections narrativas. vc-rc-03 é o check de máximo valor — captura violações P0 que contaminam o repo por construção, incluindo conteúdo que deveria ser derivado automaticamente em vez de mantido manualmente em prosa."
}
