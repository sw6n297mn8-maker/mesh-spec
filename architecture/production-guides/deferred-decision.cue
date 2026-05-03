package production_guides

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// deferred-decision.cue — Production guide para deferimentos conscientes governados.
//
// Schema alvo: #DeferredDecision (architecture/artifact-schemas/deferred-decision.cue).
// Discriminated union por status: open → triggeredAt/resolvedBy/withdrawalRationale
// proibidos; triggered → triggeredAt+triggeredCondition obrigatórios; resolved →
// resolvedBy obrigatório; withdrawn → withdrawalRationale obrigatório.
//
// Cardinality collection (architecture/deferred-decisions/def-NNN-{slug}.cue).
// Phase 0 / Founder-validated: validação semântica de calibração de triggers
// e articulação de trade-off é judgment do founder; cue vet cobre apenas shape.

deferredDecisionGuide: artifact_schemas.#ProductionGuide & {

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/deferred-decision\\.cue$"
			fileNameRegex:      "^deferred-decision\\.cue$"
			description:        "Production guide para autoria de deferimentos conscientes governados em mesh-spec."
			rationale:          "Schema #DeferredDecision é instanciável (cardinality collection); tq-as-05 + sc-pg-01 (production-guide-coverage per adr-056) exigem PG. Cascade ordering precondition (adr-054 dec 13): PG existe ANTES de qualquer instância def-XXX."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-defg-01"
			description: "Guide força articulação de trade-off concreto, não 'fazer depois' (anti-procrastinação)"
			test:        "collectFromFounder explicita custo evitado, maturidade insuficiente identificada, ou caso concreto não materializado como inputs do founder; gapPolicy proíbe deferralRationale genérico ('fazer depois quando der tempo'); finalValidation step verifica tq-def-01. Reforço de guide-level sobre tq-def-01 do schema (já fail) — guide reitera porque procrastinação travestida é vetor primário de degradação."
			severity:    "fail"
			rationale:   "tq-def-01 do schema já é fail; guide reitera porque agentes/founder sob pressão tendem a 'preencher' deferralRationale com prose vaga para fechar registro sem articular trade-off real. Guide explicita anti-procrastinação no gapPolicy + collectFromFounder."
		}, {
			id:          "tq-defg-02"
			description: "Guide força calibração de triggers pelo founder (anti-default-baseline)"
			test:        "collectFromFounder explicita conditions de revisita como inputs do founder (não inferência); gapPolicy proíbe inferir triggers por similaridade com def-XXX existentes; finalValidation step verifica triggers conforme #Trigger discriminated union (tq-def-02 do schema)."
			severity:    "fail"
			rationale:   "Triggers genéricos derrotam o propósito de máquina automática — fire ou nunca-fire por calibração ruim torna sistema inútil. Pattern observado preventivamente: agentes podem inferir 'recurrence threshold=2' como default razoável para tudo. Guide bloqueia explicitamente forçando calibração por caso concreto."
		}, {
			id:          "tq-defg-03"
			description: "Guide força articulação do triggerCalibrationRationale (raciocínio sobre threshold/pattern)"
			test:        "Process da trigger-design exige declaração de POR QUE estes thresholds/patterns específicos — não só QUE são; gapPolicy explicita; finalValidation verifica que rationale articula calibração (não tautológico 'threshold=2 porque escolhemos 2')."
			severity:    "warn"
			rationale:   "Sem rationale do trigger, calibration revisitar fica impossível: founder futuro não sabe se threshold=2 foi conservadorismo deliberado ou default acidental. Warn (não fail) porque articulação substantiva é interpretativa — schema não pode enforcear."
		}, {
			id:          "tq-defg-04"
			description: "Guide força preferência por trigger automático sobre manual-review"
			test:        "collectFromFounder coleta triggers automáticos preferencialmente; manual-review SOMENTE quando founder explicita por que automação não é viável neste caso; finalValidation verifica tq-def-03 do schema."
			severity:    "warn"
			rationale:   "Manual-review trigger é escape valve; uso indiscriminado destrói automação. Guide reitera tq-def-03 do schema (warn) com captura de processo: founder articula caso onde manual-only é apropriado, não default."
		}]
		rationale: "4 critérios cobrem disciplinas centrais para autoria de def-XXX: trade-off articulado (tq-defg-01 fail hardening sobre tq-def-01), calibração founder de triggers (tq-defg-02 fail hardening), rationale de calibração (tq-defg-03 warn), preferência por automação (tq-defg-04 warn hardening sobre tq-def-03). 2 fail + 2 warn — proporção consistente com PG-ADR. tq-def-01..04 do schema cobrem instância autorada; tq-defg-XX cobrem PROCESSO de autoria — separação consistente com schema vs guide pattern."
	}

	prerequisites: {
		description: "Antes de autorar def-XXX, agente lê schema #DeferredDecision + arquitetura de triggers + 1-2 def-XXX existentes (se houver) como referência estrutural, e confirma com founder a decisão de deferir + custo + condições de revisita ANTES de iniciar redação. def-XXX documenta DECISÃO de deferir já tomada, não exploração."
		collectFromFounder: [
			"Decisão crystallizada de DEFERIR + alternativa de não-deferir considerada — se founder ainda está pensando, postergar autoria; def-XXX documenta deferimento decidido, não dúvida",
			"Origem do deferimento: artefato .cue (ADR/WI/tension-entry) OU sessão de chat (formato session:<slug>). Múltiplas origens permitidas",
			"Articulação concreta do trade-off: custo evitado por deferir AGORA vs custo de continuar deferindo. Frase 'fazer depois quando der tempo' falha tq-def-01 — agente NÃO aceita rationale genérico",
			"costOfDeferral.severity (low/medium/high) e blastRadius (local/cross-artifact/cross-cutting/repo-wide) — agente NÃO infere defaults; calibração é judgment do founder per governance proporcional",
			"Triggers codificados — pelo menos 1, com preferência por automáticos: recurrence (pattern + scope + threshold), adjacent-need (file-exists / file-contains), volume-threshold (artifactType + threshold), temporal (maxAgeDays — último recurso), manual-review (somente quando automação não é viável; reason articulado)",
			"triggerCalibrationRationale: POR QUE estes thresholds/patterns específicos — não inferência por similaridade com def-XXX existentes",
		]
		gapPolicy: "Se founder não tem decisão crystallizada de deferir (ainda pesando a alternativa), NÃO autore def-XXX — postergue até decisão estar tomada. NÃO aceite deferralRationale genérico ('fazer depois', 'quando der tempo', 'em sessão futura') — exija articulação de trade-off concreto: o que esta sessão escolhe fazer no lugar, e por que ESSE caminho vale mais agora. NÃO infira costOfDeferral por similaridade — severity e blastRadius são judgment do founder; combinações suspeitas (low+repo-wide; high+local) acionam pergunta direta ao founder. NÃO escolha triggers automáticos por default — confirme com founder qual condição concreta no repo sinalizaria momento de revisitar; pattern recurrence sem ancoragem em failure observado é fishing. NÃO use manual-review como default — só quando founder articular por que automação não é viável neste caso (e.g., decisão estratégica que só founder pode revisitar; condição não machine-evaluable). Para kind=temporal, exija rationale forte (calendário operacional, regulação datada, etc.) — temporal é último recurso. Quando founder não articular calibration rationale, pergunta direta antes de prosseguir; defaults inferidos quebram tq-defg-02 e tq-defg-03."
		validatorNote: "Em Phase 0, validação é (a) cue vet para shape — incluindo discriminated union sobre status (open inicial; auxiliary fields proibidos), e #Trigger union por kind, (b) founder review semântico — calibração de severity/blastRadius (tq-defg-02), articulação de calibration rationale (tq-defg-03), e legitimidade de manual-review se usado (tq-defg-04). Runner determinístico (scripts/ci/evaluate-deferred-triggers.sh, criado em commit 2 do bootstrap deferred-decision) avalia triggers a cada commit pós-instância — emite annotations sem mutar def-XXX."
		outputNote: "Output é arquivo único architecture/deferred-decisions/def-NNN-{slug}.cue conformante a #DeferredDecision com status=open. NNN é zero-padded sequencial sobre o último def-XXX existente (parte do mesmo namespace que adr-NNN — mas independente; def-001 é o primeiro). Slug em kebab-case (≤6 palavras tipicamente). Regex completo: '^def-[0-9]{3}-[a-z0-9-]+\\.cue$'. Tamanho típico: 60-150 linhas dependendo de número de triggers. Status inicial obrigatório 'open' — transições para 'triggered' ocorrem via runner (mas runner não muta arquivo; founder edita após revisar fire); transições para 'resolved'/'withdrawn' são edits humanos com fields obrigatórios (resolvedBy ou withdrawalRationale per discriminated union)."
	}

	workOrder: [
		"scaffold-and-origin",
		"substance-and-deferral-rationale",
		"trigger-design",
	]

	sections: {
		"scaffold-and-origin": {
			target:    "#DeferredDecision"
			objective: "Compor identity (id, title, date), origins (originatingArtifacts), e initial status=open. Esta section produz o envelope estrutural antes da redação substantiva."
			process: [{
				action: "Identificar próximo NNN sequencial"
				detail: "Listar architecture/deferred-decisions/ ordenado; próximo id é último_NNN + 1, zero-padded para 3 dígitos. Verificar inexistência de def-NNN para evitar colisão. Convenção interna: NNN é monotônico, não reusa números (def withdrawn/resolved mantêm número)."
			}, {
				action: "Compor slug kebab-case e title afirmativo"
				detail: "Slug deriva do que está sendo deferido (≤6 palavras tipicamente; a-z, 0-9, hífen). Title é afirmativo descrevendo O QUE é deferido + por quê referência ('Promote X to required (post-Y)'; 'Add kind Z to framework (pending recurrence)'). Title ≤80 runes recomendado."
			}, {
				action: "Declarar date no formato ISO YYYY-MM-DD"
				detail: "date é a data da sessão de autoria do def-XXX (não do deferimento informal precedente, embora frequentemente coincidam). Regex schema: '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'."
			}, {
				action: "Declarar originatingArtifacts como lista de #OriginRef"
				detail: "Pelo menos 1 origin. Cada origin é (a) path .cue de artefato formal (ADR/WI/tension-entry/etc) OU (b) 'session:<slug>' para decisão de chat. Múltiplas origins permitidas — frequente: ADR + session de chat onde decisão foi tomada. Agente NÃO inventa origins para preencher; lista o que founder identificou como context concreto."
			}, {
				action: "Declarar status='open' inicial"
				detail: "Status sempre 'open' no commit inicial do def-XXX. Transições para outros status (triggered/resolved/withdrawn) são edits POSTERIORES após eventos: triggered via runner output + revisão founder; resolved/withdrawn via decisão founder explícita com fields obrigatórios per discriminated union (resolvedBy ou withdrawalRationale)."
			}]
			sources: [
				"architecture/artifact-schemas/deferred-decision.cue (#DeferredDecision discriminated union, #OriginRef sub-type)",
				"architecture/deferred-decisions/ (def-XXX existentes — observar último NNN para sequência)",
			]
			heuristics: [
				"Title afirmativo descrevendo o que é deferido ('Promote X to required'; 'Add kind Y'); pergunta ('Should we Z?') é code smell — def-XXX documenta deferimento de algo já decidido a fazer eventually, não dúvida.",
				"Status sempre 'open' no commit inicial; transições posteriores não pertencem ao authoring inicial.",
				"originatingArtifacts: 1-3 origens é típico; mais de 3 pode indicar deferimento agregando trabalho disparate (considerar split em múltiplos def-XXX).",
			]
			doneCriteria: "id sequencial determinado e não-conflitante; title afirmativo ≤80 runes descrevendo o que é deferido; date ISO; originatingArtifacts com ≥1 #OriginRef válido (.cue path OU session:); status='open'."
			ifGap:        "Se NNN sequencial colide com def-XXX existente, escolher próximo livre. Se nenhum originatingArtifact identificável (nem ADR/WI nem sessão), questionar: a decisão de deferir foi realmente tomada formalmente? Se não, postergar autoria."
		}

		"substance-and-deferral-rationale": {
			target:    "#DeferredDecision"
			objective: "Compor description (o que está sendo deferido — afirmativo e específico), deferralRationale (POR QUE deferir agora — articulação de trade-off concreto), e costOfDeferral (severity + blastRadius + description articulada)."
			process: [{
				action: "Compor description afirmativa do que é deferido"
				detail: "description responde 'O QUE está sendo deferido?' — frase ou pequeno parágrafo afirmativo, específico ao caso. MinRunes(50) garante extensão; substantividade é interpretativa. Refs concretas a artefatos/conceitos do repo (não 'feature X' genérico). Padrão: 'Promover plannedOutputs de optional para required no #ADR schema, com backfill de 22 ADRs e ADR final de closure C3 Part 4.'"
			}, {
				action: "Compor deferralRationale articulando trade-off concreto"
				detail: "deferralRationale responde 'POR QUE deferir AGORA?' — articulação de (a) custo evitado por deferir (e.g., 'cerimônia sem enforcement real'), (b) maturidade insuficiente identificada (e.g., 'system de tracking não existe ainda'), OU (c) caso concreto ainda não materializado (e.g., 'esperar segundo caso de uso'). MinRunes(100) força extensão. NÃO aceita 'fazer depois quando der tempo' ou equivalente — falha tq-def-01 e tq-defg-01."
			}, {
				action: "Calibrar costOfDeferral (severity + blastRadius)"
				detail: "severity ∈ {low, medium, high}: low = pode deferir indefinidamente sem dano (convenção voluntária supre); medium = pode deferir por tempo limitado (semanas-meses) sem dano cumulativo; high = deferir cria custo cumulativo ou bloqueia caminho crítico. blastRadius ∈ {local, cross-artifact, cross-cutting, repo-wide}: mesmo enum de #ADR. Calibração founder; agente NÃO infere por similaridade. Combinações suspeitas (low+repo-wide; high+local) acionam pergunta direta — falham tq-defg-04 advisory."
			}, {
				action: "Compor costOfDeferral.description articulada"
				detail: "MinRunes(50). Articula CONCRETAMENTE o que custa continuar deferindo — não genérico ('algum custo'). Coerente com severity declarada (severity=low + description 'bloqueia migration crítica' é descasamento)."
			}, {
				action: "Verificar tq-def-01 (deferralRationale articulado)"
				detail: "Test: substituir o tópico do deferimento por 'qualquer outro tópico' no deferralRationale. Se texto continua válido, está genérico — falta ancoragem em mecanismos específicos do caso. Reescrever com refs concretas a artefatos/decisões/contextos."
			}]
			sources: [
				"architecture/artifact-schemas/deferred-decision.cue _qualityCriteria (tq-def-01 trade-off, tq-def-04 cost coherence)",
				"architecture/deferred-decisions/ (def-XXX existentes para comparar tom de articulação)",
				"governance/build-time/quality-gate.cue (uq-02 specificity test análogo)",
			]
			heuristics: [
				"deferralRationale fala do PORQUÊ AGORA — não history geral do tópico; trigger é o que a session escolheu fazer no lugar deste deferimento.",
				"costOfDeferral.description: específica observável > genérica. 'Drift entre 22 ADRs migradas e antigas continua aceitável durante period N' > 'algum drift'.",
				"severity-blastRadius coherence: low+repo-wide é improvável (escopo amplo com custo baixo) — questionar se severity está calibrada ou blastRadius generalizado demais. high+local também improvável.",
				"Specificity test (tq-def-01): substituir tópico do deferimento por outro tópico genérico — se rationale ainda faz sentido, está abstrato demais.",
				"description vs deferralRationale: description é O QUE; deferralRationale é POR QUÊ. Não duplicar.",
			]
			doneCriteria: "description ≥50 runes específica ao caso (substituição-genérica falha); deferralRationale ≥100 runes articulando trade-off concreto (custo evitado vs custo de continuar); costOfDeferral.severity + blastRadius calibrados pelo founder; costOfDeferral.description ≥50 runes articulada e coerente com severity; tq-def-01 satisfeito (specificity test)."
			ifGap:        "Se founder não articular trade-off concreto, pergunta direta antes de prosseguir — placeholder genérico falha tq-def-01. Se costOfDeferral severity não está calibrada, NÃO usar default 'medium' — perguntar. Se severity-blastRadius combinação parece suspeita, questionar founder antes de aceitar (e.g., 'low + repo-wide é incomum — confirma severidade ou blast radius?')."
		}

		"trigger-design": {
			target:    "#DeferredDecision"
			objective: "Compor triggers (condições codificadas de revisita) com triggerCalibrationRationale (POR QUE estes thresholds/patterns). Esta é a section mais consequente — triggers determinam se sistema funciona como máquina automática ou vira backlog inerte."
			process: [{
				action: "Identificar trigger kinds aplicáveis ao caso concreto"
				detail: "Kinds disponíveis: recurrence (padrão observado N+ vezes), adjacent-need (file-exists/file-contains), volume-threshold (count de tipo cruza limiar), temporal (último recurso), manual-review (escape — exige reason articulado). Founder identifica QUAL condição concreta no repo sinalizaria momento de revisitar este deferimento — agente NÃO infere por similaridade."
			}, {
				action: "Calibrar parâmetros de cada trigger"
				detail: "recurrence: pattern (regex), scope (filename/file-content/commit-message), threshold ≥2. adjacent-need: condition kind (file-exists ou file-contains) + path + (pattern para file-contains). volume-threshold: artifactType + threshold ≥1. temporal: maxAgeDays ≥1 — exige rationale forte (calendário operacional, regulação datada). manual-review: reason ≥40 runes articulando por que automação não é viável."
			}, {
				action: "Preferir triggers automáticos sobre manual-review"
				detail: "Pelo menos 1 trigger non-manual-review é warning (tq-def-03). Manual-review sem trigger automático adicional só é apropriado em casos específicos (decisão estratégica que só founder revisita; condição não machine-evaluable). Founder articula por que automação não viável NESTE caso, não default."
			}, {
				action: "Compor triggerCalibrationRationale articulando escolhas"
				detail: "MinRunes(50). Articula POR QUE estes thresholds/patterns específicos — não tautológico ('threshold=2 porque escolhemos 2'). Pattern: 'recurrence threshold=2 conservador para evitar false positives durante calibration period; adjacent-need.file-exists em path X é sinal forte porque criação desse arquivo indica que kind Y agora existe.' Calibração revisitar fica impossível sem este rationale."
			}, {
				action: "Verificar tq-def-02 (triggers codificados, não prose)"
				detail: "Cada trigger conforma com #Trigger discriminated union — kind explícito + params machine-evaluable. Schema enforce; este check é interpretativo para detectar bypass (e.g., manual-review com reason que descreve condição machine-evaluable disfarçada)."
			}, {
				action: "Verificar tq-def-03 (≥1 non-manual-review OR justified manual-only)"
				detail: "Se todos triggers são manual-review: deferralRationale OR triggerCalibrationRationale articula EXPLICITAMENTE por que automação não viável. Caso contrário, falha tq-def-03 advisory."
			}]
			sources: [
				"architecture/artifact-schemas/deferred-decision.cue (#Trigger discriminated union, sub-types #RecurrenceScope, #AdjacentCondition)",
				"architecture/deferred-decisions/ (def-XXX existentes — observar patterns de calibração)",
				"governance/build-time/quality-gate.cue (uq-02 specificity)",
			]
			heuristics: [
				"recurrence threshold=2 é mínimo (schema enforça); 3-5 é faixa típica conservadora durante calibration period.",
				"adjacent-need.file-exists é mais forte que file-contains (presença/ausência é binária; pattern em file pode mudar prose).",
				"volume-threshold útil para escalation: deferir até count de tipo cruza limiar (e.g., 'add structural-check kind quando 3+ casos concretos materializarem').",
				"temporal último recurso: exige rationale forte. Se calendário ou regulação não driva, repensar — quase sempre há trigger melhor.",
				"manual-review escape valve: reason ≥40 runes articulando por que automação não viável NESTE caso.",
				"Multi-trigger é aceitável (qualquer trigger fired → status=triggered): permite redundância se condições concorrentes podem disparar.",
				"triggerCalibrationRationale: substituir threshold/pattern por outro valor — se rationale ainda faz sentido, é tautológico (falha tq-defg-03).",
				"Tensão com axiomas: triggers raramente tensionam axiomas; se algum trigger contradiz princípio, declarar [TENSÃO: ax-XX] no triggerCalibrationRationale + tension-log entry separado.",
				"recurrence pattern self-match (lição surfaced WI-069 first dispatch): pattern stored como string em CUE pode auto-encontrar via grep do runner em (a) regex literal characters quando wildcard '.{0,N}' inclui ')' '.' '{' '}' presentes na própria declaração; mitigação: substituir '.{0,N}' por char class restritivo (e.g., '[a-z ]{0,N}') que NÃO casa com regex literals.",
				"recurrence prose example self-match (lição corolário): exemplos prose de demanda dentro do próprio def-XXX/SRR (e.g., 'needs <kind-name> check' como ilustração) também self-match porque são gramaticalmente válidos como demand framing; mitigação: usar placeholder literal com chars não-letras (e.g., '<kind-name>' contém '<' fora de [a-z ]) em exemplos prose.",
			]
			doneCriteria: "triggers list contém ≥1 trigger conformante a #Trigger union; triggerCalibrationRationale ≥50 runes articulando POR QUE thresholds/patterns; tq-def-02 satisfeito (todos triggers codificados); tq-def-03 satisfeito (≥1 non-manual-review OR justified manual-only); tq-defg-03 satisfeito (calibration rationale articulado, não tautológico)."
			ifGap:        "Se founder não identifica trigger automático aplicável, perguntar: que condição concreta no repo sinalizaria 'hora de revisitar este deferimento'? Se realmente nenhuma → manual-review com reason articulando por que automação não viável. Se threshold/pattern não está calibrado, sugerir conservador (alto threshold, pattern narrow) — refinar via amendment se calibration error detectada depois."
		}
	}

	finalValidation: {
		reconciliation: {
			description: "Antes de submeter ao founder, agente reconcilia 3 pares para detectar desalinhamento entre seções."
			pairs: [
				"description (o que é deferido) vs originatingArtifacts (onde nasceu o deferimento) — origins devem ser rastreáveis ao topic da description",
				"deferralRationale (por que deferir) vs costOfDeferral.severity — severity deve ser coerente com custo articulado em rationale (e.g., severity=low NÃO casa com rationale 'bloqueia critical path')",
				"triggers (condições de revisita) vs deferralRationale (motivo de deferir) — triggers devem fazer sentido como signals de que o motivo de deferir não vale mais (e.g., se rationale = 'esperar enforcement real', trigger should detect enforcement materialização)",
			]
		}
		steps: [
			"Verificar shape via cue vet — discriminated union sobre status (open inicial; triggeredAt/triggeredCondition/resolvedBy/withdrawalRationale proibidos), #Trigger union por kind, #OriginRef union (path .cue ou session:)",
			"Verificar tq-def-01 (deferralRationale articulado, não 'fazer depois')",
			"Verificar tq-def-02 (triggers codificados, não prose)",
			"Verificar tq-def-03 (≥1 non-manual-review OR justified manual-only)",
			"Verificar tq-def-04 (severity + blastRadius coherent com description)",
			"Verificar tq-defg-01..04 (process-level discipline aplicada)",
			"Submeter ao founder com 1-line summary: 'def-NNN: <title>; status=open; triggers=[<kinds>]'",
		]
	}
}
