package artifact_schemas

// stakeholder-map.cue — Schema para Stakeholder Map.
//
// O stakeholder map é o catálogo canônico dos stakeholders
// do ecossistema Mesh. Define quem são, o que buscam,
// quais dores a Mesh endereça e qual é seu perfil de incentivos.
//
// Evolução do schema anterior (v0 → v1):
// Este schema substitui a versão inicial que continha
// #StakeholderType (person|organization|system|agent|regulator),
// meshInteraction, influence, concerns e interactsWith.
// Mudanças e justificativas:
// - id → code: alinhamento com padrão do package (canvas, glossary, domain-model)
// - #StakeholderType → #StakeholderCategory: taxonomia anterior classificava por
//   natureza jurídica (person vs organization); nova classifica por papel econômico
//   no ecossistema — mais útil para análise de incentivos e manipulação
// - meshInteraction removido: detalhes de interação por BC vivem no canvas
// - influence removido: influência é consequência de category + platformRelationships,
//   não dado independente
// - concerns → interests + painPoints: separação entre o que busca (interesse)
//   e o que sofre (dor), com rastreabilidade a custos canônicos
// - interactsWith removido: relações inter-stakeholder são capturadas
//   implicitamente via canvas (ambos como stakeholders do mesmo BC) e via
//   manipulationVectors.attackSurface — campo de IDs sem semântica da relação
//   era frágil e não-validável
// - tq-sm-01 (meshInteraction concreta) e tq-sm-02 (concerns rastreáveis)
//   substituídos por 7 critérios mais granulares que cobrem integridade
//   referencial, cobertura por canvas, e alinhamento com dp-08
//
// Estratégia desta versão:
// - stakeholders são archetypes de segmento, não entidades individuais
// - pain points são obrigatórios por tipo e referenciam custos canônicos (ce-*)
// - platformRelationships é lista com unicidade enforced por runner
// - manipulation vectors obrigatórios para participantes econômicos ativos
// - sub-structs interpretativas têm rationale
// - refs numéricos (sh-NN, ce-NN) — padrão canônico do repositório,
//   alinhado com canvas (^sh-[0-9]{2}$) e domain-definition (ce-01..ce-07)
// - quality criteria cobrem integridade referencial e cobertura por canvas
//
// Lenses consultadas:
// - lens-market-design (primária): composição de pool, participantes, incentivos
// - lens-behavioral-economics (secundária): incentivos, vieses, manipulação
// - lens-game-theory-applied (terciária): interação estratégica, adverse selection
// - lens-mechanism-design (terciária): design de incentivos
// - lens-stakeholder-communication (terciária): credibilidade, comunicação
//
// O que NÃO vive aqui:
// - incentivos específicos por BC → canvas (incentiveAnalysis)
// - papel do stakeholder no contexto de um BC → canvas (stakeholders[].role)
// - topologia entre BCs → context map
// - relações inter-stakeholder → capturadas implicitamente via canvas
//   (co-ocorrência como stakeholders do mesmo BC) e manipulationVectors
//   (attackSurface indica onde o vetor intersecta outros atores)

