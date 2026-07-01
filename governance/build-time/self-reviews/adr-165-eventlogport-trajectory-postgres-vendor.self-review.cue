package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// SRR do adr-165 (trajetória do EventLogPort: contrato mínimo agora, ops ricas sob
// gate; ordem-global-latente gap-free como obrigação-de-adapter enforçando P3;
// Postgres como 1º vendor com gatilho de troca por escala em def-072; grafo causal
// como 2ª obrigação P3 envelope-locus rastreada em def-073; resolve def-041).
// Self-review em subagente ISOLADO (rollout adr→isolated-subagent; contexto fresco,
// sem histórico da conversa). 1 round, stable. 0 fail, 0 warn, 1 info.

adr165EventlogportTrajectory: build_time.#SelfReviewReport & {
	reportId: "srr-adr-165-eventlogport-trajectory-postgres-vendor"

	artifactPath:       "architecture/adrs/adr-165-eventlogport-trajectory-postgres-vendor.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-01"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 1
		summary: """
			Round 1 — self-review do adr-165 (+ def-072, def-073, def-041 resolved) em SUBAGENTE ISOLADO
			(sem histórico da conversa) contra #ADR/#DeferredDecision + tq-adr-01..04, com verificação
			factual via Read/grep. cue vet ./architecture/adrs/ ./architecture/deferred-decisions/ EXIT=0.

			[Dim 1 — #ADR conformance / tq-adr-01..04]: PASS. Enums válidos (structural/founder/accepted →
			supersededBy omitido; medium/cross-artifact; date ISO; id adr-165 único no disco);
			principlesApplied com id-prefix estável (P3/P6/P7/P8/P10/adr-164/adr-139). tq-adr-01: 3
			alternativas rejeitadas (rico+FDB / mínimo-puro / escolhida). tq-adr-03: affectedArtifacts
			(def-041) existe. tq-adr-04: os 3 blocos de rastreabilidade populados e reais.

			[Dim 2 — ordem-latente ancorada em P3, não invenção]: PASS. design-principles.cue P3 manda
			literalmente "global_position gap-free" como StructuralInvariant; a decisão (b) do ADR se
			declara ENFORCEMENT de P3, não regra nova.

			[Dim 3 — grafo causal = envelope-locus, NÃO obrigação-de-adapter]: PASS. P3 também manda "grafo
			causal obrigatório"; o envelope atual não carrega causalidade (mesh-runtime EventLogCanon.kt:16
			CanonEvent é marker vazio; grep de causal em adr-141 = 0); o ADR localiza o grafo causal no
			contrato-de-evento+produtor (com o raciocínio anti-erro-de-categoria "o adapter não pode
			fabricar causalidade que o produtor não deu"), rastreia em def-073, e NOMEIA as DUAS obrigações
			P3 para o leitor não concluir que P3 está fechado.

			[Dim 4 — def-041/072/073 sem overlap, gatilhos honestos]: PASS. 3 perguntas ortogonais
			(qual-1º-vendor / troca-por-escala / materialização-causal). Conformidade #DeferredDecision:
			open proíbe resolvedBy (072/073 respeitam); resolved de def-041 com resolvedBy .cue válido;
			manual-review reasons > 40 runes; temporal 180d; MinRunes satisfeitos. cue vet EXIT=0.

			[Dim 5 — fronteira ADR-decide/runtime-implementa]: PASS. O ADR fixa trajetória+obrigação+vendor
			e delega a impl (eventlog-postgres) ao runtime (header + consequences marcam o enforcement
			determinístico como trabalho de runtime), espelhando adr-163→def-071.

			[Dim 6 — proveniência, 0 fabricação]: PASS. Mesh-Old rico 5-op+FDB (§2.2, l.556-588); contrato
			2-op atual (pm-dlv); consumo cross-BC per-fact por ponteiro (adr-149 l.83-84); read-models
			por-agregado (fce/api.yaml, bkr/canvas); ids de princípio P3/P6/P7/P8/P10 mapeiam correto;
			adr-164/adr-139 existem e batem com a glosa.

			[INFO-1]: blastRadius "cross-artifact" é defensável (toca 3 defs + nomeia enforcement de P3);
			um revisor poderia argumentar "cross-cutting" por enforçar princípio de design. Dentro do
			julgamento razoável do autor e coerente com a auto-classificação de def-072; não é defeito.
			"""
	}]

	findings: {}

	summary: """
		SRR do adr-165 — ADR structural/accepted que resolve def-041 no ponto JIT (1º adapter persistente
		em construção) escolhendo a trajetória mínima-com-ordem-global-latente + Postgres como 1º vendor,
		declara a ordem-global-latente gap-free como obrigação-de-adapter (enforcement de P3, contador
		transacional ≠ BIGSERIAL), reserva FDB ao gatilho de escala (def-072), e nomeia o grafo causal
		como 2ª obrigação P3 envelope-locus rastreada em def-073 (não descarregada — erro-de-categoria
		evitado). Self-review em subagente ISOLADO per rollout adr→isolated-subagent.

		VEREDITO: 0 fail / 0 warn / 1 info, stable em 1 round. #ADR + #DeferredDecision conformance +
		tq-adr-01..04 PASS; ordem-latente ancorada em P3 (não invenção); grafo causal tratado como
		envelope-locus (não obrigação-de-adapter); def-041(resolved)/def-072/def-073 ortogonais sem
		overlap; fronteira ADR-decide/runtime-implementa honrada; proveniência 100% verificada no disco
		(Mesh-Old rico, contrato 2-op atual, CanonEvent marker vazio, adr-141 sem causal, adr-149/adr-164/
		adr-139). cue vet EXIT=0. Recomendação do subagente: aceitação sem mudanças.
		"""

	singleRoundRationale: """
		Estabilizou em 1 round porque (a) o desenho — incl. o tratamento do grafo causal (opção A:
		envelope-locus + def-073, não 3ª obrigação-de-adapter) — foi aprovado pelo founder antes da
		escrita, e (b) a revisão foi por subagente ISOLADO (viés de auto-ratificação reduzido) que deu
		PASS em todas as dimensões de fail. Os ataques centrais — inventar a ordem-latente em vez de
		ancorá-la em P3, cometer o erro-de-categoria de tratar o grafo causal como obrigação-de-adapter,
		deixar as duas obrigações P3 implícitas, sobrepor def-041/072/073, ou invadir a implementação
		(SQL/código) no ADR — foram verificados ausentes. A proveniência foi confirmada no disco (0
		fabricação). O único achado foi info (blastRadius cross-artifact vs cross-cutting), julgamento do
		autor, sem delta a re-rodar. cue vet EXIT=0.
		"""
}
