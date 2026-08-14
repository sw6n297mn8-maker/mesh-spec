package artifact_schemas

import "strings"

// design-system-constitution.cue — Schema para a Constituição do Design
// System Mesh (adr-194).
//
// A Constituição é a LEI DA EXPRESSÃO da Mesh: identidade, camadas de
// expressão (cor, tipografia, movimento, forma, linguagem, procedência),
// contrato de tokens e regime de mudança. Distinta de:
// - architecture/design-principles.cue: princípios do SISTEMA (P0-P14).
//   A seção II da Constituição (architectureInvariants) DERIVA dos
//   invariantes do sistema (P3 imutabilidade, P10 gates, P11 evidência)
//   sem duplicá-los — relação declarada em adr-194, artefatos separados.
// - adr-150: a lei de COMPORTAMENTO do frontend AI-first (3 patterns,
//   FF-FE-01..08). A Constituição preenche o escopo declarado-ausente
//   do N1 do adr-150 (design system visual: tokens, tipografia, marca).
// - frontend-codegen-contract: a GERAÇÃO de superfícies por família.
//   A expressão é transversal a famílias; não vive naquele contrato.
//
// Instância: UMA Constituição, COMPOSTA por múltiplos arquivos do
// package design_system em architecture/design-system/ (merge de structs
// CUE): constitution.cue (preâmbulo, seções I-V, camadas VI, regime de
// tokens VII, cláusula de proteção IX, pendências) + canonical-cases.cue
// (jurisprudência VIII) + token-contract.cue (contrato de tokens).
// Os três arquivos compõem UM valor designSystemConstitution.
// cardinality declarada "collection" pela FORMA FÍSICA multi-arquivo:
// o tooling V1 de singleton (structure-index, sc-sg-01) assume
// canonicalPathRegex literal e acusaria falso-ausente permanente para
// regex de diretório. A unicidade lógica (uma Constituição) é invariante
// documentado aqui e guardado por sc-dsc-01/02 (co-presença dos arquivos
// que a compõem) — ver adr-194.
//
// PRESERVAÇÃO É LEI (adr-194): o conteúdo normativo vive em blocos de
// prosa multiline preservando o texto promulgado pelo founder; estrutura
// tipada existe apenas onde há uso mecânico (ids, derivesFrom,
// changeRegime, classification, verbos canônicos). Julgamento estético
// NUNCA é gate (P10/adr-040/ten-006); só o machine-decidable (valores
// bound, shape, refs) é verificado deterministicamente.

