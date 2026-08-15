// manual takeover (adr-194 / missão M7.5): tipo production-guide está em
// rollout subagent-drafted (adr-054), mas o ambiente do builder da missão
// não dispõe de ferramenta de dispatch de subagente — fallback manual per
// authoring-policy fallbackPolicy + CLAUDE.md ("subagent dispatch failed:
// no dispatch tool available in builder session; manual takeover"),
// registrado em governance/build-time/subagent-execution-log.cue.

package production_guides

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// design-system-constitution.cue — Production guide para a Constituição
// do Design System (schema #DesignSystemConstitution, adr-194).
//
// GUIDE DELIBERADAMENTE MÍNIMO: a Constituição já está promulgada e
// congelada (camadas I-VI); a autoria típica sob este guide NÃO é criar
// outra Constituição (singleton lógico) — é EMENDA de camada, extensão
// (camada futura nascendo: dataviz, palco), edição do token-contract,
// caso canônico candidato ou pendência. O shape (cue vet) já garante:
// enums fechados (verbos canônicos, derivesFrom, changeRegime,
// classification), vocabulário fechado de campos de camada, ids. Este
// guide guarda só o que o shape NÃO alcança: cadeia de derivação,
// trade-off nomeado, a fronteira emenda/calibração e lei/promulgação,
// e a disciplina de jurisprudência e pendências.
//
// Convenção: tq-dcg-NN para critérios deste guide (legend em
// architecture/artifact-schemas/quality-criteria.cue).