#StakeholderMap: {
	description: string & !=""

	// Catálogo de stakeholders do ecossistema.
	// Ao menos um stakeholder é obrigatório.
	stakeholders: [#Stakeholder, ...#Stakeholder]

	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^domain/stakeholder-map\\.cue$"
			fileNameRegex:      "^stakeholder-map\\.cue$"
			description:        "Stakeholder map: catálogo canônico dos stakeholders do ecossistema."
			rationale:          "Stakeholder map vive em domain/ porque stakeholders transcendem BCs individuais. É a fonte de verdade para sh-* refs."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-sm-01"
			description: "Todo stakeholder tem code único"
			test:        "Nenhum code duplicado em stakeholders[]. Validação por runner."
			severity:    "fail"
			rationale:   "Code duplicado quebra integridade referencial dos sh-* refs."
		}, {
			id:          "tq-sm-02"
			description: "Pain points referenciam custos de transação válidos"
			test:        "Cada stakeholders[].painPoints[].costRef existe como id em domain/domain-definition.cue seção value.costsEliminated[]. Validação por runner."
			severity:    "fail"
			rationale:   "Pain point referenciando custo inexistente quebra rastreabilidade econômica."
		}, {
			id:          "tq-sm-03"
			description: "Todo stakeholder é referenciado por ao menos um canvas"
			test:        "Cada stakeholders[].code aparece como stakeholderRef em ao menos um canvas. Validação por runner."
			severity:    "warn"
			rationale:   "Stakeholder sem vínculo com nenhum BC pode ser legítimo (futuro) mas normalmente indica mapa incompleto."
		}, {
			id:          "tq-sm-04"
			description: "Participantes econômicos ativos têm vetores de manipulação"
			test:        "Stakeholders com category network-participant, financial-institution ou platform-operator têm incentiveProfile.manipulationVectors com ao menos uma entrada. Demais categorias (government-authority, industry-association, technology-provider) são isentas. Validação por runner."
			severity:    "fail"
			rationale:   "dp-08 exige mapeamento de riscos de manipulação para quem transaciona. Reguladores, associações e provedores de tecnologia não operam dentro do ecossistema financeiro como participantes econômicos ativos — obrigatoriedade seria artificial."
		}, {
			id:          "tq-sm-05"
			description: "Interesses são semanticamente distintos entre stakeholders"
			test:        "Nenhum par de stakeholders tem interests idênticos em todas as entradas. Heurístico — stakeholders com interesses idênticos provavelmente deveriam ser o mesmo archetype. Validação por runner ou revisão humana."
			severity:    "warn"
			rationale:   "Stakeholders duplicados semanticamente inflam o mapa. warn porque distinção semântica completa pode exigir julgamento."
		}, {
			id:          "tq-sm-06"
			description: "Codes internos são únicos dentro de cada stakeholder"
			test:        "Nenhum code duplicado em stakeholders[].interests[].code, stakeholders[].painPoints[].code ou stakeholders[].incentiveProfile.manipulationVectors[].code de um mesmo stakeholder. Validação por runner."
			severity:    "fail"
			rationale:   "Code duplicado dentro de sub-catálogos quebra rastreabilidade."
		}, {
			id:          "tq-sm-07"
			description: "Platform relationships são únicos dentro de cada stakeholder"
			test:        "Nenhum valor duplicado em stakeholders[].platformRelationships[]. Validação por runner."
			severity:    "fail"
			rationale:   "Duplicata em platformRelationships é ruído sem valor semântico."
		}]
		rationale: "Critérios cobrem integridade referencial (tq-sm-01, tq-sm-02, tq-sm-06), cobertura por canvas (tq-sm-03), alinhamento com dp-08 condicional por categoria (tq-sm-04), distinção semântica (tq-sm-05) e unicidade de platform relationships (tq-sm-07)."
	}
}

// ==============================
// STAKEHOLDERS
// ==============================