#DesignSystemConstitution: {
	// Identidade do documento. id fixo: singleton lógico.
	id:      "design-system-constitution"
	version: string & =~"^[0-9]+\\.[0-9]+$"

	// Estado de congelamento declarado pelo documento (ex.:
	// "layers-i-vi-frozen" — camadas I-VI congeladas, pendências abertas).
	status: string & !=""

	// Preâmbulo — as três leis geradoras. O documento não acumula regras;
	// gera regras. Essa propriedade é o que ele protege.
	preamble: string & strings.MinRunes(100)

	// I. Tese + corolário de design.
	thesis: string & strings.MinRunes(50)

	// II. Arquitetura — invariantes fora do alcance do design.
	architectureInvariants: [string & !="", ...string & !=""]

	// Fecho da seção II: só ontologia neste nível; teste de reabertura
	// de tudo (propor mudança exige apontar qual invariante mudou).
	architectureInvariantsNote: string & !=""

	// III. Padrão de Excelência — o Princípio da Inevitabilidade.
	excellenceStandard: {
		principle:       string & !=""
		operationalTest: string & !=""
		craftClause:     string & !=""
	}

	// IV. Personalidade — derivada da arquitetura, não inventada.
	personality: {
		traits: [#PersonalityTrait, ...#PersonalityTrait]
		// Estatutos dos traços (escolhidos vs prometida) + efeitos
		// esperados + sustentação.
		statutes: string & !=""
		// Fluxo causal Arquitetura → Personalidade → Percepção →
		// Reputação e sua regra de reabertura.
		causalFlow: string & !=""
	}

	// V. Leis Transversais.
	transversalLaws: {
		// V.1 Lei da Atenção.
		attention: string & !=""
		// V.2 Regime de Procedência.
		provenance: {
			// Enunciado do regime: toda informação tem origem; a
			// interface comunica procedência, não inteligência.
			statement: string & !=""
			// Quatro naturezas de informação, quatro verbos canônicos.
			natures: [#InformationNature, ...#InformationNature]
			absolutePrinciple: string & !=""
			fourQuestionsTest: string & !=""
		}
	}

	// VI. Camadas. Introdução declara a estrutura uniforme de cada
	// camada e remete os tokens à seção VII.
	layersIntro: string & !=""
	layers: {
		color:      #Layer
		typography: #Layer
		motion:     #Layer
		form:       #Layer
		language:   #Layer
		provenance: #Layer
	}

	// VII. Regime de tokens: manutenção (calibrar dentro da moldura)
	// vs emenda (alterar contra uma camada, via ADR).
	tokenRegime: string & !=""

	// Contrato de tokens (P0: spec é a lei; runtime carrega os valores
	// vivos — separação declarada em adr-194).
	tokenContract: #TokenContract

	// VIII. Casos canônicos (jurisprudência). Casos novos são
	// candidatos; nunca entram sem decisão do founder.
	canonicalCases: [#CanonicalCase, ...#CanonicalCase]

	// IX. Cláusula de Proteção do Método.
	protectionClause: {
		method:              string & !=""
		reopeningComplement: string & !=""
		warning:             string & !=""
	}

	// Registro de Pendências — classificadas, nunca genéricas.
	pendencias: [#Pendencia, ...#Pendencia]

	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/design-system/[a-z0-9-]+\\.cue$"
			fileNameRegex:      "^[a-z0-9-]+\\.cue$"
			description:        "Constituição do Design System Mesh: a lei da expressão (identidade, camadas, contrato de tokens, regime de mudança), instância única composta por merge de structs através dos arquivos do diretório."
			rationale:          "Diretório próprio em architecture/ porque a lei da expressão é cross-cutting (governa toda superfície futura), não pertence a um BC. Multi-arquivo para separar lei (constitution), jurisprudência (canonical-cases) e contrato de tokens (token-contract) sem fragmentar a instância lógica — merge de structs CUE compõe UM valor. cardinality 'collection' registra a forma física; a unicidade lógica é invariante documentado (tooling V1 de singleton exige path literal)."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-dsc-01"
			description: "Cadeia de derivação presente nas decisões-raiz e leis de camada"
			test:        "Cada camada que declara rootDecision ou law ancora a decisão numa fonte superior nomeável do próprio documento (invariante de arquitetura, personalidade ou lei transversal) — o teste operacional do Padrão de Excelência (a): a decisão cita o princípio de que deriva. Decisão de camada cujo texto não permite apontar o elo superior falha. Verificação por leitura da camada contra as seções I-V."
			severity:    "fail"
			rationale:   "O documento gera regras em vez de acumulá-las — a propriedade que a cláusula de proteção (IX) protege. Camada sem cadeia de derivação é preferência, e preferência não legisla."
		}, {
			id:          "tq-dsc-02"
			description: "Trade-offs preservados e nomeados onde a Constituição os declara"
			test:        "Toda camada que a Constituição promulgou com seção de trade-offs preserva-a integralmente (cor, tipografia, forma); nenhuma edição remove ou dilui trade-off nomeado; decisão NOVA em camada só entra com o trade-off que paga nomeado (teste operacional (c) do Padrão de Excelência). Ausência de trade-off em camada que nunca o teve (movimento, linguagem, procedência) NÃO é finding — preservação, não uniformização."
			severity:    "fail"
			rationale:   "O trade-off nomeado é um dos três critérios de não-arbitrariedade (III). Removê-lo ou omiti-lo em decisão nova quebra o método que distingue maestria de preferência."
		}, {
			id:          "tq-dsc-03"
			description: "Verbos de procedência canônicos preservados"
			test:        "Os quatro verbos canônicos (decidido, verificado, preparado, registrado) aparecem em transversalLaws.provenance.natures exatamente como enum fechado (shape via cue vet) e são usados consistentemente na prosa das camadas linguagem e procedência — nenhum sinônimo (aprovado, validado, gerado, capturado) substitui verbo canônico em posição normativa. Verificação por leitura das camadas V.2, VI.5 e VI.6."
			severity:    "fail"
			rationale:   "A distinção preparado/verificado/decidido/registrado é epistemológica, nunca emocional (VI.6 regra 4) — ela ESTENDE a distinção agente-prepara/humano-confirma do adr-150. Trocar o verbo é trocar a epistemologia."
		}, {
			id:          "tq-dsc-04"
			description: "Classificação de pendência válida e coerente com seu regime"
			test:        "Cada pendência declara classification do enum fechado; 'out-of-scope-governance' carrega pointer para a alçada externa; 'deferred-decision' governada FORA do artefato aponta def-XXX existente em pointer, e a governada NO artefato (camada futura da própria Constituição, per adr-194 dec 10) documenta em content o trigger textual e o porquê de não virar def; 'empirical-calibration' declara que o resultado ajusta valor, não norma; 'reserve-condition' declara a condição de convocação."
			severity:    "fail"
			rationale:   "Pendência sem classificação vira dumping ground — o anti-catch-all do adr-062 aplicado à Constituição. A classificação decide quem cobra a pendência e por qual mecanismo."
		}, {
			id:          "tq-dsc-05"
			description: "Token com regime derivado do texto da Constituição"
			test:        "Cada token declara derivesFrom (enum fechado — shape via cue vet) apontando a camada/seção de onde deriva, e o changeRegime é justificado pelo texto citado em constraints: constitution-bound carrega o valor/range exato fixado pela camada; calibratable declara a moldura dentro da qual o valor vigente pode ser recalibrado sem reabrir a norma (ex.: 'valor exato ajustável por teste ao sol'). Token cujo constraints não permite decidir o regime pelo texto falha."
			severity:    "warn"
			rationale:   "O regime por token é o que torna a distinção manutenção-vs-emenda (VII) operável: commit no runtime dentro da moldura vs emenda via ADR. Regime não derivável do texto reabre a arbitrariedade que o documento existe para eliminar."
		}]
		rationale: "5 critérios protegem o que faz a Constituição ser lei e não catálogo: a cadeia de derivação (tq-dsc-01) e os trade-offs (tq-dsc-02) guardam o método (III + IX); os verbos canônicos (tq-dsc-03) guardam a epistemologia da procedência (V.2); a classificação de pendências (tq-dsc-04) e o regime por token (tq-dsc-05) guardam os dois mecanismos de mudança (pendência governada; manutenção vs emenda). Julgamento estético fica fora por construção (P10/adr-040/ten-006)."
	}
}

