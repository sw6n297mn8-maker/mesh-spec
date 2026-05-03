package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr040: artifact_schemas.#ADR & {
	id:    "adr-040"
	title: "Split validation into deterministic structural verification and interpretive design review"
	date:  "2026-04-07"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		O protocolo de validação descrito em CLAUDE.md seção
		Validação e formalizado em governance/build-time/quality-gate.cue
		atribui ao mecanismo de validation-prompts (vp-canvas,
		vp-glossary, vp-domain-model, vp-agent-spec, etc.) o
		papel de gate semântico após commit: findings com
		severity fail bloqueiam o fluxo até resolução ou
		aceitação explícita. A implementação concreta desse
		mecanismo é um prompt LLM executado em contexto isolado
		sobre o artefato commitado.

		Durante a validação do canvas IDC (commit acddea6) duas
		propriedades observáveis do mecanismo entraram em atrito
		com o papel atribuído: variância nos findings entre
		execuções sucessivas sobre o mesmo artefato, e falso
		positivo factual (vc-cv-03 reportou ausência do bloco
		communication quando o bloco existia e podia ser
		literalmente citado). A tensão foi registrada em
		ten-006-validation-non-determinism (kind:
		cross-artifact-friction, status: open).

		Diagnóstico: a tensão não está em um validation-prompt
		individual nem em qualidade de prompt engineering.
		Está na atribuição de um papel determinístico (gate)
		a um mecanismo cuja natureza é interpretativa (LLM
		sobre prompt). Mesh distingue categoricamente
		verificação determinística de julgamento interpretativo
		— P10 ("agentes estocásticos recomendam, gates
		determinísticos validam") aplicado ao próprio sistema
		de validação. O mecanismo atual viola P10 internamente:
		um agente estocástico opera como gate.

		Alternativa considerada e rejeitada: disciplinar o LLM
		mantendo-o como autoridade de gate via typed findings,
		consensus por múltiplas execuções, evidence requirement,
		uncertain-reading como fallback, openQuestions como
		zona protegida, e separação de modos gate vs análise
		dentro do mesmo artefato. Rejeitada como solução final
		porque mitiga sintomas sem corrigir a confusão de
		categoria — mantém um mecanismo único acumulando
		propriedades incompatíveis (determinismo + interpretação)
		e a fronteira continua dependendo de disciplina interna
		do LLM. Os elementos úteis dessa proposta (typed
		findings, openQuestions protection, evidence citation)
		são reaproveitados como mecânica interna do revisor
		interpretativo, não como tentativa de transformar LLM
		em gate.
		"""

	decision: """
		Validation is split into deterministic structural
		verification and interpretive design review. Only
		structural verification participates in CI gating.

		Esta decisão tem quatro componentes operacionais:

		(1) O que é estrutural. Verificação determinística de
		fatos decidíveis sobre artefatos: presença de blocos
		obrigatórios, validade de cross-references (sh-NN,
		oq-NN, ax-NN, ten-NNN, adr-NNN), conformidade com
		schema CUE, cardinalidade, naming, consistência
		referencial entre blocos do mesmo artefato. Regras
		estruturais são declaradas em CUE e produzem output
		binário pass/fail. Não há severity warn no mecanismo
		estrutural na primeira versão — estrutural é gate, e
		gate é binário. Structural verification será modelada
		em schema dedicado e regras declarativas separadas dos
		prompts interpretativos. O path concreto, o shape do
		schema e a primeira implementação serão introduzidos
		em commits subsequentes; esta ADR não cristaliza esses
		detalhes como parte do núcleo decisório.

		(2) O que é interpretativo. Julgamento sobre qualidade
		de design que não é decidível mecanicamente: força da
		incentive analysis, conformidade interpretativa com
		princípios (P10, dp-08, etc.), aplicação de lenses,
		ausências de design não capturáveis por schema,
		smells de boundary ou de moat. Vivem nos atuais
		validation-prompts (renomeação semântica para "design
		review prompts" — renomeação física do diretório é
		cosmética e pode ser feita depois). Output são
		hipóteses para review do founder, nunca veredito.

		(3) Quem consome cada saída. Estrutural alimenta CI
		gating: pre-commit hooks, post-commit verification,
		eventualmente CI server. Falha estrutural bloqueia
		merge/commit. Interpretativo alimenta founder review:
		findings são input para decisão humana, nunca
		bloqueiam pipeline, nunca emitem fail de CI.

		(4) Ordem de execução. Estrutural roda primeiro.
		Interpretativo só roda sobre artefatos que passaram
		em estrutural. Interpretativo nunca re-verifica o
		que estrutural já cobre — duplicação é proibida por
		contrato.

		Reposicionamento imediato (transição): a partir desta
		ADR, nenhum validation-prompt LLM possui autoridade
		de gate, mesmo antes da refatoração completa dos
		artefatos existentes. Findings produzidos por eles
		são tratados como advisory: nenhum bloqueia commit,
		nenhum é tratado como veredito factual. Findings
		interpretativos são input para founder. Findings
		sobre presença ou ausência factual de elementos do
		artefato são tratados como sujeitos a verificação
		manual antes de qualquer ação. Esse reposicionamento
		é semântico — não exige refator de código nem de
		schema para entrar em vigor; entra em vigor pela
		aceitação desta ADR.

		Os elementos úteis da alternativa rejeitada (typed
		findings, openQuestions protection, evidence citation
		requirement) são preservados como mecânica interna
		do revisor interpretativo no refator subsequente do
		schema validation-prompt. Eles deixam de ser
		tentativas de fazer LLM virar gate e passam a ser
		disciplinas internas de qualidade do output advisory.

		O split é de categoria, não apenas de implementação.
		Mesmo que no futuro um novo motor de validação
		semântica reduza a variância de LLM, a separação
		entre verificação determinística e julgamento
		interpretativo permanece como decisão arquitetural
		— porque as duas categorias respondem perguntas
		epistemologicamente diferentes, têm consumidores
		diferentes, e exigem garantias diferentes.
		"""

	consequences: """
		Positivas:

		(1) Aplicação interna de P10. O sistema de validação
		passa a respeitar a mesma fronteira que ele próprio
		ajuda a impor sobre o resto da Mesh. Coerência
		arquitetural entre mecanismo e princípio.

		(2) Eliminação estrutural do falso positivo factual.
		Checks como "bloco existe" deixam de ser perguntados
		ao LLM — são verificados por mecanismo determinístico.
		O caso vc-cv-03 torna-se impossível por construção,
		não por disciplina de prompt.

		(3) Auditabilidade do gate. "Commit bloqueado pela
		regra X de structural-check Y" é defensável em
		contexto regulatório. "LLM achou o design fraco"
		não é. Estrutural ganha rastreabilidade real.

		(4) Eliminação da necessidade de consensus runs,
		uncertain-reading, e mode toggles. Esses mecanismos
		existiam para tentar disciplinar variância de LLM
		dentro de um papel incompatível. Removida a
		atribuição de gate ao LLM, removidos os mecanismos
		compensatórios.

		(5) Honestidade sobre openQuestions. O revisor
		interpretativo sabe que openQuestions são
		incompletude declarada e não as penaliza. O
		estrutural só verifica que openQuestions
		referenciadas em invariantes existem como entries
		no bloco openQuestions — fato decidível.

		(6) Escalabilidade do padrão. Cada novo tipo de
		artefato (canvas, glossary, domain-model, agent-spec,
		governance envelope) ganha o mesmo split: regras
		formais → structural-check, julgamentos → design
		review. Gramática sistêmica reutilizável, não prompt
		cada vez mais inchado.

		Negativas:

		(1) Custo de infraestrutura. Criação de schema novo,
		primeiras regras concretas para canvas, e eventual
		runner determinístico que executa as regras. Trabalho
		não-trivial, mas amortizado por todos os tipos de
		artefato futuros.

		(2) Risco de fronteira mal desenhada. Se regras
		"quase interpretativas" vazarem para structural-check,
		subjetividade reentra pelo gate. Se o revisor
		interpretativo continuar checando presença de blocos,
		duplicação reentra. Mitigação: a primeira versão do
		schema estrutural deliberadamente conservadora — só
		regras inquestionavelmente decidíveis.

		(3) Janela de transição com revisor interpretativo
		ainda no formato antigo. Entre a aceitação desta ADR
		e o refator do vp-canvas/etc., os prompts continuam
		executáveis mas semanticamente rebaixados. Risco de
		ambiguidade institucional mitigado pelo
		reposicionamento explícito declarado em decision.

		(4) Trabalho de migração não capturado nesta ADR.
		Atualização de CLAUDE.md seção Validação,
		governance/build-time/quality-gate.cue, e refator
		dos validation-prompts existentes pertencem a
		ADRs/commits subsequentes. Esta ADR estabelece a
		categoria; a implementação é faseada.

		(5) ten-006 não move automaticamente para resolved
		por esta ADR. A resolução estrutural só se completa
		quando o schema estrutural existe e contém regras
		que cobrem o caso vc-cv-03 (presença de bloco
		obrigatório). Até lá, ten-006 permanece open com
		relatedADR apontando para esta decisão.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"governance/build-time/quality-gate.cue",
		"CLAUDE.md",
	]

	plannedOutputs: [
		"architecture/tension-log/ten-006-validation-non-determinism.cue",
	]

	derivedArtifacts: [
		"architecture/artifact-schemas/structural-check.cue",
		"architecture/structural-checks/canvas.cue",
		"architecture/artifact-schemas/validation-prompt.cue",
		"architecture/validation-prompts/validate-canvas.cue",
		"architecture/validation-prompts/validate-glossary.cue",
		"architecture/validation-prompts/validate-domain-model.cue",
		"architecture/validation-prompts/validate-agent-spec.cue",
		"architecture/validation-prompts/validate-adr.cue",
		"architecture/validation-prompts/validate-artifact-schema.cue",
		"architecture/validation-prompts/validate-domain-definition.cue",
		"architecture/validation-prompts/validate-agent-governance.cue",
		"architecture/validation-prompts/validate-self-review-report.cue",
	]

	principlesApplied: [
		"P10",
		"P12",
	]

	rationale: """
		ADR responde diretamente a ten-006. A tensão
		registrou o fato arquitetural (variância de LLM
		incompatível com gate); esta ADR formaliza a
		correção de categoria. Sem ADR, a tensão ficaria
		eternamente open; sem a tensão, a ADR pareceria
		opinião solta. As duas peças funcionam em par.

		decisionClass structural porque cria categoria nova
		(structural verification como mecanismo distinto),
		reposiciona contrato existente (validation-prompts
		perdem autoridade de gate), e altera contrato de
		governança que múltiplos artefatos consomem. Não é
		foundational porque não muda base do sistema (P0-P12
		permanecem); é structural porque altera relações
		entre artefatos.

		reversibility medium: schema novo e regras serão
		reversíveis sem custo de dados. Refator do
		quality-gate.cue e CLAUDE.md exige ajuste
		coordenado. Reposicionamento semântico de
		validation-prompts não tem custo de dados, mas
		altera contrato que agentes futuros assumem.
		Não é low porque nada persistido entra em jogo;
		não é high porque há propagação coordenada
		necessária.

		blastRadius cross-cutting porque atinge múltiplos
		domínios (architecture/, governance/, e contrato
		que todos os BCs consomem ao validar seus
		artefatos). Não é repo-wide porque não toca CI
		pipeline ainda nem todo BC individualmente.

		Princípios aplicados: P10 é a peça central — o
		split é literalmente P10 aplicado ao próprio
		sistema de validação ("estocásticos recomendam,
		gates determinísticos validam"). P12 ancora a
		decisão de manter governança como código
		executável (regras estruturais em CUE, não em
		prosa).

		Esta ADR é o ponto-âncora da sequência de
		migração. Schema estrutural, primeiras regras,
		refator de quality-gate.cue, refator de
		validation-prompts, e atualização de CLAUDE.md
		são todos consequência desta decisão e serão
		registrados como commits subsequentes (alguns
		possivelmente exigindo seus próprios ADRs derivados
		se tocarem schema existente em forma semanticamente
		significativa).
		"""
}
