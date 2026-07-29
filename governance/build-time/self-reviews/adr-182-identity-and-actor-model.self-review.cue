package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr182IdentityAndActorModel: build_time.#SelfReviewReport & {
	reportId: "srr-adr-182-identity-and-actor-model"

	artifactPath:       "architecture/adrs/adr-182-identity-and-actor-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-29"

	roundsExecuted: 3
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 3
		warnCount: 0
		infoCount: 0
		summary: """
			Sub-agente isolado (rollout adr → isolated-subagent) avaliou o
			draft com verificação de fidelidade cross-file integral (18
			atribuições nominais contadas por grep; mecanismo de
			governance-version; disciplina do envelope; def-024/def-080;
			personas do WI-157; idc/bdg; adr-172; lens-ai-agent-governance;
			coerência ADR↔irmãos da fatia item a item) + o grep do dp-10
			pedido pelo founder: dp-10 NÃO vive em design-principles — vive
			em domain/domain-definition.cue:417, statement fiel ao uso do
			ADR. 3 fails uq-03, todos verificados na fonte pelo main agent e
			CONFIRMADOS: (F1) 'a palavra tenant só aparece em lenses e na
			task-spec' era falso — o PRÓPRIO reversibilityThreshold de
			domain-definition contém 'isolamento entre tenants' (o critério
			que a escalação satisfaz) e P9 usa tenant_id; corrigido para
			'nenhum artefato define a SEMÂNTICA'; (F2) 'organizationRef'
			era pseudo-identificador inexistente — corrigido para a língua
			real do npm (term-participante; 'NPM é SoT do participante'),
			com BÔNUS: o quote verbatim do npm glossary:34 ('Usuário é
			pessoa física que opera em nome de um participante... Gestão de
			identidade de pessoas vive em IDC') entrou no dec 5 — a linha
			que o modelo já traçava, promovida a decisão; (F3) o quote do
			campo version estava atribuído ao singleton — corrigido para a
			docstring do SCHEMA + 'tq-gv' → 'tq-gv-12'. Obs-2 do reviewer
			(executedVia semanticamente vazio sob kind=agent) ACEITA como
			aperto e depois SANCIONADA pelo founder no OK da escrita: veto
			por shape no envelope irmão, com sonda adversarial rejeitando e
			regressão verde.
			"""
	}, {
		round:     2
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			Round de estabilização com provas mecânicas próprias do reviewer
			(vet exit 0; sonda adversarial do veto re-executada em cópia
			isolada — exit 1 no guard exato; regressão preservando o caso
			legítimo humano+executedVia). F1/F2 RESOLVIDOS limpos (frase
			nova verdadeira contra domain-definition E design-principles P9;
			quote npm conferido caractere a caractere); F3 resolvido na
			substância com 1 RESÍDUO de 2 tokens: '#AgentGovernance' não
			existe (o def real é #AgentGovernanceGlobal) e um 'tq-gv'
			pré-existente sobrou no rationale. Zero regressão nos 13
			critérios; Obs-2 sem incoerência (nenhum caso legítimo do repo
			contradito; delegação agente→agente futura coberta pela
			falsificação (b)).
			"""
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Aplicação mecânica do resíduo (#AgentGovernanceGlobal; tq-gv-12
			no rationale) — ambas as fontes já verificadas nos rounds
			anteriores; cue vet exit 0. Estabilidade atingida per o veredito
			pré-declarado do próprio reviewer no round 2 ('aplicada como
			está, o artefato atinge estabilidade sem necessidade de nova
			rodada de leitura de fontes').
			"""
	}]

	findings: {}

	summary: """
		adr-182 autorado via manualAuthoringProtocol (PG-ADR, 3 section
		gates) na sessão 2026-07-29: Gate 1 confirmado (foundational —
		calibração explícita do founder: 'vocabulário-base do sistema' —
		/founder/accepted/low/cross-cutting/supersedes vazio; os 2 alertas
		de regime aceitos como enquadrados); Gate 2 confirmado com a
		ESCALAÇÃO FORMAL de irreversibilidade do tenant decidida (Opção B
		com condição do invariante de escopo-por-organização) + lar do ator
		(a)/ten-016 + def-082/def-080; Gate 3 confirmado com os 3
		refinamentos incorporados (critério tríplice do roleRef;
		underGovernance versionado moldado pela Q4 da lens-ai-agent-
		governance; N1 de primeira classe como condição da escolha B) + a
		verificação pedida pelo founder executada na fonte ANTES da
		consolidada (mecanismo de versão dos governance envelopes — existe;
		reportado verbatim). Pipeline isolated: 3 rounds (3+1 fails, todos
		verificados na fonte antes de aplicar), estável em 3/4. Veto de
		executedVia sob kind=agent sancionado explicitamente pelo founder.
		Evidência uq-09 (Camada 3) registrada aqui e nos roundDetails.
		"""
}
