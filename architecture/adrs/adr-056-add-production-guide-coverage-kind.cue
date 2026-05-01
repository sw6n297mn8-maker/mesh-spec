package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-056 — Add production-guide-coverage structural-check kind for
// cascade-ordering enforcement.
//
// Camada 1 do sistema de defesa em 3 camadas (Camada 2: adr-057
// manualAuthoringProtocol; Camada 3: uq-XX em quality-gate.cue).
// Camada 1 garante per P10 (gates determinísticos validam, agentes
// recomendam); Camadas 2+3 são supplementary.
//
// Materializado em commit único: ADR + schema extension (architecture/
// artifact-schemas/structural-check.cue) + instance sc-pg-01
// (architecture/structural-checks/production-guide.cue). Decisão
// estrutural única — multi-commit fragmentaria o atomic rationale.

adr056: artifact_schemas.#ADR & {
	id:    "adr-056"
	title: "Add production-guide-coverage structural-check kind for cascade-ordering enforcement"
	date:  "2026-05-01"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		State-of-affairs precedente:
		- adr-053 estabeleceu cobertura universal de production-guides:
		  todo schema instanciável em architecture/artifact-schemas/
		  deve ter guide correspondente em architecture/production-guides/.
		- adr-054 dec 13 estabeleceu cascade ordering: PG precisa existir
		  ANTES de autoria de qualquer instância de schema tipado.
		  CLAUDE.md L223-233 (Authoring Declarativo) declara explicitamente
		  a regra como diretriz comportamental.
		- adr-041 estabeleceu structural-check v1 minimal com 4 kinds
		  (required-block, reference-exists, same-artifact-consistency,
		  conditional-file-presence). adr-049 estendeu com conditional-
		  file-presence usando discipline 'kind narrow por caso, não
		  meta-kind cross-artifact genérico'.

		Trigger concreto (2026-05-01): idc-primary-agent.cue commit b248178
		foi committed sem founder review section-by-section apesar de PG-A
		(architecture/production-guides/agent-spec.cue) existir. Cascade
		ordering era regra declarativa em CLAUDE.md + adr-054, mas regra
		alone não bloqueia — agente lê e ainda assim viola.

		Live evidence dentro desta mesma sessão: na mesma sessão, após
		exposição explícita à regra, agente (autor desta ADR) draftou
		primeira versão de manualAuthoringProtocol (originalmente
		adr-056, agora realocada para adr-057) sem verificar cascade
		ordering — exatamente o failure mode que adr-054 declara mas
		não enforced. Quatro causas estruturais identificadas:
		(i) salience drift (regra enterrada em prosa de 73 linhas), (ii)
		genre confusion (drafting ADR percebido como categoria especial,
		não 'instância de #ADR'), (iii) authority by analogy (ADR-054
		existente no contexto sobrepôs cascade rule), (iv) sem gate
		determinístico (checagem vive em comportamento; comportamento é
		probabilístico).

		P10 (gates determinísticos validam, agentes recomendam) demanda
		mecanismo de enforcement independente de atenção do agente.

		Alternativas avaliadas:
		(a) Trust-based (manter regra apenas em CLAUDE.md + adr-054 prose,
		sem gate) — rejeitada: discovery dentro desta mesma sessão prova
		que falha; sem mecanismo declarativo, drift é inevitável por
		construção (não depende de má-fé, depende apenas de salience
		drift / genre confusion).
		(b) Apenas behavioral protocol step (em adr-057 manualAuthoring-
		Protocol) — rejeitada como única defesa; depende de atenção do
		agente; será Camada 2 supplementary (adr-057), não primária.
		(c) Apenas self-review criterion post-hoc (uq-XX em quality-gate.cue)
		— rejeitada como única defesa; detecta drift mas não previne durante
		autoria; será Camada 3 supplementary (sub-item posterior).
		(d) Generic cross-artifact reference checker (extend kind reference-
		exists para cross-file) — rejeitada; adr-041 explicitamente exclude
		'cross-artifact reference checking genérico' do v1 schema; adr-049
		estabeleceu pattern de kind narrow por caso, não meta-kind genérico.
		(e) Reusar conditional-file-presence (sourcePattern em algum arquivo,
		conditionField boolean, targetPattern em PG) — rejeitada; current
		conditional-file-presence assume campo BOOLEAN no source artifact,
		não aplicável para 'schema é instanciável e tem instâncias' —
		cobertura universal não é gating por flag boolean.
		"""

	decision: """
		(1) ADICIONAR novo kind 'production-guide-coverage' ao enum
		#StructuralCheckKind em architecture/artifact-schemas/structural-
		check.cue, seguindo o pattern de adr-049 (kind narrow por caso).

		(2) ADICIONAR novo sub-tipo #ProductionGuideCoverageRule com shape:
		    coveredSchemas: [string, ...string]
		Whitelist explícita (não enumeration automática) — cobertura cresce
		por change-on-touch quando novo PG é committed; CI nunca surpreende
		com falha por discovery automática de schema sem PG.

		(3) ADICIONAR novo branch a #StructuralCheckRule discriminated
		union: '... | #ProductionGuideCoverageRule'.

		(4) ADICIONAR novo disjunct a #StructuralCheck discriminated union
		linking kind=='production-guide-coverage' a rule: #ProductionGuide-
		CoverageRule (seguindo o pattern dos 4 kinds existentes).

		(5) CRIAR novo arquivo architecture/structural-checks/production-
		guide.cue com instância sc-pg-01: artifactType 'production-guide',
		kind 'production-guide-coverage', rule.coveredSchemas com whitelist
		inicial, errorMessage acionável (3 partes per tq-sc-01), rationale
		referenciando este ADR + discovery b248178.

		(6) WHITELIST INICIAL com 7 schemas:
		    - agent-spec, agent-governance, glossary, domain-model,
		      production-guide (5 PGs já existentes antes desta sequência)
		    - structural-check, adr (2 PGs criados em commits 64a44e0 e
		      3d6b7e3 desta sequência)
		Rule nasce verde — todos 7 PGs já existem em architecture/
		production-guides/. Primeiro uso é proteção contra remoção
		acidental, não débito retroativo.

		(7) EXPANSION DISCIPLINE: quando novo PG é committed, ADD schema
		name ao coveredSchemas no MESMO commit. Change-on-touch — runner
		nunca surpreende com falha por schema fora da whitelist; falha
		aparece imediatamente quando PG é planejado mas não criado, OU
		criado mas whitelist esquecida.

		(8) RUNNER FUTURO: runner pós-commit lê sc-pg-01.rule.coveredSchemas;
		para cada nome verifica existência de architecture/production-
		guides/{nome}.cue. Ausência = gate determinístico bloqueia
		(errorMessage com path específico). Runner é work-item separado
		(análogo a runners das outras kinds); rule fica latente até runner
		ativar — alinhado com validatorNote do PG-StructuralCheck.

		(9) MATERIALIZAÇÃO: single commit contendo ADR + schema extension
		(items 1-4) + instance sc-pg-01 (item 5). Decisão estrutural única
		(extension de schema + instanciação imediata da nova kind) é coesa;
		multi-commit fragmentaria o atomic rationale.
		"""

	consequences: """
		Positivas:

		(P1) Cascade ordering passa a ser bloqueável de forma determinística
		pelo runner (quando ativado). Discovery 2026-05-01 (idc-primary-
		agent.cue commit b248178) seria bloqueada por construção: PG não
		existe → gate emitiria errorMessage com path específico. Camada 1
		do sistema de defesa em 3 camadas — única que garante per P10.

		(P2) Whitelist explícita previne CI surpresa: novo schema sem PG
		não dispara false-positive (não está na whitelist); falha aparece
		imediatamente quando PG é planejado mas não criado, OU criado mas
		whitelist esquecida (change-on-touch discipline).

		(P3) Rule nasce verde com 7 schemas (todos PGs já existentes em
		architecture/production-guides/). Primeiro uso é proteção contra
		remoção acidental, não débito retroativo a resolver.

		(P4) Pattern reusable consolidado — kind narrow por caso (adr-049
		conditional-file-presence + adr-056 production-guide-coverage)
		estabelece o approach padrão contra meta-kinds genéricos prematuros.

		(P5) Materializa enforcement de adr-053 (cobertura universal) e
		adr-054 dec 13 (cascade ordering) — antes regras declarativas, agora
		gating determinístico per adr-040 separation.

		(P6) Predecessor estrutural de adr-057 (manualAuthoringProtocol —
		Camada 2) e do uq-XX em quality-gate.cue (Camada 3) — sistema de
		defesa em camadas onde Camada 1 garante e camadas supplementary
		reforçam.

		Negativas:

		(N1) Whitelist explícita exige discipline manual de update (vs auto-
		discovery). Whitelist esquecida = schema novo não protegido até
		change-on-touch corrigir. Mitigação: discipline codificada em
		PG-StructuralCheck heuristics + ifGap; runner futuro pode emitir
		warn quando schema instanciável existe sem entrada na whitelist.

		(N2) Rule fica latente até runner existir (work-item separado;
		análogo às outras 4 kinds que também dependem de runner). Gate
		efetivo depende de runner ativação — antes disso, rule é
		declarativa apenas.

		(N3) #StructuralCheckKind enum cresce de 4 para 5 kinds; manutenção
		schema cresce com kinds. Aceito per adr-041 v1 minimal philosophy:
		'casos concretos justificam adições; meta-kinds genéricos requerem
		caso real, não especulação'.

		(N4) production-guide-coverage é narrow para coverage de PGs
		especificamente — cases similares futuros (canvas↔domain-model
		coverage, ou outras companion-file-required relations) podem precisar
		próprias kinds, multiplicando kinds antes de meta-kind. Aceito per
		adr-049 discipline; meta-kind exigirá ≥3 kinds similares + caso
		concreto justificando consolidação.
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/artifact-schemas/structural-check.cue",
		"architecture/structural-checks/production-guide.cue",
	]

	principlesApplied: [
		"P0",
		"P10",
		"P12",
	]

	rationale: """
		Princípios aplicados:

		P10 (gates determinísticos validam, agentes recomendam): justifica
		a decisão central de adicionar gate determinístico em vez de manter
		apenas regra declarativa. Discovery 2026-05-01 + live evidence
		dentro desta sessão demonstram que regra declarativa sem gate
		depende de atenção do agente — atenção é probabilística (P10
		reasoning aplica direto). Mecanismo independente de atenção é
		condição P10.

		P0 (localização canônica única): structural-check é o local canônico
		para gating cross-file (per adr-040 categorical separation
		determinístico vs advisory); CLAUDE.md L223-233 e adr-054 dec 13
		apontam para a regra mas o ENFORCEMENT vive em structural-check —
		não duplicar regra em múltiplos enforcement layers.

		P12 (governança como código): rule é instância CUE conformante
		(fitness function declarativa); evolui via diff e ADR; auditável
		via repo. Alinhada com 'Toda regra que importa é imposta
		automaticamente'.

		Failure mode evitado: authoring de instância de schema sem PG
		correspondente, mesmo após leitura explícita da regra (salience/
		attention failure). Live evidence dentro desta sessão (autor desta
		ADR draftou primeira versão de manualAuthoringProtocol sem
		verificar cascade) confirma que Camada 1 não é redundante com
		camadas supplementary 2+3.

		Sem axiomas tensionados.

		Lenses consultadas:

		lens-real-options: whitelist explícita (vs auto-discovery) preserva
		opção de expansão deliberada — rule nasce verde, novos schemas
		entram via change-on-touch. Auto-discovery comprometeria rollback
		(CI surpreende com falhas em schemas que ainda não decidiram ter
		PG); whitelist mantém opção sem comprometer ativação.

		Relação com outras ADRs:

		- ESTENDE adr-041 (4 kinds → 5 kinds) seguindo precedente de adr-049
		  (kind narrow por caso, não meta-kind genérico).
		- MATERIALIZA enforcement de adr-053 (cobertura universal de PGs)
		  e adr-054 dec 13 (cascade ordering) — antes diretrizes
		  declarativas, agora gate determinístico.
		- PRECEDE adr-057 (manualAuthoringProtocol — Camada 2 supplementary)
		  e Camada 3 (uq-XX em quality-gate.cue, sub-item posterior).
		- Sem supersession.

		Justificativa de risk metadata:

		reversibility 'high': schema extension é puramente aditiva (CUE
		union ganha disjunct sem alterar disjuncts existentes); nenhuma
		instância existente depende da nova kind; rule pode ser removida
		sem migração de dados/contratos. Coherence rule (tq-adr-02): 'low
		cost de reversão' ⇒ reversibility 'high' — satisfeito.

		blastRadius 'cross-cutting': altera schema central (#StructuralCheck
		adquire 5° kind), define base de enforcement para governança
		sistêmica (cascade ordering universal aplicado a todo schema
		instanciável), e cria pattern reusable para future companion-file-
		required checks. Não é apenas 2 arquivos pontuais — é shift
		estrutural na maquinaria de enforcement do repo. Não chega a
		repo-wide (não muda CI/governança fundamental, apenas estende
		structural-check infrastructure existente).
		"""
}
