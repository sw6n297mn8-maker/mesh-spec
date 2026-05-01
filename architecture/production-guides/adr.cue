package production_guides

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr.cue — Production guide para Architecture Decision Records.
//
// Schema alvo: #ADR (architecture/artifact-schemas/adr.cue).
// Discriminated union por status: non-superseded → supersededBy proibido;
// superseded → supersededBy obrigatório.
//
// Phase pulled forward por cascade-ordering precondition (adr-054 dec 13)
// — autoria precede adr-056 e ADR de Layer 1 (cascade-ordering check).
// Cobre dívida acumulada: adr-001..adr-055 foram autorados sem PG-ADR
// (regra cascade entrou em adr-054, post-fact). Reconciliação via change-
// on-touch quando ADRs futuros forem amendments.
//
// Materializado em commit único section-by-section sob gates voluntários
// (manualAuthoringProtocol em adr-056 ainda não codificado; disciplina
// antecipada por convenção).

adrGuide: artifact_schemas.#ProductionGuide & {

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/adr\\.cue$"
			fileNameRegex:      "^adr\\.cue$"
			description:        "Production guide para autoria de Architecture Decision Records em mesh-spec."
			rationale:          "Schema #ADR é instanciável (cardinality collection); tq-as-05 exige guide. Phase pulled forward por cascade-ordering precondition (adr-054 dec 13) — PG necessário antes de adr-056 e ADR de Layer 1 cascade-ordering check; cobre também dívida acumulada de adr-001..adr-055 autorados pre-cascade rule."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-adrg-01"
			description: "Guide produz instância com alternativas substantivas ou 'única opção viável' justificada (anti-fabricação)"
			test:        "Process inclui passo explícito de coletar alternativas com founder (collectFromFounder item 3); gapPolicy proíbe fabricação por completude formal; finalValidation step verifica tq-adr-01. Reforço de guide-level sobre tq-adr-01 do schema (já fail) — guide reitera porque fabricação de alternativas decorativas é vetor primário de degradação observado."
			severity:    "fail"
			rationale:   "tq-adr-01 do schema já é fail; guide reitera porque agentes tendem a 'preencher' tq-adr-01 com alternativas inventadas para passar lint sem registrar espaço de decisão real. Guide explicita anti-fabricação no gapPolicy + collectFromFounder."
		}, {
			id:          "tq-adrg-02"
			description: "Guide força calibração de risk metadata pelo founder (anti-default-baseline)"
			test:        "collectFromFounder explicita decisionClass/reversibility/blastRadius como inputs do founder; gapPolicy proíbe inferir defaults por similaridade; finalValidation step verifica tq-adr-02. Reforço sobre tq-adr-02 do schema (já fail)."
			severity:    "fail"
			rationale:   "Risk metadata genérica derrota governance proporcional ao risco. Pattern observado: agentes inferem 'medium/cross-artifact' defaults sem calibração — guide bloqueia explicitamente forçando founder confirmation."
		}, {
			id:          "tq-adrg-03"
			description: "Guide produz traceability metadata com paths reais sob disciplina 3-way conceitual"
			test:        "Process da consequences-rationale-and-traceability exige declaração de affectedArtifacts (paths existentes alterados E novos criados pela decisão) + derivedArtifacts (regenerados/derivados como consequência indireta). Disciplina 3-way conceitual: existing-altered, new-created, derived-regenerated. Enquanto o schema não separar new-created como campo próprio, arquivos novos criados pela decisão entram em affectedArtifacts com rationale claro distinguindo-os dos existing-altered. gapPolicy proíbe paths especulativos. finalValidation verifica tq-adr-03."
			severity:    "fail"
			rationale:   "tq-adr-03 do schema já é fail; guide reitera. Disciplina 3-way conceitual orienta o autor a distinguir 3 categorias funcionalmente diferentes mesmo enquanto schema atual mantém apenas 2 campos (affectedArtifacts conflating existing-altered + new-created; derivedArtifacts para derived-regenerated). Schema extension separando new-created é dívida planejada quando volume de ADRs justificar."
		}, {
			id:          "tq-adrg-04"
			description: "Guide força update do ADR antigo no MESMO commit em supersession"
			test:        "Process da scaffold-and-classification exige declaração de supersedes E plano explícito de update do ADR antigo (status → 'superseded' + supersededBy preenchido) no MESMO commit. gapPolicy explicita; finalValidation step verifica."
			severity:    "warn"
			rationale:   "CI phase adr-consistency valida simetria supersedes↔supersededBy + acyclicity. Multi-commit gap entre ADR novo e update do antigo cria janela de inconsistência relacional observável; warn level porque é recoverable (commit corretivo posterior funciona) mas estado fica observavelmente quebrado entre commits — disciplina reduz tempo da janela."
		}]
		rationale: "4 critérios cobrem disciplinas centrais para autoria de ADR: alternativas substantivas (tq-adrg-01 hardening), calibração founder de risk metadata (tq-adrg-02 hardening), paths reais sob disciplina 3-way conceitual (tq-adrg-03 hardening), supersession synchrony (tq-adrg-04 warn). tq-adr-01/02/03 do schema cobrem o lado de instância autorada; tq-adrg-XX cobrem o lado de PROCESSO de autoria — separação consistente com meta-guide (tq-mg-XX) vs schema (#ProductionGuide tq-pg-XX). Hardening em 01/02/03 (todos fail no schema, todos fail no guide) reitera disciplina porque vetores de degradação observados (fabricação de alternativas, defaults de risk metadata, paths especulativos) são frequentes em authoring por agente."
	}

	prerequisites: {
		description: "Antes de autorar uma ADR, agente lê schema #ADR + 1-3 ADRs recentes do mesmo decisionClass como referência estrutural + architecture/design-principles.cue para principlesApplied IDs reais, e confirma com founder o escopo da decisão antes de iniciar redação. ADR documenta DECISÃO crystallizada, não exploração."
		collectFromFounder: [
			"Decisão crystallizada em uma frase afirmativa ('Adotar X', 'Estabelecer Y como Z', 'Substituir A por B') — se ainda não está crystallizada, postergar autoria",
			"Trigger / motivating context: o que tornou esta decisão necessária AGORA (discovery concreta, gap observado, requirement externo, supersession de ADR anterior)",
			"Alternativas reais consideradas durante o processo decisório (mínimo 1 ou justificar 'única opção viável' no rationale) — agente NÃO fabrica alternativas; tq-adr-01 fail",
			"principlesApplied: lista de P-XX de architecture/design-principles.cue que founder identificou como aplicados — agente NÃO inventa IDs nem assume aplicação por similaridade",
			"Calibração de metadata de risco: decisionClass (foundational/structural/local/experimental), reversibility (high/medium/low), blastRadius (local/cross-artifact/cross-cutting/repo-wide) — agente NÃO infere defaults; calibração é judgment do founder per governance proporcional",
			"Traceability: paths sob disciplina 3-way conceitual — existing-altered (arquivos existentes alterados pela decisão), new-created (arquivos novos criados pela decisão como output direto), derived-regenerated (regenerados como consequência indireta). Schema atual conflate existing-altered + new-created em affectedArtifacts; derivedArtifacts cobre derived-regenerated. Agente NÃO inclui paths especulativos; tq-adr-03 fail",
			"Supersession (se aplica): IDs em supersedes; founder confirma plano de update do ADR antigo (status → 'superseded' + supersededBy) no MESMO commit",
		]
		gapPolicy: "Se a decisão ainda não está crystallizada (founder não consegue articular em uma frase afirmativa o que está sendo decidido), NÃO autore a ADR — postergue até decisão estar tomada; ADR documenta resultado, não processo de exploração. NÃO invente alternativas — alternativas vêm do processo decisório real (founder articula); se nenhuma alternativa substantiva foi considerada, declare 'única opção viável' explicitamente no rationale com justificativa (per tq-adr-01). NÃO fabrique consequences genéricas ('reduz custo', 'melhora qualidade') — consequences são trade-offs observáveis específicos à decisão e ao contexto Mesh; placeholders falham tq-adr-02. NÃO infira decisionClass/reversibility/blastRadius por similaridade superficial com ADRs existentes — calibração pertence ao founder por construção (governance proporcional ao risco da decisão). NÃO inclua paths em affectedArtifacts/derivedArtifacts que não existam E não sejam outputs diretos da decisão registrada (tq-adr-03 fail); enquanto schema não separar new-created como campo próprio, paths novos criados entram em affectedArtifacts com rationale claro distinguindo-os dos existentes alterados. NÃO referencie principlesApplied sem ler architecture/design-principles.cue — invenção de IDs P-XX quebra rastreabilidade. Se cadeia de supersession aplica, NÃO commite o ADR novo sem atualizar o antigo no MESMO commit (status → 'superseded', supersededBy preenchido) — minimiza janela de inconsistência relacional validada por CI phase adr-consistency. Quando dúvida persistir, pergunta direta ao founder; nunca preencher por inferência heurística."
		validatorNote: "Em Phase 0, validação é (a) cue vet para shape — incluindo discriminated union status↔supersededBy enforced no schema, (b) founder review semântico — calibração de metadata de risco (tq-adr-02) e rastreabilidade (tq-adr-03) exigem judgment humano não automatizável. CI phase adr-consistency (post-commit) valida invariants relacionais: existência dos ADRs em supersedes, simetria supersedes↔supersededBy, acyclicity. Quality criteria intrínsecos do schema (tq-adr-01 alternativas, tq-adr-02 risk metadata, tq-adr-03 paths reais) são structurally inspecionáveis mas exigem founder review para distinguir alternativas substantivas vs decorativas."
		outputNote: "Output é arquivo único architecture/adrs/adr-NNN-{slug}.cue conformante a #ADR. NNN é zero-padded sequencial sobre o último ADR existente; slug é descritivo em kebab-case (≤6 palavras tipicamente). Regex completo do filename: '^adr-[0-9]{3}-[a-z0-9-]+\\.cue$'. Tamanho típico: 100-300 linhas dependendo da complexidade (adr-054 = 296 linhas; ADRs simples podem ser 80-120). ADRs substantivos materializam-se em multi-commit pattern observado (scaffold → context+decision → consequences+rationale) — padrão de adr-053, adr-054, adr-055. cardinality 'collection' no schema (múltiplas ADRs no diretório architecture/adrs/)."
	}

	workOrder: [
		"scaffold-and-classification",
		"context-decision-and-alternatives",
		"consequences-rationale-and-traceability",
	]

	sections: {
		"scaffold-and-classification": {
			target:    "#ADR"
			objective: "Compor identity (id, title, date), classification (decisionClass, decider, status), risk metadata (reversibility, blastRadius), e supersession refs (se aplica), com base nos inputs do founder coletados em prerequisites. Esta section produz o envelope estrutural antes da redação substantiva."
			process: [{
				action: "Identificar próximo NNN sequencial"
				detail: "Listar architecture/adrs/ ordenado; próximo id é último_NNN + 1, zero-padded para 3 dígitos. Verificar inexistência de adr-NNN para evitar colisão. Convenção interna: NNN é monotônico, não reusa números (ADRs withdrawn/rejected mantêm número)."
			}, {
				action: "Compor slug kebab-case e title afirmativo"
				detail: "slug deriva da decisão (≤6 palavras tipicamente; a-z, 0-9, hífen). title é afirmativo ('Establish X', 'Adopt Y as Z', 'Promote A to B') — não declarativo ('X é Y') nem pergunta ('How to handle X'). title ≤80 runes recomendado."
			}, {
				action: "Declarar date no formato ISO YYYY-MM-DD"
				detail: "date é a data da sessão de autoria (não da decisão informal precedente). Regex schema: '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'. Sessão multi-commit usa a mesma date."
			}, {
				action: "Declarar decisionClass, decider, status com calibração do founder"
				detail: "decisionClass ∈ {foundational, structural, local, experimental}: foundational = base do sistema (governança, schema base, SoTs); structural = altera relações entre artefatos; local = escopo 1 artefato/BC; experimental = temporário com critério de revisão. decider = 'founder' (mesh-spec atual). status default 'proposed' para ADR novo; 'accepted' válido no commit inicial APENAS se founder aprovou explicitamente a decisão antes do commit (não inferir aprovação tácita); 'superseded' exige supersededBy preenchido."
			}, {
				action: "Declarar reversibility e blastRadius"
				detail: "reversibility ∈ {high, medium, low}: high = sem impacto persistido; medium = migração necessária; low = irreversível ou custo desproporcional. blastRadius ∈ {local, cross-artifact, cross-cutting, repo-wide}: local = 1 artefato; cross-artifact = múltiplos artefatos mesmo domínio; cross-cutting = múltiplos domínios; repo-wide = governança/CI/estrutura inteira. Calibração founder; agente NÃO infere defaults."
			}, {
				action: "Declarar supersedes (se aplica) e planejar update do ADR antigo"
				detail: "Se decisão supersede ADR(s) anterior(es): listar IDs em supersedes. CRITICAL: ADR antigo precisa ser updated no MESMO commit (status → 'superseded', supersededBy preenchido para este novo ID). CI phase adr-consistency valida simetria; janela de inconsistência multi-commit é red flag."
			}]
			sources: [
				"architecture/artifact-schemas/adr.cue (#ADR discriminated union, sub-types #DecisionClass/#Reversibility/#BlastRadius)",
				"architecture/adrs/ (ADRs existentes — observar último NNN para sequência)",
				"architecture/adrs/adr-054-declarative-authoring-policy.cue (exemplo substantivo recente, 296 linhas)",
				"architecture/adrs/adr-049-extend-structural-check-conditional-file-presence.cue (exemplo schema-extension)",
			]
			heuristics: [
				"title afirmativo afirma a decisão ('Establish X', 'Adopt Y'); pergunta ('How to X') ou descrição ('X em Y') é code smell.",
				"status default 'proposed' para ADR novo; 'accepted' no commit inicial APENAS se founder aprovou explicitamente antes do commit; promoção 'proposed' → 'accepted' em turn separado também é caminho válido.",
				"decisionClass calibração imprecisa = governance proporcional quebra; founder confirma sempre.",
				"reversibility 'low' E blastRadius 'cross-cutting' OU 'repo-wide' aciona alerta — decisões irreversíveis com blast radius alto exigem escrutínio extra (alinhamento com CLAUDE.md L142-151 reversibilityThreshold).",
				"Supersession derivedFrom previous ADR (tq-mg-06): supersedes é ref explícita; agente verifica que ADR antigo é updated no mesmo commit (CI adr-consistency valida).",
			]
			doneCriteria: "id sequencial determinado e não-conflitante; title afirmativo ≤80 runes; date ISO; decisionClass/decider/status declarados conforme calibração founder; reversibility e blastRadius calibrados; supersedes preenchido SE aplica E plano de update do ADR antigo no mesmo commit confirmado."
			ifGap:        "Se founder não calibrar metadata de risco (decisionClass/reversibility/blastRadius), pergunta direta antes de prosseguir — defaults inferidos por similaridade falham tq-adr-02. Se NNN sequencial colide com ADR existente, escolher próximo livre e documentar."
		}

		"context-decision-and-alternatives": {
			target:    "#ADR"
			objective: "Compor o núcleo substantivo do ADR — context (motivating why-now), decision (afirmativa específica numerada), alternativas consideradas com justificativa de rejeição (tq-adr-01)."
			process: [{
				action: "Compor context endereçando state-of-affairs e trigger"
				detail: "context responde 'por que esta decisão AGORA?' — 2-4 parágrafos cobrindo (a) state-of-affairs precedente (artefatos relevantes, ADRs anteriores), (b) trigger concreto (discovery, gap observado em revisão, requirement externo, supersession). context pode resumir o espaço de decisão; alternativas devem aparecer em bloco explícito quando o schema suportar OU dentro do context com marcador claro ('Alternativas avaliadas:'). Sem context, decision é declaração sem espaço de decisão registrado."
			}, {
				action: "Compor alternativas com motivo de rejeição"
				detail: "Alternativas reais consideradas listadas em bloco explícito (quando schema suportar) OU dentro de context com marcador 'Alternativas avaliadas:' seguido de '(a) X — motivo de rejeição; (b) Y — motivo'. Cada alternativa tem motivo de rejeição declarado, não 'não escolhida' tautológico. Se nenhuma alternativa substantiva foi considerada, declare 'única opção viável' no rationale com justificativa concreta (bootstrapping, requirement legal, lock-in técnico, supersession direta)."
			}, {
				action: "Compor decision como lista numerada de decision items afirmativos"
				detail: "decision items numerados (1) (2) ... (N) — cada item afirmativo e específico ('ESTABELECER X em Y'; 'ADICIONAR campo Z ao schema W'). Numeração permite refs cross-ADR ('per adr-054 dec 13'). Multiple items quando decisão tem subdecisões coesas; single item quando decisão é unitária. Evitar items vagos ('considerar X', 'avaliar Y') — decision registra resultado, não plano."
			}, {
				action: "Verificar tq-adr-01 sobre alternativas substantivas"
				detail: "Cada alternativa em context tem motivo de rejeição declarado (não 'não escolhida' tautológico). Se 'única opção viável' foi declarada, verificar se justificativa é concreta. Alternativa decorativa fabricada falha tq-adr-01."
			}, {
				action: "Verificar especificidade Mesh (uq-02 universal)"
				detail: "Teste de substituição: trocar 'Mesh' por 'qualquer fintech' no context+decision. Se texto continua válido, está genérico — falta ancoragem em mecanismos específicos da Mesh (evidência verificável, agentes com gates, três SoTs, SCD, P10). Reescrever com refs concretas a princípios/lenses/ADRs."
			}]
			sources: [
				"architecture/artifact-schemas/adr.cue _qualityCriteria (tq-adr-01 alternativas, tq-adr-02 risk, tq-adr-03 paths)",
				"architecture/design-principles.cue (P-XX referenciados em principlesApplied)",
				"governance/build-time/quality-gate.cue (uq-02 specificity test)",
				"architecture/adrs/adr-054-declarative-authoring-policy.cue (exemplo de context substantivo + decision numerada)",
			]
			heuristics: [
				"context fala do PORQUÊ AGORA — não history geral do tópico; trigger é concreto e datado quando possível.",
				"Alternativas em bloco explícito (quando schema suportar) OU dentro de context com marcador claro ('Alternativas avaliadas:') — evita confusão entre history e espaço de decisão.",
				"Alternativas avaliadas: o que foi REALMENTE considerado e descartado, não checklist de completude formal.",
				"decision afirmativa ('Estabelecer X') > declarativa ('X é Y'); evita ambiguidade entre 'estamos decidindo' e 'já decidimos'.",
				"Numeração (1)(2)... em decision items: estável para refs cross-ADR ao longo do tempo.",
				"Specificity test (uq-02) — substituir 'Mesh' por 'qualquer fintech' deve quebrar afirmação; se não quebrar, ADR está abstrato demais.",
				"Volume de alternativas: 1-3 alternativas substantivas é típico; 5+ alternativas pode indicar exploração não consolidada (decisão talvez não esteja crystallizada).",
			]
			doneCriteria: "context ≥2 parágrafos cobrindo state-of-affairs + trigger; alternativas em bloco explícito ou marcador claro com motivo de rejeição declarado; decision numerada com ≥1 item afirmativo específico; tq-adr-01 satisfeito (alternativas substantivas OU 'única opção viável' justificada); uq-02 satisfeito (Mesh-specific, não substituível por 'qualquer fintech')."
			ifGap:        "Se founder não articular alternativas reais, declarar 'única opção viável' no rationale com justificativa concreta (bootstrapping, requirement legal, lock-in técnico, supersession direta). Se context fica genérico após reescritas, reconsiderar se decisão está crystallizada — ADR sobre decisão difusa é antipattern (postergar autoria)."
		}

		"consequences-rationale-and-traceability": {
			target:    "#ADR"
			objective: "Compor closing analysis — consequences positivas e negativas, rationale synthesis, e traceability metadata (affectedArtifacts, derivedArtifacts, principlesApplied) com paths reais sob disciplina 3-way conceitual."
			process: [{
				action: "Compor consequences como listas positiva (P1..PN) e negativa (N1..NM)"
				detail: "Cada consequence é específica e observável: 'P1: variance reduction de aplicação manual', 'N1: custo de turnaround per section'. Genérico ('reduz custo', 'melhora qualidade') falha tq-adr-02 (risk metadata desconectada de consequences observáveis). Listas separadas explicitam trade-offs."
			}, {
				action: "Compor rationale articulando coerência com princípios e trade-offs"
				detail: "rationale explica por que ESTA opção entre as alternativas — não duplica decision. Cobre: princípios aplicados (P-XX) com justificativa, axiomas tensionados (se houver, com tag [TENSÃO: ax-XX]), lenses consultadas, relação com ADRs anteriores (supersedes/extends), reversibilidade/blast radius justification."
			}, {
				action: "Declarar affectedArtifacts e derivedArtifacts sob disciplina 3-way conceitual"
				detail: "Disciplina 3-way conceitual: existing-altered (arquivos existentes alterados pela decisão), new-created (arquivos novos criados pela decisão como output direto), derived-regenerated (regenerados como consequência indireta). Schema atual conflate existing-altered + new-created em affectedArtifacts; derivedArtifacts cobre derived-regenerated. Enquanto schema não separar new-created como campo próprio, arquivos novos criados pela decisão entram em affectedArtifacts com rationale claro distinguindo-os dos existing-altered. Cada path inspeccionável; tq-adr-03 fail se path fictício."
			}, {
				action: "Declarar principlesApplied com IDs verificados em design-principles.cue"
				detail: "principlesApplied lista P-XX confirmados pelo founder. Agente verifica EXISTÊNCIA dos IDs em architecture/design-principles.cue ANTES de incluir. IDs inventados ou ranqueados por similaridade quebram rastreabilidade."
			}, {
				action: "Verificar tq-adr-02 (risk metadata coerente com consequences)"
				detail: "reversibility=='low' coerente com consequences que descrevem persistência/contratos? blastRadius=='local' coerente com affectedArtifacts em múltiplos domínios? Inconsistência detectada → recalibrar metadata em scaffold-and-classification (NÃO ajustar consequences para casar com metadata pré-declarada)."
			}, {
				action: "Verificar tq-adr-03 (paths em affectedArtifacts e derivedArtifacts são reais)"
				detail: "Para cada path: ls do filesystem (existente alterado) OU referência explícita a output direto da decisão (e.g., 'criado por decision item N'). Path especulativo ou aspiracional sem rastreabilidade falha. Sob disciplina 3-way: distinguir mentalmente existing-altered (path já existe) vs new-created (path será criado como output direto) vs derived-regenerated (path será regenerado por tooling)."
			}]
			sources: [
				"architecture/artifact-schemas/adr.cue _qualityCriteria (tq-adr-02 risk metadata, tq-adr-03 paths reais)",
				"architecture/design-principles.cue (P-XX existentes para principlesApplied)",
				"architecture/adrs/adr-054-declarative-authoring-policy.cue (exemplo de consequences P/N estruturadas + rationale com lenses)",
				"architecture/lenses/ (lenses consultadas referenciadas no rationale)",
			]
			heuristics: [
				"consequences específicas observáveis > genéricas: 'P1 elimina classe X de drift' > 'P1 melhora qualidade'.",
				"Listas positiva/negativa explícitas: forçam articulação dos trade-offs (decisão sem trade-off declarado costuma ser superficial).",
				"rationale referencia mecanismos Mesh-específicos (P-XX, axiomas, lenses) — passa uq-02 specificity test.",
				"Disciplina 3-way conceitual: agente distingue mentalmente existing-altered / new-created / derived-regenerated mesmo quando schema atual conflate em 2 campos; rationale claro no contexto do ADR identifica qual categoria cada path representa.",
				"affectedArtifacts: cada path é validável por inspeção (existing-altered) ou rastreável a decision item específico (new-created).",
				"principlesApplied: founder-confirmed; agente NÃO infere por similaridade — discipline analoga a paths discipline.",
				"Coherence rule: se rationale menciona 'low cost de reversão', metadata reversibility deve ser 'high' — descasamento é tq-adr-02 fail.",
				"Tensão com axiomas: se decisão contradiz axioma, declarar [TENSÃO: ax-XX] com motivo no rationale (per CLAUDE.md L11-15) E criar tension-log entry no mesmo commit.",
			]
			doneCriteria: "consequences com listas positiva (≥1 item) e negativa (≥1 item) específicas e observáveis; rationale articula coerência com princípios + trade-offs (sem duplicar decision); affectedArtifacts e derivedArtifacts com paths reais sob disciplina 3-way conceitual; principlesApplied com IDs verificados em design-principles.cue; tq-adr-02 e tq-adr-03 verificados."
			ifGap:        "Se consequences ficam genéricas após reescritas, reconsiderar se decisão tem trade-offs reais ou se é trivial (decisão trivial talvez não justifique ADR). Se algum path em affectedArtifacts ou derivedArtifacts não existe E não é output direto/derivado, REMOVER da lista — não invente. Se rationale repete decision em outras palavras, falta synthesis — articular coerência com princípios/axiomas/lenses."
		}
	}

	finalValidation: {
		steps: [
			"Verificar shape: instância valida contra #ADR (todos campos obrigatórios; discriminated union status↔supersededBy enforced; regex de id, date, supersededBy satisfeitos).",
			"Verificar tq-pg-01 / tq-mg-01: workOrder é permutação exata das chaves de sections (3 sections; sem redundância, omissão ou duplicata).",
			"Verificar tq-pg-02: cada section.target referencia tipo existente em schema adotado (#ADR para todas 3 sections deste guide).",
			"Verificar tq-pg-04 / tq-mg-04: prerequisites.gapPolicy ≥50 runes E declara explicitamente comportamento anti-invenção (cláusulas 'NÃO autore se decisão não crystallizada', 'NÃO invente alternativas', 'NÃO fabrique consequences', 'NÃO infira metadata', 'NÃO inclua paths especulativos', 'NÃO referencie principlesApplied sem ler design-principles.cue').",
			"Verificar tq-pg-05 / tq-mg-03: finalValidation.steps[-1] menciona submissão/revisão/aprovação do founder.",
			"Verificar tq-pg-06 / tq-mg-02: cada section.process[].action começa com verbo imperativo concreto da lista canônica (Identificar, Compor, Declarar, Verificar, ...).",
			"Verificar tq-adr-01 / tq-adrg-01 (hardened fail): para cada ADR autorada via este guide, context contém alternativas substantivas em bloco explícito ou marcador claro com motivo de rejeição declarado, OU rationale declara explicitamente 'única opção viável' com justificativa concreta. Alternativas decorativas fabricadas para passar lint = fail.",
			"Verificar tq-adr-02 / tq-adrg-02 (hardened fail): para cada ADR, decisionClass/reversibility/blastRadius coerentes com decision e consequences (calibração founder, não inferida). Coherence rule: rationale menciona 'low cost de reversão' ⇒ reversibility 'high'; affectedArtifacts em múltiplos domínios ⇒ blastRadius ≠ 'local'.",
			"Verificar tq-adr-03 / tq-adrg-03 (hardened fail): para cada ADR, paths em affectedArtifacts e derivedArtifacts existem no filesystem OU são outputs diretos/derivados declarados de decision items específicos. Disciplina 3-way conceitual: agente distingue existing-altered / new-created / derived-regenerated; enquanto schema não separar new-created, arquivos novos criados pela decisão entram em affectedArtifacts com rationale claro distinguindo-os dos existentes alterados.",
			"Verificar uq-02 specificity test: substituir 'Mesh' por 'qualquer fintech' no context+decision+rationale deve quebrar afirmações. Se texto continua válido, reescrever com refs concretas a princípios/lenses/ADRs/mecanismos Mesh-específicos.",
			"Verificar supersession synchrony (tq-adrg-04 warn): se supersedes preenchido, ADR antigo está no mesmo staging com status → 'superseded' + supersededBy apontando para este novo ID. Multi-commit gap = recoverable mas observavelmente inconsistente entre commits.",
			"Verificar canonical removal (tq-mg-10 warn): se ADR for removida, a decisão perde seu registro canônico; ADR existe para preservar histórico decisório, não para executar enforcement.",
			"Submeter ao founder para aprovação antes de commit (status 'proposed' default; 'accepted' válido no commit inicial APENAS se founder aprovou explicitamente a decisão antes deste commit; 'superseded' apenas se ADR já foi formalmente substituída por outro ID).",
		]
	}
}
