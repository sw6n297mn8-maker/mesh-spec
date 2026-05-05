package production_guides

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// task-spec.cue — Production guide para Task Spec (work-item authoring).
//
// Schema alvo: #TaskSpec (governance/build-time/work-governance.cue:192).
// Diferentemente dos demais PGs (que cobrem schemas em architecture/
// artifact-schemas/), este cobre schema interno de governance/. Extensão
// interpretativa de adr-053 (universal PG coverage) para schemas de
// governança operacional — sem decisão arquitetural nova, apenas
// estendendo o spirit do ADR para schemas que vivem em governance/.
// task-specs governam execução de work-items e merecem disciplina de
// autoria explícita após inventário de 70 instâncias.
//
// Authoring manual Phase 0 (sem registro em authoring-policy.cue rollout
// porque task-specs são raros e governados por founder approval direto).
//
// Convenção: tq-tsg-NN para critérios deste guide. Abreviação "tsg"
// (task-spec-guide) — paralelo a dmg/agg/gvg para PGs de outros tipos.
// Legend atualizada em architecture/artifact-schemas/quality-criteria.cue
// no mesmo commit.
//
// Authoring revelou disciplinas core a capturar: ID unicidade + WI-NNN
// regex; templateRef apontando para template existente em ai-orchestration/
// agent-instructions/task-templates.cue; outputs concretos (artifact +
// type create/update/validate); semanticPrerequisites verificáveis
// (paths reais ou seções identificáveis); rationale substantivo (não
// repetição do title); affects vs outputs sem duplicação; work-events
// stream com task-proposed event criado pareado com task-spec; cross-task
// deps declaradas em work-graph quando existirem.