// Traço de personalidade — linha da tabela da seção IV.
// statute: os quatro primeiros traços são ESCOLHIDOS (derivam um-a-um
// de invariantes); serena é PROMETIDA (emergente na origem, vinculante
// na prática).
#PersonalityTrait: {
	axis:    "Como fala" | "Como opera" | "Como é percebida"
	trait:   string & !=""
	antonym: string & !=""
	statute: "escolhido" | "prometido"
}

// Natureza de informação — linha da tabela da seção V.2.
// verb é enum fechado: os quatro verbos canônicos são invariante do
// regime de procedência (P14: o que é expressável em tipo é forçado
// em compile-time).
#InformationNature: {
	nature:   string & !=""
	verb:     "decidido" | "verificado" | "preparado" | "registrado"
	produces: string & !=""
}

// Camada de expressão (VI.1-VI.6). TODOS os campos opcionais: as seis
// camadas têm formas deliberadamente distintas (cor tem problema/
// decisão-raiz/princípios derivados; movimento tem lei/teste de
// admissão/jurisprudência; procedência tem mapeamento/regras de
// assinatura) — o schema acomoda sem forçar uniformidade falsa.
// Struct fechado: campo fora do vocabulário é rejeitado por cue vet.
#Layer: {
	problem?:             string & !=""
	rootDecision?:        string & !=""
	derivedPrinciples?:   string & !=""
	surfaceNorm?:         string & !=""
	voices?:              string & !=""
	family?:              string & !=""
	derivedDecisions?:    string & !=""
	tradeoffs?:           string & !=""
	testOfFive?:          string & !=""
	edgeCases?:           string & !=""
	law?:                 string & !=""
	admissionTest?:       string & !=""
	jurisprudence?:       string & !=""
	twoWorlds?:           string & !=""
	rewardAnnex?:         string & !=""
	compositionUnit?:     string & !=""
	icons?:               string & !=""
	rules?:               string & !=""
	naturesMapping?:      string & !=""
	agentSignatureRules?: string & !=""
}

