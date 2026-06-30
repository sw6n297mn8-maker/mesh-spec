package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// SRR do adr-164 (durabilidade-através-de-restart como capability-contract dos
// adapters persistentes do EventLogPort + EvidencePort; impl no mesh-runtime).
// Self-review em subagente ISOLADO (rollout adr→isolated-subagent; sem o histórico
// da conversa). 1 round, stable. 0 fail. 1 warn editorial (ligar item b↔f) CORRIGIDO
// antes da proposta.

adr164DurabilityContract: build_time.#SelfReviewReport & {
	reportId: "srr-adr-164-durability-across-restart-capability-contract"

	artifactPath:       "architecture/adrs/adr-164-durability-across-restart-capability-contract.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-29"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 2
		summary: """
			Round 1 — self-review do adr-164 em SUBAGENTE ISOLADO (sem histórico da conversa) contra
			#ADR + tq-adr-01..04, com verificação factual via Read/grep. cue vet ./architecture/adrs/
			EXIT=0.

			[#ADR conformance / tq-adr-01..04]: PASS. enums válidos (structural/founder/accepted →
			supersededBy omitido; medium/cross-artifact; date ISO; id adr-164 único no disco). tq-adr-01:
			3 alternativas com rejeição (deixar tácito / obligation per-BC / método reopen no Port).
			tq-adr-03/04: derivedArtifacts=[structure-index] non-empty e real (existe no disco);
			affectedArtifacts=[] legítimo (padrão de adr-141: decisão cuja atividade é cross-repo).

			[Proveniência — 8 alegações verificadas no disco, 0 fabricações]: adr-141 item 6 (in-memory
			é oracle, l.41) e item 2 (DeliveryPort "transporte durável, não-SoT" + lease/ack/redelivery,
			l.33/41); P7 (l.123) e P10 (l.166) fiéis ao texto; adr-148 = fronteira capacidade/implementação;
			def-041 e def-045 existem; pm-cmt rationale "genérico → suíte do Port, não per-BC" (l.59);
			contract-tests atuais NÃO provam durabilidade (grep exaustivo no runtime: zero teste de
			restart/reopen — único "survives" é content-addressability sob mutação); DeliveryPort NÃO
			materializado (só EventLogPort.kt + EvidencePort.kt; nenhum manifest o consome).

			[4 pontos críticos do desenho]: PASS. (a) fronteira spec×runtime honrada — item (f) remete
			kit/harness/regra-de-CI ao runtime; (b) Port NÃO muda — item (d) sem método reopen, Port só
			cruzado por value classes (P7); (c) enforcement como PRINCÍPIO — item (e) declara que a forma
			exata da distinção persistente-vs-referência é decisão de implementação do runtime, sem cravar
			regra-de-string; (d) Delivery suavizado — escopo usa "transporte puramente efêmero é isento" e
			NÃO classifica o DeliveryPort, citando a caracterização durável do disco.

			[WARN-1 encontrado e CORRIGIDO antes da proposta]: o item (b) FORMA DO TESTE descia ao
			procedimento (bit-idêntico, abrir nova instância sobre o mesmo backing) — o ponto mais próximo
			da borda spec×runtime. CORREÇÃO aplicada: frase ligando (b)→(f) ("isto descreve a CAPACIDADE
			observável a provar — não tecnologia: o kit e o harness vivem no mesh-runtime, item f"). Warn
			resolvido; sem warn pendente.

			[INFO-1]: janela de não-enforcement (ADR declarado, kit/regra no arco gated seguinte) é
			follow-up imediato, não deferimento — defersTo corretamente ausente (anti-catch-all). [INFO-2]:
			affectedArtifacts=[] + derivedArtifacts só, padrão idêntico ao de adr-141.
			"""
	}]

	findings: {}

	summary: """
		SRR do adr-164 — ADR structural/accepted que declara durabilidade-através-de-restart como
		capability-contract obrigatória dos adapters persistentes do EventLogPort + EvidencePort
		(prova: kit + harness + regra de CI no mesh-runtime, arco seguinte), fechando o brinde
		não-contratado que o read-only de requisitos achou — pré-requisito de troca de vendor cega
		(def-041/045). Self-review em subagente ISOLADO per rollout adr→isolated-subagent.

		VEREDITO: 0 fail / 0 warn pendente / 2 info, stable em 1 round (1 warn editorial surgido e
		CORRIGIDO antes da proposta: ligar item (b)↔(f)). #ADR conformance + tq-adr-01..04 PASS;
		proveniência 100% verificada no disco (8 alegações, incl. DeliveryPort não-materializado e
		contract-tests sem teste de restart); os 4 pontos críticos passam (fronteira honrada; Port
		não-poluído; enforcement-como-princípio sem regra-de-string; Delivery não-cravado). cue vet
		EXIT=0.
		"""

	singleRoundRationale: """
		Estabilizou em 1 round porque (a) o desenho (incl. os 2 ajustes: enforcement-como-princípio e
		Delivery-suavizado) foi aprovado pelo founder antes da escrita, e (b) a revisão foi por
		subagente ISOLADO (viés de auto-ratificação reduzido) que deu PASS em todas as dimensões de
		fail. Os ataques centrais — escorregar a implementação do kit para o spec, poluir o contrato
		de Port com reopen, cravar regra-de-string no enforcement, ou cravar o Delivery como efêmero —
		foram verificados ausentes no texto. A proveniência das 8 alegações foi confirmada no disco
		(incl. que os contract-tests atuais não provam durabilidade — o brinde). O único achado foi um
		warn editorial de baixa severidade (ligar (b)↔(f)), corrigido ANTES da proposta, sem delta
		semântico a re-rodar. cue vet EXIT=0.
		"""
}
