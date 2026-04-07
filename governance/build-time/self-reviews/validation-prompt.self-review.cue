package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

validationPrompt: build_time.#SelfReviewReport & {
	reportId: "srr-validation-prompt"

	artifactPath:       "architecture/artifact-schemas/validation-prompt.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-04-07"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Avaliação executada por sub-agente isolado conforme
			executionPolicy.rollout em quality-gate.cue (artifact-schema
			usa modo isolated-subagent). Sub-agente recebeu o conteúdo
			completo da versão proposta de
			architecture/artifact-schemas/validation-prompt.cue após
			edição, paths para o conteúdo atual (para diff conceitual),
			contexto sobre os 9 edits mecânicos coordenados nas
			instâncias validate-*.cue, e instruções para ler
			artifact-schema.cue (meta-schema), quality-gate.cue
			(universalCriteria), design-principles.cue, adr-040 e
			structural-check.cue como referências.

			Avaliação contra 11 critérios (8 universais + 3 type-specific
			de #ArtifactSchema):

			uq-01 (rationale=WHY): rationales adicionados/preservados
			respondem por quê — comentário sobre #ReviewContract justifica
			tipo dedicado vs enum inline ("para que adição futura seja
			decisão explícita registrada em ADR"); rationale do novo
			campo reviewContract justifica obrigatoriedade ("obriga toda
			instância a declarar explicitamente que opera como advisory");
			comentário sobre severity em #ValidationCheck explica por que
			a enum permanece ("apenas a interpretação é reposicionada").
			Pass.

			uq-02 (Mesh-specific): substitution test "Mesh → qualquer
			fintech" falha porque o sistema descrito (ADRs, structural-check
			schema, validation-prompts em diretório próprio, hook
			post-commit, queue) é específico desta spec. Pass.

			uq-03 (referências cruzadas existem): adr-040 verificado em
			architecture/adrs/adr-040-validation-split-structural-vs-design-review.cue;
			architecture/artifact-schemas/structural-check.cue verificado;
			path citado no header está correto. Pass.

			uq-04 (consistência com princípios): a alteração reforça P10
			(gates determinísticos validam, agentes recomendam) —
			formalizar validation-prompts como advisory respeita o axioma
			de que verificações que impõem regras devem ser determinísticas,
			deixando interpretação para camada estocástica advisory.
			Coerente com P12 (governança como código): contrato advisory
			codificado no shape, não apenas em prosa. Pass.

			uq-05 (limitações declaradas): a limitação central — "v1
			admite um único valor" — está declarada explicitamente, com
			nota de que evolução futura exige ADR. A natureza advisory
			como limitação sobre o que o tipo PODE fazer está declarada
			com força. Pass.

			uq-06 (ubiquitous language): termos consistentes — advisory,
			gate, structural, review. "Validation prompts" mantido (não
			rebatizado), consistente com a intenção de mudança mínima.
			Sem mistura de sinônimos intra-arquivo. Pass.

			uq-07 (zero placeholder): nenhum TODO/TBD. Pass.

			uq-08 (conforma com seu artifact schema): _schema.location
			preenchido (preservado, não alterado estruturalmente);
			_qualityCriteria mantém shape conforme #QualityCriteria;
			nenhum campo do meta-schema removido. Pass.

			tq-as-01 (declara localização canônica): _schema.location
			permanece presente e completo (canonicalPathRegex,
			fileNameRegex, description, rationale, cardinality,
			allowNested). Edições textuais em description e rationale
			não removem nem alteram a estrutura. Pass.

			tq-as-02 (critérios type-specific acionáveis): tq-vp-01/02/03
			são acionáveis e mantêm shape original. As edições nos
			rationales (acrescentar menção a structural-check e advisory)
			não tornam os tests menos concretos. tq-vp-01 ganha precisão
			ao excluir explicitamente o que pertence a structural-check.
			Pass.

			tq-as-03 (rationale do conjunto explica cobertura):
			_qualityCriteria.rationale explica cobertura coletiva ("valor
			semântico genuíno como revisão advisory, são auto-contidos
			via references, e estão alinhados com tipos que validam") —
			não é mera repetição dos rationales individuais. Pass.

			Sete observações de design reportadas pelo sub-agente, todas
			confirmando intencionalidade (nenhuma é finding):
			(1) coerência minimal com adr-040; (2) mudança breaking
			gerenciada no mesmo commit via 9 edits mecânicos —
			recomendação operacional de confirmar via glob exatamente
			9 instâncias (executada: glob retornou 9 paths esperados);
			(3) tipo dedicado #ReviewContract bem-fundamentado; (4)
			severity mantida no #ValidationCheck com nota de futura
			pressão por renomeação no longo prazo (não para esta etapa);
			(5) header reposicionado coloca o contrato antes do shape;
			(6) #ValidationTargetType inalterado, "self-review-report"
			ainda válido sob regime advisory (observação para reflexão
			futura); (7) tq-vp-01 fortalecido pela edição que acrescenta
			"structural-check" no rationale, coerência interna preservada.
			"""
	}]

	findings: {}

	summary: """
		Alteração em validation-prompt.cue formaliza o reposicionamento
		decidido em adr-040: validation-prompts perdem autoridade de
		gate e passam a ser explicitamente advisory. Mudanças mínimas
		— cabeçalho expandido citando adr-040, novo tipo #ReviewContract
		dedicado com 1 valor permitido (advisory-only), novo campo
		obrigatório reviewContract no #ValidationPrompt, comentário
		curto antes de severity no #ValidationCheck reposicionando
		interpretação. Shape de checks, _schema.location e
		_qualityCriteria preservado em estrutura. Mudança breaking
		gerenciada no mesmo commit com edits mecânicos em todas as
		9 instâncias validate-*.cue (existência das 9 confirmada via
		glob). Estável em 1 round — todos os 11 critérios passam,
		zero findings, sete observações de design confirmando
		intencionalidade.
		"""

	singleRoundRationale: """
		Alteração foi moldada por diálogo iterativo com founder antes
		do drafting. Founder revisou 7 pontos de design (nome do campo,
		tipo dedicado, ausência de novo critério, atualização das 9
		instâncias no mesmo commit, sem refator de checks, isolated-subagent
		para schema, sem self-review por instância) e aprovou todos
		antes desta avaliação. Sub-agente isolado avaliou o conteúdo
		final sem acesso ao histórico do diálogo, leu o meta-schema
		artifact-schema.cue, quality-gate.cue, design-principles.cue,
		adr-040 e structural-check.cue diretamente, e produziu
		veredito ESTÁVEL com zero findings e recomendação operacional
		(confirmação de 9 instâncias via glob — executada com sucesso).
		Critérios são objetivamente verificáveis por inspection direta:
		conformance ao meta-schema é estrutural; acionabilidade dos
		critérios type-specific é verificável pelos testes concretos;
		cobertura do rationale do conjunto é verificável pelo texto.
		Não houve ambiguidade pendente que justificasse round adicional.
		"""
}
