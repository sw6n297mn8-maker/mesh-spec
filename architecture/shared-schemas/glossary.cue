package shared_schemas

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// glossary.cue (shared-schemas) — Glossário-kernel: lar canônico do termo
// compartilhado, criado pela Peça 2 (passo ii do D2 do adr-151). A Peça 1
// estendeu o #Glossary.canonicalPathRegex para admitir este path; este é o
// primeiro residente. Hospeda o termo-alvo PLAIN que os vo-money dos BCs
// apontarão como canônico (canonicalTermRef) no backfill (passo iii) — o elo é
// BC->kernel; o kernel não aponta de volta (domainModelRefs vazio).
//
// boundedContextRef: "shared" é SENTINELA — glossário-kernel compartilhado, sem
// BC dono (per adr-151 Forma B). Nenhum structural-check valida
// glossary.boundedContextRef (os checks de boundedContextRef cobrem PortManifest/
// agent-spec/service-contract, não glossário); tq-gl-07 (advisory, não
// processado pelo runner) sinalizará "shared" sem canvas — finding ESPERADO, não
// erro. "shared" não colide com nenhum código de BC.
//
// PADRÃO EMERGENTE (anotação, não dívida a tratar aqui): o #Glossary foi
// desenhado para glossário-de-BC; o kernel usa 3 acomodações — bcRef sentinela,
// tq-gl-07 advisory-esperado-falso, âncora semântica via examples/antiTerms (não
// domainModelRefs, que aqui é um-para-muitos invertido por natureza: o termo é
// apontado por muitos vo-money, não aponta nenhum). Funciona via sentinela +
// advisory. Se MAIS glossários-kernel surgirem (outros primitivos transversais),
// o #Glossary pode merecer reconhecer formalmente "glossário compartilhado"
// (bcRef opcional p/ shared-schemas, tq-gl-07 isento p/ kernel) — padrão a
// formalizar então, não na Peça 2.
glossary: artifact_schemas.#Glossary & {
	code: "shared"
	name: "Glossário-kernel compartilhado — primitivos transversais"

	boundedContextRef: "shared"

	terms: [{
		code:       "term-money"
		name:       "Dinheiro"
		termEn:     "Money"
		definition: "Valor monetário expresso como quantia decimal exata e moeda (ISO 4217), primitivo financeiro transversal a todos os BCs da Mesh. É o conceito de negócio canônico de dinheiro — a definição ubíqua única que os value objects de money de cada BC referenciam como canônica, em vez de redefini-la localmente."
		category:   "value"
		rationale:  "Money é primitivo de primeira classe COMPARTILHADO: aparece em múltiplos BCs (inv/p2p/bdg/bkr e além) sempre com a mesma semântica quantia+moeda. Por P0 vive em UM lar canônico (este termo-kernel) e os BCs apontam por canonicalTermRef — ponteiro, não cópia. É a âncora linguística do #Money (architecture/shared-schemas/money.cue) da camada de schema; o elo termo<->schema é declarado pelos vo-money dos BCs (canonicalSchemaRef + canonicalTermRef) no backfill, per adr-151 Forma B."
		synonyms: ["Valor Monetário"]
		antiTerms: [{
			term:          "Preço"
			clarification: "Preço é um valor monetário atribuído a um item/serviço num contexto de negociação; Money é o primitivo quantia+moeda que o preço usa. Money não carrega semântica de precificação."
		}, {
			term:          "Saldo"
			clarification: "Saldo é a posição líquida de uma conta num instante (resultado de débitos/créditos); Money é a unidade de valor que o compõe, não a posição."
		}]
		examples: [{
			context:  "Compromisso econômico no CMT"
			instance: "amount 150000.00, currency BRL — a quantia comprometida num compromisso, expressa como Money."
		}]
	}]

	rationale: "Glossário-kernel: lar canônico único (P0) dos termos de primitivos compartilhados transversais aos BCs. Primeiro residente: term-money, ancorando o conceito ubíquo de dinheiro que adr-151 Forma B exige como alvo de canonicalTermRef."
}
