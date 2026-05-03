package validation_prompts

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

validationPrompts: "vp-tension-entry": artifact_schemas.#ValidationPrompt & {
	id:    "vp-tension-entry"
	title: "Validação semântica de Tension Log entries"

	matchPatterns: ["^architecture/tension-log/ten-[0-9]{3}-[a-z0-9-]+\\.cue$"]

	appliesTo: ["tension-entry"]

	reviewContract: "advisory-only"

	references: [
		"architecture/artifact-schemas/tension-entry.cue",
		"domain/domain-definition.cue",
		"architecture/design-principles.cue",
	]

	checks: [{
		id:         "vc-te-01"
		question:   "Esta entry registra tensão genuína entre forças de design (axioma vs decisão concreta, schema vs modelagem necessária, atrito entre artefatos corretos), ou é gap de implementação rotineiro travestido? Se classificável como bug/gap → deveria ter sido um Work Item (WI), não uma tension-entry."
		lookFor:    "Description que descreve trabalho a fazer ('precisa criar X', 'falta implementar Y') sem identificar força de design tensionada. Resolution que enumera passos de implementação em vez de articular trade-off. Ausência de menção a axioma/princípio/limite de schema concreto. Padrão: 'gap', 'pending', 'TODO' como núcleo da description — sinal de WI travestido. Output do check: se classificável como WI, recomendar conversão (criar task-spec correspondente, considerar fechar a tension-entry)."
		outputMode: "narrative"
		severity:   "fail"
		rationale:  "Tension-log e WI têm propósitos disjuntos: tensão registra trade-off de design entre forças concorrentes; WI registra trabalho a executar. Misclassificação polui o tension-log com itens de backlog rotineiros e mascara verdadeiras tensões estruturais. Failure mode mais consequente porque inflaciona o log e degrada sua utilidade para agentes stateless recuperando contexto. Output deve ser acionável (recomendação de conversão), não só diagnóstico."
	}, {
		id:         "vc-te-02"
		question:   "kind reflete a natureza estrutural da tensão? axiom-tension quando axioma/princípio operacional envolvido; schema-limitation quando shape constrange modelagem necessária; cross-artifact-friction NÃO usado como catch-all (per comment do schema)?"
		lookFor:    "kind=cross-artifact-friction quando há axioma claramente envolvido (deveria ser axiom-tension) ou schema cuja limitação gerou a tensão (deveria ser schema-limitation). kind=axiom-tension sem id ax-XX/dp-XX/PX em tensionTarget. kind=schema-limitation sem path de schema em tensionTarget. Comment do schema explicita: 'Não usar como catch-all'."
		outputMode: "finding-only"
		severity:   "fail"
		rationale:  "Classificação preguiçosa em cross-artifact-friction (catch-all) destrói o sinal do kind para agregação posterior (e.g., listar todas axiom-tensions). Schema diretamente avisa contra; check captura compliance semântica que regex de tensionTarget não atinge."
	}, {
		id:         "vc-te-03"
		question:   "resolution especifica a alternativa escolhida E a alternativa rejeitada, com o que foi ganho e o que foi perdido? Ou é genérica ('aceito como trade-off', 'convive-se') que impede reavaliação futura?"
		lookFor:    "resolution sem nome da alternativa rejeitada. resolution sem articulação concreta de ganho específico (\"reduz custo\" sem dizer qual) e perda específica (\"aceita complexidade\" sem dizer qual). Padrão: resolution descreve apenas a escolha, omite o caminho não tomado e os custos do caminho tomado."
		outputMode: "finding-only"
		severity:   "fail"
		rationale:  "Resolution sem ganho/perdido concretos é declaração unilateral. Quando contexto mudar, agente futuro não tem informação para decidir se o trade-off ainda vale. tq-te-02 já cobre 'resolution descreve trade-off concreto' como fail estrutural; este check é a contraparte interpretativa que verifica substantividade real, não só presença textual."
	}, {
		id:         "vc-te-04"
		question:   "Lendo o arquivo apontado por manifestsIn, a tensão é observável concretamente naquele artefato? Ou a entry afirma manifestação que não é visível ali?"
		lookFor:    "manifestsIn aponta para arquivo onde nada do que a description menciona é visível. Padrão típico: manifestsIn é o próprio tension-entry file (auto-referencial) ou um path genérico (e.g., README.md) sem âncora específica. tq-te-03 é fail estrutural mas verifica apenas existência do path, não observabilidade da tensão."
		outputMode: "narrative"
		severity:   "warn"
		rationale:  "Manifestation invisível torna a tensão especulativa — não há onde verificar nem onde resolver. warn porque agente externo pode não conhecer profundamente o artefato apontado; founder pode confirmar."
	}]

	rationale: "Tension-log é fonte de verdade para trade-offs aceitos cross-context — agentes stateless dependem dele para recuperar contexto de decisões anteriores. Validação semântica verifica dimensões que o shape não captura: genuinidade da tensão vs WI travestido (failure mode mais consequente para utilidade do log; output acionável é recomendação de conversão), classificação correta do kind, substantividade da resolution para reavaliação futura, e observabilidade concreta da manifestação. Cada check é interpretativo por construção — análise determinística não atinge."
}