#Stakeholder: {
	// Code numérico sh-NN alinhado com canvas stakeholderRef.
	// Canvas usa ^sh-[0-9]{2}$ — este schema segue o mesmo padrão
	// para garantir integridade referencial cross-artifact.
	code: #StakeholderRef

	// Nome do archetype de stakeholder.
	name: #NonEmptyString

	// Descrição do segmento que este archetype representa.
	description: #NonEmptyString

	// Categoria do stakeholder no ecossistema.
	category: #StakeholderCategory

	// Como este stakeholder se relaciona com a plataforma Mesh.
	// Lista porque um stakeholder pode ocupar múltiplos papéis
	// (e.g., banco parceiro é infrastructure-provider e direct-user).
	// tq-sm-07 enforça unicidade via runner.
	platformRelationships: [#PlatformRelationship, ...#PlatformRelationship]

	// O que este stakeholder busca — interesses no nível do ecossistema.
	// Codes int-* são scoped a este stakeholder — não são refs globais.
	// Slug-based por legibilidade (int-compliance, int-growth), diferente
	// dos refs numéricos globais (sh-NN, ce-NN).
	interests: [#StakeholderInterest, ...#StakeholderInterest]

	// Dores que a Mesh endereça para este stakeholder.
	// Ao menos uma dor é obrigatória por tipo.
	// Pain points referenciam custos de transação canônicos (ce-*).
	// Codes pp-* são scoped a este stakeholder — não são refs globais.
	painPoints: [#PainPoint, ...#PainPoint]

	// Perfil de incentivos no nível do ecossistema.
	// O canvas detalha incentivos específicos por BC.
	// manipulationVectors é opcional no type system (?); obrigatório
	// por runner (tq-sm-04) para categorias econômicas ativas
	// (network-participant, financial-institution, platform-operator).
	// Para categorias isentas, pode ser omitido.
	// Gap type-system ↔ runtime: enforcement condicional por categoria
	// não é expressável em CUE — runner é o enforcement efetivo.
	incentiveProfile: #IncentiveProfile

	// Por que este archetype de stakeholder é relevante para o ecossistema Mesh.
	rationale: #NonEmptyString
}

// ==============================
// STAKEHOLDER CATEGORIES
// ==============================

// Categorias que refletem os papéis econômicos no ecossistema Mesh.
// Substituem a taxonomia anterior (#StakeholderType) que classificava
// por natureza jurídica (person|organization|system|agent|regulator).
// Nova taxonomia classifica por papel econômico — mais útil para
// análise de incentivos, manipulação e design de mecanismos.
//
// platform-operator é incluído intencionalmente: a Mesh como operador
// também tem incentivos, vetores de manipulação e dores. O mapa cobre
// o ecossistema completo, não apenas atores externos.
//
// technology-provider cobre provedores de infra ou serviços técnicos
// que a Mesh consome (e.g., cloud, registradoras). Isentos de
// manipulationVectors obrigatório (tq-sm-04) porque não transacionam
// dentro do ecossistema financeiro como participantes ativos.
#StakeholderCategory:
	"network-participant" |      // Buyer, Supplier — opera dentro da rede
	"financial-institution" |    // Bancos, FIDCs — provê ou consome serviços financeiros
	"government-authority" |     // SEFAZ, Receita, CREAs — regula
	"platform-operator" |        // A própria Mesh como operador da rede
	"industry-association" |     // Sindicatos, associações setoriais
	"technology-provider"        // Provedores de infra ou serviços técnicos

// ==============================
// PLATFORM RELATIONSHIP
// ==============================

// Como o stakeholder se relaciona com a plataforma.
// Fronteira data-source vs infrastructure-provider:
// - infrastructure-provider: provê capacidade computacional, de rede ou
//   de serviço que a plataforma executa sobre (cloud, registradora, bureau)
// - data-source: fornece dados que a plataforma consome como input para
//   decisões de domínio (SEFAZ para NFe, bureau para score), sem prover
//   infraestrutura de execução
// Um stakeholder pode ser ambos se provê infra E dados independentes.
#PlatformRelationship:
	"direct-user" |              // Usa a plataforma diretamente
	"indirect-beneficiary" |     // Beneficia-se sem usar diretamente
	"regulator" |                // Regula ou fiscaliza operações na plataforma
	"infrastructure-provider" |  // Provê infraestrutura que a plataforma consome
	"data-source"                // Fornece dados que a plataforma consome

// ==============================
// INTERESTS
// ==============================

#StakeholderInterest: {
	// Code scoped ao stakeholder, não global. Slug-based por legibilidade.
	code: string & =~"^int-[a-z][a-z0-9-]*$"
	description: #NonEmptyString

	// Prioridade relativa deste interesse para o stakeholder.
	priority: #InterestPriority

	// Por que este interesse é relevante para este stakeholder.
	rationale: #NonEmptyString
}

#InterestPriority:
	"critical" |     // Sem isso, o stakeholder não participa
	"important" |    // Influencia fortemente a decisão de participar
	"desirable"      // Agrega valor mas não é decisivo

// ==============================
// PAIN POINTS
// ==============================

// Dor que a Mesh endereça para este stakeholder.
// Referencia custo de transação canônico para rastreabilidade.
#PainPoint: {
	// Code scoped ao stakeholder, não global. Slug-based por legibilidade.
	code: string & =~"^pp-[a-z][a-z0-9-]*$"
	description: #NonEmptyString

	// Referência ao custo de transação que esta dor materializa.
	// Formato numérico ce-NN alinhado com domain-definition.cue.
	// Runner valida existência em domain/domain-definition.cue seção
	// value.costsEliminated[].id.
	costRef: #CostRef

	// Severidade da dor para este stakeholder.
	severity: #PainSeverity

	// Por que esta dor é relevante e como ela se manifesta concretamente.
	rationale: #NonEmptyString
}

#PainSeverity:
	"blocking" |     // Impede operação normal
	"degrading" |    // Degrada eficiência ou custo significativamente
	"annoying"       // Causa fricção mas não impede operação

// ==============================
// INCENTIVE PROFILE
// ==============================

// Perfil de incentivos no nível do ecossistema.
// O canvas detalha a análise específica por BC.
// manipulationVectors é opcional no type system CUE (?);
// obrigatório por runner (tq-sm-04) para categorias econômicas
// ativas (network-participant, financial-institution, platform-operator).
// Para categorias isentas, pode ser omitido.
#IncentiveProfile: {
	// O que o stakeholder ganha participando da Mesh.
	desiredOutcomes: [#NonEmptyString, ...#NonEmptyString]

	// Como o stakeholder poderia manipular o sistema.
	// dp-08 exige que esses vetores sejam mapeados para participantes ativos.
	manipulationVectors?: [...#ManipulationVector]

	// Por que este perfil de incentivos importa para o design do sistema.
	rationale: #NonEmptyString
}

#ManipulationVector: {
	// Code scoped ao stakeholder, não global. Slug-based por legibilidade.
	code: string & =~"^mv-[a-z][a-z0-9-]*$"
	description: #NonEmptyString

	// Benefício que o stakeholder obteria com a manipulação.
	expectedBenefit: #NonEmptyString

	// Onde no sistema a manipulação seria tentada.
	attackSurface: #NonEmptyString

	// Por que este vetor é plausível e merece atenção de design.
	rationale: #NonEmptyString
}

// ==============================
// REFS
// ==============================

// Formato numérico sh-NN, alinhado com canvas stakeholderRef (^sh-[0-9]{2}$).
#StakeholderRef: string & =~"^sh-[0-9]{2}$"

// Formato numérico ce-NN, alinhado com domain-definition costsEliminated[].id.
#CostRef: string & =~"^ce-[0-9]{2}$"

#NonEmptyString: string & !=""
