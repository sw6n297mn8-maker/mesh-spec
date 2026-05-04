package build_time

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// authoring-policy.cue — Política declarativa para authoring de artefatos
// governados.
//
// Peer (não filho) de quality-gate.cue: separation of concerns —
// quality-gate trata REVIEW de artefatos existentes; authoring-policy
// trata CRIAÇÃO de novos.
//
// Per adr-054 (subagent-drafted dispatch + cascade ordering) e adr-057
// (manualAuthoringProtocol Camada 2 cascade-ordering defense — section-
// level founder gates para mode 'manual').
//
// Fluxo conceitual (mode subagent-drafted):
//   1. Main agent identifica necessidade de novo artefato governado
//      (ex.: novo schema sem PG correspondente; adr-053 Phase ativa)
//   2. Main agent consulta authoringPolicy.rollout para artifactType
//   3. Se mode == "subagent-drafted": dispatch authoring subagent
//      com inputContract preenchido + promptTemplate
//   4. Subagent retorna draft (per outputContract) + reasoning report
//   5. Main agent roda cue vet + dispatch review subagent (per quality-
//      gate.cue rollout) → consolida findings → submete a founder
//   6. Founder approval é gate final irreversível (P10)
//
// Fluxo conceitual (mode manual): per manualAuthoringProtocol — section
// gates bloqueantes per workOrder do PG; founder confirma section-by-
// section antes de progressão.
//
// Direção de dependência: governance/build-time → artifact_schemas.
// Nunca o contrário.

#AuthoringMode: "manual" | "subagent-drafted"

#AuthoringRolloutEntry: {
	artifactType:     artifact_schemas.#ArtifactType
	mode:             #AuthoringMode
	triggerCondition: #AuthoringTrigger
	rationale:        string & !=""
}

#AuthoringTrigger: "manual-invocation" | "file-pair-coverage" | "schema-creation-hook"
// manual-invocation:    Phase 0; agent invoca quando contexto exige
// file-pair-coverage:   Future; structural-check detecta schema sem PG
// schema-creation-hook: Future; pre-commit hook quando novo schema é committed

#FallbackPolicy: {
	onCueVetFailure:  string & !=""
	onSelfReviewFail: string & !=""
	onAmbiguity:      string & !=""
	rationale:        string & !=""
}

// Per adr-057: protocolo declarativo para authoring manual com section-
// level founder gates. Camada 2 do sistema de defesa em 3 camadas
// (Camada 1: adr-056 production-guide-coverage; Camada 3: uq-XX em
// quality-gate.cue). Aplica a tipos em rollout com mode 'manual' OU
// não registrados (defaultMode) quando PG correspondente existe.
#ManualAuthoringProtocol: {
	applicabilityCondition:     string & !=""
	sectionGate:                string & !=""
	founderConfirmation:        string & !=""
	serializationRule:          string & !=""
	selfReviewScope:            string & !=""
	failureMode:                string & !=""
	trivialCorrectionException: string & !=""
	rationale:                  string & !=""
}

#AuthoringPolicySchema: {
	type:     "authoring-policy"
	location: "governance/build-time/authoring-policy.cue"
}

#AuthoringPolicy: {
	_schema:                 #AuthoringPolicySchema
	defaultMode:             #AuthoringMode
	rollout:                 [...#AuthoringRolloutEntry]
	inputContract:           string & !=""
	outputContract:          string & !=""
	promptTemplate:          string & !=""
	fallbackPolicy:          #FallbackPolicy
	manualAuthoringProtocol: #ManualAuthoringProtocol
	rationale:               string & !=""
}

