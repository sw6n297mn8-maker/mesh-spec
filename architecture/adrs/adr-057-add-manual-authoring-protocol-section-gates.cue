package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-057 — Add manualAuthoringProtocol with section-level founder gates
// as Layer 2 defense.
//
// Camada 2 do sistema de defesa em 3 camadas (Camada 1: adr-056
// production-guide-coverage; Camada 3: uq-XX em quality-gate.cue).
// Camada 1 garante per P10 (PG exists antes de instância); Camadas
// 2+3 são supplementary — closing failure modes que Camada 1 não
// cobre diretamente.
//
// Materializado em commit único: ADR + schema extension (governance/
// build-time/authoring-policy.cue) com novo tipo #ManualAuthoringProtocol
// + novo campo manualAuthoringProtocol no #AuthoringPolicy + instância
// no authoringPolicy block.

adr057: artifact_schemas.#ADR & {
	id:    "adr-057"
	title: "Add manualAuthoringProtocol with section-level founder gates as Layer 2 defense"
	date:  "2026-05-01"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		State-of-affairs precedente:
		- adr-054 estabeleceu authoring-policy.cue como SoT operacional
		  para autoria de artefatos governados, com dois modos:
		  subagent-drafted (rollout entries com inputContract/output-
		  Contract/promptTemplate/fallbackPolicy) e manual (defaultMode
		  + tipos sem rollout entry).
		- adr-056 (Camada 1) materializa cascade ordering como gate
		  determinístico via kind production-guide-coverage — antes
		  de instanciar schema tipado, PG correspondente DEVE existir.
		- Authoring manual ficou under-specified em adr-054: schema
		  não declara COMO o agente aplica o PG section-by-section.
		  Disciplina ficava implícita ('agente segue meta-guide').

		Trigger concreto (2026-05-01): idc-primary-agent.cue commit
		b248178 foi committed sem founder review section-by-section
		apesar de PG-A (architecture/production-guides/agent-spec.cue)
		existir. Sections do PG (workOrder + sections + doneCriteria +
		gapPolicy) fornecem o protocol; agente aplicou-o no abstrato
		e propôs artefato completo (~549 linhas) ao final. Founder não
		teve oportunidade de gatekeep section por section — gate
		intermediário inexistente.

		Live evidence dentro desta sessão: agente (autor desta ADR)
		durante autoria de PG-StructuralCheck e PG-ADR aplicou section
		gates VOLUNTÁRIOS (apresentar Section N → esperar founder
		confirmar → autorar Section N+1). Práctica funcionou mas era
		convenção ad-hoc; sem campo declarativo, próximas autorias
		dependeriam de autor lembrar de aplicar a disciplina.

		Camada 1 (adr-056) garante PG existe ANTES de instância. Mas
		existência de PG não impede skip de section gates DURANTE
		autoria — Camada 1 fecha 'PG exists' mas não 'PG é seguido
		section-by-section'. Camada 2 supplementary fecha esse gap
		de forma declarativa.

		P10 (gates determinísticos validam, agentes recomendam) preserva
		primazia do gate humano. Section gates são humanos (founder
		confirma); agente recomenda por section. Camada 1 garante;
		Camada 2 distribui ponto de inflexão founder ao longo da autoria,
		não apenas no final submission.

		Alternativas avaliadas:
		(a) Trust-based (manter authoring manual como 'agente segue
		meta-guide' sem campo declarativo) — rejeitada: discovery
		b248178 prova falha; PG existe + cascade ordering enforced por
		Camada 1, mas ausência de section gates permite skip silencioso
		durante autoria. Convenção informal não é auditável.
		(b) Estender meta-PG (production-guide.cue) com section gates
		explícitos no workflow — rejeitada como ÚNICO local; meta-PG é
		guidance para AUTOR de PGs, não policy comportamental do agente.
		Localização correta para protocol comportamental é authoring-
		policy.cue (peer da fallbackPolicy: ambos governam comportamento
		agente em modos específicos).
		(c) Apenas critério em quality-gate.cue (uq-XX validando
		section-by-section conformity post-hoc) — rejeitada como única
		defesa; será Camada 3 supplementary; detecta drift mas não
		previne durante autoria. Self-review é post-autoria.
		(d) Hardcode protocol em CLAUDE.md — rejeitada por P0; CLAUDE.md
		é comportamental mas SoT operacional do protocol vive em
		authoring-policy.cue. CLAUDE.md aponta (Camada 4 sub-item
		posterior, pointer-only).
		(e) Codificar como structural-check kind (analogous a Camada 1)
		— rejeitada; section gates são EVENTOS de autoria humana
		(apresentação + confirmação founder), não invariants estruturais
		sobre arquivos. structural-check é determinístico sobre estado
		committed; section gates são protocolo comportamental sobre
		processo de autoria.
		"""

	decision: """
		(1) ADICIONAR novo tipo #ManualAuthoringProtocol ao schema em
		governance/build-time/authoring-policy.cue (entre #FallbackPolicy
		e #AuthoringPolicySchema). Tipo carrega 8 campos: applicability-
		Condition, sectionGate, founderConfirmation, serializationRule,
		selfReviewScope, failureMode, trivialCorrectionException,
		rationale.

		(2) ADICIONAR campo manualAuthoringProtocol ao #AuthoringPolicy
		schema (peer de fallbackPolicy; ambos governam comportamento
		agente em modos específicos — manual vs subagent-drafted
		fallback).

		(3) ADICIONAR bloco manualAuthoringProtocol à instância
		authoringPolicy preenchendo os 8 campos com conteúdo substantivo.
		Atualizar rationale final do authoringPolicy mencionando o novo
		campo (simetria manual/dispatch).

		(4) ESCOPO: protocolo aplica EXCLUSIVAMENTE a authoring manual
		pelo main agent. Subagentes via subagent-drafted dispatch NÃO
		são governados por este protocolo; seguem inputContract/output-
		Contract e quality-gate próprios per adr-054 dec 10 (isolation
		authoring vs review).

		(5) SECTION GATES: para cada section em workOrder do PG, na
		ordem declarada, agente: (a) autora conteúdo da section
		conformando com target/process/heuristics/doneCriteria; (b)
		executa auto-checagem contra section.doneCriteria + quality
		criteria do schema alvo; (c) propõe conteúdo da section ao
		founder com transcript da auto-checagem; (d) aguarda confirmação
		explícita do founder antes de autorar a próxima section. Section
		gates são BLOQUEANTES — não diferidos para final submission.

		(6) FOUNDER CONFIRMATION é step bloqueante distinto. NÃO é
		absorvida por self-review nem por final submission. Veículo:
		confirmação explícita referenciando a section atual OU aceitação
		inequívoca da proposta corrente. Mensagens genéricas só contam
		se não houver ambiguidade contextual (única section pendente,
		sem outras propostas em suspenso). Silêncio NÃO é aprovação.
		Modificações solicitadas antes da confirmação são aplicadas e
		a section re-proposta — não acumuladas para próxima section.

		(7) TRIVIAL CORRECTIONS exception: correções de sintaxe/
		formatação sem alteração semântica (typo em comentário,
		espaçamento, alinhamento de indentação, ajuste de sintaxe CUE
		detectado por cue vet) podem ser aplicadas sem novo section
		gate; devem ser reportadas no próximo checkpoint. Exception
		estreita: alterações que mudam significado, política, tipo,
		relação, constraint ou critério NÃO são triviais e exigem gate
		completo. Em dúvida sobre classificação: tratar como semântica.

		(8) SERIALIZATION: sections autoradas serialmente per workOrder,
		não em paralelo nem em lote. Gap em section M < N já confirmada
		dispara amendment de M ANTES de continuar N — amendment passa
		por gate próprio. Founder pode aprovar múltiplas sections em
		batch SOMENTE se todas já tiverem sido apresentadas com auto-
		checks separados ANTES da aprovação batch; nunca aprovar section
		futura não-apresentada (preserva o gate intermediário).

		(9) SELF-REVIEW SCOPE: self-review per quality-gate.cue ocorre
		sobre artefato integrado APÓS todas sections terem passado por
		section gates. Self-review NÃO substitui section gates;
		complementa. Verificação de respeito aos section gates é critério
		dedicado a ser adicionado a quality-gate.cue (Camada 3
		supplementary, sub-item subsequent).

		(10) FAILURE MODE: pular gate é violação do protocolo. Founder
		pode rejeitar artefato em bloco e exigir reautoria desde a
		section onde gate foi pulado.

		(11) APPLICABILITY: protocolo aplica quando (a) agente autora
		instância de tipo em rollout com mode 'manual' OU tipo não
		registrado (cai em defaultMode 'manual'), E (b) existe
		production-guide para o tipo com sections + workOrder. Sem PG:
		cascade ordering (adr-054 dec 13 + adr-056 Camada 1) bloqueia
		primeiro.

		(12) MATERIALIZAÇÃO: single commit contendo ADR + schema
		extension (decision items 1-2) + instance content (decision
		item 3). Decisão estrutural única — multi-commit fragmentaria
		atomic rationale, paralelo a adr-056.
		"""

	consequences: """
		Positivas:

		(P1) Section gates eliminam path de skip que produziu commit
		b248178 — autoria sem founder review section-by-section vira
		impossível por construção. Founder ganha intervenção early —
		pode redirigir autoria de section N+1 baseado em decisões de
		section N, sem processar artefato completo só no final.

		(P2) Protocolo declarativo permite auditoria (diff em
		authoring-policy.cue mostra mudanças); reverter via alteração
		de campo, não via mudança de comportamento informal.

		(P3) Asymmetry vs subagent dispatch é justificada: subagentes
		operam em isolation com contracts; adr-054 dec 10 isola
		authoring de review subagent. Main agent manual precisa de gate
		equivalente — founder se torna gate distribuído ao longo da
		autoria, paralelo conceitual ao isolation no dispatch.

		(P4) Self-review post-autoria foca no artefato integrado
		(complementa, não substitui section gates). Camada 3 (uq-XX)
		valida que section gates foram respeitados — verificação
		retroativa, não preventiva.

		(P5) Pattern reusable — outros modos (colaborativo, hybrid)
		entrariam como peer fields em #AuthoringPolicy sem alterar
		#ManualAuthoringProtocol existente.

		(P6) Camada 2 do sistema de defesa em 3 camadas. Camada 1
		(adr-056) garante PG existe antes de instância; Camada 2
		garante PG é seguido section-by-section durante autoria;
		Camada 3 (sub-item posterior) valida conformidade post-hoc.
		Composta — falha em uma camada é capturada por outra.

		(P7) Trivial-correction exception preserva fluidez para
		correções de sintaxe/formatação sem reabrir bypass — exception
		estreita com requirement de report no próximo checkpoint.

		Negativas:

		(N1) Custo de turnaround per section: founder responde N vezes
		durante autoria. Mitigação: founder pode aprovar múltiplas
		sections em batch SOMENTE se todas já tiverem sido apresentadas
		com auto-checks separados; nunca aprovar section futura não-
		apresentada (preserva o gate intermediário). Default é per-
		section.

		(N2) Sessions de autoria ficam longer wall-clock — gates
		serializam progresso. Mitigado por sections de tamanho razoável
		(PGs tipicamente 2-5 sections; ADRs 3 sections per PG-ADR).

		(N3) 'Confirmação explícita' depende de interpretação. Mitigado
		pelo campo founderConfirmation: confirmação referencia section
		atual OU aceitação inequívoca da proposta corrente; mensagens
		genéricas só contam se não houver ambiguidade contextual.

		(N4) Não previne TODOS modos de drift — agente pode autorar
		section 'aceitavelmente' sem aplicar profundamente o PG. Section
		gate captura concretude (o que está escrito), não aderência
		tácita. Self-review (Camada 3) cobre aderência; gates cobrem
		visibilidade.

		(N5) Asymmetry com subagent-drafted dispatch: subagentes não
		são governados por este protocolo (seguem inputContract/output-
		Contract e quality-gate próprios per adr-054). Quando main
		agent assume após fallback (subagent dispatch failed → manual
		takeover), manualAuthoringProtocol aplica desde a próxima
		section ainda não autorada.
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"governance/build-time/authoring-policy.cue",
	]

	principlesApplied: [
		"P0",
		"P10",
		"P12",
	]

	rationale: """
		Princípios aplicados:

		P10 (gates determinísticos validam, agentes recomendam): section
		gates distribuem o gate humano ao longo da autoria — founder
		confirma por section; agente recomenda por section. Discovery
		b248178 + live evidence (agente draftou primeira versão de
		manualAuthoringProtocol — agora adr-057 — sem verificar cascade
		ordering durante a mesma sessão) demonstram que regra declarativa
		sem gates distribuídos depende de atenção do agente, vetor
		probabilístico que P10 reasoning rejeita como única defesa.

		P0 (localização canônica única): manualAuthoringProtocol vive
		em authoring-policy.cue (SoT operacional para autoria), não
		duplicado em CLAUDE.md / meta-PG / quality-gate.cue. Esses
		artefatos APONTAM para o protocolo (Camada 4 sub-item: CLAUDE.md
		seção 'Aplicação de PGs' pointer-only); não duplicam.

		P12 (governança como código): protocolo é tipo CUE
		(#ManualAuthoringProtocol) com 8 campos estruturados, instância
		carrega gates operacionais em prosa estruturada, evolui via
		diff e ADR. 'Toda regra que importa é imposta automaticamente'
		— section gates são imposição via declaração + aplicação por
		agente verificável.

		Failure mode evitado: authoring de instância de schema sem
		gates intermediários section-by-section, mesmo com PG existente.
		Discovery b248178 (idc-primary-agent.cue ~549 linhas committed
		sem section gates apesar de PG-A existir) confirma que existência
		de PG não previne skip de gates durante autoria. Camada 2 fecha
		esse gap distinto da Camada 1 (que fecha 'PG exists antes de
		instância').

		Sem axiomas tensionados.

		Lenses consultadas:

		lens-real-options: codificar protocolo declarativamente preserva
		opção de evoluir gates (e.g., flexibilizar batch confirmation
		default, estender para outros modes) via ADR posterior + diff
		em authoring-policy.cue. Manter como convenção informal
		comprometeria evolução (mudança requer comunicação a usuários
		sem trace auditável).

		Relação com outras ADRs:

		- ESTENDE adr-054 (estabeleceu #AuthoringPolicy schema +
		  dispatch policy) com campo manualAuthoringProtocol — cobre
		  mode 'manual' que adr-054 deixou under-specified.
		- SUPPLEMENTA adr-056 (Camada 1 production-guide-coverage —
		  garante PG exists) com Camada 2 — garante PG é seguido
		  section-by-section. Composta: Camada 1 + Camada 2 cobrem
		  'PG existe' + 'PG é aplicado'.
		- PRECEDE Camada 3 (uq-XX em quality-gate.cue, sub-item
		  subsequent — verificação post-hoc de conformidade aos section
		  gates).
		- Sem supersession.

		Justificativa de risk metadata:

		reversibility 'high': campo manualAuthoringProtocol pode ser
		removido do schema sem afetar dados persistidos, contratos
		públicos ou estrutura de tenants. Comportamento é declarativo;
		alterar protocol altera comportamento prospectivo, sem migração
		retrospectiva. Coherence rule (tq-adr-02): consequences mencionam
		que protocol é declarativo + sem persistência — coerente com
		reversibility 'high'.

		blastRadius 'cross-cutting': afeta authoring de TODOS tipos com
		PG quando mode == 'manual' (defaultMode + tipos sem rollout
		entry). Phase 0 de adr-054: production-guide é única entry com
		mode subagent-drafted; todos outros tipos (agent-spec, agent-
		governance, glossary, domain-model, structural-check, adr) caem
		em manual e ficam sob este protocol. Shift comportamental
		sistêmico (cross-cutting > cross-artifact mesmo com 1 arquivo
		modificado). Não chega a repo-wide (não muda CI/governança
		fundamental, apenas estende authoring-policy.cue).
		"""
}
