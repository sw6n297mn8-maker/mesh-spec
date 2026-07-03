package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr166: artifact_schemas.#ADR & {
	id:    "adr-166"
	title: "Contagem escopada + exclusão de self-match por construção + kind structural-predicate no runner de deferred-triggers"
	date:  "2026-07-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	context: """
		Três defeitos mecânicos comprovados no runner de triggers
		(scripts/ci/evaluate-deferred-triggers.sh) + uma classe de erro
		semântica que eles produzem:

		(1) CONTAGEM REPO-WIDE SEM ESCOPO: recurrence scope=file-content
		usa `git grep -l -E` sobre o repo inteiro — conta qualquer arquivo
		com o pattern, incluindo ADRs, PGs e prosa. scope=filename com
		pattern não-ancorado conta arquivos de package metadata (_meta.cue
		no def-010: 'n=2' com 1 convention real).

		(2) SELF-MATCH: o próprio def e seus self-reviews contam para o
		trigger que os monitora. Caso comprovado (PR #196): def-014
		'visibility= ×11' era artefato — ZERO ocorrências em qualquer
		canvas; os 11 arquivos eram domain-models (ecoando campo TIPADO
		adjacente), ADR, PG e o próprio def. def-016: 5 matches = o def +
		2 self-reviews + os artefatos que DEFINEM a proteção. Classe do
		erro: contagem sintática não distingue DEFINIÇÃO de TRANSGRESSÃO,
		nem prosa argumentativa de instância real. Contagens defeituosas
		enganaram decisão de arquitetura (ordem da janela de spec-hygiene
		no housekeeping, revertida no #196).

		(3) GATE FIRST-TRIGGER: o gate de carência (adr-162) avalia
		gateability/idade APENAS do primeiro trigger que dispara
		(`if ok and not fired`). No def-001, o trigger[0] file-contains
		(warn-only) dispara primeiro e esconde o trigger[1] file-exists
		(gateável, disparado há meses) — com DD_GATE_ENABLED=1 o runner
		sai exit 0. O gate ligado (PR #184) está sendo silenciosamente
		contornado pela ordem dos triggers.

		Viabilidade comprovada do motor estrutural: `cue export <package>
		-e <expr> --out json` avalia predicados sobre artefatos tipados de
		forma determinística e barata (protótipos: contagem de bootstrap
		exceptions transient = 24 em 0.07s; len(declaredFlows) = 1 em
		0.19s; status do frontend-codegen-contract = false em 0.07s;
		coveredSchemas do sc-pg-01 sem design-principle em 3.8s). Limites
		verificados que moldam a fronteira estrutural-vs-textual: campos
		ocultos (_qualityCriteria) não saem no export; um export não
		cruza packages (contexts por-BC).

		Alternativas avaliadas:
		(a) Só documentar a limitação e triar manualmente cada disparo —
		rejeitada: repete a classe de erro do #196 a cada ciclo; o custo
		de triagem cresce com o backlog (54 open).
		(b) Escopo como convenção de autoria (pattern bem escrito), sem
		mudança de schema/engine — rejeitada: convenção não é gate (P10);
		o def-010 provou que a convenção falha silenciosamente.
		(c) Predicados como expressões inline no próprio trigger, sem
		registry — rejeitada: expressões espalhadas por 54 defs não são
		auditáveis nem versionáveis como conjunto; registry nomeado
		(ddp-XXX) dá localização canônica única (P0) e revisão de
		mudança concentrada.
		(d) Escopo obrigatório no schema + exclusões de engine por
		construção + registry de predicados nomeados (escolhida).
		"""

	decision: """
		(1) EXCLUSÕES DE ENGINE POR CONSTRUÇÃO (não configuráveis por
		trigger): toda contagem recurrence exclui SEMPRE
		architecture/deferred-decisions/**, governance/build-time/
		self-reviews/** e arquivos com basename iniciando em '_'
		(package metadata). Um def nunca conta para o próprio sensor.

		(2) ESCOPO DECLARADO OBRIGATÓRIO: recurrence scope=file-content
		ganha campo pathScope (regex ancorado em '^' sobre paths,
		required); recurrence scope=filename passa a exigir pattern
		ancorado em '^'. Enforcement primário: cue vet (schema) — trigger
		sem escopo é malformado e falha ANTES do runner. Enforcement
		secundário: runner falha ALTO (::error + exit 1) em malformação
		que escape (predicate id não resolvido, package/expr que não
		avalia). Malformação NUNCA degrada para count 0 silencioso.

		(3) NOVO KIND structural-predicate no #Trigger:
		    {kind: "structural-predicate", predicate: "ddp-NNN"}
		referenciando predicado nomeado e versionado em
		governance/build-time/dd-predicates.cue (registry singleton,
		schema #DDPredicate inline: id, package, expr, comparator
		'>=' | '==true', threshold, rationale). Runner avalia via
		`cue export <package> -e <expr> --out json`. Predicados sobre
		artefatos TIPADOS substituem regex frágil sobre o texto deles.
		Nascem 4: ddp-001 (def-012, count de bootstrap exceptions
		transient), ddp-002 (def-031, len de declaredFlows), ddp-003
		(def-064, status do frontend-codegen-contract), ddp-004
		(def-030, design-principle em coveredSchemas do sc-pg-01).

		(4) FIX DO GATE: carência avaliada sobre TODOS os triggers
		disparados de um def, não só o primeiro. Annotation continua
		reportando a primeira condição disparada.

		(5) RUNNER: python inline extraído para
		scripts/ci/evaluate_deferred_triggers.py (testável; wrapper bash
		mantém a interface e o Step 0 cue vet). Testes em
		scripts/ci/tests/ (unittest stdlib; fixtures git efêmeras),
		incluindo reprodução do cenário (3) e os 4 valores dos
		predicados congelados como asserts de calibração. Step novo no
		job cue-validate do validate.yml.

		(6) MIGRAÇÃO dos 21 triggers contáveis/condicionais dos 54 defs
		open, per tabela aprovada pelo founder (2026-07-03): 4 viram
		structural-predicate (def-012, def-031[0], def-064[0],
		def-030[1]); 7 file-content ganham pathScope (def-004, def-005,
		def-006, def-009, def-013 ×2, def-015); filename ganham/já têm
		âncora (def-010 corrige âncora + def-031[1], def-032[1],
		def-035[1] anexam '^'; def-007/def-008 já conformes);
		def-016[0] REMOVIDO (prosa: os matches são os artefatos que
		definem a proteção, não evidência de violação — manual-review
		existente vira forma única); def-001[0][1] REMOVIDOS como
		EXAURIDOS (condição permanentemente verdadeira desde adr-076;
		sensor virou alarme perpétuo; o que resta é decisão de
		prioridade do founder — manual-review é forma final).
		Sequenciamento obrigatório: fix (4) + migração do def-001 no
		MESMO PR — o fix sem a migração deixaria main vermelho via
		def-001[1] além da carência.

		(7) DIREÇÃO REGISTRADA SEM EXECUTAR (decisão do founder): o
		horizonte é campos required em schemas aposentarem triggers de
		contagem — cue vet vira o próprio gate; prosa factual derivada
		da estrutura elimina a classe de erro do #196. Nenhum trabalho
		desta direção neste ADR.

		(8) ESCOPO EXCLUÍDO: re-triagem dos disparos sobreviventes
		(decisão do founder sobre as contagens verdadeiras, pós-merge);
		volume-threshold e commit-message inalterados (sem uso em defs
		open); ligar/desligar DD_GATE_ENABLED (permanece como está,
		ligado desde #184).
		"""

	falsificationCondition: {
		condition:        "Esta decisão estará errada SE as contagens do runner corrigido divergirem do gabarito verificado manualmente no pre-flight (def-012=24≥20 dispara; def-013=3 arquivos genuínos; def-035=5 records; def-010=1<2 não dispara; def-004 cai com escopo), OU se os predicados CUE se provarem não-determinísticos entre execuções sobre a mesma árvore."
		observableSignal: "Primeira execução pós-merge do runner corrigido sobre os defs vivos (FASE C): qualquer contagem divergente do gabarito é bug report do runner novo, não sinal de def. Asserts congelados em scripts/ci/tests/ quebram em CI se a calibração drifar."
	}

	consequences: """
		Positivas:

		(P1) A classe de disparo-artefato do #196 morre por construção:
		def e self-reviews nunca mais contam para o próprio sensor;
		pattern sem escopo não passa no cue vet.

		(P2) Sinais sobre artefatos tipados passam a ser lidos da
		ESTRUTURA (predicados nomeados, auditáveis, versionados em
		localização canônica única) em vez de regex sobre o texto.

		(P3) O gate de carência (adr-162, ligado desde #184) volta a
		valer de fato: nenhum trigger gateável fica escondido atrás de
		um warn-only anterior.

		(P4) Runner testável: extração para módulo + suite com fixtures
		git torna cada mecânica de contagem verificável isoladamente —
		primeira cobertura de teste de tooling shell/python do repo.

		Negativas:

		(N1) Registry novo é superfície nova de governança (singleton +
		4 entries). Mitigação: schema inline com rationale obrigatório;
		só cresce quando def novo precisar de predicado.

		(N2) Asserts congelados dos 4 predicados quebram quando o repo
		evolui legitimamente (e.g., nova bootstrap exception muda 24).
		Aceito deliberadamente como tripwire de calibração — quebra é
		sinal para recalibrar o assert conscientemente, não silêncio.

		(N3) Migração toca 15 arquivos def de uma vez. Mitigação:
		commit atômico separado, conferência linha-a-linha contra a
		tabela aprovada antes do commit.

		Fronteira regulatória: nenhuma. Decisão é meta-estrutural sobre
		o mecanismo de vigilância de deferimentos.
		"""

	affectedArtifacts: [
		"architecture/artifact-schemas/deferred-decision.cue",
		"scripts/ci/evaluate-deferred-triggers.sh",
		".github/workflows/validate.yml",
		"governance/claude/config.cue",
		"architecture/deferred-decisions/def-001-promote-plannedoutputs-to-required.cue",
		"architecture/deferred-decisions/def-004-formalize-tq-as-05-or-convert-references.cue",
		"architecture/deferred-decisions/def-005-policy-cross-bc-execution.cue",
		"architecture/deferred-decisions/def-006-policy-cross-bc-sync.cue",
		"architecture/deferred-decisions/def-009-policy-lifecycle-versioning.cue",
		"architecture/deferred-decisions/def-010-convention-central-schema-centralization.cue",
		"architecture/deferred-decisions/def-012-bootstrap-exception-stale-detection-sc.cue",
		"architecture/deferred-decisions/def-013-envelope-governance-typing-maturity.cue",
		"architecture/deferred-decisions/def-015-task-output-temporality-metadata.cue",
		"architecture/deferred-decisions/def-016-cross-bc-decision-attestation-enforcement.cue",
		"architecture/deferred-decisions/def-030-pg-coverage-design-principle.cue",
		"architecture/deferred-decisions/def-031-cross-context-flow-closure-oracle.cue",
		"architecture/deferred-decisions/def-032-adr-falsification-condition-field.cue",
		"architecture/deferred-decisions/def-035-agent-probe-coverage-residual.cue",
		"architecture/deferred-decisions/def-064-spec-runtime-propagation-ladder.cue",
	]

	plannedOutputs: [
		"scripts/ci/evaluate_deferred_triggers.py",
		"governance/build-time/dd-predicates.cue",
		"scripts/ci/tests/test_evaluate_deferred_triggers.py",
		"governance/build-time/task-specs/wi-147.cue",
		"governance/build-time/work-events/wi-147.cue",
	]

	principlesApplied: [
		"P10",
		"P12",
	]

	supersedes: []

	rationale: """
		P10 (agentes estocásticos recomendam, gates determinísticos
		validam): o sensor determinístico estava produzindo sinal falso
		— pior que ausência de sensor, porque induz decisão errada com
		aparência de evidência (caso #196). Corrigir o motor restaura a
		premissa do P10 para todo o sistema de deferimentos.

		P12 (governança como código): escopo vira constraint de schema
		(cue vet é o gate de malformação), exclusões viram invariante de
		engine, predicados viram artefato CUE nomeado e versionado —
		nenhuma das três correções depende de disciplina de autoria.

		Sem axiomas tensionados. Sem lente: a decisão deriva diretamente
		de defeito mecânico comprovado com evidência em disco (#196 +
		pre-flight 2026-07-03), não de trade-off aberto entre forças.

		Relação com outras ADRs: DESCENDS adr-062 (sistema de
		deferimentos + runner) e adr-071 (precedente de expansão de
		kind do #Trigger via ADR; o kind file-content-occurrence-count
		do def-012 é substituído por structural-predicate — o kind
		PERMANECE no schema para uso singleton futuro, uso atual migra).
		PRESERVA adr-162 (gate de carência) corrigindo seu enforcement.
		SEM supersession.

		Justificativa de risk metadata: reversibility 'medium' —
		schema/runner são revertíveis, mas a migração de 21 triggers em
		15 defs torna o revert um segundo flag-day. blastRadius
		'cross-cutting' — afeta todos os #DeferredDecision (74) via
		contrato de declaração + runner + CI, sem tocar schemas de
		domínio.
		"""
}
