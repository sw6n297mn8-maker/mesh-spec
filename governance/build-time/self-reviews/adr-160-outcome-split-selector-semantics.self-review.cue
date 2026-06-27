package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// SRR do adr-160 (semântica de outcome-split: selector roteia, guards terminam).
// Revisa a ADR que estende a semântica do estágio aggregate-skeleton (adr-141):
// como o decide() gerado resolve transição colidente via selector + guards
// terminais, e a forma do tipo de retorno (Transitioned / NoApplicableTransition
// / AmbiguousTransition). Autovalidação pré-proposta self-reported (main loop),
// complementada por revisão adversarial isolada (workflow: schema-conformance,
// pg-coverage, quality-gate, fidelity-scope). 1 round, stable.

adr160OutcomeSplit: build_time.#SelfReviewReport & {
	reportId: "srr-adr-160-outcome-split-selector-semantics"

	artifactPath:       "architecture/adrs/adr-160-outcome-split-selector-semantics.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-27"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — autovalidação do adr-160 contra o #ADR (architecture/artifact-schemas/adr.cue)
			e o quality-gate, com verificação factual via Read/grep direto do disco. cue vet ./...
			EXIT=0 (com o schema novo + a ADR).

			[CONFORMIDADE ESTRUTURAL #ADR]: PASS. Todos os campos obrigatórios presentes com valores
			válidos nos enums lidos do schema: decisionClass "structural" (#DecisionClass), decider
			"founder", status "proposed" (#NonSupersededStatus → supersededBy corretamente omitido),
			reversibility "medium" (#Reversibility), blastRadius "cross-cutting" (#BlastRadius),
			date 2026-06-27 (regex ISO), id adr-160 (^adr-[0-9]{3}$, próximo livre — último no disco
			adr-159). falsificationCondition com condition + observableSignal. principlesApplied
			não-vazio.

			[tq-adr-01 alternativas]: PASS. context traz "Alternativas avaliadas: (a)(b)(c)" — cada
			uma com razão de rejeição substantiva (sobrecarregar guard / ordenar transições / guard
			composto), não tautológica: cada alternativa quebra no caso de guards idênticos
			escalated→authorized/refused ou colapsa o vocabulário recuperável-vs-terminal.

			[tq-adr-02 metadata de risco]: PASS. reversibility/blastRadius/decisionClass cada um
			justificado no rationale (campo optional, esforço moderado / toca schema base + 2 BCs +
			estágio de codegen, não repo-wide / adiciona def + campo + 3 desfechos alterando a relação
			domain-model↔código gerado). Não-genérica.

			[tq-adr-03 affectedArtifacts paths reais]: PASS, com correção aplicada. Os 4 paths existem
			no disco (domain-model.cue schema, fce/dlv domain-models, codegen-contract.cue). adr-141
			foi DELIBERADAMENTE removido de affectedArtifacts — a ADR estende mas NÃO altera adr-141
			(não-amend/não-supersede); a linhagem vive em prosa (context/rationale) + principlesApplied
			"adr-141 — parent", idiom do irmão adr-155→adr-128 (verificado: adr-155 põe adr-128 em
			principlesApplied, não em affectedArtifacts). Sem path fictício.

			[tq-adr-04 impacto rastreável]: PASS. affectedArtifacts não-vazio.

			[uq-01 rationale=por quê / uq-02 especificidade-Mesh]: PASS. rationale e cada entry de
			principlesApplied registram POR QUE (não o quê). Especificidade: selector/guard, breach-
			bypasses-escalation, p11-invariant-breach-detected, transições nomeadas de FCE/DLV — o
			texto quebra sob substituição por "qualquer fintech".

			[FRONTEIRA / piso]: PASS. A ADR declara fronteira spec-only no corpo (itens 7/8: não toca
			skeleton.go nem runtime nem o handler resolve-guard-escalation/auth). O argumento do piso
			foi exercitado: o selector da exceção roteia o residual amplo (incl. breach) ao candidato
			e o guard terminal breach-bypasses-escalation — que JÁ existe na transição guarded→escalated
			do FCE — rejeita o breach → freeze. A barreira do piso não se move; as duas barreiras
			(roteamento + invariante terminal) ficam restauradas. O sinal de freeze é recuperável via
			attempts[].failedGuard de NoApplicableTransition.

			[FORMA DO TIPO / determinismo]: PASS. Três desfechos de decide() como sum-type fechado:
			Transitioned; Rejected.NoApplicableTransition{attempts:[{to, failedGuard?, failedSelector?}]};
			AmbiguousTransition (erro de determinismo, FORA de Rejected). Cobre FCE+DLV (mesmo template).

			Residual transparente (não-finding): N2 declarado nas consequências — a obrigatoriedade-em-
			colisão do selector e a exclusividade mútua dos selectors de um par NÃO são enforçadas por
			cue vet (campo optional); ficam para structural-check de fatia posterior. É limitação de
			design declarada, não defeito do artefato. Sem finding fail/warn/info.
			"""
	}]

	findings: {}

	summary: """
		SRR do adr-160 — ADR estrutural que estende a semântica do estágio aggregate-skeleton (filho
		de adr-141, não-amend/não-supersede): define como o decide() gerado resolve transição
		COLIDENTE (mesmo (from, triggeredByCommand) com >1 destino) via selector de roteamento
		separado dos guards (invariantes terminais), e fixa a forma do tipo de retorno (Transitioned
		/ NoApplicableTransition com attempts / AmbiguousTransition). Acompanha mudança mínima de
		schema (#TransitionSelector + selector? opcional no #StateTransition). Autovalidação self-
		reported, complementada por revisão adversarial isolada (workflow de 4 críticos: schema-
		conformance, pg-coverage, quality-gate, fidelity-scope).

		VEREDITO: 0 fail / 0 warn / 0 info, stable em 1 round. Conformidade #ADR PASS (enums válidos,
		status proposed → supersededBy omitido). tq-adr-01 PASS (3 alternativas com rejeição real).
		tq-adr-02 PASS (risco calibrado e justificado). tq-adr-03 PASS com correção: adr-141 fora de
		affectedArtifacts (não é alterado — linhagem em prosa + principlesApplied, idiom adr-155→
		adr-128); os 4 paths restantes existem no disco. tq-adr-04 PASS. uq-01/uq-02 PASS (rationale=
		por quê; especificidade-Mesh). Fronteira spec-only declarada no corpo. Piso preservado POR
		CONSTRUÇÃO: breach roteado ao candidato mas barrado pelo MESMO guard terminal breach-bypasses-
		escalation de hoje → freeze; sinal recuperável nos attempts. cue vet ./... EXIT=0. Residual
		transparente: N2 (enforcement de presença/exclusividade do selector em par colidente fica para
		structural-check de fatia posterior) — limitação declarada, não defeito.
		"""

	singleRoundRationale: """
		Estabilizou em 1 round porque o ataque central — o piso inoverridável sob a nova semântica de
		outcome-split — foi desenhado para NÃO mover a barreira: enumerei que o único alvo perigoso
		(guarded→escalated para um input de breach) é barrado pelo guard terminal breach-bypasses-
		escalation que JÁ existe na transição, com o selector apenas roteando o residual amplo até ele;
		logo a separação selector/guard restaura as duas barreiras em vez de enfraquecer o piso, e o
		sinal de freeze fica recuperável nos attempts de NoApplicableTransition. As demais dimensões
		(conformidade #ADR com enums lidos do schema; tq-adr-01..04; uq-01/02; fronteira spec-only)
		deram PASS na primeira passada, cada afirmação factual verificada via Read/grep do disco
		(enums do #ADR, existência dos 4 affectedArtifacts, ausência do campo selector nas instâncias,
		o idiom adr-155→adr-128 para o parent em principlesApplied). A única correção surgida na
		autovalidação — remover adr-141 de affectedArtifacts — foi aplicada ANTES da escrita, então não
		restou delta a re-verificar num 2º round. cue vet ./... EXIT=0; nenhum finding exigia re-rodada.
		"""
}