authoringPolicy: #AuthoringPolicy & {
	_schema: {
		type:     "authoring-policy"
		location: "governance/build-time/authoring-policy.cue"
	}

	defaultMode: "manual"

	rollout: [{
		artifactType:     "production-guide"
		mode:             "subagent-drafted"
		triggerCondition: "manual-invocation"
		rationale: """
			Production-guides têm meta-guide canônico (architecture/
			production-guides/production-guide.cue) que codifica o
			protocol de authoring. Aplicação manual produz variance
			entre sessões; subagent dispatch enforça aplicação
			consistente do protocol. Phase 0 trigger é manual-invocation
			(file-pair-coverage check é dívida planejada per adr-053
			decision item 7 e WI-068).
			"""
	}, {
		artifactType:     "glossary"
		mode:             "subagent-drafted"
		triggerCondition: "manual-invocation"
		rationale: """
			Glossary instances têm production-guide canônico
			(architecture/production-guides/glossary.cue). Per adr-074,
			extensão do rollout AUTORIZA tentativa via subagent-drafted.
			Fallback to manual preserved.
			"""
	}, {
		artifactType:     "domain-model"
		mode:             "subagent-drafted"
		triggerCondition: "manual-invocation"
		rationale: """
			Domain-model instances têm production-guide canônico
			(architecture/production-guides/domain-model.cue). Per
			adr-074, extensão do rollout AUTORIZA tentativa via
			subagent-drafted. Fallback to manual preserved.
			"""
	}, {
		artifactType:     "agent-spec"
		mode:             "subagent-drafted"
		triggerCondition: "manual-invocation"
		rationale: """
			Agent-spec instances têm production-guide canônico
			(architecture/production-guides/agent-spec.cue). Per
			adr-074, extensão do rollout AUTORIZA tentativa via
			subagent-drafted. Fallback to manual preserved.
			Note: agent-spec carrega contexto-heavy dependencies
			(canvas + domain-model do BC); revisit condition (c) de
			adr-074 cobre eventual restriction se dispatch falhar
			por dependência contextual.
			"""
	}, {
		artifactType:     "agent-governance"
		mode:             "subagent-drafted"
		triggerCondition: "manual-invocation"
		rationale: """
			Agent-governance instances têm production-guide canônico
			(architecture/production-guides/agent-governance.cue).
			Per adr-074, extensão do rollout AUTORIZA tentativa via
			subagent-drafted. Fallback to manual preserved.
			Note: agent-governance depende de agent-spec já existente;
			ordem de execução em WI-048 respeita dependency.
			"""
	}]

	inputContract: """
		Subagent recebe como contexto:
		1. Path do meta-guide canônico
		   (architecture/production-guides/production-guide.cue).
		2. Path e conteúdo do artifact schema target em
		   architecture/artifact-schemas/{type}.cue.
		3. Paths de 1-3 instâncias de production-guides existentes
		   como referência estrutural (ex.: para domain-model PG,
		   referenciar production-guide.cue do meta-guide e
		   glossary.cue como exemplos de structure variance).
		4. Path do glossary do BC alvo quando aplicável
		   (contexts/{bc}/glossary.cue).
		5. Path da lens domain-specific quando existir
		   (ex.: lens-domain-language para glossary PG;
		   lens-domain-model-design para domain-model PG se a lens
		   existir).
		Subagent NÃO recebe: histórico da conversa que motivou o PG,
		contexto de decisões anteriores no main agent, instruções do
		founder. Isolation per P10 e per quality-gate.cue
		executionPolicy.inputContract pattern.
		"""

	outputContract: """
		Subagent retorna:
		1. Draft de instância conformante ao schema target, com header
		   "// PARTIAL — subagent-drafted, founder review pending".
		   Conteúdo deve passar cue vet local antes do retorno
		   (subagent roda cue vet internamente).
		2. Reasoning report estruturado listando:
		   - Pontos onde subagent inferiu (e razão da inferência)
		   - Pontos onde subagent teria pedido founder (priority list
		     para founder review)
		   - Heurísticas aplicadas que não vieram explicitamente do
		     meta-guide
		3. Log de tentativas de cue vet intermediárias para debugging.
		Formato: lista estruturada em texto + draft CUE separado.
		"""

	promptTemplate: """
		Você é um sub-agente de authoring para {artifactType}. Sua
		tarefa é produzir um draft de instância conformante ao schema
		target, aplicando o production-guide canônico do mesh-spec
		para esse tipo.

		Você NÃO tem acesso ao histórico da conversa que motivou esta
		criação. Aplique exclusivamente o production-guide protocol
		e o conteúdo dos artefatos fornecidos.

		## Production-guide canônico (autoridade do protocol)
		Path: {metaGuidePath}
		Leia o arquivo. Identifique workOrder declarada. Aplique as
		sections na ordem declarada em workOrder; para cada section,
		cumpra target/objective/process/heuristics/doneCriteria/ifGap
		declarados. Não desvie do protocol — variance é exatamente o
		que este dispatch corrige.

		## Schema target
		Path: {schemaTargetPath}
		Leia o arquivo. Identifique tipo CUE principal, sub-tipos,
		quality criteria existentes, _schema.location, comments.

		## Instâncias de referência
		Paths: {existingInstancesPaths}
		Leia para padrão estrutural (sections, heuristics, doneCriteria
		patterns). NÃO copie conteúdo verbatim — referência para forma,
		não substância.

		## Glossary do BC alvo (se aplicável)
		Path: {glossaryPath}
		Leia se schema depende de UL específica do BC.

		## Lens domain-specific (se existir)
		Path: {lensPath}
		Aplique se relevante ao domínio do schema.

		## Instruções

		1. Leia o production-guide; identifique workOrder e sections
		   declaradas.
		2. Aplique sections na ordem declarada em workOrder. Para cada
		   section:
		   - Cumpra target + objective declarados
		   - Aplique process + heuristics
		   - Verifique doneCriteria antes de prosseguir
		   - Se gap identificado, aplique ifGap policy
		3. Compor finalValidation per o que o production-guide declarar
		   (incluindo founder confirmation se aplicável).
		4. Rode cue vet localmente; se falhar, corrija; logue tentativas.
		5. Produza reasoning report destacando inferências e priority
		   list para founder review.

		NÃO sugira corrections ao production-guide. NÃO assuma decisões
		de design (abreviações canônicas, hardening de severities,
		organização de sections além do que protocol prescreve). Em
		ambiguidade, registrar no reasoning report como "would have
		asked founder".
		"""

	fallbackPolicy: {
		onCueVetFailure: """
			Subagent retry uma vez com correção sintática. Falha persiste
			→ retornar draft com cue vet errors logged + reasoning report
			indicando "cue vet failure"; main agent decide manual takeover
			ou nova dispatch.
			"""
		onSelfReviewFail: """
			Review subagent (per quality-gate.cue rollout) retorna findings
			fail não-resolvíveis → main agent retry uma vez com correções
			no inputContract. Falha persiste → fallback manual com commit
			message documentando "subagent dispatch failed: {motivo}".
			"""
		onAmbiguity: """
			Subagent encontra ambiguidade que requer founder decision
			(ex.: escolha de abreviação canônica, severity hardening que
			diverge da heurística geral) → registrar no reasoning report
			como priority item. Subagent NÃO toma decisão de design;
			retorna draft com placeholder + nota explicando alternativas.
			"""
		rationale: """
			Fallback policy explícita protege contra falhas silenciosas
			ou auto-ratificação de drafts ruins. Failure rate observable
			calibra promptTemplate ao longo do tempo (Q1 da WI-069).
			"""
	}

	manualAuthoringProtocol: {
		applicabilityCondition: """
			Aplica quando agente autora instância de tipo registrado em
			rollout com mode "manual" (ou tipo não registrado, que cai
			em defaultMode "manual"), E existe production-guide para o
			tipo (architecture/production-guides/<type>.cue) com
			sections + workOrder declarados. Sem PG: cascade ordering
			(adr-054 dec 13 + adr-056 Camada 1 production-guide-coverage)
			bloqueia primeiro.
			"""

		sectionGate: """
			Para cada section em workOrder, na ordem declarada:
			1. Agente autora conteúdo da section conformando com target,
			   process, heuristics, doneCriteria do PG.
			2. Agente executa auto-checagem da section contra section.
			   doneCriteria E quality criteria do schema alvo aplicáveis
			   àquela section.
			3. Agente propõe conteúdo da section ao founder com transcript
			   da auto-checagem (findings + decisão de prosseguir).
			4. Agente aguarda confirmação explícita do founder antes de
			   autorar a próxima section.
			Section gates são bloqueantes — NÃO diferidos para final
			submission. Sem confirmação explícita por section, agente
			NÃO prossegue.
			"""

		founderConfirmation: """
			Confirmação do founder por gate é step bloqueante distinto.
			NÃO é absorvida por self-review nem por final submission.
			Veículo: confirmação explícita referenciando a section atual
			OU aceitação inequívoca da proposta corrente. Mensagens
			genéricas só contam se não houver ambiguidade contextual
			(uma única section pendente, sem outras propostas em
			suspenso). Silêncio NÃO é aprovação. Modificações solicitadas
			pelo founder antes da confirmação são aplicadas e a section
			é re-proposta — não acumuladas para próxima section.
			"""

		serializationRule: """
			Sections autoradas serialmente per workOrder, não em paralelo
			nem em lote. Agente NÃO mantém múltiplas sections "em
			andamento" simultaneamente. Se durante autoria de section N
			agente identifica gap em section M < N já confirmada,
			propõe amendment de M ao founder antes de continuar N —
			amendment passa por gate próprio.

			Founder pode aprovar múltiplas sections em batch SOMENTE se
			todas já tiverem sido apresentadas com auto-checks separados
			ANTES da aprovação batch; nunca aprovar section futura
			não-apresentada (preserva o gate intermediário).
			"""

		selfReviewScope: """
			Self-review per quality-gate.cue ocorre sobre artefato
			integrado APÓS todas sections terem passado por section
			gates. Self-review NÃO substitui section gates; complementa.
			Self-review verifica: (a) critérios universal + type-specific
			sobre artefato completo, (b) que aplicação do PG respeitou
			section gates (critério dedicado em quality-gate.cue será
			adicionado como Camada 3 supplementary).
			"""

		failureMode: """
			Se agente prosseguir para próxima section sem confirmação
			explícita do founder: violação do protocolo. Founder pode
			rejeitar artefato em bloco e exigir reautoria desde a section
			onde gate foi pulado. Sub-agentes via subagent-drafted
			dispatch (rollout entries) NÃO são governados por este
			protocolo; seguem inputContract/outputContract e quality-gate
			próprios per adr-054. manualAuthoringProtocol aplica
			EXCLUSIVAMENTE a authoring manual pelo main agent.
			"""

		trivialCorrectionException: """
			Correções triviais de sintaxe/formatação sem alteração
			semântica (typo em comentário, espaçamento, alinhamento de
			indentação, ajuste de sintaxe CUE detectado por cue vet)
			podem ser aplicadas sem novo section gate; devem ser
			reportadas no próximo checkpoint (proposta de section
			seguinte OU final submission). Exception estreita:
			alterações que mudam significado, política, tipo, relação,
			constraint ou critério NÃO são triviais e exigem gate
			completo. Em dúvida sobre classificação: tratar como
			semântica e abrir gate.
			"""

		rationale: """
			Discovery 2026-05-01: idc-primary-agent.cue (commit b248178)
			foi committed sem founder review section-by-section apesar
			de PG-A (architecture/production-guides/agent-spec.cue)
			existir. Authoring manual permitia "aplicar" o PG no abstrato
			e propor artefato completo ao final — section gates do PG
			ficavam implícitos. Section gates bloqueantes forçam
			application real do protocol.

			Per adr-054 dec 10, isolation reduz viés de auto-ratificação
			em subagent dispatch; section gates resolvem o equivalente
			para authoring manual — founder se torna o gate distribuído
			ao longo da autoria, não apenas no final submission. P10
			(gates determinísticos validam, agentes recomendam)
			preservado: gates são humanos (founder confirma), agente
			recomenda por section.

			Cascade ordering com PG (adr-054 dec 13 + adr-056 Camada 1)
			é pré-condição: sem PG, não há sections nem doneCriteria
			para gatekeeping. Camada 2 (este campo) garante PG é seguido
			section-by-section durante autoria. Composta com Camada 1.
			"""
	}

	rationale: """
		Authoring-policy é peer (não filho) de quality-gate per adr-054
		decision item 1: separation of concerns entre review (quality-gate)
		e creation (authoring-policy). Reusar quality-gate.cue para
		authoring criaria sobrecarga de concerns e coupling indevido.

		defaultMode "manual" garante que nenhum artifactType vira
		subagent-drafted sem entry explícita no rollout — princípio de
		menor surpresa e reversibility por construção.

		Rollout inicial com production-guide reflete adr-053 Phase 2
		scaling (~22 PGs restantes); outros types podem entrar no
		rollout via ADR específico quando padrão validar (ex.: glossary
		instances, validation-prompts, structural-checks).

		Rollout extension via adr-074: 5 tipos de WI-048 BC bootstrap
		(canvas, glossary, domain-model, agent-spec, agent-governance)
		entraram no rollout simultaneamente. Extensão AUTORIZA
		tentativa via subagent-drafted, NÃO garante sucesso. Fallback
		per-dispatch isola risco; revisit conditions explícitas em
		adr-074 cobrem fallback patterns observados.

		promptTemplate generalizado per adr-074: substituiu hardcoded
		"production-guide" por placeholder {artifactType}; substituiu
		referências a Section 1/2/3 do META-PG por reference genérica
		a workOrder do production-guide alvo. Template agora reusable
		para qualquer tipo cujo PG declare workOrder + sections.

		promptTemplate referencia meta-guide path em vez de duplicar
		conteúdo (P0). Subagent lê meta-guide diretamente como SoT do
		protocol. Mudanças no meta-guide propagam automaticamente para
		futuros subagent dispatches sem update na promptTemplate.

		fallbackPolicy explícita evita modo silencioso de falha — main
		agent sabe quando re-tentar, quando escalar, quando fazer
		manual takeover. Failure rate é métrica observable para
		calibração contínua.

		Phase 0 design: schema + policy materializados nesta sessão;
		primeira execução real de subagent-drafted authoring ocorre em
		Phase 1 após WI-069 verificar infraestrutura de dispatch.
		Trigger automatizado (file-pair-coverage) é dívida planejada
		dependente de WI-068 + ADR posterior análogo a adr-049.

		manualAuthoringProtocol fecha simetria do artefato: rollout +
		inputContract + outputContract + promptTemplate + fallbackPolicy
		governam dispatch (subagent-drafted); manualAuthoringProtocol
		governa o lado manual (defaultMode + tipos sem rollout entry).
		Per adr-057, Camada 2 do sistema de defesa em 3 camadas com
		adr-056 (Camada 1 production-guide-coverage) e Camada 3
		(uq-XX em quality-gate.cue, sub-item subsequent).
		"""
}
