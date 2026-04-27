package production_guides

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
)

// production-guide.cue — Meta-guide para autoria de production guides.
//
// PARTIAL — commit 1 da sequência (scaffold).
// _schema, _qualityCriteria e prerequisites substantivos.
// workOrder, sections e finalValidation com placeholders TBD a serem
// substituídos em commits 2 e 3.
//
// Schema alvo: #ProductionGuide em architecture/artifact-schemas/production-guide.cue
// (adotado verbatim de tekton-spec/portfolio/artifact-schemas/production-guide.cue).
//
// Auto-referencial: este guide é ele próprio uma instância de #ProductionGuide
// e satisfaz os critérios tq-pg-XX e tq-pgpg-XX que ensina.
//
// Resolve auto-violação de tq-as-05 latente em tekton e mesh (schema
// #ProductionGuide instanciável sem guide próprio).

productionGuideGuide: artifact_schemas.#ProductionGuide & {

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/production-guide\\.cue$"
			fileNameRegex:      "^production-guide\\.cue$"
			description:        "Meta-guide para autoria de production guides em mesh-spec."
			rationale:          "Schema #ProductionGuide é instanciável; tq-as-05 exige guide. Este artefato fecha a meta-recursão localmente em mesh, com candidato a promoção upstream a tekton (FP-02 ou equivalente)."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-pgpg-01"
			description: "Guide produz instância que satisfaz tq-pg-01 (workOrder == keys(sections))"
			test:        "Process inclui passo explícito de verificar workOrder como permutação exata das chaves de sections (mesmos elementos, sem duplicatas, sem omissões) ANTES de finalização. Verificado por inspeção do guide."
			severity:    "fail"
			rationale:   "Inconsistência workOrder ↔ sections é a falha #1 prevista para production guides; este meta-guide deve preveni-la por construção."
		}, {
			id:          "tq-pgpg-02"
			description: "Guide produz process steps com verbos imperativos concretos"
			test:        "Para cada section.process[].action: começa com verbo imperativo concreto da lista (Identificar, Declarar, Coletar, Compor, Verificar, Documentar, Pesquisar, Avaliar, Ler, Listar) ou sinônimo equivalente. Heuristics da section repete a regra. Inspeção determinística por análise da primeira palavra de cada action."
			severity:    "warn"
			rationale:   "tq-pg-06 (advisory) do schema requer ações acionáveis; este meta-guide é onde a disciplina é instilada antes da escrita."
		}, {
			id:          "tq-pgpg-03"
			description: "Guide produz finalValidation que termina com submissão ao founder"
			test:        "finalValidation.steps[-1] menciona explicitamente submissão, revisão ou aprovação do founder. Process do guide inclui passo declarando esta exigência. Verificado por inspeção."
			severity:    "fail"
			rationale:   "tq-pg-05 (warn no schema, fail aqui no meta-guide) garante o ciclo propor→aprovar→escrever. Quebra elimina o gate humano."
		}, {
			id:          "tq-pgpg-04"
			description: "Guide produz gapPolicy que declara comportamento anti-invenção"
			test:        "gapPolicy declara explicitamente comportamento anti-invenção (contém substring 'NÃO invent' ou 'NÃO infer' ou equivalente direto). E heuristics em pelo menos 1 section reforça o princípio. Inspeção determinística por presença de cláusula proibitiva."
			severity:    "fail"
			rationale:   "tq-pg-04 advisory requer gapPolicy substantiva; meta-guide eleva a fail para forçar disciplina anti-fabulação. Sem cláusula proibitiva explícita, agente preenche por analogia ou inferência heurística — fonte primária de drift."
		}]
		rationale: "Critérios cobrem as quatro falhas estruturais previstas para production guides: inconsistência workOrder↔sections (tq-pgpg-01), process vago (tq-pgpg-02), finalValidation sem founder gate (tq-pgpg-03), gapPolicy permissiva à invenção (tq-pgpg-04). Schema #ProductionGuide tem tq-pg-XX cobrindo subconjunto; meta-guide hardens severities (warn→fail em 01, 03, 04) onde fabricação por agente é risco crítico."
	}

	prerequisites: {
		description: "Antes de criar production guide para um schema alvo, agente lê o schema, consulta instâncias existentes (se houver) e guides existentes para outros schemas, confirma com founder o escopo do guide e coleta intent semântico."
		collectFromFounder: [
			"Confirmação do schema alvo (path completo + nome do tipo, ex.: 'architecture/artifact-schemas/foo.cue / #Foo')",
			"Confirmação de que schema é instanciável e merece guide (default é guide obrigatório por tq-as-05; exceção rara para schemas meta-utility deve ser explicitada)",
			"Quaisquer constraints de fase ou contexto (ex.: 'em Fase 0 este schema só é usado por agente, não autor humano' — afeta validatorNote e outputNote)",
			"Heurísticas tácitas que o founder usa ao avaliar instâncias do schema mas que não estão em quality criteria — candidatos a heuristics no guide",
		]
		gapPolicy:     "Se schema alvo não existe ou ainda não foi adotado, NÃO crie o guide especulativamente — postergue até schema existir. Se schema existe mas não tem instâncias autoradas, USE o schema como única fonte (comments + quality criteria) — NÃO invente process steps por analogia com guides de outros schemas. Se founder não souber articular heurísticas tácitas, OMITA o campo heuristics na seção em vez de inventar regras. NÃO copie process steps de outro guide existente sem verificar aderência ao schema alvo — cada schema tem semântica própria. Quando dúvida persistir, pergunta direta ao founder; nunca preencha por inferência heurística."
		validatorNote: "Em Fase 0, validação é review com founder na sessão. Quando structural-check de production-guide-coverage existir (post-motor de build-time), validação automatiza-se via tq-pg-01..06 do schema."
		outputNote:    "Output é arquivo único <schema-basename>.cue em architecture/production-guides/, instanciando #ProductionGuide. Tamanho típico: 30-150 linhas dependendo da complexidade do schema alvo. Para schemas triviais (3-5 campos), guide minimalista de 30-50 linhas é aceitável e esperado."
	}

	workOrder: ["tbd"]

	sections: {
		"tbd": {
			target:    "#ProductionGuide"
			objective: "TBD — section substantiva em commit 2 da sequência."
			process: [{
				action: "TBD substituído em commit 2 da sequência ADR"
				detail: "Placeholder mínimo satisfazendo schema MinRunes(10)."
			}]
			doneCriteria: "TBD — substituído em commit 2 da sequência."
		}
	}

	finalValidation: {
		steps: [
			"TBD — finalValidation substantiva em commit 3 da sequência.",
		]
	}
}