taskSpecGuide: artifact_schemas.#ProductionGuide & {

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/task-spec\\.cue$"
			fileNameRegex:      "^task-spec\\.cue$"
			description:        "Production guide para autoria de Task Spec (work-item) em mesh-spec governance."
			rationale:          "Task spec governa execução de work-items: define WHAT (outputs + prerequisites + rationale) consumido por agente para executar; templateRef + work-events lifecycle separados. Guide explicita process, gapPolicy e heuristics que o schema sozinho não documenta. Extensão interpretativa de adr-053 (sem decisão arquitetural nova) para schemas de governança operacional pós-inventário de 70 task-specs ativos."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-tsg-01"
			description: "Guide enforça ID unicidade + WI-NNN regex"
			test:        "Process da section id-template-and-outputs declara passo explícito de validar: id segue regex ^WI-[0-9]{3}$; ID não conflita com task-specs existentes em governance/build-time/task-specs/wi-*.cue (constraint do _constraints.cue mapeia chave→id). Verificado por inspeção da numeração + cue vet (constraint enforce unicidade automática)."
			severity:    "fail"
			rationale:   "ID duplicado quebra constraint do _constraints.cue (taskSpecs[ID]: ... & {id: ID}) — cue vet bloqueia. ID fora do regex (e.g., WI-1, WI-XXXX) viola contrato schema. Próximo ID disponível derivável por scan de ls task-specs/."
		}, {
			id:          "tq-tsg-02"
			description: "Guide enforça templateRef apontando para template existente"
			test:        "Process da section id-template-and-outputs declara passo de validar: templateRef segue regex ^tmpl-[a-z][a-z0-9-]*@v[0-9]+$; templateRef sem @vN é truncado e bloqueia cue vet; template ID base (sem @vN) existe em ai-orchestration/agent-instructions/task-templates.cue. 5 templates canônicos: tmpl-create-instance, tmpl-create-schema, tmpl-validate-artifact, tmpl-create-script, tmpl-create-convention."
			severity:    "fail"
			rationale:   "templateRef inválido aciona cue vet fail por regex. templateRef apontando para template inexistente em task-templates.cue é configuração fantasma — agente não consegue resolver protocolo de execução. task-governance.cue rules são por templateRef; mismatch quebra elegibilidade."
		}, {
			id:          "tq-tsg-03"
			description: "Guide enforça outputs concretos com artifact + type"
			test:        "Process da section id-template-and-outputs declara passo de validar: cada outputs[] tem artifact (path canônico não-vazio) + type (∈ create/update/validate). outputs vazio aceitável apenas para pure-validation, com rationale explicando alvo validado; affects recomendado quando houver superfície indireta. outputs com path vago ('contexts/.../algo.cue') ou type fora do enum são bloqueados. Para tasks de bootstrap BC, outputs incluem todos artifacts esperados (canvas + glossary + domain-model + agent-spec + governance per ordem canônica)."
			severity:    "fail"
			rationale:   "Outputs declaram contrato de produção da task — sem artifact concreto, completion validation não tem alvo verificável. Empirical bootstrap pattern: WI-060 SSC declara 5 outputs (canvas/glossary/domain-model/agent-spec/governance.cue) — validation gate aceita task-completed somente quando todos existem."
		}, {
			id:          "tq-tsg-04"
			description: "Guide enforça work-events stream com task-proposed event pareado"
			test:        "Process da section lifecycle-and-validation declara passo de criar governance/build-time/work-events/wi-NNN.cue com streams[WI-NNN].events[0] = task-proposed event (commandId WI-NNN-propose-*, timestamp, actor=spec-writer ou founder). task-spec sem work-events stream correspondente é admission-undefined (#AdmissionState='defined' default; nunca aparece em ready-queue). Para bootstrap pattern empirical: stream cria proposed → approved → claimed → completed sequence."
			severity:    "fail"
			rationale:   "Sem work-events stream, task-spec é decoração — nunca entra em backlog admission, nunca é claimable, nunca executa. Pareamento task-spec + work-events é fundação do sistema de execução. Empirical: 70 task-specs atuais todos têm streams correspondentes."
		}, {
			id:          "tq-tsg-05"
			description: "Guide enforça semanticPrerequisites verificáveis"
			test:        "Heuristics da section prerequisites-and-rationale exige: cada semanticPrerequisites[] item aponta para path real (file existe ou será criado pelos outputs de upstream task) OR seção identificável (regex 'caminho/arquivo.cue — descrição'). Prerequisites vagos ('contexto geral do projeto', 'leitura de princípios') falham — reescrever como path concreto OR seção específica. Lista vazia tolerada para tasks foundationais sem upstream semântico."
			severity:    "warn"
			rationale:   "semanticPrerequisites informam agente o QUE LER antes de executar. Prerequisites vagos viram ritual sem substância. Empirical pattern: 'strategic/context-map.cue — XXX governa Y; publica Z para A; consome B de C' (apontamento + role) é o formato canônico que empirical bootstrap usa."
		}, {
			id:          "tq-tsg-06"
			description: "Guide enforça affects sem duplicação de outputs"
			test:        "Heuristics da section prerequisites-and-rationale declara: affects[] lista superfície semântica/operacional impactada além dos outputs diretos (e.g., context-map se task altera relações; ready-queue se task altera priorização; ADR superseded se task substitui decisão prévia). NÃO repetir outputs[*].artifact. Lista vazia tolerada quando task impacta apenas seus próprios outputs."
			severity:    "warn"
			rationale:   "Affects duplicando outputs polui a leitura — outputs já declaram superfície direta. Affects existe para capturar impacto INDIRETO (cross-file, cross-decision). Empirical: tasks de bootstrap raramente têm affects (impacto contained); tasks de schema-change frequentemente têm affects (superseding ADR + contexts dependentes)."
		}, {
			id:          "tq-tsg-07"
			description: "Guide enforça rationale substantivo (não repetição do title)"
			test:        "Heuristics da section prerequisites-and-rationale exige: rationale explica POR QUE a task existe + ordem de produção quando aplicável + classificação operacional (criticality, BC role, deps cross-BC). Rationale como 'Criar artefatos X' (repetição do title) falha — substituir por contexto estratégico (e.g., 'Bootstrap completo do BC supporting SSC. Ordem de produção: canvas → glossary → ... Supporting domain — governa seleção estratégica de fornecedores; publica decisões para P2P e CTR; consome qualificação de NPM. Criticality medium — sourcing estratégico é operacional, sem boundary regulatório direto.')."
			severity:    "warn"
			rationale:   "Rationale repetindo title é text-shaped emptiness. Rationale substantivo permite founder review pular contexto + agente entender prioridade durante execução. Empirical pattern bootstrap: 3-5 sentences cobrindo ordem + role + criticality + caveats."
		}, {
			id:          "tq-tsg-08"
			description: "Guide enforça cross-task dependencies declaradas em work-graph quando existirem"
			test:        "Process da section lifecycle-and-validation declara passo de adicionar entry em workGraph.executionDependencies (governance/build-time/work-graph.cue) quando task tem dependências cross-task (semantic OU schema). Pattern: #ExecutionDependency com taskId + dependsOn[] (lista de {taskId, version}) + phaseId + groupId. Task sem entry em work-graph é assumida sem dependências (não bloqueia ready-queue)."
			severity:    "warn"
			rationale:   "Dependências não-declaradas viram race conditions silenciosas: task pode ser claimed antes de seus prerequisites estarem completos, resultando em retrabalho ou bloqueio durante execução. Empirical: WI-043 FCE declara dependsOn WI-046 + WI-053 + WI-062 — sem isso seria claimable prematuramente."
		}]
		rationale: "8 critérios cobrem disciplinas core para autoria de task-spec: ID + regex (tq-tsg-01), templateRef válido (tq-tsg-02), outputs concretos (tq-tsg-03), work-events pareamento (tq-tsg-04), semanticPrerequisites verificáveis (tq-tsg-05), affects sem duplicação (tq-tsg-06), rationale substantivo (tq-tsg-07), cross-task deps em work-graph (tq-tsg-08). Critérios 01-04 são fail (estruturais — bloqueiam cue vet ou tornam task inexequível); 05-08 são warn (semânticos — degradam qualidade mas não bloqueiam). Empirical: 70 task-specs ativos seguem majoritariamente esse padrão; gaps recorrentes nos 4 warn (especialmente tq-tsg-05/07) detectados em revisão pós-WI-060."
	}

	prerequisites: {
		description: "Antes de criar task-spec, agente lê schema #TaskSpec (work-governance.cue:192) + 5 task templates (ai-orchestration/agent-instructions/task-templates.cue) + 3-5 task-specs exemplares no mesmo template family. Confirmar com founder o ID alvo (próximo disponível via ls task-specs/) e templateRef apropriado."
		collectFromFounder: [
			"ID alvo (formato WI-NNN; próximo disponível derivado de ls task-specs/) — founder confirma reuso de número aposentado vs próximo livre",
			"templateRef + version (canônicos: tmpl-create-instance@v1 para autoria de instância de schema; tmpl-create-schema@v1 para criação de schema; tmpl-validate-artifact@v1 para validação; tmpl-create-script@v1 para scripts; tmpl-create-convention@v1 para convenções)",
			"Outputs esperados (lista de artifacts + type create/update/validate) — para bootstrap BC: ordem canônica canvas → glossary → domain-model → agent-spec → governance",
			"Cross-task dependencies (semantic OR schema) que devem entrar em work-graph executionDependencies — heurística: BC bootstrap depende de WI-009/011/020/021/022/028 + assimetric inter-BC quando consume signal específico",
			"Criticality default vem do template (task-governance.cue) — override por task se diverge materialmente; nesta fase: zero overrides per task-governance.cue declaração",
		]
		gapPolicy:     "Se ID conflita com task-spec existente, escolher próximo disponível ou (raro) revisar task-spec existente. Se templateRef aponta para template inexistente em task-templates.cue, criar template primeiro (separate WI) — task-spec fica blocked. Se outputs lista artifacts cuja localização canonicalPathRegex não está definida em schema, declarar e validar pós-creation. NÃO criar task-spec sem work-events stream pareado — task fica admission-undefined e nunca entra em backlog. NÃO declarar criticality override sem rationale documentando divergência material do template. NÃO inventar templates novos sem aprovação founder — cardinalidade de templates é deliberadamente baixa (5 atuais) para evitar fragmentação."
		validatorNote: "Em Phase 0, founder review é obrigatório. WI-068 (pendente) cria structural-checks para task-spec — quando completar, tq-tsg-01/02/03 automatizam-se. tq-tsg-04 (pareamento work-events) requer cross-file check. tq-tsg-05/06/07 são warn semântico — inspeção visual permanece relevante. tq-tsg-08 (work-graph) requer cross-file check + análise semântica de deps."
		outputNote:    "Output é arquivo único governance/build-time/task-specs/wi-NNN.cue conformante a #TaskSpec. Tamanho típico: 25-45 linhas (per wi-060.cue 39 linhas, wi-043.cue ~30 linhas). Task-spec inicial declara version=1; updates incrementais via supersession (task-superseded event + nova task-spec com version=N+1)."
	}

	workOrder: [
		"id-template-and-outputs",
		"prerequisites-and-rationale",
		"lifecycle-and-validation",
	]

	sections: {
		"id-template-and-outputs": {
			target:    "#TaskSpec"
			objective: "Estabelecer ID único + templateRef válido + outputs concretos como esqueleto da task-spec antes de prosseguir para conteúdo semântico."
			process: [{
				action: "Determinar próximo ID WI-NNN disponível"
				detail: "ls governance/build-time/task-specs/wi-*.cue | sort -V | tail -1 → próximo número. Verificar gaps numerados (e.g., WI-040 cancelled liberou ID — reuso permitido apenas se founder confirma rastreabilidade preservada). ID segue regex ^WI-[0-9]{3}$ (3 dígitos zero-padded)."
			}, {
				action: "Selecionar templateRef apropriado"
				detail: "Mapping canônico: tmpl-create-instance@v1 (criar instância de schema, e.g., canvas/domain-model/agent-spec); tmpl-create-schema@v1 (criar novo schema em artifact-schemas/); tmpl-validate-artifact@v1 (revisar artefato existente); tmpl-create-script@v1 (criar script bash/CI); tmpl-create-convention@v1 (criar convenção de naming/structure). 5 templates atuais; novos exigem aprovação founder + edição de task-templates.cue."
			}, {
				action: "Declarar outputs concretos com artifact + type"
				detail: "Cada outputs[] = {artifact: path-canonical, type: create|update|validate}. Para bootstrap BC: 5 outputs com type=create (canvas + glossary + domain-model + agent-spec + governance.cue). Para schema-change: outputs com type=update + create combinados. Para validation-only task: outputs vazio aceitável quando rationale explica alvo validado + affects recomendado quando há superfície indireta."
			}, {
				action: "Confirmar esqueleto com founder antes de prosseguir"
				detail: "Apresentar header completo: id + version + title + templateRef + outputs. Founder filtra: ID disponível confirmado; templateRef apropriado; outputs cobrindo todo escopo da task. Compor esqueleto confirmado antes de section 2."
			}]
			sources: [
				"governance/build-time/work-governance.cue (#TaskSpec schema, line 192)",
				"governance/build-time/task-specs/_constraints.cue (mapa indexado por ID + chave-id constraint)",
				"ai-orchestration/agent-instructions/task-templates.cue (5 templates canônicos)",
				"governance/build-time/task-specs/wi-060.cue (exemplar bootstrap BC, 39 linhas)",
				"governance/build-time/task-specs/wi-043.cue (exemplar bootstrap BC com cross-BC deps)",
				"governance/build-time/task-specs/wi-068.cue (exemplar create-instance multi-output)",
			]
			heuristics: [
				"ID monotônico crescente é norma — reuso de IDs aposentados (cancelled/superseded) raro e exige rastreabilidade explícita.",
				"templateRef tem version (@vN) obrigatório — sem version, regex falha. Bumping version requer atualizar task-templates.cue + migration plan para task-specs antigas.",
				"5 templates canônicos cobrem 95% dos casos — novos templates exigem aprovação founder + ADR.",
				"Bootstrap BC pattern: 5 outputs canônicos (canvas + glossary + domain-model + agent-spec + governance) + criticality medium per task-governance.cue.",
				"Schema-change pattern: 1-2 outputs (schema + downstream artifacts impactados) + criticality high.",
				"Validation-only pattern: outputs vazio + rationale explicando alvo validado + affects recomendado quando houver superfície indireta.",
				"Próximo ID disponível derivável programaticamente: highest existing ID + 1; founder confirma para evitar conflito com proposta paralela.",
			]
			doneCriteria: "ID validado contra regex + unicidade; templateRef apontando para template existente em task-templates.cue; outputs concretos com artifact + type declarados (ou vazio justificado para pure-validation); founder aprovou esqueleto antes de proceder à section 2."
			ifGap:        "Se ID conflita, escolher próximo livre. Se templateRef inválido (regex fail), corrigir para formato @vN. Se templateRef aponta para template inexistente, criar template primeiro (separate WI) ou usar template existente. Se outputs vagos (path com '...'), substituir por path canônico do schema location. Se task tem outputs em locations sem canonicalPathRegex declarado, escalar founder."
		}

		"prerequisites-and-rationale": {
			target:    "#TaskSpec"
			objective: "Popular semanticPrerequisites verificáveis + affects sem duplicação + rationale substantivo capturando contexto estratégico da task."
			process: [{
				action: "Listar semanticPrerequisites verificáveis"
				detail: "Cada item: 'caminho/arquivo.cue — descrição da role/contexto' OR 'seção X de arquivo Y — aspecto Z'. Para bootstrap BC: 1-3 items apontando para context-map (relação BC + papéis upstream/downstream) + canvas/domain-model upstream se há acoplamento semântico forte. Pattern empirical: 'strategic/context-map.cue — SSC governa seleção estratégica; publica decisões para P2P e CTR; consome qualificação de NPM' (apontamento + 3 roles)."
			}, {
				action: "Declarar affects (superfície indireta)"
				detail: "affects[] lista impacto INDIRETO além de outputs[*].artifact. Empirical: bootstrap BC raramente tem affects (impacto contained nos contexts/{bc}/); schema-change frequentemente tem affects (downstream contexts impactados, ADR superseded, ready-queue rebalanceada). NÃO duplicar outputs."
			}, {
				action: "Compor rationale substantivo"
				detail: "Rationale 3-5 sentences cobrindo: (a) tipo de task (bootstrap/schema-change/validation/script/convention); (b) ordem de produção quando aplicável (e.g., canvas → glossary → ...); (c) classificação operacional (criticality + BC role + acoplamento cross-BC); (d) caveats (Phase 0 limitations, deps pendentes, decisão de criticality). Pattern empirical: WI-060 rationale 4 sentences cobrindo bootstrap + ordem + supporting domain + criticality medium justification."
			}, {
				action: "Confirmar conteúdo semântico com founder antes de section 3"
				detail: "Apresentar prerequisites + affects + rationale. Founder filtra: prerequisites vagos (substituir por path concreto); affects duplicando outputs (remover); rationale repetindo title (substituir por contexto)."
			}]
			sources: [
				"governance/build-time/work-governance.cue (#TaskSpec field semantics)",
				"governance/build-time/task-specs/wi-060.cue (rationale 4-sentence bootstrap pattern)",
				"governance/build-time/task-specs/wi-068.cue (multi-output rationale + affects pattern)",
				"strategic/context-map.cue (fonte de truth para BC roles em prerequisites bootstrap)",
			]
			heuristics: [
				"semanticPrerequisites apontam para LEITURA (contexto antes de executar), não DEPENDÊNCIA (que vai em work-graph). Confundir os dois polui ambos.",
				"Pattern bootstrap BC: 1-3 prerequisites cobrindo (a) context-map para relação BC; (b) upstream BC domain-model se há acoplamento de signals; (c) lens aplicável se domínio tem padrão analítico forte.",
				"affects vs outputs: outputs = produção direta; affects = superfície indireta. 'contexts/{bc}/' em outputs cobre TODOS arquivos do BC produzidos pela task; affects para context-map (relações) ou ready-queue (priorização) só quando task altera explicitamente esses arquivos.",
				"rationale substantivo é precondição de execução: agente lê primeiro para calibrar abordagem (criticality high → review intensivo; medium → padrão; low → leve). Title é resumo; rationale é contexto.",
				"Caveats no rationale = Phase 0 deferred + cross-BC deps pendentes + decisão de criticality fora do default. Capturar reduz ambiguidade durante claim.",
				"Para tasks de validation: rationale articula CRITÉRIOS de validação (não 'validar X' tautológico) — 'validar consistency entre canvas SSC e domain-model SSC pós-iteração; verificar cobertura tq-dm-XX por inspeção'.",
			]
			doneCriteria: "semanticPrerequisites apontando para paths reais ou seções identificáveis; affects sem duplicação de outputs (ou vazio justificado); rationale substantivo cobrindo tipo + ordem + classificação + caveats; founder aprovou conteúdo antes de proceder à section 3."
			ifGap:        "Se prerequisite vago, reescrever como path concreto. Se affects duplica outputs, remover entries duplicadas. Se rationale repete title, expandir com contexto estratégico ou marcar task para revisitar tarde. Se task tem deps cross-BC mas semanticPrerequisites não captura (porque deps vão em work-graph), adicionar leitura do upstream domain-model em prerequisites + entry em work-graph."
		}

		"lifecycle-and-validation": {
			target:    "#TaskSpec"
			objective: "Criar work-events stream pareado + work-graph entry se aplicável + cue vet final + submissão founder para approval (task-approved event registrado APÓS approval explícita, nunca no mesmo commit do propor)."
			process: [{
				action: "Criar work-events stream com task-proposed event"
				detail: "Criar governance/build-time/work-events/wi-NNN.cue com streams[WI-NNN].events[0] = task-proposed (commandId WI-NNN-propose-X, timestamp UTC, actor=spec-writer ou founder). Sem stream, task-spec fica admission-undefined e nunca entra em ready-queue."
			}, {
				action: "Adicionar work-graph entry se task tem cross-task deps"
				detail: "Em governance/build-time/work-graph.cue, adicionar #ExecutionDependency & {taskId: WI-NNN, dependsOn: [{taskId: WI-XXX, version: 1}, ...], phaseId: pN-XXX, groupId: gN-XXX}. Bootstrap BCs tipicamente dependem de WI-009/011/020/021/022/028 + assimétricas inter-BC (e.g., FCE depende de REW + INV + BKR). Tasks foundationais (sem deps) não exigem entry."
			}, {
				action: "Adicionar task-governance override se criticality diverge do template"
				detail: "Em governance/build-time/task-governance.cue, adicionar entry com scope=task, taskId=WI-NNN, criticality=X. Override só justificado quando criticality diverge MATERIALMENTE do template default. Phase 0 atual: zero overrides — sempre seguir template default."
			}, {
				action: "cue vet ./governance/build-time/ recursive"
				detail: "Validação final: schema #TaskSpec satisfeito (id regex + templateRef regex + outputs estrutura); _constraints.cue chave=id satisfeito (cue vet enforce automático); work-events stream existe; work-graph entry consistente se aplicável. Falha bloqueia avanço."
			}, {
				action: "Submeter ao founder para approval (NÃO adicionar task-approved event ainda)"
				detail: "Após founder approval explícito EM MENSAGEM SEPARADA OU DECISÃO REGISTRADA (nunca proposto + aprovado em mesmo commit / mesma mensagem do agente — guard contra auto-approval), adicionar task-approved event ao work-events stream em commit posterior (eventType=task-approved, commandId=WI-NNN-approve-X, actor=founder, timestamp do momento da approval). Sem approval explícito, task-spec permanece admission=proposed (não claimable). Esta separação preserva audit trail de governance + P10 (founder é única autoridade de approval)."
			}]
			sources: [
				"governance/build-time/work-governance.cue (#EventType, #ExecutionDependency, #TaskGovernanceRule)",
				"governance/build-time/work-events/wi-060.cue (exemplar stream completo: proposed → approved → claimed → completed)",
				"governance/build-time/work-graph.cue (executionDependencies pattern com BC bootstrap WIs)",
				"governance/build-time/task-governance.cue (template-level rules; zero task-level overrides Phase 0)",
				"governance/build-time/projections/ready-queue.cue (projection derivada — atualizada quando task entra/sai)",
			]
			heuristics: [
				"task-proposed event timestamp = momento da criação real; spec-writer comum quando agente propõe; founder quando founder propõe diretamente.",
				"task-approved event vem APÓS founder approval explícito em mensagem separada ou decisão registrada — NUNCA proposto + aprovado em mesmo commit / mesma turn do agente (audit trail de governance + guard contra auto-approval por agente).",
				"work-graph entry obrigatório quando task depende de outra task; sem entry, task assumida sem deps e pode ser claimed prematuramente.",
				"Bootstrap BC standard deps: WI-009 (canvas schema), WI-011 (glossary schema), WI-020 (domain-model schema), WI-021 (agent-spec schema), WI-022 (agent-governance schema), WI-028 (validation prompts). Inter-BC deps quando há signal cross-BC (e.g., FCE depende de INV).",
				"phaseId/groupId derivados do tipo de task: bootstrap BC vai em p5-bc-domain-bootstrap + g7-core-bc-bootstrap (core) ou g8-supporting-bc-bootstrap (supporting).",
				"task-governance override: zero atual em Phase 0. Candidato futuro: tasks foundationais com blast radius superior à média (e.g., WI-001 domain-definition).",
				"cue vet recursive antes de submissão founder; sintaxe inválida nunca chega à revisão.",
			]
			doneCriteria: "work-events stream criado com task-proposed event; work-graph entry adicionada se task tem deps; task-governance override declarado se criticality diverge (raro Phase 0); cue vet ./governance/build-time/ EXIT=0; task-spec submetida para founder approval; task-approved event NÃO adicionado ainda — virá em commit posterior após approval explícita."
			ifGap:        "Se cue vet falha por _constraints.cue (chave≠id), corrigir alinhamento. Se cue vet falha por templateRef inválido, corrigir formato. Se work-events stream esquecido, criar (task fica admission-undefined sem ele). Se work-graph entry esquecida e task tem deps, task pode ser claimed prematuramente — adicionar antes de qualquer claim possível. Se founder approval não vier, task permanece proposed (não claimable) — sem prazo Phase 0; agente NÃO infere approval por silêncio."
		}
	}

	finalValidation: {
		steps: [
			"Verificar shape: instância valida contra #TaskSpec (id regex WI-NNN, version int >=1, title não-vazio, templateRef regex tmpl-XXX@vN, outputs estrutura, rationale não-vazio).",
			"Verificar ID + unicidade (tq-tsg-01 fail): id segue regex ^WI-[0-9]{3}$; ID não conflita com task-specs existentes (cue vet enforce automático via _constraints.cue chave=id).",
			"Verificar templateRef válido (tq-tsg-02 fail): templateRef segue regex ^tmpl-[a-z][a-z0-9-]*@v[0-9]+$; template ID base existe em ai-orchestration/agent-instructions/task-templates.cue (5 templates canônicos atuais).",
			"Verificar outputs concretos (tq-tsg-03 fail): cada outputs[] tem artifact (path canônico) + type (create/update/validate); outputs vazio aceitável apenas para tasks pure-validation, com rationale explicando alvo validado; affects recomendado quando houver superfície indireta.",
			"Verificar work-events stream pareado (tq-tsg-04 fail): governance/build-time/work-events/wi-NNN.cue existe; streams[WI-NNN].events[0] é task-proposed; sem stream, task fica admission-undefined.",
			"Verificar semanticPrerequisites verificáveis (tq-tsg-05 warn): cada item aponta para path real OU seção identificável; vagos ('contexto geral', 'leitura de princípios') flagged.",
			"Verificar affects sem duplicação (tq-tsg-06 warn): affects[] não repete outputs[*].artifact; lista vazia aceitável quando task impacta apenas seus outputs.",
			"Verificar rationale substantivo (tq-tsg-07 warn): rationale cobre tipo + ordem (quando aplicável) + classificação + caveats; rationale repetindo title flagged para reescrita.",
			"Verificar cross-task deps em work-graph (tq-tsg-08 warn): se task tem deps semantic ou schema, governance/build-time/work-graph.cue tem entry #ExecutionDependency com taskId + dependsOn; sem entry, task assumida sem deps (race condition silenciosa).",
			"Verificar task-governance override consistência (tq-gv-XX paralelo): task-level override em task-governance.cue (raro Phase 0) tem rationale documentando divergência material do template; sem rationale, override é ad-hoc.",
			"Executar cue vet ./governance/build-time/ recursive — falha bloqueia avanço; corrigir sintaxe e re-executar antes de submeter ao founder.",
			"Submeter ao founder para aprovação. task-approved event será adicionado ao work-events stream APENAS APÓS founder approval explícita em mensagem separada ou decisão registrada — nunca no mesmo commit / mesma turn do propor (guard contra auto-approval).",
		]
	}
}