designSystemConstitutionGuide: artifact_schemas.#ProductionGuide & {

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/design-system-constitution\\.cue$"
			fileNameRegex:      "^design-system-constitution\\.cue$"
			description:        "Production guide para autoria de emendas, extensões, tokens, casos canônicos e pendências da Constituição do Design System."
			rationale:          "Cascade ordering (adr-053 + adr-054 dec 13) exige PG antes de instância — este guide nasce na mesma fatia da canonização (adr-194) para que qualquer edição futura da Constituição já seja autorada sob guide."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-dcg-01"
			description: "Guide força cadeia de derivação e trade-off nomeado em toda mudança normativa"
			test:        "Process da section amendment-and-derivation exige apontar o elo superior mudado (invariante de arquitetura, personalidade ou lei transversal — cláusula IX) ANTES de tocar camada congelada, e nomear o trade-off que a mudança paga (teste operacional III (a)/(c)); gapPolicy declara STOP quando não há elo superior — preferência não legisla. Hardening de processo sobre tq-dsc-01/02 do schema (já fail)."
			severity:    "fail"
			rationale:   "A propriedade que a Constituição protege é gerar regras em vez de acumulá-las — emenda sem elo superior é exatamente a degradação que a cláusula IX nomeia como perda de coerência."
		}, {
			id:          "tq-dcg-02"
			description: "Guide força as duas fronteiras: emenda vs calibração e lei vs promulgação"
			test:        "Process da section token-and-promulgation exige classificar a mudança de token pelo CRITÉRIO DE VÍNCULO da seção VII — causal, não textual (constitution-bound só onde não resta valor livre a calibrar → emenda via ADR; calibratable dentro da moldura → manutenção que vive como COMMIT no mesh-frontend-runtime, NÃO como edição deste artefato) e verificar que valores vivos não são legislados no runtime nem re-promulgados aqui sem decisão (adr-194 dec 2/5); gapPolicy proíbe reclassificar regime por conveniência."
			severity:    "fail"
			rationale:   "O regime em dois trilhos é o que tira o founder do caminho de calibrações e o preserva como única autoridade de emenda — classificar errado num sentido re-serializa o founder, no outro fura a lei."
		}, {
			id:          "tq-dcg-03"
			description: "Guide força a disciplina de jurisprudência e a classificação de pendências"
			test:        "Process da section jurisprudence-and-pendencias declara que caso canônico novo entra como CANDIDATO e só é materializado após decisão explícita do founder; toda pendência nova declara classification do enum com o porquê derivado do texto (tq-dsc-04); gapPolicy proíbe caso/pendência sem decisão ou sem classificação."
			severity:    "fail"
			rationale:   "Jurisprudência é decisão do founder aplicada — caso inventado por agente viraria lei sem legislador; pendência sem classificação vira dumping ground (anti-catch-all adr-062)."
		}]
		rationale: "3 critérios espelham o que o shape não alcança e nada mais (guide mínimo por decisão da missão M7.5): o método (tq-dcg-01), as duas fronteiras de mudança (tq-dcg-02) e a disciplina de jurisprudência/pendências (tq-dcg-03). Todos fail: cada um guarda uma invariante cuja violação é drift constitucional, não estilo."
	}

	prerequisites: {
		description: "Antes de editar qualquer arquivo de architecture/design-system/, agente lê a Constituição INTEIRA (constitution.cue + canonical-cases.cue + token-contract.cue — uma instância composta), a cláusula IX, o adr-194 e o schema; e confirma com o founder qual classe de mudança está autorizada (emenda de camada, extensão, token, caso canônico, pendência)."
		collectFromFounder: [
			"Para emenda de camada congelada: qual elo superior mudou (invariante de arquitetura, personalidade ou lei transversal) — sem elo declarado pelo founder não há emenda, há preferência",
			"Para caso canônico novo: a decisão explícita do founder promovendo o candidato a jurisprudência (o texto do caso é do founder, nunca inventado)",
			"Para token novo ou mudança de token constitution-bound: o ADR de emenda que o autoriza (nenhum valor entra sem referência à decisão que o autoriza — VII)",
			"Para pendência nova: a classificação pretendida (empirical-calibration | deferred-decision | reserve-condition | out-of-scope-governance) e o trigger/condição que a governa",
		]
		gapPolicy:     "NÃO invente conteúdo constitucional — o texto normativo é do founder; PRESERVAÇÃO É LEI: nenhuma lei, trade-off, caso limite, personalidade, jurisprudência, pendência, cláusula de reabertura, significado de token ou distinção preparado/verificado/decidido/registrado é removida, resumida ou 'melhorada' em edição. NÃO emende camada sem elo superior mudado apontado pelo founder — STOP (cláusula IX: preferência não legisla). NÃO introduza preferência sem princípio superior — decisão nova cita de que deriva e nomeia o trade-off que paga (III). NÃO reclassifique changeRegime nem classification por conveniência — o regime deriva do critério de vínculo da seção VII (causal: resta valor livre dentro da moldura?), não do lugar onde o valor foi escrito; dúvida persistente vira pergunta direta ao founder. NÃO materialize caso canônico sem decisão do founder. NÃO calibre valor calibratable editando este artefato — calibração é commit no mesh-frontend-runtime dentro da moldura (lei aqui, promulgação lá). NÃO infira critério normativo novo a partir de lens ou referência externa — lenses são advisory e, onde conflitam, a Constituição prevalece (adr-194 dec 8)."
		validatorNote: "cue vet valida por shape: enums fechados (verbos canônicos, derivesFrom, changeRegime, classification, axis/statute), vocabulário fechado de campos de camada, ids e pisos de runas. sc-dsc-01/02 (determinísticos, born-warn) travam deleção parcial da instância composta. O que resta ao review (self-review + founder): cadeia de derivação, trade-offs, fidelidade do texto preservado, coerência das classificações — dimensões de julgamento, nunca gate (P10/adr-040/ten-006)."
		outputNote:    "Output é edição in-place dos arquivos da instância composta em architecture/design-system/ (constitution.cue / canonical-cases.cue / token-contract.cue), acompanhada de ADR quando a classe de mudança exigir (emenda de camada; token bound; extensão de camada nova). Version bump da Constituição acompanha emenda; calibração de token não toca o spec."
	}

	workOrder: [
		"amendment-and-derivation",
		"token-and-promulgation",
		"jurisprudence-and-pendencias",
	]

	sections: {
		"amendment-and-derivation": {
			target:    "#DesignSystemConstitution"
			objective: "Classificar a mudança pretendida (emenda de camada congelada, extensão de camada futura, edição de campo transversal) e estabelecer sua legitimidade pelo método: elo superior mudado, cadeia de derivação citada, trade-off nomeado."
			process: [{
				action: "Ler a Constituição composta inteira e a cláusula IX"
				detail: "constitution.cue + canonical-cases.cue + token-contract.cue são UMA instância; emenda em camada reverbera em tokens e casos. A cláusula IX é o teste de admissão de qualquer mudança."
			}, {
				action: "Identificar o elo superior mudado que autoriza a emenda"
				detail: "Invariante de arquitetura (II), personalidade (IV) ou lei transversal (V) — apontado pelo founder (prerequisites). Sem elo mudado: STOP — não há reabertura; há preferência, e preferência não legisla."
			}, {
				action: "Declarar a cadeia de derivação e o trade-off da mudança"
				detail: "A decisão nova cita o princípio de que deriva, mudá-la exigiria mudar algo acima dela, e o trade-off que paga é nomeado (teste operacional III a/b/c). Preservar TODO o texto não afetado byte a byte."
			}, {
				action: "Verificar preservação das distinções e verbos canônicos"
				detail: "decidido/verificado/preparado/registrado permanecem os únicos verbos de procedência em posição normativa (tq-dsc-03); nenhuma seção, trade-off ou caso limite some na edição."
			}]
			sources: [
				"architecture/design-system/constitution.cue (a lei vigente e a cláusula IX)",
				"architecture/adrs/adr-194-establish-design-system-constitution.cue (regime de mudança, dec 5; fronteira, dec 2)",
				"architecture/artifact-schemas/design-system-constitution.cue (vocabulário fechado de campos e enums)",
			]
			heuristics: [
				"Camada futura nascendo (dataviz, palco — pend-02/03) é EXTENSÃO sob o mesmo método: problema · decisão-raiz · trade-offs · teste dos cinco, com ADR próprio.",
				"Lens de design que recomenda diferente NÃO é elo superior — é material advisory; o caminho de volta dela é proposta de emenda via cláusula IX (adr-194 dec 8).",
			]
			doneCriteria: "Classe de mudança declarada; elo superior citado (ou STOP registrado); cadeia de derivação e trade-off nomeados no texto proposto; nenhum conteúdo pré-existente removido ou parafraseado; ADR de emenda pareado quando exigido."
			ifGap:        "Se o elo superior não é identificável, a mudança não é emenda — devolver ao founder como pergunta, nunca forçar derivação retórica."
		}

		"token-and-promulgation": {
			target:    "#TokenContract"
			objective: "Editar o contrato de tokens sob as duas fronteiras: emenda vs calibração (regime por token, derivado do critério de vínculo da seção VII) e lei vs promulgação (spec legisla; mesh-frontend-runtime materializa os valores vivos)."
			process: [{
				action: "Avaliar o regime da mudança de token pelo critério de vínculo da seção VII"
				detail: "O critério é CAUSAL, não textual (VII, emenda 1.1 — adr-195). Não resta valor livre a calibrar — o token é relação, caráter ou proibição cuja alteração já muda significado, identidade, distinção semântica ou personalidade (ex.: pressionado = tinta plena, links = tinta sublinhada, raio 0 na geometria estrutural, ease-out sem bounce) → constitution-bound → exige emenda via ADR. A camada fixa moldura e resta valor dentro dela (ex.: off-white por teste ao sol, hex semânticos sobre piso AA/AAA, espessura de foco acima do piso, base do grid dentro do ritmo sistemático) → calibratable → manutenção, com a MOLDURA declarada em constraints. O valor aparecer literalmente na camada promulgada NÃO o torna bound: pergunte qual lei superior deixaria de valer se ele mudasse."
			}, {
				action: "Verificar o destino da mudança: spec ou runtime"
				detail: "Calibração de token calibratable NÃO edita este artefato — é commit no mesh-frontend-runtime dentro da moldura. Este guide só cobre: token novo, mudança de moldura, mudança de regime, emenda de token bound — todas com ADR."
			}, {
				action: "Declarar derivesFrom e constraints com o texto que decide o regime"
				detail: "derivesFrom aponta a camada/seção (enum fechado — cue vet); constraints cita o trecho da camada que fixa o valor (bound) ou desenha a moldura (calibratable) — regime não derivável do texto falha tq-dsc-05."
			}]
			sources: [
				"architecture/design-system/token-contract.cue (o contrato vigente e a promulgationNote)",
				"architecture/design-system/constitution.cue (tokenRegime — a seção VII — e as camadas que fixam molduras)",
			]
			heuristics: [
				"Na dúvida entre os dois regimes, decida pela CAUSA e não pelo lugar onde o valor foi escrito: se existe valor livre dentro da moldura, é calibratable e a moldura vai para constraints; documente o teste em constraints e, na dúvida persistente, pergunte ao founder.",
				"Vendor que exigir mudar token bound para ser adotável não gera emenda — gera o sinal (a) da falsificationCondition do adr-194 (escalar, não acomodar).",
			]
			doneCriteria: "Todo token tocado com regime classificado pelo critério de vínculo (VII) e a moldura correspondente citada em constraints; derivesFrom resolvendo por enum; mudanças bound pareadas com ADR; nenhuma calibração de valor vivo executada no spec."
			ifGap:        "Se a moldura da camada não decide o regime do token, a lacuna é da CAMADA — propor emenda de camada primeiro (section anterior), nunca inventar moldura no contrato."
		}

		"jurisprudence-and-pendencias": {
			target:    "#CanonicalCase"
			objective: "Manter a jurisprudência e o registro de pendências sob disciplina: caso novo é candidato até decisão do founder; pendência sempre classificada com o porquê derivado do texto."
			process: [{
				action: "Verificar a decisão do founder para caso canônico novo"
				detail: "Casos novos são CANDIDATOS — nunca entram sem decisão explícita do founder (adr-194); o texto do caso é do founder. Casos existentes são verbatim intocável."
			}, {
				action: "Declarar a classificação de pendência nova com o porquê"
				detail: "classification do enum (empirical-calibration | deferred-decision | reserve-condition | out-of-scope-governance) com a justificativa derivada do texto no content; out-of-scope-governance carrega pointer; deferred-decision governada fora do artefato aponta def-XXX existente, e a governada no artefato documenta trigger textual e o porquê de não virar def (adr-194 dec 10)."
			}, {
				action: "Verificar o ciclo de vida das pendências existentes"
				detail: "Pendência resolvida (ex.: teste ao sol executado; reserva convocada) sai por edição com registro da resolução — a saída referencia o commit/ADR que a resolveu, preservando o histórico no rationale da mudança."
			}]
			sources: [
				"architecture/design-system/canonical-cases.cue (jurisprudência vigente)",
				"architecture/design-system/constitution.cue (pendencias e as camadas que as classificam)",
			]
			heuristics: [
				"Pendência que ganhar trade-off articulado E trigger codificável FORA do artefato migra para def-XXX formal (adr-062) — reclassificação é decisão, não default.",
			]
			doneCriteria: "Nenhum caso novo sem decisão do founder registrada; toda pendência com classification válida e porquê textual; casos existentes byte a byte intactos."
			ifGap:        "Se a classificação de uma pendência não é derivável do texto, apresentar as opções ao founder como pergunta (FM da classificação), nunca classificar por conveniência."
		}
	}

	finalValidation: {
		reconciliation: {
			description: "Invariantes cross-field da instância composta, conferidos antes da submissão."
			pairs: [
				"Cada token do token-contract ↔ camada/seção apontada por derivesFrom existente e cujo texto sustenta o changeRegime declarado (tq-dsc-05).",
				"Cada emenda de camada ↔ ADR correspondente apontando o elo superior mudado (cláusula IX + adr-194 dec 5).",
				"Cada pendência ↔ classification válida com porquê textual; cada deferred-decision externa ↔ def-XXX existente no disco.",
				"Instância composta completa: cue export ./architecture/design-system/ -e designSystemConstitution resolve concreto (os 3 arquivos presentes — sc-dsc-01/02).",
			]
		}
		steps: [
			"Verificar shape: cue vet ./architecture/design-system/ verde (enums fechados de verbos, derivesFrom, changeRegime, classification; vocabulário fechado de campos de camada).",
			"Verificar tq-pg-01: workOrder é permutação exata das chaves de sections (3 sections).",
			"Verificar tq-dcg-01 / tq-dsc-01 / tq-dsc-02: elo superior citado em toda emenda; cadeia de derivação e trade-off nomeados; nenhum trade-off pré-existente removido.",
			"Verificar tq-dcg-02 / tq-dsc-05: regime de cada token tocado derivado do critério de vínculo (VII) com a moldura citada em constraints; nenhuma calibração de valor vivo executada no spec.",
			"Verificar tq-dcg-03 / tq-dsc-03 / tq-dsc-04: casos canônicos intactos ou com decisão do founder; verbos canônicos preservados; pendências classificadas com porquê.",
			"Verificar reconciliation: os 4 pairs cross-field conferidos sobre a instância composta exportada.",
			"Submeter ao founder para aprovação explícita antes de commit — step próprio bloqueante (adr-057 founderConfirmation; dentro de missão adr-193, a autorização explícita da missão cumpre este gate e o receipt final presta contas).",
		]
	}
}
