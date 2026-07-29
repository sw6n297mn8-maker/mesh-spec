package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

stakeholderMapSchemaAdr181Extension: build_time.#SelfReviewReport & {
	reportId: "srr-stakeholder-map-schema-adr-181-extension"

	artifactPath:       "architecture/artifact-schemas/stakeholder-map.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-29"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		Round único com veredito estável do próprio reviewer isolado: zero
		findings formais no round 1 (todos os uq avaliáveis + tq-as-01..03
		declarados PASS com justificativa individual), com 1 recomendação
		editorial residual — verificada na fonte pelo main agent,
		confirmada real e INCORPORADA na mesma passada (3 comentários com
		lista stale de categorias obrigadas passam a apontar a lista
		canônica no tq-sm-04); o round de estabilização do ADR-irmão
		re-verificou depois, contra a versão corrigida, que o schema segue
		sem precedente e sem membership no comentário (greps = 0). Rounds
		adicionais não teriam objeto.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Sub-agente isolado (rollout artifact-schema → isolated-subagent)
			revisou o DELTA por diff contra a versão vigente: (1) enum
			#StakeholderCategory 6→7 (+adversarial-actor-class com
			comentário que define a classe e cita adr-181, SEM membership —
			ajuste do founder no Gate 2 confirmado por grep sh-06 = 0); (2)
			tq-sm-04 com 4 obrigadas e as MESMAS 3 isentas (frase
			byte-idêntica à vigente), severity fail intocada, rationale
			carregando a N3. Diff confirmado restrito ao delta declarado.
			Testes empíricos em scratch: cue vet exit 0; instância
			re-autorada UNIFICA (sh-06 concreto na categoria nova); sonda
			adversarial (categoria fora do enum) REJEITA com 7 disjuncts na
			mensagem; contagem 6 vigente / 7 draft por dupla via. uq-03
			condicionado ao commit conjunto com o adr-181 — satisfeito por
			construção (dec 4: mesmo commit). Advisory residual (sem
			criterionId): comentários das linhas ~35/165/279 mantinham a
			enumeração antiga das obrigadas — verificado na fonte,
			INCORPORADO (apontam a lista canônica no tq-sm-04, coerente com
			P0 e com o adr-181 dec 3, que veda alterar categorias/
			relationships/critérios — comentário não é nenhum dos três).
			"""
	}]

	findings: {}

	summary: """
		Extensão do schema autorizada pelo adr-181 (mesmo commit),
		revisada em modo isolated-subagent com validação empírica: o enum
		permanece exaustivo (7 valores), a obrigação de vetores acompanha
		a essência da classe (tq-sm-04 com a N3 do founder), e os
		comentários satélites do arquivo apontam a lista canônica — zero
		prosa stale no próprio arquivo após o advisory incorporado.
		"""
}
