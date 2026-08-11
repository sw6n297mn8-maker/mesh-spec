package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr192: artifact_schemas.#ADR & {
	id:    "adr-192"
	title: "Estabelecer o admission born-reject V2 sobre a abstração canônica de resolução"
	date:  "2026-08-11"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	reversibility: "high"
	blastRadius:   "cross-artifact"

	context: """
		Estado precedente. adr-188 (item 6) e adr-189 prometeram a catraca
		born-reject de admission para o contrato V2 — deferida até o Registry e a
		trust semantics estarem operacionais. C1 ativou o Registry (adr-189), C2
		materializou a resolução na completion (adr-190) e C3a a centralizou em
		#VerifierResolution (adr-191), Mesh-local, pura, com detector R1/R2/R3 no
		workflow required. Restava a peça que consome tudo isso na ENTRADA:
		#MandatoryVerifier está adotado desde a adoção do proof model SEM
		consumidor algum — exatamente o "campo normativo que o motor não
		consulta" que o D7 do protocolo de origem proíbe — e o #TaskTemplate
		local do Mesh não carrega mandatoryVerifiers, então nenhum template pode
		exigir prova por verifier.

		Trigger. C3a estabilizou a abstração compartilhada com UM consumidor
		(completion). O admission é o segundo consumidor previsto pelo próprio
		desenho de C3 — a decisão do founder (2026-08-11) que resolveu def-085.
		Materializá-lo agora fecha o arco: entrada e conclusão da tarefa julgadas
		pela MESMA definição de "verifier resolvível".

		Precedente upstream como REFERÊNCIA NORMATIVA, não adoção. O
		#TaskAdmissionV2 do tekton-spec (adr-009, governance/build-time/
		work-governance.cue) fixa a semântica das duas relações — cobertura de
		mandatoryVerifiers e verifier ativo — mas não é adotável verbatim: o
		#TaskTemplate Mesh é schema LOCAL com shape próprio (kind/preReads/
		steps/qualityGates), e a resolvability Mesh é mais forte (exact-ref com
		revision, via #VerifierResolution) — importar o predicado upstream
		recriaria as duas semânticas de confiança que C3a acabou de eliminar.

		Alternativas avaliadas: (a) adotar o #TaskAdmissionV2 upstream verbatim —
		rejeitada: template incompatível e resolvability mais fraca (sem
		revision); (b) admission só com a relação de cobertura, sem resolvability
		— rejeitada: born-reject parcial — task nomeando verifier revogado ou
		digest divergente seria admitida e impossível de completar, contrariando a
		finalidade da fatia; (c) manter mandatoryVerifiers sem consumidor —
		rejeitada: campo declarativo inerte (violação D7) já materializado no
		repo; (d) copiar a lógica de resolvability para o admission — rejeitada:
		destruiria a centralização de C3a no primeiro uso; o admission INSTANCIA
		a abstração, e R2/R3 do detector barram a cópia por construção.
		"""

	decision: """
		(1) ESCOPO: exclusivamente o admission born-reject V2 e a evolução local
		do #TaskTemplate que ele exige. Nada além.

		(2) EVOLUIR o #TaskTemplate local (architecture/artifact-schemas/
		task-template.cue) com mandatoryVerifiers?: [...#MandatoryVerifier] —
		OPCIONAL, preservando as instâncias existentes por construção (verificado:
		cue vet verde sobre ai-orchestration/ sem tocar as 5 instâncias). Quando
		presente, a cobertura é OBRIGATÓRIA no admission (item 4). Exige por id;
		a task escolhe a versão — a validade da versão pinada é a relação 2.

		(3) CRIAR #TaskAdmissionV2 em governance/build-time/task-spec-v2.cue:
		join estrutural task × template × registry, fail-closed sob cue vet -c,
		na mesma família do #TaskCompletionV2.

		(4) RELAÇÃO 1 — COBERTURA: mandatoryVerifiers(template) ⊆
		verifierIds(requiredEvidence(task)). Template sem o campo não exige nada
		(compat); template com o campo tem cada verifierId coberto por ao menos
		um requirement da task.

		(5) RELAÇÃO 2 — RESOLVABILITY: todo verifierRef declarado em
		requiredEvidence resolve pela abstração canônica #VerifierResolution
		(adr-191) — o join INSTANCIA a abstração e declara a SEGUNDA consumerhood
		canônica (_verifierResolutionConsumer: "task-admission-v2", aninhada, per
		adr-190 item 11). NENHUMA lógica de resolvability é copiada: a
		equivalência admission↔completion sobre "resolve?" é ESTRUTURAL, por
		consumo literal da mesma definição — o cenário-alvo da falsificação de
		adr-191 foi exercitado e a abstração serviu sem vazar internals nem
		exigir mudança.

		(6) COERÊNCIA DE IDENTIDADE DO TEMPLATE: task.templateRef ==
		"\\(template.id)@v\\(template.version)". Sem esta relação, as duas
		anteriores seriam prováveis contra um template ARBITRÁRIO — admission
		"verde" com o template errado é vácuo, não prova. [Adição do agente ao
		envelope aprovado (as duas relações do founder) — trazida explicitamente
		para decisão; provada por fixture e por mutação dedicada.]

		(7) ADMISSION NÃO SUBSTITUI COMPLETION: satisfaz-se na ENTRADA. Uma task
		admitida ainda deve, ao completar, satisfazer cobertura de requirements,
		conclusão verified, verifier componente-a-componente e resolução
		(adr-188/adr-190). Born-reject barra o que nunca deveria entrar; não
		antecipa o juízo de completude.

		(8) def-085 E OS SENSORES HISTÓRICOS: a segunda declaração leva a
		contagem que os triggers históricos observariam a 2 >= 2. VERIFICADO POR
		EXECUÇÃO: o runner pula defs não-open por construção ("SKIP def-085
		(status=resolved)") — nada dispara, nada reabre, zero ruído. O
		comportamento pós-resolução previsto em adr-191 dec 8 está confirmado
		empiricamente, não presumido.

		(9) NÃO DECIDE: o primeiro verifier real (o Registry permanece
		events: [], machine-first per adr-189 dec 6); onde/quando o admission V2
		roda no fluxo de trabalho operacional (a admissão operacional de tarefas
		vive hoje no Linear; este join é o CONTRATO que qualquer executor futuro
		consome, não um segundo lugar de decisão); promoção de qualquer peça ao
		Tekton.
		"""

	consequences: """
		Positivas.
		P1 — mandatoryVerifiers deixa de ser campo inerte: o admission o consulta
		para decidir comportamento — a condição D7 que o repo carregava violada
		desde a adoção fecha aqui.
		P2 — Born-reject real: task que nomeia verifier revogado, deprecated,
		não-registrado ou com digest divergente é rejeitada NA ENTRADA pela mesma
		definição que a rejeitaria na conclusão — a janela "admitida mas
		impossível de completar" fecha para os casos de identidade.
		P3 — A abstração de C3a é provada pelo primeiro uso real: o segundo
		consumidor entrou sem tocar #VerifierResolution, sem acessar internals e
		sem re-derivar — o observableSignal de adr-191 permaneceu verde onde
		poderia ter acusado.
		P4 — Compatibilidade preservada por construção: campo opcional; as 5
		instâncias de template existentes seguem válidas sem edição.

		Negativas.
		N1 — O join não tem executor operacional: nada no fluxo vivo instancia
		#TaskAdmissionV2 automaticamente (a admissão operacional vive no Linear).
		É contrato com suite, não fiscal — deliberado (item 9), mas significa que
		o born-reject só morde quando um executor futuro o consumir.
		N2 — A coerência de identidade (item 6) é sintática sobre a string
		templateRef; um template renomeado quebra a relação de forma correta mas
		ruidosa.
		N3 — Segunda consumerhood no MESMO arquivo do join de completion: a
		contagem por arquivo do detector não distingue os dois (granularidade
		declarada em adr-190/191). O receipt do gate, que dizia "N consumidor(es)"
		contando ARQUIVOS, é corrigido NESTE pacote para redação factual
		file-granular ("N arquivo(s) com consumerhood reconhecível") — logs de CI
		são evidência de governança e não podem afirmar o que o mecanismo não
		mediu. Correção editorial (redação do receipt), sem mudança de contrato.
		"""

	falsificationCondition: {
		condition: """
			Esta decisão estará errada se um par (template, task) legítimo não
			puder ser admitido sem contornar uma das três relações, ou se a
			segunda consumerhood tiver exigido mudança semântica em
			#VerifierResolution — o que falsificaria também adr-191.
			"""
		observableSignal: """
			Fixture legítima rejeitada pelo join sem violação real; ou diff em
			verifier-resolution.cue motivado por necessidade do admission; ou
			R2/R3 vermelhas no arquivo do admission (bypass que a centralização
			deveria ter tornado desnecessário).
			"""
	}

	affectedArtifacts: [
		"architecture/artifact-schemas/task-template.cue",
		"governance/build-time/task-spec-v2.cue",
		"scripts/ci/check-verifier-resolution-consumer-declaration.sh",
		"scripts/ci/tests/test_check_verifier_resolution_consumer_declaration.py",
	]

	plannedOutputs: [
		"scripts/ci/tests/test_task_admission_gate.py",
	]

	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	principlesApplied: ["P0", "P10", "P12", "P14"]

	defersTo: []

	supersedes: []

	rationale: """
		P14 fecha o arco da série: a invariante de entrada (cobertura ∧
		resolvability ∧ coerência) é decidível dos dados presentes e desce para o
		tipo — born-reject em compile-time, não convenção de processo. P0 governa
		a forma: o admission CONSOME a localização canônica da trust semantics em
		vez de recriá-la — é a primeira prova de uso da centralização de C3a, e o
		detector R1/R2/R3 (que barraria a cópia) saiu verde com o segundo
		consumidor declarado. P10: quem rejeita é cue vet -c, determinístico;
		nenhum juízo estocástico. P12: a regra nova entra enforçada — a suite de
		admission cai no discovery do required check cue-validate no mesmo commit
		(mesmo caminho blocking do ContractGate, sem wiring novo).

		Trade-offs. N1 aceito e declarado (item 9): contrato antes de executor é
		a ordem correta — o executor operacional depende do veredito da
		governança de tarefas (trilha M-176/M-179), e criar um segundo lugar de
		decisão de admissão AGORA competiria com o Linear em vez de servi-lo. N2
		aceito: coerência sintática é o que templateRef (string) permite hoje.
		N3 é cosmético e herdado da granularidade por arquivo já decidida.

		Metadata. reversibility high: remover o join e o campo opcional desfaz a
		decisão sem perda (nada persistido, nenhum contrato público, zero
		instâncias de template editadas). blastRadius cross-artifact: dois
		schemas tocados (#TaskTemplate evoluído, task-spec-v2 ganha o join) —
		"local" falharia tq-adr-02 pela taxonomia, como em adr-191.
		"""
}
