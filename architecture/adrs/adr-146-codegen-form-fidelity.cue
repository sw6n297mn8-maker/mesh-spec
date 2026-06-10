package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-146 -- Fidelidade de forma no codegen: estabelece P14 + reinterpreta o
// item 2 de adr-140 (.proto deixa de ser IR-de-domain-types; tipos vem do
// cue.Value direto, preservando exaustividade + presenca). Filho de adr-140
// (contrato de codegen) e adr-139 (filtro spec x runtime). adr-140 permanece
// proposed; este ADR reinterpreta o escopo de um item, nao supersede.

adr146: artifact_schemas.#ADR & {
	id:    "adr-146"
	title: "Fidelidade de forma no codegen: P14 + geracao de domain-types do cue.Value"

	date: "2026-06-10"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		adr-140 (contrato de codegen) fixou que o codigo e gerado de CUE (P1) via pipeline CUE -> .proto -> tipos na linguagem-alvo (item 2). Mas P1 fixa apenas PROVENIENCIA (o codigo e gerado, nunca escrito a mao) e compatibilidade como gate -- nao exige que a geracao PRESERVE A FORMA compile-time-verificavel da spec. Um pipeline que gera tipos degradados (enum aberto, presenca opcional) satisfaz P1 literalmente e ainda assim deixa o compilador incapaz de recusar estados ilegais. Esta lacuna nao tinha principio que a fechasse.

		Evidencia medida (investigacao descartavel, fora do repo): (spike 2) o intermediario proto3 APAGA dois invariantes que a spec CUE expressa -- exaustividade-de-estado (proto3 enum e aberto, UNRECOGNIZED) e presenca-de-campo (escalar proto3 nao tem presenca); o codigo gerado via protoc vaza ambos para runtime em Kotlin e Rust. (spike 3) gerar os tipos do cue.Value DIRETO (via API Go cuelang.org/go) preserva ambos -- disjuncao fechada -> sealed/enum, required -> non-null/non-Option -- forcados pelo compilador. (spike 4) das construcoes de cauda do CMT, 16/16 probes de violacao FORCAM compile-error nos tipos gerados do cue.Value (struct aninhado, sum-type-com-payload, listas, maps, escalares, wrappers de constraint); a parte compile-time dos bounds/regex e o tipo-embrulho inescapavel, a checagem-de-valor roda no construtor. O conjunto de construcoes do dominio CMT mostrou-se enumeravel e fechado (18 construcoes; cauda com zero instancias no disco).

		Alternativas avaliadas: (a) gerar tipos via JSON Schema + typify/quicktype -- rejeitada: JSON Schema e hostil a tipos nominais (sem newtype), residuo anyOf/allOf, e a presenca degrada ("required" e lista lateral, nao tipo); mesma classe de perda do proto3. (b) Pkl (Apple) como IR de tipos -- rejeitada: perde a unificacao-por-lattice do CUE (P0/P1 dependem da spec CUE como SoT unica) e adiciona segundo motor de schema. (c) tipos escritos a mao na linguagem-alvo -- rejeitada: fura P1 (codigo de dominio escrito a mao diverge da spec). (d) aceitar a perda de forma (manter proto3 como IR de tipos) -- rejeitada: viola a regra-raiz (todo invariante compile-time-verificavel deve ser forcado pelo compilador) e empurra para runtime estados que o compilador poderia recusar de graca -- inaceitavel num sistema financeiro.
		"""

	decision: """
		(1) ESTABELECER P14 (fidelidade de forma do codegen) em architecture/design-principles.cue, grupo DesignPhilosophy: todo invariante compile-time-verificavel e forcado pelo compilador; nenhum e delegado a runtime; capacidades-minimas da linguagem-alvo (sealed/enum fechado; non-null; newtype inescapavel); criterio-de-fronteira por demonstracao; complemento via gates (P10/P11) para o runtime-only. P14 especializa P1 (proveniencia) com fidelidade-de-forma.

		(2) GERADOR-DO-cue.Value como pipeline canonico de domain-types. Os tipos de dominio sao gerados percorrendo o cue.Value (API CUE) ate o tipo da linguagem-alvo, preservando toda distincao compile-time-verificavel -- NAO passando por um intermediario que reduza expressividade de tipo.

		(3) REINTERPRETAR o escopo do item 2 de adr-140. O .proto DEIXA de ser IR-de-domain-types (esse papel passa ao cue.Value, item 2 acima). O .proto PERMANECE valido para os papeis que nao geram domain-types: compatibilidade (Ion-3, buf breaking nos .proto), exit-strategy (item 8 de adr-140), e serializacao wire onde aplicavel. Isto e REINTERPRETACAO de UM item, nao supersession: adr-140 permanece proposed e vigente nos demais itens; nenhuma decisao de adr-140 e revertida, so o escopo do .proto no caminho-de-tipos e estreitado.

		(4) DESIGN-RULES do gerador (derivadas da medicao do spike 4, normativas para a materializacao em mesh-runtime): (a) naming parent+field para tipos sintetizados de constraints/disjuncoes inline; (b) arms de uma uniao-de-structs sao absorvidos na uniao (nao emitidos standalone), e o literal discriminador vira o nome da variante; (c) emissao em ordem topologica de dependencia (topo-sort); (d) politica de presenca 3->2: as tres classes CUE (regular ':' , required '!', optional '?') colapsam em duas no alvo (non-null vs nullable/Option), com regular e required ambos non-null.

		(5) REPRESENTACAO de int. CUE int e unbounded; o codegen-contract declara o narrowing para o tipo concreto da linguagem-alvo (ex.: Long/i64) como decisao de representacao explicita, nao implicita.

		(6) RE-APONTAR FF-CG-03. O alvo de regeneracao-e-diff (a allowlist-por-regeneracao de adr-140) passa a ser os domain-types gerados do cue.Value; os derivados .proto/Ion/JSON seguem cobertos por FF-CG-03 para seus papeis (compat/wire/exit). Mesmo mecanismo (regenerar -> diff em generated/), alvo de tipos re-apontado -- nao e check novo. A re-apontagem e registrada em adr-140 (nota aditiva em consequences) e refletida no codegen-contract.cue (transform[0] + header).
		"""

	consequences: """
		Positivas: (P1c) Zero perda de forma compile-time-verificavel: cada invariante que a spec expressa e que o tipo pode forcar e recusado pelo compilador, nao em runtime -- a classe de estado-ilegal-que-so-falha-em-runtime e eliminada por construcao no que e expressavel. (P2c) Criterio objetivo de selecao de linguagem-alvo: P14 capacidades (i)(ii)(iii) tornam a escolha demonstravel, nao opiniao -- Kotlin e Rust passam (medido nos spikes); Go nao (vaza exaustividade + presenca, spike 1). (P3c) P1 puro preservado: o codigo segue 100% gerado; P14 so eleva a barra do que a geracao preserva. (P4c) O .proto fica reduzido aos papeis onde nao ha perda (compat/wire/exit), eliminando o gargalo de fidelidade no caminho-de-tipos.

		Negativas / limitacoes: (N1) A spec passa a depender de um gerador-do-cue.Value como peca do pipeline (estimado ~600 linhas, semanas -- medido no spike 4 para o nucleo estrutural). E divida governada: a geracao viva (e o gerador) vivem no mesh-runtime, ausente do escopo; ate la P14 e cumprido pela FF-CG-03 re-apontada (regeneracao-e-diff) + o check de compile-probes (def-056). (N2) O custo de extensao do gerador esta acoplado a forma-fechada do dominio: se um BC introduzir construcao CUE compile-time-verificavel fora do conjunto enumerado, o gerador exige extensao antes de gerar (falha-limpa, nao vaza) -- ver falsificationCondition. (N3) A cauda de construcoes que mais cresce o esforco (constraints/regex -> validadores; disjuncao-de-struct -> tagged-union com payload) foi medida como coberta no CMT, mas o fan-out cross-BC pode revelar construcoes novas; def-056 e a FF-CG-03 re-apontada cobrem o gap ate o gerador materializar.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	falsificationCondition: {
		condition: """
			Esta decisao estara errada se o conjunto de construcoes CUE compile-time-verificaveis do dominio se provar ABERTO (custo de extensao do gerador indefinido), OU se um BC introduzir construcao compile-time-verificavel fora do conjunto enumerado que o gerador nao cubra -- caso em que a forma vazaria para runtime ate a extensao, contradizendo P14.
			"""
		observableSignal: """
			O gerador-do-cue.Value falha-limpa (ou exige extensao nao-trivial) em construcao nova de algum BC no fan-out, OU a taxa de construcoes-novas-por-BC nao converge a zero ao longo do fan-out. Medido na adocao: 18 construcoes cobrem o CMT inteiro, com a cauda nao-exercida tendo zero instancias no disco.
			"""
	}

	affectedArtifacts: [
		"architecture/design-principles.cue",
		"architecture/adrs/adr-140-codegen-contracts.cue",
		"governance/build-time/codegen-contract.cue",
	]

	plannedOutputs: [
		"architecture/deferred-decisions/def-056-codegen-form-compile-probes.cue",
	]

	derivedArtifacts: [
		"architecture/shared-schemas/assertion-schema.cue",
		"governance/wave-plan.cue",
	]

	defersTo: ["def-056"]

	principlesApplied: ["P0", "P1", "P10", "P11", "P12"]

	supersedes: []

	rationale: """
		P14 especializa P1 e e o coracao da decisao: P1 garante que o codigo nasce da spec, mas nao que nasce FIEL a forma da spec. A alternativa (d) (aceitar a perda) e a unica que dispensaria P14 -- e foi rejeitada porque empurra para runtime estados que o compilador recusaria de graca, o que num sistema financeiro e estado-ilegal-em-producao evitavel. As alternativas (a)/(b)/(c) ou degradam a forma (JSON Schema, como proto3) ou ferem P0/P1 (segundo motor de schema; tipos a mao).

		P0 (localizacao canonica unica): CUE permanece SoT unica; o gerador-do-cue.Value e a derivacao P1-conformante; o .proto continua derivado committed (never-hand-edit) para compat/exit, sem virar segundo SoT de tipos. P1 (codigo gerado): preservado integralmente -- P14 nao reduz a geracao, eleva o que ela preserva. P10/P11: os invariantes runtime-only (relacao entre valores, hash, igualdade calculada) sao cobertos por gates deterministicos que recusam antes do efeito -- complemento de P14, nao excecao. P12 (governanca-e-codigo): FF-CG-03 re-apontada + def-056 (compile-probes) materializam P14 como fitness function determinista no CI, nao revisao estocastica.

		Reinterpretacao vs supersession (decisao item 3): adr-140 esta proposed e e reinterpretado em UM item (escopo do .proto no caminho-de-tipos), nao substituido -- os itens 1,3-10 de adr-140 (CUE SoT, Ion serializacao, compat 3-camadas, ContractGate, #Assertion, exit, slice HTTP) permanecem vigentes. Marcar adr-140 superseded derrubaria formalmente o ADR inteiro (a uniao discriminada de #ADR nao tem 'parcialmente-superseded'), pelo que a reinterpretacao via nota aditiva (precedente adr-134, emenda aditiva em consequences) e a forma fiel. adr-140 permanece proposed (sua migracao a accepted segue amarrada a evidencia do golden-example, per codegen-contract.cue).

		reversibility=medium / blastRadius=repo-wide coerente com adr-140/adr-145: repo-wide porque P14 e principio fundacional (governa o codegen de todo BC) e re-aponta FF-CG-03; medium porque adicionar P14 e reinterpretar um item de um ADR proposed e append nao-destrutivo (reverter = remover P14 + restaurar o escopo do item 2), mas a forma do gerador, uma vez materializada no mesh-runtime, fica mais cara de mudar. Nenhum vendor/runtime e escolhido aqui -- adr-146 e puramente spec-side (filtro adr-139); a linguagem-alvo concreta permanece deferida, P14 fixa so o CRITERIO (capacidades minimas) que ela deve satisfazer.
		"""
}