// Contrato de tokens (P0: spec=lei, runtime=valores).
// promulgationNote registra que os valores aqui são o REGISTRO DA
// PROMULGAÇÃO v1.0 (seção VII); a fonte VIVA dos valores é o
// mesh-frontend-runtime, sob este contrato.
#TokenContract: {
	promulgationNote: string & strings.MinRunes(50)
	tokens: [#Token, ...#Token]
}

// Token — decisão de menor ordem do sistema.
// changeRegime: calibratable = ajustar DENTRO da moldura é manutenção
// (commit no runtime); constitution-bound = alterar exige emenda à
// camada, via ADR (regime da seção VII).
#Token: {
	id:           string & =~"^[a-z][a-z0-9-]*$"
	role:         string & !=""
	derivesFrom:  #DerivationSource
	constraints:  string & !=""
	changeRegime: "calibratable" | "constitution-bound"
}

// Fonte de derivação de um token: seção existente da própria
// Constituição. Enum fechado — integridade de derivesFrom garantida
// por cue vet (P14), sem necessidade de check cross-file.
#DerivationSource: "layers.color" | "layers.typography" | "layers.motion" | "layers.form" | "layers.language" | "layers.provenance" | "transversalLaws.attention" | "transversalLaws.provenance" | "tokenRegime"

// Caso canônico — jurisprudência da seção VIII. Conteúdo verbatim do
// caso promulgado. Casos novos são CANDIDATOS: nunca entram sem
// decisão do founder (disciplina de jurisprudência, adr-194).
#CanonicalCase: {
	id:      string & =~"^case-[a-z0-9-]+$"
	name:    string & !=""
	content: string & !=""
}

// Pendência registrada — classificada, nunca genérica (tq-dsc-04).
//   empirical-calibration:   obrigação de validação empírica; o
//                            resultado ajusta VALOR, não norma.
//   deferred-decision:       decisão futura com trigger real —
//                            governada por def-XXX (pointer) OU no
//                            próprio artefato quando é camada futura
//                            da própria Constituição (adr-194 dec 10).
//   reserve-condition:       condição de reserva (assume SE convocada),
//                            não decisão pendente.
//   out-of-scope-governance: pertence a outra alçada (não é design);
//                            pointer nomeia a alçada.
#Pendencia: {
	id:             string & =~"^pend-[0-9]{2}$"
	title:          string & !=""
	content:        string & !=""
	classification: "empirical-calibration" | "deferred-decision" | "reserve-condition" | "out-of-scope-governance"
	pointer?:       string & !=""
}
